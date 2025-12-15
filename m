Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 982C5D5B17D
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:03:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E64516B0008; Mon, 15 Dec 2025 10:03:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14606B000A; Mon, 15 Dec 2025 10:03:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDCBA6B000C; Mon, 15 Dec 2025 10:03:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B9A3F6B0008
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:03:51 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5BF3313A4C8
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:03:51 +0000 (UTC)
X-FDA: 84222025062.23.3B75CEF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id C01D8140020
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:03:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765811029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SXEJuzPtTZCpVI2VeTJf0oSQLFrAumMQIHEoQAJpQxQ=;
	b=Zawb0Tbjb4bOrX51fx7tZNEBNQIHUzFO+k6Ms0lm2iype6q9EkquR2XzfFyICTsPJm3+HQ
	Udi5dfxXvbjaD+s8ssnp0TbemD10yJyMeZi9BIe3VbPItcxoptFTWrcKT7ifPYF2FLw42+
	Q68gXoG8PZNy6K+wMoE+XdhYyKcj2+A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765811029; a=rsa-sha256;
	cv=none;
	b=V+sJSz3n7sVXwhLqNApz45e6zja5LxarbNDX8n7z1ncvEDHskbu5taLS06dgFt4BEMqUh3
	QaedgYggGzGvOgReRX7Za9kk3S82X3uWeoKP303GfwRTFHYSSs8mnxkcJuWMLyf0d/Vrod
	bzZj6s22dMCa5LauibuC39ijukiO8r0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 80DEC1655;
	Mon, 15 Dec 2025 07:03:41 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F7113F73B;
	Mon, 15 Dec 2025 07:03:43 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>,
	Juergen Gross <jgross@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	x86@kernel.org
Subject: [PATCH v6 02/14] x86/xen: simplify flush_lazy_mmu()
Date: Mon, 15 Dec 2025 15:03:11 +0000
Message-ID: <20251215150323.2218608-3-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251215150323.2218608-1-kevin.brodsky@arm.com>
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8s3p1smrft9ahnq869qogqop7cd8bo1m
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C01D8140020
X-HE-Tag: 1765811029-882849
X-HE-Meta: U2FsdGVkX19A6M1BtgkIVbGRHP5uk4F08bfuu7WEYmI5TrEU7qMGGZSZqCsKzpmOEO5nm9jLXA5d8N1VjwoE4rSIU2awl9v0RNeHOvsbKID41MjMI7paE0YJDQq9UEkn3AvBpQl627txjC2B1jl6fiFc1F0mpMNhrP4s//lFOcq+1Uyq+6zw2u1aGeks4GvUntzP51FwvtpPjweDTVxb7zIPMrchsG8bsQ96wHTU797Dxy4FmWc5u3HxleyKoCMyuEqhdqL+eYSWZvmM9wQqJi+Us2UohVeI8v41i/H55bMOKgO8ZQhQwYqQHAm6+Dzo4hd5fIqaFGkFx2IiF0hDuL0yqMG8ixao/3N74SJasbaCmFjJudKKbNc3A6sYF38tbjQB6sFyM8TcUldu0atocgLeGDJzV4+Fk6ncEmfND6WqVMgsDffUOyDmkgTYkUQmMQ9istyWbRpbNOIHdbO1GWEqSVQNEETsM/dPQ2XKumq5ZeO3pCC6eeSqtDEFmyK3OITR/Lb6nNRMvAwMjbul3m5wk8BM2ONl++BvNENurdfXHTcpNYYfJT/4BxLI6Jd4idUMiSVLrmRuWXGpuFn/m5gsfyjyi5wcS7kT6sNPVBlcp6PM5fnrUlRcpzMf/shBzdP4ibD0fGiwyR21Kx+WmIsRGqa6IGdeys4FXSLAF3CeVH6dlkOEzHl0ElW147jacmPcwHa7m6Fl4On4goHafyhWBrR+9aPzpfUkbZlVdPf4vrxTJNI0Qqtru5Qf4qt0BAtyZJmRWg5uDdAPTaLa2vGe6F6zS6nEp97gxbs+jqh3P/VFqdS1Lqon1exGUpNTIn5E8Z4uraA0HSHmMzXo+f9jCUOCJuznnJUNSckkTllkQUJIdzpw0NV0jX/5c0kjz8RQbvSicYc3fA/OzdJyU0DJU56RH/geZ7rcBCPxD6KVNvCKy5ysnp5GlXjEJEdFXI03yByKjqqHGzBHh0v
 Pj49Ty+k
 70C3CZYbWPY3wlUXJ2JI7ASUXimE2IXxB5K+bZ8WaivsoYF9odoEdoxsAD2rGNa0IOl7vs1E1N7iqjWTXJczenkNvpyz54N9vOjRxEouNZHw/Ywjg05TdZLjXkoa3p5WfZUjoDax9nWgNxymC8ELP8K0PyjSVZY3c/wLvo1fZ04ILplLkgEn4gIRv8907KWNElKrD/ZxxtqkGfOuwgXlSF3L0F5eNuR7mHU/L9R+4a0H9QuoCD8TZX54yj5h3HK6Db3sFYYREt+bkRggVEmkE9/Q1Zyx3BxYAt2ks3xpKB21OoCjnZDjPjc3cNnSfnQacB5jw1itAh1KipOt3lz77bXm9L4meSclU7/h3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

arch_flush_lazy_mmu_mode() is called when outstanding batched
pgtable operations must be completed immediately. There should
however be no need to leave and re-enter lazy MMU completely. The
only part of that sequence that we really need is xen_mc_flush();
call it directly.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/x86/xen/mmu_pv.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index 2a4a8deaf612..7a35c3393df4 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -2139,10 +2139,8 @@ static void xen_flush_lazy_mmu(void)
 {
 	preempt_disable();
 
-	if (xen_get_lazy_mode() == XEN_LAZY_MMU) {
-		arch_leave_lazy_mmu_mode();
-		arch_enter_lazy_mmu_mode();
-	}
+	if (xen_get_lazy_mode() == XEN_LAZY_MMU)
+		xen_mc_flush();
 
 	preempt_enable();
 }
-- 
2.51.2


