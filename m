Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2EF5606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 09:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m4aRDZ8k
Received: by kanga.kvack.org (Postfix)
	id 898806B0648; Fri, 13 Nov 2026 04:40:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822C36B064B; Fri, 13 Nov 2026 04:40:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2AD6B064C; Fri, 13 Nov 2026 04:40:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EBD46B0648
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:40:49 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2037404B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:40:48 +0000 (UTC)
X-FDA: 85429601376.21.D224C5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 14E3820006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:40:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m4aRDZ8k;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794562847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dubaHgy2wUqu74yRZWpt4ISTG0bq/E4Btq1QeBy544Y=;
	b=gNoin+WVKqUQKAn06IlmP9woVzsVwy7aVmjM/nliwBlYWROUrH0jJyO7esgIueWY4pNQ3b
	KJGP7ehs7dXXh+LC4MT3+Zz8Fgx7dEYQRR+uqWATF/hF2bi/yItezQukCsnZda78YgYYxE
	AqU8liwcnNAJAd6sbGJ+nh+uW4UHyl8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794562847;
	b=8Ml1A/jGX8flVJL8lpvW4RmT3YZAp9xGDrGA+6S/nJsqla/P4Vp437y/QQQetzY11uFqai
	hrNfLSUWCylTX24AO4k8WuGRzfX1m/2uK8B6S5uAW96OqBIGo4/qbXoT5fc/yWYJcjpgSM
	xxW0u7ySunYR3/CGbSJC4OvFuRlrsIY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m4aRDZ8k;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 568696152E;
	Fri, 13 Nov 2026 09:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9241F000C4;
	Fri, 13 Nov 2026 09:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794562846;
	bh=dubaHgy2wUqu74yRZWpt4ISTG0bq/E4Btq1QeBy544Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=m4aRDZ8kANjX5nBBATzVRDUjZAcfcyAXK0QhpncOueR/hS/rbImJL0neBkxEwJZ87
	 KlvWnFDMynyDFzuwi+gKCR035krC09laIiY8MsUew61PDGPPtDedumsWN71sG5V9IC
	 cwd97RBBwDVegPHZKhWZ17QrrVRrQvUZLPesNsDYrx7fUWmHJ9gF2wZMyx3+2MX2lg
	 uY2EGKDlKtVuB7aN5RYZhdsTyaQDqjULpuvcc5yganz3nvkumIpeqWOg4LVgZDERHM
	 ITgiogFijoxeQRFdhRI+6K3I7SHGAQOXpHRpm+7F8QZXrTYN6GYtON0lHF1XThZ/oe
	 gxEZNrPu9yXug==
Message-ID: <48a54746-d791-4035-81ec-81587cf92802@kernel.org>
Date: Fri, 13 Nov 2026 10:40:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Add IRC channel to MAINTAINERS
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-mm@kvack.org
References: <20261112212230.2805832-1-willy@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261112212230.2805832-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: n8tfucdp8xo8qwzxzrg1ohw6ger18nbe
X-Rspamd-Queue-Id: 14E3820006
X-Rspam-User: 
X-HE-Tag: 1794562846-33418
X-HE-Meta: U2FsdGVkX18dfcsnc0oVWhSKRyuhY4UZOYhlNlaBHG+n5FXv24f3kmA6Wjiu/Yxl7402rx8uaCWAGg6W2D2MoPJzi7UMM1hx34/9zqPHFkr24mfJhLgdBHMd6bEwxSnchoSbYIggrfyAiPS/gmKM4b/EUIF0Jnf5azfyiFJUSgMulpVqaaCWG5R2HjIftPAQeGtCl/Jb5/GqdDaiixxfMCyET0HvOBbzNA7GEwtoFPfRmqYunLR5G574wwlkZA76Fvd5E7C7C7IioCFCmYPlvHnE3TVNCvBH9rWawrsNyvvr8fkzchEudvkT2H6T9Oh4vynQewL/lzwQXkaWoRBP3NQf/5NSm2fMkpXdFs/w1evaaqt9gEWGbpNI40kcqnkl1IA89N3SPLZyA6cCLm/edLsXBclsdje5CmLhDTPm0MGIU3Rs2L6wcZLgWfp9uhluwJcQCBkTUpzqB+50gPf+GR+hhv6pJzXf/dFBHIngiPkkP/YW8AivTf6pvWQOVFZ2QrMt0GHSJLrNr/Ytw1JE3TJm3wCf5q1BK2AyYWMzTZwyWzkGRnf7mhYfUBHwJ0e0a10OeyRx3tPc9NcA9hYzBlfaUetQ+4RoiEFKuhVhKAVrLR6ho9DOD2NVki/9gBBiZ+uBxpOhvhL4+IWLda74n4zHfDzcRPD+pqCCBxKPWpgbMN2m62Xny/5tHiGBzikv+dWnBxm+L4OlvjUyvXQDRdpaaB3ZK7CoU4uj/4sidAu8duPc4gBzhYOgM1nPAWY36I4OLypKrOKHLAP6KI32qH7Mr6T+snDSMwdJy9hkiOn/aDC+GoDmHQDQC5tHCsii2KDJ0E/cQ0CXfSwYUj3Z6bsmwpb1hcQmrvgOU0RcvCV0tXUuOyiHHHwoyXkDdN1CmzgWtOlKqY+8QKFv4QmebsdnqdYEbR3CzA6BCG40voZWhY17kOuPvwmgM7x+WdiTswmniezq4TaL0RrUUy1
 2xhpKRI4
 oIX0Doh9P4fVgaViaaWKg23Bg2T7svWJev3fO9X3KvE2isAfIa1uR4WL2Uqr9jyVawfotmBRfU4gr8tPV5DQonxt6ajnu5Il4fOd+174tDtbeRy0AGPy1DgPYyOtjTaAtMQ7GINVYSc7ULfc4BtXg6Pkhjhk2duNIr1a16JsQmYAEh4cPnBdzsuleeIO7y8FORb1p7Vq8I9YZsH7NZrlGUCEoKC91EhOLOjoQxK5GGCv+A97Sa+KTs+Ij+pveneSnxLSWE1SgD3UWFSuIJ2soSV6s++78KB9DrN/d/ghgBgjkqxpnDzjDXjv+lzYg+BFC57Cy9Lfw+AsP04VQ6lI4u7XbLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 22:22, Matthew Wilcox (Oracle) wrote:
> The IRC channel has been under-publicised for some time now.  Add it
> to most of the entries which use the linux-mm@ mailing list.  The only
> exceptions are those where I think that none of the listed maintainers
> (or other knowledgable people) are regularly available on the channel.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Definitely more helpful than the previous link to the outdated website.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

