Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BECCCA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 22:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0CC6B0011; Fri, 29 Aug 2025 18:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C8ED6B0029; Fri, 29 Aug 2025 18:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DEAA6B002F; Fri, 29 Aug 2025 18:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70AE46B0011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:19:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC7B9160951
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:19:25 +0000 (UTC)
X-FDA: 83831212290.18.8264DBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 09927180013
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:19:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NpneGQ3Q;
	spf=pass (imf06.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756505964; a=rsa-sha256;
	cv=none;
	b=B0XiEXsvDBk8z0zwf+cAKg9w7utBGq+FAxAtj4DcQKme3IVJ06niiFld0AkW10y2uyldKa
	fNXHoK1sVSv5NlZiG/kj3ydkFa+hEQ0A40obMGpI8ZwmuKtKh2SDe7s4WJps/RVvKsNWGu
	cbxSpvAotITYVgr+hY8RvcbkEx0YxvI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NpneGQ3Q;
	spf=pass (imf06.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756505964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cXR6czlWvZZYuRgOZlVCoMto1uLIOZkL+rEOt0IMQlU=;
	b=TS2Bj73hG9RTfRhiuvhO/u5yn21FViU5pBo27SAHz2MTfxKczcGFWHpfreRJYy4w0HnIEk
	15U9KuEAH0H2bwXdezV7CMZgcIHEPGWNjO9rLto9SvCP+WAOo5bl6s7jI0gcHU3SygoXmw
	Jc4G58iXnEoneegWL4vmbfcrxZ6QnAY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BA72438B8;
	Fri, 29 Aug 2025 22:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D549C4CEF0;
	Fri, 29 Aug 2025 22:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756505962;
	bh=0bwPfbMyrek5L9hOu7GBREJXWyINw9aI7B0CsO+yy18=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=NpneGQ3QoAZZMVPOqxAMTMsnXEod1MdR9ylvjRjnlUJ/5Mz3jdgYOeIgkfRKPhZ/U
	 vShN87eLYGT8BEANkp63jXP/WsDTW3PU0xitnIZmnudm3QKOtQPPDMN6lDjVT1DMy6
	 XFRyCvB6YJQmelc7Wn3BJtfB7gPtsENP28OUr9nZgR3Z3uJVJ4N4zjTqq2R/gAAsif
	 WTFcvK4iQOHAl7e/mRAw01njvP6SR0PeP/vp9kcpLKktQGVHBqKVQ45BB3W4Cv3bfY
	 SvtEaHF5gGrpETbJNljug4x3qCKcghxgOt/gZHQtCpaow0R9q2yCiFsgb9Uaue3SoT
	 1eYuRWMtynFfw==
From: Mark Brown <broonie@kernel.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
 Linux Documentation <linux-doc@vger.kernel.org>, 
 Linux DAMON <damon@lists.linux.dev>, 
 Linux Memory Management List <linux-mm@kvack.org>, 
 Linux Power Management <linux-pm@vger.kernel.org>, 
 Linux Block Devices <linux-block@vger.kernel.org>, 
 Linux BPF <bpf@vger.kernel.org>, 
 Linux Kernel Workflows <workflows@vger.kernel.org>, 
 Linux KASAN <kasan-dev@googlegroups.com>, 
 Linux Devicetree <devicetree@vger.kernel.org>, 
 Linux fsverity <fsverity@lists.linux.dev>, 
 Linux MTD <linux-mtd@lists.infradead.org>, 
 Linux DRI Development <dri-devel@lists.freedesktop.org>, 
 Linux Kernel Build System <linux-lbuild@vger.kernel.org>, 
 Linux Networking <netdev@vger.kernel.org>, 
 Linux Sound <linux-sound@vger.kernel.org>, 
 Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
 Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
 Jonathan Corbet <corbet@lwn.net>, SeongJae Park <sj@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
 Mario Limonciello <mario.limonciello@amd.com>, 
 Perry Yuan <perry.yuan@amd.com>, Jens Axboe <axboe@kernel.dk>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, 
 Martin KaFai Lau <martin.lau@linux.dev>, 
 Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, 
 John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, 
 Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, 
 Jiri Olsa <jolsa@kernel.org>, Dwaipayan Ray <dwaipayanray1@gmail.com>, 
 Lukas Bulwahn <lukas.bulwahn@gmail.com>, Joe Perches <joe@perches.com>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
 tytso@mit.edu, Richard Weinberger <richard@nod.at>, 
 Zhihao Cheng <chengzhihao1@huawei.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>, Ingo Molnar <mingo@redhat.com>, 
 Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Waiman Long <longman@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Shay Agroskin <shayagr@amazon.com>, Arthur Kiyanovski <akiyano@amazon.com>, 
 David Arinzon <darinzon@amazon.com>, Saeed Bishara <saeedb@amazon.com>, 
 Andrew Lunn <andrew@lunn.ch>, Liam Girdwood <lgirdwood@gmail.com>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
 Alexandru Ciobotaru <alcioa@amazon.com>, 
 The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>, 
 Jesper Dangaard Brouer <hawk@kernel.org>, 
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
 Steve French <stfrench@microsoft.com>, 
 Meetakshi Setiya <msetiya@microsoft.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Bart Van Assche <bvanassche@acm.org>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
 Masahiro Yamada <masahiroy@kernel.org>
In-Reply-To: <20250829075524.45635-1-bagasdotme@gmail.com>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
Subject: Re: (subset) [PATCH 00/14] Internalize www.kernel.org/doc
 cross-reference
Message-Id: <175650594072.395832.3911302052314725751.b4-ty@kernel.org>
Date: Fri, 29 Aug 2025 23:19:00 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-a9b2a
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 09927180013
X-Stat-Signature: t8yq3qcix1yf95knhfeufikjxq5dcrsq
X-Rspam-User: 
X-HE-Tag: 1756505963-471093
X-HE-Meta: U2FsdGVkX1/lypSqYDTwKBZ2T+YpW835i9ZL/wiXJIu8bwxoqMQaljzAGKxnS951XEZ8j2tKXwMQKuEkbznyNTNeYbdBU6xb67eQ1IrdCpYLjj1HZOjSxqxTbQgNO/OxZycq0rxioyMohLyLZ5I4uJwvUekVeh2N7ksdETcJkHD2s7kQJAW/BPuooEYZUNqHCD1QiG9lrrcNMFWR6fnJhAirqozUFLHZHAHXdQrQbcgA8vYv5NUip0xliCLCjoARNbFjk32upMQzawOaDGH19lo55cG9y4EjUfMGSkX/EdOEQrrpxU5bdtRuPfHt+P4yWHSuu+PIfO0sSTahZ5BGPQo/GZYAJwh4kG9xJY2NtgawZyxEJexg/JLBJXlaXhFLepQjPBE/RYIlqk5LSbKR6JbyPq7LzfhtIUITyEB2Mi531jJTVkEwfL75bvuwFOLr3jMQo3Zt2oLp7vSUQwJ8nJyfhApLX9oWo3hWedeffo4ZLrcpQG7UzjrwGMFYIdiGqOfq5nWLnqs9GJ4iGejzfLGogLdG7JKdwFIYSuBlZu7+RaB+2NltoWDTkKbKEdrv2y3fn0JfjEtULFXtJ8xzWQksPRKYg6JkxzFdhO5alOnRju8vtn2/0Hy21VtN7E6x2Gvz17y0+DB6MXh7V92kmsmobKLy44Svr27gRrICwQG5OtbYgUF35xGs/Ke5yBFBXkdyWIRMMiHWroRNMTq/YemNCgkEhcYfke7fb6uZJaSyoaaEu+SnZa7nlN+2A945kXwW4DOq2mdLcMzD5s1oFmFNsIjb+bk1azv+8M++oLhJIhqg7GvgV72hyN//WCXG9jEZyAFUhb+8XLRpJ89GNUlczxt9VZaF2vr8Dl7mZCXyHUVMJabTr0LsmtKfR2VrC7cp2Ow11GaTAWZdiFx2P7KUhgqq/1LYLo7aviODf44PXYi+9Stef217xdA3s0OLoNpmDSkOFniYs+D2daR
 2zEpd/r4
 tmQyx5AvbBEz5D96V2JE4WajBIfGwORidTFTEBsOBfrsDfVqAVLDpxthmetPIQht61zEN9ogPMGBZP50Wedtq1veC0ToAe9g4eafGMAvzG34QuDCCxBh0cvM0n5Qh4r4JQB/bSWSeraISEfxExGYSRr5L1Y7izTUnMTCvKhRc3Qbb8W97kEHVO871o7ybQG71Cf/oULcl4w+d+FSGpU3ZSlqeAwAjINedN/oIai7MyFqLxA47LgkivIiEngfuxZyzRNzhcuU4JA5QYUvRYlwXsoP0FAdQXU4xQ0/eV87uSodydKetQ5TY+YGV+vLm8yXJZ3ixto+g387Y1XDOii8QnP2izBvQ1LbGnkRYvcU5wFtgmOUy8JtLB4yG2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 Aug 2025 14:55:10 +0700, Bagas Sanjaya wrote:
> Cross-references to other docs (so-called internal links) are typically
> done following Documentation/doc-guide/sphinx.rst: either simply
> write the target docs (preferred) or use :doc: or :ref: reST directives
> (for use-cases like having anchor text or cross-referencing sections).
> In some places, however, links to https://www.kernel.org/doc
> are used instead (outgoing, external links), owing inconsistency as
> these requires Internet connection only to see docs that otherwise
> can be accessed locally (after building with ``make htmldocs``).
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[12/14] ASoC: doc: Internally link to Writing an ALSA Driver docs
        commit: f522da9ab56c96db8703b2ea0f09be7cdc3bffeb

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


