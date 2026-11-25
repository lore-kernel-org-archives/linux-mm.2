Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 482B3606A335
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 16:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MT0lml1B
Received: by kanga.kvack.org (Postfix)
	id 666236B0A7D; Wed, 25 Nov 2026 11:40:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6186D6B0A7F; Wed, 25 Nov 2026 11:40:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 506276B0A80; Wed, 25 Nov 2026 11:40:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 278B36B0A7D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:40:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 96E48120F17
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:40:29 +0000 (UTC)
X-FDA: 85474204578.22.F85F6BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id F1827C0007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:40:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MT0lml1B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795624828;
	b=Xx8s6lmRsGe4Z8Fu3ux9T/W4dTyrN6dBRpix9iBGdNJ27HJasvsolBhVxMYSVIarecFIHD
	5UGk70k8Sd+7nmDLc9Uh0r5dJ/3H576BQhl1g7r9DX6eqBX4NhYJLZpNnuYayu6Dz5HcSr
	Z91hBMY8+lohH6L+me7SkHvGFnfULYY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795624828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M6si0L6IkcJTY0ySD5eo4lPaTuujwGDaAXZ2WV+4vPo=;
	b=Mttf1z5VVsx3L5S3yvnghRJ9UXkVNKPSUO3DYtgdBSss184jdrI5uxPKKrP2jAnXGzVPqs
	m9Jw++71yYAHLBH0KvPlHPsz6RXeMh3RKp1+uGbKk40uyPdGv94roL5xgwTW6HYZqkXiBB
	wEiay5D26fulveEfL0Vl5ehZelONLNM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MT0lml1B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 73099400DF;
	Wed, 25 Nov 2026 16:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D651F000EC;
	Wed, 25 Nov 2026 16:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795624826;
	bh=M6si0L6IkcJTY0ySD5eo4lPaTuujwGDaAXZ2WV+4vPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MT0lml1BD0MVaxFbYCiDa6kGf+Fufw7PmC4jRB79QEunJE75482OGgaJoDYKKfv1e
	 +iwUq2JFos4IsraaMWKkT2c96dgo97zc1qNNh7CRicufgDFQ0uFoKdGvlFb76Gs6/k
	 SilU/Ls3M+2pLkOgL8yFePBa5his73RZ+ljVELpROBw0hEJgwBbnQfGFgOMIO4iV0j
	 4IJuBjd66SuKcyOZauBOtomzA4bvzuswr84Hxo4GFmJDdWMac0k2dACyMQy6pOzzwL
	 ZND2KythHdD67E/S2Q1in7EwJfdiRBkLh0WpZbbHNcyRt3uuffNl/GHnvSbnFZwuVr
	 y+izVVUvotpSw==
Date: Wed, 25 Nov 2026 16:40:21 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: kernel test robot <yi1.lai@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, 
	David Hildenbrand <david@kernel.org>, Eliav Farber <farbere@amazon.com>, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
Subject: Re: [linux-next:master] [mm/memory]  f8eca7ec1b:
 xfstests.generic.437.fail
Message-ID: <awcPZG-dG5DvT2o4@gremlin>
References: <202611252134.37a9cb7e-lkp@intel.com>
 <awbxo7VZyrECnFtj@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awbxo7VZyrECnFtj@gremlin>
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F1827C0007
X-Stat-Signature: tfpjjsx8379h7gbofqrtioceykd3drsp
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795624827-914996
X-HE-Meta: U2FsdGVkX18h30MqCM8+qWh9wSXDv3+BwpBxNcvSR3SuzYZ8xabJaOCTbZ8vXI18SjywFCGOj+d8bGfQ9ZUetGFQkZjfsrq2Pwvv8cK1OxhWjubJeNIDC0+/xcPTW83pHmDhVkIIQtZjtEyDnzCzYA1TmyH3NpaHAlmYCWEyTMk3agbQLhdEDSYqaZlciIYJIzju7cNsaOmXqbvIfY5fB7FS3H1gql/ysmAizZiHI9eKL2Ta1g046lN0k5Y5eKo/r5MuqEzaGP86glSK8X2WlWa0ZgDeR2vGKHyCRU1CpY+bdTXaeK4P9r0gaqOJ6w3QdPHdkGkqEME53zmtMrnn0FBjkZkc2sH3J4yVB0+KEypCpKWnSre1w3I4TcZKdRkUZg7c0oK5aEG3+kSFnxojKVHYu7jC8SOPBvbI8YNVOk01WVn4v5Or4DOgOoUooLZQgD8JxPZRSmeeSUhJ3jFb4xqyIysHpW6BUToy9KTM6iPO9xWDsExTsMJNgp6yU94hpZPrlr4ApNBGpL/MVvmBDFi0bIhp/HlvkU9NVP4IU7ItlnCN7gwOqNAWS9y0Rvb9B2E3cmshvc4aH2fBLZdiiPISyAJMbOZ2RzBW2HnXzlZGzFSopownW/50rZq/tz1wND8kZTYRB1U6w8sJrZgG/WzqWu1OSnXgGPi1QPu5tWmQjmbb5c/NL2YmI6Bk3gErDvBlV2IgInybpl380r72xJXaTBY4pjmjDRmcIyzF4HHFrrdAHCqOzy/3lMw3gJ2NLsnb9+0jE5vwr6//JaABEsULfrA5E8SvA6S6hPTlLr+fMBzgh7XIlu+//9s27Lsp17fxbxOfhzGA1MJz3ctTbHRY/W53IbuuekeSUKPVwjf3movZqWiRPBVYGY3UoVRB5Y1niTeoJyO7qtDAzGo6zvqLsQ2EXMWQVrul1CgRMDld6YEavRUrHuODcH2n50trfhzdMg+TKz2VnwcbEKD
 yhNjMdOL
 SlTzK21kI5AEkAr7I+WVEWMK/OiV/1RgTmdf0f1UqIEm0sPpp9ZBdj8seCajlmT1qyQVSBn9SoBwcz5lON6nvVxaitLg7Q+ZND+HOfzSHhOKB8vSPt2F1DWrRfxsdjCvhQMTHPxczgJR5kn5ZWfdPXSjkTYH/67gkrOOHesOZoCUK9Zl6yPKBF/dC5a5kLUpy/SJ7HxNyeNMJohhJGvfqLRiihUPKAE2LocSLRDV4Bwbl+fY0VA6meIAasKEH7ixIc/ORHeEvsMTpJt6YL3D8KG48RO7BKioOhHZPgcRkFPIgH8h8+k9brAtxrWBc7qPJboj/TYOC4z2BWManIE0h00HbvpzYCwu6DcEnBGYLUQ/XvWHE40ogip69KaqgjtKBsWh69LM3HcHUy47yN2Hu+ljmuZALTJ3UdxYrAQdij7w5fZ6ydC1vBT22V67QPd+DqwGcPhjbQZ4QO9BVZlx9sK9tOkBblQe4ofcDutVdHzkLSqgQFTk4Ghfxbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 02:34:15PM +0000, Lorenzo Stoakes (ARM) wrote:
> On Wed, Nov 25, 2026 at 09:47:05PM +0800, kernel test robot wrote:
> >
> >
> > Hello,
> >
> > kernel test robot noticed "xfstests.generic.437.fail" on:
> >
> > commit: f8eca7ec1b368557613cc727abadc82546c1f46a ("mm/memory: do not report OOM if insert_pfn() races a huge fault") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> >
> > [test failed on linux-next/master 3dd8c790a7b7027abdd568e36db5e82ffaea7c77]
> >
> > in testcase: xfstests
> > version: xfstests-x86_64-d07dca72-1_20261110
> > with following parameters:
> >
> > 	bp1_memmap: 4G!8G
> > 	bp2_memmap: 4G!10G
> > 	bp3_memmap: 4G!16G
> > 	bp4_memmap: 4G!22G
> > 	nr_pmem: 4
> > 	fs: ext4
> > 	test: generic-dax
>
> Ack let me fix this, I need to have this return -EBUSY not -EFAULT, meant to do
> this sooner but got so tied up with other fixes ugh.

Fix sent at https://lore.kernel.org/all/20261125-huge-pfnmap-fault-races-v3-3-bbc44489341b@kernel.org/

--
Cheers, Lorenzo

