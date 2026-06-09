Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EB76CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 18:40:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C54076B008C; Tue,  9 Jun 2026 14:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04D56B0092; Tue,  9 Jun 2026 14:40:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1B4F6B0093; Tue,  9 Jun 2026 14:40:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A05D46B008C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:40:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69B22C26B6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:40:28 +0000 (UTC)
X-FDA: 84861239736.04.765F777
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6FA6712000B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:40:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ln99plDx;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.161.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781030426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=65CJZdok3oEZsd2q+cvJ0TIoA8llHzQp0VLaqDaVRho=;
	b=aHPTZLQXDx7U5lAo4Ukfb1pZzXMY603bcXiLjQl1gd/YSluDwgdYjtJrZFMEP0yYCDbAX/
	btnwrv1ZXuzX4codaCrhtNUotlZlGAod09PQx5h7lNAfjhLnKm+Zz9PO511eXgmMzbC8MW
	YpmLbL5UqO1q8LmeXhLoD2pxS6U6KYg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781030426;
	b=xaPjPcVU/lomTIB857CyfTmP8hyJThFYoqA0kWWjcFsZpg7Lk6BRtMNi0D1U4RSFSXNq+S
	l56RWrLcir/l6jN07POSm2VlMQ5QdaipcUNGfiUYJCgtcLSDBeniqO8uw1VFlzJCuqRcq0
	3QdjLZlSlHgxLLrYvwBzRpgEbmxmRwc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ln99plDx;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.161.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-69e1eae4eb4so3899400eaf.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 11:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781030425; x=1781635225; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=65CJZdok3oEZsd2q+cvJ0TIoA8llHzQp0VLaqDaVRho=;
        b=Ln99plDx1AI9hBS6OSStMEqgrEUlNnSuQ/IbiV9ACej4Mwgj0BiCBWELSnbtvp0Bzn
         TQpPFK4d1Mo7rGFS3gvn5tgWtZ3oIJ2x0U8QrW5WD/lbiM6CGcgDMoIGqJdaQnYgC9CW
         tftp1fe0ZHC6d1LLFxdaNKNe2l0SX02YNbSfUd+i1XU+xThwbB0n2yExycB+svnwyq3i
         EbjRnOYnKFYOnh53NVGtke2dMXGtya56iQYiPeqG97A/LRxaOCQgDUZz5s5H+bynINXk
         rIRRI56CkExPBD8yysybm3YpM7zp/DwoxyjxJHUggdmrznBADup7mBsSHeLzk1LV+Boq
         AZ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781030425; x=1781635225;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=65CJZdok3oEZsd2q+cvJ0TIoA8llHzQp0VLaqDaVRho=;
        b=prW9iinMS69Nkuc/9bTUh49RdIRl97jppKhqdqJYUYaRxAiBexFB0Sv0gDxEBok7u5
         I0i2mrOH0N5MBF70h8x6XUfJm1K1hgmiyKgDZsjXUM0k7buFf9WQ6SNDLPYGYlIQNIAM
         xdPb8gU5AOwhpT4rn90PmVfQ2XKq9wtBRyMBRyolxaMO8D5+D4y4swNUgfsULgHVYRll
         eKuIBWv+nxCjNzIU/58qCtuoG0m4mZeflmj8Twf1wQLREupnNWnfgPSy3wowY+QGB8yw
         6Nqy8nCJ6ltIjJX49yMnUj0EU8G5LYxthM0bn5seEwooxMLtcDLoaEWCi1Yr8EaEB56+
         7mBA==
X-Forwarded-Encrypted: i=1; AFNElJ90E4DL6V/T/gfFRsZfOLXJq00gm+9zgC3q4A16/SKk+C9FehIF6/tg6JuKmCsJBpn8KvFIPJyPIA==@kvack.org
X-Gm-Message-State: AOJu0Yy2dMi49ICQHtdQqmURoV0sprL+v6KtPnuHL/HNRC63qCjvMYrY
	nOX/EMnX/uZU2UbppZWIoxmuxQwlyXbrPfMnsFr4k1DSSh2Jr+U/tCND
X-Gm-Gg: Acq92OERFM6QzNuC+ICg6xhZi50d1s+38gTw4R8L8zZiMObv+eLsuO6RCJh2dB/EGB1
	Y3kXrAA7FF+Zf6srJKllZ41M1UAaTQZn4K1TKwPhfSzUHjPEibW7c3fa7tzbzGY7B1yBfVmQNUl
	lAhxAxqihItRCPWRl2bN2+ZXh1pd9BtaIcIrjQx0sTOPh8r6dgXMa+tEPy0DKjV6Km0UAyTsEka
	hlBjWO8XUt1Wgbr2DzUQ65oChKxm2YvxveNFmQYOOpwA11KomttrTXJF7PHG8kZ6W9pvW/cBI93
	MCZ9slXImbJno1D/lTtZRiq1Oy54PGH35lzaKcdlpIT8RqjnfKrowo0BBbHVjKTLX/ixpmfir2f
	hD6W3eUXDMDQqlR1kPcsQ+Pj4jF+0WrG4evIQqANjCeueFFaXSNLAbEDRjUm2TygFFaGTwu8hqH
	ymJW+mazFg4zh4xIxaMh03/1De6km8qVpTozpZlXnh4zhtPO4m+Cl1pBoeknGoUAFu0NBztWdrI
	TKmqvzu5NrDHKq1NjZXQ9qiqwnZjd9ibv1jYg==
X-Received: by 2002:a05:6820:c2c7:20b0:69d:f044:5dc3 with SMTP id 006d021491bc7-69e68b847d6mr8241185eaf.25.1781030425313;
        Tue, 09 Jun 2026 11:40:25 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:6::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69e46405105sm11146756eaf.10.2026.06.09.11.40.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2026 11:40:24 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 09 Jun 2026 11:40:23 -0700
Message-Id: <DJ4QLD7TWSOU.3LEDXKMML5DMK@gmail.com>
Cc: "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Suren Baghdasaryan" <surenb@google.com>,
 "Alexei Starovoitov" <ast@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Michal Hocko" <mhocko@kernel.org>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Alexander Potapenko" <glider@google.com>, "Marco
 Elver" <elver@google.com>, "Dmitry Vyukov" <dvyukov@google.com>,
 <kasan-dev@googlegroups.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>
Subject: Re: [PATCH RFC 00/15] mm/slab: introduce alloc_flags and
 slab_alloc_context
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Harry Yoo"
 <harry@kernel.org>
X-Mailer: aerc
References: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
In-Reply-To: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
X-Rspamd-Queue-Id: 6FA6712000B
X-Rspam-User: 
X-Stat-Signature: wt5f7obcbgh9896h66kbmbeufg7kkg34
X-Rspamd-Server: rspam08
X-HE-Tag: 1781030426-343535
X-HE-Meta: U2FsdGVkX18YfYyohZvR5Q7+qnPmPDhPC+DCoIOAtfp09WWrgn70+OTMQliLpRbdfuz3hDruWwH71BctD2nOz8du+EkQmbWJYftQe+pMZrA7LVQiYToTaxVYOFwx4FRZcbM94rd91HgRYMKFYmVcXjUBiCOhHnlJdAHeWXhhlovqa5+yXsqTAZ/LAWjxaAsN/L6aNgpOKJDlkTKTg6aPvfeg1L0NtPfc3wFUcUVSvrV1OIs0o7LSgM0gz4S0lMQUaIZmX4orcrmgCY00pln794EB6LH2tejZcnIqQXS+2/jhd7o+0gVNeIhzPnCRYV+MKVZpizzJuOaDVW7T06AOq1zQLNE+BxX5bOmRc1X2KjRiQb2vl4yjEREybaZha/w08Z+hwpSmIYPkWBA6MGNQ5Fxyg2CJ8rc/7WeZI1d2CM2t3bdHYmaRiHiSIDAha48JLO1XBK8br+ThT/wxaPrRaXsRAY1l+W3OFlYjpB4dCFpNxsstYMME3aJmdIMbgIFykx+8KaLK2emTqs74bEVwgCzNhAJquJ7LHpfyzA12UUvSkvNVrHY0Lk1HlLEUp82ukAim61WJvPj031u0HDGW8xmkkfw+5/NphN2u8RYYfhD8+8zn1EnGC0fipw1WTapGNfZkkFTUiAycOJlPLLV3i5W5XG4jgTHcEuueOTnAdgBrX5X9GLf/vqDE0dorHrsQVn1Me81mCUakNIgdeWc+l9Y45jkNHmknuLPbO7Fo4L/Wp0A0zqNbxn9yM5hVcoKi9c7bXjSJbP0Oj7fLZtjPkSTL10VLBd1wKqemuSPO25fQmnSgiSVi78t1W2Ln2Etlziu+BuyzJoF4bSFRBG6Fil/0fYA0Ca3JJ07Xgx+dOXSGHpPlgNdHWFz+Q+CP8Sr072LrL6HnIwyV0VrHt/EgrSDrAl2T05gbI/25N+IMQbUInghMldz98SSK/yq1hPrgmVNRLpinxTiJ7NaGrQJ
 VEnw9KnN
 eSiZUdms416JfDYjsiJW/NdLCjCzhjh/DXlncAg11ejqdrDWXbG6wwHyG6OWkaFoEvNjEV6bf7islEb2p4GjO7mzP2XZvAaZ/cTSIswCoEVHU2VqTsPi+3aFZKbNnOPOnaQBousXBI4JmTZC9muLNJsN1wDj48vxrbWM0LX1eJSPlI+897E8rVHWjQwU7ILL7YtmcobxIS1hpcYqsj8fDCmf6Q/uuOC+i0YxymTcGq8UWLW4YlYC+w2EyRWsZlotCYE5284vvh4oQzmdQ6WuAITvOjckVpftxnYRXUwm11i9dq49YSa9gC/v7pzURuzNxopX/+Vg/r9EazvC4Kad4aTNBJCJtdNcLocsVZbL5gUlOphe+0Md2FbmIbLVpnkrhrRhJtBEP8cQx4GlI5+neSPUu5/LOrBInlEl1QMqz76OmGNvO0Fs/xTXYl4oVBsAk93JixqulrH2PhYszARKjEtxnqnJ1rko8R4roz6Br+pqJQ9q9PyhlLWp5kHRI0aJ+9BrblmdUPFrnXmZrrUsUh+A2LeifKL9Z1u26g4FSCUP4/c58B3VHo9wqlo8m4YjlYvPUMda6OYAHcaMGdS8fnn7XopCLHn9q7AznQ5pdWn3yH/+A23RXR6LF9ibZvA5grEoh6EKvxzbBbiJNp1R9Ns2+r4vsSwu3XYNjp5/HUdocDLaJIanKWrt3Aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jun 9, 2026 at 2:17 AM PDT, Vlastimil Babka (SUSE) wrote:
> This series is based on slab/for-next. If all goes well, it would
> hopefully go to slab/for-next soon after the 7.2 merge window, so any
> other work can be based on it to avoid conflicts, as it touches a lot
> parts of slab.
>
> Git: https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log=
/?h=3Db4/slab_alloc_flags

Overall looks great to me.
I would ship all patches except the last one for this merge window,
since I don't see anything controversial or dangerous in there.
Especially since it touches slab so much. My slab-arena changes
would need to adopt it and I don't want to delay the whole thing by two mer=
ge windows.
Harry's changes would need to rebased as well.
So the sooner the trees converge the better.


