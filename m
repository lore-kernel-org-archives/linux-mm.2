Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2922EFEA83B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 10:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C9AE6B0098; Wed, 25 Mar 2026 06:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0EE6B0099; Wed, 25 Mar 2026 06:15:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DE536B009B; Wed, 25 Mar 2026 06:15:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 427C16B0098
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:15:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D3F87E0B90
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:14:59 +0000 (UTC)
X-FDA: 84584177118.09.84B05E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5075A4000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:14:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Avb9roEt;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774433698; a=rsa-sha256;
	cv=none;
	b=ZjyE8jkQVSIKNogQN/jXcw5HmPXr937JG5q0fzjfioJDE7K1vLTcDZgoii6PMr6kE835EJ
	tDHCbd4XHOTCHS1KLkiuhHzgNPFK6FjLOpQN5FP8yJxZSzV5BBUsuGjZ/ZtBulwa/GDnOm
	7R0tZgQs7+RgjpB25u2543OM40jwUjg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774433698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CdQekOG2Kq3qRFabl7VSXT8Km9b04xHc5QXPgAhmcYI=;
	b=H1q//xnNtKFbZKEwSz/hQV5twAu4oCv36P22DYp6ZzNj7EQBvMtMgh0FGBTPf71mdhSmUQ
	3xtXLws2gSof/nEakzXxJg176YJpGSPiklrhoDiqfjGk7sAK5QiPnd12YBFDP2KAvZsWhU
	hXr420qOe8oyX4yZp/Eeb2WYfqGmy0Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Avb9roEt;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B6149600AC;
	Wed, 25 Mar 2026 10:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677D8C2BC9E;
	Wed, 25 Mar 2026 10:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774433697;
	bh=mWCjyaxKu+x+LzWRgLuhujGHLbxlc3MmkD51VDioSIg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Avb9roEtz2tZC7EnR8/vBPTkFsUrFyERzOI3tR4QciMupwqnA3DiWXvUrFwz/I8Gi
	 iToXYDmfHcDBl+a0Z9K6rywnep3+HsnmYiTLv00vR8Hb44EItpTuJmrZrkc7RDMuof
	 3qYGqfxEmVJG1qEt1tGMGJ3FjTgRTeD1Xuk38xFFI74ll1XywwHliBcHsOjCiqH0s0
	 Mf1322lzYqLtit9CzSq96FEzvxUS0em6gQP+PC+HiEQ7XGm7P5Ha2K8pVKtSU72lSb
	 eV5gJPu7fOk1RVXaPY3BJekak8hgmqpoh2HE9XIskljcq/LHkXCpoUTbG74tqJfX7S
	 iVt/tb9OUXrLw==
Message-ID: <6fe7f335-2dbd-4d95-9918-702ca9fd10a7@kernel.org>
Date: Wed, 25 Mar 2026 11:14:47 +0100
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5075A4000B
X-Stat-Signature: jwspekyjk114jm5ectrmnkxggd6hizbn
X-HE-Tag: 1774433698-439438
X-HE-Meta: U2FsdGVkX19gRHn1qYsng5jK7fxMwFvZx8l74hLv4TshA+m6s43Jkwvn9ZCP8SfWaGlgLY/19/o7CmUN+2RkUjfCOEBJUNRFbA0/39o+hq3BeaMz8PItkgrbWVdT2iByJrzNXqzClz+/vss2Qd+TDvhH07mwzWlrWRoHZr2Z4AJl3BcTPMndPeVN1TLFL00YxGMn//pgZ4BWW5yExvEqVw43fRh+FQdJQSsDcrabHfkgvF16/pNwLVmmdc5B5czYM+ZfTHLDAPTeaVqSN0HoXgIQKufLx9rc2ot04uGj+MAwODJFI4ZpZ1Nsqn/Dfq2v5ULX+izZP10+bG06AfpIVok/umWjfbKC/I7DaOao0IriNNPKe08Nl5vhrViKyP0ISO+GH/afEpnB6i/9kjUGSLf49hXNYyaQHveO6ibVUoZ5jV7jJbmkDRLMvuwesIm+NlT9o8JpJzTtd25cOxx7Qc7cWh3OuV3cYpdsbDoq6OSs88hZNYtBTLiRWlOHFyvPYQMJbpb6Nj7wFMR4NkuKCaXd3uUND/3294r0F8aAowgkioKF8mX9gV3p2Yk1VZAEnk3GYyf7ctIB1v23dHrKEkrhNDv8v2uWBSRynOZEGUJJHH98Psm5LtiFwqa0OFI1xOx5oqbpzFvoOTQK3Oj/EnJu+ew3rRKXZCWMbdyAlOHv6Uo0GFLtMMOZgumYxxpaEldlDwYtNepGV9KwO2UnAXWZ0Ea0CNpVEvCZqWcoojr92xLkqboXUnz6Y9fbP8W2rQAEluWGOJJkuZDf42NBkIivdIqNa/BCiA6kack4vLSToEgItJpCMxqNKJL4+XK5DvCV7OXIJB8PzbPgcMkxPSVuPcg8K2kchIJYNw2f8BvkQ3MpsIscSKnx/KfPrgPqpjpT2/KfymkqY0xXJwlyEYnvtaCOMcH3dJdyebUmFR34ghx6Yd+H3WGQ9p9AtFelCjC1ntl3ssPy5UD1E5Y
 fme/NBQ6
 JQIeWqDa29yo62+/Wd2ZRjIbJ3RnumJZev+XZXANmlnNUVCmczubfa1sROPc4X3LHGzkVWJLh+uPipPw=
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


