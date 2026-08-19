Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAC95C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 05:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A15046B0092; Wed, 19 Aug 2026 01:26:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ECFF6B0093; Wed, 19 Aug 2026 01:26:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 902C46B0095; Wed, 19 Aug 2026 01:26:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63FBE6B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 01:26:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C217C8040A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:26:22 +0000 (UTC)
X-FDA: 85116883404.20.8A7C8CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id E4A78120003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:26:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AgITkomO;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787117181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=omsZzJXJdJHqKEiNfvEsBeiuueGXgPN6b7JikWxXi9c=;
	b=OY+XbXyBGJVEU+8FswqIeGbCvfLoa5iNpZNW4plfoaZesjGGAjNueTLeZ/RtPbys467iFy
	6Pg+mzesHRz6p5cSNbW/XfYyx4Thd4B/5RoF1w7L+nc0c/YoTXeyAC5fD/q1XWJsEBdljY
	r8q42l0AUl6GWwr3S8xHSaWZixfL8Fo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AgITkomO;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787117181;
	b=FFbIOR/D8ERgMogrbnd3e9wxWld2Ewf6VbyJluS65pzeyLel+Cr7NCKTXC3aHaMJKHClta
	MH0eUnNYWECZnrMf5J/vPe8UsTTYQnh+OWJOS0KmUbAWRKRCArHyRn7TM3LrTRY4bVq3x+
	rFb/TiORgwADLhUFGCWA5P/9iyACkpU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 61A78601FB
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8771F00A3E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787117180;
	bh=omsZzJXJdJHqKEiNfvEsBeiuueGXgPN6b7JikWxXi9c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AgITkomOSjHLaY+7MrAz6ezuYTaipgfSb9JC3VnwggwnIsSUriK6LOE8UXktg3URs
	 rJfyxKqRRgMPwg+Dii8EWmFR3jI6nEkL4btNpl806zA3pb82m4gqnHfAt7kuUBM6ZT
	 EYy302Vq6/gu8kdeWcGBIIu1+T44BkWLtazHE5CuTtUvZILKbQ4/e4T+oWEQZumgv1
	 l+lwvDL4ChsrXQOLa4HJ30lCag4eKnFkSJ/w1ot0xh8ULjCp9173HvGBwoY6GVFqZb
	 CDbdQBXRuNdPvW03FJ1ZqvY500y1p2UbieXMLSsn4+dsDUyjfwGOqNX/4UKta5ZNvB
	 +buUYAQ/0osBg==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8ef7b7651ecso12985636d6.1
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:26:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro/E5hYgzSoLnYeHCqYrKm5bm55kaHHebnRE2EMxy+ezXXEPX6nQqZ85YVgIvvyMXcBE+RmYbl84Q==@kvack.org
X-Gm-Message-State: AOJu0YwSZM805Y07/RAWHzXyKkrC3u+ar27cut8Uc43Vp3TPbK4zOIxH
	8vPuFsxNJ2vpoPWQJqTtr6AXLWYjKCtFfQMpdg8LVapUcr/epHTwxF1ZipHYrj8lKrujPAMsnMK
	Q/UbvNsurmELCN64oDhuBTPh0astEaPU=
X-Received: by 2002:a05:6214:3185:b0:8dd:2260:70df with SMTP id
 6a1803df08f44-90c5dbc2149mr27034836d6.6.1787117179479; Tue, 18 Aug 2026
 22:26:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260818115026.656406-1-kirill@shutemov.name>
In-Reply-To: <20260818115026.656406-1-kirill@shutemov.name>
From: Barry Song <baohua@kernel.org>
Date: Wed, 19 Aug 2026 13:26:07 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z_+Z_VppY3ravJxTgguK=m_pcYcbrogoOR2BdC6D-o7Q@mail.gmail.com>
X-Gm-Features: AcwNN1WtQE8mQn6krWK2xX6OBYjebxE1Ie4CmYW9cKD-y38Klw8g7mVnvq8toWY
Message-ID: <CAGsJ_4z_+Z_VppY3ravJxTgguK=m_pcYcbrogoOR2BdC6D-o7Q@mail.gmail.com>
Subject: Re: [PATCH] mm: include swap.h in swapops.h
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	ljs@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E4A78120003
X-Stat-Signature: boq6yot635sfad7sqtbzp6z6zheikkwk
X-Rspam-User: 
X-HE-Tag: 1787117180-183822
X-HE-Meta: U2FsdGVkX19lsHDl02r5zjtQVcuPMaffyhSsRT0x/k6f6SNwOwvabDwMJu/5fcn9Qho9e9TdRQXaM5IsT7Ls8lBRrDOEZRwF4g08KxSVH6JEKlQhhBNPeYuWDZ6PJMPRafg/QrCNvRx5pPfrcoAM96/DoOnZZxCh6Nu7VIVezX7982CSlC9mYy/eiVV9who7at+J/+9WI1Gdk5MIq8ir+7TGwTpJEce0jSoicbrB3KGWdtZ4uyRdcjRyLEh0epdF+Ohgo3Q880qu9aKlxMsZwd3CvK2XFAXdru2J56ekW41pgaDoNQooOe0rxulPivBREWb6J9ZTcbyndQgg5KDfk2kKHmUP6F4u+9a5AqjfvdT9wBl8Wa3dr4Kulw1UTVG5km4gfkzPDISidiTSPt8gyRyZZ3tsDY/J8jn8YDSA3qwCAtf+ZbWA4w+K7zYMEw3bhn5WIq2g3l/3TVoDGu2gduv3PqrEH+w1feYDDDnHIpXGd5OXntq96nzAEvI7rDyUZ2Rf67ebe0OXKs3Yi8+75Z3NQy4ZuKGErDm4rNp6ECEZl3hH9NX9Ni12UBTwgrbBvgQKSt6zm07jd/keYCfvwYt+uWPSGtvAhW6g9l4zrhgSkPyGp0vU+LD1bslqqtEkZGAT+OjLV7DyIezEvW9IaeZhVWdqZqT9lqjTddBYwMjHIced48AgbFYCSs4B8V3rpEpMy1l1NlMGAabUoyFLwqUJBLErnyx3T4YvSOflAPjUT6/IooVKI/XGGoowZtIF9DWBJgw+dubwDbhnm1AcQf4lZFN5i0J3mKPHgYSw53Jk73eZ0FdPVtRmb6p8/3/7je8jMhUxLPQpixzlb2atEfjfxvRi+KhJAulHf8qTTwScgDqdWDQCQBlLTuMpY7pr1jB5Ae3cNzFT/sAy5eaVSfK00iGQopUsaJbiOeHNITrRZ9mUfd8vAGugqnQwybilYZ19JvLxs3kWz+gkRFX
 F+NyKVMF
 DAX6EeBa/V8UzrCZk9nTIMw9qGCDb4TAE5be5c11Xhxo4g71zzjwgPGupIpRnfxooFvGMRhOJNnPj6Qn8z4iQcYWm93fo5KSSOaklC7Tg6Wt+o2r906AAIhM0LqtSsno+WQaf4ZeMOKNiBJJa+Mdpu09zClskVnpgyUQYPodu97Gb0rdfbny6l4L/Bl0J5nlvyE4UaD6HMoMygJtw91fttTZJhD5ns3EfVPSOXKOGjsAn8PjLq68RcZ5n0UnmvB1Rzjl3zWLBr0/ndyUb3Ry6FIWAQADfgR55mtEbONqJzRtekS+Yx3iUPLxwHVg40c7oKao/SPVfwHBvh80=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 7:50=E2=80=AFPM Kiryl Shutsemau <kirill@shutemov.na=
me> wrote:
>
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> swapops.h uses MAX_SWAPFILES_SHIFT, SWP_MIGRATION_READ and SWP_PTE_MARKER=
,
> all of which swap.h defines, but does not include swap.h.  It compiles on=
ly
> where the translation unit pulled swap.h in first.  leafops.h includes
> swapops.h on the line above swap.h, so a file whose include list reaches
> leafops.h before swap.h gets:
>
>     In file included from include/linux/leafops.h:11:
>     include/linux/swapops.h:88:21: error: use of undeclared
>     identifier 'MAX_SWAPFILES_SHIFT'
>
> A header that uses a definition has to include the header that provides i=
t.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202608181757.mza9RRj7-lkp@i=
ntel.com/
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

Basically, is this preparing for the patchset below?

https://lore.kernel.org/linux-mm/20260816224609.308019-1-kirill@shutemov.na=
me/

Reviewed-by: Barry Song <baohua@kernel.org>

