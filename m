Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 215ECF419B6
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 13:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7474C6B0088; Wed, 15 Apr 2026 09:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8256B0089; Wed, 15 Apr 2026 09:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60DC96B008C; Wed, 15 Apr 2026 09:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 533496B0088
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:34:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C90AA58C83
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:33:59 +0000 (UTC)
X-FDA: 84660883398.09.5CEFD0E
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8641B1A0013
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:33:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of stepanov.anatoly@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=stepanov.anatoly@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776260038; a=rsa-sha256;
	cv=none;
	b=6h/qYWI2sehIuCJfzhLy3ANdx0YpnENLcolX4W80Oln2JyprxHcqqguShwoX7zgviZvi8a
	GiaEcRDwYRS03HXyJN1ssCVB9sItnGAD+9S3fREa8jlA92MK1mLNfFYfhqIDOkvcD2UmLI
	KVJ6eg2OseWL0np805xGDOL4D1E6Kas=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of stepanov.anatoly@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=stepanov.anatoly@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776260038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YWzi8YjwqgugqT4HM35QV+agzWZ+MAWoKLWaJ6h8Nas=;
	b=p2X4UNoAxK/uHRIBrp6gOb0peSREnS//JWZlC8udhWetAkQlOvlAJ7Ex6WW/FJk+/cxPUp
	+VjnaHua3zcDFlDBpczZOp9dVOt0P6f01+zCtLgXAyhGzWlpTfvMsrvuPiiMYEjFahUGDr
	vAYhckfE9inWDOiMuJCb3ADdIgTai8g=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fwhtP2rLzzHnGk5;
	Wed, 15 Apr 2026 21:33:33 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 81D204057A;
	Wed, 15 Apr 2026 21:33:49 +0800 (CST)
Received: from [10.123.123.226] (10.123.123.226) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Apr 2026 16:33:48 +0300
Message-ID: <972b8365-60cf-4f29-ac4d-05e6c50f573c@huawei.com>
Date: Wed, 15 Apr 2026 16:33:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] Use high-order folios in mmap sync RA
To: Matthew Wilcox <willy@infradead.org>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <artem.kuzin@huawei.com>,
	<gutierrez.asier@huawei-partners.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <20260415192853.3470423-1-stepanov.anatoly@huawei.com>
 <ad-QQwctxvJVHW4U@casper.infradead.org>
Content-Language: en-US
From: Stepanov Anatoly <stepanov.anatoly@huawei.com>
In-Reply-To: <ad-QQwctxvJVHW4U@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.226]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8641B1A0013
X-Stat-Signature: ojmaapgn5md8my6r4g8nmigx84im78ff
X-HE-Tag: 1776260036-73202
X-HE-Meta: U2FsdGVkX18AR2m4BUC7WO3yXP7Bo+K4lJUqNzIHo17NSzgsQJ1d03mw8ZsrRCB2eL/uyRO0ZZAUn7oRUER6zL9+KLs3ynI27tIXxtLQi4Fo88oYgrjkCG0FR09OudKWsEUI0LpHTs23KpdOM3TAETC34FzkIlvg4KEIdl6gBtmXlhhNec1ldb/JDXoStvj7aWTCgleCRGiIYdNcZ6uZNISwZrASIqCJroV4XYkfpb4L1d67wgN2fdDo3whIAsNj+mz1hrXu8YgYgr9H2BbLAyYWmcwwpTIFxXZdi34PHi8snsBfVhus0VsOudk5NHRadkYs20JDdrS+1Xgy2fKy/UFUrwxIcXSTgyicmJEPoWlPH829IK+5wXnbOqnvqHY2jCueMI6zwJ3ZcfaL9Ud8L0yIlofQbPjYV/NmMzfGEIGP9fZ8CT1MVur8d9GYoKvTURQgwWX1Q2iNbApXwIPewnZ56dwBTKXDceu8G/PsWnoc2SCLczvQQmxtI8GfcCt1hc6m03hNFlaWTC62hsEKuMlxF+g5jHD5AFCGOI+QD7GYYrC+fA6DbmkTPEOZVg7CgfvAAMmijM3PGyGzEoZq+cFrcrBbhmpY3sqV9YwaZdj8FUuVIaMcLksANOrgvBH5n7EugX9TfFCpZbAuEgfnTTnR/K8ubToWhz7aOvAQp9hmlDDQotDvfEkQrFdhHk8B6/Zcduvsl9pKv+R+NrfbfTx3PpIizKyN8h/ry7mmbTO4ikPAsSPCm7ZlOXHVD276uYh+JiYeUBIt3pMjHA7aLlh/P33WnEpjNDh+NoE0M2kDlzDCQ7SHIF/0L8Wiz1l2cU1dq8jAb0u9IJe3MleUqY7SbroE/1OIeCioYPGu18xczxj9XDi0NwozX2kwrs3Ek8KSecreHc9ClSX2X99H2tvkKawf4AD7SOY9bgqzT60y404b0JDkmFqU+oNYMxUPre/ZphFFHjZ+4Z6ZtQN
 0UYJiPgJ
 w2TiJDKmfY5n6gPEiGDHYvloGvkdbAuauUoOhDCOV+r0JZMnAo9WBnoRpIPyiw7G7NEB8Z2quEhBDXGy7LDCrbnYsisp5h8ZXK3HvFAHoK64s9uSeK/Kdrq9CsSfYAoa0k+Ss1yu9XTUABbiq6BIwi1mDfyDVqcN86Bx7WX+6065CPcuD/fJF1ZSsvJ2GcIOVrk9aNrLubrg7mo/ynkZswn0RGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/2026 4:18 PM, Matthew Wilcox wrote:
> On Thu, Apr 16, 2026 at 03:28:51AM +0800, Anatoly Stepanov wrote:
>> When "fault around" is enabled, 0-order folios might significantly
>> slowdown filemap_map_pages().
> 
> There's a lot of "might" in this patchset.  I'd like to know that there
> is a real workload that benefits from this, and if so by how much.
> 
Actually, no real workload at the moment.
The intention is to highlight the filemap_map_pages issue,
i found it during my experiments with the page cache.

> You raise an interesting point that faultaround may be slow, and maybe
> we should start out with 0 faultaround until we've determined (somehow)
> that faultaround would be beneficial for this particular mapping.  Like
> we adjust the readahead window.
> 
Sounds nice, 
looks like, there should be kind of "virtual readahead" or smth like this.

BTW, for the benchmark i posted, if fault_around is disabled (4K)
then the throughput is even higher.


>> For example when async RA won't be able to start,
>> we might end up with a large mmap'ed file with 0-orders.
> 
> That is a feature, not a bug.  If access is random, then we don't want
> to do any async readahead because we don't know where the next access
> will be.  We just end up occupying large chunks of memory with
> never-used data.
> 
> 
Yes, i understand the logic behind this, what i mean is that it can actually happen.


-- 
Anatoly Stepanov, Huawei

