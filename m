Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33303CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 12:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E12B6B008C; Thu,  1 Oct 2026 08:38:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 043A46B0092; Thu,  1 Oct 2026 08:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9B186B0093; Thu,  1 Oct 2026 08:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA3666B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:38:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48D3BC03A0
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:38:20 +0000 (UTC)
X-FDA: 85274010360.18.A0747C9
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0DE8F140004
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:38:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790858297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rk3vPvtO5GtxfYf8XDi9e1Iti26o2AkukBliJycgmIw=;
	b=vZRjivtASPcUD6uvjInSC2AWRCJYiqC3kqs3yu8TkBY6RM6KdelDJRUFGNbHxv5Mih+Bmr
	KzQxahAQx1YWlFEYvPCZVx3i6l2pd4hJy2ZEChv6HHC+qyG3ZxNs0VBgOQlBRRCtXkm5K2
	dKEWt4qaLwPrNSQ9eC3id8u3ZXb9cV0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790858297;
	b=Xt97Y1Hk7iaudoIFGI1TUEi1877xuRDztB/b6FLdmNwZd+dwraGRSUb7EF6xovJtUqOyoe
	0fRN+RmRXq5LHA80pG9xkPrG965E+77WIJ9dprV9VwWgVbZf0h11ywilKx9iJt/PLPFYRg
	WemVYrllJnPbmkjkkrQl927iYXCQ3Cc=
X-UUID: f327519ebd9411f19a56ed5b684f684d-20261001
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, CIE_UNKNOWN
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:1ad96293-5900-46f5-9ae3-748418130015,IP:10,
	URL:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-10
X-CID-INFO: VERSION:1.3.19,REQID:1ad96293-5900-46f5-9ae3-748418130015,IP:10,UR
	L:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:NOTI_GNA5D1EA,ACTI
	ON:release,TS:-10
X-CID-META: VersionHash:7db8b62,CLOUDID:a1702f7e8908a528a7c6c0191515f3f9,BulkI
	D:261001203357ZIFNXMEL,BulkQuantity:1,SF:17|19|38|66|78|81|82|102|127|136|
	850|865|898,TC:nil,Content:0|15|50|99,EDM:-19|2|-100,IP:-2,URL:0,File:nil,
	RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DK
	P:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f327519ebd9411f19a56ed5b684f684d-20261001
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(175.169.70.242)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1435091775; Thu, 01 Oct 2026 20:38:05 +0800
From: Enze Li <lienze@kylinos.cn>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH 2/2] mm/hugetlb_cgroup: add trailing #endif comment for include guard
Date: Thu,  1 Oct 2026 20:37:47 +0800
Message-Id: <20261001123747.634845-2-lienze@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261001123747.634845-1-lienze@kylinos.cn>
References: <20261001123747.634845-1-lienze@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: awipzaek1g4zg834nrgw788brmzjg7ok
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0DE8F140004
X-HE-Tag: 1790858294-38329
X-HE-Meta: U2FsdGVkX1+R+goen2ht19bD/oflhkwCdUbhGubG6jhhiujvv7yAL/uhjyauROUdHYF6JggxP0Jzpsch/B0M12UJCHRiOwx9JUfc8BFMh8WqykHvN/OZgN2ONSTGkfQefnVNn6n/cYXRahom+P0SbT592T5o4rQ3WKSPAywmMMhauFO//U12NpHX/U16kF2LSK1/eRlCk6SEoY0Q0Db3xzEKkEWCsLRrWYWVd8UuDaNRt16q+1xZK9wZ4wGY0YpAJbZE3KkwSVERApH6huJvoZf34/Nr4sZNfLhbt39ns2qEk/mPQlV5NDh2AdgARfMtg4Xv+SVNwwdZrD6JJUhDWhENu1YcCk4l4WV0mSZACj7NCv6QoRzkqNM5j9FZXpWnK5iLDluYOuLzJCELV7Z/XuLTYwlEaFkm97k/AhewQ8i75c+F6ugYnwuSlqqoEIRpSObKVY46aQY0CV2LBmpK/8AyYPCNDNnyB20iEymsg/5Qo4VCMfi4dxFEuIDHy0MItnT2gvVKff2cUgjm9frb9JEbw5CZ9YVwkzC37r0w2xOvSzGUosTrh6us9tkPbVDxc2MJdrFS8URN1gvJEHWgOHSWSlLXzFmLaZz3TApUMpBbuNVm2UiZPNxWWavcgeBzBhwPp0przdes9LJbUw4RKulh6QlJRVv2jiEIHm4jjbB4hRt8CMd4a7mIVXkcvkYzcm8GBS654a2BtfgiYV4dzlwyIwHofFIPN9xbaL7PsbmOqvq6vbYGINok5ygvephmm7n+gQw6RzVMDbOmRgfb/f6Ga14YQMyyYefCxjC1405BGIuG2Sm44eW2ab6xr+TqVWGnBjjEWOsziGPfCj/2K3HWoTTHITAD4yIOukCwl37GXnWxeqGnymfHedszvmhGhXzBcNjeW/2grA1GBz1YEo4EwHc9nDjbt47/rp0vCtGoJhqe3weeFEXanKRD4IyJzSUda3Stz2Kqi0VOcuI
 0FI6phVW
 VTJV0Nldp+ReibGmXzxPrwrsZvWAWM6soUrwtbFwEvXg/hTc=
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
---
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


