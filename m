Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A17D5D47CAA
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 23:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 112836B009B; Thu, 15 Jan 2026 18:52:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BCEE6B009D; Thu, 15 Jan 2026 18:52:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFAD16B009E; Thu, 15 Jan 2026 18:52:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD5326B009B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:52:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8ABDB590FC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:52:16 +0000 (UTC)
X-FDA: 84335849472.09.803FAAE
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9944E40009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:52:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=l4FIRpt7;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768521134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ziMDC0dlNmas6gHzjHH1+PeorxqM4k3ugul/XAfwuzw=;
	b=zKTIVNkow5pT754OqPmrCcPRZ+0I5AcuFl70vJ66rnSMQHNyIUs0IkFL2l8XWMx+Fyissd
	yqA1xsCW/UDyt4HEymFQtBfg/qrRUS1jnepiWMAOJPMOWiUna2vOjNYd8sbPCnoYEzv33B
	TgIjMnqnX2+jA/VoAjubOogoDupa0rk=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=l4FIRpt7;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768521134; a=rsa-sha256;
	cv=pass;
	b=zDcEBG1G7H0hVHQJA5WlIKGBhKvD7OhfgSnsQLa7wIDZ9T5mJ80WDqseo6nfp4wGYQezXH
	fb1zucS/icvNf/Tem2cNerGwkwex/AEG/jIqahadMBqAU5NGN6hjAobBIcmwwAqFsDKTGw
	rfodmosFvyx8l4t8gas+gqpsALs2E7g=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5014b5d8551so154551cf.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:52:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768521134; cv=none;
        d=google.com; s=arc-20240605;
        b=l3FtRoDpFsuM9Rx5I2Fg54gi3JEC7i7nvy834s9haQtn0urFHiNSF2CpzSNCXEJC3D
         4Jt6OaWPqs6++pvaUfELU9LmcmtA15YyXLWGP3WyUVjs75jqXd9hzpZaJ6fIajZwgV0u
         BOLsJDIETeEN0vJLoyTxYR1R8wfCShHbiVbCo3v19WqmCAVF0UhZ3zPCgbmFFvlnLjq7
         e/Y7W1lEGcauquKsfeY3ohAyGbt50qECE3vVU0n0tpGHN+LwRC7Fx0aipW43Cc62O1mn
         bscrszVYAl8gPqMn3Rwbozqe+zW2uwM01W+1WCEvxRJQ27AHtv7uVjSFwSKX6DnI80Er
         +fmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ziMDC0dlNmas6gHzjHH1+PeorxqM4k3ugul/XAfwuzw=;
        fh=KyaJbps2UAxP4/jxDTBwXuZfShXWnj5KaHKaGd4bujc=;
        b=HhcgSosxn/tQipbzGPjBWbz6zHG4K5MjCt4yD3qcu2Ya6myLIru8ZQPfZ8OorvLLCs
         b7QwnsFyy6shYB/GnumeVcYxFVxQ8gcbJ2mQdxgaUFKqyiEg+d95seGkECSpW7i+xNfM
         MdYogUIlN84EzCmS0oPXdCVpYKqA1mENjfMrWa3fb7EVS1cfeJ4a51pw8G+4A/oTYLmu
         feP83YsJde9VP/AXayZwlIiXiftMq0Pma7EQ8vc6ZudY+f+3a6LByPX/LfAlUpl4yx3n
         jG4/KcGEFYNgtNzvjkomigmYs7Lq7LY2vl5uVMCVkQ76wPtI02UlwEaE60YZzXtqcB+x
         1pTw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768521134; x=1769125934; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ziMDC0dlNmas6gHzjHH1+PeorxqM4k3ugul/XAfwuzw=;
        b=l4FIRpt7OZu2lwc8UGTV7upVlZp8O95RILZr6ZKf+Ah/VZxmz1fB9lPyH7ri1f/Ut6
         upC81TnHBZY4hYRvUeIFeV7dgO+RhL82RPMlHg2nXzY/61PczE5/WmXOrunLHApVuxJW
         Jy1fBwvL8dKwRi50r6US+WrF2zZKbFRXx/GoFIGiSQixYn3kzbSXAywn70tU0Vv6I/Xa
         IADLikQfxDK2zgV6Qfw6f601U5GjHfaiv+PkKzoFUDOBrJFVsrfxr2UU1SnzzO3FJ7HD
         FNsh41oiX6XcgjaALY3GG1XhefOVcncV0V6lDyf7Flf63ds5pyDvuxR5XHNmU1m3Ekfs
         GErg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768521134; x=1769125934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ziMDC0dlNmas6gHzjHH1+PeorxqM4k3ugul/XAfwuzw=;
        b=Ri497ADlUNhzHmSLF6fe62aMqZ9bXweB2GABRHCq4tmLqnxfj3HQH2SWfHQVATDt2K
         FG9TA+kR+SpE4H4QkQ5apEqrp27lpVcfZ8ZT4h8mCj0KuF+3i6j2wi7R3SBPUGV7Y+j1
         vfrpAWQjTXsL9ewap6NuZgKNVGTge/eLCwjZEwjiJvSlcPayX1vCB4psEHPBw9hyXsJt
         QQtfjZDTm7wTIytaaepeik/OL2/4PV060dDQIPFIbMyEbzfqDF9Q/+QipyBYNpm59vvY
         yo18BzkQWXfURLvnuE3XrVmg/6zz6lW6emiqRg4fKdcO+mNxbVel75y5tAN//5LzzrjM
         PCeg==
X-Forwarded-Encrypted: i=1; AJvYcCVQnat/NHMn/XerjAE55gtFAbtGGfFirxv2gAxO9ecYDGfIFHvaGDikqFNrmyQBqY3SRevz3p9pMQ==@kvack.org
X-Gm-Message-State: AOJu0YwGZdkklMDDU+J55HqJhAihl5xgV4Q9LIuwLl5nUBgtnJMlvgvb
	xn6yeNLPti/VzZp0pLavCBECJuwFLXnDnTddYdwq5b/PBylmqNFEoN1ag8nd3O93QxLkJKVifmF
	SvRhW4o4qRB7kKHQZ51VvVa00vdcpISww486ZOtXy
X-Gm-Gg: AY/fxX68e+uXB8t+N8tawCq+/r5A8020KlNs1ZjNcuFsmIJ8qJf85p4r/L5UE3ujtaY
	KOEMEOX/vnPRn49UZbkms2rcUlgjyvx4UFlMFt8KODGcFQieWHZAm+VXv1n2RqqpPE/JwG1Po+9
	/NSHOiEGw3cartaqs0TWpPTtqPaco23ESj2HspIFwb1WxvS94okf0VIm9DXQywBdgAxjHrM8I62
	7g92yB9jRIIaGcFpl6AgutKo4LevjgS296vXY2vATgl3Tvi3LB8EFFTZlrUOrESmumsSay4OG7q
	ySQiTJ4thV8e7PA/VQgQworfKL/tizJZPA==
X-Received: by 2002:a05:622a:58b:b0:4ff:a98b:7fd3 with SMTP id
 d75a77b69052e-502a22cfe86mr4096151cf.2.1768521133130; Thu, 15 Jan 2026
 15:52:13 -0800 (PST)
MIME-Version: 1.0
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-1-98225cfb50cf@suse.cz> <aWWpE-7R1eBF458i@hyeyoo>
 <6e1f4acd-23f3-4a92-9212-65e11c9a7d1a@suse.cz> <aWY7K0SmNsW1O3mv@hyeyoo>
 <342a2a8f-43ee-4eff-a062-6d325faa8899@suse.cz> <aWd6f3jERlrB5yeF@hyeyoo> <3d05c227-5a3b-44c7-8b1b-e7ac4a003b55@suse.cz>
In-Reply-To: <3d05c227-5a3b-44c7-8b1b-e7ac4a003b55@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 15 Jan 2026 23:52:01 +0000
X-Gm-Features: AZwV_QjyQPPUtH5tGDbHEFhedU3kKqiqu-2QyYB5WPZJAwFL9F8l2hS-k58cSQU
Message-ID: <CAJuCfpHCgyKTiPOZ_p76hTLRrZfQrkNh7XHJkEM0omWWCK2WQA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 01/20] mm/slab: add rcu_barrier() to kvfree_rcu_barrier_on_cache()
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com, kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9944E40009
X-Stat-Signature: 9ucgmndmwhiboo4cnko41rxnhhd6dxiy
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768521134-562997
X-HE-Meta: U2FsdGVkX18dE/40b73eDBIU8/t41kWLANc/UuBEx6cOamQP64Cc5jNNk3Zjipv4PX5I+DGf+EYihLbwEDI2ab+WB2LgjrAwHrw5lPgPg3LZzXr6Zgn4FFS7rFU81HPQV5vtfCDECbEcSBc+UTaPGCBtk0UcnDYJphXl2O5n8cpJYL/V+ae15FISSqZvyR7tXAv48D42G+vo5mM9FoNn1D9IdgSRG6VCZgzMGH92swQD0qZX0amDtUtQJhPmzIo5pAynjWwQgKkquW++YxeR9muRBIaaDjw/gIMxLWQvQA2yZbotvSuMmwNpdN933KfW3eXqZswK0YFelOU7xnO5wcoOGODAKwobPhDaYyVPtcfsNddcwqgjbRWXSw98Ax2Gq4Lj/8f4TUxc5POOdBl+dlFg/95Ahl1/dC1bbmEnVvnmychXTPwpfq7av1G5nbmo779Y8I4gTRiVI7s+EUKA5Ov7Rl6dbd07OSNdNXaDm15QI+jkqgKiOZ7t0W5o6/OoXizk0SCDdAw1z9mwEVXLfQjAj5Tra+3WrrfmxCgcAPl9ZAGOob6iPxs0GYlbfxwS5+HCCy42Q+fuxxjvkcpcfMqB6SSfTq1YLUE4s/Y4YxApzS5jpIBkrDUfJoCFDcN6i9SF2Q1IFhQUFjmd7t5/q8GY0eJsUXB7osYjFpEwcR0VicfqY5G+CUIrcRPLYxa1ym663Mx8WGwKbU0DwLVF/TjFEN4g8Qlp591Rb/5ujvV9zEXCxlSdG4q/tFRXwUgvqW21qrHxyLpRfdNZ8lsv3rLbySjt/fFfWHucwjJ2/yRwIErFZdsxEeq7VXvEb+TFI3Jgw1GZHrUD4ZLGEADwwrUNpFBNsUTkJiFFo8O5zOZTbg7ea4WS5SbjDmv4Qs8ePTqR2F7Wk6xuHF7I4bO17qiUgWTOEl/iZQb2Mu2x9wR0/ab/Is7nXMdd6eIM58qPF0x9Ao6J9/M9enzfqOp
 83W/Cc+a
 GPBFg3G/5XAikhC3ipZNwpdk0FjWjlmc3fe6IbUw99H+En5BhHAcPdf5orsGDAVDxEhnykvfZBXE2BWIGbPWw5dJ9kG53q/2Iym7NQ54uYUFjZl+V1UmSPnmLWf62DiUKfvD+w84+eE8RpIx6oh/vrPSrGBX8CTfarBHXzgR/17feozeGBgtBVVelC+9KGCyBzF0Wvy+lFvEopq/l89Tsk5ECkNbdTwLgbum4n6dDqFZIVnoXvi0NIp47F0ZX0F7vaHhOm+AME/rlKpC863mA3qvxhOoLYQBGh07C+22Bh+CgBTaSHgOnW0BdGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 1:02=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 1/14/26 12:14, Harry Yoo wrote:
> > For the record, an accurate analysis of the problem (as discussed
> > off-list):
> >
> > It turns out the object freed by sheaf_flush_unused() was in KASAN
> > percpu quarantine list (confirmed by dumping the list) by the time
> > __kmem_cache_shutdown() returns an error.
> >
> > Quarantined objects are supposed to be flushed by kasan_cache_shutdown(=
),
> > but things go wrong if the rcu callback (rcu_free_sheaf_nobarn()) is
> > processed after kasan_cache_shutdown() finishes.
> >
> > That's why rcu_barrier() in __kmem_cache_shutdown() didn't help,
> > because it's called after kasan_cache_shutdown().
> >
> > Calling rcu_barrier() in kvfree_rcu_barrier_on_cache() guarantees
> > that it'll be added to the quarantine list before kasan_cache_shutdown(=
)
> > is called. So it's a valid fix!
>
> Thanks a lot! Will incorporate to commit log.
> This being KASAN-only means further reducing the urgency.

Thanks for the detailed explanation!

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

