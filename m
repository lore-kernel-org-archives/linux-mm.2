Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB6051061B15
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 16:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A93F6B008C; Mon, 30 Mar 2026 12:48:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 080D86B0098; Mon, 30 Mar 2026 12:48:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFF916B0099; Mon, 30 Mar 2026 12:48:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E13546B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:48:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 974BD1A06E1
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:48:53 +0000 (UTC)
X-FDA: 84603313746.04.8EB5C93
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id C3B42180010
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:48:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WCXbC1vN;
	spf=pass (imf06.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774889331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2NLtMmeOIxRP35JAbdsv5QIGptX0pyjSKKuORhLkDgo=;
	b=NxPHN99eksSDAf0jxvBdmRTQIJ/9ewW671SHZ28smXFpjC1/vF1W0I1mrGF9WDDXrtCNn2
	+qtglnMMNkMw6WAKGcE4TtX9rKfRJ77tZyqK5B/aPOz1D3sCjr5/eMJEnFQgE10zBFVjri
	rMRdJsuPoVKbBUt/yJbFaTxVtYhIVro=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WCXbC1vN;
	spf=pass (imf06.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774889331; a=rsa-sha256;
	cv=none;
	b=glBdKbUO7/TDZ86oHeaFWUTX9rPnzSe/J4YsLzqzIU7YX6tlKOPvUc/xHDsciO4mxkzD2f
	2NnzCit60wf3XQlZO6YnOGjna67YaMp6r2WhXw1GZqZJLb3Szc7zrFJb1WOSTgMSid9hCB
	4Tp1Uh19cK9qImxG9hpC7g49JOhdz4U=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b243198058so1265ad.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774889331; x=1775494131; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2NLtMmeOIxRP35JAbdsv5QIGptX0pyjSKKuORhLkDgo=;
        b=WCXbC1vNWNEfQaeBeyzqNf/mmqW40iDbE8dh/LhGdi7Ox7UxPavQZNpRPEtnpLOo2D
         L8UpHJumty8vZE3k72BFhupFcxFKih4eA4mHAh15fmYW8C7YOaO+D4xqQJO20XtCb2ij
         WaOAAJG3CXTNLuRcZs/CjWODOGeu73/eutKmY5wsWjxR+U4TFtAlXnzA6a/uJexKA66S
         NRrakwLIUDKrZJjvgIWXwEbJJIhGPbb1ee6FcPpm/ilq4GMkeS7blC9fEbaAkVJV4+EQ
         eTZSPhY1cNDVgenOk/YYjSFBe/pvAiHYnllSpuJL8si4eMoakm6RQqgawC6YRpaqG2k1
         XwzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774889331; x=1775494131;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2NLtMmeOIxRP35JAbdsv5QIGptX0pyjSKKuORhLkDgo=;
        b=lVxjR3nzx85P3mLHCeEmnUgDUZeFjtjj+PeRFrtGXUwjuxpgXeqbvqeULMNSLHiNDR
         LSBFjV0ZbTf76xetFMVEXNtnHRTd67InSrgO5I1Kx2IrQs9pvm9J5G59tGJayx52YuYf
         ZrY/n8QYrJfF+DgK69o2rEbuOwL4qUaAMhpF6JQgm6dHaD4q7U+daBPLAydExUJldzZ3
         bP4xaLupjwy9VATj5IEqX3RUgU9ro6fPAh3XMaWU7lhyworTRwAs5xUxe/VuX/8vmH2z
         ea4g5JP0dSB0OuVzxGoxcUWJuCjRxCVPjOcowEIU1sI5MDNC7rbOMuWcaMUNTTYsl/hT
         hM1w==
X-Forwarded-Encrypted: i=1; AJvYcCX+BVHQONWGaQKhMZa9OuGSkd4KLbxyOZVOmQ6OBgzZuCIAdbwdPWQG8gprsPkeLyvWB1R6gCRydA==@kvack.org
X-Gm-Message-State: AOJu0YzZZ+42eDhIZMRxRMUOHxWupiCgenUsd0I8980YpdGKoIWA66gC
	v/C1DjentQZn6qVLHx0UxKxf/2GbRPrXDXCmQlDazmzPK8dWhnRCEoD8KGwHLMmdGw==
X-Gm-Gg: ATEYQzz6bPdQSeYOTTdtjKSkOwR0yBi3QtYalcCCTDf1cwm+hNZnKjlcvG399Q5MPUG
	MaA18iAJIPzSU7TrR3JGBIKlutZEMVy2QBzRR8bOGvFuicEZGqYwHZi3MjDc4nhSYaHqSGfnzJr
	ik+j1KPk63eick2wEiVuuuFKbv/H8YJR9ltNwLOjN16Cyi1QzYZxHNSr70l28KsiqTK9fa5RwGc
	BerbU2B8KPARwsAuUnSUujkANeEKuhnR9q5QkIFYOKuueAVOv8R8DiU7QJavNfJxpP6sqtNatHo
	PlrvQvmmqD2KXdJb98sN9vs6DcgV9ayReES/2kTPMYRJJiH9GxtR3oDEFWw6RTEv6zThgtYGRxg
	13yD+5ncvPYTkwpLZrue0JQeUfKIl7cjL3XBtKi9Y+vcxFW5pXv4+D0cOQsfnSJSNhQGNiRNY2Y
	xp+uKb3v/eREbt8KnBrOXrsyhF8Uk7cyWUYr4S1ePjv5JEQ30Noqd8j2VI1ztZmJEE3wAKIi8kl
	dXp9qDALikv/8G0XGwYAJ/QRXD/VihAJCXG1ZIlgj1MPUy1AH7dqw==
X-Received: by 2002:a17:903:41ca:b0:2ae:575b:2345 with SMTP id d9443c01a7336-2b242c7b15cmr5183825ad.9.1774889329869;
        Mon, 30 Mar 2026 09:48:49 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:bec3:8e5e:fca2:7852] ([2a00:79e0:2eb0:8:bec3:8e5e:fca2:7852])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242643381sm92008635ad.5.2026.03.30.09.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 09:48:49 -0700 (PDT)
Date: Mon, 30 Mar 2026 09:48:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
cc: Vlastimil Babka <vbabka@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
    Christoph Lameter <cl@gentwo.org>, 
    Roman Gushchin <roman.gushchin@linux.dev>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: Re: [PATCH V1 1/2] MAINTAINERS: add lib/tests/slub_kunit.c to SLAB
 ALLOCATOR section
In-Reply-To: <20260330120517.104743-2-harry@kernel.org>
Message-ID: <8ec4026e-7e9f-428a-610a-a1c6ba7ff89c@google.com>
References: <20260330120517.104743-1-harry@kernel.org> <20260330120517.104743-2-harry@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: 615tfxw97hf9c3qdjdbjcxxpwb7waspu
X-Rspamd-Queue-Id: C3B42180010
X-Rspamd-Server: rspam09
X-HE-Tag: 1774889331-528793
X-HE-Meta: U2FsdGVkX1/73VX869xci1csPQwNrIf70QrMnuiAlRfrHrSfBG6AjAJi7JU91N4RH5lZ1PzeajvTaQbcr0mBE68JTs0afue+kAdqJrNLNMFrHy53QPA1ksDAZoEgfLRRGMNVy5Y75VmbDeH5cIa3e6qNu3jPCdnW9e2rI3n3VacE4O22dl5ywv/+xVUMQtLh6AQtNjAF7rRsbNHbqubWEudmE8SxDmwYHoF7XDWQWgrrfpiTvFONqXn7TBzQKmfLtW1Pg8GhdPeTsLUDaOQlP0Gp5iHlr0kJxmqHDyNBWS33Y4M+wh9BhyAZjiMztKJ0cm/zSlznGoSx+duJ2/hesdVPI//tlmW2+xNDDofi7K4mkkBwX9ipKZ5jvobx3zMpMJ0/o8jUjQcvBBzgc9WCaAfSeqliHYmjD0aBLrds1v3gf1skpEsrrXEx0fL0XwfpFEk7b75N/MlIRSS3w1liGHaEr5fXDRcWwQO6Lr/jQ3T93cb2vJopzBq0ZJDcQtgfRVMnkA6e9+nBg7iuvqwsHbcxhuiFNlcW+8xdDBMH25Qt7CadMDct8Lz1hBcdPEMW85N08WxqSbsZb5rtG4AyY5Ij6FU4+xKBhreig7L4kfFWtRnTLc9x7jgznQdq2Ba7jyvCpxWZwslEhPZN2vvT0WC1SPOFIsmyW3XcNOzXyW8zGKAKDZ6HykJNxFzB7Zfi2pzXHxxibCuij1UH16xv9S21tjqfF46P5hHv4fbPxzv1uNjSvHUE5yGQNMi+84voYGZFFc/wvSgb5PRiLZuKpfPqqrOZ8n3/Bac36N8RE++4PpTVQbKM89+8m86HAKnoyDNI7kVAdMdQ/n9JJHX06osWRqTPmEIF+KZu13O9fwDHNwh96nQaJ6hrnowZxgrLNqNpMJVNxV+tevUluRv8r3cIs/Yd8K+H+VUKQHtkUozImEKfdVeIjZuEftpL0dhNngCWOL5S0GWEF48GmUw
 6Jyn3KV6
 Vy0/5vzAokwDyafdzY/lKFJUZJt7+WDCQjK/it6KbTqFgdf9iIE/9KJGwVL8iHkTAOhXHlD7Q37kwmA+7CDv/wIB2CqV5QwY3e/kebCo/k8geGhIGGmLdOa+0UchVwDbbgjdMUGVCvP86uHSYjEDGqM8blJmu4HPp2fk/gseIfA8zKFzsTb9ey6uymENoyGJIPr7l04aKx02SYBnm1VcS1+wWrvk9Zc6iV/PxcqVHT1p1o05SHSoCT5UsMd6gSxnhzXSp+sZ5wK+yR02PEWE10Hgyb5wjtas4r00pI22jU7LVjlCzCE0f9ynCrQHMyHOELFSkw8uS05oe/iA0ZnTUn1J/eSa423eDiye3q5as8vC6whbvwiLEnlVuz/SUk/BHRLnzd062fQQceqWv9Sf8BbVR9TEvKtpKK1gXPb3cFAFCYFmUjnaANj7uOPmn9/EXzKMjuBvU/f/WSwQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026, Harry Yoo (Oracle) wrote:

> The slub_kunit module has been maintained by SLAB ALLOCATOR folks,
> but is missing in the MAINTAINERS file. Add the missing entry.
> 
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>

