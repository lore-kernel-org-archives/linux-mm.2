Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5876C982C4
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8E8A6B00AE; Tue, 15 Sep 2026 08:19:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66026B00AF; Tue, 15 Sep 2026 08:19:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97CD56B00B0; Tue, 15 Sep 2026 08:19:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7B26B00AE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:19:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BEF5E403DF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:19:46 +0000 (UTC)
X-FDA: 85215902772.27.FBBE7DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 25858C0003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:19:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m0z6lytA;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474785;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s+9PDH0CZ1Vr08YyoCof+UTThGpQ93yPbrI7mSCf5jg=;
	b=4MtCkbRSXHARIbVV+V7iABSeSPSSDbl4rBbM6w2rnzwGIYDARiG0tymfSLueDlbswFZb0G
	/XDnFxG2tsfKhBCoIyDYPXLLRaH99ozsxrFjhm7LY1hQfAjRAuKDVnl7a2k9j7hgbE2dE4
	6bQwpZLqINXKdRDkYA+kefzPl6tCQVI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m0z6lytA;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474785;
	b=huIcGCcskEBK7F2sescrHN89ZI21/ewdXaCGl0C84xdI8FK4fXWr6tinVwFjtXlsCj6me9
	/rlNd2CLrhlViPdXfJaUdM980mB3eMG+J7Xh5G7QEbnt4tBZIq7Tmojl0j/D6jWWN7TI9K
	kO6sE7EldGDFGCtafjMw7g5xzX2K+dE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5176C4069F;
	Tue, 15 Sep 2026 12:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B431F00893;
	Tue, 15 Sep 2026 12:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474784;
	bh=s+9PDH0CZ1Vr08YyoCof+UTThGpQ93yPbrI7mSCf5jg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m0z6lytA0Lb7PeCTJJ9wan77NmP+WaqiiLFqlwKeXKPuaHqeXDGZgjSEE5Nqy5ZTD
	 uXplubyhODu8Q/NNq14/kXJbT/9AFQwToWT9BIY9E7L4zCHdhq4qOYWiAgbLHBLAxF
	 XtT+b1kvKyB39r1HyAihRAZd/uoRrMfxf0YZCrLmFzS7pKcK/CRl1fiGl+0H5LKWhV
	 PlUaIzcMF+cm9TI4V6HSienMOrDlPf4JHELixv0sjOAXsqO+TJlLMDqNaOXk1sfBNv
	 cjEFW+zAMBlSevojGz84ZSkbXhlbmUkgsft9l8Pqsgamb08/hqshJfCjYTrtd+Gp+Z
	 XZIjfnkZC6SUg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 50/50] Drivers: hv: mshv: stop putting
 descriptors back on failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, linux-hexagon@vger.kernel.org, sparclinux@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, virtualization@lists.linux.dev, "Peter Zijlstra" <peterz@infradead.org>, kexec@lists.infradead.org, linux-hyperv@vger.kernel.org, kvm@vger.kernel.org, "Eugenio
 Perez" <eperezma@redhat.com>, linux-fsdevel@vger.kernel.org, linux-snps-arc@lists.infradead.org, linux-sh@vger.kernel.org, linux-mips@vger.kernel.org, linux-arm-msm@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, "Oleg Nesterov" <oleg@redhat.com>, linux-csky@vger.kernel.org, bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, "Ingo
 Molnar" <mingo@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, linux-m68k@lists.linux-m68k.org, "Jens
 Axboe" <axboe@kernel.dk>, dri-devel@lists.freedesktop.org, linux-gpio@vger.kernel.org, linux-openrisc@vger.kernel.org, linux-um@lists.infradead.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linux-mm@kvack.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-50-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-50-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:19:41 +0000
Message-Id: <20260915121942.11B431F00893@smtp.kernel.org>
X-Rspam-User: 
X-Stat-Signature: 47gfujragcjs14ctdgctdfd18a8gndtc
X-Rspamd-Queue-Id: 25858C0003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789474784-378226
X-HE-Meta: U2FsdGVkX19jmEtMybHUOFbo4z301D5A+c+yJJmqUfDRtlRi+kNPL+AqqfSMSeCvfw74liEWgyIaJu00iG0HaW8tL1QGD8O1EtOskdX0DCQ9f8Wf+NDz9L2HcBFS9x/G7+nizTXB07yUlTxkaNi04RiWtRxPd/gs66LB2qdo8CSbT2IwbhCNMmstWz8qRkp3WIC7YqCFvx26dZyRKhwel2HG0gct34DbvUJdRVBsWd7IoyYNTUqflJg6XTJZEd6s8hrKXB3EgYzCwuET6mE184QXupIxq4HbGq46T8AyyEaDvxRzahXBOQf5OkL0Xv3uqDzG2p2XPPrt96IFZOAVmWUgW7pd8y7+lO3O5rBkKc8JOAYvIBwoq/zhEDRr2chAEzgsdeFwAQwI1xTBTlnBAUNH+DADZ8jWCwLiGu5QsCbzofx1LLkAlsd4r49ohkZQuR8QV6b+tTtYQAT/uhvnABL3I+KGjDF4uOmNKMj7GFuF7MHzdNhLYljtZ7QQi4/fv/hcddKT8mKsik3NyWh4PK/YOJeidMNZbRywUyS1EC0qHDrbjwMrrjZu0wTrjJUPLQ93K0aR5Qr8l0/KwHLtIwUnXCywgQwe0PVfbCCrChg8HoOZm/OzzT1Rg4DtUSy+Wd5fznLZrQ3WKMWEOr0WkgOS715wo4hR3AHAtIM3Bwf2NRoo+XaDJKg/xCqWmQpAmh2+QH8kyRZef5dgIxBuf2Pb80VgStOyZ+wkvP9UDQ3HPFQjJXmDIqObODUDMRfIlI8ungSaQPgJpcNHrqIKmB92it6BFR0MDOMFIMxvlfa8SDe4HjL0a2WoBOS1YK5iWg9JpSSmPsAQ28H3RGRW2JyExWrf396ScBD/5pMrLGaBWgjuGeIdP/7q/wcZo38brIB686sPACYWh83vMoo+qdzQuZXIgaDXxaTAZCdRWMrreofjd9FGQYkCRMTypGbkLzahJPCGNtTlyi/ypn9
 KQpAIe9Q
 Zibx5gDLYYEn3a/ci+jwjddTDl13/BoOgth8oqbGTKJ63VaUm8ZR2rCJLFZ6FE5ur8WnNY0HY0yOE4RDibIv4Hmvuhdm43Glhb1TiX20dBumx4fGZznXj/Tz8wgq2llzdzbwsc2nB5rSZYvB7FcEYSdYpFXAm6G+kV0jryFFk96Y6tYBNmCpqqpiy8rQuvOGnN8QRWk74fMyVeshnrg2YUYDBR49vrPNSDnZ4AFQWjyC3gTeZk5K2KTuXbTyCD0yrFFxzl3rIOHMj1FtyjgWBxypDFrc3teQgUwFG5OgrYPPUmBsZ7CnE7bs87EHrIKjWXtVMHKhPd0uudnxmWAO52T5N2LtspzNjpla34ZCNYIpC54rvykuqyBslZX/2QDIPw9Hf1GSEmbDIlwVpkrMw/vk/NtWnoVh+lvrvUzB6mVU7iKFXbVYSwbMwBufTmCY6jWKQFOUqE2N/yPn3BZNnvTZjNOEA3JxUfz83P07qJJm6KZTdeh+cYLFuSfO4PmvF1WFbcAoJRWTmFOeCPh9plFS4QK/g0yW71zynXvMfv4WutfcsLXig3UPWNp70pPAa5dzKgdONKLJ51RqACBbdLlfFno7/GgkxyuJh390eCB88mtxFdIH63fh5JerjKjD+VbMPNaVjT6IdeHnFP+lFltRcTiUYJjTef1bI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Rely on the fd exit path machinery.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D50


