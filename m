Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1FA8FEA806
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 06:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BD296B0005; Wed, 25 Mar 2026 02:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06E0D6B0089; Wed, 25 Mar 2026 02:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9DF26B008A; Wed, 25 Mar 2026 02:17:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D83446B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:17:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 60C4A5A896
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:17:51 +0000 (UTC)
X-FDA: 84583579542.17.B349A7B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 112AB1A0002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:17:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T5uWNSI4;
	spf=pass (imf19.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774419469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VlCMwKIUU9wAPzYOWKF+fKVc0JKvXu6eJCtdVRvcnpM=;
	b=u93cNYWl56pOt2BWS7I7ki8bQ/2OAR4C9zVejkurtx+vREU2b6WFhnYfgijMfh252E1mUC
	DhtZrkdmDw41JG89v5LCFxjsX4/VK1CJM3LwMPj6i3mwUF/Kun+rU5sQfyWCDowKdi+r8v
	snJm62Yq3FGQZLxXP7p3zCpHHltXHyM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774419469; a=rsa-sha256;
	cv=none;
	b=0aEodlXJ5gFboMLPqjUsDIUILbvWjEoWkA+lgRJcyV79ehQF5s3f23YvVgEFs2pYPAHCRw
	1YEvfy7ztpImcNShmb0JUZAo6P0Gqzh25a24gSsPI64pF4SvmP145bKvaMermgRSHby/Yh
	cY+ns3jIRNDokGLZy994XawURQ0u808=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T5uWNSI4;
	spf=pass (imf19.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774419468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VlCMwKIUU9wAPzYOWKF+fKVc0JKvXu6eJCtdVRvcnpM=;
	b=T5uWNSI4dwEl/JVa5jwVffdhczFzXFPb4WO3P2ids97780GEJ76eqOT+1nYa+r39Tk2FEK
	0YKf6PDV4WliVw328bUQbg4BpygVIw8Kf6k2YEUnOOWUIeveMSTRFUqElPDGCkLVIsNOFL
	796BONNDsYtS1MdhtAwOJuULLOasIxQ=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-RGUvU44XMCq9ZRbo2Azuhg-1; Wed, 25 Mar 2026 02:17:47 -0400
X-MC-Unique: RGUvU44XMCq9ZRbo2Azuhg-1
X-Mimecast-MFC-AGG-ID: RGUvU44XMCq9ZRbo2Azuhg_1774419466
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-829b8bb5211so16335404b3a.2
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:17:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774419466; x=1775024266;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VlCMwKIUU9wAPzYOWKF+fKVc0JKvXu6eJCtdVRvcnpM=;
        b=tIknK7YNCbMlp7zN649ofnOc8B5ME02Cf2s9c+JKPgeuIvtytbH13dSUzEVTiDo0fe
         JD9Ix+dAnM7zoQSvCFGVynfgJgEI/zp/CPKDutH994qjBZ963fwVedd8pQUAQtj1TYwM
         p/01xs+V2TCXO27W87eW4N3FoDGuSj+Ey4T6oo43Y1CzW70EXiz3baBKr9HsoVWNtxak
         HS/Dveuc3rRrcKEbBJLIQxbsrU0gZCCfl1UossEtsx/FTkMSNhW0U0MK5i2PaBAEjUWY
         I8z+iSzV6eiMQzg36u7qU839jH6uq0Qr8cCdEHVS4O1ZHUEdA9sgXGiWHcQFnltD4XT9
         lHVw==
X-Forwarded-Encrypted: i=1; AJvYcCWrgnm5r+UF8A49HYv+5CKP436NE/qn/OAjB9B1kOpcZhqbcNnj6LUioHCccTf1ewbYyXKfDk/YkQ==@kvack.org
X-Gm-Message-State: AOJu0Yx+Pwbb2d/csi5bXkYgjyatgoFQK3bv4bjgVaveooI9qgG2CYTR
	aO+T69/tROJ4b/W0I2p/2hhFuLe4eo0q3dnaqMOOapW/B6hhVflmQXT0NslQrRxfFis52LeG71P
	kYPYbA/hx/S/82baGGySMYj2PmmM0nTJ0CH71/pYdV+dWZ39PFtVT
X-Gm-Gg: ATEYQzzxGGMlysFNaplECrY/c0X8ZXOgn4l9rRFiDpy5XHNmPOjgaffbuSANa2fwPh7
	psSEfu7EQOZlM31J69FSoub3a7YgfQuyHAAPDPHkov8YgQ35xKGLV+z9ymF0I+UKZxpYhPoNrZj
	RYjAPT7GN7rDOEZur0uus9FIJ71/PzXBuMtS33falS78LJeMIa6Ir9fTcIy4QWU8kJqW01sKtTg
	mj9BEtENr1PUghWueijs5G0t6XsFP00kvBQDwVdwB53ZFlTQ3dW1eZNHCKp08WxU+AvCrQJXwXi
	B4eq9lY+wvtDibzt3fVq7tg25cv9ewFZbDUoidU2LTOcpzNUXMO8RMJ91Y/a0IiSDbaw+pp/dO/
	cpFnTpjf4oWmLADuM2g==
X-Received: by 2002:a05:6a00:4489:b0:82a:899b:d804 with SMTP id d2e1a72fcca58-82c6dfa883cmr2410549b3a.38.1774419465985;
        Tue, 24 Mar 2026 23:17:45 -0700 (PDT)
X-Received: by 2002:a05:6a00:4489:b0:82a:899b:d804 with SMTP id d2e1a72fcca58-82c6dfa883cmr2410518b3a.38.1774419465494;
        Tue, 24 Mar 2026 23:17:45 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03bbebb2sm15843054b3a.14.2026.03.24.23.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 23:17:44 -0700 (PDT)
Date: Wed, 25 Mar 2026 14:17:42 +0800
From: Li Wang <liwang@redhat.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, longman@redhat.com,
	yosryahmed@google.com, nphamcs@gmail.com, hannes@cmpxchg.org,
	mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev,
	tj@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 0/7] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
Message-ID: <acN-BsPf0OR50sTP@redhat.com>
References: <20260322061038.156146-1-liwang@redhat.com>
 <20260322091851.e965d3a2f0d6af5bd985407f@linux-foundation.org>
 <acCyPNCBoTGAJjfs@redhat.com>
 <CAO9r8zPxUv5V+VKEBuyacJUsc-UWh7hGc06yNQntY2GcUJLBPw@mail.gmail.com>
 <acKAr0TYzuYPxH4A@redhat.com>
 <CAO9r8zOCGWSX1+t8-5qe+04UZ6i4mChPJ8hkpiS5Z8pAPZ0sZg@mail.gmail.com>
 <acNH6C6Ay7As4y60@redhat.com>
 <CAO9r8zO2Nq=8dGBuJ0xpQTEr4EM2iJ=WNULtCU5FLLj4a23dYA@mail.gmail.com>
 <acN8tN4FhuoxCxzs@redhat.com>
MIME-Version: 1.0
In-Reply-To: <acN8tN4FhuoxCxzs@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qO0a042_jKdymaQ7r3JQilENvzjl8fd9W8NtWfgZQOE_1774419466
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Stat-Signature: hu6ezu6wi36uokah63rm5koxy7oo9nxc
X-Rspamd-Queue-Id: 112AB1A0002
X-Rspam-User: 
X-HE-Tag: 1774419468-863612
X-HE-Meta: U2FsdGVkX18/S86Xjm+1zVUeClC8lQE2oYs8WVUAEWHWvu6+LDFW6HIYcCX64/vLIjdi1TRODwA+0iGdf4bfaSKVrWdi1xUbyf79fldOMNHxxl4Ci+mxPfflGfMY3xlOoBNdNb7yQQKgGwKXVoZaZEY3tUwxnAhpgL2cK81MDD3P5kLTnB5ZryLtrsMkztvyeB1oqMa8uTmioWbU6z2peTVsyClZOmMZuIeaEEJBSbWdgBSL9N4OcAcBoxo0Nzjm7baDkBS+K1uO9qLUU3Rr7VbTkojer1mdtJ4awTQA3ShkOW992Lt5/QZGGMDdGX1pHH6T/NAEEhz4HCtRpcMxZBMdRPaT0TNX2qHV3s/d0/1jFRj+gxEBzWcPNFsRigGHUcGVs2JMbVPl771ue1qsjC80M4C+xBs74hCRUv7Ku5XusInTPabo8JiaY/P771jl+RsVpw8s9F+iPWprPACUrNw8xT7lm08TJGyM2MGoz3PB1h2N6KQdVrOizxdtR2bIjyeSSsKyubmVR28NTihru/+DeZAzVAmHB544NMjWoIqXbgprJYAxHXVuwXxPUqaxjcEftzviTX6MYVnGV5o72e0Ti0kbQTSga4+xW3Y3H9nIg8130aljbAMjVOZWhlo1RIWFwQ8mpMiN503qxwV69N8jV4Ug/ccSwHSt/XdWGQt7GQqMURKxOQbCy0sqzx2GxliWWUh9UPS7u6XOfJ7ZLBSUeGoId6Hl8B5zzqZoYCPgFI27Eg7dmDU6pgf5/OqRYTbvrZmDqFZZyJb1gi1RyoRfiRsmyogVYoSJbUN8iUDLqPJIIgo8pB04yRwZmcDb2AL70MamYED4FXz7IH72pLDE+F/EGhWwX2JeM95OrX8Tv4JakLWVCPHWYmLGJlRpTdVeXoiaiJ9kBhWLlwQuViEQmBZc+GUL2fMX6C38g1FQF70o5zZnirARBHDDWrHChgrgxvYp94YQuDdixLp
 wjsnWDxA
 MJWNCPGCx/dMwHWbj9JfdEqaWZVQbrHxYW2C///E24LBGx10R4BfZoXqPZ5pYjrObVY6AT+pQfEbTP0ObhNfTd0YHZ3kfqePepRVxpLiHzlKAuRi8uDdmmD6KlQwFIFR2kfUo3GZNDwz1TWas4fO+sVggRTYYZTZoV3HG3uC+FDqttHSnIVbk8a7DWqV34QHuXh364zms9Wezyn/MlbHwY6RPlSuNMi01hGjzZlTOKi20Yjhj9cD8ZXVWjtMWSyFj5eoKaa06AWH7/aErwYZbVs80PUim4lp7Ghq4K8PAI25ci2qB4WQhwnUf3b5mioiCppyqyy0WjWhlsv5mGMDkfgt/egTnoXZ8nBo5bcEbALBtg5qjYT+GEQZfWQsGEGdMA5nDmcxmiOd3wYA6cwlouYWcskz/IMClncLf7B6Bqo73q54=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> In summary, the problem is that 'zswpwb' does not update when zswap is executed
> under the zstd algorithm. I'd debugging this issue separately from the kernel side.

I forgot to mention, this issue only observed on systems with a 64K
pagesize (ppc64le, aarch64). I changed the aarch64 page size to 4K,
and it passed the test every time.

-- 
Regards,
Li Wang


