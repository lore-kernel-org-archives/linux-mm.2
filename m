Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44AAACEBF9A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 02:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66C4B8E0011; Mon, 17 Nov 2025 21:59:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642C68E0002; Mon, 17 Nov 2025 21:59:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57FE98E0011; Mon, 17 Nov 2025 21:59:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48B118E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:59:11 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4A5AC0243
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:59:10 +0000 (UTC)
X-FDA: 84122221260.08.C1395DB
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2ED0080004
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:59:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CgI5qOdJ;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763434749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uyA/z3+NX1r8lmPy90ZzbFhLB6Y/TGoAYT7nzfduTWI=;
	b=en19iPdlFidLQ8h7eAtN2hoMggM9Elkk9xwnYE8y3BvAmIGOmkq6bOgmnNMi2yBcXP/5ET
	M30CoPwpyz5jQR3ECYDNFYsdDBjSNteXMxONF+yffOcebkrM7wnwu6aCwEWYZ8+RAV1CTK
	oBwGI6HZ8BB0dc7BwOXu9n7yNeXY3fg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763434749; a=rsa-sha256;
	cv=none;
	b=hv99DvE0vXkY+2PxjzkMbL6AH29QcHkbQEwUtCC61VY4+uB6vD0dmxnK81Pvf+xBJu72Vf
	y+uHyCdPumhdhBxThhHXN5/NWFFzBP8VjbwE/vezDtHFnP7L1VXiSHE0gf/XkDPYzIEh/Q
	btAF+OB1VYTPapUkA+mGpjz9naE0pUA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CgI5qOdJ;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b7370698a8eso479079866b.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763434747; x=1764039547; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uyA/z3+NX1r8lmPy90ZzbFhLB6Y/TGoAYT7nzfduTWI=;
        b=CgI5qOdJQ7ITGKxplCwMuOOZ3Pvs//Xhm1Dg7xMhPXvL3dAJt70uhAAiWo5SPZN73f
         d11cCREK88N4aOJ3WSGpC4kDYcCokgPrk2nDE1zMoT8b90T8gfzO8YV5jmovDYoRR6A4
         wQ3oWz7avZNNHZ/1Paw8l7jv23J7GM2sUuWnhdtUIX8Ka+R3HSiIddBJ/5sg7YI05lQY
         VDDSU5aCc4oQd2J/HnrSsqmDsQXAT4z7/WT6WJfgyzriybpka1ROLn5kGxveYSG/LEnq
         PClRH0vqcqsUDIuNmveCUo2mg2AU5nlWPZBOYeKnvRZPVicQJ7mA/a5L6PhBS7eYSd1J
         wJ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763434747; x=1764039547;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uyA/z3+NX1r8lmPy90ZzbFhLB6Y/TGoAYT7nzfduTWI=;
        b=g8bdWsRPH0cStkp8pWb1nn8XpZ4lYmOlCKK8D5FocsezYSZcM4XlEnnvkjAYHTTISc
         WILGXhsqR41pXYVLuYcYNBDDKnjEoJDpHBDIHLsp523xtFChKhG/6cVi2boOcgufEOHj
         fzPlIrIFS6VwafbxUwFXgXZ3d89Lpdgt0oqW3+nTRkJPrx6tvVT5qr4duVstAtg9mj9F
         AtcqXfFEcb7BnzgkOwE/pbyn8rA8bBeDpPW5KI6msk3/ArQQpz7+elBpk38DtKpUHez5
         ZBZwai+mNEQupVNGtVs5LVUdguEj2FcXx4+ea4gYr8Jj4y1RPc9A3v+naR/4uA/l9kzG
         HqDg==
X-Forwarded-Encrypted: i=1; AJvYcCW8Idlv/4E13z0eJwFJ3uVSAIP/NpOGQlG5FTACOjk6A4jtqSffqMOc0ikooeerii6z4e+6qY/QTw==@kvack.org
X-Gm-Message-State: AOJu0YwxlV5JLe+1oGoYHo6JCkejpx0IFKDR1WUB0LoMtdaLk/AwbBLo
	kCZ5uRsaDDTNZs8XSXRTzozLhmLStJRaXAnlOFBVCQu5n4qvDspByYsU+NmNE3iQysxlXclTvWc
	RYtv8qXoc1+fW6VxmdFV5kLdGh+5oeGx59xOsioXr2Q==
X-Gm-Gg: ASbGnctJKSHtxHFNYmHyDN+Izh32ERwwdUTgR9i+bnOojNDAppViOqHna+K5WgvWeBY
	OQo3vlbEubszLmEWOjEnLo6O5S6rejZC0+DKgs+W1OzDbtoP091hkgnHTTMdOuvdMbdfaS3o1sZ
	yd40Xaol8cLgSKfC4+WdFDMkv7Wlxk95bECHKf8tKTaXMm7NoWHu65mWA2xUTReMaCocigV0yAI
	CZhaww6c+v+mNWqOBKEeR+q1ehgCBn3zwUoOhAEdnMoR6+MfSRkk73WGH4N2wmnHFj1TYqWACgN
	+mc=
X-Google-Smtp-Source: AGHT+IE+Xmu/XKzqDItZxK55uKODQ4pXWe1jCDf3/zyE5l7HA0zpyHUAc1wH5fOIbLOq/qTekDcDuTCEd4KGgBq5NiA=
X-Received: by 2002:a17:907:d9e:b0:b73:9792:919b with SMTP id
 a640c23a62f3a-b739792959cmr714211466b.13.1763434747412; Mon, 17 Nov 2025
 18:59:07 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-8-pasha.tatashin@soleen.com> <aRoXGYC4GeAoNKPl@kernel.org>
In-Reply-To: <aRoXGYC4GeAoNKPl@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 21:58:31 -0500
X-Gm-Features: AWmQ_bmEx3-y1qL666uuCkHAOhqd8xREWBuFy8c9Q6i-THXVQGPt4k4Gmg9IHVA
Message-ID: <CA+CK2bDyKzeZBZvNM7OdSm5dBt3ADjsyXc2X3_YedV_xnphMww@mail.gmail.com>
Subject: Re: [PATCH v6 07/20] liveupdate: luo_session: Add ioctls for file preservation
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 2ED0080004
X-Stat-Signature: ahna5e5dn3wnkxc8z6ngm13byfrkooo5
X-HE-Tag: 1763434748-826660
X-HE-Meta: U2FsdGVkX1+8f3Yj193OjnivNH9tFRx+TxJQ3CjX4l+kXLuZH5Mg4NGO26MBggOPmKBKAaBHmTxd4M+IUOHW6YphHG78S+TG+lZYP4U27aqq1eVebcNFJgYsQw7aaW8AafCluoSQR+o+XAoDkb5B4edk1azyYHB9cdH8qc3YVeGNDqGmA/7gkZ/63qKkItZ/uFlAlh6EKwHu83lNjYPt3Tc9+TxoQy1jUdflv1y7M8XCc74cTeSKNLkMbhq9xQcLrnDNGt0eSHMLzzq0CctapCkaElY5/91iVU6bpAVp9VdgKGTu12PK/5AYIBTe9W5M2qNyxOcilsmDkw5T6xQ+UVqiPkzcopI2/VFr445cJqKX1jmLvQl2kzZj7fBV91kkc3hlTme86FWkpoMIPkP+lPWxL+4NOQOHIKf9WaqFv4BnedVO7bWE8Sg3ms6O0nBrASzjFbuQJa+51zJXbvX3XLVrJKBvGQ+X6JPEcV4or7QKCd2xIGwJEmKRqmwjbf5Xpu0O6F9kA43F04+4LNFkK1WGlEK0s64uw/VWQgshGHxIAKNd8lkGjpUvCz+1sl2vuxVpSyU3obDG06/oplZWTbVScXmLsPhoAYx4Bjgj6bjrcQwLfKQcy/6z1An9hZCt1BuOrChyn8+QZDanvc9cjrEAtQYrnVQmyBawDn3Be+GAQhS3Ym+ZIfzQVnk2GPZls1CBkWk167nfs972YcX8YnQOkl9JNPKb95e5IUziH9/Z1KOq+sl4CYPMGjhAdIZgUMgCsLSEUamhVKgjM6j3fnMBad1LpKI1vZMSdBQrpWoTdCtf7eKutOHPcQm1puGbQAedM5r66Ox9olkDUcU4g5ZP9yhL6V/aEj3izKnq7Jgh/Tcz4UW76uLKZs/aAh6KODrQ+5xkqUbiTJOQEy4t9+j5+KEl6lRc7ctUyFUITouQOnVz1HaBBBDRA3k0YtefXVt0/5GcepLK9pXcpq4
 r9mbiYr+
 XvolG/nLpdfie0bjXLNvrk5YFHU0G46W4KbH2lMgA4iqSUGULLgPghm5peA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >  static int luo_session_release(struct inode *inodep, struct file *filep)
> >  {
> >       struct luo_session *session = filep->private_data;
> >       struct luo_session_header *sh;
> > +     int err = 0;
> >
> >       /* If retrieved is set, it means this session is from incoming list */
> > -     if (session->retrieved)
> > +     if (session->retrieved) {
> >               sh = &luo_session_global.incoming;
> > -     else
> > +
> > +             err = luo_session_finish_one(session);
> > +             if (err) {
> > +                     pr_warn("Unable to finish session [%s] on release\n",
> > +                             session->name);
>
>                         return err;
>
> and then else can go away here and luo_session_remove() and
> luo_session_free() can be moved outside if (session->retrieved).

Done.

Thanks,
Pasha

