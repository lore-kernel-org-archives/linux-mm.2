Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A4DEC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82DF16B0088; Tue, 15 Sep 2026 07:45:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B7DC6B0098; Tue, 15 Sep 2026 07:45:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6800F6B00A3; Tue, 15 Sep 2026 07:45:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 436586B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:45:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 783B01A0397
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:45:58 +0000 (UTC)
X-FDA: 85215817596.30.1756915
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D944440009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:45:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OvyMOoJ/";
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472756;
	b=sdqXq9uWe4Ph+cQf3mqYyw1c41ZP6CR1qdcko3hGqwYi7alzW1xKhAuDEtsQL1IG5TjFtc
	VkJuP5Le5VAzsL1/isoreWvO4tcq9XB3XFuLHu88n6KiFSMIK81J3UHuKg8dgRY3hznegZ
	uxrmMHD2W/hWf2RHt6fN2mGc+BZ/6yY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OvyMOoJ/";
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472756;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84qdWoL1LKc5gtdlqTMvnJT+oufAgjOVJobzRLdUed0=;
	b=cyjxr2avkFO7SYQVk8693BDDWV980S1drlDgp1CSV9hy8UJ3qtH6Syz6O/a1EKyMRt1a56
	APVKTpfIMe6vkzyjZS5A4r/pM9pNOOnMtWG7i0hZGyafdKTFsVmUetLU4LNswrqUgnN2TL
	Heo9EGIb3safHaFbOS7JqU0ofk3vUWY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13D1743ADB;
	Tue, 15 Sep 2026 11:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6688D1F00893;
	Tue, 15 Sep 2026 11:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472756;
	bh=84qdWoL1LKc5gtdlqTMvnJT+oufAgjOVJobzRLdUed0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OvyMOoJ/eHXXAGCUuAHV9UPjednx+3v2kDsPpsRiMt2vJNRigBckYplzs+k1CunG2
	 VWZZat6CVLgoaSJTbzAssnUcFLqBHnWcBIQrLSfCF6yx/37jt+iOEtPkQuPGH8kPjd
	 AcdsSWp6kCGfJlkts3qZap21GHGOxCB9xpK4lKpyaxS4E3Gaqn2VwY0tbDq0dM8cvD
	 +S2ZTPvYUXYUWl8wkJIZFxNOYN02VLCEE6CbGr+QmxOcs6ih+Z8gfikh487gD4do1z
	 HtstDA3lVNKx0gLEevE1N9RvYOxqvCFfMI9vHNdE7EnXbFWmMIRc5NCWTLObCYGVL0
	 9PhkPHo1Z/4SA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 11/50] MIPS: commit fds on syscall exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: io-uring@vger.kernel.org, linux-gpio@vger.kernel.org, "Jens Axboe" <axboe@kernel.dk>, linuxppc-dev@lists.ozlabs.org, linux-arm-msm@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, linux-snps-arc@lists.infradead.org, "Michael
 S. Tsirkin" <mst@redhat.com>, linux-csky@vger.kernel.org, "Jan Kara" <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-um@lists.infradead.org, "Ingo
 Molnar" <mingo@redhat.com>, virtualization@lists.linux.dev, "Peter Zijlstra" <peterz@infradead.org>, linux-mips@vger.kernel.org, linux-hyperv@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, bpf@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, linux-openrisc@vger.kernel.org, sparclinux@vger.kernel.org, linux-hexagon@vger.kernel.org, linux-sh@vger.kernel.org, linux-parisc@vger.kernel.org, "Eugenio
 Perez" <eperezma@redhat.com>, linux-mm@kvack.org, "Jann Horn" <jannh@google.com>, linux-alpha@vger.kernel.org, linux-m68k@lists.linux-m68k.org, "Oleg
 Nesterov" <oleg@redhat.com>, kvm@vger.kernel.org, =?utf-8?b?Q2hyaXN0aWFu?=
 =?utf-8?b?IEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, kexec@lists.infradead.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-11-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-11-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:45:52 +0000
Message-Id: <20260915114553.6688D1F00893@smtp.kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D944440009
X-Rspam-User: 
X-Stat-Signature: 35efk1bjcmaubb3yj4fmhfqe5gksnj4c
X-HE-Tag: 1789472756-621926
X-HE-Meta: U2FsdGVkX18TOPVpXkPeNT5r+/SnEfNmRIKyhilV2UpQGM9FSNHg1T2XSwB2uGHVtmd2TfMUeQ6ICpmUQh7a43HHxCMQmxW98cXXoo3XUxcMnM2SMO6E4ugCPKGg2nE5LKYzQQw3RT+BuqSoQOgM13PgIbzF1IHhnQhHGyC0BOW2rsRjDci55RTrYG2tGGNynI3GVxq9ijsu8cLHlPWyUAZWykd8yYHXCOp7rxInkhZPnymiWQHJVP2jyB0MHurVvmBHTGdX1/703czaMvg4+/FEu91rjmVTtG2cOzKSmbteOXRvoONpw89FXkKpZJnbTqNaYH6Zkr+ZjQRcVQhcD1aB7SY0Olkc4Yyf2uicJNv6EQ2Ob9nJAKdhH4V1+Kvkqiujb6jVjz8KvjRaT7WMNue9UvH6bnsFwxTpr/e1WIfn+nmvWjoIyk/eqjzmAVXrnJ9+pYWdM4O9hbIA3CQDwJL4BnJ1KT382stUvpEi8ChZsER2i1n43vHhVWNCcEaZlR3E0tRIgLT39LMq6rYMDHv/vU+A+OxG5d/UGQMcIBfGAoYTcicxDK6oB1Z0lwZBm3EwcDRqDsZGKhbTeb6XRqwf+l+6Z5CCsHrLP9NNI5XaOUlgoApPXzG58pfdaDPBI3gX/pkNXiU30EEV+vhp+qi2mQCcbKdyCLWedW/1RTcWkrQ1lhsicNcRXnhOdO9Y7ahsdSkyKO3mkqURy1+JWsA8Uym7Qmhwm/5zwlQWOKwn+KIKdyeln4c1dH63icaxzpIoKUBeONRYG0z5zZi3jjk/QB6+18Csf0q1253EWOWIE98mwrEvH28g4jFAyTJjKwNQa94mYVsW6cTyQEpptH5anKI5V2XfQLKTkJlM0IkmSQEBqYBUIXLbes4CTC5tBXwJ9pSapNqcDknEIAvKB/iOo/331ZEQL4JkXljO+BTdkNkzVlvbRngfT+APHhgjDuKBzvb7BstHdFySLsg
 KtcvSMhR
 FHWRJ0mjZS01wt+mHSZSc8xlTgogw9gnbrU7TnAVM3yhBhDufcCGjclc7lMcmcKvKGiIXqk2GekKUWTq+3iCGHkRkvlHmuoZVg7NZSxkWyPMf2z1tPyyBi5vApb5nyYTZqb5Jml+UJrGn5FWf5XW5QC74Vq2Q7vNnrj5/mGnudu5UhwRUvEqCYDUheBRbGb1HflzckWKPf6OllkrCXyMpNmPQVIypcBvSOKN18X3z5JpYZeZpZQw1H22p58jU/2znnTiNLilg4NPL/8VVSr/QQCM4pCMXU0ivPF2mg7DWqDLsTSp1gfNcCy+x4p/1xZHDYItgCgfftxwNwYlLNL6KeGUrw6YT+COUoaK67ekt4ocd6TBENufwssRfwbz2ky+8b+tU61wqSjxI73KtbDtPCHPAPfKF9LK39gfXPqi4CrAi7eAAMBQkjcWJ1MCjf/CiI4I+iBq6gWTVaukhS+nUiiOz1XxTQRXBr8cIPpmsmCb/abHxB4Yr9ev4nragBBGO1Nq6NPY/ou6M6yT4g+opKYjbfUgdRKA7E3F5cCSDYp5VgnOGaRmERIeV1nZ6pBPdZLBWmlb6ze2Q5Z/FMGQ7tDYr6auAOkH4Z4hyvJRuXa2CYqlQV2v/b83XPDHJdcrM52Z7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add TIF_FD_SLOTS to the syscall exit work. The return path rereads
> the flags after the system call and calls syscall_trace_leave() for
> any of the exit work bits which commits the reservations before audit
> and the ptrace exit stop.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D11


