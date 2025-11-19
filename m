Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7DF8CF397E
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 17:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51F466B00C3; Wed, 19 Nov 2025 12:36:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6C26B00C7; Wed, 19 Nov 2025 12:36:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D346B00DC; Wed, 19 Nov 2025 12:36:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE9A6B00C3
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:36:10 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6629140613
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:36:09 +0000 (UTC)
X-FDA: 84128060058.20.97DDBBF
Received: from fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.143.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id 58C53100004
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:36:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=kKguyMYu;
	spf=pass (imf14.hostedemail.com: domain of "prvs=411f24c19=kalyazin@amazon.co.uk" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=411f24c19=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763573767;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYyWWExzLhYCC4+Jo3opQw3FoaDIdSA/mKXXs7/p6Qo=;
	b=ePBfTGSEo4SKCS4f5vD2m8VCGPsXP7jx3IfE7Ig3AP6fYb2asvQTcw+R8FHTTdn6fVDjyY
	Re5uC+TRUv1TEcpOSIbvX0MfCrVmtbOrrG0uc3k111yPbSHvXMNw97RBEZZ7gwnuDtlsif
	bceTPhEhSpiXeWySqATOtSGWgy+DXqs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763573767; a=rsa-sha256;
	cv=none;
	b=HGh2X05rwChgg7Y1Jd0L+p7TS/yXCXgQvWfwaaJAewcdoxrr14GRG5mBak/RpHESMbrhl6
	nFeIMrnksgyenCjp2ZmQpJ71exdf5R9zyTzSLJnkwduKEyqY+9aq+Q/hGM9drhL2cbb4wN
	gv2Ftz5pOyod7GgCAXcGlSWTH9jDpJg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=kKguyMYu;
	spf=pass (imf14.hostedemail.com: domain of "prvs=411f24c19=kalyazin@amazon.co.uk" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=411f24c19=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1763573767; x=1795109767;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=MYyWWExzLhYCC4+Jo3opQw3FoaDIdSA/mKXXs7/p6Qo=;
  b=kKguyMYuPAyLAqhYtK8oQmt3CVpaOTqe+ghuUAMiiMSKSJd5alnd2X5Z
   eXFiLFolz5Q3rGu16zswnc1oMnuiu0jcrI/nMa0vpt6QCIsvkF1lUf6LV
   wNPoVDFfKIuLuwKAc5KhGfPheQa9eZR9yq68o+u/69vkirWWTrQ01vVwJ
   5zhbJwOhyvZC33ZrIQ5HfVAsPCCV2iwrMJtt2JytMCYSd/DOSuxvPAhwl
   JWiBKUCfQJzUCuph6hcpAJHn6g/5PvMZNeoFrcgj5wWPimy7KOiAtJhAn
   lSyXVX0+mj4Wu/t4K8LzQjdF41ESvloSYMBi8tb09OLxPi/TTsMmkBfZM
   A==;
X-CSE-ConnectionGUID: 2KODmyCIQDO7OmZJiRekMg==
X-CSE-MsgGUID: /R+RMYiNR2O9nKeRZ0LSfg==
X-IronPort-AV: E=Sophos;i="6.19,315,1754956800"; 
   d="scan'208";a="5358484"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 17:35:47 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:18787]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.7.216:2525] with esmtp (Farcaster)
 id de87be56-055f-4e2c-857c-09a3093658e3; Wed, 19 Nov 2025 17:35:47 +0000 (UTC)
X-Farcaster-Flow-ID: de87be56-055f-4e2c-857c-09a3093658e3
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Wed, 19 Nov 2025 17:35:37 +0000
Received: from [192.168.8.246] (10.106.82.8) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Wed, 19 Nov 2025
 17:35:36 +0000
Message-ID: <b51a9cad-7942-473d-971a-d6fa3b26f63e@amazon.com>
Date: Wed, 19 Nov 2025 17:35:32 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [RFC PATCH 0/4] mm, kvm: add guest_memfd support for uffd minor
 faults
To: Peter Xu <peterx@redhat.com>
CC: Mike Rapoport <rppt@kernel.org>, <linux-mm@kvack.org>, Andrea Arcangeli
	<aarcange@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, "Hugh
 Dickins" <hughd@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko <mhocko@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
References: <20251117114631.2029447-1-rppt@kernel.org>
 <a5531d06-dd11-402b-a701-a7c6a62186a7@amazon.com> <aRt52tDCh72ytIp1@x1.local>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <aRt52tDCh72ytIp1@x1.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.8]
X-ClientProxiedBy: EX19D010EUA003.ant.amazon.com (10.252.50.136) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 58C53100004
X-Stat-Signature: 7k59jwco8xyh3qhxzmrpw9jyueymfwtr
X-Rspam-User: 
X-HE-Tag: 1763573767-299680
X-HE-Meta: U2FsdGVkX1/ivqlOAfQRR7Tb70ZcYskwG1gEA+kbDuRFGShHlaJtd4FFkcq4j1h8HC/2VGrJX/5UNVFJ/32kr5VsQrtFI2if4jEAJsoKv5bMTGNYaH8pipUag3zQ5/VQJbIGlrqmnQNZq5tbEcVWL9iptmGiLvNQ5fZ+yZgx0kYXK1XUJK5KKbi/CLe+y3GrUw3KLrVdSJ/g0BIvOJi6ahJGHcKqzh3qcRZHpaggnZMMTw/Jf2xawWO6BJRKz93R3Bg1aR8Yf3bzaiZMmDkf8i6QjFDrLYh1MgZ8kN+tQsF7edrr5afbXZ/Ia7OkW+KVklbAWD+h8ZhJRIfYJXB3X4li1oJ0kvw08Z1oxgLqFX3gMHs6mB1mGBDbRAc+FUmlP2gkrkBZXsdEpt1f6bOi0x9kgB5937YwjsDO/WOHYRTY+SDdVBe3tz2D0y1tQlYq9WqNEN/NlrSW8DCGNUpfAGDUXeJCDEZWq7mOmaUM4NhggY9+g2/bduJUinQFLFLbTjzrKksVuyySwAV3YWLDlCqZRRYU+hCN24B+qW2isioRDnd9SKlcW6ulF1kX0xGTylCYtEf89+fXDzlvKQvocbqwIZcnWwgeLYNkK3QZYEsGZuxjQ8oLS0BZB1SLuBLS/HCMLedskDkf0ZsJoXbi52VQZrOEMPvHWNMAjA+N04M2Ov71ayY4bK8XoThaqQG8rEUNaQwo3f72Eo6jxkD9X3uGE9hMEQcGxk8+stpslFstqlBuD+YWdXmX4kqrWDJ44HWOf3L8PQxAtwIe95H1CO92HTr0MOXHRlbb8Zz+vVPmtcRtla8jFHzrvtFQ9XAXCd5PAwyt21t89zvg3HMpCxB7VzGNoZtQ9j4UWurnseHnFCk7zhQTcotjgGGgKMPomcsCdh7KF7WNVJdqInW3b8RNH2Qn5b1cvd2qTY/Je+8xPuQ02U25fuaoiRu5Dt/MTLWBBErI1W7QOAzJDhh
 ISsgj+7b
 S2HHbzoIUtwZeYlXa4D9CaDCQYLXreeNAFvYikpRW8+3fVNU0Z2GlxxCJs8SlLD7qZ+pljzI3+RdZt9g9NvHmOytlsHBgMB3QjtOljad3reTyEsLIwVEHNRWFAo9cZACc8R/7LYsxSj6yv8lWXky4Bc8JLy2F37d26ERKqEtjrWmMTwtQ3GBzLWxStaGJpt9bTwFacFKYXQhPMQjf9zjaIKyVWLNY5wue+2K2rGp2S04nhnpZ92lPjKQAdeFYqG31cV9VHYL56aG1MrUf3FtBDhUln4wDcwNf3Z4P5poflDN7O2vxpMKNyTZERZ1/fQE1zeB575vooT8Puy4cxgZArYpdb4VVW8DheBBpijg7HJgmJSr98Wuc5l1hzsgvfBNqo1vLyDNhKfPybz115ehvFFBMda9QPe3LK7cPnT/DOm1qYCbo0Qd30VcXnsq0eeR/tjVKUXw4g4kLcrDHgZ3oK7BO2+gYYBAOwAzFgG8jIPTjg9kO6DbNp4IQtwoLsSDCOL5PMzV/y/0EGcrWsMrjKZj0v8O5CcfOmR0VPzgqqnPFYcF7JsIykYphZ4DMpTIb8u4WYP31MskxlLVjaaLb6GqJTRG1cfWdVhZ7DxKvXbKiY2aD94fEzl5oZnkJPxea+AakE3XpBtGN3qNWAgfYLs608B4VV3V843PAzBrIUMWSCrHl9vowGxCglIRqSNtlPQjqBUMp3+RzwpL184gbm7CRgMpO4UpfpRNDSYQC2XMGv0WcMVd5JIku6JnayOY3fX/Yp+qasWAIAS8GOpFxEUX+0BZK/p9pQb66MCKwsVffiApZIOUJbV9b52JTngM1nIsedTaRSJb8gdoop0eeaY1OO5PTh0z8cq5GOTsYQEQWfbz1SBRu8xqMQq32RpwEV3RjwHPHojB6/+lmaUVqHvgbZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 17/11/2025 19:39, Peter Xu wrote:
> On Mon, Nov 17, 2025 at 05:55:46PM +0000, Nikita Kalyazin wrote:
>> In our use case, Firecracker snapshot-restore using UFFD [1], we will use
>> UFFD minor/continue to respond to guest_memfd faults in user mappings
>> primarily due to VMM accesses that are required for PV (virtio) device
>> emulation and also KVM accesses when decoding MMIO operations on x86.
> 
> I'm curious if firecracker plans to support live snapshot save.  When with
> something like ioctls_supported flags, guest-memfd can declare support for
> wr-protect support easily too, and synchronous userfaultfd wr-protect traps
> will be an efficient way to do live save.
> 
> I'm guessing it's not an immediate demand now or it would have been asked
> already supporting both MINOR and WP, but I just want to raise this
> question.  Qemu already supports live snapshot save, so it'll always be
> good gmem can also support wp at some point, but it can be done later too.

No, live snapshots haven't been on our plan so far.

> 
> Thanks,
> 
> --
> Peter Xu
> 


