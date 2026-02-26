Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE9BDFD9E1A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 22:52:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CBB66B026E; Thu, 26 Feb 2026 17:52:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14FD16B0271; Thu, 26 Feb 2026 17:52:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B3F6B0272; Thu, 26 Feb 2026 17:52:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D62CF6B026E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:52:09 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 87FE7160358
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:52:09 +0000 (UTC)
X-FDA: 84488107578.18.EF2B28F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id CD6BB160003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:52:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EWJc2Uz6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772146327; a=rsa-sha256;
	cv=none;
	b=nRjIwhIJ4qyehPZnh/PnYJXnucNmDX6hNF4Zu/ywLZZNXTH4Bu7iSB8enlskE+3YS6bHhT
	E48UEEY6QPKeGLDKHtbYap1LVuCbmI5jd2nvEC+E8nwMTQ8cG7/4Bz33TnwQNNnUhLH76H
	lKMvRpowvHU4wHiIVsutfkcNMLawDP8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EWJc2Uz6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772146327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h05hljcobI8xx08G3rYVu7XYlmD9xj3EK6/LsmQW+Rg=;
	b=kJ1x8uir3MW4SH0kSWVaxmezp46ptaU48vkO5LoErxduuVavp8CnZCt+36Hokbe99ONN00
	ibMyCG2leRL7xVecFogWh30Ni6TXsd4warogE4PHLkaJrVgupoxOpuxlq5B2vQjXQbkU7a
	bSZ4uQUmV/fZH1jyAEF0CRDbbc0KCV8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AC98060054;
	Thu, 26 Feb 2026 22:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F89BC116C6;
	Thu, 26 Feb 2026 22:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772146325;
	bh=pajDmz5yp010hi/+QMkuQbHFrnu7ZcaVGRjn0wxtp+k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EWJc2Uz6oM/U5lpFUSm3GfVgR4cldZrHPbo/JbNPiCo7a9Qet3NPwP5d/g2F9Z/eY
	 PULzCCLSyJn39yRAPsdhfy+RdiF52vi9KQubOdZlNMxkN2YEKcSZEHQQHEwBCv8UDq
	 aUBFV4GAaYKK9ceshTeB/l1Olc+NGJM3RsiAcavnfuqg+7yXrgam32eowwkzRFvJiO
	 netZZv71AIv/PMFlHfmi9NAn7OA57Ds8pdoFOxBLCi6KvwtN5EM8l5UroXTz7+zS0y
	 Jdi0ImLclB5JNz4xYwfY9d0QUSMNEpHwhSScYgT0H9rCBdMCBOXzjYqnr0oZ0b2JRV
	 uc6mB11PL9OGw==
Message-ID: <104bcaf3-42ba-4eec-98c1-fe3afa7fcc41@kernel.org>
Date: Fri, 27 Feb 2026 07:51:43 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/61] trace: update VFS-layer trace events for u64 i_ino
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>,
 "Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,
 Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Bharath SM
 <bharathsm@microsoft.com>, Alexander Aring <alex.aring@gmail.com>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>,
 David Sterba <dsterba@suse.com>, Marc Dionne <marc.dionne@auristor.com>,
 Ian Kent <raven@themaw.net>, Luis de Bethencourt <luisbg@kernel.org>,
 Salah Triki <salah.triki@gmail.com>,
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
 Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
 Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>,
 Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Yangtao Li <frank.li@vivo.com>,
 Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
 David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>,
 Dave Kleikamp <shaggy@kernel.org>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall
 <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
 Zhihao Cheng <chengzhihao1@huawei.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <jth@kernel.org>,
 John Johansen <john.johansen@canonical.com>, Paul Moore
 <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>,
 Roberto Sassu <roberto.sassu@huawei.com>,
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Sumit Semwal <sumit.semwal@linaro.org>, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, "Darrick J. Wong" <djwong@kernel.org>,
 Martin Schiller <ms@dev.tdt.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev,
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org,
 v9fs@lists.linux.dev, linux-afs@lists.infradead.org, autofs@vger.kernel.org,
 ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu,
 ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev,
 ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org,
 linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 selinux@vger.kernel.org, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org,
 linux-x25@vger.kernel.org
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
 <20260226-iino-u64-v1-3-ccceff366db9@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260226-iino-u64-v1-3-ccceff366db9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CD6BB160003
X-Stat-Signature: dwaiqp99iy316aar16apxxdz1hadr7rc
X-Rspam-User: 
X-HE-Tag: 1772146327-915670
X-HE-Meta: U2FsdGVkX19fnjM/UvG13+iNvZEqTKAF5EdPoz5n5KpkD0eIOIXEAC3z0WleUA+7hLfjgrkj9OHXAx6UqckmbguzAthe7wFKllt+DxZNx4A1B5SMEL+kr6YmkDPfPjSD3CJJ367BweMhgJX+mhnT9+p8d2i1OaW2w+QqDfTOGs4K1JP1N+eT2EUD0PGNNik5iN50/zRjOC0Ft8CO2TMrZW6PL24eAFa72FgPAwCmKSGjm4/4FIVWTwFulwmQDtJYzjxZ2DrFwJACCe2dBnBHjX07eEkXWEZh4wXw0FrphbxYEWHfuNP9Ea9xW5lxyKPJHKS87BabNbAyw94bofqIuORrAwzcvuUloxrlHUMGDG9vdfTCMNXqFxfFo71QvlCGzV6rjow8flTBBAfHo0W9uq28pfH4fnWmSK/Eef55pVyLZHXF5vEpFordRJEa50u0nv+FGiRpNWlUZAhJkOiYIIul1UfVAOtKy/+J6da7fEZQOJtTS4WZLnfKIbE8+goNXXJCwCeU2BY30uh9jzO3zUclpREgGSBRUjXdpjbLjfsIYfghtyKIpxeUfJrWGTjadXgeHZZmlzd9tIVY+gQFSYKWPZWkzThz4iUoPS6iFTlvb9rz6IOASmTQbsPO3bZ4Uc1O652jzduABqWGJioLYqar1jmm50ydLoy13mJ2i7KQ0LztHBG87qVHksSFF2rd4I2UwgyLLDk+BImRTeIKZHdns8sUwfYAu+1l2Un0y7Wx4t2/EZoyGMvNAFuiSp3FHYAIODdkmmmOyxY/z/JeDR1jIsplWabVwp5I6/CQT+wVXseJD4iGQg0LYN3zgOfPPTtuTVZahTNqH2mTdTbflmfF8lk/JmK0EEk/X5AF+6+wOWwtt8ap7g6Nh2NVInW7Dt7VEC9pfCeiaNpr0ODB79rU+lYtQZvWCgmZnSs+XgY16a3AhPdlf3FDtfdOGZYstZWXCVa+HAPgFRzQ9Dj
 /kiUeUxg
 6HN50tg0j4mGlwPUYIOn8/9mxWQcbKCuTyhQH7QivLGV355gXeG/Spj14HPeQB9rLP0hkr5GNXwevhdZmY2tzDHBSeP0PaESsayPqzrl6bwgVDjiI06Py1bm2ouE4b6eB5izmaZZiTacjLhV/QlMFdtJbWiXETkMt3SUr537uqYkudBhebUc1hvbKIm4VeSgDft38scd8AkTZVurogD+GHlNX70ZMiDk2ef81eIr476loaJkN0C/PFFd64Txd/5WsY4AKX2jcPeKoRTVG0kep4a9PCmKOtSAHMcz2kSxegoSekXrKPhajI/U5FulibeJpcYttecVi5eoln49VlRKyp2rK7gVYWEFk0lw6Y1WWyBxuh92q2qRLr9hF2yYRPC0tCax1P3jTEjU35AlBo1810IziXZ4dOto2UJRECVV6JKMb/BdUJKDoohZmSAfSKbzkUFgaO9NniCH+78QVIdtd5a5ycqx/VdLYcSzOS6W90cclhw6qYOs/NNnKpIlAxdsN/NpelKQh0uhK4H8iE2jKc4imirSL3n1UfUAqfCiaCKYmzQRCOh/hbrb2PlDRrSJApgEQdsPhibtWgxp94CQM39UMvSkFBxzVh2owM3rNlI64NZClVOk7/jvx9E4vR3G9ixIn40h5D/pUXt30TEWpseZgf3UvJDietGGueNZb0KMnZDDMd6sZve1XQy7dEfbbN2KPjty6NGSRf8T+lVYUvkW0Tkkp3MMI64DqKVg9GT4jtGWc0DkwRAy5UKqwFuZ+LR9rqdZgsenlHHL8d0FOsor4AEg9U2Vi81a5AuW61fV7BrTcIBCFysZBUMOdj/iqDKuKkw2oUyY+4fRzE6xPv0zOkUJDF3vzKgZocWEiNp3ronHaL/xoKwzVTwpftVxy/C4t+jocsl0Qc2qWyVE7Y9D7Yygk1BGRPSpMZnTbNLKN161UzbL0t3k854T1941k39iaYDMwqh058dpyu3BoZTf5k8UD
 /82Ihkhb
 +1IXYENhOaPIgfStLWkzZrTzfnSIVrONrgK/UqHC2ycmS5lpDMiRgMd9bKhdhFzjJL/hmCIP8gkVXhYtzx870nJArxJXHcUTUYK8BfNhcxQ9lzIBx5OMcGwbTAgT2KevVkDdZbvBvzGoxQE2dRytPMuErqXYwc0c+LcBZTh6REstPjvuP30olczt0cxI8MdWAe38PpQhjWwYjabii+7TgJSvshdOmYRxonua2TItVfTHh4nI6snGob+qPHk7fv9B5au2GVCKJ/32P45O7obxfsAyPVrPdp+kvo+JQA0KaqEfMOUU19renR3au+dEXP4vts8l6LHZI15abS4hzevfm3+902HRJ9U/q9mQzEpzIzeLIbFhPBERpjuWgexVUlRomgCHKYXzLJ4Wgbls5LvJQD+C/BKrLPSPPgyILIn+4Xj3zB4byxpO19ilZWhpIrw63qVRuCBuXrJhu9p9t8BWrglzg3AkS/24EhkUsPOSXQyDpL9ywnxLpSQw+TX7rS+O4dGt5k6HgVAJuhd3TFewG0cF7PlRd03hdsMqI+QRN0kCRjy8ttsDJ9buJNKpwYMKFyixMpk0w1V/hVgHWj0Q8F28h9J7Y8mFnfBZpk4D/4JaLZ6Q6/oBxRT8q+JAiAJlsdPSX4gZ8YQ0RpmVQWdDF0Mf4dVoZx89DrvdZ2tWHK4G0imRFihPhhEVgzDMnfZPRSJg+lRiD26Y7+AzsV0eKKOjkOdj88dPCgA/EIrJ4WbtL7J1oLwM1REDcnXpfg5ZR5ws2m9l7hoGN6rfmzTIP1DRH4F2EkrXQu9uhQhU339kwP+eeJWNWW+v8oYekEjsqTrIe6WFfwPZSJejlCHP1Qd8UsXJP7VreEtOcYlTHoQjAj9osFYlwe52/VZl7LDo2uqHzs9Mv6r1nyZSpGLPJYSlF0tFUOZWtdoUQU2mwh84GK7JBLz1V1KroOr7Hh0m7xsGU4BLXQpf63zI+TWrYPUWEst+n
 GjfHpmjc
 oOFqTdlq126caoHzPe5nZR8ASjekYXQmn7Xp9Mk67C5+GYBvkUFWdQYxKFRc2nZxVy/uRCBcLm72zGznRkyFfh2zPxx6LTG4P2vb1MF5+bC4ZOzJJzbFGXTygAVPDFBsBF+YVrag+pojopDvtL1An9DEYtus+XrXWgAbOPOJFsc+sDnH4NC5bkeIdIQeNr7AQcOoA9yXrmXjuICSGY4IAr/YjDIHNEXTT/qsQGZF2skmzBohCpZIUpRhAgNqceoR+kVAm6MElMX+9zWsePybB2VlFzoAb6KsIUAxYdoYtg2Kc7TZ1FZH01KXR8RDqPYeggL4C5hhZxjRxdy0LeNElEw2FzFC7094jrm+JIGIy8iRsYZY9wJJazy8GWqYRMzS07nfEZ/yc4id59X6YXXo/mIckkqGkW6GSraQ5HnHRfjbIDish0jBDtVJcL8zhHhHMJY6SFkYfhdAYHsVNHkxALWXJQtVikWymgiZVcO/hMkb8K7C1wYSI/PnGoxbvh8Mv+myZRpLl/TdSMdopVykokg7VYhlzT+I1KjsxyIei9UK549t53FINqdo1IElgYyWtFkw2aPVyR/etqQ3rwuIAMeXXGKRBYet+S75SkxpP9ZpW150X+7AP14asLr8tBGniFtb8c/gA5tlwRVRoKvoOp8YieiviJ/WcCuYwPjnEfa4pp3w25FLbYdk57/K0UE+DZkRlh2CQ/ABLAsgtfZXOalMWagpOUrL8N7UUq+0CuqSYDQmO8a06qyF24utTVvs451J3LefAz5d+ni2kAhwxPnSwMP32GsvqwMylo6fJzLr8rReJUcFeO0CnqNhTDIuiyhOTRRx++T8lW4hzt9EeoZVb+JhzDvOCSgsPOFfcljnPhqgcW/QoHGJ8+e+R8nei2ESplUq4tL1AkL8pC3Kv+bBSfhVKaaaj2KnduYlzcPtuRhTImfAhqETJyC4erGqt443uFTezhnDk8kroqKianEN+gXwC
 nCWOBZ+o
 6PP2/JV40Z1ka+DqDzTN2YzTRn3mg5zFU8/9VihMfXR9eGfWewuLvAepCAKQu8ZZ4iGDwG8wj4lvzyAk0s3vA4/PMpTlXu3dB2zOVFH4bT9NMFmFUMCVWR70xnqZnCB5Lx7pSOuQqO5rBW/vahXaaSwpQIwGGcgR4uTnIUJxBL5jEkfa+sG95h+IkR+R/cwYAWLvDccEg2LAa4mlTaXtatDQ+GF71YMRd9S4B+54jEx5miBOHblvwqRcyccdNujM7n1vUnIBmNllCLs1F//h5HOKZ13G/kVjq2ZKjKynn5x9vhCBxdvlIcl4H0NfVvcqm3LybNaHXFNlNOlSxOeyuI+5+E1XedmyBQ22D/3Hg1dE4VDGym4ecyicWw7y6XqVTmuo2d6C9r5oEszTedcWUthNC9A9/YHxo6gpnHqsAxPJKOEAOU6GzV5sJrFawrDKK3yD4atghljKqVzzlDuMp6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 00:55, Jeff Layton wrote:
> Update trace event definitions in VFS-layer trace headers to use u64
> instead of ino_t/unsigned long for inode number fields, and change
> format strings from %lu/%lx to %llu/%llx to match.
> 
> This is needed because i_ino is now u64. Changing trace event field
> types changes the binary trace format, but the self-describing format
> metadata handles this transparently for modern trace-cmd and perf.
> 
> Files updated:
>   - cachefiles.h, filelock.h, filemap.h, fs_dax.h, fsverity.h,
>     hugetlbfs.h, netfs.h, readahead.h, timestamp.h, writeback.h
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

[...]

> @@ -726,7 +726,7 @@ TRACE_EVENT(balance_dirty_pages,
>  		  __entry->pause,	/* ms */
>  		  __entry->period,	/* ms */
>  		  __entry->think,	/* ms */
> -		  (unsigned long)__entry->cgroup_ino
> +		  (unsigned long long)__entry->cgroup_ino

Do we really need this cast here ? (same comment for the following events).

Other than this, this looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

