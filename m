Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BC201112242
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 23:43:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35C8B6B0088; Wed,  1 Apr 2026 19:43:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30E0E6B0089; Wed,  1 Apr 2026 19:43:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223966B008A; Wed,  1 Apr 2026 19:43:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10F6B6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:43:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B611F1B6BD4
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:43:25 +0000 (UTC)
X-FDA: 84611615970.23.A4B2E98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id B4829A0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:43:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IyesMWUM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775087003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cwufF7ksYwUn+duP8lma9/7dH11oCcCvcaDl9tsS8iM=;
	b=lW6LKeCvBUZQOfyTa0vTgVpQdNmy9XrBnVV8dBljnNHpoP62pHcUyvz6nj1yJyYBo1dKjS
	39TmIlNy90jlpYmOBOzcf4IqWy+ugFA9HjWmhTUTPH91ms+3R5E73jHhF6lOq3hTaQLSnJ
	ezdJ7/jWnd/jt8XN4V29RYxIUe1Mh48=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775087003; a=rsa-sha256;
	cv=none;
	b=XEsTS5Y23s8yCP7ttXaki5EJeWWQ8vKemM6YoKLb5JBjfGy/telfIGY26T8RW8cfJ3P+dQ
	QdKAmnaXbk+6lSYuxST/zD0AzMJuISFWs2n5QIRYY/UFtFFFmZTYVoxLdnB+wMnCr+J3Xa
	GQnVR8kFVR5BLpLF1+iS2qwfRmT/PZE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IyesMWUM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6864F44425
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49375C2BCB4
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775087002;
	bh=cwufF7ksYwUn+duP8lma9/7dH11oCcCvcaDl9tsS8iM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IyesMWUMQNHKoV0gPcD43/xqAXfmn6HmZXVEXUAAfBbBUffDBDd517M0qBMic/6sQ
	 CU2LbCu/8c2R9sQgKbFx6SLywyxyQcTex8qQbsEv4xZq9WbS76roYmpE4YcrXDy3BM
	 +YdoWSlaFobpgQtMWEpQwFaEAN0rCB8JNUnJAs+k0X0Y8A4R+Uc35Mo9Rvv+H0YEs5
	 /Xw7Ik8rXUzUXs4uP2Zya2c1Yoovlr1L7FBoLw46XdX5an4eUVkAjpB0JzyxZYpxyz
	 AknIdkUegw8BA1u4oeU/j9FgI/8W0Ii0015JZX3tK+5VaMMliqHtHPoUIYzZhQxcDf
	 5QdyNwggRSK5g==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8a3970f1a0eso3962756d6.2
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 16:43:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVRdcRu98gO5uxr175eM/XEzwSf1Yw9DLgRSRscystJvXdtTABwEvvkdKkVxl51HVvfv2/10LbDew==@kvack.org
X-Gm-Message-State: AOJu0Yz9IM4LF5Eb499jP0sLI3pwwGaHZ7H6Br1MRTa7cA+AO0EJ8zeJ
	CDayzX5r/PZ6YkBA2CYghCSm7ccqbkSOfHQZBgeasNy/MiHuyMcG68OZ7pV5LFmiiASdGh9jzpI
	jjdNptwzR7GHy1XoLUotAIXAoshKzSbY=
X-Received: by 2002:a05:6214:6104:b0:8a3:fd22:9fe1 with SMTP id
 6a1803df08f44-8a5a0032f3emr20815766d6.30.1775087001531; Wed, 01 Apr 2026
 16:43:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260330071229.14614-1-devnexen@gmail.com> <20260401074753.238053-1-devnexen@gmail.com>
In-Reply-To: <20260401074753.238053-1-devnexen@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 2 Apr 2026 07:43:09 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xbz62bSVggPdwrELBphto2ZX=OViw2o=ighdY9JhJ_bg@mail.gmail.com>
X-Gm-Features: AQROBzDnTuVs6Y1sWlh9Xc9UQNNPswEckuzNbieLSEEdLqbZV48sYma910heOY0
Message-ID: <CAGsJ_4xbz62bSVggPdwrELBphto2ZX=OViw2o=ighdY9JhJ_bg@mail.gmail.com>
Subject: Re: [PATCH v3] mm/page_io: use sio->len for PSWPIN accounting in sio_read_complete()
To: David Carlier <devnexen@gmail.com>
Cc: Kairui Song <kasong@tencent.com>, David Hildenbrand <david@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>, NeilBrown <neil@brown.name>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B4829A0005
X-Stat-Signature: jyufsbzofoi16xqrhs4ry8gz15d1seuk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775087003-297702
X-HE-Meta: U2FsdGVkX1/VoomSEBw5bMicsRXCyvyqgV8fqFztXoq/fx01kUkZWXYQUapTz7Zzp3dRHlrWgfeXE/SVGSaK8BY02LrlZ2OMojWhUHLP+t4aTwJXjsxGR8aS4P9baxjWOYu9x0h9XNR05ca6ezQYY33l3+z0mfZdaj8VwREqeFrEXD5eVmthQjNOAgC8S8NfO0AIRlYv7/pf8FzIeZsL/1t2c2Jwi3N1HivYEX0Eh7gL5FK6E7Ck2ShO0SWGGue9x592tdk6DbgOENXs3aMkL3YTHWTdFcVlDDAiKPUZAq7yAi10ck3la+LLbOqeiyRQOfHZwVkAPZsGZMYb+kFr0M7btE2SlJxrBUxZNHrxs0r2gYSwsuc6jHG1VKEYDhPU7/t1D0CDikRfEjJBaelatGKGfSwh6NEjIB2vsAxnG1fLPzvakqlE8jrjnob3wiZdE5lcCVeOA/RbIUWbmkL0L2pHWfSdl0m0u/gYlMW067kL5Uu+hPCRUdesB8O4CIRjlSEkSaV1HUIkgk3l2pay4F6m1kXN+CY5ymUqNS8eITqi1NREOMbBeABzEzrR6JrnQqZyNnGkiaNHkMMY6T5KMQr+f2LkHXsNPCrEh9A+JVlTvDKdfYiz2aBkPzONG5f01IHYo+Z41TWgkbJx/4D7XxQKevohef3mbO7pnfyVqoCb55e8zzQ/jFa9qjcPrl7SQ4L1iKWofJK/I2DCvwjy7wg+gGMJnj3qyo1L457HoXbbeLEopH3Ju8ON8vXKChQ1+tkCdInpf/Q+Nj9LpxbdIN7wXfMJnzyXTnPZQQ9WfJ6izXvug7ubvLTizUy9IRsGv2OB3eRcm8ynjJ0AI4KH4iBeRXDJFyf+dAV8BV4JWJAutCnJt+9uz2ww9U92oQ/ugx31sHV9DTS3ijeX8F8Tv7hmFlrxFxgYGuBJ58E+vSxRZs1JrtAsjsfwc3Bd34Xs40UM3kG4JisCiRea4M9
 ddmKCHMt
 gK9jP5Ef5uDp5uJlZ9wDif3oOkAraK2SVn3gLB5O1XAdK50SlNmOmI9JfC/agT3gj8heKWOt6FUdTcvkSKnxkdzes7zGYsu65WT0fyz53wTttBWn/p5oXfQvDPcrAZqmYou1Upg7pWiLjGM7qUsa4F9nqWWiR+/UXHJZkpawL3Sr4dZzqETUfkPPAmJGeAylx2gQTfGgGIViWyMhRIdkVFkPkzPJK/dDUtz79Ea7foqlEFW5RJVoyYFscr8383l5XId85UuOHtpLWGmoXdPMTdKxOR1nh6ChMXgTw0X38Tc8nZVfNAgMZAo7yZqgOPL25ad7HfcntrTPsvAIPFWjYa0J72mkdVR20Tzmr1slkrthYIZy5lyOf2zWUi4IXn6tIquQ/F6dt1ztUiYLiC6pNY26ZCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 1, 2026 at 3:47=E2=80=AFPM David Carlier <devnexen@gmail.com> w=
rote:
>
> sio_read_complete() uses sio->pages to account global PSWPIN vm events,
> but sio->pages tracks the number of bvec entries (folios), not base
> pages.
>
> While large folios cannot currently reach this path (SWP_FS_OPS and
> SWP_SYNCHRONOUS_IO are mutually exclusive, and mTHP swap-in allocation
> is gated on SWP_SYNCHRONOUS_IO), the accounting is semantically
> inconsistent with the per-memcg path which correctly uses
> folio_nr_pages().
>
> Use sio->len >> PAGE_SHIFT instead, which gives the correct base page
> count since sio->len is accumulated via folio_size(folio).
>
> Signed-off-by: David Carlier <devnexen@gmail.com>

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

