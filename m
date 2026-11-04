Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC807606D833
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hKMrkOmt
Received: by kanga.kvack.org (Postfix)
	id EC0166B05BB; Wed,  4 Nov 2026 04:27:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49EF6B05BD; Wed,  4 Nov 2026 04:27:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D11446B05BE; Wed,  4 Nov 2026 04:27:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A6C216B05BB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:27:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4245E160670
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:27:23 +0000 (UTC)
X-FDA: 85396908366.20.B8408C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8FC8710000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:27:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hKMrkOmt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793784441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pha1RY94GjOtnqXrQOQE3qKs4iPAcIL8wQlgIsnD1VI=;
	b=RWahRaFM8f68X3UCdGB5VS7+Xvc0Yk9xPF7/VVxESh5tmjGSUjZJAcQpLvQlay9Dl/s2Yo
	1QEs29u+3GqSDCnvu1EyM4tesOG8IRiUdeh2os6ay02i7srwun7YavP42/WTxAHBZnYE07
	cpW57RmTBYC6kGZEaVyAEg2dkFh2hRU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hKMrkOmt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793784441;
	b=M2wTeanHe2y1fZ2xRUr/n4Zw0Z6rTfYLSFo+3ysqw88ueUsiRKjvjQBsmK3Uz6ySidy3Es
	VuD9khQsO+f9arEvs4iUi9bzdqAw18jt3zXOWDhH1QUFNm+12xITWp8Cb8XJN3UFH1uGni
	ocbvqIezLLd+0cKfZ1DjRQsTRtIB8UI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD9FC43E30;
	Wed,  4 Nov 2026 09:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48201F000C1;
	Wed,  4 Nov 2026 09:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793784440;
	bh=pha1RY94GjOtnqXrQOQE3qKs4iPAcIL8wQlgIsnD1VI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hKMrkOmtm3B2gZiQeO5JvnZ9p2ma/4Ab4QoV2RY1r26cux4zCCLh9wEH2c33BbHXK
	 fbNgj5kWSSvaYoEB4LaR958tQgbKkBQGFEq4mxLA85jgB1KOgLoszMSGVrY9Ha931r
	 D0hMpbsmsCVo3Bmo207nmKQT+W9saDNTG/2QCtQUHOWdxFm2doY6iFV0wGD7GNxdFv
	 FmgbHDeh91BIDzv96YPjHlswJc8awRukjfsVnSPjYTrsCRqLuc7lscOjkrPunvesMJ
	 Tjwc/nSfJXhQ01Nzv2q6cSJ99acGT39x8EGT/eIVENZ4EHlmNUtg6FDEG8FGp/Kj5W
	 DRZXkXKQhuqlg==
Date: Wed, 4 Nov 2026 10:27:08 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, 
	linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-modules@vger.kernel.org, Chuck Lever <cel@kernel.org>, tytso@mit.edu, 
	dmitry.torokhov@gmail.com, Petr Pavlu <petr.pavlu@suse.com>, 
	Anna Schumaker <anna@kernel.org>, yukuai@fygo.io, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH RFC 13/16] proc: let procfs copy out reads that don't go
 through seq_file
Message-ID: <20261104-weswegen-magen-gezaubert-373ca765d28c@brauner>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-13-75df35e4f8b8@kernel.org>
 <sashiko-outbox-195540@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-195540@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8FC8710000B
X-Stat-Signature: 1c78sed3bww3nabzwoy49q7z5xd1btun
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793784441-734783
X-HE-Meta: U2FsdGVkX1969em1PX5lsv1EG0D/kQ8kV2FOrmulU6KSOl9xY3sYPQmVLLdjimRvpJdCOL/QqdSX9QWaIJoQryPHsiib9Ndz76uYrYdZgGaGjlu3+CQK68ZE2QWScaypnT3lgPY109DdLPEH6GxhwGSK2d7B5c/ahc3hI5i+DaOYOfnCjnhzOoF6KgQnp5b0Dy80k4Ui7Iv8WDSHXf+ivrVkgvqggw3H6z6p7x26KczkxHOxLqj2L+d/vzmtr/uI8XsU/aWR/uHwpBYrzOOhy+rP1dKv3MX3YcZPFf1fDpub7Enhucfq3PkmQhif5Hp5cuS+GGhYQYJpQf0X5fFnpIMnFY136pPqXXb+tcAwTuJMl6D5ufoxZAW6Rhg2nOcuBvKb42wqegvmFySMAGogpISsjzaoRpMUKNu5qe48M43eei//Mmb4QX7Nf3GluCp262Lr8f0cnZ1pls9O7QpseyIxqunnvGEYfqUaemh6Qe0hMyRobcMIgQ0lSEdKjJ+B9a7FB8yJERb1HlLqHsmNerc7ILOcflPwYHXO3BVpbIQzlAlIROt/WJXba99g3HayOC994LmO71Z2lqtQA4VkCxA0aI8CYJVafb3cRuwpDff2f8FOF623zqztv7o/pTR7FZsFnNWpEqs3zllUTKa7fEVDYBwItFxsdDjEq3gyMrr2X1I3yaz5ge3G3oyh/fslKZP+EXWaAJsJrs90przlqMH4rYLf2PIktvaEKE75Tiwylr/2iMpcY4dhMjxtD53iiC+42fWq29GlI7mn5QKNKHcbRc5Z2bc0IXvwUnRizdTlx/q/LcdD91yXEye4b9oBWyIlbkthgvu6+MuVD9FxxvarfxCKHrNWycA3h6QD5Jt5cmWbOTwjt9i2VvNFj/L5EMkF50ci1buCF58wQGUmq1kKawUlpHxXP42O0Vz6IRk58G2B4DUWqWqSYiFfyOiUcCJeH333Nz+t2MtBZn6
 aHp7oOVm
 XNADF1j4AE/kXiLimSt9DCvOYq1nkVzhua0mLp5F0KO9Ky3PubvPuDqGpHpDpVUfolMJPpbmrfk2dUEr/peo9LEpzCf8/kA34RmRbc8ulPnGY2X6TCj59pHnZn/VoSurNvBjabJINllpEHpFnXoushsW8Y4zmtF1mrdAU1tz6C6UXFSLDkHQKYIeUjLcTUULSk4ZqS5eNio7YsLvslxmymflVjPF36cTlVfWsNCV0IURMjMLQufUGprzR3eRWyBXMU3rxud9pr4oSSpiB3saP2Tfp+pMUBgfSVaWUDLsge6T2b3R/g71JwmetgPOc1siuPk6uAIY5IdkYkYg6+qiuGrsKj1Q70fzvxO44mMsEDtgfMZnG2t2BxUoouCG0/Ulsqz8aAe1PzryZMWMfnWP3wu/XUbxM/RWObWZs/IYg20TsKNqRZRaB7B4R4ujCoTrZCiKn+hThkeTQx24dtQ1DScuHRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 03:01:30PM +0000, sashiko-bot@kernel.org wrote:
> - [Low] proc: define and initialize __free(kvfree) variable buf in one statement in pde_read_buf()

Intentional.

