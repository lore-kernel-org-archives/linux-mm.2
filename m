Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20D8FCD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 17:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 863DB6B008A; Mon, 25 May 2026 13:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83AAC6B008C; Mon, 25 May 2026 13:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777686B0093; Mon, 25 May 2026 13:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FDB96B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:12:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27970140146
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:12:03 +0000 (UTC)
X-FDA: 84806584926.04.6AFC6C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8EC6720002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:12:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c0GkC8JB;
	spf=pass (imf31.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779729121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lppuGztfV3VAd9Pwvb8KD32Y3Ykhpo6lzmvPRGEXMHo=;
	b=wKHScx0gDZ4e8zOUSj3HdBHq9SB2VyFR7jJPJshtBMGc9cGprsDAOv6LVaS5//LP29jYhf
	TzyHTcYJvt5HTgq0kYqAg7hkbMx6MJ+PLPH8dbq7O37sCLkV7upXNOARYpaJGEV2EVjnI6
	pXtvn6atOK3wRkCqqb2l1+onhaX5Suw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c0GkC8JB;
	spf=pass (imf31.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779729121; a=rsa-sha256;
	cv=none;
	b=L6+V5Tk3NEo7TSjn8jSBg1JpbqznDV145Y5JfZKfzcbrJhaWXe8lgFDo9cLw21c9y6pIYG
	Ao3Id7uNXsqJRAX0LjfqroRFhzgpkwh7QY4jKOELvZGylu+fLHST2c0A2zCjMz72iLbZPL
	wWXrEBRUIcApnSJ9/RwW0vTI85+t3gk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 123296008A;
	Mon, 25 May 2026 17:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1941F000E9;
	Mon, 25 May 2026 17:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779729120;
	bh=lppuGztfV3VAd9Pwvb8KD32Y3Ykhpo6lzmvPRGEXMHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c0GkC8JBi6s+kPHIrR7x5eWxzlrBWPbVN7JRD3kvVG0gzNUV7Ut9TkT0Vs51PyYTK
	 wOXSbJ8Rs2W1si5bDo37166aK3LgCK2zLuyOB48h2NzF4pPSfV0L6++kYqQTiGDfMi
	 9iU/inQrR+aoScNEW/B8QYe5oyPB8FdJtp1abpsDjMe3Sug4cUQRHJpKWIGFrZHOZQ
	 bNNctxCvB049dg4NCUGmds1f23o4Q5gdmQl2EAmTeeOsGpMEYcZammGoDUSdKQzZZL
	 hiE7o3quPtwsL8DwdU0NekrjkJTKao3aEhAtCQvNiye0I3BdsrP665kw7Aw8t2ZsHW
	 seF0mOUytk/QQ==
Date: Mon, 25 May 2026 19:11:52 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/69] mm/sparse: Move sparse_vmemmap_init_nid_late()
 into sparse_init_nid()
Message-ID: <ahSC2M1VZOtjDVvW@localhost.localdomain>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-12-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513130542.35604-12-songmuchun@bytedance.com>
X-Stat-Signature: if3ycgx6aiz83r653zuotyb4y98k919f
X-Rspamd-Queue-Id: 8EC6720002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779729121-960380
X-HE-Meta: U2FsdGVkX19XpVmRrKOaHMv6yylR8Wm8Waf2Xx5P0oroQuZ/fXGLsYwW2eua6LD8B3nBiXRi8vcPE7BIeUD+sAuq8cGpKlfyPHsaz6CvOOT+27+IMxGhR5eicIuc8bWu6NbGDh0BZX059kq/g6sJOeIAaz0N5bt36LnLI06Lp6/IoNO4RgH6FEVHVtIvv5Yup7Cu5F/PlnfijixFlv1c4adHi5eaQfcfJz+n6XQsLceYkc1gpNTXjhXdDQ0ySyG+8mtx4VBXplh25KVFqQwZRhw9r9rjp4omGYpjeDANbd5XDt9XzV5AmV3c5NgkfbimkOVwmMx7pHckNUBYzv8wdTy1k0PYR5CPTVemZsoRBwKcbewmIAKClrnG9N5UKLZBpTLqYwgpm6ENsAp5ZN0teyGtsuGsmWK+DnwZWl2IZ1qArGEsQo+bVevbIqs5gcKfwDg9WdQWBjTVDQGwaQWSN1ZcBagPZVjs13VZB9tPeR6pqDWR+4fCKlakVei28B+S1enoQ275Q4Y7+A8cSQjP0rZ339u39/Bq0lowSHSO0fr69rKqJPER6AyrbP7ifnH0XUH76oGhNr9ibUaakvE3dbM20k3UjP+Ujsk2kzTdGjuRLOD52/6c+5R6F1TvQHoU75wsXI2VY5RdsaZ85K8Wryq2Zj+5jgTYguO8jN7LyavcuW085NV+MNxXOWdhSY/d+MOgP2d72KxYm4qiyui7S3ZpT7aaUKx6GFVi5Iv05UiZLaX+xMCyd904rF81o59Ip59+rEC4vYczqH1USZxjM5mO9VP25WnWKUroa3UWIZeC7ZsfuxS7kqeRfVpkMmMZSu/ULuwBiSqyg4doaEW82ZDgAWzfKjBSAD0rrB7Z5kMKI5Ww7UzsnSc1J65IrWOjWushQ7y3KDebD74qzkGQ972xZ4TCHbFYbNqlE01hn9pft+qOHlrAbyyTFyR72UUiyT3rBkVPmmCYRM7QAoX
 9Qxz5nlN
 /sSl9l/1k0HvTddjvkSSPJxMPUwI0+Ywu7+ddrMxgtuuMtZlGK3U20KcqxAZmMjS+DpjLeKuAZiDH40A0SueXdyDbi42kMmTIv5s8l7UUUtwQZA2r39PUR4oD9CFET6mbSQ9/0VA/BO3cK1GQVsN6G2TMFaXnW1/kmxJPaaji/Id1DT09rDWE3onbDOxIqEdIl+e7uTV4Ir8vV7GMHmeYipeJ2kCjvo2UNwjb24w+h8SgsBp0Dmixg6L1mElrXg2R4myjUv35x7CL7dVHiGB+BzllaaKvy87WrT3ENhW87L1VcKkDyQeoyri5Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:04:39PM +0800, Muchun Song wrote:
> sparse_vmemmap_init_nid_late() is still called separately from
> mm_core_init_early(), away from the rest of the sparse initialization
> path.
> 
> Now that sparse_init() runs after zone initialization, call
> sparse_vmemmap_init_nid_late() from sparse_init_nid() instead. This
> keeps both sparse_vmemmap_init_nid_early() and
> sparse_vmemmap_init_nid_late() in the sparse setup path.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

