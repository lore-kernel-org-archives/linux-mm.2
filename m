Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBFAEC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 19:23:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35266B0095; Tue, 22 Sep 2026 15:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5806B0096; Tue, 22 Sep 2026 15:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAC2B6B0098; Tue, 22 Sep 2026 15:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DFD66B0095
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:23:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 100EA805E3
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:23:19 +0000 (UTC)
X-FDA: 85242371718.06.2CB204D
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 055D0100009
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:23:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J5NHH9xq;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of jxgao@google.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=jxgao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790104997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bWXycRkvEhooYynfgtJMUHspQSrP76XAP+DtRk1GwMY=;
	b=Vpab65pWJQNtPll0OoQdzrxnMGLf0A8hVjyZCJJnFeQvkST4lJLozoBWYDGcq6Z312MaoF
	/N6orHlU6uJoB06hBpqLzHF+SzLXMA94UVAmC2kHs1lHQRp/WERLg7VuXykMKnvqOOXBMU
	lXjBvrJ5aa4vdvW9goPhGjZcrko13Kc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J5NHH9xq;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of jxgao@google.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=jxgao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790104997;
	b=kZKzO18WIq9Pd6prZ61ouxcfd5+QxUNwh4JPpqb3NZGEm8vZ9InwtSwGtLM6qiLVhB68kR
	xWVrg1Nc7QMgQzzOA4ND34/KUtSYWGz9HkBSKIuZFryLbQInyWPCTqcRqaJmjw3uRWb7WQ
	s4yIFqUvPWMpglUIC8AU8mXiPnU7L2A=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5b5e5aaf7deso47e87.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:23:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790104995; cv=none;
        d=google.com; s=arc-20260327;
        b=hc3VdMew3mENrQWesfDczrwzOvcJHnCCwDXaUzTCHdJf11wvFvPIRFdVXKyzpX4diL
         dTM7UJv/9+bBVs4A9KYrDHlsIPzCukJRKLCqqzgZmXNyaP94N+hNQFOWqWlrQ3Xioaez
         N2Tr8WpAjxEjDz2SORS7/QtKxzhE1MN8Bxd4QJqUnCiIgXPjZBTpCRb6kDFk2mRgLQFq
         HlY5pnfg/edMd8sKIcSWW4OHSf/fAj0N8dkIbaiy2/CoH1m3HfPldNVhABpLOC/Z9DUz
         1AkGwOgWrmKvTverK2bOrpopDHPTRU0+YBHXcRq4LQALOizPmbxpIL4NUMM5jDXXrKYE
         bgDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bWXycRkvEhooYynfgtJMUHspQSrP76XAP+DtRk1GwMY=;
        fh=sJQRHxuDzgT/iQRpo9XQUw+JzwkNutxFD1QZsf1kmTs=;
        b=j24k7DX80g/tpAKi3sNUzp4JXdvKmR/9192J8yIylH2KXm9ItHzbt2v41nPQt0wH5Y
         aWqOIIfRZ4UvIHA9ICNHSe/uxq1xiDwXPo2qUg0lbQQMuEOZ4RytTJ5EYPmvFZUTZ3J8
         92UCbqR4uqCwWJoMQL9DDBg6/7PyOAsB1SZfLygnsrKYFsE4GVRbO/0aJE4Jz91wBorT
         5FoB+3f0cvT2LeMmWVx2dE61NfEh1X/spsZN+BflRDP6sxzoQGoYoNHGqyfJEPG0KUo1
         8XRLKol9UBpo6yeWqGcJQ9yxTQQazEwpbWdTf3jVzg2QtgkR1sMk4gQEirpTlckkH8bN
         Yikw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790104995; x=1790709795; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bWXycRkvEhooYynfgtJMUHspQSrP76XAP+DtRk1GwMY=;
        b=J5NHH9xq7mxkmiG+5M5SA2mzIazQB2X+Rv8tFTAr10JBmVmFVGax7nGbwA+otJ6Wpf
         Jn/D2K6JcMEu3IbIVxu0O/76eol5xtxFpLuY5qfJfqKk9/9Rx9Zc8/edMEZU1S4vGxE/
         k2IMas2I6x1cc4HQVJ4qFwjaQmQpub2p+C8L4GR8URnhkrFrYQwM0ugtxq2fM6AVnCDd
         FFvOE8N/GD2JcP4WyCNIurJUfFRQaXjgxBoskVoe+0HH2qP715QTE2flNbilypVMb3dw
         Mr66XpcbjANI2qDNo5/+Mij5DD0pAdJAPN/ASgB4kTjgtEwupZKqWNPJJd7Hv9g9qI8M
         K7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790104995; x=1790709795;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bWXycRkvEhooYynfgtJMUHspQSrP76XAP+DtRk1GwMY=;
        b=kmbCWSzYpuBqCXfJtviG3j44dVVwGV7yIIM28ubpS/ogpiadfxd02xQ3rnOJkRyImB
         +wmLF74RZxdhirnmOsCGBcVgN2ZZWBBO6mYeOUlbOiWFAGOnDIPko/XlQ8yKWHF73/Se
         YeuU8mNAu6+f/QbR5U9NxehaQgL7q54gvNT1HT1Pi2efVA1TfHJYNpYQ10OnDGtv/nkw
         TAO9YiaT/BwzSEXjXrG3pQ9lECifNPrxQdFiAnih/WIou1mc5H069NGCbjboQO+GpYrr
         jrx3l4N2p1TZRlh/GaJJ6b9YLhpS961y1xKG8Ek9LnZ4DkKX46iakeu6Wc1aoL8WVCD6
         lGew==
X-Forwarded-Encrypted: i=1; AKwUvBzfw3nZmn6BFKUUdppA0Tv5w1Ibwhxu3kAhmLhZo/7B+EvCsyF7CGjOx7njRWS0le1yWZOfsIfJ2w==@kvack.org
X-Gm-Message-State: AFuF++lpCUtoyIM2EeixfnByoETU5iphvVIC/Gycb4tNtG5Kw54N4D54
	eCW2weCi3yM0vqkp/s6Sz6QZ0KXelSmsHy/Mm6IZgdCiLRxuyW7mAbdgXy76VB617keX+SRlaSD
	r+Eh/9KUqxaurDtKRR7bYDfKUZDUMc5yhXG0BlSL0
X-Gm-Gg: AYBFou2D4cHl24sXpyrjEBU5CHp3qnfDLmM8OxpnE2aTU3ZdlAOLUY0rIyeyKchOhbh
	vbCcN+0hmYd1grBxRHJzTVfTd46kDBUgRAhUqYUx2eIJjDq0ZibUpMzPf9SmLDqZXhz2pCOe2Ss
	5YRU1xoDqsKrzh6TI6zAdfyVbFKrDc+iIAQMXt6NbRpVzW4uUcPoiD+iLjVXCeoCKCjq/GRgdeU
	glW3m909nWio8gMw7m3bPpxiTxhh8igSoBhzSULwsi43Bolzjsuk4r848K7/L24yC2szwrych7+
	NYZ/JzJNElEjtbRdKQnsxVSMZkqwJKP9CgLJ4agu69XnivdCYgvIgR+b4RVYHY0gkSlqvLR4yD7
	hCJuH/jxp20C+fgDj+EVeT3E8mdRtN8K6cmsRYqPG
X-Received: by 2002:a05:6512:1301:b0:5ae:b726:5f1f with SMTP id
 2adb3069b0e04-5b8d8848194mr29002e87.8.1790104994064; Tue, 22 Sep 2026
 12:23:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260916115159.1938195-1-aik@amd.com> <20260916115159.1938195-18-aik@amd.com>
In-Reply-To: <20260916115159.1938195-18-aik@amd.com>
From: Jianxiong Gao <jxgao@google.com>
Date: Tue, 22 Sep 2026 12:22:45 -0700
X-Gm-Features: AcwNN1UxkcAsiONLLRx4-Onp4JXfCAvcJEHnQ3RWuM6d-nkITizrfWrwxkArT4o
Message-ID: <CAMGD6P38zYT8FzkFHoaKNEL0tVErK7G+ZLPMzgazAmVoMcD=yQ@mail.gmail.com>
Subject: Re: [RFC PATCH kernel 17/17] x86/sev: Flush IOMMU TLB for trusted devices
To: Alexey Kardashevskiy <aik@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Bjorn Helgaas <bhelgaas@google.com>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Jini Susan George <jinisusan.george@amd.com>, 
	Kees Cook <kees@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Nikunj A Dadhania <nikunj@amd.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
	Kim Phillips <kim.phillips@amd.com>, Joerg Roedel <jroedel@suse.de>, 
	Ethan Nelson-Moore <enelsonmoore@gmail.com>, "Tycho Andersen (AMD)" <tycho@kernel.org>, 
	Liam Merwick <liam.merwick@oracle.com>, Michael Kerrisk <mtk.manpages@gmail.com>, 
	Suresh Siddha <suresh.b.siddha@intel.com>, Xiaotian Feng <dfeng@redhat.com>, 
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, Andi Kleen <ak@linux.intel.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Tony Luck <tony.luck@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	=?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>, 
	Jonathan Cameron <jic23@kernel.org>, Jori Koolstra <jkoolstra@xs4all.nl>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, Ian Campbell <ian.campbell@citrix.com>, 
	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, Petr Tesarik <ptesarik@suse.com>, 
	David Howells <dhowells@redhat.com>, Haavard Skinnemoen <hskinnemoen@atmel.com>, 
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Christian Marangi <ansuelsmth@gmail.com>, Dave Jiang <dave.jiang@intel.com>, 
	Michael Kelley <mhklinux@outlook.com>, Ilias Stamatis <ilstam@amazon.com>, 
	Sumanth Korikkar <sumanthk@linux.ibm.com>, Simona Vetter <simona.vetter@ffwll.ch>, 
	Toshi Kani <toshi.kani@hp.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Vinod Koul <vkoul@kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>, 
	Arnd Bergmann <arnd@arndb.de>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Palmer Dabbelt <palmerdabbelt@google.com>, 
	linux-coco@lists.linux.dev, xen-devel@lists.xenproject.org, 
	iommu@lists.linux.dev, linux-mm@kvack.org, aik@ozlabs.ru, 
	Santosh Shukla <santosh.shukla@amd.com>, "Pratik R . Sampat" <prsampat@amd.com>, 
	Scott Soule Cheloha <scott.cheloha@amd.com>, Ackerley Tng <ackerleytng@google.com>, 
	Fuad Tabba <tabba@google.com>, Darwin Guo <darwinguo@google.com>, Shruti <shrutiss@google.com>, 
	Saurabh Singh <saurabhsinghs@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: phb3c1o9b5zxy5i57w6thnstw1g1yiyj
X-Rspamd-Queue-Id: 055D0100009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790104996-861397
X-HE-Meta: U2FsdGVkX18RFmHLXvidKZa6G5hXFyMgrLK9rEHZ/aIHkU7IxuJbXXq7/IhaZ9g8Ak5lz4oMF/Dtt8Qh01oS79RZqspD9JJaMC0O+BaeyiYCuUwWbJEo2Oc22lTmiJfdSwY6tIa/mp7t+Ki8U5QP7SOWuVXiNw8ftqHrhzU5M8xMe5bTI3Hl0sWceTQeQ/muUETTOqMwcSHw19Od1DG9GEuDXfWi18HcIRytq3HPBGj9w3lzf1HKsYP26zAyESGo8x5IEYJXfoRLxs7mFKCJ5SOCbgSyHDMSBS0EEVsRkw1EYqJrezF/f58UoUjDMdzuABHMltSWOoxL7OQd17tI5S4pa7H/lAQiGMg8Umqao2TlAUp3GfHaTk9VltzLTxyaZfYgA/91pDljrag51QPpTvtStNyalwfTNx7ca/QzD/fEKlIQJyKr90c6V6E4oPVhY2js2Hbj2eYYk0KRW5N++0Z2qEhnrwK3kXEOWGhT5Kp7viUmL6EWjenupCn4E81EJzYqvxDrdBzqoUDNLOI5VjLBm1a4K+XAq39yT+X/hLYMRs9oZVHVqfn6EBhSN2gljkY5I6RWmR9Muy1qWCKtNlVkzhomt8KgyiUr0fniRzQgD/tgFhHfzYXr6kySPd5P0JzbkhHHtDL8WJhKR0z81G+jlrNlFr2xd+5CI+mxpgGExRDnETOLLPuGUDhjNi63p53mXjcOvKND83ATffp6oMBIZJ3M9LQUMw7METvACzG0HQO+mZ3qBlcMyjwo+bN6nCgGrNCfwM1ppj61lv/i0nB53dZhpc12zYW0QSQIiGjFT/oVNvmzA8NTud1Kqa0BDKQlEYKpdtLFA95/UjNcDaqVY7offDWrTIZOqSbXOl6Ap4AcQHWy1RQj5+V47JEghg1ZAdAwzqgJ2cE8cn+BjtcsUwSYj48GtrpWHvVRQ1Bx6DgKSVj5i5FALRJCSV/LhkdYsPFxa1oWLgj/tge
 qVijLXE9
 tdtt5z6lHZ1Ykcpg0TaJduGT64NOZ5VxrlGJNfJspmy8Tjja4upR3G7KywmB2mkGBLjS5ToYHffevVQgPoRsAw3IqgmJjxy753Xp8eqpf5WTIjKFd2lVmkNypJISk9EguNGETSQ0TQXPcSMoi4ibO3GtYfTHykUc5XUDYL7UYzS0gB/kYQeHah2Pj4SEJya14xH7kub1ofVeEOBWhaauF7spWbAUDylaYrigPCz7ECxUpmKDMW53aiQf+ZWRGvRW1QfT3VmkD3+qw8jo2gbTGvmN3KDu08ytTtGGR8U3D3qKXDLy/KkHZ+SM8VGzOW5jYwJ/MuAeb2xW4QRSJBc7N94enGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 5:07 AM Alexey Kardashevskiy <aik@amd.com> wrote:
> +static int alloc_iommu_tlb_flush_ghcb_pages(void)
> +{
> +       unsigned int cpu;
> +       struct page *pg;
> +       void *p;
> +
> +       /*
> +        * Allocate per CPU pages while encrypted DMA is not happening ye=
t
> +        * and smashing is cheap.
> +        */
> +       for_each_possible_cpu(cpu) {
> +               if (per_cpu(iommu_tlb_flush_ghcb_page, cpu))
> +                       continue;
> +
> +               pg =3D alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, 0);
> +               if (!pg)
> +                       return -ENOMEM;
> +
> +               p =3D page_to_virt(pg);
> +               /* Trigger psmash in the host os now to avoid psmash race=
 later */
> +               snp_set_memory_shared((unsigned long)p, 1);
> +               snp_set_memory_private((unsigned long)p, 1);
> +               per_cpu(iommu_tlb_flush_ghcb_page, cpu) =3D p;
> +       }
> +
> +       return 0;
> +}
>
>  int sev_tio_op(u32 guest_rid, unsigned int op, u64 *fw_err, u64 *tdi_id)
>  {
> @@ -111,6 +142,24 @@ int sev_tio_op(u32 guest_rid, unsigned int op, u64 *=
fw_err, u64 *tdi_id)
>         struct ghcb *ghcb;
>         int ret;
>
> +       if (!(sev_hv_features & GHCB_HV_FT_SNP_SEV_TIO))
> +               return -EPERM;
> +
> +       if (op =3D=3D SVM_VMGEXIT_SEV_TIO_OP_RUN || op =3D=3D SVM_VMGEXIT=
_SEV_TIO_OP_STOP) {
> +               if (!(sev_hv_features & GHCB_HV_FT_SNP_IOMMU_TLB_FLUSH))
> +                       return -EPERM;
> +
> +               if (op =3D=3D SVM_VMGEXIT_SEV_TIO_OP_RUN) {
> +                       if (atomic_inc_return(&sev_tio_devices_num) =3D=
=3D 1) {
> +                               ret =3D alloc_iommu_tlb_flush_ghcb_pages(=
);
> +                               if (ret)
> +                                       return ret;
> +                       }
> +               } else if (atomic_dec_return(&sev_tio_devices_num) =3D=3D=
 0) {
> +                       /* Do cleanup or leave it like this? */
> +               }
> +       }

Hi Alexey,

When testing this series and accepting a locked TDI in the guest
(echo 1 > /sys/bus/pci/devices/.../tsm/accept), the guest immediately
terminates with 0x1:0xd (SEV_TERM_SET_LINUX, GHCB_TERM_IOMMUTLB_FLUSH).

In sev_tio_op(), sev_tio_devices_num is incremented from 0 to 1 before
alloc_iommu_tlb_flush_ghcb_pages() allocates and initializes the per-CPU
iommu_tlb_flush_ghcb_page buffers:

1. atomic_inc_return(&sev_tio_devices_num) sets sev_tio_devices_num =3D 1
   while iommu_tlb_flush_ghcb_page is still NULL on all CPUs.
2. alloc_iommu_tlb_flush_ghcb_pages() allocates p for cpu =3D 0 and calls
   snp_set_memory_shared((unsigned long)p, 1) to pre-smash the 2M page
   before per_cpu(iommu_tlb_flush_ghcb_page, cpu) is assigned (and before
   other CPUs' pages are allocated, in case this task is running on cpu > 0=
).
3. snp_set_memory_shared() -> __set_pages_state() sees
   atomic_read(&sev_tio_devices_num) !=3D 0 and calls ghcb_flush_iommu_tlb(=
).
4. ghcb_flush_iommu_tlb() reads this_cpu_read(iommu_tlb_flush_ghcb_page),
   gets NULL, and returns -ENOMEM.
5. __set_pages_state() treats the non-zero return as fatal and calls
   sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_IOMMUTLB_FLUSH).

Calling alloc_iommu_tlb_flush_ghcb_pages() before incrementing
sev_tio_devices_num avoids triggering ghcb_flush_iommu_tlb() while the
per-CPU pages are still being pre-smashed and initialized:

--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -150,13 +150,12 @@ int sev_tio_op(...)
             return -EPERM;

         if (op =3D=3D SVM_VMGEXIT_SEV_TIO_OP_RUN) {
-            if (atomic_inc_return(&sev_tio_devices_num) =3D=3D 1) {
-                ret =3D alloc_iommu_tlb_flush_ghcb_pages();
-                if (ret)
-                    return ret;
-            }
-        } else if (atomic_dec_return(&sev_tio_devices_num) =3D=3D 0) {
-            /* Do cleanup or leave it like this? */
+            ret =3D alloc_iommu_tlb_flush_ghcb_pages();
+            if (ret)
+                return ret;
+            atomic_inc(&sev_tio_devices_num);
+        } else {
+            atomic_dec_if_positive(&sev_tio_devices_num);
         }
     }

On Wed, Sep 16, 2026 at 5:07=E2=80=AFAM Alexey Kardashevskiy <aik@amd.com> =
wrote:
>
> IOMMU performs RMP checks when SNP is enabled, the results are
> cached along with the IOMMU translations. When a VM lowers permission
> of a mapped page (moves to a lower VMPL level or from read+write to
> read-only or private to shared), the cached RMP check results require
> invalidation.
>
> At the moment the only way to invalidate IOMMU cache is the RMPUPDATE
> instruction which flushes all IOMMU TLBs. It is a host privileged
> instruction so a VM needs a way to ensure the host has done it.
> Note that the guest's RMPADJUST/PVALIDATE do not flush IOMMU TLBs.
>
> The host implements a new "IOMMU TLB Flush" VMGEXIT code which is
> advertised via bit#11 in the GHCB Hypervisor capabilities.
>
> Use RMPUPDATE in the following way:
> - allocate a page per VCPU (to allow lockless flushing);
> - When invalidation is needed, copy two patterns (A and B) to the page;
> - invalidate the page so the host can make it shared;
> - use new GHCB call to request RMPUPDATE on the host;
> - the host makes the page shared;
> - the host clears pattern A;
> - the host makes the page private again;
> - the host returns to the guest;
> - check if pattern A has changed and pattern B has not;
> - if the above failed, panic().
>
> The patterns are located far enough to not hit the same cache line to
> work with the cipher text hiding feature.
>
> The host can choose to not execute the request, WARN_ON if this
> is the case. Further patches will attempt to handle this in other way.
>
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  arch/x86/include/asm/sev-common.h |  2 +
>  arch/x86/include/uapi/asm/svm.h   |  3 +
>  arch/x86/coco/sev/core.c          | 92 ++++++++++++++++++++
>  3 files changed, 97 insertions(+)
>
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev=
-common.h
> index ff763c3c5d63..51abf8d061fa 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -138,6 +138,7 @@ enum psc_op {
>  #define GHCB_HV_FT_SNP_AP_CREATION     BIT_ULL(1)
>  #define GHCB_HV_FT_SNP_MULTI_VMPL      BIT_ULL(5)
>  #define GHCB_HV_FT_SNP_SEV_TIO         BIT_ULL(7)
> +#define GHCB_HV_FT_SNP_IOMMU_TLB_FLUSH BIT_ULL(11)
>
>  /*
>   * SNP Page State Change NAE event
> @@ -210,6 +211,7 @@ struct snp_psc_desc {
>  #define GHCB_TERM_SECURE_TSC           10      /* Secure TSC initializat=
ion failed */
>  #define GHCB_TERM_SVSM_CA_REMAP_FAIL   11      /* SVSM is present but CA=
 could not be remapped */
>  #define GHCB_TERM_SAVIC_FAIL           12      /* Secure AVIC-specific f=
ailure */
> +#define GHCB_TERM_IOMMUTLB_FLUSH       13      /* IOMMUTLB flush failed =
for SEV-TIO device */
>
>  #define GHCB_RESP_CODE(v)              ((v) & GHCB_MSR_INFO_MASK)
>
> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/=
svm.h
> index 93597ad492bf..269050942c8e 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -160,6 +160,8 @@
>  #define SVM_VMGEXIT_SEV_TIO_OP_UNBIND  1
>  #define SVM_VMGEXIT_SEV_TIO_OP_RUN     2
>  #define SVM_VMGEXIT_SEV_TIO_OP_STOP    3
> +#define SVM_VMGEXIT_IOMMU_TLB_FLUSH            0x80000022ull
> +#define SVM_VMGEXIT_IOMMU_TLB_FLUSH_NO_ACTION  1
>  #define SVM_VMGEXIT_HV_FEATURES                        0x8000fffdull
>  #define SVM_VMGEXIT_TERM_REQUEST               0x8000fffeull
>  #define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)       \
> @@ -285,6 +287,7 @@
>         { SVM_VMGEXIT_AP_CREATION,      "vmgexit_ap_creation" }, \
>         { SVM_VMGEXIT_SEV_TIO_GR,       "vmgexit_sev_tio_guest_request" }=
, \
>         { SVM_VMGEXIT_SEV_TIO_OP,       "vmgexit_sev_tio_op" }, \
> +       { SVM_VMGEXIT_IOMMU_TLB_FLUSH, "vmgexit_sev_tio_iommu_tlb_flush" =
}, \
>         { SVM_VMGEXIT_HV_FEATURES,      "vmgexit_hypervisor_feature" }, \
>         { SVM_EXIT_ERR,         "invalid_guest_state" }
>
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index ed0e4546d5e5..aa5a3abb4796 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -44,6 +44,7 @@
>  #include <asm/cpuid/api.h>
>  #include <asm/cmdline.h>
>  #include <asm/msr.h>
> +#include <asm/archrandom.h>
>
>  #include "internal.h"
>
> @@ -103,6 +104,36 @@ static unsigned long snp_tsc_freq_khz __ro_after_ini=
t;
>
>  DEFINE_PER_CPU(struct sev_es_runtime_data*, runtime_data);
>  DEFINE_PER_CPU(struct sev_es_save_area *, sev_vmsa);
> +DEFINE_PER_CPU(u8 *, iommu_tlb_flush_ghcb_page);
> +static atomic_t sev_tio_devices_num;
> +
> +static int alloc_iommu_tlb_flush_ghcb_pages(void)
> +{
> +       unsigned int cpu;
> +       struct page *pg;
> +       void *p;
> +
> +       /*
> +        * Allocate per CPU pages while encrypted DMA is not happening ye=
t
> +        * and smashing is cheap.
> +        */
> +       for_each_possible_cpu(cpu) {
> +               if (per_cpu(iommu_tlb_flush_ghcb_page, cpu))
> +                       continue;
> +
> +               pg =3D alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, 0);
> +               if (!pg)
> +                       return -ENOMEM;
> +
> +               p =3D page_to_virt(pg);
> +               /* Trigger psmash in the host os now to avoid psmash race=
 later */
> +               snp_set_memory_shared((unsigned long)p, 1);
> +               snp_set_memory_private((unsigned long)p, 1);
> +               per_cpu(iommu_tlb_flush_ghcb_page, cpu) =3D p;
> +       }
> +
> +       return 0;
> +}
>
>  int sev_tio_op(u32 guest_rid, unsigned int op, u64 *fw_err, u64 *tdi_id)
>  {
> @@ -111,6 +142,24 @@ int sev_tio_op(u32 guest_rid, unsigned int op, u64 *=
fw_err, u64 *tdi_id)
>         struct ghcb *ghcb;
>         int ret;
>
> +       if (!(sev_hv_features & GHCB_HV_FT_SNP_SEV_TIO))
> +               return -EPERM;
> +
> +       if (op =3D=3D SVM_VMGEXIT_SEV_TIO_OP_RUN || op =3D=3D SVM_VMGEXIT=
_SEV_TIO_OP_STOP) {
> +               if (!(sev_hv_features & GHCB_HV_FT_SNP_IOMMU_TLB_FLUSH))
> +                       return -EPERM;
> +
> +               if (op =3D=3D SVM_VMGEXIT_SEV_TIO_OP_RUN) {
> +                       if (atomic_inc_return(&sev_tio_devices_num) =3D=
=3D 1) {
> +                               ret =3D alloc_iommu_tlb_flush_ghcb_pages(=
);
> +                               if (ret)
> +                                       return ret;
> +                       }
> +               } else if (atomic_dec_return(&sev_tio_devices_num) =3D=3D=
 0) {
> +                       /* Do cleanup or leave it like this? */
> +               }
> +       }
> +
>         /* __sev_get_ghcb() needs IRQs disabled because it uses per-CPU G=
HCB. */
>         guard(irqsave)();
>
> @@ -347,6 +396,42 @@ static int vmgexit_psc(struct ghcb *ghcb, struct snp=
_psc_desc *desc)
>         return ret;
>  }
>
> +static int ghcb_flush_iommu_tlb(struct ghcb *ghcb)
> +{
> +       /* AES encrypts with 16 byte blocks */
> +       unsigned long s1[BITS_TO_LONGS(128)], s2[BITS_TO_LONGS(128)];
> +       void *p =3D this_cpu_read(iommu_tlb_flush_ghcb_page), *p2;
> +       struct es_em_ctxt ctxt;
> +       int ret;
> +
> +       if (!p)
> +               return -ENOMEM;
> +
> +       /* Keep patterns apart far enough to not share the same cache lin=
e */
> +       p2 =3D (u8 *) p + 2048;
> +
> +       vc_ghcb_invalidate(ghcb);
> +
> +       BUILD_BUG_ON(ARRAY_SIZE(s1) !=3D 2);
> +       if (!rdrand_long(s1) || !rdrand_long(s1 + 1) ||
> +           !rdrand_long(s2) || !rdrand_long(s2 + 1))
> +               return -EFAULT;
> +
> +       memcpy(p, s1, sizeof(s1));
> +       memcpy(p2, s2, sizeof(s2));
> +
> +       pvalidate((unsigned long) p, RMP_PG_SIZE_4K, false);
> +       ret =3D sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_IOMMU_TLB_FL=
USH, __pa(p), 0);
> +       pvalidate((unsigned long) p, RMP_PG_SIZE_4K, true);
> +
> +       /* Ensure that the host change is visible */
> +       smp_mb();
> +
> +       if (!memcmp(p, s1, sizeof(s1)) || memcmp(p2, s2, sizeof(s2)))
> +               return -EFAULT;
> +
> +       return 0;
> +}
>  static unsigned long __set_pages_state(struct snp_psc_desc *data, unsign=
ed long vaddr,
>                                        unsigned long vaddr_end, int op)
>  {
> @@ -404,6 +489,13 @@ static unsigned long __set_pages_state(struct snp_ps=
c_desc *data, unsigned long
>         if (!ghcb || vmgexit_psc(ghcb, data))
>                 sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_PSC);
>
> +       if (atomic_read(&sev_tio_devices_num)) {
> +               int ret =3D ghcb_flush_iommu_tlb(ghcb);
> +
> +               if (ret)
> +                       sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_IO=
MMUTLB_FLUSH);
> +       }
> +
>         __sev_put_ghcb(&state);
>
>         local_irq_restore(flags);
> --
> 2.55.0
>
>


--=20
Jianxiong Gao

