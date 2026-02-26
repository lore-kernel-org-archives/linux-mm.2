Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B9D8FD8FCA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DD196B013F; Thu, 26 Feb 2026 11:07:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06DA76B0142; Thu, 26 Feb 2026 11:07:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6F86B0140; Thu, 26 Feb 2026 11:07:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFDFB6B013F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:07:36 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 858451602E5
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:07:36 +0000 (UTC)
X-FDA: 84487088112.11.255EB0B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 63415180012
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:07:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TQGmilGB;
	spf=pass (imf16.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772122054; a=rsa-sha256;
	cv=none;
	b=P7MXK6IqwfIbVOu0d60DxGWliJYczs6FhUs5hNqLtFKNRw8ARy6D4ZSV3UTSCZi3rf0uLZ
	XawMqiN0smyvuflMZntgDNPu1qHafu29+TuBm0iHLStxus0ALtCOjQwQSZUFxAb1SWlWKs
	w0T48YJ2AQKAYJOQCD8dS8GMWv5jEmE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TQGmilGB;
	spf=pass (imf16.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772122054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wTxTJ8cM0yh2HdAk2Wp3EOLk+A6tHQBQ8oXmToz4bsg=;
	b=fIUBREv/jN95BdigbWyulvpT6Vj2D784iIUx2rzkBJUImBFDjXX4kUV94xgPgbcywwSChs
	G0fFwGmXdX6hRJH4sNrcjHZfojVpYEZ+5QgZR82qfQEWtgem74259Ley0Ki6SHToNb32sD
	UOdrSSyK8kHw9ayA13kuwa2JhD7FShI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772122053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wTxTJ8cM0yh2HdAk2Wp3EOLk+A6tHQBQ8oXmToz4bsg=;
	b=TQGmilGBxq49Bb8YOXEuDIjb0Vjkq7aZyJyvv6RPNnOmIvo4MjgVB27n2opc6K1kf7AEYW
	ifgKzMCl4AkqaImxU1Jbg6iVNuYJs0Av3P78vhnYwTfuo7PU/sm9dU6mZTmykREf23QZYU
	QkjtgMWVocB01uyrPmkfpBTHaeCfiR0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-495-R2Ypp91zP6S3qLZxgWU9VQ-1; Thu,
 26 Feb 2026 11:07:30 -0500
X-MC-Unique: R2Ypp91zP6S3qLZxgWU9VQ-1
X-Mimecast-MFC-AGG-ID: R2Ypp91zP6S3qLZxgWU9VQ_1772122046
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E26A01956089;
	Thu, 26 Feb 2026 16:07:25 +0000 (UTC)
Received: from fedora (unknown [10.44.32.38])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id E5E5B1800465;
	Thu, 26 Feb 2026 16:07:18 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Thu, 26 Feb 2026 17:07:25 +0100 (CET)
Date: Thu, 26 Feb 2026 17:07:17 +0100
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
Message-ID: <aaBvtX7px-htZcYW@redhat.com>
References: <20260224164852.306583-1-ptikhomirov@virtuozzo.com>
 <20260224164852.306583-3-ptikhomirov@virtuozzo.com>
 <CANaxB-znXjfh5s9ro127TGONsu6PieuaJ1vB3PMVFeV4Eo8pkQ@mail.gmail.com>
 <aZ67mwBEbRtdaWp2@redhat.com>
 <aaBAn-r7A65f2ubP@redhat.com>
 <aaBSaIqErOamW0n-@redhat.com>
MIME-Version: 1.0
In-Reply-To: <aaBSaIqErOamW0n-@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 4Iksx0osVbqVpSrLAFITRqyz_2jHiwquVuUtFJ1-vuQ_1772122046
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 63415180012
X-Stat-Signature: ifetpzc4bawackgdkqpcmteby5k6d959
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772122054-487981
X-HE-Meta: U2FsdGVkX1/W8B2nx7k68eydJMhk4f8x8UsptQiN4/3Iu3yF18T2Uv9urBgqVtZ/lqX+mczvwuUcc8d7F93tso94VzsXvSxpUfX0hnZsyqF021tQpgj1DCj4cfsF0gsdneqddT9O8TX9te2qIRUpLN42iLRRFkamwl0TJ5EK8TZdEeHLAmKy8c/aGDl8gKoBiC31U2uB9s31M3U5+hyrWxnqdJJ7GoRk0iJuyilr0z7lOT66C2fVaXteN2ONxWn4BrC3j1S9KqQA8d1Mc7LcbBpTwMRkdE7poZV6pyel0xZRT4/kpAPAJ7Rzqj0T8rfw2cqb7Pp26Fu+Zd6NioqFKCCZUpQaej9b34ODhb4R4XvoYaFClepC+hkhzvfStUaJdqp6xkbFCMz1ZL2FNuu6PoHmRWdd6oAPVZ5d1EPRDFR0nSZW1w8CkxabC5E6rwikJU1ezi4nrikxS7PHbLy797BS1a7U/jjPsxtBM3sPPw2RGz6wE4G5SX3lelhF1P7zwbgctlhDSciapB2oBJbHIU1rdrztJakG5VFgj+ifwdg4A54I5GTBD/sZd8ohLs8gZkYMGilFZOvyjC5qLuLrSKmdyjgi1s3gtmjX5goAwSStahztIK7LSpNSKg9wdSN9Gfuf+a7SK9ZcPw2qlbcyxDHUSJYIhojn8NRASnOL7nlQ6zQyH2QjeD7Is2PTpT40fgmpPnKw2lD22DVXaEP2sQLfUuoBk5vy/3WMqkQL2+QmxF8U3l+VOBrffL83CGoeOVtDqc0WAfkUr2ogseJE0G7ChzD0WX8LKJhjatvrO0dMopvcZheUa9+EecpV7rSAWPtfy8NtNSLt7BuMscq0//IbuXtIQYAWzjaUBD949hEitm/aWPU6QyOXKmTNcLkg1yvcGIZLfJimWNdlKCR9KB3M9uTxb/vPXWgfs+raPdLeh8WS09WayBt57wIBQhVuq6YK3X0E1ga01T8rFYI
 NC2WyL4s
 0WEXKKdMELK7VfESKjm/+SgZTD5puCP+Be5S2rCGxfirDyLpwdLFKkgmJTkaZ0NbS5xnOR+hTyRgKlgMXJ+Dd80f/shF45p56TCYK7cKq1gd6IT3bANFAc7wBpmISoOmGhJDaqOmNToBPisyFhVV1Aoe9MdBKZmA3oc0xazPDQr4AkIqNs6n7z3v+X3TU6GrSU2K5dqk/2uTO/R4/pmHxEk6jbUdqCHfaphwy4ZPOjgUxbcoJ+rUEB2ArG3bFC7g3zj9/p6kV60HSWxpwi1JKDyDNZgakGpmRQ7cda81TVxUeU0dcY4OkRJcwa8ccCktVttu/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/26, Oleg Nesterov wrote:
>
> On 02/26, Oleg Nesterov wrote:
> >
> > Now that I look at this code again... Why do we bother to check
> > "pid_allocated & PIDNS_ADDING" at all? copy_process() does
> >
> > 	/* Don't start children in a dying pid namespace */
> > 	if (unlikely(!(ns_of_pid(pid)->pid_allocated & PIDNS_ADDING))) {
> > 		retval = -ENOMEM;
> > 		goto bad_fork_core_free;
> > 	}
> >
> > I am going to send the patch which removes this check from alloc_pid...
> > Need to recheck.
>
> No, we can't remove either of these 2 checks...
>
> This probably deserves another comment in alloc_pid().

something like

	We need this even if copy_process() does the same check. If two
	or more tasks from parent namespace try to inject a child into a
	dead namespace, one of free_pid() calls from the copy_process()
	error path may try to wakeup the possibly freed ns->child_reaper.

perhaps? does it look clear enough?

Oleg.


