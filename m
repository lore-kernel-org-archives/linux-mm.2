Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BED2CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 15:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A71A76B0006; Tue,  9 Sep 2025 11:13:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A22526B000C; Tue,  9 Sep 2025 11:13:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937E76B0029; Tue,  9 Sep 2025 11:13:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82E086B0006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:13:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 331DEB9CD0
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:13:50 +0000 (UTC)
X-FDA: 83870056620.14.0112788
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 558CDA001F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:13:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b="RheUw/Hj";
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757430828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uf+yTceGU5JGkt+Uo/sIFQ6JanTGXEu2guYeVg+ECaw=;
	b=1LgxYZMDVkjQNR3owsksWDw9Pg/Gsd3eQIc+73fgYY0GDdZOzRyzdsE5VuehHaN2FTLUsM
	c9dZm+q5C2ys8NU2TUf0L6iXFsRjKg6ZH2UWDFn8+YEZ/HqTs+nU3KsU/0SNe9jBDl29/4
	YhjFgcro+/1GfSHBcBCiN7wYwarMxMQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b="RheUw/Hj";
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757430828; a=rsa-sha256;
	cv=none;
	b=0YkybaCfrAccLkVXj6WYd+BF3Zyn84vhbGNVqkqdWG+nrTyYckc/u4XU6XXirzoTUXg+Ub
	4QD451RADfNNNeJnlferoTU+vb7b1K92hJPyPYNcJA9/hxeYvvyYtuE/Z+HgSvtsymXL7i
	vtNNRLDhi8PSR9zn+nnTn30MmMk4R4Y=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7e872c3a0d5so516450385a.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 08:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1757430827; x=1758035627; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uf+yTceGU5JGkt+Uo/sIFQ6JanTGXEu2guYeVg+ECaw=;
        b=RheUw/HjqhGaG2Qr0TFybt/7IXDlSBr6yHIwzbrfwmmqLLs0TEt8/JJ+nZlRNkyFUv
         oa/RyQAv8Hc29jrzDzCFVt2bE4QdSWzCfYP+eoSf8VVng3jvzaGHVuU7Dbz3WNShq+Q2
         hW/0b1VKK9bydc5RqKbWWjZB8lZAo6vJLJhwWGAzkn1o730KMZsQm/x2s0jOeKsckG4q
         xisB/ejHLEHE8OuurVLonWEzE8QCtGIat17nVddl4rUkLstfd9Nk52NxXdpHh2MsZBKF
         LUXZBF0Ukr+TywPJ1SE8LWq3iTPpetfn8ocXbNVOWUiRqOGjMh+ecPRE1AlucseY8rGk
         bWiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757430827; x=1758035627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uf+yTceGU5JGkt+Uo/sIFQ6JanTGXEu2guYeVg+ECaw=;
        b=OXo/89eu4pbxVi0Or2DPsKwBvbHAzPFMMIH7zTcNxTIGIxPvFugu9XLdtYohTQDeYg
         cmqxAcAEMB2kHVT/x7jVxe6njTfGRWYPvSuB1F1pu8GIwnn/9lcinXfbmEFm0BUQ+YGg
         ao8jFZxpPOUkQhLYMSzeOW8pchLkDUC2xLQxim+eRGh79AXb88tNJqXveG2KABgD65+c
         KVezl7apPuyIVS4+M+6F0JNZWkY+hpE1+PY+JkTxHryAXuP9sMGI8MFYEiEequAwzB9F
         Yg6laBezoHHDB8IAmG7qXXhaEGB2sIHz05S5hB1s1z1FsaBNfhA5PdCK8VmMFKBXJGQF
         mXkw==
X-Forwarded-Encrypted: i=1; AJvYcCVaU+cXBOzb5aacO3thyLYmrb9gMqkbfI+OaetqHgBaypFtR4URE2SvIBitX7Xoq3LAWMcXDdyOVw==@kvack.org
X-Gm-Message-State: AOJu0YwJzB2aulbP7URM+TdjSturEUoZLty88pDVbQkMbfu0J0wvFgyI
	/tuD7mLPiACMPaiHdPPhFCVhKI/e2y2W4Qafuie+MGbmKQ5l3yEG6StEGjH/Go0h9KY=
X-Gm-Gg: ASbGncs7pJO4SBbCFXtImGsy0jdExWklglp4y8WEmuGSAGVP0VtzxklPcKa4F9cmzym
	9n5i76Ms5oz36jEcroGXM9u7SSPecj+6fqg5ASJSmdHiRbczG3NXdcbtjx2EnZJ7UqzF9+G4zgk
	2h/iNy/RuhGw5bxjtWTMuKDOBM/SCSU3KScKG8Vei0VTv1MwjTodOn9xdqYbB/HFMcILPnMIRGL
	oW1pf6O2BEWC++ZjqoTEFKvsAAxLrjp3txoJIlviw1ehhpCsI0iB+a8kQudF+qTfCEpik0TPDRv
	YD9ZzvH3qQfMEgziVKcEoa1ygYpu0Ox1FxsYZrPZrCXPzlxzosH94mNMFTyXnVB8hOpkS88oMzI
	jRnr1+43Y7Yv5
X-Google-Smtp-Source: AGHT+IFk1mNsRoXg6pueACyEECW6Z59QmlqnpPcT14EM2tD1B0zWQIgkHrVzU+oQQccJBi9dAKzUgQ==
X-Received: by 2002:a05:620a:c44:b0:803:7023:36b5 with SMTP id af79cd13be357-813c2efc949mr1318765985a.59.1757430827104;
        Tue, 09 Sep 2025 08:13:47 -0700 (PDT)
Received: from localhost ([2620:10d:c091:600::1463])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-81b5f8fff60sm132842285a.60.2025.09.09.08.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 08:13:46 -0700 (PDT)
Date: Tue, 9 Sep 2025 16:13:45 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosryahmed@google.com>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: remove unused zpool layer
Message-ID: <20250909151345.GE1474@cmpxchg.org>
References: <20250829162212.208258-3-hannes@cmpxchg.org>
 <20250829190728.60675-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829190728.60675-1-sj@kernel.org>
X-Rspamd-Queue-Id: 558CDA001F
X-Rspamd-Server: rspam05
X-Stat-Signature: 7fzrcggkj9xznsxnjwxjmgpdor3u6pp6
X-Rspam-User: 
X-HE-Tag: 1757430828-28714
X-HE-Meta: U2FsdGVkX18JZNuz+1+iSp/vrMrtvwkS2W9V+pNHMkB0QO+KK/3KhAL/j6DbolxPfneuzuz8q+TwsYXqwbuWSYl3+woBzIYp/Sfqewt2q4o0WUQ/6DPzdX5xO4eb5cTOYNL0N+tt2r3Vkq8+XDVVsYERUVRRPUphyFbWQwk9hah8+BG3c1oCrI8RpkwXaewl/i55EzOzlSpFgYaWGOLclwhDpn2jm5OswIGtuvS/PbNe4J7+jJLu5gQOlj/pllKa8cMaef30MMYIbPRgtydGu0zRj/KL4GzoXcTnLmH8u9IaCufrdByZDY7XFdKntLnbzucpDkMtCkYMpQvBtIpn7E1gY/LJUvflvA5qN8ApLSwBx8Fi0wEDA1qlyIrebIzDBMl9o0tbBCtDY5gg+grmj/gK6VbOYiZXfOvG4neBWy7L/45odmZrBO/fwgY66W527XB/DIr6cbBOeRByjJga/RTGAKu2S0+XSQasuuoi850w7S/gAR64enYWtOJSc7UN2d+t3eSyHd/ztN+3JZ8f0PGYjRqLn9Pk4fK5/nbiv8WzYoqo44xLaILGmmq4cKbzUnwEsFzjGtDkeURtMLD+DAwfF4MlymlSWWfCl1MCGEKvqxDcTZuayYbftQQaITPoV30mOtxbG1f65eQXrFTzcDZx/U6cw5fmLYq3j9RmCzKdIgFlPklb7zmwIZBdTT8E4BR5TzOTVF49yMt3CQDK77EUe97udtdCX+8FkGG7LGIGGt1j0/Wq5iCgCL7lE+0dV+AnqdgTEInRLt7wE9scif+Dm723HkcRnzmw+nk+0UvWa2qsz31hCJZmh99Sg2v/VCTp9EXOmHhmLeBXyMw5wiJtjk8BCdEUCH7vdMBX9IvkDIV/i5XjyNLfMmLGwdDz3aXIdrnPyQxNzDuTVerRJl3UqlRToU3Z/tdr5tf1L8rB7ESyRn5xhoA6eo9G8M/hCQfAW1FeLJoOsWUhAJm
 yEayi4GV
 /mD13zvrx2m+pZ8Y9527o0MCiZl5ZgZ7o3QE9SEsP1o5ZlOnBjVUhu4HEAlSXEZzlfAeoeca4cr1/z9ga7KaGVtzjG4W6JJUnryznlV36j4fEqb+Mi1DHN1kGfH9x41oVxJsIRvT1PAyKIF3N/LWKjkFWklmtW7RbYxU3bieIIw3vOmG+mVUb0L46pEiENYKgv+NvH9rNuv9enbPCNOgGU6oXujB2TePf6DnfAYQ/yE6nCx9NS2HZhd5iAHZmfiYI/RpnCb2XLmDU374aOHIaYNxpA7tLWRm3uDc7Ohj11VmG+2lJj2UKCbXm8/3eXoK4qZ7iMWMS9MHAM4ZS4Kmo9iKCtzKVs0m2867L3lszL9renjkOtt6Z1nAAiayA/ojPCSPi8Za+kxNHVtHIVUFGIlyKElPitJrz0ZjxkZCK3Jnve5ODgDLPhKVsFWdBLnu+MI3GeYK4mDKLoWJ3NwNudPBINoqWR8NMLmBmRzJG7+MLM+BZNZB/OYdAZWEFEdWpHQiH3Zd+zuh0jP8nKGsUpcQlewfN3aiHqtEOqzv2dIurbws=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 12:07:28PM -0700, SeongJae Park wrote:
> On Fri, 29 Aug 2025 17:15:27 +0100 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > With zswap using zsmalloc directly, there are no more in-tree users of
> > this code. Remove it.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> [...]
> > --- a/Documentation/admin-guide/mm/zswap.rst
> > +++ b/Documentation/admin-guide/mm/zswap.rst
> [...]
> >  When a swap page is passed from swapout to zswap, zswap maintains a mapping
> > -of the swap entry, a combination of the swap type and swap offset, to the zpool
> > -handle that references that compressed swap page.  This mapping is achieved
> > -with a red-black tree per swap type.  The swap offset is the search key for the
> > -tree nodes.
> 
> Nit.  s/red-black tree/xarray/ ?

Yeah, I just kept the changes scoped to the removal of zpool.

But this file indeed needs a general update beyond the changes in this
series. I'll send a separate patch to clean this up.

> Acked-by: SeongJae Park <sj@kernel.org>

Thanks SJ

