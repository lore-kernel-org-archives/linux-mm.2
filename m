Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E76CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 12:41:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70CBA8E0005; Fri, 26 Sep 2025 08:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BE388E0001; Fri, 26 Sep 2025 08:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D31A8E0005; Fri, 26 Sep 2025 08:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 49D088E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:41:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDCA211AA72
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:41:13 +0000 (UTC)
X-FDA: 83931361626.26.6BD59E0
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	by imf03.hostedemail.com (Postfix) with ESMTP id D40FC20009
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:41:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of zhr1502@sjtu.edu.cn designates 202.120.2.232 as permitted sender) smtp.mailfrom=zhr1502@sjtu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758890472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KtwijDnWeLaURebu0PF6d6AnAKiQIa3FOb/9y1gQBiE=;
	b=s9w8NYNNtL/VUBdypv9eVohQjJS9OeitO+YXcYI1XPtxz8QRgH9teJIQhAZ1QCAjN+f4p1
	Z727QvuwqLARivCGzpZ/7E7TbjbkVYvbSATBK/BQYCzBO1aGfV5UjBTc9+Oez1yeqBythk
	+rlo0PpeXDNwW/sSiV13h489SGY5+tA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of zhr1502@sjtu.edu.cn designates 202.120.2.232 as permitted sender) smtp.mailfrom=zhr1502@sjtu.edu.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758890472; a=rsa-sha256;
	cv=none;
	b=Lfywhw515nUldAoRpklCMRawRzhcvbzhDXcmHM8YZAu7Vl9aFsV7XhzwCQVOFb2epSAWCs
	W2FsHrZmzUA3vCeVO3jPJgsgbPOgO3b3O0fjdQi8Nm49zUMcftuxtnRiNqdOU39BPxe9P8
	yfLFT5v4F51tMycuc2yHp0w7XVGG+KA=
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id 05EE1124B5B46;
	Fri, 26 Sep 2025 20:41:08 +0800 (CST)
Received: from localhost.localdomain (unknown [10.181.220.127])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id D95B137C99C;
	Fri, 26 Sep 2025 20:41:07 +0800 (CST)
From: Zhu Haoran <zhr1502@sjtu.edu.cn>
To: dev.jain@arm.com
Cc: linux-mm@kvack.org,
	ying.huang@linux.alibaba.com,
	zhr1502@sjtu.edu.cn
Subject: Re: [Question] About memory.c: process_huge_page
Date: Fri, 26 Sep 2025 20:40:59 +0800
Message-ID: <20250926124059.26620-1-zhr1502@sjtu.edu.cn>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <731ea778-3a75-48ae-8281-4c280a379796@arm.com>
References: <731ea778-3a75-48ae-8281-4c280a379796@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 186u9oj7ne1t1jtmipoedh34mfrz1xd5
X-Rspam-User: 
X-Rspamd-Queue-Id: D40FC20009
X-Rspamd-Server: rspam04
X-HE-Tag: 1758890471-859045
X-HE-Meta: U2FsdGVkX18p9sWtEKI1hpfDulGihTQ0E8lle4wTaiNPGCfkpVfmQwPtYqciCwq5XBo6LP/yAko6yCkrexh7RSm5fQu0iAirtpu/6ofRI7efWfVJGklM7+ETECiZ31JiTgd9Xtx42tKlfP2KNtm00e4sLhdf1gFmmJEMAPyF2WRWG0h/x02b7Aw6KNoTBZeVBatujCJWqTHVBHKH56YbeUYkhlPUThwlV/vdXe30ctQCKDULLbQKpB9zjjRI0TcOif7dtCd0bEpIoqoPips8l5TEYJwqsyWAhgNU3lGgmE62Dh9ueDePo01hsvs/2ZK5LGCSjFriXacgec/xzhMJaykSTSeA2w5N9Nl/mlMJ1cuvxjUD7/xa5CW0asKxpdr2Dnc7q0P65gr15utWl6GSh5XjLuTB+J/T3eaEeXmgMEbBifCLxN3x8UE5P5FeYqoehfQO8KToNbz+J2pdLq3BXy3oBF0rJt0UswZjvPZlwpFN+Q4usneMALrbbbhIS2MCAfxRZzy4ZMFJlJJZqTnkrT+DKTLZ00rS1Cgg6NaemE4Ly7RZOU+qioMuGyWtueLchp8GiMaQhyxvH7G+eb1oz8Yt5HTSu3spCq+vrGSAxzHDug4enfag0C7ReZXomkdHr04zA+1ggdMP7yVVWLXQcJkZGfOo+C3OUZhPQOZslwoDJX4iGRGMh25jQZrH3/uWKuoqu4NEFWPck/i4AghpyM7HdR4HfELKcv3It5Ifz0r0apKKKXKNNtG+rZFt3ftC98sn5lJFfdqxI0QLMCAInNssOdofcOTDj8X+5k8t4gVukKzlH+n0UUdjsZz0ZwEgLr3EZ2pWhx2nW/6xxmZBVvjXwYNnYypurERyFHtJLpvake8L2fQCQ7BnOlgLuaEeFYLrT+wL8/q8vjP+B65LWfkSMnGmwqezRJPYnk4n1d4jVEzBs9fgfUAMbgVzzbtNwlpPn9zFiNRul9ugZbK
 TFloTPRe
 MMj+PTWZV2K0RQWldOlaEHwbaaUyY47EWqzt1Km2V7rAHNdUhu8m7seTyUpbkRzHTXSOOY/efrMj8yhlAbU+TRuWRScI7+My+A2IeS96zRYK9SCjhU6OmMppv/Matk5FGUPZRsNk7xIcz4a1bysv98MyaWvs5neLcuUc2lzuAkW79gD1Y80L45dmC41fEklCAxYeoKhcz02wpi8bgu3PVHYxF9I7/dwsskJ8mM7oS4K0/7Rc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dev Jain <dev.jain@arm.com> writes:
>On 25/09/25 7:02 am, Huang, Ying wrote:
>> Hi, Haoran,
>>
>> Zhu Haoran <zhr1502@sjtu.edu.cn> writes:
>>
>>> Hi!
>>>
>>> I recently noticed the process_huge_page function in memory.c, which was
>>> intended to keep the cache hotness of target page after processing. I compared
>>> the vm-scalability anon-cow-seq-hugetlb microbench using the default
>>> process_huge_page and sequential processing (code posted below).
>>>
>>> I ran test on epyc-7T83 with 36vCPUs and 64GB memory. Using default
>>> process_huge_page, the avg bandwidth is 1148 mb/s. However sequential
>>> processing yielded a better bandwidth of about 1255 mb/s and only
>>> one-third cache-miss rate compared with default one.
>>>
>>> The same test was run on epyc-9654 with 36vCPU and 64GB mem. The
>>> bandwidth result was similar but the difference was smaller: 1170mb/s
>>> for default and 1230 mb/s for sequential. Although we did find the cache
>>> miss rate here did the reverse, since the sequential processing seen 3
>>> times miss more than the default.
>>>
>>> These result seem really inconsitent with the what described in your
>>> patchset [1]. What factors might explain these behaviors?
>> One possible difference is cache topology.  Can you try to bind the test
>> process to the CPUs in one CCX (that is, share one LLC).  This make it
>> possible to hit the local cache.
>
>Hi, I just had a different question, why is the function sprinkled with
>cond_resched() in each loop, especially the last one in which we are calling
>it every iteration? I suppose one reason for slowdown may be this too.

However, whether it is process_huge_page or sequential processing, the
implementation always performs cond_resched before each process_subpage. Seems
no difference.

>> Thanks for your time.
>>
>> [1] https://lkml.org/lkml/2018/5/23/1072
>>
>> ---
>> Sincere,
>> Zhu Haoran
>>
>> ---
>>
>> static int process_huge_page(
>>          unsigned long addr_hint, unsigned int nr_pages,
>>          int (*process_subpage)(unsigned long addr, int idx, void *arg),
>>          void *arg)
>> {
>>      int i, ret;
>>      unsigned long addr = addr_hint &
>>          ~(((unsigned long)nr_pages << PAGE_SHIFT) - 1);
>>
>>      might_sleep();
>>      for (i = 0; i < nr_pages; i++) {
>>              cond_resched();
>>              ret = process_subpage(addr + i * PAGE_SIZE, i, arg);
>>              if (ret)
>>                      return ret;
>>      }
>>
>>      return 0;
>> }
> ---
> Best Regards,
> Huang, Ying

---
Sincere,
Zhu Haoran

