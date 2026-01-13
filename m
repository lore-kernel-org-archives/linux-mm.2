Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9376ED29DC3
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 06:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9A5B6B0092; Tue, 13 Jan 2026 01:50:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47FD6B0095; Tue, 13 Jan 2026 01:50:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C475A6B0098; Tue, 13 Jan 2026 01:50:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B02126B0092
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:50:54 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34EF916016C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:50:54 +0000 (UTC)
X-FDA: 84326018028.05.B4A7290
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3E3DC140008
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:50:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G4Bfsb3g;
	spf=pass (imf23.hostedemail.com: domain of kaleposti@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=kaleposti@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768287052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vX59/flKMUDb8zjb/CqTAfKlTuGyJwgf2lJ9POWv81Y=;
	b=rZPo4Pr7YAueHvoN0DPXinAUZLxynwJS5MFnnq8MJWSLDMDhMpe1vBNnVin635K7BPGd42
	7T6+qYbGSoObKwRkBDkORjuIBDE6NMEkeydFklzus7PS+WwpMdWNYEDz760TVSf4jom2Yh
	i6VEFJS5osQ9OXfD0XLOdhaV69/8L3U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G4Bfsb3g;
	spf=pass (imf23.hostedemail.com: domain of kaleposti@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=kaleposti@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768287052; a=rsa-sha256;
	cv=none;
	b=XVcNHYPePhTgYPD+gax9LPp87+dxZT989U3bPtSG1JuFF0CC+78NC1vraTjhUuUNZMkr3y
	Gj2Ngsd2swoI8bi62FFfab5jEtijZ54pTQJQNHlBOExqylKleAWJQsWFV5a4INlvOpS2E1
	JGe4TcgVz22wgzpUzzDT0QgWggEPRf4=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-88fe44cce7eso56304316d6.3
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768287051; x=1768891851; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vX59/flKMUDb8zjb/CqTAfKlTuGyJwgf2lJ9POWv81Y=;
        b=G4Bfsb3ggq6DM+VSDJJDwVAEKLnvlumK4LNz9Mn2vXSZ3jI0cpPG5/obhfyZ2aid2V
         dck8tZOQawGWPPqArjRJnByN+1dk7sSk2Z4i3kyzSZBYhGjqsBzrdrDLR92agGWlaIqb
         WYutC3QpngIbFdQT1JkzTKzJwWaaoas7eANxIWsirFZB5e8SbX+eJGaRpDzqVXoQcwRv
         efdEMNpIT+jgEv/XCG3uvglC3TLl2Yz1pUO+DS3iomfpvr9vXh8Ze6PbgB+wPIQ45Ez8
         6P/6Uj6q4vX15vmwPFqXwTzwJ0DmD2pqLY22uPlJ59aBwE0k3/SIFw8Nqn/P5IqxMdej
         dSxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768287051; x=1768891851;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vX59/flKMUDb8zjb/CqTAfKlTuGyJwgf2lJ9POWv81Y=;
        b=MsaEV0cXG3rei5p5CPtsEAPqmHBcPyQrFvM4hk3++f/HBGp73YQLXmX2JFjpCAeESM
         CQebX8764IBTdijqULgVfvqEFKyDL1U8xiscPKjbdHaNbmxW1ZaRAwaPz0aLtt4OA+93
         blQQxMh73EzPALlrq77220v9LJlf5OdsqY4UsScCbpD1etm9+/tQbpY07SwbNvVGsbfm
         xyls6vXsnwOi5M7K6K3BRzFLRoBdGhgI09wj8c0AX8rw6xD2cbLHj2hJ1HHXWW3CD6lp
         aaKzUxvwmTQZcJE0rX+UyNJSMWs+ZnvoUNPoP5PoOtnF/aCKGWWJnWt9zNSCdf12n/zT
         Yf5g==
X-Forwarded-Encrypted: i=1; AJvYcCUQVbrJ6O6yrfIqIPoJPPExWr6ej9Sj73/KMyRH6FxBTeekjyGfwnfwdECWoKol+olP/sKb85s+Yg==@kvack.org
X-Gm-Message-State: AOJu0YzOfEwYhlGjFE6h2ksGjCuec5XVGjCEp4Urxd79XMtewgeTXYGi
	FKCfLn3fY+SZNQNrBbLcX1NIo8IvUD2YBxt5mv+VVLrnl58WlWc3ZfgD
X-Gm-Gg: AY/fxX5h1+pvtDHwo/mgnnZTLd6BK1ol9H1KnjsdC8HipycVYkRXeKjfY1Hv52tglVy
	9jlqTSUJMnBQ4wEcqMvUCkF01bN2MS9su6htZCdZeCTdLK8xPjS7YuO2sqSiNvZzJN2TZ+B5IXd
	WKyfWCBft4h0ZJiYlCgrLh1XJChL0aliMD5PirVOYcYqU6xdBlEhJcp2gE7hEz20JrQ9Oi4DdxQ
	Z5D0WAr78EF3ligu18BZuCOc+g8Y0vXULkQkt+GoRP+aBYzd7DfdAKc1nwpD3NcM2NbAvakfxwO
	cYQVBKdlnuhQ+viuLnvK9zXRK07i5chSkqjixFIvifBBEn6IpaQF2eI0jcEsykCBlNLGuTMSdZT
	bG3fNSqmJZbsS3jQGPshklxPjfmF3Y0wXGl7QDtjqs13hLVtLjreTh+75O8Uiki4GiFA9K52SCH
	mdfqqD7p66ZsLHZq5DlXN9hnjPWm17rugqWYiu1XXldyU6KKo7Iew/e3At+A==
X-Google-Smtp-Source: AGHT+IFA85MjM1cnTGL5nks8UTBaUTRvSeGOw/MqVWENdA/8we2okwkLgNeF33lCoaLlOIlw7RP7mg==
X-Received: by 2002:a05:6214:4291:b0:888:81f1:a05e with SMTP id 6a1803df08f44-890842d1be9mr273660036d6.60.1768287051243;
        Mon, 12 Jan 2026 22:50:51 -0800 (PST)
Received: from [172.20.10.9] (mobile-access-c1d2ca-216.dhcp.inet.fi. [193.210.202.216])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770cdfb0sm152433806d6.6.2026.01.12.22.50.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 22:50:50 -0800 (PST)
Message-ID: <86b974d7-cabd-4913-b5f2-5b62b520e023@gmail.com>
Date: Tue, 13 Jan 2026 08:50:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/29] arch, mm: consolidate hugetlb early reservation
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: Alex Shi <alexs@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
 Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Jonathan Corbet <corbet@lwn.net>, Klara Modin <klarasmodin@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Palmer Dabbelt <palmer@dabbelt.com>, Pratyush Yadav <pratyush@kernel.org>,
 Richard Weinberger <richard@nod.at>, Ritesh Harjani <ritesh.list@gmail.com>,
 Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Thomas Gleixner <tglx@linutronix.de>, Vasily Gorbik <gor@linux.ibm.com>,
 Vineet Gupta <vgupta@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, x86@kernel.org, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
 linux-mm@kvack.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
 sparclinux@vger.kernel.org
References: <20260111082105.290734-1-rppt@kernel.org>
 <20260112142323.495fc43e662e7d276b0fa371@linux-foundation.org>
Content-Language: en-US
From: Kalle Niemi <kaleposti@gmail.com>
In-Reply-To: <20260112142323.495fc43e662e7d276b0fa371@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3E3DC140008
X-Stat-Signature: kk3gx5puwibzb8u1t93t35no3yuy6n9r
X-HE-Tag: 1768287052-936774
X-HE-Meta: U2FsdGVkX18MCaI+pGL5Bc7koUk8vPkHS7wyVgH/ZW2b2HRL19uYyUkT+Z6YqwbWQGl34NpFtalyuCgrvGEBlkAc3anOQiwKvbhCW5huo/4XHIRPbtjN5Agtb2Rzoxy0tasSP7xqQxvGF+4eKJFjyVTAVEqNlhvF7LnNt8R/gOxOc8aKNg2gQw61bFK/qkgJ3KEUfVg2VH3FR9rK2wVmK9qE66cjO52i3uaz1vWsVd6fo4/MbmY8ZdCJWQ4AvkLwrmkwUbLdromXbbWgOQQ5olmxh5an6pKYcd6ev+au4vPCDgDi3UL3yCO+eHnZRZle3xh4NULnZ16d9XHHktdAFTu46rFZaSF5WF692kdg3vL5tfHoTo5syf4D/DXXF1uIEkTbc2tOTo3WERlPFkmxecVOJNlLWs5wY8XcJRtsNNM53BTkQij9QoBgCWQX2tlfkOV71W+rbhx6oR4wqBeUfiZfc20AvaQ9BucI1icPcjFn8ZvskNSYAlRPUOR7m0XZd0iG/gtZc/TVo2nEo+DR2w7QqECwtXuEDiJE/CrT4bYwYUAWwJuUyEouHs+jVm4Bv8dPgRH5Oyda0YfZfPrynph39UCrZyaxxXiIOzMoQYwmVIlRTqaNcnVhaE9J1MkkGyGGefFdhpdP7eqwQaDvu/ln8OVuF3l7qXm4R/5kYhFPU+92/wK5Twb0GjWhQO3fBYzXAfK1T0BFddbY8GLGD9ZqmEPQnoqN47RaTGMdkRAD7mmjZM1fW2g+PxOLBuTSMVyPPrjlFKa9qm6iI7UlGLU20TCP2L9+CtqIIkB9dKSRsEiQaHIXAMRM3/lceUXUkevkcYgqHK2CBHpIPJYdQrclGHwCeTbjwGRAEtlUVZJ0CvMIg06kyIcWzdy8evTxhI71cG59TV7EQS9tMXfbtII8J1pBWPYafhlJYzYEAMUwsykc9DGUT91++OOFiQrpfyM8ZG99qagpJCSN21d
 BpQ9n0fq
 ykNfAX9IwJOlzpVjSSFWqJRMKC+OhMJdIVNhOh8sSmp+uGeftwpX2yTTN2OeAhVJ88GcmPmFm8xguzc3pukfriiUfN+hZ1YppQWORFbxRB2t387uTZngF41Ds+fhiHVAv75LfJjnNomJVvUDitRroGPkcZ2KhPanMNuQ1zapYp+FhW12+LfAK4OzcdXT5m82LRsQ9ZXKqAvQ2cz20F1l1DuiANNUtvxVRwAnW/A8C7MyUTGDgRm0eUUxRHHZhguEJAyxll0cYDMHrA55i7tbnJ4bMn/Dy03ImP/wN5uN0LCGvThEgIcb1FtnvNCVEoH1dwyC89zZHrrsxGuSeeIJxYAl2/alvIEFLtQ2Klbp6mX3YxreZFd/mGGGlhhG9FO3dWx6nqxsbAPWoXf1fsW+1+sLQVED13TxZMxPFtxu7W2dJpPUZrfrltJL0Z7yFohHZS6VNyGW1GEb0LhKVCvZKicXIAU3ywTPeAOkSy8JGHCzctLnK2EcwSXMSVae77eAIj7Hb9ZdHEHdgC7OSHQMkX3wSfasvjYHdV/KLyuUAV4hLHYNwPe3P745fAjEsp2Ox5sbGApsOA6/u5GNxZI7JtyVnag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 00:23, Andrew Morton wrote:
> On Sun, 11 Jan 2026 10:20:34 +0200 Mike Rapoport <rppt@kernel.org> wrote:
> 
>> v3 changes:
>> * fix empty_zero_page initialization on arm
>> * fix ZONE_DMA limit calculation on powerpc
>> * add Acks
> 
> updated, thanks.  I'll suppress the ensuing email flood.
> 
> Kalle, can you please retest sometime, see if the BeagleBone Black boot
> failure was fixed?
> 
> Seems we haven't heard back from rmk regarding
> https://lkml.kernel.org/r/aVrUDeSkqqY9ZCtS@shell.armlinux.org.uk.

Hello!

I will test this v3 patch ASAP and reply results here.
Collective sorry for the delay; I have been busy!

BR
Kalle

