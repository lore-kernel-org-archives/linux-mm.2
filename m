Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F8260A2617
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=sGQxrLj2
Received: by kanga.kvack.org (Postfix)
	id 549446B05B8; Mon,  2 Nov 2026 06:21:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA7A6B05B9; Mon,  2 Nov 2026 06:21:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8E16B05BA; Mon,  2 Nov 2026 06:21:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1D16B05B8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:21:52 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5DBB140C22
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:21:51 +0000 (UTC)
X-FDA: 85389939222.13.828553B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9EC8B40003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:21:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sGQxrLj2;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iPgeco6QWHwjQByiNB9RkhOOleyP2xs/e2xCzbuUZiE=;
	b=avd2mW/dZuPNMnFeMcfh8Iq8FUaz/drQdBZu9cRdVnV1P9VvjJKQmvsq1D/KxuMLM/HX+P
	JHkalOV4ctS3bJXbXBnZkmDf2DYU4sve7Zabq+kJwRoQuYPIH8uAawwnLbBcxjcWg8+W7Y
	85eBUabfiBOMZ7f4gyuYIkxqqxEnTpk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618509;
	b=GOKeLVLs3ZzwykM7xw3hv6HHQHwF5oc93BIVT83GRTCNm7zaTu4KyahNBM4xnPI746LB5l
	5l4l/UovkdeHiEfaSqi9Ni/DX1dAcnXdVqgjemyBkP6Qz2JDj6U9ELxqYWJouBCdXf4uWE
	S3Mg9SY8OawzMRRF7VWFzWUjpP4xlT8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sGQxrLj2;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98BB5293B;
	Mon,  2 Nov 2026 03:21:45 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ABBBC3F632;
	Mon,  2 Nov 2026 03:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618508; bh=MWIk55sq3Xl5IhFPSCZgQqnLya5ldzX0H6ZlzYM7l/s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=sGQxrLj2PAVQM5fHkHevqVIfVin1ll/3g3ae4t/g8HEOkurxB70lXF0DZTL/IljQ5
	 rHKZXsGBRrFJanBWMs+pRElUxUB2BOmIRgyPg/tZXyH7V1J+xZrJnVL8vDsgkjLlnk
	 oes83MtSFez0CJt//3pZ8TBKJnbeTFU4waApKUA8=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:21:15 +0000
Subject: [PATCH RESEND v2 02/21] ARM: mm: make 2-level pgd_t a scalar
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-dummy_ptxp3-v2-2-78840b2ec73c@arm.com>
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
 linux-openrisc@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2019; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=4Z0osGAP3S0civxPu6dKKFX1qsd70Ol0fauRungSauY=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HIvrNf0zi5GZGBTyShCkosyjcm/ve62Hffev
 ytAlT3j/TaJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyLwAKCRBt1cPRWsUx
 M12BC/9v/yOQz+XWwbdtR0EhCi2ksiI4sjutQ/bwS5HN1By936VSeN3wcUH0K1fKV0O4ZIiW+s2
 SfJf6SpaQEfPzplAyvkiXQnqW09aHWhOdT1UwkkxMNSsHXdfqi1M4FHRSWPCkb6K0FI12tyXCNB
 h4nuW6sYscec7ovrm5iXzQbZ18FdIgFk4raQqVHNTwmq+NydXKk3z4z1PKr6pQr9LF/IibhywF4
 XjnF1eu4DGG5cokFCAkzEPmLAy7JprIb56giiRaum8uQRFE4AQ+Cp1WSXeJ2dYh0gtBvPfSBIC/
 mxl4TgYzuAab+dAvT/qiL8ektFPYyYhHDUvtnnvaYZd7YDgQ3WVoVaWuqwj0VkGu2Zkeaqp0uR9
 2vHpxiZK4KVn3Mm9K7SZrbcjdZUCchSWx3i9Tlu4I8WUFQY0nxAPvoTQsduekKtvwMxY20rvnhs
 Tv4dNY9GxHesD3XthpSYqMK/OdNippbv5S3PTdRLmqElgGJKdAMoOXuZeIn1q0haCDfG0=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9EC8B40003
X-Stat-Signature: w1ut6m7ecjm1cewibx1xao3stukmtmff
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793618509-741747
X-HE-Meta: U2FsdGVkX18dWbzVZmA9dVfpgaox/xteVhKekV/WD5sFptqfqRIopKBLCuBxZedCT7d9Pl4miOa1Rd5AbpjSiqwu0EyJR5d5xl3Do9oOV4o1CLHQeUFLM9Uan58zyLycYnUeq7HI1saGVKq0XeAvgax6wsKzBmoWzHN+ZVoMUGRzIqjtIzFkdo8lWN5BxCZV8Ke3ET/QpDLaGbzdQuCMJkRKwo5jdC+TpoA2ALRwNm877DM5QYQz8Y+CK0NoNw2rzNMkmO/tHLAYWRezZUE6onEWfU77O3owFqR7zazHRjZZlKNMta1RTCwazhbMdck4wIvtPZNgT1bji4JhPf/YaC/DoqmVs5YoBr7WuAu8BiA97F42K2OfgxMH3j90k2Ib79Ugs7LAL+uDpSk/A+KSJPKdftomaENTDOHrXYt0g4oVYmi58awJEfUoL0vhLS/XhQ68OGqN2eENdGl8IixIuh1DenOsMfxyXj1h3GMCQZvF4Yd5/tXuRq9cj7YQbedc5fyjy2pYevyjX2DSpCe0VjiyHFpUWeD5dKhX2lgR7hmTOwgn91mxggeGRD6gwuIQU/gP5vJe6SxSheBsNo2pqz0DjkHsAQkTyKgU/YcSyN1ip+qdsa0oz/xCZuPF3os8MVYiDXei9fUOUbP2Cha7Fh168pa4jUQ25gTnvT7Ae8o+yZ6LQjxkUowyVdhAVicMOql/0OdC3omSngzlPrVOAZWXjzWwAOyLAThTVsVOew8TGbW+sTPW2Rhf5b0M1qnq4xbJvMOgNGtiBXV/atTTBpMA5ktuoGurSV5LLmv6oQpY83DlizmiSxqv5OD1OgkSoGv50cQi+3CufuMFFYrNnxMe1qMFOsnTbH5kEb4ICvDbXLhza9JjC/gw6/cLyYbS9jsMEVYtKZyH3LcpXNgJe4ijo/YdJoIyh5ZaQ02uyC7PMbJf4c1Uf1eB2qplLG1MpcDTnvb2GrdZcz4EWAH
 sQNetxYt
 J4sTKs9iPmBdBpL4Md/tfcj7HyFLx8nvT9A/1jMA26SIWqgCww5ehTda/6DnH6uryjcGwpSFgtKc6AFUKBusYSdTUDPMnLrGz+p3oTMfrDqrF7h0lxrkZM4MSj4Q+vsLMXhTBsMx18k4ww7JLqxj+swdyBysI/UjIqFvmwp4751dWnE/+qpjG7LZi7kQOGJfhj5OalVChNpfula+oElXP29+pKsH/H+V5Fv8nI4QxQCHGXREa/s8tMjzLkKwf3ZT2gLI98tuAa3zW80k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "David Hildenbrand (Arm)" <david@kernel.org>

As pgd_t is returned from a function like pgdp_get(), pgd_t shouldn't
be an array.

So, just use an u64, and extract the right 32bit value in pgd_val().

Leave the STRICT_MM_TYPECHECKS case alone for now.

As an alternative, the STRICT_MM_TYPECHECKS approach could be used here
as well, but using an u64 looks conceptually cleaner, even though
pgd_val() gets a bit more involved.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/arm/include/asm/pgtable-2level-types.h | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-2level-types.h b/arch/arm/include/asm/pgtable-2level-types.h
index 650e793f41429..805044ea315b7 100644
--- a/arch/arm/include/asm/pgtable-2level-types.h
+++ b/arch/arm/include/asm/pgtable-2level-types.h
@@ -25,7 +25,7 @@ typedef struct { pteval_t pgprot; } pgprot_t;
 
 #define pte_val(x)      ((x).pte)
 #define pmd_val(x)      ((x).pmd)
-#define pgd_val(x)	((x).pgd[0])
+#define pgd_val(x)      ((x).pgd[0])
 #define pgprot_val(x)   ((x).pgprot)
 
 #define __pte(x)        ((pte_t) { (x) } )
@@ -36,14 +36,28 @@ typedef struct { pteval_t pgprot; } pgprot_t;
 /*
  * .. while these make it easier on the compiler
  */
+typedef u64 pgdval_t;
+
 typedef pteval_t pte_t;
 typedef pmdval_t pmd_t;
-typedef pmdval_t pgd_t[2];
+typedef pgdval_t pgd_t;
 typedef pteval_t pgprot_t;
 
 #define pte_val(x)      (x)
 #define pmd_val(x)      (x)
-#define pgd_val(x)	((x)[0])
+
+static inline pmdval_t pgd_val(pgd_t pgd)
+{
+	/*
+	 * A PGD entry actually corresponds to two PMD entries in the PMD table.
+	 * Both PMD entries point to PTE tables residing in the same physical page,
+	 * but at different offsets. See include/asm/pgtable-2level.h for details.
+	 *
+	 * Historically, pgd_val() has returned the lower of the two PMD entries.
+	 */
+	return (*(pmdval_t (*)[2])&pgd)[0];
+}
+
 #define pgprot_val(x)   (x)
 
 #define __pte(x)        (x)

-- 
2.43.0


