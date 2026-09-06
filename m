Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A01EAC79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 09:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3EE16B008C; Sun,  6 Sep 2026 05:34:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A168C6B0092; Sun,  6 Sep 2026 05:34:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 953576B0095; Sun,  6 Sep 2026 05:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 748126B008C
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 05:34:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 12F8C1A04BC
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:34:07 +0000 (UTC)
X-FDA: 85182826134.11.5EA1053
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 364AC20002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:34:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l5YNe6R6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788687245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hilEVd8ul6m3JKTfhkSHsr0Cslnn0G4vY5ntF4Ef4P8=;
	b=YvxKtQDx58ejOQioLYk+htj0fnBJdKxG8eSIgD1yHJ3WTpARnb/0hTi2q2j/dJ1Mrr5LBz
	ZeBNSuOs0TWWdrgxYSU6ZVY6ybWwXleg585iorRv2EDQVU+fPYVuxWfzqAHxbzKfbUKXYx
	s2rlJXjPhyIBL8Ql8rdxu+nJKFRRYEE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788687245;
	b=DnrwPps2Cv+lF4xJ6t6peXn6f5L56K06UahPcxqw40ZHbN6WircE4D1k5FYCK8n7XpygmA
	x+TFuc4bcYazvzG2Qscmr5tR9UPGOg/0F2xbz+hLcevbtc7A6NYjmBsp1pDhSQHXAzmmg9
	WJAagdrUNO3iP8e/VQsAECE+ZjuvKY0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l5YNe6R6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 11E964343B
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAABD1F00ADB
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788687244;
	bh=hilEVd8ul6m3JKTfhkSHsr0Cslnn0G4vY5ntF4Ef4P8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=l5YNe6R6Kv5j1SCpQjZD36dmpiy/doa5vpidNZ9ksQRC8RhjMdxgqKGyeeTg7zSvp
	 fkM/e2pdSGdyAKx6TlIxii8PTF9D49iq2wiFCW55V47DPW8b7pXTLeDMzORMrSWsxy
	 YuJFdLojsxRNA8HTUj1qs5/5tNCKatNTGwEmbw7nmLUKirkYjMhjGvRJ0WmcRpUewD
	 LdQohpQDhNdAFDM8u2+OLWPJExW1VrZb10uNECjn7sErIrK8sGQdYFTY+2hgEToT+f
	 LGoofGbrIKYzuAHDwDeEkjeTEXLEtqpZ/fR+3fGcDIuIBChN4anuu5NiuIUSZQZRUf
	 hpPs5TPo2XvdA==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c250f28f1cdso389410066b.0
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 02:34:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByP36WUS8llbOsis1Rs/rkYhPkF3PuavXDjVsUpx4hNlCNynYSqk1f5yg8heaCZDtCx/ktaklulgA==@kvack.org
X-Gm-Message-State: AFuF++k8pQP9QisfcDdNXjx5MSRFk/z5RNyJ//gp2l6Yio1wz5dCuubp
	f4jV8z2OcIQWAejSNQC7ZbmHg/aa0eanIvroi5/GCPVPF/SaItiuIo6ssdNAUHK22/w6174+OP/
	WCBpL0caB7xTnCQ9iDEkvZ44VVbLB9Dk=
X-Received: by 2002:a17:907:1c90:b0:c26:19de:9ad3 with SMTP id
 a640c23a62f3a-c2619dea762mr534286466b.43.1788687242859; Sun, 06 Sep 2026
 02:34:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260906-shrink_zswap_entry_v6-v6-0-ac4cf61565fb@gmail.com> <20260906-shrink_zswap_entry_v6-v6-3-ac4cf61565fb@gmail.com>
In-Reply-To: <20260906-shrink_zswap_entry_v6-v6-3-ac4cf61565fb@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Sun, 6 Sep 2026 02:33:50 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMBYv=_Rd_vSRHnZn1KqnxU9eNfhuA-aWfiDOGfxtkwaw@mail.gmail.com>
X-Gm-Features: AcwNN1VqoyNkZSh0Ex_D1Od1IyHBhtySEWsBIkwlfXBjpxaGQw_R0ENTuud7GJc
Message-ID: <CAO9r8zMBYv=_Rd_vSRHnZn1KqnxU9eNfhuA-aWfiDOGfxtkwaw@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] mm/zswap: reference the pool by id to shrink
 struct zswap_entry
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 364AC20002
X-Stat-Signature: takfpb9bjrwht963qyxz6caffhsbbcsk
X-Rspam-User: 
X-HE-Tag: 1788687245-361893
X-HE-Meta: U2FsdGVkX1+jhccTg5YAuwZ9qAh8A5Wpc9u2m9T6TuC0WFMCbJPg7MYqZph79hvtcY0WhkBTK4IKWmTh0H1WX2IsucApQomL1UvUwtKYdhurU6yPdMZsDCtvSzgc9a0mJyUUsTBrDP3idMXsMRMDflosndcfSQWkwdq81lK5CH4GdTCPMEKCPr+cCnaVIQz6YxF+UveB24UCePFt3xne3A2D76xY/v6RslZ9+fQuDLwiC1NcNcD+Jy+7uNfnov/OrmL4D3ElA7EXzLg7c6hncqZhIxZVmysTpnMF1x3EuuA1NFLzYijcn9V7ClZgoh2hkCy4koIwn6KQ3GSeNYJ8Cnj6/9+CCWJgVbAyBeZHSiKycT1BiML292aZToIi4ylq8IbE+gE3weCBYEwM95SrupEQ2SCFJ+IpIAxOtPVfxgPTs+iweYBK3dMZLzNoC0l4AwjIQLhQc+rBgtqCJGTrsryvLFkuVCuUWkc4ohN8URszFeGvQLKMjUbrJ3RwusSWG5mW7T+TQupeP0f9tWRP4H8ipNrEDigvb9BTcx5OZ9yc8JumxkmZDzoRiMB6TA1g4W7YBI3qWPpvBmBJvPk3c1qD+OOIgO4ycebXF1/p8RUVu84IAScVK9sU0kJYke5yF/hceC0+zt6CbbTrdiRZrhi00G7/mLKKuCIRxeW12AlTmi/RsAEhFI867KA+KG+GkNfJcT45SfWO8r2NSP7+9tjUxGMXlFiAopS77asgovfphv+RZa/c9QeCW/Xa/clVtKhBPNajdAzxiugNaEtUhvspauD63D3WmtfO4tLefwCEMyGwx8+wZh+IdMiKH2fpySlxoKXvKsMqd9cG2yRv7qcdxzbLVKT5zuaMidHrbgIfQqpnGdkAWkHBoN2c5AMrCobBe35/lSOipqHIWH9k4Z4wLQ8vJbVphIaElIZZsJpYlVWaykfUkkvVZzrummWBtPhMJ+4GlOPB9GdlS0U
 TzXxsWzr
 jqKiAV9vb+O8xd/2ITAnPO3ewNRocviVRy/veO6nm71yp72CO/y0FUR/ulOmfQQc3Plm+u9TBRHDBL+e+cuZMPPJDj2ir5kS9l2gvuRMgN/vDtNdJ7J7nEmYs/1HDFx8VerIJ2FVfiXIlZsiKw0aGXCUgHkwCANnUWksbX5LAKeNvqPQNIgyxZwZqYsdHjuW1e4lLIGkQcVi3O4J0jIdxxT1CCGcwzJUL1mpHXrLDMOIUhMrWsFowi0BIHynwfpM6Q0ZRGIUcnubjxmMQ+HqRt1v69xZmSAqDHrLic60zArmSpXbjOFdBUZEPNyliW07/reOGSKql2KDFB7ctHacYbJR8X4oJiYoiXu+nda7oL1bszhDPecRpxE810w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 6, 2026 at 12:47=E2=80=AFAM Jianyue Wu <wujianyue000@gmail.com>=
 wrote:
>
> struct zswap_entry is one allocation per stored page, so its size is
> pure overhead. It currently embeds an 8-byte pool pointer, even though
> the live pools now sit in an allocating xarray keyed by a small integer
> id that fits in a u8.
>
> Replace the per-entry pool pointer with that u8 id and resolve it
> through the xarray with xa_load(). xa_load() does its own RCU-protected
> lookup, so the caller needs no rcu_read_lock() section of its own. The
> resolved pool stays valid because a live entry pins it via percpu_ref
> (taken in zswap_store_page()), so its id cannot be reused. A live entry
> never uses the reserved id 0, so a zeroed id resolves to NULL and trips
> a WARN rather than aliasing a live pool.
>
> The u8 fits in the padding after the bool referenced field, shrinking
> the entry from 56 to 48 bytes on 64-bit. This raises objs_per_slab from
> 73 to 85 and saves about 2MiB of metadata per 1GiB of data held in
> zswap.
>
> Suggested-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

