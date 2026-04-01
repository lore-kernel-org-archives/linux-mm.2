Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F9491112242
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 23:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E38C6B0088; Wed,  1 Apr 2026 19:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96DAC6B0089; Wed,  1 Apr 2026 19:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85C136B008A; Wed,  1 Apr 2026 19:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7145F6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:37:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 39655C1339
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:37:25 +0000 (UTC)
X-FDA: 84611600850.07.89CF4FA
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 48A1540011
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:37:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gH4y/ZCm";
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775086643; a=rsa-sha256;
	cv=none;
	b=MPyAdUIzkzq2NArZbwqBNNd4CXajVgc5f0TJcxMW0EHgIJ42z1OlRW2xIWI2Rtlp5eXwOb
	JzjuQ2/M5VuObE4NdhzdEudP/bXcu7xfUum1DPcR6rQcNH/AHAQoqHuJpaeTXOd/TXQuo9
	SQlqfBPofyQVEP+cgOJ5SZT9Mt1ezMI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775086643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hY4tcz23n34pDy42gZbXUJKJX56cUVlfL/AJg7+tTAs=;
	b=tDvFrhwPcFHYUHvQOAIvJQNu6feGRVnLyVBx58kGC0NLaiXZavpY8we8C/J4ySxTmBWiYU
	17NSsg1kHoyQJjA6wRUpn2tBF/tHc32ozy+v7iHhsQS2C76BjpJZw3+jliEkYCwJxZ24AD
	GGkQikdIYQZLPVx8uFSBydL5gbggq5g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gH4y/ZCm";
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 1 Apr 2026 16:37:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775086640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hY4tcz23n34pDy42gZbXUJKJX56cUVlfL/AJg7+tTAs=;
	b=gH4y/ZCmOpRFp1sW9gqJkOJuncCdsM9nUh3FN3xzZ54WdeMX81tuHPD33vW3I63wpt+2Qr
	QjsXI0f5Blr0FVcRmLjzCq7fG2ut1aAjCvc9b4VrI5u1Mjq38N0Lz/HroNn1z2kZ/ed8MM
	bpO1oP5AW+5yooMvWt6ZCwn+fu7vVf0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v2 08/12] mm/mglru: simplify and improve dirty writeback
 handling
Message-ID: <ac2rO_ovnIQIeYZr@linux.dev>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-8-b53a3678513c@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260329-mglru-reclaim-v2-8-b53a3678513c@tencent.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 48A1540011
X-Stat-Signature: 8fanoff4bkxdrtdafotjsmdjzdiq6y9a
X-HE-Tag: 1775086643-651790
X-HE-Meta: U2FsdGVkX1/Y0CgfP12rGjt6Ku/3Kui34vRLSbascE7OfTAL9UUw/MRbcDjwxhPqaSWdC0w6RbylSnPjueqkNdeFfUWOlaHX+i3fvruFIT7I9zbV0Zz5qUj9k6deVuwClCzAWFR/ootxpxz5MITim+3Cp3sW3dPB/CGFSnmBsvYkhUgcIsmtcPkvkZlgaQ88d5o1pDqd8+0L49MY/vI/+gil/gNNVdDwwNdRbvAhcU5x3EU0ky6EjwHCyNJ/B3k5kczxY2vpaYSvFqweX2qKSDfB3VNq1TBola2oAqG82STA1Q4Yto0TLpMjTpWbhOzvwLHoiHieJfy59WpIr9F5pWO/TnRwrvn7PGt7AoG2HjL5ss6/pC2eQe2fa3uWSg4YQVr6vGl4hkj/4+6pj+e1YXNWtCm4+SL4AuwFPdd+sw6PsuSzDCfy/sk25DNnGpL2h42LBP8f5R1lQWz+2DT0P7W9aFGhlT83ncYJQWlZllsXH/VOMJFr0cep4zR+7kReZ12y005Ue+/0NZXibihdxckoLEKty6c12UjoIFPZsQY7dTVzMpcROFKyyYoYRUy7sZ+6SJ37ARzmsikRmbaYCsMseHcHL4MTpg9w/ep2ZJstOX9vcW/NbY4anyXvUcPHg21silhWkwPs2IR01TYXlNSXlVz2X/wiJtZKYMIj7lw/LcbSgpIGZl9vEDTGnGxCf5hx7/PCHI3H+NWwgvEmYPNqXjy9IQvH2fPkoXrfBOnHkd43AM+AqbYUxZFGNIqQ0DxnfZvVCMHfCrAZPS+MG46WpM5VizqGgSkgn/6h8sjY+QwCOOt9OiPoN+b07rTN9R8EaRVK+Gqlg9RleOj73ecAZryeVD1lT57A03v5y4eM1GmLGumctKHUXt1ZFBU3LJY3A+oNT3fLDDhjEdFwODiICGLeK7GGYJP0OfsjJFIEf+AnWOGlcuyNGjR5gkM7HYQfJLxaCjIijtO8GQZ
 RBFg+piY
 OSmz+ALga1gZfzl4Xiq64gqANpmKEslt1DIH2ik6G9qp9WA4/kT2HjbkyRwbiXcqeI7mWscJ7JuBD5mUDyaKHZq8AwLoq0cT4kiC1DQgMeUXoGtsUfChStoelCo0vtInPOwJWECZG/7cTB+0rfT58db6UUPai/J4fxn3Y8+vvuuEO/PzqfxcR2mFOMj+Mobv86ncRbNjCaD8lqoM4+kvEsB5uZBrqOWqpZcaCTY+9TFtC+uYMQ1swsZSn9TRrynFWhdEIX+585eRQY/QApRiJq//R7tzPm7zJSYwrnUoJoxRSYBCQqQ2jaMZcTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 29, 2026 at 03:52:34AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The current handling of dirty writeback folios is not working well for
> file page heavy workloads: Dirty folios are protected and move to next
> gen upon isolation of getting throttled or reactivation upon pageout
> (shrink_folio_list).
> 
> This might help to reduce the LRU lock contention slightly, but as a
> result, the ping-pong effect of folios between head and tail of last two
> gens is serious as the shrinker will run into protected dirty writeback
> folios more frequently compared to activation. The dirty flush wakeup
> condition is also much more passive compared to active/inactive LRU.
> Active / inactve LRU wakes the flusher if one batch of folios passed to
> shrink_folio_list is unevictable due to under writeback, but MGLRU
> instead has to check this after the whole reclaim loop is done, and then
> count the isolation protection number compared to the total reclaim
> number.

I was just ranting about this on Baolin's patch and thanks for unifying them.

> 
> And we previously saw OOM problems with it, too, which were fixed but
> still not perfect [1].
> 
> So instead, just drop the special handling for dirty writeback, just
> re-activate it like active / inactive LRU. And also move the dirty flush
> wake up check right after shrink_folio_list. This should improve both
> throttling and performance.

Please divide this patch into two separate ones. One for moving the flusher
waker (& v1 throttling) within evict_folios() and second the above heuristic of
dirty writeback.


