Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D0F5606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SQI7mRn3
Received: by kanga.kvack.org (Postfix)
	id 1B7BA6B00EF; Wed, 18 Nov 2026 09:57:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18F746B05B1; Wed, 18 Nov 2026 09:57:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6126B05B3; Wed, 18 Nov 2026 09:57:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4D8C6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:57:50 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64C72A84AE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:57:50 +0000 (UTC)
X-FDA: 85448544300.08.9CC731F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9752E180006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:57:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SQI7mRn3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795013868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BkdIn6VDsWG8zcWPoheCDvH+BJrOx12pJ1IaTReXVPE=;
	b=nYKfoJcpsBVwvuelwh2r3cSt7JGzkskfdMOwWgJ5/ZBedrFU0OWcQG/ilJnKMgzg5HLbK1
	gzefei+hzl3K1TC17ERPG+4AHGl5BG19ei1Bt0grg2Z453gNqdWO68rAq3823xl2QbTWRq
	JWcnCpHHyLIzWJWKs3qZw2oaFYkdy28=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SQI7mRn3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795013868;
	b=KcOaUAhuivh7XR2j5v2FQV2XgWrW08M/moiBg8FZXBS3SdYpDxS8zRMijxhPEO2xUTkNWD
	utnhD/FL1dSO7uUa7lGUw2uSyrIT+ynS78uqASK2dRF4GejQ4eGTaAX8nx1guaZV3a0M2F
	8IbsRQ0msxCuHbQCRdvQq6kvkD6tI4U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DF496229A;
	Wed, 18 Nov 2026 14:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82581F000C4;
	Wed, 18 Nov 2026 14:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795013867;
	bh=BkdIn6VDsWG8zcWPoheCDvH+BJrOx12pJ1IaTReXVPE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SQI7mRn3Ocr+l9WTFtkuziJQ5Ix5L/PRpAuag5lSJEpGny+orH251lR9fqn++z9sU
	 fP0YZUgPvSKBYwgVQvFPLX6mx1IuyanLTut8jcrFrKjRZror3raWCGKiIHmOQCGbmS
	 U3QGAJVvbsxKtA+KI0uWoNM799IYqys5YVPt/183xp7i02p6azv/suy/AorVYO7RKq
	 Cv0y1SY7crkiBcoFoXnp4ySpecT12O6eunX8Nd5rvxmR7CKhSomSLaoO1uHMWZJ6qn
	 spOsPQlD2qjpV6yzdMeHfHZOwD7urgbwNyVCJT25E7Dj1vI+CcXR1nUgYlhzF6uiTq
	 55yi0CHcHQpIQ==
Message-ID: <dcad169f-8ca9-430b-a184-ade2210a1394@kernel.org>
Date: Wed, 18 Nov 2026 15:57:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/memory: remove unused
 vmf_insert_mixed_mkwrite()
To: Sang-Heon Jeon <ekffu200098@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 "Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
 "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
References: <20261002160535.661399-1-ekffu200098@gmail.com>
 <20261002160535.661399-2-ekffu200098@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261002160535.661399-2-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9752E180006
X-Rspam-User: 
X-Stat-Signature: mm1ojux4mgm6wtyurfs4gb7absaqtdpk
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795013868-56453
X-HE-Meta: U2FsdGVkX19hp+3y+uxJkzYImQpJHKV/pBgnFTfYq44Q2mTS0fzFxBQ3/WrZkkVLbiDTnT/rXZtCBvLGhnQ44KMG4PcDgzK02peuWpJVe08mxp00iwnwItv0kdbAafVtAy4LQYT0TPtbGTHkx07gjf80kJDvU98Z/xsJySr84J62yMbD3F725H9yPjTnAmNW5BWSo6JTVnFMr+d+jWYfIna1khN7nrK5q3JWLb/iHDAgbjTYp39OokLgQUy0bE5B5NLRMgiZFoMjfq+HSUADWyFL+bkRfxj3U1dgGBmndxqucW/ng2SVlq3PGQ7SWCbLTAdKA1uns8b/R49i7aHIE+F+Y4GY9TCUsue1ci5fJMgSM9bxDOLM67CONpv/Epv8QaCFFXE+zk9F34XX1H/DE4zCFhdkymxPT8GW9S3F0RHdd0V9UbWwM4tFuP6NBQrXcbeysuEjkQKC3LRGTjfEg2qnK7dVUJlCBVx+oOIb0YfmYudYACryvVKq8k9GeD6bJx8tOv9GoQxMRx4FfNL+UpHV2OTHCSkU/7Rb6BgNxexoGid5/yi3uUa9Cp21O7B2XfIUkzj3HhXC4YRlLoiaSkUy2OYqNW24zAeJ8/jUsReEA/+eYyBiYUN11HKPVtj+iqMRrp0saApwLoWYh2L9aTfRQl58ADvJbngFnlmNgGuSiIz3iXDR2MKmhiupJklyfZYGjlgxGF76hgdYufE0pi5q+uxc7npCoeEJUeUfOxnT4vENpUHzrZK1/E/LMkUrVxYA47Z6zgVhxtQOLZUx6akl6etra6thIUXaeApmFZOYeMdL4bTSyupfFSv57srpFK6uxYaKXPnQMku0uQoaliAA0EwDqxqmnNUciOYowsXrFLBqNUxcA9oCT7Vn5JXeuoyygR/xPmaOpLHZKxo/DiGL/Uj+XTeGkDYsM8dFWtbyGzF5GjCMBHYzr3lf+yMAiPWxN7AVIwfCOZIvQ/4
 WR2SOEvK
 nSCA54X1cIRgFKswONNcV5TGjdhFGcn6jOpU1rrHUgpvUTHBf2G97FUveECg3i7de74uHLCKeuOmlADiCcnlNG2hFVW+4v6SuBz8d44Y0z2y0cq7X5mM4lKiKfEZbUdFvTRmfaElMsIg4QQYKi2fYIDfZKlEG9v1QWvPueaa0E/LN7lSEw7vgaOJqqJI52OwmDeNTpvhVi5Yr41l3YImPFVHKX1TUyUgIxtqWg7z2EW/RvYcGGhM+d6iVrazo5hAHwu2NH+xn/CpTjqhxDENYkmzTKhz/Oj0UjXhFxcdFrcvWjRTiCnNGaV3qYpl3ht6vdVNkeZHCzNDFc2WV9ZG8UlyVdn6V8vUB9sij
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/2/26 18:05, Sang-Heon Jeon wrote:
> Since commit 38607c62b34b ("fs/dax: properly refcount fs dax pages"),
> vmf_insert_mixed_mkwrite() has no callers.
> 
> So remove the function and its declaration.
> 
> The comment above the function describes the -EBUSY handling in
> __vm_insert_mixed(). Move it above that check.
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

