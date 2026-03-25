Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0629C109C02F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:04:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50AD36B0092; Wed, 25 Mar 2026 11:04:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E27F6B0098; Wed, 25 Mar 2026 11:04:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8246B0099; Wed, 25 Mar 2026 11:04:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2C7A36B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:04:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCF061409BD
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:04:35 +0000 (UTC)
X-FDA: 84584906910.15.B279C23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id BD688140022
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:04:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r8UfF+Ps;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774451074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Veh1BfpIt/H7zLtOQan6MKyLMGl3Rn2T1Z3hAkNao4=;
	b=MKJcYItWJqTP7EyqqHTdGiqQbNgjLM58BElXwfuWxYjBVTYuFbJ6P52jHzuoJhaMRs0qzd
	e4Z1BdbJwXSSflZ9nHt3UAoBTxE+POMvzSL4U4UnR8N7YNeS/x9tpETSZ+FyNSHo8bVQjt
	hR/RFG1zdd8J/XIFmGC5XsPUR+z50aI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r8UfF+Ps;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774451074; a=rsa-sha256;
	cv=none;
	b=gGYll5P2gnjTQCw7klR9rlD+KDU/mlOxADhL0wdSh4VUMZCvGr9KuKGvwQu4YgP8sAWl+m
	R75E5stWPa6I6tiFzjVINqMRQoJMsv3UpNl8e7Nw31Hyj8oTz1rlSU6jkL8iAMACWzgTll
	YaQ0VjK5jcqXQ+mOodz0mzF0JpQqvKQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8913C43FD7;
	Wed, 25 Mar 2026 15:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7DBC4CEF7;
	Wed, 25 Mar 2026 15:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774451072;
	bh=i0ERc1OsUCkfB9lMfbeJ3a9BcadwOiGGVEUgGY3EN10=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=r8UfF+PscrBhC/lLVJISEiVsy7q+phLRbGO2IARZO232xtTxofwAIKpQFaa6DDYpq
	 tsr7mvXmqESrlViyrWp72p9lwUH/cPYnDjoySxxO7M0eFCavBU4SejpSJY92NOM9w3
	 ccvZ8Ow3Sp+RpXCw9DRwTAq/xnQlxpy0KMmN7DqqKi7lNbMzi0ZQmlMsb9XzEpA02Q
	 Nmy8XhTlZjYSyxF0TGbYB7sN5gnKn5rJR69/WUR7k9nlW6FtIuktk8tg35AJ88B29v
	 YM3tOpDfdgHldC08n4hWOGaHjlD4DAS3i5aLEX8nkgmUyug81OI1/0ZmkdRw8aT17I
	 9/chLEbG7foAA==
Message-ID: <218144c5-6f51-44c9-bd70-e171005d3606@kernel.org>
Date: Wed, 25 Mar 2026 16:04:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate: rename PAGE_ migration flags to FOLIO_
To: Zi Yan <ziy@nvidia.com>
Cc: "Garg, Shivank" <shivankg@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260324114720.864478-2-shivankg@amd.com>
 <54398FC0-2F68-410C-B9C4-2802810C119B@nvidia.com>
 <41cd005e-3702-4c67-8d32-0c09274194e9@amd.com>
 <cb383f3f-b74c-41a8-a77d-d00e93b7fe94@kernel.org>
 <f844a2ce-105e-4002-a106-b936ddd98a99@amd.com>
 <857B5E73-94AC-41B9-A3BE-953E59A5DB40@nvidia.com>
 <27b1b602-129f-4bc5-a553-386e8d1f5d90@kernel.org>
 <539EA481-9CA0-4B2A-B0B4-C254E34BA7EC@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <539EA481-9CA0-4B2A-B0B4-C254E34BA7EC@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BD688140022
X-Stat-Signature: ai31f5er1xyg98hg8nsp3yn6s67onmqj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774451073-693920
X-HE-Meta: U2FsdGVkX1/fdMtfc0fzUpPaoep2b1KpHWX5X8H2lt0SHb72WYAlYjxe00uWMqK/cnLKP4zzcCWGGeZzID0AqO/G2MYOaGpaGIkWxnrS53qiUqEU5UDiZOC4s23hS7fPZlaJgyRx9bNADJgj2xUrQXGVFIoEbk1pRwvrBSM177KYlS2mGd2x9yeQSXYoZOMQTfJspMF73oXjGuCBRaE6QX5ZbIu1obzh0rWrk4iMaDdGgkxAFhI9gfIUmS18fH5GfmWo754zVeuOShk1dCp8iIIK7PRUv4XTkp1kPWcoaDr0eC0c8Te++5BwC2zo2r1NwnnrR0rbrc3DUroZx6nLTwd87fheXYJ5dewEHynfibJ7gYTZK8uFO366kvOU4nW7TS7GHOj0KNQQNArTwFhZZ2ygLk+cWVm7QLY7i9fU5zu/FfE8/tWeDEV/rCleklXMRTuX0/i8D5Yjm+QcAbSqUEmSqarjDNmyW2gRWcPmYKpDUOG3H2Q45HanE8sS10sN83LWMs0xAoCljKoa793lDT16LAx2k1kLMqSs0alFB5+n5yYmZ7a0uKZ/edmsU2tSUaS1HHGiYyw4aGecd1CGe1QfeKVd+OhHZcthfW44gyvXBxTPRpkW2YtJAhUrnUgupq8JFHeB2F2+R8iVS5Eyz2dX7obkPnsxna4Ay19vYk8Hqw2pZ4LsyNfCzmkzDhqc1gs+W6X5nVr80wGDuv7xA9Bi4OeU3Z1flryctPXJmwaG0UglLjVg/9bYAQziId8ii/kLms7L29ec6gNUV+blgSPcDYkctNHJETyHdhIAGkBXd50txtJv0dOKQrC4UocF5Z1mv+4xjY2Zc94zQcQxOCgRpJkeHqksc5iwgN4rwuUaOOzerB3HQd4ULEXwqFZMsV7/pgAGvEd8eNIRwgMVmPOwrUMzDU3U4I0aC79dj9QriEty+UFTO5iO6YGAwSo7spuc3Z+HRrltRXJtfja
 qQKRbYoj
 XFR7dg7rnHY/xt+Ts7yVDJzfDgkPWYxv4CCihlMgyyyihQOFeZYCBzKLF6+Cxs1E3hOGBdrWo2pdfnvjcKJOi8X4bxuF+oBeFI5jvbaFf82P3iWWGrki7ayMw6WhKiv5uLfTtsurfHOXC+Gh48vEigpdDQTXyOwPLg8MMzC/j4lJ+VKgaa8SXhLq9j99HpgqOF1V1/QsCJD1/Qxix6f/CYkZHeWdEEdqZbgrt4HxdgiCVp2OZKdJ7O/YoOwiIQ+PgJdEBwIS3xJdMSSDK2DsAWSkF63yj7dNnCDrznrk5jnWI5ypqhcUVkjnZKW1/iSDu+aitxyoVhoMUTPCqzB6UCcSBZUcv8KvEi+kRvzsPtWXUB6VQtqLNFi4G7xqplHIW0AbO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 16:00, Zi Yan wrote:
> On 25 Mar 2026, at 10:53, David Hildenbrand (Arm) wrote:
> 
>> On 3/25/26 15:21, Zi Yan wrote:
>>>
>>>
>>> Hi David,
>>
>> Hi,
>>
>>>
>>> In terms of folio_change_private(), I did not think it is related to
>>> folio_{attach,detach}_private(), since the latter change folio refcount during
>>> the operation. If folio_change_private() is related to attach/detach,
>>> I imagine it would check folio refcount before touches ->private. But
>>> that is my interpretation.
>>
>> I mean, given that
>>
>> a) It's located in pagemap.h in between folio_attach_private() and
>> folio_detach_private()
>>
>> b) It clearly states that "The page must previously have had data
>> attached and the data must be detached before the folio will be freed."
>>
>> This is the wrong API to use?
>>
>> Sure, it sets folio->private but in different context.
>>
>> I can spot one user in mm/hugetlb.c, that likely also should not be
>> using this API, because there likely was no previous attach/detach.
>>
>>>
>>> BTW, do you know why we have set_page_private() but no folio_set_private()?
>>> I would suggest folio_set_private() if it exists.
>>
>> folio_set_private() sets ... PG_private. :)
>>
>> folio_test_private() checks PG_private and folio_get_private() returns
>> page->private.
>>
>> A cursed interface.
> 
> Oh man. folio_get_private() should be renamed to folio_get_private_data(),
> so that we can have folio_set_private_data().

Likely we should strive towards only using folio->private (and the API)
really for fs-private data (i.e., the pagemap.h interface), and add
proper custom members for all other use cases.

For page->private it's a different discussion (requires more work I
guess, because there are many more use cases.

-- 
Cheers,

David

