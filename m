Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5426DE99059
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 09:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3A256B008A; Fri, 10 Apr 2026 05:06:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11EA6B008C; Fri, 10 Apr 2026 05:06:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 927B86B0092; Fri, 10 Apr 2026 05:06:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 80C816B008A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:06:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 363B98B64F
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:06:31 +0000 (UTC)
X-FDA: 84642065382.28.7360FAC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7036916000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:06:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eos85lOv;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eos85lOv;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775811989; a=rsa-sha256;
	cv=none;
	b=UqmdpIDCpr9iK1urYS2bCoJH4RNrryHT07WDAeAT4SMUXWK5MQzm2It1lF36GaGBXNYur6
	w2eLHjKaVW4UG4M/7mzoeWV+aOLybxEOTj66zxIjoTEI/PhKQdfFgJ/uN9LDK9RxNrHLbL
	RpwvRai4PGHY1xi/wmP1IxIF1UIKAF8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775811989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+1IIvFD5LJlpG7vAKHkTBvnct0P6iAN1c7ZhFhBGyA=;
	b=Pj20jeGAb/+ygTWkcjaaDLUcD7xrFBgTi7wojDCO3JD5pzUktQ5a61QR6+HBEhNAEKq9XR
	fF6Fuf6R7lLTSsYR2TMH93AVahWN9jzKj2UdqcNPONG9C/PmGQOrWfTacFhZomdMVqIRP/
	mDQF+RtTtQEwbJR8cqkGpwP7qpjjs1Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 699D86014C;
	Fri, 10 Apr 2026 09:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66FCC19424;
	Fri, 10 Apr 2026 09:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775811988;
	bh=r6/xbm9ICEZLdIhlJPxwO6tzE4dSTQazY+YvqBBoM2k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eos85lOv5ieVGVViyeV9H30S6rhaZ66FfCRd2srlJqSdzBHLl0WBvPWL6r9yOs2r5
	 To3G6fQX1vq9l0WTRVqnxL+X42bA83wlV//sl5G8/n062fFsAAJj15qh0o6LIKNqNp
	 DqtVbDWrg+DY7LZ7QB2TUPxy0mCX53IvR5t63iatip4XaImexBLFdZ3wO2TaK91Knr
	 5feVfe+iwBC6EydkqVk4Oi8hen+UcAJvn7tR3QYmlxB/XWGVW7o3u4tjySeuUa8T3o
	 37a5hRNfOrNChzlIhnRdzJoW6x7UHrHjXFuoh0cwDnPZqUSyqkF8yAKcD8/iYhrUa4
	 aTk5qMMxPuo0A==
Message-ID: <51c35e9f-fda6-4a24-acf5-8a332dd505d8@kernel.org>
Date: Fri, 10 Apr 2026 11:06:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
To: xu.xin16@zte.com.cn
Cc: shr@devkernel.io, ljs@kernel.org, hughd@google.com,
 akpm@linux-foundation.org, chengming.zhou@linux.dev, wang.yaxin@zte.com.cn,
 michel@lespinasse.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260410160600883wV0ynx9z59eSt4_lOUFfK@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260410160600883wV0ynx9z59eSt4_lOUFfK@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7036916000A
X-Stat-Signature: oey8w6gc564dfrsfwdxj7xr5kh45sc1i
X-Rspam-User: 
X-HE-Tag: 1775811989-760215
X-HE-Meta: U2FsdGVkX190cW8wJ1GcuPjfU6gHUMekq2s08Ugm0PEfHYtO49Lr2QTHDpVA6rceFVQs5T3Ro9bFzjfJa3B6SgYmPQps7mKe+t3OMDANurb9W2TugwgKX+Yqcx9ng6csuhmGY24TdTNyQxTGxlItO9W53gtuoBOykK6L8q6Yu5Nm45kx3OrIkkM8tv9CiFnQDVl57fxcnpjsP491Ccr6VQrhSPqHKA6i+/gjmVQzzYG/3q2Ge2VwbhpkVPgVPHLRRKkAkSUMzgt0PFkgCMlZERLHTRXhATUxG3zts9WxlEFnAYKfdUrpJGI/GzfN6fuN5c2s3BikRl04EKXG666tRTdYV3Sl/q9i1nQsSOc9GjSw5nGNYFzX7BqThDx8BY6aroNpifnohj84nbQFDuZEjyejNolyDCRYFTa31lugiMa9witK41Rb1t8K9mQZG+eImexXX48rMGk1TguJh2Fag1z4S9Qrg2rSFrdCjVAlVpB/oBoM2upvp4nhNTuSk2Y9iOsYkbI28jBil4rTz717O0ADSDB0TUBE6vlmtVZqLEelvks5nj+hZcx41KwEB+iA67y4vnsXa1HHaL1b+2tui+TVRPh/nr0e54pUKSabaUXpnP0/s4dyeNmXG+bHr6h5QDn6+NlXw0rVP1qSpJgDJBRI9peVvyxITKoTybhGXI5pJryihJwmQvDVBwwHHtBGvP1EvTotAMoZYXqjwaDY0K933vb6YDcr3T7+jssB/mfNYsd7SCt/PeRXOjBkqER4hPNudPtS0jojogC25SSMZdR962dy/n8LsWbyBa+pxw7zaNLuG8yoJS2DH45t9OWuiMMLvp1Wc8JpOMr10o62ZEL7nOPBUR56lDWHskHamayU6QMgdWq0Q8rV1vBUjrzeuQFdgONjVAzXK+om2sRD0npEY24KDWmu9Oc1/CHYz9Kw82bU8nIubMWsQcS7rZ3QGTpdoLXXWKnbeYWZfZ2
 XcFOYEHF
 wNk1uME9Z1fywSBx4coc2RDZBYsiiu8j3BB9dHE+d7gT8x/NsUyyr6VB64P6OgAHbPh7nIb5cQqRSBdzfm0Gmu0juD4rEh5ulT3nkuULQU2e2Vy3TIuYTDmWUZxveOREydbtL460y30mrRMUVBUycR2kxgZi5dGQNOXArMfnHzdv4mip89WfYyRmbYVdV9lZDyDbJceoaVMHqWZ0HoO59+hN9g97YY8yuJW3ihBcBkQD0jqBZMK0te9u6tTMS3s+aMrWoOBn6AlXQznY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> It looks confusing indeed, but it does break_cow because when merging two pages into
> one KSM, the first one succeeds but the second one fails, so it's necessary to
> restore the state of the first successful rmap_item.
> 
>> So we might want to reset the pgoff there as well, OR only store
>> the pgoff in stable_tree_append() where we actually set STABLE_FLAG.
>>
> 
> Yes, I agree. Please allow me to reorganize all the key points we've discussed, and
> update and optimize the patch along with the test program.

Sure, let me know if I can help.

> 
> I will try to release v4 for review as soon as possible

Yes, no rush. Merge window is about to open, so we have 2/3 weeks where
nothing new will get merged either way.

-- 
Cheers,

David

