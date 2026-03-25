Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC074109C059
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 19:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE106B0089; Wed, 25 Mar 2026 15:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED5996B008A; Wed, 25 Mar 2026 15:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E12BA6B008C; Wed, 25 Mar 2026 15:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D12936B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:08:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 87B1113BF7F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:08:50 +0000 (UTC)
X-FDA: 84585522420.27.B330C0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id DF4CF18000A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:08:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M6BRRpGN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774465729; a=rsa-sha256;
	cv=none;
	b=WGBjElYTCB4D9rwPSCGRPSoQD93iPPJdnoCSO77S1ZfB8UyfnP95YiHa+tZ1BDmpTIib0w
	mjHCwVe71R54b2/S7XfpwmEHr8Kjk+LLSoRCKb89hwKLMlNW1iYSwHabJ1/viy1rZH0DEk
	hERhA+6gxsu3+yXqh8B7ediTzQ+iVa8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M6BRRpGN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774465729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWWhXcyKN7A0VZ5xBqh1Tjtc3l0VwVRF+dbJJlX4wKA=;
	b=E7NYWR/bEaEXZMC0ufUmGXsjjFMGsnAllv7HhiQlEc5RCOdkpcqZ13kcM87+vMF+A9QWDc
	06luSQarLZEFXHWRKuwoLu0EFTrBq2fQZBSrUDn8QKTyU3uHkf37/3QafW0f108NKFYNRj
	TdLPTTYguLKHfUdPGrvrtR90QqX8Mgw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05AF04344C;
	Wed, 25 Mar 2026 19:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCC1C4CEF7;
	Wed, 25 Mar 2026 19:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774465727;
	bh=Qo41yGMXvFJziS9alU9r9/+sGjFxjt4T2tB+BRTnfmI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M6BRRpGNU+l+t/1WP2LzJARmGEBxhq/iSy4M7oAGkbTjXmU+7qIXz/CXlnURUJZDs
	 TGHiVbNkwtNLGM2foEPW7gFvzL+zlA2JZTkKG+Q5FGEMO1FI89Z3WEDMAStSUc+JKL
	 Ut+u74RH6/EzWcvqBk0QYi0qAmEcXOxXPqPz0LCgZHn7kC1xF4jSygmwAhJM3YncyC
	 GKdiuUAefSRfuhb9BQtP2ajY2FAC1p1bdLzeAu8Da0y3ym91sFhk0oic+nqgklU0GB
	 V/KCvC/5WKUJcxtJAaeqin4+SifD9kCzGujMle1it0FmoUZA4DRuPy80iF13OiKmpb
	 7cLwwhH1VvjzA==
Date: Wed, 25 Mar 2026 21:08:38 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jianhui Zhou <jianhuizzzzz@gmail.com>, SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, jane.chu@oracle.com,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Jonas Zhou <jonaszhou@zhaoxin.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Subject: Re: [PATCH v4] mm/userfaultfd: fix hugetlb fault mutex hash
 calculation
Message-ID: <acQytk1sO0EGBTH5@kernel.org>
References: <20260324170311.dc5b54fe0765f2e680e3cc90@linux-foundation.org>
 <20260325010618.85366-1-sj@kernel.org>
 <CAEgWzV5vp7bfr8=W6aVXNBFqxd9nVc-BGtG1jFUXJ_-+WWmPPg@mail.gmail.com>
 <af90838e-bef4-46d6-9bc1-c6185793ea62@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af90838e-bef4-46d6-9bc1-c6185793ea62@kernel.org>
X-Stat-Signature: m3spkm11xi9ff38ars57jkrzopiay5f4
X-Rspamd-Queue-Id: DF4CF18000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774465728-927416
X-HE-Meta: U2FsdGVkX19ESpogwB8sKqwxBBP0bIEC0HYL8uNMI/VidIOwGMRGn2DFqxcYrQKGR91dUnY5XgnH+2FQRxqpOekIZzQh1diZRhsqrfOTANK6rvdYII7mFTZHbRrwUBOsoqqo5zgSFWIZfdxCVjGrY9MtBVxQ3ZkD8odtLu1ZtUSgpixas8b9J2csFxFrS/6A09FD07uXL8ZxAXRdeIdw/MPUkY9ERoo0YcUbEQMuld/1i4RRyzT86AU36YKjijc9JUE3AmEFyCrTwFmHTBN5+s8CdRU5op0PmLiYXJOZqW5CELAX7B0xSii5V09eKDTBSRb9xXoSP72iKfBPRzslaUavIIfxjAbTi1N6st/iu+lyoDgXcQmO4tDtdrCDWsKbvoQAozO3bTHEI9URL/DWUcL5BdqKP8+3ATAle162fiHvY1cNA66UzdEczU8D/kMyPAvFM7h4+YPGzlMTi3kw4QKpCWM/HKx7XIl9nQPTrSSk1r8ZDZbAZfo8i7kn+pccix+CaXi6vj87cab1y9A7LZBQ86pmgEtDK5ZOZV5QP/RX3V7HlMHVn5SjaEL+A6xBI0SEMwr8aeRKPEbhbxx3euPD4G50Ba7PwQKbUtoTbTZdfUzO2SiReBEgVlz4LBI7Gh3x2RQrMguamZdXH+NcnU+TvNY3Qe3jKpQ0O1xkGd8V4cTox2xm99MBwGDDrkmrvdNv1101h5TBYFZgB7OAN2/J2rzLsDwdLuEbR57mvoeKUQImYg/8Hgvuo67JoNdI0iY1Mf6FT0E4Cu2/WjTrS3+gTwAO8FcDf5j2MxiMR2seY/E1ybBTEIy9IwX5K8ykTq7kSwsJclJpm9lVQQEugCNPZvybCElApNXuLbN5yjdsnFJ+6lPy4niWPJsmL+sm+blKlYLopZZQnXW7TI3PtFzQZt7lwCfxKLqwAA0b8hOHbPCsqd1DC3dtXIV2GvIFvB55Oop+rT/r4u68a7R
 GKTPZ3Ie
 mnq31bdtcCAydonlvB9FzsLBIOgnHRCrhzlLXNHu5TROkKNZRH/vn62gjpFETsVoTbKaxfBNPXHN29PLTSD5OodJAmv0y16FXOp5zc6KixLtYqGQrDuZkoeu/orTU8kR1EY/NPxCp5RWzE08sNE3j+JhKVLjs8Y/10A9R1AXuxKLVu8gCD6DhuVC4q5FcnBpYOM/OBEaPI5N2rRZqNkD7FKLz0IJtUl7CV2AnsEtVR0fsuvISgO+69B/hshk7Ynp1XOQhx+wyWTfSC29xrlLsPl002nkzbbi+cdQ3EvBPwbfCUt0qzVwlGqtL/Nq8vYL/QcEKmGhOgjQmoDAp9RgpLhRFmoL20+uN8aOE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 09:49:54AM +0100, David Hildenbrand (Arm) wrote:
> On 3/25/26 07:07, Jianhui Zhou wrote:
> > On Tue, Mar 25, 2026 at 01:06:00AM +0000, SeongJae Park wrote:
> >> Seems userfaulfd.c is the only caller of the new helper function.  Why don't
> >> you define the function in userfaultfd.c ?
> > I kept hugetlb_linear_page_index() in include/linux/hugetlb.h because
> > this is hugetlb-specific logic, not userfaultfd-specific logic.
> 
> Yes, and see my comment about either removing it entirely again next, or
> actually also using it in hugetlb.c.

I think it's better to move large piece of mfill_atomic_hugetlb() to
hugetlb.c and git rid of the helper then. 
And now keep it simple for easier backporting.
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

