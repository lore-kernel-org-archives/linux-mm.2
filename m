Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7DF4C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 10:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAE5A6B008A; Tue,  8 Sep 2026 06:05:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87426B0095; Tue,  8 Sep 2026 06:05:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F006B009F; Tue,  8 Sep 2026 06:05:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 980A36B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:05:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25A40A0502
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:05:08 +0000 (UTC)
X-FDA: 85190161896.10.38478C3
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf11.hostedemail.com (Postfix) with ESMTP id BD9F940002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:05:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788861904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=utEH7pUPEGRC3i+zZJZG6jYHf7HRvGc2s25CG7mpjLo=;
	b=jy+S41kgm/wgSokt/SxIuwf9I2Tfs0Tw+1/tPmyt+/5gnkD5pdNk6Izex76WbnRmvQyM/9
	UJgrIposl4vhHiY+Kqg4cxX57l540DPAu9zQMUD+PES3/D/z9SE9w7iQ6+quUDhkXtQkF3
	sNKRp7Yn8npLfiOSclJ9hQESbPuvn0M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788861904;
	b=aSAlzuyLZYlTg0L7fkNTRScSDJrQV5zWHUaRl04qWNia8CNqYahNkpp/iqREPseEIX45bL
	doQjLZiLBLp7c5eG3V4uLYCy+yxIlODyHliYkj24y6SyHrsP17ZSWGho2+rBWbdhFrtCmX
	/Rc5kJTCJAirwf7RyZHP/QkBmYT7w8Y=
X-UUID: bdaba626ab6c11f19a56ed5b684f684d-20260908
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:9160ecb6-f921-4fce-816e-bb2e7480bf6e,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:bcf8095c4c0e4b78c653f45a7ab8f1a5,BulkI
	D:nil,BulkQuantity:0,SF:81|82|83|102|850|865|898,TC:nil,Content:0|15|50|99
	,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,O
	SA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: bdaba626ab6c11f19a56ed5b684f684d-20260908
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1521093866; Tue, 08 Sep 2026 18:04:55 +0800
From: Qiqi Liu <liuqiqi@kylinos.cn>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Qiqi Liu <liuqiqi@kylinos.cn>,
	akpm@linux-foundation.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rostedt@goodmis.org,
	gourry@gourry.net
Subject: Re: [PATCH v3] mm: page_alloc: add missing hooks to bulk allocation path
Date: Tue,  8 Sep 2026 18:04:51 +0800
Message-Id: <20260908100451.341037-1-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <c4c29830-ad49-4ca1-b4d5-6f40d30cdcdc@kernel.org>
References: <20260908065043.217569-1-liuqiqi@kylinos.cn> <c4c29830-ad49-4ca1-b4d5-6f40d30cdcdc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gcoxrp1fuxcwaq7qpib6k3m4o99m9x1i
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BD9F940002
X-Rspam-User: 
X-HE-Tag: 1788861903-943710
X-HE-Meta: U2FsdGVkX18TLSsBgq1NJl/HhFZXysRDDjWJ5AaA1sKZFZioz+EWRNbOZYy67NM7QCs2TswVaNapHgmsDspaap2srzfpz92jKtzVm7BCBlg1fIG0S8JHe7RnBh9m7dfPisqUJ60nwt03n462DFhkXrShYWDgKc01lhnrXqDJCQ70NKpm+X6z15CpnhB3ceO70WUoS184OB0KMoJwZ7hEpsDCn2nfV/9OT+gp2zyHG5OuFpU7KwW/Awcw855FOjVingIzxW0WnzYhcbyhUI7m59ZNY/qoSPa4F33lCM/6+OwXQLcB/MoWWZ1AI6DhzV6lE4YfCPKd3jeyJsXMWHFhigpFbuPnrjvbsCOUvrpUfaVQ8M0tyblND436g5+/rIzqx+NAE2WU42q8JlFhY38qdlfs+LWZ5q96lJuCo3lunRRh69NJ7yo54ZPBqgyjUVA+HrPSSf4k+gSh4WIS2HqbI3hwxaXnXRE42RHL3kbvUgW096MFkJsxeeHUIKG8BkXBiDMJzy55D+aNGJoIaOofM/clrINSd5AIo7laTfgQ+G7MYnAMfMcoZOToYAkHdYJDH9V4M9btRJYUFNAC/ZLaKwe3Ywd30sLU1Ja+XdLhsX9wKROlqff1nBe9ODvUl66gEpNTjqfmL/ocamngKX3uLVvTTlAgvvWPAO0IbC/hpSdiik0l6xrd2tEMzdD0b/YYcGzBX6dnd7mQNWXBZQXqW0JPxplAK5STgu3DGBtoLKjMvjpmQyq24DExtuN/jXQwsukhnm8/7d9FJ727mzyjpEqftnGsICV9lWDTcB7/gA47yipUatEVAWJ5TEglEiskQK2qQfjmWee4Iw9gaRRTHJCl2hs1JYoKRSpbq8o33Ct/7gOS3NlaZIkkZdZCJKYnUUGnmaVU3P0UH0dEJD2va1NYkfO5sbY5suAmPA18ADT1idSyie0p6wOtBIkdbptF/aB5YsaBxZk4Fmxc/lx
 alxnce/5
 uqGdcQQutg7WI7Of/x6ODwl7eRxk62yuSpAH/O6PmkyQ0b7v4HLzPFj0WDrOu+tZVFqEcSN275Hq6GX69UjUH44kMzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 10:38:46AM +0200, Vlastimil Babka wrote:
> With normal page allocation the set_page_refcounted() happens after
> trace+kmsan. While it currently shouldn't matter, it could be more future
> proof to keep the same order.

Hi Vlastimil,

Thanks for the review. You're right — I'll swap the order in v4 so that
trace_mm_page_alloc() and kmsan_alloc_page() come before set_page_refcounted()
to match the normal allocation path.

Best regards,
Qiqi Liu

