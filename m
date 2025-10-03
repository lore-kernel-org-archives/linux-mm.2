Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FB79CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 17:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA79D8E0012; Fri,  3 Oct 2025 13:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7EDB8E0005; Fri,  3 Oct 2025 13:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BC128E0012; Fri,  3 Oct 2025 13:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 847838E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:08:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BBF213BD1D
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:08:09 +0000 (UTC)
X-FDA: 83957435898.26.077AE1B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 833D7C0014
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:08:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759511287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=13Qw4kvG/OJZJCtWLkohrZH6p46FB+3RAVVvGrQ4+6g=;
	b=0Ypsep+UaieNn83kX647/tXNw8VyAGgPWKwYLFttPe6rKMPkhO14rqnUW4bU/3iQlMpth0
	rQ6lVW4IUjeujbeejAilq8+F9HRzQkKlL/Lr/uGd2sRMPakJ7urZ5xNQylzU7hCXlnP0Ov
	4j/xQlUNvk3U+VAB7rOyt8ZEceyXHlc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759511287; a=rsa-sha256;
	cv=none;
	b=JGzQ3Xyz6kODs3zrBtOJJThlwdt0Df7fGZOFdOVZcrMQhOWDWVAe/ZwqQxGmViY7qNR0Co
	Yeu7tJDM6wMk3e8Eu2JQLnzOgV+mevP+NVzwywnWGF626NFHtXIJql5l04+mGtvA/Elu5t
	XOhHf8MpWIyhYq7ZKNPzbhbIKHo7vIg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 955931688;
	Fri,  3 Oct 2025 10:07:58 -0700 (PDT)
Received: from [10.163.65.114] (unknown [10.163.65.114])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 878833F66E;
	Fri,  3 Oct 2025 10:08:00 -0700 (PDT)
Message-ID: <cb93234b-9a4f-406b-9a82-04ced1453fc0@arm.com>
Date: Fri, 3 Oct 2025 22:37:56 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mmap: Fix fsnotify_mmap_perm() call in vm_mmap_pgoff()
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Jan Kara <jack@suse.cz>
References: <20251003155804.1571242-1-kirill@shutemov.name>
 <bqmxwfi4kohx744fa5ggoiovrhiwsoehqn57kptoni64lgflim@ibt5bjvcbhdx>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <bqmxwfi4kohx744fa5ggoiovrhiwsoehqn57kptoni64lgflim@ibt5bjvcbhdx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 833D7C0014
X-Stat-Signature: j11yj64tf8tj7pqyt5ub6ne7uqjqmijt
X-HE-Tag: 1759511287-606425
X-HE-Meta: U2FsdGVkX1/4xtQxCN2dgxylb7fSA0ftC8c7JTuuJ0mOGDxHE2mReMvQhIT+oclFrM6c1eLcb5B+twX4+xCCv8/su2wlzhubNFF7VjN1C/MY8KFsqO3dWmA5+GHF/fj0UC3dWO2fa11o7Wja/5eyU9yi3PsrvATvCAn2gUpNK+UHFjdWfR3a/jd1wP3u+xAoy89GkDmTJxA41MN8YwcW+8Pz/NN9YoOpElPkDmqbZPtjifbcqo9W6v0hyYr8aBEUgKJRnUlKtVTy5SE2wYTV6a++eLiLWLNR+Hi8VOQAZeQg+Jfk6XsIzNgcn6SPbTgpdhcHD2hJMqfIsxuCDayut+zBwe2lHuQAnRrkQDmeaLY/8uoFnA3GH/Jr6NvwcMD3TNP77qj/SUkTDAIbEPXoAe16lIi/LdxDUi02gEwdEn7X08TdkOj53khhwWCXRXRnJJdrcoX4dxouyzotWoVWNRfzTToP+WcPVYWxZiWUzPQd8ww9u1LzB+k6W94x7+iqvVhuqyT75I9HCIU6xeaZK5WmKlwSasFN9Dxc+DM1A278z0e1olNc/CF/MPjnBIkjrplDr5Zu9AdgN2N0AduM+e3wqOBUEIVZ/5TS28uQ9wQsPMon+GVZvXjCYqXsKpqGe/ASwVcVq7n3eBAmKj6koPNpqfhH9u+8DajWl8sCoWDWfHXsjN38GaNzPq6HNzD5VgS2fTne5sk9VVjZf9GVw7UY6jVqOzGLT8EWDutO+vMvi2b/ba2nkxuu+SiY2TO7TysyIQV3eyHhUO60M/dR2kUjQJLrCx7bHB4CyKghXPCmVgVJfwoHuX0B/N2dFbvQBrZv1XpuCI+vYHYbt8+MzvECddyjWb7FOO3yhtYVI0UwzFeShZBzpP8tYC+Kt9OEcVvdkOeKHArOHg5eMn4qtFylxxbi/OxhlvJbeaIBslsQXKQ5BgJPE8P6dUGbX/2Vk2ktVJJnRfla8bon1y+
 83K3sDNk
 bXQpckpzEgQ0YUmsAgsNIg2Wq/syoYQX3f8b62qYOVNaJWZkUMe68Lpgv/Bg3Bb8jP8SITPFFTTkp46ZbvA0ocijwf61Jh9bW+FZuY+39VJa7K/RnhHqT8u45kCwBUTOyxw1hQJrNY58bKZ0EGuk9AHoomoHQLUvHdWyHl1cuAgeE3veKrSB7qgFxzJR74UFUKq5yR+RAHPaEU1pz1Jp2qjShUZJrWZs2TOvCE04wKSYiNYYMlx7ntgrINZDV1derZOD/YBuSt/dCH8dHhvffu2/sVL02a4WGvXJTKoviZCP3D/vjdHVejBtSoqCr5f/Bxh0BNFM08pCw879erKDV1vrs1UaRsUFCpy5F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 03/10/25 10:26 pm, Kiryl Shutsemau wrote:
> On Fri, Oct 03, 2025 at 04:58:04PM +0100, Kiryl Shutsemau wrote:
>> From: Kiryl Shutsemau <kas@kernel.org>
>>
>> vm_mmap_pgoff() includes a fsnotify call that allows for pre-content
>> hooks on mmap().
>>
>> The fsnotify_mmap_perm() function takes, among other arguments, an
>> offset in the file in the form of loff_t. However, vm_mmap_pgoff() has
>> file offset in the form of pgoff. This offset needs to be converted
>> before being passed to fsnotify_mmap_perm().
>>
>> The conversion from pgoff to loff_t is incorrect. The pgoff value needs
>> to be shifted left by PAGE_SHIFT to obtain loff_t, not right.
>>
>> This issue was identified through code inspection.
>>
>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>> Fixes: 066e053fe208 ("fsnotify: add pre-content hooks on mmap()")
>> Cc: stable@vger.kernel.org
>> Cc: Josef Bacik <josef@toxicpanda.com>
>> Cc: Amir Goldstein <amir73il@gmail.com>
>> Cc: Jan Kara <jack@suse.cz>
>> ---
>>   mm/util.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/util.c b/mm/util.c
>> index f814e6a59ab1..52a667157264 100644
>> --- a/mm/util.c
>> +++ b/mm/util.c
>> @@ -573,7 +573,7 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
>>   
>>   	ret = security_mmap_file(file, prot, flag);
>>   	if (!ret)
>> -		ret = fsnotify_mmap_perm(file, prot, pgoff >> PAGE_SHIFT, len);
>> +		ret = fsnotify_mmap_perm(file, prot, pgoff << PAGE_SHIFT, len);
> It misses the case to (loff_t) and it broken for 32-bit machines.
>
> Luckily, Ryan submitted another fix for the same bug at the almost the
> same time. And he was more careful around types:
>
> https://lore.kernel.org/all/20251003155238.2147410-1-ryan.roberts@arm.com

Oops! I need to be more careful...

>

