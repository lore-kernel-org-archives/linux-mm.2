Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45DA3FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB5BB6B0005; Tue, 28 Apr 2026 16:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66E26B008A; Tue, 28 Apr 2026 16:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97D536B008C; Tue, 28 Apr 2026 16:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8A26F6B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:19:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48A1AC1AAF
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:19:33 +0000 (UTC)
X-FDA: 84709079826.18.7CBC4E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 73628A000A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:19:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RKU1dYlg;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777407571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFWWZZ4C1Q1RUjZ/38+2YQhT6BL392qyCXTF+caCccM=;
	b=kiJUtWijimkYt0Z3k2gywfKtbH74uRoGFRVp4Hml1rsUQAO+gTnoViOTuavMjs0AuQUAf1
	A9JJ/i2hLWPuE0VL8Y3GDimLjsuMudFe2oWvZrDHxv/+bAy7qwzN0Gksvj9wv4DUMIWTZP
	+8Q+vpYMLT20y4xGCxIQYt/Smxw/YLQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RKU1dYlg;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777407571; a=rsa-sha256;
	cv=none;
	b=j4ujp8h34XoUaO70euHbeN+OsAb447fDwG6a0+dIDp+BHGfr5XSK+edaag35d5fQeONg5h
	eD8MFqn0vMyL5EcRpijhtl+NwxftejKfKrb4PgvtdJc3iYL07b5BmopVTNd8PAfIojcjc/
	R2C6r7IpuSvrpogsqvRPlN5473uQsIM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D0A2F61119;
	Tue, 28 Apr 2026 20:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C002FC2BCAF;
	Tue, 28 Apr 2026 20:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777407570;
	bh=kcnbse3BjF+BT+KxumCD1jdaME/u3TMy13eHTvsDQlg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RKU1dYlgBU82CoJq/FNbCLIs6Ou85063aqNpNlAtM2GDE4hEek++6HXCXxP2MQuha
	 mGZ2sQpEMq2yfcqBbr/4kfY/D5fAD0P4Mgqr3rNS0JyOB7k6qaaRUio0FTTZVjVLtU
	 ZDckc5TZWYAGsJ+62Bt5Nt07/TG+NYu1TKL1UFGK5gwtiw9TIs7i5CUfmIEaWfE+PN
	 32wgGPcQ7IMcsPTzveiZPkOUVZ99a/SyJeS7YTTxTo62K1zhmIYKHwJ7/HV4mqNqZu
	 Kv/KPEHMH7BW0bB4Yu4W4Tex2fRE4EyVnD8qWMcB3z1DtGBsBTqVA+crebScEiyDSr
	 WGzebGpd5zhHA==
Message-ID: <b4fad2c6-f2c1-484e-b6a1-97e763a39ba8@kernel.org>
Date: Tue, 28 Apr 2026 22:19:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] selftests/mm: khugepaged: initialize file contents via
 mmap
To: Zi Yan <ziy@nvidia.com>
Cc: Vineet Agarwal <agarwal.vineet2006@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, shuah@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260428133138.88802-1-agarwal.vineet2006@gmail.com>
 <583F8EE1-5C49-4250-A24B-0D73372E3864@nvidia.com>
 <95714cec-205e-4b56-b8ff-9afaf9408020@kernel.org>
 <0FA813EA-5EFA-482F-B8BF-FE65D4169C44@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0FA813EA-5EFA-482F-B8BF-FE65D4169C44@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 73628A000A
X-Stat-Signature: j4fy4gadfnfxzkcxjg8iwe8ij4d4e9d7
X-HE-Tag: 1777407571-645555
X-HE-Meta: U2FsdGVkX1/Jl0GZopRTG0B7FRJY1UNxQzimC+wcD6QK9n5YaJNZIfjsy5HT5qDk6vUWIeLsvJb58CHuxRFjUTg/iHH3jpTYwcy54GJs0Wsac5JaHO1ULg6D+HVUp5nRu+NG9BbfgluzSVpq+3vv5NIYiQK4Fl8a6rNSMOBACcVgghEAgvIniSKRjSJDSH1o7jKKhHe71lKybtuMsL5o5h4HMO4uRjb128weol1fDNdWH7h4waVFC29KGMuRoZjL/9y+HmQ68X4A/Ui4BWXepE3L09GZztp9d1CDSAvvYOowfj6BawgL3oNdzSlBoma30m8uWACVfk6k/AV6YcuTe5eqCzWq/qvUP9YsZuygNCa+A/gWrjy/AWPkR+aIDj2QzOf3Rrb+CtAVbHQLxtEh7RWbpI0V6qlXaxtgbPbAYfzJz5+2/U4wPRadHmhAJjMf8ECcgj3xkaCoo29TGTxSQweH5hysiMPrUuI0qtwjoUxPKMzUANtduWnhoZGy1rBpHqfUixGBeIpJM/TdO5YTu07jZFXS4AlipVZkD2dlIp/TxZHIAYUKZC+3fFkFYE1qsUBvm1dEhZPTvZxs7NEO0eqeW9FHk02+sBAx3dE52xR9BrNzYnmjXZJjRIbqzUj6u+M18AfsyTOypLDhWO4k9gOLyHkoXjIABhOK2Cc6j1Dz1+O0FeO/Bq/ZwwsmjK3GxXAWuCLCSWrL5mlBXyRXeUExyHk1YNt8lOi44xDyIhBe6icUCDjtiZgyVoeQln0ZWR5IPx9CpseycQwkSKuJ0A29FcZJyarjIfCxSnBHMogwzbRaelmCxWA4WEjVVGOVElZLdHtNbfneHaApuCqv54wkuJkXa7AWPO0gCS1lmdVUPunfKGEkbeuqfG5ebr7q9KjgZ8k1438A/da1LZiY4NLnPEf9aWS7OkOqUzIyty4Qb5BKXtUxlJE5hFf51zxA0lAaVhzPsm/VQl0uvTR
 Br8z8AWN
 LmN3aU3bQwjocpgvlUKCN4yF8zqmhkpJDcNSEOFieeA0EfL9RmHQTxUth2fWsu6MA5QP4PVhkRbfn94zLe1MpQorzmfT+ZGpq0ryoSny3w8M9vLSxdzdmjdBn2rg4IbChM7eR8oXkQnlobv6kADW4z/VQeoy7y4N99DEcoKD4fLL4GfmqoUUWiZK+nMvw7ysr0Vu71SKv+z2DYVKZs9eihpJ+HX+ypt7x+96vD0ekFDywlj7NCvj5nXliZqZn5uIVnO6fv7I1hvXeUDdei4sx9Aen3/akCv8+vASzWeL8I1TTNh8SEK04RYbBynHctEzP9S2j4RsPh+DswtA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 22:17, Zi Yan wrote:
> On 28 Apr 2026, at 16:07, David Hildenbrand (Arm) wrote:
> 
>> On 4/28/26 21:56, Zi Yan wrote:
>>>
>>>
>>> This patch breaks the khugepaged test for READ_ONLY_THP_FOR_FS.
>>>
>>> When I ran sudo ./khugepaged all:file ~/ on ext4,
>>>
>>> collapse_max_ptes_none (khugepaged:file) fails.
>>
>> madvise() still works? Is it maybe because of dirty folios? (but that should
>> also be the case on write ...)
> 
> I asked codex instead.
> 
> Basically, mmap(MMAP_SHARED) makes the written folio dirty and the folio
> survives the later drop_caches. Adding msync() fixes the issue.

But why doesn't the write() make the folios dirty? Or are we running into some
race condition where the old code just worked by chance?

-- 
Cheers,

David

