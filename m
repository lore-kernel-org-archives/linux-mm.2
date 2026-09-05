Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68241C624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 13:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 418876B008C; Sat,  5 Sep 2026 09:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A27B6B0092; Sat,  5 Sep 2026 09:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2442A6B0095; Sat,  5 Sep 2026 09:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E593C6B008C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 09:20:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B8AE8034F
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 13:20:58 +0000 (UTC)
X-FDA: 85179768996.23.AB2D718
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id 644562000A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 13:20:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JF8Ab0iK;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788614456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uwIV32WsD/zZ7++4VP2rotd5bmAf7SflccOb0estirA=;
	b=Ol2Y1s9rvm9nKz1u8FMDxW5fmisC7bVZLN2F0EJaOkgD9bo6OY2TP/PsYuBtJ19i09KxWb
	Dlbd+ogFKMC5bADcHw1FllFBoqu/DO1NiG38jXAbulBND82GVImdpoIDK40xBqYqRJqsB/
	Am5Q04MOTAMyU3QKATt/d4gvnFtA0rI=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JF8Ab0iK;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788614456;
	b=6CH7h8kAjMRSZPvLp5eoTCkk2eeSvif6Q0YLB4yTpp1b0yq0xs0zptc/McJWfqZ18e2z7L
	NNrEO32UnhSsjS8BnufwtcucBh0WhtKQlcC0EE5XwgNOMHjL0us+F7qx0z0mLdPKLvMczu
	H/FjYwzy4W5FFKBLKgFmUr5o6vAQWyU=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5b0231a3e86so1734973e87.0
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 06:20:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788614455; cv=none;
        d=google.com; s=arc-20260327;
        b=ZGle6TXIPFhnmtUR2oIVFEZVvSuWSRN15GGcJv7YnBADy2kF8aoywVhHuBT3cJWkZC
         NSqSvsNIMl8g4Mu/0Fkqs5HtvXzGG9nXyPpYXBsG+wHOuuwOekMQR81J5NG+D0nzmvxS
         I22ZLghi4usYEXqVU3R3jrHtJHmxNBniSS8zi++wNiCesfMEtobTfNduJi03tL7iqizW
         V3v74SRCk1o7wb6hgBzyI56KffWR7KYeKkgnSYxMssmedZn7SDmDDizPXWG4bWXI+Wal
         M3ZZUsu+DL+HvE6iphkTFuePmlENqB/TZ0w0fUSey9+VwBC+nc2Ri21bso19uEkIKL9t
         IDAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uwIV32WsD/zZ7++4VP2rotd5bmAf7SflccOb0estirA=;
        fh=hZZI2MTYHDCEXJs80TH/sATxzL4gAizJNooojTjKBb4=;
        b=LfJYU4D79YfCbWt1kHOKL8zFubA2T8okUa5cOdxTYb7atS114KR+9VSp1Ichirqh5F
         uni27TPi1YEo+m3qgxjrzgjP0mdy/cd33MtX8+JrlxAOVlSlk0i8/FU2Jg5UVcN3qS0j
         2ErgV9CP2imVsnbjpVbP7Y6xDINTkghdGSB3mE8NMFsqzzTncZQW7IAGnhgQ02nL4mnb
         rlVd/JmImJ909fk3gX9xpeK+EHGUvRDWmzXi6lfT6Jrwv+LjLhMlE6zRbtamJhxEJ0M2
         4WfTpKX/evXfzgb5bhZOmWlB7jCF0DNDL1wxqIrdxLpkIZ6fHUqSxk6CTn8Tzu0nzKj6
         H1/w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788614455; x=1789219255; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uwIV32WsD/zZ7++4VP2rotd5bmAf7SflccOb0estirA=;
        b=JF8Ab0iKdxcjz6uWjsk3SECocJC8bNX8JjhYV3KKMelyv2jzFo9kEA+mCvrdkjdAhU
         8BIx5MYoRHcyEqLd2Y/3/qkTi2vDbEXvkGxh++Xr59ml105lhIVjWm7HvSnYrWp8bRHT
         m95qMcsTrruH1bciAF/c4RuKT06ttmpkZXNxz+0qy4R3KLzybWybJG8to0EdfFGH23LW
         PB2hSPBDKfuSnRT/RuNFoGfAUweFWuKYeb3Gtcji8lP6tpovaXy1flNQtK9jAjXkFTsG
         +6ekfbtYiW3aS/BeO88QGVSq6gn7dKe1wQK3JNB/EDSoXtQcr5nQyZdfZ9jw+veDEuKQ
         l8Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788614455; x=1789219255;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uwIV32WsD/zZ7++4VP2rotd5bmAf7SflccOb0estirA=;
        b=qDWL7aNz5jZ3YLJ6HVb2W2AcPq6We5uVVeMhKTyknP3FxbCjtp1fWcwugODWn+mYbe
         9ov6dIoQzFM4/W9iWHeK3KxX8zEpJW64Gt8k9Tm76JvFqhOXapCdMFIo5P2/tX3BZIr+
         AvGI86Q5dYCQnCiI2Xr+gzzTIkWGHBVFSr8v8PuJKaaXbUSZYgr71Xra2um6hcHATQwv
         4YxX6W0sHGiTQjRHQTpSei8OqRtVikf+66KDl9dSBqbnrmLXoxpBa4cyMcX1ARkwaJJD
         UR7GAFwLneOLip5T2ij4J3jqz3Zt+ju+GRtCYIMCN9YRczhM7WDrFw99yUtlatWFpLxb
         CWMQ==
X-Forwarded-Encrypted: i=1; AKwUvBw5+Xi1chQsru/4zuln5OAnk5GSe+1nDpDFqfEbicpq44Z+BV17S7uMbwFijwyBueWSjkgPmafgtA==@kvack.org
X-Gm-Message-State: AFuF++ktV7kHIKMq9P4xdc1AOqHttCjjCybF7nHkIP89tBXry06fSQE8
	g4aZVbYhRa21MCkdWpXRIHBtPAqb6C96IPrzrluZ9WAE6226vwepaoYzwF8GoDrACahX6zLHFxd
	DVGlMkjcEA8AHXvOKKW+Vuk/Q03jtoBo=
X-Gm-Gg: AYBFou0t4vermc96DOMxBAcW9Td4+huPQhwY/sdY1sYdyZYY2arFHgGzs+j9sTmEB9y
	XNgqjspbJ04rYmWJG0pvFUhyZYhtIX3EDZU39kVYwcBrsynTiIe+McUl68uaWhy8nscbc2ptwWK
	xKOGW0nBG4+bID+c1+Yximb9XF3U9nAdkFzRoeoa50QOBSklHh7uvU4r7gPu64ZayLnzzeuIECu
	tGgiCovqfnyIMTyzaQsKWHeJsg2RsrUdAuoVUFS4pGXFEaMtSZaxt8BTBcIJozyDo3wq3CggVc5
	yxPz4h5vJpUuVzYj4FF805+JV8J8+St4HR989QxgGj3lsvrqHx3YCRmNQPHMq/b86kzGms3Ezas
	=
X-Received: by 2002:a05:6512:3f0e:b0:5b0:eda:de1f with SMTP id
 2adb3069b0e04-5b616f02096mr2059293e87.6.1788614454269; Sat, 05 Sep 2026
 06:20:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260830114731.8322-1-wujianyue000@gmail.com> <cover.1788528216.git.wujianyue000@gmail.com>
 <5c4f72f1ffbd5f15d0b57fb1a87f73b4249ab424.1788528216.git.wujianyue000@gmail.com>
 <CAO9r8zP7LCRaq4e0O_gPz61d+ee6Pt=tBZXQRy4X27idB228rw@mail.gmail.com>
In-Reply-To: <CAO9r8zP7LCRaq4e0O_gPz61d+ee6Pt=tBZXQRy4X27idB228rw@mail.gmail.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sat, 5 Sep 2026 21:20:39 +0800
X-Gm-Features: AcwNN1XQdTnL4GDeFU5BsDnq2fml9cZJZMgkYM195Nirw_rp_dSf65yDkyjMKHI
Message-ID: <CAJxJ_jifBfg+f9OuUSPiYThFU_0edA-XOmuKxbKf=2LNgeWPvg@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] mm/zswap: reference the pool by id to shrink
 struct zswap_entry
To: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 644562000A
X-Stat-Signature: x5geyiz75e1fjehbos8gbgsn7boa8zce
X-Rspam-User: 
X-HE-Tag: 1788614456-888793
X-HE-Meta: U2FsdGVkX1/zRf6DgfLf+TQ9IaD3+y/GZgEzB+nMF9j+rmTlyQMo1tVb9EgwkUT1OXzyYDKDgKuGsUzTZbX2wpNwtPbswg0c1QmSCpPsHMeCAXguOu9KDJovRyH7zCY2bnp0neSmLC7hA/0tnJPweuJrNgOXoYDHrBzPGJY8WVZ5txzyhOma+gj+bJlPTt6NyyXjPCE0JNUN0W5YRfKmQFTSiVYdD2H+YEDDIqf7wOfMbegy4e8o+JpjBXNZ0oXDamL0zl3mNKoGnymRAf8X3GA4dKYyWOJRWsv6YOgxNV24UWZa4sPQN0BTEVoldbxZiIoU0MKEX3tg0I0/vWCrkp/dQaDDv8O11Lz7Hzj1kqWRsQ5tu8j3r6gRdryKDYdyQMK54N50dQufzqAUtUlqfqK6aTZwaOCS0iE1IVxYRV+brcEbRFVnjRxlEAAimz95crIlmmM1gVm/0wdkYOcHSr+cXCb76LTSqZ1BUc7D+yTaOaqPH6kEsoAmWG29lz2E6XwKKHNCWN8a1hbuAqlcWK1WETG16Yk5ybWE353hqIs1oWAEyrsoMzWMw/kI7LbP5xucnXKD761AVT9lK01G/Hl38+1n2T8mlw4gtd9Y0fxXGdgCX2WV4c9CyqXeLRisMjX60YUBF8jXRWlRo6ROOfwDB++8PBxj94YNlTnS8fYfgH7lNsmJx4coxS6cPD2Zv3+/SkEkStBkYK0twMqE7nI1qCJqr7bKLvairlpYmXc599cTe5P7sFHngju0k1nEXngivM67Js5BCBk3dpat9T2AwOJa3HQv3B4GvRr2mxhaB0UR4JKKggUsxj3HLCAPQzYS5tZh/dierlgIfyiJBScvnmal1tXJOA/Kw66JCFqBzRgZp22RUVKNx1wl8vYSAYYGMMQ3KGdFLLZk5UFdXtZ7ht4J5CTSBjYn6L9ZNuYPX+KepDHoVaBCLOS8V4pQf3MKxoPSPYwz6U7QJ/V
 ti4b27K6
 k/MlXZs+iYh0ERTlkpDvroJp1aJ70E86mrLFmaVlx9+qdbJUCeiYLWpzqBTBcbp0KfdnR96ZIajIsix51AIArnUn800oupZPra23W5kn8cqxcuuUoBQEWCVBbwGHIjf+XGCJ0XQj4u0RiqUxWKxloMi5UirwCPN5opQG29e7O4Zy2zDVXTW8Rf63Z42FvTqJdq0XwNAsAkkFbbYjPFlUa/NgbWvwqL9AZfZja4H0iNHx9Sij5Kh0lV1bpH9men7cwDxFREEJmVmGtlKH3+5Rx/wroPfNdeXyho8Wi/lRxI+4bbocot10DsNpOiyMEMKix2keIxSOPmdMWyc/ZhPTY87BQPsef6/yn/wo+wxhixqx7H6greMt2JrP6O9WVzP/p6nuw9/VKylO9hU30N8A3QPlA4RNT3YJsbdOGcIKrHEDb/IAosxmHwGSF8slVLc9r5N2nVuB6xb2Y2n2cSsLcR61J1rQMXOAs+wQq9YrIMpfke5YUb4ANsjF8LQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 4, 2026 at 11:38=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
> > +/*
> > + * The pool stays alive after this returns because a stored entry hold=
s a
> > + * reference to its pool (taken in zswap_store_page()).
> > + */
> > +static struct zswap_pool *zswap_entry_pool(struct zswap_entry *entry)
> > +{
> > +       struct zswap_pool *pool;
> > +
> > +       rcu_read_lock();
> > +       pool =3D xa_load(&zswap_pools, entry->pool_idx);
> > +       rcu_read_unlock();
>
> Doesn't xa_load() already call rcu_read_[un]lock()?
>

Yes, xa_load() does the lookup under RCU internally, so the wrapping
rcu_read_lock()/unlock() is redundant, and will remove it.

Best regards,
Jianyue

