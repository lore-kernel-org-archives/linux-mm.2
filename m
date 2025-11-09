Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BDBFCD13D3
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 17:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC1048E0010; Sun,  9 Nov 2025 12:16:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97CE8E0002; Sun,  9 Nov 2025 12:16:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAD2A8E0010; Sun,  9 Nov 2025 12:16:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 999518E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 12:16:57 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3DFCCC0A36
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 17:16:57 +0000 (UTC)
X-FDA: 84091723674.17.3A767B8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 63D1E18000C
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 17:16:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DvboeJFE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762708615; a=rsa-sha256;
	cv=none;
	b=yrzq6K3OVjk3kRndX4kBQs1zDZEDVSL8pLBXYfg/VZ/Cu+Otm5gni/YTJipjdFQLNlZndG
	hSSYdsmuF0oItxRTRVTk1F7jW8MTbIBHJ85OF2B4tbogUULLIaDPbd3vONpnJZdSuhijDc
	JUx7/zjxdHq94htt/uUCxs/34VVS55s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DvboeJFE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762708615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=De3qwJZddIJhWbGGVbrDOYNQpF2Q/objdb0xufnPYfw=;
	b=XL6Hi7cPK2ZG09zENvKL+SanYD3D+cCjGs4FcyI+N4FCY00bdQN/93LiMmy9WskjvMPriz
	sA2PQjGDi/LJI22Fqe7HeaFCgxkLIjgSbV/8t3wbjfR8WHMPA2SPwyct1AQwgbrDT/DT0l
	7+pd6vc+BDNp5dJc+EaWpcwPnZPyyWY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762708614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=De3qwJZddIJhWbGGVbrDOYNQpF2Q/objdb0xufnPYfw=;
	b=DvboeJFEgHjvBK6Lp0xPh1eOARZ3W7KGXX1lEjiTEJZp3uzEjjiaPhFXYcQMWD208d0RD4
	y0vcxYtHuI/KfCErQcEoeZjtu0P7MoKYHQalOqJ7udiVmj/iE3Bo2hZnS1e562zQIq8xL4
	m0qQSnJfMp2ycvPEKGFj5+TaHmk295E=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-sgxsSvgzNTOqDj75cxvXMA-1; Sun,
 09 Nov 2025 12:16:50 -0500
X-MC-Unique: sgxsSvgzNTOqDj75cxvXMA-1
X-Mimecast-MFC-AGG-ID: sgxsSvgzNTOqDj75cxvXMA_1762708604
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0C53D19560B2;
	Sun,  9 Nov 2025 17:16:44 +0000 (UTC)
Received: from fedora (unknown [10.44.32.53])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 3C7C919560A7;
	Sun,  9 Nov 2025 17:16:19 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun,  9 Nov 2025 18:16:42 +0100 (CET)
Date: Sun, 9 Nov 2025 18:16:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Bernd Edlinger <bernd.edlinger@hotmail.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dmitry Levin <ldv@strace.io>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
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
Subject: [RFC PATCH 3/3] ptrace: ensure PTRACE_EVENT_EXIT won't stop if the
 tracee is killed by exec
Message-ID: <aRDMYSuEV82irPmA@redhat.com>
References: <AM8PR10MB470801D01A0CF24BC32C25E7E40E9@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AM8PR10MB470875B22B4C08BEAEC3F77FE4169@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AS8P193MB1285DF698D7524EDE22ABFA1E4A1A@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <aRDL3HOB21pMVMWC@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRDL3HOB21pMVMWC@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 63D1E18000C
X-Stat-Signature: wt5pd9kfyt4h8erdz9yppz3akx4yydwc
X-HE-Tag: 1762708615-797772
X-HE-Meta: U2FsdGVkX18ONnuDkyCXfSDTJ7auPucTTVPC+ZABFF0HJaND4ARezx23I0FZ0RNaVNYfgeuOo/NTts3NRkqkekTVtpSj2T/pVHesqNKwBIyry4Z8XkDpvmGaKOGNkl3+x95fuqwc1xtF11ioTPo7Pfmsjdg4vgWsCHg5T6z+UlomNFeM/U20wDUvW0UAJHwujWcjH0TW5j/EBNnNLtUIli+q917bcUvlO329eCX3YcSMtqKvLxRB1N9KR5bGezly0jejItEjirwh2fzQgNQKF2UhA8PIWtR5OyqY81UYiZ3UWwZhog/ATyuBuSu01DeKQ650j7L8kurALTkx1P59nEXZjzsKnzSU2tlMTyn2FE4CX/fk6VfUFRD/XGpjPLIWtcUCkUvcfRpdJ9R3cgLjv55ouUAWGBQogFggmyohSUb25P2h7t/k4s0iShDEGVgWKJaJW7FCSJV+m+729tI4v1i9FbpmNHhcZl6mME2uf/avaqSdP7y8wmGPaEbpOMnDgpWiNpOyl7bd9hw7Pu1cGRaKLQehDyFaVS6fnXLmQjrurWlfZjMPI0veEL6zGb2LBjZGr8liQi8OaZpP2YdKZUbS4Fy60LRNlQBEx15t0fMNrkakpdie6tweKXICbVJsgvuSdvNR4tWBM//BVNgAyrntf9gfhpO4aLMTEcuuJLn/mFuxdoZiiyzY8OlldeTurNxlcfS/a94QCwKi8POGB+Tf7Up5MvHuo0oDYNQwyQikw45ChVv5QMYVIpMplzSm/mJza3o3f3teWqMC1B+FZMXbXViWMxAcpngwovmMNFXB75Z4q5GoAyeHD6FBoOGyACjHxH0A3XF7/8pu57tAwILA3IsrkPdLQ5ME+ldgt15zUYVxEHnjbg0f/pS7iK09DNIIPh1XnaLN6EVACk1ejMqWWx0Z+Rke5R9iPkfU8eqmKhVmVrVQxTIBVkKJ5SyqPPUBNzqfOKZ3ekjExNL
 2Rn7gkmY
 Cs8eIm8PZjrdjyqH4c9FlvxY8rRExqHbLvUqww3rZpR5O2oNHg8Uzvg6hfaFATr4V4H9O9sV/SvODtNCCZgWMK+WZPA1RDsmudImAbZPny9f4gwiygTcDtxrOiniV6urKMKVFIgtAJkd7xd2peZQ8AY8a3XREj6BzvO9jixcp7yzS+M58WwAoNJZ4uPDH7YVkk0yLxA8U4DqQbURyphztBMER995fgdud5QCyzQLAe9W57I06XyTmPTlP4EOTFfr+AD+9biMKURepODaQkGRavpKK0jjwqCeFAV/ae5dnth0qMVgQSLAsi9hw0kzlUvzvuzqqZ3aoDrC5NCurIaBdQ7i0T/+flvjMN6RAmsV0A0Rar+LvytSOsr/LOTtiyDfifeTSqu3KKJs3X4elgIwbvUGitqlSSQ6md8r9a5UqaQA0RXtn24na/RwaCWObQl8P0QQ31WtCAAUloxnK3s7VUOCZnvEnwNKmWI7QCZJ6m0CmIsdKNpdsPe6EvZ0MFHwaxzfgWAYtwumww4PKADM4dWSkFtcKV1fLOy+bKRcDBwSGcG2gP5QLE9uEIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The previous patch fixed the deadlock when mt-exec waits for debugger
which should reap a zombie thread, but we can hit the same problem if
the killed sub-thread stops in ptrace_event(PTRACE_EVENT_EXIT). Change
ptrace_stop() to check signal->group_exit_task.

This is a user-visible change. But hopefully it can't break anything.
Note that the semantics of PTRACE_EVENT_EXIT was never really defined,
it depends on /dev/random. Just for example, currently a sub-thread
killed by exec will stop, but if it exits on its own and races with
exec it will not stop, so nobody can rely on PTRACE_EVENT_EXIT anyway.

We really need to finally define what PTRACE_EVENT_EXIT should actually
do, but this needs other changes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index 334212044940..59f61e07905b 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2376,6 +2376,10 @@ static int ptrace_stop(int exit_code, int why, unsigned long message,
 	if (!current->ptrace || __fatal_signal_pending(current))
 		return exit_code;
 
+	/* de_thread() -> wait_for_notify_count() waits for us */
+	if (current->signal->group_exec_task)
+		return exit_code;
+
 	set_special_state(TASK_TRACED);
 	current->jobctl |= JOBCTL_TRACED;
 
-- 
2.25.1.362.g51ebf55



