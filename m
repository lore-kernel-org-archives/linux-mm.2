Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22333606A881
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=TuxtysPG
Received: by kanga.kvack.org (Postfix)
	id 3AD666B06B3; Fri, 13 Nov 2026 07:59:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37EFD6B06B6; Fri, 13 Nov 2026 07:59:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BC0A6B06B8; Fri, 13 Nov 2026 07:59:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C7E56B06B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:59:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0516160394
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:59:24 +0000 (UTC)
X-FDA: 85430101848.27.EC42F2D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9E455A0005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:59:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TuxtysPG;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794574763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9o0QAn31EhODg5Xk6yf6VXd8Cb1/NtuAjQyDpQKKWc=;
	b=ILiHm4J61ZU2KhA5r3v1cQ16BKmk6OccYy8+X7WSXs/sqeqoKRB5oZwYmTkn5ufMigcjIx
	5ng56/lxzTFEFn9/X+P24d/1bQ5ruk0EegjE+LU9fACOXUphlQYBrKBdbqflpPntXqyFh5
	d8KXHQ7iGTHM69ZrJV7hdAEx+kEZvwU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TuxtysPG;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794574763;
	b=ytFKcDpQUImDzFGvX6+hp8nHxcQRjxqhzl65JvKzg/kB8B0RMEapUczaP2Li0CdvODC2hB
	Tv3cGmGHweqTQlutYEbciiOjWDZI5F9f2MDlawoFbzQxluDtJugCgOXAR0g2qIgYqAC4cu
	wVU/Sas3rPU2xJq+e0x5r3BFo5wPBzg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA0A81476;
	Fri, 13 Nov 2026 04:59:18 -0800 (PST)
Received: from [10.43.20.13] (unknown [10.43.20.13])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3EAC3F673;
	Fri, 13 Nov 2026 04:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794574761; bh=IA8HbrwIcSv7yszpiNKddpXBErCGjQg6blFLc6aN5Qs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TuxtysPGkHekTOZWakO1gsh0ZU6UXYkeHjTVMySBTC5bRkJpe89iJYfrTPPZBsPsP
	 RNfp6yInd9YavKXA4MaZUVcMvkkZZJkxd1I85hSj+EcPLh+OwTih1jHciCoqfVxaxp
	 PEP99UB64GxvcCTp4Xozo9TLGLjSplxdXdRAwpgg=
Message-ID: <827c5b0b-ec80-43bd-abdb-8fce4a8b1df9@arm.com>
Date: Fri, 13 Nov 2026 11:51:14 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: pkeys: wait for the child in become_child()
To: Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Carlos_L=C3=B3pez?=
 <clopez@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 dave.hansen@linux.intel.com, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 linux-kselftest@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Joey Gouly <joey.gouly@arm.com>, Hongfu Li <lihongfu@kylinos.cn>
References: <20261106164639.2959195-1-clopez@suse.de>
 <20261106135739.113e4b432ecb6e92f62e37d4@linux-foundation.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20261106135739.113e4b432ecb6e92f62e37d4@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9E455A0005
X-Stat-Signature: k6unj9qbbookbonur7kwbqic3cm3f6pd
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794574762-570255
X-HE-Meta: U2FsdGVkX19oS4VQtO9s2gzKMCCxPYRfjWOMasgSli3rgUG9pGFPCjzYoBltmbN69zFvPoWu24Mw/xILZYqbZdYvaVMlYITlhZAMs2FFrAUXngVmo7DbVfffOw8BUGgBdLP3lak6NRA4VHZz1OcZiu6+2pfOY70OvyzSlFpsTb4I1Fs7sqs7qxLfO6+Bgkk9tHAuE3IauuxpHrC0vGRok4xDOEF+x96xErfINrxZpNDalSNde+w6gzaXfV2KHgXIEO6AZwnZP8IGD4O5uyJGIdQIMKP2e8vukCSldpTt7T0QPhNXphpvSNv5fuLyrJXaewbuNeBJrFVCKQWYV7x3t2SC3b1Cs7J16sAfoGqI4dsJIDYx7Z6q7tkhOLYkhz5Byo523JDbSHE3YRhGkFu5ZyZknybcuLwFvu8z6P8EQc5j4ikczyUmSGnHJRtrB/DxTkEkAjVuJ75edfzrEO8Mbp/ymIhqryXyCeF1bpshaAIq4+y1UI35KlESfZX1RKvF15s9NZ4DL7URUM6jqN8tpL9IzuVkcj07wdj3aNoQ5BEwbc0NQBsqVQ49TTTmnr7P4jCri8HuiPA8G976bhPNnwx02FZ4Wzz09qEux/t101BSGrs52npXHUP8mIEwd7xldNgMpnyKfedKn/NXq87V6QVAG8KNhSxflRqMmoMeHETf69LzQncDBE1wU42phpAPX65qsVKgXPV/Fi1yk8mWHsZB64Yo8dLMhGDyLWhUfTVryDN402CBNF+7RNFpeUFiMthNPrO39EH0t/Q5uBjUVX6p/9chDX94S9wem9W4XwbmvfQm/hog2P7ROjHVnCqfVC0UZOOEd8+jKZ7Dqpt+1GZRbYycGO+2lLAOrt6w1MsGaG97qfCW3/QYOSOMBjkGzWM3Dr/v5TFEJtu7PDPj1aRyTGhXnn1xPPSH6c9WTuBCiF6JzF6Xp4z9H41xivVqZPXO1x3UAZHtjh9IAO4
 CBmWXmk0
 L+1oSzHdbf/JnvdHTp15StgFYsUSA+uHpkFkC+GPGlbPUB5120hNtSEmCQCcZfsJwMgg26Os2MEXBYBrvVLdGMIS4kxU4wYsOXll8cx3jCi3YzWHZWgnOWKK18Ge3MejtmerW8kLjbs3hJlrFBiw4M6PkIXEyGbWqt1Jv3+YpUl41uzdn9FYmPVV16c1xCQReWAi0zFtcvn9PLQiT1UEjC7VnToA2x5lx0RkmQxOwmZ+Vt4yLP3GEaCbcVEn4k1HTVa0x4CTTpn3wROzoXasvs6KKJqT/svxaSEVEPEonKz4mgoUBZBD6xPdFQCay2a8I7ofQhYuopCYxyoAwZDeCLgzCp7xMtM7ugYe7kpjf9yLPMRlS6Lu2j/2YxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 06/11/2026 22:57, Andrew Morton wrote:
> On Fri,  6 Nov 2026 17:46:39 +0100 Carlos López <clopez@suse.de> wrote:
>
>> become_child() forks during test_pkey_alloc_exhaust() and has the parent
>> exit, so that the remaining tests run in the child. However, the test
>> runner only waits for the original process, so it sees the test finish
>> early with a success status while the remaining tests keep running in
>> the background. Failures after the first fork are thus not reported in
>> the exit status, and the remaining tests overlap with the next selftest.
>>
>> Fix this by waiting for the child in the parent and exiting with its
>> status. A previous fix avoided waiting, arguing that the parents would
>> keep holding their resources [1]. Particularly, the parent keeps the
>> hugetlb reservation of its test memory, so the child runs out of hugetlb
>> pages after a few iterations. Avoid this by freeing the test memory
>> before waiting.
> Thanks.
>
>>  tools/testing/selftests/mm/protection_keys.c | 16 +++++++++++++---
> get_maintainer coverage of selftests is poor, alas.  So it's a good
> idea to poke around in the git-blame output to figure out who best to
> cc.  I added four new lucky duckies to this thread.

Thanks, looks sensible to me. These pkeys kselftests really rely on a
lot of (black) magic...

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

