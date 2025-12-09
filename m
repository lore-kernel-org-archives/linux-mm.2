Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F20D3D1CDC6
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 12:28:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 615B46B0005; Tue,  9 Dec 2025 07:28:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C6806B0007; Tue,  9 Dec 2025 07:28:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B4FA6B0008; Tue,  9 Dec 2025 07:28:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39FAF6B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 07:28:57 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7C9AB9DF2
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 12:28:56 +0000 (UTC)
X-FDA: 84199861872.09.2648946
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8451010000C
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 12:28:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VJlXEdXF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7U2McOFD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VJlXEdXF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7U2McOFD;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765283335; a=rsa-sha256;
	cv=none;
	b=mVmTb21znLmY7JJ+VFHAYqUtFM9ixZ3362nRTiys11irjvOpBsjwAS5IklTmkagojDfskP
	iVeGpa5AGRqxTDj5YrRETGHv00iu/p/v+HOkvyc9di1c9yMfEHkFTG6oRiWK7C/O/xRf0j
	K3sdLLgSRng2D2FHXHJ/RUcmv3BL2Rg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VJlXEdXF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7U2McOFD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VJlXEdXF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7U2McOFD;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765283335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ygaHW8o5EWTBSXhXnK7ekdPvbFwd/VSzrB9zkhVTLRQ=;
	b=xDQWRRROBRqkgWdDAELrK8TOnv7ssn+xCe5cv7Y7GHyxNVSh/N5sBWoMUF4350A5myUicc
	rN8xWyU0lIOqniamhzlF8CrDjTcimhDEVNLq/uRa7QKdtpI+GqSkg3Jb5c+hNE/xOIFu8q
	YIsuRSvkLpRR16bgV9+xi2RDcuKk8tQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C74D95BE26;
	Tue,  9 Dec 2025 12:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765283332; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ygaHW8o5EWTBSXhXnK7ekdPvbFwd/VSzrB9zkhVTLRQ=;
	b=VJlXEdXFL5fd4Sem3MzdBi6M+Hr11U7VtVbf3ME1dk5aSuhjv3O/iSL8Yd/XI8EpEFKwGn
	qt5OE3BhUWleFUONVE7NBCIrv8ySHriCLSY0zQvS97diMAG7hRy1P55heddbwQqqP5orwx
	zke8vzmd4c6IaLFBZbk/OIH2tq5XjmE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765283332;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ygaHW8o5EWTBSXhXnK7ekdPvbFwd/VSzrB9zkhVTLRQ=;
	b=7U2McOFDYb7YMgNpJuCJtvWZaYZMflyH94JOMxO/WJFjXPjjRW/ONo04eFBGZ6oK+Zhnh3
	bJ4+1uZfHqHgl3Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765283332; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ygaHW8o5EWTBSXhXnK7ekdPvbFwd/VSzrB9zkhVTLRQ=;
	b=VJlXEdXFL5fd4Sem3MzdBi6M+Hr11U7VtVbf3ME1dk5aSuhjv3O/iSL8Yd/XI8EpEFKwGn
	qt5OE3BhUWleFUONVE7NBCIrv8ySHriCLSY0zQvS97diMAG7hRy1P55heddbwQqqP5orwx
	zke8vzmd4c6IaLFBZbk/OIH2tq5XjmE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765283332;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ygaHW8o5EWTBSXhXnK7ekdPvbFwd/VSzrB9zkhVTLRQ=;
	b=7U2McOFDYb7YMgNpJuCJtvWZaYZMflyH94JOMxO/WJFjXPjjRW/ONo04eFBGZ6oK+Zhnh3
	bJ4+1uZfHqHgl3Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B094C3EA63;
	Tue,  9 Dec 2025 12:28:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EYIZKwQWOGnwYgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 09 Dec 2025 12:28:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4850FA08E4; Tue,  9 Dec 2025 13:28:48 +0100 (CET)
Date: Tue, 9 Dec 2025 13:28:48 +0100
From: Jan Kara <jack@suse.cz>
To: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, 
	"Eric W. Biederman" <ebiederm@xmission.com>, Roberto Sassu <roberto.sassu@huaweicloud.com>, 
	Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>, 
	Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, 
	Christian Brauner <brauner@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, Serge Hallyn <serge@hallyn.com>, 
	James Morris <jamorris@linux.microsoft.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Suren Baghdasaryan <surenb@google.com>, Yafang Shao <laoar.shao@gmail.com>, Helge Deller <deller@gmx.de>, 
	Adrian Reber <areber@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Jens Axboe <axboe@kernel.dk>, Alexei Starovoitov <ast@kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	tiozhang <tiozhang@didiglobal.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Frederic Weisbecker <frederic@kernel.org>, YueHaibing <yuehaibing@huawei.com>, 
	Paul Moore <paul@paul-moore.com>, Aleksa Sarai <cyphar@cyphar.com>, 
	Stefan Roesch <shr@devkernel.io>, Chao Yu <chao@kernel.org>, xu xin <xu.xin16@zte.com.cn>, 
	Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@redhat.com>, 
	Dave Chinner <dchinner@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Elena Reshetova <elena.reshetova@intel.com>, David Windsor <dwindsor@gmail.com>, 
	Mateusz Guzik <mjguzik@gmail.com>, Ard Biesheuvel <ardb@kernel.org>, 
	"Joel Fernandes (Google)" <joel@joelfernandes.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Hans Liljestrand <ishkamiel@gmail.com>, Penglei Jiang <superman.xpt@gmail.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Adrian Ratiu <adrian.ratiu@collabora.com>, 
	Ingo Molnar <mingo@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, 
	Cyrill Gorcunov <gorcunov@gmail.com>, Eric Dumazet <edumazet@google.com>, zohar@linux.ibm.com, 
	linux-integrity@vger.kernel.org, Ryan Lee <ryan.lee@canonical.com>, 
	apparmor <apparmor@lists.ubuntu.com>
Subject: Re: Are setuid shell scripts safe? (Implied by
 security_bprm_creds_for_exec)
Message-ID: <722m42dxrfxao7y6ul5cb26orxoinsrozwqlf7ts52lpbfzgxs@gm6kakrzlhkz>
References: <87tsyozqdu.fsf@email.froward.int.ebiederm.org>
 <87wm3ky5n9.fsf@email.froward.int.ebiederm.org>
 <87h5uoxw06.fsf_-_@email.froward.int.ebiederm.org>
 <6dc556a0a93c18fffec71322bf97441c74b3134e.camel@huaweicloud.com>
 <87v7iqtcev.fsf_-_@email.froward.int.ebiederm.org>
 <dca0f01500f9d6705dccf3b3ef616468b1f53f57.camel@huaweicloud.com>
 <87ms42rq3t.fsf@email.froward.int.ebiederm.org>
 <GV2PPF74270EBEE90CDCD964F69E806EF58E4D9A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <20251204054915.GI1712166@ZenIV>
 <GV2PPF74270EBEE0AAAE2EB22B668EE21A7E4A6A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GV2PPF74270EBEE0AAAE2EB22B668EE21A7E4A6A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8451010000C
X-Stat-Signature: t3ntfri556twd3kbk7nku4k61apwkr7x
X-Rspam-User: 
X-HE-Tag: 1765283334-445205
X-HE-Meta: U2FsdGVkX19bzs6rbb0AJkhY//21Rktr1qrflrUJzAg3Nm5gI6BmdSbMHXbrrsa9pukn87Kx2evg/ZJewNc7n19lOPGXpj5KDfWi4Z4SVVhVhYMK0OxbxkcDMDnLSvBSp8CZZPNi4rp587G3p+r3/TtaqfbvVE+QdS3EddF0S3deiPBZWekVzoj7ykrLO/psnETAbKY3jHimxPvmumh8Ab9+tbKwM4DLO+9UVA8BXV3kFjn1nzW3wDphsHqER3vTMXCJwcBmWhpqADUpk3wnt5IyE7JNPYFlBM99HbONrs9ov4qi1cCSanPgMXeUAw6AyQuUwoHDRkFHjTeE0tMq+mUyGK6qTOX043NXOeVIRf2vbOiZU7qRB+VEaFrd5Wwug8f3g9Pe7HPGW0mAbmenSMWAs9lZRBlk8M71Y8HJQ38NfBtMGI0AYULXb/FyFIU8CNSb8HQKIUkFq6+SlMiz2D3D/xSfyXUMbXU4muIC/d2CBrOhp61g/qtg/N2eTRSnoumq4Et1h1zrfnQLLv1sUpnop2HA5t4/s0LSm6s2MTXzfGpYNMVjtk1GCOFxth3D9f8EZHpaMc13U+xFQA8wapbbfM6AFtUtmzwwV1My8guaJzVgAS17hPNekLDXgq1p9V6Uh3nNgcRiy07zZiF3wMCk5tkMW5xGJiwOzKOl4iip0QBwAeIaD+fnmGMDLUufS6Il2pUJLbMBlJBJKqkFtZyryyq2BPDWRBgKNeEmaDSIdINSBaYbz+uKebHzY6PytCT4cx4Au0oSCkzWKBT65SA1gKFOCHd8DBJY31/BKhyAt3SF6BMVRUMkah3HoUw4B4IJKIJRcDTfA4NOM2fiKecTdODNMZoo2RJXKh4fc70+/vXHI91z0mwu44b30Xe28DpqCCGzRmzY5i2DONINqeufN2o88sX1Nqh88yaDUoWB6R0SFC9e7sFG1RqH65h9HQdXffTgxAIEja22KK4
 QgxYyc2f
 eFwuObOqU/cMNy7PoBH3h/zTXAy1fu94+oPbYPFJbsppSaECdoqmlxOzSInL2Zoh3T6+1Frv1Rdq25i45Ur00R1uI2xyqEeR/qQe3RFeW4SSwzXxrGT2fayri1kNvgK8y/sqIDqPU15vBeWIP8ewRR8c3tE7CySBiP/LpU8d/EC14w+QfPT5/jh7eRBP+r4ZVDEvDL298J5oxxb1DzD/AXShoCSBavkoTfzKjZL1LbA4K6JPZZTmVJlUr0tPgfXeHxcz/tJgVTo4zQ+8ApwRbmbw29SIG40k88Zh4e1beM1dGKE084RgggSiV6mjEzctASCOJqukyCHkjw4aV0YOt141swd7Ql6Pucz3UiI93+bWnsM3ZY1IIAur9Cm+epAs8HImWvsb56SoJcZrYhspRBOKdaLieZDI1hVOI/cDFp18JUlKT++xgHYX/Mlj1TE69xOekDjuI+YnUk1ntnqSx/KYqJt43XQEkiWPelbd2nU/CCKfQyLJzsR9n5VgN9IQ2qWd5qfv/AsMUiPirHBUaleABY0a/88ZxiiES
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 04-12-25 14:03:27, Bernd Edlinger wrote:
> On 12/4/25 06:49, Al Viro wrote:
> > On Wed, Dec 03, 2025 at 02:16:29PM +0100, Bernd Edlinger wrote:
> > 
> >> Hmm, yes, that looks like an issue.
> >>
> >> I would have expected the security engine to look at bprm->filenanme
> >> especially in the case, when bprm->interp != bprm->filename,
> >> and check that it is not a sym-link with write-access for the
> >> current user and of course also that the bprm->file is not a regular file
> >> which is writable by the current user, if that is the case I would have expected
> >> the secuity engine to enforce non-new-privs on a SUID executable somehow.
> > 
> > Check that _what_ is not a symlink?  And while we are at it, what do write
> > permissions to any symlinks have to do with anything whatsoever?
> 
> When we execve a normal executable, we do open the binary file with
> deny_write_access so this might allow the security engine to inspaect the
> binary, before it is used.

That would be seriously flawed IMO because there are lot of cases where
code is executed without deny_write_access() - like shared libraries, code
loaded by interpreter, and probably more.

> However this behavior has changed recently,
> now it has some exceptions, where even this behavior is no longer
> guaranteed for binary executables, due to commit
> 0357ef03c94ef835bd44a0658b8edb672a9dbf51, but why?  I have no idea...

Because for hierarchical storage implementation you may need to fill in the
executable data from remote storage on demand and the deny_write_access
logic was making this impossible. We even tried to completely remove the
deny_write_access logic exactly because it has very limited use and
complicates things (commit 2a010c412853 ("fs: don't block i_writecount
during exec")) but that had to be reverted because some userspace depends
on the ETXTBUSY behavior.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

