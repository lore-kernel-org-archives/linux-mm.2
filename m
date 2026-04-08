Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50A7C1073CBC
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 14:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BC4D6B0005; Wed,  8 Apr 2026 10:14:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894526B008A; Wed,  8 Apr 2026 10:14:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9A36B008C; Wed,  8 Apr 2026 10:14:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6AFE36B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:14:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2308F87871
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:14:43 +0000 (UTC)
X-FDA: 84635584446.01.3B577C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5C9CE10000B
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:14:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cmplxyhy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775657681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CdhiEWiYLLXsfzins6vHj9/8/3eZhtuqd6zJJxWmlOU=;
	b=jhMfr/hn696ISPxmCSe0B7M4iYk7aI0/K7ejjwW+LzwWq2mThP0W/1NXPx224RT4RUaz/J
	DIoS5jXEqErS2VSWe6O+x2bYQuT6KJ7FcyX83tSxNvZsfw0hmWZSrW1CbBqnnNfy6EU3/S
	YxNJIp5LV82wFYJEdnzh+qF21VeEVlU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775657681; a=rsa-sha256;
	cv=none;
	b=nvwM8g6HBXe9ILfogaRP9+66K8aM84KLIoekeWCD2oEW8rrlsdquOMtP/tpFvRPJ4mjvfq
	9yKlmMNg0O6eUZxvuXmO9gxZ89zZml7PqAJRFuHIoD7AMLfqdmOPRPexKSC2/Wd5WOKj8m
	8CwG5elS5GC6DYBckJ15mV6X8QjslKc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cmplxyhy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BFEF2600AD;
	Wed,  8 Apr 2026 14:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29166C19421;
	Wed,  8 Apr 2026 14:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775657680;
	bh=4758blXblSGraxxNLUVAoZhJhgiAHLM/ofkX9ZNtkB0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cmplxyhycPBF8vYPibwQTrtzSgECpnUii+twBF29DlInFp4TWJ+W+NOsiWVeS/eTc
	 +UhbqSn8Ufvx6rNHfDIhUxHM0z9WhVaxfSiWV21Oy6cO5hkqVANXuFPAPoimjKimVb
	 Ec7aTg2V3/ALm/7G/7McUe8FQ2vVb2gKOwEVR3l2JAKknHVty/UOSB3I7m3pVGo/1i
	 /N4o/TrFBvkFUY96Vl1v4QW833tqNFHbP3pplkwDt8JeBZaGUw+tAT3cFvCKUmAcew
	 YEpTrztVTpXHNDMm0OCmGYYqT2HH1JdwznuwtE1h/6r7g8CAC5bEp7DXW1GYsPbzm/
	 3TxrQLHQ4CNFA==
Message-ID: <3b7d20c2-a0c7-42c9-b303-1dfd6503cae1@kernel.org>
Date: Wed, 8 Apr 2026 16:14:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/11] mm: thp: always enable mTHP support
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1770675272.git.luizcap@redhat.com>
 <835725cc-1670-45ae-bf58-593aadec6b88@kernel.org>
 <8d03a508-5836-4001-8eb8-b216251dc29d@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <8d03a508-5836-4001-8eb8-b216251dc29d@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5C9CE10000B
X-Stat-Signature: 7953jefwyib15poe7jaxfdw8mhi468rq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775657681-706162
X-HE-Meta: U2FsdGVkX19nz3vTsmJ9vc/dEGsxc16cw7gr/aGatsykXSMVOEmWNAJt1QvIvIvtYYSn7fmRHooATaDOIIltYVaVHWpXOWBXQRz9AY62D0oXcm5dwMymTgT/WRKVEI8UAtmlp8UenzOywTTVJELge0cV/ZrZ36TK71lsbzNchnbHs/AJsKIw2QFQDRVBFZDnxMJWDs0leqVJ+3R9WQufjygQnKLEt7gwXFSs6uZoQoHfz+1yoOsi+f+E9r9FKVFswqUx1iBxTVMD0CSDpbDKMtmuxTUNIZDsrNbcg2mEjcmiHvo9CEWfkKULnvLwmM9rumNHFmpTGJYzxv9X3b7cKF6qlnq9EkEMli/XIWm6P+CsN3PqGyuFf8vZCGWfaIlU2WGbkHs9PnNwBJ493wJiVYbU1W7tz/Etj7bORv/5Tz4twTVJSITNXQ96WgAX6keLragC2oY+407Itj+YQu/OAfbV8rZmsY4zKL5FXPgc2SBlLVSrI7xGS6EcU8z4HZ9OMkF1m94qgqm+FN081bUZpwJHdLXko5qNdieumN3pWkpV0SRMvbKfyB6y+O0quRNyDp8haVNljGh6f0wxKpWdAaGhngtwqpmozboAxtZGW65NxHMFRBulOdNs5D+Hys8r0aLF4JZaaqeFL3JPVZv8685OVx9ZuqqhCLxVPc2dwMjQaJroK5Ij002lKZ66UMUqazU4xgb0h3WHLZXrEpKEibraEI1Nk7SHt+OGjp41kW+Lc4Uro39Hc1Vn3ZCFEzFYVhJL88QTHGOVhk39gFKU3+TZ+ZUHrJybwKSfzb6WSqJH+yJkwq955W/s1GRzBlz5Uj9Qq0W04XCGYJr6QTG+UmA7OCBFWNLsBBTyYIosot8QWM38TXLJSAcsxRmDyjzzutALxpYtm1E6n+68Z8eOYFFzTU5WXRb+FLNBDK2UGmSrS32CXoBLzpGmeMFpu+NaYvhzObm7o2VS0+Dk8SF
 wTYsda2s
 FWEh/eHMTg1QyuhGv+B+eOIUvhG4ehDspEEsunZgBQBARd8OonVLfBV5BsjfrT0A4gZ164ZqwiJb9Ukgo1Hjpo/Rcm5jfoK3kw1t7DOYww14WQDGz8utk8Y9GzofGB4O4nVrOze9ip9ij2pEwIKP4nzJ+MqIfn3hXnT8pj2pIvmAr8aq/6t5ico0eghw6f5zgl7uxmK/qmReuhbpQdGxcLPZPulf8D+LdsWW52ENQWJAFFclYgrCyDvtA4k3to9hTZc2T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/2/26 13:56, Luiz Capitulino wrote:
> On 2026-04-02 04:25, David Hildenbrand (Arm) wrote:
>> On 2/9/26 23:14, Luiz Capitulino wrote:
>>> Today, if an architecture implements has_transparent_hugepage() and
>>> the CPU
>>> lacks support for PMD-sized pages, the THP code disables all THP,
>>> including
>>> mTHP. In addition, the kernel lacks a well defined API to check for
>>> PMD-sized page support. It currently relies on
>>> has_transparent_hugepage()
>>> and thp_disabled_by_hw(), but they are not well defined and are tied to
>>> THP support.
>>>
>>> This series addresses both issues by introducing a new well defined API
>>> to query PMD-sized page support: pgtable_has_pmd_leaves(). Using this
>>> new helper, we ensure that mTHP remains enabled even when the
>>> architecture or CPU doesn't support PMD-sized pages.
>>>
>>> Thanks to David Hildenbrand for suggesting this improvement and for
>>> providing guidance (all bugs and misconceptions are mine).
>>>
>>> This applies to v6.19, but I tested it on v6.19-rc8+.
>>
>> Apologies for the delay Luiz (as told you off-list :) ), I'll try going
>> through this soon so we can start queuing this after -rc1.
> 
> Oh, wow, thanks for the support!
> 
> I intended to get back to this series this week to address Baolin's
> comments, but I got busy with other things (which is something I may
> bring up on upstream but it's not related to this series at all).
> 

Okay, I'll wait for your next posting and prioritize that :)

-- 
Cheers,

David

