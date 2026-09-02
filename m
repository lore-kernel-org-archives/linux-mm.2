Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E1C3C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6A86B0092; Wed,  2 Sep 2026 07:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657146B0096; Wed,  2 Sep 2026 07:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 546B66B0099; Wed,  2 Sep 2026 07:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 351486B0092
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:57:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 47320801AF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:57:01 +0000 (UTC)
X-FDA: 85168671042.29.7B4AA95
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4A23914000E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:56:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="DBs+SEJ/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DkaL0Kwa3+V/GT5Rr1mfaQ3uLIyZ9Yvq6dHMfQx6ZbA=;
	b=Jjv5uXIbfI33s9ZpeXdDHR6+57AwgH9VPHJaWaoBcsnMe0ub+C5VHqHmh2xi7HS0KfHKr5
	0pqXTpig0GCEjKZuPWtDudaWqj0g7NArp9bf9kMEsGgxmZ10Wlwm0SVIX+bE3o7mtKmOOX
	HP4YBZg0J6//VfV5t0zd2yQdeOZcL/w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="DBs+SEJ/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350219;
	b=f8FkY8BZcqNCBKos58uW0z37OEUi/IJ6RTdfMKwYFEFJeht5Z5sanAAHZiFnAJXaKW5jOD
	KBL6vF0IYW6v8ZKM+5emR8q74c2KFCT6ucJeqK8NudOG2cNNEAznzchEbBY0EhX4t78b6l
	5Cd8e9+8A4mB4yEyVW4q7BAJODg6DBQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 961661596;
	Wed,  2 Sep 2026 04:56:54 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3EC283F85F;
	Wed,  2 Sep 2026 04:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350218; bh=mi4xjJsCAhGuG1KP2jLhKq+FK/V2NIyuuhsagoZBG7g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=DBs+SEJ/tWGTTLaux+S1LwsrrYGBwQV3ATuKZgMbvei+jVh1WSY/M2QC4NxmGgA1y
	 i7m5xO5OZ/Kze26/9ZcqAvwphvv8ZcI6T4TjkMJLHNM7089rPf0Uh66u16hKJ2O/bw
	 eUVTOabXRMEhFzmJCMwjz8dAs2j1D7hwhGxnsB4s=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:05 +0100
Subject: [PATCH RFC v3 03/21] ARM: mm: remove custom pgdp_get()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-3-5d8f5b17c25c@arm.com>
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
In-Reply-To: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=792; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=Kei+qz90eZd/Rla66RuJIaqD0aMM/I6F6uU024NhR+s=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7jjEkXgd07toBiXhGHtW6l2HJSNxf8EJFQR
 MrLQ8sVkn2JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO4wAKCRBt1cPRWsUx
 M6UpDACvafb5I6qRyuKtjC3o3BB6X1x2pDkn7WzYN1XkHRJTOSQqVabpYB98QmaZehBIp+rjcY5
 8XhZPr4/VlBHOVk3oTKXafUozy78zoYZq0S0E3Lf2aAZxvVYJ2NiTRRojaaLsZjYC90Gh0q972O
 Rz/p7u4wzhU9+zIBlnLnLO0sHStfpkZzqgRmFRNN/cNQcudRxV/D0DvX3QUiHospfakh8Gzd+tw
 YagxhalJiyRHw1OpcDf+m4tYW4H3OvMHS425VPwVBRIIouFfanScIRA0+fKzG0k4IK2M2wrA02H
 KrgC0K5GAs47HdDG3A/K8w5D4465AqabgyFWC/Z45fkdQwIBIeMAYZZ0m0GQzSVgwFcP4uCsTeT
 g65+aH2rnoY/2z+l0jnY4nIE9dI1zATCV6ZhkOXlXqpUwtP1NdLmkFwU+Dzgi7M8aclQ4OMOAwx
 Hd2do+6aUtYqw9yndif4b5hrcikHznxCCtm2jeKnhCm3VafyuCD3Yr1/8LH2X6S9Li8T4=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A23914000E
X-Stat-Signature: wqx5ocp4b3ctnsx1zd3m3wp97k8e8tnm
X-Rspam-User: 
X-HE-Tag: 1788350219-203370
X-HE-Meta: U2FsdGVkX1/U6g4fDh/ThvBskno8jKUxItGBYf12ShhFwQgxO/dTLxGhTKZZgY2QQ1xHiILslGR0cmYRMKo9M2jEgyE282UJoNXJBE5E6BIlZ6lZZrttZean9+NGeabPfQXSqSoqTbaZ5SBZdxwu6z+qM0b0sGlzqIM8iL7uWpNeMnCy4NZ1V33AAsJhZz1tqY3VtyL6RMScgjopylSgbZhu60UMTfLUMke7Un+Fj+6E5wAM2RtFXUJUBJ5VbIMeTax55O2x7oD3gyQgN4EelI5tft2sPAA++4xCMCyKvAf8ch4q/NN3eBOM7c+T2YN9Vn0YdzauxfRK5NYNQlwfoWi5sVp2V2oX756Z63j8rykw7h8oShsUoRIQ0lzkNCY61ngWBauQK23ZzOFLeCeCe7lygqMlnI/xnDK3TJPZheClT0mFGdniBx1/B6oyrhkVbl4Miwm3TR57sxlV1O3HDLHeqyevQ/fYS+KZqJBLU74gXmH0KQD5yk1E1/zcNYkEtuFr2UtJf8r+aVorbWDPbcBK6xjgcDEcpybiyQdyGViUEcDuH08nAxUmm9DCuHPkCM5HpOPOqlKRNgX6cVkgGAN2jwoecpPqyhkAWdpEwPTZfg7zG+W8qlrpxwrU2+c6ruwubeoQXNcer1iHQQL94ANurR5rzwIzYSG1gpDYUqfvV7YtDq+v+eB1XfNHYfqyTbJ6e9buVFN2oFdvOr+/Ygnt1InzdRHHERU+8/Grby4vhvNwY0cZDfx/ExykgmhE0UPMpzVPN5iVUNk4OhLOIA4BwUFrh0WFUhxVc90t8hE0YWxSMrg0MXRHLhSmYGtatajbmgl+ocF+iytEpryKIKOxvoYeebjqMOQsSS/0KIXvl2Ux2gPbJPEbjRAczbsgUQz645vEYmqKj9PKoEm4OBFMqF/SPI21/B60Eh7k80GfbKiDCO8GQu+00ytMg7cR1t8fhpygXHqET+dE0JY
 iywkt4aD
 027QsuLaKq73pkLTsqGlWASQuyAJKmqHnRACFdMlBsQKXeXmYbPOca/tJ/8Q8KI6kbikR+sp0kQcSEm3bmmgnLmE6QxAfjTJJ3NvJWB8UBeHNxMY/sXFZuWHfR0Etm/OMnZMHbop3m+PdbLwnYZUgeMryO8HEQ0XAurKAnUjMHwuOU1FOSKMxkEO0NMxTULhEWNYELlPFy0uxS3/uFlEzBjRN2yQoRRrXdGDAJ8I5qbMMg6d6xd4C8fZAgm8DAz46C50F8wLWsHwQMpM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

Now that pgd_t is no longer an array and rely on the common
code pgdp_get(), which is a static inline function that returns pgd_t.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/arm/include/asm/pgtable.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 8dd17d20faa3..ff3868acea94 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -134,8 +134,6 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
-#define pgdp_get(pgpd)		READ_ONCE(*pgdp)
-
 #define pud_page(pud)		pmd_page(__pmd(pud_val(pud)))
 #define pud_write(pud)		pmd_write(__pmd(pud_val(pud)))
 

-- 
2.43.0


