Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C308C606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 00:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BLZoG5hT
Received: by kanga.kvack.org (Postfix)
	id CFE696B08B5; Tue, 24 Nov 2026 19:22:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C887A6B08B7; Tue, 24 Nov 2026 19:22:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B500B6B08B8; Tue, 24 Nov 2026 19:22:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8733F6B08B5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:22:20 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7672AC0D6E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:22:19 +0000 (UTC)
X-FDA: 85471739598.22.F728813
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8EA1840003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:22:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=BLZoG5hT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=vipinsh@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795566137;
	b=t9KvRI2Uiw2LRc1l48tkp7/svxKBgyh1XLXCH+56/8Pcx0seLaQAfA6cSdq5ElTXTIDTjL
	eup5K+Qjb7X1jk+8t/2GJt9okCs4yjLAz+IZ83RsXqsIaCW1SP782nsVE0Z9zfLHvVWQjc
	1TFCJOHuJXi1/kXXQYFkFjfLfO0qZw8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795566137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TYzGQKZhwagkTAG/Juiri3uWHZu9q9sF8vYxgRrqGqI=;
	b=W95A3oCzXWCRmBGMBgw9Sg4ZgBoWV/ZOlPY1m6qwJikA1BMPdcsVfpa4Mcp8OF3jiP/+cK
	4TvsSdmC+cFaOHt43Rm8deSnDLtYYYvA+bpWgSNi81IcrjwlynWqDp9AM+8F6XmAgOkOsH
	KxqaqB45ZgZVjMCj2s/jTzwFN2grwUg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=BLZoG5hT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=vipinsh@google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ee254f6eefso244095ad.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795566136; x=1796170936; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TYzGQKZhwagkTAG/Juiri3uWHZu9q9sF8vYxgRrqGqI=;
        b=BLZoG5hT3WaDX0qepUu4CdrdBhdtQLBGkGFExwatXX159igTkNjAjEe/Nc3KzUyWTi
         dOwD5WPerZpETWtYKtkM/5Id3hfuNe6KJFZ42YRnEj2PxASsdqPNeriNgS1fvJqOGEdn
         gvBCvOkGq6ZgHemegiZ3K+uaewcktxQQpvX5NDwm5oyutpPThIJ3oWoLJizhM+nIV/jH
         N1L5qHSN51L0nOMvAFuOcDkWqVBbgG9TzE0mtAaOnewX0Yncs0g5faFccGSO7yXLIhbY
         QNCUc4SG4B+Q6H1VBR2SblVJ9yP+mYQjfvZfnqmQaQZIyGS/zISx2KCtxg7on0yDOPAL
         jHnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795566136; x=1796170936;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TYzGQKZhwagkTAG/Juiri3uWHZu9q9sF8vYxgRrqGqI=;
        b=kTB4kL6jxWrtoxYSmcsNf9y6OLSdoQEhj+EyxLC3oQ7HmjBVFRw7ueR6OOH3/Z3ijT
         sGA50WrkjurH1ukucU/PT+SfdD4JYzUSJy5riIu11uIet8qcrxTJDfHK3lAnQxjPPNeK
         XcZt2Pg4kP1mb6jeinBAHSTXlzlCODAYCtYnquNDJVJzU8Bu4Z9sKwv5WkzsvcZnqNRS
         q/XLekC0HVHAiP1+mGfsbAkLxejw1bpABwXkQ0k+cNuG5YanvmTLLYIAruJGM0TrHojd
         50Cm2Nm4E2ubGlTJbDmKtti1gH1A7zi2Y9YYGLqCt/iVevuvamOJ/hLiz/vw3leMgJ5h
         5ALQ==
X-Forwarded-Encrypted: i=1; AL+hErHinUKQzTcSHde/8CMyYZznNhuKhEbVNt5mj0tgrAhi3Gwh/rEWK1BP9XWlKUAfuQS/EaULPIXL7A==@kvack.org
X-Gm-Message-State: APuU4Z9DOm+uf3aIdRXzV3IVHzh1S8NmUt2+vQ6ETXNb8O15K/PjeqhQ
	bbo3j2vDpFiXawllzj68ytAsVLhiBDm9hxQ54orCod2BYegm7HTNijgDUZ6yqsSvfQ==
X-Gm-Gg: AZFdTZcggdIH+QgzySij3zgG6g5TPB/kiDexsj1g8Awas1S0lTes0iRQn0TAlsNHFrN
	XXEB3TP6MQIHCtChBes3QUXGDyYVZlYJRTz9uFjWnUaMaPguk1zznCDjUvJyDHM2J/mhQ0KUdge
	K0YTSBbqNSsfgB66yL8yoi5QAezTdQnXIUgmO+mHrl/RRTkBdzSTrBRZX1ZCXA+TNe0uzdkwsVE
	xRiYdIFN7mzL8wxp1TrzuVPY8xk+WTOUmjF+dnpq0rDttd0N/hrHLxYU1jf4W0zG0nSXW8DKn9k
	lJmFe9nEEE4jaBB5xWPWcS8GyNkGKA7viDO7ldMTrlymkr7mqtO1iolHvdB9x5+rMmqXyvYHaMr
	nuB1hcxiaj9kVkj200vrOhetHhF8VDoGa5W2aRY15wFK64qEYZRQG7CJP0gdX6WoekHi2iUhEYF
	WrBXNm5ixJoh4Aq3pN+x1oYnxLeYPleovV9OJ0A9ZtHW7ur0MK24NUKfcY5nUAVGvSEhcn+ilx0
	6wa0e4ITmHkHK1vlXqFiCQTnAgvspKP0P+fxKSvZrC4a8hOyibz4rfl6tvGmVDltzAJl2B8xcHp
	EqUIhOkrgON+yr38ApQRLzPUiS4MDOvxm8rqOEzugCy5uBLHSYwvJThFQWSOZXXfvDc=
X-Received: by 2002:a17:902:ce0b:b0:2e9:73e0:2a6e with SMTP id d9443c01a7336-2f0666fb91bmr16319865ad.17.1795566135674;
        Tue, 24 Nov 2026 16:22:15 -0800 (PST)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f105b76sm76508585ad.50.2026.11.24.16.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 16:22:14 -0800 (PST)
Date: Tue, 24 Nov 2026 16:22:10 -0800
From: Vipin Sharma <vipinsh@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, ajayachandra@nvidia.com, 
	alex@shazbot.org, amastro@fb.com, ankita@nvidia.com, apopple@nvidia.com, 
	bhelgaas@google.com, chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, kevin.tian@intel.com, 
	leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, mattev@meta.com, 
	michal.winiarski@intel.com, parav@nvidia.com, pasha.tatashin@soleen.com, praan@google.com, 
	pratyush@kernel.org, rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Subject: Re: [PATCH v6 07/27] vfio/pci: Preserve vfio-pci device files across
 Live Update
Message-ID: <20261124234830.GB3545683.vipinsh@google.com>
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-8-vipinsh@google.com>
 <auzftbPFO_6XBYVw@google.com>
 <20261117220059.GA2250529.vipinsh@google.com>
 <DMZLLYOVIGOU.1RXWYJN6UQTM@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DMZLLYOVIGOU.1RXWYJN6UQTM@google.com>
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: qab4a8n1sd6bi9epmcow6365p5gkn7i4
X-Rspamd-Queue-Id: 8EA1840003
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795566137-372948
X-HE-Meta: U2FsdGVkX1/PhaC0+fHIqD1bva3R6+pN5V8wF3mnsOtUWcJDkh8ZMWw5HWhjUvB5nqHgRjy7zyKURnwUDn1mBPvSJ2SeMGSI5KJrWAoAPUpqjHNcpl6OszWNI30CO07S65u4Q799BHqYCxkJbpaFw2mOWcEBMps5HtgBhbuw5E25Jcgn65/p4h/30jwADnG4m0vZS1dG/Mo5avjLWx2LMn5hjpjm7CMYlF+c7rFTcvh0v6dZikjPHSYM/zK4CCOo9syubpmGNJemJXuDn9kbZZLDGyvx1rrXPNho7k8/j0+v4WRPr+naqkfS0Pwahbq+XDNhbgJD6hM3W5ySe84kucvqwBsfrSXSaAjNDbrhJQJk+x65ja/jRGN2nn7LxxvnYA8/9EZZ3cwWJCHEzMF9WAKnWtWKiG5kyZJQW1wAf1whXxfKAWYUMYMXuMJ3C28ZSssiejnp1hIolfIILmQ9Hkdwd8bUbx7VuhvXJ/GBVqNeIOoIQn8aGoNL121crZBy5oOJHwRHkMuGf+t22IoslVH+frtC0aY//6z0wrSn8lUGQDPkXSy5xBfjT15s7rBDXKTWdMBLIlYPtAT0Qfum7pF4iaGlWPAqOqvEkiy1BVbGD9vxk5IvpmoON87Mbxe3VsvzDFGeE7GRTtIrYx9XaO6iMfUOYp4EUYFvUqs1dX6E1OB0+/oWv1rtfpYCrlOeVX4I8MNhBjilgaaY3ONhbmVJi1KnBmFTqWytxmdWlJr/ys5zf6SDLyDeK+B3TDMjSHDefHXN7syD6f0jB58I9zaix3H0kQIGf403bR2RTuN3ep9nKw1h9/ejCEkst7iryAKAzpgQGQqU/n6giC0jtLSpwE+XtQ/fSugsKgQykGHLuzKNakSZoOm20fzsJ9Hk3s1FXZCJ2oqhZ7EvOdgiaG72jr/6w0ZF7vCFl/+rqeQz2fqAi17HHu6o56GUnzhuphhHlyFXkoSRDmBRaZ8
 saSA7Qod
 g611rVeOiNZinQdg4YJy+0Ww3p54PyBpxIqcV3wzZaa9IH7JtUxSHVDEcBBmsDIjitFf5NexJwoi1BtMGhTJxoy4o+w3h4KVkNs69zrYMKy3C8PVDLuuAkNub0MQxs8Xf2/lorSlMrhPys20zmz0n824qr4sU+8w6xblue91rMt/vWwJ5/dsZexsz7jvpyebEWQQ1Lcu1MHPoXLd5VXYE4ziysSFNS9WxUkm2wHRjsdBch18Ha41hz4+PkCT/3oKvFCo3tRn4gcO4QZ0p3B2/RyC6XdkAmb624GxXIy+jpSTxgFyQD+Yr+CVBZKUQKhPYiH2owZYc+NtTar14JIFLmE9OATDfNEb8NeUJgpGr6U4Cfpg4Qk5VLSXjo7lm2w8qtsiXN8RtJzGxiIjiNAHQoNla9C/qDuk6nbT9ekUlid5xBzHx6mXh1ooAb2f2ZKBEiihI4+qkrhY2PyBj/pXUS31KL0clmT4XkvV9/yWjD2U/ObR6UBpfGjEiKa2u81AdHOPUqoJA1s/33sTQTLm3p6aodJP8+pwwLOayt0U/fDj/K1WJ+ycLwB5NYj4MOSpXgbLmtvjgWwMStJqzUe8/zgRiQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 04:06:38PM -0800, David Matlack wrote:
> On Tue Nov 17, 2026 at 10:44 PM PST, Vipin Sharma wrote:
> > How would a userspace opt-in? New kernel can change a capability visiblity
> > or virt and write permission of the bits inside a capability. Kernel
> > cannot know if userspace used the capability or not. Creating a VFIO
> > device in the new kernel by default results in a opt-in and currently
> > there is no way for userspace to opt-out unless we add a new
> > functionality where userspace can disable/enable features something
> > similar to KVM capabilities.
> >
> > For now, I think we don't need to worry about it. As this version will
> > be a base and if any serialized data with flags set received in this
> > kernel will lead to erroring out restore.
> 
> We don't need an opt-in mechanism in this series. Detecting mismatches
> is enough to make Live Update safe in both directions: if the next
> kernel would emulate the device in an incompatible way, retrieve should
> fail.
> 
> But an opt-in is needed to make rollback possible once vfio-pci starts
> changing its emulation. I imagine something like a VFIO_DEVICE_FEATURE
> that userspace can use to enable new emulation behavior right after
> opening the device, with the enabled bits recorded in a field appended
> to struct vfio_pci_core_device_ser behind a required flag. Devices that
> don't opt in keep the baseline emulation and stay compatible with older
> kernels. But that can come in a follow-on series.
> 
> > In the next version, I will not preserve pci_config_map. Hopefully,
> > anyone changing VFIO code doesn't forget to update flags if they change
> > capability or permission bits (I will write comments at appropriate
> > places.)
> >
> > If we want to be very careful, we can do two things in this series:
> >
> > 1. Create a per bit valid mask for the vconfig and compare this between
> >    new and old kernel during restore. In the new kernel, VFIO then takes
> >    each bit from the preserved copy only where the mask says it was
> >    valid, and keeps its own freshly initialized value elsewhere.
> > 2. Create a hash or store virt and writable bits in config space.
> >    Compare it with the new kernel.
> >
> > Both of the above combined will safeguard against forgotten flag update
> > in the code.
> >
> > We don't have to do it but it safeguards against mistakes. Let me know
> > what you prefer.
> 
> I think we should do both in this series, as two per-bit masks over
> config space, preserved in place of pci_config_map:
> 
>  - virt[]: the bits whose value vfio-pci keeps in vconfig and returns
>    instead of the device's value. This says which bits of the preserved
>    vconfig are valid.
> 
>  - write[]: the bits whose writes take effect. For bits in virt they
>    update vconfig, and for other bits they are forwarded to the device
>    (possibly after validation). Writes to other bits are ignored.
> 
> The masks should describe what vfio-pci actually does rather than copy
> perm->virt and perm->write.
> 
> vfio-pci can keep changing its implementation in ways that don't break
> Live Update, e.g. start intercepting writes to a register to sanity
> check them before forwarding them to the device.
> 
> Something like:
> 
>   struct vfio_pci_core_device_ser {
>           ...
>           u8 virt[PCI_CFG_SPACE_EXP_SIZE];
>           u8 write[PCI_CFG_SPACE_EXP_SIZE];
>           u8 vconfig[PCI_CFG_SPACE_EXP_SIZE];
>   } __packed;
> 
> 
> [ Note: I'd probably store virt[], write[], and vconfig[] on their
>   own folios to avoid multi-order folio allocations, but I am embedding
>   them here for simplicity. ]
> 
> The outgoing kernel computes virt[] and write[] through a helper in
> vfio_pci_config.c and saves vconfig[] during freeze().
> 
> The incoming kernel computes its own virt[] and write[] masks and
> requires both to match exactly with what's in vfio_pci_core_device_ser,
> otherwise it fails the retrieve. On take-over it uses the preserved
> value for bits in virt and its own freshly initialized value for the
> rest, like your option 1.

For now, we will be rejecting any changes and in future when we add
userspace opt-in mechanism then we can loosen this check, am I right?

> 
> I'd store the full masks rather than a hash, so that a mismatch can be
> pinpointed.

Yes.

