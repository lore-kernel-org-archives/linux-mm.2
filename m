Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC99D606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=cUtfC1HA
Received: by kanga.kvack.org (Postfix)
	id E9C786B05BA; Mon, 23 Nov 2026 06:14:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4CD66B05BB; Mon, 23 Nov 2026 06:14:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3BBC6B05BC; Mon, 23 Nov 2026 06:14:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B00DD6B05BA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:14:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E086C086C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:14:34 +0000 (UTC)
X-FDA: 85466125668.08.1AF576D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6C39A80008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:14:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cUtfC1HA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795432472;
	b=0ReGnMW17WtuASZyi718gxgDC7MSfrphv9F9ZgnrkPi2XgkEG8bfr41wrlmgMjPNIPu0wX
	9xIihtKM4J7Nxse2EOxcVSGhVoDwxPHJ+2MPRb8aQmvhdW0PB++tNq7klcgk8tFtTeMo1j
	WeXuaJOjB+fDgOuhtpRvzEGyNgeKRvY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795432472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M8BgEwiMtUwRuCgZnUVMTSSA8VV5wT5wVfxb83hMYt4=;
	b=cWDQwDV1Q3NhyPGFeBsipLXQswRrcZiX5Zbrwj1QJPBILjSUBQnEvW8oOc0nUDTSi2fZtE
	w3SZFMCnhnEx7RGSI7dXsVpyiNDbECKl4CLQCQRJ2kJDaaPcn97ePLyrUU+GhQYTKqoj7W
	y+eFTgo8BD80YDpWd6mi2/BJG0jdXo8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cUtfC1HA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CE821476;
	Mon, 23 Nov 2026 03:14:28 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1BA2F3F882;
	Mon, 23 Nov 2026 03:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795432471; bh=4UDMjdKhEafTSrkfoMvLUzagh+R4A1yL+W6+zxTSE3g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cUtfC1HA2CZBX5GdLcjS9Fv5iD/xcSaWNNdEjaMRUj8xf0cmPTKcKav27v+CAPLkC
	 w1bkGxtfk5N0ExzhPBYejU8PO0+4gtg8l1F7GJM4V1zbhqzbrPWAA1+BjvltqwmxMn
	 LE7OlN/w/0fHifp9euPk5nQuLJbtKZlIitJWjJvE=
Date: Mon, 23 Nov 2026 11:14:21 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v10 01/13] mm: Add an allocator for CoCo shared memory
Message-ID: <awQgDYK2Bq0QGpNU@arm.com>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-2-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261116091137.94252-2-aneesh.kumar@kernel.org>
X-TUID: 696EyIiS0JVf
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6C39A80008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: rezr76th7cs9g81ydznefixgc5tgg5dd
X-HE-Tag: 1795432472-94107
X-HE-Meta: U2FsdGVkX18VHylqEqft11wCwfGf/2RFnxZrypgvUeCV+pcZ7QETF56st3gWVX5yM/kbt7XMzYjcrVXQNJcMqwKm7+C9sUdY198fwym/E6IcQr/xKMoCvNyMbnXdCOGMBcYG15tIjkQ2d5a5C8WXjTnfG4Q7mHDBAH75hmve0Hiltzjeh/I14hz374c8jKqhIFXr2hTavOA65SPmAeFkW3u4ujAkelfczJWdkDMi4KSUKohVPVqBPytY7FmX7gjILHa+7hxQmdfyQhCE8TnvHCdtVk8W1tvgecrv/juGTiaWCYsFP7+iLQcXfcW3uNhXtPs+raHeAfaWmnXlCxR2B84xzTITWGMaUYM6vrgtYpc4vhHpMrBtN4mVpQYCl+RLzQfgrn1CXX7+GnEyRE7hrws4T+aDNVjRyuOvjZei/7gVzeuqqWCpxuprCnWdk+AFi8OKyJ2Lu4oy0erF5Y30AMqxcEYYow25AtmHnDFSqDmZh5QdBRGVf/iicCN3MdYieGNICqtIuXVz1f68f9vrhz1TZd8x7chi/LKDdieaf1IyR+PhsZ1J4rWVORbsN2BkQVxyCYOjprBP2m9lxidSieB/1xzPknveGuRbHE4IDg3AJ4T9Mg2uGYqsApX7zwHwHXhNc4Xqu8xER3RfJUOF8XkSiL+LFVbysdwY66wt6KhDdoPjmV+D+lEsMabtXwgcKxdMJ+eiTjgiJb/mXL2+pV0npaVPoQQIkxKRXMUwr56PLt9juxqnt+6jE/0oKhdDkZBhkdaT+3DVkmxwgNMmTBzUktc/w2+c/JE0Snlp8j7GmV4vl93ArMH+QeIS+IHWmGwT4XLTpd/XUIWPvU6/QdCBUMzxIWHNlbNtD9mAevMmiLrM8/vzb/p8eufXyVOsYurV7Wm7ZGW81l1dtpADh+vEfG0YmWP000OsB3DI1h17cdFC+oncrHhYjo91RUm5tUEloJD33Opp9chbY6I
 Frw3utbf
 SWuPZAj1Mb1SSX13nZoIC7nZYodEpPIlmbTd0KWG2r2aNzgrSIYbUzqqCQyvWKPU/3/yhjtuCASlIxCXobCCrqzlGhUdjOyZVezeWFiE7n0leJyP/VNW/08DVtFotrt7cFRZkCGRwAnPQd3SaPSvuuXYz6e1xUvD64egyiGnbVCcZhGTG02IPdNo8f8vaM+zkKq+GDp39QHT0sIIHnnF7OLEmty6Za2wI/rDGU1h9JH2/2H2u2rR0TQDjdabggH5nLvE2putrOOIlGwPD3fZHKhyomwIHo9zx50Ct/gL8vbBjm65SJlckxJC3A4nRDt6mpSk1phbe74w7AQDie4P6QSrx+4fmhp5B9nmtXKsPCBkmAmZ5FK89ORFs0C/HD0egl+bjq0M7O4a7ZMytveQJh7gMeTuv454621khHOSjl3GlIfkWau8ahws4YvuqdqBk5OK5ceBdisiZ/N0xgHrBy990zS/UjwoZLT7gZcSamQW6KvYhmzmstczZL4eWMYvSHDYMwvk/cpBmr95lYe4BIQrul5XehIgtqDd3ZbJg8MD2HjQizRzxaLbqnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 02:41:24PM +0530, Aneesh Kumar K.V (Arm) wrote:
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3e626e45d432..5ce879ea2ef4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -28553,6 +28553,8 @@ F:	drivers/pci/tsm/
>  F:	drivers/virt/coco/guest/
>  F:	drivers/virt/coco/tsm-core.c
>  F:	include/linux/*tsm*.h
> +F:	include/linux/cc_shared.h
> +F:	mm/cc_shared.c

Would it make sense to put these under a separate CoCo memory sharing
and encryption entry? It should also cover include/linux/mem_encrypt.h
and include/linux/cc_platform.h. Both are shared interfaces with no
specific MAINTAINERS entry.

I don’t mind who maintains the entry but I’d list both linux-coco and
linux-mm. We can leave include/linux/set_memory.h out for now since
most of that header deals with page permissions and cacheability.

-- 
Catalin

