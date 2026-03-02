Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA610E9B35B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 10:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B4F86B0005; Mon,  2 Mar 2026 05:33:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 362686B0089; Mon,  2 Mar 2026 05:33:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243AC6B008A; Mon,  2 Mar 2026 05:33:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 158BF6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:33:50 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A02561B8FD7
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:33:49 +0000 (UTC)
X-FDA: 84500762178.19.AE42385
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id D9AC320007
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:33:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JBI3nG8R;
	spf=pass (imf13.hostedemail.com: domain of 3iWelaQkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3iWelaQkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772447628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EnMgJMcaQgCDj7i00Uawlj/G1rJtXPwe1sCLwvhoFHI=;
	b=JlwdViBppmbnsOkGiygbp2fw+5wDnL02ljtFpSUy0g3yv17g2wZGFtJLb700W07SBeinC/
	MnQOs/ZnG52PHcBMCFtyKzhwe2WyLtGD+JOzJQ6IPsduUxBN1Geg/VD4yty5c/olEkjJqz
	qPZ/AQnI5fXoktJMFerKv3QIlSBcl1k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772447628; a=rsa-sha256;
	cv=none;
	b=TsDh9Igr0N5jaubV3Fz/TLoCbRQC+3iS+T23wI24Xprw1kVoaPzGbmNCpTKDNyhwFUcgfJ
	lTI2rdimMz6RZLCyDkMMT9c7YWZQxUnPn+27hV8ayJYYG38gpL+4A/2F0kbGzWzqM86ly2
	Ibj1RrTxgpvuNnLwn85ALZEdKWUkiXk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JBI3nG8R;
	spf=pass (imf13.hostedemail.com: domain of 3iWelaQkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3iWelaQkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48378c4a79fso36135635e9.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 02:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772447626; x=1773052426; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EnMgJMcaQgCDj7i00Uawlj/G1rJtXPwe1sCLwvhoFHI=;
        b=JBI3nG8RY5npVMyrKq8GbRr6swqR0X3xfWnP/sgfzetmH9CiaGGayJnFvTNF93yK4H
         jyHtkNqyIxhgtH55wlqGq0Pg1iePlpYhisoe9vcoNwq9tVpyUL4CdVSQ7V5SKHls8tEv
         jcgp+7fdIOQUZlVh4KYQCtggZhhXRfGjGjIGZLtle9V9vTdPdKyd+kHy/4Pdjb2xecKA
         IdDG2CQm0aOKhgvzdS0LdNxqy59AKdEcQF6baIiL5EV4TRc1foxcf5XcKmLzbc0dLY9F
         FXlJjvOkeMqGo8iWydTolLr/zJVXf8+iZlz3sBDNmXnbtiF685ZybqOLk5/rnK3ugRBo
         0eUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772447626; x=1773052426;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EnMgJMcaQgCDj7i00Uawlj/G1rJtXPwe1sCLwvhoFHI=;
        b=sfFfQ1GJ12qh7w7NzweeH1PhDnrLjG8qqKTfE6TL1rC9bmasvKwpTSLZLbL+pBStBH
         7PLa0BSpP9HLv3Diw0Be8rDXKm5QK8n5DwWbP7hJ5AJWKJh124NFEf0vrddbiGJYitCQ
         /3ALSc42QVIny2HFnLGPUbdcZbRCWrf79iJFSyYCbZX3wHoR2T02AQ4PQ8Rv0mQkdFUH
         +6gNq5V7gHTfZG92yW5ts9NF51l+dK6rDmWld2cMRu3Ruyp63I/lltNRsyZzvGZViA0N
         /PQEc/2F75FYI2agCyfmuThL1KuQe8bwj1eaPggeEIkqT/c1JIQBZPIFc5q7MNS8N9mz
         J0zA==
X-Forwarded-Encrypted: i=1; AJvYcCXQt8bqldmf85bD2yUt22cBYlitucEBR7iX9khJcG6C4S8yZGbWGUCdnGHhQKvK0DtZOvcSWTVTtA==@kvack.org
X-Gm-Message-State: AOJu0Yz2HROO7dF3VL0yhoikh+G2YOsOeHo5JGKVtOK1uXTKOE7mjaPc
	CeZt+A5mYQ/1U2u9AWU7NZI41+VUvi1Px4gmOcau0oRYJGy6k0vywRiU+SJ0w4BX+VzkoW7AmIo
	atujnQdBNKZkcRPtaCA==
X-Received: from wmdd1.prod.google.com ([2002:a05:600c:a201:b0:480:3227:a124])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6383:b0:47d:3ead:7440 with SMTP id 5b1f17b1804b1-483c9bdb683mr186031315e9.32.1772447625915;
 Mon, 02 Mar 2026 02:33:45 -0800 (PST)
Date: Mon, 2 Mar 2026 10:33:45 +0000
In-Reply-To: <f2f3a8a1-3dbf-4ef9-a89a-a6ec20791d1c@kernel.org>
Mime-Version: 1.0
References: <20260227200848.114019-1-david@kernel.org> <20260227200848.114019-3-david@kernel.org>
 <aaLh2BxSgC9Jl5iS@google.com> <8a27e9ac-2025-4724-a46d-0a7c90894ba7@kernel.org>
 <aaVf5gv4XjV6Ddt-@google.com> <f2f3a8a1-3dbf-4ef9-a89a-a6ec20791d1c@kernel.org>
Message-ID: <aaVnifbdxKhBddQp@google.com>
Subject: Re: [PATCH v1 02/16] mm/memory: remove "zap_details" parameter from zap_page_range_single()
From: Alice Ryhl <aliceryhl@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
	"linux-mm @ kvack . org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Arve =?utf-8?B?SGrDuG5uZXbDpWc=?=" <arve@android.com>, Todd Kjos <tkjos@android.com>, 
	Christian Brauner <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Dimitri Sivanich <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D9AC320007
X-Stat-Signature: mjzzgxb3xohgtm8w49bh8d44jkheg391
X-Rspam-User: 
X-HE-Tag: 1772447627-606796
X-HE-Meta: U2FsdGVkX19tCFVdSr97fnrnD/Eksr+Y5BogSA3t3jDvhsvUrlWw5r3GskSQ64ZQ5ZI0/3LER+pYQKbrXVZDZXEeQD8JYD0ukUq+6q3gDtd0Apxk50mhc0SePh4M6fVt0UkSxcLqv5Hu3iAQF8lQmFqmiSu0MUNlDbfTTnFOjNPBzZu1q3J85zKbREEXHheZLvDlBYqU17jmtHtRgp123Kukc1sV8xX7WkL1NulNmr3SHhLMcw+0XdVWQdqR8S/2dbrU62bqrKduxRrtxi3S2r38HLzbMMZ4c8RSWz2YNqb9SFgLM+E07uwBWW+mcZCB2S+1OQkH8Z/8pac19fVNeJhZhRuKEQSPj3As+vE6+4J/V8ILFkTwXGyIt+ekBImOjx38eih/4B/8POfN2dz428KEBYrjq1brgi8IM7S6OBc9N5xBw+/WOhOhDPrZ+Lrh3+F9eQlbw/oOO++dej8ocmKpRBKJD+hIusfCsBQFef/VNwtUAeIsA3xcgM9CIUqr/XXeW6buV2nxxsvAW+o+r4vSL12BqnWzdA1OV/NQLxrlw5CDt6291U6Zq/XtQPtpuPZ55mQmeSBOdsm2kciIQsKdtWHZue09lAtaYg8eqmJ/CwHGx3BU7DQn+t1IWdLKP0piGQwBT5iSvcI5aNI9oQQ6MaLUPY2dG5FxdWBdcqN4wwOwnygvwAaqBfD9WLnt94rJqsCFhySo7zr9OMpgnaGIzAzNdF4rgyONLT04d8VCLBE3hy4m/xAZAHBo+WIzmoHN0B1Q9BgvlQZix1pe3VwEpn46NSbNkcGTf2sczQjyV8z4YN9dVTFqPr69DkmAV1yeVfkq3761nWECAX1p1XnntdVB/zGRAeMh/k3RioYPdAgQyx/nvWyvlsheRxlasPboyV/F8DrJnp0j7qCfx/CcDIyfh8d+uRYqlj4Xt37vUdeeBRmgDdwqFB1hs4jmtPiuwpktSFTljmMoNDY
 Lo4Q5hgP
 E0+vg+rFfGwGiuOouJB8U17aBAXZo1nf3eWrvxF1MUeW4vXlZBEml2QSmOeU9RkkLIuZ0tlJw00kfxNhLFmHueWe5H81PBRcgw0XZuiTopcwIfzFCZhKV1WihVlyTbS48zYgRtEiJs9wLJ8nrkz7/Cu7Dz+cYgfG6Na4+ONvhMfCc3etpUvjEyvLuarApexpPvyvj0qvfkLUp//2SH6gtKRsZMmUcJtUoUf9U20cxph5FxSG8Y98VVJ4omjrk+EdW6LyRskAi06nIYb7AQvMSOYILkgKWTdftsf0ztwoTGwePVrkZ7akQNt1XYQX+Lffrs7r4/9OYkcEj/4IGjl87ckZHSgzeBCvA4X/pWOS1NCeUF92y7/HS3aNw+9qHEW67bNgnADzjb9komN2LYxxeqOY0qsx6ayrQbAC7zUV9Q1cYciztpKOx74gSm9FUqj4FvmI0FriANJ8Dz3MdKD0KjKVKE5PyOGzVsBxzkKnPyfeWSGb1EfQTEqveiHFsT8GB/frgaSZotAOApuQJ0sksaW/Q6rzIlPsn6GfCL848itd7br2AN/Yq69YKwdAFJ85L77U4QsPuBAiiLu4qUS3z2cGA8eol62NcdZA5oUeOklJYqd7T4hXlYrnB3cG1eK8IS1qOb76dfv3e2S3CtVsss378X6DKpWuboDeE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 11:27:40AM +0100, David Hildenbrand (Arm) wrote:
> On 3/2/26 11:01, Alice Ryhl wrote:
> > On Mon, Mar 02, 2026 at 09:18:45AM +0100, David Hildenbrand (Arm) wrote:
> >> On 2/28/26 13:38, Alice Ryhl wrote:
> >>>
> >>>
> >>> Please run rustfmt on Rust changes. Here, rustfmt leads to this being
> >>> formatted on a single line:
> >>
> >> Having to run tooling I don't even have installed when removing a single
> >> function parameter; did not expect that :)
> > 
> > Well, rustfmt comes with the compiler, and it would be ideal to build
> > test changes before sending them :)
> 
> At least on Ubuntu on my notebook where I do most of the coding+patch
> submissions it's a separate package?
> 
> I do all my builds on a different (more powerful) machine where the
> whole rust machinery's in place. Further, build bots that run on my
> private branches did not report any issues.

There are some build bots that check for rustfmt, though not all of
them.

> > But no worries, I took care of testing it. Thanks for taking the time to
> > update the Rust code as well.
> 
> I just did an allyesconfig and it does not report any warnings.
> 
> So apparently, rustfmt problems not result in the compiler complaining?
> 
> Or something else is off here that rust/kernel/mm/virt.rs won't get
> compiled on my machine, even with allyesconfig. I can definitely see
> some RUSTC stuff happening in the logs, like
> 
> 	RUSTC L rust/kernel.o
> 
> Thanks for the review and for pointing out rustfmt!

Similar to kerneldoc and other similar targets, formatting isn't checked
in the normal build, but make can be invoked on the rustfmtcheck target
to check it.

Alice

