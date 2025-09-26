Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C9BCAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 16:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668408E0005; Fri, 26 Sep 2025 12:04:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6404A8E0001; Fri, 26 Sep 2025 12:04:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57E1A8E0005; Fri, 26 Sep 2025 12:04:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AF1B8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:04:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0017143D66
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:04:26 +0000 (UTC)
X-FDA: 83931873774.10.CD27F58
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 00CD74000B
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:04:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dsj0RRsd;
	spf=pass (imf04.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758902665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hVCe2ZlGmR1JysT/DCFcUZimd9xi/yqqYgUZvqmy0ns=;
	b=pDuaJZ9IsY4Kr7MgnVMzE9j5IDUpA0KwRmThfx/HkRjq0BrduvZer1zGze9teXoZRJv3WJ
	teSxxSUL2qU4eCTLOhJYPsjswWRKIj5QV86nlBLD9O16FVNfMlDJZLE++URgY76IRPHP1Z
	kTPl9yQRL8UmGHr8YOYgh8AoFLeg3iM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758902665; a=rsa-sha256;
	cv=none;
	b=HhcN+Law8WBFqmVaL81VOkJJyV2O9BF2FzalJ+0uyyCVgaI9j9pW22g0zzB9/8dZwnzMTb
	PfVHO+x0QCw+jkiXN21ndCXx4oTftgyPwjGBdB2wjvgAhDGYqNHRT/H4NGqw3M4u4iKO5H
	6NLxhkAQUQftM5+V9lRkEt+3YptJ3do=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dsj0RRsd;
	spf=pass (imf04.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758902664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hVCe2ZlGmR1JysT/DCFcUZimd9xi/yqqYgUZvqmy0ns=;
	b=dsj0RRsdx/k6A/QixPLOBYxomyhwuczUVqkxtFzFj+2lSi47cnP3k2zfrcvamhWXvOb1W9
	Xj4SwGcMSxGe50qJaztHDyBJwTVNg8XZxVzkSlXwvZEcxoSucYYA4PN4m4F4G6sW4nAIv6
	Q1NWZKYGEVpIr+1JhMRef++Qv+0B2yo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-474-m0ThUuqsPk66DxOHWrQ6Mw-1; Fri,
 26 Sep 2025 12:04:21 -0400
X-MC-Unique: m0ThUuqsPk66DxOHWrQ6Mw-1
X-Mimecast-MFC-AGG-ID: m0ThUuqsPk66DxOHWrQ6Mw_1758902659
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58E28180057C;
	Fri, 26 Sep 2025 16:04:19 +0000 (UTC)
Received: from localhost (unknown [10.72.112.25])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 685D31956095;
	Fri, 26 Sep 2025 16:04:15 +0000 (UTC)
Date: Sat, 27 Sep 2025 00:04:11 +0800
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	youngjun.park@lge.com, aaron.lu@intel.com, baohua@kernel.org,
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Subject: Re: [PATCH v2 0/1] mm/swapfile.c: select the swap device with
 default priority round robin
Message-ID: <aNa5e4ziGLWmB1N5@fedora>
References: <20250926155504.5122-1-bhe@redhat.com>
 <aNa5MeqWNJW0afW9@fedora>
MIME-Version: 1.0
In-Reply-To: <aNa5MeqWNJW0afW9@fedora>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tALhNzzCPe0U3KXSmyK7PfzJrLkA4_nfzVOnM7R_XE8_1758902659
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 00CD74000B
X-Stat-Signature: brkahjgqib6diygpj1o7tt7mtzud4htt
X-Rspam-User: 
X-HE-Tag: 1758902664-450187
X-HE-Meta: U2FsdGVkX1+w8feVpG4b0IqqTg6/B2ZHktLG20YdgkYdeGLbtBkzDIqpHGbRF76HbT4N4XfysXsmXNwuVx7cxQGl7AV7KMOJI52GBabKavY7/XO79jIvXZFIMiHZIcgV8eDTzjYucMSqS++wXNsPLpOJsAXrZfS1itroOAU9VEnPOaw8G3dTVzt/3C0iKLeWeo3GQUiO/su+zPE2unJNKYjSGi1OWKF9CQ5x0tuuV0+bmdrzvyAQsi9m/1wVjqhLswG7MMJRmFV7ZgcUCQubx/Nlp5U+zIBqWPNqMmO9+9a6eoZD/U7VAZnZl/nuSw98zhtH4/rrKAiG72Rec+8LHnMw9kRND3mfe9bi8xAFbYR+vLArg+vR3ana/adY/d+3qOK+DD6wtTXnzJdhQndotUxHu63+2u76FRZ/nYq4WFAsg33FIQJx1Rk75DfiBBeewf8dsZu8YgU6mRlV03K2zcMxgcLYuDWA5IG3bHZvF3XRnzGh7ov3tmLdBeGEwdDnmE9JaBFFi4dinSmrgJjRLD4NFaOJdCaFX49FmG5u5s4PN7YR9zaLiGNdg5eJuBzgbciJuY/S7r/TbDd76SLWN5cfCm6M43JYYkex/Hf4ZrqedUfhLtzOMXmvoZ1STume/Sn05vkNvttsFeULOX6anjs8ExWWyk+0DtYcKD2SWrHMfS8rjWkN+nQoJGD7uMPMymnOYhRkQPZu7DZBb+5SLdiB9NsO+MF48d2N9/HwaZ0dgq6eWsg3+S66Y8ah3tf45NhMGZaVM2u9nOkmt3RSchRqhhgA4cieF8KCKzKzBMlunJp0dcHcR0h10XQBOnFKqBsq3h/9oFuSCgSSsYoVZxWJg1owaasrc7rWX4m7y8hXjCIGLQRA4btpjrnMs0fUAHcsrmN7WWw5e8U3Wmn6iShEiLqtIhIRRTHrLiROBgAndW/lpv4tkfzyxLh9wTEZNqFVJPe06EweW1ydTyS
 +icH4s+2
 MJ/D+D89U4SajRX5PLXS8SCRDbj0munv1NbQdqRMfwKvx0VautQ/VT2zt9jKhWzPX0YxLXGGhVnTAvERa2IIZxxIqG4V3yEVpbCD/kJEL3S19wEsgA9v2A4v8iLkQjchFI0UMsh6CartJrj/vJI2snuNszOjHl9NfM4GxlEhaXxB2NVP15oXu9E35OnO+MYPvjHe9QfQJxmfaDC2qdXKa7PKz2sO5zG31YrVLzd+bD+29UPU+OwmykK4qCVVWz/jsls0hp23mP0aBYTZ2TVaZH3xuu4d1Dt1y2IOaly8vTn7sPhhHetl7Eob7ZVtllgoHA+83RGkV9E4sIIDzF3NQodHEWAZ9YCfJmlU+mw+s6MhPep71iZjWGHrLImv+cTvWQcgp9LRfopYlGlnKOfvtToa4ah+T8eB0vw8zqe4d5G7te0lBAgnKvXmhUVGjNWQHvwRunVvE2OA3k16XQquAjwh+ig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/27/25 at 12:02am, Baoquan He wrote:
> On 09/26/25 at 11:55pm, Baoquan He wrote:
> > The detailed information about patch can be found in patch log. Here I
> > would like to add testing related information.
> > 
> >  On my system, it has 8 nodes, 64G RAM. So I created 4 zram devices of
> > size 16G. Doing this because I can't find system with 4 free SSD disk
> > which can be used as swap devices. And nowadays, swap, zram become more
> > and more popular, even default setup, so I create zram to test patch.
> > # free -h
> >                total        used        free      shared  buff/cache   available
> > Mem:            62Gi       1.6Gi        61Gi       4.8Mi       276Mi        61Gi
> > Swap:           63Gi          0B        63Gi
> > 
> > 1) create zram
> > #My fedora will add one zram0 by default, I reset it because the zram size if not enough
> > swapoff /dev/zram0 
> > 
> > cd /sys/block/
> > echo 1 > zram0/reset
> > cat /sys/class/zram-control/hot_add
> > cat /sys/class/zram-control/hot_add
> > cat /sys/class/zram-control/hot_add
> >  
> > echo 16G > zram0/disksize 
> > echo 16G > zram1/disksize 
> > echo 16G > zram2/disksize
> > echo 16G > zram3/disksize 
> >  
> > mkswap /dev/zram0
> > mkswap /dev/zram1
> > mkswap /dev/zram2
> > mkswap /dev/zram3
> >  
> > swapon /dev/zram0
> > swapon /dev/zram1
> > swapon /dev/zram2
> > swapon /dev/zram3
> > 
> > 2) Create memcg with 4G (this avoids noise from other anon process in system)
> > cd /sys/fs/cgroup/
> > mkdir testing
> > echo 4G > testing/memory.max
> > echo 3G > testing/memory.high
> > 
> > 3) Run usemem in memcg
> > cgexec -g memory:testing ~/vm-scalability/usemem --init-time -O -y -x -n 31 2G > ~/vm-scalability/temp.txt
> > 
> > The usemem output is not easy to understand, I will attach my draft
> > script in thread for easing result collecting and statistics.
> 
> 1)
> Yon can fetch usemem from here:
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/wfg/vm-scalability
> 
> 2) In attachments, usemem-calc.sh is used to analyze raw data from
> usemem output, then output an unstandable result. You can copy below
                                ~~ understandable, sorry, typo
> commands to run ten times or how many times you want on usemem.
> 
> for i in {1..10}; do
>     cgexec -g memory:testing ~/vm-scalability/usemem --init-time -O -y -x -n 31 2G > ~/vm-scalability/temp.txt
>     ~/usemem-calc.sh ~/vm-scalability/temp.txt
>     echo "The $i""th time to run usemem" 
> done
> 
> 3) Please keep all the output of usemem-calc.sh to a file, then use
> result.sh to get an average value.
> 
> Any unclear part, please feel free to ask me privately or publicly in
> thread.
> 
> Thanks
> Baoquan




