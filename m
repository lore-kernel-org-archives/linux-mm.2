Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 166C3FD9E1A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 22:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63A946B024E; Thu, 26 Feb 2026 17:45:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BE526B026F; Thu, 26 Feb 2026 17:45:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467FF6B0270; Thu, 26 Feb 2026 17:45:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 21E176B024E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:45:59 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B732B1B7151
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:45:58 +0000 (UTC)
X-FDA: 84488091996.12.E56AA77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id CD6B518000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:45:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BwPRsluw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772145957; a=rsa-sha256;
	cv=none;
	b=ZYtC+s4xsd68YFpclp7LAa9KGiMU7VJ3oGlFDieYWsVoIrSyvc/ma7+1bTXtl9trpNx7qm
	YWP221mn5pzycL7mJ7sccCbXVtOZUCcj5NNvslRqZvwDw0qfsIm2KbQjHLzquUEqmjRhFM
	BE/ijJExkkInjtPg8j5u429T7nvunzw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BwPRsluw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772145957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yXWYkCipmViaJB6zfAc5RVRD4qsyFvOR3wYfVwLbUNg=;
	b=ZUpXQEsxdbjgXKu/4BwbUmGbXdcQbpxS5NwMajH8WYRHHnSZGGFAjmsvb46iAKBrUUoTAM
	LAyeJkrA+KZ+jnnOOfB8QuttF1INr3mEDq04eboU1Q4ciFMRb5tgLtmzIrLebsphv1zqGc
	Ga90SfLLHO2hmcij/cPRXMBLc8ladEg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FCF2443F1;
	Thu, 26 Feb 2026 22:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE84C116C6;
	Thu, 26 Feb 2026 22:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772145954;
	bh=6uKDFBvN4DDY9XeohP+RP+WtJXai/wgD+w8aBy8ELuI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BwPRsluwO3QANQshXwh32wR+hN95/ZQaqzcFJ2RER/i7epF+sSCYFo1KMXHOGf2R3
	 tsLZpVKPhp6IYFncinO3pBIsCgu+rwpVvIo+0zjgm2iq8YIleJaPf8qGesVW5FdwrW
	 Y5g7WUES2Mh6BiqhQR5w2ll+Cp6d1rgxOG/dhhV4E6xF4vMFhgwVRQ/1Ucgz8zHYT7
	 7zI5Snsyyyon3Xpvj3HPGliG9ZUJpLobrX1MAnnbxvWUr9WMlrzKtKu7XY0mI84whC
	 FEYZ5B/15gnGjYg5Ru8NFUa29UtrV2uULQrsiaYP8uXtKD59C94w045b6ZIGP74ugy
	 vi3my4tvrpUOA==
Message-ID: <6a5fb35d-b0d1-4d47-bb92-c176f5e12a40@kernel.org>
Date: Fri, 27 Feb 2026 07:45:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 50/61] zonefs: update format strings for u64 i_ino
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
 <20260226-iino-u64-v1-50-ccceff366db9@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260226-iino-u64-v1-50-ccceff366db9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD6B518000A
X-Stat-Signature: oohko68d6r6zokfqnp4mezoat9y9gc8u
X-Rspam-User: 
X-HE-Tag: 1772145956-980104
X-HE-Meta: U2FsdGVkX19uBwywW+2za2/iRA5PLSOwsVPmrDDmNq+fG3fszXqbWkE6VY02p/MuiDedu3cLPR/5Z6iYSO2ZLBvObwlvmGQTRLQoRY6VZU/J4r+9jv+x8hJWZqCwFOOuGchthCHkQzpe/kadzeHS+zwdJBsWyVu4hprl/yuid5ujjX3XJzmqx9dBAYzzNlvp3XDC97oGtumD5JX/EJrQgru6YbAVv498W+RmSYiFMRwZOLA6tEoRbg2kAumcOSPH/XeVdxay6epzzM/9iYFzjeSUlno36HJCfl/MB/b9lR8AgfLvcqV3MJONVzlwbXtTvMz7UYpsX/1X5wb6ZjOEBLdzIGh4PP5T7StaAK+qMlWZvhr/tSTCnEsgTDWQDYM+SvzgTaC+auNQWqlVG/VPmAVPZEDOhJfOnweBsuqdVNyDV6PuBom7s/tlv3X87ByZsHOEo7JJNY1Xm3F5zg6EEG0+lJ+66JfYWX0odIFk7WVkMcElRsovbHoCmZTBhMQ96J1y8NX+jCBXVoSYkawC3MXPsIprXjCTupw9yTUXT2gu2qiR8e85+CtUvq/Jzxd/xxUaxiHrqJgk3t1v4+RhM9iViKXkBUhz07qiqd5H00SiDirMhEmUb2h76E1DrK1j/6ddmZ5cKk5qcgkAIWXY92FK+ZjitEkdcC6HubCNNqmBzk2gb4kNlTRGLN4/NFNukMCSrq4MwpOe3gKIVMLLFkqysHJ5QToHmvswfRvZs/keMNQVBqm2pPOYWUEZXTGU/prYMKgmEfXXWupsiN3qcVo3efSqxW5/OkY9r4yy1XNUQ+japI5+4L5g6RQ3PpqkZNcqWIPrC92W4BQm7hA4jK3Bn/pxIMF7rzLURb8qIBjBuy1hsSY4y8kZYfcEj1y4kv0nj4GwATn9V8jzdqoTUWTV7R9XS4aARQTZ+VJiWXxNMB19wT93v28v9cyrEkLKEOL1XqjJ/jYTpztZNFa
 M2LaTi94
 mhSQ95pGilyF0htBxHuHa2ZadPYR2ucwv4bcrI32ZbafWQpwf0Mi5sHCgwU/4PPbrD9Y2sWmdCTu3ceXu+DI0MxGGTBF/PG5+PVJsBPgZHj5MxCFu6suysxlCI2NVA7DlIDQEZzN14gqEJIUVmN6q/YeiKhBcq3bfn46OOsioS3LVNWDy2t8Xgkcd0kXvHoOkEjF3j4upueR8TEc4zfajIUGmdmkucOEuoYtKOj+F1krcMEYc3x+QJtUyd5Cq57JicLRt3WYpC1fELwPLAi4rttk8QwHw/EwFfgB1THlOs1IpDoAIbtdNcJHApp7oo4Etby174FA+XDF3Q39ztQTyWYqKhtEHrfNP5risUI1VugrYUdnhQFsud39HXILI9fYUoCb8dDQbklPQ3zfb2oOGVVbsFJWHC1yP6mBht/4PG4dxmEmcU1qfOgy8ntpEkW1bCz9hCQD297/nP98xkQinm1/cuGxYyvybK5uO/puXaBlvM5F9VABUdCwtjn0NiCs5YWNEET32LCbTMiJ9pnAovBjkw1TJjfcSehifbBoJI4l6Ash3AX/nvxOT1pBfLPLKHn3tcg9l8tvvi3MhV3DqjCx1DFLANFqn0HMIfxjtz7M6UzNDTp6F3tQ6GDOkdO4dA875C4baFmFfTdK3ggdq6HCenTN8fyR0Q+sMw/gxfQ0KBt5SHhFairrJOMfq5xsa8NG2KDJoUIhLV+brj6THKNZeEpUwh1g9DEYNu9biu7GhZci5+h5hnGinVWOQU1wtwAKUYwGN+FBHV592d/CwyE6zNHfBCgQC/MV5gq26zp1lhZ3GbvfQ+ToY9u7DhAIAfZX7f3HHhM4tR4I94YWwy9zMmVmSkZS+yz/oqMAZ5pOS+QGJ2eCex4usKUPCyA5pF8B1FtQyzey9TZ8dASowrooy8nqIoTaL9stcNPHHWGabuMVRN/oI8Kc9aPpIoAmysdXfsNEOWVdNSxmeoLs4tApK2k9T
 89ZZsbXp
 RKGyvogWc9FWyGtEPFExgdjPcpWPs3dSQ5wgwc+HISTjxZrxX2DL1zsf2Zi6B1bONMr9IGI5+djABrvgNbADWKAKm5S1Fgp0ySM2I/OZGr7d6rtzd2rsIDL9pUY0wop/xXi3t1NagQ2kRrFiuaOz24gMiFUwVRlAMPDyM55iuUrv/99jXHEwNon6GKH834onm8nsFIvbxFPQyN7n5GycEwwLwBC4+cyJfjYDs+hddGvgvLHpXhl8w3DD9P7+w9fX7CfX4NuPes0Ww7UuMADUn1mwXyPl06qSAGixgddQa4eKV+nM/Sx3/elzG47G2Rb4Sou3YbNeryUR2i1MxHEqWGoGk8T5A3lGSFB/IMH6E/Re1H6aP91JgmoLwJtKFvm3LyLeaNvNbDvxcY13ZGUYlJ6YNT6BZCu/7RzjfKL6qcm5s16bbevveNSfAr0lldHJK2H55XiqeqfVknj+h7mSTQyIj6kGm7sGMSyhUHDDE97abSVZ2A5dkI+5paBKVqYVDRS8+z3Si6G408r3XMY92dMEjxB5G2yEEW/igiLiMSiWurkPpwvRsnGdrlNPHtY12RvS7YahO2Z+9g+P3cskagFtnTWwDgvxiL4cVgvg3cdqpF6qpI5Hcg+wDiEVWdEGfrg7b93bVkse8KKZ/U0ZN1Q2+8YcXMWdSoSzXFFGVvKNFoXbrptUDXytCZmlCCcQ+an8UDIbI9tnqo+0qjccxZTo/iTwYvv5VCvxHmxb0B31HzQGlzcN3nfI1SzYFA6HBQ9ehhxh+i2jApz2DA3K/uaVbkug34C633EzZbecZIWDPQq/XAb0QDX6g7Q72tsl3Hi7OP3ngL2AtDTS+Y1rInduQJ8ROTD+rvq3SeAKXO4TOaSrNJK0ke3lLN7fOEJmahaAGCIYFpx5VAZbIT+ZCPw6kFz6yB8No1ezQxLsiNvgOknos3Hv9NNWDeiPpi7XbeaTADOmWyhGu9TxFY+Oworl6EVGl
 v+tqydlt
 YFFqQmWNpJ3ymzCamTeolMm8p0YZewB/FbbSDd52chCTBPMxlnqENqHnFxr1SYY0oobLYIRZDPW2QTIMA68ofsS7IHh/X2IVvbDThsOm2ledVARnVgVUILP4uvOFDV/feIufGZBTdkPNOJz+VIFbnffSyTKsbCkpr4soRpF1YMNrYT5qHNjRVIR51+jMhik10OHtqZjlJkWNSugF51BpugTDNbNPuJL9wC4mBa3OLl8fp+ORBaOQtXCl46z+GHdulzSSJQ0IDFWFOhSpVyDE77tzEVbupOPr5YXAgVnwhw2EDGarQ/mczkBpNr29BH7pWo5E+4gDcNakG5MR0IF0pNIiez210hyMmrpMboN6TeWeiEf0+I3vSXgy7sbe2IFhDtWCtFFKYoy0dYQyD932jjZ45R13wh3rSH8z2nBxRwlB6/qGqql6et7BxrwHfIhfqcXzyGrDH43EtAotYc6Ldn/AkyWOuNq8DHyEA+LU9O3rTqB298ROtUQaMMz6t0SaZLs/rgIGd20ZSluQUCxdg1ZRsRrx4PDAu4Lq+PeWboiB4F2tPX0tI8CU96SFsIn2nF40JWYZyRt70awDWnG54Ke5cNzuiajBWOGF5cORwLCMO1jVs7DuLregcfkCO1hqs0zVzTwiChnmwFoZP4mREw6WIOeBfYjBY1jqK7EVoPsJIXT0qFwnA0a0p2jJdVlEKm78+F066jZFio/pK63o8mfZuUP60tl0+A1enOUiq85/5KuRdtAy5nayDduTR5iS3p9biaSPYhRg66jY9P6Ijn7YrjCcmOojdIfv60Kp2Bz+iecmqnz7gugNy2oHf/JkaLzDcPdEt6OWRLkETD4oVfL5yqC8wc5vWGCLpPcX7es1GoMDX4iliudKtJMPZVc1DffcxfWAXoOFS2jujnAO9pj490OC06d7bE3j/C2LG51o14/D2dgNklhPPqKIfJ/iA88Tb6+yRbw0UgOVl5FDq6umjd1zy
 RlML4bAV
 3KYTk1F5AWqL5z/bUFTw7Ji/aVXl2SrisZTOiPsHvAc4TmGT9suT1WpPeZEl72FDI+gcGc4tLiupWMeQ4p09TsJfcLuOMNM57RCU9Y+anpuem7PwI9ajJ+3Y2BO55/WOT3oJ4sEJiZOlKsJvoS9edkcnLjUxrZnAXGyzwnx5Yef86BgQFqOqLnR68b64gdlEl9tY0eJsT3jvIdXaEbBMwmScbaEy/cYu36tqGPo1ZuZWSN7OpystEqiK2TpPKT1xj7lJymp2c/RZMcWrQ3OrKry5/V7y80xzAuUCQ+q4taCNYFCid5rroJt2h1f2n7tOKZ+vRo961XoAcSn8d4Fe+ugFABjdwf27YbkAGbQ5uVK60ASKJqRI3TJMzM9IdNiJ+JkpV5+GlQiBnHw9J5UehWTEUu+3tTTebYhtICWkad4kDfkaX3GNwgYbWfaHhmhMu6/Kd+THrkZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 00:55, Jeff Layton wrote:
> Update format strings and local variable types in zonefs for the
> i_ino type change from unsigned long to u64.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Acked-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

