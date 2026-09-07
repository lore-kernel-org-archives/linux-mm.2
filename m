Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ACE6C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 17:03:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3956B0092; Mon,  7 Sep 2026 13:03:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773C36B0096; Mon,  7 Sep 2026 13:03:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 662986B0098; Mon,  7 Sep 2026 13:03:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 331C86B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:03:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B79D4C020C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:03:42 +0000 (UTC)
X-FDA: 85187587884.20.2872387
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id ED6314000C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:03:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Pk6CuCYi;
	spf=pass (imf27.hostedemail.com: domain of vdonnefort@google.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788800620;
	b=rCqvsVK08i3yCHex4KFTIOs2rSdpmWnGl0kHx/zWrFsWrnneZVxerVvcBKtVD7a17Ju2s7
	dfeiKOM82KcBBlFtueRaBZ+euozyLbliKmsqbnteapxJ6mfit5EbMEPgtfjJeqihy8gqyU
	wsupqO/KQKwNsgrf0Qw1mAWY6UgWHfM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Pk6CuCYi;
	spf=pass (imf27.hostedemail.com: domain of vdonnefort@google.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788800620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/2WLxDmERbGCh7iT/2ZThPPuDMwAWqV6GCdXRr20bA=;
	b=FcPzbOJ9Oye+RCBh8z/y5pAP4Kh5lJTMzd0tKNCcnKGM5kPlB4OC9cPnbgY+mCv/g6omhA
	17tiEzMx/5ZZSlrn/Z1dWuVYdFBg+cj0GmzwhUl16ueOawBEUS17Pldu310wXjiOUyxIsx
	JiTapE3l9HhOunzLLc1yidIQpJ3uRwU=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-485843aeab8so4218181f8f.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 10:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788800619; x=1789405419; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=D/2WLxDmERbGCh7iT/2ZThPPuDMwAWqV6GCdXRr20bA=;
        b=Pk6CuCYisblej1PABN68G0Dp20ntCHFGDWmVuTqaeTyaSNlCgRfIAacZFHVskYyzCX
         HcQ4/XN4BsAZ4zZ4e+uKLoFk8mI7oXYLljFuGzntxotmdm9/K2EeLrIZtJBbpfBFIXlU
         pXZovvjot+Z+204KJ0sUYXonuW4kL84eLJek1jm9xzSnJIDVlnzMaPDKS/hYfxVGf3Ny
         Ew9xNk9MgqjusyIJ0OweRr7TzGw0d9KH5J4qjYT7Kk5NB2SvaRXrdCXfLDPHR3NpnryP
         wy7sItUb7lH9hRNYnqGVTGGDONxZdiScMj7huoSiISxf0eEtzbOY48yWLJgulxpqeOx8
         TDUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788800619; x=1789405419;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D/2WLxDmERbGCh7iT/2ZThPPuDMwAWqV6GCdXRr20bA=;
        b=GDrJteGKcIiJkFSNiuZS9ufVaeV1KOBTDjdMi7l8HlqJRohuftZsfLbU7gxhfIdKTd
         K4noIXEMAKFJ/I6wWtXzHVBwB5W2WT8i9oaj2nYUaWiJMLGckycItHvghtTOumJlzOrg
         fnlkdfhKPAcF1PQCiJiu8cMSwTT8PplDGPDvt3CJPAKRJahrrW1k7oYTb2YvOyZ+10fP
         uNp99kmmXsqunuEbgHv+KXDjTZ5Qx5rAUINkdvR3U+8JgRCinNF2WV+/iMiCt3Zo7hmo
         nKcbOtFilNQALUcGnPVgy/D0lAgTNmM3f01rH+IrX/tZwlb6t/zKHcx/QkaHqqQg/tzi
         UDHw==
X-Forwarded-Encrypted: i=1; AKwUvBz5W80OBIPryqD+GH9rPaXWnhn7AdkFI+iKNU8zHKiyvMI+5/LdjYehxBu01XAWcr21LwtcTMrGNw==@kvack.org
X-Gm-Message-State: AFuF++mug0vo4tZb1DqDYM/kQXsZuNDfHW07f1gciu4cazT5lPFRT7Ra
	OKIYsRuniMo48/ZBc04VlZOAiTHEW8AR2RwRecxzZjioeQRjvtcCg7mTWDXzjYssDw==
X-Gm-Gg: AYBFou20HmcNyvYkoufz/N79m4SsSp7buIy/3RMmlUseYc70gpRvrqY2Km277Z/9eEl
	2AE6yJsHzrbb9/mqpcBvE97dV0aRZR3JOCDH2IYCyHz27L9bU8e8A0qTB+ZPxpuLbL8gAGUOOSL
	ZcvmIXt8keCOr+2cY6OibDmFhtKRr/b4kpmiVjPw1ynLXMvtZ3e3a2rUWcjqG4WthN0Ga4qNdUv
	fDox8iqhcQQdzCAiGP8c5sc9EILGcFz8+4DN4HYRoOA8yfgTNSoGaZMgkZgRjeAsvjqaUgSytU3
	NVJpyrE2+tybW+xCHyaEqcaXpec8Y+Ts8292N28DxzfMWq94Dt8uNHjDOliEk3os4kT7w1mP1Fj
	vq0onlckquQelvFPgQtJJeBEaEdf7fnoIKyNHMtfecoU87kFYz/bBH+tL83DDerXRTSA6hAfuBH
	B26CHoSfosuNhTp8qUuhSAnKKuHPdstLXU0dm+sTAq09sKoSlkwtNvIEyezGqidTIDEuEiX4fWT
	X0dmTkW/Im88jORINLeoWsucAzdsDa6
X-Received: by 2002:a05:6000:605:b0:485:8b66:f5 with SMTP id ffacd0b85a97d-4858b660161mr42549469f8f.18.1788800618759;
        Mon, 07 Sep 2026 10:03:38 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485883927a3sm23089736f8f.11.2026.09.07.10.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 10:03:38 -0700 (PDT)
Date: Mon, 7 Sep 2026 18:03:34 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Thierry Reding <thierry.reding@kernel.org>
Cc: Rob Herring <robh@kernel.org>, catalin.marinas@arm.com, will@kernel.org,
	rppt@kernel.org, akpm@linux-foundation.org, sudeep.holla@kernel.org,
	jenswi@kernel.org, mark.rutland@arm.com, sumit.garg@kernel.org,
	ardb@kernel.org, david@kernel.org, danielmentz@google.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 02/10] of: reserved_mem: Introduce "ll-map" property
Message-ID: <ap7uZuGraZ2N58c_@google.com>
References: <20260902104712.2399797-1-vdonnefort@google.com>
 <20260902104712.2399797-3-vdonnefort@google.com>
 <20260902172436.GB1440252-robh@kernel.org>
 <aplF4NaoFk73d-c5@google.com>
 <ap7CAowlFTFhSFP9@orome>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap7CAowlFTFhSFP9@orome>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ED6314000C
X-Stat-Signature: qydf5zjtp7m4gz4h5cbbi6frzcdbcwnf
X-Rspam-User: 
X-HE-Tag: 1788800620-179596
X-HE-Meta: U2FsdGVkX1+58z+2hMvC0A7vuEbDsgqSvvc7AZxg6xdPSME9as7gdmqZNdB+m7T/HvirAvAVJmYEfKG1/NV7D8mZtxXtK5dgYMQIh0guQLe+iZXBHpjVbeOyKj19p5WaD0sL5uLeo1z23SaCC7xGustd8QojkphA0O2Ac/6OMym7JxzoKZ7wXEhnGTKMtMOW+4NBD5WGHRikyE8XLqpF+p0moZuGN2tgWHh13u1+3X5uSRR5bFcvnu/FhbOjGIXHFl04px1pth2+s1Fz3XSAaFrVx+viy95iWA4LdSJwUzGm5egmWkiT+pgYYEYsO03ojr70e1+oEHA6Mnqrc/JNu4btTndDAJl+xAOCVg+LvL+Zdoz4m+BYX4WHAbVazCDnMw/MYItbbv0AvxD0lCXhV9/9IT/ZfoZKXGI5Ln7AS9cwXcB8woW5Vr0WaEFf2LJKzBwJFhvB4DvPyqPa9STf/OCM5P0RIBFO5opJmgocQXucqsTVHYIENuClrUzmkFFJh3CB019kvQTqFK3WWGZxf6XyCccFP4euq6jE4dye1HDARV4VnhSlnLzKI4NIMp5DkBGZr1JTA86tMCOZee9RaQ1kKCaedo44HbtE8hzC+agKsLU0Om59Pzbhs2et0m7fAWwCJrA0a6lndISM/T3BffFl8NIK5S4taaAA+rohaNkAiaY4oVcPrGQrtltlrYJ87n/4dPJFWUrcmz1l3JD8TZ8y0JsvnqhcapHmIEv8shRL2QLBV9PO+ok7l5YgY7zx7RScUJY8m//Gc5d53loGF8wQySmRVLQaJpoawPP9sRC6G9fP0RS/20xef/JvGfNJVhuT7k5TdutWvjixdSuMdy3YgM3B9XHqXCeqsHfjyY0UDFhAIGRLU7tmv8mbtihYkVOUgt9BBEJrZ4mMasNGtG0E1IdI36wwXu3/x6TzEQ1GHWq/qlcMqyLJZHSM+nOa7JGsUSsxyRNMys8bUiE
 CWzKAMXd
 CIxX5ZxdVF1migLGsa6EaV8PihW82/ghdjTPcdxlyE/iVUWj8wz19WNX6diwlfVcMMToDalgPBEWWry4SYIb24Xb4VXQYUAHd2VW8Jad49M8kAamagd8dETWW0FnVAEFcQY7cO+9USGConw7bg5ygaMGbtkLaRs9hYJ/8V/evtcYvfHKSREWkj91MOzQVU4H6/R7AaObzFLnMQrEdyK6MAJmJfIPqJ3ETuF/eHegFHlH8hHHO7Y2/UECAsH89dd39bT2+JocLM3G58nGdV7BSiZqOvWPV50YazwFKlu6HCucl2d/myLO1PyU5JzlyoHRzEqL0haf7qyb2+JZY1qx6aBuSaRFoEn/+V9kOwpEtWdMHs3d5B++r7iGA9blmj5rCh0J7FxU9Dbmt5+G115OnhHEGyDQmvKZ5wkMu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:00:19PM +0200, Thierry Reding wrote:
> On Thu, Sep 03, 2026 at 11:03:12AM +0100, Vincent Donnefort wrote:
> > On Wed, Sep 02, 2026 at 12:24:36PM -0500, Rob Herring wrote:
> > > On Wed, Sep 02, 2026 at 11:47:04AM +0100, Vincent Donnefort wrote:
> > > > Keeping last-level mappings is interesting on some architectures as it
> > > > allows mapping/unmapping pages from the kernel direct map without the
> > > > risk of splitting blocks which, under the break-before-make rule, may
> > > > trigger page-faults the kernel can't handle.
> > > > 
> > > > Add an "ll-map" property for reserved-memory regions. When set, it
> > > > splits the underlying memblock and sets the MEMBLOCK_LLMAP flag.
> > > 
> > > Where is this documented? Any DT property must have a schema.
> > 
> > Ack.
> > 
> > > 
> > > Though I'm not thrilled about more flag properties. Handling all the 
> > > combinations of properties has proven to be painful. Can this be implied 
> > > from the compatible string instead?
> > > 
> > > Rob
> > 
> > We need this before the kernel direct map has been created (paging_init()).
> > 
> > I would have moved that directly into the driver lend_pool.c, but then it is
> > probed too late (unflatten_device_tree()).
> 
> Any of the node_*() callbacks from struct reserved_mem_ops get called
> prior to paging_init(), so these could be used to manually set the
> memblock flags in the corresponding drivers.
> 
> Thierry

Ha yes my bad, early_init_fdt_scan_reserved_mem() is calling ->node_init()

So I should be able to drop this patch entirely to do set memblock_set_llmap()
(or memblock_set_pte_map()) directly ino the that new FF-A lend_pool driver.

-- 
Vincent

