Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2250CD68BD1
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 04:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B976B0088; Wed, 17 Dec 2025 23:03:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C906B0089; Wed, 17 Dec 2025 23:03:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663736B008A; Wed, 17 Dec 2025 23:03:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 579E26B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 23:03:35 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01CC48B911
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:03:34 +0000 (UTC)
X-FDA: 84231247590.20.5A2FBC2
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0DF00C0004
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:03:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BFvSVM70;
	spf=pass (imf22.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766030613; a=rsa-sha256;
	cv=none;
	b=C1oK3CCZ3tFjnJvm4Zx6T/Ncqy1SwvW7k4JJNSmoqtPGunwNyUprLMio44XF2WZykOgmqA
	6KO/fqLWrG1ZGUTwqmEIvz5DdjVMQu4A7W56MJ0sQb5VkOsp5D5SKZ41NobVpd/DP00q3A
	Jns1ybTHfFtUOAXh8XTDRYKEk80sqzw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BFvSVM70;
	spf=pass (imf22.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766030613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHI6rvtpgTrf2rQzMwqNIBav/7/ZYbn4AXdiKjSA/wA=;
	b=MQ79hEVbP90Bj0ja5fX5CAmLPY8/WudDLuBXbrztdXDfAnqwUP0fie/5Bb/rxp9ac3GpUS
	h4m+Ov7qE4/6SzTrQyL/6E8Aoa6yyB44VROKEzPbbQPFX+lms14b6Dq+JMZzIlwnBKLbek
	mT4qVYVJlABSM7NEI/pvmqIDaNCrZ60=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a09757004cso2249565ad.3
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 20:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766030612; x=1766635412; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aHI6rvtpgTrf2rQzMwqNIBav/7/ZYbn4AXdiKjSA/wA=;
        b=BFvSVM709DyO9jbrzQhLDriaR50v8xKFkj/c6S/48GPHUw2NEqPjYQUSLM79dS2LH8
         3a54+9Ofr0wT1shfqL9RRdZIH+WG0QXBwoVEYuOmnreUaybhhhhmV0GTRdt0pUu7fN31
         7pBmkMijQS0BRL/DthRxVYCllvWtV+cjoHEw6zDuu5MNQjUEZJe442NYsWwgd0m9HFcq
         Zn+HERlMLD1FyVlFRzxfG+ItGpMN5bgDwl+AXVx88+2wTu1phmpoVQ8/fEQ4IU0gbwSd
         obhUKYxfND8i3kMYHWTyLmLNYff9UBxMxcfjzveszFyiJNrQ9w6JxDMuTLGiZgNwlvsS
         7OCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766030612; x=1766635412;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aHI6rvtpgTrf2rQzMwqNIBav/7/ZYbn4AXdiKjSA/wA=;
        b=vzR1CtSQQdtldfDAj+JEoEg/e+Y/efQdheO8twYIpRtTOqnZg2Gf39K49D0iOZ8Og6
         gsXR3otcdTjVedJhhUz4rRDasIyhE1/speeGirV3Z43D6EzP4//4Z/AHw1ZM1czrhd6Z
         HB9kZHynUIW8XNcs0trI++nXO4ZM0DHb89B9xqWcv9GVyUjDm1M6GpiJy7ZHqOCriatX
         AjpD219l4p13Rc/ShqbHgI76K6bq0kgWTB4W6nUt42MAqBpqTIYlocpCXRujoIqDtEst
         CXxmWp65yXhxFiNNxtvbaDus0urhmo7o6S8Gu1kXgDh/CvbzgiaXNvwGuAS2aSXaBBoG
         yXxw==
X-Forwarded-Encrypted: i=1; AJvYcCWodoGQu6p/eisv0twrpMQ48ov6mlbIZ4LH4P2NtGhze+0bbxYSDPwkyUh4J1MsV96XzHpj4wvFGA==@kvack.org
X-Gm-Message-State: AOJu0YzVx2aRspqEna98YAEOqoUMwZNcM1GFxuxtNzTQjIWtotIppvLq
	7t3PceHY+pZv+ltVRF7sogJob7xJjRavuKlHCUAD15LbJ1/Au6oB/ZsC
X-Gm-Gg: AY/fxX6suIfz9RTUrgc9hTb6HfbCP+WrGq1/Vwi0vmZ3MkE2g/QXgdxZ8Q/Zwv1gzLh
	QU6TwjtOq5vcdtxXUEl7Ma7oz11wszsERKzr13gRpOo7aEg0jgGjL6sYLyhYdNLMzqh0L68W1L9
	G52HHeYL1Y87w2QA1WxWXqEtry7ARm/Rs47Gp94ZJDyEZQvWf7VvLnVX7A6344Trb4IE+/szDNl
	Hneh4ySPeLVImMFL0uD2mQYxOjrqVTEvQ+Qzmq11WbWbhE8vT81J53NdpH5JR6PgeL8vmO0YbfN
	w346ePRPQPgjdyBaHEPLu7zGGuXmiTXBeT+rKRhVM8ZWhzZGvD77mA/M4Mf+dgEkpn3h6dYy/MH
	ZoNCNySn6LfN68ppSg/lKnd3iwHFxVg53s/upvRj6P+4tVviiidt7gUFYIqNpZmA4yV3+hplPcK
	D4PpI=
X-Google-Smtp-Source: AGHT+IHa7r0mYrLhWHjYQHKjTjGzpva8/SmCDywQMnfbi/eRtfbpSa8NAyazhiN4pJFcNwjNZ5uZlg==
X-Received: by 2002:a17:903:11c8:b0:2a1:388c:ca5b with SMTP id d9443c01a7336-2a1388cced6mr90213585ad.39.1766030611814;
        Wed, 17 Dec 2025 20:03:31 -0800 (PST)
Received: from localhost ([2a12:a304:100::105b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2d087c690sm8680035ad.20.2025.12.17.20.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 20:03:31 -0800 (PST)
Date: Thu, 18 Dec 2025 12:03:28 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+4d3cc33ef7a77041efa6@syzkaller.appspotmail.com,
	syzbot+fdba5cca73fee92c69d6@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/readahead: read min folio constraints under
 invalidate lock
Message-ID: <aUN9BFdxHQj8ThMS@ndev>
References: <20251215141936.1045907-1-wangjinchao600@gmail.com>
 <aUAZn1ituYtbCEdd@casper.infradead.org>
 <aUC32PJZWFayGO-X@ndev>
 <aUDG_vVdM03PyVYs@casper.infradead.org>
 <aUDOCPDa-FURkeob@ndev>
 <aUDXrYgwZAMYkXVu@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUDXrYgwZAMYkXVu@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0DF00C0004
X-Rspamd-Server: rspam04
X-Stat-Signature: aj3f1esfcmjjhjaqxtrgr6fwobzcjzfb
X-HE-Tag: 1766030612-434129
X-HE-Meta: U2FsdGVkX182WHE4n5mM68eLR77lVKn703gkG190P74ZBavpDz/6/H39VzZxtwP2tBw5MF43Q+Hyk1+zZs/o7e97QgQOaQo9bgFDCIlF1pt0l3HN8VPbKTtfok+DoBgjF6Ez9N2Zbfu4HkUW1ksdUi0BYh0EUMArvIoa/mq6Op71Hf2LyYT7MZwYqpEGjBUWHqHtbWiE/KvsNjrHHrLJwbMtV3ukIVcBFyX4gCpfAX7ng/m7eo5MrF/wl8Zf8t/9+er6ulilkAeXV9sLJse5cGC1NbGHleEr1Fn/A/HJXD3qabfal2LmAJCIQp07mjLKb0PPkAZdop7klvJtaelYbz/xFadkoueg3IRWqzKpPA+8nQi70uC6a1iqkht76YrcjChaaFvBYk65rZJ2OIizz3IyefFP6x+PJm0iNCw0VKhc8V9Wmp+eW6dcN6ocBzv/909PyI5jXPRdS5UU+8dIN7fXJv2SjYfQ+rMuhAdCYcQhe7I5lDRUXPihhqxvBNtAX9eAVkwEJBeQ5JTrBzVr0DCXn8dHKlAhDNAm1+dl4pANoCY1C9bGuPnK3puskF5uY69nW7qhFjen8IJZR+eb6BpWJCT2diy6B0NJq0zu8g6tcOPuTxsJ4yoVAIBbNQ8/Gks5DzrcZvQk8wN7YBa6v21ElxzExDWqU/Byl1Bdt1slSJMQWLM4dsmsBl+gSu5LNBgS+471nbnB0vZUoAco/q266jQx0tnE+etF8ya9JE1i9qqWqsMIEPfSyqFWzm/BcNEWb8ckg+oiTcakRPBeSJvG2Q7nEyPH6i5oXRsKngsORKYD4dgarUskJ1nAjnw3zkAcl0L0E5xa6bR6L6xUDukv38O/O+70SpTwWb79j7z0vbVyaoWBRjrW9LghM4Z7PgPh9UGw97cYCwGYn0gyvxm2Nyu9v0RTGURPnPhf+lTgigMnRI6PzlpPbYzz+y7wS3gtcFVykbvLn19+O2A
 yKwX3uSp
 0tH39uUMZ1ve5AVaIN/lG7oum4/TA++MV3Y0UWqQcqmKMp5mw1neE1emu2Dm2jvFvF6IG+6MrGaDzhVTse4GneW9JGpWib1A9zAwVPdLGyNmRNvGasQAcmwzzrg78Fsx/pjPi3ajkHR92rtTcJ+xNyo2hxRJhVfbtWfXO2ZQv/ymnGYj4D39pjqs5lNKXD2UpCDseM3iJcpVV1iOi19j/vbH39XdvpQZq3sNRZAIcaKwx8LO6nDHiowkdvMgjRCrsypPG4oXNilnS5oh5Er72AAYXiqOlvlnEJOLU0cMpi3B91nA6IlGNTzHOivvEZ+fYZbP3L5QloluDartUPLFI2gnENxBNMMFwoB/6QyJj0S8Fq0fEACnaqLZ+tEwJ0VQE81W8EGDS+9DxlkHjwQqun82ic4LQl7xsX4HnwJ1xtkx2H9rNsvRIjEKik0EqBHvwK1CYPDyY6SktaPXqsk9nluzb6s2LfgTWcTKn1lzYjZPX1RAmezb3hj3UpUVsgAoM8YX8MADPT0lRigpCxgiX9acZ42cgwSz4U18cwH20fZSozBx00dK5fHoj4Lv1VXN/wmEt2tqPspKmdSwSsv4hN9aNACWV/QWvzxAi65HrgKd9EN3Mct3unTyHlcmJ6wB+CsrBUqjTXBXpSTMrVijwhXl1ESEQ46SOuP/R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 03:53:17AM +0000, Matthew Wilcox wrote:
> On Tue, Dec 16, 2025 at 11:12:21AM +0800, Jinchao Wang wrote:
> > On Tue, Dec 16, 2025 at 02:42:06AM +0000, Matthew Wilcox wrote:
> > > On Tue, Dec 16, 2025 at 09:37:51AM +0800, Jinchao Wang wrote:
> > > > On Mon, Dec 15, 2025 at 02:22:23PM +0000, Matthew Wilcox wrote:
> > > > > On Mon, Dec 15, 2025 at 10:19:00PM +0800, Jinchao Wang wrote:
> > > > > > page_cache_ra_order() and page_cache_ra_unbounded() read mapping minimum folio
> > > > > > constraints before taking the invalidate lock, allowing concurrent changes to
> > > > > > violate page cache invariants.
> > > > > > 
> > > > > > Move the lookups under filemap_invalidate_lock_shared() to ensure readahead
> > > > > > allocations respect the mapping constraints.
> > > > > 
> > > > > Why are the mapping folio size constraints being changed?  They're
> > > > > supposed to be set at inode instantiation and then never changed.
> > > > 
> > > > They can change after instantiation for block devices. In the syzbot repro:
> > > >   blkdev_ioctl() -> blkdev_bszset() -> set_blocksize() ->
> > > >   mapping_set_folio_min_order()
> > > 
> > > Oh, this is just syzbot doing stupid things.  We should probably make
> > > blkdev_bszset() fail if somebody else has an fd open.
> > 
> > Thanks, that makes sense.
> > Tightening blkdev_bszset() would avoid the race entirely.
> > This change is meant as a defensive fix to prevent BUGs.
> 
> Yes, but the point is that there's a lot of code which relies on
> the AS_FOLIO bits not changing in the middle.  Syzbot found one of them,
> but there are others.

I've been thinking about this more, and I wanted to share another
perspective if that's okay.

Rather than tracking down every place that might change AS_FOLIO bits
(like blkdev_bszset() and potentially others), what if we make the
page cache layer itself robust against such changes?

The invalidate_lock was introduced for exactly this kind of protection
(commit 730633f0b7f9: "mm: Protect operations adding pages to page
cache with invalidate_lock"). This way, the page cache doesn't need
to rely on assumptions about what upper layers might do.

The readahead functions already hold filemap_invalidate_lock_shared(),
so moving the constraint reads under the lock adds no overhead. It
would protect against AS_FOLIO changes regardless of their source.

I think this separates concerns nicely: upper layers can change
constraints through the invalidate_lock protocol, and page cache
operations are automatically safe. But I'd really value your thoughts
on this approach - you have much more experience with these tradeoffs
than I do.

Thanks again for taking the time to discuss this.

