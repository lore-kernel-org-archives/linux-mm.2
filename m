Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EFBBCA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FAFC8E009A; Fri, 22 Aug 2025 05:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ACB58E009D; Fri, 22 Aug 2025 05:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62BEB8E009A; Fri, 22 Aug 2025 05:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9398E009A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:59:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 10B8B83DA5
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:59:00 +0000 (UTC)
X-FDA: 83803944840.16.2CD67D3
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 56BF0A000F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=BdvDutww;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf25.hostedemail.com: domain of ulf.hansson@linaro.org designates 209.85.128.173 as permitted sender) smtp.mailfrom=ulf.hansson@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856738; a=rsa-sha256;
	cv=none;
	b=Y+sqeSSAIEI7h78m3CDJNQjAMQ0v99hQKzc+eGGSOOZn1fNudR4CzNjp//eJpaaSQZv9Qp
	1J3HOBPtxlNs0Q4tWFe1g9jXk/h+lB9ArevCdjicvmWQ5AEhPfIxlqkWyU2ian0VRPIK20
	4T7RBtF225SVhMM3cr2s9hJR5WcE1to=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=BdvDutww;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf25.hostedemail.com: domain of ulf.hansson@linaro.org designates 209.85.128.173 as permitted sender) smtp.mailfrom=ulf.hansson@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ta0x0Etwp/qHFHu8i5E2Zmb/9HCL2i+tnxSvK4L8KnM=;
	b=SlAId1KRdSkLBJui33cwJxTOFmq8KMbTcUUxvWIMcPEIyPJFJeVFK/Ggyls/5/SBRwo8kx
	mfP+DAxHIPESCKGC9zQcG+mUI13CIFfUqCln6bV/DIBY3gulBhks8C+2JS8jR3zDTOBwww
	qSSkgKF6wngUDmrrR/8QGsNjdblt5bI=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-71d60110772so17435967b3.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755856737; x=1756461537; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ta0x0Etwp/qHFHu8i5E2Zmb/9HCL2i+tnxSvK4L8KnM=;
        b=BdvDutwwjSslgBANMrE0BVWTME67jZfrV5cz6rPR7ORMTGBZnwNsdW2DTHoit7+qq4
         +/tymryzCZLu0C/gtZeIlDxUXsQM9EiGOlM82J0gPMfraWEshcw+fPZiIML+5aUKpKFr
         i8J8SxsZ3G+5UPrw7X+OICZVgZQczboN0dtRLVq1GQbwTtKXk5lUhtsoYHEB07oibgyd
         9OfrtWpHCk4VPIijWTmvHwaU0A4/JN4rx3tseadp6KlkHYkOZxBcfjHLZouii5gZHlU8
         CM7M4NSMAe2dufkvib4gQWFmjIsWwoC2hqQqKpEosZsJMFYdPHY6g+j1maw9lcfXav6B
         US1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755856737; x=1756461537;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ta0x0Etwp/qHFHu8i5E2Zmb/9HCL2i+tnxSvK4L8KnM=;
        b=CvqHqY/55rgROjstvxWPtQGg/8M5M3Zayvnd5cYq1yHAE18oNFfLwOIhxk4bArwDUR
         MQIyFpyMqvLfOLH/ccWTw+4+m7yKwHndk9WvgIMI0ILi5NYrOKaP2LsnNxYiuZaxjTQ2
         /wO2myw6Pq+KRBizNvILiXMY7vzk+DTRFBvNgMToDnV7KxWwbxazRgGeeTl1BEtXmJtV
         klV1rCQ/ozY+lKuwFWV6LSJSlr5KJ+tWs2NpcoV4QQRPJwkanPPhLrQExtWXWHJ9ufzG
         2JMrp+KOgmtFt75bWtIB4Oihu2wd5Mg4m9Ll21pN+yQKjFKzEpN7M0NsiW8eBupmUzll
         6ZeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLSkbEHK5SXhrgMcpW2G6Ws3EdNwOpNtPZ43mhklZh8xvsHjIpk33MkFYC3pkPBk0xwEHDuPECZw==@kvack.org
X-Gm-Message-State: AOJu0Yx/UzZWMMK4zQycwA2cY1+wV2UogA+sH7q6YPxyETlXG0lBnAhP
	RIwS9IW4aNUSvGM3QvHlC1JXWNQG4Okw8R/6PfmVWfcnjMLqk/BwY3U60LJsjTrYpYq2j9cukOB
	aXfcZfgBdW7yGO7cw9TTnX2shqFb145GueQeTAAgF2g==
X-Gm-Gg: ASbGncudhE8tehgSe4l08oDftsi1qAwQqlp5F9vWCVeQwAPTieIvRDYv2vEUTDhjw/0
	/80/R57cYuUCykc1xexYSpzuH0IyZ6mFFahLSmPGmtiqYwkqZ/Ws8DR8YTpAjqRMw4Wawuc1lNb
	+q6bFV0AArocfZphnnutOA6T87WKa9tUkbeSJOsrvxPVXncY91MYKNRU97opS/w2cwarAdOYkys
	sYzKB/r
X-Google-Smtp-Source: AGHT+IFd0X7jkwq2XGOJ7EKMxon9dbw2ksIcL5ljDLbAAX3e91uv+L7uUO91qQDTLkLCO0orfNEA4dlYcWAaDmDw/cI=
X-Received: by 2002:a05:690c:6702:b0:71b:68ab:8bdd with SMTP id
 00721157ae682-71fdc437461mr24057427b3.39.1755856737275; Fri, 22 Aug 2025
 02:58:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250821200701.1329277-1-david@redhat.com> <20250821200701.1329277-27-david@redhat.com>
In-Reply-To: <20250821200701.1329277-27-david@redhat.com>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Fri, 22 Aug 2025 11:58:21 +0200
X-Gm-Features: Ac12FXyNlpfyW29hh3KLyFNs0xgg6UyHwa_qnpYtINLnggZTT9u4v5G4XN84Gbc
Message-ID: <CAPDyKFrAth_76byLZG+5+CA1ZELJVH6XaFzfo2i7nYfnMYKa=A@mail.gmail.com>
Subject: Re: [PATCH RFC 26/35] mspro_block: drop nth_page() usage within SG entry
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 56BF0A000F
X-Stat-Signature: gmy56gfqo1sxhkg5czqsrtohk3kryorf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755856738-920168
X-HE-Meta: U2FsdGVkX1/DjJMDEwwDZEduvmv3hbiM7V7dIbFRBjmWatEkUVdOJSwsdYcv8AIyu1dm/GbBBG9xmWKQqr7/q6zmxfqoFp92o5+JBJhuB2MbWqdfpHiAZvxjKc5002U9pGrxTcIEYCWT3BL7NnqErfWeUM2bRQOZuBchVM1627yE126HO8bp4X7uHbbYXdnKuP5jmpHLyANJcpoCCuy3I4rg33Qcmlz4C9DxP4fuqCcr6q23WilyqoX8kUcVtj+ge53fc4dvevfHYr7+r4+WM6iZZJq1TrF17KYNzZOezR5eZcdnPKaMPrbATabLerlirwVkQYTPU4dT0CQlnM07mc7GejEl5Uk6nztLmz4z0xLWG17+zTW0PdVcVpZwk3Nck7QyB6rAg3553TufCvCLc9WXPN/96UFjysYwVDnpv/6Ut+jRLSFD6rv904+kxPB5M0ywn3VoaxtepGqK0vVg39BHuFOgozeCovZ+efS7sJReWWRfT8wyMHjV1CsWwZQx+Bg9qgGGEz88Nls6gDr0k2lZ9UQsEwuNC0mz36XUxSXxPB7c95FgFSXAgDqP4V2lQ7ySbMemJ6+MFpUTuKKW/NqM4HYK2Lq/1Wn0rvtTyY9zKQ0eTTgqmzSt51YEOBnTrQyxQ1Azw7pYW6VfP1sMUtTa84GqxCdqy7svGwHj0MfQkipCkqHjZFRuDlFNESW0jGzvc1a5HSfTny3931R7PPOfuhZ/f3VGxuIOTu3UXaDMSh4qqQmf3XEJXaq55WOxI6fB4vRNecBHVYHUvHcDUsQaO0lIqkvlPgkfwkRw9Nz8VtEd5HBxycotDi7XHwtUXl5X2orxZUh9guJUFR7P+lFHt3vAygHTRerZ5+ozopk03VoZuEy+jwZ8Zr8ROQ4qevmdDkUq3fTHzuBAqzERGF5+8/Yv32s6lNzNp8LEajuXuQd4ObIbGLQWXr+4YXP2zPYOnnV1nmw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

- trimmed cc-list

On Thu, 21 Aug 2025 at 22:08, David Hildenbrand <david@redhat.com> wrote:
>
> It's no longer required to use nth_page() when iterating pages within a
> single SG entry, so let's drop the nth_page() usage.
>
> Cc: Maxim Levitsky <maximlevitsky@gmail.com>
> Cc: Alex Dubov <oakad@yahoo.com>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe




> ---
>  drivers/memstick/core/mspro_block.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
> index c9853d887d282..985cfca3f6944 100644
> --- a/drivers/memstick/core/mspro_block.c
> +++ b/drivers/memstick/core/mspro_block.c
> @@ -560,8 +560,7 @@ static int h_mspro_block_transfer_data(struct memstick_dev *card,
>                 t_offset += msb->current_page * msb->page_size;
>
>                 sg_set_page(&t_sg,
> -                           nth_page(sg_page(&(msb->req_sg[msb->current_seg])),
> -                                    t_offset >> PAGE_SHIFT),
> +                           sg_page(&(msb->req_sg[msb->current_seg])) + t_offset / PAGE_SIZE,
>                             msb->page_size, offset_in_page(t_offset));
>
>                 memstick_init_req_sg(*mrq, msb->data_dir == READ
> --
> 2.50.1
>

