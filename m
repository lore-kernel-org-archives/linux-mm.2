Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7EA0CCFA13
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 17:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C08FE8E0005; Sun,  9 Nov 2025 12:14:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE0DA8E0002; Sun,  9 Nov 2025 12:14:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF67F8E0005; Sun,  9 Nov 2025 12:14:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99DE18E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 12:14:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37375BC6D1
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 17:14:40 +0000 (UTC)
X-FDA: 84091717920.15.F6FED74
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 22F5D2000E
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 17:14:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mpb9ndl+;
	spf=pass (imf13.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762708478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F5HpPOlX4A+IDC0iS/hUD8BvRwzAlkYdd4UARWjCrtI=;
	b=yhRkjl9W4aJZx6vxzKPVexHGD2eGnjAHtHpUaCBK3/VaEgYLID8XfFR6jPkplQXnrYNSca
	G4naeDMvIMtAvPZxo901lEvWmbI2I7wGf6gMz1rgK/Szd27RAEz47v2ftL550u6oQ8iRdX
	xaCB5YlIV3RtJDf89cZMktwH1AVAG7E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762708478; a=rsa-sha256;
	cv=none;
	b=yTTU6PDb3dOHXqAlhwRUR90WLJtbMBk5WFz+IvXJUTA0Kkxvn/qQZC2TXOkU6sFcDC3bSV
	ZykpuMAmhC61bOxnL3BXxxCidUwTPj5W6UgSByTt/juY8it1EhOekfg6zDRhDTHtRFT9Cb
	cW/tWYle0v9/E03I9PiJHsVgGV+8ZAE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mpb9ndl+;
	spf=pass (imf13.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762708477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F5HpPOlX4A+IDC0iS/hUD8BvRwzAlkYdd4UARWjCrtI=;
	b=Mpb9ndl+TiDNpBmQsz6kbSW8q46zCfijH5GTTrERTfTmdSQKLKheoxGiWsL6dbYLRsSYtq
	9H4G0JvZ0HGKkKQV7UHX6R5U1uPwJBsdiZweyOPZccYAKEs+0HkBN9iy7JEE0D6RpTYYYB
	eDltsOybay6mfzpxWsBqNQWckhwP/uY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-346-P45cLDM0P8SsWBX1eHJ3Qw-1; Sun,
 09 Nov 2025 12:14:33 -0500
X-MC-Unique: P45cLDM0P8SsWBX1eHJ3Qw-1
X-Mimecast-MFC-AGG-ID: P45cLDM0P8SsWBX1eHJ3Qw_1762708468
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1EA1F195608D;
	Sun,  9 Nov 2025 17:14:27 +0000 (UTC)
Received: from fedora (unknown [10.44.32.53])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 6443730001B9;
	Sun,  9 Nov 2025 17:14:06 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun,  9 Nov 2025 18:14:26 +0100 (CET)
Date: Sun, 9 Nov 2025 18:14:04 +0100
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
Subject: [RFC PATCH 0/3] mt-exec: fix deadlock with ptrace_attach()
Message-ID: <aRDL3HOB21pMVMWC@redhat.com>
References: <AM8PR10MB470801D01A0CF24BC32C25E7E40E9@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AM8PR10MB470875B22B4C08BEAEC3F77FE4169@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AS8P193MB1285DF698D7524EDE22ABFA1E4A1A@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Stat-Signature: o6o681t51jdio59tceqw9resznz6r338
X-Rspam-User: 
X-Rspamd-Queue-Id: 22F5D2000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1762708477-116740
X-HE-Meta: U2FsdGVkX1/XC6U+EZmc0MV7fEitKv8Ye7MMVbNwDUk2N2mBhKho6/xDYT5SkQPcV+cE46fkrsT7+F1GS61z3omZ4PmoK1qnsz4qcou4PGkBLkqKcwxZwrvu+IQfnn/NsrPpymaPIjQtjZM9AV8VLhyHTavCDYUFFryp7sHRaX4iUI5TJhisS7l9MFnI1L9v8Oa6ME8QFY/+/UtSO2GvyEjq2Tlss2awq5w5wpmyALs2ZNLWBt/FRpM+daQrCTFB6t13Qb3ZF9Wenld/V1+5AmFxk/OpO/IDpNTsHpr4NnY87H76d6SZ3iyubCzLsUqOBq2AGlHBVjzeJabDd5nwaDdtWywOclITH63m3stPgRCh/iKO+MQRdVuFcHrB57vEx6giLqB3iwA8QmgobRcbBfCCRAnUuR7eB0czKIrLrQynlWYBE/f8FqDyK88Bnw/SUsK+Yf0w5o+lzNGUXQoYmvGDdFLab9BdyN1ELt4a7GdLl6NltjbVNjiBv774qUvaPXUClmDidoW6vR5BnETuG/jeJ2w741Q8JN4xYS8OJ2qfr5jxDmSLUb7LxdxL6D6wZ/+CBe5CcfXqBxe7MmEH/csVoq5g5pgiR0XEdHkH7WVMDRMI1XVLlEhDKGIcpTyAQ4/9jGhWXUN1D6J3E6FFIEk+x9Vf+qJRvmUV284Dk3OLX0MBHCOQIwUjIpHNqXMXUiOzkJcx7H46PvNLYNd9/cpje2k8VHN1rmzC2xKvqfdt+Konx9xetjlkPNedY0/xaOngVsD7obBOksm2hfXMRjotFWI1wWieMPLoH7Kx85jqxj7MmJqNWwbrG5IvOhXDeGL2gjElQz/maTMFXKI+y/Glv/+obvFL409KHcX72dme35n95MJVpW5QXsYnqpJLve3vAYDpqA9WsDRDCmJERqkc1oZIQkDMXCWFJuMdi0nVSb+b0Hae8KNECgPjHL+sGOBs5gI3/rZ9KzA1IWN
 xTs73SFS
 z4Fa44fM9a3JugrtapjPVKsEBNhkj1v5XgZMyPdGUSXsiqXv9gI4tF1tLaYfnh86ZwajOlgSLCzxgE5+zfGVhRe1XZRzbsMzr890rOatX8sCy0g+vilA248eQoGdiomIwyG2U3vH2MjbxyluEdTh2odAeqGGy/2wOgjA8AsdDt7cAIm/G/+7bTPY+jFA5roOMoAPGotoNiIfHS+t99S20qR2susbWfsFYBGJqlBV/eW7VO97O8ntru5JxorBN4/i7fPsDNe92QZ53kuyEQSkyQxPWjLIguNTnRhbRoP1mYRgwroZ0Bq7PkBOuiCCM3N7melKE2dAjLSx5LaHsFO/eOZ+sluGON4hS5afS/HW1zm6ScT8gZFW04FIlKOdLmqO07QHf16lUuemWP7WJdHVJxCAihuAu08r4a6YDgAxUtuH3+SfMYHgBN5j3wz0z6CTwUNLQPtSlXS6crFZuvpht6ckJ6T7lA/2A1N0ipbWGCDzXrEzLGKYd2UZNftekSPrLGh6Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Not for inclusion yet. 2/2 is untested, incomplete, possibly buggy.

But could you review at least the intent? Do you see any problem with
this approach?

This problem is very, very old. It seems that nobody can suggest a
simple/clean fix...

Oleg.
---

 fs/binfmt_elf.c         |   4 +-
 fs/binfmt_elf_fdpic.c   |   4 +-
 fs/binfmt_flat.c        |   4 +-
 fs/exec.c               | 142 +++++++++++++++++++++++-------------------------
 include/linux/binfmts.h |   2 +-
 kernel/exit.c           |   9 +--
 kernel/signal.c         |   6 +-
 7 files changed, 87 insertions(+), 84 deletions(-)


