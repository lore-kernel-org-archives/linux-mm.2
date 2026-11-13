Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D9A606A884
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oGBCJrIb
Received: by kanga.kvack.org (Postfix)
	id 6FE806B05B1; Fri, 13 Nov 2026 09:43:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AFE96B05B4; Fri, 13 Nov 2026 09:43:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CC446B05B5; Fri, 13 Nov 2026 09:43:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0956B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:43:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6BA3C02C1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:43:29 +0000 (UTC)
X-FDA: 85430364138.14.3971BFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 20070100005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:43:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oGBCJrIb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794581008;
	b=Y0iqMywqaxtmP/YgtiHr9v2QaGhpVQLPG3/vEhsMy210Ku7I473+O1kGE6ouWtA2oY/48J
	kTlRNluiMrgTDRP6GzpyGmFFMLtQl41DUuTRmhHmydCHsbvbPJAeQyNwPiQbNjrEnjSLQZ
	XiKmHvudW/xpQyQFjwrHvmM6tQWeC08=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794581008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1q7tOBKKTq5abqvlVTiQBov0Mnni6BvhJAT3mdXSKc=;
	b=Np/H/R090pbrg+fGnt8EIh8y3MpnNpufxp24SYdtMt8MY7KLC3gdspYRVo1CcEkti8LiGb
	aPhFil/Ybi9nSyPub+UEwOfUyCIOeqTF4e12ckiynelQGQNFJ13gLy08UQ5W5dq43HAAdq
	vvCbcE77jysOJAbwGqpUR8YAUjyi8Xc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oGBCJrIb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 62AFA400B4;
	Fri, 13 Nov 2026 14:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3C81F000C5;
	Fri, 13 Nov 2026 14:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794581007;
	bh=a1q7tOBKKTq5abqvlVTiQBov0Mnni6BvhJAT3mdXSKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGBCJrIbm4ca7kSdoD61vgbAK5Jv0ZyiJDP7tya/Slj9ksLssXTat/pX5YoIgnNmy
	 Jra8t9jEjDi2aDBeUXlaiIIvn8MuZzTfivUY5GmE11+J7xkqEftwE1oL8SkQ9evghl
	 VxBxT+5oa4Jy0Dumv+9Ueo1704OsVNIzEl08ckaZ5yE8IrXKaChwcGnalHl4MZZ68e
	 Wiku+M9KEEF3sxP3FERCgjZ4cJfuJFZ/100eBHU5HXiYIjwTUMSz6dOWeKI9/Vr6PO
	 dm5R1so8iM4lBQDfIky4pVpd5zaW3jG125PSapIeY3WGNxt1OOrLz/CsrKY3r6nKru
	 rcmcsCV5w4mdQ==
From: SJ Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/4] Docs/mm/damon/design: update for DAMON_FILTER_TYPE_ACTIVE
Date: Fri, 13 Nov 2026 06:43:14 -0800
Message-ID: <20261113144314.97829-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <db00f01d-c9c1-4207-ae7d-9dd77cf5afa7@kylinos.cn>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 20070100005
X-Rspamd-Server: rspam12
X-Stat-Signature: srou4hcyqdpxfmnrhfuiwf4e3xcmyday
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794581007-231416
X-HE-Meta: U2FsdGVkX19gU6wLacPMwZZbbeS67/KIFq7GVKK+AFr9/CG98f/Q7iczuLWjJMlAkGyMW0RuEL/GMXQdKhvB1P21QPX/MUjcl3S5LdXZVwqMuFWIL8nqwQULsoxDtkhpyy+nBLEt4tzY6yqpEKrnmszEJCY/ia672AvPlDK7f9r4+eo4Y+fCzi7kQpagn5s9eoqCVZkVrqMOkIIGM8J7Z9tdbJAT3vSo1BQdwcCLiGl1ZyEPzeoK8HAht2MEVl81sRDPtvz8NpvkAYEug+D3WSW1aHFTkpXeTLpbZpuTZCZcy4q5s0OZQOU+/gVa0Mw7oi96gwiDrKMwdJcJCGVc4fMjPcinDTUjRI8iy424+iL8XrhIk0r5B5tF6jSjvXsrwOxrUyKnWst06y+BixaSpJaa4iMLDrBh6DNZhQM1hCWV0OzL9zfKZwC+AKQTiqU37qu4Q2rypbnEpC3OvFFIqzScfz4F4caHWY3GdU8s/fTsB1yf5TZXHaV5WSHaGlklYWL8WIc/I/SV49lTkMG4gO0qXI6+y1aY4it97yZwxSx7TVYoudAqtQmvMW7aG8Pdn8OGZQ01JA5CTlKNB05nsLAKV2+k2M7N6urV6/PNbvaTttczNeq/uR7eudx7NU22glsKnc7crrufqLz/aZ7F/f1vAx0InqvI+Q5XvinKSjtBrAEkD9+qkk/cTPqSSgV7fp15BS8AgATPiSt33sL3RAkrQVabICeC/lAhR1KWIe++KdeOFzzdQt14H0DM+6JneetsY8hu6KcFOYseSBmacXpb0DD6nlvzzGtCOYKgyPOd7IvRmsmkvFtIgk/IzAQJo3BGfYgODo6JVweruNGCqM5/3kS6MuULSk3UkDtSh1aoBV5YiDD3v9D2hPJM0Be8/L4vD5QTxsY24YZ+iF8Ro0a/+3Ifxp4YS4y7cgqIoHnXSZDi9FR0u2MkkzrZXeTM4wo897jykAGu71XFJLt
 UY38P4Fp
 OvE+X7VhLG+e07Eqgti+tBz5YDXE7b3okK1mTyPxWJWahY4eRUsM/UhuW1kdlzH2ebUWWwsVicLV1BPtaK//0cToloFON+5+tb2tlHAbmty6CIMQ5LXxeIOvmxtORk+uKb+OipnbTaTBTEqWGHBRUqZy3Qk3QqptamRGBHOGC7okpKuCfo3opC1duDw0m/axq99aRKi5vyr5boK76dAMy+e/A/ZgSUkWcgvpSpzb0lAiIooCRZAGGdPsAIm3s2mqbu9PkY3QaBddlQIw5RI9lmiIfC76TOjXW7jLmRMjGAMKwWiYdAJWmS8yYCdC7bxKY3LGfn+yOJ6zT7cL5fmmLQeQnSceAtrApc++2lNzLwkWAw+exWL262maWaxCvJkaxEAe16WfjBekQbMFPJIcj6Km7L/T/NpCWcoqKk8J4+OPEqBiH/JGQ0vwgrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 17:54:37 +0800 Enze Li <lienze@kylinos.cn> wrote:

> Hi SJ,
> 
> On 11/13/26 1:17 PM, SJ Park wrote:
> > Update DAMON design document for the newly added LRU-activeness DAMON
> > filter type.
> > 
> > Signed-off-by: SJ Park <sj@kernel.org>
> > ---
> >  Documentation/mm/damon/design.rst | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> > index 8440c4954090e..b676be6971589 100644
> > --- a/Documentation/mm/damon/design.rst
> > +++ b/Documentation/mm/damon/design.rst
> > @@ -302,6 +302,7 @@ filter types.  Currently below filter types are supported.
> >  - ``pgidle_set``: Matches if the page for the memory is marked as access-idle.
> >  - ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
> >    of a given size range.
> > +- ``active``: Same to that for DAMOS filters.
> 
> This reads a bit awkward to me.  How about:
> 
>   "Same as that for DAMOS filters."
> 
> The ``anon`` and ``memcg`` entries above use the same wording, so
> it would be nice to fix those at the same time.
> 
> WDYT?

Makes sense to me, thank you for sharing the finding, Enze!  I also find more
"same to" usages in the doc.  Would you like to send a patch for fixing those
at once?


Thanks,
SJ

[...]

