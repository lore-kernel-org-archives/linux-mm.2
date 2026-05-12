Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFBCBCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 23:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC20D6B0005; Tue, 12 May 2026 19:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72C86B008A; Tue, 12 May 2026 19:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62476B008C; Tue, 12 May 2026 19:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B53586B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:42:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3ED621A04A1
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:42:59 +0000 (UTC)
X-FDA: 84760395678.08.DC43903
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 38363C000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:42:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wKWO/vcJ";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of fmayle@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=fmayle@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778629377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h0VhtExHawMft8issPpgsUtVwnBbQo6CTp5v0nrHBV4=;
	b=8epE50kvgLiJ+vxE25d+ucKhyCIJhvvhn/ev8C/WpaZ4LlDafa9ls7A6OKkFeQwFpkYG+e
	kUkTg3ag4Nx1h8TVh2NDLb//aEc9O4YZ1SrPLhrgmcyx+4Ao4ZIe+Jg+Hx7mUElyz7NwfI
	yoJHVLUjmkboxVdq62OzhNTHZY3w7Sc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778629377; a=rsa-sha256;
	cv=pass;
	b=7jBDhPldU4poD8++7soMBDPbsTP+/ec8kqGEft99T8pV0USZL1i9In6BuoTdxNeTcMJ3Nb
	Ae03ydta+E0iPXWrHHWBqD9aSzVzyCwJhxohqcTWq4kGpfkW4ho2tYWl4EQtEgyiYv1I+8
	A8eA93EWT+Zfov17HTgb49Mj4cbHpmo=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wKWO/vcJ";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of fmayle@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=fmayle@google.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-132cccd3d77so52c88.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 16:42:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778629376; cv=none;
        d=google.com; s=arc-20240605;
        b=HGaZxjcwyqFyhbTWzZX4/r7KCKYeIojpPxzmALAQjOGx0uxfEKQxM5d5aD1jHm6IOM
         HQPLxqeJYYs5ow/JQFRLXm23pG8AdjqUCO+m8p83us0WAkaY/3JDNj/EuQBrBtBp/GyJ
         Ci56T1VmoLmWCjMx9OLzkztvbIhoXZkmJdcYsuAeLuEKnrSw16ey0cwTLvNODKHuAQAz
         X5DGFSMwGbElMm9ZpAVB3sBMGD3NGmxK8t/P/h7wqlZqWUy2HiC5zwSfYq/FV23XcJmP
         9dQ2NZ64a2t0wrsH9pl1A2AhaGwIpUTQipJi43AqAVY+uOq4/iKiXSTLhbv/8xZqBD+z
         CEkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h0VhtExHawMft8issPpgsUtVwnBbQo6CTp5v0nrHBV4=;
        fh=nXdR17XKGD/R9VzCLjnbBZbqRsgFydyTXsvu2NhwnCA=;
        b=P5rHb3H26TBjPwYGd+mv6tp8L5Gs0mgWpiRZUmRthgY5LGwD/QUSPpeuWi+EFMuPl0
         3kE927WRhhcJ4ZptWu5JxZIT86wi+IXi/9+kAAg3mbukYOMSXyk+3eE+DmQ2EMNabHoa
         ChKQxnAcQRX3A9scYXbf6ePMAIIj8JvUEnP15bWQcak3jvzCA1gSIrPUIzqRtPgOEaRZ
         pDwyOAkcfXKkFwD4ZQ6L6SiqJVEYJyF28BccndGDWGzTf21P/L4egUyUS/CfaPo2ls7O
         lioACRC9juVyp7o0UDuc8jVhgfhlKAfnClOxCocK6RKsudhXqv3tHP/7blxZ2rhUYXVT
         D5jQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778629376; x=1779234176; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h0VhtExHawMft8issPpgsUtVwnBbQo6CTp5v0nrHBV4=;
        b=wKWO/vcJG3vL5GdCh4tL12ztVpMbA4m38ye7eCR9XpjVoQ5DuZkrmDUax2iT4y0lD3
         upWx4xkv98pKsmlbKL2hSgT0hJJ/gRJbuQBvnDX+LBZFjEkOmxwDPZk2fHnaZxWYOmwO
         fhcCljthLxaGV0AlkmoOiLlEhfwwYxqKrugT+RUhXJvs4qq0xFpkrpUWeC/z+EbsxAKN
         fVPRxzvqNsFm30jN70NPGhvJMMr83JlTTLhoS7fFKiVIm2Q56zQseTsmlE/XYCsjUS+Y
         gpl3eFTvA1s5j18lCm/dKp1N2BeWe8L/SKUHPNsmct267uU4e5AVyOqSWumtwSMW+IOQ
         w6hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778629376; x=1779234176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h0VhtExHawMft8issPpgsUtVwnBbQo6CTp5v0nrHBV4=;
        b=T2ofl/TFhXF3fakNAM4XQY8JJMfJFrBlqoIZpS2/BrKWTljQbGll7hfIxNAviHAxwV
         HdggyByLJQ9GJtJN23PKn91Cm/1QX7YC19ouLn243r4eAY0wn9IUpewQ7W9Vl8KRmu9P
         PmW1iHfPT2zm+lMrhiEX80OFCHpk9EBustbCcrxGFZ4mnaFcqnLCN5mbOP4dm93HxkiG
         J+DfU9mFgjkpnLk+2TxeBPVya+zjPfUXtcewOXO7yduwxkQa/UBhBt5c9mTYC8Z1/AW5
         FY4VIl1y1JwWVsZDyEC4VZi2ANlEt9l/kquh3x/REc0eWHl8iEJDR4mYS+fJGQLVQL3K
         oHrg==
X-Forwarded-Encrypted: i=1; AFNElJ9YmSxKVKEFs48BxWt2yp+/gscYmb/1hm/Gsu/A3ld+xKrBKhNMkZ4CichiZzVRnyqBIaBFygjjyA==@kvack.org
X-Gm-Message-State: AOJu0YzlvLiR1I8J7aMuKp+Y9IQivLvtxi5fieWduvu3ZFPnPevDAxdd
	qBHRSlgdAnh+DJ7GSL6MwjOApG7ysVqVX5kbo4xEY0r/fxi4au4/DMM8ThHBQOwGMFcE+vzlZLV
	bIetjQ7SGe3P1Iu8iOKY9XaMFmfPaSFU1apxhCaXx
X-Gm-Gg: Acq92OFyadR5ABSmOJWOt1e2jDA1jCJEN92EH2obLgrDicjDiofkUQ+HRqjwLY+hI38
	CwF4c2g8iTSbcbw/3YPXKz21s2dzYoJI+u3XLDpp9YsNtW2ZmxlE4GbAkePQ4XRZfJJO9GWzVLS
	Z01uUmb5UkEyrqV7XqGbJ3f96IQXeG8l5EDgZ+krKMuZghFvvTASbo90MnEHvLhxs6QllqiV9EK
	1Xfcoq0aT6zu6J7JIg74R7ZFrIaWvXjniJo6iU+tuaJ/bNbay4arvDJRhRfZ9MiYcj7V/B0zMz8
	GwB1Q73npLTY5DLVW8gRHuZYCXAsLeCWGgp6RGGK7LufECDTQBLI
X-Received: by 2002:a05:7022:518:b0:12c:6da8:860a with SMTP id
 a92af1059eb24-13401ba55a2mr137632c88.4.1778629375192; Tue, 12 May 2026
 16:42:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260508181237.670645-1-fmayle@google.com> <20260508165345.b40a73da1dbb45a95c55c0c1@linux-foundation.org>
In-Reply-To: <20260508165345.b40a73da1dbb45a95c55c0c1@linux-foundation.org>
From: Frederick Mayle <fmayle@google.com>
Date: Tue, 12 May 2026 16:42:43 -0700
X-Gm-Features: AVHnY4LWamnVNGFRDJjhOv7_S40CzCBIVjve0YhhnkS5TzJunUzhut_qzqGWO8I
Message-ID: <CAHCxdc60iR5-vDwOp+1FfYsXPX-BbiZxEkwu+QoV0tcAHXWG=w@mail.gmail.com>
Subject: Re: [PATCH] mm/readahead: no PG_readahead on EOF
To: Andrew Morton <akpm@linux-foundation.org>
Cc: android-mm@google.com, kernel-team@android.com, 
	Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 38363C000B
X-Stat-Signature: 4sgffixfpir8d8jw59ok4nqkc9y5g1xk
X-Rspam-User: 
X-HE-Tag: 1778629376-135193
X-HE-Meta: U2FsdGVkX19kujAFsiuhGohCjQzfs/keN5K/3H11kZFE+0z2gfcPXTSkM82mVsfC3EGxVlmrrSfhSSUGWIafNCB94L9Nt9ssRgRw3Z+sVXpzbscMWeLlEOn+MNEBHtTe7LSZ7yXBLsdmd5QCq5w1xxVaHzPXzx7KwWCkIskfavBgVMssYgheci4ShbGsKH/p8k2kwzKRLvd0F5glHKhOcstjqjLL8uTcSGFs8IyTZ7igpqvvGj49j/5aRLSvbtYCT9gxI1JSw1xcNSQI9GeU5UcJyeN6l4C9KpQbqLz+NYVg35riXAC5t+kWu0ytxDynE2nWnYgACUssfMeijaBdYYlHCeuGGDsmm38WiutkbzWCG+C1qcZmd6Q1YUgv4KYKz6ArLYI4sVHxHaalhlwbjh7lCMISC4hTi3uBsbYiXnh1//6CZ+xcbqTb8EZlp0+GnQvc5E82okilm0I7hV4F1iNKviLLpvHxtACOYu8PQy/KhSVVt0eoaTPotj2CtkKEUCWRLF7rdS4/pkxz9liCqWl6zh9Y86ihBwj0RqujlxwkvT3t6Xo/HaVYCiV9TjuE4HxSHvS90e/nonxWRA+sKttT6v3I0slXXfSojaPal5tgDZvevjVOH0WCqV4l/onT+vurF7YQfrDSQkRIClzG3cPY+YpMJ1HC5jLI5idZeCeP40BivPxz/oEAIGJ0+nRFYP86s+FnIuTArsDT/4JM/t1+gV8vs8OtsbJSBr63C4/pKzQDvqOhdf7nlJKvyxY2RS6Sqk85UEC/Dwg0R6k1xjWzDDHi1Rmb/14ivocf7893hrHiin3dMh+XnxM/QS+BhglfYd/Xthutz3XDXGwuzHcqXi4MpPiVfkEQU6DDarKnkbYiQnqwCWe/kRe3C3YLsLj31h6Bfmr0ds2Xji+TdsPte6cIxcHvlBoLZQApl7uaTc31/F0CXlhaAmRYyhlZZjtgA9CN0yeJk/x3A5d
 MST+4eTk
 9FR9DFWlQrFprDmX2QC3ogEPcDKVKVFvGXXPoec/2d5irVmiPhFqINouINLF219xfQTUYQEetjNHDDSbmZelC3Mmq/ePU7CTT6cnehm9NMGa5n22KJjLzADl+fYfgJj9BFyHEOPp+VKdMxZWsJbMcGm+kRXD4TRXtOGk0AVLdbp5fetlf+eEUGIwnRlJwejZCe84Aal+82hyQpVpkuGe4hu+uF6HaeUYc2P5DNJBubIo3Di/f0p+ge2qM0rJoZSlQROxQi5RXaE/FU6NxK/noe7DiaI/cMQ2f2oczQJK/YmlGJ3PdmN5baRSVNMM9hyaLQnaNDZUa3n3foADF1gQgPGe236eN+pf0y1zWtJ5pcS/evtYDlQVfQjdQVwY/VOKdTyjPzN64M8eMp9B94F7AhPdGeG/yCfAwE3mn15a3IrFOmAcI7jssKZz7E4BmxDE0qtwkvQxrmSqYc0zCRO7rODHqiLBwufWos4Lds+xm1Td55Mebab/5qlE1VmGOAeyS0d9vY7UAjYhDf9PAFTSB5xO7hHjJpfkdlGqWl9FycmMyDcy06rye9oIeZ8RMvB6xRDIXe1yNB8MpX/l2eo+IYbPnwXZlBw7LRGMtyYQQRNbJgDE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 8, 2026 at 4:53=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Fri,  8 May 2026 11:12:31 -0700 Frederick Mayle <fmayle@google.com> wr=
ote:
>
> > When readahead pulls in all the remaining pages for a file, setting the
> > readahead bit is counter productive. The async readahead it would
> > trigger would almost certainly be a no-op. Additionally, for mmap'd fil=
e
> > IO, the readahead bit limits the fault around [0],
>
> There is no "[0]".

Sorry, that should be "[1]".

>
> > causing an extra
> > minor fault when the page is accessed.
> >
> > This was discovered when looking at /sys/kernel/tracing/events/readahea=
d
> > traces for a simple program. With the patch applied, fewer
> > page_cache_ra_unbounded calls are observed.
> >
> > [1] do_fault_around calls filemap_map_pages, which finds eligible pages
> >     by calling next_uptodate_folio [2]. next_uptodate_folio skips pages
> >     with PG_readahead set [3].
> >
> > Link: https://github.com/torvalds/linux/blob/v7.0/mm/filemap.c#L3921-L3=
939 [2]
> > Link: https://github.com/torvalds/linux/blob/v7.0/mm/filemap.c#L3721-L3=
722 [3]
> > Cc: Kalesh Singh <kaleshsingh@google.com>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Frederick Mayle <fmayle@google.com>
>
> AI review found a little race:
>         https://sashiko.dev/#/patchset/20260508181237.670645-1-fmayle@goo=
gle.com

Tricky. My understanding is that previous code technically has the same iss=
ue
sashiko is pointing out. An expression like `min(limit, index + ra->size - =
1)`
only mentions the field once but the compiler or hardware can still decide =
to
perform multiple loads from the field's address, resulting in incoherent
results.

I see from past discussions that the lack of locking is intentional for
file_ra_state fields and also there has been pushback against requiring
READ_ONCE and WRITE_ONCE for accesses, for example in the following recent
thread:

    https://lore.kernel.org/r/2xzc3lp6ehtjwbzip4i5muh4g6oep4l72zh3j6sablfgh=
bvbau@kh7famgorzrh/

There is another one of these just below (copied here) that can result in a=
n
underflow if ra->size gets smaller after the condition is checked. Looks to=
 be
benign right now because do_page_cache_ra puts a limit on the param.

        if (ra->size > index - start)
                do_page_cache_ra(ractl, ra->size - (index - start),
                                 ra->async_size);

I think a fully correct solution requires READ_ONCE, but, in the meantime, =
I
can make it less wrong by reading ra->size into a variable and reusing that
variable through the function (+ re-reading before the fallback branch).

