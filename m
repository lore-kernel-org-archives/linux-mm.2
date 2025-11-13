Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5C00CD5BCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 11:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01C848E000A; Thu, 13 Nov 2025 06:42:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35FD8E0002; Thu, 13 Nov 2025 06:42:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73098E000A; Thu, 13 Nov 2025 06:42:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D65DE8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:42:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7BEBC140941
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:42:16 +0000 (UTC)
X-FDA: 84105395472.21.55FAAE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id EAFA71C0004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:42:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VU146KzH;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763034134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d5BQEnTGDYort28gv5F5zQxkt5w5KrhNkvYO5PsZPTs=;
	b=q2zojKc83i/5fBUeWKau7jH3vCpqDHs0fNAoZOM0kdpDkujhwPQTV90KIckyUKTkiZwKcf
	xDFwRdPVpYCcsEmWhbgFat3oZvBz4fL+XO65LQ7qM+7rSmnVt7ybjwkLPffscFwedMMcul
	zCzK11Mri+ZRQXCi5lZ4fof7qwX8fho=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763034134; a=rsa-sha256;
	cv=none;
	b=tqsWR22qqtlSrdPIapZjPKDmZg4ZFctiZQCWBhgoYrEe5jFXsHE2/fZdCwGuZnhjkaiA9S
	rVYYoz9k0Xj2cTjvd4hTyA4Kej44mRbTowxIxQJrfpytWABWCiktzkv7QcGiQmKp3R2hHy
	8b5uZ/C176WZ767yZtY8DAeuCIuihIU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VU146KzH;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 57A33601B9;
	Thu, 13 Nov 2025 11:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC98CC4AF09;
	Thu, 13 Nov 2025 11:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763034134;
	bh=STrLN9TaMedzhy/AV3DPEXhd1qFmA8sZ1GjlOFXHjO4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VU146KzHCHjuBsPUsgTIzQH0cXL+9V8Z6BJqbMtO79x84t7yUlDckcL2h7qf9bRFg
	 obF3uDlCXmobGcjhbUpr3Wa7VgZ6PIAjSBYOzjxqEbNq9uGJvWb8yDvfj08/PQ/g6a
	 D13+Zzxmn8YrUz2QFj168p5x6HYuAqYEW1zTQ3zSxxfbU4fE2KkhZKF5gYoWk1cLlw
	 MTsxXNGTVAzosrfZAxLZ83pNPnN8uj3mBnqlX8pye1ZjQHW1YlAcQHdvIY6394FQSB
	 1aQEUiLoVhEL9j6cYVFgedr30vAUY4djX/mqiBY0rzyeqOfTiityRADnFo5V5M65hg
	 pEb7zGtClVyQA==
Date: Thu, 13 Nov 2025 13:42:04 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Carlos Llamas <cmllamas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Brendan Jackman <jackmanb@google.com>, kernel-team@android.com,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	"open list:MEMORY MANAGEMENT - USERFAULTFD" <linux-mm@kvack.org>,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH] selftests/mm: fix division-by-zero in uffd-unit-tests
Message-ID: <aRXEDLQQtwVPz7va@kernel.org>
References: <20251113034623.3127012-1-cmllamas@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113034623.3127012-1-cmllamas@google.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EAFA71C0004
X-Stat-Signature: djbjgx7h9seeqi5aebqzfcarjdb3pnzj
X-Rspam-User: 
X-HE-Tag: 1763034134-825884
X-HE-Meta: U2FsdGVkX18wld13eTKQXz5SV3cDrVKvKr72J0+5/12C0lIna7dibuPN+qQPBWZWra2fYQCyTkOD7xcqu8TMrL9/Uh+WPuLAb2XwIJg5jFZmS3ynIxbGBtQvLqCtcpTiCoXOtlaVrnWCW9ExXU7MlMjd9KBhPvF3q6gwMiImasqYp7yY73sqXNGdop7wcpVXm7abMczsrMRhhP9CIlvbWdRTXu5nQUh77L9t67nJFv9QpD8q642cwNr4fShrq3yvHRrNnF+5m2Vd2F9IEJY83iWGZwsMpXn69c0yhuWl/gzpnvROHTlc7oFvhxLEk2lxkiK/XyOmf+uue23ioZfrK5cxKighU3ZGEfqd+Qw5pVEVUvvflS2BQWVBZmRcEET/qD5ehuDSLTcHe8Uxfvl4NA3lGnOxMKaIzs8TF7K0Uuwmzzw4xxespMLhj9As3DkKpfqWnirQbSXLShOpRX8pH3ApBasgoo1Fuc+fezUtDeseVIwWe+cxirie4VLA8CBZrDh8hy6VpSf0sASmVOINuQVBjpx5qg5RpsbybIbpscQ6RzPwQ/+fjFInXznq5AzgVsQocCr0H9ZSnxs0Twt17QjAEQ19F4d+qqYIdA9qGCV2uwTt6adssFQf7k/Min6zvWsmf0GGuiz6mAQVf1y+nBZIeXYAmLa1Vn16lr/nJwR4tMAmfSJPJNnZzSYzyh+SRVqUQfF14W6cMZGTpxtY44Wuquy1ebUSwtnEa2Esi+HH9WKGcypB4QwWY0wuanc2gyzR6pPmpKXXqzEat20D5U46pJMvIYE+Pu2+jHZw/bRFdjH7MFW+vQ2/BFGhhRrpdHzF9lYPs9qHmHmWV/rh/sxKM2U2kG2cHsmciUfhDL9WZKdpiI9OogOe87iselibzER9Z1pgzHB0ch5rJpxvAo4WJzI/akCXywIEJ/lzt5gLu2FbgpnxOEpEWdenflJWgJNAcJbEAJqGzLFOWKI
 BkQ19fxl
 bzyxh51715VDqvq+1BZRFqet3A29Uq4H1farJURFasid32/pvIzXZGrLqW/rd3tg1AEZcIpwUJNlQII1yA+f+arh5a23K/VRIdqytPiu38fqdrXgugLzpZfSL9aAtmL8vk5IXs5u+SiAOLAr8szbjQmOKZn2X78OFvnxtAdu/cxO4ykKVVSld73dYKfInX24CgSPsemOyNXrx57FkKEK8BkGSuQ3xN27KE1x653thOIR09mq/SYf2eXIeLwt/EHJOvsMtIX71K8axlIMeu8rEsEhGwKnt0xurkaWXxMWZq/4C8uFqb+bNeU8PQTeksih880MZnj84lUo45potipMlc2S9mySBWbxoXCOpUzU8XSAOuSzTHe4dAXXIXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 03:46:22AM +0000, Carlos Llamas wrote:
> Commit 4dfd4bba8578 ("selftests/mm/uffd: refactor non-composite global
> vars into struct") moved some of the operations previously implemented
> in uffd_setup_environment() earlier in the main test loop.
> 
> The calculation of nr_pages, which involves a division by page_size, now
> occurs before checking that default_huge_page_size() returns a non-zero
> This leads to a division-by-zero error on systems with !CONFIG_HUGETLB.
> 
> Fix this by relocating the non-zero page_size check before the nr_pages
> calculation, as it was originally implemented.
> 
> Cc: stable@vger.kernel.org
> Fixes: 4dfd4bba8578 ("selftests/mm/uffd: refactor non-composite global vars into struct")
> Signed-off-by: Carlos Llamas <cmllamas@google.com>

Agree with what David and Lorenzo said about cc:stable.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/mm/uffd-unit-tests.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> index 9e3be2ee7f1b..f917b4c4c943 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -1758,10 +1758,15 @@ int main(int argc, char *argv[])
>  			uffd_test_ops = mem_type->mem_ops;
>  			uffd_test_case_ops = test->test_case_ops;
>  
> -			if (mem_type->mem_flag & (MEM_HUGETLB_PRIVATE | MEM_HUGETLB))
> +			if (mem_type->mem_flag & (MEM_HUGETLB_PRIVATE | MEM_HUGETLB)) {
>  				gopts.page_size = default_huge_page_size();
> -			else
> +				if (gopts.page_size == 0) {
> +					uffd_test_skip("huge page size is 0, feature missing?");
> +					continue;
> +				}
> +			} else {
>  				gopts.page_size = psize();
> +			}
>  
>  			/* Ensure we have at least 2 pages */
>  			gopts.nr_pages = MAX(UFFD_TEST_MEM_SIZE, gopts.page_size * 2)
> @@ -1776,12 +1781,6 @@ int main(int argc, char *argv[])
>  				continue;
>  
>  			uffd_test_start("%s on %s", test->name, mem_type->name);
> -			if ((mem_type->mem_flag == MEM_HUGETLB ||
> -			    mem_type->mem_flag == MEM_HUGETLB_PRIVATE) &&
> -			    (default_huge_page_size() == 0)) {
> -				uffd_test_skip("huge page size is 0, feature missing?");
> -				continue;
> -			}
>  			if (!uffd_feature_supported(test)) {
>  				uffd_test_skip("feature missing");
>  				continue;
> -- 
> 2.51.2.1041.gc1ab5b90ca-goog
> 

-- 
Sincerely yours,
Mike.

