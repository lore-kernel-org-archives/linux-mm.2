Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A3E3CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 08:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 954176B0005; Thu, 11 Jun 2026 04:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904B76B0088; Thu, 11 Jun 2026 04:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81C046B008C; Thu, 11 Jun 2026 04:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6486B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 04:34:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F028C1F39
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:34:53 +0000 (UTC)
X-FDA: 84866971266.27.DDA9EDE
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2952720002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:34:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="iqi//V99";
	spf=pass (imf13.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781166891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2UMrzR2+SVHqKWgSYoVZBjp/ERVOIsPlQNqX6CP0Vdo=;
	b=35FFRNwnmsWpReVibSIjEb10XQ8KuSPh8NrXVacO4YbxaMr1wtrwIl1zE7x7/sOJ3Q6GqC
	/OtyhSf13UQXRC8Nqip6tIKqwFOm/H4lqTokFVXbNNMrmjmGN+1ty2QBIYJpglVFmaE9Jr
	1X8EszwJZ74NG/Uft7bBgoTB1U4F04M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781166891;
	b=mpZjXM/jaIWyQgesArJs7xEIVX9vr7ckwQGmYfsUw+jlG434kv9Rpea5qGPO7DgfVVC0qK
	nTTOdcZUgnKayj8xbNwQL8snPAEu77q/ak/iOl+CVh7zjSpPyQQ27GCozQS9EMPoGngj1G
	uLdBban7+40ZZAevRs5/pObqQNlap5k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="iqi//V99";
	spf=pass (imf13.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490cf3000f0so50925275e9.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 01:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781166890; x=1781771690; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2UMrzR2+SVHqKWgSYoVZBjp/ERVOIsPlQNqX6CP0Vdo=;
        b=iqi//V99nxBaRUxZjuymO3NW9yvGna9n2FJYk1AtenDDXBFnHLkoqT7xIe7+Ylc/fQ
         Hus6a53gB9ELmsihxC88XMvG7DvhHj93X0q0JRb0ImWvq5rsbLe8ikoYVe1Ln6/FAX11
         hIRA5kseUTjUBYy3rhuDrArjFyw8Zc5/eCXnGsVBkYfH4NlY9FYojgWvfaXWNVcEgxwg
         PLOwbzcT6S3OnXpn9uWtEMu/nGsAZgN/4tc076VXLX7NIh2stlFBUf9xYfuXsDBQ33N4
         pXjGs4Ib2TOxGNZNInKO1AKlO1hs+Ti3aECRj+/v3ViDg6hJfww/2VMDEKvlCx98pGWO
         kz8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781166890; x=1781771690;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2UMrzR2+SVHqKWgSYoVZBjp/ERVOIsPlQNqX6CP0Vdo=;
        b=pe76XKh0RU2nYCP6wQS75dpRkR24cdvFyVE/r3Whoo2NUCtrh12eRePKBx1wosoo5B
         mp7YYDF6kMgaVuXIstB+papgDVCnE3+JNHeeTKiJPlP/XeoWIz+H7uDjjgbxihVG+lvR
         kNYEXRlc2JXUvUbWXgwosgzOHeVAzKmCJrv4I8cO/XeqPZXmbkm3Jdx4r6yqhvMF76q0
         QIzdiToIQwtLgj6xJwqbnjIHYg8oqrtCd28ccf7HVhEe1gbREUhTOGzNFQ2Le6G3VqnJ
         FIP2IXa+JSJbf5pTRcrOwkGp70OxBe83uYGH6VteYrTrYK1xMPaSG9V5ssYgm0DJrLgc
         A8rw==
X-Forwarded-Encrypted: i=1; AFNElJ+uDbMCcfr+q7ZNursQ+D0r87MuwmXnTvTN2zoqBN3ZxNgwF1h85f2rXJMgDUCgC6gutvwesidB4A==@kvack.org
X-Gm-Message-State: AOJu0YzjLEbVz3Je6zrUa3xG2MrDOGE0MiAounOurIgJ/mJ0h0+blrgh
	OFQEzGyUwYNq45hekrtjQOq7I2IxksF6kzVXgOAIJOepicNFbF2zFTgNq+SI4A==
X-Gm-Gg: Acq92OHdP/Pq+HVczbuKRcDKNwQ3UDKih8apt74Ahz/+G/5c/RSRRPu93qSqneOpT33
	ytyA2oSP+nQfbJhkf6YvErTJWsNNrKwmSDHUdlScXMXu+sY121KlvAwU3/bWMSxttlE88DdPpAh
	nEVqfT8sjjMgXQ6JLj7g9XblnBIEGMTPLOCehZcxjp8OKFdTtjkD2yapPRzFmufx7q2TOsICsvQ
	5uFbJvzJahXqd0d/I2BZq0F4f8+9q+u4k10C2m022mAjwJJqV77pnuFVpQec3H06cdoQO6ZMnny
	Ih68BEaYsI3g3ITt6vofHifooO/AayfxFT3fkvumH2VgtjCbrjjwzy3V/m+yZ0fFHy7/5KHJQpa
	H+HpOSHvFKoz02fEOE+sUXwx4WqsPSi/GJsRlfFFDZeRh/YRvwHXhc9dN5+Zzrnefgpv/OX6meC
	ZZOJuBDV1Fr3xETZhxoQYWZXgQ+wELkhLUerNeFnJdL5UvCt4H5TuUXQVBqyXvZof6bAtqG93CR
	v8kqq60BqYujO3AXQn8Q6iUmpXI9gzOaYkt3QJXaqCS
X-Received: by 2002:a05:600c:4e0c:b0:490:bb45:79ee with SMTP id 5b1f17b1804b1-490e5379dbbmr24840205e9.0.1781166889422;
        Thu, 11 Jun 2026 01:34:49 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2e4004sm79045230f8f.9.2026.06.11.01.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 01:34:47 -0700 (PDT)
Date: Thu, 11 Jun 2026 09:34:45 +0100
From: Vishal Moola <vishal.moola@gmail.com>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] tools/mm/page_owner_sort: free per-record allocations
Message-ID: <aipzJR0KnO76crLy@fedora>
References: <ailAiIKTNSDHkUl6@fedora>
 <440C4C1E0D13E6D1+20260611023411.379986-1-chenyichong@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <440C4C1E0D13E6D1+20260611023411.379986-1-chenyichong@uniontech.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2952720002
X-Stat-Signature: faad38uzn59t13mj4pibodwkbtbcri5z
X-HE-Tag: 1781166890-558260
X-HE-Meta: U2FsdGVkX1/hby6Ss2iQe2m/AJgcBw64V5oN/mAzNg30tddkyg1c5D5kdyJ1lLNX5YRAk5mzthU8ommKbwN/JP/EAN64MPHyC8GTHcvxHZ+g5uLPoQTxe3+UCM8KlU1zstYAPHEGm6z9z4ixMevto5eH2cNkoWEzhQvWcg+Z745WeOdtfKKJQg4NQSqlCa/LwMsVAbCybP2ubHGyyYZV8EFfyWy9FYYMjKJZ/jgHiU2vHRUCv4o/Y0MPFHAzjiJ0J8EN3ya4+dLACY8JLhjCDWoGlglJPGkboRnPjqGbpQjjpgrticYv/lB3XJZwBwwScNkAkb7TmBNSYsySlVfIHeLVAIOzSMSpKG+zOKxtvYxCxewxdpuKQCUlgZsuXNgHZJJHtit0ugTLLS4Lg2kGyvnSXTr85Dhrdc6/R9wXTPtv1GGM5ILfcd+CwsyAXAmN1WSZ7Xqs52YKEXzMYEur411buXP96LgH4no3aGJT4OU/gVRuoG8BzxWlg4NJe0hfb5Z+qNZdZKL93blUqvNANkqM5145HZycWi9Rq3/EY6vqMSZc8GxmyY6YMwrd1n51hFkWu7rzDBHlG9ZMQJQ0GsE+1OvDkFEqCrg3wO1ppKaP5TmbZmPD/MX5fzqQyUpB/I/xe7ZTfrQxlGKiWmVAo0KH62BVz6xryYEhIP7ikP9/kOPbDndB4oaMUvXYOM8/5ctMyp489f+dODply32i17syPT7wxsTpN/dwW8zEBSd7erhLhigr3Z48Bb2CcedWebBbbLY/NtTvGUI0Zilh0RYEKhJ30Mjb5a4br54JjpYNqXzwDRCPYEhFvIjoqTjW6cksH3G6xgiiiEqo8Nml8JtXklfuArR0fxNPOCoaNWc8C7y3GTn/0DflFOdXMeB/uOlO7ybJMKiQmjr+no1o+Ij+H218VPjP3jZMxwZ1AIx8j/UVJDYDtuZbmuRdOIBtMTehcwPL0X/iS8gf3VJ
 7Dj9cP2q
 dWsPhIDBzlvS6gk4AmaNlVh8geqTJKskzm2f21DNFJdJW+F+rJkV7SESaJL5juNxTaqek51H0TIlCgqeScuGkipaZhrucPO20+9BxCH91qj1eQJkFh/8c755QZLhoqKjgKYVyRnvmXN4oNl6Vv4XxAOZIEB9UB6cGFIEnIFZ2aSKkOjPvjavrh2htJYHh1RE3WVbDmXAZ3l+X/y/3agPlNunI9MfkK7NxRdhMuhTLAeuzph07THk+oj2QBrNl0wJtHG2zKCgfD7T0opTXyeethN/BakVsdUx7lRJHs4ofB4/nyobl6jN1Bm6LOkqSwoZ+P0hoc9hosaP5NJlB/p47b78v8rmDFYhL17OQZ9oH7cbImzFhIKygiOF8x+j2p2SP9+cnHXSdEJ1LCRgYcL6aGW0FQcHR3crOZ42Exbptg4gf0jxhNy3QdjwAepCqOI/qrhh0r5hB5jH2TZt7176CNDJwAAxGKvQ2mvEeJsTzo4WGjYQMWLQKlrNFb0HbBpAu2B/Wi8GZZ9A6NXdHdQCYg3B9ez/mWBJXJivslJpXOcARwIBs6qozoEqB0HuXAH8ebeoa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 10:34:11AM +0800, Yichong Chen wrote:
> add_list() allocates comm and txt for each page owner record, but the
> cleanup path only frees the outer list array. This leaks both buffers for
> every retained record.
> 
> Free discarded records during culling and free the retained records on
> exit. Also unwind comm when allocating txt fails.
> 
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
> ---
> Changes in v2:
> - Wrap commit message lines to approximately 75 columns.
> - Use "Yichong Chen" as the author name.

Thanks. Also, in the future send new versions as new threads :)

The patch looks fine, just see below for my comment you might have
missed last time.

> @@ -480,9 +489,15 @@ static bool add_list(char *buf, int len, char *ext_buf)
>  	list[list_size].pid = get_pid(buf);
>  	list[list_size].tgid = get_tgid(buf);
>  	list[list_size].comm = get_comm(buf);
> +	if (!list[list_size].comm) {
> +		fprintf(stderr, "Out of memory\n");
> +		return false;
> +	}
>  	list[list_size].txt = malloc(len+1);
>  	if (!list[list_size].txt) {
>  		fprintf(stderr, "Out of memory\n");
> +		free(list[list_size].comm);
> +		list[list_size].comm = NULL;
>  		return false;

Returning false here sends us back to the error handling path in main()
where you end up calling your free_block_list() anyway. So we don't need
this here, right?

>  	}
>  	memcpy(list[list_size].txt, buf, len);


