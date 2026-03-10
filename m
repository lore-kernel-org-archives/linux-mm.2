Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3953EB105A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 14:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 055A56B00BE; Tue, 10 Mar 2026 10:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1AFE6B00C0; Tue, 10 Mar 2026 10:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7D416B00C1; Tue, 10 Mar 2026 10:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C681E6B00BE
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:24:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C17B1601CC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:24:25 +0000 (UTC)
X-FDA: 84530373690.09.79E5012
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf27.hostedemail.com (Postfix) with ESMTP id A82CF40006
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:24:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=LBScO8Ew;
	spf=pass (imf27.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773152663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4/p8AtxdJ3b4aYgpRIBgOOPVM9R5HZLzlaxPPsEZ2Q4=;
	b=Bxi9c8sp3AISAArIYVhVgoMGGfE0LtM9tZltzyt3vBYKcmY24CkQvVTq4+eCH+yT0US22O
	2j1uM2UC4oaJHekHUtY3JRex0YBDGVVjaYHZEIh5kE0J1P50MR7jNCiVHPFH2QDAo4wY/a
	yzX0zcSlbLF3hmRzOUranIy6a2Me2xY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=LBScO8Ew;
	spf=pass (imf27.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773152663; a=rsa-sha256;
	cv=none;
	b=0j4jIP41gmcHkD6F+WsUc8osO2d0wS9Rig8TjCmj728VlLtJ1ZeV48ENKy3CHukpAzXHIA
	Ji5SmQbrE7F2Xj+0YId2Nk4okqsGsy4wqXZeqx048lnACU2aV1Iwqxh4z5QcHcSrlSqWSQ
	e+tZO7bn0BS+ymlYRrx/c6YM1Ui+WiU=
Received: from macsyma.thunk.org (pool-173-48-117-133.bstnma.fios.verizon.net [173.48.117.133])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62AENmJI023255
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 10:23:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1773152639; bh=4/p8AtxdJ3b4aYgpRIBgOOPVM9R5HZLzlaxPPsEZ2Q4=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=LBScO8Ewh5j+pvClPuvYJ6dYWu+6WL2ev3A6duJrcxObwFWjC8dgbq1R1jaNAuzD8
	 1N3QSZ+599jgS5LWqKIvONI9n0DrlV/bhIgTucL1f31tVRWGphyQLoG1P9ldyU2xAy
	 5HxclsvbqfBvFTqtCNAuPlMheXwVOKZyEuJ33r0JlgL4HScNylkzQj16H9ciOlXPZw
	 GOi/SKdKtyjuJFISqW7lcvm87iESFGZLsNPOvP7dH6Va+zkOTwCBsrnPVNMrNF7MaI
	 VGM4um3yd0mf+GQ4rfSGAnefCT4XC/KXug28EdqxTBjdSY5IyF4VkjDB0JxugqwdwX
	 rwveeKEi+qz0Q==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 96A8A5C4FCED; Tue, 10 Mar 2026 10:23:48 -0400 (EDT)
Date: Tue, 10 Mar 2026 10:23:48 -0400
From: "Theodore Tso" <tytso@mit.edu>
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
        tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Ilya Dryomov <idryomov@gmail.com>,
        Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
        Bharath SM <bharathsm@microsoft.com>,
        Eric Van Hensbergen <ericvh@kernel.org>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
        Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Andreas Gruenbacher <agruenba@redhat.com>, Kees Cook <kees@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>, Jan Kara <jack@suse.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, David Vernet <void@manifault.com>,
        Andrea Righi <arighi@nvidia.com>, Changwoo Min <changwoo@igalia.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Valentin Schneider <vschneid@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Daniel Gomez <da.gomez@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Aaron Tomlin <atomlin@atomlin.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
        Max Filippov <jcmvbkbc@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        John Johansen <john.johansen@canonical.com>,
        Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <horms@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>, Trond Myklebust <trondmy@kernel.org>,
        Anna Schumaker <anna@kernel.org>, Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
        Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@armlinux.org.uk>, John Crispin <john@phrozen.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <rfoss@kernel.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Zhenyu Wang <zhenyuw.linux@gmail.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tursulin@ursulin.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Sandy Huang <hjc@rock-chips.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Andy Yan <andy.yan@rock-chips.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Andrew Lunn <andrew+netdev@lunn.ch>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Przemek Kitszel <przemyslaw.kitszel@intel.com>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Linus Walleij <linusw@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Eduardo Valentin <edubezval@gmail.com>, Keerthy <j-keerthy@ti.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
        Alex Williamson <alex@shazbot.org>,
        Mark Greer <mgreer@animalcreek.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, Lee Jones <lee@kernel.org>,
        Pavel Machek <pavel@kernel.org>, Dave Penkler <dpenkler@gmail.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
        Justin Sanders <justin@coraid.com>, Jens Axboe <axboe@kernel.dk>,
        Georgi Djakov <djakov@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 00/61] treewide: Use IS_ERR_OR_NULL over manual NULL
 check - refactor
Message-ID: <20260310142348.GA41218@macsyma-wired.lan>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
X-Stat-Signature: ri16tjt4xd718ik8ri7oq44ynr7j31ri
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: A82CF40006
X-HE-Tag: 1773152663-268950
X-HE-Meta: U2FsdGVkX1/QmUGzn6bffpl1qXzgOMXKhMDlOpZoiNK06ayfhTu8qjReQ6wg0nUqfdJxOpCNcDeyhRtkxUBFsZxlg1bxPDgQNSjGbchmty7g1IQRJiyDqLQW4ekU6nzg9rSIlZZMxvl24y3bWyaxq7EbxGYJvZ9GPz+5vcSREP9RsIL1xRmHDbZ9Zx+yp9t1ny1J4stqpqIsTT7C6Z6uf5dSeACjIFX83Ema6LAAkOzI0qBsrUsB5bTaEfuoJ7SiA8zDu4Wj/otN2oMRrAB/47GGTUrxg9b0eEckLwNy0e5AW8xxluZG/Bt75WXkF4EdiA+Kx9h896IwhkWeF46VWnfeXmyuIe2zZwF10ngOitnT/CVu52GOogfCXt+N46YyqcJ/tUrAOfTO9Oztc+BD2YE4WZqFnQh+K7jRofaAVw32Q8T//fSP9QDZkdQzCHlFLzaiLZagRP01/5Wv2WBA0+5zG+BmrqxNwCEgUxgT0lNcfzeXDq0Y3Q9empnGpMbcHkBgxReevEFtlVrAMcgnPNLruxesv+RKlwy5SdhfwUUQjKFanew7tZDWCHq/5qLwbWMHF0xI0ssNKRNP6di2W7EaHwitdXucaoFwHEIkBo7LA4emQxJuj4bGOujWI6I0AuPbbOKEQ4i82Gf9TiEMg/4bYwzw/cV9G5hnQ0e6Xw3f96bSigufh0W4H38QMrK60Akr9xJjWEE2mRRpTsVADiOjxyPly7yoKSW1bodwky3QkVk18YVscnawZ2qCxHv3QrxyoC17OVE+aPpbN5bdq+U6r9ZOjt3gj0zmnUA2FUN1DGqqUwdLn9BaQsbUeGSgf5whA1aetL7Il4gIASk9dNLscGuJq0xc7FW1D3oJVo3QucVqZvHBAc1lKT5c1KLI8o6uK5AJNkDtctTP7QHnGSNoeQiIvYi9x0/Me6WqF00P69l67zrMIrt3TF7LI4FrBRNTscgfwRYbJdmGOht
 Oso0WNw5
 AmYZ3lMeRKbhh6j5Gvb3XFd41DQvv7IfOAGONG//qB0LEgdsgnqzWWIyZxmCZGQ+TD1mTujFhZLrWAR3ppMgF96ZeyRtsAYKvivKR1ZGPhD9udITR9EOBounnP3A72Pyky+Jlph/j8IOGQdc2gU8rCGNZOdx8xEmCFNeIPmTYD+PI6BrG/o4p/9iTFaJXpg04RCg1tAVftFymkPRw2E4SF0hkjx/R084JgN3HNOqKG4rsAhtNiCM/Rvb8Vmrof1b/bZgGOBIQYPPPgXSaN1TDSWjmqY0PvHKT+HVO6zwMwLBcsg0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 12:48:26PM +0100, Philipp Hahn wrote:
> While doing some static code analysis I stumbled over a common pattern,
> where IS_ERR() is combined with a NULL check. For that there is
> IS_ERR_OR_NULL().
> 
> I've written a Coccinelle patch to find and patch those instances.
> The patches follow grouped by subsystem.

I'm going to gently suggest that you *not* try to do this as a
tree-wide change, since we don't need to change some interface
requiring a global, flag day change.  This is instead a cleanup, which
maybe makes the code slightly better, but which also has a the
downside of breaking lots of inflight development patches by
potentially causing merge or patch conflicts.

So why don't you send it to each subsystem as a separate patch or
small patch series, instead of spamming a dozen-plus mailing lists,
are probably hundreds of developers, most of whom aren't going to
care about changs in some far flung part of the kernel?

Regards,

						- Ted

