Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2465A606A330
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A5ZND05d
Received: by kanga.kvack.org (Postfix)
	id 3F4786B05B6; Fri, 13 Nov 2026 09:03:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5AB6B05B7; Fri, 13 Nov 2026 09:03:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BAE46B05B8; Fri, 13 Nov 2026 09:03:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 095366B05B6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:03:19 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 956AAA0211
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:03:18 +0000 (UTC)
X-FDA: 85430262876.30.80274FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BDE2540006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:03:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A5ZND05d;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794578596;
	b=hG1Xf8gN/23cWi1d3tah96D7SI0JGGJRHxmN23EakDDT9BNuj9nsmhDSlBM0q6LDEtrIT/
	LziXLQJUaeAMOoTokygABUKMvlK/TGhuOCOZSsrt0kPdHFun5QFM0L/TGN+MB1fMQ3BNlF
	Pdy8Y4FIFj2ahVTkTYyzppuKKG2wvTY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A5ZND05d;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794578596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q981tRUWKrBz32Jw1Te3BR+cA0g5zfyV4P8NPMxGZO0=;
	b=TZF9dfkSyBLnB9NxMkOK6SegOuEYspDwLTtIDifi5uH5xDlCjeY+hKa791kYFMm+6y7SFa
	GaG+0CEvCQkny1ApQ6wf+2n5zz90uInyQj1z7g/JQrunwYQWW85iR5mpmHvotzSOeHJpZv
	m/eAudPm8irWYPohYcyVALjRCVJwiQs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F1BD54341D;
	Fri, 13 Nov 2026 14:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE3F1F000C6;
	Fri, 13 Nov 2026 14:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794578595;
	bh=q981tRUWKrBz32Jw1Te3BR+cA0g5zfyV4P8NPMxGZO0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A5ZND05dZNdOaJh1LC6dIa2ZRCkXytqKLIGSws8HvATHSWeCOCBfESWR4fidBdr8C
	 4EtJi1Vd152F89eHaknz/xtBxsVRe0YvTY9c/KLiBUGbtbyhuTS1H2q0E0P8c4sbcf
	 YdY9ZK4GXxmmGQZ9XhMJ4ZUT6C+xPtulkL4sRJSI+YPzosb7RksaffNl5QYfmXJQJ7
	 Aip49j87YnBRsVxu4PMLWwt68ag31Pe2s7IaNDBEezpDDv6RWvCzC9wZP+x34Bd2Y7
	 MTH7zxYFJlQn3Uem7t/+4s/Cl0ISGk4uL0Z48vQWpEwrOyv5dBUsZX44Zh18XYEEiK
	 UQAu7Xx90O35g==
Date: Fri, 13 Nov 2026 14:03:11 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: chengming.zhou@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/ksm: extract helper functions for scan cycle
 cleanup
Message-ID: <avcYRcPvzpw37pfo@gremlin>
References: <20261112125754.176930-1-xu.xin@linux.dev>
 <20261112125928.177598-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112125928.177598-1-xu.xin@linux.dev>
X-Stat-Signature: 83adsdxi7cgi3wtxeuz7ge3pximpgpes
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BDE2540006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794578596-414505
X-HE-Meta: U2FsdGVkX19KA5CFgz6anG2tKG6zabk24N7BLCEM4T9y2WSmAz2ZhFLaJ6nguAPv3lPjNTGF2oeQ9lK8iAFGtmUzHnXyNpuDsrGHUNBEV+p4n8tcfBS6mNab5C43+4KUd2ottS7iyRILImkeSVb11AFXy1zjzE5mWPcSbIiL4vgBQ8k8WJImZJGGSocnmm0lbpaNiVWeywbCUEr4eKGBSaFzYfF3B5ZbNuPX7zidCPoPEzLqzxw7dnBF406yPTzGqeVyhir/1t54TIdY8sN9WV2YLxXkgr7ngUcfVhPvl2zxCJABqRLEI5lyI2No4y+SBNmdSpnH+sRfB3K5e2ljX2P+qhF9v+d/F5bTSRnR9LsXctJp+ubhr+4wNXs0Y+rr7zHBDNDbK9i/Gu4ILxtcMaBkeeQMECtkSG2O7cIrfST4tTtX2XboDXK2+lI830pg3qgK3AVJQVMIWJN2x4tAQ82VOXBqW7celgCTh0NG3Km1H26tXdXzmFHOBviM78ec2lklV5W1KtmtIHGRNa5YKRSHopsnm7C3puaEfP2nLUnDIhfXkLbq0678TOpTJ6GYW2K2PvRe6qaNuCIB599ZNtXWSEVZLV1rzgYZbqlGzhZCMUG41qStmVtAPZO3DkOD3zseExOziYnk02uhbcUeBPMcBR1SDNt+iVlBD//x7g8/ylEk8A6vLKVja7DHxZmnLT3lwNIVD0coyFKYvsxNhmzC1NM2EHVEOrQ/NgGMCPLmLYjrFZw1449kXgKst2oxvWJjlj8ghNliztiMMztz7O8cqVGwkHhWPEee0JfkwfnUAauDV55nuDx9lhaE69qLYYyDPMBdj2kdtK8OgGDSh6YTkokslbhnaGEeSDksLfZ7LC9hJnjQVDCmKAkqH7S+z1Ort0JLbTJQODBrDXdUSMCkNj81pRk4ll5aPmkuEmfw2Nd/gFZ4sGwbBfGfZNaflDMGsztxws/gqi5yRfV
 Yjj85fq+
 I7YgHpLlcBU8JhlWY8PkGI5CRVK28wlxcmOwWk4F9etvXKsd36JRgZIJ7ql/oj8zVHIaWAr7I4SIn/PC6PCb4AcjHvC/LMhTFRKCWj1feuZAfIxVK9H8E7MQSRZ+N28XIf5XiDiOTykgeGvLxeNgLAmnTvdFb4Myi6dVsZFpUd3xUT7e7aCesYrDVAr6xOILrS5fQbUx8hlbmfwhTek05zQttKhnC0/sQR/a5KdB1UsfKPPeHf+jTh0lHFITCg04SdHX5fYeizkUEszpHZ7utJ3njIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 08:59:28PM +0800, Xu Xin (vivo) wrote:
> Since scan_get_next_rmap_item() is getting too large, extract two new
> helper functions, ksm_prune_migrate_nodes() and ksm_reset_unstable_trees(),
> to reduce indentation levels, isolate local variables, and improve the
> readability of the main scan loop.
>
> No functional change intended.
>
> Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>

Thanks for doing this! LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

One small nit below, but it's not a big deal :)

> ---
>  mm/ksm.c | 56 +++++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 33 insertions(+), 23 deletions(-)
>
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 5e24b5ca8dc8..49977bcf04f7 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
[ ... ]
> +static void ksm_reset_unstable_trees(void)
> +{
> +	int nid;
> +
> +	for (nid = 0; nid < ksm_nr_node_ids; nid++)
> +		root_unstable_tree[nid] = RB_ROOT;
> +}

Recently I learned (and PeterZ reminded me :) that it's actually valid to
declare the var in the for-block in linux kernel C.

So this can be:

static void ksm_reset_unstable_trees(void)
{
	for (int nid = 0; nid < ksm_nr_node_ids; nid++)
		root_unstable_tree[nid] = RB_ROOT;
}

:)

--
Cheers, Lorenzo

