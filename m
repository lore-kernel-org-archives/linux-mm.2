Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 825C0CF9C51
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 17:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A639B6B002C; Thu, 20 Nov 2025 12:29:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13EA6B002D; Thu, 20 Nov 2025 12:29:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DBAF6B002F; Thu, 20 Nov 2025 12:29:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 782456B002C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:29:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAA011601E4
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 17:29:38 +0000 (UTC)
X-FDA: 84131672436.05.5057D1B
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
	by imf28.hostedemail.com (Postfix) with ESMTP id 43D40C0014
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 17:29:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of ebiederm@xmission.com designates 166.70.13.232 as permitted sender) smtp.mailfrom=ebiederm@xmission.com;
	dmarc=pass (policy=none) header.from=xmission.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763659776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GCfJXPfqkRJSPRHzlR8tAMkwsl/MwNptOMMjaUHQYis=;
	b=jE0sWX+nXjFZHXPRrdm3ZMVDiWkhZOq5x02Hhq7wNgQRqh97xhVvcNJaYv7IsqmH1LU1bq
	fOHBJLXYMpurC75d43wSS+svu5TT6R0qdoEXE7AJP50pN4czWcBRnbhy36Y2eYRaK7FVEh
	DdBJLF/6BhyJ7G6GZvX310xNTH94Rg8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763659776; a=rsa-sha256;
	cv=none;
	b=F5P1vkBagf0sHYiG1t/LnZD+uPev5S8v0UkCMSxvnFdcyrlNLRK36C3CK7njJn5j6i28+G
	OCdSmwR5P7eYHXaMK4STmWvi9ek3UDg3kcOhynxxZT3Rxj7DBdBZPSyN4LUUMDbu3OkOAI
	G5Tu+TyR/M4Ory8PcaAXcNlngC85ANg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of ebiederm@xmission.com designates 166.70.13.232 as permitted sender) smtp.mailfrom=ebiederm@xmission.com;
	dmarc=pass (policy=none) header.from=xmission.com
Received: from in01.mta.xmission.com ([166.70.13.51]:36142)
	by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1vM8TC-0080O5-W2; Thu, 20 Nov 2025 10:29:23 -0700
Received: from ip72-198-198-28.om.om.cox.net ([72.198.198.28]:33708 helo=email.froward.int.ebiederm.org.xmission.com)
	by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1vM8TB-00Fz5d-R2; Thu, 20 Nov 2025 10:29:22 -0700
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
In-Reply-To: <87tsyozqdu.fsf@email.froward.int.ebiederm.org> (Eric
	W. Biederman's message of "Thu, 20 Nov 2025 09:15:57 -0600")
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
Date: Thu, 20 Nov 2025 11:29:14 -0600
Message-ID: <87wm3ky5n9.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1vM8TB-00Fz5d-R2;;;mid=<87wm3ky5n9.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=72.198.198.28;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX18WRCiEc86RNupml3aU1I9F5t8x9s6oRjc=
Subject: Re: [PATCH v18] exec: Fix dead-lock in de_thread with ptrace_attach
X-SA-Exim-Connect-IP: 166.70.13.51
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 512 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on out02.mta.xmission.com); SAEximRunCond expanded to false
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 43D40C0014
X-Stat-Signature: bj7ccfrwtx3g3t4csu6pbaujbzkq7yqc
X-HE-Tag: 1763659776-607643
X-HE-Meta: U2FsdGVkX19iku3dLGMtZCv6Dcjdnab0xOLVPWO4K4aIfzJlUP07rqjLnH/6FaqmBv7ODrvBmt5IcaZ0I7SM4RBJrKQaJh3e+sffFqjR8t0xTB5fql7J4j8LA6veCWxisWOiQUrD0b2Eq5jhuovZROcZFdLC6EFSuJTDUe7WKoh5aS8FjMxDehUM9ReHnDz6G+/z7Ywj1Jf08bSAFYxTMKmVYjwHC/WGbqYSRJCTzqTS7bBL69xg5xHQk5k5RlDJY7YLwqYR1dmzOQuvZQ+ZkNmjzFiJqjmHb/NGGALb48kuucbAwFPHOoms8zxW+MUjzVlj8WSXwCf6+RwMii/2GDgawiI/dpQNOgzN2Kz9e7U1PgJDuvJ3aK10cEE7Rif5QHQOGTbSVtKCXC6d2U20JrJqJsyMkzkT9LmI7SZxrEj6IJEyG/hvsFl2u8dVPR9Y5szZEIQ6ppngLEOqQaB9QvOr1wT78rCz3+Ba3RK6V52JaVqPDyr/1sW2X4q498DzZyVbShPxh/3Ndc5NCgySZM4jO3uyOaOjR8NqQElZl7BVPXBviPvsvs+lBTicjG0spaw+LcdoWFvOhKR1kxjIey1COw4ZsaHbwT2bc/LZ4yqj5+9ws/zWTq7V6kddzMyMY8Q+8kohv+UM5sftukb7gPsd5lgwRad1APpWPo3QMFmxWAdUxa3FjZkCFouPjFGN+5/zsQF7KA1ufuVLfCuLzPsGmBu6CVdrUs6Xmhejk2kyY4AQkApyuuw1KxI4ihRbCnV+kWqAgXsJFSUwhL5gOQLObSiKgREIJ0SQmeOBGvgWM3D1+EogGd8QpRchfLiUax494syXaLUK+zA/FTWNHHnZxFFCvbnbuUZ2yMaRdcBEIzMhZ9BoWSX/WOcOeryWXdySoYpk8J6qAOXZt+u8GBmQ6WGTd3hnXxabqKGgGdRYSdxlByHj2nc/XFGL9aUklnU3zcSbdfVYdvJH45w
 iS/bK3K7
 wUuiOdpYhsmk30myTyr8aaPc7DozyOpVTyz8YQMsAuZ/7hoCo14XZbvktPa5jLWwK71hRID4kHQzd90z5E6DdI2f8UaG0XzVsj9cS+yEpSX+twTHjN49cCHB58Sn5eVtL21aB0kq80MrDqmKSvupTCUp5vrH6pRE9MnGjqnnl+pBtzhH9yzZjmqZepqsUtmll6/ofcsscjY5EWF+fcyGNpUkDShBRm48GKyz8pGuf2mMPL1s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Eric W. Biederman" <ebiederm@xmission.com> writes:

> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>
>> This introduces signal->exec_bprm, which is used to
>> fix the case when at least one of the sibling threads
>> is traced, and therefore the trace process may dead-lock
>> in ptrace_attach, but de_thread will need to wait for the
>> tracer to continue execution.
>
> A small quibble it isn't a dead lock.  It isn't even really a live lock,
> as it is possible to SIGKILL our way out.
>
> Thinking about this there is a really silly and simple way we can deal
> with this situation for PTRACE_ATTACH.  We can send SIGSTOP and wait for
> the thread to stop before doing anything with cred_guard_mutex.
>
> PTRACE_ATTACH already implies sending SIGSTOP so as long as we have
> enough permissions to send SIGSTOP I don't see that being a problem.
>
> The worst case I can see is that we get a case where we stop the
> process, the permission check fails under cred_guard_mutex and
> and ptrace attach has fails and has to send SIGCONT to undo it's
> premature SIGSTOP.  That might almost be visible, but it would still
> be legitimate because we can still check that we have permission to
> send SIGSTOP.

Bah no I am full of it.

The challenging behavior is in the semantics of the kernel operations.
We need to describe it as such please.

It is the same class of problem as a single threaded process calls exec
with a pipe attached to both stdin and stdout of the new process.

For the stdin and stdout we can say just use pull and nonblocking I/O.

The problem is that both PTRACE_ATTACH and PTRACE_SEIZE block over
the duration of exec, and if exec is waiting for a thread to exit,
and that thread is blocked in PTRACE_EVENT_EXIT waiting for that very
same tracer those processes will hang. Not deadlock.


I haven't seen anyone clearly describe the problem lately so I am
repeating it.


Just looking at the code I don't think there is any fundamental reason
to call commit_creds after de_thread.  If we can change that we can sort
this out without any change in userspace semantics.

If we can't move commit_creds we have to either give
PTRACE_ATTACH/PTRACE_SEIZE a non-block mode, or break out of
PTRACE_EVENT_EXIT in de_thread.

I will post a proof of concept of moving commit_creds in just a minute.

Eric

