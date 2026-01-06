Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC23FCD0430
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 04:10:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 331F36B0005; Mon,  5 Jan 2026 23:10:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DFB96B008A; Mon,  5 Jan 2026 23:10:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20B536B0093; Mon,  5 Jan 2026 23:10:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 105146B0005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 23:10:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9461313AA9B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:10:29 +0000 (UTC)
X-FDA: 84300212178.14.5AEF3C4
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id CD0B0A0012
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:10:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Mc3q4ldE;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767672627; a=rsa-sha256;
	cv=none;
	b=PXJOnJ+jhuX0WVwMh2nx36asZtRufK7K+Qxcr67Uxk93BabMGqYwVxYONq3l3HZn2HctgR
	qXeAo12e5MTgtWqk1g+kfNQd+xye8C6iFpZimP1o0Yyk9QcG+bzSbL1DXfU8LpUe8Fyiuc
	AztR10XFaONFhrUp4y2VudZkHdgUw2o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Mc3q4ldE;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767672627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+OFKcUwQLV2v9PqIK3mDB8hb94zaGHv5wTuwcXqEbY=;
	b=TjJXGhKDVtN8pRxSSqs6wb6XFJj89+M8Gp8MkSHGR9GPMljykf0ZWfVewJaKbYeMT5eslF
	LxpLKR5rmGAZHRCY7CF3KME5fJ0mcphkkB2uHEPuF4sfeI6vbw0A7NuPDwswsycRT8U3ed
	8nw7eTkB55F6AJKIyJ/y+9DOhS+W+60=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a2ea96930cso6634545ad.2
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 20:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767672627; x=1768277427; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H+OFKcUwQLV2v9PqIK3mDB8hb94zaGHv5wTuwcXqEbY=;
        b=Mc3q4ldEseubn2mdF3lqufJgd/csi3NrjSiJ/HZGkzS9R884oPTp1tlbqs7jDEWtkD
         OJfS3DqklXg/VcclO1yhqyS5uY2V8yZ4ToLs8INI/sImIy24oPKgllv93SML1NHvTkxP
         8wBV0zBic2uFvQyy1ycg0T6BficLTlARcoPec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767672627; x=1768277427;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H+OFKcUwQLV2v9PqIK3mDB8hb94zaGHv5wTuwcXqEbY=;
        b=rS/XGN+7CNP6lwySkVD37Gr62bKLer3wQ3tgSxekkR5sqF2Jv8BFmLRmFafEVbZHfB
         2/Vu9FplTCMNltAVURlyaHD9k7IhPXV4uY03XZEc6YIF9wDR0ShujA9jmg5ylWVxh08a
         PNIfaw4V4L5RM+361ZE+k1ZSoukn8/WLJkOscnc7KO+5V/Nw0vLLw26iCtkYVToXPugB
         uaUlNoFafokyPF8SJSjlFslwtUe9KdnL6ybg8aRLw94ux2bRtyCKk+s9596/DXcJe9RX
         b4CSEaKf/xG+5bRp6JyorQ46D0k62hD024FXTTvXIDU7vej6np6KxGGBg09NPX0vaWVX
         qoNw==
X-Forwarded-Encrypted: i=1; AJvYcCUBrErS7P5PulqKtuXmy5hXRPiR9Mj3HRwgrQzj3GQRf/QZVj6qgddordc+b7HZPtBHH1KVNNhRKA==@kvack.org
X-Gm-Message-State: AOJu0YyF6IwX745mAFrwtKT/RwOfaAivF5659J9DY1yjGy1CN/CREQv1
	dqptaBWQITsaKVPoCW4k6clQ62O+GaER8dYVSbEHANgI2iMxwnfwXTjq/2Q+d3Y7PA==
X-Gm-Gg: AY/fxX6GPBc6idaM/wGz3H4RMHzZCl7lIUJ9TakU40tnjGJ8lx4DXJsxjwBVKezm3JB
	29zWA+zTrd15kuhqNCXeKwuvez/SiOJWkV+MCKgjJkTFC4GA5vg+3TFYz4nWTgY6tCyNeppipZ5
	PXu46BiPeTdp3JCbng5rk1NxAaaHiwjqKl7jQClducOMr/Lh+ivDcNBgiKrk4edomo6UM3cL0O3
	cjL9T+TM0aNwaYNWDoWbUMJoME14VAsYkiT/QY+KCC230qZOAJyOo+Kwwoyayr2AuxmljC8oCvH
	fgj/53OHp0nnj4n0gG0NpBNDDsod7K0xR0C29/bBVwDI1NrLjrLZumBKvYiHM572/ZWM/XBApyR
	d/BmS9Uyl4zuJw2mmmzf8kvwJchLmNSCw45RIce+OZ64DgjAcjcUBQYpymLeT6hW3U6HEENhOK1
	xiWxLQmIv+Um7v+53ZDHK+VC8UXCEt3Q2BNri5DevYKRMNBBXo63eYjZu1rNMCtw==
X-Google-Smtp-Source: AGHT+IGOWB274iUDn+JrJEbqA0i5pebZsbY9OP5+YwGtgeBk4UeihTRW7iF/FczH0FO6rdlxZeKPkQ==
X-Received: by 2002:a17:903:1cc:b0:2a1:325b:2cba with SMTP id d9443c01a7336-2a3e2e1e6b0mr17578275ad.53.1767672626436;
        Mon, 05 Jan 2026 20:10:26 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:f5eb:5af6:e88e:8a77])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c3a512sm6838165ad.10.2026.01.05.20.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 20:10:25 -0800 (PST)
Date: Tue, 6 Jan 2026 13:10:21 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <itajldflunjechmdpu7aoqdgzxoegkxdvswo6csfbyr6hcbci2@jfbcmevbxoit>
References: <20260101013814.2312147-1-senozhatsky@chromium.org>
 <20260101013814.2312147-3-senozhatsky@chromium.org>
 <ddfs43qldaws5urlnpah3ibp5xeu7st37p5hgdfajvdtwor4sd@fkcm3brinygo>
 <gg5zdpzrk47tljbnaudcy2gnsodyhmmar23qb57b67bhx6ntje@eq2fcrl2dk4z>
 <gdtbjepmea65zajh6dafxiekv2wmoerje7v3qxjundbezdnpps@f5ofogyw7wnl>
 <yr7cekjrssjiwqlkrmreugl6fhywssutjzg3ll45mcvdjklnzy@5vkgju4wwtrg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yr7cekjrssjiwqlkrmreugl6fhywssutjzg3ll45mcvdjklnzy@5vkgju4wwtrg>
X-Rspamd-Queue-Id: CD0B0A0012
X-Stat-Signature: iobjtarn56wixnsujg4ty5ak38bg6hpg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767672627-578863
X-HE-Meta: U2FsdGVkX18SX6Zn1jnH7CT5tbgVSBcXucS9Em9GvEVBOz2poTqrK5wnzWioGX9rRUwIQ49QWXtT8o2YEKX1GbTHfdhUdTmOO5glnQNlGXNIl3eZF4GkPDNBQ6S/Jx8yoQti0Eo+0mbv6U71okCwgKMXse0LCFpxxuz5+yxc6Vz/DUD5Qb+Y6I7HPO7IJsDagHhVtopzA8VV8tduaidbxY7eGK2dIWyOFMxF94PfAIX4ApuNntK0GqJvGYL7O5J7E6nT2MAkey0TKJFqUVxkUFws68zOESiAumwRbz9bQEXcVVy51FBWK/Av5671111YiE/01v4y2yxCJ9N3dNm0riaiGkVCiub4KSlF3CYcO4XrWAG5hdRwEkkg0bxewVpH2mn25nS+3gRt017F8Z2RSgue3qnEUcdCCWPUHfknUIMy3BvENOSStCehC7duOFlg8CzAICOTAA7JLv33ci8CwNTPmhE8GGp2uvqA3ICtzhHTWErCrtlK9BqZq0j6on1t388ENxEp1417dH/zHjAtmb1WCtvIvutvoz0W8A0PPdIJl0H2bgFjNRxxDPrtUQXdd2FT9k8zJSeyLbS8r9Gd0Ct6A0eWY2N2MbZscWmCYNSyxMvzERvicvmRajmzgoKfqBkpa3K8RyfA9e4mlBDUkwOqhlBXAa2vTJ8JNxFkrV7zaWRXv/BVctptqJmxihw6HNvpoli+nmhA1JuMN5aAPZwcmDP8sqLd895aEBCWb7yGtBcdUxRdzZQ2NiY7fiVkif9hxhBbBs0O5S72w1Vo5qZNHtCZCgjK3OQ5DKAV1f/Obmr6HUSv/L5Vldxrg/qbO2tCmrmN9yqgvqtYFGg/COPhrD4QRhqIrpZo1TbTGjdowsHAtaPlGEjWjHs1+wv7S6XGg/zr+bkjV+qKCNsw6Pt8AYtEfdz4fl1Iyv+fnup3gDXqhGG7/EYKvT9zCM2KzjAU85hFFCMz+OWis0V
 kkLw+8ET
 +hhFRQDQHjqejmNI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/05 16:01), Yosry Ahmed wrote:
> On Mon, Jan 05, 2026 at 04:23:39PM +0900, Sergey Senozhatsky wrote:
> > On (26/01/05 10:42), Sergey Senozhatsky wrote:
> > > On (26/01/02 18:29), Yosry Ahmed wrote:
> > > > On Thu, Jan 01, 2026 at 10:38:14AM +0900, Sergey Senozhatsky wrote:
> > > [..]
> > > > 
> > > > I worry that the heuristics are too hand-wavy
> > > 
> > > I don't disagree.  Am not super excited about the heuristics either.
> > > 
> > > > and I wonder if the memcpy savings actually show up as perf improvements
> > > > in any real life workload. Do we have data about this?
> > > 
> > > I don't have real life 16K PAGE_SIZE devices.  However, on 16K PAGE_SIZE
> > > systems we have "normal" size-classes up to a very large size, and normal
> > > class means chaining of 0-order physical pages, and chaining means spanning.
> > > So on 16K memcpy overhead is expected to be somewhat noticeable.
> > 
> > By the way, while looking at it, I think we need to "fix" obj_read_begin().
> > Currently, it uses "off + class->size" to detect spanning objects, which is
> > incorrect: size classes get merged, so a typical size class can hold a range
> > of sizes, using padding for smaller objects.  So instead of class->size we
> > need to use the actual compressed objects size, just in case if actual written
> > size was small enough to fit into the first physical page (we do that in
> > obj_write()).  I'll cook a patch.
> 
> We also need to handle zs_obj_read_end() to do the kunmap() call
> correctly.

Good catch, I realized that only after I started working on the patch.
We also need to account for inlined zs_handle.

