Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48A7AC982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DC646B00AC; Tue, 15 Sep 2026 08:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385B86B00AD; Tue, 15 Sep 2026 08:18:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24E1E6B00AE; Tue, 15 Sep 2026 08:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EDBB06B00AC
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:18:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABF9DC03E8
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:18:38 +0000 (UTC)
X-FDA: 85215899916.10.0A9ED6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1D2934000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:18:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ea1sJwsB;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474717;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vrVAobJMjM7S9OZZMwIDwvr8ty2bA0kqwagLpHQp40w=;
	b=8WlcyBVW+AhO3vUUqwC/F4aP47OBdiXIc09OzeESmVOOdE4JtlTBnBR9Ea/2ujCke6Lobd
	X/JmWebPGcIVKlxHNIkqeVJlxfGUFFXTbvySSP6NpWxsrmbeKaanqZjYQNBvZC/dYfIUX4
	h2Z12wh3UEJ+AKY96a7X+cuwDJAocc4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474717;
	b=THmjq/MaGouzxG0H+Oy7Ep6hkem/HFVsaZRtXU6t1WernN3wEcMNphPBVnYiUjSnDBKiOA
	cvr2NT0YVwdSv6qXnHbR6OtHUP4jaRwIXnz0wOfaqFvBBEM/++HRtp1O+XHa6ih4m1OkzW
	ggOrdrnpfATYgXygshU14b5Q+5+mO3Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ea1sJwsB;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B2BA5602C4;
	Tue, 15 Sep 2026 12:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6111F00898;
	Tue, 15 Sep 2026 12:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474716;
	bh=vrVAobJMjM7S9OZZMwIDwvr8ty2bA0kqwagLpHQp40w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ea1sJwsBr/Nvel740b29/2lnm8kv13L85FditgVsIEu95cKYPQZU0Zm86Po1jnZNR
	 WHN070goKjNpVo1FRyPViEa8NGr0QNUX2ucQBNO5lGEpXDGQD7U7BclSRhluMnxtKP
	 ATnOY9YQY/9J5OJE6jroQgQS5sfBOnMZtK6e3d1b5IYszHnQqLJX4JE1tZ1dgWaKGz
	 MVf3djXQJIyElXt0yrKwDYp8btcu88OnDKD8ru7wqrjSAcI7zj25kTBGPYQCXOGFwa
	 RfYXn1Lwzeg0QAuqyZ/UnU7T5x+37hRI9c8kwg/0XtOV9Mo2i3dXkFawFgls2HqTB0
	 kguWCX48YbslQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 45/50] accel/habanalabs: stop putting the
 dma-buf descriptor back on failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-snps-arc@lists.infradead.org, "Oleg
 Nesterov" <oleg@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>, "Ingo
 Molnar" <mingo@redhat.com>, linux-alpha@vger.kernel.org, "Alexander Viro" <viro@zeniv.linux.org.uk>, virtualization@lists.linux.dev, linux-mips@vger.kernel.org, kexec@lists.infradead.org, bpf@vger.kernel.org, linux-arm-msm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, "Jan
 Kara" <jack@suse.cz>, linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, linux-um@lists.infradead.org, linux-csky@vger.kernel.org, linux-parisc@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxl?=
 =?utf-8?b?KQ==?= <brauner@kernel.org>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, linux-hexagon@vger.kernel.org, io-uring@vger.kernel.org, linux-m68k@lists.linux-m68k.org, "Eugenio
 Perez" <eperezma@redhat.com>, "Jann Horn" <jannh@google.com>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-45-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-45-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:18:34 +0000
Message-Id: <20260915121834.8E6111F00898@smtp.kernel.org>
X-Stat-Signature: yjgdi3jewgdnz7xuzuo49dckykudrio9
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D2934000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1789474716-227875
X-HE-Meta: U2FsdGVkX186fIsHdtmZ72JCKzU9aF8D0OKPuLfB3Ic+fpeA/ZSgDb2ZN9k3Jmj22BI7+n+f9bWCsj3Y5h0ATllnEaIGQqU3kh/UC0Aeo1QY9Qg7E9vXIRUe/5iEbD0NrLgYlc+8gmLIDlu9D+3oCB6eUaY/uwrTABv58E6sRcDpjoe3LM6AjReY5rLnqFzjbfQjosUr5a0q6T2pMB+TX2HbKRTdRNYIUPXLLnhawSwrofAPQxaVHWawxmj2LZe3NVZPI7pCQ41+Fj6hQoxTBws4RJEaeQ8Z+6wanzPQEGjqGp0NcHy/4UDTB0u5+GZtb5iNJNn811tiCgHbd33vTFG9xx3brdJ1I31BE4UjjudoSkgCVrOFlDJZ56yqoVe6ECLoyX7l8XvJimf4R1wc3521f0BNoDFZ7CCWchrhVElE4W+5xG2DlGxNoc9I4L59ayUqQvOPgCyMQvCcizliaIiJCNgoox9MSN2lKFGCHfYnYAN/+gmkRO0jLAIcWtwKEdGE1GnoDqA2Y4wicspC+QxyHQawsGDQ13aHGTMIihqn0kR5lY6esJqs1EutJmJlQltJxgdqN776lwfwmq2gQioETYkMRJv6LIp3cXyKbv84r3GTKiFQLiXuuQk2sjX/E2vgSbJnQ03SHUXkHId+B0kk+lX4zLbszk0Pyg5KhFLgpl6kkGgLrWWYhnQ2NCH3368dW85bW1Zl56eqU9U4Zx8fVcSen9RArO87eRBo/GWyFkf0sSFOFae6UfKs6qlF8usaQ157q9nVqLWK44VTLpvlNk9pCx2Nnbi8Ar7w4xRZrBlCsZPg5aT3d9MnMqigSmurdaQeJpkLDYwwRfaTm+qYgmDpZ+zx8UBj3CKre4eEDWiHQoTXn03azCLLXWzSHu5LrNfLtCq4A//QRE50lKk5scnhRcwytdBz9eE/bjui69emPn9NRROp7BEVJJQMP3kx6/KKPDHsncdl6Tc
 +yaJJKQd
 Gder9m8OFd79W9HzSkG4tV35YnR2/9OfMwbVzrpnV92R45PvG0r3SDbOyzperVlImQq5J+NZAElHsN0ETQhWD9x+Ffrg3z+khh3sop6T37JPmmUHr8wOUy83oEo46nofa+vwB8E7CWeCqBBaN9fTN0sqiffhU5TEC1aVuXrPG/Nuzk6KNQ9A3C1lVIE9nWH5AEyWBpRHIjVQlslaiIPM1AGv8B5653j3ADBaPEIjo42iDXsQbYMUQGR6VWG7125wCWliV5ZLIEDWAn8f7T+keKPDl+I/yc1A+uxZHeOCvECLw0cPA1soYeYvnOChAd2+6dySXf+9xPp2PBEWQtnQsv4LYSmqpvgY/wITu+DYKynJoNGLiFenrE6WKaiHgWHsVITyCsjUR4S2W6Ktez1fViWh8OrLK8CTwmdqS6lNNwAcH+ggyYAwZKdd5SKwJWgtyQt0BEmY/QItHxFR1mxAc1+E2U49rv5Iyc1nba8Gr6NzdVzBLdEL15Pj/RBGPPIUPygiTj+MJsFJwOV2Ev16uI2o+RpWsOgTVqJcePbXeoqN/iw6Oz3DLBe4kvb8goIlfiZiPoGMKWpIDAGownWHm7Aw4/iPvFjy9HrgbO5Ru6x3uVn2jlLwx8eClQb1TALX798zCe0bwXhWIub1IQjNRmcb0/qBLovs4T4xe9/Wt6MBhI6JFdPTPX3MYgM7WSaD//TBT
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
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D45


