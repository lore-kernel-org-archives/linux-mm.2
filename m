Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8B01606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AA1vinJI
Received: by kanga.kvack.org (Postfix)
	id 05D8C6B05B2; Tue, 10 Nov 2026 08:58:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0351B6B05B5; Tue, 10 Nov 2026 08:58:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67CA6B05B6; Tue, 10 Nov 2026 08:58:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BAD1C6B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:58:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0339A0925
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:58:31 +0000 (UTC)
X-FDA: 85419364422.29.547857F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id C9F1820009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:58:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AA1vinJI;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794319109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=orVp3ApNNefs+rNNkVjfyAq6zPjWdcnnxM9afsnR6Aw=;
	b=OlFMkQh2XpiYcHH9wyKFxHq+P+Ybsjq93UWbrsBXyzQS0BoyYJ/dCe4/bZZyzDfVS8QMOS
	z2KQq+gSPZeYLFWiUrJsRs7EX19bDPgxNlY+XlBlXjT5MTCaQ9hQP4Jy1xle4F/aZZpXuN
	4waHm4cEVtvMS5pLkovYpr+8bAZ0G+U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794319109;
	b=c8hnbiOWoujBE2Fxb3A/8InoNWnAEe3hGOLUZ3lI+cmI6LNBZE+ZQC+XOMm7NTYg4ovahS
	MTLrmrOH/VmZnjG02tB34VO3Sx9u5iMZ1HKOJn24Psho2iAtJh6+DZdscTtUdRDXYz6esY
	DUPQ/Lt2Ti1A2j+F/p3VroRgb7Jjkrg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AA1vinJI;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 62A0763966;
	Tue, 10 Nov 2026 13:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A381F00901;
	Tue, 10 Nov 2026 13:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794319109;
	bh=orVp3ApNNefs+rNNkVjfyAq6zPjWdcnnxM9afsnR6Aw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AA1vinJIhvA/xD1ksnQDVsNbJR0/awVLE6PgYIUd8vQ7vR/oalJ2OIH+fmabHu72b
	 OiTMjEKVxBWJvoU3jNTOFlETxe+OGUA2+aTEQITv2VR7ewDjOxFKCaKAwL0ucuKKkC
	 08PdPzlGPM5YWQbojOAccf/WXkzKqhuxJ5k0BZ++oEUpSOdS+C+SoMzHotjwrdn/4J
	 0dwpLnzAWICuZ4z6FXnOxvEENn1NuBHn2FBX0g8WVqjVpS+KHphJFX5ohApspeSju4
	 7cvgEemo9Sa2SjmzeA/Ed6RmmPgzIukLLLKbUJIFvoIltXDXxmMeeiVxxmg/C1AnTz
	 ZpKglsvUfFQHg==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.ams.internal (Postfix) with ESMTP id ACD30198004A;
	Tue, 10 Nov 2026 08:58:16 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Tue, 10 Nov 2026 08:58:23 -0500
X-ME-Sender: <xms:-CLzagBeJARgeMLf_AG1ZJxLWV7pXJvKtEujKAeHF-qU0ZgZahvXDQ>
    <xme:-CLzasUmXYyQI_4Kzu2urBoZSwhgaeUxAuYaxeZeMTPEPzj40JN7OENU70Yv1QZ9E
    8eVRBGU7vognCqG-HCvaxvKp1snVIVpumK5-aRpazwewn8rv2HvP7Qj>
X-ME-Received: <xmr:-CLzanS21aqSr3PrUHjqcZmw9HJRdMvrLz4f2ydWzqiPf8k28qSVd-UB7KU>
X-ME-Proxy-Cause: dmFkZTFIrSr6WV+Dg7Z+NBxEpMfqoBwddCoGa3uKS9U+WaQ7VCSq3x3/qhdKUI4sicrwe5
    XsU3w+Onhv/HvxlEPQ6YXBYZGU/VhK6rUbihfync9gvp/4ShlTVe0p1/zW8qoCPx3SKgGD
    GO7S+eklzUpLBJRzZgMK34ExeR4OFEJyH2Lkiu8SUiXGft0HwZTGZqyjjpAOwIry/UgW/2
    X2vosI4M9da4dCEEWVXBJisH+CEcZ6UbkZ6D6YgwHV11U1sou1O4FLAgEGApThR6gYJeq+
    Q0RFnb+VFAKg4YMYrUPBpHEjPv+s3c4+bUEHZ3TGaeNYtoabjfi6jx6GFodIz3c+75K3lE
    qb1lJ9VNKgt7KG2ZKMcaRendvZQArzUkKJwKZCR4BLncfR3dL80bH4DLJ92/qSIR78Wwm4
    81Eerg8K/GV30+Iwpf3SgqqkzY21VRAqvxZOa+Q3mLfpfV8am3whC4LiHxE9LZVUGhO/21
    sXQvl5MzPGXZByiEkjADH9y2y/qD/16/IsNVqlfmn0uNJYXFdDONwmbGY4xKumRGqAsXLO
    qC9OAoAqPTQsWg2oRkklIsJtBmWyJ8bGO418N9R9e4aDkTSGyh2lXYNmYckvFaVtdEhGgS
    BlE93cQTmCq+9u0F0PrUzsjQmARFZPyvxRqzL3gWYEiJsFfCIEb1mBbqw3Mg
X-ME-Proxy: <xmx:-CLzahvzYDYfEADC-hvobgDBBptNxmlVWngJHh_7jWtk03nRkGUF5w>
    <xmx:-CLzahOUnXioD5TC7srSG1JGTFybjRskA9JMVZlQgHkqrwLx2yrJ-Q>
    <xmx:-CLzasR3drxSIli0gLY1vjsUTqHZnEirlNgoen0lRMtjEsO-AxnXXw>
    <xmx:-CLzama6nXk8Sqakzv-yXPCIdkodjMzoRRZNqQfvLzq2NMHrC3EPjw>
    <xmx:-CLzaq0r-Kg2fOCTwo5Xh0Dzxhtg0iMd4lJqiwyRQcdljsiHnTAUtDnM>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Nov 2026 08:58:14 -0500 (EST)
Date: Tue, 10 Nov 2026 13:58:13 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, 
	Hugh Dickins <hughd@google.com>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Harry Yoo <harry@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	Luis Chamberlain <mcgrof@kernel.org>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, kernel-team@meta.com
Subject: Re: [RFC PATCH v2 03/18] fuse: don't move a folio with PG_rcu_free
 into a fuse file
Message-ID: <avMi1E8a7uepqMW9@thinkstation>
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-4-kas@kernel.org>
 <f21433af-afc6-4a8f-8d2d-3a377cd3bd6e@kernel.org>
 <CAHk-=whn=xc9J3qApHWRGTaBpwVRtGbvJ0LURGF=dqC9B3swUw@mail.gmail.com>
 <CAHk-=whhp=Q8qR+wPoM9+mxYPQ_OXMOEoKmT7J0JZikFZusuqw@mail.gmail.com>
 <befbf3e1-d25d-42fc-86df-e4b695b017a2@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <befbf3e1-d25d-42fc-86df-e4b695b017a2@kernel.org>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: tfqktt39riwh7dknhg3wknbat7xhsboi
X-Rspamd-Queue-Id: C9F1820009
X-Rspam-User: 
X-HE-Tag: 1794319109-633418
X-HE-Meta: U2FsdGVkX18ECWjOMz0lNN4EF4JJkfDOuUW/7IBwDrAbcrhOeGONgSkWiLL0qAe8reQa2Ps7H/hLVOyzQ9/dGLech9n9Vu7x5BKNvmCFVUrIejbHSmis5RbkjugAghbwjXOxWqyNFWwuh0r7PRqCPKFLLnmMX4PnOrgEoqi8ejwtv5PX4Kae9xdRmNANSqfI+NUC9o/0Bo/uiPTKc0lixXtl5T+heebEsfXznaYhH1TI9c8l/LglZ7RianNxC7KL5SALritPyBs1wbjhtC/tmm1NVYskeilJ2CZuTlEW0aIywzK6aAX5NPf51tFwG/crUsiIse7gxwpA+XkpgqzMRyW8eVONEWvJ0AnangqXj8rhv/WozGqbeUiJyh/iNJIC4FCh0uhnK9pXBrIwLKjjOd0tOZXTfGaQNDCqrFLsv3TOt5+eGBFFV5okahzc8MRWmYcWOR53WgBqPV3oLkhZjFQWjbjYMntcb+GpgnYaLbGPI7F3wKmuZodpRo71fQmqt0EuAHh2a4v60WAq7/JacAdSuCjGITpiH5unFNBvz8Cup3Sxsx3cbtCsmW2ZiABerZormp48LjV5JmOknI/KftGNzApE+9b6hicyfDmdRFuzxq8g8k95Y91tT5i9H9UuJssikiZX8LG9YguOTNegmg2NwRcaH+8s3PrWWKngxJfbqI89QcBcdDz4Slej5Pc3WaEfsBmEuWWJscUw6DH7SX2JSyDwd5OvDqHXq6qbynGLxMT0k+PDWMWLA0yzv6vauos0zj3esJugs/LxfQkwva2ZCyUcI1QCahbGnjIN4uZ0HhwwN2NTfQA5rExUj5Bb8+71EnS+CT1FmuGDS1hn+4tJAPuO6bBfOgaOuqOQCfaZ10W8/EZrHd/AlHiqmDVI/YKM2fTU8xu87woeqXGTIMfOIrhtiqPwPmBk+yuEegLGUNpfiWRqYCRPWgfvY1GBB2LB5PPFpNtYIr7V8AV
 dfX0FHP8
 v4ENoqBdQU66qsSZ1+0UCM14bm6SxVFZx253svpqIA/+g8NDUVqwA5flVdHVArVxlEaL/Nv3f/8EtI9haQ8zYnC4n+LEJaqBqQ40FnbQD0SOv9KDuqfLqt02XRyKUiZEwcT5JLLZgeZNrcuG5DTiuMVGlQaL3U3ICtfwKgQnNr5Gyu8TsxrrcR2ObOfOalxNRM6Ul3/8lyoZtP7shVn3spO9fYHLqHYyxEVkxFe1HFfoDCZ1nCIrIvSS/SeYaA0wQD1+WQ0lIP1qlW6A22v+O9JYfNZMX8QJ7Ap5YFVJjBLdAeMRhyjAdXnHOrPpV21FM4p6or40O4ZVR2/SjaJfweNhuvoxZZpzon7AQAnFMLwp2Y2L/a7bkDwBxuyUZG6C4RpsPPuHxqTwUGhvXRQDmPik8EWFleZE5OZqvOFOVJ8eDW2dfu6IGG/MFdb21WFfa2/czSzEKr9GkJd9MTGKPjgWzdI1pECChvVGL5LT9E2O4njw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 06:48:39PM +0100, David Hildenbrand (Arm) wrote:
> On 11/9/26 17:35, Linus Torvalds wrote:
> > On Mon, 9 Nov 2026 at 08:28, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >>
> >> On Mon, 9 Nov 2026 at 06:46, David Hildenbrand (Arm) <david@kernel.org> wrote:
> >>>
> >>> Could we get rid of fuse_try_move_folio() entirely?
> >>
> >> Please. That would be great.
> > 
> > .. and in a similar vein, we should get rid of splice doing the same entirely.
> > 
> > Kirly's patch to just remove page_cache_pipe_buf_try_steal() entirely
> > (ok, it was originally mine, but Kiryl took ownership of that series:
> > "Tag, you're it") is worth doing, but I think worth doubling down on.
> > I think we sh ould just get rid of 'try_steal' entirely. I don't think
> > anybody really uses it. I think it exists in fuse and in the virtio
> > console, and neither is worth it.
> > 
> > Removing pipe_buf_try_steal() would basically remove all of
> > fuse_try_move_folio().
> > 
> > Conversely, removing fuse_try_move_folio() would make
> > pipe_buf_try_steal() even less useful than it is now.
> > 
> > Just remove them both. Good riddance.
> 
> Yes, that would be very nice.

Agreed.  I will post a separate series that removes ->try_steal and its
users (fuse_try_move_folio(), virtio_console's pipe_to_sg()), with
SPLICE_F_MOVE, SPLICE_F_GIFT and FUSE_SPLICE_MOVE left as no-ops, and
drop patches 2-3 from this series on top of it.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

