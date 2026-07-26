Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3067BC531CC
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 08:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1329F6B007B; Sun, 26 Jul 2026 04:39:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3AB6B0088; Sun, 26 Jul 2026 04:39:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14566B008A; Sun, 26 Jul 2026 04:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1BF56B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 04:39:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61F46140460
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:39:16 +0000 (UTC)
X-FDA: 85030278312.24.053C5F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id ACA29160003
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:39:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fFDSuwxR;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785055154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PyTNe/wP4dK9zJvFPt1+xa2X0L9wsLyFKMsBt48c8o8=;
	b=E8ov5YJvzGvzBWaSlJP/Oc98S1QMNW70om39EdLwyvlIgNGzcXm9kcHlnT0dzewAGxV3Hh
	O9/bFuAwHL3HDpWab4+jYBwWmYljr9i6nbAzs0pCnHAO7i3ab2t+FmHDWjuzKNlh8AM80w
	+4ynaXCJTJFgugq2RMgm1YrReFFr+aU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fFDSuwxR;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785055154;
	b=6QzzoFjRFQ7EXahzS9HBEl9wy8DYhikEKJuHnV4ZK9RT92L/wtUzZeuzwDKu3sL/Vk+B6S
	LsWBB02r/Fn1IsxOvEGGofiHP68rG817jgGFzjxfKVZwfe2RGrJ1Ie/1FZzQUqOkkmBu/h
	aPukXmwvs1rdght1qw9jAAj5AioHtuw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A36B7417BF;
	Sun, 26 Jul 2026 08:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8720C1F000E9;
	Sun, 26 Jul 2026 08:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785055153;
	bh=PyTNe/wP4dK9zJvFPt1+xa2X0L9wsLyFKMsBt48c8o8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=fFDSuwxRDAIJWYcA+wC8tfxnYXF2mdc6VRujjn1cMx8aD0Ru+jnC1V/AjcZ0J3VPd
	 ofjhazwjA4wIayWEvEXSjDrLNqeiXmYzDt8MlbrBHPNpJLF1pqR70QMRPtCnV4LSA/
	 FxyWFva9hR14qQRzI8bbnjvOfXZL8dTsxoGAgwj8TWNsBgdBgJb+uoLPSKcKl4Jbey
	 vujtQkurmvXVg++L6lPs8gyTfudR58UOo7grnP6llchBWhtqssK1/Hbjm4PPiIlejq
	 0GN3TL5C8rm7OdSOZm5HnFkQeXaFJoJswXNclh29vT6glD6zl4n3jXg8TDfC9ZviAv
	 Ewu0STnRSOpVQ==
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Samiullah Khawaja <skhawaja@google.com>
Cc: David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
 open list <linux-kernel@vger.kernel.org>, 
 "open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
 "open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
In-Reply-To: <20260723202912.1467112-1-skhawaja@google.com>
References: <20260723202912.1467112-1-skhawaja@google.com>
Subject: Re: [PATCH v2 0/1] liveupdate: Add internal APIs for file
 preservation
Message-Id: <178505509460.1083364.11626390494173240451.b4-ty@b4>
Date: Sun, 26 Jul 2026 11:38:14 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ACA29160003
X-Stat-Signature: 5tor8q3p36ogqxpmxuet7twfod5rswun
X-HE-Tag: 1785055154-440987
X-HE-Meta: U2FsdGVkX1/Cr2ika/0+8CYPKzfp8DeuO4RcfqFdoQtEKLrHdWKJgF2YXeQF+SXxgfpyGSFoxGveGvgNJVMxgdbVH40B6Fpnmf7yyuN2EvCuzAb4L9rMkQceeKvdIhSfWeS2QbTQ6sUEX/E9v7EZBbRHqtmiJXfZJQBDCMQfrZsLyjUdoglA8nT9wZ41XAeY9fpC88HHJMUPsz9XUN13RGBS9eKuPshoMc8Fsb+y6U6nTjRS+KM+16KiNlSaGU9HvO+dcRedA5b9K5Th1a5UCN0huNhb1fanKgV0GTESN8Xc1Ex+xtO6p4y2hB//vrH4k3JcqnP6EuXIhg7z3e6aCbXCxESauTwmp9RY2vUHc35eC24OB2bU4oX9G4W1UnOcmxSBgBZU0ej+QZ2T4XvAUL8VOthnBnqxxDalHEFdUxTz5yL+LupuyNmTD+4MpgeZA16FHoXlkqUBhu+7wLu8DSc3jSJeWRyD5LeSXkOa8nyh1VxXjpYlshskOWjs5/CKLCnTwKNVE7I8K3EdqTbzBM2AgUnqE5CKl53qWK6LVX4WaSk+RwNqTZQNftFpqMrdQ37GavpHVtyIe51CVqUbdvQbvCK+yoHWm/ln1lZWk0WrCwwL3e8Rk0BDpOInUfYVysb1maMaTf6+w7OMzBrnrChPoShgHcHJJLlEH3eFFcPiTuDP4/tedLbD+hn3tC++NlIDs6nXdp/z604DN2+P2NYFjHn5WafdnsaMb+KFsIXecbXEML4wZj8zSj3ZmDX3ycnPyyxNgD66z/QM0d5dBQ/M0BYPc4xEOM9A/16XVxwshDYOU2pYnpDy4G7kV+SHHmUICZ7g+ipKIcfcOAPsSHMVSTki0khvxjPqHKr3DgMxuLngzpKJpNmjsQiU4/k6uvd6CoXDjp7+sEDWihO45uLhA3j4/PJcXZrMkue2+J/ZsesEwEE3XsXa28wGHPMy7IEHSRDWASjsdbuchFn
 getdLYpk
 xU+5DDAzDTYE0DvGNrGWvAQCpYQFnGycWuKQm4/SDbSZE6l87Uoe81XxrOq6dxLJw5UTVtfRh07+XCtD+6xsNTKLt93sgF4a5TkAMe6DbgHgjJ3cr1HqdxSFlVAtKg2iG3WAGz96CZSGUrLI/vwgdGp0A6s1d2nvOR1OTROEqqEG3bNqB32RIZkVYw1gYYvMAiuIlR96kra+SNnyaAnzOQg8g5tx9md6E9ATrUNuACwKQpH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Jul 2026 20:29:11 +0000, Samiullah Khawaja wrote:
> liveupdate: Add internal APIs for file preservation
> 
> Live update orchestrator file handlers depend on the preservation of
> other files. To make sure that the dependency is preserved, the file
> handlers needs to fetch the preservation token of the preserved
> dependency. Similarly during restore, a file handler wants to fetch the
> restored file of the dependency.
> 
> [...]

Applied to luo-internal-api branch of liveupdate/linux.git tree, thanks!

[1/1] liveupdate: luo_file: Add internal APIs for file preservation
      commit: f4d2e4f0d12d88155cd1128ed3294f7827bf4c5d

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: luo-internal-api

--
Sincerely yours,
Mike.



