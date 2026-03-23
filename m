Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D12E0F483F8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 21:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43A696B0088; Mon, 23 Mar 2026 17:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB436B0089; Mon, 23 Mar 2026 17:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DA1B6B008A; Mon, 23 Mar 2026 17:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AEDA6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:19:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD05513C203
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:19:05 +0000 (UTC)
X-FDA: 84578593050.29.5764554
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id D7625100003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:19:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q8T2dapU;
	spf=pass (imf14.hostedemail.com: domain of wyihan@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=wyihan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q8T2dapU;
	spf=pass (imf14.hostedemail.com: domain of wyihan@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=wyihan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774300743; a=rsa-sha256;
	cv=none;
	b=nJptalDne8cFqoLgNC/vTRlT5n/0V1W1TEB1gqF7+EAZqFh5sALv1PMRKS62InoSy3rxf8
	lXhsFj8bkK9EVnEw+wcQgDGGRvHS72GOLF4QPq3PNnh6AyNx8ED2DOU2gYL3pXjjAqiuJt
	WCzQs2ZDeVGuBDBeV6uzL/whWkE6q3M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774300743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FUGqI0aW7JYeGUdYKG2R2+j1GF5S/yFvaIQs/WVfzFI=;
	b=H+OLlujkgelCtL500+GDGzoJjIC90QxcMgqF637c8EWExtyET2Lvu5X3RVOt+93mpbvVO6
	SouXofabTS4o3WdC6bsWQyPF/WHXdCj0nLBvfHfmBMvgodpV81yBJKFMbcqcH8OsCKJ6Fn
	+QRmj+0Abh7fwTlVy5uKLu5rHmjr26I=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b04c9e3eb7so28315ad.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774300743; x=1774905543; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FUGqI0aW7JYeGUdYKG2R2+j1GF5S/yFvaIQs/WVfzFI=;
        b=Q8T2dapUgoNVshPAbgNdO9ASijeQ5pxqZbPVXW/ZZoTE+hA12G8fmIirK8CsXNkC0g
         C3/9QZiHeDgpK13oHO1Z7IjxfhkHyxXHBNGBaZ2vkUhahaVm4LHvS2Y5TDyZYt/IS3Te
         nvLNkCyLHeIgU8IOLhk9TPnRr//Cuf1ArtKaDwdTRD3v8JxNOaflT61gwMwG+PgaKrz7
         c+ksJ9f2YLRWJb2FzD73EGmQt9e+VrKABHTJRdbuZ1uguAdZppss/xPQaoX3Ty9CMD/q
         tcrmQKLaihwx8/6p2InoG9KjjoQD7s7PCl9BKb/4JfuF0f5m6+22/uc1Jd9e5wIb56Ed
         ANQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774300743; x=1774905543;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FUGqI0aW7JYeGUdYKG2R2+j1GF5S/yFvaIQs/WVfzFI=;
        b=A4BQhMFDp/UZtE+aD7Szga32ZlROX8DE2kdLJjytLub0qOSigut02rXOE7AkATl1OP
         q8w7pysCWORdAXDSTNE/e7kRJz0MFftzVVnduJatMPerVwZvfSnx/gxZDpGLhrVyYETZ
         OspznK4IrUz0Hy+P+/WL7BEjVQJ7xHCAKAQp2bPBlc2hLILWur7xDE6monjSH2eJMh1D
         YEhELwEok3MB46mcz+VqNPDJiuHjXtahNyyCyRtsbZGQmIzAMnoDPtiOfbB+XncqZleJ
         GOWy/M4IFeobWzhp5xQ+ahWROeRsf2sKtu/6X+k3Ce5VABmBmtcYrHFamSofQ1YF9d/I
         0EKA==
X-Forwarded-Encrypted: i=1; AJvYcCV51FbRI/+zLAu+0wROKg8WQSFkcPXyb7nX/CRutsukMZyql9XiZrwSIY+ZjmnfmsDMlMsfGPwi2A==@kvack.org
X-Gm-Message-State: AOJu0YzbgxXnnN9V9ZTvQZk5nkj0OCcSEWHYyNzIj3cRQv1IAP4wZ6ID
	8viFV6bCl8HpwElIZJSb48eGuzG2Y3L7u8hFGdQlT8PNr9Gvjh27Ktpvmz0hLCwomw==
X-Gm-Gg: ATEYQzxIyemVbzrljjCUWqzviTGUiDpslT8r47yuEc6bfviGjSYkkrg1K5v0tEwANUB
	Zvuu99RCbR7fiC0vm4lNGS8M/aPPjniOSRYU2ZUTLvcUI8nfjUVOfHMjAhUb7BraLb72kYKC9XO
	owcU/+iWgXVsn3VDcYtquiB0+f/KqdPNXbKEQKko+ybl8VkLe71aEs4D4Yb80DBw7GR+bXV2Fe1
	jHrq6nXR1994AuBR8sBRswE7CQ6PXFzdHFi3wEQd7Mx0CcPq80rzspPyss1HoU6VL1x7UTHYHEX
	VfrfzQTE+Zf3HxfP6I0Z6N6fyyON3haT4DsqK2ccQnkW3MYcTEaZrpOuzlDL3EvOh2KpueKN+lO
	A39eOWvY0/bxl7f0efx57jfJlUv6gOlXbdtG+do8ePueoU1iAZMNsjny8qV9bVWx3h+y/o3M2fM
	Fup9Imj1oCixZUtB848SfBqavD1l2B/y7ubWy4yO9DhtMDgdXnBbdj2+dASuM=
X-Received: by 2002:a17:902:e5c8:b0:2a7:d266:d84a with SMTP id d9443c01a7336-2b0a6735efemr308765ad.17.1774300742225;
        Mon, 23 Mar 2026 14:19:02 -0700 (PDT)
Received: from google.com (249.53.168.34.bc.googleusercontent.com. [34.168.53.249])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c74443cc2ddsm7910891a12.24.2026.03.23.14.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 14:19:01 -0700 (PDT)
Date: Mon, 23 Mar 2026 21:18:57 +0000
From: Lisa Wang <wyihan@google.com>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, rientjes@google.com,
	seanjc@google.com, ackerleytng@google.com, vannapurve@google.com,
	michael.roth@amd.com, tabba@google.com, dave.hansen@linux.intel.com
Subject: Re: [PATCH RFC v2 1/7] mm: memory_failure: Clarify the MF_DELAYED
 definition
Message-ID: <acGuQcWRuJMO0EJY@google.com>
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
 <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-1-92c596402a7a@google.com>
 <CACw3F50mVpnS7TQy_pD-KV=_Ekepjq00zZzdGxwLnF_vYT_M0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACw3F50mVpnS7TQy_pD-KV=_Ekepjq00zZzdGxwLnF_vYT_M0g@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D7625100003
X-Stat-Signature: e3iy4x38p61dakytmdrht37owo4zy9ix
X-Rspam-User: 
X-HE-Tag: 1774300743-687731
X-HE-Meta: U2FsdGVkX18t7Dw2FU5CBVcwUTI8tua3FbuD6WxuQ017nU2EsYaWKpXMpOG5QRWoIUTF9STcsnUTyaTjokoOhYGBuvl23QhQIw9N66K3NSe3WxVT9bxwCjJ8W8SbZz4EKWT8SOEpbAH38KF5kfRb44qr+kvWAs4yUws2xf1/lI+8KgdUvfmbr2k2J8ep1+yyUMAJ52oRCJj4PfwFUTHgEK7KK5774gfrR7azfFq64QhSYhjUbIxip1YD+EGfczifmRhbSddLWTdC8hxMxyggiaIWcCo2+wE9ayQLgG6YKbljpAgRQkBmcprfbmtXOHH7Qvvc9HND6bF7Rt85MYTAJR3LgVcbYarSuC/WqGj6xL8SXyIfLglpGBy5QStva5LeJUGj4Kihs5p2bkNd+j/LRZx8r05OrAENlZ7CDH5vZgA++8THn7DHlwKg6ByfP87V/CVLQq5f7r3vacvU7Pl4cCW+yY61eu/GDfEP7hBEXUd4X71W8eO2xOZM83n+R21hz8WZjfwy7iw4ZtiO5KbK4GpXyDy92eSjDremV/jJptzCqgIVfuhvbTEijLQG+LlbseL5kD3Izi/yOxP09m5A5LQ8frBZnsEYmj0O2Xw9cP0H/TMggttdZY3bYnzaj5cOpGO15srPUFWaaMd6Tj45SuSHLuutzgyf/m93c3CMqITOASARUg9x3L/+1d5U01FhO3iYYr4lKRksQMx7hLTagM2qFlLGsyRLpXBCgxr7Wkepu4XThiYIBm/i2/BJ5jxOkltZhA/6mWh/f0MNXxqC1hOX+3bc/7x0A/+tfxyCyKIkSsCKyOs/gNfaXgNE/xO5SuZrrhYBNzI3LHPrBKBhsOH3XuFiSr8Sitd6Vq5hJ6smN0JWvqUiSmdDkNJujRQ0KG2XD2VtvOapI+GfoZJ+Vjr0IhM1ixCo1rm5dbloTteuIdKVI+B4/m8w4yEMhAL5XWBa1qpuEHkwgWiVvkA
 j68VeKpt
 2GQt2CL1mzg7iPi7hJx6pp6dpI04qXUDy08RjORwlYUZgP1HWkV7k/MmTg7dEEpIa7L8FyV72xpzfxhK4v00FwAW3cucklLckLGLa/mnxWRIzyLriWggPzAnxxNouToexByNHJLj18niyukNunO+E75SK9ijou90UxZKmFcJLtnuY873tXLgsBjeOv8igJZgvn6Kx9zbPWwjGFVHC8R/VkyoMRsqdxzNrULRhWWkxrrX+CFPfmy7jCO9w0d18caIP8BhFSRABi+zxZaM9K5335T0qCPGzEgyFPswkbXAhFVZTx5vJQmaQeyey8Kj6yguiJqhHxExKECN3PpBgbuW96FCaBOJPNvebojBLNGOswzwoJaY9WRobD3HsaPj+oqIHBQCy6PZhGGP9JNG2+wRu2MWMLTJOkf0Cy1tGVGgNqbE/5n9SsUixchxwTOLacjrVJJnBoHBmtpCvoXHsR7/kLE7t3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 22, 2026 at 02:34:59PM -0700, Jiaqi Yan wrote:
> >   [...snip...]
> >   * MF_DELAYED - The m-f() handler marks the page as PG_hwpoisoned'ed.
> 
> nit: would it be worth correcting PG_hwpoisoned to PG_hwpoison'ed? as
> there is really no "PG_hwpoisoned" page flag.

I will change PG_hwpoisoned'ed to PG_hwpoison'ed in the next version.

> > - * The page is unmapped, and is removed from the LRU or file mapping.
> > - * An attempt to access the page again will trigger page fault and the
> > - * PF handler will kill the process.
> > + * It means the page was partially isolated (e.g. removed from file mapping
> 
> nit: what about "unmapped"?

Thanks to point this out.
I will change to "It means the page was unmapped and partially isolated
(e.g. ..." in the next version.

> > + * or the LRU) but full cleanup is deferred (e.g. the metadata for the
> > + * memory, as in struct page/folio, is still referenced). Any further
> > + * access to the page will result in the process being killed.
> >   *
> >   * MF_RECOVERED - The m-f() handler marks the page as PG_hwpoisoned'ed.
> >   * The page has been completely isolated, that is, unmapped, taken out of
> >
> > --
> > 2.53.0.959.g497ff81fa9-goog
> >
> 
> Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>

