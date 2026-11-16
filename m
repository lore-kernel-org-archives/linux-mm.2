Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1B88606A883
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=cJIuNXAI
Received: by kanga.kvack.org (Postfix)
	id 1551A6B05B1; Mon, 16 Nov 2026 18:36:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 106346B05B3; Mon, 16 Nov 2026 18:36:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 020056B05B4; Mon, 16 Nov 2026 18:36:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1B596B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:36:58 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 474F616016C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:36:58 +0000 (UTC)
X-FDA: 85442594916.11.9884F44
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5AD5140003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:36:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cJIuNXAI;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794872216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4BpAS/bcGUHjh9IAA6MS7m2MaBa7QH4c9MTUiHX6xyg=;
	b=HKGGnKD3LIN3Te8OcgYr0M9FEMnVrx6VM1Lk5b0WruKXTxJsxtsgzXYsiX8Lb76qa6gXMu
	jXw+CwwQXaQkiMNNra98usqiWhWb83bwiHO+mOYaia85kRTfvMmDRp8yQL73qTjLFejsr9
	H6wi5Mb86P4BYjwF0V9EJCwbnY78xV4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cJIuNXAI;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794872216;
	b=ugqekybvsX1RILfj8Li+ngVDB3KmowBPHgYOi3yDaKSmk7STY8DzkV9VHaFdN8S6dy3Hk9
	s2jXeboca8Jc9dcYp5kavgVZs/USqt17+Aq0yclde52dBKHkrOQkkCzgjIJV71+cUm4T0P
	+MgcPGdl9aQSpr+DrDo8gg3Uaoofp0s=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-53634b8328eso41712031cf.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794872215; x=1795477015; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4BpAS/bcGUHjh9IAA6MS7m2MaBa7QH4c9MTUiHX6xyg=;
        b=cJIuNXAItd8CM/eWj4+7e3vHi5YzBRYX87R59HMWKRjr2cdBt/HNbq/7+krH1wT/A6
         etFg73/ypX1cm6/VNyRWGSFEjIvzQM3Q1EIfX22vJf5hYM6H/BlpdJBDsSwwwP20e7uC
         vLz8vwXmpP8D93yMGNzQZ/p4EvNhYm0OE1Y2Fn/HlJplB/rM0HCLQ2q7zNV6EUvnHU0X
         110MNuSSeAXnEMiVQB/nPo93PUzm267pV/esso1Caqirpc/CC2ZWdBMCyE6qh4c7qx4T
         XUaodqRwxV1d9G4eu8Tnhi4+z7lZwn/h+w01TFGOalZbQmDTsNmrY+AAi2kPE2/DElzI
         ZbzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794872215; x=1795477015;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4BpAS/bcGUHjh9IAA6MS7m2MaBa7QH4c9MTUiHX6xyg=;
        b=H1dIoQ8E6/HXjg3AuRGU0IwFLZ7ktn+bGmJxYbow1tvKEl68qw67HP8mZpGWNY/AT4
         K6yoZplUCLrikFU1/Y5Cq/xisjMJKASsgMLsyhxJy0+MNpl94L+v2ITH92d5drMrs/02
         nC9hBv7OYvj7avV68JYgjCjWLeFLPZVGwgEuADKB0DeQYp92RaZ6Pz+F9ryHMOAG9sR0
         y2aqvz7LVoSfmdMgZP/xIZsjAtKKyl0xGbzt+Ed7W41S0k0/dTotVFWMTieJtuaXG+Ev
         ec/SWwOpAql1DHbj+BoB2yLc7fQLsH1aA82GTTY0igv4DgZ/1lKqrj2xNnH9uIVYy3zU
         +J1Q==
X-Forwarded-Encrypted: i=1; AL+hErHYuZEC0XacyhgtWObJrlLcO74DFku0mAeNoc62DPW8QYwvLMqXjV5Lg9YhSkLZ4Ju6jA01ZD9VOQ==@kvack.org
X-Gm-Message-State: APuU4Z+K3lXzh84JcaWdQURrcahbkkKnzMsj8DJ9+oB2fqZ/PCAsg8wR
	GVYAbjIhTNqFkKvure/BENbkPDMe+mC3vzoo4Mzzla1o0ZLk5efi9u3dO19tPPlc9d8=
X-Gm-Gg: AYBFou1o7iEzV3GjaVFYrkLikWpLUL+guigNNpAH4jIFixXZ0tnWQU33KJEboBNt2ZI
	ErYg1PsNeqWBNfmrLBSo9ogljEo8e5eGrm/WtXrgvTi//JO+0sv/X87g0lLUlMopoNKXKnXTOcS
	cS775AKewKSdiJ5moTtrKDHlt6asPRVwLRzPY+pthBCrCosMZmBtluPUvlBsU2bxYP1y9gWrbwZ
	TcrJtt63SQR0VSj4tesG3iy2wbjOWMFt4yvcbUUMpaoY26hkM1qOokAh8+dyJe6kdXCSv7Hkt+D
	uuw9kc1SMsSNzDJx1zwZXKmcNRqiJNi82HUDZMXRCSq4uM41s+53MqDbRyq1GRgNjaXTbBrOJFT
	IMoguu73h+VEDSTUj8DE/mHFJleJCLXeZukEZK7fD46VbT0qBNSCTLK1vU/y8o4uXUdn4t41OcX
	wgFEBxeUXuRXXv3x5Km49yc5iuxpDobCemTV970UI6NjhsE10gUiU41MjUDrwQMX8+icOhuKfqL
	/DISILQqCUlokspX8Uayd5NkMboYiX8u9MApVLVcXpQXHN61Ecy6FfWLsi2qhMbnUR6+xi59R3X
	pVZjQ0ufTwdxSdBgZ6nKrT9oendZUSQfzCK0F6SRJHexD4Fde6U4dK3WG413dCWhcZXRVBHax7+
	6/sgx+Ak=
X-Received: by 2002:a05:622a:124b:b0:536:9140:e2be with SMTP id d75a77b69052e-55ac948cc41mr185864421cf.74.1794872215394;
        Mon, 16 Nov 2026 15:36:55 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-920ee3ccf23sm26929356d6.7.2026.11.16.15.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 15:36:55 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/3] mm/page_alloc: move the kswapd node skip check
 into a helper
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
In-Reply-To: <20261113235238.3595412-3-joshua.hahnjy@gmail.com>
References: <20261113235238.3595412-1-joshua.hahnjy@gmail.com>
 <20261113235238.3595412-3-joshua.hahnjy@gmail.com>
Date: Mon, 16 Nov 2026 18:36:54 -0500
Message-Id: <179487221437.482102.6995971224578926980.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5AD5140003
X-Stat-Signature: yhiaqmt74quup61ux4kbe79qu657pwrc
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794872216-299122
X-HE-Meta: U2FsdGVkX1+X42QuDrcvU/M71D0HV8eb4fEJ6puySU7DvSPUxNUnsFAPnUubTRc6RsX/Oi7r/aE3aYIHKeF87hWbQeYz7dHNtVl/LaB6uPmLfy9tw/0qZPQ20/9phqYELMUsoyJSs+qy588eySL5/JmQl3D1ao/R6ivThlhL+d16BcqU4IH3TaJ0URql6bwPQsnHulyuMzf8jtkOvhOFy0QR6DMDM7bjV0/NS1pfcou93XVaHKjtFZChXE5eONcm+7TBrdWeZPyG69KtuUaH7CoJfgCGEWzICaKtapKL+pPMmJs6xiNKiS+OcApEDyS3UPIBoifSHr9UmXnx9NdUJndDvAwajr4JAuoajS+E9QMQydHUykY43pvK7+yEpLsMtfLPmPQyYj/nFxgzomognCkdjaO1aWqfeJcpMH+za13Gp8PL09z4Udm9SUHj55ydHV0DidDvlYHQLaA5Yu61AzjGs240n4O9dYftY0JpyzP/BmYynhEPsS4wueYVRdaITfRWxnLK/209ZeXXojaUzL9UKoEnacH6wlO+TO1sMDNkrde+IQb+96RwjYIzYahOrSJrOIKqJ5pK/JSz78Ok2BjLgrx6xSGd3lMZtcTWqSUZuxW0D3+jtGTPuCdkWcjZwf2mE5ekzEVaeIUIuwB0jHqgo5TleJo35J7VZmms480GzdIyuLIfcpYoutOX4kfyQKmiav+BHPRDXmwFIEaLu04mwhpR3Mhbkh7IR7c2II/Keyop5ZUYb3sPh7f39FFA7BLF3Id4QXc8KMz+zV5+yGwEbSFmy93wJ7GZe1sxoSt77ZQ+28R3zBFimQkJmVIHdIv2Qyb7Gj9njnPc5x+AEzF5cLajrpjSj08/Y+uLIyqBr+XP3nYrydbE17taGFfQSZ+4kkxWSqU+SFQb37PRQNqVC7f0cg+Fw6i4W/TlIrzAq/KUtbtcDQPZOWcbUGUBWZe4ThhYlO+aww9JkTp
 YUvKzwMy
 Bkbzt8IsfftJvTM3ebmbKDr39JUMm0pu1Hpqbwp6LCVXcWfLCK3mbk0xQ4ZtscuHfnqCSvkOYs75Ya0ovwZgE8dpsm8ps3MO9W28RffiLMc6MkDnuvUrDcih/AXp/yKcr13wug5S83WNXSaCrKSeS0HpZg6SC7wRKChNrDF8SNE2y4lXWOufylzWX3oG9LeoE2OsgOTetszf89+tsSRtxFMntTuEGfPEdKwCYB5NAZWyulVbPVmVpOjhExK7k/q2oi1AgLPQRqja/IVgZJ+xUYrI1tl4nhaukh1+m8yAMqEjF5CB9y8gdjjtqocUOzg6BPOG/wnGlxsKiwrnrDUsAxFC4o4ood/SXYTiUlkGLHj41BUVtiizI84aKFZTA7XJyB8K7diF19Kpou66mcSNdU0MpzYEczxG4addlUgmiH6U0z39Qwfn3S3+xg5ZDf2X1S0jXS+Ia5EATZ+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-13 15:52 -0800, Joshua Hahn wrote:
> get_page_from_freelist() checks many conditions for each zone, often
> with a big comment block explaining the conditions.
> 
> Move the kswapd check and its comment into should_skip_kswapd_zone() to
> make the zone iteration cleaner to read.
> 
> While moving this, also resolve a checkpatch warning which complains of
> a waitqueue_active() call with no corresponding comment explaining why
> the lockless use is OK in this case.
> 
> No functional change intended.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Nice

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


