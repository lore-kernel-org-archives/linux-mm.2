Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 097DDF99368
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 10:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7287D6B0005; Thu, 23 Apr 2026 06:28:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FECA6B008A; Thu, 23 Apr 2026 06:28:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615456B008C; Thu, 23 Apr 2026 06:28:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 557606B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:28:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E61871B831D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:28:58 +0000 (UTC)
X-FDA: 84689447556.22.6F1AD88
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 09AB640014
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:28:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XdMz2EqY;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776940137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xbqRexdC+3brjGT338smE12Vf1U6I5o0U8f0aYjEZSw=;
	b=g+8BYFuz7G+d5Lv/x3W7dBniOtVh5q9N0iBga/V1N20ISlMf1LhrVZNPZsf3jkAfzAT4eY
	nEWn8uUKS3WX4sWt9ukTrgVuELyK5pWst6vnbVzM02MeD0dKWuugT9mT26BoR96Qlc+eKD
	A2f1nHXeUQQIWFoYrwHVGzI5tV/Htfg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XdMz2EqY;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776940137; a=rsa-sha256;
	cv=none;
	b=nMz01ctce+nlqtF0LDNlT+BUCM8ewlHFypxCqFalXEuCYQtv/ivH+rJXs6PHlXHbiqcdsk
	e6cTPkyZWY7x3/VeAyDhB5GaPrekcqMi5EJg7rRCNOePmhkuoWMgg173rzWuD/CYLx1NeZ
	qVuH0Bv8MmXHgUaqvP1jtcSC04iZ6N4=
Message-ID: <ead379f8-2a9c-4362-b176-829dafc791d2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776940133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xbqRexdC+3brjGT338smE12Vf1U6I5o0U8f0aYjEZSw=;
	b=XdMz2EqYX4nJQWchP7oFU5W/UVsMvycZW0MTF/h42WiblpJlDsrh6AKhOiiSor/dMvNPJj
	LkAxBoYQHxwbxCqd/0SPGyJgHFPH45tyhZM4j3xMVyRUYt7wXwmhjO3KYWjFafCbdF91pV
	fMdp7AdZi6QgrsPetJRbdbcEVMzF/uo=
Date: Thu, 23 Apr 2026 11:28:44 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v4 2/3] mm/swap: use swap_ops to register swap device's
 methods
To: Baoquan He <baoquan.he@linux.dev>, Chris Li <chrisl@kernel.org>,
 akpm@linux-foundation.org
Cc: linux-mm@kvack.org, baohua@kernel.org, kasong@tencent.com,
 nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
 linux-kernel@vger.kernel.org
References: <20260417033951.1111038-1-baoquan.he@linux.dev>
 <20260417033951.1111038-3-baoquan.he@linux.dev>
 <CACePvbWZO-=Nwho9Hfk-2HpuggZyb+Yt306MdA4X_icAt6+Z9w@mail.gmail.com>
 <aego1T9d6PVudYqj@MiWiFi-R3L-srv>
 <CACePvbVHgry4oeXeouML1YNscpuMNSXSnBY9wd-McDUar4tG1Q@mail.gmail.com>
 <aemF6D3Do9FQYUOF@MiWiFi-R3L-srv>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <aemF6D3Do9FQYUOF@MiWiFi-R3L-srv>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 13fizus611nse9o7pjt854nzktbzcxd6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 09AB640014
X-HE-Tag: 1776940136-540650
X-HE-Meta: U2FsdGVkX199kSDLsgyaW+WpA/5owSyxWImWeAhkPseayBgAWbyDjjcXuRiJ+AjQ5FADDFMbm5J+ee1/VXNFcAb+pbaS7cYTBnI/PaWUGNJ1qOTmjNhGeQODdoa4WFxGv9Oa7fY5IX2O5v16Rdp4wHVS3bsHDBcDtLpU3sHGXU4RLrIYcnIxzK6Q9EHdDkKaP6TFLKDFq1Voo+Ve1uekd7REbJDw4KAUuAffXvx4iCrUyHy8Xga5dhs9ibR+iIIKVVVWRSw1bEnq4bikZ3YIXT0Pa62w3VWoEB001g2m5IBjEAdgZ+tnB1K/Ha9z3y+DIlRE3/+ZvQSvzoMsSpax0LQKCHDkNPXYTbAGKmoM9dCwSj+puOMuehaqAPVZQnG1izduEJJEtXx/5SxYZrzYN4WUxQj3qXHrcRf3rAzpsmU2/NmnlHjn/ogYXX9ElzMuMlctTCiJGjBKDkxBLzh2uD7yXbgx3fqt0h1ZUtNu2PCDsZKhHaLW6/OQ8cH6dzU59gWNv3XipyRra8SoYY7gsUTV83EQ93rYnCBVXM8LsP+59PkcE96Wwc42dGbMaySMjavawqGf/ASkk7DxFKFJbk7KUsYYOTPiU67cJgDdApVL6hFBbSlGyQp9P+B0oMCIO/jIeV7gaX/qDl+hTSZiXXAk+R/fQuocrHaShS+9pTzkkH4tvSbqtZPNp9xJb+cuAiFNPf4FscIUvuxTu39W6nNrPMWQ1A+yTvCNli59DMUTlYXmAhN5aUWNNtRASbAJT5QfgoQTnb1BF/yGPGocaKlfi+laSsgvPevkBXTz+FRbO57ESFIAnJsAMFIaHh4fAj9tfcvpdRwsKthl5jGJriSxR7h1iWId2LEyI8Cjv/mN3/g65ga6ToqiDFdCijeD8kr3fHLGsREKAMxnU6FGkC4lMtmW2zUtd5PRdRP80LScINfGMKMjldkHTS19E+N1AReuDEuFg2fcPa3zjBE
 BOlUByZ7
 nDF4z+952Uqeayf3yeKFMZfG5DoLHuF3ngLMn9pWbrPs5e4gIg9yQjbNgJJ8sS9eWwT9xqiqtZpC+VSD3+1e5WjOGg9kgVyC7Ieaom9bZ7a4xwOMtNBGOaTSgFkk/BuqqkjWFf5nfHDug8VxM/FAI8OzN6e5YqPjmzsa5kabA9bDnl5Fmd4zPumoRNuQb3nOCy1Wp1ubPAgBy9HUxrZGFJqBDgo6+kO7yhB3Gud09rrLOGetS474op7HAmiG+IeQoPOvDMqq7k1BQ1eputgz/hxuU4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/04/2026 03:37, Baoquan He wrote:
> On 04/22/26 at 05:33pm, Chris Li wrote:
>> On Tue, Apr 21, 2026 at 6:48 PM Baoquan He <baoquan.he@linux.dev> wrote:
>>>
>>> On 04/17/26 at 07:30pm, Chris Li wrote:
>>>> On Thu, Apr 16, 2026 at 8:40 PM Baoquan He <baoquan.he@linux.dev> wrote:
>>> ...snip...
>>>>> +int init_swap_ops(struct swap_info_struct *sis)
>>>>> +{
>>>>> +       /*
>>>>> +        * ->flags can be updated non-atomically, but that will
>>>>> +        * never affect SWP_FS_OPS, so the data_race is safe.
>>>>> +        */
>>>>> +       if (data_race(sis->flags & SWP_FS_OPS))
>>>>> +               sis->ops = &bdev_fs_swap_ops;
>>>>> +       /*
>>>>> +        * ->flags can be updated non-atomically, but that will
>>>>> +        * never affect SWP_SYNCHRONOUS_IO, so the data_race is safe.
>>>>> +        */
>>>>> +       else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
>>>>> +               sis->ops = &bdev_sync_swap_ops;
>>>>> +       else
>>>>> +               sis->ops = &bdev_async_swap_ops;
>>>>> +
>>>>> +       if (!sis->ops || !sis->ops->read_folio || !sis->ops->write_folio)
>>>>> +               return -1;
>>>> Nitpick:
>>>>
>>>> For int type error return, you should use  -EINVAL or some thing with
>>>> error code. If you don't care about error code, change the return type
>>>> to bool instead.
>>>
>>> Thanks for careful reviewing, returning -EINVAL looks better, I will
>>> change like that and repost.
>>
>> You don't have to repost it as a new series. You can post one small
>> incremental update for the -EINVAL change and ask Andrew to fold it
>> in.
>>
>> Hi Andrew,
>>
>> I think this swap ops series can be merge to mm-unstable with the
>> review. Keep in mind that Baoquan might have a very minor follow up
>> patch relate to -EINAL error code.
> 
> The incremental update is as below. I have built and test it.
> 
> diff --git a/mm/swap_io.c b/mm/swap_io.c
> index 77aa8373c087..e2710d5fb44e 100644
> --- a/mm/swap_io.c
> +++ b/mm/swap_io.c
> @@ -625,7 +625,7 @@ int init_swap_ops(struct swap_info_struct *sis)
>  		sis->ops = &bdev_async_swap_ops;
>  
>  	if (!sis->ops || !sis->ops->read_folio || !sis->ops->write_folio)
> -		return -1;
> +		return -EINVAL;
>  
>  	return 0;
>  }
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index af81fa212f1e..7644049a0919 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3518,10 +3518,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  		goto bad_swap_unlock_inode;
>  	}
>  
> -	if (init_swap_ops(si)) {
> -		error = -EINVAL;
> +	if (error = init_swap_ops(si))
>  		goto bad_swap_unlock_inode;
> -	}
>  
>  	si->max = maxpages;
>  	si->pages = maxpages - 1;


Acked-by: Usama Arif <usama.arif@linux.dev>


