Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6FF7606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y7p61y13
Received: by kanga.kvack.org (Postfix)
	id E33136B05B3; Tue, 17 Nov 2026 16:42:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3A36B05B4; Tue, 17 Nov 2026 16:42:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFA856B05BC; Tue, 17 Nov 2026 16:42:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A18D86B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:42:30 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC4FC1605BC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:42:29 +0000 (UTC)
X-FDA: 85445935218.02.035BD5E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 16D1414000C
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:42:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y7p61y13;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794951748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrcUl658g76wxGBnlY4HNlVgi/sQ8Xeo/9AIM2wsHJM=;
	b=Y520fsnt3FiVx+L1lJXgxULtDU2rjx6+oJ9GChw/ZfvoYMQHxLsAATOM9z28Zqu/5Y3feC
	IjHxYEi75ycLFUq6j3w4gBNZFEBeuekk2532ENEOWJ/V0WBGzPXBHjdN3wWJapAPT95MX5
	Ao2dghhiV9bvpIkCoEvaEjnZN1v4s7I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y7p61y13;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794951748;
	b=m7SQxOyCCdzrjxZmScryQuUNTQ668LGe+rnLSW0JPSE/RlUQZn+BshpxKWVtlpVTpJuLUt
	vJfLHMu18VcpWsslwoae5jFNDdKkOGHuUFVeaxe1RH5fvxBBc1UYGy8ptMP7BHbqVovCCC
	LObDU0D0MlMRjMvS2kTVfrOa5mFQWZY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A83F061B44;
	Tue, 17 Nov 2026 21:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B461F000C4;
	Tue, 17 Nov 2026 21:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794951747;
	bh=jrcUl658g76wxGBnlY4HNlVgi/sQ8Xeo/9AIM2wsHJM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Y7p61y13BfWYuoxnnoMCURUYRODS1qlCl4Dr+pzsmMAThjcbDqJLu8Bhgfj/Zawaz
	 seJgjEv1NEpqfVdf2vBmYzELK64d9BZCyjnPP++cdRoXSIkGwiEQrUwClzT4vL0D8B
	 QiK2CRA3xjXyfzwRhWJDrsDs0NtmazTTVxqhgsb6QR8chN7c/uv7UTNMTxUhroMueG
	 AN1z8Kn0kuL7zLrsfk7scHdsYDtbpZYuU86z1/KAiJ0M5hUys6dKXyMTbN04B/NGHE
	 aqgSrqTYtx85vlCmgyOOkL4oRK6WI2O457aOjmKtEoC9vm2G3zQ/FXBgjR2sFldl/d
	 8kHKyOOlBSBBA==
Message-ID: <2c6d4e24-8ad3-4190-98a3-d3f889d03890@kernel.org>
Date: Tue, 17 Nov 2026 22:42:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/highmem: refuse to copy hwpoisoned folios in the
 !copy_mc fallbacks
To: Yuanhe Shu <xiangzao@linux.alibaba.com>, akpm@linux-foundation.org
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Kaitao Cheng <kaitao.cheng@linux.dev>, "Garg, Shivank" <shivankg@amd.com>,
 vbabka@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, ziy@nvidia.com, wangkefeng.wang@huawei.com,
 tujinjiang@huawei.com, mgorman@techsingularity.net, chengkaitao@kylinos.cn,
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261110112641.1196786-1-xiangzao@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261110112641.1196786-1-xiangzao@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 16D1414000C
X-Stat-Signature: u4ftafuqnjit8g895rnpchk1qxy471ge
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794951747-631769
X-HE-Meta: U2FsdGVkX18g8SjRGyPXn6iam+uMxoey5leZdLCKaWeEWRBEW++yTXr5JW18y9QtcCqc2EVNR1t5Efkj1pKreMtZm7+SVeIBk52tLljLwkV/+Dfd+ZyEU1C/8OLcp4lOY9ckf3fEW4DABzQZmWdfVRu+8x4i4dIZ9AAixvBn8shJffH+O/lRoh+/mAhnsvfMna54wslt0trAb6jmxcs9K8lcGlaeN88E3x2OGuVtHObpgx+sNoTdUJVk6EFiFtuIRa1jHjN1AKVG1ZM9/Iq6HxscHhIRemAh50pQHN7dsXDy6iEgVUl9yM+3O7lHimQ/3ntWZ5MRuIB1CgHqocYWKNT6r3Jj0eK8ioV7d9skNTHJFWXBjrGFavCwDeAE3A4RYDWjTXAjMno8p91Esunv9zFSWNb34jSAmwAoOStq5+ZqDRcLOoOAYWebsaN1Fass8WMuldn2EZVF1oBeWQNfAjWmxjlv1KIHU13E1s2HyPmDgA0vlFw7yMfMNus16RArUPS0iR+bt2UgKqMCQTOa4TfBdODqy2B0JanXhYzrS2rkxsJg06On/46n429NZSvkAV5qkniGEAo90ku07dvCvYozhYrbHvFQz6RTEVswzpETboFztc5fgShDVwUD0c2M6xwgE1ckfKy+bvXb3Eg3cFwZmLGYbuL0n+H5i9fL/Dk+pBEdmCqFxQ6/PMCBBAU6ZU0pT73G6YSeL59bFQlekCoriNZV16pvqWHKufvJCjgI03oDsBg43lNrYarf+2/f4ZmRnTXQkMe5vrTaSxIXgOyRW8pg3M7AX4YooLci4meuqlmo4QW/AKLWohHjsYkwBZRFrTMWcuFfrCKq9E/wct0foOYr3SugW7cFVOHz5u3Aik//8iNI4A3HgrtQu+PvW/BC8prvckiP+IjZKuFYuEf7lUf2e/EZ3NFoqv/nV718gmCHP08ngeiuEWfT9/Hy6jywf9V/QCB8Z0GElsv
 uzf8SOir
 fP6tDqiEm7+tSqyt/KsrRUVaOnaXymibj33gMm0aBrPpQdu8OweKEm8d+0bxY4q9OWNsBtW0CNc7TIsVl7ibzjGw17MAFTQ6mV3TWx1rIHHUhPmuHpC1+NBEW1q8egUVWPvCCOswA0+LRhIoUHGbfI+XnFBlGV4/CZTDsruPYiEy3110o7DCiR6WfIwJwtGEQW6owxtsVuiFDSPXM5MWjNHjUdcnwwchAuOJ8xJUeOZDoUpokOyOtUZrHkizPg4gt3Xu2YqqzNGoQYbzjFDxQQmOLr8r3CA860h6tOQTNR1pKWN9epWX5qG6mahhXLFTR8V29ug7Qk6Ghc45m5sC+pXrnc9ekW0F7XEqOGc7M4It7T0ZbXL86Cfh6QIo1teWCPA/ndM80o5Qc5NkfTgAzDtk7BF85jqCz6qFlc0yc4315M2adl3SuZDpMntpGSD0HCtn4n5FnOxUbdL1YdXdtOFV7yQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 12:26, Yuanhe Shu wrote:
> The !copy_mc fallbacks of copy_mc_user_highpage() and
> copy_mc_highpage() return 0 after a plain copy.  With PG_hwpoison
> set while the data stays readable, there is no fault to recover
> from: the copy completes, the destination folio carries no poison
> marker, and the poison is consumed silently.
> 
> Check the source page with is_page_hwpoison() in both fallbacks,
> before the copy, and return PAGE_SIZE, the not-copied-bytes
> convention of the real copy_mc paths, so the callers take their
> existing error paths.  On archs with copy_mc this code does not
> compile.
> 
> Measured on arm64, where the fallback code compiles: a
> kernel-space microbenchmark measures 90.00 ns per copy before the
> patch and 90.71 ns after, 0.8% of the copy itself.
> 
> Suggested-by: "Huang, Ying" <ying.huang@linux.alibaba.com>
> Suggested-by: Kaitao Cheng <kaitao.cheng@linux.dev>
> Assisted-by: LLM
> Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
> Link: https://lore.kernel.org/r/877bjowf9i.fsf@DESKTOP-5N7EMDA/
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Queueing this, hoping for even more review :)

-- 
Cheers,

David

