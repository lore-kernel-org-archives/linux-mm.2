Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12741FD8FD8
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F4DC6B016E; Thu, 26 Feb 2026 11:58:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ABA96B0170; Thu, 26 Feb 2026 11:58:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56C136B0173; Thu, 26 Feb 2026 11:58:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 37A626B016E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:58:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA4655863A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:58:48 +0000 (UTC)
X-FDA: 84487217136.20.2ABD682
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id DE33D40014
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:58:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=manguebit.org header.s=dkim header.b=nlx+CJv1;
	spf=pass (imf04.hostedemail.com: domain of pc@manguebit.org designates 143.255.12.172 as permitted sender) smtp.mailfrom=pc@manguebit.org;
	dmarc=pass (policy=quarantine) header.from=manguebit.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772125127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GBAAeNpvfWupATD/Mqi5LhBKxQa5mgBWtQkeTAghv8U=;
	b=AZRP+1Zw9E3JoA/2VxsLiCZ1b9WDZygS7LhpAh2YnCzjwsPGe5iAzgiiMZfkl0hLFSXTSB
	jDtKid5qhCSu7f5947vhI6FxdhF3KC/LHfJN22eFiOBCMuZ1jTNaPUBqzXykh5CK8Ps60I
	zILAzONP/KChwU7/drGJoS2u8IzBhjU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=manguebit.org header.s=dkim header.b=nlx+CJv1;
	spf=pass (imf04.hostedemail.com: domain of pc@manguebit.org designates 143.255.12.172 as permitted sender) smtp.mailfrom=pc@manguebit.org;
	dmarc=pass (policy=quarantine) header.from=manguebit.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772125127; a=rsa-sha256;
	cv=none;
	b=ipv81yRBOTPzMA/++Jv8h48W8i8zMtXa/spDRyaMlBEg0CLxL7s6UMZiQsRVduvtGgbynA
	jFj6K3v3wBUw7I0dwJVP03GOK7lW91t31h7vwFzGpsTnvoCnRkR+cBvWkH/h336fPkClhI
	H7D+JtHDEvpoYphd02m/aDPm/6Y77s4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GBAAeNpvfWupATD/Mqi5LhBKxQa5mgBWtQkeTAghv8U=; b=nlx+CJv1x/UuNttwKXynH0qJFV
	GGPlyhyb56jCAmfo2Dkhao6Akb/whBUWKrLHAtLp2UnbAxsZRiEEnc/PA6a02dlJyun7VB/WjZ/4Y
	gSNeA6HN4mQbMGOcTdkRiDsoEk5l6Ssb6qUdMgoH7JYTbpZDll0K3Gc9Sl8LgYozq3/3dgHYhmDwe
	fRUIm7haKSMEmY1/NzzgcvEuyT7l/TJWKX2NJMO7AKfx12ThZPHB/q8MyHq+NyeW4NqEFdN0DjrLH
	BhCTcfbtcrlXDP67PmPWXw2HF4zz7VIOb15e9g0uBhXA6DI+uxHuKzWDbVQB6y2V+HCbHUW7dwsue
	9tQXYUVA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1vvegu-00000000rdY-0Taa;
	Thu, 26 Feb 2026 13:58:20 -0300
Message-ID: <8dcf2c77013a0de245c4417eb4726752@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan
 Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Dan Williams <dan.j.williams@intel.com>,
 Matthew Wilcox <willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>,
 "Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 David Howells <dhowells@redhat.com>, Andreas Dilger
 <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Jaegeuk Kim
 <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever
 <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, Olga Kornievskaia
 <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey
 <tom@talpey.com>, Steve French <sfrench@samba.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>,
 Bharath SM <bharathsm@microsoft.com>, Alexander Aring
 <alex.aring@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, Eric Van Hensbergen
 <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, Dominique
 Martinet <asmadeus@codewreck.org>, Christian Schoenebeck
 <linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>, Marc Dionne
 <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, Luis de
 Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>,
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, Ilya Dryomov
 <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, Jan Harkes
 <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, Nicolas Pitre <nico@fluxnic.net>,
 Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>,
 Christoph Hellwig <hch@infradead.org>, John Paul Adrian Glaubitz
 <glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, Mikulas
 Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse
 <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Dave Kleikamp
 <shaggy@kernel.org>, Konstantin Komarov
 <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg
 <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen
 <al@alarsen.net>, Zhihao Cheng <chengzhihao1@huawei.com>, Damien Le Moal
 <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, Johannes
 Thumshirn <jth@kernel.org>, John Johansen <john.johansen@canonical.com>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, Roberto
 Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin
 <dmitry.kasatkin@gmail.com>, Eric Snowberg <eric.snowberg@oracle.com>, Fan
 Wu <wufan@kernel.org>, Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, Casey Schaufler
 <casey@schaufler-ca.com>, Alex Deucher <alexander.deucher@amd.com>,
 Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Sumit Semwal
 <sumit.semwal@linaro.org>, Eric Dumazet <edumazet@google.com>, Kuniyuki
 Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, Willem de
 Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, Oleg
 Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ingo
 Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, "Darrick
 J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev,
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
 linux-hams@vger.kernel.org, linux-x25@vger.kernel.org, Jeff Layton
 <jlayton@kernel.org>
Subject: Re: [PATCH 14/61] smb: remove cifs_uniqueid_to_ino_t()
In-Reply-To: <20260226-iino-u64-v1-14-ccceff366db9@kernel.org>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
 <20260226-iino-u64-v1-14-ccceff366db9@kernel.org>
Date: Thu, 26 Feb 2026 13:58:19 -0300
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: DE33D40014
X-Rspamd-Server: rspam05
X-Stat-Signature: 33wtntzaddnuy6b4bqb774augepneuuw
X-HE-Tag: 1772125126-436822
X-HE-Meta: U2FsdGVkX19EsObOXtLCgKgw1tmZyXbfiLG9rcywpyjREKjKM5MXPCIC7LwZ2iJqvxfVB+u4t1/hKKs9JmcL4FPbKEMEa1IO+ZOEVKPeSm2COfsrnwLI67QDqTi39UzR8H1Y8iaf90nGf97vQ2UYVYtNiwyp71xamY9MS9H6WtgtUkU+quOr96lvZF0r1GzaGZ/Mo8kySwX/qEJE1zqUYsBSIyrnaommz4wRTHadhIdwbdm94dzVHkLtbJAx+JKqGuOG8IZGznIn0t80CEeiXdKglmvyt2MmKumUzlUye/rEcVoySZtxGNT7+xwqanoV2/7z2hx2dwVZn6WBBP1O/ZgG6k28iOEBXBzZ4vwLjURziwvr4bs2F7LdxwfTWysjMQlsGvBqqsB0zXaTHP8eWMXkt10IFhkoZmNmLOisbj4m0m58Ko2DSY9/0MeLeIZYGa+BIZCq4r19dozPUGnm7TWuieW6OV5mmT7cx3jeuIyeOK3F0ebjxsHT9j9p5ChoAC2TFvwqofrGTANgP/pE2n0VmRa/+q3HWx4vqfD+9qvma6xLyo0e5GXEqEeJ7++yEG5iDYjpvXW/RM7iV+1H1K6DjnOjol9gh5F8YmVqE/k/f2bvsvLhPq57cxiv5sGCoNMmXqBwVTXfId45wlsCTu0TekHcUdJtr+BoiMa0seS7cVAACUQMv5VQ9c8M8koZvkBGJ8sDZxSsEqRa1cOW5QzYz3NI3oV6H3txBnL9x2+3VXMQPsDunzqcgu8B1zpDtLNbxIG9735WAIPFDvbGFuNinmHXx77CYLwp4UVKPFo1TOHQwMp5Z8kW0l1/HZ0ysKuzJ8RKAMyU2Ts/yjn3yxPGNXkOxcvBSeR55JAgkisVaZGeJtY+igQzrhvEzHRYVoC3jwRqJ7assgP5CJOnvGQdZmJ6O2Ut3zMfpx6bmNxJypDaN4sxj71TRml7PUcG3224V8jlZ/Sd3Vn3W8g
 N2D36Qnr
 nfhqw3//adgFU0V/F6mWFkEvv1/1MSlPAdfXiV0iAbA+NPQGDyQiKC6mwdqDWCe/2in7qXn8gRikiFHy/xvB6E7v9sBuIE6JGvSgU2T0pJUivVktkCv+APUdlpayNCAcgVnaRf54Eocr9bmmD5TRj0SZtdrYY/RKYc1kbWRYhPSm6g8+nYtZjEVlGWvG+/2YK7CutkdFPLaF9oJt8iWh3EOtjyV9Vtv9B9hXZGiLgy3LylYQE1Bkl47hl0JPyoIbmOHqdcRXJ1g2zJyp3Sq5qluWnOC92JXo9PGIJqYb88d5nhVXRWK0nJMHy9qBSJ+FPcZBF0jURK7UuopRiHuAWNBlqHO26FgKKaSMlSXEC9uTfYad2vVNFsjz2kOyVmBC1xm3cP1xulFOFx0J3jysGPq0oT3UivKDI96PfH7D1KTTL0FzaCy5oZM2wr19HQLEiMB62kDwo7D4n9Rvj2mxIAp6C79lLO5bYosYTfMfxnNA1B/WwugR15hQ+hgfPL5JBp5VtJdbv3MxG90Bob17iO9Tp0mMn4+CIRC1mgrD1MAkJB30QZySZmH9ty+r3ESeP+GrIf25mrXwYSAZXo7zBeP5hIQ/P/8Y+oHDBo4gRr8phUxv/zzYDrdKtMTAeTM1wVCyXNOeXsKAmsgrotNLvj2330aoKW3w3aaOMCLxa6nxQS5GTojTMWXVaR/XhOMqIA2L3XdgipDeRHfq28EA5CS/myTf0m72t5Q6Np2WKEYErSlO6GbCBVHzgKLoc2Q2ge5pF0m3cSD/5yJUOAxX2NC9tua7plLgtlwj/VCqLpIBfwfV/mxLhywY2MJ84DeL5vkutw6g16GD1xO/iGwRvZRAWhqtBF7/Fvd63ybgYN+rxTG9us2AZhpfAVWqY4HhFwkwyf688q5g46m1O8zfqGFQ9vwFMrV8E5WzkFjQNSUcXhJ1moKHBpIoFOwqJdjNlW454Yo/pJlz8rrL9Cc+mLNi+4mQd
 QqKBIDhn
 yyNZR45k1mRdbOkUQxIA2mBUovLffxokbm1cYEAyDzsucQkm+ZDo3TEYAEsa79WOmrzgQCUim1KMSpwWct2pwney4ycaJ9/+L3KhOppXdeNaOe0mPIDUMkr2t/W2XS1msgMEKyVotzbeIChcFOj+0OhAyzKpICrNtJmsljM0xqdtdr+yscMCTJvoRmulcBfF3s9Ppw+1BhYKUAoFQWriv3dqf5Dn43S3vdig8Kh5WoQLjIveqS76SRg/nivkborINRSNeqUGkoAr1nVskbBcAUlw1Hmix9cGFy3+aCNkj7zl9xPQGst2ajLHAKE88piRx6S7JZXEtuqqAZNVE9lm8QAJYK41yRgOzaRfxADVKbxnwlbYqe68TY/Wdhjp7I53dD08g27gQ8nUQDYVbPXvZfMFl2LEVv0VJa/2CwTo3VFkkH7tdR6pVgnfbWcDmTEAXx/0+Wsi3E8SvgKg+67fQ77WE0JoGNdOoJpliGkccUezuFrpMgVITBIJs5U6AMWwSgkRYRreqoyUD4GZyrFJX2joSt0nWJEfa+ywVQZo37R8AnD25X1mT29JoPlX+UdKQgxiObR8mz6IMdrqO23w+qBUTEV8RTlfVs6zZwymV51L4L8E5zW+Lqcv+LtymqQsam6I9wjpkA4yH2iVrvgSUe3FdUwDey8hBfwtr7y+Aho7rtqT4fDGxMYI60WYC67USR33HXqvc0YCZ8WSynCSF7l2EUQbfdakSCflyXw2ncEI6dGmZ1rZhhvn+xAk2gIQUqUDdtxA+gglFGbN4UfpEW5btDkHcxfzb4MaAKj2NVBoAoOFdQBhceU+MNQpiUV+sMRE4BKzsM1HAP4227ol60KUt//jmgkGJ6BTMxfhsAAzH9udHpNJSoDiTUC3dMh2nL89gwuRqk9VZw2VU9GqUBX7R9/Omz8Qe/NpBzppftf/jqTEnaEBn1QOMT3EBUim6KMQRCNDFpHhR5BJ32wzjW4LxPBYS
 DMz64bwP
 yMBVTtbAv0cjiWaQa8jcGQC1za8rftqtZ+hehTN/2pDE16APCtCeNBjDZ7Q2G/PBKc5Ss6WAYvFxdzSYlh4whuPiIjMa4c5pbwwo8fEEV2ZZm+RnnkCcfCsRsTp/MMNCSVVdb88EOQXLe/cY+hm5X5f7iNcJUwHLK3R98slW45LaiteDbiCZGsK9F1dG3rFbcDrRVqXYHbDy7Ma1e7b0G6JtBtn1fPC/1C9byIapy1KKBSdzOtAPl9Rei5lC1eisd12a8eC/HRSOAWEmX5c+Wzc0yu2s8DNx6GY5mAAJEmD0zhNknB6zDXv7mRAErhQKloqAhvhXJpIo6aAb++SxkP7UnzvPym6loAf9XFI6413QtCRFRMeg8vTyzaP7ExPSu0k2kKKXuvycRYKVq2z+XLX7ppO54ORBQFq4gVVnfWwe1AnCkzjDueWH3ZVVg8YltCK8uaHCi1t0F2764j6rGqKlwhnXNIYzf9xPXvL+HVjcNTyNxOhPUGfSzrwcPqxWKZ+O9EkEUS22Rf3PrH9g3YnqKl5CY4XJfYk9ezwejvcOGkRaJ5S2sr+r45MTcOX0oUPPCZ0YmwhD7W/qnfar5QqgJcgEXABbesLFdOq84IJ7vIH8Jk/hVB8qwKPBBmJyDz+Y+hRq5ksJEegPuFbc/2c3L6knIKnPUMu+5+pM3eqoV32V2Dq7cn5kUxv6nrUgmytwH662+UEcBoAujWnyN0BP9HivoZszTCHOhSUgGqG0utnon2sEiwtTVd3FySjHxjR+e/vzrS4nl3EdN1jxDVQ8dmT2e4B9jqJSeUTtkM24/TOsqJDTDJcrvB7SVnPuh0GXnD2DpfiGO8NpsfKI0j/ZAI5egDjqahm7sj6Cu4SDdUdQNuoN7sMdHBmO2l8irdfZ6mVE9KsFq0a42LRpCgfMQcE8okuW4jaIX2DcjqtgnCPSgieWlEhKdpXNWBDEvooi59l0WpEeV8VSLrtAdE2DNQyWu
 Gy1j+Sll
 oN5E/NQW48KCFnXNj45ge5EBlveimKU5Ny7Dt0FlXiDvkJkzc6bunZX7WfK6Yrgd7LIBuma2WtymgRSbG05InGbZI3YEQTwUhjcRJczy1G8FBwwycthkLKLG6VyRsP7MEgGEPGwhLlnJpYFLjtqH99iU/JqudkmgiZgubjChJtNOdnAu9xtrYmWl7SvESdMSv0787rtkXxxW0LuBB06Yuk2mVEhOSSeKMUJoyYCKPreN/akN9T8KDqCUFidKHPSP9+g13J5NVzH7MYZsnOEdsFIGshFVi4bPyMDatCtMQOKmiiYOZh5bxsencrEZKftVUTFIj4a89dl9ca0CRaQaCzkVeuJPqeQEFv1E/EXCfXFN+o7wtTpKdCTwAFWrijnUuPhMah0PutxmwWVoKC71jPIO37VlG3Tqrhq8lVeY0ViGqS0acteOOL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jeff Layton <jlayton@kernel.org> writes:

> Now that i_ino is u64, cifs_uniqueid_to_ino_t() is a trivial identity
> function. Remove it and use fattr->cf_uniqueid directly at both call
> sites.
>
> Also remove the now-unused #include <linux/hash.h>, which was only
> needed for the old XOR-folding logic.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/smb/client/cifsfs.h  | 11 -----------
>  fs/smb/client/inode.c   |  2 +-
>  fs/smb/client/readdir.c |  2 +-
>  3 files changed, 2 insertions(+), 13 deletions(-)

Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>

