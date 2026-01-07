Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06A21CF6BE1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 01:16:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 452026B0092; Tue,  6 Jan 2026 20:16:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 406E86B0093; Tue,  6 Jan 2026 20:16:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 334626B0095; Tue,  6 Jan 2026 20:16:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 209306B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:16:19 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AEA718DDA7
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 01:16:18 +0000 (UTC)
X-FDA: 84303402036.24.9ECEF4F
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id A9ED1C0007
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 01:16:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WxxBrewl;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767748577; a=rsa-sha256;
	cv=none;
	b=mNttUR5UIZxiwrfAmg93PU6Ss9CAWgW4ClA8TxTSI76tTNuNWjw6AAmiygYzgbxHdwoviM
	WUwbox40GDEELaYfc+ZUB+4ZBrYI4vOoZgbpRoc4ZSaRQUMvznu/XyGyJiC5OPotemvSjK
	hMSmdvsA0B8K6OBldVawhCd7Z5paocU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WxxBrewl;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767748577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2zc4DIOdl1Pd7NU3lqgjLL5P97EqbXnp15c7Yi08/Rs=;
	b=oN3g+uScmRTb9tyovz2gHU/SnoF+/ca+t0oomiUbmqp3nL9JEsv698LFVnK73wjRgkAkHl
	In+Kfk0nDO0zIiTXnwYGsiuoh28wp2KRlb0PcM+V6LTidrQSp03CFfftxxZRBXtpa/SbwZ
	KerMmzPxKVi4McKuPitJGzITV9BLxBA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767748573; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2zc4DIOdl1Pd7NU3lqgjLL5P97EqbXnp15c7Yi08/Rs=;
	b=WxxBrewlzT7ITVhnNCn8QnR0vavmA2xixsrBEvXdYbgkVDB6ep3o4zuQgehmNdiqvXQGLHhLcmjlcOzTKj0qoSxYCtfQWWU9bMc5hYzaE0QOacqD49yngxUyQkapbP1i3heLtMOLpluCogj3/pWAHVK8LdipiPw1XAtvVP41Q74=
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WwWwVyP_1767748572 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 07 Jan 2026 09:16:12 +0800
Message-ID: <9c4b8d43-1c01-46f0-8e1e-435a19b8713b@linux.alibaba.com>
Date: Wed, 7 Jan 2026 09:16:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: fix uninitialized folio in shmem_symlink
To: Matthew Wilcox <willy@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, Barry Song <21cnbao@gmail.com>,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hugh Dickins <hughd@google.com>,
 syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com
References: <20251224094027.65842-1-21cnbao@gmail.com>
 <aUwcV2HhtdiXXxfJ@casper.infradead.org>
 <CAGsJ_4whKLWiw6LNexFPHTFWB1QbSrAwrBtspuc=c8fM2=WnvQ@mail.gmail.com>
 <bdb7f7c6-ecf5-4da1-a11a-cc19c77fe4f2@linux.alibaba.com>
 <aVvDcEB583Yuolm_@bfoster>
 <2b12f63b-ceab-4d3e-a06f-f41e6b1b2d23@linux.alibaba.com>
 <aV1Yb4r9_ukWoc8i@casper.infradead.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aV1Yb4r9_ukWoc8i@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A9ED1C0007
X-Rspamd-Server: rspam03
X-Stat-Signature: oq4bgo7bap6s5gzjqwqdpjknyy5xzknr
X-Rspam-User: 
X-HE-Tag: 1767748576-937906
X-HE-Meta: U2FsdGVkX1+mNggxbrNmxQIZPAvhle4CauuR3YMvPRBqKWpWCYwK3TVH7Z1+YZD8DDEETTW4beY5quD49sarswZA8G6pdktNN+nHrvKUGbM0Wv+3lxJAdvW2f7rnRYzUmnhFJtw6kziw2SQMkksNJB6iGX1nhDYEmQ2QiaVTy+UYcBlYy32x12NkKmEoNniheVrTBpdI7tGxWyHWvDtBbr5y3ViL+Pg5LEOkn2179+v+UeBmK5F07ekzLeLQ/dZdFz7G4ryu6T8dz1st8Jy8NRBvHc6lB6QOAvY89XZDBX3Jt+Sa999E358rbYz5/Wx+xobftzWZtcGfrKykrHXSKPBTKUY+U0agyTddnF2T07iczm5aFelFQaLFmCcYWRxZbIapz3NoatGuYkAu8xNvdqVpJ8qSxB/sGgwQtlqqKJsPOB7hxeRRCwTba+taXzCPN2tL2THeXhV+coEPMBSBE0Blaiid8uSErVvgkFvwnEbbGcgcqzO03M8zdOUxenOXOMrwR8qcv8NBx8FHEqsTHqMpaQcEU0CLmQLUjzyVYv9YxKDsdwrE7WTeD2EuWVWJ4Gn32LzMtoMuSjeRn9AHYIKT/3nWEW20cx+GJo42v2P5U30iEUW7z313EJVY/1ZUsUK88PTlUHt/lvHey78AOXjNKNzXDsG9nQV1GxAAYgA6YoaHsKsaWdoHkqcOx/bfKqenR3mk1XVT4GziCVAPqSt1umB9uLKTAkqG+SBC/SDiHWmfiJeZdUXMeq2K9WFJM7/uT1lMRR+0me0Pw2V0P1YjKR2Tu83nJZGBCHJUlE1VdlHx9dBT946+2kRj93YH8KH/wudwLXakQVuMppZ3Q+zy1KiNvSu1ysR8yAyZyNjVMcrK92lTiLMm3GTpL6pyPp7eCbqRjlDq+6DhNk05btGSezZEdhdL2e+xZbtf38sCh5/WTK7yCsAgdrwHfXW+nkAF3ASC9nDi0klVcUO
 7HulIbJj
 iGxitZ/Vm/0GEYT0LIgbcGCgIPNa2W8ThnY/sXGQWXFpqtK0djFp5uUAtx0pXFqsY3+ZpzLxHEZCKGadEUAY9fMel0qAIObpXRv5dWA1y8AB9OGC1VJGJwkDk4M1MS/cmdi8faRE9Aw5pRik7z2hh/CX/fq4ffJomf7FHrgKRzJzA3h1h2eRJyWrDwwTZPf4hHjxfdY2R0odVdKKIF1z4LzVL9qFWonNXSddlTQOSHzD5iET1qwfEe+TaSKT+a1ac2JuEUrlH6fzHkiC18uBvqInE6h9+9ECyprm1XPtcE9K4u/mwrocKHdZ4dBX8H7Mvf3Xk7ZowzBiIppFZO0EzRxoUHzqu/SFJL0xE+YiGUFDH+xzcMMecFeKlsudd3SkAJujqoWlBXjTUBP1OqZny8FvmFtSfWODH73OGj8lRFOK43D8wGcBG3M4ODtbq7OOhWDUVCGcyI/LgMOz+WtiztWduE3K/ZhQ9DG05
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/7/26 2:46 AM, Matthew Wilcox wrote:
> On Tue, Jan 06, 2026 at 11:47:44AM +0800, Baolin Wang wrote:
>> Why I prefer Barry's fix: First, the symlink folio is marked Uptodate after
>> copying the symlink name, but the whole folio hasn’t been initialized, which
>> seems unreasonable to me. Second, as I said before, using the 'PG_owner_2'
>> flag to mark this uncommon case doesn’t seem worthwhile. Currently, IIUC the
>> 'PG_owner_2' is only used by btrfs; if we ever want to remove the
>> 'PG_owner_2', this uncommon symlink case shouldn’t block its removal.
> 
> PG_owner_2 is aliased with PG_mappedtodisk [1], so it's used by every
> filesystem which uses buffer_heads (whether mentioned in that filesystem
> or not).  btrfs was switched from using private_2 to using owner_2
> a little over a year ago.  PG_owner_2 is not on the list of flags to be
> removed; that's PG_private, PG_private_2 and PG_reserved.

OK. Thanks for the explanation. I understand the plan.


