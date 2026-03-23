Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9D38F4612E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:39:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B4F6B0005; Mon, 23 Mar 2026 10:39:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC016B0088; Mon, 23 Mar 2026 10:39:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1C16B0089; Mon, 23 Mar 2026 10:39:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F20706B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:39:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E456140B95
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:39:19 +0000 (UTC)
X-FDA: 84577585638.03.5CEF081
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9F9442000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:39:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aBgzYxVq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3k1DBaQkKCI4s30uw9Gz3y66y3w.u64305CF-442Dsu2.69y@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3k1DBaQkKCI4s30uw9Gz3y66y3w.u64305CF-442Dsu2.69y@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774276757; a=rsa-sha256;
	cv=none;
	b=CmJ5lS8Dt/R0untSS4sU3C14/tjFPBabt67JCxi0O+y7hi9fbc3UmISPEmK00gCHpaK+q+
	gxgkyxBCt8JI7AnYcBbPfa+YQbUf2dLhQN9PzHHRF6qcFpexLRowXpIhTQZRq3HYq4QA6t
	7+MO8OKU0iBCzPjc5VoEM8ITaNY5rBI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aBgzYxVq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3k1DBaQkKCI4s30uw9Gz3y66y3w.u64305CF-442Dsu2.69y@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3k1DBaQkKCI4s30uw9Gz3y66y3w.u64305CF-442Dsu2.69y@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774276757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ow2cYCMn5EXbkFbtWklLmiMt9RKP3mI6kxfKs0fin8E=;
	b=5LL5G7/HK/3ZALNaqMknDaU9QAv5hGtSfwi7gAWGZw82cq5zA4mPfbrs6Lc57KNcoOvjSj
	Ofo8NGraXzkdpDCmvO4sRk8Cc9alKcXOTmuZtoTlcPx1BC1K02HEHbNWMUwfJPc8F5NX6h
	jlidCvzQaNatGvDRBrzZ7LOSUDV28zA=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4836abfc742so19629195e9.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774276756; x=1774881556; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ow2cYCMn5EXbkFbtWklLmiMt9RKP3mI6kxfKs0fin8E=;
        b=aBgzYxVqJNj4FC/KZhZmFfzNs1c9JWaOnAmS/IzF8lBeB5ix8tC8/eF1hb02G01IBY
         kGWKodgYCgspso1OB8IRYeP4qWAk5I6mUeG8GNYF8vuilBYIv1agbXbj02u6pjmgVy8v
         UdKOVRik2+UkxIXWDf9x9+lkz5c/V+XLcg8VW0qCQYKIiXeVHK2hKK1+t0PincENi264
         e9YGyMYcKxlkY9MTVJCBhL/9zJBNQQ7IZT0nlpuyoXURbOPplDeqDPxcUs+d8V1A3dGw
         9eNBd2qrrhJNbGQm7XkPz8UAxmmdsLF11IluSxMzB0NJJd06P5tBCG05Wh/qeHgG0Hbt
         YXZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774276756; x=1774881556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ow2cYCMn5EXbkFbtWklLmiMt9RKP3mI6kxfKs0fin8E=;
        b=Oe0hE5f2s2Sc38R8OMC+2V6EvR4CXqOjCNhriVgnGxJRM360CvroH72f5UtiHPNKZc
         /fuh4Yjr8lHUVZEzq2T/2gJxnNSbK3hGIZpdlKBqByXB1nIgynkzlKp07C0G4eg6QORA
         cNVeyk/4e6deeLc5hlTCY+7610xwkls3vtauoQHXnIL1XZY/vuTfQ4DeNPO6mo8bpdQQ
         MTwLbI+8owBmlEQE95BlwK56yhoKMIOpAQctBVXNrfi3pQmsiVb7CxoGG0cSGSraft/H
         HO3bno1ujtReTmq/8Hkog/QvgvC25HB3nTpnn78zZdNcmXCh38hOQYdlDTQYFNhxIrlG
         2+tw==
X-Forwarded-Encrypted: i=1; AJvYcCWrNd3r0V2ExdfgBqEWKuXuhfEbvQMtRp13TzTLlOb6D5FjIoBut8emRN2NBHsFaog4ggBwT0RgfA==@kvack.org
X-Gm-Message-State: AOJu0Yzmso0bRlMNID3cctWKecK/6nwskdTUXquKZgCfaIgPttU8rosF
	KR2Y1vwlDQH5GMET4K7qN81Aemwv2GQc7FpK/dMQUdSaKRkPX8AHoZf+g8wd+6bR1AuUa1au69z
	au2xFLJmpnUxRAIM8Ug==
X-Received: from wmbej14.prod.google.com ([2002:a05:600c:3e8e:b0:486:fa53:8cfc])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a43:b0:486:fbd1:9dc0 with SMTP id 5b1f17b1804b1-486fee0d52fmr164091435e9.22.1774276755701;
 Mon, 23 Mar 2026 07:39:15 -0700 (PDT)
Date: Mon, 23 Mar 2026 14:39:14 +0000
In-Reply-To: <b5063e7e-9245-434e-9877-5ac7b45f4bc7@lunn.ch>
Mime-Version: 1.0
References: <20260322192159.88138-1-ojeda@kernel.org> <20260323000327.111235-1-ojeda@kernel.org>
 <96287f3a-d245-47cf-b7cb-f821451493d3@lunn.ch> <CANiq72nwSWVDRqm0Vap5j5X5k+Q-wq8okQ9d3KUgZt6M4CpW9g@mail.gmail.com>
 <65336ad0-ac37-416f-b6ae-e691e3e375ae@lunn.ch> <DHA6SE9EMEQF.1PKVHEG18I5FS@garyguo.net>
 <b5063e7e-9245-434e-9877-5ac7b45f4bc7@lunn.ch>
Message-ID: <acFQkuarr6bcOFwM@google.com>
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
From: Alice Ryhl <aliceryhl@google.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Gary Guo <gary@garyguo.net>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Miguel Ojeda <ojeda@kernel.org>, a.hindborg@kernel.org, acourbot@nvidia.com, 
	akpm@linux-foundation.org, anton.ivanov@cambridgegreys.com, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, dakr@kernel.org, 
	david@davidgow.net, johannes@sipsolutions.net, justinstitt@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-um@lists.infradead.org, linux@armlinux.org.uk, llvm@lists.linux.dev, 
	lossin@kernel.org, mark.rutland@arm.com, mmaurer@google.com, morbo@google.com, 
	nathan@kernel.org, nick.desaulniers+lkml@gmail.com, nicolas.schier@linux.dev, 
	nsc@kernel.org, peterz@infradead.org, richard@nod.at, 
	rust-for-linux@vger.kernel.org, tmgross@umich.edu, urezki@gmail.com, 
	will@kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 9F9442000E
X-Stat-Signature: sirtbdwp6un6kgc36zzs3ewacg1aow49
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774276757-69302
X-HE-Meta: U2FsdGVkX18IgV9jg1W8z7HAQCfp6hJPiEovi421ikj4UtTtjtvRk8wmhot56TQiUdtU0bqOxS8PxodQihRBtQ3BUdjIthciRiAGe0QfbPmtPcq79RJTDyPqdp1soAIM9ObWvHDf/FZsoM7FUSOsQaStcin5O3UmZZZ8Q2O/LyRDwsribNsqO3mPaVT8sZfd56BZvDNy96He7+Q10z025bInW+WGV1tfK0lYc1FupHUjclu1ejlleIvXvzL9F6+DKL6IqjSrgAYkrgJM6+vpPwSoQH4kS5lhvSjvkNLDbCjSUjCLfmua3/vYYJM1f6MqPaGv/+/mMdkLalV20awqvj4Uye7NMy8dz8Te17RnZfA3Cw1VnQ1Sumn0vGt9Al7upCD4s6GP8DikoC3qQ3q9HS7MXSVH5fLl/uKMToFbj9YUDsgFC223yJtyNXX+mr7ieWst9uifsZOV0gHrXx/kuHbR4f1l2iTr3OVlnN7lRQNHzBVPYHfeRDOzrXLsdJhHx0QA81u5DvBO7SLowVhSPvTcavqyG2ZvVKCu30YJ1Jk6DppbhGdpX1g2VEOnhXDO/Y0P628ZPRhzIy/OgeT+tTrxc0Ks00Oq26IbjICpTEVZu21gJ3qdvEj4aMOHGnrGUj9ScfVpRbOHkgChKsF5wWX4s/r07lly8SH/fiXdzz8KQofG5j9SuCy2DgUwbrXJWH1M+H6ncAcguzs8EEK3oO9NJrmDWshzCxVpmZEhSg4kCaoa33sp4tR/ILOLJe3koQDetB79r8lnf8F1oxPKG6+BlIK+J6L6A/+kbN2Kg8U0imMekDOCT04xGt49gUJPTVpDc1nGHbKmGiDmParR2oJV0yFk1OZv2qBA63MFUkrRHliiYVjTYUmhBlTCp/17Wl9APaaEbvFs2EBa7U0AJKzUNLUguN1rUNw1pxSG0IGkcAhtps00zDMRHcBLg2J4MtAm5wWP8b9dK2iIcX6
 6nqUTxFM
 YmdEA8q+kYJE8AGRY7k9w+FUC8LjVOUvYIaSQuDcYOhP4AS+ZBWavcXXo9dm1FZGvUewGEQc1Wd60DjiBKdqpmEcYYGbD3EIQVXUGvG1NjPvH3SsV5T6DlaPz/2VLOTVpVb/+lGhCSEIkrLsmVmHTHVroNiP72ErjI9AappIYxKrlRMInCis2DMY1ua6Lik5CXnP1wsQ8Hmh7NtcYAmW2Ywpze6hf5e19m1ng9l6LQiBT9i0oIQFl00mYd5Rwsf0dYHVpFG+1MiSf7EUHQcaSWkmyLXNqeaOj6H7lCXyLBNDfRI1ZMO9TwYbIEhrp55bjzFWkejCc3GhjzANP7u37EfoQE+toWiWD8vkviUIQq6mQ/dba/7QbAZzO+PCecg1KMZoIi+jrVDpZ8IcO5wh1C3gsVcHlTgMJTqnouJBOhH4nHBhE7wbk6522xqyt0V4J6wuxGUjzcWxU4txC/hGH6H2FCaEDWAr0QKTXuKQbHOhYX3PV83HhkMI1X2Ni7aYQ/yVxPp2W9eUV7vNSPL+R9V9hI4ZjWKWblfLAuyHBiadh1WYe/b2y9Bt1KYl4k39p+UFNKijjD1tywYTTvdzVg8eOONEZVI+CckYS+GUYJsmsairIuVMGTqKqy+dkLT/01DlL0Yy3wZwskvTLOhvWmiOzs9+PL08XyynzTQlhq1lIfnkNbuyV0oEsLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 02:28:25PM +0100, Andrew Lunn wrote:
> > > If you want netlink on um, arm32, riscv, loongarch you would need a
> > > different implementation of the binding?
> > 
> > It doesn't need this feature to build and function. It'll just be a bit slower
> > because inlining from C to Rust won't happen.
> 
> So it sounds like my understanding is out of date. When the first
> Ethernet PHY driver was being merged, Rust could not access inline C
> functions. The binding had to replicate the functionality. But you are
> saying that Rust can now make use of inline C code, but not actually
> inline it? It results in a function call?
> 
> What this feature does it actually allows inline C functions to be
> inline? So it is just an optimisation?

That's right, this series applies cross-language inlining to the helpers
we have for calling inline functions.

Sorry if I was unclear on the netlink patch series. I mentioned this
series because you told me that inlining is important for skbuff due to
performance (not for netlink though), and this series is necessary to
make such code on par with C perf-wise. But if you accept the function
call overhead from not having cross-language inlining, this series is
not needed.

Alice

