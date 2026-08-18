Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89E57C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 17:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 735AB6B018D; Tue, 18 Aug 2026 13:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70DAC6B018F; Tue, 18 Aug 2026 13:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623A86B02A7; Tue, 18 Aug 2026 13:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F1B66B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:21:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE8C91A01B7
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:21:07 +0000 (UTC)
X-FDA: 85115055774.30.B91E0A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1DBC920003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:21:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iqnz9UMl;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787073666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=usamnhvWOycZ6oPtfGQuy9B/PR/s1qj690CQK8wra7o=;
	b=u3eJ8pXNB/OjqwwwZ1vJ8JsLvisWKhwzI5ZnE5QEaV4r70JBZqWN9rh0Wg/b1U9kFX9Rrj
	EuFqeSWsi8bHpo1p7JYt8zEqVu4aQTsvRHTiZxYLiPa0ZZVGWnRieEnaBO4mkrd3kXrwsL
	sZpAMet7Tq/6cdxOPpkv8WNgTPiZyd0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iqnz9UMl;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787073666;
	b=TGRBY6TG2yPLFR+fsrwYmhl2+7SjxlvqDUBrovUmGfTmmXegOqIAgsbO9GZRGSCfzvYd5d
	Y+AAj2J0QNiz/4+xtpXt880RizZFhJBYsnjfE4V5kaZJFN0wWwT3GPWMBHWroqzJ97n2TQ
	j488wB7CJ24oQtZeLMIu4+/Wk58Yno4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A841E601DE;
	Tue, 18 Aug 2026 17:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287EE1F000E9;
	Tue, 18 Aug 2026 17:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787073664;
	bh=usamnhvWOycZ6oPtfGQuy9B/PR/s1qj690CQK8wra7o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Iqnz9UMlga0okF1l0c78suFZFQqYyb/ObiOdyh+5jt9rAwZC0OV+2JSpzQFp4Dm8d
	 tNPT/9KgLPaoglwZUx3ptPjCPh3TtIYbdrb/EHKwrp/rOCW3Ltp3fWWNzXVoUsgX1Q
	 zqrawh25u4vR/w28ZPvRyBvjYsbon7qmiWdxfTxQoPcByhyrVh76yfPPCjTH6hkHMV
	 uxJZEv46cyMr1O34mR4cyBWx6L96nNfAbGujhe+6Jr5ojCFODvgSkDaVPXpRmDB7rB
	 43dbF/Z/RDsCrFz9cDuxdUT/Q79YIc5xkssqVBHTrmtMDzooAvR6G+nKc1lu6zZ7qZ
	 xsrzNfIOjOMZw==
Message-ID: <397f60ab-4a3d-438f-a7db-4c598af13f1c@kernel.org>
Date: Tue, 18 Aug 2026 19:20:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm, swap: ratelimit bad swap entry reports
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Oscar Salvador <osalvador@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 stable@vger.kernel.org
References: <20260818-swap_part_one-v1-1-a4fc58119fc0@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260818-swap_part_one-v1-1-a4fc58119fc0@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 193dw1j5bqwghiz99gzsgua4didhhf8k
X-Rspamd-Queue-Id: 1DBC920003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787073665-802647
X-HE-Meta: U2FsdGVkX19TZzMBMNa52ADzKYXsHLQd/vjOSV+fJ9D7/ksnpyYd+m+rf0pcBqKLM1OLUDCv9rB+Ok6IGpXbRrRGi5KrVXkB7LJ6+thSCNkNtwF6R/9TVw2XhCKP8Rwlt3BC7Z1PAdSFwlWeCILbWUag7Oq8R51Oglu6vAk1a5O5xRtHz2/5XyH2uPPJTEt4H1LhEtlIEEW4uKjSVaPchSTVlYvM1bUuHj5X1F8CqPSs27hjILhVExhfrvN3BnNHNBYLYgOhFHHI38u0ppTsKasl6p7sEPFyC9zSVU/S7CVALxyzFEYyOLbu0M92I2Dp9C817uC9cLQV4/M9JO0GOBKagPkGJC5CLePYs54HoIdo7NKcayLDB6TsBUB8QjoqsNMO5efN1iR+0RvuXVz/zF4VhCe8P2Aqi4qFafF64IyGO50gwZjWk/ytuzY2uVjUm5RWJamXfK0Aos+LyBpLitMt/O8CLAewD0YZyVyBkurkEdB0kc6E+LynXipYfxbPOBRsEADN4foCpFbaLR1e9ZtHhWcxdB3Jv/rvo04XXZJtUtweIQY1k2X3NbNlJKSPdeGkOau/R40M+41OfxI5M9M8lM4qenDPtB/6gI+tQYbJZew+apU5bubOewKrRgCeB+WhLzdpPFhfNE+lR28QEMz/g3kUupfRprQUUhTWKleDLqpNADJGj651O1uIbwUMuEiP9RFSLxywUew/iVrz79VMuS5llpJX+OznhsuH5mRkYpRwx0r+1bt4pWpyeNGufwhN+SaAz1+77xACwbM5+wdpl5br0cMFecvEv3BDVXHUyZQtcVhH9vID6GVSyFcqkNkXyKtlP3CLiewxDPEV1+rpGJq5RUviE1bxg8hHVJn7Y0lDDi7x8cKuRx3Ul4STSkbjqaXmWg8Pp5ItJ9qwada0wMMrjHlVTR11jqKoeLzTF3ZP5RdVxMA4LC1L73fdg6HZUAFDHjz6UTXeGOM
 JzHT7kh4
 hLtuFBnDXR1q0RwGYJprZxkgxW3DWx2JE+cd65qStduJqCQL+Zhx2HxpBTZiM6o1gQ4fnw2UzYCUULZ26OJEFhKrcQgNl/R9eN1iRp8SifKHf2xJMZJqeXcod0CDVP+xQ3Dui81MY8jQAdqhveiHgH2ymDlACwRG3sRNVEcucwWYfkvjBfJTQWF3bSCrkF71Q64MD29wSBGQ58QPzNYleqwEL0uKE1k6+LQPyOvH2KIegHxc0r7tmr5ce+7Cn/ETheX2qzS9EVPmM6wY4ueJ9JQu6cX/ZbwASuCR7kJI4UyERW3+DewqZLotbaJYKCfjYqPerbfSxx/U49k9aXAcqEPQPVWkuyz8CEW92aIBVQRrXvbwABu28T3uQXCii19ep0G3q2iqLw4gkS+WB8IpTNMHRkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 11:03, Breno Leitao wrote:
> A corrupt page table hands the same bogus entry to get_swap_device() on
> every access to the mapping, and every rejection is logged. One machine
> logged 6185620 copies of the same line in a few hours.
> 
> swap_dup_entry_direct() prints the same message from the fork path, once
> per call: the WARN_ON_ONCE() guarding it warns once, the pr_err() inside
> does not.
> 
> Rate limit all three prints.
> 
> Cc: stable@vger.kernel.org
> Fixes: 23b230ba8ac3 ("mm/swap: print bad swap offset entry in get_swap_device")
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Acked-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

