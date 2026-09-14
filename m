Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E40C88E69
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 05:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F04916B0088; Mon, 14 Sep 2026 01:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDCEA6B008C; Mon, 14 Sep 2026 01:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1C6E6B0092; Mon, 14 Sep 2026 01:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B640E6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 01:59:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 40C8440CC8
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:59:21 +0000 (UTC)
X-FDA: 85211315322.23.5119FD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8A083A0003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:59:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DYOs2YZu;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789365559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HwgDrDnEblWNsNQxUseFgLL3m5bnPaTZRpQzIjhhgW4=;
	b=GNMPf5BFknvXirfy8JmO59mqX//5p8X5Yc33hb+sR3kIwUEFoJuKKyIms+V/vUWl8kIJSL
	g2xo+uKBoKwJnq8IJMr2CKJzDzcr3GpIfniDX3KpOmqAWWmy6Z7qfrpTXk+aHPDnKB/mBq
	O7SRG2nHvASegTtPdUUIPEdBcFrqanc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DYOs2YZu;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789365559;
	b=PX+y9UpcpVkaX81fd6UIPLgDwfaGPjRxX0ccEsClmVRsDD6avef/exHUlMQErSrM31F1dy
	mLyt15TAyKFtClrYhCzjw+G5MhZVWck1mxPZe6FfFuTF81UVS+LjqZbZryyIenEMrTuZfn
	Ul2GGui0R4WJOy/i84a3A9y+4BhYhU8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0053343474;
	Mon, 14 Sep 2026 05:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78291F000FF;
	Mon, 14 Sep 2026 05:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789365557;
	bh=HwgDrDnEblWNsNQxUseFgLL3m5bnPaTZRpQzIjhhgW4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=DYOs2YZuT0+Mxf3rfQU2AC8D9wUnr9Dv5XkagKJFBm6H/vdGfb4pyryeRsY6wvk/L
	 BMAYEEjQWMOqNvf7kxPafTXsBN4hLTchDtouZI2R5DGxCaZuVdMT5QRR1jU04OGmtK
	 Tj22GgN05jvO77EO4Sz/oxdR+qdjNmxEclHBpLYM7l77sZ3SszCWkeIBeioToE4/iT
	 Q2U0c8MUdjsqSUXkHuZjnoUzLxEf44WnRW1gbpNqlnTjlnmqLk4D/AoJtaIb/Na0bK
	 xg/b7GTDy7XqYcZU86lwN6FEmC07Cx+RDajeIp0Wlj4s+pjuAfqlS1yf7d8KKq3HJh
	 MU/AD5w0odFKQ==
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Samiullah Khawaja <skhawaja@google.com>
Cc: David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
 open list <linux-kernel@vger.kernel.org>, 
 "open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
 "open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
In-Reply-To: <20260910173659.1945246-1-skhawaja@google.com>
References: <20260910173659.1945246-1-skhawaja@google.com>
Subject: Re: [PATCH v2 0/1] liveupdate: Add documentation for file
 dependencies
Message-Id: <178936555084.3691424.8106623729087785082.b4-ty@b4>
Date: Mon, 14 Sep 2026 08:59:10 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8A083A0003
X-Stat-Signature: rj4mjgaq1tmk479iedz67icg95r5qfum
X-Rspam-User: 
X-HE-Tag: 1789365559-868985
X-HE-Meta: U2FsdGVkX18PD1r9dJge5jUNv8nx3FFDHnLpQFJe2KtK5TwSVvEplhKYMaKVCxbwcZJ6Uh6ErH3dHayhkKiz6vcjk9BuVmvAyy6wJBrrtNz87jqHlceGbMXjieGPD1rlZyiVfKaVYL6k52ZnL6kCPlBLIbKlB31a4cVIi2CkfZgckMDxcn5nxTTsl99l1SvD8fQ87uxftzAPvwzdkSzDNphCv+OeOOg2vOh4vj6bjFXPtV3LoQylzC8+N/REcd8F2tOJoHVoRcl2VWJxPDdPBwn/Snpbpr7/4xfAvAsxASCvJwJ+IwBMlsyZkKil6ZMOB2j3G15y917iNY4n3jkw3yPKPnRTKZvdUOi+TFzyrhcvgx3AtMm/jkJkYCYONmKYLuQ295kTkqwPEr3a0jVGqqeOf+sMNwa9HD/Ye5nGy6OU1s5TALygjUvPBADvojMKdGNFXkt9kMX5QB9RjkkwIHg1Uvx0mrUjTBcv3sKcKkbm4ckExMOLcvSFXXx0M9WAcliWxHc/iPYqNuVGGfkJt7OXn6EAkmktHDbB7amVj9HhB4a2uoNykhktd/yozeLkrFvjCHN0u7C1mVoBRios2jxyuN0orJ8CMRtOb+3Q5cSaMLC3GH11RzPyzV/9SflqMewjgtlvHxd3A5i5O0OSSiQjbodFmyjYnMPSm+U8BPclFG9wybRZq/QC5T5cMsJtb5L3IY4qR86eOp3QgeaqSVvt1fKGgU2+nyyUe7w5b+v+jFnL6pj0DTIJagHeMG8wUMia4wtsEyg6FRU3bXXj5E9JyLQNW5PBEpfPERpeh4H1R3QySSndMb1r3CSY9HItlNJlcXmm9AmMCdHbvEgO901phHgqDw3XgbnQAcceEMKk97uv+C3w7gxlO7yJ1yY/4C0e4WWRJR5g936bcxnIZTXUy68PwgoS1RsEH+oWwqj/H6D+H55PxEbKF+Qb0MnVlGhM5Mw3p/KJmuIGxQY
 DEUK3FoD
 L0Fxb1Mt7LzU2D6BTczPwVq59z7Yt9eOj0RKvK7z9IvpZzSBA+RDN9TBonTrZsUzHrQerRYwTMusTQZ1ANr5x6n32cH7L0sciavQ8oV8jIa8ImQ1dmdmfgusZODFPKMnp2KLu6+Rf5YkXsQ/MO5m8Jlby1hV7sFcCoYLb84QTywC8v/c+19PztDiYi1zHiwmnLWXQ3YGVjIl+Zzili9c485OdPsWpw6i6IvkC21N75kSAQ9YXWNBdbtlaZmijK/2ilbAYKxaZs1IrePs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026 17:36:58 +0000, Samiullah Khawaja wrote:
> liveupdate: Add documentation for file dependencies
> 
> I sent out v3 of liveupdate_get_file_incoming() and
> liveupdate_get_token_outgoing() series to add documentation for
> dependencies.
> 
> https://lore.kernel.org/all/20260820191854.1642931-1-skhawaja@google.com/
> 
> [...]

Applied to luo-internal-api branch of liveupdate/linux.git tree, thanks!

[1/1] liveupdate: luo_file: Add documentation for dependencies
      commit: 38dd32f08d19beb441f202e61d9dfede3b7f055b

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: luo-internal-api

--
Sincerely yours,
Mike.



