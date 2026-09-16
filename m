Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C399C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C0CA6B0088; Wed, 16 Sep 2026 11:37:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 171AE6B0093; Wed, 16 Sep 2026 11:37:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061766B0095; Wed, 16 Sep 2026 11:37:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6C966B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:37:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4BBFC1202B9
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:37:54 +0000 (UTC)
X-FDA: 85220030868.05.86F06BA
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7DED840007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:37:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hWNXC0FO;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789573072;
	b=KvTDe4hnepH/uo3tNB1KcPi6NnUrVTqrQM6F/6HhjIMW84Zba5lrsK6NIbN9CVafN972j3
	b/5+XkhCvq5oefACoblfiItBbNpiMsp6eAzXzrriDvABcUFC2sZn8m0kMGNR81NQ/bS4c2
	xq8cITcmoP4vKrmPBeFlLQw839uZIw0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hWNXC0FO;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789573072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yrYalls8fAkvyVlQP9FlmP4RxEorGFK72anR8WExHtQ=;
	b=mnAjY6IU4hgZ0x8VExk7XcgLoJXVURzHadA8RkHjCMM6bl8MKZQuXvwvBOqSMiIr7qL6i9
	4cv5NuV20zgp/5nROXWk+DBudYqpJoZxcShjQUT/qwnZk69VLJ1IfvZuSl6jcqeTK+iehJ
	+KomDEnrlVemx1OMKJ9vi7X0D2cvbVg=
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-530e28a62abso13278801cf.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789573071; x=1790177871; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yrYalls8fAkvyVlQP9FlmP4RxEorGFK72anR8WExHtQ=;
        b=hWNXC0FO4QMm19zPALRqcNce5PKBqbKSgpdOHKfSDI9boU7oo+b1RMgf4z9C455iqI
         6nW4F4CMqMTSi4XAJCsbfMLl7YJuC4kMNTzr4m2af9gXNhrQmJywl4GFgviClmgyESKZ
         Lxz6AMy+homSeagzmizoNcE3tJhrrKTE4PLYhxWEJumFg/U2TL3mOH41QyMEr99i8yR0
         y4nYZNksFD3AleCngua7mDoedK0lmLF7qyRRrUUpiQyJc/EyD20HYGd9rRPQwShXaX2x
         nuMc1+jrOaqyizIwtCM7D/gn+GRnTV7T7ZvLpH38BAkGaav4fl4u9a9F3exxu8yGG5kd
         0Zxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789573071; x=1790177871;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yrYalls8fAkvyVlQP9FlmP4RxEorGFK72anR8WExHtQ=;
        b=ALTivr2eKtL9VuE9ckVAx6t7Hw/fonYjDfgNWvA5Upd7HFvHyGOTNL6ZaWyw+rIJvM
         Af4225qZk46V44300toCaq8HtrFM7xoE4t4Ce/L727m/IqnNRHc2pprWiS/IC8oY2pKN
         WCPzUAwoK3HDScYDraMJk70FIe810ypUxEcpUocXkuMD/JFwNgDC3bJUXv1CJSeXjtEI
         ViAOYM/tWN6kwFz2LPFO+FSRrgB83C3fZd1snYVyEFRBxGg3uppJdjZyYkY7DoQMfGZm
         xax+9Nppide1EIoNO6E/hzUKYP8chlmxFgINCozJ60PoOf779oeMdeKeUfH5DvltsRd9
         XL8w==
X-Forwarded-Encrypted: i=1; AKwUvBwJWyu7tmovvpeGEGNwlF4mvnBqLEaxv+M8bPyW7BsZQvDDBG6iw11NqGxVtyzH+w92UqsM8eO9TQ==@kvack.org
X-Gm-Message-State: AFuF++lFrGiJZeDs4TIV/w2WoaFDaAy5L8oUYaE2tFRVjQgNxtYpj8UV
	66bK/Jmz1EjvfBhpi8mVW3AOO3yudlKIJSvhOvToyIMQi/YIOfYc3J0zpCs5XBjpgno=
X-Gm-Gg: AYBFou3WMd9cDAq86GRk0+WyMpbpcQin8iFP7JE0yVy3YDnhdIVoncek+Ud8PqIfNwf
	yhxfAkFReOHCS89GB+x6pmS3BOmBKf5DSyitGJQkevOtglShk2BiVVbTl6j3a3lJvrpYrfkipI+
	vt1FvlelYBKtwsb1kFweOdKKqNk6J1Gz/vXgmJrwoDBZJX37QVYQLFJ0Hurg2m1dF9DhRdZp2ah
	aRnUdwNCY62s0l2KQmz+rs6DK2p980XssOWWseRYAVMwEO0ib1x8WTXdBRAsYhNaXljNecTzeBY
	aO9nuvJ2Af/OR6c7OwvnJipVacds3jLbmzXyAlcB2SrWw/N0TKgiS5joZZ7QMkbvtwMMNEEZItH
	XiOxrCw8DkktfU8Nnn8x6qh0uivHFlgTrYzq5b7O8WjtK69eBhegBAse+Tm0sf0mnVlWFkRnAxI
	ws+IzWEkQ/WFpNZ8Iz5rMcy/IwUkQ1MmnMyfmMR5cUb02mvxYwbIRuOfXfIwHS2KzE8DzVTrN0N
	RmKIe5VpQ/qllL9CUbUDgaA8Ri92ZgPXU4+vpXFaejAUkG7Jzo6JvE=
X-Received: by 2002:ac8:6f0d:0:b0:530:cbf7:6bb7 with SMTP id d75a77b69052e-5327f201bdemr54089991cf.49.1789573071567;
        Wed, 16 Sep 2026 08:37:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53262024a94sm24407431cf.15.2026.09.16.08.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 08:37:49 -0700 (PDT)
Date: Wed, 16 Sep 2026 11:37:46 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, jannh@google.com, wangjiexun@tinylab.org, 
	sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
Message-ID: <aqq23i9824-GWdhg@gourry-fedora-PF4VCD3F>
References: <aql65IhMobL5Al9B@gourry-fedora-PF4VCD3F>
 <aqqTbGMJL86TzDrf@gremlin>
 <aqqbB_nFAOGenDhy@gourry-fedora-PF4VCD3F>
 <aqqjW5dpyznijYLh@gremlin>
 <aqqk89oTigJ9LS2N@gourry-fedora-PF4VCD3F>
 <5437871c-d9ee-49d2-b24f-965c73c29c3e@kernel.org>
 <aqquDtEZL1ndymGN@gourry-fedora-PF4VCD3F>
 <46d923e6-5724-4df6-b0d5-8dda7c547f6e@kernel.org>
 <aqqyhkZqcXDUrzeb@gourry-fedora-PF4VCD3F>
 <4fadcda7-d96a-4cd9-9b0f-5d387b6f82af@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fadcda7-d96a-4cd9-9b0f-5d387b6f82af@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7DED840007
X-Stat-Signature: maoja7nhwjw8xqk1f66cja4im9nm7d7j
X-Rspam-User: 
X-HE-Tag: 1789573072-983897
X-HE-Meta: U2FsdGVkX183aBrP4jqKtf/PxCywcUcCJ3lTiZaYF9t2KOarrVdO1m9hB9yrr80V4iolJJ1/wzv/7HmB+jDNoNVfiZOmPmHVQ564s1jP72dy+dkbOyyjIcTCxz6Qkq12Rjl2vpjYfxeWTStmMoK72g7JSuZBZC5bQqyahP4oSjQDa+jpIJMBb/mMcFexgYvBZNTpXijzByuFAk4omTHAka6RD1scN83sQFz8dT2FYRG7ZFu1VHrdYEZ5Xl4DLvmVKWY1W5NS7WzBHN7lL0ljaezwRHj8bRMfvOR5Nan0050G8d3R2zRtbVZL/ptjiSMRAR5Gs8nVboNYdv2DHUuP6AKhZJcU+niv3W1cKsplMfp25JQDbK2r9RFPr+WpWU3w1jNNl74H26N7Voa7d845Xqtopu1l+sDauxxEZwbH/h2UhljjvcVGeRLp+oAmYpGG/P+CCG9W3xVoKZCi/wFFOzM6vt5m+6fgD6AkQ+9a5l5rWeWGXdOlXL5SlcT5kd/u9Ha6EIjIBnJPdEcgPOrNSYHI4q5EHwmTb6vYocCQJszlU6OCXX4MupsnYwiUgX7lVWu7DMFzQ683wLvLGzLdwnEsPzkDhcmz2T4tDIkYcejb5cNawXxtgQrfQo8ctnJe8CGF3JAQ0zSuLEB0pHh6swcBJ0jOQAxQMgnLMwHuSxAupF7+2Fm59DnGtV52aQRht6WUbWqQWogJ20aPlmprlGymftRuxOtTmOMar3+nXZ0WfFsdQDmkSy8jg3FkOUL+5J4vBAhhV4lFtuQnfElZbGteXgLJjY6Wu0JxBgzOLjeycXq0Vys0x5p/h2hxwlWcf/IC5Pls0MPEmgFZzYR4eB4npLlYQCBgN/Cj3sV5sFPsxqLJfPOr6HwZ3cc6j7JQGkl1GYFTT4QKXgUPdNdFIJXu9A7ZddiIv45fFE2pJ0aYxZDuriKdgKCCkriBwRM5SMpXp9inu2v99hr7isp
 Y7uo7yMe
 eVOILZBorjigqXmUzc7YzFAIV+1eowHHoHswF8fcRL5+PX5ec3KADY5QcXX3OwigGnd3J8VsIy5tujgVj824HLq82atzqr4On/m+Eu4SsFwHbWcMF7L8VYUui0I1Y4NCpJ/EsSKNydf9NFIadiOx3UzxBfAhFPthjH/FB12IZzWtc0dNkd3lF1+2C3ztyjyFsE/Nl5sNJfZPhsjh7KEDhUgDCJqth7IaZ2dZp1dYFbA3iPz4FtFsZRyOrsEl7a370zDTET5Kbyl5k1vb6wOUQEbq3ZDvU+KJcZDzpe0f7LSaG8YdwcIaCON3D9mHgspdJzzCM/C8dHjX6a1o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 05:24:43PM +0200, David Hildenbrand (Arm) wrote:
> On 9/16/26 17:19, Gregory Price wrote:
> > On Wed, Sep 16, 2026 at 04:59:32PM +0200, David Hildenbrand (Arm) wrote:
> >>>
> >>> LLM go brrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
> >>
> >> No schlop like that please, I don't want to hate my life
> >>
> > 
> > You missed this part:
> > 
> > "I'm trying to be careful about not causing a bigger maintenance burden"
> > 
> > I wouldn't do that to you :]
> 
> I just wanted to make it very clear that I don't need another schlopped gigantic
> patch series in my inbox that I'll mostly have to ignore because it's
> un-reviewable ;)
> 

I would never :]

But *motions generally at madvise* if this isn't schlop i don't know
what is lol.

~Gregory

