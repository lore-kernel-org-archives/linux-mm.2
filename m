Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE48606D81F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 22:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=RQDT1ifx
Received: by kanga.kvack.org (Postfix)
	id 2BE1C6B00EF; Wed,  4 Nov 2026 17:55:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 295A56B05B0; Wed,  4 Nov 2026 17:55:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ABFC6B05B1; Wed,  4 Nov 2026 17:55:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE1D56B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:55:18 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7EFCB1401D9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:55:18 +0000 (UTC)
X-FDA: 85398944316.05.85CA0AA
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id B16921C0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:55:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=RQDT1ifx;
	spf=pass (imf20.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793832916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/zbs/VJDYV0GvGSr2Zgo/ryZBI/tPePChlLCcPRtDrw=;
	b=Xn8RD7EgxLaFex4R5grbaZJYYeuGWupgC8kQrN4Jkr54bcqCRCMzEFTPsRdai2xOHLwSid
	avwooOR0thmkii6YP4GnYy7qnWv6hbpAaAcRtw5DdLKD6v0+yDujL8UzfUaAxND4zHiQah
	F1dZCesP1Gyiu6L0se38CSYymcwrDp4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793832916;
	b=sXlmeRmQK7FXj1Lhg16MN0oN5j4tZFEnLSepIMbUvCkCzk3Nl06Fwbeae+QbNhQSNoGQM6
	EwBtuO7NfljEFAfpD9tUYTktVQgjlPMPRjlBsn7EeX5XGWcWo6vtEjUrMhO7gIKew9Q0CX
	onMLGSdu/1MHTDmRVhctNTV8VBiXDYw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=RQDT1ifx;
	spf=pass (imf20.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ea7f9c11e6so21395ad.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 14:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793832915; x=1794437715; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/zbs/VJDYV0GvGSr2Zgo/ryZBI/tPePChlLCcPRtDrw=;
        b=RQDT1ifxkxV+9SA3u9MXDlTzIOTUlv/z2FHWSVotk9nnaRvyvpHm9aNFXizhvAuUc6
         vh7/oNrt9v5aBKq2vNCMGXzrBOgff6jzf96AV7w4v7wlnlJDfeKHtoyV5yxy/Cj1fqNm
         9yBxFw9ffdxh2VnMZOroWjkUUiFh5EE4VQSf/PprBXCgq3rJjP4KvDW0Cwfqn972nnXL
         hgl/6MX4r1ht8lMCquuwiX6dtr764clwsCZfNTopV7sp9EwmIG5bS19SbynnQ2cqWK+w
         wZxfsFt5L6vu0EKrp7vji54rkIQFkHwxGjIJTkHcPupJGcUZsg3s2hJ8zM+a14yRSPw6
         b/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793832915; x=1794437715;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/zbs/VJDYV0GvGSr2Zgo/ryZBI/tPePChlLCcPRtDrw=;
        b=HYkH5bWyE8BArpegdju4NqiZrVUpd1fCYIHivEcGeOtGZ8aAYnusgUyHvt0xA78iLW
         +MprTvXqn3qxY/18NG/OtqpBbGgyI9A23Z1mzyj8raBaqY7+ZmjGEI/7en7sl5GVsW8u
         0Z9KBuTBKGocSu21dvA4rfYt0fsBLjctYVF+umCXk8pTBarenqqS0Ci/eALgDlhf97pM
         575ELvyZMlehU7Y18H3ZktnFg7tK42zUf1u6cLowDAP7Z1BCNQMWnceiofWWfEr+WZ7v
         s/Z6dwhxgtGt4NjHhg+5hfAdWAYe9NwD1jzqrUJLOWZ3OZYfqFZCqY87ClxHPDitvH2J
         o5ZA==
X-Forwarded-Encrypted: i=1; AKwUvBw/MZfaOT7lEO3JfZbR+eHEn8YppCLbt+Xmpx//z2LTTW/vtiO0DRIwCRsjLw73vwroNUrSHt6poQ==@kvack.org
X-Gm-Message-State: APuU4Z+zyIedJtiFiGThbqkC33Q520XB0t8ojuBUoLzt/Dti0SQMG6fz
	MDjDDZZO4nubkS8etnhsJF/EO0Hm6K3qFQ6lU074bUQc1wUS8ZflqYZSEwn48KwnvQ==
X-Gm-Gg: AYBFou2GK6SAfF4u1i/iHLx2dSU91dfqGSqx1aGBCbE0/M1eWhl0oMllLFuUql6lvDx
	+jAJ4wx7npEV83ncD3zLUladQTGgb59hskDblYljc1Wlqu7oMcrViJdZd6QH8xhJxj5mgcb3wMP
	b1AE4SF61gt80UHCwnj5AulfMg/PIft7VTT5ckZbGxko47R60ibSQjCFDX0rvlvuQCoXYazov8G
	1xtnL7R0OBK/KTED4kET1Q7RdT/rFg5S0xVmOkWl0UeL6TjKmdfdAou9bjF2lTxPd8wC/iaQ5m8
	gTPGi/9vUqz5kBXKEj5ypHZbK97dDpDgpn305qEghWF/eVm55VwHUZfU9lZOyBGO6DPVcNwICqc
	cOCN+KhUl0l7edPfamDcG+bfWdYNvKAbo61ES+GP2CBsaKyd+pMSptdWDNp4NFGF33qZJ0Khn1v
	FgIVEvNlROYhM6VwNqlZbR6auRMmsMBOgdRQ0+1X7TmeZHG65hrKyR6jb5rFZy3NTuD1iYGRNI7
	QHb0daBTp37MJiKzpLyMsNlCgw+XgdNJkMIFyA0Le6L/zvBdqCuzWD610nneGtduNVjnwW6fcUt
	NL2CBYr7ipBHp40kxCIiPu8m4c/mxoU0gRPUdk/d05T6yASnGQvWbof9EZAcbR+QMQ==
X-Received: by 2002:a17:902:db11:b0:2dd:3a08:d47b with SMTP id d9443c01a7336-2ed27e06d7bmr1039485ad.13.1793832914948;
        Wed, 04 Nov 2026 14:55:14 -0800 (PST)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b09455fbdasm2528714a91.0.2026.11.04.14.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 14:55:14 -0800 (PST)
Date: Wed, 4 Nov 2026 14:55:07 -0800
From: Vipin Sharma <vipinsh@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, 
	ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, ankita@nvidia.com, 
	apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, christian.koenig@amd.com, 
	corbet@lwn.net, graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, 
	jgg@ziepe.ca, jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, rananta@google.com, 
	rdunlap@infradead.org, rientjes@google.com, rodrigo.vivi@intel.com, rppt@kernel.org, 
	saeedm@nvidia.com, schnelle@linux.ibm.com, skhan@linuxfoundation.org, 
	skhawaja@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, 
	yi.l.liu@intel.com
Subject: Re: [PATCH v6 05/27] PCI: liveupdate: Add helpers to preserve struct
 pci_saved_state
Message-ID: <20261104222438.GB511751.vipinsh@google.com>
References: <20261102153656.1431701-6-vipinsh@google.com>
 <20261102230624.GA1038787@bhelgaas>
 <aukvTvnfyAvahb51@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aukvTvnfyAvahb51@google.com>
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: tmq9gxs53ty5a355xpf4ojmfhosptgn6
X-Rspamd-Queue-Id: B16921C0005
X-Rspam-User: 
X-HE-Tag: 1793832916-856775
X-HE-Meta: U2FsdGVkX19NhzgiQescQz89yMTLOAB/hWFteUcPDG+GELFLvJmu1tRfuV/SzXQwfJkSwb7VRO9KL9tIUSSltExJJiCbk4xhvH9D2LNmBRh83fLSlHmBSijoEzU/zTtZHc12id0H5Q12EkSuCtwcSvvMK57HfmiuaYVCoPWaHJE/QcweObY1OoxcBcjxiTcCO+Kdrqy/R/PBr193sIDCjZRS+ejj/rtXdjSzOSY+ahFvicVgjp0AYIYYRPipW36KICjiEGsO9mBajsVT5ljaOvf2Kz7/Lem5VLrsrUeQrB1hZTiEnuWvhMl3RgE5fy53NchXvHICDe4A9UOEqEBk+5aOpEk8h16yF7rJ9RIZjPVmagCl6Z5VugYrgEb8Ixk1C6dxedwNfjuRzPDo3ZJsMNGuN6UZAsv9G3aQtm1kSDZo1MaibVrv8zeWBcMnIm7nTGL5ybM6/ns59PGGUUzMMHHOOILhttytlm3Cqx5ZnO6TX4dqH2BNoDr+ek/OBMA9IuocBbRFBCUPPS+XOUg9VGwII9gJxSTRJrAGt1iua8LZ1Wu7leWcaPIpABbTs43cVMkfrDIfj/MHVdEeziB6CcyXikaTOC5BApzSKUHRjqQfePd2D93936vAyrsMt0Fw8kSr7/RXtj5TE275TPMlWqgidb8yvPkidrRn0LU1XG3fLH/DP2xSdatA5DObR5mksq7Q+z9nklj8ujsEZiJRGkcc7Ob1sYYJF44IgPLDa1afL+ZI+MyPII/lppvXhRfWXV58Y1cj6iFW0rX+qw7rgR42zPBVNr7mb8efF05S0MAB/IHxNImOFruBcuKHMFfPHDX5XCKTm+qi/QXgt7IrqGUZ29HUQ26Gpb+LtaSPqQWYnmkGOoNfv29k8qefS3y+r8dDZ/hBtaEHzuSGK4JeaiLMAeTlGaGeRS+PNiPmxh8my89VWbQLL7lMwJ04E/7RHPXUM3zJYpVywlHtTiQ
 a3Ob6B6C
 nuD0fOtfI86ZqosrNhTyv8nRWKIgPlOxIWu5++v/D0JA7/SfyLcodeR7CAehDYuT2GQq48ZfYYZvNgwbmOI9aIIPPG/WKi2lmz1IMGLRBQe8PVdQWOp9W7QCtycIKQTuFWawRY5bPEcU19tfNov6f9//EsXzlQDJ+zWo0jMf36uqJPVjg+HPBZS6dEmITPlcxnpP6//N2W0Et0n7h71JIGmzg51lyPMVxutG18mj71KJ2HkvY23eAlBD4DjGK0qbcka2figptle30LRI+phTfVEi86q2KDrcl6ymh8rWYQrgyYmbpsddqdj4/YqgDIBNfzbC9k5b7bVzZN9capGb2weP/JZNMEz3gXlCtTGOs2/ukOAEJLjfZVvgYW1lOZKB7C3TSqGAk6C+K4KCGF1tPJ042XqqHOQsNg0vq8j/iBMef/cc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 12:48:14AM +0000, David Matlack wrote:
> On 2026-11-02 05:06 PM, Bjorn Helgaas wrote:
> > On Mon, Nov 02, 2026 at 07:36:34AM -0800, Vipin Sharma wrote:
> > > struct pci_saved_state is private to the PCI core and its in-memory
> > > layout is not a stable ABI. Add helpers to serialize it into a
> > > caller-provided buffer and rebuild it in the next kernel with a stable
> > > struct pci_saved_state_ser ABI. Using caller-provided buffers allows
> > > drivers to embed the serialized saved state directly in their own
> > > KHO-preserved data with a single allocation and lifetime.
> >
> > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> We discussed this patch off-list this morning. I'll sharing the context
> here since you were not there Bjorn.
> 
> The ABI added by this patch is not actually stable across kernel
> versions.
> 
> struct pci_saved_state_ser is stable, but the contents of each
> capability entry are not:
> 
> > > +struct pci_cap_saved_data_ser {
> > > +	u16 cap_nr;
> > > +	u16 extended;
> > > +	u32 size;
> > > +	u8 data[];
> > > +} __packed;
> 
> @data is a memcpy() of the per-capability save buffer, and the layout
> of that buffer is not defined by the device or the spec. It is whatever
> registers that capability's pci_save_*_state() function happens to
> read, in whatever order it reads them. 
> 
> None of that is described in include/linux/kho/abi/pci.h, so this patch
> implicitly turns the private layout of every capability save buffer in
> drivers/pci/ into Live Update ABI. Someone changing
> pci_save_pcie_state() or pci_save_aer_state() has no way of knowing they
> just broke Live Update compatibility.
> 
> And these layouts do change. Commit 898585172fa7 ("PCI: save and restore
> PCIe 2.0 registers") grew the PCIe buffer from 4 to 7 registers, and the
> AER, LTR, L1SS, PTM, TPH and DPC buffers were all added over time.
> 
> This is the problem I was trying to solve with:
> 
>   https://lore.kernel.org/linux-pci/20260924173501.856380-1-dmatlack@google.com/
> 
> That series replaces the per-capability buffers with a single store
> indexed by config space offset.
> 
> Where a saved value goes is then determined by the device's config
> space, not by the kernel that saved it, so the PCI core can change which
> registers it saves without changing what the data means. Serializing
> that for Live Update should be trivial (a size/flags header plus the
> bitmap and the values). The cross-kernel compatibility question also
> becomes explicit and per-register ("the previous kernel saved offset X
> and this kernel doesn't restore it") instead of a size mismatch on an
> opaque blob.
> 
> Bjorn, this is also related to your last comment:
> 
> > I think it would be helpful if the names of "config_space[]" and
> > "caps[]" hinted at the connection between them (both are in config
> > space).
> 
> With the offset-indexed layout the two are no longer separate. The
> header and the capability registers are all just DWORDs in the same
> config space map in struct pci_saved_state.
> 
> So I'd suggest that we land the saved state series first and then rebase
> this patch on top of it.
> 
> I can send a v2 of that series this week that addresses Josh's feedback,
> rebases on top of the PCI Live Update v10 series, and includes the
> serialization helpers. We can use that as the basis for the next version
> of this series.
> 

Agree with David here. I think David's series will make things more
explicit in saving PCI state and easier to find changes. I will review
your series provide my feedback but don't stop your v2 on it.

Thanks,
Vipin

