Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BF0AD61013
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 13:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFF556B0088; Thu, 29 Jan 2026 08:42:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECCD56B0089; Thu, 29 Jan 2026 08:42:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAB2B6B008A; Thu, 29 Jan 2026 08:42:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C6B176B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:42:49 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F03414014F
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:42:49 +0000 (UTC)
X-FDA: 84385116858.26.F3B610F
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6D82DA0016
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:42:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="CqUd/vAZ";
	spf=pass (imf25.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769694167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GDzgMbZmK6TIECiS2445LXqg7oI2wOpfTfzYF6w3p+0=;
	b=O7g0Ew7yS/Hhos39mW69msZT+5+cPXDCerQrDqufkvj016ea+yNTu62l1UJo3UkMaBTN8p
	JWp4nInLNvM9rOOdCCfO/9VmXstvAXVHeQuOC9DcfIEJ9v3cs9Ej0bcygNfm7cNB9TDTTp
	nYU7EM7DxV9Uruop+IX5LnW7pi5vlaQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="CqUd/vAZ";
	spf=pass (imf25.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769694167; a=rsa-sha256;
	cv=none;
	b=LRph9jPajn5rTSuhkIrPNRohbs42LMvwwPRQzCY0u50t9AjW7oryKWkKMfzjBFtbrCBsuB
	16m2MUxMsrIBzehxhR710k7gP2J3N2BSmJsK9M7LD9Bt2yMt3H3WsE5e/VT90n6pFmb2v0
	kV81hqsc6YsdezGmA+DBVGuBExEmWiE=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5036d7d14easo10111491cf.1
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 05:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769694166; x=1770298966; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GDzgMbZmK6TIECiS2445LXqg7oI2wOpfTfzYF6w3p+0=;
        b=CqUd/vAZS4FmkknED8BexdPYbstp7feQr0pWg4qqeor5MkZJIkPiV9Gv2epYwg5Z6W
         aWCxES9c8TX5JNhyrKzhh2FjaJPKReS+UieATyfcJ4GjbwgS4WJA8l2Hg4+MhGabC5/W
         QjQC8pz1MOx/ppnOnT98E02HNrdnnrGigPRH/GXdSUJesClry8kLOLGaZTeWHZZhbLDa
         CozqMNaeWgagt/Wi6fEwgr6KsbtBMS31djcAYx55jDSlfHnoF9FDoz3Rp9VoBkrrvT3B
         etg7jnKBqAlIGz78ZjgZhuXMicI/6KrlbC1OMriWbhIK4d8mE6DNBI7YnJed124R3OVO
         FWCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769694166; x=1770298966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GDzgMbZmK6TIECiS2445LXqg7oI2wOpfTfzYF6w3p+0=;
        b=IWioEVLXs3zDjjES81RF32Iwd5UgRMnG4vPMW9dOuc4z63mRbrFnpF/gVyLbHtM0UU
         1wZZJTmM0/8yOsvHXPfOnNTFBSwSDIQ/yFXbNppTVKi6CHsmPZIQchw72p/RETbR/pBn
         Id9Tgl0imCi/GV8kBOVNXlOzqTJzasCUl9BAWoG4B1mdEtK1g3Ts7h/xjFh0X8Aw6F/1
         z09snz8g4hfcWRfdVyeEKwVbX2bRegCBWlHG4zX9NO+w6E+ifHn3e7uVti59OhXVhuBk
         Tou7ham5CORhu5nvJDYcgXF0arXhVppyHLpKpK0HdwCod8mnhcHZp6QO6B03A+QQQkFs
         0EYw==
X-Forwarded-Encrypted: i=1; AJvYcCUoKZdrYlW3VbRcgSDLPaRm2p0UCSL+jzfK+Mrum8gRrFENDhV1C94//zKIZLR2YIDXLT0TV8+saw==@kvack.org
X-Gm-Message-State: AOJu0Yzstev900aaH56RW0X+F/51ZnwQCtoXJyxt63hM8TplmiaBUXiz
	iwp1IU7BmGZiuozK3LcIMa3fatoN6Oqz3T65WZMlxcr6UZJR14Ye9OAw50cWWlsBStI=
X-Gm-Gg: AZuq6aIxi2AGsETgK0XOzjEtYkEx4jtggInFji0VR87vqXh3Jbq3uKWJUhwE0iHZ0jA
	W2UFWNbCg6nsBFn409A/L5puF84LOs7fS3PAeq8ChEnolBd5KaGZ01NC7uec0Ei8DEGvrNHe4Gf
	eMUVZwaTiAgZULZ7InYQEE0ZwZwx7k9m0gIls/NQ3lQsaGBjnuQgNQZhrJRNzToumwFCQOFxpX2
	J9bGymeEb1s/AfFVxhiH340i3AUaorTUbB4bgkrtTVm/90c4euK8cfdjJklXzx2RmdlLmjf+AXk
	v3e25BDUS19j/hCWP9Rx7ZyTXCnOqjewsANvSoBkgDZwoi6LKv1Apilfo66xUEb1VVSwKZXX8CH
	AhOGHQ9Auc68i/MMqD905IE5wfXkEJP4V9RUPEQLGjXZbIf2KKzsrRaYVA0R+Hy38PTLse7ZXR/
	LJvfFTEMYICkzioFjRFUz445trxllKBJBYx76984IRCGYQENSNoEmqK6oji7Sb+BcjNMU=
X-Received: by 2002:a05:622a:15c6:b0:4ee:1563:2829 with SMTP id d75a77b69052e-5032fa1cc0fmr108491201cf.72.1769694166378;
        Thu, 29 Jan 2026 05:42:46 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d3764eb6sm37167556d6.49.2026.01.29.05.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 05:42:45 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vlSIH-00000009jxt-1Mph;
	Thu, 29 Jan 2026 09:42:45 -0400
Date: Thu, 29 Jan 2026 09:42:45 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Quentin Perret <qperret@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Alexey Kardashevskiy <aik@amd.com>, cgroups@vger.kernel.org,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, x86@kernel.org,
	akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de,
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org,
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com,
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com,
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com,
	hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com,
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com,
	jack@suse.cz, james.morse@arm.com, jarkko@kernel.org,
	jgowans@amazon.com, jhubbard@nvidia.com, jroedel@suse.de,
	jthoughton@google.com, jun.miao@intel.com, kai.huang@intel.com,
	keirf@google.com, kent.overstreet@linux.dev,
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com,
	mail@maciej.szmigiero.name, maobibo@loongson.cn,
	mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org,
	mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com,
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au,
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es,
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com,
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com,
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz,
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com,
	rientjes@google.com, rostedt@goodmis.org, roypat@amazon.co.uk,
	rppt@kernel.org, shakeel.butt@linux.dev, shuah@kernel.org,
	steven.price@arm.com, steven.sistare@oracle.com,
	suzuki.poulose@arm.com, tabba@google.com, tglx@linutronix.de,
	thomas.lendacky@amd.com, vannapurve@google.com, vbabka@suse.cz,
	viro@zeniv.linux.org.uk, vkuznets@redhat.com, wei.w.wang@intel.com,
	will@kernel.org, willy@infradead.org, wyihan@google.com,
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com,
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Subject: Re: [RFC PATCH v1 05/37] KVM: guest_memfd: Wire up
 kvm_get_memory_attributes() to per-gmem attributes
Message-ID: <20260129134245.GD2307128@ziepe.ca>
References: <cover.1760731772.git.ackerleytng@google.com>
 <071a3c6603809186e914fe5fed939edee4e11988.1760731772.git.ackerleytng@google.com>
 <07836b1d-d0d8-40f2-8f7b-7805beca31d0@amd.com>
 <CAEvNRgEuez=JbArRf2SApLAL0usv5-Q6q=nBPOFMHrHGaKAtMw@mail.gmail.com>
 <20260129003753.GZ1641016@ziepe.ca>
 <aXqx3_eE0rNh6nP0@google.com>
 <20260129011618.GA2307128@ziepe.ca>
 <i22yykvttpc2e4expluuzucczqnetdnpee2wx2fzqwg7cnt45x@ovx7e7hok5iz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <i22yykvttpc2e4expluuzucczqnetdnpee2wx2fzqwg7cnt45x@ovx7e7hok5iz>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6D82DA0016
X-Stat-Signature: w13j694msdbej8scpjy9km7azpr351hm
X-Rspam-User: 
X-HE-Tag: 1769694167-60143
X-HE-Meta: U2FsdGVkX1829MOrNfP7HqFH1ea0UOq7510C0gEw7nq+vRhSN5R+L3//+dYJc1SV2zdBgrEzjDQMrkcfJRKxpjhg/2fV52wvWPbfIMyu39ScCJb0ZnRRmjMRZAo39g39SJoIFhypv90ZVaxiU+fnyHsy5mUqnFzULR/UP0KylC+I6kVezNf5lYeac6enrl9e98tL4iA1McZntt8x0UxSArRizeDZttUuxBoF1N6v/5Qz0QQrqSRRgHzsx4dKawcfirVzMOMrlRr1K9hlvNbXsdAoynZyGeJ6GOaNh2WCgHU0PmUEcAUHVreCKDPdW32BOfojo2ux0HwWQlk1fdIIU15zwqzTLOz1qbwpzSBb3rRIlkiI74GR0tnRrKHKCwe8P5rAk8XSqsD/Jpm/6TzDQ5kBchLUz4tIM8rrl8fHPYHS98H4P7kinJFpRgvsUN21grdBYWxeE4L5TfZKfUTdHT1vWs7A5fpwlQu9/tX8XrJ97F7AayTCZk406nHtTzQDwrKyWONW0I7fgY84WZuKcBj5urMtT98LeaULYyRjBJdWTFWnIo6DOH1twvXLoBpdRkU4qOkTvVZOtiAAHozrYhSbzYFXC7y2GsA8vIYVkBLq33u7/vOUpd/eyGNGDjHkWLRcaisC6gotJydx0EVxdTf/C/bjBt1qvbuwwXfaDaMHWxkm8UcEOPRvVfMfcGcy+B0LlzRWmdV5f505ZTLCE2XxsOoXlTPjWuaZlirDwiKkbTYIk4apfI5e2ezi2G+X4GMveV/wAIGTccLidJbcXYMO8x4LpDyd2K3m6h5UOOYlI+prPBJdEPNEuAGN9wKITlcVWBYK5vkf4OVK6zM+Xqab/SBWU4O59NugK2HrvTN+1FUReJAq8HaJvw/fiVXSOZOrCdiD6tOSdIzE3Iz78d/hoiF94rcCrC83g+Dx6V2TV9ejpS8O096/i+BzMr4CRH2R8ui1st4nthH+a2e
 vue0nqkH
 yJapOADJzEwSL/+56Imb95tijM9jxve8rc26dBbqJRrZY9NBE1o1axiOvZ4gIlmiRcoRw2BQKdKD24jmjdg4/UrVFk++IxCl7EJAAcd1obVgQ7LCUjdObKe8RHAxV1w/SxgSkeaLctwG5FvdgpdCBTxTvPd1C8wLIPYClV7/05AoJw7vvPrJdEOVKlEXb84JL/tiiCP+6G1XS6qg3iP1VnkETfCAakiK9z7HP5Fwbqjc7RhXOfTgn7yHpPiQKBATsb1f4j0kjO6usRBMj5dB9NWKgmhp0CpQZ2UQmAWnnQDP4+9NowNeeRUBGe8wpYhFgMCmoZiNTRrPJ7nW22ibutDYRf3PHqfy2O7vmPFBh5OmL9Y3ikMlwSS8twsUSRe8cam3cTIRVygyPH1OFEppgW5sDqt0xQUWpmdHU9GA/Uc6dMXU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 11:10:12AM +0000, Quentin Perret wrote:

> A not-fully-thought-through-and-possibly-ridiculous idea that crossed
> my mind some time ago was to make KVM itself a proper dmabuf
> importer. 

AFAIK this is already the plan. Since Intel cannot tolerate having the
private MMIO mapped into a VMA *at all* there is no other choice.

Since Intel has to build it it I figured everyone would want to use it
because it is probably going to be much faster than reading VMAs.

Especially in the modern world of MMIO BARs in the 512GB range.

> You'd essentially see a guest as a 'device' (probably with an
> actual struct dev representing it), and the stage-2 MMU in front of it
> as its IOMMU. That could potentially allow KVM to implement dma_map_ops
> for that guest 'device' by mapping/unmapping pages into its stage-2 and
> such. 

The plan isn't something so wild..

https://github.com/jgunthorpe/linux/commits/dmabuf_map_type/

The "Physical Address List" mapping type will let KVM just get a
normal phys_addr_t list and do its normal stuff with it. No need for
hacky DMA API things.

Probably what will be hard for KVM is that it gets the entire 512GB in
one shot and will have to chop it up to install the whole thing into
the PTE sizes available in the S2. I don't think it even has logic
like that right now??

> It gets really funny when a CoCo guest decides to share back a subset of
> that dmabuf with the host, and I'm still wrapping my head around how
> we'd make that work, but at this point I'm ready to be told how all the
> above already doesn't work and that I should go back to the peanut
> gallery :-)

Oh, I don't actually know how that ends up working but I suppose it
could be meaningfully done :\

Jason

