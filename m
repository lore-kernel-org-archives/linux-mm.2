Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 932DCC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5AF6B00A3; Tue, 15 Sep 2026 08:15:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAC956B00A5; Tue, 15 Sep 2026 08:15:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C7F76B00A3; Tue, 15 Sep 2026 08:15:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C52E6B00A3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:15:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 305A81403BB
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:15:19 +0000 (UTC)
X-FDA: 85215891558.09.0FD2B8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id A13DB1A000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:15:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kI77b5Cs;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474517;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Ki6bSBJwaxJJeHi7SKUuFLkbZmfL/7uuTnWaWs93uA=;
	b=LQZoDfVgwjhYvGpZ5UDTBb5NYZIUJPkcuawirK3No1jqafLFuiUboAbIsRzEnk/V6/jdDd
	7fLdbvhc/YbKkTwhCWrg/fKeU0YaZyHYlvsrHmJ1OnXvrP9lyBGSBDOHgGq2pXc7EIGJEU
	xNoXENT/S5whruTiPgYdYcvAp3z5zFM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474517;
	b=X6OTjk1lMe38cykWbayb4SDZIqX5lEzm1i4teQ3uFqFHP45vVIkGqfYrKXYx0M36k3++QO
	13J7GzVkb6EAnJwu3K94b7NINrBpUfEiX4EckNDphJetRvFzk2z1u2z2i5xKJcf8D9WSE9
	DsISzWFru9A8e15FWgrEoQSWtG3co84=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kI77b5Cs;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4720D60261;
	Tue, 15 Sep 2026 12:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295751F000FF;
	Tue, 15 Sep 2026 12:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474517;
	bh=7Ki6bSBJwaxJJeHi7SKUuFLkbZmfL/7uuTnWaWs93uA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kI77b5Cs1CCH5C2TVxPIT8fy3wL5A+5GVvFbNqnc8ywtIl1xsP+kz2+YtB6oqe4rq
	 l5MIumARVSkDXAKZVkJf4FmmuUstog7U7WkwkoO47/GequtFboDqXFKBhm8gRVl+8O
	 R05h3rhCE8VlU3e70rQ0v5HNwr7mByz6nbAUN2qjsZ4EdPZrSzKMrkSw0ptkltPWdD
	 1K9aNz+rSv8p4Ksfg6V+iO9PxpNKvssHsTIw8bHe/sGHatYYCzuFLzRvKplACIwjle
	 MkbJfnFHm3eFE1Z3cOPmlWvybtFLHN5O2L13O1dy8fXdonFCUhJlZiezPlMPDhpdxP
	 QdqQbUTSLLEqA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 44/50] drm/etnaviv: install the out-fence
 descriptor when the ioctl returns
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: virtualization@lists.linux.dev, linux-parisc@vger.kernel.org, io-uring@vger.kernel.org, "Michael
 S. Tsirkin" <mst@redhat.com>, "Jann Horn" <jannh@google.com>, "Oleg
 Nesterov" <oleg@redhat.com>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-arm-msm@vger.kernel.org, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linux-mm@kvack.org, linux-snps-arc@lists.infradead.org, "Eugenio
 Perez" <eperezma@redhat.com>, linux-m68k@lists.linux-m68k.org, linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, linux-mips@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, linux-sh@vger.kernel.org, linux-um@lists.infradead.org, sparclinux@vger.kernel.org, linux-hexagon@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, "Ingo Molnar" <mingo@redhat.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, kexec@lists.infradead.org, "Peter Zijlstra" <peterz@infradead.org>, linux-csky@vger.kernel.org, linux-openrisc@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-44-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-44-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:15:14 +0000
Message-Id: <20260915121515.295751F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: k6c7hhynem8zkinicwgjg1ii9hux1167
X-Rspamd-Queue-Id: A13DB1A000B
X-HE-Tag: 1789474517-407435
X-HE-Meta: U2FsdGVkX19n7VhizPblLy74Nb8u/VxOLaPdM+1hF5C/QApepX84Ea3+kiVS2D4TEXDwqIojAeVOt/IpacB26Nf0wwddtOWgGoEAQ2TYU3hGQ2kGsJslM7kLo9d80epnc1waT432Xl1cMIQTiqK+c8uvgcBrP/gOSV1LNnDc+FairJLCNN8hILNtFASGSUju+fib+qfHRafPi4dDVPSkGf/f3cSXhM0sxKM9WYhMx69Gd1IGpeZdSwMFj630fty85GszD/+EhqN9yIP2tvoQJlYvRdFVoJ25OZ5576fdi7YCUZULcJ+9RajQy5tDnKb0ITNbFc6NKdLOegGOPxZo1FVMYCPiqPEvSMkoiD2JPG/f6zu8aiRLe+5TqdEPB+LARkCfSKlhFF9FzV9bcix5jhzuwJwdUs7OQ94N49tA2wr4WuO2l9NwLkuPqiWTqbELI4JW3305VaKKdwPTAe0PL6ncY4cbGNp3cx+ti/MnwyUpIXZtYwYk2T7Q9/eQdypDpqvOYNggp/0f0eupOGwytY1q5yr3S2twAjKgEn5F9KWNbVvbeh8cIA6oBRrdsQCGmALSkojDxKTAWIJ7iWY/FMoXh0wQwwpBQRRbdisoLWlpjP7isI/g32q5j1xg6gUVYTHtmy0Cdhi0yWyNOWGFt2OMEQaTKhoHlacBF2ptuxna63/VagC00q04yJdnK2YAd6lUXxanQmL9hOKsbWFlb4FV2hKpNCwEiZ8VQ49H4CLzy8WolIV9abo66vx8WbzuOhwCxARh8KQQV38T5RvrlxSsjPVC05/0cYMreJigUv82QYeP+8rrH78npVzNWn5BJctiAN47WX/Ycdw3PrnEa7/azX5QxEwi0NTIn3MiPUo09PJpFVLZLFAiS/1uviJ/fO14WNU8trQnPZ0/jYoAYkvAmMFR5Z2uonpNtRm7+GvFVYM2OUSIWcIRLCQjuv1Vk11VXtO35o3eYlLgW4j
 Ssga+qSC
 p/pJibb/r4E+VBqzH+7ducHvNXxBRTWuFrvPOGfdhsqu8ZYR01bJ6AhN1ZYY4NLhEIt1/zVxyYvNw2sb3F3/l5Ox9GUOsK6EI9mfIvQrMw1u5KFxfI5EzZzKaGU1NvTI0ZWJFUnIx+E/2IJf/d5mdlIT/8neaBdwMkwSiqmR8RcUwhEdt4cuoTiqq7pJe2M/PrGqbr0cYSW58KeFfymAhJeVJcTR2WL2qOLQc1eA54/rIfO2/yuNv6EgwzmcZijYfI0TNrQY30+awUfe83W+yE4jFFo2i4rVUfLutfHoQbR4LNvtsZl/vOWPkyw8T4Bp1lekY6lDeMJWOfKcRievH0wWi+gEWMvlK0wR0V17Tizrh4bouRU5lhI506dk0VYOrrRl6z6qVtrrrK98QAvtPN75KV2mSjo4fvxTFTmSTFRKxcvSVOb8mmAAfG0HINo3PqwE+L/R64Rb4yuRNtDUHoPj3Pbv4goceX5fLFPw2JusXnny7td4AneRB+FkyDbzodjqLfq+LNlp5/aCjquGVh1C7HydW/ZjBz/6dVE1akqiJ0BMQH9WgFOMWWvBF59/MzR2dY1iWXgRWi1MoOzY34vTScEjIG5JaJT0L7T2LFRieBkZ15LYvW4TWnrvhzRqD1poLTw2/0a47wOj/zdQUHR4WGkI8NPgS62vCe4KgC0VMbHK73xdz8/4phsxhbR0QoG5n
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
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D44


