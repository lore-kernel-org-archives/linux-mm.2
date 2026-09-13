Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC7DC88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 03:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F0B26B0088; Sat, 12 Sep 2026 23:11:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17B016B008C; Sat, 12 Sep 2026 23:11:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 059BC6B0092; Sat, 12 Sep 2026 23:11:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0D9D6B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 23:11:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C03231C26F1
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:11:54 +0000 (UTC)
X-FDA: 85207264548.28.070A2AC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id C8B1A120008
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:11:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CCR8M2oB;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789269112;
	b=7125snH14+Ho36TuJPC5fRpcgMxN7qrwwNMziO6ut6w1KtVf9fGACVTx3DqSqRWIklzrN2
	u/akDGHLsMEaCfghfTiOFO5VEBJCgi9FMxNvQGaJ+74+7qu0w17hRzuESL7jVRnKpFPRXE
	IOMBTOBWa/OdJIW9MsLsxuJ+/wcsSSQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CCR8M2oB;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789269112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ssrb0XY/cPSH8ZAUVROdvAzpy0zzHhYV7tpvfy8CQwA=;
	b=UP5GKEL6XwaH7bzLUBP1lV6z1MPuTmZzG82yVKSiWnkETwDbeP76LIsyMfKmrwqAA57kiB
	ff4qKnN3RfyO2y4t6fvjvRshfDTD4bxfoZJ8n+lI3SrYtNCrFxmPJYxg8S09wQ9OcHdvRg
	/A25EfiQnytlXRq5/WjP2ocNPXR27Oc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ssrb0XY/cPSH8ZAUVROdvAzpy0zzHhYV7tpvfy8CQwA=; b=CCR8M2oB4m+y0ftzq1hl5Cd7Sp
	Eq4utnfvBFq8gG0OogYzPZnaQmzmOp5fGRpwLZZxXeWo5U93OC/Wz+xi6QYk98IdczgUTQT2qoCKU
	KRd5XLKE1z55BO0DvoKqhe880rWuFdw1oBGkG7StPD4m+68dPIwtGr3HiGHt0EP5J31zAOnhXrkq6
	H9YfQ8GzUvx+lR7ad3e/FRHlzs3qPoF6bfrnkWMKjURpXqLuM58MWTSM8LvGJrlpAd2Zzgd3Kprn7
	9QWHr0RTjUAtUGxCv0xeRJ5uWFR4OjKHcnWu/4GD7GYpMcua8HluIaf9wWQfAzw2c47qK2YYb1024
	17XaQfSw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x5acl-00000003JyY-1RDO;
	Sun, 13 Sep 2026 03:11:23 +0000
Date: Sun, 13 Sep 2026 04:11:23 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Lyude Paul <lyude@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Llamas <cmllamas@google.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Dave Ertman <david.m.ertman@intel.com>,
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>, David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Igor Korotin <igor.korotin@linux.dev>,
	Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Michal Wilczynski <m.wilczynski@samsung.com>,
	Ira Weiny <iweiny@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	driver-core@lists.linux.dev, linux-block@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v21 9/9] rust: page: add `ExclusivePage` for race-free
 page access
Message-ID: <aqYUWzRSade_Ww67@casper.infradead.org>
References: <20260910-unique-ref-v21-0-e83257373062@kernel.org>
 <20260910-unique-ref-v21-9-e83257373062@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910-unique-ref-v21-9-e83257373062@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C8B1A120008
X-Stat-Signature: tttc8xriprih4h36piqpfqb65crchqmz
X-HE-Tag: 1789269111-890424
X-HE-Meta: U2FsdGVkX1/xVvNKARJO90cFAyl2tgW1JzHGn7Q96EoGHzh2vCBS1AYoNaPry0qM760MMDKLdpolMlWQtZXaMLAos1oxl8KJQlunPFC0TZRtRsqjdZQIf0HrFPo1pv7rGpx7av9IPwi8hk68nSWQvquY5OLXOMUByFs4hzl/uBZ6qNdCP2/D5PVAaq+OgilEn7gPwJoxOk1Zy1YdiTb61613Ull0TPvo5IPjD9O9WVInM4iADt4Xj5W6XFxOKn9Guk1q71jiuz4SvAdchmH42CVrr1gHCqByt6r3sEyDv3lV/nAKkJLp8Iee90vnhzc8MDBnPHL6vOJiwuMngQ1M1Yy0ZMnu7sDzfeRYmn2nf56zFJSliUVQe2LPNmWZUUUtApyHlqDPiz9ACKVB+Xs7auCga8y9q9re9XiqkXJKfjMg7sPKcUVzxOWr6nkUR+xQWMLDggVupul7m7Ne8nNDZlZ8OwPSADtS6ab7fHJP3295ZwZS/abTA6iuaZDui3CbrmVSuauwmBSOXbG8x1aEqtMBNp2PciApqyPw+feAJZN55vsxC+KqC5lPE9p4Yg8sQQKybGKhpC94GKluHvXJqnleJM/OhqZXe6C2WMl2ihZjiScq3ruYk4PyVKnekHaXujJh/YEnoI+zHyGHR06B7qoaNhzBBRRETN1ATrf4lC3ZljrM3+FW81/UfH5uhRpnfBshS+VZW714+BkGNE+mw8NDAVkUUp7OF7eBTglkvH4jUFIjCNIxj9ozYcTH6vVgt/UMZpjVyeUbD2AO167pklUWBY0HieOzRouR6VYNdclmmrqbv9wayWSuBl6mFiqECgodaGI7Y3ss/8E3IPIfOdVO7qkLE7LwVqSAePS/pZXWvq38RP9+XSJYrSQ+w9hnEhggbQguD1mbnrfDJzhFbSUkEVlZNW9i9NoKSq6ID8Hlbg6TSKDg+c4kQgjaF6JHvZwd5bOCSMIfVoB80So
 zwdxdhTg
 UXcEffQNT+uEV7zb4ReY7n8HtuyRvoFw2YUAHEded91yYF5lW3vC4RuwCaS5OazeGjnxDdfauXmuKI+O2j+Dd1pMVPeS4QoecfGI/VXBwQkaLOrkBohOBearXlJDAvTAjZzQ2UwlcY2qkLIT83+EKD8sERDuxCMOwSWDYOd+y4KmxE/vbQiW+UZbk3s0E1M/I0fUv+8kOCBFykZz8HMN0t/VZ08+Z8sI640pkUI2uAySu2XBl/lV4tsuAZODZW9XI8FFI1Ms0j4BXVx8zrUd8BbsjMSnKFtux2JNX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 11:00:13AM +0200, Andreas Hindborg wrote:
> `ExclusivePage` wraps a regular page but adds an invariant that the
> page data area does not incur data races. This means `ExclusivePage`
> cannot be mapped to user space or shared with devices, and it
> becomes simpler to directly reference the contents of the page.
> 
> Since `Page` implements `AlwaysRefCounted`, handing out a `&Page`
> from an `ExclusivePage` would allow safe code to obtain an
> `ARef<Page>` to the page and break the aliasing invariant of
> `ExclusivePage`. Thus, do not implement `Deref<Target = Page>` for
> `ExclusivePage`.

Given this description, I wonder if this shouldn't be implemented by
alloc_frozen_pages() / free_frozen_pages().  We'ree certainly trying
to move the C parts of the kernel away from thinking that pages have a
refcount (folios have a refcount; otheer memdescs may or may not have
a refcount).  Do your intended users of this actually have a need for a
refcount?

> +++ b/rust/kernel/page.rs
> @@ -17,7 +17,11 @@
>          AlwaysRefCounted,
>          RefCounted, //
>      },
> -    types::Opaque,
> +    types::{
> +        Opaque,
> +        Ownable,
> +        Owned, //
> +    },

While I'm asking stupid questions, what's the significance of the //
after Owned?  I see it after RefCounted too.


