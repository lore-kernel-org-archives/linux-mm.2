Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59F2ACD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD7016B0005; Mon,  4 May 2026 04:05:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B88196B008A; Mon,  4 May 2026 04:05:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9E056B008C; Mon,  4 May 2026 04:05:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 971766B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:05:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 272BA1A03B8
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:05:08 +0000 (UTC)
X-FDA: 84729001896.23.48971BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9145C1C0009
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:05:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=clZ63vox;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777881906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kItUEdgis1R/m8aFKWzayaMFO2dmIIir4doXZRSqyko=;
	b=NWHxyVL5qDlu+b7u9fZeOwB54X3zjM6l2QXYkxor1GW8TVsSKwcVL7m497rZxNvh0rNBRD
	2vu3vsk8/AGbP/P59EiDmQNx/73NqDJwgob3vCiaZ06eLGY2ohBIMvKYrBylbIS1w73jsj
	ILsEF4T51CYkel5GRHo3XbXNqsVVxgY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777881906; a=rsa-sha256;
	cv=none;
	b=IMZBzE00Y30qOpWhXwdOVDK5JGmN/FNPNs1WrU8SdVpRtjYzmEgFDgJSZB85D+qgIIUiJM
	94e9zkgNLqDZxnayc7trZsfsVrNqPHQAlYeGpV1ivg2Y8nGJ8hTyNfM5epvjSGg0Sc6Xut
	0dKAK/ZjEl+HOVdkbFoRxSFPNsephQk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=clZ63vox;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E20FE600C3;
	Mon,  4 May 2026 08:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DABCC2BCB8;
	Mon,  4 May 2026 08:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777881905;
	bh=sgw7LcPcgijPezjeAjo0c0NIT2NcMK72lK9lat7L4gU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=clZ63voxCVThA2Nayvoz6O+UjlaA9DDU4Mg62Y9ygdASi3msfm1CYKGs+EcrWNGBQ
	 lHa5GoSoNErp+EGBY2I/bUxz+SXw4R7WTmY/U3Kv63VZr1iQJ7ZGNHOCIbPoC+XSw6
	 We7p6jpbb+JUT2RJ14DRdJ+bwwvWJJpPf/T5RjMpLPsx+jwXhDbC8ewjXrjh+buNwm
	 k/BIyAUEXM3fqEHRIvYnohEL8e1IMenHmlyS5jaPCNvBjCGfaK74GtBX3gTFbc+sXn
	 2r9xtNjKPPzeBlb2gTkAMynxUc9I6hF83hwP0aVQYiP5Jc/UgSiiLgy2kOl9rl3yWy
	 eBromN4hOqA3g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David CARLIER <devnexen@gmail.com>,  akpm@linux-foundation.org,
  pratyush@kernel.org,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/memfd_luo: reject memfds whose page count
 exceeds UINT_MAX
In-Reply-To: <afUApNZQumxPQ3wu@plex> (Pasha Tatashin's message of "Fri, 1 May
	2026 19:38:34 +0000")
References: <20260423125648.152113-1-devnexen@gmail.com>
	<afT3no4OkYxnQ6zJ@plex>
	<CA+XhMqws+mudAQo4ibaLb9MJv7pKDfLUAH8CcHSAkLNdPtijeA@mail.gmail.com>
	<afUApNZQumxPQ3wu@plex>
Date: Mon, 04 May 2026 10:05:03 +0200
Message-ID: <2vxzo6iv38i8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 9145C1C0009
X-Rspamd-Server: rspam04
X-Stat-Signature: cdtb46t8wxwc7zxjqs16kcgb8f4r8e7x
X-HE-Tag: 1777881906-109704
X-HE-Meta: U2FsdGVkX1+WyOzIK4Z51Vgi85dCQXTknXbpV3XORZyXhicUfm0l7ZLyCwWHjqcAY5f+nuv/UZTk2WUDg3XjciZABFC2NG6eks9NI4AYLmGIAm+jh7Ub1t9z+WSWf5nyKz8AHiNxnQ+iecLSkBrDLVf0huo7XRnivHnoDlJpiwv/h2x3cQqOKaN5ErE/Y4r3ZHRXv0SjA5pCaEj6MZSPbn49o+no7eosEZU3JDyZ2PQUvplS2JtbIA82xoMUZD0qqgZixvJsY5ViAp+0AS7kGuizZNcQLbDa73gNGSM9SIWKKY7sBa1aQTLbj4QQkoPLts4B2AMokavUIRJYjXHdOTeE/M3wmi75Tct7Cx/xLILozmOHraDAILvhkstX+upqp9c3bVH+ciQB72m06CH8exeZiGcBDkJliIr3H3MRoDDU/V08510EVJqqdGFaCiiMS5P6JAVptVWAFrhXlEg0S+Ks9AZWDwBy4C/bplsYnT3wGN50uddtb0MIMOCnWNd5w9cq8dSO8ezDLib0kwetFDPJNDY8W0n4kyX4XKeqF2Z6SLyd/jmuGo931WZXiF+XsjCJkCqcqYI2QaslyCAY0xact40DgwLsLz1quHT3TwrlmfqMGnOIFE0sKQAZxD0wl20cA0GhB8FbjKLAZbll7ELK36LlP7dsQzt4/RBvJ63mJ1OBfXIr2wFgvKrrDvhmas3o4jWuoiv1JQTDZU3JN92M6PGNIZNeMkVOkSrJaP0IH5QMWJaD+cZdY703g6cUkuQBOtNw/JKAaCLWiONLLlUEX+RsOxPvO155ACbjdyThbFkhiFE4MhBfNE/MJrddkvr+0xQYv3Npe5AfNYo1x7GA/ypwcWIRzDWc5bAQNwAb8LRGqznu0utoZXTxSHfL83/EzaazUaZybDDA6QK8SidWKx0wj4g1S7W6pI0xvjanOJSJnXGeYfdTetwwshDwKo4dq4ZMabfoDYW+b39
 CeOzI76F
 xw8sEIHQbwZm+yIPU62mHgQZcmnWAc4HqP+hdxv2/300QvQnJ6IFj0gEHBAxp5SkC914q7YUJGu5qEITOqfIQoDa+ZWvZJuqshNjYQxIYkGVUATpN1nfNiI8MiwUaEmEKwrVvrc9Pu4iU8m7KURVkhIPkWdo37TFZ1guZakstmKsbi44goqjsagAkys2/Nbx09PAtHN43LBtl8paHsvXZeGd20/JS+2qrV60/CfD34yowE1ktaa09pjGCoAFZOyNaWQsah2dH8cjxrh4ywp3Osf/q/6kyzbhlsqw1k9I23OYlJJY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 01 2026, Pasha Tatashin wrote:

> On 05-01 20:26, David CARLIER wrote:
>> On 2026-05-01 18:59, Pasha Tatashin wrote:
>>   > I think, the fix should be first done at memfd_pin_folios() to
>> change
>>   > max_folios to 'long' or 'unsigned long', and then just updated
>>   > memfd_luo.c to match.
>> 
>>   Even with memfd_pin_folios() widened, memfd_luo_preserve_folios()
>> still
>>   kvmalloc_objs()s the folios array up front -- at UINT_MAX entries
>> that's
>>   already ~32 GiB of pointer array, which won't realistically succeed.
>> So
>>   the guard here still makes sense, just on allocation grounds rather than
>>   interface truncation.
>> 
>>   Happy to widen memfd_pin_folios() as a separate patch, but I'd keep
>> the
>>   -EFBIG check regardless. Or did you have a different shape in mind?
>
> Ah, Good point about kvmalloc_objs(), I am not against this, even though 
> it is a very theoretical issue.

Yeah. I plan to get rid of the pinning anyway and do this via the page
cache directly (might be easier said than done though), so this should
be fine for now I think. I suspect we might run into a lot more problems
if we get a memfd like this anyway.

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

-- 
Regards,
Pratyush Yadav

