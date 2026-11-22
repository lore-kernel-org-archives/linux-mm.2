Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE304606A686
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 09:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EMz0e8MK
Received: by kanga.kvack.org (Postfix)
	id 76FF56B05B0; Sun, 22 Nov 2026 04:19:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3116B05B3; Sun, 22 Nov 2026 04:19:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54BAC6B05B1; Sun, 22 Nov 2026 04:19:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2AAF06B05B0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 04:19:42 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D63B1C3B5D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 09:19:41 +0000 (UTC)
X-FDA: 85462207362.15.15224B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id DF41120003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 09:19:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EMz0e8MK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795339180;
	b=S4ovjDJnD1avoZQdytgETssINtZZJRQiNwim2FMDnVfgVSA4R2iL9xiIy2Fi3xNX2YyA+t
	o/kC3ttKkgCZBjZaEO3Lk2882cyCvNqjg2EN79B8nfNPPFeNe+TPNjPHOVwy0SM3x6o7L1
	8Z/WP0cRpW7O7DhWj3hEceDGUr/S3tg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795339180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLi6FJ3YBdze32J1P5e4SyztLeVBldzrE4m0g/yjef8=;
	b=ZU4oTT5EoYaSe95BumB+ZTWWK7GjOU2nH1nxfY7bYopLooLagkvGiUISZnsB0PsJ5peHrD
	hgc+5mamWRGRSEZM6CjUu5uiFT6V3O/4gT+RnpY4DuY3lDf6qIbawA7UhRQDEGuOJGrLEK
	7WWKj2iStGTU9HnRQ0q60HGXec5ABRk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EMz0e8MK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B99784093B;
	Sun, 22 Nov 2026 09:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A662A1F000C0;
	Sun, 22 Nov 2026 09:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795339178;
	bh=BLi6FJ3YBdze32J1P5e4SyztLeVBldzrE4m0g/yjef8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=EMz0e8MKeNv4rhcUPdw8SVX2ubd16Ms9Or8bDnmla+NICnuP9k8nsgLIN9WHn13RR
	 UdUwl4QgvKX8JrP+YE1sXfgoox3UAEwF7ihCJEhWGuz3MjFhEZZzHihiEX9sNTeINi
	 4fthJLsn/DTFai9w+s/NaR4Zs654C4eLHS7vW/8kTaUL/Nem9t7/FwhPbcYGCCrCYy
	 OZbBt1h5c4CfW76b+YAV+YTzxL2i+vJE+vrlhn0Lgci33sApB0Fa1UspuGJRPhtTod
	 zlQiDq62XWHwaS4YZ8VJqaJ2kUsdu2qwpbJ9M679nAsTk1+S280TEHX5QqUNtS3rZ0
	 x9BS7BLfwH9WQ==
Subject: Re: [PATCH net 2/4] net: skbuff: limit folio refcount when
 rearranging skb frags
From: netdev-bot+sashiko@kernel.org
To: david@kernel.org
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, akpm@linux-foundation.org,
 kas@kernel.org, songliubraving@fb.com, hannes@cmpxchg.org, riel@surriel.com,
 willy@infradead.org, ncardwell@google.com, kuniyu@google.com,
 pfalcato@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
Date: Sun, 22 Nov 2026 09:19:37 +0000
Message-ID: <179533917726.3135.13005025144396516237@kernel.org>
In-Reply-To: <20261118-skb_refcount_overflow-v1-2-5551b4954c3f@kernel.org>
References: <20261118-skb_refcount_overflow-v1-2-5551b4954c3f@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DF41120003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: boajzysicuxysbgmtp67eqr9mk8os8en
X-HE-Tag: 1795339179-779769
X-HE-Meta: U2FsdGVkX1+iXKcxsno8nVGoEC0qnuL/x44/G7SHvTd07ubHwOWo3OqXjSqV4pmQ7VGBKvW3hPQ3+lbtidj5TKPWh3FE403EmS5/VaJzRzlWCt/T/itZllhTTktBP+oCeMHquNi6ZO5lO4U0m2laNL26JKmsBuikGgzd/ALrcQoWOwWd1xt8aixuD07j/Ja7O+ZBfJOwhKqBo/7ByA9QVtuVl1T+VwShGb5cR4agrjWvChOpvAwYnI2+4w6xcoKxD1kmZ3/9WDzyKvNdg7hCciZMBislo/lOLRYISUzHz5AxgQGV/XTdPQjZs+SoFq00/oo0sZsKXH53MmEPCTCWWWe5VNmh4Hrj1watqnMEb3/g/XYxnciGR+XB0iVIdxdZ2RiEIigyqHIg4sfBRaToFnZeTflIFZVmm0JDS7vvtGtl1FNF70NRriIEQX2acruL9CmfV9avXJCo3ND4t8Ee0Pkrb3hfxymu4PgrP4jKFB8qlzdxKG+6wOww9SvFnc4cwYauWWQpHcj4DNm/xRiA0NfTmOLATDz7e14jM72Y3rMlI2xjzGpMTpToCllFxcI0X6SiKo/rn4Ouy21cqF30dZn4xWebAXKsFu8z1wsntgyQEP13dkmNp4NxO9x2P5INkzzdf7bkNVOLWkqwzq7XqE40DVWWJRbHY9nTWOf1L8CsqCXZY6nX0kpbW58pXf6D4or34/2g8iUda3nYvY5eJ5Z40NqQIoHlBfL4YNlZJ4bP6DctPzg4XOsOhunml1vUlzgECr3yu2qBcRWG6FeSkebHqbAIruk+2UjkiOsU2wJq7CuceZK4VsMGU12BpA+qS21wBAApFty0egafquocOtPWqGahWJIRnizrOScjlQUAVTXzwCcRN2VdZ+W9zFATjy9kRzRimivd+Z4xt98aIGYw4M78ArWXDd0R1/hOarK4jdTEL8ql51Iune7rMY+0NUUF3fN/IC81zE0Wpt6
 lqLvyCkf
 72o7t1GOulUfthZseHH1ICgnUKK0F8oinSB0WjYYJsu46GorFzU262rKNz9pahgHULgPuUBBIbTfOPBWV7Vm8CXvuBhkQyzpTukkA1j6sner4+xx1aVHOWTsByTNOsVBkgL+LVwt3O68OH2IFg87F8AHJS4CzE5DJ6AYPQnjvUgEo2iuswF9DF1dXUwDNJlF6aCsKH8n+zwKDnMf/rV9FPfA7ADXYUTHFpH7YqHokwczHC3AnyPitTRSYnd+PvXkSFXqX3uOC1I9A/qgw8fETrOo1Zdgarts8qcwPzxdt00b8xwtD32VKrCOiuRUMpQ72yFgc8pqKUF7vdZZ94VAjHGe7hkRpBPAbRsiU9QJj+4ErwizvRzDLAssPe6zTea9sB0eND2omvZFTbC9isiR2esqjyJI/U4q5DPqku2GuNwtvNJ5nYI3PrT/++GaF5Y4ZJ5/4A7OZBUeJJldIy42s5gt9iD6UFQkdjT0S0wbfR7OyduaS+OM7iqUpo4X5IL5LwAaUruBgzZQ6Zs7Ei5B+n4VACYsMm4kqCaB48cM/igP/te5lTnMyi8KQF0+NlLRwx8+Oq0j6wfcJcGu1v5k/jc0Z2t3m23jZigXa04KbczUHcHgEbB68ldQRk4dA1i5QfuBT8ADf9fKM2XATgGcevtlJBLkSXLxskEfQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message explains why skb_split() keeps its
  unconditional skb_frag_ref() by saying that "each split also allocates…

--

net: skbuff: limit folio refcount when rearranging skb frags

This patch replaces unconditional skb_frag_ref() calls with
skb_frag_try_ref() and skb_frags_try_ref() in skb_segment(),
skb_try_coalesce(), skb_shift() and tcp_clone_payload(). The goal is to
stop skbs from multiplying folio references until the folio refcount limit
is exceeded. skb_split() is deliberately left alone.

> skb_split() can still add one reference when splitting a frag. But each
> split also allocates a new skb that is charged to the socket, reaching
> the refcount limit that way would require a lot of socket memory, and the
> references go away once the data was acked, so it's not that relevant in
> practice. Making skb_split() fail is more involved, so let's leave it alone
> for now.

[Severity: Low]
Is this reasoning true for all skb_split() callers?

Socket charging and dropping the references on ACK both describe the TCP
callers, tcp_fragment() and tso_fragment() in net/ipv4/tcp_output.c.

skb_split() also has a non-TCP caller in batadv_frag_create() in
net/batman-adv/fragmentation.c:

net/batman-adv/fragmentation.c:batadv_frag_create() {
    ...
	skb_fragment = dev_alloc_skb(ll_reserved + mtu + tailroom);
    ...
	skb_split(skb, skb_fragment, skb->len - fragment_size);
    ...
}

The fragment skb there comes from dev_alloc_skb(), so it is not charged to
any socket. The data is not acked either.

The path is batadv_frag_send_packet()->batadv_frag_create()->skb_split()->
skb_split_no_header(). skb_split_no_header() still calls
skb_frag_ref(skb1, k) unconditionally whenever the split point falls inside
a frag.

The KUnit tests in net/core/net_test.c also call skb_split() on skbs that
have no socket.

The conclusion probably still holds for batman-adv. A packet is limited to
BATADV_FRAG_MAX_FRAGMENTS fragments, and the fragments are transmitted and
freed. Only the stated reason is TCP-specific.

Could the commit message say that the socket memory argument covers only
the TCP callers, and mention why the batman-adv path is also bounded?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261118-skb_refcount_overflow-v1-0-5551b4954c3f%40kernel.org

