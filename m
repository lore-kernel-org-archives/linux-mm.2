Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B32BFD5B16F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 13:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266206B0007; Mon, 15 Dec 2025 08:59:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216726B0008; Mon, 15 Dec 2025 08:59:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105A36B000A; Mon, 15 Dec 2025 08:59:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 01D296B0007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 08:59:16 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A84E3C021F
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 13:59:16 +0000 (UTC)
X-FDA: 84221862312.17.DEE5704
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 172C71C000F
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 13:59:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K0ZSvqo9;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765807155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B92+NivF60LJZLsL0UwK1xRxjOVxI+ZR0FYvLwpZtsA=;
	b=VctE3uQUOpiow4dJK8tqElgfXidLJG2PEMVyr0uyhVzr9RLVQDxS/3RQtWyF1ol1fqOv0u
	DqdJWPW91OK2QyCfz9W58HkyPqSZue7AEpAPFFqI91QK6+VODhVKYiyx3qOJLKFDLcp54Y
	N2tXKwAP4PxpV+yGOzrcMOUscO2bZdo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K0ZSvqo9;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765807155; a=rsa-sha256;
	cv=none;
	b=hOc4iSiG6J/SVzQ5AiOiKNAWLR6K241orW/9wOEWdRb1ur2cbJ8Xb3hl0iR1hzdM0Gfp+g
	PjZG+N8Ea2DE5/KdglrmUPCfU5Xiu2Ndq2Mi4RR0blW0IEyeEnywsvPh2r3ZxL+4k8ed5L
	k+djRETZ8QAWOcMwdH7BVuifgcMWymA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3511360150;
	Mon, 15 Dec 2025 13:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84039C4CEF5;
	Mon, 15 Dec 2025 13:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765807153;
	bh=YQ0YmiEKTBiByyCk2XIiAXJahBqdOSyVHDmgyhFstuo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=K0ZSvqo9FNH+vPZrOVLOU5ZraIN5/Hx4lzXEVk8deQoFTzZrfVB3Sn8wUVb8UaBDT
	 IPKJL1FeYjBc4++kymDagnMFo+aO6gmHV+UWQO7cqHTOD6VMMtizrJjRFLGRY7Ee7L
	 w4mP9rPOGGMbKthLu+r5v9Ru7rhk3vDAc1XCmmrB5wHkqvV8acOQhuC1BVzlP5ME/H
	 H7EzKs7+bvfSkQA41DZXMI2/LRypKRi0eSe24U8EkDVDNspUAYXac7itmfYbMOTmxv
	 x+MHyD8AednEYtbIisGEt5V/tIfQDU8l0ImBMScwR5yt2mJk+grnKjhIaLlaCyGSER
	 QNwLC455/HDNw==
From: Mark Brown <broonie@kernel.org>
To: rust-for-linux@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>
Cc: linux-kernel@vger.kernel.org, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun.feng@gmail.com>, Elle Rhumsaa <elle@weathered-steel.dev>, 
 Carlos Llamas <cmllamas@google.com>, Yury Norov <yury.norov@gmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, linux-block@vger.kernel.org, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Miguel Ojeda <ojeda@kernel.org>, 
 Michael Turquette <mturquette@baylibre.com>, 
 Stephen Boyd <sboyd@kernel.org>, linux-clk@vger.kernel.org, 
 Benno Lossin <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org, 
 Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
 linux-security-module@vger.kernel.org, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Abdiel Janulgue <abdiel.janulgue@gmail.com>, 
 Robin Murphy <robin.murphy@arm.com>, Lyude Paul <lyude@redhat.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-fsdevel@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, 
 Jason Baron <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Brendan Higgins <brendan.higgins@linux.dev>, 
 David Gow <davidgow@google.com>, linux-kselftest@vger.kernel.org, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, 
 linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Vitaly Wool <vitaly.wool@konsulko.se>, 
 Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@google.com>, 
 devicetree@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 linux-pci@vger.kernel.org, Remo Senekowitsch <remo@buenzli.dev>, 
 "Paul E. McKenney" <paulmck@kernel.org>, rcu@vger.kernel.org, 
 Will Deacon <will@kernel.org>, Fiona Behrens <me@kloenk.dev>, 
 Gary Guo <gary@garyguo.net>, Liam Girdwood <lgirdwood@gmail.com>, 
 Alexandre Courbot <acourbot@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>, 
 Mitchell Levy <levymitchell0@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 John Stultz <jstultz@google.com>, linux-usb@vger.kernel.org, 
 Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>, Tamir Duberstein <tamird@gmail.com>, 
 Rae Moar <raemoar63@gmail.com>
In-Reply-To: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
References: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
Subject: Re: (subset) [PATCH 00/46] Allow inlining C helpers into Rust when
 using LTO
Message-Id: <176580714194.161338.1959594276727103368.b4-ty@kernel.org>
Date: Mon, 15 Dec 2025 22:59:01 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773
X-Stat-Signature: e5ytn1fh7d4bhtdf59hax496pha57q7z
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 172C71C000F
X-HE-Tag: 1765807154-325232
X-HE-Meta: U2FsdGVkX18ad0VKJ5VZRx1x1IUMFLiDq+BPpmC8GcjQsPw3STedByJboAvM4Fyw5KXGvPWnsalVDXua9P9+otNuZe6dZEatSQXjLAPoZQ5Ajl+Kyq0eEkP3pPEvpYqY1nPNmPtC+RRZQxEGemP7vfDdT+Cx2kSMu0w/I8UCEfTE/cNXq96eoCGXkEyfktnOirRgz+NW+kaftdBu/TwrDbNKL/0xz6AIrnEc0F4aJAliSwJtNx1bGbglntsuGjA3riYajvz7wcZ+TPlGr3MYy3UKVKFbnOb+iSv5u1YwSnmvYWg3OECbNCTqW49hthvLPZajcXo8D+M2x8tMSEF+dt+gCYuCoqTaPvrQrkQTAcbk7ErTUVqZKofXqmk7nznA3D+yu5XUdYdxO4lqRe/pe0xQGChRPXovwMS75izcUFEZ039CXrpI5fm9CIEUA5bHLtfKLR3rbrTISpQzHQZd+7/kqy3oXMA167z02WeafcD0KJVxIzSNEHp3ihsM/qzz0WGw7ieMCJBYKPfcfytewhcYicqjKo/a2bIEsB2LsUVAj1Jslgl5muYdQWMjmWN2xcJdvPcZfYpUhwEbZ/omb0PGcqk/ChngVXFJCaIdyNZZmR+aIfwg9hvRv02gswi9xf9U+qRngGHKXsY0mFaAh7GgHbk4Af29xEFGX+87b2zTnEZRTcm4yqBGdSJ50t3sXTe1taP9mrDHg3zixzaRgfdquVKOvVM/MpqYYQ3HVeCnFMIySNTgbPU6K6Caj6U7qGyxKrAsUIoz8uXIPNZAiAelkU2uCfKYFCCyzj5pgYAgfClqjq1haNwJasP6vMRDai2rzdrc3Y4e3xdJcYwcahUKcMTy4eCuITa+dTrPFW5SYp/G3mRrMymS4gcPr1WmiD5RaZ1gE5fkONysKMjSmIZYpVHFv2NYS9f4pb0x4Q4O6aLK9g5FiokozlJ0q5R1BMvjZgZgtsDbYlp3lxV
 s5ANbXnD
 OAnEi2tPWW2jzEschMAkWUC2nvQ2mILcb9wYI/RpE0j/A76JBC24ENvj4Pi9t+hn5uZhwuOu7iJn1zq6GiFUMB3efNxe08/GdmZZA5yJo2iYcIfd1CynuARwvCWc7dmjlNL7Uk9xp0oZiUWIUIEGJL5B6W0K/gtqaRdMGMRH1KKqpZ6llArg5mi+qN+nOUVPZaPgCGbRBBLbVeLdaFbZ58N7CF+jN7mp0GZBVR533sENLzo5ClyUqdx84mWJcWj/4emZWmP32gcdYq89SAGNAktaRs4FiKucV1y87sx+qr318HTN9E3vuPQHb0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 02 Dec 2025 19:37:24 +0000, Alice Ryhl wrote:
> This patch series adds __rust_helper to every single rust helper. The
> patches do not depend on each other, so maintainers please go ahead and
> pick up any patches relevant to your subsystem! Or provide your Acked-by
> so that Miguel can pick them up.
> 
> These changes were generated by adding __rust_helper and running
> ClangFormat. Unrelated formatting changes were removed manually.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-next

Thanks!

[35/46] rust: regulator: add __rust_helper to helpers
        commit: 03d281f384768610bf90697bce9e35d3d596de77

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark


