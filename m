Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A923E606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 19:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=a9e85s3/
Received: by kanga.kvack.org (Postfix)
	id 9F4036B05B0; Sat, 21 Nov 2026 14:41:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB846B05B5; Sat, 21 Nov 2026 14:41:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E11A6B05B6; Sat, 21 Nov 2026 14:41:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 66FAF6B05B0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:41:19 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B69F2C05C8
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:41:18 +0000 (UTC)
X-FDA: 85460145036.25.4BD0C58
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id 86068180004
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:41:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="a9e85s3/";
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf24.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795290077;
	b=ffafcr7QaTHn0BaKiq3prB1XqAAxTpuY+Mrr/TGw1gDci0PdR6hU+SzjadTKe6x3fBCfV9
	FynFUUIvB+1j0/eTkbts4Mme3eqyBI2rewDzSdsm2J8Y1WmFuxeW4jekxfhznhmKafDzu5
	Npo82VOzRfaYjo9Vv6XWsvVcxzNnd0w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795290077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+onO+f8a19JOkIsaY0Ktl6fAq9BXdKARBPZo/DbSfCU=;
	b=xRfsK1WTY99V6PmTPGMo2wz49FXMYAon3iA5rk9kRgNND1T3oePlWW9PM4f/rYeBlrAqAJ
	msTBHukk9UYy6sRgVbmO4r2J0/294i02BExDNARwQObG97GoqpL3mV2WQRVAf34knjvgSR
	Ec9O/MRR8yhMBlqPzC9a273chGpXJOE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="a9e85s3/";
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf24.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7E11940E00DC;
	Sat, 21 Nov 2026 19:41:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id GJebFJ9-qlEV; Sat, 21 Nov 2026 19:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1795290070; bh=+onO+f8a19JOkIsaY0Ktl6fAq9BXdKARBPZo/DbSfCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a9e85s3/Kcg6dkQ4T/hod+dHO+ADXdQXKv80Rc06qwTecP/R43KDj6Tf7mOA4GDcE
	 CtwDSx5FolO6snw/xn7zaBizU+UyqRv2z/Ka9CfNOevUJymosv2KYuIVnPwCnI9jS+
	 Gr80otaHgiV7SbeWX4Lerce5gyskwWSZ2CGdZjvZ6hXtiiebuwyB5f53E7MZaLjFBG
	 3FhhGiBHs8lfLRwPSf2JVQxtpqqkXr4ghaYyfqJPvGy3TaILZEoQ45PMHQPNxgVRUs
	 7MWBv3k/1LCalDnIP6qXRCZeEe3ythQaxfD8uY0/F4Sd67rPOrU54e+cogrSasT2UU
	 DfbO/cBzBLgTYAn/NlzU/+dysZ0F2zO8CNYdGTNYhpa1+KDHRiRCAEoVjdwe/9y9qQ
	 SLIBW2ZoIPC7NkndmPiZOhjevW1FDuWVpWK5sIjRWBCoZPDTn0ctDkgxkQnsn5CFVi
	 B339NEmPnE6t/FVch24RfqhW3LQJDyn2XbMkHv8quVtReb/v8PYNTAy9BQxk49k+Y2
	 uxQ5y3ntPRgw+Igch283WMP5H5NyZYappEXYUnmq2XAHwY2Lhxg31v2hGnix+VKjnI
	 r3l6BR+7vwp8LUseBXEc/+wrNQk6x32BAJhPZSIXeTolPchGgRkX5Ft3y9OVtRmWGo
	 41yM3Zn3a+BzfhjJOas2NWyQ=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::2b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6CAB340E019C;
	Sat, 21 Nov 2026 19:40:33 +0000 (UTC)
Date: Sat, 21 Nov 2026 11:40:30 -0800
From: Borislav Petkov <bp@alien8.de>
To: Shiju Jose <shijujose2008@gmail.com>
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
Subject: Re: [PATCH v23 2/2] ras: mem: Add ACPI RAS2 memory driver
Message-ID: <20261121194030.GBawHzrrCNCMpfr7Gx@fat_crate.local>
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-3-shijujose2008@gmail.com>
 <20261017055852.GBatMOnEl66YObvU5k@fat_crate.local>
 <CAG4KcR+NOKHNzg6FN-oLLHgUxeitZHKXg9cN7dz24+Ap=RrwSA@mail.gmail.com>
 <20261110071729.GIavLFCfLKzPx8R0i0@fat_crate.local>
 <CAG4KcR+ikfQEBjCZiNJ1CUz=u3Gtbk_XDroA_GQqYpgO4Lo5Qw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAG4KcR+ikfQEBjCZiNJ1CUz=u3Gtbk_XDroA_GQqYpgO4Lo5Qw@mail.gmail.com>
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 86068180004
X-Stat-Signature: f69zqpmmjaq7iqsd8we4jpg8ifgzd8ng
X-HE-Tag: 1795290076-976267
X-HE-Meta: U2FsdGVkX18YnA0hXtNQv0N+gYp8h9sjB2x8W+/gfk/bbcjT8Y5cj+D1qNh3al7UaL17RMxlGLgiWTnVgQ9pRWGrFqouFkkQFogNs2Thl1yv3aE2BJOTbUN3Jo2pHKGghlkaHR7KVtn+5u+2yK8mWNyt+6sH7duJPQxPysGLhFxk0U8ovwjIIpMAGyF33kPygCMK6qfxMCNbeK0mT7LgRn1uOMuS5WauC0t7Rgnz2LzUMaNOHdxUr3ORWjtazQeswm04tY9mxwCMDa4lpUwItZ+sQfTKjHJZIX6exD+UYYZBGW/0+tVoeuNes41b9U0w6baLv2Xh6nlIGay3vzcZoEzKE8kPzUwD9Wppc3que9pN5ohJxNRHByDkQ/n4tObnCN3bmywVShCH8o/opd+lhRLGDaOOdD+UblUyhr2OjqMSnnXN+dWOBzDuh6V0O78kVZAP7e8bWIAENC7eN+KpkxHQoazBNygHPYnky8vARbPyqtzrscHdlLKAHklkwEWFEa0Vcd4Z7LWj9i4GYyjnDr3Y/Y3+l00G5AzqnvroNkTN6xO91AfIXmY+QYf4D2rnRyyQxPDv9bt7PsIuxB9klCZbuAgOLIzbDUdCP/Oyp4IW2YX/UkbKo4GtnVZP9vC2ACWURM3aWiDCZZ+QX0P6BtLTBwq6RiJO93ER2tO+6TVc6OSMJL0dJ+4ZjMsLhkWHsAxumllvnK9dloz3ZpuczqByVH4Idqm2VzGcZ3FruBnxHWSOE5Wnv3OlCvSiptRzUB1jO8fkB9MAdYNEfO69NktM0OtuUKQkbytkM71VVA1Vg67mx9L8qifTfXPSPJrMa5xuAj2kg/9E+cTuO++3cPNprZQq2P6W0ADZU9vplcS+iWiwzmrsCUG0AiX4VqXk+CeYhHurFzWe0yACko1mNB1fgmncVSn038SGr8iJnw3jjhnztBQDXdLrlnBfLMlYBzyHCnrNpWnhAG8IYmX
 8kgTMbz4
 50uAndUHPyr0P0sl+UuQqKuBjI+XheJcLsFkkggwBNrtYRHlJr0PV9cUpV+yT6peeBbiIEvb+LRKwG4kh9/ngKOZLthYDcj+NO23uc3DzX/0nwCsFaR3Vpnp8/9+TfZZh0oLx3tIKQYoRA4xRQ1WAHjVPhOgzvM6TPcfd4p8tKlQ9GD5RajGvjC8YErp7D6iDbcCSoAJpzT/wObZp+hz1qjRlxghOeJ1Q25EiVvQ7ZFrpLEjoAuqzFPylgW0evSvE4z47sP4rv304SYZ9t2RSuy+3gzBrSEUtFI+1BQMWigAk7J6Al9Hv0Z78dE/NYdpwCJgL4Ph01r4e6r15vPLRppbsMhQDdnia4AqjVusMwbbLBAoe1KJZVpu7o6TMGzK5NJPSNmJjNY7vTj/WOCyj4qF9DrpVYsow8jJ4m/CknO6ZcHrHudWo1sgQEZjvTgXB/Y6yX8oULeGRGXehoc/9HYn0HR24aYvjMankc6umThL6DhbnTN1+5AYB6PWxiijkg013HHhDj2tRY3o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 11:00:45PM +0000, Shiju Jose wrote:
> I am sharing the changes in patch#2 here for feedback while testing on
> other platforms.

This doesn't apply. You can attach the diff so that I can fold it in.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

