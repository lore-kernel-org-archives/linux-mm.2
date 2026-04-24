Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02995FED3CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E78C6B00A9; Fri, 24 Apr 2026 10:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BFC16B00AB; Fri, 24 Apr 2026 10:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D5396B00AC; Fri, 24 Apr 2026 10:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9346B00A9
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:31:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C73BE1A01D8
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:31:49 +0000 (UTC)
X-FDA: 84693688338.14.C335A53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id F03FF140010
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:31:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IQ24m45K;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777041108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCJvx4TUnpTSPQaFpwbBloOH8zXt52lvB64zCzxW9Rs=;
	b=vKevXYlrEakd+8aHwepHVbnt139NfTKnxVaIEE/VAWsyCrWKNyM4Eztal6FnGVGZQXvLwT
	/jG9MZs7DNMMhFwGVwMqdVhInkg9/R44R8vd46ZEU+BqerqbhiJV1hwdL8VDc2UNwimyaC
	nNdB/OzSl1nS0TOhiAsmD+TyXUHe4pc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IQ24m45K;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777041108; a=rsa-sha256;
	cv=none;
	b=RbvNyMduI2ShrHggDiAO4BI0d/F9M0oCwgyvc0CLZ3E2ZujR9jRqYrwXrHZXuR4yYduDog
	UhTSBCRrWxXH0aqiLbJy9pHjgSwIKm4kJKwBCN0o5SWzBHeu6GhQs+8tnb63BFQWyfNcOp
	zj77rkOonSAQLn96W1SyoNYOtPjKoo8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 41F0A600CB;
	Fri, 24 Apr 2026 14:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB04DC19425;
	Fri, 24 Apr 2026 14:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777041106;
	bh=Ibnzz/auXz3+3udo78jueXIEYRqia08WwlRydX0v9S4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IQ24m45K2Eibx5mWePKXhBUaJIgB7Zc/UcWu4uQMq3XKGP9ldhs3xDFTn0YhGXB7c
	 YSxHUXD162ct8HxKUG9AJgyJLPDB7d/OpWlSS1RR1stCDdFF/KiUarnzrmrDFSkOUp
	 ryowEUP3rFQPzIO3fQX1oM3yNTtsmrc8LZugGWZ8=
Date: Fri, 24 Apr 2026 07:31:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Lance Yang
 <lance.yang@linux.dev>, peterz@infradead.org, dave.hansen@intel.com,
 dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com, roman.gushchin@linux.dev
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush
 sent them
Message-Id: <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
In-Reply-To: <80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org>
References: <20260424062528.71951-1-lance.yang@linux.dev>
	<20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
	<aetw4aoABYj3keMh@plex>
	<20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
	<80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F03FF140010
X-Stat-Signature: t3hbzgnujpspn6p9m3eybfojzf9raqg6
X-Rspam-User: 
X-HE-Tag: 1777041107-707253
X-HE-Meta: U2FsdGVkX18I8NcNhzyYU5Xr69U13ewmB15/enXHUkUtBYPiwuyHp6H8bj5GhkD5OX5bh3hhb2fLy+cqppJPbcnt4iTQJ9BMnMgEBZ2wIFPDseNGpg01ghJJa21SsPwsXq7gRkOcp4DOtIG9s0+khhWNY8dtmyPg/yrgWO5Eg6o1VFplIWC8RfZcpxUubpIXsK2IxshpdTfxyehbBdgZRukjgWVCOiib4n0JTzKk9wuWma4lDtGJZDi+sgGGfXR49jZjNFTExkrJdad8H+4io9yQVpkuopP974LsnjqO0R5VLp2rLhvYJ/Gt4cFFRL7U8kBLyzarvLX9vbyk+NqRUB3Hu9byzr8f+729a/9PFQ3zTBt4BjHoxxBscXqXI9JZ8AShu/Yd2JvKfSP/KNd5AVPXIm5pR/LxYnrOwP+Cm+ubvdpnIsQkJYI+FDSvGvTSsfHNMonQfP9zPaJza5OrzyftUdjkkhS9pja9C/tXCnaC6ogmywNvUh8UpGamFtOYPnFaOTZNpL9H3+g1Qk8GxUm4UTZz1jXbr9QB//m/tcxBmP3JmMq6zQww/KfG0/EpmmpLOQD/8tCE5cxC8da/FfYBzmxRkKj0dyy2OYZdBsn431h+7MnsdgZHwyK5mx3586xbHV+q6xPza32q4u3ZOSi12ndtTGO/n4f7hQ1t7Zy/xzYn9eYdtOVL3vvfxSDRcC1h0N8iMBOnQVTQV/Ktba0MRDvljFuWx+WVvkQoIRUOJvqQBKq0iDAYkU8/L65qafVbujss14+b8w2b5uFf4/YzWorTLGYojEbfEs8bpOujwMcQSqsZR836qac1t+dTNGc798dTekP2daFwljn7zIvGEyC8CcN+OGN7StaUH7ppo4AqDsxuyABDXyGD0bhTYaYHLwBrdg8MwYCEbrYQP1Sbi52As2e0wLkmjSo/LPgFcvPJ5i/fVaQazGQ0VxnFmAe5dBFAaUdcMFJA25K
 JNqpmRWD
 jFOEWECJ2SxVE/DbB3IfhF0SOLM5YRYcazoN/ijvs84h4a+1wfBBxH7tmRT20lOtZM3p6ohJZU5ByVKLgBo2ZASG3Gpo3/amiVG+dlOLU8CuaVKDJAoHbhg36fILacqqhVZS0RxLQRfsCA4LVghXmQbiFLiMf6m5gkC9ttCXoIja61jgXmrYCnLgneNkE6xRhCAtc+Y4+IB3ilBWkGga+O2JPspls2svEBI6/i4s5aLBEszK6feV/+PsBiPFbpI34VgC8Ze68G9RWfjCCxiwdBK2NQMVaOMLWvXK8KFRPxCEDZgTkifZmdi1MQOhkTMPhqJ6DdkoAGznCLa+CcPWa8hkKA8/XQqDFRsnGQd4vSiZeBY73WIDY5i5TPwzlbcvLiOLqBSobDu6TU40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 16:20:55 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 4/24/26 16:15, Andrew Morton wrote:
> > On Fri, 24 Apr 2026 13:37:04 +0000 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > 
> >> On 04-24 06:30, Andrew Morton wrote:
> >>>
> >>>
> >>> Sashiko questions:
> >>> 	https://sashiko.dev/#/patchset/20260424062528.71951-1-lance.yang@linux.dev
> >>>
> >>> (I never know if my Sashiko emails are welcome/useful.  Maybe Sashiko
> >>> said the same stuff about v9 and it's all wrong.  But better safe than
> >>> sorry!)
> >>
> >> These emails are helpful; but, I do not believe you should have to 
> >> manually follow up with a link to every new patch series.
> >>
> >> Perhaps  Sashiko could automatically send a summary email in response to 
> >> the cover letter, or provide a link once the reviews are complete. For 
> >> the kexec ML, we opted-in with Roman to receive automated emails from 
> >> sashiko.
> > 
> > Yep.  I'd be OK with an automatic reply-to-all.  Maybe some won't like
> > that.
> > 
> > An alternative I've discussed with Roman is an automated
> > reply-to-author with a cc to a dedicated list (we could use mm-commits
> > for now).
> > 
> > Preferences?
> 
> Reply-to-author would likely be better as a first step.

Why do you think so?

Pasha, is it too early to determine how reply-to-all is working out for
kexec?

