Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A41CED29C2E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 14:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E85116B01A8; Mon, 19 Jan 2026 09:22:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5D576B01AA; Mon, 19 Jan 2026 09:22:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D933A6B01AB; Mon, 19 Jan 2026 09:22:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C50566B01A8
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:22:54 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58B98160147
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:22:54 +0000 (UTC)
X-FDA: 84348929868.07.711F06D
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id B3CB4C0003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:22:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=H1jYsBYX;
	spf=pass (imf28.hostedemail.com: domain of 3Oj5uaQgKCMEztvz0hmhnvvnsl.jvtspu14-ttr2hjr.vyn@flex--smostafa.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3Oj5uaQgKCMEztvz0hmhnvvnsl.jvtspu14-ttr2hjr.vyn@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768832572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=b8pkyldJ+pGAVMQEprScMwPOOPhYPwuYlRTxB+xChvE=;
	b=ooU5oTPBPiMrEkTncsev7h2h8O2XIc0YhRYy5dnAD1lYazOVT6I+20x7nbQh0wxI072Y0k
	PTwWqrMxIa9uNpgbW5TSuvHe1GhEoQIatFCeiuRu7zOfQbN5TcGLy6Ky1t638//kdJb0GJ
	kN0HS+9ssmoZ8WvWE5m6Cbhgouqz7rg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=H1jYsBYX;
	spf=pass (imf28.hostedemail.com: domain of 3Oj5uaQgKCMEztvz0hmhnvvnsl.jvtspu14-ttr2hjr.vyn@flex--smostafa.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3Oj5uaQgKCMEztvz0hmhnvvnsl.jvtspu14-ttr2hjr.vyn@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768832572; a=rsa-sha256;
	cv=none;
	b=3kfc3pdkge5kzwgOxqtTTxfQJnsCN9nb6r28qBEbjZaJawP5gIhN/s2f4r2F0/FgZ2g1EY
	Emq41+G8I1fc377UNAN825olglQbJPH4tTn2z4sK7YZrHystJ174kTEFd4F3kMpPH3P/vf
	QkyCqPNidrXrZbNV3Y0YhV4JXdzoOeI=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-64c62f69defso4527410a12.1
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768832571; x=1769437371; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=b8pkyldJ+pGAVMQEprScMwPOOPhYPwuYlRTxB+xChvE=;
        b=H1jYsBYXKw97/vuSR6fRATv4cQc0w6W1Wt4oqxzWuCbT4d8mpVAE+RNbmVDXZRivDE
         9driJQmJbx9qwTVP7ZzpBgPXb9410N3xa75HFPLrQSPPZsBtYvvB5hygjNS9b6m5lh03
         KvTnKNroVwOZodo5H+wp9G00sBG/3rZk6Fqhm9rkpvVfa/kLJY/V18Q+am7hv9f3oQUF
         e/ZQbHdmcREW11migWkn8nspl2eAPRqay1CVraT3dgBFUzH7TcipBrZVLOO3rEEuDuxH
         lknXKFkwkm3v292cTyTP0M/2IMujdxhjyIlXQd5cwdmXypB+5y4//8GpxTcxUl9IZ2q3
         hr8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768832571; x=1769437371;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b8pkyldJ+pGAVMQEprScMwPOOPhYPwuYlRTxB+xChvE=;
        b=TgWmeQ3AELb8KYo50GlhRMF530xinvYCTXzQfAaFiSnYwZybeyz/Hr5XJj4tf3K4zF
         iaunyJiOkSciMPdxYDow4NkZxJ8xwNBfrlgCEzT9SCeDG1dq1Lewf4FajekPiO9ZQUb3
         5Ked7ql2A+R6FH/EFa+vIvFJdvP1RdAA317/i+jIuiZ7qOdBroveJOWDylvkO87FLXUR
         mk7SHSlj/TAFSXDFtLxfaEjJoDCvs63ljEUaGtuPjzk7N4DfyEByVP4kYnEh4q8rb11x
         s9LfcC3Nt9KnB96hFExX2ZbXQzBtBJTS/Ti6agJPGADCrNmKhV4Yd9EBBysxyhhyKpAY
         kkiQ==
X-Gm-Message-State: AOJu0YxHdXlx8ceS4GpfWkV0LqsKdSvfFMldHyLxisfz8zga/FeZpqMr
	wgt+QFX4PKn7+dW0YERYBkrLTZT7TREHrYsNtnVW8D+TTgCuoIsI+4NplCzdh1isR9x+vOSEIyl
	qvSaR4W2/ws8q+RHCREuNDvfOW8F2YmbO3LAlyCcZyK3oLmrsquaWbft+SWkqIHDwlOwhJ4dCX1
	+nM6xjiyypY+TwG7eWC2opyq110QHnAPafo215/WU9Tg==
X-Received: from edwf2.prod.google.com ([2002:a05:6402:1502:b0:650:9d8c:ee30])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:90a:b0:64d:88c:c2ca with SMTP id 4fb4d7f45d1cf-65452bd56f7mr8686719a12.28.1768832570709;
 Mon, 19 Jan 2026 06:22:50 -0800 (PST)
Date: Mon, 19 Jan 2026 14:22:44 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260119142246.3821052-1-smostafa@google.com>
Subject: [PATCH 0/2] iommu: debug-pagealloc: Remove pfn_valid() usage
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: xwpic34puz3sifn8osffiz786winuf7d
X-Rspamd-Queue-Id: B3CB4C0003
X-Rspamd-Server: rspam04
X-HE-Tag: 1768832572-431865
X-HE-Meta: U2FsdGVkX1/Vij9uAHaQg7joeRthCPUzB3+ZL1VoMA1y8B0P4hPBkTUBThrYh3U1huYCSfTEWZTLooTZR673Hf3e6TB/SFsfBizMlMp7Ekw3sr6EJCXegT/fLU9fKKFCzzfb9qM/1QNg5uBGPJbKPKvhW23QyI8kpVd3L57vkmMK9ljIguQyUSUTuyHhDnjZzfi6tHPF/fgXTuu6jVkO45QzuZOfL4CgidbBMlnAA6tpk5vWdDT8VwJWimqnkZBn6px2AsrGjuB721SVT6z/qtlfuT71ZHhNQysTn6nFVzmfnl20Y4xOvGnSjlpM0p+P43+yqWv0hBpWSBhb/K5NdKuC5v9c8JjijyGN1NN6j6UNQm4mHQ8+EbIqk7stetDCM3jnwHJxxagkXN1Rc26DIwcVopORmgogek3j1My/KKm0rwaD6fEuZECOLeyaBlkYUNKhFjggqEySpXisnDT5GMqxDIjJGwzXIJLn5DX/p2LgjTeZZoFkTXe8DRAkCccZcO1EobGCIPBDz4e2DLwolevpM/oy1N0oGseDz2wtI+M9QG9wBBd83yZi4sL/RP5AV3S0k/f9lzY+lN8AELkqsjfHwB8dtX21PDphPLqHfsZRDoFjhqZ20wEFTK6eSAh9YsAZ+4wx6HLBOhpgQuZsG8EHilBxG0j0po1xv/xgyR7TxRxZCLFj0ESGrgFI87uhu+fMRAyM5qB8szcXfO4N/3hTbNlP32/KIWAYzKCtPQKKodd14qe7VikYSlwssBR9lfNkxUuqaoGK5RovKXPXoq753zOQGkDeWEkxXxohh57K2K0PksefcHSv60DM1N/ab49GSfE097vh8qsdJ0X+IrssaEe+c5MEMsNGN87i8nfHQ8SptODsAt/N9oNnSSOqKl1SjJxnOYkHQVqNmPV3+CO/XEpEcgBs96A/RjUuzP99dVTGQWCGtrDgFzGXcQG2sFQDhp4N2CO3VKdyPU+
 WaXQm/nS
 E1qx1oG+kz65NvT4btlLCVbOU9AX0aoxnF5wkXerGCJdseH1lbD+DegisRAwXLVnw4Pg5DEaNQQ8fT1bfJgFLKZn+HKHjmQ0oQWvMYB0nAJ/CrhLln9CO9bUrSnnTEptJ1xLLeoq3HT1Eiap0/KOcmnpR3CHT9I+P1QVJeeFZHIRcSYFYPQLcTtiVXRZYHOYvhrKEVP9+hS1m7q1AIyqUQMeFHtNpkUZI9ebb28lSAG0CYuI7Xi9TLiz0Ga/9HPLS9RBNCJjFvIWYffQTw78cgN1HFU9f9DXN9dl2h/4ldaUVM9qmCbJ8LJ2eFU2CBLIsaa8G6dHDm5rli6ixiVIUZDldQRbgypb5KttFIJI1ccACWIOKoG9HYtXWoOBlNmR7nleQfbXt5ZImBDhR+gIrpceNSjgZbk6W/DjTSu08hgf46DAKPNjbSWraAtvmav8ZErxjbzdxITQF9nI3qExsUkadrzVseiZEE2R7qe0HPbSihR07BSz/5RiTJw2jbg369T6Pu/p/zUEGenh9t+FyHvgI8Yx559g9UB39CJH07jp8DExF9Gra70eFd4hZ1w7di49zQIgoYS8p4uMqvj8I6UjSbY0G7ecnjuM0abey9YMVQ7A/LYIgU0iiNqW1SOE2cdH75K3XrzhJEHAsktheuo7oqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a small fix for the new config IOMMU_DEBUG_PAGEALLOC based
on the discussion:
https://lore.kernel.org/linux-iommu/CAFgf54pBAUm3ao-UJksiuGKtvv4wzRyFq_uKwLe0H1ettO4DLQ@mail.gmail.com/

Where it was concluded that pfn_valid() is not enough to validate
physical addresses before access to page_ext.

The first patch introduces a new function in page_ext that takes a
physical address as an argument, and the second patch uses it instead
of calling pfn_valid() and phys_to_page()

Benchmarks with the new implementation can be found in:
https://lore.kernel.org/linux-iommu/20260114164322.787125-1-smostafa@google.com/

This series applies to iommu/core tree.

Mostafa Saleh (2):
  mm/page_ext: Add page_ext_get_phys()
  iommu: debug-pagealloc: Use page_ext_get_phys()

 drivers/iommu/iommu-debug-pagealloc.c | 31 ++++++++++++---------------
 include/linux/page_ext.h              |  6 ++++++
 mm/page_ext.c                         | 23 ++++++++++++++++++++
 3 files changed, 43 insertions(+), 17 deletions(-)

-- 
2.52.0.457.g6b5491de43-goog


