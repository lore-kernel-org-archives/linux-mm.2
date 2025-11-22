Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5016CFC51E
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 10:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6F176B000E; Sat, 22 Nov 2025 05:07:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E46C76B0010; Sat, 22 Nov 2025 05:07:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84486B0011; Sat, 22 Nov 2025 05:07:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C45246B000E
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 05:07:50 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 046C513BBAE
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 10:07:47 +0000 (UTC)
X-FDA: 84137816616.19.2A7460F
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id E458EA000F
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 10:07:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Hmyk1j4Y;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763806066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQ4gPN6s8Xd/11O+MQ8+DSVbaktr3U4P884klWVkPdQ=;
	b=ivq3jLa6/gzJ4wWdD5LNSQmDh2NjlBp+haOrc5J2x6iM1KQ92S79PtzbhpAg4iD56Bprg4
	XaroCUoTz/QwgaI6FQgsiPzm9F2YQmUGsl4hcAckQsYizvuevs5wyXwZsB1o7ksqmxZ6dF
	hGLiAkcH+FHCe0/885w4C4NRtcZXDDc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Hmyk1j4Y;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763806066; a=rsa-sha256;
	cv=none;
	b=turWf4JBQ15uKtynOpagUXgyyUgS690oHyw8Ae/ag1f6JOiebCsMs2OaSMXryCda+XXpHz
	l3g6qGkW+FPsKZn6D5dcmkIKCG+50j3t5Fnrgb+ODYJLizbr1vSAmSQQHT+FkxzodZEnw8
	RaCw9UMFs+Qrt+6eHv96zaafPInHnFU=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-343dfb673a8so2856541a91.0
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763806065; x=1764410865; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mQ4gPN6s8Xd/11O+MQ8+DSVbaktr3U4P884klWVkPdQ=;
        b=Hmyk1j4Y5C0DNV/++A189fuLDowSrJyo8yQ1IrDmuetm1HsMxjYAgablsV1ADGA/wB
         IT52b5D6m3lzZuG69Bm9QNylW1A7wWN7x16/j9uVQDNWA7px7oXNHZViGPfnsbYGD3y3
         RKRwsp5T3i0CfsBiBlwHLAcYzHFwH+LQDhgHI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763806065; x=1764410865;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mQ4gPN6s8Xd/11O+MQ8+DSVbaktr3U4P884klWVkPdQ=;
        b=mvo3uHVPLk0CLDeNUYfj9W8YCa4g73jTQJOD0ZCAF1Dh6zcJ76482UxvcK09pSOFaZ
         tEv6LQuOYgySS8EK9t4+IF/IXtasTVH5RxMpzgRe+lDQIYYMjZg9F8eOeA8RPYJtDm8k
         oLOxQV5xEywAov6Ez44ncXsmU+LEGGbwfNhCLKmH3Ab5W7kwrfA9gw+yg6Ms9N2lEVvs
         pTtdqfDZ6pFZoe8mX4PyNDl9ybK2e+S0xpS2Xt7E0I7qP3OyUMrb+YRDYOts+AAUuu0A
         OBK7nqyoaBKCuM+2XdzUoAOhtw+SIfX3cmUF87aYU1Sx/V2jPIQkClsf2QcJgRk4V+/D
         IOvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgW2PSyftECAyKPHxUa+y/YM4pwe58KWlINSXK+JSCGujYXdOB3kLbv7yNpd+tSDdur+/p8Q9U2w==@kvack.org
X-Gm-Message-State: AOJu0Ywh29U4FsZnT/dQf8t+XG+MyGrPFRCAujnstIb95m+u/y5yHhgH
	0hVcJGQLZrYWrG5z5b+7+hZvVOG7+fneE3vLdXRCrSxlWO1G7qNOfJgDlgRpKJU+4w==
X-Gm-Gg: ASbGncs+9/+ikP+3QiqrF6BWrX8GxcOM7HN3aM+dexF1zsytAJN/HiUUrgs7xhT5pt6
	YmfAdA24rFArJsBSNQ8yQpAT1/s2RnYpOdFUll+D3rLS3+m8EzEaHX30twClJaT7Xl483W4Itt/
	RAfV1ISLwmDxbC352kkExe/mU13JWbfMg1X6Tqop/1P14qgGSlf67g/u+zPkVbBs03QOlO4HO7E
	C3uhjdchpRXVTJCfV1TgPzLpp5d/2a9K6d66/sGsiTWqlY1at805nHiEFmrUM6iqX0NajrKA0ft
	19/0fji5c0tqx+ovL3ygIgLOz60Mi8yJN/Z27sJI5s6+/LNPZv/0SmI/pT/616jITcIvuhvSFBc
	yRi4ANzi74H5t2nxv8AMKD3rbnDs7+gv0nOvqk4doN67+YvGMZD98cH15G28mW6CZDtgqYg/Whd
	Rn52WbvbWVNX37kdUJktK1z7kg2xDutywl5qz8uPRZcKBe/9Q/0i4=
X-Google-Smtp-Source: AGHT+IF9STMF1f3EeytoDQYWwe6bTpFK7Jtci+bPHUYf/65uMEfrVs9GVfGDvjF8U9gEVKfwR/cOkQ==
X-Received: by 2002:a17:90b:384f:b0:341:8c8e:38b5 with SMTP id 98e67ed59e1d1-34733f3e483mr5344655a91.25.1763806064741;
        Sat, 22 Nov 2025 02:07:44 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:948e:149d:963b:f660])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-347267a1231sm8047177a91.6.2025.11.22.02.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 02:07:44 -0800 (PST)
Date: Sat, 22 Nov 2025 19:07:39 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Yuwen Chen <ywen.chen@foxmail.com>, akpm@linux-foundation.org, bgeffon@google.com, 
	licayy@outlook.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, minchan@kernel.org, richardycc@google.com
Subject: Re: [RFC PATCHv5 0/6] zram: introduce writeback bio batching
Message-ID: <kvgy5ms2xlkcjuzuq7xx5lmjwx3frguosve7sqbp6wh3gpih5k@kjuwfbdd2cqz>
References: <ts32xzxrpxmwf3okxo4bu2ynbgnfe6mehf5h6eibp7dp3r6jp7@4f7oz6tzqwxn>
 <tencent_865DD78A73BC3C9CAFCBAEBE222B6EA5F107@qq.com>
 <buckmtxvdfnpgo56owip3fjqbzraws2wvtomzfkywhczckoqlt@fifgyl5fjpbt>
 <8c596737-95c1-4274-9834-1fe06558b431@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c596737-95c1-4274-9834-1fe06558b431@linux.alibaba.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E458EA000F
X-Stat-Signature: etfrreokeb1msqi7opgbk9muaxqcbq1g
X-Rspam-User: 
X-HE-Tag: 1763806065-8631
X-HE-Meta: U2FsdGVkX19er98ZDSKpxiN3yUPGxesYSDFfyUUCAeoonBVhAl54yEPXZn9CVhvZ5lYvfjduJbu9s4dr8u1IVHAoOosyLQPHUQ4znTHd3thZENtXHfMqKYUh+fLzlguS6PF6a/OfPnCcDDBz7KjXbkep5o1NgOEcFOh+ftd6xyKhwxHoUpa7ewmGGLVYG+bY6UDhayDrElTiOB4WyiniIhXJvRRrLUB2qTchsuvVmZQrmJecVpro9kvMcVSR76d17H0dOUKlGtyGy62qWg9tEz1cdxhi2HEK/pPBdyco9oVsqhO13FrQ5N0QtZV5M0rfg7Vrnx/R7acy2w/SVWi9i+2BTTpQd/SOiVMDHSLxkELLaPwgOB7URBzd+VG2Y/BTncdtwXuvtcXcHmnQCl5Ug88F5MuhGPWZELDK7qXu8kbftEklOE8JM4MiS99z4rED0WeVWVBGcVJ+YBmLFY0J8k/ifZ5GiCeB2YvkncMJOsWtBww1dlu6NCqYF7FA/zsAeqmK+gRZjHxdfWInr7xrG1pCA937agCxQTEjvj77O4shvuh4hAIhM2ITK+OVizfsEXGtVTRfl2MkfS4fBl41EqpIl5tjvtQGYreoblyrL4sv8mB8+Rv/jt27MyW5GQhkF4e+SqgS47xsl8Mje9oYexfM+mkHF9QvMv/AVC8jo6EkojoV09fBULJS/Td82+2ks5cZbK+8bCCpngmaY2vmyBILquxBdH1obA5kgiX6XJjYMh4jEaCTJZFaxdVUoOcuhw3I2wQns2wZCeu66JcDO1yExQ+MrJPvckRIwhApDCCPRFKs/vbeHRTr5hbua6hPi80RUShh3+4tAVzdpaM8rsq5ZoLGIqqPpBaF2ind/AIdEaN/2Anhz4u2Cf1gqqMaYBY+jaQ8dppJJOx6M6Azam/LInzQXdqWZZ4Q+JJceInXZagVX7Rx4cgLxvpg2RFgt7LKDM1GThQm9KAgOGh
 iP+F+uMP
 7Inm/qydW3h4m0a+ouomFse5H57c0cGXpMXRvCbYTOLowOAVxWL9jmMBAtKgAQSSVVAmuKMcyX0DyqJf0Rs6Z9oE+C5lIW92rAQ7CeM6WZyakmk/BGzptRhgV60CsKA1rDUTTHtFShHIGsq6QdFX7vkiNcedDW0uXgv1Z3PHOxsUE0HxM2cz6ojorogDzxf4R4D2zd5B+K2Qa4bkPhdWwBnv+Rn6fyXKVY8/SwMUerWQZkOLNoZcYnZB6Dbu411LR97374AXZ5YRtcn2h8a4NGMhmVpCNlJyfI3P6EmoDDQ5fca3mcLe0x4wGTnHIKWpRGTKizXuTR+Dq3QK8CCDYQvsPPQ+rBZ2RpxgLvyXcdzaoJRA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/21 20:21), Gao Xiang wrote:
> > > > I think page-fault latency of a written-back page is expected to be
> > > > higher, that's a trade-off that we agree on.  Off the top of my head,
> > > > I don't think we can do anything about it.
> > > > 
> > > > Is loop device always used as for writeback targets?
> > > 
> > > On the Android platform, currently only the loop device is supported as
> > > the backend for writeback, possibly for security reasons. I noticed that
> > > EROFS has implemented a CONFIG_EROFS_FS_BACKED_BY_FILE to reduce this
> > > latency. I think ZRAM might also be able to do this.
> > 
> > I see.  Do you use S/W or H/W compression?
> 
> No, I'm pretty sure it's impossible for zram to access
> file I/Os without another thread context (e.g. workqueue),
> especially for write I/Os, which is unlike erofs:
> 
> EROFS can do because EROFS is a specific filesystem, you
> could see it's a seperate fs, and it can only read (no
> write context) backing files in erofs and/or other fses,
> which is much like vfs/overlayfs read_iter() directly
> going into the backing fses without nested contexts.
> (Even if loop is used, it will create its own thread
> contexts with workqueues, which is safe.)
> 
>  In the other hand, zram/loop can act as a virtual block
> device which is rather different, which means you could
> format an ext4 filesystem and backing another ext4/btrfs,
> like this:
> 
>   zram(ext4) -> backing ext4/btrfs
> 
> It's unsafe (in addition to GFP_NOIO allocation
> restriction) since zram cannot manage those ext4/btrfs
> existing contexts:
> 
>  - Take one detailed example, if the upper zram ext4
> assigns current->journal_info = xxx, and submit_bio() to
> zram, which will confuse the backing ext4 since it should
> assume current->journal_info == NULL, so the virtual block
> devices need another thread context to isolate those two
> different uncontrolled contexts.
> 
> So I don't think it's feasible for block drivers to act
> like this, especially mixing with writing to backing fses
> operations.

Sorry, I don't completely understand your point, but backing
device is never expected to have any fs on it.  So from your
email:

> zram(ext4) -> backing ext4/btrfs

This is not a valid configuration, as far as I'm concerned.
Unless I'm missing your point.

