Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4427C624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 00:05:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E8BE6B008A; Wed,  2 Sep 2026 20:05:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199776B008C; Wed,  2 Sep 2026 20:05:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08ABF6B0092; Wed,  2 Sep 2026 20:05:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9D5B6B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 20:05:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F4481C1F46
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:05:35 +0000 (UTC)
X-FDA: 85170507030.14.9E4B8E7
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5419516000B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:05:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OJulDvqv;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788393933;
	b=LBlnepzDFfsiXcCGE4tW9znIh1CHkVeKDqJP8UqD2Ybtg4D/khFsd4Ej5ByKVj0Csw6H09
	r6G8p2YK+UpZcblVKKgD0lEFkgkWX0YwmJNbZ3fp/9iK0O/t9X7MAFCFCKlmC5tjk0l+EZ
	Mr7md9QIUwA52FsPP1P6pae5FZve7tA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OJulDvqv;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788393933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oj1j9DR7tvSUa6TkT43vyXg4EoLBwftWK8uVdHa6AYU=;
	b=T7JFmtUkl05E7bsFyB0IC1KyQVrWrIaEGw7ov4cFyYyRrS2tR1LDWLzsgzROr67JG8Z9UX
	+bwj6hr7G22jDF6geR7sKf74dJySCp5BpJvDXtn8o9UDjk2jnadK4XKg7K7EtlJ0fioHU2
	Avah1fqbud9Gr6Otvgv7b3jASrGnheM=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-90cd4631090so5867946d6.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 17:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788393932; x=1788998732; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Oj1j9DR7tvSUa6TkT43vyXg4EoLBwftWK8uVdHa6AYU=;
        b=OJulDvqvcEO8jS4VJgHAWPgZMFteWcybsii7d/vOkRH8bKZoYnosTMJ/rAV0QcbOtP
         irzL9ZgeUZfApmXPWQQODEpisC+6BeoIEcaypHDs3HXMkFj7QOgSzxjeRFkbA1w8bQWA
         WRvL0G5uh0/lk+Dz5+aWSdzbYb/D0wmlM6QtMPpzGMss5WNFIKZjQ3KJ5dj/ejeHGkd7
         i7+RGCBFHxEatBQW8iHwXI9YOAEB+p7+fggtKEO2bX0IW9OX4mRJ4K/IOlwoC8gj58wj
         VddiHyTi5QqjXuzhgCQZ36evhDJHABL8wl7NLJvD3Pjm4dWgWGIRrzbTNa246mgnjSHF
         dDrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788393932; x=1788998732;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Oj1j9DR7tvSUa6TkT43vyXg4EoLBwftWK8uVdHa6AYU=;
        b=JCBEeVgbkvFwxk1GTgCptQyuPsVWl1snWUKCmwetDJnuATIGOOnyIW9pEAHtObsGe/
         6LQC5eY3BzLx9Hy+DdI3djNOecsVgO7yXZM8Sdkap1mzESYFQ/0pioTdPDhADNb2RTwV
         AcXXHw+JGwFXnloChgIYdkbO+lZGbV8QnY27GB6iM37KDJuO4IGohewek3hDQUHEL+iE
         twgYwKl+2gaCFMRRUrlswU5MbYokIaZHaZmaBRLkADnsDgQO6Cqj0i3pKMgqBWYLxJYZ
         Kub0beQrAmD2mh2x0rgga9EafQVhTMutYLxWHjWCMML2YeDTWgXIa/Cu5bszQz9mfrx6
         s7lA==
X-Forwarded-Encrypted: i=1; AKwUvBxki+53nCsH5d+d9CvVqG97e0Gjh/LSvUEROzs9aLta7/5y9w+LSeE+W9ImI2NV8Gm7w742hlyZgQ==@kvack.org
X-Gm-Message-State: AFuF++ngvMzwxSi7t1LzQrFN+7Mm4Ovvy2IbdwL8h27cJ8TNIUptcKKu
	8PXAwS5zXd9jPYXvJG1IGwtXlX1yKpGAXp8ky7jymxktwWUEzaZra5p8eY8RcC11Frs=
X-Gm-Gg: AYBFou12zXfybLg4W+889tlF799MLTXMZRwrWBhr+EKZ7OMrYV0oTTTAqteGZHF4icy
	usYqJhn1bNQS9Riyx6HvTX1IR0q7yQilHMuOUJDmpeSShTYyQe8i3ySHSrnjI3+YCvzVO7r7WCc
	lgUyXs9gAt5rAJA44LmRM5jcadZLXi6QuvHyCvis2aIX1aQpJh/mtTmuPc7VyTq2mtzSYdQeOw9
	k9TX9N+ZDPoD5hFPpAnlSqQ1Y5gl8OOHoz3/hV+Eb0INRROSoXSvnTj0nAQJJTVdx/EUVawpdB3
	6+ap4OgUosOdVVJTuI4HtY5RQJVkNtr/4FbLOwDJ8uN+nydloYcZf8kTKEPF/oJ1PEEvAycOphe
	SqXhtgwbmpJgpnATTUdM4oV4T55La9n/vK9S459tghwaNx1D+86dmGbNgdJISSKjBujUfKSie8r
	6/mouQt+DY3y/UTDVDdCTcuHvo7Ai3W70jAr1gC/7jFkYKb1CedyDZlU6pZvv7veIMnvMPWzZ4F
	70FyYjJrN+vdzbpLLom/xfGMmgedGQN9rfw8/X0IRIUH81GpOlsqgy94w==
X-Received: by 2002:a05:6214:3188:b0:910:2f75:2daa with SMTP id 6a1803df08f44-910346ee143mr40566336d6.9.1788393932126;
        Wed, 02 Sep 2026 17:05:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eef37a6sm30220746d6.35.2026.09.02.17.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 17:05:31 -0700 (PDT)
Date: Wed, 2 Sep 2026 20:05:29 -0400
From: Gregory Price <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v2 05/14] mm/hugetlb: use direct assignment instead of
 folio_change_private()
Message-ID: <api5pece7I6eqdti@gourry-fedora-PF4VCD3F>
References: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
 <20260831-remove-pg_private-v2-5-3668159cd9e8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831-remove-pg_private-v2-5-3668159cd9e8@nvidia.com>
X-Rspam-User: 
X-Stat-Signature: 1ji31x5hzwmzde86cgsg7netoo4wwx87
X-Rspamd-Queue-Id: 5419516000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1788393933-423508
X-HE-Meta: U2FsdGVkX18Nl79fqWooqrZ4enWmmDUXBJEfSgxlk314JCCrDufOxaodkfYoTs5V8XYap3KZE/8L05EYDaPG+upgfpQU1J0MlnuSxS1H1vpHPVPwEroqefXYnMwwFUJusT5es84Sj7zZagvTyMR0eGOqUhFvhbzqn9rA39L1Y3DXN/bVwZz0RL2VNV9f0hhCgtmwUKgawSG1oVprs+rNymC8UV04r3mjmDuri+50a5iYeHmIRwbp5ZsZxD2VbdahTfID2HtzxDMQAZtDPEL8BpQsWXTuIXoha1xqBhLVoAPYPPCT56dfMkR28ghaixhatGPchgEO4k8Dd2xKyRGMqGQUkbZyT5uxxu29uIy3P8De+3rF5k1q/AuZVoJsgfcfdOPBvga/X5gaSnnaCOnrWYy40GEh24V1XtjPdD2vCuup9EEz1cvPj7KB64az/nglLe4ZXc8/p8A8cQqEr0+LK9dEUuej/5HsQIkDAzD4FKou9Kgj94ardrsd3DHumrQM7I3pTb4wFz2XZ0PU6mUv6axAh4Nz77bqEcL3Fwp4Me2f0sYj5HywwQ4ipaAJai2F4eD7r762Bfwa3cadfX93FMkIPQFkrjclKjRZmLwg87n1j0q/dFlGq8uS8KTo3vGgc9MRjPQVJNnI/Mvjh9wJ4HLEy5LY2C2P0+I8iOSAoQwnd+iYXZcHuwg+IwfCbmNuFEmUHXHPTYIwMd8PQPhRmyzVNk1qiKA52Nj3sHylKqBHiX6C59hpVBCZxDXA/OF3KFeLPm82S13KbcLjb/JzxTetuSJcTnkfz0ErQ4jUSdkPhDXZ6TkEIoVI8qQUC7ocJQo5K7n543EkZOvKJLb/dC2JHJj5P/0x2Y/lP3SPutwONaWn+b2ompSgwCYz3RqqYJ4s73xpOrL9wnLuRd/f7821G5m3aPLLZE59PlhNKoIefewj+E0Y17fD8BtmCKR+yGmsAX/EHyplAM9kGa0
 LplVJgEe
 XDs2r+JgHBAALwgcZkYtQySeMQ4SU0SDK4VeUEkr6ks8D4fN+N8tklvBjPE7lwatN1TU6Sgfaqa1oYzMxzhm3MKhHGa8xZAd/c8xNoJ7Ct83YsAtYbrXcfzyDIZfccTottu8nxfJcggzmfecXgKtDCeyyMiQHRezMypHcc6y04XiLTxR84DdtU2PgpgOxUpZaZ96k3wdmxfRlcertWgSMcF1sw7wYu/AdOQJQBXFjrhTEftoE3X3RStlLz+PiyavD7Q9ZKafw8+WB1mP3a+vrHFX6Lv8wH6KFDlJkwVTp5tqWcf+2ICW1oe4P3jhA7HObslQGYytF57LKmk2Nkj/pEj8C26Cb0mMPnE8YfV6Xs91xxhXblt07L+YGs84xLusN7MMO5sBdV2HUZapDiSeX6e4cgR6H4KVC6/YqdtKp8EGg772/5UB7BgKUbmgvP8zD9xmI0BtfmBvr+uZs+Lf84BwTn/7Rw5xVY7jBexumhqG0UVtdcv4xTspsgjg37lcee3vM0+iCtHAsdILgHMQXoGPlLpNuLSikxHBqk3jObcdRmcfNuGCq0MQZgXIDG5tHpqoXKkLxTZu2/htc6z1hSA/mYtSfYeO1m2soCc+5oZivIBL3JBKY4gurBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 03:25:28PM -0400, Zi Yan wrote:
> folio_change_private() should be used along with folio_attach_private() and
> folio_detach_private(), where adding and remove ->private content requires
> folio refcount change. add_hugetlb_folio() simply sets folio->private to
> NULL without refcount manipulation. Change it to direct assignment to avoid
> semantic confusion.
> 
> It prepares for a future commit that remove PG_private.
> 
> No functional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> To: Muchun Song <muchun.song@linux.dev>
> To: Oscar Salvador <osalvador@suse.de>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


