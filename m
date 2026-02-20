Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5A12C5ACAC
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 16:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 112906B0005; Fri, 20 Feb 2026 11:03:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9036B0089; Fri, 20 Feb 2026 11:03:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F01C66B008A; Fri, 20 Feb 2026 11:03:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D771D6B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:03:25 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6D585576DE
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:03:25 +0000 (UTC)
X-FDA: 84465304770.14.844845A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4CB7D12001D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:03:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KglBC5WO;
	spf=pass (imf29.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771603403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XK6eKrk/MEL8AorixobkPUMbfSElLezdgSmbF9o/oW0=;
	b=0TRIIq24b/LN1wCLIGdCycnAr0+NIeRON6KnpekNJM046tXBFhrPyjS26CaNasjLumNXS8
	Teyk/zE1JeKyZGpPm9Y/OiqSXHRfgPwznVK6CkELG7vlUvnY5BMcP8vSMZqZZsBjxoUp74
	PwnbqkxmkZjmR4SNErEJMidnv/dwklY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KglBC5WO;
	spf=pass (imf29.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771603403; a=rsa-sha256;
	cv=none;
	b=KFjmaX7uX4EiNIDs5VsPTnTn8yRLTS6raEp8yCg65AWRtB5R3jS6DzLWZ5qBL5Gyk7lZe3
	NFr98ob9d/2ntNjkiGHaTizfAk97ec5p+Wr24HrW0zlti+W3TdgYrZJvA4Obg9MYBzgi4m
	odvac9NIK+9TDJIpHa4PiIg9hBtQohE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771603402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=XK6eKrk/MEL8AorixobkPUMbfSElLezdgSmbF9o/oW0=;
	b=KglBC5WO5RDPfAyCtFSFCX8HVcKA1pNY407+2s8IqX/n6QxQskswZSufiTHBQiwXz5PQY+
	oq7phUPL6L2Zad34h6uHEoHJNpdWwH4R7zD+VSBXlJNz88DbADe0vRFjxHo6CK6DzKIM+S
	xyGasOs7xvmtRi+b13goKtovivpezQ0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-43-pdCMByvHMC2r1zPa4njmzA-1; Fri,
 20 Feb 2026 11:03:18 -0500
X-MC-Unique: pdCMByvHMC2r1zPa4njmzA-1
X-Mimecast-MFC-AGG-ID: pdCMByvHMC2r1zPa4njmzA_1771603397
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 40D3119560B3;
	Fri, 20 Feb 2026 16:03:17 +0000 (UTC)
Received: from localhost (unknown [10.72.112.8])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E9035195410F;
	Fri, 20 Feb 2026 16:03:15 +0000 (UTC)
Date: Sat, 21 Feb 2026 00:03:11 +0800
From: Baoquan He <bhe@redhat.com>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-mm@kvack.org, youngjun.park@lge.com, chrisl@kernel.org,
	kasong@tencent.com, 21cnbao@gmail.com
Subject: [LSF/MM/BPF TOPIC] swap_ops and plugable swap back end
Message-ID: <aZiFvzlBJiYBUDre@MiWiFi-R3L-srv>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XWomtx192IMkjgLEKziYjjyyepsBQQiLPlW21hh0xfw_1771603397
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: ekma1dk4nd5j76peaknnm69zqtbocibp
X-Rspam-User: 
X-Rspamd-Queue-Id: 4CB7D12001D
X-Rspamd-Server: rspam01
X-HE-Tag: 1771603403-362721
X-HE-Meta: U2FsdGVkX18iVO14ucWUZoa80CNNuTR6Vjp+PH7JMgiXtvZPCQY+xejAioSjtEJr9HZlipk2Y72BKcTL3eFznGswAmmwN7UophtDRpJe/vNmjHZev+2Cs28d0xoDZO8HAjUxKMPrpIFS2quIdlrtCm2WfFYFnIFBnC+5GhE/0bz5Vpo7PHY+MnDb0EW+Hu6c81gCgTY+9JrpzOzznuRM3Z081riD7NP3N4O0bBIjN5jK4XKzxM21i0jloApSQp79LyPksUZB13H+/ujN1/rMjjM9mlcgMxVRsgm3iTWG/2vNm9vAktaiylv7j3C/TybqilxBAFl6xSFbB64zoeiXTd/vRe2d47t56HkPviwEe8oVzdCZukMKKAePD+pWDUFMXe7oQlWoKhmd1k+Bfm/M9QA4cGx2pLaJ+lNRfXUPgZjXsv6E3O4t71C8bkbgg51MzQEHsVY0ZqZoUvPljhj4y8Ebr3/kDHdUeXu1GdXfHGQ+Q9iuvFouQAv2QzGuMsPb6nkykbK98bPGrVINKgZZbXcrgc7iSP0QmYYvGODoH7Csr4dxILFM7Tqib4WIWKOJ+yauHI1J7IptMFyIPLAnrt6Gkuz3lN//cRxZQc6clOggpD0EZDx10ToQwCg+hIpd1enwXLNPiUQK7rRg8Z4bZ57JuTsenylsR/fbLXjwmYOoCqfunT87/OVGEf2uHvtagFo8HFV+8B1B175rI3N8a27D0y4yDqr0pFz7Blq9zJmzTw27uXq53kfBIf9dPr9aq72GmBNFywW5AXK2+gxHEsXeYdElXTzxcGNHtQrEt+qlwWW2Q4zh+pPUIl8JwLYghdLXRd/n74tyszdrDdB6m8PL5lGVKoZRa0OfnyEjAUTHit3ohzJqGk2EtvJvnq+G9DCObpyeF9ruP7Kn19jzoE3PaT6Bjx8TbIm6BpCdCRvyX4yHY1AP2QhQ6qRi2Z7hGTuIQxX4dgVxqec5Vbt
 Nwx+6jPh
 XVHeIoFCWpElI0Ni2V4Y21+XMn6dLj2SCtywelnQnBo1qkYWCbp8gW57tBwwb2g0jSkm4lhoaonqiia+JmUprv61gBCq/WG+AUlMrltxBYQi4Ls5YxlJsJ+g247y7fveASiko04KSDQUU7/PXh26hzH0E1kSI+YgYkhhKkB0BIyzbcnhmt1qEBgvO+IW510NjqmHlfgnGZogLGk5lWnZ9WxDr0tGK3bWouLXZp8eGW7nEFCE2j6iRtkHguM9MZGTTJtg4LjbcWmekP1gPDBYEUQJukP62piOtpuINa/ubXoQrQYKnwcgP16QCE4pObl1s24Dcz9HeW1SRu5JCLFmF9JUEP7pg5KCWgnPUxPL67dUCxJ0HV8SqnDrjP0H77Orz4RgZtPh1Lsw+F2irikdd0GJcRRdE4wVqcrprfI5hgo7RnSRa4E65579gr1FAnLwhqpMO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The swap_ops provides an unified interface to allow registering
different swap back ends to coexist in the kernel with their private
implementations of how the swap behavior was handled. e.g. the "flash
friendly swap layout" proposed by Yongjun in another LSF/MM topic,
which is more about flash related swap. I want to dedicate this
discussion topic to the infrastructure to support that: the swap_ops.
Another potential user is Android, Android team has been wanting
to swap out compressed data to reduce the amount of the IO needed to
perform on the swap backend.

The plugable swap backend is somewhat similar to the file system.  I
hesitate to call it a swap file system because it is not a file system
in the traditional sense. The API is tailored to the swap specific
usage. Even though the swap entry looks like an inode, it does not have
the concept of directory and does not use the VFS data structures. It
uses swap tables to keep track of the frontend related swap metadata.
(e.g. swap count). The back end can choose where the data is actually
stored and how it is stored.

The typical operation includes: read/write a swap page, allocate a
swap entry and maybe more.

The current core swap already has synchronous block device vs
asynchronous block device. Those can be moved into two different
plugable swap back ends. These swap_ops expect to have no additional
cost to the existing swap behavior other than calling through the
swap_ops function callback pointer.

Discussion:

How the swap back end was chosen. We can make it a swap mount option.
We make the swapfile header look like a file system super block. The
different swapfile header contains different back end types and
options.

How to handle storing compressed data. e.g. data from zram directly
write to the swap backend without uncompressing.

How to allocate swap backend's private swap entry meta data with
minimal memory overhead.


