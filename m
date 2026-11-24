Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E614606A330
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=EZolgW2F
Received: by kanga.kvack.org (Postfix)
	id 9A3386B06FF; Tue, 24 Nov 2026 08:54:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97A9C6B0701; Tue, 24 Nov 2026 08:54:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8913B6B0702; Tue, 24 Nov 2026 08:54:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 644926B06FF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:54:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0569FA086A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:54:28 +0000 (UTC)
X-FDA: 85470157416.19.3E4E148
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0FBBC180007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:54:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=EZolgW2F;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795528466;
	b=etWZikLhvKT1Jx5lAGnJswo8gXbeE+MSZMbLoDD1o6agrH77b7NxC03BEu0hrGiUJVfM/0
	ccurMIPrySEnwlPSovZubqR4ldzYHWAeiAWDHJGHP5J1hHnPAcVA8EKDQyfVYP6DrXvx54
	pXXS6cSnxGSTFPengPcl9FVRwmkDQvM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795528466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jEatzr2wcCwXaEmVaXwZZOqjiW5YqebF/1TV72BGKDU=;
	b=phI4UBx5UAJ4IiIrCUagaVtScolySwgEo/5ebRHRQavsUIVinII7m4F9L2dWXCjdgU2aiU
	3gUW7FSHxYe+14VNpZpUyepZo+uJtikVJKqTMsW3Ul9+Hee99oYyKSEJnBiMGgWx4mlXVq
	QXltrRtOtz4jnAldTOMS2abZPRHdh3M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=EZolgW2F;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-55bd96affd2so70718181cf.1
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795528465; x=1796133265; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jEatzr2wcCwXaEmVaXwZZOqjiW5YqebF/1TV72BGKDU=;
        b=EZolgW2FqQwXMc55+rIkXhmwghmoq/TVEml7tY1ttDV4nWgxOeFJSWocroEGt9ggzc
         n9uTlZBzkZv2UaDAW7V4HK5MGOBv6ac37VcctTm2eicQf3QHS3pSbfiecl68g+SuJNIm
         Kb3RKrjhPrn7+Y3IRmkgGqa8OqUAJgX73eRJP4VbbyHoeAe4hzJxI7wVA3PYp0f3LgRd
         PD/3qadrzCFx+Ua8xYNXS5bA9sXxEf72Vp7reoq1ZcYYBjqJy5BwL5AIMbBrM84Eo/dA
         7qDx2zNGnZsFbIEJPkss1BO7Hraa1JqtJ4X6vSKpzIYf9l4WlxDKJhB9TbnYdaGbvw02
         pqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795528465; x=1796133265;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jEatzr2wcCwXaEmVaXwZZOqjiW5YqebF/1TV72BGKDU=;
        b=I/qgzLyftwF4TjnL51WvzhqHvBqAFfAWaien5ndo+kJhNHKn1yQbTrlff2r8w54lsw
         42FefWzsFoWkkSgLzTXomhsEAa6MMW2z4x3z/U9dFrPEu2dHOMqqmyF1GA7mXAFfPQSI
         V9EhqDipY0BaQfobB50nJre7I8xQosCroUd6G1UnbOW3+KVCSzmNfesGInqxggrjaR9W
         7jI6wQfsq+/CHDonEtKhNbh/QqJdXVlyXx1UQvP3iLpsCyjPlTRPKj8C13EH0W/WThxY
         dEv9r6SsRX6huxuHIBwV+UUWAzPAHs9ocSwo1Od3Vj55O/PQtJXegbUxfL/6SVLZ0Rw/
         PWXQ==
X-Forwarded-Encrypted: i=1; AL+hErHhu0TLqp/yXqIYMDch5jnyenxqH4xZbwnOBnBhSexJBeOYOI4kehiTHF7/OTJl66VmEnTExke+gw==@kvack.org
X-Gm-Message-State: APuU4Z9tfDke4JWJ8OBBig/KdS47zmpSN2TaMOlf2SrxGh9WYUHRBq8H
	/IndGN3d2qWGNxZGYz//r5kbROSxSrabop7iPChlWjDA8OmgfBMFdfDantsEt2Pl+T1ZvUAhJxA
	ar6Rf
X-Gm-Gg: AZFdTZciRL4t5PBBNNjuchPJrB7mNt/p4sScGd/ofkC7WjeMxT364Gfnsx2sGBtlREx
	1ousoYLE28MphpfEV2AwWOU4XgXeeDFBKI9Z6wG1E/pjGThyDYSCfkWUDIk2+/R0PPc/D0BpMhn
	GWODBgvxnFpftM0HEeQSK51WJCdPhGOxdaVFAaQgRUAcB30Gf+Vig3ou9C8CNWY9FTVYk9dmZWd
	4aHELKqlGA9SEfErFawSDUZS4J9YO1kHyH1ciKrjk7WSS9a0FDULQZC/14yv2MJwNS/wbBLjWyn
	FZDx/M9w2UEzL6eku5GbdVB8gseMFBan+fUGlVvORB+sPmKjwfQbr/tIBMgQrYiJv/KA5JIyPHA
	Yj8BvbSSHVCXkIk4EwsB8xiNbLIlc4E0lk6Kq6K7NfsyvdJcNG4ir4Bm6rNKKr/MsAXmUUcpFKp
	CGIraadhO1vAz/ssm1DiR3K8y7OqyCNsWFGlZI3ht4M5FoKejRoPAhzmqSKuwFSuhaWIEjElH9p
	Q3MrXEnD3+eWqrOpUZENrxyO6lJylQXq4PumUf9wvWJML13c+DdU516anFou6HYpNgQIXz69xAf
	a9Xwlw==
X-Received: by 2002:ac8:5a42:0:b0:55d:3669:e04a with SMTP id d75a77b69052e-55d76a30b0dmr258015381cf.23.1795528465232;
        Tue, 24 Nov 2026 05:54:25 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d788ae02fsm125554721cf.29.2026.11.24.05.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 05:54:24 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVqyW-00000000QaE-10f3;
	Tue, 24 Nov 2026 09:54:24 -0400
Date: Tue, 24 Nov 2026 09:54:24 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
	will@kernel.org, Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH V3 00/14] arm64/mm: Enable 128 bit page table entries
Message-ID: <20261124135424.GL9566@ziepe.ca>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
 <20261120190525.GC1133597@ziepe.ca>
 <aqcypbxidjbmjhuiujg2krseuy7v4lofrlq3upl4s7yjiq6bh2@3s4jqisdrkgd>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqcypbxidjbmjhuiujg2krseuy7v4lofrlq3upl4s7yjiq6bh2@3s4jqisdrkgd>
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0FBBC180007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 3rcrifd3hudukkf6xahpwqqzy7s6gdeu
X-HE-Tag: 1795528465-750637
X-HE-Meta: U2FsdGVkX1/9h1oOZmOG9fJBpEjZ4gzSN6DROBfXarYCkoJvg0vHtRQ5Tpn1p+izXLwovX4b3SlpUM/tTEd61uqs3evv3277K7uLGJPf2wdogjMx/SN+X5BiPRt0CJJF1nUj6MDF6x8dvYfrdgetZIoVrZt0AYnsKwKMOUyr87yAhVERcoo7MKWkXFayACRRrFKZXurmBs21+r5fbh4ncRGzbC8atB8nuTgxj8nGRaABHuqCKUzkTN8g2OUE+7VCLskPDRKrDotGLubwCiBGV2iR4hM943ZEDlLtemrkaL/N9uf0ysY8z+0CbMEHcj+RdIkjVgGraELTFzwiB5jYesy1f1wvDTr+lz6KtgZL91IJKxq3O5AZ2T4IO3ywkWLkXc1McoeWtwiDp5cPF1LbLDU0tue7OcsTZ9RDZ07bVZAkGdd/qa+lpoNYLFRAgyrTr8aw5c7YEOhCusgjzioY9EWAxpmdyQmNSCVnO/xkYqcbc57vJMtd947cTIUQh/p+wsKU+NfHvG5ns/pewab5XCpJAFoAvzRjydxEceE+HCd3Ndn8p3ymOXFClP/WnswsvzzHgHrpzNodO4i4SAaTKVIhjZqLq42m6PK82KrM7ipWGhcZ97No0uA78cm0TGGntDGL8w64QgdXPzn4JGsFZRO+G+vfcSAL7zWGNvy55F/FM7izsjmPmvi7uskVuPV/sDUawso8805TpEVtTbHYAsg+IC+ebR9EeRrUyUgd92JesPTevpIvns6Vzt4GHQT+CMqqMYkLf64yJSz/+3XrJwF8VRgMn1VZrk3O3gi/oMBHVmn/ALBXY8egIoQHgkbCysJvRXHboiOUca5V/rbin5uRByZo/MU0V10Hw8ELIGD945HKXFcPJI9PancUXP054vPir3BzWOwwmarfdCGVMjPxWbRM+LglGcDMAwtX4HvTl0waPdAQrZIbdyxX5f7w9wtp13FPmkf5QDOhYgN
 HG0wsbgl
 3xMWpzahCWiFJrdbQdIheMNHfxrYxmhIHUHqKAjDfb2oPBSa4NQul60JTMjrIkmlaWtkPn0Wi/rkKcMbWiIECvXrm8jOelpsGDBfkvobnAxxluKVku3tn1VIXxq6B6+6NyHOjKVxQaQrJ6caT5GytJpmLiWb2/d7nPN9F0e6yqJv9iYvYrF/eFwb8xUnq5Qw2ZARk3jLNDpWLz+NrJEZD7ecOYNQ1VkNrTRaN2gh/BSCj38lRJw4ArBeCbH/MSVSK1eYhRTNogCNFdJgJTaqhyirtrEp7ct3dRmIHcW9eGvKC3bZBHJAoQnUU1QEMLbVboMAYDiIkNtxkpt/O5ItisqRskn3moJ5+lODBWBrGARRPLIoZV6Eutse/MTxByM5m2D5bPJKA2XoDyYq+3ChBoy9XbQ/MVPP77PT2DcGBLBrFj3wm4XmyJ0frVrkUh3LZft/4pl1V3BWDAFaLXGtdd6ZXVCYbsRNzvfBL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 09:29:27AM +0530, Anshuman Khandual wrote:
> On Fri, Nov 20, 2026 at 03:05:25PM -0400, Jason Gunthorpe wrote:
> > On Tue, Nov 17, 2026 at 12:35:59PM +0530, Anshuman Khandual wrote:
> > > FEAT_D128 is a new arm architecture feature adding support for VMSAv9-128
> > > translation system. FEAT_D128 is an optional feature from ARMV9.3 onwards.
> > > arm64 platforms with FEAT_D128 enabled will now have two different memory
> > > translation systems i.e VMSAv8-64 and VMSAv9-128.
> > 
> > Please don't forget to update arm_smmu_sva_supported()
> 
> Sure, thanks for the pointer.
> 
> Fow now will disable SVA with CONFIG_ARM_D128 enabled but later it can
> be enabled back with SMMU_IDR5.D128 feature. I will probably fold back
> the following change in the series.
> 
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -205,6 +205,9 @@ bool arm_smmu_sva_supported(struct arm_smmu_device *smmu)
>         unsigned long asid_bits;
>         u32 feat_mask = ARM_SMMU_FEAT_COHERENCY;
> 
> +       if (IS_ENABLED(CONFIG_ARM64_D128))
> +               return false;

That seems wrong if the arch code is enabling this based on a CPU IDR.

I would expect distro kernels to enable this kconfig unconditionally,
so this will break SVA for everyone.

Jason

