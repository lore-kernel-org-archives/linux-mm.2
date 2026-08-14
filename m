Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F15AC5CFDB
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 11:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288C06B02FD; Fri, 14 Aug 2026 07:53:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266E26B0698; Fri, 14 Aug 2026 07:53:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19E226B0699; Fri, 14 Aug 2026 07:53:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC04D6B02FD
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:53:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7DF5A1403F3
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:53:02 +0000 (UTC)
X-FDA: 85099713804.24.161240E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D0A15140003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:53:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gTuLOlFT;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786708380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMPXz1F8eswiTGlsgow1v7rds46igEflwXLyq/T1LlE=;
	b=EsEoyiSFpr3Yd2rGqWdr/Du8Tbt9iTa10Bkgas1YSPlTNf3oeFcetOa9oXNvR/6k9yIjVG
	rUUDHxc1Pk1RgxtCWFZD103eEYxo3VQII6Qh07FGitDSX98/S0UaU9/PUIFTL3sWJZA7hm
	m9JZdvCG6V/zx8M9BV85YvtKXjtWq8Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786708380;
	b=ZGpHsBojmQCqRTG/PHlxEhVaMzib5CCx30fMTF472ibeT1O/BXTrXOQZI4EIX0Z6U1wQOX
	If+6SzYOj4C1fhweXHSa0BxTYThzSu+/krVF8RVAkouqSctWkCCbHPnk/OYi+OJp3AF8X4
	XlWKP5Z7Bu6p2Ak4CjijbJR/aMp3gcY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gTuLOlFT;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 298B743E69;
	Fri, 14 Aug 2026 11:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F151F000E9;
	Fri, 14 Aug 2026 11:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786708380;
	bh=yMPXz1F8eswiTGlsgow1v7rds46igEflwXLyq/T1LlE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gTuLOlFT5ZcbJKM3iotO6nTMlL3HVcIq0iJXTR6Qyl6Qf+YFK0jc33Mh6byeqDuy3
	 P1yPMu9LpYLGaIIhWVYxmNudp0Wa7Cfcl3xqiq+eYI3vLJPN8ob2SCTIq3HtmWaIv7
	 RRZN5AnWhkraSgRuj1qv3/SWCXioq2zb3LU2WdCdjyDUxpQdEY/uLJxlyhprxjoaFY
	 tRqpuiQgAjkyAbt5vc3JwmH2XSNMl6xt9jQhvuoxMb17nxuCYw9w9eaCX6koebNZiW
	 yq42za+B7R0X0q6+cSUeCbdcLqod/gfWyjbqd59tBYcRoGdLSao49qvB0kHYJ0D4S6
	 +cElYC/uDF8dQ==
Date: Fri, 14 Aug 2026 12:52:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: linux-mm@kvack.org, geert@linux-m68k.org, daniel@thingy.jp, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Subject: Re: [RFC PATCH 2/6] mm: nommu: use vma_is_anonymous() to check if
 vmas are anonymous
Message-ID: <an8Bdv54k2B1o1c2@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <20260813063401.1786548-3-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813063401.1786548-3-thehajime@gmail.com>
X-Rspam-User: 
X-Stat-Signature: qrsdafop6tt3d8h3ttskyrmybnc1hsj3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D0A15140003
X-HE-Tag: 1786708380-233201
X-HE-Meta: U2FsdGVkX1/zgUlB1BBxtnu9PHNg0Dn0W2mr4BZq37XZ5JX09KCgrJbrg/z9Um5AWC4oc5M9EdPp6m9KRRIp1bo7ou363diUwYnrauP67mFFmOxD0IX+5fOYVdZfEW6irw57dWlYgYudf3uDjCkzRi9uBPOSIo/gNqXAl3H9pUkHJX7g4ltx3SCDhTGaFNbn8d51qamyKzp0Z2yw+3JzvMWC26Bp9dQ6MxCui7Le76LjcCwWJRz4uAympOmqnUsyZrWdCdioxbn5q5Ah5HhXCs7QSkWlrKhYzCRuVT2hJDWAhUsa/Hh5yR7LZFZ73Hw/o3y4oq5YD7ZQ08wm+9pc/UYd+K3xYQOdZaeV17l6vfHyfAq84o4T247XPiJZLjqy8nAknrHXVZXn9GuihYbU58x6IhDzXh8qpsyPx4lpaUyBsATFpHYEqDytvM2YcnroiGV1glHwjoQZBCIIgVeH0z4+z/RofiCFa94RdwMKBezWk9TJqISl+EHlvHFE8CnD8+fBhiH+UXosFmTpmeaGNSU9g9MSzB7UGOUE14R+/NEfHci/cPGiVTlitcKRDw42yIRmFVFywFARzNfGs7T8K+CHABNgPAvemm5q8GDI6UHcZPtxyrkXO+6a1NnIpfscnhOIsDI6qRx4mdnJnyPrdqzy8uI04gHpS7lZQb3bPSB3j16694Ktf0jZW8JOiGV+Prlq3D55LBeX94PWFh4KESqwjnn0a2A8HYU7ll2NFa8rsIyYwhtXGP+sYqFxera+dgtCwa76omAWhdi0esWwBkioNWQr+oXpifwV/VRZX3gLtXrSrrl1Fp9+0a7ww7iCn16yQzdRuW0R+7ULDsZGmK1WcRMBli8IVnKj3IaVgZak76OCN8aX9FrgQt+ZhCIA0QjSJU28ipIA6Zot4MSHplyKV2FRsCJchBXrA3VaezV+G2Z5Jh6KIXvnNq4ChMG7KIyerX9vxGE12pHw3Wq
 AAoZZykT
 cdbMzct6P43hHvYyFAHXk6Coy1dgGGFYXYdKsckTCbLuPWR3qqKjXA+sSM+ODdHLmtN+8YUyTA/AfmsVr16GNUb+gEzlsWqhUKvY2Aa8UXQxvN6EcT3LLBp1gEqi84XxVHhywhlRrtk98ZfwKFNRovVZL7p0/Lvrc2GN1fB7ESpssomJ2BtTM6aAs1/AquRaRHw2fDCKF4zdRLryvbCefI5evnLDmdTzKZkIhL+4fiWA/iWEn2TwuOcdfo5RoMwU6Bq+LecC4XHoZcvtLvWn2hzyKTko5otlQSGZCpNlnqIUnnUh6j25H7vDlAKqTOdgsmNd8cGeiTT35pg8atN1nXBzLB+z/Rwint3o/Zu6PELvHy7RxkExhMTfsZr8Dz/iX4OafaqrH0x+w/5zZaUYuu6TZXlcId9iu5yndMSjUzLBnvb8FZG9RKFgxF/q1EjUNH2yfP/RZEt9iphFzm2XB9Gptyl/jlPqXzTargUL9pO3NXB/hKPmBMs9BKHh1IHOq6jJ/+1JEtkNgXoHkIPmKTqhgtg0WfMTqrcDIujwXz8m2KGG2enB1QRjxvzIEKmANsIIlYR1dgXIiY4Mk6an5v7lt/dT3M3dh83Ar
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 03:33:57PM +0900, Hajime Tazaki wrote:
> Private file mappings (like those from /dev/zero) can have vma->vm_file
> set but remain structurally anonymous since they lack vm_ops. Testing
> vma->vm_file instead of vma_is_anonymous(vma) might cause mremap to
> return a spurious -EINVAL when userspace attempts to shrink these
> mappings.
>
> This commit fixes this issue by using vma_is_anonymous() instead of
> testing vma->vm_file to address the case of /dev/zero.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Cc: linux-mm@kvack.org
> Closes: https://sashiko.dev/#/patchset/20260710054648.924005-1-thehajime%40gmail.com
> Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

As staged in review on 1/6 you need to squash this somehow.

> ---
>  mm/nommu.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 89444ee2aca6..e40990e15831 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1196,7 +1196,7 @@ unsigned long do_mmap(struct file *file,
>  	add_nommu_region(region);
>
>  	/* clear anonymous mappings that don't ask for uninitialized data */
> -	if (!vma->vm_file &&
> +	if (vma_is_anonymous(vma) &&
>  	    (!IS_ENABLED(CONFIG_MMAP_ALLOW_UNINITIALIZED) ||
>  	     !(flags & MAP_UNINITIALIZED)))
>  		memset((void *)region->vm_start, 0,
> @@ -1328,7 +1328,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>
>  	/* we're only permitted to split anonymous regions (these should have
>  	 * only a single usage on the region) */
> -	if (vma->vm_file)
> +	if (!vma_is_anonymous(vma))
>  		return -ENOMEM;
>
>  	mm = vma->vm_mm;
> @@ -1484,7 +1484,7 @@ int do_munmap(struct mm_struct *mm, unsigned long start, size_t len, struct list
>  	}
>
>  	/* we're allowed to split an anonymous VMA but not a file-backed one */
> -	if (vma->vm_file) {
> +	if (!vma_is_anonymous(vma)) {
>  		do {
>  			if (start > vma->vm_start)
>  				return -EINVAL;
> @@ -1617,7 +1617,7 @@ static unsigned long do_mremap(unsigned long addr,
>  		/* like do_munmap(), we're allowed to shrink an anonymous VMA but not
>  		 * a file-backed one
>  		 */
> -		if (vma->vm_file)
> +		if (!vma_is_anonymous(vma))
>  			return (unsigned long) -EINVAL;
>
>  		/* vmi_shrink_vma() needs from/to pointers to be removed,
> --
> 2.43.0
>

--
Cheers, Lorenzo

