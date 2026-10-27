Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 069AF606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 18:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ClfDa6uH
Received: by kanga.kvack.org (Postfix)
	id 06BE26B0897; Tue, 27 Oct 2026 14:49:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01C6C6B0899; Tue, 27 Oct 2026 14:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E75F46B089A; Tue, 27 Oct 2026 14:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C70936B0897
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:49:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46C4D1A0A3A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:49:28 +0000 (UTC)
X-FDA: 85369294416.25.EEAB894
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6D67340005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:49:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ClfDa6uH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793126966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zXDhAp7FCGN52SyLZr/XjsONmiwywdpDPYNB9mFEGnk=;
	b=I+s4bmRn3pemI6kmIWeNsflE4HQlIUN3JaICLJqFjis6uojE3tjPaFO4g+MOJithFoZg3O
	pN9equgVrhaZSfEi9cPG54LpGLZrH2T4dY2JV+0h4QfAHuJ+1w+JEUsrnMy6CaNtgIzZl9
	R/x1UHzSLMXVN75Xc4Gy1/Ma01OsvTA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ClfDa6uH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793126966;
	b=ebNLzyngfcueLwGaywLCYom/6vHqzplQP0uP4FD+2VMAUS+tXOXBfryd/1+BxY+e66kuXe
	1bxgiEPYhdQJM+oCNPrMhbzc0OlZLvNJCkXMLQGoAT+/+TbH4ID+jhqUQXxGWuwi+V3PxR
	26pBE4+G+vHTE/zAv/hVqNLcmmdVzPc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B256940451;
	Tue, 27 Oct 2026 18:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD69C1F01825;
	Tue, 27 Oct 2026 18:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793126965;
	bh=zXDhAp7FCGN52SyLZr/XjsONmiwywdpDPYNB9mFEGnk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ClfDa6uHfHxGdssP3bH7QVtjzQ0yMwn/K87h9i2uB3nlJ+W59ueQNs4tydrlw2NkT
	 bfEiRZg4kLD3hLlFsOrO2Q5EI7shl+YWXNixez1WqNI7sNtuPlVfpf9G50LbDDohIL
	 wg55J0zvD87t8Kj2GiVSS67wxzSHUXsDjl3rQRl76VKCqPUsR76/yLW6DId9AnX2MI
	 shu5y8MPHcHfVdj04fGMoKYiRTaSCCC4XjHDjTGwFPxLojtKYD6O+szQ450LP1uEjl
	 8nWwndhYMcw8L8L4uboJVqIOjIW5ff8bK31x1iOynK6qzBno/NMU4HQIvjPL8UvDfr
	 69rruM6iVP8Tw==
Message-ID: <3f289ead-62fa-43b5-9d9f-790d94951822@kernel.org>
Date: Tue, 27 Oct 2026 19:49:17 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix deferred split list corruption on
 partial unmap
To: Mani Tofigh <mt4022@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Kairui Song
 <kasong@tencent.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 tz2294@columbia.edu, stable@vger.kernel.org
References: <20261026-thpsplit-careful-v1-1-d357d70fd6f4@columbia.edu>
 <9620707e-59f3-4b91-87af-2b8e12fed260@kernel.org>
 <CAE2e9Owov22KK3ZPkfqwrJFpAMc_H5Qq22aoKpQ=0mWhiX5Q_Q@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAE2e9Owov22KK3ZPkfqwrJFpAMc_H5Qq22aoKpQ=0mWhiX5Q_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6D67340005
X-Stat-Signature: 3gc19k7oudp95g68i8gcg6zo5rbjkndm
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793126966-746462
X-HE-Meta: U2FsdGVkX19LKvf6JLbL41pFr3hOXHhV0RkiaxQlxCCjcIi3y540m1i6eqqcyBRI4GCP1lb8wqaB4CJmpQy8xO91hrVVs3c0DOPH4iArKmTpXx2pBOaograJFGJ4++CDv29+j1rjTTHhIMGUwLlyzvLW87kThFjJQ9fb4LifkYij4+LbrSISQX8sNOVqbwcNGa4n+t/Hln8LnIfcbwixAe75ccWAem+xe9+2c9qLzdzjpMaENAHamzuFvZD8mf184ATlVLPz88Ex9R7BoTpLYIgMI/rtDnoutaYFa7pio3EgWMwr/v8Pk4GtoNbB9pWHUyBMkx1cvl9ujMgrVwKACPzRJ3Bqyot3rndKay10wIJ6xRCrJv/nkvJRllyNyqyRmYwq89GnMYqPQDaHPpbTNvc6N52XZhkYqjnsIJzMQAt+vmp+IyaLiqgIqghu5ZgH06momH15oB5nebc1RdEDMKlfzetJ2EiVQDO2ko2CTfxVqdVPtAJSydHFvcT6wEb0YtL4s58Q2fsrMumGkRI/nG20S1sPf+ql9W+PP5tWOfde4dznv+ovS/uwXwWG26y3CGi4LyBdPEJF9gAZRGHTfysz1H+J4NZ/ranNEmQNwRH87uWrUIIzDHpn81Z+70joI6iQgGx2Wsvwxs8ct2UXl3lFLSE7gC3kt6iLgDn4M4BaCBH8mtDQnN0g9A1ICe87ScgA57zFMjdIyzed5CBE/iDJ1vq4+rlRWV+9nitK+PLZn6cwABRAumgSgj6efkdRVjfy8gYoZ74qxmbBLkOXJFn0WRZNn0GH9FJ6RtgSlAq3WMyuS3C+TiHbNdzu286Z9VZ8aqjw1FX98CsryeUR1JacZvohBeSlxSAGf2IjWKFsfUgwukvbo7k8cUISj2PUlQAJpRB61VPgccjyt7rT1I0pfrwRA3k1gt3l+/5+nETc3ple1CLNVxUDKtaXufINz4/flA6hF7+3PsSFqNn
 U+y29FgD
 lFI/iQm9kdKYHyxNdcV8Hn7xWDWAbKrJNMAVev6XL9AfMBKBWXy4wS2VYOe8RnIvyQat37hNqVqvNTH51TESNuwr/toO+RzznFCnpWlwkulUKDTdfFPjxQyVFXdlUj6W3/VSHQQgRhHW7vFYTtWfgkcm8Uo9OXlCo+JB4YtTb8oTch06/0P7qfOL2doq4W8Bu5/1S78LgFda5wDEgEJ8AlS/QPebh4VM7wlAGvhXeT/Og80AFXIsw707QWAUIVBETwTYML3xwhgkBVMJRDxxtSccHT2tCSn9dn1jtJmzIQCtXov3dAu4weIIqcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 17:47, Mani Tofigh wrote:
> Ouch, sorry about that, it was not intentional. I searched for similar reports a
> couple of hours before posting, but missed yours since it went out about an hour
> before mine. Your version is actually the better fix (more on that in your
> thread), so please drop this one.

Yeah, sorry, I was jumping to "this is an AI agent that rewrites fixes" too soon :)

Thanks for reporting the issue. Please do keep reporting such things (and
proposing fixes!)!

-- 
Cheers,

David

