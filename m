Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85B28C982C4
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 986EC6B00AA; Tue, 15 Sep 2026 08:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95EF76B00AB; Tue, 15 Sep 2026 08:03:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89CF06B00AC; Tue, 15 Sep 2026 08:03:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 692226B00AA
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:03:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0845B1403ED
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:03:20 +0000 (UTC)
X-FDA: 85215861360.01.185CF9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6199AA0011
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:03:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=THnhYqif;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473798;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+u7ApoOuOF8zgpGLaZZqOsYtXtnXCzj3vZ61f6s8LvY=;
	b=dK98GFoCa6z80p/ImRCfKP92hS12uA9dKL0Wf13jzeSiQyUUuUx/NpVomatoYC8/BLbcqG
	bouyOjCkljqZlMlx6T0Qh4XGGCf7k+clb02vOudEUAdPyjybZxAGc/QzyGJRGCLEc06z7i
	/7YJgna4Sx5Nc8wtqfQ4+dbokvE7M1Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473798;
	b=miMlDUPTexHHyHZRSdCrGu2XP/L1oAe46yuCN8sjwnT3jnQoYwZn9xYAJHsprESh6qsWoR
	gEV83Dg92Hza8lyg2mW2fIMGNMYNWTwN5ePNyNpmkrLwIrPWvkePk8uZY1EaITEs5kav3u
	2ovzj8IaxxBreZHL4tX8XdbkbGD6N34=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=THnhYqif;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 84F70409F3;
	Tue, 15 Sep 2026 12:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53111F000FF;
	Tue, 15 Sep 2026 12:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473797;
	bh=+u7ApoOuOF8zgpGLaZZqOsYtXtnXCzj3vZ61f6s8LvY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=THnhYqifnsYIWurKEUAhE5a21iMJPlZD91gXsYeEKbrZccsHcRXVqGfm5oAHxQqOd
	 e1wuKKqVeBYXyc2aFoavHWSkhBnSVerlDl5LdiePK1NOkSeaQW/idnPwhZZFr9qO2U
	 cg7uUETVS3OG1gBkYBAm+yUoWRGRSH3/1l1cbZ2tR32pl+WFSqQtvnmtWPmcEO4Q+L
	 BxuqA3mh6TGj2Aku0WcupA4zXl8/Qqfs3dDrK1fqU5kv2LzDSbBcXV0J8UBqa9cxEY
	 w/xfA2bcbpba0mU4z3odT8FBDfF8Id5jJPBmzjOTZnLPQ12i2X8SrT2BDKLxXvMAyA
	 ptXGYIc0ZxCJw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 22/50] net: install SCM_RIGHTS descriptors when
 recvmsg() returns
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-hyperv@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, "Jan Kara" <jack@suse.cz>, linux-arm-msm@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, linux-alpha@vger.kernel.org, linux-hexagon@vger.kernel.org, linux-parisc@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, linux-openrisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org, linux-um@lists.infradead.org, io-uring@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, "Peter Zijlstra" <peterz@infradead.org>, "Ingo
 Molnar" <mingo@redhat.com>, linux-fsdevel@vger.kernel.org, virtualization@lists.linux.dev, "Oleg
 Nesterov" <oleg@redhat.com>, linux-csky@vger.kernel.org, linux-mips@vger.kernel.org, kexec@lists.infradead.org, "Michael
 S. Tsirkin" <mst@redhat.com>, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linux-snps-arc@lists.infradead.org, "Eugenio
 Perez" <eperezma@redhat.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-22-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-22-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:03:14 +0000
Message-Id: <20260915120314.E53111F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ojzkdxhjde8k8hatwku8i8mmhxbxsmrz
X-Rspamd-Queue-Id: 6199AA0011
X-HE-Tag: 1789473798-302301
X-HE-Meta: U2FsdGVkX18GAczmKfyy/nXkXtuthPYmgJAgIdqHfsWLRMAtIjTZVnMoT7EfHCab1E6ikW73DEQDeQ5ThFBVzEXLg5BDJki8sNgLIsn5SFIhq3E52ELSGoX9/Ze4fmxWmwWcJ30w+UILvkcr2O66v7SnLEU21V+2hv00cVCuWQWteUtHw/POjOKl1DFqsxJrcc5JLu8ZEpn2iTwJ1dpV6gOYpcj9LZ1GBCK3cLwEpgyKOQBVRW66OvqHIRcgUJf2Els0mzLeNrWaZJ/cDtrDUaJfEl7EozcUW9yfq2ePVAZM08eQU6crzBfI/zA+x/DGanwUwmhF33YxoZdAluvJ63AUb0a3+TLoPKyN8Xir6qjpeOzkwTjOS2XMEbBIv/XCzIXiV09DvsxEjC08Vm4UV9cOlvACnEL8+0NRqZMSJFZSOl7N7XXPQ4MyIPAjK9Hl4JL1qgLxnWeqmi7sNyiEziNVMscOLY/BXmmVgVOX2i5VXi2Pdl+ogFQX/Ere5/aG3iIU175dw9RMrpDjlXHLk4eLfZRgL71IatCZutRffFERVPk2jSYr4INVxCqdhXFQiJHtqLwAN870amjjmkA0jDCHpNb/mfFrUWROxWzNYxIc8Fn85hKnKcVE4Z0WnReZPD36jEsK3YPoqUtqrB4hFGBC/WI2GnnmnQpGKoXSid6+4FXEnXElqJzlhrH/2+VrrzSr9sqHIMyezdtNqbgPI0n6UZ94aafV/TCbl7PxWMjrcy1ohPgrumgdPEMaiIRJQlBg+yiYjFRB87paM0sxk6DZIaqRov2P8oxq4iio5thNA2L//wzUoLpnPQef7mF8km5foxuO+tboSbZGOpeWhnxBHJTlravzAvC0oPSslKbyI3g4RnkVZsk8Vq+WyylOzHREbW9Fagh2ZWtDaVzBrrik+xNC6RRJ9uEYeZUzIU/Lr6mhs28RtktmwAHI+8DfsTdym5WVOBah+8igITM
 Kpb4Z8D5
 QqgyNCy8IYQ4fpxRv5BZmiqa7VzkbYqAs6V5ujTrud355A0cWIk8WrO2hvoITa/Nu+zs6aXm+3dnPq9NsKIoKEh+k0kV0jKuqwuy9vAKkmTDsXSvThR/aLD4Hxb1amlrIFWiZ2KdRx3ANK1uybgq3qvxS1bY97SjMfv+8pl4pD4eb0lSfH2EEju4Z3Njobt0WGmxwcPLoP031FREMuRewBjftSBb62Qy25rR2LKnweo6la5ww3xgTgCjQyLvXQCvtfkUbn4Zwhxy4Z1ORR5yUc+KL1ACSYULfw9cqgJaebynf0F5xVoDqwXLJrw4kL6zht9mhz5a/DSBIj43DFi0zGkuTrJrRoyY2S/tXlpHaBtCPQh3ayv6yf+gmIwHsFpXx29hDNLHrCziM1NdUSaAra0qNEEQ7rEmbuawNTuQTUn6QWIafeCQD97DykOLVyBa7g1Qa0Z9dmLHnvjpmISVWvAoJW1k5DNVs6q59L78+MiunSCIXiNI0c0ICtxMdwGsipkIVsPntGaHcfQ0Oy6LT4GTN0MRIoRDWTR7xm/OQFl6LnaWYUnJFvzoJVnhQXA/mnu/o204ngB5K/dK4dQXouYA/NjPYsfvzKrmm3BEnmPR/Sch7CvEXgrETNjceoFfeda9EqhVJjcy8D3Jq1MSdpM2e4I+UZFvK7Sx8aNoqi2HxvfkOmj/8U2fqYM0/W+t+9Dl7OQOz7xkl9ITpfYkMIhPMeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> scm_recv_one_fd() allocates a descriptor, writes the number into the
> control message and installs the file right there, one descriptor at a
> time. Everything that recvmsg() does after scm_detach_fds() can still
> fail though. When it does the syscall returns -EFAULT while the received
> descriptors are already in the table and the caller has no way to tell.
>=20
> Reserve the descriptor with fd_prepare() and stage the file with
> fd_stage(). The number is written to userspace as before, but the file
> is only installed when recvmsg() returns success and dropped together
> with the descriptor when it returns an error.
>=20
> A control message that doesn't fit still gets only the descriptors it
> can report and MSG_CTRUNC.
>=20
> IORING_OP_RECVMSG reaches the same code from io-wq workers and the
> SQPOLL thread. io_uring requests commit their reservations before the
> completion is posted.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D22


