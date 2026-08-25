Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 593F7C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E70E6B00A7; Tue, 25 Aug 2026 09:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 697B86B00A9; Tue, 25 Aug 2026 09:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5615C6B00AA; Tue, 25 Aug 2026 09:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7136B00A7
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:17:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABC0AA03BA
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:17:02 +0000 (UTC)
X-FDA: 85139842284.05.6F3D40A
Received: from mta1.migadu.com (out-66.mta1.migadu.com [95.215.58.66])
	by imf15.hostedemail.com (Postfix) with ESMTP id 83F9FA0003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:17:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WQS9mML4;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.66 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787663820;
	b=EyDmKEJm7dMTWVpz1uF5a7GiArHTdW1ks+EQAbwlumd3rVjkEvwvBPWQqtKrdFkvXq6dX4
	6y6UDjskajXZ59C++PAIuTkJ0p8tT7uqSlvq8fFtBFIPGQCCLShwJmHKDQqOR7MUdc/QOm
	XIAEH5Q2iTcnUaIa2NJd9TYhJelyd9I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WQS9mML4;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.66 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787663820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OUQ8V9PANReqOQcZokL5MYA+ZSGxasaDqmrBryzKEKI=;
	b=fkSshZwQ375O2o6dszVHDRPCamGp1nDHUEF/8lxDdf9i0PyoJ7J0D5PJQOhF/o/0C8B5+x
	hsAmcfnHpsbWtKQAdLG/Lm6FA0RFGMy95fdw58BNt/93LmgurBawbZJv5AZ8C2qaRIM5DH
	lblMysW0HnD6p24Tw45KAyPK8XABnCw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GZQP6l1qj64LVLY5RzENLejQmGGjaOZhrqU0YqVM6yk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787663819; v=1; x=1788268619;
 b=WQS9mML4MxYQ7UFNQ0ImognRfEHIULzcaqzD6v/8dzXJChyLCFKXsrjFTzbbcUnJmtxHRxQj
 G0IEVgsHxXDAqKxYnpnyHMtXONJeVMcvfuwsIjCkbTEkg6w08IGH5TdEKf47U6Rm5qritJZt24j
 dbp6h8lSbU+Z8xvrzWzBqvbs=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.254.116.35] (101.126.56.83)
	by smtp.migadu.com with ESMTPS id c5349879d9be2350;
	Tue, 25 Aug 2026 13:16:59 +0000
X-Mizu-Trace-ID: c5349879d9be2350
X-Migadu-Flow: FLOW_OUT
Message-ID: <0fa919e3-f4c8-49dd-981e-82ae92056d92@linux.dev>
Date: Tue, 25 Aug 2026 21:16:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/17] mm/sparse-vmemmap: remove
 SPARSEMEM_VMEMMAP_PREINIT support
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-12-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260825084608.47437-12-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 83F9FA0003
X-Stat-Signature: szqg8c4f54sbhohqouibkbxwo51uipwk
X-HE-Tag: 1787663820-962233
X-HE-Meta: U2FsdGVkX1/b82ygcSFceqy8vqOLoe75gWVR0nZ/jwZ9mPlDzlXvbfzVfg/VbafiPsyW8XgY02nKglt6bz659dNfXC3RJBkabzhaVMJnQmV7NB60Jh7G131rxBZtT49tCgEpBchf3JALB5+WiQA+hKMe9deS5Prg4ZkRQA1HjEzEDgY970sEGZ/4H5FwQazbUtPt/01eCSti/YbFTFqlCe6hTauB4NuIVI+nWX0njW8s6w7Rbq8NtO+xxYMuSq6A097KNNTyNDEzf/6c0QIMc1J/T7J8psGy3HHm0OTGEXBNayuiE58m+wGSkRJ2RrjxMVC1dRospVRMxVfGtRM4HP8CKBJb09p7NAotZdm0zjRHsD9z7Km2OPPkp/AIUwVjKqxiVP66T61EtZIHmrVKEsslFKmfPODqyAtA9BcG9eA6vIC8SBL1x0zTdqowN74PM2Jl1pbNBe6PliK3LfxcisJFtui2TVNxtTDtMJk9AdO0aSlVACOfyPSWmpJIDn7u6QdgUJEJ3TVbdwnqqjnJu+WKq4yTX/6NOoklcgjM09YKOQA2rTdq/snE9bGXE/KyDdEYFh0buxET6iNdWhH/xGyK7XDiBZMYKAXKC/4TcTmfZwf+VMkTHX8ymvTYx/1KS5NXvlgc/cH8YlWGd3CG78wPI+ygROyRHGyhz7ufnQeUy16g5GsIurcilWQDg60b7VS3QyRFFOFwYXvYsZwwanyGMwx8sm9q48+axT9VFA5HiEsgmIUAm6FN8osmcmUMWwEdNKsoLAoBsiTAn5r4U9f+yqltWWMTHX+H6rUBUzgPk+SeaYfxh/Igxy9j8Xfl5nRUOwxcxmMkAn428D7H/q749w9xqcS/oNIkm2EXRyRnjT/vV1dagZt+SEM718pnco0K6JckRi6lAsrMhAgmN2Otsj0jnbsT+y4jmMQUGzs32A1sepcYkAL9IXnMntkHCQIqZiKEvN/NkzfqsM6
 fw7aFKgA
 RfSN4Lot+gXSFFgbUkJKXjay5ijJOWVpBiDm260GE7a7N5TbR1cggxUtMvOwSWcktE5PmDFoX7Z/Z/DjUpFOIMCmcXEHbfd5A+TQK7uL7ejm6EeCN0XvlLWfIgh+Lr45tE+1eUeCRcATR79u871+kfA370N9LbibXxjpXd+HjhrXYYyFSHTaiWQBrw7i6n1tB2UOS11msjjU2YikSvzpFiO1oXnBK4sCELQP136aNk7si/jsYmXeU8dl0UGPGvwFKi51Tib+iqIBINuNkR6+iHTULsefqXhJf94r8lel18AIoAafrOUkpfUH8i0qm3hCcfWNgPJsQKvkwXzuMUB/prpkA2YAn3Zv3T970v90ULFDN2gd8scyqU+NZdVwhyhN0vL0jorDusTX28n7wrT/KLHVO4honbFYunlrIfp9UOcptwWEYo3RbVSO6oXg8dJkvyrWg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/25/26 4:46 PM, Muchun Song wrote:
> SPARSEMEM_VMEMMAP_PREINIT existed only to support HugeTLB's early
> vmemmap optimization setup.
> 
> Now that HugeTLB bootmem vmemmap optimization uses the common
> section-based sparse-vmemmap path, the sparse initialization code no
> longer needs a separate pre-initialization mechanism for vmemmap
> population.
> 
> Remove the related Kconfig symbols, section flag, and empty early hook,
> so present sections always go through the normal sparse setup path.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


