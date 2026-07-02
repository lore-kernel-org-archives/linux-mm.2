Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46CC7C43327
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90B866B00DB; Thu,  2 Jul 2026 20:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E2D76B00DC; Thu,  2 Jul 2026 20:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F9B26B00DE; Thu,  2 Jul 2026 20:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 532676B00DC
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:32:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 76D80402FA
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 22:03:59 +0000 (UTC)
X-FDA: 84945214998.26.7C34099
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id BD77A1A0006
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 22:03:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LCvUZwNn;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783029837;
	b=5jzOEJCtrsjt0CFds0O+9aeVULmEgOi+MJ1kfBEbgd8WhkVpmdvY8zCrnbc8QifCK0UV6V
	094IUSn8smu732YE1WqJTRX2ywtoONxNActSGzUYCVW6G+7Um6bxcuv2WuLS5IaYyOgmsy
	yq2Awp1tMPq1bvbIH7t04WPV7EisXsQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783029837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7gpeX2+OCbIxc12i2mYZPsdcMfJTSqmx3ZrRkkdCM+4=;
	b=zF1c8QGbLY/0E7FLUJ3jbKfeMDEyyD4ksmTkCBOGYKU1/pvdxb7BQzlBlOwYIufmMsTeBT
	IaAlRdA6jFdmV/xfc6nAQ4niumgJsWBu42fuuEYTgyAJkH08UI97x9V4I1Nj3HYo1hB4Tz
	HLJ5p22lZH1p95Rh0aAUoLZHno4ODBM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LCvUZwNn;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF75D601CA;
	Thu,  2 Jul 2026 22:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEE41F000E9;
	Thu,  2 Jul 2026 22:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783029830;
	bh=7gpeX2+OCbIxc12i2mYZPsdcMfJTSqmx3ZrRkkdCM+4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LCvUZwNnVrM2HNgsSPkoUmu830cGdvN7ppa4NBCYDDqZ/QdSrKlIm2Q5Hx3LKfZ7T
	 84W0oQPg+pqDk9ZTIzx0YN+n8abBhwe5AStbXHu54vtFuicY3XpNwqNEN1mCycx/D4
	 xKshI9yvWQg+6sD1VsWKkpX5wEn4Z+KtYLvuVJp0=
Date: Thu, 2 Jul 2026 15:03:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ackerleytng@google.com
Cc: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, fvdl@google.com, jiaqiyan@google.com,
 joshua.hahnjy@gmail.com, jthoughton@google.com, mhocko@kernel.org,
 michael.roth@amd.com, pasha.tatashin@soleen.com, pbonzini@redhat.com,
 peterx@redhat.com, pratyush@kernel.org, rick.p.edgecombe@intel.com,
 rientjes@google.com, roman.gushchin@linux.dev, seanjc@google.com,
 shakeel.butt@linux.dev, shivankg@amd.com, vannapurve@google.com,
 yan.y.zhao@intel.com, Zi Yan <ziy@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
 <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, Dan
 Williams <djbw@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/6] mm: hugetlb: Move mem_cgroup_charge_hugetlb()
 earlier in allocation
Message-Id: <20260702150349.1aa99d5a0ecca8fecc07ffdf@linux-foundation.org>
In-Reply-To: <20260702-hugetlb-open-up-v4-5-d53cefcccf34@google.com>
References: <20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com>
	<20260702-hugetlb-open-up-v4-5-d53cefcccf34@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BD77A1A0006
X-Stat-Signature: ert83e1t9mrenydfctcbfnstfz5osgdh
X-Rspam-User: 
X-HE-Tag: 1783029837-466211
X-HE-Meta: U2FsdGVkX1+lkcFQ77UdEXZHVJpFULwOjT2vvFK73z1UxvoHdrU8YZyoAyi+StM5IjlLsnnb0RxuEeg/LHpZSyiojbJ45U6fFwvxIrd1+EJvbm4hpBPMZeoXgqli4bJAizrUXb2xbby4sX5NI0wUufRvDSumrjHiu57WoWn77wL6oPx7e4uXGRgrNgyKo9vuqxVP6VIXAoYXNDufOOZako4AA4ZlI6fsV15aGmpXFULJBlJyy7kNyEkbV5xOdjPlAlyBr76EE3IrCr1LSxUQmYP6jzQ7rhsw38AzqraQIix7aD6stX3mhcUIC1YLw9/mMCUKDjtrlJUHgUPC1uYwvn29roYrKGb1cHcZVr1+JRB8lgm/O+2mIdu01B0BEKLPDTmsxudvyU28MRXYfdBl4Edcpxel9EEuwGyPREkEXQusHgOoCRRKaVJgeaHCZpewuWtVmVtHwn6flLB2Mqd0L0TeeDO0XZkGgJIujuPwBjpQtOJ10dI9UOeoA60fXlScASZG3UIWys2Tua0m4C+t6ZKCsF61+zgeOePo7Q6qBiGG1nm8Z8rJYdShN5w0t4CvpiOCWeq1ZtS0xlMp2uQdP2IGHq20+tNAiLBtI2+DBbopqxHeEYgcwBPYBGR6qWdBbw9MGUTOP3p8r1ITP1g292U3/PDuVLNOpYyn5H4xwXdiTpztwDNH+g717rZjBIM34IdM2cHSXbZ043GTl1K8i32a8Bnxrq/N86yXXHN6U8yIOps2rxz/IlE6/gAlHNiHhcX4VCN1fXC3waCuwgqlaCEFGtlGt75QdCWgNVsVYrpxqjdTou6c6S2w8Wnwo1W5Je8Y8hHbwQsArwIYPNRZd+mjSkg1/Fi9JhhcupAm6JBSP1T0ex84nXSqf4yx/z/5HolW8Sdc7CEgW27qDpXRu1IH4/v/YQKS2yKmK1QRjkozzYGQT405X/npebntDBvP99eaEGhMFlSWLUSb4ek
 Iy8MI/hU
 hEyq3rFVW0+IC3GxwZ83+oe3xHKo7evsN+QLBQTON7AOrqKC90WmKNdNNsWQyS9mqmCD7t1RYwMpVDv8n4/f4l5Qf+b2EiYExxI/dNoXUxUFvszRBN36sR1b50XybBNGyAXm0I5inIyqdOd/vZUdeGPfxYiFKIBEFkAuEkuTCk6s1VYG7gBpSFdXTDaUc4RbYahLX1TKq+guSX3slAZIDaojtsQfJZKJbqMUDQHiP3Sl2N50obggghoYDXcGQWgPN6bk3HnLI2hbS0+P/TfcZvRcmY0AWXsy6Z6NFqW8vIiXOsuItRmclG0B3bsp5WaZQEhgTzWlYQz5gAcuyWEQHJuRHDx9rqR1uIxDOZAbL9dS5C1JMtpEUecqM4cYJ9ClheOwOlShyM3RLYn9sYJ+BLi20L/AKcK3E2wJHdvH3Mn1258VZeMqtvQNZY3QcIrKA/w+suEIXrr9FW+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 02 Jul 2026 09:21:49 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:

> Move mem_cgroup_charge_hugetlb() earlier in the folio allocation
> process. This change draws a cleaner line between memcg charging and the
> subsequent hugetlb-specific reservation logic for VMAs and subpools.
> 
> While it would be ideal to make all accounting and reservations perfectly
> symmetric, mem_cgroup_charge_hugetlb() is a complex operation that cannot
> be performed under the hugetlb_lock. Moving the charge to this earlier
> point ensures that memcg charging is handled before the code begins
> manipulating subpool and VMA-specific state. These two types of accounting
> will be separated in a future patch.
> 
> If mem_cgroup_charge_hugetlb() fails, the code now branches to
> out_subpool_put to ensure the folio is freed and the subpool references are
> handled correctly.

Is this patch also "No functional change intended"?

