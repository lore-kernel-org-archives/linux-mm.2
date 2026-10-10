Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DAFDCA9EBB
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 02:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26D236B0096; Fri,  9 Oct 2026 22:58:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2445E6B0098; Fri,  9 Oct 2026 22:58:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15E8B6B0099; Fri,  9 Oct 2026 22:58:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E8C146B0096
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 22:58:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FD811206E2
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:58:55 +0000 (UTC)
X-FDA: 85305209430.02.E82A083
Received: from mta1.migadu.com (out-215.mta1.migadu.com [95.215.58.215])
	by imf25.hostedemail.com (Postfix) with ESMTP id 49507A0006
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:58:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PAj8h8hF;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.215 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791601133;
	b=HOfsT07DYLqMy1nw55eeeggnzhyFz66rndbVYvFvKTa3nsUPc37Bjd0fFTQ5YMNio15k/Q
	2p5HQ2YdGRPNZDKEtW7ukf9m4y+4LEysvRSuaBVBRgrywo4hN8ewe5Daps9SSesFgsGAhd
	7BooNgFJf6dELDMZzHs3sSqHqZ1wTqE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PAj8h8hF;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.215 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791601133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xO/DrEb5NC2MoCMBPruLijcNX5+xKYf9pDjFHrKGsTY=;
	b=EYCJzlfVxBuEo6HziPplcJFDi+ggsapRcad0nAS2mOBAtT65bAyqZAUPl8zXdfWNxoKZuK
	WGTTfwqAJU89uqTfNLS1N1t4bgwAZlYeNhsx9fPKkzUSgCZiMde8kIS5QkTJ3DqK6INsgE
	IQ2ciR0n8x0zN0uGlDmrp4f/bU64Hq4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fuKQv+8RzNOVU5ZBFPLwPT4hB6cWDIUsCSCLi5x0JgQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791601131; v=1; x=1792205931;
 b=PAj8h8hFf53pYA8bcbFfyagGuVs4DqfbJuXHEUnfv59QUS5S5psIkTHUuenHnzKs8/hsCMFW
 Y9qXKdb7ZS40BBEWtKNeHuAFhCPDS3wRLvIjGCOj+uzX/blKplHI+EZupUQhTBSUV88U9ZaJ57e
 hSGchvbD2wPg5sMocvPwtlqM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 04bc35dd178ace7f;
	Sat, 10 Oct 2026 02:58:51 +0000
X-Mizu-Trace-ID: 04bc35dd178ace7f
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 2/4] riscv/mm: fix hotplug page-table destructor handling
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <664510b2-3510-499f-aab5-ceddfcc82581@kernel.org>
Date: Sat, 10 Oct 2026 10:58:32 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 stable@vger.kernel.org,
 osalvador@suse.de,
 dave.hansen@linux.intel.com,
 luto@kernel.org,
 peterz@infradead.org,
 tglx@kernel.org,
 mingo@redhat.com,
 bp@alien8.de,
 x86@kernel.org,
 hpa@zytor.com,
 catalin.marinas@arm.com,
 will@kernel.org,
 mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org,
 pjw@kernel.org,
 palmer@dabbelt.com,
 aou@eecs.berkeley.edu,
 alex@ghiti.fr,
 linux-riscv@lists.infradead.org,
 agordeev@linux.ibm.com,
 kevin.brodsky@arm.com,
 bjorn@rivosinc.com,
 apopple@nvidia.com,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F7FC1A28-A34E-4FE3-A6E8-92D842FFA0A8@linux.dev>
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
 <20261008073021.2512665-3-songmuchun@bytedance.com>
 <664510b2-3510-499f-aab5-ceddfcc82581@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Stat-Signature: hs4kurhfuwuyt7znta11zado914yjzpg
X-Rspamd-Queue-Id: 49507A0006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791601133-221785
X-HE-Meta: U2FsdGVkX19wjYsK+8VsIOKntVEGxjIKnyQuj71H4KQkvCNK50iYtTVtGZwoI3DWDOAZjxsaK6L2ERX0QOLSgH6Qi/Uq8AnZYslebNsV1KDlWfy5bwGQTGjwM2nonhfqe1tmHHItXz5WHLVy2/mskF2Az1ameDKWfNLwC9FrOtTxPOHQPGuIiGdPujvSLT1NCvzpjcXDwJawpCZAq/A2eBBW+FWDmeTAxW9ptlAc34geX3MXHCvjuI+AmoUSTvdZXAU16sSr/Ftp6CIcYHWlSH+irChhcyIHuYBGsuQztOhQkSvxXaLuDXw3d84TEs7fR7rrxplJjqz4iPKRzSw8kTm8iBtoh2WKqkhc4cKaRUjGXY27ys77vmCysVId8EhyrSfsCVEKqg1ROuRcJru0pQvvVNESaz9DsJZW+PUfRh3x6Txbx8ZSodcV0ajbYhskNS0w6dr41nNwLg+l0zeNfxe2nazVJJDDAzCTdym6o/LyBc1gZOJ0ZiGxCIrYrxS9sFo8XUNLAFDjQrFdtQAoscbEHyASR9vZO5PJscydmVZAXcEx8RiOmLqvyx+N6ULQwrDPz8QrEVn+mxXtjSNxT9L/mBdSVswJIgMfXby+441DABfrFoKo+QXF6/fxnhA5P/hTOmm7TvIAHQg+QZfBFjgGdAsw8rFfwJlq8ZmOFw3SoN25Y8Am9Lw7uT4IhfVVq6S/rEYeEfQ+j/Xf4r7HzzFeaFpDNzjTKglMVXlkZic/OjxMH//gV0pgTo8eR3tbVs6UnPXtc+VasZbomi8DQrsrL1hjkMOKOUPKsWQmu/YKnawygWcuQsB95DrBg8mb6DncdWamQ5edRUgTaqW5TxjPB00/JRPqRG7tVtBsSMAY/1By6+152SpsnBxsjOHl+rtKvFMuAWkggCIKDGblMC6eiYrJcoDBMet08qJaMrDPvKXFf9bnYOcKyuHZSxBBMeamtM3Rmd220zWBMTb
 VdX0Vymb
 7ujjQEnCslRJYnMWPHB7O+uDprRmHda148VtCZ97NT5Ol96lCzeS/xTGlswaJwJQJ7xFqKC1qdPgV4UTmJPUaj1LU/n4YPhIHjnBdf80C2faqHocKrhPGbC7CGeQQMmE8J7M7HXeN3WlF89C6OWDAvVgcF6JvZ0UzXZyluiDyGNNo7/+304ZT5dlMK87geywKkhn50npc/mc8Ez7xepbxsFYt17wyhscmfFFW8Oti2tfPy4DJGYGZ2ls4KxWmAylcmOeCEZ1qmEAM7ANx+MvO3QwGOT6FUsJZpd0CCCMP6plK6ErUEa0ICax7Gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 10, 2026, at 04:37, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 10/8/26 09:30, Muchun Song wrote:
>> RISC-V uses the same memory-hotplug teardown code for the linear map =
and
>> vmemmap, although their page-table pages are not always allocated in =
the
>> same way. Late linear-map allocations run page-table constructors, =
while
>> vmemmap and early allocations may provide constructor-free pages.
>>=20
>> The PTE path unconditionally runs the destructor, which is wrong for
>> constructor-free vmemmap tables. The PMD path avoids that problem by
>> using is_vmemmap as a proxy for constructor state, but that =
assumption
>> will no longer hold once runtime vmemmap allocations use the normal
>> pgalloc helpers.
>>=20
>> Page-table constructors record their state in PG_table. Centralize
>> page-table freeing and use PageTable() to decide whether the =
destructor
>> is required. Keep reserved and constructor-free pages on their =
existing
>> freeing paths.
>>=20
>> Fixes: c75a74f4ba19 ("riscv: mm: Add memory hotplugging support")
>> Cc: stable@vger.kernel.org
>> Assisted-by: LLM
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> arch/riscv/mm/init.c | 29 ++++++++++++++---------------
>> 1 file changed, 14 insertions(+), 15 deletions(-)
>>=20
>> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
>> index 857f9a55039c..429a0b015ec1 100644
>> --- a/arch/riscv/mm/init.c
>> +++ b/arch/riscv/mm/init.c
>> @@ -1486,10 +1486,19 @@ struct execmem_info __init =
*execmem_arch_setup(void)
>> #endif /* CONFIG_EXECMEM */
>>=20
>> #ifdef CONFIG_MEMORY_HOTPLUG
>> +static void __meminit free_pagetable(struct page *page)
>> +{
>> + 	if (PageReserved(page))
>> + 		free_reserved_page(page);
>> + 	else if (PageTable(page))
>> + 		pagetable_dtor_free(page_ptdesc(page));
>> + 	else
>> + 		pagetable_free(page_ptdesc(page));
>=20
> Similar thought, can't we detect that in pagetable_free() somehow and =
avoid
> requiring callers to handle that?

I think we can, then pagetable_dtor_free() can be removed because =
pagetable_free
can handle the case of pagetable_dtor_free.

Thanks,
Muchun

>=20
> --=20
> Cheers,
>=20
> David



