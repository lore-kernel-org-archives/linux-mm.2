Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD4F0CAC5A8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 14:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F4CC8E000B; Fri, 19 Sep 2025 10:42:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CD098E0001; Fri, 19 Sep 2025 10:42:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10F918E000B; Fri, 19 Sep 2025 10:42:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0F788E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:42:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD84F1606E3
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:42:06 +0000 (UTC)
X-FDA: 83906264652.13.61D61F7
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by imf15.hostedemail.com (Postfix) with ESMTP id B7C68A0006
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:42:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=microchip.com header.s=mchp header.b=G2DwRoqW;
	spf=pass (imf15.hostedemail.com: domain of "prvs=350b08d43=Nicolas.Ferre@microchip.com" designates 68.232.153.233 as permitted sender) smtp.mailfrom="prvs=350b08d43=Nicolas.Ferre@microchip.com";
	dmarc=pass (policy=reject) header.from=microchip.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758292924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8ldK24AiwNDLcBYNMI6Cuki6eZBDjdQT8mYCvvECmw=;
	b=Bt7I7gnB1QsYIkRZyY7s/FmfsJZgHQRg9JtYYpfyegyL3Ri9vnfVX2M318JjgjjF/ZuS7o
	ZwAI0AgrZ0rL04E/BCYr+izCkEkCS6wvMOGXlW7kfvd0yghvkZKluw47sRr7FmHqKKId2q
	29w+ZmKzZR3K/NUebR0+SAcuzOObYsk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758292925; a=rsa-sha256;
	cv=none;
	b=ijPBsKLc3ekWieL8RQrXcrm3MbPMXN24Bt9GOComrAuJ8jziQOileJVZtZEaAAjkhtxYHA
	GUyO9c0rZRmX2vHf1gVDivWOywdzzUD9JIcFfod2jKW0FvnlF+Ltk7NnHYEdNi5TNtMR9W
	KdlB31mXzk0zPxA1+sCYyhxSVV/QSQQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=microchip.com header.s=mchp header.b=G2DwRoqW;
	spf=pass (imf15.hostedemail.com: domain of "prvs=350b08d43=Nicolas.Ferre@microchip.com" designates 68.232.153.233 as permitted sender) smtp.mailfrom="prvs=350b08d43=Nicolas.Ferre@microchip.com";
	dmarc=pass (policy=reject) header.from=microchip.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1758292924; x=1789828924;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BUXNR1hckyrk8jBBQv+MEaTsb/Yxf7QPZcopTVXtsc0=;
  b=G2DwRoqWAFwBoeiHRW1PnVtBdkifBZ1fDCZYhjljRvAG10hTiyDtoaMm
   nVcvcUxm89ol5y5wO8MIGUwm4xR32rrdIIU/AC3D53XJ+o+uDcEHowrUJ
   /2Cezw4LW9el7AD1n6rods7WJpDafF+ZMP3id8XYE1XkhV/14uYSfydb3
   y9/j1K/spGAfBpKUewoyEqGBvZMFuQoTfJB2KmPagCMtMJm+uzFfIH5Kp
   Qe48WopOgTVvDZLpDD+/TSUKtDyaAHChh7QWG/ebYkrQaGPYLIlXdluUz
   H0oLzljSE8xSBBoOLPKZuIMBRU1xXomaMTMysJvHwkP/c0OpCOch6VFAK
   w==;
X-CSE-ConnectionGUID: rCtXrXuCRuWl+rA3xsHEKA==
X-CSE-MsgGUID: EJ/u+s4TQLuYDQ4Fe3Jepw==
X-IronPort-AV: E=Sophos;i="6.18,278,1751266800"; 
   d="scan'208";a="52617186"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Sep 2025 07:42:02 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Fri, 19 Sep 2025 07:41:32 -0700
Received: from [10.159.245.205] (10.10.85.11) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Fri, 19 Sep 2025 07:41:27 -0700
Message-ID: <cc027fae-8d34-41ca-bd35-569c415fc657@microchip.com>
Date: Fri, 19 Sep 2025 16:41:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
To: Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>
CC: Jason Gunthorpe <jgg@nvidia.com>, <ksummit@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-mips@vger.kernel.org>,
	<linux-mm@kvack.org>, <imx@lists.linux.dev>, Christophe Leroy
	<christophe.leroy@csgroup.eu>, Richard Weinberger <richard@nod.at>, Lucas
 Stach <l.stach@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>, Ankur Arora
	<ankur.a.arora@oracle.com>, David Hildenbrand <david@redhat.com>, Mike
 Rapoport <rppt@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Ira
 Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>,
	=?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, Alexander Sverdlin
	<alexander.sverdlin@gmail.com>, "Chester A. Unal"
	<chester.a.unal@arinc9.com>, Sergio Paracuellos
	<sergio.paracuellos@gmail.com>, Andreas Larsson <andreas@gaisler.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <20250917125951.GA1390993@nvidia.com>
 <02b0f383-1c43-4eeb-a76f-830c2970b833@app.fastmail.com>
 <CAMuHMdVecUeLZ2LPpa457C0a=uduvDhQ4KZJx-++dEFJraRi3w@mail.gmail.com>
From: Nicolas Ferre <nicolas.ferre@microchip.com>
Content-Language: en-US, fr
Organization: microchip
In-Reply-To: <CAMuHMdVecUeLZ2LPpa457C0a=uduvDhQ4KZJx-++dEFJraRi3w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B7C68A0006
X-Stat-Signature: jb7iwzr8m79gbgimagzmjaasunatdpai
X-Rspam-User: 
X-HE-Tag: 1758292924-537388
X-HE-Meta: U2FsdGVkX18izVd9LR1jfyKGAck06SZEdQL1z8138uvypujraQyM+ZuqkMvtQQZyU3H/S/y+PsMsvzxuOESjzxHXb94EauNoqCsJjuxw2D6Tl5m0PnXAesE5IKdN9TRnHZk2yMidtWUYdBqI0tlaHLTOFupGdTI5++kwSxJD1Ur2DII7Jnx00rVyI3dLObyPnAoiKt/txrMdjpxlmfPzJjW/OCygnWyaJw0ZKP8hXYTACPBliZX3XcDJBMjE3EqHLrxAyLQBGcOET81rEixqFHDIRAAWA8PqYr5UL8Z1NjndoTpLDURycy8Je5jdzW7xDPUvRZgPYuz2W3rzW2lEEEkWU20mQqIxWa2A7eG28ZNMfLAphAltQV4yVZSlTQthFOy67pACxYjO3NZ07Zcd7Dq7ptufItdwkc5OztU7YDOVtJI4JmTeBVAYN9GQsYI33g6F1gqgMM1gKra6AzMx31QaZamrwRXEmzr+kkIyST9AY6ONYETx3gW1RFqSFaFDHY65P2eHOZynb/1m/O8rSvIbSysZngqlxGQ4jgeMTH887j0dUucO/Yaj+1taOm8rbSih9bKLsUANPOv+mHLBNJyauE6r/NnbEMCMOIgy/QldCCLXt7OUCfx6YmnLaYHmlbioLsorE2gETKQOOV4DEZw59QJdA+OtquBVd80QmB6a1HV/3ltNAcZaMuV9g8v/g4p203pDo+Yt4AtSwfetDfW2NXJXCwYuabqVUcLHay2GgWSRMEi/h4cCBkxxmjdzeZBnAXV6vCr67hSOWN7i+wMAYC8dkX1A4VkvtytyV1I7M0byuYg+/gx4mAbkiWlGPK+0F9+dS/8FqJfKAG0+FDZtMhHgyvja1gnR/iV6C8j5lVMNlgoMNfkpUjCFz8sm7ZKAijeqwb6rkOE5qU7ieheT5fxDbQin9C8zPj4U4MPA6mr8cIflNIXtx4s/hDvfnm97I1VOua5aKo/Iv67
 uWjy6i2L
 1BMALCBFJY8EF7XH+lGgyNGU2wBZCiTr/y5eTk2Tk91/MMfdC+Zm61MUCDTv6JFOjU+dAbvGjeovLMULjYrnk6vNaK3d/cLNXrNn6UP4AgBGbvx/SMvYSpfs00uVX1Iphhl9YpZ+zjz5g6QXKOrj0VR5Q6kWco2j4t7FRty8QIyQJ63mFnaZIw0cqIIh7QKkPxhDToru+5nXW536hQzyRBATnr8vFdJZQsY0MjzLFAtSB3t4B0u/2W2ZQ0Q/MZ7HB+3sWMUyS138YYl0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Geert,

On 19/09/2025 at 09:17, Geert Uytterhoeven wrote:
> Hi Arnd,
> 
> On Thu, 18 Sept 2025 at 15:13, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Wed, Sep 17, 2025, at 14:59, Jason Gunthorpe wrote:
>>> On Tue, Sep 09, 2025 at 11:23:37PM +0200, Arnd Bergmann wrote:
>>>
>>>> I'm still collecting information about which of the remaining highmem
>>>> users plan to keep updating their kernels and for what reason.
>>>
>>> On this topic of removing some parts of highmem, can we say goodbye to
>>> kmap_high_get()? Only ARM uses it and only for
>>> !cache_is_vipt_nonaliasing() systems.
>>
>> Good idea. I think we are almost there, just need to verify that
>> there is actually no impact for existing users. I already knew
>> that there is very little highmem usage on ARMv6 and earlier, but
>> I tried to recheck all platforms that might be affected:
> 
>> * Microchip SAM9x7 is the newest ARMv5 chip, clearly does
>>    get kernel updates, and the only one I can think of with
>>    DDR3 support, but seems to be limited to 256MB total memory.
> 
> Are they limited to DDR3?

For sam9x75:
- DDR2
- DDR3  (DLL Off/On mode)
- DDR3L (DLL Off/On mode)

For (older) sam9x60:
- LPDDR1
- DDR2
- SDRAM & Mobile SDRAM
> IIRC, someone (you? ;-) told me at ELCE that Microchip keeps on spinning
> new variants of old SoCs, to accommodate the changing DDR landscape
> and market.  So perhaps they also accept larger RAM sizes?
No, in fact we address 256 M Bytes max on sam9x60 and sam9x75 as well.

Regards,
   Nicolas

