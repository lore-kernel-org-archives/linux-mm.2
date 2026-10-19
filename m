Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D066F606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 21:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=wWW6wyoz
Received: by kanga.kvack.org (Postfix)
	id 27F4A6B0398; Mon, 19 Oct 2026 17:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 256FF6B039A; Mon, 19 Oct 2026 17:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8386B039B; Mon, 19 Oct 2026 17:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC67F6B0398
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:31:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5DDDC1207BA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:31 +0000 (UTC)
X-FDA: 85340672382.05.4F073B5
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf21.hostedemail.com (Postfix) with ESMTP id A088E1C000C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wWW6wyoz;
	spf=pass (imf21.hostedemail.com: domain of 3MIzWaggKCAEenbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3MIzWaggKCAEenbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792445489;
	b=sVX/SHMI6P1ACYIqDqECtmwGI6IQQil5cwalCz86TvOUEShUt/nuN3I+d/29Ul2LLyuhIR
	hkCCeRn7vvX/t1FBpdpYNeZeMDMPn8YJ/H9IfAnm6eQXY9cRgCPZb5XBdhvbz4kd8u75RT
	f7JgSuR70K+ku763iLzi8GDf+Fja92E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wWW6wyoz;
	spf=pass (imf21.hostedemail.com: domain of 3MIzWaggKCAEenbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3MIzWaggKCAEenbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792445489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQspCOyRyocPeuGvIH5YlNChv9LGZMbmr1LWcFqx0m4=;
	b=K6NqA0wKw4+BoBdX5n98eckYe5f4L9xRScsfaJkEN4PFu1AOOH9+Eb2VKaynMj2/Tl1ih7
	MVCrtFaLR7K333nT7nRBa9avvFzJ7laewGMVMQQ5YniBZ95TjSeq0Qh+jSnbC+pLmHoQlA
	ICEKe4f65ivxzsBSzSjJmyjNqBH7f+w=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1ca15334cso3041864a12.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792445488; x=1793050288; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aQspCOyRyocPeuGvIH5YlNChv9LGZMbmr1LWcFqx0m4=;
        b=wWW6wyozjH+7li7ZvKGsUC/+Qq+tLJogFU/kO0d7pPZjGmsVa1B79Fp52upW88bCqC
         eS5NbeW4mdeh70uryRpgp9r/y+hAKyqoctFdrDVGGzZtKkjPZra3S9Eqc6sby0gB2YR9
         zhAalcbX1se0gH42C9sLchhJnqE6/ov3K31nWrcoIYX8Jb/hYM+/cDwcoG+krl1CObjU
         bQhzmnhWw+w64wJb+b0hXL99vD8timSX3G+m0vE5kB5QQ8QDdZsivPn+Aif2Exzix9p4
         RFd0V4pBTAiSJ2EYEIy4zs+IFsu14ICvMupUzUF7/GES1uYfeABl9/Je+5VuOK/F8JhO
         qxdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792445488; x=1793050288;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aQspCOyRyocPeuGvIH5YlNChv9LGZMbmr1LWcFqx0m4=;
        b=kNbT29fhAtk0glpMIMCqvZF9gyPUnTGkjKll5cMaaW9yH4x1hvyGQ6Jytf6uri+B8k
         5XrP7FNOipx8Rb3N/F2+snUu39HyUxvQrk4BjIxcaA3dnsW11Q2FtX9k9KyPgXI5TrD9
         Mt7hJUIb4+32a2XhKcJ5qLN+s089pAIQ7Gs5SjGohfDy7bPAA+iYlBHCXj/7+FVslz1O
         fs+Q1CsOwoFSJZQdkgvwpnsf6VZ0KIGP1Nm92XONr03bumqvr0ih9d4AaOlV2QAaUq5Q
         Ovy+qQ4vqts7tn+PvUYpcpOylIEbeFag8lj49fzWIXk1RFOOz4QjJm1155OrBqjhGLJI
         Cqvg==
X-Forwarded-Encrypted: i=1; AKwUvBzSHBz7miH7iaShTqq3ZgpYyzg+wRxAqIsG5vKIuxVOsbA3YaN79THcuordoO5ixJiPoCNJQfk2mw==@kvack.org
X-Gm-Message-State: AFq9FYJ5f3K6l0UMtDgAEh4tTZliVgGd6hsxryfN4jgoVBBtGQ83B47f
	LNGoqK4ICMRz9KST0PpI36wSOAbz6yiRzHc49C0aBCEnBAHPDTAn0OtFnXfG9z18rVAQLCCYtXV
	PU5ZlxvWaNTRWNw==
X-Received: from pgld2.prod.google.com ([2002:a63:e02:0:b0:cc9:f746:40bb])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6f89:b0:3e0:b937:883d with SMTP id adf61e73a8af0-3e225fe8995mr7731521637.25.1792445488192;
 Mon, 19 Oct 2026 14:31:28 -0700 (PDT)
Date: Mon, 19 Oct 2026 21:30:52 +0000
In-Reply-To: <20261019213054.3157159-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261019213054.3157159-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261019213054.3157159-9-dmatlack@google.com>
Subject: [PATCH 08/10] PCI: liveupdate: Prevent releasing resource windows of
 incoming bridges
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	David Matlack <dmatlack@google.com>, 
	"=?UTF-8?q?Ilpo=20J=C3=A4rvinen?=" <ilpo.jarvinen@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Logan Gunthorpe <logang@deltatee.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: do7mb17dujk4nzy7eos7akf7acbihwzt
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A088E1C000C
X-Rspam-User: 
X-HE-Tag: 1792445489-974796
X-HE-Meta: U2FsdGVkX18Gb1hr2PZ8lJ7WswzWSbGHCwzgra7TJLGJdvo7dQJOd0kAsb52yPemCS7eeReU81mwtklkJMuqK9vMeJ8Er1km8H+/zhhb5K4kL0VDLCcKRRXbQLxqyoM01c87+ZIgA3GGqkz/2dg4+m1qC9bl/Imdcbnfuhrz2gkEJ2+RAif2qxHZmrEIt/m05HBcYH0Rwv/7qDfZBGG6WxYFRcDxWFvWyoAXWHDMRmkfgxtTy0K+VliLqy8hSkOgIuKSUty8cq8uORA1CCvxrUIFfcB/YjzH3nsQiCFjk/vj7YsMwC8mNtIg3meJFv/KuLw2AJE0WY7cP/Y30GZnGT1NCvanFlA4U8QkiYe5+kHU23el/UG3RXxczLade0Fe9A8qZkvvu0AvC9RCTuh8QSwX9awSt7xQv0T1OxN8y6vgv+RcrK7eWXoa2m7261h5ZH6MOv3YgyaZJJn5aRO6ZNJ7SI8cQ5LHa4bNEXtZ604eIL/sdcd4f8zp547pQxvEyOzoNMd3sdx1aSZmcPdYWpn5qx2wGx+morn6astCH13AMjuw7Q40lPsLMfbV4vN55nrDrpeLr6epQbjp/NjMTXyCCHAMpr5kguA135syY9iaG6HTl+GsyJcdRDN8lb2YXHD7Y/WeYRtduaptIl/qgZ4Sa4bnFIwELLlaMTlkshueZzdV02DXk6eY186wO3iMMKIx56hjIuOG1wbv2mXNLL1/MYRWD/MVN4A+zHAykuThgZGvF2KVHwx5MV6W09HSNR54bCkINUR1Q5P9YZizLOvqZ/OVZbc2SQ3IENn6YRdxUARljZUrrurvGuOzpgAndxp3UqeEK5O7fXMeXZ4nBgR+6gj+12XtPcXoNABXLZvIvW+YTa6OkyKVanM/C9jUnmm67cPC3fOQQysPr6YMknlAB9WjCNbUJg0JQCQesEuvowbbudcJ8OJcltvvbwC7kbE00FwkxRUAX1PNSSB
 Uz0pXuZy
 3qTZYqKJJv9N2cp1Mh+9uc8BnwhsYuLCdZGvKYlIZCiXg1X1krp6cA9mkvdB6X9gYfEybtkYaQCRmkGDZXcJoOwckBB5i4AxMVsP0DF/ileog5H+VqdAndayGaAhDyTD+H5ZyKov3O6F7ppiQXYTb7w1aj6HcuJE1st+hHXCe7q9DmGhlE5f17+35WvWgQjDekCTWzuGknm4Yaczicq5OO3wH+0oxdsUVu1npd/BB2pt03iD7SDrvvFraBuh0OkLTvGkwh7iqJAxJDyCWONe/lGIwc23gjnuz1QIP3GWJ//XELJTQlFRkUoe/Jef0a+GvJbZrA7P0w9ckr9JDo5CuHN4A7FDMfsibz3brwtIYwVzhjqss/tudaoR3Q65Is5m3VMtXNnfw/UZHDRvIZi6rxsu3MJmKcjTzIu8K0uD2D+PM+60pjgRwreCvxzgqnr2vYXpZbBkhIaFGrxmfOEnKfT4Ru2al0zp5fkOt2h/uKLYgWuNRY2eNRCZ7QdQ4/py+UF1fpAant37DTGEzhO1ECscD9+D57b6ZTGd6qrNicTzNhWK624FIPUEfaFt3EhcCuJpr7pFULPosEEtqFL5FRGVvs1vHlgNlInuT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Prevent the windows of bridges preserved across Live Update from being
released during the recursive "realloc" failure paths by adding a check
for pci_liveupdate_is_incoming() to pci_bridge_release_resources(), and
log that the window was not released, similar to the message that
pci_release_resource() logs when it releases a window.

This prevents the PCI core from forcibly releasing a preserved bridge
window to satisfy the resource needs of a failing child device.
Instead, the child's resources simply fail to be allocated. This should
never happen in practice though, since the previous kernel should have
established a sane resource allocation before kexec.

Assisted-by: LLM
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/setup-bus.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index b82440394ee2..7283c4be803e 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1700,6 +1700,12 @@ static void pci_bridge_release_resources(struct pci_bus *bus,
 
 	idx = pci_resource_num(dev, b_win);
 
+	if (pci_liveupdate_is_incoming(dev)) {
+		pci_info(dev, "%s %pR: not releasing window of bridge preserved across Live Update\n",
+			 pci_resource_name(dev, idx), b_win);
+		return;
+	}
+
 	/* If there are children, release them all */
 	release_child_resources(b_win);
 
-- 
2.56.0.212.g129ede20d9-goog


