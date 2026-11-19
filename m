Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF99606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 21:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=orn6ElUm
Received: by kanga.kvack.org (Postfix)
	id F04736B06AD; Thu, 19 Nov 2026 16:00:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDBBF6B06DC; Thu, 19 Nov 2026 16:00:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18AA6B06E0; Thu, 19 Nov 2026 16:00:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFD046B06AD
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:00:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 641D840C11
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 21:00:48 +0000 (UTC)
X-FDA: 85453087776.24.406F096
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8B95520009
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 21:00:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=orn6ElUm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795122046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRzgudTO1qkSGuzOPfaR+Ba0Lwqyafb02x6YrJau0gQ=;
	b=IabXEj6nPF2pdll+uIyIVpwNutKkjgrT2A2u9iwsPHZHfEPfXePzqQWUSlljQRPwrmyxy8
	ayS/TUOEH+cdpxIG4NYtvZyGsGOQ3mxp51E7iu8IupgtKeAqXnY8pWaO64rB3aPxnvxPbo
	Z9bYOqN0fq3tO4UksJmotdhP2X1Qoes=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=orn6ElUm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795122046;
	b=nn8p0h8QS3l4DvpG2TLwxycef8RBybmCvsJgXgN386ewfaUgUO+MdCuaCWcQl+pUv0rGsN
	8TuDHbGpXGuNIeU6tRA/Lhsbf5sDzfCLm55TCq5mi7XsKdWipruz2U6QYFh1znbU6+fsDL
	st0eoRPYfJDHXQieOFfOyp7Q/4JNKtc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E5B761F55;
	Thu, 19 Nov 2026 21:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A7F1F000C6;
	Thu, 19 Nov 2026 21:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795122045;
	bh=jRzgudTO1qkSGuzOPfaR+Ba0Lwqyafb02x6YrJau0gQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=orn6ElUmwk+wOC3TWMCK1D63fKBmQ66tvx/fNy/R1n50ZqHw1OpgnTw5sSOZkyaJG
	 f9qQu/IDo5aUE4eEs5j0qIIiK9CO727Ltm4ttNMYWC7BR8WTmLDhNjl6EjjRG7gADl
	 MMq9ZKC5M6XMbPTNjxCelZpzuwUG1uW0mRbrRpHm5GgDNYl4s/J+YfRjMRKk7uN1/o
	 Af9WF86DUIRObuR/qpoNARO65+rd318lrMb1OP5tbT25DR1rYP+FxCALKxN2tXCkHp
	 ZX0eaBUzRlkedL6sFRSqNvtScDw+qMyXF3wdCGDCOgep6jJ6Cyi9FQPJCCGeoOP6CD
	 Djtx2LjVYD2xw==
Date: Thu, 19 Nov 2026 15:00:43 -0600
From: Rob Herring <robh@kernel.org>
To: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Cc: saravanak@kernel.org, akpm@linux-foundation.org, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	m.szyprowski@samsung.com, robin.murphy@arm.com,
	baoquan.he@linux.dev, pasha.tatashin@soleen.com,
	pratyush@kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, kexec@lists.infradead.org
Subject: Re: [PATCH 2/4] of: reserved_mem: keep the reservation when
 node_init returns -EBUSY
Message-ID: <20261119210043.GA532410-robh@kernel.org>
References: <20261103162429.2053989-1-radhey.shyam.pandey@amd.com>
 <20261103162429.2053989-3-radhey.shyam.pandey@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103162429.2053989-3-radhey.shyam.pandey@amd.com>
X-Stat-Signature: fjzkjt4zpgj8gcj4mc639g4k433p7gcx
X-Rspamd-Queue-Id: 8B95520009
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795122046-911750
X-HE-Meta: U2FsdGVkX1+wFupzRAKcshi4C33gzAOLF/a803ED3K5oAKVk9mEgMmd8hAFsOlu4gpfEBSVY2KoCYZM2lrvMOIO6+vl9nf64u/ZQDwF0kdXthD573pwp4D6w9p7kEzyqPG6pMkzC9kDbjCL80cXO8iuE2fkFcU7sGQmvzGp8NwqgM3xU3wjaUOfXk5wx+kMLGcOhekPohVw6PqviBM3wUjTkZICpaDZnnoeXzzV2SLgX33h3DucGadTu1mS9no0NkSu7yVJgAZwjM8NvV//f5SsA+QylJMcpwUPJuLL9SK7HTvsbKxpHbeXVq4wD8E7XWr8fGkzwkzEAWQ+q9kVciow8yA/WGjSNpKksgfqkv5j6HIlIyNYlbuwcxgyuMIpmuL3ZrDLxRSh0PNHE//3vJTkElaYr9IkrCsbr1aeou6LBXHhp+EwlVyI+83Dx+fXOH3Y/xVtfnyG6+dqZiJQk9psHm9yFyV4cxBJrVefFg6d9bLxVwC5lztnpcvfX2R076p+S5k7wC0i5q67VMVHW6IliCQkn86ISc4bHfKXE93hf5TjcO4Xo45YxSsZtS+tr7IcXLCOm7sqoszGeLuSVB6sYB7m0Hp530dlSJ872jyBf7SA+zOek52nUossm6Ii1XrSZgxrBBqUKSRV3kS3FSVfyIju1ByeFDmfjWXzFBIuWZhtrTQxNp31FOrXK9+E/TlZYY6tDpsklw2RCoXyZFxm1Law56AWSBWKiPDNGucqrxGepXYhvRKtvGGQ9JjyPfKJHYK5K84R2+hXKQQTPOJyksUIhJbFH5DEQJyXC35maepb6ssklNNMmZazytNlPGJuOZLEJ3/VArs1v16pbdEPMl5OvH7W5j4uxDW/LrT0UGpLjpQvQLy32mir1vHMloHKf71XDz0CZLc/k1sA2oegX1kh0bjsOWHKLBN9TqVvtV1GqaWR+2G8V71uwP3NY1d6XD88NuMhYMJEx4Vc
 pLPwvANo
 ZdJhds8VuruvItC9b66zqvePJDPY+nrNglqkH25CEoNhDQKSxv5MsZEvtJrUYQih+7JTVEvPd9M20iPNe9X32FJqDQFlJLMwHjcA8eEmSbOedcInW1zDIVLbT61gSYxwlhbQy+vzZfYUtJb4QWt2E02VWKrxsSxin9/ykH7ov0opTOltiSGQsTfkVyisagTK7rdkZH+P/TpR/pjnbm+blc5tbJHfDeO86wpmr8HYQWSKe2kR/0wAFVqYycji5aqKzMaDvPfGobz7pRbi0Bxypwi+QsB6b0VdR5dBcg4aVJMTWhfS7yoErqCkeNW8vd4eWrvUGbtwW2GfqFa+AWcfP8cgS9LCCm8f+vAFG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 09:54:27PM +0530, Radhey Shyam Pandey wrote:
> fdt_init_reserved_mem_node() treats any error from a region's init function
> as "this node is unusable" and calls memblock_phys_free() on the whole
> range, although the range was reserved earlier during the FDT scan by code
> unrelated to that init function. Give -EBUSY the meaning "cannot be used as
> described, but must stay reserved" and skip the release for it. Nothing
> returns -EBUSY from node_init today. The next patch does, to refuse a CMA
> pool overlapping the kernel image, which without this would free
> [_text, _end) rather than protect it.
> 
> Suggested-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
> ---
> Changes since RFC:
> - New patch
> ---
>  drivers/of/of_reserved_mem.c    | 14 ++++++++++++++
>  include/linux/of_reserved_mem.h |  5 +++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index 0fd1683cba01..d67a2b3a4d44 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -621,6 +621,20 @@ static void __init fdt_init_reserved_mem_node(unsigned long node, const char *un
>  
>  	err = __reserved_mem_init_node(rmem, node);
>  	if (err != 0 && err != -ENODEV) {
> +		/*
> +		 * The region was reserved before its init function ran, so it
> +		 * is not ours to release. -EBUSY says the init function is
> +		 * declining it for a reason that outlives this node; freeing
> +		 * it would hand the range to the page allocator even though
> +		 * something else still owns it.
> +		 */
> +		if (err == -EBUSY) {
> +			pr_info("node %s init failed, keeping reservation\n",
> +				rmem->name);
> +			rmem->name = NULL;
> +			return;
> +		}

I would move this out of the outer 'if' and and make the outer if an 
'else if'.

Rob

