Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A01CC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E9426B0098; Tue, 15 Sep 2026 08:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0FB6B009F; Tue, 15 Sep 2026 08:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE276B00A1; Tue, 15 Sep 2026 08:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DA816B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:14:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 136561203EF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:14:52 +0000 (UTC)
X-FDA: 85215890424.11.239A912
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6E52EA0009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:14:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pfnv0gbx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pfnv0gbx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474490;
	b=SkgLgB0Rmy0hlmcVBhOSG2/c4x1qsIKWZJPy2zA4cCizn+qIKd4xMi5VRfNEl4e5MY6kax
	rN0I5OOJ3kVBVtegnT1c4p9nf+Xq+ilJy4OShpNjWe8mA4HGslqM448lYGL3BLf4sEyXUH
	PcIZC6ntMjaQQ7nTdUKQNenKTVIK46U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474490;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TgpDOnocVQOLMc3/AlRq1UjktGK6C7Gyd90Kux4DYfA=;
	b=vJa5yYXXA7EOASZRrTQ4N5KeIA7LUfMZeNDre86PVk1qwGSlyl4P5fsDSEvQWu/w6K6pub
	q7N7NrsFAhRijezbLfqaZ4n3cUQoiMH4DWnRxrhAFBOuPniU182UmkLvGFoguk1EMmp9aO
	E9zi8jW7M93B4B7qF6lEuOH/ERysY3A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA279409F5;
	Tue, 15 Sep 2026 12:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FAA1F0089A;
	Tue, 15 Sep 2026 12:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474489;
	bh=TgpDOnocVQOLMc3/AlRq1UjktGK6C7Gyd90Kux4DYfA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Pfnv0gbxXYPBW5ngDM1BPQQHDBEH64eQbCNBA7As7XQllaOVs9srOJocJTcOpC3XT
	 +tBSuUVsDjYLtskj1H/KnGHu64fvB/LKvoto8b/1C9TdPBUb2FGeqlDDsZw5ByIwHO
	 MoEzV8EHl67XJeuYV9ENqBOJt0ffAddHj7kVNT421bYVifya9Ag8OwSLhtmCFhxFob
	 paeFeWYGLzS3PmbOQNjlBr1q4j6FJm9IcULTM3aAnjn6WlDhkszRFKzaVJthzwN/5c
	 3uEdtqnuazTttbQPlVN1FAd3DR097y8tCWsB+WVkEH5KLWo19PePTQx30oDVv1BsOi
	 I4VTuIqYdWUzg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 39/50] seccomp: stop putting the listener
 descriptor back on failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, dri-devel@lists.freedesktop.org, virtualization@lists.linux.dev, io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-hexagon@vger.kernel.org, linux-arm-msm@vger.kernel.org, kvm@vger.kernel.org, kexec@lists.infradead.org, linux-gpio@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, bpf@vger.kernel.org, linux-sh@vger.kernel.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linuxppc-dev@lists.ozlabs.org, "Oleg
 Nesterov" <oleg@redhat.com>, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, "Jan
 Kara" <jack@suse.cz>, "Peter Zijlstra" <peterz@infradead.org>, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org, "Jens
 Axboe" <axboe@kernel.dk>, "Jann Horn" <jannh@google.com>, linux-openrisc@vger.kernel.org, linux-um@lists.infradead.org, "Ingo
 Molnar" <mingo@redhat.com>, linux-parisc@vger.kernel.org, "David Airlie" <airlied@redhat.com>, linux-mm@kvack.org, "Eugenio
 Perez" <eperezma@redhat.com>, linux-hyperv@vger.kernel.org, linux-csky@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-39-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-39-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:14:47 +0000
Message-Id: <20260915121447.E1FAA1F0089A@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E52EA0009
X-Stat-Signature: opfsiz1ogs36atwqmdn5yiz35n7aotnn
X-Rspamd-Server: rspam01
X-HE-Tag: 1789474490-797568
X-HE-Meta: U2FsdGVkX180vOq3mVfBHEFElsqd9khcG3Tzz1ed95nqhyYb9Zta0pITYRkoUG3AtN82c53XIMV9K2y63NQ7hIeHOcjsnWGcDz6o0J4wubV3axR2TsqPDbGgBzLoIDZ+d93RymEetauMedN2tZq4GgTwEVT2uSyYLgfpFk1ClDRc9eoZr7Uw3USJx1mRVX/NyFAqEbFrGJdqDlGmRUhnrF0bl9/5hEwp6C92FT2mxCDOuDlWmzURZfKtqUrlGIJTxB5czFCnGMJhr9ahWeBKYvvAL+SRqZiXZHaYJO3FM97WO9jdATJOXRGGDczDVO0P3sK6JMpAX1oF05jsu3yNB22rcNPpQj/8M8ZGy3BjzUqyVwz3tdwkuf5A8NYTFlk3H+p+zqppg6UCcgqRX3pDysspuKR6dqRhbC/Y+gG/jqJDnsQRRb78cyxd/w4LnWAbC+XODw87JQQjmslqGTvdJsWO1KmEayQ3RfyAb4XLD64tquFbLltE+enaSdi+MQ38+0KVA+OoSr7lnZ6zLm4FQAI+Tc+O4SSxllp9VgJogSnyUrR7N5NAyVw27zi3p8uQacixtQQVxndakYD0unNnqsfW5tC86nzRDeLca63DQOzlvbatLto4WYQ1L7Bjm7bvrr3EZbt87qHsVu/jeXRT83WJLvWln8j6xMR5zVx21Dog+3B/XbF/KPXzU224eNq04/0xXU4lfzgFbillgHXfQ/r4bKaW8y1vVrzio8Kz6qDCEITyRwEDj0Tc9y7viX4chR4zcAufq8UdOBJun3MiRqCAlEGuzgZgJ/wugSucBedIKuWWlXAOh+Ey7GTKd3P8Z+i7dtK3n9G8o3MQrGkWz05VY11jPjc+dBptoxUjZDwzzbar7pdBb4sfzcoarMPDQT/g19Xcu83W+3dbekNBDcTOSlZDZ2OZ1vgy+iEeGbRRq11QtNFziERfNGw9XDnMygEnJC1PN4g1EB0hRy2
 laY+Sutd
 AQum3ysA3IM3l6jKifEL1MTkIK29hFZVf7VnhsX15jgARe0b/6vEus92BULUR/gpd3qqbSosRJbehxcZ8WFEoRUpIpV7ILw+x7hqMrOEQ1aGWbwz4vjPgmwhWfUtQ8IsGg9CMmYggNRnqCdKNpflXowVid2pTDydWHRXYOR5tSc6nBipQIuF4lRZKKwjrUdwJ6PUOBwHKEEysN4pYzQg1S0vwp3OFkA364w1l/VcYbT7wh2mp9BcxDn6zBti+MTDirT/8nWjjdhBLYIxndxQ3syLEHuzqhp9W44GkApoI2CuSBupGnbhjs7L/WuAvnvskNZUbbjpqeB0nUH/TceFhobK+jCDMbUx894jUwjGdqA9gn5nju6GqTdX/ISLs+GNA+hCN5364imRtZcivj4euX0lJrZbNdp6fNQ70bTXTcGxbHTPjXVz0jEjIgs4l9vzqPECcKRMGAwyByq+fD+8dP9z2HUPVTQCwnxso1lWxnRl7V9QwFYovjLJVRxwA5+l2SFywvLazm5AUsQQwdGtMWpyLC4Vv5g8JNlJTtZocI8gZAvtR1oWe0AF/U0QKTxpZYtxweNQSn0fvxhGk8qLZ8r3j7pyv0EjQJ5h7t/fg89NDmsAJzM1BclC6KBop1y5pscxQQdaj0HO8+Ip8gMH3R9UQ6wnXfw1DYmmEMfD7uodUeevAeInV5g+Ov53UaHR8iWEx
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
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D39


