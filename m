Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 046A8D26D77
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 17:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 088E86B0088; Fri,  9 Jan 2026 12:03:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 036FB6B0089; Fri,  9 Jan 2026 12:03:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50616B008A; Fri,  9 Jan 2026 12:03:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D37D26B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 12:03:53 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48C2AD02D0
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:03:53 +0000 (UTC)
X-FDA: 84313047546.18.57BCBE1
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7EE0880017
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:03:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=P7QPvjWU;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767978231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oyvnXFALVV85dAj0zPDPAtv4QErhsz/aJNW7Eaaf5yo=;
	b=cqrxL5iw8KUoUuT7dZ64xAGa5obyRH5Ia5rElJLDHMaLYnjTNwCjJf2IAqPncLmggu8vif
	nrfkZ05OW8UtuNPDLwplYCDUCzfXZ8A2IiwtL9OvlsmC/q30jy/7bp+OIl/Zt7bZigOGea
	C6jhjfGPS2epm5fQ5tGqK/ANl//2as4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=P7QPvjWU;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767978231; a=rsa-sha256;
	cv=none;
	b=SuJqd5Twy87CsDt1omz7fR6IJ2gVBzDJiYEg+h4IkeMbZCWxdhieD8zkysvopDSmYCzHVj
	QsbKkcOyPwsPEX57j++T2KbHRqwHZle8907ZNfijjidtWQFgbYJeR4u+EeSwYGxh8cpHvY
	2Pk59VF7nkN/EB6Xb85uNq2+X7Q7tjs=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-78fccbc683bso50740387b3.3
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 09:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767978230; x=1768583030; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oyvnXFALVV85dAj0zPDPAtv4QErhsz/aJNW7Eaaf5yo=;
        b=P7QPvjWUISLnLxl3RaNc4Yz8BKoCWKb6cf5oHgUlTmK/5ztg2oWtP2dpCd0VsH0qiK
         1GHv9Dz8E27oJvRsTdrE6SObJA0yCuBqmVoLv4GsyJlfdmz6eNLBlSR4EbyIWeiQbed/
         EUOeIw3JKzRPwBQ7wvbIITjDJ7OSmGU28QE6E4F1VZH8+ZHfV+uqIIfy7/pc3jt5yoCQ
         qCMQtU0EhsNqxA8qDPXPQ4cwrMRQVXM8xnZOLHARrrd5J65wtznD7Rhwz9kgLFrw6b6s
         FRAciX4QaLrbDkSJe0e/s0vJrxYNurIHe2hlqZnQBRbV62CnLElm9nNJNkJ66N18wcPo
         +ddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767978230; x=1768583030;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oyvnXFALVV85dAj0zPDPAtv4QErhsz/aJNW7Eaaf5yo=;
        b=D5CWU+6q1fBuQmoK7SgOXyQBcSuQM6OOFbmz/lAuEgeJTGf4Umr03ODe4bmecfHBgD
         MqnhtQ03ohdEfov9zoo3MV+B2okgDt4Zd0YetY4Dg/Uuk0x1NLPKcmYRyd879FT4ILe4
         gJNy7OJUPJu1J9wZ2wfsx0soJ09PgxfEQT8AbZdkvxq9Ag1F3cmKshqszeNZ0Ytz7C+S
         875hKYzGBpTjlE0F4+ki0RdxbKWbP5RQWjpfD81Pdul7SzJ7NZHGBcZQ4jofTwwG6jTz
         LYkBgHbNlEUrHnt/+20dburyxb+ABW+uvjPWb0Dyzt4Y4Ly2q4W1OQyC4iIgBleUM+cw
         qS7w==
X-Gm-Message-State: AOJu0YyDf3I2Nge7GTBe5oGPjO/jbLe/SXN8Iq5DoB2Cj3zLuUzglMtF
	3GwBzKJry+LlHQbBRS0vK+KfGLfX8PZKt6hThEY3WI6spiCgM3A2PUU2Q809YmR4Vt8=
X-Gm-Gg: AY/fxX6WidIsyqAF/naKw9cCiOac0iTgnmdvmInRv605MzPdno3Mqkk7ww5npzW3TV6
	K/JZjM/AaqmIxZlL8/vHiyTCP49qMCuzDd3Cka3/8/l/A3vwq1aHyZpLGm9/SfliS7nDGApamAW
	7x8gPatSdrIW4I45oQcDNxC0orLixfbtd7UhYnJ0KJTfnCxQ9r0HLGJgRBfJlGaEHgm444dc6cb
	1QDAie+OGQTd0gJA7f5I/TlH9BDwHgGws9pcvBeWfgJOzsSzILlU8gg/NRhljzvkghV6IFuzM3R
	L8KHA0LEUepsKTHDWQ2Lh67KEEeBWzolDe9asIaCRAWqhjvAdZluH4yXLw2zm/IhlSn1MC/EuUN
	OHM31Dd/nc7OEHeZotFKypbExfEa5ZfT21xq1y0q1BEULmmPhNDujkceh5EjaFj/8uKzAmBoV8Q
	xpVxlHr/7B6OJnCfwiX7Gl1kRqdFP2uvkWTp8AkGP9IOZyOEFf8ZdaQKuQRdr396uvTFS1jQ==
X-Google-Smtp-Source: AGHT+IG5ur4wn6WRv+wDPnOobb9XgNDN4tAmFs6v5FHNYg3NZYd4D74cNfEP3p2oKp1wSQ0Qs+dvkA==
X-Received: by 2002:a05:690e:4106:b0:63f:9cef:d5f4 with SMTP id 956f58d0204a3-64716ba363dmr7881450d50.36.1767978229938;
        Fri, 09 Jan 2026 09:03:49 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8907710632asm77625366d6.24.2026.01.09.09.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 09:03:49 -0800 (PST)
Date: Fri, 9 Jan 2026 12:03:14 -0500
From: Gregory Price <gourry@gourry.net>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com,
	longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, corbet@lwn.net, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, rientjes@google.com,
	shakeel.butt@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, chengming.zhou@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev, osalvador@suse.de,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	cl@gentwo.org, harry.yoo@oracle.com, zhengqi.arch@bytedance.com
Subject: Re: [RFC PATCH v3 7/8] mm/zswap: compressed ram direct integration
Message-ID: <aWE00tFHjyXnNmtD@gourry-fedora-PF4VCD3F>
References: <20260108203755.1163107-1-gourry@gourry.net>
 <20260108203755.1163107-8-gourry@gourry.net>
 <i6o5k4xumd5i3ehl6ifk3554sowd2qe7yul7vhaqlh2zo6y7is@z2ky4m432wd6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <i6o5k4xumd5i3ehl6ifk3554sowd2qe7yul7vhaqlh2zo6y7is@z2ky4m432wd6>
X-Rspamd-Queue-Id: 7EE0880017
X-Stat-Signature: jhyu7137scpj17nnb6ggkyffsbhj44ni
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767978231-9049
X-HE-Meta: U2FsdGVkX190xnUo2CEbNQ1VWtnGhl1bm2cdZbdkn+Mxf6EKMCqi5b9PH82owsQ+zIr8INiut5BT56nZ9GcjFosWpdOOZZ+Qt3xwrzOt0jcJ5pVHVEN/ibYFJKeaiaMVdU9U0zApH/13aCG1c99IyJzMIMMrR5t8TkWTyDkCowlzc9DhJ8pQtT0i5OqLnn2q4qJj2R2UdlU4Wx2M+S4MSEF5MtfLjoKXbtIl29PDazGI3g1IckN1fc+Bg4FjaOzNYlVkrILQRQLgvIQoAbOHVLNc2FoL5lD/s+ufBY+HxWVmpg3K0e6NZt8BZuI/+of87cwNy30sI6kcJRd44npkvEfEf/B+4uRH2ZPTxvCiXJxTo+CIrOhA1xI2edAjdLpsBl4k7ZHOR9OtkSFMoWufLZ31bgQImIsAMta2r7kXNgXhsWBSOJDAm8nCqa9Zw0xqbDF2U3hzzXe8T6wZSWxJ3qaGuSb1D8AKYC1hD+u+XVesCHB3k0M+iq8gv1aKiT+HP03vkSU+lBMF37bFbS7obzPpZtjn+/kfYKacjmfUdI+kGVQr66uI6xjhc0czg1hOcLZQpLaxT6vyAAlZdH9mDIPrq4NMa/Q3SRs0SIc9ol4dce8ug1HoCRuGsN5Nl/e8e+kBh5vRhWcGntWFc0BkWuacpaH1vRU90I93ROOInnnoXMZ5M7Fjh4hMYkz272xWO8DjzMsZA7Vo2gY/qL2hRmYHLe47CiKJ2jtuILchp9fZMfuaMCW07k12Qgu72YzZU4GyILifw88aj9CSbbB077NBRIFbT3oQnVLVv3Hvp6391mV/AAVeQxt+ODescEYUNXV5ZKWr6B0yvcc3yQ0RBcNCRWci/WeH81loxt/GF+D6QgDnKVVpxn+wFguM19oJr+qk+yxSFPllL1swL5x7V3xDRslGv8cK3a8eIWqafJFs/CCKHsS4QuD2HtuLNeLL36th9WUmCj/OiGiQwCf
 0oLIQKgb
 V3u1DgpjlzgapIeZtBPug+Zen6TC3XpD5Wt/CJjMypFLKykUbhwdIJ0uAkNiUaACOi1nyh0bFHtljuzOzcTQnjxj7YjtgvZYJ4CUG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 04:00:00PM +0000, Yosry Ahmed wrote:
> On Thu, Jan 08, 2026 at 03:37:54PM -0500, Gregory Price wrote:
> > If a private zswap-node is available, skip the entire software
> > compression process and memcpy directly to a compressed memory
> > folio, and store the newly allocated compressed memory page as
> > the zswap entry->handle.
> > 
> > On decompress we do the opposite: copy directly from the stored
> > page to the destination, and free the compressed memory page.
> > 
> > The driver callback is responsible for preventing run-away
> > compression ratio failures by checking that the allocated page is
> > safe to use (i.e. a compression ratio limit hasn't been crossed).
> > 
> > Signed-off-by: Gregory Price <gourry@gourry.net>
> 
> Hi Gregory,
> 
> Thanks for sending this, I have a lot of questions/comments below, but
> from a high-level I am trying to understand the benefit of using a
> compressed node for zswap rather than as a second tier.
>

Don't think to hard about it - this is a stepping stone until we figure
out the cram.c usage pattern.

unrestricted write access to compress-ram a reliability issue, so:
  - zswap restricts both read and write.
  - a cram.c service would restrict write but leave pages mapped read

Have to step away, will come back to the rest of feedback a bit latter,
thank you for the review.

~Gregory

