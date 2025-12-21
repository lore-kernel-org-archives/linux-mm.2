Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67185E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 09:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C45456B00BB; Sun, 21 Dec 2025 04:52:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF3C36B00BD; Sun, 21 Dec 2025 04:52:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB6D6B00BE; Sun, 21 Dec 2025 04:52:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99DBD6B00BB
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:52:15 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54AF55B05A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:52:15 +0000 (UTC)
X-FDA: 84243012630.11.03B2532
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9E60C1A000C
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:52:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BMRRYsYK;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766310733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/0LSFw2mOXKTgCQtWKikCNtjD97y71KB/zNu1oqhhXM=;
	b=nXFKjvUlieFE34M1zocvZvy4et3fXd8FQVEDvG8eNRctDHyo9pNo3taHa9+DSV7/q20mOp
	BKIZVn3qPOOt1pxqISY/GQpD1ZSrJzSitbeqCBbEg7eKYS+qc3fmBGM9vk9eoDjmalviYh
	a5ac+MB6IOHuotD1zEUUEDIDIfArjRM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766310733; a=rsa-sha256;
	cv=none;
	b=qFTSMJJpEsVmZancPEyh2eFkeolS5G9yY/94JWaqSZkEv10jDtlQNi89Vzxv3eZXDBnFSC
	zHRNKozeSTMHeug5WBgjbTyL/YDa3q9KKnsIrnehCwDA3DPkOdETBw2U2tSNKpoJ3VKNnH
	RNiSJCHRy3fA/G7MkloY+nvIRNeKSqI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BMRRYsYK;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A2DB041B49;
	Sun, 21 Dec 2025 09:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638E4C4CEFB;
	Sun, 21 Dec 2025 09:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766310732;
	bh=ogVOCJZTSd7k8LM4Om8v4u1baSeyYlcMXQJDVl+klUM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BMRRYsYKm0QDjudC92wFnYoTb6yXHEk2dZ/ra8sXxalHAXuLMD7nm3eCJp6TP8kmA
	 GNhviJ2ovXvsrsCyJTdYAw0KNacfnY0Amy5I89EVvk+9mPh17CbNu+2d6xEOmDmk6H
	 fqm2wRfsZgHJSDmCJqUXuA1k+1XwxsZAK/J6sAXSh/BgX+Z6XpgN7NiG28c8fR7pc0
	 u9S9A7aGq8cBYquID6OvV2uJYH3mGu2VrvibslLyb6GJMcP/EfYGuAA8cuF4tHxNNc
	 65TtN2ZroWfximrzJ0QSiL5yvbI/n17VQC+jdowfQUUE4bZSa8aZUxTFKynaJm2oGK
	 eMqMtqdLby+uQ==
Message-ID: <de5fa614-65c2-43d4-8c3c-549eeeaa5683@kernel.org>
Date: Sun, 21 Dec 2025 10:52:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] selftests/mm/charge_reserved_hugetlb.sh: add waits
 with timeout helper
To: Li Wang <liwang@redhat.com>
Cc: akpm@linux-foundation.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Mark Brown <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Waiman Long <longman@redhat.com>
References: <20251221085810.3163919-1-liwang@redhat.com>
 <20251221085810.3163919-3-liwang@redhat.com>
 <74414ade-63fb-47ff-adda-903949468b88@kernel.org>
 <CAEemH2eH0a6vHhv80hDcTBxTUYHALrOKjtvWnajCwPk_zLpJ3Q@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <CAEemH2eH0a6vHhv80hDcTBxTUYHALrOKjtvWnajCwPk_zLpJ3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fn9yrmudbc9ny39wipc89on9rn7ydsuj
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9E60C1A000C
X-Rspam-User: 
X-HE-Tag: 1766310733-819507
X-HE-Meta: U2FsdGVkX194JrEa1WQllSqxbmDs5ax6iASMz9vx64NBzWP0eDtjS8odG9zWXYWOmDBAfwuWoAZnB0mlhEtq9Pw/ErObfj6zySiwv6IypU7aP2l21fpT/W7KgQxnMc9RDYox73tBfi5p/MsxEYQJhf1ErI9vfVzmgmThof3caLZG6LI8OGbtERPFzr9yGuF20Km9PeCEhM/PYti5Jp6tTV74Jg30igo6Ed0Dgf1x+RKr72MkpArrShHnahSLe+8yE7Cz61Mcb7SPaTkYMkNKcQBkro9sG3B64m5yubUmbQ5pGj4HhiqoGzSYJFHhdyVRZliK7uWgPiChyxrVq0/D+SW5NkmB4PPfTEw4dfFIU2a0FrEnPIMUeh+knMFO0aA/XJhFUfeC9EGm7im7d+hgyM2d3I683wuK2m7S6MYDGBYd2Oc8WpLzg3cDKS+RHMGJj2oFI3tSlZfh1vGPLy0tMWrVk7TSpTW250wTYvK1rrxCdrIOmUODo7W+p54Kq6loMC+49bsN0iems21hQ2e3NQqW4BoY8hJSskmQm6H3INmPQhDcOpMQQuqESdA2qSIChRjR6VdT68ebNTbUxvlLA9/WI+0ro8NCF8ghzF6QQj4ILNjX7lHfdSFRpt1NkgwPtwZ4aHRh1IRZ3Xz2lsjfIqP0GKKFJ64kClDxLfUZOR00lGLlHJSWNZBcEC9DFFZt5Vw8lvT5b0cQcXL1fT9ZzivLdE0QREJJVo1vRFH6tUgX1cECzeFt07qcIyodR0fxkCB9x/wlNr01NspJT+oYw9IW0GtYiQukJ6aGkCclUYDfHhuVDnqDPhK8AAy07dM1fP28/ugfQUy7HFYKt3a021Lhrl+E4n4URubKppwKfkGe/MdDI5oC3dkAr2ubTu2jLKcK8disKmLYKRqQQNA+lJ1+DVfw7UzNb5ECQ+/sl9Soh3ftUyymbUUhJGCuifOhPsIfpfB5+MgyrlzaFtD
 SQC0764Z
 EndK6uqOMLxX3CFAuN/gKGRuOqJ5UVipmPD8IYWTcvuKHvtZ9DzL+B+NbQw6smuNazJMJEqtwQNVZnkEg6WV5MB+NPFckvSbUu7F8oXGl8NL2wXTvvaCio9M6m+nuY08YBx8U6wNXrJSN9zWRBiYKwYjnY8dpGCKM6I3UFUwIWkaq5xEuU32OJcJrijZUHOjwYyLCwqA/ciZUSqgfjzu6PsW4Ew6ITVKHmzQC+rbH9ApxR18ThaWJIJq6QgsA4LMjlGyPA4ojWDkRhqd+onFDjalsVCRoEJYtTLOURZmfUQX04BHLkThpylsVCVrL4i1OLtQs4oWQLtw4uYU5pm5tsBSVLJ6rp6regndf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/21/25 10:35, Li Wang wrote:
> David Hildenbrand (Red Hat) <david@kernel.org> wrote:
> 
>> On 12/21/25 09:58, Li Wang wrote:
>>> The hugetlb cgroup usage wait loops in charge_reserved_hugetlb.sh were
>>> unbounded and could hang forever if the expected cgroup file value never
>>> appears (e.g. due to bugs, timing issues, or unexpected behavior).
>>
>> Did you actually hit that in practice? Just wondering.
> 
> Yes.
> 
> On an aarch64 64k setup with 512MB hugepages, the test failed earlier
> (hugetlbfs got mounted with an effective size of 0 due to size=256M), so
> write_to_hugetlbfs couldn’t allocate the expected pages. After that, the
> script’s wait loops never observed the target value, so they spun forever.

Okay, so essentially what you fix in patch #3, correct?

It might make sense to reorder #2 and #3, and likely current #3 should 
get a Fixes: tag.

Then you can just briefly describe here that this was previously hit due 
to other tests issues. Although I wonder how much value this patch here 
as after #3 is in. But it looks like a cleanup and the timeout of 60s 
sounds reasonable.

I know the reservation of hugetlb folios can take a rather long time in 
some environments, though.

-- 
Cheers

David

