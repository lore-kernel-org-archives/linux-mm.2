Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB075CC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 07:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 478E86B008C; Thu,  2 Apr 2026 03:12:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4029C6B0092; Thu,  2 Apr 2026 03:12:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1EE6B0093; Thu,  2 Apr 2026 03:12:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE566B008C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:12:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0B4DC1D7C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:12:51 +0000 (UTC)
X-FDA: 84612748542.17.EDC164A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C58FB40003
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:12:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jGfS3F91;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775113970; a=rsa-sha256;
	cv=none;
	b=PnRQWgxqKJuzA5GcHzQKmT0JINxE9B6lSBJX1mJdzawSd6IfeDg+XsdoA0O3z6O2hwhS31
	SQcSOy8S0YO9auCU6Dwdb5/7wZ7KY47XkjDvH7baYXQnIjnfjAAdp7NC/jla/jHQr5qBQ1
	07nyecemuEijlEGqrNa9o+3F6SVKl3E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jGfS3F91;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775113969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpczcsXZGJIU7Skyb0ZlPOibX4vuqbE4hKW8Bzp9Wy4=;
	b=j241iW7C/qXrwtnZ7CymjGoqtI8uoP0lWOtLJ81EjJ2+Q3xHpuSvhSdIYwOd3veyYpG6rq
	ro4ZNp9s0q+Fd6xctiV+VayZBZA3tWu8xhio+TYHL8pG1OXenn7SHG62yX85nx30DL+WSo
	fmXz1Jm1DnIzSN+DnrGfr3UmjAVV6sg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E23B143663;
	Thu,  2 Apr 2026 07:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8AFC2BC9E;
	Thu,  2 Apr 2026 07:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775113968;
	bh=BJ7G1vprBsIyT3FYtQ34wj6oP0cMHfpJpEKWCFbgSgs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jGfS3F91jc3XZB41jeFJHbPVRBdTx+uHPlKN9ZoudcWZNibkZ+9WoRftLhMGfnMdc
	 5pRRmelMtFS86VKZxI9qwMLFuUUlJ0R9Iv5kSBPog5LrMaDSQGbLfKYa+tue2UenOD
	 lFuG0g5mWbPuRSrLGeLpclbo78mF7beDFDLQ/CsaofyJwFUe2Ais7Paqwl16r9U1bv
	 QIa5ibxk+yeuaUi+9pZ3s6jWbgfBC786WqDGze+R1CL6MgU4PiF03u5Iym8iM18OA6
	 1tqFyUSTz1KSEPuGEvPXZ9OZkh1ZN3KHvO9r2QRWh9a8KpubYJAe7K4qlTVOGeJX9T
	 OAODRvDrcQznQ==
Message-ID: <c41d409b-39d1-48f2-a29b-a90cb94a1094@kernel.org>
Date: Thu, 2 Apr 2026 09:12:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] mm/page_io: use sio->len for PSWPIN accounting in
 sio_read_complete()
To: David Carlier <devnexen@gmail.com>, Kairui Song <kasong@tencent.com>,
 Chris Li <chrisl@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>,
 NeilBrown <neil@brown.name>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260402061408.36119-1-devnexen@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260402061408.36119-1-devnexen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ciqdwc9eihqkzh4htm3r6ybkio5mhd5a
X-Rspamd-Queue-Id: C58FB40003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775113969-799143
X-HE-Meta: U2FsdGVkX19azHnAJpPLNYhn1amYjCR9kv+0Cmg/ArCZXrrhulQxN7Edrdx+BCs/SWfs794kxMhWAQjYO9m0td7ayJwrRM8FwpoFjJTgLC+ZrLCUNw2hXFsLHy0mCrpKS9dRURwh6byrMxe6RIiPzLfiZXMeLbsMRFuK9Zwa9vHbray6rhiYv2sD+UEU7ZZFfBzC6VsDAS6kFLmdAKVE+tbZot4F7VPOFTWvqcJDTaxqTIELNScm01X/c/uw3G7wC66tLo/myUvAai/yG6EAbMaQvxH9zG7mT6FSzKKn6jLqPz32gkHrjvmmlr89oRHMNobJwL7ChNevcqJl4jMdldIhcfOsWawSvQFySxqjyTsC/k9HIlulC24V6MvlxyS44jRHcsdc4sO/iM439KbPs9KbnOwwzdbem/9Ij+67dbvTHsvl9EeIa7tyl8G33jnE0kyv5Lb9N9wYOFbyn4RnHpFJ+74Wsr9A/5V8pyiVOEpiPA5tvzCkXWFsAr3hvmlXLLeu76b6Il0VxFS6R1busqR07xAydR8jB6CVW0a267VIuAL3y0TuC78dXNHum1RwLpAr0Liyo+fDqzqH+2aQ2OpIEPX7TG2CmnB63yznzzddxV/72oiUda4aIvUIQlmYEQQh1o4UJIqhfmlw5mcMoPy8XkYI6/p9dSeNQtQYhkaOu3LZlaEdz0C6njrDZMhz+IXpDmFbLPRuxUDBwZX633tcAgy+/t4mgJ7HuHztChvEKp7Kwz44Kd0L7L27WZbm7JxzQMgWekloqySP16XDcnAPUcr/alL7RgMsjzQjhJvSAngoCd28/jv8z/PWOkIeyzL2fzOl9ZHX13SH8G7rmpGRccZ6Vs03kihAOmdthfq4U8MbroWOocDDdd44J8LRscblHz3061+U6myCMNwjMUnyUzd8sERppF2LbTf1DIoAtZqWu0dPTDSngpWHGsU05oHtNgrXOK/D9qRNwew
 buGDD05X
 3garN9wAGeJ6NbQtgrUgjUas49ylAESRQHxzgwEtxzAPl0m6FmqhkHQAPHNrS4WvUPNfm8y5TXSyXMIlS3h17TwWnoXlejjPTuJ32EKjErRdEb5SlwAFIAw//k8PiFYhhUs6797XxS7Jq42NmAIqZsWP3imWHPGlSTMBpr3yCT95UYp5XIVhzM97AIf9zvc1Uoj/C3qGSDiPTJhLk5NvmGdGC2krLbr7csp37oO8OUhabHRMpTuaFRvun5gvpWmQPVs0i6I41jwHTIUnmshav26++UyoSeFLi2mFZcJuZ58EqCzI7MIJeRRYTsAkTSkFe3yMJfyqjLyZxAQ/jJicojoG09kupuB3NvzqX+jX5ezZhMm7gU0ZhRdF+zQiLJ11UZmpN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/2/26 08:14, David Carlier wrote:
> sio_read_complete() uses sio->pages to account global PSWPIN vm events,
> but sio->pages tracks the number of bvec entries (folios), not base
> pages.
> 
> While large folios cannot currently reach this path (SWP_FS_OPS and
> SWP_SYNCHRONOUS_IO are mutually exclusive, and mTHP swap-in allocation
> is gated on SWP_SYNCHRONOUS_IO), the accounting is semantically
> inconsistent with the per-memcg path which correctly uses
> folio_nr_pages().
> 
> Use sio->len >> PAGE_SHIFT instead, which gives the correct base page
> count since sio->len is accumulated via folio_size(folio).
> 
> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

