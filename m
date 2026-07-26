Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F3C4C531F9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 15:15:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C79896B007B; Sun, 26 Jul 2026 11:15:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2A766B0088; Sun, 26 Jul 2026 11:15:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B425E6B008A; Sun, 26 Jul 2026 11:15:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9057E6B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 11:15:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0990E1404E7
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:15:09 +0000 (UTC)
X-FDA: 85031275938.29.E1E1D3E
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf21.hostedemail.com (Postfix) with ESMTP id 16CE11C0007
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:15:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf21.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785078905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0oPdXl+Qa702jS88QkxNpNQx7UVuI38mUeMa3xFtC+0=;
	b=sTpfoSbD/NrEL+x2IMkA4oa8zVhOOfxP/s9mbcKqYjwXfAF2SoCVp9ZN/vXHdDHjpiZmc8
	oaAE+AsuKg9BTQ0mUUha8/TYU7t1+u03CacYpiLzGqftEUWRQzJrdAPHZzJe5D2kDMVkzn
	tZjJLj9aWJh8XHVOJCDWVFkz2S6ipmg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf21.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785078905;
	b=vRz0+dnLTXT7h/8h7C2E22FJhmrBluHFRyc0erE4WzqFswXdiZsUaWHRMkYiLGwFLaUali
	kymdPLT5n3NxrSRcLZFm9jerHJ2KkMzGspJNMoMQUksAXn65Olq+HuPDgIk9+Y9WmiW1a7
	dvCcB6VND09hy0FBASQ8dD5Jcdk5AbU=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4h7QJG3mtcz4xVcS;
	Sun, 26 Jul 2026 23:14:54 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 66QFEr6v047255;
	Sun, 26 Jul 2026 23:14:53 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 26 Jul 2026 23:14:55 +0800 (CST)
X-Zmail-TransId: 2afb6a66246f649-ee006
X-Mailer: Zmail v1.0
Message-ID: <20260726231455378d_GexTvD3kHYMqCcI0ah1@zte.com.cn>
In-Reply-To: <20260726133501.504048-1-wsw9603@163.com>
References: 20260726133501.504048-1-wsw9603@163.com
Date: Sun, 26 Jul 2026 23:14:55 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <wsw9603@163.com>, <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <wsw9603@163.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0ga3NtOiBTdG9wIGl0ZXJhdGluZyBWTUFzIHdoZW4ga3NtX3Rlc3RfZXhpdCByZXR1cm5zIHRydWU=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 66QFEr6v047255
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sun, 26 Jul 2026 23:14:54 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A66246E.000/4h7QJG3mtcz4xVcS
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 16CE11C0007
X-Stat-Signature: my7j3ngjatqcobyryafjk4i4st5fzsya
X-HE-Tag: 1785078904-175848
X-HE-Meta: U2FsdGVkX19ONUAtJT+QC97D/2vMjzK1hTeAL+qAXEuEz9qCQUxnYo57uWVDRI8FAaBKvjTtWaa2YnGXom6Sp7mnTGxoU1QKTB7jc5HOzJrz0LyIxgSZ0Mntq3Vv5tCscB9hWlbIGsBfcbraLCpyhmz63pd0ft0nmylA5JelDN1FAfyUjNkHOd0W6e+Anla03qoOF6LsQm/b74m1em1ofbp3Yq7PaT2k9jh/EICoWlQm0cvLAwIC9z1/CWjOTxH5RNMtVzO+insz6+UROv71F4R3kqajasTfLmUhXBBNlRqCzaR6J4IGBFYkzPa4VU37ywH/iaENe4pPs2UI0tEyDTY5CYyr6NqTurPmLW3UwoA+s4cXRg7sxH3cHcbM0waThBkauwYIGPc5mMqlI+83BBG7QmR2BrYHWVwLdFSPCMvA38vGmD6D+2unfiyMdHQbXr5I1Sf+Rv98NOnUeaNGdOa7009YRQXHEoBbLTOkqUhOGxaMLvcA4Eafg5upP/GGHw07eREV83Fl8PMTtAlIejOVtQV7dDrCBmDhpRMIICmkvQtfwvLh5xGfPJiQOZf6hdHNqpQtobFc7hzR6Oe9+OqRcnx6uzQNno6jp5XOY1Q5fL+wLiVzHrVhljpLmXDbmeNQ3Zx4C0pV6okgQY2yjk2k9QU/s7eY5A2Cm9v15rHbP0CNMAYU4e4FD3Q8MUDaD1uPPNM5MbK82RkQzM1PcSiAoP2L4PGsaDwDws31InFEEPzeY+qjk0lQwUZuDLVb9wBI+m+xiKpQD7gZGAjFvg4uYoIyZzH6Dxu5M3a1hmBcngZlyaSabDD3hDClEBcksCGKh4FuOU7nnLffBP/DW4cogQI8STZ6YqqStoRWjR0qkvpHca+DVFuqpOjsGdbKUq/KhTxDjA7jjdwlOFYcTANY0OElHlenX8A3s+dBMUn4gp0d157NyB9saB9nEL36WMMEYoJhXtXhq7qv6zW
 WFJoaJvQ
 UAESkhlzY97aCRAmPkPETl9uGwaKodIz3fPhVxsc98hghxjMt5Tru8Pq1kglF2UuTUwKqioyDK1EkBFCg0g9yhvBKiKmRXFfiZf5/02jVOwI1FjTCufMEN+KfMgKSxBFv7fGj4ZP8YUybROS85pIPbjTrDe+ipKGRkvGdFOZ1e2WNs5Jtngz5pa0Tns5RDVDalOVqxHlWQZr7rotpUf6Yi15YIzTeDl4Ow8X14ODeshOgLC5xLgfhgKDvB4TVCHeV2+yxRwIT2OVjOro4BiMl3c46g0SJ3VLXGkS/ZzHJnyE3rASEt7JooAX9HQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> In scan_get_next_rmap_item() the break statement only exits the inner
> while loop, leaving remaining VMAs to be iterated even if ksm_test_exit()
> returns true. Replace it with a goto statement to avoid the unnecessary
> work.
> 
> Signed-off-by: Wang Wensheng <wsw9603@163.com>
> ---
>  mm/ksm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 7d5b76478f0b..5ed9db676b9f 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2666,7 +2666,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>              struct folio *folio;
>  
>              if (ksm_test_exit(mm))
> -                break;
> +                goto no_vmas;
>  
>              int found;
>  
> -- 
> 2.43.0

Thanks, I noticed it too recently.

Looks good to me.

Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>

