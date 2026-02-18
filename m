Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55AC9E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 21:46:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0AF86B0088; Wed, 18 Feb 2026 16:46:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AEB96B0089; Wed, 18 Feb 2026 16:46:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BAE36B008A; Wed, 18 Feb 2026 16:46:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 76D046B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 16:46:22 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2862CB8085
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:46:22 +0000 (UTC)
X-FDA: 84458911404.22.B3A997E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id D0BFEA000F
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:46:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cI1I/25U";
	spf=pass (imf15.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771451179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L7/VoI5q20qGTQoXj49vRdypgNZ/BrCMYvuD6UKnpJI=;
	b=FKixqMbaxn7IXt/ujzUi3JpSgeQhNbmJ5BQ8kF/AX7S72jNrNyoCuJgjoN2hceHVkUq5t9
	MZuPausAk6kliN3Hjx7FixhL+Yc609jSUNMqLKu87N6qS43jKwSgbCBhv+zwPB+e+189/D
	ZgW5pUItq7L0b3IAMlHKIooJLy9tW4I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cI1I/25U";
	spf=pass (imf15.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771451179; a=rsa-sha256;
	cv=none;
	b=5BjHwAnJCiKqjsuU5V/Cyy6crYJ7WOWhXHtodbubSQ11cfeqIxw4wYY7emxXzkrU16R6XI
	ROAHGuFV3L89Urma+8OCalpblKcmT6TDtmsBjC0e/bYRxDwVkXU7eqZqvBJEOBquHDJPIO
	Cwhg8r/rtUuFWv8afSvRsvPNtLrcApU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771451178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L7/VoI5q20qGTQoXj49vRdypgNZ/BrCMYvuD6UKnpJI=;
	b=cI1I/25U4ihis2C/hMR6fY2VLctxQpFVRUuOaAdzZW95obn6BPG3rTGtfvUl3wMM9OvfZa
	anC9OpQ4YU0sVpEEcciULiY7jItzqttMeAk6dtrG1mcwGBFRjkcCZZ5Sy+R3ROC/4LeKJF
	o9jCKOduAT1lHwNTA62V5j0zR32Yi/Q=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-hFF2Tb2aOay3fVdpkWQ-UA-1; Wed, 18 Feb 2026 16:46:17 -0500
X-MC-Unique: hFF2Tb2aOay3fVdpkWQ-UA-1
X-Mimecast-MFC-AGG-ID: hFF2Tb2aOay3fVdpkWQ-UA_1771451176
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-506a07740bdso35179061cf.2
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:46:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771451176; x=1772055976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L7/VoI5q20qGTQoXj49vRdypgNZ/BrCMYvuD6UKnpJI=;
        b=hoIps158qzHltCbOmDlt0kf6BZHRzz/59uJQApebKjBvL3LrTE8hZFqA0GMVpl2LiG
         hBdkfM7W1et+I3bb94GTJMNw8Op00gVyG8+2HlhzXfwkodFNlHvwHkm0hguCqiG6LzM4
         vV8JWlPSznRRWYYUdf0gyIEDOiK95wtMIe0YP05HBB+c3vClqL3WtdiA90RCd5+OXenN
         a4xPLZEVVWN+vNj3zOtBH8Fv0RO+i9HROwLcn9Srbpc+pQYBJrNgmYao0/YUeiw6sZMB
         8wBqzGuy4M5fer9t9KWGvXkevqD0IJtcS8XT7njZfQZRbzUA4ESVE8RLfnaFNlLoMDyt
         BGxw==
X-Gm-Message-State: AOJu0Ywh0pnpR3ichWv3OG1/um01x17dzSpN64fZWGfWGI1Babn1gEj7
	zvCuW1eSOTc4np6P7OnyS/EqfmdO0cuSCjHEH4z0gfp/8wBAOuypa2ryFuOqOFA1pwcceb7EvMU
	im064RDCPXXjlngtBRVwPSzNYV055j7PliBaqrMGf9ajMfaQcqa/5
X-Gm-Gg: AZuq6aKnftl24YyJbcMsqwnWrlcvpGaYUR/7fbJzcN1rykG6LoyhwEWO84y6U6Zw44B
	NbHRxAq1YIhKFqkoRETdTg5nnwFQBxMznMGnyE4oqoQ8Os95UKFR96rGpY/YQ6lZlpWGoqrC3Av
	eziAUJ1NiHrL/Y/bI6zGGGmBsA8TdUDrbptVSQKJXiFGZlzFLI+ffkkA7ppAwpuTVpE437PzT+N
	Kx8zZkXtrv5XrhH44lZcd1i4yduft9UBrBPWCXVWJie3JnFQNpoYIeGcGo0M4xFU8dQAgb3dSDX
	1SJI+omnHamTRz/77QAk5cDdqsM42aeaId9Aa9uXonVDrmwuke/fjIOhggeHgTs5JUcqHNHK32Q
	zL1BFUBJTk6hgvQ==
X-Received: by 2002:a05:622a:190b:b0:4e8:b446:c01b with SMTP id d75a77b69052e-506b4020625mr201996691cf.61.1771451176380;
        Wed, 18 Feb 2026 13:46:16 -0800 (PST)
X-Received: by 2002:a05:622a:190b:b0:4e8:b446:c01b with SMTP id d75a77b69052e-506b4020625mr201996241cf.61.1771451175893;
        Wed, 18 Feb 2026 13:46:15 -0800 (PST)
Received: from x1.local ([174.91.117.149])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cdbf972sm195151676d6.44.2026.02.18.13.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 13:46:15 -0800 (PST)
Date: Wed, 18 Feb 2026 16:45:50 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 10/17] shmem, userfaultfd: implement shmem uffd
 operations using vm_uffd_ops
Message-ID: <aZYzDhi7mvgucP9V@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-11-rppt@kernel.org>
 <aYIzCuh8cjd09zrP@x1.local>
 <aYhm_4difwN5XXxe@kernel.org>
 <aYzf-hS4pUY9ulss@x1.local>
 <aZIGIH9--qOamaMe@kernel.org>
MIME-Version: 1.0
In-Reply-To: <aZIGIH9--qOamaMe@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EY6uEPD-3UY9rjkwSmSnoW-FYJqzPjLlNQngGB-vq74_1771451176
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: nio1j4iz1agoa3pj56cwcz6dgq8kwb6q
X-Rspam-User: 
X-Rspamd-Queue-Id: D0BFEA000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1771451178-305121
X-HE-Meta: U2FsdGVkX1+kgrk+iRekFxd51lgrCDkF8lG/YSdxIvcik+mde6wHthunn+VSgg3IQTOrrU0BaZhDZL5Ci0f60hTMkriZ0BeVYCzQtYO10T8GIxdkjyKDRngtYEb/oyf7ac8KG8VVrGmr2QRTBKtMARGvTq2VSGQM7zXlqbO+r8DviL3iulRE2bg+HwPcEXO7mDx1CBco/S11mo+fZkJzeCkC0kmnEhZhySTUoo1Y0S+6ov3hEaK0VsMvUzSWiFJ8zBl2hP5wlOdl2roH/xtRZ/Ln8CKJ3CKiwTH8hXkxMOnlth49gyVZuhoZqaTXMggcSYv4uv5xxkTYMGXNkiwqOOsX9/V0ediwVuyZJ2x56qFXjW7Qv7Po1O9M2rpG2gx0vvRK9aP0uOXuwTwmdek4G9/d/PWST1qWTj+gb8LXwhsnbgU/7to6ZXDO8J0e6uUU2AGnQDbn8TD46HK8+YHXa6yYuB0FV/f9az3KRRD+b8SdApw4LIHzRCD8yWqzukboYJba9/aV5E7FtAYultLf0uLtZRHKfBzjhqZWq0Dca1aottJJkPPNHmkp2NrsHhcfZGq36RUNxCNIvEBXNUG1XM9h5x3DTK4Mbt/xAUkFozAUdOtOn8Lk6IdPYGeTH1DBWEAZIhxyIajZUwZtl6Xm8L89iXJxkRI67YeRwabtS8rekO/c18z2eGMYjLsO+fJMTtwjcGqiekkIYy/YsivVGGXwQwKf+QoJwEO0JDt1HC4y5z1pdFtANJyE+lTsn5OXJV3PECH/CUNs0ivo8rVgrOTiRODn9wr3hMBiWje5whJc8J7Q15r0hGSwNaAFTQjeH7K2SwMv+Kr3LfXi/mcQtN7l+7rgKUaHENxRPg5uvA37H0zXCXgJYt4JX2a4yT5gDNESXKnitcwlbvt1KvaPFQYwghPCKRddpT6ZzYXkU6Q8YtmOsf1qJIqtdji29rwitcshUiW0tPtFodi6Phv
 ld0bKUzL
 jDanO/1nKTKTJJe/aV2meHU4sOzq1+VHZORN6DNimho8U82lCBQYKxscns9NiLadnTdCE+ga5KUUbKcVkq+DWtnf2brlkR/OgWKrx3yddHUrtgDuk2mNooqjzvbKM6E4A7tZ8wj0g1416CbqtM4BBF86yBGEj7Sp3spA2hU5OK0mCfmdO1ooh6pFPPcmlVfsj+/v70DZinld99524kiENzDAqkIqGLP6QvWSC4tZsDQucQesgL33adNlI+BEYHy4FEz36OILRRiRn6PolfV0hGGVGQDfDS2CSS7IvYCOn/r7X4LEx4PHCmm4nejK6/9wBfz1F7I2a2fiSs/RmRZ6gLLraNw36VB2sO6v8U0gQ8vteC7FCx7tbYT7Br0ZLJYvubEiD6DigbVvaH+J2MI5BQ8fZRFy9QN6lnp0iuZZfP2VRtCnPNQh8u2sjtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 15, 2026 at 07:45:04PM +0200, Mike Rapoport wrote:
> On Wed, Feb 11, 2026 at 03:00:58PM -0500, Peter Xu wrote:
> > On Sun, Feb 08, 2026 at 12:35:43PM +0200, Mike Rapoport wrote:
> > > > > +static void shmem_mfill_filemap_remove(struct folio *folio,
> > > > > +				       struct vm_area_struct *vma)
> > > > > +{
> > > > > +	struct inode *inode = file_inode(vma->vm_file);
> > > > > +
> > > > > +	filemap_remove_folio(folio);
> > > > > +	shmem_recalc_inode(inode, 0, 0);
> > > > >  	folio_unlock(folio);
> > > > > -	folio_put(folio);
> > > > > -out_unacct_blocks:
> > > > > -	shmem_inode_unacct_blocks(inode, 1);
> > > > 
> > > > This looks wrong, or maybe I miss somewhere we did the unacct_blocks()?
> > > 
> > > This is handled by shmem_recalc_inode(inode, 0, 0).
> > 
> > IIUC shmem_recalc_inode() only does the fixup of shmem_inode_info over
> > possiblly changing inode->i_mapping->nrpages.  It's not for reverting the
> > accounting in the failure paths here.
> > 
> > OTOH, we still need to maintain accounting for the rest things with
> > correctly invoke shmem_inode_unacct_blocks().  One thing we can try is
> > testing this series against either shmem quota support (since 2023, IIUC
> > it's relevant to "quota" mount option), or max_blocks accountings (IIUC,
> > "size" mount option), etc.  Any of those should reflect a difference if my
> > understanding is correct.
> > 
> > So IIUC we still need the unacct_blocks(), please kindly help double check.
> 
> I followed shmem_get_folio_gfp() error handling, and unless I missed
> something we should have the same sequence with uffd.
> 
> In shmem_mfill_filemap_add() we increment both i_mapping->nrpages and
> info->alloced in shmem_add_to_page_cache() and 
> shmem_recalc_inode(inode, 1, 0) respectively.
> 
> Then in shmem_filemap_remove() the call to filemap_remove_folio()
> decrements i_mapping->nrpages and shmem_recalc_inode(inode, 0, 0) will see
> freed=1 and will call shmem_inode_unacct_blocks().

You're correct.  I guess I was misleaded by the comments above
shmem_recalc_inode() when reading this part assuming it's only for the
cases where nrpages changed behind the hood.. :)

I believe we need shmem_recalc_inode(inode, 0, 0) to make sure
info->alloced is properly decremented, so shmem_inode_unacct_blocks()
explicit calls will miss that otherwise due to the reordering of shmem
accounting in this patch.

It's slightly tricky on using these functions, I wonder if we want to
mention them in the commit log, but I'm OK either way.

Thanks for double checking!

-- 
Peter Xu


