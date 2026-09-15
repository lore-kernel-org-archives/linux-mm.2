Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E36BC88E7B
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A1CE6B00B1; Tue, 15 Sep 2026 08:21:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 280B26B00B2; Tue, 15 Sep 2026 08:21:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B8206B00B3; Tue, 15 Sep 2026 08:21:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EDB666B00B1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:21:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7ABBDC03DC
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:21:23 +0000 (UTC)
X-FDA: 85215906846.29.9C57B68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id F00A818000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:21:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RifjIpqw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RifjIpqw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474882;
	b=KdEeVrx1yjuyRdp7VMpSPrzogQW04yeowNcJcUNoiIVIk04gbRVh5iClnRh1Q0pJtrAiG2
	bxRRdcPUBeGAZVhQLFXNXWY5Yj5bmVnm5HmIjMDfQiymXnSON2oYe2KrP5TngzXFvI4pp/
	y2V5bEZZTXPJ257mEgmXlwLg6UYKg74=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474882;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uc7cO5xoe1cQZMzNgyouoEulYOfR9Lrcdm/hjSDUACk=;
	b=7tailfIs0IfTC3jTcyJe3WdgqKbnvaiKky27WDphZblXtTWVECMzUTQ3y7F+Q5MNpr/Aya
	4AaHhlW/UDfea4Ur+v/t9sCI/brQr+RYuLcYpZam76EIVyQScyrbBwC8tJBg0oJrmHOtmV
	MSK3HrX74d///NNKrr00h0EF7cH2tqM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8201B600D1;
	Tue, 15 Sep 2026 12:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789A61F00893;
	Tue, 15 Sep 2026 12:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474881;
	bh=Uc7cO5xoe1cQZMzNgyouoEulYOfR9Lrcdm/hjSDUACk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RifjIpqwJ9OqsSvNVf8dpgAPRIXNtpH+2TvjVYCOe9JUquNlggyFFXGJ0dnsaYmCg
	 GQ9XosyxDDx8GSMITHICVAvNL+LxNcmxvQMQP7A3d1sqIXZ9RcF7rJNLS5wAMhcPOo
	 SPow9eKiSuj2zKpRt8Cuw1b4X6SN6EeInZhqMldrk5L5hldvpE4fVZKWhOZYYZiNwJ
	 uht3jZCMYXSw+Eavv2okVbNxYC6NRCTmed+SaIPKeRXggq0abWEv5pETdDXtyZFTxL
	 +PtN1edDe9OuMct6IEevtSb0WL7MUHUyK38VC8DLpI0Q9G8uZMCxYp4zSbGdcMEgO3
	 kB54THZRs52CQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 46/50] xen/gntdev-dmabuf: stop putting the
 descriptor back on failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-gpio@vger.kernel.org, bpf@vger.kernel.org, "Oleg Nesterov" <oleg@redhat.com>, "Jann
 Horn" <jannh@google.com>, linux-mm@kvack.org, linux-openrisc@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev, sparclinux@vger.kernel.org, kvm@vger.kernel.org, linux-mips@vger.kernel.org, linux-alpha@vger.kernel.org, dri-devel@lists.freedesktop.org, "Peter
 Zijlstra" <peterz@infradead.org>, io-uring@vger.kernel.org, "David Airlie" <airlied@redhat.com>,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linux-m68k@lists.linux-m68k.org, linux-arm-kernel@lists.infradead.org, "Ingo
 Molnar" <mingo@redhat.com>, linux-um@lists.infradead.org, linux-sh@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, "Alexander Viro" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, linuxppc-dev@lists.ozlabs.org, linux-snps-arc@lists.infradead.org, "Eugenio
 Perez" <eperezma@redhat.com>, kexec@lists.infradead.org, linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-hexagon@vger.kernel.org, "Michael
 S. Tsirkin" <mst@redhat.com>, linux-csky@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-46-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-46-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:21:19 +0000
Message-Id: <20260915122119.789A61F00893@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: F00A818000D
X-Stat-Signature: sxghupoobushksdxhcx6cnmfgzpja116
X-Rspamd-Server: rspam01
X-HE-Tag: 1789474881-697662
X-HE-Meta: U2FsdGVkX197c15c5qCIFlF9Gy4tEEimWU0f3mChqIojeiQLEWn8hdUrFhBkGGHCvAUfczwsySkMCbsgGjGsS/r22TFrktjvRdvpBKNCf2X3sIIO+3yjkScGYL6Nkzy9ob1kDBWvS8+D2b4BS4biLjxmpPmoPToVFu+wCQox0cEn9K9Yq/pb5iiZpSRcGrWhRpuWnBdIW7NCExyQr1zc44nfSv8wo1kPzsVwUjYdE2OzyK5fGVF2qSNNe8uhXjpnTavftC42G8U5soLac6KURQy9liXntLZljoSdY+n7l+/LxK+eqmgaUHaFOCvjijYeZUn4Ra8Qc7JnYlaqJzGCKsPwHiE7S9p0PEGxFAJ5rbmE4wq7WYW4mD8wUeMO3pnYJFgJB8JyEtcIuV28I3ISaIKZQWZytHZqGzNrQO7FdPQYRf9xHNGrYpL2GzGdWXOVUjeKgUlCXcHUZHHszazoO3lL6MlaOsprL/6cAUF+1sWvn4DiQHsrWsngoJa2MP/PtKqwmFLmJJQgq0togzRg+NFbNdgqOpjGUv2ZhN4sLf9nlKjPgdETGcfPYEqtbTFOgyHkA9PgVENj6EvaYFXI9/hC/myLbZHNi3056AbbMmi45M5vSgRpSKRDcO+dBTcoJLCbAoY3izFdHL3O+LXPTF45JMWlWxkqOokepH9r2bh+OJOt5R0CdfbAZXASaECzZacAvBZHsPVeEAgf1GGkcNwDCXS0TGBt2I7EVf0EmCXOdD9kdIfTBuF7RLQZ9nDo+xs1BVh9Scii3RlX08OzG7Xv/dVwiS+h98FRD3WIegVGlxQbRlm3ktc9McG7JIAjC66FUUO82c/ZvpiucVBcAVxob51+XvoDGKnpwuu4MaSOaeTnrEUyPjeEm3PBWkTYjE+x+N91PU45auPZJs2lvzuAnr4/RDuAnTHwb78HCNsyvGFQG+vnj5lbpaSd0u/ySmgLAo9B+yLiwURcNmQ
 rKiaUxcH
 2n4BuNMJnuPQtzCYDGlwoS/6sxUKl/R+mq/+BYvE8XKRNSoaIxL7lTJC/t+MGReUCCPYehQBCMmHJF2ux1LK2AIlr8vxkXv7MhRWsayhjBOKIynFyeVGJEXqv0cLiDCvH1IzMvQgL70Kk82H8Xnj7UT2F3cfWMjitiwN7wu3YZg/R5klrzW+0Jx2HyqmAdj8LZarVNzddEwtonoqgB9erW1879yKasdqmHCD/LBol1vU9euov8c5DNurUp8ui98vOMqajN45MJ5eQhG0JGIzWdGVn5Apcs5x+eYBp3+KdIUdyLWFAzGu3pJu6RwD8loM1mrklXfwkHlpBpK1nJEHgcuMed7XV68NL/gcEoHurJbMEraup6O96Sch3KkXscTkXxWQJLU6ViJ1aedpQtWNH6yZaKWmY26n07LIFwfNcyTqaJwF2qntlFuPoup0815eVZpSEO1nVEyqrsxjirLhB9EXhvAlL4lvaQgXddpmChBcQY50vrAbfDF5Ve0zsCgdeXBhX16vPc92rwd1OFsLGmM2b2m+4Jf4UG8KGuWULQNpR8OCoI9+OdJmdgG4M9uM01z7JhvtDiyUhAAxXKmWKcdUBdkSnfjGvp8XdwkDGnPVJ3DQ4LfHZVyBR+g4JUFbSCfgugq70ceBiXPkIZOxSJYgLFESgLY8OVF8Ko+3ARxkqSujIopx6Sc5ivMoO4YCFbg5c
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
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D46


