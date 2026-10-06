Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35F1ACA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398736B0092; Tue,  6 Oct 2026 05:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3223C6B0093; Tue,  6 Oct 2026 05:52:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EAD86B0095; Tue,  6 Oct 2026 05:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E96726B0092
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:52:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 748F340184
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:52:33 +0000 (UTC)
X-FDA: 85291736586.26.5687713
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9D0ABA0004
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:52:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=IHyx76io;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791280351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fg4heyaNVw7VYP4ZPvHMypbYfuDwCofB/Hw02l9JTQk=;
	b=qPDYcKm1GhNpNy3NA9NS4k6V29WElpQTAQQURcuEWXW8O6iSH7c3vF9G+Rsm+aUpm5ywrx
	7BvN5e2L5LH7KduLtxLe8LveCWDVa6PxsHLwEd03UKlVBXuSJtkwo872Yv6p0n3emXSTDe
	jyq9oE5pam4Exsitt/gNiJu3zL/9i4w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=IHyx76io;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791280351;
	b=2tiDBDBjtkFcdfvlftMMwaXDEVrLdSpla+W9Hj5S/yOVBOmQxkxjKihGPaxs67HVP7hgTa
	fUmiJu3XikpYlZ8rg+m93Hg5nLSPu1sdIkoMWB/94zLQsIZVYyzD/lZUjrK8F7DnPke5D4
	tlybcESDBrIXSLh5p5K9C0uTgtPxV3w=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-88cfa501c5cso858719b3a.3
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 02:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791280350; x=1791885150; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fg4heyaNVw7VYP4ZPvHMypbYfuDwCofB/Hw02l9JTQk=;
        b=IHyx76iomSheGu01C0+pjvLsSsP4XCz35TYko6yqEs7gsvuENfxH6msJ/NrLB5c7YX
         jFCgrJDZCR3ef7N10MwKonM1LyFWnx1zIy8Geq9OugJm1rkrHZlCKatjduc6wLTCy8tq
         cN/Sfx6gBjJ/ZfHfzyUTVf/EMSXN6FKkBnFuM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791280350; x=1791885150;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=fg4heyaNVw7VYP4ZPvHMypbYfuDwCofB/Hw02l9JTQk=;
        b=ubA886tsi6jagYxe7euiY4XwwmRW41RKwZhTx/oR/ovzJ9gA59/DgrMnXjH+AMrr95
         mRty41PrfR9iCE/W+z1ze+aNVlTPaRgk9ks/kxmO/47+0Le/la9K+ILfXSqsS9KbODnQ
         7Of+M0mvkO8XGIIAst/h3t7yxRFdX15xMwSDXxuwlGgpkjGJyyQLjtT2TWOJEoThsv8W
         y73y+YLJKP01KOvP3ro0nWZdIg6Xh2l5aZeuJ+kDKQV1X5fwIQB6L9q4Tjgjp2p4hlJH
         54EfAjXyGQtx0kkOzUnpy4G6X7WKx/bIyjs9vXHIq18TWzBGfsUiNmbMJ7xLXfDSipdu
         Je2w==
X-Forwarded-Encrypted: i=1; AKwUvBzRCAhLmvx0befmPw1qkVbpTvexPD0JdqH9a7YmpQcX9RZ2IWWph0lqDivFJ9bUhyS/8NgbfCev2g==@kvack.org
X-Gm-Message-State: AFuF++n+DAV8cy/UKfteFMp+lVu13ajY1e/oHCSP5Bv08TscIuRkMQVr
	+pkEzwqaK/sdCIZsSPGsXvuo4eYSTlpU2ma0MSFjQz6jWKSaoD1kSlL2YNuQVMh3nQ==
X-Gm-Gg: AYBFou1H8Cnd169QmoY8i4mc+AQ3W+D3t7nQi/T3VzijWQH6QKk3ApkKt699kLuLGcZ
	Ygky5ecY7KX5HrV+Jit5n907sQOe+O5MtmJSe6iUZT1jWCtYp88ENSl+B2I1r3pW6hp+SQ46OHk
	7dwT1zOx25SBb1jL7NZIcqc9vm8HLxSZStqfiENA0TBvM0dI03RwuFCDZAI4UykkhtCgEL+Ol3M
	/bZRvaaPOYJwtFOC+ltRfHqVm0hLCZUn17FxdcKM7pYFLLVKb6OIrxI8EMivGsBrarzDTMSTPju
	if5FdU0tudHc6oYQT2GgH020Iwf4v/cUXGx2U2Oqs+201I/eVjG6XzwrYLa++3W16irHAGbVoOp
	5KRaRQrEyglDJTkyxQpBZAcxMRurWJcIbkvDIr9Lj8+/hHcd4LJghbsEOsuo+j3QBB26MDEjsw/
	EHeoKsxFyxMUVbr4xOakIT7u/jta3PY+dk79GvwGXkKOPSHRVw+BVgizyXCUM1n/RU8wjt++xC4
	WRAN7osskmb64zx9bYQJgVup2grT7cJHPFREic=
X-Received: by 2002:a05:6a00:27aa:b0:88d:284b:6ef3 with SMTP id d2e1a72fcca58-890e027488fmr698552b3a.58.1791280350355;
        Tue, 06 Oct 2026 02:52:30 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:ed0f:30a2:6c81:a58e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88b0d152432sm4523788b3a.53.2026.10.06.02.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 02:52:29 -0700 (PDT)
Date: Tue, 6 Oct 2026 18:52:24 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, dsterba@suse.com, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, terrelln@fb.com, yosry@kernel.org, 
	riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, senozhatsky@chromium.org, 
	kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm: zswap: use separate compression and
 decompression requests
Message-ID: <asTEwVNe97_m0Iui@google.com>
References: <20261006002307.2669023-1-usama.arif@linux.dev>
 <20261006002307.2669023-2-usama.arif@linux.dev>
 <CAKEwX=O=QNWUCTn9kcCwu9V3pTrSwTj8SMCMS6Z-8fwhGjrkdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=O=QNWUCTn9kcCwu9V3pTrSwTj8SMCMS6Z-8fwhGjrkdA@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9D0ABA0004
X-Rspam-User: 
X-Stat-Signature: 8xnz18qrm6ek939w5s7girn7tha35h7c
X-HE-Tag: 1791280351-499514
X-HE-Meta: U2FsdGVkX1/QRvql0Ay064qo5dfvdYRzsYZ+Iqgyc4ss6PNaCqec66Ets4SBd/wx6zBXhiX2tGSHPAmPb5fS0YzUqpvUq1BZh5hC9sOkDp7CJ8Q5A2/7p1+Fiw35RLaM+4xHigUfGPkHWJ/Sg4zBbN9pGpYW1DosPPqAYC6H0EXIaIdej4oDB+WfkwY91hpGUUSerzoIwdEZXNX71K7UIGr56RoxWbEFPNDYS/eCvgUWwzmvY2M4O83bo+RvQ6jYycKTgZiIrm4wB/kTpqml1Wk2KE2NgyiOGdDLwuXQ7Q03FWRvDANxAzTm5jxlS5I1/eMt0IMcTVPo1cwzxkq6Ak32Fqt/EV7zcp+hQt3dCeHG/V6bAgvlzYvfKPeeXd3g0jfovRlla2GjJAUyElC/06d5mjgx3YoOLLRhWC4NcJcfKH7IqDGyKV7t1WktijpogbIsh21bL40A0ZAPAyBVZZVZDbSW298+8EDm+faRF9STn3SmE4HNcQfbz81p7UsMIPQC73Cx2Fq1Dze8Wd6R+4pCH6gEqEk76mQiSfLMTrDAtIXPkBjMQrfALN0ZU9H7sLsBBhq1IFZN+4x2mYel67nU9kdfar7SPOyEjhJzsr75QxQsqx0AkQm9o00trOV16/aWL/AOVDIiIpxnFiX9wqGEK/jWRk9d8uIjuCHNSTMKSdrbXsSdWMWQU7LY8ja9woN4Oc/aqld827V0ycgVsHPOcyQ3GsHiHOyZ7/OZ2zyCmOmzz2aS3/TJ3ozAI+eX7syWITNq2G8IOqouIHwkZi6Uzh7h+6SJDCLFf68CIh94LcpaY+Y+JzJi65ya67JdGSgL1sJOhZJbb3f8ZVdgGLszXIqYQ8wds/E0nmrxoVNSHM0+yxCnKfala88vPH3Nj0b3K4ImHxQnZKQqogvLqwG3wpbwHDuNjPn/BJC3dqOwgcY0Tmdd17ufiaGB8hcTIiXd8dpL9pG0JKXNrrk
 q4HsOoke
 gnquRDWQfKx2eYOuJXCGtnxSJ+KCvis9Rg+Br4B8VXYvc9XBf1EC983ikSvUUn3GvX/gSok8jvqvV3iNHGdU3dnuOZJ+Ug26cDwdqMb1TyKdUlzPEINgiq+FtZpmClxzpJzTNXG2RwH3cQeKyJRkcO5eaNSSKPy/70FJ8KOvHIJo6bcSU3lS95hQ9MR0xeiQo8yc8OgdWXmeYgjBrcPoFU2r3tH8EZtVIPFM+kvPYA83dPlDt6p0LVMicPyWQMU0GfauThw4Dxuz/dm8MzgrrDm4Raq5Tf755j6ochnVNjoJmYFzYPDMheqm6fkDE/++g0NC5AFVx20Yi098CyxtsuyEUzrC3t1+kwYjdxLkNjoj8WRdLEVqvbLROt7QC9yFyGJCB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/10/06 11:47), Nhat Pham wrote:
> On Tue, Oct 6, 2026 at 2:23 AM Usama Arif <usama.arif@linux.dev> wrote:
> >
> > Stores and loads serialize on the same per-CPU acomp request and mutex.
> > A low-priority store can be preempted as soon as the compressor drops
> > its stream lock, while it still holds the mutex. A higher-priority load
> > on that CPU then waits until the store runs again, which can take a
> > long time when other tasks are runnable.
> >
> > Give compression and decompression their own request, completion wait
> > and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> > decompression APIs from zsmalloc"), the per-CPU buffer is only used for
> > compression. The two requests can share the per-CPU transform: no
> > in-tree implementation modifies transform state while (de)compressing,
> > and shared codec state has its own locking. Loads can still wait for
> > each other on the decompression mutex, and stores still serialize on
> > the compression mutex.
> >
> > This follows the proposal from Sergey Senozhatsky for the same split
> > for zram [1].
> 
> Thanks, zram peeps :P

:D

