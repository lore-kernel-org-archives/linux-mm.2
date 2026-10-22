Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79793606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=fsM/K2tE
Received: by kanga.kvack.org (Postfix)
	id 893DD6B0856; Wed, 21 Oct 2026 22:51:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 843DB6B0858; Wed, 21 Oct 2026 22:51:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E6F76B0859; Wed, 21 Oct 2026 22:51:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C98C6B0856
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:51:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B84EF140690
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:51:33 +0000 (UTC)
X-FDA: 85348736466.21.F76338E
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id EE4E5100005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:51:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="fsM/K2tE";
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792637491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DgxDvLuT+FrYCt+izSlqoI4afXyKDdrxGMCJ1K0jMX4=;
	b=vokO6/wmT4lYeE/52louYSTPSIJyGD6LPH9YtsC7/Up2hUvVFyp0NLhmn1GdaOFj5AR6Y/
	jzSEgACbpJ5ZA7ugzLdb5CcpL+THQ6Fe7XTdVYhAsKQWOkF9XoGA5AcItGzZLzHYmhr+bf
	gUhiHympRgnfOI8E3LQnJSSuUjkmtwE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="fsM/K2tE";
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792637492;
	b=aSSDL8EXqzB2LMrJ9mMRSccOQfRkmlUyy+9CIpMGMsKN3iF/yfPrhdNhcZrij37ipWt2+C
	+tg6ygwEUn9wHjoFiv80c+WBS4U2X0/VOaGZnKYYcEXTBGJHP7pXk2t9PW7tBLEfOEaY32
	xlhR5PcVOPGq6Gqd4+ie0qYN/Ho9ko8=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cc147d86bebso282460a12.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792637491; x=1793242291; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DgxDvLuT+FrYCt+izSlqoI4afXyKDdrxGMCJ1K0jMX4=;
        b=fsM/K2tEqlvVzNN9HaGjvRyRFrWr0pgpSOq1+S/exXP23JP4EosI8tnPScYZN+ab6f
         zgS0eydBpTaSmWLoVy8FIAa0ePnVek4PKuEk+X25pSqO7Ej2eTMZKi6mTlWOv14rGI1W
         xnbDC1h4iGn/s8benvXnxynkJhFTp2/1RyVb08H+uWCUQSG8mtv2EAT6BgQAqTz3Rfkd
         6E4GymZYX68EqXJ3gGdMpVkww6L6TsEjeLwxFOwZatNyD85+U4K3Cf2xquepENEIGUzv
         FZnimDVa+nvKfPr+SGVTcedqC3NKaMCRNxEwp+Cb1hbSNiW1yONwf0Hre/PWSKBA5i59
         +WmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792637491; x=1793242291;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DgxDvLuT+FrYCt+izSlqoI4afXyKDdrxGMCJ1K0jMX4=;
        b=zjKUyCcAyPB2r+bXQNvcGlSiptJ1Uc/8rpeCj8AbkDcm+D/DHgGvTRH5C4/qXjIIt8
         K6jyTdKEbbH9wpN4NFGUKdGlNfNwKFqfKODzjrcqrDx9+7q05XU31pZOd19/MHecwvDn
         vt44afaAB3v2UOSi33XGbN6QheQe62DrspBXoWz3RcJ2BeJsbs8Lkr2+5QPrHd/dlczN
         58u9luIWyLpQb20JuhJCH8ZlS2gGxWP4gD3GZfWbG43lgIxzJbXMt8VvYM3NKCVlhHaE
         /7098qag4pyA3Mkdv3J5m8MhC/vUUVpYxgdMEpegAhIr/SKpE5xDL/0FSa0iAJkgUo3A
         GEwQ==
X-Forwarded-Encrypted: i=1; AKwUvBx1hNTHXF74xLqltK0EAZETkhECTfmD79caLoRb9OQaqgn7C52SKr7nzv35fxrnPb85X6gtiEmzDg==@kvack.org
X-Gm-Message-State: AFq9FYJYXVttUlDj1WUK8+EVtuSW7qnjFabCtXkrQ3dZJ/7iZ6gFV8h+
	LjAcKOhXYIplv6H4r1pUgvYtTDkCtqPv9o3mFbRn8zJZdn34Ae8jO5qT+ZKZxrJiFQ==
X-Gm-Gg: AYBFou3siNZvo5RznoVWXQhPx5ujxSsUN/Zh18b5U1uIXqKzQYVwX9a7jhZUkudtYzE
	u0dqOHPrsElxnrwA6F2RFw23VCAVxMfTBiWpYVPxZnVM4cB4DY0Iqocnssv/kGKOAg4snNCTizP
	Zp8+K8y3RqBvE4QjweDjEjyZmWGCfgQZCnP1idALXX5fg7OgmG3W46Z1RDb8yvG2M4HWWaTMw7e
	PmDJVK0NpZaZiVEfId4GxPQ4lnSL9JPARNWkeFZh06S4kht9pZS3njWehTD2g6pzq9OjsSX4Oq5
	QWgH1OhBvT/r1rzqHhxK5tX1uhO0lvyInKlq+TcA93camKFohG/qFnybcuATH4iYMLSk403oMSR
	AS0lAYEdYR/2X7C4FSeuVFk7k03hgM50HBdN/xPhmBIq6ZrYgOS4P5PSY8c5xsp6zYNcq6NJnN6
	UjIWLIsNP8k8HFeh/AjafV7SQdea/Wg4r/tm1BrobTlU96+KrPbovZXtrZ/giZUT1Zsw2grvLyW
	/poHIUinT2RaEYEAQLc1WLtiwzV71/rBkMIrac7AEnu5SNne9SHMqTwT0DdnxaKdV5iVZZPsymJ
	8awyfAHoxJv1rIp94Q==
X-Received: by 2002:a05:6a21:3b46:b0:3e2:ea7:621 with SMTP id adf61e73a8af0-3e2a0bed41bmr545882637.42.1792637489967;
        Wed, 21 Oct 2026 19:51:29 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd6b85e8c9asm635619a12.20.2026.10.21.19.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 19:51:28 -0700 (PDT)
Date: Thu, 22 Oct 2026 02:51:23 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Tarun Sahu <tarunsahu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com,
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org,
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com,
	will@kernel.org, Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/4] mm: memfd_luo: Add the 2-bit pair feature
 header
Message-ID: <atl6K2Juy6Bh29lh@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-5-tarunsahu@google.com>
 <CA+CK2bCWo7ixrNLKPvqETn3JSFwSNaB2UsPgy9RHVAhWroJURQ@mail.gmail.com>
 <atlINfvlXY4wMbpO@google.com>
 <CA+CK2bDf-pKbH2J13mRYRT7Ddj-Q+VXaGYePs+E-azSWXKzV5w@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bDf-pKbH2J13mRYRT7Ddj-Q+VXaGYePs+E-azSWXKzV5w@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EE4E5100005
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: sgtahguwfswec8gnftdx91kckytxh7wc
X-HE-Tag: 1792637491-481010
X-HE-Meta: U2FsdGVkX19vKN6c5cPebu17M++JCKtAybceSam0KTDtdXOfvWM6hHfO+QpddpJsD5z19gPmEcoZFDEfyCcuLnDxHoWQ5I+hWAlktpMwPzdKPzbleQswCXIaYwvnl/jGjcXtBMVbRRpq8xQi4gPI+vkkdTvSz/E7tYeTIHv2HdQCbOf0QoLYVWNvqAK8L6/eFOMxTnwF/u5smLw9EDQk3w+AjG+IXJkaQ4J4atsu+y8GdclRpHqLXqMP/80os0RffNPv70lSlzrGkRFQBIp902xTlra3rwpkS8LbCXKjUPpaK5+hG5MrxCSgxHWXu3WVz8dARGVRlfos9L5gqFcR5auI3cAgCeRJeew0NfFhg2zKDSRZBJDph+/7M5p+VJY1YDMTlQ9JVq+TqkbXpQryRL8J04EBEDNvv1Bcp/A/93Q7uYLyWGYmiaVE+xLdPsYHtiu4Ps1pd77axgji8EkFNZ5CjcpphLZt/1kRGs2kZeBFr6p2Ayh17NSAz0DOS+6lvP0VRjw/n7uZpiIMSoCCr7RkxBCYipNNXswtuJH48wcjAvGutgZhV6kbB3b5nbLjFcoqtdWId+FmKJreuQriOjPYJh+CeoXIPqEk5KfXL4dl/RxwLFQpYKRK1oDJEfPtkHirhyFnl/Ls8T90oldVTqj3Gz5HYz32AJ7fL0vO+LmKH6hzxz/2sK8sO63f1SZTXgr8sCmSpru0vrV+B0Kc3vcn8ZnPHPGiYytDRIM5W869z7M7BuITG2xzyc1vuAiDWdBCTg8ewuvNczwm48jzXJEtgwbBrwT3SBEGMRCTkhmoJCZPrXnCXUF5IWiwI2BrDCs+CPfM7AkZZg5Mo3GceJzr1PSGD79CPiDqgCHBStmP01KG0cJI/YsZRHEJPHb006+uVqCp7wOx1o8VGh2PRx+Epyt+e8rU8IvZ5aOEC+88J1s3PJoGWk89J6jC0fK99t1/fxOV2BIDJOU5AUe
 1AoM3Ijy
 j4sj18wKDyGYgL+OCm7T57U1ip/B/KlO+oEmc5x2DKIHecozP4UIrZaHaGxa1M9k3IKOV/pe+ZFNiaIOWcq7NuRwoUiWLweypqVJEvnckwae6NjliEk0nkOcTft3wos5JLA/mdwXzxEhq57lSej/E0s4Kk4yyNNZqRzwBJNbbZyAv3gaCzKToWsf/p8fuq/INR+WEsrNeNiTpMsfJKbTN4YB21ag48IbCpkpZI7U03GEgkUMsRv3tUjOh1gQSmM9DUEQZ2oSvB9EzvTMuDqz/iCb5GxAXC8ERnJaJGZl6dfysUOCvveavYo+XleEXRWtGPNM68GFkMjwW1q7NWiRfh+ZN3uxY3l0f/BuJ+3G2hhBhy/wjth/y22sjK/ZRLVNnyf1NZubOm3xY9jmzQKbiKd8Wh8yU8QHT1Iz52ZTz/D92U8e/pKMhGh4DPBAMgCtv6HT3ieqWYOdLUy+EoP9uUc+ahCaHURmcT5+b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-21 08:41 PM, Pasha Tatashin wrote:
> > > >  /**
> > > >   * struct memfd_luo_ser - Main serialization structure for a memfd.
> > > > + * @features:  ABI feature and size header for memfd_luo_ser.
> > > >   * @pos:       The file's current position (f_pos).
> > > >   * @size:      The total size of the file in bytes (i_size).
> > > >   * @seals:     The seals present on the memfd. The seals are uABI so it is safe
> > > > @@ -79,6 +103,7 @@ struct memfd_luo_folio_ser {
> > > >   *             struct memfd_luo_folio_ser.
> > > >   */
> > > >  struct memfd_luo_ser {
> > > > +       struct luo_feature_hdr features;
> > >
> > > I have not looked into this yet, but I would prefer to use some kind
> > > of macro constructor for serialized structs. That way, they will
> > > automatically include the header, making it easier to search the code
> > > for what is actually preserved versus what exists only in this kernel.
> >
> > If you want to know what is preserved don't you just look at
> > include/linux/kho/abi?
> 
> Yes, and having it initialized and declared in the code correctly with
> proper macros and verified just gives the right handling and avoids
> making silly mistakes. The second reason is so we never forget to
> include the header, and to make it expandable and easy for everyone to
> use. I think this kind of constructor is just useful overall. Are
> there any reasons why we wouldn't want to use it?
> 
> > > So, I think something like this:
> > > /* Base serialization header: 4 bytes total size, 4 bytes flags */
> > > struct luo_ser_hdr {
> > >     __u32 total_size;
> >
> > Why do we need the size? I'm not really opposed to it I just don't
> > understand what problem it solves.
> [...]
> > The luo_ser_hdr is needed for top-level file handler and FLB ser
> > structs. Those structs are always dynamically allocated and preserved
> > with KHO.
> 
> The top level is not enough. I think it is needed for every single
> serialized struct in kho/abi - the blocks, the FLBs, etc. They all
> must
> be expandable in case we need to allow that. Let's have future
> protection for everything that gets preserved.
> 
> For example, take a look at vCPU preservation:
> https://lore.kernel.org/all/20260920193650.3373435-9-pasha.tatashin@soleen.com
> https://lore.kernel.org/all/20260920193650.3373435-11-pasha.tatashin@soleen.com
> 
> +struct kvm_vcpu_ser {
> +    u32 vcpu_id;
> +    u32 flags;
> +    u64 vm_token;
> +    DECLARE_KHOSER_PTR(arch_state, struct kvm_vcpu_arch_ser *);
> +};
> 
> We might want to add fields to the arch-independent part, and we also
> absolutely must keep the arch-dependent parts expandable. Therefore,
> the header needs to stay small and flexible enough to grow as needed.

Hm, anything that is dynamically allocated can have it, but anything
that it is embedded directly or in an array cannot, because those
structs cannot grow anyway. So I agree it's not exclusive to the
top-level FLB and FH structs. But I would push back on any a mandate
that _every_ struct in include/linux/kho/abi needs it.

> 
> > On retrieve, KHO gives you back the blob of memory. You look at the
> > header to determine what features are used in the struct, and then
> > access the fields associated with those features. At no point do you
> > need to check the size.
> >
> > The only time you need the size is for a KHO block array. You want to
> > store the size of the KHO block array elements so that the retrieving
> > kernel can correctly initialize the iterator.
> >
> > e.g. from the PCI base series:
> >
> > /**
> >  * struct pci_ser - PCI Subsystem Live Update State
> >  *
> >  * This struct tracks state about all devices that are being preserved across
> >  * a Live Update for the next kernel. It contains only state owned by the PCI
> >  * core; the state a driver needs to resume its device is preserved separately
> >  * by that driver.
> >  *
> >  * @required_flags: Features that the next kernel must support to take over
> >  *                  the preserved devices. No flags are currently defined.
> >  * @optional_flags: Features that the next kernel may ignore if it does not
> >  *                  support them. No flags are currently defined.
> >  * @dev_ser_size: The size in bytes of each struct pci_dev_ser in @devices.
> >  * @nr_devices: The number of devices that were preserved.
> >  * @devices: Physical address of the first KHO block containing pci_dev_ser.
> >  */
> > struct pci_ser {
> >         u64 required_flags;
> >         u64 optional_flags;
> >         u32 dev_ser_size; <==========
> >         u32 nr_devices;
> >         u64 devices;
> > };
> 
> Having `total_size` embedded in the standard header of every
> serialized struct solves this uniformly: any struct can be placed in a
> block array without needing an ad-hoc `*_ser_size` field in the parent
> struct, and on retrieve we can always sanity-check that the preserved
> blob is at least as large as the struct fields implied by the flags.

I agree we shouldn't need an ad-hoc *_ser_size field in the parent. But
I don't think the entries are the right place to store the size.

A KHO block set needs the entry size before it can do anything with the
incoming blocks. kho_block_set_restore() uses it to validate each
block's count, and the iterator uses it to locate every entry (index *
entry_size). The entry size is a property of the block set, not of each
entry.

Putting the size in a header on every entry means:

 - The block set has to peek into the first entry to learn its own
   layout, so KHO blocks would depend on the LUO header format of
   whatever is stored in them.

 - Every entry repeats the same value, since all entries in a block set
   are written by the same kernel using the same struct. For small
   entries that is a lot of overhead, e.g. struct pci_dev_ser is 8 bytes,
   so an 8-byte header doubles its size.

 - Nothing enforces that all the entries actually agree.

Instead, I think KHO blocks should record the entry size themselves.
For example:

struct kho_block_header_ser {
    u64 next;
    u32 count;
    u32 entry_size;
};

kho_block_set_restore() would then take the entry size from the
previous kernel and verify that every block agrees. Users of the block
set can read the entry size back and decide how to handle entries
written by an older or newer kernel, e.g. ignoring fields past the end
of a smaller entry. That removes dev_ser_size from struct pci_ser, and
any struct can be stored in a block array without a header or a size
field in the parent.

I also don't think block set entries need their own feature flags. The
struct that holds the block set (e.g. struct pci_ser) already has
feature flags, and those flags can describe extensions to the entries.
For example, an optional flag in struct pci_ser could indicate that
struct pci_dev_ser has a new field appended. All entries in a block set
are written by the same kernel, so the flags would be identical for
every entry anyway. The flags only need to be checked once, before
iterating, rather than once per entry.

If a feature only applies to some entries (e.g. some devices), the
parent flag indicates the field is present and the value of the field
in each entry indicates whether that entry uses it.

The entry size in the block header and the feature flags in the parent
are complementary: the entry size lets the iterator step over fields
the kernel doesn't know about, and the flags say which fields are there
and whether the next kernel must understand them.

Please take a look at this series for how I am extending KHO block set
elements using top-level feature flags:

  https://lore.kernel.org/linux-pci/20261019213054.3157159-1-dmatlack@google.com/

> 
> >
> > >     __u32 flags;
> > > };
> > >
> > > #define LUO_SER_INIT_HDR(obj, _flags) do {           \
> > >     (obj)->hdr.total_size = sizeof(*(obj));          \
> > >     (obj)->hdr.flags = (_flags);                     \
> > > } while (0)
> > >
> > > #define DECLARE_LUO_SER(name, expected_size, members)       \
> > >     struct name {                                           \
> > >         struct luo_ser_hdr hdr;                             \
> > >         members                                             \
> > >     };                                                      \
> > >     static_assert(sizeof(struct name) == (expected_size),   \
> > >                   "LUO struct " #name " size mismatch!")
> >
> > Why?
> >
> > Practically every change to a serialized struct is going to involve
> > appending one or more fields to the end of the struct. Asserting the
> > size means we have to update the hard-coded size as well every time we
> > do that.
> >
> > Is this to protect against embedded structs accidentally changing?
> >
> 
> Yes, exactly. See how kvm_vcpu_arch_ser is proposed in that same series:
> 
> +struct kvm_vcpu_arch_ser {
> +    struct kvm_regs regs;
> +    struct kvm_sregs sregs;
> +    struct kvm_mp_state mp_state;
> +    u32 pad;
> +    struct kvm_xcrs xcrs;
> +    struct kvm_lapic_state lapic;
> +    u8 pad_xsave[40];
> +    struct kvm_xsave xsave;
> +    struct kvm_vcpu_events events;
> +    struct kvm_debugregs debugregs;
> +    u32 num_msrs;
> +    u32 cpuid_nent;
> +    struct kvm_msr_entry msrs[];
> +};
> 
> All the above structs are uAPI, so they are stable compared to random
> kernel structs, but they still have a size and can be expanded. So,
> having the size and a static assert guarantees that when we expand
> these uAPI structs, we automatically catch that in this struct and add
> the appropriate flag to notify the next kernel of the changed world.
> Also, it catches implicit compiler padding changes across
> architectures.

Ok makes sense. Having protection from accidentally changing the offset
of fields in a serialized struct is a good thing.

> 
> > >
> > > Usage:
> > > /*
> > >  * Header:  8 bytes (hdr: 4 bytes total_size + 4 bytes flags)
> > >  * Payload: 8 (pos) + 8 (size) + 4 (seals) + 4 (_pad) = 24 bytes
> > >  * Total:   32 bytes
> > >  */
> > > DECLARE_LUO_SER(memfd_luo_ser, 32,
> > >     __u64 pos;
> > >     __u64 size;
> > >     __u32 seals;
> > >     __u32 _pad;
> > > );
> >
> > IMO this makes the code harder to read. I think open coding keeps things
> > simpler.
> 
> I am ok switching to a different construct or way of declaring these
> structs if what I proposed is hard to read. However, we still need
> standardization so that every serialized struct has a common,
> expandable header (taking only 8 bytes by default), has its size
> verified at both compile time and runtime, and is initialized in a
> uniform way.

I think your idea to have a growable header from the thread basically
means that the header and the ser struct will be 2 completely separate
structs and you will need to user pointer arithmetic to jump past the
header and find your serialized struct. So I think this is probably
moot.

> 
> >
> > struct pci_ser {
> >         struct luo_ser_hdr header;
> >         __u32 dev_ser_size;
> >         __u32 nr_devices;
> >         __u64 devices;
> > };
> > LUO_SER_ASSSERT_SIZE(pci_ser, 32);
> >
> > >
> > > struct memfd_luo_ser *ser;
> > > ...
> > > LUO_SER_INIT_HDR(ser, 0);
> > >
> > > Thanks,
> > > Pasha
> > >
> > > >         u64 pos;
> > > >         u64 size;
> > > >         u32 seals;
> > > > diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> > > > index 64f8b8cb75bd..ea1f4c8cd259 100644
> > > > --- a/mm/memfd_luo.c
> > > > +++ b/mm/memfd_luo.c
> > > > @@ -84,6 +84,10 @@
> > > >
> > > >  #include "internal.h"
> > > >
> > > > +static const u8 memfd_luo_features[MEMFD_LUO_FEAT_MAX] = {
> > > > +       [MEMFD_LUO_FEAT_CORE] = LUO_FEAT_REQUIRED,
> > > > +};
> > > > +
> > > >  static int memfd_luo_preserve_folios(struct file *file,
> > > >                                      struct kho_vmalloc *kho_vmalloc,
> > > >                                      struct memfd_luo_folio_ser **out_folios_ser,
> > > > @@ -284,6 +288,8 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
> > > >                 goto err_free_ser;
> > > >         }
> > > >
> > > > +       luo_feature_hdr_init(&ser->features, sizeof(*ser),
> > > > +                            memfd_luo_features);
> > > >         ser->pos = args->file->f_pos;
> > > >         inode_size = i_size_read(inode);
> > > >
> > > > @@ -525,6 +531,14 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
> > > >         if (!ser)
> > > >                 return -EINVAL;
> > > >
> > > > +       err = luo_feature_hdr_validate(&ser->features, memfd_luo_features);
> > > > +       if (err) {
> > > > +               pr_err("memfd_luo_ser feature header validation failed (size=%llu, flags[0]=%#llx): %pe\n",
> > > > +                      ser->features.size, ser->features.flags[0],
> > > > +                      ERR_PTR(err));
> > > > +               goto free_ser;
> > > > +       }
> > > > +
> > > >         /* Make sure the file only has seals supported by this version. */
> > > >         if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
> > > >                 err = -EOPNOTSUPP;
> > > > --
> > > > 2.56.0.212.g129ede20d9-goog
> > > >

