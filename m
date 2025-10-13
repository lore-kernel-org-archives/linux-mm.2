Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8DC4CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03C468E0011; Mon, 13 Oct 2025 04:00:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0143B8E0002; Mon, 13 Oct 2025 04:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93588E0011; Mon, 13 Oct 2025 04:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D91018E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:00:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D1B88611E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:00:31 +0000 (UTC)
X-FDA: 83992343862.24.2BB8366
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3A8B940012
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:00:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DTgCzLUY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A2YAIP6G;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DTgCzLUY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A2YAIP6G;
	spf=pass (imf12.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760342429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8t58zwnbBpGazmpfJwigZplemtrFKud6dUJScz2Wcb4=;
	b=dMnS/FWbhUN/X028/wTEHh3jNwMLGWH5yMEMXvFoRgULuRM/NEdG5QRFS6eY9GW5V0jy/p
	JK6WnCmctDOyxKJud0udKHbvGyuyPx4jjGLzBglXwfeLfujI0kJ2opZ5coewB9nj8KHA3z
	/HZkaz07nzWTWEH/nXSfvQAqUJ/HYyY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DTgCzLUY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A2YAIP6G;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DTgCzLUY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A2YAIP6G;
	spf=pass (imf12.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760342429; a=rsa-sha256;
	cv=none;
	b=nmazd86iSCla6YcHUeQ71e/VdFHIa0CjDM/ii82aRQagED2QPsqGI/PAiU6eJFrkNEf7jC
	U2ddUCcsl5vqP8ekli4GF3gwx4RmwL5oiGOxWSDe4Sz6xU5rnLPDDu8z0zO9s4twDlomJE
	GTSYvUTU+rtm0KcXWCwpY923UkvFvDw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B156621221;
	Mon, 13 Oct 2025 08:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760342427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8t58zwnbBpGazmpfJwigZplemtrFKud6dUJScz2Wcb4=;
	b=DTgCzLUY0ad8E5MyNbrkArk0eE/wvMEH12RuNqcAtldq7n1aIISIhF4rhVLK/BXvFxNWxv
	+2c7Z2NMawHiyT8aQ+mdEekUeye61OKJTiNRcZcQ3sbIkqpulexnVZcalAGWkwb3so4qA6
	dTXYim4ey1ywpKU8Pl8cYhT236rDqDM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760342427;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8t58zwnbBpGazmpfJwigZplemtrFKud6dUJScz2Wcb4=;
	b=A2YAIP6GqGRuraijN+d6sG5wlkWRahixq2bxKuvr+idEKO30rEGNHV9pl5Gy2ltlDrTMX1
	cnlGPBGK61chaLAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760342427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8t58zwnbBpGazmpfJwigZplemtrFKud6dUJScz2Wcb4=;
	b=DTgCzLUY0ad8E5MyNbrkArk0eE/wvMEH12RuNqcAtldq7n1aIISIhF4rhVLK/BXvFxNWxv
	+2c7Z2NMawHiyT8aQ+mdEekUeye61OKJTiNRcZcQ3sbIkqpulexnVZcalAGWkwb3so4qA6
	dTXYim4ey1ywpKU8Pl8cYhT236rDqDM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760342427;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8t58zwnbBpGazmpfJwigZplemtrFKud6dUJScz2Wcb4=;
	b=A2YAIP6GqGRuraijN+d6sG5wlkWRahixq2bxKuvr+idEKO30rEGNHV9pl5Gy2ltlDrTMX1
	cnlGPBGK61chaLAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 02ECC13874;
	Mon, 13 Oct 2025 08:00:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nsRjOZqx7GijEQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 13 Oct 2025 08:00:26 +0000
Date: Mon, 13 Oct 2025 10:00:21 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Usama Arif <usamaarif642@gmail.com>
Cc: muchun.song@linux.dev, david@redhat.com,
	Andrew Morton <akpm@linux-foundation.org>, shakeel.butt@linux.dev,
	linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com,
	kas@kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/hugetlb: allow overcommitting gigantic
 hugepages
Message-ID: <aOyxle8OJPMKlVWX@localhost.localdomain>
References: <20251009172433.4158118-1-usamaarif642@gmail.com>
 <20251009172433.4158118-2-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009172433.4158118-2-usamaarif642@gmail.com>
X-Stat-Signature: rrh5im6wumx8wz9155pk9apnttytn8zi
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3A8B940012
X-HE-Tag: 1760342428-969357
X-HE-Meta: U2FsdGVkX1+4HW4tRIP6IUw1pH6MPnzzvGGy9n7NEthKI1fR6b3HCPjieTX6bAoSEtlwiHs10GylajhsuBCB2S555ifJ3yHE8K85dpDCMXpxoPOVGsQ5YyTXUfqXNrxH1lhV0mlKgwGxORfoBD9ddLRYpH7TF9K3xR/idhyGfboYK6a+TFe+JbYlmgbcQeLlWUdsx8gc57z2wXDS8pjInC0FILgzuSK1RgkMUMrtaOYKnfPye2hZLoroFEOeOnqgo9oG11qN/fO4WzjirdWcKr7h6lDZ2SbfWOnIzghsdf9Ez6D0F0LaZ4SUXrZxPvsSMTqAaimJEz7c+Ne1VSyrMjPfmOaSzsEGZvexegOZejX/I1I2UK73rIPcAV7jcTy7DztsIcvqquJt/vBShi8rL4tKy/dQYqdebDJgGyDwlnPcva/w3kfj7MBgixRpXUvSDpOeFgR1sSD9jyqzQVoOv3t0fJ9JiWjOS6cmySyOOIsylIejfavPG+N8JPMKV6ZsRAcLsbADljcA1CqIaN2rY4wdM2sTyK3TrsmPhyKz6WexFXhH4eF25Ffre5qC1899ZuzVueVjHrrFTLyZwKZdui4h5OTPpiXgxW4h+HtFbQZbEw7B2Ki5w5aNEKNbB5AqisJBY2a8sLdNuYOhFg8/S26IdMHyQWcmg4M38ezw8TD/igITheLiXBCU2SDYl/SY1BYqBCh4+jgKtrTZ7RVsuOFW1sP4iIErgqPrQz1y4ek1yAErSZGrrnl7Cj3ewAU8yGdpDROLnDU3BxtlZmL+o/gFZWQzFd20XvPvqOAsbXU8s4CzKdCU6aarskLG7/+81WTzIzGoifdqm9kRqVXKKIGdByj3IGVq11PjkSI/aZG9M5crjJ7eNAfqwNIPj8R82jZirKkqzY2NTyhrCBhvtmwTt+UUstmzamX6kryW9SgysdD/VXYu+nds3kL6Zbg9+IksPXgF5qOvlSBPiKO
 ZohKzxv3
 CQ5izQSyygURQ3uJywy/vUGkzmdNCv2BTuKoyc+4EImTrhv48ARsuPaTMu8nS3c+HXUSsZSKe0EFMITqzkiJWN7EK2TJrNrNjlmG6LGxk+SQb925LpnUCTkjiDbf2aZY9qKj8dy2aFkIufQzfk+irK9++yvEzsjlQEJUFNuMHur7soSJYcoVEvc8gfp8BN2GMoXIDF0gbaslSO1MNV4DQyTOVTCCustpspvUJIbZpzZBh0rnQw92IkG5EIHSffamUjuZ8gjc8d6XlB5j+2S2AykTe3Fu+OSTKAfJg5UwRgCDWtDVMT7R0MiiTijywZ/2gUUye9cLrM4vVzITFmt9x5G65+gv3fI2d4W8K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 09, 2025 at 06:24:31PM +0100, Usama Arif wrote:
> Currently, gigantic hugepages cannot use the overcommit mechanism
> (nr_overcommit_hugepages), forcing users to permanently reserve memory via
> nr_hugepages even when pages might not be actively used.
> 
> The restriction was added in 2011 [1], which was before there was support
> for reserving 1G hugepages at runtime.
> Remove this blanket restriction on gigantic hugepage overcommit.
> This will bring the same benefits to gigantic pages as hugepages:
> 
> - Memory is only taken out of regular use when actually needed
> - Unused surplus pages can be returned to the system
> - Better memory utilization, especially with CMA backing which can
>   significantly increase the changes of hugepage allocation
> 
> Without this patch:
> echo 3 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_overcommit_hugepages
> bash: echo: write error: Invalid argument
> 
> With this patch:
> echo 3 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_overcommit_hugepages
> ./mmap_hugetlb_test
> Successfully allocated huge pages at address: 0x7f9d40000000
> 
> cat mmap_hugetlb_test.c
> ...
>     unsigned long ALLOC_SIZE = 3 * (unsigned long) HUGE_PAGE_SIZE;
>     addr = mmap(NULL,
>                 ALLOC_SIZE, // 3GB
>                 PROT_READ | PROT_WRITE,
>                 MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_HUGE_1GB,
>                 -1,
>                 0);
> 
>     if (addr == MAP_FAILED) {
>         fprintf(stderr, "mmap failed: %s\n", strerror(errno));
>         return 1;
>     }
>     printf("Successfully allocated huge pages at address: %p\n", addr);
> ...
> 
> [1] https://git.zx2c4.com/linux-rng/commit/mm/hugetlb.c?id=adbe8726dc2a3805630d517270db17e3af86e526
> 
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>

I guess nobody bothered to do this after we added support for 1GB hugepages because
creating those at runtime is tricky, and in my experience, almost everybody reserves
those at boot time.
But I do not have objections to make them behave as normal hugepages:

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

