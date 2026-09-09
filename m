Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0667BC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E0C6B0092; Wed,  9 Sep 2026 06:32:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0EE76B0093; Wed,  9 Sep 2026 06:32:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3AB46B009F; Wed,  9 Sep 2026 06:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B06336B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:32:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10054A0188
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:32:56 +0000 (UTC)
X-FDA: 85193860752.08.5078794
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7101F4000D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:32:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gw5YFqsC;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788949974;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1or08Cl/oOQml/DEZq6dmSOvYX9gsw/HGxWMpfSXX6Q=;
	b=AmywyLpk2IwbubwDyHNbYibxF14YBdhKE1FiJ9+DnHu9dBFLzmO0PCHf8ICEl86sgFejow
	w5zNxUgeX9ENszHijkk6rCtLghGjgEo9UWyg5ex+PO62nswSGukNtZ1lHYfoxWbNwYPBiG
	xgz2IaFLMrwh4nDlmlo2l9Qq8ZNHU/U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788949974;
	b=TmWMoAqkwpp0umnNCZqotB8pwaBBsLojwjdpGQOF8WYDsDeaoxMJ2c4F34Spi3ibpdnlSq
	+OM5X2qXccbGO0kh+F+vyWJ9EKcXAbIshYjC/l6UJrjveqiWPar8tXxDrJOzmPV+e7iMQ0
	c1w56I9Hy9nVsVcfFM8R9sKDce8Ccl4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gw5YFqsC;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9405342B62;
	Wed,  9 Sep 2026 10:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3CB1F00A3D;
	Wed,  9 Sep 2026 10:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788949973;
	bh=1or08Cl/oOQml/DEZq6dmSOvYX9gsw/HGxWMpfSXX6Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gw5YFqsCgsVuhLTgR0h6VYOggGKAcT14+oSd7ei90H1dAejVV9s0danJX9+quVwTB
	 +fLTVYXsHgCSPtgK7AkvvV5lvHgAAtTJo8Q2ZC45MHuITQvFXMh1bHC3pKm7iFStdG
	 PPJralRhoTcnn2kMhF3HS3JvUV6WR8OnBrJHrOmTK5ovyKnIqty971wel1zbpM1MbM
	 9l3rpsYNklfsm59yn6ioYACXXteQAGGC0pj/vCjqrVbrnWAlDbZ02xK9RpQSfvtmZs
	 JqoCLFxemaD/yD8cLis6c8WV5Ek+mLWh0bW/PbXKh0ohbTPWS3EmvGbLOEco3nm/AE
	 w9nCmhYJ4N4OA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] kho: docs: fix scratch_phys debugfs cross-reference
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pratyush Yadav" <pratyush@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Kamalesh
 Babulal" <kamalesh.babulal@oracle.com>, "Alexander Graf" <graf@amazon.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>
Cc: linux-mm@kvack.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260909103001.2423403-1-kamalesh.babulal@oracle.com>
References: <20260909103001.2423403-1-kamalesh.babulal@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 10:32:52 +0000
Message-Id: <20260909103253.0D3CB1F00A3D@smtp.kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ncx1jd1c8c69w3kezs3udkmwft9cqm5m
X-Rspamd-Queue-Id: 7101F4000D
X-HE-Tag: 1788949974-406874
X-HE-Meta: U2FsdGVkX18Bd7Pa6tS4OJKqJKPcZpgN3aTQYc9MaXRyZ9fMfjSQZCTvkUHhyvBcH0Nz/e6pOjp8+ZauX1/ZH1JtrI8eI34pSN9rFlCmL/F4TX/VSuEc2jPYaKwdEf4VMTtQ6Xr9dqQMObX6Bk+lU1W4gSGwhnAWXVlLSk6/KpgYt+4yQe6nK6pmv6W1FXWOmIqUETBiZ9D93G5bPQILh7KesNG3CYoKKlxLgVCXknIDApWPR3DVEdnS1oGEJRzpBZQrjwGwnxQ7/3BQ8Dc1/m82pp+SrDrMN8bnhd7uL+Mp91PoXWQ6wizd/IoBU+0FM/zMcBpsOrS7zRzVlnb5OgQ4sMIVVsS5LnEnXWo7Z/D0ILZe5sJ+36/ghq2SH0703pJ7JgPIafbt9EGcb1JoB7pd0GkqM5CCyHs5G1V+2imZHxTlZH9quh3ns/EMYyaa9q4qzwpvFNaQaVGrnoI38BKT2HRKBov8FmVQAaZcoAHjFB3WSI8j6yzBABRSFi/LK48Ktcko4HAM7dY2uRvfJmIyU2lnayOkHT/sVxJm2sS4lULQI/pZ5qnKx/2daFamGrHmEe4g+7atlHfdJ0+SESv9GqNKCqfcIU93UUhOCuhgVnMQQjsEpUQQQ/qcjv1JojOjnzRfwfuJYeIfmS2m93wi7I4BPyk44XJm6xh3iZr7yZVXBURor7HKBUNGH95rkVf4uizGQ4C4QBixW8iqsUviJNXj63nTNJoh4CBxV5005VbpEUFvlRS81S3n1e3kqIvWWiouhr7gvzYcd7z++cvSkb1pRBHbhr4b/qHTCznlfeb+ZzxtUZTSl0/G/BHisXk+KXWHD8jnPEgWpB/iH9YzvT4k8OjKXCPU0pSu2OgvQbVo+QzB3R8tBi+NZ6LFEci9Hoo74n8CEPKEOshuVx1AZZM2G1vkjJA1B4K8jCU9HLfSucr3WCbCf2g6qfw+jq5awTLG0tvf/Giuk1Y
 wuV4VIGj
 quPfv46fYFin7tka16MX/AuTz1TMJQa9GS+Nf8g1QRNCnnIoehPHTcfoC+7lahI64o4cz+66jPeOv7H4iTN68X7zkccWDuO6kxc9MZbTyTs/F6+qb3tjA+J+HJ8HnM6Pv9LWCOBJ6IUN3piVPpCkxjaahHTq5SKhdbPTFRn28FpPuYkKNlmADOG7YWT64oCCsjLEqMRQ1lwfjQfFZRIMLXmyrfn8SmPw+XMApYiBQ0/aY1Jq3JCpQlL9KLOU6IQEKfyjD+b5V1VndVXeGx2VcdBwPflPM368HD+SC6GnbXCSbn5CNn9yBv1ryB2Vr0YMIdNod5ZZOT3Q5MlOhJ0Vs3A23GCGcrDYILgzmSZ5rfaft7KCu+ZMmgIoKeoWqCOzt1ly5BoDYTmYe5iGthvJgH99zLsTbcywrTJSCDZTPsGrqpyCtMBUBPnz4T9YDeul7/EyHT29ylC5nF8CGvnS6KQZ+RDoghLFsp61duqIFLU0IfsPLUVZ0u8G8lou8A0cgPiG328rBYyo28Bp3wmpQU5Kf6LIHk7Xow3WlNaVGBmekg4ZABGYHVEL2+akdckwTE505sXi8zwZmaJFzLNapid1XAiUBrbfVBxMGGPF6EY1HH2m+gp8gP12pc7uD4Dv9qIrrRTalsi+2Tw4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The scratch_phys documentation incorrectly tells users to use it
> together with scratch_phys. It should refer to scratch_len, which
> provides the length of each scratch region.
>=20
> Signed-off-by: Kamalesh Babulal <kamalesh.babulal@oracle.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909103001.2423=
403-1-kamalesh.babulal@oracle.com?part=3D1


