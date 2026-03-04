Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2585EFCE38
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 18:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D15026B0005; Wed,  4 Mar 2026 13:03:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9356B0088; Wed,  4 Mar 2026 13:03:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF5526B0089; Wed,  4 Mar 2026 13:03:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADEEC6B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:03:21 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F22A8C12D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 18:03:21 +0000 (UTC)
X-FDA: 84509152602.01.CAB1D6C
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5E42418000C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 18:03:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FtI+ziW3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772647399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s081Yqcw4FMldRcUhZ32fBADnqVG0rTSkc+UZ7N5S5M=;
	b=LUuNaXM7aMiBAAxZiWferM6AU7g0flktdPpwDRH21xMh3Ba+xV7QItWI1ATXkIR1yaqs9+
	grgWV1CcxonrDWOpn2S9mpu742UBulf9M443L6DFgqZhRNEDE9NSsTW0LWlQzDN159Oyrq
	s4zg3itgdthi/pxtTwTT1+ZcSE35t24=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772647399; a=rsa-sha256;
	cv=none;
	b=cIHuwW3EjrzhZn3+eunYqj4BWkFSomg3eZQ24AEKStDYr6WL2XY+l9gWQ726WihFj3h8bf
	Ulbr/TGXqg6/P2b5KwUVDAuCorq2x8UQkO9JywvlfiFCaraviSephZALqTf9diUmT+zaic
	qTsVuDaC4nYgzSD1a+/mKSTCc9WY9UY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FtI+ziW3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7d18d02af68so5649803a34.2
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 10:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772647398; x=1773252198; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s081Yqcw4FMldRcUhZ32fBADnqVG0rTSkc+UZ7N5S5M=;
        b=FtI+ziW3mWS/Qdrd3moEXpiHYzq6/vVtOCSJZr+xwkkJ17dR2vI9Oq/MxNWq3lVo/V
         fdr4+QKjx4HPnfddICKMoucKSAv3KCGo3QJ1TW76VTv4uL+NS2EFiJhGAwtQClVm0pEx
         uG0xXTTzRM3lKgn8UeZfn2Y146qmJiyNuLWXW8IvdbpxcwY3oSVhL4YON7WYfXw5D5pO
         m96Ube8t5rQWassE5iDgCTZoDu84NM9lv+1y7dx3+MMvTzSSEtBJAbInek0VU8PMTYPC
         Ka7cWcze/Or6xctLEMfYVmItJIp62+nGI2+XfyGe4RxAYT+M41/biY0lDI2OfUKhj/y7
         kydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772647398; x=1773252198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s081Yqcw4FMldRcUhZ32fBADnqVG0rTSkc+UZ7N5S5M=;
        b=X4y/NXMa+tbfAjlmQiLwzoX5gUYb4/eVBV8h9MqACheglB8tWo+pjfoc4KDZBQhIhM
         U50ERtBbPsA45uec2id8f+f7KFRir7tMtWenDdFt2Mt1eR0+cJ8ocO1ITrgWqx0GhfpF
         OqsbGLQla+lByEX4im3UfMDjRB3L+BGHFNwPDmtvZf1k/8jVdpice9faB18BuL8M8luy
         d1uuY1LWtT99uAAPGFknLJ/JjjbReBP4Lk7KRpqwSHDYiEJ3Jk8DBuF/IqA4TIl7tMf8
         J579AbX2Rg86LQcKWSAAQFoa1DgNTcBinlk17XTY/Ifg/zLLx5XY1YzVG/vmx13OS/DO
         tE9A==
X-Forwarded-Encrypted: i=1; AJvYcCWS2K/bUQlrXB7cYU6Qlsbf7F8VjglcCr0t2U50kRVLUUO0WONqjnV7zMIkd3arMwl25N3I0g9Giw==@kvack.org
X-Gm-Message-State: AOJu0Yw9NQxlAxCxw+2SgPZQFJeoeXMDAmrlHVJ8QolXTog/hSqqI/0F
	YS9VOl00Ec5hWawWE5eO7Ya98g367fi8RckFVBdRNH2nNBaCHMWscFA1
X-Gm-Gg: ATEYQzyFzoMU44HZPZyGwx8LOZFqT9cg5ESsXIBo9bwl4FkCtkMOplGGFfdGrZw2gFR
	60Q9EG8hndeJuteMKW1VzBNEhnr3oazwSrt3OUSWPITDUQp5BsS3BJs6z+XRRWIvK4tgrvR1Gl3
	4HWN3NTj2O/6sIPRggXSxFCuR5ecEEzsA6+MmVuxgKW1P4kaTt9zEQETUAQwquRNSPHgFIVdwZL
	Bo6ImqOPaPx4/dacYFlujRFWOTvprMr/uUB0rNsd89SYpeTEkgJpWIQEe7yR80tOWWDJtfObGIH
	xcWq7jKQ0MbXuSoILwtcsg/xNM8Q2s5wX/Tet1u0W26lHuHkCOgoSN7c+38meJKxoK9WQI8vnFe
	PNBmXHdKMSTTKTopWI8Py4p0TjupU08TxJq2OtEAX+e1gdv2x4OCXTB4zwHZN1E3w02OudO950L
	OHvkmN132knTIuUquVEUs3
X-Received: by 2002:a05:6830:264e:b0:7cf:dca3:5c6f with SMTP id 46e09a7af769-7d6c7f5e661mr1785549a34.16.1772647398349;
        Wed, 04 Mar 2026 10:03:18 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:c::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d58644edfbsm15582806a34.6.2026.03.04.10.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 10:03:17 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jens Axboe <axboe@kernel.dk>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 3/8] mm/zsmalloc: Introduce objcgs pointer in struct zpdesc
Date: Wed,  4 Mar 2026 10:03:16 -0800
Message-ID: <20260304180316.1429892-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAO9r8zP56KdyaQjMp4PK_yS27x35s0p=aHYzT8Ey0f7bkbvNuA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5E42418000C
X-Stat-Signature: ih84a8anbc8rk7tm4z8ac69dkngsib86
X-Rspam-User: 
X-HE-Tag: 1772647399-784652
X-HE-Meta: U2FsdGVkX19EIjdprnAlw8zAh/D3RJo4uchDAwP7ckSwuEI0PmVLmYhkuysfj2+PM1h7QP/zaFo+9E+nVlSxzqaQaZ+ITVpoGk+eFI+2HdzSdSIiiLVbN8cGwCTkEukAhzMVnbHmIEjWsb/HYe/9vbn9ZrwerUtLtRf/MJylynMSLk5o+SGWTgGjvYoKDPih6xNsCGhWj+MGoVF7egrNIwrjOR0oiHEvft7aOlrkowF8qLrOW4C+63TU3Lt7o2HadNK2ARcjStLBEsIdO6HfykVRhmEv1ut28/aG1Smd+UZm3uaov6Hc0BnbHYxPyHWArzI71C71I50Zcp59BCElZ6wL9KTzKu+wujejiamc0UVbS+B2TM+YZZiHkKUqeLbAiOYC3ssTNBrSxvmPm4FnTZtpIIlTkR3Yi2vytawyWyetZ7bo572h+v+rF5pK7lvNF2a4O/U7+y9y3mEgujtb6DhklQTjw8w/q4K3soBgJrZcBKXZZkbNdqVS6qmd16J+Avz4bRZ6j6F/WAlUfn4/AENKnP+mFXFQ4qZNT4ZMjyI085dw2M8KlcQlLRcVdFrIAZpl+D6EgDjRLZwj8iZla6VHc/yW6wzH9btiWOEnlIHxuggcnqpM04489BMA+c8YTY5i+1Jd5fMDJlS+X9kli1+JiZYM9chqWEnl6Ua+V8enO+MxL8d+TUjpcK0PjQyLPRauoD+Jx1R9ctilGnYWwXvGIUnOb6AEoAWMF9Nlvd4gtv1M9O722ayqqv+eVN/3oXuoiHmsbXMxgp2GmeJHWkHXB//rI6MSXty0YmvpkeWTX7jH1o32105NmHhYSMO1YJqvE6Knc5MAVSi76IK5GmGs/2z4f2gOetWhETka6769VoDdLhYoMDmvp+0XfyrPuhYJXO76fNgLiXrrwtz3hAERg/Hgqj8Sv9+lvnrEeRnakagJdI62UVO4TV7Nt9SvB7BE0lQbAp5COYCG2c4
 eTjMk2NC
 aJQOAkRwZ5aFa2Pg1mfGcHxzqSy31nIe4Inl0Z9BpZi+UJEm50+0CelNIZ0qDRC/rlW7TUCRaLc75zRCme/NAEBk1oQU+4XcecuK9nsMilq+hKs3FX40t+9LxnXS5ch/N8R8YJlZSjcu2ps7czmzAL0A+9mWAu1A9bd9sb3/o/Evs6tdt4MaE9aZ7Zul4X/MnsJesIULnJlCCp+AlLbibuwhVGpKsF9Cs3kpahj3n07Av8CRTWXMi5er9zPkR0IPBE/3gQcHAK7CvLl0IntVga+qsiSJSBsBm3kkTMnHtO/7TQbxN1LQ4VGubfVCXR4U/ylQZl91cGqmTAzn134yc2bGzt6oYpuv+o/JlEvsrym9Hb+35r6w9TDVPLJ5PTmUfqtT3pmHdMNT9teIPHqLH9nY446jmOh7XOW0TvNwL4LroAdGQ5jA5w5cgEO9FrBu0sTHRRCQQVzfUpSBLKZGqRt62mVwXRLTr1CZHxxccE4ei2MCuUI9uMobSGiaff2fRj8DA2sJlyfDY+21pwsqX1EsXtaj3YRKkrwO6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 4 Mar 2026 08:58:44 -0800 Yosry Ahmed <yosry@kernel.org> wrote:

> >  static struct zspage *find_get_zspage(struct size_class *class)
> > @@ -1289,13 +1336,14 @@ static unsigned long obj_malloc(struct zs_pool *pool,
> >   * @size: size of block to allocate
> >   * @gfp: gfp flags when allocating object
> >   * @nid: The preferred node id to allocate new zspage (if needed)
> > + * @objcg: Whether the zspage should track per-object memory charging.
> >   *
> >   * On success, handle to the allocated object is returned,
> >   * otherwise an ERR_PTR().
> >   * Allocation requests with size > ZS_MAX_ALLOC_SIZE will fail.
> >   */
> >  unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
> > -                       const int nid)
> > +                       const int nid, bool objcg)
> 
> Instead of passing in a boolean here, what if we make it a pool
> parameter at creation time? I don't foresee I use case where some
> objects are charged and some aren't. This avoids needing to always
> pass objcg=true (for zswap) or objcg=false (for zram), and reduces
> churn. Also, it allows us to add assertions to zs_obj_write() (and
> elsewhere if needed) that an objcg is passed in when the pool should
> be charged.

Hi Yosry,

Thank you for another great idea! Makes sense to me, then I can leave most
of the existing ABI signatures alone and just make the zpool changes.

Thanks a lot again : -)
Joshua

> We can even add a zs_obj_write_objcg() variant that takes in an objcg,
> and keep the current one as-is. Both would internally call a helper
> that takes in an objcg, but that would further minimize churn to zram.
> Not sure if that's worth it though. Sergey, WDYT?

