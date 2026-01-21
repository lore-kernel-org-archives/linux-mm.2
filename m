Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84BBFD46951
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEB946B00C6; Wed, 21 Jan 2026 11:57:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78796B00C7; Wed, 21 Jan 2026 11:57:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26446B00C8; Wed, 21 Jan 2026 11:57:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E2C26B00C6
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:31 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4AE47BB6AF
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:31 +0000 (UTC)
X-FDA: 84356577102.06.A1C6DA5
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id 697D44000C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=q4O9IG3R;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DzJlvh2XyLMGkwtl0QberzuQSLWoZAkg3qQo6w3w0Bo=;
	b=tR2hrz7MmfJh8+1wvpXezy1tRtFwEGQYN/PLxH5a1Vv6ClLhC37c0hF2jjfl7Fg+tVSRad
	uAD+MVbAKN9Nh8vd88bTMKC+ZyVu6oeHttWUY38ZgREcGmUBtNvtVn//oTSq2gbgEq5a+k
	rYghjQrRugPXVV4WPZFFZqW5F05+YNs=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=q4O9IG3R;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014649; a=rsa-sha256;
	cv=pass;
	b=uTdVvL+8vcePOo4wIYHEobNOjVzdMvig+2OeqQBitb/L7kRERxrs4r8uxZDUx6AJGzLMz5
	ru6Fqsnq7FSME25WfZOSkm0kJTo8qkynSzPGGUL85/+Xrp1pQ2nTZaVuM/woKDp4vCSIBY
	r4wNPls7DjuuDKf03KaLkU6sMePotOc=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50299648ae9so547921cf.1
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:57:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769014648; cv=none;
        d=google.com; s=arc-20240605;
        b=Ls10TJaauLgsfO4oyxAR8ifzNfn/rO43BgaRE2HeI9ozjxPeVzf58/VCPD0I9lbn+T
         kwLLXsv/nOflCUfs06JikWbdg68abNMBzzJmN12bxv677D/RLzQOuHRyoolkzVt3Zoq9
         OnG9IwaoQrcK8ZzSC5L0Mjb9BPNo8GI8pzXS1kpA/yOuvb+F/ceWNGtXg740R3PKd1Kr
         GVQ+IAYxR5d/6I9BdMzw4BdyWXKy61oKNiFbNUnrX5Anw0T8EbJ22dB3NbvbkBZrEfRE
         2T3gj8pX0pZnfaXM5khgO7Y35iAJrF69KLv08bAkdQJIFzL3v0WCT1hbJLzX/JNMXbxj
         W/zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DzJlvh2XyLMGkwtl0QberzuQSLWoZAkg3qQo6w3w0Bo=;
        fh=eWx+uCnvjwuQkHleThgZGcXjxlZPh2IHTxRWIQJcI0Q=;
        b=kBml4GVVFDKNM/Iu009iJRQCzXj9kGViudq88TigsxVAveC1m/EAu2rbYn5qmhjemq
         r9GPR8uoPdggkEpVnmR8jZ3Jh0C3D6JzJ9qAc1F380W2T0PD6QWZ/dzKnRrjW8CDgt1m
         H+scFxOrJsw9n8UArKjnlMZN6yoExebxRhJLafzDzP9F8aXEDWcpUDqt6B4o267aAV8m
         9F/KTCofskDLgr2RbUL4CoiDpX4LAAlJrNZjZ7ha63h79ODEwMcR5eMmY6ufr2JC+aR7
         gdyfHg/Cz1VygaiRGu/rWPPx/B9xaHOJn9YFLKErrrgJ40g4iuY6FJBvGxWa4vEUx8Yw
         2tkQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769014648; x=1769619448; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DzJlvh2XyLMGkwtl0QberzuQSLWoZAkg3qQo6w3w0Bo=;
        b=q4O9IG3RzdynJfQNMpSeFE679MQ3FxngJaDNVDGpD2bTP/PyT0c9MoFlpI7jC+AScG
         thkvjk7QbmjDP0nN3qio/2MsvGX0YmNHFAY1N0OH2y3Ln/SbxtdgkB37q86A2qUtwckg
         OMRJVF1OUbCYGKFtmr1rhdufiKXJMimJyioI+C4v5A8UjzcS1Oi2v5oFLD5PmHoPHhJa
         Exg3rZ9HX7814RLrkFzPMEczsxyI3IfYuU48BGAHxbLv7WWW0nAHPkAD88zUTp1EKsvL
         GS1rMhc8lifWxPuBxATA/r1fnUNYd3eaeJMVvQJFuo0rpCWWy7bvtrnMDQoMQ7UVssSG
         Utow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769014648; x=1769619448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DzJlvh2XyLMGkwtl0QberzuQSLWoZAkg3qQo6w3w0Bo=;
        b=ortMFTPmi+5hDEWmdinNSpJl5i3id8NH7b3NO0YEAtKNcPM2eyrP2Ao6/QyziQ5bbB
         yEv7tMo8KrGq1l2BEGYmiBjkJUhNOWUd66m6LoZL4sNqVZgTdFFcYMov8V9nY2qYdMQc
         kvW3veoCWFyRQUtwpwu7uJjXHhveCkAfOpWIyePh+XlRNalyAc8ZOktvtMvbsf1un5d0
         jDDd9B/Fnlz8K3LhqxGv3ri+3uE2VCmJZaXty9Q+RXQ1kG4/JR+r99EkUxWQ3Zqx4vLb
         wvCYrApXHiXrLp3JW4wxY8kiEOC/Jv4X/BgoDszMSzh/z7mFN51UuCY70sDeo6nlBDv2
         mS/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXc1KxWg2BIDxpFgVtWC1Cd+F2jIL+s75WKpTdG0HtR84TtpQKz602k1kutbCICpOsPBWreubw7kQ==@kvack.org
X-Gm-Message-State: AOJu0Yyz1wzsoT80+XWZGyS+q3d/ORAaE3DcxyKJo3sdW45PZviQTcAs
	h8i2qlISc76nR4gvdAvq1vvkzJx+C3yZ+CjyZZWzv6rNj+iig+ZOLJ6gP2eZGrua+mw3pJMQA2O
	4qXJDlWLU+r11t1+dpep3kRumo/FX0A/Xivt1f/77
X-Gm-Gg: AZuq6aICGiy/2n6Y9sTvOQZLX4FV0vSuBPyT3LpXQpHna0VYXJu//MdTFqnV9uJGYA3
	nASaJdINpfrS8o1A/8WHUip6nirqaW750aLQYHJB2GtoWIACJbI28KywEGM8u6EkHXaQGpBQdIT
	a2D9a2U17v1Spq3zndbQtUeknKL1FYAlIrEzfO1w2kL5uUaUQnovWkBKuSGhX3F47Hx73OKh50O
	5+Q8cxrwKvpajRJpf4dfqZHgVTVfJ/6b4n62gIwmZh5AJkqBKqbwcwMl67VguISUqjovenHvnID
	ZvxPEgo6KIoYT910oFfcAK0=
X-Received: by 2002:ac8:584d:0:b0:4ff:c109:6a4 with SMTP id
 d75a77b69052e-502e0c0d426mr15219551cf.4.1769014648007; Wed, 21 Jan 2026
 08:57:28 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-12-5595cb000772@suse.cz> <yejhiw37av3o23z6s4oewlmhip3iqxxkkfcjp2jhlo4qf7nm23@hojkan5ym5cv>
In-Reply-To: <yejhiw37av3o23z6s4oewlmhip3iqxxkkfcjp2jhlo4qf7nm23@hojkan5ym5cv>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 21 Jan 2026 16:57:17 +0000
X-Gm-Features: AZwV_QgOY9Ovo2gtiQ4jhpdmFVjl8h8HKayG692yA7UEj4JquBoNIBa9LT-cydc
Message-ID: <CAJuCfpFaeYyzHirCYUPT0JDeavuq5UGqegW0OMata31XbYGnww@mail.gmail.com>
Subject: Re: [PATCH v3 12/21] slab: remove the do_slab_free() fastpath
To: Hao Li <hao.li@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	bpf@vger.kernel.org, kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 64k7u5z8uuy4aeraya51gdqgtbimh1wm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 697D44000C
X-HE-Tag: 1769014649-669227
X-HE-Meta: U2FsdGVkX1+8z5Hbsu+MDXOb7rM3NxKU/+2wl0phsyhsMl5qdRoSFto3iBqn5x/d/hlFfCccGzTAilT14DtvZN6V7bhk9MJB/tnClKmXla260zw6uwOCCSVLMQaPPF7OX7/qkArl7nR1JxIFAqlLJ0eoocwfjqBzC4eStrbG+7Vgw0VMFVDXqEW18EatqSQxvxojUN7KF4irOkiIY4w69o6Pscki4CjkO1yapNn7YyFDfOaH18OKpZcY4PEATl0hYLXzapiwSrsyR3wTUKCbFXxMTo4E14ZyPUtylwjBqJR+fW2C2VwYU8BlrZYEY5+61Z5F20kYpAk5J0s6slRJoJ1BJ5wRJs+/OM8GTtTzHcvu+1rKR+n0Mm6JifTKGSLmMjTlN8+A+TUVp+nuAy62gZikt9xBFo5IjBwTlK+JfODhQuiKLkSjwcaF8jwFb4G5UwDIX/Ou8GQR8ilrvayrS3LyEwP89EAzbnhr+RiQGYDFp5OD4AjxY3cg1lPX6r8Ky+qm6TSIV7RWwyw7OpJXPu0oINQo6MgNoWo0SkpCRnX1VCNADgz1ltnxeZFdUq5gPOkZE+IuAd9Y4EQJetLOTZbw+dCyHRBHtnz5MjStFm0DEHD0OwxKQDPhjppUNqnBPdn5cTX6llc23tp8n3Cno+rTgOxYmLJnXKcExdPy4h93fMBYl2gQMpHi5NWF8Bf/gTLv0uTKmIdOdETiKJq+xyJFj/aX0/XlJdh1qtEKsk7+gzUNPj+i7pr+nUEuJ1Jcj4uSUJQXTVxU+1BMXtrDwhfSobF5yu0fWRuwTrHExa0NMKaGtiyUQJlb7EGhpzCkr/5o45rSJ4H9BXXN8j62UsakfAlF3wy9PSMZ+mVpH9TJBQM8xXLRiqxJPxLQALyUeCIIgQdnfmh6cxbUxM2bR2OaxguGCtoVqTvW7+xu3kdVVbgy5HeA6TB8+awmLUuzh9g7Mpk7UE/MYzfp2ty
 e/UltFAf
 HUHtmp4qtrI+SNxn6bDQh7iCiyyy10CKgXi01
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 12:30=E2=80=AFPM Hao Li <hao.li@linux.dev> wrote:
>
> On Fri, Jan 16, 2026 at 03:40:32PM +0100, Vlastimil Babka wrote:
> > We have removed cpu slab usage from allocation paths. Now remove
> > do_slab_free() which was freeing objects to the cpu slab when
> > the object belonged to it. Instead call __slab_free() directly,
> > which was previously the fallback.
> >
> > This simplifies kfree_nolock() - when freeing to percpu sheaf
> > fails, we can call defer_free() directly.
> >
> > Also remove functions that became unused.
> >
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > ---
> >  mm/slub.c | 149 ++++++------------------------------------------------=
--------
> >  1 file changed, 13 insertions(+), 136 deletions(-)
> >
>
> Looks good to me.
> Reviewed-by: Hao Li <hao.li@linux.dev>

There are some hits in the comments on __update_cpu_freelist_fast and
do_slab_free but you remove them later. Nice cleanup!

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Thanks,
> Hao

