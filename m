Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A06DBD46C01
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 02:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 887916B0088; Wed, 28 Jan 2026 21:48:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80A986B0089; Wed, 28 Jan 2026 21:48:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC4B6B008A; Wed, 28 Jan 2026 21:48:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BD4E6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 21:48:24 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B55DD1A087D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 02:48:23 +0000 (UTC)
X-FDA: 84383467686.24.030538B
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id DCFFF40008
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 02:48:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aA4EQbXb;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769654902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=logWgHGlCER7wF/d1bfHjZorFrIMr5ik74BP+Q9xdGQ=;
	b=c/itHFhJzbhr++SC8PAaMFntvZHwLDewq64NwnQBu4I2RvpB+KzXvxH4MqxcnbgSzgWPEa
	5nrQXNrzHoYgOW3FvFjTQwpM3Cl8ePGtlIk1mo9FgmOUmdHAtcV7MudpHu/7uWbjQUGinM
	RBpsBR1BIBrplnHQk4gHV04CKJIK2Q4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aA4EQbXb;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769654902; a=rsa-sha256;
	cv=none;
	b=ROYukQq9tHCwU+0qsyZKgvq7yX+rSUDAfjCfrZhhsWTIyo3yoT+2jJuiPNhtGMS1XR1Klr
	gYCg+z1FGPN9jifsuhv9sIj2KhkoKUcSSek3PwdwyyJVIqkrldMe11CW+9EiBwXarhfo8O
	CQJEXBW5QXTSz+jPYL1Pu1Y6UfjIGqI=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8c655e0ee70so61411885a.3
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769654901; x=1770259701; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=logWgHGlCER7wF/d1bfHjZorFrIMr5ik74BP+Q9xdGQ=;
        b=aA4EQbXbWuRh1F4xMkr1OPFCIhE037Vsjl/TV1bccXR8Ja2REmW7X0YZ0/3ssuDPnC
         xXM/yfzxDLN0TWuZ6wOoQBXPryY16vV8iwK6oMalTGcb82K/MAAj/LYwOXA1SpgMJiGt
         jht7/c24+DLq/hbKCPVxGjWcfS26dqurETQDV/dHgGI3+Xw4poPvEpNS43+tvYILl/J7
         TJp4NxEoKvAbxBM07tujIV/dIIKvxaa9y1sBGyGGJDr1gCtWtRCzpYOCcDZwDMLux2qM
         WQtTnJ9km+PYNFvwvQYwwrYcRpNDxtlldZ1+6MFxbWA1Hik+5xGNAmllyEcV2gNtzyXl
         IhVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769654901; x=1770259701;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=logWgHGlCER7wF/d1bfHjZorFrIMr5ik74BP+Q9xdGQ=;
        b=CdKyBGu493h7CCIbfGSC7lwtMl8ynZNt36md00ahTZLDGimzZOfs2NKYqu/RkuPkLP
         3wvxtzzOQGt2/UnKtO+LwUQg7p+062yT6LKViWL05I+UhGT+UJ9Rv3DEEDbEthl0zF8S
         9vi/pTdUr6DOhaMC7WQ7S91IKniH6eYr7nMsnyAnFQxD42RtpVP1wpdNKf1kHLILAdsj
         ZG5YlE+Jnts2aciYuyBD7oJ+3L/B40Vr99/H/FlyBAQLSsU9S5ksA8/RSu0xLAFKnsNC
         0bILSGkd70j/zCXuPwaQpSWhDKeJKiyfKH7zgVFfrtlGw7GRCC2PMO0Y4XnjF115ZQ+u
         CnGA==
X-Forwarded-Encrypted: i=1; AJvYcCV3DInKUk/xQCp9OVatwhTSoz5XqU+50YldeVE2WWnoTxLeDkrdDyI4foUOUGMNkswXgd8GuflZRg==@kvack.org
X-Gm-Message-State: AOJu0YwTvaJ5xXkEv/QVx9n3zmDofz6dEf+5nFFRWQuUhTbmZYhUcEMu
	X13xV8l7T6zD15kT3HMUJB7+x1u95R/P2W6TdEru8ktva2NxZWwIFpm7OPcsisAcmaM=
X-Gm-Gg: AZuq6aInfNTnpT7fTGN6AOMm73GjZNjdWD/GrYptMSn1pOkSEQxCcAQwp1jQiBgu0I+
	LgszCEkY7QRrSa51ipNLACO2yXt8JXi+iInymBoAe0XBj6Zy/ldGgxwi0xxmIZYQ3tKd4jgTM70
	Rm5G1x66pGH4yTg8vl3qCuktSaE8dCCaCx4ysB/Ky3alBtSpkDGROrqEuKPMajy/subDPSr2G98
	KJioUmjMGt7wNufFIXjlFx1Bup3rUbaUGUWtQKxA1Sgzr4vhL2ItU6d3qk5471LUwMxglfSS4eZ
	doW3tpEldVF9iuboirvbyEhkLq96ytljonwZcsjb/g92b+IPRfnGTn2Ve18/DBuLCwBBULSlPKL
	rQ/LstCDvN5fFKLt/gSxxLDtsYcyW8qGGOFbpArhmIGYnjYy14Qg8bN4kcSzJTUCgaz8yAh7Hhm
	wozCAplgnU8DpbRDFEoDAcrWYBu8ozjzAeiYyyce1nSOGKApZKXEWL9XYb7Cs75+d8K9c1lYIkv
	XF8YYq2
X-Received: by 2002:a05:620a:444b:b0:8c5:310d:3b2a with SMTP id af79cd13be357-8c70b86793amr829909085a.19.1769654900885;
        Wed, 28 Jan 2026 18:48:20 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711b7d169sm305514085a.4.2026.01.28.18.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 18:48:20 -0800 (PST)
Date: Wed, 28 Jan 2026 21:48:18 -0500
From: Gregory Price <gourry@gourry.net>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
	david@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	bingjiao@google.com, jonathan.cameron@huawei.com,
	pratyush.brahma@oss.qualcomm.com
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
Message-ID: <aXrKctiYCIAGyOWV@gourry-fedora-PF4VCD3F>
References: <20260113081453.8293-4-akinobu.mita@gmail.com>
 <aWZLZzo5Hb1aFZ0j@tiehlicka>
 <CAC5umyib=XmPkTvRT6eAsMx+WDx0NkSP9djh4xkhLJgwk_v8Mw@mail.gmail.com>
 <aWfXHKDzoQBsHxAp@gourry-fedora-PF4VCD3F>
 <CAC5umyg+wubKoQSfpDQvNh3K5Y7+iOEYn6_BuKFd53kHDVE7aw@mail.gmail.com>
 <CAC5umyjOgZE0Qpa3W3qZ=sSkwkuf_md47jctXgi5UKWuG49o1Q@mail.gmail.com>
 <aXJSlv1_K1uQCN16@gourry-fedora-PF4VCD3F>
 <CAC5umyhrcb963mA9dUaZswJKq2MF_OVaipNmy=L4J7u6rPjfqA@mail.gmail.com>
 <aXksUiwYGwad5JvC@gourry-fedora-PF4VCD3F>
 <CAC5umyi6oW9qZZH75Owitojd+wgTGrz6uHsEFXxzo8aWF7FoKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC5umyi6oW9qZZH75Owitojd+wgTGrz6uHsEFXxzo8aWF7FoKA@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DCFFF40008
X-Stat-Signature: bsb6tfdepjbdfd46sjrz8q9cijjqqskp
X-Rspam-User: 
X-HE-Tag: 1769654901-789869
X-HE-Meta: U2FsdGVkX1+0A95zoF34z5btVJamdH48k+FnAYr+/W68vV6Wadw8FCCTJifr1P2Rfc9c9aMojNwPJbQ1Wb43nwsmGeMf/d/RQLB1JCUnvCjaFEOSSW79gxIzht4OAqrwdcUXF2oSWtbxn8TOzAArWNqTaNiNM4alB80dzzw95DwCA8L1njCMnNWexI34PHPqIMCn9iEV5h0/ATUmsBcKlBdE8Iv+FO27fQJ7uym27sEh+/ddXcM5oOJXNBwf0MSQLAgZgzWrPkVmsc7+mAtaZSheeJKIu5D9XAQjxFgB86xfBC0ID1Ymwmh2WoDUBZ9HgcbPbUEGle6bixxfAeVn0dza9ui21CJqdyhOb/ESN8xRF3ockUDjHwBm7JwsE5C7jCwON3Zrqfc1L4Hy2yOTpbGABDiLj2tN+N0loZkjIagYY9kTx99MMHTjbjBJAahVIB9GLBBL6FYgi+7JRLXSfhjcE9kNR6WM7E/+nJhXpZOa4MTSVZE6XF0yHixYTxDvaM6pIhMKnKRs4E+kKQWEetg75BjZAAsx5hQRzvbtCvbsLswBCnfPyXdZutWALY3eKYhgJ6b/Kpivhp+OKUWWJxSLzRAZy4W/LmvDWWd/YfdwejNwLKns6rlxm4UQ/bOR4g7FNmFpSLHXTyprtt8sMWKbRGw9hRq6oDPuYJR3Li+neWTma5gUB3VcgF+qQRn82XRUWTelTJQzFmGTzie3p3OGyHs49Vok7GLw3bhzCBcRwQeou9Ie+T6JmURDqXviRbOoLe3EM8zrqMzen4hn3fAVcXpJgwks++mLCYyorb9s8xaTIaxdLzGKcIFUhIfpSRwYM985CSO0HYg3EwkfQ1oPlyvdoPzPoc3LXg6wmLyyYoKNimie3whiJyd9+B57LtP+9l9TkiT4BEyEwO4dNF6JM1o3Hb3yX/4YHXV1EXLcvwqSyscR1qoY2y9UJ9sjUfhoEt/BoKbiCEgHxkp
 Y74JwMI8
 Q5nvSWuMIlTQ+FVf5zq1BdaSqddjiatnQN5bs97hGazuKN3WF1cZjrKdaGZ22aXm/aoJMa6RXucvPu2cZp8TTItqePRoUaeU+ghm6nFz9U8uGp0wBry5stJ0NYpa1RFmSv/rdmlWYYxx7/TgCJ+I3PqdVSH0aL98DHdsmoDzjPASteSkzstbfhejNqBNspXLQCk5alIG2wxfn+SXdq2qvO4/HisA7/YyCG/oYTbr2FM4ijQP7Clwt4Mug70gjoxx9jv+JMZAzFuvI2xP4XyhhFEItO8o90R4y0L4HivE1drqWJXak5WVIbiQKo83pDrYQt0PrucWUchMWHlcyrpek9EP8vvwOTTanKUILhX7Y1vQdZkNFiTr/6sG28UAlJHiRGiSt6F71lfzomwry1/eV7NTiZPYdYJUL9xokgwjoBnEPtvU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 09:51:44AM +0900, Akinobu Mita wrote:
> > I'm not sure there's a best-option here, we may need additional input to
> > determine what the least-worst option is.  Causing LRU inversion when
> > all the nodes are pressured but swap is available is not preferable.
> 
> Would it be better if can_demote() returned false after checking that
> there is no free swap space at all and that there is not enough free space
> on the demote target node or its lower nodes?
>

I need some time to think on this.

If we take your patch, I think we essentially default to the same
behavior as-if demotion was wholesale disabled in the first place -
toptier nodes would reclaim space directly into swap.  zswap would
probably get skipped if we're already in direct reclaim (if we can't
allocate a page, neither can zswap).

The alternative is reclaim makes absolutely no progress, even if there
is (z)swap space available - which is essentially what you're
experiencing.

Maybe there is an argument for simply falling back to swap if there's no
room on any node further away.

Will ponder this for a bit and get back to you.

~Gregory

