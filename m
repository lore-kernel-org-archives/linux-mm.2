Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EA35C982CC
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A39EB6B0088; Wed, 16 Sep 2026 11:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9236B0092; Wed, 16 Sep 2026 11:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3346B0093; Wed, 16 Sep 2026 11:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA286B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:48:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB8731C2BAE
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:48:18 +0000 (UTC)
X-FDA: 85220057076.13.A5475D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 26280180006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:48:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NFp2cwYO;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789573697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gskwgGHRMM7t2Jel0JgW6huYm8F1pELSbv7bhAuvqqA=;
	b=PBDZMgNHIojVkeBVmoPuhu9cba6oxitg88UEX0HvmIBzuegdOeJNARe2TJW6CBmCZn1GiZ
	dfRFSW1/hA5VeH9h4YJFlzaCKpqYSdb6hDBRsr46ylRIb05qU3QzR9xq7gLV7sOjOx3mBk
	8d4fGrrgBcwnaLkkP0Jh9wB2NuDn22c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789573697;
	b=N+f4jQc7dpdg3PJhGpu9Y2NxIu1USH8wxO1z2Gg1QhrW/rydU4OLzInOD6uPV2iqP+R3Ri
	wiDhD8GgjOv60pB2iBn1YTC6pA+jEbpK3ZqUeiu6xXKW4MlUPyJaiCBQfQJBHPbJ1/Fjm0
	dsodTcFUt8YRAY1jlEV6lz6SNKKeLKw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NFp2cwYO;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C765602CC;
	Wed, 16 Sep 2026 15:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969B51F00893;
	Wed, 16 Sep 2026 15:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789573696;
	bh=gskwgGHRMM7t2Jel0JgW6huYm8F1pELSbv7bhAuvqqA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NFp2cwYO6QAEFYHTGlepp6PIGgfQtTKWLqgWZWIBFrJ/4521Aomax5NAx6y+qpzA8
	 UFCri083JdJjCYTLoGovaX09FvKwqdHZr4XoQ6UEIEUtC3j63YzdV1qVCqynUpo1oJ
	 nPPcmlWlKxuwfFAFJSADHodNAwStbFCHWyzxNMePkwTg/3z1pqI756Rx3k1jXU9pt/
	 QW3TceTrD52IsqnjCcB3Y9EdSPBaw/tgKFHYlt7a+4kIHwTbNVRgHgdsFMzEqK+qnU
	 CIi65G1Gq3v6q8ESDLDpHtgas5HGG/L1PJXsAYvkQcTekNo2C2EsPmdotSnDnwrRNE
	 jnXtPA2MntVMw==
Message-ID: <7560715f-43fc-46ec-a860-4cc63ac4e51f@kernel.org>
Date: Wed, 16 Sep 2026 17:48:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/mempolicy: use SRCU for the weighted interleave
 state
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, urezki@gmail.com,
 chenwandun@huawei.com, Matthew Wilcox <willy@infradead.org>
References: <20260829015943.1258774-1-gourry@gourry.net>
 <20260829015943.1258774-2-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260829015943.1258774-2-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 26280180006
X-Stat-Signature: wd3x5b6js96b5zf1nk1i4w6j775krc9w
X-Rspam-User: 
X-HE-Tag: 1789573696-440348
X-HE-Meta: U2FsdGVkX1+9U1NjL0naXBwWsb3qB93koTurpIhXbtkLQXWKS0AXpvDxkZGzvzDxL2oFtdLRaiwRIGbxIwHZHEUC9q7kvWf5/fBaPUW0r0PYZIfU4aO0zi44qBvKP8l9krVbnKORADcvGpjsbY/Fx3lEMQhdysKFRpMYxPHFacfclMGs3W2Q3QcCQfWcvoNZliPacFAl1EpGOA51rhv89p+vmmImBMmjm9Zkd9GkmFookIukpXuWWItidXsT+NapzOaWxmkN5L+Mlug4l34VuJyqjzEjDHYCKb2x8XQqP/9djzL5O4UHs7R7DfAQ8F0ltGtHJSA+P15Rkt19A9D+QoJkm6wKfU2CNN/0sPKKhrI4vO1xUwY8iJ2/8GhyQJfPZ+LY1eogi82i7JM4XXC5y4lFLPAfY7rEhmB2o5HLld5ZsLlRmRTF6ZpUldLUH0LkhtqpwkvxymVQw2iaxPY2XB5XW0L+forv4vmW6s83HPOKfahjMLxatNL0s1CJtxIiKl5WhqPCYvDIUveolIY6E8Ex9B2Ngh/1ueSFjq+bC/ZvewDase3DrIHMaUzdUKlRp57XqdyXmwK88Ry6JF+slNqGQu9YDTW9Eln8FAyp8OQkzv3MzrPtBzS0Qw/E2pMztVbrkyQTLGcMFCPRrQbvldGQqRug2fiDbVCzFGsbPbFgf7qPUyzGTotLt79NbMZ3h+JL5K8Ud/qlesQpCKayH94ZoexnQP4r+5sqc3ZDrqUWEL/aVtf8Ssz8weBzV9inX3EbcKiLJnx/tEvCnZfhP3DsvJbMjr64wfGnvnmQYDI577Sgi3cpzt4Jg25k8HsQI6Rd4taOUzvYfDW2OTh2R777jHfkKoO0M+MRE0t9yaqpjvxBnzEcuE2a0JzcDRY0pMsmHb+l9RwTEw53mPbeamKy4EZI+GIpwNBMkGxbtdseFL+KzYvfpXM+6dbLnIl4CpeS8vCJECH4Igb91j/
 a/9JfXQJ
 kYlm3OAnlkVoedM+RYWF3AJp/UKfeGugZ23zGMpyZ85lqJ7+EbYAtHydkl8jdtaJKlVPVIZutLcNXANwjh9iQqn8G3v5M7ZNAXIg0aYLulS677bWp+xZPQhfzzdeU44fq8aYKk3IOnJS6Xuvyn7c/H1JHzEbb3ZjsimsurOVQqYTP8bJhIgiUbgYaT2+o3u5FAdJWX33jyev92CxGgJmxlx9SiidHfXxvEoovINaw8HK3b/KBt+ufS1UgirKh2wwWzyoYJ8L9wTU9SVshk6FWyrvAhfpcA6Sl5eHJzWapR8B1urLb9JVsPogAjfXTffcL459m3gaVbZwvpsVlwfC1wp1we2aYScDl69TQarI4TymgEdaOV74B5YAZBz0I+a+r8vqJZYN/isgSTOntje0amVBbf/6NhTMcMh2w2Es55TMca8fKS/pdScxO5Rs4ya2GZfvSpeluGcKlRV29jbdokg4tixi/zIqANVql4Q6ln8OAs4Onai2CiOix1Rfia4g1ZTbz6mZm7c0V1wEI14mnKKoxdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/29/26 03:59, Gregory Price wrote:
> alloc_pages_bulk_weighted_interleave() copies iw_table into a scratch
> array on every call so it can walk the weights outside of RCU.  The copy
> exists only because the loop may sleep in the page allocator and so cannot
> hold rcu_read_lock().
> 
> Use SRCU to pin the global iw_table object and use it in-place instead.
> 
> Retire through both flavors - call_srcu() for the sleeping readers, then
> kfree_rcu() for the reference-less ones - so writers no longer block on
> synchronize_rcu() either.
> 
> Tested in a VM with KASAN, PROVE_LOCKING and DEBUG_OBJECTS_RCU_HEAD,
> with a udelay() injected into the read section to widen the race against
> concurrent sysfs weight writers, and placement checked against the
> configured weights.
> 
> Every retired state reached its callback. Swapping the deferred free for
> a bare kfree() in the same test reports a use-after-free immediately.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

LGTM

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

