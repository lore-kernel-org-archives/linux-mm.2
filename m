Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A751710F9964
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 17:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EC8C6B008C; Wed,  8 Apr 2026 13:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19CCA6B0092; Wed,  8 Apr 2026 13:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F311C6B0093; Wed,  8 Apr 2026 13:26:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D5FAD6B008C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:26:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC2611B6E64
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:26:17 +0000 (UTC)
X-FDA: 84636067194.03.B901978
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf19.hostedemail.com (Postfix) with ESMTP id CD4BA1A000C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:26:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Jji5KAB7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3to_WaQYKCIU57rqjwpxxpun.lxvurw36-vvt4jlt.x0p@flex--wyihan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3to_WaQYKCIU57rqjwpxxpun.lxvurw36-vvt4jlt.x0p@flex--wyihan.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775669175; a=rsa-sha256;
	cv=none;
	b=rS+xg/HQgbLJlVnZ4PsqSAfnyP3YuAoB/U1Svp4KbafHqDCayT2ZeP/Fut6xiNpCd4aefm
	jrrFdE/FjcyqIdmEstH1vq9Ik+3z0+IHhdA7IGhL7SAg1KIwfcmWbdcwhkAB8ETvD3UaZK
	S/ixChp2QtnVR3LlvnnAO6DhNzqV6XI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Jji5KAB7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3to_WaQYKCIU57rqjwpxxpun.lxvurw36-vvt4jlt.x0p@flex--wyihan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3to_WaQYKCIU57rqjwpxxpun.lxvurw36-vvt4jlt.x0p@flex--wyihan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775669175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HKfhxJtawehvSEWMDkPfY/SsNOZhfVJKas8DUTzpFWA=;
	b=niWT1mTk1CQuliUH3M6nDnE3GGUxz5T0BY7vCCO848QZWEPI38VsfsLsJu5cGAAkXd5Al8
	iCCjVBaJkthANbfzC0jf7CWdPL8/C2xwvxN6vWAAuhx1B9vinYuU8mWmfBvXURmO9UWNGj
	Lpip3oxxzGWRFsoLnHhtBw85rMOQs3c=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82c70d1f56eso19329b3a.0
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 10:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775669175; x=1776273975; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HKfhxJtawehvSEWMDkPfY/SsNOZhfVJKas8DUTzpFWA=;
        b=Jji5KAB7EV58wcFmnbX/yhTRtrauOLGTlIu5dccDojnnBsZY4jHt/JkCJ1ZouZHTU2
         POeN7e5Xzs4HO15RuT0jPJyqCjGpe9j4uO0FpW0uc9U+s3aQCEbPXqA+TrinRGOjDj9I
         Mbz/gRNm72xrlK5aq52PN/NMbS78MvyXXepCl3yoD8ss+Z/6UYZhI/icxUtTLytQ85mn
         NNVE/Y2r4fUQGi6ODZGJ1NdWlrHrbkhJWxZy2ien8n9JqxjIpVPQgrVq1ywkOrFpbG6T
         WSJLbZ+FgiG1A9lzapmQaL4vAgrGJmD0Y2a6S+L5JTTcP6NVbm7x26juryrQaxFdTCMY
         fmtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775669175; x=1776273975;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HKfhxJtawehvSEWMDkPfY/SsNOZhfVJKas8DUTzpFWA=;
        b=lXXFAc3vFD0jDJ+ZSWQnGIJH0JmEAye9FWT7SrPERstXXqqUvqEH9pdiH6rrLNY7ya
         9YSNC6j5cVM/eSfLqQC5zy8FqtYcfPZAZ2aasi7a+ICBat4NLhwiA8E0v9IIZw4+eIUG
         oZHR6w8H92Umb6cSxcH7RTsniSde/O6zP+1+k8GwYrSqDpeBKReWGA1NAHWqh3p84M8i
         PYH2BWh/9Eprkh3m6uiPUJRL78w6RbiHxF8pCUnPLU6hrqaLXVXj2B6IaOcdkon1ky/y
         +lcSUIrV0k+d8c/pmn9zYcIMw9LdkTg1s6H4trfAx/JaBMXvpWLgCTQmjNCN0jkkocot
         x3pA==
X-Forwarded-Encrypted: i=1; AJvYcCXiQ5TVB2kzToq3rSQEKZmyl5OyQVT9ygh71OcI+30IM3AaycLa3TDUVubxRimCnHJ/tkx1qvH/2A==@kvack.org
X-Gm-Message-State: AOJu0Yw5d+ecb/9+fYI9is7TdSoM4UY0TLFlBQ9TbgW7O2+vOhSj60IT
	L1XSjRH4JoBSjokReh9Am43WTPtiyUxNYa5dsIvAu8HtuU4nX8o65VkTGmYbtuibpDydojdwcKU
	ogboEyA==
X-Received: from pfbay5.prod.google.com ([2002:a05:6a00:3005:b0:82c:67aa:804])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a0b:b0:81f:852b:a925
 with SMTP id d2e1a72fcca58-82d0da4594cmr21368656b3a.1.1775669174393; Wed, 08
 Apr 2026 10:26:14 -0700 (PDT)
Date: Wed, 08 Apr 2026 17:24:44 +0000
In-Reply-To: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
Mime-Version: 1.0
References: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775669168; l=1598;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=sG0P7RhWvhPfeqHAnDvFiL/wdpauzKoG7D3X6bRIOBg=; b=HYYjhlQyURswF6uipGoryLPDVw7e6x7xLSDi6B5Ls1j0ivGRToHWOQGxxy9K2uu5HWYRcsBPt
 EKIp8P5HwgPAwc24TnV56V+kv3ClUL+8+ATdyRnYAbdQ0knKeaLNQGa
X-Mailer: b4 0.14.3
Message-ID: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-3-718f45eb7c75@google.com>
Subject: [PATCH RFC v3 3/7] mm: shmem: Update shmem handler to the MF_DELAYED definition
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: CD4BA1A000C
X-Stat-Signature: ne4mbuciuye5kcqsiipneakdmz399nj4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775669175-185256
X-HE-Meta: U2FsdGVkX19WHGJ1N9eROxPC0qNVSAJ2WcbqEQnGlEnpfnmU573OHzfnlcuFng1MVLyx3PTPbfEmWmneD9vDFVqUeeNFN1uICXZa7SuijH9Y1QlVMeuM0EV8xwlirInT3aNijIfO73HC+ka5z/CT77lYtV3J59adFUNJ19gSJujrbcry5uq37sVC4AbmLk+jomBjpd9QXJ7hz+pZeOxrnI1XW8d5g+uA39mN7mbW+KP0GVNmGn0TCTTHc2ngeqxc046MOR5YDAtYHM8D+/hbJFnWfOY8fUB35y7MD+xWlobte1AGrqskqN2GdDjck0fbRakgpyaCGQwNJ5if9MPWxiX9UpOFCeqbijgImdwUScgdMPjjZcD9s3Iy986yVlxDscmmVrsCyUlNHZlACKhyHm2vyPTPHxb4dWunVzcWDzv8YjC5MjE9wiWlWq7KWYwIfSBa7rY1blV375px3cIPiaSxtRPeq5CvOrdsoDqX/qOZVL2B2hGNiNjEAQwd9yzJBCpHQvA+GmreB3BEz6+NPlx8UQsANbiZJ1+XgqjIJiL8Q8J7tF7Moj+uWOjUc33HDbcEk8paJpigLvf9f5mjIP4r2VMxu2NWZbeNZ0Goh6TrM+PXS2toFBXjElcSqsedVOEfcNmrzBNsdF0hfZYDkeRcll3S2Rj5fUTDzWpynRjmjJm9vcmF7WTh/3TdOS64CSkOKgECaO6HfnUKW71LAu2beVMjaPWuoto5DOKbb335Ejho67NqwuDasDf+ngYgPIjgyVygs8wV0pTyMcORAGh6Y1knzDgs3I6HP2QO/YCEQ4E3HjE3lHdJVIOTXyPgHvAqRtFHGoNyW+Ea8Wfffjm4wjbxa+iJmc7qJcR5dHE86hv157broY35b/O/vou4lAllMI0jAMz5AiL/uq4pjl/TVE2L0ODZKc0JUo+7KaV2vBMbzBfMBBKsRRKFkpiFhsOb0LiCnXfld8SSciJ
 v5AskLZW
 tiUK1vjLrHkCLR2eQ/54Tpw+nfCo7RL5BJq4B6SX6FjMX7SXJzISnn8TMaiy+DX2xRWzd06gRR87iYlMo0WHJPl6CEwHclXorfMvvtFSX4sLTzZhhDUIOlcEH/dhtKLyEQl5HkOeDGZqbS9ddR1WgboCKY7OJVk4EUhOfZBh1YY9CBjJ8hknOyGXKlXARPnbEg0TtvVGyF4/K8cIYUp+XTWIWaff10/6/Wo2rbbIr1mTMSFpFJSsBc5CbqE2HHt1ShUctQVQQwdRnP1a4uU3Ur4GnqWCX2tTxdiDNsptOm5/DUjgsCSolGmKH+I2NY5vxhRWjOP6aN9Wd6zbJ7LKGw2usCC10dcwhylE9OHrH692tid3PNwrXA23rXQs5KzQb9QaJzga+5c+l/qebt8sX63Oc/HwwdTO6htofa9uizeDrK3mEYyddga0DJs0JT/a5LxCMHzVaZZ83NVg6QTz57MoG0xJq0eIPqXLX7RDr600O2HwLmrCYDv3zWIzxXrm2RDXjf+N+aDx1drin7Xkq8HplYTm3W4y5jyuacS+oe3YNxu0ZlxV4p5j2r4L3Tp3kfwMM+Hk337RNHGtnKkZz+QauSA78UrjXxqVdbDkuhsgeKiphRfeuJmr83wGdejNXiMjT0ia2ds/CHt5xbh82KogBfkPYXM63FJJw9wxqyyLa22TLYd9uq7xlmM2sOXUV2aLuFzi2jzB9RYXTTcIJMoGp5yhc/Y6uVju9t6QzY7jVAcmmuohrXXZBVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To align with the definition of MF_DELAYED, update
shmem_error_remove_folio() to return MF_DELAYED.

shmem handles memory failures but defers the actual file truncation. The
function's return value should therefore be MF_DELAYED to accurately
reflect the state.

Currently, this logical error does not cause a bug, because:

- For shmem folios, folio->private is not set.
- As a result, filemap_release_folio() is a no-op and returns true.
- This, in turn, causes truncate_error_folio() to incorrectly return
  MF_RECOVERED.
- The caller then treats MF_RECOVERED as a success condition, masking the
  issue.

The previous patch relays MF_DELAYED to the caller of
truncate_error_folio() before any logging, so returning MF_DELAYED from
shmem_error_remove_folio() will retain the original behavior of not
adding any logs.

The return value of truncate_error_folio() is consumed in action_result(),
which treats MF_DELAYED the same way as MF_RECOVERED, hence action_result()
also returns the same thing after this change.

Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b40f3cd48961..fd8f90540361 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5207,7 +5207,7 @@ static void __init shmem_destroy_inodecache(void)
 static int shmem_error_remove_folio(struct address_space *mapping,
 				   struct folio *folio)
 {
-	return 0;
+	return MF_DELAYED;
 }
 
 static const struct address_space_operations shmem_aops = {

-- 
2.53.0.1213.gd9a14994de-goog


