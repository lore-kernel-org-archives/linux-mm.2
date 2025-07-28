Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554F2C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 10:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9A5B6B009B; Mon, 28 Jul 2025 06:15:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B23E26B009C; Mon, 28 Jul 2025 06:15:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EBBB6B009D; Mon, 28 Jul 2025 06:15:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 894E46B009B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 06:15:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 446A1B7141
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:15:51 +0000 (UTC)
X-FDA: 83713267302.13.35CFC68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 84F128000D
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:15:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D9dy97NL;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753697749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmHVNWL8en7hrOviYJv9levJ+kD10Oya00GNVd+k4b0=;
	b=j88LfyRD+/kMM6CEobWeQ8OzOV3Ai5AycLDfaEYgJYR4HbECeMvSQlXf99RZbRnirBoTW9
	yIiedn+VFCmI3DLHEyiNfteCUy6hCmG5NiwlBuCA6Anqf4ZKQkJm2r+cWpn5ll/Mw5qFdQ
	GLwEm4tmJjYQlHY055MI1IHOfyf9MCc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753697749; a=rsa-sha256;
	cv=none;
	b=QWzF8jVD6fBCldakNlRFfsa64Q6JWwaA5BJtuv3BoQIWM/YxyLa3OzpgtHuZZW3mvRhcwW
	GLxRvrLYk+pt1YBr8PtmGDxp2Nl7LMYw5pR2HrXV4W//1WfFu1rRK33Num5HLZaubCxmdw
	bQjna5ibP2TP1FT7W0zNtv21NQl1WkQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D9dy97NL;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 80150601BB;
	Mon, 28 Jul 2025 10:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C482C4CEE7;
	Mon, 28 Jul 2025 10:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753697748;
	bh=slkf/CEUcS5BKPd4iT/cdxh3rsw6/TCS+iNm0nuYCWA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D9dy97NLzTbR9r+tVuMA5GsO2jrgJHwsh7giEqcd/Yh32HdUlqywypP0lKq4VY70K
	 dP11ec6+n6Y5aBw1Z3F44dKB5Ds3UV19fAbDLk8LgRMPvrv+Ye69CPdym0ZhoLZRy/
	 +0iBSCBAqszcXRcbusHDs+1PI1KQSGU7lIaONpTgXnqL5f07K9v/Trnr233h50ATFl
	 lkWi2oFUduKtQNNG+p2T8hCvoorjUvd0UeIm3oDZAVabmVWhaUmkVPMIDzQhMhhGfo
	 SYbOj5Y/GCxzCVOMfR+sciBN9ysrdJCHXEiA7HDwrpGbdZ7vkhknVOHs0PACAFM5W/
	 OC69K+1Rmyuag==
Date: Mon, 28 Jul 2025 13:15:23 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	changyuanl@google.com, dmatlack@google.com, rientjes@google.com,
	corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com
Subject: Re: [PATCH v2 03/32] kho: warn if KHO is disabled due to an error
Message-ID: <aIdNu7wwsbnVGbAN@kernel.org>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
 <20250723144649.1696299-4-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723144649.1696299-4-pasha.tatashin@soleen.com>
X-Rspamd-Queue-Id: 84F128000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: i8taqq53ubmyetzrz3bsjp1uzpaqok36
X-HE-Tag: 1753697749-862982
X-HE-Meta: U2FsdGVkX1811/NF0QMJ6x3423unKr9URbQDuG/aD138twiU0e1Yaku3nfnefauw/Bk9+xsaw3RMwEpPpnjzsDCEnkY/Rd4wgdJ+ObJqA1wXOYdnjWvJ+EbeUEo/Nt2AeKmtP+fG2YUgON32ZlU/PmfHcTaD/bfvQwt46QxkAae3pffianIggI2u75oB+JGyIfFIPS6RPX5nqrOw3veQRDz22Gi85cRNOMDUCAzZNLE/fM0y8d21J90oKGOi2Znh+JJu/r+xN5p4fTf1ak6kx4o1JtZbMOKAFh6aG9neXIkH20A7kA+mEtv9n4vqvbFNDBujD50QL3/JMxJpzO4BILuYQc0n4A9to2VQK+heU5T/Un3p0bsYxVaPOkHeIoxDKKzvU0qDdUGn+Fqxb9VuVZ4DAp8KtZIoSyb1vx8Roc+4MGp6My6A0CFgDRGQ6PsGlJBvmTTUAChEtOwl0rY/WLnE3JDRz+FjWI7vIfBRDgBW7FxMeXAjZ24FY9BdVGtf2mW0Hh20CC83nRflzkDLabilXbpYz063jaf2dTMqexXr7+kw5MKBcGJM2R5Zdkf/dYUtjPh7pw563TZlsvowaEbrLnrJ+Vl0j4CTncJzymn9tNkMk+f0rS2dipxjcwNpXDONNJl0M6sCrNPL+jkk/yhy71SUyDsK0TjLAfZu3pXNSR2odgLL8VnjIddd91VwcHnEyvItgqH/STc1XVOqBxmTEMBlLVvTVzccI8CsZv9BJ6Enwzq2SxSVi1gTeGc5ZhCa4MJFjGClr7CXajZRmOf0o+AYmQ8RBCL1RtwhS8B7+jfSJSdi0mAatWp5O7tylFgcsZPqFoYX3yqe5ctb6m/o6mvKy7qqg78I47LANq2qvlp7sGxZB14D0VGeeCKSweopu8cv8N5CnsJTp2OZrBWh89D0TI4IAbf0IUg3TKA2Z5TUPtcbd5wO20vubv+4IYLF2umBc1/XkhPv81n
 jLMXon/u
 gWNsQNwYM7OE/IRxIu6ncGcuybwB6//5h+DVSz6NpEV/Id5OJR0EgjWOAZ9zngcbD6KjUHQfNO2U9rYWo3C+l7P1oA/wcCa1mMhF/fFz9uZenrAdmFoKQEFTVxtJWuy/xif8f1NhgNQUy5Wp909b3bkJvwB1zf3cGQkbUEVdvcRYMK9Nmrpwz9Vr4oHIAd5wltCgfDTknKH+Qnaqpq/gsrBA13fAYJzidxVAKb5a9Es/ewPR1UTyElJqbOKMbIjCwPsgjft+CfPEMknz+384UNFZIbhnRWMX6EF/bzCAnymx/W5KVyYdObzdtrYvOqPwjs4m+vi4h/EP7M08zNBh2aF2Uqdm7HFBPr56GHh+srwzZ7VSvd01M8Rz+FVlj7PfoZFYw5Rrt6UYIhVBFFMn6ytPJkDtPiEOmikauJNAgdsJsQchdUtNvecJX3L5b+pxCfkW0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 02:46:16PM +0000, Pasha Tatashin wrote:
> During boot scratch area is allocated based on command line
> parameters or auto calculated. However, scratch area may fail
> to allocate, and in that case KHO is disabled. Currently,
> no warning is printed that KHO is disabled, which makes it
> confusing for the end user to figure out why KHO is not
> available. Add the missing warning message.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/kexec_handover.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index 1ff6b242f98c..368e23db0a17 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -565,6 +565,7 @@ static void __init kho_reserve_scratch(void)
>  err_free_scratch_desc:
>  	memblock_free(kho_scratch, kho_scratch_cnt * sizeof(*kho_scratch));
>  err_disable_kho:
> +	pr_warn("Failed to reserve scratch area, disabling kexec handover\n");
>  	kho_enable = false;
>  }
>  
> -- 
> 2.50.0.727.gbf7dc18ff4-goog
> 

-- 
Sincerely yours,
Mike.

