Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42FBBC5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 15:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AE8D6B008A; Mon, 10 Aug 2026 11:57:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485F46B0092; Mon, 10 Aug 2026 11:57:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 377D56B0093; Mon, 10 Aug 2026 11:57:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 110076B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:57:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E81B1C04B5
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:57:18 +0000 (UTC)
X-FDA: 85085814156.21.9001907
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id F1C67A000B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:57:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FZ8xWMdp;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786377436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LXP69DgZsBhPLIDftgBYQMeZY65q4fXqNb+N+1nniuA=;
	b=cHIi/Amc0bTrTY5glwt8fyr80cEh86WqFhPdppOrFowvBpa0lJH8DWgUIO+9NBb27slskc
	dqtQPfVm1LQ5M22WXyUNp4kULP1kWKNYtCB27QPc4jHGm3gNm6+P7DET3CHUd6hBgbhnD+
	KQhAIzLDPLYXIenKg5RODudLwPztLxg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FZ8xWMdp;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786377436;
	b=PheovjmfGRVYAK03ovyyJVz8mNYou6DNpJg/qk+N/b23veVCyXRtFEW3lD0T6iXAnsrTsU
	dXg6tCEXwZ0Ka13/8GgVwMknEGACs6a9uGcS0rsGgIrREwvakfNyTTZoG3EmXRJJGnpseq
	4Oo3SfX3YUxnXspLvdjvZfUlvxWHNn4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LXP69DgZsBhPLIDftgBYQMeZY65q4fXqNb+N+1nniuA=; b=FZ8xWMdp8ay2XNYrinFegvJE4B
	mRA+1r5KSjA+yG3tqXk7F+4VCtM4WgpQ6eZXtUHu9lQE/G8qaORaR6YzicwWZATwg2NzXWJX9j69P
	f0dTtw8rUGD05B1HSGc3kYU0FXFGRU3VWfSikCjlAEzjH89oQUOSC95t7MUYH35dl2FnEeBTgJCKD
	Bz3mcuzhfaSKD6T7kZV+z0F/1esPpT96zhd5M6PI94P2el1nHwx7KMH+GWGcuvoKhIiUgPKD1iFsd
	BVe10LgdX8aRDD2V6ZmBDw7Oy/YVGnMYBd/yQusW6hXXZ/KrKDuF9pD6ocvjOnnQpbUiQOLuxH9n4
	npFkD+bg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtSMk-0000000EiDr-2A2D;
	Mon, 10 Aug 2026 15:56:42 +0000
Date: Mon, 10 Aug 2026 16:56:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org,
	dave.hansen@linux.intel.com, Liam.Howlett@oracle.com,
	david@kernel.org, shakeel.butt@linux.dev, vbabka@kernel.org,
	jannh@google.com, aliceryhl@google.com, arve@android.com,
	cmllamas@google.com, christian@brauner.io, tkjos@android.com,
	dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v4 1/5] mm: Make per-VMA locks available universally
Message-ID: <ann0urrWGUqQsHyq@casper.infradead.org>
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-2-surenb@google.com>
 <anmTYW8X6c9TgaO0@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anmTYW8X6c9TgaO0@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F1C67A000B
X-Stat-Signature: 8hdtn9635xaqhdfk47z3tay7cd39miut
X-HE-Tag: 1786377432-24692
X-HE-Meta: U2FsdGVkX1/tuR9DQAK30uYkjFTZWGRh+clT4krWedHw2eK3uYnN+4IMwEhYYX48LEMAQAn0fc9p9nS+ihpTbdmfdfp2IATeJ5VF9vXXViLs9ot9JPu/tyLMNl8UBd9WHbXUPwE15e+FZD1g/3PCd1hVy3J7J6hlFZfomBfivFcaixFLDurLlXVeUkIPjgyqISmBnoyxv/sBN12GTnT9kKMOEKL82jnz6qBjNh16dkT7QW+NZaLIejbrJUqIm4iE4zH0FclRj+Ia4i0VAem3vrUehOvpeNY9QxXSFZoKDH8UWkkJVQE7Jv/4bsr/JKqrzuUsLDnhLg3PvTNJyQhHH1PjT09lUtHXF3yYDLaGBfzLJJXkzL/Jhe9wuluXUtXS0pH9MdJM34xZkN64BLRp7xfG6ppUw1xlDQ/zREqHyn6YyuD1IyoiXK/+0qlzSvah4mfMYEIeAXZofil5w5WLIrvvCOupd72/lWdHsYSzrxkgk8/XdiWVKhsghaCU4nN8WYo/oS2VDk4ry9h5HiqEul8+Dx1FZyHjq6rT3riAJV7O4JOrS7sj0eICfMnZzzxax3UPPeadNe2j/2AE8/nU7Q0T/JFEkJj0nIHfBzu1oM36b8vv69gasDcg0bR8o5L8UgWUxoNytWFigp8PAD51OEkF19JH7Jq5cMGoLqmsHRAZ7L9D9k6dt9BLW8kjtl7WbNfc6m1kU2CFOwRpEI/Kutxgl4lpW4bCDHH2yptct0II6kKdvNJoM19zchPeyEY13wUGmM/PwmlnW/4q7U9GbfCE6gH6B2aKYs3ZCn5W/p4ysWubKsh5ukruqvkQnSOtIbY2Hi6y1w6WOMKZTesfd8T8avyYiora1m7bL9YGhkF81pYA0fCLsMFlItZtJ3rAfPlJotdqlPJfroZ+EhMRNnezJFg9zuJszOEE4hXDhoEnln+KSSoN8kAEDAYcHdQ1J3gJJxsNvy9bS4uauIX
 gOz7DfJ7
 DtMS1K1kkaIUSU3KV2ZFESCJHWMkPScvGh1IIi7Jb9D8zbfMv+WKOSE+jk0hdAeOs1JF7ot7EK0ArDofh8VB7xH6b/lPByC386lLCXZYkbzzMCKVuCuXNc6N3zn/R6Jll4IIhc8/YYoxsM7FASm1+T48A4loasXpR9/vxtxJlErqkOrBKegn6TwOVFciFl3xudMycfRtJP+sOQuL5kD1HL8LwVwSB6Gd17tQlCMobpd+0KO4dicTIAxQ/nqo5QoHpP4vbmTt1xYMN5LYIBqpewttRBk616rRIfEcEGnaNoLzEtDBniNhF5iz2+PSvgesbIMve
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 11:17:26AM +0100, Lorenzo Stoakes (ARM) wrote:
> And, in general, having consistent per-arch fault logic would be a good
> thing (TM) (and particularly - as Matthew intends to do - having shared
> code for this is a _really_ good idea, the duplication right now is
> horrible).
> 
> So perhaps Matthew could do this as part of his changes or you could follow
> up with changes to do that?
> 
> I think his work would be made easier by this being the same everywhere,
> however.

Yes, having per-VMA locks everywhere is kind of essential, so I was
planning on going second after this was merged.  Hence the careful
review ;-)


