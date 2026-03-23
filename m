Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3660F483E7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34DD86B0095; Mon, 23 Mar 2026 15:32:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FDFB6B0098; Mon, 23 Mar 2026 15:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ECFC6B0099; Mon, 23 Mar 2026 15:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E11A6B0095
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:32:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF23713C19E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:32:11 +0000 (UTC)
X-FDA: 84578323662.30.2E93261
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C6DBF40010
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:32:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lqq8zjWn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774294329; a=rsa-sha256;
	cv=none;
	b=RgjXzcge615aXqov/XLu5jIfDGMoseQoLryX+UIl+P04Yn1/8etHI4LHRTyhITGIr6XK19
	uKYUhNZmmcVShV38W94PPCPgmn4Ir7sHDP7VJoM5EnrXzuyECDuMnLBcf+I4AXwj3xsdRR
	XrvaaLzWs0mYcV9Iz+mDAsU+FZ12U4o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lqq8zjWn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774294329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6noeMhmN1RTeEof+ypetO7wKothDXttGBMpfLs2ADuo=;
	b=51u2WGX1ERuE2vZFZZmgwCp5yXSvzBjPQjVTQA3JOW4bxjcaZaetn6aOvgtDHYrrXEEpsP
	1E5irTFwKoxpKPua336CCXkk6l2bFyjnqtQ6g8MbT5bJykSaQn+JPI1dNQxCTJqf0dn01y
	vxSmRqYWZAqK0usGTOP+f0JTwLmRde0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 28087600CB;
	Mon, 23 Mar 2026 19:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF016C4CEF7;
	Mon, 23 Mar 2026 19:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774294328;
	bh=DcSNcB2vuoTknQEOUpXBENgPkQtkP4p/n7AoSZPFNDY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lqq8zjWnhd+1rhQsZ4u5Qqi7r5aqHfjizsnQ/p/wpc85SHL84waMlt3aGYJNZijeZ
	 A5s+79N5WA1i7XT7NwfOJegVOC1F95hSCJwL/0vpcsyqs4QQQgp/JSfBj09/PU2W3a
	 piseMpqaiph1/bV0QmqPrT1ylSbztf7Q4hG7y+YWH+oT3pHWeoPvoz7o5BNV2y6h7P
	 piuHTQbvounqqcc91YQCNWYwSIuNODWREGYGzdJHbL6ntprBNVvccG9sFyk71UfJL9
	 bvDIZRyMf3quZ+9VNLvB0q6J7+kI0RZkz7GYhtECpzzBf19MhQgSiurPqfDv2O2u/v
	 gtf7xKGZ/A+DQ==
Message-ID: <33879ae4-5788-42ed-952d-9792d50b4a4b@kernel.org>
Date: Mon, 23 Mar 2026 20:32:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] mm: switch deferred split shrinker to list_lru
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-8-hannes@cmpxchg.org>
 <61d86249-cd89-4e99-99d8-ab7c72e95f34@kernel.org>
 <absr1vgNP_tM1OEP@cmpxchg.org>
 <e9631520-857f-4f67-8944-6af7a2b47e89@kernel.org>
 <ab1wrRdT-4GfWbcH@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ab1wrRdT-4GfWbcH@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3mxg444pkztdmr69es3of9g9nm9mh8i8
X-Rspamd-Queue-Id: C6DBF40010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774294329-891211
X-HE-Meta: U2FsdGVkX1/ORt9k8Hfl07bY2b2LIY6qVpEM6cynolI9bzqtMUZ3ZIPdyyFHLtd+lpwyDvzNbDr+ajeNfAEAQLI3aTWnx/8jAKOyDf1zp2synAtCfGyAjGGRUmfJ8FQUr67aqpO2QLVupHkWYaNk1/YAQAKSwmvyY2qrDTNHOdDjYqcQ6LKlm6dwy395LfVt5lvGfSAXI45X7sDE3G7QMOJXxwMAcrXNFiAftVCptYzLFC83emCuiYFlJnSiu680dF9UPoLQ15YW0EDFrwIf40wZDzAiR0Y1ZM2WVJ2GJIKkHEzzN6bjGqHBDVystsT3fSOJdjgNQVtEqfIb61/9gRstibF6iQuVBDwNFpxAumfTHbblxooOPeCCebtMS8dYrsZB3F5YI2J1rxwH/1qi5g0NjjDclYPiBWAesaJkZ1wH4c9Ujua517nv/wZc9qx5oFsE+/B+Wabls7IAOwXvNyYUDGM8kQFewj9w0ZGh6cbDXrcziDSa2BOfTj+69qgZ4IpodmWbPg/Cx+oegWUCqUzzvMI7pckWZ1aaQNjy1uqD5ZwA/ofg5n0Kdmw61E59KYzM2s1xT7lf7vqrHP1r9RjlNACca4tGrUxd7k1mzZXW4FfzlDTSTwwrLzUxIDzFqyFUbmbTYd+xabYvGjL/2TLjvgwyPzji5Yt8f2M6ZN3xpae9nmjEIopQxx/VgIkfMEhPDQieZ54QpL9pzobZUX0XJUXyl3iQeeEY7KEHeiXDQlwNSYC33iIaUavCNy6tSryt5lDIIW6i0eWByUb1t0v/uXSAkWF5LwQdrwEBV8zFQBS2eQr+fUOBw/dEBNX8L/WOtLtfiAO5/qBWqwTRchDeVbpUlWrApjvi+vua2i1zL49HvGSYHb2UuCeBYCRuskP5tw09v/PPCtZ2PlzneYsstvH5Qdx1nkGbjIw6H+KY4oS7bpZ8Pd1P5oHDqOimvxVu+pykNWCQz7TRUZQ
 eU/Wd6h+
 0ca+fOgZgpv0RbY9A/uShOtcOmvwHS6VLHWgE+3f3rvXFEXaHUruCXXH78ZqLO4uNpUSQ08Dr4unpp0kOhLG1dpH0QSESuSI1ny0brvQ4qjINXTNLksKUH0bSzD2QBJsNDZpUpGa8dvMVdoZEJOO+hCN+BB42kEn5Ge7Y5tNE4S0dSP2+6zGn+KaRLjANm9PnFeEDrc2cY10q51Nyt1U7rSCOs7R8wYctbXmkrLodrL6UdZcmd7aNgGlY4V2HlHS68sOdSs6wCMnW8tlg0pEkS1CwDBrA8liYiKJigbLId4KaWsDkFo3eRGXZkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 17:07, Johannes Weiner wrote:
> On Thu, Mar 19, 2026 at 08:21:21AM +0100, David Hildenbrand (Arm) wrote:
>> Of course :) If list_lru lock helpers would be the right thing to do, it
>> might be better placed in this series.
> 
> I think this is slightly more promising. See below. The callsites in
> huge_memory.c look nicer. But the double folio_nid() and folio_memcg()
> lookups (when the caller needs them too) are kind of unfortunate; and
> it feels like a lot of API for 4 callsites. Thoughts?

I like that. Could we just put the implementation inline into
list_lru.h, such that the compiler could try reusing nid+memcg?

[...]

>  			__list_lru_add(&deferred_split_lru, l,
>  				       &folio->_deferred_list,
>  				       folio_nid(folio), folio_memcg(folio));
> -			list_lru_unlock_irqrestore(l, &flags);
> -			rcu_read_unlock();
> +			folio_list_lru_unlock_irqrestore(folio, l, &flags);

I guess it would look even cleaner if we would wrap the __list_lru_add()
that needs the memcg + nid in an own helper.

These are the only remaining users of memcg+nid, right?

-- 
Cheers,

David

