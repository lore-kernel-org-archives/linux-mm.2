Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCABBC982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D21AB6B00B9; Tue, 15 Sep 2026 07:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA576B00BA; Tue, 15 Sep 2026 07:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C38E96B00BB; Tue, 15 Sep 2026 07:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A415C6B00B9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:55:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E7BBA1203E6
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:55:05 +0000 (UTC)
X-FDA: 85215840570.07.5F88350
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 59DC1140003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:55:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZyJu22BU;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473304;
	b=ONZvJERHfXbWn5/lZ6z+gwYMyQaJYGQod6r67J4zN++3HxBTf0gPKIZbWugNCnqyvqWmhL
	HACap6Jfto8of18qyFTvm0LxFNsjQZTeUMFvX24GeyaSM4HCcFd1/a7tI4G5WzGBLpYkl7
	xnCNPFujaCDdI7lcmT0qUC9q0A0IcM0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZyJu22BU;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473304;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D7g9xDZ0omvORxToAZd7wz5+AlCcHiBcOzmxibNhlVA=;
	b=M7AKQP4tMbOrYcrtGIHHQNhpgYI6ltZrgD+CuU4PyIYd69J+uRgvM+W+7IkItWZBgILaxm
	2j76OMZ+5HrAbfazRK+hjMWLx6FjV+tguwtlwk0RULPhiGiDweD9RrRtJWrjtRgicoNriE
	hEu/d92z9J0DncOhXh/2uao57ErVOnc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A243943B4D;
	Tue, 15 Sep 2026 11:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D521F000FF;
	Tue, 15 Sep 2026 11:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473303;
	bh=D7g9xDZ0omvORxToAZd7wz5+AlCcHiBcOzmxibNhlVA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZyJu22BUp/krcHqRNTq7jKcZ/omh/8BK0J0GGcmbyy5eXF7HLUhGysm81swJVRcRo
	 fJATPHtnqwBnOk6PWVqaIPLWcfH7MWcD4yqz6G7e3EGCMvuO13BOVBnpv9ez1pkoHo
	 h5dypooXJxYBa1oPbCPR5mUV6AbHtDqPpwLdNjZnOwcsbqEhQDByZ9Y6IWPAHL+aCB
	 IGdiRVZ8zo4AG0M9gKDQBs0eP2aITK9r+bHOxAfCyl+sA6VP5e3n+m73i2wu6dE27u
	 SdD2cWl466lslpt4/j2EFsvQA0Pnw2GlUhysF9C6CVND6+HZdKJG2WejdsdT6gvwdV
	 rDjhEE9s7krJw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 15/50] sh: commit fds on syscall exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: linux-gpio@vger.kernel.org, "Eugenio Perez" <eperezma@redhat.com>, "Jan
 Kara" <jack@suse.cz>, "Ingo Molnar" <mingo@redhat.com>, linux-hexagon@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, "Jann
 Horn" <jannh@google.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, bpf@vger.kernel.org, linux-mips@vger.kernel.org, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-csky@vger.kernel.org, linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, io-uring@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, virtualization@lists.linux.dev, kexec@lists.infradead.org, linux-alpha@vger.kernel.org, linux-parisc@vger.kernel.org, linux-m68k@lists.linux-m68k.org, "Michael
 S. Tsirkin" <mst@redhat.com>, sparclinux@vger.kernel.org, linux-um@lists.infradead.org, linux-arm-msm@vger.kernel.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Oleg
 Nesterov" <oleg@redhat.com>, linux-snps-arc@lists.infradead.org, "Jens
 Axboe" <axboe@kernel.dk>, linux-hyperv@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-15-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-15-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:55:00 +0000
Message-Id: <20260915115500.C1D521F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 59DC1140003
X-Rspam-User: 
X-Stat-Signature: itjnm4fq4t65c7ouobdeyze8h8rba5he
X-HE-Tag: 1789473304-721947
X-HE-Meta: U2FsdGVkX18B4ffznzXVvTJ325B7hZOx0fK5fJLyn0Ck/aKq6SnRq4vUMhCxlspzTGEhmvbAYQdqAWl+Wqssa70nz1dsBrknCbNzeQT5hHO2jzlZQVYbtctb0WdmO1nMbXSezBZ3Zz1UjDCttEcA+LIc0jeBVv7EtraOkNctanBWR6B2zGVVF6io3sTN2X9aj8XfKSTMdimKmP2tpBVlaWmbDYh6wVhWaUXfWnj9B7v58RKRVolevmgXk1SXMmfH+rLG+243zjVrH2l4MgiM7dyeth48+ygIzhwLnpJ19o95XUXiA9fX2glcsI/a1QBb6G1ws6yf3Wg2Ew5wBNYJI3H3iSrxGLl9Ym7aKlOBfje50K1FlTO7CHVF9oGBS6dB5q/1NeaQRGaRUaSEw/Ya/IbgdZAA299uJ0ovEJPe7cEadLX/pOvW1Vu0fFSZDr8ICtEbwvAr1bEUFKnADDJPJl2ryRMU1+QOvD11kGvxDXYRCh+q9K9z6U4AWq98NSI6sOYsAT9ZMnWq2qkBUo28c1PAdFjMCb2OAcZfP5r+Vu+/zXXLgpKa8iRPYx/IhrKlUeeBM3WiiKayr2plU6e7OmlRDAHbrRttq2KiqFJcOQU24CzKI141RZE5EXYEigvG15xslY4ycO1dvlxoIDoKddcFyNiYZ3JJkK+XtGqhX7JfSRHGf/3HcFzvVuniFVPODvYcV6LH0sns3NOR/IsU5KvRJKr8Pi9rilOhL5/gg0vWOnrUR47+4TDmBeZvbutwodd6TMmxgeBeW2TFRJNuZqwZaFXT7x7c6VXavhfyQNPGYY3PjPsLveKMGs/hgpdWIyVBMaudzmCT9kzsQVViVxdCA+JplUbgvhbPPabHrycqype/+tsZ2YdUit474VWTwRv1VLqFctdSuZ8dLDShHZMFiOvJEeHYswJpiLsH5OV5sbUWCvU0x8rwVcNVvigzqHzgZDr3tnDb6zq4mpa
 rw3aEpRO
 9Doraf/MT74yd8GcXg4fOXsU7qDaphPzN18jXh2Gt47j2qOBjx/CRHeFbgtYN9Vhed+FODC39LTzA3k4Cya0ryFEq0wr+tlOkrKeiz/eOqWes8Lr61Qor7DKSabb/9m8jdYu3kpRM2pE5hx33unZNV7KFrgFlWuNZe/R3nTa7ZeD3YjHHvVgyPxoJ0HFTrUtMmKSOUdI0z5d6+VJtuhZAPbKmoURlZFOkBnZyJvx2lPeSl4WiHIt8JATErnXI//6V1G7m70GoSEJbJDKX/pROrmCA8kaqlLZDeKCCy8czGkyRQvf99iixWIhCQWFVYLw+OI0FxVLQ5RXIjKBQLCgpY4fbv8GeOzZjL+zTwBdzZmISKg8qmGgLAqChQQAFn19hL2p9yomLDu2cqEJ5x/BK2A1JWzK005QkmSn1MXh952XupGsZ3PfW/EvFoPHjHCKnPpzVz49vnvc0gxWEhApE87ep0Fv/Ux16nsWSJCudugf8bGCBlSMvnf9/aeeYr1D4Js9iypUQpkxWr0dQ9K41hifrwilW2A4g/DI6jsoz5W7SA1Py1aRe+9F9cOhbLTyjf3pj72o6/EV2fG7BuakMZrLDqWZB2/TsZ4tqYDq/UXvO4jAdVTLS8uO20tEJ63MymRYk1tauMtvREb5OUCAi1du5+qU+8zZhX6fhjUauhZjsxX4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add TIF_FD_SLOTS to the syscall work mask. syscall_exit rereads the
> flags after the system call and goes to syscall_exit_work for any bit
> in the all-work mask, but hands over a copy shifted right by eight
> when the bit was in the upper byte. Reload the flags there and test
> the full mask, so that the bit reaches do_syscall_trace_leave().
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D15


