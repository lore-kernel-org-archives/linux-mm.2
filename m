Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05100CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 10:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814C66B00FB; Mon, 18 Aug 2025 06:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC946B0100; Mon, 18 Aug 2025 06:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7298C6B0101; Mon, 18 Aug 2025 06:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 600F86B00FB
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:04:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 11C55140864
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:04:49 +0000 (UTC)
X-FDA: 83789444298.15.A0CFC27
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf28.hostedemail.com (Postfix) with ESMTP id 79085C0007
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:04:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=DMd43+nv;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf28.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755511487; a=rsa-sha256;
	cv=none;
	b=zO6nkd6Hsd/90vGk57UwGeB+F12DDdKXT7ZMY5jP31HFc/g769NTahNLddP9X9iWaESMb0
	SYqPinc6TnhGCj0OURgzOkLFek2qc/ZBOqYlqXHywBq+zrJylBiRd7yJBQC5wpl+AMY9bq
	nmyHu02t+Vg7xZGZjgIorQP+j/hFW9o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=DMd43+nv;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf28.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755511487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awwiyH3s0NQNHsdDw497b+l067+DM4LXdYTHuIVv1cU=;
	b=zEE5rI6N22cM/7jjPN36f5RnQwkjVWVyfMscQpQTDN8Ga3ACW4Ajup6JKQDMeYsNhpgAX9
	Q+xnuwQ0kX6bFpq/h0KS0fWtkWlKin5Bf9aFgGP/F1wnW7SbXXgmIGHQABJpvyV4s666Qj
	/dk7jl7tPVlwCOL8iJ+IqvuG0DhI94I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=awwiyH3s0NQNHsdDw497b+l067+DM4LXdYTHuIVv1cU=;
	b=DMd43+nvcqImVbvhqh2Eh3CORxPAIEFx6XRQ6CnPrNU0umuSnWA/D2Do/IpaJr
	7L/6t5O3wmyj8afVUQyYT9GsmycrULrVuWRrOnvmT55HTdrL/+2MRwb1hMdVa+Kv
	UC3GIMEzsFdhkxaDdha0udI/OzBSn0t32THn0K56Wg7Xs=
Received: from [10.42.20.201] (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD31_+o+qJoFtABCQ--.9173S2;
	Mon, 18 Aug 2025 18:04:25 +0800 (CST)
Message-ID: <9b3116ba-0f68-44bb-9ec9-36871fe6096e@163.com>
Date: Mon, 18 Aug 2025 18:04:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mpage: terminate read-ahead on read error
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Matthew Wilcox <willy@infradead.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20250812072225.181798-1-chizhiling@163.com>
 <20250817194125.921dd351332677e516cc3b53@linux-foundation.org>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <20250817194125.921dd351332677e516cc3b53@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wD31_+o+qJoFtABCQ--.9173S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCw1DWrWrtw1xJr15JFW8JFb_yoW5Ar4kpr
	WFkFyktr9rJrWrZr1xJFsrJry8C3yI9a15GF93Ga47AF45WFyakryfKFW5ZayIyr97Ga1v
	vw409FyfZF1DZrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U8uciUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBaxStnWii93RePwAAsn
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 79085C0007
X-Stat-Signature: 5ue6pwygfxpz1oqcjr5da6itq91m6eez
X-HE-Tag: 1755511486-144093
X-HE-Meta: U2FsdGVkX1+C6fns2Wwl9GRY6tRJFL7cmnzXTEov/Zhf0PA3qyobnV769aQ+klgx81S80/ZlHsu8Eec2zzqU5/l7mC1DSeb6DFpOi1WVJsBV/fnoU5ZjiSdndPT3NkAjzDWJ4Ab7iQ6gzdTFOhA0vA+V2qHzc071WkvXyltDbAz2BzeZuSk304FCPjuRS0EpPRxwTKriNBC/V+PnTgNYEAerkYpg5HZTFMKk18M0DTmDYwpfoLQgsrdXq1l1pCqXy3VUxQQCyWQqTnmJe7ujwCV6Lm1A69QAIE1TSrLYcMzd326GRGypkRbEyWftc0bLL++pw22AL4mCf2AzrsmWmVCFJus7q7wK1k1kKfhJsJGG/A9Po645w9oxmtKg/04nnj80MByigeznhMqauHl83obcaOghuvh1uswmeOB7yVR79ANf3kCRtlJBAD27ts6w8XEyzJqx3ukMDur7WdPE5uxBd8Z7w1fdKBBcqL6VgtOtJ6Kp9c6WlFLQu0MxUjXLfTU+m24ejjIhJvmQf/x0ifp5UlLvzXZC2iBG4UAWpGspjj/iRyk6mXu0DOrRHjHVLaIQVhPjOaFreNyN0TRIvTQjwvA1f+f/NZBnr0whobx/4/m3s3fri4AWrhyysZaDCA34be1ca7UXDHS7QhaaephW/0a8JLrkCQoRGceOd+Ptfrgv4M+I4lGKxZCEBexOMtyaEiDNoCuWu4Hjnfvm3FMcrU9SBDyeDcjaoHR7E1U7ac4eczUE2mVMvuW+3AdKELhT62xdq2nsuqP9xyuDWm5bduBjchrO03nXr9mjMFrMyirI589W5xKdkLH69nHpffFut2ah9AGiwsOOOOFE/gcZ4ZCu4jO2ssa6WTfa0zUB6xkglpoATe6wAshvEt7LadliQVL4dw+f9E0rIUIoevDTZ99W+H0fbE2DyVnO3IjGvdeMabk+ScbjfxS+74dKsusG4RB66l1PhNCr9Jk
 pIa8GqSd
 JHbO1dBeEYNAlhepOzuvjewE7zAJ37B1HvkhIrdh1fstYLWQx9e7rEQKiRbApSa/f+eMXC9zPzHAJV4GKTHn6+TPmY2nBfz4OHSVTUSQtNZx0Hk14Y6DtSuQRD7RXYvFJ+dZY0ox59JG00Pz2vMMpa5SzeyeyiXWb33luNs1ZRnJ86o2hSRiH5Z76eVudFBwo6zeqytsX7uzzoRkjHM0ODGcQVlHgBRL4cwaZEdQhKDecMJhq2rGUwZiCc7y6qZq0WVKWYtkIWjxcHmkvMVD3uWzcD9AMZyZoT+6E/cmOn7N+kKhD7zK+wboiiqgbfC98VAck5Xd7eP1IEkgp/j7ToyY1JXLM3QC7pR2LX+gQv3PMg2/GAX/ozG4KQNZ4bZD3MIjZK0qBUmmMpvgSKAV10X70vtf0NuthPlhgj8pkMltnt1PRwbVfHr4/iMktjwpmBi/I3vdiAzveBDY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/8/18 10:41, Andrew Morton wrote:
> On Tue, 12 Aug 2025 15:22:23 +0800 Chi Zhiling <chizhiling@163.com> wrote:
> 
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>
>> For exFAT filesystems with 4MB read_ahead_size, removing the storage device
>> during read operations can delay EIO error reporting by several minutes.
>> This occurs because the read-ahead implementation in mpage doesn't handle
>> errors.
>>
>> Another reason for the delay is that the filesystem requires metadata to
>> issue file read request. When the storage device is removed, the metadata
>> buffers are invalidated, causing mpage to repeatedly attempt to fetch
>> metadata during each get_block call.
>>
>> The original purpose of this patch is terminate read ahead when we fail
>> to get metadata, to make the patch more generic, implement it by checking
>> folio status, instead of checking the return of get_block().
>>
>> ...
>>
>> --- a/fs/mpage.c
>> +++ b/fs/mpage.c
>> @@ -369,6 +369,9 @@ void mpage_readahead(struct readahead_control *rac, get_block_t get_block)
>>   		args.folio = folio;
>>   		args.nr_pages = readahead_count(rac);
>>   		args.bio = do_mpage_readpage(&args);
>> +		if (!folio_test_locked(folio) &&
>> +		    !folio_test_uptodate(folio))
>> +			break;
>>   	}
>>   	if (args.bio)
>>   		mpage_bio_submit_read(args.bio);
> 
> So...  this is what the fs does when the device is unplugged?
> Synchronously return an unlocked !uptodate folio?  Or is this specific
> to FAT?

It's fs behavior,

AFAIK, all filesystems that use mpage will lock the folio until I/O 
finishes or encounters an error. This avoids races like buffered writes, 
etc. The uptodate flag being set or not depends on the I/O status.


So, if a folio is synchronously unlocked and non-uptodate, should we 
quit the read ahead?

I think it depends on whether the error is permanent or temporary, and 
whether further read ahead might succeed.

A device being unplugged is one reason for returning such a folio, but 
we could return it for many other reasons (e.g., metadata errors).

I think most errors won't be restored in a short time, so we should quit 
read ahead when they occur.


Besides, IOMAP also quits read ahead when some errors are encountered in 
iomap_begin().

> 
> I think a comment here telling readers why we're doing this would be
> helpful.  It isn't obvious that we're dealing with e removed device!

okay, I will comment here.
/*
  * If read ahead failed synchronously, it may cause by removed device,
  * or some filesystem metadata error.
  */

> 
> Also, boy this is old code.  Basically akpm code from pre-git times.
> It was quite innovative back then, but everybody who understood it has
> since moved on,  got senile or probably died.  Oh well.

Actually, I think this patch is safe, but I'm not sure if we should fix 
this issue. After all, this code has existed for a long time, and it's 
quite rare to unplug the device during a copy operation :)


Thanks,
Chi Zhiling


