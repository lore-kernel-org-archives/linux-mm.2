Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 350FDF506D2
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98AF16B02AC; Mon, 16 Mar 2026 10:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94AF06B02AE; Mon, 16 Mar 2026 10:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84DAC6B02AF; Mon, 16 Mar 2026 10:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 741406B02AC
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:11:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 45331139276
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:11:00 +0000 (UTC)
X-FDA: 84552112680.10.708224C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6256810001F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:10:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=petKGAic;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773670258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jUkhGD1MCM+nCnzw4Kcfpl+7V84NlLk8gIQtiFzeSAU=;
	b=mAMuMQNHdqHr5ssGCzEwnJRXJZq0khR56Cwi6+TInCKKyidM97yaxOg5W109hAEmBlxBQY
	OgzoVBZnC+phbuVWsdeVltt0Hq3iLM2kBsBsvURPKFpBBQJCPBQeFnh7r3GvlmfWix2mKJ
	57rel4Br+k9fSgl0rXCpYwrWMkP9mFc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=petKGAic;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773670258; a=rsa-sha256;
	cv=none;
	b=oNPDZV0h9zHbvJlYWUffCjfcWMovqzXmCRTbj13zvxs75scMveelDs2owBwJxvxN9K08oA
	rUm0inKQ+SJ64xqtJn+iLcjd33YNYCg9MSZFVjuPjnJ5Mo9U4V+NsaXhVlWpPSZE1H4Hz5
	rtt+mi8BsYL/xgjWgXfNrCh0IxIKEME=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3AD0444475;
	Mon, 16 Mar 2026 14:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF20C19421;
	Mon, 16 Mar 2026 14:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773670257;
	bh=zt28grrniYz4OCeinQNJJYviLQgaKriHP3aR2K5oqi0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=petKGAic1bz1VLuLQdg4AMqzF7adDp8lthU9JFwPyO2/45RIVwMYkJldH1G1jVha3
	 Zg+75ciGcKHAVukEy2QTnmInanyaiKVOTmt1LWr0HN6m7ieOLfDH8MOC2KauN9TLfq
	 3TN8xw1j6WB9A9LHc3O5jOGhIdIQfIFUGWp4XDvnCilZ7cnvy20kq0LTdejt/7W39l
	 LqCv8fyDHyoFcirBhGwFMGbz9P+eK+hFkB+0rrkf07IPXOUAmwmSqcvLSiAaLzGvPr
	 vpEedcYHpDyJ4thXMWrQQkdnHT93v+vsr5smVaY29OrPKh9JTY2g+VolTVWcEKP+Gl
	 SuiPNIcZgMSQw==
Message-ID: <3696bd1a-5eb3-4bc1-b64b-3f955fe7ac57@kernel.org>
Date: Mon, 16 Mar 2026 15:10:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] selftests/mm: split_huge_page_test: skip the test
 when thp is not available
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 Li Wang <liwang@redhat.com>
References: <20260316044335.1390608-1-chuhu@redhat.com>
 <20260316044335.1390608-5-chuhu@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260316044335.1390608-5-chuhu@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6256810001F
X-Stat-Signature: p3ya3t4fjnifpypkn8z3gcwoants63xj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773670258-442676
X-HE-Meta: U2FsdGVkX18tP2Vby5myLbT3VTRwdbVzLhP7GZtJZLWg0DxrpCS3jZeLmsStGnsdMAoW+UXfSGFDO/QdUAj1bE7yP3m6QKbyY6ZPL8E03+IzFc1NEhwEcclm1xr9F+0A3EPUWfZlL/wOraDl7+iZKUK6qZGguRTekBgn6g+Ek29yEeASpFOd3T1hXE1O+J7SACFVIBpk/IoKaxnfHQvI0AC2VrMkLD0L9ZOd6r6bP7fAiMnAIAnfGIo7S+fy4INJVlGM+Scc0reQB/BlWeKvQ2/pwoIja7HMQkAfXBn/xwJuyVLMSQ9lAMwrKWG6JaMKIDasM6unmH6+4F1zNPU1g7+lbHF/qcCMBjM7BqhKnz10zeIZ6RpRHTM9R6TXYSBYoyvAD8FItevJ8jGlIfXHHLjSzEse6McYMOQzGSL3vFAHJzGFIytWaXPm5eMEPIBqkOuMRaGnv2DJ2tPlH0bhKADKdUCE7W7HoAd6VvYl2oUj8xJqqBsAGlrHPm98Uu2dsSB2VHHqExikFO3IluelE8nU3o26bK1AjsUfB0VpXNR9xQyWH0xi7+EWUKFxStxeZWcES0XayK5E/uiXRUgiE53zn4xQrIHrBe39gkeTPhQ1tRaYB7wU92Z/iA4J8/asv4A78J7X9YM612gv76rUfe+IcBZ8/GM+yCKC96rUybD1Tixiiq7SahSXRWCKdwc3Xuonf8qnbIo3h+L9nCPj6lgtZpuZZRFXAmUjkSetdGouAMUB+sxlQoVQWyUAwlW30kAU9Wmco536Sw+Z1Tauz38EnycOXM+03eAqoO0dmNZIc897fC2/gVpXQni3sicUNLU/Sg3bQlkR1DgUhvyvKJKQBL4ZGDQcLVXIErMnPFkCBfGxjsbu+x29t5zk3vQ8BkLSCZtQ0Whc4vwZdAhuJP91P/x5BNwuEKqh3afUZuFScf8iNBPa/JlNoyY850KiySq1T55FH4noW3vgpvE
 x2A1vzp5
 v5EvoJMTlCnssvfEKC1+p+ejHhqpt/yKVQ3IY2XJNz0P1/2Lb7ZUyGT8Neol0YKWQCG4p+XYtA/DNF4AkJrk/2Js4UaNEB4nynyTeC/QFDBr0UUA9PJWjW5h4d5A4qCRNQl5t21yhnprS/m5+c213Yt1cm2n3hhtp1RG1o+4kMuLXW2obkvvtXpxT10iOB25glnlPu+XoxCBBYm8cu0u6vNxMhe4xQyHZWhAV4SSz85QmleHR2H4F6RhQGZdnEYqx6GSGerQ4UOnHpadLdnO8+zg41hJ01zlSjWK8Rxo0fuPG+M8RxmbxgYF4DcnMc0GV7MX4C3XKHHNEo/JDdCHieYpt8d34kDt5Xd8ob8Lu+mnarWGXnUsGJlT6foL48/1Eumw7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/16/26 05:43, Chunyu Hu wrote:
> When thp is not enabled on some kernel config such as realtime kernel, the
> test will report failure. Fix the false positive by skipping the test
> directly when thp is not enabled.
> 
> Tested with thp disabled kernel:
> Before The fix:
>   # --------------------------------------------------
>   # running ./split_huge_page_test /tmp/xfs_dir_Ywup9p
>   # --------------------------------------------------
>   # TAP version 13
>   # Bail out! Reading PMD pagesize failed
>   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>   # [FAIL]
>   not ok 61 split_huge_page_test /tmp/xfs_dir_Ywup9p # exit=1
> 
> After the fix:
>   # --------------------------------------------------
>   # running ./split_huge_page_test /tmp/xfs_dir_YHPUPl
>   # --------------------------------------------------
>   # TAP version 13
>   # 1..0 # SKIP Transparent Hugepages not available
>   # [SKIP]
>   ok 6 split_huge_page_test /tmp/xfs_dir_YHPUPl # SKIP
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> CC: Li Wang <liwang@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

