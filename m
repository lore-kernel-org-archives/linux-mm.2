Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E13CC61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 08:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E9786B0088; Sun, 30 Aug 2026 04:45:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 399C16B0092; Sun, 30 Aug 2026 04:45:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AF766B0095; Sun, 30 Aug 2026 04:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 09B106B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:45:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73553A026A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:45:29 +0000 (UTC)
X-FDA: 85157301978.26.41B2543
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7302740005
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:45:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GaQVowwc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788079527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7EkBLffHUilXUOjYRnC67N1nxTA08hQD3hpd88dlmDM=;
	b=0MmCzeX/KhH9BFCyhAEA8kV4D94umjMg2EU33weRkyM90B3cXjiJpCbchZLhtFI9nHl/9X
	LtAVv3AwiHVgblGqzjkSUlPbNKNUr81ZrurGd4x5WgUlYf66+u0txH3LTb+TNkyaTbZrrY
	W2p9nWHdHnx5SWsSqJpts0Fu9gRMr70=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GaQVowwc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788079527;
	b=VwWPtzWjZct58cerCOmib5X7vZESVUs0N/lH22135npHs8u3ApXoeNeMyrAUambnjzN1+B
	8DxchfgxfqRu0nMfhu4QSAqbk2p2GLgnf98GNBOJR/3O8Gn91Vhpm4V+uMV9XzMuN9jMPV
	Z0oMQK0a9dvAA/vA7B/PfpGChHQZfzI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A247E441F4
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8575C1F00A3E
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788079526;
	bh=7EkBLffHUilXUOjYRnC67N1nxTA08hQD3hpd88dlmDM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GaQVowwcTTHSnoV07mxxH7tp3H0PPNfB7ije6AYFDP9JHUlPWqBF/K+elcY4Og3De
	 GRq3QStCWJaF8QA6OJS/FKAQDCh9SKNZkwOA4qBzoTHiVe7bVHSDEzapqJAgsXKI3d
	 Q3DkG1N1RJF2rahVShFluAeUcQx46U54xKFgM04CSYYWYTSWFFIIAiveagZUCcKCQK
	 9Jb/Y6w+dBJaNEekiGVhwvlcE2pX7FUCq+xEuK3/cTtELO0MW0wXAmVZCWYoCq4TQq
	 5y/lkUeytEztpNhiVSsq8YXZjxOAOLCPWSPk345k06XRhUOeJsvH5Lk3zaXvmiN5Fo
	 XjD6LFXlNFxDA==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9392aa26b25so72956885a.2
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 01:45:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpjkz7su3sIP+C/IPw1VpYJlXnq692vng118hNlsqfGj4Y4+5OQeu5PXFfx5+MuPta32TpwbXeP1g==@kvack.org
X-Gm-Message-State: AFuF++lRWwu3F+EHtcIput3Vpt5YFpCemsxhwyH47dERwIxgEPw5OpfI
	wfenmqMpIwokmCG/wl3yt5rDOP6ffHAgn9H4dPQZ/a6/4+cmSXu0962KYnEs4wTIXQH6lFzlct9
	QoOwz79n3qeabcNdiawu1am4nDlH2DAM=
X-Received: by 2002:a05:620a:1a1f:b0:937:37d4:5dbb with SMTP id
 af79cd13be357-9391390a280mr2106971885a.27.1788079525955; Sun, 30 Aug 2026
 01:45:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com> <20260828181035.ce6e23970d37e38b64818f10@linux-foundation.org>
 <20260829121335.3491374-1-qwjhust@gmail.com>
In-Reply-To: <20260829121335.3491374-1-qwjhust@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sun, 30 Aug 2026 16:45:14 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xxDpeaPv9Uh_1qsuXsMLkx+J0X=2V6342idLFO5jkTBw@mail.gmail.com>
X-Gm-Features: AcwNN1X4DbE0lm3JyC3by5kykwuVyKlkaTLRkog7SDb_iT14PqwGbCiV-P3uFKs
Message-ID: <CAGsJ_4xxDpeaPv9Uh_1qsuXsMLkx+J0X=2V6342idLFO5jkTBw@mail.gmail.com>
Subject: Re: [PATCH] mm: filemap: tighten dropbehind completion context check
To: Wenjie Qi <qwjhust@gmail.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, qiwenjie@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7302740005
X-Stat-Signature: xhkmhc1zxk1yxiga377unmzf95b531e7
X-Rspam-User: 
X-HE-Tag: 1788079527-91513
X-HE-Meta: U2FsdGVkX1+3Nnnf4/EXjYiSkfDHNA0vtnnw0rn7G17G1Rj3PHizNMAuJ7JOJTMCq4NsKLCFxMwAC+Xf3T9aXcVIfvd+MMwejxB1HksCGAteRaGWmZZIDflLbMFzg/AbZUXBwkDG+SXBtO/1GWij+IHOAm65iYRBRhAlXLNJ7sONWowOpkYvrq4crUtJ7oeQsypYTRGODjwFQRW3A6akC1XCr8QulbpvCdwc3h3plALd1wmjUbriX56+dfcm+1OEGzxr/pjJ4NPcKLcgHD5PsvRVwfUUuyMYnXGxjX9gfvN6zTmPMrMDe/iP7BFuJL3z0wz3DQv19b8/7SbTNgEazl4lxmR/XRw9ivQY6qT3kPi5r2HMRuhTrgo69qLjLOIGMNynSMVmvHlZMmuIANPH85wX610+1hPXIhStgEjD+KP+a2ZvMTcfbortV7wTS2srDl2CBjohZnWz4ZyMrRLJo2XiSnfbYt7oa2smPB7lGiaV6aRheuDW59tDDE3PwLHZmwctmJcrlgP0wLI0mnhFW1vPjFxtrmcmOIr8CVvYbn8h5YmYUyGftNlbgJd/rUnsmzO1mxQ3BTYqQNaeCeaHB28rPwHwP8/gavg56AeWP8Rq1b5ZwP6QevC5LAj5Np4yNIghhcxCeCmWcoe3nsjTno5S3dMK7Q5RVjZJcp8fRYOvJal43Mer6DeEnUCcFSjxoP3zD6ZNUJH5CDUnkS5Bh47flv002zxDUOp0JXzpOcTHkCB3X6GoCf+AqEiGdk5dn4Gqqmzn4qE5G1LfVWBAC3HU809Huv05NhBVUNPVIWmWVaUpdguqSS+mNmDYxzdyaGhZDBMRqOJMrU6CVvn4OxyZkWtRf8BCZDxStvx9nUXNZONtmB/J0Arp2A2/1jw+MciVcknJ2Q9aBG0js96xqTBUath2mz8N4W3iyQBst4bi6NAeQnVDnHKp88bAH+z6MwpwbAtlsV7vG/D7m99
 N/LCK/pu
 BshQ8IFb/ta2yvBQyAk2CRMJS0AciomWKVZ0z1jKY/4d7RH6sC2S0KIheCw2eArhinqOeZGfjzemjmrlQWYOEkcWjYdqtMrHBMo/Zz2UIJ0FKfFHuzEUi5vj4cIPKZmka09H30YY8K4ZHRhorZuxy+tvQtqyLOvkitojKKnufz0mi0/760IDU0ZpEjCiuZy67MfYbJdwAKRksnuNJt8Vcb5Vv36Nu4DL8YNNGdCB1fPuwOOujgurkG5r+ZZCSGQbRNLujHO/EoiXm52v1NwF5dwOWEVsTzN5udpEzJLqghrf9TwqkkZliaU9urA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 8:13=E2=80=AFPM Wenjie Qi <qwjhust@gmail.com> wrote=
:
>
> I kept the helper private to avoid an MM dependency on <linux/bio.h>.
>
> After looking further at the mapped-folio case Matthew raised, I think th=
e
> better fix is to retain a dropbehind folio once it is mapped.  A mapping
> represents a competing cached user, and retaining it avoids the sleeping
> unmap path, so filemap no longer needs a stricter context helper; the
> existing in_task() guard remains.  I will respin the patch on that basis.

But we still have `bio_in_atomic()` in `include/linux/bio.h`:

/**
 * bio_in_atomic - check if the current context is unsafe for bio completio=
n
 *
 * Return: %true in atomic contexts (e.g. hard/soft IRQ, preempt-disabled);
 * %false when a bio can be safely completed in the current context.
 */
static inline bool bio_in_atomic(void)
{
        if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
                return true;
        if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
                return true;
        return !preemptible();
}

Right now, it's used in three places, and I expect we'll see more users
over time.

   1   1925  block/bio.c <<bio_endio>>
             if (bio_flagged(bio, BIO_COMPLETE_IN_TASK) && bio_in_atomic())
   2   1451  fs/erofs/zdata.c <<z_erofs_decompress_kickoff>>
             if (bio_in_atomic()) {
   3    403  include/linux/bio.h <<bio_complete_in_task>>
             if (!bio_in_atomic())

Yet it really has nothing to do with `bio` at all; it's purely a
scheduler thing!

So I fully agree with Andrew that we should move it to `sched` and
continue the discussion there. Maybe the current `in_atomic()` helpers
aren't really good enough?

Best Regards
Barry

