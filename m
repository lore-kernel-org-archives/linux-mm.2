Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15FB3606A323
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 06:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=gentwo.org header.i=@gentwo.org header.a=rsa-sha256 header.s=default header.b=Jl9PyvKQ
Received: by kanga.kvack.org (Postfix)
	id 033626B0AFD; Fri, 23 Oct 2026 02:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27806B0AFE; Fri, 23 Oct 2026 02:43:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3C3F6B0AFF; Fri, 23 Oct 2026 02:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B1FDC6B0AFD
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:43:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E24612033E
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:43:54 +0000 (UTC)
X-FDA: 85352950788.16.9BCF23F
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4C5E740005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:43:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=Jl9PyvKQ;
	spf=pass (imf07.hostedemail.com: domain of sh@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=sh@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792737832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bfgXKyJwwF/nfGtCyOlS3xPYMWC1c0JLZ2eQ5Uv2UcM=;
	b=1F/JqN+aPY9ik/wb7qXDnRbzlrHn3PbO3FSRshIz8tij+frCFCkOmHcENvGw9nWNatXRQp
	Yxm3f1XDp4EkifTlLgUFzX8lJj0vjOsVZIRUAsBgWOgaKJn37ObSO/CUnQjmAARFwdnetZ
	7IDDj/EKK4q0uh8F1TUPi6Ou6YkvX5k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792737832;
	b=UukxsdEQD5iJYHBio7O8TgAf9R/tKpZakNigpeU/UoOG3sRFYj+vctYWHkuk5srCVS3Ar0
	cVblB54+3pF+sF8zN+JlNXFK8HxAGvd+5VNb9v3Ui9fHpOYfyh6/ymWZHEuMqnLQK95vXH
	h1g6ZLA54/3EEKCpRUmUTydfcO5d7NI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=Jl9PyvKQ;
	spf=pass (imf07.hostedemail.com: domain of sh@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=sh@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1792737831;
	bh=ApygcX8wvo5BhNbhfSWDu9hHkemTxweY5H05LTIOMyg=;
	h=From:Date:Subject:To:Cc:From;
	b=Jl9PyvKQi/iiZHL/mLsUABCk85OXeLxFFY3CAuwJxeqKEG8Y6cGMsNVmt+kMRGPEQ
	 LbC5pTO1dqEJMQFA8DecMAdTSVyowIaR3K/z0PF6LT0FOvVXLiZkZ13ULnnSF5ObgK
	 o7RpZcwQfqlaCL0N9ke9pd0mrrLurFeml2IGK4C4=
Received: from sut02sys-r112.scc-lab.amperecomputing.com (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTPS id EF764401A2;
	Thu, 22 Oct 2026 23:43:50 -0700 (PDT)
From: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
Date: Thu, 22 Oct 2026 23:43:47 -0700
Subject: [PATCH v2] mm/vmalloc: reject overflowing vm_map_ram page counts
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261022-vmalloc-reject-overflow-v2-1-0db7a20c53f0@gentwo.org>
X-B4-Tracking: v=1; b=H4sIACIC22oC/4WNQQ6CMBBFr0Jm7Zh2sCS68h6GBZYp1CBj2qZoC
 He3cgGX7yX//RUiB88RLtUKgbOPXuYCdKjAjt08MPq+MJCiRisizM9umsRi4AfbhJI5uEkWZFO
 TNaZxteugrF+BnX/v5VtbePQxSfjsR1n/7P9m1qjRuJ6VOpFz9/N14DktcpQwQLtt2xdwn0Sbv
 wAAAA==
X-Change-ID: 20261022-vmalloc-reject-overflow-e532c556f3fa
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, 
 Shubhang Kaushik <shubhang@os.amperecomputing.com>, 
 "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792737830; l=2414;
 i=sh@gentwo.org; s=20251010; h=from:subject:message-id;
 bh=ApygcX8wvo5BhNbhfSWDu9hHkemTxweY5H05LTIOMyg=;
 b=sWycU1BHCOHtw8daozCzYfO25cHs4g8ar2Cxr8a1AFLY6WYa/z7XiqMu0fn+r+o2hiGkeEI1I
 noANPfedynlBP843L13bK5Dm/GemSOs54ibXM3JQrhnTs/EeROQWcmv
X-Developer-Key: i=sh@gentwo.org; a=ed25519;
 pk=jc8YIRvxPSyJaBRe5y+a4N0RXKBUEcAh8+OFhlROXPY=
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4C5E740005
X-Stat-Signature: a9ns94otuz3eooj81on6u6xzy46ursh7
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792737832-841788
X-HE-Meta: U2FsdGVkX1+Qyk4RRvjFCfcoZOcTRXh4v6aPkOl5i9qpwHo3OPPGrs46Z6eOl5lkms6UCdhlYO8hWSdv/J6lBHD08VO6iV9VeB6KIASd93/IisNy2YGA6SingK5IKKw/ku3dsK1kj+bI8L4CndmSb7sXHOuIhDYYp+ZlhqnbFCHJIkAlmy2dhD2riaxKk4N7r14WZ/D1l3iIRGBNSyTcmCO7JLhfnr9G7kNtzxneu0cHYmlhtwke0Fuxic/tKql/W/m6hYLMTY0RJRKrECkBKRTlPg38nBHFqC7Sau2ixZStNbcf2Icm9PiyUyjOKoaO8jn7Jlr8kAHOD5A15b9jgwHrMHrGWWV3+mDj91UMnTgHMZz2lOUy7E4hCCOCE1m4kNCldBZaUpOvUhhTa45ueeRicQPR3xHcG6G3XLwcp+3SHL4/GgKYLNQwKXAd+DIFVchbGA5ZfJOg5aMgspwEX8/S9AUrW/jgymyB9BA15nuiwBacvt3YRTxaxDgsMvIzRd/emvLGbaoAUGpQccVjsz9SrmSJ7hCiiDBuKm5hUSV1ngImDRlItxVH+Mu0HWZ4UIMGe2TO1Q5KYVIUDY2yCHJbuTo96spug8II2qwUFp+P8Ny6qCBcvAW079fbzUrJdAhgbUqVEEZo2u5wW7E39DlcqauYYuZAt58kQHlVR+ThXPxyLnHTARQKeplGV9blG7DGFNfA/PIeJMWFRRUhh4pnBIx7L3xGXzxm49P7dz5FBIxW4WoK5hGE6Q8JVntii8YKrHiOrsoknrX43o28GovnyuLmXLA9xOwASSG/ESmxq7w3JQ7+QJaLNKDLmon5707SzFrFeXLHExcUhDxwLGPPDnlWrqqtz1IVvqJx1rP8gBqYtt8WaklTyvW4oZvPgeqhJpy1U8MCTYFpw3CTBN5ajGaWOPcJ/3TTMlk6IXYjNlTci1y8nrrcLmbRjCTLRdZK7CKDDSP5e7/7cCX
 jW06yAo7
 cu8Ap28tbRO8x0v40cWhrpOBwdjyf326R5ZZ0X3DxR2Tc2PHGmt21yoGHCi3RPP+ra9YiE91QnJ3Ba+rCyi2XTdgKvlU8RlfJ3oOMnFB7rpeJ8ZoBnJXz2N7TMcdasQXN9KqpMI1AR1KgRai1RiczuJahCXQWGMhfuOKKdPxHtGacgIg9o07fhtbxawqwD0YowJ9ZbXarusgoTJoG6nrQ86n+zRtFbr5ZwrgllJEKxgjJqK/BCRLpc8wA+Zph+EFNeawcf/v6E5HsHv+bJ/vPg9HRnvlxf7pMtyXjMs66/z97N+apwbiQB+nnbxYpNMhqlLkN3gBQFkT+og4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vm_map_ram() accepts a page count and must either map that many pages or
fail. It currently converts the count to a byte size with:

        (unsigned long)count << PAGE_SHIFT

On 32-bit kernels, this conversion overflows when count is greater than
ULONG_MAX >> PAGE_SHIFT. vm_map_ram() then allocates and maps only the
wrapped byte size, but returns a non-NULL address to its caller.

For example, with 4 KiB pages, a count of 1048577 wraps to PAGE_SIZE.
vm_map_ram() therefore returns a mapping containing one page instead of
the requested 1048577 pages.

If a caller uses the successful result as a mapping of all requested
pages, it can access beyond the allocated mapping. Such an access can
fault. If the accessed virtual address is occupied by another vmalloc
mapping, it can instead access and corrupt unrelated kernel memory. In a
userspace-reachable call path, this can result in a failed operation, a
kernel oops or panic, or the effects of corrupted kernel data.

Return NULL before allocating or mapping anything when count * PAGE_SIZE
cannot be represented in an unsigned long.

Fixes: db64fe02258f ("mm: rewrite vmap layer")
Cc: stable@vger.kernel.org
Signed-off-by: Shubhang Kaushik (Ampere) <sh@gentwo.org>
---
Changes in v2:
  - Use check_mul_overflow() to validate the page-count-to-byte conversion.
  - Describe the short-mapping failure mode and its worst-case effects.

Link to v1: https://lore.kernel.org/r/20261022-vmalloc-reject-overflow-v1-1-5fde0042ffb9@gentwo.org
---
 mm/vmalloc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bea9f76ed7e74247d4ce919250c2f02dd5c36483..8a056e424a4f2c037c10f736002839014f1f57dc 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3083,10 +3083,13 @@ EXPORT_SYMBOL(vm_unmap_ram);
  */
 void *vm_map_ram(struct page **pages, unsigned int count, int node)
 {
-	unsigned long size = (unsigned long)count << PAGE_SHIFT;
+	unsigned long size;
 	unsigned long addr;
 	void *mem;
 
+	if (check_mul_overflow((unsigned long)count, PAGE_SIZE, &size))
+		return NULL;
+
 	if (likely(count <= VMAP_MAX_ALLOC)) {
 		mem = vb_alloc(size, GFP_KERNEL);
 		if (IS_ERR(mem))

---
base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
change-id: 20261022-vmalloc-reject-overflow-e532c556f3fa

Best regards,
-- 
Shubhang Kaushik (Ampere) <sh@gentwo.org>


