Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 724E6C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:45:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AA836B0088; Thu, 27 Aug 2026 07:45:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75B336B008A; Thu, 27 Aug 2026 07:45:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6267E6B008C; Thu, 27 Aug 2026 07:45:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 325806B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:45:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 93C87803E1
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:45:10 +0000 (UTC)
X-FDA: 85146868380.24.748C5C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C5C3B180006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:45:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W3pT0tiT;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787831108;
	b=Kbd8MBo29Cb2WvWyZ1IOt8foQYEvRkzscOO7ltVKR932P9r4jq1nnLJVn3F06VLqU8BREd
	uUnOVNq74Ge2N1WcQUbSQqwV04slo6C8bQbdHpxsJ2KFV695LG7NGLKsmPPvXj2nnsmO/N
	xb6JFNbn8e+Iq3ETM+ho7wPwS5qFboQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W3pT0tiT;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787831108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tl/MrtSWTP2YZYbhCAQl0DVDAuF9kj/Byi1DrzYz8OU=;
	b=R6QNhtl5P8uPKhj7PFHVMhZX9fxpQRqgQDG8ZOW2NEI96N2YQkh8NIBrIKBbo+mee3wK2V
	InZaRJIxHwJMkLjHeQ4hvNlHlbn4tYEMS7JcNfU+D0+bZaDJQTOUksMEWKthseNv0+I024
	jOzeONsiZvVlCBR/oTEpeGwbszQTz4E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 436BC600D3
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C851F00A3A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787831107;
	bh=tl/MrtSWTP2YZYbhCAQl0DVDAuF9kj/Byi1DrzYz8OU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=W3pT0tiTSMxISyoTXyhxq30y4oxeOoia7gRVqwoNPPIw0M0lfJvQbnazTQ3jYieAO
	 9XLKVjXh8iFjGdTPykLKuyODBXdHsLvOtLUvffsQ6kTtR8QzsuRyfb1tN3R4XNn9un
	 V6nO2ltpkAb3EmPzJsbtW1HKzqHLeZAMn43rEIaNQfEvN8RasDGc5SKezICAfSSJ9G
	 5eHp4Egz/TN8x2eIabAyuvrHgOYpeGlfvwMK5L7Qv5WryV2ulUeonnoh199iCvFisk
	 zK06cvTqKth3vvjklN36+E3UzcTciw8oN7TbHdF4zQnXIyLYK9R9BVkPv8vuRxsLXQ
	 436jVkC+OUApQ==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-930c0f9c1b1so102042285a.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:45:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoaDFsxI99pUEZKU+Zn0ddMsWe52jevV1fXAaLHefhp2A6cqDfSdmDZemBOT0okluGaMzxtnFt2Ow==@kvack.org
X-Gm-Message-State: AFuF++kDSlmFCGYOjgal+37MusY7Oiat0Xcwx3ppLnCNIKIJxo+sPJXW
	2MBGle00u/Utb6es0h4CgyGAAki4bs06EPOm2+KUmS9QnWqHar6PjZuwVV1oHEitGVkAIIKTBpJ
	Gr95sVUKtNwLh26L75JJBN2jXDqhsQWM=
X-Received: by 2002:a05:620a:4688:b0:92e:fc42:2c19 with SMTP id
 af79cd13be357-9378012ed0fmr1253366785a.11.1787831107251; Thu, 27 Aug 2026
 04:45:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260827082722.1809702-1-yuehaibing@huawei.com>
In-Reply-To: <20260827082722.1809702-1-yuehaibing@huawei.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 27 Aug 2026 19:44:55 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zEn3fn0qU8QZqs9ujcLWL4KPWd8os2CbEhmZ23wCC_bQ@mail.gmail.com>
X-Gm-Features: AcwNN1UEJWG47THBIyOeUsF3FWdr22GgPA-FTUeI3kQ5gT1BObP07Cd9-ND9oqk
Message-ID: <CAGsJ_4zEn3fn0qU8QZqs9ujcLWL4KPWd8os2CbEhmZ23wCC_bQ@mail.gmail.com>
Subject: Re: [PATCH -next] mm/swap: Remove unused declaration swapcache_clear()
To: Yue Haibing <yuehaibing@huawei.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C5C3B180006
X-Stat-Signature: 7699e9813ozi8amrwf5aq558jmi7aqiw
X-HE-Tag: 1787831108-145625
X-HE-Meta: U2FsdGVkX1+Ny5SSwFd0n818LSWyIHc9znnmeKcSoXukXl4DQgBdD/XCGLvaJv34/vYk8TB/OYeX5YqUOgUF+OB+ijnPshxrS3nGdlmh3Dq5rI44CcIFuKy9D13gwylzwY3alxWOR7j8e71kER/IMy0Ty1BEKZeUhbE0rfW2CSUQ56tVdYhd9swd7oI611yAEha2Dg+nBoXYsYdL0UDGKi7YqGwoicVb7tOAxUERVldjc5yIFTvUjiRzUinkv4GmdylCj8XDJ32XT6H2K9P1bXYsa4A18diED65/3+WIM8j2jxZ2mQbV6thnACtzS+og1DEWKWdYTs0VLRpkDziTQpPdCWhKs8P06cKXqMuUP2dBxk0q6JKldp8INyG5P8x6QQJE0bVHwIEKbHAvKMv0eCRrD91Qa7q/T/DFOz+2lDsp+RVf5cNo5OQz/1H93MQudhVhjUqGDrNoBtxcAB6WY7fHUydbnG3MjPfsfvR5jRFjhNkIfdaVVW7NV92N8UOQukv2477yb0U54gTnjlpg1glS/d4zoORd8p/rQ405GeoXExfAsUKJhjgOjR9pt1mEzu7Ljaz4K+Wnrv1fTDBrIX8fQ7xMdgWKKXK13jjC+rX5pKVNa3hkoZwZJw5BTaGb8i4yFd/9C50q1hcP1yw6sl9QtuveRE8eqvaGIuGT1mv6FjW8S/ZG0e1XuDomzcdgZDPuuu9zQgd1uFxwrZVIi7ajoW/qs0e1F+2VFMnprxPmM46/YGjZj8PFDVE1Ty8cVWy7yA8Jomdg5Dfm9gHqEaCj8vHwOmyxgHFIJO9c1e0Nx0mFvN2qJ6QZ/MwtcmuPhtYb8ApqkUcRR0Wx5jTi09Zy19S/y+GLtnR09+SY0aIP4BSDE3xqo1eGbs1k4TM9zC9H3W5dv49Gbwc0I/B2LDqztkhICOySUPxzmS9Xws3Vll79KMmVDf2ym+i6JLC96hyhYrLHbzQVE0yym6I
 kh0/Hd+j
 EbD1gklHbEDBOTYEyY0SCfv9e5FSb3tW2ENVvDX10NbVytAlywrOJv+OJLY6PtRwfR4nxy/P5wJ9RKXoSXXZx5x5+BlAxD/G21aRGoQgzFlmoDt4RCAKjPrtwWIHnv7qJij4I5inIEMJ6OurIGhdT+0kbzzWnP6yYYOXEYoCDFRA3a/8fbqAdaApG7ht3/R5lTJBOw5Q3HZTLVDBLUu7gAEeQ6+aXuYYX9+mq9pzbycAAXNLE3d3OT4F+LOVdUfAhb+K10muDtxTiABQI42V8FeOdMhyRRCwtCKoPvUF/4E+YKjdY6FeGbD6Y3d/5EO6bsz/Cw7GV7brlmqnUfy9IRfKAOdAn6kfkTifINdPHgIoMavar17BGsMiGrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 4:06=E2=80=AFPM Yue Haibing <yuehaibing@huawei.com>=
 wrote:
>
> Commit c246d236b18b ("mm/shmem: never bypass the swap cache for
> SWP_SYNCHRONOUS_IO") removed the implementations but leave this.
>
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>

Right!
Reviewed-by: Barry Song <baohua@kernel.org>

