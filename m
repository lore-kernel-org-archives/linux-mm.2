Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAB8AC5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 13:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7785E6B0095; Sun, 23 Aug 2026 09:11:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7292F6B009B; Sun, 23 Aug 2026 09:11:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63ED66B009D; Sun, 23 Aug 2026 09:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EFE86B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 09:11:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C87D4A0318
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 13:11:12 +0000 (UTC)
X-FDA: 85132569984.11.91B1DBF
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf19.hostedemail.com (Postfix) with ESMTP id 10A341A0008
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 13:11:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf19.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787490670;
	b=mdLi95aUcvrvxd7l7EtLTczyLOU5bR+yTLjD9SfCfP56tsV72AjTJGfxsXkReExewzHIs0
	LfSlNE3nKE6a6BZpTzX0Mtvg0eVZdKAdQcI79MRTzcDO0ijj4m/jfnHxmivf2O0u+0yWhg
	GhX0yiiJ1oKA73yme6oydDQXHZOTuE0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf19.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787490670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r10YN3I+o6ILrxeLflUifv8SNpLhNkgIEhPUwVhaR/c=;
	b=cOnsNtw/mpXEljhsdLJEx/ktJWsw5DHDCU5T/1TyJQNpSJ8UGaAOKV5bmXIvk+CbVwlcYS
	8W3XRyDDZ9KGBcq/hLEsUd3iuDuQ6q84iYwKE2OiMERvmbOUlA+hPAXrfDmb66WbacBftJ
	Xm9O1DZZP9XN6Id1kA0ECggVXOLKAyM=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4hSZDP0g7Bz4xNv0;
	Sun, 23 Aug 2026 21:11:01 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 67NDAtlP097966;
	Sun, 23 Aug 2026 21:10:55 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 23 Aug 2026 21:10:58 +0800 (CST)
X-Zmail-TransId: 2af96a8af162409-e924e
X-Mailer: Zmail v1.0
Message-ID: <20260823211058353icNAkP6s8nFh6lcNTqnda@zte.com.cn>
In-Reply-To: <20260822163846.3747787-1-nicoyip.dev@gmail.com>
References: 20260822163846.3747787-1-nicoyip.dev@gmail.com
Date: Sun, 23 Aug 2026 21:10:58 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <nicoyip.dev@gmail.com>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>,
        <chengming.zhou@linux.dev>, <hughd@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <nicoyip.dev@gmail.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW0va3NtOiBtYXJrIG1pZ3JhdGlvbiBzdG9yZXMgd2l0aCBXUklURV9PTkNFKCk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 67NDAtlP097966
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sun, 23 Aug 2026 21:11:01 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A8AF165.000/4hSZDP0g7Bz4xNv0
X-Rspamd-Queue-Id: 10A341A0008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 5p7pmwiaoqi74ees4mteuyirnnbhzkj5
X-HE-Tag: 1787490669-727107
X-HE-Meta: U2FsdGVkX18EQf7IDEYz8ZKNTOKogyBnUwbwG4xSKO+5i9AXmrfRDooXg2U6hZzKkt3c3/wAzVV8/8ytNuzZWbm2TPNR58zGiNuI4gJavQVW/Sk3b7dWleprjUxZJwvRnpDcuLhPOvsnz94JjQNOYDh7GOMNWqzyVNe0amwsQsFlBovDUR2EpSCk9tZNwP0Tn8M157cygr7+iNaGT6gLhoLoE/iMCXKN8Kuy7flejUtg1rpkW3G4rUFA2cYDpmwpSYRLI3jD7R0esrgEaWT8VvWF54xdCHInuhjR6mcfA9nqJXEj0ksVcK8SdyNgW2juloZOSICgJeI48j3WtZCYdIvl/UukZR3DpiFADUK76JWgmKP4H6OnD7ut78BJm/EjwiKZzTdemY7GcqsoqjRT70BWM4cEQnLNYo1Yv3qcUkQHRU0xw4XTw/1NgvaLuR0GDK3DP6me76+U/J+QMpKXh4euUld182BisN8cDWOcJ80ekC1hUTdZbcidYd+W7ZJVFnBum0bmvvfljJ4pt9XanxB5Ek6l6d97H1ySg7p9XUUVbDJnVZpM4MHMyMImvbqyOTGDqE35NBd2G/zDJKew4NSm/UGTbXBtlXN1VR5Lqs2lGsKxMHoP/2hV0fbX9rMXg8mlbgEw0uhJtbHduDNvWzOlxhBPmTESjXnprbKI+CfW7+97KyZqE+bQTmUYZEZRoB6CCg1K1MoykVIGAKkz/D/WdLyaYcbgmkJgreMJeA0EEWRsUd5usNw/Oa4BnYFX+C5SVXMImI4VtrcqdnouxD3cG6jtFOlnT9v0DY2KzsqKNID+1BzfBiMLHqJ14wBqMEAWOMl7aNmkb5d3G+qySOrCS/RAElShx0mleyMMYYhv0UU25Nrruih8LHRPxlomoyGA39IEwtlCHCA91NwZWmghpdvlwveLPzi91ufjJ1dAXnU+bia1wk3pGLaA+6JK2CLa9MTOk83hAN3MFpp
 2v00lx0y
 kov3v0MxhA3R+DinQbwTn0Z2JCMGR5p/gU90Y8DkUB3JPfm9vQAFF0f9KHMz5IU7cLcIJ6epIAaKsLB5353Psoh1xIkTX/C5MHckdsk1eQu5MLIYwkLGTBL+cOgSGAvpVZbQy3BV6JJZc3cPQyXyDRiMSO0S9adYvsw6+zLx7KMgYa9znuVprRkkh/zHh2bLy4bWnTy8wYq6gsRaBTv4BsEyrDJAA0EhpVqJUT9Z9+CNf91qGO/RDXC1YUEZtvjmaLU0ncKiFlcNpH3XFk508U6SqkQgR3xAvUSWZJ1dwxmAexpgW91lrimV9L/rRwa6C7BBYwYZvucwCCVi/sM6BDyBN5OL9jWmj381nK4VWFTvcpFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Use WRITE_ONCE() for both stores to pair them with the existing lockless
> reads.  This preserves the existing smp_wmb()/smp_rmb() migration protocol
> and control flow while preventing compiler transformations of the shared
> accesses.
> 
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
>  }

This is good.

>  
>  #ifdef CONFIG_SYSFS
> @@ -3318,7 +3319,7 @@ void folio_migrate_ksm(struct folio *newfolio, struct folio *folio)
>  	stable_node = folio_stable_node(folio);
>  	if (stable_node) {
>  		VM_BUG_ON_FOLIO(stable_node->kpfn != folio_pfn(folio), folio);
> -		stable_node->kpfn = folio_pfn(newfolio);
> +		WRITE_ONCE(stable_node->kpfn, folio_pfn(newfolio));
>  		/*
>  		 * newfolio->mapping was set in advance; now we need smp_wmb()
>  		 * to make sure that the new stable_node->kpfn is visible
> -- 
> 2.43.0
> 

There are other places where READ_ONCE is not used like in ksm_check_stable_tree() and
stable_node_dup_remove_range(), but these two function belong to MEM_OFFLINE, and
I think there should be no races between migrate and ksm_memory_callback of MEM_OFFLINE.

So Basically it looks good to me.

Acked-by: Xu Xin <xu.xin16@zte.com.cn>

