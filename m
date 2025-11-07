Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA4E6CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 22:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FB5F8E000F; Fri,  7 Nov 2025 17:35:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3688E0006; Fri,  7 Nov 2025 17:35:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2B5F8E000F; Fri,  7 Nov 2025 17:35:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E20908E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:35:22 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79F17BA6F9
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:35:22 +0000 (UTC)
X-FDA: 84085268484.16.FC34BC9
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf17.hostedemail.com (Postfix) with ESMTP id B55874000A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:35:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=gwskUpuJ;
	spf=pass (imf17.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762554921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1SMRxhNRshB8vecJq42CGMcQSf+tMG9pcOEmrtJR/2o=;
	b=CJkUhS7+i3ltJ06WjQYQg/lyuMU9yj3LGm66WBKuVKycsUTDaJ3POqRTNW/1PrOxxbuRTl
	xuW+nJZGjIxfY3Bs1fUUpExjXuveNpAow5abxgpR7QDON61BGGi+ctOzEbe8UHhcGWceCZ
	TNh8RWXVL8UTFYGQL73MLLeb/2HC8to=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=gwskUpuJ;
	spf=pass (imf17.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762554921; a=rsa-sha256;
	cv=none;
	b=rpMqXmp2/r6G737gMo8/DQ4qwsd7VcH/N9LIcBtEPkBuec1QRPguNaGu2/DGDu+uW3St0U
	LtGjl2HRG4RiEaXaI5aqv4X0i4WPQnOJdwLgxCIv/QRx6f0sQAKSuQ0uu0R3uD5Vvn+KPV
	JdHttBxxO72XKVcAlV2tasD/yvghHzg=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 65A4040AED
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1762554918; bh=1SMRxhNRshB8vecJq42CGMcQSf+tMG9pcOEmrtJR/2o=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=gwskUpuJ4a2g0JY5PiFttMjCeJQuS5S9UEPZocWG6S53nMlyt4gNfosYgLoQ6Jwhj
	 dtsb6S+afpYrUIi0QfyDP5S6e0bDBizWxKwt/uIC0tV/2BUoFA5ZIOjasCC/wOB6C5
	 IvBnQSvlGwdiy84Vv7DtwNnU0ThlI1+rpNmvLMNs2Mlba7j5UvudGA8dWS/wNWoEhb
	 QQZECfmiJHj8aTYEDJFrkXseci/C7M7RQmHvvaOKNnK8EDDOg1KshyEqtA+pwvZFub
	 CJuACGdj/HuNVrTYEYhxm/X8rI6+e/rYpIzGlIZWWTn5T4qJ87Gv51ZI5YPYmAqjvD
	 ATLFFKQC18bmQ==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 65A4040AED;
	Fri,  7 Nov 2025 22:35:18 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: NeilBrown <neil@brown.name>, Jeff Layton <jlayton@kernel.org>
Cc: Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, Christian
 Schoenebeck <linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne
 <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "Tigran
 A. Aivazian" <aivazian.tigran@gmail.com>, Chris Mason <clm@fb.com>, Xiubo
 Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Jan Harkes
 <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, Tyler Hicks <code@tyhicks.com>,
 Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, Namjae Jeon
 <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang
 Mo <yuezhang.mo@sony.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger
 <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu
 <chao@kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Miklos
 Szeredi <miklos@szeredi.hu>, Andreas Gruenbacher <agruenba@redhat.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, John Paul Adrian Glaubitz
 <glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, Richard
 Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, Mikulas Patocka
 <mikulas@artax.karlin.mff.cuni.cz>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>, Dave Kleikamp <shaggy@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, Konstantin Komarov
 <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Bob Copeland <me@bobcopeland.com>, Mike Marshall <hubcap@omnibond.com>,
 Martin Brandenburg <martin@omnibond.com>, Amir Goldstein
 <amir73il@gmail.com>, Steve French <sfrench@samba.org>, Paulo Alcantara
 <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam
 Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, Zhihao Cheng <chengzhihao1@huawei.com>, Hans de
 Goede <hansg@kernel.org>, Carlos Maiolino <cem@kernel.org>, Hugh Dickins
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew
 Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>, "Gustavo
 A. R. Silva" <gustavoars@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, linux-kernel@vger.kernel.org, v9fs@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org,
 codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org,
 linux-efi@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, gfs2@lists.linux.dev,
 linux-um@lists.infradead.org, linux-mm@kvack.org,
 linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
 linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
 ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 linux-karma-devel@lists.sourceforge.net, devel@lists.orangefs.org,
 linux-unionfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-xfs@vger.kernel.org,
 linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org, Jeff Layton
 <jlayton@kernel.org>
Subject: LLM disclosure (was: [PATCH v2] vfs: remove the excl argument from
 the ->create() inode_operation)
In-Reply-To: <176255458305.634289.5577159882824096330@noble.neil.brown.name>
References: <20251107-create-excl-v2-1-f678165d7f3f@kernel.org>
 <176255458305.634289.5577159882824096330@noble.neil.brown.name>
Date: Fri, 07 Nov 2025 15:35:17 -0700
Message-ID: <87ikfl1nfe.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: B55874000A
X-Stat-Signature: f8z1xrfq6kjrbfjkp449qf83yir9tmpd
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762554920-515368
X-HE-Meta: U2FsdGVkX199iWXi6a3cDZ1veLgG9n74e+yv1n03YTOUJe+7jtwZ9+IkBy9Jc5sWboq3nGW6966veIXaxDH3UAbGA4K6JDbpdEZLYl6iOYKQM46eVK1KhRo5uQGI1dCahcIa3W5CXMCmZwqKnU6mseDRBhL6ajqmSzkCozpU9DUTSzPeX00nIW6CmR5QR09BCRcov5KutABnXSA8B68UE7UK/xm4plZ4M/IZnEGzaujYHxB3NCuOkGHfv4mUfujTl08IUHkwKbtJmC9KrDEsIFK4bJo7efzZD/Q6iEMhLm10ABu5S1noMDSsBATUIXTMYPHIaDzn1Q/4VHm2Nx5oBevCms4gx1GJCGxUrZQfeXdxPULEB0EdRw9EY816F6qHG6beuM52kD1a8qj3AsIe5aBrFF2yCi7M1WKLbUD3SkCsusE/CqP+Kn+7QZTDI5g179V1Zyf2gQEyNgiW7cYyCTwL/u9Cb3YjeSSNz1lBwa2kztQv57UojGNei9mI8N6/kvz8HJmXVIaFvW9gdNe3qsw6UF8dDdapppCS1hOK4D4kpYzpG9VsAmLtXG3JSOZ3PcykwzYt5HFG6nFzscdVS/Vu9UcoPQaTfUPJR3pNX2DRX2gSK/hdcv2Xle4DMwx7u4s12XHXsjYcjiIPMFIHlyTL4LvYsANWAlCg7j/J/N3yBiKPkylHM0Clqr1XUex4cLilDrdjaQTIJDRJsrnikI+Ur0dAKiS9lD3M59SgXj8ST/KY62H9EU6+ggfNZ4I6QTr7UsmfzJa8lVNuuFwfx+x77+Hfiu57KN0QMtYuLpRxOQ1UE9UdKkqhtQ7jvOgETI6zG4IEqqDEGwkqPmbJW+b/4oeDxT4i1/Ov1BwXR2oKkPZq+2wvIrJoCKH1Husv6uH5xxmETIl2GG6bpmzd3FQh2GLWbQVSYxxwnnKh2t/Wq2Fm1vnifA8lfvSpw2NnckBacdhbXtsTxXc2tzj
 ysZp6f4T
 mqsi1xutSy/OPT0zB0x6QNEU3cdLkxbr19qrPH5Aimuon2eMp1HeP2pK40eJnjKHFvD88RGLWY5JKWUVOcU3v5XLZ9MfLC5EZR/CvTBcRDmyD7dHPMcDFIV0QM7IwfAL25+pC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NeilBrown <neilb@ownmail.net> writes:

> On Sat, 08 Nov 2025, Jeff Layton wrote:

>> Full disclosure: I did use Claude code to generate the first
>> approximation of this patch, but I had to fix a number of things that it
>> missed.  I probably could have given it better prompts. In any case, I'm
>> not sure how to properly attribute this (or if I even need to).
>
> My understanding is that if you fully understand (and can defend) the
> code change with all its motivations and implications as well as if you
> had written it yourself, then you don't need to attribute whatever fancy
> text editor or IDE (e.g.  Claude) that you used to help produce the
> patch.

The proposed policy for such things is here, under review right now:

  https://lore.kernel.org/all/20251105231514.3167738-1-dave.hansen@linux.intel.com/

jon

