Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C4F606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 19:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UCvThTcf
Received: by kanga.kvack.org (Postfix)
	id 3AFCF6B0AB1; Wed, 25 Nov 2026 14:35:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 387AE6B0AB3; Wed, 25 Nov 2026 14:35:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29D256B0AB4; Wed, 25 Nov 2026 14:35:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EFB5D6B0AB1
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:35:45 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77119120FB6
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:35:45 +0000 (UTC)
X-FDA: 85474646250.06.55C6217
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9BFDA120009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:35:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UCvThTcf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795635343;
	b=As2nEW0f6EtuklElU0Js6D/MKGIcvDC3l3HGvf2+rNMAyhazO8U16PhcATXymikmGMZkrz
	jmEJEPSRDIcgzl/shoxPiaeBl6kR7cdOLMQI7YmXilnMhfOzzzQv2QIES6n3d8CLwhtEuA
	mj/maeFxoYxWu2W4pVBoNHAyQdugERM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795635343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bl6ud81CkF4X8slN2gxlMoZUcM+itrD3ts59TVh3d9s=;
	b=0fwj0THEifdJ2x2N1IEMzW/g7abR5llUkYQaYTth0X9P4xhn0DfX+tRiWEkAnjII1cuNt+
	SLCkBfBSJTwn0XIiKelwaf7DRt+4iQyC+EfX0T60MMMq43AIBv3IqAU1injKDTQ5a8qumX
	QF5P8mY8sLUrxnY8yl85/lfUkIDNPqg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UCvThTcf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC8F846225;
	Wed, 25 Nov 2026 19:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5341F000CF;
	Wed, 25 Nov 2026 19:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795635342;
	bh=bl6ud81CkF4X8slN2gxlMoZUcM+itrD3ts59TVh3d9s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UCvThTcfkLqcNquO62sVbpRnRFnDeJcWYrDOsYdGdggtj1XDXUgpHJjSyrrmNWyGK
	 F7RXOgsMh7v3en8oiH1q5NzhjJKTP4AXozUjeYGEw/cSKe6Vq6EWLhTALocukOHRED
	 TU0QbBIdrhuHYEqpKms3adX//ZLqJjlpIzD6wICAs4emB/vWbNXrjftj80Q/GATZy1
	 pGvrbH4lH1r7Ep5sP6ypHZusLswB519SxJNEaMC5c47FWmdtEpGivWXlTB7K42KK0G
	 3+4vbSHZ0aySjr5Zck4Gde5gWT4h6Rx42X8ItdMaJLiiGhTH49orBiJWS9qmwzzl9c
	 KNeNjKO6TNxRA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 25 Nov 2026 20:35:12 +0100
Subject: [PATCH 1/3] mm/slab: update the documentation of sheaf_capacity
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-sheaf-doc-update-v1-1-4a579abaf0b8@kernel.org>
References: <20261125-sheaf-doc-update-v1-0-4a579abaf0b8@kernel.org>
In-Reply-To: <20261125-sheaf-doc-update-v1-0-4a579abaf0b8@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, stable+noautosel@kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3596; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=yG94NeQum/ZZ+SaP0cht5yNDs6BMPBqt7GNNKhBTgdk=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrBzh2XxhN3+C6LXD8CUKJRMBrrroDfZlOzxAkQ
 8d4TqnJJdWJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawc4dgAKCRD6UCkIqsW9
 0PDcD/9k6HWaWfLUXNtskwy1Gw5C/zatYSwV2CabQM1kk9PROCn3kF+jJJyhdRiuLpfCRWLirSX
 WugN4/H637U0FbxheHgJWF4bxhC9Qzt9LbqrplDVRQwxdwhbKQZYaz5ma6wd2ruDc/0WwnWsltG
 BLxjY2u5qViAeOA/nA4NIpjegYZF33nDAdtNwh4ZtgJ9L0J7fHugwXDKGNKJyoyn4h34CLvnqSL
 d/C8PMD79yD/jsgK0l02cLjETsx+NlpRDfrVwdPfXRfppT7MTa2ZuIT1irACx2yDuwrbFZEmhkE
 a85WIML4Rr4kwX9bu26hA0osBR03jBEBZPHvFHxP5iUifDInmwElJPNXAD2AVJM5BXPdHvKwh4P
 fTBD4RO6GMY/19gpu+jYaZANIgzidVlb0jzDwO3uCeMEKZR10gPeuy2fCU2vPDjV2rblA7fMw7b
 dPt2AUHjNa4j3WHbj1xPumo5iHb1qBSOugZx+36iHaFH+W6f5lj9p5fFSAknUlKuLJd1NIR4UyO
 uIo6rajWET4VAWknZMrdzuA6zdoKZaWqcckF54rjzlr9Z0P+3yh9sQDJIcMf4rX/GoOzz6jTVA5
 SD1wKI9J4ttitEIqz7IRXnA5j5iRzlwZ0zrMfp2oVik3sXDHU1G+OXrks9QbxggrRe++8rlQoaX
 pgZMD5vGuPcyFAw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 9BFDA120009
X-Stat-Signature: qcaq7w5w9tfgb87g96akj6fcdi8867uq
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795635343-264618
X-HE-Meta: U2FsdGVkX19RNQCPf9JEAd2uL10OwoMI7C+HKT4XWe1uKsHxJ97H8whWzBCpVXl6eu/OkyH47gdYzvNOdH0E7eLoAju/5Fr4huqRK4HpegEEmYkkkyxUxUjj3ROKU8uLjk6rTLlQ4Uw67oKQGYCkXISnW35uCzPXTG4zTqjempM1PpahQMaFab2wb8LiWxO91o/nKAG5lkcp4Y5KuRjY1+VZ+XYw+uAH3E3Q2/6fOqjkA4gC4LFmKmO1sm4XwORoj5tWR1KoCIN1RbCD0xjNHX+5K/hJ7zESVxhv5OOq2vnzAlmlkqsAinvWqRyfgYtZfAmeoLT/AC9ydpSJYZucl/5h/giccIETEJdCLdBAnLP4udwxaK1ystKrViMyqpLiudN8ndcGVu5eE77x19AK3DYTEujrafRIU12wTnBiMk0U/H/V1VbXzFIoVQlN+nTzzgpAFS6mg8UPuxqLLLKT40oYkuCg5iBDAyu4SMmOP5J0UVEEBUR5Shu7acPqwG3MBuSi2No4y5lhnkXt/jKZGD5IyFTxnV94EcOiueXRjvRZNmDpoH73YYE0m3bt3gabLyC8dUD/2sDCE+aAMfte6gVmCxEhSl33xljIxmRZCSbRz95X6FM13bhEV/yTxlGOkS0boJTE5jhtVaDAY1/PxZi60Pvbc086MaO5HKgeyi4xqPWzfFidG9YBuSAuwd1Dk/0OY+5EHvSLGB7v93ohJa2P8Rv/eMJRu3cKXpdunA2AmaR1giAu+8FdY0GENERP/vcFM9FtDikcFTcQO5Tqh1SFngP2JzbWsdk3qlbeXdZvlek8LW/j9T2zUp+DW7nYwbLCQoTGbYD3fQII8jFplD/3ChUbOdA5+QQoOZPibaUx1ZwgpXOkB5SzLIG2as/H9xub7NkQkDNtcn0rlLxP6sIFesMiVsTvmsYrMkxFEK8slOUD00IFCTBPYTR6qCpQfInTzSmmisZ3Uuv5Nup
 sSMETghM
 etVq6Xj+2SBr1xKZkRoUWSbQThDwO0lnMe7o0Gl2xuE4zjmsgSMy2CPlJhyb4//kRw7oFc1oMbfToQpAAF+GsEdWQLsrtC0pEfkVodNE5yz/KnU9S/I6NbtVMLLdYCCGUrZDOPaYEi2yyvxkJLqUEZEp9bNsXUkw69TznPj5J5Uqt8/FypbHTNV8wiTO+pA/er+X5N9UvERwZBXs5o85GueUwX0itFKqH+mgaHefsU1rfXmC7yhS5Yoma/tJ0hKiLOnSI93uz/jlgcdDLgBN+EYqYH3tArMeZxJVzLYFu8jzAdQuLKJZ8RRGPkGtZpReIuaT3hpBb7CRUxMlgsOKGJeGNpokR9Pf5CAACqvqi1zMr2zfzx2O7+7bNu+Lprmwof5N8ujZQ8+6XOeyToqTYRI66/HNXiW5uZmBfy6zR971NbcSyN9TvylRtOsBUzNm2Zj/FXYTumom/e115Z/8YeiSLVQqIocTK4fzcClBMFTMYWEW9QVuloVSeX1S/ndkZ4oqqD0I2Ma80Od2I+LpLtt2UssrfTozWqu2+47wNGJJhBlgCynpAs0qkfelpWVvCTNpDX98IKbBPeIjqzua1Yz3PCjyAqlYfqCjJBDo9T9kccFu5p/7cdXqmF9RFIZemzKx9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The documentation of the sheaf_capacity member of struct kmem_cache_args
describes sheaves as an opt-in feature: a non-zero value enables sheaves of
the given capacity, and zero means that no sheaves are created.

This has not been the case since sheaves were added to most caches.
calculate_sheaf_capacity() now calculates a capacity from the object size
for all caches and returns the larger of that and the requested capacity.
The requested capacity is thus a minimum, and zero selects the calculated
capacity, as pointed out in [1].

Update the documentation to match. While at it, mention that a non-zero
value makes the cache unmergeable, that the requested capacity is also not
used when slab_tiny is enabled, and refer to the debugging parameter by its
current name, slab_debug.

The updated text refers to the slab_tiny boot parameter, which older
kernels do not have, so exclude the patch from stable autoselection.

Fixes: e47c897a2949 ("slab: add sheaves to most caches")
Cc: <stable+noautosel@kernel.org> # slab_tiny is not in older kernels
Link: https://lore.kernel.org/r/8a73da1c-0167-4aa5-a62c-4190327685cd@kernel.org [1]
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 include/linux/slab.h | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index ad645967a3ee..64daeb239f78 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -351,13 +351,12 @@ struct kmem_cache_args {
 	 */
 	void (*ctor)(void *);
 	/**
-	 * @sheaf_capacity: Enable sheaves of given capacity for the cache.
+	 * @sheaf_capacity: Minimum capacity of the sheaves of the cache.
 	 *
-	 * With a non-zero value, allocations from the cache go through caching
-	 * arrays called sheaves. Each cpu has a main sheaf that's always
-	 * present, and a spare sheaf that may be not present. When both become
-	 * empty, there's an attempt to replace an empty sheaf with a full sheaf
-	 * from the per-node barn.
+	 * Allocations from the cache go through caching arrays called sheaves.
+	 * Each cpu has a main sheaf that's always present, and a spare sheaf
+	 * that may be not present. When both become empty, there's an attempt
+	 * to replace an empty sheaf with a full sheaf from the per-node barn.
 	 *
 	 * When no full sheaf is available, and gfp flags allow blocking, a
 	 * sheaf is allocated and filled from slab(s) using bulk allocation.
@@ -375,10 +374,19 @@ struct kmem_cache_args {
 	 * Bulk allocation and free operations also try to use the cpu sheaves
 	 * and barn, but fallback to using slab pages directly.
 	 *
-	 * When slub_debug is enabled for the cache, the sheaf_capacity argument
-	 * is ignored.
+	 * The allocator selects a default capacity for the sheaves based on the
+	 * size of the objects in the cache, with larger objects giving a lower
+	 * capacity. With a non-zero value, the capacity is at least the given
+	 * value. Use this to match the expected maximum size passed to
+	 * kmem_cache_prefill_sheaf(), to avoid low-performance oversize
+	 * sheaves. A cache created with a non-zero value is not merged with
+	 * other caches.
 	 *
-	 * %0 means no sheaves will be created.
+	 * When slab_tiny is enabled, or when slab_debug is enabled for the
+	 * cache, no percpu sheaves are created and the requested capacity is
+	 * not used. A non-zero value still prevents merging of the cache.
+	 *
+	 * %0 means the calculated capacity is used.
 	 */
 	unsigned int sheaf_capacity;
 };

-- 
2.54.0



