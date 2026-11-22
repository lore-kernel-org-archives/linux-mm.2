Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81DAE606A685
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 09:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k6BShycF
Received: by kanga.kvack.org (Postfix)
	id 60EC76B00EF; Sun, 22 Nov 2026 04:19:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7276B05B0; Sun, 22 Nov 2026 04:19:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7CA6B05B2; Sun, 22 Nov 2026 04:19:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 15DD26B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 04:19:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5CF7120682
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 09:19:39 +0000 (UTC)
X-FDA: 85462207278.28.7D45211
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1B1E440004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 09:19:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k6BShycF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795339178;
	b=PZ3m9v8/Qkb958RMCqnb0yg/lY6IzGIIqgwaRsWYr4IaWBZ6+rwR+ED3o4YvxHbPaCvTkF
	eFveknK+Jks3uxWXg3ghcDyZpwBBfdVxV20bINuZ5sQtODvOGkYISQy1uXvSOUbn4WHQr8
	K6XwejBSpVH4o3IjyJiBWW9kWFidFm8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795339178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BzQISL5lSMrXxR4Vn+nWmVJdpxxTtSXQ7y9eFl2L6oI=;
	b=45qnrcSpcoh3jvoUd2SPLwkO9BulvaE++lzs4t5vkMUhoHu2Tm6rcfGMf98t3MbXvbD63q
	vqn4WK2tNIZRAvmQUvbKyXH5oF8Kdt0UVKyePl6vGqVWDCr1HHJIrNuPPUKnKDngt0n41r
	XV3rp0geiWqWnrwSUcqKyo5TTpaoPKI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k6BShycF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6006960D12;
	Sun, 22 Nov 2026 09:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1288E1F000C0;
	Sun, 22 Nov 2026 09:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795339177;
	bh=BzQISL5lSMrXxR4Vn+nWmVJdpxxTtSXQ7y9eFl2L6oI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=k6BShycFQ7Et7Ajt8PiMo9vbr3rvYz5QOtnCooR1aE7EFb+3YI59uEcKudTxmqHB+
	 zKgQnGRmjvJPRRBW+PmV06QmfMBYoHQ9jBJFozoguS9jQ5BjcHAzcM2xEo4wH04CM4
	 b7PtNbMoDT4gVDjw59JgaIkqlixRUbENRxp369RfnlWCDLXLZZExFQMEse5PvtuuZY
	 P5mkZ14b1rGZ+Z2NAW4XtKjlDV0zdEczliwYdn6dhaxBVwRpWXGneFrHEd0SYa76wC
	 5TTnfdivPyHRviIudf7dkHwpvO6zZNdAYeiV9T3/cHbS1TBk3U3XWHqrZTLZWY6xp1
	 zXi0wo3Rjd/Sw==
Subject: Re: [PATCH net 1/4] net: skbuff: limit folio refcount when copying
 skb frag references
From: netdev-bot+sashiko@kernel.org
To: david@kernel.org
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, akpm@linux-foundation.org,
 kas@kernel.org, songliubraving@fb.com, hannes@cmpxchg.org, riel@surriel.com,
 willy@infradead.org, ncardwell@google.com, kuniyu@google.com,
 pfalcato@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
Date: Sun, 22 Nov 2026 09:19:35 +0000
Message-ID: <179533917558.3135.17684828734142496084@kernel.org>
In-Reply-To: <20261118-skb_refcount_overflow-v1-1-5551b4954c3f@kernel.org>
References: <20261118-skb_refcount_overflow-v1-1-5551b4954c3f@kernel.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1B1E440004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: mgsxyq75u1mdjd7cyqmpp8fdauykmkfe
X-Rspam-User:
X-HE-Tag: 1795339177-314542
X-HE-Meta: U2FsdGVkX18SYNuQiY97/2nkhU5aV5P6QQ3FhHuOv9nIckaMOcPVxltOoW9Mt2NAsgVVatqstWxuKunrE7YiXMvOxJE7c54eVwGhDPmlJ2IwwkxFIBexxnnSotWk8lxFjESUePDI5hlqjNd6pYFt9c29bfKppzpRE9l2cq4lXcWhzFrFuyuuQWOCrnXlmvrVWuqp8XNhgP6lao+Tn/nz8OGiLhpg/8cANv1QXVCEG6XlJifABPTyERRPGez7fiQu/TYe4QB5bWqR6yjfG9Bh49Xx/DN/liYZ5iZKdgRrRok/b7ka0f7cJSvFS/tQnvPiIOv5bNVszE5oc3J1G5bJq5QfFGt43veJMzeGE7871gYrB82Jdd7ZYB8U1bsue22OHvxP0m4hkRdqFpq+xeprwH0TKQn+4KHqMIZs14qynOBQI/PA7HT6uj8Tq8ikhuL4ykBfNphqjCKe1O5AlfvvWVCImQsQrceThNZIm5dtH8fmW3LwDWWKuhGQFFsMRnakJjl0N8C81nCUwVrSCHgHMAVS8O7FCrqzAImPNY7CgO1c0fSpT6mAxrgs9AmGLa+JPkKNvlFZAFm9irk/Bqohv38anLpDE0TSQsRx/7OnHXyI2Wxeav9dBm3wjj4UKeemZ+Ijmxlmp3txjOqh/TeZ/A38QjGzygqYnVwszPHTMKTl6jAyRrnPWRvz8wvSMV+ujs9Wy09DWoihuUVgF7IHKH9JlMGjRqW3UqbsXMS1OYv5t4bcHqXiiUigPr/k1Uxf427aTOqV7hgofRxrKN5a/SLnn4PgrWcOopYs4I6jJc1r+SAjrhV1fu5lCYKUZ8rKkoFxZi4UFpeVMyP1AiFhigfJWajtkOfdCWhICJNRRTUDaBr72H+for6IvcHvIwZhs6S1fCRrMe4xECnNYWB7Pkv3W2qPnDAz/S567V/gn2THlDIPvmbtk0VMwVxHgLIZa6pJk4znEJQ80WMI5N5
 JGxx2/u+
 72bghQv7Wds66ALNmJDodEV0gfX6KEAOMO1u4/8ImXCi11s8rCnl+Oihf3zHLgm60AFPYDS8qOkCBNv9feJuNMbjzCqud5TdNiWTuNYpEsCgK3j/0Wke/XIAj7KP+7hIv9+egGyRhpf88Ll6wzSYxJdBCVHi8IEYXAQfU8m600a3HQwZXudAs4HOXd56vZ7E0Pfz93iNUmet7dhj5UdzjYdnIxVIcWqlvtgHubkpSigSGLJISaUeH2xcxiBuHVpliZng1KMEKhh1uaNSS6mP9zFEM5OckNTwY4UwONQYDydrvJR2WUKmVg8X1hErKnQBf2NxcBGOXipg1xLirPz3ZirTfceR45tSzNAe6Ev4ddIVFqe2h4lPS3UPgrYekAL9qM2DmB3IFKs9tU1H8tvz7vejQRSvwjwaLpGXd261QBdQnbvvuXi74bQzHrd5o5auEflOH/RshrmWbZegf3XPnkJN0yRqvbAu2L8Vn3Ettut/2XE3OTFTfvPdZa4ipWDJ8foe78FyijR2Zn0jbMpI4ue75XvjdSWalwn0a6GiXdOubP+7uB6lyAafGD5SWAH9jimmey0LhEYvEzKiAmUs50ji8bHwDYNRsuv0EhDFJDXq/peVoYHMjQbq7izkManbz25ImUuPdKrLpmDVp7oemVV8nYro9T51TphXI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] skb_frag_try_ref() (include/linux/skbuff_ref.h) sends every frag
  page that is neither page_pool nor net_iov through try_get_page() ->…
- [Low] The patch is tagged Cc: stable with Fixes tags going back to v4.8
  (800d8c63b2e9).

--

net: skbuff: limit folio refcount when copying skb frag references

This patch adds skb_frag_try_ref() and skb_frags_try_ref(). They take
non-page_pool frag page references through try_get_page(), so the folio
refcount limit is enforced. pskb_expand_head(), __pskb_copy_fclone(),
skb_zerocopy() and pskb_carve_inside_*() now use them and fail when a
reference is refused.

> diff --git a/include/linux/skbuff_ref.h b/include/linux/skbuff_ref.h
> index b6f6da556ee90..560ddc863bbec 100644
> --- a/include/linux/skbuff_ref.h
> +++ b/include/linux/skbuff_ref.h
> @@ -44,6 +44,33 @@ static __always_inline void skb_frag_ref(struct sk_buff *skb, int f)
>  		       skb->pp_recycle);
>  }
>  
> +/**
> + * skb_frag_try_ref - try to acquire a reference on a paged fragment of an skb
> + * @skb: the buffer
> + * @f: the fragment offset
> + *
> + * Like skb_frag_ref(), but acquires non-page_pool page references using
> + * try_get_page(), refusing additional references to a page whose refcount is
> + * at its limit.

[Severity: Low]
This isn't a bug in mainline, but the refusal described here only works
because try_get_page() enforces the refcount limit. That check was added
by commit c6c9a4c1c9a1 ("mm: limit pagecache folio refcount when splicing
into pipes"), which builds on 26b8f029ce52 ("mm: limit pagecache folio
refcount when mapping pages").

Before those commits, try_get_page() had no upper bound:

	page = compound_head(page);
	if (WARN_ON_ONCE(page_ref_count(page) <= 0))
		return false;
	page_ref_inc(page);
	return true;

This patch has Cc: stable and Fixes tags back to 800d8c63b2e9. A backport
to a tree without the prerequisites would still compile. There,
skb_frag_try_ref() would never refuse a reference and would only warn
after the refcount has wrapped.

Could the commit message state this dependency, for example with a
"# depends on" note on the stable tag?

> + *
> + * Return: True if a reference was acquired, otherwise false.
> + */
> +static __always_inline __must_check bool skb_frag_try_ref(struct sk_buff *skb,
> +							  int f)
> +{
> +	netmem_ref netmem = skb_frag_netmem(&skb_shinfo(skb)->frags[f]);
> +
> +#ifdef CONFIG_PAGE_POOL
> +	if (skb->pp_recycle && napi_pp_get_page(netmem))
> +		return true;
> +#endif
> +	if (netmem_is_net_iov(netmem)) {
> +		net_iov_inc_ref(netmem_to_net_iov(netmem));
> +		return true;
> +	}
> +	return try_get_page(netmem_to_page(netmem));

[Severity: High]
Can this make the converted paths fail on every packet for drivers that
deliberately keep RX page refcounts near INT_MAX?

Every frag that is neither page_pool nor net_iov now goes through
try_get_page()->folio_get_checked()->__folio_ref_count_over_limit(). That
check applies to any folio, not just pagecache folios.

The gve driver uses GQI RDA/QPL and DQO-QPL, and none of these use
page_pool. It biases its RX pages up to INT_MAX:

drivers/net/ethernet/google/gve/gve_rx.c:gve_setup_rx_buffer() {
    ...
	/* The page already has 1 ref */
	page_ref_add(page, INT_MAX - 1);
	page_info->pagecnt_bias = INT_MAX;
}

The qpl_copy_pool setup in gve_rx.c and gve_alloc_qpl_page_dqo() do the
same thing.

Handing a frag to the stack only decrements the private bias. When the
bias runs out, the page count is raised back to INT_MAX:

drivers/net/ethernet/google/gve/gve_utils.c:gve_dec_pagecnt_bias() {
	page_info->pagecnt_bias--;
	if (page_info->pagecnt_bias == 0) {
		int pagecount = page_count(page_info->page);
		...
		page_ref_add(page_info->page, INT_MAX - pagecount);
	}
}

So for roughly the first 33M frees of each ring page, page_count() stays
at or above FOLIO_REF_COUNT_ADMIN_LIMIT. For roughly the first 67M it
stays at or above FOLIO_REF_COUNT_LIMIT.

In that range folio_ref_count_over_limit_slowpath() refuses the reference:

	if (ref_count >= FOLIO_REF_COUNT_ADMIN_LIMIT)
		goto over_limit;
	...
	if (!in_task())
		goto over_limit;

It refuses unconditionally above the admin limit, and always in softirq.
Each refusal also prints the ratelimited "reached refcount limit" warning.

If that's right, these paths would fail every time for gve RX skbs that
carry page frags, i.e. packets larger than rx_copybreak:

  nfqnl_build_packet_message()->skb_zerocopy()
    (NFQUEUE copy-packet mode, the packet is dropped)
  queue_userspace_packet()->skb_zerocopy()
    (OVS upcall fails)
  ___pskb_trim()->pskb_expand_head() on a cloned skb
    (AF_PACKET with snaplen < len)
  skb_unclone()/skb_cow()->pskb_expand_head() after a tap cloned the skb
  __pskb_copy_fclone()
    (pskb_copy users such as nft dup)
  pskb_carve_inside_header()/pskb_carve_inside_nonlinear()

Before this patch these paths only failed when a GFP_ATOMIC allocation
failed, because get_page() kept incrementing without a check.

Later patches in the series apply the same check to skb_segment(),
skb_try_coalesce(), skb_shift(), tcp_clone_payload() and spd_fill_page().
That would also affect software GSO of forwarded GRO packets. splice()
from TCP and AF_UNIX sockets would return -EFAULT on gve-received data.

The kernel-doc for __folio_ref_count_over_limit() in include/linux/mm.h
says "Checking other folios does no harm.". That doesn't seem to hold for
drivers that bias refcounts this way.

There is also a more speculative issue. folio_get_checked() has an
unconditional WARN_ON_ONCE(ref_count <= 0). If any remaining unchecked
get_page() wraps such a page to INT_MIN, a later skb_frag_try_ref() on it
would fire a real WARN. One example is iptfs_skb_add_frags() in
xfrm_iptfs on RX outer-packet frags. Under panic_on_warn, a remote sender
could trigger that WARN.

Since this is Cc: stable, would it be better to restrict the check to
pagecache folios in these net paths? Alternatively, gve could stop biasing
to INT_MAX, with that change backported as a prerequisite.

> +}
> +

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261118-skb_refcount_overflow-v1-0-5551b4954c3f%40kernel.org

