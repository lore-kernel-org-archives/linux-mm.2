Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82DECC88E7B
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5C06B00BB; Tue, 15 Sep 2026 07:55:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 556EC6B00BC; Tue, 15 Sep 2026 07:55:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46DE26B00BD; Tue, 15 Sep 2026 07:55:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 224BD6B00BB
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:55:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 97AA5A03BC
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:55:10 +0000 (UTC)
X-FDA: 85215840780.13.1EA9409
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 07A88C000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:55:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PsQySeqW;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473309;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HMMRMhob7IkIe9e9mAPaP9M7mjfa9q2jKMemMrIPs6c=;
	b=jwlv+vUVAvoSrAuIbTN4o7JyIxC/4UvMMH0i0CgRcyP7tjxCQDBbuQxYhhcC4VEPPjvFpY
	JYcT9+SQne49THdwbXXxK8tClyoH4SYZRWZBzf0Fj/yx289vMIKl8PXJDtUk6vakr6Y+Tt
	IqMxT5wmpXcw2pj/XQyIw5XTAGXaYlo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473309;
	b=yjMqUNnYK7zeEsAsT1vOw3J2pdgcawpSpdTOPnD3niNQvliggeOIK4k0OJfOYA8HacmyMT
	flh5UBd3zNTz/okdSX/8PzcnO8BkPIikJaKqDgrFzmKuQOlcIwCI7NuqfVwB58oXE8i07n
	HMpxJnN9oYOR4c4KpA9iubzNqQTn0Po=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PsQySeqW;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5203943E12;
	Tue, 15 Sep 2026 11:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE761F000FF;
	Tue, 15 Sep 2026 11:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473308;
	bh=HMMRMhob7IkIe9e9mAPaP9M7mjfa9q2jKMemMrIPs6c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PsQySeqWE8JCmadPFY/hnc/12dyVnuAieOOYame4n2RSKPpHPzZEwa9aNXFW6Bh0w
	 jCKKPfvbQGd4w+kjCdDB1cDWPrLj1jH+ib+NTLKYU1wTD4r5SSCiyK6Bkhm0GPcOD/
	 n8VVrYov9a2DUD0P51p6sbyyDt7TrPEsZSbloBTRZV4lFnVfvS/4uwmg4s0o9mGPwE
	 J86aQbIHSTHc2gNUMi95Os/taOUoLSS+QNmmmSrckOC7X/ql9/XqZQkG5NLta2glDR
	 Mp2J42KjxHOY8m6wiQeHzVa1+u/idZU1hpvfr6kocKyTTL+rDtt1yEldFXNOgmmj2l
	 +dfiOWdDv0iJA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 17/50] um: commit fds on syscall exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: io-uring@vger.kernel.org, linux-mm@kvack.org, "Ingo Molnar" <mingo@redhat.com>, linux-hexagon@vger.kernel.org, virtualization@lists.linux.dev, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, linux-fsdevel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-snps-arc@lists.infradead.org, linux-m68k@lists.linux-m68k.org, "Jens
 Axboe" <axboe@kernel.dk>, linux-parisc@vger.kernel.org, linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org, linux-um@lists.infradead.org, linux-hyperv@vger.kernel.org, kexec@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, "Michael
 S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, "Eugenio Perez" <eperezma@redhat.com>,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, "Oleg
 Nesterov" <oleg@redhat.com>, linux-csky@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-alpha@vger.kernel.org, linux-sh@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, kvm@vger.kernel.org, bpf@vger.kernel.org, sparclinux@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, "David Airlie" <airlied@redhat.com>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-17-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-17-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:55:06 +0000
Message-Id: <20260915115506.6CE761F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 07A88C000D
X-Stat-Signature: uh4r5mbtat67f9xpsdos1qpnwgsmdo56
X-Rspam-User: 
X-HE-Tag: 1789473308-465231
X-HE-Meta: U2FsdGVkX186mvFfY5YqQ0A+UwkmlpuVmYSpS8T2YtgltNgNkongUpDzwf8gL1oZ1Bxl6TXs42FIzy9EDnpmfNf3UvwTgSFrXLZDSu0YL3rAkoK8VNSMTKDXKdownXYhnHtI1C9SF/XCjUdr+qmhtNf0+Gvy9UHNhgEBbpUSnpu/ezSIPlH9fgEfQhIqFqaRyAkuckhAnPJ/RoH4xsfifEfS8MXvM2Up961MYuyB08bgi9h8ditUPu40v0mzpvKYZVw6sGF+OAypLx/aTSDgiPRJj1qoQOL7QguS7D9M7tYKwldIZDqjR+54RMrUwG2grfo5knILPsFU42gwyxT090aXNU9Ky7Sv+BZrem0AsIaN8mBe5O7dSn+Mk02QuBST1cv/I+tnj5fjl5BrfMKku3h1JIIuehlqBz4eQgxP5e1E3yIPXC0g+o6O7ISDVOrLxb+xjKcTpGP9gvtxA22UclNMjHGsapust+vO5rS1FQPufVw6BY4DPuR2a++xmU7RNFGqcnG54VMBTKD+yX+cR4Zqtwi3mHiSozT2AVORrigcLXEKeQ+HgbaNrWAxUZ1y/q/wRgkBN/oSveJ7qjWuqQPVBoU94X+r32vKUb29fF7H+CPY3zZbILo48vytTJJSUdXKWFyJj7I22fnkVvJqSurxHK9kRR4Y2uZEWCqDdsq5hjzrg278hDFgz+9BUbYxwo3VLKv2liuc9DdLjnKxYDUpi64RBtthZ78D7eDKsqZjEUpuEISIS7zC3v7305DEk2fezf6bYTYS7pCoxwOW22iwll8ft0WgwZRT+6CZxR2m0yNhNpQ43rwozbhLdrKg6h5hasIr5WQUuvW23TxFEO8yLMHD4ocimLJKe5B7q0TPQtr5dhj+q1KhGQpb56GmBdEVfhYMgBtn937KSfWqrv0ctl2D9HoHFq6oKSp/YLoKTKLKDHI1H5f+0RmbVusk9UFsjFiVR3Lb8GFP5C5
 3lvQFAXe
 aF/J9+IxbnxM39ARF1SbMsmIaJKRMY4LH4Au09YiLZ9tfyXUgud9mnOWU+zRdVOAkdHHtTCcEjgGrTB3xQjhNFVRs72Aw0tfAz5XA700xeqvtokkFji2KxwlVG7tvnBkujz/qbiGo9AHO+huqutRNlmN71D9OFy0OjcS7TGlp1lXJ6NuvsQGDIOhOPe1g5egOpq8511H3L2n877Mb9jG8Qw3EZ6DhGAaW1r3D4daGP1HdMGda6f0hwRRyeuK3hlOZWrY5+2rusr+sLTfpP+RC8ulF9J9Xp3Z2ILVOzWYCeyaz4yK32d1XV1FeJVqMEAawjyitDu9NldkF9E/Na08cM7tH4j2CUoLGK2ooOVBHEXCWxGehpfjRuyvpAyBolWGxi5SU+0LMqw4QDSoewHOOA8V785u7t3DfdN6g+WyKo6eAwvik1Vlghj6VcIxxdBmDGQQXUVRQBZ//nGtqUuUKqn6SxBQwdH5hViC1CW61RTwtacm0WPA09m7pFC50irUBVkir3eiHZTdAjJbsEFuybauxes0qlRfCYF99Nz5zeps6FI3H/bNS6juHcZkr8kl7lWTenwlZCT65c7Ig/W16byTzvVE14UigfUXaLGFHJqkdC9VBdFyro0O71CdSKbzF/H9q2RpsYzT0xiJlQH8kyIf9ed7iSDRlMlSMtf+3Df6v6xU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add TIF_FD_SLOTS. handle_syscall() calls syscall_trace_leave() after
> every system call, so test the flag there and commit the reservations
> before audit and the ptrace exit stop.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D17


