Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2774C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 03:09:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B6D66B007B; Thu, 23 Jul 2026 23:09:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266B26B0088; Thu, 23 Jul 2026 23:09:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17CA66B008A; Thu, 23 Jul 2026 23:09:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D33CC6B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:09:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D01F1A01C3
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:09:11 +0000 (UTC)
X-FDA: 85022188902.16.79B0C22
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id 89305160006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:09:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AzFpsjix;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.41 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784862549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IkK9Ic+plNLgIM9fugN/4zQ1Q3nP9xjTpKSDbJc/Qzw=;
	b=5GiKs/hV2YXSmOUyyNhf/HsnIBT8Qos+0fH9QrOntavmNMbi9xbPmETSdFWiklQIQWTDSk
	vOSGfKlHdnLZ/6r85CNHAevY8gY5NGOsVY/U+ttOYhqnrrHQd7Uo7wTmE65rPNyU2eDWys
	AxUaIVryVvAYc5qcnUF0hB9LBMRVnN4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784862549;
	b=qXX7DtrNt4U4iTYgn1RHZSSuWSvSvJOtUpagCUMtxxt2bXPNWHe6zlJoBzxNvI/v4hNfU/
	KeVMXQx4Sr6P/qkKblvSKp1IlDMtm+Snf3aKhrW5IOKuC027fPXcA6D68amx/DR42M4ivs
	MFm0NlaO+q8bx+ZpNTmSJ5qAjaxtSU4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AzFpsjix;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.41 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-381216921aaso1214422a91.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1784862548; x=1785467348; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IkK9Ic+plNLgIM9fugN/4zQ1Q3nP9xjTpKSDbJc/Qzw=;
        b=AzFpsjixvCVFQc2mK0W4SiW6E2jWLrOTZVe+jZ7ZFT2kY6UaZoq7zkKf7me0b/bQ50
         aWEogUqvpMQBg1Sy8MH9eHG+DIDVUb2xsLIylJAYq7d5TUfK8hO1FPKAjC7X9z8D3tpg
         Ye2ZcHlIPuND49x3LWFPY/kIqywNX4zVA8vRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784862548; x=1785467348;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IkK9Ic+plNLgIM9fugN/4zQ1Q3nP9xjTpKSDbJc/Qzw=;
        b=nAC+Rm2VKt+jsSFX8lNr+HcVKrXqQaKAZzraK3Otijgvpw3UQXOBN98RMAHta9Faq8
         tNryIZpSC/Mxl8LYavvquVrK6FALwdy3GPoZb9WHfJWse9Y9gKTJ3cjJP4HzxQp8b0kg
         9g5USY8JBJsvHgogcYoJJSRisfQrnkXrxFBmIDKeRNcb2jlph4/TjRLoajE2ZcgUyjTL
         YpRli5yGWuSQ34Wa/TyUjtXLHmjgmJdzqw2/v+xESVFTSLgbl+SXDr3RGKHtSVg+RP6C
         gPloOcKwTcURTkF2XvwaKtXSIJyHWWtdaxsAMf9C0EOqx1dX9LON2ZSzGABf4Cdhmh/g
         xlhQ==
X-Gm-Message-State: AOJu0YyM3jA94enM8J0DS2OcybUK/yVReJLSG4VOcyzGdGhaxHYugIcH
	RlI/1Hb6K7p7Kiq4SSTopR9EuGc4uXzeUWLuKoI/sgwuwwTDtnjIeUvStu7VSDUD88T8TRHoGXH
	k1oQ=
X-Gm-Gg: AR+sD10FN7Ug4z8KD62+BZuRdMjQ2RJQHsoT3hwLrJilolVGLLd/E4JHiltkOME4AI4
	nP0kTwjevUriqFIDi7L/tOvV1K4WUFCjqG6NoJQjmWHmKLkJCxMk7ozNFSbe2QcfanqhPHUGO/S
	FEtCDIv1VFptKTuLqUT5wVH1pXY3zMdE4KcFN3Uu+YcVuF2/8y1QkylciBYt0KYGrDzJ0LzT+9e
	S8WvshZRqwT2mq7RuwAag031BrjTtoff4B/UHyOZkwUua0oxntHzM/OEx0406OjHoe6dy7KBqIn
	1RF9hviFw8h9XaD/onCnzPJBtTZqBlscaqGpU8e5KRiwbXdt4SMJ56Boa7yMqw0/9ynBBJTsDDN
	dmhqkq+GV5lcF5nUQFAhVGZ3uQs1fPrub86ykWA/AdiMYVmpW9JhJghJx9uqjBNJ9GKTwApawWP
	d9WHXska4U5GtiILgLQWNFteL+qqB2Tx7vNZv2onanKw==
X-Received: by 2002:a17:90b:2b88:b0:38e:ab33:9551 with SMTP id 98e67ed59e1d1-38ec66604ddmr5709201a91.42.1784862548389;
        Thu, 23 Jul 2026 20:09:08 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:c102:f12d:5168:6be5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f04175831sm715874a91.11.2026.07.23.20.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 20:09:07 -0700 (PDT)
Date: Fri, 24 Jul 2026 12:09:05 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Subject: Re: mm.git review status at 7.2-rc4
Message-ID: <amLXLip9U9H532tL@google.com>
References: <20260721225139.fd654a3a40e755d3e621899d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721225139.fd654a3a40e755d3e621899d@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 89305160006
X-Stat-Signature: krnt13tkfbk9qxphryk71zojzqzbz5cu
X-HE-Tag: 1784862549-963187
X-HE-Meta: U2FsdGVkX1/7SVEfTTAPAYmjIozui0ezlfwfjgZ7BXoMH2+RokMKVccelklkH6fI1raIho3yEMlif7Kec98s3PcV5pUWR5HYDjqIiZlsl/R1DVMze+BwmqZQRRS73I2X44yWySPJb/cTTIZXJQPbgu3ZqEAQE22fK5D8Ouk98m5wPrFAI+Vf0HsfhRQx/r9gSWSVtZT8uXt6/cTf3wLnXnqDvdqawuvvohtHtGivFCLV8pvqzSep6mbBP2HebDY1v0Vcc9Ga+QLR/ThGaealfe700D1VPCaASIpa0OjDOEpLv2Y41gbhEmLnlWF+zrKoAPgqEIZHEDLQWPWCdfrR85gV0O/kAu/4wgH5aiYo1n/gMkPxPDB1bSj4BkZqF3j3NoR9xDaeet6w2pdZWgqjnzLzX0DNL8UotP5Yw4ZFC7E3qiEyQMGh8zBA8wSuBwpw5oH/eY5udlQzM+hfJKquGuwGKMf4xud1T/6alqJEI6OQKw/8Chjb60Zm46WRwqsitqbNM88DiJFW90NnrTMo6F1EB6EnTD90taS8pRa9YgciD2UN4gCIOrJK2tLE2fRAr0BzWSYNIkkge8J+k/qevlMU2HQKvOBB7y6+QotCl25rP3BhbnVdHSPIUgNsgotHNlptdm3Emk/pJ/6Ccij4LRwgC8oegniO5HgCc9c05VmQIIUlpwkzoRkDFFU9Jyk5HBSrhCcBybS+iDpLKlpEAhq6BDB4Sjd4HJwupL4sdZ70GzFZDOOctvMaFEn8lG9fUvPxmtRcucvDi1En2tW/Q0qWl9/sCE8nAF1Bj8KKa+VwO24qJwfmAG1QrIzCKJuVHpoZ4w5l5k9biBE8EAPuKIbcSSM0LSqGaW1vhW7QoYhLGtRV8yVEPdNfICxTbIsEnJ/N+1HpOT2QDptcseCOiKcYl2pbEMZ+uuABS34dahwUmH2sMYIBWvKWOfzhelZPDK4dhd6Ets8j871N5BA
 OJNPBukC
 KrDWf/F2URAHPo/GJv8gq5Mte7KAk6tXd26hPCUXWO7vMYmw6NCpBUQ6OF418svvBBg11vBxR5arOMYaeRM4fwE33AYY+uoYQ9h3h4PN7rc1lhk+r11OigpxhNGSSQpUzgnBZ9BJw+RQ6CFgiiiu8ZJd9As5OZnXaCRmbZkLaF1bUZ1DjhTa4NKAv8ZSyA0oMHaTWWuXtlIPCzunmF+0MN6qlllv7ATGay3YUOsrjLfIVTYsAc59/KwahxZohz0Rdr1Xae6q09YxFeoV4Ve+PckPc8LnA4wcQc0ohkMICFJlEl/uQf8BClAEj01x7znNbxFb5RWxBrVUZYkUH3WQwfgtWGOrYASLPkCJ0yyhX23rjtppv+OiC5wXZv0E1mEXGNGImjdOkPWFpelYaIAbQxRpQ/Kzl8qNMl69A2kmTJiE+f9tFiJMfmGh2tMNyrG0u4VnNooGofEMWajY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/07/21 22:51), Andrew Morton wrote:
> Andrew Morton <akpm@linux-foundation.org> (5 total)
>     "mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix"
>     "mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix"
>     "mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix"
>         Link: https://lore.kernel.org/202607020359.FMDmPwjF-lkp@intel.com
>     "mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes"
>     "mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix"
>         Link: https://lore.kernel.org/3a185a5d-2f2c-4e9d-9cd9-8bdb236dfc5c@kernel.org

I will review these.

