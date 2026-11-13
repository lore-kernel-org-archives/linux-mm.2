Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAEF0606A896
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CwOdmvHG
Received: by kanga.kvack.org (Postfix)
	id 1A0AC6B05C8; Fri, 13 Nov 2026 14:10:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A566B05C9; Fri, 13 Nov 2026 14:10:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33EE6B05CA; Fri, 13 Nov 2026 14:10:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1A906B05C8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:10:35 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 80DC11A01F0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:10:34 +0000 (UTC)
X-FDA: 85431037188.12.62C03A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A6E5D140012
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:10:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CwOdmvHG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794597032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TmQhBXxYv2wy3oWjyq1yC5XpUFA1i4l5VWHKkx2FbwI=;
	b=Pz6rIbuR3iRPs20H0QonQ8UuuqfdiPKeTLOYmNotzHVuotfb3Gyn84zx8j193nA0OfLaFG
	ro/ML4A9z70H05MvcEAqk/22ffnAGyl52Nk/uH6WT1LvYJkHMl5kLNG8lbBT6mFcYkk+Yg
	6w84mv8nHe/m2FgmHNFTa4BAB6n+cjc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CwOdmvHG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794597032;
	b=P6Rx+wXr/7ckh7UuxjPGU/QtFInR+YWnUhvyB0J+9x4i8TBJrwTJmwPo0dNKp5oZbKvP2+
	5X2l+6O4gpofIwVIpnDGk+ZYoxszqg/XBiTrF5yH4DXhpNemdg90oUJBZMfOdaBmp4vMUQ
	lw2/1uA1cppuFqdTdthRm2t0noZZajs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0428046C9C;
	Fri, 13 Nov 2026 19:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBA31F000C5;
	Fri, 13 Nov 2026 19:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794597031;
	bh=TmQhBXxYv2wy3oWjyq1yC5XpUFA1i4l5VWHKkx2FbwI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CwOdmvHGwN0V7RevMwq+XSLErkMTQPIU0g9XgUG7+UhuxToue+GpBWcI88Yd+ek0L
	 w7iawLFldGwkYJndnP76FS/Dpty3LMdeL+NqvKkBN4RJ3QdLt3LDhd+pfcXD3SEbC4
	 qzGGGJhD8QKlDJ/x4yGRZ1GHuKwM6S0LB0xIp8x7nSluJ/VguXuf//n36LJTKG6qZl
	 Ur/t7Q0zo3zpYz2D3anxD6WcKlohv9Jc5bjpFVy6l8RSrTItGwxoH1u3D1onKQOkl0
	 LWfBKjrXFb8ce3frkZWzEgPc59boiD0dqbeT9b5HqX1EerJKxSsaCePcdKo+ZpFW+u
	 OrxvUyUv6Csbg==
Message-ID: <00521fb1-121d-4aef-9278-fb6b36755291@kernel.org>
Date: Fri, 13 Nov 2026 20:10:26 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/ksm: add initialization helpers for
 scan_get_next_rmap_item()
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: chengming.zhou@linux.dev, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org
References: <20261112125754.176930-1-xu.xin@linux.dev>
 <20261112125959.177881-1-xu.xin@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261112125959.177881-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A6E5D140012
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: msf1s1intrwhhnkwqsbpuq8wpmpw9uaz
X-HE-Tag: 1794597032-839013
X-HE-Meta: U2FsdGVkX1/VN/uzcI9qGEPetgQ5QicgwHh6G1wxP7zAVkzDtjbmw/Qo23C4/Mq3lrLv5YNRJY1A8TrRwAMFBtU2elSfn1HQM6dZaO62LQJRk9Y2AMFhYjMIbyxkOx2X1be69GQNX+a3Hc7GiroizdYzHcVDdc4j9YxZL1RFA4CkEvcTYppX6HgsqJzXS7yZh2dIx1BVBABMHEITKRkXBoaUWrKIpewMuHMxXrWsHAJhfzkmuLY0bU2Gilmmzxa3+WNJg/wrEYngZqAEDL7e1/euuWBWILexiaH++mUkeZZHrethbyaFjyGm6VYcjH79SwIuQjF1aEUUL6v629u+Ezvj851B4QKYU1FpcM9H9fe2VRAeHujJIhoanCD9zSFJsG5Jt7waN62C8AooUq5GuAQi/zkO029YWvBn2OchWR9fAWfZXYXgZEOGXdilcwaiz5L1KXwtunfPcsKM5Twl3vFyT1PgNValwJEgAFMlYlbfdvVvQ6AyZRUT/XCaivnEjCGHNOa5kYE3LF8hLhexlWHxiE3idXQPKNzQ5jVL1laDgcP7RVW/0lwzr1xv40NSopOaNJLVXm8Ixj2aXec3zbIBdmBuMeHWe3SWg6+bjZn1Qqiolj8pH/GwiuiTr3m0xKmMoGzP90OW31+9nqFddBS2zq4zwAdBTBVT91LMnpc8LIkP3jX1DpQ9FEC2mhBTrmyJUXMJg9cTHeRGMt7k3v9eEtVoTzRP5A9al1YFfP+rGny5tr7x8JRkHaLk0WeU450xwfnWZivYuiOwlxEljkOIpBqADZUeX64Lk4R9vhq3AVSbSuYlk4G38ShDtD5/Iw651Ve8nEB3lXNwv7aAOIMwpNTZVf7O/tm4FRaX9c4w6Dwe3RkVUlIekZx7MMDtuawmHRXaUh5O1jwPJhOqjNreEIq49zEUB+YUFrbZGvPx2qKFotxljKyU0gVq3DOQwzDlgYfKzWVyqhdudXM
 jbcN6QFN
 sgBRL7VqpLslsrsqQYbmkf36gJqOd6yUIObgsCAwXHpLyokoNSipvAp/McO4dj3vQm0g6zbFDXJ/C3tgeLelWgJNsMEeBm9qf6PK+2gHV0+C7+Yd+nU7KXEl2zFGp1VfaaKog+tcusP/OUIBVbrOdT5cAnRWRnkQthM+bls5JsWRPzFd+Q9OungGNSY9y+kKDoU9BgcnNdAMk8Py5KngaXD6SnGlipoSaCz7E0LTr5P7/flWWYiJ5OT1sgyLB8rjXvQyxqCBJBKY6WYaCf4jYoFVZhfAOswoylTnAGX0i7Cqu6rh1BlyklaXOMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 13:59, Xu Xin (vivo) wrote:
> Extract the new scan cycle detection (including draining per-CPU LRU
> caches) and advancing the scan cursor to the first mm_slot into
> scan_begin_new_cycle() and scan_get_first_mm().
> 
> This keeps the exact execution order intact while making
> scan_get_next_rmap_item() cleaner and easier to follow.
> 
> No functional change intended.
> 
> Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
> ---
>  mm/ksm.c | 70 +++++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 46 insertions(+), 24 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 49977bcf04f7..e79e64372e49 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2640,6 +2640,49 @@ static void ksm_reset_unstable_trees(void)
>  		root_unstable_tree[nid] = RB_ROOT;
>  }
>  
> +static bool scan_begin_new_cycle(void)
> +{
> +	/* Check if the cursor points to the head. */
> +	if (ksm_scan.mm_slot != &ksm_mm_head)
> +		return false;
> +
> +	/*
> +	 * A number of pages can hang around indefinitely in per-cpu
> +	 * LRU cache, raised page count preventing write_protect_page
> +	 * from merging them.  Though it doesn't really matter much,
> +	 * it is puzzling to see some stuck in pages_volatile until
> +	 * other activity jostles them out, and they also prevented
> +	 * LTP's KSM test from succeeding deterministically; so drain
> +	 * them here (here rather than on entry to ksm_do_scan(),
> +	 * so we don't IPI too often when pages_to_scan is set low).
> +	 */
> +	lru_add_drain_all();
> +	return true;
> +}
> +
> +static struct ksm_mm_slot *scan_get_first_mm(void)
> +{
> +	struct ksm_mm_slot *mm_slot = ksm_scan.mm_slot;
> +	struct mm_slot *slot;
> +
> +	spin_lock(&ksm_mmlist_lock);
> +
> +	slot = list_entry(mm_slot->slot.mm_node.next, struct mm_slot, mm_node);
> +	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> +	ksm_scan.mm_slot = mm_slot;
> +
> +	spin_unlock(&ksm_mmlist_lock);
> +
> +	/*
> +	 * Although we tested list_empty() above, a racing __ksm_exit
> +	 * of the last mm on the list may have removed it since then.
> +	 */
> +	if (mm_slot == &ksm_mm_head)
> +		return NULL;
> +
> +	return mm_slot;
> +}

I like this function cleanup here, but not sure about the other one.

Can we just leave the lru_add_drain_all() where it is, or what's the reason for
that change?

Note that that might soon get removed either way, so I wouldn't worry about it.

Then, I would rename the function into something like

"scan_should_start_new_cycle"

And keep it simple.

-- 
Cheers,

David

