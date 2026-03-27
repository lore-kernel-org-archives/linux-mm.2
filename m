Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94ADD10ED656
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 10:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA9FB6B0096; Fri, 27 Mar 2026 06:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80F86B0098; Fri, 27 Mar 2026 06:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBE6C6B0099; Fri, 27 Mar 2026 06:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C76D86B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:55:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C14C161088
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:55:48 +0000 (UTC)
X-FDA: 84591537576.11.9A4A119
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 99F71100005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:55:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fV0km1q7;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fV0km1q7;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774608946; a=rsa-sha256;
	cv=none;
	b=vevuFmeiW0/RACMcDhh+CfCYNeycuqrYPCt5c3hOEQqMEuXwyQ0FHAAJ8h89OFf8ZGgscb
	Ztg5tThqRlIvNf0yg1rjTqoclTyNBda8adGDkpY47vhNgZfbLncDPTz6RPbs7NgCjI5z0+
	7yGOu7FP5INGx9TqGYwIxVYbq93iaQc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774608946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wqOxX014rr7/4EOQiI7npt7k72qZHgRBDLEpuc+UrsQ=;
	b=I8UgiGk99zI3ylauqXJrNHZkehUBOtUEjXJNDOshy+/SZB0aratTnBiClTa7qsYSi1/R9P
	ZR2BYnQlXgdRciSNuFDrQahYMQCSJpgIklc+Swhz9sccUhE6wma7hfd38dZeQJqV7/iUy8
	0dDwSQ3h2F3vNboMt+djwObKzhZUGs0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FD91441A8;
	Fri, 27 Mar 2026 10:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D2EC19423;
	Fri, 27 Mar 2026 10:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774608945;
	bh=OnNZiU3/2JpKPliKEYeVbD7OBy40yJs15/jP7cJER64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fV0km1q7L/8x60xynQ3CoZH0kgAWkgwF7yWKaD4IULVH30RF3gEnspxV31EsHRkSc
	 xNFKruMCKBR6P5YBqTaKdA+I/XrD1HtzXvs76vQglGg0GqOY0ws9cFveGJlv+eh5uq
	 cav0c91sLFKChj/bJMgRu4z4eN5zU8fQs7NjoFvYsV720rL460ckXsNw5OXh1ghcle
	 /7lKwWng2C6VCn/AoRSBzimyA2MEroigRat4FzYfxUIosr35SfL5wEUkloeiWZ0V1m
	 CMDba15ct+hJCvoI66VEqCLkugjZeV+TLxMiz5lJb4uAKKy6Nsy8nijLmX5pmINyYb
	 GGc/P8aIztC0g==
Date: Fri, 27 Mar 2026 10:55:42 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, Chris Down <chris@chrisdown.name>
Subject: Re: [akpm-mm:mm-unstable 199/330] vm_util.c:127:14: error: too few
 arguments to function 'pagemap_scan_supported'
Message-ID: <ea001104-8f08-4175-90cf-f667f703b5bf@lucifer.local>
References: <202603271115.uE9vpppi-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202603271115.uE9vpppi-lkp@intel.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 99F71100005
X-Stat-Signature: 3kz851ga9dkw81thoq64dm8kbhtto5bp
X-Rspam-User: 
X-HE-Tag: 1774608946-881112
X-HE-Meta: U2FsdGVkX1/dBZw8vXJNhDntqUYDvqYUAHWs6FiTHmg/bodcEs4/kjH6Tyvmeu4O1LIOz9zJtvmqFXGclb3og/Yz/8HVl6ewEUBaVpfN12wuYJCCKIqkf8pL8hpk90UNeH5zLoPWI91XKhh/26SQvW9PS0KVY8LuXAN+9UFvlRH0vxU5uD95CR9DtfhIAY3UUd5l7njKTPxJhfENz3RcmXuiFVi/iqHZwLVvEO9ah6VgusQvCTr/NY4+VacD9Q+hA6nk3TNVQg8n3yIQKV3ipm/NrWRNWd1Cod15pxKg3oaLaNAFl6AUz0jkcuDgAdQcplgHwB2tREJ5/qq8dCibtSuGWFtSUJ1aNTAPxrkdCO7w7nitnbgBSF/V9jLG59pQjU/4Qo3+YBFf2EevmaJcTfkMtlZ6AlSY6284JTR9YmJDEOGN4KGxoRneIrqmXu0sQQZ/UT/tPwnwpPBw9Q7qh4IinQ3LM8a3OxQbt7df9TrYEMauf251X6Kpko3eTMa5xEZuJ6jTa/dp4aKMFZWMKM65aVr3RRKBP5cTv0F77mh3Ashym2EJ3qY+dEr2vhRPZIB5fIndqxua7oVlggBCjuA0zZPSp/GkfprNTpCrZVbStWwGe2XO5vcuI9+TULl9HJVTprA6m2keqL8iHnt92EAhEtZiOyRJVyBw81zGtzH0pulHNkRcjyxEuVt7+AzOGHMxr1YbLMDgImkOn6MgX5SDUpJM38WvcK5CiYcKucVuo4/HB2jRWqZUkE4If/PVNHmmR4zAnagMlE6o4BZ3DRLaaSt/2+OQIJTSCRzCPMeupxi+KHs50kDskGREiL8bYKw4SPCsVaJeUhsMCy21UY3AyWdrG+1W6NNlEklbYTHKvBfgcP62ZtHyESmzU/5TEinD7QZ8uteOunxkL0YotrsdjYwAeGGO9KXHQFpME9jxgwZ4LLItwwCY5JRA7CztYp+Pc0sEK4x3yTqRSCp
 vqh1t/36
 Wi+8mLR0ahCslHvQtmxTGNgkpuyZVzTa/CdyOYHmFFVfK8A3g8SnYcBhvGaiFC1XMbPZYP0RIeJWdEM/9Clhiy4PEqYmB4ayomCYcR/GPAiAJusj0nFu0vITxuKq3bJMik7hw2WGWt58RZVqrg3+I86VERBzAbEjnGOfGIP1YYVFFmht7D5/pOSIMlstLNFQ9r24Vi26D43tbN+lGd2bsdJGgLXUd/IL8mLd23BGj9uyHSi4+eXr2vJFaOFq8kMI9gAXgloZRUUiw6b28IJkkmmoHDGVUKOHbAXqyBlO+Z7oVz202yn7ze6I1+cbb86q5IA2sLLi5PGO/t6Cj6l0j4B9Kkqm/aNfkMZSzBo45Ms9aN6hWF/8P7e+dERWLAzjyP2kI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 11:20:28AM +0100, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   74dc4627271e6e367176b519565e901ed72d6e4c
> commit: 9652b82ca963243fb80e645319d473a7dc65ee79 [199/330] selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix
> config: s390-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260327/202603271115.uE9vpppi-lkp@intel.com/config)
> compiler: s390x-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260327/202603271115.uE9vpppi-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202603271115.uE9vpppi-lkp@intel.com/
>
> Note: the akpm-mm/mm-unstable HEAD 74dc4627271e6e367176b519565e901ed72d6e4c builds fine.
>       It only hurts bisectability.
>
> All errors (new ones prefixed by >>):
>
>    vm_util.c: In function 'pagemap_is_huge_zero':
> >> vm_util.c:127:14: error: too few arguments to function 'pagemap_scan_supported'
>      127 |         if (!pagemap_scan_supported(fd))
>          |              ^~~~~~~~~~~~~~~~~~~~~~
>    vm_util.c:70:13: note: declared here
>       70 | static bool pagemap_scan_supported(int fd, char *start)
>          |             ^~~~~~~~~~~~~~~~~~~~~~
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>
>

See https://lore.kernel.org/linux-mm/815b2fc9-cee7-4bfa-8036-4b93d1b47b4e@lucifer.local/

This is because of a broken fix-patch that stuck around after something else got yanked.

Cheers, Lorenzo

