Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C678BD46BEB
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 19:17:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04C766B0005; Wed, 28 Jan 2026 14:17:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3C5E6B0089; Wed, 28 Jan 2026 14:17:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1DF36B008A; Wed, 28 Jan 2026 14:17:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1DA06B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:17:24 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5EE1614075D
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 19:17:24 +0000 (UTC)
X-FDA: 84382331208.03.C5F7A25
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7C7D74000B
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 19:17:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nbMaDlPl;
	spf=pass (imf12.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769627842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=foymp24JtH4ZC5gHeCXURFQMtU4VpzKeRfs9qQlLjHA=;
	b=rQVpO5dr5MwyIBiDzH5jk9SHzduzgTFbhAwhD22Q8zGlki+1TwsmEhdx7GmAA/pmAUT3ZE
	uU1G4n7bN75+5zEw3d9OzUf7357OCkiZ0bgfrPLQjEn5J1ZuH6W53NL65VScvkuX62Rxju
	pm6jKDbUnyVjKlUju+Ff0Tx2yAp0YmY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nbMaDlPl;
	spf=pass (imf12.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769627842; a=rsa-sha256;
	cv=none;
	b=szn8LC6ag7aMGVgeWk+TvxpTrzJKSm6ClacKWcXjzMO0Mca0KCp5fON4Ca9+ZKj0EOz4A3
	h6VT9YNKYTdXuXeq4Q+h9WqhRiQOiekOIatPW70TdpeaMRqX5vpZK7XLErPC9GJt9cO29N
	yJCu7pz+6tSLgEacSoxZeD0Sez7DvOU=
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-2ae2eb49b4bso599613eec.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769627841; x=1770232641; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=foymp24JtH4ZC5gHeCXURFQMtU4VpzKeRfs9qQlLjHA=;
        b=nbMaDlPlAMHUol54nhHtr7OWUa9qEKmI1yXJovjLiexEpv3S6XRFFHCivooS7Sz7xl
         kyHTjabTmfIFete+X/Eg3MdVawTs8rbIlSx4xObT6eIc8nS3jmO8FS6qHFzVQHFCWvJ0
         USmKlj9CFagr+xyIHUyuCC3UyToodn8T7XuZK5jiX45ejtnynyEuMFNGdvSdSz7iFV+H
         IoTJ3Wr2rapr3o/mQUlXR4Xf6b97grW+HOa/Sp32GLkrPE7f9qNSaC8n4Q+Q/qsPmCaN
         /ImVEOEHkSUKs0pStPlNJoa+lU9yLrrVfsCoLcXLm4U6duJmbP+jCFo2jIoxCA/HHMh8
         r0kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769627841; x=1770232641;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=foymp24JtH4ZC5gHeCXURFQMtU4VpzKeRfs9qQlLjHA=;
        b=LW5c4+BRiqqLbc1ZPpRu6tQfmfRZ3MmwkrGF/7kmnbkwlCApj+9owBQ10HmNLEcJtk
         tk6c8AYd+KDyy9ZaHzjybhbvP0pFtxqyByKadGMkA2VcdrQ4UK5tIO7umIMzIPqh1tvU
         sorl7R2miOVvEfQaYsXRUVVqSCQSo5N91SwfA8T1U6AJUTKpGuZJraouj8xEFX8I8+Ef
         N9hCOkZyoxMgF8LV8QMMDyims1yJs/UGWD0nWNmKHABI/t/MyMeRlP8ytd0xNMt/PgSu
         vNN81G7XicehCzBWuGi2evMZpSSYEF9b5OrJ2pz0JO0GrmSPMzKOGUL5WUHIDXLr+Jxg
         TvDg==
X-Forwarded-Encrypted: i=1; AJvYcCWT9SdUrkx0NLJ4V+H9UDEOSJVQJUzlXgUov6QmkzHN+7Q1go8IKBD5xYL3ymjqmlY7vb8rE0fTUA==@kvack.org
X-Gm-Message-State: AOJu0YxcCSvztEF0TucGQ/gLPB0zIbDv7NBEP/SZJMdI+PHmYrCbXm3F
	Y9+a7olhYaDFxvY2PBaXvkGKSESGrnrlMVM2T5hqUZXB9LO0BpNOeDAY
X-Gm-Gg: AZuq6aJtxuMnB297aFW2Un5DwmrhSlA1g9U+dTAnj67c2l5bd1TrPxCs5SExeM0t0D0
	vJtDELARiAwS5PrzwnGEPBp6jdc47qfRumlnpsxoJeP8reAHtRvRHUgF+I5eZ8KpCkaHpGh6mYH
	fLJwFfW/QnTYOxvrgP5L44mC8D8tteN2rUYz9zRsBIPU8iV5VmmEey7Szg74WZfOZeUYU7OregE
	nog7+Nm/F8wakEKlbyZbBvToPFk+VqXgU3nF6RtzinQA8fyl4lbrJ8MNanad7p14aeXnse+u/GN
	bjazSZYamH88wamyfX0miuZ61djyxCBQKUtd8zq5otOnge/N36I9i7s88V4wB3wwSeCp9k27P1/
	GOQxMRuMppt6YfoRPRJNN/cq09eVOTpZLQ15cS46IAEegnvaPfXkgH4GvlgSOMalt8HXkwaAQsf
	DBjM/MLYf9un7s/4mHEjFS7X1m5PnWmeiJmn5ju8SKtnQ=
X-Received: by 2002:a05:7300:7307:b0:2b1:7910:b102 with SMTP id 5a478bee46e88-2b78da133fbmr3982778eec.37.1769627840996;
        Wed, 28 Jan 2026 11:17:20 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-124a9d6b663sm3521180c88.1.2026.01.28.11.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 11:17:20 -0800 (PST)
Date: Wed, 28 Jan 2026 11:17:17 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/3] Convert x86/mm/pat to ptdescs
Message-ID: <aXpgvYe1BySUXnKf@fedora>
References: <20260127005140.197847-1-vishal.moola@gmail.com>
 <aXn4i6Zo8OKyVoCL@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXn4i6Zo8OKyVoCL@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: p5ime5g4qkq3s7zp8crecajf5pxssyxm
X-Rspamd-Queue-Id: 7C7D74000B
X-Rspam-User: 
X-HE-Tag: 1769627842-881369
X-HE-Meta: U2FsdGVkX18T56O5m5nd6LAbRKqXgz9RVUw28ge4Vhy+If93ip3Xvp/yHZ2tTzg5dA+xs7uo3o72LTEd4MwM1hbveKw5L9wnRY0Kf+PikNFb9tKjL30/zzs/ujF0u4bcsdRMnzB1eOY2uGv2yXqRK+jDIt2A0myZ3wY9oW45ZQzZgZ3kSasYblnc2WcT8L+9k9VmMxtuh1mJxC2ZvpxwgZ0uHG7v1+vNT14ri0iMMyMG+iKtn74kipONmvGn7GZKkF2Z40OWwoYw+R4ZgBOcpHJr/CSV3ycxGPJI4JpG7xdb9ZBSpXaivsXE4gGvjWmWe7vsc99hO8fPw6v1+ZIESIfpGs0Nusl9+rbc6PnDOcuRER+ONImjk4ZJqkLOxuoD45HK4Bs1hCSt5cHyMsOzVbzlBwA9yxpJ3cdVc0i3gYikqeD6daHBy8gyovVWSWK16zAojOC6BkDFFRcWIZ48BrTgt1xy7B6/agVFLfBMkeSUd6fwycjcSq5iWW0Xs9ZqM2Ai2ioeH1C4DjrmW3yNEX55ynwK7+mCEQlLONe/U58m9vbSaCuqkFzGBZG/AOV6p5eToEh9bAperoDLxYi/E/2Xof7WmXGaBK3hJ6UVbd77uSC0IeojPbRLEG2qCZRnuFa5r1WeEdP6KeMBkXGZgCTpfhjaTna+KvGWW93davqBsXm5sAh9PbE++Han/sMFHcfC0+vWuyN0fI3HHixKQJOoR4ei1hzPtJ7V794lWz25OgeY5V7KLulY1/tNNn6QI7eSRG5yD0AZ1oROTJ39UJSXiEUre0tWRWxMlcScawouIfy0//L9dxxbDwSi78iEqT/U/VtPunICVLRCNstymYUOTuy9pTve5DF/Gdx8X374P8rxxGdbYVB8xzpkOgNirqfy1PR3Gx7erEl35O9j7KP3egtulDAJuLLAe3sfuzG8F0+GQgQSdGux2fUcghqHgXZvOeMCpO6EnCuiR8L
 wDcUH2Sn
 qNkcFZicNQH06dHNUIIyrG+thm3SH9Ri0EX6l0FUIlIKCQonw0s57P+2km3LKcW0p78WUMccD6mpQwzJsbKqxG+66fYDEz3HCduiAYsx2kApwHbfxi23/K4YlZ3PVIXXIEmZjPDOuL0WDpTseTaiqcqaDHlp4TZnQ1sOULuZ6bGTlNF/evHCy3xNKvF6oHSgI5hdmHmNpbb2zqS9LH3EtWvGF1IwoAy4LCGyJs2ekMKaDRem9DqW//D7Ie+tyfWzxl8l3NoqzxmQ1yUpSAVpVsg8IcNcf/4DGDpfcKHHeUu0cinG3x8qTOwWHxCuCjUASML47ido2CLOXD7OELQ/rZop8o2xWt/kOpWh37VvyZMy6B3inhVrK9IVU33nwDC1r/tYOmCu3Vk60pP76k3PO6h969elU01I1Ke8TFGvFmZxX+cllFVrPhtplFdTwJN91TmzvWUH+FR6qUI92AwStr8orfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 01:52:43PM +0200, Mike Rapoport wrote:
> Hi Vishal,
> 
> On Mon, Jan 26, 2026 at 04:51:37PM -0800, Vishal Moola (Oracle) wrote:
> > x86/mm/pat should be using ptdescs. One line has already been
> > converted to pagetable_free(), while the allocation sites use
> > get_free_pages(). This causes issues separately allocating ptdescs
> > from struct page.
> > 
> > These patches convert the allocation/free sites to use ptdescs. In
> > the short term, this helps enable Matthew's work to allocate frozen
> > pagetables. And in the long term, this will help us cleanly split
> > ptdesc allocations from struct page.
> > 
> > ------
> > 
> > Based on current mm-new.
> > 
> > Vishal Moola (Oracle) (3):
> >   x86/mm/pat: Convert pte code to use ptdescs
> >   x86/mm/pat: Convert pmd code to use ptdescs
> 
> There are still get_zeroed_page() calls in populate_pgd(). I think they
> also should be converted to pagetable_alloc().

Thanks, I missed those. They should be converted too, so I'll add those
in v2.

> Other than that LGTM.
> 
> >   x86/mm/pat: Convert split_large_page() to use ptdescs
> > 
> >  arch/x86/mm/pat/set_memory.c | 37 +++++++++++++++++++-----------------
> >  1 file changed, 20 insertions(+), 17 deletions(-)
> > 
> > -- 
> > 2.52.0
> > 
> 
> -- 
> Sincerely yours,
> Mike.

