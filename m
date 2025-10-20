Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91C78CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 07:43:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8A138E000B; Mon, 20 Oct 2025 03:43:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E61BC8E0007; Mon, 20 Oct 2025 03:43:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9E578E000B; Mon, 20 Oct 2025 03:43:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C47968E0007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:43:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D59BBB049
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:43:49 +0000 (UTC)
X-FDA: 84017703378.09.DA1E2C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id EDCDD100009
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:43:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GD/xJmWM";
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760946228; a=rsa-sha256;
	cv=none;
	b=xQAdEOGIx8LLcj/Zha6ok1Gm97vCa8s7rleUC6e+t3YMW40I9ldSKesAfS+P4V1FzzodMs
	uYB9dWLTYd4HgyUR9Fs4P4wk8jRT0GMBxlq6Y/anRYZ+HyClpkL1LacoBGu+8JkV8a0YzC
	YNp6VCNlMgblobmn9b0wRUGmz5rPRNE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GD/xJmWM";
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760946228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUAXildvQf7xJtsEL0Hiq1JG3lYBilqJyD1R6PITsgs=;
	b=ry8f8v7TA0YGGrDkneW6z2MTemDoGs+MtQjYXN8N4jsSQYyGEl97cAmVnVwRQsP9bRcuUB
	BN9Cl98I/P1QviHs+tlyvcMh2IDmGUZsHP2AOw1k46kIyedEU9JJ95CaObfleoKZWD8Hmc
	W6/PH1mTpAopGNRc36Sovh1/qiJGB7I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BEE1541904;
	Mon, 20 Oct 2025 07:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CE9C4CEF9;
	Mon, 20 Oct 2025 07:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760946226;
	bh=BO5RsfQHWdqK/8/bY6nMyHmhnk8uSPRdfDihSgALoXM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GD/xJmWMNtkh88BpkeuZO9yKhhM9JSXE1JpFOPv1KpkAbGOpAqegh5/3YqEzdjD9U
	 lTDl/Wc/FLZlR7lIYuS/F9qHTmoOqCqlfyOz8E/7GPfVByVjvtdRqIoowyu/Hfp6Fg
	 JlaRoqtVIPTNEybkOLgRTXPQsrW1Vo/iyAE0LJx9BKj4adC4ynSIfSVa9zPrNBa/PP
	 Q0XnfmCuVfH7qcVTl6Y0ZA564yFmOYs7icu9Y2C2f9M4joMHOcHgl2aJ6rrRSyrVyB
	 FVUyJ3vkkEKu8OQPHvfKuu6JfyV/spsBiSFRe6yYeyXd7idtvn/0H69T9cKglcej1L
	 egDCQfHTw7v4g==
Date: Mon, 20 Oct 2025 10:43:37 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org, jasonmiu@google.com,
	dmatlack@google.com, skhawaja@google.com
Subject: Re: [PATCH v6 01/10] kho: allow to drive kho from within kernel
Message-ID: <aPXoKRVAyGWCNj8I@kernel.org>
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
 <20251018171756.1724191-2-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251018171756.1724191-2-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Stat-Signature: fhenc6xz1hs5b5okweuist1z81w7s914
X-Rspamd-Queue-Id: EDCDD100009
X-Rspamd-Server: rspam09
X-HE-Tag: 1760946227-88099
X-HE-Meta: U2FsdGVkX19yhl/yFcVK29TfTJgY5E+F8edwVXH3rmpTg/t8Q8K9SkvtdWRRxqEumcPho8MSQIicTDamiOEicRIGRse6haB4hyWG0p+n12TxwvpweSI9DOOmzuGXAm2xqSMmsHRYVaYwQ+4dG8C5Xj3/Ye6X/+GEq5Q011wZwKWag86/mOwu64jTtIcE0Mkl28I0464AR1cNRPGRHWjIqNi+m2GQw7jJLYG2CKBAN1ZRA9MC3EPBKDCS5l4rwtTp5WLUGXHJ7VfLrXDQOoxKmIDBjC9TMBlq6T1u7Ave6E1nrOmkevgsF6s2NZcd4nYAdHPITxx6Uy8EgmWsYYg7SjWca41K0jnlpqQGSEZ6KmuFvJzq6BwvIcTq+GvzeHidDtpVvXXcKX1G20W2Aeex8tt3qDHm5HPr7o+HPVhKSBrCx9PaaMXAx9Ea7vMv/JDNrdDvqwwGqEdkd4Nshw8PrCXESP+8DYNCz3xRpFRFyRvR+P/U2GfdBnKsx3scB+TelLMRcM9Ss4Gauwq1N9pyhUOtgsvQGX9+InVUZpJJqa5nmqjrE6/MInjEXbvTAnmaX2o5/UdnylFnalO40ytxDXgiBqj/CcYMdHIDBGDzVX6oUQ1KwRP8cllvGMZZsmTYpEl+l94td0YIj+ehSNZ0q5EnWDCqCqsDfiA6PT4x2XuS9DF5BUGTpnGFqIagSwDx2QsxLBAH4QLDhe2DOocESffxMlFeHgIyKm4fRtl3kIsrCPFRIsLBQHeVx7LdtHM5L+1Ce3Y5keTCGX6/oqG7BPxDbPqAwWpziqkJcVnp0u/QNmDt4cpdtk5ip/qmTIQ9ew7mWMpZeHBzieVGcVud/5oR7fFJM2lPmN18t4rukyrSZ5doKAHp0TFtQ30JPKXEP/Q7hdzRW5M/QPQdbjZisNy+SobUhUwLhBySLGPjZycqXaS2sLe8Cg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 18, 2025 at 01:17:47PM -0400, Pasha Tatashin wrote:
> Allow to do finalize and abort from kernel modules, so LUO could

We surely don't want modules being able to drive that. Maybe

   allow kernel to drive finalize and abort without requiring triggers
   from the userspace

> drive the KHO sequence via its own state machine.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> ---
>  include/linux/kexec_handover.h | 15 +++++++
>  kernel/kexec_handover.c        | 74 ++++++++++++++++++++--------------
>  2 files changed, 59 insertions(+), 30 deletions(-)

...

> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index 76f0940fb485..76c34ea923f0 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -1067,7 +1067,7 @@ static int kho_out_update_debugfs_fdt(void)
>  	return err;
>  }
>  
> -static int kho_abort(void)
> +static int __kho_abort(void)
>  {
>  	int err;
>  	unsigned long order;
> @@ -1100,7 +1100,27 @@ static int kho_abort(void)
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

Please include linux/cleanup.h explicitly

> +	if (!kho_out.finalized)
> +		return -ENOENT;
> +

...

> -unlock:
> -	mutex_unlock(&kho_out.lock);
> -	return ret;
> +	return (!!_val) ? kho_finalize() : kho_abort();

An 'if' would be cleared IMO:

	if (val)
		return kho_finalize();
	else
		return kho_abort();

and we can rename u64 _val to u64 val as we are dropping the boolean.

>  }

-- 
Sincerely yours,
Mike.

