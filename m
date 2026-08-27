Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71115C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 20:27:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70B766B0096; Thu, 27 Aug 2026 16:27:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E29A6B0098; Thu, 27 Aug 2026 16:27:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1896B0099; Thu, 27 Aug 2026 16:27:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30A6E6B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:27:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6E37C0199
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:27:14 +0000 (UTC)
X-FDA: 85148183988.26.905AB87
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A881A40003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:27:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mCbG6wIr;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787862431;
	b=5vZK9Q9FAYP1URf52GeOnYr5fDtaKpalkaFHw3MrTO8SaomEiTvvxnAbYldWATmwyU9GwU
	xxNJWUOz0UmcyKhetaHYqbEt1EROg393yd80qof1eQLpXdid3RZGnGiXqEvoxjvtfXK+zi
	2zVluVdKF91gmSYbKUFb2EJVGFJ3VfQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mCbG6wIr;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787862431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1L3yxEZbWCvg5LUmRwP8ZDavWBk+Bf+rg5djBphl/1s=;
	b=uCxbR6YxBi8u0edTHPCsJDOvPWv+BpLuZj7p276GKB/KQRikuJ+U2QkTfxenrXctPqT4cv
	q27HyomXHbLu8Dss6UUGUf50W9khQJUNHh4bGIgaxSmgaL08CQOrRQZn1NkYjUhyTNwKko
	EGQwM0b2KhulIx+PYHbb8lrjAe8RYXI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E85CD600D4;
	Thu, 27 Aug 2026 20:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544C81F000E9;
	Thu, 27 Aug 2026 20:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787862430;
	bh=1L3yxEZbWCvg5LUmRwP8ZDavWBk+Bf+rg5djBphl/1s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mCbG6wIrrG+wf+wFiK8+ak/XJFOgf02RCcuYCcZpXC3tCVV+oMUfKaZuB+PLZA+/Q
	 bBqvFU/RlaUmb8rzrh233tGbgtj+5cZ0lX0cLf5Szk2Ley1p8mI+hxkXzKjsOrDc0w
	 Qoy1yiXqTErnp5LLKhzzzEFdKekHfvujE350xJ3hULVdozTJkJOKwmJXxy2A1oe7sS
	 g/j3UNZG2GmeAmc5QUephEnpY08momDvCUPbcEfTBieqPovU8lMhrtt0w11NopdCLg
	 ztNGnkpYFo4vTWWTk4/hmYbyKYy05qkqR/VDmAd6iHbVWogmnkqC0QWHFftwsTlb2q
	 5YntX49ZLP4pA==
Message-ID: <443ab5b5-2d47-4ffe-bfa2-15e47ff7469c@kernel.org>
Date: Thu, 27 Aug 2026 22:26:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/25] s390/fbatch: no lru_add_drain_all() in
 s390_wiggle_split_folio()
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Ackerley Tng <ackerleytng@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Binbin Wu <binbin.wu@linux.intel.com>, Christian Brauner
 <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Christoph Lameter <cl@gentwo.org>, JP Kobryn <jp.kobryn@linux.dev>,
 Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>,
 Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>,
 Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
 <7bf68e7b-f88c-6ca9-39ab-e9fedab0c8be@google.com>
 <20260826155722.0198d3ce@p-imbrenda>
 <2319f670-fe0b-f032-c0dc-486cbec0f3e1@google.com>
 <20260827145502.2fb4505b@p-imbrenda>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260827145502.2fb4505b@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A881A40003
X-Stat-Signature: 9w8id7szqw4it86rmcwixfaj9gtezphi
X-HE-Tag: 1787862431-729431
X-HE-Meta: U2FsdGVkX18Ru5aGjdJSwNzjvaGC8zIibj9YjgqWBPLQuEfIda9QK3TA+gvHoiUZbk3KQEJcxdmwth7Q36ImbuDwvEyZE0QMyb2eSzjt6vANotgVwcZnTzznQmrZE9qlLIA1GKq2f8L77DyoYX+qQY8apshe0g6RVOmMC+l1rsMNca71wWidHBgJW4rkGwPcWH2KObohrOFWl7mi0fUYIxuF5ymg8WB5u/yR9ZMdzu++htdwxXU9ZNnIriT5RTW5t5rHu6Y2vOPek5EeBt7M46L2+P4pXwI2bT/ZK4PqJHXJgIfQyL67CoKaDxqys7pvI8kAuo97nXBQ1vGQIPQ2DQ7NZW4cBsVuVSI2reXWrKA1X+xmmjm3w8clpdtWHyvKG7XYlLhwjkZInFPdluEldNkuXYjvw41zEufAL6t1q0h4iv+Vv0rm3S+Yj5HWEwxv1vatmzRpYWK25WuGiVIOYJBBnmEdIMsggZeqcrBXFIkWzrqdSYlg7jgj9bcNN+oz0z2bINJF/NRmrmg45vuslFBNS215ItVf5ruiQxyxlr1OC5ojsHPvkMJQ8H+J0hlLHr8oqwcpS//0OCymL6+iT6MIOSZ2CLT15ouuSFMFz/j3j2o65Vnw5LsAE79JnCxqPJMP+7KzbNhs8pdG6BvSVif0on506d6VbHFTP5+LbKJkwmWIlAj8HS0oDQ/oZRlBlQiE86+pwkPaRPdn4MOQ4KKl3ETPReBeAX9avxN2TTLANs1ngRYRfRxYZ1VkUolKMOddXnuRDWgaoXy2+NCMYXhnz96hvtpTWzLlnF9/mkVPDbHjx+ccgsar8DLa9C7aV3AyAAnCWH9yRqtrjNHja0Gvt+8Y05wAIIxRbGZy8E9soG5mngIxrPr6EsjWN/FDdovLr2Dmi4VBFt5LaY7mPdFvIf8HL9rWPU5xrGIIMIEgjcMxMCILS6UBQuFWvGpsiW0tnwBXrqvdK4HGto/
 t6n1jbrF
 w+BjCVNWert5bpmNcl9tLFXdmc4Z+PyCBKpeEUJII/xzvt5B27/StpFGKhkflR8JDtZffbklY97by+FksqMPqLkH7v7ci4evP3Ai9SQVxE2iB33u3tD3G/S9zKALn/a0BC5V33rAFsSDdS7vPWuzKbyhmnKFcUQJFLVLUDmJ/2t12ntgOygWwb4uUICt6mUVORo8pUXzGk9o5pwGEMWzLFTvMqSOJXiMbAFsqy6QXa8FmqR4dJ0tlJ4CShS6vdU9HHtqoH5DSRx/v1jZ9msFB7dQs55gv9Q6BrvZlSyqkZr+LDTIqS4sgBlHVi1dwWBXQ19n9f7uWeczIvfAxMd7IyI8qWyQxoSYJKifImd5KHoB4uRpHc1t7ujdaV24XtjZ++j30
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> I most certanly don't know s390 or that code well enough to guarantee
>> you that no stray references to mapped folios can remain there. What I
>> can guarantee is that no references, of the kind which lru_add_drain_all()
>> used to be needed to remove, can exist there: so there will no longer
>> be any point in s390 (or others) calling it for that reason, to help
>> split_folio() to succeed.
> 
> we are not using it to help split_folio() succeed (although that's a
> pleasant side effect). We need it even for small pages, to guarantee
> that no extra reference from LRU is present on the page.

Just to clarify: the LRU cache might have references (IOW a pointer) to the
folio BUT the refcount of the folio is not increased.

And that's what s390x cares about.

[...]

> 
>> there was an earlier time when mm did not enforce that; and Barry
>> is currently looking to relax that, so the limitation intended for
>> pmd-sized folios is no longer forced on the smallest large folios.
>>
>> If Barry's relaxation goes in before my drainage changes, then
>> there is value in that s390 lru_add_drain_all() in the interim.

I think we should get lru cache references sorted before we consider using them
for (m)THP.

If we realize that this series here cannot land any time soon, we can reconsider.

-- 
Cheers,

David

