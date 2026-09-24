Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C99D1C98304
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 02:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C1A6B008C; Wed, 23 Sep 2026 22:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4C7A6B0092; Wed, 23 Sep 2026 22:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A14016B0093; Wed, 23 Sep 2026 22:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 779C96B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:56:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F37C71A01CE
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:56:07 +0000 (UTC)
X-FDA: 85247141574.28.E1C0EDD
Received: from mta0.migadu.com (out-126.mta0.migadu.com [91.218.175.126])
	by imf20.hostedemail.com (Postfix) with ESMTP id D57521C0002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:56:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ckaz0wTr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.126 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790218566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3rUJrOssAsIlzaIbpG4p7ewG7Kkt+KPljgikjsMoRc=;
	b=NE9U2JQ/VUbFl2ADB8e7w6xk0HerPFHTf4t6XgPvEgjjN3mPEg0dx3kV+mzmOUDjbHmmVG
	qY69aJwjOuA/w7kwlAiapYDqtn3lHBgE9OpVuWmXzYIj2zHaBGbmMzWCa5+CaNSrBvtXZW
	JyHsNuMR5tylUuMyPPXUiWwC96usQkY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ckaz0wTr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.126 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790218566;
	b=l57fcltY0UBD0KhkvWfEU22d8BP+wmBAEyMUWeWkKzTEE+0+Ujjlsj1MafSwAhxf8Y+bEc
	lg1/hP1looLxDMMlKI511IeSxftnUrP4UBPo7O3hag/geLFgUFVH3UoEYqtdWFZp7oSqFP
	Z9olCI7caH+7Z4BjqqEYe6CXD/av/Jw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=i3rUJrOssAsIlzaIbpG4p7ewG7Kkt+KPljgikjsMoRc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790218564; v=1; x=1790823364;
 b=Ckaz0wTrb9WChEDMMPZoMKsoiASMuXtYD8MXij4Z2VX4tIx/LPQbi9RurLmV+G1NQPuqZ7HX
 6BtLv7sqNe1i5pdNXYy4OvwUj0j3eDqS0R+KFbEIgrQHGJl0yU3C+8Nim9/vhFkwvGufgxCiSe+
 otzbitNzcSXs2oJ1DxiUQs6Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9cade30b803883cf;
	Thu, 24 Sep 2026 02:56:02 +0000
X-Mizu-Trace-ID: 9cade30b803883cf
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	guoren@kernel.org,
	bcain@kernel.org,
	geert@linux-m68k.org,
	dinguyen@kernel.org,
	schuster.simon@siemens-energy.com,
	jonas@southpole.se,
	stefan.kristiansson@saunalahti.fi,
	shorne@gmail.com,
	dalias@libc.org,
	glaubitz@physik.fu-berlin.de,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	linux@armlinux.org.uk,
	vgupta@kernel.org,
	monstr@monstr.eu,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	davem@davemloft.net,
	andreas@gaisler.com,
	richard.henderson@linaro.org,
	mattst88@gmail.com,
	linmag7@gmail.com,
	catalin.marinas@arm.com,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	tsbogend@alpha.franken.de,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	chleroy@kernel.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	richard@nod.at,
	anton.ivanov@cambridgegreys.com,
	johannes@sipsolutions.net,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	ysato@users.sourceforge.jp,
	shakeel.butt@linux.dev,
	corbet@lwn.net,
	rdunlap@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-snps-arc@lists.infradead.org,
	linux-arch@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	hughd@google.com,
	qi.zheng@linux.dev,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 11/12] mm: make userland page table freeing RCU-safe
Date: Thu, 24 Sep 2026 10:55:56 +0800
Message-ID: <20260924025556.18719-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-11-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-11-fe1ad1f1e303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g1nafgtzwgz3owzg74omrf1s8zjydk5x
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D57521C0002
X-HE-Tag: 1790218565-372354
X-HE-Meta: U2FsdGVkX1+ZMqMZi9RJOiZRuG9enVecalZjrj7SWWMa2xyoEp+IUMjgYpwVri+dCz/hdx77l494+SjX0In/vqE97dHinKaif+G0ytW9FSVAzaKkJPqaEfQfXmmX19WnqWtmV0xTd6HGcY0xTzre1xf63frxEY7Kt4Kdfd2wnFFYGewOI0gn0MZMMMwUplVFOtsxQ54S6lyjOoRU+xuEB2eqFJ+bzrPSUOx14sac0WMisMP52fl9cazw0Lwk18SqvDnOL3V2FTCrcyMZdM7faDHCvX9RRjB1a76sUKG/fz+SKpkxgsIYkA6qJBmbJzXCF6AQBLKyY51BwvXikuwt/em03SFOi6l5wXiqQbiKovnMp8r2vkg8gcZUxGN/F2Hg8Knn6Cn22G7BOS3eRAMzUefYdAOIULYSpPX/ipVXL21wM3mkF1aQ1U607NT5k8EqxegrjKU9LoJrVDuMkUA3OIDzOA61DWjLa1MJuYb8+EgguVmUCFcbDE7ldDuqgjGEKM/OaCeECsImdVoTlOAm8gZ/9OhPQv4px9UN6oYgpHs37JMw8onpw1O34oKi+sTCS49NCPV5C34qNMtWkFatbBbqAi5/42Ff5rB9I3j+olzjvuF/TIkJg6gFyFre7DW4aSlupVo8GtkZGlkUhxjEBVT5oE2LSVBJChUGUAdhHV3yqesLoyWAPL+jz1J/4j9fzz8xVokJqTjNqByXNZE6AHXF4dzOprUrmHNkm+9+w/b7wd4JUunRPvUe8C6HPBTnG5/kRt2BxXUKIKdiB5VYGotLp5YuOPcvJG8HgmqjPkaaTH+TFDkhfKPHBgyOSyBwsmFz1k2UnWCBi+cEqcPy7TC4brkX7hORRAAnbG2PcgQeOa/Dv2dmuUGDSry7dbohaMnwsZMpHxAdW6Amb/gMOOO/yGFmCbS3GVQY0lhaseEJBns2JVCDjKpXumdp84LvNqMqhctOH8/u35hEpIa
 yndzspWB
 9oDdWBx+hJpkiFJXyKjmDbOyV3hE6Q4Y4oR35E4RYAkLPU9yP4EAuyqQ0bga+pixyO64cHw64hipZi6w+5blsncyexzMxj1OeM3Xve+sJ/qEVPsJQ0hRkxXnOgUXVXqeMGQ8CaVCcOeMnLXo3pW0g/9uBZme6MZSiyJMJczwFcyrez8omtVcHT+iY/lZQnTR7WIEjhU0jG1iA4zUNojkIMrwrdf+hqE0o7JYSTMOINS0wAlST1NkuPYSyAFHOWvCy3W/zkKwHRbxLwl9UTDW4iA1tR4rKQhUVSSNTPS6PQagdEgO83sGi58t3tvtObMDdZBcgBQcXziyNYb0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 22, 2026 at 04:35:42PM +0100, Lorenzo Stoakes (ARM) wrote:
>Now every architecture has been converted to support
>CONFIG_MMU_GATHER_RCU_TABLE_FREE, this configuration option no longer makes
>any sense to keep around.
>
>Therefore remove it, and remove all the dead code that existed for
>!CONFIG_MMU_GATHER_RCU_TABLE_FREE architectures previously.
>
>Additionally, CONFIG_MMU_GATHER_TABLE_FREE is no longer necessary, as all
>architectures instead use CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE when a custom
>__tlb_remove_table() is required, so remove this too.
>
>A number of architectures only enabled CONFIG_MMU_GATHER_RCU_TABLE_FREE if
>CONFIG_MMU was set, however the mmu_gather logic only actually does
>something meaningful if CONFIG_MMU is set (mmu_gather.c is only compiled in
>this case, for instance).
>
>As a result, there's no need to gate any of this logic on CONFIG_MMU
>explicitly.
>
>CONFIG_PT_RECLAIM however does have a strict dependency on CONFIG_MMU, so
>make this dependency explicit.
>
>Additionally, correct comments to remove references to non-RCU page table
>gathering and make it clear that this is not 'semi-RCU', nor has it been
>since commit 1fb3d8c20bfa ("mm/mmu_gather: replace IPI with
>synchronize_rcu() when batch allocation fails").
>
>With this change in place the kernel policy is now that userspace page
>tables are freed after an RCU grace period, and thus it is now safe to
>unconditionally perform page table walks under RCU, safe in the knowledge
>that page tables will not be freed underneath the walker.
>
>This is all that is guaranteed, however, so naturally it is still incumbent
>upon page table walkers to ensure that the page table entries are as
>expected.
>
>Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

with David's feedback folded in, LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

