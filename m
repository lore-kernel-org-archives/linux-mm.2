Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F47CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 08:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 982BE900115; Thu, 14 Aug 2025 04:41:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A3C900088; Thu, 14 Aug 2025 04:41:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89781900115; Thu, 14 Aug 2025 04:41:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7861E900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:41:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FC261383DA
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:41:00 +0000 (UTC)
X-FDA: 83774717880.26.5281B7F
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5C5EC120014
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:40:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r1ez95Ol;
	spf=pass (imf29.hostedemail.com: domain of 3GKGdaAgKCB0C35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3GKGdaAgKCB0C35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755160858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Il/U4eiIvjz9tsKhNGMfHkx+2RjUv+CVTnBQlCiCA4s=;
	b=u0J/iyg4pFDx3Td7GXH3GrlAbbmx0w4JTo02mMKTdShnQcjy9p/wfWpKW9itduWIwtto9r
	Ne09857lbfroyNcraJkkRSu+Kw//SrkJ6dlLayUTMIXudEgI1yASoZsj1oNRZiK6wM78N1
	I3OM2SzP+UA2S+inDacIIBhrbZZDlyo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r1ez95Ol;
	spf=pass (imf29.hostedemail.com: domain of 3GKGdaAgKCB0C35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3GKGdaAgKCB0C35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755160858; a=rsa-sha256;
	cv=none;
	b=Q0659ujKdT84vTJ+2V3T4ufekzSPKVOx4T0ktF8OKZTrrPq+OBiqtMwuo2gHrS5E0WDGE6
	zd1TUIk2v6DymajKkEQv9yh9Vv/Gp2bjXfn+1XCsBQWwXDqwlE+0pP4DeXPWr4fcnQx42/
	9aHnER+PUUWRQ1R0FsV9p1WOsFhwDGE=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6188b70a993so614022a12.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 01:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755160857; x=1755765657; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Il/U4eiIvjz9tsKhNGMfHkx+2RjUv+CVTnBQlCiCA4s=;
        b=r1ez95Olq6DYnzvMdPXll6EO2OfOuWW/RUv7DlU14LinnkqeD7Qo1v+Lol7dbsD0E1
         +ahl8ON3exGnnZHDuB6E5u01iWaxmCn8gNRFByYcWElzndDXcQOqv3rcHjM1jyAD6gvh
         7eTs197VVvRmH4hSH5e6eZNjtMNLm6pK81qFlPcT2yTfvMQKrhX+j8oKvh1dzb/cmw4C
         eoAB96+/3vtqY7CI7dx9bK2HelHKogiZRKn49aTfzlV0HXzZKRJvrgFCYmTZjrQxkyJf
         PQQXGBtOEX2uZGzNdVdgrDn5UtCpl4KBen2Pbj8JdVe6y9AK69JAdaJc50Nxr+RRpSos
         qcJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755160857; x=1755765657;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Il/U4eiIvjz9tsKhNGMfHkx+2RjUv+CVTnBQlCiCA4s=;
        b=pzAXCsx1aBNqP/Lv+8F7zGwiCBQGbwPsxS7D/bVi3exJwn/SLPv0W853sT2VMrRNk6
         dR2De/b8fmAsJt1hL4FC9UEhOP0M7Q6d88PH0HNuo1BekWeIdVmFFqM4amCwDaKcxdAD
         OjjC9RQ1MPAhfAhM4uUWWKC4KcidNLRkCm6TzHc02nOjc2stljeZgfGdEmrKy7jARTpy
         RCWCLZc2P8SoWOJLgRnkVyd5z0XNzjOo/FNwp2fRqoMtQYUuuKKV9JnKIPm1ETn8dwOs
         rsaL0lW9atKCQp+UPAirZ6UTPxxMzQYyMY7TkhIQ5RXnZu6uJ+bGqRDTZcD92d9SA8W9
         D+5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXh0zUCzrNuE7cRXpXMI3fFS58pYwyggUeeOtVOouZnDF/1mj9t8IYXv55OwrfkLgwJjNWYHLHG3A==@kvack.org
X-Gm-Message-State: AOJu0YyHwOdgjZHCIEVGdqcdHInVLwMW8dZ9O1VksVqA6cr9zb8qKKDb
	PxfIrf7DJWdZc295RoDuuz7xwDz5Zpf2BeLiTh/yZcYnJOwq9734mTICT8+KbcXDnJd6KZ3EQjG
	ucAj63LbwU+FXrA==
X-Google-Smtp-Source: AGHT+IGBO/FVtv5Fz5TwK+7kMge1vcO6cPjAknpyeSrJy+CEUQA6/lPkatqZKsJon7bRCNXwfEJF+OhHwNl96w==
X-Received: from ejcxh21.prod.google.com ([2002:a17:907:d715:b0:af9:8135:75bc])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:1c89:b0:af9:d863:5ce4 with SMTP id a640c23a62f3a-afcbe075846mr174843966b.15.1755160856865;
 Thu, 14 Aug 2025 01:40:56 -0700 (PDT)
Date: Thu, 14 Aug 2025 08:40:55 +0000
In-Reply-To: <20250814071828.12036-1-ye.liu@linux.dev>
Mime-Version: 1.0
References: <20250814071828.12036-1-ye.liu@linux.dev>
X-Mailer: aerc 0.20.1
Message-ID: <DC20LHZMD7MQ.23X87A0C9M3TO@google.com>
Subject: Re: [PATCH] mm/page_alloc: Remove redundant pcp->free_count
 initialization in per_cpu_pages_init()
From: Brendan Jackman <jackmanb@google.com>
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>
Cc: Ye Liu <liuye@kylinos.cn>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5C5EC120014
X-Stat-Signature: 56r43kxn5pmitg54c6nsw6bb5db1bpx9
X-Rspam-User: 
X-HE-Tag: 1755160858-768300
X-HE-Meta: U2FsdGVkX18hNIeF40GD3xkq2x/fg49nWFOUcrl4XzEgN/iu0l1Ck2aZUhHvrHqOFsOQ91/Nu7OAL39UoZevyqDI+ovCXoxwxn0qgDyEtOEtJ91Xm5KF4pjejYfkuyr0UEi0vcbpCoUVxYwyfp7A1zrNlgsnEGs3VGFRQueO0iSyWkss/C7islOb29JtBirTU0fIcbVlgcfYVAjVVaj2AyE9TzoNBvc1n22s4dFAk+DUmDkrdcrx+ZgZPMbKI9VTxNUhzCcHzwTctZcEnGW57jB/jVix09kE61rcKba/6iB8NuFmXvcmpdivUIjbclEgiEo/tFA1Mo1MPT8BIxnkx0B6O/TtBlI5bLNMKUagbdnJxhNtLPDEt7A+0wbDxDiuE9gbFUBDARqVHqYCAhd7LWtCMMtjYhbQm3BPu4UvyVZVgn3ZM6u7tdtZNaTFrL5Yrzkflag2Qf8icQTgT0VH55Lmlel2Ye/GA12orqto8zEL6d3mUhRl5r//KQugo9ImyyfKqm1Qv2Bgl9H8VXGy8CNP5wsP0strzJlDlr/LYdg0VF5OqwEgdBSFcnHhZcjyJ7aiFctuDmEfoFlT+R7We/2O0RKm4u2h73HY3D7yEwC1dK33L59Zd7VahR1MNj3ScAlToqYLLl1QkB2wsCC4Qcc45qyQzpyDBChazpp7hF/6mwqUQA4uvbW3837wpgzv/MXjf1rOloniAN2olX8IiJ7GyOnkAWVqVp+sQQjcMcOUmwkSiALnmG2LNa/UWmPA2fuSwD2rHTmo0J83VA5ieb+5xCACrJAurVPaSZD6SjMfSt/9WXgnU74MgFbymRlVbIiPLCtnCzPdTEffeBhtlnG6P1ccmz14KVbm6gN2N3niVfs7cKehPUFNpw9OsbXiMLzVVvRloEqiQ20cFdQdHo67tCOtkUNuCPOA68alf3re4X7IVwHNoZuy6gHS9vYhQhasO+8t7/7P/EGHeOf
 IgMXn/B7
 CMdYuOMiKO0cRgAYSDI+kx3ATtnhH4hh0goM/lhAVGhxpmmye30XSGIYzxOvs01hD6xiGHkXqwA/CuNxvT5DFN4MO1aqWesSu6Yija9txfiWBifRFuYUKMOv7T4aM4KsYDgGZ7o6RnkLUMTDRN5/nnBTzqcuwGs0EwvEcqhG1lMPI9U+8nl3pZyuE3fr9hjG68fLtbruHCEu27R5CUzvKvlyWP7AWeG6TK0tLxKfVOmuS20/79cYGm2xfHdWMRuuP5QPxP1+SjdROgdHVd4CoJHigV7L334Syfhn+G2k3dGYU3e2UUiSiu682GAffFrYSnWKE6HIqS0W5NBNu2oA4riJhhY8aB8UxETPSeAwoEb0smTkg3ohRHRo+jdYQrtJKJ2MYQASSeuHJB1i5GehEeSHw8BqAHPCZUNaEln1R30qy+Df3UIoMdQN2J0FcEqC6HoNBdrbkBv0MqgUEjfmCRj2mksczEdblbBABIf4v4+7J+eA+sScDuKuIwC0lUPdz3n3a0DfIaprmRY9w1jTlyMsLEn2j+pZZr9ZPU9qmjlieZxxmuxU3QQkgd3BW97UnM3TCVEJXQRGaZU8UcQwBoqEBY5fDq2uV+xCQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 14, 2025 at 7:18 AM UTC, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
>
> In per_cpu_pages_init(), pcp->free_count is explicitly initialized to 0,
> but this is redundant because the entire struct is already zeroed by
> memset(pcp, 0, sizeof(*pcp)).
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

[heroically,]

Reviewed-By: Brendan Jackman <jackmanb@google.com>

