Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B105CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:51:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B6596B0499; Mon,  1 Jun 2026 23:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 767966B049C; Mon,  1 Jun 2026 23:51:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67CF66B04A1; Mon,  1 Jun 2026 23:51:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 54C126B0499
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:51:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA43EC2964
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:51:19 +0000 (UTC)
X-FDA: 84833597478.30.027B9EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5443A100006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:51:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YxSsoNn5;
	spf=pass (imf14.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780372278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RjMhCk/o5NC1phCHo9ITOCgxpvxbQwvB79yIHI8KxIA=;
	b=e84o18kakBP/hBWkkTLPXIoY4xhpOBrIgz6HcKXI6dpSAZBYXeW1mmvnxiQsoaBQwpbU75
	cJdS2Cr2k2RKt/8J3v3V8Q8O/3RUiqn8tWtub+yDyQozi+ynqW52jw+beowRgFsVJA4YnK
	SPQduMP1cvI5YgwIWYY60/dtjlZryIw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YxSsoNn5;
	spf=pass (imf14.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780372278;
	b=CvDy2cN43b627Vy8uiP2iK2joZfxpCjWmtzhcxpfpUHBB5TPPsCFSm+agK/Dk/g5fVMqu1
	3BmsCnr1yAFulcf+jMok0KVukAGfXYptWlbDsXlE4Pl83WuAhjpsmEspHu7h2CDeJlAt2y
	VboqoFiM6DWBn1MNPc5WTNez9tdzF2g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 429FD437F8;
	Tue,  2 Jun 2026 03:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1C31F00893;
	Tue,  2 Jun 2026 03:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780372277;
	bh=RjMhCk/o5NC1phCHo9ITOCgxpvxbQwvB79yIHI8KxIA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YxSsoNn5YJCuKxeKl6PAX++Bg1aMM2RevmuoB3R+3Asp5hkDYkYRJMv/TpeoLf9B7
	 Ro5GqUKqVtSJmc5PF+GpOiLc0azL+gPTApbXdxRHccH8Hr+f9xJ7//k0XcZqLOHvSi
	 kGrbwecefO6SaCt1vbjnccI71sOts8z+Y7MsYvqGsWup39aDDNQTED3u4+lj/rv/8F
	 syhtFXtiRdqG9CWJa2E8dieXcFf76SrQLQvLUGV2C2xznjLRecAhHWsKvgkLiwkJ25
	 xTybY/DuKaU+pdIyACHJmrYf48SqhRY4KcLhkA2h2XeK7eAcBCWailPapF06VTCHY9
	 SOQC8eSGQAvkQ==
Date: Tue, 2 Jun 2026 05:51:03 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org,
	pfalcato@suse.de, r@hev.cc, jack@suse.cz,
	Andrew Donnellan <andrew+kernel@donnellan.id.au>,
	apopple@nvidia.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
	kevin.brodsky@arm.com, lance.yang@linux.dev,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
	npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
	rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	kernel-team@meta.com
Subject: Re: [PATCH v7 1/2] mm: bypass mmap_miss heuristic for VM_EXEC
 readahead
Message-ID: <ah5TJ8tNqcztGS4F@localhost.localdomain>
References: <20260601102205.3985788-1-usama.arif@linux.dev>
 <20260601102205.3985788-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601102205.3985788-2-usama.arif@linux.dev>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5443A100006
X-Stat-Signature: g1isd5b5mk8fs143q4akkj8faxfpit65
X-Rspam-User: 
X-HE-Tag: 1780372278-55740
X-HE-Meta: U2FsdGVkX1+gXQZ46wBCXwMXey1Wzawjsat/fMrzDZa8KlBsC8ISuTsZ6WNqDrKcT821F2PobCigb9Wg+ueyo8Yj/OQxGeJNyiP7nIrEMHG6NOQrIsZMIzN6xZ5QCsPKGUDzyHr+x2bhd/V4IMrtwBmxX9jvRo3kkKGzAuYuyw+Tko51If6vol09REVt3pBLO4C8ItHKB0eEbzy39R7d65JDgQHM1l5Xg1FHH+ZSOWMKwElt96YeNUjcVUkOSEPzmCB26fYnZOPqR7kaawPDL4KK63z/5B9APMOjMqDTsPZtIQdWbma7DKAahmszMgOLWWpMgz5b31rZYie45t9beD9HMLX3uXgj++4Bub7geBhjYHqXOSfgWW403I/TW4vcEurIBn3ECflXxxTeiEg88cws3EuvPwxMJue9WT57JEuBXO3kTOj5zhT693hCNfw/OQ3Wqz2e2rIBnEmA8wGmAq6uXSmylgN2fZh9dGNgaYBjFj8VsoUrMfEi5ylCT5IaodgU3EMjrbCKUTHoHV9QVJofUhwBkq+tEZnOkZW2xeFoo8hEHgBsNS4Eb/ixptmGQVsStnpjKLNVmVVsozWax/D5BEsbjhoQNOAOPmL88uTqgZapagUHKQbdlCjEMlntAu+H3wYPLql86IPtdXTSAhxmkhlv7lJSIpF6oF7rSGpWTp8ZmUur4n4tK+HDHgDK3gNkLT+Gx8u6jZ8CKoTMo075wPiDranuKLhI5aIpFMPuJYhHfNpeXRZwRqTE7+IZfVwhI2vHOOxqkCEiIvVVTwAdmepfugXJhcgFUqLMfBHohOnepkWPHvI8lDzPldWYwUMGLl9UCtusIyOJWsbxqTaHWPq+BbhkIKjq2w2HE7Yqckq89JnifCk9C+AglbHlAIzzfhfUZxkMD5toWcpESMTN+rlxMMblOFLGWz81MEeqpLdAjVNTjM5ipHXVNaiB/so82JcGTbtOqgJ8CcU
 t0EXLPtz
 lECnsp6oCri3XuU21OjFNXm0xWJXr2xZ2BN8laWo++GyPlaHeBL4/zX237Ixopt994b/bTTvon/rmf+RFkbGQsK0MxeIUwmFGZYDQ408B2FMY/mNNE+/N9a68wtlhsS7We7GeDWv/MKRDaZop2Dqyhg5WGvizFdAh7zBx0zShElvniLn35iBWiW5N3KX01HA9bIsiDvxfyULBDtDcD4aAPTCuQrXrQcMTDVKedx083tfL9Bl9CNlrfixjtAGg/MFBg2KLCqFrmwu2faH95JbuDiSBmYEuRgA0REP3kxFheXLDy8oR0WYhAjZRFmBrn9mbwgBjwbDBiCA3ao7uPNSSaWFr6MRzyWhUd1BKtfoHETInw0f/9WSnL55YoaNfJkaP4wKB09dTLXEt3kW4Mas+61cSyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 03:21:17AM -0700, Usama Arif wrote:
> The mmap_miss heuristic is intended to stop speculative mmap readahead
> when a file looks like a random-access workload. That does not fit the
> VM_EXEC path very well.
> 
> VM_EXEC readahead is already constrained differently from ordinary mmap
> read-around: it is bounded by the VMA, uses exec_folio_order() to choose
> an order useful for executable mappings, and sets async_size to 0 so it
> does not create follow-on readahead. When VM_HUGEPAGE is also present,
> the larger readahead is an explicit userspace opt-in.
> 
> The mmap_miss counter is decremented from cache-hit paths in
> do_async_mmap_readahead() and filemap_map_pages(). Those paths are not
> always enough to balance the synchronous miss increments for executable
> mappings. In particular, when fault-around is effectively disabled, such
> as configurations where fault_around_pages is 1, filemap_map_pages() is
> not reached from the fault path. The counter can then become a stale
> throttle for VM_EXEC mappings and suppress the readahead behavior that
> the executable-specific path is trying to provide.
> 
> Skip both mmap_miss increments and decrements for VM_EXEC mappings,
> matching the existing VM_SEQ_READ treatment and keeping the counter
> accounting symmetric.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>


-- 
Oscar Salvador
SUSE Labs

