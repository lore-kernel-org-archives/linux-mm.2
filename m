Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75B03C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 06:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F1AF6B0095; Fri, 21 Aug 2026 02:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9146B009B; Fri, 21 Aug 2026 02:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DEA26B009D; Fri, 21 Aug 2026 02:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F08C06B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:04:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57C7A140376
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:04:15 +0000 (UTC)
X-FDA: 85124236470.29.719742E
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 83258100005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:04:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="TO/kHazf";
	spf=pass (imf05.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787292253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g+M7b/GvGl+uD4vBvTDfSad/jpayqDUX2TQt1tkjpXg=;
	b=UYyUTPCehinAWUTXXN2coSPt85FlVMoXZa7vQQrsMOOYI00Kf0RUnBojJtJ7agLCbt2WLS
	wAOABtRymxiu6Z+elNKW/VF9RlhSlSa2GQFZtPmn5KodvAekC0kxXfcvom3so+AOmtruQT
	50azZXGGaV4b1k7EEElrd2+dQHo94R8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="TO/kHazf";
	spf=pass (imf05.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787292253;
	b=mx4pCcrFhmla2InySF757x28K6f764A/g3crSAiA+9iBbSGzc4aQsHwLtcw86f6dpjX22x
	nomRDQRYMJEW3AcMbkcQGX7aa2MNxfuSPOQ8LvWskdcXOLFd5vMpTMaU3LjaNyfZ0uquBO
	6PdXUWdavcKqWj0ipH1CVv5GbC7abhc=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-ca97d139d5fso610348a12.0
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787292252; x=1787897052; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g+M7b/GvGl+uD4vBvTDfSad/jpayqDUX2TQt1tkjpXg=;
        b=TO/kHazfZyHvORRzFRuu9mQF48vtVI2gxGJEBt0xS+p7UtJ3S2sHKWo82MjK2+lo8s
         NLzas9BfB6D3MUDd3RcEujEH85rB14G0h3/MQ8oCQw/zXk1oU5Aicrg2ENsIrY2SAk6/
         7E5sCZMiaaNOGWquU1zFE0zDNnulWxTcG3ar2q5XgXXxieCU1BCW2KGEcyuNnemLWJnl
         obaZdXd8WpsCiigAC+13QkA2KpG8BuwgEkKJMzhG3y+dNcBLr2gn7gsgZInpm21DodQK
         kDSFEGB2sls3o7bkOyaMgq4uUvEYhWx8jBXMjjPJ+HzzLCDAUdBq0a30nb7iftvc9DAb
         S4sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787292252; x=1787897052;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g+M7b/GvGl+uD4vBvTDfSad/jpayqDUX2TQt1tkjpXg=;
        b=HoAwx9f4l8GSvyeZLjYybGMDCjObj57tsqDKwhXEkYWJJAJn61XO7NyQtsuI9xpFiF
         KiUQwqTThgq/exYUOTnMWP9FbWCDPEgOwQi36j7aVPZatpIETgFZqc3jgy15BRv5PpG8
         SbEUVarzqeQ2QPGWDiXFNpfNs5K6NcxmMHteYHjk1xD9VA1QqtGOieRb3kU4N5eLqct7
         uO3oUKt/zjUk+EpN+m+CheO0oyt0+y1dNxmOhzXN6WwdhRmO6H7jEqiwcVZwzQQdd5J9
         qxN6ClHl4Mxmev4XPHE3lDCIExJ/55btxBDoqAepP3sgM77RGlunv4WUqZ0qxNz86FLN
         trrg==
X-Forwarded-Encrypted: i=1; AHgh+Rr1kSMrH+xSEpeVI28ux/cMgmWfjx0qxx2yvUvnfglNcYxOz5oYcWoCx9HmdBNoMsrOK2qE13Q+gQ==@kvack.org
X-Gm-Message-State: AFuF++nwNSiNzmwcxfNoGOT38gMCLe8t+mwYVFRsOBzOTrn89IiOF3Il
	YdX94Vxi99aERlShFvH9tfYsMIatN6TtaMKv55Z9elJhelMCUq2tC+Wp
X-Gm-Gg: AR+sD122malJOS8erhK5HA2f1AOOjO2cijKbvQSuCw4VBTeQEYGQQgc0nfJOrlhJqBH
	3Lz/qkHQueNhvqyOTiVqbMGwdBXaWZQcIZBLlp39Izq5VupKb/p2U2lt/KjNh4HLP2v2cMpPHgn
	AEutRh1N23eEHtel0wfNZrrT5NGyh/r9+n/37CX2CbEXTy+Fpz78abyEDlwdvpGjUz1bvdmeipd
	0Y4jbfpHBUzAFc4/J2gu12ouEHHL21ufaNgI1YoHhlo+RoNBxEq6oAsaa7+jlXdaJL5qFWQpaPq
	FiZu5/VSMj9AbLJyEYWeRC1NAQnSIg06715/iFAgQyBNyX+OfGNVMfII/JrshNw3a0gv1n3Tyyq
	8vtcWRux0MCaQcpGX5XV42U0wHzKEshy7aWCb3cbuJD2QyPW0o1oOBvtPEAsRwhgzgZ5apfNuxu
	+kLqoGaARdsMtaaxp5fdHz96ppAMnkiiEcaAZ2aRLiM3sVPA+J0AR7luJ7yCLGTEcCZNn8qQw=
X-Received: by 2002:a05:6a00:a8c:b0:84e:d5e6:a085 with SMTP id d2e1a72fcca58-851f969b7a9mr5413810b3a.0.1787292252349;
        Thu, 20 Aug 2026 23:04:12 -0700 (PDT)
Received: from localhost.localdomain ([114.86.54.94])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851d366c853sm2409432b3a.49.2026.08.20.23.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 23:04:11 -0700 (PDT)
Date: Fri, 21 Aug 2026 14:03:33 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lance Yang <lance.yang@linux.dev>, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, zokeefe@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/3] mm: khugepaged: fix tracepoint UAF
Message-ID: <006469fe-b6f2-44c9-85ab-b9ef99bfb2f0@gmail.com>
References: <20260815174444.4164-1-lance.yang@linux.dev>
 <20260815181632.21453-1-lance.yang@linux.dev>
 <20260817153049.120e224cc303f1c2292cd768@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817153049.120e224cc303f1c2292cd768@linux-foundation.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83258100005
X-Stat-Signature: rjnwqznykw64a933mj34spjj4698p549
X-Rspam-User: 
X-HE-Tag: 1787292253-196540
X-HE-Meta: U2FsdGVkX18J9OanMQhq2gDd6AZSQOU5wHPlo5BpooUU7WhhaPUpLm9HNMMxlSp9aAf08vChHEBiHKD58jqYUjOMyYvQWKDCs5MnDITY5J2WuuCnk/A5M4rT8HRZHtcCwPaQZpRvoJ20D3sAR0sLceSOTUlX7zBOU30NV5KVBaaaZ7lzY3+wZCXlj8w1HAB0RtYAwUZHVWcf3u2Uet5A7ib82pAsmhv3Y+UhH2QWrX6TaOWAPqkAYZTjmG7wHCj8gnlzKg4YpRlrAlKYZBnt4mOlSR/rc5F3C78XGAqvVxVrQdfUUYp8w4FfR95a/1B1TE49OYg47/MjAWC+ZI3npT29NyGII6gvdLyLiBdXA7VFQK7pGQWGmRwaVOL25bU+22wgip61OIYJ5RPPBqeKHFF7/Mn4dE8gXG/rafURsNB5ggQHC18Om/9ApIWvPp32TIXjOHawwAsz/0e2fqe4YNGeU4sYRA/z7FaEI0ssxNK5F9JIXNH+pYUoERRsMpI6j/ZwYv+GSiLOFarepBuAVCU42gtDq2/G7cMuwCcfD7hoTXaG2JBsq0xSo+FrAAtRw5TvcBoDkVT+QbxgqOMgVI3hjwcGCHOgLSSvqF9/ht2RJqgjj68rrgeT13o2YaaPKRdoqsH76l7/VPx06wjDOa5hCCPNSP6iBk6evUbe5V5irUrjH1Qi5miFBRJH4+2/YdKuxg4Dp9PBS8FJQUxNP0MrpKoheOTnY455NuTyvGlVSwLZrGQ4EsQb45fGCba9YRzh3XlSX4FKGc7sF6TNlWEM+LZ0G4IFpTNL+tJRxOHQ8ie2bz7+nNpuJaa14fzRdjfWM/ugjSU8YPgHeZTw014Hj73mZANIBWrlhsNMG9rGjdGVMQMbaIsz0B4wW3XhKw6w8k47WPaSv1YLL9Ep8gaeGW9HOkT3tIUhY3D9kvEPzsZjlUa4ve88o+KAFQfxzrDAlQc0TxSYbSwtRVa
 8uK5QwBZ
 3iFx1l5q0tU9/UszBYItn9YP1IviLGeRCTiZmBUI6FUJwyp8+wXc8x8UEYTiEjJMMVUtysDjGOO77viSUSEZCt6r+W+R6F5j+aapPkM5BdAPD/saIouTU8xMe95jmOZ/lbbLCEpxxoHsFLD3m7nxMivbYQp8IzGzyk1sVZUO8ZJgtwm9oCsEuiNzCccJ1pqYjZiXWQX9zGYECqDjtO3qiA5q95vzHt/7ogyU0gHqh0NXSX228UQq9AZTMNZubGE63y9TtT1P+e7FTTLBVZSCqfqDZrCYPYSlYybTaOYth/JMttcBv0CyghMHdpiEz5644d9LELHQnZv7OZVftzPBFqV6xfW52XmSXHVgu9ag4IajVI1YSwXrE428AxtwoJSMKklf7vtlFNaBIrgYAg1CoRO+jtVTaTlUmhBdwr0mDydcGe1T+g9M40pORlzwNah8NyV1FkxEcM1rIi1RLOIjGwYhcoLiun/mXWyohL8i1hbsF/WCdKo6K9G6UwS+pXRsQpbrN6YgqogIszvI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 03:30:49PM -0700, Andrew Morton wrote:
> On Sun, 16 Aug 2026 02:16:32 +0800 Lance Yang <lance.yang@linux.dev> wrote:
>
> > >>Pass the pfn to the tracepoints directly, captured while the folio is
> > >>still pinned, closing the use-after-free windows in
> > >>mm_khugepaged_scan_file(), mm_khugepaged_scan_pmd() and
> > >>mm_khugepaged_collapse_file().
> > >
> > >Well spotted!
> > >
> > >Gave the series a run on x86_64 (KVM), all good (only classic SPARSEMEM
> > >untested) :)
> >
> > Hmm ... stumbled over something else while testing this ...
>
> Sashiko might have found a couple of pre-existing things.
> 	https://sashiko.dev/#/patchset/20260815051924.194810-1-vernon2gm@gmail.com
>
> Vernon, you may decide that the second one is on-topic for this patchset?

Hi, Andrew, the second one already is on-topic for this patchset, detail
look for the PATCH#3 please.

--
Cheers,
Vernon

