Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81E58606A330
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 00:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HxhgnpKD
Received: by kanga.kvack.org (Postfix)
	id 8290E6B05B1; Mon,  2 Nov 2026 19:48:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D96D6B05B2; Mon,  2 Nov 2026 19:48:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9026B05B3; Mon,  2 Nov 2026 19:48:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39CB86B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:48:23 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8904280233
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:48:22 +0000 (UTC)
X-FDA: 85391971644.03.2B5DAD7
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id B6A10C0004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:48:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=HxhgnpKD;
	spf=pass (imf22.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793666900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4komcI6Fb95Hps7JFHEwewY0Kj5nDX9+u+4ZAxqqJ4=;
	b=OS61/Ef4lvHU7iQi9+ZVnJ/8GAyXoGWX4mf2/o8EAPn1QiDLhgAO+SFT5aH5txtjRSIdUn
	VQLYYeMWTTDcY6INs9xjFTmTbcHLMl+BD09OM/R8dO5Q5TcJOSJymhNJeRBhoXUXM80Dar
	k+8PZrFxei7Meo6UrLMJ60KrKs9ttnY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793666900;
	b=QJSW6VZx6qslc08rjssGrpZvk1SJi+jKnY3u/mc95nZLi5ksbSQnTv5EA4erLJBFMLp1Qo
	9LmOWFpBmx8CVnELS0hgBNU3zb7bGAzjgAkpiYwoNhaH4Gq3n+fzL9JZaUjVRJjwF5EPFA
	PdJNzF2s5S3Wtud99W8M6Fv2jO96Ie4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=HxhgnpKD;
	spf=pass (imf22.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3adac5c10e3so2243602a91.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 16:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793666899; x=1794271699; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+4komcI6Fb95Hps7JFHEwewY0Kj5nDX9+u+4ZAxqqJ4=;
        b=HxhgnpKDDjCi/ZjXHCW4B6poh3cLfHSUNwIiYBut3e8ryCh2IfM4fNdo5cwhTaQqOR
         jtBK2TbKweJVTOx+LNIa5jBUVQvhe4nxjapMhGNSjV/OnS3gOiMaAmCG3uWvKpRFDa/T
         PRrHGD/dZuwK7+9xO6KX7ivOs/dbP79TTwgWa5kxRqZAQ/p0wHFhdf+o2W7/hb2g1HRO
         GmRT6gh0yXD9rGC9mw08qZdowHD8b63ZLZdIchCHYZCbR8gC6sbjGJKZm2KYJcekm0kO
         v+2ea40e1qd+OkdzbAspLa3boPQE1KTBQ55wnl6K+CtveyijUdaq4XBPr/MO12wp8JMR
         edLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793666899; x=1794271699;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+4komcI6Fb95Hps7JFHEwewY0Kj5nDX9+u+4ZAxqqJ4=;
        b=OXJFYSKMSNUsBBd6pAsVoU7VTnhDgYHH508YgmppCYtoZ3QWVdYOE+InoDrdjYleGd
         BIer2YFHl1LWrvSw/LMmU7jqSvUK0Y6irfHR/CjXJyT1I0+qTdW7ixboEztOPTvyd5NW
         208leNdpErWloNrKSy04KcoXVmNDyj0DJm15LOaF+WpoeznNXgEvb6uen332UM0sGjAj
         zmxmgovvDps634pg8jdDsJgq6bw4Cz1WLFcPk1/uOESebWZJzwn8A4PdupFItwDV9KcZ
         054q2x99ZhKiXnljcM7Xvq9kVWBaBf/oRC/7Ny9OdTAf9NmqKLSoAZ0/Tmzf0rK743GC
         SuGw==
X-Forwarded-Encrypted: i=1; AKwUvBwzokunWIoDg9ebmJJE7RVU94+LKRzKtIlqH8YwAZI+CWsMQaK6/Evktttsg4JXYH/deSEJUWPzKg==@kvack.org
X-Gm-Message-State: APuU4Z8ymTyjBQKAQUWHw6p4rhjG2jxPkr7y/hn3ze234MvZCG2I2G3e
	2pZMRzytCnjWQsan7jIymw//3ATT2+9Oh2Qgs4FtQowRF5X58QHZYoFi2x+oNmJnig==
X-Gm-Gg: AYBFou1CTLsNX4BmSpjnucWP1F02+LChT+flXhwgMZJquW5y3AoPky2UBLwyHQNNHsh
	m5gwcfXGMHzWFuwDYg/4HoHr765P6JdgrdHg4gnNXciOrUNGGuU6Qg9+iL8m69FpoAmuPa7iJ0e
	Vgry6F8bTjq+tTuQqV17aEp25g2YWEq4ZAF+DlH8Jev0p8a7mAIYcPwkOibasnSPI9iODkPSqdO
	JATD25e0S6E+C62n3njAc3emOxk3IuP+GirlOLscQ7+7xpRZFogI1GnmIdfikMb9EUdbZPW80K7
	+vg8qjBc97RJe0tnDO8bk84g3ShImFcslJan6UM7AD0OvCgiET0bbbyWzIZISh/fkFizjzUGgd5
	tkA/GkehbVN7lke4+fkOzF7vweUshDqkG/XI6BeVt8MBUKeG+fFLspzEBy/R/YE0FjcHJp9AeYv
	AlEFf9Onf8KDa3L1tdMFzNHX+/FRzFs3XJ86KH18aGP05Rrx1x9RRje8R+BL1vjtZb1qYBIN3BB
	o6IKeGF5R1rKtrd5rnr6jApVisJfxCbQ3GDnGFC+rCdFGHwIZJa3aheoeSUCWXv7VBmUENgMczs
	ygJW8YPOviF+OvuyjdJ7rwLxeybBqn3HoSEhLqsMkF1Gzb8h/ZmmcyjnhXwVnza9
X-Received: by 2002:a17:90a:e7cd:b0:3a0:8050:2ec9 with SMTP id 98e67ed59e1d1-3ae897ccf9dmr9145000a91.16.1793666898905;
        Mon, 02 Nov 2026 16:48:18 -0800 (PST)
Received: from google.com (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c6b3493sm1454586a91.13.2026.11.02.16.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 16:48:18 -0800 (PST)
Date: Tue, 3 Nov 2026 00:48:14 +0000
From: David Matlack <dmatlack@google.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Vipin Sharma <vipinsh@google.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org,
	ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com,
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com,
	chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net,
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com,
	jgg@ziepe.ca, jrhilke@google.com, julianr@linux.ibm.com,
	kees@kernel.org, kevin.tian@intel.com, leon@kernel.org,
	leonro@nvidia.com, lukas@wunner.de, mattev@meta.com,
	michal.winiarski@intel.com, parav@nvidia.com,
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org,
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com,
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com,
	schnelle@linux.ibm.com, skhan@linuxfoundation.org,
	skhawaja@google.com, vivek.kasireddy@intel.com, witu@nvidia.com,
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Subject: Re: [PATCH v6 05/27] PCI: liveupdate: Add helpers to preserve struct
 pci_saved_state
Message-ID: <aukvTvnfyAvahb51@google.com>
References: <20261102153656.1431701-6-vipinsh@google.com>
 <20261102230624.GA1038787@bhelgaas>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102230624.GA1038787@bhelgaas>
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: o14heqbu9nztitkre76dfxmqhhgkaukq
X-Rspamd-Queue-Id: B6A10C0004
X-Rspam-User: 
X-HE-Tag: 1793666900-308395
X-HE-Meta: U2FsdGVkX1/N+Me4qjsA50EJntKtXVL2xv0Wvd5jszlUwjh5C35/wv5UbTi4nEJBFETDrgDEAEoJ989Hj5cw5GBHdEbdDXYWXiipo1lQr1wKOMMsRoNj6jTayshaUnOTZRci99QHgkfCOCCXWHdiKCPMv71DMbVtmvNWsYRC7qJBBqsGZmzEU3cGDRCJLh9/6eEDU0gZ0OsaluzEwSWDHYMDcv4jyIczt6EEfawMkpnO+zDSNNp92jqh5j3O8tuZ19VQMGVB9cO1tTyES8dz2ztI25PMXRb9B9JNnaijXfNS0qqMY3LnV5jjD+tLtpmvKLQP+4zQ0FSxhStN2dFCjItTqdYAGbJa9CNCp4iqkMQye0Jt81rlsA0NoRffk8wc1Kpq5lIgI8U6XPTWdRBx1rpnWTMx6X/wkn9gIYucVfyJJf4dMmOgnPcV4aE3LU+iQZQNCdxei5DNctUKEEgBh0cim/vXNaDBvstMm0upTs33RRtM0K6jS5QBHzRgAIABM7zkgsc7PCQSWo9AQCbOUe4YhARpVy4TRi6s/fzMrd3Z6bhf8GK4arTGTwcr/5FoC/5rnjjwCTpyZLrsRxDMvnmbAWjJ1fKNQl0i1HhxS4biEkwNFunxfLkN8iQ6aJD5XcpMIlNNtqwhPClCkv9Us8/yazFKobIbjRdZQ0TDuTz9YGNTUj3Dxb05GUfY0auIB2y8Ma82tGdflxCBBSOYZsLH1opDA1u7C1buwPGbxlQxRNkf1PDgn3CflXke1eEfbwGHXi5Yqr2E0yDFfY1dBzYZQtXkx7i1xFb7WNZrCj5w5cjmsYGRc1yOJzgX6VyhZaUhEgIJGqx3XKll0ysFuVBN1ZLJAggeLn9ftwBYKu/1q6d1h0ixKSYZtXeWRFTus0HEnTh0DO1+N7jpnSOO40o5Pj7Ur0DJ7wsZXmRTqutGlaZJWuCKwiDs5RRJ7nbvv1cO2yP0VwCCAjSDOfX
 iRxvT+Uz
 be9IV3lSbweBgMFbLdvLzTr6Po5kWcwBZ1wPJ2o0ln0uOE9GXcWHlNZzx+mbh5SK3IZMZj+c1wY964fw8x0zJwt0gUxxJI7Cr4DuExI62WrIwCqkUTV8iCRwv/3yDYSzANkDlgUYpiKR3//qoRmV9DzRvJkkza5tfMhc/foWNNt0kWjj28ZDdXUjvFPVjUNtEQ2l4dCQ7jOA1/bgaBkd/1I4eOl5Cm7fHsJ1JTDjFXf+xKixQafLJcZ6qQHFODFPBp/ECuyI2+LUBbIRhogHIVjRcMQY/eC1Jd3k9l9SzIoFb0gyrwNoZGpLTZHcc6tjfIoja0a9ljhDKQMicUbhRIldlwfjTFq3k93TDBur0BhJ4fzFzzAJFeNTQDOx4KOSAZoYnr9D7knvvrWCIKM5ubjT7pNWggaUSllc8LoS6B/NgA04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-02 05:06 PM, Bjorn Helgaas wrote:
> On Mon, Nov 02, 2026 at 07:36:34AM -0800, Vipin Sharma wrote:
> > struct pci_saved_state is private to the PCI core and its in-memory
> > layout is not a stable ABI. Add helpers to serialize it into a
> > caller-provided buffer and rebuild it in the next kernel with a stable
> > struct pci_saved_state_ser ABI. Using caller-provided buffers allows
> > drivers to embed the serialized saved state directly in their own
> > KHO-preserved data with a single allocation and lifetime.
>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>

We discussed this patch off-list this morning. I'll sharing the context
here since you were not there Bjorn.

The ABI added by this patch is not actually stable across kernel
versions.

struct pci_saved_state_ser is stable, but the contents of each
capability entry are not:

> > +struct pci_cap_saved_data_ser {
> > +	u16 cap_nr;
> > +	u16 extended;
> > +	u32 size;
> > +	u8 data[];
> > +} __packed;

@data is a memcpy() of the per-capability save buffer, and the layout
of that buffer is not defined by the device or the spec. It is whatever
registers that capability's pci_save_*_state() function happens to
read, in whatever order it reads them. 

None of that is described in include/linux/kho/abi/pci.h, so this patch
implicitly turns the private layout of every capability save buffer in
drivers/pci/ into Live Update ABI. Someone changing
pci_save_pcie_state() or pci_save_aer_state() has no way of knowing they
just broke Live Update compatibility.

And these layouts do change. Commit 898585172fa7 ("PCI: save and restore
PCIe 2.0 registers") grew the PCIe buffer from 4 to 7 registers, and the
AER, LTR, L1SS, PTM, TPH and DPC buffers were all added over time.

This is the problem I was trying to solve with:

  https://lore.kernel.org/linux-pci/20260924173501.856380-1-dmatlack@google.com/

That series replaces the per-capability buffers with a single store
indexed by config space offset.

Where a saved value goes is then determined by the device's config
space, not by the kernel that saved it, so the PCI core can change which
registers it saves without changing what the data means. Serializing
that for Live Update should be trivial (a size/flags header plus the
bitmap and the values). The cross-kernel compatibility question also
becomes explicit and per-register ("the previous kernel saved offset X
and this kernel doesn't restore it") instead of a size mismatch on an
opaque blob.

Bjorn, this is also related to your last comment:

> I think it would be helpful if the names of "config_space[]" and
> "caps[]" hinted at the connection between them (both are in config
> space).

With the offset-indexed layout the two are no longer separate. The
header and the capability registers are all just DWORDs in the same
config space map in struct pci_saved_state.

So I'd suggest that we land the saved state series first and then rebase
this patch on top of it.

I can send a v2 of that series this week that addresses Josh's feedback,
rebases on top of the PCI Live Update v10 series, and includes the
serialization helpers. We can use that as the basis for the next version
of this series.

Thanks,
David

