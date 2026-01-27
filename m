Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D43E1D2FEF9
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 23:06:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398086B0089; Tue, 27 Jan 2026 18:06:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375836B008A; Tue, 27 Jan 2026 18:06:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2780D6B008C; Tue, 27 Jan 2026 18:06:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 16D0B6B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:06:11 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2460C1AC9
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:06:10 +0000 (UTC)
X-FDA: 84379278900.12.2DF1850
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id DBDF8140008
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:06:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lbORS222;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769555168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/SRkukJ6tppv0DBe3kVqUWicjzex62Inmnt+2ix6yg=;
	b=Igqr8tvu17yrAPqNr9/E2K0hDQQVl3rf33T+ELC9UfaFTTJ+W162hgaS2eKekdWepj5KGH
	a5fN0pZiNoRMujLh2FKNlfjLXASQglfKtJeWG1E1RTPYYaE70UMDfPNm8Bslx177CajpAp
	PzF12Hxsyjt7q2eyn5QdgfWqY188pj4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lbORS222;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769555168; a=rsa-sha256;
	cv=none;
	b=oHTUSa8/iOPdhQt+znN56lK7Z+mCt2cailoRnuAqPLoo+qnRppqe8xUqkj1e1LGualjq4R
	D1H12cD4nPbnE+yLIwzeUr616kxXxyrqmKljwFVAzTm190EAImgblnk4kwUOw8j5u1mFYH
	daGGrWDAIgSKKqVticMO2IlmMqXnpf8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6438760007;
	Tue, 27 Jan 2026 23:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3E1C116C6;
	Tue, 27 Jan 2026 23:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769555168;
	bh=GZx2go61irl/yrU3n13wEmtTxxomni09R+ySI530Rio=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lbORS2221mW4UB7Lc78M075DHdbfBzuAOnIJOGnqtOVAb1UBVbld5xFTahgT2k+4y
	 xyOEhvem8/S2x+iQxNzPgoRodqPGLzza1t781oLP2BVOdW8so6NHogSdOSZp4nOL9V
	 aIzFDiQ8s0swPdHCwrDK9jiCJrAm7jeoXWKv42pOcvPGRACH1HX4BLqyro+ASH+LL8
	 mo9mDnsMMorr9I86BPO77e4aMCdK6YPxhZttnWgwTL8ETXBSzs5KCqFtVq9hFZp3XP
	 d9+/vnbUvZWv91I7tfhhBFSKcihw4RepYQXh/3Aex++BEDr4q2uNSi5JLiMwybcI5n
	 RzEMzYINQ/Fkw==
Message-ID: <793fb531-1fda-4de4-b73f-fb46444ca613@kernel.org>
Date: Wed, 28 Jan 2026 00:06:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] mm/memory_hotplug: add APIs for explicit online type
 control
To: Gregory Price <gourry@gourry.net>,
 Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kernel-team@meta.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, osalvador@suse.de,
 akpm@linux-foundation.org
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-4-gourry@gourry.net>
 <b3d435d2-643f-4dad-9928-bc7fb5080181@kernel.org>
 <aWfR86RIKEvyZsh6@gourry-fedora-PF4VCD3F>
 <4520e7b0-8218-404d-8ede-e62d95c50825@kernel.org>
 <aXLCAtwMkSMH3DNj@gourry-fedora-PF4VCD3F>
 <20260123182526.00005ee8@huawei.com>
 <aXPIGMVAvVEBgFhJ@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aXPIGMVAvVEBgFhJ@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DBDF8140008
X-Stat-Signature: kmkwfeocwyg4jq8zma89cyeej6ngmsn3
X-Rspam-User: 
X-HE-Tag: 1769555168-261294
X-HE-Meta: U2FsdGVkX18oc2gwuE5+tIOHx0R9rxPGabcjVecSw4S1yXw00Pjpx3YvJw71Z8OsrQy1CTxYAvp27lXOUm822ysieBAa09MVxXSfDRQ8DVqvNQlszL4QVgWPXXLp9tFtMu1s9oR4vB5y9UAivNyNETeR/rV6JsNzcw1GGhXHAKlYpHQmWBeAal52rJS6EuuJPQrbdecMBpayvX5jwcgrI+/zyNc+cZQPq7UGVqrVYSnN520Lud/JbI0ad8vncYFVIWFnUPX3wONktypyn6JYHO9iS64xFT/aumb2CZBxLTT/cfnNawmG6GCtbTLZbc6RwW9L0jD6ZezsJj/6q7ANP75jnSgdXXiGppJGaV2bOYwcRp3KjgG0CvAUOFVxfkz5Poj34NEskWqU81Z0hWvJj9YjWbR65ApKVpKeqTQ4QQvRhIJ2skQERJuNoDBG0P6kSLhRx6SHOylHlgcPCZIaCdu4Rwko6quZvh3g6yNgAQ1NZSeCFn2rVorxqBh9wgVJNFE13MK+q4THyviJmej7SlHVazjSWaZhDXeJXz/tAPbSKLD7ychofC++rcUsgzuB40b1owt/34baeoo89tVfm/OSzIiML6IfQ4nBhjGDuSyV1uyOh8v9R2NfXmDfGIavUJvG4mg5LIsmdBe6FaiR4/jWRwj8sRtmRlHlhcHytX+NsKpQRnsd++vkBJW9WAH8dFXU/klK+EQruo2s0f5eMFgcGTHRIGhuU0vKDlC/N9TTLhTATfo8JmrXPOR1rB0KSkEq9x/6aHYy+1PTlow4dbyB0s6bggzO2wNEQ05PACSS/QAmQK+6P64R4jvr6E7NGLOCiHCNDkiSwvq12roT+BE6n6Zi3SdPUgEp56RJMBZ/mPT/pJ1T5+uV5MiYxRKvqG6CljNh6YbmmtTsvq/WWsDzsPljSvG3rp1+djHssCG6DJ5yFMiEG2SADccdswG85DwJudsvZZ2b8eUu7zm
 eojFTuS9
 xddtX18J7mylJPGY/dDSb1vvsfYPcGz+5bCCt0vi7pvCh0h6cAROU4oXMrLUtmptT9zGrwfnEO4Rl3aJlg3yxobHLqGiWD3FwT8l7aGi1FrtBGcuOgjOOUgHIcA4F0E/Tzb6SULv2AnJbSDaUdhMWK4fH4+SlggNSUawpTHLMt5bFgE1GyVIPaXZYDMHbQncnQ75avW0PSALFI8Xv36hylq+qVCYlhC8UyAmdxjGmypzdascsQv/GYjTlXnOCGalDoPCVeNCbOYHMevaqGfHvQJU4zj4+uyX2bQT8s6W4jejDPc047g0qBhC51kFXyXcyKZAwAWpw/8XHyQfB1OyuQPNGGAWOEEvYQ8QYrYXP2iuGEQ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/23/26 20:12, Gregory Price wrote:
> On Fri, Jan 23, 2026 at 06:25:26PM +0000, Jonathan Cameron wrote:
>> On Thu, 22 Jan 2026 19:34:10 -0500
>> Gregory Price <gourry@gourry.net> wrote:
>>
>>>
>>> Ah, this was lost on me.
>>>
>>>
>>> unclear to me how to restrict a function to specific drivers, but i can
>>> add add_and_online_memory_driver_managed() trivially so no big issue.
>>
>> Is EXPORT_SYMBOL_GPL_FOR_MODULE() enough?

It's also fine for me to just limit add_memory_driver_managed() to 
in-tree driver by using EXPORT_SYMBOL_FOR_MODULES.

But it might make nvidia unhappy :)

So maybe just adding a __add_memory_driver_managed() that gives us more 
control and using EXPORT_SYMBOL_FOR_MODULES is being a bit nicer for OOT 
modules.


(I guess __add_memory_driver_managed is a better name than 
add_and_online_memory_driver_managed, thinking about it)

>>
> 
> Is the issue just that add_memory_driver_manage is `extern`?  

Heh, the "extern" is simply not necessary and can be dropped from all 
such functions. Not related to this. It's all about EXPORT_SYMBOL_GPL 
allowing anything that claims to be a GPL module to use this functionality.

> If so
> yeah, i can just do the EXPORT_*_GPL path.
> 
> If you prefer FOR_MODULE, then yes I can do this.

I'd go for

	EXPORT_SYMBOL_FOR_MODULES(__add_memory_driver_managed, "dax")

(or would it be the kmem module?)

-- 
Cheers

David

