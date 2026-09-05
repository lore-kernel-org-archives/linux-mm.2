Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49A5DC79F8B
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 19:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51F526B00A0; Sat,  5 Sep 2026 15:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F84B6B00A1; Sat,  5 Sep 2026 15:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438616B00A2; Sat,  5 Sep 2026 15:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EBC36B00A0
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 15:49:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 953781A0366
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:49:53 +0000 (UTC)
X-FDA: 85180749066.01.EDAFDA1
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id A1BB5180002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:49:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="Nc126gF/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf06.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788637792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dOlJOC5zpBu6MtL41vNbLB5DikFdEvej+QPJFEZWO4w=;
	b=CF4b44NjxzLp/Pj3dHDGH9Uwl0hDGhyajk9dvbJ5/+wVFPPFtngQfeBFHeHcVQPAQDhlEP
	DXdPT6RP0XrmmZg/93UA+cYyPW5Syqosk6Bfx8hPOzR0Yn9sQkKtVzzlg9oTyq4uwASjqD
	aoycauJ/W7A5c/G1FonhP37vRbl8Olo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788637792;
	b=gc6pzCk028216Hl/oV4m56hTASVMvXi6sx9FDYnaphERNhVKVc4osqziVuVGhojPGO5RvK
	oQCMlq/Ws4kOdqz0eeOWxZe6XU2DbmGLQgBKLghX1W9p5+zt8i1u9V3ObcTSQ250PKqY9J
	9mF9VM0dHnlppIDavYkhEb9qCcfQRDQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="Nc126gF/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf06.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=dOlJOC5zpBu6MtL41vNbLB5DikFdEvej+QPJFEZWO4w=; b=Nc126gF/TGG7yeI+pCV3ydxzEM
	KZfq/OLCtVZBNokaXhRKhH6qyXIUNjtrbtIK5TweJrv2xoWQH3ZsW3fyB4dm8Qejfm7qq+OkA+ipB
	1agDCfYTlf4+lOkqo9XNurXjeWmQ40On/t8exft5mt0noaJyFA84eyHYvoTtlC9F6kKqffaTgOejC
	ki2k+njoPWB59k2LJEOlFC1s5qFnsUIJy7hO/By44TIlrf2mS5W+BjHN3B+Hd9HvfGH5YoTycud/Q
	HrJ3J8eWxmAeW2IKx2lLx3m4pc364qR5owwuTfvXBFB8jpUZ5253KCji3yXpDAzF1BHidngEtXjrT
	Va1oIdHw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x2wOY-00000004NjQ-2uog;
	Sat, 05 Sep 2026 19:49:46 +0000
Message-ID: <97f80aaf-fe16-4557-a4bc-7eddaf406ee5@infradead.org>
Date: Sat, 5 Sep 2026 12:49:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs/mm: ksm: Use the renamed ksm structure names
To: Karl Mehltretter <kmehltretter@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <20260905084034.39521-1-kmehltretter@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260905084034.39521-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A1BB5180002
X-Stat-Signature: f1uu89ywafkpjkqrfid6dqhrp7wceg6i
X-Rspam-User: 
X-HE-Tag: 1788637790-843912
X-HE-Meta: U2FsdGVkX1/AeXMY90YNHmtlfcWIGZ9kAJqk/lYKpwqFzc8ty9Pg64eMpdWBfHtyGgGfB8VOw/KJMQsvglubGSL20JqLtQq1n2zn0aQfRfB7ikmby2pDlHHbGSc6AsPFNicjehAWIZDwvn9QjkUNtII0v3Shi/PmfFDOHafoEfAo+vh38pDylspW4OZ4kkkqTUk6MCdhz1bKn8kBBMUoiyJ6LG/z1b3FYqqP4iJqTQGhOwvqUlPBU8h7O1989JIrb5UKeC1d+iPiCdbdGVq+sc66c06c7d00zvaqYOTGBODMWhaMKBbOR0GCky4otsiohgozUBEObVRa+3W9sK3jvEzJ0HbdzS5nDEsVb+33MaLyFpVujxW9rPeHkJjiUp7X4bbVsyos8Sx39ckMG7qUxMi3ApldKiigSi3uD5fIPEtcYfn2HLz+bBAP2ZNJZObwRrpP04gnTNhmYaE6L3zWFdie2Lr1YMAjPtezoY1rxjosoQn3RmmIyd1skuykLAL0+IG+vHkt8lm7MZMVn2Q4OmnYoPb5QMFGe9HqdqxV6TO6idFxQr9SIP/IVudm9Ke+aCgxUaXmBkWxQr60S7WJmBmJpaDr6nUruoawgorL68oKOFTLnuaiF0jXQ7WArD1Q3empAIx+XdgVzeilmG0rUxVqPoX2yglWOMwtBX7MEnSfbNPuoaFec4DXZVttaMt1nnCWOsT7mVpnD1wUoHiRhGyvsxZfgakjxu6Rmam90Ox1qK/qPAViHLKKZtiMTbUrZxrEO+qAEYqF4IgzI+rzEriXLdDgf24oq7+25cF+zKs3yQa5KF3FSFN0MGx9OkkxcFf328dAhUXX3YjPA8AmL7fy4vT7y4UC4xwO8/vS2MynTddrLk7EtUu6U6sMXN0NBMOHW4S1DWQWoczm+5QjdSknqeG0tQ5j+aOZgnvwn/9kWXmqObuqtlk07SaFjsV+RNBBHd3+Dr6jx1r2TT6
 PIlN/vAb
 QPn5FG8472MBmKGNaH9lL3PVwzBicM0LzHrMIpyN4STJZsZJ7WJVmEaMgLoWCpIoCXLcMr/6RZUwDbt/DPCI+q/bNzPpFFRA9gV3cS354L2edWqf7oG1MJ6Nq/2EYTvLQtQOr0HhGIQe1pYPsK43mBqpNtFgywIAt6Ys6yE21pfgdQN9axTDCnVyPFn53UkQdsFKchwbgplZv/iWPSgc3sBEMWJYt7s5gpsJRjsCOrVO1q0kUvZemDFMn0ek8cBKPQAIAtamzlvp29Mop6Y4U27hl/PXIavPspGZisYeldDBcIDdnkvs6Gtif9jQbIDOUR8ZsRqhMeHSgKHTOa43P4rycDq2vAy/tVKtkR5z1rnG0pIj3hMPGQOMK0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/5/26 1:40 AM, Karl Mehltretter wrote:
> The Reference section of ksm.rst asks mm/ksm.c for mm_slot, stable_node
> and rmap_item. Commit 21fbd59136e0 ("ksm: add the ksm prefix to the
> names of the ksm private structures") renamed them to ksm_mm_slot,
> ksm_stable_node and ksm_rmap_item. Since then only ksm_scan is rendered
> and the three structures are missing from the generated documentation.
> 
> Use the current names.
> 
> Fixes: 21fbd59136e0 ("ksm: add the ksm prefix to the names of the ksm private structures")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
>  Documentation/mm/ksm.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/mm/ksm.rst b/Documentation/mm/ksm.rst
> index 2b4f72f1f953..5a80573162de 100644
> --- a/Documentation/mm/ksm.rst
> +++ b/Documentation/mm/ksm.rst
> @@ -78,7 +78,7 @@ The frequency of such scans is defined by
>  Reference
>  ---------
>  .. kernel-doc:: mm/ksm.c
> -   :functions: mm_slot ksm_scan stable_node rmap_item
> +   :functions: ksm_mm_slot ksm_scan ksm_stable_node ksm_rmap_item
>  
>  --
>  Izik Eidus,

eh?

-- 
~Randy

