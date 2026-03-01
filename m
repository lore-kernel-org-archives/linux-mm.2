Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48EAEFD0078
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 19:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06BEC6B00B9; Sun,  1 Mar 2026 14:59:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31C66B00C0; Sun,  1 Mar 2026 14:59:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D686B00C1; Sun,  1 Mar 2026 14:59:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1C686B00B9
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 14:59:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4902DC253B
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 19:59:54 +0000 (UTC)
X-FDA: 84498559908.18.DE6691E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id AF651A0005
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 19:59:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bu1SLlPE;
	spf=pass (imf15.hostedemail.com: domain of lossin@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=lossin@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772395192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c7Lf0pg//jvb+3j7ibNw1PDnDJENzEb1R7UG7EkUWBo=;
	b=JmzqlWoiNK9P45KEORE2L7aP2dERFwJluC/AKi4eF9CghqGSIzaUefdm9CYIt8Er3Pn+i8
	2n7TRFOi4dhmQURYhe7LDz0Gk4rSdLl43izHEnNQHpJrn2D9U4r67TjivcxFjEDMt1wAb+
	nOqBYAlG7cXl/XuLXThayrkqyn6ocOU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772395192; a=rsa-sha256;
	cv=none;
	b=Pjdy/LDV9xbjGkR5jsiJc1d61kJBgxKkHyrlmZ0V5yb4YQYPB9RydvwvkNdXFS+zGAa+1m
	o+6953HGx8pUk3JtjfuiEKsT2gWMAjWbeFb2VlYWLqQkf6ZqNQf7bOidYbY0e8itRwZgDY
	fnjZ83adVCM+woRImDstD1cUOdiQoVk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bu1SLlPE;
	spf=pass (imf15.hostedemail.com: domain of lossin@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=lossin@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CAE7360008;
	Sun,  1 Mar 2026 19:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A73C116C6;
	Sun,  1 Mar 2026 19:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772395191;
	bh=c7Lf0pg//jvb+3j7ibNw1PDnDJENzEb1R7UG7EkUWBo=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=Bu1SLlPExanZzJBk/3KZ/KJEQNSweZ38bl1tkZtVFxhnq0oJlUvJegoCFn4bRC5Uz
	 8JDJaAmHXk5dhybtqUAV/W3yC/U52oInYwdv69V1GK+nnTYouG94WW/x7Xw8lxDOZW
	 NLQl7cIpj6VKUwwEwSu3f2J+rajFU7zgPKfetnELrePj1Nlrv58tgQA8w7IEJTypc8
	 IkJhPuewEYoACBnMZr2n7CuzKUSdrgsOeKZ16KgdW5hPuSMIlSi+farv4EpkH6PCj9
	 YYCQdHxF61C67tz1eYO2FCji1QDBfhLkU34F5H3EpcsZm3OxSXvAcfEcGrmjaGYIaG
	 zXQ1ANgq2n3QQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 01 Mar 2026 20:59:41 +0100
Message-Id: <DGRPNLWTEQJG.27A17T7HREAF4@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <rust-for-linux@vger.kernel.org>,
 <linux-block@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-pm@vger.kernel.org>,
 <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v16 01/10] rust: alloc: add `KBox::into_nonnull`
From: "Benno Lossin" <lossin@kernel.org>
To: "Gary Guo" <gary@garyguo.net>, "Andreas Hindborg"
 <a.hindborg@kernel.org>, "Miguel Ojeda" <ojeda@kernel.org>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Alice Ryhl"
 <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, "Dave Ertman" <david.m.ertman@intel.com>,
 "Ira Weiny" <ira.weiny@intel.com>, "Leon Romanovsky" <leon@kernel.org>,
 "Paul Moore" <paul@paul-moore.com>, "Serge Hallyn" <sergeh@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, "David Airlie"
 <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Jan
 Kara" <jack@suse.cz>, "Igor Korotin" <igor.korotin.linux@gmail.com>,
 "Daniel Almeida" <daniel.almeida@collabora.com>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Viresh Kumar" <vireshk@kernel.org>, "Nishanth Menon" <nm@ti.com>, "Stephen
 Boyd" <sboyd@kernel.org>, "Bjorn Helgaas" <bhelgaas@google.com>,
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, "Boqun
 Feng" <boqun@kernel.org>, "Vlastimil Babka" <vbabka@suse.cz>, "Uladzislau
 Rezki" <urezki@gmail.com>
X-Mailer: aerc 0.21.0
References: <20260224-unique-ref-v16-0-c21afcb118d3@kernel.org>
 <20260224-unique-ref-v16-1-c21afcb118d3@kernel.org>
 <eeDADnWQGSX9PG7jNOEyh9Z-iXlTEy6eK8CZ-KE7UWlWo-TJy15t_R1SkLj-Zway00qMRKkb0xBdxADLH766dA==@protonmail.internalid> <DGRHAEM7OFBD.27RUUCHCRHI6K@garyguo.net> <87ldgbbjal.fsf@t14s.mail-host-address-is-not-set> <DGROXQD756OU.T2CRAPKA2HCB@garyguo.net>
In-Reply-To: <DGROXQD756OU.T2CRAPKA2HCB@garyguo.net>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AF651A0005
X-Stat-Signature: ube5fjwpx5f1s44kzkub68zmf9w4mfk9
X-Rspam-User: 
X-HE-Tag: 1772395192-333480
X-HE-Meta: U2FsdGVkX1/BdzzCJXQr8kYCM48Fv01GM0HvB63lRKR3+NTHotBlzjI/nX1ErynbPEWihJDtQJ0VQCtRP8GlEaxgvk7caA9tFm+/xrjawtleMbZoOiaZk1EsLRaTtC/3yl57G7pyLriW4OZU1HVQv/bXN38Fp0/0qxddBZ6njvETN5mgvYIfV/R05SG/VyS78E/7bqYSWxr0HOd9F1Onfa80DjGjhgvaBiNMvHhG4EBXivs6vygSL0qah8DenoQzGH3A3IGq8r+TBolEIdZhYZe0t06m05CJnmBjO4Y2evKIJdCc5+STQVVs7rGomjYjHBYYkU69aZFqWZN39oVNaJODPW8zrU43ZxxKaarhapjT4v0woWWRM17gBKT5opDzdosX2y/ZxBQBnXrHCtn64LHiU4nP3MuUYp62uLg2sTomgtUr48DZdq3v4Cg5MgzStZr3iwZnMGtSh+aiFy5S8Nxay9GvMVZ3NMeSo7HYt8tqBXv0PV4xYXRefK+47tdG/JFDqZN62a9bzeg4cYbvH6pb98dpVc9JvNr9sqL925S7bDAqEZ7KLW0IS8WkCLmRCvEuvBw7yyrPNycKTVe/EKClw+GVe39idkh0z1kBZQ/JErSvrPmyP/Gxaa4uoIYb5aZT6WJyhlWJCOSCCN3G5r7cYdVOTPIWt7UUQlJOLSRvNiwTooSEeoLK/4g37qZMdotDxc6vBiPjyzkSD0AnL1APSta4laioWk56K8ZdXmaCTSSjzocUINTxIlz1tAULstsb0tyDSB9yypnvjdvGBeoJKwqmJU78F1Rd/l6o+hDpKk9VJUCx2H+3zK+rV8ANJe/7WGaP5mu0ZCMlvlEMXv1TkRhaVA8sYIvBidR1VK+nRpow+UsYeGjQ1VrKpDabSW2aaT5IOQUd6ScJJFhMQWVQpOpY+lqtXWgYup6I8lz7b19X5cwk+b8vJ5CihoJw52+AvcQbBHEtb9F6tvm
 pjjtwX5f
 J2x2e5XIIaxvHS5jlcKwjMnzc0TJmQRi3pBzs/REOLPJHaPtD+moJe3SPNUO8V/MvTQ3f2oRdZWbAXUXqfyQ6fMaTuLn/rUSIGRZp41KVZ8JoHfXYYrW44DbcfYv4Hf6GbMWsdff4Xuw7bjI8Sb4bOWguCe8DC4BkhZefYGAcygPoZaRjUprQQ7rIf8P3pAbS/fLBGvtzBpNTssFvQsJWpMXodoyWJ2uf1E6eMo2GozeegmqFh76gaBQPK8/5PIeD0k4dAF2sKOy7rubbBlvWVthiigX/v0bakbBjcNRw8DqZNoh2vNiR0zRmo1X5uHnvYgdLKM+VjoYmZ1r/QSm/B81kWH1U52emt5sd7y1tgb+uRPVqg0AsBdTMPIGZ5uSNhrg88qdGCkM6YkxFKhdhSVtV7wY9dfmbMLjl+MMiABq9aPM0RRtqb9sewMo6I4V/bqyC7RL5Dyga+hHF4fvVPS00qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Mar 1, 2026 at 8:25 PM CET, Gary Guo wrote:
> `#[inline]` is a hint to make it more likely for compilers to inline. Wit=
hout
> them, you're relying on compiler heurstics only. There're cases (especial=
ly with
> abstractions) where the function may look complex as it contains lots of
> function calls (so compiler heurstics avoid inlining them), but they're a=
ll
> zero-cost abstractions so eventually things get optimized away.
>
> For non-generic functions, there is additional issue where only very smal=
l
> functions get automatically inlined, otherwise a single copy is generated=
 at the
> defining crate and compiler run on a dependant crate has no chance to eve=
n peek
> what's in the function.
>
> If you know a function should be inlined, it's better to just mark them a=
s such,
> so there're no surprises.

Should we set clippy::missing_inline_in_public_items [1] to "warn"?

[1]: https://rust-lang.github.io/rust-clippy/master/index.html?search=3Dmis=
sing_inline_in_public_items

Cheers,
Benno

