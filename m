Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 788DDCFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 17:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D923A6B009E; Thu, 27 Nov 2025 12:54:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6A2E6B00A8; Thu, 27 Nov 2025 12:54:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA76E6B00A9; Thu, 27 Nov 2025 12:54:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B85E56B009E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:54:19 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6687D140255
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:54:19 +0000 (UTC)
X-FDA: 84157136238.19.B37C26C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 89F9A18000B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:54:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aIRcwCSY;
	spf=pass (imf16.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764266057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GSEfJvNBtdUsb/OhigVc7Yf2tt3tDvOOP3QtgGRe2CQ=;
	b=id21/ry2QBi1QWXwAMoyJxokGGuhtm1HxO6NoPJoft7qLHLjikqvMKyYRoiOcPmXL/1L8x
	PntIctFmxOX9r3+3u2o4DAx1Zd8GdTj+eCJkWLUSgZY30vIlke2eyF8XEnKsQSSDCx/1TO
	WYyFCJ8UCaQ4j56wQkvmI0ybGU1iRAk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764266057; a=rsa-sha256;
	cv=none;
	b=Q3lYHW5xvbtxI/QgEfA8tX6Vx8i4fUkxMIeJ/mlzNrz4uPa7UmCXdRcLhpDQKjwcHtUNo4
	Q++or3a4Mlj+JgxRoIb5spt3LH6ZFiop+03ahHXRQKrMOyeyALOuaIA6pBGqbLQ4HSHX7w
	TTVO8QAMZDfjtv4BJbiuSpyLgMBlVm4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aIRcwCSY;
	spf=pass (imf16.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764266056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GSEfJvNBtdUsb/OhigVc7Yf2tt3tDvOOP3QtgGRe2CQ=;
	b=aIRcwCSYsYFo71GVrt5rXqm9L6xiw6oArzh2FSHJvANgI+Sbf44Ckk7fd5jDmFnnrMx7zM
	doDA/peO+CzjWEZx+NF68wqC5wTSMf/+0AAP2Si4loDK5C68db/7RxNEfNLHsEWq7+5xfo
	xffr7Pt4p38pw/wMP6Pp2yjI35omBcA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-397-tuD2wo-DMeqk4iiF7eavWw-1; Thu,
 27 Nov 2025 12:54:14 -0500
X-MC-Unique: tuD2wo-DMeqk4iiF7eavWw-1
X-Mimecast-MFC-AGG-ID: tuD2wo-DMeqk4iiF7eavWw_1764266053
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AEBF81956088;
	Thu, 27 Nov 2025 17:54:12 +0000 (UTC)
Received: from [10.44.33.72] (unknown [10.44.33.72])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EB2C430001A4;
	Thu, 27 Nov 2025 17:54:09 +0000 (UTC)
Date: Thu, 27 Nov 2025 18:54:04 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Aaron Rainbolt <arraybolt3@gmail.com>, Milan Broz <gmazyland@gmail.com>
cc: linux-mm@kvack.org, cryptsetup@lists.linux.dev, 
    "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
    linux-kernel@vger.kernel.org, adrelanos@whonix.org
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is
 exhausted
In-Reply-To: <2b8b83fa-5cf5-4f97-b796-0c738ce3a548@gmail.com>
Message-ID: <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
References: <20251111231835.1232ad8f@kf-m2g5> <2b8b83fa-5cf5-4f97-b796-0c738ce3a548@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 89F9A18000B
X-Stat-Signature: 744wfh8qzqd9qkbneoou8xap4p7oeq81
X-HE-Tag: 1764266057-539298
X-HE-Meta: U2FsdGVkX19vFHL9oDfILFJ3RUFQJGiwFz9hxRhcu3gv1Q9nrlAWjOuti+2wr7gFPuLKgx8J/A6c7lepGvgQPiMZrDOG0quooKzhhpNzYn4jJmTJOG56X7+IRBSx2uy3i6XhTHHLLJUDLQVEIVSkuSrRlJtZNkY6ityMQpBP20ilFwFJsVs4FKMXwx8RFl6QC477WxpRAVyZmB9cqoEL4YCq0Vs4nFzjSKrxjXXNWRnFwm2IHOZG2jlvvEkmCcC7QP/myU2MtEnCoHakHbQQuVn9HPb3Bq5RfvyflLc2Y+l1jF6qjcjMBbhXcUYfokdkL7/JZgFlPqPzKgWh2WE7BFoxfzHNqhjbsIZcAq4vw1FgJU5Htr6pHtOIgoOZmR+EmDh+D34cNTpZtlyVygJPLLQYsHe7/482Fbyeywg5HbGD2i1MT1aIteugAHHagU+sEtZR7w10fEAeOmCZ4ky99l7z4dYZA9bk6RNXWXIJFo5kS0bEsmXV71TqRwQSfYX9g+J3N3Uu2dyzXgYf4sYT9ScAkjlrE0bbfbqvLdnW2siHTyOoHk7c4IxCvMNDc3D18ppWc/S5OMp/qUlWy5q/EIqC21+SDxrpU6fSy9Og5UvVvclm8ay/euptREJ6ckDLVPhG+wWtb9jmfrsIg6rNBVCYkk2y5AqsMG9YQFhy5O4krxjCG9/O94EBCgCzXc8/Xde87yBo2P9i+vu09X2fOMGopZv6uafCI/u5g8y1f8XHz1vpFUWijnXQNqf/WHrhnmKj032ja4nJ3BFI0eySuhGRKdFZeveiLRnquzr6kLISrVHMOxRaILcRSVuP4LiMkDuLmKr0CAEghUhDLxjj0S/NVnTi3e29cn9Io8GCvqEq5/g6ufSpn1vbETlnuBRpusHKDMkNa/7yMekvcMjWQ7ULtIjNwjUwOwciOC+I0UI19e6OF2m9c+RyuyqlCBAnADNomS8qdTOccUmLY3A
 xWTHzPLd
 RSDovxg+3c9gCxyEN4VSnWMKNEBPz8j9ZWqsbqHiJsH0l2dLCWcCTXBCc6eR0Pj2QNzlJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Thu, 27 Nov 2025, Milan Broz wrote:

> Hi,
> 
> On 11/12/25 6:18 AM, Aaron Rainbolt wrote:
> > Not sure if this is a memory management issue, a LUKS issue, or both,
> > so I wrote both mailing lists.
> 
> It is not a LUKS issue; cryptsetup/LUKS activates the encrypted device,
> so it is only the kernel/dm-crypt handling IOs.
> 
> Adding cc to dm-devel as this would be another combination device-mapper
> and encrypted swap that could cause issues...
> 
> However, could you please specify exactly your storage configuration?
> 
> From the subject, I expected you to have an encrypted swap, but it is
> not clear if there are other encrypted devices.
> 
> Please paste at least lsblk, lsblk -f output, and also luksDump
> (or crypttab if it is not LUKS) for LUKS/dm-crypt configuration.
> 
> Thanks,
> Milan
> 
> 
> > 
> > I'm seeing an issue with both the latest mainline kernel (6.18-rc5) and
> > Debian 13's 6.12 kernel package. When physical memory fills up, the
> > entire system locks up hard, as if it hit rather severe thrashing,
> > despite the fact that there appears to be disk cache that can still be
> > evicted, and there is ample amounts of swap space remaining (gigabytes
> > of it). This issue did not occur with the 6.1 kernel in Debian 12. I'm
> > seeing this occur in very low-memory Debian VMs, with between 512 and
> > 900 MB RAM, running under VirtualBox and KVM. (I suspect, but have not
> > verified, that I'm seeing similar behavior under Xen as well.) These
> > VMs generally use a swappiness of 1, though I have seen a lockup occur
> > even with a swappiness of 60. The filesystem in use, in case it
> > matters, is ext4.
> > 
> > To reproduce on a system running Linux 6.18-rc5, with :
> > 
> > * Follow the steps from
> >    https://gitlab.com/cryptsetup/cryptsetup/-/wikis/FrequentlyAskedQuestions,
> >    section "2.3 How do I set up encrypted swap?", but creating a
> >    swapfile rather than a swap partition.

Hi

Encrypted swap file is not supposed to work. It uses the loop device that 
routes the requests to a filesystem and the filesystem needs to allocate 
memory to process requests.

So, this is what happened to you - the machine runs out of memory, it 
needs to swap out some pages, dm-crypt encrypts the pages and generates 
write bios, the write bios are directed to the loop device, the loop 
device directs them to the filesystem, the filesystem attempts to allocate 
more memory => deadlock.

I got the deadlock with 6.18-rc4 when I used dm-crypt on a file and I 
didn't get the deadlock when I used dm-crypt on a SCSI block device. That 
is expected behavior.

Note that the in-kernel OOM killer sometimes doesn't kill the application 
and discards read-only program pages (which generates big I/O churn and 
general system slowdown) - if you are hitting this problem, I recommend 
installing userspace OOM killer, such as earlyoom.

Mikulas


