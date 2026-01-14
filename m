Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BDF3D31A09
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 05:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BBF66B0089; Wed, 14 Jan 2026 00:20:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438B56B008C; Wed, 14 Jan 2026 00:20:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 337D26B0092; Wed, 14 Jan 2026 00:20:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 23BEB6B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 00:20:29 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ACA4814038E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:20:28 +0000 (UTC)
X-FDA: 84329418936.28.FF508FA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id A21AC80004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:20:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768368027; a=rsa-sha256;
	cv=none;
	b=sp2pX11pboYd7i1cSGSYIaCPXgRB/5lQcw2F0R+QxSMYeNAljOKfHLOb8S1eOUo3yAMknQ
	CfYacfIEqxp27hRkN2RYsqUUQqsg4M++2ujUJbNKRdK5+mKMf9p+YAbAf3VKadxcxuydxS
	5Ara58Qvzb8Bi5yK6xyPKd6eoZ6OoTQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768368027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tSNeGpwd34DmBai/YwZpBEPj3/7kUWhLybAbF+P5BR0=;
	b=pcy8KlK/37gcCpZY5ITZw4QFCyQiO4UkWoAAPc/ex+hP3SrnPbHVOCmK02utL9LBrrsuxX
	xLWVSXJS4MFRLSTr8K/gbfXPt0esmDlh/L2kCj9Y4oPQHSu7q3YQC4U3iokai7O+IN0zRS
	QayQZciofUKt+nUsNlIv2M+N5I86iq0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BEB4C497;
	Tue, 13 Jan 2026 21:20:18 -0800 (PST)
Received: from [10.163.161.65] (unknown [10.163.161.65])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8EEF03F694;
	Tue, 13 Jan 2026 21:20:23 -0800 (PST)
Message-ID: <10ebbce4-1b83-4eb2-99f3-738a0e613958@arm.com>
Date: Wed, 14 Jan 2026 10:50:19 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: make khugepaged_collapse_control static
To: Ben Dooks <ben.dooks@codethink.co.uk>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com
References: <20260112161818.604651-1-ben.dooks@codethink.co.uk>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260112161818.604651-1-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 8kjp1oyh61r8oeeyo5gezsad7iwcgb3t
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A21AC80004
X-HE-Tag: 1768368026-677611
X-HE-Meta: U2FsdGVkX1/+FMCpKyUn3CMj6HIVIKOuEodQl/UtJ1XAPA+2UHLWnByUln2a2Hww2XgEStBBcm7r7ImQHeaYYzXJtcD6i4t6sd1h6qG2nhRBinTaQV5ZE95wEMcdDcZVdh82A832Z9b0oc+T3jePnLDWQs4eBJda5EaWrNbGxAKMGYTD7pnsC+NZ1+Ayw3TnVVhjFP1Gce7yM7QRzmel0KBa1SO4SwL9BMxvSOv1T6cfEFd2Ho4V/1gLVWi1ouB8+7+RKl4BvLi//GYfi8n/VJK5EiYO7xHAUohu6ku72PSejMhJXR3TQYL0OOSPJbSk7sqwd05QVNf5qysO1sF80opqO/Hice4JaTLj0JYPiI30m5DUGN8LAd2OIyQ18LhVM2TCKJgHhvBLsemb35spkyRHuPm4nLqIxJoPhjOtT4shQprcEEnw7+293VhVkh47rPe6Fky8olX1ayfZ9iwaMaWMeVz5iQe40HW3RdIAsOTSaNfwcL19noHmc5Qx82nAJGgJJDYqyqSSxNko/InOOn2FvS7kuodBKgRgQJNpW4uby4eNOc/Lz0WEpesKcOqr9UJ/svUu2jH10Jvu7AslTUAaB4nuNSERfeIqq2YEkoUAtpoQfR4Hv/paX+BoOli87sHdVdNOObHW3mqakBJloV1QSpTZ6SVFzXmXmROEtGC2UOyb874SbFCu5AlR7/ic0KrZ8tHmBZwf0EPe7n/iMCBbxy5L0h5j+yBuYfdNnhpJN9nnt3OoHf5qm1fVi5luAPWe/2VfzO0o1j4rKjbxV2wOl4UlgqPzzQOIZG9e8Kznsc6kM4oS7LXyUrn9N1THkz20AKK/Q0HttjXcTpabnS0Ry/YGsgjGnV7mXvDNv59sipMeEI0QHu/G4+aZZ9EtVqkNawqejJHbEcgthf1tkZ0FXL5TKUDHntXcceadVLGy8/eDrsNe3NuuCaJJN/ha/49BQR2W9IC9zno634u
 GXhDTCgI
 jLFWLxYncU3Q5hayTUkOAuhB/iMxOYmQrnUOqOdMSw7NB8A49bA6jqaogUBBRIL2sI7gEo7OjI1HaUUUnoa7IU4Khfi2ZCMBcOHpmK5F3qjz7j1UH3gtG6qwBZEgz5GrwduxQi4QIrz3LDVsiWLOSWRt9vVsLyIZpwFfEbEYvrwK/8xPD3FmBf4FxlUWz0P6DxuMA2V29ZZ5wWhDvZimk0OoeITVOHSIIduogdQ2YrzPIIhD8gl5R73dCWbdsBAUXWg9dUe0XleAp5rSTIf1GvD3Y9qfLu/0mrBcLlTpgHNtfYJeOtKLfEB7T3CEIMy0KKgjwKdp7mXuaF/Jgx6CBgRE3Ow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/01/26 9:48 PM, Ben Dooks wrote:
> Make khugepaged_collapse_control as it is not exported.
> Fixes the following sparse warning:
> 
> mm/khugepaged.c:829:25: warning: symbol 'khugepaged_collapse_control' was not declared. Should it be static?
> 
> Fixes: 34d6b470ab9cf ("mm/khugepaged: add struct collapse_control")
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>  mm/khugepaged.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 97d1b2824386..c9bd0df632bd 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -826,7 +826,7 @@ static void khugepaged_alloc_sleep(void)
>  	remove_wait_queue(&khugepaged_wait, &wait);
>  }
>  
> -struct collapse_control khugepaged_collapse_control = {
> +static struct collapse_control khugepaged_collapse_control = {
>  	.is_khugepaged = true,
>  };
>  

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

