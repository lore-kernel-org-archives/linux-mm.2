Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCC7CC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C75AB6B0096; Thu, 10 Sep 2026 10:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D246B0098; Thu, 10 Sep 2026 10:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62306B0099; Thu, 10 Sep 2026 10:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 960ED6B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:09:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0B3AA0582
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:09:26 +0000 (UTC)
X-FDA: 85198035132.06.BB90BB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id F2D1B40017
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:09:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjaE3rzW;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789049365;
	b=BfzPAfwyjXCI1TpRmM6AoUKgpE+tVOrtT/vcNqacHlbSXqapmMsmOsalBDKqM4/SvPuKik
	7pjYGz4meDozWaHblvtCZNT0cfEeQ2275nxX9Ch42Y78FVmOcuJRo22Fg03zKoQRFiHQ/T
	RFtJG7Vst5XSsakMu8i70/p9M53wCsM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjaE3rzW;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789049365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+TR1SI9WlTbYYCKxfXulyIGLAxEW6EjpI8Ciu8i5LN8=;
	b=QWovo0mTAMCr6KC93p9q949rVEIrw98LeTwwkF4tnzzR8+1HJyKX2TjLQdJbys2fT8vIud
	Gr4IK0qq++h6m/jOYTfM9YJRJlC2EoPS/99+fPlk6Tffit6nkuxDQq+1i/dPF3Ob/XaAs4
	oohb1/xNOvRzBWoT80K/kQtm7t7XPEg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8986D600CB
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402F71F00898
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049364;
	bh=+TR1SI9WlTbYYCKxfXulyIGLAxEW6EjpI8Ciu8i5LN8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mjaE3rzWO7cAvdi+EKMh6csE534Io9btmVmSOzmYfqu7Bx1bQ/z2V/S1ksi2tXvrt
	 5Rf/JMOtGpaKjYywJjBgaPYmUFXTIXUNsi4JZ8NznxaD4tb4YQPILzZB/wteFeBfoS
	 6MTUo+Zi9KRADh3I7KYlTH5xHi9cAK4lxZIJXiCju1FDhBh+1di+aus1A66FSbSudF
	 fLCx0z2w4uHc+MTYmuKkexgOnRflSg2bFJmoG1ut+lAELv8fke0Z7kRfngFbqmKO/G
	 WqnZjkRoqGZe/rksjICVIPiTWcUbOm5Tw8CAj6MYRY3PYmqmRsW8li2XBeJHGi3vBM
	 Yq99qfLj4dO6w==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c1c52d920b8so983701966b.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:09:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxEeTvK+3FKNj6t/BUY3dS65qa5JqjDetspwoDgUYUozoqPTtgNqBgLcds6hmAegbuqsqlJYzlmhg==@kvack.org
X-Gm-Message-State: AFuF++lPJWFQbeCKEADP8DAZ6IW1y3Fko5EVkELSpIZJHqi2/5/MJbfj
	+M756jtojinHpCmNNa2f9nb5i9lOImGJrMPBbDYafW59qjDhjs/mPtilPHw4iJvNBS/HH3LSBXx
	KKxxEL0TwK4OW5GbfudWdPq92d9vlkvk=
X-Received: by 2002:a17:907:7294:b0:c29:566f:531c with SMTP id
 a640c23a62f3a-c29566f5b38mr83551966b.31.1789049363181; Thu, 10 Sep 2026
 07:09:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260910123544.818146-1-wangkefeng.wang@huawei.com> <20260910123544.818146-4-wangkefeng.wang@huawei.com>
In-Reply-To: <20260910123544.818146-4-wangkefeng.wang@huawei.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 10 Sep 2026 07:09:11 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPj=uP2ZcDx8ycahjgkb3Dodo=ou4Ry2W5d_m_E6xL57Q@mail.gmail.com>
X-Gm-Features: AcwNN1VArvysjweyxF6anKXyNwn_HpHOpUsrbt-TuWPQXbxLudM6ULJuhFBwxgY
Message-ID: <CAO9r8zPj=uP2ZcDx8ycahjgkb3Dodo=ou4Ry2W5d_m_E6xL57Q@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mm: zswap: reuse zswap_invalidate() in zswap_store()
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Chengming Zhou <chengming.zhou@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F2D1B40017
X-Stat-Signature: m1sy7ybwsygedz36jmyrh6w4p9bqrjn7
X-HE-Tag: 1789049364-439207
X-HE-Meta: U2FsdGVkX1/lcFU78vQmFV0YrSSy4tLowOO+l/Xi+RYfw3Dh3GyaPX+e2/rOyjhgeVggXqvFxVH60bHMPMA6QdqEd1YBLZKs/MtPlcs/G0Dm1Xzaagbqi5F5IbaTNrZV1kEWslCmy6njp14soiKGB0g02hN/KDiHk6uo0uXvixvX16MszzV1ATVKyejBmzCgrUOoBpKjw2Qh9RuIouwDIrB6Of7x8A7IHTecWQbh2jhcv/pvyELyvHYmSfmOBTzAc2FDEGi8j7L4lyNVpZFDZftgKrtg77PfwrKUYWjvvuBQpw7jMSw+4X7RY07HCJoitOedhcbQ5Z8UNQ5QKb1GzBiuQSOkekvzrjYrZcYpEDWKKu+O2W2YfZBycjiS6bK2Sc/9yMu4MMFF7Rao3IBRrooYGpYltMDpnP7M6gUnSu0zox5iBCsUGPqFU+kMzwTULNHfc9Mx1/U8VwdU34Lib/0CiGJGLnLwKbT+H+aghCSHyk0GfTMKkXrnuoUHB/Yv8p4ea4ISGLj6lXh9k3/AoCVHUYJ2MqCZOVe7haggoAP3X5+lS5ZiWmWhctuWxVQU74gYyBCYy3yS5oCIy209gmJm17z23rhJjOonEnUbw+Manhu37rcbhmYoC60NWY/SLG0PieQAZ8OnedhNWd8ftTe1IoIc9JAYMMSwfXtlW79zr/TfhpLGnF9gnLnRGlvihYdFvxrneabAC6f8Edzw4FKQ+pmbd07G2I5dZXlGcJUy1NIXWryt94k/0eZ7v250EMmirYehs8jKXIbypfHG4f70/2BJHdPnSDkwyPUd+ITI8jfR7oiFUpECv3WfdlaiTyrU++yruFuAukzrw/T/fIuGT6HmuGdfHe6QW59Y6iFn1kHWCV4kGR0TLfkTXzrisRNufoOQX8WS8pQpEcKgNfGA7IUHzcg5lWvLZQPZGL7Tku84ng1+VqG44Nr1qnN2qRWvupK5uQqVK4tW1Ci
 JPKmA5Wa
 yAc24mJXsVDCtiYbTz9Vlf1bSMySEafa7pv+uaIaWjvscfHCP6mBphHL39ZKIzA7exjJuG1prpa+Nah47YtFpY5rmUM+uYELADwN+v84qZq3jopE6wwL/a8I8VwqNquzZAWAKKbW9FZ6WD5NFJ/Bh9IwOzh2nYEea2aFC7Ty/+qhyXscME9R+uvq7apoFIxhJXNKYyrFh1DekUFZZZMIBEPnAK9Ai6n8Pgvn08T6Ktf4FH1cHlTBMz0lfaD2sUxwo8oi0eDG0T/5GurnxFAGTNAcq3Um+DAVtsbqvsQ8u8Kcx8mAsNz3i0ENIirl0BrWC0XcWszuRsOtsGkUtNoboTTpeGh+v7B1ZTrY50KNp3OrJPDfwaAPf3TGtxrSNaJlSqjAemFHdN4C7AlAjkNVSBh1tEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 5:36=E2=80=AFAM Kefeng Wang <wangkefeng.wang@huawei=
.com> wrote:
>
> Reuse zswap_invalidate() in zswap_store() check_old path. Its
> zswap_never_enabled() and xa_empty() guards avoid redundant xarray
> lookups and deduplicate the per-slot free logic.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

