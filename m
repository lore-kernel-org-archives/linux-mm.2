Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EB54EB3625
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0C2F6B0005; Mon,  2 Mar 2026 12:33:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3AF6B0088; Mon,  2 Mar 2026 12:33:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC5D86B0089; Mon,  2 Mar 2026 12:33:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB63B6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:33:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 60F2C5797F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:33:32 +0000 (UTC)
X-FDA: 84501819864.23.AF4F977
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf21.hostedemail.com (Postfix) with ESMTP id 638221C000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:33:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=L8FDIujR;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772472810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trTsSxZrTWkQLZJIlDPSoDSBM4dbobHN9KokPDEXX0A=;
	b=ex1x9nD8xA9VKxHjuvpkmmlGym2c+zpwk5Sg3DQEjs1TFBgN28KlFlVgqYfcrfnbXY8ggU
	Uk8LRTYVS0x8b4ssNMBAWhPfF/edaYxQFt3IdC5p3/b1oIr/7ZZBgB45/N56o57W6G3UWQ
	JcP/mFvb+Pgy+GCP+IMj03mrhelERYk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=L8FDIujR;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772472810; a=rsa-sha256;
	cv=none;
	b=jmBlTVZFCsP9Mae5YjphTw0wHqO5tO6WCRAnCltqxfiSY6684a5VjnzBYbft7wpnlg/nhw
	3wofi7vb6OyYsgo24Uf1BTJaobGxsV2qoxfQWvxYibzPuvc6+WEgPXOmYhdnkw/IH8Lt+I
	XJ+JBnpRdvCuxkBdp/ijKR2hqXrkzrQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772472809; x=1804008809;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1RnLvMl4SaaPb1RpGzXgI+NG37Ip+Bl87/IC9CvyY6c=;
  b=L8FDIujRMM0FltZJD14aGXnHtLZmPOR5/KlecLDd495RwE/esDksv6dD
   xzHffSctplBqInU1mB0eqQHJAtcXPt7QTI46lvOtLBnqVFd4HhWTrrX+O
   xKdRZK48p35lPr1kJPd3fO1JlUENeON3fFsiFFNn9VD2wvEbWOkU8tkEl
   HzYiZdsY28Y+ijzn7/icV1SzLLJUCfuVxK/bo64waCkZceQaqwM0gcSg/
   Rl7shnAl2VPJ0N7fS2ddL8beARYIns0lYHswC/iDwvzU/3ctOPwX2IxEZ
   rwHrJZHuUl1UdpHTISoUC6cysAp+kdR4gE14y8V0Vpw7lQXNbl6AxfXes
   A==;
X-CSE-ConnectionGUID: fVVnpiEQRUqTrRXwAwlb7w==
X-CSE-MsgGUID: E4HsuPsST7iScdDE0gCi8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="73395497"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="73395497"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 09:33:27 -0800
X-CSE-ConnectionGUID: 0fexQWVjSsO7Q+tgjjd/KQ==
X-CSE-MsgGUID: 3p1hQa1xTj6kDEJl3/mhrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="222712695"
Received: from schen9-mobl4.amr.corp.intel.com (HELO [10.125.108.54]) ([10.125.108.54])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 09:33:26 -0800
Message-ID: <bf7d3f8b-8cd0-420b-b418-8b45bcfbcfcc@intel.com>
Date: Mon, 2 Mar 2026 09:33:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/4] Convert x86/mm/pat to generic page table apis
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, akpm@linux-foundation.org,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <20260219020354.321088-1-vishal.moola@gmail.com>
 <aaH5Z5HTC5GyJ6sT@fedora> <2fe139df-1764-40e5-983d-48d7f97c2e39@intel.com>
 <aaI6Vq-uyJ6F4P7u@fedora>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aaI6Vq-uyJ6F4P7u@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k9jzaituimb611wygropk9bbjikxmo9s
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 638221C000E
X-HE-Tag: 1772472808-218818
X-HE-Meta: U2FsdGVkX1/g7ktcbc1cW0YdZb/w3vVa13CPg5xEaH6zaZww2OmWXFMzT8NemuvBj07zhln/WSFhtvOlo8Su8nFzrRyIs6QR1jBQG12D+pfte/gyCzqJc5oBTOfpOYz3UwhLVl10uUfeSAXuHkr9OG+Nz2wGnxuEqPS/DZc9FTSHJTEwb2003pogl3heRvy47sqMWJnJqXvGi2bkrPSbhzwRtOMsi+nvFYEQaygWyv8J43GSlgj3G6xrDDm47405MxsolAboRk6YO2OFIf7IOc52qYMUErcVSpfodMp/cFM0QtKfoU80LlK0iHEivUhNySEe4+cDxy0IVWaiJY4qtrGofo4seMKeqoGhIWT0/PaK00Z2oW6PED3APRKhgfm1GgcyatVN/wRsS5ZrXSPeeYMdMGJuP7hbCl7CBakeRwtH7/IJI09cVo3SZabKluO/X9BFRmfU9BXWKLH32/SS8V6ci8xATH6SoGkPSKdRilqPjVFAvrOuX28OmiRTLaGvTkmFYCED3gT3WcgWdvewWRo6RUKphDoXLHl3TOmgfUBhni/DzFinW+XJGf98UDOFZTVDS5nWvXDu92nkFLaZoI/otaZbtkd4HpzXDvJrffMNTGtvK58pGYV9hYEYOwZooeXaw0CsUJP7HO6XK1+J2G5LbMvv2DYSlgPOhgeYQdp9WCevMmWcbhFrLalHVKaE476sZCRGcRsYMcAU3YrBfBv0ycVhOdOpdsuWiVVCLCrw1kIaEqZxjwEG3kCrJU54vOxfWbkTJhnXM5H4NJezULiHDMXDdVuxJaDvq/YgFKL5ir0GVPzxwulESx2LHTZLZqXfHbfT8gDDsJbHCO1E/UwvHYzCO0LgT0YbsuY4Ip8/b7SrWhTdXbptkC/w0PCzZydtuQVFOdP3b1ifzfXHTlO2mUreqSVX/oY5sUYdZ94sXnfzRswFzHlKwPHQtej8q1+oefMuNsU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 16:44, Vishal Moola (Oracle) wrote:
> On Fri, Feb 27, 2026 at 02:24:33PM -0800, Dave Hansen wrote:
>> On 2/27/26 12:07, Vishal Moola (Oracle) wrote:
>>> Do you have any more comments for this series? If not, could you please
>>> take this through the x86 tree. Thanks 🙂
>>
>> From a 2-second glance, this doesn't have normal comment style and isn't
>> using imperative voice. Quite a few "we's". Looks like it needs some
>> more eyeballs.
> 
> Ok, my mistake on the comment style. I'll fix that.
> 
> Sorry I'm not the greatest at imperative voice, I'll pass all my comments
> through AI to convert them all to imperative voice.
> 
> In regards to more eyeballs, I've realized I didn't cc ALL x86
> maintainers. +CC the rest of the x86 maintainers and we'll hope
> someone else looks at it as well.

I was actually kinda hoping you'd be able to actively go out and find
some reviewers other than the maintainers.

