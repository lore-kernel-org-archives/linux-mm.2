Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FF8ECDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 00:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DF8F6B008C; Tue, 23 Jun 2026 20:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18FFF6B0092; Tue, 23 Jun 2026 20:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6CF6B0093; Tue, 23 Jun 2026 20:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CDD546B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:19:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23671C063F
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 00:19:30 +0000 (UTC)
X-FDA: 84912897300.14.A772837
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 939B01C0002
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 00:19:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WN6LjFO/";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782260368;
	b=ZcMIq+Oo4R8NyvfeuHXu/RhMm5N8c1xVnaH1f0maWc1xLQMieVaubvEMn6j/BS9kyDDe83
	ODBaEcLnWQIF4+igEZs6Gxl+MG5BlIAv6oASZQ1GDYyJh0DibD06vt+1GOPpRfXjS+yMtX
	PfmOVZ4UxTUgBrlWxp/XkbBbdnniLfU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782260368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCzkIn1Rve748otyKAzYdv6wrefG3cqLC7ZgTsMh0Ww=;
	b=cAa8FUwjgmcnRWyVt6nJqeoBWHMrfSYAB1naWUUoceqfRMoLhKMjEFlBup1ttXPZgmlYWV
	B56YsvfRt+Vb4B63EckYSwDoqlaxmvSXVnCufTcA81VRoiUu9DFvTE3U2VyhrhpTIfy1T/
	CfJYSXNJwSoilQsngCXh87ax7SmrMa4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WN6LjFO/";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 861F541800;
	Wed, 24 Jun 2026 00:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1106A1F000E9;
	Wed, 24 Jun 2026 00:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782260367;
	bh=mCzkIn1Rve748otyKAzYdv6wrefG3cqLC7ZgTsMh0Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WN6LjFO/uhwj0LRfTYUzHdjaYyyTAvL4aMYJkh0qS7/Xc8YUEYTi/HueS7SkS62ah
	 EeRod9UUp0EshEhszB7Dk/oyI/6xaa0+sGLI+vBbF++NoPCda8pbVOjOkH2keKD7vl
	 Y9icHJSXQasKI33yLb8BmvBsckMVCO9boZ4JseLTi2KyswJZIzB5TeMVi/PmUjDYm3
	 pZXeuswBMKX7jVINHZyICWYvr06UoONIrhwF/DBlydtcLnpiqr+qUVjkojbLRcKQx8
	 Qy4uRUod1cdB6Di32YKd69abaIYRE0dpkzwZfrp+yR1gZGyd5u06uhAmKNVjjFrMgZ
	 Wzt52tzI/+pSg==
From: SeongJae Park <sj@kernel.org>
To: Igor Putko <igorpetindev@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/kasan: remove redundant initialization for kasan_flag_write_only
Date: Tue, 23 Jun 2026 17:19:11 -0700
Message-ID: <20260624001911.77632-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623114743.4565-2-igorpetindev@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 939B01C0002
X-Rspam-User: 
X-Stat-Signature: 4edsby5iftsgougtrgcrz1kpbwwrchct
X-HE-Tag: 1782260368-403322
X-HE-Meta: U2FsdGVkX185QnWeEKrzzi6sSzGBkr9cMz30b5JXAT56XDVlJ3Qo3YoYtvKS+Kyt8067Ghl29aW5efpJcvnz9nAJIbCm7Owb2F2r4XtZpaUcwlFXzvTyyWNXE9Kveol48L0ajF3xebbAmit3r+bkulU/ASKVVIqy3iam7nOaumPbY60yS6Zhc4757Z8dQtIiq5fgfmtXqWV+BnSQz7a6gGGKaVJpcVv6VUv/tfmm//IBPOWeoNeI1y10tpIvY5r+4sPCKRCrWpzbw3cX13LjhvqvFFHnz5bINAUmzBQa2dEfx/fBq2LqcLaaR69ME7ku3sLOLcFzwQ3OlwLm2Q2bMe1LSkuvLIgKNvnuTBKPUxXom4IuBfxyTiXyhqp70mOCovwNH358kiuFaU6njvNN4bVRqX7pngHQCdwdoSYKhdW1UNumQ9E0mKA6tTMdUMmffWcKQEAXo46u0fZRUTxne/1XbH+BwmiJOmbp/I+hII5IeYXIYzj7fs+BYBHKpBtr6kwAGH9ovZ1CqRczsyRA5RHvkIlolx6qT+xtZiZfFiUl1wP8us91+IydzP/ebKh7jI9xIejEZYrATsnYrIzrRAjaqcVSLUe5G9E31idR/VWdcbZt8l9PM6bSBTJyADUiBxpjfuHNbzcB0zIfA5s+tAALgGLKzjZo4XelCGKvSTYAU3zJZscLo4ixCqcS8o4dIiCFkQbo+G0L7VSJULoGycrCHp04PUTH06TqTilSQfuB9GjWCH89/Gw4PW/a1Efe2bJ8FLIz1UPzW8WqLbs4O9xsIzW7aRzne2XVeHpR1PhFmpfNAnjNjpKB0nfo83gCgWSCowDtrnKAxOA6q+GyfN22gCA33xt5zD3UPnwwsZjOXuQudbCbA6GnJV+FmSqDXQq55X1svaY/OM77zLclHSYJV404qSl0g4nlnx464QDoar2UlRXNrNIVV8ya46OA3+BS4A78NxwXMMCTNvC
 kNRMFus9
 kSS9iuJBoj3eopOyJ3P4M7Nh0GX8H/bjD+XRXRtElYTFOqWr41lNDWf4nZImsyU9WjE5BVKOhSh5beaKdJoY8enWZ5AmVgtH87phT1Lo7GVPl17XKuXrl4E+F1Q0Zc9rxY7NwuAWe0i4AxgK0Onqt2ykcrH7JYtWOPLci6Rj7r5Nz5i/Q9SFINesovGS6TSaPq/zf193kivqUTq5pd1My97ocspYcHb/OkLKdbakw3v8pdsotCMB5g7FwExKxCJ2nn1UXVIwOf8HFwEVYoFaBcgVGYcsziyknkCrj6SU6kdIPVctgn3mpMinb5DJIvTu2uyM6pyah3bdKiG/eEK3wjMztAztHWp8mfPZvbyOUK2HoAVxByL4gAIqE6wRM+Fxvm/YD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 14:47:42 +0300 Igor Putko <igorpetindev@gmail.com> wrote:

> The static variable 'kasan_flag_write_only' is implicitly initialized
> to false. Remove the explicit initialization to follow the Linux
> kernel coding style.
> 
> Signed-off-by: Igor Putko <igorpetindev@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

