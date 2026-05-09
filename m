Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 668C1CD3445
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 19:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E4EA6B0005; Sat,  9 May 2026 15:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56EED6B0088; Sat,  9 May 2026 15:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436576B008A; Sat,  9 May 2026 15:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5396B0005
	for <linux-mm@kvack.org>; Sat,  9 May 2026 15:33:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3EF7160203
	for <linux-mm@kvack.org>; Sat,  9 May 2026 19:33:01 +0000 (UTC)
X-FDA: 84748879362.10.A45DFAE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6C933140002
	for <linux-mm@kvack.org>; Sat,  9 May 2026 19:32:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NL7ZAfu4;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778355179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBOtQVZ32PRIoegZx41Eusg3Z4O4/OjJ62U4z77mjp4=;
	b=VOQWTy4HgE9VGGhl5U8UUoOafd70J6q2ma+JlJVd+6XECVUdb27seEWI7nVns5/0WO9mtm
	Y/erYYY5g9WrFYyj7Tl6viuyaNUi0GW30gX3F1wxb0hK8FYMcc/US1Ztoj8nCmAqLPvve6
	5XAO6SqYIiR3dcgkuSd8X0Kg7hsNxhY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778355179; a=rsa-sha256;
	cv=none;
	b=KJg8cWW393wnuXqUfwQjB3TK6bU/LSxL4jYgABmjSvk0HFp6hAZacImny1XJVxC/DJEOo7
	tsXXE/3Gs8Dv/PA4qVVOCJe8zkk9aSB+YTOtFFks9Emc9cnQTL44bx92nyW9dZNNL9YE/T
	9s9f/mTX1d+V/+X2ero8oiKOidMXpeE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NL7ZAfu4;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778355178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dBOtQVZ32PRIoegZx41Eusg3Z4O4/OjJ62U4z77mjp4=;
	b=NL7ZAfu4Vdvgv0veORTXx3bJ19Mk8itIetPspdjnY9VdBDtrB670UNDTc0WPhEuP1s/FS3
	0lMaqL/V5VBShKrSFk990bnT0gqgTn7NIRJB/q64CwYQJ3I+KqDoropKYAff8zUiyI9k+N
	L1bWnX2fsvrXbgra/uzqM0lSbKW4JLk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-x_FPDCIBMzGWQ0PZ8lSNlg-1; Sat, 09 May 2026 15:32:55 -0400
X-MC-Unique: x_FPDCIBMzGWQ0PZ8lSNlg-1
X-Mimecast-MFC-AGG-ID: x_FPDCIBMzGWQ0PZ8lSNlg_1778355174
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48919890a95so19814455e9.2
        for <linux-mm@kvack.org>; Sat, 09 May 2026 12:32:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778355174; x=1778959974;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dBOtQVZ32PRIoegZx41Eusg3Z4O4/OjJ62U4z77mjp4=;
        b=dWGTvYF3Bh6edC2qH6DxqMSBaUd3CihH9z103msWrhJhCOVzu8wRPOdk4c/3sqR5G2
         FhTyt8TcLmP3xbWpWhADc/m2B5QgFUyiHGFGxFeRLNqZBm+l658QW1Mt3aX5TPKBajNQ
         Mup1BV17RxLZlzC6J6hRM4VkqVW2BHXLJ6RkcQRRNLjM+j7YH0421Ugit/WIS4UGfonT
         xIq4TJJ9xrKCVJ15+gN9KHvL3vAhkj7dvKA3nFFo538//ecQgEfTa+L0yxV1YklvyU4z
         0MMZkYmIbhOcwqG0RlQ4qzpnMcVSs+sDy/7WkJ2KftnjgIeSgAHQA7vMCYH5cDW9YVfQ
         +0yg==
X-Forwarded-Encrypted: i=1; AFNElJ/46dmMTuY8i9zpHjvRBUpxEkYlupCIu94TyeM3mgZFusZaUsVZx6zG1rdzRm2Gnkgc2ggQkW9GMA==@kvack.org
X-Gm-Message-State: AOJu0Ywpv0sEkgyQNgvWI7IR5FezoDrhRGBBDax757UvPQ17EYXDG8+l
	fP/P50V4l1rpiZCHiVq68Wq+qGVJAJ78kWwMhvBuJlcyPI0e+FAVTiyTseRRQQeu+DIfScY4649
	EEOyGBtlXRd47RY2LUA3/66FH5smhSgX01p7x+NSpk3vU08LBzF4b
X-Gm-Gg: Acq92OHy3pMZ4e8ysXFPUb5bZvNYIojm0fsMSJ9igSxe54Iqo4D1KI9pUorvyyBP+sp
	c8kh+8B21u/EpujB3oGfhn+zwkSrTblbJYLuWFwUfpvFs7w9L/CnEThs7But3jod5GMOQjuMrAZ
	uw8HInzGE01paXB3rpG27HFGZSCB/2GrfmZUko82+31R29DiHnki72VPt6YCvmW9XOPlqFRzzg/
	o+hEPQrAMmX9F/EYq6nahSg2gO90cZ6S5+CkyYgswwxm4d5Itwlb2kHCA8u8ClIg7pyD7/aPFyg
	P72xrC1mcl259KMEWiI4DePMgRTGqUPlOQZWdv8HDGZXUD1Au13Zo2j7lY1EhI2i3P1b9agZXxW
	97XLJaygLveDQeywxTli+zlAVGaviyLxyC0TMz0H+
X-Received: by 2002:a05:600c:a118:b0:48a:58e1:6d02 with SMTP id 5b1f17b1804b1-48e51f35b3emr227082055e9.19.1778355174126;
        Sat, 09 May 2026 12:32:54 -0700 (PDT)
X-Received: by 2002:a05:600c:a118:b0:48a:58e1:6d02 with SMTP id 5b1f17b1804b1-48e51f35b3emr227081615e9.19.1778355173600;
        Sat, 09 May 2026 12:32:53 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6db10684sm28265845e9.26.2026.05.09.12.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2026 12:32:52 -0700 (PDT)
Date: Sat, 9 May 2026 15:32:49 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 09/28] mm: vma_alloc_anon_folio_pmd: pass raw fault
 address to vma_alloc_folio
Message-ID: <20260509153059-mutt-send-email-mst@kernel.org>
References: <cover.1778192416.git.mst@redhat.com>
 <96a2f5a938bf65315ac95e75b4e7741bae018cdd.1778192416.git.mst@redhat.com>
 <db7cc3a4-0070-47b3-bcf3-540d0e9d3baa@arm.com>
 <20260508020947-mutt-send-email-mst@kernel.org>
 <be3d69b2-4e4d-42be-ab5f-61bf5940b0d9@kernel.org>
MIME-Version: 1.0
In-Reply-To: <be3d69b2-4e4d-42be-ab5f-61bf5940b0d9@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Kna2Xnc1M3bMjIgV67lCjQjh9NTUGC3FNqqQVUvBLus_1778355174
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6C933140002
X-Rspam-User: 
X-Stat-Signature: ngdorg7tjpexqzuyd8gbpgif11ie993m
X-HE-Tag: 1778355179-949990
X-HE-Meta: U2FsdGVkX18Tv1vTVJMGqzf0oyB3C5Y1uYEr5c3wrGg2Y/lnONnfEHuR+oOCUNj3xHIOwVfjj227bfeXKw/XzMON0qh18rBo0dFkXiU4goh6JKzW8u5CKJyE5ZR3Y1hjwTgn7hdF6zzw2JtqfCAqQnewnXCd5l6TxKCDM6agV+ozQlrSh001pp9Fe3SvQ7iB3whb1mIJa/3X6hTDzoTf5RaByDW1HQyfgx5gXu1qB4IS47XFTSZYOFUREXIE1LCr1n2krqO1rl+fLh/TLZqFScW+1YvfcEs3Y0sVHuVf9CE1ZqB+T28lw5TIxUqHbXDs+QtQnuS7q+bbiewvAlKUmMrkP66XiIMOK3v7HJAC4JxjfRmYmBt0zSFCNNUOcFAI0pQkP5x6hQBU71vFevzK7kwWTCgCWkiZRVLcju8Fq13lnjFHWV1u9M4MiRYGBaF7LSgM7uTq3nzXJ9STlksa5l61oPicAwPik2u28CHDbP/AJ6FGMtAJvcIC9AcDVeUnwUK+0x0r3fOgfcvYxq1354bpKqPvrpVIbPgpelFcxE8pwzNaHKyORhKPncq7oVK+Gdc9pEAfJGP+pxwENfzR3EyOTMmpr6nXh6FQv7iXSHqUe3CLIasPfljNoay8pKVl/CkSsfgMmBbQNAiOhjbZXTl7jMN+FII9ebBw3wqRxDQMEQGEGlLs3IWF5NFIXNny3uielfVyZx40FCdZj3DeUp5uaVk7PwgFQv/N4Ge5RQwwi//cRKwlVwn4buvjuTQYOZ7b3JWCgUf+z+A0HJRB8vuB9JAPGJrWUB/WXIW0XQwGa+SG6KNpJgbw9nmEYcIgdsk8FjrED0ohd9EdM+CwpxHfUb19Y9+LXBnLSRigjL2mgA5turTfI2QF3T8oCRHZA/kbf7mViO3QbxObfkcMKjOOpFvnRobFW7EcsTVo3G5DTlW+/bRTyR+cKcwILO/efyGdxHekuM3hDiNZ2n8
 7DoUtfOc
 zthQMhiqSbJ3s72gw/YJVSolv3cDN0aAeCko0s8r/XxRy9cGM1G7NpFJOmx9HLvBThMvlThOArqOOaCs5Uh7NrmNPQtLrtUyq/zykyyd8YCmMAV9n0AUX7vDtIfRaWoA/O1hR3Zt7qkQenh3hA/S2RmfJIgnAddh2e5/GGbqhnelg6vvT8rgWp+lsWIbLIQpoIRwPhy1qai99bq/ohY6ynANderdB3VXURT3XGpAx4+KpClvrn+hzqODfizaKEkWze8yrdqxpSEACxIiB1yVkvTqnfcoxgyJuq2j2qx3XAykCW5btlR6vToLQBiQOfS4YUpg8OmeDKePW+ltWEFqZB90rKJ8qlVQRgeA2qM2UqDCJBuk8kYZEAO0Tlpd8BXJMQsv0VG+Xp2F//Ic+JTjoaZkjR5QYFk1RlWHoj7e42/kV+QE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 02:10:08PM +0200, David Hildenbrand (Arm) wrote:
> On 5/8/26 08:10, Michael S. Tsirkin wrote:
> > On Fri, May 08, 2026 at 09:06:22AM +0530, Dev Jain wrote:
> >>
> >>
> >> On 08/05/26 3:52 am, Michael S. Tsirkin wrote:
> >>> Now that vma_alloc_folio aligns the address internally, drop the
> >>> redundant HPAGE_PMD_MASK alignment at the callsite.
> >>>
> >>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >>> ---
> >>
> >> Hello Michael,
> >>
> >> Could you please send the whole patchset or at least the cover letter
> >> too, to everyone CCed on at least one patch? I only got two patches
> >> from the patchset in my inbox so I have no context :)
> > 
> > Will do, for now I bounced the cover letter to you.
> 
> I received all patches, but no cover letter.
> 
> I can only suggest to look into using b4 for patch management.

I have some homegrown scripts that I've used for years,
once in a while I decide to make some improvements.
this was one of these times :)


> I'm planning on looking into this, FYI: [1]
> 
> [1] https://lore.kernel.org/r/05cf9584-e06c-4ecb-a5d7-2a558fd756ce@kernel.org
> 
> -- 
> Cheers,
> 
> David


