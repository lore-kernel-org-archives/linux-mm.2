Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8767EC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 08:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87D586B00A2; Thu,  3 Sep 2026 04:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82D636B00A4; Thu,  3 Sep 2026 04:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76B786B00A6; Thu,  3 Sep 2026 04:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56D526B00A2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:51:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4DE0A42FF
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:51:12 +0000 (UTC)
X-FDA: 85171831584.27.6A79A62
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id D052A100002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:51:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KT+pWvfj;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788425471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JVH0nro1HsiwVZu6xbxniUaWZ5ER5yOTQJkFDX2BK5E=;
	b=WKYZ2okR6DP0A+SdITP4fQy7iZecwp6zVMT4giwihuW23s3aIlSmnyqKw2qy6L0WpngW2B
	0p0OGgdg1R1INxd4xTHXoA0lIob6seevfRcmZ6PZQvCtBHy9srdGVz68A2hPl1vY/YqGTl
	coNddZCKrrw/m19dTqe/5jyBpJDqb4o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KT+pWvfj;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788425471;
	b=TZL12HNim9YSGSC06gnkmrSAFiuzVOXS8UKAlRSkRKXEvJvFlSaHR4SfQiz4zuqh0jfOI7
	NYTaywJc4BiUbOkZBqBgHwpCf6VfyBiVa7pL8xqNVFaMex0kK5p6mcFg7nDNb5Rxcxq4vt
	w5NtIKEXrAmhsZCrjwSeaTBaCcgsOWc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0BB4F1596;
	Thu,  3 Sep 2026 01:51:06 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8BF733F673;
	Thu,  3 Sep 2026 01:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788425469; bh=7ly5roaVBhOuz8Uf+wlOpzMScbbGT3Gn+abI4matX6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KT+pWvfjhpOIP9JUbMKZsTvpd+1pHytdFYh65fL4CMQkPEra60Io3Ba+oas9RUMa0
	 mQWySB8ayRO5Q7FbW0/+Gjb/y1Nvez5PbGcyqFK10KO6eP674XPfb/d+9Totky6ZHg
	 f2K6iEGhQJHVvjwRJN/sivSpAQoq52FbTE2BmSEw=
Date: Thu, 3 Sep 2026 09:51:03 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, shuah@kernel.org,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, nico.pache@linux.dev,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org
Subject: Re: [PATCH] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT macro
Message-ID: <apk095XPQkwdoXf0@e129823.arm.com>
References: <20260902175611.1241118-1-yeoreum.yun@arm.com>
 <20260902122932.7a1b82de7a80dbd5897b65f0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902122932.7a1b82de7a80dbd5897b65f0@linux-foundation.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D052A100002
X-Stat-Signature: zf4ijfchubcar6qdk7re49pfpo7zbxwd
X-Rspam-User: 
X-HE-Tag: 1788425470-864554
X-HE-Meta: U2FsdGVkX1/7ay6C3QjWX+NApuLxZzaI+yPkvg1E/2iYYVqZ9wC34c0cKS6nV4xIsrLmlZLWDjM18/6qa2dV/2SRPfua0DIUyt+GVo9OIGYyTNs1bOHMi9dEIGrvRZyvDZDqUk4uVDXPECb+zLF2zEFj5Plxxs9IRf5Mbdn0eD0/cByn6WBOVOk0/P98qcjRHS+L/SxpnMDkxickfbTxyuALyqKCkan9hc88zQsNLzAAX1OOKUOxcGvUg5fwAhsV2VoGS5ed1psmb3yx50zB7aQYuNMGxURis13RJEB1rMCM3qk4oIPUvXEEAWj4uPxyLS0kuV2yBU2sh5g7jCXUnsPlHYtSDNKR6vs6H7JYv9tHEVzTFNaZB5P1ovFcNXLq7jitlnKRpfGcAgIM7G/3xIRCO+nQP1i7LMqbO92Q2g9ZblEkBI7Ea5fgoqgzkB+cNk1noU32JbG7fWSgTtILiWpEK96sVvtrtksCZBGO0lIK1Sp8QvWGopb5+NXeNRWMN4+0SmdmRyevoRqhWhufzeXg/4NfargM1wOUQC1Uxz4tjIJhrPN5nIuJDG/5aESaNeo/OC5ZFYykQtjcG+XVKJ/brOfH7kSevLo2m2COWBwEjqxZTp6loRTNKM1CUQ2YsF30MO9eY0Fszt9rvBEvHcavnCKPKQsSBnGLhllbTT7xUZucw2XkaJFqJQ3wmjzCdW7UZvLuRRVZ2S8/aoPdPL6/lw+UeU2xv7Zw5wzXKy7WjJ8FZsoXWArSV+HXX/IeG+qpfqrQgqmHz9KoFN2/R3enWwWIjX73OJpNUhVOSDafb4gE9ps5Mu++RaF/5UzEMn7m0I/IAW9IVAl3mSbE/9VGTOiXVhbsc/2uVppb6qDNtHbG48foGON7Egj+qVIAOm3tMaWxwHpEmK69C/miLQXIkCcs3KjGishSkdKq8U9B6BN8mnOu7yK0r6hrx3TB611ZWNEeyO0DFYRYLd+
 odoVBHY7
 j86Sm+tyCUmb/e0NV4HMfzof/U6539ksdaJxD+vSq25aws+lfGAhJpNPbuYIWY9csInKstZdoKEfKlZfHR8wH0iJxBr9L4NDltKq8E+RgRnyHUEYvqpHDqjOe+jCJWGnEqatH9tLMhGoMxRQ6mt7ZiImgH26CRCpktNY5AG03vxAqaseR0M71E0GTkfkG+2aqCsYiKdMoF1ZKeExKZ1tvnvzhFof5Q0hPTpocGgGabBUYO2oGnVXC69puyzMhl1bsvvZkN7jiEwUOXKzR7BcY9SrpkWqolc2rfatDVfRDD+cxGG7/QMZ0AkCg9DNegmGfE2B6wb9Mwz0A71HrdKIOL8nAxhz9MIvRtMj0io+FTPXjbeprdWGxAF/1GaayrbxNDk3EOijiQI+8oks3fiz5fiLrGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 12:29:32PM -0700, Andrew Morton wrote:
> On Wed,  2 Sep 2026 18:56:11 +0100 Yeoreum Yun <yeoreum.yun@arm.com> wrote:
> 
> > HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
> > When this macro is used in some test, test result would be strange in
> > the system where PAGE_SIZE is more than 4KB.
> > 
> > Here is example with transhuge-stress test with 16KB PAGE_SIZE:
> > 
> > ...
> >
> >   ok 1 Completed
> > 
> > Remove the HPAGE_SIZE and HPAGE_SHIFT macro. and introduce hpshift()
> > helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-exist
> > helper, read_pmd_pagesize().
> > 
> > Also, do KSM_MERGE_TIME_HUGE_PAGES test with size of 512 MiB which
> > is the LCD pmd_size among 4KB, 16KB and 64KB page_size.
> > 
> > After this patch, output of transhuge-stress:
> > 
> > ...
> >
> >   ok 1 Completed
> 
> Thanks.  Sashiko made claims.  The first looks legit, although minor:
> 	https://sashiko.dev/#/patchset/20260902175611.1241118-1-yeoreum.yun@arm.com

Thanks! I'll fix!

-- 
Sincerely,
Yeoreum Yun

