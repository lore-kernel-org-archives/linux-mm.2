Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71E4F60A2602
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZcpNV/Cy
Received: by kanga.kvack.org (Postfix)
	id 83EC26B05BC; Wed, 28 Oct 2026 09:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EFB46B05BD; Wed, 28 Oct 2026 09:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705926B05BE; Wed, 28 Oct 2026 09:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 408396B05BC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:59:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4D84FA08B9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:59:25 +0000 (UTC)
X-FDA: 85372192290.15.3702B52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 80CA38000E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:59:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZcpNV/Cy";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793195963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lmwsrkba+SRG/AXiVVkwXIp5wUOzmuBRAc0XQagcnRk=;
	b=kY42mWs7Zto3G8PCabO19HRCXx38VyHOkMcMBxc3prR9bFzgf39w2vnCFadvr7Wl1m7fXT
	d96ct5+LyTdFHGekzHf6EdyVzxZjsN2uofnSTjy28NPFDmefqcLsTZ+ve/xkPnN/zb5Xum
	nJBFBaKuZFiRPu0iSdyWMyZ6dLKuQM8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZcpNV/Cy";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793195963;
	b=o/smzJSyyomVy9qM7ZcUNTdH9Y24EuQMjhc4HUO04TMPQuCi9uoQK2Y6w/GpRfZ0Yn5Cnp
	NH+F75Q9l9L2QrcJvbxJRmp461V+z/lAgAoTClVJW3hQYKauv72C/bsYJCkKddA/lbl94h
	f8JkTmcDhlhf2w/z0XKWLNlMTCz/tvs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B8D7A6021D;
	Wed, 28 Oct 2026 13:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E981F01825;
	Wed, 28 Oct 2026 13:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793195962;
	bh=lmwsrkba+SRG/AXiVVkwXIp5wUOzmuBRAc0XQagcnRk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZcpNV/CyxgZlHYTgc9hz+BHGNvVQTNr2Km24y1NtEAipKrQpWq/PnNnomtVHFa60H
	 fq/dnQtzBNA1YFxuQWUpMKjxRjHD9TL76A4VWNOOD17bBj39UbNmg9IoGsdC8TNibD
	 PzZRXmfWpzc0v4S8HCUxioxzz0nUTL723I738EfkJ/pwmVnZL6fJthMXe+IdRUM8sY
	 0VSypMLm4xLMThodRtiJupZVx4RrEYAMgTVMyOcxVO6P2TKUWAK91DXgn4+kT3k8kH
	 SlTXh7e9aDUOI5e2xO+fmTOBmGkauVtXIU1nu/qAI16DPgVIp2HS6yRGNMGl8gcDRJ
	 7uIMThOzuVRBA==
Message-ID: <cc5c7066-b5cd-45df-b338-37944320da2f@kernel.org>
Date: Wed, 28 Oct 2026 14:59:11 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] mm: pass the number of PTEs to move_pte()
To: Andreas Larsson <andreas@gaisler.com>, Imre Kaloz <kaloz@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Magnus Lindholm <linmag7@gmail.com>
References: <cover.1792609488.git.kaloz@kernel.org>
 <2bc50d2a6829b49ee909e5bb943244859661a40b.1792609488.git.kaloz@kernel.org>
 <409079fe-ab52-4389-9fe0-d7246eb27bad@kernel.org>
 <20261027212610.6798-1-kaloz@kernel.org>
 <dfe06aef-540a-4450-88ba-300a460007b7@kernel.org>
 <20261028091631.8072-1-kaloz@kernel.org>
 <25f5cbed-9126-4870-a81e-65099155bc9d@kernel.org>
 <20261028101719.11918-1-kaloz@kernel.org>
 <4fba060e-c4f4-4d73-8efe-dbed0b5a7bc3@gaisler.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4fba060e-c4f4-4d73-8efe-dbed0b5a7bc3@gaisler.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 80CA38000E
X-Stat-Signature: ou7ow5gahu3szsmtmdg1gcz9i3gj4zu8
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793195963-657178
X-HE-Meta: U2FsdGVkX19wKdwEdNXZLVwmTssnF2lcM7iyho1zNyfKkw4g/FCCBXIiX1tcFzOmxrIeokbd75GhgiVOFuvw23jxIWZ2Os5rPx5LAdCeiRVZ5Yd7CskixYXzxbB4yqsFzNtSgNZ1YoA4/HpV6hteoZkfUivXShaJTTTgjg6NZxTu7NhfglofZKLad5O3eV7i0YhTnQcSZkuPLSqBlhTKocBilI8qqXenOJ9815c/Ie3SILCL714HApc4nFcMAIdpKCres9Z9xqfwlvRl0+51uoCwW30javKPEzibHDA5GHEexqPwImTbLVh8DPQz761rzhQmQw0P6CnN92W1OiH7/RTqxqWJAuyiXkw/DWTXkaXQoogA+griNbu+ePcLhjZ4k70PwKKucDPHDMWoXUGFYi6y/kLkSJ4mZGEZImyUnHU+V9BfW4UI7b3UC9U2mi84i7nFco9kH8XKLzcUvM2p9VnzthOgm2MOcHL5KZ7AFk9o4bZRm6MhzT7KQ35EC+bSIGMIjFWXxjYDuk+qUpeSWtvIVO+hmqf+HhVZhfI0bFwXZ3Fe2i291F3JcDbFkgLARRGfXDxjPpM0NR3B9QoDpy4NMehTnl30pCC/zNHwxAfaCPoeoaDdBYz5VivVIi1rH0INWn1nPEUblkN6zNCVoragbyeWircw1gOWQU4T7iI/2e0UnatQImX/eO0bmIeFm9+wADu44e/ZPHgDgr/iKv3Pic0Jh6KCPFNn6Kjq7gn6mrWbUZ+EJ/UWcnHTP4hMogk8AcR8awuWPrhYUbK2/8rAhDKtqIw1/KS60LYO8BtwZryoFb/dygapxHuViXwDx2J+HuuD3+kpEvq0IbRzK0xDDrd9PWnS3f5hbiBmkjZYGRmSQYkYgjOn0XiNA+fsV87+V8fuetv7ty2cE5LeiEWL1m2n9W3HpmpJSKiwG9Jkk2uAsZTL22TQiTYzpWypnsu7kBvp2oSNxcPB+L1
 T/QwVd4S
 01Pof2S6pF4WFOcAcfsCaZzgCyTln+0G8DGa5N7xEBflIUe0UKtFmzq2pqd43ALG8p4KI7iYrxt0W6XEWUfOCVVNcfduAaytGltKcd76lCdbEbXQfLM2268lfHKZ08D0gYaC2QlYVpVh6V8IcfbQHvRjhR93bSrCsY+AjJ7xSa0QglKyV3lHfa48QkhHWOwBFpA5OOh0ayMSx733lUBknuiga/bcedOFNoYXj2fQ1XLTpBR/JUwUdNDagCKuFPqRJljNYqf8Iu5/kFF5NXy7gYFrfw6VJS3nLWyAkH5nt8r4WZuP8lP/2pRTzhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 14:57, Andreas Larsson wrote:
> On 2026-10-28 11:17, Imre Kaloz wrote:
>>> The biggest problem all of us with supporting old hardware is the maintanance
>>> cost. Not just core-mm, but also things like ad-hoc page table walkers you are
>>> adding we (from core-mm) might have to touch at some point.
>>>
>>> If there is no good reason for the complexity, out it goes.
>>>
>>> Because otherwise people will push more and more for removing legacy support
>>> completely, and that's not what you want, right?
>>
>> Definitely not. Fair point, I was only looking at it from the sparc
>> side, and keeping these platforms cheap to carry matters more than a
>> few percent on reclaim. B it is, then; it's below the scissors, on top
>> of 1/4-3/4. Thanks for taking the time to go through this!
>>
>> Andreas, if David is happy with it, would you take it in place of 4/4?
> I'm open to a solution like that, but it'll have to wait for the next
> round as we are far too far into the merge window. 

Fully agreed.

-- 
Cheers,

David

