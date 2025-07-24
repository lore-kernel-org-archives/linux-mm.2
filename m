Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B33C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 21:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E0988E00BB; Thu, 24 Jul 2025 17:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BA3F8E007C; Thu, 24 Jul 2025 17:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F60E8E00BB; Thu, 24 Jul 2025 17:24:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F5288E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:24:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE9F980524
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:24:56 +0000 (UTC)
X-FDA: 83700438192.28.108F067
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0D54F1C0003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:24:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=TpVDTtmn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sboyd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sboyd@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753392295; a=rsa-sha256;
	cv=none;
	b=vUc1WtG5wN42ocxVBoOBy0T83rAbo3Sy4J3TZ1O93Alr1HnbHRLSzZxfF6AQ/GUfJ1nTEq
	h4YYMUow+rIbcI7aWGj/oD0YqT3d27l2TZ49fGmZVeWQRRIL0s/ZTTV84CnZ/lzquB/djN
	Uxz27gjKcwLEbNWK6goaQEwj7R0Yq9U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=TpVDTtmn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sboyd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sboyd@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753392295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XF9wki9AjDCraP3PkW3hEqMnoy89UeAnuDiZvWolUoQ=;
	b=dL8aiNDO60f2Hhrg82yUZdP8924ifBZhTPoW+BdtRtCW9uLJ/N/fVwb1F4xdm1kbLqbdgb
	pfRHIln/pURwCQDl00f8+RPIKFvu3e+JSFJsFLV4uVDlbhnMty5gx5v9YmRo7gf5kMn7hw
	d5B2ag9cGTwT/GfggKr8FBXT8cF1AMk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 14F5243CEA;
	Thu, 24 Jul 2025 21:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D667CC4CEED;
	Thu, 24 Jul 2025 21:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753392293;
	bh=XF9wki9AjDCraP3PkW3hEqMnoy89UeAnuDiZvWolUoQ=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=TpVDTtmnke03qtUEM6XIe7WRETHGZba0w/dTkUEFESVK6kJkUu9ET7u/rEdgl4bGx
	 2EfRXLHH+i865D9SfrkseELWYD78ivz0BkiFnnzfeHYll1nkdAXSzp9qNT/KigbhAy
	 T5NiCU8nM+JrweBAZePm38tiRglzXSaeo6nE37mL1qsPw5wL8nRe1MxIARw6gt8vcQ
	 8sQUw65v/p2D0hPaA7kgvgfml9H9l59fExztLX1CwHYZM2Lu281UiO6W2v2a5oRSb7
	 sXmpIoxIWLKlTPQkXdbzWLZ3US4iGFhbInUbA7oANY0Ki5BVzlaTW/c4pyT0PuBrxO
	 eIxpilMnzjWcA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20250625231053.1134589-2-florian.fainelli@broadcom.com>
References: <20250625231053.1134589-1-florian.fainelli@broadcom.com> <20250625231053.1134589-2-florian.fainelli@broadcom.com>
Subject: Re: [PATCH 01/16] MAINTAINERS: Include clk.py under COMMON CLK FRAMEWORK entry
From: Stephen Boyd <sboyd@kernel.org>
Cc: Florian Fainelli <florian.fainelli@broadcom.com>, Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, Michael Turquette <mturquette@baylibre.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J. Wysocki <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, John Ogness <john.ogness@linutronix.de>, Sergey Senozhatsky <senozhatsky@chromium.org>, Ulf Hansson <ulf.hansson@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Liam R. Howlett <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>
 , Sami T
 olvanen <samitolvanen@google.com>, Daniel Gomez <da.gomez@samsung.com>, Kent Overstreet <kent.overstreet@linux.dev>, Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Uladzislau Rezki <urezki@gmail.com>, Matthew Wilcox <willy@infradead.org>, Kuan-Ying Lee <kuan-ying.lee@canonical.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Etienne Buira <etienne.buira@free.fr>, Antonio Quartulli <antonio@mandelbit.com>, Illia Ostapyshyn <illia@yshyn.com>, linux-clk@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, kasan-dev@googlegroups.com, maple-tree@lists.infradead.org, linux-modules@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Florian Fainelli <florian.fainelli@broadcom.com>, linux-kernel@vger.kernel.org
Date: Thu, 24 Jul 2025 14:24:53 -0700
Message-ID: <175339229300.3513.16413844188162316683@lazor>
User-Agent: alot/0.11
X-Rspamd-Queue-Id: 0D54F1C0003
X-Stat-Signature: uzqz41hibhpomg7wqx95apjxsyf3e684
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753392294-227071
X-HE-Meta: U2FsdGVkX198mtb+jpLrpLE2a5NQFGWdo96Amw+BmXRqvyEHWkcJXT1KhgJfgKwNTcKnZ0U/3Ut4N9K/mtOEXQZXPLfZwan8gybEjH1ilO2yz0rqCQuXOqlmSGV+ueGzRK1tSljILdSkuNfmZieBjgbE6CYENIc5kUNjShK8fHh+Gj7z3hnkr+0gVtvm9Fl8hXjL4DNTn/IoDUiO0WvX6x7EX8Rwz1S1egcY7WN2vLi36rpTGjBuS1hQ9QLnGAg9i6rp/Y8TTb9aC/LrSL+6lQYT053Ey4RYYafPEI1b89j10H01cAdSJ4Y836HXU7K72sGPRnTIWIKNLUWIJW2EeuZJY8+XTB8BOnnyfYMlr0F3pq8p+iIT5ITGiCBLdjcImWo1h4o608Vhwe6ApyaQfxfgQca2PA3mtngPioSJx25FKnOiZPBYlCIfGnI9fMDmg5jSk5MqQI8sQ6MWkvjtHhdmerMqzjhUCg4NY5G7nywaX+/PyrxTh8CVnQUMgYG4VBW5TkGqQk+AsWC05z9MHjtC/gXiZA+GvU+hjI0i+CL35jJv2goBcpCn67dxUKOxWmgG7zwshRtlQBwtnJ0BgISySxzeAXixhOvWpZF7PMzmg4IDKn7MQy0z72+FVbThyHC81JfjkORrBv9Jl7lCIZ8u9q1Xj2XQlwxWinK/CNKmcbb4LQtJKGZNbzzC6MHIRHCOMQ5GVbogpE9/3p5irq4zJ4l7/hetVb3pjtxQy9Ec7CFfpMsZMdNhhWGVRomDRQYrqZLRhBu/wMxe7LNzQW5N0s8hMoJ1kYnHEjz02KcjG9CGUX6Gcyb2+/9kT8ERtEq7m8lUqlJkgdcXv9qQ0GEBSor0O6tNlNUkSGd/oKCTtjYt9eafBTccx6qC9rkU5TMpDYlQRkbnj3ETKNSa2FN+mEIv0+sOtCg02DGdrkVD9X2ftsDDjL1UaWNjUCRSN6sCS4ulp2GSRjTbwyk
 /p/8k8LH
 cFic7DUybZ3OsmU2l/XYZ+1W8EmVgN9s7Wu8UwjYCR2d1W/EnLeTxW2ICG15dggpfusFBYr88F86u5EpEa5qc4Yo/oumFMV6OOrCNk1rMHbWqGUZfurO4Du1xyAzAfZ+ZcUF+rlTr73AtSR48sU6QypScaSLq63gs/7RhGY648gEnJdBNFbUSA7L+XzN9Ky84By/fGtk4q+baCvBFPlVYmLnCZdKNscSiIXFRpnk0oOTuUSjRD5VwTscNz+IU4vH7Su7GImSkBzb22q4j4HS2nica/1sxDa7lkmYZqZaGDegNudDlv4/cmsD4yifOM/zKZBoymx0Gyz1rZ0Bys2aFYKSsFRqiRqM+H2Sz4uuV5Kw5t9d2plbjLRFMmRQ0TWuzF8Ry25+9RsFQFhG5UeWp4f+YVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Quoting Florian Fainelli (2025-06-25 16:10:38)
> Include the GDB scripts file under scripts/gdb/linux/clk.py under the
> COMMON CLK subsystem since it parses internal data structures that
> depend upon that subsystem.
>=20
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
> ---

Applied to clk-next

