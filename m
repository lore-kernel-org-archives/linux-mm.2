Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 207AAFD9E1B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 22:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EDD46B01A3; Thu, 26 Feb 2026 17:49:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29B386B01A5; Thu, 26 Feb 2026 17:49:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F8F6B01A8; Thu, 26 Feb 2026 17:49:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF52E6B01A3
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:49:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E0F1569A2
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:49:20 +0000 (UTC)
X-FDA: 84488100480.09.50E455B
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id C48E62000D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:49:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NpUmiSzq;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772146158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oYDaj+HYxxwd2SoII0inXN8E5ab2WhHpXFva2vqM1nA=;
	b=y00QsaThtfZS5cyW5+ADrRNWlMgDCP9GAdDJ+5regDMdJF0dmzQQr6MgltcmyLqRk8dJIa
	s1BvmJBO/XsgexhGSsYa7cCaNAoOTVOU/FkjAU4HKD+PH5K7GDnMHzjGtV/EqG1B9YGgPv
	vYf0ptp8A2hIy0jUAzDv8GKYgmWFCYk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772146158; a=rsa-sha256;
	cv=none;
	b=h7npm3MbCGNELdYRK6dgAkJSSibnXZ3PDlHsM8zyRw+JrItxpbVFz9y9OskNcb6d4akrYw
	Q4gboE86zJb8mCG7pYEgSRFhaEnw/0pb4AZX35Nvwnl5qtMP+F6lJ7ORTdYYSpSEoABh5i
	ZQBUSmuoYilW/J3zxpY/oXFRQGyiSfQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NpUmiSzq;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-506984b6d83so10146041cf.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1772146158; x=1772750958; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oYDaj+HYxxwd2SoII0inXN8E5ab2WhHpXFva2vqM1nA=;
        b=NpUmiSzqBFyMYddAD/R2LmnfPsIgayAg8MZO5hn2VwGbmQppaJO36Lml+XtC0cz+4s
         N6NR0Z+JoyPs6/wWEUj8SKnHZ6T0He9y0EoyzdNLvs0TBCsUHTCYvrb6oW9sjwlH3nhJ
         RCfitgAKc+F1q+Do9oP/5EDEVFEcr1jKRu81b0GhINosCEdrT7srjRRuTOR4W1YvLbH4
         vsNXWZP5OxcqHMKGB+lq39CNhTHFs8qAey1hPetoV0Hx7uSnNaHBN1Jnn9pF7vOoAjlQ
         9HUP0EKtrR/RXj/CTjJKyytMTeS0/RS+GZ77wbqJvaGDbqysZVncFgvipTefwF6ogAx5
         CcCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772146158; x=1772750958;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oYDaj+HYxxwd2SoII0inXN8E5ab2WhHpXFva2vqM1nA=;
        b=uT2QCN2pqeT8GgnxIQGjtgn6XKzTaZmzq5WY6DYTWcwG36qijSyN/HvjCkFp9XHVhH
         y/eOmGzrBg3mvl6CevQ3ukx4ZICbV8yZcl0L4BmqRY6WxYwV6r1YAhwuG1NuImz49T2N
         +Bgq1kwNOgLyQeDM3RFxQUgOZhBefv9f0r7Ol+ZPuG4o38uxz3XZV76yZYdAl4AkX4oi
         0E+uoo1sbFUMxak2rvjVbuCMrzr10+TgzZfpw6CwI5a2WwzUXx1joMdx/jxvyLAc6ZEq
         mcICarYcmA/avSrXEqb/jxg+kc/1fauAaH6roJYfUNUTimaKyD3Ka2nhG5jcotj8tnbB
         JI8g==
X-Forwarded-Encrypted: i=1; AJvYcCVoAZmfDiC1TId2H/KKA8NJ2suTvwzJVvgwK5Hmu7UPwkBWIzbuDB81I7FzCatCP95gGF+8PUrVpg==@kvack.org
X-Gm-Message-State: AOJu0Ywko6HO3BAk/cEMShPXQZfkVagUl37CdrALjnJKtkfS4jQKDMlU
	X1aWiYgzA3k0Wo6NAZMHEGTw6SvZn885B8AgcSMl7JaHIDlkyZjZyGuCl//FAT2M3Cc=
X-Gm-Gg: ATEYQzzYzTCQ9HPnruzg9k7236fk31o6lDG76ptFjSFljDl/EtRS+E2rkep9lEx5v6v
	z1SNA+BUhZ+i0RdUMf7OrZCfI1z36VTAESCR+1WnMOVd+UtWmuq/2mmF/cNPNfON1Y3+rgcDY8P
	HpKeqinyQ4Ce4ueBAXtClt4teKqJ6uNOxSsB7lJdnNnhCgFJ3WYFCUlgFzyFDNEj5ljFWPKRqQL
	PJ+RsEteo61X+OhZNqBvKYfDpMBIraF7zoQfReuM1aSso2DEFEJ1jGZXEuRIARdFRYvwjckE65+
	TWnEzS5BiNgJ32Gspyds3wcP8+ZmcXU/kfCSwh7q97MAPn2nbFrmSxspKql6Oq4+1zbTt5P8lwl
	nhnLyU1zNuohIfschvipOAOAemr8isFowJxyZ8At7ceyuTQ9keZJ9L3+QPuDoywvwCbeEAXacBE
	XjixvhGzQc6VDcx8WIhibhgfQ2LL2O4tZm1xAaUB1dVC8nknLj9hODXJypsOIrUAkcnso3V8hH4
	r9vGuhWSg==
X-Received: by 2002:a05:622a:1984:b0:502:a100:4054 with SMTP id d75a77b69052e-507528c1f89mr8534231cf.23.1772146157581;
        Thu, 26 Feb 2026 14:49:17 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c7159b72sm29449326d6.7.2026.02.26.14.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 14:49:17 -0800 (PST)
Date: Thu, 26 Feb 2026 17:49:14 -0500
From: Gregory Price <gourry@gourry.net>
To: Alistair Popple <apopple@nvidia.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <aaDN6ocubzGUz6zc@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <fzy6f6dpv3oq3ksr2mkst7pz3daeb3buhuvdvcw4633pcl7h6u@mxjgiwpg5acv>
 <aZ3BEn_73Rk8Fn7L@gourry-fedora-PF4VCD3F>
 <a6izpi2wlqro72erhbvxhlx2lwdnae7my3ghfs6t33ivtixo4h@bi2u4x6qv7ul>
 <aZ_gALm7aE3d4IcP@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ_gALm7aE3d4IcP@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C48E62000D
X-Stat-Signature: 63zoaxf8k3nj4n7jizbgpnbik1boxpzc
X-Rspam-User: 
X-HE-Tag: 1772146158-96750
X-HE-Meta: U2FsdGVkX1/S8Y7l83zRytlH8BeN51RrihmudC9pWFe0nwmiB8P746foDNAtRA77MMTw7AXvhOmdoXXui/5D7wYERdRT89iQkXaFcczAxeTyazFY8uOIBSE4ykTtxXDGVi0ZORb/hwrpUMcm4tt4GNEVD5divAgDavwfLNc1Wb+7rpiSw+frgW96PiZyuJmTqeqY/Q3bSnY5Gjmt9p7jTVAMmmiG+J2beIURjOpzPwgXQEi820AO9zPL0sYvQJ5nSr+VpIKXpLt0SzwOVvq7Cucpf7MwSKGFxgXYCPknD2Mp/LR3WwmUPlLdXDIHtLgtQrux1AZNTZaW4YVDUM/jokNU/kzgCJk2rudS3yoq59w4pYihbao/86pk5CNBVEtIbKzX4o1TTLbhv7LIwUG9K74ePpLGbvTnqrvJSYvCedUi6+DQMusUA/fhlYPyD+LLmqyLlITiRQxcgu/iTps7YBDO0B3mqEqgVIg+PPQPrGStTHfVPCjWmniXsYAeNfPYwNZ2PryeiYywsopRRl+cbxxY/r0klHrYzOimLHl2Opk9OvQltYS6vXZq4CO0E4sW3z+oDUNJIxblvbieU2dH50ja3ku81MvaD/uh93T5wyOq8ipjTlW30qrsXgeXJkwNU7q7aEi2aPtIXyBcGLFqwqoWJy2iis7isEbPo1C3/DWaAz+sCzb04ezMdatbxA8aogjbcNjcQ8Q1Zux5QGyd35U6Z/GHGofyJlbo7QF16A+iztJiJsy3HdJMRJwc/uixFKAjKxeGD3/O3x3Yc3g3OMe91jToiGwTGPG5+SDwsCzTrGLFbSIyl7HGGzNj1PlDbJta2GARaJUFlhqR4oV1o+KrlTqJhAlCr2nG1Ha/W0wg8Nfpy95BnexgZv9jEgQ2BldvpWo+MeH4QyZkg9YLC7H+Gwf1+obzZO9KZGY9+JBYOcRxw2IjSed803i8ED/n2f853hT5ddcR2g0k2+W
 mb8FBwC8
 cCQIKFx2tIA8BiqByB8tPGMR2IXXoJAZx1/+GPMfp9D/NVChSid0n+qnrRQaMDXxT3wFjypdATybbWIVsW2yWpeLEOhzSWvwiH9Ki
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 12:54:08AM -0500, Gregory Price wrote:
> On Thu, Feb 26, 2026 at 02:27:24PM +1100, Alistair Popple wrote:
> 
> > > If NUMA is the interface we want, then NODE_DATA is the right direction
> > > regardless of struct page's future or what zone it lives in.
> > > 
> > > There's no reason to keep per-page pgmap w/ device-to-node mappings.
> > 
> > In reality I suspect that's already the case today. I'm not sure we need
> > per-page pgmap.
> >
> 
> Probably, and maybe there's a good argument for stealing 80-90% of the
> common surface here, shunting ZONE_DEVICE to use this instead of pgmap
> before we go all the way to private nodes.
> 

Out of curiosity i went digging through existing users, and it seems
like the average driver has 1-8 discrete pgmaps, with Nouveau being an
outliar that does ad-hoc registering in 256MB chunks, with the relevant
annoyance being the percpu_ref it uses to track lifetime of the pgmap,
and the fact that they can be non-contiguous.

tl;dr here:  a 1-to-1 mapping of node-to-pgmap isn't realistic for most
existing ZONE_DEVICE users, meaning a 1-op lookup (page->pgmap) turns
into a multi-op pointer chase on and range comparison.

Not sure that turns out well for anyone (only on ZONE_DEVICE / managed
node users, all traditional nodes still have a simple pgdat or page->flag
lookup to check membership).

There's an argument for trying to do this just for the sake of getting
pgmap out of struct page/folio, but this only deals with the problem on
NUMA systems.

For non-numa systems the pgmap still probably ends up in folio_ext
(assuming we get there), but even that might not be sufficient get LRU
back.  Might need Willy's opinion here.

~Gregory



