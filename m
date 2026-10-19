Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8824ECCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 05:13:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 807786B0124; Mon, 19 Oct 2026 01:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B89A6B0125; Mon, 19 Oct 2026 01:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CE216B0126; Mon, 19 Oct 2026 01:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44F7B6B0124
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:13:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB4FC1C3C55
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:13:23 +0000 (UTC)
X-FDA: 85338207486.13.5753390
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0B1C6180003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:13:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sgeAvZuB;
	spf=pass (imf24.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792386802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XvhtXuV9XKl0XQhWMK4sJXSo5YXTOO2+0hwy2EwXoWE=;
	b=dOwOEIk/FQR2hSCh983tUhOi7+z7tnR3+8X40Qx8xKc6deFvXbChdoYWeM1r0mKmONHuvu
	IADF4FOrVwwF5yV3xgeiaayH5TC48FX2RY0SzGuqGl/SB2zolIAkPstbv/V8FLglM+j77c
	h7EUW7dbUCNxBdfl/BIkvSzDCWg+MTU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sgeAvZuB;
	spf=pass (imf24.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792386802;
	b=dWurwxuOOlxINORJHv0EGf2+ys0Uu1BV9a3voT77gVigq24CKOnqZTEqFF8cmkR7ldDPJ8
	zS6ZdPU+gHv2GrUlIZ1xeC5Nnh4e+Lxx4lc16zfARBV6Tp9mNcMa5AgdwSFrhyTTBFxmou
	nTs8+Vmd4bOTzEtNIPzOhllVylobVe4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 02B3E1476;
	Sun, 18 Oct 2026 22:13:18 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 469C33F7B4;
	Sun, 18 Oct 2026 22:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792386801; bh=/cZAu8TZP4F38PHdEa60qvWPo9zmofCHFWZ65uJo+CM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sgeAvZuB1W6o1SdRy9zYA7GJMhndI73Mrx1OMrKc6iaKtu+wVbV9Et6vqsUoL4Ei2
	 AlUw7uMs0dDHZIdIf/qR4ykATw7Uhw9c56n8TDd7wKgyWoGwhTy0njvoz+x1s9NB8X
	 vCST7KDRrGfaVAbHWEVbXIK7ptDuUgFZlv3Csl/g=
Message-ID: <d67a7c38-5f35-47db-8ddd-e84e01f63388@arm.com>
Date: Mon, 19 Oct 2026 10:43:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] selftests/mm: check that MADV_COLD and MADV_PAGEOUT
 preserve shared memory
To: "Gregory Price (Meta)" <gourry@gourry.net>,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
References: <20261014175756.2035176-1-gourry@gourry.net>
 <20261014175756.2035176-6-gourry@gourry.net>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20261014175756.2035176-6-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qh8x1yd8htrabr3kiwtckt6m5fkpcz4f
X-Rspamd-Queue-Id: 0B1C6180003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792386801-928405
X-HE-Meta: U2FsdGVkX18pGfN6C8DtBATFLH2AMXuOAmopCAEYTzzk7ZfP7UIEWxjuiP3+QjPeIty1xz0Le1SDbvfFmZwUeh+nNhQQT73lS19Z8xOCTW8S662cqjP1ZzscBnzXyd/O5+qISBq0HRVsapCwpJRUF6H45yjaTz8yex492d+Z4e3FZ/QHmlSmr/HkWW0ASaV6qV9zIt+P/nAMey3w2/FxBOLdWSj0ICydE/wsJqCgg6UcbFIMYFO8/N9lumVTjZQjo9i5dA+T1dTY2Qwqha/VtLSULwcrW2b7FZ3sGuyHpcQ3ZMZDLWDfaUuYMK4FGbDsKTvSWp8uPa/3XNywVdqrwHLStFG0Ax21V/ztFYrlqncaAIFlMrz0K77NpxzrmluxF28m8DjNXPnBcTiVReq596FcJaMB3QzelXfnlP/mMEpFEzy5qxswswMCXN3AoKc5gQmPXuI+bp7aYwSJPTFD8zsK4l2CVT0PH6qnM8Ny/g1u0v2XR6lU52w5h56+dJnelqfQcT1MeDptl0WrGV67kk0zTMoZYUnNYgBlSqbnDSY/tEU/EG+7mU3NvEriKPw8yejKMy1mqDwWh2Gc4rQIQ66xLeRw+PbjRZlLAX72Nzc/R8aZ9uobcQOXLzSnA7iOJiIEe3A14/F66nX3zyNxXBf9y5E3Nd+nHh4T7/hzB7UrAkHuTNj4ODC2TS8Opix24GZkbY1pdf3kUOq8qvMuTtU9/agdHAWI3c7LKu1R5Ttw38M+sNYyH3jXbz7+6CAEp/3oxsYSSKW4my16KpeYq0bBjghqg2zKuCcA6swiQz7xZDoCkrCsIxLTv6iFgrdJWXZW1NFpbjdkJPwEebsIDUC0Rl2vHLTmYTiVaqnnOwx8d/Q2MxNUhh6/ZzwYVG34ZCgNARg6FY4y+ywp4dZs81yH7u6o3ATNW250eTK0351PC/JI9Cp6UO0EvDenSW2pO/grWqyYtQQYUYasrNu
 02arHb0C
 OMxQYzwWl3FGAmKJMLkbJRaGeY+P63f4yAOWhjesY5/ZABtUR2gjoBsJjJDWhkVS5jL+O690X7kZridl9eMp7E8gZsBzN8KqW9d0KwT/LEla5pLe7qeRMaWTrJiz14t0RSXS6nXyUwLk9cIyXVS7sTPtv5aUIsf7MgdAh5XZCM0o6YCeavXlJ7EWxjKxblgIIBdPQvzdMohFMhzcEfwMKUWTvDZMmI/WnczkUTUUhw8nO5SqyOEklMP8y4gnIhLvN4rmdMMFyhwUdoDeEme+v60Yes/1xCdgoBQFruWCJNSU7lOP5csze1y0S9wMWLkqVCEE/lRYl8t2WWMzBR2qbHvH1x+cP9KhGbpoxpGagL2Nq7CQabtMT/4PuToaM65pk3UeHkI3Sb9hFHFN+thOSusiKIXcCWqm8KRVko6TDMluuXuw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/14/26 11:27 PM, Gregory Price (Meta) wrote:
> Both hints are non-destructive, but the tests so far only check that for
> private anonymous memory. Shared memory reaches reclaim through different
> paths: a dirty shared file page must be written back or left resident,
> shared anonymous memory is paged out through shmem, and a SHM_LOCK'd
> segment is unevictable without its VMA being VM_LOCKED.
> 
> Check that MADV_COLD and MADV_PAGEOUT preserve a dirty shared file page,
> that MADV_PAGEOUT preserves a shared anonymous page, and that it leaves a
> SHM_LOCK'd page resident. The SHM_LOCK test needs root to confirm through
> /proc/kpageflags that the page is unevictable, and skips if it is not.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  tools/testing/selftests/mm/madvise.c | 138 +++++++++++++++++++++++++++
>  tools/testing/selftests/mm/vm_util.h |   1 +
>  2 files changed, 139 insertions(+)
LGTM

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

