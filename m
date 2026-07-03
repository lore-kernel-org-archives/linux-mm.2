Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86123C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 08:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69E2E6B00B4; Fri,  3 Jul 2026 04:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64FC76B00B5; Fri,  3 Jul 2026 04:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515CA6B00B6; Fri,  3 Jul 2026 04:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 231BD6B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:20:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A4731C3741
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:20:32 +0000 (UTC)
X-FDA: 84946768704.21.94C0A34
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id DD83E1C0007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:20:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CaOXshCG;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783066830;
	b=sCII6gbZVix0A78eAwuI0CIYJrfVeqQ3/Lz7BYXHa1jya9UdRO2vKkqfh5W/CxxuDUtSd8
	FWt4ZYYSP1lzesqQLyfVdFsOJBtqAd29kL3Dk58mBXs3TqI3REy+PiRkpBly7/A3EDVCJA
	uJnlywUe6ihPj7aLdaG6WVyP2reYgKU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783066830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9eBMQkRAIIiiD1/VSxT9ESyU/aInOBlcadzqDqKcKNU=;
	b=p/KMUEtgsxjNsrbncZTpuPKXjrScaEoQM9Sfgp7NbV1Ws31Fxr4YSPBiUDS3t+UPQws+r5
	iTT79K3dHw7mWX3ih3DTlfOF+iC5Yybcw4VKDgaQRE8rMNX1ljXdkTz21eTON+WAxAQ4zX
	F811rVi97r2s8rTfnyTkSXhsr49shV8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CaOXshCG;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 56683600B0;
	Fri,  3 Jul 2026 08:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CF21F000E9;
	Fri,  3 Jul 2026 08:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783066830;
	bh=9eBMQkRAIIiiD1/VSxT9ESyU/aInOBlcadzqDqKcKNU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CaOXshCG6r0+KBtTiJ19wWhAxgPjDZye71u/BG7CxHsUKpc3RHiFsgmNAeoXaP1O4
	 6q32HMx8WwAwDQ58RRTmrRifC4mAW8dC4TvarNI8+sQgmwe920m/4AzlBEtLpLhUnv
	 PexAmaNntL2iK8cp5YJfzouP7DSHBijvWa3ildUzneJR3Akh0lLJxwVo5vA3YfUcxN
	 eqFZDhZZ8F1IXrGYXkgBr/Q7TTeAe7qvd3SniX7e3uYRD5TCXV2NKzTxCjRDvZ9KDv
	 3Ac37l+nwyONhEBaK8V/CMqJYHGG2LwHPtl7RtRBk53oEbRAFDhwbs7QlbV0LO8k4Z
	 TPLu6FVOoI9kw==
Message-ID: <2436707a-b6ab-45ec-98e5-538e18589462@kernel.org>
Date: Fri, 3 Jul 2026 10:20:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC hotfixes 2/2] mm/slab: prevent unbounded recursion in
 free path with new kmalloc type
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Danielle Constantino <dcostantino@meta.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260702-kmalloc-no-objext-v1-0-167175008538@kernel.org>
 <20260702-kmalloc-no-objext-v1-2-167175008538@kernel.org>
 <de2e0d60-6954-4b54-bbff-ae78dbf9f789@kernel.org>
 <b3f15af2-2c01-48bd-af87-e27df32388ea@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <b3f15af2-2c01-48bd-af87-e27df32388ea@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: zwjoooephegcuztejcteiyzqea3sbf3n
X-Rspamd-Queue-Id: DD83E1C0007
X-HE-Tag: 1783066830-821303
X-HE-Meta: U2FsdGVkX1+iULH70a9U2dzLOF1TTr4jQ46dDgo5p3KDd3ENbWTsHOYUHQ24NFk19oFnJoi0rOs3AK/2eigK9xSXB+evPCyDTCpdauzeVe78Ajh9fxPJYvM75sU9jR7FJFak30HNk+RFxfl8t/jeWvsc6XMsLDfovz9bbTZ79X9ZFNfGUIM0IpSv+XhIyrDeDzNZMFjPlvq6Y+pVW/XVpJ/w9g6RQNDeUrnJ60sox5YPe2Jh/h0sW7eREVqsq59tRQvow1yS8L8Aiz3YC5AkXbaAdGt94P4cUa8OSkB21OkhUMEhBx3FWO+AfEgII4J8SDBFydzqBRuhAmaIYzZLwKyJBms794Fciff6CPQoKow0ruBSA+d+azS8fhwWAKp2gGqvfttU6zD92HAiC2BTjQ7/Hlow7XtsHXb0Wd+LQNUYyyOcnBhZsgVaMlIXYgUbY3b59L2c3nn4twFX8QPRrQ0gs6snC9ATA/2Xq6RCKNTRh2hmvMHjezqggsCcsUwF0+sl0R62u2qnQEvN9MNMcEngXFQQHBpP+P+XrwrMTDC/UAxwHrQTbyOs8zgmNL8/s3eGkVox2MTH9UEDr6iiQsKekOBS7acmKu3LN8rKScQHq0UupqywSek6gmQAoH52fh0buGKJqp+RuZoBZ9UADEAaS5GTIyR3awqQX4iACn6aqILtaQeAwuRY9WdrEcrXNU8Q0/YFEQPTWShypLDsVUY8Ovj9yAgsqMq7x86t+VmrlDh88jzD6ptHV6TEe7Ca1YiOraqK+0UL4pldfb6VE+AubfhL5AlSU9y0Z9XkyhnEhVlGGmOYZJzM66naL+m3iGzTZ+L1RK5SlmMmQIN3HKqpTAJ+OUidtfcNYVKYfuOWr0jX0zloAJTc83AFy6Ckf+fgklWyHMFO4unsbnBSa2xFPhlGRyK16v4rVkJcABRTj0yMQRYs9wF62B0r6eAnefR6yLUkGaZ/l/k6peF
 YL30ttOq
 soCsjyf/aVNEdru3zQmoOQ4bu5EbHjhCahTAPUG4GNtUd//t+9fdIyH1pQ3ysbUwHs3ZYRMGIakYV/nApNc5gi491GXhBODpsDOme7zZ6D05EO7TsNWa2fuBGtKG2wddaMYamUn7aMyoCcnxjJCEAJ+5vSnJz+slACuzf3NGYeJwaDr0VvrdImiCjbHuSH3mB9rZjWQu814NqCzYwrT3hS08jx12zOQJVrTv1wgf9DDE+lOrZrVDUYlqgDCNxjZM814VN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/2/26 15:20, Harry Yoo wrote:
> 
> 
> On 7/2/26 9:57 PM, Vlastimil Babka (SUSE) wrote:
>>>
>>> To achieve this, create a new kmalloc type called KMALLOC_NO_OBJ_EXT.
>>> KMALLOC_NO_OBJ_EXT caches are created when CONFIG_SLAB_OBJ_EXT is
>>> enabled, and they have SLAB_NO_OBJ_EXT flag to prevent allocation
>>> of obj_exts arrays. They remain unused until allocation of obj_exts
>>> arrays for normal kmalloc caches happens.
>> 
>> I wonder if we should just use them always (not just for kmalloc_normal) if
>> we already have them. Would there be any downside?
> 
> Good point!
> 
> That's more intuitive and sounds like it's good to separate them because
> likely obj_exts will have longer lifetime than slab objects.
> 
> Not sure about impact on memory usage, need to check.
> I'd say it's fine as long as it doesn't clearly increase memory usage.

Yeah there might be more usage due to separate slabs, sheaves etc. But maybe
also less because the separated lifetime, thus potentially lower internal
fragmentation.

> But I guess that should not be part of bugfix as it's a functional
> change that is not required to fix the bug.

Ack.


