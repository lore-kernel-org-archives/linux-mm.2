Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16634FD8FCF
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61F806B011F; Thu, 26 Feb 2026 11:21:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ECF06B0130; Thu, 26 Feb 2026 11:21:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8606B0152; Thu, 26 Feb 2026 11:21:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 389B76B011F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:21:20 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E829AB76D4
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:21:19 +0000 (UTC)
X-FDA: 84487122678.15.403D745
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6170D40004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:21:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sDDw8eYq;
	spf=pass (imf01.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772122877; a=rsa-sha256;
	cv=none;
	b=3hZdzSJUmgOhKNAx8WSu0XIyFUc7/GPeSV0BMQ/3n7bzK4DvuXUPE3tgRvgL7ShLZxcsy7
	dqwRi6Px7ExxVr8jjfYfDfS+bnI2KwwInYFmeg/Isx/sVQvf2vTHFN+ulCrVToj+e1Hvoj
	1gcO5DL6aYdpy0QRSmPmWlyJwDmlYtY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sDDw8eYq;
	spf=pass (imf01.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772122877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVB2nRE2FG3NLF9HZTUTaFJC5JX8an1BLHt8rWCue3I=;
	b=2JO27IiFOpLdC05MQ8cbidltIBxeUfLEWBv0AaMfDTg3WTMTJV4m6Y2nE56tYx0NAB0ycl
	gpxEDETPbZqtPg45XG4Sm7oiHhFHs5XaRAmQ2UuyfmuSToN+6wFvJGyJ67RDwO1WeZQ9Ch
	rTgum9DChwVwyuShXJ9xttji2CToy2I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ABF7860131;
	Thu, 26 Feb 2026 16:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C94FC116C6;
	Thu, 26 Feb 2026 16:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772122876;
	bh=V1fVfV5JdygsYqqvdLgkTi9eHo8yzA5OHJNuP74kT5M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sDDw8eYqwACHaj4O7vDcEY3Z3DSJW484PKPOPXOKy0boTF8UTmzICoiE1cyykKiIM
	 xOBYZnf88DGWi93IfTOYIQmn8jqOXrSJr2ShZA56rqbg0hmfpRiu0o0LAQFqCN3kbN
	 l7bFZXaFkR1tNue7G1SE2sRPdcliKClo/uCAM6VErQTG1ybCP3jdOu/hVxSSjxEks3
	 VUzWScs/xItv1vurP+yGi08YkgXCjGpKTqvsk5MSnA/Lz7IU4uGDaXbH0vz/GujZLV
	 De4HiUvA9a6pugKUqRxzcuDcG+x6k8c7HKvA0XOAeCpB6hQxZsN26OBFzIyNkqkG3n
	 aZJXtG7dphM0g==
Date: Thu, 26 Feb 2026 08:21:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Steve French <sfrench@samba.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	David Sterba <dsterba@suse.com>,
	Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
	Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Dave Kleikamp <shaggy@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Martin Schiller <ms@dev.tdt.de>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, fsverity@lists.linux.dev,
	linux-mm@kvack.org, netfs@lists.linux.dev,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org,
	v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
	autofs@vger.kernel.org, ceph-devel@vger.kernel.org,
	codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org,
	linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-hams@vger.kernel.org, linux-x25@vger.kernel.org
Subject: Re: [PATCH 59/61] iomap: update format string for u64 i_ino
Message-ID: <20260226162115.GG13829@frogsfrogsfrogs>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
 <20260226-iino-u64-v1-59-ccceff366db9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226-iino-u64-v1-59-ccceff366db9@kernel.org>
X-Rspamd-Queue-Id: 6170D40004
X-Stat-Signature: t9ba8xrom3xmrb9hh9p8osppx1hatzwt
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772122877-410122
X-HE-Meta: U2FsdGVkX1+c1DgpbH+ck+LOasjAjDTJlTqkbXJSIGiAU8x+yo6IqoJy1k7YSsFXIQJcY7nuwMkJfavlLAyXCxs+k5a4KOBSsEEf6YuHI/w82cuLqU4yj8+mXYDtcMjrFZZiflBXB1nwUoh36VSU5PMj7OwKOdBFZ+liRcO6lG3tQnZIPZdZh5hPSGrbhVshqH/+jRPpcn4HG7Ii6gAlYuzNVA6PiO0rVqdXcIU5nz2LFUWROCVz19frztYrXQbkygpH/1z7H5xyA1hOAgMyx7QzGbrMwDgJJq9zQ1ZboN/QQRvXDZ0ZoHhzkq+rMdHy+ddNNlQtplE+fXIKYe/F1r/7Bp/7QqxPRJRxd5AF9yz3l30izjCSh0yBS83+K1IsURaIUk4VbQ7R+7BFwgFJ8SsvEnmmwN0xwueePkHZ5hXHS2jGWLtEGIF/RVsAuH8al8ZhwE+jvRgIaHe3e/8xVxavVkKfqBiaKsTJyRofhMKPKB8B/7jUqLpQWi1yvI3STe/xBYCov83Rm/2yamOLSCAFXrAc5LtJ1UnWv2SkKpSqbUK/FNbFOZ9NUaKtyL0CsqcHhw5gEkQZK+hACYx+uuamDEwZc0D+Wrac8X2dTegvZx/SE1gauZAqnHKAcZ19Hm7nRl1OM293d7RufMFpyJbU5WiadwkfaISYeltIk/6IvPYVV7vvaN1mGOcVM7Bc24xZzNO/Kr6EqjJu5BNkrd2MIVJKpOuRGcqXrjttAmdTpTxpyN/q4pWPxDbCrqBaqhGIm0ElAOj5sc+YDU+Byupci9G4dZnLkYSRAEbWw8nta82fJl/47rMGMTJ+oDGjwWbslhZdVus/13zJsupPGr4LnTBuPcNT/sRX8qb4vcHtuwnW1+MdPvU7tKzp+XvCFxkj2WPCxHYUyCeHnUewSdF11jxJn2379r1De0JBj5eKTkKJjAPD6WS1/iv5CR4KdZGWCjmQWMFkJ/ct7wd
 vIsmN78/
 EKLjQbu3CJDs0gISkMEAdgPTd6ZtvcaTmNhWekvFGe6eb0ofdNGnP2FcpXKuSCdd3jKPmFJ+a0Ep1MFOe50cAQ8UBJAmo7LmQJ9QKeoz0OlyKPhtuuudV0b5Z+fIA0onXt0GiEDJ/X8JX9CZm7ITrXYsR1SJD3smQNw4mnjYL5w7CiIdncThAsmOgZLYvspRLQLlSF6ZSWjVSkZ27L023YuK7ZdnZmtKEEm/CnRkx6YslpOa7zSAo2rzZITsdCLVu/hhiTZap7T+SIvBxX3pY9i59MIDMlSyeJyvr7f8kbG2cMKBW7KVtwXFL/5Qbfl99cJCzN9JHvy5RXkdcDAFkC6fxsVyl6cuUVUaRi+EE7GaaJ7IBOv98f/c2kQLgyuuE1IFU1ApIxs1mJUOf4SPj2hanNnDpjhe5sDN6MMmjHc9c9O2f0cwxkvVI7tyeGAszlG6YG0pNGm5IAq36+X9O6UypibOIiCWQ05weoqzRzYMxwuFymbSftapatugxOUWxetgPUJBMX6s2smGA+C1Z/SsQjOrGxNo8ERWhtGi5ErGRapJmytgEUstUouucmG/ShyuwdgQFEJUXGOB9kNXlMC2aU6gQ4xNltiXw7QXj5byyNbmPIAXUYGeYPvqjIywXDQYwLD+cO9CZeDi5Px4khQ9JAnKSBo9i9irvypeNmpGrzu6HsHW6Oo3riW6SsGTCuH4MvxlJtVlsgULoLUulc7yb8P825o+WN2DDGelDjhnecEnWed3U/RHVwfKfJfVzhjErOA9SD9vp86rWDpWMUp9SeHtHUy+Hq6gdPrFCWJA3c+fdUBDCxNtIpArbFgEgaJBotfnEZ7+qOdrIdUZ3qp3A1W6fNxxDFi3n30L6SWXuS+gy1OIttLYED1z/nE2h7Vs03VCvFaZesiEgyZDYZwEbQmn19ixW44Zo/Xhf+evrfn4YSUqj+hyHU1W8eBKMXV1r+fiidjBHGkO83FFFA0OUE1XJ
 +1mrhlcI
 Mc+E/m6r4WlPFIGpfpLD7Bbb+aKMt+WZ+SuYTSaj2RHgZyEpjDfYHfE488aSuZ7TcE7re3YOMHzRY50sQ4Hz04YbIJdGhyanV0tCZ/IO45SfS5PAFeQbADkAD6zzlNWqTG7lu8mMA1Xf9CI882X6+JsQspn9QqbDjAIsEAQp7q/3dw6KudX4uuDVggQJVJK+whREIA44LldjlSE6mC1uixXhf8RYHeQk1LBt7N/x9FPo2ZfYU18CcIf9DS8wqevZofeu9sBdY4FgCmyE+SfqDxkDtdSZrT8536GKlCGs4HNHYSfXMOtZ4UMIHOTVzzFwu1FBbV6YxVj8D/ASLcoqbhO6I7BiQi1aVddUkFdloc4TJ/1SyFBgwwT3fEk3KBi6j+6q2f/L4mRdif7uNlQKa/G+aUB0/9ru38zd6qwunW8ol3DHkGuDY0IjHcHaOXG4kCzvr5E+O1p02gIHiOIpykRT6FKdiPGyRJObj1wgFZfOwqyT/t+7P6sp4kgmc+z42JnX/9oDdDCfTA338QWMdpkmLf3VZ4QGqvQcItNnSGDLNpwXP3b3Y4cKpneEktF1vBizlvqRgQyOGAs0i5dvDtTmWQPJfC51n53DYZPCOeb6WLmrianzxT4yZpcNmT4onVsvO8a1R15bnu7GabFBNlqBulw/3PJjLks6itYDbB9+pXcLoOhtf5RgMWQvhabFg0VVDykiwDJgDnAXA79G7mB0klRoLm3El+r8OonEZwJSG6p4H3wei4lfJzxLUltGkJcIV3/NhMubNgFcqpKTI9iBIJkHmgb4aZ8maEyDu9w0TncxehlpmPjsLczGBfOkc5ulbuSxEapFyq1DIFEdcO2+Ofdlw7S3Rn3yC6kps407ez9W7rRd7jX/2ezXOELlkqXG5o3pt1UN+ujWF7MiIYMHqg8B+9cPE+TYJXzxjb75fqKGct62uInd4jDXmIU281Gv6yuGHt309XjjFtWyufO1MWU6Y
 0ob506dx
 dZnba9nWqWlF9EWrrWed9l6Yt+cUSL9s4pF6udMCIPpVduiFo74h1iv4r+F7jqiYApMnBvUFOqyTJQ5v7visLJpM4r79cD65QniPikwGRJOu4cmC9WFD4/HAWDyMAvXwNfvsrS6vkMWA+hH9AoLAKkqjLxHZNVxN8cvdxyPzhj66AFG14BDoT2pUxvjxIP2owy5IpQFPejXepVUq+fKbzcGY/Qp7/iAVEHH/1CHSsGhJu86f8OSL+CjHbM59HYswOtC7h4ujiA7VGKF5eDkt6XlPqJRjFskn9HmgLYQKl2rfncByyelxBuVCwn4QZQXfJvJx6I4fUn4ztKnhDx6Z0eO/qrquwMq1+uyYyy0QDhXWv7pHsFix11dwQqLgDBzdH5tg9kEPiiXsQ73BjvVZOw8M/pFqCuYOM+X/3siyy/0T1xOSRonEZUu0HN51wMmeHedrTJqqDdsu/2nJBZMuTylAbJP4KzFH1Eo3LYH7UIIPFYedgv/mKXfd7jEtJv1DxLz+WwEKfGwwIv4SnNqKHkQPYqVPdq3rLWnD3Nap0pF4LVabPaN99v9ScJSjZZTH929F6d94AhJCh4t+9nqIWZNeX6JG4QODrK3n3pNRxH5sHpiPE67I+amWGjDguPwS7toq4WCvVE0azPKvFnu84NNr6XtsVPeGaslbjKwE0hzb+llgTrX/HuDi7h1kTQE6ayzhWBHz+6eUcQHdZkNzWhKar0M99l6ENoQH2XWofNrPh5UnXRlDUQ8P7XftAYAWCYSCdDxIKMmWHUUT5buoMsYFOimoNGSrY6DDLbyYkbO1QyGf8F0Ixqz1QWejLdL5uR3KZhiJBGKWCMwWUxKxj8Kq50XR8puw085tJiVdO9EXIbFaXr4UdpeToyXNyhBJb2rZPNZgZzgTjV73SyV/f/j7wKhZWFwUJPcUCzs1pp58PWXmh1ucZGHUX2C4LnUvgNOz67nc4T4l3Ofqoz8eP2kZSCv2m
 wvAHq8hg
 4kyizXxLjl2GfHhsbG0AXqGrqNgkM3Zol7So2fARHy+5KAHEmwkpmfMurEA2SWKhZuHcuXvopbw6qFP6YfyIstMlhRzVLx416PQZeBMPorKYigJ0Sqk+2vbyXHGtN0nIBk1G/0wJA1/HC0xwcQy3b0kOXURTmNBY1K2R9ftCE+RavvBlVBxGcxivE1Z8jQykZqyVuW+Pdm3+O5uQ8TIJP43POzBG21IvTfjWjysOdUCme7BtJL14E7bNGtzu8cMGzqiTSXPeXz3C3dmSARfk/wMbaZVLNFjTkCGjmJRtTtEun+vVLYYkolDF5Q61ZBolEgwQPfiqbUnJF/mTEN21BELMRygRAgtoX2P4emjP9ZRtV6QnoWMfYAiQeeEwDqsmwvnNpPbntfc5XP3MMSkMIJdi5sOOrQ02UysWaVJT/Nhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 10:56:01AM -0500, Jeff Layton wrote:
> Update format string from %lu to %llu for inode->i_ino now that
> i_ino is u64 instead of unsigned long.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks fine to me, though I'm a bit sad there's no xfs_inode::i_ino ->
inode::i_ino conversion patch... ;)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/ioend.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index 4d1ef8a2cee90b91591d387f8e1c3f75350c1da0..94d9a3c77bd68581d752fef4c16b88e1cb5f88da 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -48,7 +48,7 @@ static u32 iomap_finish_ioend_buffered(struct iomap_ioend *ioend)
>  		mapping_set_error(inode->i_mapping, ioend->io_error);
>  		if (!bio_flagged(bio, BIO_QUIET)) {
>  			pr_err_ratelimited(
> -"%s: writeback error on inode %lu, offset %lld, sector %llu",
> +"%s: writeback error on inode %llu, offset %lld, sector %llu",
>  				inode->i_sb->s_id, inode->i_ino,
>  				ioend->io_offset, ioend->io_sector);
>  		}
> 
> -- 
> 2.53.0
> 
> 

