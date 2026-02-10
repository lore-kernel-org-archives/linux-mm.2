Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 862B9EA8118
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 13:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE3BF6B0005; Tue, 10 Feb 2026 08:47:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91EA6B0089; Tue, 10 Feb 2026 08:47:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B734A6B008A; Tue, 10 Feb 2026 08:47:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A4BB16B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:47:41 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64E9BC1FEC
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:47:41 +0000 (UTC)
X-FDA: 84428674722.22.3B7A225
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 04A191A000A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:47:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=e8Klf4H3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="z1Zo/KBR";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=e8Klf4H3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="z1Zo/KBR";
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770731259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5YjEW9rY5f+WC+e8I8HcxIvHHp40YBO+UXznndHs1FM=;
	b=U6Z8Ya7lhW0JHXNlny39mx2mFjcfMXTMSsnH4yt0HzbXoEY97SpoB/a2x6i6AAuVIwWNB1
	sH+FBrQ8ybuEv7MhnwNp06NHVl6R40zqHCmgUwpPT/1NEp549M6aS7dD3qz12PeJTOjBTy
	TR08rVcICo05YyhfwFR7TOGyFEU2yh8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=e8Klf4H3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="z1Zo/KBR";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=e8Klf4H3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="z1Zo/KBR";
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770731259; a=rsa-sha256;
	cv=none;
	b=kY5vriskNdr7ogzOiwpSMMyGuuhnhT5JVPSHhfaf3eiOROFy1++/WEM8VpRFFJdI39KhBG
	SNbnWzy++Lw0LDKXKBOIAr3AsIE5fhPPdnp5gvszCDL6cX2nxfhq9hrjeWVEIZtEeXil/y
	gwGGo9qWZG2x5vkflg8Jt9zvk2QbsHA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 105A83E71A;
	Tue, 10 Feb 2026 13:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770731257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5YjEW9rY5f+WC+e8I8HcxIvHHp40YBO+UXznndHs1FM=;
	b=e8Klf4H3Wf0REiYrsJ5KDGCefLcZmtsIzkYRYYqlLIPOY5fdMzBQ4u0hPQoEz5wqWsNDKB
	JQYLJqvoaXBHdzoVftKo4DT/1c+WKqX/E7bx+3nC2rZu2WGgLgYmNUD4emRew1GXsYShW7
	aM7zs4M8etINl62m0PYPBjiCP8Eq5AA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770731257;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5YjEW9rY5f+WC+e8I8HcxIvHHp40YBO+UXznndHs1FM=;
	b=z1Zo/KBRSYTQoiDNeqx4bYHpRLjWuIoYwPJ4+iFO4jOOnF8jTMIuUv26I49Su4DfEVKwHl
	s5yKw1c3fiLjWAAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770731257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5YjEW9rY5f+WC+e8I8HcxIvHHp40YBO+UXznndHs1FM=;
	b=e8Klf4H3Wf0REiYrsJ5KDGCefLcZmtsIzkYRYYqlLIPOY5fdMzBQ4u0hPQoEz5wqWsNDKB
	JQYLJqvoaXBHdzoVftKo4DT/1c+WKqX/E7bx+3nC2rZu2WGgLgYmNUD4emRew1GXsYShW7
	aM7zs4M8etINl62m0PYPBjiCP8Eq5AA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770731257;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5YjEW9rY5f+WC+e8I8HcxIvHHp40YBO+UXznndHs1FM=;
	b=z1Zo/KBRSYTQoiDNeqx4bYHpRLjWuIoYwPJ4+iFO4jOOnF8jTMIuUv26I49Su4DfEVKwHl
	s5yKw1c3fiLjWAAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC4DF3EA62;
	Tue, 10 Feb 2026 13:47:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nAesOfg2i2kZZQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Feb 2026 13:47:36 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A6F82A0A4E; Tue, 10 Feb 2026 14:47:28 +0100 (CET)
Date: Tue, 10 Feb 2026 14:47:28 +0100
From: Jan Kara <jack@suse.cz>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "chrisl@kernel.org" <chrisl@kernel.org>, "clm@meta.com" <clm@meta.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Machine Learning (ML) library in
 Linux kernel
Message-ID: <6ek3nhulz72niscw2iz2n5xhczz4ta6a6hvyrlneuyk2d36ngx@4ymlemzifugr>
References: <47d21a6821c4b2d085f7b97bcdaa205bfcb0e0ad.camel@ibm.com>
 <CACePvbVH0ovOcBqCN7kJ3n0QFmvuf+_5tMeRXs-JAQ+m5fdoCg@mail.gmail.com>
 <a994bdedca7d966168076044249a58e52754c6ac.camel@ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a994bdedca7d966168076044249a58e52754c6ac.camel@ibm.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Stat-Signature: jup9q8i735cmozghfjd14umpmbig7bzz
X-Rspamd-Queue-Id: 04A191A000A
X-Rspam-User: 
X-HE-Tag: 1770731258-646010
X-HE-Meta: U2FsdGVkX1+rUPB+c/8XboVBU3XnWJC7ZMgcsBcXGaLz/BKpYyphnKNZDUhoXLe07mqtLEgCJSd0m5t+sDUujIkUmlgI09ehwHNTAWBG1TEnyZE98R2vd2MTzMt7MIsbVORjRsvJJ+BTnUFcZLYLnwC7H1DX7U0FqhuMTafw1d5zb9bbZTQkef8tniWavVOaEfsD1PGxidLB7hIyDn2oHneAm8suWYojINOf/3pRoEjWuAWuJUW1dlNK9648zYR7b/gofTyPGvgg8y3I+UAtQZpEmpn8tpp/Co2YNeOSsRupxzi2oDZWfTyHd3Zl4R8NCshW2AJ9EfdKpJdW/PnWi4wZHZmaRR6x72Edl8Za3VLtjgpJSebNaLA+bNMf9v6qRM653+bEggkW0TaEtpI3tMzUl9hVPJbqV6v2F3oqwju0rmyqUVez7dkdSXLjaPsqJ3sxXrykg7z/FnK0SXi9SMiJEehCI/ebmMSprpNv+xeiQ5BrkUaC77Z8Jig5JqIeOqvq8S+90LigO6y0ofxAxPqgJqopimSzO1Jk59ObelX5dSNUHc/op44b73XPpDLoGKU0ktc2NXTjzNljXdEEaC2pnxygRm92gPRYXeqYtdd3H4F/2uzrH+fpLhxNke3y7krgTIeXafttnLHiXxzuTrBGb588xYU2+O0YtyF7z39kvai8X7ChOdtU4qA/IWcz1jylEMcd2HCW+vfs5zFHcD5CvyDnxiRRIp8NkMoXSmZzishmEYM3RnvtGzj6Wtpcg2B+gmpHQH2onHy7ZPi5RPEA4KLSwhX1zj+rSq8j+aFUGdMvXTj+rXK50E9B8uCHV6qrckJh4QbhFzaDMIbrKMKSMywDwNqIhfacehM28YSLb+FyzDsD/zxmi0vaCadOz8oQ/i3JistTrBzy0NjgDYirsn/Up9oeUXmY8tXNwrJbM7kQSoa/MB83xL4ZgaeGRFvM4KhGQdhekoGUpZn
 zLnBeJOi
 nMQxqbAsxXi1kazPQyvaU5oc0OOYt9bvWNVCT6QskOqdinp3z0a2Fd5AEPAEN+rU7QhejL2hUveE/qQzcr310WTQ3f1qmz51v+uGYXKoQf4wrWJyJqzqLKPGcGsSshXdPfIuBvHjTqG1xgCj8BBOF8S498UUPL5IaKG4YtWfg/fh49HargbUW/Ws3sDPSTN774r1K/V+sBnImUxT2MHLyePT3puCSZE86cZfTEheD/lVDgSRPM3NgDDpxQ4LAkMNHnTpiHV3HS9+op462nKPMu2wq5BdnlxSQd37aS6PBHMkeYHI1JRCymXAz4XVaYbvv7HEreyqUW8wdiwbTkS8G596T2isLuZqGl55PO9ybIsp7XJt7Nx6lQj34ewENk4WH9cEEiMSAxOig1dbD9irbMwCxarUPCiQ1bqVMCNcuz+MTgSUX/Cp+vnjm+4GPjpS+pFpU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 09-02-26 22:28:59, Viacheslav Dubeyko via Lsf-pc wrote:
> On Mon, 2026-02-09 at 02:03 -0800, Chris Li wrote:
> > On Fri, Feb 6, 2026 at 11:38 AM Viacheslav Dubeyko
> > <Slava.Dubeyko@ibm.com> wrote:
> > > 
> > > Hello,
> > > 
> > > Machine Learning (ML) is approach/area of learning from data,
> > > finding patterns, and making predictions without implementing algorithms
> > > by developers. The number of areas of ML applications is growing
> > > with every day. Generally speaking, ML can introduce a self-evolving and
> > > self-learning capability in Linux kernel. There are already research works
> > > and industry efforts to employ ML approaches for configuration and
> > > optimization the Linux kernel. However, introduction of ML approaches
> > > in Linux kernel is not so simple and straightforward way. There are multiple
> > > problems and unanswered questions on this road. First of all, any ML model
> > > requires the floating-point operations (FPU) for running. But there is
> > > no direct use of FPUs in kernel space. Also, ML model requires training phase
> > > that can be a reason of significant performance degradation of Linux kernel.
> > > Even inference phase could be problematic from the performance point of view
> > > on kernel side. The using of ML approaches in Linux kernel is inevitable step.
> > > But, how can we use ML approaches in Linux kernel? Which infrastructure
> > > do we need to adopt ML models in Linux kernel?
> > 
> > I think there are two different things, I think you want the latter
> > but I am not sure
> > 
> > 1) using ML model to help kernel development, code reviews, generate
> > patches by descriptions etc. For example, Chris Mason has a kernel
> > review repo on github and he is sharing his review finding the mailing
> > list:
> > https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_masoncl_review-2Dprompts_tree_main&d=DwIFaQ&c=BSDicqBQBDjDI9RkVyTcHQ&r=q5bIm4AXMzc8NJu1_RGmnQ2fMWKq4Y4RAkElvUgSs00&m=vvrDPxyw_JXPrkC8BjzA2kEtwdPfwV2gBMEXG7ZveXM4LhS01LfoGwqhEyUZpPe4&s=rqNez5_rmiEuE7in5e_7MfyUzzqzaA6Gk46WWvmN3yk&e= 
> > It is kernel development related, but the ML agent code is running in
> > the user space. The actual ML computation might run GPU/TPUs. That
> > does not seem to be what you have in mind.
> > 
> > 2) Run the ML model computation in the kernel space.
> > Can you clarify if this is what you have in mind? You mention kernel
> > FPU usage in the kernel for ML model. It is only relevant if you need
> > to run the FP in the kernel CPU instructions. Most ML computations are
> > not run in CPU instructions. They run on GPUs/TPUs. Why not keep the
> > ML program (PyTorch/agents) in the user space and pass the data to the
> > GPU/TPU driver to run? There will be some kernel instructure like
> > VFIO/IOMMU involved with the GPU/TPU driver. For the most part the
> > kernel is just facilitating the data passing to/from the GPU/TPU
> > driver then to the GPU/TPU hardware. The ML hardware is doing the
> > heavy lifting.
> 
> The idea is to have ML model running in user-space and kernel subsystem can
> interact with ML model in user-space. As the next step, I am considering two
> real-life use-cases: (1) GC subsystem of LFS file system, (2) ML-based DAMON
> approach. So, for example, GC can be represented by ML model in user-space. GC
> can request data (segments state) from kernel-space and ML model in user-space
> can do training or/and inference. As a result, ML model in user-space can select
> victim segments and instruct kernel-space logic of moving valid data from victim
> segment(s) into clean/current one(s). 

To be honest I'm skeptical about how generic this can be. Essentially
you're describing a generic interface to offload arbitrary kernel decision
to userspace. ML is a userspace bussiness here and not really relevant for
the concept AFAICT. And we already have several ways of kernel asking
userspace to do something for it and unless it is very restricted and well
defined it is rather painful, prone to deadlocks, security issues etc.

So by all means if you want to do GC decisions for your filesystem in
userspace by ML, be my guest, it does make some sense although I'd be wary
of issues where we need to writeback dirty pages to free memory which may
now depend on your userspace helper to make a decision which may need the
memory to do the decision... But I don't see why you need all the ML fluff
around it when it seems like just another way to call userspace helper and
why some of the existing methods would not suffice.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

