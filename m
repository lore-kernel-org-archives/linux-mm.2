Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CC78EB1056
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 14:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 850276B00C3; Tue, 10 Mar 2026 10:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FDEE6B00C4; Tue, 10 Mar 2026 10:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B5876B00C5; Tue, 10 Mar 2026 10:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5878C6B00C3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:16:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C81E1C0D5
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:16:52 +0000 (UTC)
X-FDA: 84530354664.03.3C17049
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id 146FA180015
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:16:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773152210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u1O5Z146YMk8FHwWYHIeq5l+sJXYGn84l3Uu3PDpBrg=;
	b=1mt4i6PLY3qUCkCFrhr2j57cpdBX3926oK0YgALbC3S2jtv4SJRp3zYL8jLwRFQZeUcC0I
	t/dwk0IB8q4RabcKI+93JTzBquC8koKzLLVIaL72+8JsEpxLx/WggeZQYEv/oXK4pN5OE+
	7hv1k2f9sG2o65hG27T8tZZy5xuZ8c0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773152210; a=rsa-sha256;
	cv=none;
	b=MMmAJaVtYEGUcnx/M3TgYlIyZ/IJJmkcMNW/ZMHQ939t4pXAeHg/ETeC8YgWZaa6gorJzF
	bET4t2OLE/XIEz+pgg1Glt+IZlXSsrIQxt2Nda7/v0ZmO6rcBqeaiwTDXnfJ7PD7QQHd50
	jJbRh6wnE2wi8cXfDQqYGZkone8UJJk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	none
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF2B9C0E36;
	Tue, 10 Mar 2026 14:16:43 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id D3F9D2000E;
	Tue, 10 Mar 2026 14:14:32 +0000 (UTC)
Date: Tue, 10 Mar 2026 10:14:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr,
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, Julia Lawall
 <Julia.Lawall@inria.fr>, Nicolas Palix <nicolas.palix@imag.fr>, Chris Mason
 <clm@fb.com>, David Sterba <dsterba@suse.com>, Ilya Dryomov
 <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, Viacheslav
 Dubeyko <slava@dubeyko.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger
 <adilger.kernel@dilger.ca>, Steve French <sfrench@samba.org>, Paulo
 Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, Eric Van Hensbergen
 <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, Dominique
 Martinet <asmadeus@codewreck.org>, Christian Schoenebeck
 <linux_oss@crudebyte.com>, Gao Xiang <xiang@kernel.org>, Chao Yu
 <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, Jeffle Xu
 <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, Hongbo
 Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Miklos
 Szeredi <miklos@szeredi.hu>, Konstantin Komarov
 <almaz.alexandrovich@paragon-software.com>, Andreas Gruenbacher
 <agruenba@redhat.com>, Kees Cook <kees@kernel.org>, Tony Luck
 <tony.luck@intel.com>, "Guilherme G. Piccoli" <gpiccoli@igalia.com>, Jan
 Kara <jack@suse.com>, Phillip Lougher <phillip@squashfs.org.uk>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan
 Kara <jack@suse.cz>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Tejun Heo <tj@kernel.org>,
 David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
 Changwoo Min <changwoo@igalia.com>, Ingo Molnar <mingo@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Luis
 Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, Daniel
 Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, Aaron
 Tomlin <atomlin@atomlin.com>, Sylwester Nawrocki <s.nawrocki@samsung.com>,
 Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Max
 Filippov <jcmvbkbc@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, John
 Johansen <john.johansen@canonical.com>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Andrew Morton <akpm@linux-foundation.org>, Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka
 <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Marcel Holtmann
 <marcel@holtmann.org>, Johan Hedberg <johan.hedberg@gmail.com>, Luiz
 Augusto von Dentz <luiz.dentz@gmail.com>, Alexei Starovoitov
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard
 Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jamal Hadi Salim <jhs@mojatatu.com>,
 Jiri Pirko <jiri@resnulli.us>, Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, Trond
 Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck
 Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown
 <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo
 <Dai.Ngo@oracle.com>, Jon Maloy <jmaloy@redhat.com>, Johannes Berg
 <johannes@sipsolutions.net>, Catalin Marinas <catalin.marinas@arm.com>,
 Russell King <linux@armlinux.org.uk>, John Crispin <john@phrozen.org>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Yoshinori Sato
 <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, John Paul
 Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Andrzej Hajda
 <andrzej.hajda@intel.com>, Neil Armstrong <neil.armstrong@linaro.org>,
 Robert Foss <rfoss@kernel.org>, Laurent Pinchart
 <Laurent.pinchart@ideasonboard.com>, Jonas Karlman <jonas@kwiboo.se>,
 Jernej Skrabec <jernej.skrabec@gmail.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Zhenyu Wang <zhenyuw.linux@gmail.com>, Zhi
 Wang <zhi.wang.linux@gmail.com>, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, Alex
 Deucher <alexander.deucher@amd.com>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, Sandy Huang <hjc@rock-chips.com>, Heiko
 =?UTF-8?B?U3TDvGJuZXI=?= <heiko@sntech.de>, Andy Yan
 <andy.yan@rock-chips.com>, Igor Russkikh <irusskikh@marvell.com>, Andrew
 Lunn <andrew+netdev@lunn.ch>, Pavan Chebbi <pavan.chebbi@broadcom.com>,
 Michael Chan <mchan@broadcom.com>, Potnuri Bharat Teja
 <bharat@chelsio.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek
 Kitszel <przemyslaw.kitszel@intel.com>, Taras Chornyi
 <taras.chornyi@plvision.eu>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>, Iyappan Subramanian
 <iyappan@os.amperecomputing.com>, Keyur Chudgar
 <keyur@os.amperecomputing.com>, Quan Nguyen <quan@os.amperecomputing.com>,
 Heiner Kallweit <hkallweit1@gmail.com>, Marc Zyngier <maz@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Andrew Lunn <andrew@lunn.ch>, Gregory
 Clement <gregory.clement@bootlin.com>, Sebastian Hesselbarth
 <sebastian.hesselbarth@gmail.com>, Vinod Koul <vkoul@kernel.org>, Linus
 Walleij <linusw@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Heiko
 Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander
 Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, "Martin
 K. Petersen" <martin.petersen@oracle.com>, Eduardo Valentin
 <edubezval@gmail.com>, Keerthy <j-keerthy@ti.com>, "Rafael J. Wysocki"
 <rafael@kernel.org>, Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui
 <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>, Alex Williamson
 <alex@shazbot.org>, Mark Greer <mgreer@animalcreek.com>, Miquel Raynal
 <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, Vignesh
 Raghavendra <vigneshr@ti.com>, Shuah Khan <skhan@linuxfoundation.org>,
 Kieran Bingham <kieran.bingham@ideasonboard.com>, Mauro Carvalho Chehab
 <mchehab@kernel.org>, Joerg Roedel <joro@8bytes.org>, Will Deacon
 <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Lee Jones
 <lee@kernel.org>, Pavel Machek <pavel@kernel.org>, Dave Penkler
 <dpenkler@gmail.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang
 <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
 <decui@microsoft.com>, Long Li <longli@microsoft.com>, Justin Sanders
 <justin@coraid.com>, Jens Axboe <axboe@kernel.dk>, Georgi Djakov
 <djakov@kernel.org>, Michael Turquette <mturquette@baylibre.com>, Stephen
 Boyd <sboyd@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Pali =?UTF-8?B?Um9ow6Fy?=
 <pali@kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 00/61] treewide: Use IS_ERR_OR_NULL over manual NULL
 check - refactor
Message-ID: <20260310101220.24a5c5e9@gandalf.local.home>
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/9Mzn/qfZFEp1e7RgFq11s4n8TXcGF42g=
X-HE-Meta: U2FsdGVkX1/sr455L+OeqDWIUsSflk6pOnirfnKU4P+1ptXPBptvvQtdgLpKUro5xpE5mwL9OSxc8De42fWUKW3UA0xDjLt8deOx7Rt+YD2zdLsgLNPt+GtW9t0OIk6HGza/DLYz3Vzwa6W2j9RFRkt0u8kU/4nSdzQFXg0XUCPq0O7Zih2HPR5kbJC2dqX8fgpgG6kXbyGWAJWC5H8NEAgNiaeFS1ibRza8HlDqKtmihYdG70k1ID4dNk90G/xB/tCbIhXs0SuHsvdkjj/J9rzzD7qFP/bRWTfcgm+WhH9Nv5Rz067I1rPqmO4dO7ez
X-HE-Tag-Orig: 1773152072-399195
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 146FA180015
X-Stat-Signature: t3hdewhrhasw7f3gorx5jroa8bfttu61
X-Rspam-User: 
X-HE-Tag: 1773152209-187552
X-HE-Meta: U2FsdGVkX1/TUa8mwbRvOfb0KoV1Pqg02D4NAyfST8ke8pNVXUJZb9bX8bR/xMvosblNhu9eHUCaQLFYgoS6sLCSONq5YbaFVC0gUEmMEJtOK9wMcIU+K/kS8koJE8W0GtADSF/2+/jECuTArAHsgTzNdUsyI8+MZKxQ4s0/eCQEGzTAOiJx+FptU6SvXTj3G26ulcnr4lECbD+esm6wzYC7grFbkNGob9Ts1F266dpXuvEtJPuVoMTK6QdjZYp0R8poXslqgyI8d49E+pvlvJ0YoFei1vUXrRS5UgGCQnslUaXjKtxSp/TqchWb2MPx6xUdBVZb7O7XsUGbm6XRKxAVibLHG+KlIzYunq/nWh6H41wR/bH1p/CbZErvz116P1500OyU4oMfCZcxM559/uXXxRjkgqSvSWqy+oZ1vJU5Sin1tOxyLyFW3IeNqIlrQsBwEyAIflnmmMuHJJixUr4wcoI6j0rPBoXpgzZ7FRhtcnRQlQSU7Oi75ilYq5kYO/hQZUxkQtzmOc0HyP0p7/YghD2Lnde8Knw9yfTpSssHpH3rGNbcjTAemgzwYqID/KpEkjyyQMSRjIh49HcXg9a8FRJ6HsLkm0GpxvfHPER2UfUIC0iWsZ7UkRjRfXLxfiVmYvEh+jlT8zxK3TGQIv4SNQq8l8rht6ElPD6ZLjIS/zjVhZMq+ySKMDB5JbmhH4B9pF0p7nTdSNtcX9Cs+0xCFme1QJ7Sbw510yK7h3E4T/Ru1e5b4BaQ53w9UEdd5n3JVNE+KfsoqQTFmb2Wid4WAtpOYT+a/xSxgCb+6u2NTaxqrxTkRTl24NWbqdOntBNZF7RPbVt+FqnGuLbXPIRSh2GOHvZuqPlMlJyydQS9vyvidQp3S2R2T51/mBWBZcuIuI0DzPxXXihgc0gmJww5RhwBAiWlAmVlqyrqZEH/ohQc4NACjxOOD6m06qXC4UmQfAfEo7PhWVR9Gkq
 i12d3zRg
 5a/rRpcdf66lFMab2tLBdqrLUD4SwLkuNdwtoPHwBhvvmPgMOgoFIISLdLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 12:48:26 +0100
Philipp Hahn <phahn-oss@avm.de> wrote:

> While doing some static code analysis I stumbled over a common pattern,
> where IS_ERR() is combined with a NULL check. For that there is
> IS_ERR_OR_NULL().
> 
> I've written a Coccinelle patch to find and patch those instances.
> The patches follow grouped by subsystem.


Honestly, the IS_ERR_OR_NULL() looks worse in a lot of the locations you
updated. Just because we have IS_ERR_OR_NULL() doesn't mean we need to go
and replace every location that can use it.

NAK for any code this touches that I'm responsible for.

-- Steve

