Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF4F9CA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 14:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 905078E0066; Mon,  1 Sep 2025 10:05:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D8078E0024; Mon,  1 Sep 2025 10:05:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EDB48E0066; Mon,  1 Sep 2025 10:05:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 635018E0024
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:05:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC0C31A08B3
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:05:29 +0000 (UTC)
X-FDA: 83840853978.30.2246E69
Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	by imf22.hostedemail.com (Postfix) with ESMTP id 43A01C0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:05:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=IeHKIisd;
	spf=pass (imf22.hostedemail.com: domain of "prvs=332aeadb2=roypat@amazon.co.uk" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=332aeadb2=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756735527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kse27neqs7TZ5sTIdJhbs0CXmugDWDcv4gD+1oQQ4ac=;
	b=fTFumca5kvj3cgbOZEqqA8Zx3fFpfS2jRp6Xx74L17mn95uLGDadZh3sDWHaEFRkAO12On
	07HDLiRhN966i5UcYnB3jvOg69RoDCVD+9bfYn2xW2n+LIv3dB28v1xHLMdL7HoSwGDDiD
	WfNNgomGPKXDaBVLu4Ky23NyqeZvf40=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=IeHKIisd;
	spf=pass (imf22.hostedemail.com: domain of "prvs=332aeadb2=roypat@amazon.co.uk" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=332aeadb2=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756735527; a=rsa-sha256;
	cv=none;
	b=44hVJq1mXyVQsHtaG2ldmjsCtaQFDNPOeUqeuwW/isrDQ9ayN93y2YvFeXvZfkZ2yo0+9Z
	nDHf/nn7MTV5yB4azhgcMmY15bg5ZyQiHb0LiceLVbT171z1lXxANjjumjZWLlwEOQJG/4
	uuBXV8HZOR4BBh6o6kPxwcddgsPq5fY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756735527; x=1788271527;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Kse27neqs7TZ5sTIdJhbs0CXmugDWDcv4gD+1oQQ4ac=;
  b=IeHKIisdRCXoZ5+V441l9oXqa7nrbEkpfLyaC0umnYkFL/LbuVXeiFnj
   BhgsLae20Tlq1w4DSiqC48YHBv+GVqku1yOGfD0fdk6/0lZGbRbuiGVWP
   63r5/nUvd6FMLgpueoH8UgaLfdkjnUSJeOhhv3YaOBZo4m7adb83Tpa7G
   lfEYZRYD4j3yDKoylKH9GKksATNVzCcNeDSd78BLXHlvXyVtH2rIYdW5r
   V7xIJkNaGSvlKMF9+nKvGVtRSIK2LFwVGLqshvlOG5z/KI1SM1ErRbR2q
   tT5PMXQRYJ+SO91KGf1UA/nn9gscfAZJhw0SoT80PRAyGPEepUT8AgZWr
   Q==;
X-CSE-ConnectionGUID: 6cHdMLo7TCuPNE/i2oSWAA==
X-CSE-MsgGUID: 9a3n9BLESJaLUrTeRH3vhg==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1361090"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 14:05:17 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:5495]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.18.194:2525] with esmtp (Farcaster)
 id b74a8fdc-df20-4ffe-a94c-ca7bfc8d3d2d; Mon, 1 Sep 2025 14:05:17 +0000 (UTC)
X-Farcaster-Flow-ID: b74a8fdc-df20-4ffe-a94c-ca7bfc8d3d2d
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Mon, 1 Sep 2025 14:05:17 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB004.ant.amazon.com (10.252.51.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 1 Sep 2025 14:05:16 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Mon, 1 Sep 2025 14:05:16 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "lkp@intel.com" <lkp@intel.com>
CC: "ackerleytng@google.com" <ackerleytng@google.com>, "david@redhat.com"
	<david@redhat.com>, "Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "rppt@kernel.org" <rppt@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "will@kernel.org"
	<will@kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Topic: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Index: AQHcG0lxZt1T5YHk+UqqKLGu1cJJ3g==
Date: Mon, 1 Sep 2025 14:05:16 +0000
Message-ID: <20250901140515.15769-1-roypat@amazon.co.uk>
References: <202508311805.yfcdeaFC-lkp@intel.com>
In-Reply-To: <202508311805.yfcdeaFC-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: kqk1yaesyd4c71iz64htrqjou3eah5rj
X-Rspam-User: 
X-Rspamd-Queue-Id: 43A01C0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1756735527-77667
X-HE-Meta: U2FsdGVkX1+T/Fyka2Wg4eaCIG442tBYNBjOuZYp/nfx9ymGzk8whzA7jYM7sNHI4wLpfb5JjsHgyyH+Skqnj43bs0XVHw4zzXivomlkYmkSYc9+JawFLNMwrr0x1CxuaLPoY7Uh6tp77OQkj3ZRs+haQx17J6FBwsgvTE27ja5h8oeJ19tlbafMhTHL72oHzwCDPYf9gZQIhepbsCSScTCGvJrcpsfvTbwTaHC7uQUMFKHiGx9mzfEdijub/94Q0jojiv7AynDhy+m+qTmVtxnWRZXz3y+DfQH1N+eF/KS7pMDE8lzW7bZZmUQB9GpCVKhDPdzES37p5SAYgPFDFHygn/1CgcYzxD5P0twevp+XBrVrRq6Mj9sUNuBLlICWRzhRq8tfQaUTXSseaRD+GWQPt0iaDnWA3aCK9Q0Pzho45EA4QiPkCh/aW0VnrXE2AuKKNrzWRp3Na+dnuxQuFVcZootYRpZK+vJ0E/O2xLlS9J+1PK7GZyTKtB4HxvdrMZVHf0VPI/X0rndt5emlEru6Q+cJMAgm994Zmu+E9X2NHhwdkZ8qSEdIGPNVwZBYH81MBJohVf5pqOojj1R4K1UMsv5TgqCGXSKRwpnLi5oML9Bx/n214OYnBtt9ZUN1bwtRgT9oquSJrWbTFdU73lZlpDAuqIPOuayl1gA5zoi25qWXiOw+cnMsmiLbh9KSuCw0vtXbF8crSaMvYtnQCg9bOMklAO9KgewL31TNFuFczKVKuG1eL3IUOVNYSD/dmARCAONuxLkhiGQw6hCV4Z0CD1ewoh1MUWEYtuWQ9rm1C7yxpgRlFvDmmqzhmZpBxRnEqyZ4qFGLBBYi+O+3A9zVhuISvBzOkOP1BLereT+Px3YjTJbvBJWv/szYFJF9g3edjQu4s29eItqrNOi3JN7JenXW1dEyv/9EgxebiiUl8S3JtHDg251T+S/e518JOAAz7ZVJbirmgw6ri+4
 UivXWxhv
 iR2wipIz1HfDGlMobiHIU8iHZ0/Nxnh1L9Ft9IuqomSjh8CqmRNxbHBf2qbZsafG198MjHB7GLoZHF8MQHKoB60ibKf1u/k+iZJiSnlklkZKSLrMt1oC8ezbsu6gO37c2pFoVEMZKeXs2Ky5fZxm/ODabwqfWThPgdU+RUm8nVYp8piwYJsADi9kbSrD+wAE2s3LSto/ixB2SbdlzlYgCyn+RHlQ0COu1NvgUeVWhrs/PzUU21jwGmsibJ4oj7kIHEVAvk+mKdqCt7FZhVRw4I7PcgmXU2OajTDNWscc8uLHsApfE89P9cnW2DbWYSaouY4v1CnFam08Mmic9e9/BHuN3ju738RMliOugqb9Mazl/q/Zikxfs5VzYIJt0n/3MG3nT4P7vT5MmGajF7mGwFIrzKZL7uX/3aW/B988gKm1tb17xmGIWkKhdi1hBdxxLO590h+PLzYBgDKJHj5Y3w/RnkSLg+ciJJWo8l+HK2CNJ0GYpIpKypOLzDSDKc+JFejvicJu6o+xErgXusyDWqlgunAdKJVyFtYKzs502cF9F28mIY3/WO7kJHcAgdsQV50lcDq8QR/KK7rW/DrqsO7jczt0ynZK4oBLZyWluNhALwdaW7EdBvkh4KrKJcwoqR5mWk9KGLeYGdjr0sZWupcM3d4q2I7iTcTkPHr+aI6hpYxyoOI8FftSk5iT/gttAPJVbIVpD6WDKt8Qa4m833uNTJH+8n79g1jH7Z9WTIk9GcRUzygsxzj503++g7WyGKgSjx8kwiqPbfpyOTDYLHj/3KwpdYdbqGfFUZvZTN3oCBt+Q6pgrkRhtWxxbMwsvwucvzoxsABmJsRwz4fUdBrqLnBq4PieK5yGl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=0A=
On Sun, 2025-08-31 at 11:26 +0100, kernel test robot wrote:=0A=
> Hi Patrick,=0A=
> =0A=
> kernel test robot noticed the following build warnings:=0A=
> =0A=
> [auto build test WARNING on a6ad54137af92535cfe32e19e5f3bc1bb7dbd383]=0A=
> =0A=
> url:    https://github.com/intel-lab-lkp/linux/commits/Roy-Patrick/filema=
p-Pass-address_space-mapping-to-free_folio/20250828-174202=0A=
> base:   a6ad54137af92535cfe32e19e5f3bc1bb7dbd383=0A=
> patch link:    https://lore.kernel.org/r/20250828093902.2719-4-roypat%40a=
mazon.co.uk=0A=
> patch subject: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP=0A=
> config: loongarch-randconfig-r133-20250831 (https://download.01.org/0day-=
ci/archive/20250831/202508311805.yfcdeaFC-lkp@intel.com/config)=0A=
> compiler: loongarch64-linux-gcc (GCC) 14.3.0=0A=
> reproduce: (https://download.01.org/0day-ci/archive/20250831/202508311805=
.yfcdeaFC-lkp@intel.com/reproduce)=0A=
> =0A=
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of=0A=
> the same patch/commit), kindly add following tags=0A=
> | Reported-by: kernel test robot <lkp@intel.com>=0A=
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508311805.yfcdeaFC-lkp=
@intel.com/=0A=
> =0A=
> sparse warnings: (new ones prefixed by >>)=0A=
>>> mm/secretmem.c:155:39: sparse: sparse: symbol 'secretmem_aops' was not =
declared. Should it be static?=0A=
> =0A=
> vim +/secretmem_aops +155 mm/secretmem.c=0A=
> =0A=
> 1507f51255c9ff Mike Rapoport           2021-07-07  154=0A=
> 1507f51255c9ff Mike Rapoport           2021-07-07 @155  const struct addr=
ess_space_operations secretmem_aops =3D {=0A=
> 46de8b979492e1 Matthew Wilcox (Oracle  2022-02-09  156)         .dirty_fo=
lio    =3D noop_dirty_folio,=0A=
> 6612ed24a24273 Matthew Wilcox (Oracle  2022-05-02  157)         .free_fol=
io     =3D secretmem_free_folio,=0A=
> 5409548df3876a Matthew Wilcox (Oracle  2022-06-06  158)         .migrate_=
folio  =3D secretmem_migrate_folio,=0A=
> 1507f51255c9ff Mike Rapoport           2021-07-07  159  };=0A=
> 1507f51255c9ff Mike Rapoport           2021-07-07  160=0A=
> =0A=
> --=0A=
> 0-DAY CI Kernel Test Service=0A=
> https://github.com/intel/lkp-tests/wiki=0A=
=0A=
This is the same thing Mike already pointed out (making `secretmem_aops` st=
atic)=0A=

