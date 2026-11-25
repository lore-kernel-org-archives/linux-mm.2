Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DC2F606A335
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 03:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=If2n5gIJ
Received: by kanga.kvack.org (Postfix)
	id B86056B08E2; Tue, 24 Nov 2026 22:58:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37086B08E3; Tue, 24 Nov 2026 22:58:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26896B08E4; Tue, 24 Nov 2026 22:58:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 82BBB6B08E2
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:58:17 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFEADA0DB2
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:58:16 +0000 (UTC)
X-FDA: 85472283792.24.B085950
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1EF9D120003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:58:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=If2n5gIJ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795579095;
	b=uwVBJmZXH7FigJYqfRRrw693wCf7v/S0NyvRZhIZ76jKBsrKqe8TVahKi+ar9kBW6+o5oO
	LLlrINOPj9udQLcGpBjOQ4CHgjbVjCUR/4nUflm3t/jivBqaP48Y02yuFGqn3EuKopLrPM
	om/8JD6kIhsu9yF0NZsU/3JnVJzWIWA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795579095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w2GcGq8IeDHEJo2hhv/gnTH7TQqHvIsjQUqf1AKZb4w=;
	b=LocUtJmAJ9jWHI6ZMxoN+pvtPmWfz0M6XXczQL2mLPgLPcnDFI1DpKfStHJXwPyk1CDK+M
	ykMDqO+o0Vcp1olPSkfYimMJxpNMO3jw0meG8q5I27dXPWnurMx5E+zLhOaoz4Tehg/ufP
	1Tsyhs5FymCH6N31g+5wFHJYotFKilo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=If2n5gIJ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2f0213202fdso27672495ad.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795579094; x=1796183894; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w2GcGq8IeDHEJo2hhv/gnTH7TQqHvIsjQUqf1AKZb4w=;
        b=If2n5gIJP5REldXHMIz6VQFXBugDr+FMniv+wbJ09NFzFZIzeCfTTnZw3rXPcEUK/x
         UH7w5wowdU6+asi7lXeXbDTyXVRDNjldng3OfIu6VcX4I67QqqLadxWGCBOgbT++cQL0
         Tk/80TMz5FbqxodH3ASgHm/K4kpLRqEXjIs4E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795579094; x=1796183894;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w2GcGq8IeDHEJo2hhv/gnTH7TQqHvIsjQUqf1AKZb4w=;
        b=dVNO6GSzpvc46CHT2r78gf3+B55Ae0000bsLTg5Jd23EOrQkYXcOdEx6tOqFROhRdT
         kZkFjdwXBXr4hm5v7pZSNHsCzpc/GPTsrZ5/+kfVKuGklN4UflzGzEJi4+30A1PxbCI9
         JzimWdIO2m3vqdIhOJ14vmvp3R6UoWYh5+mnNyz/eoNNYy+8avRDwDvmWcyl2Cr0+Ln+
         2Wm3ZrUeYMxnETh+TDNmmkeHps4goESgUtxcWMtu8jHYGt835BG4OgshOmV/ZzTlCG2X
         53rCXnXybNTFRuGqJDX8qR/pTZ8bct5T5aTUY8K8qMWOqN7IJ8jr4gbywL3aX7NSNihD
         73Xg==
X-Forwarded-Encrypted: i=1; AL+hErGx1+45NWejxoNGUUQQLV8zayuLbgUeI+abVQiMt2gVd4tWjtG2tlGNmpKR1lwm2ReheoBAYHbYBA==@kvack.org
X-Gm-Message-State: APuU4Z94LJMW+Nhf/+zKDO4BLbgDAtkf0mpr6kHFfasuDwmcvzYI73Sc
	Nd/n2FQgNGoGWQi74WU6G6QntJY0ra5tA10u7NLSGBrqUziVrzt/xGJDW2/vGzxWZQ==
X-Gm-Gg: AZFdTZem6qfzwBfvopOysQ0ti/qugaWKHOExCrWh+QjHuWgVcGDOVv44ciFoK7ldtQ/
	e347+xuDnbOZVoeI41K6deSeeJYfzoJN8Jl3PLOxb82JRNgzS84TurW8E9HesZySdA0OU5yxkHq
	vEY/FOLEUestswYmhQHoD3PMVUBmBE8aLfQpuLUKayIxI3NTzwkINpB7+HbrtkcHQxBCu8ZQN9b
	eqZ0udj9mfCT+qSSNWcEcnk3Ire+jOu+4cC/TV2Vnshw2tRKaM2qOIJYgrcvIwI0H+uwS0S5dgC
	baDttrYSj3Wq6OcyIrQ5KNPpHwpdxsqnt1iMW3T6WN0zjKNK5AFYrcD2nyXP6rE4PZ4I3gn14F0
	rM3eJY4tqcAH2QijsXk6e36KrfZhGxJXnLBAkoWfRvrfIk1dsITqTGM+VR0ZgaMzIaHJltkErus
	NSobM9z6BKdoTbzr/pO8+v5Nk9fX05hGVfBj33UvPqS5KExm6F3GJIOwd/3DZYLwqqOtzhzzGQk
	FVvplQU79RjvXVBxIGtJbZI/9jteFZDA5H+Bv9dO+spJhH5/Xf8rhs8/+J9Gs/5RGNzBHalEJW2
	f6VcPCbcRPtCWGtkQoSL7OntPLyI8xFhJMb/mSAA9ICpLG768AXBQ2hgv/vRzMzOY65Hnw==
X-Received: by 2002:a17:903:2984:b0:2ed:e22b:77a2 with SMTP id d9443c01a7336-2f03f1ea587mr159665435ad.55.1795579093844;
        Tue, 24 Nov 2026 19:58:13 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:46fc:328c:bd84:94eb])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c2ad2sm77813365ad.16.2026.11.24.19.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:58:13 -0800 (PST)
Date: Wed, 25 Nov 2026 12:58:09 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>, 
	Hongfeng Chen <hongfengchen@xiaomi.com>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] zsmalloc: free a zspage's pages in one batch
Message-ID: <awZcfYOQXpYLcZSp@google.com>
References: <a74aca7a3d27333972782b29786c7b33861a56f1.1795412161.git.senozhatsky@chromium.org>
 <CAKEwX=MJJVBfdE+LL-j+jwfkNP=OHaV21XLJxEOBv4XwsBLiiw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=MJJVBfdE+LL-j+jwfkNP=OHaV21XLJxEOBv4XwsBLiiw@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 1EF9D120003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: n7zou6dexutmythqoxsmjauhrue8rcm3
X-HE-Tag: 1795579094-454447
X-HE-Meta: U2FsdGVkX1/ntNPvZbp9YSXxaQX7PMq1PLPeMHpE0e5yUsdd2dhpO9NY3uzdclxqIxbmY5KhxABIR7aKGz4nANf53vXt3MGvdJghSSk8KcqabxoB4cP6mLpRtq4j9XOkclTf7hIWSh2YGtU2jmreedlB0oJ3ai3oel4xfL/R5MlR8iqQEJg5uQmtVXUWIjR86bet6oHlGItuwj62GYdrbrYyYcg1JJvo/uKKaRIMse/VXPDqwxYUiX1povzhAi5Per6YJPnERH368gEyJVxu38OFOXoGc5Hymc9+y1PVy9Y5BY0JigmKOOyz/o5drMEK6lyNTisY/vEzEuKzvMtSMJif0FQJNiPEx4k3NGVK3c/Kw5F2yq7d10GqcHFUU6TSHfJwEcrNGbCvIf8wNJnIFPeLm7pJ9OaQwPV7tesCGinC5hhqmCFjcCuW7EbEZO1FZhy0tao7bNCxiQN1wuWBdhjfs6p0BLurAIUqf+ZehKHsjW3m4n53iJ3fPeqyakO7VpmOmQHHJdVz7n1WDdIDVQOI6YdYiPkQ+o5XoHgg0cOhzLeszgEkbMsG9/uMRggGhILQEqulrcxnNEU4O1e2Wa4oCOXVaO/pgVmTEYNAbs43zuKdxFmMVxBx+wRAjiOBtmM3EVPCaelj2ROM3XzdEbFDyel5s5BoaikfkDmx5fQXtbHPTcKVErGcC2X0bBDnb+rhdrh2hCLWtlHbfq65yHs7R0qAD1aH+KUEwxX2ad2Nyw4yiBaYHS80uNDjDWhYH6f+M3O3s2pb5ZHdvhmfPbPdtY0ptpPyaL864o1d29cfdy+7UGKEJL922ONoAD8CHuQ/BgBmWVwQbe2IdRO5oel5O8fa02I+BUzQjU2DiCXBmBmGj2l48MUj2f27S9O/vPjtmIS8+dHED9cpq7z0Q6xEkKpJQQN3ynvgd3yCkkaPp0rlWlRVUKTuz6b7ieSGCRX4zCTrCiItn9yaO9V
 SEqr1Tis
 VPN5BpibDla0nwWoJOziBRtOS6trekQksdfVKtxCR9Ke98EQrzKAKbQRv3QVwIFxcUqngA5Gqit/aD3c9HSPyB1S0ZAXFJ0WIZ8yBGmNJK4101Qm4rBY0dWGLSc4WSlhi5OyTRJygaaGf1VuzeU55KQLA48VuwLYzs9bz1IgQebrdSHMyQo8uaqG+PckzFAsr7T0kj7IUdHG8iDEL4e00H+MHAfiJcvtg/fzOy+5Stq97TS1kUL2NkojZL8Ni3yFqjDpSgkOtlgp1se2/wOOzeYjrqCCkO1Z04aJdOhsplEkGJ7eU/bl4e3glPQTNETWKEFJS6KPp5my4/AyW5eQhuCC9pkLUTvq+uZTC4tTu7qszD7NdrujN+LU0Zs2bzp+A0BdhVwlsomfByd9W9vuTG59LXiR8FZKQ6dIdg7AKJrYJrrObk5TpPRQAVpBntkQAuVaIQplUbQPhq6Xv/y7wSpDNLGh4lasqK+wu8jR3XLi9Gnb0+eBXA5vH2w7KERuOn7FlbWSZMstIttuaVA+0qJsEiK1m1j0M8IKLZbGz2J5m1hV+moZu8c4ctr79c4gAnGkEDUnsVq0wZbI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/24 16:16), Nhat Pham wrote:
[..]
> [...]
> 
> > ---
> > +       zpdesc = get_first_zpdesc(zspage);
> > +       if (get_next_zpdesc(zpdesc)) {
> > +               free_page_chain(zpdesc);
> > +       } else {
> > +               /* Single-page zspage, e.g. a huge object: nothing to batch */
> 
> I wonder if it's worth keeping the old logic for incompressible case.

It does appear to be worth it, it's visible in profiles.  Batching comes
as a win for multi-page zspages.

