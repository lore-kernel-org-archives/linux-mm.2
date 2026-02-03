Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 422D4E8B361
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 21:11:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5786B0005; Tue,  3 Feb 2026 16:11:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 863676B0088; Tue,  3 Feb 2026 16:11:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761EB6B0089; Tue,  3 Feb 2026 16:11:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 637276B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:11:58 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 197891A05F2
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 21:11:58 +0000 (UTC)
X-FDA: 84404392716.20.9DDD671
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf14.hostedemail.com (Postfix) with ESMTP id 542C5100008
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 21:11:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FR90jCiC;
	spf=pass (imf14.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770153116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjouYKeFgulSy3uVZCrduhB9hUSwqp8VNZQ44L/rPlc=;
	b=uxa28y15+COF8BaqdLq+qzW8ilsihC3tko89ufugWRMKeWt2KMhDzcXpAzTbq6dbFh+A9Z
	L518UyUGS4rNEybgmgKcITTYj6spaJPOy4swa0NDaVtEcbH/rYzu8TkORjeVisM3JUe6jo
	L2vr5Ozwn5PCPinDm3fiJSBc18kVmSw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FR90jCiC;
	spf=pass (imf14.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770153116; a=rsa-sha256;
	cv=none;
	b=aqAbV+VXQhjTapz6IANeKi+p6zmlrMVVTlWmwpbqW53R8c3L30pM6O1qJ3AP+hYI2QJHsI
	wnKbqNYoEQSgH7ilTpBk4WMbvz1dgexxy3i/uCLPB3uq06Lbz4rX9mRau9rjry3Mj9kKpx
	O5MdZ7JMrfI9Q01BumijxNhHF2mnPUU=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2b704f08e73so163141eec.1
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 13:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770153115; x=1770757915; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GjouYKeFgulSy3uVZCrduhB9hUSwqp8VNZQ44L/rPlc=;
        b=FR90jCiCbAY0eqMzFra4kBL8BgNgMiog8JR/MYMOAgQcgxxaIPm95cF1TmCjyoSwY6
         DLUWynxEoHjcUlLHr3fLd78kerm3UqB4qwQ6S2NBoi89NEad1iXvn5mZCaIeF2rWau5B
         5+Tchnkh8qtQZBTL5qXyAgwbo3kOydWEhPxBUXG0IRjH5SFaG0YwgAIzpYcM3ZvxpZHj
         YRN/WiWEkUdJXmSnp98GixzdJXVonAF5lqvphjExco+vqkF/JdawCtYnOS/1ly4zc2ZA
         OKOkIH8hd8WIIsPq9bnqoCt8Q837ieEoLX0OzHRH0aCT7TJ6gRCQc263Ehey9h72TC9d
         G2fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770153115; x=1770757915;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GjouYKeFgulSy3uVZCrduhB9hUSwqp8VNZQ44L/rPlc=;
        b=V6z8s7r0Sqc4F71vf/kJjHFBpv3a/lzEf4bxcS9Jv8vKTR17gxmYhmes2HbapTFrYf
         VlN8Sn6EcfOz+ggIlfD/sUXm4GRx4Dnychcv6dPM+nk/R2AhDV245SerWQU9n4diXqwz
         cWFlkxRqqKupOJoBWfgUfbLLwvNo+i+/4DeEFZefhmH4bzxrs396XRcaA60/fncBTqEs
         kjB45B7C0oJvHYsKSEAs/hVR7X57je7U1Ny6kyD7l9hfGYbzHp/hI22Jl/JmLggG857Z
         XXw8Zz+nSTuiAu4zJNv2uTbfzHZy2nEAbDjcrfhro/iacxqzopRsDDZosm1CuzYmt5ME
         7Juw==
X-Forwarded-Encrypted: i=1; AJvYcCUoxHiBEIXcKURPPUAqC/42ksNIXIgxcfokNBtWDFcE7nhHnWA+mNmVpJJ0btP5ZzgDeC5xngnftQ==@kvack.org
X-Gm-Message-State: AOJu0YwgMrl3cUEsvDDEmI1BvCmtaYkyfmkWlW31BGWxhDCnlzok8RgM
	ymy3tX/4F+1CZtkJLX0Y8DbhIEjQWotdgnqbAclIznS6JB3JXFMVOt3n
X-Gm-Gg: AZuq6aILmpEY5DzvhkHj6yR2FWgt439wXN4/WN3yuUr/GY3SrIqeLcrAtQw23iQ7RsH
	8abxi9Q1crnhgXJbzszNLKoIPe1ucl8r/S80JkJB4fx5hWry4418La5s7MQOlYS/IouBMcCfqZO
	n2CpeIEFxKK9TWyX40/OnrtoWiBXzjRNC8zm0GT/PM1aQIRNlI3sbb75zQXm2VeYswiPfDn6msV
	EvXbxaOXPGyUTHxjs/SyTH6xSHXpZygl2m1czZTscrfWeLSaO+Zx8EQuiyx45ig50hyfbdJ/Z/q
	XGpPnRhJpul1QfokdPuPsRgfK4JyhcQn51z7khYYVSEN2eBrvUzK9RpYg1yqhJhyrx8mzzJkxpW
	r0Uo45FixawC43QB67fU5B/dgpTXxrc0zDqjfIMdt69GjW9He8ysbZrznwUj/eD+JzKqcwr49Pz
	qDmEc+gmDLps/a+cdo5PnuFcdd+2aAfquKFvdBL3i93dJEtHJBuCDkmpT0/baBLTI=
X-Received: by 2002:a05:7301:e8e:b0:2af:f2c2:3bdb with SMTP id 5a478bee46e88-2b820dd8980mr1904350eec.2.1770153114986;
        Tue, 03 Feb 2026 13:11:54 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1151:15:1cc5:26fe:6b00:bcef? ([2620:10d:c090:500::21b0])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b832fafc2fsm379363eec.24.2026.02.03.13.11.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Feb 2026 13:11:54 -0800 (PST)
Message-ID: <d89bb495-92ad-48bd-8cb1-c9f75de9af4a@gmail.com>
Date: Tue, 3 Feb 2026 13:11:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
To: "David Hildenbrand (arm)" <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: ziy@nvidia.com, Andrew Morton <akpm@linux-foundation.org>,
 lorenzo.stoakes@oracle.com, linux-mm@kvack.org, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <aYAhRjI2xNdtdvWY@casper.infradead.org>
 <7d6f5fd3-9652-4e9d-89af-e81ce20df8ba@kernel.org>
Content-Language: en-GB
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <7d6f5fd3-9652-4e9d-89af-e81ce20df8ba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yubg4g3rmfwmuoxq3cdqaqa6wqg6udii
X-Rspamd-Queue-Id: 542C5100008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770153116-817803
X-HE-Meta: U2FsdGVkX18I7xaHmSWgoZR/uzNE8xohfcaj/VJuCF/8qckigHMPOf0cm9/jLQTTO5tlqCunU3LHoweLuEGxA02u4GjYJ6+NlQ5OlJGC8vYtcrTpoXmHkCxLdYEvALPe9j+veBLrZtGt7Vb0fdsdPW40TkXUoTpQMj45kVy4BTqe02qjxJXpGvHWLW+NWCbdI+bO4ekWE/yALZ99Ew/PGAilIhxSN+O6x1898YnrgJdnA6a0kvbFMCOQa+NIYVlMETGqobosxjKJiFkrsBSjhxxEM8YUNShwID1I7IBVcEh++3yswEqceiLmw96vtFW/u7yxDRsTIoVPpB1ijhpGEhEj3kjVKbq83EN/jceMfqHBRCPvmfxuM2gpS6iWuvI8gc6uC5YtZNQVj/bx0hIX2eG0dZgzmjwfcj6+eui5MJYbv8yAcLqc1/M4gf5Y+pFc+S18RX8xfvh/woYVlskmq4ZIkqIt5fnc2sOJQ2TRJ85IYtbjUB9s6ut1Qn/Jf5UNgM+/VrCqZioYbUgNJtCLE8fgNWtjbR2Jnv3yxI6Y4d9Cm4Q1XE5TbvSiuJLTQM6acdA8ycQjOIZQ6AKXbuZ30C3Rdmz2ZDwqpoVek+uGWnnI8K5pwBbxYg7lTpBiPICpQwfFidIEBBp3PGhp7bViIWtt22AMqxU+aP85OgT3Xm0AopicGe5sHLM6sESWdaTV2pB9xLvaIgGn+v0gOtE8umQ4xpthyn3nhlAGzlFSxo7s9ql3VQdvTpyagPqRIbbcCQmtcJFu0m9vAzd7s/3jpBe+ZxiqxrD+1pFWbfYWiFAZmg/hRJELK0cn3zad1wv833oVYkzBMsF+cobxOxRviBQDl2uN0/1hQ10RTAkNLUrUvWCM540txR+tDrrK23MwGi9LX9SIDWzHMiA3sJpkB5HcaG38z3yUGl8d9v/dTunGMEG8goBKgePgCakmEusbn1NlgpEOb72fB5Oa3Nc
 AYj6I7jv
 kV0I5ZyPoryjG2aDvC7OSLtWbLgOl79+Ucf0Cey/Dirn4LHF9bjjIdRa+Dg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/02/2026 01:06, David Hildenbrand (arm) wrote:
> On 2/2/26 05:00, Matthew Wilcox wrote:
>> On Sun, Feb 01, 2026 at 04:50:17PM -0800, Usama Arif wrote:
>>> This is an RFC series to implement 1GB PUD-level THPs, allowing
>>> applications to benefit from reduced TLB pressure without requiring
>>> hugetlbfs. The patches are based on top of
>>> f9b74c13b773b7c7e4920d7bc214ea3d5f37b422 from mm-stable (6.19-rc6).
>>
>> I suggest this has not had enough testing.  There are dozens of places
>> in the MM which assume that if a folio is at leaast PMD size then it is
>> exactly PMD size.  Everywhere that calls folio_test_pmd_mappable() needs
>> to be audited to make sure that it will work properly if the folio is
>> larger than PMD size.
> 
> I think the hack (ehm trick) in this patch set is to do it just like dax PUDs: only map through a PUD or through PTEs, not through PMDs.
> 
> That also avoids dealing with mapcounts until I sorted that out.
> 


Hello!

Thanks for the review! So its as David said, currently for PUD THP case, we
won't run into those paths.
PUD is split via TTU_SPLIT_HUGE_PUD which calls __split_huge_pud_locked().
This splits PUD to PTE directly (not PMD), so we never have a PUD folio
going through do_set_pmd(). The anonymous fault path uses
do_huge_pud_anonymous_page() so we won't go to finish_fault()

When I started working on this, I was really hoping that we could split PUDs to PMDs,
but very quickly realised thats a separate and much more complicated mapcount problem
(which is probably why David is dealing with it as he mentioned in the reply :P)
and should not be dealt with in this series.

In terms of more testing, I would definitely like to add more.
I have added selftests for allocation, memory integrity, fork, partial munmap, mprotect,
reclaim and migration, and am running them with DEBUG_VM to make sure we dont get the VM
bugs/warnings, but I am sure I am missing paths. I will try to think of more
but please let me know if there are more cases we can come up with.





