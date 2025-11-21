Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3F7FCFA477
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 07:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 119CE6B002C; Fri, 21 Nov 2025 02:19:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9A46B002D; Fri, 21 Nov 2025 02:19:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED4956B002E; Fri, 21 Nov 2025 02:19:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D8B6B6B002C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:19:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F0BB1604EE
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:19:16 +0000 (UTC)
X-FDA: 84133763112.12.2AC045F
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0F10540012
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:19:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of ebiederm@xmission.com designates 166.70.13.233 as permitted sender) smtp.mailfrom=ebiederm@xmission.com;
	dmarc=pass (policy=none) header.from=xmission.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763709554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9pngaLztQQ+2iBDbtnCkL3ZEzgZ6M0cpCANSfVb4nGM=;
	b=65SkQIlUdsz4x86Ev5XA4MnOBSjyQy4tOcfsHtGR7HkcVPlEWJxku0Y9qoH6Y7j6QTA2nV
	m8frLq2b6tNxrDNTuPQ8V7mHmK718ywEFAcQWXuqynV5cX+w+2beH9KxQu3xCVElXUCN3s
	63pLW4M26PiqfpGre+n3948be7Kv9C4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763709554; a=rsa-sha256;
	cv=none;
	b=TSlvP6x5PwtVW3Ps8mkxS2I10lPCk/d0zfLCQAfKmqdyPKaHJOAKf6G6TyoIDLaiPeYEFx
	ot3U5+WLqjyHMRgcSo0PpwMuvyFwTfpTyNd0zUQFqFG7B8Nj8oOwGysOHOGQVVhFTza7G3
	YCeycQIIJvWgLVYHyu79xVtkrkFAZRE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of ebiederm@xmission.com designates 166.70.13.233 as permitted sender) smtp.mailfrom=ebiederm@xmission.com;
	dmarc=pass (policy=none) header.from=xmission.com
Received: from in02.mta.xmission.com ([166.70.13.52]:38322)
	by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1vMLQ6-00Cn6i-9s; Fri, 21 Nov 2025 00:19:02 -0700
Received: from ip72-198-198-28.om.om.cox.net ([72.198.198.28]:55264 helo=email.froward.int.ebiederm.org.xmission.com)
	by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1vMLQ4-00CUPL-D2; Fri, 21 Nov 2025 00:19:01 -0700
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,  Alexey Dobriyan
 <adobriyan@gmail.com>,  Oleg Nesterov <oleg@redhat.com>,  Kees Cook
 <kees@kernel.org>,  Andy Lutomirski <luto@amacapital.net>,  Will Drewry
 <wad@chromium.org>,  Christian Brauner <brauner@kernel.org>,  Andrew
 Morton <akpm@linux-foundation.org>,  Michal Hocko <mhocko@suse.com>,
  Serge Hallyn <serge@hallyn.com>,  James Morris
 <jamorris@linux.microsoft.com>,  Randy Dunlap <rdunlap@infradead.org>,
  Suren Baghdasaryan <surenb@google.com>,  Yafang Shao
 <laoar.shao@gmail.com>,  Helge Deller <deller@gmx.de>,  Adrian Reber
 <areber@redhat.com>,  Thomas Gleixner <tglx@linutronix.de>,  Jens Axboe
 <axboe@kernel.dk>,  Alexei Starovoitov <ast@kernel.org>,
  "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
  "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  linux-security-module@vger.kernel.org,  tiozhang
 <tiozhang@didiglobal.com>,  Luis Chamberlain <mcgrof@kernel.org>,  "Paulo
 Alcantara (SUSE)" <pc@manguebit.com>,  Sergey Senozhatsky
 <senozhatsky@chromium.org>,  Frederic Weisbecker <frederic@kernel.org>,
  YueHaibing <yuehaibing@huawei.com>,  Paul Moore <paul@paul-moore.com>,
  Aleksa Sarai <cyphar@cyphar.com>,  Stefan Roesch <shr@devkernel.io>,
  Chao Yu <chao@kernel.org>,  xu xin <xu.xin16@zte.com.cn>,  Jeff Layton
 <jlayton@kernel.org>,  Jan Kara <jack@suse.cz>,  David Hildenbrand
 <david@redhat.com>,  Dave Chinner <dchinner@redhat.com>,  Shuah Khan
 <shuah@kernel.org>,  Elena Reshetova <elena.reshetova@intel.com>,  David
 Windsor <dwindsor@gmail.com>,  Mateusz Guzik <mjguzik@gmail.com>,  Ard
 Biesheuvel <ardb@kernel.org>,  "Joel Fernandes (Google)"
 <joel@joelfernandes.org>,  "Matthew Wilcox (Oracle)"
 <willy@infradead.org>,  Hans Liljestrand <ishkamiel@gmail.com>,  Penglei
 Jiang <superman.xpt@gmail.com>,  Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>,  Adrian Ratiu <adrian.ratiu@collabora.com>,
  Ingo Molnar <mingo@kernel.org>,  "Peter Zijlstra (Intel)"
 <peterz@infradead.org>,  Cyrill Gorcunov <gorcunov@gmail.com>,  Eric
 Dumazet <edumazet@google.com>
In-Reply-To: <GV2PPF74270EBEEAD4CACA124C05BE1CE45E4D5A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
	(Bernd Edlinger's message of "Fri, 21 Nov 2025 03:59:56 +0100")
References: <AM8PR10MB470801D01A0CF24BC32C25E7E40E9@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
	<AM8PR10MB470875B22B4C08BEAEC3F77FE4169@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
	<AS8P193MB1285DF698D7524EDE22ABFA1E4A1A@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
	<AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
	<AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
	<AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
	<GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
	<GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
	<GV2PPF74270EBEEE807D016A79FE7A2F463E4D6A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
	<87tsyozqdu.fsf@email.froward.int.ebiederm.org>
	<87wm3ky5n9.fsf@email.froward.int.ebiederm.org>
	<87h5uoxw06.fsf_-_@email.froward.int.ebiederm.org>
	<87a50gxo0i.fsf@email.froward.int.ebiederm.org>
	<GV2PPF74270EBEEAD4CACA124C05BE1CE45E4D5A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
Date: Fri, 21 Nov 2025 01:18:54 -0600
Message-ID: <87o6ovx38h.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1vMLQ4-00CUPL-D2;;;mid=<87o6ovx38h.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=72.198.198.28;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX1/iHCtWSAl7NFlir4kFAhXy3/S8BzfxSNE=
Subject: Re: [RFC][PATCH] exec: Move cred computation under exec_update_lock
X-SA-Exim-Connect-IP: 166.70.13.52
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 512 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on out03.mta.xmission.com); SAEximRunCond expanded to false
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0F10540012
X-Stat-Signature: md57py4do3smehhkmko1n8pe6wswrffe
X-Rspam-User: 
X-HE-Tag: 1763709553-601620
X-HE-Meta: U2FsdGVkX1/+NG/KqpnHBbtxVK2JIxqkWBdlklFyaj/ZsFg7XEiTSqp/OfXV8sfFnd0fkJqkZP1FsJPzfGtP9+3Edw4fNs+6N1y/ZeSzkyqJEQPs8BPlblKzcNTohp9pazrvTjORC+Z6ObjM7ctf/Dr9RpmTNGpYjMy/fu0khpb7ATwN9RvX03l/GWiqd4zQ70qYK8qmxEGV95X3c61BRuaVKEzt+I6dVMNg8TKCMMuxDbqPgJrdhcoOQ3GYJg9V2q+NjPdRkZ7Bxd7EGCp8xCLp33NSokPehpr7UXHILzX6hgAjbG4sW8yKFxRi5tdtL6wmuZkWm3/Y8lVc8zO5geA2WhKH5q1qBy07/l1BEthgHNc8k/tMQ3kH1ktrKz1XD2UK8l7iwcExciWtdlDrByniyljiHCi1ArDIvGCQk5OY9WpgCzk86DlMLbHaH/n9gZbj8+HSsoPhiUS/03A4uNEhY2CAEEjQ4qtld3zLemeSVEHzqLPqq8VR3LvCqNf30XtjuSm8B4cQV8+gu4quN/3EH0U68V/IMaLU7Z0XoxkWeAGghMsDsT9F33fLvcr+sJbra8FIGqW5xygfNZmzpgs+Ee3z3xbvKp3+opnhqdUT/eRXwsbqeAHy/l99UZfjREQ4NRo57dltnDGYTrKxJZoALEVwXcoU2zPbZTAYP5m7zqVfhGiHL9xlPGEWsRFWhhXHo51XNSiW/m0N+SaIi5Bk+pj0oE/eHGiVdkUAF5cud1QQZhlOWy4+dTEIbB4tSEbk2DVqItf8Bpvm5UOnnzM93Vyl0WgYKYMcKmQ4FjyNfCoXiEFMc0qoH99LnQHI4OebOZiFpPkirz7yXOlAmf82kZr6Az3EXGUCJPdqPmBeP09JoY0O3mXLbEHD7LROhrDpzGaoOzbjwxJb6WR2H31D2slYdY4ze9yL3ppyll2VKM7jxyYkn2rFL9zMj0Laxe3MxZ0PVg/X2S7cx/7
 gG7ZxySS
 abwooeZBLCYjf7VqrcgMI+F8lpuYMor5ImQMF34OaTiFr9A3pS9eW559rGkw3Vh0x4WT8Eyv9PX4BfkBlQDwfEgHXQn5V1ECwjo3jiIyUXudMtNvi5/rJtC8LJk/vYvaM4iWMkHvXJk73/OgCUSP0Rx7E7j/KWlE2I3KDwjg9zepfhv+6Qm2jSerwI8E2+FHp3OQK8C7en5OUskG/uQiPtSFIGtY44BUXYerzUSdrj4AUJUk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> Hi Eric,
>
> thanks for you valuable input on the topic.
>
> On 11/21/25 00:50, Eric W. Biederman wrote:
>> "Eric W. Biederman" <ebiederm@xmission.com> writes:
>> 
>>> Instead of computing the new cred before we pass the point of no
>>> return compute the new cred just before we use it.
>>>
>>> This allows the removal of fs_struct->in_exec and cred_guard_mutex.
>>>
>>> I am not certain why we wanted to compute the cred for the new
>>> executable so early.  Perhaps I missed something but I did not see any
>>> common errors being signaled.   So I don't think we loose anything by
>>> computing the new cred later.
>> 
>> I should add that the permission checks happen in open_exec,
>> everything that follows credential wise is just about representing in
>> struct cred the credentials the new executable will have.
>> 
>> So I am really at a loss why we have had this complicated way of
>> computing of computed the credentials all of these years full of
>> time of check to time of use problems.
>> 
>
> Well, I think I see a problem with your patch:
>
> When the security engine gets the LSM_UNSAFE_PTRACE flag, it might
> e.g. return -EPERM in bprm_creds_for_exec in the apparmor, selinux
> or the smack security engines at least.  Previously that callback
> was called before the point of no return, and the return code should
> be returned as a return code the the caller of execve.  But if we move
> that check after the point of no return, the caller will get killed
> due to the failed security check.
>
> Or did I miss something?

I think we definitely need to document this change in behavior.  I would
call ending the exec with SIGSEGV vs -EPERM a quality of implementation
issue.  The exec is failing one way or the other so I don't see it as a
correctness issue.

In the case of ptrace in general I think it is a bug if the mere act of
debugging a program changes it's behavior.  So which buggy behavior
should we prefer?  SIGSEGV where it is totally clear that the behavior
has changed or -EPERM and ask the debugged program to handle it.
I lean towards SIGSEGV because then it is clear the code should not
handle it.

In the case of LSM_UNSAFE_NO_NEW_PRIVS I believe the preferred way to
handle unexpected things happening is to terminate the application.

In the case of LSM_UNSAFE_SHARE -EPERM might be better.  I don't know
of any good uses of any good uses of sys_clone(CLONE_FS ...) outside
of CLONE_THREAD.


Plus all of these things are only considerations if we are exec'ing a
program that transitions to a different set of credentials.  Something
that happens but is quite rare itself.

In practice I don't expect there is anything that depends on the exact
behavior of what happens when exec'ing a suid executable to gain
privileges when ptraced.   The closes I can imagine is upstart and
I think upstart ran as root when ptracing other programs so there is no
gaining of privilege and thus no reason for a security module to
complain.

Who knows I could be wrong, and someone could actually care.  Which is
hy I think we should document it.

Eric


