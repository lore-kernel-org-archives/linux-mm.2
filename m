Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A5EACD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 17:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E86466B0088; Tue,  2 Jun 2026 13:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E5C6B0093; Tue,  2 Jun 2026 13:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9BFC6B0095; Tue,  2 Jun 2026 13:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C7CAD6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:06:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48024C3109
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:06:32 +0000 (UTC)
X-FDA: 84835601424.12.429ACE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9984C40010
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:06:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vgo5MSpd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780419990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ukUSWAZT5k7G7XbzmUvOStOIMgWiMG+ApVUWmOXYOU=;
	b=4QZ2NsF6jU9+IfMqYKYxAJGoP8LZOhRCDz0fYLkPkR1NOQoZ96l7NyEvmTN3Oiwg3JK2fi
	P9FrDj7xW6RMrn0ppIsT+F1apzqXTC2Z7SLrkyGsD9+PUKCz5SPm0LVkL6m506i4uDzi6g
	Mq+v8LpzJJC7dqvnvSxumEZyobZlGYk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vgo5MSpd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780419990;
	b=3Ox0xIP1IK8BiMwCIzGI+GvcZJga6oEgxpeOBEJoH2GCrWPM4fBeUayxX0L+DvUs5TSyX8
	Uo/lAXa85z/e6J78QXZsJHMHme9U8lClJh9OzlYZRac9d0CQFwQjeTfGwTrVWtQYDHrdJV
	EHYpSP73UJ8XvTGnT4b9N2gH/QRXuGg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DE4A440245;
	Tue,  2 Jun 2026 17:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DDD1F00893;
	Tue,  2 Jun 2026 17:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780419989;
	bh=0ukUSWAZT5k7G7XbzmUvOStOIMgWiMG+ApVUWmOXYOU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Vgo5MSpd5rLUICJbwSXXMHlNmtOE98kKio8rRf5wUvLCLyHS64u01h5uZF23YS35Y
	 ul23hEGvUhCtar+qiJ8TDD0D/rb//t/aJ5trAIHCY70bhUOKdEuH+hRiD8YDcjiWZT
	 dTHQQnx0Olyuc2ChrMBZn+VGnoUSWkc8GoSr5jw/RXHv8bo1SMy1jEUdLuU52Nibei
	 khBSic3ISmOTQ7SYPfSHyNNnjeHN8cbs3C6YSjFY4eeCU4lWx9JihATLPpPW3ytYgL
	 jAPs1BmEuxsiiYf8dHovSR7nOwG1R7v6QZgPCsEH6zfrWECQAgq5NchWuIbFMdEexY
	 JhISPenXLwOVg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  skhan@linuxfoundation.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  corbet@lwn.net,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  skhawaja@google.com,
  graf@amazon.com
Subject: Re: [PATCH v5 08/13] liveupdate: defer session block allocation and
 PA setting
In-Reply-To: <20260602031717.197696-9-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Tue, 2 Jun 2026 03:17:12 +0000")
References: <20260602031717.197696-1-pasha.tatashin@soleen.com>
	<20260602031717.197696-9-pasha.tatashin@soleen.com>
Date: Tue, 02 Jun 2026 19:06:25 +0200
Message-ID: <2vxzv7c0dg8e.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 9984C40010
X-Rspam-User: 
X-Stat-Signature: 4mpfigrbkz4w884c8hg5ndttbfkx9qzn
X-Rspamd-Server: rspam09
X-HE-Tag: 1780419990-538829
X-HE-Meta: U2FsdGVkX1/DOyA+6tjK29BcTV7toAKrSRJJODF2BtHNHIjNKgGi7hMsMdLKn4lGo0VzDk0uulIb+9rQKPMGBLnJtlGdXYgbcMNZOUWf5jprYMd19ZHoXEjI5PWssh1pYTns3G4w0dfQiHbtIgLoSIObmi9nMWdWeCsLmVEc4+FR3+NgETVVlSCgabFtGgy/NAc1LS0QPZWP78rwO4ghBRfVVRib8uRRZCC1l1G1n/CG6f8nTdsy2XFwTz8brjapVzbHDyv/xANZ/vLgnBL9ExofiJtXANxMPlZoeX68EsyslHDwZoB6VQ1B6EhsJ12ymMsFlnS8+JaO9AED6DI+tWNPi+hxaAbP/BoK3xp9PvzFrxHI1VyNFQIBqVsdc6R66MYA+DYveKdgVM8RclpNEm0hjkOHNnqa9H0OzqIxDx/T+J1iMnzUKPj4gqFkDfG0tKTe9F/lOUNRPDeW8yxS39n74hx2G5NFdTkQCVVpWujUse4TQjF6ArIb8Tr/HzgtapWHP1MHzpwRZVK9/CkpyaADYE5WkyGf3janbsbFV+7ZbxndZ0bULTpKatQRk1P5PZrIAcxOXs0KsthsuNUvbIi3clQgQPGpQJebPW4qtVhJCE6ySXtdDwIA+cYwHQJbm4Y8pId8EivRqiN22sXWDdR8Cct92eM0BzZuNNBWXXRp/BHTX68EatMkX3LHms/ovg0LJv53XV8ebjIJSdWxj8iHngAbRs2tJY6kfHihxAAnRSgKb5OdH89zzNNH4iV9K/0y2m2Mfbz0Vj8NA7c1MlZ+wkYDzekiC/wQn9YRqBR7WJ02l0bl8YtZKQkPx6r0V56QZhie7Z+AJ1qGAPQTk53e+4WS39IHRTLxrdcU8JVK2N/a1Vs/CLzlJ2AMTSV+lp89Q4P+fdvvYqqp/FVXONKWKqNx4gZZlLIrVFeK9kqhHP/qFAFO1/x64D5VZdQYxPo9Nrc9WUyE3fGAHll
 +tKwnRxQ
 5ZCgcv7dGtC/tt76v5yoJ7OlM1D5kYz2IkuqZzFQ6Af0dxLGEOWrpclKrRkU1e9chYg2+V5gnuFYaRGR+VG3cKAIq/cz+I/6aRxPfaWkEvjJeCkASwjRpcM19jhK9euF+RktGvwAdnGm0lReSwAvFVWLFPhrb8dNRb+30yIiRKTyYxMPWppTLDlORhWsRcOF7WvsxVeNx2DOzz1e9BuoAqZ+lcZIic5HG6NJMvppP4XETrlp/9VDoM6EeRnizbiNzTxJZKggvNvoTEhvkyBjpazwqvIcOgg8Ov+2d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02 2026, Pasha Tatashin wrote:

> Currently, luo_session_setup_outgoing() allocates the session block and
> sets its physical address in the header immediately. With upcoming
> dynamic block-based session management, this makes the first block
> different from the rest. Move the allocation to where it is first needed.
>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/kho_block.h        | 22 +++++++++++
>  kernel/liveupdate/luo_core.c     |  4 +-
>  kernel/liveupdate/luo_internal.h |  2 +-
>  kernel/liveupdate/luo_session.c  | 68 ++++++++++++++++++++------------
>  4 files changed, 67 insertions(+), 29 deletions(-)
>
> diff --git a/include/linux/kho_block.h b/include/linux/kho_block.h
> index 505bf78409f2..0a8cda2cbfb5 100644
> --- a/include/linux/kho_block.h
> +++ b/include/linux/kho_block.h
> @@ -70,6 +70,28 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa);
>  void kho_block_set_destroy(struct kho_block_set *bs);
>  void kho_block_set_clear(struct kho_block_set *bs);
>  
> +/**
> + * kho_block_set_head_pa - Get the physical address of the first block header.
> + * @bs: The block set.
> + *
> + * Return: The physical address of the first block header, or 0 if empty.
> + */
> +static inline u64 kho_block_set_head_pa(struct kho_block_set *bs)
> +{
> +	return bs->head_pa;
> +}
> +
> +/**
> + * kho_block_set_is_empty - Check if the block set has no allocated blocks.
> + * @bs: The block set.
> + *
> + * Return: True if there are no blocks in the set, false otherwise.
> + */
> +static inline bool kho_block_set_is_empty(struct kho_block_set *bs)
> +{
> +	return list_empty(&bs->blocks);
> +}
> +

Are these intended to be here or should they go in patch 7?

>  void kho_block_it_init(struct kho_block_it *it, struct kho_block_set *bs);
>  void *kho_block_it_reserve_entry(struct kho_block_it *it);
>  void *kho_block_it_read_entry(struct kho_block_it *it);
[...]

-- 
Regards,
Pratyush Yadav

