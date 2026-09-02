Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DFF9C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B2BE6B00C3; Wed,  2 Sep 2026 05:02:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1622A6B00C4; Wed,  2 Sep 2026 05:02:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 078D06B00C5; Wed,  2 Sep 2026 05:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D252D6B00C3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:02:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 55856A10B4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:02:56 +0000 (UTC)
X-FDA: 85168232352.23.91F4A49
Received: from cmccmta4.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by imf17.hostedemail.com (Postfix) with ESMTP id BEC824000B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:02:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=d0XcqTIp;
	spf=pass (imf17.hostedemail.com: domain of liujing@cmss.chinamobile.com designates 111.22.67.137 as permitted sender) smtp.mailfrom=liujing@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788339774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ApIbz5x8f2pYSzlpS8pwscgpAezamK+Zg/a44uxxyps=;
	b=r32aw5CNaoAGmTkYeSO/NGUbKoLPorGeQ4p6NbxdqXe87GF74vm3q9McvEDDFqZXsLbpJF
	Va5/YuHbi8fmH7bd3VymKrzT0kIAzUwwl7EvdVEJfdxipw+E1Bsu9fF+c3fgQw22NMdsrp
	vmdjaNGXYPwP1izB/DLoefpgMdAJ9Bg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=d0XcqTIp;
	spf=pass (imf17.hostedemail.com: domain of liujing@cmss.chinamobile.com designates 111.22.67.137 as permitted sender) smtp.mailfrom=liujing@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788339774;
	b=YNZfdy8+e807L4hsu2T4L10GlYjQ0fu9P242Fu9ntoeh0qZWYVXXqRH67xKCw7k6/y7NaM
	SiVZBYPCVYCYXHdmaF8GNg0FuRDSm4mW6iWT8B9tPOb0MIDDNcxsZq7juTaBZ0V/im3gqy
	d6BdOH+AnB7we28deMfXvUiMjJ4qtAs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=d0XcqTIp+Lio6XNTvjGEJI9ZRA8Md9BeH5IjRgMahXvmLfqVmoU+CCjVGMXJ9VWdQ7HyCnNR/bDf7
	 9MRe+RO+nWknzQfkR2orhYCGasUtjZMBU6j/rBboaKeTnd73yUrRI8/YaNdXiVyjD+DDA/EVTkiBpZ
	 AdzmQvGq/IxyVSDo=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee86a97e636db6-40e02;
	Wed, 02 Sep 2026 17:02:48 +0800 (CST)
X-RM-TRANSID:2ee86a97e636db6-40e02
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[223.108.79.98])
	by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee36a97e636eb9-f1f6f;
	Wed, 02 Sep 2026 17:02:47 +0800 (CST)
X-RM-TRANSID:2ee36a97e636eb9-f1f6f
From: Liu Jing <liujing@cmss.chinamobile.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Liu Jing <liujing@cmss.chinamobile.com>
Subject: [PATCH] mempolicy: fix div-by-zero in alloc_pages_bulk_interleave
Date: Wed,  2 Sep 2026 17:02:45 +0800
Message-ID: <20260902090245.16411-1-liujing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ipjbp5twhd4n1ty1bq4xp9ici86uopqr
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BEC824000B
X-Rspam-User: 
X-HE-Tag: 1788339771-734507
X-HE-Meta: U2FsdGVkX19UbfUHntSbGadNFN43SZPPSaoHaplrIlDyYVsvzoJD+fHuGkqkDMKe4t3TVo3psYZlSZTKufc+P7zxlSMzH/mqLW6Mo2RiGDBgrcLX2UcSfnx88Fjg8CcPNGSP97guEJmgX3Q/5nFpSgCfe3pWsOJDVThLUHQoxyUCaXp8WxfJBqfKiPQm+TCl27Cg+BflHeWz6CwhrbcJPcpsQmfIm7IxCtpou++CLvbFP0LE+ln0APDOdvTH2fzyLrradRKgHz0gu/sHrE+B3VtISyV6mjFNYrd+JCywqice0CS2O2UyuiS5NgK1B+PaO4jszfr9Qn+9QSdPr2BGMZ3hstTMbpK7+8G0LBiw2p6GGwAwhbt8x4W3h+BMms9EOpad7hXvGcADFOQozPHTA1kFJbZJ8V7MFyp4p6OvKys7fjhKU66MSw50On/+vXFYjQLy3MocUVfIRQ5hiYIb02ld7u7q7VLxWTn3HkZv7NHfdO/zdi+rou0fw23rwsgfMug0RGwmtIZDlN8jMZJXz1bXewbh+d04J0vM0vmTRQtRiqrr5Ez44AIuqmVhhBeiOrnVA6X/Oyfg6bo5kS4jzBTIBJIBOY2jsYTWjAMv9YaZbA2oS0M2Gw+fr5NAUggMDAAepFvqjxLsHkunE0gQJdOlPyNbFWgCwwbNPhBiN2D87bbx9XGjuN2+Ri60F9KaGszp5mdE4LeA0V6Vrf1OgPHVY22zZYqBHjeTZD1XnUPLCuPKuLOeEM5IS/r1ItfHSK/LEfhrIAw6m0J2+Z14dIA+uZ68KJVZ97RQwx3n6vkjO/Z1qKMcBHzCAxjcl8bXkfz6O2nr8NXFS+wBbT1bWjalkI+a7sshZuDyiinTfIa12qLRDBPH4rSPuYVgprueY7dmF4N+fg2jCfsry5O46Mq/u1EiUeyQzwPYdtf83Ke9cYXp9CfawR915BNbctj1RKDKuj2timDxOZqPHGa
 ZrogWqbS
 r1n9pv9ueO1mSBXtMMFuGYB+UKR0pFKintv0ckan7oQoxlIVqOxJPq/nibJs/RFzhoBDjZ4EFNI96YqbCWGY3tpwP4oNPsFEDV3TYID61su1gC6gjphokTXa/DA5gVb2xptpwZ4j2e1IQZydoUNl+WThGeCRmSaZwA19/63esYsOXZ4nCI5Ldcv5g1rANG3pePG2nr5rUhnziue7+Qz1hmsz1npvuplqwLKotnkQRpDRjSCYhfLx46IbdmkJakEdC+YiSy9+LXkhqqheUciu19lLbazByKqtwJJPUWEeJA5sBbEuOVFSD2vCyOeUi29lEIeMYGyNfC8UCMjXhOi+dSIgR2Ul5Imz6S/qyxSJDOk0+Kyn5Vb2K3d2WllJLwd4r8IcM/fnXgOrdNffFTrRUfbbzHSBnV7gT/uOwpgxabtMihG191TpciCQYWpFljxpcwu/c07CqC48gqwG4tj1vaoVLh9n0bM4pXKdcslgkUF1QYbht5m5oIEfIsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In alloc_pages_bulk_interleave(), nodes_weight(pol->nodes) may return
0 if all nodes in the policy mask have been offlined at runtime. The
subsequent division "nr_pages / nodes" triggers a divide-by-zero
panic.

Add a zero check returning 0 (no pages allocated) when the nodemask
is empty, consistent with the guard in
alloc_pages_bulk_weighted_interleave().

Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>
---
 mm/mempolicy.c | 3 +++
 1 file changed, 3 insertion(+), 0 deletion(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2600,6 +2600,9 @@
 	unsigned long total_allocated = 0;
 
 	nodes = nodes_weight(pol->nodes);
+	if (!nodes)
+		return 0;
+
 	nr_pages_per_node = nr_pages / nodes;
 	delta = nr_pages - nodes * nr_pages_per_node;
 

--
2.43.0



