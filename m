Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76960103E19E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:51:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28AC6B02A0; Wed, 18 Mar 2026 11:51:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB1F26B02A2; Wed, 18 Mar 2026 11:51:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC8456B02A3; Wed, 18 Mar 2026 11:51:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B320B6B02A0
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:51:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6061A1B88CF
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:34 +0000 (UTC)
X-FDA: 84559623708.18.564FCD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A29B040015
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kYBDbvOe;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QgtlNgL5opTpBn73U5l71gRYTR0A4QeyxntZU129xEE=;
	b=w5KVYC6vmi+TW3G8jFZM5tgdHzMfKh2jD2Wlty25tgwiDQ8+nOO8nC+wWUOhj4Uo6p7C5E
	yvczziXG/ODTwIsiZ308T+H+kgAFf4wJDXvXuTWEC3L0C/j66CSm9u4qOzd/a27M+oaCqQ
	cXdkfyod1ND1mKi1Hp6fNsVvM86GSzQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kYBDbvOe;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773849092; a=rsa-sha256;
	cv=none;
	b=EgzQgsfg21VkC7LUcD52F4YWEiOjHxZDlVRcpgb8nF8WEr1RugjSbBpgGnSp96MxErRaLP
	ZIKC5FE+e7oedVytPGNk/mcIrV2mF/4ojq7tKxdmHFvpHCpC8Eu4kYHPBXLHBHhvupFDdz
	0SWaYhvQtcvhFzYs98l+q6Cok1yAg/8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B436D405F4;
	Wed, 18 Mar 2026 15:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68B3C19421;
	Wed, 18 Mar 2026 15:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773849091;
	bh=cshoMqhmsXn21+m564V6gRodJOxo+/21XTwmvJpWcIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYBDbvOefVH8dQP36IUT/9DNjXp+XC6btzKmAwBySknpL8860bXEYhr8djvgUeRiC
	 OPGw3XL+CBA1HOuGfH0Ost7lZwcRkY3fc/7raUu9+cJiqmuBSttO5eeme4v0s1o4Iy
	 HpDkhdHVuquXBSTdYlKqs2yKZhmFQ0StiUOzhekFu2ujNvbpMUTCUnLOZZwLNmJxH8
	 +aULPNpo0wcd5tdoj1ix0e8YLB+EIkW7+n08p7MUPngRSqjYRAMJsm8/RIejPDgvYt
	 lWbeUmVCNrnFxngZwMnFCypGI8SxOxvAb/NItOlBMURYI6peljYWq83Q9KU3WSGEFv
	 mtgUvNx/5gkcA==
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
Subject: [PATCH v3 18/23] mm: update vma_supports_mlock() to use new VMA flags
Date: Wed, 18 Mar 2026 15:50:29 +0000
Message-ID: <8bd076169508ea4640f66f91c4b84b433a3476f1.1773846935.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773846935.git.ljs@kernel.org>
References: <cover.1773846935.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A29B040015
X-Stat-Signature: chb6e5ancy5d7gp68wtie1qijwm3ho41
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773849092-588765
X-HE-Meta: U2FsdGVkX18WVP9sZgUxxevDXEylJaQeDxidvRk2Q9w5hU3U5CitYdNa06M8Ja3aKgMTO8NKYC7+bDRV8tcMX0ZEF9Ae3buEyW/ip+gjDhxFX+hyzuB0D2+Tkfv4jjMMG8UY0FAvJbdSxX5NBwwyeKC9bMnDFF0TWzHncZSX88xeZFOwdO5eykLPbKc2p/fCSdZWWxtPtYtlHwIGnw9kAcJfhL2NrfgRDgoJt1IpFZsOOP34fwWFDTiTrAi6hE8i6shH3nspXbK6s+WMbjXX/05cooRC29mNbJhHpM/SGHLAP5rekyiBGLJ4M5FvZiokpeHypiPVBUafnNtfSPkWNy6cMBOS55gmy85P2aGVHdPsD1BpZHT9bRFwCz5bpWzVR0HD78daVP5rbe1gfjKYdG8GIp631WlKhZRkRkbmSOjjB7gmjwq0NIkRQYb31Q9Qr6ixMFTlc3lLHmwA2s8AdMmMSuSh6lx1fMIAH96xPlUO3iKFPXc0PlOk7UFPjoO9SKyMOTNf3hWtoGrwLFTql7+GK0hFOKuLlHtV8OkbLrPViXL53JVDctSlocH74sL2q1C6KhOBYkSKtt8XJ1UG59NrUOjXKR5yHvGom3fAW48ug3Wz3Rx4cFKppPXb2RyexrOIeoh0x2DOf6XGuB9XHu8jAKSPePEh5l2zadJsfhHG75FbnqBasxI/iFfLGz462u0H6gphL55r0He25KTC1vF2hq7nhByJ9NUP1tta9sHL0IWG5HPdeDQTghot0jl3v8z4Rn3797E9lJSam2ESGUbuT4Y9Z9GcR9k2tGux1Vs5fD3T5LiGITz61uRBA6C5ekd4tveskGWBLVjbplIr8A/+kpJRmjh7ojecHI+isNA2bKBekU9nAE4UAYhQo28Xvh1RbaKlOqkpWxo28tZJmXT5p3aAD9z2Ra4NUnHMBrrC3GO4KFvuOW2akoJagawqeS3sk6jdVh0LTb29Lfi
 yzhZz4BA
 azjGGJVXvZN1rnaPbFbTORShPWaC3bGVaHchDUX1QMmVLsEloZjjCHVC4PB1fvppgCpsEWK2Z/XF2paVJA5GkGps9GsaHdgVIigcDyGnYKXN87YLdGAbwIvue4VHILuEyIKRZDsr4YaZinLujP/SL73tKnWIrMb4CzNsO6Iu8bLziUuJIceagzFEWVDv+pC96of9W1t83ji83p23o8xJwgULY3KfBGhJJVgFAE/0y6xcPTugViX919Fxx3vLBn1xfoNkmB1iDfss90OrU177n5/BWe9KaI0LQp85m1UnWNzwjB6UghFbkbbkEwCr5vJVjPC8qaqzJBY9NjuQEF3msFmT3YZPBde5xKBIm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We now have the ability to test all of this using the new vma_flags_t
approach, so let's do so.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/internal.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index 80d8651441a7..708d240b4198 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1252,7 +1252,9 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
 
 static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & (VM_SPECIAL | VM_DROPPABLE))
+	if (vma_test_any_mask(vma, VMA_SPECIAL_FLAGS))
+		return false;
+	if (vma_test_single_mask(vma, VMA_DROPPABLE))
 		return false;
 	if (vma_is_dax(vma) || is_vm_hugetlb_page(vma))
 		return false;
-- 
2.53.0


