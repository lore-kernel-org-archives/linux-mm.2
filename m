Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B04CFFF60F0
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 208BD6B0095; Tue, 31 Mar 2026 11:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0DB6B0096; Tue, 31 Mar 2026 11:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F65B6B0098; Tue, 31 Mar 2026 11:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 000AD6B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:18:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F29CCE054C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:18:21 +0000 (UTC)
X-FDA: 84606714402.27.D3F7445
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4CB611C0002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:18:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Z17IberB;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf20.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774970300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HIf8gyFX80uSQKCoWkQ5ZPo573gaG6x/O65jKZB5gh4=;
	b=eibKHKpD6XsFlr03Tj9Avjocxd1kBgMh5+hxGbxRQWZClirhpnHPol6xkbvPQxtAkVqzM1
	Z/w/Du6g1fgFWpKuHfnK687xk8G+hSd70qEDf2MjOu8CuLTCz4WgcZzpFYjt2r3Vd/VRmv
	aY458dN3O10r9CXysgyezniZYx/WJCA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774970300; a=rsa-sha256;
	cv=none;
	b=LdjbROiLxlChW0mNsxvihk3p9zcskEJL5nwWZ0/UqGgjG3oo9+yIaD8IwiGHcioWmUH4To
	qhIcWfPZSLVpcx2yWJan7e8/SzUlTlu4XuXMJepJ5R52KQ4K1Mr1SXqQVs3JzWz/lRbSVU
	4wpyxvJ8e9ZM3hvGD8h8B0JWEXD41NU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Z17IberB;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf20.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id AF79F40E0140;
	Tue, 31 Mar 2026 15:18:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id HEXG6Jv-8W3v; Tue, 31 Mar 2026 15:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1774970291; bh=HIf8gyFX80uSQKCoWkQ5ZPo573gaG6x/O65jKZB5gh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z17IberBscI1nNIel2qnP2dKieE8Angtikowhd8wgkm/JnlHdoCe/RUlPPxw7dyJx
	 nePrSWXtzHAKzAfvLyykWFfOEc4+/vPcMwM83zNC9iYPdYwn4J/G1gLIuV/RRyLo8O
	 cXokxt/7rMbYC92jB+sn6IaCUTAlguzdNqi+suGBYj2LTjIp8LOIUEsS6VkHTlOttn
	 +Kfl7I0KBTYO3CNKi3E+67jkSbrLY9DzBReN2pt5hfiaiyBZYJxvjw4VDgD6JuDiuu
	 VX75wBEayTVozfxkP7Nz3nRP1pX2PzQGfdEoInEH4fKr77BsPqzflHTnYzZIAODdlr
	 qVNW01sIg3kDzj4b31WUQHkNONc5uCS5QF/cCOR9E1xGCBQ5pBM5oyvujNB9IgQFDn
	 wmBGHWcGc/hlxZcaU7CLUn/FMGLSPEvTifJrIBmTt7akASYYQqwSg5s07mxHhs/zLK
	 Rmq2uPj6IJn3SpucLkPXnqOI76PIlYGzikph8+AyYo5mDGoA2gYBZ/PpdtT47R8AW8
	 sWBNyZqnDW6r9nbzK/gx+wObyNPWhvBDnGmERN3AvphrNgw42Ydg5SnnXNxAEjMZ8T
	 LZ2X+A5zyhTvQfE6EvlE6gWGyoNKcj1HPsOUcu3s+EiKCpirb5e2x8HPrCPioSkR/d
	 pUSmm0Z9qeLeuqB79ERFpTCg=
Received: from zn.tnic (p5de8e020.dip0.t-ipconnect.de [93.232.224.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 9FCEF40E0032;
	Tue, 31 Mar 2026 15:17:35 +0000 (UTC)
Date: Tue, 31 Mar 2026 17:17:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Shiju Jose <shiju.jose@huawei.com>
Cc: "rafael@kernel.org" <rafael@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"dferguson@amperecomputing.com" <dferguson@amperecomputing.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"lenb@kernel.org" <lenb@kernel.org>,
	"Yazen.Ghannam@amd.com" <Yazen.Ghannam@amd.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Linuxarm <linuxarm@huawei.com>,
	"rientjes@google.com" <rientjes@google.com>,
	"jiaqiyan@google.com" <jiaqiyan@google.com>,
	"Jon.Grimm@amd.com" <Jon.Grimm@amd.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"naoya.horiguchi@nec.com" <naoya.horiguchi@nec.com>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"jthoughton@google.com" <jthoughton@google.com>,
	"somasundaram.a@hpe.com" <somasundaram.a@hpe.com>,
	"erdemaktas@google.com" <erdemaktas@google.com>,
	"pgonda@google.com" <pgonda@google.com>,
	"duenwen@google.com" <duenwen@google.com>,
	"gthelen@google.com" <gthelen@google.com>,
	"wschwartz@amperecomputing.com" <wschwartz@amperecomputing.com>,
	"wbs@os.amperecomputing.com" <wbs@os.amperecomputing.com>,
	"nifan.cxl@gmail.com" <nifan.cxl@gmail.com>,
	tanxiaofei <tanxiaofei@huawei.com>,
	"Zengtao (B)" <prime.zeng@hisilicon.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	"kangkang.shen@futurewei.com" <kangkang.shen@futurewei.com>,
	wanghuiqiang <wanghuiqiang@huawei.com>
Subject: Re: [PATCH v17 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature
 table
Message-ID: <20260331151714.GFacvleugPydw71hxQ@fat_crate.local>
References: <20260311155518.1000-1-shiju.jose@huawei.com>
 <20260311155518.1000-2-shiju.jose@huawei.com>
 <20260312165247.GSabLvX5DjzhDtmyuh@fat_crate.local>
 <33a8a02f07184508bdff31e1053606a2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <33a8a02f07184508bdff31e1053606a2@huawei.com>
X-Rspamd-Queue-Id: 4CB611C0002
X-Stat-Signature: crmt86p4a3ufr1koroih75mefsh7p3hy
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774970299-96788
X-HE-Meta: U2FsdGVkX1+5Upp1m5ZR2vaa4PmPtJwKWgXSrErAdfPNz44VCD680qqoNoqNXv9Z6aHZd56Q2nSPA0Cw3DjdeuYDzMYPvDvwA/ry9a4epkIbGWK8t/glUBGWi4UM20ANnBYh3FOWEOxREUcf0RdyYjVzdqzTfGPZdF+caHm5zvY3l1gt1aRRfQvc6ktrAX2tmde4zoW9vIuBtr5A3iN3AlaTUoPDdGIGSuXyCweOaNNIEBs4kUdtEJMvbXxubzp+nwTR+1y3xDrHGmqLDIVvFtVd0B9eP+dr1N+VltQgRe1C9CDcAi9vnAFpRxZ8ZoKphzXoWKP464iTTH4/q6rL4s4279ZEZ75a2Nz5RfQtW5TxwUIjmClYzJiAQARkpb3e3IRN57GdyHykSJVv6rEbz3cTWqfvBOvEmqXDospjNvr+0kOCstsQGBew47ldzKdyHZ+ejH4OQcUfy1/TImfwlK75f/26eGT0KfnUyjqmn8ZhvSS0VSBzu/SbaULnXPRoU07TyqRYsyHoD4nugQMrtbXVKSd8GqGCbkYypUzXxbX5/6k3NXyqAgBNC1XOTRqaOaTmqfNySgDsdXddP7QWSqFs8PU0qWuaJiOHB6ZziYQZpDD8hBIWo7dP1b0kH/EhfqcQDnYTO5oDwDY+7WZeflDgKjGJrMRNyU49HBbNGtPC9FyM0H9av9Q5vPr3IlzJwd/SwJMVLcZEt7Vw+TdF8KK1uhKLHxDHaNRMI6I2mscBpiNjFj1usNdvnjyQqSAEfejhWXwj65G+g7mEmE7bqpda/PiGXSBOU2qeinLnzIJI9V4V8B6sEGLF/j0eriSWxXw7su2XCGT7KgaRiBHZPdjTcWZUBoptfqNF/os+Tp4zOVZpUPFsloEITbB+wis4X+yUdTpjWBvd8RxPp3jbQp1HoApQUyiKbSfDJLcgoe38gl31/J7HCVoNQAhqvwZVyu4Ks6ipYSX+UQHMekp
 dRvt1F4g
 aQ7/zKua2y1Q4gAK3qvgvcFnzUTV+4Tqamq4XfiUQaarMaX6jZipluFF6g2LchvwwW/p5t+gqwgg5sYPe+JnAOHuTcaQwhS+4+uRnQubLgb+8jQYRMsj9SQaLh5SxwTlyCr/9XVrdmkKMSnrCbnYuJOKzxScn3W3qtH1ziCl9EH5h1hyaJ3sIdGtXPKSJMsgTy2tlkNHjsxal+Agpckb0iNZr9xejbsIWhl1aAgsXckNzQ9exMKSeLM2QUuu04/ZkT5UmnrW0x2PgwoZtkK38NvlyKSCCnNr8bpNwO8UCXGLV/PVg4SQwIzC5omB3v/WT4GOy5WpDn8syxi9imPVMlJyBWT32734goyPOBVRt+qacWE1RYAtJex7rOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 02:27:40PM +0000, Shiju Jose wrote:
> In v13, support for address range has removed for the code simplification
> requested with the expectation that a firmware will do the full node demand
> scrubbing and may enable these attributes in the follow-up patches.  I do
> not mind adding support for address range now or else later after first
> version of RAS2 code will be merged.

Right, that makese sense.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

