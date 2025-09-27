Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03A26CAC5BB
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 00:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3388E000E; Fri, 26 Sep 2025 20:15:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59A808E0001; Fri, 26 Sep 2025 20:15:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6ED8E000E; Fri, 26 Sep 2025 20:15:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C5498E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 20:15:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C6F471607C7
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 00:15:05 +0000 (UTC)
X-FDA: 83933110170.10.E678578
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id C0A7C40006
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 00:15:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FBHRle6u;
	spf=pass (imf27.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758932103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N66RsVJXiBlbb/QUvbgFl1wdvUWyCT2EtGwfeQOPWPQ=;
	b=PMC0aLYta2PbTSgRZnThtlNIj/WgbdtcLg2Q59bMxoHkxhGQ/i6LTRB50YLv6UvYqduxR6
	LtB6FsVIDnFlq0I9fodA39Ehi5anzHOyO91KX98tb34KdbIHYVkJbaTVg4YDcr3P+lLMca
	RJbogB0WzzKKTcivPbj5Ng+DAB5l9kM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FBHRle6u;
	spf=pass (imf27.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758932103; a=rsa-sha256;
	cv=none;
	b=7pa1/bFMibbL7LGL/uq0Oza6Yv1Eh08jB7uxeZdD4riKIvrnq7X1f6y+H0tIByntOclJmx
	VchmAO4JK6ozLj5Q343oeiiEG5GDy6CukPBIxxlCniH3IWN2AL1HAzwvmem0Soi6YV1w8a
	ix1Ep3gjcDxb1MLnnq80sdHBNULy3Lk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758932103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N66RsVJXiBlbb/QUvbgFl1wdvUWyCT2EtGwfeQOPWPQ=;
	b=FBHRle6uHZmunC1jrZXK2b5hjHlxRh/PAzyd1x9ig1uo8ZEN054WNHB7SgidcaqjmRKbkU
	huMKsU2ugaMx5EHiVpPEziV02Ok7a8YsZY81C1Qdso9y46idi11cBWHWh0eFG6gjs/PBUs
	ltVL3IF/0VXaDsPmKQsLga14aHckxU4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-653-uzcTgOE-PMW5d9qd8F_NVg-1; Fri,
 26 Sep 2025 20:14:57 -0400
X-MC-Unique: uzcTgOE-PMW5d9qd8F_NVg-1
X-Mimecast-MFC-AGG-ID: uzcTgOE-PMW5d9qd8F_NVg_1758932096
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83C1D1956086;
	Sat, 27 Sep 2025 00:14:55 +0000 (UTC)
Received: from localhost (unknown [10.72.112.10])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E5AC1180047F;
	Sat, 27 Sep 2025 00:14:53 +0000 (UTC)
Date: Sat, 27 Sep 2025 08:14:49 +0800
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	youngjun.park@lge.com, aaron.lu@intel.com, baohua@kernel.org,
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Subject: Re: [PATCH v2 0/1] mm/swapfile.c: select the swap device with
 default priority round robin
Message-ID: <aNcseZC+9ao3KK9z@fedora>
References: <20250926155504.5122-1-bhe@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20250926155504.5122-1-bhe@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TmKCiN-X1LzdCjFkUIVDp96NSupAU0iwZ27y_V9fr6Y_1758932096
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C0A7C40006
X-Stat-Signature: 44meqnrty8ao7oxytzxmb8y6dhcy58m7
X-HE-Tag: 1758932103-767234
X-HE-Meta: U2FsdGVkX196C+CY9SHKOPaLwXixTcdQeiiMLV1QEke233YeiwtQBbxWVhHOO/8QMX3TUgOR2oN1tHw2qC007w4NHwr7dkMB195H5DRmjjlceZE7MgS4O7CdzD15VMdY+0M0d2ElWRE3XhpDwrK2NJb2Q2SX9lTWWGPD4/+Ud1dJUg8AzDJo6Qq1JuvhkGP4Sm/E8KyIFz41C3CFbUUTrfa94Bu/lXxFXKfaQll/1XkuhdNpVTQOVbzzNEQsotfSkSpfKqaKrU/SYhiHoODp5EPDvDHr5Ukr5UhZbRpy7Cjs35NjlEGwNQAcg6nRe8Ri9+hhJ1Hwd0a/G9TuIAZjAMJflI8MGa3c8c8dQx+5ZlUa9dRUcyj87HIBFXmY1gawhvMwwI5CqNAqD5elwBG8tN932Ie6sZZ8fk4J65sdIfL4xTd+rVsKJFhXd+tTG/JV8e1zyY9AMF3bkbqtA1oDaabNzfdN6dxv1Wl+MyNy8CnAchwLKIrvSKnofxWPPjwsoVFhmnRCjMRjl+pc7wkn9H6YPhehEBiA99Z2LNBa7pqlmwJxnAdnR3KWPCYU2XySiwo7EWXj8Np9Qu46Zgu0b8BLjBx+syAXgZkM+JV7+WZ9w3hGhlVUBMMaqbcZN3qnPVQT7zglTtVrudv4K1FvC+rldFoGK5mAwHjay0anso5eiXdxUjbHGi6DJsPr07DZ6d/+Ir8djkGQQENR9FPzmjWQ6q6Vy0nkIG6fEXbWaAIlMBSkLTEWAWrC8coKf10lyItSWBN4O/IcBfjkH9FJPPHuv7fTtayKRDkU57XreCumcJsv49/OEEHQdfFMIwmBpPmvcZUcJrqmF4onsTvpi3x7aRKiK8dbHaYQpDceNYmfSdnamrUYTju/wHlNFSpHoYIj4IS2Pug/RJTzUXKnxndEuVHvGOgmOedrmjUFX/solmnWDw8x7cFg5Y0Tt6jMxxpAiB5w83NhnGc0YMg
 WkXgO70I
 GNfx5Gvfu3AQKiRXhq9GxUTwyyUPO+NoHXNydQ2X1QCi/TDPJJEV5CyfzKLl+C/d135Pgd/XlI32OQlAWSRB49U5x3zTH21J+ru73Z33K1HQL+6OiZT1inGqMWLsQIQgEjZl5nb3jhvtb8+7LW2RXJbPbQqDSYi4IvnuTj0ERCFHU+PGwpnhBpC8kNGkOMANES74hZaxWfdxjSEVY4C+MoCwUxtoq0HnYGtXeWRdVRfJ7nQd35RuR3qjlCxkfjadVD/N9Kl2iFOAlf3uXLgs0jVL093AIEAtaxouQC+6VZMxKRMOeKKyo6k+aRaDJiOSk4tmCP2TT5SmZeBo9h8euoVtImfXH7TAeNrc3gOUDYlLU/0WMnSJpbPY6SgwkZq8vonpZBEh86/YkK1ZaaaNyYKMFqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/26/25 at 11:55pm, Baoquan He wrote:
> The detailed information about patch can be found in patch log. Here I
> would like to add testing related information.
> 
>  On my system, it has 8 nodes, 64G RAM. So I created 4 zram devices of
> size 16G. Doing this because I can't find system with 4 free SSD disk
                                                        ~~~~~~~
This description is misleading, testing this patch needs multiple SSD
disks, 2 disks is enough, more is better. Sorry I was dizzy when posting
last night.

> which can be used as swap devices. And nowadays, swap, zram become more
> and more popular, even default setup, so I create zram to test patch.
> # free -h
>                total        used        free      shared  buff/cache   available
> Mem:            62Gi       1.6Gi        61Gi       4.8Mi       276Mi        61Gi
> Swap:           63Gi          0B        63Gi
> 
> 1) create zram
> #My fedora will add one zram0 by default, I reset it because the zram size if not enough
                                                                             ~s/if/is/
> swapoff /dev/zram0 
> 
> cd /sys/block/
> echo 1 > zram0/reset
> cat /sys/class/zram-control/hot_add
> cat /sys/class/zram-control/hot_add
> cat /sys/class/zram-control/hot_add
>  
> echo 16G > zram0/disksize 
> echo 16G > zram1/disksize 
> echo 16G > zram2/disksize
> echo 16G > zram3/disksize 
>  
> mkswap /dev/zram0
> mkswap /dev/zram1
> mkswap /dev/zram2
> mkswap /dev/zram3
>  
> swapon /dev/zram0
> swapon /dev/zram1
> swapon /dev/zram2
> swapon /dev/zram3
> 
> 2) Create memcg with 4G (this avoids noise from other anon process in system)
                                                        ~~~~~~~~~~~
                                      it should be anon mem regions from other process
> cd /sys/fs/cgroup/
> mkdir testing
> echo 4G > testing/memory.max
> echo 3G > testing/memory.high
> 
> 3) Run usemem in memcg
> cgexec -g memory:testing ~/vm-scalability/usemem --init-time -O -y -x -n 31 2G > ~/vm-scalability/temp.txt
> 
> The usemem output is not easy to understand, I will attach my draft
> script in thread for easing result collecting and statistics.
> 


