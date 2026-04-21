Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD720F5A8D3
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 02:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 243C46B008C; Mon, 20 Apr 2026 22:21:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E41C6B0092; Mon, 20 Apr 2026 22:21:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F746B0093; Mon, 20 Apr 2026 22:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E86196B008C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 22:21:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8BE01B929F
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:21:23 +0000 (UTC)
X-FDA: 84680961246.29.296BF4F
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id D065F100014
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:21:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RYBhqgcD;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776738081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ts4fktzEABhwW/8zC7If98qX/eLs2oXD1C9NL7CTV+M=;
	b=CGV+A8Eo9p4W6hTGG2wqpbVkX39d2AWeB3HjdXwxc/nO2q8L0ZW/F8w0QiJ1fnjWjNVAED
	rOgMnO0F8mkWUk6wtq5Hk6U5tS+XyvPFH+jj5dngBKFSaEiAh0UgMlkdaIN/L5AQdmsMnA
	W/x/3mtvLtKXCAT5Gj1rzIuHtO1WDSg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RYBhqgcD;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776738081; a=rsa-sha256;
	cv=none;
	b=jL5KHLC5rgyQ9JXPsXnVw1zwzlM0wTe5YD8aNuZ1yjvV2+Rss38cjw/WQPIrVkyg7z/bjd
	puX77Ehr+/7H96f0rhJkgr/w5xf5ckjpiUnr/MKEaq43e9gGHeClObp5T/bBUAacGiaDBu
	yuQtfQzphjqqFKGMXUqhAEE8rW77GFU=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-50d880e6fbbso50334991cf.0
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776738081; x=1777342881; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ts4fktzEABhwW/8zC7If98qX/eLs2oXD1C9NL7CTV+M=;
        b=RYBhqgcDuK0694TaUIJQocPQziDqjYaNkSltYD88eIMpGJUygDbMEvqttvAsLNqYLs
         bBgb6/vjyE2ZfCX6u077FHLEHoOe4us6hGCSu7fDp2yOMey9PbafLhIN321+HX52XQxs
         WMRYWNy7J+txJdEPdgcc28QPyRHU4nQXcNWAVLaZMqY1y+9uoerMMZfvkTnMsFdtbka6
         F8pJB5KcYgcfBBUmsmqC4iXzGkC4MPT6wa1w3mFjkE0XKGbQXdJ/s/o5NeHDRskD4yxt
         1vnet6HGwYnpGQl6gEu2Hj4c/EqHoyjgPN1vadzi70doppeg0700ez9rv7QaoKoqD2yy
         Nhqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776738081; x=1777342881;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ts4fktzEABhwW/8zC7If98qX/eLs2oXD1C9NL7CTV+M=;
        b=d4FXUpBfS28wA12fvmwZOa0JcMn2Uop9q6LDbpeTE3ZtL//b6qNzCbF+ksMJCg65hl
         x5RtH3F2K+nwscomHxHs7RgzUZ6BZkZiWxQZNZc7qqjVLg/v04gH9EB40U8EjTPEgE/+
         lICIX3FLOQ6WWmfgA19h5chx6NYOzGZIUZPkTk78lRfuO6M4HLMiL5uLagv8owLixB9f
         /3CQbIFbJoi7GlONv3tg0Ida+6b4HSwBUKfdy6t6OvhytVhcD5PSsHtPvOEtTbGkU8lq
         HHH6t+r8/Om57X9xnVNHPv0GHDo6LyKtFDENuC4+CTMFtc+rYCQwTfT7pAZgFgreMIbt
         0K5w==
X-Forwarded-Encrypted: i=1; AFNElJ+RjBEF7jNXeDb+4byJba11c1JmdOct1ijN8YhkPyIzSXqanEXIBFUNmm4a0Fz3qNh/R9uQYQafQw==@kvack.org
X-Gm-Message-State: AOJu0YwClue0X3btoTG4diDs+N6oLjMYUPK0D++2BO8jQp06KssvpTvr
	l/oMvCRqQG2bV2er0G3/J5tFm91/DkIvUsdXJnCkiuYIyZ1OgqtBES+icafzq2qvKGA=
X-Gm-Gg: AeBDiesDBe1CI80ifV/LKinJi1p4kY8QCqIuO+skz8peRzu54sZEW1uGNdMxpVbaHGa
	6GbsXi2bYySod/0LDJ8iunGr1enPdY/nkRGv2qPtdXXkDTz7Zf/d0cnF88Gds/A1wWkyGQS2WKJ
	Il3Y6fnf8GIASMYPiqsAk37aItkqnXFLwy6Lm2csI3TQCZSRJvltFq1s0wzHx5ICE4R1PAMHJC+
	G6l9Vsp/SyTu5FXSZ/N+He2VwJh2XFdorPRHH0zXzbkS1VUIYRPxU18mItTdN2Jgc/EhMzHbDL9
	1eTaIbukFJYKumbvhY6QxEiLtr4WIb9ua/weFHBXj+iA7B7tOzqEznqrznXFkiYvvuEGzoJ0ewD
	VaDkONotF3NNlkReTWYhttErGtCfpVzcOadnQt1Vrp0DIRwJVm9qvXNgWGwNRAQigZB9Q7aIss+
	ZxhO8PytD07ykFp6s8Qa09OMVTGWL92sPEvMRmsX5rQOnG4UQe+PLga67LbjTJi77O65IaYto8t
	hC4PQQrVuHYLy46mwPfbHI=
X-Received: by 2002:a05:622a:8356:b0:509:2231:977a with SMTP id d75a77b69052e-50e3676f1fbmr145985271cf.30.1776738080875;
        Mon, 20 Apr 2026 19:21:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-108-51-163-112.washdc.fios.verizon.net. [108.51.163.112])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e39495192sm99043001cf.27.2026.04.20.19.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 19:21:20 -0700 (PDT)
Date: Mon, 20 Apr 2026 22:21:18 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH RFC v2 00/18] mm/virtio: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <aebfHrTC4Iz6ZQpx@gourry-fedora-PF4VCD3F>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Stat-Signature: jayfjxbs8954q4uotfn4pzsibcr8yegf
X-Rspamd-Queue-Id: D065F100014
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776738081-731868
X-HE-Meta: U2FsdGVkX1/xFczgPzq3b0SfCDvguhl1ddkdSmfLwGDSbJ57YnI2bLYe2MOWR+/G9VQWHMxoDaERAU23KPg0fgbpRBVUHBmI4sWEdL7jxcubjr5xQ37UAIMIC4KeQmH6/ocltYhC0hpD/mvJv8OlUAFNjkrCP17iup//mj/oqECMRmRM67vBExy/0TRiix05EAVKydMw9HL0DIWhAMUMijLuJIP/coxwTo2nxazSXqpag6h7PuRk56vzzquFdfijVFmD/ww8CHH7CVxrg5/PlGVFu/dr6I4ddtdR/gibZ6qVfGVLfx5l8/kiZZLn2Hk6nOehuF1TKaYIfX8aQ76LdlQJysHMgkrVyn8IcuQjX2zppdfLgfrOejOUR8eebHAuI2yoiuo5qg4hbHxk6EXMmfPptkechgDyyX0cg/Nps5UeWCP/28eGHGI6yx4lhBbg/iFZEMi3feDzcJZYgSR43q8EJCdWPr62Udu0lcz3AeLhxVeYRqJWf0d3Rvw/MoGZeMClf+wa/LK3lrfsXt6+kexrxRrOT/kmsTrSv/QZ+au4nh6ebt8KwW4z+3EJ7WTY3tDcJ3jdp474WGlCidukVEI1X/yKogpX7kP2/7fJKBz88B4izSemptrSB5kwGQGozoG/zc+4vqm0JllLei9+N7O9ud4+4AisFL6XMmGV7ZZwOQXHZEjvTnmf0cpjqUFBrplhH+nMJGh/nRlA4/jzhvvGdUBBOzQoLp4b/eTv+YGrF+MYS2gjRetKzIoTAVtUrRW9QPTOfpfdQmbNasW3J/BczOPVu5hdrSLNmuC+b466x6HGMAA3gbm1f2/T9r9/WpqMghh+iXklv6YtUadI1qRUOMgOAHb2ai0AfIvoAJyaOyjhixFS67eOVOqxzRNy10kVT/5mg+27KKNHOrLZ9qP+XbqhnX5pspR1lG8lG/ovslGXl9sUlWtDq1H2tUrGHme3HjTikHDgzMhC3EO
 clydr7wv
 j2dgSn55/ZsMTtaARKN9h4PHt+e5cow9+Fwe5l2YyPRc4eldlEcAO84WU2hgW2f+MKBRl+Qr0XQR2zXGi+8d4QYnLUxFJNFEbHWwOiqQrEfvKVb2PinN0RTViZxYCmqz9h/1bhs7e9ULbxSfDg+krk7FGyy4koP9F1Y+sV7MQJZZ/DfEQYvoVdwjvhMAwHy1VWT95oKL9pa6GK+rE9XE0RNrx2XJSZNrZY5Xh8UsdCigMLA+bBD5t26KfdExhEjdaCMq/cPacnq/Hz3FYFBXXF4NHSKf3FhTra5WPsoV8JwdMrzfqwIloVf4h3Pb8ItHANoOStEJnE4mS51w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 08:51:13AM -0400, Michael S. Tsirkin wrote:
> 
> When a guest reports free pages to the hypervisor via virtio-balloon's
> free page reporting, the host typically zeros those pages when reclaiming
> their backing memory (e.g., via MADV_DONTNEED on anonymous mappings).
> When the guest later reallocates those pages, the kernel zeros them
> again -- redundantly.
>

It took me a second to really wrap my head around what you were saying
here, but if i'm following correctly:

  1) Guest steals a page, reports the free page to the host
  2) Host returns that page to the buddy
  3) Guest wants the page back -> vmexit, alloc()
      a) host gets a page from the buddy via fault path
      b) this memory is "user memory" so host zeroes the page
  4) Guest repeats step 3, re-zeoring the page

So you're adding a step that does:

  1) page_reporting_drain() in guest sets PG_zeroed if host_zeroes_pages=true
  2) on allocation, if PG_zeroed is set, don't zero

In theory this seems ok.  PG_zeroed being a buddy-only flag is nice.

In practice there are obvious concerns about an explicit flag that would
allow a kernel (in this case the guest) to skip zeroing a page destined
for userland mappings - but i'm also paranoid.

In concept this seems reasonable, in implementation I have concerns
about the pghint_t type being added. Will respond inline in David's
reply thread on that though where you already have notes.

~Gregory

