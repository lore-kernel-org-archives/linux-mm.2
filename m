Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4CDD10A88F6
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 17:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC6E26B0088; Thu, 26 Mar 2026 13:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E77A56B0089; Thu, 26 Mar 2026 13:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66AB6B008A; Thu, 26 Mar 2026 13:54:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5F3B6B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:54:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C1DEC207A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:54:12 +0000 (UTC)
X-FDA: 84588963144.05.7B15B1C
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7475C100011
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:54:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tAuSQioc;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774547650; a=rsa-sha256;
	cv=pass;
	b=b3X+RFAWCCadIbfJGGCNgkO2QjZatRiapAp9X4HD7mAzIDJkbWM/lEwCCVYtOEW94S0MMn
	Q5Ei9JK9zx4YyS3dYlKabboT4mdpQPEroEfvyTEzSdFJtSJ9FjC32JVmV+X0Ny828ol7xi
	M3SQvWU0Ms1+A2yKVoCj2VD1oMScgUE=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tAuSQioc;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774547650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2b1UX5269EiDhfq1pawQFex+1Y1S6Ex1txW/zzYwTBo=;
	b=nAsAmRLr+He327rAJ7UfkMMFiiKnZGa2w+EYZSpgMpuVMWQKIh8sxdEeKd/sI8mn5p5tzp
	qlRPBoNNzShalL/sOIpQ7rSJtN1hrBKog08m0PaS579cNdT3C3oKlJ1Vfwf/Ej+nHrUc1S
	EtMgzJB7/ZYKEzMYmnV05xQXltmWmIQ=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-486ff3a0fc1so12689855e9.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:54:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774547649; cv=none;
        d=google.com; s=arc-20240605;
        b=LSRDYYxRZpAMd/7KYgFcNAA+HwVrfWXvGtxElcyOXr24wfflTnfzauHyZB4y+K9H3W
         pLzavDJei577gm0Z5LqZdnB7pqzUWtOA1Carp/HVieq0UdXR7t29GZqn1pNnfxVEc0fK
         0RzjcKTIt2R+XGHa/kYvdTzEVK/n0WUzTXbpTDjqipNxT2ULOiMk9UkRWKPK917JwaB+
         QTpm+zf1EkHdPKe+l5kjrn/GdzBZJnsFqwHHVrzjqwh+2wJyj5SgCKt0dCOqwcYOwJYH
         mEbLWIfeNPmX50voI/3eTo5LY64vTsZnFOBPtUb8PgJzghKPKDWjArbzpPqNWPDbKLnU
         mOMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2b1UX5269EiDhfq1pawQFex+1Y1S6Ex1txW/zzYwTBo=;
        fh=DVNBMlRgYO1UeTMkIAJu+4bU9fN/8DGNfZbSl6ocPEw=;
        b=jV7fJ5n6w0aY5RtO17Db1hOIHv/kyfsa82+MKNh8LG7wYmbJm0qDAuy0Ec21OJvLNm
         XaaUdtjhvWWmQ4YKmuFr+jWZIHbxbzdiS5x4r9wCdkciHx1LcN8YUsER6+r0S4I8IWN7
         j4Rf/rcY3O3+DfnxzbPKTwZpu0Wk7Wjy2a8S7KlFx3NH49n+PBKH9N9ArPEM1tAQtJiy
         f2niiYkbVusj+NFiSqSUAQSqB0f7f9CjsZNbpXN2x4WK+z3hhfB2vTiamiL+yxstzXLL
         wFiOHeMv8Wai2cyoYZkrlWBxG07eY7nGvvgVm8K+b3ay+uJ8w+0ygbNDUJ5tN5lRHa/G
         QWCQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774547649; x=1775152449; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2b1UX5269EiDhfq1pawQFex+1Y1S6Ex1txW/zzYwTBo=;
        b=tAuSQiocKfkApNy4RLuDfPg3YT79Op2RyVsknv7rsBok4N7CGMfWuIW7rswmVvh3Wn
         IsiORgbEU4WC9rw26EFno5vYzUM+XY1bhl2PCVKYeXE1i3fOLTQxVtvNSVcNjfD8smVy
         HBvn/06pyUUQcXiTUX96+p8ipTxDUNpOool91xEhDmYtEUZpd0H7L1bzkYph2ko+NJes
         TH55BdB0GvyRb8RKuqEUgnYgFEQbTcQrWmtH+zzFkTiISARhMifQ2syFtEtYrdpJzFlJ
         hLw7q9XO8GRRJTElrEKEo3MRnke9ajxtoeeWpNVcA85O3lVaGeETlXMn0iRtrfXy6SQG
         vfDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774547649; x=1775152449;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2b1UX5269EiDhfq1pawQFex+1Y1S6Ex1txW/zzYwTBo=;
        b=iiLC4R30xAyhhvfrlG8X8xKisrBywXnK857th8JoV77woeiFJvgfDmB/8/nhkE+tjP
         wgxoKeYUK4Q22qF77rgtv+KdiYG+jHbY/ceHL+WTromYxWq8KB8ckzf1Lv2b086B3ojK
         S+vyeo/3CchT4Za3+Yf9jbeI/h+/JJ3h//OWKIkJ6wlbdskpD5Yz+Qd7Fwy/ecigsnKq
         25wFu935zj9Pk6SBZlyNHV3OlyPpiNMMuxOy5kosObEpvh/bcfkmTEOkKZ18Y6N7scI9
         jcTUcXIDCWXY5QpBuPle6y8eBhPCGCakTG9gWQo4ng+lSdFesMT4ycwEtVJq8qYSsSjV
         j2UA==
X-Forwarded-Encrypted: i=1; AJvYcCUFkk+Brv7IB5EVTPui8Ub3hcLnBiPnuqxBr6uhXo7aE/JWN1lVvRqGOmmTIOVpZeuSCXeJmnyLfw==@kvack.org
X-Gm-Message-State: AOJu0Yzszl26+3+8Qm4Sv+IGt2SN9JpHdcW5t6gnw82aXz9R2iWG3xY8
	5JPNH0dI0BOTwvnmAq7WBN1xCfXb2jQFodQCw+pqYAmJGrSzsLhNGfqMJH5hxnnLujs1VzP4VDj
	i3HWmdtVEJzep8Hd2MMTXPfbypqVlPobnrsdvRWc=
X-Gm-Gg: ATEYQzwpbcT/+4zuDJ+mx+ld8QxBqXXjlfEuRMxA+OrH35pfxyPNKbcGaqxOYTXJR42
	3NmgvmrXtfWvN6dy/G2WJhlu0WNI1zkBgLxOxR/65fMn7XZis9W13RHgfQORjkgA6g5Vc4LOox0
	77AoJuVMhju6+Mp18WJi8iNxb1HLpTqkvzv/JEI+eQgUjBpN9u4J4Nnf5dcoftc+Wy76qL7skC9
	HfmQsdSbd+KPCXMPIFQDwDHUdDu6iw74VrV8NC7Kn2n0NzICUdmy3dkL+5/WbWtXfyKem6iVhOq
	aWC7AyA5haovG9r6
X-Received: by 2002:a05:600c:528e:b0:485:3fc8:de9c with SMTP id
 5b1f17b1804b1-48715fd4dd8mr131671765e9.12.1774547648461; Thu, 26 Mar 2026
 10:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260326001337.828947-1-joannelkoong@gmail.com> <acTJLJdrd_T-cOAu@infradead.org>
In-Reply-To: <acTJLJdrd_T-cOAu@infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 26 Mar 2026 10:53:57 -0700
X-Gm-Features: AQROBzBk1MK2sKpbF7oHxmG14dUDSRU0L6vuO6VBQC9M1qo-02BtGUnmY2CGWLQ
Message-ID: <CAJnrk1ZTHphV9e=chJD5iHTMDm7F1qqHebn6+Li2cYaggyP6AA@mail.gmail.com>
Subject: Re: [PATCH v1] mm: fix writeback regression for strictlimit BDIs
To: Christoph Hellwig <hch@infradead.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, jack@suse.cz, 
	willy@infradead.org, miklos@szeredi.hu, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: azhwwyycm7u588d1jg1ku3cqynxqxfja
X-Rspamd-Queue-Id: 7475C100011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774547650-982928
X-HE-Meta: U2FsdGVkX1/bDYY7yxQQ8cccIoD83OL1qr3INEcMaGzR0ppAWs5oGKD6C8aGoXpsAqSeefY2DiNxyEvtRHdIWbW8Ruu4PfRZ7KAR2mOlC2C2N+nOagMUzLxlH20kA84AHR2DVg+u2G0gVWxF0yNUJ0ZHy2P2T8yFs0kRlVJM6ET17TBLD4VqibunGEkjla7MTep3YLNcld4uf4TddB+adB+GbmK0ZYpp5asAzAqIbkTzO/LLwlCwsuWIOcZHisUC6XwB+4BGLDYhqFGNnemf6SfOLuezVv7iUVQC42zO1HWFk2itHigM3lETuxV2yh8hJgaSr7CqGh1YGEzSIQdceGNOW/4Q3FCYWV2+zG9YTAWjsdtuIvaiNik4okD24Mw10QYk4r15HQ/Kr1G/m/j4VfWdvPkGYTGFQ4XqFuBKmWJ+8235fXvR9mlBz+EyJKvZ3h3UAXW6B4u4qdg8Ok5hj1kS7MIQZF6PWD2bAAMzJHkK4GNjdSirFzAoJtVNX0PzWHgA++TClwwxx9/otkgncwS7T9tqQvOSd9vV+KP9Vx5lXmouqsjnXUarJCW3d4WStU9DV5VGRwsQz4c0taehH9Kt9F49CsmU7d6W0zb2lYP0flEui9oUC6tdd/ZeNLnI95JuPOx/psWwkgdmN93Fu2Zcjzn5YczyVzvMGFJh3v70c1gbCNHM49+CH5yOS6c2h9Y0Xg96n7b+OsFme7eCidl/ExbXIZdzTxI6ru2V7XDb/N6DKsuYZHn7CnfILziN8XJGxUyKHHXGBBHoQoJQ7QWYVIl2av/Pk0dvzFRXitbBYXkNSYsRXMEwinidoUGOuF66UxZ2BTgqU8/yqEMENUkoWCdtHskoGqOr+i9UhSCYYmCdaImy0ppkKCmAkv7a+7mZRsDewzxFbp2e7OzQH9/fvRWjkKs1diMpRSbZng0v/zz1aPFsF6vkDOEZMW2rUl+gAXqJWIvkiwPzKny
 jBZaruJR
 G15tVWPyUZojj+WsMhEfQPZVdJhiBMJoIIkEXIq1COH+eeO8zMMX8bHn5JZyANHjYbQl+HsXL+WmM7er1ecxK3kBWiF/P1ahEBdErz1GMgnCXD261KTbSJxx6+A44iWrViwd4yl2e1JSwvAcJnrPIcrqx47KRg2tlHsPe/+D4x0pMWmu3CvomWOJRu7NFTqfS3mqx9UHslNN0EehqzEV2roXTWzhB9G/m8MmJpLHLUBY6F8Cd7d26eKLTw5nhf1QxCs3u0OYBt4iFZteDMTPw093OAQZ/ov2pfzOZSRfqulqyyjbp8XhUIRV/PAIntgYkx3HOcYvKl+l8IpwB9HVaUZgo18zrdnbXhVtzoIsNCYej/x+w+Tkeu6jYwHJLfi2+3uzIcj05SvXYnMIFgpQeYXHSX4FpGAu9bNwEM8See7rKVMW2Vd6EwjnmOubSxgDxrne3A0RhgL/uwXg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 10:50=E2=80=AFPM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> On Wed, Mar 25, 2026 at 05:13:37PM -0700, Joanne Koong wrote:
> > Commit 64dd89ae01f2 ("mm/block/fs: remove laptop_mode") removed this
> > unconditional writeback kick from balance_dirty_pages():
> >
> >        if (unlikely(!writeback_in_progress(wb)))
> >              wb_start_background_writeback(wb);
>
> Yes, that looks like a bug.
>
> > This fixes the issue by kicking off the flusher if wb_dirty exceeds
> > wb_bg_thresh for strictlimit BDIs. This restores performance back to it=
s
> > original baseline.
>
> What speaks against just reinstating the old-code as-is minus the
> misleading latop_mode comment?
>

I thought those two lines were unnecessary for nonstrictlimited bdis
but after reading Jan's feedback, you're right this should just
reinstate the old code as is.

Thanks,
Joanne

