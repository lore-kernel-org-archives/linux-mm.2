Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B45D7CCFA13
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 17:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21FF38E0006; Sun,  9 Nov 2025 12:15:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F7028E0002; Sun,  9 Nov 2025 12:15:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10CEE8E0006; Sun,  9 Nov 2025 12:15:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF82F8E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 12:15:25 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 878A6140A39
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 17:15:25 +0000 (UTC)
X-FDA: 84091719810.12.01E10BB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id BD048A000C
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 17:15:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pgmrysgp;
	spf=pass (imf15.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762708523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CH23Ki9EOjG++XfGf0hWyR5UKo/5fVuG3elhs2g375Y=;
	b=0PY8oJqeXK6d0sOoCJ3Dltw2/jcT+vkCt5gPzq2KUB2wRrPOaExGGKO3yvFGxEAfxMBdCf
	Yp7u6kceNtbSsIGdqUHHvl8OlYOCnZpovE83t0hnAg9phAKhJ0ERDiwyS5kV2plDhLl6io
	iKSjzOktNG/0jkglCTGvsi+lztrtlkg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762708523; a=rsa-sha256;
	cv=none;
	b=J5SlC4zwNkqiLtoM/M81n7Ef1tsdVsxYy0/GpptllmHDLnQPKuC3jv6EuOp3KfkJ2b6HgS
	jRZqhLm2fT7COJKNhE46F+qmGHBI2GScKZ3vddMXMA9XyJN4EDdwlyHLG362HMjpOBQZ+r
	VgnNsappzQ+7Yi+XRO97fNyMywrjkeg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pgmrysgp;
	spf=pass (imf15.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762708523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CH23Ki9EOjG++XfGf0hWyR5UKo/5fVuG3elhs2g375Y=;
	b=PgmrysgpS/nM6fmM6cgvEQM+wfMQZwOHA/wr+1NlUe/ZdirVEyL9pjyCdorcXkUHNRvhMx
	Hp5CMgpW68/q+nFSOMXiwPl5duVO9K3Z7DTdBNO+f4UZLSifPcK1Y6puN03TzIjf1kTdsC
	LNyRLvSMqHNF2UINfKrLZr3FgbhU5hM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-hba6nzFHMM2ZSUG6656qEw-1; Sun,
 09 Nov 2025 12:15:21 -0500
X-MC-Unique: hba6nzFHMM2ZSUG6656qEw-1
X-Mimecast-MFC-AGG-ID: hba6nzFHMM2ZSUG6656qEw_1762708516
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0CA8E180048E;
	Sun,  9 Nov 2025 17:15:15 +0000 (UTC)
Received: from fedora (unknown [10.44.32.53])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id C8655180087B;
	Sun,  9 Nov 2025 17:14:53 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun,  9 Nov 2025 18:15:14 +0100 (CET)
Date: Sun, 9 Nov 2025 18:14:52 +0100
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
Subject: [RFC PATCH 1/3] exec: make setup_new_exec() return int
Message-ID: <aRDMDLgLdYq9g1Tr@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BD048A000C
X-Stat-Signature: oc1x8zooncu83sfmngae6fhnaf6mr4yx
X-Rspam-User: 
X-HE-Tag: 1762708523-270355
X-HE-Meta: U2FsdGVkX1/5nvJEunuXJ1OUyGVsaoysIH7RQLrzCF3yWt97eVyXJjEMHa8XOpiRKcxYRu/xhXFCzI6HTaSRel4cMXSG2ukWN/qnzDRGlrhLqL6F5QhrYLJDkqGdJWKfjHmWpzH+pzsWb2iiaS8Gruka/ArvaRtzP7CuOV8JAaGOrSC0VJABYrxcJiIs0jW6UUdf9FfvqwP5z6y2scD9eaLcMEobuxNV3zfRvb/ehYWpZTvSR+7HvaQyMFsPM3RpoR8eKVMx77aVAm6TXfuTKpKOPlC4HS/U16kpNAhn3sf9baQbVa0qx5FjIMEekArSFwPoKLg4cXRIYurTCZy6odEPrdoiexKFJDCc3ctY1bRtgFjnrmRiNMB/c8RX/z5vKbC9+YCz3ZhehOeX+VtuEeL+rCXHQHTVJ/XMW0yWNbNse+Gw1h9WiHKQxK6shFfLm2cuK5kEsxYdroQcWPBILc+zeaUHO+NmulJ3lMOtGWdE2varXFFkRwW+4XdUVIa5k2SBft4y7mh4l/Ro1kcFU7OSAgpralG6CxwoLAv2tj6dLG6xzhQSnPfk2rczySbTo+FcYDevDWOQ8Bpa3E62EcjT5jQ7kibRTx0YFUwwLwLYrf1jXoU806rwg+SvMKi27iVhfqCWvcfUbtFu/Vm/J7qYBB/JdT7IYtJlyZy8WQ8ebHl6wbzwVTnF/AY3axmd1G2JPga2Mr1t2VmE6/igq9EYrz2HAHCUl93ZZx/rUkh82iTSTIKJCG/H4GJRRJ6DPNoCKxo9GV0hSK6llXWT69pw1T4rRHUWTErCuMt/tcxIdJAcqAlKHPEJ3tAT5oL4SGD39sx3urzr0nEaSE8w2kZ7OK7tJxe5gXxs81+Q836fY+X/XtwOcv8FCEkKLSLn+sFDcW/C8fbJa7BjvCeftNtI441dsFrc+RnKu6geA7pWA/z1wXLiMO/NwVhxJhnO8j+CkDcymxhsVswBIsT
 DgsBoQNs
 PpFpQ9TmA7BvpJM4PyEnJr+x54pn6kw5EGrD8umuYZFibFlfazMulYPUbxYHUIE0ChvhcgT0rRSCTFsWdOQT709Z1MRM2V/vCqCoJjt0aDP2ESgeNHyO9aRTZqw0SHwo3g9THHjm8IBMXYoDwjoCdGQIyR2moVJz6+I5cFh9+hSgp4Rv0XVtG4p8/MG8tq6xfEPvsYawtMRhH987qDNbi//Sy+m+pQfvu9Zbkq6fOj6Jwjl682DnS1qgDdknl9+4Y0eJz+HL6zA/5yv67W0i1R1BTbdNeKRTv0ekaJaLJbaP/9Kt5IIhNn9R1gjwpGTT7wy3bjOrwasS9Upo10vnyn69Ao9LyNww9u7a0OnNbuE1JN0ochitUn5kCUX6VKDdTU9H9gNMrqJdasG0upxV65uEF7TjYoV4vqekvOljyJkRPp9ErWHrrrHJaTtrPDdm+eb9Rfp3aI+ydG2VAUlZCjLdstY7jxLA1VKI/CBHpTgHqkRy+48+6+ki/iE9dtyEFjrhRxnBAQwEuPyeSxvKN4htykg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Preparation. After the next change setup_new_exec() can fail.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/binfmt_elf.c         | 4 +++-
 fs/binfmt_elf_fdpic.c   | 4 +++-
 fs/binfmt_flat.c        | 4 +++-
 fs/exec.c               | 4 +++-
 include/linux/binfmts.h | 2 +-
 5 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index e4653bb99946..8a38689ae4b0 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1021,7 +1021,9 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && snapshot_randomize_va_space)
 		current->flags |= PF_RANDOMIZE;
 
-	setup_new_exec(bprm);
+	retval = setup_new_exec(bprm);
+	if (retval)
+		goto out_free_dentry;
 
 	/* Do this so that we can load the interpreter, if need be.  We will
 	   change some of these later */
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 48fd2de3bca0..7ad98b8132fc 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -351,7 +351,9 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 	if (elf_read_implies_exec(&exec_params.hdr, executable_stack))
 		current->personality |= READ_IMPLIES_EXEC;
 
-	setup_new_exec(bprm);
+	retval = setup_new_exec(bprm);
+	if (retval)
+		goto error;
 
 	set_binfmt(&elf_fdpic_format);
 
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index b5b5ca1a44f7..78e9ca128ea7 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -512,7 +512,9 @@ static int load_flat_file(struct linux_binprm *bprm,
 
 	/* OK, This is the point of no return */
 	set_personality(PER_LINUX_32BIT);
-	setup_new_exec(bprm);
+	ret = setup_new_exec(bprm);
+	if (ret)
+		goto err;
 
 	/*
 	 * calculate the extra space we need to map in
diff --git a/fs/exec.c b/fs/exec.c
index 6b70c6726d31..136a7ab5d91c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1321,7 +1321,7 @@ void would_dump(struct linux_binprm *bprm, struct file *file)
 }
 EXPORT_SYMBOL(would_dump);
 
-void setup_new_exec(struct linux_binprm * bprm)
+int setup_new_exec(struct linux_binprm * bprm)
 {
 	/* Setup things that can depend upon the personality */
 	struct task_struct *me = current;
@@ -1337,6 +1337,8 @@ void setup_new_exec(struct linux_binprm * bprm)
 	me->mm->task_size = TASK_SIZE;
 	up_write(&me->signal->exec_update_lock);
 	mutex_unlock(&me->signal->cred_guard_mutex);
+
+	return 0;
 }
 EXPORT_SYMBOL(setup_new_exec);
 
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 65abd5ab8836..678b7525ac5a 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -123,7 +123,7 @@ extern void unregister_binfmt(struct linux_binfmt *);
 
 extern int __must_check remove_arg_zero(struct linux_binprm *);
 extern int begin_new_exec(struct linux_binprm * bprm);
-extern void setup_new_exec(struct linux_binprm * bprm);
+extern int setup_new_exec(struct linux_binprm * bprm);
 extern void finalize_exec(struct linux_binprm *bprm);
 extern void would_dump(struct linux_binprm *, struct file *);
 
-- 
2.25.1.362.g51ebf55



