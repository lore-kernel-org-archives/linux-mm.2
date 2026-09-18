Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8F58C982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 00:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C88FB6B008C; Thu, 17 Sep 2026 20:28:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5FBB6B0096; Thu, 17 Sep 2026 20:28:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9CBF6B0098; Thu, 17 Sep 2026 20:28:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CE9D6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:28:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 356361C28D5
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:28:49 +0000 (UTC)
X-FDA: 85224997578.29.517F7D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9F7C31C0003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:28:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M47w4V8O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789691327;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CZyUKeUjL3VbbEuUgq55Wv+PmZoa3E5pWDjbtphAiMU=;
	b=u8rfsca+qTrVINbd6t/AGZhymB8Xa/k0kVtnAQOVj0obU5bxC+NWoDilCtTI2Ff6kxJ8+Y
	5DKWaPbuz+QQ8fekw/Qsi7fHUJ1PKjOt3IzX0dyVlKxLWG8zFby5wtlS/rAku25JqkrFRc
	5cIPgoRTWxQhw1Jda/fYjQ3qTJGvkKQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789691327;
	b=ivZTjv8hx1hzjiRUmBtYeM4Sr13Rn992IAASteU/zfL1c+hfTdJT8opSxhRrRGx9FzVTOd
	PzkCII9IYYYWKRq2+1mCbHpo3+5RdmNbfvdd3IoyqooC5ZoAoLj2Kg7s8Hf4UKqi6RGvGd
	mBO4beCARxN7qKOayznhIsBU4ncVOe8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M47w4V8O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D657B43751;
	Fri, 18 Sep 2026 00:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F13C1F000FF;
	Fri, 18 Sep 2026 00:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789691326;
	bh=CZyUKeUjL3VbbEuUgq55Wv+PmZoa3E5pWDjbtphAiMU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M47w4V8O1MJwov/K8stC0BWLy8Xd0XiFdkCxmRliNYgCEVr89aeb0ZJ/fJ7oeIJlz
	 RGDTB5ikI75dsYAMQ8KU077OumjB63isA59L3wlr396rJIhEwyHz+GUYVS/YEu97H+
	 EZ2JXAkKMa5ejpkR3I/9B5H15Yt776sC/4b/5MqLC/Osa+3GphfLlxJuby2xsuSqOz
	 SGMAqgkuvalFE+/Dw7OTWGqxoy+fr2JAeGyYQAqLirHOWZSGqZSZk1iehgaQ89IwQB
	 oExv03YOfmyEfXlE3N0K8DGcmnNiN/lvF3Avcc6AGD1m7K8W0Mm9DYIOoDMrPXj4a8
	 GWyZrlUiHsUSQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] memblock: use binary search to locate candidate
 regions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, dmatlack@google.com, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, "Pratyush Yadav" <pratyush@kernel.org>, dev.jain@arm.com, linux-kernel@vger.kernel.org
In-Reply-To: <20260918002239.4024231-2-tarunsahu@google.com>
References: <20260918002239.4024231-1-tarunsahu@google.com>
 <20260918002239.4024231-2-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 00:28:45 +0000
Message-Id: <20260918002846.3F13C1F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9F7C31C0003
X-Stat-Signature: rizstrhz6jy3w5a7ax51taxwczd4aidg
X-HE-Tag: 1789691327-52264
X-HE-Meta: U2FsdGVkX18yYmvQmi3hfWSWCI6WOy27pveHjd1lQ+BQMHS1xc4yArhF8bDxl23anErMhzZ/LIcuk8xkZZ+o1gl8XWHtEvIAf62e+Vj5ZJZMiJrsEeyBtA7/9PzUVh3aBXek8ubJgLeNJo4GBa0CgQNcAlVSYYxJiBz/kEn8/D/WbCeBRUii6g71QYOT6sGvLHjJCA+7yGuPoAAFpMB1bFMeRFWPS0jkfriht7YROJh2vv4LROOIy2+wcu9Pzbl/t2FOwI6EqQ5rmnTGB8BGmBEsHVGQyodZyyjgdJqLBTMa7gbQo8oecpRY0Qwjjf1j8B2vDOXSuOLbyfoHVKzSpplEzSbdjW7gW7r0B88+a/TfCA9QRgEmGGksE6ezjfc1SewJclUhL9dJZLYW5HHpyVayQ7c81jd4KJAs82lVjJjqUSX6DkHGu7oZLSoAO6Myo4eYyhtieTDyQ6QTl8cs99T41DU6cPplObTizlNJPsfrNwKF97N/02cEEORgLAyHtkFGFrG4ZN7k2K7MA8GheLSH+GamqfMITFPyVuQ8j7DIvKR7DOJ6tMuSvsTXwVFc5VU+Tq86TwDIanSoHfmnhIQTo6t9hmLpiNsT+dIZ43Bl3EFOcZWRJvcOvWv6tfMaA90oTa5418otW9IAiXiq9SrSVsiCm494pkNtgfeOGWHeoNCmEZHc9lycvgIpsxfJsYv5OkpS5jtd5oVynsfGZAtUk98tf8CzGghts+9nWu2BA9R7CN/bBD6bzY5Ca/zAoKVXCFDgj0m1B+wIT0b1QfL0vpAZepAvzd8WbAPQksMNb8iNL873B3M2CsX5lTMJ2k/hak/D0gm87QCxArZ6D8ito07TOzxvVAqzfDK/qnV+9mzYYLEDp2SisX6Qr2daqx3UsYBpYenaZ2qvBCDVVVMhyprhh7gVUh2ctjHESDceRv1uaGv3P52AKTf3rSCSLtEicBXoBl5To2Qt8tL
 S7TGvDNc
 eAorK3zCD+yPE7WlDLWW1ibTzfYQOl2oAwESJLCSwIwTLfsb+lnVEDVuji8UUFfAsPYiFHPBbFL2Dr9fnypGh9tedHpZh9G/85n9uer8hEYihzTMAYkFHk8q/K1E4SSW3/CMsn/uTk3yMEd041UoAv7ZiXaCZG/tqR/XaD+Gm44tamNxd125iTeMWkgXGk/210n4ImSQ7X7bGolvcv7kspA9qUBt4Lcbdan0kLng6o+mcO28Mh0v/ikFLN4s3ThOMYTYqB52zHFMmKQX1KaX3lwhgxrYvZOZceLKOoFRtUj9a2aY+O5RnSFGHnn2S4KlH5C6r6XJ+BEque5jezbCfCzUqz4GyvPrBXQNEuwR78AR1Qwza/QqfqImOO4t7aclIVC2O7ODzfr0CgT/KMMNbnGfEs9aaND9uPPIqy5TL/9U+vi1y23zG9vXVM8A9YM4Sdq2DrdycvZ+pgj3TuMJfzGZWMsMWndw1b3Kf4QGrFxnLd4sZEftAihqlabdgJdFvQQ1Frh1TYpU3AU1UE17WYCFexyyA89e0TqqNxnYtRDUYasyqzhzhgt4PyWW+hlUZ/1CdTAzyL69G1juBMGKDy5qIcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Use binary search (memblock_bsearch_start) in memblock_add_range() and
> memblock_isolate_range() to locate candidate regions instead of linearly
> scanning from index 0.
>=20
> Under heavy memory fragmentation (such as KHO page preservation registeri=
ng
> hundreds of thousands of disjoint folios), scanning from index 0 on every
> insertion and isolation results in O(N^2) complexity, causing boot-time
> memory retrieval to take several minutes (~268s for 393k pages).
>=20
> Using binary search reduces the worst-case complexity to O(N log N)
> (and O(N) for sequential appends), cutting KHO memory retrieval time
> from ~268s to ~50ms.
>=20
> memblock_search() open codes the same binary search, so reimplement it on
> top of the new helper.
>=20
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918002239.4024=
231-1-tarunsahu@google.com?part=3D2


