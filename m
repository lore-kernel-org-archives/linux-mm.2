Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22DFFD711C3
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 21:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3026B0089; Thu, 18 Dec 2025 16:08:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 788CC6B008A; Thu, 18 Dec 2025 16:08:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 694896B008C; Thu, 18 Dec 2025 16:08:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 583656B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:08:32 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3375569FF
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:08:31 +0000 (UTC)
X-FDA: 84233830422.14.726147D
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id 080561C000A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:08:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Og0A/mkE";
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766092110; a=rsa-sha256;
	cv=none;
	b=Rgt0t9u4g54QeRVbwYyOL6xRuWT8f2TFWaDeD9pH7mMFbbs0vstBEWH34jFijp2tyTBStb
	6EPbF2fnq/ioi5jOA0dJnrwxN7uF/9UoyNxS/32b26i3srARucX941T6ifpyB0OR2TFcJy
	vjmirdk1kKDTEs+EE7EPkBLJydR8vUg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Og0A/mkE";
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766092110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y/FgQsLwyx8fVWqPcpiJu4icBSs+ky8Lhpq7tjq00OA=;
	b=gjsWaZcspckdNvX0wn+o1oyAfeKTnil4XpHyznxPCfDyjGgn+sGpkuWbU2rnbwIIyUWK99
	I8vOyuDKKS/ps9drgiTQSc5E4R8l6OJEUCBarnxLBEBpUl05HiXLlKzRAP2FYpscwpeiV6
	3VnUesk3iH6UqOIf0T8r8SnUJ70bFkU=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4f1b1948ffaso6979541cf.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766092109; x=1766696909; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y/FgQsLwyx8fVWqPcpiJu4icBSs+ky8Lhpq7tjq00OA=;
        b=Og0A/mkE0QVxfDzx1mrTHbwgUINcHlU8ldt2IVBQ/33WVkwFANvMOqAtw434Q/P7vV
         1xqOt68LbIsYQ+xr2OF0P/guKZOqahe6t7eRm50266uT+ivZnNuBj/83TJ3lNtvzbCmv
         bkCmhT7rYO6KTqjsH5AZGohNbSN1axZnvIM/sfPSBBu0MEMrtTG1Yi69DYWrhHu5HW3x
         hzeMsO+UNH4xwEjYi9F/DWLlylWMvxiErANW6SXvHsX8l8cgQMkj/dRt2b0eRyZpVOfA
         OSVvLysEcJbtFCWjghEaC6JGXzKWhWxXu2iD98GBO+sfMVt6HMvCHFaRerza1Y+tw39c
         uVuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766092109; x=1766696909;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y/FgQsLwyx8fVWqPcpiJu4icBSs+ky8Lhpq7tjq00OA=;
        b=WYHp7FI+d5HULtafioA8STQ2ZIPmwzv0LNs+a2X0N01q1JGt34Zx9n8gGWO3At+sNb
         JyH82I3dFbJ9EbIIGX5sHm/vx2fpRaVtWaSuSpasGAfVNgQc4y3GulGUcEInWcZQLDkV
         xMap4UQRPhurqRP2rKLDADBhxd7yUQ97ekR/tPgR7N+MtnivEAf3ILNXOt8RWy14aPKm
         LVVveaG4u7MFtULLTqPYKRBRKWDwYsRol0ry4L2tNvFgjf/NS+n4GYruRDuicrLiXCa8
         lbVcvXiPPqr4J7fX6Hox968moyEzJqVD2kWQGJ/+UWBJzX2iynHHh1oDDN8e10a7gn1C
         8ipw==
X-Gm-Message-State: AOJu0Yzn1ebJuJbAGXd23aCOAHQh+wJhGQYGcDAXViqR3YPfV1xye4L7
	mSA46SMkj+G7fUhCp3JG1TluKWcYwFc+Km585VZKaF8uUgzsqKJ5fA0AG7EywCkY6hc=
X-Gm-Gg: AY/fxX75m2vF1sZHPjDbafR4mg8ftn7rqNv07hh6YbuSEhz2qH+XzWj/gFEJNIuUCni
	UJqUNNve1Z9HbCec04XRHRGSH+ZvSexrqH2ZMsIMylgUGmygYYwQuEz/l8nY0eAPhcpVHyrxqxY
	YCBjEWK9ESboGt2vTAxoINU9oleMz9V5M/vht65FvgDfPu9r8UwcM8jIgMXA21AGU0zDhRBAqjT
	i1VYGft6xahJX1cr+sGDKpIvEJU3HvKJ1kFPndQX/9moIaKgh+kdNJiymvIax9lX/4HXtkyuQwD
	eMNjvHYzEJ9YeMIfIOhADybb/FtmuWzl5CG5u53qeJ7uYfow2iLVoGohfKKAQC0r0jmt3qrl+nO
	Q3X3c5uuTWsk6Mxuk+JVxF8G5L2IcgYa8hz9p8JQWW1hzDua9hQRmFy/6WlwtnmnW4kZT8iFdYu
	94KHvw7kN8jXwbzDt7aKZFxpQb+22AQJNTkPClRPY6gEKOBgJ7W8pNiu1Rr7/vwDC5TKGLXP+yc
	SPe7kJo
X-Google-Smtp-Source: AGHT+IEwFtMpkal5mmWunqPJmqhe65BC5BVjEz9o50PoXRxrZtyUpp77NtNVqWPnP30YdzUNpTKupA==
X-Received: by 2002:a05:622a:87:b0:4ee:2200:409e with SMTP id d75a77b69052e-4f4abca8a5amr10360181cf.4.1766092108980;
        Thu, 18 Dec 2025 13:08:28 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac54adb9sm2255711cf.10.2025.12.18.13.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 13:08:28 -0800 (PST)
Date: Thu, 18 Dec 2025 16:07:50 -0500
From: Gregory Price <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	richard.weiyang@gmail.com, osalvador@suse.de, rientjes@google.com,
	david@redhat.com, joshua.hahnjy@gmail.com, fvdl@google.com
Subject: Re: [PATCH v5] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aURtJj-krJxqLefP@gourry-fedora-PF4VCD3F>
References: <20251218190832.1319797-1-gourry@gourry.net>
 <0E77F151-99B0-4F67-814A-4D79439C9A88@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0E77F151-99B0-4F67-814A-4D79439C9A88@nvidia.com>
X-Rspamd-Queue-Id: 080561C000A
X-Rspamd-Server: rspam03
X-Stat-Signature: e33cmxfwrm4e5g4nd49zg4nohnu4uydy
X-Rspam-User: 
X-HE-Tag: 1766092109-500346
X-HE-Meta: U2FsdGVkX19tabp+/2PR7xQoGTPdXNRYEtyBZs2TJvsIkW+lNe+h1Ft1n+nOOjQzu4GpDKC6tEXWTiVrgzhAX6V/7P7EV2yVbXvbGQ0Fu0Ry8Q4WZJIG+l1PsH0OVc1fzCpO4gNsigI+DPaB11p34yhBRW/OXGXJMvyKCzoVWxDVppnDpoO+aFCbm3EooCFUCNbruBZobt214pxowvWl95WLhalloimUgzA4QARSdlKnYeHYdxRYp6LjK1/30r1yZu/aFbz9WyS2Zg+rQJNnclmM1bsC656X4FkuDOZhKNt2sXd9WECYC6LCAeLVY1IIyKOKjkJmOqF84Y4ryy0ihvrZINIwVbmQmIatuTCpFH/mRUds75ZZx6bJ7mQ0+5So2/N6kPgB3puh9WUjFnvOvjp+zJwEgGAuFkFGuIHJuLXd/W4MDW6WdI7605+ZDH0TS/FZBylM/8XvSUySoB1Y3xpQIe7B3DSGFfwC7fGUpEYtSMkMHRLhF8/5+yJCUat8vyci+tjrlEWwr30ZmFqDOEuYz5b+mB60jqp/VNMYDYUFLTtVkSdsTp2OOfofLdNPS2nPZZdi+k525Y/3lPBkU1yHNpmYftzYfua4joDnDEPrvTn7t+ICSskOGcl/WtkvtvVebFNXehWzWBNcBPdVTDV9eGcqWtFeA5P2L/yK5N1xM7kdY1SApMMD0qoLaOoGkrk6aBNS4XGfmbdXoOO4MvzwYJJ0qdt9xuVx0WWHjZKUzsKQ0NYybFmd3tSbHm//OAT/afgAmUGnm59REBX2gHg6p0mvABwL0b6OYGkYvwvjgP6HH+uYN8ZFHOuZItHjXzNCZs6CVMxczK29NjaEAnH93dHJPh0wTcZHq/JVqKyDQV+3H2asFMfAStl43gFS4JbB7s8ezyv9+7snelPJISrCV5kBpqHQcD190kKdkeFke0w3Fk/dSyZcLWVpAF2LXqVe8s7pq0llhmDPs4S
 i7u2I1pL
 hQGMWWQ6lenGunJR8q989nVJ2F4pu14jktwYjTYvGrWyBHvlIJli51fdVZG+h6KvRJDVshc5hYEN03oQRfg3Hb3nq7ajZAoN7Dt8mVW5HHroMUOyzWLVqDE7SG4GtmePXeaz21t35kFAaB++XIjCFD6oGvSYFLUpOFLtI40NxuDlezy8OKJMXs5Yb9DrKZbd/UFTzwbk9TUJXBLvQr0A/JQYM5X9FF7KVDakUuXpiBZw12hqO5usvSgFIgf2C3v4ox+QbOD6Rjo6IKoC/Zqr4Bsdwv2/x3HxAtgTUMSh1vAqM+OeHzlDbLqvVr/3q/1KNyrp/FovMtHzrf6jpBaa+ujm0F2TNyUr/5IikqkxjCc4aKdAfIdfxj3qjwzBov7ZI1TJFIqlL0SDyD7pADHD2NOsFJp5m/Kp1oqUu/BpxxJ9I7oiCZgsQK4v6R6cVuWaPy1l+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 02:45:37PM -0500, Zi Yan wrote:
> On 18 Dec 2025, at 14:08, Gregory Price wrote:
> 
> Why not do hugetlb search when non-hugetlb fails in pfn_range_valid_contig()
> and give hugetlb_search result in an input parameter? Something like
> 

Short discussion with Johannes - it's not worth trying to do any kind of
filtering, but we can at least optimize for the case where we don't
actually find any hugetlb regions (preventing a retry for no reason).

So I'll ship a v6 with a mild improvement.

~Gregory

