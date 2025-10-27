Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B217DCCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 15:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C8F480065; Mon, 27 Oct 2025 11:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A08E8000A; Mon, 27 Oct 2025 11:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DDD680065; Mon, 27 Oct 2025 11:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F24C68000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:51:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8AC68129ADF
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:51:16 +0000 (UTC)
X-FDA: 84044333352.25.622C8A0
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5295BA000D
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:51:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=V3yB0G+S;
	spf=pass (imf25.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.44 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761580274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fz5OAU8C9T/9dkzlT3ECgLDp03ETYSkJWqABI4th3fM=;
	b=cKKzNhoOusC91z+TBiLDLzeV3+rPfEutyMWisr2xbnIEO1ph31fPz+2hsZvnKf6Cw8sNe3
	pMsUb3nxV2SN+i1NJC36o6BSLQ4Rw12AYtuTcsDgYLgJSeUCAKxBH8at1q0Vg5EMhZeA3i
	jLKwQY7McxplBFfErGpA+rDuZOHsFiM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=V3yB0G+S;
	spf=pass (imf25.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.44 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761580274; a=rsa-sha256;
	cv=none;
	b=YQk0/iMBCBKco+MWd8FSn8yxp7e5qFxmEs2C8pT5MXlQH71yMZuH8G5SsAErslQYwYK6VG
	vRcZWrrHA9KpkjOAgPLFeIE0PG4vlKRtn2Txunn4Nj2wvV7W3o5daYWrqdNvA9VWd0Lo6+
	V4pKaMdSCBwf0UA69WI8uPy4c7cyguc=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b6d70df0851so671498766b.1
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1761580272; x=1762185072; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Fz5OAU8C9T/9dkzlT3ECgLDp03ETYSkJWqABI4th3fM=;
        b=V3yB0G+SYnNQM9t+UoRmXi0xOHioCv1k5FOM/4D2o31N+f6iQNXjfp3D2CFBuW2HhF
         FW3TOCSPWnFLNjY3SlKXTC1SpYzj3KSj1r9BLVVOc8y1QaJcMk+9dj5YtGHyilQK3exd
         Uxtin8GMJW1Rnuw9lQ8yndEzw7LMH31aD38Ks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761580272; x=1762185072;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fz5OAU8C9T/9dkzlT3ECgLDp03ETYSkJWqABI4th3fM=;
        b=AMaHJ6c/rPSInbh+bI1udyhYB4E/MPp3XpF5gcYYj9Jw6gbe3BpvYulk7CH60Cimb3
         WN+nrf+3LE04RJ5JNQvvvslWIP2wCgPrJ8wUgt1q2Ez1FOt+G/vMlTNXv7L+ntT57GMF
         OKbSooKHnx4KSD3UGZ6BDGczscZeYWl8CzgepYiHFW1OVyn3c3SqsB6cZ7pQ7s7EePRm
         ppsyI0bHvlku6ivIq5J086i+xfXB3aJe5gagALhkuTftoDVs6+MW+kPjaQCHbmkSHujF
         4qBhC9DakfGr2WQhg+HPdzW7X1dEi7IBNQIulNtf9o9/1YXhmVsWnBTy6J7HtZl5C03N
         Ru8w==
X-Forwarded-Encrypted: i=1; AJvYcCUNQZJR00C+Zskz1pUY61fKpmuTMe22TCjKmcx1IecvdVZXQbV0A5hHpGUz4YOVnYehaELmLMoV5w==@kvack.org
X-Gm-Message-State: AOJu0YxSzjpfIH+D89TcD7dqsdo87Og6L7mEXxG1x6jblBIOvBhtjoeS
	b/NhNcKItRUmlUSXmiyDjrPbw3Z9RYbfNJYP3xpjRsuvRfwaMrW1PgIi9/vaRQ/nQGNs4sh63KC
	g7EY9Imw=
X-Gm-Gg: ASbGnct62OYfoskwBRB7Q7mWNo+VDJUoRB6kQ0yhdb2ycHgr8+jXU/nKn+ecK50kfA8
	yXn8JUM7WdQDyMkzLgX5cpF1y54Ye/IWvz/gPdcdXFHtdpAHgKBinGSKAidQiA58QI5MxffZdbe
	cR4rTo56t1ZBX1CDz+lNyQ/qAg96zVOSw+psTYCg55n/KO6K5JAKzzxaIiUF1sApzTTeNFVfvw2
	fjxS6mtioWFjWqi7jFHnyUZvs2JEDB8bXy9B7pd/E7W706Hxa2qrOTuvJOm78Wx5Ta+6BYluUJX
	gQtxMDSrY1jKPUYyU5FS+8q52KyKQR01NlGFum6QqNJ2XcxEl9W2P3ixWclN+ROlFgOfoG8zKld
	73VyKoHidHgpT3WE87Zy/RaSXYfumgHw+xIGxkAWAZYte0zydUwINYmg0wqmEyXDXcsvd5I0eRU
	5Gkiixxm+oDZFHQ3LnLEGwcmrIEzXHDfrkUhukIhgKuTAYOgETKGq+P4qwolmb
X-Google-Smtp-Source: AGHT+IEFM/W4OqyaJ+x9+zpNREk6QiKZPR4znbkrlUE7cMRC50usFV6SqAXdjMPdrV1fc8P7op+nLQ==
X-Received: by 2002:a17:906:c112:b0:b3e:580a:1842 with SMTP id a640c23a62f3a-b6dba58c635mr42632166b.48.1761580272287;
        Mon, 27 Oct 2025 08:51:12 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63e7ef82f2esm6656124a12.14.2025.10.27.08.51.10
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 08:51:10 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-63e18829aa7so6642730a12.3
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:51:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX0r+2D0z5TG8yWqfnMXgSRDwYs0k22jXOjHxNRkgAmnuwFoXvJXzqCwM7V8YOMbKIZECQYmf5SSA==@kvack.org
X-Received: by 2002:a05:6402:5208:b0:63c:45da:2878 with SMTP id
 4fb4d7f45d1cf-63ed8262ceemr407724a12.25.1761580269751; Mon, 27 Oct 2025
 08:51:09 -0700 (PDT)
MIME-Version: 1.0
References: <20251017141536.577466-1-kirill@shutemov.name> <dcdfb58c-5ba7-4015-9446-09d98449f022@redhat.com>
 <hb54gc3iezwzpe2j6ssgqtwcnba4pnnffzlh3eb46preujhnoa@272dqbjakaiy>
 <CAHbLzkpx7iv40Tt+CDpbSsOupkGXKcix0wfiF6cVGrLFe0dvRQ@mail.gmail.com> <b8e56515-3903-068c-e4bd-fc0ca5c30d94@google.com>
In-Reply-To: <b8e56515-3903-068c-e4bd-fc0ca5c30d94@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Oct 2025 08:50:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiWmTpQwz5FZ_=At_Tw+Nm_5Fcy-9is_jXCMo9T0mshZQ@mail.gmail.com>
X-Gm-Features: AWmQ_bmga7yjIxTmcYa49QdMzCJ_rjqDZmpAlOCSXqWKYw9598-EirU5Tn5Et44
Message-ID: <CAHk-=wiWmTpQwz5FZ_=At_Tw+Nm_5Fcy-9is_jXCMo9T0mshZQ@mail.gmail.com>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
To: Hugh Dickins <hughd@google.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, David Hildenbrand <david@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Yang Shi <shy828301@gmail.com>, Dave Chinner <david@fromorbit.com>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5295BA000D
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6apq8xgt4tkma11i88n1g4s3m6s8idtd
X-HE-Tag: 1761580274-719475
X-HE-Meta: U2FsdGVkX1+awrKPNorTbriqCIYWrwp4w68rJjGgpa2yrCil1ckE05MevAAjmwYRS6YL9QsA1iiJ+yZ8o566B2VIgEl9DWxBHKJPasLnXxwFM4sDGB5tbxA3JC5VCQiXRDMCEyaypgVIcYa0ooBBWScqH9ZYDys/85tjH0fLCifI+Cbk1Y3HykKoYhmhURYoEu3oejALHE9EDxkOp81fVUqcajd/ME00rfhnCxq6OYLriUhh3eDtqIdvxP0sIVl0BoTzKrjomH84bRVR5fDLaNm6J6X+cEc/4UuaprtqtN8elOZngNXxBQflzfhLN1kSE2SENUTy5/5FYGchrgPChA//43i87pzi7DYdbb7QQ1ab0D+RLDvyl1p+F4HmTCYUqH+Tkb/zSRuD/Yt7qBwV7nVpyheCsuvvoea4SHpU66jc4eUpeV8JZ1z0bMYz2B1XkASyic4I9/07e1B7oh0W0Z9zdfEbefgbhZ1aAMPq6GHexEMApdg0evPBi+f1VOjAt9O8kWW5XzhmVH1IXnd0lNvtNPTUYxluLYzNReMjThFBqvMwIgptlyLrN4xm+6VJJV4RoVS6YJKd/+OLo7VBARFTN9xMiROvEIRPb6b7pyeHeghuoc1tGMZjxl43CN56DZy94/fntwrz/32i337h+NvUKbons28tGVwENLIiF5J1+i12pR7QrUu//B36CndFBF40xzQfmGOTivaj8jKSnZ8qfic2QmRvYe9wDUWverXnoYfrSVaJxwV7w9ynSnSWES8gFRv9eQszJJu2V6q0hREgCyVQvzCNTt+hpM3gshY3POqlU6wmfJh56NwE/4IezJXMzA+60TrJjG1yndUA9suhdZ/KJQW4XnmrAMh6I3PGQR65cH8dAcz2XY7LbfwL7JYW7xL7U9YtMcjAU3gGTu+4QUO4TolEAGSB7788H6un9H5N+krY7wTUQrVAX5kXfIMbOwwANKfFdTdHbI1
 gZmpXbDQ
 eD1Zqn0hQMaNiZpP9cMxgal5ZaCa++QtlBXupi2kvBjlHeeFyooKnpirHTrWds1PieKVHLkMhc227/0DoLOPICmDQa61Vu0n4PZ8KqkpSo91G8j2w3Lb5a72QkT2YUE1fhsUuAUwMtROkYhfbi6r3dR7KNATT1UdGn8RlybhmZHepJCg1i2kkyNUbpM4CF2K6G8WCjeZz8huOvYk9tvbAS/TXngh7pdv/3QLayBmJxkTXvBAE3A4xS0JmzEDe3vPqVU7ItJtPkPMm42Vmt9OjCgubaXxqIRmdeteFF1kVHkxH+vZTVU97jIa2y4/WMElE/smvoGLQl/mlABkXrkr7sjjvtOFZzP+ZmAhVNh0+I+fDIbh0ZDObM5Uw4RkY75UCYt3bAkh89XxF4u4CgLEQFModp1o3+FD0+bovFGPTYMz5U1L/rUknOH76yLdIW70G2PoWPXEuboN8Dn+xmNKnETi7Vwkja2qn5/C+J3v1SKqX3t2Q+nAqgRyLGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Oct 2025 at 03:49, Hugh Dickins <hughd@google.com> wrote:
>
> This makes a fundamental change to speculative page cache assumptions.

Yes, but I'm a bit surprised by people who find that scary.

The page cache does *much* more scary things elsewhere, particularly
the whole folio_try_get() dance (in filemap_get_entry() and other
places).

I suspect you ignore that just because it's been that way forever, so
you're comfortable with it.

I'd argue that that is much *much* more subtle because it means that
somebody may be incrementing the page count of a page that has already
been re-allocated by somebody else.

Talk about cognitive load: that code makes you think that "hey, the
tryget means that if it has been released, we don't get a ref to it",
because that's how many of our *other* speculative RCU accesses do in
fact work.

But that's not how the page cache works, exactly because freeing isn't
actually RCU-delayed.

So while the code visually follows the exact same pattern as some
other "look up speculatively under RCU, skip if it's not there any
more", it actually does exactly the same thing as the "copy data under
RCU, then check later if it was ok". Except it does "increment
refcount under RCU, then check later if it was actually valid".

That said, I wonder if we might not consider making page cache freeing
be RCU-delayed. This has come up before (exactly *because* of that
"folio_try_get()").

Because while I am pretty sure that filemap_get_entry() is fine (and a
number of other core users), I'm not convinced that some of the other
users of folio_try_get() are necessarily aware of just how subtle that
thing is.

Anyway, I'm certainly not going to push that patch very hard.

But I do think that a "3x performance improvement on a case that is
known to be an issue for at least one real-world customer"  shouldn't
be called "a niche case". I've seen *way* more niche than that.

(I do think RCU-freeing folios would potentially be an interesting
thing to look into, but I don't think the patch under discussion is
necessarily the reason to do so).

               Linus

