Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38443C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A53E6B009F; Thu,  6 Aug 2026 12:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17CEB6B00A2; Thu,  6 Aug 2026 12:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 093626B00A3; Thu,  6 Aug 2026 12:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CFF316B009F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:47:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54CE8C0159
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:47:23 +0000 (UTC)
X-FDA: 85071425166.23.DC7866B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9355214000F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:47:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jVj88kl/";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786034841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C6GHpzFzUqs5eLagW1cC+q1h3FHH916iLAv9u6RFnvE=;
	b=XGubNbtf+7qYHg8tQc2VvkQFGlGS38ANWFABiXXAUAAuRa+3GBA5BwjgombR2KDjattt07
	rGzRlzqJflBjBv7kYYge2pY9yp1vz3I4qWXh+Tnt1pkTdY0CQNUfXtuM+/LHJEVw/0R5We
	GkkekJyf4DBK+8x4BbmpZ+kC5kVwyDw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786034841;
	b=eJSWGYDhfftqLF/fDDZyQnclCGJz3hWdC3KSqe/sdwbO/72SHx3UILZLiN8Nk4xAE3DAOD
	jsL+FJ9UoSokzPoODOAhwKVdpmI8krtP97f1KZpeoO6/Svrz7S/hQ627jikZUzdBkwVSAR
	7KRGS85LMX5GkZ35+l6mTktblMYlgyg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jVj88kl/";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 19F7260AB0;
	Thu,  6 Aug 2026 16:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F195E1F00A3D;
	Thu,  6 Aug 2026 16:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786034840;
	bh=C6GHpzFzUqs5eLagW1cC+q1h3FHH916iLAv9u6RFnvE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jVj88kl/5eHqqSkn6/9pZNFG7+2nWAcqvKOG6+wd2KDgo7xdF27AtTZjrt1oo8ebA
	 9YrmUBarcE5jZ8951W3PjLPFDhP5plRBbCGcQHN0Y4T4EgfI3QL8W6yLuLHl7mvjWG
	 eXGMoztysDcAohzURFUZkcGLbkyIEUrSC09hg0sSY6Hv1nhXobt6oHkEqBLuOlVNbt
	 lUicuiJzYKf1OTUtk1ak13yuJrS1hZbEE8ITQKF3oIfmwB9S+nE9A9t/sd++WHnl5S
	 51+YUFpfXGeEwFMz3k606tApXqQCWLbxZxYvLL/FdhefIpLk5aNaJL+bC0ssue8LCc
	 FMXh0NnpvEAvA==
Message-ID: <3fc3c53f-0dfd-4e1d-b7a1-1b2586a68f66@kernel.org>
Date: Thu, 6 Aug 2026 18:47:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP
 policy check
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Peter Xu <peterx@redhat.com>, Alex Williamson <alex.williamson@redhat.com>,
 Zi Yan <ziy@nvidia.com>, stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260805055544.1568534-1-clg@redhat.com>
 <0e52d0b4-064d-4602-8e7b-5744b05f24ea@kernel.org> <anSZpAjt84Pn7O_b@lucifer>
 <5b7e84f5-2007-458c-910f-7a6e1e3d3eab@redhat.com>
 <cf533fc1-db58-4c6b-a206-a8dac3fff391@kernel.org>
 <20260806164517.GA140051@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260806164517.GA140051@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ift3ycju7guo8up8g1ymntyyc87odz79
X-Rspamd-Queue-Id: 9355214000F
X-HE-Tag: 1786034841-82882
X-HE-Meta: U2FsdGVkX19n30ap8ENesrj4rzCDdG7uKbPD6IzPRP54JBNKPDBb6CJSXwm+EEhhIepbGa7rlYJfYOL7C7hnYcyjd6FhHRymcv+Oa6hMs1aUgyn7kptg7HA+ghVFKqEDzXzyePRynUO0Rrpt8TeKlxZGslT+nKB/irEaJh8pxVaLtZgHLMNmRhKVsDZ5VW69qP4ivYDnmWZNPz9lvlILaC0N5sPhKW6KoKTh/+aD13v2219e1juoAPmf6GatM/Tzq2/3xVLpikVbsek49r7FOrcd2CK1EOh97ENG9nbZf4xo4wZzeIxnrWAbCA0gOU+8gxDnIHdKKo9CGnpeC2KdIFvAJOlSRr+9VQNUaEA6eGZI/F5D8QOuhDsR0H4bRvxgQcvYwSMQC/xuy5NiCJtF/qJTIBocNkNtC7llDXSRUnNzsUWsxgmn9L4oBddvQQotuu7HDMEyaTPQiEybyK4jSu8rmFmf+d5Elx6E0amsSQND4+xv49a6jrV4wHlegq9f/I7av5WMglKOTSePDbFccSjxbIkdSrwbXq1QLWNXIK94Hg480OaBbu9diH+iSCdgE7wqmTJQBu92JfhI0jpjzXTpfoiVS+0uqftpYlCLak8KoYadQlC8pSZ587ncubSWFoM+zS9q5VoGonNQ/Dvpi9xSgsifbxVadtkdHsUffr9EirB6HTS6nx7aSqYUNTGfBZY8bDfZC8fChnDnOl5vZNHMEBvmIvetYiKfu7c1E39BZrxB4plB2asxlemtZagckNyMyPKtYhbu/bmpHSgsOMS5lI8/8FCOU+ZeoRq9YMxWo5dY9J17ujP8J4f6P1hFwtS0QXEmdov1B2YSny1oW+Nt5XTse7WpB9CCfGcI9eY8Qq8GyIODSpAxBZf4MOfkbKxlRPndVpTLOU8BVxo1wGp8CGElMPLPuUxXA/qEHNgIctSynYB7ppGt3seD3drn5oxvA2z9VBAn7kH3JbF
 2T3E12s9
 oRaSIvJBvkmiYGyJAgSk7j05L/xoiMwJ7NvgpZXKv996WiFI0GHLxWmsJqiApf1e6gumQrx5cptpS2PGsR/GQAWc0N1FY6dlXuZFgcvU7cv3yF9QEtF+e5kV//f0Yv9i9facAbMZdBiE/jZue1RsjlQXDlnf+dKrniGhnEsGaHAdZLjLDEYOwIrMceevtpvTc5URwUjq1S0455+FMRNjhz4nSsa9PSg4DubyVp4Va58nr26Cn838o2X8zqPJDElfjScLkALS60eZYXpeiwrt6+ont3TWNo9bYyikyjimQjTf4VHc5FYLMpuDv1U1y5GOkApu/6FXZJUW3ojA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 18:45, Jason Gunthorpe wrote:
> On Thu, Aug 06, 2026 at 04:47:07PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/6/26 16:42, Cédric Le Goater wrote:
>>>
>>> There are quite a few of these in the code in fact.
>>>
>>>
>>> It's a one liner. Good enough to raise the discussion no ?
>>
>> Just to be clear: Unchecked AI slop in any form is making my life
>> worse every day.
> 
> I think eveyone's life who contributes reguarly to the kernel.. The
> only ones who seem to benifit are people doing drive by patches!
> 
> There is so much more harder work on the maintainer side, and it is
> now even harder to get patches picked up on the submitter side.
> 
> Yet responsible use of AI seems genuinely helpful and quality improving :\

yeah, I run all my stuff through at least some basic AI review to give me more
confident that I am not missing extremely obvious things.

-- 
Cheers,

David

