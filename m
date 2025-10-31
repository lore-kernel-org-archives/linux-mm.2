Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D92ECCF9F0
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 02:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B007D8E0087; Thu, 30 Oct 2025 22:20:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8588E006B; Thu, 30 Oct 2025 22:20:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C70E8E0087; Thu, 30 Oct 2025 22:20:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8A68B8E006B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 22:20:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 094478816A
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:20:00 +0000 (UTC)
X-FDA: 84056804160.24.8A76C2E
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2C2DB1C0004
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:19:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hj7YBBvV;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761877198;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAuHBkzBsMSaj0Gbuvv+XkhIsngSwsrTuvil52QriUA=;
	b=gr8pF0IcQPz13mW1jFNLTwca5I9J/edFwQk3GarNlwVA7lORa98NSWQsluIAf8ybDWZd1Q
	/o2c/1oD3oA8n1mvqeGFj6eTlyHoT4wIvre5hOtSuv0fBnx0gw5kD3G8Ek1B9/Z2+l8PqO
	K26OjAGtdT3ZiAuxQXaZccB45ItsNqc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hj7YBBvV;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761877198; a=rsa-sha256;
	cv=none;
	b=K7UVaMo18I/XMrWSsT9cj4ESbshNrHBVSAgEnkyx/nHN8WkoElbvNCnSywDAbRq0pcYDqM
	xYn36tzK/u+qsgHuUYPGYQOTepIkhETrLS3zxQcvbmAgETOxA+E0t9NHa+QrlLyxgzpVbZ
	YuXm5VWEgOy/s74ioJvbEOT7ZwNqows=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6399328ff1fso3089158a12.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 19:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761877196; x=1762481996; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nAuHBkzBsMSaj0Gbuvv+XkhIsngSwsrTuvil52QriUA=;
        b=Hj7YBBvVJI5a+SlNRA6Eydk1fsW2qBrDJ+fHRfbha86XD0RJ87uxL1HfGryELxnJDE
         FLNO2ZPmPkzQF1rBPKAqbEv/3hxqvvQrO/8LJBRFtwESCkNYLhJuQHZPFiBZ2TI6BJYy
         eqzjMKOPsq15eQkynJGkeUDS8ezjABQf1dD4xVgoqjM8cdj20bwifeK5o8a1BflhZx/s
         /xCy0rCURHmZ6CPxLCjQJjzIOMrx9krIrl14cJH9hjctlyQQFmHQlQX4dM4J8wU3uR6M
         eNFrfpSimPLyNfjcPxQmWblDU++wXKZDUjJup3plwgo5YdsBIYJdfGdldA+xRjHpJuHR
         2dGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761877196; x=1762481996;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nAuHBkzBsMSaj0Gbuvv+XkhIsngSwsrTuvil52QriUA=;
        b=M/FJfOQ5xKlijg6vwN8EKYEmrAsGgudXJQotVNYiPxbKJHCyqyOHELIF/rOfCPMMx4
         +1hYYA/uaNlWz+hTm11aoigmy2+1AoGKTXA5DhS3C7nBhuOfF78vE7ZWqpeFokLfYooo
         AnjsxmibsVbPT6FWq1zFjz2TCXUTDg/q2wPJNBFZLGkBUXptZ6IfmToqnh35xg2gZhci
         +9OumfC10ixmN00/QoCANbMWU3IAWvcJoZ6F6+FD9n0W3A7sr71dCsgZhjFJ2KqEciyJ
         XiiSMP6NKhnypmzAkFJbIYbGA5Y4J5qDnXZxV8L54P2Oj5CHwJ9Fy1QPHkFVNyCoYYLL
         UIsA==
X-Forwarded-Encrypted: i=1; AJvYcCVYJUXW+mGNoQne55FWNQn5E1r0z2SWpPrvGfWvZtUHbidse7v4Kgpc+HIcHafd3yghK86DD4F5QQ==@kvack.org
X-Gm-Message-State: AOJu0YytWeeCjZ8WGSymtvoygiFWmEhuPBgltBN+fd1vR6krV+JX8X8i
	nUdqKEmKc5f2FYvhCgSYALDlUOLVEKUOnQ9HwszZPHRMavwWFGdKi7Rv
X-Gm-Gg: ASbGncvAE4qHS0CN7tetXVhsnoPJv0FwwXLOUH9B1S7rHfeUQkrHsVvj2e53KjhYE9n
	oiM4YNwcgdenDp/G4Gx0mDxPXZIy8wENWFO6FALNq/2OCqQ9FI1lKdXHRy6P08FDYuEXBR9HEgf
	s/8wEPN1wFiVpHTyXbDqhNBUWlHzFzRTTchTnpx900x1YNuMXRsMY6UbTaTSPT0rCiKlIOGdTL/
	8dyO23tE75fIfN8NzycUhhQ72ySMXgFsQoSp2/9gGAw+UEKPmSp6sPZuhrOVCuQhex/5HGRcNLl
	4T6uIZlc8vFvXMlli/jSaPKDEA94TpXXsp2LnXQh4LREFqbseg63XxD70nXSvkieYIzrlVEwD7X
	6TLSO4JjS/cZx/OcldkiTvND8PVuek3C/3d3TRp+ZScRZNiM94ug4AI6SXLPh0O5wUdJD8VXJtq
	0oCgpcdMzGWQ==
X-Google-Smtp-Source: AGHT+IEcH4kOFzp6/56rakvTEjeBVzfv6qBiWaY3eKFtuXFG29gDskvq3YaNRtp/ukRJ/0KfRNrsvg==
X-Received: by 2002:a05:6402:1445:b0:63c:4f1e:6d7a with SMTP id 4fb4d7f45d1cf-640770127d6mr1311349a12.19.1761877196183;
        Thu, 30 Oct 2025 19:19:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6407b427a23sm488415a12.21.2025.10.30.19.19.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Oct 2025 19:19:55 -0700 (PDT)
Date: Fri, 31 Oct 2025 02:19:54 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
	kernel@pankajraghav.com, akpm@linux-foundation.org,
	mcgrof@kernel.org, nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yang Shi <shy828301@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v4] mm/huge_memory: preserve PG_has_hwpoisoned if a folio
 is split to >0 order
Message-ID: <20251031021954.ba2pymy2hjvgzohf@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251023030521.473097-1-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023030521.473097-1-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2C2DB1C0004
X-Stat-Signature: pfyaqpgbspq3ca8h58iyafc5g88m69c3
X-Rspam-User: 
X-HE-Tag: 1761877197-994961
X-HE-Meta: U2FsdGVkX18eBbXKToQ7EwchUzbrOOb+D2UTad7avT6X7+Sl8IxnEVm6EFdlt/jb0pVWv8kH8RbGrk4MMMulaRTUsd86d1uau/4F/VCCmh8T7lYwGPSaZayJhGftmuRIELhtl89Ih5j84R8YnezSIMM9F+IfwRiCbljGZgD+RheuRyh8qaeux0kvHzr1kBeW6xs5z7OJSPbDWc+fQXIg9cxUhfAseVMOIZ/XdaumhIM2xikafsKxXbU2gvsmjk/8ptSyvsjdUSqNBHvIV5eba12+oUAH2e2vJhSyZkueBdEiri7L9pzMyYOawCil20iNhh7BqYlU6+5SeH9O4WJeanShDKIDn5stV4XY6PeHqRvz1+yeWpjb0X2KoWqvG4zDBgsKLz7vFsXpQIKqb1xBx1y+7trOROEC18/XGsistSzkW5OE/zLleXlThpZBZqSGYzykFJfFB+0aLFefnQoFsZTFIU3I+PoUxOl9TSN32avc9p5A3UbcngvRN/5HbVD9/tSqYSlgPIsIn0qQkSZR5bw1KfxgjDLD0r9afXxRvDWiTTSo8VjSBtq2jRNASVo4TGu6Vq7eRS4dFWGnI/2I1+iRwykPPsVVefRaQkOFoAF3F931y5dvAcL3AHcFxqpyVHdvh7S26Q7hYwgzzpkl57pRSbZapOEWsr/XV7CN0gZLtsOc64w2SJqE8RA+qAlr1rzBLLy9I0xldTrNUMpjm2z6mna4bjHjgOeYBsEd4UBtc7q4Dh3ccIsy+V6kN+AAkc5XALIV0JRbLERJ6BMaTx1grnRzi6F4KNtm+xRgo4jhDwEXV0QFdLEjwF0KNECEJWmyBLH+R+TqkLT6/RcLHmoIse2ITxXnVU9TvN0pbtoIUbXLqvvEBdjd2qSkuHVhJrys0gTKBVGXb3g3HqtB9m4z3RtIB6sHRBWXc32KXUtZP+QdY/sokrBhgiC3dT9H+YehUuBPdeeYDZVmsSU
 RmGJdIFq
 /9fB0V/n5DYcCwdWoRlcPH5bCPKFIbM4ctgZMOlmG9fUQ8cciShwzTczuCzZFPQT1Tgd0gkfTzcD97FNhtkkmBZMDwYqOPrZmWJDQ3WRYQuTLicCHdMt0CvnW9innM70J0K0heb1VAwyujlmGMxKlyMC8f96NDjGBQhmvtVsvirvkJZNxIrcJpkq2kV31x3MLiIfKNyvCI+N4Kq40lC4Wp5WklZKDqFtM3jozjRBC0Avg4DQ6PQlRJFduThsrSF3ipRhn4O88tTwgPMGvRAzsWzEQJkZswTdmxTO1kEm5CPtuaK00t0hfMuiQkH8WE64vnBkt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 11:05:21PM -0400, Zi Yan wrote:
>folio split clears PG_has_hwpoisoned, but the flag should be preserved in
>after-split folios containing pages with PG_hwpoisoned flag if the folio is
>split to >0 order folios. Scan all pages in a to-be-split folio to
>determine which after-split folios need the flag.
>
>An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned to
>avoid the scan and set it on all after-split folios, but resulting false
>positive has undesirable negative impact. To remove false positive, caller
>of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page() needs to
>do the scan. That might be causing a hassle for current and future callers
>and more costly than doing the scan in the split code. More details are
>discussed in [1].
>
>This issue can be exposed via:
>1. splitting a has_hwpoisoned folio to >0 order from debugfs interface;
>2. truncating part of a has_hwpoisoned folio in
>   truncate_inode_partial_folio().
>
>And later accesses to a hwpoisoned page could be possible due to the
>missing has_hwpoisoned folio flag. This will lead to MCE errors.
>
>Link: https://lore.kernel.org/all/CAHbLzkoOZm0PXxE9qwtF4gKR=cpRXrSrJ9V9Pm2DJexs985q4g@mail.gmail.com/ [1]
>Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
>Cc: stable@vger.kernel.org
>Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

