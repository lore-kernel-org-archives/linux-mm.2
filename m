Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32461CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 15:04:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828998E001C; Mon,  6 Oct 2025 11:04:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 800258E0002; Mon,  6 Oct 2025 11:04:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 716468E001C; Mon,  6 Oct 2025 11:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 615588E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 11:04:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10C1FBA618
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 15:04:30 +0000 (UTC)
X-FDA: 83968010700.09.C1F5645
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id DC08180011
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 15:04:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759763068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dkkFciodtjlZ++pRZ7+TWOfBdpzT5Z9HCy2rZsEAuaM=;
	b=Mc6V339XVOITDE2XM4StjNvOxnQuHu17Kt1Dlp6tqzQLBTAuLHTNpDfhbYelZgZbEeHOXE
	rftm1S9viO6/nc58IGVF0hqlLOWZPKXMLASYZXY94RUpyZz0vjndM9lSufXq/ihW/hB1lb
	/3k+wXU5DaoOSKLRZbL08sGHzUhhNnI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759763068; a=rsa-sha256;
	cv=none;
	b=1P8l/uyzJrRjlQIBLA2PMQaYCf5GkK+4//1pFL4W3YLEM0BCqv7rL/K0ZpMAaLSVxkHi9w
	FzbnSAn3G8UfFpS8N/toJn70Pc1lDUvizjYq/NyyrjAtZ/JLo4pFVp1hIW+Nq/5VceRbTq
	mWMlRpLE90HV+sAmS0cW6YAusS+HbRY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D19BB1515;
	Mon,  6 Oct 2025 08:04:18 -0700 (PDT)
Received: from [10.57.81.160] (unknown [10.57.81.160])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F30893F66E;
	Mon,  6 Oct 2025 08:04:24 -0700 (PDT)
Message-ID: <ae61f721-3d07-4908-ad31-9c25e8b8119e@arm.com>
Date: Mon, 6 Oct 2025 16:04:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] fsnotify: Pass correct offset to fsnotify_mmap_perm()
Content-Language: en-GB
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Amir Goldstein <amir73il@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20251003155238.2147410-1-ryan.roberts@arm.com>
 <uyh6y4qjuj6vcpsdnexwl2xqf2jnp6ejj7esr3g3hix66ml2zi@pqsbsjtt6apl>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <uyh6y4qjuj6vcpsdnexwl2xqf2jnp6ejj7esr3g3hix66ml2zi@pqsbsjtt6apl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DC08180011
X-Rspamd-Server: rspam02
X-Stat-Signature: xwrg7c5x1oyz67iyzstcuk6jb5jg4rzz
X-HE-Tag: 1759763067-788783
X-HE-Meta: U2FsdGVkX18OYxaUoRPmg6Mkwb9+E3T12tA3A/nBHlkoionBp5Gm7kL/0IqeENG4cW/24P6v+knsOT6R+suHhZGy2RMMnZxvO6SZB25ogPESj0cfkRGiSc30N1b5APWr4ukvexUhbuFCI4geHEolB8GCg4C2PJou6oHldI2QKVNvKAu/HwtKzInClIGi3gii2wknG+UaIJ3msCqKl3MVTw2LG2ph8NRNCpglDow+lMUGrGFRTjPiC8GA6QJhpnxHBCUni0YyHz9IyPr1EqCCruPb3mj2tz0L4tfEL0Ix0Ktj7apjYnF6NtQHh9AjROKh74SWUDlOS4bYPYQxzEQn8V2Icq7pr2swGL6zTkxtilLdKPuRPPBGA3oVMXm/4EGlWbPCHs1D1bM19bFODSY4ORbCTrNzb2/3vtBFIqLiQcn9Gpdh3iTzSJvZiU3plV/vGzFLp3J/fxJM9sF5hgKvRLrPLHZ9Tm1nYFMqK+xp26DZ6VcjFJBsrvmGZ3D4hnyRLyh9EAWl8MaFxc4K1v8ZGmJ5xCYJW5K3rhbGCIOFAPr4Xk+ZogueKyb4fVMtsN/U2GIqbhUAQbMyD7rlZQrPF2f8n3NEZuDq8AGQ1RcPxpzdGrNl5S6KGh/JH7+i8uoorBkX2mAO9pAzSnngerhYLXzBoqgIXTWz2lTthb0QGTYLNKuBId0dXSLVPRi9JuQC50gvZeh30w/CIrxenvQKnZYn3plGsTufieyJCrmUpAK8cBlO1TfOt73smrt7hFHIOQ5XnImErCN90Lakl4QisT4BxSGTa8XQ27dDIABffKk3BqYXCWDFwZV0aMn5rrtvRMJSp3loVMZQjpAKiQGL/0PHJHGKSEJLHCb8EJPbnJ1T91dzibGbU5hE4wEVNhqb5WYHzLWqVXPoiHTsQqSrnJKd2HhYon//E28NjrRtTTA1KZ0O3zfDsxFHOdERvOJtS3VKjk2fWz9AfO2LpcH
 o/jRke++
 i2tiZ+R6Ty9TqorLMPAf2E+mJcKZBjqm6lHSiJYr1Hf6djbdP7HsLKX4jshstsTtJErA3TK14hYBJXx/7yzZFGdzwUP2bGpjvkV5affAjGJFK7lvjeGL/dqPljOfBApAJxWDqzYEt54boLVdKsIsOZ4+VMXOL+l2olW7oPkBApRbA7EFQNP+3WPA87DXCGNLXsqKsoQwt5PTm6gGzSy6AAbo3uqQFxekUWwSgOgdFxPpEfSk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/10/2025 15:55, Jan Kara wrote:
> On Fri 03-10-25 16:52:36, Ryan Roberts wrote:
>> fsnotify_mmap_perm() requires a byte offset for the file about to be
>> mmap'ed. But it is called from vm_mmap_pgoff(), which has a page offset.
>> Previously the conversion was done incorrectly so let's fix it, being
>> careful not to overflow on 32-bit platforms.
>>
>> Discovered during code review.
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: 066e053fe208 ("fsnotify: add pre-content hooks on mmap()")
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> ---
>> Applies against today's mm-unstable (aa05a436eca8).
> 
> Thanks Ryan! I've added the patch to my tree. As a side note, I know the
> callsite is in mm/ but since this is clearly impacting fsnotify, it would
> be good to add to CC relevant people (I'm not following linux-mm nor
> linux-kernel) and discovered this only because of Kiryl's link...

Ahh good point... Sorry I was sleepwalking through the process on Friday
afternoon and blindly sent it to the maintainers and reviewers that
get_maintainer.pl spat out. It didn't even occur to me that this wasn't an mm
thing. :-|

> 
> 								Honza
> 
>>  mm/util.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/util.c b/mm/util.c
>> index 6c1d64ed0221..8989d5767528 100644
>> --- a/mm/util.c
>> +++ b/mm/util.c
>> @@ -566,6 +566,7 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
>>  	unsigned long len, unsigned long prot,
>>  	unsigned long flag, unsigned long pgoff)
>>  {
>> +	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
>>  	unsigned long ret;
>>  	struct mm_struct *mm = current->mm;
>>  	unsigned long populate;
>> @@ -573,7 +574,7 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
>>
>>  	ret = security_mmap_file(file, prot, flag);
>>  	if (!ret)
>> -		ret = fsnotify_mmap_perm(file, prot, pgoff >> PAGE_SHIFT, len);
>> +		ret = fsnotify_mmap_perm(file, prot, off, len);
>>  	if (!ret) {
>>  		if (mmap_write_lock_killable(mm))
>>  			return -EINTR;
>> --
>> 2.43.0
>>


