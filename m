Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6AC7CFA457
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 23:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4221C6B0011; Thu, 20 Nov 2025 18:50:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3356B0012; Thu, 20 Nov 2025 18:50:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29B346B0022; Thu, 20 Nov 2025 18:50:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 164EA6B0011
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:50:28 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7E9612AA0
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 23:50:27 +0000 (UTC)
X-FDA: 84132632094.09.75A325E
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6861F1C0007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 23:50:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=xmission.com;
	spf=pass (imf21.hostedemail.com: domain of ebiederm@xmission.com designates 166.70.13.231 as permitted sender) smtp.mailfrom=ebiederm@xmission.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763682625; a=rsa-sha256;
	cv=none;
	b=lrVNeacTch/aps7yqUFId7Vk3/D4mn0DI3xw2c79rvDk7MJLP3o6p/1dSdb+AoX8V4G+K2
	Xjpx4MM6H0NHgr6gLQ0UNbrTKhfdwnm8yAK3Eu4oKZMfyd82MyLmc/R808GltdtIkRiSki
	aHOFdBbkPW2lAX3l/hMRpMClfZCU4zE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=xmission.com;
	spf=pass (imf21.hostedemail.com: domain of ebiederm@xmission.com designates 166.70.13.231 as permitted sender) smtp.mailfrom=ebiederm@xmission.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763682625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IgArm/powDc2w3sfk0PrhOPR47VJcOI6WDZNZTfW6dk=;
	b=Hdrx/NM+vI+mzk+gcnhsTi//JLIxTcQ5+x/nE8B7JweoU1OFkMizFR1LXqBYLXcqHdr2ML
	ibJ7NLoTwK9wYDxxwzDd+lDUt7100VCv2Tr5LFcKe/+lk6SKxFXP7YzA+aT/TM9ULwjYst
	giJuhLPSpwZAPvjIVuhsj3TkUbiNHbc=
Received: from in02.mta.xmission.com ([166.70.13.52]:37028)
	by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1vMEPo-00CedT-A5; Thu, 20 Nov 2025 16:50:16 -0700
Received: from ip72-198-198-28.om.om.cox.net ([72.198.198.28]:35208 helo=email.froward.int.ebiederm.org.xmission.com)
	by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1vMEPn-00C1ie-EW; Thu, 20 Nov 2025 16:50:15 -0700
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
In-Reply-To: <87h5uoxw06.fsf_-_@email.froward.int.ebiederm.org> (Eric
	W. Biederman's message of "Thu, 20 Nov 2025 14:57:29 -0600")
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
Date: Thu, 20 Nov 2025 17:50:05 -0600
Message-ID: <87a50gxo0i.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1vMEPn-00C1ie-EW;;;mid=<87a50gxo0i.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=72.198.198.28;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX195NfJOcpcY5dj59+cWhIBuzpRq6EZCwSg=
Subject: Re: [RFC][PATCH] exec: Move cred computation under exec_update_lock
X-SA-Exim-Connect-IP: 166.70.13.52
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 512 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on out01.mta.xmission.com); SAEximRunCond expanded to false
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6861F1C0007
X-Stat-Signature: yjgrqir69zrbiwfr9tpfcjen8hmz4iau
X-HE-Tag: 1763682625-584724
X-HE-Meta: U2FsdGVkX1+FmgQ+CqOxvKGqMOgyKK+A2uewhdPGAfvJA4Y+qbQfyFEK3N3dy+mQk2GDHIitjURreKNeamWag5Cssp/rgXHZwNw3UCerwo7qpVMmECP2kZowzWU+hgFNLEX6v4VL40TR1oWHr9dISXJwXHW1+HDw0M5NSRekYmgxx2dZDSapQH702qt2WdvewQaEMpi8IJFc9WOdKhAOsPt6nsOVPMbqvrShlfswyH0656rMJdZgXqUipewpQbtGnz2LJYODOfbczX2DBbBfXKBVeQ/Wju21rKK3NjmBh94H44uVmR0DsyR+NKiuf92szKQzZ6ihDLLrbnK1KBWha6V8Ld7QEU+XrRjR50VgBldM8bQBu7B4mrLk/iiti8Iycdn4GR8SOhqWK1fzR//BNfUzkyAFk/xLM5tvgkUQNvdbb54Z5d+h7NbUwXQHbXVyngegeZod6yx9zYGx5fveC8f5MpdO96SC08ZV37GWHddKbrrkeYoNpV/+FJlc+Oz5tKE/arVjCimmvH0bQkJ8w/OTtKcIxnXtpvvPpiFx6wOeQfXUKI6pdzR8oJRzSuFWNy3bPd+01NbNkLZH+KXvHuh5TgHpahjnL61Y8gn0A73Ggoh3C5/J7VxAUnmpQ4OehvWwMjP4sGeIChBozqC+7BOrBCeiZXOGp5mxAmBAZSF2t4On6Ef3C63KobXeFjnr8WEuOGLQ49YJgQOc+fOq8sz+4yxwjec4cwhxZcn+sDQIh9fWdMeCXFNpJXVm898lwaC6646yctxj53UBLfKiigVtCPY138FWhugPBgs53aj3SZBrRbIDquiTqwMJzFmcOVHlM2bpW58L67YzoWytX/VaCzp978a3lLQZEqqULY1yT0yJcfXdpOFgTWqM7jonnk0ifyWdBJLjnbNYrOt3rao/2FNCIrQRFkYFVbveFLBxUxMS01FPW8PU2qXppChPpOGFw2rmCFkhlj8GOBp
 zDN1uI8P
 FmE3Tq+yksJsuJ+nw5zcx7xO+U4in3OeN+H0Lm+IvMVg7i23XfdSMaxA8ruzH45jzYbir3THh3fRvkO1SPl1kY6mj6fsCLc6AzpgSkyhTemOJwq96SHc400JAUP3Zy3azrlpQdC/BbXFgztxP7NlP28GwzlL/uxXnEd3SMQqoGyoiQca5S6GuaRQNPKVYtMlrtyqPw5eUBblVl/Dh0SsmT3y6IuVpz9Ay+RW6qcUQlJUpFuw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Eric W. Biederman" <ebiederm@xmission.com> writes:

> Instead of computing the new cred before we pass the point of no
> return compute the new cred just before we use it.
>
> This allows the removal of fs_struct->in_exec and cred_guard_mutex.
>
> I am not certain why we wanted to compute the cred for the new
> executable so early.  Perhaps I missed something but I did not see any
> common errors being signaled.   So I don't think we loose anything by
> computing the new cred later.

I should add that the permission checks happen in open_exec,
everything that follows credential wise is just about representing in
struct cred the credentials the new executable will have.

So I am really at a loss why we have had this complicated way of
computing of computed the credentials all of these years full of
time of check to time of use problems.

Eric

