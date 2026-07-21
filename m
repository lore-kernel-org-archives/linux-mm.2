Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C760CC44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BFA96B00B2; Tue, 21 Jul 2026 10:15:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 498316B00B4; Tue, 21 Jul 2026 10:15:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ADAC6B00B5; Tue, 21 Jul 2026 10:15:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 077B96B00B2
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:15:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C80DA01B3
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:13 +0000 (UTC)
X-FDA: 85012980906.17.3ADDC23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9B0411C0003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S2zXb/dZ";
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bLaf5tyDxWCxvlHTtD5Z4k1xuBW7w64hgCUEqdp/QWY=;
	b=pvO+UTGotmT3akLH0m5SwDbxOg+bdINGtsoMFzSVp9188CMrtPr7fM+VEV65s6v6xUXBJg
	gBBPCR4GdGcJh3B+mxK/DNHcUhEjOcnqF8IcOluyG07E2YznQImvKqrt67s6mh41y8D8IP
	htu6+Op6dXRdUp1TivoC1T1oeEbipZU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S2zXb/dZ";
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643311;
	b=AFj5X3R9Z+Mo8SiiVh7JgmizICuqZTCklH2cDhc6tKBMDNN4w1cZr1IhGbjEU7X5LLRD2h
	Eq3sRV7RCpgMLG0yJSOxboI4XWZemz+OT0rF3H6BjhZ7LHNX2SlR6LL/TO7gGCQ9mBDgwU
	8DrYP7c9yJYb5+QYW8rN9rwMKw5E5Vc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E7684435A0;
	Tue, 21 Jul 2026 14:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E331F00A3D;
	Tue, 21 Jul 2026 14:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643310;
	bh=bLaf5tyDxWCxvlHTtD5Z4k1xuBW7w64hgCUEqdp/QWY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=S2zXb/dZrasMLZ/uaMCz9boorv4beZgIxRhuENjwATRQZ5mqaqFSIXVSo+kkHYylU
	 tITkd3LgsxjZQVwAtIDa3JvBdNFf11ZQ79AKpfCh0RbLZPNAQTZeVJX3L0dJNzf1Lc
	 nT0ygtbqd0grOh0+mgwmmv1srlpQpl35NAOw9898Ih1upg9j9QClYBL4tZawNdQUcS
	 5DsWrVhen21diStt0c9ZGQYw//KpfFrau4zLZcBTDjZm7WE4lEIA8W+q4iQ735uJls
	 x6Tj03wFS9TDvYvulQbG/ymFVj4gIt401+prpY8UUF/IMYXX/vBhMHPJaRDgZ4EKgF
	 sTkqXyD5WoAQA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:13:56 +0200
Subject: [PATCH v2 14/21] binfmt_misc: document the transparent identity
 contract
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-14-e57866e4ae0f@kernel.org>
References: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
In-Reply-To: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2622; i=brauner@kernel.org;
 h=from:subject:message-id; bh=XclEE/Ai2/yaq+1kn6/7w1hPUg3O6QDYJzvXiuRCLbI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1x1oqX23496J52lX1D4bXdGbwuNXwdYls+9sbknIx
 PXLpgbHdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyk8xgjw+YK15lBK6enJLUn
 R1tb55XZqPCdbb1iaj9FWPJvlprjTYb/SYcPRPSEVjZd1n/nfoD/b1my6DUlzavrTpfcm7nqT7E
 0LwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 9B0411C0003
X-Rspam-User: 
X-Stat-Signature: akgugxsrqm7ibcaoja64nt1niga8aq95
X-Rspamd-Server: rspam04
X-HE-Tag: 1784643311-635438
X-HE-Meta: U2FsdGVkX1/V8eGDN4TnWLWwy0uj3PjzOAG3qyaFPFl5qas9eJr8+jhZPhHJYWH9LlHQ2CNRYkQd21eeM2+YCLhnJiLdYtG/70awOTnYwAMSvBRECp5fc2ps5WXnhCT/Rh6QxNhJyDqnhzYmE+b8Pi1PmgM5kMAJVnQog33w5VgE7zsFau7Kkzl2x59PItTuNoXL0DiGLtpazcSUYl/x2/TkTyf/kOUCoqrDj1VjkHliTtbyVK8ubZzkZjTZjmYdacUQqNHBdQL9vVG78cR9RP9Js6OjvKgp86AauSuRS8LzNJYeitqLS4IOtjRFZdkNEMMy4EDBhEi5BcUFGs1OjM8vXqrkblj8CuiRSqjtGJ02nzIsBFeP+Ij1/g1mbW2UHxQpNkZVdLp/alCIkM9u6Lac7PcxMqeEvExd6VDSOiwWrF2R1o4ZksCv+pCFCTfu3eBzZbfPM5QBTJpyanytNThqhqUjlBMFFNFbYV10i4H1IEJzOTf3gtmv00ULFsy/22SKa5D8WDLYdGN6HIacAN0NKWMckGOJT86vxd/TO65Fr2U/Mi/C0pe8nLhqkhC97MVal7sm1rPOQSfIbaZ0OUfMT5t+yDvDbmf6EWnFXjKsy79Nb2Inv+JIUiuI4UrPzuMLxNIzxlc2U2h1ryxzKEV8RN123tCNjRfKDmCLm1HTX6EgfvYWwvynIF3DGUZwElu5+LArN59c8l5XDz4B+OTTAupy189TAC4eaW1pkrzLICqHFfn1U4BeqIu1IXcJeYeKqCc4356R1BT6aYibxyZvkyv2p5GwAhkcx86gakLadxmGUU5JF0iw5phqddEDtEheTes/rrAYeh1pc8dBnkxKSN5nYvGKgEQBRZi9272OEetblD0GIBk/rugpFSD8w4SAiRXNmeK0CUUZzIB16lFX/is9kl9rQXr7Cm3Kl/TMkGAoBwPo0KJgFpNtJWSbryAH9e8AL8ZMLfG05K1
 wYpDRZuo
 uE9BgztdQ0m2UCRcOWKW/Q1fj8Fskfh5yR+rA8GWsd3vYF6CfnlwddqALzcNly3UI90RnABL9DDHk0UqD723Qx83SnbsPCAKm0+zMzzi6noKej3jwmqfQLxjS7WliPup6QmnSDBVMWsT88WGyTKZlMuVNWc+SO+CBSX+YrMd3T2rcltm6VIcrVwH448Ddo8dLpIS9Ny/x51CLm3UNQTHhRpLgy8ETIKd4OiEGJ/ZGWo6zKYcG5hxMI34UjSce1iBk+eDJmAogebUt2ZFVRfr2fuyro8K4SlPUaqgcC/E3bVb/XNn2TpjGABpmDlbgTV7GOv+VIF1txsJH1m8VCVjXBh0vhbGb8ch96u56MNBw8TEriOdRJOHkinpzgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Describe what a transparent dispatch constructs and the loader contract
behind AT_FLAGS_TRANSPARENT_INTERP. Also note what deliberately stays
different (the address space layout) and what stays unchanged
(credential derivation without 'C').

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index 81b78e315fad..ea1c1c0676c8 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -223,6 +223,36 @@ binfmt_misc instances themselves are looked up. The entry keeps the handler
 alive; deleting the struct_ops map only prevents new activations.
 
 
+Transparent interpreters
+------------------------
+
+With the ``T`` flag or ``BPF_BINPRM_TRANSPARENT`` the dispatch is invisible
+to the resulting process. The argument vector is left exactly as the caller
+built it. The binary is passed through ``AT_EXECFD``. The kernel also labels
+``/proc/pid/exe`` correctly. The binary's file is write-denied while the
+process runs and the interpreter's is not, exactly as if the binary had been
+executed directly. A transparent entry does not change how credentials are
+derived. As
+with any other entry, set*id bits of the binary are only honored with ``C`` (or
+``BPF_BINPRM_CREDENTIALS``).
+
+The interpreter has to be built for this contract. The kernel announces it
+with ``AT_FLAGS_TRANSPARENT_INTERP`` in the ``AT_FLAGS`` aux vector entry
+next to ``AT_EXECFD``. The argument vector belongs entirely to the program,
+nothing was spliced in, so the interpreter doesn't consume arguments and
+simply loads the program from the descriptor. The bit is also the loader's
+license to finish the identity. After mapping the program it may retarget the
+``AT_PHDR``/``AT_ENTRY``/``AT_BASE`` entries of ``/proc/pid/auxv`` and the
+code/data statistics markers via one ``PR_SET_MM_MAP`` which completes
+what attaching debuggers observe. The prctl is privileged - it takes
+``CONFIG_CHECKPOINT_RESTORE`` plus ``CAP_CHECKPOINT_RESTORE`` or
+``CAP_SYS_ADMIN`` in the caller's user namespace - so a loader running
+without these leaves the aux vector and the markers as the kernel set
+them. What remains visibly different from a direct
+execution is the address space layout. The interpreter occupies the main-image
+position and the program lives in the mmap region.
+
+
 Hints
 -----
 

-- 
2.53.0


