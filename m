Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E335060A2609
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hcGmPkf1
Received: by kanga.kvack.org (Postfix)
	id 06EE86B05B8; Mon,  9 Nov 2026 20:23:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049216B05B9; Mon,  9 Nov 2026 20:23:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7E46B05BA; Mon,  9 Nov 2026 20:23:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D2AE96B05B8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:23:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 61285A07F8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:23:32 +0000 (UTC)
X-FDA: 85417461864.13.AD27B53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id BC6C0A0002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:23:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hcGmPkf1;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794273810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=05hTPr4FUsWYnaGend0CJdILpGB7dM6UzKcEst4eqP0=;
	b=EjgrReKkbQnEt1ZOVO69WknbNuczhqLHUamVj+tw05osuySf2s4qtMuUSqRoU1MUsFQu+2
	yaJVPA+6iIgGidPaYKjFWCwX5gNlwNFJJpv1cIkcYCEkK+/vTNYH5quKFrgnBGDsQPVvZV
	AMtpE4KjfFLPBZbxCqRGJcnTDvaRoYo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794273810;
	b=EMBEScM7STkfZl8r0jt30Iv8DTfm0cy2uT5dnm9dnQVVH9bVcLwPui41u8t/SCZhzo3KC9
	IWuCsN7GmS0fBg3GeLOGHTP4zOwp4taGNBTUl79+sqcYvDzv8NP/sC5S2uBzijz10IIIvs
	T55DPy0GP0e1UizJwAt3F5UpZZchuqY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hcGmPkf1;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F002545EB3;
	Tue, 10 Nov 2026 01:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB801F0089F;
	Tue, 10 Nov 2026 01:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794273809;
	bh=05hTPr4FUsWYnaGend0CJdILpGB7dM6UzKcEst4eqP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hcGmPkf1GZM/IdW3McVwji3+ikHi/qWLv2QatMViEmyKeor633JLQTCh52DSaSSx4
	 xMzKzbg/Ba3xKpCo8YRpYc0Tbpei3Pj3+C6hGGb4Ak7eLkWhRwILLB03JH0DOwN8Xw
	 2uTLLflkEmzL74PXpZ54hEN55jE+BTG3H2DzIL4rKiiFp13AjUV+EbONLRt+iojzrT
	 9Sd0KhISEl3qoIPb8m6T5e4wM/o0ti0zPhVv6WfApFb64wAmWUepWh+GF70nK7h5nW
	 4es71hsI0T/mi9JJSgc3ifOKxf0b+z14XlixgEmqBAVGBte4D4TKgUwm4oNoZTQNt/
	 x7xcbwFm2t3Pw==
From: SJ Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	Ridong Chen <ridong.chen@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] MAINTAINERS: remove myself from MEMORY MANAGEMENT - RECLAIM
Date: Mon,  9 Nov 2026 17:23:21 -0800
Message-ID: <20261110012322.106757-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109-maintainers_mglru-v1-2-c25e6de60bcc@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BC6C0A0002
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7oeeeei3kc8j1hohujb43qkd7e7k3154
X-Rspam-User: 
X-HE-Tag: 1794273810-618693
X-HE-Meta: U2FsdGVkX1/UvYl2FaK6EM5FUyy8oCWkHqbaTZGAHUKDRx+UNRxFL2HfnuASNyixQPtw1Eb/yYDSTHL9Kb+kABmOF81XDVcRIckJjRgn2R6xYRmalfb3667O1pE9Nr7nn56k+C9RONuxlQ29THCWhxUo67tIqjeTQUIxYDVfVuD9eyyomsXnWleU8peTyd8wvqT/5u5OpHsl6r8Oh4JWU8pqgtwe6sZGTcZmk1DO99UuCpSHDCygrHPDYMdUPJAlinnR8jmRoWZwRf9dz8YIFWuxLxvPgQnfEK7lvJU6bbXxFNAzfjBTDcUcEReSP0a5ZtTA46lUB5defjzxp7O80erbaIqF2gm6CKuN06nfrD1d49b0xQ/Oma040lmsF/Gd0u54lh4pJXIKJ3RX8uN6KWUIhNO8NmeZI/UcawzoFTrAHKAPon559f0L9u8z6Z+arvmelCJ6m69doP7+SBWnNU5H6KQAWZFhJvMG5GcufAEPw+3FqVdhw3w1+uXfmXqBcW7wfh8LCSyEIxWLusoG5FBaiKyGAZKD5LXmOhU7d1spTzhYRFP6jnClEgQH/Z7M6+XhTwCl7ctMVY5oXSpwWUV0UOCQWWrqJFAXULnqKNZmcjDb+QA3rEV0JuD/tqD/uSY4HrPW8Sx0gvKcCivdJT718V4Qo3R1BazuYS7Fvf8Qm6BCotaxYHkg7SseNtSKlO6xMthwODGAj+pWL83qxw0+P0qY8NDUcYnjLGzPGCuapARjAhXLofks9hBdr4qjFgqwhR81VdzuMHDWyj1UlIms24v7wiQ6u8gdyJnCGHqCPCCyB9u99d7Nk/2a1BRe7da5XwiHbLRtsQlRnOue50tfICDh7oV5Aya5V5Iuu1rTcru5EF9ekEWiRkneTA8t3uFjeq31J9TGbhO3yya+mKyk1zw3SocXFMK2RbcaQul1rTM7Valbn6hURAUCgsmt/fAwpZBja/p+7bW91Pr
 /bAt4RBS
 WD8JYhaTU4frBDmnbBiGlx/UCES9Hai8E07/Q6oyDLUl9S/Scybp8HsCMU+oGoL1G+KrjL54aBGJXCVcuKCro5qHpyW77PtEEwK019lP0M977GWZQPCHXbsJm5ooMSwHe4jMY0kRWDWa5eCimRgThhKU3wzhdrLSb/mkY6R08gBRjHebbEe4huGbLBI5yL+v5hhEtaLbkdibSEoik4xQ7tyXN3iOlfpiewFvBt+oZ9L9qmKM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 09 Nov 2026 19:31:54 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> I don't really get to look at most reclaim related stuff. For things
> that are actually relevant for me, I'm sure people will CC me.
> 
> So remove myself from the MEMORY MANAGEMENT - RECLAIM section for now
> to have a bit less noise in my inbox.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

