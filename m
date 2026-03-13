Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D67C4105F783
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 09:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 411CF6B0005; Fri, 13 Mar 2026 05:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EA746B0088; Fri, 13 Mar 2026 05:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316FF6B0089; Fri, 13 Mar 2026 05:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2230B6B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:21:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DEB38BB996
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:21:56 +0000 (UTC)
X-FDA: 84540497832.12.9D69FA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4B163180002
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:21:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uHDzvVxW;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773393715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hP6VB/kh4caosJ7JSFrTVR87i2GC1lPoiQyiYwHx/ts=;
	b=w74+LlkJhy04CxW9ydd2JiZItOcY3dIMdBLSh8w71V6Qcs3NkvNbJWqiI7VTqF5m8sBi9T
	5Xj3rI8Z4pxuvc4RQM3eXdvjMwnt9NMFoRdk00MMj6SDdBK6Ge7zBiXm0j0MH0Wm30KwMd
	HDR81fA/9xkC/r6QVyhRl8MSaWPcbAY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773393715; a=rsa-sha256;
	cv=none;
	b=ZYKJ2N60/t8XYmc13zfmX1+RJvwwxUFMN0SVgfD+BCGpz9jfcTQ4IFBd8o3DqOIBS11Kzw
	alYE2iXVEpgqYYmmZKY9K5QeDIh5bJjT8YmlEqStFq0qHphkl5x7es7Oy1Suj77TVSjnHV
	AuBB0Lw+86Vfe2lk4lGij50jVuf8rgM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uHDzvVxW;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A0C856012B;
	Fri, 13 Mar 2026 09:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A260C19421;
	Fri, 13 Mar 2026 09:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773393714;
	bh=tQJKdL58Q4S6pgdJ9PWWjtqzjJ6qyibzg9gNvLmbvNc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=uHDzvVxWqEjeUrRDkZCSRp/7kEUJDWK7mW76FM+GvRlYeECWZC05DVI7QbMSuB+LR
	 ob/sftdL89q0W29TpL0ancfU4zZd98enqGB2NmTbZ9DShiQUHRS7zul5tT4wsFNLW2
	 OcRkn3ydcRA2ZJ+SOiedL9N2n0D9FQQe8lIs+GuGq2zyC9YRzLqtIdMaQwM8h5A5II
	 uvIPcJO215CL9giQF2gsvkZGoNhYSKJEKv2UGlxkaNaN36wVTKkONuKN2OZtOzjixc
	 1lYnLNuWaMJKYnlZrFgkCSUhvsLPEkER/Bl6s5omfDF8SjvzNC1fmngKAH29eh2Owu
	 nPdSACfYjsfTw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usamaarif642@gmail.com,
  SeongJae Park <sj@kernel.org>,  kernel-team@meta.com
Subject: Re: [PATCH v8 3/6] kho: persist blob size in KHO FDT
In-Reply-To: <20260309-kho-v8-3-c3abcf4ac750@debian.org> (Breno Leitao's
	message of "Mon, 09 Mar 2026 06:41:46 -0700")
References: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
	<20260309-kho-v8-3-c3abcf4ac750@debian.org>
Date: Fri, 13 Mar 2026 09:21:50 +0000
Message-ID: <2vxzbjgsgk41.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4B163180002
X-Stat-Signature: 57pe4yt4gqzg7fkj7my31jy11arw8adj
X-Rspam-User: 
X-HE-Tag: 1773393715-393059
X-HE-Meta: U2FsdGVkX1/VsDlKQ/yOZAJgrvlZpeZAJzyEUWbPxrnToTDOHwwkcJ3pzHGNuPUdlcb2TN7Y4xTcC0Ha0m7s+gbBzeg7oFUybFE9CPCSEBa21PjRxeAq3nWPLT0kGofgY7K/YsT/nQZta4f6dcp4GP1klhmJOSoXjoRXl3smyIkdXz7QP2/bKS02G419dfLEdCouOo653cIAwjDDEKhidwTG920G22N+v1QqHfQS24kwPC3a8/+8JzIQLfbyKy/fTZlJ++8zZCyyaQdEQrbOJ0ntcz6JTjcWlPXKuPgfgiT+Pf5Ya3D+cBtJP4Yif3kDu6twxM4/Xo34ExUe1fE2eKpXvedA5oj8L0HLMFbefSrsN1k7KVQYl9mFDPHSEdJM26i0ZQ11DxHdMELOEHlQyytkZwGrjeJHdZ8peSfrJKWCMkz7+7i1WNILHokyPPcAtzCaW9T/WW39vXkMLFGxbV5oOcaKIz8HKSSC5Y/O07wmKYR9ojwZ2NYe1sh5qADLBy4UeBJGMMqdn7AghOEgVKmSotn48fyMSZBMkUWc0ypAyscBmiu0uaiswh5xdFzhdIFkpP7uXLcjuutcEPZ9XySIVggVaKbbnQKC24PSIxRfrxrZWc/ud72pOlcW1/wXETvhpQTmXEqb7J+ebPR8JsKkF8i+RDTrbaC7kOZi9x1xbkPrDGWXFBpk2quXFXwqXNlMx+EesCLP0dv3+v4DJJH84CayNgv+LJQB4Z3DhJE7z/fhcteeuaN1He7JOaHpibCMAy8n6+NAAf6TlC0ewlN2kYghE4WqzsXs04SIUmmIczlW3fb6a4HbiCXzPgNrAWjOV59OKpXX2IRFEgxbTvI9hh6DnEYqegZm5w4ZqcA/vaMt6piHqf3UCoojZ4hbclCZpCqOcQTk9wVxxRiutfi+EH0uBnp2mgXbvezzimFOmcvTy6qYmiJ7Jn5+MGL+3T5uG5cYoehVD1QPuqk
 4bP8fpQe
 XifYxNH3tyPBLHdIqAZDw2TLLmNueUdB7K50UjCnqlNW7tb+u6zQvHbIg79NCWCyBq1F0iPs0DZOuCkQT6Dvp8zdE+iMbL5GfirRO4KI1KYZXDupdlcJh548KDTHboh89UaXhCkvIpZEs2o5LzpA35CVXxiM/1TOUSW7i0CFVZbKNZEymA6XSdEQC9tijr5CZUEbx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09 2026, Breno Leitao wrote:

> kho_add_subtree() accepts a size parameter but only forwards it to
> debugfs. The size is not persisted in the KHO FDT, so it is lost across
> kexec. This makes it impossible for the incoming kernel to determine the
> blob size without understanding the blob format.
>
> Store the blob size as a "blob-size" property in the KHO FDT alongside
> the "preserved-data" physical address. This allows the receiving kernel
> to recover the size for any blob regardless of format.
>
> Also extend kho_retrieve_subtree() with an optional size output
> parameter so callers can learn the blob size without needing to
> understand the blob format. Update all callers to pass NULL for the
> new parameter.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
[...]
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 54fe59fe43acd..1f22705d5d246 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -768,6 +768,7 @@ int kho_add_subtree(const char *name, void *blob, size_t size)
>  {
>  	phys_addr_t phys = virt_to_phys(blob);
>  	void *root_fdt = kho_out.fdt;
> +	u64 size_u64 = size;
>  	int err = -ENOMEM;
>  	int off, fdt_err;
>  
> @@ -784,11 +785,16 @@ int kho_add_subtree(const char *name, void *blob, size_t size)
>  		goto out_pack;
>  	}
>  
> -	err = fdt_setprop(root_fdt, off, KHO_FDT_SUB_TREE_PROP_NAME,
> +	err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_PROP_NAME,
>  			  &phys, sizeof(phys));
>  	if (err < 0)
>  		goto out_pack;
>  
> +	err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_SIZE_PROP_NAME,
> +			  &size_u64, sizeof(size_u64));
> +	if (err < 0)
> +		goto out_pack;
> +

I noticed that the error handling here is a bit broken. We open the
subnode for the subtree, but then if we fail to add the "preserved-data"
property, we don't remove the subnode. So the next kernel gets an
invalid FDT (per KHO ABI) and might as well refuse to parse it.

Similarly here, the FDT might also be missing the size and then the next
kernel might reject the FDT.

Also, we directly return the FDT error code to the caller, which
wouldn't make sense since it probably expects -errno.

Not something this patchset has to fix, but I am pointing this out in
case someone (possibly also future me) is interested in fixing this up.

>  	WARN_ON_ONCE(kho_debugfs_blob_add(&kho_out.dbg, name, blob,
>  					  size, false));
>  
> @@ -817,7 +823,7 @@ void kho_remove_subtree(void *blob)
>  		const u64 *val;
>  		int len;
>  
> -		val = fdt_getprop(root_fdt, off, KHO_FDT_SUB_TREE_PROP_NAME, &len);
> +		val = fdt_getprop(root_fdt, off, KHO_SUB_TREE_PROP_NAME, &len);
>  		if (!val || len != sizeof(phys_addr_t))
>  			continue;
>  
> @@ -1314,13 +1320,14 @@ EXPORT_SYMBOL_GPL(is_kho_boot);
>   * kho_retrieve_subtree - retrieve a preserved sub blob by its name.
>   * @name: the name of the sub blob passed to kho_add_subtree().
>   * @phys: if found, the physical address of the sub blob is stored in @phys.
> + * @size: if not NULL and found, the size of the sub blob is stored in @size.
>   *
>   * Retrieve a preserved sub blob named @name and store its physical
> - * address in @phys.
> + * address in @phys and optionally its size in @size.
>   *
>   * Return: 0 on success, error code on failure
>   */
> -int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
> +int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size)
>  {
>  	const void *fdt = kho_get_fdt();
>  	const u64 *val;
> @@ -1336,12 +1343,21 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
>  	if (offset < 0)
>  		return -ENOENT;
>  
> -	val = fdt_getprop(fdt, offset, KHO_FDT_SUB_TREE_PROP_NAME, &len);
> +	val = fdt_getprop(fdt, offset, KHO_SUB_TREE_PROP_NAME, &len);
>  	if (!val || len != sizeof(*val))
>  		return -EINVAL;
>  
>  	*phys = (phys_addr_t)*val;
>  
> +	if (size) {
> +		val = fdt_getprop(fdt, offset, KHO_SUB_TREE_SIZE_PROP_NAME,
> +				  &len);
> +		if (val && len == sizeof(*val))
> +			*size = (size_t)*val;
> +		else
> +			*size = 0;

If the size property is invalid, is it a good idea to ignore it? Should
we instead consider the subnode to be broken and reject it entirely with
an error message? Because if a caller expects a blob of 16 bytes but
gets one with 0 bytes, it will likely error out anyway.

> +	}
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
[...]

-- 
Regards,
Pratyush Yadav

