Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60BC7CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EE606B008C; Tue, 13 Oct 2026 23:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C65F6B0092; Tue, 13 Oct 2026 23:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DBF76B009D; Tue, 13 Oct 2026 23:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CF536B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:23:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C12611A03FC
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:14:04 +0000 (UTC)
X-FDA: 85319762808.17.BD316CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C9FE720005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:14:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hVK98rTK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791947642;
	b=ZJF25u7ayU+t8vkGvJv4o7JViL9T5N+hEOkJ1kEfFyQcg79lHnwNzLevHsfHVbX/GK1Xjq
	Gy663Nw2+KlYlsIh0JnjDzqVGb0iSrGaQzqumtsvxsdM2WLWJMfaGvdRWfYRl/EGOLc+8o
	fH5h7RJBfMygS6rUs+/HwqppTmHJOZ0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hVK98rTK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791947642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xafWGKCMJrMg4LkqDNQKwh6exjnqsIIY7f6p2ybXHl4=;
	b=ahM6GtjrSfh5RYtbaKvLjSSrSRV+dD22JkEIjhl/pI8qguQovSMpysXPy/juLt4ofvx7mF
	P3MT7BKYi0+e5IBAHamH4ez3UocHJqmO6/ytuhivS9eMFedUxAP0v5M/EebUdoi3nijeQR
	rvoCpD/iqAnZg6u/T43t+bFNB1zJMjA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FB6A42D8E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9A21F008A0
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791947640;
	bh=xafWGKCMJrMg4LkqDNQKwh6exjnqsIIY7f6p2ybXHl4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hVK98rTKP4691AQDpea0IZUehE1S5b+Kf2KdjL7u3a1Sk3+2gr8PqrwYD6U0QBwnv
	 KBlQHnd+C6n4V4hSm4B31tiZoT2KeKdd5COiBBq8weQ2op80Ltm3hOiFvHE/vnV3K7
	 rDOkDOrWlbEenUJpOCFnJomqrFCsq3mvUwiA5+OxY+XTRgtmLMbnRYxQwO9IEiWuU8
	 AQaQKIjkG7r3Hm/cpY8c+KXCBVWnjncZ0LwqHMGrbbuTHIuY4jk7rN97NUr2PmqYdX
	 kSgO/th3DoNUpJmPvdd5WhbcuK/QaFPis+XRJw9wraE/iQcHL6/LkWrCphKBSt6ydl
	 FcdFfx3kOL5Mw==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93cb9e9405fso190419085a.2
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:14:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwJtv7qwAPWLcYRM4aMii5SOaQKEADPNq7883Gio6AnUyfgeC1LBUP6D5LsnaeOHyNYrPMRuxhoNg==@kvack.org
X-Gm-Message-State: AFq9FYKReehs47Gbf5S1AbgjMHMGh9FQWdQJJdTF8EMqqgiPWFmotnzy
	SvmaevrvOLijPD2h73agGyRcFQMmHe8RHg6IDG2v+Z4H8yhkHbwtIfM/ghwqfZa5LrKL7H3MOls
	SlquCky23RC8gUNpCp01PIPQ82z1We8c=
X-Received: by 2002:a05:620a:17aa:b0:93c:c162:1260 with SMTP id
 af79cd13be357-93ebd24a4camr2358972585a.38.1791947639745; Tue, 13 Oct 2026
 20:13:59 -0700 (PDT)
MIME-Version: 1.0
References: <20261013221307.850803-1-joannelkoong@gmail.com> <20261014030737.2102-1-lance.yang@linux.dev>
In-Reply-To: <20261014030737.2102-1-lance.yang@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Wed, 14 Oct 2026 11:13:48 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wxKQK=caM6a_AqJArGyJdBgq_=i=gSNjiVePkGBZHnpg@mail.gmail.com>
X-Gm-Features: AclHuK8lputVsSCWQ9JjCuBEuJbYAeIyTKia4Leun33uZrp9EVvPHDRnkQPzee0
Message-ID: <CAGsJ_4wxKQK=caM6a_AqJArGyJdBgq_=i=gSNjiVePkGBZHnpg@mail.gmail.com>
Subject: Re: [PATCH v1] mm: unqueue deferred split folios outside the lruvec lock
To: Lance Yang <lance.yang@linux.dev>
Cc: joannelkoong@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, hannes@cmpxchg.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, ryan.roberts@arm.com, 
	usama.arif@linux.dev, hughd@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hpn5huna7sbynmba4q6uf4bdqbf9me8s
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C9FE720005
X-HE-Tag: 1791947642-38184
X-HE-Meta: U2FsdGVkX18/6oxjsxF4k8T2vjYLEwNqQS+xwxiI2ts5x++2xQDPUBtxB06cix3IT5BdU2Nj7Pzfi83KgjnQNGER+eEMT78gnseSyoN/DsAmsHKxG2QSlmC9cmEGG32QqMeY011aRN642vJR1P5b7GRnBNp30y1ckxctNY+z4WakwQC6qyhNwGnupzQP1/TVcXwVO1ctUPdBs5Va/8BpoJLi3L+ADxU7p5KCOp1VnU4j+ms6s7mWdqo26Wz2fR5JsCtGAHCM73/6bBtqr64wZ7YFiqtaBZurChReTOXqzydkBDfu2nbcGykjawOx/42THLApaeTvSN4AKUlCyJ1zdipRKe28KIGe2fBu7A6P5REkBu3n9lbS8Y+URAA+RVpmH/go7b1gRDhIuCGTxVgu6ZNruPO4KPTzwa9BWWy37/ouAEmqzTgJB8YBPzLwrq0yw/gStGAt5ekxuQ5MszrIxunEyxIKkNxqJ3Az+S6s8OKGjs1pShB4b08vg2ukDlQ1T63GPP49mPaKwDlGVTh5onXcGOAT2OAhXYH8hG3RkPMocCjhnouhURe47buSYDpB+/U0uRX9cLxXIAQ8z+mF+kN0UzWkBSeJaLFUCf5iNceZQfAHLirYs3aa0PQj28LjqHejAb64NE9i8vBy6TkaxAzzzGsJ1lTMrOwON2skc77HIkH9KvDTBc9LLQLik5dZyQ+hcLfXViNSRTzsGSNd7c8SVC8z9HMQwZvm44m/gjL3Rg6lQ4OWGr/l1Q1MatHVt21X6vkM/6822zRcyL5fX8udANFi3UxDeqJZxE5I2vgcK5NjDaklQ80NKWSH9Q8Q7m6O3rJ8501y6rF9M/aPNYERhs8nRFjgUrMqkAqpuDsO7qmxotveDgULA0Wq1UvOcSZLGkQMpzZqvjdICntPi04Lu6xe4UoMfISfxBDK2mbyJRBUTHL+IjQYw5Yu78VH4WvrohuGGIj2JxRMJZW
 0+uXJ8U9
 gWJvIYaNIY7c2l14DY2CloqbR8aTwQQxHmdh21Z3zIVybI2u1qh/47+DLbsvohRysSvyii64qWL4XG7HNK0YgUtXlFfhh08U2wZRuLAfH/1U4gLsuFnO0dG3QEfka89uZw8oCytwE6p8svVO6geMRSH4cBn80uwm0Qs8VaGaiAY14ct/sb490LedJ80qPmrEtBwnCn7WqCeLy5A/0mfgVbyVsgbu+ECkACcXIEkKP68n0H4gpha8YsgQqm9bpu4/dXFcWCxJDZObhKfi4JND8ZbXti64twu8MsXQw5EMVG5xbn75rPsdxXrUhjc9YdVdBIeBE/unEX0mwf1o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 11:07=E2=80=AFAM Lance Yang <lance.yang@linux.dev> =
wrote:
>
>
> On Tue, Oct 13, 2026 at 03:13:07PM -0700, Joanne Koong wrote:
> >move_folios_to_lru(), folio_batch_move_lru() and folios_put_refs() call
> >folio_unqueue_deferred_split() on folios where the refcount has dropped
> >to zero. In these paths, folio_unqueue_deferred_split() is called with
> >the lruvec lock often held (move_folios_to_lru() always holds it and
> >folio_batch_move_lru()/folios_put_refs() usually hold it for every folio
> >in the batch except the first). However, it's not needed to hold the
> >lruvec lock.
> >
> >The lruvec lock protects folio->lru and the reclaim LRU lists whereas
> >the deferred split queue lives on folio->_deferred_list in
> >deferred_split_lru. The deferred_split_lru is a list_lru with its own
> >per-memcg per-node lock.
> >
> >There are already other existing callers that call
> >folio_unqueue_deferred_split() without holding the lruvec lock (eg
> >__folio_put(), shrink_folio_list(), __folio_migrate_mapping(), ...).
> >
> >Add folio_batch_unqueue_deferred_split() and use it in
> >move_folios_to_lru(), folio_batch_move_lru(), and folios_put_refs() to
> >unqueue each batch of zero-refcount folios from the deferred split list
> >after the lruvec lock is released and before
> >mem_cgroup_uncharge_folios(). This helps shorten the lruvec lock's
> >critical sections, which run with IRQs disabled and are highly
> >contended.
>
> Nice work! Thanks!
>
> BTW, have you seen measurable overhead from unqueueing deferred split
> folios under the lruvec lock?
>
> Any before/after numbers for this change, including the cost of the extra
> pass over the batch?

I recall Joanne mentioning some data on this in the link below. Is that rig=
ht?

https://lore.kernel.org/linux-mm/CAJnrk1a2PpUGTsCgS7jct2KET4K2zAL+_h+te8G1M=
aU9bXs99w@mail.gmail.com/

Best Regards
Barry

