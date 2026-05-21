Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE699CD5BB4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EED076B0088; Thu, 21 May 2026 09:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC4826B008A; Thu, 21 May 2026 09:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E02DA6B008C; Thu, 21 May 2026 09:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D51806B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:19:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C53B1C1A33
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:19:05 +0000 (UTC)
X-FDA: 84791482650.08.361B5FB
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf22.hostedemail.com (Postfix) with ESMTP id E8B28C000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:19:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tzEx0prd;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779369544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YK2uSx9/FGZV7F7ut1QE7D7z/0Qvpx0XqR7yKWkjPq8=;
	b=P7Fy1g3aqaShS5eNIhiS4+n+WX0qyXvyklGQvc3tz1F0XLGY3kEA5iheHr4fxuIZNx+rgG
	7JIO2pfZiBf7ppJaZoXdFD3GCrzi65k9RyPBsWUL1EL0aDWsIeeqtxDMtbOq8mZ+LCWgVP
	D003SvC7/rgP+DpUH/EpAX4xbNyBcsg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tzEx0prd;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779369544; a=rsa-sha256;
	cv=none;
	b=Hk5uKEmNRm189JPrX5Qn6MRHRUwFjKVSJj4iyc+ssV6Dl2g/iDrTypRgwn3si/9slns7FE
	WWUsKGaYGPfi4jdaCKsBxeenxkpaLwIeufKK7W1ImCqf78TjoRmvXFH+taaldKdAqc4MlS
	Hjaftv92VI3hDQlAzDqFc8wecbL/u/4=
Message-ID: <7a976d40-54a8-43f1-9d7f-744cb34e7bc1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779369542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YK2uSx9/FGZV7F7ut1QE7D7z/0Qvpx0XqR7yKWkjPq8=;
	b=tzEx0prdoipxV/FdFxmTZvBRCW5TYZVUqqgF4VpxSkT9Ha3qZBXV/yNTIWPomnDlzSYaSI
	TduvWhBs/rlXak51cn/bfK9OgMz/FVf4oH/h/DWLKZiGJVfmT/y9KwGwg7Fgy2R8uTi/Nz
	aOAdS01cMSkZxxhXhGHa/j+CIBH4wyU=
Date: Thu, 21 May 2026 21:18:52 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 2/2] mm: shmem: refactor thpsize_shmem_enabled_show()
 with helper arrays
Content-Language: en-US
To: ranxiaokai627@163.com
Cc: leitao@debian.org, ljs@kernel.org, ziy@nvidia.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 akpm@linux-foundation.org, baohua@kernel.org, david@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn,
 hughd@google.com, baolin.wang@linux.alibaba.com
References: <20260518123238.56344-1-ranxiaokai627@163.com>
 <20260518123238.56344-3-ranxiaokai627@163.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260518123238.56344-3-ranxiaokai627@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: b9crokqp516gw3ruo73pd8uo7wpuqkmo
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E8B28C000B
X-HE-Tag: 1779369543-334134
X-HE-Meta: U2FsdGVkX1/kAlqj9Okw2c9EhTDH1JMB/bSnKHiWaGilSFvwiuoXwGOqIvkOavNVRNXFBWg2+xX0Fb745SDjudNHJV99AntOMhqLXIYk3hdiDnuw/aOGgZsdboRWi5XHq9VpnDI/Uu/Lt086HFS1KWwNwJtomfWFIOFSuBNhbcPtp1Wp0Yo7HzLCXflJ6sMkaHVnq4dG1LJddoKUsXazlU/umRHFP5kHQtX2Nps1s88ItSsvJ/5h+xOvhA7ZAdD5V8vSgZQghvsDhHocQ2B7FNt1NuNwOKySgYrKb2OUebnIWTzKGiatIdTl9bGt1G/rPe3mqXRUcTlMVY4zBmr/23N0EBVV2tfnonDZvUoOLiC67vChVd4M+8FaXi3mFlpBVcT3TkSEdux6qgbEPVCdDYbmLgoxv0OYGriaNJCZbx6/gcthBW3r3iNN63c3wqbwJh0yy+rwf/90on7sBTtV4E/pw4o83Pp4cxw5Cwbb3tAzWYeCzbktkY5YdU8ltfuZnqMZE6E4CZBHdzaBAT4aEqqjj+82LDWff5u1GYRww7uXmbjmc3CJOvKzTwtdTHkq63sdI18TYhTT0v8YVA7KNwfeU8tFyHJtv7MFf8qNFYK1vch2K1xA4ZZGmwBrIvHwcDxzqo0qDJD5VNDrQ1FR9eEqqQ+I32diBCGv5jkY/1ha41QM+u8opSQc2WlHUiPe3X0gQtAJK8z5rXivarK4gjk5DJ+Ll3WG877FjngwR+Ut5W8H8b6UVEW6eqB1dUVBzzIOZHd96Lu38V5xlQipWsim11OxG/HzRgqRhFTyyR3H0XzTmEvyTDZDbAzFJOgpdTfsCpzZRdjlT0OUiurNqHbJ5uk9Frb0zt/oiuk+QEyEVu7wUSCkiKsZGFz207WNWEhkiHp8xK13nKRhktk+YZoAoIN7xKk9b4a1YDm9zB8Eko9oKiFxHvktevCmF5FYKOuBx9XI97TmC5AtEsR
 DXmqGyRI
 56Ba2he7MvQEri0ITf0xNcGZTX/F54u5INs5Lb8NduimR0MNzlU/SFXDLTFNW5tYEt4wwNg1SjhvB349fGx+cw9SUqb87wBIGdnkYz6PwJAEvJaUPM4PggnWmuX3zV/f/nX2idNQnf/Uu+qpQ8bXlJmDREfyYZ8VQEZ66sCuDKlzliR5e9ClZdLn3lDFmnPa6ls+5SXKQqzB5iKENO0RuMX9IaUIHdo4fzf3v/LmMVMZJtHDsYGCCQYUUjF8mWrpWzHH/U7uQOdiC20wOOgBCLLQeA+CH/F/B7q3VyMkQkDaBbebS8IZkDCeZ1g1y2lLZ4yEuCvR5FnZ7/CK0e2gsiujv+Aty6WXHA9r/mSoPu9p/OMct4Iv2d5DzuXiigGXKaEMdVkSmJLjIo5ZOjO7HZ5eaWvNZfjkIugQs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/18 20:32, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> Replace the hardcoded if/else chain of test_bit() calls and string
> literals in thpsize_shmem_enabled_show() with a loop over
> huge_shmem_orders_by_mode[] and huge_shmem_enabled_mode_strings[] arrays.
> 
> This makes thpsize_shmem_enabled_show() consistent with
> thpsize_shmem_enabled_store() and eliminates duplicated mode name strings.
> 
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> ---

Thanks.

Tested-by: Lance Yang <lance.yang@linux.dev>

