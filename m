Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D7E2106ACE5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7106B00A4; Thu, 12 Mar 2026 15:44:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A77FF6B00A8; Thu, 12 Mar 2026 15:44:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871C76B00A4; Thu, 12 Mar 2026 15:44:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6EFE56B00A5
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:44:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30A6B1602F2
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:44:57 +0000 (UTC)
X-FDA: 84538439034.07.4E80528
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 70DE78000F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:44:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mpEVpsoU;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773344695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SnFktfRM43dYSUMwwZXoKEE5a7xueCnkwlUIcJwTPjU=;
	b=oqCQGnmSx5C50OwB4xzxc00Pd4cT08W/M1G8NG/uMrDYBMMMVEmpB4Z+05QvmcB5FzhDpN
	qlEzeBfUlh8350gd5W4MyoLpxfiOVIcSu8lItXdP329PPNkswWTm9ll13BMDZJWtihtR6X
	Tp4aM92YkZc/srfAoAROdwu0KgGRcWk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mpEVpsoU;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773344695; a=rsa-sha256;
	cv=none;
	b=ThZ9MSIsRCSw5J5PW80MsRU8fuA7vH3D3VvloBOTEuPok2csV/GC4PUr0hVmpUnpxo4hlG
	elyqLQWpOf0wSsBBvtS2mmuDt3ZVk+nvz229OShHSXuz1egbmswCjaDyDAelo8cgtMMfaQ
	gOBzPPSATg5SUVnrL1SBE+LoI5N4qbk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CCADF60142;
	Thu, 12 Mar 2026 19:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EB0C4CEF7;
	Thu, 12 Mar 2026 19:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773344694;
	bh=OTVyLxUvfae+dMqceluPl0oSG2+r6KAk9NfYzk3yz0c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mpEVpsoUORd9Ee2TTZ3hNrej9eISTEtQ7YBcHQmQPpqj6nOBRFD1h1mof1H8c9u48
	 b8iOTQ5kfSPt7O0H1YDgzHSS00IqB+08xctccuEyMEJKEuBf0Y7VTS/0JJ0G2+GF44
	 QtLTwAOW0V+11aY9tzA66NmW6ioL00dxauahiMNDRzg4NI8Qcn1D0DsG067PVumxDP
	 rx538igm+rfMNgCahXju4wTr4zyseGrNiiuB6oFr3hylMJSQkcYLQ3Sg+dFYZhh66h
	 KLY5urkbl7ro08TFSA37m2CE6L0b3Cg3rIkDo3GjW+oTyu47oIKaK3psCLXzbBN+u6
	 iLFtBgeD3247Q==
Message-ID: <cb35f32d-ee65-4865-8664-1c9d7547bd5a@kernel.org>
Date: Thu, 12 Mar 2026 20:44:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH 3/4] selftests/mm: split_huge_page_test: skip the
 test when thp is not available
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 Li Wang <liwang@redhat.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <20260312114027.634559-4-chuhu@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260312114027.634559-4-chuhu@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 70DE78000F
X-Rspamd-Server: rspam08
X-Stat-Signature: 91nyougpkkbwwo3sxgwqenxm156spa8k
X-HE-Tag: 1773344695-537699
X-HE-Meta: U2FsdGVkX1+DXAXsTy61CrOmFDs8mUtUj0OHwjPz5ywqXfmJzPFaluMans4Tubcfn7s17MppYF8rZ6REa12rg/2BWqc1ZVClRU/Vhq/L9gZRg0AgCsRwmG+NovCD+q8TYMlK0727bbcO3Ileoud0ykokMatx0gCxSBWWW8FH7uZlTFZnmS8Vc2ypBg+1LLT0Yk33MVYjH2xEpx20YrUoR0Y7j8JoFc4ckRWJQbMg9fnBaMDEncZ3sv6/fEWp4IX14y/uSYxDPwTnbE9Cmns3pVgbDrDUpIRhtY223Oj86gpPzJrlgwpHmbk/FM+HW7ERF0hJl1cjft9gT3AdJofQ2z5eH4vgHUJ/Wm5WeAst2whb44q1FLCZuvoEjkf0jLG7ubP8gBhbwlRLRidF+zE1M4gTAvQh2DJfwQn5D5AZ86B3ARsTrntWFZY5TMhGwcA6NLsdObDqhbiS6VFFaF/gCCuZTinrf8tXkvL7X8rYIbeHD6+cXPFqh1bKBvhNJqDkbIk2svmVpqFNdD79VUkHpe/dYZgx74VgHr3LwlHbj7PRXYISJidwf00bAbQO4lO8Jv66vrvyVnjWVTnjqAPWm06LhkNTIP8jtGwY2ZRRAfM1J4RcdGTqcKTeLgbj9qn97G7c2FMSpPlIsUbrRHUCiPKo82ALwiwJ6TH3ec2+Fl6SY2a7VRyC3rfeyMZi38F8wBZc6dry8pxh4zba4jFFKpyxEeY5A9/fwt/guYRMcpE9IzFSYrOTDoY5/HpfwZv27E5F3W88il3koKoH7doHtEo5WWm0h5IwcDMU3E4Etjl5eE61MTjYhKzK+Fy97fu6X4iAOyMyOEXjh/A7ZeaWNu1UVfh/pJgoQc8C1hxJzGhISd69sB6VMftAF7uPpEB2LUAnJ03Far5CH+yTkppzf/S+opSCVxU2QYBE7JmXhUadYPhT/74AmZUNLAQ1FqZ1ZI6aZYX9k2H+7kxBWa7
 ICpI3kbW
 kcJlcay1k4KvYcOOQy/9FH43L4YawtCs1DQlu7qHciSS/aGfKf2hEj0UTPSTV6hZq+6AV6lVH1GlILktjM9+0DvJrv2crkVIEqDEfpFt5D/bqBVcK5E7bLFX4Y9a+Ya5nQsb2KiTHgetUdmXvjaA/YEhZ9amLFOwyICPr4HCmjr7P5i1enD/tzSLK6BTS8bE0TEWZMwXh0QrHRjxGyhQmcJkEBXklD8KumIG4wmq3/fgpxCIQbXs7oWDMrVDF15VVJh+MmRCJ4IX6MOoTQPE1QwI1LkNI6spsOwDKDaN/Athok1suufBR4ZvJXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  
> +	if (!thp_is_enabled()) {
> +		ksft_exit_skip("Transparent Hugepages not available\n");
> +	}
> +

No need for the {}

-- 
Cheers,

David

