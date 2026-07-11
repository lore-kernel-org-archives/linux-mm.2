Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCE2AC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 06:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C71126B0005; Sat, 11 Jul 2026 02:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFA606B008C; Sat, 11 Jul 2026 02:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9AC56B0092; Sat, 11 Jul 2026 02:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F06B6B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 02:30:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 139F814065E
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 06:30:24 +0000 (UTC)
X-FDA: 84975521568.14.D16DDF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 778D71C0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 06:30:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CA/Q9Pm+";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783751422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9eVIbMKITUevCMOU40dgSnSieoLsS9WKVsiAM/rS2zc=;
	b=0WVlMMIMooifDt3MenHXyU5iVG2Zo6LQqhjDt6HzfHo3M8PT0V9CgXhh63ayl0Z1K6vOdk
	7yrqoGDWy9ShKB3A+IbWgTG3zj54tr/DHr4qtfVF9DHobDNaI1E4QLa/ER+Du+kCGabP6w
	zIZoi3+8DA5KuzT8u0rK++DsPlEbTaU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CA/Q9Pm+";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783751422;
	b=BT6wtSSbX0tIAxBgPFJvT4p/sr/7BEDw2qN3Q+5x8CCtuG6/E89QpvOjrwuzuNXbE+VS6p
	lz9LrDL1hIhCNUr0piyCJlCgJtHND4xJa63G6wImu/+NBaxD+GsV1s5DX9V8Kof0sDQ/23
	qejirvDefapgBboEOcolwiyqXBuanPQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC726600C3;
	Sat, 11 Jul 2026 06:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945361F000E9;
	Sat, 11 Jul 2026 06:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783751421;
	bh=9eVIbMKITUevCMOU40dgSnSieoLsS9WKVsiAM/rS2zc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CA/Q9Pm+cFj2kk4xdwe69i1AbSxfCXCM2cXfUZUmah7hj/Ubo4XRMpolw0xadPgzS
	 gJKPFPNOiaxsBuYMret/fjJqncO1ktz8USS2e9mcsvOvn/mYZdxbB0Tj4MwDAR99I8
	 XjJAHanxpe5kn3UjNk2QvoY7Z9SySLEvrabgtKT72ChDC0P35M1kixnqGh//znv2Eo
	 zs46Q03pLQrCwnmFv2evmTv6jRhyAeUF/oUtnSZ8CgIx3vH1zVbTxPW+gFEiOkzrIz
	 3gFjFIh/y6o02djVfVIAtyQQXW8ufebAz3kNAQo/UlS+sQecIJEsnzo0CVUPuoIX6/
	 1foRf4eXLXDwg==
Date: Sat, 11 Jul 2026 07:29:47 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>, Russell King <linux@armlinux.org.uk>, 
	Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	SJ Park <sj@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>, Peter Xu <peterx@redhat.com>, 
	Kees Cook <kees@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	Christian Gmeiner <christian.gmeiner@gmail.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Rob Clark <robin.clark@oss.qualcomm.com>, 
	Dmitry Baryshkov <lumag@kernel.org>, Abhinav Kumar <abhinav.kumar@linux.dev>, 
	Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
	Marijn Suijten <marijn.suijten@somainline.org>, Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
	Thierry Reding <thierry.reding@kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>, 
	Jonathan Hunter <jonathanh@nvidia.com>, Christian Koenig <christian.koenig@amd.com>, 
	Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, 
	Shameer Kolothum <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev, iommu@lists.linux.dev, 
	kasan-dev@googlegroups.com, linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org, 
	linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	Russell King <linux+etnaviv@armlinux.org.uk>, Ackerley Tng <ackerleytng@google.com>, 
	Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v2 00/33] mm: make VMA page offset handling more
 consistent
Message-ID: <alHiUW6p5dpyoU-L@lucifer>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710154521.435f67cc7b03ed3a9ccd423a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710154521.435f67cc7b03ed3a9ccd423a@linux-foundation.org>
X-Rspamd-Queue-Id: 778D71C0005
X-Stat-Signature: f1xtykr1q8zw4rs37q4k6dxx73fmo5oi
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783751422-248082
X-HE-Meta: U2FsdGVkX19uEZtefbpbJmM/WzbzBu8SnsF15ZFGW5fh5GzVCVq61HiRHL/sMWhFD2A0GWvqMgZ4gMNHKAmQQ6cqN38PsKx5bb4/Ud3iqKxJUnsok/TxvblPNUrXfT1uxj5GH+0UCXOEbzcw+fGvFnUVfpsCm9ky7/JgOPPA/UqpWIb8xj3mu1sMztc/+w70ryGpf6T9Q01MgP8Q2tdfYbN4AuDa+xvyQ4ScL5OmjOQ6+AOL6TRbn/QPcG6/LVoRKeJUp1nigFgwxfTCkpqXOEchfaTuHCaV6WMVcC84qeWOZFcVWouLdyK2a7BwZVXfkNZ38jdbY2Qe5ZN4uU4OeoBNkVtvOKsWip/z3D23QvMp79HLf9Cd4oAIYVpNqmZ4382l9YHxZcDEyjEhIOrsaN1l4rTzmO3dIKMsk6VAxTIgn43I4TEJtYAXJox2aTiMZkeCNoXg9W1h9DemXXTkx4FMAX0OfgdwZu4uUzAr6CEzoCGC8uFLiYzf6yVERjaU635rTBXppZk5UB97UuLdNsywa2kAshmsaeoQt8OVVyHPxgniqPsbBsnAikk8DwwqQYUDeLFxYJDAIffQ54vhDPatEConkrgvm8RI7pe7vN8X5m5PK2x+rnXZKopJ/ny/zZf6O8qbUvcieicafAAMuT5ZxPuRBFirzs14NJDzSmiNImIvwc9fMlbhqdFnEXSUac4WJVIBOSZYr+wZyGdEQBt8KVw8XMGUN2y8nIQOUhZ2mU4x2QjpRo+6rvANPaD7zYm52OncDOERikfWlaOsmb3fuBxQh4IiLfZ9Ym5YbCtanX/N+8jG9K7KNicg4hrCqRlnB/abcHqZ7MrmgaVuueEmYbpPQtuq9grFD5UWSM0tlEHQ+DDTIBjRViO+gT7JDosCpwXnRLV8dzS3LmDK0/rfyv71lpw1kNdMlNf4OQ8FrtS9egfw8BEEFF+ZhvrXF3OcuEbVq7mneD8f3SS
 oxU5uEz+
 Yzmr7Ndyw4bmlnLVSwhFPagofeyMe+A2JZHw4Wmay3PQE5uTlhnKYysBGbK7y0Kf8LYXdT67LLfMn0jW6Z2J8FLV6G4vYUsH4IQIrb17+ddJbXNr2Pbj0jXpssiKI56ZFL+XGs+KiCviIJwgMwX8OyrpDR9EtEBO8po28PKFA2yEdgd6BNK2aErMHA/QvQDzjQA6T3maRJ9Fe4HfMRHiCnYqrCzHiCk67tKV2BXgZHxu4NmMg9XE47DGhLt0vkAHZvu1cKgRf3HUCoUa3iptQjvthDC5kjMmG1gzXltyU4vkjKhIRUpuE/Wu2r2qSJJMsPUQBfDDvzsylChTCDHE7I9dcxCsWZyQv9SpV+cP9zScZpH9xpXLCpy9nvCbwnFrmiJnnw5dZnlm0N74e4crGGYxb8YebwCPozLSHpYrULNgmGSZZQwgvNcmThxyb7/QCZld58El1if9qt1w6qyxU4q2RywhIfw0xI68cOF0kd9fctiRSPddQjK56LXJu5N53WF71W/If/m0FsJFUWA2Lm+PDRh66dPKHa6rInqLMJUrtKGA5asafA0Outp9YTNyCk8zcbU9zpANOvzHWibVLaB8Mz7I+s/eK59EfiSAdzNxSBLzRBphH29s6cjhBUMnMu2vcCxWNoxcXckSzyWGt8/7cP1ggHYFStdmu+EQF6ZNxFfrcwQBNWYImscp4SNF0bedqPpkscoqUo2eBYAOQ2M7/l9WEXbvONhjIxsfB/PwvK/bD+4ndpEmjQRbzXbT9LJqGLusnXtPXiGwRuiLiuIBpt3JJPk2wbxjCK+4/55+AMrOLC2qGKBV1VQCG7WhT2zohmYqywmBR6Vz9w7kvYnlsyqOLxZdsNRKtYp3fBacLLztVD5x3ruFEzeLvtZV/lfscUxO3lRmu+77APkVUEMl7CuH1AGGiti7aEFSZRnTj54KReF/P45W4I/qB0jeZ+AgZ16CB/2SEt5FlTk71PWHE6SPC
 BRkxdkJm
 oAaoKxJfF+uVbTlivtF5U9j9K3pPeXg0Eni9uior0MN3TB5ROoM7XJVOQpMT3l38/44SYZRVL18Opvq2dQGfKp/HcGL9x9WZuGzvF/ZBp3GKEFV3u5/tQ7zHu1paGtJHErqtQOSJGaVNcZAwexwH7Vo8YX3AmS0+Mzten2dmdoagbXM+uIe/em0jFWFW8xmRVVyIjIxzzPBlSv0N2nqaEBnOR5OtWwf0BzcbT+GaHfaaq3qO2HUcRgD3GKmNeuJANjtUG0cLSSbRZ3muaptdJWU9fztD8Twya4E5zBPzn9EaBz/Bdiq1NypFsk3MGK79r2h07UncVPwqxfMKWDmlwj2kCI7vF2mhXwRMrcFSE9MngtCfAo3ExwJuOwfeS1udyu9SayBwbfW02JhyeKmsx5gGZ8WDtGx18rDO2kFfp7+1SkdG+V2dcfpkSwv+blqUe84LrMXVGiMNX2Cv6V3ahDgkEjUEn5Cl4m+CtQ9JHBUB0dRf5KmOeNy2FZ2P7JVHdeiQ8Zrc8GKNV/Cwf9lYNc6Vtczi7KYwm8/FbFEJ8f+A3saXi7zy8u/amWg9DWvnQSzSQTvw9IMTBGrmXEDI1KGy9RuHgpphl876HKUyPa3XbY7y8V4elqUt3tpR3DumN/wNtUmffTkpYPsxXkC8dwyi78VZ9RVQCe3erNpWOw4+dFjjNgINI27vVY/vzyNWvI+A2KM/ag5cgKF9oNBPvBccriPi3zanS87CVExaTg2cn1FWz43m0cHMo3tZ6VBgWty/crJDkJT+hU0M0Bgnkh37PqkZRSCMuT7iCppb1fkfXSls1x2+b3kxTVxrv8coM5PyJ7gmQTGPn4kapezwEaTvrVvB70tyh46PQvi/CAKYhNvferXeWsJmEAz6hZg/eLNeF2/DCm5fuDdLeYfrH6f4inZTY+Cd+ircz7zkAgNqiA8QX4wjYqvB+TR5wwaEO2S4ChbIuc2P/EYBGwdmW4jlHKaKK
 RxcVsJ5B
 SE9Rx+QbxVcwDDpE8Pa7FRkKRDvIJUrgb8L5Hn28cK880Ta5k13ydW7K/pKiuveFswYIE8sSOYEZeHxWOtuaUAfXPCTqFqdgsXo3XhfFehLrCO5tZbfR48GlThC72xLVyi/U0fy6QFIhofat7vSEAs3e6fAIJYjEGJHPd6gieEd1e7W5hnBLTaic7NmaIpn34EwrSCbhcBG1GDAweAlq6T4CyrKf2jrMZsfmKc35jua2oiqkCSbdG/qFLJyHtk8sLHuvRJodGJAy8w91FXxR0KPZKThW135XI9qvyFbLeRfUIhOO55vTmqJw39LAu8hN2AaAQN+7n0g/UNwUsErFZbm+8fOfYo283KjqOYnUfZAy4Gr2uEHmdZmzhbNXH199zROjapXjsBcJLLCgO6TVTYAiigHgui3jPvSwtxgeIBG9A2fAFt6EIUFcUMnBnL2PuqI2mU++cl8GVXHcYNumy0ylEdCHSTDrb5MlAybGMB/iiu2umz2pzdQoeUwNo7V35H3/1MbLH/fPPmXpHGlL0EGWJXDVdeaMZzRZiBDe9dLAVLCCdxJM6S2e/J82vwgyCHYRb93a9wIM6zOI0Us+1eHlng4hWAF/z9uCWnELg1oKyBctPxFtE9XN2YvpVSMhG8eUNmoMOQfNDAtPEcpXRdP7cmanmkEE8Opq882WFWmVmwk5kNrqP3GocDrDEm2uVc56H8iMRuK3bm7Nv0LrpoxgdR4lGa3GUcPSesREI7PhmaCCbL+2XeK/i863PKMgPk5yvPlxlv3NifmOaPvzpAw7lycpcoU8vON5Dm2p/NpO7qMJZSlSfyy91uaCagU8hvBJDptZ2sFUhDd7KoeAJ7XrplMSmNAi4DvfuCz/DeHXJJU7v3Yf+RSm7VN8aR2ctz8oD5UXz0pOq/lLODazEpe9nkx2/B0P8JXNR6hEoQsE2kLv+HC+PnPzqImYY/8BSLN8kzybNFSEudJyZieAOibd0LdIh
 NBE//jxt
 K9hhVENxsvVNfvY97akHtL/1fA1yGb3+Z78D3Y2TTDUUWFI7z7gv5tnmDUwQp0RoN8r6ZLx979IEZ4vee8YjTHwhNiYJdDHbQu5+n5jIip+Qf3X7az2igDLyrFTTRpkBvqU+3rmIdeZkLIjnQcKWbgFRRe8ZreQvgt5O6pHYwc9XKOsLR7cKAKUfiMEytYiQIfQh8giZY4uXXigBVZU5VA9wJ1dCYeC+YnYR5k08wX8qBZrXqQ3/Kq0w8Ty/aBxXwXTCfOQjnIqeFVauJcPFlgGDQ7sOtlSAw4BDMPipEtKyVi6mgDqO546TMdrzbR5VER6i8e7ohKGJAxtTGB31utS68RaPHDmTx3s8l5kyWmkyxOmweOSwoZfoyFvjo9hNmV0XwQY8ewBgiDwpq33V4H6Dz6KBuHm+mxLUVWWLzPrCm9yCC9NAedd7L+ektyzR18gAbZohkwI/zIoVIQ0mfEBy3XV5OzvYtWa+jjXPyv+wZ4Vc6qRB2IBhqBfBowTu3L1USKQFulsg4cSVEu1ndBOM5be0WP0S4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 03:45:21PM -0700, Andrew Morton wrote:
> On Fri, 10 Jul 2026 21:16:41 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
>
> > This series performs a series of cleanups and improvements around how the
> > vma->vm_pgoff field is used.
>
> Thanks, I'll add this to mm-new.
>
> Sashiko wasn't able to apply it :(
>
> There were some minor collisions in ksm.c, thanks to
> https://lore.kernel.org/20260703162510242nxmjbcLy5ccp1dbZSK3EU@zte.com.cn.

Ah yeah, another series on my infinite review todo list :)

Thanks for fixing up!

>
> (You'd think His Royal AIness could figure out how to resolve a few
> dopey patch rejects.  Oh well.)

Yeah it did this last time too :(

I will try to get a local sashiko on it, FWIW I had claude/review-prompts go
over the whole series several times (and as a result fixed a bunch of stuff),
but Chris Mason's prompts are more conservative and sashiko often picks up stuff
it doesn't as a result, so let's see how easy it is to set up locally... :)

Cheers, Lorenzo

