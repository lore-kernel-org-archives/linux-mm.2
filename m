Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C15A4CAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CBF88E0020; Tue,  9 Sep 2025 22:46:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9B38E0016; Tue,  9 Sep 2025 22:46:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B9788E0020; Tue,  9 Sep 2025 22:46:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 081D18E0016
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:46:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C11711A0724
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:46:48 +0000 (UTC)
X-FDA: 83871802896.11.7FC4DA9
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id D268614000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:46:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mT9gjzWL;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y5jPTpqPMOi1hpcfswRT5c+4UlwlwSKkHLVyMRU04bc=;
	b=R5fTaBe6scpGT13clcF0KgSXr5Wmp/di9jk4VVDvL26/YRH3pheHKA77Ihi368NTI3lNcW
	mUKScI/MSU8LybMkFh24mUYC3go6nKXW3Wh/WbpLm/XKeqoLlb/72k0BXyH7/WiROGdER9
	mUT7nTOn1qCR9CiuvdFQckMXQoFwPDw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472406; a=rsa-sha256;
	cv=none;
	b=A0mqerqYmgZkLQ3l4GBSCUvy7YsdIkkhXK+o6zsJvGKT7kdCVJWuAfEOCOgNz8PT4UNuW9
	6ITg+WWOqD8t5DI4OSES9c2iVT9/o0HzJh3uiByG3Ms6gqvwl4pWZaV4XMZT413xpjLHq0
	R+DOT53KBjdh6wPkxH/8mCb9NExgpDc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mT9gjzWL;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-32b6132e51dso4849271a91.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472406; x=1758077206; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y5jPTpqPMOi1hpcfswRT5c+4UlwlwSKkHLVyMRU04bc=;
        b=mT9gjzWLcFA9i6pUF9zbVeNFjbIcNiFAdLSmjOL03yXhgGVirhGDHTp5Qrf7x3IeE4
         uDjDJ5DZhSXdOzibKCKbHoaioh5L8g3VyQMhJl5cXk+vFVZpjw+N6opr5WQm72znFADi
         nJXlfKPMYNi0T9z4aiE/zSqw65MKnyYnLyct0VhmjBspYkmN7MWZdviDF9KAJsLmRw+X
         /QTOysBkgcCjp9UgYUEnj/ABu5ZPJmCEtq8UP0vm8G+hBSLOuftMjq/spK471Qh2BHyG
         izqpAQXm77K1kEE3k5Pb3PFmIHCZ6GdeDXi11CC99DAu/PITYd+/w4IVywk0qG8SSDQi
         Ep8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472406; x=1758077206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y5jPTpqPMOi1hpcfswRT5c+4UlwlwSKkHLVyMRU04bc=;
        b=p4ntngoebVteAD50+ySbrELDJoWxPxB1G+NurLpIMz8QXIrKT+ESU1dVNpDl/uUMTK
         rDV4oPHRYrlWpRNFn4cl1mL6jQ3oLO1KZOQot+eZ/yQzxW3QP8PmIu3a5rbYBSCW7BIa
         qsfPMTcc8NZi8FVSRwlQHHYTyT+XVBcmb/iKld0Jz3a7UEEYHDwKHsU45hhGWoeNt1OW
         uGoi8y/YgsP81sex25iEG5k0UOnkaV8ne3DKpEqqxT4fNsJR58v1e20nRsbgAXfi77n2
         sqzliycmk7cvHxA2UFsa2O74Pgi+hgSZQfSyaqBPTqmMCIDgKXmHfsr9Pazx1fibeOwb
         O6Gw==
X-Forwarded-Encrypted: i=1; AJvYcCXZNudiJUljP+3lQkOwqfnTwqGW77C+FWf+Mdgs5MpXHqirumbPjPHYrUX3JYc+26lQwthv/gjNsQ==@kvack.org
X-Gm-Message-State: AOJu0YzEcjXcoTFOurwcGvd7w2ji/PZd7YE2IKxrphz/hiABBbuQuGM2
	4yAlfvXHVqFAI0G0Cta4eIvKYhkJISt0XKrHGxop1INyGbDjY+dqQLVL
X-Gm-Gg: ASbGncukSLO+QHzmKdH6o3Y5h4NV5Oh1+B0CVs5XOHGcpOc0PV+QaLgkgOyeKp+N4EC
	0BCW+Up+/MrZ75gXeeZevQx7dvlbCFbI/kXvR3Glffu3ON9LDdwLqLNPIq349tI1GyiTmrMmccO
	mwjP68dghADAvgHkiIPwdaFaSCAQEakaF/IQmaB8gCpSYRMlWUce3wz1KH8XWPhdEjLmvKC6Sjj
	DmyrSSA88fmlhPB7BmzbLRyKwGoyUagHDc3A83IsFdyE62c9ugzI4EhYHMnEu4qxNerA05Fi2xz
	vS2bS2mM7x4qJks07ECMYpkZdZqhK4KTefNElpP5Igh8vw7V7/F+7+CczgOXbM+Tzv/Zxo/r8L8
	vsOg12jpONolPwmjUdlzm+7+Hqd3nfybx1OiSZSLjxF4cRLmpsXoLHOsEfPQueNTK7TUKsOCNeV
	LeyalQOhd0GzRjnxmVLgSL6vR+
X-Google-Smtp-Source: AGHT+IFZpY3V/uOIGTyZ8BzKdRQSeK3R6TIpn8+CqivqfkEb3qFahG1VblvOigKRq+kSt04Qfxrjgg==
X-Received: by 2002:a17:90b:2fd0:b0:329:f535:6e3c with SMTP id 98e67ed59e1d1-32d43f9338cmr18153184a91.35.1757472405568;
        Tue, 09 Sep 2025 19:46:45 -0700 (PDT)
Received: from localhost.localdomain ([101.82.183.17])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dbb314bcesm635831a91.12.2025.09.09.19.46.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 09 Sep 2025 19:46:45 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v7 mm-new 10/10] Documentation: add BPF-based THP policy management
Date: Wed, 10 Sep 2025 10:44:47 +0800
Message-Id: <20250910024447.64788-11-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250910024447.64788-1-laoar.shao@gmail.com>
References: <20250910024447.64788-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D268614000D
X-Stat-Signature: xxhxc5zgzxjhx1twjpx6t8ui5zof47y9
X-Rspam-User: 
X-HE-Tag: 1757472406-497992
X-HE-Meta: U2FsdGVkX1+K9LHsS4AbQhLdHZf/WJaxGVFWjiUvIpfLT2MIfkDzfEMRWn6Ba92ZDZbBtjrpWBEI9Zt0eHQgcb1RealdAXiATp8pPgJ3gUctfGtZT1fvgnCsqxs6mLrY8jSrf+S3N206eFoV3hcFYZZoHz4E4ZwK45PriLvuz+YjctzwBYIQlcFpKLvb4/6/N69MZmrPr1fmlcof+QQ7T/IGNEp34MM94MM3pjg3hE6ef6d1XQRJovzOyG3ict3/326VjghcLVXlPGMVD3Iz3bIYsl8GLw3YmJaYkhU6Wmp66JlA//pxCjqHhFAmgO9LAx3p3vLBQW50FUIV2pQh3NwQUS9kLSQznIn95LN2MlwLuXv4nJLn5UVLLWAJwAu8s13HQQV/U4R6o0GGy2uM3N/y2TaJjzzXhV4BJgaUPUK6qv2xLg1ZHhIQGwwA+CsOt+Cfm82I6QXw4LAHfJrO2NrbpkL1ZIfCiuJG1AWrJTFkvGIwy2dP7Py9gG6U+yrkC5oe/56QvJkctg+bghqCh4f8WHW48aT9wrjGQo0kqsOrtMJVDR2UmwVD4dds4ELW+B3KwWgoXMI7/T7AEhn4FJ8ZxuVUa6GHhGe6SZrCqU8Vz3gCxq0AXtFRuVdF0r5rj2S3d0C88uRBP1RJbITXneQAHrrkkTQkutFGOv/Ogk2v1qIayGmqwJ8oML8+yCKX0so8Tem1pX/o//CZF4C0WhX8EGcOk8klXY2uvSOjzRgsyFKUNRTo1XkjA6slq6So9vRmxfwNG8fBolf25dtQI6AzG6yJXdvL/LZizp6p34aJhFLgm3pNWH+LSo2auQp3/SnESkriXa/wtzHdZfNjK6CON7ywLEp+AzRDiIWnK6EN11SPXcv8lXvLkfVMB+oRF4+HEdMc7/MllrmzQOqE8Z/d7D5lo/rRZJxsejnY52dbV5AQs4KJ3KaqSnUlEiYfBenPr+/cmta30OLcRFJ
 K3aGsZ6B
 aBPTPShtrdZpZdJYUPNYzVVTB2yyHdENHiNMwkNwBm5/7Ui8s+GVdFXV9AybJOmbu9Tv6bL0oPIiuZ0ld9Qek8DbmYX9uj4a/t8kfofqMc9h7GlCBxCGQjek6LfewDdDk+/0+vJIqPljG4nmZwfEKVQPolGkUINV5QkR4RW6KA4cZt/YpHmaNw0+lyeTVKydZmJYggRMtXAJcB/UsuoiaPPITQHPf3V6KV73uie2j41PaztYn++OIeWtXtiL6hXRfAi2ruTGF6MBQAzl08LIxHZPTyFC930P8yCNYUzYneFGvidjU1a49CHM3YHzIwEOnyo272OI3QU1+QYfkOA6rjlJmVsmAVOFj+ABBLZ5761CLRBJE1zBEIRF/EBbqFMDPQyxcLbpqehUCtNQjpTDj2HPJzSH0v0b/i/Mdd0PVtFayi5pFrdZzPEVeMJN+iLuAd9I/zAs+uCJ5cduYRzcR2GCwczmIBJh9fhzZG7yIcQrkwViSWwFKkO7Z1N7levg2DeQptt7aMCZJpqM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the documentation.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 46 ++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 1654211cc6cf..1e072eaacf65 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -738,3 +738,49 @@ support enabled just fine as always. No difference can be noted in
 hugetlbfs other than there will be less overall fragmentation. All
 usual features belonging to hugetlbfs are preserved and
 unaffected. libhugetlbfs will also work fine as usual.
+
+BPF-based THP adjustment
+========================
+
+Overview
+--------
+
+When the system is configured with "always" or "madvise" THP mode, a BPF program
+can be used to adjust THP allocation policies dynamically. This enables
+fine-grained control over THP decisions based on various factors including
+workload identity, allocation context, and system memory pressure.
+
+Program Interface
+-----------------
+
+This feature implements a struct_ops BPF program with the following interface::
+
+  int thp_get_order(struct vm_area_struct *vma,
+                    enum bpf_thp_vma_type vma_type,
+                    enum tva_type tva_type,
+                    unsigned long orders);
+
+Parameters::
+
+  @vma: vm_area_struct associated with the THP allocation
+  @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEPAGE is set
+             BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF_THP_VM_NONE
+             if neither is set.
+  @tva_type: TVA type for current @vma
+  @orders: Bitmask of requested THP orders for this allocation
+           - PMD-mapped allocation if PMD_ORDER is set
+           - mTHP allocation otherwise
+
+Return value::
+
+  The suggested THP order from the BPF program for allocation. It will not
+  exceed the highest requested order in @orders. Return -1 to indicate that the
+  original requested @orders should remain unchanged.
+
+Implementation Notes
+--------------------
+
+This is currently an experimental feature.
+CONFIG_BPF_GET_THP_ORDER must be enabled to use it.
+Only one BPF program can be attached at a time, but the program can be updated
+dynamically to adjust policies without requiring affected tasks to be restarted.
-- 
2.47.3


