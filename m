Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B372C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 772576B0092; Tue, 15 Sep 2026 08:11:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FBA26B0095; Tue, 15 Sep 2026 08:11:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611146B009E; Tue, 15 Sep 2026 08:11:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E8CB6B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:11:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF90E1603BE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:11:27 +0000 (UTC)
X-FDA: 85215881814.22.32C7A71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 475EC10000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:11:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RmyX0EJ1;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474286;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sOVPYbcZwP0qO0v/wyl6IpYJ7aj9qJBJUvOIh/HcLZU=;
	b=Mj4AU5oJ0ya1b/VDoPDL+K0WFodkI6R1xhd4xZkkeY45gSrHqdnYOqOMsyS4kLpCcxnXlw
	lFSyDMzoolOWesBl4h0txXwKlc95sAPES6tWwKzOlUaaJ9PURKD1V0FSmUuij1RwDIAxLT
	p63eTtIoF42S8vO8LkNWQCJOaCV9cc8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474286;
	b=Mpr6VnFdmIOJq2yBquPF34L0TFEem4WmO/pxotGUgghl3G7D0cHrh9ciheWdtMHop5/0x5
	aFG+tAlP/nfTPykXMiRrduKE4dxb8kaRpGLo4/k2JwyIzS8uGQEBWbvwWEu5RJDF7DbVvm
	m/v6GMMjje8yTwyDhGvgx+ZB0GbuFdU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RmyX0EJ1;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC954602A8;
	Tue, 15 Sep 2026 12:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D341F00893;
	Tue, 15 Sep 2026 12:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474285;
	bh=sOVPYbcZwP0qO0v/wyl6IpYJ7aj9qJBJUvOIh/HcLZU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RmyX0EJ1B0zOgT5ioEXRLk+o4F4Y5EudQ2MyBappoNbd4lClHN+PysLRe+lqvPVp5
	 tBwJMbqCeZEv7naOUmB5POnQKn+dbX0K1SIPTGnovxWaK3d1hrbCQzt+QTOIjSS0jv
	 ozOLD3b4lQSvA/CU30dXodluwPZzgV+Ca6K7iJVN6Vk+KD4JQXyjNYe7jK3mYcGLUH
	 4XnCIyui6X4vRwCLNy4FaV+3AmDMv+qiX7nSh5emNDsXdPMr643qZCL0VouKa3ayzv
	 pThUPgyUG/CP/C8WVCikSGDKsjSd8zkAPHVNK+58jF+szrJfKJpZ9+ygivmoI9WEAz
	 pHHOzSGPpXmoQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 29/50] drm/virtio: install the out-fence
 descriptor when the ioctl returns
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: kvm@vger.kernel.org, "Jan Kara" <jack@suse.cz>, linux-csky@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, dri-devel@lists.freedesktop.org, "Jann
 Horn" <jannh@google.com>, linux-parisc@vger.kernel.org, linux-snps-arc@lists.infradead.org, "Ingo
 Molnar" <mingo@redhat.com>, linux-mips@vger.kernel.org, linux-alpha@vger.kernel.org, linux-um@lists.infradead.org, linux-arm-msm@vger.kernel.org, virtualization@lists.linux.dev, io-uring@vger.kernel.org, "Michael
 S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, "Jens Axboe" <axboe@kernel.dk>, linuxppc-dev@lists.ozlabs.org, linux-hyperv@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>, linux-hexagon@vger.kernel.org, linux-sh@vger.kernel.org, linux-openrisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, sparclinux@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, "Eugenio
 Perez" <eperezma@redhat.com>, kexec@lists.infradead.org, linux-gpio@vger.kernel.org, linux-m68k@lists.linux-m68k.org, "Oleg
 Nesterov" <oleg@redhat.com>, =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRh?=
 =?utf-8?b?YmxlKQ==?= <brauner@kernel.org>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-29-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-29-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:11:23 +0000
Message-Id: <20260915121123.B5D341F00893@smtp.kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: xfze8i6mgjyfdusnsqmuqrkjznh4k94z
X-Rspamd-Queue-Id: 475EC10000B
X-HE-Tag: 1789474286-483025
X-HE-Meta: U2FsdGVkX19sNbQWbGX86TIV/tbhWyJfj9aLwQ0+NnBGjomRbNpiy8BqZObU3CwiXJRi49SXnK3OEpcdRekbL1jVGtQK2hPIVGgq2hQJ/3H2ULLLllUmbfXfM/ldvPVYRa/7ngahrZdAB6Q7Jx4yy3kU2w7EM8jrhU4AKcHVkZ54hKDTzrQcwj3BSRXpbb1JPRUKF2fPthywdK/w7UBCJ/bkpxLeA/TmoC1e5jdlEiBl6LCNSWk5wVQ7+CoIzvgos1WN8vp4F7mutqpPGUzJg0nE6SDBObzbfk5HoqvyqkGtIVJGq9JLF/Nt8LDeBR2jQj65vNsX61iAQRY9u+KrsKoWam43VcvicHQCuN3Ge4UhR5f65xO8Y4R0jgcBFOYxUMQ8eatGocSjNxVCsiNq75g4Nv847qrctXmYHBe/+KEGCj4N0n2apL7tuiwk8+Y08k/J+MS7P4euJuosWUpFxdgTgruCpK1PMzo9P3gMAnjMUUbaakK+eIcKchXlnCp7EzB5KOg1A1Rq198bOejwe+UxjCVVBoUGiFSN35U5hpzLkhk2AnrKXfgYIGIbzkEUx1aL9o75O+/UNg2DQqd6KCllQJ40T9k/k/ePYbOINrIYr7ogZBRSmzmHyGfDNLgjCMdMJSQaAANcBSve2yaNoDduQWO5dlDed3jDv8hQ0Q5Ciq+sV0N3fGF0cb5v8dLU9QImQgYlergk2WaDw/7cSe+GTdxHSgOBeb9g8cgVlOda9UX7LDReNaYfuSJVjowZstONc0Ai27eUUBrOsa1pBuQhWt0qgn5beUEIaUkoFmLIAIsoHtU8pjuj1hhxAPNAo2W78P/whUKUnFD+PUSfrEiLbVGFzt3PK1UwHA2HACYFGSovgIib7bB97aIcROG99bkIC58K79PQ6v8THCzdyV1x/VnyR7oBcl9QNnuHJdZRUNfwwbgUZGJGTHKUlGREdmA/AWoTxTPx3J7XC6o
 rPb0IW1B
 Zb1wVsz0VKm1RHty12idog5wnIfUmEoRas0FshJb4Hl3tOORiZZn+Gh7ssw2YVi5s2nAy0Flxce+f0bCiPwYGTDYkntcxVFNPcylbGelpkQCFjlpeYaquBfE6O2XbkzAKB9PzacQaaXR4SHWWrcMmycUw3mtXpvbixH6MB/n9fBvAZ1RlZamfFd+LbocnJGy4SfrBqYVoWBnBpJnw8NNQU9KDQOJY9qauYdmsE8cO/TRkS2Ud3sGfS1Kr8M0QDsFWT0mQ28jDhb2ZBvVN+gVik/byX+H1zjcEfYjPr9O8tzSeTwblazmcQ+waJSuSJ93w1XKBFeOxRKgztrJlE8VhjmcYoVlp7Vfv5Q1iIn43pxxHyC/9/QK4dNviRlGsqn7pWuOB5+RhgmsrFuQSHcWduvjqMsQ9HxRRKm1JmJsYYvK+5l5b7bFg3lbrVVecMoh+mzPuWLCUxLJemYahNHud/yotxkzCZIcqo85xgeQ+0qRwOtmFjGTE2bV/xtWkHvFRW3FrNxz4vR6jkP6Aj0gy97my2W6bujKu4o6y+Q49LDtiCqDr1L2++gT1NvDgd1Ye04/+DIeu2p5+j7aq89/qZ8aBWNaE7h7mFhqu/ZsWbMohlDJtDIOSZRcEU7oZ9TcEuAToUde2ap0+d0bSHRupvDsEiiddSfyLC7TotKi7S/EWVlvCpZCCFxJtCrCTrEnEXEQK
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
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D29


