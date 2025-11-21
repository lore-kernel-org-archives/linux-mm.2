Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB4A5CFC500
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 19:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08DE96B00A4; Fri, 21 Nov 2025 14:20:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03E6A6B00A5; Fri, 21 Nov 2025 14:20:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E48876B00A6; Fri, 21 Nov 2025 14:20:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD5476B00A4
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:20:19 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8C7C13043F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:20:16 +0000 (UTC)
X-FDA: 84135580032.11.05C3760
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
	by imf10.hostedemail.com (Postfix) with ESMTP id 52473C000F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:20:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of ebiederm@xmission.com designates 166.70.13.231 as permitted sender) smtp.mailfrom=ebiederm@xmission.com;
	dmarc=pass (policy=none) header.from=xmission.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763752814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BOQoKKKIUOk1x+84ttvDxBfDqICa4LLKFZdt27XPDPs=;
	b=ojT6LSDug9OYtCBVybJElwOwM42uxaAA/kSnEjc0pZ2q3DljAFSpFpkLdNtJskUpQcjA9T
	6c3z105JyWzDwyQYQd76excVkXIBWxfvjvJgehYhI7ylTHw1tFTE//Bg4dgpl2N9IdK1/K
	y9CTxzX13FYTy64l9G9+/1cyNpB7ENA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763752814; a=rsa-sha256;
	cv=none;
	b=KkqkrY7fim/H6L82fVgTMSZN379HO/tb7eBwjk1tcDKjYZU7TzCiaVnPr4VqtPQSYzDRAr
	1dIA6HbClym1j2zn2Pd9io8XQwSvoVEqY6W3vdx/BQeJDIKAWcbFdda3UelU55KSs5JHlJ
	VusXLcQnT4h9QyrF9yzb22eoFVCaOPw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of ebiederm@xmission.com designates 166.70.13.231 as permitted sender) smtp.mailfrom=ebiederm@xmission.com;
	dmarc=pass (policy=none) header.from=xmission.com
Received: from in01.mta.xmission.com ([166.70.13.51]:56436)
	by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1vMWfr-00EM7W-Dy; Fri, 21 Nov 2025 12:20:03 -0700
Received: from ip72-198-198-28.om.om.cox.net ([72.198.198.28]:50660 helo=email.froward.int.ebiederm.org.xmission.com)
	by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1vMWfp-000k4P-Vv; Fri, 21 Nov 2025 12:20:03 -0700
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
In-Reply-To: <GV2PPF74270EBEED0840E45459881C0EDD4E4D5A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
	(Bernd Edlinger's message of "Fri, 21 Nov 2025 12:26:48 +0100")
References: <AM8PR10MB470801D01A0CF24BC32C25E7E40E9@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
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
	<87o6ovx38h.fsf@email.froward.int.ebiederm.org>
	<GV2PPF74270EBEEFA106F4EF26B087ED898E4D5A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
	<GV2PPF74270EBEED0840E45459881C0EDD4E4D5A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
Date: Fri, 21 Nov 2025 13:19:55 -0600
Message-ID: <87ikf3w5us.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1vMWfp-000k4P-Vv;;;mid=<87ikf3w5us.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=72.198.198.28;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX18mnrD+bsi9GaqPd61WTLqlIJTub8z3bTo=
Subject: Re: [RFC][PATCH] exec: Move cred computation under exec_update_lock
X-SA-Exim-Connect-IP: 166.70.13.51
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 512 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on out01.mta.xmission.com); SAEximRunCond expanded to false
X-Stat-Signature: 3gzakttd3ifxnw6fd1egbxs6giscye5q
X-Rspam-User: 
X-Rspamd-Queue-Id: 52473C000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1763752814-37401
X-HE-Meta: U2FsdGVkX1/qEpcjUj+D+M7b5IVNT8wLBDbPHqmNyCKiEooYs+x7LQXKbLSN372FkcQ6oOl/vRLgtc0WWMaTxxd4kUyJ7NCsmbLLTjt3iQlhx3bynTXG+0FoYx7AGg2v+ZMtQ0d3owtunQJvabzKiQ0ZReoj8HDDeHuvPtwdg7h6AR/ZTKtc3PvzdoQAmZTQyxKexwbhFBs2ueATMdFsMo+f8rS5hl7Wvif8/smmHq1KsBhXqPWgxGK4VGDvWq55MB5j4G4rZQ6IGwMVzLWDraEQJ3+OONMapT/f0nie3CWQx+oAWal69RI6YomFiVQjMHdBUOGCiiaFBcnhE3hsPZOkImuFqpD9pB6DfdsTqH9xOoo5i6KPjGbEKLKs+3wCwHCwpFM7tsIGTg2tFpUXBIwVvQeAj2V6lsHqO5EM6HwVYk9XCg8EiCi4nDy+ZN3LnTTB9peQNBHsOLcG1SRQMWtLa8w+yCazObAq72fIe2DAtxQSbMVPvgjXclVh5U5jhtCGrnTyG+AU8W+ylci4XYjOzgkLf57blbVS+gHIVCE9HIiZOLLGSUtaU6VgaaviBxHbC9GtQfmMgjrYGiLL2TV2s8yBncFkBPir/PjWcck7+Z12VIF1rQSU9HzFh1FdQI6lyWINwmjdx2yRPqM98o0qhliqvctxgBOc0PL7jcu4rKnhqCK3+8Drbm/JAbmN3AVjtOEbce+fxcQhoIIGuKqe4JLLVqChSDJl3zQe0sYKbXZA9Qef/QajeIwfIJE8DD3/T9EtZI/34Z35EL2nVlzoiCM7E3RkHTj0bkrrzjoE/J4pK7qii9ABVOdjX+cAWjXEVnkX5/KOjp/swr5TtEPOT+2oibLEBon6H2xHjZ8GnNkim8yxaDfBbtgsZyTIfPHZ5Sl7n07zybg4Ry2yxhev2smGOX05Mq4RFwNKEiBiCi7U/IWJYJtWTTeARpAQSLhZRzzZJhQtS13nGBk
 cRmeOAI3
 Y+DQn8T2UFujIC28Isc/L5d4r7WjYpEkwZfFLt2Gj/nrR+sOUqzl/uyGyL5ZwlUIoGG+joUqT48VD8SxfUk6Rw/Rc6hH7uIY6dP9yjm6qiF2MCdySrSNWXkGPLDjFnBUJ2e2rcqp2oa3YMye1nJpH9aw9MjZp0jxS/cOgoqeUtN1vNtXYyOHcfvEo9jRhh17cvn0Pv8jVXpuyYZT9To7WO9SXVIWHy3QoIkEtI3b1aE5jlbAW9aA2ov/kCHYyCQSRSB/njoYYuzeHcWC142+737GxTs4InFZkODI553IMh+AXB/4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> On 11/21/25 10:35, Bernd Edlinger wrote:
>> On 11/21/25 08:18, Eric W. Biederman wrote:
>>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>>>
>>>> Hi Eric,
>>>>
>>>> thanks for you valuable input on the topic.
>>>>
>>>> On 11/21/25 00:50, Eric W. Biederman wrote:
>>>>> "Eric W. Biederman" <ebiederm@xmission.com> writes:
>>>>>
>>>>>> Instead of computing the new cred before we pass the point of no
>>>>>> return compute the new cred just before we use it.
>>>>>>
>>>>>> This allows the removal of fs_struct->in_exec and cred_guard_mutex.
>>>>>>
>>>>>> I am not certain why we wanted to compute the cred for the new
>>>>>> executable so early.  Perhaps I missed something but I did not see any
>>>>>> common errors being signaled.   So I don't think we loose anything by
>>>>>> computing the new cred later.
>>>>>
>>>>> I should add that the permission checks happen in open_exec,
>>>>> everything that follows credential wise is just about representing in
>>>>> struct cred the credentials the new executable will have.
>>>>>
>>>>> So I am really at a loss why we have had this complicated way of
>>>>> computing of computed the credentials all of these years full of
>>>>> time of check to time of use problems.
>>>>>
>>>>
>>>> Well, I think I see a problem with your patch:
>>>>
>>>> When the security engine gets the LSM_UNSAFE_PTRACE flag, it might
>>>> e.g. return -EPERM in bprm_creds_for_exec in the apparmor, selinux
>>>> or the smack security engines at least.  Previously that callback
>>>> was called before the point of no return, and the return code should
>>>> be returned as a return code the the caller of execve.  But if we move
>>>> that check after the point of no return, the caller will get killed
>>>> due to the failed security check.
>>>>
>>>> Or did I miss something?
>>>
>>> I think we definitely need to document this change in behavior.  I would
>>> call ending the exec with SIGSEGV vs -EPERM a quality of implementation
>>> issue.  The exec is failing one way or the other so I don't see it as a
>>> correctness issue.
>>>
>>> In the case of ptrace in general I think it is a bug if the mere act of
>>> debugging a program changes it's behavior.  So which buggy behavior
>>> should we prefer?  SIGSEGV where it is totally clear that the behavior
>>> has changed or -EPERM and ask the debugged program to handle it.
>>> I lean towards SIGSEGV because then it is clear the code should not
>>> handle it.
>>>
>>> In the case of LSM_UNSAFE_NO_NEW_PRIVS I believe the preferred way to
>>> handle unexpected things happening is to terminate the application.
>>>
>>> In the case of LSM_UNSAFE_SHARE -EPERM might be better.  I don't know
>>> of any good uses of any good uses of sys_clone(CLONE_FS ...) outside
>>> of CLONE_THREAD.
>>>
>>>
>>> Plus all of these things are only considerations if we are exec'ing a
>>> program that transitions to a different set of credentials.  Something
>>> that happens but is quite rare itself.
>>>
>>> In practice I don't expect there is anything that depends on the exact
>>> behavior of what happens when exec'ing a suid executable to gain
>>> privileges when ptraced.   The closes I can imagine is upstart and
>>> I think upstart ran as root when ptracing other programs so there is no
>>> gaining of privilege and thus no reason for a security module to
>>> complain.
>>>
>>> Who knows I could be wrong, and someone could actually care.  Which is
>>> hy I think we should document it.>>
>> 
>> 
>> Well, I dont know for sure, but the security engine could deny the execution
>> for any reason, not only because of being ptraced.
>> Maybe there can be a policy which denies user X to execute e.g. any suid programs.
>> 
>> 
>> Bernd.
>> 
>
> Hmm, funny..
>
> I installed this patch on top of
>
> commit fd95357fd8c6778ac7dea6c57a19b8b182b6e91f (HEAD -> master, origin/master, origin/HEAD)
> Merge: c966813ea120 7b6216baae75
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Thu Nov 20 11:04:37 2025 -0800
>
> but it does panic when I try to boot:
>
> [  0.870539]     TERM=1inux
> [  0.870573] Starting init: /bin/sh exists but couldn't execute it (error -14) 0.8705751 Kernel panic- not syncing: No working init found. Try passing i mit= option to kernel. See Linux Documentation/admin-guide/init.rst for guidance
> [  0.870577] CPU: UID: 0 PID: 1 Comm: sh Not tainted 6.18.0-rc6+ #1 PREEMPT(voluntary)
> [  0.870579] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBo x 12/01/2006
> [  0.870580] Call Trace:
> [  0.870590]  <TASK>
> [  0.870592]  vpanic+0x36d/0x380
> [  0.870607]  ? __pfx_kernel_init+0x10/0x10
> [  0.870615]  panic+0x5b/0x60
> [  0.870617]  kernel_init+0x17d/0x1c0
> [  0.870623]  ret_from_fork+0x124/0x150
> [  0.870625}  ? __pfx_kernel_init+0x10/0x10
> [  0.870627]  ret_from_fork_asm+0x1a/0x30
> [  0.870632]  </TASK>
> [  0.8706631 Kernel Offset: 0x3a800000 from Oxffffffff81000000 (relocation ran ge: 0xffffffff80000000-0xffffffffbfffffff)
> [  0.880034] ---[ end Kernel panic - not syncing: No working init found. Try passing init option to kernel. See Linux Documentation/admin-guide/init.rst for guidance. 1---`
>
>
> Is that a known problem?

Nope.  It looks like the code needs a little bit bug fixing testing.

I will take see about taking a look.

Eric

