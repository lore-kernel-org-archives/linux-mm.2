Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12C11D38FF1
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 737686B0005; Wed, 14 Jan 2026 12:12:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E51F6B008A; Wed, 14 Jan 2026 12:12:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 617356B0005; Wed, 14 Jan 2026 12:12:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51D0B6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:12:26 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 00832C21A3
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:12:25 +0000 (UTC)
X-FDA: 84331213092.10.63CFC3E
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2F70C40012
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:12:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pWC4Qjkl;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768410744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLZK+PqSn6nIdPCyk8+Al7PM0O31XRvufO9b7gKXcTo=;
	b=kkspTmBamaHi2I6xvGP5C2suHgDPkgz044g3OA3IKy6VH9rWtC2SVZDwTlz9I5jxXBOf0O
	/A9zMvAcCfjJKPx3VqXY2lU+SYaoo88e++z5ZgJYUTi2whbfV/7yNIoshTeh0al5g1F92y
	vMN9sqYNIWG5tE+2+nLiUwWDL8dotj4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pWC4Qjkl;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768410744; a=rsa-sha256;
	cv=none;
	b=2po/8V5/mWhBxCvyNI3YF79ekDZTLhm7sw7ZRE9/7jL7offpTSfVeu2ITweP5DnQjAWuoK
	AlrqinLa5fhgPM+tHrs35jclaFpylzqwe8W/kEPiX3qO9pDiGt5tc34T+QoulG2Dxht2wp
	OH8G3GV7shqH9DbPK8XdZIR/vkLhHuQ=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8b29ff9d18cso2865385a.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768410743; x=1769015543; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cLZK+PqSn6nIdPCyk8+Al7PM0O31XRvufO9b7gKXcTo=;
        b=pWC4QjklAXhWbRqzeumEoAvVOuABILXFFEeLUEgrt4R1u74t2m/qqj9dkygnoHw9Nj
         6z8Carny8KI9lR7VmmYMsvaELEUyhc0R9yx6APV66ZZVAVeXW+UZc5A+5e98fO7yVu6g
         KksjbniCZ0XTuhl5AC3wJlKhBDXsVme1dddGlGl6KkkTyNjOt49Kk3RIJ0I0xvSnwjUM
         jf14IqmHjX+Bg5OPo95Y8RnuVg296wBUmIERKU7Fteg9j908aBnst1OArbKqq9U2r8h6
         WUIdnEbFO4Wfwx7J+MTDPYQoqv5EIkvJvY2c3nWMjNLu399i7NTby4u22i6yx7EiE0Xh
         e4/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768410743; x=1769015543;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cLZK+PqSn6nIdPCyk8+Al7PM0O31XRvufO9b7gKXcTo=;
        b=As4LWCM2wqBxNsaV/RhbNpT2KJ7DxQqa+xC/uDvJOGe/cCAkj7edt6E0FeupNM3BiL
         9/SOYLeW2uspMly4ezrwP4Gh7bsSiL2+5R55XFB+rAQfCyx4qSnibccWgv1xX+WEXixK
         DKK2Rx30YmckzhV4ctOLD9BiEmoybkhN4UbCS0OuKABCMzgNWfJfr9jLqaPqlp4VbMM4
         UYia16fpOWvQ7mTqipaJP85gxloxQUfkzf72kaZU6cQrr3C30bgyjTnctxoAcuq3P5yZ
         XCnXElsCaX4ZgwOhQvtPHqiGyTRigD4VCm4ObXChlQoEqoz+wqoj+NEZpPNmzgsbHjgr
         YP2Q==
X-Gm-Message-State: AOJu0YyqRL1tSizO+9UXV/Nif3aK51ac1fr9E/nShZDlxhAX/uTN0syQ
	RSPwXNW23a6xr6D+bVz3SuGrgrDqrQmNLKnn7SuXS/+/IvRc7e0j9cBEQbAB84rdfBs=
X-Gm-Gg: AY/fxX6/H9/ipra2nJ3+DZXyO7Jb1ZF27ugahUjx01pJUzQheHWHA9UbW4RKJAJb3RG
	Axlz2cfrI/FqRo2Jf69o5uuSHkhPBE747Nw72t/GETbaCsMx5H7silGYgYgQNVxAhlOOaa7+SUr
	89XP1X4Q4LTmnT3HDrZRwoRCzkShvAOMfrWKTpgCVtnqJoTGH1VEjgQ4z+20Tjlk781EeDq8Qfp
	G0qhiJ2IZnC02i806ogi4YTlmao488lDj2wRnEmHocvveLiyWeAbfwspiykGLOpO3pP2e6u4YPP
	eSYwQvNL8L+4ZOpm7pzCO6CqkA4qgXqm+Tuqb/fIHYasncpOO/N3KqCi9Ms+l6cggh67RbT6drq
	vRCgfh3DtBS6hsBIxRfilFb3nQwsmOQ70gvlVdrwtl129mR19s8fJ1X5KklxQUsMtFw+LVlsmlC
	PL7myjJe2LP6cnLgcl6VLZ/lQzA6aM66KV9uytPRImv7+x//zwPc0tf0vmbZveHOYPnFy8joYr3
	mSITiFT
X-Received: by 2002:a05:620a:f03:b0:8b2:d6eb:8203 with SMTP id af79cd13be357-8c531808de8mr358190785a.69.1768410743009;
        Wed, 14 Jan 2026 09:12:23 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c530be76d1sm201549285a.48.2026.01.14.09.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:12:22 -0800 (PST)
Date: Wed, 14 Jan 2026 12:11:49 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 2/8] mm/memory_hotplug: extract __add_memory_resource()
 and __offline_memory()
Message-ID: <aWfOVd3_GGTNHKNt@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-3-gourry@gourry.net>
 <c4ed9675-269c-4764-86d5-87f4f83fc74d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4ed9675-269c-4764-86d5-87f4f83fc74d@kernel.org>
X-Stat-Signature: m6o4d53sya88srm8fchpog11tjbwsk6c
X-Rspamd-Queue-Id: 2F70C40012
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768410744-435798
X-HE-Meta: U2FsdGVkX1/C5b8uT4V8HNDcVjXqbHe/fv9j2kelozUlpo4c9ER0KnZpMSuJFXNeQSuUbkuKp12odm0aKrmNwBCvKv9t8CYRg8Ycrab/9cQUVrL8xEgf8VGIMtxefniIxDmiLLepmQDFfJJjLdPkAz/BYHSlM8wBLA3noqWootl8W2KiF0icZ4Stjdnp19dz5SQgnyiVZLcpswL+ilEq7ZA1Om5erwOBoKqPhiiPZEe31Yj2YnuDqlszRK9CfYN5WA8UYBM8dntkL07xYakdjkUrB2gCG76kcUFkB80Jul4uG9GCNkQ1+WTf4/DmvJaXoVx+DjlqI0KAlAqgDRFbqlIve66TZH0Q7krKwY8I+7cclKbiIpdS0C+tTR1s7lOOQqYQCxYe++v4DZ5WO1up4Nxhfl00uT6tEozWKsXG7vEbLy7bLcV71NkQeH3LETSwkUdp297i7SFNHHttf9Um0caS3+hVIJPOuYvk/sRZ1Ms/g/Y+ImTy+5TrVWAlnkaRI3wvYLLIuPPV7AGKQkQ/RfNzOK/Ll517BlOXNl24i7fy89HyHFpsQ3RM3LazQEgupKUwuRb1wJdvHBmvhL37eVYSxIyrIBLICkdOFbg/n5F93mW05xrbaMhDyIeT8xSFx5mQNVzFLeA1T5GMoLt1c/vnDIwaHRLwkuciRyGOvxDUjCKGxre1yWClBdqV9l9cnRiq9n+3Vd/v79R1O+8R5EXMvHJa9IGh88kBeZIhU2K72cCTpqjpIjVwzgPbhcjir+fkZ+P7bxpOdIcBDoFs4F1won1jLp53ROBhODt0o8YZ+S4D3TvXgp8mKp7hiwztUFxDKr0oRnh8ti8Fkn+WhKz8EdcVelO/JFSUSRpaBEucuUCq1mTB5Z/tr70ujwL8d7wVZQshxHD2W3OuD4nb9rFvQd+DbOwgUEsNWCV+gqTbAuZrjJodrVyj6FBQl/aVJ+v1s+o7Ev6BiFezQyN
 e8R9C0Jx
 j+J0M6J8E9nkqrck8ZHaoaC89rykuYIGdouP/qy5g15mU6SdN24M41l0F7b8TeDuPL/SWE7VUbP2qNaz1gp4CSCOSn5+XdbnPjA+dmXE3v2Rur+hjk+/v1j+yCF6Xs//hWanfPJRKh1ozP9b9g4UWZRE8OZpUS+hoQ9wV20BA8j3jM8674IiTYoGQVV1i/nUAHdkq1mOkdRvxHRgovhd+tUGZIz10/WsiqxzH4l1Y9Bgn6OSjT9RJP5Es56S/HNLyikWcuTt0480/4CPD2o4zNF6hfTx28xscVYgBUjsdnFlvRf5uIt7KRP004gB5X0KBsGB3/szUV0xAEjbHkbDBtCgxBUrtfHla0anOKYDByjw3oESirwQ50qGa+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 11:14:21AM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/14/26 09:51, Gregory Price wrote:
> > Extract internal helper functions with explicit parameters to prepare
> > for adding new APIs that allow explicit online type control:
> > 
> >    - __add_memory_resource(): accepts an explicit online_type parameter.
> >      Add MMOP_SYSTEM_DEFAULT as a new value that instructs the function
> >      to use mhp_get_default_online_type() for the actual online type.
> >      The existing add_memory_resource() becomes a thin wrapper that
> >      passes MMOP_SYSTEM_DEFAULT to preserve existing behavior.
> > 
> >    - __offline_memory(): extracted from offline_and_remove_memory() to
> >      handle the offline operation with rollback support. The caller
> >      now handles locking and the remove step separately.
> 
> 
> I don't understand why this change is even part of this patch, can you
> elaborate? You don't add any "explicit parameters to prepare for adding new
> APIs that allow explicit online type control" there.
> 
> So likely you squeezed two independent things into a single patch? :)
>
> Likely you should pair the __add_memory_resource() change with the
> add_memory_driver_managed() changed and vice versa.
> 

I tried to keep the refactor work and the new feature work separate.

But yeah that's fair i can just add them to the respective path.

> > +	/* Use system default online type from mhp_get_default_online_type(). */
> > +	MMOP_SYSTEM_DEFAULT,
> 
> I don't like having fake options as part of this interface.
> 
> Why can't we let selected users use mhp_get_default_online_type() instead?
> Like add_memory_resource(). We can export that function.
> 

Wasn't sure if that was preferred, I can do that.

I think i eventually ended up doing that in DAX anyway, I just never
came back around to clean it up.

ack.

~Gregory

