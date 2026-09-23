Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBC92C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 20:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C788A6B0088; Wed, 23 Sep 2026 16:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C02096B008A; Wed, 23 Sep 2026 16:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA37B6B008C; Wed, 23 Sep 2026 16:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FE4C6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:59:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 075BA80137
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:59:33 +0000 (UTC)
X-FDA: 85246243026.06.1C81C51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 697C5120006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:59:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QqomW+yl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790197171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=IEdNn3aUwe4HImBS9dDjkJ7weHk8oU+emztUHcnANtw=;
	b=acrWMBf0+Eclb7uKvBTmi1xgz5ZXMao6AUbonW8JVytmrHaDakJi3K1SkD0W1l8EaEGQmR
	soaIaI1Q3swRH6l1jA7BjChVnFSG68T+1sydHVOMZFrm0Vz7fhnE1YZCiDoWBmdmqg9tEM
	oVwRFyZNOsilwmIlKrfMyqg1mpmkImA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QqomW+yl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790197171;
	b=2nPB7TiobPmZqYvesHTCLC0nNHofTh47Qn9Bf/68on/kM9Ta/9CUKiZ2lADppasUMogccU
	plE/ZYTycwkZw64SfmSBdP4M5NEh1sUQ6Sv/Z4RlAdJ9E3tHTuMXPIug8EJpnAu1UZK4Fr
	//6c1TuBxsVVwTjlLpZ6MQI9kq2KIM0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B664D40A7B;
	Wed, 23 Sep 2026 20:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602181F000FF;
	Wed, 23 Sep 2026 20:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790197169;
	bh=IEdNn3aUwe4HImBS9dDjkJ7weHk8oU+emztUHcnANtw=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=QqomW+ylpw/PDwHN9aiavnvl81CPHF9/3wUqB+c4utej/ylTCBDXi9PwjpqywO48f
	 qpoH7O7V2ClBBAc6veRhtMn+YFtMQU57vfRRpftyeQqjMJfAsiI9koqG0HNVwhCxgx
	 R2GvCdoiPC4W9beZtTMPNobd5zj6RbzdrEwxEVKM1eZUatzQEvrfrNBVdeiQPs/LpV
	 DwdHrQgMIQpCmpB/94BNzCIP6mSvzojtmhqdzFOsMOPHldJz4VxIcOTMjPZNGq7I+K
	 PLTTmlIUxjLF+suBD4fBrd4SJ3YFZXArduF8R+tUZnRjDKVw2i5gzgIa3K7+IjzRot
	 egDJ2t3wrj7MQ==
Date: Wed, 23 Sep 2026 15:59:28 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jini Susan George <jinisusan.george@amd.com>,
	Kees Cook <kees@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Kim Phillips <kim.phillips@amd.com>, Joerg Roedel <jroedel@suse.de>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Liam Merwick <liam.merwick@oracle.com>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Xiaotian Feng <dfeng@redhat.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Andi Kleen <ak@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>,
	Tony Luck <tony.luck@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Carlos =?utf-8?B?TMOzcGV6?= <clopez@suse.de>,
	Jonathan Cameron <jic23@kernel.org>,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
	Petr Tesarik <ptesarik@suse.com>,
	David Howells <dhowells@redhat.com>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Ilias Stamatis <ilstam@amazon.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Toshi Kani <toshi.kani@hp.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Vinod Koul <vkoul@kernel.org>,
	Jiang Liu <jiang.liu@linux.intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Palmer Dabbelt <palmerdabbelt@google.com>,
	linux-coco@lists.linux.dev, xen-devel@lists.xenproject.org,
	iommu@lists.linux.dev, linux-mm@kvack.org, aik@ozlabs.ru,
	Santosh Shukla <santosh.shukla@amd.com>,
	"Pratik R . Sampat" <prsampat@amd.com>,
	Scott Soule Cheloha <scott.cheloha@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [RFC PATCH kernel 02/17] pci/tsm: Fix stale comment about TDI
 report range start
Message-ID: <20260923205928.GA1942391@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916115159.1938195-3-aik@amd.com>
X-Stat-Signature: 1kfj5mm3t5r3oy8h9e9aa3grofhfpyc1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 697C5120006
X-HE-Tag: 1790197171-152143
X-HE-Meta: U2FsdGVkX189v1k1SC2LCybdXf4qlkYlbRq0DzJL5oU0559OKperXnrJFnfWSk+g3+f2cepWWswxpiHKhz2IFId/NqarFVYr/VkxZR44GSWiXXpvLojc3hzhlndnoe9N3UNmWcxey0WwT6ivH8i4ke1hzmWJalkFw1kRBcqSuB2ImzcM5ELo6F6Hi+lCnyqKZYosAJK27GvIydMVy4guwI21OsAb8X0PsjGOAvfGFQnb7wOX6hqE+OQJ5Jgb0FYmj4DqivmjnxfIIYD5gDabmt/65oGt3ZpZONvwgzx7M0nt9KNyF/ZimiAAmbmTVdvQ1DGftgUM5VH2HOd4pGB21oZ2p25WDMt73toP1bSnSbFm56hRSuc63u1SLe+2XO/I3Erosy9sua0Xvo/+kAhwmgyYkvnjoHiASmqX9IRmsuuQyBXMnMG8zdL5LuI9X3BRfhTEOJr3otDnPDbw3TV+s8g5e5wKu4qVHEalMpBj7tzJr/ECz15KloQFG8kSlJgqmkCWrndBY/XuzFYZ+Mj8mzRr+S9g7fXsWv9jsI/XPc7KEDKiTgOzFErjL3vSM+l1Iu7VA05wStqx4GZXedXz1N1wSGnzs25+2m8w79MpRmWNxrJfsK6oZbkwTKCROZUFSd5pGD56+SK3Z8WChP5hdh6b51+5wyZMqVLH1dVUSvhGlKfliBWSLsb2cSPTLG3NGSPaAViEsEl6uyrAnC57RPsLIcXs3QHWutLJMMuZDzbiSa3FJecYWsgJlyF/hgJ341ZSbRpO3JZgKcj3dLEDWH7KftD92qucCtPkm7ytiN+l/v2Nbv8h0jF1fT375BbFIr8Tnau4GQOttgxdtZQkqmT/GOMS9FDhmFTsZer4exla+IzxzWsMEiFoibDxQ7/wVotxM3Y0I0RG7d749W/fxVWLVZ/w4LThugZljtzHI+vz2sDo2FB2BJS2rjktlbKmluhPNvsjsuZEnOaFZrQ
 Q6wsRhrk
 t4f7A2G5BgjP59TnTSyalm0j+gfcHBucF7URrBop8GMc0PNN83eX1MbPrhGwhLVIC/G+TZwB8HOTOKNdy4poghrWKztDramO78ArMe1AkLiiJZHg0YZm9Nf1xE/2rcQcDrs2B7aSvuvYHysTS4XfvOa2RvGYODdDleSXyanJhQpfqRLRduLegzmB6LI9r8fvgwbYUlRtbJHSkTOXnUrYp52DzRALE/HVyLZLV9U9Mt88c+fqaKBrvN5oc3AN8xKq3fnMr7aJmpORkhesmsJ426gMI8b9Nbe1k4wNAfdEQqvG67Y2/YfGYRVWAYbnvvTGWxuXx2ZuhceEbgIIPSRqpIXZj5hPdP/wPZ/MY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 09:51:42PM +1000, Alexey Kardashevskiy wrote:
> The PCIe spec r6 and later defines the MMIO range start in 4K units which
> was not the intention. The upcoming change makes it a byte address.
> The structure is already fixed to match the new definition but the comment
> is stale, fix it.

Please include specific reference to current spec, e.g.,
"PCIe r7.0, sec x".

I'm not sure who's intention is referred to here.

Please make the subject line match others in drivers/pci in style,
including capitalization.  Use "git log --oneline drivers/pci" to see.

> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  drivers/pci/tsm/core.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/pci/tsm/core.c b/drivers/pci/tsm/core.c
> index 9ac216ad896d..2a18be5be56e 100644
> --- a/drivers/pci/tsm/core.c
> +++ b/drivers/pci/tsm/core.c
> @@ -623,7 +623,6 @@ EXPORT_SYMBOL_GPL(pci_tsm_mmio_teardown);
>  #define PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_UPDATABLE BIT(3)
>  #define PCI_TSM_DEVIF_REPORT_MMIO_ATTR_RANGE_ID GENMASK(31, 16)
>  
> -/* An interface report 'pfn' is 4K in size */
>  struct pci_tsm_devif_mmio {
>  	__le64 phys;
>  	__le32 nr_pfns;
> -- 
> 2.55.0
> 

