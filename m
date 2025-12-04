Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88820D1F9A3
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 10:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B143B6B0029; Thu,  4 Dec 2025 05:06:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC45E6B002A; Thu,  4 Dec 2025 05:06:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98C5C6B002B; Thu,  4 Dec 2025 05:06:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 81FAA6B0029
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 05:06:08 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E21FD8A6F9
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:06:04 +0000 (UTC)
X-FDA: 84181357848.30.19BF548
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 02E648000D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:06:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Osh22c/g";
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764842763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uGXO0gLyG5Nar+sZjNqwt8rSrpyx0kuMXY3yDl/u2RY=;
	b=u4ohJR7RS5NQiLPIGdZ06/yNUdXUIc9CM6V93YRa+KGHxXiAYtaDjBZaLUnHB4hU5SpGpF
	15hIEY3uo1B3xWu3uKcnpf6pPNqBSB2ujHyBQZWNKkYZE/OeYm4t3idJ6uo1pLNdmaNRPN
	u1VZ06iceyMP6WwGf14EQThG0vJW0jY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Osh22c/g";
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764842763; a=rsa-sha256;
	cv=none;
	b=2EwkTGEUIOLO3uZvPLiWg7/+A24dscEkuSXYBzisz/sEc6QUBM9lvZKKZ3CE9INbsN0IAa
	pMDUMYy6cR6JLUsFgZBKwn4qZXa03R7NACsBJi4zJi0NQLmx8JJTEPoW9evGWE7PKaVnd4
	XDg8wxsjJob1t2S6LPA6hPLy0Z4/BF8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D8CA6443E4;
	Thu,  4 Dec 2025 10:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C558BC4CEFB;
	Thu,  4 Dec 2025 10:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764842761;
	bh=HdxuyW48hjewxA37dD/zbSml/Oj0HqVBN0P1TbtJSfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Osh22c/gHyR+VPM2kPcT0dPiD6K9BvVhe5Ewzn9HXTkYe8a046bP8uE4VgCP19aDi
	 K7xBIYI24RyUjLFUPu8Jsurggk4oUE//29xVfPPkiZv362d67AnRunbs4b5rs1+Gjw
	 YS2XQ/6kgerJ6XOyYneyYfkre1v2DNabxE2eCArlBtO1fZs0/9oUkgnRGacd11N388
	 /GqZScuD1gNPgkWGXr8EGPBS8fC6oU43ADwQuKp3i8wBSNVTdMRqREmWXwUbXqmGUE
	 ffmQYPQtEzvEiW/FXBg4sDYheO7g+t6NXrH78pesoPO/l7JrqMckbFuomSJrJhGli1
	 QsAy+pTCZPGgA==
From: Christian Brauner <brauner@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dave Ertman <david.m.ertman@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Elle Rhumsaa <elle@weathered-steel.dev>,
	Carlos Llamas <cmllamas@google.com>,
	Yury Norov <yury.norov@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	linux-block@vger.kernel.org,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	linux-clk@vger.kernel.org,
	Benno Lossin <lossin@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	linux-pm@vger.kernel.org,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	linux-security-module@vger.kernel.org,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Lyude Paul <lyude@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	linux-kselftest@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vitaly Wool <vitaly.wool@konsulko.se>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>,
	devicetree@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	linux-pci@vger.kernel.org,
	Remo Senekowitsch <remo@buenzli.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	rcu@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Fiona Behrens <me@kloenk.dev>,
	Gary Guo <gary@garyguo.net>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	John Stultz <jstultz@google.com>,
	linux-usb@vger.kernel.org,
	Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Tamir Duberstein <tamird@gmail.com>,
	Rae Moar <raemoar63@gmail.com>,
	rust-for-linux@vger.kernel.org
Subject: Re: (subset) [PATCH 00/46] Allow inlining C helpers into Rust when using LTO
Date: Thu,  4 Dec 2025 11:05:29 +0100
Message-ID: <20251204-denkbar-stinktier-8a7c07650891@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
References: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1456; i=brauner@kernel.org; h=from:subject:message-id; bh=HdxuyW48hjewxA37dD/zbSml/Oj0HqVBN0P1TbtJSfw=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQaxnzoC5KPC9BQ6Xq2IqjgffnvpRpvskU9368/659bp HtRXnNJRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwESuWjAyXDA8eVezNuVTq5R5 o8gOmf3FN+71+Ire2yjd+7GFVzhvPyPDbR6JQvt2uT/tr3YuKJvw1D1B7vuZ55NmCNlPeyuwRvU UKwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 02E648000D
X-Stat-Signature: 18h1iry9eaz9e493mqfo5osb7upfz97k
X-Rspam-User: 
X-HE-Tag: 1764842762-311026
X-HE-Meta: U2FsdGVkX18TP0J7z6FBhA43x/Uw8QuS7NxjG3Pmy8HvR4xKDYSicLSD5vhX8PqiUZ8porm9tCgb9SAZWrwne8pQW8hltbOn+HuBm4FelyBZ17XCE0aaFOQTNBWP754/sESO/KVh7ueou32edIw8AN9miuJwPY89x222DCOaTmCBGmvb7Rvictqh7sCJri99rH4Mo/KS0FVX0mHlvlBsgD4FJAX7Iqw19D23QpWcdRM5qYKTVMYuDoo9lWXXvlajKYmqFhZevHxmzafaA3kGYr5VjDft3fJY/RAoflcZioejMQ+QBg/SpmBo9Li/fkSDUpjXa1CqEclsQONg5p6I1PdrsC82vyZ7vPo/pljANUwpJ881FVxFdPjDTeoaH4doo+4tVKUb9V8P/cUDSxS7kqO9VFB5LiOerNxCyCqoTbsGoQp3mADyoWgP6mr8TabQuPhWs3VALNY8vV85ESNqVniXdFnZLIniO073bfzG1KrKNiMhp0ubabtI544xZYZj0fckBUhRny4WiEA1UFWMRvDtZqRbjZuDRhGLr7T00MltnT6UTO6czz1fxiyYFSdTLrmbjjF11ck/jl1YIn4J6Mr5PHW0QtpAS3lxVZzU8O17gnKNtD2TQGO9v1znlFoxSFCZPAXYe35ESQ7Ya2Rlh4MQi+QL6rQX/O+2j8JoNFB2+3fvaLXFfX1oI5/I7xC9GrrH+ef4UA4TCeSVL0xECGERxJ4osO+it9WdNDHDGiMpTV2V41WBMJ1Qfw/+WTPiGC+yGJX778T0Atn38iw6h7dpyqL9Vtma9Emk0BWZ2Dik1qfbIFVpuQ8ohHW4Jf6UjHiOhIgHWO55VIcrjcXJFoeeGl6r2GDgBMALO68PDHMLnLmEWIlkmtPACE0Mt++AVW3+mdAC98yEiCLef9OvyRHT7I2KZAflQf4uI4EP17I0nMZb5PlxBVQpV8C1MDDakvOwy6yzQowoIEzGCnT
 P5jsiNgR
 kIWZSbBa7lqlSIdwH7V1D5cAbhAP74Je148Qlbga4uctMiwR99pHs+KpGd2YhsNcr1BQb2Jdi8Y0dhQ2GLe4VKYsk00Og9JwHCOAZgPDwTghnpHeNYMG3x+XX3L8Fh0ypK9nDfOp7QxhlkRNiqGuZqI3ULrhRKUZlPHYq0YF/2uFCJmVVpAh2u0J7PsQd9yDJvdgUJdN5ajfGnTLZ1VM1Ia+J1Wzen83ihT2tUsgjS3/clXv/Qr1fvvkydNnNa13a9B2J8+bmzzZeORPnGf6yMKecPj70hYAB3LTq4CKGA3vqJXFhERufzyM8kpQ0CLPTw3+Iv3G+nMmWoIkLdRffZMsryK4gJXEE9XY5pEDGKqFTwf0=
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

Applied to the vfs-6.20.rust branch of the vfs/vfs.git tree.
Patches in the vfs-6.20.rust branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-6.20.rust

[18/46] rust: fs: add __rust_helper to helpers
        https://git.kernel.org/vfs/vfs/c/02c444cc60e5
[27/46] rust: pid_namespace: add __rust_helper to helpers
        https://git.kernel.org/vfs/vfs/c/f28a178408e4
[29/46] rust: poll: add __rust_helper to helpers
        https://git.kernel.org/vfs/vfs/c/de98ed59d678

