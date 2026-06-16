Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E048CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 22:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B4A06B00CD; Tue, 16 Jun 2026 18:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 064C86B00CE; Tue, 16 Jun 2026 18:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E958A6B00CF; Tue, 16 Jun 2026 18:38:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BAAF76B00CD
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 18:38:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 223B0120275
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 22:38:12 +0000 (UTC)
X-FDA: 84887240424.07.EBDCC59
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2E47E4000C
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 22:38:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KV0oxm1q;
	spf=pass (imf01.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781649490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0bi42mNvv8zEfpJesfq39j8DzoTdUbmNl2yt46Rb57o=;
	b=QfepPt1+9OTrmnfJcSYp65RW6a+IEghe1qGazfyV9XLCRGlENk0YFrBvu0g8Mxcx4KepRu
	EPAztamGLHFnbhSB4/uyC6qTuxT30x7h4gipoFn/OZCIsc9qaG7relUaxeTVIU+sHbeiXp
	O3IKD6s+rMI7SQ/96j+l+fUdbiRLRn8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KV0oxm1q;
	spf=pass (imf01.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781649490;
	b=5248sHXbfbcKfKOftRkO0TlR29/T9AZ1TOeAIP75jX+Z3CcTfXlioz574ILlM1K4ZFpjZf
	EmGT1/1Nnn/xPDF3k5AOJG/RALV4/csgzJNcuRdawJ3Zymh8zSOfxHerOK0pqXRw2FhsLJ
	ZJ5KAjFmEImEgK5Rx0HCqeYL0/BBBj8=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2c6a4eccab1so8585ad.1
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781649489; x=1782254289; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0bi42mNvv8zEfpJesfq39j8DzoTdUbmNl2yt46Rb57o=;
        b=KV0oxm1qzt63NBgg7yhY+ZjS8MS9fDtuc8d/+Lzl8SyvOdBsz3i/We14cLBmrZxL28
         7r6zxESNX/SEgP8BVMGskXk+sY/k2Cb+KrxL+P+gk6JQIdOhte/YRgBCZCbMAvw3qhFc
         upNuGQEmMg3SlCDcgkv9hRbwKSn1z6osvGB/zjIwZjD8/21cgyOVYkDmYlnCVrRKYxJW
         WK18A7Q3WO8Mv5whhENjMrs901mqCsZdm9lpnJ+zFWiV1XcgJQgOmxMzkDVoxaJeCkRv
         i6i2ydBqW63I2vGalAf76qIcXI0NPHL/y8CL3T1SFpTHnAScf6DuwwTn+Xa9LNxFkjw4
         xzNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781649489; x=1782254289;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0bi42mNvv8zEfpJesfq39j8DzoTdUbmNl2yt46Rb57o=;
        b=pH8MKpMg7j/i6sahND9edgUYx8ny8BSWB7dfSyFvQ3RwZCSkAHP7ek0XoNb5POqoi9
         05jvw+dvpZyVs1FlhUV2gX4IuZ2GbTC94S268uBtT+5R1Lv+otiwpK9bXruHi5JuxoCz
         lCGlDQ3anEbNGHphOSGzSZmfUGXWRzs5ai05AmTwMvG3KxZwej11Fd3IpDJoSeevlfiO
         mGLnvfYMtWaFY5GYqwytQt0VPwRukX5zG2OTfnJ84t+qJzZcubYuoc0plEpuWc9RkOuL
         Hsmdr68mYzjc6r9jX8a6ICgLUZ9sYNCeJu58ZdtYoaZGhe/dPSPwqbmZWOE+iVOXz+G1
         pTWw==
X-Forwarded-Encrypted: i=1; AFNElJ9NIyD740Djpo+Ma6hqkLtaMXBKWh9pALkt8CcHkG+XSMAgIPkReYyvgNPsxCUl3vmX7LBTEfuO9Q==@kvack.org
X-Gm-Message-State: AOJu0YxuSib7tLR/fRGt01xwtU5PHlntTS9Ot9p9rQRglgED+3ZXgXsC
	SHIfAOtTBlSudGIScrKzrsLHODOtHJlw80NQ6ycRhmIlS4q0DGUl+CsdNrkS1Er62Q==
X-Gm-Gg: AfdE7cnsogYMNmk4jCwHHOSvcwfZ/p1MBLu8rZj0bs/KDo2dwUflFY6s2AjKm0Wn+rn
	8Tiy2e8Y5AO7qD6XB0uTBUdOFlN2CfZpym8eGVvB0Umlv52CEjlAM6Xg5TKeABTiYkEuZuUuG4L
	PqLac0D3Sr0GdaoFHB9nYXNow6wNKAV2y/hTWfO/+P6voywkxIgxOCcyJcjFRVljzBplLpGe1EW
	lJsYYLYLcDB68MGSI25roM3281diR9A52x1DZwbK4150y/N/vIrY288EN+cJsuStjU84ZcstCV9
	tgukAtOF+YI+8PSQdEnwrcZpDaOttALFXKgxFLDw1iyg7lrhO/Rsib4Vhh9J2epb/ifk+J9DCOW
	JaLMGI25krnMQh+x7PcLAmoFgZkNHmvBSV1PtFeAtRCX+NB4EsQLPkjlDQqnTqQJ8D/8Qgac/GA
	AKwXzwI+/0aUrK7WBTH+XWu1t/yXg/2iuO5EWpTYOQgAxdF94+8nwhdQlBzjxBsjvssI3KQD2lY
	weBA+eMkrc+xQANemc=
X-Received: by 2002:a17:903:289:b0:2bf:2e8c:db96 with SMTP id d9443c01a7336-2c6bd35b47fmr636505ad.5.1781649488392;
        Tue, 16 Jun 2026 15:38:08 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f2e5590sm159640205ad.14.2026.06.16.15.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 15:38:07 -0700 (PDT)
Date: Tue, 16 Jun 2026 22:38:04 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 03/12] PCI: liveupdate: Track incoming preserved PCI
 devices
Message-ID: <ajHOd1lkBJTySVif@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-4-dmatlack@google.com>
 <ajGpxMXk9iyXLzC4@google.com>
 <CALzav=eo=UwoTNTYM8Z7uKoihxfB7NtVP701qidVgoqyBKhUig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=eo=UwoTNTYM8Z7uKoihxfB7NtVP701qidVgoqyBKhUig@mail.gmail.com>
X-Rspamd-Queue-Id: 2E47E4000C
X-Stat-Signature: hzf9conyota86mitbnt6f6or8ywmcnay
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781649489-715937
X-HE-Meta: U2FsdGVkX18BNApb0n1H+toN3Y3JonFwY5FdTW9IrXENal94vgXJHSaLjFXGIzA3FeXCONC1AtbsKC0u1EHOzMoFHJqnmOfoRJOZYjAFB1ZNKi5Ki+4EM21X4FUEcRkkTVZz0uoikYj/f+679S0qplm3Upydc+fgLPYWCxcMdSvyzNFfZ20IBs1qBFgXg+byydWFgi6fiSHL37CFEmQIKStMt6y5zb7VJDM46+1O4piMSCtT+vVFgqv2ZbTDXjrh48lBornJj0f8p+y7ZCNGNFTWnLkqQr7zOGK/JbofwBeSS5PZ5wN5PXrRv/Yh/ZOPGNjTocQDz8HlWM/qBMhFaF7HP5T+ca5N2rRzTuLXRma/ebfd+R8Vgq8mhgGsmJu53c01PvObuNLyGwWNHcvx9b1XuonlsdqCEWmSDxcdRZhBP55N+3R147k3aDzKIdCFkUKcQCIdxAid7bLy9WZufSZ201mpthq0rg+m91TL1m7s+3aXO1OGRd0w7wqpLa2RKOfL1WQTGMP2O/Y4Px1hD1UQ0REhlhl9+KhOlKC3mOZK3RtBylnH3B8TUwaEuJwreqfj0GTy8TnU6OyEr+tcX9dFGEwwNuN/8lPsnOHxHnw4tbPgKK4/D4fBu1TTAT2lHRuYAokDVI+Taq4zhx5N9ZuahfRo6U1TLi33gYaSqwJUvPpmObB83ReG/+gJ+z1jsvtIgQ/EFMH6FxwvD12LZMx0rPDO6scm4GA2YvVuN+A+RrM8NHrDK5VN7FAF0u4P2uZUDMcze8pMTnzW2gzFZKTAJY/vRIwDSFu5gzgIUgQZgQpn8Z/9KREc+zeaq4bhwseMVXO82w4JWPzRfu4jS/R2SiHylF0vTCdGfLJ3F/GDWNrCcrWoyfrHPFlqCKf7V/eCqm0b8GMnkrIRRDFiEE0AKyJtymlaKiTnJR3/8gM7bctMxwnskLB1WLMq3B+HQuE976D86CcDv2OwhHe
 J0YBpwgy
 VRCuyJNy2quyn2/LHzws6Fb+gz/PLpHzc3vk8BKIWXqHdB3zXaWsV0wRJ7s8bM/Ol1sWBe6vNItORKXzTsAPrEy2cuk/Jc2JkFbnjuyogI0v6L5riS6/qOHsfW7G+Bi0AJVvOol8CchITxRnZkg/TuASJYxxpIkQprTFGdacLFQl86e/M2nHGmfvHFvLfSQDiJuytNld4XmPEWjKwqcYxdMPeYyNb07eSeEDZNKq2JoHXI8H/6oxzfT1Cqvt0SIFW+czFGNWIoApYVuka08RS9O/syV+huCnzNlQ+IiE0RDJxdfLAVY6mMJdbya+BSYncOxnrRblMKPwmaI6BKpBaLugo4RJOXD6mvOwHpsZ1gTZ1iIo68dFqPzh9JKBM3WX+XABOkdsrsW3EnMx/JiDP3G8xF93yIH/9jJ6QhgRTg99kTSkP/E65s5lINTqiPgyovN1E7aEWfE/0ML0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 03:20:33PM -0700, David Matlack wrote:
>On Tue, Jun 16, 2026 at 1:09 PM Samiullah Khawaja <skhawaja@google.com> wrote:
>>

[snip]

>>
>> Hmm.. This is interesting, so the KHO state is freed and it cannot be
>> reused. I see you already pointed out that we are putting an LUO policy
>> to say that the retry is not allowed.
>>
>> But what should be the behaviour of liveupdate in this regard? Let the
>> system boot in a normal way? This might break other subsystems as they
>> might depend on PCIe restoring state properly. Also I think some of the
>> PCIe state, like device-id, BAR addresses, ACLs etc, might be used as
>> source of truth by other components.
>>
>> For example, lets say FLB retrieve() of PCIe fails, but succeeds for
>> VFIO/IOMMU, now VFIO/IOMMU are restoring state of a device that is not
>> restored/preserved?
>>
>> Should this be considered fatal?
>
>If PCI FLB retrieve fails then there are certain things that cannot be
>guaranteed, such as BDF (B specifically) remaining constant. This
>could lead to memory corruption as the IOMMU may have live
>translations in place for those specific RequesterIDs. And, in the
>future, preserved devices may be doing P2P which depends on BARs not
>moving. If the PCI core cannot retrieve the FLB saved by the previous
>kernel, it cannot make these guarantees.

Yes, this is what I was worried about.
>
>So yeah I think you're right that PCI core should treat FLB retrieve
>as fatal and just panic.

This sounds great.
>
>> > }
>> >
>> > static void pci_flb_finish(struct liveupdate_flb_op_args *args)
>> > {
>> >-      kho_restore_free(args->obj);
>> >+      struct pci_flb_incoming *incoming = args->obj;
>> >+
>> >+      xa_destroy(&incoming->xa);
>> >+      kho_restore_free(incoming->ser);
>> >+      kfree(incoming);
>> > }
>> >
>> > static struct liveupdate_flb_ops pci_liveupdate_flb_ops = {
>> >@@ -270,6 +335,91 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
>> > }
>> > EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
>> >
>> >+static struct pci_flb_incoming *pci_liveupdate_flb_get_incoming(void)
>> >+{
>> >+      struct pci_flb_incoming *incoming = NULL;
>> >+      int ret;
>> >+
>> >+      ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&incoming);
>> >+
>> >+      /* Live Update is not enabled. */
>> >+      if (ret == -EOPNOTSUPP)
>> >+              return NULL;
>> >+
>> >+      /* Live Update is enabled, but there is no incoming FLB data. */
>> >+      if (ret == -ENODATA)
>> >+              return NULL;
>> >+
>> >+      /*
>> >+       * Live Update is enabled and there is incoming FLB data, but none of it
>> >+       * matches pci_liveupdate_flb.compatible.
>> >+       *
>> >+       * This could mean that no PCI FLB data was passed by the previous
>> >+       * kernel, but it could also mean the previous kernel used a different
>> >+       * compatibility string (i.e. a different ABI).
>> >+       */
>> >+      if (ret == -ENOENT) {
>> >+              pr_info_once("No incoming FLB matched %s\n", pci_liveupdate_flb.compatible);
>> >+              return NULL;
>> >+      }
>> >+
>> >+      /*
>> >+       * There is incoming FLB data that matches pci_liveupdate_flb.compatible
>> >+       * but it cannot be retrieved.
>> >+       */
>> >+      if (ret) {
>> >+              WARN_ONCE(ret, "Failed to retrieve incoming FLB data\n");
>>
>> I think this should probably be considered fatal as mentioned above or
>> the caller of this function should get an error so it can fail. I think
>> retrievel of preserved state should generally not fail unless there is
>> memory corruption or ABI is incompatible.
>
>Yeah. I think I will just call panic() here to cover all cases.

We have an luo specific panic macro/function that you can use.

luo_restore_fail()
>
>> >+              return NULL;
>> >+      }
>> >+
>> >+      return incoming;
>> >+}
>> >+
>>
>> [snip]
>> >+
>> >+static inline bool pci_liveupdate_is_incoming(struct pci_dev *dev)
>> >+{
>> >+      return false;
>> >+}
>> > #endif
>> >
>> > #endif /* LINUX_PCI_LIVEUPDATE_H */
>> >--
>> >2.54.0.746.g67dd491aae-goog
>> >
>>
>> Sami

