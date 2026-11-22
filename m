Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 969FC606A33E
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GQY07Bxk
Received: by kanga.kvack.org (Postfix)
	id 9FFD46B05B1; Sun, 22 Nov 2026 07:48:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6876B05C5; Sun, 22 Nov 2026 07:48:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EDE06B05C6; Sun, 22 Nov 2026 07:48:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7E56B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:48:26 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D87ADA7FED
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:48:25 +0000 (UTC)
X-FDA: 85462733370.23.C4B2FEB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 23EF040004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:48:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQY07Bxk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351704;
	b=rVAkU8clcT4B2px4zD92cUFZZr+XTXaPEep/ZsE0RZAfK5UsUbkRmEB2xJBN6hFVx/Pcyv
	70IiXyzXu6BJUJDde1QMxw2IgM7VAjnibR+N0RS76QpuKORUmqhFqJ0hfEkvULBJRWGSq5
	jmEAVLyr1+JXT/7VZIuY8AZHTdDbWos=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYWaYBNtufSJa/UG1/SFqHGRJnP7udoeOeCcl4gVeUc=;
	b=nRIpqCzqlc+bRq26yo+I6UuygflGkiYJofHWKm0846y60VG+i0AnNf7Dj8NefID4ANKOve
	u8zrGUSxnyzQJ1RXb9b3B+QcpHEqDrVjxGGi0Qh19cvAuQa1EBDK49EpcWOjA9dNQDYxY4
	svfdlXdokpFE7lmMV5vRlrBa0f3P2zw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQY07Bxk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96A6261892;
	Sun, 22 Nov 2026 12:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8601A1F000C0;
	Sun, 22 Nov 2026 12:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795351702;
	bh=WYWaYBNtufSJa/UG1/SFqHGRJnP7udoeOeCcl4gVeUc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GQY07Bxk97fqzjBwqZoIfonKj9WndWOr5euSKR55AAtV+p8SeMXk014AYRuBJz0ta
	 x60pIAz3ouR2QZVBdY1VjnItjkHn2UVlzI3dwQCe1GsDRL6nEKNW0Bhq0LR50i03Rt
	 SUSU/8Srh84td+seq39GDtLX+WosIH+pAEHo1MCtwuqd4pYzDBG/KiCa0rEoDCNsq8
	 Wacjew11ESU55kDUSNmkp86O7QJLmmbP3Byv4kYFsTnt407DZGHqAcBqzUJepOABJ8
	 blrEEUH+UPBufXFFiKZMWx0xoIPkVPYXGINISX19NIpYL2lUla6D+Q4p1C786WhWEd
	 /Ti5Vfkj3mv0w==
Message-ID: <7641a736-bf40-42c1-b169-9d21a8606638@kernel.org>
Date: Sun, 22 Nov 2026 13:48:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 2/4] net: skbuff: limit folio refcount when
 rearranging skb frags
To: netdev-bot+sashiko@kernel.org
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, akpm@linux-foundation.org,
 kas@kernel.org, songliubraving@fb.com, hannes@cmpxchg.org, riel@surriel.com,
 willy@infradead.org, ncardwell@google.com, kuniyu@google.com,
 pfalcato@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20261118-skb_refcount_overflow-v1-2-5551b4954c3f@kernel.org>
 <179533917726.3135.13005025144396516237@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179533917726.3135.13005025144396516237@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 23EF040004
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: tjp33fntq8naqpads34j59jtjtizfkjk
X-HE-Tag: 1795351703-597558
X-HE-Meta: U2FsdGVkX19xlBddOnsuMOlrFUWmxDBykk7XTXj+clEgsvuZCwessdlVbUBT4cP8pzZZ9gmKwMwXbT56tQkD7EWQPA7ZpTDTCp0iRI/g1l9W92ODuE/IOQ12D4I+3AZoKL/QTZ/mkBnC23Nla0+WHFK8sKMGTrnaviZ1LzKkIBKWyZVxfnXjkaq5PMdCSq13ZBMKGf6/mOMxFZva+J2tafvK50mZsDg/EGs/9WhOaaleeqvi0MvORl5mA1r3SUsMABnL4cMFIVJvesVONXXJcqhkpQf6M2zknPmIDkV9HtaUHtfM1sfrVTDuwsmijfVQPv1KYBwbFRYRmvAZgqrNW9ncC+TeiVNDm87U7HXNoq3gqLla9QJzhw5twyPVmvz7UCySAjoJOjT8Fpm6CmBuDRWpRCtRPrsrA9ruR9G+NEcGaRXv0kKEg3W/NKsoSzFPFGq4HYRMrBRicoNo7BGoe6dAR/3vmwpckZ34rAYeeCjn7GuFfvLMZ5/IPmihTYBgz38A8SPzo/Rp2m+PvSvrJuHX6qz2Dc6QriYzj+yg9Yn2/L2/qD8JaGxtD78C8LYc4SrZ8FOFmvH5G/2887MFWkBeXGC2RxmWvQGeBWSjMkHQ1bZYnJzRoottbRkACaz4GJcj/75t3XCiF3wwtFaevokDV1aoGbLyBI49SFT9pI8qeZac8S6QE0C0KH5IeLLBzmaLWqzoAyke0y1yRvB4RaRWdGBgH+L5/CkIBtugO0tf2dK+Dtimd2/mOe4zQK8tQZo1memqsbq8Wp5R4PX0q/7cqFtkF+9lUZ4zUTnzGxq6nSSlC2Vh1+T7bjb44fm6KYGU1m22pqomO1+oc3MOP7WWbydOgVUiI+jqeLjSHB3ihqEuIgjI5EaN1zCojF4kFmdZIhkmVLWL0aURhT+o/9CswXOpW0yS8i+B4YGnvzKBX3zs8AXeyrCRZxFjSJLJiPqD1wcFE81CF9n3WxA
 ee2nKpWt
 rxTOvd4DZBL6yGHnOMhlJtmwzHaqGg8Nzy8HnT64zukBBD29wcij2XDFWwayj49r36laP3Y4qADY7TM+oXcwNVC54XoU/hC+3dw9x2oQKl/KT7QjzC6FDf8adTK6c3yCDf0PD4H2TakaaXdxCpe4+QuT2Dzow1NfV6P4fFpBm0I2ZxA6XIeIGmFE3/D1Z7PGq8jwET2in3JAvxJfwwWUxOFug2rINJz6Z4tq6QU5PhZTPQc7ZBRTiR5XOzW57KZLskeRw0n1UBLMw/YQKg4RHiPLEI78ya+ufwk75kERsO2NZQTZouK1xvVwOcWXEV8n5oqAFR+lpRw0dhTZKWUwQNjVircUE0D8RII6c6faawnOOuUxe3b7BNsTZnxeMfy5EzLEB8UdgGSDLkJpajkz9l+ZumbSJm5fRFnUuHY85RxZ805xG3ptNH6CsiqcGQXfILaOqq8QwQ0YjAOyXoC5CckZr9ZiPr+pEirIdIspKgaPMjxiGShy4cse5H0Z0SXKqETupjg2gunScQRHeeujkS1H/3ks4o8qi+1xGhZoDluWbW/9+2bi/1mgTMn5/EEyPTXhGigrhJeqM3xCNTmsPw6mZlJdic9Q0yfbB4gzLrzCGDoE81FxSweQXlj6rCSEpxqqAyYmgFQNHrSQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/22/26 10:19, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in case
> you want to address the nit picks below when you respin.
> 
> Low priority / nit picks for your consideration:
> 
> - [Low] The commit message explains why skb_split() keeps its
>   unconditional skb_frag_ref() by saying that "each split also allocates…
> 
> --
> 
> net: skbuff: limit folio refcount when rearranging skb frags
> 
> This patch replaces unconditional skb_frag_ref() calls with
> skb_frag_try_ref() and skb_frags_try_ref() in skb_segment(),
> skb_try_coalesce(), skb_shift() and tcp_clone_payload(). The goal is to
> stop skbs from multiplying folio references until the folio refcount limit
> is exceeded. skb_split() is deliberately left alone.
> 
>> skb_split() can still add one reference when splitting a frag. But each
>> split also allocates a new skb that is charged to the socket, reaching
>> the refcount limit that way would require a lot of socket memory, and the
>> references go away once the data was acked, so it's not that relevant in
>> practice. Making skb_split() fail is more involved, so let's leave it alone
>> for now.
> 
> [Severity: Low]
> Is this reasoning true for all skb_split() callers?
> 
> Socket charging and dropping the references on ACK both describe the TCP
> callers, tcp_fragment() and tso_fragment() in net/ipv4/tcp_output.c.
> 
> skb_split() also has a non-TCP caller in batadv_frag_create() in
> net/batman-adv/fragmentation.c:
> 
> net/batman-adv/fragmentation.c:batadv_frag_create() {
>     ...
> 	skb_fragment = dev_alloc_skb(ll_reserved + mtu + tailroom);
>     ...
> 	skb_split(skb, skb_fragment, skb->len - fragment_size);
>     ...
> }
> 
> The fragment skb there comes from dev_alloc_skb(), so it is not charged to
> any socket. The data is not acked either.
> 
> The path is batadv_frag_send_packet()->batadv_frag_create()->skb_split()->
> skb_split_no_header(). skb_split_no_header() still calls
> skb_frag_ref(skb1, k) unconditionally whenever the split point falls inside
> a frag.
> 
> The KUnit tests in net/core/net_test.c also call skb_split() on skbs that
> have no socket.
> 
> The conclusion probably still holds for batman-adv. A packet is limited to
> BATADV_FRAG_MAX_FRAGMENTS fragments, and the fragments are transmitted and
> freed. Only the stated reason is TCP-specific.
> 
> Could the commit message say that the socket memory argument covers only
> the TCP callers, and mention why the batman-adv path is also bounded?

I have no idea what AI is talking about and also I don't care. I have more
important things (on a Sunday!) than to do that think about such silly nitpicks.

What a waste of time.

-- 
Cheers,

David

