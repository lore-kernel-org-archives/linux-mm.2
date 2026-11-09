Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 810F0606B698
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vf3W4EGB
Received: by kanga.kvack.org (Postfix)
	id 917066B05B2; Mon,  9 Nov 2026 11:55:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EEAE6B05B3; Mon,  9 Nov 2026 11:55:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807076B05B4; Mon,  9 Nov 2026 11:55:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5633A6B05B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:55:06 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E63E51C4134
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:55:05 +0000 (UTC)
X-FDA: 85416180570.22.7B8A8CB
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id F154040007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:55:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vf3W4EGB;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794243304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wz4f5GFlzpgFeRAMcKCd/VPFtcaIvfSeX5hY9+feV80=;
	b=Hu7a2D00jzZvTOFj5BX5+A1cPayoz0FrfxV5GbROxza0bT8u/zO8qpJci/7+gKtAa1STIb
	hEaAAGmW0cyK/8+KbCehMrumBvAqjLer4SD8s3IlbclfFFbQR3ckzLjFoVSLFoFlDkdrsA
	uDj+N8OZJ/30dv64jwwM2kmZ+ytPWbc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794243304;
	b=pNwoMx9PNIyONjj7VOTtsBqCT5Hd9xE5I50WRTy34r97V4Hi60D37Acih4G6/LBsvYFbgw
	rIzQg3ePBRJHn6Ve81UVN1PEm01WgaWJ4FVbAsmo5LFr5dKmDs6IMFJs+H4j4yclh5eBhI
	ZsbjEokQ2LPHUCrk2wgta5twRVf2XkE=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vf3W4EGB;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5c14470729eso630662e87.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 08:55:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794243302; cv=none;
        d=google.com; s=arc-20260327;
        b=X08Wg37xKahyN61VOO9AEFlojHWuZowDg2WMnEja4EEM2cij1BD5Svy140gtIhZhow
         phf59yqvU161Kk4ToMruMLzdex7k0xlH5aM8lgYeb42wVmaI7GB8YJMn25NitCyg+8+E
         B+5EMuklQqkCP/L9W9al0flIY7T7X7r8SroHtRXSkmhieMWDzeY4oAGIV/ppCDDBinck
         RKnHN0mC2LsNubGMg70fVRa565VWfP3MsS5XQ6wPqoRmAYHcNH7Ks18oxW8jyJHf6dcc
         rQYKu2ULfr1lIfnVj3qOfreoTwPNP6eYEFYaQH80T2uS30CsjGshPtI2KTlnM6QltF7y
         z6cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wz4f5GFlzpgFeRAMcKCd/VPFtcaIvfSeX5hY9+feV80=;
        fh=fDFWM7SpKGwQu/OrdA5U5jYctCPQi20BFcqWuZ0MIrs=;
        b=GKk8Fx9kdO2rVD5nEYRxChPQgjgdoM89d1QjfJnLLs9wlwqoWlWxKKFbm9byONzom4
         fql7aNWV01/KoABoeMUdM53qguVNta9OUQfnqCDwrN/pcfzkwloJthTcqWrsrCZKvrZ3
         5Kd8O02zBLowyBrmiIT+Pmv1ngMX5q/EsCCffiCTs45xpMdFY+Rt+LicZSQglLB7PXZE
         0c0Azue21TXdlyeYZ6IBfSCDidFKj//A5kVzVBJz1eww3afZ/Vi507mGL3sE1Bh9LOD0
         AOq1Wbd6kE5yqNeX5gSqfsXcOEMaKJWN+S3eRl0KO0Fkd6f8TSQqbUttSgeXcoB/Z/xd
         PxbA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794243302; x=1794848102; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wz4f5GFlzpgFeRAMcKCd/VPFtcaIvfSeX5hY9+feV80=;
        b=vf3W4EGBAkrrM1R8XLZY2rQkp126RWgP+5IoyNdArjRSJ09Tk+5GxNXwGFVWSLt3fG
         bm4e1MoTWZrZCgwx0Yh6QPwuoc7NGIWfc0zOLuPOJSyZboUZIHohFR91wIcVHMmK1Vzy
         TIbX1avoJH+RQG6amaIqHoJBXmCP9QLXhQb0+6SGkO8g4LDRI/54n+F0NgtO6SC67Dgx
         TicocnsiRuEoeJZHop6cKPW7PJwI4zz1+npySyj/0xDwB0wgxCU5ESP/Y+TI49Els9+w
         BF9b286bZB03KxJP2im82wm8fSpYkMjzNojWgLC2/xgjVXIwSSgOX/FD81IbEieutNVU
         DR+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794243302; x=1794848102;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wz4f5GFlzpgFeRAMcKCd/VPFtcaIvfSeX5hY9+feV80=;
        b=24lyft2KgYOhnlo2setVMK5WhcnwI3vxpAQxzLhHbRnLeORv58d7+W6J6NIxrbgcRN
         L6LCVZPNug7ZxYah3YdXjwE7obEDoFtRk0CMRtHhIK7yJsW8v1/Srd1kV7Y7LbnwHGih
         YDK4f5Z60nEnAlKEE7m3bxkNkWwV8ga99PK9n/Fj5zKPD4D6fsuwwd+bRaOvrtVqZe0X
         /VAcwwEXlUfx0nEfoURsL0y3WGMY3D1XfPPlTod7zX8bYD4dcqziRnWbdkVYXkNkjXmu
         hQh8bIwmtvoPismybAvhuidhhLMTyG3GvaYxrbaJY4QAB40leauR/a493tezS231vi09
         0Pyg==
X-Gm-Message-State: APuU4Z8phWv70HRt07+0j8E4XiohbE9xP/5xLMI8ha2HbuP+AKvIGNE2
	DF1a1WOFXtnmeTvYFgrLTMOWXVXZK6Rv/q3giLa5KQ2/t8LlJdPjsKmqWoBesZ6LRrCzrHhmLTO
	8xILGy2FgiWGf8A9DWDOypiYdnKVINQU=
X-Gm-Gg: AYBFou0XB5MAmxYMRLqd2y1aSGUSmCrsI97lgIxWBjt4AbkefgG8+h3Zmv6xkc69F0E
	i2rjjlbLG2vzKUqsBM+NlMFKAL16tUXaOuPYyPAac81hmxOHWmJUweRg0fnmM6BV9aVKDdY2LUp
	4i90mV3QkBltLlx1aOHnn4gc8kKOA5n2wfS97h6aFzzs7Zo94X3RD6hd5/QqgmUAyhXf2Havwki
	5BX2uymFjp58A3YlSLQED6O7TpU/HbdocP/NNFXYjZBX101arFbB1E+3pnm/nt6qd69W86qpOJO
	xxiRc47L8O2HftDRu2IVI77Iw8xBWS33HkDU4oqcQziLCaAo27+mmHoVJ21O+ejoMMXPL1B2c3a
	KAmVmIVnlUa2+Aq2K0eZAokOn4e4w9fnBxxRszfxx8My3+QL/aIJZlAoF10rQdFXJloxZaHI6+b
	0vjPQFFIDIArmfvznALauBFaZuwjjrCJZrqLDsX/6d0eJbM1Ge36NO
X-Received: by 2002:a05:6512:39d1:b0:5bf:d54c:1fb6 with SMTP id
 2adb3069b0e04-5c14c0269fcmr1310915e87.44.1794243302053; Mon, 09 Nov 2026
 08:55:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106160432.2552507-1-nphamcs@gmail.com> <20261106160432.2552507-3-nphamcs@gmail.com>
 <CAKEwX=PiM8vc27jOVdinOGO9AdCOpbKozu=Hj_b55y10-ynFyA@mail.gmail.com> <CAMgjq7BuAKZ1BjTmdTmXHV+SZCpGMT2YL+q1qvbDOSeqYA==Tw@mail.gmail.com>
In-Reply-To: <CAMgjq7BuAKZ1BjTmdTmXHV+SZCpGMT2YL+q1qvbDOSeqYA==Tw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 9 Nov 2026 09:54:50 -0700
X-Gm-Features: AclHuK-YPpD4TepwOXmHYRcmkMcbFS6VvgciVhmro5ByiYQtUy7Yf8RUTGbR0xc
Message-ID: <CAKEwX=O_wiq-iYhLrw_zVFuO-cMigoSF_zmKYAQtcGFVj2BmKg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/swap: publish cluster tables after reacquiring
 allocator locks
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, brauner@kernel.org, 
	chrisl@kernel.org, david@kernel.org, hannes@cmpxchg.org, ljs@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, weixugc@google.com, willy@infradead.org, 
	youngjun.park@lge.com, yuanchu@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 454phw18pnrocqsy1nykxfetkkkbiw3e
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F154040007
X-HE-Tag: 1794243303-306026
X-HE-Meta: U2FsdGVkX1+cuVKcQFaP5zMW1X5gJyfFPFair5eGzegMj7aeM373XIoeZnfGro/VkJmmktTiUf+H9deE7ToWZeJvTuR2twpjEyL1QC8mh3ztlFO5WpB/ywE40k34kE3fEN5qhaIrJPTsUYVy13jwgUFLetOcXgG8tke3FAM70LiZIyLFoxm3mCLuHUBXoxmtImMTWgYCYrLrs8p2omzZOHVtz8+csWoUhCWx6pz2WaxueEpLKSTpSVvdFMLGaAbeF7ZfleGXFn6UFwXoHgNTNaHlf9xMGNs2iKFLbCBebdK5O7wAEx6P1shTzS6sjbTLpF1SfbUzj4qb+Oxykgcmd5LBbLtkdRLxsozvJDPfjOQwsd26PiwTYY0Iir2+E+O0xPrxakGX7sB+n9X/MknARopx7KDHDW84wmEVlxxmptperZl1Rbm0KavCRmuYpeoRc9+H+GAhSKt8rLi9uoJlad0reYuGbISrqgV/eBmgY52CbBQHg2GaHWfDaBEWt3e/2ejHAx28ShMTYsi0TOby2nZbHzuDiltB8hX2qJnPtIlMUQbVQjK/p3lCFtnSVc+HZAb5C4BeeJ5xOqaL7OCGogzdPFauXHMAUaLuLe1QlwLgFeGwG9puLC3m1ui4F7DOBktagq8FjDE0O6nbuv+3BB0UTlwkzEp8l/wwc0o8xUZEIt/D7Bkz/XaZIqdCM7xYMyGvPdGP6ozWMMcABGtPhZQs/pAGF68400D0F8TRBK0mmmtPqXREry7lD5mwRbn1AqLpOqjVHxFZihQ1QdYg+rnJswu+CMBkKCR+ULYEeyfdnEdno2xTl8x49esVToxbhAn99ieKGQFMktJWDAXek803I/Jiug101dER3yFxQrU+kSneT8zr3+HxTiwwB3ZsheEBdGCKJ9itAX6C6MnWAvwXiUh6a1/Hj9w5lS9SYUxu7KGBDTZT4BEqaypO5TVMv7Dzu7FwiH/Z0kXV5Yn
 ULhw4kCe
 sJeiuuQjSWCPFb2AUTCqUGlVBGtL+KW1+2C/18esl5khHOKjAgwUuIVaIvw6Dg91jk5ROtzYhTibBUBMbyIeTZ9QV3dcjw94D6xC5M8i4SbTBrA29tTwvK13aNK+dlsHGBihy9tEXzoMAluoSVdi0GQeRAD7bYibzyAlLnBvJ6Ejx4Ux3BFB5rOHpN8Fhuc6KRQ0JrLfjoK3KXCaNVVtZ/kApADE10jznlbi7PbOwcEzuvPJWeql478+uMCn066F/R1R0cH2PJXLnHy9gg3nNZv3NuNZN3d7Mtvv2/msmL8A/KhPdQ7i3Q0hoPQynx43bstVZazbH6NJC1O77tlpLIs0Mf41VkaDQSG8ZhH9WN2+F0SCoJkL1AtfRGo+hcz6gQqRiD/L6JDcYzouQf+iHEb2oiVrTG0Vxctq3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 7, 2026 at 11:03=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Sat, Nov 7, 2026 at 3:59=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
> >
> > On Fri, Nov 6, 2026 at 9:04=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wr=
ote:
> > >
> > > Under memory pressure, swap_cluster_populate() can publish a table
> > > while its locks are dropped for a sleeping allocation. A cached
> > > allocator can consume and free that table before the populating
> > > allocator resumes, leaving the resumed scan with a NULL table.
> > >
> > >     CPU0                           CPU1
> > >     swap_cluster_populate()
> > >       drop local/global/ci locks
> > >       allocate and publish table
> > >                                    swap_alloc_fast()
> > >                                      consume the table
> > >                                    charge failure cleanup
> > >                                      free the table
> > >       reacquire local/global/ci
> > >       return ci
> > >     alloc_swap_scan_cluster()
> > >       read the missing table
> > >
> > > Keep the count table, cgroup table and zero bitmap private until
> > > swap_cluster_alloc_table() restores all allocator locks. Install them
> > > under the cluster lock and retain it through the scan. Initial bad-sl=
ot
> > > setup takes only the cluster lock because the device is unpublished.
> > >
> > > A stale reclaimer can return the isolated cluster to allocation while
> > > its locks are dropped. Abandon installation if the list state changes=
 or
> > > a table appears, freeing only private allocations. Restore locks on
> > > allocation failure too, so the caller can return a still-isolated
> > > cluster to its free list.
> > >
> > > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > > Link: https://lore.kernel.org/all/sashiko-outbox-181084@kernel.org/
> > > Link: https://lore.kernel.org/all/sashiko-outbox-181086@kernel.org/
> > > Co-developed-by: Kairui Song <ryncsn@gmail.com>
> >
> > I think I need a
> >
> > Signed-off-by: Kairui Song <ryncsn@gmail.com>
> >
> > here as well...
> >
> > (Kairui - up to you if you feel like Co-developed-by + Signed-off-by
> > or Suggested-by + Acked-by is more appropriate here. I just filled in
> > the sketch you gave me.)
>
> Let's go with Suggested-by then :), I didn't even check if that sketch
> actually works, so thanks for taking care of that!

Okie dokie - will update that in v2. Sashiko picked out another issue,
so I'll use this opportunity to fix it too :)

If something sticks out as obviously wrong to you though please let me know=
!

