Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ACB9F99C89
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 15:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F10B6B02C1; Sat, 18 Apr 2026 11:30:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A2406B02C2; Sat, 18 Apr 2026 11:30:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B7EF6B02C3; Sat, 18 Apr 2026 11:30:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 08E036B02C1
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:30:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72BC01605A3
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 15:30:39 +0000 (UTC)
X-FDA: 84672063798.24.39B7730
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id CC9134000C
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 15:30:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W2Lpe7la;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776526237; a=rsa-sha256;
	cv=none;
	b=lNnL942uYAyPhH05/1GOiRZX0OhVh+oD0cgSOIH4eqHD1MM4KbNDMEvGaIg/jxQKrbcTAx
	8pNqm376jQrHPrtex3lKiQ063lC+8h6pA2/ZpgDBT/KW4cYSFrlDZCl58nHkYTbEvowduH
	LkIp2QiB9frGl7p9Z+9w5AurKGzmOIs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W2Lpe7la;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776526237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mC7yPuHu5gpbPHSCXjjbB6rHNjjqgzuWTRPAPgmOAB4=;
	b=fNKWmExHup8y/zR5MNIcpYDVFL4Ch3i9XZwOp2/fLFkiYNuq1oEm8cojKLqccucprMbdV2
	3gVMW/VYd6SqqZuZg6XRKI5LWNPYl3nSB5/breFRI/tnFKGuihxPpWzzyoXtKV+Xv1M84o
	ihyxvlrqXATwFjRwrWRfUeuYaOOQnFc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0460D60138;
	Sat, 18 Apr 2026 15:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74699C19424;
	Sat, 18 Apr 2026 15:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776526236;
	bh=ZkqedO1+/KX2dVkAjxmTlTJE7OhLU/Oi+zD52I3fudk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W2Lpe7laQ4FtpTW1u0i+4bKpSZ80WTLPFWjyydgWKSIZMgZhq4aXGnxpdHpsf05Uq
	 5PUJX/JbgiidwwND4yVJwvC8MdFg86SpRTD5oAAbDvL/OKm2uHeL9P1Iy5QEPS1Ws8
	 1jYVSiL+zl7MT6NoWc4Ry4Q7bP+Ks45iBExmSpmnRquK3YnFHrEjfjiviZzcPwTiuQ
	 mshk5ZddhUX3R1K8LYMh75MBcg2ZefkDN21+RmFvgrfObUqeFOb4aYoBgoVcmuXUbj
	 ZJZPYUBpxLzsJaXvP/AxewXBDfvAb41Hlqy7kCXv8/qrkvFY2TlNGOt9TKo2cTUqHT
	 Yr+WlTLh2TrtA==
Date: Sun, 19 Apr 2026 00:30:34 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Nick Huang <sef1548@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: Add overview and SLUB allocator sections to slab
 documentation
Message-ID: <aeOjmvP2nR6ri9qr@hyeyoo>
References: <20260418000635.17499-1-sef1548@gmail.com>
 <aeMQ36jFnCKmCSyA@casper.infradead.org>
 <CABZAGREDHwsXMm65_WxEn=v-zTv7_eVqQzQeCRqU2Gyc0aTETQ@mail.gmail.com>
 <CABZAGRGFpiiEr7Odd5an1+9Z+sX1C6QT2iadv-0hNhxGj8eEyg@mail.gmail.com>
 <aeNKDh8S6pXHqRFh@lucifer>
 <CABZAGRGCwM1PiSxennV-Uy9y1gGKjpcHeq+eOAbqSZcy3Qb55g@mail.gmail.com>
 <75b2b254-2e02-43ca-9109-9812cf3f85b2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <75b2b254-2e02-43ca-9109-9812cf3f85b2@kernel.org>
X-Rspamd-Server: rspam10
X-Stat-Signature: a7xwwd7o46okz5rwoq7sisfssghigfet
X-Rspam-User: 
X-Rspamd-Queue-Id: CC9134000C
X-HE-Tag: 1776526237-671035
X-HE-Meta: U2FsdGVkX1/6mzKrxTPBzYmzD2PqCvtB83czPkDJeguswkki2gNSLnfUaLGGZ7cUJKt+qNHC2/NPQ+WpsTzvNl70MCB0Mcv5tBosuFG7ATNtHn6JjnvTVZsT2ipawma1qxFt+/4zK4if/utqVuyN4fBtfw8ZHdhO9ET7rUtphNf2Y8+VPoa6/fqqeg9Ywmu9EslGdky4+18JyNMjH908qLmwxnaNOwPc52BuagAPmsKDv2rbC0G6Y66KvbEKkTffkoe0HEneEmi6RSeghmG5crqUdJbIa+voVUguRcBarkcrhaKzF6LVcVDYc8/hUWFhWezz+4AwQUvNc8bPUaYrQpJpADPVc831woSgWk2l+HfkKZrnRTYF+Mt5gGRbJzuf6paQULNkvs8LplucQbPJemCRT/3GOb9wYtTfrUc7XxBpzS3aXl5NVXjK1T/0jpkqwbAHQNZNzLX0Xb3sY2IEgu1h8mokfz3PPZQjjkT84aVicF8MavMF9kiGqL57gIcAGSsMgPGcWHOOJj4iYgusxb+J+5ngUHXbJLDikKsL0iO7GpkbIwaCFDL1V1CROE+p6vGr7dHHI4aTz6PP7i+0e2u10UhCQYG/iUaZHm+EZYN3qBe7FtrZwrgYn8OdcACUCOoOsiVjUpnALFOdBnVtB2zMj8II9QdUTVhb3f7298wqzbbvJUoaBC/jsTSGiSJ++z7LEePLsgr55ScAAfRTGg2D3X4t4EW+/hqlylI/CKF/b5/xCF071T77xY0Jr6dCSy0wrW7VcZP0694+LrE4rLsG6UFCGk68WhHpF5Hq47oabh9qHOJmVknf6YchePVHKz5ITJhf7yHYDWhSW+T+Q9DnQHV0ceCU/e4wIBSeKZOV5zRmkslMc9oWyixj051iu0cXj0kQ2B5Urk5QgVRxDFmoRNaOdWkV6eIeGXe2jTZgtTtYRL2A529yc8AOpTtHvhPsnkUhQvbZInQSbga
 iRW9wyzd
 is112IjCZsmVQmmnn+CwSDEDSODK/LAbP/b0mON0aBMLr6dhYTKGapajLNue9IA69qaxMm3x3r9pkGdtziMDpEDuNdlXUI5we49k5IEWQOlG1Vdzl+LMjOtXJfw0JTreNCvYxZwlF6AUePVBbP0K82O+QIOMXTGh8lw41L9y9ecW1l6wyNlXBqb1D7BHbdXpUXdoq6a3Rjomikytgg/hg0p9L5Zu1NYK1qSU4JKqnAznluuu+hi3VLNzSxwLva/rQ0J3gloKQe5sIpPddg/YmmYkbMZPer3lVwrvXnHAN+dNlKYZ1QtWsRj71ghHHhq38pO+ZkOavdIrOcWWMg1/cwrPvAKpihv3n1+j5fWwuxJPNOqvdoFXsn5geD4mKpleiUBLL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 18, 2026 at 01:20:42PM +0200, Vlastimil Babka (SUSE) wrote:
> On 4/18/26 1:00 PM, Nick Huang wrote:
> > Hi Lorenzo Stoakes
> > Lorenzo Stoakes <ljs@kernel.org> 於 2026年4月18日週六 下午5:11寫道：
> >>
> >> On Sat, Apr 18, 2026 at 02:12:22PM +0800, Nick Huang wrote:
> >>> Nick Huang <sef1548@gmail.com> 於 2026年4月18日週六 下午1:27寫道：
> >>>>
> >>>> Matthew Wilcox <willy@infradead.org> 於 2026年4月18日週六 下午1:04寫道：
> >>>>>
> >>>>> On Sat, Apr 18, 2026 at 12:06:19AM +0000, Nick Huang wrote:
> >>>>>> - Add "Overview" section explaining the slab allocator's role and purpose
> >>>>>> - Document the three main slab allocator implementations (SLAB, SLUB, SLOB)
> >>> Hi Matthew Wilcox
> >>> I will remove this sentence in the next version:
> >>> “Document the three main slab allocator implementations (SLAB, SLUB, SLOB).”
> >>> I’m not entirely sure I fully understand your point. If I’ve missed
> >>> anything, please let me know what needs to be changed. Thank you.
> >>
> >> No, please don't send any more revisions of this garbage, thanks.
> > 
> > thank you for your guidance. I will correct my work and introduce the
> > more recent `barn`, `sheave`, and `kmalloc_obj`.
> > Do you think this is appropriate?
> 
> No, this whole thing is inappropriate from the beginning. We are not
> going to waste more time on development-by-review for something that
> started as undisclosed LLM slop.

Just to be clear, Nick.

I'm no longer willing to answer all of your questions and request for
guidance sent in private as you keep ignoring questions & feedback
and still looking for other "interesting" items to contribute.

Let's not waste your and others' time.
I don't think this is going to work out.

Expect NACK on your future slab contributions.

-- 
Cheers,
Harry / Hyeonggon

