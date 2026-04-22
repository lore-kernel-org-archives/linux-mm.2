Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C3B9F94CDE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 08:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 946606B0088; Wed, 22 Apr 2026 04:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6C46B0096; Wed, 22 Apr 2026 04:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80CD16B0098; Wed, 22 Apr 2026 04:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6EBDE6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:18:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 39E1C16115F
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:18:40 +0000 (UTC)
X-FDA: 84685490400.14.B43BB00
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf23.hostedemail.com (Postfix) with ESMTP id A52F2140003
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:18:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=g1IgcTZu;
	spf=pass (imf23.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776845918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ekQm8ewHAsjUqvi2x2wso40GhX/Yq+kt0EAdT/Gi4pk=;
	b=CV77n5W6xehcjNjjjwQeR0JNTQgvMYNaQqIn9Ik35b6RdOEK4wZWy2JmnMIFh9dPNKHsiQ
	2mPYIC4abpt5MwJ+uzUxktJCZ8FHfnL73seckuY376vZzu4drwldkcS16EMiDx4RiD3Ov4
	MeLqFj5w3WW2DyAaLMAQ6pUSl1PZ41I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=g1IgcTZu;
	spf=pass (imf23.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776845918; a=rsa-sha256;
	cv=none;
	b=i6BVaYGq7B74EJTn8O93emUSJSrtl4QC+4s1Iwqrwgk4RU6c5TNNeN3MCzSmNHfIiSx4mT
	Aj0I72IlFF8Ym+XQi4EcGuxpll+l3yyU8pstSa2p83uLQRujrzlqiLlke0e1gavrxpm+Zg
	wXMUniYS9BRwKD+SueCMgYkURHN+sGo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ekQm8ewHAsjUqvi2x2wso40GhX/Yq+kt0EAdT/Gi4pk=; 
	b=g1IgcTZun4lBHwh65T9FFPl7S9QitLz1C32AgB119ECvS6Y6NtzdSWxpyYaIWI6x911JDdGLgUv
	UhszjxBpUos+lAUpuFlc9kKViTyXqoEsr5hH4YPUxQ2/r8K2RRUj9riMunkEVy8B6mZek5gsue9y0
	FbGp3e+CC3P9BBG65ODV8rp3+XDQVnFTwEC0mEY83FIBHEFXSLi3AmIs2BXsshd7Gx1xnEdoGCrx7
	1CCsFRxInX/mI2ZqvaAUvbvCTjt02Fc/3366u+dbJJ5P0gN/w2nrNcZEhf+nzAMhFH+2Ciqe5SGq8
	yfepkkiI3zgTOPoEqQQDlWVYYri2wKHsf4Dw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wFSmm-007uhl-0g;
	Wed, 22 Apr 2026 16:18:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 22 Apr 2026 16:18:16 +0800
Date: Wed, 22 Apr 2026 16:18:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Thomas Graf <tgraf@suug.ch>, oe-lkp@lists.linux.dev, lkp@intel.com,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	linux-mm@kvack.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] rhashtable: Check for vmalloc in emergency rehash error path
Message-ID: <aeiESGghexEuKbEV@gondor.apana.org.au>
References: <202604211323.fac1b29e-lkp@intel.com>
 <aedvSnhOGM_mauYP@milan>
 <aehdcxC14ycvY481@gondor.apana.org.au>
 <aeh2Ii9CxtgfsX_p@milan>
 <aeh_2WwIb8nAIcy2@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeh_2WwIb8nAIcy2@gondor.apana.org.au>
X-Stat-Signature: j6uwqi8paq4mbtcymrpeb1s9dhiscb6q
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A52F2140003
X-HE-Tag: 1776845917-159683
X-HE-Meta: U2FsdGVkX19UVOdh8CEy76wvf2YrlUh1iOiwAkGMErFA+jBeRUfHYKmYFadjeCDblql502EjS+QA/J8YeCq+QJy/pVdMoJwY3ecK5AK7NvahitN8MLI4Kid7d0gXXazgH1j+H/mKnFMIp+2ET64uAtXeoZI/W5hkiuooFyPuu1AOVxKLYN+9tYwnbbuz4dmMFWvOSqRvipuWDZiE3pQxuuxTPSHX+DD8sgPG2Qx25IW0w2BWlx7KmnhngcjbHKeSDpxDQPwf2X3FOKdn0baAKHqSxxTb6Dws5EncDTlHgrygg2pqOK9ytS1q6paLvCjPaHiNeGdiNxmpwqHIrGKVUnzcqhLFReA29wEyGMHRAVrhwH9f9G8cuqMM1bbqvMSgGY3X+dljpbcfZ+cRR07c/ybwFShs4h2h6NOzTBYpqsJskRKGzfKLs5fbghhOcYCb8KDcs6ogMbeoyb1p//UGpIS6MjArHwmSwdoeApAVnKjBsYigBUHLsTqm9zqHNDyLhJXVFAguzEO5sQaQXNAB39i4IIUwsgTuWnAvAt1T3avn5HR7ozlukIUX22exjX0qnsA5lx1hfMrUk321ZyAWK+cV9fmXEg3E06N/HUged1m8NJ5PZciyqJt0coQj7Dlge2cJnRj8UZusLlzly8OCrh8dYbXjbT6LHrIMwcpBqyz/ha618h1QZR2fRi5Zocd0MDRrFK3didrbFO1ud0OwgoAisyh5NkzRsi8RvGZvF+WxyF6/TPcmIiIb9Uwq/+FtKkaJACC1Skr2mW4aIsfPhQq0YZ8/Nnct56/eWhM4895rrMKW6b1N0h/m1DevRyLnSpfTLOKv8CKGwHpx3F2PvpDHkE8zTzwELsDK5M9ScwHgvOR6ft42BsTTcqtm+s4veICa6GtOya92NfEMzC3kVxU9cI+AFMipTAlA81yzusnQuJ2mAmYy0KQuTfB3WtwHJdZ6VzONHwmhPeYmQjI
 D2oXqnwI
 NAMFNIJxExG/xQT6EXtaEQDWfZlLIiGjhSwFm23SVSNxmlxKuyYVd4KkMZ8A6s0dI/3Pp249C/EdTbmnONloTftB03QBLtl9KSjxjBR2MdRveCzn0/LyiwPa1I9/NGtOddWm3VGJXwSw796DtU5osSXj8VMqNzK0Y0M1O8hY0L0o3W3EpTCHzFTAuyBk7eZ7dRd2kreXL+fAOMI+VKXSjcRIgNq25J6izJZa4NsWLyOixkwS2QahXnWOi4mwZxiGiORboWtzZglZfBflywWb3gMDChXJaGzzX5I9/urmy/C8rNDW1HhQQQwMvP5mjb7YROysZJMvK/lUHSWmXOvfqHNMU/EkPMweZSXPCYmRyIfCkQ5XVubIOfnLupewh6BdhPHru
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 03:59:21PM +0800, Herbert Xu wrote:
>
> Why is kvmalloc returning vmalloc memory under GFP_ATOMIC?
> Is there a new GFP flag to tell it to not return vmalloc memory?
> 
> This has been working for over a decade, what changed?

Nevermind, I found your commit to add vmalloc support for GFP_ATOMIC.

---8<---
As kvmalloc with GFP_ATOMIC can now return vmalloc memory, check
for it when freeing while in the same context so that vfree isn't
called in an atomic context.

Use RCU to defer the freeing if the memory came from vmalloc.

Reported-by: Uladzislau Rezki <urezki@gmail.com>
Fixes: c6307674ed82 ("mm: kvmalloc: add non-blocking support for vmalloc")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 6074ed5f66f3..c386f456e417 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -119,6 +119,16 @@ static void bucket_table_free_rcu(struct rcu_head *head)
 	bucket_table_free(container_of(head, struct bucket_table, rcu));
 }
 
+static void bucket_table_free_atomic(struct bucket_table *tbl)
+{
+	if (is_vmalloc_addr(tbl)) {
+		call_rcu(&tbl->rcu, bucket_table_free_rcu);
+		return;
+	}
+
+	bucket_table_free(tbl);
+}
+
 static union nested_table *nested_table_alloc(struct rhashtable *ht,
 					      union nested_table __rcu **prev,
 					      bool leaf)
@@ -473,7 +483,7 @@ static int rhashtable_insert_rehash(struct rhashtable *ht,
 
 	err = rhashtable_rehash_attach(ht, tbl, new_tbl);
 	if (err) {
-		bucket_table_free(new_tbl);
+		bucket_table_free_atomic(new_tbl);
 		if (err == -EEXIST)
 			err = 0;
 	} else
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

