Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8112CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:41:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07AE78E0020; Wed, 24 Sep 2025 11:41:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02AC88E000E; Wed, 24 Sep 2025 11:41:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83D58E0020; Wed, 24 Sep 2025 11:41:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDAA58E000E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:41:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8224B140846
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:41:40 +0000 (UTC)
X-FDA: 83924558760.11.61A45E2
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf01.hostedemail.com (Postfix) with ESMTP id 17ABA4000E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:41:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758728498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bc1yMzhF0krxpSU+n9zRh2Tq4R/BcW/pLydDRq7/20A=;
	b=zJPi7mIqt0TnYM4dpkZ7fHw6qY0bAxF5hovGH6QRgLeBuIrVV11irIfxTadAS/CfedkSLh
	poVzqMb57j4x57pofpO36RWBFiR6LcBqO1N3/b3GhHXHKHiBbgXe5Vpv1erDahyfGC4UrZ
	2KnUxTlJ3tzSHdP7lVA6EeexkOGp1/8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758728498; a=rsa-sha256;
	cv=none;
	b=fTDfECXHkJglhBtyHzurpa59OBQeyF/DbrYm3CZTXF1kXNwMAjbzLLZYp6HGIp5J/J6kas
	5tTIH3YOVfUy22g+6M9uDsTSowrNX7QDQA4Phs54iMLpUPkPI08ISZUrQzhMTlZW1yr01i
	N6BoZIY1IXhk65JzyDHa6HKbVxg46Cs=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 25 Sep 2025 00:41:32 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 25 Sep 2025 00:41:32 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, baohua@kernel.org, shikemeng@huaweicloud.com,
	nphamcs@gmail.com
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
Message-ID: <aNQRLGWlORrIpPmg@yjaykim-PowerEdge-T330>
References: <20250924091746.146461-1-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250924091746.146461-1-bhe@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 17ABA4000E
X-Stat-Signature: knh3rub85ghfbkxj9tmmpo4fwtbsya7m
X-HE-Tag: 1758728496-884193
X-HE-Meta: U2FsdGVkX19RmCS1jWJU+TtdVyVK/L1BdXMyWdtx2OHyxjI1BW/7xoDCJJcDZIyVd11GLCQM+BXXDuND1t5iRRQIav6KEtMTPEdAXOEM4V4zl2FCCzrXULMr1OUSLDZPJGOEx0ojoGeexXXiofeKNvmrm+D0EB0hoFt/tHbBlr1B0tlyksCnVs1jOVLAXrkjAIj0OhghCnLn6yrf5I5mxe+f0RNK79qtGJqxhmcxv38Ho6XBf6jfR/1YzUECNZkJuRmorgF0eraGCKgmGJxwRBBaUbj1YmNxLHEwlyMoLG3Op1ArAcAu+WUzuHR4qKjtM1T/RFP2A88R0m2r9pfT1cnJDDTki719il8yMrzxiLifhHdKPR0BLoSeQMxpKnMI6FGqX7tdWfHk6y66zX1ManypcnfdwCc/+eKGMpM396W3iPYQF9M3sYHe3PpUSi5udJV+Im8Q5Q9jwxUA8EjN/gY8uF//dLd0FD7runqvVyPuz9tCnnYx44ZX0+26L7iE2VRJRMCIe2caSmEGjeB4uxTSpjhmrcGmeB2oKWYU+SPGzdnDIJ5902LJGTVY8Han4t2/1EOqiqmrb5DUfhuLhW1Tk1V2OxNg00GGcWE2x8NLmD3Ii/brPZfisWwGvh3m/xvgjkUgf+1q+gvZc1A/5o6bcinVILjPo4k0LXVXsUr7CIJLUAmXsHHH98kUi8XVNtS1N688DiyV4M8fB8K00u+97OMsL6Qwvm08UI4XwIsIWxdC8CF+iCWlyWqFJOIrgscMNE4m0r+hXe+fbAcZdB5qk0TFpVQcnlenoXJ6zxF/2ugBANlvPNSValFa+LcStiFcFZapV+AInpJBJ+xSqLPOwxytOstdzVI3R20Gg89VMkoAIwePOqLKD5MozvHkgBaCoUWaPKuHOe7tGIIynii16Lbzw2ljPe9YV9Y7XB6wTjpG95qcgXLRvfYSjc3p06nIEMeDkRvdZj+e6hK
 0gA/eBqF
 2DB2+Hvipe0JBX7rPL2E05Z+OlPQc48VKcS+xmnUyBAAov5Xf+5NhvDqdwnwbD52cmcxNs3+QaVBRN10hbJQdD6xBtEagyDFRIX9GDdTtyJ7V9/EXpFGnq9eoKX0+FVSbQd9+s/Rrdozn53PaqgFd2NI08E35S1Mx6Sphw9Rb642ddWcY9vsDcd3BpJarNPoGI+fC5w9wnreTZL34TOtW13F1xje9LSOmfS/rvbPKnU8znUnURxugwjGJfYZZ36E/6g4FMP0WKXJpLnRWsu+AJiSIGWx6tWCAegDw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000064, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Suggested-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  include/linux/swap.h | 11 +-----
>  mm/swapfile.c        | 94 +++++++-------------------------------------
>  2 files changed, 16 insertions(+), 89 deletions(-)
Hi Baoquan He,

Thanks for working on this patch.  
Shouldn’t `Documentation/admin-guide/mm/swap_numa.rst` 
also be removed as part of this change?

Best, Regards
Youngjun Park

