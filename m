Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38501C44512
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 05:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D5F6B00D8; Wed, 22 Jul 2026 01:20:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3D256B00D9; Wed, 22 Jul 2026 01:20:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52706B00DA; Wed, 22 Jul 2026 01:20:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99D806B00D8
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 01:20:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 04E0D1A0256
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:20:20 +0000 (UTC)
X-FDA: 85015261842.11.983BD5A
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id 99C0720006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:20:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="eJ74/J1/";
	spf=pass (imf03.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784697619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cww537ASv8kzxMe1FGmK/V4GT98IxA5VfJnEBpkxoko=;
	b=zPNGFD9+uwzunxKxtsTen4WcisQqCdoQAB7sXpAFWqnF7/dQFYLzjqNSlgCpRvKS/4RD9D
	U46ToL7Yx3in21aXDEmLXN+UNDD5r3jWuiJQbo45q+UoHRvDTYW0WaBDJzVg//KRXmRltj
	HYO9KeIvavxCAFUHAI4YcQ3h42LP2J8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784697619;
	b=yAL9lmzhvInonu9B0oA0ix0UAK006ZxFpejtjSsawIqCcbliq6w5LZi1KcenAQvXMLLmhT
	ulfILx30IFv/GAKaGIlAEwJP79Wrozw0LA62RAv1LdaKc/igFhV2bW3rf2wvxsW3vAsUfH
	R+nTNLiu3Yx6Bw/JOPNnrYOTHy0eX24=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="eJ74/J1/";
	spf=pass (imf03.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4451740E00DC;
	Wed, 22 Jul 2026 05:20:15 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id r3gHIk3Z3MOa; Wed, 22 Jul 2026 05:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784697604; bh=Cww537ASv8kzxMe1FGmK/V4GT98IxA5VfJnEBpkxoko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eJ74/J1/mMRLlE9IAuONfD56lNUVXzhb901qTTGENZwHDUVcGgizSAaYO8wZHAExL
	 uVsJwZzSfKuJVlU/vEeiX1faUMYGtjP80CDZCEkdW0VHP9sgbFZ8/9r1/7tVg+2F6l
	 a1xEzieGWlQp/toLSUHJ5fZaTujsj8rtcfw5cm2Jpzq98Y5xMf/Zz+7kaVZg+uKJin
	 xRvfHcAnwTKFVlefasJd6TIa4frpo7LleJuPwugGmzgzYS5kSEzCM49oggSQLM9UmI
	 a+XwuGSPT+saT5toOfAhBpmeuDZb9W65QB+biIvujG9fzKzp6M2yaZ33Uw52jdIyir
	 8oSxzWtd6xfM0kVPr8c3ZNqwcw+i/Nmvs/IrfZb1KvAZ3QU8RYHLheIdibCSqasNNf
	 rM42chfSS0cdoDEwkQPxocMOY7m6G2jFLflfMxos13KnszcoK/3Ol0CJJq/xRgPF3+
	 nkzD4uYQW6VHYcQwoKCxGoJq+a6LWScYeLVcHWS+Xzq/bycwqwUj453r/7PW3qVZ5L
	 o25TaVAd7fSwvTPLLNMPh9V9TMsO6cCbD8jv9f3tjQl1J1DcDJO/O1X2F1+gefUvb7
	 sehjqYsRj4bC44uTZH4DOfADniqpy3TzT4dRs1PR3/3umimP4pzL6TGrYBSaZ9moQq
	 8NVt+GVAlinVBUQ4zPTqVEh8=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::2b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B81DD40E014C;
	Wed, 22 Jul 2026 05:19:27 +0000 (UTC)
Date: Tue, 21 Jul 2026 22:19:24 -0700
From: Borislav Petkov <bp@alien8.de>
To: shijujose2008@gmail.com
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
	Yazen.Ghannam@amd.com, mchehab@kernel.org,
	ashok.raj@oss.qualcomm.com, jic23@kernel.org, linuxarm@huawei.com,
	rientjes@google.com, jiaqiyan@google.com, Jon.Grimm@amd.com,
	dave.hansen@linux.intel.com, naoya.horiguchi@nec.com,
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com,
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com,
	gthelen@google.com, wschwartz@amperecomputing.com,
	wbs@os.amperecomputing.com, nifan.cxl@gmail.com,
	tanxiaofei@huawei.com, prime.zeng@hisilicon.com,
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com,
	wanghuiqiang@huawei.com
Subject: Re: [PATCH v22 0/2] ACPI: Add support for ACPI RAS2 feature table
Message-ID: <20260722051924.GAamBS3KN1wWTbiMwt@fat_crate.local>
References: <20260709210750.424659-1-shijujose2008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260709210750.424659-1-shijujose2008@gmail.com>
X-Stat-Signature: udbjhqubdkbch1tmn7yzgofy97q9mf37
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 99C0720006
X-HE-Tag: 1784697618-410084
X-HE-Meta: U2FsdGVkX18LNfeYBaofdiVzEWM43EmjzHCf3395XBXM/8+FdkupEoOaHG9mBiHTf+vnZB4aX3ZgLATSOpJG43QD5/7p9K3qGCmPZsRIC4f2F7G5b5ADEBJdC+EdJkaf2K2Vt9XhD3lQ/QNnrh4aivaH6/x8P4Xj5Zcf1GkKMsJ+2pqJ5MDbpAVvIiHki6GNDQim6ZzXwl1W2rmndxSgQpU9oIQwGURUQfNhXSFrzTNxbOd30vdzWvEukJdqltJw4a0wUxC8ms/SisZCmsDuqLUurV2Yc8xA+RJkm5f5O5FQ7Rr7P/QE78AUAHWRw7tjrm7sE9amxB+ptlGtgPvr2ioXm6fRGwwB8oHy9m/vaKlJIyeHW16/67vvA97S4I8NNJS1+fucpKFJwdTsmqL5B3Zd2lotbZ19fuEH5uV6I9vJxB1/eF6n7uZDd6v1/PsLqk4GLSjXY65kCHYPG/L/et8t5LK+hjzsK93cxRG2Ist3yBsGZhsPi2OjbrQIw841DiiDGv88l2+xfs/5eTBqCR+tok5Vis5geufjRKPc3WkYncw+SWSwQfxE75wcXCia9c2W8yWNnCk/fW3MQFt6fKKT0Tg0SwEb4H3vj71AkI+cl93aVN/QpVtGnm8mgGivIljD4DPXPO/+ImYCQMfwaRPlS3Kw1Ls3xhz6nRN5TuI+oevIqAWVvAbsbjBVUAilIGMMLWyWwpYKPTrMqVT13OPb5xq6VkLGmebybIpqLvJiXOb8eQEsvw3IW684EiUAKk24IXoDoZhL30dgw/+p8NONXQBDvNaZk9fhgDdO/4Sev+yI1c4cZyU5P8VhVFZPXlFsIUKvI1O7cj38WbKh9pSEVsSrm0u8Mpe+/BEvuaYtgqAjfOKwSggBOun02X5c7zoDKTL9RelbMzrcEOWVj8BCe9PlAVt7mt9pwfjGtmTCZRbHEODphSAH9ULfPWAVXT1TskvBjvriseSMcsE
 0QaVwLUT
 FbB+9csj5ZpAqtEBP9XPyySVkmAk+eQv4TN7DTbG0/6cdq52EOfgIYBvZiA632TS25YogENHHpTdpPTCkiezO7ukZOWow7BweGTfYnB8M9rTPukPOkHtidkT/dDtYhXmxRd0g1icfOz2FZx00vHldoBydtx81R04C3C/Kj49dCm9TfT7LuAqUo7h+YEziE5JEOvPOegYE5iN6fqvZPrPkuvULW0E/XFf0VdVN6crlbIOMqylD8iIwJd/MN/6IQ7sXiJxpckWpN4+7oxillepBnh2shkZ2ipn1bxY9i+QlEax/gzZi/eV6VkSzVOJ8sE8e+qbnDpqYzS82mB5po5r97mvK+oTUarWOcpqcUuHkPEikHp0GQIym2l9CJnQAxL93/yWNrYJRJ3CV95pp+jc68C0nVfmNS+3G/GfJDuAqIY2TJGAtm+kxZhvIx2oSUKXM0Pw7seeb+OmRluc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 10:07:48PM +0100, shijujose2008@gmail.com wrote:
> From: Shiju Jose <shijujose2008@gmail.com>
> 
> Add support for ACPI RAS2 feature table (RAS2) defined in the
> ACPI 6.5 specification, section 5.2.21 and RAS2 HW based memory
> scrubbing feature.

https://sashiko.dev/#/patchset/20260709210750.424659-1-shijujose2008%40gmail.com

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

