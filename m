Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC2FECFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 11:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 439B56B0008; Mon, 24 Nov 2025 06:04:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411D16B008C; Mon, 24 Nov 2025 06:04:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F6A6B009B; Mon, 24 Nov 2025 06:04:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FF346B0008
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:04:44 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE82612B18
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:04:43 +0000 (UTC)
X-FDA: 84145217646.24.EC2BCA7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id CDCA1100017
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:04:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="D/l+DZ4P";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of rjones@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=rjones@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763982282; a=rsa-sha256;
	cv=none;
	b=EbdKs4dQnwuYswiJr6C0UBQOdkstP9DOOpoklWr1sdPXfIZsYIQONiAs6YrNvbgTomgw5z
	2PyQfkXrUbR1PAfEHSrsZouiNF8kqkLaxjX79TppUDQThFRV7MTZSa+k4yOhFcPkISXJbq
	QcJowmCOaINh/CJAG+tth1ZqCyWaqnI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="D/l+DZ4P";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of rjones@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=rjones@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763982282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dj4aD9OHkRc+idg8PqslDsENxuTCxgqBYCZ+pFPNN/8=;
	b=GCOt7hgRlz0ITMJdRyt1fJq65U0JzAhRGDiDTbfSZRYh9qJOEB5KcQ5kZHnPpy1ytgH2+v
	Xd4ONmXJO4bCoVRs8ePyDiTeGIbc4f5MxDWbknCPiViykp0uYGCFCu5eE6PJLsElZCimdW
	cMgflup3MojLuEa2EZIHgSoFencjQkM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763982281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dj4aD9OHkRc+idg8PqslDsENxuTCxgqBYCZ+pFPNN/8=;
	b=D/l+DZ4PLk0Px/FQnN1NwOFFpgytAMdTH4F6C4VWpmLzhCiWYeksTtni0Z4/5GgmxsM3hx
	4s5uTxaSAJtnYz561Jss98VS800UgKtD9Hzj7Fiz+J8MPAyn+WPJtR0S3v/FhaccuLXoVg
	q6YU63uslDc/iw3ksQPRgj+hQ+annls=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-150-HY_Y74OnOtiQcY1b1TE0NA-1; Mon,
 24 Nov 2025 06:04:35 -0500
X-MC-Unique: HY_Y74OnOtiQcY1b1TE0NA-1
X-Mimecast-MFC-AGG-ID: HY_Y74OnOtiQcY1b1TE0NA_1763982272
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28B741956054;
	Mon, 24 Nov 2025 11:04:32 +0000 (UTC)
Received: from localhost (unknown [10.45.224.26])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2E0743003761;
	Mon, 24 Nov 2025 11:04:29 +0000 (UTC)
Date: Mon, 24 Nov 2025 11:04:28 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
	Eric Dumazet <edumazet@google.com>,
	Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>,
	linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>,
	syzbot+e1cd6bd8493060bd701d@syzkaller.appspotmail.com,
	Mike Christie <mchristi@redhat.com>,
	Yu Kuai <yukuai1@huaweicloud.com>, linux-block@vger.kernel.org,
	nbd@other.debian.org
Subject: Re: Userland used in writeback path was Re: [PATCH] nbd: restrict
 sockets to TCP and UDP
Message-ID: <20251124110428.GA13479@redhat.com>
References: <20250909132243.1327024-1-edumazet@google.com>
 <aRyzUc/WndKJBAz0@duo.ucw.cz>
 <20251118181623.GK1427@redhat.com>
 <aR2JjR1yKHCCPalO@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR2JjR1yKHCCPalO@duo.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CDCA1100017
X-Stat-Signature: jpcnx5sufrp1ziyfz84ndmm4pw1yi8si
X-HE-Tag: 1763982281-805182
X-HE-Meta: U2FsdGVkX185hvXGKnlEnUeoaNWaFDUAfoRT4xVwBhlImiwgMsQHMq4wqYbfRTz+UGuZA2QjbLEO7klf2UpnttPIv+4vkCSus65TVtT7Kcci2ttOCCEY2IJc7bkwmCwrbv8TekBaY8kNNiGcxevLG0dxFl2P8ev0lL0ZSRbcX26IwBQtoddomf/HLF++WfpuIK8MGZExoM4iRB+2qjGjvgwvnDQvbDU2kIo6sZxAQgxOasMS7y7Yq2AYbyzISPOHfcnYVXlrmpJUd5hgBarLuZD3zQDj+KAiqeErm4j9SQYtW13ainiFlG84GrWqAxsSNV1tnlzSIMeXdta6POzn6FcaZeTnWtGqjHdyo5Mx9NS5Bsed0nCGypOprTyUpKWwsSSqCVb3IJdbBQMbQ2BAOGy71KTwJBd5u501Hye8FHufzy1Rqni8sqJobrht6ARxPk9oE+EQiFst73QZjdFYAWKpF1CN/bbk4UQkZot/X9GF/SrIUn5+65dhDYK1OjTBB3WYp6Ye4cjT7TpyDngefO/Rb4NLdWtFNg+3qEMBRPqlVRqgu6r6NNGh0J+Rr85YmPQksKZxyOHN7F0Dv9YJGaFOF3L/q5GBRI56cRj5UYOCmeXhMH/8aJbgs2x1CpIbYp6IJ1eoVrK1B5FtnVAP+hcQm1XkcTfXpoZZbhtLVABRcTkKnTiEB2yUTdUDsc6gEHEoUFa6sHm1B0wFxhprN+es1VjuBF23Lbn1s82jykbDvuaCQHpZu5fwcs0h5Yk6psd6PwvL9C4pw1KUBmzj1rD1lKWNdh/8iF6TY0xtb03qkwozSdoekVyKdnze6MNFnAUPx6D8rWNPCjwjqsawLZqpCbxMI1CS6wyq2Km7ZNlduCglDE/S9EBIf4wQpa6/vIsvynk78Td6YgEtsgroYK4/q5rebwUPcn/dnI2pJPTmWPsYt1Hi2oeCrvWVguB48mApLdwkhjelo8VwMNY
 kTKV7Efi
 Hx8qXOI6Avpt0TCy90jmVyz7K3OhXiLjyeyddA9Aa1/wYV2KA87S0uDieAQduISZew7htOysCwI2EVcRzqH7cx8HG8VFgbQakiHI8F8ftgZ+c5Gk1fCjW9BtY3Y9EtV8ruldo+fUrbmxjV8KBpdPollLcRU6VAKpYn4nJGME9Oq7NQ78YzPGnhP01oXYA+JNJVoMg5gB1yBs3mdLVwRSdk/YlRatsdwE55XK0dcJIp8bShPhPIuPC13qQ+PG2mNfacX5LDg08SXI/gSiPVHcKdWgFal9tmRcyL+9dg8lIgO6xR4nLDgmNZLx+3PfujWjKbtBN3whyAR1EyXLploLRGFLcy8uGHkysaCCQHL+BdZ2IJI1ZXZkY4iUcCl994xVr+vLs+1i+ADtj5u32KScTiaY82yKptWVwvBHzSWaUCHv3fDgu6AMEiKhEo96NWgakecZAOqDorCpExurjn2TfA1+yr0rqx6WKVTidnXOhUD/vRSHF1+tzxIbGM89cjO89kiKWGjnatlX/OGVaOjWXkK634u7XrooHhxZ5nKvDcdteT6qThX16AHnFey/MWkuYVN8l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 10:10:37AM +0100, Pavel Machek wrote:
> On Tue 2025-11-18 18:16:23, Richard W.M. Jones wrote:
> > On Tue, Nov 18, 2025 at 06:56:33PM +0100, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > Recently, syzbot started to abuse NBD with all kinds of sockets.
> > > > 
> > > > Commit cf1b2326b734 ("nbd: verify socket is supported during setup")
> > > > made sure the socket supported a shutdown() method.
> > > > 
> > > > Explicitely accept TCP and UNIX stream sockets.
> > > 
> > > Note that running nbd server and client on same machine is not safe in
> > > read-write mode. It may deadlock under low memory conditions.
> > > 
> > > Thus I'm not sure if we should accept UNIX sockets.
> > 
> > Both nbd-client and nbdkit have modes where they can mlock themselves
> > into RAM.
> 
> kernel needs memory. It issues write-back to get some.
> nbd-client does syscall. Maybe writing to storage?
> That syscall does kmalloc().
> That kmalloc now needs something like PF_MEMALLOC flag.
> 
> mlock() is not enough.

There are loads of use cases for NBD over a Unix domain socket that
have nothing to do with storage.  nbdkit supports all sorts of purely
virtual and remote devices.

Practically, we use this feature successfully all the time without any
issues, so we'd appreciate it not being broken over some very
theoretical concern that you haven't even been able to demonstrate in
a test case.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-p2v converts physical machines to virtual machines.  Boot with a
live CD or over the network (PXE) and turn machines into KVM guests.
http://libguestfs.org/virt-v2v


