Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A29B5CF8860
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 014146B00B5; Thu, 20 Nov 2025 10:16:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F06416B00BA; Thu, 20 Nov 2025 10:16:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCE316B00E0; Thu, 20 Nov 2025 10:16:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C46E56B00B5
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:16:25 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8FEFB55CBC
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:16:25 +0000 (UTC)
X-FDA: 84131336730.03.F694AE4
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2EDD520007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:16:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=xmission.com;
	spf=pass (imf13.hostedemail.com: domain of ebiederm@xmission.com designates 166.70.13.231 as permitted sender) smtp.mailfrom=ebiederm@xmission.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651783; a=rsa-sha256;
	cv=none;
	b=vKdirhX8sBgUkcw8PXYwoE7QxpQXEBir7E2QyGjrPkkahqW+D+csi1rKPu7VDKIdL30QCY
	rGaQpM644vs6glantdF7oDMJ+h8a+g5fXXYP3zKYvbJrc9Y5oqo+nSI7yGrlIrP8QrsBkz
	pr12WOv3TxHkTrKWXRx88L1TCbHGpls=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=xmission.com;
	spf=pass (imf13.hostedemail.com: domain of ebiederm@xmission.com designates 166.70.13.231 as permitted sender) smtp.mailfrom=ebiederm@xmission.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g7Zo1NqcibOcLFIYREG/C81F4eIqrIpL20FepJqhFIo=;
	b=W9FRTA17tomagmqFZxxf/BXs0zZCDOvByzJPuWAKvBiN63ndIK3zM8npkXod+nElcxXpBb
	nrPkQwpe3+0792S7c5p7xnY561lTJJUmoTW0LtOzgkgwAFKBUJX3gRR4vUsB2x5Ih9DFOp
	hD4CAAOioBj2JchlCzT7jMo92zkFWGs=
Received: from in02.mta.xmission.com ([166.70.13.52]:44142)
	by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1vM6OE-00Be3t-5G; Thu, 20 Nov 2025 08:16:06 -0700
Received: from ip72-198-198-28.om.om.cox.net ([72.198.198.28]:59778 helo=email.froward.int.ebiederm.org.xmission.com)
	by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1vM6OD-00B1Wa-2m; Thu, 20 Nov 2025 08:16:05 -0700
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
In-Reply-To: <GV2PPF74270EBEEE807D016A79FE7A2F463E4D6A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
	(Bernd Edlinger's message of "Tue, 18 Nov 2025 19:13:33 +0100")
References: <AM8PR10MB470801D01A0CF24BC32C25E7E40E9@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
	<AM8PR10MB470875B22B4C08BEAEC3F77FE4169@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
	<AS8P193MB1285DF698D7524EDE22ABFA1E4A1A@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
	<AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
	<AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
	<AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
	<GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
	<GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
	<GV2PPF74270EBEEE807D016A79FE7A2F463E4D6A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
Date: Thu, 20 Nov 2025 09:15:57 -0600
Message-ID: <87tsyozqdu.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1vM6OD-00B1Wa-2m;;;mid=<87tsyozqdu.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=72.198.198.28;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX19QcsFpf8D1sbddVLnmxux1sHku3bCtmFE=
Subject: Re: [PATCH v18] exec: Fix dead-lock in de_thread with ptrace_attach
X-SA-Exim-Connect-IP: 166.70.13.52
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 512 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on out01.mta.xmission.com); SAEximRunCond expanded to false
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2EDD520007
X-Stat-Signature: gn4rx3s1z61q66t86e531c1tagcmmd8y
X-Rspam-User: 
X-HE-Tag: 1763651782-231185
X-HE-Meta: U2FsdGVkX1+KVefF9xf4XX0heJvFL2wEmr8MwbQcS3IIqtYAWcaVETLKNPcFbD92kkIYFgLi2tdSf7gsPgkQt3RHOJywglEDOR9Ui0AoUJMXBCoTamJHB8n00j0d/vtG5cx1ExBIWXUKMdqnkrtNHNgIai8UjVIg61lyKF5a18WnSNTPf+Nq3MGygLZhWvXZB+3xNVywwTgn3vT4Hmm4/x2NOw/RjU7yzPnuz6X/gdm+yf7hXK5nI6PXv6qoAbcIAwqcN1Rd9LikOHGAVvCL9OYzDOrpQywp35Nwj+QbcFWWYG2SnPWFSgIn6VFQ2aQJAwY9bMtZPnSaAXavNIJhckl8+f3WTgihPE4NOngKRPQ26EQDzX2mAPAdEEYmTM/0Rpr4Wp3lFubSCt4SMhriN9ls8xeQWyQ6Fj0Wb8yyUjST8dl28Dk2iPN72gUBqzmpd+dQxm36rWAHe4+SOoyNJDuqzrz8fGwrNv2J8yiO1CWQyi6FCdAb4e/frTUIaauMUgcHBmM5hQ/T1uwTpFn8xq0gIsnq4+8O/UGswOpqXSLVzjmhHY+YkjrsbM9fgVI4tw1v0qXLlAu9ONY74SVI8j1p0iKSME5A9No5auFq8D4MiHvWon1CGrEE9HzaXgsRS5Rf33MhfzvEQ+dmhU9oq8z56HXOrkAu/g65uKxtKDs1Id7jXYte3vivsKIpJOcpydxx+0X/+awdzmPDMBBCTm3r0Gqx2iDzxaSMvSC0mDYcU2ocPccfFXjGLmJSAXvyjFBvhzuUZkOztKoqb9g96m2SvKSJYCVHxCGPpbLfPG2UIYEvejpNLZXzO+kV2asKrqIuuw+L0nzziAX0gUl3nImVg5SyhR/+G8nSIfKvWCt2s89hdMxnKyhadQqManPHrYZEON7kfBV8GrmjkC9yd8D3UC58tnax8C4Bj08pVVtkKqvN68/ncrNiWkxOBMwayqtTCx1hA+ptzHR+83s
 HTUsUcrP
 IC8Tx565gcbIzm8aSaXCVbWOqTvu6zkeXJBIbKZPJ9k+lT2lpkMMH6XF3cHLY9oRnXt5xAtzgCNx0Tsp8HJmRVcFAMDz22kiT/eVRWBwdVam5F9hW1JaJsAAw++SowkVA07hpYofKFmBvCfRNOa8eNINj0nYclP5uQvq6H+1Wlq6KFHD4vPLoa+sqHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> This introduces signal->exec_bprm, which is used to
> fix the case when at least one of the sibling threads
> is traced, and therefore the trace process may dead-lock
> in ptrace_attach, but de_thread will need to wait for the
> tracer to continue execution.

A small quibble it isn't a dead lock.  It isn't even really a live lock,
as it is possible to SIGKILL our way out.

Thinking about this there is a really silly and simple way we can deal
with this situation for PTRACE_ATTACH.  We can send SIGSTOP and wait for
the thread to stop before doing anything with cred_guard_mutex.

PTRACE_ATTACH already implies sending SIGSTOP so as long as we have
enough permissions to send SIGSTOP I don't see that being a problem.

The worst case I can see is that we get a case where we stop the
process, the permission check fails under cred_guard_mutex and
and ptrace attach has fails and has to send SIGCONT to undo it's
premature SIGSTOP.  That might almost be visible, but it would still
be legitimate because we can still check that we have permission to
send SIGSTOP.

Eric

