Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AD4BC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ACB96B0088; Wed, 16 Sep 2026 08:48:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75CDE6B008C; Wed, 16 Sep 2026 08:48:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624A06B0092; Wed, 16 Sep 2026 08:48:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3686B6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:48:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6AC971606B1
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:48:53 +0000 (UTC)
X-FDA: 85219604946.17.0F2EB15
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8488A14000D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:48:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=R+U+t9mr;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.230.235 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789562931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VzaI7ZYbqdoJC4coFReri2t1Bm12kg0MhPi/KYFxqXI=;
	b=cgzVqlzIiLVQrTyiWWCoQ/6APHX8GLiAUYtxGiuMZ5/bq2pkGvd4qmeevlKFbo0gdIdTOd
	myrR4kDQJCCG5vVd6DcFHhlAGpyecGE1JJKKEqt2i+/IY0Gbq+xPL8Lv868pgqwRvVW6bP
	9Vb8x1mGYbT6f29qKE2r+d+GS6PXX7A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=R+U+t9mr;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.230.235 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789562931;
	b=LwoQlRBtIHKtFYTrB8JNXSFXUiJl5l7esCl4ZbP1BbuaJITAIIyQBtBqhFgbb39K/oRa/M
	3Plr7D9Hm1xEVcMpdildyR8TphLQFjGJoSUigUr2EZotZTCcrXuooAK6gra/mWcqND8cW5
	jfRSVCG9O3dCzl5+hyHDtFPVt//nVgc=
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93910c9ff1cso75977585a.3
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1789562930; x=1790167730; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VzaI7ZYbqdoJC4coFReri2t1Bm12kg0MhPi/KYFxqXI=;
        b=R+U+t9mrRt8+WrHVP4KqzOuvD61Kn0o2BzsfkZtFHjy6z711fD1d9DUBawuBwlue77
         0LOM0qlNbhu/cQPmg1DagIUsQ85ISSbtN5VdZxBQHJFBO5IQWT7MMtIDL/woSZQPGMFh
         pByB/mhHpujkbWJIC8PKxhH0G1CfNQJu2VGlAw41LHrIo89MVtRzunNGOeVm97wqbO+0
         IoesEm8Kp8HPqfKR4eGUR84cekCEOBpndrN5F54/ulPxaxROZuDSk/FxV1tklPHPjlXy
         a3n4912AZKQ8XG9RSqC/GDnFdNQUfUjIbVi1nwQc6KNKfXZFCk36RicKbtDvvtNTwabJ
         5srA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789562930; x=1790167730;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VzaI7ZYbqdoJC4coFReri2t1Bm12kg0MhPi/KYFxqXI=;
        b=jDexAm+S9SkKtz7Zvuq5O+xArjDhNvN+AR7498xQ22hEjbKueMYg042FFrTsO9AsSP
         SJ4CqZlY7bPjQJjfnMKhmk2/yF6NAmwqggk/Y0+vJ6H2ZvKF+kv8GKPpAw1IrSCwehMH
         Bhb1GypksNbPkXjtPKU7kWH0vB2/rDKOI3bjqEpbLMAjtbgv2Db30H1YFw2SpKYKQV78
         vLZlbGCZOuXXq+3xMj3QTAPqc7YA36deOSZn1iq+Fd8vX0aXNXEgrvJRxTwvAvt4y7gg
         7UZoOocGpKi29DIV/Gwc9TBAu3rBz8ufWmq92vum113GaWEqP/+ckHVBEAzTnPFOKgeD
         bBCg==
X-Forwarded-Encrypted: i=1; AKwUvBw8jae8ROGpGqdg/DiVTS5NjE/G+RJKqlJ4c6BDx2ZlIfexAChQuQbWss7gnTC/WQ2fMEqoeq5kfw==@kvack.org
X-Gm-Message-State: AFuF++m78wh0VaeKNfVfhqvp0J4XHKVGRIgkooqfDwMPtU17MJSkFC9O
	vNWrbOOp/SHUMYnIXFAMCVmb/gbDh4/vZfQXN8+q+gDTMYwW7kOaOB6Od3AeCoTbHbc=
X-Gm-Gg: AYBFou3yfBsOein3BeHR6Uikfcv6gfv26Clw+01gGA/RHJLlJ7tBkIuqLnQihOA0YKU
	gpZeDerxvESgn/fJztspvaDqD6iVEjYhovTglt2wPtu8XsPcIi/pwDfkKQRhnHyNj0z5ZnnDyBJ
	slfD1I9ydExr6B6Vs8eecf62ONg3L83YD2GCOFD4Yq9njEOMikmX9uQRBktQmKOGlyws3N9tfj+
	NX3C8+r7kldv2KikLCioEanOZiGlcZtCD28Zl1e0Uv45RFH6S8xsO/tzZnNyULqyf0ZGIb63tBn
	fHY0RC3V8MeKHhs6t7V1OSlrT4SZoh89qWOxRrpOQxxBiaCy55+UT0ZFPYJE4f0dFzWSay9Iv8T
	duLITw0dVVuF90Dy8XevngQQokG5ZCjmyqOYr/aX+sqD/nNj/RuoScc+xHyEq4H6Kvw7Xqrgub7
	6CNgxnYXu8z5M35l+CZBFxyd89wOenLMvXP0AnesjVTSqdBUruSn50ehIRO1XubevQTBVXO4O03
	cCDHm/XJ9CjRz496afXqTVlhFoLKDXc1fnCoif2lbQH+LVc09b1RhC9lQ==
X-Received: by 2002:a05:620a:d8e:b0:939:6de9:4cff with SMTP id af79cd13be357-93bb7907fecmr386232885a.45.1789562930363;
        Wed, 16 Sep 2026 05:48:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b7821dcfesm208481285a.18.2026.09.16.05.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 05:48:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x6p4D-000000099Zm-0Jbp;
	Wed, 16 Sep 2026 09:48:49 -0300
Date: Wed, 16 Sep 2026 09:48:49 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jini Susan George <jinisusan.george@amd.com>,
	Kees Cook <kees@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Kim Phillips <kim.phillips@amd.com>, Joerg Roedel <jroedel@suse.de>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Liam Merwick <liam.merwick@oracle.com>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Xiaotian Feng <dfeng@redhat.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Andi Kleen <ak@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>,
	Tony Luck <tony.luck@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Carlos =?utf-8?B?TMOzcGV6?= <clopez@suse.de>,
	Jonathan Cameron <jic23@kernel.org>,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
	Petr Tesarik <ptesarik@suse.com>,
	David Howells <dhowells@redhat.com>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Ilias Stamatis <ilstam@amazon.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Toshi Kani <toshi.kani@hp.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Vinod Koul <vkoul@kernel.org>,
	Jiang Liu <jiang.liu@linux.intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Palmer Dabbelt <palmerdabbelt@google.com>,
	linux-coco@lists.linux.dev, xen-devel@lists.xenproject.org,
	iommu@lists.linux.dev, linux-mm@kvack.org, aik@ozlabs.ru,
	Santosh Shukla <santosh.shukla@amd.com>,
	"Pratik R . Sampat" <prsampat@amd.com>,
	Scott Soule Cheloha <scott.cheloha@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [RFC PATCH kernel 10/17] x86, dma: Allow accepted devices to map
 private memory
Message-ID: <20260916124849.GD3196566@ziepe.ca>
References: <20260916115159.1938195-1-aik@amd.com>
 <20260916115159.1938195-11-aik@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916115159.1938195-11-aik@amd.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8488A14000D
X-Stat-Signature: dtnaq4wqa9t7qy7anhiwj77zcoe5715z
X-Rspam-User: 
X-HE-Tag: 1789562931-809441
X-HE-Meta: U2FsdGVkX1+hrVfKLRnI+YIZw0OT1ow9PzYMBrHWfn6+bLosOCqDWiy7aFicMzEAnr8QJ8ZENOFoHjzyuTxbJb7lHglweS8vVJgKNyKNEVN0a7X/LBnFuS8arQuMrN7lzQipRYUUMBklRKlZNY8qsii6/OWLpOeq4T7sx8Vf7UWuTM91i7wbBmDr7cmGlL16FcN4r8/py1HEkRenlpBjXJ8iazSk1dMKLVa24gWH6Te7BBv0mEN8iHAIfKBRYTuEfH3HtDRsvqBNbNOd1m3WdwQ0rN9kaJ4mqg5jhHns0cfe9cEjGopHMDdfYWW0b4iAQ0cqLkeEMEYCa2N3TSqGgbaA8F1aieNy19pD07W7/J7B5ywkCpddIZ4eOw16CCpr/xvctaB0nUeCljDLXasoP2kNdI9mLkF9Dekpq3eLJIcPsKeUPpWS3wFrq2w2aQu2YyXX8gvOdj+cCP/pziLBHdHa8l8A513fMLoBTvqb5fweSyaa2OCkC5H5yJPUJkHDFWOlwqETiQwCu6CsjpH0NEIsJ+o3umyOA8ZhpB68FLVXAatpV0c4d3oPde8xNsaasafaxPYPr3IDO380JZ3Fm2rzWI8FUTGs/I+Lbwi8WKU4h3NmigBCpXTuxilp1tjVQ2Ws/HpTDWNColLFsJn/30ihCGDd5GuLP9wTHEmOyCEgKfN9vqnd06Vxwj8jpZZZMwHDTpXSKMrzCO1wX6Af+6OwC30FzMMnPIN2HKaEFR/lCIfgv1Je1m7FUjnjJIkUK91Ns9/S7QYub/c6FSWa4cZ1dTQiiRgSrdpo9sjonJYAV8EQ7BA+/8o6Mzbn+uz80dy4xsdtopRi/S8y2grKgkINRZENJ2gPbaM4gGcvBrb+VccC0ip3XQ+mm5Vhjlw5YCde2P6RRMjxruDiLQoIaoeaYYA77fjtx+zEOj4d/YNtIY5kXXHlMpjXconMQ9jPXlP7reJnOfZCnHTx/MQ
 +EsRcOn0
 Gc8d5g8qzDPQlN3VpmYxl4p8eTszhXWDQpTq7g/Pt0I4HwEKGsijPd1KiQMqAeqzp1hUSVgUNTpPRvc73s8euj07zLDsNea9VULkM9pB27OUf1c32YBDK3GQu7I0/NlR04M9Zxns695qGpGkjCPkhTX5tlKxsxRiQO2hrsacwItTBQ3vU4RrdVI5OIqjfsVeW5BPOzo55K3yHgLbZH1VHwOCTJVLEILk7cKetopv+aQPVypePOitO04XRzL9IJHC1P29lzu0dQOq3gKh+EkBvATbdeOdPLAGPBMnO9AThwy1WTZl9dRbRP1vA9CRaQrw8oAuSjXhm0JLjPUrourCHBiOH3YksJehCHxzZRPPbyPxSRyoB0XOK7yPH/DGY17pqW8Bty+DlH+6jh1pA/d6c7nwOaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 09:51:50PM +1000, Alexey Kardashevskiy wrote:
>  bool force_dma_unencrypted(struct device *dev)
>  {
>  	/*
> -	 * For SEV, all DMA must be to unencrypted addresses.
> +	 * Require unencrypted DMA unless the device has been "accepted",
> +	 * enabled by a TSM driver to DMA to private encrypted memory.
>  	 */
>  	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
> -		return true;
> +		return !__device_cc_accepted(dev);

I want this out of arch code, after Aneesh's recent rework Nicolin is trying
this approach:

https://lore.kernel.org/all/abddd433493324a6bfdf8ba9710e96d90f0d1ccc.1789010941.git.nicolinc@nvidia.com/

Jason

