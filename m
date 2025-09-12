Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 258DACAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 16:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0406B002A; Fri, 12 Sep 2025 12:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6615E6B00A4; Fri, 12 Sep 2025 12:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527806B00A5; Fri, 12 Sep 2025 12:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF046B002A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:49:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF96B5BA6F
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:49:46 +0000 (UTC)
X-FDA: 83881184772.27.74BA0EE
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6F7891C000F
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:49:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=microchip.com header.s=mchp header.b="z/Bp2ta5";
	spf=pass (imf20.hostedemail.com: domain of "prvs=3431635e0=Nicolas.Ferre@microchip.com" designates 68.232.153.233 as permitted sender) smtp.mailfrom="prvs=3431635e0=Nicolas.Ferre@microchip.com";
	dmarc=pass (policy=reject) header.from=microchip.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757695784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cnmFDlEOsmIEfqMrpAweTNFX9QftyJSBrntOrKfce2w=;
	b=WvGHpEvEo9FB7H9cIBu7nsUmsmKCM6Jnfnsg1tLcEMBSID8Dv0+KpavX5XSut+ondX8JjT
	cCkIDNJc6U78YKMHUEEHYTRBVQqh1qeX160sxJp2SPfuf1p83vozie/YR0o4ALGb6dTI46
	7B/jOaSDaEskNW49hubpSDiG47Sq7NI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757695784; a=rsa-sha256;
	cv=none;
	b=1hF6C9cOH06mMKeOd0CkuQX5VAWDrGxpFki21Q/KrWWk0y0wOLJt0AErJ0RrSWSGFfgGp0
	NRSpyJRhmXQ3yaBmNLowAMxIu5gIntgYrvTcqiZ0gl5DehY/bkwskuOGMVyYzlfmIgChBK
	ZE15iPD37aWIVH8xgYjljmTgtH/Pi7s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=microchip.com header.s=mchp header.b="z/Bp2ta5";
	spf=pass (imf20.hostedemail.com: domain of "prvs=3431635e0=Nicolas.Ferre@microchip.com" designates 68.232.153.233 as permitted sender) smtp.mailfrom="prvs=3431635e0=Nicolas.Ferre@microchip.com";
	dmarc=pass (policy=reject) header.from=microchip.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1757695785; x=1789231785;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u1apkPsXybe68Jt3zrIWLyQZ7H3ZjR0gWhhluRQrN3k=;
  b=z/Bp2ta5KHcG5dl1LZVjVrXnqozabOTOwL9uTjgILmb6BWP8owpWrcRC
   L1IprKG7JnS3keKo7QfCm988c0w4H88eqG14Vun9B0knsuXiQF99BCunb
   PC3XuWuf2hQCO24cga2D8jYE2X0NLd4mvp8BSGOY4pBOJjIbe0YmtzqwT
   aI1oLT/cb8Wi46ZfYTh2AZ5JPfQlrwjz4q85+EGL7X+x8E4UOXe6wiKc6
   5CBi7arvShMj1zcqOdJ1qCMoR8zPgoLwli57u6D0Dr1PIPit/oWLCvRWo
   w71zcBdkVAW3iWmAfYLlMXxsD3K5glAV4FPjJJmu9olMBX1byNMp7FFNX
   Q==;
X-CSE-ConnectionGUID: s3gPgfU6QPiurXqxeBySFg==
X-CSE-MsgGUID: 0XiE5fKtQqWtnhAnsP3idA==
X-IronPort-AV: E=Sophos;i="6.18,259,1751266800"; 
   d="scan'208";a="46433595"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Sep 2025 09:49:42 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Fri, 12 Sep 2025 09:49:38 -0700
Received: from [10.159.245.205] (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Fri, 12 Sep 2025 09:49:32 -0700
Message-ID: <f931da29-5f10-494a-acc0-309bd805d41a@microchip.com>
Date: Fri, 12 Sep 2025 18:49:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
To: Arnd Bergmann <arnd@arndb.de>, <ksummit@lists.linux.dev>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-mips@vger.kernel.org>,
	<linux-mm@kvack.org>, <imx@lists.linux.dev>, Christophe Leroy
	<christophe.leroy@csgroup.eu>, Richard Weinberger <richard@nod.at>, "Lucas
 Stach" <l.stach@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>, Ankur Arora
	<ankur.a.arora@oracle.com>, David Hildenbrand <david@redhat.com>, "Mike
 Rapoport" <rppt@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
	"Ira Weiny" <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>,
	=?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, Alexander Sverdlin
	<alexander.sverdlin@gmail.com>, "Chester A. Unal"
	<chester.a.unal@arinc9.com>, Sergio Paracuellos
	<sergio.paracuellos@gmail.com>, Andreas Larsson <andreas@gaisler.com>, "Mihai
 Sain" <Mihai.Sain@microchip.com>, Alexandre Belloni
	<alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
From: Nicolas Ferre <nicolas.ferre@microchip.com>
Content-Language: en-US, fr
Organization: microchip
In-Reply-To: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 538zgonfbufoouc4yxpozmtn9gwkfzui
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F7891C000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1757695784-594333
X-HE-Meta: U2FsdGVkX1/LmK7smKyAXxv5+nDIzwyO1EgMqjF5VXDLS/t+7HLD/2W8GffewHm5fT4o/QTXAPK686fy/lhV6XI1/ry9nXSY915ul4AktHCKJS2xKqzkdmA/gp0YiYEJ5KR8+GORHqnmsmf0FgR1iBHFhdXXZFFAT9mEZyZW8/21/2u8FEBbRrVazLvRjoCExlJFsOXLpc8YKiRdpeGHsSEx1SkCsa0KkmM7af3LRNqNQGkxdvBTMl26AW4uTgYltGieMn+RY0Df8d/nZFNimtRGwklbxDKumSOX54LUp3VC1I7BCaKq//fpRrU2X5ivyaMm9hkSDO/wgI1T6SNAK/oupTxhsRyZ3m7zCg4V44kCQBUA9CAwFBgtFbrTxYGc3ICzQAnHP5ZfJDHD47tPZ9OgcFz3Wuc0pvWhLnPY9IBEgNTVCVWADG0mcKlj969XQDyA7KD+xbkJ4u1pZ8jPHhnP7taeEoD4J2mSmJUX1zaYWmzMbVT57kSNE+0U7w4acvLrA0Y4PNupQyTyYqIJb1uMTlaflDUNjgVDbnYlZTnrPk/Ev23zeNRqwO2mvYvhYOegVR/DA5aMxoSOLrIuPYISk7ofj9B6YpTmpCE4JjzfWTrHGPbsfCFBbaoKO3KXtxWG51vE8vPl7ULEa8eS3bMSKC8MzMejOPI/RcNoBU5/X8yfkGPfZSpzNQwWFTFz1LvWIpoUEhPwnb77xOM5IAGJoclkCkpuqWajeR+ibr32mHA87WhC7pVia6s+GFJ1VuOs1gT+VB92ra0Ck9KJm3UM9KwHOJ5pVXn8R0kZoJur3e5/aFrV/pu4qA6A69cB0WR2vo4gnem80eLOpZ+BrozF93yMbi8aWj6x93h/lDKAs1T5oK7JrH41Ea0P9pLdg8GILQ+PdUKpACBXXgRuQm5MnMLMmjTVedLzrITc4z7ZCMx5UsMBZ8aIHHCi7kk69ftS4u7oQwzp5QRZTv0
 REPxDWsd
 ybh72XCPisDQQFAwFHiKZF6KatAwZjDfBd7qmV/GOauYxe9d4B1yYRyyhj0MbtchCdh43CLgsAQM5C2IHJ1biu738YqnEGNjIa3PTAXShFOHfIhhTX1qhO5Tol8bFrQR43XI+eLrcu2UGM0rnQG9l2FU3Q7Fz/oi20JS/RsZXzp21nIMbcYAeFmgsNUdlUiB5mLZQosXdqZBs56Be3vDrflrdo1gHDsqvzZAquu/lQgsURBN/Tuh/n5TqAnJ3ns22N7wn9oSVKc3pxY9cxVgi4EstTanQZNyXc8F62lkiXrqDOJJc72ACb7Y3vjNHNcbDdOnWh1aPIPguKV4MUhpSYNgfG8iX+9Ij4rlzrns2YcSQMBmUsBE7GpUjzWAwCrxiVYwKIhnA549KawGU67ckBkgnpfpvLce3WIMUL/cryii96YaiUm4f+1NINBGvdK1lnUQVC5JBs7EP8n//RCCrWIfut4Nb5te5KQqBeRMFgB2obudHMtto0Hq8fzXeZnHfZjt5oNP5vaQq7+KwS8Bgx72LbiZigP2YRBBhx9sghbfJs0AYBBanuJUzeIwin9H/m1FJdvuoHjMVtGyN/XNSKdG7/Fp4Wi07ctE17klbTfxKSQohwlNG/L26SwF3CQfVEZvo9aYdtv3N4Qk+HaQ1176erNsWVhz6rPwBdlGBcWJ9+0RyDCkfd6yxxxu3011K0bvDLJhtk52wMxt2pxm1aDVD9jkRRnLliM3e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Arnd,

On 09/09/2025 at 23:23, Arnd Bergmann wrote:
> I'm still collecting information about which of the remaining highmem
> users plan to keep updating their kernels and for what reason.

We have 1GB of memory on our latest Cortex-A7 SAMA7D65 evaluation boards 
[1] (full production announced beg. 2025). The wide range of DDR types 
supported make some of these types interesting to use at such density.
Both our Cortex-A7 SoCs don't have IOMMU; core and DMAs can address the 
full range of the 32 bit address space, so we're quite 
standard/simplistic in this area. We use CMA with large chunks as our 
camera or display interfaces address "modern-ish" resolutions (~1080p).

We use CONFIG_HIGHMEM and activated it for simplicity, conformance to 
usual user-space workloads and planned to add it to our sama7_defconfig 
[2]. I understand that we might reconsider this "by default" choice and 
move to one of the solutions you highlighted in your message, lwn.net 
article or recent talk at ELC-E.

Of course we plan to maintain these boards and keep updating our kernel 
"offer" once a year for those associated SoCs (with maintaining 
upstream, as usual). As you said, being ARMv7, we're quite confident for 
now.

As you mentioned, we've recently released one ARMv5te arm926ejs-based 
soc: the SAM9x75 family. But we don't have the intention to use too big 
memory sizes on them, even if they do address large screens, with LVDS 
and MIPI or modern camera interfaces...

I don't have too much info about our customer's use cases as they are 
very, very diverse, but don't hesitate to reach out to me if you have 
questions about a particular combination of use.
Thanks for your regular update on these topics.

Best regards,
   Nicolas

[1]: for instance: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts#n29

[2]: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm/configs/sama7_defconfig

