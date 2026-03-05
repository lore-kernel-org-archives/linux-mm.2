Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16F0DF3D338
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 17:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664966B0096; Thu,  5 Mar 2026 12:13:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63BC36B0099; Thu,  5 Mar 2026 12:13:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53AA26B009B; Thu,  5 Mar 2026 12:13:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 449766B0096
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:13:10 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 062E0160219
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 17:13:10 +0000 (UTC)
X-FDA: 84512654940.13.E584AB0
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1D8871C0008
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 17:13:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=i8y11gCQ;
	spf=pass (imf20.hostedemail.com: domain of stevensd@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772730788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3U1wJeEDhpO4CHVGDgYHkgbI6YxMM93rPh20DiYWuO0=;
	b=lCvlSbzsQ6linO/ykiAF63GMcHLV003kzoLuT5wzxuG0TknP6vsiodN6zWD3fqpy6YwvJ/
	XhloWR/HLCVBf7tsUyJohl9JXl2zXFW9G1AyypuLe+DqvtgENREEuxK03sPc5gLXZL/Cal
	m/KDRMqMyQK0SHSP2irGhQid7IYGdTM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772730788; a=rsa-sha256;
	cv=none;
	b=rFxhvhGW5WCaNPcLg/rFa3rgUsY2y4ly5GFk9TW/jbc9A8A16QENWHVTzuiZmwDTTSRN4C
	TvwNOZ9gW7xaZ+7By0Ue3FOra5QRhPswNxn8EfplNQaBbqYY3OEVLVzRnOe8om6/PkAGCZ
	nRX9ylDA9ou7s0uhnHE9qRlmZVZjkHw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=i8y11gCQ;
	spf=pass (imf20.hostedemail.com: domain of stevensd@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1270fc2bdf2so12413c88.0
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 09:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730787; x=1773335587; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3U1wJeEDhpO4CHVGDgYHkgbI6YxMM93rPh20DiYWuO0=;
        b=i8y11gCQsQxtc72zoWWKegQRcTTzGIz3O9wlRPJ7xnzppeVXIGbafpcujbPsK+0EUf
         rPOEbgJNKrL0aepN0K4J3pxxG+YKqtJ+de2AlnspbL58Pt8Cs3e+saqwF8YppBEN55El
         g7XcjgddErNr1kdltvKRCponU7aLgyDw+UazsmPwxTbwDYoBiEN0ESNliiGgJVnZWm/r
         y3YKogenqe8N9AvPXm/sJGcSPKoK/ps7svisiGsbGSqHhNJoYGtcuSrdbX0gusmIZ7Nr
         eQF7kaCSCBNzj0EAU9Awcfwdb069+Gc+rCFPcM8BjIBP8xyjnDF3EmQxfH4szw817+Kj
         JFZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730787; x=1773335587;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3U1wJeEDhpO4CHVGDgYHkgbI6YxMM93rPh20DiYWuO0=;
        b=TT0BKKMul+N/tqOUFNiCzhZc3N+rv2+HFtyVCPl9Ovo2qJVI7MIV2gHNh3YUiim5rw
         NEwMBRiJg4/uEfPM5jhaNd8LuM9qeD8lx6lQFU18AG2Jc9iS0LHGbY944phLMRdbBxCT
         ieLoCphHdaHtAt1EXm7mfokdpnQB0P+ayZwyPbtdD7FfAN+sHm9dRU7+JyP9lmB9gZUh
         8eLvOJn/jV1181flcNsFWDeur6VWfR918gs3kM7rVRij0Q0PqMRrDwizURJbWtfh6W3s
         zncbxjgxYrRzfsgmkxr467drDDS99l33vL1ZXrtquO1d3t7k9NvoNGf1FYkL2mJGQzyW
         nuVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMZVamlql8684jvqEQG+Jr2sahzmREBuwDoyemzoKc3cDOKnNj4sGSr2tfzvlxPUFrSbmoJ8+pgw==@kvack.org
X-Gm-Message-State: AOJu0YyW3ZoqigJPYwinFfQvgUel0McZv/jlpghOkQ+CmK2MuzwqQlSp
	Ki4i5JovVMCbaqVrkciOid7quhC0hY2TmIO63+rNVcEJOtiieZ1AdjMjbXBGt7pUDQ==
X-Gm-Gg: ATEYQzwDkLB4/Fh/wopS8W6/26zI3RnC9LCAtq546vqa3809NdFkrIb2GERW8X9KDX/
	oYcJoQfyN7hKJNnauIhicbLilmQXanqY+0TyfMqDcRfUQ/xHRJGF2BpVsin544nuqMipLs/8xo0
	C1RS8zkoBxldi4qUdGfYohA1USSEn3rXv0o8at+ETwAQl5/8yg+HLE6gGNoC+GgTjbhhrdW9rkR
	KNTdJZbjxMwPnzsf+Mrj4Rqhdf/1V52sN7DPTLwc/8vOi0AdxYHZEfOCwuLt+4haCRXSbq6sJCF
	Iep6+7pbV7RvoguGXMxu2KCq7nN6LsM/PqXffxETn3EQloLUu77Mn+zhnUMEJUQrsqH2M7SphzI
	brxQN/PdyGYPeASYTV5iXvUqtXthvmnMwMs2rFDg2EkrUiGE30+mQb97i+nmISWgg8ldQAzXkuD
	pfWlzWLABrdGJHfR2ceHS3KN6+vJpLmpKh2OWkk+Ihq3w5lfslYEGkIbUagJFEHsKw2uWfIZdQu
	gHVZqIT6vhLIOS2
X-Received: by 2002:a05:7022:2207:b0:11d:f440:2690 with SMTP id a92af1059eb24-128bb7fb13cmr204021c88.0.1772730786074;
        Thu, 05 Mar 2026 09:13:06 -0800 (PST)
Received: from google.com ([2a00:79e0:2ebe:8:e619:11be:acb2:77b8])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be1731b6b6sm9538163eec.5.2026.03.05.09.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 09:13:05 -0800 (PST)
Date: Thu, 5 Mar 2026 09:13:00 -0800
From: David Stevens <stevensd@google.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, David Rientjes <rientjes@google.com>,
	axelrasmussen@google.com, linux-mm@kvack.org,
	lsf-pc@lists.linux-foundation.org, weixugc@google.com,
	yuanchu@google.com
Subject: Re: [LSF/MM/BPF] Improving MGLRU
Message-ID: <aam5nOyXs1sNdjTe@google.com>
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
 <20260227033013.94901-1-21cnbao@gmail.com>
 <CAMgjq7CDgap5pe_xVemow+SbaRW+ERXZBZvkymhFWZQZdDM2Kw@mail.gmail.com>
 <CAGsJ_4ypfGxp5vbNaOt2i2qDmy9tCJuemDjMjwWr6hSv2RtYVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4ypfGxp5vbNaOt2i2qDmy9tCJuemDjMjwWr6hSv2RtYVA@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: 3ntzwdsnpkxkkf5byf9uker8x83ideta
X-Rspamd-Queue-Id: 1D8871C0008
X-Rspamd-Server: rspam03
X-HE-Tag: 1772730787-678142
X-HE-Meta: U2FsdGVkX18FPSxdWs5Djla0h+FwAjoFmltHNjxMZykTrIMZWlFihBc2twkIKqsrrfpUWVuPt5M2nLpGxcisfBtcbLra4u2QizmhrkcKXzdXeLYgIemQMGKn5LyNQKjKMKmFexk5j8ab+GUPOBXtOZa72MPq/ARmvCB4itQ8BbtsHwBk5KXtGbvh3C/zEjbxjX8gy6tDI7+lXmpO3j66SWQv1BfdvC2JcTqEl6pByeaWoyy63BJZa+X2urKEISnLmNctGZsq/O1q5A/fQTtr4JH6T4m9eVQvWTHaM5J3HSvEqm3lRxqdDD7UOR9R2rVmPwmkwU5v8NVAQOgfYU0ARqUx8yEsnyZ15Hk42rcalXyv4g9gk2LpUlqj9SMHGoBnRp3olsTHjYQctFO4+yn78eyDSn3VboXwDDuWiUrntn8cMJZwRKMAH8B8qYfSXHloh4SfutWTa7vtdszVkab9C5mL8Kji2dxN6F92+QxzwNZrC7dDoRXDZcPkgaxW8C69cJOMMS6Wb4mySRNlPiOdT1TZJpdaCSdhKocHPkIZWRTNVq5HRqO/MCWFv1wnGK3ykXuBLVaa4Wr5BY/dqPnWqg2PzrfVKKKZLCFu5sb4BYO0aRSJZtgarTSKp81PB0cWnZa+yqU0idmyUouACOGfzdq/DbJrIgGD/HbHJV+MJPZuSs2xjQ6uuw93jnbM1UUR8mRaB+W8qpWneoqskPXSabYoJxreNgvkSYnAiQhNNolhYqaHu2/cV+UXfmfE66gBcx50wkzCZN9x95kQF+PXlInmRAXY4gay7/yARYlROSx9LSyzny86MQ7dmbM1GX74KpeEZY+hBG53cRPlbkJRTDU+GdH+O+slcV3l2iItxrnxaNQsl/vfUazSaUWDdMBu65kEWsd2DoDnTB7D1QT40VWwncTs0u0Ahvm/2m/SYiUVhYxZVOGqlV5dAGbVys57Ng8yTfF9oqJqoPgMj+2
 +BJ9ALry
 SxbGzTAphdZ9GyyuC61ti/Khc9FN2Beh2RdYACSPzXonEWrfZaU+tLQaQKPGj1sWoDh86GLjtrj1P7fNyJmOisYTImsp9igTaeVgOD8LRTN0jAdEoCcEimBsyQY+iuzAII0ykSNfXdF7SdzB2xXVXE3KBeelYsFX7T091cTY2KYhdNUYPbBmFUk5FbHUgDFgxa2cE6Z/eznAoHuNv0B6AX6Cv4HVlwjMW1HU28rHdxMOOI4rooAinqxbaXizFHbk6wK7KZCw/Wwpxxcvo08CatHDwHl1L5ZBz8TvyHbje5PwS56+sU9PmmlpfYRg5x9t//xmwuWN8zyGFu5KIouA3nQdr2p0oUueR93o1GuOoOIV3jEcV0E6GejLDbvskd5ZdgYdLJgQLEA0MOMTeinCCSDmKOsUJzyY5zf5vkFGHMmrDIKfYKI/fMROHxODFOS0o07n4NTA7HWOPCE4zv3J0mcisTQAWVaHTUN0psT6cAnkc4C3Jek4z8E3wb2zaIaShzbe93GrGwJv4Pav/btv7jwtpQ8foBRpUFzkUvYFEI6QggI6PLL4ELgwj+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 12:06:20PM +0800, Barry Song wrote:
> On Mon, Mar 2, 2026 at 7:10 PM Kairui Song <ryncsn@gmail.com> wrote:
> > On Fri, Feb 27, 2026 at 11:30 AM Barry Song <21cnbao@gmail.com> wrote:
> > We have an internal workaround for forces aging, and waits for sync
> > aging if one type of folios are not reclaimable (without the wait, we
> > still hit the MIN_NR_GEN protect again since aging is not finished).
> > And without the MIN_NR_GEN protection we might end up over reclaiming
> > without aging.
> 
> I see your point—I did exactly the same thing in Android.
> However, there’s a significant problem. If anon has two
> generations and files have four, they end up sharing
> generations. To age anon, we would also need to move file
> folios between generations; otherwise, the hottest and
> oldest generations would overlap, causing cold/hot
> inversion. Furthermore, in inc_min_seq(), moving folios
> means the oldest generation gets pushed into the second-
> oldest generation:
> 
> new_gen = folio_inc_gen(lruvec, folio, false);
> list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
> 
> This is far from ideal, as it still mixes cold and hot pages
> to some extent. Could we keep anon and file generations
> separate instead? I feel this is a strong requirement and
> likely the first step toward making swappiness work properly.

I did some experiments with splitting anon and file generations on
ChromeOS a bit over a year ago and got fairly positive results. Although
shifting personal and team priorities unfortunately prevented me from
finishing the project. It didn't get to the point where I was confident
enough in it to send it upstream, but I think it's still worthwhile to
mention here.

For a bit of background, due to a combination of low-spec hardware and a
complicated file system structure, many Chromebooks have poor file I/O
performance. We found that a fairly significant contributor to jank was
important threads being blocked on .text faults. We tried adjusting
swappiness but found that MGLRU was unresponsive to such tuning.
Splitting anon and file into seperate generations and then setting a
fairly high swappiness value resulted in meaningful jank reductions,
especially under very high memory pressure. However, there were
regressions to some workloads that I did not get a chance to try to
address. 

If anyone is interested in seeing the code, it is here [1] in ChromeOS's
6.1 kernel. I also have a WIP series posted to Android's 6.12 GKI kernel
[2], but it hasn't been merged there. This version fixes some issues in
my original series that were exposed by runing on a very different
system, in particular around memcgs. However, it hasn't been tested as
extensively.

[1] https://chromium.googlesource.com/chromiumos/third_party/kernel/+log/929932351492d01f0aee37a0ac3be8c7bd88f80d
[2] https://android.googlesource.com/kernel/common/+log/49cd20cfb0da2361be064f7fd70b36867065277a

