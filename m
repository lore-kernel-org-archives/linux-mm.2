Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEA2DCAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534508E0006; Thu,  2 Oct 2025 04:03:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50C3D8E0002; Thu,  2 Oct 2025 04:03:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FAC28E0006; Thu,  2 Oct 2025 04:03:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 28C2C8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:03:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E150FB8B85
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:03:14 +0000 (UTC)
X-FDA: 83952433908.16.0F13138
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf30.hostedemail.com (Postfix) with ESMTP id CD9E480011
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:03:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=Y0xQFQ8R;
	spf=pass (imf30.hostedemail.com: domain of "prvs=363256128=acsjakub@amazon.de" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=363256128=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x6O6oMw804oQZ/Ro+shkMBMYGI7avV6WEQj7MYFI3fw=;
	b=8cx6vpCkOOafPzc7aESqol/bkoJbwzI2Apj42aLlCVqnlem4iBGAvDd9wlv7D3VIvNdDa8
	K8ZUmwD/FdiuwiWUuJj9l4Vnv/C6uidSALfg9wCEOaV8abTyXW6XigeDZBrxpB0TGoqXy/
	cAlA3X6ALxXG0biBq5sxvWJYamEKYGs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392193; a=rsa-sha256;
	cv=none;
	b=mMFRJ9V9mMGDV3NUxuIheuWrRLzwOcJfj78o7AQyfuo5Sq+gCS9PR4kU2z8fYpUNzTa5Xt
	o4bFwhkmrK1fhuYWYRgivcsAN8C+H3oU6cOzVybTQ3RHBvmBwhpIjJOfFK69WkByVy3V0Y
	RmtVOiD3IM7DudmkkhIZztjK+DVbAEk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=Y0xQFQ8R;
	spf=pass (imf30.hostedemail.com: domain of "prvs=363256128=acsjakub@amazon.de" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=363256128=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1759392192; x=1790928192;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x6O6oMw804oQZ/Ro+shkMBMYGI7avV6WEQj7MYFI3fw=;
  b=Y0xQFQ8RHwyn0dm35FSbRP299GONxExJBNErnxbzzRLRSfj55p+UBwa6
   XpQ4q8kZBudbJPnwYjgb7ZV6k6BXqDQfWhkUKttW/DEHTYhYXXfQ/WUnR
   wO6Ys1QDt+fDzpyPeeypXc7Kv3a2mUXfFw6LAE3MBk7onmxq5u1jtWLZu
   HENL53aL6cTeIL43Zemx5cH0fSAbi6HU5G6QeGx0K2aIDFaJdYwLnszqi
   QbGw63w72u1+5sZfIbsZbhcfpkxGfu/FWAOiHnak0NxMqDMQShlmp/smO
   Iv/pslFru1L4zrKJFlxMVaX8MPSpbUmwBRlEQTU0pp8gA5ivcXr2Bdgh9
   w==;
X-CSE-ConnectionGUID: Ysj+1pBqSMCNFcJVNcJ0XQ==
X-CSE-MsgGUID: mqx+7wp8RzKMOARc/pMxug==
X-IronPort-AV: E=Sophos;i="6.18,309,1751241600"; 
   d="scan'208";a="4126945"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 08:03:09 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.38.20:14480]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.2.125:2525] with esmtp (Farcaster)
 id e92ed99c-d82a-4e10-a994-20eb525beca5; Thu, 2 Oct 2025 08:03:09 +0000 (UTC)
X-Farcaster-Flow-ID: e92ed99c-d82a-4e10-a994-20eb525beca5
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 08:03:08 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 08:03:07 +0000
Date: Thu, 2 Oct 2025 08:03:04 +0000
From: Jakub Acs <acsjakub@amazon.de>
To: David Hildenbrand <david@redhat.com>
CC: <linux-mm@kvack.org>, <akpm@linux-foundation.org>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <peterx@redhat.com>, <axelrasmussen@google.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] mm: redefine VM_* flag constants with BIT()
Message-ID: <20251002080304.GA26368@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com>
References: <20251001090353.57523-1-acsjakub@amazon.de>
 <20251001090353.57523-3-acsjakub@amazon.de>
 <98cad9a6-875f-49c2-99b2-389bf4fd9b55@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <98cad9a6-875f-49c2-99b2-389bf4fd9b55@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D032UWB001.ant.amazon.com (10.13.139.152) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: nwmoh54gmofjwkzdte5rqrcubmnn6his
X-Rspam-User: 
X-Rspamd-Queue-Id: CD9E480011
X-Rspamd-Server: rspam10
X-HE-Tag: 1759392192-728901
X-HE-Meta: U2FsdGVkX18tdOE6GrmEH3S2NipQPurUhC2Hygc5Mne2wPk6F5YbGdjSNobkkM+oKhdIRzOSSk2EVvZRn/SLaUjcAxER2RW5CVWrosIQGnWuytgHWORiu/3ylwq5cHjiuAK3LV42jZoX3NooeQmwBo0hSnxwhk27/ann2T5PRcig2FajJi96zMueNAVfu8yGWru1JV5g7fkvAb2rMRRLc+bpYhZnDZTaTWnIxEPS0JGEPT3o5k3O1EmVxmAkkbP6Av5GkvUfMpPNsb5cqM6X/MW+Q5yh0P/KfNqJj3it5AczgQdEdlCfg6kOZ/9jt9K90oXnpQbfqwFCMAe1o0087EV7C5I+0IZA2wvfl5F9aMbA+ibaBnRsDSAnfx2jt1VWOlnVvPiKkPckWh+l5cUCySHsMwkXeenCApFMltmrmDOIOCiqlcLgYwiu4+nMnlXLBQy/TDEY4I5u0dAo5LV4IhRY7ISIxm/tMfPEeredOGydcJTiPtjw47koV1AEBM1u6+IWgXO4SzIh78O7wpE5K+2YZYBVoa09JY/k1dSvftbTaH9HqqyXMTY6NubOVg9gIGThcqmR7UsQyzGp+N8GaB9QpdXyAwlwxwE1jJVUiU3DTI9vVEjKEl0SZ0U+94aFEOQ1+moRHGxfH5iy7IVzHApwYHaiNMcwA5KA9YwAd07GtMDEqTzZ5pgp1PX/uo6XC3U8P4IgXkmPNRbWmMXQOfbsb9M8+UjALFnrAOhCVyLiznMTs0zzE+/8GejNas6jhUoYaKaQN49FdnR3294vlQuLusI+BvaNG02g8y166/uHGlUYCPbn2jCWB3TzBi8baH1/vTBEZae5OI++/28ixvlXpAmNh4617vkXDRq5kypCysE/0ygGcApbMkYmFCbLK1kHS+eJNX7oG2RcDT7Fne1kgkL7aal3E7DoMMYhvaLXoHqp5fdX2MqWZl0keoXWUyxFBaY7Hu04SNj1Ubq
 xnpYBes3
 SjnS02PGpVkfscc0ycBTOJYlRaamdy7xvIgvx1Z5SVr1kUTKz8SjFznbGSwzU67FdixB0Xx2sn6VzPJZLOMyzA0wypN1ylPT+lJoy81699iFFao5S7Aa9sr/esRgEceZkNfkLB7uZsV+N9hWJE7ORvwBd4sSKtiWb5RHw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 01, 2025 at 04:04:51PM +0200, David Hildenbrand wrote:
> >-#define VM_GROWSDOWN	0x00000100	/* general info on the segment */
> >+#define VM_GROWSDOWN	BIT(8)		/* general info on the segment */
> >  #ifdef CONFIG_MMU
> >-#define VM_UFFD_MISSING	0x00000200	/* missing pages tracking */
> >+#define VM_UFFD_MISSING	BIT(9)		/* missing pages tracking */
> >  #else /* CONFIG_MMU */
> >-#define VM_MAYOVERLAY	0x00000200	/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
> >+#define VM_MAYOVERLAY	BIT(10)		/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
> 
> Careful: VM_UFFD_MISSING and VM_MAYOVERLAY share the same bit,
> depending on CONFIG_MMU (9).
> 
> >  #define VM_UFFD_MISSING	0
> >  #endif /* CONFIG_MMU */
> >-#define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
> >-#define VM_UFFD_WP	0x00001000	/* wrprotect pages tracking */
> >+#define VM_PFNMAP	BIT(11)		/* Page-ranges managed without "struct page", just pure PFN */
> 
> -> 10

Ugh, thanks for catching these!

> 
> 11 is actually unused IIUC.
> 
> >+#define VM_UFFD_WP	BIT(12)		/* wrprotect pages tracking */
> 
> This seems to be correct again.
> 
> 
> IIRC, Andrew prefers not mixing fixes and cleanups in the same
> series if possible. So you might just want to send out patch #1
> separately and, send out patch #2 separately with a note under the
> --- that it depends on patch #1.
> 

I saw that patch #1 was applied so will leave that alone now, but took a
note for future.

For completeness adding the link to v4:
https://lore.kernel.org/all/20251002075202.11306-1-acsjakub@amazon.de/

Many Thanks,
Jakub



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


