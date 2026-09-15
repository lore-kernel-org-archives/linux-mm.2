Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3797C982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACED86B0093; Tue, 15 Sep 2026 08:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA66B6B0099; Tue, 15 Sep 2026 08:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E3786B009E; Tue, 15 Sep 2026 08:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4706B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:12:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB2E71203F2
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:12:15 +0000 (UTC)
X-FDA: 85215883830.24.DD24F7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4C998A000F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:12:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EFlkG4kl;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474334;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTvFOp6vSGe4AZsCgKO980b0BeYwtUxBQL5x62d5jw8=;
	b=enB9t3vR4kzSrFUSHId6ZvoOXb/ub62GoKnlpk+6rEUG6eqKBF9onR1ocQrmQQtvcFkBjr
	0GRLhaHmesPnHBu5G/MJE8PSZE0yXnS5M+b8f3lVBtxrDol0/cPfWQ3yteoLA0tj3TQfxn
	jixUO3U382nHJYgSYX+cfYVC1AkFKlo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EFlkG4kl;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474334;
	b=Dx5ut6ABHtNJ+KqAa2p0boNOcMUTr3BUTp8YhrAE3u5ujS1zMU1xI2yjdp1J7gpyol6JyR
	qOENcS/SmjrHs2epjA8uLwDCS5+R/8klQkQSCDLDgI1eshzCa4tLLd4ed2ABVckPZ2oC5J
	gQw3YpQcjqZIe6cEK8JIkaj0lxY+8iQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A19240523;
	Tue, 15 Sep 2026 12:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7195B1F000FF;
	Tue, 15 Sep 2026 12:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474333;
	bh=dTvFOp6vSGe4AZsCgKO980b0BeYwtUxBQL5x62d5jw8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EFlkG4klTh9q0ksv7M1hSJKTTDQQe7H5iyO2zHATvBU+UXti67y8RU1/odOq/zhGR
	 VYQ/UthUrZvWy+XndwZ77DKsyT/9Ri6pFxYRhTSWuJI+DH+4yLpyuhu8mAIrHMk8t/
	 6kDv1q8AwhLZ6F1rb+P8f3KP0PwnSljmvJWSc46nWvAQt32cRvhQ+HBCxLIdV4HK1y
	 DBbf6pk3x8FN6xy4faUytIL4oO+ojk8F8MkK5f1LgG4gC4ZmwrIhyHU1W79T6CKby7
	 mQNMHJsClSUixl8DuKxj7EGI22mNfTcwiHmk42y9GBCpJ9M/rUqbu9RbXfhHzUFMg4
	 vNY+QKqLhGlQw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 38/50] perf: stop putting the event descriptor
 back on failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: "Eugenio Perez" <eperezma@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, kexec@lists.infradead.org, linux-um@lists.infradead.org, linux-arm-msm@vger.kernel.org, linux-snps-arc@lists.infradead.org, io-uring@vger.kernel.org, linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, "David
 Airlie" <airlied@redhat.com>, "Ingo Molnar" <mingo@redhat.com>, linux-arm-kernel@lists.infradead.org, linux-m68k@lists.linux-m68k.org, linux-hyperv@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org, linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-alpha@vger.kernel.org, "Oleg
 Nesterov" <oleg@redhat.com>, kvm@vger.kernel.org, bpf@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, linux-hexagon@vger.kernel.org, linux-mm@kvack.org, virtualization@lists.linux.dev, "Jann
 Horn" <jannh@google.com>, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org, linux-sh@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-38-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-38-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:12:11 +0000
Message-Id: <20260915121211.7195B1F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Stat-Signature: yawg9uwgjqk55yy1et7hc9t15uwkowro
X-Rspamd-Queue-Id: 4C998A000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1789474334-3722
X-HE-Meta: U2FsdGVkX1/IL0/hPzzlfhY22mFNoBRqLI1xFhIp4qXT7K35dfFGnD9beHmxGC8IiYyDUbhWf6QSpj3OesZ1OUcaaLHJUEB/hz293xBC9z20Gg8D8UdMJcsAtsIzXqpf3FGTLpzaoJVA1TaOvzApx8u7qN0AJ0BvdyiiBzymcOJ5OeWsuTsL4QywMIG63t0EkcUlhkSxR6LglLSY1xD9V9TE13iliQPBQagArHmwKPxJgHcK+/NFkrbA7G7vmSlc79gr7g3xplpqhmysVOb+CGz1SITpWQJ8T6mjrH2Jd4LwgN+gR1NdNRq72yoaYqAmKaOOXYyxUzMVUPBX9jREgQwMJwy2Dh5KBVngjc+9XbcvZxAdWFu+sKfbDybSN2Zp8LIeK2Nn3Is10ksmDdtv2kDW4K3gThOxAZkWBdMBY9l5MV7HWIJ6/5rys8XmUGFXU1u3JHzDxngtZB6emNtlZN6UMjTJIOZuZ1bsop5B5aorah4ysIEVBhX6O0MmHKMWqVL700DUolRvaVGnE9c7fn63UbVXEdWtGOsB8tV9VxVJ6VUGej5APos3zf9NfozEhvEBosvR/QyGJJdrl6Ck7bcqEZdPISPCPnUNLaibF58e3ciAKuxRuYhQVXrenHCeWF6N99fzqQ40Ay7SajkfuaIFiGrJOWOosF1IJAx3yVtKI57gGkaa6+yhSfRHD8cmxhFwNsE9YJrlW0dESoL6XqzwzCNKZrnqMe8dxUPNSPv+RySAP5cXEL6cfoq/apTUnemb0apPnaSgu34e9LvOJB4HBwe7EaldHC42jNQJA0Lo97IjJVsf5vgdV30lMXLYzosV3z8ICbSYZIPfWTC6DxUsFmTyaL1YlSeUeJLc5CiyJ2rNoshzTDWHyXxP3PqRth5/QR76j2lz8o5FTgA6zvCEdvZgkNXO5p5QyV8mUw6YhiiIixOWhBgXpN0qWEZjFJYqpCjEP7XThEq1/6/
 K7FqlgzX
 8nu8t/5+kC3WfsxRwePIYyiTpLtr9vAwiMupgvpeQ0EczzazdZury1WSJsxbKSs3WUZ1Ebd2N4csNvS7x4PYHStJXEy1okWqkt93I/ZTYVp17Ewv5TMq4b6Rm5sY/7+0UUQE3MoK5y6qHPpXHepDRbzjPGuANOb7iDMjxuY/V2YaG/cn/4O3S8qjz+zTCVRW/PA3eDGczaZ3Pm9rOanUtMjP/T+YoAZgZT77LLXDKqQpe+6wdJe+cBqvPt0m/nxuKcts/wz7XB9OpK3n0RCEsJHN0a2y8GCsInuxZO2oFOVplCHzTwrZJ13OiQkaaLiY1Usunt5U0+cqLzv07Ln25n52dKlvajENq6ssCDyFFchPOegT8EfwwtieDuj9G3+Fg9ufRST+5QB1WmaeR8gCQ5+Ztub9Cbr0gXF62orVzWI/aNzfXSWIageNRA4efz+GiY7BTuOH6Vrobii8jViEWrTRjh7GAWECgysAHZco565nC4X8jq3CmaKNn6iWs6/HlELJPzPrcZrYIJk8MGsskAID7cjQxdrdY1h1RY+Ss3hj2C3r13dHOcJciMm7eyaG/GurEqbhVgRUT017d1Qm2iIYnx8hJ72Jk/0A56Si9OghJXhVoLkhaGGqGd9qAkiiB9CHXaF1alSmBgdVBQctawgnxW+xr8zqEyi+mI1ZWFSc7xDt9YwivJE4ncJuVDT2uwBnm
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
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D38


