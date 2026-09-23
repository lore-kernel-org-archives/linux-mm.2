Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C6D6C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 03:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A78D6B0088; Tue, 22 Sep 2026 23:34:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158376B0092; Tue, 22 Sep 2026 23:34:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047006B0093; Tue, 22 Sep 2026 23:34:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D813E6B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:34:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 20A4740687
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:34:18 +0000 (UTC)
X-FDA: 85243608996.18.B0E480D
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3EB26100002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:34:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hGj3Y43v;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790134456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GhjGwmzaNfLYRhZvbNLwLfIrdRdgncHpniFjcnEOIBk=;
	b=Th83DZpJfVk3fpNpxruvRSV42ZD8U5y9Hewv7QE/+ufT09nK1PBJLkAK6CjAnavNUWjtkj
	H7sIXgM2vcGLPMTdjBi3GyCI5wNR3uiwUER+r6cOJ/quAxHTS1kW0hI5nN/9mmWbNhmDyR
	4+5Z1gJ7IIAwf3HeUWC1AciLBNrPbEY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hGj3Y43v;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790134456;
	b=71DuM2G4sVSosCB1mMbOTE7izCay7pyFJbc4S+pZWF2wyNDSN9Fz1dFaug7fRo7PNnyxmX
	0FdLY97TF5V+HwzusvXOcQWr+A0K9PGItMwGzfJhZkgGOQ3qu4+lnbbUWBGTXgzJ73/GRJ
	VYi9sPJa2qGWT9RGuKZhGa2YgCgOtwQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790134452; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GhjGwmzaNfLYRhZvbNLwLfIrdRdgncHpniFjcnEOIBk=;
	b=hGj3Y43vQQu1WuVS6UUybplW4ZTFjso5vSlQAUbU4GsEQin68gG6G5lz4BprkM/sI6tsaM96r4IfpYrX9rNlquInKenYLwvncD5QtRT7TYQfD4B0endMnp2a2nq61YnZf+jU0RKeVxL0Bn79Do+DDFCCKNZ6dqrrmU8umBh9sUg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XBVe.Yc_1790134450;
Received: from 30.74.144.107(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBVe.Yc_1790134450 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Sep 2026 11:34:10 +0800
Message-ID: <50603720-a8af-45dc-9219-3d942a8682c3@linux.alibaba.com>
Date: Wed, 23 Sep 2026 11:34:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] kselftest: mm: return fail when child test result
 is fail in khugepaged
To: Yeoreum Yun <yeoreum.yun@arm.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20260921-fix_khugepagd_fail-v2-0-3c2877beef61@arm.com>
 <20260921-fix_khugepagd_fail-v2-1-3c2877beef61@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260921-fix_khugepagd_fail-v2-1-3c2877beef61@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3EB26100002
X-Stat-Signature: 9n8gen7s8p9gaauifb4gxine6o9pgx8x
X-HE-Tag: 1790134454-415496
X-HE-Meta: U2FsdGVkX1+5ZHxcc+U3wR9a4UigMASYNbs+uexX4MpwKc7STcpEAtUfuTqvxc6J1kJt8pl5/fjJ2QQIa+uGNMH0qHseJieQoOWWQkipjDqJThP1ItDHzLUfROkM2czcbwFuDmBHSgcGY3/O6myllJ0DznTh0yNbXiPfQwfRwL88Ka1Uw8L18y6raFJwGp4XivmfhEDINHE3FpsOXQwHIwu85APZwyCzox10UFNBgF3oVWFnomuPFB0wiN/2Y04uHPxYIGYzEIhA83HTc/vmEmYtvkifNsygBbRXXXmV5aTWvgjT3O27SvNU8H8RvNkNi1LZ8pOG16vOqMlzAl1v8aMIuOZuTpm8pXc4xAzUloGp08zZaUnIBFCtPn8UCWU61e7aKXMjdUDkf9LE2qJvhmVz8rmZQtFmxJdUsx8mtWRxyvvQbcFRwqdQhfRNr9jP06KrepNPhBh/NLY44hzuBrOgVtM+EEXejDDSaHjTEYVdj2WkxOn5RSU1/PQkfjjjR1ShyUL6In+KWCbTlGKlVzxNr9gPFBExY2g7AWUxT62GokJhwlGehGKQp2SB/19CRuTK/Au/1UyI8eWO7Q7ab6IzOKsOOdMyNqwKq7GIYeFQA8qSRDal+sljg58UDErRHZfOkz2oJQuf9tuJfG9m/793oUn1k/jD/QiqMFhFEVEoERiHq24PXy1fbwK7BopsdsFLOnXfN/Ruy2JsmzNGP4oaHT/PoSrzwLNI1M49wT2WnoThQ8+CmZhjrb0thNFHiQ2nCB+FoRTTluoDV4RE17/Q+QuNRdlNlPc/AZZUMtdBNHBQObySNhXHhFTLoSOrCkcA+JsvYkAnim7pgEfQRgFhTubl7CNAgNJKHxaFCOe/thaesej1e/vCssBpP10QQcQ4qlH5Vflpo7O7dYVdd9stPO9YfFqaMyWS0v9CZFImnN8e3n8Rr09gZmEAS0t2wDrfSSrfcVz+5XsrDvy
 nGgMuNCm
 g+Pc8xOQK9LvBDDXH26l8Tq+oNDSjJ/tZU5JJVQ7/UgmHo75xVnuxtOUSCflCmeYNFK+9sEaBuSSakwmkwsxO0y5Ky/KZ66guZCEwL8Ve/dBQlHfAW0o123Uac/od76yMPq/tOYFBNnstR/CJQqptVleog0TMrELRpxCzV+hDtV7nQXzHaPvrYZNLpzJrMOwNhO87Vl2FrfbfNvVI4L5LJU9XMOuN63GcaCT97cyvHppVVsVskgFneWBGdyiyV7AwZnWk0ndJ4qPJovkYqKMoZoySoYMoQ19kcLaSSiGcxSZ8cgzvOdk5btbNCvkV6LG2FpM+X1+I/wlUNk0klFjN1jAoktM1f2qvnuu5y83W2dtaI9qcHXeKp2nO7Ba1jTdr6bkD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/21/26 6:35 PM, Yeoreum Yun wrote:
> Although the child process in collapse_fork*() or collapse_max_ptes_shared()
> reports `KSFT_FAIL`, the result is ignored because the test only checks
> whether the parent’s page was collapsed into a huge page.
> 
> As a result, the test is considered successful whenever the parent’s page
> is a huge page, even if the child test fails, as shown below:
> 
>    #
>    # Run test: collapse_max_ptes_shared (khugepaged:anon)
>    # Allocate huge page... OK
>    # Share huge page over fork()... OK
>    # Trigger CoW on page 1023 of 2048... OK
>    # Maybe collapse with max_ptes_shared exceeded.... OK
>    # Trigger CoW on page 1024 of 2048... Fail
>    Bail out! Unexpected huge page
>    # Planned tests != run tests (26 != 23)
>    # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0  // child failed.
>    # Check if parent still has huge page... OK              // parent hpage success
>    ok 24 collapse_max_ptes_shared                           // considered as success
>    ...
>    # Totals: pass:26 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> To address this, propagate the child’s failure and skip the subsequent
> check in the parent.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

