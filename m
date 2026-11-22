Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B86D3606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aZS8N2zh
Received: by kanga.kvack.org (Postfix)
	id D6CE86B05B2; Sun, 22 Nov 2026 07:58:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D440A6B05B3; Sun, 22 Nov 2026 07:58:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C33056B05B4; Sun, 22 Nov 2026 07:58:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 946D26B05B2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:58:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 20BA74068D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:58:20 +0000 (UTC)
X-FDA: 85462758360.23.7184C17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4EFCC1C0004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:58:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aZS8N2zh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795352298;
	b=1c3X6Bcri/aSNrVgmWoRa72uZB/4HeKiSnIyjE35sMqQe38g+9FcWB5GOkAWaSuHnLLUXH
	G2NHpybadaTakGtaYGbWelUVYQS82YFCV5V+YeKNU3UfoS5yiN54hneHpi07Flvhj+/qq9
	2iMDZVR68dqDrHFiNmVHTU0WuyMK9VE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795352298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5JLzXb1Ekv3vj+0rTQE3vVSlpUcvc7p5bp6+Atm1iQ=;
	b=W/G1hWOFYmHGrJYwNDX2TWJFC/AlQigK4jV0v5QUOiW5VaMJtKBlhwL1VR0XUkjXwBFOnL
	3Cgh/Ao1LaJxBgQ+Zv256+ZmMpJQQq5XBUBgl78kN0SgyhQSS2qO34OO6kWT8/ryntsYIF
	k9SfbBOo/55bfakx3VHu/KdlFBrCQ/k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aZS8N2zh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8436A4119E;
	Sun, 22 Nov 2026 12:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0731F000C0;
	Sun, 22 Nov 2026 12:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795352297;
	bh=+5JLzXb1Ekv3vj+0rTQE3vVSlpUcvc7p5bp6+Atm1iQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aZS8N2zhgmVuQem9npVtdp9fQR7jTcyw8rqZHsxYQ5cn0aLihJOjscUM+VLm64new
	 qLO2X21BwPPdwEhh8GLVcnhcddTVnZNIr+xGzQJUmAei2msRb+hbj+KgxVCERRw+LS
	 d9vwJ1EQpq9/8NFNI06uZOZmMh5zzR4wGY+cubNoMnGitNNcHJFy94d+cQbJkxji5l
	 u5OUpBmhQ7261prcxYej5tYuJYRCp22rccuk/adevsk2YPUZ4A/Kuz04FQG2+wfs9w
	 iIG4r3fxS6T0c1nQYaeq7wuQ1Es8alV55xP4FUXGR26chc2eL76JlfJpMEtr4YwfqR
	 Z31OApPG0CMiQ==
Message-ID: <dff45fdd-aedf-4282-9d91-1a871d3c86f7@kernel.org>
Date: Sun, 22 Nov 2026 13:58:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 1/4] net: skbuff: limit folio refcount when copying
 skb frag references
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179533917558.3135.17684828734142496084@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bmiq53znngjwrxgmecxbrcdgo6xagpxm
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4EFCC1C0004
X-HE-Tag: 1795352298-738969
X-HE-Meta: U2FsdGVkX19uBuSxRSrFiIruzTzQtAZ7ZsVZR3pSH/B4sqYh7YkMAb/R+iZsGV1hFsAzASFlEGru/ziHdDlBp+Qo5TnxObANZGJGHRvE+J7G1OL05RWGWlxyhZ3yV/61n43sOw1bqNpeDdoXGdxBcyqgIYFqhGolQKZdqs0gbq2SjaQd0DG8OWnWy7OSpY3f2UQonH7OViGIjjq9OfNxDkOQnBnqxwrNphJ2/6uvvG1cHBdMaTPnVusg/SyTCnoWm6wrbv4xx2kTrxB27iqXozqXC7D8yCDDQSetjKahh9yltS4sEZtNzNZuC4vfDSuWjs4uJ0BrD5Q5rRrwA7u9V584E0aHtKBhUPW6jTslhFFEXOG0BHeD+2+IhtY9IABCv8Mz1E6rt8u28Y9TZQYJEUowFLODE91LwfpeoVz58Qlw4fwpazMBGrldOyeZRg9BB4ORFHTvyAEH6P3EpCE/M8vtzy90Bsw/TVpgaVSyXatQFFrPYn7WM79bO995njrUqYSFOTiwZXrnZc/oMaya9ZrR/+QIrSf63iaKGRNsqVY9YTPfVO8iCMVvy3Kw/EcAqg7jnGOE1Tv2cZeHxQHcBCWRkykV6RhrjRvqRM9LqB075q7aICnZlqDtic3t7sOeG+M2NSeHNW6x1wEoPaPZtQtOJEJ1wJ39clS5sh5PBC8dYoshnvhm/ypOo4IJCOQb63D2z3tOPOVI6ZsrwuFdWJWynYPt1gAIi9/bczByE0sn1QZS06jo/eq2xwYKft/AJXWVuC24O2FcgIg2qoqAWEdr66JqqSOKYAGBCf2yj1c7mXkwqtU/USBjfbyZoPI5/Uc2Q4/Fgs0gSYCNPpIMar4vlZFf/Kuezf7n0Zc1yixGJ8JCpiTjTn28UoTuPsiY+VZoh86JalIyv7YUPdRcBYrm+ZgHeRMiYg4OnLX8xI9fRMsw01hH7iBbybNannYhcDX/E3OdbDCpUeJuP5T
 DQGBdXwT
 9zSTSv40ulNYQ2wlw3I+N7bxybp/7w+E9Qqy6m0LBdfS52t02vjfvM4ibakX3VjXaucoYMh1zEkG+QadwJ6guPtRkMQzYy+ktFm6sfUvLajGnZLjcm0pLwPpOG6fre09Cqf1fGQw10hAEGTNVGnPfXBWIMxJbsjCmrb0LHx7kP8rOkAypm3eWKleElqgzV6sK8MKXlH7Et3heK4naEZt5JIpjzxIOy8sUxlAlQtfyruaTCf2PQ92V5Sb6km/PUkZzUbTEom14pwPn1m3FbK4tfJwHopDDM6W2H4GQOoOeb8KVsDXfh3K4LSaE4uW3PCgYscKrqmJtf0fFtrFDe2pAatT3x/RgWvhPFyEK7OovicVAHZHAqVT+KUiW2bQTavgKxUvjFuD772FhsvzOF9e4TrgXfKLYbXT5Rt7jgQOREdcnF2RjVU8f0joj8+RaZS6EiOML5rKgv7cFcjt8vxE8xBIvrjY/9G19Yie3W21U2hg/c5cwf3e3/E4Z5C+E7VoJppMNAOKcuB/UhuoWIHRgTgIFMq5kuIl3schwPHyCAxVa2a1QKomlTV5DINIypLMbqaU9ovLovpoYTnln/CDAEp6TtbPXJI/jForf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


> 
> [Severity: Low]
> This isn't a bug in mainline, but the refusal described here only works
> because try_get_page() enforces the refcount limit. That check was added
> by commit c6c9a4c1c9a1 ("mm: limit pagecache folio refcount when splicing
> into pipes"), which builds on 26b8f029ce52 ("mm: limit pagecache folio
> refcount when mapping pages").
> 
> Before those commits, try_get_page() had no upper bound:
> 
> 	page = compound_head(page);
> 	if (WARN_ON_ONCE(page_ref_count(page) <= 0))
> 		return false;
> 	page_ref_inc(page);
> 	return true;
> 
> This patch has Cc: stable and Fixes tags back to 800d8c63b2e9. A backport
> to a tree without the prerequisites would still compile. There,
> skb_frag_try_ref() would never refuse a reference and would only warn
> after the refcount has wrapped.
> 
> Could the commit message state this dependency, for example with a
> "# depends on" note on the stable tag?

No.

[...]

> [Severity: High]
> Can this make the converted paths fail on every packet for drivers that
> deliberately keep RX page refcounts near INT_MAX?
> 
> Every frag that is neither page_pool nor net_iov now goes through
> try_get_page()->folio_get_checked()->__folio_ref_count_over_limit(). That
> check applies to any folio, not just pagecache folios.
> 
> The gve driver uses GQI RDA/QPL and DQO-QPL, and none of these use
> page_pool. It biases its RX pages up to INT_MAX:
> 
> drivers/net/ethernet/google/gve/gve_rx.c:gve_setup_rx_buffer() {
>     ...
> 	/* The page already has 1 ref */
> 	page_ref_add(page, INT_MAX - 1);
> 	page_info->pagecnt_bias = INT_MAX;
> }

CCing the person that introduced this refcount abuse, making me angry on a Sunday.

Fix your goddamn drivers, that's just an abuse of the page refcount scheme and I
won't hack around that.

-- 
Cheers,

David

