Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A3A5CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 12:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0EFE8E0008; Tue, 11 Nov 2025 07:37:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6D18E0002; Tue, 11 Nov 2025 07:37:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC958E0008; Tue, 11 Nov 2025 07:37:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC3B8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:37:01 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5CBE412C0E3
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:37:01 +0000 (UTC)
X-FDA: 84098275842.21.FB15578
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1079BC000B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:36:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AyPTV6H3;
	spf=pass (imf22.hostedemail.com: domain of toke@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762864619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HJil3CsSx+8fOj31OoVJWOQNTlYu8I58IHhwpqoKvHs=;
	b=DXeoflzFFn/11pc1gRbnaYyeKMcvtAsWndGR97Tn2kEWsR1EV5zydHLE/EFgEth77WysDq
	oHLNBePpwoosHgr5MWMvDOmmSMdlxWc+HFYDdEFGYcwZ9s1ibTULZiX3hC65FJbgTroqw7
	1yiBUAaoQjLw59+3xg8xLOcUUjfISXM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762864619; a=rsa-sha256;
	cv=none;
	b=uRay2KYosCVfD6Ns1rfz0OKezG4fsO1oovFqe+vsQWMg7wqbhlu0k1vZ9J/FrqaXVJxaah
	zzaVD2tc4t6vB0NVPKalsNgvRmullINABP5+kZSUWnzN4azMRzdCNWGZHdy7fqOIWs5A8T
	1mv0EcMT2JB7nRr22AiOQyTPwJdd01k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AyPTV6H3;
	spf=pass (imf22.hostedemail.com: domain of toke@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762864618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HJil3CsSx+8fOj31OoVJWOQNTlYu8I58IHhwpqoKvHs=;
	b=AyPTV6H3gucK796jy3F3qxa/V/hFlKjo1gBtdbFU8xgahLGiBHLRx3o9dAmDqnTUS+jMIT
	WWY6gIVYoYjxc3NlsvfviO/TgIdbL4jbs4cRa48KiGfqw2sUuVBQ8D/3mCIqjeOhESoULk
	Awch9Q0kJl7aFWyjmeTe7aPJQuGZBVM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-F4V393cvOpaPUbGjepdvog-1; Tue, 11 Nov 2025 07:36:57 -0500
X-MC-Unique: F4V393cvOpaPUbGjepdvog-1
X-Mimecast-MFC-AGG-ID: F4V393cvOpaPUbGjepdvog_1762864616
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-641613171cfso838742a12.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:36:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762864616; x=1763469416;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HJil3CsSx+8fOj31OoVJWOQNTlYu8I58IHhwpqoKvHs=;
        b=W0MVjd/j1EMhI+b3A21gS+URQ9Oe6BBq7Ta9awPG7WjdecCjTf1x5oZtiYEjUf6KwU
         M0o+WhfhaoQoryYHO2K2T4U20fx2OaZVHkk/ukXE/e7cW1SoJtOjyB+71dy9XgE5YcjA
         GIuk8o3zbVCHkwJy4babULEw2nwOdr52Ng3HyuYcXeuuALUfUtbXhJZGAwVevJR5azOB
         u/lV+NxrNaFJFyFx743iBao6hhrM7B8Mb9FT/J5icETeW/Y4QdEKiWOvEhLH/kwhT8xW
         1PzMw7dz9ie2VJ9AaTHvTQsiHygMVB+b+riut924KKAtOEcRkFr7HhSQ3MCAsTDpoZ+G
         0Dpw==
X-Gm-Message-State: AOJu0Yz3qOLrgr7w4jFizjoWZVxX9VOoKOgeW3eTB2EByidq3pZOvumW
	srcvPgw/knsK1R2yKipt53S3sEct8X7YjSZ77C0y0MA/An2kiDSZlQOQOhwzPfbyoQP1kO+rcTb
	IbeYHG/XHobiPlrtP6qxAIvrFtEmU7sk9ldYsXCTtxBjngEdF0GnX
X-Gm-Gg: ASbGnctTppOf9nwWxr3kHdbjDHmYMDbMD88JE0zoA+M70qmoPsVlnIy+kYwgVDWTUHI
	Y5ldyYTlS06mmpJ9IkxGG/F2qdm82kueDl9SE1lKHUYWXRslAZ36PV1ieML4gQQblxNtPF2c/pS
	xbTu6syIouwmxftR1JcrCoZIqjGz/HqLreMe4ha5XFoP40NIu3xDT7P/XpeJC6V4uY4aBGjhcmI
	P5Qfz8ygDdJgU9UzxYj7cb13i7cspsRGpv9KbCZ/9k+G7m7ZR10aF7ua9e3ew6Z7A+fQdPFFKVS
	kR7Km00qD2K8x70c0Kp+Q0byXw/TGxaxj66ypB2Gdc83CIU9yDe29qZ6XoalYDlK6oEyjc6CywF
	3Wjczs96llrjqtoXIpT/kg/DK3Q==
X-Received: by 2002:a05:6402:5189:b0:641:6b44:75de with SMTP id 4fb4d7f45d1cf-642e275ace8mr2893741a12.5.1762864615827;
        Tue, 11 Nov 2025 04:36:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGfkAwSb/V5JIwU5moExHjbeMcWwrXGoX+mdVUHDtdTxf3WoXuBjDbonnmfpi475Ak1gHNtpA==
X-Received: by 2002:a05:6402:5189:b0:641:6b44:75de with SMTP id 4fb4d7f45d1cf-642e275ace8mr2893656a12.5.1762864615046;
        Tue, 11 Nov 2025 04:36:55 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.borgediget.toke.dk. [2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6411f814164sm13449948a12.13.2025.11.11.04.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 04:36:54 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 83146329590; Tue, 11 Nov 2025 13:36:51 +0100 (CET)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Byungchul Park <byungchul@sk.com>, Jakub Kicinski <kuba@kernel.org>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, horms@kernel.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org,
 kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 baolin.wang@linux.alibaba.com, almasrymina@google.com,
 asml.silence@gmail.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com,
 dtatulea@nvidia.com
Subject: Re: [RFC mm v5 1/2] page_pool: check nmdesc->pp to see its usage as
 page pool for net_iov not page-backed
In-Reply-To: <20251111024500.GA79866@system.software.com>
References: <20251107015902.GA3021@system.software.com>
 <20251106180810.6b06f71a@kernel.org>
 <20251107044708.GA54407@system.software.com>
 <20251107174129.62a3f39c@kernel.org>
 <20251108022458.GA65163@system.software.com>
 <20251107183712.36228f2a@kernel.org>
 <20251110010926.GA70011@system.software.com>
 <20251111014052.GA51630@system.software.com>
 <20251110175650.78902c74@kernel.org>
 <20251111021741.GB51630@system.software.com>
 <20251111024500.GA79866@system.software.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Tue, 11 Nov 2025 13:36:51 +0100
Message-ID: <87346kn3to.fsf@toke.dk>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -jLaSvqmgHA1Ji1n6nozDJApA8kq6AMDXtGDaV1hFz4_1762864616
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Stat-Signature: 5gy3gu7jkzt9nxmh68opfuh33bj4d1qd
X-Rspam-User: 
X-Rspamd-Queue-Id: 1079BC000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1762864618-153313
X-HE-Meta: U2FsdGVkX1+R1hOvgbf+gLeIZm3sUGyOI8mw5qx+zjU6HK0c8wiJXiNqzFpfOKmt/nKzsNrgYnIJ+gWoiL5dRxoRFJr7UlDf51C04Zfzl4cDACzPEPQMqgUqQjZ66+7i1iPIlTMKaVQJ5HnrOOA132FB2XfUfd6p+vznWfMOYhCaywbO0iZbgMzm+z+ejq5CEysxupR+THRU2zdRiiAqlQs0aGQ87Cedv+qiIt8fr0eutwH9/QUZuqzDDE6tHE84ksMf8uf0oMqChWtFFrIhsc8Zst5AisOoyJ3Qzt7QqB0oAcgbwEjT5JmzltRrRYsO/l9knBQxEU1wNpTc7ihFq9P+CrU12ulQV3645tWcPA8pGoXEoKpQDNcYoct9efJIMEOnv3zZUyK4J6sk26A7SHzRBFIekJHil7qe3WFoo4uF2bfebD/v9SgTIrIO+J8qRYCkz4Ui+Iucp0HX9/aK2Nzr0aATil9JbZrXH96nD6WviJpjFYdTa/oOIxbvXWCX4jyD7gUd9N7IZXH4KA+WeCvzOrNok1ER3kBHvo5Wrw+GS21NNem2TWSmBNiENwwgLwAUCtbciOAeYx6tRagG/f/PierTEqO3k/D/6Yqd94wP9dSsWwFRGNe182/Ho8qqz7XObmEynw8PEP0SLZXQprUceS8Szczbvexzcisplq5WpPw7TrxYkcUSoGbA7l2BqkdZ5qiISqRHZdLnOcFUOWwQPmHyVg25S5EOrOufe1lvPeXuBABKHUjuQ5gbjy5au7Sk3cAfOoMaENjTAQY9hEe8MZehBb+kiGFUcPMTtXZ7yZHykek3nXtUx1yvDRVNBNaeOqw5+/5/RNHDJlXgHf4l3LRG5mxNarlBWkszTqktio8Pne6Hkd2X1Z06sosOpETa8ZbrOpIQ7cdxkTP7zz8aETAqI+s18DlnD9HZzV6CQk7oQ1a6vPIifru9xBe+L9en0HC8+VuhbzxvYjM
 qaCsiIyy
 m/E8R/qBt1XVa3cLEgB0L1zQAjsUj9cUpxntWvP3RclMspv5ZuaXot8KWlFV+vLEfTBToKMl3gkJdG/cHd7FUZ2UKD6rbrEEWrGWBKeqNttDIm1aDxpajsTfgpUHKnofb9CBUYkAoNE2wvFJW3fpqgcsnADUWMSri7/FaLJoB4opsLA5K2cjy6Qq86V19tMShS7qBv2PXVvBGEsz730yB/Eou937c50uwBi1PdywBrdn0dItp9MtkwU00ndQEzWb6QbGyldGkntTg/CiXdixL7Okc8EIzS7Hq+v2N8U6ppFpVuNBjxuRUPmc48OVWc2eYy1BkmY0RUXcp9pW4UqGWTmvQNkiU58XVk65a7bb8nMlLn0xHF2jMusGL/+YnBvlJrKR7hX3RQeAso6cBCuEeMAIl6b6md2KzN5ZDCn6G6jhiE6TpDyKP7sE0wfY1zitVYVxk+c8zhMadaf86134smZ8OJjY3380PlAVPULVgau5joXYgRKXVX3qH+MNcpGLpDlaWxQa4rMSsXYlf0xLx6UjzJ5mTRCOgzm8F904XtSDQH8j+0X/2mI73+nCIQ9/DrQ8+GwS6P3rnMoc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Byungchul Park <byungchul@sk.com> writes:

> On Tue, Nov 11, 2025 at 11:17:41AM +0900, Byungchul Park wrote:
>> On Mon, Nov 10, 2025 at 05:56:50PM -0800, Jakub Kicinski wrote:
>> > On Tue, 11 Nov 2025 10:40:52 +0900 Byungchul Park wrote:
>> > > > > I understand the end goal. I don't understand why patch 1 is a step
>> > > > > in that direction, and you seem incapable of explaining it. So please
>> > > > > either follow my suggestion on how to proceed with patch 2 without
>> > > >
>> > > > struct page and struct netmem_desc should keep difference information.
>> > > > Even though they are sharing some fields at the moment, it should
>> > > > eventually be decoupled, which I'm working on now.
>> > >
>> > > I'm removing the shared space between struct page and struct net_iov so
>> > > as to make struct page look its own way to be shrinked and let struct
>> > > net_iov be independent.
>> > >
>> > > Introduing a new shared space for page type is non-sense.  Still not
>> > > clear to you?
>> > 
>> > I've spent enough time reasoning with out and suggesting alternatives.
>> 
>> I'm not trying to be arguing but trying my best to understand you and
>> want to adopt your opinion.  However, it's not about objection but I
>> really don't understand what you meant.  Can anyone explain what he
>> meant who understood?
>
> If no objection against Jakub's opinion, I will resend with his
> alternaltive applied.

No objection from me :)

-Toke


