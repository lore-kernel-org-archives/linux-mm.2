Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C56B2FEFB47
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 12:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD1976B0005; Fri, 27 Feb 2026 07:51:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7F776B0088; Fri, 27 Feb 2026 07:51:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98B866B0089; Fri, 27 Feb 2026 07:51:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8279C6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:51:41 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E628140653
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:51:41 +0000 (UTC)
X-FDA: 84490223202.23.E2B5CAB
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 08D5F100005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:51:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=jHhtxwar;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772196699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJsL5ft8+uR36go2nZZ3KkNMsYpE/8dDd7y8kbPIygc=;
	b=PKGSx6xSvL4k/ag5FJob+zp6C5QrLBM8dgrFfMNL+lE4aEK6uBx72W3/JO13V4e6g01lkR
	PDXCfQhKPEGAEmWMlYPEJjIX2Pa3mG+6nsOuWk3XwYopW7Tpc4CXYaVgtqjvjUhy+8KEdh
	y5kXNBK5BGvakvOaB4mg6+WGZm4MTRQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=jHhtxwar;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772196699; a=rsa-sha256;
	cv=none;
	b=1AY33bUcwlPJ9DeZ5Vfg7hMqmdz6sggi3LUkg6FFnxaBaXgIYH7YkGwjBneofXtxzTwD4a
	dvpTPC86tFzDsj8/f2YS7PjVQyiT2fm9bHU6sNCZrFGT4jxIuCtZAO6tmlLeiMj36IdRCS
	JMLQe5Phi7t4ttvIzLupHbRVOEAc2Ww=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cb38e86cf2so204805985a.1
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772196698; x=1772801498; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aJsL5ft8+uR36go2nZZ3KkNMsYpE/8dDd7y8kbPIygc=;
        b=jHhtxwardLNMrMznEDbFawFHR4v3LQW0AAzlg+tQVIyPYst+VMrnN0mvhS9PRd9jYB
         ETI5/u1wuqdrpOUmV83mPvu9VyjZ8hPdwraXApanX2xtM69GbCt+Bn3mFEH2ERAYXRlX
         MzPv7q8O2B/d5hLsE79ADtc5wadu1GDheSl5mgOKCAKrYYwbF+gWMLRaUT2oP6e2GmD5
         MSjQ7iNM6TQd/Yc/8CKoKQyekQLrOUfOHQEZn95l81upYV92qJDXU02njRFd+8pchTYp
         4fqggwjsh15N82am/4CZYtlepKnIj2MoIUm9Aj5k2l5EUbha3ziy4NigNbGLj7+pT/XE
         URzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772196698; x=1772801498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aJsL5ft8+uR36go2nZZ3KkNMsYpE/8dDd7y8kbPIygc=;
        b=mdDUtFVt1YqlYpci/+SuxK51dyyiDKAGloKTxlq4zAC92kaFTzzTBW4h2RN8RHjL0s
         NVKrau3ytIxqxWm21aX6zbVZzW+Och3aQ2VwJBzbQMk6+zUoJNyc6ousu9ogiWbZAXGe
         XiIKmGZ/HAtvNH9yskoe52MGzd2//vhyPPaM1Upa/6KPMLGQXxyuFN8eH3zvVUvN7qDN
         6gH49y4gnd2Bm7hazXfl7TMI/MxDxbuBkOtemKY+w2WarAcAXDV+NC2sjv0SHFA+Knkr
         3eD604bQZYz84UD4pwpEzNp/wDBcuwNYGXyqgHbLU5LfyUwojcxMZMAwSKgWakFDKLhn
         JYMw==
X-Forwarded-Encrypted: i=1; AJvYcCUWEY6cATNINwdvMdB87yCQzsU3RCaWcddJcyVejygNwqvhuJrJzKGTJdyUV5qyg46aJtMvdeKiFg==@kvack.org
X-Gm-Message-State: AOJu0YxlsjOP5zY5vxsDQQ0AENJLlHdxRliCbKuKsetdSyTll+xv1piZ
	rSToaolG2WUvbAtunYaOxFnIp3iRusza2gEQMsjl47D+I0X6HtvEoLTkBcvG7JyIFZA=
X-Gm-Gg: ATEYQzyzIWOSDBw0dOzGTW9L8UszpWv4V3SC/yS07dHhJSQcOz3EGvmvv2SNClRoeab
	RXxbOFzsWCTFy8JTfeAdIOM73CAViH5NhFDy6hToeF4urUPE3qUCFbTpt5RMC82IrmPgGV5DlWk
	6HZEb4Cm0A5WDHC2S2sDBqma8H+cUwneWa15etkh0oBBAl+nXofiMVjBT2q7RL2wRAgo5htBAK2
	/efI4JWyZUUtNorU8XVD0bWXwg6yK/kVKOlKBs2RZmyiQJjp6MLhjU2NHJauRdwVSBtaWqb1PDr
	xUSPpXAUB4mmIvsBzuRO5EiTQWhMrNs8Xm3WgqZYm/dg8Uau/XEZvGDO25ZPGTk9qIhzL9/bo6F
	dRyB3p4J00z+Qy5LoU0atm4+SqNVqO6Osaz4w5sr9r5QtAwSZWp6jEzioYSiIdPsWF36OoMNj04
	mw+g1r1ollDUgktCQjfK3NSQ==
X-Received: by 2002:a05:620a:318d:b0:8ca:3c67:891a with SMTP id af79cd13be357-8cbc8e0515cmr303454985a.52.1772196697812;
        Fri, 27 Feb 2026 04:51:37 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf68b014sm472521085a.21.2026.02.27.04.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 04:51:36 -0800 (PST)
Date: Fri, 27 Feb 2026 07:51:33 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hao Li <hao.li@linux.dev>
Cc: mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	vbabka@suse.cz, harry.yoo@oracle.com, muchun.song@linux.dev,
	akpm@linux-foundation.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] memcg: fix slab accounting in refill_obj_stock() trylock
 path
Message-ID: <aaGTVWumz4jYEx9L@cmpxchg.org>
References: <20260226115145.62903-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226115145.62903-1-hao.li@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 08D5F100005
X-Stat-Signature: qgnddo78dap858aiizhmum5dijd6k661
X-Rspam-User: 
X-HE-Tag: 1772196698-619294
X-HE-Meta: U2FsdGVkX18TXQ9A6nVwCYFaC+uWQ9SyciJq7kIUPCpwrmIQU7uMKbmJjp2fFUKTo8pI9QsXdrEjMZbOXULREboTCOb96Z2zfME0DPyhrBqxnD+USBl/Mkw85H7oBFLiEaRPETMbVgesFr8Xw+pyVwAtC9g9JhkbIH6CeppmnArdQRcNw62mXvQz0uNSKhQBRr7Vqcz7V8AF2XpRPfciQzK12nzhCBooMvrwCCTxWw5fN+y52wJD5mVm0bWalCDGP51OCbatzj4dh68jceL7CTd0kkzMnBTWb7rSOHbBAt7QtpUzH/bGiuJjIzZK6/0yCu1f0TlqO485XDgd/nRUdfRWAE71QggIU0sUXIBHQJIh2IG1Fw4WrFiQ6ZTF4QS4iwYpXOAE+G4Zrv/zKGrZn3qi1Mvt6TBeE0Exwb5AcXEJvzbH0AtV47Garcmhw3a8ylgfDPVEHBb9mpa3RFVz4/Hx9ZKXQF7nU7ZNznBlI4f5S0JjCLtjGt2G0peQdmn4e02hfLlRh1ntMFfQnoEszCfRKT752WLhE8JWD1/rUVjFE5NK90ALhSKBLGaRL1j4s3xTDwJLk6LpuIC7etq6SmPMOeuQa4RcGbzerOpDF8OGCLLuP8xOZMHNq8NGxDMtlZzXAckAMW4zBY1s4qg6yuqpkyZW5NataaOzYFBKB+T47RN+gfpWlJ8cwyO5/4FirpcEsq7pgBch9dAjc1N0QkFM8F6Ydtsd+o9a42KLwZPuiJIs/OQFA2Ac9y01ZHefQdx+uEUh05gPUPXuEwCoGrldsSPc6VpQyOjeJw6Q2x9UNrvwRWUmhnJNYaE4n7KRJZGdj9N1yeJi9vKUbyu8H5a5q5YVpA9s1vnQNcLcTWmi4F5ZxgkLbDalmImJAdphY0m7uNwlmpZIXNUtKVLWPsnE3R9trkYH3jkFaoPuPccSMYTS6/4fe0zP9W3Z9wuSiB/WWXGCJewyDdM3Q68
 uZarix8Z
 mPnRlyfFYJsK+uy0/4abSD56YUApyyK+YbT4gahZ+YGWQkxs5pVWEM09h5sgdqUwCV7MXDM18krIbJYR9PTSKhXPpwuMWObqxeKowvacEAohiat1uVvIfw69fblnziToUVtGpqPkCkb6PK/00r3BY6YjkO5ddPK4RxjxM5Dd1xXkM4/N29RMRSvML4udCVWc493u+9RkQu0B2WtTaR/VXfw5LVBOUaVwpYpOruFmtTODgJKleYoRgfNHqZrvyO2XFMH9Cc6qrWWmgTYJ2SPh0u12Qa9yPxgerqYzlP8q1fWBXedIqHoEDLG//Spd6geHAvW+5blwN3OTe/0boBTOHc4HwphqoEbnCXEGH2tJ1TuVeLIT59iP7FhRZuQYg6jnBt38PbO8zSi5jEj2+mSz3wx1xMgntlmheFc2LAMKLWrQm5ksC7XoVywTgXVO99wM5XqEBzFUNGCleBzIvd9efoY7/OONUWN/j8esDS8Og3mR/ndOVIWoIsvurUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 07:51:37PM +0800, Hao Li wrote:
> In the trylock path of refill_obj_stock(), mod_objcg_mlstate() should
> use the real alloc/free bytes (i.e., nr_acct) for accounting, rather
> than nr_bytes.
> 
> Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Li <hao.li@linux.dev>

Oops. Yes, I suppose the contended case is quite rare (this is CPU
local), so I'm not surprised this went unnoticed for so long.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

