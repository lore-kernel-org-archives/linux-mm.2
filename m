Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5A0FCF2567
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 07:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E2086B0029; Wed, 19 Nov 2025 02:13:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06B696B002D; Wed, 19 Nov 2025 02:13:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E75256B0098; Wed, 19 Nov 2025 02:13:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D2D366B0029
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:13:18 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F335788B0C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:13:15 +0000 (UTC)
X-FDA: 84126490350.15.E04FC8A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 719D840009
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:13:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BPA2nBzs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763536394; a=rsa-sha256;
	cv=none;
	b=8mflCu2FGiaA2eo+91Xcp7Lw6wdgr7Kilyyg76jDaie2kICrko1Y4OSIpJY0zUCH63Ns6S
	ePpgKlAD/vbiY+jaccTXqyckvd8X3WZBFiMaCt8D/+pWNiclaH3oiTNoWa+cXLIsu37Fl1
	9Fd63+aMDIlmxSbAUoXQwyA6r06Tbgw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BPA2nBzs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763536394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HwSoJupxiBjdrEJ3BFAF9vO8gdttxSiMNIuAwnCgjg=;
	b=0U7rRvC6KXWtsRBPB/5GLERkZI0JXNx+s1KppJU33/+pNRvzyz/qMd3Y54RVioR21FyffX
	VY3avo2ZVolRLy6I1sZuO3iMu9L8T9c1GX+iSW7n7DC69M23Ag1jjRffqx1Q8RDBahpANU
	4/hwpHGymM6sgVY+SXffqtFL8ni/Mp8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A500C601F1;
	Wed, 19 Nov 2025 07:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A60C19422;
	Wed, 19 Nov 2025 07:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763536393;
	bh=1k3b91TeAw0rzeU6aDRybMO0nK66XkCSomfBz/2p4/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BPA2nBzs0EQuHRPga+czJDN2TOO9kpazfniyGqFJxmNxnxfJwR5SurOBwHdtQQ2FK
	 3Tks6jG1OTjIr6lfWvlEuLWHouOCFg9iNUHUZa/MtonM+vzFTQHXZNoIBByrExM78l
	 c7SEeT7cR1y7KWxPyUkTtFDvVvidoqnV1msIC00pABA2sFbXyWXafa4UJtSsf/HETL
	 /jOhHTqJwYRyjeCHILkKsFf0gdocpw+Yk8EVZVYU8Jd0AkAZ2vse757aGXnjmVnl+I
	 pG3ErNtARklGA27Ecgy9jNDA804XkfgHGjKSZabTXxlGN+mapPEeMIC7bEkv8KOk7D
	 8NjBVLxskNdMg==
Date: Wed, 19 Nov 2025 09:13:05 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] test_kho: always print restore status
Message-ID: <aR1uASSp6VWY72kN@kernel.org>
References: <20251118181046.23321-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118181046.23321-1-pratyush@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 719D840009
X-Stat-Signature: mwz1gjmdhc7g3iuswdjdxn7n331aht6r
X-HE-Tag: 1763536394-615143
X-HE-Meta: U2FsdGVkX18FFMaLwn70aw0nASBltMr710mOm8RBPCmWXGXS9y4pd48LC1S/6vs0rQXD9w8B8Q6tFjAZFw1h0P4a0xGjHbODzEDYQEj3hSFoB6jrhORYOX2KyNwKxPpL4PtBzetAhRESzde1kgz7LfB0O18a+C67Rju1NLZQ79zL3QufRaXpX5kifok5n/Yh3bhEZ8g65EbBF6XJzSL04djt6c3kiVf+ygjmF/8c0CHngVQmUQ2gFhSCa/c29tS7i7cMX0vX4Rqa/PgRVeHRu34/0nsAz0ZC4FVh/WfStLXhxR0m4sKVYHIMjBc41165a2Oq7wP521J5GnsKO3UAdEiIt0ZRfaNzcQzz2fHF38YiOzUyAljPehA1Ix5SIrT6mO0e8ztaj9e+ZizBuBQFzz9niROQKx30t4WP1/BTwYOz3nmEernSicqLDOZJhjahmzEmGuPMKap/+w/RpcfnSTAAtW5J/pnsIrmVJIx9ilaPFeAAp+lrd3iF8gpTzfZ8QeQ4RHCLGH7i1E3r36KPdxXEhp8tRvJx52fGfvsOTESvoe1Wd7K9YCGEFHe0b70PUZ1mK6rdeLPguOZtO0XtN3g6mxGqhgHAwgD1b2miv7FGF9T2kd399ZR142XUWpeYOk2/3WSANolNVibyI6Pj3PjyJijSva7omMSrhmHyt6RLuLwjxRAqtc5Bu5zuyX6PLFSeV9ECkrVHVTSckrye9Y2d9ifr7g72fRGTt8ufMGS5N0+ULXLe2sHpJUfejHI6RLDXOIM+hFalkVWzZEbV3KQu2xQJT865bh3HQujCi71L6m0Q6t3v5CFpGj6ebyuJbUVo1DRnoqBRa0doL1FeX9/WaMK3i9FsYwSQG4eHSlwMwny4tn7UsRlM9iXzjeHblGqtqCq57JEwVTq2DHHN1Heyi5jPnPq4fRLNdtKvbhfxSXTZ7BaxqSVUSzSqUt4scZYMBwbf8fzy/ekS6EG
 9cV+sB4v
 crjqlbpYnUHYQs0qDWmU742tJ/umigpEWHh0CQSTM56fDEe/EPp5yG0n9K1PkgwZnviEHiAgPla9Wlkv71aKvM7uWNF+7QWIvU62YMaajo0PE/shOx8lyg1bv6URaDBeusvB3GctLhVWvL7LIFzl33gXPw54A5o+fMp1psN2dRHc1Y1R1VoJDLj3MeIHmFOOZGcSuynt5W2rDPEaiYt002VsTDmSMHWUt5J92yro5xwrpM5o9lY8EzcBTYBn3DURVEmKGwha+cOFAootJT2QcYRg1i5MH7q//3GBm4Cj9gOHZlWZ6/AgPqnI+1MPW+qPgeOD1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 07:10:45PM +0100, Pratyush Yadav wrote:
> Currently the KHO test only prints a message on success, and remains
> silent on failure. This makes it difficult to notice a failing test. A
> failing test is usually more interesting than a successful one.
> 
> Always print the test status after attempting restore.
> 
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  lib/test_kho.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/test_kho.c b/lib/test_kho.c
> index 85b60d87a50ad..47de562807955 100644
> --- a/lib/test_kho.c
> +++ b/lib/test_kho.c
> @@ -306,7 +306,6 @@ static int kho_test_restore(phys_addr_t fdt_phys)
>  	if (err)
>  		return err;
>  
> -	pr_info("KHO restore succeeded\n");
>  	return 0;
>  }
>  
> @@ -319,8 +318,15 @@ static int __init kho_test_init(void)
>  		return 0;
>  
>  	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys);
> -	if (!err)
> -		return kho_test_restore(fdt_phys);
> +	if (!err) {
> +		err = kho_test_restore(fdt_phys);
> +		if (err)
> +			pr_err("KHO restore failed\n");
> +		else
> +			pr_info("KHO restore succeeded\n");
> +
> +		return err;
> +	}
>  
>  	if (err != -ENOENT) {
>  		pr_warn("failed to retrieve %s FDT: %d\n", KHO_TEST_FDT, err);
> 
> base-commit: f0bfdc2b69f5c600b88ee484c01b213712c63d94
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

