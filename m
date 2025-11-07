Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FE6FCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 09:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D7148E000D; Fri,  7 Nov 2025 04:27:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF1B8E0002; Fri,  7 Nov 2025 04:27:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EBA98E000D; Fri,  7 Nov 2025 04:27:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 403568E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 04:27:35 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B0031603D3
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:27:35 +0000 (UTC)
X-FDA: 84083283270.06.EACA5F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 56C824000B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:27:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L+KqY78U;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762507653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=prXotkjtMDp69DmOdwmX2oX6jOSVOhNWdQ+KOvPQzZI=;
	b=UFGXWsurCs6ZbYJxSf5jLs4l0pD2+i9VeWky6LNTZ0yNOkfguyVMrosGKAi57oJMB1T5WJ
	h0QYdRSKz0Rsa69tQ0NXUj/QyL2iThZLzS4ntsb4g/vzCTp3i983rsauO49mgpBQBtUtQn
	pgxuJbcG/HFFm7NjWDrcj346H7W81xs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L+KqY78U;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762507653; a=rsa-sha256;
	cv=none;
	b=dGMnNaT6+BXv4LUZ+iypgQlgfd9Q65CDqJTaHoWs3xD7EQXB4sMBZDGzsG6JaR9uSo1DFt
	CnItmqLEw7nHnwIQf79hN+f/Zfwn+CK/36KqK4zXsnjU+ZyspDf3dSn/afOWFSBIC4dEFj
	YO/2vZ7KS8BIbEtF+n9Udd9jBWPQQX4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C56E618FB;
	Fri,  7 Nov 2025 09:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B39C19423;
	Fri,  7 Nov 2025 09:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762507652;
	bh=XYsZOHDCQvqBnfIJG8n72IsqXz8wRu5FCAMH1Fh68L8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=L+KqY78U5Aw8o2oFDAC9jsuAfpaoekJrMt9UmrwJZZ0IuMSJpB5oih+tmojGWpYmF
	 CSW4agR0Ki5dfjyQqPpDDNMck6Po/SHEklb3UdtbBVN/tlwVIJutMAvTQk+T9sJ8Bk
	 5DmZXrEgpsQDNnlglx7teswqt1Lrh6fNpjMuRgfR2xrezYr4BnWuaJAiQXwWXvPAwz
	 0bdfriP8Lv8haXp3SVfdAw5w22/5H6c3cxo26kCeLzRYopHrypfnK9mE7QBYyPgX+j
	 I1wCfHzqQtDOcp+OFq09FHUFlOTk5+Kv5O/fuOryyYSxAdLqfqID3B45ME/ih4CU5z
	 bfcESEkKYBDQQ==
Message-ID: <6e07949b-d86f-46d8-a68c-9717cfb26084@kernel.org>
Date: Fri, 7 Nov 2025 10:27:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftest/mm: fix pointer comparison in mremap_test
To: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251106104917.39890-1-ankitkhushwaha.linux@gmail.com>
 <fc051006-5cb2-49e1-bb27-7839837439cd@kernel.org> <aQyOZ6eYng-IjxS_@fedora>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aQyOZ6eYng-IjxS_@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 56C824000B
X-Stat-Signature: da5etngyzkjzad4jb7p3u31kscewndrk
X-Rspam-User: 
X-HE-Tag: 1762507653-30258
X-HE-Meta: U2FsdGVkX1+RduMJDCfMqfy4iM5Q3yCc4hn/8RTeO+tn5qCbrMYujXPCKgTV3DKCDadcN2hqtLEhKDwMwSlq1E6HwiDrTgnCqn4D2h5hLnEHnMJfCf/yhodk0MpbxinFUUB+HO4v/iLkrpPMrSIJ3+mzcq2/5sgMHA4sPXeo6MP7FcseszKnGiWrtmGo/uh9Wkwp/4F5HurCvdN+x4DA3j30uf2Zt/uGQyFfThSoLoDWhuXN5Bfa+bm87BpVgOlXgeZitdrz2IyMa2YGg7kxhaSrDNgEFUolzX0foCRbIdaOxWDcqdhWjLbfJlmXZB7X63d3TdE3OgeyTds4KEsMy2UvUY+HwaShBxUi+doqV7GZDzkRjCvydbYDz8gL4KiIccV4p/oyqGwmddaUr0rRe9iZW9SpgjcTcmeVdgRbTbMbCkZvpa6v4mu7wlmgQzyj7yeuvSM5LzpWJDQVDJZD5jcLLh8/OxbGZeBeuKFwib4xMQ2t9WZLJXGPSlXub1tKmMqKVeCHhc/37vzdriDGydeOxzvdB+VM/Tt54oaC0p2Dg2Gqm9VEFffpdLoMYCL32w7geFIYrF/9CIJFVRFLxN7wFFFbrSeeuVLri3BVJQih2a5iKGyECfn5hmTvN/+20oiPWOSEJ7+j+OsTSQuf1asr3bM4lnuNMt5iWXNX0ZZzc2JsAkB3Jzreh2v2E3eJNxdZDBJHStIdnqcgwSwnpKvlloITf0ChWL9q7wKOzQD5ORRGumehORpeaeE8dIfOMBMGeywkxaYdDcyh69KjBQF9CjlmKImAlHH49ORhDw8vKfTDoRsk/gOyVI0j3XnL6wxP5Ppn5UJ+xiRMIb/8UMPqsryjepvacgXXc6N7XxYTiGKdoQzv2PoBMAt5HZB75Cl4yg3jyhZ6OHPs8/pHDSY5zJo5hFx+AWdDqDBhBtivD9gF4GyEGKrvhEGHAEgcw53FKl8TlwC/w7cS8Bi
 mXEJc3Yb
 IVcJ58sr+lHZ7bbkpVhPtO3/PHAExAzVFHdafgX13gVn1vvFhbhZVGSOXAwvUcaP7X5ukerb+1/Pvceww7CcCHKQoQC0OzR5iLqpTece9vUh2LQHd+65k+zNHtm1gyYgVsV9N0d+aEt47ijWz+d+kruUpX6oxGoAOXcf6DfrlwNJUi59ZdF1nz5k7ejAxMOd6VQFokv1B+l9oQOutkxGYyPBAuj0ExewQEb6ELKUZzIYbouRfruMtI58dKqUrvfXRBtTf9WOQK6sIWxCFKum8JUCNqproszHYzOLp1kApZ7mRIfX7rFI253lZ25StVNKV/Ly1zr+BkqzfU0ecaV0QKSqFOyk4JQX3hFlLnbqPWHjKmKJByHXddqGibYo3BUcbTwlka91R6a4OX5e3LI1ZaWqYLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.11.25 13:02, Ankit Khushwaha wrote:
> On Thu, Nov 06, 2025 at 12:18:57PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 06.11.25 11:49, Ankit Khushwaha wrote:
>>> Pointer arthemitic with 'void * addr' and 'unsigned long long dest_alignment'
>>> triggers following warning:
>>>
>>> mremap_test.c:1035:31: warning: pointer comparison always evaluates to
>>> false [-Wtautological-compare]
>>>    1035 |                 if (addr + c.dest_alignment < addr) {
>>>         |                                             ^
>>>
>>> typecasting 'addr' to 'unsigned long long' to fix pointer comparison.
>>
>> With which compiler are you seeing this?
> 
> Hi David,
> 
> clang version 20.1.8 (Fedora 20.1.8-4.fc42) raised this warning.
> 
> To reproduce:
> 	make -C tools/testing/selftests/mm CC=clang

Thanks, and thanks to Lorenzo for the details.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

