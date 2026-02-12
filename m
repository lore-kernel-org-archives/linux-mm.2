Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BB2BECD6F0
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 08:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699796B0005; Thu, 12 Feb 2026 03:42:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67B396B008A; Thu, 12 Feb 2026 03:42:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7666B008C; Thu, 12 Feb 2026 03:42:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 456616B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:42:27 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1518913B4FC
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:42:27 +0000 (UTC)
X-FDA: 84435163134.06.8822FDD
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5E680C0004
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:42:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=laygvVoE;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770885745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xk4lAjwzPj9EeZuA1UWe5vA/cT3NLbSxLc8OEQhG7YA=;
	b=KGiWze3i7vK6CIuTCTkZhcwVgLJL9NyK92fjvezqhGJGQcXv6k5awn00q44EcAOPVD2mLo
	Grvj6q2RJ7ZzGeGQUZw60Gg0K+//15Vh3+qzvW2jp2nSo9GuojDTjfbUpd74yE9q2GJ2Rl
	cYt1G4EnVn11nZNSp/jKdl1ig7wDrYc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=laygvVoE;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770885745; a=rsa-sha256;
	cv=none;
	b=HH8GCCuHmgt7Lqi1gbdURkqKmDcwVEQFkauqjPtMwWbJlYnNWCZ1Qw5H8Lvtzkmfhuws/A
	lig987kUnk1ajr8Ax+/ogUiptIrd5XSupbAV0l65dF6qXBz8b/zUC5qb959n1tUS8zIJlu
	Zgt1B5eSAee4didZmZ22ZtjVvYPQsCA=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a871daa98fso42401045ad.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1770885744; x=1771490544; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xk4lAjwzPj9EeZuA1UWe5vA/cT3NLbSxLc8OEQhG7YA=;
        b=laygvVoEd4GDosTPSCjeBeYH7GctynYxTM5TCbJrdHiarVC3hhaz6uE6iO3J6ea8mB
         jR469XdSx63rtP3h6MLU/h91ufC5mn/BebjS0qZHnHzyEGDa7RCvfgwcGJzFu3P0rqK+
         L06V7ZASLlRyT+K+WPF2Dm4pwYCO3208445O4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770885744; x=1771490544;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xk4lAjwzPj9EeZuA1UWe5vA/cT3NLbSxLc8OEQhG7YA=;
        b=h4k357/dlvCv6UQpDbZFSnbMPfztSv+Bl9kegHge0/r7RHvcSAS6v09OQ3POnhVI3i
         yN9AJQO5gGNNrXl3Rx7+OUhbmKNjijqQK6Hi9S47JGYv0T4j7zHCvUVpCkVnMb6D6ZbD
         FYaBIO8TiQgkz5CSDhYc4VWlo/UUFrdobNVtZN2/F5idrtxVLZY6y7VX5UZxCa9lSogU
         h/Vh182JtKrSg0B8Fo1BLTgTfWWGX90gLXpKIFR0pV685NTC7P2Wa+h/dyRB4xHdQ59i
         g07yhRwM6Ba79wVnUlflKOO7jGFQqypsAuRB51/CxQrXwN9g9US3mkZwSdmUvSC1vfdV
         SqyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWbuQ6FfydQRvQE8fsRaeZlW+1Eo3e0utPLkgDa1t1oA4gT40jNH7ac/wFANxbKLI5YfnCtrZZzQ==@kvack.org
X-Gm-Message-State: AOJu0Yx705PFmp8rOLMtMDirtVJNXwvds33XJOvza9C45WR+QZPal8Xh
	mmqKeLBM/+kuYAwSJzqMhQWc7ThKWuN2dCewuwo+Fi+BwVKd/pEyAPxqFKfGg3XM4g==
X-Gm-Gg: AZuq6aKB2XIh6aI2OM/y9iktd+Anbi1iYK/G5mYzAOFbx+RCujwzRTUm756PKLM5hiU
	kkobkjFolmCNiQZqNPyjz/XZ0kJBNu89mMy+0ogCjYReFyz6uPon/8VZaZcaFxcK+0k/F1DmmW9
	y/IUXhMy2gfsJfGQzlfiRlAfunxzGLj4nykR020YfSvlTT3Cw6fA25X8cSIccVs73mH+WilIWJ2
	LWu9aF6U1GiQ30hTmM2jkzBXeCCtc6X12ymbju9yhHUbqL0Wf/dcwXFdFRUgZb7A8fpBg/l/hOo
	vOCPi1IxiFTtng5bXJHDKlqP26pGr28BHK2XGI1uxseFp7utV0JxwxH0MtzCKgMVODRHiEeP36N
	aku+Xt2SJlbbvaLUGthdeawfyN6zGp71wf8v6cOaWJm4Ks11KExbHAgBsLlCovfHRZcqd4aR+Kn
	ZuDqdpGdbF6Kj6CKHUcC+sUjIowPfXHg4CrxFb6NJ3yPEJNJNQZcrNUCU+3ztsAg==
X-Received: by 2002:a17:903:144f:b0:2aa:d816:e19d with SMTP id d9443c01a7336-2ab3989ea5fmr20241785ad.5.1770885744187;
        Thu, 12 Feb 2026 00:42:24 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:725d:f34:4b56:7316])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3567e9da655sm4554138a91.6.2026.02.12.00.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 00:42:23 -0800 (PST)
Date: Thu, 12 Feb 2026 17:42:19 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] mm: khugepaged: make scan loops suspend aware
Message-ID: <cd6ra7w47jmroy7ww7imyhmz7bb2yblohls7hd27uxvdv57os5@3i46rvvz2tgc>
References: <20260211031512.261127-1-senozhatsky@chromium.org>
 <104bc764-5a20-4ac2-95a8-b31f41255766@kernel.org>
 <qk555c45mchdhz2ivjrrva73gja2d7uny4tu7qx2f6c5rhanhu@llk5m5gilog4>
 <0787227f-c707-42d2-8f57-5795ca19a53d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0787227f-c707-42d2-8f57-5795ca19a53d@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: tg4bhkb7nd58zrm9wedhjztbtfyxiz77
X-Rspamd-Queue-Id: 5E680C0004
X-Rspam-User: 
X-HE-Tag: 1770885745-773925
X-HE-Meta: U2FsdGVkX1+alF6nadZWb2RSqm2roEYuB8oSQlDU7JYVwaPb5njCujoBRNvEt0Y2t9UDCwUmug89UAkqGfF5C2R9ChPQoX75Y8yagQ7yo1t61kPvfxi9SHXl+xLB8WMdHCmUdAQOQ0Eu7HNvJfJKYcnlAbsy3BxoLRF7d6Ergfwv4SRP6wXtOOUeFH9b/aMzsPQzSb0Yw0XIX4SKl5Taua1JI7Yl6KF21/k9xyLMylSa71p+yt4UOPbi6ZkTA224IwNCZQTHQVKJxBixzVosvW7JGR+qt+Gj7FzLSOtzYUYUn51rbCgi8u2fF8d4iQGa3o+zSWcMyKiNijpjlxtTdQ+94mTmTFQxwVMCVoXm8BilfABN1MHYcRW5f5lAqDHdcre1WqxnkzrVPD8x015kMetWj0E4ftmd7R5S0qGTsvnX217flMZMXt2NJDXHBWJahusnXSiLRratXsIhIZ3S/brTXMIkdSOwG9KAfDk9qzvrWuNz4CbnqRpEZwpcMN/nl1uC6+FSUxnbrD7YXjq177k81Oc0VA095z1C0dNv/LG5UscwuJgdkqL45xTu6PujEh2HsA0Aq0O2cbyw8jO04LkP55w2L75uI0cyZ5f8Pc+TvxLIzYk4OnqMro9xAtWgilZ8YE00ynCoLsd6PP97ZJ8TJLCfi5r06h5cjypnyKAHaEnhzSIj3yEa8qYrRtHquYdd4oT7GIBkxV5IuxRldzclpvrHuRxPelghzGeffUblp5VKYr+f1n+B5TFs/Q2t5ucEm6DYr9we+QGALe1IqrrQxdZt/HY6UXs/h9hWklmSEQIJnpzqPEjNvIU+2p9cpOQq8zyAHaixkwv61eRnbZOkvPcMO6KtS30gGI6k/uBwsA+xkz/rQfkTfeef0HoWleCxmsR4+Z5JQus7xSXDbSry8lKWzdWaf7Je5EortrlH4ab5oNxp8vKh5tvmJ2+FvlWna+9Yn9ioRqUBV2c
 RLtEskCp
 V7GQ6mpN1D8eWGGltqDr33x5lmZCjsgFKdCVa1nzkze+4lDCdeiO9pALbfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/02/12 09:30), David Hildenbrand (Arm) wrote:
[..]
> > > > -static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
> > > > +static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm,
> > > > +						struct collapse_control *cc)
> > > 
> > > Two-tab indent, please.
> > 
> > I initially had it like
> > 
> > @@ -393,7 +393,7 @@ static inline int hpage_collapse_test_exit(struct mm_struct *mm)
> >   }
> >   static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm,
> > -						struct collapse_control *cc)
> > +						      struct collapse_control *cc)
> >   {
> > 
> > but wasn't sure about the 80-col breakage.  Is that what you meant by
> > two-tab indent?
> 
> In MM we prefer
> 
> static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm,
> 		struct collapse_control *cc)
> 
> 		^ two tabs

Ack.

I certainly see "(" alignment in that file (e.g. khugepaged_scan_mm_slot(),
__collapse_huge_page_copy_failed(), etc.) so I thought that maybe that was
what you meant.

