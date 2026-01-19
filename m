Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE833D2ECEF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:03:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D58C6B0305; Mon, 19 Jan 2026 18:03:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596F66B0306; Mon, 19 Jan 2026 18:03:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498456B0308; Mon, 19 Jan 2026 18:03:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 367C06B0305
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:03:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0208C13A86D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:03:49 +0000 (UTC)
X-FDA: 84350242620.20.0BFED05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 40DC640003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:03:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f8J/4Vdc";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7hwfO2cKw85nt82n4iGmVBkB9S8A+CcgyBu1vNXXR8=;
	b=EYomUwamfzTQkndPZxltWRPeiUIVrXJo9E6RAc8rc1hYEgPp9e9cZ5mdyQtkVCB0P9QqUE
	losldvM7Wy4tCtQCJbIz9/QoGPB4igtPXUesEgpHYwbRNr23EiMiSuTk8mI1kMcaCoySD/
	UJbLfbdnjwd/ovgaEfC6AhIib0BnsAI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f8J/4Vdc";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863828; a=rsa-sha256;
	cv=none;
	b=aqSAg3Q7+bGStcc3LeTF8L81DC3tN+7e2OAiz6ERIMcpPu1zeyK1lS4uYcJ73rvTtnovuW
	XPDcleldQFSnbFNISqGhvb0yO2bpT9tPNtLfhpofl+iTiQnfHpor0rlikaatBjlYc5rnmd
	slxTz9HrEV/YpDaIlbVkwhlAuKMJAf4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 68A0840201;
	Mon, 19 Jan 2026 23:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19448C2BC87;
	Mon, 19 Jan 2026 23:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863827;
	bh=KZzIizZvvXk5/lfOietMXSEPEGZqiuCDOnY5HWS5lB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8J/4Vdc+eCRJIAoxZbYJ40lQpJ5YxM1F/DqyvPfB4iJiREt/aP0cufXXYmkJTiIM
	 rh0LWKL3Nl0Ig6I/DaxSbZKowewwb6MLwBm7BJJM7POJE6T/6Wb4590Bv4XgR6miZz
	 uCagcFY0+R+8aQpuwm359CC04g5+OYUbM8mPxOLnyFL2g2jXX5Z2xE7rr+QfftChow
	 4Kfzlq3Guc+H5BI7frRkqQcFPbG757vyABP3hefzynK6Qxh39ZXxZ09NfWxMCn0UVR
	 1BRBgGimswwiqjm1cQ0jMqScckqGXfw5zyMHy1U0YopOuZK/DGiBJhdz2D+GLvFryi
	 ae0irgoEhRC6g==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 18/24] mm/balloon_compaction: remove "extern" from functions
Date: Tue, 20 Jan 2026 00:01:26 +0100
Message-ID: <20260119230133.3551867-19-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 40DC640003
X-Stat-Signature: ckaza1jgk3xiw6oeshfsjynzura3nwfn
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768863828-752759
X-HE-Meta: U2FsdGVkX19YEymswcryI2pj3NRpPFA5IdlkhV7QfjXbSPH1/jGCEgegMhy0Ie184izfM5mAFnP62oGhLO4U8KjswzBkY7bvnMA4/oj3Yp10dxkESc5ncWA4fLEvIZfK7R/D1waTY9E+db9aBnfsRFPj96rcIQ+MWL30YlM9ayXKm3aExu2YVxAx6Sf21f8qHogwREi9K7kQUxGsdw7KyMygQ4kCh8gg2RnFB1cXvO5om+V+JYD74+xT3Wi4Q5yiB9692qpk7DD9y0AF35HXrU7WmGdYYyE+KIa/8FtviTiKFPH9tmObToB3fQv+FZZGFgm4DhvYKOfdhTUJmJqgL5e6l/99pjoBOhLhiRVp64iAWXPjz5NNfETUfzG1XaruICt3YVF8d78mZTNtNepUe5Ongr14VyTPTOhmvMZ/uv5Ik1RZAzKgwUEwz2EnBKV2Ec/HsW//ndCgYF1UrfU8ZHBmqmqbIa2/XeXA9oAzBUd+fD2skZkdyzIFHk2LkGEx8KtEGdaEqI5c6nZ69G/DdIYpVh88IOrGrr3dEsZoLpPRNsq9wFMGXKnpOUSuh1YicPkwmMR379snAyYfPKk3MN01HStUExtNzeQY0LjZPpiglR00BOEz8ITaBegAj1vxym6zgkIrjLKLq9ZuPTbXXk+ywOqzVBKLJG9ccFZ+kUHuf8aU7n+zaCTJSTgKiZSyT7Cwpo4l/ScRNCuf6NnKQX2+Cy0EqE1xHg+IJqUE4+11mQQ/DN/F8+dBSK96O9flF9p4S9/vzHJP4dAcrtp0NLB4QFf2Q76sO7L7wRDumlqD9M0yfNyM/kQXU8q8RaS4Bdu4xxEIhiyKUbrhn5aRHZ5YKLFjuuVP58+/ip5EczQJjx3Po53DJTCTjaJzYOkUEyjrGdwD6Lwf7tFBNIMd+YQJHdwUOUWX/2jpvz1u0Hplht2yxx8+eSIcrCi3puhpScx0GpI+WRqSKHU6wGm
 v0PpuJNO
 ja2+JKYk22BM+VvRyd+fdrIYoy/5Fgq4DLBvC0mzQtMje4/VYWL3cX3c24wzpbBz4dlRtVCvO0DKTVAW2EoemUEh8HXVsnU1XN5fHKkxTvd0p6fwUQ5XAM3fbaVXkX66IQvP8PjNeC3Cwi7n/jo/NHsUAmT1TJyHl7QDdY1mw+2a2Ik+FLSFuKuT/1srB6z4M16msD1EvB83gePr9Jgdi+Um7LasCRPhUkaorlkbatGijfC8FpwOoOafZNOG1nx6EA1rLWjZdWXUf+8xBSamG4j7Q5svTiJWlhypCi2ox9MfhD2ysmFevb+mUc5Gq8n6ZaNJ9lr7OIV7Yv+4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding "extern" to functions is frowned-upon. Let's just get rid of it
for all functions here.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/balloon_compaction.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index eec8994056a44..7757e0e314fdb 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -59,14 +59,14 @@ struct balloon_dev_info {
 	bool adjust_managed_page_count;
 };
 
-extern struct page *balloon_page_alloc(void);
-extern void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
-				 struct page *page);
-extern struct page *balloon_page_dequeue(struct balloon_dev_info *b_dev_info);
-extern size_t balloon_page_list_enqueue(struct balloon_dev_info *b_dev_info,
-				      struct list_head *pages);
-extern size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
-				     struct list_head *pages, size_t n_req_pages);
+struct page *balloon_page_alloc(void);
+void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
+		struct page *page);
+struct page *balloon_page_dequeue(struct balloon_dev_info *b_dev_info);
+size_t balloon_page_list_enqueue(struct balloon_dev_info *b_dev_info,
+		struct list_head *pages);
+size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
+		struct list_head *pages, size_t n_req_pages);
 
 static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
 {
-- 
2.52.0


