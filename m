Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2D51E9537B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0A0C6B008A; Wed,  4 Feb 2026 06:17:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7E96B0092; Wed,  4 Feb 2026 06:17:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D957F6B0093; Wed,  4 Feb 2026 06:17:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2FE56B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:17:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7296FC2953
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:17:39 +0000 (UTC)
X-FDA: 84406523838.11.8540AD2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C557820010
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:17:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="p6G/wrMA";
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770203857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Xj2+Grd0At9fCuLDW7VCRN8j3ktoJMjySUHnDic1Mro=;
	b=4yQkr3bTXa3vx3t00mV2WAC+wN9ZK10f1cQ0X/pl1LgW640FwmyOPP4ilyflI/69njeY3N
	zzz4y0bVBwldfCO9Z4FW0ci7RizXXZOLfu6rp/UpPh2eI3wz/+Q8tU32X1YmvM14OrS14f
	vZd+1HRQgls1zddm4uVLLJqxEhnsisg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="p6G/wrMA";
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770203857; a=rsa-sha256;
	cv=none;
	b=5ImRTGofpbJE+1gr8Y7RjCzCCCXERlSI89f9OtGh5vQfoAZ+29ChD04jhpm+hEdhs5rBGJ
	im/yM5XDL+96iUjrfhs/WY7hjpwQFoaWFZeRu9z8c4MpTdJgJ9NStfF1aot6aXpppvGJqn
	Xy9r1LmXXwoOp1GfPNrT/wShDZES0YQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CFC3060010;
	Wed,  4 Feb 2026 11:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD8CC4CEF7;
	Wed,  4 Feb 2026 11:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770203856;
	bh=9NgZx2e8Bvl+6LjC6KiPuiUsxz8bHH/8vTvdMGjdA+c=;
	h=Date:From:Subject:To:From;
	b=p6G/wrMAqPCOe0/So1nM1eK0npdrnHDyOwIEDgJye02gIvahfqrcLVIlgemv+fG/s
	 xItm6St27c5CVCGCGZ4SPVD9o/18o9YfV4AVNAymBv8hQJ0dNbkN3bhHukF3EWH3XM
	 XA7ML9ss7BEnteEt8aikJ970i8dGUTH9AP6fjufz2NsUH2sO2keVgyIlmdkJVAi3IG
	 Ndrab7KA24L/mNy5tgf7UCW/pFO1WeO4x47TUPQNYt8M/xxFs+uHw0Wx77F5qSYwlB
	 4zuWDQ42DV6hhxfGZ9ldgEWSQuSdQ7dTGmIwwGHJKLsmQ266TVTqmf6LhaEDuZtt6j
	 umHaHTRR6sCHw==
Message-ID: <585f8c89-2212-468a-960c-737d3f7050cc@kernel.org>
Date: Wed, 4 Feb 2026 12:17:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-02-05
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C557820010
X-Stat-Signature: td1fnetk9ej3ng59htrnhxhpbthud1oy
X-Rspam-User: 
X-HE-Tag: 1770203857-479131
X-HE-Meta: U2FsdGVkX1+xpuE2cdOE1so09WRdD+IzY4C5SSWf4WRDcRttwp4JhYHsQEweBWwCLuevAtWoe3TryrIa4nHTdRzdlNMkjLrYgIh4uJCZtnLI/9MfeKmS0/HLDdhzVOJJvojfZdwUF+7N1+z1tht8ISL4gVVhaoB1hcFsGpJjwqPmZ66ZyqR6kI0Eq+gQQ9c5K6evNA7TAkgSkJvOiTos15rfCotTAU3x+lvs6+KktMdap0egLV4tA0ueb8yHCGtMviaCOte/ixn6ZDOuQy1V0JFIIXc/1LVNBMV+MIePi6gxnYH8S16McU7VJCDRSOOMDd79SC2Ura3CMPLIkXvlihHg2XqqflTZBqmseUB6KurgYy9ANx/aq6Zbycf5OfCEcnzNfOSZjqIJ7Vk45StGneMNo+qVvM297rXgVC0UMVIYIf0jOd+XVGM2tOyYp85HGMEsd5C+wQTV2U4os8jjwD2WoJQSrurOmuw37pWBo2Q50EFY9z7eSdMRRV0juUQEPg5cG5GhhQprviBxIJXesZaRX3+bTLeuE45WBxVKOkxtg4MOlakP4lt0JGq7ZR7gId3EK44OwB0um5jHiQ2jjHeb7fci1ydi2ANc8naGgczgz5IAPMwWEpUsmsC4HdJlEX26CfRIZLiKiubNkg85pbPTr4oSxsKeY3jc61boWjnlNeECjbhs4JarTJXMR0udtgpY7mDC6ilFnoUG80Spl6O4tE18R+vMK+IwYAqyEQF1u1YCoX3WufE6nY+DF4eiUjry98+G5LZ1/KDRG4TGxCq5Rm5O+WIERNBuFvaAMmnGhbUNKKqT7IKFrSW5KAsdetqaZASMkwP6wvvVm27FWrXHT1Vucu6z6BqWYquS7KkFgeSAM4G/8BHmKi4KhUUI4mslHnFXZU7+mnnEg47OSeqLyMl2/ODzCdhEvFvCGFsCSnXukpjSzvqDB8AZkJZ2bnQS4I0cya961hFfPIw
 ixn9SpaS
 TAMJoD5MslzsUzlqzq9goDu5Di1kpOEyB/ylCLrTtYgLorzrPX4wpAtI9fWWQhkPNTGlrkP6eGv84QjQh5ASYfOIYFbcR3hkDurPdNNLW7qVMvDQ5bmJSrSdNl01eCgg1eYUop5CldLWLW96No6kHd3bmBvyq4rTMoEp2ohv+YnCiXYNSzZSP0hRXN+qiHpGz/qIFxX8pe0uNCjtt/6PKcfhUP9V/YiC3tS7F6mbaq1LM/YOW+CM4AwGYnISWbfLtywlSDhLPjI/05QrZMPI9E+/Uf66KGKJQbpPTnYvyyAtOskBqNB8n0tXJ2hL5VGuu+3dElsUfMY0HvpjctToXaWLIwhc5BzkzxY1MXNzH++PL4F1lsT1uQhiGndqAEWqf2WyaGD8E1ym8ZHJYdVDa13e2jhMlbXQN2s913oZWzsY/R5Fu4KZ27E28fw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Our next guest_memfd upstream call is scheduled for Thursday,
2026-02-07 at 8:00 - 9:00am (GMT-08:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
or Ackerley a mail.

I want to briefly talk about the pfncache[2] patches and how 
synchronization with truncation etc. is supposed to work; then well see 
which other topics pop up. :)

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.


[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing
[2] https://lore.kernel.org/all/20251203144159.6131-1-itazur@amazon.com/

-- 
Cheers,

David


