Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A7D8C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 07:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAE396B0088; Fri, 25 Sep 2026 03:15:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84A16B008A; Fri, 25 Sep 2026 03:15:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A156B008C; Fri, 25 Sep 2026 03:15:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A09AD6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 03:15:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3548940548
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:15:18 +0000 (UTC)
X-FDA: 85251423516.26.6F9AB39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 769621C0004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:15:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K3W8lDCm;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790320516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7gdWsILDeGL2fq4hXJ9qNq6gT7AIFOxT+XzWAS6HA4=;
	b=4a+ALtFQ5cbl2WhhKIyhP99XAoibEJ3MhuX2rQT74TE2Czitizcw004gnrfftthV0fGx6R
	4cXeg1AIHrwDGX7ieb3QrNyjIKTMl52T2x1TD8laLw7ucTLc6YtxUhFBuS7CS08vURffoc
	sc7q6ret4Hgjf6I7fQM81t67oWDSXkI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790320516;
	b=Cbjcr2ZIYExtgnbXo6d99CsF9vA8/jvfuVxB5G+OM6wUZz9HNVdoeiAguvwXQU85DPt7MI
	6xMeBY0W2s3wZcSBtG4fX06HsddT3G8XILCouCFqE3ICV2bJLmPLQLmiYFRaSBbx6JlgI9
	DNfK7B/vmcqda7O0hRnd3kCvm6tbVRk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K3W8lDCm;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E99FA6022E;
	Fri, 25 Sep 2026 07:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA631F000FF;
	Fri, 25 Sep 2026 07:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790320515;
	bh=K7gdWsILDeGL2fq4hXJ9qNq6gT7AIFOxT+XzWAS6HA4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=K3W8lDCm6YecnNVEKENAO2Z6Sg7cT/3eLRojKTT6Z9zscAa/v/5cqGv3GNPCLAGEp
	 535X6IYjYQnPdQSkuW0jarjrIMu8TG3MAad+tPqdtJJd80EQSMeNM67ts1y4gFv9Mh
	 3shg6wfIiE7m9n6ku2qbiiPe+vdifcqzKk7ZcucIOZ0Gr918jX3ObWr91F64hJC3nN
	 1fUJppekntNIonBq0eCEDOIzNLTw4lwoewnQqUlREO5dgJGoFUlUNJHiWExvBnQrH9
	 5Fo/LH9LtJ1n2y7hCTUi0oCupcxb7hAcZAmAYw5JPGiqrewJHmHPfD2+BevGErZTIz
	 SKS0/2E0Ij/Ng==
Message-ID: <a2ea9840-bca1-4c69-bc67-e6e27485aac9@kernel.org>
Date: Fri, 25 Sep 2026 09:15:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] mm: implement page refcount locking via dedicated
 bit
To: Zi Yan <ziy@nvidia.com>, Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Ilya Gladyshev <ilya.gladyshev@linux.dev>, akpm@linux-foundation.org,
 andrew+netdev@lunn.ch, apopple@nvidia.com, artem.kuzin@huawei.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, edumazet@google.com,
 harry.yoo@oracle.com, hramamurthy@google.com, ivgorbunov@me.com,
 joshwash@google.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
 muchun.song@linux.dev, pfalcato@suse.de, rppt@kernel.org, surenb@google.com,
 vbabka@suse.cz, willy@infradead.org, yuzhao@google.com
References: <cover.1789239015.git.ilya.gladyshev@linux.dev>
 <ebd6540ad89a4bb80e2a62d00901b5c827315b66.1789239015.git.ilya.gladyshev@linux.dev>
 <DLFJL5U9DI6F.3QJP9YP0KX636@nvidia.com>
 <56e036665dbeb0a8f51d697220d5ed84f210994c@linux.dev>
 <570cf649-a8bf-4073-be71-207fbb2bef40@kernel.org>
 <CAHk-=wh3LLDV2AMZn1PZcU1o3Na-BNcQtP=LPXouLKPZWaiRdQ@mail.gmail.com>
 <DLO1WIACYFWF.3N01DXYFJLMD0@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DLO1WIACYFWF.3N01DXYFJLMD0@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 769621C0004
X-Stat-Signature: xx4xmp4mj1cgicfekn45tigm9688pjfn
X-Rspam-User: 
X-HE-Tag: 1790320516-50930
X-HE-Meta: U2FsdGVkX1/C7l95L50g0bhBoPlftd4fejKNHCze/8ENxCrcU/e+BXJIfOHXv1OBNhJj1lERGXP+CkDreah643Ylyd6tbUu0LjkloBuneMx6FxvNw6mLoxYzJ8toxnIvanergJY5wtc2Hx5dLvwYQRKMvlAMLSxSEEuCfRAnCloEs3HgLOKC/IARZxuFFQY//pkpZzt9UxUTRowDRzNGSRLzg2zB9otWZboNj4LOZ95F+qFrHri3tpTwBH4PWGG7O4icX50lXiFCGFZEF9Jmpu+nquY+Y32YrYPxCTx46DiKVQYGOAcH00mDxMc6MwlcPbj3HVMRfu/ZpqFNnl/Jl0IUjdX1I94T7a+9vcirTe+7GBNoHATtL2Ulx+mWxkefxvPgefd/S2XJTiPp5G5RhfHrxW3G/W7/KfdNRVzeR7GeJcpeFXDydG6vNNL+VH+bau8Z38DTYK2FejdsCj519ToFqYDyxkiQA6+l2wNSHn0KdEctJNkUOYZiOErilnKP2I7SfjZZ3zmmHVDpMXRrpHNrIw4ffLSTobmEAjZLcPwaFSEEIlR4Sq5PjqPe3yrVMwYFQNSKC2qIUYFKcg6cM8SaXhe1/FMJ3p/NISNKtneNimV0uYD3vjQ8XxeuutQekvfQS0BbpmVruDzFy2Lk5Sy6QhxbCS9wxJdXnRGGdTdV5eynl0nwCKq+VuL1O/GwZFI38o4Vn1c6qMCj5NbOIdb7yt3paZNG5+G5uEhgsBTiLjqGfrJJXgVOE6sCASaUIRXgIOzAQgfGlKKI1Fj+dNBDefJo1cEjEiYIZUehtI8mJzDuVUM0EDJy7ng10hm52Vz2wJsKewYOeijWTkMQJkxqxrJ2IpOaSpeSKYbCWuWXkRmfzylC1/eG7bg8lGP9YJ602DInTHFXHs64KGdq8vWDOh+wpWE81lNTYhImuRYDPnQvQOFkasDHZ34B11Jzm7TbomazDvZp1aNjwXZ
 dpWNRZ15
 htZT6UdJskNHapWFML3dqepdlJRuvvC1aZg+ZNcyPpEGzxfyUq6q0BgbAPaoxCitcafVxHdiaztuXHcNGADiEGfiUp0aCKqqH59HPA+zatI8l6xhn1f8mQPm4yY8YpUh24ArSLtO1c6yJU4vhCZ75gTmchtZNEIOlPc0maFPkXFyWuEc0PUHG6VO8uToKWoYRxWEC13LuNfxSv8LDPw9DHNHffft6h5t1MY3Jwl/0DAZWslDWx5Vwb4OWtiSOuplPIVcMxGulbEQDWDu1HBTtFGZnWSFZvT0lP7NWNH6OIcR+QRL3RAPP3rpQwYhaBUQ7rbyOEBT08bGX6H2YtNAsqPvG99hFQtG191k0frhz4e6n4/mwU7nBrfLNrPU82Tg8ZY7FTY1J/HOOInUi9HyVUhxz9p7r+d5hS4i3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/26 04:44, Zi Yan wrote:
> On Thu Sep 24, 2026 at 4:06 PM EDT, Linus Torvalds wrote:
>> On Thu, 24 Sept 2026 at 11:52, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>>
>>> There needs to be a common page freeing function that dipatches stuff.
>>
>> I think this all needs to be entirely generic to all pages. Agreed.
>> Everybody needs to do it right.
> 
> It assumes all callers of page_ref_dec_and_test() are free page
> functions, but there are two exceptions:

Right, we'll have to sort these out. Which is the right thing to do either way :)

> 
> 1. compaction_free() uses folio_put_testzero(), which calls
> page_ref_dec_and_test() to put not used migration dst page back to
> isolated freelist instead of freeing them.
> 
> 2. virtio_mem_fake_offline_going_offline() drops the last reference of
> fake-offline pages, so that they can be offline.

I had a patch for that, where we keep the refcount untouched:

https://lore.kernel.org/linux-mm/20250520164216.866543-2-david@redhat.com/

Long-term PG_offline pages will not have a refcount at all, and just have a
frozen refcount. That's the right solution long-term: allocate+free them as
frozen in virtio-mem. Needs some more work, though :)

-- 
Cheers,

David

