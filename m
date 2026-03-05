Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18CD9F33A6B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 14:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55B906B0089; Thu,  5 Mar 2026 09:05:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533EE6B008C; Thu,  5 Mar 2026 09:05:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 460616B0093; Thu,  5 Mar 2026 09:05:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 338F06B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:05:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C1F99140143
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:05:31 +0000 (UTC)
X-FDA: 84512182062.23.0B3D263
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf26.hostedemail.com (Postfix) with ESMTP id C931614001A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:05:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QuKWDsVD
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772719530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OUBy+8sEPr5bdVEJymY5zJ8s1k1i9PEe1Y7EMp5ZRRA=;
	b=koR6zSXr8xuyccgvu/d0wsKA3i7+DAcSD46XAeEKJIDJRtra1Mn8DciGOr5CUX1AQBjG/E
	5G8ybhjEpXqM8KW0b0hy0YQeueTDcN38MFgOAzBkQ17YIkZn4p6rmTfKNvGkIzKi8M/Kc4
	y1lwZbNysHr/6vQiqADg2ZTTdVvY2kg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QuKWDsVD;
	spf=none (imf26.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772719530; a=rsa-sha256;
	cv=none;
	b=IA0kqrlAaetmMohikqlSWuiWijOm6VVelDwb+4DncE53KdVUSKHnhXIhxsi0XhmYlYJAaM
	uW+YDpAdTGhFxNcciesRGeqK2pGIfUBJNjE8aqXg/E1Ca1Ymvzznt/c2KfIbbdFIubpiww
	Cj0f+SBAGXTi10Cbm+c8cOTHWFhJhak=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=OUBy+8sEPr5bdVEJymY5zJ8s1k1i9PEe1Y7EMp5ZRRA=; b=QuKWDsVDQz1shNyQeTGgni08ME
	2elu9jXTJamicv8b8VQSFT+5vNVjpBataWcO+4O1ZZKvdZuJf8/1N20rzDu5aTzRXdfj1zmG6KO9Y
	741KivVh0/g4zQ8/dNYDBoEIScuk/0mOjZIKFW43tEJL4xbUMmfjXiCgryCMUd2DnvkyuapFuan7i
	ix7tgnLQp1mb4e+2ThJqwD2DS2EXWhXAEXoKynpwZ2JNlwEnsAcCYoR8SKHwPDS4FaZCBc05YFVfF
	1Cee2xFpbg0U8wFXBcJmVwZ9S575VTE0mvQEPRJV49pWdORyi0ukS9CzszSSKvQW/OcvCOsGCZ+zt
	uMWA0vwg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vy9KM-00GmPB-Kq; Thu, 05 Mar 2026 14:05:22 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 05 Mar 2026 06:04:53 -0800
Subject: [PATCH v2 1/3] mm: khugepaged: export
 set_recommended_min_free_kbytes()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260305-thp_logs-v2-1-96b3ad795894@debian.org>
References: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
In-Reply-To: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1489; i=leitao@debian.org;
 h=from:subject:message-id; bh=EG6CHi+pTEhduAjBnWyYsnqK4E7lPm6jKVUTFHdusKg=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpqY2VjAIvXSLlnWrKVfNCZo+uzQhZEW+Il7PQ1
 UZ7i6s1niWJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaamNlQAKCRA1o5Of/Hh3
 bZFRD/4zhlJBeP5EInd/GLNKjV8cfjlhT8PyECvyRyoA55Wl3Z8luO/HaJrgGVq/Yd2L21ra3TC
 LNCSCp5SxnkyxIFZ4PEthgv+ZOhXDmBph6yZACSx+OihrFWzEmhQY8O9qaQK9oo9mDtRmnYOHKf
 NJiGL5H7dGueNVy4vFFBT0hMbmHnHxkBzJwLV66JAZjB1LWPCLE3f/U7mm04C6kFJ/lTtaPlkah
 TkQ9G1re0o2C45UphPJqFyUpviadH7iG3tkLSW+cWDKkGZziHXzmw/oAoR3LVdZ/mC5SKx1ukH3
 xsg7eSGPZVDZYA/WYJuJyDjCj7XESMg2YgMNQJaKUFjj1dvHfOieL6njMb6sDafl+uob2PzgJwV
 fzhJwXkQvxq5UFUoXhZSkRdmdaGZr+Z4WcLaVLmZqvEtmzhAnqJcdzrmrbLmzPWmU2gWfGAKfku
 RShrQTdRdLggi5NIWVgtGcd69At/IbA4J1nWLLpGqwpmXGHyfXICh69KNSXaIm/Dzh2psjLp/qa
 mZRNY5NgFu94NGiaDm1ygHhmDcikvwTPEbr9640ZM4AatLyGceNA1H/lkMW3+PJdsFK52GJ8TjT
 iAeedAOfEI1NmiwmGLHnwzFNfGvJ6+gqVpOkzkPRiAUdZWWF7aJhrgph3wqcxD6nGuLPJeXY5Rh
 KqAYJmlFqjgNF1g==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: C931614001A
X-Rspamd-Server: rspam07
X-Stat-Signature: nq7wgbxem3ygqcgc8ht3d9p9m7euaq4y
X-Rspam-User: 
X-HE-Tag: 1772719529-247926
X-HE-Meta: U2FsdGVkX18kIFpx7QqtprjXYujoXu3GNGn9+eRX3SfdquUO+MXz7zaRL1OE6sAe5UXCGCYCuC1yhhwPSAE20vRBA0WwFxNhZcpbJYEwVb602ObPn3AGKrLGh4ayOIzy7JaqAHI4pQRbDF07XcJhRoPg8jzuRFjMrHmNEAMXAjoKJYzb1sICHnpU06XtKh0pTI/biQ9Ufnzsa1cpCLLYilHZZJZISQvEU3IdwHS8kfMMuq9zmVnriVQD5rBY3cOVh2/PQlb3D3mFrqTsfngUGyWMXsqqoZiNPi7NONZzbh1CjOVGZsSgZMAVH1cgkYkMve5ZvYM6QNrRxteH0SWSYqTb+OUoguh4viSm2gTqSVPo34QqPA47I18lEqscjrMVeS3Xx8uqUcATXq9jr0Vp4Tb5WR2hcH1U0GFOS+9kxmOPpytbxwB2kiaa6z3AmTw39P1pAmvxR8Y+S64oXy/WgE1lPC0zC3olra0/3oAx55ztWTqOpYpHK2TPuNNZ1umPFoFaap6aL+W+HJmAFNoGjXAqwIeF58QvSyX//zAJCn+0D92p4AQQBhT5/9Cn8DgD3T9MNjLlxnBzNOgMViQ0UdL8nGNBvNsXYLYOSvd55z4TQFNMW7bCpqjF9O9zSEymD0YOZUQjPrdvwXrDPg9yl04UZ26vWLcJrcm3DFlM4BLEPm+5z9Rmy023PAobESqa4Uxkt9j5ykh/uaOrBNpY96RURnjl+K8aolrIqxVfToWL6jOLeZ1AyxHKdENj4h5WlZi6tIOAMKQPj0dCXhFW1BNYsjVJ/XANA3f48lUpIUScsQH2Fwuy+JFBYQJrhecyA9sBs5VYR05TRlBP6f+M0kNc0U82mFGdV1Q255mqp6AJ3eoP5xRXaFcqDTRZTXAl3F1FwZueYY5n7xHCXoQZoAlpJnF3cSb4AvzDPjrFLzO/CqkBGTDTCa0zTlaaWM85M3EYodZrMtLAe9xtlNo
 PHiAax+C
 v5GzJyjB1Bt5Rn7P1kYc1UIh7ASmJ0oV2aygV4Wbs9Dwy8z6m3TV1P1bU30UD1OOT5UUTVruPDP9+d82mR4o5YpEn85sBsqpbqAepVWi+YpAi7ro32ZIpavzZsf+6UqcL+iOoPNczWW4Lh8Ar0Z8CVyUBkVfHwUnaXDrFF0iDMkoQ9C/3h0mKScZTUgQhmjwjatksFaArWuXWb92qqtZCCVcaDF+gAGIRCAW8QqFpKMsAb5vWRlCYioRSNN2d28CgXJqpaEb+eluvHNA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make set_recommended_min_free_kbytes() callable from outside
khugepaged.c by removing the static qualifier and adding a
declaration in include/linux/khugepaged.h.

This allows callers that change THP settings to recalculate
watermarks without going through start_stop_khugepaged().

Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/khugepaged.h | 1 +
 mm/khugepaged.c            | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index d7a9053ff4fed..76252865fca4b 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -16,6 +16,7 @@ extern void __khugepaged_exit(struct mm_struct *mm);
 extern void khugepaged_enter_vma(struct vm_area_struct *vma,
 				 vm_flags_t vm_flags);
 extern void khugepaged_min_free_kbytes_update(void);
+extern void set_recommended_min_free_kbytes(void);
 extern bool current_is_khugepaged(void);
 void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 		bool install_pmd);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1dd3cfca610db..56a41c21b44c9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2630,7 +2630,7 @@ static int khugepaged(void *none)
 	return 0;
 }
 
-static void set_recommended_min_free_kbytes(void)
+void set_recommended_min_free_kbytes(void)
 {
 	struct zone *zone;
 	int nr_zones = 0;

-- 
2.47.3


