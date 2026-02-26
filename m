Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A564FD8FCA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18156B013C; Thu, 26 Feb 2026 11:07:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB316B013D; Thu, 26 Feb 2026 11:07:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AB636B013E; Thu, 26 Feb 2026 11:07:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 72E5B6B013C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:07:24 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25C3B140266
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:07:24 +0000 (UTC)
X-FDA: 84487087608.23.661D41F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5829E120009
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:07:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oP0XhNxc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772122042; a=rsa-sha256;
	cv=none;
	b=vRVezqiCKb2LbQMgj05DhvAREuxzPJ0APIhNtqRff2rk+IMjQWP+PE8cO1a9IIWonFSQLo
	97mP5NtkDglL8GoQhtXipBkD6rfRjVa5sCbTrTlMFts+JgwuYd2nWdMLg4LNuSGywGsh0N
	5qZfgPZAi16Qm0GkSDI3W2FVV8XF3K4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oP0XhNxc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772122042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QEXuDubfu7DiBE0tJWHgiTQReW95Jv4vi5dFz2+AqoA=;
	b=ydnF8PFWtJdrpDstPVXUHyXEvCch6E/LNJ0hUbTA2a4Hu0+42Y54Jcbra9cIirB4t3Zx/D
	eZT/FqSnO1WPZLjiJXmmkKwyk3At3nK8OpB/TZQxis0fftiVPAQWwn68wNplEbdqfLzRTk
	8PLJicDR+R+rQgNsp4YnMCb3apCxgNo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AECB760131;
	Thu, 26 Feb 2026 16:07:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A8EC2BC9E;
	Thu, 26 Feb 2026 16:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772122041;
	bh=guIyR8txAyswD3hV7ksTPOwKgOC5jl6K3IuEHEeuazY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=oP0XhNxch+g3ihBD0nKGKJbH8GWy25UibaNuGneJv2vKAKAvpBXyRRyDQAh+7r/mj
	 0tj5DG3z5WZiIBo6ukSqM/xNVCclXpalBC8EnHMcepR/Id/T8kJiYvdIQoz/8BGD+Y
	 4cX1i9xUrbUhQ+qs3cT3KBOvXfScQAVx40mJkk7zu90aUJRfq+6vndvqiubk6S8UAG
	 OCdrgWUILGd8iCGxzF5Tuo4w70SkeQb5LvixBFHRHfCw72oXu4u5HmxqEEHaHjD2N6
	 t3+5KOuAMEvXLdKEXQyTsMsboXwEHUiapjR7XM+/H97N0pDnM4Kh22dmlU6WPmD+fB
	 s0fHo8dLgp/hg==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:55 -0500
Subject: [PATCH 53/61] fsnotify: update fdinfo format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-53-ccceff366db9@kernel.org>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
In-Reply-To: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Matthew Wilcox <willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>, 
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
 Shyam Prasad N <sprasad@microsoft.com>, 
 Bharath SM <bharathsm@microsoft.com>, 
 Alexander Aring <alex.aring@gmail.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Eric Van Hensbergen <ericvh@kernel.org>, 
 Latchesar Ionkov <lucho@ionkov.net>, 
 Dominique Martinet <asmadeus@codewreck.org>, 
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
 Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Mike Marshall <hubcap@omnibond.com>, 
 Martin Brandenburg <martin@omnibond.com>, 
 Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>, 
 Zhihao Cheng <chengzhihao1@huawei.com>, Damien Le Moal <dlemoal@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
 John Johansen <john.johansen@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
 Roberto Sassu <roberto.sassu@huawei.com>, 
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Ondrej Mosnacek <omosnace@redhat.com>, 
 Casey Schaufler <casey@schaufler-ca.com>, 
 Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Sumit Semwal <sumit.semwal@linaro.org>, Eric Dumazet <edumazet@google.com>, 
 Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
 Willem de Bruijn <willemb@google.com>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, "Darrick J. Wong" <djwong@kernel.org>, 
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
 linux-x25@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1455; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=guIyR8txAyswD3hV7ksTPOwKgOC5jl6K3IuEHEeuazY=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0RiY9iQ/WI9xzF8HjuSF0msd9z65XTS1K3v
 W0Jme2yHyeJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtEQAKCRAADmhBGVaC
 FUdXEACVy0RSg//ixaXELfj5UYiV+H80XbKRqlys8++/J+rh+FUyeqvaKy3D8aWpMOzazuduA4H
 N3+TGxw3ybpjbHT/F94iC/Lap37RUxYODHLoirg+hdONUnX3UiWOMmm7EGl+D9lEionRSeK59Ud
 NYqDJgfaYqg4ElQ8kkK6Sj/OCB4DF5OVQPsO7ajqz59MBYDNWIORf8StRcDgClB4jfSdtU01Lfs
 3VMa9eqaG2AoO6jUI7XdX/CyvsbaIcrCvMvlNmpAJcd/My+rWY1ePJdybAmHaSaQHEhNbFTA74A
 dl0kZP5lWE2a+5Xjb0BjiviDEua1jaJQ/XXhjoITYssXmchunqi2XGiG8CSkelRfXV+Dj/iUeoX
 2jWkJg4vtYV74oCqJ7EQkNuV8DckUTxePz/vgkmjiUC3Rouj09LGiXtdgz/L32fL5qm6qq/XKZn
 AZ0b47pHHvLrz5+2ZcNK97YTeScVVL1ksJrPodgioUmRwdjcxSrbQxXs4anUPhlfHCfc3AjRqFi
 LRk0kVjY2MFBuYmha4wXPXmzs9LqGEl17305Fak20VPYzOSMV8mbJeQPCi0WqrycFSf5qvjZl4n
 Qv8ymGVAGxz2vIrWx8CH0jaVxPfGKHp3HESyfW4gBjmUvw/KMOtBn1LJ1WjVsBnInM68bFVVzO2
 sa5ABNGi9XyWjug==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5829E120009
X-Stat-Signature: wugyh8ajga5gqimohfjtfqtqqj6iprz1
X-HE-Tag: 1772122042-811090
X-HE-Meta: U2FsdGVkX1+SyG1gRhbinux4EZjT9CaUsss+eN885CHBGXnRIEK5JgWCCHD7qSd4mE/5dgg1C3zlXt4EuOtzVj2wnXKN8bKfHMCaClFjeCJhoTDt45/lSStr4YL8i7ukOsN00RnrrWBUK1AMjCUE5aLxU6+ZEUjDslphCX0zCWSUWBq2nddQnrzEDWmpBv7E/B2RNVUS89jjxEtmKw+BXny0iEzqnqoQTCjOAunPPyLdp61NLaxlyTANo9BEjol4VCxMw/6332UkfgvuE3Qf290BdqocW7IDbhJdNPLhGzHcyYVA3FxH6TJ1JIxwsJk0BgtScJ5K5VlLAbxzoY72ug7HTMa96yh7aUAOkOaWCK2v4nprDoB4+NiRQwK0yCWNPRoe6Cg7/BaUD65fHFfNodhA2dAR7XeBzrxTR/zRAIOyP+PnbOEJl+FUqhKWQQmBMiBBeB3fkOUrnFovctkaIUlgh07AMcSApU3IFTuKVht3wMVCZusP1fRe4LmWl/6gZdEMTkMORLhuTWorJbK3X26MQiaM1LsU+HXa62ROU6uTWEbDBQSII65O4Om53/dU7dl/waGKx8yl77PLrgf3EZsEx30cAlVWMMvhZKXQKDdV5ghQYT0DsyaqNO6KFEF509Gkibej0Xe+ZGR9guKtnJljzK6Iro8HQJdVagjhKlD1MAKrlCMpKpmd2EYk1VloiUmdni2QjRzjKB2Ww+angM5YPmpsqaBQE2Jz5VO/Ok/cmLbbrZrNQjyCMiM/EITqeJI0SJVpAg3vGFytg/DfGWLGGKyat5HUkdL0MejEBWzpKXDMRiNEguEHKWwYu8f9L50GGszJsxDPH+qrKl6DSpZeC7bGRKqKJ2/AuJxWlUCRzaB97sGbolLUigHtMnKFjLE6vQ1PoB8+HhhX2zXIskiCrGYrNM7+wsb/dMM7TDKF1UBO0i4f8BNjCOreDVOFiYhrqjJXhMgV/O116Lw
 B0y1S6/1
 mJpqmlQhLcbfG4CbNJaoF6FK8ADyw1aLh9oOL+8jnyuQ65TouBnGjsRu0l6mBshTuVCZIWrmBzUIlO8C3w3/Bfe5PjlzCAcPMvLDSw/qNbE3e7buf1MDky5WNkX/mLZYJyJlXZgb4mVYhOvn1kFJ6g1bgp8JuBQQoSXWp0TRcSMgkEhTiQOjkKRSEuRYXebMIWBpnQNetiT8sVxB0/Wuc7ZhUBhs2p8SXRjnNYLvR8DEm7HVpPxILBHYIspHL0ZiBmTlMz5pJxK4OouitECgQkcHHQ5Mw18Fi5liCbKz1bRds85HUWo73YJ0oe6QyAVdfXs8owkOMlVnHDMPGncF1GHkx/GcEGWBMwSBag5/qRRQgNoeqxdfwJRZoEdGcT/s3NatTJOKxqB7FVcKW2QMmactFEUjMHexgyOZDaEy6poK0WwR4r4/bkHmoK9102QPPo7xDx8HLUUz54+HD+wAdHAtqyCI8FALDHqA3GgZIUFwLcT0KQzr6+HnG+od2+1gUwEgNIrjZPkGbStP+8gSxR735N2OUk4VV0cXTZTrgXn7tN2yNBdZCHV03fp534SgC8UPdjm5vI4unPMEfaR9QJqk7Xfd8IL53sH7QFQUSJrbKGx+5ogpb8CTGu9sY3QAEhchJdUA+m15HVpVVjsQpKmzKeRaFi2Upw1yNIMQJSImaQgslvNq6/z5PFde0QQYdA2Ug4NfT09/jiQo+TWaE8UYrnnBZq+K9VfbuuuBnT7GTv0bn66ZZz3OnfiNM4k7WLp7b8RL0x3hlggfNsG2WQLUIO35Ga0NzCWvMh9w6T2oAO+QrZCKnN6lCDsQ/7FzZ6dZSkDR2Z/COMl6MTwBv0cbhpVby4WI9WyL6zw8EZrA6lNZbF+IyrIRBY/Qho9J6Y6dfO5hrOBzIJ/Rc6YQtECKRcKu7Wbz/xXJU3lQsjfqS+MbI+Hz+jn4KnZRLsYhrLNPlR3WLFX+axRIzGB+8UoV/YB1C
 pQxNpj04
 C8koTE0wmsTPEN658+Gz5byY7xF7X+eH+llbyUQGoVYcIvSiPfHPz/OnhWG0rm/jxB0BTYU0P9gv/O/0Edq7MDSjAPdSS2oCe1nGg/ecPaunZi9T90tk0MFrIY7zZQK9KuwQUHFZMCHXKmMkNMyfvxrk/7Ifm6jufMq2Q6/+tOB9O7/7k1zvUjDA4VjOW5w/r/FdJ+u8bzAvEGz2vj0F6EiLEZEb+etCTWrVDHPL1WRUIhQSnqePQuyR69mKU+HTd0buKxGX5tECG1j2K3zpEKodflJphraN868ejrlpwmG+jMoUA9dfwb/5FQ5qAoDAK/BtDkj892qTRSWBrxfiCeyL9X7HJr26sEoO8TsASf01JuZ+0Ad5wivg/ifbMLo1f2iy8OwIqRAt8Zr0Q/CIle/p0MLYcO9DeQ47JXG+E7oDWShevaWnjL+Y3AjieXLrkdKZie2BUNuvMzxL/DTKvheF6r/ZVI7gXAFqe1InnDW5nzDgc0S+rb38A1hepzQK/9wZ5rN0j9y+Cci7Q1wFIehNkxteX7sgs0HU1/gM+o5GZDrk2CgduYydYgd/I8Rc2HTiN5fk42CGQGSe0Lq2CeLQWO3DbcboGHXRu0YMnGmIWZ5ckBBmfzNZE9sXqDGBhpHk+Heh+m/U4faWM+yQjUOemkItORHLri//4kZaobxRPvbpblAFt2sOkmvUQN576NbHPxm6Co5YXpWZm8eMI513Iuklfm022ST9XHWVOHnbcleQ6vw+7u3BNHZiaJpSpnCEj15t9FlS8h/1hCUYDe4EeAWGgp4qpE/H1gZgsZhCYNnwpqoUMbT0PMYyMM3b/V5hNDSnAS7rA7SQvhMYE3+XQbnkT2bun0d8K/MMlqDT+7gDRkZX0C1//4rAjoEFMkttdnyjAp0kzmZAfffaEPSxyslmRql69QabBPpngh5SVjEb3QDFnNHjJmB4bUD+Hw1GBIayiwdoW/H2431GSh4a9fEeN
 vFKOkbLP
 UY8XGZVpcxJAzIeyM+nkXlvbvBrGFiE8AUre7N0DRzCmcwmU0Rg5KphcniAGMkoqUiaB3xOjiQsZIrwZlxHsumpRwyybjJVTo+UIZSDSHMoAKvhLQuKHukZXUo+W+AHv9zF0AaRjocoPDZdzXsYoclguLU3hmHSR36T2JNwFGoRwStzWgmqiCxmT8ZIR8Mb/oPPoaa7+6w6atY/bWwrot3hVaovbAsAoKmUUTVetO9c4IzuCM49hgRaaip42vNxaOJncJbWuThbisFqjv/XF88uv1yGXONSDEEMmVfh68UokJ7UqTjY1r7+nWpwoYDnLivTl4ls5cmuJqQG/56h1oDgbB2ptYxJFbdkoPTlU8aXBn6KueXhcQVw9YkIBCjaJAtOPfrueBDwS5upaOE1STSx5DA9J9wBGwlnctb1vulIv7WVevsILMEH1O4S5z0TnLtoDhHqb+BOoj+qPR5rvzWGcGmflB/uG1aTiBWH9t0RrYxY06uPdXyFNLzaxp+oluQEWF8bLBIzK0eCqkwAng6PBYgrtQTKsj9ZdU1M3RctzYbvUn7mXo2f3RjOP5ty15zQ/vqgPDibZ91aZzf3D1lru7dkoLYJnZt6CZA7TQMiMB9wS+CL6pvz9D42Pxhbrn5Dkatfw8etNCgtxVYJs+3F15g+wl6+wNeC3pu6O9w1cc+IyqZsVuMA3v3bqJrKDGv1Cj3hP+HwNY2tQH9ls48JQwqjdOHzp+q/+sAsMXPZJB2TQ5u2FA6OYk7mVLOSThUo0FR7n42TRojcttwUrXYwkFWRXkX2q8bEuPC9tLRXLgPRbY3m2vBmKm8v48aEpddPuUDF/MJGr37tZEPZXQKvW+q87a8hTNlTeXIe96zSHXv7vc6anNX19Ha5fXQk2SKh2vWV557FxJpKZBRTmzQGt6XvrK8ZLMTYucVUc6GJKANHe1CrmP4cVHpw6yRpb0hyApTL7IGjmmSkD9uwlsy1RhRZtI
 lRQPESf8
 66C998CDVcTg86GBV69r8ZOsbdV0RH9XoclwwePFFSjxC+vpPvZLvNXbEvF7poI6PyilBAixFsZdnE0fwg8Qxq29HbsxeevSy/Anzou5ubSUkuz1WiGKtsBOAxOoN9fjj/XAJP3kz1mmw5NsL6mK2NMEv0HzzjlvJ+DDAovJbd/Lk0LnlDXaNbPOdqBdVpRcAQvKT3IKRO3VU1Rdk+x5qB+sMHbvRYJV/fXfcjJQuqWnJEQRlvuNgrEVKHLPpJQwt61wcW9O3UgtIVxaQvJk/N3T9yW9qxWcxO2blEDWS/8MWagJWAtk5AEPg+gDZ58kmcPschmyI1aXc9L9cBBuniecnHXQ41zQ9ciKd3QyN4yQAQVbaAYdBVo1Crgr3sRKkpgwoT/qvB1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update %lx to %llx in inotify and fanotify fdinfo output for printing
inode->i_ino, since i_ino is now u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/notify/fdinfo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index 9cc7eb863643774b83da8b6228c38db16d0dbed1..0f731eddeb8be74113361f45aa4fca2943395e9d 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -84,7 +84,7 @@ static void inotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
 	inode = igrab(fsnotify_conn_inode(mark->connector));
 	if (inode) {
-		seq_printf(m, "inotify wd:%x ino:%lx sdev:%x mask:%x ignored_mask:0 ",
+		seq_printf(m, "inotify wd:%x ino:%llx sdev:%x mask:%x ignored_mask:0 ",
 			   inode_mark->wd, inode->i_ino, inode->i_sb->s_dev,
 			   inotify_mark_user_mask(mark));
 		show_mark_fhandle(m, inode);
@@ -111,7 +111,7 @@ static void fanotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 		inode = igrab(fsnotify_conn_inode(mark->connector));
 		if (!inode)
 			return;
-		seq_printf(m, "fanotify ino:%lx sdev:%x mflags:%x mask:%x ignored_mask:%x ",
+		seq_printf(m, "fanotify ino:%llx sdev:%x mflags:%x mask:%x ignored_mask:%x ",
 			   inode->i_ino, inode->i_sb->s_dev,
 			   mflags, mark->mask, mark->ignore_mask);
 		show_mark_fhandle(m, inode);

-- 
2.53.0


