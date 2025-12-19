Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D370D711CF
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 00:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4A376B008A; Thu, 18 Dec 2025 19:27:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21B46B008C; Thu, 18 Dec 2025 19:27:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D216B6B0092; Thu, 18 Dec 2025 19:27:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC3436B008A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:27:54 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E6E1571A7
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:27:54 +0000 (UTC)
X-FDA: 84234332868.13.BBF9024
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 87BD218000D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:27:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aVzdyRaU;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of grovesaustin@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=grovesaustin@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766104072; a=rsa-sha256;
	cv=none;
	b=u8+do7T82GDUwuysrDUlWgxgNK1kc75OhWf1mCubMv/YCw0nHuHG08sbjnP3HSFsgwJ1ua
	JF4IsIltFU8L2uJQOzYPO1FXSQSB5uB45x/hN5X1jDgMbxN9HI14ON05A+dO4Yg+03Fyjf
	/O0FqWdqAjn+r4LiyQR/9zrqIKi2fWk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aVzdyRaU;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of grovesaustin@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=grovesaustin@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766104072;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g6p92sJSBgMtlDAjO4F33+QmLqegJ9wBIbGZxC3DXP0=;
	b=3HSr0msK/BNIsQIJsIcKf1eo5IaeFBCmtjZTkrGRiZZpMl2FAUIP8yCdYHsBWDuVNvuUFu
	Mnqh0O58YgoJIxzsJMjFW6KYywR1tlBY+X5LYOwMGL30axYOl8K+npLrzvaIxubUIttGRj
	AzSW7qGYkW2iZKBnyslzqIt5MYgj4sA=
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7cac9225485so1023155a34.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766104071; x=1766708871; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g6p92sJSBgMtlDAjO4F33+QmLqegJ9wBIbGZxC3DXP0=;
        b=aVzdyRaUv1yT9sAyj0gcZGhkDnXlnnA/J8tm3fXFXA02ulTNn5zToczUb0tJ5W5zIs
         nVwARQbORvm1YXBMDpugdTXXG+6Ytkxc/cVoe0nym4ZqRWBbNifdwdTbkk/k6huSzyYE
         NWu2zlRqxhed/0VEzW7Nflhc2QeRqsY5ncfOtnfXF3Lj368eHOS6AWDnsjecg002jPoA
         cVQ8Aw3m9dTxBfqc77UfgTVjP3Qz+QmsiK1RtyhHLti4GweiFVT8uXQIUnzaD6Bv6TfQ
         crj1TIQVumFelgKclTMWPNaRNCYMikqzvTQ7te/CYYl9DEajLvMcJUX/wlhY1F/i60l1
         SeoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766104071; x=1766708871;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=g6p92sJSBgMtlDAjO4F33+QmLqegJ9wBIbGZxC3DXP0=;
        b=FzKoDVw0EXODdrWu5VKArdHYy1K2XxaILZzeps+LiUMhNYgN4hdLXAXQOEQ9Kk5Skv
         CG1g16gyizQnv/ZJ8AuiBgSaW/Y5vdHvC8UzJodRsbHV+p/cE88kPxHy/K8nqg8LvZTs
         CefTgwxu9r9e0NwrPPLFT5kuJN4C3EutmkastsLROuJwsztEPcSXhKvCg4BmxI17NPyJ
         QOS5vRQBH7GOOdMGAiHY6SNedHkpueKEORgjlY0J2LW11GZuYOMzAbVhnzA700jGcgoP
         iU6T2CPZotn2Pe+dMAwVr3+CqXcYmoasvKuNjGxgxUgoZMAYuFJcSIUV5k9Dx+7L+xVE
         Zj8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVvDsplBjyWPCDiFLXORHcaedcdB3XrwuRDQGENGChZAtf3VmAoauzj3zbha6gLj1VCk+iw0/Ghgg==@kvack.org
X-Gm-Message-State: AOJu0YzG3qoudSvo4cLEEFRsAAdyGp+BGCCGCFltwdPQOPy25A+PA6fJ
	LGkmQkNUyDVq+sHveuUg6zF/cqEZzSs7huDySs09WB7iksQ9OaccND4A
X-Gm-Gg: AY/fxX5qf8bmNlaotBNA9UoQarCfsIiH0i/J4hIahbpKWKXAsrtUmgsvcOJEqtduPyL
	hhA0Ruy+yZD0H6ex6phXB7C4L/srskdRi0XhcDZC3zVoQlgCuSmVg9uWIjyiDyCOPS3DjWWaxBf
	mGPysRCaA5bu0eS8P5b/uxgf/NUs5VG4bAZ3AJtUq7+N7yQ5NY18/O6k014dyVMOF4huKqVnZVo
	R5hxqOwTRwJ9oI4F4SlgqMa4SteNLEGwNkID3hi3djWdClm+GwMZz0bh1WzNNbNF5kJyT+eQC6D
	0atDcjG2wff/SNRVyxcMLAr+h4cWfexWo8PwnytTJ90AKTH6O3LHbdHTTiY6ZjIWxU0qUGEs+fb
	M0/RBQ9w0hIezG8LjpZeUooZTJ8Ojz0dFSI3QBLay7Nc8ThoH+jNF8zerUw5CdT2JjHazWg11B1
	Ob37JofFXXy0duRVrYvEa0ij2Yay7EiA==
X-Google-Smtp-Source: AGHT+IERKL4ZyEN7B1vAl3Y9MxIRuqPuP38LufUNlUV7SjP9oOO1keMwPqMl/xHbJbHq7VDkgiFPgw==
X-Received: by 2002:a05:6830:438d:b0:7c6:b6da:e2ad with SMTP id 46e09a7af769-7cc66ac1f03mr555005a34.33.1766104071510;
        Thu, 18 Dec 2025 16:27:51 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:7cbc:db2c:ec63:19af])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cc6673ccc2sm663236a34.12.2025.12.18.16.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 16:27:50 -0800 (PST)
Date: Thu, 18 Dec 2025 18:27:49 -0600
From: John Groves <John@groves.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>, 
	David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	John Groves <jgroves@micron.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Dan Williams <dan.j.williams@intel.com>, Gregory Price <gourry@gourry.net>, 
	Balbir Singh <bsingharora@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [PATCH] mm/memremap: fix spurious large folio warning for FS-DAX
Message-ID: <lxwhxzpuffky4hkw4qgiavv2x5pctb7ka3pnqdyci6w2wd5xch@bt3ehidvftnk>
References: <20251217211310.98772-1-john@groves.net>
 <74npmrpzagba2bbye7kmwwoguafbpvnkxarprp3txy4wmu6gxp@japia7ysaisi>
 <20251218160332.ee5b1c9b2ac7aebabbabfa45@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218160332.ee5b1c9b2ac7aebabbabfa45@linux-foundation.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 87BD218000D
X-Stat-Signature: 89er6yj87ooen43cqgx61ycrq6cpujdr
X-Rspam-User: 
X-HE-Tag: 1766104072-908824
X-HE-Meta: U2FsdGVkX18JzKweMHH9Sfr/p0TjY/bLJhpDUn1QC70CUO/QW3q2zHbMS2duGO65rbAw1R6IvcGXFuEjV8bD/MSexF9QLBU2ojfocOy9oFBMr5d3HAGu5Y8Esf0W4IMOwcAI91eaGZD0l8X+jmpUjySPp9LQ5SJEbuLI7eZCPg50S5g6Q6il60gCXcPUhHqmI7NMRj/nWfC3JKFAkLr0zYjgUcmPyQy+QegbqiBagCpowy1eMa+n74xxoLbeVdD+w6p1OelxeqpZhlK2693rG3lHKpJMn8+I8yiV54ijXzgThidqzcByc4MaNaDhz2FlHWL+PxB9/eKDZXQeAwNuJgsXBr0Kr9o3J+nEL/tJA8Q4AHCmzf7aLbq31ktYd3F78h71xn7x4uvfOt2z+XcY3NPguuB9NY7tzPNoHjcB3poeOzRAY6e7mxu48o8Gt/e0xp6OdM6g4OTZsVsApvNovftd0DsxGSprQQP0IMiAIyTz3fRn9oysuGy8k60Wy1xAZnZdo/k77eFvpu/QOBJS0Z8HHNzDLi4FE6EtHbdpmMUxBTgsuP13u3RAD0tBAcR5ty2PTM7vclkxFU7/wjgqIXV36987gqGHZvCqaLPiwQG9shSVS2mDV8XdwXx/vBA8YvXp0eWm0wFLIyrvfL5cjKJaI7pkQlEsyc6Xogs5fkuIQGUn9lRO0BlkpcemlVi+wS5sBTrf3tF037pCktqZR7bTXE/a9MgzeVnsDRaeCiCn1NlNsAbSCa0BMurf7nwUcnEpqghtTLzjVoQTiN6ogT6JGeGmIDMiJn+JDXywPkHVrh5pvCANIRfZPbXbo6qLj2d1xHu5nalCMOXILOT4s2Yh0P1S+f58b2j7R0AbyUgffqa3lrsD7ml91LaPlNLJWz18eVtwnETYDSJKSSlli6ut3HLfid8QsbIern2yaZ2Dbj4xwN0g/JDBqiq/4lYV4My/LM/ezYRy6bgtY5H
 dGW89LWs
 DkTfr0/xh96/xnOXb0HQ9Ri2DL+qIfMLhX91XFpje+G4BMkxILtaX1gu2JIGMfHLyifCG3Vlgiu2Fy8jB0qQZyyYx7qdZUUb5krbKTlHkpsRJOwUVLxVws8bzlcxR+FV8okXCeBs9XVBLEyUtufofiSo3AEnZHsbwn3xkzZzMeg2D1cCZXxC/CX4/1WnH9G10Vtxtt9FkCfJJNXCAt7AG5dg/2u0fJrFQ+1LG3z0C8lYSE9WQ6RMAjZlWOi5RluqKI1G533WXmSPfXZYJTmPDeODVrbZsYg/HEdFH6PtvnE95avL5EQx7T9it0upkVPnDOk3vomyVMZFQj6R0tUHbezgyec6NDvW5EyptlAIX/gSwn7sE9rCO323hv0FoNaPmYB2oKg2rz6wrv3Cp6IMpUVXOLo75srOs+wULTLDkT4Xy8W3XyoCvRRZ7HmXp5ZaFLJA3acdA82Dh6UkfOo3GrohFGAt9KWWTyuOVcUWoFcIaQ++qFRzjBj/jY3SKGLkzy6hAUCcftmVTHs+mLbikmN7AwQU8a7mdX32DOv5wT3Zf4ZlS+jS4r7Lejh8kJlRLuGDpBOuQdOhhUDsz6/pF9bWwBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25/12/18 04:03PM, Andrew Morton wrote:
> On Thu, 18 Dec 2025 09:58:02 +1100 Alistair Popple <apopple@nvidia.com> wrote:
> 
> > On 2025-12-18 at 08:13 +1100, John Groves <John@Groves.net> wrote...
> > > From: John Groves <John@Groves.net>
> > > 
> > > This patch addresses a warning that I discovered while working on famfs,
> > > which is an fs-dax file system that virtually always does PMD faults
> > > (next famfs patch series coming after the holidays).
> > > 
> > > However, XFS also does PMD faults in fs-dax mode, and it also triggers
> > > the warning. It takes some effort to get XFS to do a PMD fault, but
> > > instructions to reproduce it are below.
> > > 
> > > The VM_WARN_ON_ONCE(folio_test_large(folio)) check in
> > > free_zone_device_folio() incorrectly triggers for MEMORY_DEVICE_FS_DAX
> > > when PMD (2MB) mappings are used.
> > > 
> > > FS-DAX legitimately creates large file-backed folios when handling PMD
> > > faults. This is a core feature of FS-DAX that provides significant
> > > performance benefits by mapping 2MB regions directly to persistent
> > > memory. When these mappings are unmapped, the large folios are freed
> > > through free_zone_device_folio(), which triggers the spurious warning.
> > 
> > Yep, and I'm pretty sure devdax can also create large folios so we might need
> > a similar fix there. In fact looking at old vs. new code it seems we only ever
> > used to have this warning for anon folios, which I think could only ever be true
> > for DEVICE_PRIVATE or DEVICE_COHERENT folios.
> > 
> > So I suspect the proper fix is to just remove the warning entirely now that they
> > also support compound sizes.
> 
> So I'm assuming we can expect an updated version of this fix.

I'll send an update Friday morning

<snip>

Thanks Alistair, Dan and Andrew!

John


