Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C168DCAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 20:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29EB28E0013; Mon,  8 Sep 2025 16:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2763E8E0001; Mon,  8 Sep 2025 16:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18C708E0013; Mon,  8 Sep 2025 16:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AE398E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:19:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CAD6F13A258
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:19:29 +0000 (UTC)
X-FDA: 83867198058.10.8A8571F
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id DCD2B18000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:19:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LMnPDVgS;
	spf=pass (imf24.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757362768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEKhAzri7BBrxNHU6CjKqcmbERBZnrPEV1ur7Br4EzE=;
	b=5iSz7MGiN+m3VemygEHJSvA8pAJHgzL3vyBxhACTnHhp6GbeS8LmcDb0+uWMrMsSQlZWk6
	lAIIbz9iBVFfMZk3YZE0j1qmo2go+YE85JdI8wCSYgs9RMOQn1O17itsKczdRJtzM/8zBI
	x6oSKKMb3rpAkgo3QdwPB7QQMg5dkok=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757362768; a=rsa-sha256;
	cv=none;
	b=DS7KxxjJ088mSWDsrHDQh+i+c0aQexSYqZ1trZKULE5qRYOMUfLEXUmv5yzO8JeiEcMbYs
	m5ZFCaJhZ77GHCSDKOj/ZUNcCLr0jNR+EiNmq8PF1zvfaOtb13wNIA193jCopL+T7X3idv
	tmTbIBvOP8b41pCtRJ9LhlQr9yOsqc4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LMnPDVgS;
	spf=pass (imf24.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45de6ab6ce7so8740685e9.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 13:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757362766; x=1757967566; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bEKhAzri7BBrxNHU6CjKqcmbERBZnrPEV1ur7Br4EzE=;
        b=LMnPDVgS73QqcoedsHGUCktnJoPF/o/KWky4uHn2N/ZUI+RxIqflFrZGHZIbrbzg4N
         TBt+xyM7sYFXmkY7eR0ffKnHsDMWpb+gvlXrts4fLWBDy3znMO0DAYGstLHr/L9unyIY
         AQoziETR1KwjxXN8H9Ua2t2XQOzSYCvJblyFJgKi0Kf3R5dWpPq88/bIUa+wJ+VC/1cV
         dIp2JRILCU+pHOl7r4DSfvxlIg3Ua/ZbV/+1ZVFqfsMaN+0uBP1s0ynQT7OTE/VsmTUz
         QgRvNHtBdK74tXMMMWtp3ZQGgHrJfk55FIH/wSV/e7ufIZhsxfh0OrEJ3rBg+5FNWPn9
         hH0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757362766; x=1757967566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bEKhAzri7BBrxNHU6CjKqcmbERBZnrPEV1ur7Br4EzE=;
        b=whk7RmX5lC8ll87UPPw8WhkgDXh1Jb3Meboz3pmVg79t6NjxnljzIZhEdolwomcEmo
         s3PcSR4tDd4oKrYq+867S4fyzxjBimZUaS9ldsDaEmuZqyAFHdl944LINlygHGAezPMi
         U62kmM0ax3Q/dd8pT7mPpJC7jH88d57qlBSbBbT5iL2M9pvXLK8kW6osSilSZxMrJMgB
         ZCqv+Y6MB1biGrGZR0YykygG+g3Zs/2vw4qnI1NG0pvPCE+14+avSsywxOwQIoatWpch
         xO49ZWDQxqJrQtO4rICW6HfxhlPbjudgUK3dKxd4lGeDrIhAshNSU7lswKH4VuS8AVFM
         GflA==
X-Forwarded-Encrypted: i=1; AJvYcCVruXQXyFa8X//OG2b+qVOml0+xxQTF80qAzrqnEm/kxxCNoGExH0ypBndMs6EG5Y3BT/E33s68vg==@kvack.org
X-Gm-Message-State: AOJu0YwShZHbUWrafNQpTKk1Vs/b3poWoHAUnmzYmRCVlfgM0VxFRZ4w
	HjztlQGdHm5mP+VBNxbSy84N5YX+YTHjnDXJTC5qUYvZky9cXwSqfksncl+9NZdc59jJ57wZ7Vn
	YZkWCc8QThzLLNIs+RWTaKQdp/nkLuNc=
X-Gm-Gg: ASbGncux2lD2lwQi7vyi1t1tm1mM5lyIEYhj4gK57WJqeHlS/T+lXlKBrwgk/D9h2tP
	vJzpA5QmHBtxXF1zkGD5CF4V4AHDmNCnT6iZKGa8BQRW4P2CjJfAPBps0ULb3JRW8JXDXAZRvpF
	cdTPILoIle06FxG/LfOCTRlvDYMItVu+h6bvik1VZtxupdje6d5Yqwue0E0YdDU1X4xaSdfSpAj
	UctjoOGCf02wKfbZfA=
X-Google-Smtp-Source: AGHT+IETXcCyuhskt8NfiuIvMZk4HNrRqt02JjM5fpQLtTPCEi8+CDkXKLs0cMppBKfL27M9u+6qWLgrHDP5cvo0P64=
X-Received: by 2002:a05:600c:35d3:b0:45d:98be:ee8e with SMTP id
 5b1f17b1804b1-45ded05bcd0mr4878465e9.1.1757362766098; Mon, 08 Sep 2025
 13:19:26 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <3339d11e69c9127108fe8ef80a069b7b3bb07175.1756151769.git.maciej.wieczor-retman@intel.com>
 <CA+fCnZedGwtMThKjFLcXqJuc6+RD_EskQGvqKhV9Ew4dKdM_Og@mail.gmail.com> <2xfriqqibrl7pwvcn6f2zwfjromyuvlxas744vpqrn2jthbzu6@nrhlxafjpfnr>
In-Reply-To: <2xfriqqibrl7pwvcn6f2zwfjromyuvlxas744vpqrn2jthbzu6@nrhlxafjpfnr>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Mon, 8 Sep 2025 22:19:15 +0200
X-Gm-Features: AS18NWDjLBMTDDx-3GcgskVrIFrWTkldm4ARgshAhph95s8X05Rv1arvNW2pjfU
Message-ID: <CA+fCnZeem3pBPfhQyPiSAUfp5K0YdHFuRs0FZykF03YXVS-f1g@mail.gmail.com>
Subject: Re: [PATCH v5 18/19] mm: Unpoison vms[area] addresses with a common tag
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: sohil.mehta@intel.com, baohua@kernel.org, david@redhat.com, 
	kbingham@kernel.org, weixugc@google.com, Liam.Howlett@oracle.com, 
	alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com, 
	trintaeoitogc@gmail.com, axelrasmussen@google.com, yuanchu@google.com, 
	joey.gouly@arm.com, samitolvanen@google.com, joel.granados@kernel.org, 
	graf@amazon.com, vincenzo.frascino@arm.com, kees@kernel.org, ardb@kernel.org, 
	thiago.bauermann@linaro.org, glider@google.com, thuth@redhat.com, 
	kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com, 
	nick.desaulniers+lkml@gmail.com, vbabka@suse.cz, kaleshsingh@google.com, 
	justinstitt@google.com, catalin.marinas@arm.com, 
	alexander.shishkin@linux.intel.com, samuel.holland@sifive.com, 
	dave.hansen@linux.intel.com, corbet@lwn.net, xin@zytor.com, 
	dvyukov@google.com, tglx@linutronix.de, scott@os.amperecomputing.com, 
	jason.andryuk@amd.com, morbo@google.com, nathan@kernel.org, 
	lorenzo.stoakes@oracle.com, mingo@redhat.com, brgerst@gmail.com, 
	kristina.martsenko@arm.com, bigeasy@linutronix.de, luto@kernel.org, 
	jgross@suse.com, jpoimboe@kernel.org, urezki@gmail.com, mhocko@suse.com, 
	ada.coupriediaz@arm.com, hpa@zytor.com, leitao@debian.org, 
	peterz@infradead.org, wangkefeng.wang@huawei.com, surenb@google.com, 
	ziy@nvidia.com, smostafa@google.com, ryabinin.a.a@gmail.com, 
	ubizjak@gmail.com, jbohac@suse.cz, broonie@kernel.org, 
	akpm@linux-foundation.org, guoweikang.kernel@gmail.com, rppt@kernel.org, 
	pcc@google.com, jan.kiszka@siemens.com, nicolas.schier@linux.dev, 
	will@kernel.org, jhubbard@nvidia.com, bp@alien8.de, x86@kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
	linux-kbuild@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DCD2B18000A
X-Stat-Signature: trg6n4tn5a18jo5rtf3sjnjfbjy9jx8i
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757362767-173500
X-HE-Meta: U2FsdGVkX1/MOO22ZdzLrRzOd8YWxhEC7Hn20B8oNcUnbzJkkQ+R7kCkhVlvT6lJl6++T8HNnd7t7Uuzl8NP2FaBrCy7fgLc/K5Nc0LsaYUinhvY6ONwmLXb9Y8TFdZAuZq8EqP1b8Syat+Y5WpZZbbQPrzwsSP0s4nIBRbnraNDWhx3+yXVRdrM5/nmk541p9MUX9hdAKTJpuiBvojhMBneArvyqY+9q/6F4iDXytr9OT6DohWC89qPFRkruG+MwVybIn4tZxkj5RS7o9hQCB2cUWQedSB5e9wHF/GNBfgVdLmSeeR015b3hfBBjHVnGHQlgLUJGQ/DZzedOkM36bUPDtZgOK0Q+GM3P+H7cDm7lCQqfm3aVjB72gAuQNeN+AbRs/1WUAH6xkzqSM64MXimGPUQ5I8wVaSGXou3W1wTcxafAzBB91faVQOKS1AWJRaY+zhkCHH3BbNjPlHjcm2I4l6N8lSaje5eJujqU+oezkF1EilLiLVOtkjYcgolIy0ekEk/fCXFjqKUjpjwvs84afV7OwkHkLs0Ak9GIyqa3yFu3HNsls8Br6uX3edit4toSBGkx7zX5F7lT90Zwubzo21sSw/hroYama2jpjGTo86pA127KFq5jhG18X7ycjjicyE9mMGqZCAPJExKiTTqO0MqvHV61r4ViUNe0UkIUmK7hdeBMkJxDcw8WGz95uXBkcolwbYwAjyFxg0aIyqbmTGaSlmTkB0tKaLEv9sZzONkmDNOlakPSDfumwWY1Pq+LYwNCwFuRGDvxiXCcsGC79CqCrnkBEvIiAYff4uqfsrJArHldIKh9G8dOTf6vCjC2BngkN7NgJzlgyKPOaVE+yWWfJwkwGLCbWzXNB7CLPaBqE43HB2T/Nq3W0uv7vby7K/hHLKsGg8byMXE6A5xq6E8XtFas5w4Gcy4ReCmvfU/53yjiCOxutZz4DXWkQgcjtA5GunVwMBELWe
 0CPNOMUs
 KxCqYGXDcgDUa+73+AKIZsaUmi3PutvWEETUcHQ79pHu3563BdNOw52EQWeEWMCmd168pG2abJaliZ6IwcFLtSQ2ynzBAjC8LS2KxOD+VjXc/YKyALowz2o/yRMc15Gg54OPAlvyn+KVFAY2yadUYixu9TCLVJtbj5z9DZ0FplaQ2+zLa4NZ3ldvi64GrD3byf30CJ8ByuzmpRSY7PO3MEd5mBiJZ4/MCgem6ZgAqFSTpFcP7Pv951NhODJcw6wwU+bu1QPMW5+3HWF43rusWYLB8/kNsd0ecjXIltHDp/Gr8Cpg/l+cilqAqArFHpRrmjfVNSWcROjWQFum0vIpXi5hT+DqRKgTXMS/Y9+XgA8mT78le6oJF8Z+D/rstO9VGuNNGnUVoq/kcqzhtOogVUZTtC4GQ1EL1C7fMEy8MkilQqfwBDTn+9CpTu+IFMB2Gasfo/ImxsMWOkwc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 3:12=E2=80=AFPM Maciej Wieczor-Retman
<maciej.wieczor-retman@intel.com> wrote:
>
> >Do we need this fix for the HW_TAGS mode too?
>
> Oh, I suppose it could also affect the hardware mode since this is relate=
d to
> tagged pointers and NUMA nodes. I'll try to also make it work for HW_TAGS=
.

Ack. I suspect you won't need to provide two separate implementations
for this then.

Also, could you split out this fix into a separate patch with the
Fixes and CC stable tags (or put the fix first in the series)?

