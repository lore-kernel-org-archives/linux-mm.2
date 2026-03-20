Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17ADD1099B30
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 21:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B6416B00EA; Fri, 20 Mar 2026 17:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D9A6B00EC; Fri, 20 Mar 2026 17:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CAA06B00EE; Fri, 20 Mar 2026 17:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3B5D46B00EA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:08:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E192413A741
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 21:08:25 +0000 (UTC)
X-FDA: 84567679770.06.223F201
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5A4B340011
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 21:08:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qC8HBmDJ;
	spf=pass (imf17.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774040904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v0z5q5BkScD0Vv0DWxEkIMwRkHxRdQhd9pZjMXjr2l4=;
	b=frBWzmrEJNpCs8G+UWp5Na1XR4ZKXJgUUi8lyoqwW8/6VM4ywST/TUHBK70eH6BU0VAV4m
	4svaI9+ODwmvHJmrylTFlCQv9fdo4FjUq717EEqMDBdEGHIvVGR9W7+ynksI3wFS8cZ14w
	Kz25+X7PBa/4CcAlkT9LQj3daay/63s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774040904; a=rsa-sha256;
	cv=none;
	b=R+flI1ih4rb+fNN//dgpr3upBT8TR9bdluImX1Oc2vTdJyqLmBb91Q1rhwxHmvzcgTL3f5
	rqxg34sBzcjDlkw3Wovz6cAoMtwR2saCdsEcFhgFqVQd6cGa7foL/hJPHou3Ua6nbiG/uZ
	YWUCypLI3GGdS8vrmVFPTkhvUcrukLY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qC8HBmDJ;
	spf=pass (imf17.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BF0F760126;
	Fri, 20 Mar 2026 21:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E28C4CEF7;
	Fri, 20 Mar 2026 21:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774040903;
	bh=u0zdmPIhkicnjjaekGwGuaSnl24uNp/SD6pTY4tTyoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qC8HBmDJbc3QTlANvhaLjcn0O5ay5GqzDEvYHXsOkZQejTAbOkx+bkEo+ki3/IcqS
	 2zxeTAiPAA/ZnIrs1vWkKIH1qQM6hWWWHXeyTtkY/GTcJVwCwrNv3c5QnInC7yBUEZ
	 Emq3X5gGUqXLf66MStAVqC5m2WCTfSbnlpAHXDlhTtb1Ap6h4AtLg1EuCVIYnM3U2k
	 9XYMGV8lFcVQ3Ofo63x/aFk8UD8Gt0FgB8ThIniVMGJGtCnjMclwn9hpHtv2VORGXx
	 vrpZQBmOIITR6wCUusRaEbZoc8REFtZupMT7Shny3yqCThx6DNBFOpK9/XXBVuE7o9
	 ZHBuzLHK9WgAw==
Date: Fri, 20 Mar 2026 14:08:12 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v3 15/16] mm: add mmap_action_map_kernel_pages[_full]()
Message-ID: <20260320210812.GA3988975@ax162>
References: <cover.1773944114.git.ljs@kernel.org>
 <54ff3670662e10a66ce0c1a13c0ae93b99a5f201.1773944114.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54ff3670662e10a66ce0c1a13c0ae93b99a5f201.1773944114.git.ljs@kernel.org>
X-Stat-Signature: oqoxx5y8jso3cgpi641ud137d5djo3gg
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A4B340011
X-Rspamd-Server: rspam12
X-HE-Tag: 1774040904-953320
X-HE-Meta: U2FsdGVkX19hzygn8zIwaGgTT6MsxBE7s3X81uBhHUtkKIJa1IJMnGuWyjvKBCOl5BcD7LVHFwgK803BnsaS/7WRkum3AKPwNoaoeUlMJUPiH4AfDXZDOSU+1XYqEafv7z+MOt8fjD+YqmFNY+ul1kUCMEBx5tOjKyj/YMacn5kPEK4waYZho7gP1RntzWu+LwnqoLUCGsCaSneTspeQYNC0/cJHm0ooywZT7otVcNpR2DRBD1EzYt5aOZAjSHznNLm9oKFbTV35eBP5f1BDxOc+5mFfx746X0/7yaqkxlZANuFYbHOgivFb43whSbYziyLmdgnTzHgpP5EFE6VijFo8mF41YT6MaSQVwe+7FVw2lHTiCozrQcxvegNPFAFnFuEOpoXNA5GPTkE/VQV3gY9tqcg3UcCfokipHLctrCzOb5tsACIwETeBvapUKhiqcAPuRKvy4crhjQyvc39aGhf71ooI7BcNwnxv4Yj7bhKf3fhSNICv8+RP1ckfgMu3pyHznK5Omj2njWBSFfNTrlwc04UkEEU+4uHyTN0bUpahmi4R3WWcBZeSHHk6nSd5OjO6gMQJn//4ZZl47SCQ40BRSH1nzVSxu34o8Mkb6ztCgutlc0unbhaMQS6cZsfMkhQChWIW2/1CgFtiyVqbwiEZN1xSg08KULv9h1Ju/nzh3WvRCoXoc/nGFmHadUo/JjBYNvUDJpHZ3ZmJzYTEnoWGWXXZP2E+wbmExY+qeAjob7hMeooGiBIWI8Q/kqN7CpgD7fMaM0TaO85PLBQPl6EfVhiwUTOy93baOZXRLfJBtPuGAaFiCM5zn1WURkKcfORc8KV9s9uzxeu6idIpVkP8VhsosAhSTq3Sm9mqK47F30edvxeicbJ/y6Ws9bGo4lgchfycxQ1LpAVmriFUn2cXVGOOU6rZl4dqmQoDSVmiveIs8CGuakGKJpK8Vj3Q1Mbh9CW4RBgbeBGEwvk
 L3xXNeHE
 3DjWzAxO7M2G1BI1giRKijrTe78NXR32e1iyaQm/74lYdZM12IhEZR/z/pSJ8nCuXZCIaRWolz4g5/gpoYStw4Y6+HDuT1Fz/p+CHU91nu7AU0BaYug+5Ycc+Qy1uMQ6AoOJ2rr1JPJQiDts7fBTtX5RZHDIcFG//GLYqi81T3gxO4LDVhqYvA6VQQKWOIBbQreeX03dYCgXgEqU2DcJb9ynJDH85Ucu9e0L2u+J0/0wiwwYqTMnij3ocYo/nP8xIxxUCNhV3n+JwNTSdvFiOu1chwzZ433Fbwm0F6XNxhMvEWOLwEFFsKiYyc9GwBeyQHZc6IIeFnUidungCnANnLQSaS+8ZOiLgxPPIQ9zqvHuZ7Dx6gYGFB0Sj2m77mPqODz3r2cvJ8PppC1QoEriPavT22MAE+bvbhVK4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

On Thu, Mar 19, 2026 at 06:23:39PM +0000, Lorenzo Stoakes (Oracle) wrote:
> A user can invoke mmap_action_map_kernel_pages() to specify that the
> mapping should map kernel pages starting from desc->start of a specified
> number of pages specified in an array.
> 
> In order to implement this, adjust mmap_action_prepare() to be able to
> return an error code, as it makes sense to assert that the specified
> parameters are valid as quickly as possible as well as updating the VMA
> flags to include VMA_MIXEDMAP_BIT as necessary.
> 
> This provides an mmap_prepare equivalent of vm_insert_pages().  We
> additionally update the existing vm_insert_pages() code to use
> range_in_vma() and add a new range_in_vma_desc() helper function for the
> mmap_prepare case, sharing the code between the two in range_is_subset().
> 
> We add both mmap_action_map_kernel_pages() and
> mmap_action_map_kernel_pages_full() to allow for both partial and full VMA
> mappings.
> 
> We update the documentation to reflect the new features.
> 
> Finally, we update the VMA tests accordingly to reflect the changes.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
...
> diff --git a/mm/util.c b/mm/util.c
> index 8cf59267a9ac..682d0d24e1c6 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1446,6 +1446,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
>  		return io_remap_pfn_range_prepare(desc);
>  	case MMAP_SIMPLE_IO_REMAP:
>  		return simple_ioremap_prepare(desc);
> +	case MMAP_MAP_KERNEL_PAGES:
> +		return map_kernel_pages_prepare(desc);
>  	}
>  
>  	WARN_ON_ONCE(1);
> @@ -1476,6 +1478,9 @@ int mmap_action_complete(struct vm_area_struct *vma,
>  	case MMAP_REMAP_PFN:
>  		err = remap_pfn_range_complete(vma, action);
>  		break;
> +	case MMAP_MAP_KERNEL_PAGES:
> +		err = map_kernel_pages_complete(vma, action);
> +		break;
>  	case MMAP_IO_REMAP_PFN:
>  	case MMAP_SIMPLE_IO_REMAP:
>  		/* Should have been delegated. */
> @@ -1497,6 +1502,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
>  	case MMAP_REMAP_PFN:
>  	case MMAP_IO_REMAP_PFN:
>  	case MMAP_SIMPLE_IO_REMAP:
> +	case MMAP_MAP_KERNEL_PAGES:
>  		WARN_ON_ONCE(1); /* nommu cannot handle these. */
>  		break;
>  	}

Not sure if it has been reported/addressed yet but it looks like
mmap_action_complete() was missed here, as pointed out by clang:

  $ make -skj"$(nproc)" ARCH=arm LLVM=1 mrproper allnoconfig mm/util.o
  mm/util.c:1520:10: warning: enumeration value 'MMAP_MAP_KERNEL_PAGES' not handled in switch [-Wswitch]
   1520 |         switch (action->type) {
        |                 ^~~~~~~~~~~~

I assume

diff --git a/mm/util.c b/mm/util.c
index 682d0d24e1c6..c41c119a5a74 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1523,6 +1523,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
+	case MMAP_MAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
--

should be the fix?

Cheers,
Nathan

