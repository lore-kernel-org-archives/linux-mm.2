Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05235CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AE478E000A; Fri,  5 Sep 2025 15:07:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 585118E0001; Fri,  5 Sep 2025 15:07:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C21D8E000A; Fri,  5 Sep 2025 15:07:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BBD98E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:07:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1397117DF1
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:07:26 +0000 (UTC)
X-FDA: 83856130092.02.DA95B8E
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 00A51180010
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:07:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="RhQB/Oq/";
	spf=pass (imf24.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IQ/oIN58CQG5eRvJBAHGWAbcCzoZ6DmYMUn+vT6yYSQ=;
	b=a9x+vTjFIuAGsnom341TEeehoD9udZvtg/3iiIkNJa6e2C5geq2nWw/camHPdcogyVHmxg
	C96J2BuzR59D72MToBpcp5vSG6LAHBKd+ag4GNBHLCdYXlzQoEom26q/eAWUUy996q3nGf
	V41BsPQHnzU1s1pq/4PiRNRevAVl+RU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="RhQB/Oq/";
	spf=pass (imf24.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099245; a=rsa-sha256;
	cv=none;
	b=3zK41CDyjVoi1fdobCOs2msxvGRYzfxwNvzi3WHUtFtZ8SiaE3LBMDqEU65uGyFnT1d1kG
	7vlhGSLTBhEHAt5SfmijFiSZ2meePDMGR3D+lCVB+9LSFZAef+9cbtcsOeU7MbHKd/5EoF
	1fQCYYA0c0lhfJ7b9kdOMw7droK10pQ=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-805a55c09aeso244244285a.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757099244; x=1757704044; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQ/oIN58CQG5eRvJBAHGWAbcCzoZ6DmYMUn+vT6yYSQ=;
        b=RhQB/Oq/5ZWyr9TEUXnn2H2Tt+xZJGVumF4Ac8g9vp4MfpNlMt9dnRsovhTGJBNMwJ
         tbXuf9ofSIx9x7ieTpN4289Dau36FVObua7/KyjG5/w22d7hvNPK5nD6c21Hin5Gd5d/
         pv+QRDNjFtlxyc/1hgHdna84h0kG1h8AwmHRIOq3JT4c7nYqmI2S4mD4vh8YpHJVZ4qL
         A57mGQv8xm4gVUqTGINCrPRpI/njBW1nfElfFUYnQlygwchiCQDrO/lGvXiYbmFLpvqE
         QtA6Y3gS5ETw4IE5b3xyLRJXNHNpQT+TZs0e0wJI8yKAuf7h95b9UDkcgqieZA9myuDE
         J7Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099244; x=1757704044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IQ/oIN58CQG5eRvJBAHGWAbcCzoZ6DmYMUn+vT6yYSQ=;
        b=E1IBRmXGlSL6JWmSldmL9fne8CTfeNa9RCOjsxLkTzyijZJ56kEYtAtSOC9HQuTKhB
         Gw0cy7VYyweMOW30PUJvFNS+Q8d6q3siWORzkU5pwjHS9b3J+jl1v7dcW/so0orjrXC4
         gjGZje7vitHrKg20NQsh5ttcZGrhxvDYrnph6pAyAoQrkElVmPmw7jc2NsmBvATu35Uh
         mBeGYS2f36wl0BIm467fvyBNKli9OyVp+iccKeEIHCaO3orgqxCdYkq4p7QDH6hI/nSN
         K6nOXAIfcRFEWq4JulbPfWxGbXSA0AR3sbPJ7QT50SOI/rLJaEVLW7YyT1w75bfxOjlN
         FFkQ==
X-Forwarded-Encrypted: i=1; AJvYcCViorj4IhqvLzWA4cs0JCTkCRaYDkV5ADsGmJJX1na/Ou5MRB/WKDA6H65sqLaD+nsR+7+twDOjXQ==@kvack.org
X-Gm-Message-State: AOJu0Yww+v5tjx7sz5bFTwhfI4vrX3EmTqwGnoKWwaHMwZi8NWxhGafT
	N1v2RLDL6mxR2jpkCRnhKcWSyC2EaxtnTjzr5x4op9O55tMkBTafQS3ZOdib6oAGaHcTd8+lTHY
	TckhbdteRoLXxkWa3OzfaaISl6K0OsyQ=
X-Gm-Gg: ASbGncvVR2Kzsh+7tXGPmyU69UL5TjYpEOT5LUu9lpd64XsKkxXqe10CXVeYm/rfZcA
	oA1ZxkZ5Pfr+1BB5PB4kWxPJIRHzw9SL8zJjYxuxe8s0k+qcuuqZ88KVUwcQSXSCSduT2GUUw7Z
	zmntTQtI/bZn9lrFCgpD8RzfT/LakSPKTOpXDJOml+M2rCjigEMKdwnmc0ZDteFd352g2wDSdkT
	moJaX1IFbnDq0vRQw==
X-Google-Smtp-Source: AGHT+IEFCcAvTRiAP+ne7o+on4Q3WXOguRxEwPVt18f+lK351eBuSwYXNaETh1rSpbCvL59gTg4Up9CrdMez1u3469A=
X-Received: by 2002:a05:620a:29cc:b0:806:9c53:d6b6 with SMTP id
 af79cd13be357-8069c53d711mr2035482085a.73.1757099243957; Fri, 05 Sep 2025
 12:07:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250905131352.88069-1-kernel@pankajraghav.com>
 <aLrrQDCBzaMwwmA-@casper.infradead.org> <hfljftvow5dzmkfgh3cjuqmngnmg65o4r4mpp5u34zoixwmdl5@ohnv6bbqavyu>
In-Reply-To: <hfljftvow5dzmkfgh3cjuqmngnmg65o4r4mpp5u34zoixwmdl5@ohnv6bbqavyu>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 6 Sep 2025 03:07:12 +0800
X-Gm-Features: Ac12FXzjLPwbFvmdOPGnbIFkCRXITbBdCuuS4xtejDrZ8WskOLbWE1_9u1pa88k
Message-ID: <CAGsJ_4y_=m9hNBjsT9WEn4UDJtOsjiRworATAxes+MGcjQ21zg@mail.gmail.com>
Subject: Re: [PATCH v3] huge_memory: return -EINVAL in folio split functions
 when THP is disabled
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mcgrof@kernel.org, gost.dev@samsung.com, Pankaj Raghav <p.raghav@samsung.com>, 
	Kiryl Shutsemau <kas@kernel.org>, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: k5eatb81i61fxpwmbbzpzkn5x1fjch7k
X-Rspam-User: 
X-Rspamd-Queue-Id: 00A51180010
X-Rspamd-Server: rspam01
X-HE-Tag: 1757099244-352440
X-HE-Meta: U2FsdGVkX1/oeLOLlA+MsVC5sarifOAdGUOq3ATHyYYIKPjnwR9LZdFUUURuZACstc3EUuJ2lfwKhtzHOxt5sJ1zTCSARtfJ9OIJatxFQSozjp9NKL4cR2YWfUILNmI19tfb/m7W0/oZESSdga830uvLGukhITAAmAoGh80Sr5xJQTpafzhTSfGp4eV48vxwQdLby+cEzJYaE6EP9+GMMBHj5xWB4NF/38CQb7eo8zpWSqVvHChEi2RNrYRrXAY9jh8oy30cvST1+c+Tb/8jiAFByhYID7dMQS2y+RTI8MB3PVNt4lx9yesvFfOFI9meaVMcRJJmWc7yZHAMQUMVvfRdGrdO5Ubu2tfnMf2uFfxb075I+JuRW/7amCXdTRcP6+KtMCv9Z8XqVZqWEQzveiTNElWCFRkk5WSpeQcbPZKJr8oWU+1oa1Sp2Y8SoxmOSpi+d/fsKPXjgfFnZtHjEE9Bu+Bo0i4rVoWiJ+xUMbh5ifNy1h70+UCWMe8+lKQUiR6xhSB7kL3aYFMl389nGyReA9fuHLckFKREv9nOEAyq+UVSmgAgWb+LnPUw2X8+alYHbHAmNrGYVFU4tEJPaeA/DJIFAp0/OWLKq8pdo7rgAjFt3aTmONLDrvgDhByWVVy2kve94FaT4RW6m5l7koAV9mBcKdmWANziBEr24ni+y0/BssP/HVyzwm+S0UoPusd5HCtS3dHM5dLS2b0CAVRJShCNiPjhXp3LJmYmOvyD0YbH01Vr23GnU3HPOzYD+cMPQhP2rEUTT5h9EpqQen/3bb/jJiQlzNslfsgOX6ZBhGcYOLM2zt2Ok4wjm1+lQAGAxUitIhRrHOz7KxgxdZIXXPRZ04CkBr3LZiXl50ozpy/DRRvUGZxHOIeArPO0Dp9Wm4zw7ZPHxiw+TCROZpAEL+bWMw6uCil8MvnCogZP6ecHURwIsLco113dQr+wr4btKZno61IJVRdXolA
 gBCw/Urz
 9QEZxnMUYCrq6vVwSEDEnz3wRwZrwCHBEncslMfGS6/KNqf/ksuPx9EZ8sBLsq8Jzp3/0F5nnLNbueVAx+g38UF90q9TxBBehMUYIFCQ7mcf+tYSNw3QAaGa3eFZhiS7oSlngOWCwGxmrlJLytz5zNv1Ojkf1gGaeaOyfne9SjGJTj5VVvvoqO4Tx6ZOk0IpCW2a8wJ4bAQT34Hls/C42EkoD1EiPEQPAnQDi5T8LcGZOcpmSm4gSoC67pq1G7WKO4L5FCSgqijyC6nMSkdfatLi874jyYO2F5ZBF+FWcUqnjXp/T8Lcj78BzEy1fKf4Lv7sTEYA4N8vLG0wWzrxrdGfjsNnJImiddbccrY/+C8wyoA7Vze0+15KAglUym/CQdSE5JKOL5If2svZL0Ej0gmsP9/1DeGMJPGStE2YOZJP6noEvZspCSdlc8YCb1VLtu3n4kQ9O4RptbxLce7Xlk4GHzXZg/e8Kr9IZUlXKu9f8Qf4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 5, 2025 at 10:57=E2=80=AFPM Pankaj Raghav (Samsung)
<kernel@pankajraghav.com> wrote:
>
> On Fri, Sep 05, 2025 at 02:53:04PM +0100, Matthew Wilcox wrote:
> > On Fri, Sep 05, 2025 at 03:13:52PM +0200, Pankaj Raghav (Samsung) wrote=
:
> > > Changes since v2:
> > >   - use page_folio(page) directly in VM_WARN_ON_ONCE_FOLIO
> >
> > ... why not use VM_WARN_ON_ONCE_PAGE?
> No idea how I missed that!

With this,

Reviewed-by: Barry Song <baohua@kernel.org>

Thanks
Barry

