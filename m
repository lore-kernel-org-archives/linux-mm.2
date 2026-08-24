Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42220C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 10:39:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 599306B008C; Mon, 24 Aug 2026 06:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549966B0096; Mon, 24 Aug 2026 06:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4353C6B0099; Mon, 24 Aug 2026 06:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CA836B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:39:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9CBD3404C1
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:39:50 +0000 (UTC)
X-FDA: 85135817340.25.E62B89E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id CC3561C0002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:39:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mDy2PrII;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787567988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+cEnHUXSEW3y9hV7Pqg+IFZMaWU/0V6kmLa+UNlhmow=;
	b=poMX0JnrCg6fpW1FQLPYTajeAPt8ZngdYJUC4kvzlYsKtwCYgCFdEJ6oCwjsZ2bPsu1BMT
	Bex5mO/YPgmJWpP+J8vVia92VC4IsZ+oEcYWwqkYaCx4+9GG1opyCVLT2MnPu1ojXgyfFV
	b7aRdx4xeWxeR9hsA7NIpe3XGd22Aac=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mDy2PrII;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787567988;
	b=mwVTIp6tw2JPxxuCzPgOFQCyFpopVhFGBXKoVg3VSXR+eAzB0+/PROWHBKQubh4RHYd8c1
	JZmIieYU2Antzw1d7iehUtBL8tFIMVUAb84Cjdi2jHJ8fG5mxvXxuScdygIrb3F4fS4GzO
	sUl/xWwarVQ34kybjEWK1MjiMRe4F54=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E587404E5;
	Mon, 24 Aug 2026 10:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F47F1F000E9;
	Mon, 24 Aug 2026 10:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787567987;
	bh=+cEnHUXSEW3y9hV7Pqg+IFZMaWU/0V6kmLa+UNlhmow=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mDy2PrIIfHZ4kB6+q+vg6gsrXD6Ppn+PIQkY64b2eaTlwmEvSgANYOcVUOpHyJCID
	 jP1B9QCI9L7l1xspbvJXlzCffHqHrTuRl3wlKrUkJd+oeuJTmEWT83baWDHQUW6ma7
	 Cu/Lt+HpvT8hzlL6HEbywf5NjCibx7u9D5KUVt30ezlpj/AClcal/1nTC/Su2zcbgC
	 l61pPhMguCtirH1cf8F58USJZpybFDKUMTbl/zLbvJRca/tkF9TsnmeAF8fadrYVZC
	 vElksBI1Z5XARW7iNRjuTYlYDPzGTvMIX6uShygEsAASSK1W6WIK1VwaTgjp/RvGd+
	 6Scm23rIy+inw==
Message-ID: <5501d110-9f04-4a61-b0d1-16898910eb93@kernel.org>
Date: Mon, 24 Aug 2026 12:39:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ksm: mark migration stores with WRITE_ONCE()
To: Chengfeng Ye <nicoyip.dev@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260822163846.3747787-1-nicoyip.dev@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260822163846.3747787-1-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CC3561C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: 6aadqubkgub1sghyf3o9eagrigpyp7ua
X-HE-Tag: 1787567988-310508
X-HE-Meta: U2FsdGVkX1/9KiEtUh9YrpyCJMhcqy4OLNrkygtzrvflxgpdHPunumt8YgQWNrH8GCLnUWoSE2ZtwiXiu0zNMDv1j7tLMiHWa+LynMPfBcXU6pxz5lcZpvNNgAwddnvO4z3mWHgk+GknbF/921C+50nhJQw/OYNrP2Tl4ixqVG2lc9CwgRaVy/cFH+FkmYSAcdDUuXXWMbaCh2E0Scw5QIEXAql7Cj8YdV5LAINCKW+vab7wsYTO6ETiIcpwkbX3bLR5kI9Gcrr4tx8vZzLPX6g6xk87IasSEfJjFy2Oc2gF0Xgyx1w7SWodNYuhi49Cd7B8XwnG+Chq4K+HJu3wVtbij0J3R8ZOPsZ/zvlpb8OgwD8Upi5tYu3qVdqniPKnIJ4rZRUOiy2L9CWAsl8it0/g0uii4VgHF2XoUzFdHSTiehNwssEkLmSHGRju5biToy8HHSMNcWKAIgKfgzmr0VcISQZcC2rU2MWQVF09buD4PV2ffGcncw1PmvyTnG76LRcLNwXlZXhfC9t/toePrkOkiVliGYwpfYbCcjV+z0exzeNCeQvunbjERaC130gziy3uXE89XtH249kvhYzd4H9W816z4oz/Fqo4KJutSN31zxKykkF8/E5JZ5ZWCyrCi4VUL7xFhhV9/P56SdJcfmtV4WGRQucq7krxOGX86nUOt5Z9DcOI1JgwALBUmhXHtbQPOscTEzc/xQUv7YFNzWbEx2eUTkeC/0QkfxCn/RtO5Z5WRZ8ncK0AheyLWxG3Ba6qe95kFpBtiihDFYELSAJkhOw6LzpWB85RbWDGbgqm1anM3ny30XDwmkjWIFvl6wlYiLyqmXPa6me2l92kzH3NEmNaM92rfJhkvc49ZNto9otrhDSwYWil1hGvimCAJlEoSRJf7xL6vS/Ret6meEzOJ5xd3vkrTsfNqPaUciA0jTefFBZxHDRXXaQay+wzOjxpSA2N9+wNyh+qT3f
 o08NqOKf
 bXrRTw2aXEggsCeoHQ/qeG1W9G/4SKS+sG11umZAuh+SXqLQkrqP47gqByAdm3lzo9uqNomdaAlBh9pQahzlsxjjv/FBzrH76iws6FFSYqbStC2R+UU09mXN4R4AmVJnOvjvna8jkx46cxW0cnwuqq/uASSY33vEO1kuA4PxSGoeQtvmr17a70qvilIonEjP/leXShv51G13CI9k1p4e8FEtleJTwNDpFfG3OMEKDsZJym1TVn074psledIZdTSe+5bkTGz/yEp2mljFGbpiYa9ZA2e3qpioL/dSHulajSB3Z+z9mI7Nh/UdSRxj5sXU4MaP9BDGZ2HGwDk4/dwoTXA3OUkudglksUfZD7QxVZtT3uZpt7nD3wB7Jsx1AjI/KW97/3moPf/r5CoXcIaarfrqtfeUUjejTFbIlMUVufn6ZdHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/22/26 18:38, Chengfeng Ye wrote:
> ksm_get_folio() deliberately samples stable_node->kpfn and
> folio->mapping without taking the folio lock because the KSM folio may be
> migrated concurrently.  folio_migrate_ksm() updates the same state using
> plain assignments.
> 
> The reader can load the old kpfn, then the migrator can store the new kpfn,
> execute smp_wmb(), and clear the old folio's mapping before the reader
> checks that mapping.  Thus the initial kpfn load can overlap its update and
> the subsequent mapping load can overlap the clear, with no common lock.
> This leaves marked READ_ONCE() accesses racing with plain stores.
> 
> The kernel reported:
> 
>   BUG: KCSAN: data-race in folio_migrate_ksm / ksm_get_folio
> 
>   read (marked) to 0xffff8ce401421330 of 8 bytes by task 48 on cpu 3:
>    ksm_get_folio+0x7f/0x2a0
>    ksm_scan_thread+0x1635/0x3330
>    kthread+0x1af/0x1f0
> 
>   write to 0xffff8ce401421330 of 8 bytes by task 102 on cpu 1:
>    folio_migrate_ksm+0x6a/0xd0
>    folio_migrate_flags+0x193/0x420
>    __migrate_folio.isra.0+0x162/0x1a0
>    migrate_folio+0x4c/0x70
>    move_to_new_folio+0xd6/0x170
> 
> Use WRITE_ONCE() for both stores to pair them with the existing lockless
> reads.  This preserves the existing smp_wmb()/smp_rmb() migration protocol
> and control flow while preventing compiler transformations of the shared
> accesses.
> 

We want a Fixes: tag, can you dig?

I am not convinced CC stable is warranted ... but certainly wouldn't hurt here.

> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
> ---
>  mm/ksm.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index b4142746777e..bec6fea0fdb4 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -1116,7 +1116,8 @@ static inline void folio_set_stable_node(struct folio *folio,
>  					 struct ksm_stable_node *stable_node)
>  {
>  	VM_WARN_ON_FOLIO(folio_test_anon(folio) && PageAnonExclusive(&folio->page), folio);
> -	folio->mapping = (void *)((unsigned long)stable_node | FOLIO_MAPPING_KSM);
> +	WRITE_ONCE(folio->mapping,
> +		   (void *)((unsigned long)stable_node | FOLIO_MAPPING_KSM));

That also matches what we do in folio_move_anon_rmap()/__folio_set_anon().

>  }
>  
>  #ifdef CONFIG_SYSFS
> @@ -3318,7 +3319,7 @@ void folio_migrate_ksm(struct folio *newfolio, struct folio *folio)
>  	stable_node = folio_stable_node(folio);
>  	if (stable_node) {
>  		VM_BUG_ON_FOLIO(stable_node->kpfn != folio_pfn(folio), folio);
> -		stable_node->kpfn = folio_pfn(newfolio);
> +		WRITE_ONCE(stable_node->kpfn, folio_pfn(newfolio));

That makes sense as well!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

