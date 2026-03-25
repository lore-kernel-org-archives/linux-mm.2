Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E595FEA824
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 10:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D8866B008A; Wed, 25 Mar 2026 06:04:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9898A6B008C; Wed, 25 Mar 2026 06:04:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 877F66B0092; Wed, 25 Mar 2026 06:04:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 732B66B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:04:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 247591A083D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:04:53 +0000 (UTC)
X-FDA: 84584151666.07.712691F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3BCE11C000A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:04:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TNJpNZcI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774433091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CdQekOG2Kq3qRFabl7VSXT8Km9b04xHc5QXPgAhmcYI=;
	b=pONdbLUaHhM2lUQvGIyF2YbtkqTmtwsnhybyRd0pV1OIozTZdWLLbh2NXoDBGbgpwSMMXW
	xyjZpLpRyYJUDErly4Ir1lnbPekbk8U0VAm63GtfwoPF3bXKqwIZodPWrs4JdS/VUy4+qq
	U4Iq/QRlZl680RUd9wiaA3u+93ddIw8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774433091; a=rsa-sha256;
	cv=none;
	b=ojmLcWNLN3jSbXrlJgjw8M1IYOej1o/yeEsTcRm46+gNS/z3zUJ5oBqobnjU2cpgMYwqFa
	vunf1ZQejKiu3SRdD6AY6Y7e8cWuS8fQuVwtRUJMlH0Hcg/viombiYU+DCtl1756IB+Hti
	6SVslxoV1w++nABIQRE9A5S/jK0snU8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TNJpNZcI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A1CA42B3E;
	Wed, 25 Mar 2026 10:04:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99004C4CEF7;
	Wed, 25 Mar 2026 10:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774433090;
	bh=mWCjyaxKu+x+LzWRgLuhujGHLbxlc3MmkD51VDioSIg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TNJpNZcIC+RvxqTV15Sf9sni6H4IWM0T+i3wt5MLiMfUHkfT34q1CwGBusWH1kE3/
	 dnN4SNi4+AvIgkYt4oSgjYjdYCeFsI6VrGO5PEXoPnnlOc1fbEncDzZgNiPcjbFygA
	 /ZtI085ad/dYBptuY3ARMNcg2KQletfHZ9gpOpculjQh5nP+N4E8Zr8dD6BGl/fyUR
	 zafOK0794Im+0DBGvQliZGSK7JRyRUDI4tpM02JeU+gvdZP2ymlEdlBc6wgAXyOd0B
	 aK/i0OiLd75T1xW0NaawDtJsRy0EK96sVVOg5mJbXC0sIeQ13cP6pms6xqicRCBsL8
	 W+CvXhvSGQluw==
Message-ID: <e41b5b30-7371-4c61-b6f6-2bf35e4d68c6@kernel.org>
Date: Wed, 25 Mar 2026 11:04:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/21] misc: open-dice: replace deprecated mmap hook
 with mmap_prepare
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1774045440.git.ljs@kernel.org>
 <5a83ab00195dc8d0609fa6cc525493010ac4ead1.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <5a83ab00195dc8d0609fa6cc525493010ac4ead1.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3BCE11C000A
X-Stat-Signature: tof99wmbfr7czo3gudp7j31gp66ei9py
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774433091-907559
X-HE-Meta: U2FsdGVkX1+oYDc5QVOTS0WyRsmSsfR+JcCduvrGSYSVRRXxsZQkqgL3iOly0saQ67f98AFJZea33UtdZw4vgWx200g70P7pUCvITVoWMSlmxUVCfNBiwWO9X1hAN39+I1Qh3E1moWIiSWhTd7kgM+ElaqqADBO9kAa8mcTwSy6lKxIdSIaKI0lnwn3ErRo8sU7qcYyUQ9m2BACqEp05vKaeorfmCDWU8YcNmr1cItIVk8bVbSXHw5ywvMzwLUNKjfhNU4BlOTUWIFni1mPj14qr6gKY6A6Hoy1oik64rHy8lPJv8fR98OipEgoQKbafQJs0qY+Lj4WPqGZO9fqGHX+DwkXipUtc8VH4L4m1rmn2Qcd9dGmy4sl6kOkoeJFjCifWcW9r0BpRLOyAQrHzFIMJC6eHZ87nbP9IZ+KTjaDqhG/Hp/FHmxAbKe4ynauCz8NNK+j6RGRkr2YGNuiTBCA+fGZAypdhbdGo4aF0j7P3SUHFjDrZ8ku/hN9pCUaqH5FdfJglTnyrb5b+R0Jun1L8x1fU8usidIzKDhk/PbfxH/YSqCt2qCOPZtW0pxOlYkvzwHkAhzX0OXy/wmRR5EVZ6IPp2+8xBZyWpi0zRoL31WF5mgCsNTNYROVsjuJNvrta/lAmwioWj7fFRpRzssQBvFTWvqIQ2Hj9LqVH8MvibNIAeor4/6oNSZ7Mo547mxOV0m7wAbSgCPmDUppEkG5dehYkV5NqjMWks1SVgGSBJgu2554dAdlEUm7LjQTLC8xQZT0SHz3dnFCJGsQn95Zd0i8oyyLFoimBNYW0imAlBKGGlT+06KSauuGzh6WuTv/AcGYWK6q81WAHXObqwHRVi/DJ4vhBiQEQgEnTLM+ahJhnoGAJkOQcugXkOzHA/P+W8TOxOhS2Kg/Tw+D2RYbcBOicj1SM3Kkd4fCn9hODZoJYEmihN+VqYwPVN9vVR5SuF2dwhCLRAaqz3CQ
 TRpiyyNn
 KfVL6c4CkhvhNaRmqgNrWhUyTtzmEEATcheChFk5lYILZ8Pskk/sdj1iRAaL2EbQaukJvhEbedWrH0KnJdEIim4wCa1b7ob4c2P+PL+KMWHBfSjqgjrdDldq03+tD7QG4h7zUVJiZR3j2n8H7Gn6cRfQY1QEWlExj4KumEmRw97hgZKAQxxx8PQ5yZms5uoyLDJAajGyBrnx2OjegE4nGYeHfDgJoTuDSAE2CaPnIlIu8L5E+7U+alw72N22DqiGugHr+siWtQeaNmT7Y1unUyLrLNGNOlw2fhrpupo24LYPAL/5YeR5OhGAR+ssgRfr5Y7qAjqBGLuOffiMJ2/lOabw8aFTKjVuTbH1++ZclReSGuhyIeKuRNjOsLATOu8kK4c48eVZv9nRMSX4/uW64vaoobBLk8G5ET89hmZGiQ0G1a5w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> The f_op->mmap interface is deprecated, so update driver to use its
> successor, mmap_prepare.
> 
> The driver previously used vm_iomap_memory(), so this change replaces it
> with its mmap_prepare equivalent, mmap_action_simple_ioremap().
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  drivers/misc/open-dice.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/misc/open-dice.c b/drivers/misc/open-dice.c
> index 24c29e0f00ef..45060fb4ea27 100644
> --- a/drivers/misc/open-dice.c
> +++ b/drivers/misc/open-dice.c
> @@ -86,29 +86,32 @@ static ssize_t open_dice_write(struct file *filp, const char __user *ptr,
>  /*
>   * Creates a mapping of the reserved memory region in user address space.
>   */
> -static int open_dice_mmap(struct file *filp, struct vm_area_struct *vma)
> +static int open_dice_mmap_prepare(struct vm_area_desc *desc)
>  {
> +	struct file *filp = desc->file;
>  	struct open_dice_drvdata *drvdata = to_open_dice_drvdata(filp);
>  
> -	if (vma->vm_flags & VM_MAYSHARE) {
> +	if (vma_desc_test(desc, VMA_MAYSHARE_BIT)) {
>  		/* Do not allow userspace to modify the underlying data. */
> -		if (vma->vm_flags & VM_WRITE)
> +		if (vma_desc_test(desc, VMA_WRITE_BIT))
>  			return -EPERM;
>  		/* Ensure userspace cannot acquire VM_WRITE later. */
> -		vm_flags_clear(vma, VM_MAYWRITE);
> +		vma_desc_clear_flags(desc, VMA_MAYWRITE_BIT);
>  	}
>  
>  	/* Create write-combine mapping so all clients observe a wipe. */
> -	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
> -	vm_flags_set(vma, VM_DONTCOPY | VM_DONTDUMP);
> -	return vm_iomap_memory(vma, drvdata->rmem->base, drvdata->rmem->size);
> +	desc->page_prot = pgprot_writecombine(desc->page_prot);
> +	vma_desc_set_flags(desc, VMA_DONTCOPY_BIT, VMA_DONTDUMP_BIT);
> +	mmap_action_simple_ioremap(desc, drvdata->rmem->base,
> +				   drvdata->rmem->size);
> +	return 0;
>  }
>  
>  static const struct file_operations open_dice_fops = {
>  	.owner = THIS_MODULE,
>  	.read = open_dice_read,
>  	.write = open_dice_write,
> -	.mmap = open_dice_mmap,
> +	.mmap_prepare = open_dice_mmap_prepare,
>  };
>  
>  static int __init open_dice_probe(struct platform_device *pdev)


