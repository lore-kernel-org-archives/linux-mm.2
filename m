Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D38CFF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 10:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F33836B0088; Wed, 29 Apr 2026 06:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0B0D6B008A; Wed, 29 Apr 2026 06:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20AB6B008C; Wed, 29 Apr 2026 06:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D48C06B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:01:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0EFAD1BB8A7
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:39:27 +0000 (UTC)
X-FDA: 84711095574.03.B1D04BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4B9D81C0012
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:39:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="loXD/LAk";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777455565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jV37fnUY1F/0CH8IWXSF3ZoqRdt89Tn4Eobn+EgB+BI=;
	b=1xIR4oTAgtvUCaX+/6UyzmwhdS/vpNm1PzcalRQQ+gAq09wqZT3kkRDEDjV7/7C1IowERi
	uGRI+Jd7YU6ZGfE0p0sOdRvsX6F1Cr/kXEHAhZO+Yo6MU60+nyO9UbRD7lJ9Mse5iazoUO
	w/r6LOavzfzPF3EGZRYYxBarguUjA5o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777455565; a=rsa-sha256;
	cv=none;
	b=hM/Pje969pGOTabwlq+lHQ2yxBvCqwpNTcC4xnuIn+CiUKJgqSFiOJw9vdWJHm94kBkfV8
	lgquJLcuGEeVMgQUTNZ9WBCApK55oHAA71VAHYxjL1OJKnc+3o/Y+5BzCMChsNTIfTkAJ8
	HoPObqqZ7FHreH/hMwcXikVx2EgVbqQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="loXD/LAk";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A964060139;
	Wed, 29 Apr 2026 09:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CDDC2BCB3;
	Wed, 29 Apr 2026 09:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777455564;
	bh=66fFrly8kPdZfVWImwjO4XAExc1kJnamL1b/TCdS+L8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=loXD/LAkpPNZMilT1kMYqKWAyh8xNZ5R4JxY1AG0XfFsCpz58u9ei0MuzrtHyWTDs
	 WpweOeJ1aKqiu4NzrQauA7gtt/4VfdfH7+ZE0ClDpkg1i+nVWYiaQ0dfysjpqV9pso
	 TzlWCRfBGl3/dSu4CbCLyfRnwIt+vGPOLOvbg6RQ9tnbnSUXsv0Now34SSHxe7VKrt
	 xpYnkCk6Qwienb/SFwRi3qI81v1DWlmIwIKnl46G7KQHvDrMeUbxllnUB/y5ILUVAj
	 wln1rDPD0AR04foLuYf9BCJqttcPELvA0gayDwC3ZrSwguep2abhSqwohYIYiwQYup
	 y99O8gZpG13qA==
Message-ID: <76d06c0a-fe5c-4d61-a091-919db2ace4a1@kernel.org>
Date: Wed, 29 Apr 2026 11:39:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] drivers/base/memory: fix memory block reference
 leak in poison accounting
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich
 <dakr@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
 Ying Huang <huang.ying.caritas@gmail.com>, Dan Williams <djbw@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, muchun.song@linux.dev
References: <20260428085219.1316047-1-songmuchun@bytedance.com>
 <20260428085219.1316047-3-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260428085219.1316047-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4B9D81C0012
X-Stat-Signature: wag3gf37e4onttxgug393c8ng4jr571g
X-Rspam-User: 
X-HE-Tag: 1777455565-304671
X-HE-Meta: U2FsdGVkX1+X8c86UifFNEynfSnm+ifNQDaspv6wCNF5avc4ORoFHQVYUwHhpgdhobR+MR5KQXuTM+D5MXBr3zxvmjKRrIqEseMk8No5p7dcoodvT3VvPOXfvLOJFOS9u6XZ2doTqke8zXiLr7+Aofhb1AClYHEAYVgr5J+tKYu3VH5oKYQiGMCLnN1oNlhwREABTrLWY0/+WT3u3iUqh6g5AQXZ94p6VkLK6kuQ1+s3RxKsma6BuQ/X5NZr70HEreV+UggNE0H9ImoylbWhgceMXP4ZpwyENFITgi/ft2HcwYpXkn+6OOblTWU9ANFJw8/cn81rc09olPZ9SCod+j8tMCnYIpzu0BECzCgrTkO9P3FzY9MCPgP3oJbdZsorhyMuoScnOrtZdgfshTCp9+ud9WoXoPep+bPxyv92pt5X6KFzvB1wFP1ckh8bIjjx2X0iLOON1O8Vgdd4OhyUsr65s0b8fDNroMGaK2eEgO42SSA9PQEUHN+XIKWXSHFiLSM47JgVAGo/fuxCF9IEf59Ti3eW4Tkc43eJxban6zGRP9oUTE6pjdMcrU7V8JFUpOO/Ro/rLEyFKP9H4vJi3VRAz3fKYTlCrk64Ikydx0wxqjMBgMPqFavymAz5GLBFppIpmCM4lEiLzA8O2303cmCNwwqy0UeLPHRWc+kjfflwJl5d9TEXTH2ValZXpcMLAE0eDONlMc7ANs0g4bTReCJtm88h6/UpC8gWMRWXH1DXDGCJayhyNd8MoCBBzX1BId01IhxWnD8aSJH4lmoy+O3JNfrb+txhNOvEi/r+Zg8enCrtPEG0/ZuABaOFSM1pqSVc7fPsTG2JoZo5h1gq4Mf3vOowSNWvAKJB3jfw067N1JWs6ssemcJzHNlwiNjkO+gOwuQJgXcr8MEZXp1zh9BRmBadj5TC5nT0PD3Bpi7TfkTzziKTjOB8pylWKr1swosvaRPPduomG+55e0d
 oV7tZQVV
 Er1aDa47EN8rdJIesFfMI3qTUpuuTJxKOZLDOIMmUg/tZCazuh8RCRF6g7/gzyPiXbs5LeOXjgu0zJZkFSMqVGOKqoOdOEtt41k4RIMXeqC4S5LVjSZkMFocib2txlbvUuL9GuY4FAzClw+QcJVa4ROBp9JGVLUBLzZfE2/5UCd6ckLlALdkQm26CqxIJeO6XbvEYvUA6/2kIbdjcOT+9GJKJXhQxTvXddDQ5ATKtSUvMqIsOWL30Xm4Dyn+NKL3bH5H57CQ4z31ye97WZ4espGuGhvreLJF01IM84UsJWdJBciJvCH1zgADujpOYlmfiYfU1Ubp1YiB3HOa8dC259DoG72BHRuHJMxqJuZNSZYiwGS7BWsF7CEm5btQxoqd3fhB1XrX3vzvTr8xTHRTVxSm6jA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 10:52, Muchun Song wrote:
> memblk_nr_poison_inc() and memblk_nr_poison_sub() look up a memory
> block via find_memory_block_by_id(), which acquires a reference to the
> memory block device.
> 
> Both helpers use the returned memory block without dropping that
> reference, leaking the device reference on each successful lookup. Drop
> the reference after updating nr_hwpoison.
> 
> Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block hwpoison counter")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

