Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 742FECCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 14:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFC418E002A; Wed,  8 Oct 2025 10:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD4828E0002; Wed,  8 Oct 2025 10:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E98C8E002A; Wed,  8 Oct 2025 10:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8EB048E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:59:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47F10B9760
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:59:13 +0000 (UTC)
X-FDA: 83975254986.25.31A8BFB
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4A9652000D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:59:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GvzmOQwH;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759935551; a=rsa-sha256;
	cv=none;
	b=qpKdtMskoYchrO7ErB83eN6cYFKWXfUwafmVZslejRhAVtJIc9e00rrN5+CSKrOFNFqSpn
	kiRlliGlBJGA83c0+KOYvml+2a9bUuef70elewJ93h9YsDB/kyjcW2MdFKsIvEVuMjMzBT
	+r5LlZ1Iu3ri6dRQxtl+C22hRc5It8A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GvzmOQwH;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759935551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3WqvDkSw2KqYGDX5nwqWxTk9V6PgPZ8rHUAzP3TxPgg=;
	b=8S0VIE0KAc43WVtMPvfpu7InRxaAlqTbPyj39jcmEsj8udNgx3tFgFydLfN0YptvQt15gP
	LOqGDzsfZPq4VPF/i0et6lZy5DloCBQznL6//3s8Z7ar0HTwAknEMnKyOtxrOcjC73hEin
	/+HdAAGNmloHay5XGQf5brHUPwjxpW4=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-afcb7322da8so1566908166b.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 07:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759935549; x=1760540349; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3WqvDkSw2KqYGDX5nwqWxTk9V6PgPZ8rHUAzP3TxPgg=;
        b=GvzmOQwHB+BdNYzu9YEe11E6M9nXcKmx1tCuGBzYCHtDBtDz5POUcwIu1FDiLV+3p9
         pFKvxgsHVR91bccgKm9TJFM9JagSYWIg0VQDakB2/xY1cvv9UUumCYGq4rTyqTUl8XWf
         nwqcgXMEUiHvq35ZMOK0WY/40iEA/CpU9wmgsa9I6rEtc/jZ7i0ZsvvdVWQXnVnxT3su
         IU6OUp49SCP6EV5aYlGq4yL6n8DmKJ5c8+lJhCXQAqGmUcBxPtnlHspnf1VT2bWnwIY3
         2J2CsIghTvTfAOY0c0X4ZBFHPpff5E4aGyJjeZtlEhOiq8kRyNYyBfcLqz68RSFpu88T
         WKog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759935549; x=1760540349;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3WqvDkSw2KqYGDX5nwqWxTk9V6PgPZ8rHUAzP3TxPgg=;
        b=ZOiR0OnfjmqtgHocUY7Ui3iRDb+bpPJ2hIRj7T46i4PtqGPrklevUNfNK4Ps0RsqwA
         bl0ppldPowpKxBXteO4oGfZb9n01HpZHfUvcbcJVRSHQv4kMlaKa0tO/lxYB7MHL3uks
         zXqHuI6pVohvJHKaO8cqtfrD+7jmGD7ihXVqhcHTJA680VzxDaY+eN93UDA62X7CHaHd
         PHNYQy53xsLy8WzHhJxo8nmah1b2AsmUjBoNT8Yzp7FXmoQZkBiXAj8QoMtOQ0Pypz47
         f06AEUY9CWHcB0EPYcQXLZoIjzLtWIGLGBCQyusKN0skJ9czBcbNYFRns/UBXbjYSjOB
         dLrA==
X-Forwarded-Encrypted: i=1; AJvYcCX8O5Q6AcD681tLYnOP8H17y4biRAi3Qoe0bZsCFp0QS+LGQR3Po9KcgypMYiPgF7wM/nqGQMlIjQ==@kvack.org
X-Gm-Message-State: AOJu0YwYdawBWcJIuVfz8WBVwEBUoFMp8SEnYb0+6tMexAfm0XB8M4d7
	dCkJZib38Cz9aITJUMmijqZIgYlRv6hgzdWSfhqwZBBn97idsIYDeWkfGYPAQRiSfLA=
X-Gm-Gg: ASbGncv7zGxQyLMM34hpQTCy684GjN4yjCqMNl3aCPrWqZCveRG/aBonzaxjfSUHI60
	modGt8QZQ42DgvyQnGyqUAl4ziyp2yvK4sChd2qw7GEyB3FEy1HeMv0LPTxyKwNoOytl473V1nN
	F4vNyKFGzGsNSJo3Nc2tWkkD9AFPL98aOJdLwWGadB0yzi9iZVul3wMB6rP0LIkWGdBFNrI0mvA
	UggfFMc1Mle6C25katiMK1Nf16J5tXeBg3r8MR3XHAUEzWHv1Hp/sAyASrrQMnL8W05o7VHouoU
	EoLQpruqVqP5vQyoLuLdeZi967W/QIXVmuBV/1G2XyHMnZhFtcZ8nxeiEuEkhORlOUHnqv0hsZZ
	MOLv1rqdnORFHEQvoSNXi1aYVHtOnNmb0KDbqaYXC9Hnm8ijaZU7zzqmhB64UbWnSn/lST4s=
X-Google-Smtp-Source: AGHT+IFBSess4JhPzPnfqXQ4vaR52HMiQOJrNFMXBMaP94ew77X1V9umXx+wx/PFKR0AyuDpLcmESQ==
X-Received: by 2002:a17:907:25c6:b0:b3b:4e6:46e6 with SMTP id a640c23a62f3a-b50aa393beamr401394066b.1.1759935549398;
        Wed, 08 Oct 2025 07:59:09 -0700 (PDT)
Received: from localhost (109-81-95-234.rct.o2.cz. [109.81.95.234])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b4865f741f1sm1679808966b.39.2025.10.08.07.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 07:59:09 -0700 (PDT)
Date: Wed, 8 Oct 2025 16:59:08 +0200
From: Michal Hocko <mhocko@suse.com>
To: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, corbet@lwn.net,
	muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
	hannes@cmpxchg.org, laoar.shao@gmail.com, brauner@kernel.org,
	mclapinski@google.com, joel.granados@kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mel Gorman <mgorman@suse.de>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
Message-ID: <aOZ8PPWMchRN_t5-@tiehlicka>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4A9652000D
X-Stat-Signature: zgg17ps8ofdn45z54of7h5xzi1rhs3mt
X-HE-Tag: 1759935551-457747
X-HE-Meta: U2FsdGVkX1/HH/2kWvxs8GaGKL9Qk948e44Fo/++xuaQ3FP3kyVtVPCfm2BNmCzf1h8NsKk94IlHCKSvlvQuEJZRv3ROsj/ix7wPankDJSq16KgoQZmGMwiGLfCCwNA9XF1l1j3SkupHYesCD2B2uShn2LcNg6BIUFtAcqwZOIfpTsXSIXXN9OGuy824YeMNts2Fdulb/ouOTILG/IbDmFbmaQ/lMTCVR6dSrnptM8inSWRd3mKM2iYwqj5WbpwrnHV0gkFkwRXL/wXKNb5jwgomoFaVWfanya05sl5w7cWpqbTJeJQld3u2x7bDGVbXkrLTs8WEnyR6+xibg9Ta9tFR2Rm2S2vssHdT4MAqlbIJoK/e+qAPt6BgMAmB27AtO6M8GdHIapsnYBaYeZffbAdc9g1upIMlKQjudMuru2dCmt/Vnr6aTEEdN36e5Gitb8i196FyuxLrpjGN9kqIYOa9/6VtRqyE+0KVKXItbpV5B62ac8dFhsh0KohSFyr8Ah+Kx5ovvC2M7p6DUActRWlN3U7WnRCqOlAnZxzmoLUcfTBEjE/2ScOdcNGvwGdZbOr/kWGlAVLKmwDB9BNQFOAQEe5EW2kpPzakYDJY6Vq1SdTAtuuR1AdYAlNRRpPNIg/DkLaZwl/L7qLQGf/5o+pLvgb4fqfLgFrqaxMmhXbGJiNieQuIyhCUCE2hwbEmnMk850M8rWzbDvVt73EgjtbrYUVjAnKqDResK4ghMNEnn/JugfnD21ReOHjvSF7w0rQvgti5UcutYqbN4Qfh2xJL1W1MN0il5VTYg/aTzZLOw/bvuiBrw59xgbHGIAZ2D5rGqlM84eW03oCH0g8ZiaYFs6e4rhUviqbv0Op/PQnMwkhVWdiUIE2ySOGvd7mpMfSQxMfFUYgFyMHtb+JEB28fopxHqA2tDPFbjXELd8OG3ta9S53SWNZvIglhw5VyUyh8tLBZAvye541dwxj
 /H8kWTa4
 ly3l/dTdtCZUUbEu83iz7k+v4hyRjnu+jdHU3lm34mzePre6CwIuT9fJiax+4jg4yGZ8NkH5TNfHhdXHAQsMWPdPDVf1jBS9eWf+gewQ9uBK7QwBKu6OQLOPGO/gtNTvoCKIAQzNOindcRg7RUXnfd2FGTEU/1lz/kI5qmi08FvJErDBQq+nFpOAkXU57dsoy7/Gt2/m+eEUvImDTJxALMmOMA2H1yra1MI5AhO1XKmbNwNoLvy2/mqR5ytO16X4R2uULA0aZt86qL1siMbQxY+BKrBDLpxo6jecJNCTczZr4oUYsdjgKVu3dopI4T8c20jxigK3nhRwYbJ8WsK05d6D2P+o2HWxfN7Wk8m+2TS2Ji/hkzlNqCHAfdOtNfcZu5aJNLYUcbxppxEbbRhhTs6rx6FabyRlMdhF/6U/WEhwwzVVCAlZY07XyGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 08-10-25 10:58:23, David Hildenbrand wrote:
> On 07.10.25 23:44, Gregory Price wrote:
[...]
> > @@ -926,7 +927,8 @@ static inline gfp_t htlb_alloc_mask(struct hstate *h)
> >   {
> >   	gfp_t gfp = __GFP_COMP | __GFP_NOWARN;
> > -	gfp |= hugepage_movable_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
> > +	gfp |= (hugepage_movable_supported(h) || hugepages_treat_as_movable) ?
> > +	       GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
> 
> I mean, this is as ugly as it gets.
> 
> Can't we just let that old approach RIP where it belongs? :)
> 
> If something unmovable, it does not belong on ZONE_MOVABLE, as simple as that.

yes, I do agree. This is just muddying the semantic of the zone.

Maybe what we really want is to have a configurable zone rather than a
very specific consumer of it instead. What do I mean by that? We clearly
have physically (DMA, DMA32) and usability (NORMAL, MOVABLE) constrained
zones. So rather than having a MOVABLE zone we can have a single zone
$FOO_NAME zone with configurable attributes - like allocation
constrains (kernel, user, movable, etc). Now that we can overlap zones
this should allow for quite a lot flexibility. Implementation wise this
would require some tricks as we have 2 zone types for potentially 3
different major usecases (kernel allocations, userspace reserved ranges
without movability and movable allocations). I haven't thought this
through completely and mostly throwing this as an idea (maybe won't
work). Does that make sense?
-- 
Michal Hocko
SUSE Labs

