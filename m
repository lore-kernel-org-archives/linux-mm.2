Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D57C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A23E6B0088; Wed, 16 Sep 2026 09:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02BEF6B008C; Wed, 16 Sep 2026 09:28:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0DBA6B0095; Wed, 16 Sep 2026 09:28:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8ECD6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:28:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 07CA9406F6
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:28:12 +0000 (UTC)
X-FDA: 85219704024.16.448AF03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2CAFB180018
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:28:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rd3UjnUT;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789565290;
	b=VkSbk8XA9uiRYFF3ylzAtM1myhYymnnilpVEm3S2oZI4vPpLIBBvFH6Qk6763e7ey+WdhL
	oBJ4X7CWhr+uMwrzZVGTxvQfXdSNgxLIFIPe0eMRdwvIIpZSDTd0xPR9fcevb6c8CEAOG1
	yGrFogytisHtUvyu6KfCthX2KYOcJ+E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rd3UjnUT;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789565290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5j6rnx+mCo8gZ3esGUeGF9jFOvp+62a04sJQH5jFRdk=;
	b=K+ZIE/z6M5Od7Xn097FyPBny7I+Eb0F3EZ1q1c8selXhg6GgKWUY4OUqRkp/+t5GaDicrP
	9M+G1SMvXpUQXHJuzzVr6TlMxTZszw9YNKpbhAx2yIc9wThfUZXIYs00xE37M6Dp4KExqX
	kXEVNzVwy+UC0+PXXRhG916FHKLO5pc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3761C416B3;
	Wed, 16 Sep 2026 13:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45701F000FF;
	Wed, 16 Sep 2026 13:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789565289;
	bh=5j6rnx+mCo8gZ3esGUeGF9jFOvp+62a04sJQH5jFRdk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Rd3UjnUTcvpqRiaaowqjEmO3ozv8vavlwqVS5OfoAf8TapeUXK0yvEM0CrFG92Zdd
	 TFTdyD8mvwM6jFpN4Vnu4C8eaav3iumlt7jzB35F0bwihU6EG4vLoPnAkIAQIrdkIW
	 zNWQcRLFo25SSjf5fkZVBGVFCGQwPhc53AdpvCAXn2uGoOJSCLCM/plU3r5bxXysiS
	 ohAV4KTlEStwISQMdEVQtutcphPSzETZDeavREp9kkBAwJuiYnvJHVLKIsAb/k2ALw
	 83ucoZOzANwOa/7u0qmGFh01siZWiahoSm5hvkwKHLNpeKZWscncwflvEyEmeVZiSC
	 ki41kZ3naXcqQ==
Message-ID: <36480c86-fc59-4387-91a4-cad839f502f2@kernel.org>
Date: Wed, 16 Sep 2026 15:28:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
To: Michal Hocko <mhocko@suse.com>
Cc: Kyle Meyer <kyle.meyer@hpe.com>, akpm@linux-foundation.org,
 corbet@lwn.net, linmiaohe@huawei.com, shuah@kernel.org, tony.luck@intel.com,
 jane.chu@oracle.com, jiaqiyan@google.com, Liam.Howlett@oracle.com,
 bp@alien8.de, hannes@cmpxchg.org, jack@suse.cz, joel.granados@kernel.org,
 laoar.shao@gmail.com, lorenzo.stoakes@oracle.com, mclapinski@google.com,
 nao.horiguchi@gmail.com, osalvador@suse.de, rafael.j.wysocki@intel.com,
 rppt@kernel.org, russ.anderson@hpe.com, shawn.fan@intel.com,
 surenb@google.com, vbabka@suse.cz, linux-acpi@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <aqiIEkrc6aDBOqRg@hpe.com> <aqkCbgHmMGxI_GLG@tiehlicka>
 <aqmGd0GGUCkbZpkZ@hpe.com> <aqpYxAktjexhaMGc@tiehlicka>
 <ad36cd54-7319-4bb4-bf8f-9fcc7b009158@kernel.org>
 <aqqXbwglwYTyTuUG@tiehlicka>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqqXbwglwYTyTuUG@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2CAFB180018
X-Stat-Signature: dzprpywd9p74gue9bbu5qirrz4nwq7j9
X-HE-Tag: 1789565289-658009
X-HE-Meta: U2FsdGVkX1//7eR/UnyMkajnsJ+0cza+QBd7zMzkndK8tM7c5QV4WO5eG+lwkTvp7dO5gPRQ+PVPYVmqO3+K0sYCRTUX9K8SnjVca42kxyiE7mf+zk+OAr4DgOkFj/AQCEXNKWBsQ6w+Buqm+VsGI077/XW0ft0msntDFA4AeFA6ZYJz8bUdaX5fchBF3/tkDB9FUHGGJhy8XbZmwEBHRckrcXnl3womopcZuVNyU0WjpOa5OvsT39D2tJOXo/D8WC4pwW1xoFUQdbw6nusgzAug2MjTkGKBxvG9R8drx+zIDtU1qOuSnFlvZ3BXhMoxeKLdBO16e6iXA+L1ATXwG8HcrnYtKVZT6+0WyseY5XoY8Z7KMpclvBjcJ4kKtrxgx8SsbvkhKNKlbdHwDICmHqcEXII3RzwqtCssd2qeKogX6POEt2+T9laJq8diwGuzSUbhuLisKa2JyqsEn2ShjCA68YrODdJtmTdH6xfLAs0MBzK1HWWFQ4rhHaQXxDYc0dXC+8mm0LT70oexGIS8cA+uzX2SrKA/I6skap4AjN/EOv5jpVyfOogF+eLAi+I7q/iTxm0iOc07/BjN8/VJx8j1AibTVd/dlAyhH4XKEHnD1P11YMNme/WVgAs1zeNdPKwH5dLfkTvYwimjRW7gWYF7ImvzZkj+TxuQ7VNCl44WLJq58LnFw9/lV172uFVlMmia+51ZY7EV1g8gEzTY6rGO1vLa7yLTmFfPJP+X8uGrfUv0JWfxAq795WzeqqXiNMSwhefPX7NzgMUTUSB7d7+F9jXop5slI++o6zWxH07RIPdZJ3yvwdAt0MyVnFl9ur7NT0WzVQ6aArz0jkGY1uKs4z1jUwrhI+QP6YgJiLptwRkt7xFkxEbPBcjv5NuSbLsbf7pZ20YN4hveyfAYqtDVaWsash0UJOouDldP85GSZLUCcfLaeiGwiYMgh06LbHR5gzYdrz58lTD+2Df
 cF9JIlgN
 V9ds1bCgISIAY4T0Z4NhovVrh1H7N5DSKFtiO1I8L15tQI1DVcLQJwtv7ydUEh+wdtx3Pd+j/pIG2T6LuV+CP0kJyyF7v7qKjYcJF5J2xPeA65IbCbI1kQ4awFThKH8sR27UTks6UBFODlxB8/r7RsWxTy85j+VKUz6ecCEy0A+vrxOJEmTueyo+1BNgbQpdlN0dAyRZNNtlm862u7Gyg0dcv1qVIXLQhPZA5MP9AxryGuvlqjlfkW90ujqKB3KzowDpzuf1xxoWde2/mcyaY2bRNnJEom8I1Uz5Xg189sBVTuE90yWn/y5I5BjJLwlHSDx1PrwczxNcGka+bhSCZ4o/oxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 15:19, Michal Hocko wrote:
> On Wed 16-09-26 15:08:45, David Hildenbrand wrote:
>>
>>>
>>> OK, so apparently there are some BIOSes which abuse this feature to
>>> mimic a real HW poisoning. This doesn't change the overall picture
>>> though
>>
>> Is this really abusing? We know that a page is shaky and will likely go bad in
>> the future, For now it is still accessible. Trying to migrate off that page stop
>> using it right away sounds pretty logical to me.
> 
> Yes, no dispute on that. But we have HW poisoning for exactly that
> purpose, no?

Well, that tells you that the page content is effectively gone and should be
tried to be recovered / migrated away. Unless I am messing up terminology here.

-- 
Cheers,

David

