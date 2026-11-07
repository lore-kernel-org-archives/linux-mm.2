Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77C96606A32E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 15:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=NftaLBSd
Received: by kanga.kvack.org (Postfix)
	id 8B7BE6B05B2; Sat,  7 Nov 2026 10:27:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8413B6B05B3; Sat,  7 Nov 2026 10:27:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7301F6B05B4; Sat,  7 Nov 2026 10:27:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7466B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:27:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 79384140284
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:27:41 +0000 (UTC)
X-FDA: 85408702722.29.0E678AE
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8EB3040002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:27:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NftaLBSd;
	spf=pass (imf11.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794065259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VBHdHG0IvkfIox653vorDa3irUr9xVe5wSK7A8Aj0NM=;
	b=lAbTjrDJQiEOMckx2E5zh1YyZ7Y00VIH6PB0aWvqeAmYBrsjlcRtQ30NOXxICoUyCCgXVC
	W7ZyQpCTf9z15WOHUH6Ez+TCuAK/1GMRsdX0lhgwJJ9WsoHRvUvk++Hzt7GNouUhoDy32f
	SFeMbzfvYVI9M5k/GD7V8imlxH+MSRI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794065259;
	b=vFupJL/bqn09jUsSaoj63awZXj/cOjijTAdjPcqp2Jn/1EhI/nI7pLdF6jDt5IQ7Vrks9t
	9+QpqzIlK2Jz+y8mcJDT1R8r8mYbe1y7IvGVc0GJokcLMZtntcqP6bnJpPXsb/B2fWR+lD
	hFJue4iBHoFJb+7jg3lCn519VZpdtEw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NftaLBSd;
	spf=pass (imf11.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794065253; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=VBHdHG0IvkfIox653vorDa3irUr9xVe5wSK7A8Aj0NM=;
	b=NftaLBSd8viefNCtqZMIEChVV70uT5GRcJFArIQLasXx3ASF1SMeFh+NvDqayRva7y1PxX9gPtdta6kED6K4aS3uYCWH3oWkKn2BUEuXYpiWl2xuY0ZYgigixREErjdFNsnDJktMCB5NpcaYV6DvIUvkuT1F931hizk9EQWeE5Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0XEEpSZY_1794065244;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XEEpSZY_1794065244 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 07 Nov 2026 23:27:32 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: sashiko-bot@kernel.org
Cc: alex@ghiti.fr,
	graf@amazon.com,
	guoren@kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	palmer@dabbelt.com,
	pasha.tatashin@soleen.com,
	pjw@kernel.org,
	pratyush@kernel.org,
	rppt@kernel.org,
	shuah@kernel.org
Subject: Re: [PATCH v3 2/4] riscv: Add support for kexec handover (KHO)
Date: Sat,  7 Nov 2026 23:27:21 +0800
Message-ID: <20261107152723.847-1-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-202683@kernel.org>
References: <20261106071459.2003-1-cp0613@linux.alibaba.com> <20261106071459.2003-3-cp0613@linux.alibaba.com> <sashiko-outbox-202683@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: hfdnbqmo8sb8kf74ggnokehy7y6sukb8
X-Rspamd-Queue-Id: 8EB3040002
X-Rspam-User: 
X-HE-Tag: 1794065256-966699
X-HE-Meta: U2FsdGVkX1+SatJsI7mkrTGcZk+77J1x3jSKHBBaHOeuHiGkPauQwmnAZhanePK5HYM0/2u1+DLJnEaRAY1DbvE5ygcCYnnGidDd2nfPOcTfVSizZBIthvHLSDE2lfyVJZB81jDIx6MikTrRa3nvphwrhx3KSq944b9L00cLsWy+yKt0+OGb0rk7dGe2Fe3r6+M4PJzXm+uPqdOU3K9zosv2SMPlyP32sSJpcyS/gszTdm5wRkqW5MYRdOlD+kGM2GbnDRpWY9DrM5q13v9RghDFNA8S2Hay6JjPDY1ffJ/wKTwL0odN27lZUNbQNK6ywVSdpZLKKQmEorS51/wnwURHFfiAgg/+5S13M5EL+9Py1ruGbQ0e46j5BTEWTWILImhfbZKBpkGoFwgxd6PKg7vpWqsD1qaM4AWtrBoWBnQuAA1lVGKJmA0/Ole9g4JWpq/KmZHJJ+N9j81jItr15EpsayP3BO7aRhEivRpXBPv1z3KdjnnCdQg94li7CfphKJqBSdyN5DNCQPIOLeQN6hM8oLxM9OVQMkbcgmsy4klKldw0CzBHnZWVACHQzWn1BVQLAvOsDhYWqPuOgA8K31Mtpf60nyhbOHoPFhhOg6/I40BQ6i/2RIdZpUGcY32S2DX/1ezbEO8Q1dbRzonEIhv6kjTfk+KTBE/X85P0vUDCOO+wV7noHwYGrryZsXtVIhRnutFdT4Gum1WnSpngJ2Rb8aoOJM5mkE8Aur5gDErjT0yplPTOKkZJAbdqTLPElNUiX9+D7UHf3HrgVb/PoDB8PNJ7UQkvwBPvhUVB8XxHg/fw5cPSpUPgwAVSmWNu6CYtQbtM0xkZjWci2uCHIgmume8RwSjahHZ6FliHfaguJdbjvZPyXBPsK0Ipdm7yySlwOHzKjoGfHsGW1O/djkk0FFIQ+lt1P5cSYWAGlZC0I1jpZbiSJ1EOwxYFGEgy2O6rTROOygzgECqceBR
 a//Rjp+m
 6GzmkSXXDllAdBNmn2jAZ4noQtoleWtwIopWj0WFx6zvmQBNZDu/WHklAGL0FJ5q0Rc9Ipd7OZlfr9sRn3MELetbn0oniHZapX5z0n66uXVURQSsWTVRBwJSYY82fT5RdQoU8wM5pn+hHvmbAsgdGiPmdN6LAv1CvpvybGblXkNzgzmIKq9L5KCEc+VI2eiJ+9GzDgPInpBAv9egBR8g/heNi3FWAnpVCYid44niLy5Y7hN1wIoMvOq7K1ls2ulnt4nKYrCnxshPbIpgw5HChX3018V0nFS58i0o8ftSod450G2TVzEl91P1Tow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> [Severity: High]
> Does enabling KEXEC_HANDOVER here hit BUG_ON(!kernel_map.va_pa_offset) in
> linear_mapping_pa_to_va() during early boot on UEFI systems with
> CONFIG_DEBUG_VIRTUAL=y?

Greg Thelen has a fix for it [1].

> [Severity: Medium]
> Can kho_reserve_bootmem() fail on 64-bit RISC-V systems where DRAM starts
> at or above 4 GiB?

Mike Rapoport has a fix for it [2].

Both are generic KHO issues rather than riscv code, and both are already
being addressed upstream, so there is nothing for this series to carry.

[1] https://lore.kernel.org/all/20261023054518.3258350-1-gthelen@google.com/
[2] https://lore.kernel.org/kexec/20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org/

Best regards,
Chen

