Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28851C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 15:36:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4431C6B0096; Tue, 29 Sep 2026 11:36:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F3DC6B0098; Tue, 29 Sep 2026 11:36:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E3266B0099; Tue, 29 Sep 2026 11:36:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0ADF36B0096
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:36:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 668088053D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:36:03 +0000 (UTC)
X-FDA: 85267200606.04.5D8E1EF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 380E14000D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:36:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sTGZSRl2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ie2AEQyS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gamWqDUt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/GQdw1NJ";
	spf=pass (imf11.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790696161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMrm96DArMa2on1T2OU8poCiT/Ajlmru9xAu5CV6dbY=;
	b=Nuil1bJy4avAzU9q45RZw6IXNbHsxeyjLXC1QRWs2/CSeKt1ObkEOEHwCI8btMJfueOLeg
	NtTih4hIAYjPRnz+mCHX7DTrl39Z5hx4gyr+ikjrK3y2Zc4xGvXsoVlLEh8kMC0dEET8Jr
	8cE9RDNj/NsxiFvKt0PKL/ZcmF5k+aQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790696161;
	b=LN8lfUoSmPqgPo/GMxG3sxBOeK4ZW3kdiZv/1DeCVqu1WUkx9o0KQdA37gYU0O4eervN+c
	5p5O+nsE6uptT1ar/2xficrm0ko0vlMqt1U+qmoAfE+eyi2KOP3t6WnlMfsApO5F+v7Lt2
	7niO4LxaH3O8lrUraa8ufRwdoSsyzrA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sTGZSRl2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ie2AEQyS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gamWqDUt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/GQdw1NJ";
	spf=pass (imf11.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D0C771F79C;
	Tue, 29 Sep 2026 15:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790696156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yMrm96DArMa2on1T2OU8poCiT/Ajlmru9xAu5CV6dbY=;
	b=sTGZSRl2gb/ZI0qsUPV3bN/ycC4DOfvy0k8jSRYRu3cJDqFnn4MGY45KEk8RogeTeiPdHa
	vUG0ZFjm2qoCr3arXbNQjJBU5OdETEhnTgwrFFv8W8eImBLyPjUvWmTsj0Snpba2OSetfS
	DCf6sEK6IK/dVrdrB9H/QNdXJVoOAcM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790696156;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yMrm96DArMa2on1T2OU8poCiT/Ajlmru9xAu5CV6dbY=;
	b=ie2AEQySndq9FaLcpcsC0PYLPt1l6WpyPcbdBBy6ica2ycsMHWP7daV1brC11IQSohKNlj
	rpUOyuMe3Gf/ZSCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790696151; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yMrm96DArMa2on1T2OU8poCiT/Ajlmru9xAu5CV6dbY=;
	b=gamWqDUtEANmJfk8jCSlqDWHELAoBaqUUJIOvWZRf9sxyxjNCDZfHorSql8Qs4cn8rB66v
	O0wOZpdI8SgwF9UUxlIsxTf9iDK8SGWZNBPSN0Bm/u9kPcNbyVPjtXnXlXYUkiJdCn1qFF
	PEDwWkmRpXJUUALVhl0Ugus0ZHAvrfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790696151;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yMrm96DArMa2on1T2OU8poCiT/Ajlmru9xAu5CV6dbY=;
	b=/GQdw1NJ6k1WzzehfohpLY+HtIMSmnqQG0xeAHCPbhqYk1is3nMa5jvQtPH4QQ2G+7HlG5
	5P9GjvlmBt2ykUAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D37C136E4;
	Tue, 29 Sep 2026 15:35:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id y8YsBdfau2rwKAAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 29 Sep 2026 15:35:51 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>, Amir Goldstein
 <amir73il@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Hugh Dickins
 <hughd@google.com>, Daniel Tang <danielzgtg.opensource@gmail.com>,
 linux-ext4@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
 linux-unionfs@vger.kernel.org, linux-mm@kvack.org, Chuck Lever
 <cel@kernel.org>
Subject: Re: [PATCH 4/4] ovl: Expose the filesystem encoding through sysfs
In-Reply-To: <20260929144043.5rg4zf7uth333qke@pali>
Organization: SUSE
References: <20260928213155.2612039-1-krisman@suse.de>
 <20260928213155.2612039-5-krisman@suse.de>
 <CAOQ4uxj7Vx-UGvgGGr9hPC0qUgJZ_WRAv1ZLi=gJ6r=ZJW0QAQ@mail.gmail.com>
 <20260929144043.5rg4zf7uth333qke@pali>
Date: Tue, 29 Sep 2026 11:35:49 -0400
Message-ID: <87jyo4xe7e.fsf@mailhost.krisman.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 380E14000D
X-Stat-Signature: rbn1bcbc7ysqosj9raxmi9emtt3ma1xb
X-Rspam-User: 
X-HE-Tag: 1790696161-810733
X-HE-Meta: U2FsdGVkX19S7/oegErVQKteU19N90S010HVcvR0QEiUf1zHIXfYZFmKPmMEd/3f3RArmiN7rRjD4tsvCAUROGYQiqHuqLVL4voP1iMW+MW/rKsb3xjKNSOI1OVBIJ9BT2o6xvjCpWYbgAy8z8a+h1JdqWHojR/g6YiIgAEOys6dKl5JzOUOlun/MxJVaz69PV8w8r12/b9paNYMEqUy9SfJ/bYttcrkRgwakY9RJAAEgGfPI/3yazGT0QadzsYoZIQ7ZkPT1GmKRoKVcaA0uVtdcvwgs0Bfk24D015pdruyYCpdC7a+GvYF66czRlhOxwf09PvAeQrK4u+zvyQho5lT7n7feABUMzUsiMm/o6/vFy8Mu41Qp3c2pX7/OjOIVUGkIFpNE4dXFneh33/sY2tzJpSJx0K15DKp9iforloVy1FiGFlZwDGtMz0swc+tFytyovra7RJU4jpVt5hHj3tqfmbs53qD4hFMu5Y8gtC1RDQqCNWcuMtyjO0kLdwWv2rwgdQITmiI62/1jCVyo6RVpFF2WmSq5E17nGwUfHkaexAO2UpCUwRmUheIYI44/TXz234sFZUfnRW4wIwrG6CFTh72nIWIMri1pA2PyE36y1DGnFxAr97ou/1q+WyHgkceEqb3jrEyTGVYOvwTz/LsrJ2h7oHkDEmXaGyQZtYP/k1my36LbTh4EPrgO2vzNOSQ8A/YEqbnLRdyq0F8oqUhx098FKf/l9iR4DuyFhIBUVzcbTVcp8uMPHKU0Pd8lXwiNbf6RX+WQfl7GdNNp3sxyWbjR2Nnw9VQ4VzaVGHMqF9N9+K2zZq0TX7+GRaQH1HhOv4zLjHkxWDQXRM398FfZuk4toHoTLVcAVav5uGpfn6uH14sAsyIUeHWKSUyv70CGegy8XhDS+Z6LhFWFKKygD6SK2EwkyWbQhEkc55dRsf3pjjKIbwLIRWQ8sSAOOTiwIAny477iyFbC4e
 4rMX3/jr
 igVkKcwyWqK6z0Kacp4oCUq6oEPTJzP1Ja89ubocFQuwD1gpH32tNP37swuWJ9l7AvJCI0ZhnWBRHsvsNIvYR+aNPlXdERWSJhrBje/Pc9TyU1sUbFtxyglRGo/Ho5mmqGxg7WGSPQ5kOFMxJXfcBzGOJBbk7LB7hV6pyTKuw2Qesp/96OW6SH7tBYcs8GssBiK8nSKUG7zL5NcSZDunIKcn326MrWawDWuo7Sd/vQNeObYKo1TX1Cp7b6dCMEzuCz8S7GLOH6QNAW8A0nbmFMsumVsYdFCPrkUb6/z+uh69wf6XdSjH7ItgjDPNfO60wjnnAfJlOZXNZU6Vl/W74rW+dtuXsV+YDrd3ZO8RS5Z+3sAIGvoE67C3GqVTl93BVU81A/PhjSaLcdvIbRmzhZFj936AAaNoFvPSKhzScu31731g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pali Roh=C3=A1r <pali@kernel.org> writes:

> On Tuesday 29 September 2026 16:15:04 Amir Goldstein wrote:
>> On Mon, Sep 28, 2026 at 11:32=E2=80=AFPM Gabriel Krisman Bertazi
>> <krisman@suse.de> wrote:
>> >
>> > This patch reproduces the same interface from ext4/f2fs to have feature
>> > parity, so users don't need to rely on parsing dmesg or trying +F on a
>> > temporary directory just to check for support.  Note there is no
>> > encoding_flags file, as none are supported by ovl.
>> >
>>=20
>> Gabriel,
>>=20
>> I am not ok with this API.
>> It is wrong in several ways.
>> It is not generic, we have already file_getattr() to get casefold status.
>> There was a suggestion by Pali [1] to get the supported xflags - statx s=
tyle,
>> which can be a way to say if a fs could return FS_XFLAG_CASEFOLD.
>
> Yea, sorry for that. I have not finished it, I did not have time. But I
> would like to address this as this is something was was asked more
> times...

please cc me when sending it.=20

--=20
Gabriel Krisman Bertazi

