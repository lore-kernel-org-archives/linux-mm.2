Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 654A6CCF9F6
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 05:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4D598E012D; Thu, 30 Oct 2025 01:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C25228E0112; Thu, 30 Oct 2025 01:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3B7C8E012D; Thu, 30 Oct 2025 01:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A001C8E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 01:59:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C1D412B663
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:59:49 +0000 (UTC)
X-FDA: 84053729298.18.B1A41D6
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 73D311A0007
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:59:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SslU7RYh;
	spf=pass (imf19.hostedemail.com: domain of hughd@google.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761803987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ChsXC22GEEipb+m9hP846LdbfZpqHSDexm/9GSfJLYw=;
	b=Cw+vu2WwdU8RflOASUeya5Op7j4vzNiyXH8k/m7bsvaO39CnK87yOL20nq9L0tkzw7ESeW
	zk6JLt9TLB3r0zVw7T73vjndgmAei+fKU6wU8xj2i4k/jNScsvo2gJbOGXHqhExlBUVuVG
	0+r+j4q9JpvNYkwAv2s8L99WSIa5cSc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761803987; a=rsa-sha256;
	cv=none;
	b=fRoJ94wZ0k5p2/09ava7ixe1778US32ERyjlglP/zZGN+t8yyZsHdu/PIyL7AH1WfjfQn8
	oKWM05VfP18kTAW6Z60Ly5wRQI++Fx2898BqTQTs1R9WYF4hsMkl1ATC/6SZwxFSwcOx74
	6Z1SD/6bNptlwpPfdUnnjQHs4ZBYqtw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SslU7RYh;
	spf=pass (imf19.hostedemail.com: domain of hughd@google.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-63e0dd765a0so740633d50.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761803986; x=1762408786; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ChsXC22GEEipb+m9hP846LdbfZpqHSDexm/9GSfJLYw=;
        b=SslU7RYhv8FW6KXH4Vau8cFHRxedWiUUnEVHc9zd5WXI2ytp/uTjhqUtwb1wRFD0Tp
         f+8wNnS0Hg+tiNrQIUkDubwa0eYYAC3VPTR/ZUGnWvd8bv5QWnQls0pjmfLXYZw1juIs
         V0La9JoOvb0weTjhDKZaOeuvYGdzej9D704gg3D4lW1U6UeT860f5FpwzJ0dvyqfr7Bs
         yijTjRrj5JErqWXg9fsdVhv1xA680PMGO0hznVRDVDv29ReGgKzVxsnaVSNd4vHSJE6a
         jZLmP/8mIkhBQOPQN72jLigfRp6IpuM77j2tz+zfhfs8FWf2QVOZ+lu0ZkSs1B+cgXjC
         Ue4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761803986; x=1762408786;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ChsXC22GEEipb+m9hP846LdbfZpqHSDexm/9GSfJLYw=;
        b=ZqP+3zxlw/WPhCsqvvVDDA9QjghNmUyamP6GPuOFUSsAfmxCD6rBZgeKqwhjpFwUkb
         SoTpdV/Y17D526qnvlYoRNFvaAWKbT90g/K8lkN/Wp+oTo0ILwPVEKKXXR9wp5Fii20v
         oVlx+8Rk0S1V9/BM4oCXg/9oepi/SUmbxWsUMMd43GxW3RcOzu8Uqu9rLNwgPPfMWWwO
         LhPb2iJwggZghCvBovZUkTjiRAJjYeKYF6aec6hXxQvW5YGt/TBjoFoMumckM/5DS7RO
         A85xRDLMSb3wgEdU8si0gpWjGJu6/U1Kfi26y3BYfKVsmmFFbYyyzrzRBdmt6lj/NXG2
         bE7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWmmndZAnRdOBKo75m/TZL/gUh0nsLQrXiIPcDvebxD9JcGBxRJfZqctNO3QMndIMEeOSy8i5tvBg==@kvack.org
X-Gm-Message-State: AOJu0YzW+Ebp9Pj2ACAq4ePeU9knrH2ehQmJnZqw6L0oUY5Z6ENtusfY
	p2VnLpSHMRByhJbSfxbiP7f52qamzhJ1UvbjdZqxhNRXtzM9i+f81FqQYQiXzVi+tg==
X-Gm-Gg: ASbGncsuCxWJUvw9IrsN0FKlCrZMsHZSQvqja4lzoV71RcmSpkJ+fpls+IvpQVn+SUc
	gqOA/M8Kl2PeKbdI4/9gKYBqicNIO7NKfBdeGeG7sX6aBalmDW7SmoVBTL9IXmP5KKvR8nMx4hY
	w4meWqvfXmadVIGM3p8tfQsRorRKaVC5cOwRgBFrKCyPtYj7zI29jTS2HIiwaKD3cXdm9hInccq
	ggzAg3VjR60q9SnSOsBj3Xh630OQRkSYP5GeSGZiP/4f9z+4fVGUvPpHgsZumIDlvxXmKPfyvIQ
	htWlHVtgRkrrdcGgQksO/ogHY+ZLdymrAq7QO+eyDKkFLChNVApqJhuf9ZrXdMS9CQa5CgR3M9L
	GhwvduYQ+HVIj/cQEqtCkGW9OH/YxEWoZjd7Q2R04yR/x8GS9FHKofXgctukG5rxpd4UDqe0VmT
	NYzcywt1fnrrU0tuBZsesoLs8Jt/HQ29nRjfAevJ3LwzWFNywuBdQnrE19/Qwl
X-Google-Smtp-Source: AGHT+IHtaoa/Pxq5oxH85sshVOTI9spxw9LUpe10KGGpGL4M8OEIeW0CHTrJ2BtAjboq/8BNzA5j1Q==
X-Received: by 2002:a05:690c:3512:b0:784:94d5:847b with SMTP id 00721157ae682-78638e2fa9dmr35267717b3.20.1761803986131;
        Wed, 29 Oct 2025 22:59:46 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63f4c4423d1sm4861208d50.17.2025.10.29.22.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 22:59:44 -0700 (PDT)
Date: Wed, 29 Oct 2025 22:59:24 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
cc: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@redhat.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Matthew Wilcox <willy@infradead.org>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Christian Brauner <brauner@kernel.org>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
    Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, 
    linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/2] mm/memory: Do not populate page table entries
 beyond i_size
In-Reply-To: <xtsartutnbe7uiyloqrus3b6ja7ik2xbop7sulrnbdyzxweyaj@4ow5jd2eq6z2>
Message-ID: <24aa941e-64b2-14cd-6209-536c1304cf9d@google.com>
References: <20251023093251.54146-1-kirill@shutemov.name> <20251023093251.54146-2-kirill@shutemov.name> <96102837-402d-c671-1b29-527f2b5361bf@google.com> <8fc01e1d-11b4-4f92-be43-ea21a06fcef1@redhat.com> <9646894c-01ef-90b9-0c55-4bdfe3aabffd@google.com>
 <xtsartutnbe7uiyloqrus3b6ja7ik2xbop7sulrnbdyzxweyaj@4ow5jd2eq6z2>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Stat-Signature: b8jy713bk5rgpmxozyrx6mro3cnf8pu8
X-Rspam-User: 
X-Rspamd-Queue-Id: 73D311A0007
X-HE-Tag: 1761803987-282040
X-HE-Meta: U2FsdGVkX1+Ltfy2p5EePSwzWmmCV+G6k61PoEl5y/Dh/h2EhXkrLek9C/M0/d1w6bC347z+g9tZECvlB2y7PmzirAHeA6ko55BaCDNr82ZGK0ZRb/zUKPQ3naPbcvNcoXEvqIC4ew5il5KKDdsxYXlR7NJ93NtZ/fMKMgkA0Ot+a6qOLXcN8OXxgOQzuwLLoqCcDNYanW+r3aEj/9RQDphi5vWXDRHslDtYJpCNlB2sVYQGwFTvejSJVEvy+N9YisCxlySg8WCPxAzuToiReg0MlkYlDRzTv6afKDP4Du/u0NXdvFHObfyalPRBYKuSzhzMV/DBRv7V7gSjcsYCn79swKDbaijTpK7dEoqo+LpHsxghpbwKyW4hmKgp2hRhD2H12mFWYC18tn7cJmfun6o7n0YebonW9NwShr6iiJ/JJ/qNGN57xRInbTtwojUScEdLJn94JDtCZPWsgenKiM7fRDKTscgt+lbUIEFRjiGVF43uhWT9b3z1fjPDJwaPVPpHhgoZkBSLurNdXXvGF9duwxhddStMupBHOvKzHGEIqLJz/d8tR5ZyhFs1egDkWZWwWeiij1i7/F3NhAp3rrlKCMMrh+vvZgILDEuPHG9jtjVlQTEY256WyKUR31Y8+i8Bci+JB3JQ16z4OD/a1M3GYm3Db15f2Wn7qylfmRyoaSF7gQEg7kD3NDnZRto3uBbTeRD267gFB0qlEPdU+H0iZPgOdVF4WBzReC2YJKHHxBgCT6F7Dn/EkmfvbC21ogwjwZ0sczJ03SoBXyrVUUmJlhHJLoYUZxOXllNbtM/a0Gb7FdrAlrNJ6GVbPOiYo+0unOvxVI8AuItoIDSH7P9XoNPewrg3nn3ECBCR1857bqpnK1UCFZC2fBNfCn0jx3kHD0Hz3YUY8QlBrzlma+QwNQQib3DteEsmXrIkdsRc6YcL8Up3i+yQnF6DkeQdvLwegLthJCpAHa9v8vO
 8oF5AZt0
 eHWC8QPNDb9084MZSU41LdXb5APXToqCXJyoWcYmTEM8MJ4TQipgmQXf2bRJKaNVj+QU59Agn8k3YebRJB7tNV7HhxjzENOhaJTqq1iX4PhwzqE+ePl7qxDgQERGCRecUcSY7R5N65qc47ZUse9LU/HE4dVFhYZK4LKAdsQxJGOr1z0IBTFVkJBPgX5XPd8ZX9FiHlDcHHRhgZHcru2aHfHlWETy922kxYZQS3qFZCE4ae9CutMyFw2Nv8wc+So1YMZMfBj/TdMIdHPJLJ3kaYlEgpl0YuYNAh5VXdUbSqRCtl03SzfQOD99Sitv1CFL3jtMkjgNA4A5rSTog83S62TSfD+XqP1vaMf7jvTJ5FeeynlMhrH7k1V07bumffj+NbJG3LRXgQ74t+c83IaCzeSCjsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Oct 2025, Kiryl Shutsemau wrote:
> On Wed, Oct 29, 2025 at 01:31:45AM -0700, Hugh Dickins wrote:
> > On Mon, 27 Oct 2025, David Hildenbrand wrote:
> > ...
> > > 
> > > Just so we are on the same page: this is not about which folio sizes we
> > > allocate (like what Baolin fixed) but what/how much to map.
> > > 
> > > I guess this patch here would imply the following changes
> > > 
> > > 1) A file with a size that is not PMD aligned will have the last (unaligned
> > > part) not mapped by PMDs.
> > > 
> > > 2) Once growing a file, the previously-last-part would not be mapped by PMDs.
> > 
> > Yes, the v2 patch was so, and the v3 patch fixes it.
> > 
> > khugepaged might have fixed it up later on, I suppose.
> > 
> > Hmm, does hpage_collapse_scan_file() or collapse_pte_mapped_thp()
> > want a modification, to prevent reinserting a PMD after a failed
> > non-shmem truncation folio_split?  And collapse_file() after a
> > successful non-shmem truncation folio_split?
> 
> I operated from an assumption that file collapse is still lazy as I
> wrote it back it the days and doesn't install PMDs. It *seems* to be
> true for khugepaged, but not MADV_COLLAPSE.
> 
> Hm...
> 
> > Conversely, shouldn't MADV_COLLAPSE be happy to give you a PMD
> > if the map size permits, even when spanning EOF?
> 
> Filesystem folks say allowing the folio to be mapped beyond
> round_up(i_size, PAGE_SIZE) is a correctness issue, not only POSIX
> violation.
> 
> I consider dropping 'install_pmd' from collapse_pte_mapped_thp() so the
> fault path is source of truth of whether PMD can be installed or not.

(Didn't you yourself just recently enhance that?)

> 
> Objections?

Yes, I would probably object (or perhaps want to allow until EOF);
but now it looks to me like we can agree no change is needed there.

I was mistaken in raising those khugepaged/MADV_COLLAPSE doubts,
because file_thp_enabled(vma) is checked in the !shmem !anonymous
!dax case, and file_thp_enabled(vma) still limits to
CONFIG_READ_ONLY_THP_FOR_FS=y, refusing to allow collapse if anyone
has the file open for writing (and you cannot truncate or hole-punch
without write permission); and pagecache is invalidated afterwards
if there are any THPs when reopened for writing (presumably for
page_mkwrite()-ish consistency reasons, which you interestingly
pointed to in another mail where I had worried about ENOSPC after
split failure).

But shmem is simple, does not use page_mkwrite(), and is fine to
continue with install_pmd here, just as it's fine to continue
with huge page spanning EOF as you're now allowing in v3.

But please double check my conclusion there, it's so easy to
get lost in the maze of hugepage permissions and prohibitions.

Hugh

