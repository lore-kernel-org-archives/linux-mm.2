Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6209D3CC8C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 00:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D01456B0089; Wed, 14 Jan 2026 19:46:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB1456B008A; Wed, 14 Jan 2026 19:46:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBA896B008C; Wed, 14 Jan 2026 19:46:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A91746B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:46:07 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E164138881
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 00:46:07 +0000 (UTC)
X-FDA: 84332356374.20.20273AC
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf13.hostedemail.com (Postfix) with ESMTP id B7EF820003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 00:46:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b="e0i1+i/u";
	spf=pass (imf13.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768437965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MXzmoFUHbPS6BXubya+ZXpD2xU2NiAR0zQqqyUOBipk=;
	b=eSETQBBcxwCknKZYhI7MD5XC6RcLeoC2MqrmdJEoUW3E3tkrdSpt8/ZtbtvDTw1qK0jgmf
	8+BPSQ/RhYM7E7r/iTOInBQt3s4/iODu9loeXmQj9v0xcDKbEIZTzE1fc5ovFdNXsFic4c
	HAP1hi/Pd1GEz/6QDCqjfZy1UUBFhQc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b="e0i1+i/u";
	spf=pass (imf13.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768437965; a=rsa-sha256;
	cv=none;
	b=rZw6WLKxHk7e3vNuV/NqXPvGYl/9Cj/C39dI41tJVmpuEuRQ8WzbSwcaHO19XvEyiGSMSU
	EBHwIm/pSOOmV1Iwz1jW5k0+JOsM6KxNJxwg8hPidifJj5yn3T+tPJjuz/l/TYpQtd9RKb
	47xeq760+QbiE/y5oSoYd7Cc0EC+2dk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1768437964;
	bh=W3U4m/oqLfESSPENXjy5hyjsmBe+zWiBlc3RcXGMd8g=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=e0i1+i/uEUncxqqlVSxjtdOjgwzzxD//BL1vgaxa3bbLJeDye+Jw/ZF8D8QoQZDX0
	 GzvRBOnBk+STTOemYCD/Y5tbKJXDRwJJ+hEFOfd7v0UuXGWvJcwmcCyGTAWGPMB2Km
	 HX1TVWsrVBTLVE5/+B3DyWd6WlR+LcVZmjfgCaug=
Received: by gentwo.org (Postfix, from userid 1003)
	id 6DDBF402BD; Wed, 14 Jan 2026 16:46:04 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 6B4EA401F6;
	Wed, 14 Jan 2026 16:46:04 -0800 (PST)
Date: Wed, 14 Jan 2026 16:46:04 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Al Viro <viro@zeniv.linux.org.uk>
cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
    Harry Yoo <harry.yoo@oracle.com>, linux-fsdevel@vger.kernel.org, 
    Linus Torvalds <torvalds@linux-foundation.org>, 
    Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
    Mateusz Guzik <mguzik@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/15] kmem_cache instances with static storage
 duration
In-Reply-To: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
Message-ID: <0727b5a1-078f-0055-fc52-61b80bc5d59e@gentwo.org>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: i9ak5d9id4i9d8osojh3qaqfk7bk8gcp
X-Rspam-User: 
X-Rspamd-Queue-Id: B7EF820003
X-Rspamd-Server: rspam08
X-HE-Tag: 1768437965-70176
X-HE-Meta: U2FsdGVkX1+vKOnjEkCoBF6Dddea3POBWQ5GXMRVk1SmnU/6A0u/txItCoEWy/GX0kc3cmvHtHjm/jN0/k6zDRGk/PJ5swYlVXjqPdC8Ekz1aJv1XlPf3lcurAZW14FOMYv11tFwZnj82bUNoaBgw+G/qNxp5+j6La+BV+3UohMY9u6rg4oPmLJkJvKwaEP5MDQ7WRDQDQhlXmslCWwLX2JSl06FKq07LoXFMrBQVnSDmIg75Dk+Fr9lAJWUSr62G1yGqppkOvYcMQMpDW9h1a+GAep8dHM1i6yph4c39SrbUqbeK8qgfKAlD5rwNNi2bvS6PkVq7YL2nlVhhzXi9ntjzC4Z1NWAM4XqtMR+K787+VEVunCjrQ+KQNxJYZyA348dX0bQMAh2UnFYjhdkelrnLHlTK07xzoN0s/PFfrFq8r2N1kNYoKHsYnhSgIavxWgekf2urU5U0mDL2rlUksJKGOV5qG9PJjEjVChe6pjOQOk7lAcgamiY+dbc30yR1S5v7591zkbJME1AF6wDGt6ZCXt7M2D9OxalI8y+jKEyGh9ol3b6fpqURBtFQR53+bo6DVTxQrP0rijUTis00imlPw0v6KxPr/LSYV49sI6PZZQyc4SX4Wk8JNvk74+hMdm0uGTKE3Phr9C5MVhZ2zCzy+6MG/ixVCAO6W03DQrKnTMGs4YmI31xy9tF6CHmjTppKuK3X2xM61mTTHIXEp/Lt4xlhwf48SJesO29otTfOugSwhSWbiVMdfP1i2aTpISBWVPj4W2QYgujxol3p+VqtZ4YOpWfYuxcYZm6bxiLEp51LACRu62wMgMatbTBhGGRwngrzhJckizBC/WbD8kIEvksWnV1GHWN8pfazuq2dQrNapzeJf+7JjAIDHO72o/AyzBcGkf7n2NL1+BijClBVE05nB6A6benKZWI9iu0/qXL0Sbsy6NZcGp9GVYk8xtyMAwYaL/SubCFPX0
 +yt1A2/y
 scXsW6189V210dWiWVmCA1x331Bpp9cnGDPSuGzdRe4Ge+k3vDP5sWDPpi22QhXI7CG+T5Vb75g+7nIyLYkpvt0QWxtyG+8csl3c/Hv5GWlebeuE8ni5J3q8SvkYISTb/xxmPsgumRVNW0qN+DZYElENWDNCXu2ez0LrqfXBw+jHIOO5BiEn3Zh31Kzutm7saxieh7vrs/Z/wlB/QKYFyTM3+NebLCgSbN4YZf2LIOPwDB675lsDRMmP7ThyQN5LkCr+3+umsTzqURHYu85ypODZSJ7ZVlzxK/aT/SSdIWvMdpkQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 10 Jan 2026, Al Viro wrote:

> 1) as it is, struct kmem_cache is opaque for anything outside of a few
> files in mm/*; that avoids serious headache with header dependencies,
> etc., and it's not something we want to lose.  Solution: struct
> kmem_cache_opaque, with the size and alignment identical to struct
> kmem_cache.  Calculation of size and alignment can be done via the same
> mechanism we use for asm-offsets.h and rq-offsets.h, with build-time
> check for mismatches.  With that done, we get an opaque type defined in
> linux/slab-static.h that can be used for declaring those caches.
> In linux/slab.h we add a forward declaration of kmem_cache_opaque +
> helper (to_kmem_cache()) converting a pointer to kmem_cache_opaque
> into pointer to kmem_cache.

Hmmm. A new kernel infrastructure feature: Opaque objects

Would that an deserve a separate abstraction so it is usable by other
subsystems?


