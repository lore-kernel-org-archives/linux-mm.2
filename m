Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB8DDC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 13:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3AB16B0093; Thu, 10 Sep 2026 09:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12386B0099; Thu, 10 Sep 2026 09:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50CA6B009F; Thu, 10 Sep 2026 09:52:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA5DB6B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:52:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66DC7402E6
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:52:16 +0000 (UTC)
X-FDA: 85197991872.15.1B8C6A8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6A12D10000B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:52:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vARC6GeL;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789048334;
	b=6Kn5k0TvM5GXdY8oI4d6hFB8OrFYT5OW5ZCdMOUdc8du66+JFO6fj/5AFwIihBT8EmmjGh
	16qbk/GlXKodBk9d0SxwyFkpwKDPi3r7xZhKE/m+7YAkNBnE9q3wxtwywbeOn2D9lb+B/d
	lF7Apuc+Oa0Lqvj+DbgMbK/6ooiJawg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vARC6GeL;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789048334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Hw99+skKmn9AdtNdvtGkcpzpWEaSoMjqxT4jOANVrY=;
	b=IhmVNFUa8VkRYvRDg4k/iNnsT6H+jJfznf01Z3G1mlMC8j9fsp69zZ6dgIzL4ZLKnC/Kji
	RNYydPoHwa93dIRSVae2QKHb0R5+p0jfpjGJTG0JfW4KUl/1FmcalraAaR5ILf/kXBy+aV
	Dj0+VyF076FhJvaru/5sP76yOBCaYFE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A05201570;
	Thu, 10 Sep 2026 06:52:09 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC7FF3F59E;
	Thu, 10 Sep 2026 06:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789048333; bh=BLeoWk5uxGFQ/YEtzA3yICYffhVnHkWffEkn9ZTAC5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vARC6GeLbF1eSnLStgikeBQEfsKezRxmbdmUGMAx6++HTEpu/3HCtHdfmAzI3UZYc
	 ac1ZRP+v5TZhF0i9kwYvN7wTSjvRUVod9/iUe8KlZZ7IVsrEGN3Dl568ewPpLEP2sq
	 UNWVhKw5mm0nYzLAp6lUmqqigrSBI4rzGyLgwXfM=
Date: Thu, 10 Sep 2026 14:52:07 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: ;, Re: ;, [PATCH v5 3/3] kselftest: ;, mm:
 introducealloc_isolated_mem;
Message-ID: <aqK2B_ehcrcGM-kV@e129823.arm.com>
References: <aqKOVGECsCNtSMIV@e129823.arm.com>
 <d0b3ea99-e20b-4883-8fa3-67fdbf5b1ee4@kernel.org>
 <aqKS7CP67X4h6NiM@e129823.arm.com>
 <31418d0e-9745-4e8d-bc02-dbbd5cb9e193@kernel.org>
 <aqKU0-Gm4yh78F3V@e129823.arm.com>
 <d6f2e6b2-9dc9-4f02-be37-14329c1a6798@kernel.org>
 <aqKfjqa6ye2AOU5k@e129823.arm.com>
 <11a36d52-89a0-4f43-8a51-a4930e171ba0@kernel.org>
 <aqKj5ojQ3dabOV5g@e129823.arm.com>
 <8d27168e-5443-4073-bc65-24ddbe32e29a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d27168e-5443-4073-bc65-24ddbe32e29a@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6A12D10000B
X-Stat-Signature: aozjyyjxamj7erswgc5nzjuotwu5ashn
X-HE-Tag: 1789048334-555695
X-HE-Meta: U2FsdGVkX1+jyKSAiQ27jDtgr4e9fbEbVvu/3uhmcL+uwRNnCJDf3ZuhldcYKRNvvk5y0vweKIQoentLmfDM0tMyqCdIVhtm15dJoG+UmzMx9ZRI2MBvoyADomAcFSPqXMkkfQxwEpzTfsYIbCxa1vuwfSiYBPXflDTIaKRA7H3W+kTRhadjv8nyW+UYCood6Le4CZNognl7QSeok1d5U7dpkQhKSju0lRnmZ/lPyIJOkALcTabesJGuGOp84rjqsfNgDkpdJVo2JOjw+Q1plqu+lpDOEjXcFs5UnFoc8tnkvVxcfrFFdknFbe8hFRrLXXipF8sVtozLcdemLmnGkh3n0vJEsPE7tY2eQZQ9pRxZq0cQVRloV/EGk/IHmLgfh+ZCgZlCoLeAGKXiMOljmHvu0onD77GgXD84meNYmr9JmvafYko+0S41Fw01Lzo7TWF6kKvBSQNUjttKjCxgwDPlGREpfV12MCEAsuir5WXYwwCU2+tmnyWOZiy/tHXSr47MwrNaVb4jZTnx2wXlRecY4JzQnCf0/oSsNuGNl5zxM5tUDYSCPIFr4nhvenMRV3chEY6zsSftNLNqQriFS27i0UYtSONvevXDAnXVaveKIf10qw/1yKJ0EqqNjbW7TsS2w4Fv4bR6AxosCUstu7NFgddzkntzeKP+1x1H+QJYykI8JsknUzrUfX7rv0PXLsrVnRMcqXqfcqB8ZH7d/8VuQrzxhIgTyZUeW0pC/XHvZC7tHNfUAAGAWgUppyaAX54RPpCnT4QNbZtAOJQRwlzpzRfypnMQW+rPZWjW2rSxJ2W1LYgf6lGCOvYH5FAAfF4iLw75ceiHsC5gdLKeGICh/FOGLPDc5/N/hTkdNi+BpeTdNb/vpvcLG/j4kTHDh37fdu+9EOz8Nk+0Hqj3PVBjNgoPWUQ2voUqYerGE1qZEtWKWPPxJLbQoIjK2q9cBbgVWRjWqBF3QtLqDkV
 IyBtzh8U
 THFZ0I3zAr7vF2L7IT6OmcPZ9DvEE/ern+u+0ccG1Ubo//ks1fvr1NJtXgmKqzGAxhQJdWc/xlbnVvIgeHJE8JM1DFrFsQRX9f5U48I+PNwNoJ63apEOZvcHEknksnVVH4RdjNiGGRi2Qt/k5IV8XkVk7xPgl23wvhV+2AJYw6J9gbL7SQ9lu43O34Bdif6mcTpgCCkrNp576qJXOA0rjsGl/njiR/MhaBxpd95Wly/jm9nV6FUkkbN8TLCuld0c5uj7DQ7wBCmyNqgP5CNfmpX8+E8qdXFX+wPU3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 03:14:36PM +0200, David Hildenbrand (Arm) wrote:
> On 9/10/26 14:34, Yeoreum Yun wrote:
> > On Thu, Sep 10, 2026 at 02:25:40PM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/10/26 14:16, Yeoreum Yun wrote:
> >>>
> >>> True. I overlooked guard bit is sticky.
> >>>
> >>>
> >>> It's enough but alloc_isolated_mem() could be modified to allocate with
> >>> PROT_NONE first and then change the prot.
> >>>
> >>> It seems whether make a helper or testcase should write the code
> >>> properly in case of unwanted VMA merge.
> >>>
> >>> IMHO, instead of testcase write them all
> >>
> >> So far I am aware of exactly one test case, which others do absolutely need this?
> > 
> > True. I'll respin with your suggestion.
> 
> Don't get me wrong, if we'll need this for other tests we can add helpers. But
> for a single user adding a helper is not really worth it.

No worries. Since I thought there is no use case right now except the
test, I've agreed.

Thanks!


-- 
Sincerely,
Yeoreum Yun

