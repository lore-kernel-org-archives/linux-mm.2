Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED8D3F33812
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 08:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DD226B0089; Tue, 17 Mar 2026 04:27:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592F16B008C; Tue, 17 Mar 2026 04:27:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5236B0092; Tue, 17 Mar 2026 04:27:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 31FC86B0089
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:27:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BFD2B14042C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:27:57 +0000 (UTC)
X-FDA: 84554876994.03.8B0CE2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 019731C0002
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:27:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rPHlFxRm;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773736076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HFZXx6yxpltKOjN6nUio2ywnViz7PUAkjtLMNs2Qr6o=;
	b=qGBeSwWbJOoox+63ZkgTnlJf3JWfMurmREbC1n1vDmXkNvIL8Z9WKRboLIJ7mB5jtIA9R4
	ElsbyH9pl4Je4ArWh+6khSR0BJaZJA907gDEnec1JXsuJLCZJ4mAfYU9vs1AVWRfasCTTB
	3yREL1O051scc4UXa9rD6ZfMECaefwk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773736076; a=rsa-sha256;
	cv=none;
	b=NaY3/hRO+4p3g4Bg9H8Wd+HtSyHjI1UwLD5MEI/N/7qGK+xQ8JGUVlta91bpkkXE57Wjp7
	N1DqPG4SlS0FHA3/ZgWIBleLkmLik6SAkL7L0EZ3FO8TIusbFsZ8LrlsR4tJnn4j4IgAqT
	uKyNi5nY+7HvqAmnmMejyDll4kiOjdw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rPHlFxRm;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05E8F43E2E;
	Tue, 17 Mar 2026 08:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B08AC4CEF7;
	Tue, 17 Mar 2026 08:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773736074;
	bh=5J7bm5yZK2SOAa9ngMWjA/xHVCb4YicboOTrm+PNtwU=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=rPHlFxRm+xTAI1x38mz3jSy00ZKkrVmPpnz40uyihNJE5MPDov1WHJdJUitOMXLrJ
	 un6A8dglaKzNMTlYW8p7vZW0d/oZcVWwNHhf/Jc3EQk9CIAxFAO/TV0PTJBAU+xMX4
	 4SBdtLTLv0tJnRV+H5bHNxvG3TGygef8kayz+xsC/OhwS6JmnTucI7EVfjQhUW5fnz
	 k3HNS0/A8/i+4SKgBrqCtG5hCNiS/Mi7XpynSOplR0cxRbCaHa5k0NLGFDr8WykDK6
	 iDppdA+7VLxcxSyM0fPEPfd6hcmf9cf2OqNpnno0ACsAJBsUbqlJQ5m8sBErpDSyAz
	 PJg3HBBRH7D1A==
Message-ID: <abeb4474-8f3a-49c4-bb73-50f2a633d179@kernel.org>
Date: Tue, 17 Mar 2026 09:27:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH v3] iomap: add allocation cache for iomap_dio
To: changfengnan <changfengnan@bytedance.com>
Cc: Dave Chinner <david@fromorbit.com>, Harry Yoo <harry.yoo@oracle.com>,
 Hao Li <hao.li@linux.dev>, guzebing <guzebing1612@gmail.com>,
 brauner@kernel.org, djwong@kernel.org, hch@infradead.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, guzebing@bytedance.com,
 syzbot@syzkaller.appspotmail.com, linux-mm@kvack.org
References: <20260115021108.1913695-1-guzebing1612@gmail.com>
 <aWh06YoiJrR3-J-X@dread.disaster.area>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7ce3c98.9b89.4c0d.96b4.bddcc787e1ed@bytedance.com>
 <d2598f65-8666-43f4-a9c1-73bee678f8d7@kernel.org>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7a4a183.1b5a.4776.80f3.36cd4d9bdb3b@bytedance.com>
Content-Language: en-US
In-Reply-To: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7a4a183.1b5a.4776.80f3.36cd4d9bdb3b@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mpwiythh9dip9fgikrqzq3sets9azfw8
X-Rspamd-Queue-Id: 019731C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1773736075-243086
X-HE-Meta: U2FsdGVkX1+nKfAH4N+T8wRu3qRoz3r7F+KCMqNbIINO36P0oRhjcg2lmJAUYyOpBQ0J8ukYVb41FJ0f/WXRqDXghVIWXOdtRngsD06UMY2iy21rgQhi0loQgEgM3f9yAfrIr17LO3KVOyfG0AeaiuUBZWeTvEEO9vCX/ZXSu9dHofOqNZZaOZOFovXjvFqIlRa3nJDjyNdMbi7DYyiATOKlXglWp092i+BstwNFI09MrYasxDPkbRwVh7uE2j0FlxryqxpZIRVDb3oGbh1i21eLhICvH25ukAUVDExMxGaJDuXVDUOW/l8DgW0jOxN1m2JTdhLBgspzrW576+uaBlJJfJrum+oUBrY1tkDmHII/8jV4psykhU5jTh+NeHre1WTQVXhiwILbFac0AaPuIWWE1qlff9doPO0dK5FDo5sbGfT3CElGBGqP98o9Ar5uNW0KfNo0C0JteDmWsGBJZa2VxclOfbWie6V7KCPLR/MreHXthbrtgoWHmtWEsMSg/plb2zE+uuQWMUT64QurU9fTyyArgofJzVoV456WvlWi1WBRXrx7H0wj9/E1FrM87P++jswRuGb9osTDbpaJebOdKcb5OtFjZPFHv3HW3gI6hQyu1J3WMGmYC6EtKwORrF2vk7vP9DoESnEKga1N04YF1Sx3Ohpc5jJagwMdWOGUYF3QxjPFVsHxBl5YNK96eB5U8EzReK4NpKKUx1yKYd6CdaKAZS370Spso7HTMRZviqswNO1Y1S8A8msufMnUj4lCwkvO6Ybyl8mCz1J3bUqH1Hxy7jrSKGtRdcUvhWvSrdzt3GMj2vszbhcg9Lq9yvxk/QIiDYuq7ZeBOXsysedQAN3BlHmqgoxlw++nwrL5AfmAqwaI7Yt2dAGsYDjaduWhSC/qWzIpAZgGpV5U0CnkP7KX53VdvvXYaF2ea9nZBE5uJNUhWMbAzwZ7J8PJp7Ts2YAsNWrTlXxf3oa
 fo45UXaw
 A5ErNLH0hecMQZ3tiDFgIJEKcG3ej6RP0DEA6V63otGCoE7zeAq87hbrNzxs5qbuxH/ZysBKELLlt39kiwLK9IklwQcKtzEFEBfE7kFRe8FmXPq3tMEaOYN56kX+xPa6tTl7NnhOjQcoUjhSJ+TdNXnv9qsUuIWVeZwsyK+bxEOIeyEDsIS/oddJTtHAjuVnC4lTxCHaL8SYmhBGhPIroOmgtckkD61152lzv+dMjbQ90UwYMEF6a/DkChP17AYXK93VoiCV/C3whr1bF+aFEJ2J60jTbNX4y4Vyrpg8CkqpTE8VdxNFouwrcU8rBKyRcO2TNSu15EsbcgGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/17/26 08:28, changfengnan wrote:
> 
>> That suggests in that test you used larger capacity than the automatically
>> calculated.
> The 10% improvement is due to the every cache has sheaves.
> When I tested 256-byte objects, default sheaf_capacity is 26, allocating and
> freeing 32 objects did not show a noticeable difference, but allocating and
> freeing 128 objects resulted in a significant improvement, about 3-4x in a 
> multithreaded environment.  about 12% improvement in single thread.

Great!

>>  
>> > I'm thinking that maybe these improvements may not be significant enough to
>> > see the effect in the io flow.
>> > Using a simple list seems to be the most efficient approach.
>> 
>> I think the question is, what improvement do you now see with your added
>> pcpu cache vs kmalloc() when 7.0-rc4 is used as the baseline?
> 
> On 7.0-rc4, pcpu get 1.20M IOPS , kmalloc get 1.19M IOPS, new cache with set sheaf_capacity 256, 1.19M IOPS
> On 6.19, pcpu get 1.20M IOPS,  kmalloc get 1.17M IOPS, new cache with set sheaf_capacity 256, 1.19M IOPS.

Thanks a lot for that data. My conclusion is that kmalloc before sheaves did
indeed worse and custom pcpu cache improved it relatively more. Kmalloc with
sheaves does better, and the improvement of custom pcpu cache is smaller.
Also the default sheaf capacity seems to be enough for this workload.

IO is not my area but getting from 1.19M to 1.20M doesn't look like it's
worth the custom code? (possibly from 1.17M to 1.20M it also wasn't).

