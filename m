Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CC2CCAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 16:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740758E000E; Fri,  3 Oct 2025 12:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718288E0005; Fri,  3 Oct 2025 12:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654938E000E; Fri,  3 Oct 2025 12:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5528D8E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:25:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EBD0711AF8B
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:25:14 +0000 (UTC)
X-FDA: 83957327748.25.4EE9158
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3B07D1A0011
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:25:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759508713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CjdWr3nerEvY5CSlTmB1836gJanoc7KNdc5t8oB70+o=;
	b=ixYY8DMqU8Hp7Bvj1jt8aclllGurmo9V+6SLyn5NTsh3iNn5H/OEb31lxk5JH5yJj55uqJ
	edYB1vIKDq5LRY1y9JqpdskgK3k562KZpbBdpybvg8i+sa+iNEYsq+mChFTauv8fRTj/hB
	qREeHHNxdKM6WvhPSl46gx5JP/l1VZY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759508713; a=rsa-sha256;
	cv=none;
	b=EggFoUb/MwdB7+0oawbedB5EZbBgr2NpzO4DHAUixHG78zfOlmZ4tDjWxL1wiTJabVAvsl
	EemmX5b6QlKChf47r6e/7MbBqG8ZXUc6EDDGjljwsZl6zHQYI2x949WXGPApqiUASldluN
	z++STRS5SY3rnbJxxTS5o0A8mlk8saU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A08E1655;
	Fri,  3 Oct 2025 09:25:04 -0700 (PDT)
Received: from [10.163.65.114] (unknown [10.163.65.114])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AB1913F5A1;
	Fri,  3 Oct 2025 09:25:04 -0700 (PDT)
Message-ID: <39cb4556-f80a-44ba-a8ae-7990544673a8@arm.com>
Date: Fri, 3 Oct 2025 21:55:00 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mmap: Fix fsnotify_mmap_perm() call in vm_mmap_pgoff()
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kiryl Shutsemau <kas@kernel.org>, stable@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Jan Kara <jack@suse.cz>
References: <20251003155804.1571242-1-kirill@shutemov.name>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251003155804.1571242-1-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3B07D1A0011
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: sf1a3731yadpkzticxyakx7askapfj9t
X-HE-Tag: 1759508713-566015
X-HE-Meta: U2FsdGVkX19jN/OvtUyp+CloDkwxgFW2tAUD2OSTEgJ93m8f5ykIdWCr7f5CTNah+QREL/2PaNYh1aHg7G/6xMPlX4MdU/lsOxVhkmeVvEswKBp2Y63RsRwvD1C0r7FI7WeFhfUaAL/6HoMau6dA1fSuo2fRAaT6fR0EYmDItZjZpKKCzDD5bkOstM+1tWexVnKX/aed6rbgK0GSx/kL9BtEjyzlEtL7k56VdpPdZShHElaOU6v54K6TwNEOpm/gePIL+i7LIegWEXdrlbdKM/ZurtUqTKdd5T7WfsD3GApqIWN9AE1kguMMPEy44QcOEM3+7Opq9YAAULWvn7HnYZ4bjgJCJpKEEdhYCV2EWtdjTCeBufDNAU0QnlwGn08ENQgBVbS+jR2R+DwbaOQ863KDum4JOSm3Wj5sbKYLiWgbrWUcwMpYvXs/DSg/BrGaDhxHFJ3/7fH5b0kR3NL72VGz/yxFkMhdWC9tCLrNNokLGO9dWv0IRZZ2cGypjER6pSsDMT/jU4o8g/1ONGbRWw0uwJ5jhIUKXzMESAg1Z2tgI0hnxhl+13u7ChrptuI/M1bG+u75N+pcHKg4jvtyLuELbrev0VRIjea3Dat6HahfVUuOytWDnmMvl4tClOcjp+N+I9yiCobf17WtlbHPaY6UwRmhJ7ZSkI5QnDc1SpghQ6bJAN5flRqRJ1J5VY5JLuFn3iixSdXnYRY1gdo1CmVMDYW1ZD0Smx1mdlOEqylh6qX04wPdXaAcM4ZBN7+aJbnejkHCoI9dCwU8q7WvgCrtwfJeoxJCRnplIBj8RLPmMdXhrF5rcLmCsyaepfYsLnB/i7TVxhJFWdMBJhlo/v9qG//nuaNQVcqwJfahIwJfpsHlc0M52cP9MmRfn3GHegV/B4j+i/NAuFZYu2lhGYc0A8S6kK0+d+8C3eOLrb9c+Oz3s8olUJ7yZCJok7siU7VWzS+hTW6nFLGJQ9X
 yrY33hRX
 t6bwlQarLsuwS44CSui8qcZSW6zEgHUM8CwNVkOzTKkW56F494NcScz8XWOZsBoextaqEk4dhiZ0x3wh/tMQPfZ8H4dkdxwjw0ouRqr1j/e+jzXDWkSQgppR4/xMdHcBZ3awoIS/CZdurCzWoerwT+e5wgnkIRGeiZLCc4+bflW8TjBfJuS5ZPXsBYE7DlSfT5ZdNWwRtz0W3s11MCkzXAHsIX9zN2dD35tbuT1dLPAM6WEs47NMY+NE8V/wXxXNfAsxb+X+828Gc6QkJuF7VaqvZmHeCt4oJ9RKCcfKivh43BKCmxjvN8ha6HCWoRLlKL4CkoCbLFHKO6tG+rVTWI2jQM3B/bfsg9HuU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 03/10/25 9:28 pm, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
>
> vm_mmap_pgoff() includes a fsnotify call that allows for pre-content
> hooks on mmap().
>
> The fsnotify_mmap_perm() function takes, among other arguments, an
> offset in the file in the form of loff_t. However, vm_mmap_pgoff() has
> file offset in the form of pgoff. This offset needs to be converted
> before being passed to fsnotify_mmap_perm().
>
> The conversion from pgoff to loff_t is incorrect. The pgoff value needs
> to be shifted left by PAGE_SHIFT to obtain loff_t, not right.
>
> This issue was identified through code inspection.
>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Fixes: 066e053fe208 ("fsnotify: add pre-content hooks on mmap()")
> Cc: stable@vger.kernel.org
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
> ---
>   

Reviewed-by: Dev Jain <dev.jain@arm.com>


