Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21758E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 09:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 845CC6B008C; Sun, 21 Dec 2025 04:01:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F42A6B0098; Sun, 21 Dec 2025 04:01:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72AAE6B009F; Sun, 21 Dec 2025 04:01:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5EDEF6B008C
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:01:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2AB3313BBE3
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:01:11 +0000 (UTC)
X-FDA: 84242883942.22.7D20AD8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7D818140003
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:01:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SPUnUVwX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766307669; a=rsa-sha256;
	cv=none;
	b=gia2hLUT36tRh0DL6xF3mloYlHF7B+n4G+GC7BrihX1Kl3VB0XD3GXZlj7H6C2XfWVkN+W
	XBGHbiVjm6CeMaOwm18VOoHrkls5K4ll1len6jF3cc9cY4Y0hhgT4YZKstdhAJkFag2xMY
	jWzd34C5qoicl4w/lc98MZJ4826B/Cc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SPUnUVwX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766307669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RuCDAIhPCM4P8cZiLAUFVOOgkURLOFj05HxE+Krbd8o=;
	b=lojytf1ce1o63/ZWS/gxlx7Rxc/Zca3/Zu7rO4iQ7UpiWGR4e9iPivvCO0HpaM2taYUzpK
	jWhKQTqear6Awr74p3sl4BYuioAJc+S2pfm6LEm4EZGtCxERTXeg9mrIoYjJ+Lfn5nHGYp
	Gb4w3JaUi7h9tw5DHGZ5M7YuLT3N6bU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AF35260052;
	Sun, 21 Dec 2025 09:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B278C4CEFB;
	Sun, 21 Dec 2025 09:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766307668;
	bh=H4zT5BMxyg2XWDEXjZIIYKZGybtJExTbNVzBDE+GsgI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SPUnUVwXeTyFjPn/Zt7TBk1aIPrsWIGwZafaKseveX/KK7wwBjHeJFEslqlIFVcez
	 K8z3vouojilitnf1ShJsmfRewFa4H9dK+tcyDfb7j3gCv40SgOXkZD2z6/gDBQ6zDo
	 1LDgnhaj1F+XR8yTjWPSiNkpR9Rd1j46lD33+J+gDSqNpsLmxbVNs26U30WGTVtK53
	 OYeNRP5VX+RF+ILOqBAbhBaKiZxyOKiHlBeBqMBUdNSYS22YeTj0AKeddbvccafVCj
	 EN3M6ELK1do2+Hyw60vOixi5yKeWBhboqM/P4mptGT5Lud20vQtkcRsNXXFN2xu0+n
	 fnIbNR8QqxDwQ==
Message-ID: <60b8a0da-7f82-41dc-9746-657d89e88b69@kernel.org>
Date: Sun, 21 Dec 2025 10:01:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] selftests/mm/write_to_hugetlbfs: parse -s as
 size_t
To: Li Wang <liwang@redhat.com>, akpm@linux-foundation.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Mark Brown <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Waiman Long <longman@redhat.com>
References: <20251221085810.3163919-1-liwang@redhat.com>
 <20251221085810.3163919-2-liwang@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251221085810.3163919-2-liwang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7D818140003
X-Stat-Signature: 6ziqdmoi4un1c6njoknqq9b1aynnurcs
X-Rspam-User: 
X-HE-Tag: 1766307669-451507
X-HE-Meta: U2FsdGVkX191VkQd+qjUQ3/Xa/OMUlJ0J8vESVKgwZvy8AM2Zbwad6aQ/EvdDwACtJOe/fjd0B2U5XoUFtuxP7mR2HaYSJUUGThUMl1hdHynPxzbjng74ezaz7K9sTxdjHl7MP6aERvMhfrclKu+E2GOSjAkwD6GJ52GRhp9YOxPf/YMk7FWycGlLHx0BVB89w2UAiU7SsfsmxaqfmggIS3j4OHKoPjZ2e1ah1T0nHUwADpVQmg/nUJEjwwwVA9V03XJ/PhExFFjlhfJXUARmVvXTSjTyL2WR0o4vDIKLIK6Zv5W4z/ZAxzQjg5lnuXs5CK3NDAxMbkTpjxUw8VUgiP5X3EXwvKRGS0ncCrj/QOmueSw1+WznVrUOqa87sdXQRUmM86zIcTtFj2FcK23JYWdMNbo2NxsSYWOYPCrq8Sv8i9sBwzTbpcWCIlmfO1EkucvkcyiwpuPpMuHYbWdn7RcSgtBr9OmCrAu5sycQb0PCTiQxnlIsCIclIUdRYEZbuFaAKJtUtCy14tcj6ZljabKuKMpyNk1ERtIbkdZE23V6f+GnfMDIdJND2UW37vL1NGlLhXJZQi36TcSKHHD6AQGwNXxsqtWPOGf2T3H9Oso4fTvC3XMfJTG38J1SzGYACHAwduEK8hoh1uuuu27ulOK7xAs7VLg2LDizwQeC5uJnmxov1C6F06IPnEW4BxhnBaQflZ2pkV1BptYbwlXYudZKX5CLTBYqJew3aOqdZHrYCHH76Jzi9CYcUnRowej2woH+7+BjXqI/0zlEbw8TitjhDoPiQ7xkIF6bS6/SdjXUsT9fRNI7VV+YoPZGAEeJ4SEvuOyi0iXo+ce4DmkVTWy4IYAniervXbR54dHGwYorNCXdPKt/1TzYZqFnZbUE+hlWiCsf+Yi5VSfMMaiNdyKJ3N6PjrtM5ML9OTWvDkziYir0q+nqWPSetQRinfAlm5RkX967SLyOkuSjmA
 gBp6+AqS
 bjYGe1MSPVOJxPk7QoQnhQ4fmkFXsAeAlju/8ovl2kZj3aIH3XDRnDCT/CZdM7jtNiAAlZUUNJ/FjMFse+appzfZC5cQv9aa8CS/FzGo9TfWQtkW0XcxrqI2j9hhtaC8OiuKK/Mn60CPp2kx4Xdn7FDOiBB9oaeJ9kOKPzvsvZxncAtHkJIbyFJZC/icqrJpoU0+MZeskj0o+gXJAUwCIL3umY2CbO0TAlaFeYXNQYmaFqay9RLuSRtpcK5shW8qdJS6DQPxpklo6C1fDpeJMHjbwQ2MmGNqtQ2yvzdjDVhyigOYIw9dn/Ep5YrokTn3kjpQgArt6Kfm+t1o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/21/25 09:58, Li Wang wrote:
> write_to_hugetlbfs currently parses the -s size argument with atoi()
> into an int. This silently accepts malformed input, cannot report overflow,
> and can truncate large sizes.
> 
> --- Error log ---
>   # uname -r
>   6.12.0-xxx.el10.aarch64+64k
> 
>   # ls /sys/kernel/mm/hugepages/hugepages-*
>   hugepages-16777216kB/  hugepages-2048kB/  hugepages-524288kB/
> 
>   #./charge_reserved_hugetlb.sh -cgroup-v2
>   # -----------------------------------------
>   ...
>   # nr hugepages = 10
>   # writing cgroup limit: 5368709120
>   # writing reseravation limit: 5368709120
>   ...
>   # Writing to this path: /mnt/huge/test
>   # Writing this size: -1610612736        <--------


I mean, whoever does that should not expect anything reasonable to 
happen with these selftests ... so I don't think Fixes: should be added.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

