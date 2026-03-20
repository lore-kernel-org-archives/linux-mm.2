Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C7161099B28
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 17:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497406B00B3; Fri, 20 Mar 2026 13:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46E406B011D; Fri, 20 Mar 2026 13:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 384476B011F; Fri, 20 Mar 2026 13:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 23F5F6B00B3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:30:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BCAAF13A78F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:30:21 +0000 (UTC)
X-FDA: 84567130242.12.2AD5192
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id EABFE1A0017
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:30:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k3SpwwTm;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774027820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lg0eThoGxR1F9HhNvACHHsjFpyt0rpeLzAulURawP20=;
	b=wbTwOyFBHsthN+kmAhzaB11rmcDKUGWlftIZd46ZzK7v/fuyC5fM6BJa7Bkc42DYBD+HfQ
	7VOruvi2lOvK+uNoug46axImi+t+SRrakjvNo4L91tnZjm1TEjXT8g/Vyl3vUZykKDSDZP
	zDlraMgF+vpw+zsb/Ot0CpqMY1UfrbU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k3SpwwTm;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774027820; a=rsa-sha256;
	cv=none;
	b=w+OiFsLhUb7wd5Nz+fuHVCplKmVQkdAHH+hkGTj70Er1ZKJuI6NbQxDq6yTr9ZPaLh7ES/
	axvmFRrV8X+PjSpymUsAl1OHXTSqKZnXCd6BgzWY9T8FZX14c/2WKX9Oo5o+SIpuZhwrl0
	C+xxv2Hn21u3otfsCeDBzFuciu6u6dg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E1F43418D8;
	Fri, 20 Mar 2026 17:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD94C4CEF7;
	Fri, 20 Mar 2026 17:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774027818;
	bh=cn49vooa6zI1bK7Ne2keDKeM7S0Q3DYN+gFeecdr7S8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k3SpwwTm3+LqCjrQj7miOUpofGNKZgHYqEQFraeDhPNVkXfECxvLW8Zobe+NTCg+G
	 i7xlPNhvtTYeO7xTUc3PKqRzid15IRNPdH4YUSohCwce42VZkVlfUBCOYco/sVD2et
	 vxE3mFh096D4OSX2GQRa+4bRuL3WZDLWUKtjGXNpv90+4RK+i5qV9A834ZJ9lkzev7
	 lahhfRWQ33ItmIvlrTAdoDUipL3iLC6ZC/fkTuxcE0ZVmjxz+jG3WsJOCgw84oKjof
	 B8nLkrNSu+NEYlk9zV6lwNjmYwBOeq57KIpkyhjcIZtOPDWfA1AJwLaP+3IsTjxXfR
	 z+df8M86zwjVg==
Message-ID: <ea8a46ab-3ae5-447b-96c1-37b58619edd3@kernel.org>
Date: Fri, 20 Mar 2026 18:30:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/16] mm: document vm_operations_struct->open the same
 as close()
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1773944114.git.ljs@kernel.org>
 <808919eaae0b682ec631301b3c06d85c62ba428d.1773944114.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <808919eaae0b682ec631301b3c06d85c62ba428d.1773944114.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EABFE1A0017
X-Stat-Signature: xi6yy3hdskn87gu9qqop6yn13w1z1mw3
X-Rspam-User: 
X-HE-Tag: 1774027819-654472
X-HE-Meta: U2FsdGVkX1/7fDjIe6AZIzqlZtbSv76ZjkuXbqK+VR2s6L73IAdW1OnwCRyE9HDc9xYW8GKaesHyw5jbdKVWOD5WSAP+sMakgB//wJ4nbAy7aaIarRj6ujujUwX9I/qJp+V74SHRuizxllMO4Fn1mCCFhMyvo+KUr8FnrOGRc6LRGOue3Ujvl8E+f88dKlQMTD89TpCeUTanX5Iubgp7hHuiuBCZS/ViVtoNwRycuvV1c2g7LrQ37Zi6h0lqe22Xl1H3D2l8n1YRGR+yMUruSIXJoMKb+LOmQ7dLcyK96mEUdGP/bQx5BTRI8SN8xEZ92UZ/ECk/+q92VYwoKZKYPrBxS+2/2buX9jMe4tmZu9rQXx3YEqUX4y9Wthoa8OPSxBVa704v6r0pGF5zPDqP/c9uzIRFOfA7ys2qsHuQ1sles5iCel4iVEPaVINw4f8y+0XVJp2GXZg+lf+8X+8GspQvv1TJGXpKiCMcDek96e8aEQkjVD9OTk04HrT9gcR0qgqcjHFC0jtntU0jgj0iM6BN1Sex/3slGHfNqWMnJFmF7n0JMs+2MQA4mQCynbWvPGbcp2erv1sb4kUcyd1J5CieH0VNk0Ld1v3GEgBYfEycfNdXSC2Vci+Q/hUjztMl8lyLAbDLTctps8I1Dxb9eEpdL8JLHvqFm/RyR4ckZ51Fb7b/7EDHT1dgUjjgby/s5iG76e+yLLCMNYfm7QAGps+Z1pgHBDAp6VjJldXpPU8Xmlob7JIx2rz0hywMhRpPY0U06rp1bmgvNk80w0lpOIpmqX0kiNuprHmi5HhrQwS7qs9mP9gD2AHScmJK2CFrQ2ddb/MSIbi/8YUhSpT3sz3tb9l8CbLF9F3uu7Av8FsZVMmzwcbe1VgI10eArMIpVezsfDknKDVaUR8emXa7ft7cG01iatYFH5wNhkO5YyQf65dpQ9eNWwFQUFGiMjO/tI/VFCl/tg+nwlpuE5q
 WcHMZWIv
 c7dgDgE8ImrYXi2SyJQkif3ahKLoCVaEf0ibczMb2Iw3OzBtSma3xbSTVNuBA8qOPKkff8RzK+3rsx96ZhihPGT/frYjMzWaFlTaueb19dQjO9m5UPv4pghiMWDgA0Ce8aE4i+/bSvIbX4sPNBmbgUAm6ysByyAXdji9aH51h2GqjAZcR8QRwAWXpQO2LFz8xWaIYRr14BiHUFZG8ojXf+o5VsYMm0dFxuEvBYMYoeortzCUHl4HMmslH5Nijnjz6iFn666f/5OtHPF4w9zbQAUFwgrrc3lppCVqoPDuwozWZdKBsLMVEq1+xVTsPZ5r0zB/56QguQYfMcAw1bepX0GVOzisQJlQSXO6rFT06R4S6z0GAKV13tpEuxOQgCBh6WCNP9CF7N1OvOcf08z6ga0DdRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 19:23, Lorenzo Stoakes (Oracle) wrote:
> Describe when the operation is invoked and the context in which it is
> invoked, matching the description already added for vm_op->close().
> 
> While we're here, update all outdated references to an 'area' field for
> VMAs to the more consistent 'vma'.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


