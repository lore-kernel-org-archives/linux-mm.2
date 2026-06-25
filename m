Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C429ECDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 13:00:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADD556B0088; Thu, 25 Jun 2026 09:00:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67A46B008A; Thu, 25 Jun 2026 09:00:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92F156B0095; Thu, 25 Jun 2026 09:00:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6820C6B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:00:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5099A063A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:00:10 +0000 (UTC)
X-FDA: 84918442980.06.F1D554F
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id C74E5140006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:00:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=P1Ny9RFZ;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782392409;
	b=4N+NI9rw41XoW+qZw4UDNLG36F/SAW7lV2kmzUmAcDSVMPOX2wPMufKJB9cCe9tPZ6u90R
	yjFfE4uqPFD3x6mseVQuKcwJcNrbtxhjW5oolU1QTFxGIwp26LwVATqT0zDPtkjhfttGmi
	AR9tQToXt2EPBnsHIdviyxLWkX4KknA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782392409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4E7xhSxqesBGvRNciE8rd995p49J3l/FL5kNnGzEtQI=;
	b=ynDUq0l75wJc3rXj8OwnE1cYQMvKW8aSTn3IAq9SkxbfHzStpTOu34Ewgod+Gop1A3MD1c
	yJg0OrlHZvB42QFjaZqyKcqsKgWFCkxOpZ0iqehD8RgBierr4x2HuMd5kxGtemdZZyCpcT
	yXa4jxgRk1Fi8aDGpysiPJ0ODC3s3Vk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=P1Ny9RFZ;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-519f6a10d9bso14401371cf.3
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782392408; x=1782997208; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4E7xhSxqesBGvRNciE8rd995p49J3l/FL5kNnGzEtQI=;
        b=P1Ny9RFZ9XHbUwxL72uTM6pRmg0x+OjFm5jNb9NisXEyoTq/RuNm1rXKW2lJRQSwrM
         MJ2yzQXfQYpSRPwfd+OhZPiFrFNWu704nzrQM7v9owyAEqcCivSUo/ZWeRv1MR+Uk/hd
         WOGjjZItA1BvbYHSmS3gAmQOi418qxJLmEGWzgwfVJcdoo5AHg4pdKUtvHi5H2qqEw0w
         V7S91OxnF4GlHsQLZedniCkSrzX0wDJM8Q5y79nvRnbCUJUju3hSOXZXIGv/kCR0S8eq
         dIpSdOlxBdS/9C+h6r41EuyFXYwEHVgp3Op8ENSYzfzxDHAEoHWq/TD6mEjCIj6v/+0T
         fQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782392408; x=1782997208;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4E7xhSxqesBGvRNciE8rd995p49J3l/FL5kNnGzEtQI=;
        b=MfDZS9HSTAC7najj6IIEBncO74buyegj6XmIy/tJknCCOol6G1zmPVGiXvc7W18e4v
         LR/uzYQDAJ7pTJZYtoX8wQL990dIEGOC5y6KhCeKSbdF+4pmUfcQImMQis8CwRI5EN1a
         krwpIH2tszTonke5vSdTy0FHgbIZNfJu2FENhUJi5xs7sh1nxAGfYr2kGtGndbtY6pUF
         fydCWGFeJEAqIJ+0snSiiXD4bKYi2PSDg++LrMotsmljngDg+n12veP3B72VPO4t6cpx
         xfWdL3wV31V3qkfIXg2Avul2+vDPrwUS2lMBMDuNO9n10KHqZkDodSFpXNKz5O+Hs/p2
         8lTw==
X-Gm-Message-State: AOJu0YzGYMaZ78oP4riH+Vqs13wNKxTM84qyCZOcRnDLa1bpaANEY6r9
	xndIpayxfLT13Qdb5RzRDUe3UJkyprI0CB5u1v1HNNInj38y6cF+h9kb32EpNACpMek=
X-Gm-Gg: AfdE7ckadHNd+5JooSf3ipbm4TJtx+fawulmTHq9YNo4F/hPczFNHxxQK8bn5I41UCr
	r0zL2+Nz7CDG+ZU1eR73GR0bCz+b4Cp7OvWQ0rjkT1rlsx13ri4zGBwnIDR32Ye/MlmmT78cYpj
	D8yTc9y6Yx/RRQPhxfY0tK3kg5yOayzjrelZ9lzCasE7pubEdkS8BX+xaJFObavtsClSOUEw6sd
	CJg8gHKgKX/V3alOJ5HTyGT681x7fYBeLe/U0A66T+bwVEwgeQ1d6qTcOCEviNGu8V1s1iKQESJ
	vShdADel5jXu5mZZqlP5t7sdvd8wSrxeUq1aBVtf5VlPsVt2BN36OofdVejsE8GLVKwaua6RnS2
	92x55/N2MiHLrlLDy+r1/UgD5+ayUwAOXO5OJByUV7zWW1YjfRzki0jM0BCnLpczjgF9v+Tj4zZ
	fb6E2iAHEcmz0=
X-Received: by 2002:ac8:5f8e:0:b0:50d:65ec:a071 with SMTP id d75a77b69052e-51a726f933cmr29001281cf.5.1782392406263;
        Thu, 25 Jun 2026 06:00:06 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a657f7b2esm34801631cf.30.2026.06.25.06.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 06:00:05 -0700 (PDT)
Date: Thu, 25 Jun 2026 09:00:01 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-kernel@kvger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/memcontrol: remove unused for_each_mem_cgroup macro
 and cleanup
Message-ID: <aj0mUeI_8t04Y4fj@cmpxchg.org>
References: <20260624183700.1152742-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624183700.1152742-1-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C74E5140006
X-Stat-Signature: fre6qipgj36qde6ogwxayj5wpqjk7n3p
X-HE-Tag: 1782392408-181411
X-HE-Meta: U2FsdGVkX1+iVrSYsYJsAsoDVG2ATi69S+nV5Y78nIVKIxdRcI24Qelmi+hsZyS9cTKUkz/conYTfOqRkKQTkUqlqCltJeU32EtyuojPTfUpqCiVL9jyZ5nLWvIC4RHrFWu5z9QCAVAf4AyfIRlsVmNIDS6sfg5TC2KPCrerkKS5tAQ83HFv8rWP34C91FLc9wu+uwWnDOX+WWCsK9K49V0ajA33wpQ6g890Fig4gJTInvP14E8jzkvASCrUIJMbSri482qaYtd8XAQmdzh5DKYVc+XxZSiWtH5CkDHPEgFCtPAzEU4XIizr0WKte/CYD+lp+bvTVZcVXghYV35husqc1n0T4TrO8crdXYqNYMJQw7RQDIYQUyrxmZQcm2k96CoE67WdWqAfacG8tzweg2y0oOcPHUWxZ0EV0dr1MhBhi1+bpQhxVL+MS85mAHc1v7BRt/tmLK7CDs6v6cV+qGpce6zKoftLQzYaNT0zZgs0jnKwHNq2oYR4cbe9kRWF4Ve28i+TJsMzRoAWYxx1jBWrScFgAIdcFIov7HiExSCbwB3oRsPlspGl9Eag827S8gn8DC7ChtAp+sdxEZiysaa9ufzLqGdtAViRh0b0OQXaY2D9VBDt9MrEAerLrKN7kUehJxGZCtzu5VEEOl+QZOZWEoCPMqqifOf2ELPn/PoU5CoBXdZIhQRXbNh9dfYR/8T+pmKV/Sev4BGsheY3efIXuCzlS8O7w+24gsF6zZIR562vL10rVMI9QCcUtY+hxJm5c5tzY2FbhiCcpJEDG16g6VQXr4JC53q810TyGwE07GQW9ToLi3q4MlYcLDwwImEYLRNsshcC6sITaElAGflc11LPcawUcYXOAfBU9akhjqFoNpPBxq8yA7oo0/fwjoXx/HveRu923X6UtABPIP9dey9pxUB4dC+uLo7ucu+bDwqARoU28bVbF3uYs1yc2OZAHQIAgAwkUP4F9SO
 KuCCWPvu
 1E0c9J0nObIW8Mxlofy2ivkAH2U17GDlDOG2OjtZSAFgtrIq8J1b8p+0HPXRo/MdFw7E3wAF4VV2Z/f3hZQuBvx96DnyLxqI3zfrmU2rljguViiNR8vJ3vlNI5YYOp4N5sSGpIteXc2p6Va6dbU/jUYlp2UwzQWbP6s9KfwBB9A8I8HdJyLPugZiHoFyoyxykgrzZ7gHKkQXZGg3QY5wkUFoc6MRM86adu64Oxcx9oS5hyGqzvVTfA5XmHwvqBivk6qGQdwqN0EZSVW+B3cmtxHkSyTMWSapu6ugniG3BtJUVLYUtJi+x4Ig6PlNJswf0ZnkEzIszsCfhWvk1oDJo5RLN3it5B/JyvTBIVRcjSTF/piSIa31+URPCd43rqH0HHnD5lAovHqqZ9Tt/xjYncuBU1xXUKl/GzGCtrl8Y7JerDN5tjKUIzn75cLSRm3Qi0bbPzvvN7+aLo33DZbl+tiYZ2jQJg9SNOCHjYkNLPYgafkSIKls3gUFud2t5GpcABKhogc2BlJNd1GkRkC2eXBiwpfWqV33EID+FwDR8x+NGv0ua7DjQI7bO4LM39AdkbgNhrHyNv+fnWTwOA4Mt+wGQxHGEu2MoLvRB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 11:36:59AM -0700, Joshua Hahn wrote:
> Commit 7e1c0d6f58207 ("memcg: switch lruvec stats to rstat") removed the
> last caller of for_each_mem_cgroup back in 2021, and there have not been
> any new callers since. Remove the macro.
> 
> A comment in mem_cgroup_css_online has also been out of date since 2021,
> when 2bfd36374edd9 ("mm: vmscan: consolidate shrinker_maps handling
> code") open-coded the for_each_mem_cgroup iterator. Update the comment.
> 
> Finally, 99430ab8b804c ("mm: introduce BPF kfuncs to access memcg
> statistics and events") added a second declaration for memcg_events to
> include/linux/memcontrol.h, duplicating the one in mm/memcontrol-v1.h.
> Let's clean that up too.
> 
> No functional changes intended.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

