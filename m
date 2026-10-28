Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CDC6606A33B
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 11:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=HpmChy7/
Received: by kanga.kvack.org (Postfix)
	id 34A316B05B2; Wed, 28 Oct 2026 07:24:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FAD56B05B3; Wed, 28 Oct 2026 07:24:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 238336B05B4; Wed, 28 Oct 2026 07:24:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B5AC6B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:24:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97AFE40C4C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:24:22 +0000 (UTC)
X-FDA: 85371801564.07.6497799
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id C356B1C0002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:24:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="HpmChy7/";
	spf=pass (imf18.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793186660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2xCXHplURiniQc9ck7TyMRt3ZbXb6hxVB8xWH2R2PZE=;
	b=3C3Hp303YqhVMZ78y7s7fYiccmBZILnmW0m2eDdJBoqxey60FSqALrcnTbsi90YXJlqSkT
	o528KuT7wGVDSDiGrUHnhu+TzHomH0UPH3lKttaHrMGFRM6m7zFK1q/5Fyp1+jb41QtVbT
	bti0KirCQxX1RxahrS3igs5aGNq9JWk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793186660;
	b=AQ+CSpkFOcFmIY05uQ2UiHR0WXwtiAFt4XIJUEhWD0y0qjJs4xPctvXoEL+sEQwypwV1j0
	MngzirvTn3H2Ee1rHGbS9cSqNP/PQ09qPLYKAgLQGC0wOPa7qRt7f077rYAwel/EdPi2cM
	PRiInTF8kVE/sal3Y+Y0IAKaDGQDG9Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="HpmChy7/";
	spf=pass (imf18.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF51D16A3;
	Wed, 28 Oct 2026 04:24:16 -0700 (PDT)
Received: from [192.168.29.156] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6063E3F673;
	Wed, 28 Oct 2026 04:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793186660; bh=kBcc9gOJeHW/ZyKtIy3EZx6TqVCzCIfBXbymtxm/ptk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HpmChy7/wSzaK6QVHmfmbok1yQSifFR0m5JhkcZEoFkXWaUFHAsqOwKt5m4nqEwRJ
	 0ek8YjtXV7O1W/lo18XYEHgLN9flJKw7/bzmiGS6/Bvvl6yTZCyMfvaLmRu8elSs+y
	 tOjU3FxS7E3iHLXEr2MVSr1Lcyz8I3VfMl38JNiU=
Message-ID: <f3e0403f-07cf-49be-acb9-671a1467d1cd@arm.com>
Date: Wed, 28 Oct 2026 16:54:12 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] selftests/mm: check that MADV_COLD and
 MADV_PAGEOUT preserve shared memory
To: "Gregory Price (Meta)" <gourry@gourry.net>,
 linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
References: <20261019171206.3331374-1-gourry@gourry.net>
 <20261019171206.3331374-5-gourry@gourry.net>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20261019171206.3331374-5-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C356B1C0002
X-Stat-Signature: ye4cxpacf6auxn1k7q97bzi7yudy1o4u
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793186660-527417
X-HE-Meta: U2FsdGVkX1/xfBlFcakIHs0Bu6dKWyx/lw8atFUDWx2fhpJ8coXSayc2LQPjh5dlchYdUCrZpqgdiPWGycZNxyLzzQAwA938xsV9m5QXzbkKUB43LgnnJaNqc7VmDNO658QzzFqCNhcwwXu8mX8Dv6P38nxs/fXARgLzMGGfGhGfmWXMoTnrOFoIPrHZrxF63y6SjCYaEoD+aZOXO/aKjV2xosKxLR0wj+IZlX/uNxhC1VQOfp0ZgD2tdYZ9Tgrk1I9Zs73IXWzsOLae78vksDadk6Z/tGUcTGMrl8ntkwekXAJdC7nR03Ur64Pz35PsFAR5e6ukTUAI4EIzphYZN/uvNn1HAvvRvZeFjIYlBosIZItv+NcA4hlwTP0wkwklvWcjqAS9Wvt14z7LZbOoMs8h3ORi2UwINseRL8JNWxIgkIU087HQWUhsrmo+zmcONYldZ8JTRhL29WCi4s+gHk56rTixyvdrEvViVcEoYVUCVEnVKl6YZw+YJTLZ8nehL0tdSzvkX+bsHb2Od9n5Sdw17oovJ/g4J/CCvGtiRPz52Kamk2Lw2Lc6S7tvi9+alRlfFOcCAJ06SkoQCwci+XI/1SpbVOJVqnMvanKgxF/mIqNmCNe3Afw9560qnWyvCsqeMgQAq/N31ivi7rTWNFOBmoHkcMRmsOEyXpoV5NsZvDrU5GAmlsruAiBxfZVH34bWVfM/CuU6lBkeJYl1Skw+fDuGGN3NJ+wNq4yYbYoCsdIuF09nSuV0WTE61Ge6Y/+JKQE4H1l5rtxqN4xhBog5TbGvzRSRFLCRXkpFYzrh2EPRrhNFnKpgO1vf/KeJ3xtSub+VOewI6s10j3GwjZjBk1X0zJ1mgkFl1gXnJdvnLdFreFEHublVs67BwZNvNwC/j4+sy5a6QlLqav8tq+cAyOS3rHIWQMsFXUyR5nzc4F+jY4YhqnGMgnKJ7Di6ykqqYyMSxehJL0St7Ry
 DepOjDWL
 TdZXCu8DpZIWZ0FMNCdr7+0n7b0DGpFMN9DgNcbR5iDr2JCrtOEM26WHRzOn53a2AYMq5C9uOtwy3UPsk8xlN1oLIVFjP44sw46m6jaz5JFl+llEXi7CcVQ6No02OvQJHZORI1PIcDLj39Gk/gFP61vtp6qYa6dNgwwhwrryPX0ug4jzsuafdSTFIA7nh19qpuubO0ConKlt0bbH5d3Os2kmNRo9RaxsMrCgW6VuOO+iuDMuagy80GZ06fFVuYnuyZywK3aRooOAsoqb06scJpQLIizkIo5GndgQb/T2BeW26K8m/Us2L2FhSvoZK/SQuNXLQgzbBVsHiZkn0y2ejI7DB4qnNlUe6xEEsJt7RXaxKv6uBlmDidbF2lcNoqzCX1/Zzy8iai/qiFD1wYai+U2C2GA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/19/26 10:42 PM, Gregory Price (Meta) wrote:
> Both hints are non-destructive, but the tests so far only check that for
> private anonymous memory. Shared memory reaches reclaim differently:
> 
> Test the following:
>  - a dirty shared file page must be written back or left resident,
>  - shared anonymous memory is paged out through shmem
>  - a SHM_LOCK'd segment is unevictable without its VMA being VM_LOCKED.
> 
> MADV_PAGEOUT unmaps a shmem page before it tries to swap it out
> so none of these needs swap.
> 
> The SHM_LOCK test confirms the page is unevictable and skips otherwise.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
> v3: Dropped Sarthak's Reviewed-by from v2 5/8: added the fixture check
>     for hidden PFNs and create_temp_file(), and the shared anonymous
>     test now fails rather than skips when the page is not unmapped.


LGTM, so:

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

