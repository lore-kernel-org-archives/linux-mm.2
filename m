Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3320C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 07:45:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 970E46B00A1; Sun,  5 Jul 2026 03:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948896B00A2; Sun,  5 Jul 2026 03:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 886AB6B00A4; Sun,  5 Jul 2026 03:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3946B00A1
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 03:45:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7B56120644
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 07:45:27 +0000 (UTC)
X-FDA: 84953937894.30.49ACF0C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1FF2020002
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 07:45:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gRnFhPHb;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783237526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RX3le/qPT7zqjelY/UP38ySnAKXxuX0WuhVciQD3IWY=;
	b=cv46HQ+/pZKuKNsYay29J7L7RhdHSR3KeAdKYkQ238c86r4hPh9nP9P2Ti5IMSgjGU/OIX
	jQSbDlHbT6VX6YQ/Qwga/Jbx/lHK+Jncus9T6M4F754PhHI4bx5WHx1R0RQbRzz/CIsnaq
	LXFGoHSp/wcrXBrpGZqpUk4kd1Sc4OE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gRnFhPHb;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783237526;
	b=wSicjlo09HO80uBAqzgzulF1SJ+nEGWhRgb2u3i1gq5hNOl/Sm331erhgIyQ+Bvnkaw74a
	HuCywGlTctVOPB6mQ4XllWammZMEmX3QFnGDwYKh5IZgiHjff4N9AfwCnQHaf7NhaDYkhR
	CwszN2PBBeCYU9f3WW3w5iSyY1AhuAc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BC2540F2B;
	Sun,  5 Jul 2026 07:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB79A1F000E9;
	Sun,  5 Jul 2026 07:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783237524;
	bh=RX3le/qPT7zqjelY/UP38ySnAKXxuX0WuhVciQD3IWY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=gRnFhPHbpFC/3ywofs1mMe8NkJOCzc+3slJfghrYxsxz+YxgEIGInp3iiGlEp1eca
	 XT0aXsnw0ZrgZ1Z6y994vzNW+BgoxKw0PjUXP8gfAvSTX3cltwi1+T7VGZSTB2S7En
	 5lafFxltUOJsBNji181n5RIUffNZSvJXONR3ZDKo=
Date: Sun, 5 Jul 2026 00:45:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dev Jain <dev.jain@arm.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, ljs@kernel.org,
 david@kernel.org, liam@infradead.org, riel@surriel.com, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev, kas@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, apopple@nvidia.com,
 rcampbell@nvidia.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, ak@linux.intel.com,
 nao.horiguchi@gmail.com, mel@csn.ul.ie, j-nomura@ce.jp.nec.com,
 pfalcato@suse.de, tglx@kernel.org, dave.hansen@intel.com,
 jpoimboe@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
Subject: Re: [PATCH v3 0/6] Fix incorrect access of hugetlb pte entries
Message-Id: <20260705004523.12817419684173cb1ed1dc57@linux-foundation.org>
In-Reply-To: <20260703114202.365553-1-dev.jain@arm.com>
References: <20260703114202.365553-1-dev.jain@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1FF2020002
X-Stat-Signature: ap4r55amaj6b9gbq1in3quoa695w3fg5
X-HE-Tag: 1783237525-355896
X-HE-Meta: U2FsdGVkX1+0rVWiI/TayNvW3AaQIzQn0aD9BTS7/bu2QfB1OqJhm8YsXrig5heL0aad4bPucjvGyO0Bwia1RNIYyHRnGDVMZ2W1HwcBrcGcD708aYZVoJU515QFAo8yn7rHzQ4TPels90WLgHqByIpNMTBe7awZL3pz4ouIsEfJOEfcBu627tO83oy0fdFSz+tk0T4QdF3yG+qf8JpvzUyliQ2tPv2O6KDDsEkFt7vPSKd7n8DprhKMXB25oo4imMB3n0mS2k3PzSpMLcQHzZ6sOj75GF1/VFsCwk2uOH9PQFvPHTYyZpGrmMg84Rp7WZb4CV4WhvdhXOkMHlggDfcGiLmqEXCpwuxuf45Bi7zLhXSG6iuCtPNyn7E+/ruJV8Kd5wguDuty48nuYiqpndb9rT9tKTlqAlNvwpqOQ2EtAyB/m6otMtX8AzQsCwhL1QR/kcNzh4ped+2kjreomPh6luakBK4nSrJhJusm7RZUXaytmWnZ1WDtkjKWM322ktPrcttOuLlfzCds3jndT6D4rTkwYMyUIEgANWdertD7zOf+3K4UfBTf3EfH/HkSzevEhBvIyiC5p4HRuu54na7nWW5gR/PF0lH0JkKYt6GUWf0n3+OjC42u53TaoNyY1OuazwQVFqCYiArF9VRB9I9K+K9uYcRbbIN8iYOLo4CvBfCP0Q3au3w7VTEtBhLc99uPhvdCkiGNnYbDEedSmThDgFWfKuND3l0MssjpKxt+aXz2/tD/Vq5J0n7erGAXsonB/AD17S0ifbd9sbHx9WNWr6dtnJ/Q19qWtOntkLaJs5dIYsgE+HT0ygWHbix/sC7JWRDvwXabn41iNAY6aX1kO0xfF3cSPLL619JxRjIAnWyByxgxVJ3Bc/04BupJPbcrR/eaNtZMmF5AuPP+dvXtHklurkwsGrDCZq58UcgTwclDJRQkdEjC/DFZoKlT6V9o4cljg1gV2V79gxP
 nlviiLbG
 ABwbu2NPk9JawaquT5ot7WnQsSq9GKmlWEbGaY6pzs/nzXt6bXniSgxZvF1IgRqRVEOxpZAQumP2MJ40pYCmlxnAwE4y4IsnWScWRFzQlFzIk+Fy1mFcyCd19KzApTuXWIVxc3UCiGr+eaogAgxXDGVVYPrfvzhI9fww3qbXCJJ/weyMPVg95+VTGAkqTVrzod7E1nl5juZ6m0iP84n+YdBYWRB1pYq1cl1pfl/el4mCiCm392aGArq7MgKJTJCNYea0rkT06lXKYaukKoopljtJ+KVioE225wj4sSSlTovg+FeCSBF/1hR0oYCQX7OrsXCMbktPGOQgWoQdenxPAVb+jU3XImwXM2WFCDT3GyoqbFPrctb8aSysscC3zycxWQGCeGwFNtSX9u6HGWVXvS20Q+f9kqwEkNxJZIAyltH6Nr/oJG3Iy+WC2/gCxAMBrNsWw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  3 Jul 2026 11:41:53 +0000 Dev Jain <dev.jain@arm.com> wrote:

> There are various places which use ptep_get() to get the pte entry
> corresponding to a hugetlb folio. Some arches (like s390) have special
> handling to compute the pteval, so they provide huge_ptep_get(). Use this
> helper consistently.
> 
> Additionally, some code paths may provide huge_ptep_get with an unaligned
> address. This is a problem on arm64 (I checked other arches and it looks
> fine for them), which is fixed in patch 1. The fix is made to be
> backport-friendly: the cleaner fix would be to perhaps pass the hstate
> to huge_ptep_get() - that is wider churn and we can do that later.

Thanks, I added this series to mm-new.

That means 7.2 will be released with these bugs unfixed, which may be a
mistake.  But without knowing the userspace impact of these bugs, I
cannot make this call :(


Sashiko is worried about [6/6]:
	https://sashiko.dev/#/patchset/20260703114202.365553-1-dev.jain@arm.com

