Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4EAAC982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 10:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A40CE6B0088; Sat, 19 Sep 2026 06:04:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17146B008A; Sat, 19 Sep 2026 06:04:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905AC6B008C; Sat, 19 Sep 2026 06:04:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 665D06B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:04:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E22931401EC
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:04:54 +0000 (UTC)
X-FDA: 85230078108.11.20DFCFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0B69E100005
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:04:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AB+P+Dbo;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789812293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HUNU8WlYTvz53+Q8M4jOiz4WEBDp0YF3dUQql82MWfI=;
	b=FGnhhTzb+dL3X2AyeEAJniyay+q8FgjMpOBes/x5clxPGtXT1CsqK0zWPSa6tL+qIuTHKw
	OXXelvAuOm+LiFEPQVwcVFRNXkNi5kLYFXaduKzruGzs2IqrS63sjZH8VjptyIF23ou4qF
	YJ8tqxkaTgSvYjBp8xnCdtyqMwATQYM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789812293;
	b=HcUtyl6SuHOW0eIkV45K24yfHwQDjuQoQStlSr3YjoZjoguDIv3En57OMP3hFQtQGxtiVk
	V2vuoANqb/gnB2qfO8l8Ak1WF0Hey5tgUztf66O0TD0T9P/EN1RaC+WEUA9GSQmMR9XRJs
	i3U+S94GLJUR+qkQVzCWQz2kM7oy+0Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AB+P+Dbo;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F78F40A70;
	Sat, 19 Sep 2026 10:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757831F000FF;
	Sat, 19 Sep 2026 10:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789812291;
	bh=HUNU8WlYTvz53+Q8M4jOiz4WEBDp0YF3dUQql82MWfI=;
	h=From:Date:Subject:To:Cc;
	b=AB+P+DbohSA5vF//USDAePxj2u8qkSxK1aZEhzVQsWNxGfugWfltgjTBtIsbaxVlP
	 pGAR241LXaIPfTlPQcSD8SvBkmmoZpwIL0XOqgFXl8vASk9DIde9yWLwxI2tmAHPIq
	 N7BZKFGjsv3HXAO6RxH+211b+ggm4zUD1va6ZjnHolKmbNrH/58L31nkQb6+PzER25
	 yXICDgioK0IULDjdR0YeZ1Z1QqrnH0j/4oJVic5QH8V70s5VStJe4uUju6WkLrdovB
	 IeJiiqCB3TUQ1QxRXaQy+jiPsee2hHE+fUL09b3k/REM0fN2w7opVer9H2tHSl2twF
	 znBdj5Lqoxc5w==
From: "David Hildenbrand (arm)" <david@kernel.org>
Date: Sat, 19 Sep 2026 12:04:36 +0200
Subject: [PATCH v3] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260919-nommu_gup_pin-v3-1-3660a8851243@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXM0QpAMBSA4VfRubayKcyrSIs5OMqszaTk3Q2X3
 8X/X+DREXqokwscHuRpMxF5moCeOzMhoyEaRCaKTHLJzLauQU3BKkuGDWORS17qilcCYmMdjnR
 +v6b97UO/oN7fCdz3A/tEjEJxAAAA
X-Change-ID: 20260919-nommu_gup_pin-df63917c8182
To: Andrew Morton <akpm@linux-foundation.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 David Hildenbrand <david@kernel.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3893; i=david@kernel.org;
 h=from:subject:message-id; bh=jGLrYmctqoehyGtKEy83+Rhs7HUTE97IKGKEz5l+j4M=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLWxVn62VzpXMdlnF75NadYadca83kGfxZXZF5tTftna
 vn4oeyLjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACYS9I/hf8HB7s0O3TlGX7la
 Fil+42e6/DOfY0e2Z+SepNqbZ6JXezAytNTf4K+1rljfq9THb2uz0PSdse9u1wcvTxj+l57M8Go
 qCwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0B69E100005
X-Stat-Signature: 7aodsw375t4cgso39k5cj87drscwph8i
X-Rspam-User: 
X-HE-Tag: 1789812292-798006
X-HE-Meta: U2FsdGVkX1/xrKp5+FN8cyKMYtCnywntX4ifLGy8lFNbFHlZhLKEbZIK0Bi+S+gT8rDcBed2S5Q1+3Xxnuo5BwyB+euDFFQVU7i+t9afgCCvNz/jzmlcHvBbjCh2nRad7QgSBhluUljNUr16o6PhjC2HNA1aoEZzLVsDKcM21wBYnN6YXWzXMT+BXAK+UmyjyRv8Xvh/4rHwU6ns+KGEnHshp2vEwwnX1MapHiu9MZwXS2pL0k69pSwkKSD9vuEtWD1Wbpwmq35KnhZJdRE7iOyEeOYP3ofnmlBN/HSAiJGk5ieKnbqSpKgqM89G1zMRb5LdIjuymUhSDGMuRlaUN1sP57dUAt0cLxLmdqfbZdX8wxgCY8MN1COLt5QKyB7cPP7yP3AWrq6vXwcgZDDL90+MGGu55RVs768IuW3tWLQctZJvsfeYfvGLMiHE8hSNOEFtiNXsPgob5lWibMzd8LYAanuZF2e+GqpNkVYQzz78xxdVwBMB7haj8/Ss3mRJkIP6OunugL3a4n8iv6BJ1f+MQ4CThxw/8la2lShzIgvTkkCq4thGlkyFipcQZI5HZOQkt0i4dTfP+MHKw1W7vGkGHyQj9pYWb6HPAO84g+ESGTTGv5A4+KAGt4HoCpG0Q7H6GDcTbctAltZW2S1xvhPn+AyDW/logUdpi8li/BW0CL5pT6L8MdSQ6bzPy7g3YHARJ+7X1gUJeQLTd+sRciTQ0RoOk/ASiuy1jVIYSVebCRY3WxmUlPQsTiXsaiqZ08+CqHcsJQe6+a5smffwXR8YVZ3kz/NuuxhBHwZlwO1il27H15qCBXTY1vLoqah3X9pCBcghlJ0PNo+hcjZzH0JZXVmK1fPyCHCnE7wZxdg+kF2j2xunaJ31SA5VfR/65VAsUowq/BA3DY2sfz/rGjSL1KMhAKXkuVIfd+YkXopNk13cHIb4PhwJYmS0qZJ1hC4nWBtKLiaD0ce4l4g
 R56f+wQt
 wc1ic+uoFP9L4rBnSt6jYo0E5s/pmsuNFUC9Tids1EAE/RCRVemV3p8jr5UfVo05K5GfmVH+L4VAKDwc7TUNy/UfSIvsOax8Md8YhWo9cbyIu+2365nWLWdBANsgLiqKzE44/vJyXbG1xbWZhn7G+AYM4zRs9vK9i7nbzuXtp+/6nMJXL5POfhuIhyoxgCzrWe1yRn4+jgETvqKohBEwT/TBTJ0MIep7rUzsscggQrmhqaKq0Jcy6PFd1VrQ3xeJ9eqkwNYnlf/UahImOU1r/kzP6XvDPwCwmpRNQ1eg+bGqRCWVbJiLaXHa2s4KhiY6iS1kof/w1r+MFdX5aiGovQp4jpZqkozAPVQ0v5O8y+Qp5Os9KWzCBG0pICTi9isq2tR3nNOqireIQmPraUVmjY30BumKFTjwnSwIMS59jRYXYCDMO9MoabJ/nSR9bpcfhEwY+SiIoH61ktvjCd3oHIow/MMHFIO8UJvxT2wLkrqhvgSmmQ27wmCbvCGK4f6BP9RULZwWjdSDx7a4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
get_page() reference for each page regardless of foll_flags:
	if (pages[i])
		get_page(pages[i]);

This is reached from pin_user_pages*() with FOLL_PIN set.
unpin_user_page() is shared between MMU and NOMMU configurations and
unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.

This means that pin adds 1, and then unpin will subtract 1024.

If a user maps a page (refcount 1), registers it 1023 times as an
io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
the page is freed and returned to the buddy allocator.  The remaining
1022 unpins write into whatever was reallocated, and the user's VMA
still maps the freed page (NOMMU has no MMU to invalidate it).
Reallocating the page for an io_uring pbuf_ring then lets userspace
corrupt the new owner's data through the stale mapping.

Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
symmetric. Keep supporting the traditional behavior where users specify
a pages array but don't set FOLL_GET.

While at it, don't return NULL pointers in the page array,
as this is really not expected for GUP users; instead, just fail and return
-EFAULT.

[ david: support traditional behavior with no FOLL_GET, extend
  description ]

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Reported-by: Anthropic
Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
Assisted-by: gkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
I added a best-guess fixes tag. Given that this has been around for a
while ... and it's nommu, I think this is fine just going into the next
merge window. In that case, I will pick this up myself. If we want this
as a hotfix, Andrew please pick it up.
---
 mm/gup.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index eb898ea1ee22e..1681bea8eed7e 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1659,6 +1659,10 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
 	if (!nr_pages)
 		return 0;
 
+	/* See the MMU variant: support the traditional behavior. */
+	if (pages && !(flags & FOLL_PIN))
+		flags |= FOLL_GET;
+
 	/*
 	 * The internal caller expects GUP to manage the lock internally and the
 	 * lock must be released when this returns.
@@ -1983,6 +1987,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 	struct vm_area_struct *vma;
 	bool must_unlock = false;
 	vm_flags_t vm_flags;
+	int ret, err = -EFAULT;
 	long i;
 
 	if (!nr_pages)
@@ -2019,8 +2024,14 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 
 		if (pages) {
 			pages[i] = virt_to_page((void *)start);
-			if (pages[i])
-				get_page(pages[i]);
+			if (!pages[i])
+				break;
+			ret = try_grab_folio(page_folio(pages[i]), 1, foll_flags);
+			if (unlikely(ret)) {
+				pages[i] = NULL;
+				err = ret;
+				break;
+			}
 		}
 
 		start = (start + PAGE_SIZE) & PAGE_MASK;
@@ -2031,7 +2042,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 		*locked = 0;
 	}
 
-	return i ? : -EFAULT;
+	return i ? : err;
 }
 #endif /* !CONFIG_MMU */
 

---
base-commit: 40288c9206c17eb66a603262e06a58d300d0f279
change-id: 20260919-nommu_gup_pin-df63917c8182

Best regards,
--  
David Hildenbrand (Arm) <david@kernel.org>


