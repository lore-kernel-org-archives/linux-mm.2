Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DBA6CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D55156B00A3; Wed,  3 Jun 2026 09:10:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2C3F6B00A4; Wed,  3 Jun 2026 09:10:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C426F6B00A5; Wed,  3 Jun 2026 09:10:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4ED86B00A3
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:10:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 66F9C1C1823
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:10:33 +0000 (UTC)
X-FDA: 84838635546.16.F17B02D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 81D3218000E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:10:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MQIQPSGp;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780492231;
	b=kX25eCG4YSqNyJYH1c8UPf4Ed1Dh4Bw+AruGTEBJ59ubwRx++uyzaTOdatMErhAGuwbo1W
	gmDHv20tJjth8bcmjPBMnbxqlB+B4e5Yk7FEWYYbBfEBIPXV9tWsEAFzxv50/N9pjWVIxi
	VO6NaYpCv0bj5e82nHpiV4xsolEsVo8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MQIQPSGp;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780492231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xfGW+mRFGm8otcTxNVwZMIMPut6TCa61gmVUrx4IZyY=;
	b=A36k/QVUdChUO+ltZvVL9u2ruEwtESc8OK2v9HEXYEpmSBZoLureEVlAwrBMjtt4rrgabk
	wOkCUgWv9a1iPro1dHU9q0aT0EmJ6rZqbvsEl3KXN8fBj7vc21i4Cp8czPIrrW++8BNeYE
	IGcYGf8zkmPpPMC8PNDdY7TAfQpvjXU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ABE7240464;
	Wed,  3 Jun 2026 13:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E711F00898;
	Wed,  3 Jun 2026 13:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780492230;
	bh=xfGW+mRFGm8otcTxNVwZMIMPut6TCa61gmVUrx4IZyY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MQIQPSGpw5I9loYGFQLcQY7krurq0Y7ApV7YAwoDGRJoFsVw+6xjNfuxELTSJH5Cj
	 aG/6mkFsGEqOLHl3wbpTZQpORpa12t6ssxCVueCuAkjqRefy8EmoULjnS6PbDtsPSE
	 eClL4KWs4bPMDBYnZOcju1cH17iKUPZMFygJY+pCAasLIQLsVc5ChIEYQFSRqAtmyW
	 JTeiLJ+Uz53GdqGavxHDurOtMvZUMgwVdKpXenWQMH3YkUj7CE7+uBrBYgGr0nDxSk
	 S3DLl5R/FC6IGUBjIZi6DNeORcBDiM1EeWOEn1dWkGBCBiTByK/qDHfxFIDrA1Svqc
	 OBE/1RR2+8dqw==
Message-ID: <8948ca8f-d872-4fe2-8887-568eb0d0e65f@kernel.org>
Date: Wed, 3 Jun 2026 15:10:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] mm/swap: colocate page-cluster sysctl with swap
 readahead
To: Jianyue Wu <wujianyue000@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com>
 <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-1-ce0219e100d9@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-1-ce0219e100d9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 81D3218000E
X-Stat-Signature: aqhj6pykjajoytz7sr1rk5rpybyhaug8
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780492231-323416
X-HE-Meta: U2FsdGVkX1+QqFavufXAgJevUG7/Vj53gL1NIx4gTM/tyeX28E04g3VMDo1RuNoAl+zNzpX113IwLGjA5KDo/CR/xRxMJtIAllUV5Q+AQwIa44IwO2SeDJk8BbBiyiW0Tv6/glOU8MobLiXf8xmhU2Qexl4J47XLcbZqzygEGIrbsWncnDD9BOADLFzmg+zXlsZyk4kO0Rkro5ei1o+sqJZhX0Kwzw6U8J/JTcNZVDTsInUmlrpprCpy0VmrYx05mBJbKzq/bq/1Ko8NeyMIfrquZjDE6opF3CnZT3AwhjL+aVkgo+2wpEPJslbbTYcIUnZO2Sd8kAOx/tPXLYk/Lsso08zCsiCNvDQzvhWb7kJocOJZpO4E7qSJBfWSqHSE6Q7dgMjAqJqo8sE88MZSJAATSqwRficTL2UkMkYZHIoqEmtJui3QUm/pQsSo35W5lN0k4CRA3eG6fffQbnLnpdAtGlBMtmIngdUjdIZttCj6MFs+f95M/eygPk3WNlN3OBjztTBB0zUPzHvt1gzPMHkGV+BTdTUO/mNCIOK8aisB98p4hMsuIkcmrIrUmLS6z1NMyfnTzAA+lDCCrhso9iRZYMUqGLKZJRk+B+pcpME/fVn27VbVRRuO3LP2HBymDRPuv52scXLfb8DL7GSL6YKzjfa5lomhRF/jHju4LuioJbK7LRvLGzysSaR0IqOjDfSWuqN7pnFpjUuvdFFjp9R4y07106hJY/c8Qc42oAyTKSTwjTq9FnbLvYJih3cCWWGw6b0ET429UwPiMo0s5EBVwKoBaxjWbCp5n/K92RWHTuWwbDq3y9ribXly+mkvPKd6bspo4TOJYB13wxeqeNWkhsMfSEGZPAqS9DUvK2sS5Lpb6PZSLhRIV8mJPCPYao1OA00zai5WQhxje4pMD8KiO88RtbG8Lvh7+JpIjG5Dy0pGiJrWh0PCdGl68Qk5MYJg9hVtJa6ttyl1eu4
 Rhuq403Z
 E3Mk40o3eErt8INotQc5+ZQfYnfnENJSdIskyxi7iYOVmzOC1vTRSaiy0GYPOKBrm54SJFoJAQd9/GodQJxIMwB0nNC2pUUQfGsrm6ao7DMwEeEnMdMze4CNDb7Fv4uOEs0PkENorLxReXl1wO2RFiD9TW5nsbM127jPjVKzUoBlsI85mlP7P2OzNBZ0Fymmil/otxq91g5x8Nc307XPnuGN3RUQ4UOWcbd14otsXtla1fjK0ai7QYjV5HlvYB11OIDH/4zN5HR/s7bZZIjeYG92eYcAdjo2KCjw6aKKynTu0C8NDN9xuMBbtC6ihvryMwO3L5cMCbSw1+xQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/3/26 15:05, Jianyue Wu wrote:
> page_cluster and the vm.page-cluster sysctl are only used by swap-in
> readahead in swap_state.c. Move them out of swap.c together with
> swap_readahead_setup(), and make page_cluster static to that file.
> 
> Rename swap_setup() while moving it as well. The helper is internal to
> MM and now only sets up swap readahead defaults and its sysctl hook, so
> the more specific name matches its reduced scope.
> 
> swap_setup() previously lived in mm/swap.c, which is built
> unconditionally, so the vm.page-cluster sysctl was registered also on
> CONFIG_SWAP=n kernels. swap_readahead_setup() is now a no-op stub when
> CONFIG_SWAP is disabled, so vm.page-cluster is no longer registered
> there. The knob only tunes swap-in readahead and had no effect without
> swap.
> 
> Suggested-by: Baoquan He <bhe@redhat.com>
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

