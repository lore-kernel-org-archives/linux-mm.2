Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23E24606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YRmX8ub2
Received: by kanga.kvack.org (Postfix)
	id 361A96B05B3; Mon, 23 Nov 2026 04:36:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338C16B05BC; Mon, 23 Nov 2026 04:36:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275EE6B05BD; Mon, 23 Nov 2026 04:36:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BCA66B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:36:51 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 955E5807BB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:36:50 +0000 (UTC)
X-FDA: 85465879380.30.19B455E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 086D240009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:36:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YRmX8ub2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426609;
	b=Z7ClvGgF7lvyISwLm6Jr1dx4SQjxyTh8ap3MkW5vJTRc1+vvcaCJU4VQMhmIDzZa8WThnu
	RBHhacpE9vlbEU6XLktMygtkLlBMTAfyKziPsidxOq3ZVsvp1FR3mFOtCk2M1JEuzrwKlq
	EPc1TWeIqvGYbLdyIaQoMnfxNgMtwuQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TqkCeNdmpN1ojvlqAXaiFOL23olxi6kTQ57V2PF+UJc=;
	b=O+l3RyK2Mhi1jIf5FLAsYmg4FcJBdLLVqtJSbLRgBJkTJCdl/Xiz6gr4U8J9/8dilQVovv
	rex5+A+Gs4T56Qmqapl5tVvU+HUma3M4MHQ3J59NcGj0Y3bhLBhOzRzBB+Lfrn/CuLRkXQ
	SnIituTNAjyY+TiiQlMoNsBISSBrF1I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YRmX8ub2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 509D54414D;
	Mon, 23 Nov 2026 09:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFB31F000C4;
	Mon, 23 Nov 2026 09:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795426607;
	bh=TqkCeNdmpN1ojvlqAXaiFOL23olxi6kTQ57V2PF+UJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YRmX8ub2Pj+TiuqJP4/xsZzUkuw2TrzDCQZjQamdF2NNnCHo9SxWIsliqjcbUhDmV
	 fEeI60qy+Uca+1Ot2mgmeilwWyoIkyxuay06uxV9YP7nx5WnR1RYOpJ6RLBshAAPZ3
	 qfSESm+OZGpD7/sEkp6okDkN76MvkHJEGSS79QyiU2OKu4HIT5r+2oQXOPbLT6Mhmi
	 ubLmI3gPuioj8DmH7r5GsPs63dY+zTGgEE/t2jEVoNX31tLW8vUovvIZiZZEuITbwB
	 A9VMfT4t4a2uzuKUnlto7LFp7QNq2UdDrrUm3RniP2ZNAr62gN9Tl8+Istx4YgW10f
	 pe/O4Dpzt5WWw==
Date: Mon, 23 Nov 2026 10:36:39 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>, Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 08/11] mm/mm_init: make __init_single_page() static
Message-ID: <awQJJ9-V15lLTtEp@localhost.localdomain>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-9-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120100856.16929-9-songmuchun@bytedance.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 086D240009
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: otwpqp61ebddkqt9zrduufx1689nuss1
X-Rspam-User:
X-HE-Tag: 1795426608-744491
X-HE-Meta: U2FsdGVkX1+uXSGDxLPH2YEeBl4HkpC/sfxB4dkdyB4T1JNOf9Bj9s/FgN/8Sj+EUvkiHCFzSDg7A5T00bFtRpf/ZSosAE8DB3LxSeWWY/VNfhtUuuz0Bfb2V7jBHdaM3DRSmyQuK7wDUN3O+EN9YgCtGPc2Ff5oo0cRcF6iHyv8PPpo6KHs/jGSs7ljyWP5U9Y+e3SjbErmJbVkuT1/fXBuX1yXMjD8Y1vTl+34Bf5WPK+3wMhkBuXVqodDTbzRqnMErav9C7qH2mKmK9IQ076eWVMvE5xwxj2fO1UEo6nzElj3S3MKvF+yZqoVI7p0ugMjbaKJ8nwBXxhG5YPS1v0M9fKnSfbwohhqAsaFgN39dHP6y0vDvSymJfTl6Y5UEUObtRivM7rGdZbjVn3EX/mvWo5yp+Ug+RcVn5vzBumrXEmTUNzMl0X4heO9MkygnzbrRH6cQFleHmx78dVz3GqWAHMOrI3bwRn4ZvPBGgvFSs5x+8hMzY2TR6e0SNu0D1yij+jcT2hJuoY483RtsqczGlcNsOiVog5iDr3Z+HtFvH8ua2l4GkqhnCj8NRt8c6l4gOHELwSbqYhPsDiGBYj1W/hHPCTCPiRLZskjRBAsTxv4TRybjSO2pUzO8U4dQVtJEqTNQeB33C+wLaBIi7429Plmsfp1hmpDCNgv81Y3PU6YmnicYG93LVyYLRoZRVYr5StXhO5fGatbrVM7qpGQlbirkeMKEDP6+U6eJ3i5D48IZgvfxqmX8cAJQ03quN66M0nPl+xW+OqoEj5eB0FPfZmp1JkggZ2lott78oiSUaTKe1smoh545c6bNUr80plz2F0uOtx1Jd+EgPmI2arQkQxE+jnkdjtkfspA0fCRZEQxgvqGWjFCIDY7kBE3gbTxfqnED5/CLsxeQ5+jw3N73QFCIEbcRAZTwAS+YPJmt6FVheOnxwOagW/TfaHLGaFhNXKKFOUWV88RhBm
 fF5n92rn
 0i3rMMkUg3XmVBhvoGSbdJLw1trScbo0Vzf7CCx7pIdm3EwRULw7W3MK5DrQ+kyDfPeHSk/+U2AeHWo73KxbwzntCPnKT2Iq4sC3q3NVB1fe6d1VRDPpQsY/J+tkjlFFRoX+WisaHPVIO7Uwwt/EVTPRI4uqz7+gvZBmsUqskGBoFoAKSerP+Fhl+l0Jqw3lraPvc4i9haCtT3UPQSIIhQvxtclMB6l4nQ4krCPbv7Yzus7JQjPiTlvAOIsYnUP4f6/j5030mJrTuqRuZ2G8LGEw2Zj8XLKT+te/oB5RXVoHrPZ3ws/jbJ91v3rVv2mRj+W4swDydpidpHQD3bZoIAKwoSmVSkU+i74BzhqKhMbLnSnEVKiEw/Tjq67uwMLF6+AKxr172+IBwvOYwcouDFpr6pj5MIrVzObxOMXeMfzTF6b76mBUjk4bmsYoF2UpjJpQIUPO7FYo5jEJA1QrOJJQ+UUIQ6SGxbtFd7e0ehJXr+2o+Yy/z9fGd5EgqDyoG7gb8IBx7SzdLlk2IpFZ+5gyaSkKp6yT1WR8HuA084q6ULWiL9D89+AH7mQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 06:08:53PM +0800, Muchun Song wrote:
> __init_single_page() is only used within mm/mm_init.c, so make it
> static.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

