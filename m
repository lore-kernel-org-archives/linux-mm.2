Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E23CDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E89EA6B00F7; Thu, 25 Jun 2026 20:44:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3AAE6B00F8; Thu, 25 Jun 2026 20:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2BBA6B00F9; Thu, 25 Jun 2026 20:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A93136B00F7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:44:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2EB5EC19DD
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:44:23 +0000 (UTC)
X-FDA: 84920217606.17.C460BFA
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4AB6340007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:44:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NeCgKQHT;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782434661;
	b=wY7TRtyxHqdY0HFdTsHkO+sGl3dTihRxbASGJ+SagckkzTMKPtajtZjcbW4TiQXn5YHKoe
	zm+hmR3RHZ84Pm1MGCHj8HZVDLJU2IDeSqIaQYVAqadbdAYlPXCbW3CDhAyMUzgv9FfRRN
	kZ/5bfTkvLvutvjSXe0bmdZo+BD59kg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782434661;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rIoxXZTpiyNd5JYFa4lQt0gUtbR9irnlA4zKsBOidWE=;
	b=s67YCOfdAKUga7WS2Xsfe7DgU7z6LZ6VeFnT08w/lElLUI4bq53ACfwa7CaMjRyuPdJfXh
	0vDF1PhfL1adJP98VQ/CsOQkMm/Kfdb/6ANYfb/Yej/DWCKESSERskgvWCDETxp1+j99BI
	n2kWL58eG4KxE/ziToxZA1P2JTsA3Dg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NeCgKQHT;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c0115a3794bso69552266b.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 17:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782434660; x=1783039460; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rIoxXZTpiyNd5JYFa4lQt0gUtbR9irnlA4zKsBOidWE=;
        b=NeCgKQHTy4iRzhRLkffuDbX6s2b9Vwr1H31yos0ET2RHJXgx2bXpKvU2887HsTcd67
         812goaIQk+cBLgAwbMyRnpXZ6wTHlLCPqDc0Iili67PUmsJSiVQFlywN3OszBwbLTlkP
         jtDPYRVHIFpVtq25UUQeIyiTktiJEc5acAQ8b31BA0axlCw4rIBpc6OT0kXtklMLHdVL
         1twfHjSUTTIJgZf69ctqEL5Y3GkaEab8qtKqqzxoBtogCKzYPba4/tCI7bAQqp29RwB8
         LE0msCI7Ht/SGUGVvMd3A8s4sjFCSsA+5kiVtsJ2JMPSSveO+fG/e3VLU2L9VAoZNWi0
         Rhbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782434660; x=1783039460;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rIoxXZTpiyNd5JYFa4lQt0gUtbR9irnlA4zKsBOidWE=;
        b=gvib+NJ1dhBhrTVVL0xKzXTfGj0GNw1qpik7a9IGu8vRFTrzVS0QA9UjETUlvU/tU3
         zMn9iO8WE0Q+JDZ2Lobp4jpet4swjydXGl7LbEAsn8jmRaJzZmz1ojBe+2pwGu/AfnZb
         oTt+Kk1BLmXiHqwcUhZHTNVz6+F0ihlGko+tfMcLwkI1CyWPp7uj+eTnKonVeY19ixmr
         uHXndyG8kQABG9xijwsQblQAWlLF+5MSFF9EONVfbh+wNXVLKmh8r0/wf+adUdu8HTmD
         XnvnHXyVtCwxSVL8pAQfDjbpCbmzIKaRClyA0dgI06Hwpo92IGyn4IQnrjjPKEqyauIw
         2J1g==
X-Forwarded-Encrypted: i=1; AHgh+RrKgs6CPPcXPTBJ+CkKC7mDRvQEW58UWKVVBdUjBBWy29v1/UZaT3LwERH+Lxypc0Ng7IL8x6Q4kg==@kvack.org
X-Gm-Message-State: AOJu0YwlDhoQEd5WXTkh8aDGlDjb2s5ywwDgxc949P5qsLhMrPi8ZrJJ
	e5SwlVS7TRFKtyYn8Q96GaSEVwO0sptlwLkfUqiEjkRMK+a+zlvfXPrc
X-Gm-Gg: AfdE7ckHvWeq/RCIj+Y/W7sunqXHcMcwIeGdLlQxdZgbCpVmDBW3HnHoNOn7M1c71Id
	RAMgdRWh3INlp6ONK+dHeNn8LkwYwa7nc9scGVAflITLJ2i60y7UnCW+ihknBtW49SnQveNJgfj
	K5GVpV77wDUwCfWEAHADHfaGH4FWqy161pgVklfuFJYL++L7XwXhiOSIuhuW49GrqxEevOZGuIf
	ElXIvWOwlJCp+EDylLQLdDC/HyccMRlyuuVRHt5fqJHCGMN9COHB8WEfhqpI9IMXal/ZA5rXjS5
	smx1CINx93I7i10SIxz9ZZ0sTMJSyCqmL4SQB8dissPlJoMKacjNTMYe6cw98v2PIUjiFlwaCOO
	h/4WNC0yXQ4V9JANbzL1Pl3Dn+Z+Z8CNg8AyNlFRd9Y6q31eFOrBTMG0LC9KWHXgj02xm42XEQO
	JERO0nFUUzWx9LNO3FudTWRg==
X-Received: by 2002:a17:906:2081:b0:c12:20b0:d8eb with SMTP id a640c23a62f3a-c1220b0ea52mr34718366b.7.1782434659530;
        Thu, 25 Jun 2026 17:44:19 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c11fbe06543sm261224666b.29.2026.06.25.17.44.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Jun 2026 17:44:18 -0700 (PDT)
Date: Fri, 26 Jun 2026 00:44:16 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, riel@surriel.com,
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
	jannh@google.com, ziy@nvidia.com, sj@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private
 PMD handling
Message-ID: <20260626004416.vm4funxhn42hbi3c@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260624065353.1622-1-richard.weiyang@gmail.com>
 <38410976-ddac-4848-a4ff-e6a9f7d9c828@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38410976-ddac-4848-a4ff-e6a9f7d9c828@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Stat-Signature: bxiunfeu9yftp1eb7yxtrfw85saow8em
X-Rspamd-Queue-Id: 4AB6340007
X-Rspamd-Server: rspam06
X-HE-Tag: 1782434661-274085
X-HE-Meta: U2FsdGVkX1/xrf9Bmkv0PFlopN+SOAX4JwDPoF+zG5uSpG5W9kUWQNhGFKuprCKgeDJNCobUESHphENwZ96G+s59qUR1da/3fErW3DjXc5Cg4GycvXW0Ewbj3EVLSV2tp+lkCMpA6K9jgeaOC91t04UtMIHKv31MLjBTx6+Hm/HfmM+8xGB7pzd+KgwUG1PTXL7+tMh2a3uQ6QfXAqyBdyb6Ke15z82+a9kFfUob1VkvzQLz51Kx+jz3X0RYLtrYUpbF7YPy3Epwm/95H2QJAnNi5bhtV4U1mm8OqMgjb3bLHhF0GaNw4SBw2KhnFjad8/u38u1U0eu2pv6Aw350zri0zvL5ITeScoyrpohNpZTfv9GnV/C+j71+Uvj8VyX+eI+R5PsNw6KMteHi/Xbm8r29Xb36uMA7AZCh740qjTHHl2kaby8KtxjFJCGupp8Cu4ElyFHlfuE8UsissRlF7dHCYv6vZC0P2jXtTCtm9w31YXEESbGGLwTh5VXtSPJDphhaNRBvdDf5ILMkhdAFnQSxc7C3GvtRnQMeM/6DWgPOkzRssDcW4fIzOun/tZTOH1diUf+eizZNevql+eDslPIBTSmEsD0I9qhfRowKQ+bLLpJT5XeBG6HqiC2vrYBDFmutdGfHTnkp/IhV9kG7nJDkJEpBZcof06sA6HBVUcuBTwmWEXKI6rkQqf3uEiUH4HOIEAkyH0tnKxPXjTuvaGhaK8qKxPpMcC7uEW/eaA9XmCZoLpWWr0PPpeM76akcjaNgYE4CdU91zZW8I7GZjIa4xBF8ITpZE7mVhTaRwC5JAzg8DtKIEAka0jC7aYT1xXZnJ1aP29fCg6Xa2+YXakeEZu/X9g6Q/LLMwTPzdtSxvL5rjNtB3lTpnOZG0tYMOg72/xYHk7VXoANdVGzSZTPDXbGIbWLthe4LVK30u6nBgCjb1qg9HDKmE7+UUU6qScttXS0J3jN2IP9wCG6
 EFzlE9WP
 SSmnLXVKumwWZtjkcgLJEC2X2Ktwnxjrq4c48jWSjmf2qw0hCXEcnjLlFWl+WAMSZwqH94GYPpfOGlKjw5NzvILkK4JpB51zLA90fAwes+6eEoNBrpKMRED+5Fl/wS88QKTdNFOShT8S9Ws8/wha3u36OG48TD3WH3jT6+FDxNRYBJtKO4X3yJEhb8ulPFVRTxNyaFm8y/yJQLJB55wc1QAqsFFxmgmypsPdx8mqm5bd77lgyYEgZhr7BHcdrKowU23UphVqHOq8RQn8ROVIoJxao56WTc9GgbpYt/XA5XXOrhfFSyuuUusL3/fROJtZY30+1YKpvBGeMECFWjYfVu8hjkejR/EfG5QQndApaDcr1rXx4yRPfydsk+P77QSUHNcuxaps9YZQkyeLIsXLsbIxmSve47crVMmR9k5CTYKNPLw7LYi1t3uO1FMZ7CtG7j3NAwaviTBkIqCXN5Y67XpVfp+kXYSJP+hEHKiJt8nFz4i60IL1sm3d9rixMwbxB3ewtzCTXSoCFXLSg/dEmKajNqMKCWLtXpe2FLtMj+3VcBtc+bAHGzjhH3v+mIuR6kHeE7AiVBQWDUbU3h5o9403uQCwERZTOnXpBhe2haLM3Ibd6OJ0T5GOkqdiGVqn3DJt5eupWgdjwyHn20FcFDidza57eKKb5UMG9l6Fxw7Be6UEhFngKwu7+KJ+5s11sdOGEr1IaNaNNGrof3i2S67qEUXLam1FPLIC4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 09:12:23PM +1000, Balbir Singh wrote:
>On 6/24/26 16:53, Wei Yang wrote:
>> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
>> device-private entries") introduced the concept of device-private
>> PMD entries, but did not correctly update the rmap walk code to
>> account for them.
>> 
>> As a result, when page_vma_mapped_walk() encounters device-private
>> PMD entries, it takes no action other than to acquire the PMD lock
>> and exit.
>> 
>> However this is highly problematic for two reasons - firstly,
>> device private entries possess a PFN so check_pmd() needs to be
>> called to ensure an overlapping PFN range.
>> 
>> Secondly, and more importantly, if PVMW_MIGRATION is set the
>> caller assumes the returned entry is a migration entry, resulting
>> in memory corruption when the caller tries to interpret the device
>> private entry as such.
>> 
>> In addition, commit 146287290023 ("mm/huge_memory: implement
>> device-private THP splitting") allowed device private PMDs to be
>> split like THP mappings, but again did not update this code path.
>> 
>> As a result, we might race a PMD split prior to acquiring the PMD
>> lock.
>> 
>> This patch addresses all of these issues by invoking check_pmd(),
>> ensuring PMVW_MIGRATION is not set and checks whether a split raced
>> us we do for PMD THP and migration entries.
>
>Should be PVMW_MIGRATION and "us we do" -> "as we do"
>

Hi, Balbir

Sorry for missing your comment.

Hmm... looks you are right.

Andrew,

Would you mind handling it or prefer a v2?

-- 
Wei Yang
Help you, Help me

