Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5A6AE98E0F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 09:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6566B0088; Mon, 23 Feb 2026 04:36:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3AE6B0089; Mon, 23 Feb 2026 04:36:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5B206B008A; Mon, 23 Feb 2026 04:36:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C35F36B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:36:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E73E13BC0F
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:36:56 +0000 (UTC)
X-FDA: 84475217232.20.0BB1BBF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id B2ECA100003
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:36:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OCS/Oxe+";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771839414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gT5iInjxDhSQB4omwEw633TVDuZHS7fTWQCIfSqEbeE=;
	b=6OtxSxZyXbPkAvuWS0Cb5g/xwpJwgbRMmRDVAhbZwhFHrkkv7xYCWw6wcP85zz1VAh0il6
	sdg6YgGdl1uEn9yrho+RSWSZ87n35ZOoMYUmIm9M87KxLgD4NTGuRmqcYZpyEQuUO7cktk
	M8h6bZbFr/fldH5/qTZqa2xZcI3QSMs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771839414; a=rsa-sha256;
	cv=none;
	b=zhSS4KdNrMcXbVrsnAR6/1pX6KPLbh6DjbsUF4ffLPF7IxiegzxHdz8swmPTkgS6tj3l+a
	xdyzt4t22DxpLzbEt+0n/W1LtaUOhUeq+go4fzrcgnwx1zllbD7wDHLfL6kjyUDMjL4hQb
	Pa4g/AQva1VgmfTGz7PXkNPmhzcVoi8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OCS/Oxe+";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A65D960054;
	Mon, 23 Feb 2026 09:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB8EC19424;
	Mon, 23 Feb 2026 09:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771839413;
	bh=0jMHGP/ybufSz9lSb0ZxZMotoqEwnfv1L084yPjko08=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OCS/Oxe+Dxgz+x+xdUK/MYBO0KYN9A8SZFhWmTCCYz09A6lLOmm0uN5o6h7jMzG2Q
	 jRFenKp9st0gV3TjgABTQgDrtgQ4hthtQYeoS8BvjHkxFb9TZa+DzTqltblbK0bnZj
	 PTURObvt0rZihgvX4BA4ptBpDGCg21GZiA8k6fRayqylGJCXCLs+FligqQjx4JlxJ8
	 wtf6nUlUn96LYP8M84pt9Zs2vz1o92hBGuSRYaOBpe7yA9Nxf547jnW90lIsB1uO9R
	 TW30TzjPUMgqMt/5wwjjya/3hUZIk5rkroJnbqCWY1RiILUhVwYeJVt9SE06Rrnl22
	 BMoG/sCdcY2zA==
Message-ID: <492f2fdd-3f1f-4303-b512-ef90b649910a@kernel.org>
Date: Mon, 23 Feb 2026 10:36:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/11] Zero page->private when freeing pages
To: Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-erofs@lists.ozlabs.org, linux-block@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Jason Xing <kernelxing@tencent.com>, Yushan Zhou <katrinzhou@tencent.com>,
 "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 K Prateek Nayak <kprateek.nayak@amd.com>, Davidlohr Bueso
 <dave@stgolabs.net>, Eric Sandeen <sandeen@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
 Todd Kjos <tkjos@android.com>, Carlos Llamas <cmllamas@google.com>,
 Alice Ryhl <aliceryhl@google.com>, Damien Le Moal <dlemoal@kernel.org>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Gao Xiang <xiang@kernel.org>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale
 <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>
References: <20260223032641.1859381-1-ziy@nvidia.com>
 <aZvXevheBMQ6LuUu@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZvXevheBMQ6LuUu@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B2ECA100003
X-Stat-Signature: xycxyiodg96164mmjewjc8qe3f8x3qdz
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771839414-565192
X-HE-Meta: U2FsdGVkX18EAH49YVhK2Jfbdqfxr1R18+Xx34Q0+XE3kGuF9JCdeXsv5jau5GIE3ghXJ/O1ObI7nXkRXUyPp9hwlb3/unrrWLxfTWyRuYcZ2ZWu1feyuxN8Cho92Ez5krkR5qxt+0FA9CMVNKuIVDn4yhtjPV1rBACZNN9YeWdombSMKmradMzgEp7pTmopshDoIXtvnBBh/4POAuWH2zhun5hfp+Oku/2Ngwz2dp+klcWgxpauqSfzh3DHcU7/HZd8REVnub01sJV36t5LfJShgR5ABN/KfovEa73Ma+OM4wSKP4naSujYheLf0TlwORGW0/7L+CaKLnwh8ZUS5Zyj4IUUFd00+46NluxsMQSg0TOw04FjRFI/uZfbduOr27f027+LD/vn4DdG4rBm9aoVUcisxgdvgdHkOGVfUF2ykWvP+0GWax9dMVlYHM7hmvlsd9/2+guW/913OT21syTcmDpn6HfByFH9Pjq3KGXU/Cra2N2Cidm/eQgM9Bf0DfokrUww043Gjdyg2gNteopONlvIj1i5pH+jrKXCBXMe7ffTBfERvjDzWN3e6Nb729Q0uDDgbcmIUkiuoGwnVxTq9Itos5pjm0dW+1xloREs9UAqbJurElDqavhA/jD6qaVceNHpzjA+I9tI4vu346dY+ckGaHETJflEWykXxpwYSVF4jnu4tnqWeMTaxgRqJPXMN2IXMdV6aAdHoVg2oymRnCc1n63nBUJ5DFy6Wjai5xYOECVVCrgtzEHE0yWA2h2Egoh0gX4xFkxzwdBmXXJNsKlt11HsjY7chXlp+pu6q38VcWaWZfDbiYeGYNmJa+k8jrS7I0xhTGgZswFUstbasw/QMQ+sd4aloFtOaNTwNLek78WcIQsinbqYFQRCn3z1uILxXaDrv1vMkiY5kGWV1ahD2f2He/wmXvlhZYHnojOCPKkXj/iOtsyiG8t7ZTzk7aIDGuloV8vk5bG
 VLH1BUE9
 1vKpkaPUHKWOU539TJtyiSma9AaTLTtbEZxyhnxb3wYURaOHVKxgHgQGyK+dlpvAJBSAMrboyecg53jxq2J4stqWEQjlOzsOeebOZTMUF0xUaZ/VDAD5wur9iTuIXIIq0eZDAlG66id+rO1npeRO9DjWDVoN0Lv4eqwO8qQJuF8EsOV7/QSZxpnRbhBdU0ZKlFkYa1TPZZz6KG5qi5UDsRp1azGb4GWyl+5SMhWbimirqxshgtn2wXgT2QwG4AGaN4bc8dshcb7YT2Kk0YJYECcY+yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 05:28, Matthew Wilcox wrote:
> On Sun, Feb 22, 2026 at 10:26:30PM -0500, Zi Yan wrote:
>> Based on a recent discussion with David Hildenbrand on page->private
>> is not zero when a page is freed[1], this patchset is trying to fix all
>> users do not zero ->private when freeing a page and add checks to make
>> sure all freed pages have ->private set to zero. For compound pages,
>> both head page and tail pages need to have ->private set to zero.
> 
> Sorry, I didn't notice this conversation.  It seems entirely unnecessary
> to me to zero out page->private before freeing.
> 
> I'm a bit confused that ac1ea219590c was needed too; I thought we
> cleared page->private in the allocation path, and I don't see why
> it needs to be cleared in the freeing path.  split_page() should be
> clearing page->private.

See discussion at 
https://lore.kernel.org/linux-mm/cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org/

> 
> Can we discuss this at the THP Cabal meeting on Wednesday?  I don't
> think that introducing this new rule that page->private must be cleared
> by the users is a good idea.

The benefit is that only the users that really use page->private will 
also zero it out.

This implies that all pages that enter+leave the page allocator will 
have page->private initialized and we can also likely do:

diff --git a/mm/internal.h b/mm/internal.h
index 9e0577413087..4ecdae78e0d2 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -724,7 +724,6 @@ static inline void prep_compound_tail(struct page 
*head, int tail_idx)

         p->mapping = TAIL_MAPPING;
         set_compound_head(p, head);
-       set_page_private(p, 0);
  }

  extern void prep_compound_page(struct page *page, unsigned int order);


Which is rather nice.

-- 
Cheers,

David

