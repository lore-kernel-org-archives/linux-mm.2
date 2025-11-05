Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB753CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 20:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52A888E0010; Wed,  5 Nov 2025 15:01:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501D88E0002; Wed,  5 Nov 2025 15:01:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C9018E0010; Wed,  5 Nov 2025 15:01:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 251CD8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:01:08 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B87F516046D
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 20:01:07 +0000 (UTC)
X-FDA: 84077622174.27.74A7751
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id EBC734001D
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 20:01:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vF3hfBad;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762372866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldDyq3tsFgYvyoHI8nWeYS5HdbVk0rd4V1r4ezrVHxs=;
	b=7MWpUfO8uTibkNMup2m0JjdheYTBUolnBh5FvaDK7CLCjTZN+PO/i4kBhh3sJJr4kpws+j
	IFwZ6MjoVTuFZwR2jQGL0lFBeazrfrstT1EHxhR+zCjJCeYHVVwQxzuJS7aHiKKjTOYPCk
	6B+99d6mDH/wQTF58pjWuNdc5qQYjHQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vF3hfBad;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762372866; a=rsa-sha256;
	cv=none;
	b=25L1aS+AIwzPEKrGnonXWe5A/CVE4udhElEzC1a3KmGvRg9EAo6fsuMYkosDwTl6oDy1c6
	JJVMZMy5m//Sos/joyl+x8NRA7Ubtw+pVYZkREZ12YRkdx8MrFu/enQm6/zF8N+Fo6y84V
	C6lFheYfu1sJl1Kha7SPVEP5HBeLTSc=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-880499b2bc7so2690026d6.3
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 12:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762372865; x=1762977665; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ldDyq3tsFgYvyoHI8nWeYS5HdbVk0rd4V1r4ezrVHxs=;
        b=vF3hfBadMsMKhfGaHNGK+6r2/+tFe6W1wdpexmkKKFZgelfqr/I9t4Ej0MifAnLe4t
         /uIfdHG8FMMQzNulbbNzOfVI98k9OnVjfkx2d9kPZ7JvJJaovca8uDEJqNet2F8m+uMH
         o6pWIqpie0hOHnGQ3RtqlhkvGj/7PY0MA0zh9pGDW8N5aylJp6SiozrBD8fy3EwsNGU9
         MG0DBbADeN6h79N/0ayUQhg2WzeWpTrfI2/e56P7x2NbUBMxZjJ/fUSXRMbgi9ubeEca
         zObbSK6FGO57QQwwytTCCVY5u3LZ/akD8zB+Ay0xx5PEz0dD8dIHFiISujUIrgmF49Ul
         hLcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762372865; x=1762977665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ldDyq3tsFgYvyoHI8nWeYS5HdbVk0rd4V1r4ezrVHxs=;
        b=g4Lp1mp2FsITJG4DmB9teP6WCMtKx4xFSGbUsLN7lUUA0RB2yM928Un+5X2M3L8ZPm
         dl+gcCIA0Yj0h/wFdWM2cXGOrdqkcj/rS/oGQYtjhbIT7aIie7dquHLIuuGTZkMdHUy7
         JZ3w7IoAetnpCSyGvOTdAOY8L77OC14AQmbk9KCREmR+Pq0pAAVZi9fhCsgSoBSUkY0I
         soB37k3PH0N+TfiCvCk8C9yWaT7IMgWh9PoeI6x4FfvsapVGdPi0JW46/LdwOMY1xNJm
         H7ubz2h+GCzSYztw8ZGNTM+i9Tk9WhEkz3R8jgPWWccPHEYvA/Tr2gm3QL76lQt0kCYr
         C7jQ==
X-Forwarded-Encrypted: i=1; AJvYcCXopPbUMI5YzIJ+0QKrSpGvLZjIP39Ywba3AR8DbT88GM0aUL8489ylOAh9hEYH0TUVmT7ArWQKLQ==@kvack.org
X-Gm-Message-State: AOJu0YzEX6/12ZX+qSNhzyi21kc5t1yMczI6Yg/Ya8l5c/KIgt5dBMON
	y5LFRwFS27VEUP+ubbEjmIKNTwxr9zUFn8PxKdEEP/aUn4klK43/cCNO8jx+CN8E8tc=
X-Gm-Gg: ASbGnctwxhP7Fsa4eS6bZzYUzCcVl3xPEA7YVjjyHJ+/goLE6xNLNsIVb88gRfWTtfA
	eOSnOSAnR/y2yO2WVIOWOL3ROkAeVBy+4i8g4TVHe0cDbswbTGOm4ov8+yspATtlkkZWB2HyL0M
	r93m2n8DHHxJEWOJlAJd/YJW9JaLZM1NDDRTm//Ymi1O2UXZ4M//KWTO+5YKEYF5ZDYrZdqVRWg
	18HCqAnEC6dl46qMgGqA9xvQqWjTKnoOcddI1MVSItR1rfPAq0OWxN62VwDA52oBTipK80m2Hvu
	45hvv70xFR1vYch0Gh2cU4Pw6LYvoJoaQhYwCMG95X58E5+pOIS8CTS57a7lbwmdre6wHFPybiX
	3+5REFMuY7XNAAIVNJYJ5n+W/oTbgttwbV2W+uGAtHrbRTYNqdyHHHiriGBKM6TWcS7Qea+NyR6
	xzhx2pxR9srxlnOxC/jGLmAgjJb6W2NsAcaCMe/gA8MVwPfDngcO/mESg1wIk=
X-Google-Smtp-Source: AGHT+IFrPbLMeE9CYwB+D7eMKoLl9vB1NdinT/slFi02CGhPHxsO1o1rCTabfaRmYf3n9WMkLz+GWg==
X-Received: by 2002:a05:6214:20ad:b0:880:4896:5d81 with SMTP id 6a1803df08f44-88071135a41mr51873106d6.3.1762372864533;
        Wed, 05 Nov 2025 12:01:04 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-880828c4570sm4100556d6.10.2025.11.05.12.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 12:01:03 -0800 (PST)
Date: Wed, 5 Nov 2025 15:01:00 -0500
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	SeongJae Park <sj@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH 02/16] mm: introduce leaf entry type and use to simplify
 leaf entry logic
Message-ID: <aQus_MNi2gFyY_pL@gourry-fedora-PF4VCD3F>
References: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
 <2c75a316f1b91a502fad718de9b1bb151aafe717.1762171281.git.lorenzo.stoakes@oracle.com>
 <aQugI-F_Jig41FR9@casper.infradead.org>
 <aQukruJP6CyG7UNx@gourry-fedora-PF4VCD3F>
 <373a0e43-c9bf-4b5b-8d39-4f71684ef883@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <373a0e43-c9bf-4b5b-8d39-4f71684ef883@lucifer.local>
X-Rspamd-Queue-Id: EBC734001D
X-Stat-Signature: z7f844fjiu3smhrsdm8pn311khymhtyt
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762372865-586404
X-HE-Meta: U2FsdGVkX1/iq6KWP9y6Yn9GaAg+zoUIHpAnhYQUzZBPPS0YGqUnZSyRvtNj/cjtjXuS7KTG4n3269xoOpSeZKYF7hEYY2HlCy+YH9uBah1PKamMVBFuUob+6ni74l5Hp+ttkDFuQR7nd5IJEdy7cu6CwuIPwSblI8PNT/pBB1vtF9Jv8A55hD2j6jyWB2Hw0914TrmNsL+qbJpntfVEqNOvj9cf8XRXS1ewNuRrBIc2CctpLJnU2afrYGdHA7tqIWbkJCtPH0/zrkA8lnwS0f4DcWZh2bq4ThyyCiYfPqfGPM5PH8eDX6PcQbmVJbsmEy8Ph4Boy8RcKbJ+G64GfTHBxByP1MC4mXhsHpCDl3nStA5aGvpK92PQRMVtEeJ9iXNZSPPTHB1ieBf/rZI4gBmD4wTh28hILPuwXj4hT8WXQ83+CvR81vL0SAuui776kTYD4/andSinfC9POXCrrWYA92LrLJxysXklQC/cSgUfyAXHk2ufn7CVcqcWypUDv5wD4M+p3giAXmP1loT8SL6JT29QlHhOcGqsZY5UEkVb3FYNuvRS+Y4wI4C+rz7lNPEob3tvUsQOnLUbjyU/5OwR86XomaLPUvfwQTNJbTVmDf3o84Lf3uxUhW8Q+tJWZGWyICBi5BsA74kpwG5yY86vPwNruD/IjOI24EqgxF+KjaYtbr7T4Ewpkr4BuKPKFIRzFVSb8pDULZgrNBe/neOnBJ2lWSbDPKqfzFJeMukYWJe9/udojXhfXgwFX2Gp1yrD2mzpmSCDUJOLU1nlFEVpN9Ib9Mn6kFNAXGAmpBGxYvdLkRJSgmN96G2XEj1ZAAKNM2SNTpb2+4/LcVFmI48Z/ST2jKz2Cx29QH+1HzA/3PpxaamlZW5Cb01UBagad6eFR5bTIWbfO7rnA61Kogk2joN97OC0iYIevXCe80ift/3o67rQWIVlYv/bkNjTt/Mumt6amYKG6YWLe7R
 jZ//b/Wk
 RqZTB6POsK95ah8CXbaFCESxAhWSOH57j1KpruP3Y5zbNnNjXZ9DWhGW4eIO6dJ59vylAi7KCUb82wZ6LiEWcsaRQApJtCTxchlVe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 07:52:36PM +0000, Lorenzo Stoakes wrote:
> On Wed, Nov 05, 2025 at 02:25:34PM -0500, Gregory Price wrote:
> > On Wed, Nov 05, 2025 at 07:06:11PM +0000, Matthew Wilcox wrote:
> I thought about doing this but it doesn't really work as the type is
> _abstracted_ from the architecture-specific value, _and_ we use what is
> currently the swp_type field to identify what this is.
> 
> So we would lose the architecture-specific information that any 'hardware leaf'
> entry would require and not be able to reliably identify it without losing bits.
> 
> Trying to preserve the value _and_ correctly identify it as a present entry
> would be difficult.
> 
> And I _really_ didn't want to go on a deep dive through all the architectures to
> see if we could encode it differently to allow for this.
> 
> Rather I think it's better to differentiate between s/w + h/w leaf entries.
>

Reasonable - names are hard, but just about anything will be better than swp_entry.

SWE / sw_entry seems perfectly reasonable.

~Gregory

