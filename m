Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C50DC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 01:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 246626B009B; Thu, 27 Aug 2026 21:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F67D6B009D; Thu, 27 Aug 2026 21:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10C156B009E; Thu, 27 Aug 2026 21:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5BA66B009B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:55:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5968D1A024C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:55:57 +0000 (UTC)
X-FDA: 85149012354.20.6A25032
Received: from lobo.ruivo.org (lobo.ruivo.org [173.14.175.98])
	by imf29.hostedemail.com (Postfix) with ESMTP id A0856120006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:55:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=gJ2cYnEy;
	dkim=pass header.d=ruivo.org header.s=mail header.b=AQFrrniM;
	spf=pass (imf29.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787882155;
	b=omTiS88QfFPuWrcAOEBJYmR8l12VSjDJ/hOfHhvMMvMPDU60c0xiyQTC/vG3n9+fM25t9L
	QKorzNPAWXeQoWzzXPeYdFqWBXHnz087XodKQ8u64QEZ+QIoNK1nvKT9TIOvD9votamvEx
	4uPZamhKZj/HHNgGdKOiZpF4um/BGxQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=gJ2cYnEy;
	dkim=pass header.d=ruivo.org header.s=mail header.b=AQFrrniM;
	spf=pass (imf29.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787882155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=e6fWfFZv/Tj02DIUdDBKSbJQ0mOCAlqeJKYo6mt+3RI=;
	b=2qHZ/wQm0Dw8K6UEdaqR9WD7qlliTgyZcwUro33tk7a43B+qFtq/Z7iRKrf2FoegJI3ExN
	O+cAHJExD7J2ClTiHjNB0Jbg00wmmnPHlf7/VTpSPEg2Nl9DX8IlT5sXfj9QcXd1SY4pLr
	5A0+5zrLSs0w1YpapPLuhDqVQDXhRGY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1787882154; bh=c/1uD7NBoSrmix7prAqaH3iqaY9hDoigI61b3sJia7M=;
	h=Date:From:To:Cc:Subject:From;
	b=gJ2cYnEy5ISIZAFG+CoAYVTS9YyEF+kgIH3SSXng8RpXOhSjKmRR6aN8TPycLaqa6
	 /3I+BVAXSitv4+OnllzeMdkWEBNflwXnVHFtBCtTHfFqtVa/AT2ZkMvcFYD4jnUxUR
	 OPSWpcvdKRvEfGWxvDHd1aTVGtQJBEWnnAYIqfnk=
Received: by lobo.ruivo.org (Postfix, from userid 1011)
	id DBBEA532AF; Thu, 27 Aug 2026 21:55:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1787882142; bh=c/1uD7NBoSrmix7prAqaH3iqaY9hDoigI61b3sJia7M=;
	h=Date:From:To:Cc:Subject:From;
	b=AQFrrniMkk+dvoWgFTo2lHFXpGn72qiki/2jrF7rYX9VlBf6smrQpdkKluTg+jOlz
	 0Rc7fdtKLRMBUo3AH8Oh2ct34Vzc58NEDhrF8ohpoXwAIURd6R3fWL9d39uDIXfjCw
	 uJl91S3cMP/Q3w+jXqwz6ux6dO3XZm1JrCcrB0Lk=
Received: from helbrecht.local (bob.qemu.ruivo [192.168.72.19])
	by lobo.ruivo.org (Postfix) with ESMTPSA id 60E875296D;
	Thu, 27 Aug 2026 21:55:42 -0400 (EDT)
Received: from aris by helbrecht.local with local (Exim 4.100-RC3)
	(envelope-from <aris@ruivo.org>)
	id 1wzlok-00000008OQw-0rPT;
	Thu, 27 Aug 2026 21:55:42 -0400
Message-ID: <20260828015542.125576330@ruivo.org>
User-Agent: quilt/0.69
Date: Thu, 27 Aug 2026 21:55:42 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
Subject: [PATCH v3 0/2] mm: gup: cleanup gup_fast call chain
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A0856120006
X-Stat-Signature: 1egbua3guaw4upcwms4djgx6g9yxmgmj
X-HE-Tag: 1787882155-67218
X-HE-Meta: U2FsdGVkX1/jVbGCBuvVJSi7yEUb9V5OMQaIQig/Iuwd8SSwZDw0HZmZkagug1te98X5I5Kdac1tUhr4HGxqcUyAykKl4eqw/GczDYF4+lMr7mVQBk2sbO5HkM5FKABmKJ8wPsY3ch4U4VriYMU4/lBT/sFmyOJsmJB3E7glsrgknJ4xa99D55iCDXqvqwWQTCg5y7xBtz07P6cbD+yWdYWCVGYq1n0Sf4fUTysBar2j/c5L9hXe7mA8cXZyIQLp98Qq/dFslxuthRjKxRzEtlvJw5PHE+oCpHN8HY2+3B+vtUynwnEEJ5/x9Ihw6+FpGqwtRcx/BlSBL5ESxlejlhh0FIIqhOOnJv7jsjl/5+3Mh+x6wRfECeUCAvqy0E/MljHi9sDYtBqPxP6iqMwQ2Zs+pgdU/ckXVzxya7OGU8W2UFmZmroqRepYxh4fMfzESA/yETJVbIvXAQPVMv7i5CpirUAKsUbjuoQz+6EEXnKxHXsDEKF5Cw5uF25AjGtY7uOWoXgiRh3LdaeHi12vFbbDtaeQmldPluAdtc9zbHWCO94PHmnaFKdJRHUwyewVr4bwccc3BkDd6n1Hx8Ij/gk4EbBwzgMqR+OqbfGrmFLhWLvYDAerHToOHbGfF6qt0ma2Mj70aHKSiABB9sPKqxiRpqgAw6/vcVOqwlvjHf60dLbeUhaGhXcK5a0+W4V2McLP6id4xhhsGSb1yXwg+0dze3Guy2MsOrby14nD/izSBnkMJwEvOWRTeMOvOeEhQPcVReOaxqO6wuWc89R1bC74/paxr5gjQObGZHeezELcJjJ5MgtlWBXBDqdf06ZhBfEtc+aFw38j9myejCqTnTpX6Nune8ugQ4lvcV76F0t2l+icQ90U0KsrV8BO/bp3i3oG55cc3dobQjius0Jzg2oG+66dD2j+uW568aPjqpFYmVPy7zUHChllGTdvPMWQ6gy8599FYPiAzCGAwAT
 NI7jAAmi
 Ng0bIGKJn9LFUlnYXVQzatXDLNSkB1rI/Bj9VgFLHGZxtzd2sOy2RrmmTQgzC1KW+pH5NFn4CONAtOru+qvmykVPcfGD5owcnNDkE534KeeJhMfdQNkfNZBPqM5LEPBL5R1LAqFgaeIKegLXY9CaxmlQBb0fEosiB+S1wgk7mtwfzIjPS3SYxygnls2Gly80XeWP8cUVxcoLLzaPidubKEsf9yiWKkApCz/Lw8Ott9fyoRvycccKq1KP6XYkXbgJfUxdmbTVyy3tYIqZXZfdqDA9f+7tkxQ7XN+PsBr3mn+c8+CyG4xqnb84KiDpVE1mNgeDS28v/YKrKvsmqaW9JBPwIUzgbSgz7PJi29MdW34ScKcvPkBd8JrKPt8G/KUqtvzAwpiSz47h+TPzYsUaXj54kRge6IC7Wl7O/co15xxVMD5r1dbJGBIi6QzhMoDIQH2ZpVHzrPrk2wtH9dFrrRdwwRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These two patches implement the refactor in gup_fast call chain David
Hildenbrand mentioned in

	https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u

v2: removed unneeded initializations on the second patch as pointed by David
v3: fixed gup_fast_pmd_range() nr_pages initialization as pointed by David

Suggested-by: David Hildenbrand <david@kernel.org>
Link: https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Aristeu Rozanski <aris@ruivo.org>

-- 
Aristeu

