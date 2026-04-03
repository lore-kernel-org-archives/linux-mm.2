Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FC07E7E378
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 11:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56D66B0089; Fri,  3 Apr 2026 07:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07D76B008A; Fri,  3 Apr 2026 07:37:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91DBD6B008C; Fri,  3 Apr 2026 07:37:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D63B6B0089
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:37:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13CDAE1565
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:37:53 +0000 (UTC)
X-FDA: 84617045226.26.E374375
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7E0EF1C000A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:37:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EF4VvpD3;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775216271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BjMlsWhY6jfzYb+mCsmE6mk1gxbFqx16MLVYx9pqxPo=;
	b=euw+N6gVXhSGzcFguUlw+U4I5DSt4Rn0nGal+ucDzrOZdaUqnhD5tfBUXlLfUkdpumJ+MZ
	b3DjEhVy73Ktz3qoCgUUf3RLVi5UJwvhq/lwdlQIAxxlzT6fEpsW4+cBeiL/e2N9E11dMY
	1DsaGJ/8/6k2XoD7zSU43PvgN36XlyM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775216271; a=rsa-sha256;
	cv=none;
	b=erCyBQMt5Oxwer7IfWJIYw4wwGG4BwhjnUstQmtPs9eLm3oxE8BrRGF1cToM7gHyLZgTC0
	S/s8MoDvBcayQgawRJHEri7OVeu62fIKJnb1/gGAxgDPMogNsKEzoS1iHe1YdFNG9yR4QT
	QOx9BdoGbDk9mGMS5dEhzSKLyzgePXg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EF4VvpD3;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5065B4345A;
	Fri,  3 Apr 2026 11:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE964C4CEF7;
	Fri,  3 Apr 2026 11:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775216270;
	bh=vMKZ7un5FtqzmkKApMQD7+RG0CoGlZexiI3kSh6AhSw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=EF4VvpD3Kmcyx1KhggtAUGhgjtIw5v6tzk2xv79niXA5bmlH3LYJ3kaGdNHsQZ1Uh
	 jB6YxwxWbPghSDe+IRCLThjS8klKx5YLsuz/eiIuWzqDVsxj3fmWPjT25jTKv/CgpJ
	 BdqCh8N8na0fwP66eFQexPrB7QLIVN9YCaPAAipiZmxCUHm4onD5OQiyqLsN57AnxU
	 ZonVZemsLWRkZUUhgZQXQUDdHs+AaOFBhUpZZR4AonfiVrOc5nlbDxmYVyuxHt5sns
	 LvnnBsk6PY84Xn/SqUmukQe6kCcEYc52FYTMg1w7jp+LIapurVe7ssuL4+L0nIv/ar
	 j2h7Ya9bAE0Ug==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,
  Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usamaarif642@gmail.com,
  SeongJae Park <sj@kernel.org>,  kernel-team@meta.com
Subject: Re: [PATCH v8 3/6] kho: persist blob size in KHO FDT
In-Reply-To: <abfkVOjq1ngZb-Nm@gmail.com> (Breno Leitao's message of "Mon, 16
	Mar 2026 04:09:43 -0700")
References: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
	<20260309-kho-v8-3-c3abcf4ac750@debian.org> <2vxzbjgsgk41.fsf@kernel.org>
	<abfkVOjq1ngZb-Nm@gmail.com>
Date: Fri, 03 Apr 2026 11:37:46 +0000
Message-ID: <2vxza4vkcm0l.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 7E0EF1C000A
X-Stat-Signature: m3o1zn745efy6f9uq3pz5cpt1u94eqaf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775216271-676360
X-HE-Meta: U2FsdGVkX1+fYEfLPR0ShW0sBzjVTQ3HEMtOuZyZVm6JHkGy42Rww9ditM92S3iEzFyLwE8LnJcsVIWr1mOFcXy6RW0RSrGvzifVQpXe+w2XT86OOc7LPTe/wykJ4v7KkiI0rJ2o1A9HudwkIRjvPg5IqN8I+K7aOs6/+oF6dNjEDCV72DdhWFTXHth/Uit7c+m9rl9VXRS7YF7AQwqYnRbhwkdMve9z7LQe/Ekg7QTyi/DZHvsviLkZUFCDe8X6QqJInGS5FHpYAaLMF5P0upNEgMCAU2yqNxT09tDkW+cEGm7yxeVUn53AaAQ+/1l2oJgU+9403fSB39Yy3XiriXDWCiJQNM4qYy7/2Vjjzh2b2TH2dK7mzisNyo6/vmyKHbakn73p+W0qAwvFD9orNelPRPfnt708e0tqr8eHtLb975sf2+ifXftyPXwNa5jbNHj1jPoJFMVCwduT16YuzskYAbnEVG1blzDaEuJrlj1zU0ibmzltAnQEhF3f17VMncwPtTRKuhfOlqakZeKhGcWtG7k0MGI7AMbu5J3PzMiDifO6jqxA7GH9Iz1GVhKn9cLegrC046jCrAmlJBriQvZu0WlyGIjBmeu+VZSbIRLU5gI8FaA5biRITEwyU3VLzRn8FY/JHgikF4A8xOxtNv+UbL3/7nS+NHYjhlSAe1bpT0hA1iHwnqQ+IO0oZsZRw5KbbL/XwqLyYYNDj05dqdhBC+JRXOGvNzRxIImiVAz2S007QMwDX0t8bewatkcmSbKz5R2iOWNJEaSITpco0Zvj+BtZJO2yq3heXoSYXHGp2b8sZubdwKkTMzueRZXo1ZxZ0+78TaKRokoG4ThfTMHZgT9n4e+IR+BkKyIH+r9jwxOuGoTW9TGvQmyYu3PwOAkkuv2h4/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16 2026, Breno Leitao wrote:

> On Fri, Mar 13, 2026 at 09:21:50AM +0000, Pratyush Yadav wrote:
>> On Mon, Mar 09 2026, Breno Leitao wrote:
[...]
>> I noticed that the error handling here is a bit broken. We open the
>> subnode for the subtree, but then if we fail to add the "preserved-data"
>> property, we don't remove the subnode. So the next kernel gets an
>> invalid FDT (per KHO ABI) and might as well refuse to parse it.
>> 
>> Similarly here, the FDT might also be missing the size and then the next
>> kernel might reject the FDT.
>> 
>> Also, we directly return the FDT error code to the caller, which
>> wouldn't make sense since it probably expects -errno.
>> 
>> Not something this patchset has to fix, but I am pointing this out in
>> case someone (possibly also future me) is interested in fixing this up.
>
> That is a good point, do you mean a fix like the following? 
>
> commit 633d0cb01ed959676b60de8b1851dad1757d8fe5
> Author: Breno Leitao <leitao@debian.org>
> Date:   Mon Mar 16 04:03:51 2026 -0700
>
>     kho: fix error handling in kho_add_subtree()
>     
>     Fix two error handling issues in kho_add_subtree():
>     
>     1. If fdt_setprop() fails after the subnode has been created, the
>        subnode is not removed. This leaves an incomplete node in the FDT
>        (missing "preserved-data" or "blob-size" properties), which violates
>        the KHO ABI and may cause the next kernel to reject the FDT.
>     
>     2. The fdt_setprop() return value (an FDT error code) is stored
>        directly in err and returned to the caller, which expects -errno.
>     
>     Fix both by storing fdt_setprop() results in fdt_err, jumping to a new
>     out_del_node label that removes the subnode on failure, and only setting
>     err = 0 on the success path.
>     
>     Signed-off-by: Breno Leitao <leitao@debian.org>
>     Suggested-by: Pratyush Yadav <pratyush@kernel.org>
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 62b1b8a9aa337..8d2d30119f6d4 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -787,19 +787,24 @@ int kho_add_subtree(const char *name, void *blob, size_t size)
>  		goto out_pack;
>  	}
>  
> -	err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_PROP_NAME,
> -			  &phys, sizeof(phys));
> -	if (err < 0)
> -		goto out_pack;
> +	fdt_err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_PROP_NAME,
> +			      &phys, sizeof(phys));
> +	if (fdt_err < 0)
> +		goto out_del_node;
>  
> -	err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_SIZE_PROP_NAME,
> -			  &size_u64, sizeof(size_u64));
> -	if (err < 0)
> -		goto out_pack;
> +	fdt_err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_SIZE_PROP_NAME,
> +			      &size_u64, sizeof(size_u64));
> +	if (fdt_err < 0)
> +		goto out_del_node;
>  
>  	WARN_ON_ONCE(kho_debugfs_blob_add(&kho_out.dbg, name, blob,
>  					  size, false));
>  
> +	err = 0;
> +	goto out_pack;
> +
> +out_del_node:
> +	fdt_del_node(root_fdt, off);
>  out_pack:
>  	fdt_pack(root_fdt);
>  
>
> Given this is not strictly related to this patchset, I am planning to
> send this fix separately.

Yep, looks good. Please send it out as an independent patch.

[...]

-- 
Regards,
Pratyush Yadav

