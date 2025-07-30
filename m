Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D5A1C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 12:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEE4F6B008A; Wed, 30 Jul 2025 08:49:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4906B008C; Wed, 30 Jul 2025 08:49:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A01D46B0092; Wed, 30 Jul 2025 08:49:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92A006B008A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 08:49:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5FED58026C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:49:44 +0000 (UTC)
X-FDA: 83720912688.19.7DC16C5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 06186C0003
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:49:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NS8Ro2Q7
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753879782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oXjbbzRW9TrXGpMOJwCvoOk0ZBJ+mMgDqBJb4Q1gY94=;
	b=Xn8iqJIEtQE0JLJCs/twkOBxjXjCKMmjw9I0TK+lPSNEbt6OYNhAIaeDd+ybc3/w/Tnmoe
	JeyVrgXPiMukxzB4gh4osqiI4rP6t3Ey+ppPoSZF7mcVHvldfdoeV7fTX5Pn7CuOZlLObs
	wGAzDpf5sTxXm5b9KD1MADYPIxOeeDA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753879782; a=rsa-sha256;
	cv=none;
	b=f7kxVXLbpR4z4GDNW9bo1d7E/VEyW6ypk/GZlX7UbEllRk5dkSbMjywgiXhr8Ckygtcndj
	PlkEH2TQ0tr7ylAKmbFe31pXtcwv0iZEyIXrt+bHMrJRa054pSlCyLZ8ULr5E39JqMGiQI
	w5wRYYBGJZ+6OVcOR0PYOJumEMpZgLc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NS8Ro2Q7;
	dmarc=none;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=oXjbbzRW9TrXGpMOJwCvoOk0ZBJ+mMgDqBJb4Q1gY94=; b=NS8Ro2Q7lUz68JJPsJvPf5BZOW
	gZEroRiPD12Jv5J0snMDiLKi++eAt+CGOjlGdUumtUHOjq2QJt2Y1KUVt6cHw3kYKA524TOIgt4lx
	Q3Uxi8bvIckE3snuynXGWwkns8VQwHr+y4hcr7VgH81RY3mSyI/McyrbCXA0042qsVzPAaU1d8e5p
	MYRatbiBBQGwlhc5mXl3JAnoTuiIOWSKo1gwDwRgHR2c4UjFQjOuWxQLZ+BLcatCusQsRkhAA17+8
	TrCIasldVYipK3VL+rHZf+3//kRaE7Q9Q/sk23RiW+qHccnx4XM2O22cMn92XdOU7inVOHTmvt9b6
	k2rTKwOg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uh6FS-0000000CVGZ-3Fep;
	Wed, 30 Jul 2025 12:49:34 +0000
Date: Wed, 30 Jul 2025 13:49:34 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Zhang Qilong <zhangqilong3@huawei.com>
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, david@redhat.com,
	wangkefeng.wang@huawei.com, sunnanyong@huawei.com
Subject: Re: [PATCH resend v2] /dev/zero: try to align PMD_SIZE for private
 mapping
Message-ID: <aIoU3hO9JBAyuTcy@casper.infradead.org>
References: <20250730091905.383353-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250730091905.383353-1-zhangqilong3@huawei.com>
X-Rspamd-Queue-Id: 06186C0003
X-Stat-Signature: aapiok9c98kw78p1ozzo7joen74wbwwp
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753879780-978432
X-HE-Meta: U2FsdGVkX1+6FZafX0zaHCsISQ4cBTKnfT1fmX1iZbtgan9aYErX82gTXxFbNV7che1402c+Fw28MLa5AV6+QeoafleXBnVWTkb1gu1MNTgvpgxeVCoz8JMNGdoohjX8DitdW9bqpqKeHC4vTnpV6VOodzZDWvb9YWgOGbsewY7TpMHahDLxQwTIEYZyiIEjtJcDi5HqcQBw2gKE05JVHENEFWP3L5lZgwnLWNGCV1KHXbh39y4mF78VynMdHOV4q7MPkfxvqhSToTs4JIXY67yJOAJNGvb4c4ghi3dED202jcMu55BtEx/hheDCLFzFlVqUweQzCsnY2LJZZrz9xq/+tZ7Q0d33rPYMPcd7bXITRyJBiyb/eYfAr6QnvUgfOCbi950USohLgna8qmz98+4MC3ctqozBU0eaR4TbCAjTbqmaklDNbpgwwFYo3NE7dHd760Ikmtpw3b7oORcWMyUqwAH2eeXBtowbTG6DlFv/ukwrRUazpchMHG2KMyVGJXSMo0YezEsnu80qGVJ47EJ4tTuFnYeza4akDzqE1IQB8mNmpzDncrYZm8uCtgmjKOzd/IPMDhwD5/oRFRQ9bX6dnZ2f8pxmVfLCVbsfDv1Fhp14ylxJxXQSFQamS/+lR9wRp68xb0VRWf952pqjNevEQKiAtmQVUij9I27grUTEplUzhAQ8o4krGZh0k4Zh9aE8ndnr7yC1rp8VF/b4Iy/VpO//OWZ4hlY/vuw0lZeeRVbprisr94cwafKBprs0AROrQ5z0RHnJ8lzC4JqUHjoDxGwu+o0227BAXy9WAUcR3X9kC/RPKHZznGrEj6MPpUjhsPLZKUUx4npJImCTv/naLJTUHztFE7VzYE4stuUZdIjC51E15KydPxDu6QjtW0Dyt4HFL+xuGrBbYspGclIfWhplC0rCcsYPljXLqkt4XWnoxREgByGmajNFZCoxHcMGvQegsKEGIlgw/nG
 N7ZTT0bH
 aCZ851PO2M+5nOKnfKOesuq9Q3g9PfF0/w7r/0/KzBfK2O02O+FZAysqxYAJcbzB7wq6ZRtEujoCRZtSTbagyFlQfZ26fveYxpfo+7Ez9WT1q86tqOv53ZpNg6LmE3G2NAcaStW+50134l51//zk14vOhxZ9L4KSwxS4RCc+FPz8BQdZsQ0uOCa6nAcO3Ek3oYS5E3jusjIR87mgD/ZcO/N9G37sInoSKk0uqVwUHm70Xvyd/NziT3rxVbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 05:19:05PM +0800, Zhang Qilong wrote:
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +		return thp_get_unmapped_area(file, addr, len, pgoff, flags);
> +
>  	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);

I'm sure the build bots will give us a compiler error.
If CONFIG_TRANSPARENT_HUGEPAGE is not enabled, we get:
include/linux/huge_mm.h:#define thp_get_unmapped_area   NULL

and we chose that so that various filesystems can unconditionally set
their .get_unmapped_area method to it.

Which means the cpp will turn this into:

	if (0)
		return NULL(file, addr, len, pgoff, flags);

and the compiler will say:

error: implicit declaration of function ‘NULL’ [-Wimplicit-function-declaration]


