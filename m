Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78722CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 21:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31B268E0013; Tue, 21 Oct 2025 17:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CD818E0002; Tue, 21 Oct 2025 17:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED9D18E0013; Tue, 21 Oct 2025 17:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC1888E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:22:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A54DC11AAA3
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:22:22 +0000 (UTC)
X-FDA: 84023394924.09.BF087C0
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id E29CF140013
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:22:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rin4gCzh;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761081741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Jij6kmWq6kT2URmFtdprAt8/qQR0HaIQ7FSP/Rz2EY0=;
	b=mAUlIBDiqFkzhGE8McWexw3opA8aAxJDS9c4mh3DKFFUdB9XrKO+6b/dEBZm69VIDSorjL
	LpgEEbCn3jQHnIxol0UE+C+zNOIuL0B7nMLo803Z2hGbNcDIKfENEdOQKzBqWZNzrHs41/
	6sNR+KLVaQj9h/1MWt5ShXm8CjoJFqg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rin4gCzh;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761081741; a=rsa-sha256;
	cv=none;
	b=1KaChXt0bYyujXWxjVJ0TQ7UmCWY0jIazc8DeGK3yS8QKivnzbuPgLZ3BIcrUdI6pefSpp
	RRqgBgKvo7dH2Suly23GUZ1QUmPKYxmihG89Ew14NhATG2YZPl6LV7+fPQngsiOjvbPI4b
	nWEsEPvU3sWCKVBl80ym3yoVYejuQaw=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b3b3a6f4dd4so1156730766b.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761081739; x=1761686539; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Jij6kmWq6kT2URmFtdprAt8/qQR0HaIQ7FSP/Rz2EY0=;
        b=Rin4gCzh0guQafPzgYinnUVWb7TyX+0hGJpLw6+PiYtUA12G+vRD3rqp23S+vN8Uxq
         TRw7p+zwpC+6grcAaxcX0RfXiTnCu4w/ARvvUvvYpfs6+PaK3z/NQ4Ozjl7rgzJBP5MF
         iR4qhNRc2K4h3fWZrUKf18asMaAivqovT6pdHLAwQPs8nnJCrPRJEEEfdtZO7sCxX8ay
         eYkzdtHpjlVLwcw0WKn6moVk6g4nOEfIBaq+QJPnLM3nyWb5Enq399mfI7EDUea5IB0g
         i/qN5vGb3/XF5yuT7W3L5JP5pUAaWDRiU/7NkrsPdZC5WFyLOA4xGKigVMFtSQmZwL+P
         RtvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761081739; x=1761686539;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jij6kmWq6kT2URmFtdprAt8/qQR0HaIQ7FSP/Rz2EY0=;
        b=G21Asmb7esVPtuAaOE2Y2i1L5MwNGnBBWMzKo7lKEWmLdNW2bNvY1jWXQGat5ar+jR
         VnMkt7jKIvtbmvvOgIY7xzP1yEFd+klXtWaHGrQecLwQRBdMo0pfaDyT/N1w+mSII5OK
         Xs1VE0vi4g74aYw5Bb2tpDCbro8y3U3LUksHtLuwR3r490n+CvLiCz3N6vyF4gi35GX0
         gDEjY2iQ0BAfQ2gd+h3Q3NCtY8GUxPvyBhfwMV6QerzwQIpmzzk/GQwkH+j6DHGZ7X+s
         svGD3KoyDfhYyARQvIVvHRkQS9xTALGEFsdy9NcRBMj51g5vsdXesf5zQ+WD0efc2dJx
         1IqA==
X-Gm-Message-State: AOJu0YwvS7yYvI2Ls5zgTJL634/SWqtvU88muE7DJVzL6i1p6HMByWdq
	h7nAbbP+ZnN+Vne1u+YeBryKf+879Fr1dYtEZFolFduAa4BcQvp603S0
X-Gm-Gg: ASbGncuS9PHrYHKPexiihCic3vN6KNzsrveLyohfKa6FnFAYqH7zV7RPP0vsOUy+kYE
	5SdbmraYNH9hEh/OfzJ0AALpvu5sXc9NteM4QNCpoVFP864vIicR9K28DtBh3W2H6y4MWVe12ME
	nE01Ci8weIq5YA9f9egH4vHfz9foSyYhQSECM/7rMJX5YbxrEQu3wzH4VatyhEuz2pWYrBMHEQT
	mmnd43Vs8Y3f9RbrsNiXexP2bqoV1QF7eNj6A9XwdM6kTVaIG8VZDzGwSnwQicuPtjk6c0ctVnv
	bwfZ13a0gj6LzBE/hvhoera6SVGUq29RnTvTT3BJZrPFa4InnoGY2yFSH9+UO6VjiNtz3Qg8YKn
	s+N/4j7fLduD4tuWP77ZAqqzqZpPkp+aOqVoARrQuUWezWhKH9cTWX+YrTiLXg842IuWpMezsbw
	8=
X-Google-Smtp-Source: AGHT+IHUafSc+fqrquP0RchJrnJIi0gHLAwLJmD1FCmMp9IF9Y5Km8YAJIYaxt4fPRfJDA8OllFjEA==
X-Received: by 2002:a17:906:d542:b0:b3f:8210:d058 with SMTP id a640c23a62f3a-b6475ff51d9mr2119109366b.37.1761081739247;
        Tue, 21 Oct 2025 14:22:19 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b65eb035bafsm1175707566b.42.2025.10.21.14.22.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Oct 2025 14:22:18 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	wang lian <lianux.mm@gmail.com>
Subject: [Patch v3 2/4] mm/huge_memory: update folio stat after successful split
Date: Tue, 21 Oct 2025 21:21:40 +0000
Message-Id: <20251021212142.25766-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251021212142.25766-1-richard.weiyang@gmail.com>
References: <20251021212142.25766-1-richard.weiyang@gmail.com>
X-Stat-Signature: q19s1i8n9z4xxgyopn3smuj8fp3hqtkg
X-Rspamd-Queue-Id: E29CF140013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761081740-602709
X-HE-Meta: U2FsdGVkX19G4WfkGslRK6wWKDK+jSQGJta0ljleOS+qw9X7ZqAQNY0QGddm1dY/7UNNtUs2Db/HRQv/8z9b0HPz6UEEa9DF6cPktYfLXNhcQsTZQCSfc0ZMv6tSzhGBqskPxM2SyjFD7ShT1bDsAioR2yoN6QBtfOspd2mGZx91RO3ayRd6PdVD8nyHKmspp0OvNds2xYCNcnslteXat5FYs4aewka0BvTKC3fRXg3jpvFpXS5NlIpI6kxR7bl1jhURqz9Wou+OUWov6GbTSIPaZyTAuJlivRAs2QJQfQuZb6zT/hf+yAA17OXG9iCwWVMHeYZJzVhkL94eJxIxqt9QKmNECGN9ULBzC9cQy71wd8I23sfY3qwVmZTn50XKuVceNKGr5n8DJvQWbOv4GA1xXNB8bwbYZYodbtpx8QIKPr4v9P4A95KnwcoTU6xdadZ7F5Ia+Nlkk5VvqhAvAZrCIKJwfWnUnOtTqBEOXhwiI4O41o2TgDCWv4+TTxNBgHt+aSPmB0Zr7AF00o0RvhJ1AbuDN8mxT1D+55vRuTlnrJ4uOPqKo3IAhTysRoBPcb7KoSVvYw2v73ua6bTqIdk7RCv1IMZYpltUtAmM9cO+y9beWp9+bII7EBFGfdyuzbt6pw9VZdGfMo/Jru5E/OpLROOnDC43gP2Kvr5E6sNFUYa6n+7kFg81iWjPbH7o3bg+4gE5PRl02NOjgmyP9HYrlUq08jlVi+1C65FqC35p/9Rif9sCu+f7l/OlZTRbnpvi5kLhqJIFSposbN+J/7UvtEgFkDj93GYs7uDq2iUElI66Wbt7110j+xXr/QqrNUnQOo7OOH9EUVDem9etmNCmQyU2o3QcLX1wNr5rcp+KhYv7ig1afB3ht8eKC1S/4jbXGMLkstWmtWI0bx37bVM96jNwu/fqIwCu6AaPlaMkeK4JvrNk7Jg7eSans+rMZfJhZaKBxeg9a9YSwKp
 3AGJrDIE
 M8xTcAb7+/qtDOTLcY2oM1z665uqEe0g+ydwfzcVVX9kKqeNUaZHfsmeVt/O/Wju/C4GdwTlxxmNfi3XwllZF9wuHpqhKUArUlDwXgWjiOSP0qD7GAjsCZCP2aFEGgJcjUxS7TP6x7Qf+pqc+ALMi6/Q8jhjUJVaGHYEkEU44Z2Zch2rVTSE4h8fttVKxQQ6rp9QryfHRXnpDousc62CnNON/KAixAYkCIjjVvV2UZ/vbKxSY+EgzwRVfsWJrc/ELL7iMnkFlThe/k7EWqwjU2LyzuClVASlo4lMu2lSHkTAgrX16GaxRKYx2V9CBxEljg3dVdKfnuzONtYf9CH+d0brHPvXWzNbrQECP8jiNWh1gl/nAY9n6/RKwQJo8u+/SNE1rmuyuOrH7e92OmGLPAZFbhPmlDkwM53gZ3Aw6PXpDyHU7sBI7Oz2EqPll8ushOOQUZ0jG+Xl5f8gXEnjvogzvldcjcg/Dx4kBfpLkEb2TIvtEqAH7wp/23+YWcqOTnynGWekBDMnjCF7mg+Z9HEsXgzskMgrQ8jXMqHfnvW0S6HOhN0W/bA83Vw/wUDxn6nzIcQpl8IdpDT2yMZKyvm8T6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current implementation complicates this process:

  * It iterates over the resulting new folios.
  * It uses a flag (@stop_split) to conditionally skip updating the stat
    for the folio at @split_at during the loop.
  * It then attempts to update the skipped stat on a subsequent failure
    path.

This logic is unnecessarily hard to follow.

This commit refactors the code to update the folio statistics only after
a successful split. This makes the logic much cleaner and sets the stage
for further simplification of the stat-handling code.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: wang lian <lianux.mm@gmail.com>
---
 mm/huge_memory.c | 44 +++++++++++---------------------------------
 1 file changed, 11 insertions(+), 33 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6d82df4a88dc..b9a38dba8eb8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3598,13 +3598,8 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	const bool is_anon = folio_test_anon(folio);
 	int order = folio_order(folio);
 	int start_order = uniform_split ? new_order : order - 1;
-	bool stop_split = false;
 	struct folio *next;
 	int split_order;
-	int ret = 0;
-
-	if (is_anon)
-		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
 
 	folio_clear_has_hwpoisoned(folio);
 
@@ -3613,7 +3608,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	 * folio is split to new_order directly.
 	 */
 	for (split_order = start_order;
-	     split_order >= new_order && !stop_split;
+	     split_order >= new_order;
 	     split_order--) {
 		struct folio *end_folio = folio_next(folio);
 		int old_order = folio_order(folio);
@@ -3636,49 +3631,32 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 			else {
 				xas_set_order(xas, folio->index, split_order);
 				xas_try_split(xas, folio, old_order);
-				if (xas_error(xas)) {
-					ret = xas_error(xas);
-					stop_split = true;
-				}
+				if (xas_error(xas))
+					return xas_error(xas);
 			}
 		}
 
-		if (!stop_split) {
-			folio_split_memcg_refs(folio, old_order, split_order);
-			split_page_owner(&folio->page, old_order, split_order);
-			pgalloc_tag_split(folio, old_order, split_order);
-
-			__split_folio_to_order(folio, old_order, split_order);
-		}
+		folio_split_memcg_refs(folio, old_order, split_order);
+		split_page_owner(&folio->page, old_order, split_order);
+		pgalloc_tag_split(folio, old_order, split_order);
+		__split_folio_to_order(folio, old_order, split_order);
 
+		if (is_anon)
+			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
 		/*
 		 * Iterate through after-split folios and update folio stats.
-		 * But in buddy allocator like split, the folio
-		 * containing the specified page is skipped until its order
-		 * is new_order, since the folio will be worked on in next
-		 * iteration.
 		 */
 		for (new_folio = folio; new_folio != end_folio; new_folio = next) {
 			next = folio_next(new_folio);
-			/*
-			 * for buddy allocator like split, new_folio containing
-			 * @split_at page could be split again, thus do not
-			 * change stats yet. Wait until new_folio's order is
-			 * @new_order or stop_split is set to true by the above
-			 * xas_split() failure.
-			 */
-			if (new_folio == page_folio(split_at)) {
+			if (new_folio == page_folio(split_at))
 				folio = new_folio;
-				if (split_order != new_order && !stop_split)
-					continue;
-			}
 			if (is_anon)
 				mod_mthp_stat(folio_order(new_folio),
 					      MTHP_STAT_NR_ANON, 1);
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
-- 
2.34.1


