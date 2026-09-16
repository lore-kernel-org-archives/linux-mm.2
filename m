Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B3FC982C4
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE016B0088; Wed, 16 Sep 2026 11:27:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95856B009E; Wed, 16 Sep 2026 11:27:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84B66B009F; Wed, 16 Sep 2026 11:27:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85EF16B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:27:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20CE914079D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:27:16 +0000 (UTC)
X-FDA: 85220004072.16.C677F27
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8315F80007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:27:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M147Y4WN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789572433;
	b=SOthbxOP8wSL6ntXpNV19hx8OH6Rs/xrHhresSTZ8Uf8bbh5ciGN7syYDA2A37KvJnt7z0
	4967HOAqZFbfibuyS6vpf9336AX8iT/oiKC1I0yn2/ArskeNrybU1kcdUdTk3xDfKBuriK
	+fB2fsYFFUP2MH91qmcGxKlWBwf0u7I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M147Y4WN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789572433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEp4ZnPbrejlMbShDfgZlS9JJ0BVmM1UYTzr+qTasEE=;
	b=w0gN0QxfFB+SMrB9Ux87We7bQa+jLZm9q5LMfw6ItqLSGM8ATWjZNHw8IZU0jQcQ960v2M
	ze2ZXYNMmpoOeEV1uCzr9sPOxBATgN20tfefvcT2wN20iSQ/JweiOprmhMcP+61Z4jbNav
	bqcxNP0DMX03AuEvTsPL6YLutGNGtGY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01BE860234;
	Wed, 16 Sep 2026 15:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396991F00898;
	Wed, 16 Sep 2026 15:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789572432;
	bh=pEp4ZnPbrejlMbShDfgZlS9JJ0BVmM1UYTzr+qTasEE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=M147Y4WNSRLQzLz095+KM8Q0tz8N4DxvBUKJ4Z1D6WyxX19+dYyjefg3rZGCnN3gC
	 jGZASvaW1D0vNi/vmu1kfxeuULgNODd29T16eicployzlDPWQjTOuf8Y83Uyfft1FU
	 iwQ5EiVCmg/SNdqMqQouOSxKothPEymGg24/WlS4SJ/A+2o37vS5Ie6Jjcaew79+bb
	 XNF9+5Ymfy9YJFIA4vsG4xWjagM5OLwQTgXChBKTZeeih7yNO+G5Ab5PryIjS+NUJf
	 D681IKJHKhNfiXD1M2t7sbtihOOg1W3nde2w4nRq09CPyo9FdA4UCJ5g4O8W66HbGa
	 Zfut5LYDRi49w==
Message-ID: <88807afb-06a6-46df-a936-ec2a56cb4319@kernel.org>
Date: Wed, 16 Sep 2026 17:27:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] selftests/mm: mark file-local symbols of
 pagemap_ioctl.c static
To: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, gourry@gourry.net
References: <20260908134117.84405-1-zenghui.yu@linux.dev>
 <20260908134315.84431-1-zenghui.yu@linux.dev>
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
In-Reply-To: <20260908134315.84431-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8315F80007
X-Stat-Signature: rmgu4t5juw94uzd7jjiq7bkszdhzwuw1
X-HE-Tag: 1789572433-874472
X-HE-Meta: U2FsdGVkX18ZfGFzt+vAIP7ICWcrALYIll5YZ6yHmRNslSXFakYG5IR7RM/AWvGJc1Iz/9+TMzzwpLftJdj+tPb3xC5UFBlUjChN7+4f0SA81oZW10bWkGC4q4lgQcoX6b/kZc9yID3LpmspxA7MENuBSkBdLDjzVu61q4btGIt84oXfZ53MCYnwxphsZyS/ro7Rgmg1ncHeY7ME1SlZc2zc0lqHNhABYM3OE1gC6K4ZU1BUqhgpiTKnwiEPemPS89YjUQwgqyYbxjCc39lrssTgzdV6Co72wZHJSXBl4M+u6jwc5pw3u2I27o2YN3OYAhu51xVtha9mLZQyTBP2IjOp41Ovc66WWE1B0zcw3hggZw48/1937SdSX8HlHVVE47KGm0UqZ36smvStL3jN0wWEDCQxuZzt4CBzjOja3J+vPi5mIW30AWDYpilBW14zLTTYzOy+0qKU6aGLXnS+mxh07IYApL/GDCyKDJlzOUk+pIZfU39+NWshAn3ukbVgjYiBSLylgHM5LuZC7yr6Z8uhmAyO0bPAFeDMC0g2Ui1kQQYB/6SPXuWOj5hWp/r34N999WdNzkcs948oHoVKvBZi4QMXl2O79096BmD1/gFdF4zGq6V8xwXaJuXElMfKJjVWAfC3M0EJMm+2jSjhGtgexrZqU3GuyUZxoq4vyJdIRSdtAE75EkCWeMTWmiI5xN3nZLZArghk55U0RAcpSKXlui1ZhZwdt3k/j9Za8P762f1QoVVclhXvkbfDXLr3biHMuDZVTxNSugJ260bxWJIQ1UMuaaplzbZE2AqnuOnLkoLIoUwJO5UEqP5JHsw1t1PcFH2GUC1sVb8nOEJwejXxBgyBlp/oT1S1AlksYyYZ/bt8NFjbzFGVuvYvw5Mmcywktlfw+2m+OdgCSwmadS8VLgmJLHzLQBGKJvD79SSwYp0aeAFnXokz5QF2Px8O3TfW8H5M8yHBjFogIEu
 5+NF0TW6
 FBfrTxSw7IXCh+IUrizXtoDARAOhSh4zRhEbvuDWH8mG03adAIJL5bVUION1weWDiYm+nvMip5DydREbr6etgO0dJnnX/tyav7VBGATx8zquwpdIpQn/thv25vCuMPY8f8VwADJOwu7rYgbtgcHB/31wEs/Iq/fjkBE6iFzQ8fkJ7nwsNPUngmuz0rUUl2xNJMgKiM7eZs7qijhroD7HYl+1MjU+z3VDlsQASxIBdLAdexp1JTE7b13WruXG3pKVR8hPOxNEn/GtpnO09GdO3D0druV6YMj2IrqO+64x/BYxurAMw2mrIhoFLBQX+uu/QYcJoNnrkHaIILGwIXSiUlJlfuTImafHpyMdfWXF7uje88LiqbugOZtUC0/FxwQbzFrQQ0hqTqruHYmg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 15:43, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> The file-scope variables (pagemap_fd, uffd, page_size, hpage_size and
> progname) and most functions of the pagemap_ioctl test are only used
> locally, but lack the static storage class.  Mark them static so that the
> compiler can catch accidental outer references.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
> ---

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

