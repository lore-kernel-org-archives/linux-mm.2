Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8200FD6AAF7
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D795C6B0088; Thu,  2 Apr 2026 14:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51F86B0089; Thu,  2 Apr 2026 14:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C67806B008A; Thu,  2 Apr 2026 14:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B9D9F6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:33:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66CDC1A08A3
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:33:01 +0000 (UTC)
X-FDA: 84614462562.25.CACA1D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8DA94A0002
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:32:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VClVWyHf;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775154779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i10a21LH5eRTVqCa3HKy+TYFoxTg7JY0pRK3bgffNpw=;
	b=iV7hAf80TwZIgTki2GinIqkZREKP8BtSi9LEIi9n5lmAz9TKjKCqmC0v2JvhISbNZ/F1kU
	4WN68cAxZWYFJjVEYIhPfflcU3krtJbh+srH4iWk1AqSwB++Wjd6WsWl02psv+QluhRItB
	SXZz43kYimNt/MXl3aXwNqtpWld3BPU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VClVWyHf;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775154779; a=rsa-sha256;
	cv=none;
	b=7kpuQAglf+sOaSFqcdAItm7iC/SSW0IVNpzzwbOc1+GMBv1Li52qDmvuj98icrwbLeuMwe
	SvsAug65sp19UqUMj7wv69tKz/Nq0vuKAX0pi0xky5FLyDAIL1MnxoIyXouhTJK+44mZF5
	7xx1VHFg9Wc2vOzQoYXe1/woo3sVcec=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E5253600C4
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2AFC2BC9E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775154778;
	bh=i10a21LH5eRTVqCa3HKy+TYFoxTg7JY0pRK3bgffNpw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VClVWyHfA9T/Q7wuSquxatkIqKvvhD9M5WmFmrIMCg907CtCiI2L79CmCgxi4Tv44
	 Soopr1xdksaxsn7WrhLMNKaf2r2rMT945v9XTkS+F+nIsnEqrtmw3F5y3ROyey90Io
	 N867GkdDupTOfNZroNj0A3VdP79fmNRDhqNtlO7D6wRlBm9IZK3XPRvZ+QPOd2pckT
	 kxdtSPwK5IRsRFpa1Und9OT1zPxYAr/1IJthvo9UxirfGRBMHPPrzMUpCiSLcei/7Z
	 YYChXTrSYXxeix+3X6yyFWjbQDQmZVVoDeJYmQX8Rp69/S1tmwS743WISln7rQ1sff
	 akOnRK0+rBouw==
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-6501547d7edso1276633d50.0
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 11:32:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXTPDGtkRL9iM13NDKYt10cnfIe27T/4P+hZcu28Mh/gY5q6ph31sR7dNy0ECNxMxENuLDe8p0XfA==@kvack.org
X-Gm-Message-State: AOJu0YxntczmKyytlQzFAF0UGzIufxjjEVigWAHD7+/fQHmqSCbELaLE
	1dDewtqwf0o7BbTzHeJfmLaVFQtNtDUvLmpds+07weX1V4CjCCkZL8DWpPPcshpSFQhvIz9woZb
	GJtmRNTFHGdJwKbOo//1lt+BSK/w3AuMAOzDzq7Ssfw==
X-Received: by 2002:a05:690e:169e:b0:650:1bff:6045 with SMTP id
 956f58d0204a3-6502fe618c6mr7787533d50.54.1775154772918; Thu, 02 Apr 2026
 11:32:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260402072650.48811-1-devnexen@gmail.com>
In-Reply-To: <20260402072650.48811-1-devnexen@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 2 Apr 2026 11:32:41 -0700
X-Gmail-Original-Message-ID: <CACePvbVyQTZfwiFSc6RmSm0w9YoMMg=andZo1Y8NevEhemuUtQ@mail.gmail.com>
X-Gm-Features: AQROBzB0r67-lBX9AnsoQWjFUl1dHSxK4qL8qvXI9NZ9sxvq8jmWZdAJt0vdsGw
Message-ID: <CACePvbVyQTZfwiFSc6RmSm0w9YoMMg=andZo1Y8NevEhemuUtQ@mail.gmail.com>
Subject: Re: [PATCH v5] mm/page_io: rename swap_iocb fields for clarity
To: David Carlier <devnexen@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>, NeilBrown <neil@brown.name>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: nf71ii1ojeudm7zgu34z9pzc5cw1myxz
X-Rspamd-Queue-Id: 8DA94A0002
X-Rspamd-Server: rspam09
X-HE-Tag: 1775154779-527341
X-HE-Meta: U2FsdGVkX1+prdiFwnUeLgfyKdFPqSLtSPu+7mJmft46xsK8jgTmoEpLHPWA1ko8l+mYlQkwrjNzm2vwUmUqsbeCJaYa2wTxeMiUSL1RTU3P2v4po5Ow5cdnwLrOwO1kuT9oDGCJRe61tmijDz9SNMUlvpfz0UqPbzl2YeGh/fMGxOoimaA3/CYPhjBhGvqw1qRtV33lBG6IVpIWyYQGS/38b3AormY38SPRd31Kkkl5anFh1GnkBwUE+pat+PZ6sSS41tKSnG34VYoHkF5HPyeD6C9ZmON7KcQo6aFlSqnVC/xrmkl2qABIMKf3uQpvPrraawPaA9oWhUONDreDa8qEsJstVbioFcWsAFWTU+9gpaBhEx4I9/eoIrepGbSGOOM3mbmJJWAwUZ33k0SpJIwSBdsDVAdBj28Y0cGh20wh5JiK6AeTGcFMqztNIhvB/EGoc5QRMp6R7f737emUJdjQzxzD0G6OPdleWunFieS0o6DmO18kC0EmtfOy7VjeTVeGTT2MQkVZZYcDWawhZl+KVmazMo6B9wYseQI+FE2/nZMBdW4lhAXFfnMoO/KAS3GIKDFj89ip2LGnnAa8/oLeFn5wlIuP+LG0gya8D6GCXaqXxMwPviDFrs/qVY8MjOlM3fTvTuuKK8e9SaQsKT/h0UzYn7MpsdKm2CT2BLOBspSFgtGh3MCmoj0f8lKyb5ivuGecGWt4Jl4qUjObUOAcGhMsR4+nVdLxWP1G0N4GN2V/X6eQx0Gok9zFNfIhDOgfGnwlXrJodjlBpeCLfwaRum9x/DvB96NFpgF17WQAG/eEw7QcWPipJjItKNxo2EVRKjhJQlY9j+QqNXG27UZcqOnkzDrAf0qbq/CncYRH8tOgrV5M/10aFuovEq4Y1qcOyTmzi5rQY1rbzwrMs+vnVjZFglt4fmgq6L4gc/3V8cKBRHIsQGmgJx+yyOChrf83lBFcrUMzAylyZI7
 cwbfR56z
 pBp/YcWbhvxbnYjz+YJ139gjDU/VQK19QWUrYAsbACh/iXcvhiNxQDempacVLB6/UCf86NGGFnlLdvtlGiO8oStY7zfXll0ND2NKUaMGBdmPabt7ugDUsDOs+ZXOE68QG/EUp2IJbB/6OWU/xUOmhHiF7B7nbDqAXsr4DdA9nE74rpyYxrJkMTf5MY2QeB1dyYJjh89YZhDVMjTnzQ0e95vfSzYcQ6pvWFDDxcsweMyckdZkVuChOcTXNCKOWy+NdBRlpWHd+VpIyusqhOFif/43+cuhZZbip52QARDrQOUcky6VN+ki0q2py6lOrzre2AXcd3It2Zq24q9xZbvt+h6qLCwGdSytkvHdN6detU3KBP6deTS85kLGSsZmZft6Ch6NUOFrXDmt+ogvn6VOKTVfkiRiTUSN4oCS/f99AYpRvDF4xrxSHQf6wcwZxbgfTwy3GXFdAFcuyEDo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 2, 2026 at 12:27=E2=80=AFAM David Carlier <devnexen@gmail.com> =
wrote:
>
> swap_iocb->pages tracks the number of bvec entries (folios), not base
> pages. Rename the array from bvec to bvecs and the counter from pages
> to nr_bvecs to accurately reflect their purpose.
>
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Carlier <devnexen@gmail.com>
Thank you.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

