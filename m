Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 542F1CFD2F6
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 23:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AFC36B0012; Sun, 23 Nov 2025 18:23:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75FB96B0022; Sun, 23 Nov 2025 18:23:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6279B6B0023; Sun, 23 Nov 2025 18:23:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B9206B0012
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:23:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F3CBD1DFF66
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 23:23:01 +0000 (UTC)
X-FDA: 84143449362.25.49716C3
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8BFC0C000B
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 23:22:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=xmission.com;
	spf=pass (imf28.hostedemail.com: domain of ebiederm@xmission.com designates 166.70.13.231 as permitted sender) smtp.mailfrom=ebiederm@xmission.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763940179; a=rsa-sha256;
	cv=none;
	b=ZoYCfqQGaWwuiD+Z85odA1V0I/+VOF4V/DAb4clJwlzgu5Ue5sxTeBcZrUrZUF72bQmNj+
	Ly/Fm1NIBK8b29P0Fzoqhl/KgvP2IA3yWn/J5ZrlsLZIxmT/9KkI8qfQ7+cVfCVEGka5VV
	K1x+jWtTday1wFMhwPBcli+/l6ObSUY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=xmission.com;
	spf=pass (imf28.hostedemail.com: domain of ebiederm@xmission.com designates 166.70.13.231 as permitted sender) smtp.mailfrom=ebiederm@xmission.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763940179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FpHhFTCAZwFgh3s0KLoxrVKxgOphvEX1IYsZq7z2mz4=;
	b=Y7n4qja1vua09PS7w33a4Ug3HdKXX/78VGFqyQVM6+vXcg6L5uWvIEipZN4nQR56sV+9Wg
	6aOinE/XNz6w5Az5oxJtuP506kx0Ash5b8NnZAiPkFL2K46VfOS8wFR966umskmYz/oCj+
	8Lyo+vFFevoql2H072Mr0Mn4CZLGuX4=
Received: from in02.mta.xmission.com ([166.70.13.52]:44430)
	by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1vNJPq-000Vmp-5s; Sun, 23 Nov 2025 16:22:46 -0700
Received: from ip72-198-198-28.om.om.cox.net ([72.198.198.28]:44852 helo=email.froward.int.ebiederm.org.xmission.com)
	by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1vNJPp-001fVL-4Z; Sun, 23 Nov 2025 16:22:45 -0700
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Bernd Edlinger <bernd.edlinger@hotmail.de>,  Alexander Viro
 <viro@zeniv.linux.org.uk>,  Alexey Dobriyan <adobriyan@gmail.com>,  Kees
 Cook <kees@kernel.org>,  Andy Lutomirski <luto@amacapital.net>,  Will
 Drewry <wad@chromium.org>,  Christian Brauner <brauner@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,  Michal Hocko
 <mhocko@suse.com>,  Serge Hallyn <serge@hallyn.com>,  James Morris
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
In-Reply-To: <aSNX5B9a5iSjJcM1@redhat.com> (Oleg Nesterov's message of "Sun,
	23 Nov 2025 19:52:20 +0100")
References: <AS8P193MB1285DF698D7524EDE22ABFA1E4A1A@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
	<AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
	<AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
	<AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
	<GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
	<GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
	<GV2PPF74270EBEEE807D016A79FE7A2F463E4D6A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
	<87tsyozqdu.fsf@email.froward.int.ebiederm.org>
	<87wm3ky5n9.fsf@email.froward.int.ebiederm.org>
	<87h5uoxw06.fsf_-_@email.froward.int.ebiederm.org>
	<aSNX5B9a5iSjJcM1@redhat.com>
Date: Sun, 23 Nov 2025 17:22:36 -0600
Message-ID: <87tsykuyf7.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1vNJPp-001fVL-4Z;;;mid=<87tsykuyf7.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=72.198.198.28;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX188bdynm4AjSoejNdWJaikuesUTwrwxz14=
Subject: Re: [RFC][PATCH] exec: Move cred computation under exec_update_lock
X-SA-Exim-Connect-IP: 166.70.13.52
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 512 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on out01.mta.xmission.com); SAEximRunCond expanded to false
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8BFC0C000B
X-Stat-Signature: bqhk9j683bec3p1mfa543ki4txcacwwp
X-Rspam-User: 
X-HE-Tag: 1763940179-922852
X-HE-Meta: U2FsdGVkX18+XKrhyIO8Mndd9c3LgSjLBfsBRERzvZbdeOHuC5ukLyf89Auc44/7OUVG8CJRU6ihSiHAeSEtqtCqCgsSCLaDDJa9Uu6r6Y/iNo6/9pHnpI+cWP88KAmx1xiOkkhs2zkAo9VFQnsPgMQhkz/s0rxqgNAi8tjzpWAJ2nZPOiaMvXS0v8LXP3Y7kRUH2CMg6ZVJO1YJaZMpsKgLFMBt78ueUoiwCA3wGhDivCcaMsHQiqiV2qbzztMYcrl5kIh0uCgkOHBZjpyvFSjjsa3jY07G9A6+uHg7vqFWwCVproSfWvOazVcA+0ZyH0V3zUrPDdiqHFnP4CJh2SZfETPIkrchGogT3+I5evX8IP/3Ap/Ney/PQmRvPiyw1Bb4kDz1GZkvcBwx73bGdVnOpnL8lcX6+kOsPd2zmkliOIUa6Ju5e+1deALF7TErWmXSDEhOxkB/MarARdsm/E6mdmDVu0VrvSNXVS43ilxQ4Lf2F9IIYw1ImUDppr5r4zP21NvL4jBrmoUAOn+ZK3K1FzKUVNGNsIJ1BtzEGO8SvkJYCY3mOveWVfwhksEDE66GMFZqYeMJWVXdkA76WI73h+Tga+SuHeVdYvQFQdjdCLSdIdnBpXMWyawFdEduwGx5tB/lAgKNhqPZLnb3zFwdCAsa1i+nKWYADvw4+EHifV3TYqwkS03sEK/lo6acwoq9OsGAibNIs1AfCME9MAwF+BTWr5QV/keoH7zWU+RCEF80ikM2/epFFovxgqFSwQ3s1qCgmwEzNPuS7Z2yxRZCHC65NWvBQBaSlrcjpQqkVggFe8SxAP+Vm5EeCqNZt8gT+U4K7KSYmdYvJDSkwr7KPstx7Kur6fMrfZZKIj/jZFLeN4lK+ONUz2BNumvrRO9I/xeKXJq7UB4aia72v6Re/362CspeKV7Wp340whaLfPYNE4ZSngqWlZEVMEhbzCngAk1N09qCsWaUSoi
 N0G+JpEF
 9wUKZ6xl+TwBKEsE1PoOcUQMs4yHXBObp4YygxcnwN94oZG9MjceXRYAwAgimt87TuD4tt3M7Qzl0jTEZCev1Ubu2gBccO5Jkcc9hh7R8tYnzFEUmi8wiJKDUaytalEhQZ8bDTmYDbGfVal1GvdcqwjJbC23y2UTAaB3YI9jSZH1TdeYvnESklKc/S3dzvAiLhclgF64IVQgMgOU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Oleg Nesterov <oleg@redhat.com> writes:

> Eric,
>
> sorry for delay, I am on PTO, didn't read emails this week...
>
> On 11/20, Eric W. Biederman wrote:
>>
>> Instead of computing the new cred before we pass the point of no
>> return compute the new cred just before we use it.
>>
>> This allows the removal of fs_struct->in_exec and cred_guard_mutex.
>>
>> I am not certain why we wanted to compute the cred for the new
>> executable so early.  Perhaps I missed something but I did not see any
>> common errors being signaled.   So I don't think we loose anything by
>> computing the new cred later.
>>
>> We gain a lot.
>
> Yes. I LIKE your approach after a quick glance. And I swear, I thought about
> it too ;)
>
> But is it correct? I don't know. I'll try to actually read your patch next
> week (I am on PTO untill the end of November), but I am not sure I can
> provide a valuable feedback.
>
> One "obvious" problem is that, after this patch, the execing process can crash
> in a case when currently exec() returns an error...

Yes.

I have been testing and looking at it, and I have found a few issues,
and I am trying to see if I can resolve them.

The good news is that with the advent of AT_EXECVE_CHECK we have a
really clear API boundary between errors that must be diagnosed
and errors of happenstance like running out of memory.

The bad news is that the implementation of AT_EXECVE_CHECK seems to been
rather hackish especially with respect to security_bprm_creds_for_exec.

What I am hoping for is to get the 3 causes of errors of brpm->unsafe
( LSM_UNSAFE_SHARE, LSM_UNSAFE_PTRACE, and LSM_UNSAFE_NO_NEW_PRIVS )
handled cleanly outside of the cred_guard_mutex, and simply
retested when it is time to build the credentials of the new process.

In practice that should get the same failures modes as we have now
but it would get SIGSEGV in rare instances where things changed
during exec.  That feels acceptable.



I thought of one other approach that might be enough to put the issue to
bed if cleaning up exec is too much work.  We could have ptrace_attach
use a trylock and fail when it doesn't succeed.  That would solve the
worst of the symptoms.

I think this would be a complete patch:

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 75a84efad40f..5dd2144e5789 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -444,7 +444,7 @@ static int ptrace_attach(struct task_struct *task, long request,
 	 * SUID, SGID and LSM creds get determined differently
 	 * under ptrace.
 	 */
-	scoped_cond_guard (mutex_intr, return -ERESTARTNOINTR,
+	scoped_cond_guard (mutex_try, return -EAGAIN,
 			   &task->signal->cred_guard_mutex) {
 
 		scoped_guard (task_lock, task) {
-- 
2.41.0


Eric

