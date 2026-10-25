Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C95E3606A31E
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 11:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kXvSlVnD
Received: by kanga.kvack.org (Postfix)
	id F08B26B05B0; Sun, 25 Oct 2026 07:52:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE03B6B05B1; Sun, 25 Oct 2026 07:52:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6C76B05B2; Sun, 25 Oct 2026 07:52:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF6F16B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 07:52:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5372412011D
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 11:52:36 +0000 (UTC)
X-FDA: 85360986312.27.09AB75A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6737FC0005
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 11:52:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kXvSlVnD;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792929154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9CEWfORfntv8VkhsX5SGmYSPLl0+f9APEy3k75g3Ges=;
	b=ka3kx91phO9n98iD6zO/H6m+SHiNfqlIryONRGdstQg+PcXBaAYe2OoaMq/2gqBK8ooVNv
	FaqaISogPjkkqWhUKnvrmjwUYMiDmiHYYWPLQ3v7VdBW8O5+h746doQss6jUWjq5ggbaVH
	qOe97TALcw34VgGcMlIaJlH2e+uP5DE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792929154;
	b=z7nUc0cKZ4ugsqxJdMFlS0m0ffZ9erLYlbY6n3yZTYU/tJBtJdLfTCrgnE2FwDuD4okz42
	eTr0tSa0qstIm7tJefEsqHVkjXwo6ph0YHfZ7sRJpTmRutlFsswcsDRfr1HvwCaJT0XP0Z
	UGTRvQxR6VqZeYF/ce85DOgkZUb8wHE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kXvSlVnD;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B28A43832;
	Sun, 25 Oct 2026 11:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D311F01825;
	Sun, 25 Oct 2026 11:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792929153;
	bh=9CEWfORfntv8VkhsX5SGmYSPLl0+f9APEy3k75g3Ges=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kXvSlVnDH15cWbO+1dz7W4fA+T+ypLAoZ5VIau7XmbxS6feD3VAzBV1LffLw5p6nH
	 NQGjuMGAlXxYHVEuvpQ0vcRtODFwdjaIc0xgimwJ4L/8XTFRcIN9lwnrg0BoCXQTqk
	 386sgwGM/6HyI+6Tuz5K8dPrXes8XavbQRl9tpJKTcviHkxSJb1Knt8DPmVJw+J9zN
	 poVRvHhxtbzIXdvplQThOA+xbji8a5V3vMiF9TSUAjcLn8ogW4RhCHq9dwQuEuLFJE
	 oThSBPZwm4yzahMxKEfSeVBAu7ay/18ITsC084l18AwdnVqAfO7yH3ERFL3W36MsR7
	 HQiXEUK1N8C8g==
Message-ID: <78127b64-d4ba-4e72-87fd-28e26f989de9@kernel.org>
Date: Sun, 25 Oct 2026 11:56:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc/task_mmu: return -ENOTTY for unknown pagemap
 ioctls
To: Hengyu Liang <hengyul@cs.unc.edu>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, jannh@google.com,
 pfalcato@suse.de, usama.anjum@arm.com, avagin@gmail.com,
 mirq-linux@rere.qmqm.pl, arnd@arndb.de, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261023181300.3366487-1-hengyul@cs.unc.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20261023181300.3366487-1-hengyul@cs.unc.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6737FC0005
X-Stat-Signature: adh1r9rjp8hrtidnyu3ge1n4mq683jyo
X-Rspam-User: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792929154-341681
X-HE-Meta: U2FsdGVkX1/jPvSFr1ZublwezrqEYb+6RHTHRM1iEwfjgyffiXo6GyheNvsuk2QPPbGZe3CFb2WnbfRN/+Wdx1kHEkeNVEHtz9Xik3BspOR+FoMwXr6zwMvhyKbt1Zd9K2n9LHeqZmmJvbgpqwAuOEVNSIB5ZSSyoh2DH4DpBZ+OIajP80NXcwhV9Y1wPaSsWEz3ea2eMtRBmxFrCQhRHUzO+3OA5jLSoNi4fBZ6H1wS07JBVgGq0Uzj3DFbiSzv3wWvosbYvTpQLh9uEotxQs+dDGON4C9DNKYn3o3wMWxo/zCTBKybQQzhUrxd1KS593Zf7ryWgm8gIe2kQlzCgJQ2X6rI23eJh1roSoKh/DMvKqlvHpWDDAdZGzd2L5oUK5+vnseWJAMlGXJWAuZCzq1v5rj2y6KHhxwjhDMHYns9EShVWWpitu0s8OaCkMRgJlalozO6ypkiM1K3KjwbJkF08ExJPdagA7F25MTkiidl1wlgOiGMcRJTOpyqldxDMwIyIvyyLUFvigGvNZWRJIx+7dRFhyCkK0b1ZPm4jZpN5EPv4s1C/1jmUZSxfzw6X9IASyXFxoLVfXS/CUE46RBOyiMOl8dDyvWGYfiMWO8IzjyvUGQtDGKggitKTuzbjr/PhUN3ZVdKlk0CRfB7YqganXDuqgVSiVrWllaz0BDkRUofUJCMiViJ8SRRDGmzDDk1/4wJ3fg8UEi4YvWK4IEyn+5Yavu89jelwJbGsdcCU501Gw+76mLudIyWJfTUNdNRDlyzgImCSAePxkKlEMdGPnxFsseFFMOpS98oi8/rN0GWrcHjtfmsIwjBnQJQ271aXjpiYtCBkxqT7AqMFwo7wqHc9W8PDN1qlO0ouiqlempyd1CMvIvKLKj+cGo7Kl3iaszjNDYm14gYd9apcGuQ3/nKcwG6EcNHg9N+ChE6ZZGuhMTJpKNPfjl7TrgSYzbHlAt/zxn3qzmi8Lk
 LZzct6qv
 OyXsIj9CzjtiV2OIr+1dLagiFAUwC+NP4SR4lAF923kGt7gIaStZpx9COpN2P4ksE0y/3pxI2d6joL2L2xxWojHPnc6zM8w6cO4OFTCYcZfAz77wgWNq3KB9SJVd4553n79YwngoKCcTNJk7Kj7IuWzKFUE/y84UKz0gcpReGl789NHbPf1K8hOqg98M/Zc0peMT2Ja88NXtrxNqzXxJXG6HGNPiNs5/X8q6zlOICqJiJ1bZp/D0YrdzamQKBpEn0Z8AEJQGPjxNlxNxHUNu4EGXFmifZoKapeI24rA2A6j8dCbaeGGqBVSNM+Pbi94yEkDLkYVmf6+URwxQHN4ksyGm9zcmjFvVMdO6ziXpxpcLVMmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/23/26 20:13, Hengyu Liang wrote:
> Commit 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and
> optionally clear info about PTEs") made do_pagemap_cmd() the ioctl
> handler of /proc/<pid>/pagemap.
> 
> However, do_pagemap_cmd() returns -EINVAL for every command other than
> PAGEMAP_SCAN. Before that commit, pagemap had no ioctl handler, and
> the VFS returned -ENOTTY for these commands. As of now, they fail with
> EINVAL, so tcgetattr() and isatty() on pagemap report EINVAL instead
> of ENOTTY.
> 
> The issue can be reproduced with a simple C program:
> 
>     #include <fcntl.h>
>     #include <stdio.h>
>     #include <termios.h>
> 
>     int main(void)
>     {
>             struct termios t;
>             int fd = open("/proc/self/pagemap", O_RDONLY);
> 
>             if (tcgetattr(fd, &t) < 0)
>                     perror("tcgetattr");
>             return 0;
>     }
> 
> Before that commit, the result is:
> 
>     tcgetattr: Inappropriate ioctl for device
> 
> After that commit, the result is:
> 
>     tcgetattr: Invalid argument
> 
> This patch will return -ENOIOCTLCMD for unknown commands, as
> procfs_procmap_ioctl() in the same file does, so that the VFS turns it
> into -ENOTTY.
> 
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

