Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5B1CCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:05:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 157E86B00AF; Tue, 26 May 2026 09:05:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12F396B00BD; Tue, 26 May 2026 09:05:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01DDB6B00C5; Tue, 26 May 2026 09:05:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E59446B00BD
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:05:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A03551A0410
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:28 +0000 (UTC)
X-FDA: 84809592336.26.AE70A8D
Received: from fhigh-c5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf22.hostedemail.com (Postfix) with ESMTP id 91B34C000D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="J i+Qdks";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=HkWUbR8C;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YBwKkY/grj7eTubGVS17k23m7rOV/TXg0sGJ6fJ8NP8=;
	b=lIugSxauvyOlOdV6dSGQck1sUIvB9Fro5V/0mPe8IjjxfJdCQ9p+UAwJxmojVsmg2HFsI8
	UB0FHF7oaMkJEMy4VpRA0I64qGdjCmZll3EZx2sNA+KxsD+dHekgud5Ddk8VY6afAduuaU
	vZzz8zQWHFaVa35XKJxv6pXWT4fgxiQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="J i+Qdks";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=HkWUbR8C;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800726; a=rsa-sha256;
	cv=none;
	b=T8j5Z12sX95UyVbWPJQXzSH91QNxcrrDkm5TGxW6P8YkvFxexkGshsvT9j6uzdNyvJfEN7
	25VuCAH90G0i985HwHKmFVN1TkwnFe1O1s/ZaC5Iai9/1zksuria0GK8j9fM11ygmL7BCk
	DWZBZH4A8AUCT/AujlV8nDFmb/82jSc=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 401717A0199;
	Tue, 26 May 2026 09:05:25 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 26 May 2026 09:05:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779800725; x=
	1779887125; bh=YBwKkY/grj7eTubGVS17k23m7rOV/TXg0sGJ6fJ8NP8=; b=J
	i+Qdksv20gAC3RtFnogzYuu25FqSHcEULonL1lRlrS7o2BRSUfo+tE5HTg5ivaih
	g2sXfDL+EO/nlWjxNp+bZTl+7sDqzSegl91NgJ2/xxLYD2qWt6QE5KBLRboaH8qT
	SOFPRtInVPpGDxw5lBIcU3wZWUhpTkqMp7iMpE/X0o3Q92YAKg3TRUZu1hhplYRS
	GgvqOYv3c37fS/80zr2OEM1EH3ktUA/eyShWyrxqR374NVvvvaB3oqAH8l904Obn
	LTXxo8JXpxl57wqk0FzVZMCSMHgi139eVOpm5IeoJyG3JwLZBH8x+q+fAk9Xqbmx
	1jUz+atgx2rYx5PsO6cvQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779800725; x=1779887125; bh=Y
	BwKkY/grj7eTubGVS17k23m7rOV/TXg0sGJ6fJ8NP8=; b=HkWUbR8C2VgDKVeEi
	3fFNUpQr18rx/QntnFFe8xmRB+aCvuXp9lhz/Bq0kzAnwfKWM5Sv0Qjm357tNNMF
	LYl8E/zE9X9ryvJI2g0N+MPXGephfbTTa1p84lol6pTHUXVfu2kEV1MLcasQezhS
	JBIz+aEdPDV0oAakwARpNFoDpvC2C8Bo8eswLL6ksHbh695rDWBd/SqujHW8bXI0
	Y3iHY2XtNWW7qVagSMesXd+P8QeCtvP7buHbacK6gEmJUWlQ1Nw8BLDpSSXUlXf/
	IYhBD1tV6N8Rbe85VpYRluMDzAyVSbI7+rJ5qb5KbT2KKrb1QOx0MP9qXPobEaib
	LBr4Q==
X-ME-Sender: <xms:lJoVaqjwmQpR_dfRce5MYXNvCOa-GpW9Kiacl8s5KvkHq_Pjrv1GyA>
    <xme:lJoVasEeU0ST0qFOsHCPQfv-RizLckfphd1RP3HQWECYYNZ5-IHt0MVgJ6pK0acOQ
    YLqYiqTG9zn7eGBj1cc6PNP1JyHThO1OJWKFGpGyyckQEQlt-J4ZBU>
X-ME-Received: <xmr:lJoValBTebOWMckAcwxrqC2ukMvK-K_1FksiLWqWAXXmj4il4FjClHaSOxswnQ>
X-ME-Proxy-Cause: dmFkZTGhhOzazjqDbg84kXmGQIriAJ7A5ZgfZ0KyuPxd944l9VDoz0auYhNa1nywHIJo+A
    1950kHkKTkQx9lnfSbZcx/S8Mcmt8P0l8Wb8fN0f+wGCwnBkoWy9vl20eCC3tZZX+sH7av
    Dlxe1oS29Zt+/zoZFzy+yh5aDbHDzc3iUaHQ8s1Xon6Q6ulUL8z0cPYFRnxsd9cUuaOOeC
    grd5OyNgyo2h51fT3APjemmY7PM1ZW9p43vVXIU5xFLcMabfv/O6RwCJbL3XPnw5Oz6kjj
    h/H6ZW2FJischjgbFlb1Y+t4mjYQn8Uqjf0DstcwPvag6qa0D5BtHhYNV9zEgkVoBIpvTz
    ZnR1foptO7/8jmH5QXxz32AsiOm+BXz6hc/cs5B/azrJ0t+P/mqk1gFTiuuTPm5dA5Vq81
    cJX4YOgsiiWFnHVl2CR8dh5PxgYu8tU+XiYMmMArsrktl7gMkXqC4+Sbs5Xn6kySEhNAys
    mYSAKOa4AxYoEqMuWUhw8xNgM0FzaeXymKeIrC6L2QtadT/OHDmcHIZKIxtLTvXPGciZHW
    lAasq5Z58Qc+qpKkmjjFN0MXay2YvYLghe85s4ABJ6fi1iJVjQD26TVp+3WO6IAh6yMxoI
    vHJCG2WFwICzMtns84mmZs8RKQ3lGJVWcW9XDv21tmktq9h501AtPj0yTmcg
X-ME-Proxy: <xmx:lJoVag-fHOwSkVIhIcgbEuZJ3EheaAFKPruqXtoKKZD7VTEvz8WlDQ>
    <xmx:lJoVagjvOwHKdOZLp8dHu4japn4UurRHA7BXVITvuV01NN0HkLCjNg>
    <xmx:lJoVahaP6hRlgQF-WK719SnmrQE_rkzUv8TiMarwqyYIK1BJR9GFUg>
    <xmx:lJoVaqQIecvWfMmOr0nZddq8kixyt-yQ70ZduCfmhTCEb_89-t78fA>
    <xmx:lZoVagVAEg8PRpsCV8YCg6wu5me45h09voNBCdPvUMWguihk7VgrxZrY>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:05:24 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	stable@vger.kernel.org,
	Sashiko AI review <sashiko-bot@kernel.org>
Subject: [PATCH v5 03/18] userfaultfd: gate must_wait writability check on pte_present()
Date: Tue, 26 May 2026 14:04:51 +0100
Message-ID: <20260526130509.2748441-4-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526130509.2748441-1-kirill@shutemov.name>
References: <20260526130509.2748441-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 91B34C000D
X-Stat-Signature: ssd1znye1w1ewxjdu1iyxbdjcfoq65bk
X-HE-Tag: 1779800726-390009
X-HE-Meta: U2FsdGVkX19X7Ks8cS/PBBE1jX7QhkBXQBPfMGGAlbXv9WGWSXi1CGhryyWlIUTlJmFQSlYfkCOa5RNCb7GnD9Pq+DHC3E/pR/DFS0uSdbr/ljrz1gnMZ+ZOPcigc+VoJTIABgV3u8/aLDIZi30ysyjMRxqzYG0uLPuWtTOXvMz5maR3n0fwUeDxW5+LA/Y2T4VO22/1aLLsh1BkSrGEVfFDkNupsVz5urXaGcAfcmHUeaDuQWZMfM4KMfRQKFvj/KVhLa8wacZ4Srcp1dP6PRjP3bcHAC64fOHO1pAZ8O2hiM/aJ5LAb+8ZGPDAnezynumB/uqlPQmHIaXEd6insJF5lfrfA96agwcQFvgdblXY/54sF/WEyzxJCRh5tBj68jXK72M8qyO1zNvzu2aLJoJ3B1p00mNjEJ3VsZlm5+kgEkI4DiHTWy6l9OZo9fg3Q3GDdh7xkc0K8SE40wffYDsaQ7SV3NP4NF02WpB+Tj0x175stVFX+j7vLSz5s5YLHZwL9Lr/gBfeIrYcCmUapGBatYm0cXCLQ1J9Ln/+zVufZYGVK+wK4dll6Oq2xJpjOCV1XAOXux/lYYbrtowS/e3+YxNearw/ePBAq3KW2K+jlVWEzk7puRglwEwtLOEJMPD6y3pJkpdOEfvDlC/REIq1UR9717jdkA5kh+S5o0bnK0i+LqjWwkKGHmIySHeBKtkL+oIGBsf/Aqb+jtFn/SAa9eMAFiCaniFNv1j/Cgeyuaw1saVwjYppySrFIOLas0l4kg0ybHxPoGNaQptBPxPUPcocvvo2lToPlU4C82bjhQwz+EAH+vBUUuoYWWm5/VH1K/yzjFPkkTX8lCL+8o1ekowhPtVb/NwFQ/UvfooMXopjfLjYE7bJLA3gzvhUJx1ZM1Y8Occ5U8A1rs/YYg9trTN8SppCrYTKNx8u23icUVPlJLYbxRxNYl+KblA+KTN06NL6SrO+MlPjwRj
 XoPtSYEy
 XkDp6QvUrmRO1hCPGMDot4QLodWcIoskAgfXM7QXIhtkDII9v93sVoYvUxUXFaXbQbpOnxVvm5rxWWoYBySAPxW6tu9o4PAvDWoyGj5nTdWV3j3WlvyZyyT7XE+Jst2yyKq7p6EM/lxAGfzUCItciewY8D6tJyytmz3qSpOWD4PORRJeD+F38QgP1Ir4k6sr00UwrdzYavfEJRjQxMBPPxJNa7vM5lzLDbUpcoHCKwDRGVEGd0ZdGSj+tBSOe5pDyLpzGz2Ol1s9O6DdLcCQZlz1xSsKyjnh5spgwX3HMKFxBGITgMLYbzuFCnZvaARtw7yVF3Li4l0RIAh39dQUMaeHQzxHF6RsoCmtsEaC1OtoRhkex8m/sWfwHdVbQa0CDX9JkCA9cZY6cjPHhdd359NfzUGgiF6QM7yvTh1Ymtz9dKp61l/QeI/X4EkvL9i70ksW6XoYszVs6453JnW0EEweqsj7cgP1zhOeQOOA9eO51piVG9d5PzPZ2TCuuWZ1DfrKezGb07Vb6f+GcV4BUj9m2La7FJ9MGDR269mjOs7UMzxYCDDWp4D4x0CZeCHCyDCDRgLMS9zegIcpfz/4D7Lh6VDdgwPlNe171HrzuuGGGlsU7M2+hLj8H9KtUMHcV27UqPj3Kgd5BfxpzrAEV2wZqJimSsE9U6PP42dzOkeRXjgs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

userfaultfd_must_wait() and userfaultfd_huge_must_wait() read the PTE
without taking the page table lock and then apply pte_write() /
huge_pte_write() to it. Those accessors decode bits from the present
encoding only; on a swap or migration entry they read the offset bits
that happen to share the same position and return an undefined result.

The intent of the check is "is this fault still WP-blocked?". A
non-marker swap entry means the page is in transit -- the userfault
context the original fault delivered against is no longer the same,
and the swap-in or migration completion path will re-deliver a fresh
fault if userspace still needs to handle it. Worst case under the
current code the garbage write bit says "wait", and the thread stays
asleep until a UFFDIO_WAKE that may never arrive.

Gate the writability check on pte_present() so the lockless re-check
only inspects present-PTE bits when the entry is actually present.
The non-present, non-marker case returns "don't wait" and lets the
fault path retry.

Fixes: 369cd2121be4 ("userfaultfd: hugetlbfs: userfaultfd_huge_must_wait for hugepmd ranges")
Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Cc: stable@vger.kernel.org
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 mm/userfaultfd.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 35b206cc9aa6..f6d2a1c67019 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2535,6 +2535,15 @@ static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
 	/* UFFD PTE markers require userspace to resolve the fault. */
 	if (pte_is_uffd_marker(pte))
 		return true;
+	/*
+	 * Concurrent migration may have replaced the present PTE with a
+	 * non-marker swap entry between fault delivery and this lockless
+	 * re-check. huge_pte_write() on a swap entry decodes random offset
+	 * bits, so gate it on pte_present(). The migration completion path
+	 * will re-deliver the fault if it still needs userspace.
+	 */
+	if (!pte_present(pte))
+		return false;
 	/*
 	 * If VMA has UFFD WP faults enabled and WP fault, wait for userspace to
 	 * resolve the fault.
@@ -2621,6 +2630,17 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
 	/* UFFD PTE markers require userspace to resolve the fault. */
 	if (pte_is_uffd_marker(ptent))
 		goto out;
+	/*
+	 * Concurrent swap-out / migration may have replaced the present PTE
+	 * with a non-marker swap entry between fault delivery and this
+	 * lockless re-check. pte_write() on a swap entry decodes random
+	 * offset bits, so gate it on pte_present(). The page-in path will
+	 * re-deliver the fault if it still needs userspace.
+	 */
+	if (!pte_present(ptent)) {
+		ret = false;
+		goto out;
+	}
 	/*
 	 * If VMA has UFFD WP faults enabled and WP fault, wait for userspace to
 	 * resolve the fault.
-- 
2.54.0


