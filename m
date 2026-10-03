Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58BE9CA5FC1
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 06:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D07A6B008A; Sat,  3 Oct 2026 02:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181756B008C; Sat,  3 Oct 2026 02:01:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 071816B0092; Sat,  3 Oct 2026 02:01:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D97336B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 02:01:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69CDCC090D
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 06:01:21 +0000 (UTC)
X-FDA: 85280267562.03.EE84BFA
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf09.hostedemail.com (Postfix) with ESMTP id 403A9140004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 06:01:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791007279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8PbHEv8izSKbYwrwnCZfg9pd6cwtBbIAIkZu3b3fO4k=;
	b=YziyuxjrlKgVXdrOFzRCAxwvKxl0wFhFOD5+s6VZ/fk1ZPLJHdRel2pFlKGtGsI5FpU/Nj
	BIoGGLo+XShyNzmAygRMvRrIcE30VGPU2ouKW4rG1D08AIVGLyoWcF6l8wVGmCMKxod0hz
	NLsKLqk53YnuhTLi0HRBc/5xTo7d5Ds=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791007279;
	b=vreqifFF+0JaDlJPo5DqpRYFOVWqKbISTL1ATvbNYxeABKxbK3S5Cw3fIp8pnsQDU5Ylq5
	Mj8zJZMkcgNO/GsleppZJT4P8qugmliJ6imxXAG/ISDzfVGc7k9dqBVaem/harISie1fqI
	NV9TW2n/WcHY9BOCByFjsi56m/bblAs=
X-UUID: d518d70cbeef11f19a56ed5b684f684d-20261003
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP
	SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:c2f9a782-b875-44b8-8b2f-1d460e9e9de3,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.19,REQID:c2f9a782-b875-44b8-8b2f-1d460e9e9de3,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:7db8b62,CLOUDID:ee5ce49d2d2fb665b8389a4051ad5556,BulkI
	D:261003140113NOZ9QDVA,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|136|
	850|865|898,TC:nil,Content:0|15|50|99,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:
	nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:
	0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d518d70cbeef11f19a56ed5b684f684d-20261003
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(175.169.70.242)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 302574845; Sat, 03 Oct 2026 14:01:10 +0800
From: Enze Li <lienze@kylinos.cn>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	sj@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH v2 2/2] mm/hugetlb_cgroup: add trailing #endif comment for include guard
Date: Sat,  3 Oct 2026 14:00:29 +0800
Message-Id: <20261003060029.2152489-2-lienze@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261003060029.2152489-1-lienze@kylinos.cn>
References: <20261003060029.2152489-1-lienze@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6q8tzicpgqch141z1ynxcrqm6owrxa1d
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 403A9140004
X-HE-Tag: 1791007277-660783
X-HE-Meta: U2FsdGVkX1/NFUTAAexdVe1cZh96BZv7FEReHZVHnqFeWz/l0YzFE8j3NZUE4jxiAGcL+JvprwU6gWSs6woFWzEveDcpeuJSoUrdZKvE9AS9Tn9vGpQM0+XFiH7tORu2tRoJ2pYSd7o3llnaJ3gy1/QuhbJGQuC4EIv9eW9hzUtplj1DOEQJfPXyVeot71MN/4tG5eSjw7EPiqh4khp90lXzqZsjGYWUR0pO0QqZQMg3bgWzDAgX92JUtCpdrQwaU8AXLkY8oYoIjZzTZBQ/VXFN36JzJdPSyjgfXqSOxxepK2JAI9t+nrd72OOTMWdUSD5j4xuLjX1VSr2gZprJBz3IwNNf3RvQ4L685xg8AFMdpbt4er/7W2QzmCCZkR9lKjp0m46n+zAGPsuANttOoif4bo8zR56kbPBlgLc/d4nK1eqfUD3Z4DIdBTNPOlYONSbKkz+eOLUBf68+Uc/K8qBRFwEFTbxCuZlpLe26C14Gcd7ZcxuySzyTcyNlJBI47ySagbb8YCmrw2jCY0tXRg1UrkEPJF5nsiJ202ihPBONu3PmDkF6BYc+8ENfivw8b45+JtgQkf+Ap/4iqHZHS6inyL3DsyZI3Nxx8r+u3czvGhwJFTX0gsBRcWwBjTd3tdyQsSIupLwU8a2qBCZaLckOccJpYYH20qThXWEdTD2+tLbPntxqpw6yy1kk+vv9bqoJrxrBTx55qW7SQVNkhdz45+fJ2TsOAEzwovCxRq/BtI/bYW5j0Db2XMB/Ux7IbrHVtShhfPks2kSraAa1vBnxh318/chJAB5986zIYvYzn2YMBYsxpoBLWr+wwqHOGBoK2DgsTqUhL9pT4XYeNKSgJyQgGPV6PUh2XkmS86PZbm/d87LOoGn4OFPXwuAORpNy1lBe8UB7TFNSJOjK4vI2kXheDNLGnPzBn4W4mcmU35dTldnyLUicnziqm8gaGxQPZOcLF8malJ6H58h
 iDFXcPDE
 Pp8U03voweubXbqZPPeC90FTBy3aYPZNHXGuSna+dwHTjWlY4WJpSni5jyUlnSMQUibRm44i6me33sKxMPaIurVsngShnpqVL/9KNDGaVoIN0+YY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The final #endif that closes the _LINUX_HUGETLB_CGROUP_H include guard
is left without a comment.  Add the macro name to the comment for
consistency and easier navigation.

Signed-off-by: Enze Li <lienze@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
---
Changes in v2:
- No code changes.  Carried tags from David Hildenbrand, Muchun Song and
  SJ Park forward.

 include/linux/hugetlb_cgroup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
index 16d72c8c71f6..b4e0958eabf3 100644
--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -268,4 +268,4 @@ static inline void hugetlb_cgroup_migrate(struct folio *old_folio,
 }
 
 #endif  /* CONFIG_CGROUP_HUGETLB */
-#endif
+#endif /* _LINUX_HUGETLB_CGROUP_H */
-- 
2.25.1


