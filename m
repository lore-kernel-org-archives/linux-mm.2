Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27C4DCD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 12:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C0EF6B0155; Fri,  8 May 2026 08:10:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898DA6B0156; Fri,  8 May 2026 08:10:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ADA06B0158; Fri,  8 May 2026 08:10:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7A26B0155
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:10:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38694A08F7
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:10:17 +0000 (UTC)
X-FDA: 84744134874.15.DE7E104
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7FDCE140005
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:10:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FWIRnE8J;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778242215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hlUzDLpFOxCZ161P2gPWMqZBdzjkVEijhEtrrDICBmo=;
	b=75qWe3LUGGusJH2SHyQxDNErAWZj/4fbuj6ZkiB2+/+rvXeYo/ZyVin+1HJsvd5452heoY
	Xk0Zs8x6zB6CaR21oVTlI1qM8jrWYme1cSHT/g1b8ZZ2mDIhWFD36qfdjOOe2siHgITIk5
	BsIGltfUujjpvSpslTTwGCipDUmtHQU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778242215; a=rsa-sha256;
	cv=none;
	b=Rvckx1J96O21DZ/80GHhltQmm/qrd5jVqjf53/2hou/gQNE6HwtnCSujeEGrxM/fOaO+r5
	/SU+c9zqQ8lqNRYbr+j99nNKxjAyTWF59yOVTOINMvyhOQIP7hc5n6YBB5VuKD7i+qkXTK
	WATCLGrVAU4wPABDgOflBG/U2jhxyy0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FWIRnE8J;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D0ABC6024D;
	Fri,  8 May 2026 12:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC09AC2BCB0;
	Fri,  8 May 2026 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778242214;
	bh=ROJP46nXJtoxsu5Qsfv6GSxGcxmvr9wAog/XA3F0mlE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FWIRnE8JITDbbPi/noYPB98nrypPnAm1VO3KjBpJp5hphskGL/EpVkkwH28beXQ8+
	 XpnbtL0CNceQ4wq+kmDOshkHkBytR1xqe8EQdAjNeneSeRyZpSzdJB5bjRRtVVmrMT
	 Eog26q50iKRkgRKTQlYM00nO1halDaqppO2ltBQpt/o/3mTrrs+RaPpke4GaZ0Vmen
	 A52js/9Q6hPp++2m4hjds9D1k4B2+cm47MNYPMJzvuQKe7he1f4zvT3HCZ6Qf83cHy
	 x9F/VUxpuLh0ey8n+MQWwMeD3Cjx3FDZN8MXxbfXn4tHr7KBPvSlqP72oKJx8U0kzd
	 ZLI8S4qxsZykg==
Message-ID: <be3d69b2-4e4d-42be-ab5f-61bf5940b0d9@kernel.org>
Date: Fri, 8 May 2026 14:10:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/28] mm: vma_alloc_anon_folio_pmd: pass raw fault
 address to vma_alloc_folio
To: "Michael S. Tsirkin" <mst@redhat.com>, Dev Jain <dev.jain@arm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org
References: <cover.1778192416.git.mst@redhat.com>
 <96a2f5a938bf65315ac95e75b4e7741bae018cdd.1778192416.git.mst@redhat.com>
 <db7cc3a4-0070-47b3-bcf3-540d0e9d3baa@arm.com>
 <20260508020947-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260508020947-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7FDCE140005
X-Rspam-User: 
X-Stat-Signature: s8erh6chr9kyac3zuc5wim6xhgatnytp
X-HE-Tag: 1778242215-749416
X-HE-Meta: U2FsdGVkX18idQziyYL+owcaYtdXUpQlFMYpJMJ4L79VeZmjOfxl8SG/NT4LH3T4UyKfJ/ka2f5EID6wa0xb82ERAx0bSwlmHppcGDKwKkQM9FDZ4GaWZjJiA0s5Cq9R1iJdo/5jdCps9d2hq6ZPN6AxwdOqMpl0KoexbbOrrmxgy7gR+G8+PEuBNCIxLnOMGAEodfGzbuoB4NFvwYgnSDlhuVwFOhXWvAp1bd7LBdi/XXKjeDCPV+9u9ReMr2ObikO2echL/wI2N5vBYAfpOhAQt/k+UFvoQ0Gg/4fS28iRSsOSSVSqw+Y+lyipETd1VRIlVMf3tZ+Qv4WolCz4FtvuLk5PcyPKafefGDaqQubyVrfi8uAKR9d+HQ0KkjCmJp02NPOAq+/d/QSag2BSdP4sIysH84cdmHKSXACI97F9aI3/Z4aDi49AZVbFjtXdWL9iFhx+GFjQSDLRVrvR6Dxxk/vVRho/wb8nSVlRr3B8NMlNlAyVp6zJSCAwUdW7B9tF6+Rtgk8/+41uzgtL4vdVYwsyqtppaF2VagOw7dnLEAbQ2afHf9wIEFx2yogy3OYvaT76J1uJ14SAjgPCfsS0/uSFCQclPuvQZM3KTddRBKuexVt3tQQGgl9yoi3k79bP6Vt7cHXRnoRn7vZKSylsxSUn1OIIfIrQBHe+88pzNBios42iU4diJna0l3peLN1/n+9HKE35c7u9ZvjeJmqfapTS3CKtnStcUB1xL+BlhSeS5VtQ2OvtDecsQV1cmTXGwniAtrZHYgMcmFfUV8c8NS4Rt6rZhxweXXJLzJ2PHbi714VyVPy5Cyg2Eagk5qlAVxQtK0P5o3fs7v9sxW6JsJt/wCBeOGNJGLvilX1iDj8ttX9TBuvEE2dYE/W2H6VSnysznZBO5woFRi8aZ8c+Go0eo+1c2y/i7m9PFombvpQP8FNnJcC2CASApNR36vguofV2RIYO7/HB7bE
 F2rdXKQr
 w35+Dv0ouXkPN7Xq8nLZNLHC5OJ4MrDyi86tyqFekkzgrNnJvVoEykpR6oCiYYpCZqgJGRL5qEI/f+gMuvYMBGHGzRI0THYqVASAVkEMjLtO94pOf73SeJhQjzQ4ZA/lNMfxVbN+ZUA7Kl267vBnG5rHx+RC8blK5IUFaq1CVp3mMCLrDSz3w3luPqpH0ojAfRB4oKdSrUkWvcDhIvOIbqjICpPtTnsdLgsZFCehv/+MbC68RV0J94/JS3HavQOpHGT3/fknVSGayYDuHHL8/5su20i3T4OrNiecC0fohciVQPUS1l/O0KrK5UCOGus9U33NmhKkToQmhKVU1s+zQEKhEZ68i5upjMMJA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/8/26 08:10, Michael S. Tsirkin wrote:
> On Fri, May 08, 2026 at 09:06:22AM +0530, Dev Jain wrote:
>>
>>
>> On 08/05/26 3:52 am, Michael S. Tsirkin wrote:
>>> Now that vma_alloc_folio aligns the address internally, drop the
>>> redundant HPAGE_PMD_MASK alignment at the callsite.
>>>
>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>> ---
>>
>> Hello Michael,
>>
>> Could you please send the whole patchset or at least the cover letter
>> too, to everyone CCed on at least one patch? I only got two patches
>> from the patchset in my inbox so I have no context :)
> 
> Will do, for now I bounced the cover letter to you.

I received all patches, but no cover letter.

I can only suggest to look into using b4 for patch management.

I'm planning on looking into this, FYI: [1]

[1] https://lore.kernel.org/r/05cf9584-e06c-4ecb-a5d7-2a558fd756ce@kernel.org

-- 
Cheers,

David

