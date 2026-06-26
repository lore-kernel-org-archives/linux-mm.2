Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9A8ACDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 03:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D020B6B00CD; Thu, 25 Jun 2026 23:50:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD9A76B00CE; Thu, 25 Jun 2026 23:50:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEEED6B00CF; Thu, 25 Jun 2026 23:50:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C0CA6B00CD
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 23:50:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2570D1C2732
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:50:07 +0000 (UTC)
X-FDA: 84920685654.05.83585F2
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id 08F8D40010
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:50:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hOg3vx6x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782445805;
	b=hz2eZ1za5T18w5tL+/EtWDhMPUzCaehvarvj6NjjY1m/flkdCp40+Z2f2P6XD/Xo59QiIP
	7M885T87KASjyhzV86X+ryr3UQQc4Q55q7CrhnPYi9mmkvh3KwyqA7CkJEU+lNwaXapVwN
	W2FyAdf6zSxel3YqdkbdeUbYIxls/9Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782445805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AEwCP01McVKkFzs5YSXKWYRkZR0LtHlb/C4tjHs60HU=;
	b=wUBbtxY9j4nTtXJU4kQYPxJS2ok5vhSlGhaoAZdpZwxPdkC6GMMh5nf/XdaFZ3ai6Y7d8X
	Q6IwHwvxLykSZgn9Po3qm6vfcU9EQkTNcNfiu2nsvz/6tC11OdTiOYVm4rU/qmyKR9g+2o
	/TqpuQFEDHwEunTI0uR3J+V9S9ADUfk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hOg3vx6x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782445803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AEwCP01McVKkFzs5YSXKWYRkZR0LtHlb/C4tjHs60HU=;
	b=hOg3vx6xYD5XyIJ+WJ/sCCoGoBDrcAq6WxNmMTei3tyeQ50pt7z9DLMlID0PiwESQ65zVR
	l5fKf5tnZtNDXMx2tjHNvVRuCABmKJ5Ft9OXBttwdBtZaF3eA7SD9EVObVaEvzROubayWH
	iIRBjQ5GbnNa3evdT/lRRVj0wys+kXA=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 1/1] mm/shrinker: add NULL checks after rcu_dereference()
 in shrinker bit functions
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <6l2gs76zo6zf-6l2n5wa2xbvg@nsmail8.2--kylin--1>
Date: Fri, 26 Jun 2026 11:49:13 +0800
Cc: fffsqian <fffsqian@163.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <305C42A2-1359-4998-A95C-49998B4660DB@linux.dev>
References: <923f391a-d760-4d78-92d4-2e765aa226f3@linux.dev>
 <6l2gs76zo6zf-6l2n5wa2xbvg@nsmail8.2--kylin--1>
To: =?utf-8?B?5YKF5riF54i9?= <fuqingshuang@kylinos.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 08F8D40010
X-Rspam-User: 
X-Stat-Signature: onmiwkk1iorhcihnwntn3o7sihg8whtm
X-HE-Tag: 1782445804-435492
X-HE-Meta: U2FsdGVkX1/SFDksTkNNkwsbeLiMkHnRfhsAngv8MRzwyq4PgG+nLtqxzuLQE0WqYlXQE9YFN0T7bTZIYQSCiZzdEACwDSHgt2QEtP35hNWXE+8ofpvuU15QCdGLRhtbb9BI9sMYonruBkBFYvJpngoTVHG0dV2Iq2xYV8ehXBxOMXpWCZEc/dLPB+SZ/czm8zq6cIwdD45KS6qhkQOTvnNo6dWV/Ol99t6v5+hcyfw9VAKEvXUrHNCj70RgFKlGeKyR1x9d6DRezdNzXVKPBN9TAQmqIcuaktoM/aHI+KEcRJXGtd+6hPoJVqRiYAb3xvKXE9Ie+fcziKS05u4A6WJ+BQNoktKnS0HrM+qzfgqIvgfU3vdTTFYKUPzC4ldXerYoa4tGLu0YcQgjSVSiIOBetezfPhT1UGdlaHchVmDZCV4SJu3um+nUnl5AeSDFS4N1R7M9Iu5uK14fmnwYZxfO8nl4zj66e/SG8UDCQYx0/0ZDKOmLLpqcYos9if48R2BF851P1Ek9LK0Fd1FHE4cycSjbfY/Uf7Q+wJvnrxrBH6SKuDZvjSezfL0MZkfRqddhJpa8D9jlvAFjYKewrbpGkHCsbxkMA9qMyTOFjzlg7R01Ood4euFhkuutkwjjV9t4o0CxYxSlf1QeaVopgzomQOQ8KqQ7S0PJveuoQXhaOla2PjHaRoXuJIdKhHXfgjV0HbkomW3UUWqK1iICQhZ2Zx9pl1S0AvVz2Klg/iVRbAAMBvjrTKwRmUtxIc1JmsddXB78GckpVWQwEcLx+MK3edsZcnlhPK9KMKD1D8Jd9u+FHHMytaP0Ro7DeRe1jfVFB32ru5b9thUkIFsiEjFt/bRCyiqIMCOMA3gINWXa76KAXkl8lGujo4bMPupK8UCJ45se/5P2ZC/tf45RB9RpZXnrpb/WmPFK3rmXFDaUUR8WOWn0HiSRJ+TFnngFwhwDX78YRdFMwVC23mR
 9cmaspwb
 byeGl84ew8GwyUhW6LKoUtUYc3foqq9Wf6fABJgWHHf/lxBrdr+bJ8WnQucFjfNUTp9b27/4JH4ChOuDARbFgyB8Ch+xhQ34yOsgucrgaifcaoF/Bwashr/bG+ScVODPyWF5j8ZYKxlSb/vsxAtLeWv6dekzJBV3OgZMkO9Szqq9CDgL7x7Sqwa531SY3Z7c8XuayiCd069Xtw8BEdPmIcae9dSvqUXof2Mm8CRbIUMuFVrH+W2JjhDLtXu0nuDTsLK7InQWa7pWzRzRBfmUUUcsIMYsN1wMhnnId
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 25, 2026, at 11:01, =E5=82=85=E6=B8=85=E7=88=BD =
<fuqingshuang@kylinos.cn> wrote:
>=20
> Hi Qi,=20
> =20
> Thank you very much for your detailed analysis and patient =
explanation.=20
> I fully understand your point that the existing caller constraints =
guarantee shrinker_info cannot be NULL here, and this NULL check is =
unnecessary defensive code.

Thanks for your contribution! I have a couple of quick suggestions to
help things go smoother:

- Please take a closer look at our community communication guidelines,
  as we rely on plain-text-based replies here.

- For any issues you're not completely sure about, it would be awesome
  if you could run a quick validation yourself before sending out a =
patch.
  Maintainers' time is quite limited, so this helps everyone save a lot
  of energy and speeds up the review process.

Thanks for understanding, and looking forward to your next patch!

Thanks,
Muchun


