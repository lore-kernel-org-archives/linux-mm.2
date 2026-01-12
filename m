Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B458CF45D9
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 23:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8F426B00B6; Mon, 12 Jan 2026 18:40:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A127C6B00B7; Mon, 12 Jan 2026 18:40:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4376B00B8; Mon, 12 Jan 2026 18:40:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7B0A16B00B6
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:40:59 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23EC6C8488
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 23:40:59 +0000 (UTC)
X-FDA: 84324934638.02.358193D
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 472FA40013
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 23:40:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=YbkL9YiG;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768261257; a=rsa-sha256;
	cv=none;
	b=K0YyuoEPMOkShzm6pqEWkwd8RDankBIyrsbQgROtnvka1f2fV0Z/RyOjODdXKCWbOgackf
	nR/Urjwqcbxj3sLriaqU9fvJr8chtUbxXAHfCdGLZmCjbSM5gwkcH+95YoI7XCDspm2fO3
	g3CbYo0aGJTeuJR5I+NAj1kCfgnEVvs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=YbkL9YiG;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768261257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CMPIlr+0naNU5kMo2DwX+nChgxcRBVo8GV+FHyiHDrM=;
	b=JeRJyw7TzCxLhaOnFFP21YrRlUVz0Scu9DztxpXml3J/m6XZiWvSrAbZsr3gshhD7r6Cxv
	1smn3QjhsOSDLMZK7uGVgN3WzqT/5zd4RxT4Qm1FY4Y+cXs4Q7sF1SPfgWElANgYIy+hNW
	2BTrjLu9yL5hKuSvl+AoM5lFsnSwp6g=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8887f43b224so109598736d6.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768261256; x=1768866056; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CMPIlr+0naNU5kMo2DwX+nChgxcRBVo8GV+FHyiHDrM=;
        b=YbkL9YiG6CW80Pl5XFTy0INuGcJ9IAflod4kcnDkSh6fphvaG9wzwm8dBOGms9BsNN
         ZFqIFBqdk/2qAI9lfQIVipoKNJbybTHahY6sH+SjZwdxijuQZ37JT3ZgcIKU/Xyxphyw
         IDuqh0hcME970KPptNWbiu+Mg5sMcclAvvTRZhTAq3LYh2+WEUnEYDSiQQWIHXskziSL
         3lZoH8bRE5vQLFZjAr50tYOZYQ6yLMhSrRanpBj1pNjI7cw7iEBkun18ZxjZ2REkF5Qn
         k+n040wtP6/SBJKfS79dtglH0Q73qyNZTyjZ2Z22zNVy9nvMa4L5E1SgtFiO2JFZWtmo
         JX5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768261256; x=1768866056;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CMPIlr+0naNU5kMo2DwX+nChgxcRBVo8GV+FHyiHDrM=;
        b=VycmYmntspj1jITyUlS+K6BiKAJFaeFP0FbtC3zNDQZixACfbZUlWr+8/QZfXm1/SL
         N1hmxdrPckX/vTmEzXYKSVvGdYDPnFCUBg6LnDBbJmummSRStKw0eb9GQ59DTP9haZlX
         ENA24wQf2SMzXV02QUxOuPGJnBWStexGvtuNUw9Rsrg/8idZz6NeO6aACmSdQsjgWCBK
         Q1PyZ0N7aQI1Lf74ApEOFWgxSRMGuXoFwpaCXHLkYbHs1m+QmnF0wo2xjcxz1GiFxhz2
         PjF0tAqS1FKPi8wgsvBVbtbLxpF4kmfgpHu6H5pUeN77V/gwWtyIzAVUFUXuZgnbvckt
         GGKg==
X-Forwarded-Encrypted: i=1; AJvYcCVeB4+5ydvbkqkkpveN1fLdr5dIUzEfsXxeRypNWyvLXxeJmRRWMTwPGROhVqnMxPYXfTRENEs4Lg==@kvack.org
X-Gm-Message-State: AOJu0Yxb8o3AJ940Dfq30NV7pNF9dedRJmKI3LpumQBxEE4V+VKFifXv
	+ProUbGa0Cx9p1DTFM4k+BuUQGeZrGZmXNEfQQNgh26gqcCgn80ig3n7XG4oXsnPiJ8=
X-Gm-Gg: AY/fxX5/otfzpLgUym4oSaPessWMcSdFBiNCln4xB8twjSjGkLH+hS11W+HS1koXHJ2
	cfNiS2MoPG9yqtxGDmxDpPs60ix4Hk9T314Q3k7D5fJoHEoZZztZA4DdxjQLS+rObL0GR7dFhCT
	V0ytuDpEscQCA0bjSI0tO+OH8craiu4s4cQqwTxo7JlH4OcYwHT8MVR6C5T4yUKE7pLm+IaZ/ZY
	osyAcSvyAl6QzTcMcaN9Dr6vefuA1w5txvdxejEwG/cvB2d0+AttzLY4ja6xoT7B7qy8tdesVwP
	BD0U3csqdbR1l6xqJp0PxkRO8Kx/5TdKKx+i8VyubLVwtgwCri9JnFRcaS7TsJKOjf9tzU+uXJ/
	caydKAIevcIztWXS0ZAf6t4NoyGGVSMmplM1uW3v7cqDQjU8mGZLhIlvSMsJmaejmKf5ydPY9Nv
	uU1JSZbb3NC6ZMu1bzu9SFGgRnsJKm4nhGvHZO19paFIg9R4YStY+PXRJrgK4VXGLKhyICSA==
X-Google-Smtp-Source: AGHT+IFzyx3JnI+bFcbUp+3l5iKXvAuxuT7zO7857F9qVshwDcYCVr5Df5mi4k65Skb1cKr5CB/URA==
X-Received: by 2002:a05:6214:5901:b0:880:4690:3bb8 with SMTP id 6a1803df08f44-8908420e7dcmr284078116d6.18.1768261256343;
        Mon, 12 Jan 2026 15:40:56 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770e8cfasm146393266d6.21.2026.01.12.15.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 15:40:54 -0800 (PST)
Date: Mon, 12 Jan 2026 18:40:21 -0500
From: Gregory Price <gourry@gourry.net>
To: Balbir Singh <balbirs@nvidia.com>
Cc: dan.j.williams@intel.com, Yury Norov <ynorov@nvidia.com>,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com, longman@redhat.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, rientjes@google.com,
	shakeel.butt@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, yosry.ahmed@linux.dev, chengming.zhou@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev, osalvador@suse.de,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	cl@gentwo.org, harry.yoo@oracle.com, zhengqi.arch@bytedance.com
Subject: Re: [RFC PATCH v3 0/8] mm,numa: N_PRIVATE node isolation for
 device-managed memory
Message-ID: <aWWGZVsY84D7YNu1@gourry-fedora-PF4VCD3F>
References: <20260108203755.1163107-1-gourry@gourry.net>
 <6604d787-1744-4acf-80c0-e428fee1677e@nvidia.com>
 <aWUHAboKw28XepWr@gourry-fedora-PF4VCD3F>
 <aWUs8Fx2CG07F81e@yury>
 <696566a1e228d_2071810076@dwillia2-mobl4.notmuch>
 <e635e534-5aa6-485a-bd5c-7a0bc69f14f2@nvidia.com>
 <696571507b075_20718100d4@dwillia2-mobl4.notmuch>
 <966ce77a-c055-4ab8-9c40-d02de7b67895@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <966ce77a-c055-4ab8-9c40-d02de7b67895@nvidia.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 472FA40013
X-Stat-Signature: tix1886bpkq9tfsyhqu1nxd5rpt1okab
X-Rspam-User: 
X-HE-Tag: 1768261257-201656
X-HE-Meta: U2FsdGVkX1/2+f9+SwrPfa71mv1yrofXKWeoKbVAnHubBSqLJCj8EnNjA/fKX9ZOqdeyHNKsgUf4Ajf114A/nCnYd2HKvVGdLITZ/TVTpVPTNaCAfuh6mplUjvS6t9FIrkBebMeMkpBzyUC92gxUrr53WP6KIgd9SMb/skw6ZLyG2eNEQcEk7DkjDXAWMfY2tqDNlwVdpTSLHfygdMwGadskrDU6NZNMVpH1+h4dZivMNL0WGtPqmqGKbG7ZJR7Z6YAtXKjzM8kfIyVxhsqwH2Ltr207xU/bNIGUUlolRRhsEF17NEwAdCudUQjgssQooh36p3wTgBeTYmqPyO9fjdYqnMCccvox1wM62X3WpCodLf+vpBekJfVBw9RXusBsVaYZ2FzIC5y95CRDUel0PHSnAQcJ+MOTvIsuGa9LZS+65lrp+pGwfwihCEzmDcUL1SC80qqKAyHuHhlmOD6V0szngOxaoek7QJ7A/AIvBFJa+zEVRW4ZjVFSSTHOyH19z//q8tFbfrc34H3k1HdBTfzdatq1VuKsPq4riSGjitMWaKsxOizpeV6D2soutZUHO7iS5eMHqt7tuVzPLFaeBgenJn4NtyaygyjyAheqKo5t3qdtNA1SCqgWE/xkQK+j/KJe4IhNDdNu7OYZ4AyIDaMTVTZSbiZZcrhblhVUrEI7UJpfZsFdlOItpgXj335Fj0xLSS6xHs3fYSBx6o3jA3xszU/fntJgGSSpy+nud0M6RaZAUVNXITkmRmLeCiEvKuJzS44KQZ2051YrGXz+IkR2S06kyISlyihcuJZjF/rHEHG2KK8nWU7/TCvxM4AfAtzms47l0BtZhu5E/kpDNtEOYv5JHd+N9iEJfb07htuSMKgs6pD1vEwoycu8pJNc7OsLb6VMI4hZmr/8PrmnTFgbCuqbX8kpPYLkOSQBtbuhd3zdtGa7X8Q+6N1OBVnTd4zegxLH94+6nUTrbVX
 73cxVUOZ
 TYVdNRjGCJN1hEcgVMbzOZS6nvoxVPCxvxmPy8NeCr9JVOyyzyUQlw/+XXhwOicTMTAlS6ekKZd3966X7EPvyxCUYY/Y3MrvdOcqhB0OcAlSyAHZHXS8+8n6ASBh+aXC9VzsskVrBvgqV7kmm+O5aEPR/E7yr4WYhgJFfs3eUSxN0m7twjEYzBeWn+pR4Hr0/2yi+ldS6D+XoPKW8kt/977BJg491J1VlQIWcOlphtFTMm4nXiyObnCjQMwsVwGhMVLn6IksU0X7VgdEqBSPaR4ngjFo1Gjy1pny7ZoliHx4HbC3bFzf6ASs5OcPoJYj73J/0nG/h1a0vltzqtt6PBwuTFkDAwS+eHdVda/r37PK8lTJmrpOoloXb8RlWVG2btDWSVgcTWsVSmQna4h+kP2iriixe4kgGDMlOxz7VAZmQljijBlHAa57NxiAGIKrTNei+4ZWsfOR/sqEzQpFxJPuh8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 09:54:32AM +1100, Balbir Singh wrote:
> On 1/13/26 08:10, dan.j.williams@intel.com wrote:
> > Balbir Singh wrote:
> > [..]
> >>> I agree with Gregory the name does not matter as much as the
> >>> documentation explaining what the name means. I am ok if others do not
> >>> sign onto the rationale for why not include _MEMORY, but lets capture
> >>> something that tries to clarify that this is a unique node state that
> >>> can have "all of the above" memory types relative to the existing
> >>> _MEMORY states.
> >>>
> >>
> >> To me, N_ is a common prefix, we do have N_HIGH_MEMORY, N_NORMAL_MEMORY.
> >> N_PRIVATE does not tell me if it's CPU or memory related.
> > 
> > True that confusion about whether N_PRIVATE can apply to CPUs is there.
> > How about split the difference and call this:
> > 
> >     N_MEM_PRIVATE
> > 
> > To make it both distinct from _MEMORY and _HIGH_MEMORY which describe
> > ZONE limitations and distinct from N_CPU.
> 
> I'd be open to that name, how about N_MEMORY_PRIVATE? So then N_MEMORY
> becomes (N_MEMORY_PUBLIC by default)
>

N_MEMORY_PUBLIC is forcing everyone else to change for the sake a new
feature, better to keep it N_MEM[ORY]_PRIVATE if anything

~Gregory

