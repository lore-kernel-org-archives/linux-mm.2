Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A933EFD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9D86B00E7; Thu, 26 Feb 2026 10:58:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C3EA6B00E9; Thu, 26 Feb 2026 10:58:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDB2D6B00EA; Thu, 26 Feb 2026 10:58:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DBA926B00E7
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:58:38 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A639913A2BB
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:58:38 +0000 (UTC)
X-FDA: 84487065516.13.163F5EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id BEFD718000D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:58:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GmrdppOH;
	spf=pass (imf06.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DrUm4Vs87sGbvGboHyVP56FCVQA4O4lyyjMnhBtrbGA=;
	b=I/3xNSkuoXkXiXGA3TLQP1v9PF8RNa9mXrDhiHXVrVaARFaNk687TQDY3VwsZEUFFCmJvz
	FWI5yinJ2hwL4RuxKGRDokrLd5maoTdSpxqH48SIjZLXFeYAj5Ea/qJetJv4hkxKzvGwhX
	3Z4igwprfU4wqmjQO0HjE0UnubPwMJY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GmrdppOH;
	spf=pass (imf06.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121516; a=rsa-sha256;
	cv=none;
	b=x+AJbghiYwP6USn8a+45PbDom77sh65H4oGa4wvy13FNOg/ko1U09TJ9h9mkDRxYFc9Wtd
	1/M43WWSDdaG0upni8mexvUR8H3udeLTT1yX5F2DTv7ziiL8dwkWHfabNOBzku13lWDY/Y
	gb8IGDAHzpgrOcA8Buz0gvvLwRcjchg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E1CAB41A76;
	Thu, 26 Feb 2026 15:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1D7C116C6;
	Thu, 26 Feb 2026 15:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121515;
	bh=YA3Mtm5mPmkVjL6hFtey9KMWh3gSaYq2MagoP4LN3/A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GmrdppOHVxTK6LjwPJUDCRCr56MTlrDltKbBC7kjaIBy7u7PeoWA2d5cbdi8vYlRo
	 VHH6W1mETt+muiHQyBLKRS1eZbP/x+JD6/mcHLZuSB8JM4wlewRNxTu/nz8RTZ9yXJ
	 OlrwKNA8ElMmnLoZXapQor9EiTxscN/HV2SjnSL+OmKYSyHZCtpJAm0sP/MTOBXdfE
	 gbU9CW1TQFNiUrpBDEaUSBy040cvPOdWtoayIKmOghN2yBTZB/HVVZxNYX1eHVaeAY
	 jn4G/B3doACFrs0XhKmGU+BQSamXDsqOL1QBEcsX8vnDPTCT4BiLmZrP1qK3iI48Ip
	 K8p7OmEZiI0Xg==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:13 -0500
Subject: [PATCH 11/61] nfs: remove enable_ino64 module parameter
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-11-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1279; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=YA3Mtm5mPmkVjL6hFtey9KMWh3gSaYq2MagoP4LN3/A=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0Gs4nMQ7L6lsVYVbz9tP+3htrQ7f3vsiUCO
 jWU1x0BBJeJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtBgAKCRAADmhBGVaC
 FXJ0D/4idsXZVMw5wmoMDDtM6AOQkegw7aKpmJucAxThq9u28V0k5Lv/tKuxcDyaWp0Qk98pcC1
 THlFYaoMkc7byE0+Hmcgkxdo4IjLCDtLHlxmvrOiLmHSJ9UZto07rvtQGD04R4aWGxQ8/7/zFUv
 hWrQSVnKGkxCPRx6Yvr/mE4SJtsKsq4qoEsz3uFUqYkCPHEPZ0rSLvS5NUSTn1T2J4NlrLbX8ak
 1ja3HKzV6IfA6E/G8N8UoRcGMgU0YfRykto3QM87/x3SZ7azd0hInC6OippwGXjP8o2hVEhCNle
 YQYOI1St4BAmtt9kX7Bmsl/DANMUbS/+UgPJ5ku38ohJLC7JBwo9DN60feaXlcIvK88km2kzqYW
 CuXGRMXz9e+SOjoxR7PNYr1cgU3XVjDyya4Kkc8AG2Rze32VPYSO3BMa4zPE0eRWWjIZt3m9UNx
 dKQtLQ4NuBOhba+BvvkX0SHwDZ7+z11cDz7yZDaaekU48wtWD4neVYf4Jsr+agoF6HRJgZ1+eht
 sTxSLr20OypdDn/AOhDecQymubNDOQ8GANzIZrnciGCoC5AMCUpzbuB2GKKeP86s9hupVnHOM8S
 4+EiSz/H3rEasjtRAfLXqUMKHjs1F0BtsyDNUr4UT/WQdlwLXpLyvqHTEcp9U3ja60cqNUEWkhj
 xA71KUF6JLqqfLg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BEFD718000D
X-Stat-Signature: 9sp6rj59ou87mw1647ebajqp6rmyrzgs
X-Rspam-User: 
X-HE-Tag: 1772121516-551032
X-HE-Meta: U2FsdGVkX18+e8b2U/37fw3vWeIoaAQoyTiDxtNnBs7naEmcr7KLyzWdaeW5jHmaqGIR7PFotheBw6oQiQDiUkGk61ubBWJf3DxB3UC3EM0b607yudSChkhEbDWDKHIxqLyIsIAehOjH0Q4GtuR8/xJ4Ffy4QE4LggWspCb6/T0jfvVjk93RuCAbOXEoDpcLZ0HQJSN2d7oTmawT3BEBM6N2RUTdnTG76EGMFTbhyF8vAzwemSytK6YANtM3PO/2XEJdAeMfkQgOrkLjvbEH0B42irTHnm0rlEb3a+HCN3AZoXJQmcLc4WT4T08Ia3F4aKCiUDQI/m93Y0Pu/lvfIzMT0Zja6LnKTKSnr3mWQC7lyd1AB0et5lIga5z5Y+AcIEY5GB90SfHlpbF6aUniiHa8oCUMAbhYNp5AapiTYAXllpqA1QRPjSlWoA/i9kSndG4zJlw22yyqFJ9VPe8kXA7cnn1m2EoI4qiuP9dgCXCNj7DJ1udaEDbq/zWUiKIpVL7rWDDu7B91R140Wd2KugF8vF9g03ZablZP2UdcjV6Sd1zKCk+rRJLVzIKoJpGmLJBHgototAwTztZ3cTTO2CfzVHc3AeNtnH8WQauLLPAvW3Ee5EChPdPM3ZoIELFSKjBD6EvQu2QbJr35+W7Id6JfrD5oRWgz+37Ou4CEnicLXz8yNzaJlgv1LllgrRbQJaoiUE7kwbAoQchK4fu3Q31uOQidiBsRD808camUr+OZrQ48EuXGM0Vy0qwsxZ9S1pgcoJH63LVFl2CDJEpy//EAwk6qsrcNbjjEHIraZXaRTxmU1hDTi802jlOfiRO/FGD3UkEkSxFc12MeK11qvykK0FhSPAdKlIHT5mna7pDIworF3loTRRAgOD+xEnbxjkxXDnlmxqeE2AvtZH286gkx/qQ3+yyKZONjJESW1AlaxJuwjjTbtUhB0AojbC5us1A2XX4OeT/afCDwF50
 0Xcgy2Vo
 3ibfU42lYJPPObSsxpt2i4fEdIMkXQciinJaczhueOGXEXZq1B/x9wNPUPKCVR2WP8XDbbS83ZJeXWXH0xTzv+CFF5Zd7JGhMAoTIsZhQPLSvspBdEsm03m375Oi1yOYppY26p5jEcJfS7DZrQZPtaRzFebKd7dtRGr2tOD6zcYQeTmbPmb4F37bqTInEzxnRR6AG3e7SU5v86+YYBS6Kgj43ZCxddeKNqrrv/kuYuaNJWHFRZ02DCnistb7KgeOwt5FLPT4QpZI3sDplC1G5GynhkLxdAToZeiqEvt1iNxjo1rfYZJgmLy79+SeJUVwg/AgQVwktFsjPFcc2j28oOb7yzd6cU73v71/Xw71r97JmXw9v4EOsxJmjZ92PRuttdhFbWSBEDtN6Q2SIlfW17rTI30UPEvUuGNFCjRXS2miCGes1OvKu4nssKq04P9ei4/OU27fiQaSln1j8h00iP4qj4pVEsexS3sFfvZMvEjqVzQlKOEdF6L3Vg78Ff2IWupMZr3nztXsgh9POuPCXkKcZz3rU8MfCq8oQUkZyTMLnVwMkuiU7TbIn3GnVyj/daueIou17rjAbOq8gmU9k5jk20053bHLnbpVbH/oBHCx/B0TfV4VzmvnxOa7iuJMKw0SADp5JbuRCrtht6ZOJWHv00wKfCsQmGaSpe0cFtkAtb7bZ1orxzrz0Wtsnyxnlx/mmcFfQJcMaCiO+Dec+Nb27y1bRSAjWh3XuTkK//x5RuSUPwObTN+2otd6exHZwbqiGV2LJSJ7/apgrMhEDiq9jX37IMm5EI2GTLDuiQH0FIazwGbRuibpgkJix15eCFgQJYieNPfX4YzjilnOcqAAJbdkoDuOKh0teOAoDgclpXXcpz6mZM9A5HRnfxnUI19240peNLyJMx0VHN9esLAgqJ3XD7P68qQ+uxQaXU1vCpm/wDlc0TmwsdN/EXzVhFxQEeFuCmgv/RTXyoqYUv9pZUM4d
 saP1A+HJ
 KcTE9PRNjt9YOWSeLhsbQWOWxpTnhF5tG3+kndzUt8wddeM0/vipv0Li6vvIQataJmmwX9+TkOzH8hNkE/yWeQFG1daOmKeuUk58+mpu3pQtpOo17ukqhbUKaDZIIxT9fSncHDz8gPJZmoTOtI7hEWzEdWAqu7dIYii8B7kcXShnsrEzF4JKxwlXSbF2F3ZBQUVBVNCKWLkY5refZOETcSNjEgc/9dP+h7XhBFnZSFKgz/J/2zgFDKITAcZJAxk4/CGn2uzm3Lw7zGKiG715zMf7J0hmB/z9HGDQhjB9aBkQvPnKeCWCJJPl61r/NpwFPc7EESIvlG4SDjGWWM6YhtAFsgMpDY0TapoAowtu+RrucSJk3oRup1TRwtorQbuEOZe2z5ieszev7MCi32ZMK2ovIUkv7hK0qdquoRH2KDbt2KXoP6zFDJ4OZccggv6w/KVHn1fH8dClbMS7M2SgGeQPL3W7VLOjkRf1jhvaok4iKJ8L8lFSP52u3dIGbQig76Wr5OcOxGSW+iVkiLxHFYfqIF3XkCC49oTPu+BEFONI20FnpBrfCwuFzu2Zi598btRr8zE85sR2yA437IEhldYLBBjsFtpfPlcQBCSwpMDZRQVHMnQcBYqr6MHemCJXUh58M6UzDKRdJepAB1nu3D+ZuEIMsDLAQPgu/hT1M7I6UtdluAsyhCDTODAOMnE7NGkUWuk8UQxaBgzzlL/zWSyYJs6bF6DizP3fhcTLCuL/BgaGKdVsnoTPVSODk6l+s3HLEu8YTvorpyCom57bEd0OI4LKw6NWhDHFCMVBl7sZMOdjnm2TZeWBijuNvnVrgzOmbpM6cbl6bWufOzrUo0gudKBA7W3j8Nk3NzMz9FT3RR2Ua/VaiD5m0JO17/ZM1A+icyAtji98VPmboWhnKGNwBfEuTMPe8YVe5KVH2sLMJbwfH9T+a7ZVS6XRpqIz5T61nz5+7sXowi2E15Iyl5DS5XbMJ
 +7ncaHpS
 n1gDcidrdNY39zklYH5YEUR3dKyGbsE/lzsIVBSY4O0nrF8HxKJgw5RmX08tC6jbRxZPnT4V8l5/Er8UA1L2Q00taeD0yVBQHyN4jKh30B8FR80Y4uJgiAncSWdASpSldeCPjuUjzUqROxv8UcUfcDBcpqZ7ydijApvhmPumoGUxZ1PbBEPPsFStgrF37QuQHM5sQ7L905vVE0AzOoaFKCSye/4Ofk4OG0zqXHPjtubj3f/y2siEco+qnocwZCAjq8N+DaNHA+KwJJrN3E57An5JBN8O/yoWFIyySeDbrDpYSACx7mTMf6m68ABqsSf4b6/iC4W8urf2mONFFWTcLfv7HXVPVeIpqvMhB4SsCWhQfLWEKXjI1RLYAkwVl7wuCPl2Kdlm0TP3fEFqvBHGMosqt5Edu5dGvTv++bS6aetkvCtUTFoWEuFgm4jIhTNPd+7bbrA0mN3oGShQdQRgiYvPIzIQoNJheNM72YrSIdlLdCNn3/P+n9f3RsoTrJkz+FX6N+ahyasGGMHGpLbsWXsRspcW/IE0Ake/x41APPRfUt+3vN76lFY+OmPJ1KGzCxNM0hr7jPtbK3yFNHl+DEALDRDLvygIOp2mNFv0TOEgv0meT5Y5APKoJfm3Nb5TOgnpNBQYJB/g9vzuL2qXkP2gIA5oCjBrtr9hU5WvHElD/HhLvuwTOY9CGw3j41QQKP5EJAtKATOyLN30f0u2lEyt5rfx9qvlkC3GzNbhdKuIWCFb1P8Cj/lSDDr0KkrrVfGkQxvaSKP1MNCJ6XrHsHOyHK3mXz+RuHE2iFckr1wPr9kNnO0BNTwMN6dSGgMyDjseiyG/1GvRUqkqDeaouX68dWXCDG/twsa+xg/UerkOkGDnsy5daQUFCnqlxP66YQV09/DeEwhptES+SS/VxFlBLgFm4DBTxeEYraYlLzBJxbEO/r6SxU/+utAh+gY51cZwOtYvIpUgSD3opEzpjPrBZfv5w
 QdwWCTaA
 XUJnr7LBreu7e6Ukmfg0GIfpivN+KTyocGJRtlSq0pYnXbNWiTJR2yg2bps8SI49mtw3veXCktKQ77JT7rvK7p8pElOEJTu/mlrDBVsGkInpNr8pQpkFkY+1/OqLXXNE9gciD29BdTZzD5/U8tv7g5L/7ZFKdgriJwh3QBMdlYjDB5R5W8PDAbJaJU2L3UqVjLKQAF+TQYabKX4B0tkQXpvFcnfeVjZBCJUjIglnzvdVSncSGzNRd4Z70ehtIXSF+49Zzl/OW+ZZ/iq/AyIr5HEL7PjSdrI/YwyLIoeJ59WM9QsaweI1eqvIdQzI01+96OhibEPCag2EQuy8G5EfLNiF+O+7fjhrVtdbzM40p1tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The enable_ino64 module parameter controlled whether NFS presented
64-bit or XOR-folded 32-bit inode numbers to userspace. With i_ino now
being u64 and the compat folding function removed, this parameter has
no remaining consumers.

Remove the parameter, the NFS_64_BIT_INODE_NUMBERS_ENABLED macro, and
the enable_ino64 variable.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/nfs/inode.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 1a7d7bafbb623ab603b8c517628343463277e096..8743f3bd96a7b5915ae892abe731f159a7055d40 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -57,11 +57,6 @@
 
 #define NFSDBG_FACILITY		NFSDBG_VFS
 
-#define NFS_64_BIT_INODE_NUMBERS_ENABLED	1
-
-/* Default is to see 64-bit inode numbers */
-static bool enable_ino64 = NFS_64_BIT_INODE_NUMBERS_ENABLED;
-
 static int nfs_update_inode(struct inode *, struct nfs_fattr *);
 
 static struct kmem_cache * nfs_inode_cachep;
@@ -2770,7 +2765,6 @@ static void __exit exit_nfs_fs(void)
 MODULE_AUTHOR("Olaf Kirch <okir@monad.swb.de>");
 MODULE_DESCRIPTION("NFS client support");
 MODULE_LICENSE("GPL");
-module_param(enable_ino64, bool, 0644);
 
 module_init(init_nfs_fs)
 module_exit(exit_nfs_fs)

-- 
2.53.0


