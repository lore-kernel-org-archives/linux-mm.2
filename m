Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBC301093176
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 01:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F11396B0088; Tue, 24 Mar 2026 21:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2846B0089; Tue, 24 Mar 2026 21:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1706B008A; Tue, 24 Mar 2026 21:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CAFBD6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:58:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 67C541605F6
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:58:24 +0000 (UTC)
X-FDA: 84582925728.13.6C3FCBD
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 67BEE18000C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:58:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b9N59Wj0;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774403902; a=rsa-sha256;
	cv=pass;
	b=adyJ/AnA7eprDgRZjIYxdvufNFbeDT1kBDI7/Zw/GN71kjGILtOMX5F7GniirVceTbPO8e
	+l/moClhjEZeRcOpQY/6gptu42PvbmGyzZpmTueNJEzjHJstlXy7iQD9PxbfWHQ8p+NtCF
	zdqns8sVLdz1PYi/1NAqKsx31vDGKUQ=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b9N59Wj0;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774403902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uATiCdJVNXsXbqp7wQweEzFd+VzHCHpWD2sO0E9ZBl0=;
	b=W8Q3fZM3IZxcoUopHPtWTFowTIkdRDS8SXGiuZ/63Jkl3iJj8VOSveKkdJqpbRygoBDcNO
	K1+DbYWdDbS5aOR7Hwy18kO+w0xluIcIEe07aZ5vaCfZbkC2QifE4vafC58lOfJXyW8N+r
	SCUOL61hAkcTTPHQGRtRqZ59MB3a4qY=
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2c0f4a65bfaso176107eec.0
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 18:58:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774403901; cv=none;
        d=google.com; s=arc-20240605;
        b=a0gALa2VSF7B7km23Vajeh/JPNiWGw3OAMmzypxmHcabB14BF/KuShkFZyUZXjNHXv
         wpGk50DXMhb33s4JAxHSN2iFfuCJq48bF2X3P/C3brJ6l/k2hi8J9JthzViWE00WwmTv
         lcX/7PBchwr/uukDZVHeHDV/Hi5r1Qc/6S7Wblx+XOq6t8jtB/Y+ZVL79TvhJxRjG07x
         gq8SIYLIsFJ021GakLrfIKVZ2waVunjscuuXIDCctELx0bEbyz3v9CH2BXbgzEEsfa+n
         r6ZoMo/kuR7Q4LrXce4WPh/jaTaQO1Q3sYMG2bjH4YcovqUdlgX1GQtWqNlbSf8jKoCP
         QCtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uATiCdJVNXsXbqp7wQweEzFd+VzHCHpWD2sO0E9ZBl0=;
        fh=ZlUw0nm2XptcVenXpZo3waUO7hPcyz/x0587GZ9NgLs=;
        b=liNuNDK9cZqoCVrcZyhMw0jWy/INhnmE2wW1GdX76MhrHY/LbvZUiOrPZOysn3nJDd
         J04aKo7IF7Ezoy0nB57s2GelzSh1WAkDAR7tEos6fHGARlziThozFYMsUey9Jyj3ceTW
         DFNLAxDybPHE3sX9HTH03v1UpkwlNYgGrP3iS1L8vLiZE2r3rSsZ9LX0TQXpJPqSjaOv
         qWrPi5u3SmiztMCbcaVOW+U1ZXncTVlqfFpDJKA6mFHyexP0vmm1IuNk07zEZjKUvXRt
         zSwyucIlfpfF9Pvf8UIufAevOt0DD9N8t1VpvSDVv3BZVIX4YK6veneTtegvy99UKEYK
         K2Cg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774403901; x=1775008701; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uATiCdJVNXsXbqp7wQweEzFd+VzHCHpWD2sO0E9ZBl0=;
        b=b9N59Wj0mhorztdkDyAEzFoTbwT7Z1lYEjonYWCJLxErhEJot8SukS9GpOZ0TnVDrM
         dDzNJ78hvI66DXFWdX4aaXgt1vZjyZl8fMKvPnTbVv7R3Wbb7DJElCS/AIUiXqnG0+R5
         Yhw2nOSjLjhIafoXyYkLQdWRU/3QEdyQ1r1ySzUMI928ifeqVzfZiQUZM+yDJ1okDsh1
         pgeGhWnfzSvFshSbi3xBL3KKymgrr3My/vo9dMGJkDk/sOD1+3bN8ffCQVYXl0w0mdNt
         c/SkEwoPS8BEa8DyhA7KKV/QphFxK5tg19tdCOcEx2zrzDA1z0aFF75dc6LgCTEAHJHo
         CJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774403901; x=1775008701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uATiCdJVNXsXbqp7wQweEzFd+VzHCHpWD2sO0E9ZBl0=;
        b=MSyX7r4ta0Cup6UxNYSEuqP//H+lWaC/yQtLFlmEofz5jUJsxzj9NkYR2uJYXm+aab
         GTwIarbqDRwnyQFgTMpk/SyfzuOZ0P7clku5dHLTCkKflMWZouyHyDk6Urige+wZSc2N
         o9KFvGNeewGIoE5D38ciMmlWw0Ul6LBLEwYx40Dizh36sO5wHDbJ0UQlJ6j6E2yLFCXg
         arpN1V3QUIzXq43AB7g8n7Ua8V8aO/4Trca7E6i6xNvcucxo056R2oYk2ERW18X8b/Ld
         YK/lPZ03jH2MjBR1hmiVsOQj3CGGkRfRQwOyCW5HutqBZTM1vgfJYlfMRL6GGauYTeQX
         mdIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmQjz5wexUWwysMXHY+h+209EnCRi3wj4Y5v5Mm9kvXrHlTbzvmjM9a4IQSy4wr5Mo8cjCsk4sZA==@kvack.org
X-Gm-Message-State: AOJu0YwUGYfdEtFQn1nm29YR6XFNcAz5TH71QB78h2hdBGPkZcw9U56C
	9+5x1eR9fsufizgJTQRJrd4P7v+IEBX/dVNs9x5skG9l3Zie91bu7XIr73Q8t9Jxq62n5T9TLYk
	n71wn21nRG53UBahWWtX7DsPdD/fbS4M=
X-Gm-Gg: ATEYQzwsf0S47KhQkv9nfsIEiWqAr31+xHWBbDw4TkwA+2+P2Xam9tw5b/Pz/R188Gw
	NUTL7TETPihf17EcsogFugO7G94UMV+aeg+HXu2PQICWhzqIeT88ZCHiDMRsKtW2WPH/IoCpqbq
	ENZdGILOMS5JNUN6M0pG67fkF1FmNYuuBimOYH9oOXdsxIQALGzzUBAoRRjuqLXF+42ntwar/I9
	4PHxq5Hh4AWGPJlt+RRGP29A1w1V5ChWRD5kt+3u74VNRqJRW6xKjzsmZhhh5C7Y+Ab0yg8s9vn
	ajAV5iSm4L9ZvhhEKi/hwG2oM8O1j72PAtvcLuUbmOTBVnwnO4FWa8sO9ZrZRNBasEbPQj/jdaj
	BgvSRwbLlVwUBG0yP14HKEtE=
X-Received: by 2002:a05:7300:dc10:b0:2be:298c:a11 with SMTP id
 5a478bee46e88-2c15d3a8a70mr394983eec.3.1774403900918; Tue, 24 Mar 2026
 18:58:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260322192159.88138-1-ojeda@kernel.org> <CGME20260322194701eucas1p1f72625f53e50806fa4f430550f291e76@eucas1p1.samsung.com>
 <20260322194616.89847-1-ojeda@kernel.org> <1c4e429b-f30c-42a9-8de1-71cb2cbbc114@samsung.com>
In-Reply-To: <1c4e429b-f30c-42a9-8de1-71cb2cbbc114@samsung.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 25 Mar 2026 02:58:08 +0100
X-Gm-Features: AQROBzAYV4sPQIbCVLLNfW-UqAw-p0H5kvr5leqfcWwqgBKVIhpQi6sU039YVRU
Message-ID: <CANiq72=UPiXc7JLracLeC6k45ToByJWZedp3B3j5=5mAnyKZmA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Danilo Krummrich <dakr@kernel.org>, Abdiel Janulgue <abdiel.janulgue@gmail.com>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Christoph Hellwig <hch@lst.de>, iommu@lists.linux.dev, driver-core@lists.linux.dev, 
	acourbot@nvidia.com, akpm@linux-foundation.org, aliceryhl@google.com, 
	anton.ivanov@cambridgegreys.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, david@davidgow.net, gary@garyguo.net, 
	johannes@sipsolutions.net, justinstitt@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-um@lists.infradead.org, linux@armlinux.org.uk, llvm@lists.linux.dev, 
	lossin@kernel.org, mark.rutland@arm.com, mmaurer@google.com, morbo@google.com, 
	nathan@kernel.org, nick.desaulniers+lkml@gmail.com, nicolas.schier@linux.dev, 
	nsc@kernel.org, peterz@infradead.org, richard@nod.at, 
	rust-for-linux@vger.kernel.org, tmgross@umich.edu, urezki@gmail.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 67BEE18000C
X-Stat-Signature: rhk411ycbbg4p364sq55t311nb81pqsw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774403902-357457
X-HE-Meta: U2FsdGVkX1+BVtP9qv0KqdxQLIBb/g7erKjW5itmFO6aC/+Y+0t8+d8mT+i5NzMYiQmFpc7XuKSUyJvTjBdprzO06Q14fu63dXv7htHp/Cjc9gyNpORT2D/Xj6XCPRekxswof+fG18wl4DoBOOkB1OcYMz2HU9n4aIepxsTf30zWxdhb3Id9psud6F/b2WY2cnKGr6QaC1uxSIJ6wKp6600pRo1PaOXMInLOsCDJQ8Ge6RojnnTPubQU76x+akh+nv1NOCH8Rmf/4F3r5/+hb4WunWDq4heZx+1DSJZ6rf6aVa4CrZm/TaSdGuJqIwepnCITFO+Dm6RA4XIouNrgTYOEVxI+JSD/pf9Y/DAJDJh5UAjGYepmCDgeiH4IBRvRp8JXHKb51NjZNnExivDsZRi2ssWsTOYuzL5V7uu08uAlTSmw6mhT7C7H+UgvNMJvnHV84rxWXM789iYe3ySgLrkzj8+VRW9EV76sLJsJfEtoabW/n5VIJ02T9hVJeBc4sBsLJI5eUBMkR8F7Qa3AFB7CS73qW9Obv/bE6X9+OED/a4Q8Hs6DUHdBu1dzhLqTgJ2BsD8ifYh3DZkTf0NxpRzYTjAz4EOOXld10ZAqc2KyngGb3G4y6vRCYEiqu/S/FaFfwxEUd729hWtxWlxvQBdCAMW9q+XLLqNM0efmL3vjz0T/kkrK/IWeNFSnLwg9Q8b67QudQp91elcsKvVmqDZ5GgU1LnXJBa4W8xCNK1Gb57nHSo+fa8q7vF17ya9rbh02ymKRvpHspnIPwiqC5oyWYwALJbvNgvxXbLH2Ws+YYPck8EJux7RrC3PudrQ4F/wb6IYcf0ZzeW6ziwHxCmGHsJ9bHqIksX9lCor5zb3H2VNPhypa/HbYvrfZSKoZTDlH8jR7bi9LVKUPgaXGhuHt5EDAGvfAOVgE+/VxyqKYtWCOf5DoUA4b01pE3ah4e7meGnPr8uO8RI4wrpW
 BgO30oPx
 TeoDwZCcWtc8IrtLUiyoG2g+ZyhlPT5GQdvKr3yWt5w4UyC4hshYFuFnq2ZovmD5SzwHjETtPIQXKeAszs27PAK8OlrAvRWybDDOa7ibUtgnuyqbb9kio6NkYwfXWFpFOgzx2KEzVeBrHy35uHEEE3Dzg/vTq+o1d1XrUu6rQDBN0kaNskfIdKr8xL+GzoPgvphHbBkS9W69RbYAPQApKF+ABhHNwf7em0dCc/3KR+WZFw13wlcV93eiha7+jUWyqp2AayvZmPN3OgEpWULt15LOUMHHOBIFsmm6fMVGaHPOXVgkROpW+T5SgxcVX+CVQc7ufG/x17Fr/CvgRp9aAWX6IL4ZqiEOUXM2nPpJ62itW5c6GBJJvIyIMOnTcj7InkodWH/5Kpt/Ki1Yh18E744bqD2SK907rBfXS9yTc0uTVR77Vi+ZKGaqrn2HUmF6ipzdQq3YKHEAgI36u0oVDSreasAncbM9H9hyWKO3DRZbbY2eNy1RXha9FDDI5x4h/AmveWXaHs1sJizJiUYveZfbiZ945np4xaWZ+Klu37yAAz+carIbgtPeJ+bN3RwuL4xjF8l6wBe4BRAU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 9:49=E2=80=AFAM Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
>
> Yes please, this looks like an oversight.

https://lore.kernel.org/rust-for-linux/20260325015548.70912-1-ojeda@kernel.=
org/

I hope that helps!

Cheers,
Miguel

