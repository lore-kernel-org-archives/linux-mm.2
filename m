Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42C6DFAD3EC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 02:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8CEE6B0005; Wed, 22 Apr 2026 22:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A65116B008A; Wed, 22 Apr 2026 22:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1FB6B008C; Wed, 22 Apr 2026 22:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 895436B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 22:46:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2FD1A40251
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:46:48 +0000 (UTC)
X-FDA: 84688282896.16.E0E736F
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7B91A18000F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:46:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=N72OwZto;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776912406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j6TEcC/k0cIqgg7/ppJTuoefMF2zsA6Agg3eQu3BxA4=;
	b=Fq24Fedk1dZHeH6+wsqamITQYXzDg44qP0rqwZIEo0+T2wS5YndvDjK4oGUjMmKzyqqn+D
	N0OFzm3KVNMqx8jpoyAnM5yma41EDI9HrAQYG3f65w/aTthnQu7GAGrO2DeAxk8jIvHio/
	E5Acse3o/GV6HHXUXo/x6gzjLcEG7as=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=N72OwZto;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776912406; a=rsa-sha256;
	cv=none;
	b=gSkdx39Z8joe5TgzhoFokGONeuHvjKxHvYs73O9AG+zWAg/ZeUoAIyOJNyFIa9PgDLj3xg
	ytWx1eijNPtplp2fgZvG1LTMz4TMj9LdYmzPzrMiD4g8cz9lXg3btVbJsDouyMZPJM4aqH
	bZVgzl/GHujyv+MRSKXvV17r8uN3zTo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=j6TEcC/k0cIqgg7/ppJTuoefMF2zsA6Agg3eQu3BxA4=;
	b=N72OwZtoYJCxx4bo3pf3Z76vVDpwD7yXKDzexbYoF0aoIMIcsEXSFktGE2GkOl2GmgT7vXbpj
	ywEE1volGKkfIwGSpPdHIhDRazKKYe/cadzhXGTVEaPJsGN327QEHqDSskXhDIkn60690uI6X+D
	4uCzvhSjqZOrfULQtXdzdlY=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4g1L0t4dDhzKm9l;
	Thu, 23 Apr 2026 10:40:14 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 90F5A40561;
	Thu, 23 Apr 2026 10:46:39 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Apr 2026 10:46:38 +0800
Message-ID: <5c915191-b477-40af-8d56-ba9f2c24c5ec@huawei.com>
Date: Thu, 23 Apr 2026 10:46:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "tmpfs: don't enable large folios if not
 supported"
To: Baolin Wang <baolin.wang@linux.alibaba.com>, <akpm@linux-foundation.org>,
	<hughd@google.com>
CC: <willy@infradead.org>, <ziy@nvidia.com>, <david@kernel.org>,
	<ljs@kernel.org>, <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7B91A18000F
X-Stat-Signature: 4469ratns4n8badb1kkooipgjn43fp9w
X-Rspam-User: 
X-HE-Tag: 1776912405-785836
X-HE-Meta: U2FsdGVkX1+JWCtD8xtSmrinbeR44ms+DztCtttdNNV4qSAAdTEG5OZimPphx3fr2semCfbFs3IqT75+m8VJ8MD+G7h92MoUqrpttul6qOXZcXfQ21TTpgdnJdkTCNnWreYyaL+HvwW7AtiupIVx/GGNr5EDCEbHZcy9TbTL1L40xVHJeGiFpBgo9UqT0qAe66IvhXwkf3Qg9lrYQ1nKvJb1rpB0rg89+MvTYtS7JugwDsw8ZqwXaqtnMH1i09mtr5yhxFKp6b+U2N2mk9VLizxL9FbpPMnsFdhUf7f6S547mH1CSadaePbOyUVeWn0B+7Ul2vNsBpuBCqGlazit4MakJF7ocgRwnN9WA1au1dhJ2WA4SlEyHrT3YAJCLe35YxTkYSVbJq6y7idur1VFY1YZRSIJU9T9T4gQJxG/un7XergscH01Rw38pEd0rBznKtiZacplG5P0tnpPFt3vEvJEfoZRgAes+hDPC9ttg/q8Zc4PZIoSthLjwUF3a5Y3Dg40S4VveA6kRS61z4hz/mzqgOG9hX8mNzDADTWGefp7apj/C06ykDzx2tFmE02LHoRl/Gj9pR58xadnjY9yofekmvXF3YWt45HOq5+/h8gjcXd98Cl6+aTSLqOSQp6TIKKeBp5lYXnYO42wrHqy6iSuT1Mkzg3pHqW6E2PW5Y0EH8KCxJWq+zUOz8J7gjHZse1IbfsaVWHp9U76Lp8sSVAqmxgC21J0Gbt2JVn8atUPhOKz1z5FbRsEPvnM236XRCX8fhx85WpJEirGKgnNQwDEWe+2vwkUhmr9PZRSfDn8ymDpfA7k3ako6rVr3qm48ppXHDTSGbp+q1kUZOcQ86nF11o7RxcUDEtkfWrkheifXTtiNIMHKlUHblsDUnL4LRD18R4U3Xbpgu+rpnZ1P70EvEtp1xjCXDrU/e5R5z13kQUeZOl5QFz34CELrmTlkmr/7NoXuC+SPrTB4L/
 NvaTm5w5
 hEBi4ikGLcx6DO1YxfIRQm1qACFx8XwZyp/U6s6lNZv+9Q7u+pLMaKQd3+4Z8xKubB5jQ/cDifbnX+LEMeLTn8UNllYwwAugviFxXxP+jAOpqvEdzyMsUo+GCScmfkiktS0i/6Nx49v/Ud65HdDHBApJcZX5Exw3Vt9WLOrTR/T+MEjYmwHdJ60T7Zskycb4M8S7PDJwcZ5coKWER2Y4OjcNox8a4ValwY6x+kD5m5x0Uomfbd5r+O1OhR92nNHPo6Y6nbpBINRw7RyT2sbiUlJFzUFAYE8lNeIVR/m+28em8El1pxk/EkMk35lsOD7xxl6xUXVzMGAif5Kjce+3kLJwNtTsHMJgfLKsAKCu44G/qd4tCrYBkBNCkkR5tSzsefHHK2ZckKeDbruWrVB+iOjrovA+B5BvdducC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/23/2026 9:41 AM, Baolin Wang wrote:
> This reverts commit 5a90c155defa684f3a21f68c3f8e40c056e6114c.
> 
> Currently, when shmem mounts are initialized, they only use 'sbinfo->huge' to
> determine whether the shmem mount supports large folios. However, for anonymous
> shmem, whether it supports large folios can be dynamically configured via sysfs
> interfaces, so setting or not setting mapping_set_large_folios() during initialization
> cannot accurately reflect whether anonymous shmem actually supports large folios,
> which has already caused some confusion[1].
> 
> Moreover, for tmpfs mounts, relying on 'sbinfo->huge' cannot keep the mapping_set_large_folios()
> setting consistent across all mappings in the entire tmpfs mount. In other words,
> under the same tmpfs mount, after remount, we might end up with some mappings
> supporting large folios (calling mapping_set_large_folios()) while others don't.
> 
> After some investigation, I found that the write performance regression addressed
> by commit 5a90c155defa has already been fixed by the following commit 665575cff098b
> ("filemap: move prefaulting out of hot write path"). See the following test data:
> 
> Base:
> dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.2 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.2 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.1 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.0 GB/s )
> dd if=/dev/zero of=/mnt/tmpfs/test bs=3000K count=1398 (3.0 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)
> 
> Base + revert 5a90c155defa:
> dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.3 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.3 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.2 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.1 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/testbs=3000K count=1398 (3.0 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)
> 
> The data is basically consistent with minor fluctuation noise. So we can now
> safely revert commit 5a90c155defa to set mapping_set_large_folios() for all
> shmem mounts unconditionally.


> 
> [1] https://lore.kernel.org/all/ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Note: for more investigation and test data, see:
> https://lore.kernel.org/all/116df9f9-4db7-40d4-a4a4-30a87c0feffa@linux.alibaba.com/
> Thanks Kefeng for confirming the performance issue.

LGTM， Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>

> ---
>   mm/shmem.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 4ecefe02881d..dafbea53b22d 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3087,10 +3087,7 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
>   	cache_no_acl(inode);
>   	if (sbinfo->noswap)
>   		mapping_set_unevictable(inode->i_mapping);
> -
> -	/* Don't consider 'deny' for emergencies and 'force' for testing */
> -	if (sbinfo->huge)
> -		mapping_set_large_folios(inode->i_mapping);
> +	mapping_set_large_folios(inode->i_mapping);
>   
>   	switch (mode & S_IFMT) {
>   	default:


