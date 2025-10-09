Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D733CAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 03:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98C318E0061; Wed,  8 Oct 2025 23:17:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93C458E0002; Wed,  8 Oct 2025 23:17:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82BA98E0061; Wed,  8 Oct 2025 23:17:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7069A8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 23:17:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0555C13BF32
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:17:44 +0000 (UTC)
X-FDA: 83977116090.09.09784A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4F4B520002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:17:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AyPm4yay;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759979863; a=rsa-sha256;
	cv=none;
	b=AJXT5IP0Cp4x1tCj7v+7PeK/jIponar5mFWjA50mrA/Qsv5YTxddBS5KEVABLmHO+4tAMG
	YH5LCyU/HsjIVldQ2VHta7GpWtmV8j3ZkgpiIDfpTmHO/ERBF/IGJokNn7p+6tqCssLED4
	d1574VmUN3tmPvT1KnnMYWth44w8KYc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AyPm4yay;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759979863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EeYH8DtDhKNv/7S6bbr+/OqhmdAFbE3SUfdoOHi3UT4=;
	b=VBDFe2HAE6lDDQ0IGst9qKONV0pk+H3FGSApy8TejaevGh+NADQi/VK7aIoPgd2Mw61kmk
	FOc4L4C9EnVqhO2f4El37q6nYBhgj2mRDi5xLFwvqLzqx8CyXXTNlZfRYRXq9zAdCNHiyj
	tZur2To1EVO+ZVANoKmYItdNFXgmVDA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D6F4041790;
	Thu,  9 Oct 2025 03:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F6BC4CEF5;
	Thu,  9 Oct 2025 03:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759979861;
	bh=wPJ3c+Eh/QNy+wErZtTJ6qcki/ipw0RIOm8hLXCgx9Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AyPm4yayNVHdTNj2bvS0OKDp+PvHhdOn440JVw+h+XkAavnCmVibloeRaBO8okAdC
	 KEYcw2Nx0sDWNxQyvFV/DqDCm3xbgzlspwEDTi8aQngtRsH+1+5hHecjBtK+lcyphZ
	 qRgwUAnTrM/DleGHi8A6MrCv0kwhLLhmt3CrLvok=
Date: Wed, 8 Oct 2025 20:17:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, David Hildenbrand <david@redhat.com>, Zi Yan
 <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>, Danilo Krummrich
 <dakr@kernel.org>, David Airlie <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>, Mika
 =?ISO-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>, Matthew Brost
 <matthew.brost@intel.com>, Francois Dugast <francois.dugast@intel.com>
Subject: Re: [v7 00/16] mm: support device-private THP
Message-Id: <20251008201740.d9507f4807a73058d4da23a8@linux-foundation.org>
In-Reply-To: <20251001065707.920170-1-balbirs@nvidia.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: p3cbteuca7qhn73krdgggiu46fs8cqgn
X-Rspamd-Queue-Id: 4F4B520002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759979863-906181
X-HE-Meta: U2FsdGVkX1/ydKZD0/csl8wYPj7nIR9hSys9sJpniyg9tJr8jMb/UkP2vg3UWcPY3vENGclOPV/DLiz+FX9MDBvXVAk4hj0+Bw3BUWeJojP/0FTyxEB1jbx8wKLscrEWLVGheKN5pVxPIh4FxbLbXDpWFgV9Rc7sv5xtuyC9d0EhgS2VYAM8Dk01hAOJZ3HfzHXfzuSrndgDIclpaEVnQnmXGJnpffdyAbMTTk6vyWhex5Iov9Pe7MFnmzVHcZpJQ2azWkNW/oIxyBowd/+CcA6CE7SFed1NTQiyyVpi7ykEJCbsoUY238nUMqsxMjzDSU5ono8CnSkGBfcv2Xz6pwn6VLFS5SKohuw84wpBzMEfeMMVzqt0h+ZjiH8S85ZxP3CHCBdCUGO6Q6gTsJu+Wl/H+gs1zp6HMsnJNOcQlgxPALJ8OW+yP9W//2u7OiHr/wnx0cR/m3NPTgwXAw3c/Pb7B7tGaRAZIdGETGcK80RrPuspwHKeEPjscL2uF+rNL78jyGsiRZk+vm5dugewgdOhvngUwB5TaFBLri8Vl/FPcORoyXhxUzkDw98dmxeca83Wief3FiW6BF9h+4XCBY/xD1CxiESuD/nlHOeTChft9aF2RFxg8laPj8F9+LMTb5wR0nzsi3oqksS8fiPamzRo+UXtwukDjj2/Kmgp1P73/eWw9IktB12l42Wnuw5v1mHTr954qWgGdprBh5uJKEMxpYLjq3ihRkfRjir3AZudhnfdFAI8LJGMcNst8KGV41AuM02NcJpvFJFMhG+mnYwXiLkbJ2hOfYmSmLZjqIw8dsnQFI+W2ng98Kr+vm3nPQT4lbBR41RirFIm7yJSS5Uh+xPtx8B3gVZXTL5aXKRYqXrboCxuNIatYo2btucN8c9Fqa+yymwSLANqNA2//PNy5r4dIHHB7GMa+J+b8vJOeZKeUIkp386DQCnzJxbRIFcoAzJweSIQskiSN91
 9xwW86UG
 zJcsIxfcOjA0HAXCPhtDA1qMeUYG82jq+McOKPgheu9jqB5GI0PcJQRP8A1R2v+AqpXVKn7loKuhHIOoyqkyPI7dj0wyo/7wW6/cxgmd6i6ASE/L4kXE4c4DGlCmC+FPPd5SscmgZhdq44ba7v4jqS1ki5o/mMHwFXkWhn9MHtHET6VovS+Y2aBe0QFA4UPLwAhiKjP6Tb/uRrF3TtV+0ZbDa9VzGUZa0UlDAW0edueBpoyFUWxAMhyNmXxfT7vnDTGcS9Gcs+Im4z8l2Hk75ZUeq7qaLohiiAMwfuRnzwjmB8L02AMTLFrZ/fg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Oct 2025 16:56:51 +1000 Balbir Singh <balbirs@nvidia.com> wrote:

> This patch series introduces support for Transparent Huge Page
> (THP) migration in zone device-private memory. The implementation enables
> efficient migration of large folios between system memory and
> device-private memory

Lots of chatter for the v6 series, but none for v7.  I hope that's a
good sign.

> 
> HMM support for large folios, patches are already posted and in
> mm-unstable.

Not any more.  Which series was this?

