Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE7FACAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 20:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28E028E0005; Tue, 16 Sep 2025 16:05:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2655C8E0001; Tue, 16 Sep 2025 16:05:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17AD18E0005; Tue, 16 Sep 2025 16:05:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 066A58E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:05:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B229FC0319
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:05:39 +0000 (UTC)
X-FDA: 83896193598.13.8004BC5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8D87540003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:05:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hWIeYjJf;
	spf=pass (imf04.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758053137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RpCQ4fVtk0nJ15mgeceVmsFUTpPDIkoZsDCSqJpWkuY=;
	b=zQx2AL9vDRiIz/74c/C2m1owgfjeYuObJN8oz6aCotJi23azK4Kn83it9btXhcNPOJMlF8
	rKUFFin9/NZV1gKGVz3shMeb63MHYz09Qqy9WQXJ1y3xDFo6H+cFDzkl7ge+7CDK8vxy7U
	v+P+8WfndOYwM1o5d4vIWUU93zqHaU4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hWIeYjJf;
	spf=pass (imf04.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758053137; a=rsa-sha256;
	cv=none;
	b=8GbXltYDUqzwPSPGS0mro/blW7w2r44zdhC9mou8kxlNCD7cmlwA3eImwFEgfFqsFLiUBX
	lxNgiTSEfKrKpzieIkQ53W6CiIaQ1cPUkpDApk+K/VrSzqV9eoO5MZLop3I5fYrcWpiOk7
	6XbpoeQ7xhdVcFiskGYEse7wnMaj/gA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758053137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RpCQ4fVtk0nJ15mgeceVmsFUTpPDIkoZsDCSqJpWkuY=;
	b=hWIeYjJftxA2QpMfICXEaIhZEs9GgPfwGdDQIYPJ7bp8x+6BSDEj6MRoHUPnIsWrxWSYLx
	9eTRvyHWHgH+4oawWbH+87ym+xWYgQ3DIPnZMhu73+7/D+Zn833fnmv2H3CFjW9OgO0WJX
	zi2CIzJVnpv3yG+PlJsPnzq63fLZVpE=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-tX_Ff3jrPA2pcEUOY2-L3A-1; Tue, 16 Sep 2025 16:05:35 -0400
X-MC-Unique: tX_Ff3jrPA2pcEUOY2-L3A-1
X-Mimecast-MFC-AGG-ID: tX_Ff3jrPA2pcEUOY2-L3A_1758053135
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-77585c74658so107474886d6.3
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:05:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758053135; x=1758657935;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RpCQ4fVtk0nJ15mgeceVmsFUTpPDIkoZsDCSqJpWkuY=;
        b=qHalcQzgoSTRnhV5ODiSSj4B6lEe10+SvLJcufVdeYwzeJPEtb+ab8VBZ1+X175FyI
         XibS8x/OUVyX9a3ChfQhdF03L0U2OSAn7c+ZWrsu+chFyEtxSwIS8UWN+qd5qfoorwMG
         Q/V8EgZH+UhV4ZsqscC05eEz61Gu2l0mu4muvwGeE4G/G/Y5cs8UbJPEzo3zPIf8Z6kK
         j/KyWgUEVb1Y6nUL2zku9ZLPJHTXxUAoM+rOWfv2DJ61VKJ7lapJC0P3CBOS8dN/aHnB
         mYMl5qg2NhKbLbNa4Vs49FGz2JEtcR1L2HS6CTJxkY0x4Vu1Zr1WLCNW2wgVyE5PWuIK
         QsBA==
X-Forwarded-Encrypted: i=1; AJvYcCUbnCYdKfOIues2RqcMh0qbYCPu7uydIrVDfK+XE8Iq765wGaqaaOeTujo7OFxaWdVR2Ma2wkSGTA==@kvack.org
X-Gm-Message-State: AOJu0YzB5Dn8HY2WxfOqhZzhFmjfQmDsYJGBEhHQknGXFPg9aGiW0DLT
	ZlRQvehPbhljOmnmiiO0rZVY0J+E2hHF9HAMmQEeUJ5L7704+nrpHmUMy9jfCKc2mcCM2Ovqd8J
	i0jT43cjZ6dXoU8CRl/pUSSCebH0pjcFQXHze8103sM94hEDwT3Fd
X-Gm-Gg: ASbGnctVrR4WY8C0v92AJrJyjFZSP8a78Oo7PO9hwrJN92s1kXZEni2oqaFB2hvs3OD
	h18eMp4RLNmL4CW9sP1dTNV0wLvXN4e6SP55TF6/cgzpAflyda8ge3xPq55B5IqGzsATsw7W6D6
	7+bwYxW8+Jv7ewwhOGEvq/a3Mcs62nHXVS0kqcyIoI/Fu/uT+WzfZbqI81ZEDnUSeACyiK5kmOl
	1wxwgmlgU65ew8hpLetrwrsxRrKsDCWuJSQlYuNunH5Zf8TxaoEiIE9ZghYcVfAiYviT2HHuaql
	wndYjx1OHArOZqIJbSuYScSCSEzQJJ1T
X-Received: by 2002:a05:6214:202e:b0:756:a4cf:b1df with SMTP id 6a1803df08f44-767be6d5f03mr247719546d6.18.1758053135314;
        Tue, 16 Sep 2025 13:05:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfhupWWrTG8VxMqGQsU8BHddz1vAyCePst6r9UyWiXycB0vta1N1jEpGL7eOj4d2fvDA4mqw==
X-Received: by 2002:a05:6214:202e:b0:756:a4cf:b1df with SMTP id 6a1803df08f44-767be6d5f03mr247719026d6.18.1758053134748;
        Tue, 16 Sep 2025 13:05:34 -0700 (PDT)
Received: from x1.local ([174.89.135.121])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-773292c6357sm67482916d6.67.2025.09.16.13.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 13:05:34 -0700 (PDT)
Date: Tue, 16 Sep 2025 16:05:21 -0400
From: Peter Xu <peterx@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
	Muchun Song <muchun.song@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aMnDAdMyuatKth3w@x1.local>
References: <982f4f94-f0bf-45dd-9003-081b76e57027@lucifer.local>
 <cda7c46b-c474-48f4-b703-e2f988470f3b@amazon.com>
 <aGVu1Isy-R9RszxW@kernel.org>
 <aGWMsfbayEco0j4R@x1.local>
 <aGbCbW7hUf3a2do2@kernel.org>
 <289eede1-d47d-49a2-b9b6-ff8050d84893@redhat.com>
 <aGfsaIIzHWfjcNFd@x1.local>
 <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
 <930d8830-3d5d-496d-80d8-b716ea6446bb@amazon.com>
 <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
MIME-Version: 1.0
In-Reply-To: <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Fjb3RFBcvCwo2b6Up8KBC_UTnybvjXghgA9cSkJ4Jm4_1758053135
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 8D87540003
X-Stat-Signature: 59ygrhh7mxyaitf1xxjrm5i1aobqkmq6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758053137-488167
X-HE-Meta: U2FsdGVkX1/2I/bqSRCWxcJ5YYlocbu5UFBXuqZSY9Z4+lWlnMT7ZISeg7lLrPtOUTNPFeeqGBMI3zz6BWFg122WGhYUd33Y6gbn9LtOovGaz630003hBVEInFDH3LBlVtSf8jZ56F7lJ5raj/QgQW39CJerv6qX4h7ZMwtWhxpFzKiZ7frs4ZxHe5EASSurOzAk+4ODqBvGGpicWapN4gCK6k3vQT6KKmkxsS1ryows9lJH1r9bbUL8PmZhpU162dTgdZ0+8iEZvJoejXFbeH7SkuMaqhfCusdmasX6XOiZqwLmTQn3FeX/0N3GQZ6s7XJGM0Tm7ZPGi0Wr2PewdlnoQr/km0LIli6Tl96UQfZmKo1S+bdoJwJT9fmB6ecsgdkBSDw3mAEc77rmlkLVdrxhEQmFXomv9d0HYLh9Xzw/OUXGEeQWWhGPAurWeeUgWImrINZzyncoAyr/0UXFbsWnYTRLXGiNto589RvuzEXXETDk2aG9QO+yjkcCoEGRCoGO8kXQzUE57p19vK1gQZUDQ/ocf76HLFqVLwLtYJZxjruO6hMkrCCwuKB1dnLC7ZVr3mO0wjr6AxgbDJgkKB8Q5O5kHoiYfymU8TFnUlYbWq+dyVJhCc7Of/j081dD+dtiCDNurXaw56F4Oaq2dqENcnZC7IEsOCKJLsd3vJGzRiPhH+oD+YmnvcGtGGxsgr27Yvvd5VgyNVX5GejTpiPDxGZyo2nQK75i9UPP32VmUa+kavb4Q+9QdMJm8XkATfsZB6yGGYNEDOYv9dzTjkvgSfDL4FIM/C4xUrOmDajT8wIEOfhIgD7Y+pDCNaCexfhY3XCJ4ibVYCnb0UlTkzU2cud6taLBpqHTyhhcROw080XJSnfpjKzqdpMfaLJAuPuNjqGsLaeJmX58lf57AZ1NfRXEuMzAMmCkYe+WN9WraMVHr81Jr0yFimOVNydk05xOHs8CJwXU+zfhxth
 sKuzBDx3
 VrrXkL241BlfzVMWES6Ptk0yf2C7eZ0kJKYvqlalzBqpLG6OKlZoC4uL90NpD9x53mFWz6zQ2W7meLqmcnYq/BkGDlrzVOtyekxNja36PJIfymytxrx9sNr0WYA+AdLGX6lfGLzT9zfJw5x51ekwtw6V6Op/KW5+MAi7cFNFeUjJzuMv/MeekbirqVKo+nIDtCpXFXP892dChVPLGE//wEao3yLHT4J+o91wS8lYZMGmX3dZs5/KLJvXvhtt1SymFM/2j3ccxNvkS++laB0bL4KGirtsifKTTaNcYQRpB1DGfn9V7DHcIindiofTrs6HXfn2o3T2YL/1rOHWKhQM2OLNcHkSj8SobPHzIGPb12TVJycDXOU8Scyte2tZz0P1WFMcXEjQCRnng9f8kfi0EFLeVb3iocRV3soe3XQM5B+MJpP8PHM3L5bKCjmsg8kY0kAfkIuWApzx7FCo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 12:53:37PM -0400, Liam R. Howlett wrote:
> What we don't want is non-mm code specifying values for the function
> pointer and doing what they want, or a function pointer that returns a
> core mm resource (in the old example this was a vma, here it is a
> folio).
> 
> From this patch set:
> +        * Return: zero if succeeded, negative for errors.
> +        */
> +       int (*uffd_get_folio)(struct inode *inode, pgoff_t pgoff,
> +                             struct folio **folio);
> 
> This is one of the contention points in the current scenario as the
> folio would be returned.

OK I didn't see this one previously, it partly answers one of my question
in the other reply, in a way I wished not.

Could you elaborate why an API returning an folio pointer would be
dangerous?

OTOH, would you think alloc_pages() or folio_alloc() be dangerous too?

They return a folio from the mm core to drivers, hence it's not the same
direction of folio sharing, however it also means at least the driver can
manipulate the folio / memmap as much as it wants, sabotaging everything is
similarly possible.  Why we worry about that?

Are we going to unexport alloc_pages() someday?

Thanks,

-- 
Peter Xu


