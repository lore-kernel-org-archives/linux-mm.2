Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7295DC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 07:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77BCF6B00A3; Wed, 12 Aug 2026 03:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 754516B00A7; Wed, 12 Aug 2026 03:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 691056B00A9; Wed, 12 Aug 2026 03:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 445BC6B00A3
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:19:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C61F1A16AD
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:19:24 +0000 (UTC)
X-FDA: 85091766648.15.72C13CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3474080004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:19:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iWC3V+9j;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786519163;
	b=3J3+jmaXyjXYBYrtq8jkbl82zHD6Podi2eWgcpvjsqa+o9KgI9LApWNZpnSrK5NiCAENMP
	hZM3BOfsd2utqPdzXrpzJ/CVf26FPq9T7PttbXa9p9Hpxb8ttbyWFbAdqxx+WIp4jEftpk
	bdNcdnKEBoZ2coX55EFL7VA6VowBD7E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iWC3V+9j;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786519163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qfX48QkquLWzR1+PO7k9R/d8Tp1TXi6Cfs/zpXrXi3A=;
	b=BcbmaZ1iekxLzFnSbKp7AHMNPvsjeHIAqD4858xphT2hCtZARz4XEarsXuCOFXGd0Q2Mbf
	UEYQB2nwkhJAtY9y7wuGTZPgPF5IM3pLj9sI57Qd9EtTP6Nc2eSZEVhpKV4l0o5zDnesZ+
	J24oCJGqYpGObK/PKtuo7heUffb3Ojk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8080760A7E;
	Wed, 12 Aug 2026 07:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D191F000E9;
	Wed, 12 Aug 2026 07:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786519162;
	bh=qfX48QkquLWzR1+PO7k9R/d8Tp1TXi6Cfs/zpXrXi3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iWC3V+9jzNSaccdN447tsnb4AQXVGTC2aq4nEXry75v+8hrutQ0Nv77klgtsXQe2h
	 tMHN8nt21NNSkJ47M3GqQhlVqxCIgDaWbTU3jfz0sVHmQx79yy2QsFvYbEBezuJDWF
	 3R1PqhAk0uf+kjmH3+sRGeb0pDvzPu1LiUNFNlYavzGlD+q2+iU0g8SXPafphupEId
	 J1JKiF/8houQkJrzYGnRt+ZYwlmJ8TdL+Dbm1aU1iSmYVL3kEHglNmx/uI3cUPTFkd
	 gWVphp/YHDA5Rb1tFaDRAis2T1y3MJpHzy+lfOO4NhVcn/RrnJfCxZ1oBsvwHrCXiR
	 p+q8vj5DTIk4g==
Date: Wed, 12 Aug 2026 08:19:03 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] selftests/mm: thuge-gen: fix test_shmget() for PAGE_SIZE
 check
Message-ID: <anweBwHBa5PlFbEg@lucifer>
References: <20260809-selftests-thuge-gen-fix-v1-1-1919f4b3d12f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260809-selftests-thuge-gen-fix-v1-1-1919f4b3d12f@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3474080004
X-Stat-Signature: k4i9nmqjiedznxb31x3dydsq99riccgw
X-HE-Tag: 1786519163-98360
X-HE-Meta: U2FsdGVkX18y77+VFTgYSTqY2JUCtaegprwEJ+15QfIRH1XWkW8Y8qKwrgq2LQ/RBQFKGpPlTCAl/xn0gSsDfu/9fL1v/0aRfYDzcHKxoqZkbAqxHZyMGX811HVYf13g9lffj8lKBgILQstvnkr1+XS4iWZ8MX0prIvwCcWe2ellAxul4ofUrksu1qDdGQN4/LQopWJh+f8FKPG/70OJpAmgbSlAcO1BV63Fb045Uxk6cXBvJ1XEfJ4JSw3F+zEsAo7BmBlB5n6vswJF9ZrYlFDnqhqT1lVMVWmCAkyUVZ8rneYQJy4YuwpgjV4PfaGQ4Q5RrbamhW22yACF97R1++AeaDJaixZY+LOGnDKyEXV2zRlOrxqXZPxmIl7QHnMUGe4R5uT0g/LtsecdK5L6KTaT4sxrqyD/8+Yf/QivF0zujckeAwwcN2YWHLQZSR04V5Z0UPJ/rzLvCTEdwu+glhwK+nXsfLgoztOjOAORhvORnI51pBu5KapJ2SCZrogTu3EmMgfZi+V/bCjZjQB7vuJcJuw4bJ90DJnMdQtUaKF0V/mi9a/x+Wfm0vi+313GwvO4qO4HenyMgAvFXa8qSpZxnIcEMzs2uIiu8nb4g073Dg2dAH8cIJzuKO9sq0w6zxTXXIEi95XnZzUirkUc9XPnOCxOeIMWQp9sYCXY1tIxZ0j49MTwtSHlHm41rzGieoLmGjysD7lEUmyhG7kpVULXGKzkqYlYP7RNIkFOeAeWlHFUMPIUoAr/ZRfweTsQcKGKYkVcwIOIris8fFjGJqhAZNx7VmOtSByNWxk71wfdezf8o5Got82FdXIYA/jdAxOmZ5chJmnnvm/P+YNpZZmMYwjwUB42VkV8DDgOmiaedPt+ypXNYrmPpbi8AfTKppfO9bxaZLUTpy8ef1zejIuCRhzJ9fADsGoU30SPZa6vq0qh00TpJVNWHkPjD2MrNv+7eEBo29NIlFflbyv
 3JYy/u33
 /HMk1uRay4lFfP3xY9jX3AWnNIp8LtKrSDGNXX/gTAepv0d43LEJ+Q1rRG6Ip6NRJcPBYqsIXLToD+pdpzFzkc++uUusbc+gYQA8Vd7osUz8SgZtRuMg++LNJCj1Px8X4PcUWHK6zMTDKGEdFC5e3qLrM+NZic3SBmrMrdBjy4Zbw1xhRpv/7r5w1gauNtJsvT7qdsOgwrqnsR1xX0BBoSekDuxoNjGWYrfJWpLz9YEqXmszJp07lpxqbInU67faTkCTZ7aXv0/Vi9oJccdrAaPh/mp/2Z5z0AxHc71Lx8kXlWIsVFU2J3q4kV3ISO386ViX3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 09, 2026 at 11:03:35AM +0300, Mike Rapoport (Microsoft) wrote:
> Commit 49a4e7186b08 ("selftests/mm: thuge-gen: add setup of HugeTLB pages")
> changed thuge-gen test to use common functions for reading hugetlb
> attributes from sysfs, but it missed that the original read_free() function
> special cased PAGE_SIZE tests.
>
> For PAGE_SIZE tests, failure to read sysfs was ignored and read_free()
> returned 0.
>
> This allowed test_shmget() to essentially skip the check of how many huge
> pages was consumed when it ran with PAGE_SIZE.
>
> Commit 3199b0c09efa ("selftests/mm: fix read_file() return value check")
> fixed the common read_file() to actually return error on failure and this
> exposed the issue in test_shmget() that checks the number of free hugetlb
> pages even for PAGE_SIZE test, tries to access
>
> /sys/kernel/mm/hugepages/hugepages-<PAGE_SIZE>/free_hugepages
>
> and obviously fails there.
>
> Gate the checks for free huge pages on size != getpagesize() and initialize
> before and after variables to values matching PAGE_SIZE test.
>
> Fixes: 49a4e7186b08 ("selftests/mm: thuge-gen: add setup of HugeTLB pages")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

With the issue Sarthak brought up addressed, LGTM, so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> selftests/mm: thuge-gen: fix test_shmget() for PAGE_SIZE check
> ---
>  tools/testing/selftests/mm/thuge-gen.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/thuge-gen.c b/tools/testing/selftests/mm/thuge-gen.c
> index 22b9c2f1c35d..50d0805b65db 100644
> --- a/tools/testing/selftests/mm/thuge-gen.c
> +++ b/tools/testing/selftests/mm/thuge-gen.c
> @@ -71,12 +71,16 @@ void test_mmap(unsigned long size, unsigned flags)
>
>  void test_shmget(unsigned long size, unsigned flags)
>  {
> -	int id;
> -	unsigned long before, after;
> +	/* values for PAGE_SIZE test */
> +	unsigned long before = NUM_PAGES;
> +	unsigned long after = 0;
>  	struct shm_info i;
>  	char *map;
> +	int id;
> +
> +	if (size != getpagesize())
> +		before = hugetlb_free_pages(size);
>
> -	before = hugetlb_free_pages(size);
>  	id = shmget(IPC_PRIVATE, size * NUM_PAGES, IPC_CREAT|0600|flags);
>  	if (id < 0) {
>  		if (errno == EPERM) {
> @@ -97,10 +101,11 @@ void test_shmget(unsigned long size, unsigned flags)
>  	shmctl(id, IPC_RMID, NULL);
>
>  	memset(map, 0xff, size*NUM_PAGES);
> -	after = hugetlb_free_pages(size);
> +	if (size != getpagesize())
> +		after = hugetlb_free_pages(size);
>
>  	show(size);
> -	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
> +	ksft_test_result((before - after) == NUM_PAGES,
>  			 "%s: mmap %lu %x\n", __func__, size, flags);
>  	if (shmdt(map))
>  		ksft_exit_fail_msg("%s: shmdt: %s\n", __func__, strerror(errno));
>
> ---
> base-commit: 17e5919bdca144d4e67337f53bf57d7811f62192
> change-id: 20260809-selftests-thuge-gen-fix-5ac05f56307c
>
> --
> Sincerely yours,
> Mike.
>

--
Cheers, Lorenzo

