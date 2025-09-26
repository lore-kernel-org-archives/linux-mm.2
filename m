Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DA1ECAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6BB18E0011; Fri, 26 Sep 2025 05:34:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1CFB8E0001; Fri, 26 Sep 2025 05:34:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895F48E0011; Fri, 26 Sep 2025 05:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 704048E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:34:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E73D1DFF98
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:34:51 +0000 (UTC)
X-FDA: 83930891982.23.776796C
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id 21E8A180009
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:34:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QcFuqq5c;
	spf=pass (imf16.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758879289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOprrquoKlbkEreJojZ4KykFg8G0TswcVk79ghRz+Tk=;
	b=TlxPsS4SGS3E2DtSEEmcsr/GGEL4q5CVUsuEK74Z/8P/feFDJtkordjQa/89SvFZAP0NnV
	SywUPUdLg3FjRXvdYlukT5OIV73d+lT4U5pGu7Qifw1gVapowOtIsze6uFmjwAdGXPSpKX
	0AFJfyqq5FgY6TPT7pIsue37Tjo9StQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QcFuqq5c;
	spf=pass (imf16.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758879289; a=rsa-sha256;
	cv=none;
	b=hVOeegAjkj+Uc1tikmaNG6H4y7rXBXzacafM02NPVDdI9WtK8erYQn+FObu5HuzgHX4Dp4
	lusaM5FzEhYcxzdjkxA6jwomAl+C5o+oaX1mj+j1HkGgtfd8HMJikiNuXWfjEaqOpv6Ktw
	kwLmrCqwG1RU9hrl0MlrVtnfwSv+S5g=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b49c1c130c9so1407196a12.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758879288; x=1759484088; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oOprrquoKlbkEreJojZ4KykFg8G0TswcVk79ghRz+Tk=;
        b=QcFuqq5cm/G+ECUFBW7hWv8LDyo/vNSDwvcoljUBsPX2FIwSExLh2wkjCbf9OP3Gl1
         gecb3zrP5EtAuXidTWTd35nm95kwmdYg9An2X8sfcIrg0oojRn4zXGD0nz51oRyLxXlk
         tl+alfKlDjdSq8DFzA86ECeA4r3Ba5xYHKnAI4/bVCQNEdL/X4F61JpMMrkNlPNfRFIs
         bZ1D5fFUd6nXwXppIskAErEr72GE7V6fVJfDhpX3Vz2HcCR2qESntbL7AejHt60Jei2J
         ocZyI2nUmHsDJfHpMq4U/cdpBsXptwOXSyfwqaiakzVUn5Q5xc+3gOWkJS3hPllwBYG5
         fPfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758879288; x=1759484088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oOprrquoKlbkEreJojZ4KykFg8G0TswcVk79ghRz+Tk=;
        b=Ie7092IPXzDFDMT4VXRMDpPk6CaCSVXEWSwrZDLfbfz9sanUOtoCQ+hk9WVUcu6Q9p
         /cYB30avihQS8bsHqIOEwGIU7PSPZRh0JA9HX+ZyiYLHxIWQVxEhwUQEHU/nGgAEBYz2
         paFX8+XAXpECaqL/xts4/CIzxCAaUUNgeFaZQGwIQ7UOrkQq5rum/rIpbhTCJHQgdvMy
         DNy6EnHM/qN8ffrxGFbsHrlOma9VAPoZGKmZrIv6FR4GMLgl81wSF6RBmAyEzu6wFYc+
         0pjpodUh47Icv+roVYi6AHZHl5UTaczSMakT3tiMQnnItmr5A1KXDZkKddj22VjXJ8NN
         lxSw==
X-Forwarded-Encrypted: i=1; AJvYcCV6UoKR6AgfmFcSBGJYe++9Aha9a6+rqzzc41yENv4YRSpAGK9nUSPwleAcFLVH4omyo9ia/fMg8w==@kvack.org
X-Gm-Message-State: AOJu0YzhR576LwvtVOKL4yV+b0Kic+RxEXI36DETovz0Z17IQN94LWut
	Zirov8Gymi6qHodP0QUuYldqTvBtTcXejq71c9IX+XCLPStJ+rlJ1ett
X-Gm-Gg: ASbGncuiITSbG05862lhXzWYpyMWbKBIOIC0NQTpTsjrKjTw5N/tzXv03UDd+mxaReg
	8MBF5KrLMvslC98SXqtNHkNbWCBvvz8Ujfas/ik4V1T627a47o5D0p2Fmm5y4u9CvlY48kDD8jE
	Dcxa4TSd8wQmoAxc5IQVfu6E6ll7ym/Mf+9uAUbtO4S+K6YXIeT+OQAoVxb0rcgL78XIfR7fiR7
	l/v4Yhmyy8s+g17hBxZ7m0c5Xidu+Jvmt6nvIJ3FwOuBbHsczWqJYN1OR00DRCo/64x0JwHCBlj
	f1BLQLO19tGmS7ylFMOH+lxGk+tngukDkQxoJLnTnZcncUEtA/tN82qBANfiuhCDYZqe7i61ioV
	A1P/xqtzr+/MeYVUr/Pat/utmB1vVY4WkCbU27MGqxcfzITNv9hrAY6iWVCU55rn1ZMNY5Wwgel
	Jw4aUVy6JWAlqM
X-Google-Smtp-Source: AGHT+IHyNvkqZ/H58qTgrC7RxZoAtdYJitsFBBvDlhUuvEFdmMnVmU2Ltz5BgywZtZV48lyMJHsZWw==
X-Received: by 2002:a17:902:fb4b:b0:26a:b9b4:8342 with SMTP id d9443c01a7336-27ed49e9308mr63284705ad.25.1758879287971;
        Fri, 26 Sep 2025 02:34:47 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1c21:566:e1d1:c082:790c:7be6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cda43sm49247475ad.25.2025.09.26.02.34.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Sep 2025 02:34:47 -0700 (PDT)
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
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v8 mm-new 07/12] bpf: mark mm->owner as __safe_rcu_or_null
Date: Fri, 26 Sep 2025 17:33:38 +0800
Message-Id: <20250926093343.1000-8-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250926093343.1000-1-laoar.shao@gmail.com>
References: <20250926093343.1000-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 21E8A180009
X-Rspamd-Server: rspam05
X-Stat-Signature: tsozu85ieo1anj739hidwidr4eghar78
X-Rspam-User: 
X-HE-Tag: 1758879288-895521
X-HE-Meta: U2FsdGVkX18IvLmAkbwMB6jT04lbdpP3Qa3kjIHtvtKqeOTvhjZjWiGKbpxpQsUDv8fcDTlsButAPoELE/fUt2Ui4M5jB2ozUN2aBeni4z7hdLVF8tb8GsYyEYzX7goNYPtKFzfvv5J/QevlU5GiJOKaCEsACwUkPZhieGFIAPauEiwsgl9yROQvDSlJWqSDk9hlEz222qYwaXFNNV+/z8pDmt1XhVqHLjgJXupxq5kJswXLQ54JmnrQjVPpuuqYqX5G1wD8dbstgHPYNHLETJ9L6uMz7Gvm4fjrdRI6ytE8Y2t2C2hZJfM8/J29BGnOJz/Yt5XLtxrltiNY0BrLVVi5VliT+mifNaZSwq1fhhKRFnzGFLn7fvBiN/YRXVuy3virame5NUdbFxy5/2alR7Sjpo6PQIQdAemALuJuHjBQe7MPqQ6gSbIgjI5CAFjUNHpXYncNnoK2ZmIffPijYHLJyFGYyJJCml5JY+CVXWqgF4vMPkbxlHqv9WRKxFruiP6F1ggqLk1+ZpgPq0QgRWEm4iOxBf2QzhlubpzS11Z+OUjWvSnkyfv+YT2SwrD6ma/5SMyyhXwzYj8NvmOY+DSFLzGi39OI/9GRslZxLyXgNlu+h+veqW5JavbKIPXNoBdfHZEJnCqSxgnxi1MGGL9gDX+kIIAck2ayb3ln3N6XaFrb16h89sypx5imhLP0ac2cEvRYSfet0C37pP0CFgzps7uM8CsNH7IDtFoup6W9831mzJncz48Dx8HEBNv+cmqz2ZU+UP/WHjFNRIlYwlDyeiu0SxWUJz3ZnIhv5FmFred6Dcrba4GsziZ41u9CWUii821sk5G0Iq4tb7Mt23KLwqDWbIrFCmuyf3E09HXA4VLoohCR36Q16Tz27RA13lrSzL/8n9u/ke9gHqBo39m+fAnILGpzpnKs0WEcvsGxqCWlUp+FIXPx9Cn8KwMPKRxW78DdztKtJHMK0FU
 tMZDgOy4
 lqDThb2bLiVhgFGCXqpznxYbkRLSzV1HObHJT1PVLVf8jafOt9zlvA8yq8N3ZsiyEhyVf7i9AV8YCUxq7n3dVLn0H19v6mQr5coo/Y4A2Z4zUQuI/wwvtYFr4z/Jqpk8iYc50HCOIcyyhWomrC5z2nhJoX9H9AG9e2aqvHNRFI++F8JXVSKF/4HC0yquob7FZDy2M2pWiCx6B2lhSVESDl9DLlTAP6cxK+Hx9O3LmGPwWuO+IhnKWdWdhWfNnFp9bEAJfmSUwD5cwxDO8ZdR10xkJvkhNbDAEXbMuxTfei3VuqqQvJIygyl3Hqtr1xNYRkDCZU3tUyasCPEWc6xKe+NGR218yIhwsOGEWmHNRheK+XqJo8zAHCXdUVQEx28Ac44XAUmeduqK8zb+Z5q1qzuUAqgC57AZRYKA3cGYivp0uUaZjncJekBwqfF36S4tho4pku52NrX44qsVhGShMM4u0huQNip80RAg9+Ub3reD5xfHljKDjR/fVNpO2hdfekYfWOMjfALSAlktpLgw+LUc8l/UGitXFYsQZKuV9LLH07DYOw4rAE9fF6u+oQOgSn7TPCjRESittE6+cLHXeUiMC/6gf5dDZUr5fcn9J1yoFs54M/4Ju3MdZyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_MEMCG is enabled, we can access mm->owner under RCU. The
owner can be NULL. With this change, BPF helpers can safely access
mm->owner to retrieve the associated task from the mm. We can then make
policy decision based on the task attribute.

The typical use case is as follows,

  bpf_rcu_read_lock(); // rcu lock must be held for rcu trusted field
  @owner = @mm->owner; // mm_struct::owner is rcu trusted or null
  if (!@owner)
      goto out;

  /* Do something based on the task attribute */

out:
  bpf_rcu_read_unlock();

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 kernel/bpf/verifier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c4f69a9e9af6..d400e18ee31e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7123,6 +7123,9 @@ BTF_TYPE_SAFE_RCU(struct cgroup_subsys_state) {
 /* RCU trusted: these fields are trusted in RCU CS and can be NULL */
 BTF_TYPE_SAFE_RCU_OR_NULL(struct mm_struct) {
 	struct file __rcu *exe_file;
+#ifdef CONFIG_MEMCG
+	struct task_struct __rcu *owner;
+#endif
 };
 
 /* skb->sk, req->sk are not RCU protected, but we mark them as such
-- 
2.47.3


