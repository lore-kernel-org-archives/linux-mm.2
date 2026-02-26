Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B73BFCE086
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 14:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66CF16B00A4; Thu, 26 Feb 2026 09:02:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644956B00A5; Thu, 26 Feb 2026 09:02:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5711D6B00A6; Thu, 26 Feb 2026 09:02:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3D8CD6B00A4
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:02:39 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E02261B5C26
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:02:38 +0000 (UTC)
X-FDA: 84486773196.26.949975D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id A631BA000C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:02:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SGwc4xmt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772114556; a=rsa-sha256;
	cv=none;
	b=HswPDkDo/pezmicw48alXoeRW5rzn8JCt7uxZSvfG/aVsEH8BXpTJ6CPjmKNnz15BF3s43
	//7FtlD/xnWMR0zG0qJsmL6Lyy7m001I28wRDTIYJL0WN3qLxhmnwc3HRFJ2iTVnbFtgtY
	msxNsEHfnzLv35QG65po86i/TWRGVYs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SGwc4xmt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772114556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQ41jwqaTpbsu9nZCnt6Zy1FX5m9icmjt6wuVuOZFyg=;
	b=ZcK5ySzRO8ni30slWk2Ru0SS9dgYp9KYmMYnDs5zB70LLFwOtU8MT3YUx/0GyEgZqt+9jA
	f9LSSqDwJFwBIlwRN4Pn3M+6TpNr3gvSuZzB+Fo5e3Cp7SLjpHbm6nfXjLL31cqrCPcQyD
	V47WwwQuvRnI9cByqOjbPpVDN1p+ZM8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772114555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EQ41jwqaTpbsu9nZCnt6Zy1FX5m9icmjt6wuVuOZFyg=;
	b=SGwc4xmt7bLzHPcO3/rL2lO+da8Du34AcRApJzWdKIfDn43z5YgEyppRArfJpzXIE+p+pH
	sZThzoSlrgHy3Y7kxOv5SJNcqygqbGYQaT2URK3H4lhMTQfdnOfuSYNmA81yIfs1ulcH87
	fmcidZZJPEwryhf6+Ext4mDMPRswrao=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-632-IjRME0-pMcq9mV5s2vUwDA-1; Thu,
 26 Feb 2026 09:02:30 -0500
X-MC-Unique: IjRME0-pMcq9mV5s2vUwDA-1
X-Mimecast-MFC-AGG-ID: IjRME0-pMcq9mV5s2vUwDA_1772114547
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C687818003F6;
	Thu, 26 Feb 2026 14:02:25 +0000 (UTC)
Received: from fedora (unknown [10.44.32.38])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 33EEA1956053;
	Thu, 26 Feb 2026 14:02:17 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Thu, 26 Feb 2026 15:02:25 +0100 (CET)
Date: Thu, 26 Feb 2026 15:02:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrei Vagin <avagin@gmail.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Christian Brauner <brauner@kernel.org>,
	Shuah Khan <shuah@kernel.org>, Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>, Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>, Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 2/4] pid: check init is created first after idr alloc
Message-ID: <aaBSaIqErOamW0n-@redhat.com>
References: <20260224164852.306583-1-ptikhomirov@virtuozzo.com>
 <20260224164852.306583-3-ptikhomirov@virtuozzo.com>
 <CANaxB-znXjfh5s9ro127TGONsu6PieuaJ1vB3PMVFeV4Eo8pkQ@mail.gmail.com>
 <aZ67mwBEbRtdaWp2@redhat.com>
 <aaBAn-r7A65f2ubP@redhat.com>
MIME-Version: 1.0
In-Reply-To: <aaBAn-r7A65f2ubP@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: kqLrsByJdyLgeVJgSznZKlv4KEwopwFYnNiJ2TEfmuU_1772114547
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 4rzhwdrtd5ci3cis9w9myrno4nnj7sdm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A631BA000C
X-HE-Tag: 1772114556-620129
X-HE-Meta: U2FsdGVkX19a9GU53CbPe3jBRyiNF+VQKLrY8YN2tfrplzi5J310jCHR+x3DuEW0ib8ecMGFfNYjb9+4C9ghnocY4VwIgoiP/VGRODPflqmwZAsMyREtp6PBKcZTigC4N07wKbga0h2kwF2KQLl59O7NUnutn4Qj8w/iNoOLgLa6czMMwQal0o6aaK3yxL7p/kbdmBwbXj1IyYWVyVyTL4TvfIZNr3Wv8K9n7Vgdfq4Pbs37O5ZLl8RZzOf0R+ktUNayJCKFX6ehrQXg6SkX7yMz/ILm7aHYYEwnIkX7z1K/96o0RSGlPTZKqHPEcWP/mjpTy0aUCP/uUAmW6z4xEGkVWr0UZOt4H7YmUhJHoR2kFLwH+u3WVcHcfwkA0UTVZr+7dku2kD+eY8XtO2+QmEYVK7nvZx755M5OvC/3N3NHySZvpKjp3sexgYI6uQrPkrpXKotSqhVUCCDeySVobk3NCsJm43N0ee9uo8okQiLH2NkXqTo1kXpRrgsI9P2cRW7y4eFD2PO7YuVN0SCPvq3wAfR/QsANRMtdOD/C0Vpuv7ghftGvryVkOzJTc+mngoGF+x6u5MhvGsTPTLOzdws9M6jgHNnJq69MxIR/94tBLdvmoDiTAuTu/ZkTZObLBq6A8k8W0GrbUg1k1gc6r+v5eaEhKqGMbXWccCuo6DJy9X7C4rBGOgJCvTWolaZnpxuXcdz5kHsyM+TgnWBRr8NGbVX4xOYP9jo3qeGZMcQnm1VMF7c6iNAHbOlF3KudRdmt/+P7Q41yil1cuhmByM+FQ9gOpPBOwXUqZxkQna63K02hastVZjHqEIcTX5bF+Xs3Vv6FvjPO/Tr5DikfPpIJwxEv3xfXefDNbx9OoqyKL0n78emorlH3sEPlWXt6iemoJHo2gQEL/A5RCPTXuYFLuv4z9QEZnsugjej+lXbIelHmjVZ0uM/pQSZVuyvyTBbN/lR9L/ncFWlwJPx
 Ji89lhci
 wmwA68M9bdIb6oA4ceEMe0ZAPpvF7kQEkm8tdmIant3l8KcUOOqmZojYAfFrkAdQsLF4Qk+H6494o/QXIxEZcvu1Zz5CZCXFCZfvUfpk94e5OJRR6PJPVke88uz+Q3leYh9Ywqs7LLoB9rKbFZxQ3maKWaKWNErJJrEA1fTOPrPcqsrr82+qLkyAISaGXT4Z46UJnUF7o7SlnzmwyPPM3zkAkp0Qpdu/Tcj4PeCK4Jf8ZJqO1I6tbkPGBNFFgi/Q8EflF81tdOj0stsNpIWKUWcPdUqr/C5NQKYZVObzzr0SKgT3ncnuPjCsLgyQFmh+Xdxo78YSqqmyjyjkuh0TY/7Fswr75KK7UhPjF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/26, Oleg Nesterov wrote:
>
> Now that I look at this code again... Why do we bother to check
> "pid_allocated & PIDNS_ADDING" at all? copy_process() does
>
> 	/* Don't start children in a dying pid namespace */
> 	if (unlikely(!(ns_of_pid(pid)->pid_allocated & PIDNS_ADDING))) {
> 		retval = -ENOMEM;
> 		goto bad_fork_core_free;
> 	}
>
> I am going to send the patch which removes this check from alloc_pid...
> Need to recheck.

No, we can't remove either of these 2 checks...

This probably deserves another comment in alloc_pid().
Oleg.


