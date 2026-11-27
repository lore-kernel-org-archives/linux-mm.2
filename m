Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308EF606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 03:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Hn0vhtFS
Received: by kanga.kvack.org (Postfix)
	id 528E96B05B2; Thu, 26 Nov 2026 22:39:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DAE86B05B3; Thu, 26 Nov 2026 22:39:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0E16B05B4; Thu, 26 Nov 2026 22:39:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA2E86B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 22:39:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 48A561A01AD
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:39:33 +0000 (UTC)
X-FDA: 85479494226.06.BF7EA82
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf24.hostedemail.com (Postfix) with ESMTP id 23BAC180005
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:39:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Hn0vhtFS;
	spf=pass (imf24.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795750771;
	b=YxxlyC+mU73AfxnLm5zV9hqeUbLdqEV6MlWP1or0ZU0el2AdcgtotdLu3K24ECpVj8YCeQ
	rhMlBHiBz8Hi0jj5bbsDl1sN3bR+BEyOHa+EadL5Fxnx0sF/CiCUG2SZvONqn8iCnDIpAE
	qFxst/oa3vDga/k+LooJuYoBQ4atSRI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795750771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHm+FzKE36SnVI1ZswFKXcG12/LjELz3/7Uez7uAtfw=;
	b=fvJSXgAwUqsW78ci82/gMaHMXaev9OXaRJw+flI1/AtmDcy4Mns8BbmTp3/P9J34rzIjHf
	LjD/U0m2A0kL6Ip8XMP2UD4R1qfo/4+Q/40VlGNEZHXD9sxZnr+sXi3kcl3NrgQHOzTpui
	wu8nSdx1q8Z8i68rUTZqqHyjazrbkvA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Hn0vhtFS;
	spf=pass (imf24.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IHm+FzKE36SnVI1ZswFKXcG12/LjELz3/7Uez7uAtfw=;
	b=Hn0vhtFSl58AK7IVHA/YiEIzohLqbCLCGUmSwjcbzQy2l2GmeVkpwjZIyIAR4RzvvNyUb3BWB
	Gc+l5mOP5/i2dfAGiSxUkFrHLW25kC2TE/l9+bZ/MaPNKH0ZtFnZBMes/LQRuyrebWgfrhZbUxu
	+LCKQ/Kw8BIhUy0nwOjinzU=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4jbK0B5kz2z1prMP;
	Fri, 27 Nov 2026 11:39:06 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id D12D540575;
	Fri, 27 Nov 2026 11:39:24 +0800 (CST)
Received: from [10.173.98.163] (10.173.98.163) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 27 Nov 2026 11:39:23 +0800
Subject: Re: [PATCH v2] mm/memory_hotplug: don't offline a hwpoisoned page
 still in the page cache
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>, "David Hildenbrand (Arm)"
	<david@kernel.org>
CC: Mani Tofigh <mt4022@columbia.edu>, Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Vlastimil Babka <vbabka@kernel.org>, Gregory Price
	<gourry@gourry.net>, <linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <tz2294@columbia.edu>,
	<stable@vger.kernel.org>
References: <20261105-memhp-hwpoison-pagecache-v2-1-029d35634d42@columbia.edu>
 <d4812513-6cfb-4865-8636-b83dd92c23a0@kernel.org>
 <2e11ba52-b5c6-463e-a5ea-c165ba935704@columbia.edu>
 <89037847-8875-4d8b-a8f3-d77a59aaddea@kernel.org>
 <awf6RghUETgb41pr@localhost.localdomain>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <0b947b66-81d8-e921-ec57-76bad1ae1202@huawei.com>
Date: Fri, 27 Nov 2026 11:39:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <awf6RghUETgb41pr@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspam-User:
X-Rspamd-Queue-Id: 23BAC180005
X-Stat-Signature: jua8wusw648zzq8sxc9in6iri9c38c1e
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795750770-60251
X-HE-Meta: U2FsdGVkX191Fjy5dEvZnkH0MEQh+dnAXa2nW9YSIVTGRWOmyDf/i2Np8QMdrECjkEtp5MjbND4DW0o+B4jNhdDx5uLo2X0C8xSz8dXYNTamcj/+pE7w5zP0IgYolVqIDxaRa9Z/TXzN/dVYJzJ5Mchy8wfFpw52E+58wDWkMfb4AT0QI6FGG+ps/X34FcnFU/ofOOkyEKs3bozfHupB8Syu4K6p2712cpqeDwt0asYujwlWbtB4c+DZEejvGJQNrSxykfMUwSmtGJgoaRYgT5k8ErycXYxINVb7HwaKV5QPAooP0SC4JYwZEU+xyx+eLzkIzTB9d2zALseg6YODXXmsHTdn8z12GCVxQq3Fkr7jpPzvpZm0ooZll5n40/BAMngp7qmaP74jnA/T+7PgkuD9ZYl6CT4ka3ylfuaJMeTqJ1rWhAfCnitljIDxmDyu5EIvj8EB112VuRE6y1oiEGJDU167d/XKVvvolKHDCsHil+YPdC9xA5ZGuVThzCBqkq+Vn6mWjK5M9uXz0DG8aTt+mUxFGzIx8VBE2N8PElwOBegBP/1esJpjh/JldT++C5mXbzXtj94CjgmbQ1+fedBCA9gVJNUqYSey1XwW1l5P+Spqnl/MogEZFIOCGdDBjmh+KmvoH/ZjXYpCvX/bumiynFjjEAPAmNbHDE12rUhjFX13NiC+Rxe1zUfn2FULT6TVfzHLl+aVi2INVLVTdX4Tul8vpzobWnAnnIppBxPECkvAhhuEEh75W0ylclziH3Q3Gg5zk5UdGKa2zZ/WxBGpbecGD4SXNzdeLxlvXyHibQ3H5NNl3MeQHmWZPEjAOXXO4TBTPa1xuS5hVcmfnPFsVPfsnv+/iKQh0WAw2prb3Uw7D14ex5s3jgbXo36T/H4iWonseT8xqusnEhie6cRJCcmp4Fx3EfqlnMJMSjNd1uzZQVWlBJjUUYo+PZxm6dZvTrW83SK8giA2ZG2
 E8hawfR9
 mbAvOaSd6oKN7jjKSNKOcRGFlyLnZMxtoXxuew+lf5GL2TZ0VLas95pIBUsGx/cr/8RpevrNHabVAM/BZ3KsQR09BK1myhfiL36nREKAFXvyFGjzzqmWXwllNDTnDE4jhANyirivP/9g4+FZYRrFfDZFLcIEIvp0AVYwroN78Dinp3x89DCc+RoHE1hVf0Gk9/eKw1omlIDVSK8/hKYnDcMqjuONK4p/y1wn+KdBmKznrnjV9YYOjeH4wkeo9JKBp6MrA4OluUBOKWQtA5VmldRoHbEyl7E8IS0q7SGo4KvMCjVLZnB6OqKiQatPGSaj/yqg1ywGPgoT+GhsC2olYj7tuoAQ7kBsX+eSGSqMOiPDy36UgtxGXbL+na+R5GX7qQmUZWagljvU4BF+9PkTB3x9nsnTV7wV88Rjy882QrlPcqD9g2MYIoYOvfDx6YJcpVszNHN/9XRagLwSVPCKtDZ2ymIl5pm/TcvTuIpbLYcXkV9L9H1qVLLaQ9Ov4uDOUPCGzWx2gJVv0H2eABCzyHpW8lEO2DdtOhh6hoXAZafcaiNErmoDx0ZCe8QzdtnUBmsB7PhLrP2RfecvE/5eOtalvvsbBwauHA1vP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/26 17:22, Oscar Salvador (SUSE) wrote:
> On Mon, Nov 23, 2026 at 08:45:37PM +0100, David Hildenbrand (Arm) wrote:
>> We'll have to find a way to make that reliable. Everything else is just hacking
>> around it.
>>
>> Why can we block concurrent offlining through get_online_mems/put_online_mems?

I once tried to fix the race between memory_failure and memory offlining [1],
but ultimately failed.

>> But I hate these functions.
>>
>> Or alternatively (better?), have a memory notifier that block concurrent
>> memory_failure() by grabbing the mf_mutex when MEM_GOING_OFFLINE and releasing
>> it when MEM_CANCEL_OFFLINE/MEM_OFFLINE.
> 
> I think this is the way to go.
> memory-failure is a shaky operation and over the years we have seen how challenging
> was to interact with other parts of the kernel without crashing.

I'd also prefer making memory_failure() and memory offlining mutually
exclusive instead of adding more ad-hoc synchronization or spreading
get_online_mems()/put_online_mems() into another path.

> 
> IMHO, we can try to be clever and try to workaround those issues
> (memhotplug vs memfailure) or just make the two exclusive.
> 
> @Miaohe: Thoughts?

We've already run into quite a few race conditions, and there will likely be
more in the future. memory_failure and memory offlining happen very infrequently,
so it's not really worth adding all sorts of code just for them. Therefore, I feel
that making the two mutually exclusive is a better, more permanent fix.

[1] https://lore.kernel.org/all/20220226094034.23938-1-linmiaohe@huawei.com/

Thanks.
.

