Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D6AFC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 21:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAE686B0005; Thu,  9 Jul 2026 17:46:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67476B0088; Thu,  9 Jul 2026 17:46:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B27E26B008A; Thu,  9 Jul 2026 17:46:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 800B36B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:46:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1CDDC1842
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:46:45 +0000 (UTC)
X-FDA: 84970573170.25.71A1709
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 04CF6140006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:46:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TA8AqZ7I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of djbw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djbw@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783633604;
	b=jPC9xJ6qJpoGpRSFJXv2SGP0BgJFzh6rJACKA6IaNuQYdaS/3JF8YGbfDLUSQ8uSMNDg7t
	/pOMyLxlzbqM7EWRV0xpFQvnSeKUH8OevziPskdxHBY+BgJ/ZkqK52c6DepJiyrmTaNqqn
	V2Q8beCR8VnsGTgY+dt/fG1SXnPuHkI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TA8AqZ7I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of djbw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djbw@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783633604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xvUpE9WcYp8vTdTGEYoEnE1EtejEUIbK/UADepyuNY0=;
	b=fAwYQuDpfsWP2BcOz/sR5JEGGFI37i50x0Cahyn8p608O3/9LE9/d6L3bmPTxNgpiCfyx1
	fuZknkzVlxEGBrcFAvy+vjuEERMxhsB2EL7H6GJJ4g+kQmt1+w+mPtHxKJCjHX29/Xq6Ii
	qOSSzcU9/JoxDDk7nz1cnr8evFrXQWk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 48C9E6182F;
	Thu,  9 Jul 2026 21:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A911F00A3A;
	Thu,  9 Jul 2026 21:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783633603;
	bh=xvUpE9WcYp8vTdTGEYoEnE1EtejEUIbK/UADepyuNY0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=TA8AqZ7I1hIce7o87XkKPwSqxMdzJVoYEE4HCOGiRp5db/3BRSrjGyjKkoy8GmD1y
	 b9Y6C8Q7SLNQ4egftq4P5ZEDEejlYXiZWglFtF8WLNrQWJwViJkbx25fL1sBd2wi4n
	 DCSSSL+ytiHHxwDFklRKDOHGC4ZPB1DOs/1gshxUD36l12Fny//aqjtxp1c3+Du1N/
	 gBAUEFcY4YfUQwId4leGmMzyBsqKUzvxnTYohNt+GPWxi5SXW6nI5zN06q9dDt1zIS
	 fmjugPp7FVXu7MimQp0YSxZgvDLND2tGttvg8x8yuCf/GJnokC4r246h2k8DNgRLUR
	 Pagc0KB7g550Q==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 36203F40074;
	Thu,  9 Jul 2026 17:46:41 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Thu, 09 Jul 2026 17:46:41 -0400
X-ME-Sender: <xms:wRZQatvFWtrTwr1EjET3SY_trkFv5ByXFvxwuRdoxp5nZNvdH5owQg>
    <xme:wRZQamngVETnvwD8NBa-XtvQpVx4724Zay6MVM63n_6ymuey3wfOgySL08LLsooog
    UX-chX-4R6sELh15ZgWdlWqPRhtWCNR2SS_SccjFUcsJISlBQW0Jg>
X-ME-Received: <xmr:wRZQaulAZEPtxDDKpaH_YbkptlPFAMbWXlA7EE85RV-Ons1W6zy6jsk9pC4kEn3uk7t8zBNGPLJp6Q5UyrA4U-G2iQ6f_GlG3-g>
X-ME-Proxy-Cause: dmFkZTE6pGaGaXtiuJOhuGCWlZoBx9j2X3a8VM6fEMYo0GgLn9Toq0lK5LM0v7iRTsbBsV
    qlrEvEtCLS1HyECWCw3IhgieUQHf/LHM2k0r319GerFiWVnYyf1YK+sX/8GKpHbeEDkqtn
    HDG3mhPN5PblOtwUozJ//wR1tQjsfmPDOvoxX5Te1glFqzecABmTR2Zh8nu80wxuLaB9Zq
    2zHMg9W+crhZwO/iasCAkbhbQkiZL/DfjYQadxfklfe3HABtE+ynOGyGbRkgDasbfKe5xO
    VfWC4UbTVVlwtY8KKGNtYMIYw9XkDx/17fWR9Y/a3y7cL3gnrzhViVaOvAGjNANzJ0ugdZ
    5PhTVw9Ns0QhhLKD1lQlPKK1qDIBABInureQW4ET1HapHww8srucCfs+rrvwAVPVpc1PfA
    HYIcCN+U+A5av5qS7mt9cziBggX16xCsoo8ISOQX2m5s/bLHlIFqjSrysZbJ3A8UTjLlcH
    L3uk/yJObKMM5E62Z1vetG3TPwFWzYElHlH/N7CdygvxX0xaTfR0R+ijFpTgtO+dGDZyAd
    yJMUKn+V4nGoInZb4lgPPMBhn6Bw9ObzrTWFW1dVXsVErLJiF5Kp789djPKp0Plu417fRL
    ltx20K8SztGbd39K8VVdFQHFiete1nLG1dIxa8J8RKKm0TJR3JNksl1/9+3w
X-ME-Proxy: <xmx:wRZQaoc4wjzaNgvryg5NN70-1Vatf2xzep1RWYAbyMMVv1jU6GuGUw>
    <xmx:wRZQasIJCeYXn13SMsIuUbkJJctlWeYlyIgEnBRLtc4d-vVKYSLz2g>
    <xmx:wRZQaj5n-_r_R1jtCcxgv8VUDHEvYWm-UIKRMsfxYAmrfmcJ5P0Ibg>
    <xmx:wRZQarTPZpDwzCgul_GWo1SBKOdkWO7HWCqep__MKJzfdeGX2A3UtA>
    <xmx:wRZQajsp5WUuI2CXr6WdWNwkXcx1AADWI-zKxT0Fq1uz1hG6ukfLy3xS>
Feedback-ID: i67ae4b3e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Jul 2026 17:46:40 -0400 (EDT)
Date: Thu, 09 Jul 2026 14:46:39 -0700
From: "Dan Williams (nvidia)" <djbw@kernel.org>
To: Gregory Price <gourry@gourry.net>, 
 linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, 
 linux-cxl@vger.kernel.org, 
 driver-core@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, 
 kernel-team@meta.com, 
 david@kernel.org, 
 osalvador@suse.de, 
 gregkh@linuxfoundation.org, 
 rafael@kernel.org, 
 dakr@kernel.org, 
 djbw@kernel.org, 
 vishal.l.verma@intel.com, 
 dave.jiang@intel.com, 
 alison.schofield@intel.com, 
 akpm@linux-foundation.org, 
 ljs@kernel.org, 
 liam@infradead.org, 
 vbabka@kernel.org, 
 rppt@kernel.org, 
 surenb@google.com, 
 mhocko@suse.com, 
 shuah@kernel.org, 
 gourry@gourry.net, 
 iweiny@kernel.org, 
 Smita.KoralahalliChannabasappa@amd.com, 
 apopple@nvidia.com
Message-ID: <6a5016bf71df4_3b7ee5100b3@djbw-dev.notmuch>
In-Reply-To: <20260630211842.2252800-8-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-8-gourry@gourry.net>
Subject: Re: [PATCH v6 07/10] dax: plumb hotplug online_type through dax
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 04CF6140006
X-Rspam-User: 
X-Stat-Signature: 8hpjc4domxx9sofr5scb5k8arofigo56
X-Rspamd-Server: rspam03
X-HE-Tag: 1783633603-971170
X-HE-Meta: U2FsdGVkX1/dSVQcmkxMhzIwaGSmuZua6V6PZANvwy+dm2N9YflICwG2huiYz+C9O0EY306k8DwI+gPODesdmMVBa75SvIIXF429f8BR+BmnFRho4E6hBjMc2w5Sir/dBywKIz0S6qmw15UY1rS+cX+Lev1GmlIP9VIieGw0NvePpGtKPLbP7Ggwn77FB4AQQtSW2Xe96q7GqfWEQasKTsjDSMQcjNHxExdISIOqN13JwG12CsFPAtZbyh27q1TcKcEyvAioarpY0sBOaT1mdzize55VnTEm6Bo8Rcm6KnGZyeLuoUZEq9mFgbNxN10FGjbvVBpg0u9fXYj9jiUNYzxR8zj25BH2pEFcUP7+HZje312l1ZKGYIBH2nzB7VIAsCRJ2Ex9TNxZwgiOuVgukyslSw6fZRqaNAhhHbHtDRkODcIm0m8TXpto4UXcr3wnvVkEtT99oWPhuI4IgozP2z49ZLUVGlzZ+/Hh0oSmGjfP25Oo65tOpf/Vkp/V4ovqR4xEvx3ENj3VKigO8F2CCLMLiQ4Eti8+beHcfe4RCf7XjRRFMNQVeXcFy9g3tCM+58AFntg7ilgaJxyQ94+XH4LB9LxzHuBleBqDERcrkj2bsekld8BHiza7F1bsJT1lPVfYml6zI8g6ZvhV2clCxvzz7PyLOMphn7/0BTaBSYYm+foz6sE0xsPhju/DXmgiGyhia9c280xF1UJ8X7iOVWNE7JVQGljdiT7M9GC2vbwmakvU9fLEzjDlOg7C1d/oF4ZZLgNcDO0WUsO/a4SvHUFsP+R0JZSlAeZ7LGyDo8BvZShyAOLnrXdIDsgZMDEsgqGaBbbZEMFF5xPgpcqwtF9e36uHQorClOj89LYvomOGXOoDEbgilMwf0eMEMTr4kX003HlByyWmwo3avmrqjlOpsUaqlr6hUQkaQXvseRJx/cT8Ej7dew1GBqGhCMXZFl6ovpWMg9WVMucz7Qq
 QJcRh5rm
 XB+MoSr6zfFbWYCZS91Cmp3BdGgWzTouspEy4lK3bxWbb9IZUJaBCE7A6xjWa4umbGRi29aaZy1PDS/himRzSNBL70ZhD8O6I2q5vUV17HMfStY1ihaS/H/Rdd9OYfBFwKiEEmKYNlQH/URjlT3hSIxd00ifNNT97xPluPWBR6Z+8sG8I59SQHgu+UMUfqjjIO88qYh1iijoaz7BVHiHCo1md601I5y3DdErETTbA3KrEDeDNjsuyfmsFUWkU3A1b771U04rseZLyfYaLe4w2cvePOXEolU7sGIrLLfukHIieIodK8bRGhbB00cxbu2St62KSFrPFafs/ZPjx/gtigrGwcByIMyvdSJHW6SHPqTYyfbCqrzN1+0gmDxrI2C27ftw90L0u/JuofYSzau76yj2z3OpC7XcA+xjP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gregory Price wrote:
> There is no way for drivers leveraging dax_kmem to plumb through a
> preferred auto-online policy - the system default policy is forced.
> 
> Add 'enum mmop' field to DAX device creation path to allow drivers
> to specify an auto-online policy when using the kmem driver.
> 
> Capturing the system default would otherwise break the ABI, because
> the system default can change - but we would be statically assigning
> the value at device creation time.
> 
> To resolve this we add DAX_ONLINE_DEFAULT, which defaults devices to
> the current behavior, while providing a clean way to override it.
> 
> No behavioural change for existing callers (still the system default).

So I know you have some future usage for this ability, but it is not
present in this set. The only piece that *is* used is that the
online-type from the new sysfs interface gets plumbed through to
__add_memory_driver_managed().

Are these touches:

>  drivers/dax/cxl.c         |  1 +
>  drivers/dax/hmem/hmem.c   |  1 +
>  drivers/dax/pmem.c        |  1 +

...premature until the first user arrives that with the background story
about how it knows to set the policy?

If DAX_ONLINE_DEFAULT is a sentinel for "default" should
DAX_KMEM_UNPLUGGED be a different sentinel than (-1)?

Feel free to add:

Reviewed-by: Dan Williams <djbw@kernel.org>

...to this and the previous patches when that is fixed up.

