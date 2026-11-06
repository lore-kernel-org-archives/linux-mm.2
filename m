Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EED5A606A332
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 18:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kvlR7CoN
Received: by kanga.kvack.org (Postfix)
	id 1952F6B05B0; Fri,  6 Nov 2026 13:20:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16D0E6B05B1; Fri,  6 Nov 2026 13:20:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 084906B05B4; Fri,  6 Nov 2026 13:20:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BFBB46B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:20:43 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53610A0177
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:20:43 +0000 (UTC)
X-FDA: 85405509966.15.BB86B01
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6EE3140007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:20:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kvlR7CoN;
	spf=pass (imf01.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793989241;
	b=Ir2ET02gqoJgLoSbnXDgufCRWPQv4jknDp5OWIlQQ2Jm4K93FLNwi6j5vagIwfENIuQujX
	D4PlIE9woFNIJH+fSgPfzMmm1lKjGM6S3QWFu6eQjdffZ9uO8nLrc77+rDgcdtm5mHgs7T
	GQEqj21HPpVXFCd6EuiMpHNl4rWGwNg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kvlR7CoN;
	spf=pass (imf01.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793989241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9qaZQMzb7DXoF7l3soDYlbhGMbKj+MV76UM39vsbcMY=;
	b=sOCcog0oPAAO6rtZGM4FBvdAQHZaXDjpM4C0K3PsY6/2EATXL4XSuImhXbbXIqVe9SSEtJ
	eumVG7X/fsB9QfQDMCrjPwdYgyaVnludaDEZ/rHhAKShs0NMYRmb15Ac5RIx3dldejmPUd
	l758e0WVqgr17pwVyy1z1VBIi0ztVNw=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8a594d313a3so527408b3a.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 10:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793989240; x=1794594040; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9qaZQMzb7DXoF7l3soDYlbhGMbKj+MV76UM39vsbcMY=;
        b=kvlR7CoNKxtkYAbwvEgc3Gg4CUV6m4FDu2L6hVwyDOnjoz7YU389UiEE6/ooXkKDtw
         4waAsqExFNwAxVF1utYUWmm8eC6fKywF8VZZoNSfuT1CABDQTzYieNSCd6WplJIPW0Kj
         OpCL2NnrzD/9AYcL77Zj4cJFa9m5tgorjGG2Xv8l1dgOjvonk1/bcq9kh/gYNQN9mSJU
         ietatZjiXyj2AtDvQ501ZV0CnRCbgxjisIJpmvVN38H/6vkwGbfuy51ejjgw3wqUDiDv
         FZbkBkz7IXi8Ek77uRGWvpZk+uXPwG7qESelY5N0xtGf+jnTT5rMq3ts5BOjqanSXujB
         Q8qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793989240; x=1794594040;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9qaZQMzb7DXoF7l3soDYlbhGMbKj+MV76UM39vsbcMY=;
        b=pZ8d8hCH1+JQd80fqk9eng62hLRDixe2iT0rKsiatNpDWhaZQ8BQFUFSsffYkFDvv3
         b3EOFQteYGw/f7lvqIdmLtrQmWM/rO6Q85n+E9zreK9ln1whq9nG5sumgjvUSK53pbUw
         XZRBYhTa5SuE43r1iObwYrLMmlv06lrtewV2dj87WlDnNGWdmR/Xo1BgtFkKMnKyk5q5
         HMY5kuv7bRRzcml9Q9TcZTF42SttoSziS7NfnNXHG0hKstX8SQDqTeRDzRC2qR5/1SpA
         7w3FU2waMNVbQaN5osz4OFzAuTF020S1wcb4qoYO4bFhaKpTASWPcNQoBlIBd3lw2S6q
         QiSg==
X-Forwarded-Encrypted: i=1; AKwUvBzDxY8id3Y+E9AAVGxJB9MDvmrHWaSgI1yVcwRb+WY5yViQdP4rIMzPR3KQIS+GACjyD5XrbQy4zA==@kvack.org
X-Gm-Message-State: APuU4Z+Kq4c78EQlGuhFlvooWioOpEvHSbsF8fcoU5iY+gac8Fmz7VMg
	+O6+y2F3IKqXFj3KMSPwLvLqaASNZp8oz2snt3u6x4lMWg9K4IXBciG38ydRedYmHQ==
X-Gm-Gg: AYBFou1g1zdEkuTEWGWwNkaok82VA4a0Heg6ZBdyTcPivLMKcYd2yTYCYAUpXyAZWaO
	y+UvZjRi62V8VkKkTFDN1i/Q3aGDR4F4KDzXNQWGsh19hbxCfyfUqghQN5LJ/Czsrm3YvkPDRY8
	frqAzv70PoYyYP7nLvmozgSyzUcSiPYJM+AYJn6moa0eL52pp2rJ6Upwj/IjDxRGANu4EugMJSb
	i0yXHWDazVhHWm5vjbR3GO0UBYEmE4cTWfueZqo/IR01ZNacaIpUwG1+IohAYamB6poFg6iOT1l
	GTkQwlXHwBg+dXtYWcwciww0T15yVmbrm1MTXwyQmiuy6XkWiiL/sDqYINjSY+hbTtC6a848rPR
	8wlexy56L3NrOfG37nChZCpElov/d3A4rAurLrZ9+Dt62zBLut9oIi/xQ5Ai6EE4qLFETV0t2Ve
	JsDFCuom0pPeMHtDT9olzHclLGX+t9QE1kygxDB0j+tGpEqDs8v5Gez+NA6Y6/7O49H+ZcT5+qd
	swjFCOb/vj6LcIfSHy9cwJNiLmfnaK+vebgLGMQEooxfZoaMtctdc+VCnSQwbVEIhT/waKXFH7p
	xOVVhkB+VXw/t/3u3lflMc1iL0BBhGrI/dPwQZ6UNYwR43q5J2YBca4MOyhtf20d
X-Received: by 2002:a05:6a00:2188:b0:8a0:3483:51ec with SMTP id d2e1a72fcca58-8b37cdfd31bmr3344310b3a.58.1793989239208;
        Fri, 06 Nov 2026 10:20:39 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b359128352sm848989b3a.13.2026.11.06.10.20.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 10:20:37 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 06 Nov 2026 18:20:36 +0000
Message-Id: <DMOC3XV68W0K.3FGK4UZ87838R@google.com>
Cc: <kexec@lists.infradead.org>, <linux-doc@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-pci@vger.kernel.org>, "Adithya Jayachandran"
 <ajayachandra@nvidia.com>, "Alexander Graf" <graf@amazon.com>, "Alex
 Williamson" <alex@shazbot.org>, "Bjorn Helgaas" <bhelgaas@google.com>,
 "Chris Li" <chrisl@kernel.org>, "David Rientjes" <rientjes@google.com>,
 "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Jason Gunthorpe"
 <jgg@nvidia.com>, "Jonathan Corbet" <corbet@lwn.net>, "Josh Hilke"
 <jrhilke@google.com>, "Leon Romanovsky" <leonro@nvidia.com>, "Lukas Wunner"
 <lukas@wunner.de>, "Mike Rapoport" <rppt@kernel.org>, "Parav Pandit"
 <parav@nvidia.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pranjal
 Shrivastava" <praan@google.com>, "Pratyush Yadav" <pratyush@kernel.org>,
 "Randy Dunlap" <rdunlap@infradead.org>, "Saeed Mahameed"
 <saeedm@nvidia.com>, "Samiullah Khawaja" <skhawaja@google.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Vipin Sharma" <vipinsh@google.com>,
 "William Tu" <witu@nvidia.com>, "Yi Liu" <yi.l.liu@intel.com>
Subject: Re: [PATCH v10 05/13] PCI: liveupdate: Auto-preserve upstream
 bridges across Live Update
From: "David Matlack" <dmatlack@google.com>
To: "Bjorn Helgaas" <helgaas@kernel.org>, "David Matlack"
 <dmatlack@google.com>
X-Mailer: aerc 0.21.0
References: <20261013162529.1928093-6-dmatlack@google.com>
 <20261106173427.GA1633106@bhelgaas>
In-Reply-To: <20261106173427.GA1633106@bhelgaas>
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6EE3140007
X-Stat-Signature: 8z6dj4rgwxagfg9brtm9edd8xh649ww3
X-Rspam-User: 
X-HE-Tag: 1793989241-928128
X-HE-Meta: U2FsdGVkX1+rQKD8nyIL4VmbwBsE+1DmtlDJZBTMJvrHTfjm34dOicV1FTrM6CmYht9r12uKMAugvI5HqUYKTj7kG/kadpgctEIIL9KZTHImZLu9H1VHsXncp0G49DylADOPUXxMaaeIxl2iLvqzcxMz2RmRPW2/b3+WizKB7aCtEZ5ywXqOzXOQW9+lbax4cBjq075EWuTFZ12aGvH9s9Mw8qM65ankM+D35Sv1zLlgCGzMu3vOslOHj8Ej+Fkbm/BkrXj0U4Bm7vRGd6SYgXl7vw2GMEn9OAJw+E8tsLJEkTOUu+XdOtYLSvaQ0dfOUiIUt58fT0FXAbxp0P0j1XVbYNxt1efFN0rpoSk8AzZnFo2spiKrw/6K/bpAZqkwOnDcmhYLiAgvaFK6s0GFftUog5slRCAQejUpvSg32PZ2o9PopyYPisXdp5AJ5H/pGj79GfY7qzSUP8nUdrPgtALMiOvJiagJXb12lpdlxKbcAsTBHx1Xtr7uf+JvoXOkxgv6mbXMthQbaKDIHM62QjqEpWKBoHtv2uF3egUB9SaHXqcttRStkbfA64dBNW3Nduat3rTEWZ6oZZ5rZn7BDeacBQ7FgSq8tTTMla1e4kyeRfH5WpdV2+USbNXeg18V7zaVYcfpG2ImHwZQfYvYeuMRFbuDE1slW8BkbOdX7PTN74w53e8FGH1QIZ8MSuZEO8FJPF9J6SI9zbdV2k4PNb1cUJBfo9YNkkjlziTS2CH70HA8COon+j1GdfjBvoBoEvl4ho7eIb1OjBGJQp7GPICn8OO4xs/cisaLjcmECOm1TrXpb40Qgebz5LAazSvVHmfIJTRoYQK6tIyoZAfu1uXLeu1mpyKU+jbbBSUxVQ1OnlZnX3PzLFmQJBa4G4zATTyw+mAX+i2tzsZhFFczNwO6Ji5e2pwcHCzA8zQZjtSFelF2ycnZXSw6cftlQDMWKVOyuS54yXj8H9Ap8aO
 6gyptEND
 GMDah57BKGCkkqqzPtUIaEbqikj6llFq0Xyja5aBzSgOUA6WEK/DQK6Xwr2oCBq/GQE0Mld26Wf+u8eOuVmeB6V38GprBGxI5Ds2E814XSWY10MylQicUOM2XLi3OnrCcm4vbAODfoo4UIfmj5jH9XY6lMvMyVH8SoA3nCzdX+SHJVBGNa3Fe/9L/tkwjCcVNwk4HasjLzVgyrQfJJxLNEGvkk07/9uRxPKh9vyo9nVNUG4xbkzI0M+Z0J85jTpYH5+3DHNG1CdSliZVNzSd9azolJf04RJ7UwmE1bxpKzw116OWkfv6yXdhFBjX3i/ZH4Cxqcf48DZ1dCr+fbjM9n3U/LCdVxRTbcMIalMaF5qDjZBYrvytewREY6qAY3pLgoSzDW23Y4KFMHQhBQj4CzRGlSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri Nov 6, 2026 at 5:34 PM UTC, Bjorn Helgaas wrote:
> On Tue, Oct 13, 2026 at 04:25:21PM +0000, David Matlack wrote:
>>  static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outg=
oing,
>>  					  struct pci_dev *dev)
>>  {
>> -	struct pci_dev_ser *dev_ser;
>> -
>>  	if (dev->is_virtfn) {
>>  		pci_warn(dev, "Cannot preserve Virtual Functions\n");
>>  		return -EINVAL;
>>  	}
>> =20
>> -	if (dev->liveupdate.outgoing) {
>> +	/*
>> +	 * Endpoint devices should not be preserved more than once.
>> +	 * Bridges are preserved once for every downstream device that
>> +	 * is preserved.
>> +	 */
>> +	if (dev->liveupdate.outgoing && !dev->subordinate) {
>>  		pci_warn(dev, "Device is already preserved\n");
>>  		return -EBUSY;
>>  	}
>> =20
>> -	if (!pci_is_root_bus(dev->bus)) {
>> -		pci_warn(dev, "Cannot preserve devices behind bridges\n");
>> +	if (dev->liveupdate.outgoing && !dev->liveupdate.outgoing->refcount) {
>> +		pci_WARN(dev, 1, "Preserved device with 0 refcount!\n");
>>  		return -EINVAL;
>>  	}
>> =20
>> -	dev_ser =3D pci_flb_alloc_dev_ser(outgoing);
>> -	if (IS_ERR(dev_ser))
>> -		return PTR_ERR(dev_ser);
>> +	if (!dev->liveupdate.outgoing) {
>> +		struct pci_dev_ser *dev_ser;
>> =20
>> -	pci_info(dev, "Device will be preserved across next Live Update\n");
>> -	outgoing->ser->nr_devices++;
>> -	outgoing->ser->devices =3D kho_block_set_head_pa(&outgoing->block_set)=
;
>> +		dev_ser =3D pci_flb_alloc_dev_ser(outgoing);
>> +		if (IS_ERR(dev_ser))
>> +			return PTR_ERR(dev_ser);
>> =20
>> -	dev_ser->domain =3D pci_domain_nr(dev->bus);
>> -	dev_ser->bdf =3D pci_dev_id(dev);
>> -	dev_ser->refcount++;
>> +		pci_info(dev, "Device will be preserved across next Live Update\n");
>> +		outgoing->ser->nr_devices++;
>
> This looks a little funny because prior to this patch, nr_devices was
> always incremented in pci_liveupdate_preserve_device() and always
> decremented in pci_liveupdate_unpreserve_device().  Now it's only
> incremented once (per device) in pci_liveupdate_preserve_device(), so
> it looks unbalanced.
>
> My guess is this is because previously we didn't expect to preserve
> bridges at all, and now pci_liveupdate_preserve_device() might be
> called several times for a bridge, and it's all just fine, but it's a
> little subtle.

Right. nr_devices counts struct pci_dev_ser entries that are in use, so
it goes up when a device's refcount goes from 0 to 1 (the entry is
allocated) and down when it goes from 1 to 0 (the entry is released).
For endpoints that is every preserve/unpreserve call, but a bridge is
preserved once per preserved device below it, so most calls for a
bridge only change its refcount.

> I suppose the "(dev->liveupdate.outgoing && !dev->subordinate)" test
> above is what allows us to just increment refcount each time a bridge
> is preserved.  And the test around pci_flb_alloc_dev_ser() is doing
> basically the same thing.  I wonder if there's a way to connect them
> more explicitly.

Agreed, both points come from the same thing being spread out. I think
both can be fixed by splitting pci_liveupdate_preserve_device() into
"already preserved" and "first preservation" cases, and moving the
nr_devices accounting into helpers that allocate and release the
struct pci_dev_ser, so it is visibly paired:

	if (dev_ser) {
		/*
		 * Endpoints can only be preserved once. Bridges are
		 * preserved once for every preserved device below them.
		 */
		if (!dev->subordinate) {
			pci_warn(dev, "Device is already preserved\n");
			return -EBUSY;
		}
		...
	} else {
		dev_ser =3D pci_liveupdate_alloc_dev_ser(outgoing, dev);
		if (IS_ERR(dev_ser))
			return PTR_ERR(dev_ser);
	}

	dev_ser->refcount++;

with pci_liveupdate_unpreserve_device() calling a matching
pci_liveupdate_free_dev_ser() when the refcount drops to 0.

The helpers would only manage the entry and nr_devices, not the
refcount, so there would still be a single refcount++ shared by both
paths, as you asked for in v8.

Since the series is already in liveupdate.git, I'll send that as a
follow-up patch on top of lu-pci-preservation. If you are ok with that,
then an R-b or A-b tag on this patch would still be needed.

Otherwise, happy to send a v11.

Thanks for the review!

