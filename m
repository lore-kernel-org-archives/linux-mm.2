Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7589CC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F6956B00B7; Tue, 15 Sep 2026 07:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A7426B00B8; Tue, 15 Sep 2026 07:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797D86B00B9; Tue, 15 Sep 2026 07:48:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 512E36B00B7
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:48:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4BC71203F0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:48:26 +0000 (UTC)
X-FDA: 85215823812.26.AE42675
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5856E160006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:48:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=or6y3CyS;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472905;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=snQOL0WONF4IRsaF3EIs3wlmLSFM44jqM+liurayMLQ=;
	b=4eFA2WT6a53sZJfpkoUeblSysRzRzDQrYWKAKdxxx0PlmnK6Sw1P1KOOmI5KqfrhJr9mlE
	LEVX/N8VKSlR9Iz+hNJOpHDn1qUO7w/V7ZIlQw3jZDl6eo6huhSSRyt0vSoycKYE7PXs9X
	d4kJZSFX0Ts+uzjz4JRieCE7AIegqyQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=or6y3CyS;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472905;
	b=AueGg3+JbOHRB5nvkeMgZMpQvzrrHfsHJ9g8WLOJXaOvEVsGzJ8dfOkOR3kzRXqqsdl8Rs
	3mGbeJJscX2B8iRG0fj/vSM3Pt9K5ABw0bxM80Aj9EtuUEhDoXWC6wykrIPbcwQOo2NNNs
	dSOYRrpAAWzlep5YftR2V9LzuzaPrjc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EF34F6025F;
	Tue, 15 Sep 2026 11:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB181F000FF;
	Tue, 15 Sep 2026 11:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472904;
	bh=snQOL0WONF4IRsaF3EIs3wlmLSFM44jqM+liurayMLQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=or6y3CySlL1bdxzm9++3Y5GlWLcEPN0LrDGjXv4IhxYT8SwPi7kInte+CrlQcFfkp
	 1XQmoKBf113PXHQChs2avy8UGIIquFVuSvMCoCSNMtA9/3wH0G1HosQnaeUEIWka2B
	 wWhLR1WkDA4HzYixhD6H1F5tbulUxFG0FnA5+hj8l5IA14GNeQQ0O/Dk84ZVAgSj+v
	 HbNF4/Hpt5pQyZeE6+47+X/P7J02CVGZbdLDaKVKYgjpAgC0Jr6q5hx+PjdmH8SQ8K
	 ZwTjgJT8b9Hr2cJYcHzxNGopiariE1M/El0VM6I8g6qSqO3peUD5vDy8v1Fyu9cVcC
	 cthdt2i/NUkkg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 04/50] ARC: commit fds on syscall exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-hexagon@vger.kernel.org, linux-snps-arc@lists.infradead.org, linux-arm-msm@vger.kernel.org, "Michael
 S. Tsirkin" <mst@redhat.com>, "Jann Horn" <jannh@google.com>, "Oleg
 Nesterov" <oleg@redhat.com>, sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, virtualization@lists.linux.dev, "Peter
 Zijlstra" <peterz@infradead.org>, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linux-openrisc@vger.kernel.org, kvm@vger.kernel.org, linux-csky@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, linux-gpio@vger.kernel.org, bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-um@lists.infradead.org, "Jan
 Kara" <jack@suse.cz>, linux-alpha@vger.kernel.org, "Eugenio Perez" <eperezma@redhat.com>,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, dri-devel@lists.freedesktop.org, "David
 Airlie" <airlied@redhat.com>, linuxppc-dev@lists.ozlabs.org, kexec@lists.infradead.org, io-uring@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Ingo Molnar" <mingo@redhat.com>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-4-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-4-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:48:22 +0000
Message-Id: <20260915114822.DCB181F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5856E160006
X-Stat-Signature: 89iyib63rn5tm6xpw7sgafbumsqrujz8
X-Rspam-User: 
X-HE-Tag: 1789472905-900370
X-HE-Meta: U2FsdGVkX1/U4A3OCvVVqYkX6uN5N0kK8hoDW7A3ArCg+qQKVaUAjCM2cEAL/uMkUF8s8r7dEQXJYpsaV10kBxzOYfvyw7xQrch9kZNX90oIlmxub+4LnLErqMQJtCKNOCJcTeuHr4XMObJlUFiC3QLrM4mSYR3oWzDDpZFOz2ZEINsDhZiW9y1M2qgR3Q48x4j583dmpE3be9h5JBX0jbnbdvC4SoJPmbby6LvRWiqJhmJHDMgD9p3abIKCtXd3wSvh8rEMcR714eB/sTtNT4XxtJbyqsQ8w/Je2an+wCjlH3nStVbEEEHfAKSfm8WZ13wRMJnDQGwxq2WWUg4fJi/POvkC7Px9eSC1DIOEIQmfvTpRNqNldQPWE11AB2+8R3sKOb7iQoOSavL8N+KOeGCj+frosyQ9zgqLlc0PUEI3Q7Dp32CJPjUMB34n2OQZE16FqWSb4fCR6lZ+YpPmsKt95ezEmAkqEGem3V+hnBLe97J1Dkbo44AfwfBD6G1KENMNjJDqltmWHT1Wfw9A/4cJIvHX+JIMb7IH3qF1RdW2CQvIt6nwL7u9up8rR3V03kPC9c+bxnv4oYBpWf8Io/93lwP4b70hhHmv/HTgLzBA3xvQhtPCjfG1ajAVKg1Kuja/jLBhCEsviwilF17vLEzoCjIwiss0rokKVuhsTp7GKxOCODZPe3GRJ42EGhhlNazl3H1iCDY3xBgmW5GIcPVP5MFX4UO9foZTw3r0h4qkS5SwdEqpZmoytnwSm1rAcXD27iQNW7ZhDR6cLS2ukC5LC4XCKo5v1O8qJp6xeOpaqliduFIWIcMtkH5Ql8rDDoyPO2zFTYRvN2BWWZuK+RDWimC5sUfSkHAVhJyphF3YYk4SSdGkO6flhkoHwn9dMuiwqdMe5/PQIIeDVEFgDBVwRNkxEhVJxQzgKD+6UQptzLqhfY8zOKO7h3r92XAw2Ma8ex2kunzpiPVErlb
 erE3Rzbk
 f2p5kOOlbFDAZOhYf7+6mwbHHfMYWJTfwJ7UTj0o85Z9oJMbm21Kd8hPwc0dsg3Y6PU4VOzfSrU0ieSfZZQL971rJsp/rn97C6EtxvNAHcNQXpULHqcdO8haehxCv208R1l2Ikv7L1Pgy57NP4GxaA4a0jfy4Y+TqUrksJNByF3ALiY7Ptjk9fwZy5cOxTd7t2j8aG3cGyOJR73Ky6I/Rpjmo+yPH90Au4NSR+2d0FK1WrPjps+F9wt4prYOyuIFq1hTBBq7r+KxKNWteD7v2RNl3YhdgsEjuaU3Wj288kiDpU2IFJ5IfwhkKiRv3jYn1HREPGPatLxmLXY8H9xs18zy1VF3Bt+6H49IOWrtTarC3YC7MvTifkZ+4/PfeyIyjgZ2waWSoxONft/5NWFX7WppIyGPilQcjKhyD7UxoAPGximQYg4m4loMAo/Cp3ukzfNwqvoYhBkPPAgQfFMcaLEn280WkS3Ftpu6A6oodnQ8RAasA5BhGctUOCJQxNfyjAGruPGmRSXzqT3oh7TduLLzsfdQoLEvHfykUx2MeHWhGIUi765vBWKfyDllJ/NEF9305iLiPSkdSdjWVpw56t4tp8ALMoBGWkPl2guUTVd8lUbxcVuoEIysnA2VZjRgplq1P7iCYqVv4ZRqsnMFLB1G1IELikcyRLtx7fxXd4cYXDM0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add TIF_FD_SLOTS and test it on the untraced return from a system
> call. A task that reserved descriptors takes the tracesys_exit path,
> where syscall_trace_exit() commits them before the ptrace exit stop.
> The traced path already ends up there.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D4


