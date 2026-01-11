Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9407D2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 14:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C9FB6B0088; Sun, 11 Jan 2026 09:24:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 177F86B0089; Sun, 11 Jan 2026 09:24:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 059C16B008A; Sun, 11 Jan 2026 09:24:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9DDC6B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 09:24:30 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 628E81AD89B
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 14:24:30 +0000 (UTC)
X-FDA: 84319903500.16.A3A4453
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6F220180008
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 14:24:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HIate9L5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768141468; a=rsa-sha256;
	cv=none;
	b=q5AE3jXed8DigAHn2FRO9NdFTXb2M0iio4/dnsvxJpENRIpKKLH5lqA5XoYi2dfYO7Y9jS
	9MnQmJnS+pRdQosPKOkZgYKWzVJtgwV79sa1CacHyMCdL8EG0XElzeizCVY3G/DAsKsNrS
	G6hOpt9+gjppRv2FBobfK4S1epqFUZ0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HIate9L5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768141468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sybVQVvIUZ2xnQZHDweZkMjQ138E45xUi2gly0/jMW4=;
	b=VQmxsoNGkZI18BGVIwGPEiO7DQqyknKcc+X6RkQtDCkqPmC0FoytI/WaL7oGDnvmPUcFgg
	9wxVPQwbAuNzbuVngv/MffVPNvluO7g5HWXgr48Fw8pbSG/X/PYF6b9kc5vxIIAu/T+3zn
	dwPhf0xGwnen6fhJ5vMYRWj+hrJFGsA=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-64472121ad5so3810431d50.0
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 06:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768141467; x=1768746267; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sybVQVvIUZ2xnQZHDweZkMjQ138E45xUi2gly0/jMW4=;
        b=HIate9L5T6tbmmLRiWQJeIxR+0xMVQ34GVgzM+In1B9Do68oZJLvd8XwseqnqK7a18
         gCNt0uuckkdrSx8VlIO5gsia7pUH2oCskso48Qd42xSIEhwPl531dT9FsefFr4YSwdt9
         MBxKbmE9gyxnF0+ZhgieuxQA+mVc9o5Mvo5+aTtLv4z3h/Ggdd33y+sh5fK6SQP1QgQk
         BmqBUHxV1V/SrHcpWjNGWjlREsY08CMN5+C6qzgK0SrV/5cJ7//CDCpYGObIeJR15Sdw
         5EZE+dEEyU0hBC7AGU6I3XQJUE/V2lmx0F6KpXVJO9cFG9Q5FfvQ4gT3u+SaThB1f/m6
         5UMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768141467; x=1768746267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sybVQVvIUZ2xnQZHDweZkMjQ138E45xUi2gly0/jMW4=;
        b=SkpI0WUx5xxsKI8fEgBUBdICRtcvHeV0bBEnJhSX2Lo6RoSHX2dcE64PjDdX52TfmP
         EyPTE7KbAlVSRoqP6PCcgsfpFuc3jR/7tNQnfCJM5PrRgdRiPxArYVtyIemKPiMFeCvz
         2Tz94OnnhtPcM/AESSRZW4qlQjtUr8UuKJTQRrnjXMlWMgMIrOka2aR2XDe4RlVzDDjd
         woGezcB7NkdyoKc6ll8WzuEPZj7z5q5ig8TOBo3UwRiblV87YiUHB8c8LBPHDRrGX2dY
         KxPplV1gZm32DUOOUHJow1QJ6aoN+/PvSQ1XDM9jd++WnN6MgYoejidEPW9jvto5rGKs
         syWA==
X-Forwarded-Encrypted: i=1; AJvYcCU0tqhmiXAS5q3Y4rUEXNLZbhvCeWow2i4fU51Ar9QJ3UieUK7jyXRpRweQPBdHCkPuLTXb8TjsKw==@kvack.org
X-Gm-Message-State: AOJu0YxBLqS00JNIyr6L2H83gNgdOaXCOfx1a1re8QzOnJTY78KxQ+QE
	1Dg0mL4H3bos+5Tm1OU2VVYm9Z7Aq65S5zNbXf2MlhQDdNsJiK7USaEk
X-Gm-Gg: AY/fxX598wxNhXpRGVL7PsvkE94gM5QA1cRH2NbeqnKG0wXZXezeg+x99j/828crgbX
	EXLC1iuz7T1UMzU1DqKXv1XbLcDPeOhoLTzK1WnUiAL9MHjM7JLZeVQ2Ug7kdz3yryWuk/wbbXc
	ZvBrfDa5FIn536aVMLZodtkK0lBdWJMdD78HXZxZ2KXZuLPy7vr5BPBp+xLJ7HbNTx8ThTCU7sc
	PZR4nrFMelvWvcdDm/TsdcZVv++4i6Hx9CoVMCdW8IjqZ4nThJ5psN3O04a1sPIqsNArrLL9W9n
	0fb74kEe+m/A+itF9aob+IoTqZF7umUclGsOlm8uQErXIKC1rJdNmt0vLdLAVJkDTbg0fNkdNBo
	QMHv62uzm+8xF9y2hkamz9N7NY/V85E6xTgEXhk19ZmAPvdyOQqWzrU/6bn8kkk0xP5QBdOgwJ8
	0ChuRvbIz9bw==
X-Google-Smtp-Source: AGHT+IGuOhyZ7k2UnW/gdq3Y10926SeAcysmT1Uz7hzyT0YXQCinQlOxp5RCgC6oy22dMjXvaxJNWA==
X-Received: by 2002:a05:690e:1209:b0:646:7ad7:c85e with SMTP id 956f58d0204a3-64716ce4a2dmr11797959d50.85.1768141467392;
        Sun, 11 Jan 2026 06:24:27 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:50::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6470d81260asm6932271d50.10.2026.01.11.06.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 06:24:26 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yajun Deng <yajun.deng@linux.dev>
Cc: akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: Avoid duplicate NR_FREE_PAGES updates in move_to_free_list()
Date: Sun, 11 Jan 2026 06:24:21 -0800
Message-ID: <20260111142425.2783953-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <EC18DC0D-45BB-40B4-B34F-0AD7DA09EC99@linux.dev>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xs6h93ff9y4nw5d3azpbiq5q4qu5rw5m
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6F220180008
X-HE-Tag: 1768141468-806046
X-HE-Meta: U2FsdGVkX1+Kks5FSQav6VBoVMohyRXoslRm08ohPpcCaj1nXS06iyLZrosTP8EptPFMIJYkHJAMy8JKWa+hGYPWbVi8BuprRyQmh5Z9lTxXzqzNlHdE07tdGFZDey+ei3xvQtW1/XFumMG7onBxT+LWhVCvTA2fx9czO63kHzF27wZyPfmYJrRzVjNMybdnLiAtpa8dd5/+m7sIEqmsTwUSZnjJv3Gwzj9Ogf16czUg0H+eq9/vz6kvdipBhDN3VUKIArtUOhB32VxBI41bMIbbwr3jQ48N0HggNj4HJcVt6heTQ9gaXydDdMNPDI8LFvNqJIxLjxLH42BOym3VgmMkEug7PdMdPHgy/dwEaut8CddIKLqLiC7qqRzXg+Fj3n/jlgHJd4W4lhd0AHCV8KUM26Qb+aRSq7/vMXqdLtD9WSSfdWCHS7BZWElBxrQcTI8Slr4Tu1UTSqbrU1mhKVePiE9G0OOqoR6g74hacOwzxPoxazzJmb9qUzFQLC5RDhcZswnL/0imQ0JNp0ilGvk5GQdfSxWaCNRLKif4djbktERPfb2AqMAj3N+OlUQk2/H5XhayhHRLQg1mix2hbr1CrPaZX7er/OguZ4CGvXwK3vbo19myT7Iq7GTofXJOnc6eSouV46aM0u7ul5tys4Dkw8wxrRRsOh1VZ/+PQYM8VH90LTiRZi51Ubn/5VagdId5SHOsGyxtdXFWO/09fZDUBEGZrHeyDsP8DYKbxOUW5kcCe3Nvl/xuiny6d0PY360AQZBSYWcJ6iu1/UjcIQEXt1WZ/ZVjm7Hr4Rm+UJWtpCZw2gnMV3Z/XHOIBIyy+H+JpCZvXvuBqQ480MQvo1JjID3l5rNyraWVBhVrSKJphQJB9Mhcj7JZWioaqT36baDhHoehvmnSOkFdJ2JSg8BjLwFf7PnvznWYm2sV71dQaiWIrOur8WPLbIXpMSamjAZ3tjVipM1cJJpsV7U
 nWwMTt9u
 mXlQ8WozBRIgOD5EouLu18cT9EAbqiLOydlsZG0RJIsz+cG7ZWtmq1qxmEGDVn3GYlZ5f7VdJ9V0JliqnHN4qiPsjiOlZLTR7gFsMlILry79f5TsSEZ/GHsc9GRVAqRcPiCogRrNPzcz1bnVQHwTU5RYmmsXYGZb2SGlGfFrZuFaQ2KXjp9e8uEd8TqAdRO4yWFSGypsqMEhxv5syD7B2yMrcxgKc+DiySKtrOlI0ydnbFDgBU+nzlBvSlpyTatiGRYtw2J6rj6Q8dDR3u8/rIPHVjYIK4p92JTrl1L+KXvsJpoqkMtjAI8c40624j9RZADv1XQTkAI0iKgutKxyyG1In1RSBlXJrd9ceuXgBGq+P/acHAZP/QwSIPaapDk6AKCQh4cgTpaqCu7z665m5f7OFmhZ+6jGVCyBvCuMzxXHShggZy1w+di0SwtJAsm4EJpmTKbUlXdiaz6iavJLDaa3xGi5GDRDZcHLwvEEdwKxoY8g/Za7uOaYTypE2VH92YL90tGG3VakHj5WA4z9Dh+MgevjKoK2YZG7XoZngvNHvaaCZUemuV5JoABclkichmJ+jTlTVH6SBGk8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 11 Jan 2026 21:47:42 +0800 Yajun Deng <yajun.deng@linux.dev> wrote:

> 
> 
> > 2026年1月10日 00:31，Joshua Hahn <joshua.hahnjy@gmail.com> 写道：
> > 
> > On Fri,  9 Jan 2026 18:51:21 +0800 Yajun Deng <yajun.deng@linux.dev> wrote:
> > 
> >> In move_to_free_list(), when a page block changes its migration type,
> >> we need to update free page counts for both the old and new types.
> >> Originally, this was done by two calls to account_freepages(), which
> >> updates NR_FREE_PAGES and also type-specific counters. However, this
> >> causes NR_FREE_PAGES to be updated twice, while the net change is zero
> >> in most cases.
> >> 
> >> This patch introduces a new function account_freepages_both() that
> >> updates the statistics for both old and new migration types in one go.
> >> It avoids the double update of NR_FREE_PAGES by computing the net change
> >> only when the isolation status changes.
> >> 
> >> The optimization avoid duplicate NR_FREE_PAGES updates in
> >> move_to_free_list().
> > 
> > Hi Yajun,
> > 
> > I hope you are doing well, thank you for the patch! I was hoping to better
> > understand the motivation behind this patch.
> > 
> > From my perspective, I believe that the current state of the code is
> > not optimal, but it is also not problematic. account_freepages seems like
> > a relatively cheap function (at the core, it's just some atomic operations).
> > Personally I also think that semantically, the code currently makes sense;
> > we are doing the accounting for the old mounttype, then for the new mounttype,
> > in a way that cancels out. And given that there is still some cases where
> > the work doesn't end up canceling out due to one of the mounttypes being
> > MIGRATE_ISOLATE, I think that there is enough purpose in making the two
> > calls to do the accounting twice.
> > 
> > On the other hand I think there is only one place in the codebase that
> > will use account_freepages_both, so it might make the burden to understand
> > the code a bit higher.
> > 
> > What do you think? I don't have a strong stance on whether the performance
> > effects are big here (if this change indeed has a big performance implication,
> > then we should definitely go forth with this!) but I do believe the current
> > code is quite semantically sound and more readable. 
> > 
> Hey Joshua,
> 
> Thank you for sharing your thoughts. 
> 
> I currently don’t have any performance data, I just noticed from looking at the code
> that there may be room for optimization.
> You’re right. The original code is indeed more straightforward. I think we can add some
> comments in the  account_freepages_both to make it easier to understand.

Hi Yajun, I hope you are doing well!

On second thought, I did notice that at the end of move_to_free_list, we have
some additional conditionals that depend on the migratetype of the mounttypes.

What if we open-code the account_freepages_both, and skip doing the
isolation checks twice? Your idea to use the ternary operator gave me this idea!

@@ -869,14 +877,17 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,

        list_move_tail(&page->buddy_list, &area->free_list[new_mt]);

-       account_freepages(zone, -nr_pages, old_mt);
-       account_freepages(zone, nr_pages, new_mt);
-
-       if (order >= pageblock_order &&
-           is_migrate_isolate(old_mt) != is_migrate_isolate(new_mt)) {
-               if (!is_migrate_isolate(old_mt))
-                       nr_pages = -nr_pages;
-               __mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, nr_pages);
+       if (!old_isolated)
+               account_specific_freepages(zone, -nr_pages, old_mt);
+       if !(new_isolated)
+               account_specific_freepages(zone, nr_pages, new_mt);
+
+       if (old_isolated != new_isolated) {
+               nr_pages = old_isolated ? nr_pages : -nr_pages;
+               __mod_zone_page_state(zone, NR_FREE_PAGES, nr_pages);
+               if (order >= pageblock_order)
+                       __mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS,
+                                             nr_pages);
        }
 }
 
I don't think it matters that we reorder the __mod_zone_page_state to be
after the account_specific_freepages here, so hopefully it is OK here.

So we can achieve the best of both worlds by preventing the duplicate adjustment
and also keep the control flow simple! (We can also just include that
additional check inside your account_freepages_both as well).

This is just my small idea : -) Of course, please feel free to ignore it if
you feel that it makes the code more confusing. I think that what is "simple"
is mostly subjective, so this was just my thought.

Thank you for your thoughts, I hope you have a great day!
Joshua

