Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA133FF8873
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ED356B0005; Tue, 28 Apr 2026 16:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39DB66B008A; Tue, 28 Apr 2026 16:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B38D6B008C; Tue, 28 Apr 2026 16:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1AC256B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:07:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD5D31B8CA1
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:07:32 +0000 (UTC)
X-FDA: 84709049544.11.6C05EDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 240CDC000E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:07:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="k9/Dunt7";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777406851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2utE80mK5/wfcidAaIpmdLr81noNhGMmz1yfhQVit+Y=;
	b=KfBctmNVFlrpn6Kzl68Pe24glJf+NKmykFn1T5oI3A0GGzpvGxLL2GKoF9wqu8kt4u7wix
	/Co5/ubE2LZ0b9l48L8yBxBsF0LRmtw2Z8d7888BHCdjIV0fBjvtL+i82FdADJY1KBdZlT
	qXlivfjl+NHxaSTlcuKB1Vz2nml+IbU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="k9/Dunt7";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777406851; a=rsa-sha256;
	cv=none;
	b=XFRAZOv6/5c1Z0EE4oQz9MucHf8wGVWWjXDAc94WzLg+T+AQuFQQHjy5+Lxo74t4pZxYew
	XjkyhSzVffyGHG6tfx7AkR2av3+PooVhI74pr3zncHgWQvDmFXtSwfxcOBuw4y4qd97Uwr
	mk+/hBrTwWRSpzJWgmJ+HoHRv6HyNbE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 849916111B;
	Tue, 28 Apr 2026 20:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D551AC2BCB3;
	Tue, 28 Apr 2026 20:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777406850;
	bh=CpG2G0CkYYwtxDyS8y/mKZjk8hOvOMceUBlVzLtz0Aw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k9/Dunt7IXgUmC11DR58JuO5JNeGsdW7H6CzNQhXKBo7m9TGzwml19W1/eeeAOC3j
	 wMpOaH2RWxhmEphWdeFwkaGbdmlVn0qHHpObdAAWHSrva4hD5hfRXkSsrpWtYPIQwy
	 TvAr5O5Wr05OSSUnHqOI9+MCuU+aMtfGVG+yO9tbr1t5b2suMi7EbJDI4HZcLUViR5
	 pbfqyc500IYGtBavFZzaINSg7JzBA9v1WZRhSg/Q+ahhc203Fqush7Y0MaOug1e7eg
	 w6LrvZFOzN4VpKgHK347Ptzo5u3YSy+Pkc6hi6jCuMXyQ7CQiY3Ao4oEVTjijP/Zkg
	 KcUMBDjSfzINw==
Message-ID: <95714cec-205e-4b56-b8ff-9afaf9408020@kernel.org>
Date: Tue, 28 Apr 2026 22:07:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] selftests/mm: khugepaged: initialize file contents via
 mmap
To: Zi Yan <ziy@nvidia.com>, Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, shuah@kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260428133138.88802-1-agarwal.vineet2006@gmail.com>
 <583F8EE1-5C49-4250-A24B-0D73372E3864@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <583F8EE1-5C49-4250-A24B-0D73372E3864@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: t4wayfd4e5ext8t5t3s5431y91kdo1x5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 240CDC000E
X-Rspam-User: 
X-HE-Tag: 1777406850-366312
X-HE-Meta: U2FsdGVkX18nF2sitCITTTL2hXCrWpZZor6iVPyftlpTKwXoPDFNs6K/PiJNuvzMw5d4H3UzX30l4b82TpeGlT8XCZPbHtj/RsZpzheni/bHm66nNUxKN4f3XjqkonaCPCwZe+FjUNVrak/Ht8cC14nhSg38a/H851vtWQypIjpc3ZSYutb+oonWkAO/2YWOfaGKuhI15c8YYiqfuk9MSZkr1w8bDC6FP4e1G5qujBynQ1qFNuJibrJCdOCpNdBSHRaiKOISBAYfXmjSKX3EBoaqrlkjKvTYpsIMLwlhkQAFLC1udTrgLPHi0OrYzpbVeUqiK5je2Y81MPcozoO86XtxLYz90FMocKH4W0DuHtHVa/8vrfrzaD74x5hmpYwa3A0vNj9at0040jLg1Jooyqupu2G52BwWbZb3hZhBpn+9UYAEWQkG6opkXQFdzbJ+iCfZ0pNG4/dfpU2XBRui52Iti99chyUdmOPMt+gXrypOxl/lob1rLAFxv0tyHcEZSef7kuSayZ+Hjs8kp2KL8cfcl0OZNp8sKvy/qHuz0fQPzZCYM21aqYgjdnh3jh3NGsIqoBazHdR7ffsqZ+dEiVSQZvD11cQvkr8qhhCWKaIfUtwxV8Q19qWAOuIXKJC6+VuDJ9KcoPDn/uc22qedJFvZokniAcmS5k8fcvADc+WDGwVD0Oxw/lhksCg+FYzdKuB3DqnkjABWF++SoiUK1td2sViwak4QdCG+GX0H5Q4rEvnH+EEmprHnTDyNcnBKLJ1SULhOhIXw8Rn2WQHF6T7/qQvkZxorAYuQTMSqYclWQtx4qe8QaNHar6RsEoEHLreQbA8WgGZfkip6eCQFczRsQnLBeBDkvNza+NN5MNaVJD3CzsQAWDdhguRhFog0pE8UkuRV0ulKSPUvpDQ5ahLqqXIq3V73oBhS31xDmkSkumryA5XDxn2c5dmzM6nOPVL4rWC5TtUPNXjeXe+
 JbuMNjbl
 W3n4O97eMknqiZcggqs59kXyPJvMKOdYqjZEWpCQMu7/Fcc40g+/KuZwQD7xnFgnX98gtHnKGQDGd/i0zVe/Lwz7nZnFVumkkpioKdRyQ0CsRzn4GVZ6S8Ljitoc4K+1A+GcBRsWYE3QJ0KrHdMRVr0YzCaJWfu1snZMw/Tv7K3uKWib/+l9XkSlU0qzPNPMqMH5dL9ZOq6ssznGSj0WUc8xKFlFfphtj5QwHreQsJ7hdPwbWJxh1T6cVTYRRcai6iuYHxa0coYqKqlBab404PzUUS/E4DZ/+O7/91RAJ42+gDVQHmvj2/0q5ahnUdrRwIIAG99pNgJPBXmesTVNyaP56peI4HYKQqeQ8KDKHRLuFh5DkBeo80oxt/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 21:56, Zi Yan wrote:
> On 28 Apr 2026, at 9:31, Vineet Agarwal wrote:
> 
>> file_setup_area() currently allocates anonymous memory, fills it,
>> and writes it into the backing file used for collapse testing.
>>
>> Instead of copying data through write(), resize the file with
>> ftruncate(), map it directly with MAP_SHARED, and initialize the
>> mapped area in place.
>>
>> This simplifies the setup path and avoids the need for explicit
>> partial write handling.
>>
>> Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
>>
>> v3 -> v4:
>>   - Restore unrelated blank line removal
>>   - Restore original close()/munmap() ordering
>> ---
>>  tools/testing/selftests/mm/khugepaged.c | 14 ++++++++++++--
>>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> This patch breaks the khugepaged test for READ_ONLY_THP_FOR_FS.
> 
> When I ran sudo ./khugepaged all:file ~/ on ext4,
> 
> collapse_max_ptes_none (khugepaged:file) fails.

madvise() still works? Is it maybe because of dirty folios? (but that should
also be the case on write ...)

-- 
Cheers,

David

