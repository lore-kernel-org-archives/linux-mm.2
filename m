Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0DCA60A381F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Ctcgk8m6
Received: by kanga.kvack.org (Postfix)
	id D894F6B05C3; Mon,  2 Nov 2026 06:22:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9CE96B05C4; Mon,  2 Nov 2026 06:22:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3E176B05C5; Mon,  2 Nov 2026 06:22:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A9746B05C3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:22:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 100F7140C0F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:42 +0000 (UTC)
X-FDA: 85389941364.11.31E5352
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4972CC0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ctcgk8m6;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0uSF5qpsIfEXe0LqMz/VFLuJzJd291vneuC3VxqkSI=;
	b=XLyCdgEp76CD3fd/BbD65KjHZ69nx6LnyPAv5tDATzHGwO42P7Wk91YtPFvzHGypuX7+1H
	NaH3W1LXeTgMUpADcHjTceQG8fAGq6NyqbRNXJO3zcrsqrnHEkQTQ4LYUq93B4sN85vY/U
	kebO+1A56wRU/3HZ/IUgH8zKp4c2WPE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618560;
	b=vuPlMOy5ReVwj3eapYUn1aryWiXFdbv0SohrSsYj2/wcgsK3se+Mok6fLZIGJ2ISIdVRO4
	h57Bzpmd1rSocBzNCWuTfZqvqlDkywcc9NmbiVW/ieVuwNUJlSUVt5jkiEwLg4qprmUwry
	JNCL/k4+gvhRnrIteMAIlCqGRnUYhng=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ctcgk8m6;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D25A1691;
	Mon,  2 Nov 2026 03:22:36 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6474F3F632;
	Mon,  2 Nov 2026 03:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618559; bh=bDxr5gvFE+Bb+w20GZGn+s22BxRoQqetE+tU52d6PfY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Ctcgk8m6cdw5AgQ2Im/7eFAWIBTpDgXbtAAO8GJUIWWh/YkZBAZaw9T1WzoMpEVS2
	 9posqID6bDX94oqX9vEed1OT6H8QPauiWj5F4typRunUthD06NqbA4adWOmWErHOFp
	 ZJmVrpwHNi9xgaTlU68f4MNjQeHKzt2spQZCrMtg=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:21:23 +0000
Subject: [PATCH RESEND v2 10/21] riscv: kvm: remove stack copy address of
 pXd in pXd_offset()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-dummy_ptxp3-v2-10-78840b2ec73c@arm.com>
References: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
In-Reply-To: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
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
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2080; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=bDxr5gvFE+Bb+w20GZGn+s22BxRoQqetE+tU52d6PfY=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HIznkcwZYOsTE4W01GcU4mYfE39Lhkjeb/kl
 qYNmf69jTeJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyMwAKCRBt1cPRWsUx
 M1nPDACyTxKW0QIf1aki2ILBtcSj+P8SuxY2HQa9GTNUVsd/UcGoLZY6uA/dg7A/Yvuw0TCGbPd
 kcIgBiMNtSZrHn52D6+1EE8BRFSLynEcFOZhgBpTFFw/vtZ6INCLbtKOpOsjDg4DyfpI12y0ZfB
 6LW3z7kJtoWiIOxcg7yDeqiif4xh2+ukAxnSqDWrIA8XkmLrl0meoz8b/5o0DmW6BjtbNX138z1
 KgMPTeBvji7YOP9l4nxY0uRo11y9BlRHu9pYQE8CO0ghDHcBDVdF9JDf7OaNAFcMMlfAco1VUec
 5xAY2JevPpbxhhIvzqN/7k9SEa7bJIpRNqP/uwAp4sA0o4LQYqs94OeBxp7lPb5y1agzCGGwynH
 F3F0i1TidoUuvK9RtQr4nVouqnI2kCZ7OD+1YaNGfAelozaDSsnKalZS3jbFtWUTTPcpx6ZrZ74
 yDINCJGTkAAOUpALpC2WLfbfFmJVgwf9O+hkJStfemMtmTCYRBWPE/h7YvjwkvOWcAHD8=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4972CC0005
X-Stat-Signature: nc9c1erm8tpk5piaz6z8c1nkk37hyn9f
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793618560-428521
X-HE-Meta: U2FsdGVkX1+5htqJ22zkd6nZMYx28VWadyjB2XF+EixT6ARcTf/FaX1A/b8YYFBrq1XkVanT6W5WeLOnOnmZjjQEePQpvHR+OGIltvmOp6NTJ/o6l7L2LJzsMtWJSoVzK0gJZ7M3uQa7C2uiU4LucWLeYa3SWlQ0P4/silmzzREu5puG6MEEokSaeZT7Wq6MBO4B18BSJ+WNt3dNt3Fwv7iIFpQORaRFsLftstWCdCH0G3V0OfV9d7m851uHfVYZrjsGClwbovk8MdMAiwit6RY5SlDL+nsa/tdEOKDIJyj582N5F2qMl1Kp51polRGzDIJoZNwTM/Nipznh6AtLj0fsHYPwGlbaof+rYF8wCamyWVXTxTPRBuk1vt1KgrtdkqaUfABw8woox/jx8cBwaaQHHUFljEvEkvAQoA6Z+i76XNQdbcVixn2V1j0kmNhe2a2zLBs9rsXnkFJl4HLRsu9BHKNIyMmOnkloWWraHydGS5VjyQdEabGxbmo8FkVxzy17thHWwJ1Q64ng7tnXrx5lXpJKronCQJpvTNpLzaucFJ4n2OplFXnCKgBqG8V/NMthWVU8uNOGshTEslafNzREnu0OneynFUCTLsGDWYhKsbMn0ysECK2s/tV06Zr4VTlwB6MZAihtyGDTagVxevhLFc0B5RythJ/KA9iRaW/It5fG4uJb3d2MMKBI3Dyt9Z+wX0eWFvRuupXQmjuk51VVTdKCLRtXS2EnaIxVEgTaYjo1K3wrPg9rvhMK6/NCUWa6SMcyEtYQF8zKAyEaFHci4Xo4TjabYh2PiPBwOhwPy2bJGssqpBxe4m3QqcFs3ZSASWGhj7BF178f8AOeVe3ElrshMr/B5AjEyuw4RXfYOBTxHM0qPp78wrnAgfvqoqu0ojsEQQBQMhwxYieJ9QYpifinJGb+a+JwSMhR3nwN9R23cyJI7Dt+hQ+e51KcqfwqtQO1PD7JH/Dp4oT
 UXJjSGPw
 2fKPzRsrFiGWbhoUFt/zBIVRtJuO5eoPcT8X44qW0nXd1JZ+4EU6RByPRq7dpGZC4AK4BllsAE5dcaMWn9UKN3DPY4842iG8WS5+9VW+QLeO32gu4xHHvd8/q8/ovtn3UGD/2L0SQKMr6B7sdXnYUW3PKbtwtUgOzYb6TwBQH+Ddrk9n/XQG/8ZLddwAE36Wu1GS2zHN6qY/xB67sIIApxc6JiM/fOyQxpaSfZ1Vp3Lwb7ZWrzSSSTA8Y9BdcrqGbM2YobJ2UjkaGNuZu4P+B5Iz4lQcsgb5Sa3LTu1aDbJGRf3ou+PHpeZQ3pY4h0NbFjMqAzKOpm6VPZoM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The behaviour of pXdp_get() will change with generic compile-time folded
page tables. To prepare for that, rework get_hva_mapping_size() to avoid
use of a stack copy of a pXd and pass it as argument to pXd_offset() so that
the folded entries value is ignored.

Replace direct uses of stack-based pXd values with pXd_offset_lockless()
and there should be no functional change.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/riscv/kvm/mmu.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 371fccaf9df08..a062e8508d3f9 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -450,10 +450,10 @@ static int get_hva_mapping_size(struct kvm *kvm,
 {
 	int size = PAGE_SIZE;
 	unsigned long flags;
-	pgd_t pgd;
-	p4d_t p4d;
-	pud_t pud;
-	pmd_t pmd;
+	pgd_t *pgdp, pgd;
+	p4d_t *p4dp, p4d;
+	pud_t *pudp, pud;
+	pmd_t *pmdp, pmd;
 
 	/*
 	 * Disable IRQs to prevent concurrent tear down of host page tables,
@@ -469,15 +469,18 @@ static int get_hva_mapping_size(struct kvm *kvm,
 	 * value) and then p*d_offset() walks into the target huge page instead
 	 * of the old page table (sees the new value).
 	 */
-	pgd = pgdp_get(pgd_offset(kvm->mm, hva));
+	pgdp = pgd_offset(kvm->mm, hva);
+	pgd = pgdp_get(pgdp);
 	if (pgd_none(pgd))
 		goto out;
 
-	p4d = p4dp_get(p4d_offset(&pgd, hva));
+	p4dp = p4d_offset_lockless(pgdp, pgd, hva);
+	p4d = p4dp_get(p4dp);
 	if (p4d_none(p4d) || !p4d_present(p4d))
 		goto out;
 
-	pud = pudp_get(pud_offset(&p4d, hva));
+	pudp = pud_offset_lockless(p4dp, p4d, hva);
+	pud = pudp_get(pudp);
 	if (pud_none(pud) || !pud_present(pud))
 		goto out;
 
@@ -486,7 +489,8 @@ static int get_hva_mapping_size(struct kvm *kvm,
 		goto out;
 	}
 
-	pmd = pmdp_get(pmd_offset(&pud, hva));
+	pmdp = pmd_offset_lockless(pudp, pud, hva);
+	pmd = pmdp_get(pmdp);
 	if (pmd_none(pmd) || !pmd_present(pmd))
 		goto out;
 

-- 
2.43.0


