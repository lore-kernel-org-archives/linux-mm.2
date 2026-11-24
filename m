Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B37EE606A322
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 00:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KdmBA0IC
Received: by kanga.kvack.org (Postfix)
	id 80E406B05B0; Mon, 23 Nov 2026 19:44:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF7C6B05B1; Mon, 23 Nov 2026 19:44:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 686CC6B05B2; Mon, 23 Nov 2026 19:44:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 271A76B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:44:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 08F3A40A8C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 00:44:06 +0000 (UTC)
X-FDA: 85468165692.23.319979C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2335320008
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 00:44:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KdmBA0IC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795481044;
	b=k1fDr8cCmlKNPTir27Ih80B7EYi+QtjNvVWiiZjiFSaj++kV2Yb9cp4ppobACt9f36VX6S
	HX5Nnn8bTzZMXQWtwbrfH0/SP6KkOVaguGMnTAm70wL/jtcBbnlyUXRCPixnnlHf3mcp+V
	LA/0ZQSu5Qg8Miow6QWxS8ZoeornfYE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795481044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HAUh8nMd0G5wslRGOt6PASY/mQlGkjEiWQn7IMGhj4k=;
	b=B0jpZ2LjYqPUD9bfsJKsMgukdYcaVYgWgaLAqTXclPmhID2lW5ja67LNIa4ez3onjwLER1
	NLgMDkYw/QfBNcyeXGX0VXMnwz4wZ5VUC5yxZ0idZvvhD9Ij/7+r5dDAqDqJm5GMhxMPaP
	6KzMb2QbHSoFA4Vjn87p5YCWLlxUyHg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KdmBA0IC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6404D61F12
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 00:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04401F000D4
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 00:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795481042;
	bh=HAUh8nMd0G5wslRGOt6PASY/mQlGkjEiWQn7IMGhj4k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KdmBA0ICnoK/f0A/LjDkVOSVWPAx7E13t8X9c5kHAbpKXltrHEomPWBZNL8WoPc/Q
	 VIuVrJ+iHtoPVrczRYlpWGTNoucuHkS7tH6uwJAc6OYXkWlaSV7K31Zw9xgpxM/qcQ
	 0JgD624f93rt76bfxzlZj8rIt6K4yIe6hTaijk+HYcc+Jebko0Svl7Vh9bLsGZdBVJ
	 sIYgzVeypgn6xO+29AqY0MebKqvuSBA7zFm7XTZExYux6q9oAzqagNVEwYNxWItbI+
	 YnR69Sw026MnXgMvzvyvj1WXyh0lu8QC9tFIb/2Y2pOHGLmP4/nRuMcdKOCAfRwAcX
	 734tE1kK/OyrA==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-94999a08973so378897685a.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:44:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFCg8DwkEnjrwDciSKibM02JIVA5x4iv7vgb9gYMVzX8mNXKr4ufEJ4UjOHC8m8i31zuIUMtyQJig==@kvack.org
X-Gm-Message-State: APuU4Z+HaBilx7tjpIKhhDo+aBjXWnjextTF1VKAVRQ6h3SH6n8vVQYR
	M1EP7sAQSlp/btbOPC+xPX63Bar2Kg18u4gPHYemh0rgvAgrA+4a6cYT+QYWCI3i3RIuktfuo2n
	Ajs29sMeqwtoMHV46flv6R5PpUz0dZxs=
X-Received: by 2002:a05:620a:4386:b0:949:ba11:9612 with SMTP id
 af79cd13be357-949bab0cc38mr2014300985a.69.1795481042112; Mon, 23 Nov 2026
 16:44:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119134740.514632-1-ridong.chen@linux.dev> <20261119134740.514632-2-ridong.chen@linux.dev>
In-Reply-To: <20261119134740.514632-2-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 24 Nov 2026 08:43:50 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yiSji++3BPgFUWDp0SGJkFj13qjEfkjNZu7ak1JNozSw@mail.gmail.com>
X-Gm-Features: Aa3M54p1CinVf_O_X9hcMTagKaGftCTA6lKIVPQ5asLSHtMpVGNWzowXV7zN3J4
Message-ID: <CAGsJ_4yiSji++3BPgFUWDp0SGJkFj13qjEfkjNZu7ak1JNozSw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/mglru: pass a seq range to lru_gen_add_folio()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>, 
	"open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fb8b1me8ce9bwu5e7fqyoid3idzu5rr1
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2335320008
X-Rspamd-Server: rspam03
X-HE-Tag: 1795481043-393351
X-HE-Meta: U2FsdGVkX1+F0nBzVmz/xg5AqCDpikx5aiWjpPnW8Y+FPWhHeovDq+QdZLBGh4dRJoiP7V9NV2WFvVaEXqTy1lqC2ks+4JqZE2zQPb7l1CFIFkBUuzFkOIfaKadMhD4km3hvTimfV0AH9wenqLHwPbIfGUUjxmR6e30eEvZm/cTkx18Xm9/byBtxHI0oJRTm0qA59Kf7nxMc9GhWgzuObS8V78UrJHdkW5zoVb2iJi5pjDPUAs3XpLKCQT8b1htFRNfI5A+dwP4EhznF9o/A63EnS6v1/hkYU7teD10uqXpPxn9gJb104oP8FTzOtjhuFcDiEiVLJIrXf0K6T5CWwghmBtZwICO/6flHbdBj27cxY8PYAvftWQ99m/pZf5RwyWsxqOkUkSdMeEb9aLLwzOA4WPqGHUhyWmxFAQYrVZqBMS/bAQ8JG6XrSjB1a3fLiMeWrROBuLChcA9XPSaIQp/slnZrUkyjXMIVqkKJ202opawAet6vFSqWsJG+oRO+505vDgipFaMXb7DTYkC5zexGZ9ZCQVjN72SD7ABXpqMjYm6objyaN24OcxkjGtax5aIF2+MWJWtHPX9Fe6uZsFyL7S4CSOdqdYnkrazvhfJP9oqlynveVQII4jvACsWy8YAO5g//RPBI++IVo4Fo5JW91hhIoZHccAOcex2dljHPgjrrJQIhGmBU/rgljjT4CARwlZBCKUhZztf18g3ODyRC/ZjBjPY3UZO9BvU3QrxW6lgfsfUoWpd7RT8q0Y8Qhul8WKY+TGCqoIoGrJ1NawHWVZWhVmD1wpqHbavMiQ41uwLJnV/Euu7VTPukRJo82eraTkbyxJ28dkMdcA0R/w6J9JorNvlYJRRal7AULPrbbPYStua0K+I7r4K8WBxLk5b+BMuOJrmjmymjmsXcj0XHZjT7geTbxSoH8kDZMjpw3qI2OYoK3WjnoyXzyLKHabsS0NUnsolF5CkY6M0
 8TcO94GA
 1ZEErYi0ta6ghZoOsAIKjGpS/i6CEMDAlWKNsd+Ha57/Kdopzu7e3ja9TFeTL4V7JvfL0kAqtEc1C+l/8jpFKKBvFIKSTPffK0kO2mBlDEw3Tpe8/qd8GXNia13cijZ8CUtIEWVOD1NQTU6rugYqkPPsd8gd1eajgeadp6zo6fXDfsjtwbYmT3V6Gon728gCOayeSTVVNMLWowGM0dIc+ShuZUiyQMayWNsR2wuZdlWwySxWAoJwzzbJ1sSk+ya1ym8gE33kVvbUfRHLUrZtT0ykE+UjvOmHQYraw0FC93/ZNvmrqHThboKocIpjHX7CQ+pkp5a2QzG4Itt6759P/RvKxc8Eo5WEvP25wcHuKiZocwFhqZwVKuAhPJr2IDu7P+DbryhTRF8mX1XG82EeycJ9AbFZStE0iEJBlyuhdDvPYoVntkhK85jayagah+rhL+wph6i+N0tgFo9PaCF6nwwZfcuJ912IH9Joj1sLpmaJ0foanuu1EMp+LbIPaeNxES/Mzf7zBae5T9d+zGcEn+mdytLL2Vj8TYZs1nxSmohcq0m6ugUgo0OL7TQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 9:48=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
[...]
> -                       /*
> -                        * Borrow reclaiming=3Dtrue to place inactive fol=
ios in
> -                        * the older gens.
> -                        */
> -                       success =3D lru_gen_add_folio(lruvec, folio, !act=
ive);
> +                       success =3D lru_gen_add_folio(lruvec, folio, -1UL=
, -1UL, !active);


I'm still struggling to understand what the two `-1UL` arguments mean
when used together. Could we use meaningful macros to make the code
easier to read?

For example:

#define MIN_SEQ_UNBOUNDED ULONG_MAX
#define MAX_SEQ_UNBOUNDED ULONG_MAX

Then the call becomes:

lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED,
                  MAX_SEQ_UNBOUNDED, !active);

for other places, they are:

lru_gen_add_folio(lruvec, folio, seq + 1, MAX_SEQ_UNBOUNDED, false);

lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED,
lruvec->lrugen.min_seq[type], false);


>                         VM_WARN_ON_ONCE(!success);
>
>                         if (!--remaining)
> --
> 2.34.1
>

Thanks,
Barry

