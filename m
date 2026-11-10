Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9ABA606A323
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 19:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jlA4Tqbo
Received: by kanga.kvack.org (Postfix)
	id D64BB6B05B2; Tue, 10 Nov 2026 14:18:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3D536B05B4; Tue, 10 Nov 2026 14:18:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C81556B05B5; Tue, 10 Nov 2026 14:18:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A67066B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:18:57 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4538E1A0AB6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:18:57 +0000 (UTC)
X-FDA: 85420171914.19.D775523
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id A4704180003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:18:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jlA4Tqbo;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794338335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJk3YmOxg0lJBokWvd1lYbv0iZ6w5uZScCFE1jaF0zg=;
	b=VgHG3ePbfNQrKb9DZrisZ6feWdiiINQPEqTipuzwN3ADEn3huOrRX5U9m+7xsQ+cN0oFuU
	gy4Q5hWBgVESGRLPJ6LYkSPg1wn4I5soLRxXqPJ4bIrVZ1mQhLawEDD1ZWJ2PAcpQJr0SJ
	sQWGWO01YBByVhU1ShCYWScVJlvdkd0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794338335;
	b=h4LTLwHV+p2dp7fhf1El4UESyFDDKeS7EUh7T/8UcM58MpHnr2JT0BrdPXyeWvsmC3oeto
	sxNheCsFwEJyNJGgtiPw1sHmOLK+J7iE0aQMc707+3K+Ze9Wdm8gEJSQ7YqnVq/OOSPSV+
	K8gSnbnRsMDORHI6UmjrztNi2zhPG08=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jlA4Tqbo;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 28D7861336;
	Tue, 10 Nov 2026 19:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF34B1F0089F;
	Tue, 10 Nov 2026 19:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794338334;
	bh=EJk3YmOxg0lJBokWvd1lYbv0iZ6w5uZScCFE1jaF0zg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jlA4TqboaRmQqFcwJxLUB0Xjiny3+yZ2Gw4htr3kCUa9BKK3RwtSjicIXi71bQzIL
	 pln6NHDgcYKn/fycKT1oNaV5BQnj0eGWSPyMP2h91MRWkV89byoERa5AhdUYefPjPW
	 1esKXgmfPWasQH1b5ahQF4d2XJeK24eAYBB4RCRPZI/g6u36mSRDazWI7ifq4tzl6R
	 SkVel42DVjWCaeSjnlACzY4zmk+uQiOheNZOttg4oe4Q4YXi3lznEMgBHTDtiyVwC7
	 9eHWYNPI0sfgU3c7fJcI9Z06vh5LIoXNlsO8Di/42cf72IOyoKWMtEILX3u/0v8tBW
	 iPUMzMt0rswKA==
Date: Tue, 10 Nov 2026 19:18:44 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Uladzislau Rezki <urezki@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 0/4] MAINTAINERS: remove my reviewerships, add CREDITS
 entry for THP
Message-ID: <avNsYKFvA5u46us3@gremlin>
References: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
 <20261110105430.54c7a914e163250222151d69@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110105430.54c7a914e163250222151d69@linux-foundation.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: 3ptt1c8tzkn9pbnmedes8n41tr3hzmbg
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A4704180003
X-Rspam-User: 
X-HE-Tag: 1794338335-83655
X-HE-Meta: U2FsdGVkX1/Rwk3s/1phxs/KFZLc3p1biIdmL3Y7V85boja+MkwkLnQt+0LQvDwsUViU5EYODOmFPScaW55R25kb2fM4H0PgFFLjjX6ZK9jNoZbo54MwNjoEr2b4rBHWyhN/Om63hMubOU+sN3QwronPcBcvASWV3tuqqmxO/v92IH0KESIEyKk1q077+bBn+bFQXWg6gsW5B+xs+Kvnji/fy3JMgIk/jbfr3mSOfeSs4gyYa4UY1oY1IwB6MdAGbsR1+Jy4Bcse+Oc8w0uFRrp+pCSvYNZKurtgXqP2ohBi+RUeZmjyvw5iP9EYqmApscEhjudA/vx9Qqk6+nkEKfF25o21mhb7O0fwJz+x0Oj2zmwtnMhLvV7oFt7t55dKnJdLl/0s5/04VpCE8z7tmzaSQSHfeg6W4vzf5sV2iNRt6l/zbOJA2/UjWkcRjhe9QdHkljZ12pjxtJxzDGomMnhZgp4ElHkb2r4fgs6xOxflTRvuqkx96Y8gHS8+T5de6vTl5ulWilXVaJ58heueBj8Si9xTcaHh40Z2tTG7c86Q+QnnXUgE7l41LvH8qCXcYmXjWpd8eGmtw4Gt/Vq5Wza14fkyA1KYyW1yKdvEV3XbHeaUYBRdKFQwVDlHHME5zPtddURRF9wvCZpppPEIfXwVoobJugLFVonVWvNRVJHfyuRP6FUeyVNrIcFSlrvEl/UNPUhSmw7qKt5Ly2S21UFFQq6+yEaVWqjRraoYSsfiVXU+p82x7wDLkYxxjebnoStE8kLnLnkUXHBWuNQmTFL18rEHKDkzEh6ICm3gU+kXRyueq3RGk4DpvZqVqBR5snTAE5WmjDuskTsfznc9ScS46PiTczz6cvH5lo2f5b3pe8jQU1rCDh77nmO6+6xQJftm1LCqo8zSdKLHdpMQmZdLQHmBqHMhU+0eJIWVB2fzT+IFWufx9/GRvo2lZUnPxbGoD736+TXA3sbmGIf
 yxUzxm+d
 brgZQrgpnT9pRDsDk3A3CuLRwZBWyexmdpSMFxb8w9Jbld2i6X17sjnhawXqpw7kQBqunwyS0nqglipMRgkipy8waXsYYKdP5lB48pARx/k1fIQqleCVJQaH7Zor6dwwFcDR+sxt6nxflGfvQaGkOHl6+Iu7vR9Sq1DtqWw60cUWvD0lDX13clVd7/V5iJz1NKKfVscsV2xGx8FQ65w+BjSQ7XPTsSA8Bzl5QAZB+gxzJpd8FVAAgDbAtPyDwWi3TOtLQmECqSvSSnQH2NxdbaeCgpYQGkbKU4SFyeRxhUK2MH0fhMzZyZctYKcM8d0Hm3ZyRb8Tz2jHD+rIuaODD/SHm5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 10:54:30AM -0800, Andrew Morton wrote:
> On Tue, 10 Nov 2026 12:03:06 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > Given the current throughput in the kernel resulting from AI-generated
> > series, I unfortunately lack the bandwidth to generally be able to offer
> > review except in those areas I maintain.
>
> Sigh.  Is
>
> 	Nacked-by: Andrew Morton <akpm@linux-foundation.org>
>
> allowed?

I appreciate it :) but sadly not!

>
> Thanks, hang in there.

Thanks :)

This is mostly about cutting down the noise in my inbox. And likely the premise
is false and I'll end up reviewing all sorts still, but I would like to be less
subject to being self-nerdsniped into reviewing things unrelated to my
maintainerships :)

Of course the AI wave has been horrible, and is getting significantly worse.

At first it was once in a while that I'd see slop.

Then it was at least once a week.

Then every few days.

Nowadays it's pretty much half of what I see, if not more.

There still plenty of great people in mm though, regardless :)

--
Cheers, Lorenzo

