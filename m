Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CEC4CEB2CA
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 09:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7C328E0007; Sat, 15 Nov 2025 04:36:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E54378E0005; Sat, 15 Nov 2025 04:36:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90DF8E0007; Sat, 15 Nov 2025 04:36:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4F408E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 04:36:30 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 756D212EBE3
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:36:30 +0000 (UTC)
X-FDA: 84112336140.15.46CA5DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 151284000F
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:36:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dGxzfoXl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763199389; a=rsa-sha256;
	cv=none;
	b=7nYg/9BGyJ82jqyV63nT8X0msCt2EGUS1JP7f7Llo//1YbvaaAk//GznfH7PviHRq+RtEH
	hXsKPp49GlAC/J99esol2DzWvxhce5pNuC4rq7XFGjatDqf51z7gQtGsaoKHrVqfRSaKvf
	Nkz7F0vhg+uqAXkijfhp4TInpbr0AM0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dGxzfoXl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763199389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKoisX4HLU9dgcXGPM7N3K58Netj8d9bvL1jAWnG9Ew=;
	b=lOR60c/UoP24PneI/WbMaiygtafukoLjxcY+wntM6P0aLycEkIQxh9BwpjRoWLl1FWRI5A
	72dbIbYkltE2cVstw1QoNbNidG934jcTpzDRGf/d4PnuzwMhtOEIttQUvvYGNDFdfX8wPn
	4xXyQqJCuOo46fFE905HBOhsuIAA6ZU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D0FB6014C;
	Sat, 15 Nov 2025 09:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483C6C113D0;
	Sat, 15 Nov 2025 09:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763199387;
	bh=UQVFeJZr0401KX1N/k/ogaXP4dW5OIP3VmbTx9eJ0p4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dGxzfoXlLnRHLFr5Iy+HgSyVz8Mf24TyR4OMdm2IHhWYyyw5lvhnGu1juDXcxNUkp
	 QGhzi4JzLJsO3a+Z5xAT7xWd+MWzPyyx6vz4jvLNbTuQ1z76N3iBJpinvuFeHy843t
	 oTWlLJWPDqqzXfL8c1qC8ZIeGVbv7lhEq4qH4op6A+dTztPFhuvt2s7/V6kahITEd2
	 3GaNsGO0s/w16mxXH8zmm4SBsTxJDfykXeINuvSgDFhuZM7l2O1Y/qg5XIz4OhiHHE
	 9G0bjLz0Z9QZFPaZt+OqQXbfhF9gn/h1IHT3Fuz1Jdv5I0MrIxaoqfRmHqymK78Xs+
	 X5RVw3cugcXIA==
Date: Sat, 15 Nov 2025 11:36:19 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, akpm@linux-foundation.org,
	bhe@redhat.com, jasonmiu@google.com, arnd@arndb.de, coxu@redhat.com,
	dave@vasilevsky.ca, ebiggers@google.com, graf@amazon.com,
	kees@kernel.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 04/13] kho: Verify deserialization status and fix FDT
 alignment access
Message-ID: <aRhJk_Glv2pX2dRo@kernel.org>
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
 <20251114155358.2884014-5-pasha.tatashin@soleen.com>
 <mafs0tsyw7e0a.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0tsyw7e0a.fsf@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 151284000F
X-Stat-Signature: 3byz5b84xxxyq1jaasrad1wzhsqqs7bx
X-Rspam-User: 
X-HE-Tag: 1763199388-621148
X-HE-Meta: U2FsdGVkX1/2o1+rVjW99z/+qVTWFRJCsBFQxwpdmiZQJyDSfQpQBU0QgkKr684cwzHnchSIthnkzw8QNEnCZYYURzU8Y/jah/0wurGod7mqV+oWD7D+/0hHvbjfpgJpE6H9UBo+Vr1AemrD0u9KtHRPTlWzmWFAyZ6yJueF0zcOvWgd9pmSax9FMjJZmkbix8LsSPUyQ756OP7dGS/+B2BJEwHajrmiDxWa9wVxtJA6Jz6I7JpX+5TpSxyaAGFPhf9/zjHjpr3fzgj4L8W3TvsqEAqqFRo5komKO950BvZ4KEuzs0r3enWHXWtsop25insfIAg92OsbdiV6THBsFgxsbY6zz9jTJWDZfSdNMXd54g17cXF/lAj0Ko0wQpfh5zVHolUVfontALNQbYk4+QzTXuhD7Ti9twCMUJLTn7NZaf/o8I29muo+Ht2nxhw27CxULnFswHLag334KInlcv3Nyj+ICn31wCIEg/lPPCvL4fo1Tfh6NdzWZB6eKbVNvgDvtOvcLqsMPX8se/T9rwo05RqQNUcIOOxdOeF94PkYrby/f+Xs4lZxOpi1pIYrG5gNARY6nCQhEeB+H6Mxj+KqVxWTSgjuk/M8ZlYg8NEmCEEe3Xc35OhcRGzY97Owey+R9qsJv7pxnOihhTBDlqi1K/eQcBMXu8CoGUZwell4WVtnPAFNnNFYNgC9eE4dv4Dp9FIVzA1WvweuN7FS/pAoZWb4xZjJVE3JWwE7ccZqo3KYszFlJZUS8sJUMHWg1rMc2DrMFIgUaasar8jcCWxorc0wi7kmh+xvUVg/8xN+zKiQjI1PYhZjbSUtS3l7OQwRa+Q5AWojsfWvWAgtd4MppPCGsem7dNgcofBes7XBHaSX5yzD6KGCgP1EDSivTJu9WoMkA/h3Z9R3hqbih/xzeH6CFLTRyKcDbxdFMIKa54MztT6T3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 05:52:37PM +0100, Pratyush Yadav wrote:
> On Fri, Nov 14 2025, Pasha Tatashin wrote:
> 
> > @@ -1377,16 +1387,12 @@ static void __init kho_release_scratch(void)
> >  
> >  void __init kho_memory_init(void)
> >  {
> > -	struct folio *folio;
> > -
> >  	if (kho_in.scratch_phys) {
> >  		kho_scratch = phys_to_virt(kho_in.scratch_phys);
> >  		kho_release_scratch();
> >  
> > -		kho_mem_deserialize(kho_get_fdt());
> > -		folio = kho_restore_folio(kho_in.fdt_phys);
> > -		if (!folio)
> > -			pr_warn("failed to restore folio for KHO fdt\n");
> > +		if (!kho_mem_deserialize(kho_get_fdt()))
> > +			kho_in.fdt_phys = 0;
> 
> The folio restore does serve a purpose: it accounts for that folio in
> the system's total memory. See the call to adjust_managed_page_count()
> in kho_restore_page(). In practice, I don't think it makes much of a
> difference, but I don't see why not.

This page is never freed, so adding it to zone managed pages or keeping it
reserved does not change anything.
 
> >  	} else {
> >  		kho_reserve_scratch();
> >  	}
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

