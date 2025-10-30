Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2165ECCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 21:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E7B8E01E0; Thu, 30 Oct 2025 17:13:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006578E009F; Thu, 30 Oct 2025 17:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5E4B8E01E0; Thu, 30 Oct 2025 17:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CF1248E009F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:13:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F93616027F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:13:47 +0000 (UTC)
X-FDA: 84056032494.26.7BA7BC1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 37E574000C
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:13:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iARlgBDn;
	spf=pass (imf07.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761858825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2qSMd9AkD4Z7b3gNm80YcCcg0oGBGt0b/as95bErXJ4=;
	b=L7uEofwmqjOnuuhSb1v54G5itjVxsrNL2XfMOZEDAG4QM/inoxEtMIr8CPqpYmS08MYG9h
	xw7X4JxcU4ZmyQ5IkssDhjCjrEnRmyGyQFDTzUwxyYws1ht7MObIuA/xAxX2FjfFPbyE/2
	15oxg6ESSpH7J9k6DVgrqaVI++Wm+5E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iARlgBDn;
	spf=pass (imf07.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761858825; a=rsa-sha256;
	cv=none;
	b=e+9oBdFE5yf6lpiZSGt4ZKiPhX/Pkrvx2TVPhp7naq0Cvs3EZ937qBej2odO8B8rQFoHhF
	bHTYksi9rKk4+Y+LPkNX3GTHBwP0o6I40fX9AkTFM0G830jhMKxcCnAwMJ7Kwk5KcCpnsq
	5d1vKjvv3MU7nZoFJcqIzzx5T2d36o8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761858824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2qSMd9AkD4Z7b3gNm80YcCcg0oGBGt0b/as95bErXJ4=;
	b=iARlgBDnfgv9nvyr4WstLEi1qwrkvWrKFmkabFrdxpP1SrJe6ZyPcvEps+iqj2PjOjVEYe
	F24iCcQvvAsfpKX+pZjtuTVqqJ3cSbJ7muXHkdtzzJlTgt4MyZzJSWqxdyZoCIzWMkRGCF
	jTtKe5lAPyQRf/ieY9e5qIqO38B5ij8=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437-XMBYqyc9Pl-Tfvi-G0FWuA-1; Thu, 30 Oct 2025 17:13:35 -0400
X-MC-Unique: XMBYqyc9Pl-Tfvi-G0FWuA-1
X-Mimecast-MFC-AGG-ID: XMBYqyc9Pl-Tfvi-G0FWuA_1761858815
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-87c6f88fda2so58632576d6.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:13:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761858815; x=1762463615;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2qSMd9AkD4Z7b3gNm80YcCcg0oGBGt0b/as95bErXJ4=;
        b=QyZqbbxD7lmv+hSApZa2zjCLaa/VEdNYLunsILXjWPQgQZCJpj/3n43Bq5fFjQ/Nh3
         Z7Xj36b5hg+lVp2j8oaFzoSBh78Tv2Hts3o47jTpaWMjHhY4po9YLBMtYpwrsU1/AfSk
         egBsrAxqp/CZzlFZzVe/nXjr13qZEbwrZYig1CBHPz5M460sfo8m7OwYmDgTVi6rBqen
         DrZkSK3uc5H76UGnF8wqSo0ZyGxkrdUxkSwr1OaZX2KnOakEKsRBxPzUKliYNJ4erJvQ
         GRMh3CbcOdfxMsEvdLQUmp1qQMAYVKhHFKvM8JILEzW5TLFljuNft1aUKLPlABjBsbfS
         tx2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVI4jUjMFsvShIbl2QfzUP++5Hvpo7bO5RWwLxjqHXzZMB07dpor+s3spSznbExge3C3LIOKYOAsA==@kvack.org
X-Gm-Message-State: AOJu0Yxg0T8hIIbmsPjDDAw+NKamdsz3nIINmQTWjBKcod5x/+Dkiixh
	/UTL3JiIa0UwJxkMPfwWj7QKPcSzJBy5go/O+p09gQxb+4ZvAfyEBe5BB4xvPHKVni6HmRqr942
	GB08+cUzL0KYgR1uKnc/ahouanrr2HOFMHHRO8Vr5D4hkg6fH6PkE
X-Gm-Gg: ASbGnctLaohTSCLhAlMpcavNn8RGTwkIQUZzHljmxMQpDb1N1t64dZu3RKeXwpANRQo
	qgRhW50eOfncUVp28nRDRLDJoqPuHDVTQ8xvDbAj1DV3zCM02KPdfQaFHDiAyR5DSFJ1wXudln4
	CtlO4ScMhiQwLEET6SmAMfTeERh39c7NgjVulFqR2ohAHcBbmZs38TwoNkISIQSDo4euAnwd0gM
	BZLjGRB9LUG1fhAgRJmYOkWBI/AXx/QlzOCSr8INjLVpTNaT607YlS7N6dwf/0bG1rTes5kdDJ8
	pjGKN5DYEgqVk6b/lAKD+DfPzNrr8kZfc3F9vLk3N02GBI4/OYRShqmggA6SDysjmak=
X-Received: by 2002:ad4:5f45:0:b0:772:45a0:4e28 with SMTP id 6a1803df08f44-8802cec2b96mr17784276d6.5.1761858815212;
        Thu, 30 Oct 2025 14:13:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHy39LrKID+rYZSIuDUuhKO4bD0gQsxxZgkOrydITJ3UUu9nNWFlxRyOoHC0FWqEtv02hCdfw==
X-Received: by 2002:ad4:5f45:0:b0:772:45a0:4e28 with SMTP id 6a1803df08f44-8802cec2b96mr17783756d6.5.1761858814718;
        Thu, 30 Oct 2025 14:13:34 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc49817f0sm125018546d6.47.2025.10.30.14.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 14:13:33 -0700 (PDT)
Date: Thu, 30 Oct 2025 17:13:30 -0400
From: Peter Xu <peterx@redhat.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>, conduct@kernel.org
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <aQPU-tyo_w68cnKK@x1.local>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
 <aPZDVuscFsYSlQjI@x1.local>
 <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
 <aQO3Zko6Qrk7O96u@x1.local>
 <aQPCwFZqNd_ZlZ0S@x1.local>
 <d0b037a6-11b9-483b-aa67-b2a8984e56e0@lucifer.local>
MIME-Version: 1.0
In-Reply-To: <d0b037a6-11b9-483b-aa67-b2a8984e56e0@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6tdtUd35Xkj851PStoi0MKTrdm0TvQ-rINGzjwqzKTM_1761858815
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: etn3r54xhdjc1sxx97ycyo57xw68rzrt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 37E574000C
X-HE-Tag: 1761858825-787488
X-HE-Meta: U2FsdGVkX1+x24g8tlRInB1aN8Z8ljRUqSJPMwMvcsnh/7YKWHGzmP92DVOEpA7G1/4kWwf2W6h/4cWlBjIFw8YsAdBWuerWgk7y0JhU+A6C/Zd4Whql4T+RCIRTkVjAKqXtKRTzjXs34HYGztm0zFpKEYTkjMRefeaWHME5xnJPwWPXjJFcTzRIO1/o+pwZ3o/HQVD8WExVIHCyesfQo3ASD+At22Nt3A5glQTJhHQQDPf3yZdbUFjEYEx0zbVH/yeFsGJyTnBwtapESNdBmKls4H3LcRwZ8GXe4piRXfd9BJAk5qq06EhhSNVjC4dhG3OL3AM1HhpOK9DO6ZbzOyevGZZzDHj5Hhk1fdb9SDV3ZMBe0LYcNvTbux0eYHHUIhSaXsIfD3CuKTPaGQ4onWRvcMbLiozkmEg2675xVO1YTo5rHkNajYPAhDdSsUFCqMTgQmJkmYxNC5wQ8K3nbiliUdXJ4zoV80XX8fuczPK8wCCAEAWtV2kXaOlA9LCUNLY1OIhPCWvnH8PtvEbMxXwnYVkERd69ZJj7FwsOryYbac+hk/958C+0UmxfAWkMGmDjbx1+0jM6YSMI8EbDwnpzM/orJPLCBqAFeVNWhGRstUJuM11st++CaDEzf9/diOT1AmFdXsQOYrgkFuFbs8MnwU9RZmFCT7nKICBAkDsYgeCDqA8uEQZiuabYL4YI2eNX2vv9AxcSq+RW+08u1rvZZ1wD6ImSyTu+sTEF10ZGlEAZt6rJgDtswv99tC+hUZ/1GsyCDZ9ZwPFfjfZMi8jDOTxBjrzcBksJFP1T76OterZ0rs67hchBosM7YDUQPW5Msl/autAXhZMhqgUUHK865sCqz7FItENzNyADvn5Pqhxx+q9v8LlNSgkVCHO5ZsS5oLA68a3Ku8/NbNTWPnEvVwTwBdJ3z1OiHU0n3IupgIVum2cblJAmiPhOcUYftDOVaxl4zAlrBDUKDTj
 FIW/g4kr
 DrVXHNdDnBavZ4eT1ODT3Seld6nqLND73wUaEdMNS7ocjpXl5koyskCyk/i9pa5LDrjqHmlvD77Z7uBXdi+jeT44IgN9x3+sq8BdYUo4mPSuACtPZv6qBTzTAV1bnqcTL//j60xa/xNkua5U3r1qv9u5IOJaB9Qe/xyq4G7zBnm1zIjlEFNx3U+wnmOToSuylVzgeT2Fck53kPym43URaquM1J5Fq9l7EDEdSdV1JUtBNMDJD1wUMmGML8nSM1LoBH4R3OJJmbGMFZUG5zn7p3j3uz7XBPO+qVG+SyIyEQPCXqnfWfJvlW5/vewrATMsZeNVNComW0lGO4vZwzpNuWpJn991AYmgCD9k0W7kexsdUj9txwmZ+xxV2ttTZS0Q/tyrb5CpLVajXfhDhwZQ0MrPXbwh6Np/2nT61j+CJMsMOQ42eo9Y8QvEhqmUlQoISFrsLGpaHl5qCmfd2nU8uRjJWit0ZNymysKZUEzuEROpqVZx7epCCdoWBoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 08:23:03PM +0000, Lorenzo Stoakes wrote:
> +cc CoC
> 
> Peter,
> 
> I'm sorry but your reply here is completely out of line.
> 
> I know tensions can run high sometimes, but this is a _good faith_ effort to try
> to find a way forward.
> 
> Please take a step back and show some respect for the fact that Liam has put
> VERY significant effort in preparing this after you _repeatedly_ asked him to
> show him code.
> 
> I am starting to worry that your approach here is to bat off criticism by trying
> to wear reviewers down and that's really not a good thing.
> 
> Again, this is _good faith_. Nobody is trying to unreasonably push back on these
> changes, we are just trying to find the best solution possible.
> 
> Comments like:
> 
> 'Your code allows to operate on pmd* in a module??? That's too risky and mm can
> explode!  Isn't it?'
> 
> and 'that's the wrong way to go. I explained to you multiple times.'
> 
> and 'I'm pretty sure my code introduce zero or very little bug, if there's one, I'll
> fix it, but really, likely not, because the changes are straightforward.'
> 
> vs. 'Your changes are huge.  I would not be surprised you break things here and
> there.  I hope at least you will be around fixing them when it happens, even if
> we're not sure the benefits of most of the changes.'
> 
> are just _entirely_ unhelpful and really unacceptable.
> 
> I have an extremely heavy workload at the moment anyway, but honestly
> interactions like this have seriously put me off being involved in this review
> personally.
> 
> Do we really want this to be how review in mm or the kernel is?
> 
> Is that really the culture we want to have here?

Gosh.. Seriously?

I'm ok if this needs to be audited.  I have all the previous discussions in
the cover letter as links.

-- 
Peter Xu


