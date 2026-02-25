Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D258EFD20D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97ADC6B0092; Wed, 25 Feb 2026 03:57:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952316B009D; Wed, 25 Feb 2026 03:57:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87E856B009F; Wed, 25 Feb 2026 03:57:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 730076B0092
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:57:34 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF50FC1F8A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:57:33 +0000 (UTC)
X-FDA: 84482375586.05.08079F1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 056F78000C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:57:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NXOrTgw9;
	spf=pass (imf30.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772009852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GanXkJjST8p9TrvQUdc8dnJl6GmI5zogzlDRKcNNJtg=;
	b=0kZeQydPkrFGrMGAlGwz7z/Cw6CAQXCGcFsU7rkZ55+chUU5vKtEOuoUgjZc9kRgWe/c1+
	QBEwwtU220dabGdGsUlcQUV4WW6BHtn3WneDOiOFiupDUzCW3WnZSisjTbXI5+olChFr93
	uDGFzhr3h0TbJ+LtmLXjN8r2TT7mIr4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772009852; a=rsa-sha256;
	cv=none;
	b=TArFY4EBhUctvMiASgGcFHS7sv7uTTJJZkaV+2tMtv6ZpjrOpw05q1s8k7wMAcenTX+oHt
	e+M2aRuhbw2tN3qYEYZ6qyyEI3U1bzWCpThhs2ZHRHjr5RSV5CiQlnkum/aI1wue0PRhF5
	d2Xch4fXeuUocYlVIZgJE+j//SoH/Nw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NXOrTgw9;
	spf=pass (imf30.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772009851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GanXkJjST8p9TrvQUdc8dnJl6GmI5zogzlDRKcNNJtg=;
	b=NXOrTgw9nkDXuVnzwVx2/77yEq18WPjVbi65R/TSLC8gZDK700OXAc6GoABpDIpIOOEHmL
	tlRqhjEAS9V7omULVjcIzdLloxGJgTR6ZSuR6cBAll2YZxb1yh4m7gWWhig6mA+snnW1mm
	G01QkcN7MM0O0ievuY/6AcaE433zFIU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-507-FGNCDzsOM22o-VbrbTemxw-1; Wed,
 25 Feb 2026 03:57:27 -0500
X-MC-Unique: FGNCDzsOM22o-VbrbTemxw-1
X-Mimecast-MFC-AGG-ID: FGNCDzsOM22o-VbrbTemxw_1772009845
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6078F180025C;
	Wed, 25 Feb 2026 08:57:25 +0000 (UTC)
Received: from fedora (unknown [10.44.32.38])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id E428D1955F43;
	Wed, 25 Feb 2026 08:57:18 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed, 25 Feb 2026 09:57:24 +0100 (CET)
Date: Wed, 25 Feb 2026 09:57:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Kees Cook <kees@kernel.org>,
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
Message-ID: <aZ65bWeZWanmJblL@redhat.com>
References: <20260224164852.306583-1-ptikhomirov@virtuozzo.com>
 <20260224164852.306583-3-ptikhomirov@virtuozzo.com>
 <aZ63F7vHRKw9qZw9@redhat.com>
MIME-Version: 1.0
In-Reply-To: <aZ63F7vHRKw9qZw9@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: OvzAtXUvY_Fizrybrb4rVjkp32N1aAAVWBd6O4076fk_1772009845
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Stat-Signature: uuecrt1pdmmqg9irdmfkkzenmdo1tpmn
X-Rspamd-Queue-Id: 056F78000C
X-Rspam-User: 
X-HE-Tag: 1772009851-131798
X-HE-Meta: U2FsdGVkX1+w72upOpoVdJrKYzltdFVk2WmlmCzQ/ZNU/TGiYwr+bcr5/1n2jVpAOKpKZTNwmw6S3qUs5GR7UsFYbqciFGWB71rPnvx2Af+c/JehelY92EbtKHN/FlSDfAm+j+TUaFTE0XTISeJ0IzCU93+bfISqufPPeDyE7+1ffOX7eYw8k67qkXX16988ba/COodDDCzKK/EZiAl6GQhsuTj5JypgA6dZvLUiPT1Y+5dEmN6MdL3e/rWJYurMYdNV3MJ/+7D3ukf1Iize/H5CQr6Sd3W4KUlLDOEfvMo0G0816wcLgal9Cowpe2IJIkRdCToBgzou3RJsC1MWyeGvcxLB/WIsjGP9nRGOf2CAVVVdqYwx7QPYmk4Iz/nPTo63ICRzRsXFzdC6W3Wpn9BzHfWfrAjohBq98eg0mYf3SJL90tl50v/dCgZo7VRtYIWm8bNzqaxKFCoQhYbppyFzftb88A6eWDeaU8Zh0kH1qamIFto38+dozegJWypadqqCOMVFdGVjV3b5xxTFLHj2n67uGP3abSDLbPlAJOO3UD8wk7wdQzZmHt2de6cfeudf2hRflNzqU7RADrX9CeeZXawOF0N+3UV4BnMl0m8XCPq6pKfLaLiSbMQpzHzQs/p8lX7Fj/t4r58OIoz1eFxrBEg8bR+Iwx9n8YiX1+KrgC/9iHjxRHPStsuJFmhz/GmECInVnlnfhfpRCm86F7FrBCoWGYHLEo4dSfDAISvt8SciwfE1j8BPFt7iEWptEx2s27Vbr31rwtOa0ie5M/W4hn5O/8ZkUrJvjYnW+lrzy+k+Nsd3FzcnPaTYRN6DRyEISk+FFqMw0lBpJ8rFUCj7NwF+o36EcNB1zdXl9S0MPB6TttPFTfN7gi8X/jTVtucP3/7g6bmzgtusMfD23Xu+AthDKEmB01f2uN+HkI/P8r1Id7seBWBSkXrHh0V7uUAdCeQdebJDZkDusQd
 iWPqT+w0
 AYQG7ucltzaUpTP+MCL6/RKgnOLJufB3M+oHUK3590MspnTbNtZdLivBWtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/25, Oleg Nesterov wrote:
>
> On 02/24, Pavel Tikhomirov wrote:
> >
> > This moves the condition (tid != 1 && !tmp->child_reaper) to after idr
> > alloc, so it not only covers that first process in pid namespace has pid
> > 1 in case of clone3(set_tid) requesting wrong pid, but also if idr
> > itself gives wrong pid for some reason.
> >
> > This could've been the case before this patch, when creating first
> > process the alloc_pid()->pidfs_add_pid() code path fails, so that the
> > idr->idr_next is non zero anymore and next process calling to
> > alloc_pid(), will get 2 as a pid from idr_alloc_cyclic(). Effectively
> > leading to init-less pid namespace, which is a bug.
>
> Yes.
>
> alloc_pid() does:
>
> 	/* On failure to allocate the first pid, reset the state */
> 	if (ns->pid_allocated == PIDNS_ADDING)
> 		idr_set_cursor(&ns->idr, 0);
>
> but this logic is broken.
>
> Suppose that a task P does sys_unshare(CLONE_NEWPID). Then it does
> fork(), and fork() fails for any reason after alloc_pid() succeeds.
> If P does another fork() to retry, we have a bug.
>
> So with this patch we can either remove the code above, or (better)
> improve this logic.

Damn, no, I was wrong ;) As Andrei pointed out, free_pid() will clear
PIDNS_ADDING in this case.

Still I think the patch is fine.

Oleg.


