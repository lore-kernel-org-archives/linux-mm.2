Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA202C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 23:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 877766B007B; Mon, 20 Jul 2026 19:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B556B008A; Mon, 20 Jul 2026 19:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7191D6B008C; Mon, 20 Jul 2026 19:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 389926B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:44:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90FD4C033D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 23:44:27 +0000 (UTC)
X-FDA: 85010786574.24.400DD5A
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id B614B180008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 23:44:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZUXQUDV+;
	spf=pass (imf16.hostedemail.com: domain of linkl@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=linkl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784591065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=riG3LbV3k8BvVbdgieZV9J6mlRu1bGRgQczBpq3mS/M=;
	b=h9cA0zkP0ljslT+bZn+w+RLiz+LCBegBkIbeTyjs8y+RAAW0jmrpUf9kn7mXnmkiSV6tvF
	vMZw5Dcj9LQMNGeWTSYE5m+MKEphiG/GrzSuQ4SYZjHfvxn1MM2Xw+ZRawDPKGhl2wQYsR
	yRSVLhot7/Ir6CEyVwEFpejSN3yzpQY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784591065;
	b=y9Sn9N9gjjr2hKzZkRdbXFOAma7og5Ci5rP+wXk7S+ylz4X7tSgvS8J4Aia6HiW20ERsUH
	NwrPN/H6TrSc2aaLymgkeC607bgqtjDGXe9gBh0WqSvKoRYaug+JIzVWbdENf49oo3JLyj
	tY44zFxH0OVouFBuZnNqGexO3ciA0AI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZUXQUDV+;
	spf=pass (imf16.hostedemail.com: domain of linkl@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=linkl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cede6375caso386795ad.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:44:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784591064; cv=none;
        d=google.com; s=arc-20260327;
        b=l5ooPDWqROjmrwOA5ySndaXU2G7upqcF1y2fvwfat6Rqv2faYiS1GFc9jwyGBVxwX/
         MhfydOi33tFnuxXvv2ncXwxBA8qImYjnBGQ4zJpPfoZmNQIpMCZceFgNLIwxrc+CKkO4
         ZhGZ/hQ28anQDatFtrJ66XkW17jDYjXRPnyA+b1vdD+V0XJiOBCq4qw50MocMaB9zEeS
         AY1vle3PKK2HJSODw9mnIp6tAukf+GEGVbn9i9tkHiHpSVSJeFzLEzUlDexVZbdzj+Od
         7VpZxSX9hAjMRNGF9nja10f8swEKVyYFGyHZu+WSWv1lt+6pWeROmTQRlZrrpvYclzWX
         Rw3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=riG3LbV3k8BvVbdgieZV9J6mlRu1bGRgQczBpq3mS/M=;
        fh=SbyWZGmN2ZXcJSGlAiqk79HTxqATdtsh10+VcpSWeqE=;
        b=N1SSK9XDeJTscckAd/6PHeEb12+y8rRHxWkNb/AC7Akztjq5bkNerigS7mI0xYWvJz
         1P2heTRIhawZ/sRdSoUz6mE/HCUAEp91xA55Sy+YcuoeNMT92Z0PHG5SNKFUtjlD3qbw
         9cIN7PFfs2Y9/qu9Aw6BuL1aHUEpYkCQBpe9INZNG3mN2fZR7R+7SFMriCTEcWBUHAFi
         tC1vwiuZ0JhZTDmIK7QM1lnfaUAaRcUbsjzbRnn/tLCTXRiwMmtbwoecU8oizQQt+r6y
         y2I6Vri5N3YQbjvxpMHa80KqrPKupY8wnaqwi/v2axovXSH9PG9se+fNYWAId+dK3WvV
         SmKQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784591064; x=1785195864; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=riG3LbV3k8BvVbdgieZV9J6mlRu1bGRgQczBpq3mS/M=;
        b=ZUXQUDV+PMHtPCfjBqTSv/cnbOhJ2PrCbmNBPWgKQfGLeLdHyyJMxi/Ga3rAKadA3R
         CqQC8TY1NOjD/JpHGEDyJHOczhOJuE9UNdaN7rE8rxNmQb5xPKatw/RCjBr8axqR4cs4
         ZaQjq4BVUP7GhTVYaLLZjAdhXk1Ef4cMtceUyMkXMtzc8hB6rOPqpLwc6AXojgq5zfRh
         4DtjiTRUf2lfz/Pv3nEI1YZ8Ta2KhINxivzOkM7+RHaiLLgA7P1wDc8I9bp4opEvgWRA
         jvlNq081E58Vmv8N3EAWmbBJf2iErhAZqJnB0Gp46ex4YYDK/sdTw+n35i6lmCHs7Z7u
         uueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784591064; x=1785195864;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=riG3LbV3k8BvVbdgieZV9J6mlRu1bGRgQczBpq3mS/M=;
        b=aRR9lRTCXVn5u7Ti3dQm0V2NeBUHayTdDwucakc0cwfLDJjmV3WHnBgCeXCIBON+Bh
         DraxWzaUMsn1nmcWdLLxV+AooJQiQIFOseWmHjKLPQIanPcsPh0myqU7ZDOSih2pAr99
         V+vZyjxWB+BncNoXGz01Bya5BoTWPTrmi2z5YSUiN+zM767sSP4LhbVblmY9Yf0h9cKH
         Gz92MDDMhckHo0rENVoS8eyi8cS/9M//P6NIUMVDNvO3KTpdRNmYaQhOIHaB4gbCx7oH
         Bdl0dNib56A54/wcJy9AOBMnTDZfrIfDDiB//TgF95Uq4d98H8xfLdhIdVtS8ncYGoil
         HGDA==
X-Forwarded-Encrypted: i=1; AHgh+Rr4/i5WBpad+YqB9Xv/e4Rfs3TFDWoUvTDVm2bYBLguNlIkB3OdJK0uuK5tEkh+AhqOA2cMjVKm3A==@kvack.org
X-Gm-Message-State: AOJu0Yz34KaeuhqZBi2TCZ9Zf5qBkntTSFkYkpr+I1l/2eTToE9g/n5E
	q/fjllMUMPdigeH2ZvaLT9hEKzxzZ1r5RCR9k6+LO0E9TXwpleIL5q6gBVSXzWP+L1SFk5jjwsW
	1CJ1t/n8GWqZfhSKddXLjbWNZtxK2/eDmsskYNWIt
X-Gm-Gg: AR+sD13LTjQmZJPGnx10VEThJegMr/ikvuaX9trRHCTpr7wIkOXEMe5oU6rJ3h2jrs9
	MxTMeP9pCb6b7apf98CLjwgJM/gRe9P6bQL4795G3i2YjMiGIB3xlvuTf7YEy/NBKuRHJR3JCEs
	uMh2l/1q88X+VJ6z1AJSXbmlDMxqAITMSMCF7lDISeamNIyEw9HX4hHRe2ZNnDR8Ku0FsuEDF3O
	OesVdClldWWzfHE2f08fMF15PA5B4AvJx69xultyb7z35n6tCd4TsRSF0zu4iX06gwTWOAmhlms
	5Dsg5BGv33rRYZHv
X-Received: by 2002:a17:902:c94e:b0:2cc:a859:d404 with SMTP id
 d9443c01a7336-2cf7b6d3247mr3540335ad.23.1784591063975; Mon, 20 Jul 2026
 16:44:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260717002311.681748-1-linkl@google.com> <20260717002311.681748-3-linkl@google.com>
 <29457fe7-0fe6-4bc0-81a8-9e67f85b3a3a@kernel.org>
In-Reply-To: <29457fe7-0fe6-4bc0-81a8-9e67f85b3a3a@kernel.org>
From: Link Lin <linkl@google.com>
Date: Mon, 20 Jul 2026 16:44:12 -0700
X-Gm-Features: AUfX_mx2yFU1L9Gcg6BFQSpQ6hI0WeLlvWjDg_00zh0kZZHsctUEsZJDtTWk7bI
Message-ID: <CALUx4KT_EPWmKhEb5hTD2tk5k+WU2oT+q9Bwk4z1sHBKi0ZJ7A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] virtio_balloon: avoid shrinker execution during PM suspend
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Michael S . Tsirkin" <mst@redhat.com>, virtualization@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, prasin@google.com, rientjes@google.com, 
	duenwen@google.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	Ammar Faizi <ammarfaizi2@openresty.com>, jiaqiyan@google.com, ahwilkins@google.com, 
	Greg Thelen <gthelen@google.com>, Alexander Duyck <alexander.duyck@gmail.com>, jthoughton@google.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: qa6exqobumjo69xjfe8nc3jk664yyn86
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B614B180008
X-HE-Tag: 1784591065-907695
X-HE-Meta: U2FsdGVkX1/may1Ae1nowv0qzmdF4RH3JR8GrheGmIbucTCTjvuzuc+UHZL/tK7Z6i/M0R4KhicSglu0GEWx4jZng7htscB80mqdRnOoI6gTsTnI2zdH2Oki0pAEj1lyAoe3XjVSEMd3c6zC+dX9iE5r80Ez3HEE54Rj3D6Pxz2IqhCEY30DwiBHYfZLcVMbJ0/0MYfiu3v9QiWJGLBDwD87sUimmPUU+D19bSM6LSYrDuPACjKeVLWXNUUCR7IoaHg9/W0aHKl9YwwQ4xmRnu3dZpWM98sQqzx85YC9jCFwIyaragOyYWIPeNX0VqvjSkfg2OSmmWSGbkIoXKP/S6M3VZiKwfscrmmXa6KS/97yP4Akomg8Hl0kkOSa5zHRZwArZn+z0KM1sAJIlwtMGKlcB+3e9M8lazvOR39krM9nKQrFZPJVaXIy+YPafDzCcUa5nhNIQCnVPRkpS+ot5VqFSfe4ZBWXlYReDSS7gwmeLruFse6DXzi3VJcECHZpBbdPly0n5eH2st81o2SC/pb4MXKPQVYzHezmk+YsQDMCs0AqhDtIsLBskJnoIo8UY0WU6O/1sQRte5GglTBxLo0jkysBxsOVal4NAVBeyp5sMO5xpBjXd9ydaDCknijSOFFs+g8R7J7M0fnMjsZI6SOpGm8yczIHQHK6GiittaIVF7GRdlB3ETdG4MWbDeCB5xqdSmvTSlUqkQgwZQEPGf3rWF5KCl+iuiZvxekIaKZLr3UB0aleigIWpK/YGyoXGMkhXLjqCCrw8Y/XEghNpIKGHx2qFA7QoB6q6zISJHWxPSPEwO+W3a8vjxhYnPaByJ/f31xEDnfT2b8XsF692IgpXKrKAnxl6KK/znMadAseAzCAueHZ715QcAyzRq4dZPQYj0VnYGBZo6TcpopqMJTiwle94isqYagBtQuGen47IUAa8wpYllSiFIE/0QK88BYBsOaTDk+m8B8WPmx
 fTO43kxR
 mpPjBFhNqWE6fn51ysrmd234ZSsLxI/jYSld8TKgnftIeSlq124UCRypaRrf6d07yz/nYiX6TKFRXS8yadCkZNZMebvFEUKr9wEF/vTNC/2A9gxzBAqUS+leWkgw6XM4XQ1+Y9StmhvhFUCz4lLtpW867DhCPlnzuW/omn5xQqGgSLXfpdAcWfOmF1RP2Hmu6UJLeqHms2Z8E5mTPRda/8b+PimSbfqf6UaZistohLsc5+cFv59jf8jMNMZkD5JkuNJwzni4/wgr0Zk7BMcula7tLGCdrQ7XeXpuFsyKfmBI+TYqXTPWvh4CgQ9Qt4Xqp7ukNcYWeVe6VhoNeXi1AFZRmmc8Id1uRwuWgB0Mh4EwzyOQtvZPPNoopejsJd3dwab2M4Uko5b6Tv0wJ+obQpsa9iuog8uwks14/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 02:17:24 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > reclaiming free pages under memory pressure can trigger page reporting
> > which might access the deleted reporting virtqueue if it is not yet
> > frozen, or interact with other parts of the driver in a teardown state.
>
> i feel this is the thing to fix then? not the freeing itself.
>
> ...
>
> this is remove, taking locks seems futile - if something will acquire
> the lock here, we will be in trouble.

On Fri, 17 Jul 2026 11:30:44 +0200 David Hildenbrand <david@kernel.org> wrote:
> Why not set the boolean immediately after this, and call it "shrinker_disabled"
> instead of "suspended"?
>
> Then you can keep calling "return_free_pages_to_mm(vb, ULONG_MAX);" here.

Hi Michael, David,

Michael, your intuition here is exactly right: the freeing itself is
perfectly safe, and taking locks in the teardown path is an
anti-pattern we should absolutely avoid.

After re-tracing the execution paths based on your feedback, I
realized that Patch 2/2 is completely unnecessary.

The FPH shrinker doesn't touch virtqueues itself. It simply returns
pages to the buddy allocator. While this can trigger Free Page
Reporting, Patch 1/2 migrates the reporting worker to
system_freezable_wq, meaning the PM core natively guarantees that
worker is frozen before virtballoon_freeze() ever runs.

Furthermore, any asynchronous FPH hinting work happens on
vb->balloon_wq (triggered via config changes). Because vb->balloon_wq
is natively allocated with WQ_FREEZABLE, the PM core successfully
freezes this worker prior to virtballoon_freeze() as well.

Because all downstream paths are safely frozen by the PM core, a
concurrent shrinker call during suspend is entirely harmless. It will
merely return 0 (since remove_common() safely drains the
free_page_list anyway using ULONG_MAX) or safely execute without
interacting with a teardown state.

David, thank you for the cleaner `shrinker_disabled` suggestion, but
since the asynchronous workers are already natively frozen, we can
avoid touching the teardown paths and locking logic altogether.

I am going to drop this patch entirely from the series. I will send
out a single-patch v3 consisting solely of the page reporting fix
(Patch 1/2) shortly. Thank you both for the rigorous review that
steered us away from this unnecessary complexity!

Best,
Link

