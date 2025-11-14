Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF953CE8D4F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 16:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B77D8E0010; Fri, 14 Nov 2025 11:15:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1675F8E0005; Fri, 14 Nov 2025 11:15:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A4C98E0010; Fri, 14 Nov 2025 11:15:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC36F8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:15:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8053958EE8
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:15:38 +0000 (UTC)
X-FDA: 84109713156.09.6714F73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E823010000F
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:15:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UZwFnJlV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763136936; a=rsa-sha256;
	cv=none;
	b=5XCEHR3NmHj5OWzZLBa+4YTs/LoHYCiHb4QkAZAos+iyns9h4Jb1i6jPZedMsPs0CA9ARx
	SyuhkLzkMTacy0qF72/9xr+WWgeSn72pEYZ3pTnAzZO3Bw1744PGeUo611uxk7f/dH152X
	10bgAN8u/i5W6bvBoNODwK0IF83Mer8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UZwFnJlV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763136936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUEecNRoeBKG0XiBz+zcBfCaqxy8Kw7OvPQ59OVjlp8=;
	b=eth26EpocZZij5p1Vb3anOZU4ymO6DMb22xTLc2yxspgUZcTm/lAZI7vP7q03W1JmrwC+E
	HP1CHrednGPciWR3EzIZp1j/jTDrX3hy+g9TQDKNR97JT7yyYx+25DC2yqB4cZlKRE/8b5
	G3WPCA8isuH8Zs5ErXtiuKHC/h3/jio=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 14E5F60174;
	Fri, 14 Nov 2025 16:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E27C116D0;
	Fri, 14 Nov 2025 16:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763136935;
	bh=mS05zN0VOwxcIzYeKKKWbjayWEtwO0xQ9kdg6GbidOg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UZwFnJlVY28QzM9QIPLYI58Lo7h47lF3Ah6v4Eq+44AwDgv3fODBre/S6VrWs8hth
	 BlZS3y6bx+osk95r4i8m8r7Fe/sCVNuR5NoKt8h2PJOD8e/lz76TCOtXdnlh3Q3Rth
	 +EOVlg9JTIMGb4+o5+0Pt6mZ/qr/3lfRQ2ToalES0NHGEyDAf0ejHk72tlOaIuQ6uw
	 e8u44IuwWr3SK8UJCCAeydFyOv90rnPB3OogbeL4dbg1R4cguV7ca3DViK6WYTdrRO
	 PbWyboobPJKmEv7zB8f03zlqyNvbC0W9X+Aw6SNlXf5Rj3/n3sD+/B/vQ2V2CZUqiS
	 Mon4k6NpRynJw==
Date: Fri, 14 Nov 2025 18:15:27 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, bhe@redhat.com, jasonmiu@google.com,
	arnd@arndb.de, coxu@redhat.com, dave@vasilevsky.ca,
	ebiggers@google.com, graf@amazon.com, kees@kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v1 09/13] kho: Update FDT dynamically for subtree
 addition/removal
Message-ID: <aRdVn-e3Wu_pFdmZ@kernel.org>
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
 <20251114155358.2884014-10-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114155358.2884014-10-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E823010000F
X-Stat-Signature: 4a4jz7uwnqnunjpwa1tchjp6ikcka3yr
X-HE-Tag: 1763136936-603317
X-HE-Meta: U2FsdGVkX19Dgy1CMLf/j6GQsptlovAwsGYWWAROded/9tyyKAxZ5ojTGLxaIyolsjMx52H6MWX4GGgI2qTiMTEcpbbKqiUD3rFBwmHQeGCbPeVhtWYd5lZLgx3xZn7SsJegoYzWTHPZ2vSPGZTNx/3i+VuaLoFzGv0ImoJCUuieLwo5Uu3tWVHDXlRXTWDSRWYZnBdSck7NDTfLdZW+J2ob0E5QCzu2wz52WgL5AC+FhwmEabt9NGMmfdwpfz4jAPObviwMZPYtgItFKOod5LHJcarbgcTo6lrRCCq+RGluhriwVFrvGMYez8yXCgi/ZcKBEGhst7kBa0HtupQipc2YzSf9Ib6l+XbGtDaDMvrU3rZS1+ss7koa52fizfd6k8TUVFtTG729w6/uq7hqEebomLaV/1nvenB7P7SR4Wy92YM5cCkUyhZCpj6tboljPJfBk0bnxFDUZnGUFLI9ZWFON0XuDUtZQ/VdxhfjWzu/hvDQ7VkkY7qdhcJzq5qxst+slyKf0pQwmr7mFtSqCVHNud2tkYpqleSLaBwi0Wy3C6devkPkI6sm97u7xntmimVOt1vxNMkxY+t5oqn70QN3MzkeHp51kbKj2aXqJ56BM9h7U4WOHEp5zmnheS4T/WLeH8k/KDeqUlLJzZ7SrYz4z8nlnS3dAFuBZASpBcNqpg2RzhWj9nqEBpBUNSneH4aiIWPz22aTsMGRASKdkQMUI9Gu5EMivIiLHPZGTDYt01rzxxYpLZmz6KlTXGlB5DDibP3KykUh7AuKhSLKHqEOMlT6hZpd3VRS5h1ZxoYEHh55RAHRA+A1hbHRZGIEwL5aMz6ExlbUs3a9Cd6K7/N/3pXbBY1h+Ky7dkzuj6rA0odSXs2Q20GuIodmOHkNgsb2SnTxI5xXPlw4Sy7rx5o8Lv6QbMBemXOie2PV0yHvIEecMFQ7OUZ6vVjBCYfjekZ9nCEA9B0oZb/Eu9Q
 cDyfnUR5
 Kp7mZxkz9Ucdn7KP5nbKxqCHg4NhbQAeYTlNjXeP6fiQSD5Bwjffo8dxKV5OJXrs+WcsijCKd5Yd75dMs9jPu4TRpZAkUmNv+1GNOuDekp7ZyOWBfK8txO80aT38q7MMqx7i4/vm2zE8g7CfOr4Y29m2rSq0xM7z9PoDr46PY+q5avQ6ENLlnHZt0DzOqfRiRKhWvLHxp4sZXdHu8ew2jTFmUP3/Z/pEYxyEsBk7BXi5jwAM7nUBARKPBk+7xI+raLNjbxZz42glDMghkIBupsfLK1eoX7lTy7xRl16O7qDKCu5hjXSVFi1s/Dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 10:53:54AM -0500, Pasha Tatashin wrote:
> Currently, sub-FDTs were tracked in a list (kho_out.sub_fdts) and the
> final FDT is constructed entirely from scratch during kho_finalize().
> 
> We can maintain the FDT dynamically:
> 1. Initialize a valid, empty FDT in kho_init().
> 2. Use fdt_add_subnode and fdt_setprop in kho_add_subtree to
>    update the FDT immediately when a subsystem registers.
> 3. Use fdt_del_node in kho_remove_subtree to remove entries.
> 
> This removes the need for the intermediate sub_fdts list and the
> reconstruction logic in kho_finalize(). kho_finalize() now
> only needs to trigger memory map serialization.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 144 ++++++++++++++---------------
>  1 file changed, 68 insertions(+), 76 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 8ab77cb85ca9..822da961d4c9 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -724,37 +713,67 @@ static void __init kho_reserve_scratch(void)
>   */
>  int kho_add_subtree(const char *name, void *fdt)
>  {
> -	struct kho_sub_fdt *sub_fdt;
> +	phys_addr_t phys = virt_to_phys(fdt);
> +	void *root_fdt = kho_out.fdt;
> +	int err = -ENOMEM;
> +	int off, fdt_err;
>  
> -	sub_fdt = kmalloc(sizeof(*sub_fdt), GFP_KERNEL);
> -	if (!sub_fdt)
> -		return -ENOMEM;
> +	guard(mutex)(&kho_out.lock);
> +
> +	fdt_err = fdt_open_into(root_fdt, root_fdt, PAGE_SIZE);
> +	if (fdt_err < 0)
> +		return err;
> -	INIT_LIST_HEAD(&sub_fdt->l);
> -	sub_fdt->name = name;
> -	sub_fdt->fdt = fdt;
> +	off = fdt_add_subnode(root_fdt, 0, name);

	fdt_err = fdt_add_subnode();

and then we don't need off

> +	if (off < 0) {
> +		if (off == -FDT_ERR_EXISTS)
> +			err = -EEXIST;

Is it really -ENOMEM for other FDT_ERR values?
		
> +		goto out_pack;
> +	}
> +
> +	err = fdt_setprop(root_fdt, off, PROP_SUB_FDT, &phys, sizeof(phys));
> +	if (err < 0)
> +		goto out_pack;
>  
> -	guard(mutex)(&kho_out.fdts_lock);
> -	list_add_tail(&sub_fdt->l, &kho_out.sub_fdts);
>  	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false));
>  
> -	return 0;
> +out_pack:
> +	fdt_pack(root_fdt);
> +
> +	return err;
>  }
>  EXPORT_SYMBOL_GPL(kho_add_subtree);

-- 
Sincerely yours,
Mike.

