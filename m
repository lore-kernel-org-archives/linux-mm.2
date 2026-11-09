Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0B3A606A33D
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 14:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R3j5M1Gt
Received: by kanga.kvack.org (Postfix)
	id DF4026B05B3; Mon,  9 Nov 2026 09:46:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5506B05B4; Mon,  9 Nov 2026 09:46:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C928B6B05B5; Mon,  9 Nov 2026 09:46:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F7C76B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:46:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 974AAC06D1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:46:26 +0000 (UTC)
X-FDA: 85415856372.07.6CE8F7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id BF0DC2000C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:46:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R3j5M1Gt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794235584;
	b=mHPgEHQ9PDs+lvvuFBdCSYD/zPXl6Uj8o07ttkBhexVj5K9HW/x2v8qFoE8dRAFQsTt6Gb
	VptThw6nWst/qwdDuALoV+vgq7Xl2DgaXHpNFFzarPdDnwXZboG52G9XgaDlgjzhTTdQd2
	hsw240Efvjo9oDyntA/B+O7s7Rt2kA8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794235584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93AR0ixWRF7Xc+mKq42uEUHnh202mM0USTi6ybrtt/0=;
	b=t4tHR/oPsFGUWH0bgK0INCKh0tFW7PUaNS7IJJVOAdgmV/LlIQd8mJ9/Uh2hOuDbEZqt4q
	JXHC7k1sduhP50f94X7mKAqCfpVuYS7zcvs6TPsiGWkjjTWluWW0xx+uX7xw2epu4JQ6G7
	zbdLxOpZvvbGFeVfaOOE2GhfZnzBfA4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R3j5M1Gt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13927447D8;
	Mon,  9 Nov 2026 14:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620B81F0089F;
	Mon,  9 Nov 2026 14:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794235583;
	bh=93AR0ixWRF7Xc+mKq42uEUHnh202mM0USTi6ybrtt/0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R3j5M1GtbQ4HJLT7OhpTZEh2BryQV+uiLHfcysgIOQ1NFb5i4bak6X+eNkP0EAbZ9
	 IQ85enPQ15w1I2aklY5dL5f+9UPF1nB4OWrbOipMU1EhxsV2QyXRhRi7HD89zlVrf2
	 7dp+w/hxXIYXChRG6Ji8VoQrIx+r53F4pKdzVlHCKuMaMejkxQ+1tOSwdkAJ62sF6h
	 C72/0kQZRLR+UgfMObni0YgD7P8W7VFoxpbK2xToMWavoQI7CPAdxeSX5jQMqY0cW2
	 bIXVv9cTXdaGNcAZah1PVqO7mgk/LZXCLJk1Xgn4u2atOJoobfxWL1KjRB9VY6Ej/t
	 Oj1Qw5V5yi4vg==
Message-ID: <f21433af-afc6-4a8f-8d2d-3a377cd3bd6e@kernel.org>
Date: Mon, 9 Nov 2026 15:46:10 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 03/18] fuse: don't move a folio with PG_rcu_free
 into a fuse file
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>,
 Hugh Dickins <hughd@google.com>, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Harry Yoo <harry@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador
 <osalvador@suse.de>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 "Paul E. McKenney" <paulmck@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Luis Chamberlain <mcgrof@kernel.org>,
 Ilya Gladyshev <ilya.gladyshev@linux.dev>, Jaegeuk Kim <jaegeuk@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 kernel-team@meta.com
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-4-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261104130118.2507513-4-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BF0DC2000C
X-Rspamd-Server: rspam12
X-Stat-Signature: 489pdc95ab5634jm61i5r6ffnd48x3p1
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794235584-915509
X-HE-Meta: U2FsdGVkX1/Uat6MUifOUAxVeq927zTo+8Hz/0xJzQP8HckXJuFRyjEzWx4bYbfHO0HGMi3MeaCrsGMQpFk2eJkROKurXDW8xlRGt0RX1Y2l1pzJtOM0mWv4HSzgemw/iP+RayZScacG88vUWSWUVk/Y/dp9fQJBy8r1Tip6piI7HbGb2Ib2qwVFuOPJ1bAiEOdHJT5uvpeqaoSaEotwFsU+EReps+Q6yFP8ot85UegBhZIFijrk6WNVhGlQTnNrZ93vwTuQpFmSsXcAOycJcLEx3zFIpSxrXTx/ymvmxISVDIOFaNc2MBDpqKYgf4huP7vv2qEXBIHGiyX7RzSluwqa3yem9mvOVeG36Ypn9UKWwsvqKsvBZxAHZxMXyPihBWjEUDDMoa2YJ4ncJsZ5+6ERJTRoP38YWprMksYOGmqqGgy3pjT33naAhVgUsKNBHQDmXor0w7dW+nYwO9vsuGn66oviHho4ZuPLN56AUrTbNF+/cohQETrjn+4UWd5Bt5GzaBW5Vg9tuLwmuVMczK+DFcfndCV8ne5Pgp/aD0AyJfpG2XJBGz7fPU38ny9XT7ULGPHZHHOUHNf5k0gxNk049Y22f4qQsjW9MWHjYzUnUhcIPKrrA0VigeXhv2GI00lYCkzXYp8H5kfjv9Zdhynsp0oKycA4lQ1pDk2XOcb31hODv3wh2lYC+ojaTPg0L6h7XIjp8acA0XwLkGiaejwl4rBH7Bxa9gRKUnNy/5KMbLKu25joD8Q6aALT0oCS3WT9IxEEfSpvdEziCFcYmJVDEjlWohYHNtZBS9qoICalWBpWuJ2G14ARTlnLrLBxmGGGNMsDbNm1NKweQHnhsm1P9Sl70447omu9YFtSn/eWqZZuUW1Hkhw2jHjcGntkuA0NOMhcueGJe2tSafbW6cSnbdl+K0PpUoE/pi5at3k1Iw0lKZyUOqruplxsnUphaHrw11qarGPRDNn/ox/
 fSdFGga+
 GyXxEyu3aZl/dyGhv8dKY0lJikklaLL+LlBi5O/5v665mN7NMG438l5xMc8zB6fDJByT/uNooFLgTEfIEBJ3U3wRHHYW8e895AH1ldtrkgHP8a75tHNrKnoXeN0WQlP2lPCcObIJvThXzLqHY5qSwebYMK7pLqH7XZ4epJe4oLgnSLn7ptDfXsGLK05MK+BqhXIu6LoXW9gaRVhTcq1I6uln/t2FtEUZamN4+uvSr3Oo4j8d8clmP8nWdt2+zNesa1CKkpoZQq5urh6p+VPDFbd4HKrN2mnjrI/oX6dxUq6DxYq/9fDHXkXm9clQAgMZwPRvxgGO5fqtSWbNYLsd++1fVsg3Z2PSmBDPqT0Ihr7hpge671eSi1hZRXNKOSLM+XAhpdJNPtd/6HYEnfIW9/crG4D6vsRsJHueiY8fjV1K/lLG2IE/7uugrouXuk04fjXY0JRBo8ABX1nOUReQwfPEDefkFMyVEzBHiIUciU1r7k1AOj+VxM/nzJWPE6YsqZgf/j0HzENv6K68=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 14:00, Kiryl Shutsemau (Meta) wrote:
> fuse_try_move_folio() takes the folio of a pipe buffer and puts it into
> a fuse file, where writes change it.  A folio with PG_rcu_free may still
> be copied by a lockless page cache read that found it before it left
> the page cache.
> 
> Such a folio reaches fuse when a mapped file page is gifted with
> vmsplice(SPLICE_F_GIFT) and its file is then truncated.
> fuse_check_folio() refuses it only because the flag is not among those
> it allows, and with a dump_page().
> 
> Copy such a folio instead, as fuse does whenever it cannot take one.
> 
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  fs/fuse/dev.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 4fec31fc0b84..526929c7b3f1 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -1152,6 +1152,10 @@ static int fuse_try_move_folio(struct fuse_copy_state *cs, struct folio **foliop
>  
>  	newfolio = page_folio(buf->page);
>  
> +	/* A lockless page cache read may still be copying from it */
> +	if (folio_test_rcu_free(newfolio))
> +		goto out_fallback_unlock;
> +
>  	folio_clear_uptodate(newfolio);
>  	folio_clear_mappedtodisk(newfolio);

Talking to Zi, it would actually be nice if we could disallow converting
ordinary pages to folios and the other way around. That will be required for
some future changes where we identify folios with a distinct PG_folio.

Could we get rid of fuse_try_move_folio() entirely?

I think we'd just want to get rid of any such stealing if possible.

-- 
Cheers,

David

