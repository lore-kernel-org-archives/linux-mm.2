Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB5DC87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 07:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DDF16B0088; Wed, 30 Jul 2025 03:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38E7A6B0089; Wed, 30 Jul 2025 03:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5526B0092; Wed, 30 Jul 2025 03:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3506B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 03:52:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B87C11A0250
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:52:34 +0000 (UTC)
X-FDA: 83720163828.23.244E15A
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	by imf06.hostedemail.com (Postfix) with ESMTP id B5038180007
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:52:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=tHoTEQpc;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf06.hostedemail.com: domain of "prvs=2993f5a26=acsjakub@amazon.de" designates 99.78.197.219 as permitted sender) smtp.mailfrom="prvs=2993f5a26=acsjakub@amazon.de"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753861952; a=rsa-sha256;
	cv=none;
	b=Em7T0FfE7EKC9WvjIhr5D3TimqbPnjcPv7VmEYZPOh06wrCZ+zDiYqGT85ni0NNwgCtT+o
	Oao9fuH2NFFB9bo72KDrpAidjrZXmzI/JIqanGP8CaoDxnNisxeSZM1UH/wvtH4Roobx9G
	9bkKIBVgZR6XJDP4YmKCs5AVatirXEw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=tHoTEQpc;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf06.hostedemail.com: domain of "prvs=2993f5a26=acsjakub@amazon.de" designates 99.78.197.219 as permitted sender) smtp.mailfrom="prvs=2993f5a26=acsjakub@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753861952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ewmKg2qydsqsPsmwmuOE+1zussXmQpRpngogWAjgHX8=;
	b=2yQ8FXpJ55bPnzuUW5Kl9hjX1P5Q3WVLnXOecbGp7aopnUVaDvzqDoNR8I9WE7vpYeomTH
	qCH/nwA5MWOR9mZXq6lB2iRf68icLqEi1fwrG7XbMheIIijFDNzd3vtrmVkb+XpO/O9ZXO
	9ntPXWo987khB7EarPiC0HkWe7tRpJU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1753861952; x=1785397952;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ewmKg2qydsqsPsmwmuOE+1zussXmQpRpngogWAjgHX8=;
  b=tHoTEQpcMpxAJH8kTlOgA+dowGj4ZP+N2qD1igBOOJuh3guI1uhq1Z07
   bUM0S4m/Q7lOHju4pbCtR+EtrzqT4Pv3RQoZkbCvdQhOn3YitB+tHyyVh
   KEE+8oXQpJUzHCtZSxYdzVSWzf+gXLaul9/te5O2o8XT8t5OgVTbGeHaQ
   oVP78e4PCTR7OzDcfxQGIWxnI8FbGBIgyDjlbozUe7l+dS0h02H55ofar
   qBMz/awAHC1gmYuShpjeBcEcMuN2KloNfkQadD37zJm3xdy2NuoKtU8lY
   gIdcL44hL4sPepZ3/6r6iXhzdt2thpnYCPKOq6I7VjToXiTeVPRg9fpBh
   g==;
X-IronPort-AV: E=Sophos;i="6.16,350,1744070400"; 
   d="scan'208";a="218293529"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 07:52:30 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.38.20:12002]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.62.141:2525] with esmtp (Farcaster)
 id bd670100-5b4c-4039-a6c9-e56ef9592578; Wed, 30 Jul 2025 07:52:30 +0000 (UTC)
X-Farcaster-Flow-ID: bd670100-5b4c-4039-a6c9-e56ef9592578
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 30 Jul 2025 07:52:30 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Wed, 30 Jul 2025
 07:52:27 +0000
Date: Wed, 30 Jul 2025 07:52:25 +0000
From: Jakub Acs <acsjakub@amazon.de>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, Liu Shixin <liushixin2@huawei.com>, Yang Shi
	<yang@os.amperecomputing.com>, David Hildenbrand <david@redhat.com>,
	Chengming Zhou <chengming.zhou@linux.dev>, Johannes Weiner
	<hannes@cmpxchg.org>, Kefeng Wang <wangkefeng.wang@huawei.com>, Mattew Wilcox
	<willy@infradead.org>, Muchun Song <muchun.song@linux.dev>, Nanyong Sun
	<sunnanyong@huawei.com>, Qi Zheng <zhengqi.arch@bytedance.com>, Andrew Morton
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>, Jakub Acs
	<acsjakub@amazon.de>
Subject: Re: [PATCH 6.12.y] mm: khugepaged: fix call
 hpage_collapse_scan_file() for anonymous vma
Message-ID: <20250730075225.GA39475@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com>
References: <20250729090347.17922-1-acsjakub@amazon.de>
 <2025072932-scorer-manhood-b6fc@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2025072932-scorer-manhood-b6fc@gregkh>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D032UWB003.ant.amazon.com (10.13.139.165) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Queue-Id: B5038180007
X-Stat-Signature: kwurtdoig8h31538944jzjxq6zn47i68
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753861952-577564
X-HE-Meta: U2FsdGVkX1+iewG6rZoEF4XkZVNTi93JPmrE3RdniYac8iJd+P2Ks2Sx+GjQmoKvJ9KRbhK8S29MjNf1i88tJkcziBGYU9seTLUzqPABjpXJbodmCUsoIUtPiXxTQHbacQTeGRuVsdjgj0IBcJki3wZYEpgLJtdX3PVk4FHQahGgRGhxFnXN6Lvkql2ic79sadNCGne8Li3UqjA1U4gfX8mQZ1ECSqzlnts/8GNXUKJuanVQXea3rTKQVX7WVpewRVLtBcJHLVp4WEyS/PXuFPU0lJ9ediyiem5Lw+6oWJU4Fo97YA3ZyooDPLNgA8fDRiQiynJi58oiuH/c+45pxLv/RRi7FGtz4jpReEQjeSqyDS0s7cB85hix2ZSLCcgIbc66IZhI/uG/RO5n2Ern9QexIhLHPMfwsRzq4/lIQO52Z/Pd0JhYhHF+18ymxb6UR/Xrx0Dd5RiDLWN6x3TL3w7/F5MmQT69+gOFhpdQygibvYiU5BtyYNcgvrsJz7C/yZEcnPtr3n16apfGxB5A9lehe1kPvlLoUyH3xtJUmS4bnJZLRZFeuQsHjdv3c6BcC1RIJMueUsKogJIkAphQmPDCQ7OODCgEfspHfV77Dnz13xUcAlHplZ8omWOZKAQggp200e0Eq/T75MtYVrdRuRJlRzzlc4KNKEK7+SRTlN8er0By5WnLoLSVXke+F3zC6ye8L1zP9k2SC1488l2tcTLAcCHOl/AjgID7LS2wy3dhHTexUQ3a3RRp8Lt6j6zMNIlRGn6T6usCxY1dseHPOz9qqSGcahm9lueTcvxGBZo81BcQ0S050We1PlfL7f1JbQtMxeZYH2FZCTkLu4nbW29Ytw8TD19vDv5BqP9A9GP7JCKpC4RxRbcrdATr7NuKcTxKygNXfxSC4ATVyOEx87Hdbc4wK1iUAIdGC9feRbyo5sIo5cnY0x3lVtK7960rbe6j/F8/2/NsroVlxe4
 XoEon5b4
 DwUYfbigzoz7y/no+KJcWN+DEVDXmCRx21jkpxNPitmFsKVR4mnnl5cS0LRblSEyGkPPQqMBOW0XtjRP5NEGVdsGafV0Xns5l7lRzWzsdUMT9nF+I1myNqVI228SF0Cuhqn6Hub1kHdWGY4M/NvEVW3nCUE3A4kJWYGnWYkn8GQ9tE8vZyd1ThK7kqeNBBY2mS/a96vXxK/jnuRp8KFwntxP5MZtXqsNISOE5dvIIRrEGaOeMviJ+e8jAquR9ZWseKyZewhBb53IfYGHvvt8WHfAXfVJ+MN7myOH6h3GZ7/XyoQj3/2I1kLkGJk040882pkJtgC6Yf3FN3ujd4B407cIgU7BBYz6IzLCBJK84a6nVQcJfvZYneTaHJWtsxGajyRlOXgmLVWEFdNXrnZIW+5pv2BnxRbbfBk3x6MerLjfx0ljARFpNFWZ1GQfZFe5ssTZDbuq/NpLrdcvYu3grm/2mWuuVHDcaUqMM1XMc7Ktn2d0jVHjYfPY2WLppCPe+q4gIdrFhHpcy7ORVc5OPvz9Ayo8Gwgz2NU7EI3FBb6o6qrrpk/oZcKMlLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 04:49:51PM +0200, Greg KH wrote:
> 
> You need to sign off on patches you forward on.  Please fix that up and
> resend all of these.
> 
> thanks,
> 
> greg -h

Oh, that's embarrassing, my apologies for the miss, sent v2s:
https://lore.kernel.org/all/20250730073927.27312-1-acsjakub@amazon.de/
https://lore.kernel.org/all/20250730073956.28488-1-acsjakub@amazon.de/
https://lore.kernel.org/all/20250730073945.27790-1-acsjakub@amazon.de/

Jakub



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


