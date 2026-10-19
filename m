Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD412CCF2DB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 13:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A295D6B024F; Mon, 19 Oct 2026 09:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9EF6B0250; Mon, 19 Oct 2026 09:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8DB6B0251; Mon, 19 Oct 2026 09:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DE696B024F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:15:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D7D1A806CA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:15:36 +0000 (UTC)
X-FDA: 85339422672.24.CA44C64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 227FAC000D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:15:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hQuygk1Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792415735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QMSg9U3oIXO7S/hMTG8DVmMVB+eB3mbdCkdIWryAqB4=;
	b=nkVWspC8OhCZLXN2NzPe7atOpIw1FxmJnA7yqYtp7so1osd8WHlLhGQBaxYcJP/4Lvnslr
	SELGRE/3IzpLN7pkrTYqEt/yqSMp5qFlNAkigrmAf3pXguBMG9XTTewwwud30g29l9Z/u2
	98+35vAaFd+1sedensaIyyJJ8WfkibY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hQuygk1Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792415735;
	b=hhqXCNwSS++AvH3tLTAvsB+0UXL334XmXYj/23GaOzEJjKuC/W3XhQ3eRCj195darxoA2G
	0JfTgprkhg/kcdmM/HNZ1mz8EToUc8b96B1DXXTAmBNCyaYwuHpULAn8/+sjMZHIZSVfz6
	gmLmOIIs/01njo0SZh3Cx00aULWjPl4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 93B7D6022F;
	Mon, 19 Oct 2026 13:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63101F000C5;
	Mon, 19 Oct 2026 13:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792415734;
	bh=QMSg9U3oIXO7S/hMTG8DVmMVB+eB3mbdCkdIWryAqB4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hQuygk1Qt/30o0nG3xGq3qZdMkhOC1rB0x4SckVoKF9J+jfMDCgkAx2JmmTCyXkkW
	 +XagNsmIfLUik6Gva5xwxj6V5/LUXK7ny8CHFbb7r6E4vwO+t5AswhIo3sYb5DpPgI
	 NTUYfGtX2PRWBe/n9WS5J1JKZEK0WeG5UK3ZS6MUoORU0Lx2vtrxzeA9XPIpa+JTN+
	 sSbHVxDZ53hdv6vf6pmA1kQzZFXVtIBKCAEOPUz61rGFbqgivf/VyUkyObt7A52LUP
	 Ask0P1qwXXIuTU+np3isC+YC5uDhYGst8u7pD9BviVm+5kLeqtcBDrNdZ9qXMkdV6Y
	 djF6epmi3wBTw==
Message-ID: <44d2fd76-c8c0-4166-a339-c04b76aad242@kernel.org>
Date: Mon, 19 Oct 2026 15:15:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 9/9] mm/collapse: separate scanning a PTE table from
 collapsing it
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20261014171145.3292736-1-kas@kernel.org>
 <20261014171145.3292736-10-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261014171145.3292736-10-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 227FAC000D
X-Stat-Signature: axii1c4uddwswa37w7td3nasie9d7mhg
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792415734-943955
X-HE-Meta: U2FsdGVkX19Gt+YFa7VdhLlxSR+LVvXlIJ+UdmEjRPw5TS3QLp1Q6acFjOm4jlIsiKGhamFEN/IeE+HJAfzfrxonlFJP1390SUPz75BKiNFhiEQr9pmpoWtVuzW0VA6DTf0CfJlVcouxDex5ZeSFNS5Md6qEn6DYLKowW4nBpcCJYMO3W8IVCNwWX4SIiLGo3BMnpqvH6Uas6TU//CCXcbWjRtjIk6AoJZG2Yve36Veak2275G4A3IQK5bj+SxRtTcsDE4PZSsQHZ0DieFHZuohQqL4Jo/a6xzbba3e+zF/4+5IS+ZYd2yNtbfK3oDPHeCN1ZC9B2rUdET7mYIr094UVkD4UZ9WnP6Rmws3NMZqUaM8S8BpHSuryWLURdcFILPoBR+3yjmeJS1N7niP/EhJJhqoOKAYW88cjcVaVpqt6kAJH0j/NhfqemevTi21/gMI21uzVibfnxF6TaefN8N0nzey7lRzGmCvJw6tRvirJnDc1dCvNjGyJ+295vFJFOp9Mg1VWMtsF+uxnbPrjYfvX285m4Ei0yrQ40s7vW02A/7LkgReETd1bZJyVm24/jFX8UZ63udw5u93NFMi+qxh51obtbZxZXr2nlQKpkFdpx3RxyDgtLQzX/CZunnPPgPSQPkY8Wp2ANywhU9Ro39SANXMZalaIqGJMUKeUkAD52N6SNRj25ssZjEn0e+pDW6eEFlSy594JbMCR3EhhrxjxL4DB3f7ujKfxo2lLjKwWEp3+xAdsUF1xrLJ674EKMzg7454fI2mhCnqO817RbW95pQlI5ig/GDMCdmbZk+sHIYlNxRob1+98hTQHy8m1VIN0XzpsId+aUhY7O2m89HYM7JV4vi6og1Wu/fDhpCumUNMI/tHcw1AGEdfazUTm5ycVtv5c6sv5GEva5E7zLep57jMkvxeNL1uGar4D9mw1TK4j//nKf7hkCSEg9HEu4uW0BOaiBlI7OtXlJat
 SSTR+QdP
 qWgAhNcTqvNHXbaojyNrvQlP6Nvw2zD7lTsGl0JXYTd9IzBUJ46mIFleFag1a9yOVObJz8OWR+gTP83714MdYuXt4dYZXwtztpscTd24sJFeGQyAIm8mqELw2Yt86jJOiVg/FUJdYxbezxmWQ7pLmQzhGtH7UpR9Ls5MquE3ipbPoxU5xolw6uxJKRL9DMdgOtnEZLU5KsM0VCtJZYJDUaIGdVg32thOpDu3Y053cZdkOchPSUiJLgEnPx68gfeLDFxbMesFnbnVQkID9x+U5TfINPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  /*
>   * Bring missing pages in from swap, to complete THP collapse.
> - * Only done if collapse_scan_pmd() believes it is worthwhile.
> + * Only done if collapse_scan_anon() believes it is worthwhile.
>   *
>   * For mTHP orders the function bails on the first swap entry, because
>   * faulting pages back in during collapse could re-populate PTEs that
> @@ -1235,8 +1235,8 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>   * while allocating a THP, as that could trigger direct reclaim/compaction.
>   * Note that the VMA must be rechecked after grabbing the mmap_lock again.
>   */
> -static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
> -		int referenced, int unmapped, struct collapse_control *cc,

Still some sub-optimally named functions around here, but we can tackle that later.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

