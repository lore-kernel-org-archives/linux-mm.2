Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33002FED2EC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 08:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA76D6B0088; Thu, 12 Mar 2026 04:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55646B0089; Thu, 12 Mar 2026 04:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D665D6B008A; Thu, 12 Mar 2026 04:19:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C29A06B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:19:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1944BC29A0
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:19:16 +0000 (UTC)
X-FDA: 84536711112.25.AF55FFF
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 45F851A0010
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:19:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hTDXSDhI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773303554;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0emWzhuAhGO9LSYg2p+g77BXTPv/gBf2HjE31Shudc=;
	b=5YKs+RW1ugksvnspXHDEBx0sJ5zTGJ/rMtpwxb2KUy8fPubaaru0wcHtOlvUAUT1ihdCY/
	tTbJSdE/PtAsUZJPmgkxUB+TIES5LokWEiFCJLw+uTpcasWgTSYbYWfaSZTRE8kjT52olP
	O3p5dsaNZF4vUy8y7bcVtjIa2aQyOSg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hTDXSDhI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773303554; a=rsa-sha256;
	cv=none;
	b=U9QArJjigAOBTxyv/eFE6azsCHz3TOdg+7tQnVPyQ/+r0ngVlBTepiA3u2EMLIRzi7hq0r
	Qs+VL0s34KjRrhYHClWjLm1U7zDk3tFwBzsVk07YfQFo+nHcboDD9N/lPcG66z7XDUNYZE
	8djU3ZypYgV90tOMcgTG7pj7go9Sm7Q=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-439b78b638eso772346f8f.2
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 01:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773303553; x=1773908353; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l0emWzhuAhGO9LSYg2p+g77BXTPv/gBf2HjE31Shudc=;
        b=hTDXSDhIdd1x/U9F5DqDbr4tjA8m1wgsknYyvK/t9+NTsOBRN/gDXmefzKLhWdItEE
         CY9PPeAdfxpcCnVzNT2o84oUkh9VXVNZZSKK4USlCXArmjMxRz7aab7gJh73zefkEz7m
         LPnCQHZodqw8fMGJje4VKurDgVfIAmHLYYVl+Y4QfJVcRuRjjGjkizUvr7i7lY66xu2t
         Xcum5L9RC/dA9ftDz1CfJWUfgAfBQIEeII1hTGr6M7gCfGsiUMvTtmWGsSv8EFbwu4CL
         VjCgfA0ewTovNKxtBNmUxSQm067aQN6poDjuRbNEOrqC6P6QLHC8m1+gvb0MSzvCz7G6
         qinQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773303553; x=1773908353;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l0emWzhuAhGO9LSYg2p+g77BXTPv/gBf2HjE31Shudc=;
        b=JmJ5MVCkr/jpcADdtedx1GuERdFZsbk/oOc3fC344814sFTBXwrx6RXc9nem3c3V+T
         oqemTt3QWxTuyW2hfBaaGbDp1vZ6kUwdm4UpGYjWQNDgqdHsf4mYnARcvst3EGxvlfsl
         svKWv0MlEJNOnSPR104xIcr+M2v9jak9th+MV/YO4/DW45WaSWh5TmwZiBYyby9T4Nfn
         hIyd7bXZAlLKpKlpAYLLAnix+Ggqd+fNFUwBMAPTypkwW/+3MbSZ6oa4PUulRDvJrAUU
         uTzoDx0u28mFY3FBRMcD5h6gu/vWORjSt5RnRGRwcrIoFOaFichQa64oe2LUmDNmEG8P
         RSEg==
X-Forwarded-Encrypted: i=1; AJvYcCVs3s59bQJkOcHNtBtD0TCcJzwPeuez6pvMgeMEkhxM2svDr1LmySjhHY/0SWe7MuIg/XLwc/VcaA==@kvack.org
X-Gm-Message-State: AOJu0Yz8FV76euw4W1wlV8O8/trC4Mz86YbmtQpInkx8/3UhTsmHNPu4
	1HxCSSPMtsnrgCydjXFpFmtbIBB3RNjrQru3v2nl0XOPqg4LTxVaRSh8
X-Gm-Gg: ATEYQzyJeTpG8Vl8lSbXES+uRUI7nnVgIIhKyc8m5gPkAVf52xJc1g0E55EIiLoevZN
	baohUa4HmqEaYwqXxyeCY9MpfEQjgLHxAesZB6s3G8hxrb/u3z1o5//Fx95bzjz3tewpbrSxpkA
	4RguUCeZQfBVt49klWn8nfclW4GjLUBZF3zbVd5GITcDYiRum87p90nnr/I+GrqpLeRVXe3vTOS
	4u4Gg9PR5nXemV+QjHQxHtqMdybdgjTiBsg95TE9NLlbO3Pz9eOsE2oi/ePomQc8uLTBVzrVO2A
	GHNFNLI4dWgW+3VkLpkqeYyvTKOH94cCFFQD/hF/bshWW8jhlcwcI4I9P8RP3+pbtUkHyrQhAHm
	e0LwL9KoAd0nbtLQb6hnVxqG0U9iYQ9kRh3e7wC4EthxlzxLQR2wBbd43h+FKjNZs6cugPGEm4q
	Hdbao4Ll0z/Ni9RmG/wJ/23Q==
X-Received: by 2002:a05:6000:200d:b0:439:da0d:a028 with SMTP id ffacd0b85a97d-439f81f27cdmr10680722f8f.26.1773303552362;
        Thu, 12 Mar 2026 01:19:12 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe23afc5sm6843600f8f.39.2026.03.12.01.19.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 12 Mar 2026 01:19:11 -0700 (PDT)
Date: Thu, 12 Mar 2026 08:19:10 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, david@kernel.org,
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com,
	weixugc@google.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
	pfalcato@suse.de, baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com,
	kas@kernel.org, willy@infradead.org, yuzhao@google.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH 8/9] mm/rmap: introduce folio_try_share_anon_rmap_ptes
Message-ID: <20260312081910.ux6p63qtde3r77rv@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-9-dev.jain@arm.com>
 <3ff22f08-5617-4c05-8fa0-1d808806e322@lucifer.local>
 <aeb28e78-4943-4330-b323-799dd80207f2@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeb28e78-4943-4330-b323-799dd80207f2@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 45F851A0010
X-Stat-Signature: erze6ha8xcd6jsqoy33g369fg8q5kiah
X-Rspam-User: 
X-HE-Tag: 1773303554-178048
X-HE-Meta: U2FsdGVkX1/AOGVsR4pI12W0OGB/wm/bGkb2bg8eHs3lZqtmV6AEZHA2I5jzs4JNhOH78BjDA1PVI7UP0C7EsOXGKIwVgrfOWYy4b0L80iDHADFkhxlMRD7ws7ZvT8fWAnciT8PB5evzsQwtifzIyAnK6Na44jMyOF463e37UvrfP5wLZrz1w9zT3iyRKi6rNi5SQY/jBdUSfI1S9r8CbepyaK4PVX5q4JX2jNVPvqqUaGy98rbhGxAqCiNiOW4sKp+0nM2XINde57Da/M5xDabJ/IEZoiwfxcIxJbfDNhthJRIwjLqk0LJ5uTVQVx7zoqO2mNs68nEhssrXKVQVl2Y2uagjpNY8BYqPI4QRlzyjCLi3VTpsLaRX5F1rAjOdD9D1gIEMxjZpZbyHHkxcmHNT/VbDGR8QhyYiPK6DqWPaI6mgfAxNdMejYx4VhY6W0NCJsNZt4yKgGvuj/7v5CMrOwMjTpMC+wBWJWfse13Jmz+bBnZSWyvp46cGeiqR9VZMJP5YKyzKuOWL6it4xrHZ2Gu2hCW6ybCdysmC1TNCpBxjNanp4mUAgTiW6BBs4tyT4goAq/nnig+lgszH77Lt4bjZkWbnxzrU53tb9jUijZ+185zTh+BTdx7g5lTP41uxmaxhKgAMUfb7dR/9ItwTmmoQ0IixHHgxuF2nG41pg+Go1bdhxHqRUNkctRxrhAQ/iPOBNHfZ+p1omfze2mCJLWAwgpGuZPHnolP7KN8nfxJx81jrPNA6/h0x1xpKY6sZSZLGhM2xUfEpBqPqLCoR4cIjgn2/MrpAqznL2Z7LYk0LkjDQZYlTNRe2DZFOndVtbj/Z96834zNEvaqEuAdOqbnEcoXlqZQbISE5OydAvvTfCav0HMneYZaVLJxBr1f1011pBud8qYlv5EUFdseteX2ybp4ZGjxoMokusHVFxvuKrTeCSNpqx69xWEf2h+y9BvfQguOdsh2p9ti2
 tN/jQJ7z
 N0Hij+St031MWhkSPN7qKkjEWwioRvNuB4dwwFkxjfr8NTWS5s3SaNIdoYX2QcDKjamGCzzdETJNEyaP2b7bEww//h385/pE5vPQAv9++AOOBZaT4zSi0iT8nvL9GgLZkyLH6QmU7GWxqbUX6HMMLFfyraTF9TlSs5N7viwMqHrYXsWQVGQ2Rk6SFB8I5uwhoFbqp7/5rfmYTrSSbcLUg56txyM4H+qxTMA0UfCXMi5JfdBZuJ9l772rUpGKEpdOHbClezSMAhVCfZ3rtLJricZgxLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 01:39:25PM +0530, Dev Jain wrote:
>
[...]
>>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>>> index 1b7720c66ac87..7a67776dca3fe 100644
>>> --- a/include/linux/rmap.h
>>> +++ b/include/linux/rmap.h
>>> @@ -712,9 +712,13 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
>>>  	VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
>>>  	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
>>>
>>> +	/* We only clear anon-exclusive from head page of PMD folio */
>> 
>> Is this accurate? David? I thought anon exclusive was per-subpage for any large
>> folio...?
>
>The current behaviour is to do this only. I was also surprised with this,
>so I had dug in and found out:
>
>https://lore.kernel.org/all/20220428083441.37290-13-david@redhat.com/
>
>where David says:
>
>"Long story short: once
>PTE-mapped, we have to track information about exclusivity per sub-page,
>but until then, we can just track it for the compound page in the head
>page and not having to update a whole bunch of subpages all of the time
>for a simple PMD mapping of a THP."
>

Thanks for digging.

One tiny thing:

Now we have a comment in PageAnonExclusive(), which says:

	/*
	 * HugeTLB stores this information on the head page; THP keeps it per
	 * page
	 */

This may confuse readers? Not your fault, just want to point it out.

-- 
Wei Yang
Help you, Help me

