Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19315C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 03:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4DE6B009E; Mon,  6 Jul 2026 23:26:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65986B009F; Mon,  6 Jul 2026 23:26:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA20C6B00A0; Mon,  6 Jul 2026 23:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4A26B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 23:26:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1AE531A02E5
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:26:03 +0000 (UTC)
X-FDA: 84960541806.29.FE50822
Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	by imf04.hostedemail.com (Postfix) with ESMTP id 75FAB4000B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:26:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=fiScCpEk;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783394761;
	b=qopPuvAuMFMxP8hg0SrUnBqmlt28u3J5Pd8fBKQdvpK3fOil8h8oOb3aTlMmems9n6fTeY
	mi/kEDIuTs8wCL2/iFQcHwoWhqaRjNQQBj0mTKc5CIkmPsJLO2ZyO18uUUTwLVxFUrukPx
	bo85gAzruyRbf3tIJhgOoTnT94Kscgc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=fiScCpEk;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783394761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bs4YEwGhuau8az/B0StDJAa2em7HRJjmNMnR+mFCouI=;
	b=70SIDbOlxGW9nQYGf43sB3Rjt0X1LcPbIpwho+qyQOh0TwD3YRzMQRGtEZ/SA//IJefgMk
	MHcwdcMgA0NukMF/4bf416boWfbevZ09m7kpIQBRlWovU8ReV0S9ft8V9O6iNLVzl1Rc39
	gh2hy4Hy+sqfYaM43/jHH+T7g7TrPfM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783394755; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Bs4YEwGhuau8az/B0StDJAa2em7HRJjmNMnR+mFCouI=;
 b=fiScCpEkj3wfzVD1WWuF2+Syv8ox4WfI8HaqdFVpOVelvwqM0RD4CEfvN+dnooIneFZVrz
 cW7QsEq2tQ185IdgwCYpLlpeDGq6mjllrJ0NlVjl/dXqNYGmAte939SISC+Kp10sUbvCpg
 n4/pCxYk4My0MeenYwN1JIEK1ucMBADepQHr58r/ATd8mvOF+4zHyNDQHSwhHJXARe8gUn
 rY6HOc1UqUk6x87aePQ5UKFl0FumrCrTZBgBgpDxgAyjcd+1+PSymhLI1v1EVOliZr0aMd
 2hTxsapo4i08tTmxl+98xEk6X/qnDufuJ8Nrj5CtpCOkVAK54Is1VYAN3yQmyg==
Subject: Re: [PATCH v5 2/8] mm: factor zone-device page init helpers out of __init_zone_device_page
Date: Tue,  7 Jul 2026 11:25:30 +0800
X-Lms-Return-Path: <lba+26a4c71c1+739c44+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <kees@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>, <x86@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <374a0a2a-444c-412b-8ab8-414dff6a2ca9@kernel.org>
References: <374a0a2a-444c-412b-8ab8-414dff6a2ca9@kernel.org>
To: <david@kernel.org>
Message-Id: <20260707032530.22444-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 75FAB4000B
X-Stat-Signature: m51zsprzd9k7t73mrn9ts4h6b7w39d9j
X-HE-Tag: 1783394760-165944
X-HE-Meta: U2FsdGVkX1/bE69+QiBRPZ/7NoFzMPoQPpw3pdbYJnzes8Wo7yqqlhMAsEp+3/MRsb+PGl8IP7S8po8tQRjcny9FcmSuyJEE4zZR1nOHCRAbqiuQ+dVByLWXHQA+axnqOi/kpYmsOLRQ94yp3apspf43SmQN/4HSeQi3Mtcm+9GFEpH4Fp2ztUYKIOVAC95qXdLWpzDCDzI4xlSovGy3inYwnXYJCXR2G7Pbki0ZYYUE2df/S/7mzDn9zWvyLH+euRqWqNK40PdCw7s++qbO6Q4Lzv0Ycpesoxt8pKqhZQptHUJqi6nLhI65vKVW8aNIhtfOmJuTBr9evdS6vTazKCKNoDAmas37Zmdod0iLxr8vDWlyvaJgOdXS4u1LSZduRf2u4oC9i8dfYNEjeYNqcO42BqCLn8iTLGbawmOEVJQIDZIUChmjrvEbZedEnSMs5LN0ECpLO+ivT7Xla2YfMpnUKJ5HXp6wWiqKJjcv2VzMSo0ih0vzsXsbRgLcTjTf/4E4XzgLa8BJ/WUBHcKJwpkWl5KJ0sd1/NwozfX918CjnTLRAM7QIrcuAE/XCxQ6BdPhk7R4B8yfcmyZiyq3eUlRR5I6YCfLec/qwr6pJlefMixiQ86ucgc96fIWMEocQ+ZH+s9a44RnsQppk96UbCWb78l//tokP7GDVx/uuPvjgNvR2zxv/cIpS7SG1Loix3fRCsGg7mIh26QwtJqKk1PbwqF9sHU1U1ur3wwN93LPpcFBLa5cM7iljUKKScs2Gl6AxzTOjsTFlZTeBCRxM+e7oGBrIZ8harUZYXcjhHXhP5GYZyyMz8yXMdahO5t9HlCeZ6JkrSL3mPF9TYRbH0PflL3FUgAyfxxMcXFraQBJO1smoHG+SSOH6OSgMjup8FA902uBazhNrP/21jHzB/5T3t6xcEwfyXCYcT2p+gxhea5lhkNKKkAPwzSIRU5vgI1EQ9Bp3RxEEMX/r7q
 +dQALBji
 vvD61UoWL0AwH6Ci/ivonEYLPIGUjZqTYnbolkxuYcFBgth72NWGhSTWDX4PKZWv3+Z8bXfnLPmlVL1yR+dOSlA2zN5y/PmKxeljngXMne304Pv3B9CXWL0WOc1xxJt7lxGvwsYO37KN4TXzjCYbV3O7QPGqymuRqcpVKgAdM4lUNy/+3Hic1Qg4XXNCk1BVVC66PQW0RTgKDKziRz0K7CYXCYQVizaftKKHQ1Ybe/2pmgAiRG58a7ETxnyxFW44sBGKspASWjS7HRVIDZk4wN6Dtzsq8csks9IhMkSRn9wFsBTfoce2vAg8WgeXLpDU3Ce3Y/W9OD5V/QdSU21Dg1Jq6IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Jul 2026 15:47:43 +0200, david@kernel.org wrote:

> On 7/6/26 13:50, Li Zhe wrote:
> > On Mon, Jul 6, 2026 at 11:13:45AM +0200, david@kernel.org wrote:
> >
> >>> +static inline bool pagemap_resets_refcount(const struct dev_pagemap *pgmap)
> >>> +{
> >>> +	/*
> >>> +	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
> >>> +	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
> >>> +	 * the count again when the allocator or driver hands the page out.
> >>> +	 */
> >>> +	switch (pgmap->type) {
> >>> +	case MEMORY_DEVICE_FS_DAX:
> >>> +	case MEMORY_DEVICE_PRIVATE:
> >>> +	case MEMORY_DEVICE_COHERENT:
> >>> +	case MEMORY_DEVICE_PCI_P2PDMA:
> >>> +		return false;
> >>> +	case MEMORY_DEVICE_GENERIC:
> >>> +		return true;
> >>> +	default:
> >>> +		WARN_ONCE(1, "Unknown memory type!");
> >>> +		return true;
> >>
> >> Wouldn't the compiler warn if we would define a new type but forgot to update it
> >> here? We're using an enum, and I thought the compiler would bail out in that case.
> >>
> >> Or are we scared of some other garbage ending up in there?
> >>
> >> Apart from that LGTM.
> >
> > Thanks.
> >
> > I will drop the default case in v6 so a newly added enum memory_type
> > value is easier to catch during build review.
> >
> > I will move the WARN_ONCE() after the switch so we still keep a
> > runtime guard in case some invalid value ever shows up there.
> 
> If the compiler complains, we won't need the WARN_ONCE().

Thanks. I will drop the WARN_ONCE() as well in v6.

Thanks,
Zhe

