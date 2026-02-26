Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 616D1FD8FD0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:05:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C12A86B012B; Thu, 26 Feb 2026 11:05:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD9D56B012D; Thu, 26 Feb 2026 11:05:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A929D6B012E; Thu, 26 Feb 2026 11:05:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95D756B012B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:05:44 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5975BB8061
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:05:44 +0000 (UTC)
X-FDA: 84487083408.01.6355DD8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 80050A000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:05:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ul3rovIH;
	spf=pass (imf25.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5AbxXI96ps7KW41leLCWpoTwGHyFZf5Nrw5tw2XdvA=;
	b=4/fLZxoHjn4buuKG9Qxx+IiQnpRzcb0bKp0/O1MQnz7aNk8Xlw9csrthyYf5mQW9SJ6YGB
	s4QYqVQBOQZj4qMOuLO5j/uESq/fPpYxV6zEVuuCjE+pXVwen7HOLLdmLqt+MHpCmdjL4M
	STUzMgJsnhrAzfSkT8zGxAJC2L0miKA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ul3rovIH;
	spf=pass (imf25.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121942; a=rsa-sha256;
	cv=none;
	b=HBJnrF3MsZKqqHheI5Z/bl93FfTQF2YepCrcF/6G/HLdhEJoDq3BNsgX3Yeoc5Ws7nqZBX
	W9WBBmYLsV0WS+fIhMzLzZ0wWOkyWNFyn1hjMU9pMRuDOliwzR5EqunebCvADuCzdvfmkf
	l4aFiUODJlZfPvBq9zaM5Xofku3agb8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ABA90600AD;
	Thu, 26 Feb 2026 16:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C81BC19424;
	Thu, 26 Feb 2026 16:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121941;
	bh=p3nWAP5CT1ulwpvJRakx7FIjnQBi7GhZAUzGirZ6VUs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ul3rovIH2+WUunaOYEP63DXql7KMYk2OV0h8NQoCk4Kg7NS4RElLfpNXq6VkHpZUF
	 1FaZT+UHC7xzNc3esBZDQ5GI1UkEzyM8DSFM+56SIG49C/PsrUztxUcJar2c4DBdc1
	 Us/TQodxJKiYzavt//nVqe+ZxU9a18FeSlv5iv6L7LYafpMQHbYTs1SuK/u2PBZzN8
	 TyuT6HlZdnsuqxFciXTSKosJFTYXcaCZkUMXgPm29KMqfQHFiSek83336xSBoqWuSi
	 G6qIXvakzPqVAtgMSstXPG8G69SBqGgIZCqM1+aRQxCs/psd6sO/o6gSUXc3aaSNl7
	 +OWhK5JG9EBng==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:47 -0500
Subject: [PATCH 45/61] qnx4: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-45-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1182; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=p3nWAP5CT1ulwpvJRakx7FIjnQBi7GhZAUzGirZ6VUs=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0PCoBESlfHnrvoNKvSIwMyJsP5Qf69ywFk0
 e4gXuH1Qw+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtDwAKCRAADmhBGVaC
 FbpiEADCqc+dmVuH/SW2kJZwzUG4seXV1W2jOXg3GTT0JJy47XDvMOa8ny7NPegQxcow4mjxnbM
 ehu+ktF+TsX60rUeNgzMRJ0aAV8Vpg1+exq9jZpO0yl2KYdWD0E8gCEBTEkk8vJ9Ezs7FZMP+Ws
 atYkMvvR5NACbKcg3TplPWBHeuRZQYNGB4sys4SpnzbQYzrjGhGF+93wr4t3NbPzsGi+oJ3lq5u
 WuHvq/KfudmAqIKUkrOsLZTgy/3K2ZBAF+1KQUwsskGcQqTZf3gcV+/sfZnUOv+5RwtxamY/q3f
 fpgJRyIBtliqfUB9+JI4VVhhAcvbeYSRj5z+U4DSQSA8uS+2vC6Bf/5NOe0LqwZRJdTBpdPDwZX
 apworER0Ru6pzxPYAnQUedV093TdPsPEGUEWAWIm+fVS2g3o1jnpYc6hb2yVePETtvxYezV/EqN
 qNEhYWvIqK4OgjbR5THIy1ZW4L6H2cJsNx20BXCfRVXn8rKkGwD9LiSqiBa1O3TUezCFyh0zApD
 UHdBxb9ZUqwbFqirtM3i34p/PQjOnakjp8g0MHzIyHhP+8k4X+qYzvQ8BrWcmZ7a9Pmt7t9ongz
 jIAROU3o/STE7n93o27h1jhhMdHxLxf0USTG/ySW4Ahx6Ll8okGWAajR6kmvwz3afWFISufeTXF
 vGbWAiNibA8+Ryw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 80050A000B
X-Stat-Signature: qrrycsfyr579zk4k44f45j8y4mqudfu5
X-HE-Tag: 1772121942-386826
X-HE-Meta: U2FsdGVkX1/enjaFrMExfKUGsxHFA88uvbyWPLUX85JgO6Dsw+mtH/xF6NkN2d9dKewMSv7A6r4+45s+bufAngNgs3h9zb1KO9SGLUy5phP/LGX4FM5dUfA5exx+0w/vnLXipBwHrMJeyqL3wjU0q4KW9nD9MK0YH3FDaglmbtkaFvlo2sDDa1ZhzIFUa72v6zjiqF3IakZXgNcNLmYOBwZXeKfmE2KLTB3rp5xRZ8pHNuw/7dvSHd1koIdxYUb0LXCzRc8fXd7+UaQFdbjGa4HDl/W9HbSX1/jISI5T8UNOffSO0K2pFEVyYUwflc/Oql3dqxOZzhPnIJE5S6YQS8SAzjCsirGQJYqGxc1XUG5BoXXN2qqygk3IDoJz6oab+Hi2c9qnf1/6AUTYsjgf8RknJpUv7xL8MNSw1a30t3F7194qrdyjDGzHm+1w2VuGhaTz5FEaTK7zJDgcx9WqDdASRjg0TQKav6Egq4ddo6mSRKBlmh68sMuRgcZeJSyfBb+pXP5xOS/ayaaoISYgdWEWNtTn5gniQGdVqoEr94PHscGecJKorOK8qvQuhi+k/CS+meC0m/RsYQrRgBYMI/Fmu2EnNk2MnXaXZZDx8YO4Cb6etckdW5uw5uOns/AOtvQRv1qtxtHed+aIQHJjdYAkvF9GgTcwOBZ37imvabhwyVTh3fMeIkUt4o0B0yHiXiGEyVg9vZYArdJC/lOlvhNp8LHSICcLi70qMXYxRV5zaNfk+dqYTSHt/Q6BbXu/Os0pC1HCATOyj6EMwtsIHfljF/Zc/S7sj1s0hOKh2E6v6lStVRDt351CtnsObVId8HN1RkMZmcnXhcGgEJaFwi/DEfUDyEYDY1b0pBFXWnI2WdwzhxYimy7xO/MdsBitJ6wuvQLO66yV3fC3nv6MmXV5w+1/B7BQeUgqS1uPkP75oKCtngDGjFNNlL5v+3B82d6PMEaIbnQCOjWzHTO
 WPOTGpEz
 pCKFFsxtkB4sKyOV3NpYGI1RG+a3E7kx38lLiFSmN4snUCHK5LFm4QoqKwxshLWXQUmeBzbxCl9+t6D68UQH901DtOgOaTmRAhDx/2Ey00z8DPQfzpU6D3qs/wZXr0XR8eAgI02P2gr+ep/9v9z2Rb8LSECDuv7XOeRy1SFnfW7L2vAobLWWQ5GX6AX4+5GZnFc43bk9fgCu34NIiSKr9LPz+7DysQMjJeAYL8hxjDDpNXQTnYyLa0Dg80W+rpeYcQazXHyKsdBfaFItr8Z9YtLV5F4u9jBKek/hQKc04ONGKv7CjWxefgby2BD68udadRwGcF5rRhDb7bCih6xYkZX1i+cjinIgug8g5Kcy8dfaLlMRj8r1ST9Ljf1bV/IhyZWAd9Z9j92Iav4mr5UrJK9Om54oi1uSIEy6giBWVaxX0ERFl8ZrE7fTOkeHLq2AGPnLDHPg6x5aCxBi5vXGZgKRlfWFQtYf3tdVjscBQOpskaNe2RCHRxaurjLntPLH+7QrOrApKGYzSdFwr7A2UrfVA6Gq2GZjDGCacpVQdJlIG8/KAsW4aP6KKz5MglFZ5Efr9xp2hD0t+LJYaHlpdjBKEzZFS/z0yLHNZeApdzWy9491G6IzAN2doc55bqyzj5EqA9O0gmkEaMlbKzrFBioMvL824QLzSXPMgW91DZTTWd5k9Fq/fvSuLvZNwrA0XEwzOUEisOxGhLszLMlzBaq713+b5SCp8v2QkVXMNS4iDxqhlys5N/CHUyz4viAb72v8Dx04mS+XVccf0qiIOjRwmF5GreABWSxkteMTz+LitttnOlOH9gDr3Knbqpog1GHsdRhxY12sAaoISc31HW+IKhr0aMn2B7wck/zUPgOgcU/vnICfYe5RxkXzBIQvqttdaR4RLzAmkV7cMKCHJmfqaCMyYts6TCVEEQj1mPpGd2BEww6w3zCbnR0xvWan3me2/jWcxaoS6xfwJWf0W6hRu+PCL
 32yZ+lby
 aPxD3XgLOCfasniEvLovxUOPNeILVzBtlH0fMED8AYtQVCM+ZRcDlT85L8rn3C3t0uGEpIq6IEoBrG1nOVXr4PZXhXDI26Vlj3ERSVEwPf2mffWdlYGg+41mq08h0/sK99I9d5TMl8YweLulQInPLGdIS2xLdsyIVKwNB2ELm4/OEuebUQfdCBmYnNIcoLO+xPI9aUhQa/GjmmUbr598p1a13a+xgbhwBMkpOt+EplkHM73lcBXA8Jtr8LzR0NDtd3zJYZ18BXdA6qCnMeM2uqj6AURdFnTijvKNzbq0zFP3f/reEK2YllxFr8jAOL8BI84vML/67P4ME5hylAyXk7j81OMyp3lY8RGJ1OlpgB2FdgdesR4xeZ+oPhwB9CqXPpDFhE6yzHdxfCAmCzGGHGAqTOOiR2AByuoXAy+dKiSNzpqiZEMiaU9dN/nSF9cY6Rbsiuva8xLDVvBDd/P8DkF3h/KoOy4b4pJZP8fylXFyUj0N6tmi9BD7SiEsUIP9tS17Am9eVAKdQxyerhBkZ6LZd4PXMQm8eYFKFQEhUtjSzn9gT0TrDt9AMIn+DXqtc6dnnTu1T2Diiv5+ZfDt9Bgh0xhhSPRGouEdK4nJ9CL6rEhrMnjiMCbModrGA7akVXgKhUogpBAudyUIMl5D0Ze6AgkslgFygqOzCfuuvfjJSGfcGWP/c4keONvo1JRD/4YCLuO2CFeXzVfS1pIxKfFptcgfA4s4LrqFQXaUqPFNdINUiL2htQvVk66blniaX6hG5J0L+DCGQUlqYsWFD3JI37QUgpFNtafKKI3l2bIEUPDWnnenSyC8VYISH02aJyKo5ZxRy2h1DMi+TNh44Dygxl406GpSZlgeTPH63nv6Du+RVky3+S6d3kofPbhzmcn8pNTHHbLPwsmpYgjLODdkBICmXnxNEUr28HBMSfvPDRCWqs/s1DzOXeUBx+yUwdYqYw78ofQEhL+9dJ0pK2A+SSU4t
 UFXaZGzS
 Zem8ZImUbWvhWgRCdrnrR0jxioVLVmIvlRh4Pz8ssCYf7F6OAC59kceU/uxHIVoqEexUNW8wdBilOtpHMPO7JYJzmNAw2PEPBJnlT96Szcrh/Fdm2RhCW1YP22czCYNO21uZZs64UpyWZV5XZvUjGdJLp3HggpY4WSw7oBArbppXXVJ/sK5Ky1q5KoDlbTaGvaWj1JwmjL7p8pg257NA1TsWj69+E4Qz8cRrd43nSjMEHcYXtQ7q1U80e7xbUT7tVY9DPovQRfqa5uvwjQhjFGIMYxTjLVhxpTHUqiDoqVejQRTjNg1a8NrSExpZSQv2ZKtPhPbskR/4JTa1DXTIpVDl5FFelRuqGYjy9ijqlCPd8tSlWWTnNM+NkBJ27eADBhxPhVfi1OJrBClgPhoMG1ycJlvBa9lak83A2sV6aQUmrbCiCX5/03k+U253F6foroRM9ZKTT+xLcbbrZuTx1YR51Mrt9SZGD1gCW1aN1WfzfzpE4xki9GuhVZJQNCtbywJ3eGejcwjHHPD76kqHvQnWD7tXbGzTnxHW7NTl/aiBNhCLuMfEqZ6qkvWPuncfd14sfK1LosyfkT0gHTWoVxOQU2w+9OEpmhuT9et+SOl/Z8hrODZ7ysEcRcMEaqNOQSwr2lDgQwnPMZRHA3t09siNGi2Irn00osOg40fbMPaA3eOVs9thDECMNCbfQLGl0JyINZny+ZUyZTLsxYk/h5vIQyuHbh2S7uC55kV+T/OhZ6LDxWFPKe+nrxwZXTk733At+eLmv5fV61fdOXZtPbsra72tZZlRsUww2Tr/O29W2GOdsu5bQuDTlOU6Z+5pEwHQ6+wgYNLhGi3e86m4R7aXJMYRmGaVLz3fCpH+JDq9ub7dbVd1ESnx+0I6Ud0L3UtYBjNMapX+V2mFOGQWUSjpZvrscs4mxCz3bjFoFp3GgssK1om3/VzIO992lsW1FmyoYRGdLTAJO7lB+2Z2J7XLQWIU+
 RCU6i5/V
 iyw0kqcODEZgBpu9tIK4pUMPOdSMJRMo0jmy53eb9VlLy/EKJXj+OxWrrt3YKyARENzH7hocerNotxw75fTXGLzJHjQWVtp7nVK/DC+FF22ODU5lmptb43iBq1gOXNjaS7IA5bJlwfDv7uvulU7Fw43Tbb9eYtoS208WQOzTu1CfKkzAiGX9mkU7PDuBoWPaxplw3bDpIgNnrOp7TayyN8wS8SsTRHCqB+5HKehs+mIvzMPb65BpAMRskh+B6sYO/rw/LrPy4tdUntuVACugUZVLtq/wrKr9Bi+ujjpZkIx4/owzreIlVkAadDRJqNHa2j6Xofkd8DpCdWDcgklKo7N9Fxb3rRDYpUcQVt/mc/a1TLP6bzKnQOj41qi2gmX3mLGC3X6417kA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in qnx4 for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/qnx4/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index 8aeb63d397cfd6c87b7862f0dc7a34cdfdf02f9b..9305b8bb556efda2be578c75fe3eb35ca095f8ef 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -62,7 +62,7 @@ static int qnx4_get_block( struct inode *inode, sector_t iblock, struct buffer_h
 {
 	unsigned long phys;
 
-	QNX4DEBUG((KERN_INFO "qnx4: qnx4_get_block inode=[%ld] iblock=[%ld]\n",inode->i_ino,iblock));
+	QNX4DEBUG((KERN_INFO "qnx4: qnx4_get_block inode=[%lld] iblock=[%ld]\n", inode->i_ino, iblock));
 
 	phys = qnx4_block_map( inode, iblock );
 	if ( phys ) {
@@ -128,7 +128,7 @@ unsigned long qnx4_block_map( struct inode *inode, long iblock )
 			brelse( bh );
 	}
 
-	QNX4DEBUG((KERN_INFO "qnx4: mapping block %ld of inode %ld = %ld\n",iblock,inode->i_ino,block));
+	QNX4DEBUG((KERN_INFO "qnx4: mapping block %ld of inode %lld = %ld\n", iblock, inode->i_ino, block));
 	return block;
 }
 

-- 
2.53.0


