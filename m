Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63058D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 16:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD70E6B0010; Mon,  1 Dec 2025 11:06:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AADDA6B0027; Mon,  1 Dec 2025 11:06:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99D1A6B002A; Mon,  1 Dec 2025 11:06:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 858EF6B0010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 11:06:28 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 532178872A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:06:28 +0000 (UTC)
X-FDA: 84171379656.03.3C7C561
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
	by imf19.hostedemail.com (Postfix) with ESMTP id A502E1A0011
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:06:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of ebiederm@xmission.com designates 166.70.13.232 as permitted sender) smtp.mailfrom=ebiederm@xmission.com;
	dmarc=pass (policy=none) header.from=xmission.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764605186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jfoe8ZcSvlh+XnyCaZM0ZXbigPuP/rH8bDNejf2Ivi0=;
	b=1QyDioPh7IBjWX6uqF2u4+1f86IfGHCCjHNkodyDknDFfYe7/OCwciugPljTO8UhRADud2
	bGA2TAjDF3IoglrjS7lcrM91iskqzByInWkZyud6MfIBISlmRdKcKJp/rtOl8aRpZN2M8J
	qjTxccih7uowRyg4F1r2lGLVoltPVVw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of ebiederm@xmission.com designates 166.70.13.232 as permitted sender) smtp.mailfrom=ebiederm@xmission.com;
	dmarc=pass (policy=none) header.from=xmission.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764605186; a=rsa-sha256;
	cv=none;
	b=MD52JStGp+y0U6z0AyX5KXhter3TcWILG0vg5MfclG+uSBqU7P0EvxZ9tkOaZdU93gPymk
	+Ws04mVD4LZHA29Govlxi0KMurVYzJtmEbNL5/ljrcQQu6W4PVVUko8NCaiMdkOxzrgV3X
	zgSVoqnnSXQPCNSTtR51Noc++k4t7L4=
Received: from in01.mta.xmission.com ([166.70.13.51]:50512)
	by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1vQ6Pi-009mGN-1t; Mon, 01 Dec 2025 09:06:10 -0700
Received: from ip72-198-198-28.om.om.cox.net ([72.198.198.28]:40282 helo=email.froward.int.ebiederm.org.xmission.com)
	by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1vQ6Pg-00Cg1V-BQ; Mon, 01 Dec 2025 09:06:09 -0700
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
In-Reply-To: <6dc556a0a93c18fffec71322bf97441c74b3134e.camel@huaweicloud.com>
	(Roberto Sassu's message of "Tue, 25 Nov 2025 12:55:00 +0100")
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
Date: Mon, 01 Dec 2025 10:06:00 -0600
Message-ID: <87v7iqtcev.fsf_-_@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1vQ6Pg-00Cg1V-BQ;;;mid=<87v7iqtcev.fsf_-_@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=72.198.198.28;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX1/O4IKUzWWwapDxt1axB69s37nkia9NNac=
Subject: Are setuid shell scripts safe? (Implied by
 security_bprm_creds_for_exec)
X-SA-Exim-Connect-IP: 166.70.13.51
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 512 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on out02.mta.xmission.com); SAEximRunCond expanded to false
X-Stat-Signature: 8iy88phchxhcj47iqnw39r8iq9f9mn1s
X-Rspam-User: 
X-Rspamd-Queue-Id: A502E1A0011
X-Rspamd-Server: rspam09
X-HE-Tag: 1764605185-916805
X-HE-Meta: U2FsdGVkX1997Vzn2Er9MgxNOGX4RDHz5u85DrXU96TkuHKQPwlb35qOqPU4442FEIVCFWyoZnH17Z6Gcddof9ZejKXpERexN9QD6z1FHpbM0JFCFl8hoI9dA9wfrZ0QXIJFOClL6QYOTPtA/P7FR3JC4mG5KjnbGIj4uAEt1G7BF5uI3mPF4JeUQLO4f91FEuGSX7KzpnxqtT+1JHXnvy5NRSzV7r9qwfQzTJjfB+IcwNJFpwq3NmXdYOtN5fl5lJ2nqVZzupHMBQ1bRhOnMfHOa6SnYmUTEb2ODUzHyU5H/0eelEfHKGNw3RvBEFr8ODB3SO+d++z03NnrFOHr9ysdVsnpk6Nl4AbNDH5sKUyOGbM5zW29SfkGfXEdhXGsDtBg4FgZbPB3ZnQ0Ii2FwOMsB8TYVXV2QQ4W8UI9Iqs4REYkF1w0rOYQE5xU03uaDyIlOUXbplJ0YhZR9k5LQ79RwHYKs3NsSaPK+tnrkkzMP0eS8JPGMuK/fa7PGRKUm+5mHXShJHnnTJ+M+rU1el+Bw2Ep88+0zhekbzZhq71lg9swhDb8YbCtKOksGuq5yHFeVd5u7/kqKfTGYd+s83ul4Cyy6AROtZVOVqKEfG/UOJacaIRZu0h4leA2vtyTk9xFrXbtYWQpvj6YOn8ZqG4sgTLpp55tXoIol87x3WMEibhjgZ6dygu2FifJO0qKsYFWD5ysHelczc109TlHJmz5UtCGnKBnLouaZ0rOpsHEf8XDCTFwtLM8I+xvvvRGVArLkKzqZaLYcjusELlZpOfsQmjHQg6bknBDwI5PlaQNGTrhqmZX8erRQrgMSABfcFjdo6t7mYE9F0Fy57QQi1/f4I2C/FQfvlKqM/cgAdtglq1PWFI/iLhT9rL0YWqdoSxNcRQuxhJpqL00FHAIK7KGazcgf7JhpXUXhTJkRCkKj0jlfcTSJO4VOnxvY/xt+M1CcBh9jzji6In8f5/
 /G9bZAC6
 5rEF9iVIDmogIoK2rpO+AJZvyW61JQvQy7/SZq+QRiJTMu3iFyW2S1mmmsoJrzte3yuI/n9EhB9VyFEa6b0viRtAMojddyOFvpCxYHaqR++Q5kG9CJP24Nj4Ko+tGHsl3E44GKYV9xWRxKbx9klJsP8XoiFTTa7x+QKpf6rs97B+8PVsCeFGGLvIYlbLggjv96fZTsQv4s/r7Jd8uvY67r3kgpgiG+fFfQOvxhJt0VVmUXJQ0B8NKoKHjqhEfmL5kZSLEnJYL1UN6NBfiXRj46ifWYumZKTbqcMQqv8icGDdiCPjHYSJUSisNdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Roberto Sassu <roberto.sassu@huaweicloud.com> writes:

> + Mimi, linux-integrity (would be nice if we are in CC when linux-
> security-module is in CC).
>
> Apologies for not answering earlier, it seems I don't receive the
> emails from the linux-security-module mailing list (thanks Serge for
> letting me know!).
>
> I see two main effects of this patch. First, the bprm_check_security
> hook implementations will not see bprm->cred populated. That was a
> problem before we made this patch:
>
> https://patchew.org/linux/20251008113503.2433343-1-roberto.sassu@huaweicloud.com/

Thanks, that is definitely needed.

Does calling process_measurement(CREDS_CHECK) on only the final file
pass review?  Do you know of any cases where that will break things?

As it stands I don't think it should be assumed that any LSM has
computed it's final creds until bprm_creds_from_file.  Not just the
uid and gid.

If the patch you posted for review works that helps sort that mess out.

> to work around the problem of not calculating the final DAC credentials
> early enough (well, we actually had to change our CREDS_CHECK hook
> behavior).
>
> The second, I could not check. If I remember well, unlike the
> capability LSM, SELinux/Apparmor/SMACK calculate the final credentials
> based on the first file being executed (thus the script, not the
> interpreter). Is this patch keeping the same behavior despite preparing
> the credentials when the final binary is found?

The patch I posted was.

My brain is still reeling from the realization that our security modules
have the implicit assumption that it is safe to calculate their security
information from shell scripts.

In the first half of the 90's I remember there was lots of effort to try
and make setuid shell scripts and setuid perl scripts work, and the
final conclusion was it was a lost cause.

Now I look at security_bprm_creds_for_exec and security_bprm_check which
both have the implicit assumption that it is indeed safe to compute the
credentials from a shell script.

When passing a file descriptor to execat we have
BINPRM_FLAGS_PATH_INACCESSIBLE and use /dev/fd/NNN as the filename
which reduces some of the races.

However when just plain executing a shell script we pass the filename of
the shell script as a command line argument, and expect the shell to
open the filename again.  This has been a time of check to time of use
race for decades, and one of the reasons we don't have setuid shell
scripts.

Yet the IMA implementation (without the above mentioned patch) assumes
the final creds will be calculated before security_bprm_check is called,
and security_bprm_creds_for_exec busily calculate the final creds.

For some of the security modules I believe anyone can set any label they
want on a file and they remain secure (At which point I don't understand
the point of having labels on files).  I don't believe that is the case
for selinux, or in general.

So just to remove the TOCTOU race the security_bprm_creds_for_exec
and security_bprm_check hooks need to be removed, after moving their
code into something like security_bprm_creds_from_file.

Or am I missing something and even with the TOCTOU race are setuid shell
scripts somehow safe now?

Eric

