Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73A4BCD4F4A
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 17:20:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DE096B0005; Sun, 17 May 2026 13:20:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5B46B0088; Sun, 17 May 2026 13:20:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CBC66B008C; Sun, 17 May 2026 13:20:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9AE6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:20:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C27DFC2039
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:20:26 +0000 (UTC)
X-FDA: 84777575652.02.97BD53A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 26D424000D
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:20:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WJo6cs3/";
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779038425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5YKrhK2FI6dV50p/NFGLmiNvDsShZX47WPcABrCLFYw=;
	b=hwFqdblh1BeV1DEEwHuCE18vSSyOWfEfqYWBOUUleC0lYPT/gKemm2u5Clqfqqo4pOrNCO
	HXE1/tiMApmcH3/RqHVA6Lq9hYFDie5CINmlCHaBEFtgZHJ0FDEdtNck53bt9UoKDiTIcc
	0JmD2fUBZcaFIPHLN5dJSKtdAKHbhBs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779038425; a=rsa-sha256;
	cv=none;
	b=KejIRyPBiGypJfQolUGxPl0JL4BieZbx5xdu395eTF0o20mQh7rKq16cjYWqiE4A4DuFdL
	i1Hf0kSx5+ytnaIia4ST6/k7Uw5eXAekHX/E3O659hF1RcVqR/VBXtQjHrtIClXyjehJRw
	DXS1b61KcRu7ZyFGYPUKj+5CYJU6KUQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WJo6cs3/";
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6824E60125;
	Sun, 17 May 2026 17:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6DFC2BCB0;
	Sun, 17 May 2026 17:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779038424;
	bh=9zAiXASte9+QF5zhIHe0oi7WTzSBFGj/YZujYlv9iI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WJo6cs3/G+d+DgzP07h7g/GxQyDv87IyuonHXZQobWN/j+tdQjATiXjrmQtCjzsC9
	 NyBqn4HoFfUKWA6G8ZeRsTgw0uNeD3P1bLtTkpoHKIXocS8K295tlVHrk0shwjaiww
	 E1Ryg4TlvJy1o+Sg1bviynvbvOz1pAH5WbvfqyaYL4x2pDgl5V2Ka3ZTxMP5qeiRkH
	 +FFtryp8VYsi1ITV9ECyMeyCxnh9kENVXjLk+ywamUugvuNeJ1tod0nGMQ3T/ewY74
	 uE7ytb7QgSMfZYWgUVeGGQImxzxIuvz8ifr6Q39qWN0qRV79BZKws5x+BMd1SNnkn2
	 DvkXBnt3QMezA==
Date: Sun, 17 May 2026 20:20:15 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com,
	kexec@lists.infradead.org, pratyush@kernel.org, skhawaja@google.com,
	graf@amazon.com
Subject: Re: [PATCH v2 01/10] liveupdate: centralize state management into
 struct luo_ser
Message-ID: <agn4z5ZrFBi9AIGw@kernel.org>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
 <20260514222628.931312-2-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514222628.931312-2-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 26D424000D
X-Rspam-User: 
X-Stat-Signature: ge8dkg3gpigi3hyf5dpwt93p1pa89i8b
X-HE-Tag: 1779038425-105357
X-HE-Meta: U2FsdGVkX18JTMYWKv7PuAnj9pqQ6l267wBAfMDJ1ZvAybgZDikyzujXSazWhjQt9MDHCxJKHoe2GcMQI9eYo/7kNrlO89f1q+oQLCHdyCcLuD5XezPXg8/X03qkdmbK605sezgUAk7/33loYCKXJfhEvb71URFbl8JEylGQQp4Zm7w3K9wHD61ZZr2H6owYmxtJOG72giKxEGE3adFjOPIl0c+2veFMs40neZXIt4/iRegmprI67mkJvsPPay1hizO3Cpzie6FtsmrV/u2Vd379L+RxJkKJnJgTER/fbv3iFJTnZd8NGMoZ53xWu44Qh2M161fg65ldCuAHQ0AE+InljeZHGQGKurH5rUlutNv4UuWlfIlahdJDqDPvs7K8RXWGQEBjDbkm6KIvEHVoxLGj8v42pAjFRo4Y2ioxlQtAJeVJ3L9pnNuvvt+s1UV9tpy3sgQ4C9hssd419DpRDpfXpeN5rtnWcaRoxWKW8ztTHwOvXZwbkN2sekUdgbLH/v3jZa0KcteDy4dQgVPdCBZoz7GArMEvYbNFEGgdanYb90j47Fdy1u5HZ91Bk8reGm3RPe7NxLpc342w9wO0Eq5n6r3xJE3BedSYswLt4Bx3EMldGuzsDF0J3tm53aCR7p39AQgx0wV8gg7xfFAp8BM15JZEYxRXRSfoCwkVgMLgINLNDdQ2yzB3Topo8JTJZ/KI3mQBWjf0vosLW4Nd2Nu/OwnT3TMh//HWxacKjPNE8vVg4LJkJSldyhId4LpbRT5aL1uTi2dEIMFXpYarP6AV36rAYEsDhefu9LIRdFFztrnC9ooV2dGSUv0rJzU+r5vPxT+2qnkZ9//y/1OpMxwUWBJtFs9bHaagCGjAXN03i7gtdzlOxapVN8NWVFE4hf4LHw8sfjvuu7pExAoy6p+rCMWrybbBvL0yjjCxzh/05ruXd9Ns23DC16lZRJxfCZ1ZyLh85M1xVeqBf3q
 IJd9zV+2
 Cu5OihjfBDH9e2GhvtxlU1k+BqJSiW96d7rt5j42Vs8DVuPwna8xT5spDi0hpzXWKWa0MhHg9eaK52H/zQMIatK01lbPxilDqOb8B1Lebk9X3egpVNxSXsiGMKId6gTDQ9ZXn7XjVrcUzStzieehCoz8LiQB2Czzm47cy6zeTjYRWRIEaJ0ZCarcU0w6kGCP7Z/0e2PduQC69gxbiQMfn2KOGQ04Y5gP1oWmiWiu3DkUyk7AQMgKsD69cjZA6PPzy/K/zr0sjdr9mkBI8gLtPIXaNvAqG7kpU7wdvZFljhUqFt+FSP+KQDtw+BLefflkyiOJkrAwkbm3dRj8dq6HLlH5g2BXRSFlRKf36NRedj5H86jfm45lwES+9hxioSStlaALr+RPYAFEv77E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 10:26:19PM +0000, Pasha Tatashin wrote:
> Transition the LUO to ABI v2, which centralizes state management into a
> single struct luo_ser header.
> 
> Previously, LUO state was spread across multiple FDT properties and
> subnodes. ABI v2 simplifies this by placing all core state, including
> the liveupdate number and physical addresses for sessions and FLB
> headers into a centralized struct luo_ser.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/kho/abi/luo.h      | 91 +++++++++++---------------------
>  kernel/liveupdate/luo_core.c     | 59 ++++++++++++++-------
>  kernel/liveupdate/luo_flb.c      | 65 ++++-------------------
>  kernel/liveupdate/luo_internal.h |  8 +--
>  kernel/liveupdate/luo_session.c  | 57 +++-----------------
>  5 files changed, 93 insertions(+), 187 deletions(-)

This looks lovely :)

> @@ -115,27 +117,29 @@ static int __init luo_early_startup(void)
>  		return -EINVAL;
>  	}
>  
> -	ln_size = 0;
> -	ptr = fdt_getprop(luo_global.fdt_in, 0, LUO_FDT_LIVEUPDATE_NUM,
> -			  &ln_size);
> -	if (!ptr || ln_size != sizeof(luo_global.liveupdate_num)) {
> -		pr_err("Unable to get live update number '%s' [%d]\n",
> -		       LUO_FDT_LIVEUPDATE_NUM, ln_size);
> +	header_size = 0;
> +	ptr = fdt_getprop(luo_global.fdt_in, 0, LUO_FDT_ABI_HEADER, &header_size);
> +	if (!ptr || header_size != sizeof(u64)) {
> +		pr_err("Unable to get ABI header '%s' [%d]\n",
> +		       LUO_FDT_ABI_HEADER, header_size);
>  
>  		return -EINVAL;
>  	}
>  
> -	luo_global.liveupdate_num = get_unaligned((u64 *)ptr);
> +	luo_ser_pa = get_unaligned((u64 *)ptr);
> +	luo_ser = phys_to_virt(luo_ser_pa);
> +
> +	luo_global.liveupdate_num = luo_ser->liveupdate_num;
>  	pr_info("Retrieved live update data, liveupdate number: %lld\n",
>  		luo_global.liveupdate_num);
>  
> -	err = luo_session_setup_incoming(luo_global.fdt_in);
> +	err = luo_session_setup_incoming(luo_ser->sessions_pa);
>  	if (err)
>  		return err;
>  
> -	err = luo_flb_setup_incoming(luo_global.fdt_in);
> +	luo_flb_setup_incoming(luo_ser->flbs_pa);

Sashiko asks: 

  Is there a leak of the preserved luo_ser memory here?

  The outgoing kernel allocates the header using kho_alloc_preserve(), but
  luo_early_startup() returns without calling kho_restore_free() on the
  luo_ser pointer once the fields have been processed. This results in an
  unreleased memory reservation on every successful live update.

This seems preexisting, and we probably don't care enough, but still...

There were more comments by sashiko, didn't check them yet.
  
> -	return err;
> +	return 0;
>  }
>  
>  static int __init liveupdate_early_init(void)
> @@ -156,7 +160,8 @@ early_initcall(liveupdate_early_init);
>  /* Called during boot to create outgoing LUO fdt tree */
>  static int __init luo_fdt_setup(void)
>  {
> -	const u64 ln = luo_global.liveupdate_num + 1;
> +	struct luo_ser *luo_ser;
> +	u64 luo_ser_pa;
>  	void *fdt_out;
>  	int err;
>  
> @@ -166,27 +171,45 @@ static int __init luo_fdt_setup(void)
>  		return PTR_ERR(fdt_out);
>  	}
>  
> +	luo_ser = kho_alloc_preserve(sizeof(*luo_ser));
> +	if (IS_ERR(luo_ser)) {
> +		err = PTR_ERR(luo_ser);
> +		goto exit_free_fdt;
> +	}
> +	luo_ser_pa = virt_to_phys(luo_ser);
> +
>  	err = fdt_create(fdt_out, LUO_FDT_SIZE);
>  	err |= fdt_finish_reservemap(fdt_out);
>  	err |= fdt_begin_node(fdt_out, "");
>  	err |= fdt_property_string(fdt_out, "compatible", LUO_FDT_COMPATIBLE);
> -	err |= fdt_property(fdt_out, LUO_FDT_LIVEUPDATE_NUM, &ln, sizeof(ln));
> -	err |= luo_session_setup_outgoing(fdt_out);
> -	err |= luo_flb_setup_outgoing(fdt_out);
> +	err |= fdt_property(fdt_out, LUO_FDT_ABI_HEADER, &luo_ser_pa,
> +			    sizeof(luo_ser_pa));
>  	err |= fdt_end_node(fdt_out);
>  	err |= fdt_finish(fdt_out);
>  	if (err)
> -		goto exit_free;
> +		goto exit_free_luo_ser;
> +
> +	err = luo_session_setup_outgoing(&luo_ser->sessions_pa);
> +	if (err)
> +		goto exit_free_luo_ser;
> +
> +	err = luo_flb_setup_outgoing(&luo_ser->flbs_pa);
> +	if (err)
> +		goto exit_free_luo_ser;
> +
> +	luo_ser->liveupdate_num = luo_global.liveupdate_num + 1;
>  
>  	err = kho_add_subtree(LUO_FDT_KHO_ENTRY_NAME, fdt_out,
>  			      fdt_totalsize(fdt_out));
>  	if (err)
> -		goto exit_free;
> +		goto exit_free_luo_ser;

And here we also seem to leak memory allocated by sesttion/flb setup.

>  	luo_global.fdt_out = fdt_out;
>  
>  	return 0;
>  
> -exit_free:
> +exit_free_luo_ser:
> +	kho_unpreserve_free(luo_ser);
> +exit_free_fdt:
>  	kho_unpreserve_free(fdt_out);
>  	pr_err("failed to prepare LUO FDT: %d\n", err);

-- 
Sincerely yours,
Mike.

