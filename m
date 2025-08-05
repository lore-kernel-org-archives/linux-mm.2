Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2825C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 17:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DC868E0017; Tue,  5 Aug 2025 13:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B4008E0001; Tue,  5 Aug 2025 13:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA6F8E0017; Tue,  5 Aug 2025 13:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2E88E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:56:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B3B0A1146E0
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:56:34 +0000 (UTC)
X-FDA: 83743458708.14.A74634D
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id C9811140005
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:56:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Tjr71N9A;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754416592; a=rsa-sha256;
	cv=none;
	b=ew9UCmlouJAvQVedDqBhbBUekP0ereMzdKw3t1TCHtlHS1LSmWPAJsU+xk2hAm1qjt7Q6P
	PzSDUw/7zt7a7AX7Yc+QAQ9fW5Iz7OxWke7yt0L+IJgw/e3v/t7dSpQSlQHqBjadmt2WAN
	wNfSmLY/zFzdbHqLaXUPOXtcIavbx5c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Tjr71N9A;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754416592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yz7TfqAprCAWQSQEMRJk+kCrZ8pKB7cwdUn+vbZdwuo=;
	b=eIxgHASJxEI8R9ws67CrWB5FQRD9PUJliAtHn4RkdraYcDyVjpDtn/8a00/UsxOlHLVdKu
	wvgJuhXFObVtP/TF8HN/BLv5IZeKnPu8V3FJ88yij7bjKe7C2vNC/m7nuG5ZmnAF7hDZqa
	/TLXTzYtafvRlbGZuc+/6S1Iz6FxM/w=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b26f7d2c1f1so5528757a12.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 10:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754416591; x=1755021391; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yz7TfqAprCAWQSQEMRJk+kCrZ8pKB7cwdUn+vbZdwuo=;
        b=Tjr71N9AcNuqiA9Tph3iQx1uyyXoVd5rhqIjapZwo6WogIAUVtC/7xpO5Zg8MrSRiy
         wQpuQI6vGUfCflKyPcZ/4/Qid0WpWfxUcxnOC/E9NaGShxUzlIKDk51NOa3yfHqtEiUG
         4xhg9HUtuIlzFIPY2GHXQTpbLJa0o2jNpnK7r4N91YawK8iOcqJ/vOmZIr06XGD6xro5
         EOc2Ng7PC0sB/TiMbMce642p6r7Bna1bifs0vJK+raDkwHVW0vQuuJE05A2D1YC1rODK
         hdRLmUcYTrlTCrVXuGufJdltD7RGL7VL6zcPMw9Te7QN81oYHD56SXrLg7eowsB0vLHP
         5Rew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754416591; x=1755021391;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yz7TfqAprCAWQSQEMRJk+kCrZ8pKB7cwdUn+vbZdwuo=;
        b=OtGugBN5dEPiOb8+9aMKeuIL3NgRwENreusEN+cJP9bn8FFTsVqZQNs4N6IL/giOOE
         TQuXGMZVUCxO+jRJMQP0xuOaDrG/fQKRZdQ7a0AT+h/hDZkf0sRZBNHtMXltB1gX14A2
         8esPJVlkteqU4gqgMy9UoZHU9N3LVqwGsCcX+BMC1XM5mmy2nHkhI88VZQIjJSLZj4qw
         TLrs6VxXLC5Vzov2K/VzD+2KUdoB3M3pNhUnp4SPx1qHoWrFCZMZGWali6tcC2KgkL8T
         USPnYtxUPSIf7SqpCi+/5edBpBfM0WERqKHticdCIuLJhO3IL+ODWvLOO0U0Gwj8hoRE
         T7ZA==
X-Forwarded-Encrypted: i=1; AJvYcCX1lKPPIoqkB7B+TMjz1jILDqFeNl8ISJM1+qEogkaxyomGS1/JEDU5pvu5svW3BX5y4XLxQaPXIQ==@kvack.org
X-Gm-Message-State: AOJu0YwCe+RHOHkVPBLvJWu90JqdCoEttmtjkksjN1OrXx2xEOUc4d/l
	8XwK4i3gL+VZdPNrbWACt9l8J5EMRHtoQk+pTJNgKUNslpa2kQjgFv6R
X-Gm-Gg: ASbGnctn+9xZtrW+geeX0ugF2yI7OknqscsgQytpGPHn59o1Xzfn0vkNDMmaCQ5ziKo
	wz3P4n2Uni83/m4uvzNp+4VP3S/c2qCVruOdLR0YopLpm2ZDjixDX1TWwxmdX+MGNhcrx04+aHa
	md7r7TFoP81yNrC6g3w9RxcbqmyZf5i8MWhd9LOgpSuFvoQDLr/h4Ma/lMMQRsqkfLgAVBx/vig
	d9NAa81dagLXnqrhCBpAQzX0CpWlMuIdr1saH5Wn62y3H7fOY1QMSQezfY0oK4vu00azyvpAz5M
	XTUjca+n+EER+v8wBRPLD1Gj5yBdGJsrODCCpHM5iaxDLcaqe2SmMHj5YsLUl1vec9gWrzy6Xif
	FAnWHZDnQPtXwVrdN8tFfH7RDespY597rBkoHDknR1dpF0HR8BBRArQ==
X-Google-Smtp-Source: AGHT+IGnn8RA3YePPYa6DBuUuglyhjaj1nYIVikzs0KaLx3wQ0H5bzkIc8kPNPXIVB/VrMverijzog==
X-Received: by 2002:a17:902:f652:b0:240:8cec:4823 with SMTP id d9443c01a7336-2424703a024mr206277885ad.41.1754416591465;
        Tue, 05 Aug 2025 10:56:31 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef6832sm138211425ad.25.2025.08.05.10.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 10:56:30 -0700 (PDT)
Date: Tue, 5 Aug 2025 10:56:28 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/7] mm: hugetlb: convert to
 alloc_fresh_hugetlb_hvo_folio()
Message-ID: <aJJFzKj45bQMjhIb@fedora>
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-2-wangkefeng.wang@huawei.com>
 <aJEXvnrvaoUPvD2l@fedora>
 <d59a21d4-8a7b-4194-9616-53c6ffe0cf8b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d59a21d4-8a7b-4194-9616-53c6ffe0cf8b@huawei.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C9811140005
X-Stat-Signature: hhpfo5s8xbd48qxp1ns9znd19su8yfxt
X-Rspam-User: 
X-HE-Tag: 1754416592-452575
X-HE-Meta: U2FsdGVkX19lx1O5yxyLlHFmwZyQI1anZK7/xs6dxhFk/S2XuLeAwcfCho3ZUxGVbdTM0qcK+U1sJmvISPlYE9TiuwLbSVl5wfPxAXPISAOzLQOZ2E1Bwc+E3TaHqYhDRuUPgplAuju46Y6SvltsZiTQHPrrN/z8zVaKtrSBc+ghLAbCAYdX43bVRzlrSdQeXmZGTye+iJGWaC6goBMGo4+oogLszbnR5AhXZ7WEi7KjA4D7oiTScDisqiNHPF4BTQuIIOkMRCnZWJ4WuuHnDZWHfzQdrBcMXEWznxjHCLGsUAB2/F/Z+avJhME20tfxHR7E6DVuzy0ITKJcmhiVCHNUB1FPFAgJsFKGbp6WUr0ixp44TvO0gdQC4Ro0TtEPSad3ZgqFUXR5LELkacjhY/8zFVLhcg3YPqcyErtzNAJc+/cDy3AIHltxflIePF5ok4V+yEm3VdPJo0JemPAhObQuR4FWIdHtoR1JeCKNJrtP01JhYL5ME52Z1wUx+Uok0lnsOaEQcFhibaGYzavBFWezwqK5nq0qIcojD4rTiz6rCNi3uuq/RbOwX114n8R4zmRLLcxrh+Xiy4zxV+rEf8fUtD+7rBlWZyZ/hIvhpuhhKIOjeS90VAjIeGToNrCFRZ5+ZU0Ro8l3iiemgd82q+nsEYCvWpN5dUIiFTCi1h18RvCIR0G7uGQqGshdg0Lq/2Onm6G/aKHfrUl6GQCDzK41CQUUWKWSEFwahCNjoYz0N60L/pMl+9mksX0R2kWMdKFsq/DuYOFsvTEVbyavgkhd+4YwgjqStRIqd7oHDW+6U0G9CcQ22Bb+PbxveOMoADP9QfS9lVLufbh0+ZLq+ySOv4fx/3cPooqRs+0qk04Q/Ormm/jqczkLJ8z5mGXjZGARTO5xt3pjs4GDfGFCVR52FF/wGzDuZ/U8/x00xx/CmiMfbZJQhfnL7Eg85i3do+MsC55V5IuiDdzmu4C
 Y3xDt1lU
 j+xDIlYN7FfYaaNYH7vLrZxcwlBrwsi+u9uolBdjCnwNv7up0anpo1umQbX/qsIqFglKiKESP2nIvhxnBCy0qrb+OF1ZxAqFmZ0bAhpj1n+UeP1N4ySyogqxg0B28LVd4I+tVsbj5IT/e7NcektJyT5pTqLQpYX5ORVFCcevoT+blGidvJ8AfZfnuMgeu7ok5YBJ0cFU0aT2Mq0GbXvsayBEjOGtv9SIp2RcJVOQYtA1bj4EOWWYcVDx88EgQCpJZwYG+G+lbpuwIsdNHqyruRAY3Y2xNQ55KXHYDodQskSVZLOeWY0AgRdE6nGVjhfGCoahYMLM3NAEVsVXR6XUtotdlpxyKzb/MRQqZ+KgyXoVnB1oWUNY6abVYjQ4I8vjqirmleKQmZULZn9DO8yEkl0EwRpChjEfVxNQrdLyUtpUd0RX1WJbxL9YIlJJnkDJE3p3eVQlisB1MnifNwfZj7Gsajxeob27jgM/igaGq+nN95TgiV2h1SnlDjVpRDIGaPzyR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 10:21:17PM +0800, Kefeng Wang wrote:
> 
> 
> On 2025/8/5 4:27, Vishal Moola (Oracle) wrote:
> > On Sat, Aug 02, 2025 at 03:31:01PM +0800, Kefeng Wang wrote:
> > > Now alloc_fresh_hugetlb_folio() is only called by
> > > alloc_migrate_hugetlb_folio(), cleanup it by converting to
> > > alloc_fresh_hugetlb_hvo_folio(), also simplify the
> > > alloc_and_dissolve_hugetlb_folio() and alloc_surplus_hugetlb_folio()
> > > too which help us to remove prep_new_hugetlb_folio() and
> > > __prep_new_hugetlb_folio().
> > 
> > Have you considered renaming alloc_fresh_hugetlb_hvo_folio() to
> > alloc_fresh_hvo_folio() instead? The word hugetlb is already a part of
> > the hvo acronym.
> 
> Maybe THP will support HVO in the future, so I think we could keep hugetlb
> word?

Hmmm, its alright either way, I just feel like hugetlb + hvo is redundant.
There's just so many words in the name now :(

