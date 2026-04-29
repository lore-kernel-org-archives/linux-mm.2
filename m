Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF38FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 10:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4D426B0088; Wed, 29 Apr 2026 06:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6496B008A; Wed, 29 Apr 2026 06:23:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89DE76B008C; Wed, 29 Apr 2026 06:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 757B06B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:23:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B0B461204D3
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:22:36 +0000 (UTC)
X-FDA: 84711204312.18.47C89B9
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf19.hostedemail.com (Postfix) with ESMTP id 69EAF1A0004
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:22:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777458154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQnZQYLrTlNYy1jc1rXnnTon8LpqLdCTjRpZns17oGo=;
	b=wk9g8JN69449PqKYA5zsXfCeZbs0nzvaXCMHC+7uXpPJyJi8mjkfAd6B1sTihcnxClGKEu
	n4SV+PHY2jQVE3xrzVLN4GMI8AYX4nERH0OVJ6oIV++N9Oz8O35JGIbkeiEekDu1lbmMda
	lUlpGFG78UjIOlH7tynQqWTLoLEeX9M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777458154; a=rsa-sha256;
	cv=pass;
	b=jUJI1YiqnerbTHiYcNdi84cllk16pJrPe17O3nTXYOsYC7reWGtxDiXL+Og0EaZew35Lk6
	gtqEl52WUkIUZavQwXzgZOqdyNLHqLkTXaQ7AvqeISSDcIyfB4feJy8pJPAs4jzJJvrON2
	3Yi26ax9jBmon7hICRmtQ5JfclD0ZbI=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 804F2A0297
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:20:11 +0000 (UTC)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5E60A082F
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:11:50 +0000 (UTC)
X-FDA: 84711177180.25.26807DC
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id B9F9840012
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:11:48 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777457509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQnZQYLrTlNYy1jc1rXnnTon8LpqLdCTjRpZns17oGo=;
	b=zkC7J1KaIX1SywvNI2m5OdS5inlHpKM1HFszEI5PkdHZrpqDrC7Kr+OwUz3U1+fQ4SOO7M
	i021KmJf6KvZpweiAvcllUxtbG62cAAuaML+fkxK5bVsw0zXvTkM74FNZoTxkeigly/YZ+
	0WQt1WtixTvbWJ/7RcZnyeB4ijQ5f7g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xEM+oNRW;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777457509; a=rsa-sha256;
	cv=none;
	b=a5xj6drmIyrMFfcSOVyoWs+5LkioalZWsrY3HiytKQsfBnYnVC0BQnvPt4x17yaBdOKQHq
	HU7FC+CkDFS5/ms02DCLfqPrm+CTNZzXjWBR16nkNILMznA7p+z7EX7zQVUhYulI+xUAIr
	8OAFiYxFBKlXLR5A4rOchM/EmIovNRE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777457504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hQnZQYLrTlNYy1jc1rXnnTon8LpqLdCTjRpZns17oGo=;
	b=xEM+oNRWB3iEUl7EvR41PZcCxwM+tlM71BYBVb0m6mTHUTUlRsZy9GVgnWzfYDsO7wLdvx
	qqqBFWU0yQ8IgsOppvyiVpGtZRPXqj5d1PS22xkgYBQtdQrPjdRNGC6Ec9FZq1PHvHQCTe
	D5/aom5/W69PK8yAlF8NAp+unM5fxYc=
From: Usama Arif <usama.arif@linux.dev>
To: Muchun Song <muchun.song@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rafael J Wysocki <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/3] drivers/base/memory: fix locking for poison accounting lookup
Date: Wed, 29 Apr 2026 03:11:33 -0700
Message-ID: <20260429101134.1358607-1-usama.arif@linux.dev>
In-Reply-To: <A3EF6D95-E3B9-4228-9AED-A7018ED494C5@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-HE-Meta: U2FsdGVkX18Uc3lpbA68o8YSs0QkGzhlkWAWDND1bBo2h4ue/7K93HQklET4znlr8/jAJ5LEGh2qmgzD9AdlJDUXI7TvGt/4rOmBOFLsCYRWke7efkE3JFkhwZixCJiGRgVMg6IsBqkP0A33NgeDARSivKNdplc8qyElZOUlrc3T7DowB0An1n963u14pztNu+hslMpGUkhJoriOoash+ZZYibGTOzkKfy3POmDf4+KKM9x98qHYP3MkXLocdITzoMaiH2KBNLNZMlU7gA/mpr+U9iJ2h1FxauLSz1R5YmifnYsv2ZKjnj1C/bZu5DxgR10nMSCY2hhPsM6sFdWCj7EfW0PPXaNVfTh8IEMEZ2tF0sTIgnU16V+EwOYxNsz8AllNkz2uiiEgRqtWnGwrk9r9VZYZv6Jta2OerqMGCUSKHG1syCtO1yVpyNIhcF/IFqxxr4xv0QifQtY+KXLNKbPbQEKn/qzYCErQd0xOMP56UdqrDwMi7fVJNG/NRKclUhaooSPzR7FoRKFC16cOQMqRwzDiIRAZer5GBuO3xnlf49QhFrh2jvv2Z9ZT7+rExxBs+Wd/6VTnvW5XWBA294ccYTl6pNRAbt1i/ffNIMqXXnAZMMSbWStyT4Bav20Yx5Rer5WJsyA0ENNEKfnZ+fMqrfk0ujziDj+k2R3KbqtSwnia3tPNgkfDHIZq+pFD8TXsB25QcUsyynnbtkPOf6bhD++RlOwGUVH6n7CmzVjMagCJseRxk+4RzFJcmsNEgtRW5XjJdfzcVKlA4h395H7Gbda7LeHrMHZzmqNBGsafmPCk+x8h1n4X7KWYDNghoQnMXhVr7rExd1guFCcksUsLueCzi6qAPMgfrEjr4mLCUtQwfUhdE/8ANsnpzUs0lXnik4PRiAhTTvHXqII0/XcFU16PuXWdsGvQBYYD6XF5aZN40V1TK8kxo99bZou+9x1ikMmtpC1VcFSYqtp
 2j8orTUn
 URi4jmBhLrFCjgtK/+6J2joEF8iHes9vNCtQHSmfGjfuVhPMQaKbQV1fPhO8ifjkCJtz/uhjIFkw4pu5ndwHIpa/jEUqaf/qIK1FokYcPu4hvsjOq2Lal0S9lRxwhnM7qZMiJwv/dRLzNKip9/75diPbZHAMPa34tlAYzo1mnOfxRr2lMGbK8+y6KumI0t/D5mxu4RTR00i8DbDlL6n+7G4qon+b9IRt720IuBqD9x3Qa0j6ejF9Dr1ubCeFxrKnj5S4/36S6J+Rh6O1cB0aFMB/BOq89CSH5F4DrZKPazNW823EVtBqb6chRtOHkWcJ/m9P3j6X7RY1br6utGZiwGv56z1gNYqAk9WLq
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 69EAF1A0004
X-Stat-Signature: ma97fnr6guby9hdtbk6zmidfay4b63zc
X-Rspam-User: 
X-HE-Tag-Orig: 1777457508-338704
X-HE-Tag: 1777458154-457503
X-HE-Meta: U2FsdGVkX1+u6ljCBwXx1au6Np0yOkRmfR9Qqz7NxPbXHOtJnLwloIKkq81LJbvoVHYU9F3oZyxXH2iXofqDxHS3b/OntWb6vxsSnzWEsWAMoHktLQs3FE3X9Ub5PTdemWiXf0FMuXMMJtUaPPMDngx9mtA7Yi+e1nkREGC4sL37YkBV635nAPm7+yJDCJnZfHHQB7Nvt35LRwqQuj5aayEiWPcEqY5PQYIJCL5rTdftLGw3ollt3cXMwUhg6DlzmQIVT9QZ+g84UgytxWe5N6eYLTo2sNZvd/QWC00/KJwMPDUkAManT8/WABqscZggNP7ztmctEM4KghMBAgxYYyJqXxXSCL2Y72+IasXgdMFnQ0hXQ4/YP7ZqOzSJXh+OCAo+hAbw2oIH7YdPo+uvCsG4EPtAKv8PGD8ERUkEoAA7NXPGrVJUrkVt5nJ8j4G+Y2l79GCJ9N39GJrfOF7/BFNt5tPlIZfNQM+mgou3uPnKC+P8tIAIFtHCv+FCih7gbnkhToXUNETPnIUT1lbRdi7Bb3P9wE1wNluFiMX8ZoApUbhgLV8m3JcbyRLuxRzI1EInlYy7B78XFsSxz04U7AbhxS80UsdWPgnPuE0RTqAorTqglHU0aiL01wf6S0pLJn/o4tq0B2I3278lDPveeSyhq4ZV/feVE5Xoz4RriHIxOzAY2zFrnnR+2ma2Way/OEFtW7Pq5kigTiyNjeRX//iQND88mjwQ3l1UROiClBRQk7NFAFiYDD3jdfggYKteYtnzHem7/pey8+MHg2mheuRO9AEhNBZEG7NBfDwTMaV878eA7KR21xqNBLIfZCXSbD2uDCoZbb6t4tktY32T+4V+cAEFJLmbYolO+NYJY42KTLcbgTws01lktxhEa5KK3W6j+eY5CnL4IRd0mSP++9/ywomNriNpg4VnIJAEktF53KYQsLwrghnltUgoJL5AFq7C7X8ZwM2L2EDrLao
 DCm6r0ug
 muYpbxBpZJjmHYeYZa5EQlXg7IKzv+bWbJngs/+vs3se1AU6m4oYQnoQibEd+y0P8O5aJZrR0nZCGOk2fa6nDKA3757BsjL7VjDp2p4mZ2hii/v9F+zO7D3Fubn1UrX1NplS4MUaRtlTnxIeGp3sboAUBgkz/iXnveFsrEnfZpp79gpNosvMNLXKnWFV+NAWH/chPYZxNamJmqXv08FQWdkk7Ov2Wjxtw2P6sOJSSn+qdEo6qcUaPxmzWv4eoeeqPSOH/lBEGLS8/8VIoPlj3rTXnz4Rxo22GPI+w7374SmdgccyawXE/cvKE7JnGwEZ0mmfO9BSVzBrf4kA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Apr 2026 12:18:08 +0800 Muchun Song <muchun.song@linux.dev> wrote:

> 
> 
> > On Apr 29, 2026, at 11:32, Oscar Salvador <osalvador@suse.de> wrote:
> > 
> > On Wed, Apr 29, 2026 at 11:08:51AM +0800, Miaohe Lin wrote:
> >> Right, I missed that. Thanks. But I'm still worried that there might be potential issues.
> >> For example, this function could be called while lock_page is held. Acquiring lock_device_hotplug
> >> while already holding lock_page might cause problems, though I haven't seen any specific issues yet.
> >> Also there might be some other potential scenarios that haven't been considered. Hope I'm just
> >> overthinking it. :)
> > 
> > lock_device_hotplug is a mutex lock, and we already take other mutex locks while
> > holding lock_folio in other paths, so I am not sure I see what should be special
> > in this case.
> 
> Hi Oscar and Miaohe,
> 
> I saw sashiko's report [1] related to folio lock and lock_device_hotplug.
> Seems it is possible. You can correct me if I am wrong.
> 
> [1] https://sashiko.dev/#/patchset/20260428085219.1316047-1-songmuchun%40bytedance.com
> 
> We could fix this by calling action_result() without holding folio lock.
> What do you think?
> 

Hello Muchun,

You could end up in memblk_nr_poison_sub() while holding hugetlb_lock spin lock
from get_huge_page_for_hwpoison(), right?

Lockdep would flag this as sleeping while atomic when acquiring mutex I think.


