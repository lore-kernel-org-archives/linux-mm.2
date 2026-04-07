Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D624FF512E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 18:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF56F6B0088; Tue,  7 Apr 2026 14:37:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECCED6B0089; Tue,  7 Apr 2026 14:37:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE2566B008A; Tue,  7 Apr 2026 14:37:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D05546B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:37:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 75EADE2809
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 18:37:59 +0000 (UTC)
X-FDA: 84632619078.13.2C3A5F5
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id A48F5100008
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 18:37:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tqRCkSjb;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775587077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1CryZz1quunkh33nabMDcABtwXOAm695UMpux3s9zQE=;
	b=hOLmAFmpuwVjJaNdVcPaZrcC4KF2OdYJ6ImWKsOs82wShoaK+g5iw3DqQpNdHKFaQfN7Lf
	teKC9igIgdYVv3Ze0+M9GBeufHtokpTvT8FyPr3HWLPUimn78tIjq0sdcZtxpoiFc4nmxB
	SsqY1/qvHthqlePpzyn50TcxXmJyioo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775587077; a=rsa-sha256;
	cv=none;
	b=zKTv9NSPEPO3H3sJfrSlZJYz2EM1NliA7ouc7imNcKSP+7QtnoZymmY88rXxOqU+lPsgUD
	0Dnrm8TuBkaI1pT7CcRcSBvGHOCxcLfaqYqPPftyP35Jb4iozOV4S17lhHv9t86o9RcIHb
	blDspbR03vynOg/rXo+Fa5VpMeDJbz8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tqRCkSjb;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8cbc593a67aso547270085a.2
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 11:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1775587077; x=1776191877; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1CryZz1quunkh33nabMDcABtwXOAm695UMpux3s9zQE=;
        b=tqRCkSjbUhlovMG7pjB0UTie3KO4Gfg7EmpSirsqhF/+9c88UnR2eL4b5R6yfvzYRk
         rUdZl9BmeP5+zesMkKib15qEyiaiSddulL0kjW3ZqRXvY5riRVenKWBwmeK0lh1TwUBm
         MAW4/cDe3OIj48FzVsvYSoByxzWWthxKd4zjNi48X2oh9zWeJ5DtwbNMtOiaIiFD/gk6
         WVt+tefPiRU2kn5VxoVP/VSMNGsM0VGRR4D/5H5PioF2jpLLdcZbgafeKogusDNvTDz9
         vzzNSkFUEvgk4LBISLexUylcEMVPC47oYhapO5hQR0sMK68+y3ycF+HLQsfcl+WLxGHP
         L7WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775587077; x=1776191877;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1CryZz1quunkh33nabMDcABtwXOAm695UMpux3s9zQE=;
        b=m74sk03Q5u4ply2hIxHpzIe5MPbxlnHUsKED6bv9JFzzy4pQoJIwuVZPzdtoowlKpl
         KXxJUeh/O+DIHHEYSQqWnL7+mfnNJXHAXaTmcwIv64IJVOQeFzUDnRKPLglESyyT/7lM
         VylMD8xMHOjZsPsDauPcJPCD+kgH+c6n6ICW5sgilkYKGRVXKQy69xtU5ypl9qc5OC8/
         O3uwnNHYFwEbi84buSqmU0wnsx5Q7PwmYAPuaNhmYLUJMcrpm2kLuWfhmhn2JU+khQ1V
         Yu/5gjdVCpbhMrt1zXoZ5AZd7EJvjHhiCFBwZyja6/QMW9Pc9CI04NLUmcLF2gJNje7S
         BEIg==
X-Forwarded-Encrypted: i=1; AJvYcCUe9TEAEmpw1lU4kMAmMsJZSJrAPsEhxwME/tpMKi7YH7t0op/lhNLm/Ph1buHajeJkB4REJmdRQQ==@kvack.org
X-Gm-Message-State: AOJu0YxlJ0KRfbAZSHX4kDX3/G3fiMm1oo7Jfz5tyDoxb/VsNWumP1Nd
	KS/N00L2tdULAiV60WTz+XfmEcmwLTFZsR2Fv8guE6EaxIT3xNzwsrIqY+tvgsWfG5Y=
X-Gm-Gg: AeBDieu+b2fGH+x0zRHAvbI65vSQNCK62LBLTKuF55gbOflmWs05bHxKqFXgUgVvE2V
	euQcIutStGecwatBIrbEQgwhXxHuR4YPQrM1WX/vpgvFXQwbWE7gsZeFrNOqHqK89Wpq3nYm91u
	3ockXgzi//zBiWAAGr8NKKoGAFc4iXAQs1j6970+Ggrxe8kXnUXds/cG74jeTLzkVw27Hw09m6g
	SIqwZ/zynPhWkSSKxQsu2g1Rb1phi2SqJb0X91lSpp5lHf7sNHgi7A67Fp4/H85AXV9m8HyDGMT
	Olu00qR0aB3zKsuls8zYFdvbMmo90/QQ7mxHEQraOPFsWeaveT61VO/RMY1MSe6uTLyCB7ivvy4
	ZG7UAefIsvrtpJgfhTQeWFvWWOt9yYZLnIVyu/Ql6ucueglqO8cvLXM3OCqF8DjobnqHGdKkPKg
	BY2Sa0ktHte7LeQLyLL6yBZO53SzyIiS3yoPaBuutp4g0sthkB5ZIj5dRxMr/pJOpRTzOS1oK4l
	UYxreztOq14LF5w3+CvIJo=
X-Received: by 2002:a05:620a:1a11:b0:8cf:def2:c356 with SMTP id af79cd13be357-8d41b9ddc4bmr2656844185a.11.1775587076669;
        Tue, 07 Apr 2026 11:37:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d2a5c5cb5csm1368806385a.15.2026.04.07.11.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 11:37:56 -0700 (PDT)
Date: Tue, 7 Apr 2026 14:37:53 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	lsf-pc@lists.linux-foundation.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kairui Song <ryncsn@gmail.com>,
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>,
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	wangzicheng <wangzicheng@honor.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <adVPAS4PP7wK0Pxq@gourry-fedora-PF4VCD3F>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <42e26dbb-0180-4408-b8a8-be0cafb75ad9@lucifer.local>
 <acVPrEyfcE4Naz5b@gourry-fedora-PF4VCD3F>
 <248a126c-43e7-4320-b4bb-282e0b6da9c4@lucifer.local>
 <acbgIKuwDsPvPjdF@cmpxchg.org>
 <adTonuzmUc2AzUhp@lucifer>
 <adU3P9fk8h-AmEp4@gourry-fedora-PF4VCD3F>
 <adU8VnzlLw9JUHB3@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adU8VnzlLw9JUHB3@lucifer>
X-Rspamd-Server: rspam12
X-Stat-Signature: te7tgxsi8he3br9zzgeknqxymubfo8qj
X-Rspamd-Queue-Id: A48F5100008
X-Rspam-User: 
X-HE-Tag: 1775587077-650909
X-HE-Meta: U2FsdGVkX1+R8zpDqNYrqkc9fhrGRb6xcg/jx17mp2KR/3+zBRto8UZYpdEoOChLS4O6auM6f5xQpBKzkwEinBH71F9NK2qrOFfLpUUin5oyTqwsIBBJ1jhh+3Bz1HJuXy33EByaV2pdo8LZpZL3JTErIY9I+buRfZPpPdy5b9Yojrjss9AmYviXdvqhHMoW31xk5vxUDhyv9eRnSqCO3R5ZnhDn7iOCecfmyZ5WzyRpUgp1LWRroLq3nV+kwme0JNQhoGxQbD7sBV5beImbj+z/Yeryh36qR8z2u8EAQTGscoMLCJYf59MznEp78zZ+KT2fMVDaUSvaGCUoN6pnvqPa2f4sPTWjooEfMbATu7nwE7vYxtkItZNk7sXQI2D2Lulog1UMvEOl9FntvfGG68mxDrpjnbAHjFcX7sBzr5h5YMrYp4PtXI7uy7XC9EQQxmbUevX9JlhT3pY41rfDYoVsJkWYqkhUJulO1vVfOzEpBOoUVEN3CLSHUMmVg08SPOYAVsL5FB5Bk1zYoQ0yNuSDcjfkBBorUKqX187k5VABeWOHWeu89zytIV9yT7ljbYLdYZSIMlZKvmGoBAvggVWU1EUxLShcMrX/nJFF09j3iABLkpx/p5fhzWD6DTTYgXlwKOpy/8AjBjsSgy+/xskMiNWK0BO1f3gC/Cu25vonX1MpIhgUOHyNZ6d6hqf/Mg3Mwj+HR6BMoRLPO7dFSAdRXvDFQ7d2BQvrAMgQA9bDbwNvF3U5jCBoH4RfHWs9gRcqaicuJ2CJy4BvUldhAi9T90rdmuBsR7A6/LYYL2nW+XOaEAVxg30mqHwCgpkmvsmLsz0NgS4zqtZhbn+kIeuWpa6Jd8eYUqEWricxA+F/TCcA9JPdr18HWVyuIi9+F7lll4+ZwdkTIm4tvskXQ/EArAtkAAdYKs34Pyv7/qdaUUjaiU1c+kKSIHnryR2FE4L60jIgrSpOep3vEVZ
 4++4z1c1
 TLFXhFJQiqLCIp2+VJ4R/CjJnzRG9myEm/kJvOSDGaq8mRntTUUEG7UXc6DWn2DoP3bfdkCpBaIO9r8nDKMIY63fk92TriyQvZ/hqzsUCu+vDi0W5ZVok1Z91nhhGKqYC+ghVMm2JUruziUajIjLqYimzBiluFBusALFqSNESmS6OqzJf/wxdl8bZfKq5oPknuxX6aOifgbK7lZGbJuUVvEAg7C0DTqRq6Sv0s3zxNFbve3CW6TLb618agIcQWvbpfuNHvtG/2ARnYEp1dsNYdQQybYrjaZcWj93/E6qYxwyk0gKllcf87pZrxPqkVzC5R+OOFkpROZV3wvgGZ7Rn2TtbsyXD6oTgutd4SseeZ+uVQvQdKmRI4nHtKIzzZ5q83Vx+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 06:30:55PM +0100, Lorenzo Stoakes wrote:
> 
> > somewhat trivial work these days via <pick your favorite LLM> with
> > reasonably well designed interfaces.
> 
> Though to be honest, I did ask Claude to do this with some code before and was
> really impressed with how quickly it came up with something.
> 
> Buuut I've generally found the code LLMs produce... terrible? Really terrible?
> So I think you'd want there to be some level of human improvement there.
> 
> And in any case, maybe doing things this way will struggle to really represent
> real world cases (lock contention etc.) but OTOH, being able to simulate a high
> memory pressure environment with certain parameters even without [the rest of
> the kernel] interacting might still be super super useful for diagnosing issues.x
>

There is a concern people start looking at these tests as signal for
performance regressions - which is neither meaningful nor useful
(unless you fundamentally break list iteration or something).

But for trivial cases, you'd at least like to know under strongly
controlled aging and reclaim scenarios that anon/file memory is
reclaimed in a balanced manner - just as an example. 

If something breaks THAT assumption, you know there's a logic issue.

Likewise with comparisons between LRU and MGLRU.  It might be easier to
identify the behavioral divergences that way.

But i fear the whole page-table walk thing makes all of this a
non-starter.  That's turns into stubbing out like rmap and such.

~Gregory

