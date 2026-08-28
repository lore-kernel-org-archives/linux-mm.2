Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8626C61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 02:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE36F6B0088; Thu, 27 Aug 2026 22:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C92CF6B008A; Thu, 27 Aug 2026 22:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5B756B0095; Thu, 27 Aug 2026 22:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A5C56B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:07:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04D37C021A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:07:29 +0000 (UTC)
X-FDA: 85149041460.12.EFA0B0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6FE9C20006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:07:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YxgkTuvP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787882848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7eyYXRUwO3CYA0w+PphgO5XkPG/514TRxReSf2GU674=;
	b=yUkah3ti7EA7cI5xrVomqPXBeE+cSNqGY0K8E3CwW8OTaoAyhq1FjAAdHqKbuVXa8KYOxw
	ZZqb7WksStxl0+vn48tLu2dBz36zGklHyjKuFZC42V+ZNwERnhv2cqlss/bUCVi4s5whOA
	xuaNkyJEknIdTQn9Piah6Y3G4sGNkyc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YxgkTuvP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787882848;
	b=5wJh8kEbpb1M4fguubwu/9em5bb6orgVRLSyL1KQTIBOKgZQfNT7bnYJ4AngmenhGoYGBw
	lh+AUe7m6YGfGX02x3KpjaMnP1yRwbKCx5f2GFdbutcOuWGtXKlpJamX/BbGWbrrbzc6Xh
	NHJ3UgYJ1mMZhNqpXLW6djlSZUyEsrY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 62A5C413FB;
	Fri, 28 Aug 2026 02:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A281F00A3D;
	Fri, 28 Aug 2026 02:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787882847;
	bh=7eyYXRUwO3CYA0w+PphgO5XkPG/514TRxReSf2GU674=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YxgkTuvPt7lazpqwaf3eUN8Wz+t0otbNoh8iafDfWBHfu0iqQvkiDuk7/qpkAaNAX
	 1aCwuNiWwEK3O7H4bEFhjYtcD8sdC+wza9qm4wQrAND6nFnIjiXxeocM1QbipKalyx
	 w+Cyp19FlUyjqhUNeD21/LDrzuLC+Fjj8kr6yQzJsYbpc+UQ3LkQNGFcrw3iJT3AXI
	 kXYNTt5key244OiUYLdYLkrV8YpMj8jX//FNEtFQQMBSLIzvGR0WO7oEvq3HRTTLCH
	 hI7No3V+g0SGg70rnOTGIobyqlSuF0D5UNMs+qU9xqHfoS5X+1V4/wZ9CRFpx5f3SI
	 p6vLNa12W5m7w==
From: SJ Park <sj@kernel.org>
To: Yue Haibing <yuehaibing@huawei.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mm/swap: Remove unused declaration swapcache_clear()
Date: Thu, 27 Aug 2026 19:07:19 -0700
Message-ID: <20260828020720.122079-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827082722.1809702-1-yuehaibing@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6FE9C20006
X-Stat-Signature: a8gdb5jsa1sd7poknj4papci97k5676j
X-Rspam-User: 
X-HE-Tag: 1787882848-41827
X-HE-Meta: U2FsdGVkX18UQINh0HMv2MF4jC0k5YfZ5RZoLkgz65izXfhbK+8TnJe0cR2LZbig52bfIF0ltVeFN04RLWj77nLTPkqPyGmkKPbq7qZj++/iFgWE05lIafhya5gbbLRMxKAdO3G8OaOnLe1hk6SFy61hYCHF1ORd9V1fYCgK3YzEFk5zLSKvJHzmEAPgNAbbUXmlNJ8jxFGER2NvLnS0kEFrp1K2Ww7anOrUYwRWkz8Y61ROWDtTxPWN3DZp7B5atGQPvVSFXOIc9XpPm1urEhgioxeubPWs9I9W4xnghoGECq5lT994cIxVfjTBUENWPIxw84A5DEhg4i+HmuCWgvZH8lEs6MW2rhghn3BHYte8jMzS/tECDOYi/6DoYSJmIkJaQqerzky193D1MxXHrALNdsQmVsol63L0mnkb1SYiXiMOoN9WctI86iVeLq4GLrYwwwVxI0//xHkeY5up8neOYMkKvUxoU9Fpl/ikDmLMYZu5QdcL9ldh2moaIE/vC5R/XBtKIwPrxAAP1z6DTEG3xPZR0SDlcVZ5GU9hefnfa3xxFLGhRKv+yATtYzL/O2/PqHQHajwIluarXZ503mNfu+M1cnxJXSLz87mJIOOCSzPsp5KqN/G5l7fDKzLzo9proGvdts/3VWoTgSyQxT0Au5YeAIfQaxhjAm4mEQZlPCdJSLNZVdBeZLFSzCMH8eC/S3bog2qDq3eL4dojOJiqddbnWpgiEPMrCohmNblBizWujN+9HV3gG/qISSU7eFCatoMDEQE9PMRaZbUq9omzp+H3Mq0rZjPy5+xNrPNwpDeaeShH2/vLiZdDqLaYd+8Z84EmfkDbot1tayWGQcWfGDFkxl/KGiKvXmrkuDtvtzPgMLLVHkzILAz1YAGkTzGoBaCk74KFwmPXYxsc87sqmyc/B3dxP2//xSl4HfSa90GHGv64etEZRNsfISXbyGEoq2Yd89TWx9a2fRU
 J93L6R//
 thutT1obM9DA1MMq2Qahlls3qBQg2gJCQ6LaJnayHOq08QyvzyYmQbHMpvBrmMCLaBvYLzcNaUbTIiOgU8OmeT7sY5bq6ENn0MWIbsOE/SWgQGsKMJGIKCq57IZ5jSn4AYVV+w0hTJ1mQJ1G/dvnNSRYsU0OijfhdmkZqh9X+itOg8TJD0V7ocaLpPCifVpdbyWlgDIUxdKG5u6TD4t8Xpbsai/0T0QykuXMyQuiFDx+MRaPUBUM1qfrSZKVza48fc2VYa2G9N3USpan0ln31GUIbevOmUcHQb2t2f8ESDhDHX0Y/8akD0Vv3nA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Aug 2026 16:27:22 +0800 Yue Haibing <yuehaibing@huawei.com> wrote:

> Commit c246d236b18b ("mm/shmem: never bypass the swap cache for
> SWP_SYNCHRONOUS_IO") removed the implementations but leave this.

Nice catch.

> 
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

