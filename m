Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D8D2CD98C5
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 15:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0796B0096; Tue,  9 Jun 2026 11:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 792DB6B0098; Tue,  9 Jun 2026 11:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8856B0099; Tue,  9 Jun 2026 11:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 557EB6B0096
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:55:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 21DB81A0666
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:55:27 +0000 (UTC)
X-FDA: 84860823894.23.AC022F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7582EC0009
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:55:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hHxclXE6;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781020525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZbzCK1HDZ6UQM0wxmODd5gt3PhXikPzvdF+pmduOMD4=;
	b=KYHiGzTUDuM9bSrFnHWFyR5cuKajiCAkOUxDMdDhwd+qpYKnmMJB84RoN+SSVi9WNxibIY
	+WVUtORl4W4X+XF80VWreLnuZ0TK0exrFcUZMCqX8RlaIIgMCO4pgsM/0MrEMg8dIXi0VR
	ENYbcKzwByrnsoRqfTsiO1bvzLIWx6U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hHxclXE6;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781020525;
	b=BcheHvAXAaboBdmZ98T5LX08jLzkHZAv8KZeYjCxPnvIa6DxI9TmmtgqIU6BrDqTnLEcMI
	mpQ5jhZmW1t+4xt2re7fvmGy+HjhR0oEZ6M+EphF8Ms0vr7NjrRg5l2agddWY6niB721Bg
	fb4YXakoinwiRm6E0PYmqOr8+gXT8qU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0869A60234;
	Tue,  9 Jun 2026 15:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACA31F00893;
	Tue,  9 Jun 2026 15:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781020524;
	bh=ZbzCK1HDZ6UQM0wxmODd5gt3PhXikPzvdF+pmduOMD4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=hHxclXE61EFMwxcZZ4ijcKdmZQrXuHFpw/8CotX43ijEM7cIj8eoOWyMjiEpkQs9z
	 8s+wxGuYEcL7qIWh2PuqYhtJ6sViwxkpG7ntvpgu2+iqzL+PKZjbAqlVXkOA9EB3JM
	 RXOop81ORKUegIcXQm2xuJUzqk3dxVGZP+7fF5udRvb4yV+c/UJA45i5eC40GfmVU7
	 DatfDIxUwYt+satO6eHDulTBroOMM0WfB/mOWLojxGfwT4BDyImoIC9N801qlUZf0D
	 TE0DXAd/e0ONGvRHfe6p72N+i7y/1poMqooU5WCKSx9FexX1x+6j+rR0jpJR23Q5/I
	 ZOJgu/CycSMNg==
From: Pratyush Yadav <pratyush@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>,  Huacai Chen <chenhuacai@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  Shuah Khan <shuah@kernel.org>,  WANG Xuerui
 <kernel@xen0n.name>,  Alexander Graf <graf@amazon.com>,
  loongarch@lists.linux.dev,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kselftest@vger.kernel.org,  George Guo <guodongtai@kylinos.cn>
Subject: Re: [PATCH v3 0/3] LoongArch: add KHO support and selftests
In-Reply-To: <20260609143945.512688-1-dongtai.guo@linux.dev> (George Guo's
	message of "Tue, 9 Jun 2026 22:39:45 +0800")
References: <20260601092823.110362-1-dongtai.guo@linux.dev>
	<20260609143945.512688-1-dongtai.guo@linux.dev>
Date: Tue, 09 Jun 2026 17:55:21 +0200
Message-ID: <2vxzbjdjso7q.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7582EC0009
X-Stat-Signature: 3pzwpyncd1u53iy9uwi8xeefye871gnr
X-Rspam-User: 
X-HE-Tag: 1781020525-245459
X-HE-Meta: U2FsdGVkX1/uUHv0YH4Cui7R1OFXyO5WPJOeqtTbsgqGNPfW28SMvmaw76HhjnY/1ltwOpUQrpROWCBWkaHHXkmsK4Yi8euSEhgf2VYzj7A8LI6uNaj88vjjtmlx73megHTyLrcBkrqGdidCVX1W9f7NbawjKvLPun3igvgqtfbnfvMWue2aqIElGfWSNHerQCoOwsIu767Tcz8v5qqt3F9ZtM4eyGkYaaKM45FQnw8Flq6P8EFIWDK7lfxCEkgI77KWlDrErofzIbvTIDAdld+NffBmYMw0gokCVy0v3ru5IG6TTSxlM6GN3F3BFjOQGzy3Py4FnjBLj/xgp+JwYkiBujEJ9YHEFPXGO1FHeG39m4UYKyMWbyNzPu/t2ZvVyFyAJcuuDbtxXxir1tP10hQp42TuSPEdJKkGCYfOHFB6bPJitHBgj+WmcKFBagV1MOaCLEXkJ8e0qEZU0ZK8m3m4j8MEjnPvEYjHUzDWLR2z1R3CUR2IgPv6jS1v7pETMZXvz1MEVi32x6Ddsj4wgCDEp7lVA5XgNKU4gvbrj9JlRWof5oWq8bCycJ7SDnbUjzHxcbwfuZVO4+bCnCO/Ardc04wG8TGWdT7PGWc88iyV9LP0IVyKMHPhKtW1hZfm6AR7Eb+jXHurEmIWsVoLb5k49TDS3/pqmMOwTw5BR+UVe8kay0+m3xVkhQoj8iHPr7WwnjstLvP2LGrCafXyDfaWwArA3YgbV5d9xLB7PzaAPMDIoPcKJF5C4mBKC7zJrqnKCJ1FqPtcO8FHwIyU/95Jhqg0Bm00UMr58w6cIgz5xDR2T5AQgH0aPe7BQ1duULnIoNtHe6+tkhczROJfpz30JaaxRA7iH8LQjIr3jSezd88aJgNghAEn8TIADlfglbTSaAA7x60xaaRPz97k9pN0yFvsyVZvxAn7azGuziTn/LlRkCXILDdV3ZbapgQgQbEbmY0RJ4jkD5pJ0Mn
 QlN42Gjq
 u7YQjYgyCpwLK1Almgpatbxxf0cJNOa1vVrZPEOXbjFkFqshR5SpttFIn/2LHQnBXU+0TUOJdWhfFy3qSXTZjcm4swQTR4b+8SKH+HhPxvBgb0Hx4Y1Ae10f/O4OE+dXLVgMRuZQRb7QqVsf1qqOdbfcwdvMxta7Y0Fmeh3t5PelAVoX02gk0ShNIO43l0Qsgqh3ilZituIyuRVPzc9pHlwfgfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09 2026, George Guo wrote:

> Hi Mike, Huacai,
>
> Gentle ping on this v3. In the v2 review you mentioned you'd wait for
> v3 for a more detailed look -- v3 addresses both points (folded the two
> selftest patches into one, and replaced the LoongArch-specific kill
> loop with timeout(1), with the timeout value set per-arch in the conf).
>
> No rush, just making sure it didn't slip through the cracks. Happy to
> spin a rebase if it's gone stale.

It is on my review list, and I hope to get to it soon. But no promises
unfortunately.

-- 
Regards,
Pratyush Yadav

