Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 581D2606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=wdW0YDDp
Received: by kanga.kvack.org (Postfix)
	id 768086B05B2; Mon, 23 Nov 2026 04:41:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7383E6B05CB; Mon, 23 Nov 2026 04:41:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674ED6B05CC; Mon, 23 Nov 2026 04:41:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47F096B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:41:07 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0F491607AD
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:41:06 +0000 (UTC)
X-FDA: 85465890132.03.C84FDE8
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf16.hostedemail.com (Postfix) with ESMTP id 15AE2180009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:41:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wdW0YDDp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426865;
	b=PNpVu6gFFe6uVyvwv7FwgSF9rvEQ3DT+moHCeldRb4m9fnmxPXag41D3lwG1n3nszkXEwR
	k3jXU9yELVGAra88wWSKuC+hgM94aXP7qjcmp1caRr1AkOubl3fxTmWQYvbjt0YaGLI2Ew
	qa6Uw3yFgjHimYNiDKxve0w33CERrM8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=klUf2CdqHQRXCM9LUthGI+m1p+fVvUp/IIQj44sT9IQ=;
	b=BCOfKt66UNgWsBUKwdRip4uFQQzcrHvpMkmb4cuEe0J9H8rpeSHZz5QcrEJx7emCwSb3ZQ
	2yVSmh8LcMGlq5X4eSu7erMlwMsknUPj5xNiPwSfhG/DizGT1NoBqkXrgJEF+FCeU86lx8
	+8RD/Fify7AND5X2hMI4oJ26JWWnkus=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wdW0YDDp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795426859; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=klUf2CdqHQRXCM9LUthGI+m1p+fVvUp/IIQj44sT9IQ=;
	b=wdW0YDDpm6O9CRiIV6Yk8Wd9yTWmQCUsOfFMi5e5LPr59IoWSEJkeCwz8AX2bfp7oo2eeev0lYrDfI4psNwEqbZIIpDVmrc1eqfu4sh2SDvxRMdiu/p44Hns9BiW3qbbFNcgWZ3+MaWp7LlngT5TQtMBJSIRbz525OOt1+KPM2s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XFGswNE_1795426856;
Received: from 30.74.144.153(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XFGswNE_1795426856 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 17:40:58 +0800
Message-ID: <100c33ee-be1c-4eeb-a94c-567cc0337c78@linux.alibaba.com>
Date: Mon, 23 Nov 2026 17:40:56 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] mm/vmscan: move code to lru_gen_{add,del}_memcg()
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, baoquan.he@linux.dev, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org
References: <20261116081403.216452-1-max.kellermann@ionos.com>
 <20261116081403.216452-3-max.kellermann@ionos.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261116081403.216452-3-max.kellermann@ionos.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 15AE2180009
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ztfx5g43bapwd8b67h67pmyk5w7fqwa9
X-Rspam-User:
X-HE-Tag: 1795426863-299909
X-HE-Meta: U2FsdGVkX182KE5c8DiuK3Msut/m+VgRLF++PSkvjPl7kPPg8ZfTVaoolZafcT86sjDYmHe8T1B5PG8DUP6tx4IWTeMc+bK9g4JAuarZnCxcXhUODZnQB2dVsy9CmZ60I5ZXNA/vOE+HzXlWEq0gJk/uGX8W9CK2XsD8dQyBoofFMfkGBwy7uzPH38DbYzB6yAolVCvRGxZwQ805spBahkhcrCqV6Kavu+rkOsiIzEUkiw7iVeoV2raZiQg4tEY4+rKAbrn941zA2hZdcRgi9QBIs4v302nx0W9FNca749/PN1wEaIjrXSHSFn3yB/g3gcynFRVVECjQPf5uanykyz4D4gr2hkwTmAbe8jdOShc5NoJPh/6gaQLsFwXQyiNCJ9ojOeTa2R83TQm7m7xSlX4uu/F1aPahpC9UKGqilaN2NKlWbPgRm1uYTSMXtRvYx5lqL1rgGHNbdk5RHUuslBEf8knjgTvxklbqLKirnJvVUndr0x3t0cNTbvQ9KS4cIrXR6i3Xox44YJewiFF9YUBVD1oW+eYVjjB41z5qyGa9vcdVr7N92UfNmHM1z6TTjSZ3GrjE5+tbSN1XjPaLIAv/6k2PVv434bjrcnSUhAbzdfuWadCYKuW6c5Txj453GNSxBUtVFdjobIzbCdn7ib5tWbS1H8IKjxi5EDHEebLaYwToIIj2zBvv/RoT3GT4r8l0gH+ULx/v6b2DMTCjrgZCfQ235Z4DoPfD16r/oCwJO3/G391iapKrswooNgXEkHMvnxmN6kvde89OKvc46+wnakF/APVIlH7BQVDgbAEJqyvDP6aIH4+rR/kQkRpJPeuMs5StpDV2WthgBfGs07zlHRE2a1stCXY2KsDS7jipWDOZRQdWnvI/w6cbKr8ltg+BEuyWgrmQu+UvdZt1M7qb5x7f4C97HwDqsz0aTLmiCQi+y8MlbPUM2jZQxTt06BA5RkJtQAymuKFXyw7
 NXRWfvau
 7EqGumSXa6ak6/QdNXukwkX8FqWnhi/k1ZivwE52CajJOuwkTE5p2WkDM9SWQxSirNovbvxiU8w7WMI5kMBsWvxm/pFlLodUsQfhDN5TC4T/aAC449C3dJ1tQzVbQyC0G44w5FbLHFr8C+JbcYD/iPSeuZmNpYY+XBlpIauvZrrlggitNun4VDZECMo0wDuoY+SvHh4dnf8r1xF99+6nNXZ4n6uaF5a/rvECm7TUXFDTmvgaf9V06gmGN4Iub/5tkMdVIllAn/+A76OVGDGCv9p/vtWh7zL5n8OuRI7S579dECZl1/CTZxnxfbJGIkhlDRKjG9MXTN+0XTvSg1DNIzcmC6Hv/dAO6haz5h7ufR+cgEj4KCRDNncnEW23p4BKY85tadEb+V34wNjc4MvcnH8V3PfEy6ue6EP2oAfYP7hOxbgr5XpY+CD1fJRSqSQzio0yDkbLymKgvhow/BjsaQ9hnss608VXGI3J7brFct6aJf0VNdMYiiQYydBnMDxrIqMWB12QmnTohUFTZjoC1qI85EQpyymkp1LXMAG1TYchHl7kUWjdmZWHfFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/16/26 4:14 PM, Max Kellermann wrote:
> Preparation for the following patch that adds tail caching.
> 
> For simplicity, hlist_nulls_del_init_rcu() is now always used, which
> is also valid during rotation, because the entry is immediately
> reinserted under `memcg_lru.lock`.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

