Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51A08FD45F3
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 20:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9425B6B0088; Wed, 25 Feb 2026 15:58:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F0556B0089; Wed, 25 Feb 2026 15:58:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FC286B008A; Wed, 25 Feb 2026 15:58:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 693DC6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:58:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EEAB114070A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:58:02 +0000 (UTC)
X-FDA: 84484191204.10.4693F46
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 56E6B4000D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:58:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OzRZeBqt;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772053081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4bQL2DktOVXOKwssA689TwMNm5YeFPHFhQxFj3pF8/8=;
	b=UPgkybhqa1z8Ia82xAh7NEuM2ln8JvoDotIBdbFeKdTmrN6rRzuc0kS9/CJDhyAYoUJ+jS
	PpZtK5AZNIzq/ydqyEf/4rWYF/X9qfChKsdEJHfU8zJyHu9bZpc1avxlAh6BQp1vClF8UM
	pMDes9Y0z+sSTEa9yn/VjbTsU+cLaW4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OzRZeBqt;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772053081; a=rsa-sha256;
	cv=none;
	b=RDNApC1brS2rBV0u3WKxhQ8gHvd9VdF41L6It+W5LPPLpbgN5GXcB3p5nypnhlBHKtg8gb
	L6igQEzOxWB/UAPpE0TeBON4y0lwukecMLTwCn81JbDCUbhc9aeRdt39rmAY0TMDFgC9yK
	13xzL0CE9bx66e7utSxmMAg0dpKEKOA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4bQL2DktOVXOKwssA689TwMNm5YeFPHFhQxFj3pF8/8=; b=OzRZeBqt0nq2TdNWknkKFl5FLt
	gqOdqltp7xjaUYmlrjYFlUKzNOZ6fHyH7u2A7xNKzf668CgjHfc8mfRT4NQxDFLmQTpdb3jtTv0o2
	5fue3M+n0zKbyed5SFNHSdOCGEXQ65BK7daaAa1Ys5h6/inH2GQ+P1BNlnRhBNyRDcjxeivCHAEqp
	evQOO19NdgRWOxfiE4kV5Ry8T/7qneeut2VcCtCHE5oWaPjEe+1dBNvuPuipSJiaushd6XPLqXzpU
	wQbQA8VIiEGQaxucab9o0GFbFEygU8BjXVYRZnkvyVsRGbLa8CeTDiG6KO4hZo3a8h2y+ovvzpGfW
	9IrR29Zw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvLxF-00000001e1C-2dOQ;
	Wed, 25 Feb 2026 20:57:57 +0000
Date: Wed, 25 Feb 2026 20:57:57 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org
Cc: Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: [PATCH 3/3] ptdesc: Account page tables to memcgs again
Message-ID: <aZ9iVaWueDjbeVB-@casper.infradead.org>
References: <20260225162319.315281-1-willy@infradead.org>
 <20260225162319.315281-4-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225162319.315281-4-willy@infradead.org>
X-Stat-Signature: opfzffk1o93zqq4hnsz77m1yeo9jrec8
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 56E6B4000D
X-HE-Tag: 1772053081-56064
X-HE-Meta: U2FsdGVkX1+X6o/aoPMKO0Z9s7NhOkO/BrUPAVpkfzLAPSuX6o+zR9W+hGOB4jbLxWZYk/PVWPSCimVL/iQDuDkOXDjOcDTbnpdnuFZi0gqQLvoMDSA1AZu8p+Jj9mAMpORE+YvZIw+SXJK7Oalzh6W1ZNxYH4XECpHS13/7hA0y7EG6CBMRSwhbWOzhvwjP275/MIbAJtuvNrlksZ6FtBK1PjVFw47INWGdXN6nb77TVLVBquph/CorXdY0WPVDF/XHmDyf0zTqJan090tV7zvJOUiqnAy0hWzQf1HG9wplOPT1ArnRZmCtXTJLzlEVy4lQOM4IyKpx6RaHmy+l76Y3MSsiSdZtY2G6lqPfSNBn4+hM/qt0gmS2oT+dMyI2DiLmdeddcFDCGaLMvW3xUL6M4iQ4dsRardM3rb02R2UuhpFNXS84ITU7TLHZcmHh82DW2YTw/W3kL2FRH6cr/fC+SNQqf6XVmtK3+PUICQTjGTEgxvaA2pybzfPDRcGl84hpb+kypahYZZUHFHeS0PxMHIAHHPyzr819dQh05JEJFQtLAFty2AgI1ygSoGOBa10Dbr53q+gJeH/L5zo1G7zQofFg+P2yJxDANgCGMX6HYq0THKSNJV3+Qwrt2cGgTRqLI6HOZREiahfNjw3b69cqnHT+0l4aBp0qiJ5yrerlRZyvBJb1L/dJsNiP1pMtfjbxQbYgTnI9Tx7at6GLKefW4xnYByrrQ4B5qPEHJ86tC9e9bcb2qjvzjEI9vqHEOWouM0D8TnSsqKcGOC5eEorG+e90l3pQIIsMn8uUs0RXqPHN6VI9onA2F6CBkt2yeA1ff3ERYiuIf0/QG9C0aqT2Ah7AO+/FH/iuQc3QE0eW/aUWfly3sUu+kdZL1HyVlWJptcQXr7qAF9+/gbhxJ0q/Rcpm0PbeIs26rWbsknhMvjnXyF2YzS48DEVU7//6VxVFE8DFBYc1m8Op8yd
 3ZO7Sp0f
 ZHETK1el42OcuS2sPQT5h3sRIQo+XuOVfwfSjVFGVMQknuSa6jE/MuZVxLljQ7Kf5WTHHtjd5rW/xMIzNnLnxsWUge/FzAhOF3c7GcNvV1qJEDaH+IABYSitpvCKjOWfNk2ILcVBt3WuXMPu7KtxxxhjmNERZNCfxxABgWhVM7sHOt7mEI7SvfJUooDKDeeJ/D0IYhFWYAwetetv7LCxpPw6iFxC8Iwy/pMrL5qPxrb09hsQVgTjpM1Bj9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 04:22:17PM +0000, Matthew Wilcox (Oracle) wrote:
>  static inline void __pagetable_ctor(struct ptdesc *ptdesc)
>  {
>  	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
> +	struct mem_cgroup *memcg = pagetable_memcg(ptdesc);
>  
>  	__SetPageTable(ptdesc_page(ptdesc));
> -	mod_node_page_state(pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc));
> +	memcg_stat_mod(memcg, pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc));
>  }

It occurs to me that we're not holding the rcu_read_lock() here
(whereas we do for the other two callers).  I'm not quite clear
on what the rcu read lock is protecting here -- can it be that the
memcg is rcu-freed while a page table belongs to it?  Or does the task
existing prevent the memcg from being freed?

(is there documentation on this that I've been unable to find?)


