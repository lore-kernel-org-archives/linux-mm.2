Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6723FC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC456B008C; Mon,  7 Sep 2026 06:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D716B00A0; Mon,  7 Sep 2026 06:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3836B00A2; Mon,  7 Sep 2026 06:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2AF616B008C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:40:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 965A68010B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:40:17 +0000 (UTC)
X-FDA: 85186621674.15.69FE7CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id BA637140008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:40:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="M/eg12hf";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788777615;
	b=GBCTggjxE0l1oNLK2+ENz0tkZZOrq5fFlFqQnXw2/jBUGcIWdh9SCbFX686jFwdkGqRLlm
	mS5SkNg/ZBKtm9buQ1FjLLx8W696/4HcOJeN2bFyioxvgF3xkd4xgfkx9/fiL1+006bKoU
	Mu+zci74olLYoclechB3n1nIBBnawZA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="M/eg12hf";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788777615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wrV+FNvI6RXsSIMowCgW6ECgKmSPKXvaiOz84anP4m0=;
	b=N3nx0AwIBRPJ1uHkDmNqrKW82LJzESa72Ic562yiJAeawJKT0nQuVFYRrffM4iEuwVed+f
	IMJyThnUjZLy2zrXo5eOVWzQv8MkUDO3paSfqsUyf9ZcY5nqdK1vTfrfXctpg64ThFwNyL
	Whi+na+FNDmyoy1JtVrDXP8QW2P5ZaY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4300340F35;
	Mon,  7 Sep 2026 10:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4EF1F00A3A;
	Mon,  7 Sep 2026 10:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788777614;
	bh=wrV+FNvI6RXsSIMowCgW6ECgKmSPKXvaiOz84anP4m0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=M/eg12hfv9NGYHbqoOYAKq72yaNM9iz50UK7xfQn4IQEv2THkZeqN9OSwCrFVtQ88
	 DmuiclAhUztMJzYdyjr7b1U1YfJitT+JOSwfqJZj0SjwQbbz0j5MsHD3F+6hb+wbFG
	 vygVCKnX758l3YlW+puyluoC+82iV/2vilC+6Egmcy8zTUlPwc24xqcKN9brD079iv
	 Cxd1z2SUuc/VsWM9zDolWgNJ0Ge8VSLO/k7/c1A1gbaX+sEVVAE+p3j/PdoXWRDJeS
	 G5+t9QpajsHz+qTTPxHmjBkD1tQir0fUmJMCfC1SyEbjFmEhQv81T9Vq6o3itVTKsu
	 9qGRp3o/gc32A==
Message-ID: <b7b8bf57-ad14-4304-9ca6-dd53e299682d@kernel.org>
Date: Mon, 7 Sep 2026 12:40:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs/core-api: memory-allocation: clarify when to use
 kzalloc_obj and kzalloc
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Randy Dunlap <rdunlap@infradead.org>,
 SJ Park <sj@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260907063654.2248617-1-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907063654.2248617-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: csz681rh7hn8erymikwcpmcsu3y3fedq
X-Rspamd-Queue-Id: BA637140008
X-Rspamd-Server: rspam06
X-HE-Tag: 1788777615-883017
X-HE-Meta: U2FsdGVkX18ddeQcmnNgu8EcSINadObvNXPiA0KjC7R7nuGdd8G4BdHetjZkFbfnwLp8WyWeb2ZbIMsmZWMUjkouRsctUs2DggyTabPuSwCtyuWCLbobUb+M7us6tE/AQAXMh74U4iQJTgp3kEEbDbbwfGayV8rpuLmTyFK4wqHym5c0/kG/zoKjMqk1dLtafgGmJBYd35UdW3Newh/0UAFvYkEsDIvbKzj6jfZJV4IY2oElx+2642HUp58mrV1tZ45cPOolzerwNwZNnrVJdBRtZEW+3/gXrQAwkY2cbSpFUgsv//GePSSFdI8JhtrCae45C/3gsUxyHu4/ohPUg1uD504fwYT+ZJOb1KYWIdF1sobKmxibZwXupsy0bxLLrGpjBsPjf73AwqZLKJjduW7DUaM7mRXrfQKG0lcbLTtwabAaER/D3gt461/ziuYCm24T9J0bgqquuORzvIc9XUmVRc7ODkb+rT90fm8hZtYfu8vCQhSYZDbXZgAv7L6/bBg7Gx94ixjFNuvS2Ay/sKSNYCc1kHIGqLFOZkeXsSoA1w4p+9Eeq3zPf1s0qO8t1/l/KY9MKXl0uu9Ak7AU0LP2sGLzTHZCIM38HhyUS+zwGmD5bR64efAPPqk1KmhymlEKBZDv8/ayhoMl7pyMNXe+s02WBmlhBpBdTIDWc/m8LYsbayc2ifa5sLa0Ckso6HgFtW663VHynklweLAIeONf2yx0nCuhOGqAyI+n5eWllJ1Pbud5mMsvhRGrO9vvH48KCYpdsWoyV9k9qqtf8idcTqXbmuoM7Y8y/oyUfX3p+fBvmEScgwJWcBHcLubq3t1+5gNqORvl5WKlPqqEG08PkPZT3mu6ZHJ7/6St8ZHTWqwYM9rJJ2qP4ZngBxtjcwpUmoPYo5YwJ0itKrOYPjCdc7/aBk29MgUJRAUbF0E4K2Qd8MtsRfPV+cHc8Rgi31J+lcxlEJktpdHkrv6
 MjObSVyY
 0WXGG4P6DqNBilawu5ojOzpmSrQPFnv3a5EYlgqgt6slgUs0Erd1AfZh2ImRz2arABJqwHwpCl2FHnOmN+FgVZ4AIHl5MLLVoL5LteNVDw0tGUDToHwqMXX9aGuOl7aMviJKPWWojhY7pgJloQ5OVHmhdjtor04qbS08eQOilmQpypdCnLrD3Ds2uaYtJXuewt9I+XxHk9A5Za24dSJBqNB55A5EkkcywYA7G0QUnMOfm23DLclnchPJYufh+93PKx7RnJgokStDU+EMVsEZS0r++7EGq3SiU7qZ9bzQ3v1yk3Okw4IuJ1F+u+GwurZEkmnWlhnOQFF0f7as=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 08:36, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Make it abundantly clear that in the most cases objects should be
> allocated with kzalloc_obj() and buffers should be allocated with
> kzalloc().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

