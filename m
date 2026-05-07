Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FC47CD343B
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 06:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CB336B0088; Thu,  7 May 2026 02:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A32B6B008A; Thu,  7 May 2026 02:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 592D66B008C; Thu,  7 May 2026 02:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 47B486B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 02:44:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D2E2D12010B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 06:44:58 +0000 (UTC)
X-FDA: 84739686276.05.039BB4A
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2449F40004
	for <linux-mm@kvack.org>; Thu,  7 May 2026 06:44:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JdezC4iw;
	spf=pass (imf12.hostedemail.com: domain of 35zT8aQkKCJg2DA46JQ9D8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=35zT8aQkKCJg2DA46JQ9D8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778136297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KanSvF/vheS4526j9LXW3DP+vM38eLB21WEJsAnBSw8=;
	b=vkb/yUAx75qNtT8d0CNuRIVW2nb0xBqW2e5KlXh3G7I69QZifoyyP79E3ueU6zid4II5Bm
	1H1+kQOTAGb0P0aPyVWJoKO9eNerTWEwKfP45nXbWpl8TDDa4cicOvScFRJ6TlAzmzmks1
	Y7bz7KgYdBY9OF6KlcFCUg6u1GegLxo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778136297; a=rsa-sha256;
	cv=none;
	b=sWJe6a0OYCssOhsDcjtP4N/zan3q49fgvftlKsZrbhDeaSvTjUnz+soyNHtJF5wHul2Vns
	wgziHpew0e7vWD4WmIzr4hA1NFO/cfP8aluYHSVbEd7GsUN0BVOibIg5xSs+jyLn4VFPIA
	q09H2SdEcDlyl+AUY5/FTQriXUBJu7M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JdezC4iw;
	spf=pass (imf12.hostedemail.com: domain of 35zT8aQkKCJg2DA46JQ9D8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=35zT8aQkKCJg2DA46JQ9D8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837bfcfe0dso6081655e9.1
        for <linux-mm@kvack.org>; Wed, 06 May 2026 23:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778136295; x=1778741095; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KanSvF/vheS4526j9LXW3DP+vM38eLB21WEJsAnBSw8=;
        b=JdezC4iwrGwRLjJP/FPaaqgUMYWlC7SV8y2FZUDm+fVUjrJ1bUTRKUCz5mQ9QoaF4G
         sOEHB0W315zQeM257C811k1p6+9Sc/+5u+qobNlqh8cBXQgYMTwK7O22M43Yw9RO9vA/
         v5JT9G7qBq1wruNT6JBc+rlO4pR2EqMJtWRTGV4zK42mr24KMy8/U6u1O8lJR4yhQMec
         TlmX7gXk6GvbGRCMPYaBBaPNZNGgTBIfoIV76CsD7qQzjb56jXaUQ+v0WKryDTapW143
         vpXrTFVJOgiMedWVkUoPrefUN45AF5unwAVOJ0VMJv729rxoylDs8FPyrNIcU7tpahxj
         QYYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778136295; x=1778741095;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KanSvF/vheS4526j9LXW3DP+vM38eLB21WEJsAnBSw8=;
        b=ppLCPs0hHdnzvZSKxMDLUK/b4CFnc1AQFzy56Q6QyH7jU98UfkPJLyWZeEcW9De0I8
         KGjCGp20GelDEmgogcCr0557KuC5fNMSGQKFTRO0HVRFMLGZQ+QgbBYZIjL9XutzebIy
         ClRhJ6uleHlm7BsWvmNDmtDM0pIXJ+dfGYTVY0ty8Wku2dnRj0p6NKwx1WLZpanTm+zv
         UH+jJEyUqRWXSSzuz8Ku/6xs3+Q5RCKGM4eaz4D5zkLMDlDlwHdOIlPoRsAceA+UDeg+
         cZALfjSGpP4jPq8tirB6G/gSRhhrQnXjLeJuomLpd1eQwP4Vn6R1zTpqAWi4D1Z6DHUN
         43yA==
X-Forwarded-Encrypted: i=1; AFNElJ+aDOEcJRzmrlPVJTRx1JTMH6Y65q6H0gfV/DlWL5/a7UrVTFHGhnelTS3yqEN1KaNswypBGMkGGQ==@kvack.org
X-Gm-Message-State: AOJu0Yzz9IcG6LpT9MsWHq/eIQ7lU8C8CdnlHVOYdWe9pI8GAXfJAaWb
	GW9tzKaUerJzvb/JJAa8y6bRY2mQ/7uBP86Gx6w6D/tujOOjuv74Zc5ZFWcPgyv6bxkLbVWY7KN
	kdgWJv1IAZAQ93ww7pw==
X-Received: from wmbjx5.prod.google.com ([2002:a05:600c:5785:b0:48a:58a1:abd4])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b96:b0:48a:66a8:9981 with SMTP id 5b1f17b1804b1-48e51f55272mr113922875e9.27.1778136295060;
 Wed, 06 May 2026 23:44:55 -0700 (PDT)
Date: Thu, 7 May 2026 06:44:53 +0000
In-Reply-To: <20260506105218.2d027cc0@fedora>
Mime-Version: 1.0
References: <20260506105218.2d027cc0@fedora>
Message-ID: <afw05fkEikYVxpzr@google.com>
Subject: Re: [PATCH] maple_tree: document that "last" in mtree_insert_range()
 is inclusive
From: Alice Ryhl <aliceryhl@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, 
	Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2449F40004
X-Rspam-User: 
X-Stat-Signature: 7jnjxjuafibrwo11jrb3ffpoobkn1ofj
X-HE-Tag: 1778136296-176727
X-HE-Meta: U2FsdGVkX18P3u9J7QIDlTgcKA5wLbGNA9araQU1QYcmlZG5Erliki4wuRzwPz9hDfoARcgDXWBMNJeZOoZFz3W5hYj+3IIMY/n+nJm79bRrwim9pS24x3c/pB0aX38ZC2Ef3m1EH7WFbwaMdcoqltEtmlJYRwhWfpgBz+M5GJIiCXBfDLMIdlcKCFhbreKnHX70DVQY5zXwloj73+zPToJSqRHj6WKR9Hx+GTnet/AKBaraeS7IxCCNn2z9ti5mIqb8vymyPk30KSij+kz+SzQgwvGTReVAoEcVXqtDoZQBemSCMpDgcTn7VzkUzCuK2ZMEsv2T2M1POWwIiT90eM7CuM8DZOHjpiTiFSQPSG+DEstJ3NcVBLe77wTO73f7T9LZLhNUCk5a3LdxqZBfbmQBaxdFT5tbnwBVthj931ZdbbF8aXq9FRNTXpH3QOJI/RuiMGswAE2zSpiVCEF0pztrc0+QCUIpfT0NXxXz+Z9sd0th4fHFXV8FFO8tmeu7VGSWxPk0QlI7yM1FtOu1QKufnrDK6XuF1b5Yww3NHDm0x7DectSwTVG3UMIEgzoqS03mkjvWQ6c6kYfuL4QAZHr2WF5wKR5yQ8wCgs+5zH+F3zLHREJHl9LET3onItowfWW48f11uXuPVS8n38LAlAk8uPYxRPVZIdndIdJzsxjzjYLp2JaNenlx/eCM6jQzuC1bzN8YtLfROfeQ5TQCspoxjbi/fUOpHCLoiV8pGHBHH6xvssGk1Y9TR8Rj0zKiHz/gd2pFnlTWd8yggbNbaIxJ5LBmLMaQ2Nzcgsld4Kr3nTSC3xec2gRl2aDlh0hqyfll18NKwYDPp1k96OTKSYBhRuBsCJqXUA7UReBtsfj/j5qVn2UiiEs8Ayh4nqB57Zf/Q7HlHNYqADP7LiBM6d1lrpIQporKO/j9/6gDgMPdV2zkoqxXaPCNyap/VUwt/1RpVEtTHWtoFW2vaGC
 5zMwsGi6
 3oOv8IiUAiuFXa38JRtuG36ODlCq7/R2+9xV9mSghof/zSZfzhwZA1olBLrvwqXObpLUis5HM67RE1+kKXJJWVUhqFTUiL5o+KzuYR7WQqGEZZXY28OnEHFn6+mCA9U0JeZENbJJ/BslgYxdDuhFXlZVLjHRmGJOH5+dTPxQ5QOpvdyAG1LJJmqXexuOLsTtvy9eOZUgbUsVgcHh/sUf4/i0VsRjbdlmVEWUkA0uQTSSisErBU+MFWBwu5SL99Uhh4Aolr8B0+70aGO7hI0ywm2eDDzcXEwtnl2BV19bzn9vMwDeEgczJeVOQsrMP07zWVvYFotu6R1mC2T5QvV9lgWXbDjjXjSYl1mKRTxjYIZKqBiwrWgaStRRY5xhljv7HFP9NKuFk99w0lPcnCOrI2fl6b8Pr6ny0oI7MBwtlkebpb3KzcWqfF5sRVsyCk9jW4ySLp6ry0UxoomJzk+xQyrzhpLHaOEooqfpwUFiFjK597TMiTSTt5WN9wzuUykwiTADhzcO8G3hDr5qRxx59Pc3SQhKvrzLhyYX3v+gDdyPCdI2bPptffkI52kyqwxcCPcQHtvZ8ZdTjDBT4wSaa/ZNs9nB11iLVpukJqmUq22MnPEuNPt8VrfzgYGcmoBf2W28pGJ8Q6zo2vxaX/5QxHqnbXk+DapInSXm/8N5wTpVBEs5TT1kUj/04T/J/GZ3FZgLq4nvsE+IkY/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 06, 2026 at 10:52:18AM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> The kernel doc of mtree_insert_range() does not state if the address
> represented by the "last" parameter is inclusive or exclusive. This can
> lead to bugs by code that assumes it is exclusive. Explicitly state that
> the parameter is inclusive, and add '[' and ']' around the word "end" to
> also stress this point.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

>  lib/maple_tree.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 60ae5e6fc1ee..dc9591218446 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -5730,10 +5730,12 @@ EXPORT_SYMBOL(mtree_store);
>   * mtree_insert_range() - Insert an entry at a given range if there is no value.
>   * @mt: The maple tree
>   * @first: The start of the range
> - * @last: The end of the range
> + * @last: The [end] of the range
>   * @entry: The entry to store
>   * @gfp: The GFP_FLAGS to use for allocations.
>   *
> + * Note that @last is inclusive. That is, @last = @first + length - 1;

How about writing it like this?

* @first: The start of the range
* @last: The end of the range (inclusive)

Alice

