Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69D81CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 12:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F71B6B0005; Fri,  5 Jun 2026 08:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A8206B0088; Fri,  5 Jun 2026 08:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7977B6B008A; Fri,  5 Jun 2026 08:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65B3D6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:14:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 212E8140BB3
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:14:09 +0000 (UTC)
X-FDA: 84845751018.05.2923461
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 49BA0C0009
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:14:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EBYyKq4J;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780661647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hFn2Kj21t7vBXcRahiovSs8PTd0jvYFlnhPHBtEsQwo=;
	b=X0STANhsJ+AVqb5SPMsbh9MrL03AHBNsb0dEDJJS2E9r1K1pkO1Oe25jLh6blSMZN9Frnk
	aROUP9VeXAiQvuYeMKIW1FaYo2woDid2wpeIvT6GKRnKih3XlzMqvM8gYvpUq2An9gWJ+T
	k33ExXm/s1KI5alqt6eUv07kG1iXiTw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EBYyKq4J;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780661647;
	b=7jkBNyII6lRO4nY/iZV9X8PsoK4Y/He48NbKCl5q16DOb1V56bi8yNpqmk4w8XemuKsjqI
	ScI9Kr7zaJMBmHtQ7Lfe0gpX+RC9edHUDCw67L4jiqnS5o2tvVHX4I8dmQRK8Fk3xInS+C
	8e5GI238G0hM4H6EaN/C7kmGOcVE5MM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 43B4B409AE;
	Fri,  5 Jun 2026 12:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F69C1F00893;
	Fri,  5 Jun 2026 12:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780661646;
	bh=hFn2Kj21t7vBXcRahiovSs8PTd0jvYFlnhPHBtEsQwo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EBYyKq4JCAW8GNUGiIHBtC4FTeUBGRM86DnzC8blZmSIdcNUJcW7DjTEGD710n+B+
	 U4evLNzQvWAC74XqMyk/+Fld2I9s2fyoYQxyeSgBa3xn++HxB4Iq6ftza8Mb+9yACZ
	 tMb0Br1lnhUKLfdV8ifew9cxkHWyg3yDM4wHfKKMYZCzq0rkXX5kWCEpQfsq6Oqxoj
	 H4HXAbk+EIBYO5MjajoMtf2roE5f6x9ZcUmh1CneSM/5sFklBy85el1M11qU4hUQ0m
	 H+wVVuDcryGip/HPQ0Ew6QmcrcxLcC6YHk1SL3MD4kYsuAKrpk0V2ZG0EAH2D4cZ7a
	 +Uzrsy2rRykPA==
Message-ID: <ab26c726-6769-4251-bfe0-fe0dc927cd5c@kernel.org>
Date: Fri, 5 Jun 2026 14:14:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmstat: avoid taking zone lock in /proc/buddyinfo
 reads
Content-Language: en-US
To: Imran Khan <imran.f.khan@oracle.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260604134245.1580287-1-imran.f.khan@oracle.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260604134245.1580287-1-imran.f.khan@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 49BA0C0009
X-Stat-Signature: mg9sx46y3sumimgja5hp1hjn7igmozhk
X-Rspam-User: 
X-HE-Tag: 1780661647-237847
X-HE-Meta: U2FsdGVkX1+L4FYqE5wcPGfD4QidKh6lEDnMKgiTnPjrq+EiALLLMW8+jtYg/2OtgdTpbLQFsKV53vshcbSS3xTRQ0Xo58xS1GQSJX9syqN11eJQ7nIly77HAPm9Gihr9oNTCtnOJangy4P8PuRGQ4zsA1Ef/7ZJlvVV/2mNkhThFgtA7TCQh2Du5Y4vAJO0sDqWg2BtAtpd0Ho0497ZBXO+xpCtRJ/8xZxregRCYdK9g7/1f7gzRmvbQmh4ABlxK7UkLk8VDf15UEjQCZuOYKBAMM1JHwvE5ggG2Qum9SocAmkvrZNn+tfyjh0orULvsuVL3K2zgnX+SyGdX1wBh5HA1vkURGIdP6dW+U4672JfWgTszWXOuv8Dkjo+Aoh54tevAeL5+ZZ9ROntcnzunUXmqGfJdCBX9yxOh497KPPp2Ijj/M3ZpfUeqGeh++gJuB2MMcGyds4CgiMtly2/2lgxUPx/QOTuIuVhlHyxKtSJnMoGhJdU05vQ86Hf987aOYRScytwmHnG6S+ECTEZSVHTC4HHN14g14wFGohbQXZc9+ChWB5Vc2TYVK2oPfW/n9xKz8b93eZZLS/VMLAjkKqx93RdZUUZqWneJJnOAkEbgqgkACdRwO837pCsaii0CD8GBoUoDIRvyK4b8Rm3+KNATj5dRyEEwwPc8pozh0rEMvW05VedVBkNysjoYJ/AhylLAzsxIkFik61u+fNl8228Flmp69UetKJhXc2zF7LBQ+iBW+dq1Duo5U7UBSxq4p73oVLD6h8yQBZGAhMx9UXBQtSExJa4VQtFnjBTxUEAVie6PzydEW3N36F4twYVyMA55IaB0MF5w9t6vsMlJeWMAMLfSsUM4AetbpOOPGPzq3SUV6g/yNNHKGRitLmWcEmajkDpFbvYWlB5KZsNXTamtRzVH3wU1X8y3yL10UV+6oyJ+dXfESLYUcMySiS3H1ETjbbOqYFcPB8YbSR
 CyPeLERn
 voK+iScPsAJSy30Lz01KtQQ0kIAtUjuUrcNuADKi8kwL8oC0smAR4fvtghYtQVmVw266RS9c+Q4qzUqU8rLzItDnktLT9GLJfvbVIVBHiAtxhgf71V5Rv5Xh73XI5E0wcI1w9UGa57zBBhTxSfGCU+k6N641KvVRb6d/Dw0doV98VfLag3NmqmK+cizKigyt/CM++TCTJ8KD3Bx7msFZLUYBe5WN6ZsKZEwWV11AGX6j1pb0il79MH6L0YRaMVUx6M8p1narP009cx2leqs/FHnOBJbmppCffeLvysGMzMAYxREBWSJ3dIQ9G6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/4/26 15:42, Imran Khan wrote:
> frag_show_print() just reads zone->free_area[order].nr_free, so
> it can safely do this without needing the zone->lock.
> 
> Pass nolock=true from frag_show(), so that walk_zones_in_node()
> can skip the zone->lock acquisition.
> 
> Signed-off-by: Imran Khan <imran.f.khan@oracle.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


> ---
>  mm/vmstat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index f534972f517de..7b93fbf9af092 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1568,7 +1568,7 @@ static void frag_show_print(struct seq_file *m, pg_data_t *pgdat,
>  static int frag_show(struct seq_file *m, void *arg)
>  {
>  	pg_data_t *pgdat = (pg_data_t *)arg;
> -	walk_zones_in_node(m, pgdat, true, false, frag_show_print);
> +	walk_zones_in_node(m, pgdat, true, true, frag_show_print);
>  	return 0;
>  }
>  
> 
> base-commit: e43ffb69e0438cddd72aaa30898b4dc446f664f8


