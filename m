Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13AE5C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 04:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F274B6B00C6; Fri,  3 Jul 2026 00:14:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED7B66B00C9; Fri,  3 Jul 2026 00:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DED406B00CA; Fri,  3 Jul 2026 00:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFC526B00C6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:14:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2DBD11A0420
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:14:29 +0000 (UTC)
X-FDA: 84946148658.13.ACCC781
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6AA621C0002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:14:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TQ+g3pC8;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783052067;
	b=aoFY/Yy1Z9BOogwW6FtYh2cVi92RkXLuiWFr3ykXyhkf/areTewIG/gHgaL/2fyqUnTcAA
	VaJDvcPmRh2BvRnXCmqLl4d6/dAxnUAaWDMVBo2sdB8NDqfNEtVF9tiYhf+LAuuoq2Lo4j
	YUusubIhuo2gLMR+9k2KZC8npCgtRO4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783052067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jqXn/X0N93kvWkJarTQhoPtzUbI801hVn8f9o9OjVHg=;
	b=G7GDv0jxkVtBd9Iuh0aT0rbW81m/44eTmrksGooBFmwqzlqNCgW1cCL3xXE5Yd4QrxvvUp
	rKJQMatwNhgQzq0vr8KqnniEZ2unJC0TAXLiPCQLQKy+9qcKBOhY3rxPRbv/x+2wGHhC2z
	w0pb+JCzcqxPhNyYBZlbfVBQjWZLD98=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TQ+g3pC8;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-847a69ba83dso94979b3a.2
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 21:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783052066; x=1783656866; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jqXn/X0N93kvWkJarTQhoPtzUbI801hVn8f9o9OjVHg=;
        b=TQ+g3pC8Re6TnNWvDSAk63Yk9PAYiDFGiIDthg6gqWJff0DNZryP2bLLPifVZEGL7x
         Oz/sYTCrqbwvitDAYIARUx2O23KHRXAzQS0QgbNnX3QK6iK4Brp3ZWFbgysaOtDcy9aG
         U6jJK1ksFkUItOjzhXwdGAr84YHsmrNiBAO7oYnTUKzjQTNXr9pN+8aWTOv8LivkAIg4
         YerYPVabmv1pzFsgagdG1XL4Rm/WQ9JHs6dYrwPv5zooMA8HDOFOYxSspzTmk5MJ5nnw
         v7hyrbMDbTwVrDXSWcBL5W5Fvisf6OeVWXxmi5gXutW0oNZaiPJUbBjY1ZcswZUlAlaA
         fUdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783052066; x=1783656866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jqXn/X0N93kvWkJarTQhoPtzUbI801hVn8f9o9OjVHg=;
        b=my8IfMyQQzvpV/OWkoJ3VFIyoPcAmz8RRdQEKd/jKOO3hxq6Qd6GScLMssp+kx3U18
         +I0eFCDygRQFUUOjYO1TmRdOcWD64+xWWA3mQ0Mrvw5/ULOZDTQcNuRaqC4/ckKL+NFc
         jm9TYqlTh4+CA3HAU578E5P6pNNerly/SpvOANSJAaH+7TbC7TNU8pSOK/r7n4jP2I2r
         WczXP92Y2McG3+twgL8PNLecE7IIBjOpz3Az3lIh/XqxSiNqOr+ik5JeYUA9x5mBFYx0
         vfMNZacliKq8sv7iYB8QUjGVE+75xWmkUVgOgA/J96vVHYEY0mE9iXDmsKKJoo5aBTxl
         uyMg==
X-Gm-Message-State: AOJu0YxxYNv3DhlrSE16m6hjYtNzmlmWybb/B2g+nzVqhivWsxF6Ij/m
	gv1/zJHu+EjNKBLTDvbfXXBV7wr3QO+oHjcwuM+BYmGBJMQejyJGqOVg
X-Gm-Gg: AfdE7ckIQn0mh9w+/WZuCPJNPlFpJQdZPrXF++Ormd0mu3augWNoh2B3FtRsOF9qrlS
	WmJk7sx+C1h9IyUfWH1QxQdMZ5zG5ILkXCgCO4ek81QWWloAgbfh1LjPDGHnT11OhwKmK2SQAZg
	wDoQXMa4q/dk1yF3Vh6iVvB6B2GDRGAFeGO19Qbldn8ruBFg5zkKL3I4+PF8Gm0CLota0Je8lX+
	NbYSA6AtPPCOYPOmjMbqxCpKZNt/eG71zG44DaIVZBjTUPZjsaU61+PX0lFnQ4llZy1USPpNles
	oE0f1IsEmuiXxmlIlHPP3WRlYX4reJCxkMXsteEjWqHCO4mIjiZ/qL7kmgw8/SAGN8YFIZbUjVy
	7BFnKo7tNCf0MN9SVh7k3w9iWCQgcuB8mB6PabZC1YmHHmbwKBHHthgYCx1qWpgaWWJcCAYuiOq
	lEWF8cTSAFd8NhdOpA7Q==
X-Received: by 2002:a05:6a00:944d:b0:847:83bc:d2a4 with SMTP id d2e1a72fcca58-847c068623bmr7514208b3a.2.1783052066293;
        Thu, 02 Jul 2026 21:14:26 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb94bd7esm2207768b3a.38.2026.07.02.21.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 21:14:25 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	Huacai Chen <chenhuacai@kernel.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Danilo Krummrich <dakr@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>
Subject: [PATCH v2 6/9] LoongArch: remove redundant numa_nodes_parsed node_set()
Date: Fri,  3 Jul 2026 13:13:26 +0900
Message-ID: <20260703041329.2797584-7-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260703041329.2797584-1-ekffu200098@gmail.com>
References: <20260703041329.2797584-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6AA621C0002
X-Stat-Signature: uhp7afzfqhb56jyuqx771rw6a89r3dks
X-Rspam-User: 
X-HE-Tag: 1783052067-441060
X-HE-Meta: U2FsdGVkX18WKb6BcsHbZWl/e3m6g3MsNq4qxkh6cPv6ZkgbjsxxoQOHgeY8JwVwQ2vGVJlQ2imcR1szsIdZFSHOG0akhuEhNkpj9JM0LcJ2i65/El8JkdTV1I6GU9hFgqLcq1kuWya8/I/wkbZXt6iVt93XeqLJzB7NOQFCoLS407s2vld6dC14r71uaAU5BYRnuxydoF2xB5pSLdThARtOmG/qxLLfqhATLSuBu2QeLr0mC2HBXPbjSl9sY3Vqa9tfTsVRuDBA0sNNz6bm3QKQMQpdA+iAFle47MU7V51At7zJV17n/dzXmSWT42lFqvAkOrGH2N6NF8CasYKEoBmd6OlfTzQwskcVy4oq+Tczbk+HhOdHS947eb4QvrTqe0qMnfg425MtX+YzirjdU+SXAlu8X3kc14R6hyu6fn1K8ucstRhvgSLq0X0EIiSVBrptN2jANgyr8dhJFkXT1LYfAHN+xFgui8F7aEWPRQrgQWBP7YObaX+3IAAUYSZLPsKIfJGCjOi5fyQfHHWc9HFfwW3LY7FDYcXed0y/lDSBsOdCVcHKbvlmKa0beszxazVPkRdM2irhpaRb8nw5bL4ZRb+A0HLap5s1n+tiPTOgpod4ZDOzx8JRkqXDds/hdMtfz+gBTN130ULPtVEMjUshkyHimX3Q49h/eHG7Qe4dLV5DKIdgoNHtVUSWLMGp3Nvk+gYxkExhIxtlA3C3Ft9UxKIrZfy694N0LfSVk34MWArr+L041F4KD/hGTMb1ZV3Mh+uolDBRimS5hBqDuYy1KK07/tONRcISAujgULLUl8KrmS7O3r8Uxb2DeaJXCquDAkAaglCwqTdmKVeypJL/isaxXkE4zM4mxTYXPjsHTPUZKd3+rgoSE27o9hmRTSbm7j6P266e84fYcoTxtN8sz54Mrckk3gtcwDy9wDW5UQigLvmSBsKFVNx24KdsQONtYbcqw6APRfnZkxV
 5WG51nXq
 KoJoTCYp3jlnwVD8pnXgS/cOTIK8M0xwbOg1yUYvpkMm5GW3YQWNrc9hlEjK/551WMM0e9oE6/SXS6HHOfxZXm9GfuUxIHz3KZvBIx/MZFUjAXpdp48fDGnq9tSNG0n1D0xU6wvP3pKCRzKYuU/c8X8CzJAaxAVlXeL6Bdl044uGyNWSKbrFY+G6q4bHcix+ysyUfkdePAF3DvaP9Uvh1aPVfF522K/Wqlh+hg2Osk5Aixz0B2AYweXfRXzQfVhCJfm7ZgcIpznU9nPStO5yXrNH3S2BnHstkPgdKM+YDcr7VI/IJVDMjDgYWh4Zm4RYdVnuPtKK/0oyAmxZzZH4oPI1xLiiHa33Eil2jsLXzvRbpUi/G7dOHlhTJ3hHaZMhbfse/1is4gvvY+GEGrzzzV4RIq54Wxh+A+PAnyDqmLr2UTgUxppij/OI0sfIGrVApZZMQs8ommq+rbMc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

numa_add_memblk() now sets the node in numa_nodes_parsed itself, so the
caller's own node_set() is redundant.  Remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 arch/loongarch/kernel/numa.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/loongarch/kernel/numa.c b/arch/loongarch/kernel/numa.c
index 8b89898e20df..c96c53623715 100644
--- a/arch/loongarch/kernel/numa.c
+++ b/arch/loongarch/kernel/numa.c
@@ -216,7 +216,6 @@ static int __init fake_numa_init(void)
 	phys_addr_t start = memblock_start_of_DRAM();
 	phys_addr_t end = memblock_end_of_DRAM() - 1;
 
-	node_set(0, numa_nodes_parsed);
 	pr_info("Faking a node at [mem %pap-%pap]\n", &start, &end);
 
 	return numa_add_memblk(0, start, end + 1);
-- 
2.43.0


