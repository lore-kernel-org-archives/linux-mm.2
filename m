Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33F69F506CF
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A9CC6B0275; Mon, 16 Mar 2026 09:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97EB06B0276; Mon, 16 Mar 2026 09:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86D4F6B0277; Mon, 16 Mar 2026 09:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7586B0275
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:09:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3083D4A88A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:31 +0000 (UTC)
X-FDA: 84551957742.06.F69AE07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7A094C000F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lfxg9CkE;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773666569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5K7eKfDaNC8F0R4YEvVj595iph2zwfv8FNQbISthhlI=;
	b=Fs1QZewsilaSsO1w9XalLXlxR1DoMinWJ1uLBeAvoWiZNk4fqXdMoPFp2m4a12CsMhBtO6
	njaSmsPuVzt68Rk24PxA0p/MM1acyyQuF6wbuEVMBmeRDBk200+PlI+OcrpiUcjaiD1CN/
	0UdcZAv2/tiRDrH9ILSYKVllZALBn3c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lfxg9CkE;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773666569; a=rsa-sha256;
	cv=none;
	b=6ZZAwRJCx8dPWjzY6sKxYnalZ6Sym2RVwzZdph0G0uWXhiBYFZLAv7hpZhoFnhZ/wN0vgY
	E1DjiuYVKYizbJBde9B4Avp3TgNX0ZJUBBjgPdZmSVhu9BcxXwMf+JVwy0QJ17uRJtfBiZ
	XjVeqS6nCkP3ArX4DCREaeK6n0bb68Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A4A904459E;
	Mon, 16 Mar 2026 13:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5F1C19424;
	Mon, 16 Mar 2026 13:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773666568;
	bh=LrLBS64c+lmBUJM2XbvLHLJnGjK9/zMfbb5TL2UTCws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lfxg9CkE3XOoc6lXpgYy2pcAO6Hc6ib8/1Qy1xhOw+VHHgoC4ldZaAz5MKdUunLwk
	 evL0sHn+qUhum9zmcrNTCgtUpSE5CQ4CGNRa+00XBCSchPYXd/xWLfqxqYJ9skmE9K
	 CX3Ww9RSRfWEGkTZ6eiJijkz9wIFZ61HqUkhV7WD8hwlK523wPS1op1w9qmYFyA7qG
	 FJxsyW1CCw8XR7ax4KyCGwl3ZM0UKR9G6704RJ/9qqFcsQLVtG8dDN0s1e3aStfj+Z
	 w3h7n/urDNIwuIScJ6XZgrH4/EcLdtsWhdHxvyM993b8PDpgqF9DMcTLvAZYv1YIFp
	 WGnfsx1Vg/+6A==
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
Subject: [PATCH v2 12/23] tools/testing/vma: test that legacy flag helpers work correctly
Date: Mon, 16 Mar 2026 13:08:01 +0000
Message-ID: <4f1956b7e1e15293f75bffb5eda3d967a1da6f5d.1773665966.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773665966.git.ljs@kernel.org>
References: <cover.1773665966.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7A094C000F
X-Stat-Signature: 4zaer8y99tragodwizbsrk1wbsgpj4f7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773666569-343924
X-HE-Meta: U2FsdGVkX1/dp8pSlHgPKIesDapLVSwe0eIP6BdAi9a8cFqyAqySvPebj6lRwlwzycKK/ehRiyrvk0HK0mo7DXt86B7PjEVze8piV7boy2krhbbQWuHhTs83R50zY3pQj5xobHWCrcsK365ok3+5BiRH2z+xRcVTIS0FH8jKZv6g1mOXIeRpMBU5TWCDvUO2foEiM62HCPBXsu8r4cJnqFuo//B1GYNiu2SuwdMRt+jKkkUqMc24HdjPPECWqpuTpYjgS0muO3ryRbchEkmH84SUtI2geCNmYcpbrDYWYYDAtwvQmonFr9HDfW6ZLNPpr0DoWE273tMM0FqOuPEApGbNrwX24inzvFgR8s6vHiq6/uLid6YYUyWhSR7+JlIdsuSoivEd/7xk0eUahe5K8a4k6sJTHIw6U3G5DeMm92d5ZeqR7tasn2wvzUVmw1A2V8EPZ2eERPamT/LM+/dvD5Ud2vvcAAGwhmMF+05IIyl+0o8GTfbZX2G0GUx6PJ0QZpRyf3HYl6yh4FmIU/kA0m5ovhK/zkXpSi46JiEkhApwGEPtHCSCzAGWzrNIHfhsSmV0cei/uVZJ1416PHJzYbhZATnllEp3fBTb1dHa4/IOnvpmgDgVVSCP8e17lp8BeJxG0TlMOIU9EVSpnpK6G9eSj/IoYk+J03YnSlW5lFj1nisrwZTkGumnL+FhZ1T3x80QkAiY458x4PGNNKN0AKlqVdc6tozlgZFe1H17m9kgatl6QqDJQ2FQ9hmbKoXKF157tSp1YMYlXdH9xH31ThJkxUK6F/dK9dtRR5XaQNWN9wmLcveOr+FKUeRxqyaZdNg7HiQhtas9gKiICWIhCx8akeSfU39k+LHWdQRBoK2ZXMzucPLESM56oMo/GfGXdHp8NEIP/4IfgvKpfuHOxtAxcGD3tiTiPfF8OnzgLZC4bfb5eFGybVPx+4MSiomovSevehs1tinNC9WnPlv
 l3QMwN9n
 EcFWQhlGXqFFprkqbqUPdjy53pp01rthv2CgQ/istIjELz9IyMg/WuK2rNgsiVKH9E64QtkHP50UYkBXRYIv9MwuIY7lESLVfKrkJJZeWk6hOVc9GUJsyj/jMtol0fKKNTKppcqkVtAhoNq3Z6lIeHa7c6mZqNHBfsHnWjEFJ3uRieJy7p//77GZZc+6MIFibqFtRBRwKP3ctNin4Hk/o3vZr4/JQc1EAsI/Xi3LiU6YSN+jlTQ4cHiQgTpb1g1qY7ZfFUvBZX1OeTB8SB8IcA8R4B+5Y+BzAad2hflFycfjokFSBxz6Y0lLsiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the existing compare_legacy_flags() predicate function to assert
that legacy_to_vma_flags() and vma_flags_to_legacy() behave as expected.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/testing/vma/tests/vma.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index 98e465fb1bf2..1fae25170ff7 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -5,6 +5,7 @@ static bool compare_legacy_flags(vm_flags_t legacy_flags, vma_flags_t flags)
 	const unsigned long legacy_val = legacy_flags;
 	/* The lower word should contain the precise same value. */
 	const unsigned long flags_lower = flags.__vma_flags[0];
+	vma_flags_t converted_flags;
 #if NUM_VMA_FLAG_BITS > BITS_PER_LONG
 	int i;
 
@@ -17,6 +18,11 @@ static bool compare_legacy_flags(vm_flags_t legacy_flags, vma_flags_t flags)
 
 	static_assert(sizeof(legacy_flags) == sizeof(unsigned long));
 
+	/* Assert that legacy flag helpers work correctly. */
+	converted_flags = legacy_to_vma_flags(legacy_flags);
+	ASSERT_FLAGS_SAME_MASK(&converted_flags, flags);
+	ASSERT_EQ(vma_flags_to_legacy(flags), legacy_flags);
+
 	return legacy_val == flags_lower;
 }
 
-- 
2.53.0


