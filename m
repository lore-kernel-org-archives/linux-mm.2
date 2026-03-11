Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE2F1FD88D4
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 00:11:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF0BE6B0088; Tue, 10 Mar 2026 20:11:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9D66B0089; Tue, 10 Mar 2026 20:11:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91FB66B008A; Tue, 10 Mar 2026 20:11:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A5C86B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:11:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06C1013A9F8
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:11:44 +0000 (UTC)
X-FDA: 84531853728.05.FA34DDA
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf14.hostedemail.com (Postfix) with ESMTP id 61E1B100002
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:11:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=rsZWNNzp;
	spf=none (imf14.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773187902;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7hV5LSkoaULvfWpcA92IONFe2jiU8FtnTFTGMKYHxiU=;
	b=mTJBZfOCGxe1sWiqxHqOQl/t92YhbSrJlKkGQ4u7V2BAZ2FoNObYG+9vjEdgP7eFNEIUWm
	7Ts3EgH/ZKPoCTnFQVyPCDAVim6BPS23PLPooeDiWVa7saOuChc1Ue9vJisNgC5VV7udh1
	HEFcGoxMuWzpPIV6iKYB8Naxs1ayphI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773187902; a=rsa-sha256;
	cv=none;
	b=sEtmbOfri8L02viH+AwxtmQ2nQ4hUoOPYwPONZfwWZY1g56EqnDA/6k7zNgy0zTFQmYP/g
	+RmzYI8JFmdU/XuV/7lYDb3PhKX6k83SQKjQnLx5e5HB/JRqSX+fK2OtkOX7LV09NY8B6x
	eC41m0w+rfXd59eTFCc45Yk66qRGmKQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=rsZWNNzp;
	spf=none (imf14.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=7hV5LSkoaULvfWpcA92IONFe2jiU8FtnTFTGMKYHxiU=; b=rsZWNNzpN6nJksHTEkajq/n1Fi
	36oPDej5oPfE2xw7j/8liweJ40O8Y0rBYAawwkQr0/sJRg1ts8hN1ZWdPPuu/S+9wTI5BZjFWFDn/
	6VM0HaPK6l/WG/KwNwIc0bS6+oKrv1v0dTQCkIL4TyM4C1voCXZuHAyDW2/Bgql9xoNiDgpnuxFbm
	Bc71fMVSzRm+pq3372pS1Xq8Ouufm8Njzwja33Sc4G+rmZ9dNuCAJtMq0TJedL4OAoV/4ImwmK35b
	TUHQq3VDfaWDfmQ6l7uWAqtoP6Cr7hJRMUWJfb9Rs80koZ5DcRmLK8FvDMNhR9mVwMAz/6MWBcbRm
	dCGRuMnQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57602)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1w079p-000000005ZQ-1adR;
	Wed, 11 Mar 2026 00:10:37 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1w079B-000000005hV-0rNO;
	Wed, 11 Mar 2026 00:09:57 +0000
Date: Wed, 11 Mar 2026 00:09:57 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
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
	linux-sound@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
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
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
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
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Kees Cook <kees@kernel.org>, Tony Luck <tony.luck@intel.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Jan Kara <jack@suse.com>, Phillip Lougher <phillip@squashfs.org.uk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tejun Heo <tj@kernel.org>, David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>, Max Filippov <jcmvbkbc@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Jon Maloy <jmaloy@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	John Crispin <john@phrozen.org>,
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
	Heiner Kallweit <hkallweit1@gmail.com>,
	Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gregory Clement <gregory.clement@bootlin.com>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Vinod Koul <vkoul@kernel.org>, Linus Walleij <linusw@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
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
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Justin Sanders <justin@coraid.com>,
	Jens Axboe <axboe@kernel.dk>, Georgi Djakov <djakov@kernel.org>,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 00/61] treewide: Use IS_ERR_OR_NULL over manual NULL
 check - refactor
Message-ID: <abCy1Xs9yQx0Sjbn@shell.armlinux.org.uk>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 61E1B100002
X-Stat-Signature: assjxauqx115ux9pdjxan3xx3k4fkqh3
X-HE-Tag: 1773187901-336579
X-HE-Meta: U2FsdGVkX1+5CMteODhpXrh4MorXIJiSRRS9X0GoFQniAs6wsXucpOw1KkzEBh3j95arUO5cdXs9k7JGyd720gfKZ2ZZvC9ednWvJtQKmV9bCZn3dVS6Xuexj5JSBkwfUE8aJ+Y5Rk8PJ1fEhUbclsP9s4bQsC9p9jrN6YZ+E34K9pPLIAbZewuhO9kgeWS+8ciN4I2F/7j939vQNMtTXrxjaKRXbUFlYJAijW4hKkdI/XiS0rOx3Chpd3SY2Z75m90BmxzBkbfVRi1ls6wbbd6dp8zfN7Or2YGF70NHVV3265ozy6BiQpxrziE/aaV6kIqo4znUC+aUp1K8SPFKEw495NoMWEtp9vOZVgGMqcLPP61KhtEWaADPX7QH6v3cXpKVMqgnIYf4/dxGoCAnTYrPfGlA2iQZlL2QfvV8key8Vda+REjYhmD3z07ymIhBKMsVt/CrMWUIUkm7bXEMcj9bqi+e/6NzjoQkmKmer7mrYH9sePBd85JOQghtRpnP/rAPAOlhVovTkHZlhQ0O3rbtooKhCx6S1l5t8Dmj3I9UBvc86CAMRsIAn1eOhhH39+L2/kday2UKOUmJjnSExbLbeo0ODegW5jC1/r6aLptBFgnQJ18jiXhKfJSK0tOErAwlco91Zhf8w0q30teP2yPRnDntXfLBua9jCL3flpBRid217Jo5kawuze8OgdZIZzEtK+khMwXuujxyOB2vqdC8jOcrQyjaA+wcyii0PFiAYolrN9gqLg7gXc/Kx7W8HORwztVVDU8LMwyS5rPisSFhgKz3MYBeQoBUQvpk8Ce26pe18n9ZmG/gcYlIYcW2XpWLHIAoy8swUWtgo6NoB3rPtulqLEEjpHMsMmVWZ+VxSGJebKCX7u8mteXOQPQdlmdApkvNHa8CePNhPBqDHIp4zU72rCbyALDTlBKuCID8tYj1WmpF6g0NLxU+ERVHLEJXooM9P2DK16rzuIZ
 TbXNp8D5
 a3Ro2BEBI3XsgSqDh8jatwAQqGCIwVq7Z2DraOGSiXoaegYAJqAyGxNIH9jlYir4+M58cedyufjlO9fKqe+ocnts3RGaNNyZCBNH4Py+LnoLJrgcepwAEjQ0ZSEx6P48MZdkgsfEcTCM9MopyW8pZRsHRkPR+iqmUe39x7LKMSsLTaFmBdD/ahu6ggyh12jVRzhbB1qSoy4NyMdmOa1D5HDhfSRd1IC96u4O7tsarQ/J8tZF/yiu8JeJsgereQs7PYzj1JUohSfJiKj7vqmFRar952UcKVgwRGdcUB0XQvP9ZGEGpbkiAPf603HJ7FVIWmE/9hvPMo5VVVNGbMZ60rRWgi1NuHV4fxwZnNk1gf0zNoA6qxHaUMi+ftpHHMSEU4Lr9oWsSQcsPShLCaB0QiqHuWoP780UkFOIe5Zohf8GKd4JHxJpXKxTawU4j0YyyNOMIZ6ZKQK7JKitR1Mk1K7gVkgBVwX2PI/vKG8sdqyym7SAX6tZc135jxtqORfqzbu2u6QN6F3EwYH42YSwKrOxxqy2E7EYKkHKW3Za/qup+pxrK2jHeuzR9N8pr50CFurlH99DBfNk5LWmrEwjUutal4WN3kxnQjLbul02XBQz4fwc=
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

One thing you need to check for each of these cases is whether the tests
are actually correct.

There are certainly cases amongst those that you have identified where
the check for NULL is redundant.

For example, get_phy_device() never returns NULL, yet in your netdev
patch, you have at least one instance where the return value of
get_phy_device() is checked for NULL and IS_ERR() which you then
turn into IS_ERR_OR_NULL(). Instead, the NULL check should be dropped
(as a separate patch.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

