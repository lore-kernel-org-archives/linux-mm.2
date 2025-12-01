Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2A79D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 18:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19BC46B0095; Mon,  1 Dec 2025 13:53:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 173846B0096; Mon,  1 Dec 2025 13:53:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062FC6B00AC; Mon,  1 Dec 2025 13:53:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8D856B0095
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:53:32 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA1A214030A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:53:32 +0000 (UTC)
X-FDA: 84171800664.04.4E2B1F2
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
	by imf13.hostedemail.com (Postfix) with ESMTP id 26D0220015
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:53:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=xmission.com;
	spf=pass (imf13.hostedemail.com: domain of ebiederm@xmission.com designates 166.70.13.232 as permitted sender) smtp.mailfrom=ebiederm@xmission.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764615210; a=rsa-sha256;
	cv=none;
	b=J5C79QXqIwDXJlp4dsnPr1cGm05HYWjfqDU42+gWSjAnZEDxZzlvhtTOqR2BIzd9qOqA+3
	pHyOJOAR91YjxEXd/HanTI+zjRMB+Wfhoi5X8BZLVdcPf00/RUE/LRtljh4nheaemvpaDY
	M64xcHoo+/FNORATaHeRjxjpMpDAG7A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=xmission.com;
	spf=pass (imf13.hostedemail.com: domain of ebiederm@xmission.com designates 166.70.13.232 as permitted sender) smtp.mailfrom=ebiederm@xmission.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764615210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Izzfb4CkbX7pw5tGLh2P7e2dMmXxfGZWRW2Q10s0cWA=;
	b=iql0QODYqVLKS3CXU7dt4PrpDXAtKsazHB06Z1o423o6g1AMg129TcHrgIXjoK+u6Y2uJ9
	LxJWUsH4hXbTbRG+Q2/sI+cL3+ApE7ED/b+W9g0StRVZkUuPZ9khezsDKlJ/OIPWWfYqor
	KR312A16SGrnDJ9CBapV+NebgXOKs28=
Received: from in02.mta.xmission.com ([166.70.13.52]:36888)
	by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1vQ91S-00A8D5-Ro; Mon, 01 Dec 2025 11:53:18 -0700
Received: from ip72-198-198-28.om.om.cox.net ([72.198.198.28]:60576 helo=email.froward.int.ebiederm.org.xmission.com)
	by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1vQ91R-007wwj-3u; Mon, 01 Dec 2025 11:53:18 -0700
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc: Bernd Edlinger <bernd.edlinger@hotmail.de>,  Alexander Viro
 <viro@zeniv.linux.org.uk>,  Alexey Dobriyan <adobriyan@gmail.com>,  Oleg
 Nesterov <oleg@redhat.com>,  Kees Cook <kees@kernel.org>,  Andy Lutomirski
 <luto@amacapital.net>,  Will Drewry <wad@chromium.org>,  Christian Brauner
 <brauner@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Michal
 Hocko <mhocko@suse.com>,  Serge Hallyn <serge@hallyn.com>,  James Morris
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
 Dumazet <edumazet@google.com>,  zohar@linux.ibm.com,
  linux-integrity@vger.kernel.org,  Ryan Lee <ryan.lee@canonical.com>,
  apparmor <apparmor@lists.ubuntu.com>
In-Reply-To: <dca0f01500f9d6705dccf3b3ef616468b1f53f57.camel@huaweicloud.com>
	(Roberto Sassu's message of "Mon, 01 Dec 2025 17:49:31 +0100")
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
	<6dc556a0a93c18fffec71322bf97441c74b3134e.camel@huaweicloud.com>
	<87v7iqtcev.fsf_-_@email.froward.int.ebiederm.org>
	<dca0f01500f9d6705dccf3b3ef616468b1f53f57.camel@huaweicloud.com>
Date: Mon, 01 Dec 2025 12:53:10 -0600
Message-ID: <87ms42rq3t.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1vQ91R-007wwj-3u;;;mid=<87ms42rq3t.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=72.198.198.28;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX1+XM2P5RQHG0tsP4a1fJTNsMKeh8jmHpMk=
Subject: Re: Are setuid shell scripts safe? (Implied by
 security_bprm_creds_for_exec)
X-SA-Exim-Connect-IP: 166.70.13.52
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 512 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on out02.mta.xmission.com); SAEximRunCond expanded to false
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 26D0220015
X-Stat-Signature: qqqmnosjpk1h468ecydzuns3c37t4wpb
X-Rspam-User: 
X-HE-Tag: 1764615209-57470
X-HE-Meta: U2FsdGVkX195aXOWftq+LqYIn2qSIDM02xmERD6lO5ZXbLSYuxICpsHwSVjCZR05dS798X4wKOCGg9+vZPyZtVIRROsWCmmNKaSw/s0D5aKL5KmL1raw1fWUfOqW4wRbzxs1FILWNIcffJwdqdVxVDuScBPxnx4Uf1L89PmJHNnnp72tbuPig5pzyeo6IFf7tzuK/xNLAV1VitGFoiLFI/hkyAn9vh07kcRKfo+RSTyINAesDoFwLonC426YfsFHQPFwrPnwW6kfPvh5Q+LevK+5N9FO34NKXqk7iTrq58jwhRoOF1A4jYVbE9fYmIBdvX2aZYpYP4baK2mn+zbnljNjwl299CYINvLzP8sIoeAjc23Cxe94/H1ZnEbSFagiTL+Lq5CWuYG8WQ5OVfI89lSrshFm41bflvnZTTUzcdW+t06Lme7BXJX9BKZDxPi3XZclM0fqLdJSuG6j0jhRSP8r0/G6onxH8t1GX1KlSNdvDfsQY1lggo3biWesPPnz2P1FFCAWnjCXJJLZmhN/6rArEP0LL2kZ/9/zaK2N56Z12s6EJ26qCZyMinzQ9KCrvK9zS9NMl6zxn7LIsM29wTBsE3UthMqcwC+KaIOD2+Q+xivFGNrIX3hczZVUiYiXW/zbOTbDt0cOb26yLynMDibN3aMVX+Hv7/z3YNOCRoDVngB/qLvc6F0HGY5R5FO8hkdLnPriW9EIWnsQECQu7KlVnL7+mFgXtU0HZYtSJ6Y7Y2YMAS7797mQ7HZ1Yy0uqsq+JpJ25tLVueFvYdYDPler7Ncu52/IoEVN4OfOQW9KkmRdeEjpnE7K2oKqUQkAfpBwcSy764MaP3fLBof6AesAHWlerUHXhn11J0YEYPCgOR8n1skjLaf/jnykEaE79NjMKt1awZ+WwCSbePmWKvB1N/9nxzCd2NEwAG37Chv0vzFcSylUc6cFu51VFk0B/EwZOyfYQIRUmVpgM+d
 N0uqtvVu
 LKuV0b+7ZUJgF7k1DoAzMCoo969KRhBbNc5urYJ+NQ20UGgW5ep5Kb6toUe9hVUVduUesRFC9YWJrm+0iAqE1Eqh4nhZHa5CQH1xJWjNYxIUGTqSX0hGSMkg+XV9dOcoiSjxXQ2dJc8+jPUsaJSq0xxaovbVDRlprhSwNycNunitex6kStB9q+p7Eb6GVdhQ41sBOatC0w/dX7NYI1Y1cBj9jDpi9xpaLMGC/ciDfXtdWaDKl8Vu4da3Sg+ECCu5S3Pw8J5xqVmuwoP2raOE7LGXNTvdDZKd92nMFIsAyEVbCicUur6kH18ea4pNzM2VkmAiDlRgglpC/YzM+uEdH25H0NNI6fePWZ0AOTkgo1uhA/Vl8bCRvCD88nFwimPrFz4KDvBXu8+jBd1A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Roberto Sassu <roberto.sassu@huaweicloud.com> writes:

> On Mon, 2025-12-01 at 10:06 -0600, Eric W. Biederman wrote:
>> Roberto Sassu <roberto.sassu@huaweicloud.com> writes:
>> 
>> > + Mimi, linux-integrity (would be nice if we are in CC when linux-
>> > security-module is in CC).
>> > 
>> > Apologies for not answering earlier, it seems I don't receive the
>> > emails from the linux-security-module mailing list (thanks Serge for
>> > letting me know!).
>> > 
>> > I see two main effects of this patch. First, the bprm_check_security
>> > hook implementations will not see bprm->cred populated. That was a
>> > problem before we made this patch:
>> > 
>> > https://patchew.org/linux/20251008113503.2433343-1-roberto.sassu@huaweicloud.com/
>> 
>> Thanks, that is definitely needed.
>> 
>> Does calling process_measurement(CREDS_CHECK) on only the final file
>> pass review?  Do you know of any cases where that will break things?
>
> We intentionally changed the behavior of CREDS_CHECK to be invoked only
> for the final file. We are monitoring for bug reports, if we receive
> complains from people that the patch breaks their expectation we will
> revisit the issue.
>
> Any LSM implementing bprm_check_security looking for brpm->cred would
> be affected by recalculating the DAC credentials for the final binary.
>
>> As it stands I don't think it should be assumed that any LSM has
>> computed it's final creds until bprm_creds_from_file.  Not just the
>> uid and gid.
>
> Uhm, I can be wrong, but most LSMs calculate their state change in
> bprm_creds_for_exec (git grep bprm_creds_for_exec|grep LSM_HOOK_INIT).
>
>> If the patch you posted for review works that helps sort that mess out.
>
> Well, it works because we changed the expectation :)

I just haven't seen that code land in Linus's tree yet so I am a bit
cautious in adopting that.  It is definitely needed as the behavior
of IMA as v6.18 simply does not work in general.

>> > to work around the problem of not calculating the final DAC credentials
>> > early enough (well, we actually had to change our CREDS_CHECK hook
>> > behavior).
>> > 
>> > The second, I could not check. If I remember well, unlike the
>> > capability LSM, SELinux/Apparmor/SMACK calculate the final credentials
>> > based on the first file being executed (thus the script, not the
>> > interpreter). Is this patch keeping the same behavior despite preparing
>> > the credentials when the final binary is found?
>> 
>> The patch I posted was.
>> 
>> My brain is still reeling from the realization that our security modules
>> have the implicit assumption that it is safe to calculate their security
>> information from shell scripts.
>
> If I'm interpreting this behavior correctly (please any LSM maintainer
> could comment on it), the intent is just to transition to a different
> security context where a different set of rules could apply (since we
> are executing a script).
>
> Imagine if for every script, the security transition is based on the
> interpreter, it would be hard to differentiate between scripts and
> associate to the respective processes different security labels.
>
>> In the first half of the 90's I remember there was lots of effort to try
>> and make setuid shell scripts and setuid perl scripts work, and the
>> final conclusion was it was a lost cause.
>
> Definitely I lack a lot of context...

From the usenet comp.unix.faq that was probably updated in 1994:
    http://www.faqs.org/faqs/unix-faq/faq/part4/section-7.html

I have been trying to remember enough details by looking it up, but the
short version is that one of the big problems is there is a race between
the kernel doing it's thing and the shell opening the shell script.

Clever people have been able to take advantage of that race and insert
arbitrary code in that window for the shell to execute.  All you have to
do is google for how to find a reproducer if the one in the link above
is not enough.

>> Now I look at security_bprm_creds_for_exec and security_bprm_check which
>> both have the implicit assumption that it is indeed safe to compute the
>> credentials from a shell script.
>> 
>> When passing a file descriptor to execat we have
>> BINPRM_FLAGS_PATH_INACCESSIBLE and use /dev/fd/NNN as the filename
>> which reduces some of the races.
>> 
>> However when just plain executing a shell script we pass the filename of
>> the shell script as a command line argument, and expect the shell to
>> open the filename again.  This has been a time of check to time of use
>> race for decades, and one of the reasons we don't have setuid shell
>> scripts.
>
> Yes, it would be really nice to fix it!

After 30 years I really don't expect that is even a reasonable request.

I think we are solidly into "Don't do that then", and the LSM security
hooks are definitely doing that.

There is the partial solution of passing /dev/fd instead of passing the
name of the script.  I suspect that would break things.  I don't
remember why that was never adopted.

I think even with the TOCTOU race fixed there were other serious issues.

I really think it behooves any security module people who want to use
the shell script as the basis of their security decisions to research
all of the old well known issues and describe how they don't apply.

All I have energy for is to point out it is broken as is and to start
moving code down into bprm_creds_from_file to avoid the race.

Right now as far as I can tell anything based upon the script itself
is worthless junk so changing that would not be breaking anything that
wasn't already broken.

>> Yet the IMA implementation (without the above mentioned patch) assumes
>> the final creds will be calculated before security_bprm_check is called,
>> and security_bprm_creds_for_exec busily calculate the final creds.
>> 
>> For some of the security modules I believe anyone can set any label they
>> want on a file and they remain secure (At which point I don't understand
>> the point of having labels on files).  I don't believe that is the case
>> for selinux, or in general.
>
> A simple example for SELinux. Suppose that the parent process has type
> initrc_t, then the SELinux policy configures the following transitions
> based on the label of the first file executed (sesearch -T -s initrc_t
> -c process):
>
> type_transition initrc_t NetworkManager_dispatcher_exec_t:process NetworkManager_dispatcher_t;
> type_transition initrc_t NetworkManager_exec_t:process NetworkManager_t;
> type_transition initrc_t NetworkManager_initrc_exec_t:process initrc_t;
> type_transition initrc_t NetworkManager_priv_helper_exec_t:process NetworkManager_priv_helper_t;
> type_transition initrc_t abrt_dump_oops_exec_t:process abrt_dump_oops_t;
> type_transition initrc_t abrt_exec_t:process abrt_t;
> [...]
>
> (there are 747 rules in my system).
>
> If the transition would be based on the interpreter label, it would be
> hard to express with rules.

Which is a problem for the people making the rules engine.  Because
30 years of experience with this problem says basing anything on the
script is already broken.

I understand the frustration, but it requires a new way of launching
shell scripts to even begin to make it secure.

> If the transition does not occur for any reason the parent process
> policy would still apply, but maybe it would not have the necessary
> permissions for the execution of the script.

Yep.

>> So just to remove the TOCTOU race the security_bprm_creds_for_exec
>> and security_bprm_check hooks need to be removed, after moving their
>> code into something like security_bprm_creds_from_file.
>> 
>> Or am I missing something and even with the TOCTOU race are setuid shell
>> scripts somehow safe now?
>
> Take this with a looot of salt, if there is a TOCTOU race, the script
> will be executed with a security context that does not belong to it.
> But the transition already happened. Not sure if it is safe.

Historically it hasn't been safe.

> I also don't know how the TOCTOU race could be solved, but I also would
> like it to be fixed. I'm available to comment on any proposal!

I am hoping someone who helped put these security hooks where they are
will speak up, and tell me what I am missing.

All I have the energy for right now is to point out security policies
based upon shell scripts appear to be security policies that only
protect you from well behaved programs.

Eric

