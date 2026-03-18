Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED3E4107BCF6
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9A06B0282; Wed, 18 Mar 2026 11:50:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573E16B0284; Wed, 18 Mar 2026 11:50:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48A746B0285; Wed, 18 Mar 2026 11:50:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 333F26B0282
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:50:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0843F13BB62
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:50:51 +0000 (UTC)
X-FDA: 84559621902.26.667C0B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 71D6480009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:50:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=heUZTsca;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mDmT/d4gU/ujLRxYybjgEyO5KzFd3992QKL3dwN7te4=;
	b=iGSVPc91Yqu4d3Z0O75nk2wnbK2P+wCtfkK9qHxoPmy9nsE5tYhZx5LqUdWvF0aP5p1uP4
	d0M27Ne1hF+1H9BmqWGx5rsrkBiJWgst7nkOpgMN2Cr27k5WrPeGbU1dJOjc1Tl5GH/6Vr
	oPJWNKPli6hq85S8u3QK6lUaE2eGUlk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=heUZTsca;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773849049; a=rsa-sha256;
	cv=none;
	b=ZZQKCPS1mntCm5RLjZIz+mrlI623tQyhTJkvdhtaS6iGFx6H4KrQWt/uwNpgLwMIMC3UsM
	OI+y8uCX/Rmla5q1fiEQ3zkseeA4BKbwAQKWLWEwIz0QvnfWkEZuB9m9Rk0eYC4QB+63zJ
	WpKOiPk7yhweq/A5lNgNv0670mofjmY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D899061119;
	Wed, 18 Mar 2026 15:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23EDC2BCB0;
	Wed, 18 Mar 2026 15:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773849048;
	bh=1bmVXmNGky0SCfxhVxovkiNhcH5cr4OkT/HqzMt+5/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=heUZTscatGhhk7SObWMvwJE83fDWN/p5K0Lb9X6aF4jqHsuZwMssRBm2LtX/x0NFK
	 UetmPMVELTcPUNw2JeOkHFhR1MgHdVwW1HMNVHxRZjzhHaskVzSSl2aL0XT2t6jB3W
	 g6k6vt17mVCEJlBINP7Dsg6NW+JM3SUFakQUcYfeohTnOnWHyIL13yh0+pSjZkWm2h
	 jay0DKB4No+GwEAaJ2PoiGJIQXS1IAtot6rPLLrQHteFYjR4U9YaC0B2UtdsXPipi1
	 /ixKZpv3XPVc5Oq1URn4d9XGvmi4Q4TK6O7jOOq1Ly5otc3SxNXNvVrNjORiKU5ttL
	 6Z12BLNMGP2XQ==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vineet Gupta <vgupta@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Brian Cain <bcain@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	selinux@vger.kernel.org
Subject: [PATCH v3 03/23] mm/vma: add further vma_flags_t unions
Date: Wed, 18 Mar 2026 15:50:14 +0000
Message-ID: <6a2c2cfa2e0c1582647c39eb427f2aa53357e97e.1773846935.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773846935.git.ljs@kernel.org>
References: <cover.1773846935.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 71D6480009
X-Stat-Signature: jcitw781zaduhwa8egwc5za1bkeeeqag
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773849049-743782
X-HE-Meta: U2FsdGVkX1/OlWjUrVkaVp5S3Vqib8XqLzg0dN8KYW6S4pqZfQYGllypR5hLfCREJGKx8ZI4F+rdy5tqRTUV+rWi6Nr/RN5hDMwKsRBq1Y6RZxRfFGF1yEIlvNlO4npbG8jgucAmY5BdoGdVQK7PHb+GDqkvfjT0gK3MgFpAvJWGc7tVLgnTitg0fyTgJ7uE5MwqhLPm4FTAohDsYS8dPQ2csRxl8ae5oeGjxRs+lNfI03PB67a08Qbp0wiIuEJF/Gsp+uR7hMT3Ce6yzkK0tv5PNgSGwxinPyGPcmXcj0zNBMOlyIkCbwT6I42WXMHzvFq022NApEz3q7gEm9p513GlUyq0dKNSS8eSIX5L638kMkdUjNcMRik26WmVYmYlTopW9qQr35M9hXpofOzViO0w+a7Z5H18CeXIqUYhJDfi7zTW2larb8g/9xoDKKW+a46ISY5VNQcllevpHgVwjZsYmInHgBhadkuiROvLoK0WLY4i4zHBYQMYvcUkcnLT8M8iFxssj1H8EzjVotzpACzM3XghEi/OisVwI7Ne/ysro5b9vm3+1WHDbeUALT3iu3np3XBjSAm2zg/7IJMUGKFdMFYsKgiC5zjZbUcA5xAw0URSASkE4NlNurfwkui9mBoN8Mv25CjAoEjXmMIzp6/Bpr2zryEh8ufoYzEHyihnw3V3Dn46Idh4pS3CsMh7FN8JLa2C4Sf5+6c9PUkvQrBUYzkW5gKo2zOl9i08HwHxzrKi3cpsId40oZmuuEEBUnimzYtKxiZaedDBeXznXShciDkH1fjTnA6U2zh2ZFTNPgKKseLjAZil2F6jSwHKqp5BtffD7Qt22tLulg7X1JeUnKpETRfA7QlEHtHDFCXm2irwqeQ0axFEVl45RdkfI3WXuyAG7wm4PSV0/hBSBAHE0RK9Dgo7jaSmQ1cSCtsY4O5OsZblke3LfRdJNEisQFOiqIEPlB4YMU98eHe
 1XGZV1AE
 NiGXQ7+3wAQOSko8E5jNdV1XfswIXe58W+vuZcN8UqrtlWmRp7XN1+XvyYy7tS7ksJ4S+uG/FY/ouUTl6zXReaAOosIcxjOnQAvqx4mwiwO71Eks4yo9Tl5I+r8DkQnvI7ahaigHDeR31kPzOFAfqIPv1BNF0CcoFRHiaGYnNR76df2xw7Ij/g4dDojsd4GIya1ELz6CVw4BQpf0ZIbq7OFcqu7U7PgK13KHM14ex1+SPjQ0txtzQLHXmo1fvZJyZMDpiGZsWTL/A3EUsuxk+EU6ikBoN+umjpV89CbsiAi1tVVbmMrza6mh17cBsepAlVh8cWWqC9tW2sS2wKXITL6Ds6S+EcR0NJwn1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to utilise the new vma_flags_t type, we currently place it in
union with legacy vm_flags fields of type vm_flags_t to make the
transition smoother.

Add vma_flags_t union entries for mm->def_flags and vmg->vm_flags -
mm->def_vma_flags and vmg->vma_flags respectively.

Once the conversion is complete, these will be replaced with vma_flags_t
entries alone.

Also update the VMA tests to reflect the change.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm_types.h        | 6 +++++-
 mm/vma.h                        | 6 +++++-
 tools/testing/vma/include/dup.h | 5 ++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5584a0c7bcea..47d64057b74c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1262,7 +1262,11 @@ struct mm_struct {
 		unsigned long data_vm;	   /* VM_WRITE & ~VM_SHARED & ~VM_STACK */
 		unsigned long exec_vm;	   /* VM_EXEC & ~VM_WRITE & ~VM_STACK */
 		unsigned long stack_vm;	   /* VM_STACK */
-		vm_flags_t def_flags;
+		union {
+			/* Temporary while VMA flags are being converted. */
+			vm_flags_t def_flags;
+			vma_flags_t def_vma_flags;
+		};

 		/**
 		 * @write_protect_seq: Locked when any thread is write
diff --git a/mm/vma.h b/mm/vma.h
index eba388c61ef4..cf8926558bf6 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -98,7 +98,11 @@ struct vma_merge_struct {
 	unsigned long end;
 	pgoff_t pgoff;

-	vm_flags_t vm_flags;
+	union {
+		/* Temporary while VMA flags are being converted. */
+		vm_flags_t vm_flags;
+		vma_flags_t vma_flags;
+	};
 	struct file *file;
 	struct anon_vma *anon_vma;
 	struct mempolicy *policy;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 8091a5caaeb8..58e063b1ee27 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -33,7 +33,10 @@ struct mm_struct {
 	unsigned long exec_vm;	   /* VM_EXEC & ~VM_WRITE & ~VM_STACK */
 	unsigned long stack_vm;	   /* VM_STACK */

-	unsigned long def_flags;
+	union {
+		vm_flags_t def_flags;
+		vma_flags_t def_vma_flags;
+	};

 	mm_flags_t flags; /* Must use mm_flags_* helpers to access */
 };
--
2.53.0

