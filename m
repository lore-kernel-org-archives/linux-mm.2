Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E044FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 00:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAD616B0005; Mon, 13 Jul 2026 20:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5D626B0088; Mon, 13 Jul 2026 20:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B739B6B008A; Mon, 13 Jul 2026 20:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B7736B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:16:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB6821401D7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:16:52 +0000 (UTC)
X-FDA: 84985466664.25.FC08ACD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 53F57C0004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:16:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e++cUxvx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783988211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D2RRBIAKbXI1A5KhuqvtfHAInMsdKXSK8xayxkBELkc=;
	b=AchzDc7HIEDdZ+kFyxA2QqE8JeG9kttX5jZqEG7pYxfSTgmvoUrQrnbQP2YGhDfP+J3Q5Y
	5p24NvyP3TknlXzh6622SvIlttueHPY8maYh9tMp5vh44R7Pnabguf6BKo+hUjXTxIQi69
	ptZcdlHoJI9Rup1EwJK8pTZAWHvCPDs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e++cUxvx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783988211;
	b=qMwhEoZyBfR5/b92voh5kd4+tsmhjMppySNEG4b5QWbctTUKvOw7/2EGJXwLb1ZxsURFz/
	TCW/HCPdp760Mjeumy1sWtCiT8EV67oEnoRx191vCxeonOVUHCkTNbU7YXaVgmbUav5GBT
	InlBOLIWzl8DA2xFhXMWnwznQcDllQM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B7FB860103;
	Tue, 14 Jul 2026 00:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D181F000E9;
	Tue, 14 Jul 2026 00:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783988210;
	bh=D2RRBIAKbXI1A5KhuqvtfHAInMsdKXSK8xayxkBELkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e++cUxvxNWQaLZ0BBv8TJI2IgqicvGQHtllcl3e8aUrc86UQquG+l6TghhlerW1Xb
	 bJys7LF9kUSNDWsi7UrgNNggvworJmLOqBEbMFcIKWKiH7xQNxDi3smv6FLMefqoZo
	 I9BN6bE4cQC3Ah3Av5dIoQ38P26HWG9pJSSigV0eVrcq32OYYi6wESKu5BUDtxk0fm
	 GlGf9D7CSipCKhcb4CPtRH2Bay8drqbZP8b1HUoiFXO0r4JlszsgcnRFfgNRhGvsvX
	 bJAYytdSczgfeB4k9OOvFf2wKbrlHLBV1COUE/Vj/22nF3it2RiYbehKnw1J0FFTda
	 JmDyRA/Iw8LmA==
From: SJ Park <sj@kernel.org>
To: xu.xin16@zte.com.cn
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	chengming.zhou@linux.dev,
	qi.zheng@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	wang.yaxin@zte.com.cn
Subject: Re: [PATCH v2 1/2] mm/mm_slot.h: add a helper function mm_slot_remove
Date: Mon, 13 Jul 2026 17:16:36 -0700
Message-ID: <20260714001636.85603-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260713143707966lCkTinO0i9zYAc1K2ZmqZ@zte.com.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: txxqkja6uk8b8gxg594wag46q35okmua
X-Rspamd-Queue-Id: 53F57C0004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783988211-280951
X-HE-Meta: U2FsdGVkX1+P3DuBmKIbvCeRM6AGtiaE4KDmIyFuJeRRfZKwtp2e66ZrwB+9dBr0J9FXgb/vujoWVVXMDsZo+lfDTMB4k36RfV3TnVQrWErAnMEhBLZXTSasNlBMbHpIozylX9+/bB0phdfTbr1sJju0Q6hAQEQ5fP+r9kZoqJZNG6GpGY7W+c4RoL7B45EnTQgAG1x4TeAP6awoR66htwW85WUl5KAB78teCP6frDtKZsdeO+0L7jV6QpUbAKaC1ybOeMwHka5M1qgEE2mv+c42Ho8fRF4RrF4jkNh3VQgCQ7W7EO3sOEEGw2iUmm3eMSgaGfs89Y7sGQi/+qGFuxdSvTUQWzadVsh+MBbl13SPrHaP2k+U/vmM7ncGo1xYfhakaDRm58fHcva0BaEmOMimoIvmctjAYhzcSbKM+GJj6Rk6ro1LRYOmtp7evPEwaNpc9emuKmpLwV2ifJf1YUVKCXVwc9DtW81jj1XZkzNApHp90VdtAi51Pi4LlwRYybjCjgmt1XSomIAiDa31SzG0Y2s8wqdWeRcDH12KE2/HDMu+T1NmlLX1cUT/oLeqEAasTSWHu7d3O65RoQBHsCjf7aarhj4m8yUmRJObgbpaIoLobvsQWOdGpGpMye6pMbErW/V1pekOwQhokfIHGvwKhftB+70O49gcqOLpBfmxkz5oVfgN/orLNxyuRBXo0EO4ugWjPo72qWTBXJZjmP2/rdeUbm4Bd40VXNuIzDTeHSiF3mjtt01AtWQuOwMwROCUgOV6gRfkeRN/JPIJ/mKWTskxzgFePJMCqTkjowBGziqvgL5IUJEkWRqViJUaO2IOOO1yAD/QMv+aic0X59nmwe0wsRjd6r10P6FnFRbQTgQFlrQRCMRvgEQeCfHTJhFgbnLt+NgIne9Y/V72QSgMOcq0hHS8sJHXLbxXdbPs2PSphJEhcm7P38WVMbNAn23uq3c8kv3QCi9bI7A
 5QYa2xl4
 JrHJ8+zbZVbwCWhvB5Mqwtr2QsSmLGTtTMGzjZJnU1Qd/s05j6+488wQyADqMboTzj5xT8rGRyp+toeP/iH2fpXPQI83bEDGZOoG8G4DPsKQvONKxT5p4t8bU8XyVLtBPjJdCNTUMlwPN2LsIuZ8JOoMN6+CTQgseChMJOCfb3m3xiRSKVp2Jc2/UhtaJdmtr8E9r+qjgYVsi0uUwGoSxUyWFkdmfptSzEvThc64RFc5ny1omVPepy7Ip1RhSBWqjV8KiXsZL+yTmJDONKa4Qs4fsBOA9f2yMqaVhwXciyiMB6Cpp6vU96zYGMbFBEC6wsHdQv3CGGGFkfIALslsjxnc2vQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Jul 2026 14:37:07 +0800 (CST) <xu.xin16@zte.com.cn> wrote:

> From: xu xin <xu.xin16@zte.com.cn>
> 
> Both THP and KSM manage per-mm scanning slots using the mm_slot
> structure. The slot is kept in a hash table and a list, and removal from
> both containers requires the same two operations: hash_del() and
> list_del().
> 
> Introduce mm_slot_remove() to abstract the common hash_del() + list_del()
> sequence used in both khugepaged and KSM.
> 
> No functional change is intended.

Looks good and clean to me!

> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>

Reviewed-by: SJ Park <sj@kernel.org>

[...]
> --- a/mm/mm_slot.h
> +++ b/mm/mm_slot.h
> @@ -52,4 +52,9 @@ static inline void mm_slot_free(struct kmem_cache *cache, void *objp)
>  	hash_add(_hashtable, &_mm_slot->hash, (unsigned long)_mm);	       \
>  })
> 
> +static inline void mm_slot_remove(struct mm_slot *slot)
> +{
> +	hash_del(&slot->hash);
> +	list_del(&slot->mm_node);
> +}
>  #endif /* _LINUX_MM_SLOT_H */

I'd prefer keep having the one blank line bfore the #endif.  Definitely not a
blocker but just thinking loud.


Thanks,
SJ

[...]

