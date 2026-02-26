Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35FBFFD45FE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 01:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9366B0088; Wed, 25 Feb 2026 20:08:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287196B0089; Wed, 25 Feb 2026 20:08:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 189E56B008A; Wed, 25 Feb 2026 20:08:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0382E6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:08:39 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A34EE1B7234
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:08:38 +0000 (UTC)
X-FDA: 84484822716.20.7D72DD7
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf18.hostedemail.com (Postfix) with ESMTP id 79FB61C000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:08:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772068117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=HA3lanI21yIiyXu9S+5kmmRZnagu/mBBgbb2W+iMoQM=;
	b=JxgI609VdINS2VRc4NTFIpzzBUyx0iKyPX2ydlKWt7hJDJhn+Wti4i2dKo/s937JqGBHs0
	D4xb76ABu7ZzR03thXy9gOHJzbc+Mq7ko6fe6slYTxpg2VXAI9yiX9XRT9rEHQe2yn01hm
	2/5laj6wATwSIUb426KIZMOURdJXVsQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772068117; a=rsa-sha256;
	cv=none;
	b=ofVCzzYsCC9eICZoQ7z7z8HGT3hoZjgsZwdypw4RAMkcWFB8LE0jYq8IBc6EfZZIlqmHlW
	AGW4zQRApTcvLYOZ+8Z+dkt0JK9IwLthtNZR3qYcXx5T3iq+oVCiTEn56qOuTE1iZ82WAw
	1NMm2suEAZcPz73Jr8KXOnD/zsGuscA=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 26 Feb 2026 10:08:32 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Add myself as reviewer for SWAP
Date: Thu, 26 Feb 2026 10:07:39 +0900
Message-Id: <20260226010739.3773838-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jmb7z3uhghd7ua36wq9wwpiuqeho84ic
X-Rspam-User: 
X-Rspamd-Queue-Id: 79FB61C000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1772068116-804247
X-HE-Meta: U2FsdGVkX19Ky36dXeMSoR07mlsp/08LgoAJZaC7QpbNOSQAns6Tl/+BFsOAPStKOkCxuCwsS02fs0Vp/SUwUVpDDd5Hpfws8wJ3l3XcC2t/fO/FcEc6DC9WHwLsuOWElxgUtDOpG/jfbpLssjFdfT4zm7RGiNOqmrdbg3UUPJW6LJ7Yp4bLcP+juct41TF3MI7NtkErVXaJnFeKRsAWbGPuCicuY7zdMNF6IgVRknXE3FIrBylrq/ASH309Z0eFDYffp03NSU33oi3zWzMBwk/JSBLRywWyu9ZomHMP5zfW8pYNHS25fq01AKU5jMQiodX29AQENW99j0xgPnLnEfDubm8fKFsQuqOmwZka74WNeEyVsTnb3UggyORXg2v9pYexEGmnsIePjKonV6vk7xNnf4xeb1U/tpLm+XyBzy1SfLHwep8TAmYF4od7eY5CGNHrprZP3ojhyEqExaRIbQvWQn7aLU5xbJiTU5iUtG4M9mcJpNXnqZqTgtXTebC6VlsBtVThuiy//9K7CrZF0RYxW+L+ngUl+faPF/Qjcr6ef3TxzXoaMoaECj4+oLBF57Cz0wiYsVQhluPLivoZB5A3gcRlQwWOk11bMs7OAKSWAQ1AllkI/NQdCrL0KbyOv34rIoxPaWvAa5KTJ4GbYBjmgcxLrz1L2DPImeEdeC5CnzsBIeuoGejqyQufkRy5vXV6EW6sljJbwB/AFCDaNLrAFLBxza38aBcC24Smms8w48h3SjcaQdmvWceAFz4tMg8XE0OXy1/ZnLkbVxAI+DhZr11rqne/30e8E2QHOumptOMbMd1Ra6PlD14NHwn6YXET3ywPJVPm/hRCzRXBDurHmEUN7VSWJoN2ShzdFHOj5BEluivm5zXf0J5lPMaCvnZ76oaxZOB5CmiXDhw/YxDa24iF3c1LI5Mj7eneH0B62Y4RuyuR80Iefr5UAJF+/6xv6irDCnmUbdm+hlD
 /Dhzxf28
 JnCs25Zbl908m3K/VI9QUEyG0CfSIHtvlB+ucVWvQ7dH20nMHyddNGW+BalcOu3a3v68YLxOYMcUyBkA1GLha3d/6ulKgsZCxjAkI9iWgcYfgp1nqfcndBCCoAM+V0Pyba9DeBOI5x+WONRwlJq1Hs3XFStR/thDs1LCFrXLpZOSn5DPOJbzw81dplQ1hFb5IlOUZvTGObXWjraiUBkfBz0MVopZb/dym9t9g44ukMdPAwPxwjV/1Ojlib3mqZt/KaTSzb4jPd/ffqTl1u+nyZA/nfbvovzRS5rYVTOm23DMzqSLwRS40cHQ+2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Recently, I have been actively contributing to the swap subsystem through
works such as swap-tier patches and flash friendly swap proposal. During this
process, I have consistently reviewed swap table code, some other patches and fixed several
bugs.

As I am already CC'd on many patches and maintaining active interest in
ongoing developments, I would like to officially add myself as a reviewer.
I am committed to contributing to the kernel community with greater
responsibility.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e4572a36afd2..8fb7b70dfb47 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16913,6 +16913,7 @@ R:	Kemeng Shi <shikemeng@huaweicloud.com>
 R:	Nhat Pham <nphamcs@gmail.com>
 R:	Baoquan He <bhe@redhat.com>
 R:	Barry Song <baohua@kernel.org>
+R:	Youngjun Park <youngjun.park@lge.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/mm/swap-table.rst
-- 
2.34.1


