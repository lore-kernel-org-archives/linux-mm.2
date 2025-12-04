Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 256ECD1D868
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 05:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED036B000E; Thu,  4 Dec 2025 00:50:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5116B0010; Thu,  4 Dec 2025 00:50:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B37F6B0011; Thu,  4 Dec 2025 00:50:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 493C36B000E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 00:50:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C25C48ACE3
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 05:49:59 +0000 (UTC)
X-FDA: 84180712518.24.1A62B42
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6BB4D40005
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 05:49:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=nXmoy3q7;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764827397;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s6+X3uAjfnbMKEn6Xkh/hO+HnZ24JeUWApwybKJc010=;
	b=ks8G/AtdLTPx4B+sBZ/UTdkBo7AClFaJ13LaYvjd/3AVDfpoq0rSWa2EAhAsxEUeDBXzWn
	iA+JvScE5GZHaj+n0ZPqO35BLp+2tAMdFhLqatiCEnuGslARTjRxhHBVLlEZgv84U9KO2d
	Hl7Md1MhY+JPmPqYjVyQFox4xINxSLU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764827397; a=rsa-sha256;
	cv=none;
	b=hi2WoTC1pH12dgoAp8xO8huHVzS0o3UCEyDK3YUJ7IFkpUK4WQxWzUfE7/MA1K2s+DymXK
	r1RwFl+nnAbCujSrg5XDdpY/k4D9ijjm2bcUkvpP0tAdRu4mCAkJ9Xsv4BUXXoW++l3kiq
	gkYBWZNtJr8FXOaqYsOQODdTNc9ZtXc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=nXmoy3q7;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=s6+X3uAjfnbMKEn6Xkh/hO+HnZ24JeUWApwybKJc010=; b=nXmoy3q7PEPpF5abxhwxO3qXvd
	TkOCDMpiiUph/GGfD1WSJSK6FPE7975gCK4ZlbwYerMAlQ+aDVWKI0+zdSP+F0KjPdtQh7MNS982p
	z3URRnIZyusnvBJZ0tu+Gk9YMZthTHw6do/oReTtyIYkuoIlZyFmFoCJSyIVZsPmb/mEgU5ADU4bK
	UpeFaQlqNn8cm5F7j27o7aJ9XMA+VckFrpslNClucgYUn+qf2Q0VjoEWhwaITyMRS1yfk5eRiK27k
	h1+uW0AsswtW89hBcY65p1OQhlSrI4BenMrX6NTWbeIfKYv8oym8o/6VjEDkCnb89R955AmHDd024
	le4n+XBg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vR2DL-00000008t6s-2eTQ;
	Thu, 04 Dec 2025 05:49:15 +0000
Date: Thu, 4 Dec 2025 05:49:15 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
	Roberto Sassu <roberto.sassu@huaweicloud.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Serge Hallyn <serge@hallyn.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Yafang Shao <laoar.shao@gmail.com>, Helge Deller <deller@gmx.de>,
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
	Eric Dumazet <edumazet@google.com>, zohar@linux.ibm.com,
	linux-integrity@vger.kernel.org, Ryan Lee <ryan.lee@canonical.com>,
	apparmor <apparmor@lists.ubuntu.com>
Subject: Re: Are setuid shell scripts safe? (Implied by
 security_bprm_creds_for_exec)
Message-ID: <20251204054915.GI1712166@ZenIV>
References: <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEE807D016A79FE7A2F463E4D6A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <87tsyozqdu.fsf@email.froward.int.ebiederm.org>
 <87wm3ky5n9.fsf@email.froward.int.ebiederm.org>
 <87h5uoxw06.fsf_-_@email.froward.int.ebiederm.org>
 <6dc556a0a93c18fffec71322bf97441c74b3134e.camel@huaweicloud.com>
 <87v7iqtcev.fsf_-_@email.froward.int.ebiederm.org>
 <dca0f01500f9d6705dccf3b3ef616468b1f53f57.camel@huaweicloud.com>
 <87ms42rq3t.fsf@email.froward.int.ebiederm.org>
 <GV2PPF74270EBEE90CDCD964F69E806EF58E4D9A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GV2PPF74270EBEE90CDCD964F69E806EF58E4D9A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6BB4D40005
X-Stat-Signature: 7atxm1i8nq8pupruaws673pz6ximq4gn
X-HE-Tag: 1764827397-349277
X-HE-Meta: U2FsdGVkX1/DLT6soZwsg+gkwWlQlABFLw916qqkG/ulFD1SjKgK5RvpteW6kZy5GO/a3kNOQp6y4mrg0LFFTGsSO31zcg+GYSSlQXzLhpJqy9OqGVA8DiHgU7qwIq1it1jzWjE3NwfUDavu/eiLmm/UhUaY4Dw2+Xfy2Bmb+K13pamQH7dllAP5TKpobiQiynMxMUQD4sWVWfv1nOJeuv+lT5AmKMvwGcO51+7+S3t44ACAO3I47QbbowzKaL9I9LVTz2ugh/Va8jJ+el/8183z3cYknkg8UQMlWUyB33R82S5i+Rs/OL8ljIg1kiaiFcbkcFqDCua0vIzMm5tCqNtMTDqcU6gjh7D/nx5LlF8wZ6EKXbs2yl/btnya1FcduZuNWu4l1M6boHVieHRXzduINo63eMjv6RdIKhtA5eepROIXNdZC37ccT0jDCyPlPY2xNL9nrF17pUB+Svat/Jg1CpB9zZf55EoZ+3oXes1S1+kbevf12Ms1+AmqZsmgDiL9hEkMYrBYPCwN2lzC2iRTljgoSZztk5qlpvChQ2hKYpFkUkBvST+Ux9r3jzmPmAXc55Ksgn5c4gUQidtYrtFvuHfQlujalUp44PUqvMeIJ4ujcJVYD5CSFcW6JQtXedJWFI/n4b96v8Ma7qiUJl6167yPvSk4nlT7eC0Lqk0Qn4Do9zpnNx6VP1tHQ9pwseMKQf9g4P2u2UwHLPhExDnc7YmeglA0c051uwa/HRpeQhFIBul+hcXd0lMTTZk6bPN3YONdaWXfmXCMXVt5pgRsz21ZU7rNlqT5Jt4wQbCVb5RFY8IRdTBO01L75fRdCQdy39sgSwZhDveyGhdhJS064STRALhc10oKdombrRF2s3+wKpBii/3jzBw/YAB9AGJqh+Y9PVYWKZJ4IulBmlP1+nSgiFTcyhphv+NPRflwq86T7C/4ik7y4ZpsBRMoeEqJJ7nzIbLI7ZFPn8D
 GBNWGe5L
 DKhuCeFk3LfUmsYiyY0To85jXJXwvl21DxcHVKbSRVZXxD9ism1+zn+KRKXjf4Xuz6jUe0w032oPSeYkMefprweKbfGWjPt/fJEnN523QG4dGv5HUlW8z7ZQTb/Ooi1tiozjSXk7HeV0Uf7vgLU5pRr6TbASk/Ew3Y+HD+7KZydmVqKLZ8pouwglol9GBQPGxqfPnKFcSb5JL98K4CsoAkyfrCxAaS5H1EwtvURH9iUdzoeiqEhHfUeQcJPMuo1RHNkss4V8475Gspyt7qRZ4hIowh/XAV/P/1GjghfeXReMGnElxTAGdKGerp8LFdE8AuNupbXMbfHKPkZlKOyvGgRzF3RKWzwiVxIgA2t/3RUuZwsRPl2FlZQI4VqEpUtWB1Lpynchwx1CtxzdBqjTx4eGfyLcz03pdUUQ5XijQe4yC0CEmcL9NMl1WCyL6n7ZQXWUaBgebTtdoGI/LaMoX0JdIGA8F4v3MDa3NwGr7lJrLV8wEBOsJuaevKtgx1ISPBhw9tvQhxr0GvvbpzG2h/1Zo8g6bdtzz8K046uKE5x+jasTkEPTrp2YIQ2JiOHhYd5A8hWydfsDMpjKFsAbIGh8IrDv9Tw8slhHsL25xWRcXIZbfpgpM2CzIHRUQ/tWw/4FpqArdIRgdOBZboKHcYiL+MFBfOiwSNWP3gSSX0YXFPbCEcgG/DV9Q5r6FeJPkpCrw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 02:16:29PM +0100, Bernd Edlinger wrote:

> Hmm, yes, that looks like an issue.
> 
> I would have expected the security engine to look at bprm->filenanme
> especially in the case, when bprm->interp != bprm->filename,
> and check that it is not a sym-link with write-access for the
> current user and of course also that the bprm->file is not a regular file
> which is writable by the current user, if that is the case I would have expected
> the secuity engine to enforce non-new-privs on a SUID executable somehow.

Check that _what_ is not a symlink?  And while we are at it, what do write
permissions to any symlinks have to do with anything whatsoever?

