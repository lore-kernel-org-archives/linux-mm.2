Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E16410F286A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 20:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FD546B008C; Fri, 27 Mar 2026 16:12:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ADA96B0095; Fri, 27 Mar 2026 16:12:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69C1F6B0096; Fri, 27 Mar 2026 16:12:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 53E4A6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:12:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D06B01A12A3
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:12:44 +0000 (UTC)
X-FDA: 84592941048.13.F1FF14E
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id ACDB3C0005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:12:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jgyq8yDZ;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774642362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uU2Z1aCep1i3LdlSfO3cr3DMGQ8MLAEb2T5//jGmbqw=;
	b=JwLLlVQp6EnPbXaQjzQIgKyleVWUJ8HjxAI8GaqDAOOx+HWJhhfMsGdCjtgxMhn7h4Fnsq
	6EvVlqmYnz65aVeq9df62NTAP3vO4uNMrCc8hGYE66nVUh3FmfVXdjplEs4V19nq6qeKfx
	j9AAeOb+0LeNhUkwQ0f1c2t8jQ2UdCw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jgyq8yDZ;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774642362; a=rsa-sha256;
	cv=pass;
	b=408ZiqHxyXzOV+SwQvaUmJM/wKf5BDpb1Sf16gvoDipAH/9OBQOuBkFwg3A1nIdghB/Pjr
	XBBEAz4CJVvqQieR7zHp/oQySlwcim4lE5TurjcZvTThTqzOrWLUgy1NtZCwT5LeMUXr/h
	LA4pif+vK+SejvecbgHpfF4CpVTlD58=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50b6c45781aso138131cf.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:12:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774642362; cv=none;
        d=google.com; s=arc-20240605;
        b=KycoCUnBvPFbhR2tTPv+6PKBAVUdphstBU6uJGCJjp0e+mrhxOxttJL3lu/ep8G7/J
         QBPYx0ex2PFH9nuh7R85lgALosm7f1Rp5cS0jCvRYeU2dCS7w/lwOLNwNRy92OGcj04J
         tI7iyuq/yY9RQkyNtZB+a9RU+0GMF+Y112S9tgGwcC+kIWwmM/nZ+PBw7oI5NWRZS3NV
         EDk3e9fxFz/WQeIyRantF0I4iH1uuZmPlLbGZMqSxyTgIzJ/H05EjL9C1UkKy6av8NM7
         lE3wnnG7XQVQlO3mJzcrcpCZ6B7reYlYPM3BSozbWprleXtmcHGyPHxll3by25+BzpdB
         2JOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uU2Z1aCep1i3LdlSfO3cr3DMGQ8MLAEb2T5//jGmbqw=;
        fh=zGgM4lrraBzEsqwsdN7asfjj85F9cJ42y69zc6m7L3c=;
        b=KLdbit4em83iBvNKjWhpXnSF7ueT4anD9XujTHDptHb+CJe5E1okYlMUlGNSRC+u3z
         wDpmRM77KsF0YC7lIqC21YHT6w/tkn/1M5eUn1xyrWOApF5nCRjmipXeFeZeJswCxsxY
         W7LJ5RwDYivH4mPy03/nZtNu1SI+BlbL7DpcxP+LkvzgSHlXJOiKZJT5YACrWvKDqYiQ
         kDZQjLiKf7TAIH2FNs2qwcIpIdL3LB6UdMBs835MMmdEoXzTx5x2gcqVj1P45GVzpFmO
         5zEnb4zX/2yp8vppWXi4PS+uwKNg1XEEXGFKZdTWNw0Hx9hgBG1vjKw2FZHdhg8uFjd/
         g1RA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774642362; x=1775247162; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uU2Z1aCep1i3LdlSfO3cr3DMGQ8MLAEb2T5//jGmbqw=;
        b=jgyq8yDZXTIUb+kWr9WqucgZCXwVjZMNXHpt2sH50bYiDuRotbMV1oQClGvlhGLi7O
         /LnNiDzafz2s8itHJN6EdG0Z6y3cYmpglB5F/0egWcUfWlMHL35NqaOPmLLPW9jUW6YK
         OQGsd8kxpew0+elf9GNVtsnaLl1wOupXSOZEwfathX2d9IdRfICvtR9EeU3A4PnZiOKu
         54X21Vr8DtppNoDHI7Lb5S6AOInVbWynBsUXP38XWATjVTqiiG1Acb8CedYFwS2/0ng6
         h6Ps6/tQphioAZSwDImbK9859od2EBFSPpr82wWXzruOjP5O2i+xYW8BZOkoRCDfZkdS
         CzlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774642362; x=1775247162;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uU2Z1aCep1i3LdlSfO3cr3DMGQ8MLAEb2T5//jGmbqw=;
        b=M5VLNRLdwMmuE6O+Uhp3z6Hg67POQGaCQe3FGxkKorMSJEY57T3QLdiAGuWc4/+MeW
         guq2bbbs749VkMeJxY8+Vr2D2uOZSSJUHDW8LnI8Ck/KNY9aAJ7wfhODTN74jSwG1ojR
         Rq5Of1BOLu2BAfbpN6RVRLL4i9iEnfZ0sUMK83qkIxR8HVOzLi5nKy4cCuNsyLdw8Ghk
         T9sbx+VeewGk+1YZ5ilJNV6VhjOIqTLnUw5giLowT6KAst0IbVHYctDkhXDH+5WzeN9c
         8DiT0c0bbbT3Sk/FIWefauDaIr8+np95mO6+5CpblcsP5mTQck0zGtTFHCXoqTvr1Q4z
         +A9Q==
X-Forwarded-Encrypted: i=1; AJvYcCV0kcPv+1VIaAn1HQEwM9lDNUwnZwAZEfGoHOIxqqhdInot5oA/KyDaJWaWeZXxdqo4nCx2IkL/hw==@kvack.org
X-Gm-Message-State: AOJu0YzbV1sM6Skzt5TwQEF7Si5hLDTvj+WyGnGiCzfWs9bKL5uYDSBe
	Ed5mQZ4q6xxLBkryDF32k/Yk/UTHC+37aNXci3CTR4bJcX/WhTRc2TvnsCojpQhjhw9q+Rd7tUE
	R3SYxnII/uVj3qGjfpHp6b8Nj8ivTRQuDix3CPfYy
X-Gm-Gg: ATEYQzy3vEvv0/BWge1sETlnSOMJo86yxWpKghyTamaK9GaPU1rbLGdk5GsRxYQe+Zt
	lvslPaz6EYaAF1D4eWYZByunDxpqJQVAJI3I767fnuJqvKQPMSpVm637ls+XxseFSWyVUBTUI7K
	ZP2c/qWV10wlYYr5XEgj9ZJM8m5mDCd9ceXPNkTu4j8or+EA5LSYpQWghBNocNIwbXBxElT8au8
	qj9oEG9aYhI91BTJ3NEHZvxL2k1me8FhTeqSbIAjHnp23LTVl8X3YwBc6shg1lz+r0y3Oh0yGA8
	t1nFInShydvgNXuZWrHlDYecj9CLVFrMMwE5h3kxt9N6Aks=
X-Received: by 2002:a05:622a:5905:b0:509:174d:3224 with SMTP id
 d75a77b69052e-50bb3d746d3mr261681cf.11.1774642361119; Fri, 27 Mar 2026
 13:12:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260322070843.941997-1-surenb@google.com> <f22cb9d9-7fc8-4a79-ada8-02d66a1155b2@lucifer.local>
 <CAJuCfpFqz3OvOrJOnYG8NF0gjzkzmSaiM0LZKD_aLoW9Br2srA@mail.gmail.com>
 <0f599835-9b99-4457-9ba7-a3eaeb0768d1@lucifer.local> <CAJuCfpFrQQDipONQN-ie-tWVNx7m_=jxyqsh0gGD9CE7HN7RLA@mail.gmail.com>
 <20260327125314.98f1087225ee48d4feb97345@linux-foundation.org>
In-Reply-To: <20260327125314.98f1087225ee48d4feb97345@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 27 Mar 2026 13:12:29 -0700
X-Gm-Features: AQROBzASPTaLyVjM9MinRGYqFaZfiU267OUtOCT9GhVHhSVDOES2aRI5iB-Ton4
Message-ID: <CAJuCfpEk7MUA9SsNWw_-7542_vD3W_viQVJt8uku=yqZ0=DekQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/vmscan: prevent MGLRU reclaim from pinning address space
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, 
	zhengqi.arch@bytedance.com, yuzhao@google.com, shakeel.butt@linux.dev, 
	willy@infradead.org, Liam.Howlett@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ACDB3C0005
X-Stat-Signature: ht76kiyeae4tfraage63w1gsojitnud5
X-Rspam-User: 
X-HE-Tag: 1774642362-585655
X-HE-Meta: U2FsdGVkX1+6TfOBCqJG7htrl/vp4+UxWpUWJ2nqSrIw46kJ+uumisVr8QKKv35yj7t/kj/u+JZT1R+kApuGWjpraQjt9pMqVdb1lBPbWOgAmcXn4gEF5lRhNzbB6xkf5paGLDQQNzA5CMuOeLYReiO+OBbzczi09hfz7lT8USMJB9JKGE17dDY0LZGCJ+ajjEdIkODxW2alV9vc7JjfgiNuJp9svxTP9v3f5r7AOntBcRNJzAXtpTKmfG0rv4F7x2Yzaiy0mGD+R6llIW/3UsCIwRlRt/wshjpR3N9eKzF4D7/6LZ9IVic+zcjotYZQkPJ0cPF/wobbqu7m78Lhm5O5ZqIao285V+C1ZckEtYuqzYBSO+gExDkkiZJLkGKx2FKa90VRRjqVXVDwpThwYJWBKuKUNnPv73j+5AHyMg6yzW0X86y0U2HXoDJTnJzNXBYs+GfxklTseUtCHJhyn7cP4Yv/Uld33A41rk0lKvaDrtlZGONhdgDNHtiw6Tk3fu2vWASH2edRZsf6hxWz4ojAm/8M0c5whxgDN8yngZR/AMLu7QQEQAA/LIdj+J83P70i9uxrbvdNNJ8yRevEHDNqXqBB0hZjfTIWaV8RezhmBSgORlVd/2SCDV9ybu7rhKtk4a0I9pw3MbKCcj/UwKS6TKH/8WvcZ+iILtSQKzDcXZ8dJNpHBq+8gU+sezE0TiYCRshEtoD7gJiNQjxjCADTVhc+5XlC73eEz93TgMM662se+Lw/3Qe/qeFlc6xL+Ht9YKropqdg31iTO8IpZ+oshfK2Fg6rqoZS2+XjhR8h2Tx7bQ7rqZrXnRYCPn0lDLZrv70UNdHeWsit2N2lvq4OaLncCpRcC/ltMyBkg9RyOJrtcpbm7htR4fz1mmJgcKLh1JgVj6XcFgKq3xADp2mA3T9R12Yqhxt4lHjh21+yQuOAE0T45ZHdp4r7o3GUslX1IEWyPcdLVeAoXxz
 go4EVkj1
 iuwIYrINK/emxWW6ZO+LiVQpXlN48NDy3uuwHVZPC0fpOx7/MARjH3ycYENg63OTNPdUt7BktSWt8Z1n9Blxzhxh1oWwf+JpXHvc87Y/PVLRkYTraRsgFdY6Fp+uN6gpv20KmMhO+Myj4X1DPmTxhznavY6KxBLKsb7KwNN2GLVuJeNE88AgQ1SOkWFTlvReinjxLCb2aPHGCPx+WCSsIBWWf+kH09Od0QkMhUG4H4yXa+VdEZYUhqTM5DTl6ZzvDiWQzmWlTe8lf3izMxTP/xTYP2T/KGQNNlmTV3XD/xz9sxXb0nZxw+rd1OSeXMyJXpmv9IQTb+FkqPFsEjs/E7/mGnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 12:53=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Fri, 27 Mar 2026 08:20:06 -0700 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > > Given you have cleared up my concerns, this LGTM, so:
> > >
> > > Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> >
> > Hi Andrew,
> > Any concerns about this patch or do you want someone maintaining MGLRU
> > to Ack it before pulling into your tree?
>
> That would of course be welcome.  But Suren+Lorenzo is more than
> enough for me.
>
> > The change is quite simple and I explain in my reply why it's safe,
> > Sashiko seems to like it and I extensively tested it on Android.
> > Please let me know if anything else is needed.
>
> I think that if the fix is valuable enough for Android to backport then
> we at least should have the Fixes: there to help others who are using
> MGLRU on older kernels.  (We don't have an "Improves:"!) And if it's a
> really big improvement then we could even pretend it's a bugfix and
> sneak it into -stable ;)
>
> But the changelog doesn't say much at all about how this change affects
> users.  Just "delays".  So can you please expand on this (numbers are
> always nice) and I can paste that into the changelog.

It affects the system in the sense that if the MM of the killed
process is being reclaimed by kswapd then reapers won't be able to
reap it. Even the process itself (which might have higher-priority
than kswapd) will not free its memory until kswapd drops the last
reference. IOW, we delay freeing the memory because kswapd is
reclaiming it. In Android the visible result for us is that
process_mrelease() (userspace reaper) skips MM in such cases and we
see process memory not released for an unusually long time (secs).

>
> Thanks.

