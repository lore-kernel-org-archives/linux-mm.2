Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59539D3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 06:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1E3B6B0088; Mon, 29 Dec 2025 01:58:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEC0A6B008C; Mon, 29 Dec 2025 01:58:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0CA56B0092; Mon, 29 Dec 2025 01:58:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A11E56B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 01:58:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 390B05A18D
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:58:28 +0000 (UTC)
X-FDA: 84271605096.20.9562009
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id A45E04000B
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:58:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bHt4chWY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766991506; a=rsa-sha256;
	cv=none;
	b=xuyNN2wSjE0nOPHTr8Uez7BC9C2sjM/iQPNZ64O5GAk6ot+uPDG2PWDR+gP8W3XT2Vcy56
	g9zNgJiKeh7m4YAIBzcu4897bNzBgGbLUuxu6ZN0L4KpQU34H54ExM2J7Cbo8nz7rFPssN
	IilF9VnVBBqocknZ5i+zqus5p0y65H0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bHt4chWY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766991506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYvkrAfTaF1Jiwc0dg+DZgautcB/4SFAZsgdQU0iGls=;
	b=0fRVKoCYXF3C5QvvFLevwnT/8EH0mIXPDIl2+YE4maChfVPbldaBeXGbcKl/am4MuyoPlc
	09xn4exh5BKgCEyTpRMYB8J3qVdRKGiZ88FkZ3AQfd22mcOe1TsAKmU2F6UWWSCObyQ+qy
	v9VQITYvEHOT+nuSIgyBm9SNcaMcUPw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 256A06000A;
	Mon, 29 Dec 2025 06:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CE1C4CEF7;
	Mon, 29 Dec 2025 06:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766991505;
	bh=V2y2PsL6+tNWebVwd0+KwFFsHyM19wzJl+pDNwf+sLo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bHt4chWYSuLuDbLrlpROYCd7Q5YXDLbWsfAff8CsrYD04k+l/DTp/2dZtSHvQWqno
	 Uv5A0PAEYWXIBVNK12KAE+tDmuz8dJWgD2fSfp8E+h5lbShxW7rzd0p1nBC55JzQr6
	 H1J0nH3v1nzqVtEKjuZo/DRD8Z1dBI7bank52DAHxQsGMaiJjkeirY+zSVUQDHe8f5
	 I5TbcjUhTz054W0VQeJG+KxBrB+7o4bbom0NsfxtyhwDUA6+N4J9T7lR2nuobKBKWt
	 5JZKi+hSeF+id57btnngVjqW5FuY5oi2sSB2Ro1A/cKqN/uxnV1tLUBaDqFrQ/Yod7
	 j0PAqpdFf/nHw==
Date: Mon, 29 Dec 2025 08:58:14 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Eugen Hristev <eugen.hristev@linaro.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
	pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net,
	david@redhat.com, mhocko@suse.com, tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com, linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, jonechou@google.com,
	rostedt@goodmis.org, linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org
Subject: Re: [PATCH 19/26] mm/numa: Register information into meminspect
Message-ID: <aVImhhgEsHInebeh@kernel.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <20251119154427.1033475-20-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119154427.1033475-20-eugen.hristev@linaro.org>
X-Rspamd-Queue-Id: A45E04000B
X-Rspamd-Server: rspam03
X-Stat-Signature: b6xdykx9a9wnrg1x45oy688fq9hmzkck
X-Rspam-User: 
X-HE-Tag: 1766991506-478285
X-HE-Meta: U2FsdGVkX1/Pn7Ta0wFIO5EZj7mxGi0xiOp/hm5IjqKIbSVIM8Twp4xnS6AXPW5bWV31PROrPw5a8D3K4eMsO2YqpXsvIFn04JqYDm7JNXdwoxwvGe7Jhh4nppCgMYCqeFo8BruKL8uBwlsP6q8w9aYDLy57x22ReovBmR6M4+rNaLF6fj5reN+TpCOBVo11kZF1lO33SgkhOqzhEeZAcOWnNrXo0H7SueOQwpYNEBU8Tp9hdouOgg03evUCuwiqYAuCUTGS7uI2V2i/ABcI1XOmjLuIQL9TeGFUX7wzPQUj9i6YVB7a8ExotuPGIKs3AsDfomvda5GCqEdzsur8RNw5482ue1JaJIIgnW3iDACLJj8sRQ/VhDyyaMEl7oQim57mLRsEk4pnXEHfhREweaTAqnyjZXmIIL4sgNzINJXN8HBT56YOIC876hsP85Cxp9mWr/ZRAlUXvZovp3aX+wgdY70KnWw4GR1j7eUK3vOVDmpcRg0FfPpzU5Zah3PCiXYKqrIJ2rJEAXA8If6/KYJjOATGJfoGXzbYuS6jmgXbAyelPpQgP9cOXPrhDhVFHZphqmGgD9UKxvNhCbZ2VTmyY+/wkCaFhS5e7pxPSv+84ibPpnlVVqBFIqOAVnFrYGgeF1hEIJR3+P3fEcbnWjCFe8Xs24whJ7Kr4NQm+J+RNkh44/w4ZX6grafksqWtoJjT3WcgedHOp+h829XDsjHMXIiAXcH8Cam2pmWb5J2wuwRRGx5JucReP229Z22ZVyOjaz18+Rl0LhupECgfai39eO/R1w3B/n6CgXk+6EAMTMQ/ClzWZVDUfkHnrP/Mk0rEh8Az2bBRuoHjS1h9460hB/oPfdHEFGMiuGeG7qCLaU2yVsulZt3a2nqNTGnif6tzfdY81c5dDmQLPe42ppLeGP8d9qNnAY4hbhcyQidv7qrymDYtXmFajc2FSX1iJfCUcI+1HMb8JNO11or
 2hFx6z9D
 pALO4ixESocvKsN9g5Qylb+/+LtKuUXUNsAQt9Hd+TpskA9b9XOTk0mJVmALSiQ6BVqgySF8dz4F3nlEy771KBsOp10rxJA73KAfhxWsve9MD3pqYZ3AhRNu0WKvkxnz3upMv/I+HhEpVYsYs0/JceAYhwrgKAsWnneDmeumJlikTgHxe1Nh4YFIJs2Hij+CSJLf5tVKOdqNuKwnUNDTgnMLlBhsIHlQNwGjFYYUxngM4HmfpW7Npm/cJrggl34xkiKEeg4cZYBug+Xq128u6Nq+9Bz4kU7W10ChV/YEobZJC5H8SbpMJpLVKo1xqpWtkhA3zYjgvKRDOGIgwNiv8FVcHWVj+Kd4ZfMV7111zYkLboiSNOJCfocVTmBc2P3azhfBl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Eugen,

On Wed, Nov 19, 2025 at 05:44:20PM +0200, Eugen Hristev wrote:
> Register dynamic information into meminspect:
>  - dynamic node data for each node
> 
> This information is being allocated for each node, as physical address,
> so call memblock_mark_inspect that will mark the block accordingly.
> 
> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> ---
>  mm/numa.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/numa.c b/mm/numa.c
> index 7d5e06fe5bd4..379065dd633e 100644
> --- a/mm/numa.c
> +++ b/mm/numa.c
> @@ -4,6 +4,7 @@
>  #include <linux/printk.h>
>  #include <linux/numa.h>
>  #include <linux/numa_memblks.h>
> +#include <linux/meminspect.h>
>  
>  struct pglist_data *node_data[MAX_NUMNODES];
>  EXPORT_SYMBOL(node_data);
> @@ -20,6 +21,7 @@ void __init alloc_node_data(int nid)
>  	if (!nd_pa)
>  		panic("Cannot allocate %zu bytes for node %d data\n",
>  		      nd_size, nid);
> +	memblock_mark_inspect(nd_pa, nd_size);

Won't plain meminspect_register_pa() work here?

>  	/* report and initialize */
>  	pr_info("NODE_DATA(%d) allocated [mem %#010Lx-%#010Lx]\n", nid,
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

