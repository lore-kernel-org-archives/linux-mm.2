Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED0EE1067020
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 14:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F9DA6B008A; Thu, 12 Mar 2026 10:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4116B008C; Thu, 12 Mar 2026 10:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D0D16B0092; Thu, 12 Mar 2026 10:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1CCD06B008A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 10:04:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C08FA139D61
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:04:10 +0000 (UTC)
X-FDA: 84537580260.03.7BA5ED0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0929CC0010
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:04:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CgeEeEyB;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773324249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g4EUffu9WlExPOUsrRnK04LvkwrPij9P76rk4wv1Z9o=;
	b=z5GGh6eu0LwW/mz605qEs2IonTImTAb2F7MhSsfMnR6mXis024e7n75qoSxfdNXjPlSyN6
	Rs/F7VoTcTzjQfILxkRfX8Ro49mVpT3Uz+Rx248nT70vQ9011d41w8n3dYu7QTV9ndyJoW
	y+unihklUQqkwirvzh4xsCpkVqKoaDE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CgeEeEyB;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773324249; a=rsa-sha256;
	cv=none;
	b=nDtPkfj8IKEyvSXjQ2956/+wEdEgdBgqM7T13Xa4CtJyWYCN+EM98Z/Jj++4CLpQ5+fC+7
	QJV0cjvx5sNemsl5WNAaGzV30PiHFVMGBgE7Y7ItOOu9F+OAtXTSGuv0Cv+iE8gDDFUlJ+
	2V4A4GU9JCCHjimLr8fFW1zhbyW4UVs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7651160131;
	Thu, 12 Mar 2026 14:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D7CC19424;
	Thu, 12 Mar 2026 14:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773324248;
	bh=o9SPjIiwj2xZfrmCdt39M4hAYfV6fTu/SjM80H4vpEM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CgeEeEyB5syn1bLnxgeTI7hIxBuMYwh9MjY5vu3G4U6QcmBDns4tFLoVbLX/Zs772
	 7RcxEqJK7Kp6KahBsHUHbyS07BPGmeRtl7imAjGE56nKCWmxhiD+ah+peDNSWkq3Iw
	 hHvsj0tHh3jKKkw3yiQIVvy1wVg40m/37Ab9gpy92kI9c5GwkHTPNzjgLCEBFD7exJ
	 DnZnERitXZZGLd7fsx68j4NrOTwzvdGotpQzHobjLHsHQBW3W0yb+7oPe5eKcE/Bsl
	 DR4bUpf6YdUkDPFwJHk+JdmNHrkVbBzkqcrAcZcz3oFSNVEQapIyjswKLmUeCZDF+5
	 Ik/YqPO3mvrlA==
Date: Thu, 12 Mar 2026 16:03:59 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH 0/4] selftests/mm: skip several tests when thp is not
 available
Message-ID: <abLHz2qjdeNqdFaZ@kernel.org>
References: <20260312114027.634559-1-chuhu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312114027.634559-1-chuhu@redhat.com>
X-Rspamd-Queue-Id: 0929CC0010
X-Rspamd-Server: rspam07
X-Stat-Signature: jajsmcz3dzayu6cfoynbqnqcch67wdhd
X-Rspam-User: 
X-HE-Tag: 1773324248-465011
X-HE-Meta: U2FsdGVkX1/xW5JNJ712tkG7369zjD/050xaNRlmQh7eEY21VUcBrRAoO2ZoFnHgedV4o6YQjEQDOVDxJa2Rr+kA8SlJnzfwjn9BH5iw0ZXrbvxtYtfimW59KtdgGnQry3QS1RzgmqPWw4puXboR56s13r1cd+HXYxNKm4vgo9rWVb9HYvf8AsT0BTDt9cAPVQJ0iqN/4Cpkqb0+3kykuNIlbnk+GKC0p2JmrcUGHJy/MMLi2uGK82igczbqbnZhKoMCUmmpTqzVaHk6EMwXcGERsjhSP/hr0QBTft6du3vtxc8oAax/M8kWXswjGZgiXOOEpr9f7TjCbMVt/X8TjbiS7FR9nuk6sVr7MHKGHnfdbOXaqbzX/l7Oako0VdwWquuc386jbTdU5I36CM9inPavQTw4/8HkyZrHjN/rykqElUWIdYf/NuCA2OdvDCLJ8Q5BnopRmd2cqm96hWNMPZQcBGnFaKUssecmsXnk6KD+0mmyPULzYZJTD2S0mKbiTDcwS8d8zAi7osOjutNkGyc6MUIkvZTkpGgicUaJIgWBg/4XZg3scvgW0dAPHDx0KBBFIQkEHSXKh22RKf9suqM4BNFOeN9Hsy+Bsdd76B5VD0eOgkJCbs702i4ZOv/iLaOqGlb+Rp1wdH5/POUcXO63QIH1AJM7cXOsKBdhtN3lNnwdfmTcwTXCOCqE6QixHk2PLMuHpeVsdX+s79Eg4t8xdXQAEEVWSYRdmwYzNcpnjm38scUj4NLgKzqPlc5705Ok40ejgFwHSa0C3myKSrGV0d1HJJmxbncfMarPe/AnMFZF2dkWEb7LWjP77+utQ5d5LMv1j5IaQPClXBZ5gqro+s79PGCR2tXAPZ9ESlK/vngrnv/pfDZ02050fBDYZtbnQL3PyFELUtO4muiDUNb8xA851P5cNEONrYuDLQSzSZLr2WwdwKT4poBv/NBfYQnhFI4a1q3Z6VkFKZq
 wjJeV+ik
 F3Pfp1DxtNewPmO4nAM568SM4q2U2t7qjOgRCsDOdnfcb53+CZ4XF8fa7fmHPNIlpsvuqGk4Fwdhhb9xGzhlv9mMIIWntpTvEokhs9my/T2/hx8xI1qQDZqFpnt1Xtl1qDM5TFoRIBJmgddKgDyrzLbmVWEgIwEP5yU966UwLB+HjF8zK7oQR1cCEckE4WCAbZ7b4HKljqadk297lwh71W/ZqEfNgq7gk7nuI0yeKeD1xDNubECvzRDQUgLSc+Ys+EVQI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 07:40:23PM +0800, Chunyu Hu wrote:
> There are several tests requires transprarent hugepages, when run on thp
> disabled kernel such as realtime kernel, there will be false positve.

I presume that when THP tests run on kernels with THP disabled they fail
and it would be a false negative rather than false positive.

> Mark those tests as skip when thp is not available.
> 
> Chunye Hu (4):
>   selftests/mm/guard-regions: skip collapse test when thp not enabled
>   selftests/mm: soft-dirty: skip two tests when thp not available
>   selftests/mm: split_huge_page_test: skip the test when thp not
>     available
>   selftests/mm: transhuge_stress: skip the test when thp not available
> 
>  tools/testing/selftests/mm/guard-regions.c        | 4 ++++
>  tools/testing/selftests/mm/soft-dirty.c           | 4 +++-
>  tools/testing/selftests/mm/split_huge_page_test.c | 9 +++++++--
>  tools/testing/selftests/mm/transhuge-stress.c     | 4 ++++
>  4 files changed, 18 insertions(+), 3 deletions(-)
> 
> 
> base-commit: 80234b5ab240f52fa45d201e899e207b9265ef91
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

