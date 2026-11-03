Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC959606A332
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fODI72Dy
Received: by kanga.kvack.org (Postfix)
	id F2D5B6B00EF; Tue,  3 Nov 2026 04:25:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDDC46B05B1; Tue,  3 Nov 2026 04:25:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3C26B05B2; Tue,  3 Nov 2026 04:25:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA10A6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:25:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 35FF61402E3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:25:10 +0000 (UTC)
X-FDA: 85393273980.08.D2140EC
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf13.hostedemail.com (Postfix) with ESMTP id D446F20006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:25:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fODI72Dy;
	spf=pass (imf13.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793697906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=znfwk2ucOi906Els7Tq5ow5yT3CmRKhld7c73Wmlhuc=;
	b=PGfTjipe2hhU/1SX3sPeNDm9062KVkngGG5m5spYKEYAQefTDKJ0+ay8v1qjWQfKX4tkhf
	yBV0mjsgiiYY/POt+zg8ZiV/hAR+dqLAeNlJRMBX04fK65vYsUAXXGkKZLuar5cKN7rsqe
	T2NqayMc+VwYvrmubkW5/VpFT7alAkI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793697906;
	b=hXd0RxU1Q902pJ210nUmCSbwHQiyR9wl/etffPlFKyfw9Bl0MxdzLxD949NrqLCw3MCT8k
	saF+ZJEi0orGBWYtSWo36x0t336GzEZq1aty2px3jHxN+54cNVbtR8qavE5bNEF6qjHk5A
	9ruHWpYxQBZ+ctNEruxhU2CvuqF4edA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fODI72Dy;
	spf=pass (imf13.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793697900; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=znfwk2ucOi906Els7Tq5ow5yT3CmRKhld7c73Wmlhuc=;
	b=fODI72DygpmSjgHBWzwp/if1nUPoZG4uIL3HWcDNEwO9NNzsNTQHAdrAJVjA4V3srsADcOrMg2YTRW9I8VksG8Ss6/q5t6Uf0ZnhLzeWSn+69oTI2LwkV625F9IozLSAmQW40Z5DBxsnHmB2PGFlNfE1QDQTF9I1C0FcCdKx9nA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=tongweilin@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XE2Mb2w_1793697898;
Received: from 30.74.132.52(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0XE2Mb2w_1793697898 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Nov 2026 17:24:59 +0800
Message-ID: <155615c2-2f2b-46e5-a3ab-a332657a4bfc@linux.alibaba.com>
Date: Tue, 3 Nov 2026 17:24:57 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/mm/thpmaps: handle carriage returns and non-UTF-8
 filenames
To: sashiko-reviews@lists.linux.dev, Andrew Morton
 <akpm@linux-foundation.org>, Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org
References: <20261101211644.c63a2028bbede0f763f41f80@linux-foundation.org>
 <20261102085419.696232-1-tongweilin@linux.alibaba.com>
 <sashiko-outbox-194896@kernel.org>
Content-Language: en-US
From: Weilin Tong <tongweilin@linux.alibaba.com>
In-Reply-To: <sashiko-outbox-194896@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D446F20006
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: q34wd8y3toy9raqd5fhnancpj87n15im
X-Rspam-User: 
X-HE-Tag: 1793697904-406745
X-HE-Meta: U2FsdGVkX1/jLa133gAiUaeJf2dNyMDQ4LhLN4zDXgb9C6dvM8mKY1ZKrXfC/1nNmVFYnirUz0eXS/+7oxJepg3FkBoWU/zMurJw6/7HIgARdebT03DNoF2O+aKRv2/jR53tZQkJQXSFFiOnfEqyicg5t1aU1pxuaNmt2YIEKwXRVIxVxy+t+hmk0HnM8mEKnzEj5li5a0Uhteqi6WqROZv9pOMlZUE5d3j9p4so7q9+Rhweon0JR9m4uCXA9yDSAZwJNZChEuKeSMvEPML1ef9eVK9mRXgx8NjEvhD+dMovzOyHOzuuZk4nrnOCG3x38OOd+mG0g6JAUt+3C8a33QxdAgTRH/EERGFZhmnC3WIrF3arfhoga2XsTxIKnbcRGtvyKqB4QnTpfMtdJn2CziFJBhq7/pbvesiLP6ZaUVt9Czjc/UH8uroeY6TR+ORR4e9vJfG6XG54A1H4WJf2ghBRHlJvfO9tl/ZWXGZJPnCtWAGU3j7/2SC8leswUEQunHmTqVlGI9ZYsQk6gNIriGTIxHxvP6iMei6wB2/Kswg0xdFMhOTj+Ii+/MAxnMWg0t2ZhglIXUPN1JffPXi7iiN9JRy1nkJbwp+0cH7datQBMOGR1C1WwQrVT6zRbcjwAT5FVtQhtdUz7iJDe3C8xGK+3GGtEXZcQLZnHyt8MH5e3OeVb8xlQA9TRWBfQz+PkvF7uyI0hUeoLKkSXrq/IJq62n2qqSv2ErGLOHvJ66mpSQL4dLjYUJ+MDm9oE/VDgYAND0ig4RO07gZj2RFxrdVR7jocQdz9CL0F/0AdYeK7SDTagxXZK1L0ZrVkZRa7YrpFYUMklegTwDZNZ4xCn+bZw+8Mt2dWc2tlFRNeZfA4sLvCCioSqPttR8qRiSqZe7oECzzw390LGsZt2qKN02QJiH8caVJIN/iWGwOiTIZh773L0BwVX+sMy1pkQuraizCJGi9uZuId5+poDAW
 xYdTocW9
 L85Y+V4breecjK+1wqD0aOUO4xxZC9B4ABKfynUNCrjEv96E+7Ji4Y/FeuuvaEikJ7o75k4oVI0dYFN9v3tcu3hnzbJXNKLODt+20vvI59Mc3LWW6PJfLclM+0QNvuK+czcDktyH1Yl0a83u2hVEiZQntl1k1ZRBY2S/VIDKhUCwxoaXCDWDwsrlD3PrVoZcqsWFSUeMLt/GTjgl8d2OHRsuXQTBpBSLdrFm9X+LwyKLRqhIcbacrgtep/wUJNXWp8FttEWj3hjFMEd4nmaiPDlhpmrGozxROMtF+SZvozwc8Jk/qmuaA2SEnjsWz1SedTnEwDisA0/7Ut1Z1qiI17r5aHfsOEOWMCxl1DgLejszojzvgY9/RNxvu0XHZWlqJgdfURcQkfkQRmZaMurcyT5n1EQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 2026/11/3 16:54, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] tools/mm/thpmaps: UnicodeEncodeError in vma_print() on non-UTF-8 filenames
> --
>
> commit 5f793a93e6fde4bbef2fd7ad6b6bda119aa8b288
> Author: Weilin Tong <tongweilin@linux.alibaba.com>
>
> tools/mm/thpmaps: handle carriage returns and non-UTF-8 filenames
>
> This commit updates VMAList.__init__() in tools/mm/thpmaps to open
> /proc/<pid>/smaps with newline='\n' and errors='surrogateescape' so that
> carriage returns in mapped filenames do not split header lines and
> non-UTF-8 bytes do not raise UnicodeDecodeError while reading.
>
> Link: https://lore.kernel.org/linux-mm/20261101211644.c63a2028bbede0f763f41f80@linux-foundation.org/
>
>> diff --git a/tools/mm/thpmaps b/tools/mm/thpmaps
>> index a1a9bc30514f3..f89568bd499ec 100644
>> --- a/tools/mm/thpmaps
>> +++ b/tools/mm/thpmaps
>> @@ -196,7 +196,8 @@ class VMAList:
>>       # instance to receive VMAs.
>>       def __init__(self, pid='self', stats=[]):
>>           self.vmas = []
>> -        with open(f'/proc/{pid}/smaps', 'r') as file:
>> +        with open(f'/proc/{pid}/smaps', 'r', newline='\n',
>> +                  errors='surrogateescape') as file:
> [Severity: Medium]
> When VMAList.__init__() opens /proc/<pid>/smaps with
> errors='surrogateescape', non-UTF-8 bytes in a mapped filename are decoded
> into lone surrogate code points in vma.name.
>
> In default (non-rollup) mode, do_main() passes each VMA to vma_print():
>
> tools/mm/thpmaps:do_main() {
>      ...
>                          if args.rollup:
>                              ...
>                          else:
>                              vma_print(vma, pid)
>                              stats_print(stats, vma_anon, vma_file, args.inc_empty)
>          except (FileNotFoundError, ProcessLookupError, FileIOException):
>      ...
> }
>
> And vma_print() writes vma.name directly to sys.stdout via print():
>
> tools/mm/thpmaps:vma_print() {
>      print("{:010d}: {:016x}-{:016x} {}{}{}{} {:08x} {:02x}:{:02x} {:08x} {}"
>          .format(
>              pid, vma.start, vma.end,
>              'r' if vma.read else '-', 'w' if vma.write else '-',
>              'x' if vma.execute else '-', 'p' if vma.private else 's',
>              vma.pgoff, vma.major, vma.minor, vma.inode, vma.name
>          ))
> }
>
> Under standard UTF-8 locales, sys.stdout uses errors='strict' by default,
> which rejects lone surrogates. Doesn't printing a VMA with non-UTF-8
> filename bytes in vma_print() still terminate the script with an uncaught
> UnicodeEncodeError unless sys.stdout is also reconfigured (for example with
> errors='surrogateescape' or errors='backslashreplace') or vma.name is
> sanitized before printing?


Thanks for the report. I reproduced the failure under en_US.UTF-8.
I also confirmed that valid Unicode filenames fail when stdout uses
strict ASCII encoding.

I'll address both output encoding cases in v2 alongside the smaps
reading fixes.

Thanks,
Weilin

>

