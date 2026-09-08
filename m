Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED58FC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3C26B00B3; Tue,  8 Sep 2026 05:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84706B00B4; Tue,  8 Sep 2026 05:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC1EE6B00B5; Tue,  8 Sep 2026 05:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDA076B00B3
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:25:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63ACA140464
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:25:56 +0000 (UTC)
X-FDA: 85190063112.08.BF36F61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id BFAE8100006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:25:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DGEIzbQZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788859554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EIjb+8qA0AOLbrUigbrFdsr7Bi7xUORUq9H//Gsw4uU=;
	b=F21z1yClFovXDP0zi14g1GFFhHAZTtUzPVZJASf0zkJv7frlXKowoFwbEpf6XUiJbe0S2P
	116cL4FVRzKR1yZxg4HLNswmb2g6oiODtr/JNBz/7BLvWBh7oyRnUEdkDM8wrJOFM8jwGn
	aVb5rTFIQ8uHXM2+RW5d+9mTvYoMjrA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DGEIzbQZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788859554;
	b=d5JATbdGOZgcbqoUqN4u86CmK0d2P+hqpKpOOKDMcapsAii3EA2IKgbhgTS/b/xQVoOmB+
	Dm7QdHfCJijxuJEspk7tg1GPwSBIODRriYXy89rtidrmWtAVmAHflY2d5+PGUZOhk6dvFX
	1kVu0i23SnVSM0djhpH2Zntwe6+gwyE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F18D740A2A;
	Tue,  8 Sep 2026 09:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CB61F00A3A;
	Tue,  8 Sep 2026 09:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788859553;
	bh=EIjb+8qA0AOLbrUigbrFdsr7Bi7xUORUq9H//Gsw4uU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DGEIzbQZ+aPgK3MYWRjjK08/6SvQLu58K4JBVmBFiUqScBXqCi9GHoevigvsyfB4G
	 JfeNxKWVQC74+SAmTkV0A4a30ebmw9xXXEVjlPlrfZtrIaLcaWn1Wnju9BRCzK40Mf
	 fz+JDUGCYWIYbMUrF/UzDzffKEyhJlf88rXs8VrZ5CYwfmvsE0EWh6iAdAxz7ROSlY
	 R8PJMSwbBp2YNMUcfcb0sRazaYGegWmfnscXC87EW8FwSvET56XtCyekmPPjpPsMcX
	 uAPrdHc/BekDrHKWcYJZ4Uuhaaq26PsvcKtsbQ05xlS1L6FEYSWowg2ccuw3C7U1jq
	 2DIWv0rHrjLFw==
Date: Tue, 8 Sep 2026 10:25:49 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: syzbot <syzbot+c6879dc677a017f0a21b@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, jannh@google.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] WARNING in vma_add_pgoff
Message-ID: <ap_Uke89Q9LWoaoK@gremlin>
References: <20260907192517.564ea15aa8c9d47669b3a81f@linux-foundation.org>
 <6a9f8bc6.f614420e.2bf292.0005.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a9f8bc6.f614420e.2bf292.0005.GAE@google.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: f9y49pxcgjthk5ibwdprddmuycs7d4xf
X-Rspamd-Queue-Id: BFAE8100006
X-HE-Tag: 1788859554-519502
X-HE-Meta: U2FsdGVkX18zJnfeJphQQ3V5fj1s8lIovwFILyuO0p5RMg4EmB/V8FnEOcYFay4i+n4NuZ8DbuanMWAdVWTjJrygjPAEuibgDDGj7QI1UmNxVBs1iGyeu2LsOMQkkArEOBImst6Lyo475qp1nVkzB8NVDuB0v9TI3i9GgtbywFko0aEgopER0Vgu5DC/TZU2Ynm24OuEAwq4aAMmL7Miflq74ASduJ/3ypSL4bQ/LWRYnpOUOPG1h4Vv1MU3S7DoRUkBjjeUgw0UTLDT+GMCiSQmhfCiYIMfwI4rCZ0w+J9y3wnkh8vE8QqN2mOr7WRvDioke3F25ynJSsmvxXiADIzcspfaqPOSZ+jpu6kdYNyRP621k4HjJFsGGkqfIrGqVOm5f8bneZsWBfsgL4CW51mTt/x2N8yh68CBNj2C5Vq4eSZ/l1I2GP5qPUMVrs8iTMobk2X0HXR43FE0Wwd7WY36GwxJN5ogCC+aguLpW5Sx7TBqoqLjlbl4DDsj+qePKfUjDrSXahb3Zu9zQzxYAAWxxu5ktj9eaUqt2qpYRY6QAQ+GWzwBwXEUpS8R7XC+5K1CHv3TvdD/K67KDvVLPxSt8Hx+raVC3vgS9suktAAwGhgYMDy0Gss4s029ygIueN5I1A+N9LCeAV9bNtv0AD69m+TdITQbX2j6K1c8f6hsBvGf26+6RZrtS5EJvvHEiLg17NRYaJdQEpwBW3lHj16g1FDIxYReSsV0OisY9i9JnWHvfHkTyBRT1RAWolyj4jQJMsjt30YzizNpANEY0t7WXWbUZvbPItQ5cJB2ytdzdMRgv3nkBoBgOLPNcQrEmqaFshyZsyMf3YSWkbXa40b6Ux30s7krF4wzIm4yv+Od0uAxRRyoPAobUeo1LV93Mi8r3WXWJBl8JYHk3d+hpDcCk0BuX5NxIlh+244Ie5sfBPbsciVo2As0aWJvDLp46wKhwKIfFcucIvnRkfd
 XCKyxdjy
 JMATENyGDd8KDIUTWU28U3bUeDC+UZdemMG1ujxp/3G8e5VoEvRMHg4177H4+HEuU6eCZRnfme4gbcvo+wUy2JrIcnpqkOyljuJHp74dM4n1LRo50MpFVQ8uHxqTYXtY4qdFmFB5frU1FusNhwVT7YwGeJVk6f16/61M8SS6cv7qjnoJnTp0F/6To9cXJ/GVuKhR7J+Gu5BtYVOB4t9WHKwiRWiz9/MA6NLQJQJKaYdtgYXZquGzjVv4ew1lq+m3PWUL4Sdn+T+uQZnqE+ehfLk1Bq8HBapVz/VgKFXw/SLFtajCGgfpuzkY/97c/Ir/AsGorDmEu6A95smf+Sb9wN+GVzIVyEq6pir0/rgFwbcLSfPdLAgTU3s3eRaodJ08eLJSB6or8xkVkoy8ivn3mJNRgrIacNn11c3FWiI/NOSGocue6HByAZQd/5N0y3P6iNQTsidbBqXQ8Mjf6SqKclhbtdcBQYoUe4jU3K0QDUwU8DW7wAB/LXO9z0FL2+tXFd6BfChqr7dh8mdvl/Pm0PRebz4iC34I3y1WyuNczshaoASy3wiz6Cs3xeJpupMUT9fyoD4x8Zna4MBCEAvcLvDQ5HBc8RldeLs/gChWchjCI3atCcOSmCQGdrDbl50ZFAh4il40rmCo4lbq9XvCdLGQVyLYv5VjFzmEvcHF4LfNt4tX1a+m8UJTmP0435rO35o8WAqDyR3HOX4Cr3LlfiIY6dYl02myt/BFq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 09:15:02PM -0700, syzbot wrote:
> Hello,
>
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
>
> Reported-by: syzbot+c6879dc677a017f0a21b@syzkaller.appspotmail.com
> Tested-by: syzbot+c6879dc677a017f0a21b@syzkaller.appspotmail.com

Yup there we are :)

Why is this constantly duplicating I wonder...

>
> Tested on:
>
> commit:         35b0fb39 mm/mremap: reset unfaulted VMA page offset fo..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> console output: https://syzkaller.appspot.com/x/log.txt?x=15e13af9580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=56ed23170c168d4c
> dashboard link: https://syzkaller.appspot.com/bug?extid=c6879dc677a017f0a21b
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> userspace arch: arm64
>
> Note: no patches were applied.
> Note: testing is done by a robot and is best-effort only.

--
Cheers, Lorenzo

