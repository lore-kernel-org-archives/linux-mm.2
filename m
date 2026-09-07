Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42404C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AE5D6B009E; Mon,  7 Sep 2026 04:46:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385106B009F; Mon,  7 Sep 2026 04:46:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29DE36B00A0; Mon,  7 Sep 2026 04:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F39D36B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:46:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E9111206F0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:46:50 +0000 (UTC)
X-FDA: 85186335780.02.008471F
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 97512C0007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:46:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E7zi2vbD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788770808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bo+3ezyb4Sv4NQNeQMvoxqsPDGjYgbnA2PqCEy61drI=;
	b=GhDECIlP8YlTwDOO7KWTQh/TZ+Rsxov7xf06GQcPqgiL66gDTticGdKmJ7LcRgkZXyWRg4
	y7B6UUvzUeIZdLLTejebLjzWwPYEZ3pJlJjRbTv7Ff4JiLuYh4aDdRLKNkrvW//2N0m7Wm
	sY1KiuHuAxrkIra+j16oV4G/bK18eLg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E7zi2vbD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788770808;
	b=UbSkRQR1TGI/zmxiRMS0UDfLvbvM3v6zVbtG06NlBtYvUzC4MT59LtQDAInXOV3vLuj3r4
	oW2u6PegupcG5BfnIrFhuM20quF6MGJOGgig6lSFJNkL+iPWky114BWlCFDY0xm6Mr5ZTz
	I99R7W4QexMaClaPfjcmj27JDYbFeyY=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc1d57602e8so2912380a12.3
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 01:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788770807; x=1789375607; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bo+3ezyb4Sv4NQNeQMvoxqsPDGjYgbnA2PqCEy61drI=;
        b=E7zi2vbDLFcRCKj+SBKbJ+icb09XXAZ4lqUFk346LRzW48XkK6ki0GpS64so/ZhMFT
         N0h3ZrQUTyr3G4f38XJaPjVMoH4soJ/yK8Phqzqi+85xDhLn8fIdNR2jSUX80HclTs1v
         ayb5d+hlaAxptNl68kuAvvslPJYCqXgI/X+M8O+sRdKa0znTI05aZgzq+jPCk9M8O+gO
         +9YVmbb9hblaYd9UWpGC81Jy8tMLvAPV4mpZyKE8v8us3Ma4kxJWW6UYPlxY8wm4vt2B
         tEZYZFGZOVcvBB31kSHlDmo9T4wk6YBGNsI8IbgmOc7pzmagScG3dX6dWtGwGLlARymW
         aGSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788770807; x=1789375607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bo+3ezyb4Sv4NQNeQMvoxqsPDGjYgbnA2PqCEy61drI=;
        b=qr97/6Af2vcGL4ntHtYXMuLKcxjkQk6gYKQHc6WidnoVZe/YjCHUA7dXmMTKOQRvna
         hz3Pby+asKNi4JTSVKUqX6gWPFwfLgsWdyNPgVuObD7Yo8VvNx148kP4wqAaJLZk0HqY
         L4Bzf9LFjQ8YwFkeXRVjAvyTLjpewT33taGDZZmdsUevqv2XTzBBaLTX0M2sGKkY29D+
         P0HeD9+i1wh0igK1QqY5+abiAiCoDeHrDeM/8iMOFTBgxG+p/JyMWcGirdeMGLDJ1t0n
         JlIS0iy6SwiFg9v7y5Tx3FBeVV5VAqnSvsSWq59IQs6sDbJPOHrGwXpBbDCtT2ewxp8R
         uqPA==
X-Forwarded-Encrypted: i=1; AKwUvBwx5fscTAohcMdmY/1pVB/nEV8bJv8oL/yEQOE0RKOxkj14wfjxVhPvp/O/47M3/DUreQi7JpkHCg==@kvack.org
X-Gm-Message-State: AFuF++k1nc7BtFVGskTbJk++KfdlZOkqTZM23IvlIak947ttH2ZUbmC1
	Tp84/ehxQ+hTgYZTXRA3enGjRTD1NosuDho7HhgizoKRabDaMsiWpZNw
X-Gm-Gg: AYBFou0F/SaOt0scWAz09Xoy2BVB3ljXAROi0vwOiyUXDJzUiwFVq6F7i6tytmz5vF2
	MlGKIaLDvf29qXyyHCExZ7gH49vwa+B73L5el2DctrsIRRXZlDs0mNHiRhXbwaOWBw3VPklWOLT
	MHAu5CCmhhSJ0cmN6kS8F65YqlKDQC29xhLil48nmJ+K96c1MzhUHoTkhJZpN3NaijeD83ORjgb
	f72E24ORAEOGFAFdr+PhKsXRAJfLVhn0kIwJktWmyTTU5wjg4JD5hYssHS+LA59EGMRB3Ng2ZJb
	A7naAerwjAgS4KnfuIpdFvWI7O76fefdJ31bZshAajHntlmgD2+LWjfkdfgP1/OvPFOqT53QaZX
	IKsiLbarB86/bRsVxsvnl7ZurIcvZfgcRODNDVNK0zyQVkohkLQjQXi5c1usE1HMOmTZtQ0YxZr
	14oGQaa6031KMLiidEl8qoeYzdoMoXDTuRYIFxRf3JR9IgRDhthmx6LbN4hJs4JgC6/EPjxfv8C
	b5TKQ==
X-Received: by 2002:a17:90b:5790:b0:398:9bd5:4910 with SMTP id 98e67ed59e1d1-39b2624f0ffmr32121138a91.23.1788770807373;
        Mon, 07 Sep 2026 01:46:47 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae8f1cf6dsm9357274a91.3.2026.09.07.01.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 01:46:46 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: ziy@nvidia.com,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] mm: compaction: mTHP-friendly memory compaction
Date: Mon,  7 Sep 2026 16:45:12 +0800
Message-Id: <20260907084512.670883-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <DL8QRV0RZS55.238LGA5F34MYG@nvidia.com>
References: <DL8QRV0RZS55.238LGA5F34MYG@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1hq3545p87ms5dy3psd98fdp5os8yny9
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 97512C0007
X-Rspam-User: 
X-HE-Tag: 1788770808-442649
X-HE-Meta: U2FsdGVkX1+E8pd2RL6b5rk6NQJoDK7f/JPf7QC1fjEo3Xzc6XV94YI8n2jNE9tuuDg9/l1HylUHfH5QuAiFLtTIEYyLd5OORnJqPGFxGmOPP9bfK9aIOsgu/rIrdyJWJEhr44vET0T07nlYcux3J258lFjTrzKyZasH76qy4ovG2ax/Ag8xDbKvJqpGV7+bPdLK32DO7pY2nXVUFCROKHbcNLwdgsIa20fMufSlHwNvtG8ndq+UhGQ7rIcxGAdKvRb1b86W4TmXfB8Zjc2Vzy1ZOxnZEKOcWlnL20J0RmiF7x6wthrd/ghBEqFNVGzm/GxCIAyyxAYQYBuFkBjZvx0SK+ZXfjjGtwIanmjg3X1TcGIquyvEGmVHoCl4KHwtxUKIXGW7aW7yvQeNyWTw7uA/594HDUymAWRbRtmuDVhxjIOFLVGGzoHH0kFUTXROmgJumBDi+kdU/RaeAMakCMM1eyrB4POZcuwNPPDo7/axSJe90eDAO0g8HPpZILx/Eutjc2NwdZOu/7IG8DBy2ahS1H97YsLBleuPlPiJeqQKjRi/NJN1WcaJLv57xie8T6f9O4jH4zOBdG9qCPHdb5EbNpyI0bzP3dLSN86Y18egBf0UM5pmazoeCYT66orOBZdGvTk9a4uMWPVrN0h9r67xP7VFrcHD/3Nl8MwMSABldaReIVK1i68EyIX6kRVJFuOAZeurQj0x2oYd9hk9qT3CPtKJX+HmBCciPGXlLYqcHT/tiPDWWSOZw4lgCbPn8jrGw0Yps49qNd1TxYoZIJN1hvRpZ/Dk1o1OjDhnbn7DrQGmZijPDiNXmRCb+vNlDIFCIrefGqOle0jVOheSn03GVoZFwCeW393hR0eet5il87jKgYbTMi4iTjP1bTVr1GZPcHW66AM5PDvwTrDmAtIEoO5qP/EJbOkpyzemRQa3oalcZHtzWVL/UCe4G2YcnV6l9YPu2CTjVbBF8QD
 fEgf/PFb
 1VzfTEVT50Hz7WlsCnlEQsub62XvxauqLrQySvmRCVboiffBMBVMKphyAvJCCP6UraipZaAYk5h8/3F28x4PqpL6kqDjXRCxD8uODy29dxNtMY0SlsNcS4pVmpPO1YzlCeKDYefiaEIh/uM6Xm2pE3dwAeTUdKPZ0QDhkm0KAHiHeGhhLKsUiRaO+2Yc8Vcwg70PyPxMo6RkAz4o49Sk6+fo5j8OiNQcCIoj/UK1x4xjKQ8mBeQfnx79nsdrMzT/kvFQ1X6CWkTUGY2ZAPwuzZwcNZ7Ks8R4vlzRNy1e2wtw5axOZVm4mjNQRGhiNoLf9pdEdBjwOmGsLhGQoIUnzxs1sf6MsKrP2HAnr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Sep 07, 2026 at 10:51 PM EDT, Zi Yan wrote:
> But skip_isolation_on_order() skips a folio with an order >= target
> order.
> ...
> Oh, you are targeting proactive compaction, where
> skip_isolation_on_order() does not apply.

Right. To clarify the cover letter: the "migrating folios that already
satisfy mTHP" concern is specific to proactive compaction, where
target_order is -1 (via compact_memory) and the order >= target_order
check in skip_isolation_on_order() does not apply. For compaction with an
explicit target order that path already handles it.

> What about the impact on THP compaction? How does it affect direct
> compaction for both mTHP and THP?
>
> It sounds to me that this patch series target proactive compaction. Am I
> getting right?

Two things:

1) Traditional THP (order-9) is not affected. The mTHP-aware branch in
zone_effective_free_pages() only triggers when order == compact_hpage_order(),
i.e. the minimum always-enabled mTHP order (e.g. order-2). An order-9 THP
request does not match that, so it keeps its original behavior exactly
(NR_FREE_PAGES_BLOCKS under defrag_mode, NR_FREE_PAGES otherwise). We
didn't change the THP path.

2) The series isn't limited to proactive compaction. Patches 1-3 target
proactive compaction, but patch 4 also covers the kswapd -> kcompactd path
via pgdat_balanced(), so both proactive compaction and kswapd wakeup are
addressed.

For direct compaction: patch 4 does touch compaction_suit_allocation_order(),
which is shared with direct compaction, so order-2 mTHP direct compaction
would also fall into the new accounting. However, the direct compaction case
needs more testing and thought. How direct compaction should behave for mTHP
is something worth discussing together to decide the right approach.

Thanks for the review.

Bo

