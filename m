Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3427ECA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 09:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37276B008A; Fri,  9 Oct 2026 05:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0E6B6B0093; Fri,  9 Oct 2026 05:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A23526B0095; Fri,  9 Oct 2026 05:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EED76B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 05:03:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EEAC51402CF
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 09:03:04 +0000 (UTC)
X-FDA: 85302498288.25.B07693C
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by imf19.hostedemail.com (Postfix) with ESMTP id ED0411A0008
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 09:03:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791536583;
	b=sYk7bC2Gtx80zpTsvu5MV2DCbwUewHlCM0fFxP3RcCiT/dQrrgGfw80QLklw9/GO+x1fau
	b22Gd89caP9HPWZXq7JoqKT0QBTwLZIuHakoTSBl57p3pa6uBxNL+EZ6Gn96ixP8b164bj
	NOWzd3i0Isf/H1WH28oQ/fc78QB+8iQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791536583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O+bI0LZtnNyijAMkyN7bMgQxatS2B6ns7KyKq/OUIas=;
	b=w4Rpx0XDdW3Yl7MoNLEb95Oo9QjvyQWnkuQzTecmoVJY2mfp7g8/SrBpd1g7/PXU5eGb0e
	aPBMbc/U6rsIjfgF3wyy+/Ox64SlDZD6x9dZnCkclDjpRUC5M2p/HHZEV/x3NIKvaGzF/e
	j7ECjhIAqmKjwjR983YvchTLmDlHxD0=
Received: from 8bytes.org (p200300f6af404a00448550d0471e54ea.dip0.t-ipconnect.de [IPv6:2003:f6:af40:4a00:4485:50d0:471e:54ea])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 1FC8B1C77A3;
	Fri,  9 Oct 2026 11:03:01 +0200 (CEST)
Date: Fri, 9 Oct 2026 11:02:59 +0200
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: Ankit Soni <Ankit.Soni@amd.com>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, will@kernel.org, robin.murphy@arm.com, iommu@lists.linux.dev, 
	liam@infradead.org, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	ashok.raj@oss.qualcomm.com, jgg@ziepe.ca, kyle@mcmartin.ca
Subject: Re: [PATCH v5 0/3] iommu/iova: convert from rbtree to maple tree
Message-ID: <asith_7x71HNWMDl@8bytes.org>
References: <20260818152505.1057922-1-riel@surriel.com>
 <arUZwesREX05SZ0J@8bytes.org>
 <mcki6p5d6u7ofhiucoz6vi3jdldzmc7yv7n3ppoiwdjbwuriji@e2ezt37ga6i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mcki6p5d6u7ofhiucoz6vi3jdldzmc7yv7n3ppoiwdjbwuriji@e2ezt37ga6i7>
X-Stat-Signature: nobx5chyc6kk5ck9qtkx7dmn8pc5hhp7
X-Rspamd-Queue-Id: ED0411A0008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791536582-36020
X-HE-Meta: U2FsdGVkX18tqAgcSO9CvHK5/tcAJo3fJBhTNBHBLUF7MpDJ/DXaMDlZUcrkSUQNQVgOQ1VXsYs6QgUHn6OxBiUve+mCcBtEbPqi9jFQ8jYiw2/mB2VzhGYSv8B1SifLllNLU28Em4m7lr09WyrXqVqpdcuVQWa+6NRRaUVFs9LRkJYJNfOc9/YRv5/HMS0vU+ostlaqLTIQ/aqEZXJELSsTqZwdTkAsAK4m8nOtFgkuu5Xn80KqfgJ4LkIev6wTK01tub9GFUb9XVoaSgSkgItCd0UGvOG86ko6C+jCkNmKf1oDU5YssVB3HQl77aQrKM44NfVeM+HxqldFarUZIE+8rt0PRXnF8NEfHxtTSypwLCNxPxAIQkwO6Khy8+Vm9cJUX5hRlIahD5qcJwA3g1A0XE+QdvI5/b6F3ATOyvjv68mhTKsdBG1J4gUb+34eM9sY/dMqCzW2NESESVgn4/AesddbEQCosQGOE8IjeLPKmFQjGbUztYrtn7JO6VZ9zaVvcTnTzkv41Pqud41v0Um4+RJ8h8IAQbFhkXSZDxDOacSPEvuS1C5lFq+Zt6zTVaMOVmyLS36q9HKGJ0V5rQNgVi7AN08jqFuUxbETDMUz7gsky/GHrQ6m0/R+cDyjvlvWskBeXMB+rynXXtYdV9yJ+YVK0W0w5Ih+wYV1Ytho1CyIMkwA+p+s3h4uwGENBOyQG6tk3C+U8tJECeI0EpeKDNinwoIknBn3NlNNgbbBFImUgwGIGtd0GxNS5i09Nyo+pKvs9gAUbiWXREcPmyFcItYvy8kKFQrRD+UylVCIUgDP1XHBpFm1zw3rVCVXZP5b20Mbsh+jyBLgOsZlaGsABLJVZY2BSZcNVcC02WQg30NzPBPOezNL7FPIEwmtVvAs2CjbfSxH6npx7CX/0aRrh40dy3fYJ7IcGqq3/wDjCdGAMo7kGO6XZWXpQkLl+yUjV94ueEeaO0w6iBN
 GDqkwvL6
 Cm1LLZwbCEDrPqgKHDjIsIDExRrghFj5bgDbQjcr2lmDGWDLIoH4kgIvRkyNZnw8BbmXFpNI06BUBs1s65n8fdCY3f6qCJmLIVFrR0y56uxew7oOG0A5IJVgbzSRcJrRBTouVvQ1j+6hUcSSLDFFh5t72sXzcIaSlYRqbtT+EQtoWDpXD7fYGtYL65kuDmj0y4796Q7vpX5afyCNB19lFtYB2zyqULgplZjQGAIwLmwOq9Kg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ankit,

On Fri, Oct 09, 2026 at 08:45:29AM +0000, Ankit Soni wrote:
> Summary:
> 
> alloc_iova() is O(log n) in practice, on two CPUs and by two independent
> tools. The series costs about 2x on a near-empty tree and wins by orders
> of magnitude on a deep one, which is the trade you describe. Memory is
> the same within noise below 786k live IOVAs and a third less at 12.58M. 
> The costs are confined to microbenchmarks on near-empty trees, No regression
> in any real workload.

Thanks for providing these numbers, this is very helpful.

-Joerg

