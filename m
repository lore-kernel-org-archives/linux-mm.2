Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1D53C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFE566B0099; Tue, 15 Sep 2026 07:48:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAFEA6B009B; Tue, 15 Sep 2026 07:48:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA23B6B00B0; Tue, 15 Sep 2026 07:48:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A590A6B0099
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:48:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 509C7A3E23
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:48:07 +0000 (UTC)
X-FDA: 85215823014.01.F931A45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C6C27A0002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:48:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KEA46w/j";
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472885;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EYRIdKp/FfwNNqSNi/pBExuEJpqL4OpkJpzESq5stW8=;
	b=myGTUx4XaBR8Yu2J6JH7IJUBCaFV6rfupMukHUJCfgc3yus24g4gl8Eac+eYqquOqCtUPh
	Ektz04THmDkaEOJIPAOqdCFegPqQYbw2TqiadFxpx3YMP3wDutRnRNqhxkA+IAUYpClF8u
	/RznT6H785ENL072jbxdpr3pMWz6FkQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472885;
	b=riKGBBjmJ+l+2LdiqlrIvtJcf46f376HKek7Q3VA/Us3OE6pmwSTKFfiB7DEXUmTf60jwX
	eTj0S9b18GABipAE7xBfIod0KKuXtkXcVFVVHmujXiu+lr5Z++pKgYEsSk72mQm4AQU/R0
	E9av61fbOK5k+L+qGwijlRXZnppxCXQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KEA46w/j";
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 617DF6025F;
	Tue, 15 Sep 2026 11:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BC01F000FF;
	Tue, 15 Sep 2026 11:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472885;
	bh=EYRIdKp/FfwNNqSNi/pBExuEJpqL4OpkJpzESq5stW8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KEA46w/jL9NKEBXKdpDRVvgUVpdw6hOUBCW8wQyHI6NwDPC4Am8sCmr7j0WvoKK5v
	 Bi5VQmzbc0sNbBRMKVoi5XBwnkMmxH9tNMHqDw3ItnBUybU4feNnNWv7cT2bB8AjBd
	 dY6wMyYKrW4Ezf2ZF1yg1nT3JYwFHCkXSv5QxKi4ShZMZv5F2iT044OEtU+pEb+idW
	 Tog3ab9yFoO5+qKuA6KwBgJKAx/c448Pa5xlXvcd0f4KIxP8erzSA5JNQBA/bgLLZB
	 IGHhr6D+xE3ldAUlwnI0HynOJtRl8do+l5clEE47V/0XL01LM1u7vq8zJwzIFJqQrv
	 ilAIi+rTQ2iFQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 10/50] microblaze: commit fds on syscall exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, kexec@lists.infradead.org, sparclinux@vger.kernel.org, linux-sh@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, linux-snps-arc@lists.infradead.org, "Michael
 S. Tsirkin" <mst@redhat.com>, linux-openrisc@vger.kernel.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, "Eugenio
 Perez" <eperezma@redhat.com>, linux-arm-kernel@lists.infradead.org, "Jens
 Axboe" <axboe@kernel.dk>, "Jann Horn" <jannh@google.com>, "Ingo Molnar" <mingo@redhat.com>, "Jan
 Kara" <jack@suse.cz>, dri-devel@lists.freedesktop.org, linux-um@lists.infradead.org, virtualization@lists.linux.dev,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org, linux-gpio@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, linux-hyperv@vger.kernel.org, "Oleg Nesterov" <oleg@redhat.com>, linux-alpha@vger.kernel.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-parisc@vger.kernel.org, linux-mips@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-10-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-10-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:48:02 +0000
Message-Id: <20260915114803.44BC01F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C6C27A0002
X-Stat-Signature: y3rqmoeeegzh1xqpcphy7gsp7ciweu9y
X-Rspam-User: 
X-HE-Tag: 1789472885-760505
X-HE-Meta: U2FsdGVkX1/0A6cOu4Qe1iE9vBdUbBGzhplXz0KjEXKWydIpZB5icyVM0Fh1lrssH3wYBJ8t7WLDnmzVErrCL6NyS3QjJRROM3UqRDVAspVylqaat/JIWjcBzdszybOVqIXNdJ2IUbGf2jJU5IbvDzrz/QvAEy33wgh0DLYPNpeEOzetanFfg1iKjZaPEEHAjxOXev4gQyTjTwQSM2aAKy/WMZhkwe86vxzD/Q/RpE6BmZzhFP/+Tml/weNhXD5kADIpnC9c2nvjGzKhRoi4TUSBiar3Hayx5CbdmlyLdHqwGcbQsRKLse5MZb1UenI9A5csE+pnc5Lulvi1c4XLIJHV+V6/fqDV+xRcCCjJxX+AFgDORI1PrP7PoBg47gWy63H17eerMmfkd1YtN2H8rOPpmySrMSfJ0QzQVFPBNFcsdmo2pX3xDS92xJQqWlm5dGDMYI+6VYVdtPoh4lXvALLZTxaLkVmc/f7dV5M9hgCjG8JQZz0YUcaUN+fWX7BKiX+uemVwRbHjMWTEmkBb+7s0raU65UykDgLBZRZ5t7pP49ZlJNzTAsHpr+9yP1ULy3Lwu47bPukA4BEVrjiqwzcz4tBaDY9vny/sMOJuxaTwaPf4XdS+YVH66z0LCPdlZEC/D/lq134GwwHqDUUq1UKyCMQ98i9dC9K1DyIr8DAndIT9alzmAmxYHwkkaOXVZ8uvBnevNxBMZoPBkFEgCVLK+4zuS60blFkMOPjAsuAk1LgkOaryXwuMIlxtU2HjIIqoePK+6M6cYhrJRcSdjpQYm6ZwC2Ve/WZrx+omFtZFzbXkBzEhqlHQrGcqS1wOwPt+eXm1rgcwvRC5wMDulNWOAdJ7E8TSmrhzm7H3VmdSbA8x6S/GFjEaY20BvM9Aa5hDIfmAG4BNALFuNwF4MohAt1AHBag0PZqNk1meh1gyRWOxci9SF7G7RpdovKg1sThQmFFNFg9vWbL37Pq
 0dpK7c6m
 lBnO5ErcGZRfgySzRPubAGAdWon8r39pADoa2IH9OqUzvWpuzaZ0AuVc/xosjeORGa7E6LZ1TUmSyHziyv3DiNpRO3kINVc01y6pVzqM7xL0R32FtrIMA9+0LYMTRW+jSf9c6CsUP1/G8OHmRqmEptV5bAWtE1Y+lxkv1LtBQVC+YN9jqHWEHMpYwuVETQzqW7fL8RRpBXiynj9diR3N69lCUVwxYDUivY72/CSaA6CQ4gg5McCunSnCmAj2aowoDxWxLX6YbIJZ5hLekJHyfRoko5zhxvKPDO9bDso+kumDQu6zBrnHMVeVDL8gKigUtW7BCTZRAsiOQ2A7Ox2GvmZo6ESwpT0GB6a8xKiWnohKTE1D71urlDVyHE92yW5k+jYn/rzubt702w3tEwCS34vFx6zMFx1AKNPD4nxEypSngBDO1fyjU4xjikzMbhkxKZBZ/ioYvV9xB6R0ivLoAnjCJO/33YUWhPwFL4f+oZcR3ZNHoRTeVY9EvN7tl1H5kqY4vZ8HUiel1psh9GVVNeAevXzkINKr3bU+HJE0+kKEwOYOdLV/wnbWtqEmspxEKycK6TFDR2lBl6LJGDr0Fh3054xOaftX5vbG1eC9zlLpDbTj8qM7trd5B03UhsA5HpfqM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add TIF_FD_SLOTS to the syscall work mask. The return path rereads
> the flags after the system call and calls do_syscall_trace_leave()
> for any of them which commits the reservations before audit and the
> ptrace exit stop.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D10


