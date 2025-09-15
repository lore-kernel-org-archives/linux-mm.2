Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FD69CA101F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 05:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6348E000C; Mon, 15 Sep 2025 01:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D66DD8E0001; Mon, 15 Sep 2025 01:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3C58E000C; Mon, 15 Sep 2025 01:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B72B38E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:39:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 05F8511A0EF
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:37:39 +0000 (UTC)
X-FDA: 83890377438.24.235410B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 020C9C0005
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:37:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eeIzYdiW;
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757914657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rR4nvuLB68PWeoEq6OrLbNMctFC5H6hheeaS39RYv7Q=;
	b=f7dKeBLbLsop24xpD6GpgE3HNqcA04xnYBgdBdIDeEuB4jiW/9Zhk3BGNt0cRxQhosw56H
	Yz9hibG3F5Awe9dvfJvYue6zXXGMzJHtiXMd4zWtj1n+QbLv4xc5dR37qMVXOD34FWZlkS
	jB2xjxnTgL5Ikdk6vCsjYwaWdRytR/4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757914657; a=rsa-sha256;
	cv=none;
	b=58spt8Zt93qOmwJEUlroscxKvrSGMrdVQwDqNwCYL9jsHBrJNBGfULOX5LFPj8B7MqzQjO
	YZICcyqUyazl8wL+uebKIkb0uOwsy+pY+X8JFpcvEJVU6Cf+uKFRa2IgwQ6sgSk0FBJ0Ru
	ZVNTlh1zniHqGfRPhfHIgABIW9taqqA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eeIzYdiW;
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757914656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rR4nvuLB68PWeoEq6OrLbNMctFC5H6hheeaS39RYv7Q=;
	b=eeIzYdiWz4HcnoDDSn3zFRw9owWV0oHrIEdUVXrhFR7tlGDsF8WJdaYMjEO608VXs5Pd7V
	zVVen2hkjNWlNjNaCXe06dNHCrkbCSiw4mSTDwbTRHqteg6uQOS414YHmYNT8livv3GlgF
	8wBU511FVHu0h8Qg0JaSIxkWPzyB1F4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-j2IEoyyDO9S2fP4RaYfzeA-1; Mon,
 15 Sep 2025 01:37:32 -0400
X-MC-Unique: j2IEoyyDO9S2fP4RaYfzeA-1
X-Mimecast-MFC-AGG-ID: j2IEoyyDO9S2fP4RaYfzeA_1757914650
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 52736195609F;
	Mon, 15 Sep 2025 05:37:30 +0000 (UTC)
Received: from localhost (unknown [10.72.112.195])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC8901800446;
	Mon, 15 Sep 2025 05:37:28 +0000 (UTC)
Date: Mon, 15 Sep 2025 13:37:24 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: glider@google.com, dvyukov@google.com, elver@google.com,
	linux-mm@kvack.org, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	sj@kernel.org, lorenzo.stoakes@oracle.com,
	christophe.leroy@csgroup.eu,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, snovitoll@gmail.com
Subject: Re: [PATCH v3 00/12] mm/kasan: make kasan=on|off work for all three
 modes
Message-ID: <aMemFIM+T7PBrx1G@MiWiFi-R3L-srv>
References: <20250820053459.164825-1-bhe@redhat.com>
 <CA+fCnZdfv+D7sfRtWgbbFAmWExggzC2by8sDaK7hXfTS7viY8w@mail.gmail.com>
 <aLlJtTeNMdtZAA9B@MiWiFi-R3L-srv>
 <CA+fCnZf2fGTQ6PpoKxDqkOtwcdwyPYx2cFwQw+3xAjOVxjoh6w@mail.gmail.com>
 <75a2eb31-3636-44d4-b2c9-3a24646499a4@gmail.com>
 <CA+fCnZf7jYPUyqHqonWhDKVi9eeN6aaaByMTBYCQrv2-8+hngQ@mail.gmail.com>
 <CA+fCnZf0z526E31AN_NUM-ioaGm+YF2kn02NwGU6-fmki-tkCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fCnZf0z526E31AN_NUM-ioaGm+YF2kn02NwGU6-fmki-tkCg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: wfoyubzizb73ejhurkftsab7psjxozbc
X-Rspamd-Queue-Id: 020C9C0005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757914656-834002
X-HE-Meta: U2FsdGVkX18YGOgzsn96TVPvOkV+SZi2FPvFshAdrprGKtO4hGyDIm6dyAuvzhmwtWbwo1aTf0aT9VlRR8B4wnfdga4DKr6zzFtabNRhLwNcginv9XD7H3jEvnmbtbYTXPyt2iglIJrOYoT8eenDTP1ep8GMW3LeN0Mn6Wrf61+BGK1Vx5/Ths3I34PUDDxgWT3tDSLoVSEvh0xQRGqoqh1gNtnnNNftHqb6+Px0aDejfTHA/VkNwzk1hs6lRZxSb2aVmIbwPTSszO93N5DG4TRaoU1OpP2RTaryabi+TKEffVuNEuoL0nFUBDOBbUuRqWH3bfmKRTvhfl/42PO2MFxGsQIrJAEhU5jCOvu24iePpkTNIgXh2vDjX2Nwj9qfDiGIi0H+irRL5yMnM+UurHGPfI3o7C9IxG0QXM4ij6kj8uw1llipn2wqDxnATy6kLfyF/t69wH8VMSPP7DaZ3WuaOhQCQO2/uAllkVo1nyoedchA1A/PA3d7W5qk9/pKqdcR5gYEcnamMD3vqlB4x010w1S36Kw6WOk5ZMNPqQE/qUPKJNrOkzqQZsNxFgir61fFg1IVVQm7DmrEWdb65TsSDdLLAgBrHda+IbIIx2teDQ8D8ETGtYrhdbrUBYoEkzl1RNSTHXos840eSyvcMWg/US+zvNIxZgtm1bmRhpKvqG+A6ZuYt1HG5qMSjm/a51RyzagV+8GsWjk3x1XpHMgP7DYEawemPdWUrGiSFTbAd4PC0ZtFWEGjW5QYKCt+IUNqulk/YpNipeHR4Nny5jP0TPxE/Cptw6TGZZm+AtETngAC3IYhsWHYPsp6syjoNYizaIzY/EGoB/W55oMO68nKWsQK1js+o1FDLptarhmTA5l3XR23HfPtNEE440LkkCz+1v4CNxXH7lWhvwVTubgJb2EUgMtthQ4SRfdpaBu8etg2xv7SJQBeLBjvxnEdpXx1Zh5aRVRDz7iJH+4
 VL9VLGx5
 BnaGmt8oloZziQ5m2dd2T5KGkc33ApOlOGROCSlsqjVQsB2dZP48KllQtK0S8OZCXi6ZUrBdakczg4TABY75kuvvDvJBBLHaNz+wIO6B2c3HVaKBv0aiEpRoc06cUMMPrr6FVZU+kcjwCy0IxVZyeGMJQwXfUKEQl202Pnob+EAXlnjJL03uXH/l2Q1Czf8kpGsMkiBt3S/G+ZfMruqGgrKg+Gvc7qUhD+X9R6X64Qym6TAX510xwjzyc1nBW5ys7eZ82SFJKfc25d/VDqB5yQjYcvrUJjCweMsu7J2VY7G2abk/NySpEMdy/qBsovpMdjGvrFzJffB6zKT6HX9CcwthMqJeEq+4tD5PdZV9HkLo8G99V5miTwH6rJ7Djf5zq5pY4x4xVzxGsfWDB1WAxhg9R+fPiYGoLH1NuHUwu9Ap0rPj4g8c1o8PtoRpBXbzIuuFZqBARLRuGrdY2L8hb94JDPoqtY4j+PozZbL6wTJprQnpgq7tGnQRN2cefH9+SJjA08wm9noN/wwg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/06/25 at 03:25pm, Andrey Konovalov wrote:
> On Fri, Sep 5, 2025 at 10:34 PM Andrey Konovalov <andreyknvl@gmail.com> wrote:
> >
> > Baoquan, I'd be in favor of implementing kasan.vmalloc=off instead of
> > kasan=off. This seems to both (almost) solve the RAM overhead problem
> > you're having (AFAIU) and also seems like a useful feature on its own
> > (similar to CONFIG_KASAN_VMALLOC=n but via command-line). The patches
> > to support kasan.vmalloc=off should also be orthogonal to the
> > Sabyrzhan's series.
> >
> > If you feel strongly that the ~1/8th RAM overhead (coming from the
> > physmap shadow and the slab redzones) is still unacceptable for your
> > use case (noting that the performance overhead (and the constant
> > silent detection of false-positive bugs) would still be there), I
> > think you can proceed with your series (unless someone else is
> > against).
> 
> Hm, just realized that kasan.vmalloc=off would probably break if
> CONFIG_VMAP_STACK is enabled: read-only shadow for vmalloc =>
> read-only shadow for stacks => stack instrumentation will try writing
> into read-only shadow and crash.
> 
> So I wonder if there's a way to avoid the lazy vmap freeing to deal
> with the RAM overhead.

That's a very key feature of vmalloc, lazy vmap freeing not only
integrate the virtual area freeing on one cpu at one time, but also
merge the areas and flush tlb at one time too. Please see
__purge_vmap_area_lazy() for the details. This can avoid performance
degradation when many vfree() are called.


