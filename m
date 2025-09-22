Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 052C9CAC5AC
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A2F68E000F; Mon, 22 Sep 2025 06:10:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053578E000D; Mon, 22 Sep 2025 06:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0DAC8E0010; Mon, 22 Sep 2025 06:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C13CE8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:10:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80FBC59AEE
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:10:55 +0000 (UTC)
X-FDA: 83916467670.20.69B4630
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id 576154000F
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:10:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758535853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=01vZXiYUKZS92cC9/C0DPWPj1sg95XaPPbD6UtgCHF8=;
	b=bYJvhe50e4/b7y8Dsi+6sbbEmiZHXNOuLTThMO4ezEic3t+2CGBjipffeH/+oVNhLg+XAF
	zeL82rNEuNSLe2//3/Er73cOijBUqTu4Zsj0MILKq4PmYaAKhI02TuiSnRM3uHzNvjh01k
	1Ye3O4j3JgHn8EdpHWSjVY8OgmEGDXI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758535853; a=rsa-sha256;
	cv=none;
	b=AxxTAtr5TFXwayr+RQ2WQM/iNiJyHLXMF3f+qgpr6wh0od2v5eUXgZ7mfkI8wQSuvp930L
	dcgYfzyfA2PTeuewYTBheyW6pQ44c3eesdgQep2Q2bFiYkDyME56Zj+9inhBPP3eDT1CRX
	+Px7VaWxPO/fqNu648GvSEjq2I7E4bA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
X-UUID: 659cc440979c11f08b9f7d2eb6caa7cf-20250922
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_TXT, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, UD_TRUSTED, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_C_CI, GTI_FG_IC, GTI_FG_IT, GTI_RG_INFO
	GTI_C_BU, AMN_T1, AMN_GOOD, AMN_C_TI, AMN_C_BU
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:677bb565-a6a0-4c99-974e-f0d2634e367f,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-5
X-CID-INFO: VERSION:1.1.45,REQID:677bb565-a6a0-4c99-974e-f0d2634e367f,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:6493067,CLOUDID:9fdadd777354701e6854cac0a256054f,BulkI
	D:2509221544039BEHWNZ3,BulkQuantity:1,Recheck:0,SF:17|19|24|38|44|66|78|10
	2|850,TC:nil,Content:0|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:40,QS
	:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI,
	TF_CID_SPAM_ULS
X-UUID: 659cc440979c11f08b9f7d2eb6caa7cf-20250922
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1216891740; Mon, 22 Sep 2025 18:10:42 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [RFC PATCH 0/2] DAMON: add priority-based scheme application control
Date: Mon, 22 Sep 2025 18:10:20 +0800
Message-ID: <20250922101022.362822-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 576154000F
X-Stat-Signature: kg9qikxswz99jzokcqhqykdifd7iei1x
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758535851-954151
X-HE-Meta: U2FsdGVkX19vrke/Xkg4v/qjO3Vs0cnJDeQHa0+hN0TYO/5/FVkqpf7w9le6Uv52JUgH+j9ETdNtSZdLpK1511L9frXDh+giwk68rBSbVYsWZTdehq9pBBlDp6aSAQJkw/Gi64mJdhrfvJwRriZcHG9K65zr/qB4YsxDIWsQ042BwDtDSU1o3oB1lE/eSKyp70k6SwmjtYncLg9TLOe+biOv9/KN+l7TaCPO6I5h3/USDz1jrX/LPyvQxGaYrnFMuF3ZGwunaWZcM+mnq1EZVu8ve0kL4b/LkfK9YlIUNtYfuKbMTShgJfkvbUrIGJ0/yY3ntQBJQ5JtkB2ys1ZXYVHbpfkfJdgGN42UJ4CDR8QxdJdcneuq8igwhh82J80IwFZeVc5EJHnIC8zrqV7stzXzjHsqY3SAqcX/ppuwRdyIpqTFTRyWqSYyuG7U8CLE0hddFQMXn126S2MtSwz1rRJPWQwTZYP/HoI9NkND7KDLGxzN7KqsU4jrEOYVSkLuvBi1vhCbtFSzEwli2KvKsMFpuebfSwhaIm7qel3ePsmX8lLbpxjybzCi6Ak5BE1PQEOGr5BdeTPMt6SuvS9yBhbd0i/qgGnP+1Nx74hsfFLu3wtLKstYYnBhmrLb4gaLYW7Bu8Icy7o9oNqDN4h/BBxf0vOIO6DHFzPxZrqCLdR3Z7FiKoaF9zO8D1fwTt8yMAAG0QXCeXpPnt/S/tTm1eazbbINCv60hS34lyik9Obp4HBZOJjHffAY8Sg48UtqcZu8viroEKSDkxpg29nLz7mskOm1eicbmfsNhQbSO8xH/8oDKw5IK9R9cDH6Uojpqdp99VOAiwqIBZXqF2oKcCz/4txlXFHDScK8todJutyCSQefQRLQyTbe/57Ji12EacU0aj78vzyA3ExvZ9TBTsNmW8jMcKr9l37MdsN+UtrNcP3WblkbVPa+1CMQiNgyeoZsdGEy4BU33PAcUOY
 wmoBuqro
 6ALMy069xw/TDqshrswpitXMjzqBAgw8Ex0V5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset introduces a priority mechanism for DAMON's scheme
application, allowing users to specify the relative importance of
monitored processes.  The changes ensure that higher-priority targets
receive more frequent memory management operations while maintaining
fairness across all monitored processes.

The first patch modifies kdamond_apply_schemes to implement
priority-based scheduling, where targets are processed in proportion to
their assigned priority values.  For example, a target with priority 50
will be serviced 50 times for every 30 times a target with priority 30
is processed.

The second patch adds a sysfs interface (priority under each target's
directory) to dynamically configure these priorities at runtime. This
enables fine-grained control over DAMON's behavior, making it more
adaptable to performance-sensitive workloads.

Together, these changes provide better flexibility for users who need
differentiated memory management policies across different processes
while maintaining backward compatibility with existing setups.

You may want to verify this feature using the following testing
procedure:

 # git clone -b v2 https://github.com/lienze/damo.git
 # cd damo
 # ./damo start --target_pid $(pidof <target1>) --priority 50 \
 --target_pid $(pidof <target2>) --priority 30 --damos_action \
 pageout --damos_age 5s 5s

Enze Li (2):
  mm/damon/core: introduce priority concept for DAMON
  mm/damon/sysfs: add priority support for DAMOS targets

 include/linux/damon.h |  2 +
 mm/damon/core.c       | 91 ++++++++++++++++++++++++++++++++++++++++++-
 mm/damon/sysfs.c      | 28 +++++++++++++
 3 files changed, 119 insertions(+), 2 deletions(-)

-- 
2.51.0


