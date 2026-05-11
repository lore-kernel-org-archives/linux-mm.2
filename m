Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 088EACD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7027C6B00CD; Mon, 11 May 2026 05:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B9016B00CE; Mon, 11 May 2026 05:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C9486B00CF; Mon, 11 May 2026 05:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B1486B00CD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:00:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 116021C049C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:00:47 +0000 (UTC)
X-FDA: 84754543734.02.3DA8436
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3792240017
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:00:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OTT2DCpx;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgNP5RpPgi1LL0e9qs8Mg4XC0VRjXt22C19L67AJWsk=;
	b=wO/M+U4vVQTmyiO1E75fsc268gQLS4GXOqv0O+e09R12Im8gBW2vED/2b0Txuy+f/jro1t
	aY/1gKGK3IdZUgXxNC8trf05J1CD6pCbxfw1AejGqTculDx5Z1t26xkhxRJvc8jz3DHZQ1
	E17Aiu80u/X18CzbErauUDjyuAGz49A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OTT2DCpx;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490045; a=rsa-sha256;
	cv=none;
	b=ULsmdIazxDKA0AdeAhCLef2VfGqzxYr94oRgtrThecE7NKS5KSsAKtqsnqZTUxQWH9kPFt
	aeRa2GoVUZklOe+Eo6H+sArrsNF9MQgM95tGc+E8VIC00ojlKHjtKqg90tMoGvrlA5u4+d
	EEo6EI1RM7Bh7gXzQdyT4IOF5ileiPk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4ED8C4415A;
	Mon, 11 May 2026 09:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB712C2BCB0;
	Mon, 11 May 2026 09:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778490044;
	bh=k7smP5MusPe3ELVogBIJcnvcbs7Lr+iU2V9b5g1X4n8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OTT2DCpxVJAwwznmhT9Tzi9rrAaKoLzMGdUlOEf2s4KfQakBqJxRE2SQhiotb0YfC
	 GtDUNoDmgf+UdmIy86xRTJFoNgxK1RO0IfniGexWa8pF7aO1pWYLq5e9rbZVkmEpA4
	 ITCIPOIdLNaaH1Gn0GH4gwpwksBBfNKXwZVu19uFyfXAeNa+po510UC5+SqzfcKE5q
	 /xtZxQ/BDvri1i02zKPjUs2BvRJ/WY9VPGyvOa4RifRlGfa2nVAzy3MlVKycjGaA+Y
	 hZOuwSgy+hWhzr8hWWXfD1HOmWjXvPl/WNWcVR/A0HvXC6M60keJVtg+d0u9JytpFH
	 9hmFd/RZz3psA==
Message-ID: <c9c3ab03-5f79-45ba-a1d8-88d016656086@kernel.org>
Date: Mon, 11 May 2026 11:00:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory_hotplug: Factor out altmap freeing checks
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org
Cc: muchun.song@linux.dev, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260511084307.1827127-1-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260511084307.1827127-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k6fj9rba1eqdyxi6ng8tronrrsgkboem
X-Rspamd-Queue-Id: 3792240017
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778490045-385878
X-HE-Meta: U2FsdGVkX1/ZBvgx+VF+EwgQtrU2VcUCNmT0KqcDHg4RXx0oG5MIAErPxrH/zbzDdbA3TYMzP501cB6QHQmsOeibaymGzcwDGkaY2l8yUTvNOomLIGj/YqfsA//SYcMULkiwDgUtf6rDWXJaXAflK9eFns4BmrWVb/Y0R92wWvUMp6qYzE2TSpaE3ci5qHIzCY37LptCbBw/UaL0Xahck0Wa3cwC1VMQGmoCDB+RMGqaEmq0n2urHtOPXZ/XGOBHeFUwuO9PwIy7CvVBGZg3SZFW9MzMX/tdlltslu1NYRXp3JbjNSS+DrrOQ2FJxV9UjlOOL0zkfeZmIuGRU+tMJEsC50hM0HhJURB1G0qpHmMAclu5Y7czNiPus5HWMMlPRw+XHPLJIk5p0YAWJP5P9sNYon0LPBhv+/0F855L0SLtzwR77SA+wFU4Fe+i6UrFsmxPlGvIO6EkOg7Mf0Wm3a8wZjMM26NWciS8XReKOMOeFMFZbiEEuevk7A9V5mdu7EIq0P/3itRfn45wC0Hn7kcsTo9KqkE1G+Mntl4fCacAMAmpUqJzEIE5V0Bq/EP4b0Aj4RPhbC1vTg7vk2rvFpOzbf1jRfVubbQvCOoQhizoyliB3tO6VtH45GEgMlYLwdVsV/o1hFAuFcPri59aZWtOanoBvULnqXuvlGFFmDR9QbnG9efx72VXev4rWg0d7bg9JaonO/mpBwHmH5Vu+PK6p6BatFI57aWAshyWQzRb5nl+gmJSydtBQMSrQcgkXWIQTc7TiVlhwcLGee1pBmXb4Gj/AGTXKleWkFhXpswPhA7elil1HGdF0FZ36BTWf8MMxxB8Pa/E1h0iWodtRsSgYGFbCCJO+CY1ld1Iy/GWyNpx8mX5l6XkfEQPYMEf6Kbfy3gtEBfJ3FE/jSxw6WvYyKCie6tmEF7Z2jPeLW6/2601mhJNvN50O5ObdnNF1pN9BMlcfo2+VPPknOL
 eiQ0YaeB
 ab3tkbpxdaHoe8zht16s+MT/WAEbZlsP8pxwmLR1EVkwwbOXYToNKFDcwHjUJy8sS335hPoLymqFgZSFsKtzRSwLq0xYCPC0Ru7NlxITyy5/XC21rPcfY0NxYG21CJEpLD/+Z990cmNmmx9Kwqf+jN6U0u0re0uo92PPAEd7ShVs1RYI2n9nCm6TxsssX5LGRmcjcX0nUPQZM2mupFgEZquihrHUihj7iAo7h4heyHyFiiACvcHev0twqyVM34yIxJ31JV8lWgaNLihcI20L/DNkhQqEUT0bgFR2Te2gW/DxDrcpIF9dnPCBrPoCJcec9HKpoWfW23e/vrpdiFc2MFCQVCz/m2C6iVtYa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 10:43, Muchun Song wrote:
> Use a small helper to centralize altmap freeing after verifying that all
> vmemmap pages were released. This keeps the check consistent between the
> normal teardown path and the memory hotplug error paths.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

