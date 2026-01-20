Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99211CA5FD1
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 18:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A5CA6B0481; Tue, 20 Jan 2026 13:18:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029686B0482; Tue, 20 Jan 2026 13:18:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E772A6B0483; Tue, 20 Jan 2026 13:18:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D4D236B0481
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:18:55 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DFBEB7A0C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:18:55 +0000 (UTC)
X-FDA: 84353153430.27.D734B0B
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id A4AC6C0008
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:18:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WQqAXVvw;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768933133; a=rsa-sha256;
	cv=none;
	b=OEQa0IpvSV6c9KxOmapq+WejEGzIrBKLCnIRGt25uCGJ62iNe+ILFCmV6o3rL4ZStLTDIS
	13LOcmYDpzSEJuE+TnuHFtAslNqM3ZwWhWbfSg9PFYp4R6kBex78k8ZNjFtw3pLexTohwz
	rUC/yoc/RhNujgYJlBxZbZugMvXjK+Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WQqAXVvw;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768933133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UtgC14b32AkerxxtW7iTRCLeOq1ZZH1b7K2qfFqW7v4=;
	b=TNqJwpjA0s+zivb8dwM61S/dlCE10RGspaMxTH8cFkKq1ZBSBM0zaYlD2fI0pwhKBqVQoP
	rbFyhIm3dC6G/DsvK7pf5KIuIJD2pIQcH8oB4YuBeMN7CdxpMO56j+8GP5nXCh5mOLNufa
	rHhXFTcc0oSj76PRsYfvI/nMXjA0eMY=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5014d4ddb54so60598351cf.1
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768933132; x=1769537932; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UtgC14b32AkerxxtW7iTRCLeOq1ZZH1b7K2qfFqW7v4=;
        b=WQqAXVvwcfEN/tYBKxAvRa25W0++3faLKjjz3hy6b7xqBME7N5ZvbZKxxfQXDHR5qO
         Abm4BXeHA+zTZaSpqlNaWojgsxCCudotINnvmSvMHJnjPEgPWxLCTipT4/RvHmexN6ST
         jKtU3CXkbnaNMAZoMqlMwlhoJvHkYQ0Qn/3/DCgVZLyq/rIpOsEJyVwjxyea79mywcN+
         E/K3Ua029vtZEOnqzv281EG+31m1MKovKEmzM/LwzC/oA8w1O1EPNDm7QOqQN7SvLmZJ
         qZpmARLUbYwVeXZ3hnKMZY22+oUMoBA5LuFnadpEC8EkJko7Zv4WFu2RaEj5Dn8UR/3e
         M5Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768933132; x=1769537932;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UtgC14b32AkerxxtW7iTRCLeOq1ZZH1b7K2qfFqW7v4=;
        b=ZQdjHJ2MZNgw2CMW/Rx2CSCJtp2g5z7MHMic5+k6d+kXhIb/LidjnGf2bxCovM0wwE
         9dGzHdqisBQ9YsQOqHyVfSK2dc+K8YSh1yDKBcxvYbZABRdxdVf4GgRO4sD71ys2FFbX
         yernHTtoJHweGLAQA4W7uREjhFP5oIcRW11ijgM1t3ObU6iTU/PPWaY9vCkcsgQk9eCm
         B1Fy1c+IRCLaT2TZ4UhCn3nIx7r2l39/mQkmayla6sz8rvoJSm8908wzHaHLyrxC7yeE
         79Kf20cdRUWez5Kfuh211j3s34v1X/Ioub5iz8a6uK1wkmNjnYtfMkncK6E0gh2A93A3
         zWhQ==
X-Forwarded-Encrypted: i=1; AJvYcCW31duBEFRDLF6eJ11q2lUOFnlXVvRgoBX0g58mGfNuGbPU4J5GQYnkqyDdtsjKdwmdBYO+7j6HUQ==@kvack.org
X-Gm-Message-State: AOJu0Yywy6YQs5iVduNv6njujgaYAnlUYPYzMOS8FXTvM0hz1Lqk/PR+
	Wkfm/MYEwnyqPs4sJxcjzVPomRBp737ZONv/P7cpcHIu+MOPkRvytB9thGdcVZKRnzrNwjS5ZkM
	42tqxLLs=
X-Gm-Gg: AY/fxX6+0/4OTKDBHno4RThpiv+OXizm1BkXinPXm/J0vklXhADFba2x5bm+ZnoQWFO
	YbSWQqcauZLN6tniQhHeDmgVkTpXhNMTWcXZJwUHO6dJVsUb1gE3lIX1S91jfjmQfqHndNbQtiW
	FJBc9qiJ6fuOehimBP21NxByHiVcJRjDK+lMDJsV6GLnS8ALoN7SfvMb4eU+3/nTLotyWLuumtg
	Lkc/TDpZEIc6VzWYz57M2ezDpz+630zmoymUY084ycwq5/G66j5SEV+ErzlRXyNcBJlQdKzQEJ6
	JhZwOx0SrOzmoOJ26gpPsr7soTMAhaJcRvO3vNtLhBvpLkM0qN8Wubb/SNL8PdGolHsubao0Mwn
	rEQhZOp8e8u9E8BRZCPS1wItzFg5wcgdBofaprqRMywpncs3mrKGFhf2WmBlOygoTQ4Gkmtjwrx
	6esiGIRLgRD1K4CIHth3g/kxx4JPrPtc3kzqX3H/CPHGmOuk7vHiQG3bxD6Khl/UCzLaoOpfJQl
	r5wERpy
X-Received: by 2002:ac8:7d93:0:b0:501:459b:6138 with SMTP id d75a77b69052e-502a179c71emr233059251cf.65.1768933132218;
        Tue, 20 Jan 2026 10:18:52 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-502a1d6e67csm94446971cf.7.2026.01.20.10.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 10:18:51 -0800 (PST)
Date: Tue, 20 Jan 2026 13:18:19 -0500
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: david.laight.linux@gmail.com, akpm@linux-foundation.org,
	ankur.a.arora@oracle.com, dan.j.williams@intel.com,
	dave@stgolabs.net, david@kernel.org, fvdl@google.com,
	joao.m.martins@oracle.com, jonathan.cameron@huawei.com,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, mhocko@suse.com, mjguzik@gmail.com,
	muchun.song@linux.dev, osalvador@suse.de, raghavendra.kt@amd.com,
	wangzhou1@hisilicon.com, zhanjie9@hisilicon.com
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
Message-ID: <aW_G66HeWLbyiPHs@gourry-fedora-PF4VCD3F>
References: <20260120094744.5d92e34a@pumpkin>
 <20260120103949.7673-1-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260120103949.7673-1-lizhe.67@bytedance.com>
X-Stat-Signature: yj4o4asrpftssjr8nhyzdyh8wxozw5bn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A4AC6C0008
X-Rspam-User: 
X-HE-Tag: 1768933133-543226
X-HE-Meta: U2FsdGVkX1+30kIqLUaXNwb11f2x2/QXXpEUuA93tYqK3YehjcFJVEpSQO92J9xvH18qYPTjOYMG8Uz6SJnFHeuyFtH5M8QKjAzIR5hWV+CfndJ+CfJBFEJ901m+F+GZdckpllxA/2fwjJAb+x8M5CP80AEras0WY5aj5V+bEu4sylmnQSBXZ/weHTa4MeGpOPFUNhKYcVppBtSg7AazyxTUzTH/T99XMNHj4EWaolbFQFIzzFIv7KmP6x/JAI3BAWg+yzja535VwNPUbqE4srehtEbvSmcAy6DMd+ISrtxbpuy+QeQMgWQw+xQX3ccQrFz52sV137l2VGH8GG6OzBCQ+4e6LIF4PMxWgK/4O9JKdIBwodKNnHOOVT1csqs1ftJl6XcR0F6dViIGtH8Gj+bvd7qB6l8mRRh+qhms0TiEeChnJpXJZ3CcR+eJRovc2Bc2rS+ND2QGa5yRPWuk2DsUBYzmK4oTINJF1mvzOk0I1js9ztz/uI0EIv83+MGa7VvdyquCiuGFJZ0essX9wbpK48AgMyl9RRxysR5kHUbefKpjH4zCydEwsOtMA7kN1YklooJejxgwOcqq3i1cHzYmQkw++tQ8vJucR8qrjwZ5c4EAS21lvo319UizliMOY1+pR96d7+GIDxVepa+2ws/Y67sZbnrwLg7pWMLX/30t9zQz3A5tdDB8jc5A8pRYhK4KsVsrFumLDN7KcrQ0H2FndNwp9RDZffSowZW13sjlrbEB00dpMw3xKY+dBbx99yHS+BqrnkMnVqNbsx+y/H/SOen7wCcRd01X44FsQdT/63TD8gddq/Y0h91IgGaa2nCqTbHWFZfYRt395xrjRByKT9ZxWK2GHI7Zir/IWIb1bp0mPupcQUk8I6eDKhJQ1rkwnigLaG1IGmndyzxrv/5iofk6OlHcGZYKQ3X+gE1ez32qDZoF+obLdJreHUVrhYKiI9DzQZFOkoXN4kP
 hlGT2cT5
 134zQXxEy3wzj1RJlSmFicxqW4DOuDCgPaHE1q68X/VAaczHJK1bjUzXzHdeLT8np5gv6pCDC62bIp3hjujU82SUDTCAvXzFrHZPM5jk9bhePoTkW34XNq49D4lenHptsKaYG0yZoy7AtxNIbmlUCfNmFNEix2Lc5h/hHrgXrpGah57FBgsnGRntmhu6sYtYnm0fM1ymaxL33VBVZPTPcNRb8VbulRKB46k958QEz75uYABwYx2LlZf+p3Z14fOQCsBKDe9Us90F7cmxLNxPYDrDh2+ipM+8xVR7toOiA1X2Lfp+wAWFUKez9jz9zH+3oFK6xl183+amWsf4g7xpsbCGHBAMlgUb378LQOVzGNiqYgmr93Q83jGpxFPz94PT7GYWU1SecV3naDea11aAvGNsBFWMj8WNzAx+YoVyqrcOKzdLYEJHXbax7UmJQLsETUk3SmrTX3T/ZOZ1iGeJyUJCNMrv/fSG1cXS4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 06:39:48PM +0800, Li Zhe wrote:
> On Tue, 20 Jan 2026 09:47:44 +0000, david.laight.linux@gmail.com wrote:
> 
> > On Tue, 20 Jan 2026 14:27:06 +0800
> > "Li Zhe" <lizhe.67@bytedance.com> wrote:
> > 
> > > In light of the preceding discussion, we appear to have reached the
> > > following understanding:
> > > 
> > > (1) At present we prefer to mitigate slow application startup (e.g.,
> > > VM creation) by zeroing huge pages at the moment they are freed
> > > (init_on_free). The principal benefit is that user space gains the
> > > performance improvement without deploying any additional user space
> > > daemon.
> > 
> > Am I missing something?
> > If userspace does:
> > $ program_a; program_b
> > and pages used by program_a are zeroed when it exits you get the delay
> > for zeroing all the pages it used before program_b starts.
> > OTOH if the zeroing is deferred program_b only needs to zero the pages
> > it needs to start (and there may be some lurking).
> 
> Under the init_on-free approach, improving the speed of zeroing may
> indeed prove necessary.
> 
> However, I believe we should first reach consensus on adopting
> “init_on_free” as the solution to slow application startup before
> turning to performance tuning.
> 

His point was init_on_free may not actually reduce any delays on serial
applications, and can actually introduce additional delays.

Example
-------
program_a:  alloc_hugepages(10);
            exit();

program b:  alloc_hugepages(5);
	    exit();

/* Run programs in serial */
sh:  program_a && program_b

in zero_on_alloc():
	program_a eats zero(10) cost on startup
	program_b eats zero(5) cost on startup
	Overall zero(15) cost to start program_b

in zero_on_free()
	program_a eats zero(10) cost on startup
	program_a eats zero(10) cost on exit
	program_b eats zero(0) cost on startup
	Overall zero(20) cost to start program_b

zero_on_free is worse by zero(5)
-------

This is a trivial example, but it's unclear zero_on_free actually
provides a benefit.  You have to know ahead of time what the runtime
behavior, pre-zeroed count, and allocation pattern (0->10->5->...) would
be to determine whether there's an actual reduction in startup time.

But just trivially, starting from the base case of no pages being
zeroed, you're just injecting an additional zero(X) cost if program_a()
consumes more hugepages than program_b().

Long way of saying the shift from alloc to free seems heuristic-y and
you need stronger analysis / better data to show this change is actually
beneficial in the general case.

~Gregory

