Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF74CD2628A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 18:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1279B6B0496; Tue, 20 Jan 2026 13:58:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FFD06B0498; Tue, 20 Jan 2026 13:58:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0018F6B0499; Tue, 20 Jan 2026 13:58:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E127D6B0496
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:58:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72AF813B92D
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:58:12 +0000 (UTC)
X-FDA: 84353252424.14.9C6B43C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E1390180010
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:58:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GhB7IVkw;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768935490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ytTCX43YaWLKtzXMqmoIG0r0Wwfc5JFXaC5vs4GyATw=;
	b=Qtj8OdEgSOmbVJVczn/bWyme/gLF14MZxa8zMSEXPt0RaxY8tICNlihjiRUFLCHj7kuAu3
	5gN72eyR3E72NL0p5xIy839Oran/4gTLUim053gkP0jPHFVXHHeLXSAZcVzs365z0AUFd0
	MT0LOkxf4eamlz1+DeLlLf04L0d9a2s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GhB7IVkw;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768935490; a=rsa-sha256;
	cv=none;
	b=fwGWlgfTUkm7eCfs4xva81VYJikpVIxJ9eJV2fzn4wVaEv/rwtsMajwfXi5O+Lv+J51c7N
	w1tBzuNGUFkbrWeUUS7aBte5djKVsDEkPUEhTcPDIB3c6c34NdvZLzadnDD4tlyz3s/3zq
	nUzRu4LLaytU1xvR/g2EMN2DJFBFqTI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 46E7A6001A;
	Tue, 20 Jan 2026 18:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEA8C16AAE;
	Tue, 20 Jan 2026 18:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768935490;
	bh=I5q0oGB+BoA/gz8qsotA61iskY7SDlYKob9LdnVdGNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GhB7IVkwG/XveGj1F09VZwJYfZ6BTg7yXMg4IEJIePaigtf7knr23e4MQvTMxS+XR
	 3XGbUKDlpl5+VcPlQFcjc3V9gDkHfwLhvQtn1622KVxhrL30oJc5/p1DDSVoy5b+oK
	 gBhlEsuMf2+/UQWGOlx0kq6hZGbVeB28j90YZPDymuuRHHHrT0mJOWLA4U3nnby16v
	 xCMZ/fk+eOp/cSZbaK58BPKykl50BWitcslIvDcc3KdijKzNQ8tUR6m4ERC7oTDGHh
	 8D5Dnc+dFsby36GI2D0phtpjip1EDcbHqJ8Lu/KtkMuKJMuTGQxieNcRvQdi2kptia
	 B2purnqkBT7Ig==
Date: Tue, 20 Jan 2026 20:58:02 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Breno Leitao <leitao@debian.org>, Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com,
	clm@fb.com, riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH v3 1/2] kho: history: track previous kernel version
Message-ID: <aW_QOpA1ocySNLAF@kernel.org>
References: <20260108-kho-v3-0-b1d6b7a89342@debian.org>
 <20260108-kho-v3-1-b1d6b7a89342@debian.org>
 <2vxzy0m0gfyo.fsf@kernel.org>
 <v7g7nmd3jif6vftvnmucvpluevufcdxmefcgqq3yfpnzyb7mql@ojpotuu4hgxm>
 <2vxzms28e1ib.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzms28e1ib.fsf@kernel.org>
X-Rspamd-Queue-Id: E1390180010
X-Stat-Signature: hz7zgzjwika573fspg7qh43bw9i7po8o
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768935490-134749
X-HE-Meta: U2FsdGVkX1/7HQUPLH3xlAWTA8PIt4kVeAvpXGLuCL5nP/YvWVqO4VYDpqN/qLmOuZ+y9Zpc/MJAnwrKi1hEiTHv0x74RhJ1I2o82w/YAP5kQ0FFphVelQ/jL3GCpzcxJgI9dRaaaxfIg+iVMhkSmpFBRh4UdXrW62EO5tnvN5JQ+u4vzK9qHjpoeQBF2/+0LQimkA7tB0No3nNGvU0gmJalHahZDo7g66skN09YdvikAosluskejq3dHP9SmHKdp7ymHVkJ7YhlIEiy+nyf0zh1L6dNcBDgC+9KM3yqaQ5z4p1Dra7SZ73dEKSgQXtBPIXISO5x0jmd/W+At4qIzTmuM8JpPvKZw+MOzZj2w8XIH6ejV9u9uCWkg5NpEEBfmlpu2gdSm0UbWC677fb8fNOlmdG2R3TmUbZufbEQQyncGshB7UCCM4DWePOV5RTQMyvkbHu0gxNsQpTwQpRDQzVdJ2dYAtTRcvj/nz4R6R0lxlxiVuGTJQPUuHLqrigOQl1AbJ+tET87kIzYMvBe3YIjyIAGH8smoClS/scUGH4P8etCGc9gphSB1SS+Jdp8Hiz0S7f3AY9MtNCvTXRKhse+Gb2zOXhNuzjtQbdxeH5okkxNSmxMauW78z2sb8j6kiMBQLBgV2/EWHmhHrijl3z5WVJMEhpDzjX00Ws/lqr/cYYDZEXHLbUXee2QJvLDv4/tWiNUsmPhjsk96pxv2BQEr2Iih798iIlh1/Ps4gGsc9VV05I60/eiTmncmxCUBxkjXgFCbB+xxqnduUt3zUzMD5uqmY4NxsHuPxNjVp6+CthY5REjTXtYhnMKGcG1HrqD2b50W1TJjPm4o5Bo2FiqcysmBRliU3bIhWRUb02OZN7uUdKFhdBooXC0yZb9KmFMlFZHwze1SLfca2a3CZGfrofVr8n99Bh3fyAW5wOrGwVM2pCOHAt3Vtu7WsPJEVJpeKZnfhHvIzX1bEE
 /oJceSNn
 SHwj991SHoGU8bSRpbMef0gbRn2pfWGRdxU04i8xOW7mHRZBT5T7h296xbjH5vXxGItH3YUvFwSzQtZXsrtrlhDDJNFxmdw2KfB4GY0RmJm8Y0fC7eE8klpg+0K8vc/iIj3uwJLLELqZJj9mGwmU467FGPPPQ8J6yArasmpbj9uUnhUbsnhuOJqQvYGRgW8tinNj1I2M5H//FNg2QCp97qbSVlWwbVHnc1u936w8eroo0l1PdGirB3RZ6GIfe+ePgbluy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, Jan 20, 2026 at 03:40:12PM +0000, Pratyush Yadav wrote:
> On Fri, Jan 16 2026, Breno Leitao wrote:
> >     
> >     On cold boot, kexec-count starts at 0 and increments with each kexec.
> >     The count helps identify issues that only manifest after multiple
> >     consecutive kexec reboots.
> 
> Very well written changelog!

@Breno, the submission would be perfect if you'd start a new thread rather
than reply to v1 ;-)
 
> > +/*
> > + * The "history" subtree stores optional metadata about the kexec chain.
> > + * It is registered as a separate FDT via kho_add_subtree(), keeping it
> > + * independent from the core KHO ABI. This allows the history format to
> > + * evolve without affecting other KHO consumers.
> > + *
> > + * The history FDT structure:
> 
> I don't have a strong preference here, but you don't _have_ to use FDT.
> For example, with memfd, we moved from FDT to plain C structs during the
> evolution of the patchset. Main reason is that FDT programming is a bit
> annoying. C structs make many things much easier. For example, you can
> always assume a certain property always exists and is of a given size,
> and you don't have to validate every single property you read.
> 
> Anyway, I don't mind either way.

Yeah, I agree that a plain C structure with an array of chars and u64 will
make things simpler.

> > + *
> > + *   / {
> > + *       compatible = "kho-history-v1";
> > + *       previous-release = "6.x.y-...";
> > + *       kexec-count = <N>;
> > + *   };
> > + */
> > +#define KHO_HISTORY_NODE_NAME "history"
> 
> Do we want to call it history? Perhaps "kexec-metadata" instead? So we
> could use it for other misc information if needed later.
> 
> Mike/Pasha, any thoughts?

I like kexec-metadata.

-- 
Sincerely yours,
Mike.

