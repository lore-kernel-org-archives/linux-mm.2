Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45CE6C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 08:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34F1F6B0098; Fri,  7 Aug 2026 04:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9056B0099; Fri,  7 Aug 2026 04:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C85D6B009B; Fri,  7 Aug 2026 04:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1E096B0098
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 04:00:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F6B71A039B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 08:00:48 +0000 (UTC)
X-FDA: 85073726976.15.DA1A249
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A74E740008
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 08:00:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BGxkSB7b;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786089646;
	b=7MMbnDuQepdG35GLID/GvtlOdqhqxTlbYbvLPwSlY6pgaYo5PYWlRnpjMbyR7RgAIGmGOO
	N/9jKrJZb4bBYIMXInWK0XmyLV4saRaAAzEmVYi1xk8D+AlVCgANoz1DYEEN5tHVFdJlyu
	cjk89TKy2XbtDc9HY9vc6k+ZMmjMplE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BGxkSB7b;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786089646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pp9Tsv29Kywtrh5hEdWeyb7iqMYUwLZdWf1jVABveyU=;
	b=JHzle4ULF+J/FLvSL3HGBwSA9P9S4IhWahDWGDAvWdhfeSAFr1NVoFw+TVfmgOWQttGWIW
	D3Yt35hDC/Wqjypbw29W3Ekm261J5H7ylieD+zSDmXBURLr9seQDk7azyVMrCI6SayyLAh
	qkWaMxSdVP+ZnHL/C6BZsaG5JYpZ/TI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B54C60DB8;
	Fri,  7 Aug 2026 08:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2156E1F000E9;
	Fri,  7 Aug 2026 08:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786089645;
	bh=pp9Tsv29Kywtrh5hEdWeyb7iqMYUwLZdWf1jVABveyU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BGxkSB7b0W3zfv5VH4I31EyJ3FHofLv5b2Ii6whX6K8yx6nU+vTpbHMSbnSq2nEye
	 4TnU+twVU3U6n3IfnPx9Ab3xkkwZezuXsjCdIffZ4CtwasQ2F3NVGCdb/ttKomy8QQ
	 uzaJoKSeIbmQAGtvUVmBGTnFwdEcZZ3w60MacBkZeIL45YZ3K29eCOcvH5oqYQxY/3
	 ElseNhCP0U6R9XXGKLfb53IUM4M0nc0d1cRf9h0mpW9NN0RGJ0yXibvK4+zYnJi5QZ
	 gCFrh35hpBwccq/EuTS0xf5/2a1khEFIvpBggIEtfv5G9covxlrryF1Nxlljewyilx
	 FeCDqXkL4zhog==
Message-ID: <ee7f1dc8-c37f-4ed9-9ef7-71a65aae96a8@kernel.org>
Date: Fri, 7 Aug 2026 10:00:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fork: reset pointer tag of vmapped thread stack before
 vfree
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: sparkhuang <huangshaobo3@xiaomi.com>, akpm@linux-foundation.org,
 bsegall@google.com, dietmar.eggemann@arm.com, juri.lelli@redhat.com,
 kees@kernel.org, kprateek.nayak@amd.com, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mgorman@suse.de,
 mhocko@suse.com, mingo@redhat.com, peterz@infradead.org,
 rostedt@goodmis.org, rppt@kernel.org, ryabinin.a.a@gmail.com,
 stable@vger.kernel.org, surenb@google.com, vbabka@kernel.org,
 vincent.guittot@linaro.org, vschneid@redhat.com
References: <anSVlVpUXrA8ra_z@lucifer>
 <20260807065351.93659-1-huangshaobo3@xiaomi.com> <anWPTt4DE-Q8PKry@lucifer>
 <15a1b3e5-825b-4ffc-9349-de771cbde7fa@kernel.org> <anWQIwKDHj-8SXO0@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anWQIwKDHj-8SXO0@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A74E740008
X-Stat-Signature: bqjjbt6jfzh1y5mbnfdzz6ari8gdd9oz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786089646-250288
X-HE-Meta: U2FsdGVkX18QeOV0vmbE1imf0UjMSXiGx9la+8578KDU4EDxolkMEoI5JrD3KGPllbQoDmgyDaSHObqvFNRXDFYaH63sNHUgaaCRhLj3vJLhLyuuqQ/c54pF84JtCEaMzRBm/eG8XOfu/7FcmOd5Znj7bO42KjMlbFvKIFjWIy9VHMaxbwyatwnqLKUHuzgCrVyuE2Jcgg+SryaS/RO5MmEC8NfiSrnEwQMSpQm1UFy3WSJ0uz6kjGomDH5k9Vmkvi3DIuDznaO2rjztK6AtqNf4ogRl+Xs4w52rLf8GjzVhsU3IiBEFrH1q5t2WwPVf8qWmi+GjyUmV6tc4b0pvQfLiFP1sVXHrAvC+qWh1PEZevuOqLC3rFPmDdCx1uh6Y6VZe2+NUBT4AUfLeSv05LmIlmn4lRAVKMUPq8Xv8jBtMJApkolqWREQ3xGIXgijCuVraG2ZOYI12w4dhaENp+dUvskjCzFNMZB8mb+9/6lPa0uSclIvje8X4HUpB/glBbGtSf0TDY1TTlGxstpCYMgHtRMELXlFfVDe2KjpIixgiZj+3waguY18AihCD+aQo992K/DIw6SL8s7xcgSG2UD/NE7HB6TzWuFVhpFuZwazE2W8XWJbtgth90dUI9tzvld8snvkqqx8vEpjE0LrX8oWyHO53/dmLXgcFmniKCBuLGZJ5/wj74Jtz9x/5twd9bKPS6TB2WjiGY38BAjImQNDnHntadek60fXzBPvMEm5ehI6OD9jl4DGp9YQPTXlWdI2vK/u+1bZqGqD/YduVxfT0SnI9ehcS1QdWa8vAJcBJ+kx+xMoPorhfNBGUlWI8pGYSCLXewt2UVEN4JKOnrHrOTNiUV8/baRmS0vWfdWAiASrmsWDqYZlYppIbRRve+Axz+PxKk6r/W519jzOeDYqkbewYxitW2qHRnZWu5KARUTXXzZB5AAKxJoZKQ2niEWpHmmdMuOoqgIaCxU0
 2mz57O9A
 hZsrcYL6B8qcJjZ2qOVgjWyq7k2sapKV/PKwJ/zkfBw1LD0O+aQsrlceMwikXJPDfcQZ8w//fZFOPrS4I6JaLo73n6B1a5ZqEP0orT9RMtdHsI7j+bX25/8gqYMsIpZauJs5I3DonHNF1f0vF3Ut64sfhcdT5ZTkPQVElRonpsmTrXufFr0FT3u/TDmRBtubz3wkJgRrjTaAwgG4NCE6AM/8uhokU2MLfiZY1zj4MCx4ly+IfdJB+kaz7jM1C/bk6EAGeNz+9ZWcc2H19QZliPkci2UBgtQ9WupSnMR++E771NmrAJcsPd3LNTnU2sPohgiAvokBGe8kBdYk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 09:58, Lorenzo Stoakes (ARM) wrote:
> On Fri, Aug 07, 2026 at 09:57:30AM +0200, David Hildenbrand (Arm) wrote:
>> On 8/7/26 09:56, Lorenzo Stoakes (ARM) wrote:
>>> I'm sorry that whole reply is more AI slop and I'm not reading it.
>>>
>>> I have zero interest in chatting to an LLM via a middle man.
>>
>> I think we should start charging a workslop fee of, say 100$ per patch? :)
> 
> I don't get out of bed for less than $1,000 ;)

Oh, sloppers are everywhere, we're going to be rich! :)

-- 
Cheers,

David

