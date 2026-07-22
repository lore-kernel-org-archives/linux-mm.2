Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44F55C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 09:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 296696B0096; Wed, 22 Jul 2026 05:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26DC46B0098; Wed, 22 Jul 2026 05:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184E86B0099; Wed, 22 Jul 2026 05:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D99376B0096
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:39:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F1471603EE
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:39:01 +0000 (UTC)
X-FDA: 85015913682.12.2AD8521
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 850BA40007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:38:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HP6LvHAv;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784713139;
	b=48HEv9MVp4APsqC/6qxsEA84hukgA8DQjQonwIMRd2iVOLawEZ8Dw6snLWSPAUwXSz+qqh
	BWXSBZtHCnE7wpk6nbsV1AXMzdLVCZYe5Xl1cC7b/lcJjDQ3jjeZMIlzlcBhLFakDwFeAH
	8rZyDjgSCbdZVu65rKogwFHCPP1i5bg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HP6LvHAv;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784713139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7RxK/cqkx5zm0zUzRBQlYHZ6HubdZwVeSlafhlZfSk=;
	b=QhyC7ey7dZu+f0sGz9xnTnocxs2tvZKQmSk+Sg/48nwvhXhMMxb7i1c4iz8f/k21oHOcuY
	DV1DFTz5KvmdWWrN299LJMEkG9I2rJK9wKIkyX4PhWny8NTHoYbSjZU2XP7BCKnTYXe4SS
	VHDZzDYhjshybwLy1R7+6BQU80okl1A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EBED460A70;
	Wed, 22 Jul 2026 09:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8E41F000E9;
	Wed, 22 Jul 2026 09:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784713138;
	bh=u7RxK/cqkx5zm0zUzRBQlYHZ6HubdZwVeSlafhlZfSk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HP6LvHAvJS+CRTPHxHaEK/B6aBFoCwy50MzG+4ziWAx9GMHTGQnpSVuj3O2e4I/TX
	 w4m8HZqvstuZS6NQ+IzKalQwQ7xIwiLOXJJ3cKT3ODI8aqg1nxIYPf0UY9iaEl/3fJ
	 WTrHn+usQVVngBz4nGKzCWxYoDWvFDfd95OCoypz07m2o9lFr42I15OIwq1EYBN+Fk
	 xzjEhD5a5yEB9BWVv4q51ZFWdw8t4PBZ91yoRlvC1m5xwpEnhpRVU7Sjpntg+SufRf
	 Btbja4VCgMZXY8Kd7SWRtdxFVe/fz8AhTHLpm/6dUnhexMxAwEZkPrstiqBYeLLTli
	 14yr3pp3vrFJw==
Message-ID: <aecdd315-1cbb-4e7a-8694-f9b85ac68d76@kernel.org>
Date: Wed, 22 Jul 2026 11:38:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] mm/page_alloc: introduce
 __free_prepared_contig_range() with fpi_t
Content-Language: en-US
To: Jiaqi Yan <jiaqiyan@google.com>, linmiaohe@huawei.com, ljs@kernel.org,
 ziy@nvidia.com
Cc: osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org,
 osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org,
 nao.horiguchi@gmail.com, david@kernel.org, william.roche@oracle.com,
 tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com,
 akpm@linux-foundation.org, muchun.song@linux.dev, liam@infradead.org,
 rientjes@google.com, duenwen@google.com, jthoughton@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 shuah@kernel.org, surenb@google.com, mhocko@suse.com,
 boudewijn@delta-utec.com
References: <20260705180714.3708947-1-jiaqiyan@google.com>
 <20260705180714.3708947-2-jiaqiyan@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260705180714.3708947-2-jiaqiyan@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 850BA40007
X-Stat-Signature: xg5sh97ibputxabwkxfidt9djswonnoe
X-Rspam-User: 
X-HE-Tag: 1784713139-713161
X-HE-Meta: U2FsdGVkX19dJ6u1cPFC72n1R2Tjol2wHN/O5/6R/pxhTFKB5XJo+4zEXO2cHmE7sBCjNi3KmV2kivHF/u4AJXRGl2Yl1Kz5zUWn+0SPYPmAsyqbWcMCaVb4aCrzA541dcSibWSDmzvjlCJ49SmSM0feBS3xvRhhXx4AlRzJLeeopCfnNzyLhDZX8GB5nimMvzqi3SmQ1T5ji3PjGTmpETwJ6wEEJmVcfZWh2tLrn4QCU8DrKFuIO+VJYL3jycGhsg++MRe8bCFmubmz/073srE1Xh7aGaxJs8wa2n19CfcWS+2gLZzxVxZA2BWvC2OshVTYj8glMGJTiQTeTdJ1STkY4O8dIT6DkhVHy64+Ncbm0lwC9Ly2CaJjz8Aner9YoC6pPWGlD+wA1i9wHG4Q2t0YS9z7i9dMdo/aNqeYzIprme2J78RYNGltJ+GSrM/lR/Z33XLSFmHFEW6DkrCwd9m4NrKf7amp+PDT2Wvvd47qMifva6yScO4puyiJ0yAT+NOIs4zprKAu/M25ZEzXTRNMOtFdZkxpXZLBNRoM3Aud3qX0BiCkkoz9vkBh5wbgVcyeaINJNxPfgRLjpXqwisoQVDp58kHUXqg3C5I+pYzFUyvjxoDREu/oRXWv4VO2HyHGzBYUFTvcf/ys1fWvk9t6zo1upFHcmu8Hm3vrF9s5wWU+Xt8uRskwjWfdZhxZ9rBIdGH4715uxPCcfkn6oSPwImnhAnOhccpusNaOq+6W3/RZ+E0+7TcTfjH8vR+8S1rkuLDdMFOnZw65Hq0IrEv5wYcDd0dJ7jjv+jsV20Z7+Fu6iVT8XYZaPvizhNaEuaNOKnM7DBF7MTFkMkyDaN94BXCZcLw5/GKeRiS2fV9RT46NoGOa53BCnxSsyxuxoDtCiiZ8AKO5smX2leLjQnC1wdw6177x6s1ScrdKaibCYrPUm00wey7cCXyeE7cnV7TwNWKC/gMritc8liS
 sc2qCEwt
 iHIc9FuN5qz8dADoHzJ5fOwYilnAV7P5Ldqnsbzib5DbUNGYe5ZH7NdEKNskwWxsToH48sKUqJjo2R0kFJH7hjw5Sh5/jx/mJrRicdMyxlvkZuhRZIIrnYBqxr5WeFilJP/JGQZluDIIQyYg1XS9V3x9qaQ/9WPv6R9Gr3SX9AzZdDuTY2Ou9WqeLES0iIkZRzPr/c9FcS4kF1mi7lEsiow3zcz9yhVaWVKMsO/9WebrVxQ83yr2fxffjnq7C9/AtejN4VQNIpSUPgX7qUmMNpqjiykKCeyOQkTGTZPjVwFfmLJTSmaSd9/55YHlo0AQwGvUGSYAsTQBPI/dIOgrzLcJY7EK8uBK/+HSWsHIyx/CyIpwoHT+vb8a508cz5qeMZQs8Db7hB9h7RFw49R6V6ZAW2YA20KvsGazf2NIcCEzCQXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/5/26 20:07, Jiaqi Yan wrote:
> A future commit introducing free_has_hwpoison() to be called within
> __free_pages_prepare() will need to pass specific fpi_t flags when
> freeing a contiguous range of pages. Currently,
> free_prepared_contig_range() hardcodes the FPI_PREPARED flag and
> does not accept any caller-provided flags.
> 
> Rename the core logic to __free_prepared_contig_range() to accept
> an fpi_t argument. It bitwise ORs with the required FPI_PREPARED
> flag.
> 
> This is a preparatory commit with no functional changes.
> 
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


