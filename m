Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DAD4D2FEFA
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 23:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B4D46B008C; Tue, 27 Jan 2026 18:07:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53EE56B0092; Tue, 27 Jan 2026 18:07:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441B56B0093; Tue, 27 Jan 2026 18:07:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 321266B008C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:07:07 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BAE608B678
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:07:06 +0000 (UTC)
X-FDA: 84379281252.13.5772F0C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D644CA000A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:07:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vr9Fpvs6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769555225; a=rsa-sha256;
	cv=none;
	b=b5gmEtMiFtrZu2hU9cniOv/Gnxg8M/cgOgJn6DlaCs161rqsmcH/Pvwz+c6Txo4fESpQqB
	ZTflw5N9dyTrGJMwLaSeR6WU0z2Fc0scnjX1uzf4c2E6guz5qMqDOPbGr9Lu2hT1bO/eFs
	/HE37Zpp0baPmJrE8IoT79xtv+pIgoo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vr9Fpvs6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769555225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4gAbzJORaevWihXfnTOpdgdgK4mH/RoVtZbdN9W6P/A=;
	b=p7F0ya5lTEezWkW4UR96CFM8DW2ACHEK3WQyNpSJuRBdMQIAz1rC9ObF8M3hNFlNy6If0X
	MlBbI3GMLqm90IMLgpXJjrqPK4DjcLZIjoHepK4M7ZUsEKE3C3C8c6j5GhTwI8TP4W3vLY
	gdyFDhPzgpvgT37Hommr7ulZj4IveRI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 81A9B43A24;
	Tue, 27 Jan 2026 23:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96402C116C6;
	Tue, 27 Jan 2026 23:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769555223;
	bh=JySjp5riAZLd6mmNMgHnUjqyKf0qlSv7WXkRBVPO1CI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Vr9Fpvs6d0EEFlm4bRch6d4FLbnrB3uR9XUZB+6kxeIh5Gyst9s6dSw4NXLPzopYt
	 XqwJV7Wnspg5pXLZXLnpM8u4tvMBkIHTJQ0Aa3TC6l4+NEAAe1TuLq2A/SZ5fW4hAk
	 WOU1kcDPd8jgY+iJMdpEDFzhp/MyYRYBHKb4IRwaBLT+kDwRFKonaMqzzJQKkF9bnJ
	 APJREuhAfnpqpBlGU+Rkz97qWBM2pG6xxczmOQoPtRgLSjvvmt5sCjqKuowoH188gw
	 rNcWsvHbSVi1cMu6+i1La2I3jhMb8sceN1rhUwVuotOIbsT7MpMCO0oKxYQesQrl6P
	 qIrKq5h/E13Ag==
Message-ID: <684f11a3-1958-4562-880c-7e0afd3ae3b5@kernel.org>
Date: Wed, 28 Jan 2026 00:06:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] dax/kmem: add sysfs interface for runtime hotplug
 state control
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kernel-team@meta.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, osalvador@suse.de,
 akpm@linux-foundation.org
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-8-gourry@gourry.net>
 <3555385d-23de-492c-8192-a991f91d4343@kernel.org>
 <aWfcYjZVrROHfGyh@gourry-fedora-PF4VCD3F>
 <57c5f44f-3921-478b-843b-877fae536591@kernel.org>
 <aXLEOjgVyGYAU_zk@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aXLEOjgVyGYAU_zk@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D644CA000A
X-Stat-Signature: ho8wwxieg96hn13bk6ofer6xstrn74dk
X-HE-Tag: 1769555224-214606
X-HE-Meta: U2FsdGVkX19YdReAdZqdRLyMW1thaXmQcOoqWfZCypqoYccT3pnX1D++s3H9iYC/sdNEEaf2jFWvZvI2aq1AO8+uwflkkCBBdD0/o5HR9d4Y7LNpUjlIGo4lnUNyPlVv3XohYq/OOS6kCoNxV385I4aDNu1/jyP+vacRaB4cDNsqRSnAe2sLR3w9s+s7cUq67glajrhZ/EWCcrt+enCbOiW7/J3tF4QOee8jmqERq87jgqucu2P03bsCaUDU7vuGd2sBmhwj//4yTN3CDjujUnKKmoJ9jqdKJaT/uGzRj6iQUEQJtNDTJ1KQ2VVkJ0z21C4ILIpPt9aL306cUVErQkBeDEX4A++XHDYRdkB7ZLhV1uFWR8zRhDF0T4eQByS2ne1ZfCdP9ptZiQ8COxekSW81RXn1z0090lmBPyDSXv1kSiWovb4QZZxSX63/U+su5+ttNb9KJEH5WL+OZ7GrzNLhSxv7UcisropXhBeXuTkt0+GCdRLy0hKoil1KRU5p2OXDVfCeO8Bl+iFkNsG9geWNqRO+yTaDJBwCIqTqfR3enE9IZE8iuiBKk7VnWvZ1r4KbbZd8djOWQ+QkLJ+ctDLCkaEBfVZ00Fzi7QWV6VPr3PA2Xw9rW80MBXfzuj46bHyN1ijFRG7BHfG8JrdxSQ6jzpAAxzzwAgEDiLNlnu220oiEJ3DmLDz2bvc3zqQnZEviYjceUb2HzWSQebznTSeAjXYA3LHNQAnVRz/WKTHDIkUBMHVVSPY+6REA+nFRQ995rtkcHmDAQw3W+xVF1ap9omEtI2TzQwcObKM74zO4LvEkbFx0ZXnhlgXfQ9icR6LAPYsbVeUYF+1g56YiRIFp+v5i551EoMAy13S0wvL/iAKE9Zf7+v3SXCq/a+6qKDifAIiqFuIEDAuBCJ685N5LULs/dqVqn3s6Aakp5uQ2FGl/m/FSLa03Eap8bLwVu/uHfdmovB8nsbNSKyJ
 8C8+GaZ9
 8r9DkvpvzfIFRDPfTDaR+m088liwvMhXuV+HYOcx8kwqi2XRqzmVbALQ/VaD+84e6Id1O8aOvPZl1INrFxgHo4o+xs/JJaj17GsDdzEY0bes9Nc9k9Wok895JrttWgSy3MTNIb6gdOjz8a7sxT3iCL7Kh2OJFzZybdn6x+N5bdeyYRI3i8CfGnCamGdxwNR1+aoTqIymb0SycCptaBjzSEtk1tcKSqhZjgChxpUY0nFdJv/gsjobZ6sM5WMxH/h2JFKa7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/23/26 01:43, Gregory Price wrote:
> On Thu, Jan 22, 2026 at 11:49:48PM +0100, David Hildenbrand (Red Hat) wrote:
>>
>> I'm merely wondering why, in the new world, you would even want the offline
>> state.
>>
>> So what are the use cases for that?
>>
> 
> I don't have one, and in the 5-patch series I killed it.  You are right,
> it makes no sense.
> 
> However:
> 
>> Why would user space possibly want that? [plugged-in offline blocks]
>>
> 
> I don't think anyone does.
> 
> This is baggage.
> 
> The CXL driver auto-creates dax_kmem w/ offline memory blocks
> 
> Changing this behavior breaks existing systems :[
> 
>> Can't ndctl just use the old (existing) interface if such an operation is
>> requested, and the new one (you want to add) when we want to do something
>> reasonable (actually use system ram? :) ).
> 
> I think we're in agreement, I think I'm doing a poor job of explaining
> the interconnected issues.
> 
> summarizing the long email:
> 
>     cxl/region + dax/cxl.c + dax/bus.c auto-probe baggage for
>     BIOS-configured regions prevents any userland policy from
>     from being plumbed from cxl to dax.  There's no interposition step.
> 
> So yes - new interfaces would resolve this and the old interfaces
> could be left for compat.

Great!

-- 
Cheers

David

