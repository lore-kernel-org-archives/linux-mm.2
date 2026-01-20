Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87FCFD2ECFC
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 01:19:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E70ED6B0342; Mon, 19 Jan 2026 20:19:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E484B6B0344; Mon, 19 Jan 2026 20:19:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7E586B0345; Mon, 19 Jan 2026 20:19:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C399F6B0342
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 20:19:22 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84FC11AEDF8
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 01:19:22 +0000 (UTC)
X-FDA: 84350584164.06.25E18B3
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8D9B1C0008
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 01:19:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="Z/oA6+kh";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768871960; a=rsa-sha256;
	cv=none;
	b=D5RrhR3dF+ij2aIvP1cXfJsSESEic3b0U7hcnU3wwGQmqBRceTCSCZqn4iS862XI9hUG/j
	wZ3Us1N9D2C3XDgITJbopEREapPvf2sovzvBsMdSJT4rUqzMdtOmhm5q/24zaaYj8a6IV2
	lYvVW6SiQ5gyT6qKYUVNAmvVXULMgIM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="Z/oA6+kh";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768871960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMGYex7CtCaRfZT11xZYlmk1T/ScS7WJskb3/TJYX3c=;
	b=r94W0jUBpiGeOfXU6il0gSge8C9lsFykkOS0uIGGTgDT/9JCJR5YyGgn5NktaZlOXyxd0r
	pxdTYIH4sNEPDDyyPU6iSFKZHFmhvDvT8OMgE5/J3kl0Xl1/zWfx/7kj0/szh5NGDlVkO3
	fepd42DKdHhbbttMo+9nvRomf8reCIM=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-29f2676bb21so48690095ad.0
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 17:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768871959; x=1769476759; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rMGYex7CtCaRfZT11xZYlmk1T/ScS7WJskb3/TJYX3c=;
        b=Z/oA6+khgmbpVTBkAAmt3dNxaY8UFRjntDYiLlM1mCX0Ny+cFLe6TmIQDNPVGuQR2q
         Z6SzzvR9LWD2NM6EHEHH5b2RaW3D9Arx2ULgqEsyYTfr8lxQ0uT7/BQmIqKOQCyX/8k2
         j/av15mT12XUReLOgXdN9qagVeqVg+jxwARQw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768871959; x=1769476759;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rMGYex7CtCaRfZT11xZYlmk1T/ScS7WJskb3/TJYX3c=;
        b=sTbJyWNarPTTOEUHvOv2l13osqAyhCg0iUY9RnJ23dYBChN7H0JxPl99t5Fis8vdT7
         8ooyCUDQayxHIysCQzAB/hk/cIgDAHBgiEz0QSxnMa1jVJQ7WIVKRz2H8unSXi0tu8YC
         7kZ80ONxD9qbQGZw/NaapTT6PsMmlr2v8M2mUzkfJQuDcoUSkCs8540UZtjKuEd1r5hj
         5Aldh7C0zTz+O33lcSS+2YYRwlo4nBhqaqxip1hGRxtr/liq4MM4Xe3LDRBJT5L4TWsm
         MMzed2HgpADLx7yc7Bqc99harzZiNURzwRfcU9eu1uSTgdFEY0gnpAmYFZT1b4rLjx8y
         nmKw==
X-Forwarded-Encrypted: i=1; AJvYcCWJoEYqJfAdjhOwLB89JaiiDrniOjv6pHAKpMbw0wkfXV4tAMBF7AK96NqcBaKKYt6EtNIWxX44Ug==@kvack.org
X-Gm-Message-State: AOJu0Yw0Od1doUVV4clmg/JRW4myxwdHcRf85pXOvhIX4+41ODpNMmYX
	cN4GXf7omBImUHiw48rtKr9IUOxKaWvsckmu25wrKEA0BzJfMAhGGUOz+Z7fVtF+mNd5PxqcCGI
	YY5A=
X-Gm-Gg: AZuq6aJqzsmw3d2dyz1G0LGUkExjntEUVnmkB2OkTuJZTi6j7sv1j85IeF8Cgs+MGfB
	hh7pIwKbW97bgDDRIXEExufyeTGkjNrhtf3Mjz835axC4z1xkrZX2KYcqZM/nM3PFhyfO6SVzzS
	qWW8ZzRfJNK+YwjvZ/6OJ/xmAJTyEBrjEF9U49mXagSP92WkReMdZ07JVdLWcU5dt4dOQjTn72d
	iZyc+jmRK/1CkdVZNc4ihTzZELeDCPLECf1ENarE5dp6UwZbcWVCADdomqlYUadfKvYt0KuuYDO
	Xf5lSBp1GKAzwZ6xFl5+JiJ6s+tutbQ5ellxNGQnOExe3odcM2XHmlJug7US7V7BQqo6bvaCijv
	6Ve5nhJi0uJVlfD9RPW0Mvu4HSL01LzmtwwZfocQM/CYz/y2s3K1+IL+hYh4PyJG1wxhdL0bjKE
	ZaPA403lBdUNk13C0RHNP6+wninFqisKZ8Hw54WN/CWevLq1xp7qQ=
X-Received: by 2002:a17:902:ce11:b0:2a0:9ca7:7405 with SMTP id d9443c01a7336-2a7188f91acmr132088615ad.36.1768871959407;
        Mon, 19 Jan 2026 17:19:19 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:b424:8c31:f047:b690])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a755a68b28sm5145815ad.101.2026.01.19.17.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 17:19:18 -0800 (PST)
Date: Tue, 20 Jan 2026 10:19:13 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH] zsmalloc: make common caches global
Message-ID: <qs7qfzsldjz4fd3lozlm72p2vmebzxvsxos76r2h4gvjc555un@3mfigywcnenv>
References: <20260116044841.334821-1-senozhatsky@chromium.org>
 <CAKEwX=PxJo6RijehmJMz+kK45Qr9AcQMCedO7KY_+GWzsW20tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=PxJo6RijehmJMz+kK45Qr9AcQMCedO7KY_+GWzsW20tQ@mail.gmail.com>
X-Rspamd-Queue-Id: 8D9B1C0008
X-Rspamd-Server: rspam06
X-Stat-Signature: xc46bnrxi7kqh8nxae4wa89ck437gxc1
X-Rspam-User: 
X-HE-Tag: 1768871960-79491
X-HE-Meta: U2FsdGVkX18pitIDciMNb61VOjFt9H9vP7xZ0afBf4I+S7oTbF6HGwyLCrd/CbEHZozzxmy+zqDcF/II3ayBLpfaTmhHKz53Z5CGw/hZ8KDT2I0DjM9D76yxyi/43RlziYHNV/Y0xdscTuYdwQll0lPwVwocCdjcu0SptoBXGO2sEKtBZED19D+VLBXPedhZ/N041PnbtF/0gXQkZx3Put1zIY8L3M4t4R/U1OZGs6dFtavE3udpAvsdGQV2taAZ6DbzJdeP263iFNjZW2ZuZJGFApX+u8ksscLJ6N/6mR/IHC8UO9Gc2r63EUlYIqlY7rsSvL9iMlzm8O1wp/Y9z2tZA/US5UASH6S7AggQ4qeVgmaW3UbDm+sYP7OZY/02ImeblZBL9EJxK++hlFUubCM//+fq2+htimPEIQwm5JxEBjoBUct0S5imDEXJudselzoCoiNNoV92QuA8ZzLT1uQx5rH855QAMC+dO/BuaGudKSFL7AtIXTPcSvfQPHM6jEXIf1EcVJ3Uw3/VkIiluTUe9zMH/ge3V2Jrs80G0+7s8FKCAyMR/ZcCtNlTOep6Q32w0oziMoN9pPjcpAGes7P391Pp/HWv1YO+Y/pDId1l0AhEHC1eKFuFfcYN1mbv9zd8M0wMtHoj+f3kragsgD57YP3mevVmu6am+mgh0J+p3AORvNzAiRxygqrq9ynrl4SX9LGxQCgVtPdQESZCnZudQru25+3+V+mK+3ee7i2GBymj+287O406SIVRsDs7npXMu4YKMnVdbBmss/26CrdfIKWEkPOhqFLY3NNlCAJC1BytdY8H9UFTPn3ZsedruGkc5hWD/Xqj894KeL6PFXfu7ONvcOn5cXzCfZgFqWweFd8pFP18uo8ylDUKPUZZKfmBf7auIorh0S9BBQDjauo2hu3kuQp+7IbMjXR1GvY3B+5YgjjKc/vzTLygtbtVhEjTowfLLGojae5Tg+6
 KiAN1+g0
 8QVAtAA2aZTVCpFGRpgm+hnQwbvSzT2Ad5JlEcqJlDZqpiz7lgm7h4DgB7qduEkb5e6rcRGnBYNghLnJ1cbFSyEuTFci5eKecofDXQrJDpGvPXA2PSmlgkzjPzvG18NSWqKR5WkQSs3kHOzLjeJ2o/UXegVfW0H9CWrFMkQZplqJI8cyTdfLhIu943nm3uHQd0pj6H8CuTvR6WuzAHx/EhvZcgTMFvQrD7Kni5MlSlvSkJSXZx43GVKn102EyglqtrBreqhii4sayNCnscSgPiFFhUlkSIWTM13tEe2+g1iIxUHcYW9Mw7/kFfJU6iizAr16O+a39K1s0rsVncIBL3E0vBUaiwv7GHDYEzt9tni91KBj2OLmLk+Nszw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/19 13:43), Nhat Pham wrote:
> On Thu, Jan 15, 2026 at 8:49 PM Sergey Senozhatsky
> <senozhatsky@chromium.org> wrote:
> >
> > Currently, zsmalloc creates kmem_cache of handles and zspages
> > for each pool, which may be suboptimal from the memory usage
> > point of view (extra internal fragmentation per pool).  Systems
> > that create multiple zsmalloc pools may benefit from shared
> > common zsmalloc caches.
> >
> > Make handles and zspages kmem caches global.
> 
> Hmm yeah this sounds reasonable to me. No reason to have dedicated
> kmem_cache per zs_pool (in the case of zswap, I suppose it's one for
> each compression algorithm, which is usually just one - but still...).
> 
> Is there any lock contention implications?

cache_alloc_handle()/cache_alloc_zspage() (and their free counterparts)
are called outside of scope of any zsmalloc locks, so the upper boundary
on the number of concurrent callers is the same - num_online_cpus().

