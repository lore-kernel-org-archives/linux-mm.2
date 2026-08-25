Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44EACC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABF2E6B00B6; Tue, 25 Aug 2026 09:21:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48C66B00B8; Tue, 25 Aug 2026 09:21:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 938036B00B9; Tue, 25 Aug 2026 09:21:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 73B6B6B00B6
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:21:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A084C0410
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:21:02 +0000 (UTC)
X-FDA: 85139852364.17.E2E2F28
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7D061100004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:21:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Sng6iSCk;
	spf=pass (imf14.hostedemail.com: domain of 3upaNagkKCHkXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3upaNagkKCHkXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787664060;
	b=49i+PtE6vdYx6uuAW9IFQFd2DSCETDrHrBmSJ3MvS8foL3k5XfNvOs1T3Ij5xhh4Wofb6B
	pY8w0l2lGgiE0pHvZ4GJPNtduHv+eJgLlQzL9UWUoBF/K+8Tf7ScxR7+SUe9jA71OeVWq1
	Up1Zzf2V/6hTYorC1ERYweA309kLroI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Sng6iSCk;
	spf=pass (imf14.hostedemail.com: domain of 3upaNagkKCHkXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3upaNagkKCHkXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787664060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/wDF0hN/FW6BAXrcHvW79QxhTrkNJERnJhXR31M87d4=;
	b=yQ7GVnM0D1lS/crcuGr3DsYs32GzZDq1i4rSkcuYN+ToWEDA0v4XrSp/b/x+1Y4t8uqNwJ
	jgSiHv0s8MHZp7u9K0gf5vWlyjYN11hrDg7Xv48kF8Dtuytu5lErm0SxsKx/V35YjTmORV
	80mftjMZUL7BcbT53o1LmfKwTnIPDQw=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49808ea1b64so6536285e9.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787664059; x=1788268859; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/wDF0hN/FW6BAXrcHvW79QxhTrkNJERnJhXR31M87d4=;
        b=Sng6iSCk9S0X8Uzl9/sk5atc5atOOeYDkVeoBd3vSqnYW8n5X3eoUxK7FiwmLJ2zho
         1mWndRpmALwqUIHjrdng+BtExqNcmCdi1motI+e7ex5/RpHSUfPSuI1K8dkwvWgQF+IV
         Mg2BrTX/JpsR9s9dQKBEKbItzLaXF6t/F86Bpb3q+yxm47ujZaO33+8ji5u6STiEV7XL
         E1cstkLH2XA7mi66wnPujIOHQjQrsOxk/MX18tI9JME58xvF5ss2v/nE+Fgjl7KqeLTr
         GlxSn1EYA66TLWpTZTOGnmQ6mkF4nOPKWhdyYKIpogmjInz1uSRpw7dcZcJnByPIHSAG
         hSmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787664059; x=1788268859;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/wDF0hN/FW6BAXrcHvW79QxhTrkNJERnJhXR31M87d4=;
        b=HX2QV/RqvGs86AzstMEN4E+6DautaPzwDp5mm6FoQ+jhTDwpIPfNKtMcQRAZwMwIgE
         Aq1lkntEuQq0cmQ7u90xDH18oPogJJ+LajJz5GKTYc4xfMULhBgieveZRpaRmsk61IB5
         fpC0Je7+I88Nu/Rttdsaw9UlXkUFdXo2fcrvHFSAs6EnOn7op9CIztO4r6H72ccv52c4
         0zz3UfqJEyl9/aFTN5+HDBdjKRivJMoytF1GR0qEsCavQYEkT5qof1y6N/fB8w/EghhX
         y6TQMiBg/J5mdUgntRz9sfzyYcy9Cka8C/G9N34h6gUBD8H8aagAjpttVXhnpI6IAW4J
         yJng==
X-Forwarded-Encrypted: i=1; AHgh+Rp6o6kMCvDewGwPQ56lhmTZI3H8wrQbYvUqgAVRuHCrXzlv3tMjozvcGErH9y08LpHAJkidvWwfuA==@kvack.org
X-Gm-Message-State: AFuF++nRfwNlHLHXR0ZLalJz3sV3YtTwRS94gwD8rUHeOKF+3lxG+tve
	AZNoUr3kihXq/DvKi9kt7IbeNDsJ4rtSfORDX3Gs+XAQb+DP0+zcN45WOBhHliSl5sX3ugV6fRL
	XAjBZCq1vz9KZ5qfZog==
X-Received: from wmjs24.prod.google.com ([2002:a7b:c398:0:b0:499:9f79:18de])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f89:b0:493:f783:c46a with SMTP id 5b1f17b1804b1-499d63308fbmr60648795e9.6.1787664058484;
 Tue, 25 Aug 2026 06:20:58 -0700 (PDT)
Date: Tue, 25 Aug 2026 13:20:57 +0000
In-Reply-To: <20260824-unique-ref-v20-4-490735672187@kernel.org>
Mime-Version: 1.0
References: <20260824-unique-ref-v20-0-490735672187@kernel.org> <20260824-unique-ref-v20-4-490735672187@kernel.org>
Message-ID: <ao2WubjLtDuHvRzx@google.com>
Subject: Re: [PATCH v20 4/8] rust: page: convert to `Ownable`'
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	"Onur =?utf-8?B?w5Z6a2Fu?=" <work@onurozkan.dev>, Lyude Paul <lyude@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Arve =?utf-8?B?SGrDuG5uZXbDpWc=?=" <arve@android.com>, Todd Kjos <tkjos@android.com>, 
	Christian Brauner <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Dave Ertman <david.m.ertman@intel.com>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
	Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	"Krzysztof =?utf-8?Q?Wilczy=C5=84ski?=" <kwilczynski@kernel.org>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	Michal Wilczynski <m.wilczynski@samsung.com>, Ira Weiny <iweiny@kernel.org>, 
	Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev, 
	linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
	linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-pwm@vger.kernel.org, linux-usb@vger.kernel.org, 
	Asahi Lina <lina+kernel@asahilina.net>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 7D061100004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: p3bjgbh3uekf8rsgd57bk5wn4jxeebud
X-HE-Tag: 1787664060-542104
X-HE-Meta: U2FsdGVkX1+AJ6JDJBV4x4EaF5TmFB9gq6+0wsdixg6Dc6/saEGvnhsYGW8AlOrZ4dUkLpVfv0GK92I8f3/rZF0kotnv0XQ7knlVXsaVNNbVwpCtbroLHRsG0r/PVJyQ/Y9UDK5vBxoSCAcq7RIUt1bei0QpTZeiY+oYh8tYWaqNVEEp3/qjq1HFdg6ZYOC7eRLuIwkM2YSNQirTgZdQmD7BAZstv4Mzn+4saUINMmJ5LF8ruvDh+elOrZRlspU1YksV2+bOEaYdW+jbfca5NCPKv6Re10Jt48+T+5/YXzVHZfummIp7eY8KpL6oeQHIV1BJ2NSR2lr6hTSiyT63Pybz20jKNdQNAcSmi9CR8Voc+eJG4vnN3DoZBC5a2p2DjtwWcyIG1wWYywk8j48JeMK5LbYFqoqQjGb3CHu5hYyaNIY5ftci3ntsAGqWuIn8J3H2cwRor7i1x/SyBlmdKms0oX/DQ8SFj1XVddYAupZgQxqZOzDHICA/Ns4aZdNhwl6hwi2rRsYYf46Vy0rClLmjG0W24wU7kqw5LqKnIzlkN5v/Zw6+B8eDNZuRYcMYpWEcK/lWgHp4fpEKf9svDeIoBl0znXIfHvIUGddlmQPaJ59REP3OaSETwu/qdf4uXbVB0XdbrrPH3NwQyIMgi0bOEd+GFNzMA/CrKH9hWDow6XVaZ7ICjz0YqKw+s+WArSWOTJASsnszym0zvv81p87/8BAYKXuxI6A9MjwklXjCbcvohOS/UCPpwujkNNInlLZi73/YSNlq/4/as03gRxkpV/VcmswDf2M4VaibsMBcj5JGe+MVEfTtskupSwgdDCtZAuH0W/1QI5KcB/jkAiFo2E7oTY36O+93LjVlatW8ZJdszw0F4LOUtt359sdeXrUe5/r3JSD0hQjgf1PiTgiTPcV0UKo1b4HzBE9sP8iAYxZ0iWuH/Ts2y83zlaxNdHq7M+V+C5ONrLCME6r
 B5SgYCax
 bg6eruy+9A6+yDY+mk0VN9sXzLHLni5Zc0cvvcrEmIuSeiGmIiUQQRCmxd4Wg97qE/KtaXBGFAFQ559kRMG1Z36Iw0afQspBz32W1fcHvtdQxDRHy3f+bsNY1jwxp2glkLw0hucJVkVqFd4qXOQVkRF7I0zLfpd3Q0p6lVd8+jfDKN8SoC0IOmlXDzFEuw78WwV8m6Lf7af1astMN9w7epNN3VTzAECCrqdBn7bSjrzdcwjrGUuB6kJ2P9vG3BZU2dQU5kScn6G4FpOeIyC5gzl6ulBARdRqVFUlyOM/lLbBoGbMY/LD9cV+g8cG3nzPogxpu2d8H7h2bIXeLPT/tHIxAWx7k8vekkhN/Hijw2RjM5ZZfBK9H/7xuGs8nIyj37KgWiDWsx6IjR3A2KKEzF4DP3tPWZ8qQIayk2w2Ztg9PCIwqqSxOeQLZo8FbpGEyHvkQMq0mx7A3zks8uVbJMPohgzpmXr4ph9eMqFHRFnptnT7/+kYcYH8PzSxdMGbFWs5AR2wP010+jEgE6z3MajNM+E1O+vfB2AnyA4saGmVK3Lalla3HvVchZm46hVpiDMdWYfcfbVgZU/tWzDjeMyZTXhNS2xGQiO03uM1j+diktGBiOKc07fIBrL19gPXnQK2rsZRfgUEmL849B3b2rYFc3ZMnvK6OuUgiTY6X+AunGBHMfXF9aakpuLQG6d/13m4it7IS0Bm73mDQHEKBNkqga/2wY7oseEH0IcckL6hP4WPW4rRy1vo9vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 01:17:56PM +0200, Andreas Hindborg wrote:
> +        // SAFETY: We just successfully allocated a page, so we now have ownership of the newly
> +        // allocated page. We transfer that ownership to the new `Owned<Page>` object.
> +        // Since `Page` is transparent, we can cast the pointer directly.
> +        Ok(unsafe { Owned::from_raw(page.cast()) })

This doesn't satisfy the safety requirements of Owned::from_raw()
because the page may be used with vm_insert_page(), which increments its
refcount and causes it to be shared the vma system, and this occurs
before Page::release() is called.

Alice

