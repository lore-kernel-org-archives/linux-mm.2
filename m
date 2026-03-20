Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15261108B904
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26B556B0089; Fri, 20 Mar 2026 07:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1AC6B008A; Fri, 20 Mar 2026 07:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E020E6B008C; Fri, 20 Mar 2026 07:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB4066B0089
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:44:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8754AC063F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:44:19 +0000 (UTC)
X-FDA: 84566258238.18.52356E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D171F4000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:44:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sWXnbUII;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774007057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYb4FHf3PCW5LSK9DKOUyRNQ49L4FNJNqBrPlKiywnk=;
	b=xPZqf6KFYug9G3oqUirW7fTMWoFnovnvjLh+qh2LM6OTOST8dQ5g+k0FZzmJ7RlHnFjXA4
	3pbYv8SHN/U8VwmT7hRRdz/AHWi0q4mBvQLthcanxsXsd+g/H9gvso1KvLUDzsOOckcpC+
	bspuYPFSWNnTAGW9pVvDe8m+DL0bsR8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sWXnbUII;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774007057; a=rsa-sha256;
	cv=none;
	b=m8PtpOc/Kxc6/N7Jfi/BVEHxAM5L3nDhIkA/aol7kYf6e3Q/wGM88XspqJk2uT5iBP2PRp
	+2Rfhh53AWvfD9Lh7a7wraWLZGQEe+woxPyPGlhON+wINWcvBr1xT4NH0aXJUyngCe/c+2
	Rw66k0uKQcG86f7oRlmvK2/PhVb5WxQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 403806013A;
	Fri, 20 Mar 2026 11:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC06C2BC9E;
	Fri, 20 Mar 2026 11:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774007056;
	bh=uxcD6iy1OIzVsCiyIuf5xalzycBJ/0G6BKEWEQlSuHw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sWXnbUII+e+xazivVX8K5ZHLQj5IqjAjJZjya1fRWC2f5eH4nbm0ZPpNq0a35uOxj
	 bbnrZCjZ8SELJfBiPw9y+U9aaLf4Do56kNewdMeo/NxrWgoyJWjuHA3i73KZKyRDqy
	 tRLLB1+JWFC5rBT3hBJrNCD9dEZOiAEPvK99tSKuyx4YGXf6GpnuH64bFS3bGPXSAj
	 DV6NLpz+bfcDNOloNU213VgbKYQ8JHxTX6rJi0lKwNFpG30YKCrlJ7lES1k4005U+N
	 1mLVCm2jo/vgm8itMbCAdUCTaFw1xW8XPr3PAji/TzMp6fi/DlKwjUdulyf+KoBSfZ
	 4ZtG9vPJHiCzQ==
Message-ID: <024d2480-df23-4c2c-9f2a-1c4a130f71b1@kernel.org>
Date: Fri, 20 Mar 2026 12:44:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] binfmt_elf: Align eligible read-only PT_LOAD segments
 to PMD_SIZE for THP
To: Usama Arif <usama.arif@linux.dev>, Lance Yang <lance.yang@linux.dev>,
 r@hev.cc, Ryan Roberts <ryan.roberts@arm.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 kees@kernel.org, willy@infradead.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 baolin.wang@linux.alibaba.com
References: <20260313005211.882831-1-r@hev.cc>
 <20260315034647.8462-1-lance.yang@linux.dev>
 <0c2bd25d-1577-4935-8ebe-0762b480abfc@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0c2bd25d-1577-4935-8ebe-0762b480abfc@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D171F4000B
X-Rspamd-Server: rspam07
X-Stat-Signature: xy7h36krs3ni9o8ixygokqwoqwdqyiri
X-Rspam-User: 
X-HE-Tag: 1774007057-703706
X-HE-Meta: U2FsdGVkX199R5t/8cyvoCidmNFAaUrtYng3+FAMC4yfncrJPi9DFgQv7VSpgYOWeb3uAIOlbsv2fQE88lajF11LVC2EMlIG4iLYoIIbBNmii93Sxu6XxdKRp3mwv/Hmr8e+RadV0uOw5zJ6BkTg0YKh887LTDmOAELSjxP1lxd5y0ZUp8rJytZU+tor051edbpjw3lItBNMfjSVfJgmOrRA+ZaZhrLkC1TrCEN72PScYZRuj/M8qjP5XKarUtABQ1auBL1KQw+a6mLTNW6k7yjNV8ymt6DNOpofZS2BDNLt6LSRYakPMzKKJoAfzixJEG7QgUfYANessw7QD+NvfzJ9mnmojgr6N9PbX11bjRn0zRrzC8Wx7GzMCwFgGytJcoE/s85h6WwKOmFvtcXB0MORhHj+zR4y0QvLcXT7KgfjdzEP/hKY9p2dwv9YYoob/D1J8Ga1J0q0lHkP6JHFmNX4iz1KXYT+0hXLwJCyCSV3KbHMqQwo+ZRzgS4z0i81iSPqCVGqSVt4qeiE0pKtSEBAuZRQNqEaocMG7GXKb+wDXbSuUyjHL5+8tcRaXmU0xokZ7c9yRZpWgQSfKC1UvhUjz5SjnE/dB/l64ph0G7eQ3NdbPhxzQBHf5UhQn9UR16EaKi10UmxOurOCSTO4v2Cwgiuzl4yFLERHlinDJ08YfW4Tn8TE9FC3tqTGO4wBvDHFxjnBK2PlPG6ym9p7pgEsyjOV7ccMazsKPrucWZjsSFJ40Spgd+GYBxVTx50IT8ljkqxt1d0ztS/j8lGqc36CcB/CrgCKejCXdHUHkdd+CFnVkdBjc0QbaVASugqC2hNsRRa3XX6iMLajiVtxtzq52WKyyQuBwLcqJD2qBAH2FMTCHwgMq6AdGBNpcoftjqZwxL6ECO633kCqux7h9c3jGkrFq2do65+L0vG321NmZE8EzNcH8R4Fu8VT875jItHY6k5kuIUoFZ+UNLp
 8KO3csZg
 z/rVXW9jDKugrNGsK3Zm7M9CnxeuRfWGdEm6DEpuhgs8UsKfrgrbarM9+jEKZeRJrJPJJp5/WUQC3psgfi271ZVZjQS/Us6McLaYV5sWjhPGNe+BZgVahkCn0cCDQjgDV1QimU8ozNkq5/LZYy0FnshztUiXaoRQQd7ABIpCzPQJv9xOSRFp/3tj3nFQXxJ56q7HXyds+X1+DEkcTQkrnic6cWxCTsocewL8HY4hThemtiAZAQrIom+rqv82yNEpzqFcQII6BYwMXd7OOFT4eNmR+Nlhkv4J8vLz+JEuEMlime2CHsya+LxhBMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/15/26 14:12, Usama Arif wrote:
> 
> 
> On 15/03/2026 06:46, Lance Yang wrote:
>> Hi Rui,
>>
>> CC Baolin and Usama
>>
>> It would be better to keep earlier CC list across revisions, especially
>> for people who have already reviewed or were explicitly include before.
>> Otherwise, they may simply never see subsequent revisions, and from
>> their side the discussion just stops there ...
>>
>> Thanks,
>> Lance
>>
> Thanks! Also adding Ryan who did the exec_folio_order() work for ARM,
> and also raised good concerns in [1]
> 
> The problem is not just alignment for elf, we need to fix more things like
> mmap heuristics [2] and how unmapped areas are gotten [3].

I agree, ideally, that would all be tackled in one go.

-- 
Cheers,

David

