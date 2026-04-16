Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB40BF433DD
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 03:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2097A6B0005; Wed, 15 Apr 2026 23:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0C26B0089; Wed, 15 Apr 2026 23:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11F0D6B008A; Wed, 15 Apr 2026 23:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 050186B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 23:18:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 99DE4160700
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:18:39 +0000 (UTC)
X-FDA: 84662961558.05.BBA15E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id CE8D2C0003
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:18:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CUnVYvlz;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776309517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g++/TzLSngXqnQuvfhZftdLquLr5oh8XV2a7B3GO9D0=;
	b=l8ziYw42HTQU7Nvidgd1TUWc507JiDjcIs64G2rJvk2rD/OgtUG3yGntU43WTBco4ww1iw
	U9UrSeLVhsn4Pm2MBRJ2NAIBuXElSHv9tH0P/ch+oT35DHm5Bi7T92oggqdZRrpM6BjIsM
	js1ZkLl+crihreqTEhbgSE/fC7q6loE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CUnVYvlz;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776309517; a=rsa-sha256;
	cv=none;
	b=mRGRDpKnFJfDlAlR87RRIPbJ+4CgxUykHTvHY4FLhOThszGVazi0cozQ6TheTTrsyUNqkl
	RRg7DV6F780MeKfO4/Iwl3sCA2VEWbyP1nCM66+KbkFxl/YxTiECB4qiVK5Vvl0beVsvHp
	qe83utL4zLsUft7BzDFZasUtgDPnEEo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 27FB160123
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DEEC2BCB4
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776309516;
	bh=g++/TzLSngXqnQuvfhZftdLquLr5oh8XV2a7B3GO9D0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CUnVYvlzdgo8AWD5DKcpsov6pdvWGA+eTe9v3MwsSNDKEiKz5utGde5Kr1VFg83Fw
	 DRsHyFKQ2jNqsEfzKNCIRuVSte5WIZfrtTaUPOkQZFdGXaqEskoJFMxXlGa0BzFJEP
	 K5UjbKTJYJouTM8WEsJ6Iyv8589+4QfBntPG2wzBNsettwC3i7NBeufyp/qhVYI3kU
	 xrGaLzcDhpfxofRwm/lLm49fmfzYTKxvRMsVHqsViivGbLh2hZd9oPcICzA457qzZe
	 OU92WnIPBFZT11sHBN7KXSxSaPZRva/XSpLOU0jZp3LufHQD/OD+2PPXbIfvnyOhgj
	 88bKctWK1sntg==
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-650775f427eso7824515d50.2
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 20:18:36 -0700 (PDT)
X-Gm-Message-State: AOJu0YxnPw/BSyAn/TvfcTYbHk2Wg7V5tIEEPlmqODdYn0ME/V8UMbIU
	iPiD8Yw++W3AxfozdA5vyRK6/tjmsSFGqkV5c8AbH7XVTg1Ot0q6EzqZJOER0QVoDnrPyQXH4jf
	bSH9HCV30da5PJlfJfbE77lB2fujG/EJkSWcH6afzIw==
X-Received: by 2002:a53:ac88:0:b0:651:bdff:daef with SMTP id
 956f58d0204a3-651bdffe9f9mr16710813d50.19.1776309516234; Wed, 15 Apr 2026
 20:18:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260415085658.993859-1-baoquan.he@linux.dev> <20260415085658.993859-4-baoquan.he@linux.dev>
In-Reply-To: <20260415085658.993859-4-baoquan.he@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 15 Apr 2026 20:18:24 -0700
X-Gmail-Original-Message-ID: <CACePvbXd=DM-4Fp47KruwtML611AVhXLTtrH=98wMiBnTXNgQg@mail.gmail.com>
X-Gm-Features: AQROBzDpQiDYV_BEAg6iFPgcSOVrcJ1c-GKNJg28DL5lJO7_iY7glMy4I6ojZ34
Message-ID: <CACePvbXd=DM-4Fp47KruwtML611AVhXLTtrH=98wMiBnTXNgQg@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, baohua@kernel.org, 
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CE8D2C0003
X-Stat-Signature: 83aojtopcq4e1oj5g1tpyq8ny5xch8kw
X-Rspam-User: 
X-HE-Tag: 1776309517-378014
X-HE-Meta: U2FsdGVkX1+mTh+ZosRl6qR7O02vI078Jykinasgfw7+zj3Eu4DbwEeDkPC7RcneHOctwBqYzKaUH01GM4n4DqQf1IG1o3YIjry0AlAsG/A6FbI9ZN/H2oODv38y/g7kRQOVghgQc9t6uHLUeHdEPiM0zTa79cjWxgfdouFF9vcvE+YDCI5xX9VziVagyuWHowDBxx42u+OA2oVmpqYrmoQCuDa/BQBgCqn39PFCFF/rfrCfCCSCD5dzUc3Sks4LzELz8x/9O73HvKj0em5izPbHJtfmivtBjTQlIBoO7PrOI7aXM1RwfnMFY+qI9QjtxFOVqqbU7eT6JR5dP80ps5Ag0Ag6+RQQ8VAbLZqw0BT4TkJ8Hy3Xjkj3kVNZnhLNyseW5SyBHIi/qokrL8P5PMI/waruMPWEwKnzMR5/mks3iBALEc8Z8P8RFqjE8+9dsAubTpLNi734617SL3fTmhGJW94VD7ahN2HXvx9cqrUbhMXHxRto9z6LxepxvjewcxPumdR8GXaAdyfA3SGCVbYhH3UQ0gHjvCyAugYL5y/obKRsa0D4Mn8f4JYL3FcgKdjbKAyJKvB0bSc7VuTQdY6I5chk11Zf8m+3pBLeMSHiZxEgf9W0WleDrCoZAdqvsMArOcHK/MM387qJbSJNgHCUB+vbaz/vXlvc9qtl/BiT/eyHo6c+mh8/0sASZ6DTLZANhSDL8Zu95m32Q6w1SfIAujkt0R4xydlFmhPTA0o3412N9lo86aoTBhSIqVaUmr793VgSfaEkeN4M6mhE5LfG6xXpzafCIYGy92nrZuTaH5fh2MNieHgIb2+tqgvm+srfJfMgwUo2cOltEG/tD2HotJpIl1Et8qDsBoNfS3yEVwJR1u7k9nQAv+uL5P0oImJIvlCvMHr1cpGmDLCfzmv5N8rLZeCPLPNh5daewsR3/imeWHepCPjsdsU15N89BxsSkbjD9NZNwo7uSqU
 7nKCBprD
 NPnyYGRtWG84SU48j+VMzLw3mQIN+7ksGB1BetXjWddjEz46h8WBDjEzqQkBaOXtzhbF2ViSYSE77H+XYc5DhsePJEmOUOBNTgLwuXVzMQMsHZ48s39bPQIVNd5kAP68Z6jPOU7ZZ6iVVzo4qO7/Hw4n65h8LEwSRMpWEn+vlo2+JlLWO91Ajh0FVpaGEqst6bm7kmXovglN6ttkhSMU0bF9n8VKWBbDrnH5izI32b5JU3gjQ2qnaMMdrcf0KDpS5L7aMY//wzkeBtOy/qrebq8p3EEIhNJGvUvXVGFzH2tSSN6R2FpTqQ1eQXIxPXaAGGFp3xZAfSkEr3nVe6ahHi6WJSSO+QEAtuW0B3xvF0UFOyPHc7xipTEpaOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 1:57=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> All these swap_writepage_* functions are hanlding passed in folio, but
> not page. And this renaming make them consistent with the their
> counterpart swap_read_folio_* functions.
>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Baoquan He <baoquan.he@linux.dev>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

