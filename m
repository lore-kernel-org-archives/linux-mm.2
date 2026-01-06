Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D69CCDC192
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 12:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9996B008A; Tue,  6 Jan 2026 07:52:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBFF76B0093; Tue,  6 Jan 2026 07:52:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC2D46B0095; Tue,  6 Jan 2026 07:52:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CBA0F6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:52:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6DE4B13B3E2
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:52:45 +0000 (UTC)
X-FDA: 84301528290.28.D92D6B2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 45ABF100006
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:52:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eNtqMy1Z;
	spf=pass (imf05.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767703963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6VWZ/QqZENWpaP5ZlDrRpX55Me1mi2AKp72VpmjbLgI=;
	b=HgmLupAV/lJX1PEhTQ37L9hKi27HUebA7rvNoeTL3KcohMgQSYVO2vBoZEb5tRDQB++Tuh
	ngGH1HzNcWbK4FQKcxFnpCfjc5+N9Xs6RngUadbXVGbxETD6RESltTEhLTHWFrrabftfCY
	6hzCy5OVVESwT+J3Biosqf23NVNkFp8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767703963; a=rsa-sha256;
	cv=none;
	b=5jvscxhgouLoR/q5qqSJFr3DEMjWBT7WF7a54XzD7quYv6zjtEiBzTEuzxOrKlkAWMPLWM
	mfsmfE90UrAHdfoX7JyYt4uWsS8vjlECU8Sv52D1GYvf+SphJokt6vojIAeJP+UKKCIwvI
	tsXS5Rv8jAJaIZcdT/Wx2bb7jtGP28c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eNtqMy1Z;
	spf=pass (imf05.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767703962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6VWZ/QqZENWpaP5ZlDrRpX55Me1mi2AKp72VpmjbLgI=;
	b=eNtqMy1ZvnSFhlRlNZYSS+o56cs7tEvPme2VYxfWqgdQA6ofghPaM2Zx2E1reZIl7BBv6/
	2ryWFJ5TaPcH3+/eHpz3++K4d1v0qXbnD9F4BCTkPxCOHl/mY//u9LPq+AHBrmtSR+ywr3
	lYJkEpJnltx4MgjR40EYhyRmaB9xx4Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-612-iQ6kWQC-MeyBEacBgOE78Q-1; Tue,
 06 Jan 2026 07:52:39 -0500
X-MC-Unique: iQ6kWQC-MeyBEacBgOE78Q-1
X-Mimecast-MFC-AGG-ID: iQ6kWQC-MeyBEacBgOE78Q_1767703957
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 93B92196C402;
	Tue,  6 Jan 2026 12:52:37 +0000 (UTC)
Received: from [10.44.33.27] (unknown [10.44.33.27])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0485830001A7;
	Tue,  6 Jan 2026 12:52:33 +0000 (UTC)
Date: Tue, 6 Jan 2026 13:52:28 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: =?ISO-8859-15?Q?Michel_D=E4nzer?= <michel.daenzer@mailbox.org>
cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    Alex Deucher <alexander.deucher@amd.com>, 
    =?ISO-8859-15?Q?Christian_K=F6nig?= <christian.koenig@amd.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org, 
    linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
    Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v3 2/3] mm: only interrupt taking all mm locks on fatal
 signal
In-Reply-To: <e597171a-cc64-4811-a043-db2e539aaf94@mailbox.org>
Message-ID: <5dfbf2f9-0948-cd59-5c59-a6ee946ff9f2@redhat.com>
References: <b672e17b-461d-16ae-e7d3-45d3c1aab142@redhat.com> <7whbqlfrwjr4z2d4bpny3rjyl5tetdyx7ccf52uvby7hgywoym@6l6m2xcytez7> <e597171a-cc64-4811-a043-db2e539aaf94@mailbox.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OfByKVq9WaLWftpSg42AJSc_GUPvzRYrJhajrHE0sEc_1767703957
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; BOUNDARY="-1463811712-1739719334-1767702910=:329667"
Content-ID: <4dd8c681-f09b-0e56-d450-138c4d923bc8@redhat.com>
X-Stat-Signature: 34ne3j5pzac1n4dfj9cetkc1ytdims9p
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 45ABF100006
X-Rspam-User: 
X-HE-Tag: 1767703963-115480
X-HE-Meta: U2FsdGVkX19xn4xviDJAvoApariGuvpnDEKZHi727i2DZhyYZS1wU+mMQYG+VnRCrbkCHyEv8Y9K8qdH7LGJtokLOMVz8eBbPnBX66Piyj878kO2ucIiXBvMNGGvDHvTYbxvgWFGPoLRgbzNQSvwyTz/xuC2tuZ4QnKlGHtKSXZHgHRFjRJ25AZQ+ZP3SoFX9djejOuhuio4aYItJcb1gTjX9VEPumDmwe9n1W8v3JfD945Da5j3TzAOg5I3Tka8KHJXOpHBpLwbCrfOk7dju/ZqPU+LXTUwK9QaBqIChPDpYn4FMiNukX0KEA1X1Cm7p190NcJNl5rKzYNu7p4FXaIoUE8dr1tA20pYjo5kHZ3k+FrAuT7kyx+T302mhdCKeojNa0zcuAPezYc3Th1GloqPBw6JOtEMkSfYZCqUb5E1Siz4BkSYf2xZU68N+AAF4DVWejWseqpL6DKJxTJD2ROUlBDz72ylPaiNUwW94cGqrpjZHdzechJK2Ae3a7Kka94RYRfduhtjtSL+FkB0/ryb530nkyfxbW7JayLbtgbIFcMnEU6W38zvqZKdugsV3VxDPkYzOwKgRpJB2rB6Ng+s7vImzs3anoGyo1E8tPYBLQQ8Qaeb2u8IHRQem9oog3lkP5cX2kqp6XaXGe0SWiUmdgFqGsBYtZtYMbrD2ASl75pBcGzshCC18Yr4qqv5qgSBFq3qW5tPTreJvFiLDSMUTDvLxLVRHyySyi//hY6PTnRs6V3KfHb0wm96pIqZRTpgPDbfRQ+Fh3OJ0kykRXYht8JrDCGzCsNp4nm4UFV/oLkHCFPPaaAPcNP+SShD7u+OUxnNevLAFuPAn99smPHi6qfFuhJVk57uFo0w3YSJXz/i+3CwgJxQ4tJK1tmIVuiAyMClgSwqJbHlZfgKS5jLiWc6WcQlneZQGhO+5J6i1v+zxM+3OA0kfVlImYT88EmFpKVtkp7ACUgzm1+
 d65zrz/H
 fy/mj0itunQu7F83dCfjKMbZsnAsUKlHAuNViK1W3FG+qvCr+WKfJw4GkjKRqUIS0Y9OwbwJSGluPP+qPRXSbiMPEfDFVHNANxDYkeLBI0Cakns3aG4CRReaUeiJPLX04RJ6dcAGjRYjfo7xFwY+FO+2mchgsY8PVm8TQvt8njUFSyL6AdlMR4UoXfTZOG47Lb5V0x50urxAdItU9aIjRCILuSK4yD8ktzdBlNlUbHGPUkmQ3NZk25Kg2IlZ6umyrk9glZTpGEV24x1jh6wRpnSCWGm8QMnqS23aziVksVIY1AEjgNootPkpjXm2Iav8lUqBGgtSwnY1RdqO0Y8wYf0tl2fzAbP5DeE7iSRJKjBndTSMPupVvbn3zGJBZxH6tdwxmn0TnwNtQRoZsRaKormnIji2h8826LL0xVMWmDsmP4Xjd0yKdl6NcrPl0I1STpafd7TBerdE4kbksQxS/yP3p71Z9Xtgua9RY94Jy2R1Xjxg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-1739719334-1767702910=:329667
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <0b5eb857-a42d-63b4-aa09-99752d29977a@redhat.com>



On Tue, 6 Jan 2026, Michel Dänzer wrote:

> On 1/5/26 19:15, Liam R. Howlett wrote:
> > * Mikulas Patocka <mpatocka@redhat.com> [260104 16:17]:
> >
> > I'm not saying it's wrong to change the signal handling, but this is
> > very much working around a bug in userspace constantly hammering a task
> > with signals and then is surprised there is a response that the kernel
> > was interrupted.
> 
> I'd go further than that. If user space fails to retry the system call 
> in response to -EINTR, that's a user-space bug, period. It can happen 
> anytime for any number of other reasons. (That most system calls happen 
> to get away without it most of the time doesn't make it not a bug)

So, I tried this - just for fun - and the machine doesn't even boot. I get 
a lot of errors about inability to open particular files on the console.

Userspace is buggy, according to your definition, regardless of whether 
you like it or not.

Mikulas

---
 fs/open.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2025-12-31 20:10:31.000000000 +0100
+++ linux-2.6/fs/open.c	2026-01-06 13:28:01.000000000 +0100
@@ -1419,6 +1419,9 @@ static int do_sys_openat2(int dfd, const
 	struct filename *tmp __free(putname) = NULL;
 	int err;
 
+	if (current->pid != 1 && !(get_random_u8() & 0x1))
+		return -EINTR;
+
 	err = build_open_flags(how, &op);
 	if (unlikely(err))
 		return err;
---1463811712-1739719334-1767702910=:329667--


