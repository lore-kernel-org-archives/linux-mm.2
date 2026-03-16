Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F26B0F4644F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 11:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 516466B01A9; Mon, 16 Mar 2026 07:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4096B01AA; Mon, 16 Mar 2026 07:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6046B01AB; Mon, 16 Mar 2026 07:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26ED56B01A9
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:09:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D12AB88B61
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:09:58 +0000 (UTC)
X-FDA: 84551656476.15.2824928
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id E5B524000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:09:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=FyiTwwV+
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773659397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZL2bgode2vAt2OHP2/8t7Ara1fNH4s4w9EznBHpivw=;
	b=edqWgKqOTatp5GODdhG25is3j3h5RowbQZoJW2Lkr44dPf3w0N2tfdW2bUduslCGf4OneH
	31Y1aByT8GjwWY3jhVtYd1tWfWWEWdA6Ni6ScmM8D71UQGyjwUVAbsQbF4SwhO5yWI+KdH
	IiMu9P53RB5uLFy3VwvC8WFmySEsn/s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=FyiTwwV+;
	dmarc=none;
	spf=none (imf11.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773659397; a=rsa-sha256;
	cv=none;
	b=hXKuUzrdixQJOPA8emYvtF0Y8TNDthUPHQejTY46cDByRSTAKKpDzgX4a6cgkXchsOqwP8
	qkVVT5/JsIkR2W6dgtK+7QspzPGpR4I9kE9pcMis6o+f8RWH85OA1l+kOUeDgGpw0vncj9
	4loHHe9PFP3rfOSKcmRulPwgPERdZj0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JZL2bgode2vAt2OHP2/8t7Ara1fNH4s4w9EznBHpivw=; b=FyiTwwV+9NvW3WHPFOYHEDVBcW
	3mj3heMZibE7ObGWZHDyqshfsIZq3czXuoBSKMR1bW4Gk3mLHzsNByOIVsw8+F+HfrdQYsny/NhfL
	MUMVuXyrWmHZdZsOZE3lhpwYK9Gdqf12CLZ6yg83sNWCaME+d1gWOFWgTdmyYk+PUnOSIrBaqnU+K
	wZl3IJseSbq+xllzRYWzZOc6IO1+xhkLWqd9cs8WVT70vGBOwpmmdP2rUW3QUlUnWMDzthejTvbmu
	3LwO4LHeFCYx5Sohkn2sE5Yx+lauTchJpbKjZltDmylLJbTAqm1/5FRcD15EbP/WhPCnaZlsPg8Nf
	woSHgZVw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w25pV-0024X3-H2; Mon, 16 Mar 2026 11:09:48 +0000
Date: Mon, 16 Mar 2026 04:09:43 -0700
From: Breno Leitao <leitao@debian.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, usamaarif642@gmail.com, SeongJae Park <sj@kernel.org>, 
	kernel-team@meta.com
Subject: Re: [PATCH v8 3/6] kho: persist blob size in KHO FDT
Message-ID: <abfkVOjq1ngZb-Nm@gmail.com>
References: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
 <20260309-kho-v8-3-c3abcf4ac750@debian.org>
 <2vxzbjgsgk41.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzbjgsgk41.fsf@kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E5B524000E
X-Stat-Signature: fmz9u5mu3fe8c1ipnpan54qa6h18c1b6
X-Rspam-User: 
X-HE-Tag: 1773659396-221492
X-HE-Meta: U2FsdGVkX1+s6nCD7OBuH1Um7Ef20f0/DhLvSHvksTtXVugI90uKdY3L+Z7G0cMDn9UOzZLpBdXJrCzjEAEHYOPo/44zk+Q/G5lc1pEcQOE1m0BMAW4mUjvdVqw0sTfbhmjXtNy8huUI7YGlfNc6U04IDnTsSMSNm+MEK02ysomLFTqW5qa+yUgld6XTi6TD3Pi4FaT44KeQo+t/i6ia8bWKKFUuX6bIlSCCPrAMYaJZuadpH3qSQninXIW4ZW4zvW94U3vCSi7C073B2+OVxXrLP8YJgDKFaQRqs8UNdVu93915giNd0wPxLZzDyA0sVS2p8FgPINkAw38qZ0EbRiK6WKPAof407PCxVsxxv/fQxgt5NCmsokGQQww8SCwVHRPM7KzJ7/DOelfkTSPxqF1nqHDSiglC+D7DDxMqa315NVqAMNNbx5wlEDgv6YM81lschPLByCHh8ESU1JfPIYoJu6XKd/34K6ZFJaNY018ExR6Z+A0OIqKVVfySE6tMvJsCITXtPUJW8ZPwyzikjQJTt3eoDtXHmjmThFBBu3Yg5EOsu1vFL0pzmmlpSk8a1qNn1T1q7ZZ2ucwHiTFdL9QIjmodKDqBWUeqsrx93X8XuArsOa8GvbkCXOggrvCRcRsMefiXkfmxTSER/ZBkK0uL7m62fK59SrBx/HGI3nfnCz1LQP9uwLSlT7sqeHzYunCoru2iagzUJAP0oVZI/0PGqaNTH8E67AqqRz+dBtLiABc1q/K+1wbpxKSb4xp1tjgWfiivhpiAiYr0yQspspMDKZvKq3wAp4PsBvOKPdKF2lDPTA/YBJ8M1to6QSbUD+20HlirXrRSG3MB1aPKJSRCAyZAXDlOJ6AwoivvXHhvUXm0t4KAtN1uyoWIwdAYqIG1iHdSi2w+dh4RbmYGhezmYLhtVIIlQfiQE3YG1zhEFRRQzVJuPRhknP0eyZ1mIF8hF9JRwx/Xo1HiUSo
 rZUkiAJm
 NcD7mwHtjyoVe9Q1JlZcaegF5XUXaswWpsm9NjM/duecJpMwZOaI84f79XXOGe2F+ZfMqbkjAj6qccXeMPTU6t2SLhwfrlkhcWMvcFMrqrgzC3OorlMkG87nIsbHd39/7Rppt3Q2uqAB0Vcko+xMtn/hHSo+K6obH2rDWrT9glUJNV88=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 09:21:50AM +0000, Pratyush Yadav wrote:
> On Mon, Mar 09 2026, Breno Leitao wrote:
> 
> > kho_add_subtree() accepts a size parameter but only forwards it to
> > debugfs. The size is not persisted in the KHO FDT, so it is lost across
> > kexec. This makes it impossible for the incoming kernel to determine the
> > blob size without understanding the blob format.
> >
> > Store the blob size as a "blob-size" property in the KHO FDT alongside
> > the "preserved-data" physical address. This allows the receiving kernel
> > to recover the size for any blob regardless of format.
> >
> > Also extend kho_retrieve_subtree() with an optional size output
> > parameter so callers can learn the blob size without needing to
> > understand the blob format. Update all callers to pass NULL for the
> > new parameter.
> >
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> [...]
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > index 54fe59fe43acd..1f22705d5d246 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -768,6 +768,7 @@ int kho_add_subtree(const char *name, void *blob, size_t size)
> >  {
> >  	phys_addr_t phys = virt_to_phys(blob);
> >  	void *root_fdt = kho_out.fdt;
> > +	u64 size_u64 = size;
> >  	int err = -ENOMEM;
> >  	int off, fdt_err;
> >  
> > @@ -784,11 +785,16 @@ int kho_add_subtree(const char *name, void *blob, size_t size)
> >  		goto out_pack;
> >  	}
> >  
> > -	err = fdt_setprop(root_fdt, off, KHO_FDT_SUB_TREE_PROP_NAME,
> > +	err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_PROP_NAME,
> >  			  &phys, sizeof(phys));
> >  	if (err < 0)
> >  		goto out_pack;
> >  
> > +	err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_SIZE_PROP_NAME,
> > +			  &size_u64, sizeof(size_u64));
> > +	if (err < 0)
> > +		goto out_pack;
> > +
> 
> I noticed that the error handling here is a bit broken. We open the
> subnode for the subtree, but then if we fail to add the "preserved-data"
> property, we don't remove the subnode. So the next kernel gets an
> invalid FDT (per KHO ABI) and might as well refuse to parse it.
> 
> Similarly here, the FDT might also be missing the size and then the next
> kernel might reject the FDT.
> 
> Also, we directly return the FDT error code to the caller, which
> wouldn't make sense since it probably expects -errno.
> 
> Not something this patchset has to fix, but I am pointing this out in
> case someone (possibly also future me) is interested in fixing this up.

That is a good point, do you mean a fix like the following? 

commit 633d0cb01ed959676b60de8b1851dad1757d8fe5
Author: Breno Leitao <leitao@debian.org>
Date:   Mon Mar 16 04:03:51 2026 -0700

    kho: fix error handling in kho_add_subtree()
    
    Fix two error handling issues in kho_add_subtree():
    
    1. If fdt_setprop() fails after the subnode has been created, the
       subnode is not removed. This leaves an incomplete node in the FDT
       (missing "preserved-data" or "blob-size" properties), which violates
       the KHO ABI and may cause the next kernel to reject the FDT.
    
    2. The fdt_setprop() return value (an FDT error code) is stored
       directly in err and returned to the caller, which expects -errno.
    
    Fix both by storing fdt_setprop() results in fdt_err, jumping to a new
    out_del_node label that removes the subnode on failure, and only setting
    err = 0 on the success path.
    
    Signed-off-by: Breno Leitao <leitao@debian.org>
    Suggested-by: Pratyush Yadav <pratyush@kernel.org>

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 62b1b8a9aa337..8d2d30119f6d4 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -787,19 +787,24 @@ int kho_add_subtree(const char *name, void *blob, size_t size)
 		goto out_pack;
 	}
 
-	err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_PROP_NAME,
-			  &phys, sizeof(phys));
-	if (err < 0)
-		goto out_pack;
+	fdt_err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_PROP_NAME,
+			      &phys, sizeof(phys));
+	if (fdt_err < 0)
+		goto out_del_node;
 
-	err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_SIZE_PROP_NAME,
-			  &size_u64, sizeof(size_u64));
-	if (err < 0)
-		goto out_pack;
+	fdt_err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_SIZE_PROP_NAME,
+			      &size_u64, sizeof(size_u64));
+	if (fdt_err < 0)
+		goto out_del_node;
 
 	WARN_ON_ONCE(kho_debugfs_blob_add(&kho_out.dbg, name, blob,
 					  size, false));
 
+	err = 0;
+	goto out_pack;
+
+out_del_node:
+	fdt_del_node(root_fdt, off);
 out_pack:
 	fdt_pack(root_fdt);
 

Given this is not strictly related to this patchset, I am planning to
send this fix separately.

> >  	WARN_ON_ONCE(kho_debugfs_blob_add(&kho_out.dbg, name, blob,
> >  					  size, false));
> >  
> > @@ -817,7 +823,7 @@ void kho_remove_subtree(void *blob)
> >  		const u64 *val;
> >  		int len;
> >  
> > -		val = fdt_getprop(root_fdt, off, KHO_FDT_SUB_TREE_PROP_NAME, &len);
> > +		val = fdt_getprop(root_fdt, off, KHO_SUB_TREE_PROP_NAME, &len);
> >  		if (!val || len != sizeof(phys_addr_t))
> >  			continue;
> >  
> > @@ -1314,13 +1320,14 @@ EXPORT_SYMBOL_GPL(is_kho_boot);
> >   * kho_retrieve_subtree - retrieve a preserved sub blob by its name.
> >   * @name: the name of the sub blob passed to kho_add_subtree().
> >   * @phys: if found, the physical address of the sub blob is stored in @phys.
> > + * @size: if not NULL and found, the size of the sub blob is stored in @size.
> >   *
> >   * Retrieve a preserved sub blob named @name and store its physical
> > - * address in @phys.
> > + * address in @phys and optionally its size in @size.
> >   *
> >   * Return: 0 on success, error code on failure
> >   */
> > -int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
> > +int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size)
> >  {
> >  	const void *fdt = kho_get_fdt();
> >  	const u64 *val;
> > @@ -1336,12 +1343,21 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
> >  	if (offset < 0)
> >  		return -ENOENT;
> >  
> > -	val = fdt_getprop(fdt, offset, KHO_FDT_SUB_TREE_PROP_NAME, &len);
> > +	val = fdt_getprop(fdt, offset, KHO_SUB_TREE_PROP_NAME, &len);
> >  	if (!val || len != sizeof(*val))
> >  		return -EINVAL;
> >  
> >  	*phys = (phys_addr_t)*val;
> >  
> > +	if (size) {
> > +		val = fdt_getprop(fdt, offset, KHO_SUB_TREE_SIZE_PROP_NAME,
> > +				  &len);
> > +		if (val && len == sizeof(*val))
> > +			*size = (size_t)*val;
> > +		else
> > +			*size = 0;
> 
> If the size property is invalid, is it a good idea to ignore it? Should
> we instead consider the subnode to be broken and reject it entirely with
> an error message? Because if a caller expects a blob of 16 bytes but
> gets one with 0 bytes, it will likely error out anyway.

Ack, let me update this, then.

Thanks for the review,
--breno

