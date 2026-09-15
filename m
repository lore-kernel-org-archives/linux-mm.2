Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0569CC982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:52:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21FE06B009B; Tue, 15 Sep 2026 07:52:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F90B6B009F; Tue, 15 Sep 2026 07:52:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135C76B00A0; Tue, 15 Sep 2026 07:52:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF9286B009B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:52:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5EFCD803CA
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:52:22 +0000 (UTC)
X-FDA: 85215833724.16.A580B1B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B7B27120009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:52:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gD24zazr;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473140;
	b=QCVSgS2hzUM1bwk6kg7fAu2nM8ZM6BzDmP1F/hwP+wY94Wsl0jT4Ss1rTOCB0pl4nvgtBY
	y/jbDG+gFGygCiFgbg+u3r5qOmX+4g1sdFjeY5NB2TiupnHGSUfAh5zXg1fo0aLLiXRisd
	ctm5PtSYtqDckkid5rEGnOkcbNuxA+w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gD24zazr;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473140;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ekDoF5aUkaIqLM1AvgKs+prcUXxdZryD2GdHfQi8iAA=;
	b=b0+onz4NilqiyxztRtxnRg651BvCzacTFdtpuPrK+NURc0+CrTmiwyCl+6inqwal8z8xD4
	6du9X/PdvsceRB2Iu4gM/YLmeGtLUJsDL/GW57Btx0l8yK+0V0kiVktI3kUMVbUeK/epUq
	Q57kYHEikx2ac1zOFLJR0AfFcrK17A8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DCC2140C2B;
	Tue, 15 Sep 2026 11:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F289F1F000FF;
	Tue, 15 Sep 2026 11:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473139;
	bh=ekDoF5aUkaIqLM1AvgKs+prcUXxdZryD2GdHfQi8iAA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gD24zazrk8TigMiCd5ASn+dm6txgjVpHa5zvxMTtUFRuPgLF3PTUXkAm0k3tzbTVQ
	 kW4KsfY0HBGQif9CYx1pshd5pTSxWeoqAtmTVWdPBVqC5Vn35qXuEvnFfVWf0GTUKh
	 RUU6SoJAkl5L0Kq8QF9Rmz6Bec1Ua+EO9EvYsJxPA1pHKVceE0vbNalGCUnepaasCe
	 DK9cR0VwmXUnDDchOmLvDyG+u5nXi3gO659qnVPIeiexcntK9tyLliM401L/8g63N3
	 plW5ukJMt7+DcxaIYWdMgQ+GjvsoPq80PE5u4Yrt6L+3cW6+83I52c5iJrh0Haefuc
	 0OjHhKSvx0zPw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 02/50] entry: commit fds on syscall exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org, linux-hexagon@vger.kernel.org, linux-csky@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, virtualization@lists.linux.dev,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Michael
 S. Tsirkin" <mst@redhat.com>, linux-hyperv@vger.kernel.org, "Oleg Nesterov" <oleg@redhat.com>, "Eugenio
 Perez" <eperezma@redhat.com>, linux-mm@kvack.org, linux-gpio@vger.kernel.org, linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, linux-m68k@lists.linux-m68k.org, kexec@lists.infradead.org, "Jan
 Kara" <jack@suse.cz>, io-uring@vger.kernel.org, sparclinux@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, kvm@vger.kernel.org, linux-alpha@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-snps-arc@lists.infradead.org, "Jens
 Axboe" <axboe@kernel.dk>, "Ingo Molnar" <mingo@redhat.com>, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-2-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-2-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:52:17 +0000
Message-Id: <20260915115217.F289F1F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B7B27120009
X-Rspam-User: 
X-Stat-Signature: xhe7wf48zbauea9hq3gc6oqwa4ncfwni
X-HE-Tag: 1789473140-972651
X-HE-Meta: U2FsdGVkX19RlOomcXUv3NI6eWp+D6F7ACmZA2ConqwV7z1iNPDuqNl0Gh/BGD+T28T9oTmtXE3G6S3EDGlnTeYCijLvawTplCy9QnT0pIRFrZVRSEwvGnLHJHO6xTznONvwIRgu5YWSfHayFOXtk3JSk8DaTG/eTuC3Po66XRwmVJT3gqe6R+VEbG+d4y9oqiMeG1qSM057dvNhb/LmEs8/ZECQ5hDUMgCb4BoZU9pcHIuRQfaDZjQZrwH84yIol52a07i8DK2RlfhEb2wXEqsMx3s3mdAEWLF/LLYuqBbdbiwe32+32asGUJ+j7eRWQgrbiPlc74murxBBSwXORQ1sVNANrVkls53lGrcc2psJC1z2KME90HtVZDjQFxtcs9F0K3BtNTQhYXQwbgWTz2EuLcqUlSamob5RLU0WJr5rxOIR8x9HteG/9KSkOVaDmEqk+cTOAB9nEo+RCxxWpM4x8dHdJ/dhiC2mm5iTKezbVToiXHUB+vcs2tgGXY41A3qCm0aqCnQLwXtg9OmGNmUwH53lyZq1iSTZT2qJO5209JD8of7IgrxgRa3GAjVcUFGgPkQnyUUtu2Tg6zh94TgrCvNxsXB/VXlxZheYLlU+27RK5UniX42kYVQS9SYn6Vh28hhLe01snpb2mOCXwDCDn7xSVeDibjQtLwHew3R6I4L1dBmXJEd11HWaMsHs+EEsH2N4qKKNgOUblUmdcp1+CdNuEXI46rrdPZ7CYKvewxBiup2smffoR4hO72M7hmcMxfD+1FJvA8S3KbScsGHjjbNMzNNGlXxXzFv/pOuqQY+/y+dq96ZU2xelai/glKKIjgb3GOXgfZFPgfdsqpeXVeBgLv3k5nIIOjRJhkYsM7vmaCxfWLiRuKsC+LD1Fy1N+e5PHQx0VMQxTKUUb7kqHM0ZypofTfThzhkH5gQK8XTSIZtZP5ujmO3LQGUEDYMGbPw2JPTQl+CjBoO
 J8fhXpYK
 dA0uYEoOfLQxRL40Kw2O+YDKLzS5jhvU5MjDJvy+07NtjVsRdUKnN6Hm/1NqRs8uOWjrxFZGtQEP5h9tBrSwrVJYPB6gi8HmyaY3dlI2kSZizB21A6muBx2Goz2qlwXUtjGT6KT3TAIo1gy+x6qjCXeFFMkNPQyzRRWEZUY2u97VHK51jIanhAyNSyUtYdu3Nhh15YjsK4FlF/YoCQOE7ry7btG3cMvcSzlXU3uCJVohMZUBfspcU3glw97K3dsYRABTgCE5+PLt45fDGIebvDqBcyCdkyybgY0lWAiNVCpZdc5SW0QFj5MXPGEamL9zjq3hrrbe1DgzkG5CtnHni9MMPd4z6Corz+ogj2nqLcToSYkMXputBUCWPMxxNg2IdVOKVoF02vIgNmRP3kwPNkc3qdQd+Uhz1tiXFPzD70++2lURk4u4DBcWI2VZXDxiofTGgNf8omxgIP+u9IkLhdjAhNB2j3YAI7DRP8W3LUXcUPAhLMKDm+XAnGeEC+lm3qOjpS2P+0JGmUhBH1TCN8MCQ7tQR8Us5lfGG58zljLv9qoMQRkgLAyoVKtOqGMQl2gabh1OCrIsTgy1qG0ofD+Z8CFwaDawhIcpUDWDvd+co6APIGKCsrxvvAMKp+c7w2QPfqs7KzAYnL6xe6f01DMdrKhM/Z9zoNw6H7VPQIB3ePVI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Reserving a descriptor with fd_prepare() marks the task with
> SYSCALL_WORK_FD_SLOTS. The syscall exit path already tests the
> syscall work bits so a syscall that deferred nothing pays nothing new
> and one that did takes the slow path. syscall_exit_work() commits the
> reservations before audit and ptrace.
>=20
> Architectures without the generic entry code grow TIF_FD_SLOTS bit in
> their syscall exit work in the following patches.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D2


