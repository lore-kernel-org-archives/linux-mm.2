Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91DC6CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 09:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDA0D8E0017; Wed, 12 Nov 2025 04:52:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A1D8E0002; Wed, 12 Nov 2025 04:52:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2B5D8E0017; Wed, 12 Nov 2025 04:52:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6B8B8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:52:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6ADCC4C93A
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:52:49 +0000 (UTC)
X-FDA: 84101490858.16.FEEDA72
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 626BD100003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:52:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qx+reW0v;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762941167; a=rsa-sha256;
	cv=none;
	b=l8GEt4OacCphDykP6zhG0e9FcK16YAO66EV2zqWNJES0sx6TJoqs2Fi2a4kqGjML8P4Vm+
	L0Jl0jqu03V5vFUW+LZ9MKEtLPoJeCjEvHCRnXJ0tssMsfFZjxxTDgX7OFZ5XvuNiIARKL
	OcLIQMyz99NST+ANOtf+FRBMi3wwvr8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qx+reW0v;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762941167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NhHDG/RYOkgjp1iTZiVveFurISFNmM/HJtxHwxRJDf8=;
	b=JZNtM7Sg6WTtXKRpJRF2Mh5vV0Jc7Ub9PDLhf7z0b5RJ31VheSbrEoc/0Z0/q8fJyn+aWX
	tTG5sf61jzOY053BJA5Wlx2dYoTIkYIQr2FVl77VifXRhKpu5eUA30P8b7tQDLJptcCLFj
	Rb2Gv33HVhfuP2X/tmpB5eQM0W0o/L4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762941166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NhHDG/RYOkgjp1iTZiVveFurISFNmM/HJtxHwxRJDf8=;
	b=Qx+reW0vrhJmkf6ybZN4Ko1CcJLOVr/pMVjQ2m0GU+zaxPqbrHEjFkkN6WK8jZaXywe4NA
	Bml7u5jR9fVvlktTd96f0klHWonWarWAB7dxBl0CgQe13QS0qmvqSm5aS2fRISxp0FWD23
	i4xC3DPaDBE0XoWe6IGdCCYMQlheteY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-151-thKX29d8MDyDCSuebjYMpA-1; Wed,
 12 Nov 2025 04:52:43 -0500
X-MC-Unique: thKX29d8MDyDCSuebjYMpA-1
X-Mimecast-MFC-AGG-ID: thKX29d8MDyDCSuebjYMpA_1762941158
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9FED31800650;
	Wed, 12 Nov 2025 09:52:35 +0000 (UTC)
Received: from fedora (unknown [10.44.34.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 8BECE1800451;
	Wed, 12 Nov 2025 09:52:14 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed, 12 Nov 2025 10:52:35 +0100 (CET)
Date: Wed, 12 Nov 2025 10:52:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>, Kees Cook <kees@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Will Drewry <wad@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Serge Hallyn <serge@hallyn.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Yafang Shao <laoar.shao@gmail.com>, Helge Deller <deller@gmx.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Adrian Reber <areber@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>,
	Alexei Starovoitov <ast@kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	tiozhang <tiozhang@didiglobal.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	YueHaibing <yuehaibing@huawei.com>,
	Paul Moore <paul@paul-moore.com>, Aleksa Sarai <cyphar@cyphar.com>,
	Stefan Roesch <shr@devkernel.io>, Chao Yu <chao@kernel.org>,
	xu xin <xu.xin16@zte.com.cn>, Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>, David Hildenbrand <david@redhat.com>,
	Dave Chinner <dchinner@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	David Windsor <dwindsor@gmail.com>,
	Mateusz Guzik <mjguzik@gmail.com>, Ard Biesheuvel <ardb@kernel.org>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Hans Liljestrand <ishkamiel@gmail.com>,
	Penglei Jiang <superman.xpt@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Adrian Ratiu <adrian.ratiu@collabora.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v17] exec: Fix dead-lock in de_thread with ptrace_attach
Message-ID: <aRRYzb2FxHzpKhms@redhat.com>
References: <AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <20251105143210.GA25535@redhat.com>
 <20251111-ankreiden-augen-eadcf9bbdfaa@brauner>
 <GV2PPF74270EBEEDCF80CEE0F08891ED37BE4CFA@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <aRM2POTDTxEzeF2F@redhat.com>
 <GV2PPF74270EBEE16FE36CF873C5C2309A9E4CFA@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GV2PPF74270EBEE16FE36CF873C5C2309A9E4CFA@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 626BD100003
X-Rspamd-Server: rspam07
X-Stat-Signature: j6y13wpsxgou4d9qs8dk98somcruuydw
X-Rspam-User: 
X-HE-Tag: 1762941167-516462
X-HE-Meta: U2FsdGVkX1+pW/OSj+W55JFTtFs2OSodBXkyVKYDKAv/jt26UWZWx9yi26lvPW4JiWRvFVx0ezqQCya4t6SLVFPFysa/KiixogEmIpu7LyYPSqmPwCzlzRDv6gO9nD79GcdOnIlPF/FJx5/N3pJRzWJUsfCUFbkdgziqP7Sm+w9BhE81c9zoLSvGQr8rL1DTZhYGgxR5snDyqp8Yh6CxoFMxFeDqx/QTV0bXxSjRgyfqec1pzaKKQ9VDnwwndZ3773ydOHA+XlTw7GGlR35fmiPmv7kkBvcM11abWQ9xfFjLdqpBWthmSHJDGTq/c96wXNCVu1blR9qHp/5kETkcN+pOoPVI4PYcSlaVsOb+MHBuXIRCjp1le71B1LdvlrAwcsKrg6PRedIG+ECXqOQXcd+H43N1nlwhfVuDzlfHTqmjLD/BrH+KbPlxcuPPSnRkTM6N6Nzvaxp4WLiq8NmDg7IX2nVrtH0qjoxnkccHNTuS1zlxA9zMMOtuEPQSYs2SMvCYW+xKRcnWqNeaPHG5KiTkEwyy0QRER7KDqwG94aV+/HNWyB/6bZGl2ZSpidrWLpaFwn2Gh/VWeKf6DTF4LOTd+BZ3t4UEPB8Lk+2yTEyXHhKO0e25UygCycK0IYWQoHYnt0fFgkKvAmmNr4R90EU5tUhbi6mwTc9MsMRvWYr1iNwRxwMoiLDQvssNBEG3ln6ZYNF3rQ1uY8F7ZbDY/wUVjgm6lqAlaqBAR2XAJntfD7OTm1PLqqqYSHkUn022gbzb3V5KdQ7n8BKj9J//7dJt30OMHFeo3I33Gj4RFkn3tlUl0ojGbVH8zt9os3XAYc0BkfBBTck8QI+XNZLA2iZ3AXbI5nA6L06k50KAQROQz+TdS3tWBEbOw3o5WRd/VK8Ws6AZw1xQectgtCW6FEHFbhTGq2RWKu8yS4tRXm4LQbxr0Yr4oXd2pGUq17OZqSNbtHvjYv8RDJH9b+Q
 ASFtn+WP
 oaMHTwwXjM6S5yptGaFyHdZN/dErdf0DKQ3Npi/yju3OSTJo6sK7TJGR+qDipWDx/NiRQpuC0aC4Fl6GbOjdbXmiOQKGIaYuQuW3WtGnA7vxkU+mo2ynk1YruKDFZAcOunV8bIIMbPtGp9ZiJSFvms4w1xT1n8Gblb3eGHrboXR7soawi+c3lqA0uoBJMxCk2EOymjomBUU+FAabvKdLNiY2njRcPKdjvWfdEGyzM1lp3P5KKUjaPtRh5mwlr0D/k594FsbXxuIL9mcC4vyVsNsVoifNPc1xsGaRtSuKVTVUjKnG5te+JxmjzEye3U4dMPH3yHbWYaAW3JfP0DRXpX+8vDQTpu1oyw8mlLrqV7NgimO14btLjxP1BorSWFCFOxR8FdatkbuWdXie0Uz8sZ0xfIdnpWszLC/DWOuAVbOzdR6ca+gCkkCXLKLPgPJ7Dgy2QSrlhBNBo02XQ69uMLv7s2FetPnvMcqKFfV/ZJWlpzZoTc8kSxbsn6glM1cqJAZMC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/11, Bernd Edlinger wrote:
>
> On 11/11/25 14:12, Oleg Nesterov wrote:
> > On 11/11, Bernd Edlinger wrote:
> >>
> >> Well when this is absolutely not acceptable then I would have to change
> >> all security engines to be aware of the current and the new credentials.
> >
> > Hmm... even if we find another way to avoid the deadlock? Say, the patches
> > I sent...
> >
>
> Maybe, but it looks almost too simple ;-)
>
>    164          sleep(2);
>    165          /* deadlock may happen here */
>    166          k = ptrace(PTRACE_ATTACH, thread2_tid, 0L, 0L);
>
> what happens if you change the test expectation here, that the
> ptrace may fail instead of succeed?
>
> What signals does the debugger receive after that point?
> Is the debugger notified that the debugged process continues,
> has the same PID, and is no longer ptraced?

Ah, but this is another thing... OK, you dislike 3/3 and I have to agree.

Yes, de_thread() silently untraces/reaps the old leader and after 3/3 debugger
can't rely on PTRACE_EVENT_EXIT, so unless the debugger has already attached to
all sub-threads (at least to execing thread) it looks as if the leader was just
untraced somehow.

OK, this is probably too bad, we need another solution...

Oleg.


