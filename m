Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28709C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 06:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CD1F6B008C; Mon, 24 Aug 2026 02:34:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17EA96B0092; Mon, 24 Aug 2026 02:34:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 093CC6B0095; Mon, 24 Aug 2026 02:34:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB8F26B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:34:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E7101A0448
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:34:23 +0000 (UTC)
X-FDA: 85135198806.19.07720B1
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1E53CA0003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:34:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="LZ0/DHz7";
	spf=pass (imf15.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787553261;
	b=fS2GerzdX4gNsANXk+yxXGwJL6RiuzLgxQlUAAYxvs6DFmjOOWcth8tQ2lvfRfT32BzrFO
	kTDIn23pju3j09p/Uq6aWe3QQbIRIylfIfHLcAkwmev6A9xeBMWmBGVC5x12gjr3Cl3IwK
	j4+r1LTYp51jcTEmWDwQncXIGsVote0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="LZ0/DHz7";
	spf=pass (imf15.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787553261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=02mzIcyNFWU0Hsiw7mRli2vS+eyyUPUCGoO00qWXUWo=;
	b=pHstw34HqRY1AwxWyX7oQn343MJXbzfJjTA3r6/HZBqt7gEFTmBM+jSf31e/qe7kPYvzh0
	8lrIjzywQyZyvqKZupuECWGyFKR7LT+pwdMCrvbaL4y4FktN8i55Rm2E/JWGV/Vj4BNqhd
	hkd7qKo+sLJz2rYuv/AC823jkSMSbLY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=02mzIcyNFWU0Hsiw7mRli2vS+eyyUPUCGoO00qWXUWo=;
	b=LZ0/DHz7xa2j9yzxzP1e3NfauLKAuLx2idpzSrpgnag56gGrgINKWhZ5xmCv+x5EgwYQbEbcn
	OPHb3y05XB3hOr05ODst+wZM3wMO4PNeQ65AS9uXZa0Ga1PbZKsoKLaiOlSMqN6vqfTMHwHJ+dB
	5R6rc11v2EFhJLIcNt7Os8A=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hT17j3SsfzmVXX;
	Mon, 24 Aug 2026 14:23:29 +0800 (CST)
Received: from kwepemo200009.china.huawei.com (unknown [7.202.195.26])
	by mail.maildlp.com (Postfix) with ESMTPS id E9D1C402AB;
	Mon, 24 Aug 2026 14:34:13 +0800 (CST)
Received: from [10.174.186.187] (10.174.186.187) by
 kwepemo200009.china.huawei.com (7.202.195.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 24 Aug 2026 14:34:13 +0800
Message-ID: <e1c2d008-9490-4b68-924f-dcc45a84f369@huawei.com>
Date: Mon, 24 Aug 2026 14:34:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] kho: Convert error handling to immediate return
 pattern
To: Matthew Wilcox <willy@infradead.org>
CC: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, Pasha
 Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>,
	<kexec@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <hewenliang4@huawei.com>
References: <00c96a62-f783-497c-a7ac-1de495e4af06@huawei.com>
 <20260824024448.550552-1-longwei27@huawei.com>
 <aouyWs39qxGI7CP0@casper.infradead.org>
From: "longwei (I)" <longwei27@huawei.com>
In-Reply-To: <aouyWs39qxGI7CP0@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.174.186.187]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo200009.china.huawei.com (7.202.195.26)
X-Rspamd-Queue-Id: 1E53CA0003
X-Rspam-User: 
X-Stat-Signature: jn3ehnmcuns58w3zqk9xc6cszajysd3i
X-Rspamd-Server: rspam06
X-HE-Tag: 1787553259-796659
X-HE-Meta: U2FsdGVkX18Q/r2YmE2xV9NnXLDDw254GEgmGvwTGGRmrjLNNunUfQaUvAsQscgf7MU4XE1WlN57GZ8jUjyuqs6j5aqTZbpwjluC1JSEwDqvrsSmuufAOASAP5wj9vp097rY7ZEmcyY1yWQoTq+ln3X7pGx7Y0xzRkQNA0iwDtyZc7OOgUI0Ge/WNQ7sY1bnPeUbuS7Ux06DqfDpf6ulC569oC+WFpU0QTiNZ47JmIQZUEvOvoMuxmFl7hyWD5mRIuftMsh23mkP2517MbCteume3+yLx7PtKZlPnVuNyy20p9Q1TqslrgY1inL3dj71gKqlsFNrg0HKHXaA+fXGUrpTstwEZG+rVNOOxJykmkBCvR0vuqsSShnnohH2mjA39+vCy9MfIiHFzaI0G3KsgEv5lOYKqyaWAohlhKmw+Nan2krTAU1OINtOom0pCcNT9/k+TnwjA4j0rCStJzqtsttK1ASz9SytZpADYqKkDBPZLohFDhvIowP/bRkLMEZU3261fYS/PWdYmly0o/a3DkkaCpZwrESzWowW/bE0snVpoXJYtZ72RArLHd2Gc8iKxNjhxRR4R3TIGiMeCJur4Y7Gs0vsflyGY1aWGkvmiWnnQhyXnZy48oKXRchXTEgb6YilVM0/DZuwgQ2V9kCmvcaMHiuM4UCbyN/4OMHpDjVIWPcDp6b7w3kBuH7JoO64wBdIxtCckmgbUH/POXhm64OGfljcIVx0DztkUJEjPrN87TAIXtK0KB6YKE/CUP9ZPHNzx0UFiy2HyvhjGCApi9+B/R2sFFABnuYcOHPEGtANoewKrEzDtbLRuZgjjD3bRHIyFRkc9iWrKSRaX8kXqqYuDbapk4klh2QywBCp4crzFZw2b3SPrngDhTOypYLCPghwPvqwuX8a2vjZ8NIILPestC6kL48yLDJbJ9/BLVAHvXAqOx029NpMM8IXuQ+OdSqSzCcAd1lGTpSl/5P
 RK0RPEpV
 AhecvS/oUijGjtgWfxI+4z/5afOI4WUdlp0OQ3MHqxjI798Z+EXB5wEQZaa9WRimd0IIwj6VT6bZbScMvPfleT5ht4b58855PnkqisKSNvHJqZH0cCTht5wdWlMe2/fvuyDH+nrzoLtSKVevVxAh3iJzf5jcYRZptfCzfKVodDMjK+C8sFAcuCnOPjerZFDuaIpJSNCbcDMQscf26u0Dnr2DZd+Pk6zNh8QS1ewTFARHjXEWbb7XCl0SV8y7JGh7IrlPFVo3tdPxcrj+0I22YuCmPen+MJjY02vRvMNyd+ul6X7vvPuJrQ+pMMFhoXH7/r0hf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Matthew,

Thanks for the review.

I chose the explicit `if (err) return err` pattern for clarity and
"fail fast" behavior. However, I'm happy to adopt the chained pattern
if the maintainer prefers it.

Thanks,
Long Wei

=E5=9C=A8 2026/8/24 10:54, Matthew Wilcox =E5=86=99=E9=81=93:
> On Mon, Aug 24, 2026 at 10:44:48AM +0800, LongWei27 wrote:
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -1438,20 +1438,34 @@ static __init int kho_out_fdt_setup(void)
>>  	int err;
>> =20
>>  	err =3D fdt_create(root, PAGE_SIZE);
>> -	err |=3D fdt_finish_reservemap(root);
>> -	err |=3D fdt_begin_node(root, "");
>> -	err |=3D fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE)=
;
>> +	if (err)
>> +		return err;
>> +	err =3D fdt_finish_reservemap(root);
>> +	if (err)
>> +		return err;
>> +	err =3D fdt_begin_node(root, "");
>> +	if (err)
>> +		return err;
>> +	err =3D fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);=

>> +	if (err)
>> +		return err;
>=20
> Less verbose:
>=20
>  	err =3D fdt_create(root, PAGE_SIZE);
> -	err |=3D fdt_finish_reservemap(root);
> -	err |=3D fdt_begin_node(root, "");
> -	err |=3D fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);=

> +	if (!err)
> +		err =3D fdt_finish_reservemap(root);
> +	if (!err)
> +		err =3D fdt_begin_node(root, "");
> +	if (!err)
> +		err =3D fdt_property_string(root, "compatible",
> +				KHO_FDT_COMPATIBLE);
>=20
> up to the maintainer which one they prefer ...


