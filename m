Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CB2CEF48CC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 05:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4FB06B0089; Fri, 13 Feb 2026 00:19:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9A46B008A; Fri, 13 Feb 2026 00:19:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF4D6B008C; Fri, 13 Feb 2026 00:19:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A0CC06B0089
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 00:19:41 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19D2F140386
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 05:19:41 +0000 (UTC)
X-FDA: 84438280962.02.15242C4
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2539A40009
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 05:19:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hpDJ5XsH;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770959979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hcm5N/FNl39nu4tcKBsHTHKuYwpRADdhLeVO76g9J1Q=;
	b=hJeRTM5hVmHUjdejxSURiDeGnLpFmfUnotGSUYtJ6TMqAYuPqI4+q5k4da9B/E+cicPxpb
	l9RiDwwUlh79TI+FU8vw8CGhWqMvjr3obDvzhZ7WvThycH4rM/ubqN47S7R9Zg+Nqey4MJ
	65KSJ8Lr5ewhSHGaWPecKs/2eXmHt3Y=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hpDJ5XsH;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770959979; a=rsa-sha256;
	cv=pass;
	b=hbl85kJ05hdqHaWlgEmJMv+0RiFkvnxR3BCU+0qpRRAX+YcOKCejvwwcZKRfqv2G8Bz74a
	3u0KXRFMbcX8FGPdaM6XYWl8iBfdAqAfuLiXj78SQQ5c4QFMfekG7K0r2xq8P2eaywW3IX
	N4lErRrNOCbuq2VXt8MIGGpeYCmuwkU=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cb3fb47559so62672185a.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:19:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770959978; cv=none;
        d=google.com; s=arc-20240605;
        b=BVoLTSNYobFDqqR/u4qEdVPQo29TDAQ2Vce6I8AnQFQBo91uTsep78aEiA+qnVIiNw
         6SnIy8QFug9lejqTONpzkeuVZlGBofoHDvGSh682+Z/NeNDKq1olyk01ztzQknnh5f0U
         Oc+Mkas52g5dhA2I8frGE6LQPslxD+SDbH0kJ83yyFaxtr9mmxJGhwGRbOCXY53mYqRY
         XhBefCXQHX28cyRGUeTwcuHlPAtf3r5HnfGGPmTTP+gYfkFbo4+/TVUI+/icTPT3ReWw
         X/pvRGUwDdGEmLNIvyU7mQcDDHU3way6idth8IxhfJ4f2DRdSjtRXeRBbphykf6CL0Jx
         +fPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hcm5N/FNl39nu4tcKBsHTHKuYwpRADdhLeVO76g9J1Q=;
        fh=1roFhOHkhhMvUCtCUCIN/OOfmPA3QymppF1i7qOD1Ak=;
        b=V1nLxtIDlzDaOgvtNS3pm/hyYbdRMKLAou0LkyZIRKbhSEwQffxQZTHJ+bF1OGFaA2
         KgXyPvO120bbiK3kqbiq6pVZnUxL6UJo4Lk80+uOkzSyYkJHvvaCXvVUZcNDU12HiCeJ
         emNGh/XposqQUgQCqOshnzWW3Tz62WoChHFUDoqCaVC05XDH8s1Pptk41C49uV5PQeBl
         VxND90eNNn/DvXASNTQD0xQt5Ku3SIWIQYo7qg8LRnOE5Sr62SZ30qvxGYIfZnY1AZKz
         ERFJ09x82VUXzpxHtgvaQ8+rpFOmb6XkVHqPfTm7a/8FXZAjnG5HJaBR9faqEMsYd5GO
         l2QA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770959978; x=1771564778; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hcm5N/FNl39nu4tcKBsHTHKuYwpRADdhLeVO76g9J1Q=;
        b=hpDJ5XsHA9Mal2jM7TxleFykTEkUlrAQBVs+lTDvxOrtkMbiWA/tgYm+4l3a7ON0OO
         rrd0fFpth8hqOjNxQR8KWM6o6fZT9zpn2u6Jd/z4ESj64L+PcTgAAQ6/bVwBEkv89xX3
         AFSzYYQRZ2zpNVzMxA7AztgXH/tq+p7bdvZcDvhVylFt4AjWavDxdNOKfuzj3u/pGi60
         ll1kNCvhQl44IltJVOpElDJ7RYeAgNnP791S/gIcLVEHOIOnSY6neatfzSGNPQ4e8Qk4
         EYhsHdLIa7P4PudoUN2dZxfCJG7adcuQDBd/Ya5wdl6WjwjdveFvia0QpaqzLU/lkGTP
         /77A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770959978; x=1771564778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hcm5N/FNl39nu4tcKBsHTHKuYwpRADdhLeVO76g9J1Q=;
        b=bgWBHH4056qVy60CB+zB/th57jQ7smNUNx7XnwGH+Dn3cMminJ9oJKPzOqNiHhbdGt
         21JIOHNWbEa2bQfGjcqJeS2O+VXfHEXQxyIVFtJMtqJoObvCHsTijs6qTyuR3HCbqzBJ
         cotdAuLQ5a6c68uEZnoyt0mVzPbkPGodBx9NUSiBGcB0ZNn6f5X0UhGZ2k/RpW341kMY
         L4G5J8MczxJMVgIXE/XL/nsO9+j7DWiG+kFk/7PhKvitKV3gOLpZZxvAN7rvwzat3jC0
         a0QdGDjT5fsfhhlRO/GTyRehcfVMGZJKaQMjsb5dErXBaUuzVInwQzn7thFjpJmGu8aF
         GHaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJK4rf5K8hDOX1d7dTA0A1IlQDqPUUU1Wr7yyzJ3ziUT2zJEhzLPe7JpKGIyE/OdrYUz1oxMgaNw==@kvack.org
X-Gm-Message-State: AOJu0YxALCt8+2s5ZXMtvihrG+n3CQfN2/weDHobnv6aZzWl8TICH7c6
	j+tacp3Gik7+JbqI/6BMz/bKIFQpiJyz+Aq5BD+hNU74rXLh7nYXxj0mRHjy0wnddd+N6Shcmwr
	VMknRx1MpXUfNvfqqt4LisuurF/8fcFs=
X-Gm-Gg: AZuq6aIE+zuo2mfpATi8WpCxuYDgTue1xyVT2BylH94p11n1rGv8A83bhKBKsFDM9c9
	Khp7tYlhPj2sDCSyEkXvVjCXFpfMvZKhuXiakh1d2XrT77IBrF8KBdPg3fKdbxj/CUYRd3UJcNR
	qPBb8ENKnRQAebGwPJn1N9kmLn9ckE80G6qeT3QWVaAt+t3Gme0TmEHxAdZEoCZnVopKtu1CJ5P
	xnkDoJpvxAUcZVF44PXLnZNlaF1ruJxKQxahfMsJAirg8XnOrpxHwQr356xO6jW1q/VZXWHdGAH
	SeCMKg==
X-Received: by 2002:a05:620a:318a:b0:8c0:cbd8:20b0 with SMTP id
 af79cd13be357-8cb422bef85mr69698085a.34.1770959978020; Thu, 12 Feb 2026
 21:19:38 -0800 (PST)
MIME-Version: 1.0
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
 <46d0b6bf-db7e-418f-a497-983db4d4d786@kernel.org> <ddedb72a-d24f-48bc-88b2-f6f99f3d45ad@linux.alibaba.com>
In-Reply-To: <ddedb72a-d24f-48bc-88b2-f6f99f3d45ad@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 13 Feb 2026 13:19:26 +0800
X-Gm-Features: AZwV_QjOrB3mhYeaOWb88OQxVXS_adocoCi0wTeW_g2al2n0WylFx5HY55y2R0Y
Message-ID: <CAGsJ_4xqtksoCwjLp-7Kvg5=LyqH+=aGWDWi8jRp8J0c-QiSwA@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, dev.jain@arm.com, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: b65nt58tz97ydswdddknbt66cqsjtzsg
X-Rspamd-Queue-Id: 2539A40009
X-Rspam-User: 
X-HE-Tag: 1770959978-16916
X-HE-Meta: U2FsdGVkX1+r38XM/nYqHkzfs9WTljOMOvgpGlMpyQm1lzt3B/uUrYLbeeHEZgsXLIzBt152fvLsZ3cUVy8EmPAvzQtFM/33D0XXKFSW2AgSavaoqrGXz4PtxO34HCWNQQib35SJxwnP45clZwP3ZN1NVp409Zbx31+CMxg73GE98qgRlRQcmTpSJabwDL6n2WUDtzjp3Y7YoCKgMzdF+MFj2+zHEf3Xl+2tKxVGbgVIrd6HEivjEAMp0hDIUq99rncYigQsjIIDjDqpzwUW+tC1EfMdJsymSKwNpHZ4pWcbnZvI4aknETZQ8oOMi/AQ0hPaLPznxAr/rZHeB7eNWQu9Rr1Xnj60YFoDkKv7mk76cRM2GEpfquQDHk23d1EbpKLVmuDgodcOKGMGLFOpN4uR/b4lEJPQOGP9sb7cSPiOWD28ahnaNgdsbkB+g42O9RqYB6DOM5L074BbRzyGKrdHur2tiTax60BNj/ZU3zY10pbQm3yXf3yvm+rAbgm1BiDfoWCKrqhZ82eypjLZoEhofINsghXUM9eJE4jApwkmDt2mNRPVp4nr+oCuj1XtR0ah9ZvgZ0SEvIMVPQxnb3kdMpU8FN37rZaCZk6vxy2L5GXxbeDEMxkV/gR7JlQAT66dERQcFkGwRbGo3U9MVIGcv+RcXqsX596KGT38qV0Oi2p+XP1vIM2WyiVyWqZl2sfWGZDa7htk1g99mouX//HDEWW1GJn7le7RtsDNDmes+1yVtQPBqjBaYDR2va2MrK7UI/tW3VZC49mCoGgs7Fe8xUaSWALw8jAsyHyJgDvlo6G5b4vg31FcRbr/2qhWjocACCmpsqyq/8YqOtAgZpxy+zEaoGPMcQElKVju0ptX39w3KGHVZEzGxzXari68RGTdgJwOR5o/4UK6WmbHMFKyDl4ahvmgWp2u0itkOobqV0yQmxGqpFjB0GAsCujMdZJ95gdLvrvBb8HeL0I
 Rl45hItS
 KmCnEXBNqjZOXxuyoFvbb647QkfKTO50Yt9tsAc7rM5+6tazesdxs3oPAwME4zCtJ/G1jxuY6SnNTJIikVmwVdK/UWZNvBrz07eTLVbe9uigyhD2oTi0L8jys5kWBU7vS4N9Zg655YbUEK9syv43wu7k0pmgPMq8d/m6KeAG8S+soGL7S4A7oQCjmOjTCJNHlG95dionxrX8w2ukxdC5uRueCiDmmmh/rmvum4JVwHfChUIrFI1n5DoGFgDAT7nsr/suokJCaVowsKtD3/va+D0eiETDEFw4d3PU1xtOjGd9qEApm7KUSPK+oZIG/JGjRirnTTOFADKaSzF+IQorHqMJZT3K6afJGhOTv63J56p3kVPkKw+WPTnNaXuZ4J6Kv4qRRCaSEv9Hs+KlDk6lOggEC6uzVUO7tEOWGzazZoTMhuYE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 9, 2026 at 5:43=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
[...]
> >> ---
> >>   mm/rmap.c | 7 ++++---
> >>   1 file changed, 4 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/mm/rmap.c b/mm/rmap.c
> >> index 985ab0b085ba..e1d16003c514 100644
> >> --- a/mm/rmap.c
> >> +++ b/mm/rmap.c
> >> @@ -1863,9 +1863,10 @@ static inline unsigned int
> >> folio_unmap_pte_batch(struct folio *folio,
> >>       end_addr =3D pmd_addr_end(addr, vma->vm_end);
> >>       max_nr =3D (end_addr - addr) >> PAGE_SHIFT;
> >> -    /* We only support lazyfree batching for now ... */
> >> -    if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
> >> +    /* We only support lazyfree or file folios batching for now ... *=
/
> >> +    if (folio_test_anon(folio) && folio_test_swapbacked(folio))
> >>           return 1;
> >
> > Right, the anon folio handling would require a bit more work in the
> >
> >
> >      } else if (folio_test_anon(folio)) {
> >
> > branch.
> >
> > Do you intend to tackle that one as well?
>  >> I'll reply to the fixup.
>
> I'm not sure whether Barry has time to continue this work. If he does
> not, I can take over. Barry?

I expect to have some availability after April 1st.
In the meantime, please feel free to send along any patches
if you and Dev would like to move forward before then :-)

Best regards
Barry

