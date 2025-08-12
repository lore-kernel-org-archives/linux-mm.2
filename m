Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD6BDC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50C0F8E0135; Tue, 12 Aug 2025 09:28:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E33F8E00E5; Tue, 12 Aug 2025 09:28:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D21C8E0135; Tue, 12 Aug 2025 09:28:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B28D8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:28:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D14B911665D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:28:51 +0000 (UTC)
X-FDA: 83768185662.10.CD5EE0E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf07.hostedemail.com (Postfix) with ESMTP id BCA8E4000B
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:28:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dohaW+no;
	spf=pass (imf07.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iHJ6iFS8ysRcPJg5oDGHM3GTKm2yblW43OcQ59Osn08=;
	b=MH/HL/GXLnrw45IJp4OJX8lGpFY7MrrA3XYaVYexLAvqq2s+/ctDL9XI3y2Rjdp+xhfhxp
	t/q6FdALOcJQAMyeRHyhvHCAETl/NPqZO0DckKL99gAllqLQH7YfyW6zbtx5DZmN9PLEVU
	BN+EUyZ0p4PDGIqRGGg6QvpK9tqYTiA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dohaW+no;
	spf=pass (imf07.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005329; a=rsa-sha256;
	cv=none;
	b=7jDPouMjslhNdi9wBYgKYuZ46e7sTLuh3/+T+efHOSYykQziuftgD+ZWy6RoX+KF7becK4
	kxCuE5lGOOD4z+gtvdxmf7Tr5Uvgbce5WEQ4+1FEOT8q729DXS08NJ3xTD8Rgtd3IMxjcw
	GaUP3cuweB++yy4LywRigiPnsrRAwmA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755005330; x=1786541330;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LqACkkb9/6GBECPhMHTz7bJjgo3j4ob5b0Xf9fj/ZIk=;
  b=dohaW+noLHnLLCJiFw/rddU1pJROWA3EUzafWIi5bXn0fVvNCnlB1LPo
   /NM8jkXKGuL01hePazEnxfkfmX8P0Yy0EmUXMblXftC9omg3sjniNJyY9
   d7S9Usqh1RP+UNHVQVtsI647Wk8pkILiC3EPCA63U//or8yI4f8oLjIzv
   MPW0GhYOgpjP51wzESCuOmNaJRK9Thjfeov8ONrHFSTnkJw/ttv/QXHFQ
   F4b1RHPgsqEiZOjUC1kyMIapF0XQ7wLWlyixOd2MzGeqBCtSNUlz+3LhH
   Wj5cdczdxB7TvCp655rE/2eqwpJIytXZMTOyW3nveqAb0Jdef+rQPTpBz
   Q==;
X-CSE-ConnectionGUID: nFSRaXrPQFC0la++RHN5EQ==
X-CSE-MsgGUID: PT8oKQfTQ1yIaa86C9CJsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="60903711"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="60903711"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:28:49 -0700
X-CSE-ConnectionGUID: 91sElzL6QCmJr0sQT27i3w==
X-CSE-MsgGUID: 58vZSmAIQMuehLmPiYiDkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165831526"
Received: from vpanait-mobl.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:28:25 -0700
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: nathan@kernel.org,
	arnd@arndb.de,
	broonie@kernel.org,
	Liam.Howlett@oracle.com,
	urezki@gmail.com,
	will@kernel.org,
	kaleshsingh@google.com,
	rppt@kernel.org,
	leitao@debian.org,
	coxu@redhat.com,
	surenb@google.com,
	akpm@linux-foundation.org,
	luto@kernel.org,
	jpoimboe@kernel.org,
	changyuanl@google.com,
	hpa@zytor.com,
	dvyukov@google.com,
	kas@kernel.org,
	corbet@lwn.net,
	vincenzo.frascino@arm.com,
	smostafa@google.com,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	andreyknvl@gmail.com,
	alexander.shishkin@linux.intel.com,
	thiago.bauermann@linaro.org,
	catalin.marinas@arm.com,
	ryabinin.a.a@gmail.com,
	jan.kiszka@siemens.com,
	jbohac@suse.cz,
	dan.j.williams@intel.com,
	joel.granados@kernel.org,
	baohua@kernel.org,
	kevin.brodsky@arm.com,
	nicolas.schier@linux.dev,
	pcc@google.com,
	andriy.shevchenko@linux.intel.com,
	wei.liu@kernel.org,
	bp@alien8.de,
	ada.coupriediaz@arm.com,
	xin@zytor.com,
	pankaj.gupta@amd.com,
	vbabka@suse.cz,
	glider@google.com,
	jgross@suse.com,
	kees@kernel.org,
	jhubbard@nvidia.com,
	joey.gouly@arm.com,
	ardb@kernel.org,
	thuth@redhat.com,
	pasha.tatashin@soleen.com,
	kristina.martsenko@arm.com,
	bigeasy@linutronix.de,
	maciej.wieczor-retman@intel.com,
	lorenzo.stoakes@oracle.com,
	jason.andryuk@amd.com,
	david@redhat.com,
	graf@amazon.com,
	wangkefeng.wang@huawei.com,
	ziy@nvidia.com,
	mark.rutland@arm.com,
	dave.hansen@linux.intel.com,
	samuel.holland@sifive.com,
	kbingham@kernel.org,
	trintaeoitogc@gmail.com,
	scott@os.amperecomputing.com,
	justinstitt@google.com,
	kuan-ying.lee@canonical.com,
	maz@kernel.org,
	tglx@linutronix.de,
	samitolvanen@google.com,
	mhocko@suse.com,
	nunodasneves@linux.microsoft.com,
	brgerst@gmail.com,
	willy@infradead.org,
	ubizjak@gmail.com,
	peterz@infradead.org,
	mingo@redhat.com,
	sohil.mehta@intel.com
Cc: linux-mm@kvack.org,
	linux-kbuild@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	llvm@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 10/18] x86: LAM compatible non-canonical definition
Date: Tue, 12 Aug 2025 15:23:46 +0200
Message-ID: <5dee53bb1044787199e143f7b5f6ec13204a3029.1755004923.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xafy5ia7nrhnf6qti8f6gooy4c96mizp
X-Rspam-User: 
X-Rspamd-Queue-Id: BCA8E4000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1755005329-778426
X-HE-Meta: U2FsdGVkX18gjR37sjLGaUiDBaY4pUjJ7/BTIJb+6mm+VX5sdylFBypVSsm8vjvqUFfXqQkDzwFPo0zcaEN8ZRKzuzHRXxotXe9GC3yIPbP4Bo+XWQhS96SW4T1zbZR1BO4h/o1LRDZO1RczqJaXAfy/gbzb2oe3cTV2NOX7f5/PgFqdPIgqefUyFJ1Xra6eSG3BgL19998EelEP34KX+f4cZyKv84e7xLGEUmsJ6nNILSzeR2i+Y13UTuSaLxknrt3VRiixhnIyCM3lUrWGtwCPZANyGilq61NnXYXK3EuCXkkDVYxattXjVhG4gThsadKj/hW0OtEAFkkHtbIlztsahgW8lXFTNJZdSCJN0FA/t6b2YJN6EI6YNeY29Fpfm/kAcfCh/w/DNhQjN4Aaye4VnQ2XB2A0ZwLx39UsEZWGjf4IOa1H24t+M78rDQzLOfmEO63SmQvAuNRJruxCPSC4NhPXbExeYax/cDwuFoIDnAC0GW4ZWmO0qsFpO7VQ0YbTBdKU7bJq1UbCDvMANl8r/QiWnHcHgizRg/JVlm8iWpwoTyocgg8nmvTTEhSlP2QKG4OYe5PYtuZAsDg49s1zeNBy6lHP38SpdutOJIUNtGMswpAJdHEr5jH96E/e60h1SoCcBTzXaRqW1MNA5BsYvBQbB2QyLP+IHgO6OdETfvvHdaxto5a6eX+PrwcpA0unD2Zte2HYfgkEEW2Cod1dFS8a7zSH4vjyw7U7KZobUvp03ggXpcs9n5AX7Li5BE6PfnHJE7PFId7KyXHZRjwaYjHjUbPF58Yg8O90/ztX7SZxqj9vQpVJk+Jzm4A+v1lRgN1zM49oKsKzleo49ZWa7OwJ9as4urePN8q9OWdz4CZYC43Kp/6Q7VI4n1Ve2PESQUAgDrnunENCRuUyH7AUJoatgcXWLitfOStjQTe/yxviFDTn6nGiQ5u2c5mqI/5btbVq3bzF6aN4Ajg
 9KF3bB5G
 v33jtYYMnKX2O4UtZnHca9a1rkQ4eV5BY5vvWh9zMAZFn7ppy5nOibpJU6+xKrN9NxM4dm6MJCoTmnKm0cvDjp6lnG4jbmUGsM+SpZPXSb24xskzOWbKfZZVj9OjYATvE7JoJY5rhBCdpOJ3XBZ9hsm+8cA2xhbYoas5RGYmmmZuIJSsNE9den6OyStx+DVZvM310l+NvxT+YTGRmxL4FcprJn6Iaw8APGWuiOoFC3uUIrKxoP2bBCFjCUrKyaaF0UABq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For an address to be canonical it has to have its top bits equal to each
other. The number of bits depends on the paging level and whether
they're supposed to be ones or zeroes depends on whether the address
points to kernel or user space.

With Linear Address Masking (LAM) enabled, the definition of linear
address canonicality is modified. Not all of the previously required
bits need to be equal, only the first and last from the previously equal
bitmask. So for example a 5-level paging kernel address needs to have
bits [63] and [56] set.

Add separate __canonical_address() implementation for
CONFIG_KASAN_SW_TAGS since it's the only thing right now that enables
LAM for kernel addresses (LAM_SUP bit in CR4).

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v4:
- Add patch to the series.

 arch/x86/include/asm/page.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 15c95e96fd15..97de2878f0b3 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -82,10 +82,20 @@ static __always_inline void *pfn_to_kaddr(unsigned long pfn)
 	return __va(pfn << PAGE_SHIFT);
 }
 
+/*
+ * CONFIG_KASAN_SW_TAGS requires LAM which changes the canonicality checks.
+ */
+#ifdef CONFIG_KASAN_SW_TAGS
+static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
+{
+	return (vaddr | BIT_ULL(63) | BIT_ULL(vaddr_bits - 1));
+}
+#else
 static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
 {
 	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
 }
+#endif
 
 static __always_inline u64 __is_canonical_address(u64 vaddr, u8 vaddr_bits)
 {
-- 
2.50.1


