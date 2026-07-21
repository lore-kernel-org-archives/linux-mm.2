Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE575C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 10:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B74BB6B007B; Tue, 21 Jul 2026 06:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4AC36B008C; Tue, 21 Jul 2026 06:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64686B00A3; Tue, 21 Jul 2026 06:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7001F6B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:21:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9E87A0C62
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:21:29 +0000 (UTC)
X-FDA: 85012391898.03.F37C316
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2B9A810000F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:21:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GKczp2n4;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784629288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZOSPBV5aVAEwLYVjNRoOlMr+JSa2UkAatgyy7uYpix8=;
	b=3kFcvn+I3TPx3tsZ3z4FF25/npnqq9ZSHxf7IOB2vzZ6HK0sgarAaymAzBVHLcwwBvzMav
	6Knw/VC6eHU/j9QtMb1OjFVofloxAkfs3vsAYyB6rEQOY1cSy4MiLyktVt6xDRShHkq70z
	iLo1q6CCx3aur3NlVBJ38e+IYZc5pKE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784629288;
	b=Oq0Vdq8MBHBlv/S2UXUolV4ZJ+Mc4Ghi5zhCebLXvaXJ5alS09G9RquiBYc2poGSwNvaUg
	ZmikX3kYQwYHX74ar47NI/JgvnyvFZ4nsDLX50qos5L0L884dLMDGKyCygxZbO8UZ62viH
	gkm7VC0LWxfjRXQfyYhb7DpyAavQAzk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GKczp2n4;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7008242A88;
	Tue, 21 Jul 2026 10:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A341F000E9;
	Tue, 21 Jul 2026 10:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784629287;
	bh=ZOSPBV5aVAEwLYVjNRoOlMr+JSa2UkAatgyy7uYpix8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GKczp2n4eRLB3f3JWK0e3dwItaCfN77wXgtp0MYQEHWdXye6isZxvtK+87VZcX3dJ
	 7L+0vH9e7Krd/NfLr8PkvH0fLofr45CSzSxWON+v+3ThPjcz6ubPPeO91fqIrX+Zm0
	 s/E45fhdxERSlkvVBlQO7CiDCU1Ix41qun07U+WcEjXWrOAC7uPM8QetvIfzX2NDN5
	 9ym11Er/HniqgG5mZKnzWvuZPoUS8v2vlqNW8izX+KvKyM2PxGqYEQMkL25rqf+eCJ
	 Q1Z+57KggmvkXFCY7JSZvW7R0oGDTu0YvZikaDPNyLV1vRYyOF86hQuls8YGXduXAQ
	 WlnbWtZFpQXpA==
Message-ID: <43d4d21e-1dfc-41fb-88ef-865ca0dc13ba@kernel.org>
Date: Tue, 21 Jul 2026 12:21:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory: use folio lock/ref helpers in do_swap_page
To: Hongfu Li <hongfu.li@linux.dev>, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
References: <20260721013347.65698-1-hongfu.li@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260721013347.65698-1-hongfu.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2B9A810000F
X-Stat-Signature: 3hs6pfr1xk4pir6x5zbgzxs5zfjpazje
X-Rspam-User: 
X-HE-Tag: 1784629288-373416
X-HE-Meta: U2FsdGVkX18CJ9JXXm0AyUup66Z2f4//n7QZSR0y0Y/PR1KA8HwvU4SRgVbkD6Ue/Hw+cEQ6dLM74NyKidajdmTAb95yBNIq34Z0qG7NBikPbkJWK+QtIRuDm0v160+92KaB0jGluzMIrkNg3JxXoIoOb65VaW8+pQwxvOKWPTOYCXoN4eumXSvRWTT+aDELX08mfKrc+T9Netow7N4Z24oA/4apf+dj07zwlgoylKXXGuhlrVyzC9rpBxY/yonpM9YAytCu0eO4xIsEL05WeQHDq33UhLkvurIWcifqlZMpRjuyc9uO+K9AKNq5ZTDoZYaPT4zafPUBwCYouJYntFAegWxy8xkHfKVXXs6oKrzU0tJQ61/0o9RySu3jBxHW7rWVRXTYBA1mJ5eL637x+4Ra0VrXRg6CyP72daE1LlRpyae1dMZ99QDytXQX49OXxTMfdMKy+xbGkkH2Eg57adoorWx4a2cmgs/QNIZFLbiYcBdTI/o6LikqKQhDJGRn6jD2ZZNAsykqK2fD/DnA6AVkW/1xIuRYBm2SH1Z/i7DoEXKD3NaZT2jr8MlB4wx8pom9SrZEfZTxqftjriFZ1yEc/ePvJwF9W+zBbNtpIZXv0+Dfrfs0msbfDEF/6y/E7CSwb+4Lzpgaeh+3bS1ALGiKIcJbJ9oCtaoQXj7A4Yj7LpFb/g4LWaIu1SD69vLuh6NnrezyQ1NMSyFAdsr9yQfc+xUIuwKTcC43MmBidwGFdJqaJ6DzuuIPXo1mLSlSCBwej3+OHsvgUbBLYOaVTWJPmNAqLf8HrsmVQi9GjTR0hcbRTq9ne28pU0wx7aCgtffcMq4xylUv/KzA9JbEFvmfhYC4zxoh1yvmFmEV2rGKeomN9rfDrlCg/bEO6vAggAHQBQAXCA+KqCwTJzYbHL1DHcN/WcgZ0IxHagFjRSzn8NSavIQYpYVkBdSZAGSlaw8q0nvJQJ5eCP2Jz2c
 nelYEn2h
 WgipC/mvMTo9DAEKfaIlwYQORXR2TtWW3EIvkFo3wSOrkp5IQu/9pqYT5pxgqySgiFa0WhgPI82zxogvjDjKCE6qnMMivmwNOfVhGios7dnCn8PHvOg8ApzwgPYwagtoLEH/fgkWWVr0pSGOVvv3uz2LOp0kcGTb0vdwO3+gUBHMMMzc8ZJXK2A0dkMMFr3Ckx7X0AdNalzed2jXSo52Tpdet7rW9W/1GASAOSCuiDrXOqLRN90dfzYI7xnQcnPlgK8qV2fuTXi5hAP2inp1huP7XxXfgOxvdybBnQPWo2Ju+Nz9T5skaj/YqAc+l107Ny3cU0EgqBzXr3W6R3E5RRGwkRPRZEyeVdvhF3DKlX1cN8e+C4tNqz41UTQsYNXEpba+y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 03:33, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> Replace page-level lock/ref operations with their folio equivalents
> in the device_private migration path of do_swap_page().
> 
> Introduce a local fault_folio to hold page_folio(vmf->page) to avoid
> repeated page_folio() invocations.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

