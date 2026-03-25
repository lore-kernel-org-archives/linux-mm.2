Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B41FEA83B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 10:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 669F36B009D; Wed, 25 Mar 2026 06:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61A556B009E; Wed, 25 Mar 2026 06:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5300B6B009F; Wed, 25 Mar 2026 06:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4439A6B009D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:17:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E99471A0811
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:17:34 +0000 (UTC)
X-FDA: 84584183628.21.F1DA017
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 211A9140003
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:17:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FsbzuEFD;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774433853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M3Oaf+lsL/xagpYhIMI77+rJU8pe63gBP7xVhdSABk4=;
	b=sW7LTLfWH4Ib7HPBWg2bTvVZvdruPIE7d/YlKsRVr3/aZm9it7ENQBuY8gv6hsjkGod9aB
	fxTDyHjWFHjp5RD/xS4bivtTf+eMT183nEX476/5glX4Yq0zI4T0kTP4r/2GZNtEe5tuC/
	U8h1RP6tErTVoPMCQCoFevPZgvyhFUc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FsbzuEFD;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774433853; a=rsa-sha256;
	cv=none;
	b=azinPSMT0577r3gyKZ8bvP6u18PM5jmyNhaRuO9S2OVENvPW3KeC+CHnxO1ZuzHr4KrKyn
	KpLeCAzUNfyPUflPk3vOT6iRIMMWSHogKOjYQIRiH/+51mnyJEVggBqBnxCh7IftmGkqDq
	XIFPXUVq5k0dS81Qf+bp4ib2Z5bOdwI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C4352443B7;
	Wed, 25 Mar 2026 10:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BACC4CEF7;
	Wed, 25 Mar 2026 10:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774433851;
	bh=nA0qfgO+czMrdsJFZWiTSPRkj/MhdlMkek+0+cH4SK4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FsbzuEFDSLYe92S3XWu8yA78sOY17+zhlf5fynvhqSJTYFYJw6q0esNFUoK8ipb2a
	 u7R0mqK8LQby4NecGDUI2pWioR+y7am2SLggsBspBeZ15yYpkkr0SBGpm886/RhHiN
	 rad5UyakBWpkFvgRnnO3d8ty5mH43/XtNctbuFlXr+pC2FE4a3ufJUm13vdWVqj8co
	 4Skreuix3aAhO5na1RQSvBFefxTvYLO7FZ0K5/iflLUiCqXO4VIdN7LbTK0OrRu670
	 3FJ2hxkm9GwTrZwAenqnMthnSBKw3cgrQZw56I9+c3uoT2QVqVKcJOz1Sp0xitGyIg
	 3yAvaJsltHt+A==
Message-ID: <b009c82e-42c7-4808-972f-91c325432d82@kernel.org>
Date: Wed, 25 Mar 2026 11:17:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 13/21] hpet: replace deprecated mmap hook with
 mmap_prepare
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
 <094c5fcfb2459a4f6d791b1fb852b01e252a44d4.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <094c5fcfb2459a4f6d791b1fb852b01e252a44d4.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: cxpsb6po3hkz9z3j3cfy9hh15adc7rst
X-Rspamd-Queue-Id: 211A9140003
X-Rspamd-Server: rspam09
X-HE-Tag: 1774433852-672301
X-HE-Meta: U2FsdGVkX1/8vpl4Wry32N0sKqOdMg2fY3TTaTU+9HTfPaXiJkPnXYwX78CPr2TiFjRjLwFZlfSpKRgOmef9JpI4YgQkJs4BduP0T18A3tF2sqJB2STONc0xU1LfpmEox5p+VtanFA00i1Aop374xaEFNMYpm435tQ36INT1ajEMzHp9j6AcFTcZagNpH5pGnAKJRJsLwcGIjiCfukembHySELXFxiwN55J50iCRCmwrgaO1Pql0GPCwWqqLtilkQPHUaPnG/AlfcmhepE6qQAFADmFZFO8S39HV+7clYJ6XiIXe+STmZqBsNK8hCPxEjxC93FYKtnQQaqt7IVdA5iFu60b8niFVQUxTjr1wiMP1Fv2O1p4fPi4uER0ipGKtNa6stAJrID8mjUfJsp4lS3YugmQKGQkHvoJmBN3Rkrw2+fhKt7Ewd87Cwo9E04aZvlpRr+m31dozCWvQkH3xYnZP2wpXu2ukqd/tdChbP+Tqn+5tTMbSQUm+s4XzXt5f+gqYC4Mjx96vrn9VtQKC2ylaLGoaWKSJ1nGCtm9I8vk6zJW5LTzTmKvrpiVFgwhcPva7HPKDbnQzagOw/T9bY7VS8vqfrX39QHwVLJO75nWomPDxkVRYeuyVN6HgGEQM6pXTmSlXp5EuPFXueAYrJgxxyZuZzpDoiHUnDacJ1e6BwmnaWWssKYqEVws9KiqPsquAhL2zCS4ZZnDZ7AgebAbgMDXUY/1qLLJgvU+qdCfDJmK4POCoNUtHX4RmhAAo5O94+tMJ+vyMnDHzIpyWWVJYrauj14NNmKdXZ8tpF1u2Zi/NiOt8a+1r7gVGQgpx7W1DDR6HqdMCPOHP++/v2TzTnQEB3/UrdN0R2t2BvIAaLuPgSBqp8rS/BqwRkwrdghCgDsPgXYvgChLLuqFVqrOTMb+ErC1q54WW7mRC/s0soCjIgSvDFtE60f1FyxLndmPaAxLHKkJbm+BZh9L
 9fO1O+UG
 bJSJQLhJDe05RmF7oSFVjDWQ6QSxKGcL4ghizi8qmSq19UiUNuCBfBflFV9o+z/ZTf0CfFGhp98mVpJ9ckiGaEPfbD0fqt3Uf7STiGgUiWs1na5nMcaa4h2lxthxQH/DoKCBbvvDSWFe7OWB8SWRmvQNYevmR2zj9Ba2gpXyg6bEBl89tSR9RXwinhG3Vi8IRjeVkeGtLxFDSUDQwXQNnuUJKJyTW0GYjCcXtrM95WMraD5yDJVzkb6MSOQYcvJeW3Dcq4LpXonxzb3IiOxCw3n4Aj2ToRfUvC7LDdXRwCh9IoQyNiW5cxX8iJ9JcF8hHpQNiRMzuWXLf1Ux4g7OOc+2YopH+wXJ+Z2e/1xE4/hoy37xf0j0pMjOP5zvQMlX8rnOLVViriYGfGzr+qfayvI4Xr4eVeunx3Hq/9vRtQRw94ss=
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
>  drivers/char/hpet.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
> index 60dd09a56f50..8f128cc40147 100644
> --- a/drivers/char/hpet.c
> +++ b/drivers/char/hpet.c
> @@ -354,8 +354,9 @@ static __init int hpet_mmap_enable(char *str)
>  }
>  __setup("hpet_mmap=", hpet_mmap_enable);
>  
> -static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
> +static int hpet_mmap_prepare(struct vm_area_desc *desc)
>  {
> +	struct file *file = desc->file;
>  	struct hpet_dev *devp;
>  	unsigned long addr;
>  
> @@ -368,11 +369,12 @@ static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
>  	if (addr & (PAGE_SIZE - 1))
>  		return -ENOSYS;
>  
> -	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> -	return vm_iomap_memory(vma, addr, PAGE_SIZE);
> +	desc->page_prot = pgprot_noncached(desc->page_prot);
> +	mmap_action_simple_ioremap(desc, addr, PAGE_SIZE);
> +	return 0;
>  }
>  #else
> -static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
> +static int hpet_mmap_prepare(struct vm_area_desc *desc)
>  {
>  	return -ENOSYS;
>  }
> @@ -710,7 +712,7 @@ static const struct file_operations hpet_fops = {
>  	.open = hpet_open,
>  	.release = hpet_release,
>  	.fasync = hpet_fasync,
> -	.mmap = hpet_mmap,
> +	.mmap_prepare = hpet_mmap_prepare,
>  };
>  
>  static int hpet_is_known(struct hpet_data *hdp)


