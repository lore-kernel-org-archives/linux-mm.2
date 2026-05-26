Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA12ACD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 04:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA04A6B0005; Tue, 26 May 2026 00:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77D76B0088; Tue, 26 May 2026 00:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4586B008A; Tue, 26 May 2026 00:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E71A6B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 00:09:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 434A540294
	for <linux-mm@kvack.org>; Tue, 26 May 2026 04:09:33 +0000 (UTC)
X-FDA: 84808241826.14.AA5CEA5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8ADA24000D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 04:09:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZDItGFol;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779768571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQd79S3jmwh5Od5pm5jxNxTwgJT8xPboifU1ZFa5Ro8=;
	b=wZl8ewIwwrlhaPeGSx7kGTLzSky1czrFXWc5CLFDjoGhoOwEy0ZKOHDbDisKPfCsfLYqYw
	3WDQ5Ve2bmmzggz1iPOKVVterVl/G4/e1DYRNN5nqeukieX9sy+lbIECqXwSS2P4fof0ak
	x87gN2jkhUsawvHsqkfmftEQWp3Dx4E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZDItGFol;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779768571; a=rsa-sha256;
	cv=none;
	b=0z9DvU1HI3Y6UG8+ZPn9iQjY7xNjHhwO0KrgLWGw65hGWOAuiLgi7vrV/RPiwd2uDJ+4ih
	ClQH09+mc5H5W441Cl/VvEFG70tI9iQyaUmssiRoZFf9QljzHV+Tm52Q96Q+aJb/PJQWr1
	fpk0ZwUIeEcJ9Mr8Eda7tpkAH7kbKjE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B120A42B68;
	Tue, 26 May 2026 04:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7891F000E9;
	Tue, 26 May 2026 04:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779768570;
	bh=CQd79S3jmwh5Od5pm5jxNxTwgJT8xPboifU1ZFa5Ro8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZDItGFol54Vyau00nEwrGiLqSd89co+5KygIfEcE5Yr9VyW3cUR4nJWWme0xPopxf
	 taMzNt2gz2DLL+gNKrkkZFSSOJ3NRNjd3xNYd5JlyE/NQiMf+s1ijUNsWwhZXPyUe/
	 v14XqSFIG8rjcaV8gI7SXwL4XlEJvmbpP/YP636LSFKbCiO8y6Cvc44SYbLXde+SNE
	 z9TscFICTMfvkGQgGB3jyhh227m6Ji9ic0Q+OFIgYi2dQpkCvSc6gH7JPfXTIoODNi
	 0rT5IJ4En/qwmqN2yW2gHJCWpxAm1i3UsTPwTazILJKAeS77pIWzU6hLUsYRvKVoAr
	 sTx9ONa6Ijn2g==
Message-ID: <c129633e-c411-4070-a836-78024b4f6acb@kernel.org>
Date: Tue, 26 May 2026 13:09:26 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] memcg: cache obj_stock by memcg, not by objcg pointer
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Alexandre Ghiti <alex@ghiti.fr>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20260518222827.110696-1-shakeel.butt@linux.dev>
 <aguiSnY3ie1y4nEl@linux.dev>
 <4e296262-fbbf-4ac7-aecc-3ef831583704@kernel.org>
 <agxszIIN6FtK0fEb@linux.dev>
 <ca8e655d-5fe7-4957-8a36-6667616be8b6@kernel.org>
 <agynzVVBb4CYJTYG@linux.dev>
 <20260519134927.ee04379d07b0674872422c06@linux-foundation.org>
 <ahB_kaWXowIIQ6dQ@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <ahB_kaWXowIIQ6dQ@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6c41pcruom8q95zxehxtmihur956rino
X-Rspamd-Queue-Id: 8ADA24000D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779768571-117251
X-HE-Meta: U2FsdGVkX1/Uj1qRo3kRWl5mdx2LyMC+s+0NrCBF5PnfTsmo3Bcf8ZaGb6xIzZySg3N+dOmYs70CK1DZEpPI4kcskTRqqmHYGQn2/EFSVkEc0dYoKtjm3yJ2dyOYZudxEYl6RFXgLSWpsqaqUciS0YcyZfPtdAE0sW2NTGH6qV+KH5M7YURl32WTZks85FhhDWJTXgyYdTVOc8Mnu/2ZhxB6j1tcvryL6IPueuAtkKt3ZGsjHhLA1J4a33/Hpif80SftubnfzPlu/WLmjFBH2X2jZZqt1UfUtg/UTgGXVO6RiCwmmzPiiY73c5akh7j0bBwCVBz9351BrnBdudYP4GvLPCMMIFQfvALDGjaLMCIb8m/cYEWmnIgXpsiCFR+/soIMoUGRGwOKZNN72UxRB5cBLwLm3Tokp3m+5/ISAbKjB7yuTcRxVby3BZEOwKqdtbrl6Az8VwnTYVwxK/IFTLVNpY5Wbzef7/eEB9scAf5xPgKiKyEbG5H0VAH0C4OCdLHNS5HE7pWDtIQTX3YsJ3GoPnpgvgVcx+oqAjrmGVKGJqIPailZ6JYLU+MY/ZRumdnSwHJsChW73rHyqSnWo7i67Nj9tby2TL6w6FDBOrFfejwC1I7buZzVziSs3jf/UWzLt8ZXaDlg1gXHdrBz0emcu5I0ZsnrNKCxkZ1bZfEkz4xaeymOcu9XEpi14qup4eA9s0qVXPPdFToq2uPRB+2oOMskbVhL3HhlvE68LIPdVSEOEOI8GA+BB+XGptX5skqHc+U4VJaYwzG/vI6EaG0LqS/xTpFy+t6albDZhmFMDrONRYG7G12vlR64FkNPRo0jvANcPjEpGGsO8WqLyViPF6igKPR9osaSGtI7By7ezfia3baJGDB1RvGFs385b+g3mPdaOfKKxfFE+yuaKCNGTW2GHbu/wyzZn24C2d3PK2Cmc1u+RjTtqdpsg4ko7g/630jEtddO95TbNLC
 Vx97yFqS
 APDmoT+2XkAdUAJomz8RTOPUR6l2oITXeX/UYs9CMwcpvh/zcG0qe4SH9cepfSQrqeHyQI0/1bFkEh3qYfi7SUc5tlmFNJ/BXSy4rSf7NfujdHEbgDpJjY43nG3TAJHik+ijM6TZRB9Y1KiMiprJTBW67z2F9iUa1dBZ6krHCjX4NzgF1ILN2ejPD1PgYdOhWt2Ds/UBFhT6Bl1ag+fSfA4y2jtlcNIIJzxdIpDoesc/N+4uM9OgPUEcsw45t4178VMvbREkWfRBKuQI2CxVCCpR0gqlKwcfzDR9otx9vGInwEzjo1Km/lROXImSvVN32mhUKhPvTq5PGav1bx97Wx4Biuh4m+2qYDZqVSlh9ugxmK2LFXP1FV8DJjSs0vg1q3RTBnp5HQBOmQ/S7FvPWqGQZhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/23/26 1:16 AM, Shakeel Butt wrote:
> On Tue, May 19, 2026 at 01:49:27PM -0700, Andrew Morton wrote:
>> On Tue, 19 May 2026 13:11:13 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
>>
>>> Andrew, please don't send this patch to Linus until we decide on the option.
>>
>> No probs, I added a note-to-self.
> 
> Here is my suggestion on how to proceed.
> 
> 1. Let's drop this patch (memcg: cache obj_stock by memcg, not by objcg pointer)
>     from mm-tree.
> 
> 2. Let's not add anything to 7.1.
> 
> 3. 7.2+ will have the multi-objcg series [1] and the patches will have fixes
>     tag. If someone uses non-LTS 7.1, they can easily find those patches and can
>     backport them.
> 
> Please let me know if there are any concerns.

Sounds fair to me.
> [1] https://lore.kernel.org/20260522011908.1669332-1-shakeel.butt@linux.dev/

Thanks!

-- 
Cheers,
Harry / Hyeonggon


