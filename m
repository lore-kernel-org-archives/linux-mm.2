Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 932D3C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 05:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5996B008A; Fri, 21 Aug 2026 01:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37E5F6B0095; Fri, 21 Aug 2026 01:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BB406B009B; Fri, 21 Aug 2026 01:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0355C6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:00:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A6DE160391
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:00:59 +0000 (UTC)
X-FDA: 85124077038.01.AA7C88F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 85E4C4000C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:00:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A0vI4Yhx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787288457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nHRy2iP+9SLgpqCJ/zjLL+H5ITom1p/PnhbqOOo0/eo=;
	b=uMU6+l3089A+Appk5D+C6ktallme7oEo+UL1m7f2CCC4ywE/BuwA10e0EWnzCRBFS3Zsnd
	e7bEHqDo3V6WwKiW7k4vG40MsWNjtNO+R8YaFuByrgKn0X17o6phh44lyNbyB96rXl4MC/
	Xdc51aJqXq/HE/4nGgnxCsuKhOhv2Tg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A0vI4Yhx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787288457;
	b=CaU4RqrcG3YIz5g+MveGT9pRQUApCH9X67Feu9eFFCqlkqbkk5biKdXDZ6oqZ69yDpGz+e
	h3WCuEbT5MzOFfehSoIjOp6DMfB0y/n7eoQmr6wBuxxbxSdDAdC1rS2ergM0hQjjhn0e9t
	6qJJ138wGOC3pmlbOUziJHMfSjyq+rw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6614C440AC
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F3E1F0155E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787288456;
	bh=nHRy2iP+9SLgpqCJ/zjLL+H5ITom1p/PnhbqOOo0/eo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=A0vI4YhxCJXait7bXbMqLgXISUS7OjbtowYNEN0cVN516Ts9ehMgigm/30pn3WHd+
	 Ht14SFdIufr6ib76q2naTnnDqlh0oX0N4EqEqyNm1EPqn239AGQKkLzYSApQDOs5By
	 0mL2fyofe050NU1cfCue4jWB7ca14z595EcORuIJ7kuD6UokA5Aye+k4w0S/dhL25Z
	 UcoVotXxe1Zd7CPrFRhEdosZN/fO8WjT0cy6b3z07TDAh7RAzG9VNNSEgJEK8ex8Hm
	 LJPWVnMtjxPPUKOBxNnWGF6lcpg026iS2XyoOEQPAlfRkP9UW2504A1ac6bSc98L89
	 BmrO7npgXdkSg==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e7632b193so37086185a.2
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:00:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpjNiy+HfShj0q8Iz0v9nuPsCE284n/Xrxmv4kSHlj5kVRbsKKJTEaBwlXC734vOGmWL8xV+rSUaQ==@kvack.org
X-Gm-Message-State: AOJu0Yx2iuuP83MbqrOFbYRxCf0b0IJicI3Rd++YHLTeuyDHZwPXPkbl
	OlEya+M2/7Tz0DUAGXBh4n5sm+tZP2AFUrPmWdHhsz3ntyZi7qjLzk0MG0GXd5VWrd3h6VYRbme
	lesXnaamldWQjcj3KKRNgL476vkEZepE=
X-Received: by 2002:a05:620a:2092:b0:915:b852:4361 with SMTP id
 af79cd13be357-93739555290mr250944085a.20.1787288455444; Thu, 20 Aug 2026
 22:00:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260818163221.589352-1-alex@ghiti.fr> <20260818163221.589352-3-alex@ghiti.fr>
 <CAGsJ_4zC+wAuevG+i5y23rLPGXn0P=D7JpMECnZ1OuP1BsyYkw@mail.gmail.com> <aocfZSYFRvP7_vEG@casper.infradead.org>
In-Reply-To: <aocfZSYFRvP7_vEG@casper.infradead.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 21 Aug 2026 13:00:42 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yb_5803vALp9YMHXRsTcqkDuXfGFLMcxpNDQXoqnsPWw@mail.gmail.com>
X-Gm-Features: AcwNN1Vr1I9MP1ETL3deT9CVHH3_gOH9X6-A-RjDwJmZICKRamiVldVSaOWVKyw
Message-ID: <CAGsJ_4yb_5803vALp9YMHXRsTcqkDuXfGFLMcxpNDQXoqnsPWw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: swap: drop dropbehind swap cache folios on
 writeback completion
To: Matthew Wilcox <willy@infradead.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kairui Song <ryncsn@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zf4536j7ie15fj66ccy8uo9h6wcanmrs
X-Rspamd-Queue-Id: 85E4C4000C
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787288457-268054
X-HE-Meta: U2FsdGVkX1/5IkodchefwvSub+OUqBwpLas2/wkWEeAirTXC1z5W5v6f2ZmrSTTWX6IKdqWGGy7xjUz+uZcM+bAgp6hZfgv132KmHE+9lDGM7CvSfJ8mdJxjepqzCJ8gwZH0+mYZQFDvsizLZnC2a/ugTxX0MIRg/XT1st7CddbmhRriVU4wuHxop5w19qxiB5+MaTjzIyK9Wo6n06zUGu8VYz9JfCWS61uMYe4gxN4HbGnY5Qhif73sI2q+7FD3jHZGUKKvVCwV9D+PztVcSIw94Effue6+xlwUdhfzQ+uMntgOUoiJGvZ46S7iXUS2R5qBVg+EUcbwwm5vE3oaS/QsQnbt7/9bQeZZBIRSPDWyRG4Kkz8VbnomxrsO33v9pPYgP6GIJPUnl/g3NnWeq5F6BwS45/l6fZuxOuinxv+W0+xTStxWJ/C10Jr8o6wGMwVUmjoBg+TM+cUoE26TOMhf+YOBdiS4VS/pUk8LUVbvf07o6NCh102dnx+qDmccXghzsBhJM8TnLXV3N+JQOLO1rz8p1Pa0tZhrZcX2KfVBlcZwg7SoLEeAVf/itAE0gdN8F0ZE0qj4w4ClS8E4gqW0xwuXrmg9w8GiYUSzEQU69W4EWLitVQCZQChTc4rhUIW59FfWPFCP27rgMLZXgf5T5lueq+wqOyhUHcll0cgDNvC73WIh56neOF6QRgp2LE+jXQ5Fhw1Eybt6XBH+uXEnNTvkYWDphqkurwqs/3CHusD/bQAWMP156qOcTWPmojxIeHVyfFGBUn5uiP2I+uPIA+v02DZMGSyBkZp8jfA7FUO0L6mO+2DcRIC4bG7QjGoXovZbvdHHaQxp3I5sE/Ylh04mu8wEjC7Gc9/VthrtAy3TH+N0/y3NFes4ltpiVg0rlCfkM3N1ZDcqZ2LhU0MfjbZI2Kd8ij9oopnNHllYFMl0YxVsgFaIwEwbPb9FPrN/rWdh9py6YjsnT4E
 pArtvY9d
 Wp89OkljoPvICbQ1ZFbg2Ir+pu6YbecOrUFLlqlCbxd6BllrrDnhWHJdLHfEuKZX4BjbMjFyelcVssDbe3mty+6bYuAr3ithh4CSd2N/aqIvQkf6LD6sfWeHjz6MVv2NUACzHfSIHMH2Yg2yH+xjQIeZ/9DlK/kZhaDS+GKj36u5g+GaVDBa6FpIskbO1OC1H2cV2iQVg3Y8scNAytBOSBREs4OxrsndWximuJYAhEbI96eCWZ6oQ84ATWrkB3dN7PExkbuiGKWE8KI4Bg5DnuxfADgCAXKYZXyVwEq40S4viNRjMR8T8pws38s0PlYaftEMtjkMidivesQveL3qwp8NuxfR+/e0R7X549/9MUcb3gU9fswUnr7a2E9B1/bhiNK5Ox2PEmVWYQ5c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 11:38=E2=80=AFPM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Thu, Aug 20, 2026 at 07:36:42PM +0800, Barry Song wrote:
> > > +void swap_writeback_dropbehind_folio(struct folio *folio)
> > > +{
> > > +       llist_add((struct llist_node *)&folio->lru,
> > > +                 raw_cpu_ptr(&swap_dropbehind_llist));
> > > +       queue_work(swap_dropbehind_wq, &swap_dropbehind_work);
> > > +}
> > > +
> >
> > This is good. For file dropbehind, I see both F2FS [1] and block
> > devices [2] reinventing workqueues in their own filesystems or
> > drivers, while folio_end_dropbehind() simply benefits from its safe,
> > sleepable context. This seems a bit odd.
> >
> > So I'm really curious whether this could be extended to file-backed
> > folios as well, so that those filesystems and device drivers don't
> > have to deal with this themselves.
>
> You should probably both be aware of Tal's series:
>
> https://lore.kernel.org/linux-mm/20260730-blk-dontcache-v7-0-3e8e6850068d=
@columbia.edu/

Yes, thanks. I even asked a question there, but nobody has answered it yet.=
 :-)

https://lore.kernel.org/linux-mm/CAGsJ_4wUvLoKGafR3U-ji1kUUaz6K_QdN6QxMT-ap=
SaO5tXp0A@mail.gmail.com/

>
> In fact, I'd base this series on Tal's.  It would be considerably
> easier.

I assume there are two things which might be helpful?
1.  bio_in_atomic() helper
2.  bio_set_flag(bio, BIO_COMPLETE_IN_TASK);

Then, if this flag is set, we move the bio completion to a workqueue.
Right now,  Alexandre's approach is moving the folio dropbehind to workqueu=
e
but not moving bio completion to workqueue.

+ if (swap_dropbehind) {
+     swap_writeback_dropbehind_folio(folio);
+     return;
+ }

Not sure which approach is better, but moving bio completion to a
workqueue seems to have less coupling with the LRU and related code.

Maybe we can reuse Tal's code, for example, bio_complete_in_task()?

