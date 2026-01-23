Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3967D6CFDC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1CE96B03CE; Fri, 23 Jan 2026 01:23:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE066B03D0; Fri, 23 Jan 2026 01:23:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3E06B03D1; Fri, 23 Jan 2026 01:23:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB89D6B03CE
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:23:30 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFCD6C186E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:23:27 +0000 (UTC)
X-FDA: 84362236854.02.88953EF
Received: from mail-dl1-f68.google.com (mail-dl1-f68.google.com [74.125.82.68])
	by imf09.hostedemail.com (Postfix) with ESMTP id EEF31140003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:23:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RQlk2uAl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of tianwentong2000@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=tianwentong2000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769149406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zhxgaciYhXpYZclEyoj76XiDHlN7ymumRTT0uPccOBQ=;
	b=yrLgnVm9fU+cTM3b8IxHprev8s/144qSpTQdIRrjqq6d0kJYwARgovlDUbo9cVlAbS9B2U
	wyca2sf+0yi28B0ru1Axs2WECz2B1JOgZpz1d5DKXT/xHC/A8AFhazp6r6OHBIbeTaZvff
	VsnE1OZ16kE0kZ1hrdcVRxmJofGSPr4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769149406; a=rsa-sha256;
	cv=pass;
	b=jsx4WyLlGSpQMMafpX83x/dhqI0rS+NMCtgWcIam7x283iNvV3dCnLfiX3vkG7ZhV5SrGj
	qwXndrZw0fVjb2pMALmLLpNgFvJ7EAqnW3oXGw+wXhwXmXY9ethaI5gMcCt+RzcXSUwZNu
	cDkYdeQBuEsSr/uRP+8/4Zywnxv2pSA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RQlk2uAl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of tianwentong2000@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=tianwentong2000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f68.google.com with SMTP id a92af1059eb24-121bf277922so3149562c88.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:23:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769149404; cv=none;
        d=google.com; s=arc-20240605;
        b=RzHJnvIIwy8W9zW+w2UziCzbKKW+WBQlZaj6x8R0C7TUlhf4uxEsGjFztYcqI3u97g
         /gMBAotj6YnV4pKQVdG34SO5KObqN1kxeXnzSAs4vlpKc4I14ZFqA42TMdeUrkesdWEm
         eNaXWbX2xtpfUR9fF5z4djRF3gWES7CJ5JeZ11q9Ne0TD66i1+GmAVA7MgF7/V/4w3af
         630Wi+xsoBoAVKJJs0AKtzK96eW0lm5Y68T37zcehLPTdiISOizTOcyNpgpDHmn1whTD
         RoAy38ai8CkTaecdgJM/w6c1iIcNPJwfK/q1mbefkXpkk8SZoUufliuIaizFVIhiepgV
         oELA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=zhxgaciYhXpYZclEyoj76XiDHlN7ymumRTT0uPccOBQ=;
        fh=9OSGxxWW6zt5D9rwPmybw3fk61pF/N5hNG15+no/Bxs=;
        b=VlCRmvND95d0WLI5wSYJfOua+p0JV0TmV6Yxr2V9OKw1zUHPy0XIiuwdJ2z9WUsMdw
         LpyxEY/lLvFEU7WYXNO7bHnFjOYZb1cdpWUCBXEC6AL86eDBNA9C4xwbDI+kOYSjW89A
         OsgIkD/6EnvuoecnmUZ7+m6ysTV6XZBuwzzst5zQ/Irkn701ipsRZydzSQo6Y65ApP/s
         Hiv80MGbREyPn0iIM6XO8lF+4SOFyxSTes1WoTrlZsd3aVSkBKMiHVRT0Fa32pmSevHD
         taFElcy8OrNNODM2US9awOi0WpZ+9gfGhcqRVsAnxIG9h8cO+hKliER2F8Zx1dytqKRe
         3BfQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769149404; x=1769754204; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zhxgaciYhXpYZclEyoj76XiDHlN7ymumRTT0uPccOBQ=;
        b=RQlk2uAlE5kKeix63RhSyspbCEYOkPPPyzYLnxhG+JmQ+uX1ZPBLtfoZdEfsCgcw5f
         7GE4XM9/oZKMb4yif9oTRcqaXMKhGKzokS8QdvQheywJxHXoVRYAc16EAisDo3l0HZu2
         FxLwM/m2d+mEROUU13pxlDNX+4zkHGJvSzcVQMNM8vJSNAMnTb/xKqPMOCs/fCsoC29W
         HuBMHQAaASZfkmvOFIV24owtvjI/HnUmRW1QqPTET6cAQzVVOJ9KxrWVkiT8iJVknzie
         X36sjbLKMnh8johEhiQDFuRimEuOgmU1lQupXzL6ASCiA22dVfSZYigFnxNdPMvC0U5d
         /OmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769149404; x=1769754204;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zhxgaciYhXpYZclEyoj76XiDHlN7ymumRTT0uPccOBQ=;
        b=EFnWMYEv478nvU2GS4XNp/YYje4G0qF8cNR6EK+PW04ovc1XEYtetL7XiGL9/SKhK1
         U2bWJULUEf2uJX4h1+5ad8Mkzd8w0zkvMGAjZYI4tWJVXhHl3fMrIQ4C5PIwanrJGIV6
         LOmPfFDCuin+N1TSQyXqzysr/7L0iYmCmh5Qz9FW2qvo6+sSESMruxdoLn3wpqFSJjC6
         6OkbeaiBkXPmhuYmmxsP50nnuMg4oikEZeSufQGkRLdx2tdpUyAXK35xyDDTHjxYzwt/
         k2+ADWg+19aqTvnOqI8VHa5g07XINO2Dp6hTNDzSFw7lpxWlghv3zezuAgMgyhtXyAEo
         57Gw==
X-Forwarded-Encrypted: i=1; AJvYcCXXg4AG8pVk2fo/4dNjuWf4jS/IiwKPFHrrIZPUxkKlHewAGGJiIBM5htjY1KvbdUPuit8qkHnMyw==@kvack.org
X-Gm-Message-State: AOJu0Yy9gUwH48dC3lCGx0mt0voFGvYmVrd22tNFNy/4Rvjpqdjm3QMy
	dBM5+7/Nn/+VPP1Mw/JzxTWFNVqFJ2Jo64YDhCPPKjGCC8wB1GhxT4xXwh0ZO4VntPcvb2s4gj6
	OZGNs/jHc90p/1T1cIDAiQdHFBMgP4Kc=
X-Gm-Gg: AZuq6aLnoOzg/ci3WhasLZCuvB7Sq2JOMygU9950Vn9i71YH5FuPVxRRMYK/vAAR9ZF
	BcS77HY2JV3WBGT/HNGXd6WSj2uK8qc5P0BUoca3AdvJZAH6TstnaK+jxY5yTigcPuIOngRPLjw
	2LbJ97Qp9k/aTQTybYGmIz6/FwVv7P7eIfBzU7HmloZ72ng2P/Eej9v99UGmsl9JLtNxXtAMBZF
	3+QGruOqHHNd5jFZtE3T7xSkPuZ7jsUCwkVWUONgc87FUqXPijzj9J6JprIAe3MsPuDB8Ku+2bu
	UvV2hsl7
X-Received: by 2002:a05:7301:4e0b:b0:2a4:3593:c7c5 with SMTP id
 5a478bee46e88-2b73995a3abmr797133eec.5.1769149404505; Thu, 22 Jan 2026
 22:23:24 -0800 (PST)
MIME-Version: 1.0
References: <20260122133633.79792-1-tianwentong2000@gmail.com> <5961c2655b49a7d384140c33d6897e53f89cb5fe.camel@intel.com>
In-Reply-To: <5961c2655b49a7d384140c33d6897e53f89cb5fe.camel@intel.com>
From: TwT pupupu <tianwentong2000@gmail.com>
Date: Fri, 23 Jan 2026 14:23:13 +0800
X-Gm-Features: AZwV_QgqsSas1GY0YO7VHpwDp1Q8NmEsEQKa1FNvxIJomShoSzfv2IK9DYrJyu0
Message-ID: <CAGPELS7JdxTY5hthmTyU_yDxdG7xR2k0hoA1ZqV_Lj+8LEkO2w@mail.gmail.com>
Subject: Re: [PATCH v2] x86/sgx: use vm_flags_t for vm_prot_bits
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "jarkko@kernel.org" <jarkko@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@kernel.org" <tglx@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: EEF31140003
X-Stat-Signature: ti4jgtaijmnb55h19xpbdafjmd4rsctq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769149405-454418
X-HE-Meta: U2FsdGVkX1/MDXmH13MhOT//jW/fkGrvCW8XTscvbGbvgHcEdUhQzqgcz0rs/DM63IiuzbxdcZBKZrhibFD67cEA/YOkBIo6mt8FJ13ZL89pJjVvnocv+S1b2jvKAabCBlyyot3tCkIqHDKV/T75gfj0/QU62O0/i3qJg8f2f1i5r5Ek13XYOaqvKwSBD9y3wsfJNIgal6Jc+jmBS09KDwV/MZeVY9PkyICS4DMGdbN1jOk8hqJ1okzQpuLtm00Ld4S7Q4LhVKJcfRKw/lRgZtJYjFNjAoKN5ZTpXbfCYzB/qUGDFBQZ5ZWf78dnXRseDVJhu/tNepiY1z20w4TBPe1iiGtMuuvvW7iz/upgGraGSV39ljRv8OMWVGLiC7fQgW3ntC8gM16dPLMZ9uJHox8IZvNsMjtg1cl9xGfVnvYBU03AHCTQ8w5M2Zc5UGpsI3MWNeupvFXA/4ysAhg1LV8LKvUwEZF+8iX8TkysiZanLsosrOs626m4DecjxOLKmFv3uYAK1aUrdUdVZZ+0Xf7RwtMsm14VGyC1sH/pyzzAKfk+gYXtbHDVNLv88i62ZvENphJiOB6YwDBRPTczBUrhLNhONQ+jMfZwTJxNmLxytV2EZ4QIlLCWEpfGhTVf2WlCmg48tubXqfWOsXKr4JuEJfrYNG7nYIosXIGWJUCMvGMzKgf4f81emRMusf00/vgZQRz3a+yNWEnPjx3L4bY0IEDcBkIo0Kmfmj9S61+68sA1txgJWwuZ41wwQdr4USJr2MBRWkuNv15acfHGInMcS4pElCMK8HxRnNa23D7dUZBVbfpjJtxX2jikJFaKVftF4dnyloRKem0JIHbugOezdv9w+/Qa2d8nXkXTsOlBehp6dy/fbZZ7lI2UODmRbutx0LNqdcNlWiHnu9lJ5lI1UIH1v19E6WA9L9nYYXBYBtPDbKvB0pKRMi+Ktu73shgqMnV6t59uRENZnvW
 9zeWilxc
 8HAHesmZTCrfc9jcXVXt18R7mTSEBy3+G1FxoTE/uZd4A8XlY54Buz4RVWxHvm/LEE7lBvn1IhM0t7wTp8zICXg8LqRwKew7Obf8ZZcPMyjVzoADF3O2crLG/pgdRNL5QVwrYyRjvBT1hii9lh3fLNa262hTwVqA9pTObVXJxo1urm1v1tQwnlZWzGHO/vPQQijJJyWhCfkbPoXd7I4waZOigIgT+XlygREUiggsCBPrh8qbjgJuDANanqkcxOmOpx79J+fjiQtOIG56PR3BuPU+s+rUnjRcasRKaINQOg0Qh3W0iGz1U4TnTJldy5xH4bVodpZpJU+nDPfocgX73277LmFHsdYmkTvdeng7utA0GubPHcAolKkpMnAyAUNitto8sorCPPdt1cTVllj/QvVWmOca/XbKNu6xNWv/37Ecn31NPE14hk/LMg3LiXsv36YvmShbAIUDAWEJR/EPkaKUJZc+u+AcItSKZ3tXUdwbif+KtDbrBH3an8wmd6IYkt2mIT/A4fEXf1Dr5vVf9lTCO5B/M52trNor615dAi0/8yjNZ814lG0J7hXOKS6TvznjHqEAH1Io/SrHkVwJwzYeP+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.008386, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry about that, I'll make sure to reply to the list.
On Thu, Jan 23, 2026 at 4:57 AM Huang, Kai <kai.huang@intel.com> wrote:
> Hmm I was actually just pointing out, but not suggesting, since I am not
> sure (honestly).
Sorry for the misunderstanding.
> With vm_flags_t I think "theoretically" it could stop being integer type
> someday. But I guess the advantage is when someone does that that can
> trigger build error here (so that we can be aware) which perhaps isn't a
> bad thing?
You're right, the build error would be a useful early warning if
vm_flags_t ever becomes incompatible. I'm fine either way, let me know
if you'd prefer keeping
unsigned long and I'll send a v3.

