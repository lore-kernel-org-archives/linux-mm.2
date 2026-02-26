Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A21B3FCE086
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 14:15:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2C76B00A8; Thu, 26 Feb 2026 09:15:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60F56B00A9; Thu, 26 Feb 2026 09:15:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6C4D6B00AA; Thu, 26 Feb 2026 09:15:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEB8F6B00A8
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:15:15 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 53B1013999A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:15:15 +0000 (UTC)
X-FDA: 84486804990.07.79886C9
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6327F1C0026
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:15:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=InUg18l1;
	spf=pass (imf18.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.173 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772115313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3FQ+7uigzhY0D9bUb7S9byYQ1qGUM2ULqVMWKZWoKSI=;
	b=GAWNXXi4OpL9HKGH2KTbEQJ8CJZgWN/kLrC0ApxhH1d5BhRhT9AGDHLKufuvlouECMOgI0
	0xdkY0IcbADbzryEJ55p7QHz+qiz3jSy6ZG+XuLISAFlM1lgweiFWwwnvgkQeO7soGatR0
	lfyNuKsewrkFVSu0tM8FKDr2xGdE44I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772115313; a=rsa-sha256;
	cv=none;
	b=aVCDKV2o17kWccX/4hQyIessKkkyQ763lyjDSHesRLSYvYCDanjfNl2bmjcF8dYCdxzqXt
	uP6mUX7XwtPaAaMGYj+XnJGeq/ijd73TxH71y12lmg9axULGHM1xH2TxsowqNcK+bSektO
	70AXdr0aP1lTVRb5/DD9/rMaeHY58KI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=InUg18l1;
	spf=pass (imf18.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.173 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-824b5f015bcso1096488b3a.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:15:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1772115312; x=1772720112; darn=kvack.org;
        h=user-agent:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3FQ+7uigzhY0D9bUb7S9byYQ1qGUM2ULqVMWKZWoKSI=;
        b=InUg18l1DkC0FZYUj7aemh0bUMD6X68j2/AMA1o6vbhfUNHAO8ixL8DvcLxEetfQhf
         vadr36OnHa0al+R4zSZKlc1gfww5NKepqAjYQcpzIpd9EML+3HoGlxPINzShevJXoFiT
         6vi61FfygpzAAnh8bjUJxg8kT5LSl/ZhWF54I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772115312; x=1772720112;
        h=user-agent:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3FQ+7uigzhY0D9bUb7S9byYQ1qGUM2ULqVMWKZWoKSI=;
        b=lvVg6nAfebQxFrNyLBbTuXcrlAlKo59uQikHAH+WaRr8o5F6htzRXiyDQf1oiJksSl
         EJBC4m34HLyL5Hwtw7J1G7O7bLDgnxhB6RW1SXr39k0ENlbN6XSPzZPQ5o4Ew5XWJVin
         Q85dPWT1z5ghFXggwGY4dmmelui/lZi/rYElDq4oTmPGyM4BnKEtQe/L0iQnyh9An8Gh
         fPrAHtpFDMHnNNN1CUdZeCG/nKQbF+9jtAHd0uYMysPZ1rL+dbnLy4XdhFHyh2GGJrJt
         Tpa6TRHhU0c9R/L2AyjOvkrlPX3K7Yns1IjtqrkoR1lMpACzVjHXeLeGUruOhMd0JrvZ
         a0OA==
X-Forwarded-Encrypted: i=1; AJvYcCWMgNkmeH+9JZ653Sl4c2e9xgF+TqKec/+27X3MaOaGw1gojVy6kgYg+NZw4cQ4FdUAjMSijSUt6Q==@kvack.org
X-Gm-Message-State: AOJu0YyY7S5znZ6gfmDwUSIrbdERG+0H1TOtxdCFcZRDvqKN00TU35cs
	H46K8shAZF1p1AvusqN+D3A2zg9uDqNSI4vnWpDzKGaMELhGCrvTJpqP6JomCgXbRA0=
X-Gm-Gg: ATEYQzw3Ms8K1c+EYko4FcZm/phGlR6FfstPQRyD5bo7mpL3sYKG8SIY0clWbRwnFwp
	FItQUnxI1CyFpka0wUT4VGEZ1/PhvcGSDXN1ytHaPm0gnHMVwn6YM3HWAAYNJsfsSNViwKruipW
	yrTHJEDRzWxfuc8jFllccn8WKtlSrFr3YBU9RBMuGkXfz1LTZDoLv+J4cE7Hx9xSnzHmCvA6IwA
	5Msr669Cjz6ECV5+9CmhSXOeFWXZaxBqP9r4ExGtqUhkUR5Od088SYI+KBKSC+F9q+REayGkeTO
	sIsW3CpAuVx4VN4MdTRAChe4qGcKxqInEKpcu/mMFJAczS1M0rsv2YU6KA0JoTtBl+muq2ogRJh
	IL6Zl2saFj6mm1Ayp/Ny1eeAL++TWlSlUiPb7tvClCWQ6LAvilJiQKXpOHz2+iuRaRjDZSqmqYP
	Crd0ResLmt13hSzGHh6A==
X-Received: by 2002:a05:6a00:439b:b0:827:4526:50d with SMTP id d2e1a72fcca58-827452605cdmr1182006b3a.29.1772115311913;
        Thu, 26 Feb 2026 06:15:11 -0800 (PST)
Received: from localhost ([154.47.23.70])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8273a05e831sm2569799b3a.58.2026.02.26.06.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 06:15:11 -0800 (PST)
Date: Thu, 26 Feb 2026 22:15:04 +0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 0/3] mm/huge_memory: Fix move_pages_huge_pmd() for huge
 zero pages
Message-ID: <aaBVaHs8rIkNcwM0@chrisdown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.2.15 (2b349c5e) (2025-10-02)
X-Rspamd-Queue-Id: 6327F1C0026
X-Stat-Signature: 7q6wkduz1sixbd861864t33ndr59i3ca
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772115313-412769
X-HE-Meta: U2FsdGVkX1+yGFCABoUijYrPRoun6u0XnWpEW1OCtIS+iMuObmkhKJ4fpptXiqQLMeXy3RzJZcyrZz7ncKiWYw3qSk8M1tAphyr0kWpIFph1ps1hbunAKe9cUqce4NRnQSU9pYKsu0+VjUmMzAdoqYwmSFsWh7YC3epLwgB4CfropfzGeuvyRgSFhtMKji7FOATv/Su6RJmZH7OuR+W39N0LdklYQzrnZoUo/N3QcmDQns0ptX68VbfqlFdn+DaBtZQr7Mb+dwbvpv+ixC2pn9cPzvs90RnTiu2Jyd1qYnTMEP9hKzUYANvmB1yRELOPNyLZWj6eqby4K2ZRJbZbL7R2gsZlTYAiaH2AY+os6dL3vgGZZaIBYcy4d6ICMz5ITmFBLe8MfKRxshrVo9ROLVRiY+/w/6lWgOcaFWQBdq7bVgxbnMek7xDB3NckTgA72Pc/J9WCErby2XHjN85X4OcU1+sKGn2gnk41M44Sm9CyHQNumC7gvrKl4hlw7QNpjcV2kIZoPN8anOOcrgyaohIviFaihNUdOcaJbb8CGOGPAb6V1ERj0jkoEThiGxr88gYfFd+DA9rgjtFW7IdrbiB4zdVM2EAjxh8LN92pnI9ZzEmz/6ZDcZhattGWE+yJt/K7uNOZZVdT9ZNTl3JdF5ThTe4U+NLM3smDC7UP4e6psiSOie6hB87S2ApkqFmEASVXQAERLKkqOQ0bT6C38kL34yprVGQsj50D6ncawJ/e6IhNxvtPT1RPUkYkwvV137wIQHjd4GQoFFpeGaUSr+h0ch+t+nEZZ4kzawzVji8L2Hmvy0nnTEs1LAvltSAPW8DqLFH9ySXIwCdWNzD/oZwlosbFT6/hZUKuig+l7SEsjNHkX+N8GoJRfoijtbOYzRyF0bTgCRQLtFvN7h4oilxVGdex6iIB5OAnXatJcTtG2MGlH5Nomygh77wURnlMeAkbj2tu2t0xl7R+DqA
 RIr3m65b
 qClMvM3dAtbJc/rxjRNSTJ7JsyZt8WszOSf+bUZpZ1fJj+A2xhPMAVk1pqQs55EnHM5XXpgI4fpeWnyvtXYh79lTuiF6Z8wKGU/ptbT6LMxW0MNjf3ZpPDWPeHNq58UtjsLLzhPp6/8SaG4PtKQvHs4Dn6CbO9qCeo09MGAxv5SsAP+vhLeAzcFeK8N0ta02XlDSFP1AHvUO9RrH9rLeeijQ1rmY5s9YBCQd6d0ZoYgLwRWdwhmx8KUgz3pocYewNzKsjE0bOXq9HAsjjcOPoB/Fp1wMNokW0WTM/uCXsQofEPmXTAFAGyRsP5ZscNqakbKXi7jx8xqcv/C0iNpvJmwOJfV7kqlEqNlxx+eJ3WqTkwkGGG8YFEKRYruFi0hQKPFnz9v7vQ/UwUHZvL/NbeZH4xl63iTNoBr5kgiwtEF1zva35+fcMXnW5Hkoxs38SkASZT6Nemx3Q4hk+sSKP9jSAZULYU6MXELbFcT6aMbiGpgvJW53lrdH3/uB4wuYP39E9fs1+zAUUhikNga7Fe+mYh5rgXN6j0J9LvAKGVWqpl0br3VRalcF0z+SE18p7wSM/Ml3WF/o5wL4LRKnKaUfmqBpcwoPvy7n9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes since v1:

- Reworked patch 2 per David's feedback to stop reconstructing the huge
  zero PMD and instead preserve PMD state from src_pmdval, then apply
  move_soft_dirty_pmd() and clear_uffd_wp_pmd().
- Added regression tests.
- As a side note, I've kept the two mm fixes split intentionally for
  stable backports, even though patch one immediately gets superseded by
  patch two. The reason is they track back to different commits, so
  although patch 2 rewrites the same branch in newer trees, keeping the
  fixes separate preserves the correct Fixes: annotations and lets
  stable pick the applicable fix for a given tree.

---

Two fixes for the huge zero page path in move_pages_huge_pmd()
(UFFDIO_MOVE).

Patch 1 fixes a use of NULL folio introduced by the folio_mk_pmd()
conversion in commit e3981db444a0 ("mm: add folio_mk_pmd()"), which
replaced mk_huge_pmd(src_page, ...) with folio_mk_pmd(src_folio, ...) in
the huge zero page branch where src_folio is explicitly NULL. With
SPARSEMEM_VMEMMAP this silently produces a PMD with a bogus PFN, on
other memory models it is a NULL deref.

Patch 2 fixes huge zeropage refcount corruption after commit
d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero folio
special") by preserving the moved huge zero PMD state instead of
reconstructing the destination PMD from the folio. This keeps the PMD
special bit intact on CONFIG_ARCH_HAS_PTE_SPECIAL architectures and
avoids vm_normal_page_pmd() misclassifying the moved huge zeropage PMD
as a normal page.

Chris Down (3):
  mm/huge_memory: Fix use of NULL folio in move_pages_huge_pmd()
  mm/huge_memory: Prevent huge zeropage refcount corruption in PMD move
  selftests/mm: Add UFFDIO_MOVE huge zeropage PMD regression test

 mm/huge_memory.c                             |   3 +-
 tools/testing/selftests/mm/uffd-unit-tests.c | 176 +++++++++++++++++++
 2 files changed, 178 insertions(+), 1 deletion(-)

-- 
2.51.2

