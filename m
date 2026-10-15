Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA587CC6B39
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 08:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0274C6B0096; Thu, 15 Oct 2026 04:37:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1A296B009F; Thu, 15 Oct 2026 04:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2F486B00A0; Thu, 15 Oct 2026 04:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C22606B0096
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:37:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3895C1A05FD
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:37:07 +0000 (UTC)
X-FDA: 85324205694.06.A48AF10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 89D3BA0004
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:37:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ceFJqAFL;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792053425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NLcSuJO4U8vjtpBw9Dd1guU9F3I58AzL7EvX+dUZ0Qo=;
	b=UrbExEMLwOsQ1GYaSYRifpPGb3rQaLNZ/fUEUhGcVrR0gt2CMofiTsDvaxbOMt8Xy3r55v
	5i7sOetKFDUGHvbu9THKk+kTQkoBm3tFwbuLB3hDemtCFJKuz+rxjO72LhrjBzZNCD00fK
	rpZ6oKniD9q9r2O2clbOhZXPfksMnk8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792053425;
	b=h7iXpN0j4awON+uUNv5rdFtnzj1mNHcNEG534wt1GeR2mOi/nlBTCejO+p13L/XPDWJoLT
	hqfMPzX3HId61ny/cJ0+w4dzDXBCRcOcLgGOTr1eFjE9jK6RCT+CBJjvA0LmXFE36ay5/+
	zhw+iqyGxRKGPMZOXtnIzrmdzIhbacQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ceFJqAFL;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4A1B43C14;
	Thu, 15 Oct 2026 08:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1BB1F000C4;
	Thu, 15 Oct 2026 08:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792053424;
	bh=NLcSuJO4U8vjtpBw9Dd1guU9F3I58AzL7EvX+dUZ0Qo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ceFJqAFLM7g4NE9wZsEJoybbeHVCVxchnM7ejTiim3IUlIFyU3ctm4G9tESzMQMla
	 DtM5RNVSK1/JVG2PJqbDaMrJtDeUiCNnpI7BbLZkgoooSQUevs8vV++LK021vfv2cV
	 2pdkgAjUJy8kcL1c/QXjLltJq619Z1+4uE0gOSXKSgBn9+sAjWca4ng0iBZb/Wj+HF
	 DoQgKlj4SpKEMEYFJaqRJssFTt18waBVfOXf1eOWjRYA2znJ1KOFyqgCAu6Qk1i1kL
	 LzSTCa3+D34hc8AKJVAg7VQxtm+MGSw+6K9TtN/GxtwaY4A1HRstooBKVORn402cMK
	 YJKOUb/qL/qqg==
Date: Thu, 15 Oct 2026 11:36:58 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Bing Jiao <bingjiao@google.com>
Subject: Re: [PATCH] kho: do not reserve empty per-node bootmem areas
Message-ID: <atCQqghin0KOyx63@kernel.org>
References: <20261014131547.259138-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014131547.259138-1-pratyush@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 89D3BA0004
X-Stat-Signature: gk1mfwbpn7mjurqapqhr4ctzphu61yy5
X-HE-Tag: 1792053425-688009
X-HE-Meta: U2FsdGVkX1/Kr8cBpmYn0+KeDYxQyNAV77ZIXXALCONwa6s7u0lzOPEGD/goWUzXSPA5spd+odGFWncuubQBm179YFC4/JLQXLfodOh1pRr0J1pTZyLH2xyDRRgnWU5uxMffqyGCrs7itX3oNn3rj78BDsJvjlCerZEusiG7s2ASFin2GiVL8RF7yfr60R5DfDGk3aAXkiVOfrpg1hoNPam2neu6esaZ/uqkMtvFHF/Erh43in123e1Kwa/EYrxyWYtDfMOxYU5E0egHbvb9K5UwVXwyXHF7eXKLgT1HvCJRAQ1IMUNbsdHFr0LuaqZvxNKS0p+51cUr8SM7NkE/Eyq/ydKNFXRvI7IqyKzCl/83cKAGDaWN/LnPiYuBWge5JeLn14rut0cFLimxL3o+mFK0EV9o8BJDAvKsLHEazSIpumI4dAVXEOPmFdVv30rH3KqS/JDmaoR8qrIxb1P/7ZDile2WMjHPtfcPuwJTtm6BpZVvLRoTbFkhIFlHJa/EXtUwSPaSxQiIZSMHmk3Zk6HDK8CYO5/aBbHO2mNfz5u4GdSjLXwWxBma8HEBJiLyc0O6SYxo6MaDXEu4xx4zVFjGY23boE58tGnn2jY+26Zc0/oKtxo5X1udJUYLwzxTdamidLotNNpCe1PgK4B72dgf1Qgg5Puw4LFKGMIV35Ek9FmJ0HXejcvcqE8j/0IXm5oQsS4mxzVjyVtRmK5oQS6z2+Y9tzFungjm+aU29C3WajpnRQ6KfH3Y9AIcEAwL1aO21/zDAcifjytcGjT/CNZdwyrq9geqMuYSgF3gwKpX3gmzimWt/LZVrl4NrZc+lU6EPUnKjQNAZcJx46ZgGZYQ01w+rh41OOnkH3LSujrKdQloUByfIzaNdBTxzWnyBGxqJrfsBkrrpprSbaCiX36nEW7OwHggYUu9PMK/P98qQLyr6a3sK9pC3b0E2UqJJtLdvv9B2Nxg+ycsfiM
 3Rv8FMdQ
 tjmlkNa8lqdXRkBm0SVm1UI/fSY2UkvoB35u3FyitvY+CdJY1xoVhkL5efGKPhmKnhlDIcxWxzRAba2Q1oWh+LFDlXR8Sp8KExNLFHMp1yMTZPWpXjgno7QGMt3PKDhU3B7b9mAbioSion5GQtzc7FJPicKEnC8QTAAr/suHNbpOfElNAAmzBumDIdeKS9o9p7li+qBXv8HxlEzfU4hU84huo4FTLUNGTZbPB1Ci7+htVZY1PmOU/OP/NPl1iwxCENQX271pmlMikjYlYQ/f/iMLaS7sSqb4oR0H7LOgkUjYY2Oo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 03:15:44PM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Some nodes do not allocate any early boot memory. An example is
> hotpluggable nodes with movable_node enabled. So the scratch size for

                          Let's use the new naming please ^ ;-)

I'll fix it up when applying.

> them ends up being zero. Zero size allocations normally don't play well
> with memblock. Memblock returns an address, but then doesn't actually
> reserve anything. This address ends up being recorded in kho_bootmem
> with a size of 0. In case of hotpluggable nodes with movable_nodes, the
> allocation on the node actually fails because memblock refuses to
> allocate there, and so KHO fails to initialize.
> 
> Skip bootmem reservation for such nodes entirely.
> 
> To keep the code more robust, avoid overloading kho_bootmem_cnt. use
> max_nr_bootmem to store the size of kho_bootmem array. This ensures that
> the location of kho_bootmem_cnt assignment does not affect the cleanup
> paths.
> 
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Reported-by: Bing Jiao <bingjiao@google.com>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 7018e25e4eda..6f1f55fe3181 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -831,8 +831,8 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
>   */
>  static void __init kho_reserve_bootmem(void)
>  {
> +	int nid, i = 0, max_nr_bootmem;
>  	phys_addr_t addr, size;
> -	int nid, i = 0;
>  
>  	if (!kho_enable)
>  		return;
> @@ -840,8 +840,8 @@ static void __init kho_reserve_bootmem(void)
>  	bootmem_size_update();
>  
>  	/* FIXME: deal with node hot-plug/remove */
> -	kho_bootmem_cnt = nodes_weight(node_states[N_MEMORY]) + 2;
> -	size = kho_bootmem_cnt * sizeof(*kho_bootmem);
> +	max_nr_bootmem = nodes_weight(node_states[N_MEMORY]) + 2;
> +	size = max_nr_bootmem * sizeof(*kho_bootmem);
>  	kho_bootmem = memblock_alloc(size, PAGE_SIZE);
>  	if (!kho_bootmem) {
>  		pr_err("Failed to reserve bootmem array\n");
> @@ -882,6 +882,9 @@ static void __init kho_reserve_bootmem(void)
>  	 */
>  	for_each_node_state(nid, N_MEMORY) {
>  		size = bootmem_size_node(nid);
> +		if (!size)
> +			continue;
> +
>  		addr = memblock_alloc_range_nid(size, BOOTMEM_ALIGNMENT_BYTES,
>  						0, MEMBLOCK_ALLOC_ACCESSIBLE,
>  						nid, true);
> @@ -895,13 +898,19 @@ static void __init kho_reserve_bootmem(void)
>  		i++;
>  	}
>  
> +	/*
> +	 * Nodes that needed no bootmem were skipped, so fewer areas than
> +	 * initially estimated may have been reserved.
> +	 */
> +	kho_bootmem_cnt = i;
> +
>  	return;
>  
>  err_free_bootmem_areas:
>  	for (i--; i >= 0; i--)
>  		memblock_phys_free(kho_bootmem[i].addr, kho_bootmem[i].size);
>  err_free_bootmem_desc:
> -	memblock_free(kho_bootmem, kho_bootmem_cnt * sizeof(*kho_bootmem));
> +	memblock_free(kho_bootmem, max_nr_bootmem * sizeof(*kho_bootmem));
>  err_disable_kho:
>  	pr_warn("Failed to reserve bootmem, disabling kexec handover\n");
>  	kho_enable = false;
> 
> base-commit: e1fe7daedae7a4a23aca6dbd58e1746750b632dc
> -- 
> 2.56.0.385.gd3acb90ef8-goog
> 

-- 
Sincerely yours,
Mike.

