Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 181FF606BA85
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j4k3SiVx
Received: by kanga.kvack.org (Postfix)
	id 5E4976B05D1; Fri, 20 Nov 2026 19:10:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 595BB6B05D2; Fri, 20 Nov 2026 19:10:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45C5A6B05D3; Fri, 20 Nov 2026 19:10:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 226876B05D1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:10:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE11C160260
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:10:28 +0000 (UTC)
X-FDA: 85457194536.06.7902870
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 27D5E40006
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:10:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j4k3SiVx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219827;
	b=LGprsZyUULN2NmXmYn5mBWAX2n6G0/u/meRgf2md5WLB4cPHH2YSJ3edJQjiw09f3hrDl7
	XPgiL/Bu6+CvGK/gi8o1saHcxCNpnefA3KyIi1yjR6BWEoKIYGQs48lrdo5M5a9ie+3ydq
	qrZYVdpNnRwbK/R6uTZXLubMN1glQLE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Eyq4GxevLOo6CnxBFmFSQzUssMKFYdLLMcgPqVG7IE=;
	b=8Guuy5QpKO6dc+6tYTwvIBXTT7Col4vHK/0KDTxV8KDf9F9iweNMNg8dNlVig7HBjQhISF
	G/ZIjzhgTeZGSaPTazri5ernVR/7rzx+HUBxONE4CiFEw705tUrTCa1O5PvMUhaStAzQuK
	Tk3MWJsS1T0Yiha616w1HjNaO4s9mIk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j4k3SiVx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 695F34412D;
	Sat, 21 Nov 2026 00:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7A89B1F000C0;
	Sat, 21 Nov 2026 00:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219826;
	bh=+Eyq4GxevLOo6CnxBFmFSQzUssMKFYdLLMcgPqVG7IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4k3SiVxDcE9xNRlED7134kIVV0tuttt6dCAjAJdcuJdDLCLNbA9NMivdrmSGkgMr
	 OyNYJAI4aS5nK5BjnSJmKNea24ET+/1PJcRvhRqVRku61xK52x95rnz1mf14yb5Cq3
	 wzasJkApfZpgAp4UJQVf+77zavqRmbkwXW68Cta8+wbDYMnflh84pGO1NF3AhW3KJ5
	 bkWL4ZK6uXwvzo38zYKicjnk74z6NK/tPzG/PYLm+025Jhr6sftady81fOpPFq+7OL
	 9CVbjQr8GKAmoKnxNWjVKohFbByvxeQb52RjUYIixDe3jeMOt2VRMI+DTnvns4+r/E
	 77iaHcj4oHZ+w==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 21/25] bpf: Register rootns LSM hooks
Date: Sat, 21 Nov 2026 02:08:40 +0200
Message-ID: <20261121000844.1863324-22-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 27D5E40006
X-Stat-Signature: gyka5nkstrwtfe4tc1wwouf4hqgqb9py
X-HE-Tag: 1795219827-848298
X-HE-Meta: U2FsdGVkX19PaYqJ69MK4pHyigH3/KyT3Do3XbNAwFhZbyl/pnaVo291hZtBGYcqo6uqD6hpBXn136943Y+MUIEvYbTtnIuxrIFiKOHsuIbQzBk6nylGW1PuEbGTQVqrw8F6pBRQPz5qHUxja/P644CkbBcXpgavfWOrIb5hXnBfHBOGDwlrju4fUO9o6hcRlQmbnT1pNDBzEn6h5TYPCgr1n+O1FFtP7bnVUu+rN/RpUqG6zKE11SyMs3VK+GDhcNq/Ds2QIgXOE398gem87KzFV3+Lz6Ym6BCC/reO5lXVUwIcZwfmPUKypIfcXx6yl7//4Ej+Afs7166wBKl60mDYeP7Ak2mhRK/NahkmuiCB/gKG6Zd8PGS0A9pSLnPr3yYUITaKH9iGa1snIH+qu/EjmAy66f6IzTRcRxzf1Hje+8mlX6Ms317IH0mDdp8VhuL1z8cuKAvRSCxJMCwdXm+ITNCVfN87lQ6D+/95nmtHU6KHRxpLrq6SKSsqpYgvkEA25RimaQvsIxrBwCQ5oO6WILb5TEuxRQC9mACyZmh+1PTgLDFrQgbKZVGIfJegHS+61m/3CjY9hnXe9IAqNvfM+tiyXTwHI99c1GffLRobYQOrRxAaGZ5PZx5mNhFsyXhbMRPj6WX5Yh5EyNCiRFbnpUm+TdelYbWsSuho+C6zfxxypwbBxCGDj/W4QD5G/gV0EHbgm9xe1wG+D8AjjKhwjrtHijnuytEFZEVuX2z+bsNpXkOrVTYKjFvy7BaLGJSd0t4MvUjQdkGB2ycS3gojOwdqvPxAuyfku9YujhXBCFYVQYrw2ypB90Y/MpyH0lQN9hSCrbkOndfJOb+hxi8lwzY3w6+0Gg8MCHFuUTh764LFEmNvleM9WvpKdSeVuwcTYmFMc4nqrl45vwT0hVaEPvRk7O8Tenctp97ebxTz2phATKmVgtuiahDpSktRuNrjL2CwsrKx99hUzkc
 Uh0l7L/w
 C80DHL8GkYIN5fbYDTpFyIMVCNbZFfo5EWHTyUYL5cBivSdWjIIKZNSJMiLm8u4AZYirUN66qGmmdx1Zsfuz08HLhAkbyVoPx5EnZgPucHAoHHo6ONDYphYRAq6Y0yfcyFFgvkLVpXq53JUx+Km0qxX6Oyi/z41akEC3zBA0LxJU/BXIZjPPBpKU5Dm6OYtYGz8KX+r1fOiOjXY3S2nOLbbZHkLw9QxbqNauc4+tt6ecOWK9VCZfyXXIwwYjweLg7ifyeoyUh0i9NxAuuHmY4G0bb+XBvJB1qlWrAWfdpzvsMoNWJ0FgyLiMnq3CmuTADuUcZlbm4faeGwn9dc5hNjF+/a/9f44gksbDC7qJmK5wytOHQ5qMTPNCV8pTfOberow40VfaXsw76oWZs6XiOwqG8f2pfR/CAgVGobyQoiDHQYU8a1ZPSUe8LigbJG5jP7GJF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

BPF LSM programs need sleepable and untrusted hook classifications for
the new root namespace LSM hooks in order to attach policies to root
namespace allocation, cloning, signaling, and release.

Register bpf_lsm_rootns_alloc, bpf_lsm_rootns_clone, and
bpf_lsm_rootns_kill in sleepable_lsm_hooks, and bpf_lsm_rootns_alloc
and bpf_lsm_rootns_free in untrusted_lsm_hooks under CONFIG_ROOTNS.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 kernel/bpf/bpf_lsm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 468e63dbd922..bbcf1433fdc2 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -16,6 +16,7 @@
 #include <linux/btf_ids.h>
 #include <linux/ima.h>
 #include <linux/bpf-cgroup.h>
+#include <linux/rootns.h>
 
 /* For every LSM hook that allows attachment of BPF programs, declare a nop
  * function where a BPF program can be attached. Notably, we qualify each with
@@ -404,6 +405,11 @@ BTF_ID(func, bpf_lsm_task_setscheduler)
 BTF_ID(func, bpf_lsm_userns_create)
 BTF_ID(func, bpf_lsm_bdev_alloc_security)
 BTF_ID(func, bpf_lsm_bdev_setintegrity)
+#ifdef CONFIG_ROOTNS
+BTF_ID(func, bpf_lsm_rootns_alloc)
+BTF_ID(func, bpf_lsm_rootns_clone)
+BTF_ID(func, bpf_lsm_rootns_kill)
+#endif /* CONFIG_ROOTNS */
 BTF_SET_END(sleepable_lsm_hooks)
 
 BTF_SET_START(untrusted_lsm_hooks)
@@ -420,6 +426,10 @@ BTF_ID(func, bpf_lsm_sk_free_security)
 BTF_ID(func, bpf_lsm_task_free)
 BTF_ID(func, bpf_lsm_bdev_alloc_security)
 BTF_ID(func, bpf_lsm_bdev_free_security)
+#ifdef CONFIG_ROOTNS
+BTF_ID(func, bpf_lsm_rootns_alloc)
+BTF_ID(func, bpf_lsm_rootns_free)
+#endif /* CONFIG_ROOTNS */
 BTF_SET_END(untrusted_lsm_hooks)
 
 bool bpf_lsm_is_sleepable_hook(u32 btf_id)
-- 
2.47.3


