Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45CFDCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:47:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566D48E0023; Mon, 10 Nov 2025 09:47:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53DA48E000D; Mon, 10 Nov 2025 09:47:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 453B08E0023; Mon, 10 Nov 2025 09:47:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E0968E000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:47:52 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4288137EF9
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:47:51 +0000 (UTC)
X-FDA: 84094976742.22.4E97F7C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id DAF3340002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:47:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Av7Rfl7F;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762786070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIeb35oP9Vs/R5h7VhglPZyEdkMXH/upLLEanGBOeTA=;
	b=RIV7TvEVmgR8l676fW7aC3IAUe1yKxmXMrnA0EdS/a8ZjbU8QLwaRMBuHOSaGkKAY2G14c
	SCgH+SYtXS//rZvvls6nFYbBustpzrRM3GqwC/BseV4N7HFr3bA80ZK7Pom+51NXteOYmD
	fqnmFS+iFMBzDyNPljWtcDTRktqgkHg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762786070; a=rsa-sha256;
	cv=none;
	b=t0nrTCMuw2Lc1uKJZOfeiT3Y5w/IfvxOiaXL7rqwbG1tHQY4bTwJgZ/uuAEEz9xC4u8glq
	bb9gcXDd5jYAQJeRoKz0it8bsdj1VmnNIQKY8A2imqyXo9/TM8ejEAbz+POS7/VIkdgekc
	TaSFVmzZuVqm7cXchRrvzRrculHbHTE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Av7Rfl7F;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762786068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uIeb35oP9Vs/R5h7VhglPZyEdkMXH/upLLEanGBOeTA=;
	b=Av7Rfl7FzLqMYzwuLuWU+Cns8e2zdqv66+WHDAw4MzeWxtX7efipbRIHv5Qp5derHiCgrV
	hqR5FX8cIvf5YgeSPu6ezKcbrwViWzxODtO/uzlvYuU7G3M4R3tvVpEaajPSvYVAD1ypgg
	d18VIj2p7v/ra81YSWdO/PW7d1OyXb8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-502-b2a0058xO8GOujbU21T91g-1; Mon,
 10 Nov 2025 09:47:36 -0500
X-MC-Unique: b2a0058xO8GOujbU21T91g-1
X-Mimecast-MFC-AGG-ID: b2a0058xO8GOujbU21T91g_1762786050
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 49CC218002CB;
	Mon, 10 Nov 2025 14:47:28 +0000 (UTC)
Received: from fedora (unknown [10.44.33.158])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 787811800451;
	Mon, 10 Nov 2025 14:47:08 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 10 Nov 2025 15:47:27 +0100 (CET)
Date: Mon, 10 Nov 2025 15:47:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Dmitry Levin <ldv@strace.io>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>, Kees Cook <kees@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
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
Subject: Re: [RFC PATCH 0/3] mt-exec: fix deadlock with ptrace_attach()
Message-ID: <aRH66lGd-OT4O68C@redhat.com>
References: <AM8PR10MB470801D01A0CF24BC32C25E7E40E9@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AM8PR10MB470875B22B4C08BEAEC3F77FE4169@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AS8P193MB1285DF698D7524EDE22ABFA1E4A1A@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <aRDL3HOB21pMVMWC@redhat.com>
 <GV2PPF74270EBEE83C2CA09B945BC954FA3E4CEA@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GV2PPF74270EBEE83C2CA09B945BC954FA3E4CEA@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: pgg66q4axgh1x8t7xxwi6i81ce69hrh9
X-Rspam-User: 
X-Rspamd-Queue-Id: DAF3340002
X-Rspamd-Server: rspam10
X-HE-Tag: 1762786068-354441
X-HE-Meta: U2FsdGVkX19BTO8JTAggMvGmkwZJ2tFELP6mX95Z7zStCCEMJQu0ROmY1xWqLxNl6LSyBb3VEQrnMY0GraUua21S3NZTFbwjoZbalNAia02Y/S4hPs/hM5cuSu8yDz5Erh1wjCYhTtwo7NSQboDFoMk1TBhLAzsZ2wmMSGlbzAVkfSkIuH7dTVgoS66BCig+7+MWd4Qf6MkkX+Vz34RXdn5j0FeCZ5Z8dvk1mb+MD+ctU33Y/EzuhWfH77CjzDjAQgNsNQtrYL3sSZXBahKcOf/gUNa6pPHC5p6+5KWGlGUJOBmvU+gdKjWz8br3BAQty5q+WB/P/iv9wll/QbAEL5P8fkQfHNZSI9pyz9qICflHrxIgINBGV/ZE3xsfPmIgnN36EAVyFQJlijhmIDzDUEP+YNW2iL1Ih+ZHb8VTHt883/uIX3G5BW4/zIEQ9l7jdOOlLkS6c+NgRV9zTEkdgEnvCMJRU7Cy+TkOzI7oMCrtYH69hEYpDYlY5oSWVL+bjUP8ZB9JZ3yNdI8tsysnlfc6PqelW+7egfDrwBUrImopzZi5XPWAC/ZhEzAFyHRFC/asrvtM/9Yj/fUETtoLhXbGAnEZu8Bfm7h0ftKHiPbvji+sTgnOmWGON8XO21d+yXQP/mQWZFK2H807gssP6cOR086vr1et4rQe7RYUdU2Z6qeTPyC1IWkZ5eSbCr1Ot7InjnauZVVBPy+t8eFB5JVBiL2AgWY4KYOrRX+TJdbSj4ZtsUUBWnNt3iPP/gn7jaiE/tIgsm0D6s9ihJUHZDU0BXd6vpbanw4i5kO6FSqA0vWHRlokArr+FHg7oHMEk748T/RfQcHR2M6x4dYJzSaiJmEAIORiIgJAiBYzaQJzpAKYK7Z672KPcNvMgxhQB3q6iXXrE9oVeKKPnrR1VEfyR0Fkb5/JxUjWlLrmYmFX7GuT4ywuY3qWN8lCenNAdDpu1sJzDL1gFyGuHWC
 VxjkFYjF
 YRaugquNPaiu8OiM+LyqVbzwZRkwoHx/tCD7wPlNmGvuBxAEfCUJoyw7CD+I7pMGuGto88QbcBXDMmX33phkFzH2pmS7Lb4zUsU73bJbgF/Fx+Ihvrl6gHyf9VvxG8g34xOqtTiyAlFJTGSKCMmvKrO517J2UMMmoKQ7Hmvelru0quehX2PdjzVPPq7TiQ6zvQjY3Xw4ndQZKJDJKclKPPjVni+MGeiAi49l4MsQEZ4KfrvSSzCJDPZJctzdeDUKHrI9mPyuibLSAMiemWxOT3am2owNdXTAiRITo+/BaaoeAi87hNmVPFw40PzRbUToIhWChmm2EafxAV5uXWO8QxMkGsWptTMx0a2rfreqc8Wc2b6+AUuiZHGNt0Lf8kqwdZJ2HsU7eo3fRoxO/N4S0x7riS3K5Ww8dnBwnB9wpRj3jh54+OYNI3v91Hw7dwKo0CkgrKaqR73X7MnmzTRNyqHqUo+AAMBfVJBpSeV22zCZvukINsQ2nGJX3HPMHkbD/y+DA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bernd,

On 11/10, Bernd Edlinger wrote:
>
> When the debugger wants to attach the de_thread the debug-user access rights are
> checked against the current user and additionally against the new user credentials.
> This I did by quickly switching the user credenitals to the next user and back again,
> under the cred_guard_mutex, which should make that safe.

Let me repeat, I can't really comment this part, I don't know if it is
actually safe. But the very fact your patch changes ->mm and ->cred of
the execing task in ptrace_attach() makes me worry... At least I think
you should update or remove this comment in begin_new_exec:

	/*
	 * cred_guard_mutex must be held at least to this point to prevent
	 * ptrace_attach() from altering our determination of the task's
	 * credentials; any time after this it may be unlocked.
	 */
	security_bprm_committed_creds(bprm);

> So at this time I have only one request for you.
> Could you please try out how the test case in my patch behaves with your fix?

The new TEST(attach2) added by your patch fails as expected, see 3/3.

   128  static long thread2_tid;
   129  static void *thread2(void *arg)
   130  {
   131          thread2_tid = syscall(__NR_gettid);
   132          sleep(2);
   133          execlp("false", "false", NULL);
   134          return NULL;
   135  }
   136
   137  TEST(attach2)
   138  {
   139          int s, k, pid = fork();
   140
   141          if (!pid) {
   142                  pthread_t pt;
   143
   144                  pthread_create(&pt, NULL, thread2, NULL);
   145                  pthread_join(pt, NULL);
   146                  return;
   147          }
   148
   149          sleep(1);
   150          k = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
   151          ASSERT_EQ(k, 0);
   152          k = waitpid(-1, &s, 0);
   153          ASSERT_EQ(k, pid);
   154          ASSERT_EQ(WIFSTOPPED(s), 1);
   155          ASSERT_EQ(WSTOPSIG(s), SIGSTOP);
   156          k = ptrace(PTRACE_SETOPTIONS, pid, 0L, PTRACE_O_TRACEEXIT);
   157          ASSERT_EQ(k, 0);
   158          thread2_tid = ptrace(PTRACE_PEEKDATA, pid, &thread2_tid, 0L);
   159          ASSERT_NE(thread2_tid, -1);
   160          ASSERT_NE(thread2_tid, 0);
   161          ASSERT_NE(thread2_tid, pid);
   162          k = waitpid(-1, &s, WNOHANG);
   163          ASSERT_EQ(k, 0);
   164          sleep(2);
   165          /* deadlock may happen here */
   166          k = ptrace(PTRACE_ATTACH, thread2_tid, 0L, 0L);

PTRACE_ATTACH fails.

thread2() kills the old leader, takes it pid, execlp() succeeds.

Oleg.


