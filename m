Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 368C5606A33C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Na1X6ogB
Received: by kanga.kvack.org (Postfix)
	id ACE5A6B00EF; Sun, 22 Nov 2026 13:43:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58D56B05B0; Sun, 22 Nov 2026 13:43:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9229D6B05B1; Sun, 22 Nov 2026 13:43:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E1E66B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:43:51 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C82B7C0755
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:43:50 +0000 (UTC)
X-FDA: 85463629020.30.853E08F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 12A321C0007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:43:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Na1X6ogB;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373029;
	b=O6p5jFncLXuwb/pubMNpmXU/hwGlYA1Brpqx6QE8gU/6ejeTOZ/eT5DeMrgZNVc3pg+/+2
	E8O2zDL8OktMxAJBsClzMoM89LhSCU7DUqtkhO9SZeAXYz4AFN0oQJIBzPp23M7zIxanyJ
	/sH9wjGzOr1/A57W4dKNEYB0Q4gBNjA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2kzqKz8b9+g9ux0aGmdX0Kbyj1UrfPu+6LYC3kTSK28=;
	b=zHHv3kel4gX6NyxezTWyfnnjwF77Iq1b7E6H3zZcR+S6VimpifywhTxU5eiWUR43LiElNd
	kEo3MZTpkr3yn9MyIQv7vUSJSJdcxmsZWL9aFcpK0I0Kl5cPVgzVVTl2rcJiTKep6ATjOf
	ZzrWQ3kfab/Sb8qyfxkdVyC2qqoAJck=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Na1X6ogB;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29FEA60E15;
	Sun, 22 Nov 2026 18:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651C51F000C0;
	Sun, 22 Nov 2026 18:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795373027;
	bh=2kzqKz8b9+g9ux0aGmdX0Kbyj1UrfPu+6LYC3kTSK28=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=Na1X6ogBMLMhiOSlFp0tPvIfX2hU0kJs6NjRA/Wco5OXhrpdgSnUJEz10Ai0xjpVK
	 ZTL+bTWrlCOW4+HkVD4gFcNmyRWKjnLDaq4jgxQO/rzeFG7nR9ZIggDpAPvIZcHzp+
	 jsMjUSUzJK7U8JK7lE+kXfRvkxSQYxizpXslQS1z5LO7DKZdSqy5rHnjz9EUGazTcn
	 oEhMzX2kE5W6uMP2xdvOZb7mNKVnU2+xoD95sh7Gsdm6zwmLDVWh3PPvTkNPaOd1ng
	 CHnuR80BNYr+EJwvpQ0g5crSW/teGXHXDxi9EWz5HAR2+2dRy14EsBYb12gQGg9Y2/
	 17oqiV0vfoQ8Q==
Message-ID: <874aa044-5d56-4f75-9cd0-c9fd8790dcba@kernel.org>
Date: Sun, 22 Nov 2026 19:43:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 1/4] net: skbuff: limit folio refcount when copying
 skb frag references
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: netdev-bot+sashiko@kernel.org
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, akpm@linux-foundation.org,
 kas@kernel.org, songliubraving@fb.com, hannes@cmpxchg.org, riel@surriel.com,
 willy@infradead.org, ncardwell@google.com, kuniyu@google.com,
 pfalcato@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org,
 Shailend Chand <shailend@google.com>
References: <20261118-skb_refcount_overflow-v1-1-5551b4954c3f@kernel.org>
 <179533917558.3135.17684828734142496084@kernel.org>
 <dff45fdd-aedf-4282-9d91-1a871d3c86f7@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <dff45fdd-aedf-4282-9d91-1a871d3c86f7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 12A321C0007
X-Stat-Signature: b78jssiuqg6881bfxgtc1x6psjtydg11
X-Rspam-User:
X-HE-Tag: 1795373028-691435
X-HE-Meta: U2FsdGVkX1/Ciw+5eoiopztjHnMDIk9pP1/UzdzbZ/HAb+cMJXK7w92utYaFNmiI+ClmrRfBOpAejG942MVCwCfV165zTMTY6vq+G4clg9GdKPARuLbsuG2XZ/fVz6ZzEnVyDsqw5BDQDIIs9ZoAeEHHKCrLXTM9L2wG5XisdiF5lt5yFLa9zWE1+50zEjmLldVNUoQ808k5iWB4lY8frvmX9bYiMko9GD0wSv6V4wbCUjh4rd+7ss0RqQk3wKt3TC9BJ6sFOcYNQch4hLlyImkn5bgWkY7LDOzE9x7HTVoX9fhJN+wi8J7MdzTjx4wCtu720GSVgGqHBpzIMxwIZKjrhyJZ85GdPlbfdkInwJOJ+E81596Tt6BLOsNK6hQdXlN7pQUkA4WB2Z1ga4vVOSzGR2UGQ0dwh93v5wTjcSSLxQQn0umNthC6P+WgOoocZ8W2Q10klwQ6eq4LybdoEcbdrPyYfnBFJdWMU26mf3/4BxOwPr4v4LQomXYa76ftsApp7Hq0nc3zRsBc6Z2SEuGpHhFl90JXRmgoBQC6+zUbrXjAqb7s3emtCM2Ug2kOUjZ7pflFc8CUkoayxjesF98/1Q2UnuC0EKz/I+HHsSN5pvtJaaoONban4bxNleM5AK1alLsLa0CjWMHh+fK9vbecfzhb0QCsmsoQEOE+BGmfXpgRdq5i5o2X7eD7xWmRDzltXiMxrDcQdXoFETdGTTWPf2mkUbsoqcsjJfzeaJ/A3gfwrj6uOJsHNDoZ59wa+GuBpwF1a4gbpmth7YyE4lEU4FE4OcI0PIbLnpe4ygYS0o+pCJkTeO0Cw61Yysuf7Q+esppGVD+lMRy3TD9BRHDkGEoW5sjPeiv6Kip1ztlQFpxqYdK2jA51L3Y/KGek9wMdJk2zvbDF8b4tjRUCd5iorfkkw/DvnW8cUCmUys1yB44wt/Vb8/32Olna7uiGrOSHBmb3xEhV5EevIts
 oKiC27y2
 2PR2PcKLMaXB7eM1cYLoNVgb5vgPMrR/WWw74/T9xUndihof4pfxIXNBUcKGniefZQ5W+IF/Ks3sk9QTQBkHP2zJJU1xY6kZ+QbL3VAaVkg46sAp5PDB204OeMFfwdNukLllzF27ZK5sQTQpT9O0Iv7KIK5iKua1U0QPpGJM2yBskEDSrOWEzlp6F/gvrse07oJ1hA3Tj/G3XQ/ybHQQxnBfLnYxueb3oifV5choDZ3ZaugN63itTpqiylwqMuiMUfdt2hbw5G5Z8F2mfPZt28MSrsntMz//gfVRFfBdHlh6Aap9sZHHWasFydUlUcp4WNpTHEoOvG46v9jAUZwzNazI2Zt7wyCexyVtCOiRaLjnwO4EbRtA4Mng0s7hlXut7wjzUiwYTJu06xDFVjcXdZRt2S6ofelmCsCHu+jTw5ICQyJfsw12vtJiUaEG4XkeBidKqKj+RCWmfb02n/YfO6h6RBG2Xf/uynSRxRdBJqYH2gRUIB8Em2J6yvPI1B3WqefdXIC9s3fYaFk0HTLHO1bOZP8x/Ig/gUD4+5UqOJ20sPD6E4mhfm46OFTOLcPbYzLDD517WuiFHAuma69YqF54cZV0q8ChP9tHf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/22/26 13:58, David Hildenbrand (Arm) wrote:
> 
>>
>> [Severity: Low]
>> This isn't a bug in mainline, but the refusal described here only works
>> because try_get_page() enforces the refcount limit. That check was added
>> by commit c6c9a4c1c9a1 ("mm: limit pagecache folio refcount when splicing
>> into pipes"), which builds on 26b8f029ce52 ("mm: limit pagecache folio
>> refcount when mapping pages").
>>
>> Before those commits, try_get_page() had no upper bound:
>>
>> 	page = compound_head(page);
>> 	if (WARN_ON_ONCE(page_ref_count(page) <= 0))
>> 		return false;
>> 	page_ref_inc(page);
>> 	return true;
>>
>> This patch has Cc: stable and Fixes tags back to 800d8c63b2e9. A backport
>> to a tree without the prerequisites would still compile. There,
>> skb_frag_try_ref() would never refuse a reference and would only warn
>> after the refcount has wrapped.
>>
>> Could the commit message state this dependency, for example with a
>> "# depends on" note on the stable tag?
> 
> No.
> 
> [...]
> 
>> [Severity: High]
>> Can this make the converted paths fail on every packet for drivers that
>> deliberately keep RX page refcounts near INT_MAX?
>>
>> Every frag that is neither page_pool nor net_iov now goes through
>> try_get_page()->folio_get_checked()->__folio_ref_count_over_limit(). That
>> check applies to any folio, not just pagecache folios.
>>
>> The gve driver uses GQI RDA/QPL and DQO-QPL, and none of these use
>> page_pool. It biases its RX pages up to INT_MAX:
>>
>> drivers/net/ethernet/google/gve/gve_rx.c:gve_setup_rx_buffer() {
>>     ...
>> 	/* The page already has 1 ref */
>> 	page_ref_add(page, INT_MAX - 1);
>> 	page_info->pagecnt_bias = INT_MAX;
>> }
> 
> CCing the person that introduced this refcount abuse, making me angry on a Sunday.
> 
> Fix your goddamn drivers, that's just an abuse of the page refcount scheme and I
> won't hack around that.

Breathing normally again :) ... this is really the only driver that pushes the
refcount just under the overflow limit to then interact with other subsystems.
That's just not how the refcount is supposed to work.

Others drivers either use USHRT_MAX (32767), 256 or 1000000.

Preparing the driver to take INT_MAX references is completely unreasonable.

Why was such a large number used? It should probably use something similar to
the others, and not more than INT_MAX / 2 .

-- 
Cheers,

David

