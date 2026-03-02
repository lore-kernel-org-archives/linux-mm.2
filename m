Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E540CEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D5CD6B00BF; Mon,  2 Mar 2026 15:49:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57D336B00C2; Mon,  2 Mar 2026 15:49:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FFBB6B00D0; Mon,  2 Mar 2026 15:49:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 312016B00BF
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:49:31 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E38EE1A02F3
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:49:30 +0000 (UTC)
X-FDA: 84502313700.21.3D48698
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 24BC3180008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:49:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GKA9YAdD;
	spf=pass (imf06.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7qKht5TEG4XGxg/jBK9F/TEug/xp4e6yj4ovnk7QZQ=;
	b=HKfGl6hegAgcqggz5lp1fodaS09Q8lgEppngQb6EcMTWUOaVuJa6eTAG5Y9hZr+/m4vvuP
	pFMOfth2R8xFJkzeDMK/TpOyzjnOeSgLW8qAfMhYcpzNS9DMuCc+o6d7The5zqwOe6C5IU
	7okJD5CK1NJpvOfCXbOmocH5zzQxrPI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GKA9YAdD;
	spf=pass (imf06.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484569; a=rsa-sha256;
	cv=none;
	b=dV96LMo4wDE9L1grAinm+Ieb6OguW2JDyod6qE1ykekfi9Gi8nyyLepxV/3fQSc1kl4p9o
	7Xf+B1HeM33vwCm0IOWOMTTJPOOJEp3FCK9j1eXSesogjjI6ojtSrrZwaGO1FrOakAivDF
	ccHJFtcmqUJFdsbXpWWRmNbd90vJSMM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 772CB6133C;
	Mon,  2 Mar 2026 20:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123B5C2BCB4;
	Mon,  2 Mar 2026 20:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484568;
	bh=vzIQRv67NMWSNgS1VbjzK8gHJGBIX5DecOuq4g2+t/Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GKA9YAdDB192UWw6Ik1+IjOsjLdN6nt+3OcqupadQsh6+xxwtrbePQBg8GZbEyoN3
	 vO6jFKIL4G9a8Vq7JIVMLKNMvWgl2e686DUqFpww9RsYvJusQXIjA5DRSVALHhV0XD
	 sKJpFOz+3Prz7Gf8D8l7la5HSWWMcRbxrapQ0hXgeKUu0KUU5FicrtQM/r9zUst/+8
	 xRFRfobXD7ZwAShbn85mB4uV3Xlw5Ci5j0P45dY87aI+Vx9PwEHfpIyh0HKhXsT7zB
	 rJcRDsj++olsdd4Zuo3XxNg4YQ0KM/bM0nmSS+BEd63yAXecSzTWyg9S77GEGM1hj8
	 X/xOzuffFg7Uw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:26 -0500
Subject: [PATCH v2 102/110] fsverity: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-102-e5388800dae0@kernel.org>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
In-Reply-To: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
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
 Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>, 
 Joerg Reuter <jreuter@yaina.de>, Marcel Holtmann <marcel@holtmann.org>, 
 Johan Hedberg <johan.hedberg@gmail.com>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Oliver Hartkopp <socketcan@hartkopp.net>, 
 Marc Kleine-Budde <mkl@pengutronix.de>, David Ahern <dsahern@kernel.org>, 
 Neal Cardwell <ncardwell@google.com>, 
 Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Remi Denis-Courmont <courmisch@gmail.com>, 
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
 Xin Long <lucien.xin@gmail.com>, 
 Magnus Karlsson <magnus.karlsson@intel.com>, 
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>, 
 Stanislav Fomichev <sdf@fomichev.me>, Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, 
 Jesper Dangaard Brouer <hawk@kernel.org>, 
 John Fastabend <john.fastabend@gmail.com>
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
 linux-x25@vger.kernel.org, audit@vger.kernel.org, 
 linux-bluetooth@vger.kernel.org, linux-can@vger.kernel.org, 
 linux-sctp@vger.kernel.org, bpf@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=830; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=vzIQRv67NMWSNgS1VbjzK8gHJGBIX5DecOuq4g2+t/Y=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfILORiaxrEB5DiZmtKXsmsAIwV16e9x2gsA6
 iuyH09ayOuJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyCwAKCRAADmhBGVaC
 FUGMEACyRmyxK+AXHZh2l9nhLoEUj6daFKPMxeFZc3xikQ9UYU4tO+iAd3XEUu/T6UesQVADyRu
 Dg54ayCFZYhCuAN2ftoGf0q6tue0XDsH16Kbw16nWgFgwjG0SFCSasCSeNt9IdGGUT23uaoTC6g
 PdPhKlrkgngnRtyeQhY2HaPR39lqLV/WpLREBVsi9tv7qBQT8uK4z+CehDgoVEJxpHQvgT6mHCM
 XuSmjrkCS3sUkxZTZJV/p/a1Pjw7A34YzfqgkJK8Dx5YAyT+umwCkzRX5hXXd842n7WnLMk1n3s
 3SJkqTzDqh1w7wQo/pnUtztBXBRMosGGr64Kay2b1TeH9F2gw7jI1YNadmmFxjM5e9h469OzeBV
 N+Ze5M5OEzZ8KvTFcWAUJRlcDKDuGdAz7NHN6h2LBr8mmak6XiAn7UK59M8+dW0uo6Y81iF6eMt
 KFQQ12fURLzdqMx97SxsCE2UuejB4qBRta/1Xzf4cqPTb4/CRc20amRzBCmAuW5D5yvHvywKOvI
 Jz/KhUqg35TzOUn+kqMbWzJdkMUxKLZFCGYJnrO4+cTBN7Pu9CzR+6Gy0foX6fPDA61RTIaOuVE
 uUF+/mI1ADdERH8VPGKomlZtk0+OpgHhsLYUe5iC0cLB5yFrDLJFkkQ3TKCteBbnTzXXCmqZk59
 qJ10YlxsTbU003w==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 24BC3180008
X-Stat-Signature: qbsip7s4rzcsuwgcfkayp3fs6oh1pakq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772484568-339200
X-HE-Meta: U2FsdGVkX18+i+QimFwk2UNngQoalHlBfAmWYGfnt5knELpIHhQLfZjIJDaJT3yh5rtUsCRZjppoMVxV/eP2MhFfQES3Dzh5csKLYbCr3lhbnzKX8N1EK2ZxgQcDecjJ6pntTeO+/CV6cciPcsT3bqNYUefh1NMX52JwjwbU3xueL8AKhAN3DXrqfoJddv97YdPIXMBdeRUmyHhFk6nAd1Ft9yHbmv8DZHCxUzX1aSvyDTP41m+tWXmbicxIDidprXzzit0ntRvykH5dAa1tMfnMe43qMRmqNO9FekRk/JMJHpFWokxAEB47boHn7FT2yEJBDpo+HNmTD5jyWsDaQ4g0zKn6taQqWEg3pxDOIDCNsiXOoCd4Fe4ozDtmAcB7UTeF54+KOjVKaSy9t4TB3wqxlwo9N0U0DONc7q10QQd2ELslEtiEMLAVHiKRIcstTpzeIg7EDfJ43tNpPWYbN8Zd7auynQffyC2zYkrf3ggPwCeeSMj47NrcZhWGYi6OdCkNkthKUUS4sM/gHEwmPqbJrItX+a6olyVxg/GqVIzFkBk5oYCRBs6Phz3WUEq0QhzVPqii/uUbzJIZZOxkQwBgtWL/X5b54tzMBip0ks3vVXAMD21iSx1b0d8XATLMqEQd4yudPVybFYObtnPvC6kKSgFQT3uhSYWdcvZfnqMa+o9tf+CTc4NOwlpioUWPyGxa3ibucmLCr/lPOAjah06YRSG+3f35mkTIF6plzMjlVjwzTQ+t++Bypp06UesEuEtlwM+DtmS8vTbjQnRe4uqS5XKTlgQBtBjKTb5sfz71Az98fn/NGuNk05snSLufbDf9cPGvXcxyYPHINdUK9JxnFvoO/g+S8Sq8usRsUemeBDajg52123uB0tmEjWY8MlhldaI+DBKerR6bVy3gjU6mtKyMUnuAdOWjQ+TsAgvHMUzrCqCF++PKCyLo+JyvYDbwvjP6nI7UiKHAjLS
 CAQvb4Pn
 yc8+6+X97qPVBIFUd1Nqc28xDXi7VQUPMmBm/TUvq8oSyvKX2JN3277WgQzkS9l2YYYxmxdmgGnCJVCkbaR9xY76tiGM2QiFBS20cV+CPxbHFEBdnZNwRyr5VaRmz7/mW5WpUv8+at2tUfCbp21DhLgQwDNSumllrA0MqQ7fTTDgGXyow5M+WJY3rxpCRLiXkTQhgDRmqqyn+WZDunT5N8Xg5S2sxaxku0Xbolowa36EOObe150uByTyzdIczsNRr6HsvVckQcArgp07A1GvXY0kk9nkRaZAG28d/e14jX7YibgPWlxOGNeMzhrGzhAD9F6rSslaNxD8hoU+ceZHYy4fwuayI/ARYYVwAJFiBo++Dy//bQnohEnkpSsmJgKgF7gfmHtDosjsR/Ac7ggjTOeACQjmbJUGj63AHdoFJl4lNTydOpRyKbfsAnbZzZM1AbZmXnrZwoy6yBsdqhjsepvwgYxHzFfHJnmhLMOjghxB5TCgNJMMz52CaC3lO2HoYos6VLJeWER/fnxBeWs0az4NvVifYYRM5Kw91PSgbWx/L12nTzSUMLzZZn3HX9mL26bPuQC7tZUqDXUN/ODhtC8s98EcjVGxxJcSI3y2RTWvboG3MwiujWopbrIc4BmsKVZJlVqZv2mjx87oICE+nY5kebXbjJi7HuiQo8kvCbH+DjmHoMujC5YtPc5t2vGMRThlqkkop0cMuG4vsnZhdVieXrn/ylCJ5VcURbfXqMD+tXwsXGrjwXwx+qv+Ks8+aLT8RANoBttvedPgo1xVbFHnr5+Sn/luDDnNOGDThmeTNlgrQEHzQS0+9TTfbtLYrS6RfsZ9mKrmXnag/gc2FBhdT4iJJlF2kJZDnb5sMh1vQKrfTREJMJrSLz+JVUw4KFH8GIj4SBvnV6hIAOtSK+Pw0lmOoiU7IMDuQ++ygR3U3bZCW4LnRDDhDtSw6lI9J8XQSE5Y/XAZuxO+Kcj20LhNYEH65
 5IuuOAhs
 Y+FDweUkBGq8W9K77XuT8qN/CwpM1DIRJUu/lC28Frcjudvkgzz2LI8Mom9z5m7S7AuuvEU3eNICoaDf9YOW75ajNqMneX2ojSaB8nfsDY7rTJhPUNP+IJg1+XHo+SSku6voRl/wj+a8R2EhSizgOK0WSWOXvWh+DRpdRF1OeFNZYr+S3QzuWwHE+ymO0f30eY+cIiwd6mg/52p/ywE7990/ig9Pgkd2JpQM/Tyl0l6Puwt021V9GfZeDRgww788SEYNC+XkRwtUfbYbYiKbeVTpxXMw3adTD5yWKNFbLpObW9ioEXXDp8pSZM2yRH+1h5ZEcfuViKnUT16CjsidEmLzWHS5jLT/ehmEBJ0sfbaJzv6AD+C53xyLZmRGkknxpiwAPt4aQtSPa1k+01+hIZhDPWBhXHNOR7IfajerTRpYPw5LMHW16NY/t8BFt9g/ghIVA8ADMV9fI9yYWvjtikdKyJBHGGaemZzPCQ6FJCsHl5Iu5h84eYE3lDKgV2ob5Yzi+hKYbdSWnArCV0oXVCzEdbJrMRZ9vBSBC8W8FiKiYuUTlSURk/i28SSnPf44ccWoyfSrdkJHwv5HQounFDkKY8o4rGbbtANq7mu1WDvV3BQyVbix2tbE1ku6mHNQFR+bVB6Ucgc829iMUT3JC0ZhyWctvDu6xEhwcy6Gha57leQ9XLSjUBO+dR9EtPS+sHDR4C1cwagEKmA3612CKwQ4Vc2EJrm4xYruarWcQ+SztTty6Iqk0jIHglSU2EQoMj9GPEu4DoaR5vHl+dlambLcafSdHFnH4T5coeb0KeFoVGHeibJJryJwb+LnfZzXluxj57Fm8X3uKTukkKQbPrmiWPTMK/cEXsrPzhJAWbQ7BgcqD5Ibd2X1KGWjVXDKhYuSXFvJ03/EmAUb6u7AAHC8NT665UViyNvbzmjn8IqBXjeKtaNEour99qQeL27tYMO62x+mAW3//ZPeUsWzNM9jr4476
 j/+Kf9Xt
 NEnGiyhpMfGHa7ff9zTC1i5FQgs2sU31dUbo5WELOfsRuVkT7Xcc745//PLcu6hzgET/A4VSwrR0V1yyexTF6aqaQANrXKVTQgPTQjNWU6DMxMF3nrojte/ngOoSFrhuALcbhSvNhSnxVnP4AbJL9XZdrExeiv1bwX4NQU6SovXeyO0P84Y8XCfLsDC91h75VzOTsAlUCjOZ+xxEh9MelfqaLipLZXXZUBzBEj6PKBg3pfzzOvPulOV9BTBHkLtvaQCGWNqpR53IE644SNMgGHR7L7Evd6Bkp7HsngK9lwwverik1lou6TXLpVYX9ms3BsanQyWD7xNP4S0q/nROwY8LStf0GSJWEhGqQ70mCQPe7836znU1YHkJ0jfwbSSwa9rL5AkvYGo2yHwFmnPOMQiyDDj1CI6TROsYME/HMTPIrKrD2i++WujAfLUqSV1eYxIUHds9M6d8dYXmZuGBMu6y4JCTca+3R0lZ6FcyZVjev47zTRkBi27lQBzGt+fXVB0lqmznyIr6SuDS0vAOOD8tK8FWJDF8KUqh+TtlycSwnvmYsTLQzK5so+HEAnD6Al+Td2FfNdkNPN70gYu23nX9p/x5qeUwe05XZTKIHbMG+DSL6htOWWr/aw/UFYbl2SXo1LZJzx9waMPvWkRR6/VKGNG7z/f/fjcGt/IhbiovNziA6O3FrtirlnsU7syIF+xrM7dUgTKUJDMFa/2enfe5pw5YYlO5VZlZgwPjB0AKJxYzNVMsWN983gxfN/RKL/qrJV8AMHmAL07EBtJlPEjis3hWZtJCM1ojAzE79cYU1l1JJFT6+XRgxCD3UG/g/jptX8MAK6UFg2S45x6Wiwg+c5x2wnfc5BMBGNe1tj9HZvMKExrCuYMgppPZmH9M4k/pAajelLYed6QQGUssUhOItvoVclUD+EOMOdCjtJsNWKZaZub7ZRl6vyS6wI43jA6wcjNMvc8BtS7su7RTzgcVEBQYi
 u1H3EOYW
 0jHj3tynPAnCVSh27e+sS3LPdLaNP9D5UbyeiHPhsayq+N7Zv/rorwtXDIDLWwc9lM6As8aJL0ey2vp4+uy9t1ocoZkyWGxpaq3uVEgOPnteQIhORK5em+73qgex7AhSUeFwQvYbEkY/rnxm/XbYTDOFZFNzMKfLeKifDP9aOabJL0O8lbMYW8s7o8TQSfPtS+fnD1jQ1hWl4weLXDBtClb5ejq/2cW5uD2o+/8GYfnONmUUQe7oxwl6He0HCKtal32hluPPhzPxgRrO82EWDVIuSaa8JlWoocrfNacrV/MPkYLITSsoh84r/bnj7MYrewHDazLS+Vwl33TuElymF3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in fsverity with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/verity/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/verity/init.c b/fs/verity/init.c
index 5f6a7b4f0a34aedebfcaffc2be53e00b23976217..3aa55dec88fc919792a2cb4be476f8481ef78a9e 100644
--- a/fs/verity/init.c
+++ b/fs/verity/init.c
@@ -50,7 +50,7 @@ void fsverity_msg(const struct inode *inode, const char *level,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 	if (inode)
-		printk("%sfs-verity (%s, inode %" PRIino "u): %pV\n",
+		printk("%sfs-verity (%s, inode %llu): %pV\n",
 		       level, inode->i_sb->s_id, inode->i_ino, &vaf);
 	else
 		printk("%sfs-verity: %pV\n", level, &vaf);

-- 
2.53.0


