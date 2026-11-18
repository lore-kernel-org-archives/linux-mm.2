Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D94606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 06:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZpHzx9Xz
Received: by kanga.kvack.org (Postfix)
	id CEB456B00EF; Wed, 18 Nov 2026 01:55:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3456B05B0; Wed, 18 Nov 2026 01:55:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB1976B05B1; Wed, 18 Nov 2026 01:55:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0896B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:55:52 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1589FA81BD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:55:52 +0000 (UTC)
X-FDA: 85447329744.13.9BE96C1
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id 398EE20007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:55:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZpHzx9Xz;
	spf=pass (imf03.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794984950;
	b=AGHzF1e2PR359NZpwD0KSndkO9Ou0vaVeR0bb6Ym5nF6bc0YAhUesZEc6RgVdBXaTjtwXJ
	Lso/VeTel8Qw0rdy52BHG979gkPOQPpJeBYWezjOUIQhFBTfZKbV9/wfLuDmXQn3qvKWrM
	muIM/0RZRLLU0Q4fBYHaG66dyj52Les=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZpHzx9Xz;
	spf=pass (imf03.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794984950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3IFWTA7ou2igClaDYSbsGTVSgzRWm+OXVAzSzama/M=;
	b=htc2ntSiqP01E8fnbAbML8MiQrCqRIkWeUUfKweEnqRxKM+et6M68TqU9bya0QppFJzb3b
	Xk/2kUtzvjSHEz7vz5uvkHQg8lOVWZy8aU8QY+WR9qRionQ0I9HuV5rKSFt/rBY7YYlNlZ
	RXSUVkTlKNqxYQMly9OsVBUkm3FdJQ0=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2efc4a84e75so28965ad.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794984949; x=1795589749; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=D3IFWTA7ou2igClaDYSbsGTVSgzRWm+OXVAzSzama/M=;
        b=ZpHzx9XzkwW3f/aRUMDPLSrcWDfAeF5Bw5LqoLrCUYW0ZVNLTJjSpE4SIvzMEzsbli
         Lhf333boBm1e7Miy83w4LeB5ANb/z1sKQkH3b9WjYEPGdvowcJA6E7d24+b9Qu+xgQbb
         nvrl+vEtCQQjvrf2ilkGCwPSGIHFQly3GIzWBRAcNEcmR/+7dQPJxEQpP92wfR8XUnjF
         HlOKmF4nicswX8pYhWb4ixeY45+wIJ1fp0502a9dLZs0HXqv95ivPK8GLHT/v+4PgBvN
         NB1LrknDJhLt7xwCFanwYjgAFLeIwxnZJQ9C7ioigpxM3t/B+IdnIT2m1Q9kH3xRVS7E
         xPHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794984949; x=1795589749;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D3IFWTA7ou2igClaDYSbsGTVSgzRWm+OXVAzSzama/M=;
        b=st2DSCXeUuRUTtmhZUoOgQdlkgfaZ/C9etMK/eq9v1tpVjBs3fEVoB6pLNw4PU3C4+
         KKKF5MBp5Rd+Bo5X0N9i/VvD5Byg8qBBB38zdmBQMW3lmeTKxqSRghiaKlcEO65BbZgK
         YrT7FBQVY4b/Dn7nzQFB2rm9Wssbmj63VtMPygoRZl2QeFskg51pCinJB0S08pjOdLdG
         Ra9KOqjc8bZw0CuUzw4Z1dzgAlJ3SyfwndNjcqu2FOCLdUCDPfLOC2WlO50Srob5H729
         OCljoVarGuNhTDKUCGDfDeIN/sgWgFuC02bFrTISkO2tQ6zxPBZOkItPOKYKFeHMeW+o
         OEqw==
X-Forwarded-Encrypted: i=1; AL+hErFLtE6TpRNURuGx51/uLFKghassBlEYUI96dKnUnRSECibxZZ38eRMlYcngSU62mZYpA+htjsFQvg==@kvack.org
X-Gm-Message-State: APuU4Z/41fSD23gmfZqM2z4WN8AJYotZMhg5XaSbt5D31nadvL+mfd+x
	hHXjqycyM6pLzc509f/AMj5dUSMdX2RiUL4HQYuG8M92JAJxzF57OXSfsvBOryUw3g==
X-Gm-Gg: AZFdTZcVE6nEomiQgK8h+erlNHC+8weNOAMM3cNlwk5+IkjYKFF7mxbC8OtutWKMeyB
	RVUMFYOmNwv+OVAx+TsqrYiXoOlUuy2zpCYtr/bJvZwKD/O+AwRLOaqDSlJI89D1ea+ZkmwOiWq
	iP05NQSqeoHAiCTWHTVsX/w9fF8ccoqBoYPxDSAhtjKn0KooTbb8r0lmT5Kc34wOsS0ZWGrD0K7
	yofn9vyKYqzLahZ504hZ7foBGs+vjyH/T4qylEDd3Mg6yG8I2jBvg6t7xwl3VeFkvgS93q7fGHu
	tVAakVCeroQ+SWFz/1/bcbcYNDbhIlkPOunGaDVi4dSoG2x9eQBotds673INJjoTWpRjKMJmWpr
	FmnILb2dFq/Nthhzil9f+rcEQqTdz15tIuoFjlTjCoPO8rarlA61+LO7ndj3SImZFrYnG6AMLKN
	ItK+b8dVNG8ddUfMev5vU5/Bvp7LMUNWTqJgpBrDC4xgGiUGjf3CIR9+x9CcvRpX4evttGzoYLe
	lyVPkcgZLm9s3elKk2aM3YpLVVEsLr6h7UYe9eAFOFapFdNKwenr+54u1vNBzMpZ9QbCwoYvL8D
	5T903wows1VOd3hsBm6FuDrZs22cLjs+k25o9dqK7oN1X2gVPcGi5U4W18376dRa
X-Received: by 2002:a17:902:ce10:b0:2e9:73e0:2a6e with SMTP id d9443c01a7336-2eff9952062mr2886095ad.17.1794984948419;
        Tue, 17 Nov 2026 22:55:48 -0800 (PST)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c5ca5bf959sm657169b3a.20.2026.11.17.22.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 22:55:47 -0800 (PST)
Date: Tue, 17 Nov 2026 22:55:44 -0800
From: Vipin Sharma <vipinsh@google.com>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, ajayachandra@nvidia.com, 
	alex@shazbot.org, amastro@fb.com, ankita@nvidia.com, apopple@nvidia.com, 
	bhelgaas@google.com, chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net, 
	dmatlack@google.com, graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, 
	jgg@ziepe.ca, jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, rananta@google.com, 
	rdunlap@infradead.org, rientjes@google.com, rodrigo.vivi@intel.com, rppt@kernel.org, 
	saeedm@nvidia.com, schnelle@linux.ibm.com, skhan@linuxfoundation.org, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, yi.l.liu@intel.com
Subject: Re: [PATCH v6 07/27] vfio/pci: Preserve vfio-pci device files across
 Live Update
Message-ID: <20261118064707.GD2250529.vipinsh@google.com>
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-8-vipinsh@google.com>
 <au5VMy7zhOb65xIE@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au5VMy7zhOb65xIE@google.com>
X-Stat-Signature: smje6j6xkon5e89a9pdsj5k19yiwrsty
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 398EE20007
X-HE-Tag: 1794984950-83756
X-HE-Meta: U2FsdGVkX18S7enM4AhjKjZc6S1l64C13HKWETHeZK1vfVoUPhCM5/oy6+UmrjAGDi7lMKW/4G08clGRkcPXrZ2SKIEscMzzdmsvNiYWwJLwAovzq+zckAqpvijG5S2kv57b8Ctme25TTBouRN9VJceu5S4vnQhEHIir6Vl8r3D3d889SlHd1waWClGKCiBjuGC2cBR+HgXskoT5zPMTfxB5BoLAFt7LMNlL73Rc4dmUuA3rn5rWQbPuLy2TDoYsbOaGmKIvie43jl6tnLsraq2PpVvmqDIOiX2df33xSMAdD4k+zQPIT02HI2Z61qcJSoKA3dlJ4RczZE/neqVYpflkrIoKSg27IZ+T0+M/ZnQANJsDKvyPi31n+TDuVnl3ApoM30wYpyptT4zgMxZ5ZN/px3xh4Udg/ePmhkhol1bXpItPWn2R8287u4DPyVWvMw18EvNEYYmQTyyWZMfgxy/v1UEKsocsLF1wBS4ZDJf7Gtfw1fMbP2zBjA/3XFoaCn3r8Cp9ozwW0EfVxZafmijbdQ5OiXCCf6DXyZSYd9Wb7eJmueRL+OHqKz7njELMItNKE7hwpJjWVqnTNJW+96rZOM18HI6esK76e3noGM2MzdYr6e6O+ODuOhawHDwJQAwhU5KjUedl90khbUuP0eeUVut+xmjOs79XJt7jqMl13bbDq1YGHCY92+9sUcqsruPLYEQfgluft4I5ZiR8a/W5C8Yt5hfBk61JMYSE/onLkEcrdXt4gwhcS4EM4xA3c7UNqXTnwKQepudtv8S4wu/M6XU59q7mvRZZoawPskvmtlq54qf1cML9h3SMpgKnMklO7XmZglh6AhT2ASwTejPRCjeGYtfLyPtuDbXbR93/7ieZkwqeP1/lcF42eUx/p3D7yIeTmHcglH06LtOJxzihL4UF5j//Jp6/fotPDPvLHjVM1ifAmpl5J3Up8fh9XEPudTnUBof1xw4PhGB
 9FRcRbX1
 fNkiBSzWRnI2AdUcz1jAzkKOMh8eJ9YuE/Zy1s5jxyWc3zu3yML3iXgJppUx8SQHJqZlW/n9oHY/j6qQ0bkQrzBt9nPynZ5GJdtPhbmQ/ZfGAs9oqnNszTgJo2rKOQ8FFhB8J0ydd8KGKWDuf6LbJbxq7AJ4zcrJtirGgq4ahtgyLG3iYcns7g4Oo6uIveACwfVfAMv6PAi3HBD+44pM7VePBWYJoPqGlsSjs/IRtLVi5p6jsJsYPpKLj2B/LKSrwqtrW4SsCCVXbc5xrZo1PI0iksRZPFo5AdvNHR/OnNj2sM9vLViG9oeSCI4z3Kua+RIRD3sKH4A91QUmZJ0455t2Bjap89NbGktkrJWs9ug+Hklo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 10:35:27PM +0000, Samiullah Khawaja wrote:
> On Mon, Nov 02, 2026 at 07:36:36AM -0800, Vipin Sharma wrote:
> > +/**
> > + * struct vfio_pci_core_device_ser - Serialized state of a single VFIO PCI
> > + * device.
> > + *
> > + * @domain: The device's PCI domain number (segment).
> > + * @bdf: The device's PCI bus, device, and function number.
> > + * @cfg_size: Size in bytes of the device's PCI configuration space
> > + *            (``PCI_CFG_SPACE_SIZE`` or ``PCI_CFG_SPACE_EXP_SIZE``).
> > + * @size: Total size in bytes of this serialized buffer, equal to
> > + *        ``sizeof(struct vfio_pci_core_device_ser) + 2 * @cfg_size + @saved_state_size``.
> > + * @flags: Bitmask of ``VFIO_PCI_SER_*`` flags; unknown bits are rejected.
> > + * @saved_state_size: Size in bytes of the serialized &struct pci_saved_state_ser
> > + *                    blob stored in @data after ``config_map``, or 0 if none.
> > + * @reserved: Reserved for future use; must be 0.
> > + * @data: Variable-length payload containing, in order:
> > + *        1. ``u8 vconfig[@cfg_size]`` - VFIO virtualized config space snapshot
> > + *           captured during ``freeze()``.
> > + *        2. ``u8 config_map[@cfg_size]`` - VFIO capability map snapshot
> > + *           captured during ``freeze()``.
> > + *        3. ``u8 saved_state[@saved_state_size]`` - serialized
> > + *           &struct pci_saved_state_ser captured during ``preserve()``.
> > + */
> > +struct vfio_pci_core_device_ser {
> > +	u32 domain;
> > +	u16 bdf;
> > +	u16 cfg_size;
> > +	u32 size;
> > +	u32 flags;
> > +	u32 saved_state_size;
> 
> We will need space for iommufd_token when we preserve that, we should
> probably add it now as otherwise the compatibility would be broken when
> we add it? Is the reserved here for that?

No, reserved was just to align data[] to 4 bytes boundary.

Based on David's suggestion, I am gonna get rid of variable length
data[]. This whole serialization struct will be fixed length.

I think it will be fine to extend this struct by adding a new field at
the end of struct in your series along with updated flag when you add
iommufd support. 

iommufd preserved vfio device cannot be rollbacked to this kernel where
there is no support for iommufd preservation, so, flags will be correct
to reject the change.

Do you have some other concerns when yiou compatibility would be broken?

> > +	u32 reserved;
> > +	u8 data[];
> > +} __packed;
> > +

