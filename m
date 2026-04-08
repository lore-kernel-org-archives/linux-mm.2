Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0A861073CA8
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 12:31:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 009686B0092; Wed,  8 Apr 2026 08:31:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFC316B0093; Wed,  8 Apr 2026 08:31:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E123C6B0095; Wed,  8 Apr 2026 08:31:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1A6A6B0092
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:31:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 973271A0AAC
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:31:10 +0000 (UTC)
X-FDA: 84635323500.21.A771F87
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id BF0844000E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:31:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fL2obKUG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775651468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s6k5O2fsvEAkuEpSEPhXbZ85nMZnV2N2ztZ6Od+xouU=;
	b=dmk6otp0rxpH1IbYDJU8M7dM9xiaU7CnqOEx7C5z3/Wq6InKyvSa24tPljPaYv8301htrr
	DzZbZPaeTEThMj9EbdPyj3Sgzyk0cz8ehJxXqPkrc29SEYhPWp0qceSbvJop6KOL9/XAUX
	zpNi/fegcEN/oARch54nh1JCNujZE0Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775651468; a=rsa-sha256;
	cv=none;
	b=urnlQWn1jv28HIZrySkAJPt2gaakUxOhlk+ft2AB2l4NHI1kedMdI1vt9PqBmuyRIlJT+T
	460nZyBUYoKfD/1NiwsFDPjp2ZVczhtPaiUbf1tPhtE4diRqE82HMkk4V7R6aZnmcn8pnw
	RvOQ7bPcYtaN0rd7kS4PvKzaD5XDqMg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fL2obKUG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DC021443A7;
	Wed,  8 Apr 2026 12:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A5BC19421;
	Wed,  8 Apr 2026 12:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775651467;
	bh=ny/5AyHrAqLd/aY33NUm54cF+Bg70m7gtQFtwi8UI3c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fL2obKUGkXiB9sKtq2nZ2X3PAJ9O41x3jEVg0Yzrw3aR3+Vm/ANWxZsasS9ztrIlj
	 HAcZ4NMbl/HjkkPxRdaRw1OLAIRpH0kCKkD/HY3vA6+cFsOyfKxPWJATKe/mICIe6e
	 IZ1ucovCcBsA93830RPkjtv9xvOZk19hOSPlvDaWALmyZK0LUDDh3fc5Z1ittnFhyC
	 ageJVZjKSf+14+eRj2dHHrcbBFzlpKLu062ZLKcBeB93MudoJhICnp2pzmO+jdMz94
	 eGflr1A89HImTxI23UdJ0mlAymD581pZL69fwtkIQd52ovbKRYhSbhnyC5MrW4f3Mn
	 Jm8w4dUdRnFsA==
Message-ID: <6e770522-0138-49dd-8f7f-3833b1a2a120@kernel.org>
Date: Wed, 8 Apr 2026 14:31:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
To: "Liu, Yuan1" <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong"
 <yong.hu@intel.com>, "Zou, Nanhai" <nanhai.zou@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
 "Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan" <pan.deng@intel.com>,
 "Li, Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
 <17b821b6-0176-43d5-92f7-fe2a0c4f70cf@kernel.org>
 <IA4PR11MB90099CF424CDD1E88A30504EA35BA@IA4PR11MB9009.namprd11.prod.outlook.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <IA4PR11MB90099CF424CDD1E88A30504EA35BA@IA4PR11MB9009.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BF0844000E
X-Stat-Signature: afkx1hr4bcao5mpbw1hecuss4ixxgrna
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775651468-268925
X-HE-Meta: U2FsdGVkX1+NgC54BaGTcI7qYxIBE2p+/tOpECQaDGtw0BQPVdZ/hJbudIHixWsxJA0bMHTBAShquFPisvbx+p16kXSufLsBOF6kHKB9IL4D+TIsvxzhSyPGlLCYn3QygJLaEedkaUV8pJu6yTJV1cvmJjoqv9wten29SnHAtODwv0aovhQzwQdxFfePBj5PhNuNfYLqQNo1iqNbziuxiwdz9MKWmizSxoC+URG3BVXVrjxoWFC7vl0rcTYZ1oz7G2XYy85kjmnfslsERHSnuiOEz14FiNO8HCGb5hbkgsLpln/Ix2Le6nAh6uRLibp/EJ6Knqcd+egnERUfPJnlc0K/1T4wNXagjGiZxt7RqQr9wEMONnLvjFNGE8JIjPVqjsR3eNqz6Y4yPrUmlDIWGychEbx0PK7vISO7TxeNbhp/eCiSZvyj9sM+VbArzCjL8SHCJaFHxA9vxgCriiecdKA1Lniwv6wk4k4SqI0JbFgNAul9b55FUNCNoeThjgJD/rGHU6BdVEDGUCKpY34FRZFfs+KLSGr72cByX/GK+CQeNsF4G09qkXRXRwC5jv3CNa3z9rjz8o5IPBvxMXX05Q7iW6ehcn1hXDaW0eLthmZ1Fmgb1nEwS8gGpPusUoZXkaMgCuRi31X7Fx0QKued8P7X6d1kfibF7wx7POY59cp/QkqlJeqVE1kk4+QOcniz8E1+/Kn/vbBZ/O0xETiLZ8wr8G1CmXg7SHEIez5Q4aksUxYT2FM8FKzQZ/OA0muF9NMPVQHCgjLDr6GmQY+D/1L6grn/jtNZxWl7rySd03Hqe6gldKtLy8OZeDbckd+2GfLtLNOHahYxg8RVS+ChqTh1zQRgXaYCvwXoW3xJRR45fDQFGkoiIzDUCRcT2yH+OMh4nalzKcxL1aqFbWyVA9wA5YCHvOFWjkEwFaf7TgoUEenIGRnR9lfwnS271L1wXh56fE/bbcFEd/d4fhB
 VxFcBUb2
 /io27ToiKcNacHivjl4ax32XU8RH6I5BoIktvbs49ywDfTpXDIJDunHrbedOnpOWjRBSbJT/dk1uHThPIijcWuc7Taalvaki5hAr30U1Rvo3yHjOv43P4qMzKKn47OnT8K7EeUIGNAhNlYDV0brzUEiz+K3GfWTdInVgDlXOFGWymNAFdhl2dgNG4hU+YYOv8atpUPJnBoG0DLwNOnBIwGU2Mfgv+fr99hKWnPUiR+t2Stoc7TmzXDRg9FHglP43OivOqppUAa6YLgAp6N8Y1/mdeGKbSfsg/+XUgAqaL0ZmjpHpg3LQs6O36dOAXWyDVDrh4nEzja9V1R9qxca10cj504HCXGJ2ks9jBwCozG56utZOxxBSaA2RiJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>> Maybe something like the following could make it nicer to read, just a
>> thought.
>>
>> unsigned long hole_start_pfn = *hole_pfn;
>>
>> if (hole_start_pfn < zone_start_pfn) {
>> 	init_unavailable_range(hole_start_pfn, zone_start_pfn,
>> 			       zone_id, nid);
>> 	hole_start_pfn = zone_start_pfn;
>> }
>> pgcnt = init_unavailable_range(hole_start_pfn, start_pfn,
>> 			       zone_id, nid);
> 
> Yes, this looks better. I'll apply your suggestion

Best to wait for Mike's comments first! :)

-- 
Cheers,

David

