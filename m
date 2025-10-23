Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36D15CCF9E0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 07:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BE0D8E0009; Thu, 23 Oct 2025 03:14:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695398E0002; Thu, 23 Oct 2025 03:14:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2008E0009; Thu, 23 Oct 2025 03:14:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 484478E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:14:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AFAC55C336
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:14:00 +0000 (UTC)
X-FDA: 84028514640.25.D6A84E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2377E140007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:13:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OODg5w6E;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761203639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=liZBE+jq2bIDFokfeq3Cv57vjgsPhqKmbYOJ1XMUPpg=;
	b=rr7jzVosk/YlOmpuXE+X6O4DNc5mZSAKN7dG2e7R0nZpZC1ErH+aN2DJd0eEgVjcSVSaPD
	JxDXV0tj0V/2+LgH+MT1HSmjW0Cg5J3/1MFuQZR69OEWC5Nq/oxv1LOlbgYJKaxoTQjYzV
	Nd56AdLswVttjmSx2UggHrADCk3ACak=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OODg5w6E;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761203639; a=rsa-sha256;
	cv=none;
	b=vr9PYAstkq3b5XEQgYWwBEorlf+aeRfHI4lR+js5oDvGn5mknfEZrFwdt9k4awmHaU7gJr
	pko061B0/hH9HpYmZapSQdpEaI7x9wUUCyuUcBfdRoG5X557eJTauvWwLog3dXFCw4sbF1
	gsyf4KLFEq7LBzXbxFKWB6uTnYpHl8w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C9DB605F3;
	Thu, 23 Oct 2025 07:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24502C4CEE7;
	Thu, 23 Oct 2025 07:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761203637;
	bh=2Z6faUlpxxg8NJ99mOXDv3nxN6IIqbuwazngqBJ2agg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OODg5w6EFB/hjsGbHVp2Vq9m7F+hBZgNtIuU5LNZe2mYTpdNyCVCbIXUA3Vdvyk52
	 ErhoZo9K7Z89GKXdanMvWKrAWUrbXY67tNn6zxtWL+7BzQSgaPo52fDLmUpan2VWdD
	 rE2qNVF+7AsYdvGZDRWtc/a8+uxAsg54+3aw866XKzV9gBQuY2ujGksVFsgziH3ktL
	 opVRerWZOfIvj8VhNQRP2iKDKInrAtXVwvVYm96tdy08q1RKVcXFwAqP524kuC2LgX
	 DtWdWbTC1YhHlmVgdTf6JFxr4NPdwQYSVh2DnnrfeRw81pRGpc9vwOUINW3WpTOZVf
	 BlAC0rtfGtWXA==
Date: Thu, 23 Oct 2025 10:13:49 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org
Subject: Re: [PATCHv7 1/7] kho: allow to drive kho from within kernel
Message-ID: <aPnVrZC4Fz273lLn@kernel.org>
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
 <20251022005719.3670224-2-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022005719.3670224-2-pasha.tatashin@soleen.com>
X-Stat-Signature: e3z9xeo8ip7haar6w6wquwoachampkcm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2377E140007
X-HE-Tag: 1761203638-628561
X-HE-Meta: U2FsdGVkX1+jI853Ru5olMNQ6hgL0hDHC/vHeuQ83GGdD+aWFylqlKLhrIQhtTQwBTJBl1bynDDEYVMmEk8oBq1bj37mBhmSYk6SWadLXOYDsEFVhTXvjLJEc4goL1pNOaGF6xLpZb3z0VF70QDyL0kvR8FXDOWWGEHRn1BelV5eLdvmTHLgdV4FihTUUnsmx5wT8J2XCZAK11ysb06n0OzvpbSqet8Bv5a2hasP4OQKL8kwZK+Kozczaekib8GxnE8NuG1dJlOzIFfWDDtLC3lqm/kqkLcvDWvmjQfyDja/h7ZYii8MMWutoD01tKKF/q0Is/l/OpIc0/8kN8ItmXObGnMPrIRfE+1a18BXfphNkjUWxS+KrIBIUWHx3/O723GyXy8qkdDlo1EFeyaVXc6PEZzcnY/PhNR5nb7rwSoE251i0EMeUrSkBfh8SkUU1smRFj9sXryly8UX5dynWmNvjfTC8ZPPcWD6EHOn8AL072w+xijRssFWGqeF3zNZibM7EvmwOsUHF591EvjgAFfJQhvpkdTQUk5gtGAGjGYEpQsMYcnc7eVXcDz7udBvoAJ3ByKtNaup/Y9K7M3BLQaL9tlqDXiRK54M7KTbgWPn6VZWNf1wlGS8yB3a4brCdyWJVuBlHhxsUR0eSmD3uuMqcW2r8Q+oG+qSGH1w7Dr+JwrnLfTJlNQjnq+ZL2DscnmXrw+ASoF5KMu15lX1p/5p54+vPv5yQrqjKWENKuzv+xtT7nELms129YXEkRLA+AVl6Q8xlcDoE/x3hW60YGTj0si1uV+XGZ0EFgyQ1Hc0KDcU41dACEWewoa5q2CtkzyITxVBgse+isaQyWXg8N+9J31dNgXllCNdBMFo+2bD/N6jMVu3qflXBydEmsTDC3YEUTdga3QjFzWYWaRgEhOWs6iH1p9atX9Cv42F0OfWLx0eBca5Z6vDCKZV0szmbcQdgz7wiUq9aXP6F73
 MiI+OaM9
 Quv64FRA4PhD+NCdFFDVdgLnkbtBB+seWnesqvv8UZiZCOyhWAtcHZ+hTF29zTgjjMotAZb9TJV0pG3qM1jewCHTg7Y8N29xlHTiVilinNFDN87oo/bXZiVewE8cPZ2acyXOmXQ4/eochFUScWGIfi+nnxx7sp0My281Wv/QzSJVz3r5UOgk6U0jt+PaeotyoaGOdXX+s2fetuSY6ZeL4tv89tUMiiuWllW/Sr4B0nJ+Q3IVWy05eIMvnwK0FaXuH57025g+9iZIrxYOiHvsIR2ES5T+flyqk3bnsBBZittGBQd+pILia3BZDwjeTfoNxp2M1ZolGjl94s96WA8f/CHCYD7IvAEHrwvNlTaDSy0NlsTnyLAcT5MrJaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 08:57:13PM -0400, Pasha Tatashin wrote:
> Allow kernel to drive finalize and abort without requiring triggers
> from the userspace.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/kexec_handover.h | 15 +++++++
>  kernel/kexec_handover.c        | 75 +++++++++++++++++++++-------------
>  2 files changed, 61 insertions(+), 29 deletions(-)
> 
> diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
> index 25042c1d8d54..04d0108db98e 100644
> --- a/include/linux/kexec_handover.h
> +++ b/include/linux/kexec_handover.h
> @@ -67,6 +67,10 @@ void kho_memory_init(void);
>  
>  void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
>  		  u64 scratch_len);
> +
> +int kho_finalize(void);
> +int kho_abort(void);
> +
>  #else
>  static inline bool kho_is_enabled(void)
>  {
> @@ -139,6 +143,17 @@ static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  				phys_addr_t scratch_phys, u64 scratch_len)
>  {
>  }
> +
> +static inline int kho_finalize(void)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline int kho_abort(void)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  #endif /* CONFIG_KEXEC_HANDOVER */
>  
>  #endif /* LINUX_KEXEC_HANDOVER_H */
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index de4466b47455..6458f369a346 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -1087,7 +1087,7 @@ static int kho_out_update_debugfs_fdt(void)
>  	return err;
>  }
>  
> -static int kho_abort(void)
> +static int __kho_abort(void)
>  {
>  	int err;
>  	unsigned long order;
> @@ -1120,7 +1120,27 @@ static int kho_abort(void)
>  	return err;
>  }
>  
> -static int kho_finalize(void)
> +int kho_abort(void)
> +{
> +	int ret = 0;
> +
> +	if (!kho_enable)
> +		return -EOPNOTSUPP;
> +
> +	guard(mutex)(&kho_out.lock);
> +	if (!kho_out.finalized)
> +		return -ENOENT;
> +
> +	ret = __kho_abort();
> +	if (ret)
> +		return ret;
> +
> +	kho_out.finalized = false;
> +
> +	return kho_out_update_debugfs_fdt();
> +}
> +
> +static int __kho_finalize(void)
>  {
>  	int err = 0;
>  	u64 *preserved_mem_map;
> @@ -1163,12 +1183,32 @@ static int kho_finalize(void)
>  abort:
>  	if (err) {
>  		pr_err("Failed to convert KHO state tree: %d\n", err);
> -		kho_abort();
> +		__kho_abort();
>  	}
>  
>  	return err;
>  }
>  
> +int kho_finalize(void)
> +{
> +	int ret;
> +
> +	if (!kho_enable)
> +		return -EOPNOTSUPP;
> +
> +	guard(mutex)(&kho_out.lock);
> +	if (kho_out.finalized)
> +		return -EEXIST;
> +
> +	ret = __kho_finalize();
> +	if (ret)
> +		return ret;
> +
> +	kho_out.finalized = true;
> +
> +	return kho_out_update_debugfs_fdt();
> +}
> +
>  static int kho_out_finalize_get(void *data, u64 *val)
>  {
>  	mutex_lock(&kho_out.lock);
> @@ -1178,35 +1218,12 @@ static int kho_out_finalize_get(void *data, u64 *val)
>  	return 0;
>  }
>  
> -static int kho_out_finalize_set(void *data, u64 _val)
> +static int kho_out_finalize_set(void *data, u64 val)
>  {
> -	int ret = 0;
> -	bool val = !!_val;
> -
> -	mutex_lock(&kho_out.lock);
> -
> -	if (val == kho_out.finalized) {
> -		if (kho_out.finalized)
> -			ret = -EEXIST;
> -		else
> -			ret = -ENOENT;
> -		goto unlock;
> -	}
> -
>  	if (val)
> -		ret = kho_finalize();
> +		return kho_finalize();
>  	else
> -		ret = kho_abort();
> -
> -	if (ret)
> -		goto unlock;
> -
> -	kho_out.finalized = val;
> -	ret = kho_out_update_debugfs_fdt();
> -
> -unlock:
> -	mutex_unlock(&kho_out.lock);
> -	return ret;
> +		return kho_abort();
>  }
>  
>  DEFINE_DEBUGFS_ATTRIBUTE(fops_kho_out_finalize, kho_out_finalize_get,
> -- 
> 2.51.0.915.g61a8936c21-goog
> 

-- 
Sincerely yours,
Mike.

