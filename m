Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45A16EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84C366B00B8; Mon,  2 Mar 2026 15:30:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815BA6B00BA; Mon,  2 Mar 2026 15:30:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C0366B00BB; Mon,  2 Mar 2026 15:30:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 59B2A6B00B8
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:30:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B92916033A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:30:06 +0000 (UTC)
X-FDA: 84502264812.18.A0F6FE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2EE9A40015
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:30:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CGd0nv1U;
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8jpbPVuzTJFszO4DDE2XsCc2tmYhf2Ntyo1yhsjYnt0=;
	b=DFTZglqXFT5aNc/QxTdhVe8cflXSel/kqSlXIM9TBDRyAyGck2H8zRFYgKlqtQlGT81GOI
	LP6pvjcTaLWCjenmo4tpdpau8jP6xXpZgqBlLiiUxpca6oTOI5yQcLAUJY1KfT1liGznfZ
	8wjYfdnWu8BvsTii2dkMJIebauiH2Ds=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CGd0nv1U;
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483404; a=rsa-sha256;
	cv=none;
	b=R4TpixL007MW7nig2FI9n8Jo/7LcmsWN8EVORTiZ0t7yhLkUNligw+mXqQ4G3SnWRk4yVZ
	W/dZdrxPG79rWFpEZ/wnIwrqwnKTEtNw7ISfPvgZBDxwGGfH5a/FLrny3Thg0GUR29oppJ
	wavrgBygDlPp6eEUuMvUqQ133PFYp7c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2903E408EF;
	Mon,  2 Mar 2026 20:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA0EC2BC87;
	Mon,  2 Mar 2026 20:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483403;
	bh=1uE6eNgLWjhTlZI5fPcR1cRgfMraDTGbBiD8J29weO8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=CGd0nv1UP3vmSP2ruwtij3DdWX6we6kS1yCv5d8Uwn1IyqepaaACcY4sa2Fm/3gGU
	 lcmP8KEIZwkJbQn7ko2nkYM9eTo/CgdjJPn9NUNENpvO9vm89SWnb5DZU3GsVEKQI/
	 S+0XyxktJ1xQOqV+6N8tgoT2zm/qaogJK6DnGL7Qwd3gEkh15/VE6rm5edry2m+MhG
	 by7Ny1BaprkSLnDXz0biLhJ6d4Q3gr6W0J84CNVu2X2X9mwYUdbKTKCvAEEk2isYy9
	 dRjUqGMYsCPAzzmsGji2xyuMWelGJ9D1O28EveG6jkhf/Syz4dwVTiCParqHM1ZQ+1
	 kgFfa1QJQH9sg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:05 -0500
Subject: [PATCH v2 021/110] bfs: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-21-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1133; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=1uE6eNgLWjhTlZI5fPcR1cRgfMraDTGbBiD8J29weO8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH02B9pVd+vLI3tsGZcHh6xG/C/hj6NYi2ea
 8V75fnVyfmJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx9AAKCRAADmhBGVaC
 FeRUD/48uqnf6UKtVy+aiaLzavEv6LMazv0wx+DEmdHZtpC5rZUxFSrpRomhtWLcFR44QMxvrl8
 9d004fxQI69tc/63aCrpFvuXJ53LUCjyTtIv85NqSgUPBf9LG/Pf0tBKwmKVmk2CC1yH0qAGrqg
 Bui6XcBhwMdMrfLvZACRfwaVDrjwS4ILmolPG4mrsOAOr0ONQgzj6ls8qGZRbmneQJOuyprIN7J
 oaDCIgwUl4o/f35hF+SDoRWAZxqSQEYTWIbNrFesuP0ENF5YCJ7ZEAhUNCqqQbol1cbJoaPufj0
 q2kG95bnr33VscRsxto3Ini818JFDTFe/rEl/6JL48ToHRBgJZm3UYpIVzocW/LkVpJ1qChf73q
 b0F5PuzdQ3nC+ACmvBZwqsYJQosjwdbbK/Uae6L89+pJcDYwA+B3G/DF8124IsWxS0eea6QAZpK
 3ecimadjNe1N8WaAP7CipL6KQxSVrEjNsi3SlrdTacHxnJw79wK7CBtaXZri6nj5ZRdCfKtyLtb
 KX2srVTuZaXg54g9ZIP4cJs7BxeuJHzfjmK5L+R0jlMOEX7c1IlFuRj6enM7pDuqIBWArr/uVZR
 OtGXPtFEC4bUrGma5Q6b5XXy9IQMh5JX9yz7NyIE//JoFUaIBKl9EIEWUoJImSZqt06ldfKs3v3
 s05CS+pS0A0Qmeg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 2EE9A40015
X-Stat-Signature: apqefcg6cbjzcrcr1ptanjoxep9smkcq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772483404-583233
X-HE-Meta: U2FsdGVkX1/swCOQ9o761cLxmb37sUO+BEHVtnHM2Uq+Ne1M1zDXSyTIcEdyTn6WhIHZvxnnW88IKJpbFxVGF0bHJFSvKJv3/yOdwWf+6BaZ92GgdArugsFBeLGlhY9IYh32shahkT5MUTskpoXg3kp/50k0BUsLW68ECJE5zOTuvH8Wg/lGPA5+KyFjMSn5En6ENR+2ysLmHrnglxsOYWLGLAU7i9iXVhe2Chk4CKcASdcsm7YXhP7QQPjs/f7izzVRJBVPBT2ITTX3HPqHN1dYlx4ANCMhmeyRLegMJPQqwE2HHykx85is51VunUmZVcCXMGL7T8haatWJkuX0M2FVgtoBDFfE3FzhOu6iAJ+7fhpcFnXWLZpCUJBz0JllVAqFVZO/o+bRNj96skPkvCvl74TMFuoKO4BiNvNcRHkSqoMIEoYfV957pFunFi4rPuY8nL2Gypt5UPAXbeXpWvBbIvMyAK6zkVtb1QYrhwz3T3HKZNY+kmNa7QyAWoTVZV15Pob/oed5eNeKG2yeJC/xF3iw/JLAQQrfzdCNUkg7FlS6l84ll/LjO4UEDChEvVnYQ5AGizHgFzu/c/OecPR3+LW/WDjqfEC1o/xxdMRazc7a5D0TR07Mi8H/wkc+MUm+Y3RGFIx10CU5CbyyLbm8Vq8Y//0AEQ8lhSXRLAowbV1sFPsUes5nRN14vDjWkWgvRgeee6yQUaPU+Lhftc7ptxl74O+7HtNwhCJMFXut9t5+FHmJQagmduKkThihkiakC9tj0GhtMKmoQJIXQxMEmTIy8fc9sYIZD4W/0g+cvy/WEiAHCi/rjX+O+0KanptI7nmD2NBoUj/55iIwwa9LtJs1YTrFeGjlZC+JwF81vQwCCcKqmaK0bAo77Hfep6sdEmzTj9pS5lIlVeJd62VwTkZzKiUvIDDkMQwUF5LyAaVaaDW/a8N6xhoD64JMbzvTLLRHU5a3XxniiXz
 ApZFy/8m
 +HnS9+hIvdBrhkcJBpfMtuNBT2GDOfzYRAIgTEQkfg4r8fVtvE8IHslTgdzOuZltWLD48qVwnjyAPi5flAVby/8+75T9xL7qMs+w7dEU8qblYG0Zjn6eDquB2ynQcz72Alq4h2qm3pYIH+VXihsWQIoSR+esPvmEJlDDiUIeB6kT/g/cqFPAen+CtaKcD84sAk8ClNE1QfgwAZeVCeBNORZv4FX0R7/RKt0lihJRdycVG0G0AorOrLX+2EPikfXH5tiv3ktWDjdCBKq/F56w4dXIPymFFyGOW3itQpXF0DAGVjygVGk6epsizNXQLoJp5R+qgYcNOq/NlJTWt9MwW5UDmbMao1XINF+DlRBn2rZzUbOmiVvmCOeuF9ugrDuAp37P3D0WrEhKv+Gu0A6F5NeMzpXLMehLNgjHhmWqzs3oLvelAjzp6Jjf8ckb/Bd5BmrGcP+TJzOFfdoynzORHKxAYYsw5v5GZWkvox/TQ5/TfSWdCXWpVwp+HiQxb0GqNpoycs8aXzyYO92TpUuVmtgUfTFEd4ivkRaMaKBlFKb4z8adA5Huphya823Uw5J60ldcKWzxq5bADGRw2f0IjXz36a+mxsN5iw4t6syBJOPbNFv/1BLuwlV76TsOlTZTwZUfuOTxYuLGY+V3Q/7sh626aQElxxuKtfkE/X6bZPTqMBANnMQcaQN3bin5s1oOM/W1c2eMsl4F/xjbWb69HM6oAyNWNiL6B46R7x2f6j9wivOox7PrZqyrUwvSIdVCre0kWMJMUiY0lDP2ZrwVSXc4WfDNZvh/dNmxhlOfljQ2AH0cYfo+1aZjqNdXkdp06cgfiqj2EoRwZs25RE1OLe1QaHrtoGAHBfnInModlH6paPJR5mj/ey1wQew6UmLqJFlDvIEHudOahaCqnJFdqCueW4LNZ+N/1Ct/BUALKZLAcGIVzStP/7mLKoHuH/EFXcvvRWsHrWHic3mkHPheLD9bYycGd
 gk2MAC30
 RE+H6qflfgAyjCx+ZvqVXnftam8MyOWjNWeLZaf96Eba6tOJwVfUhBKJYpPoQahVeltgrSqJtAv1hlxfwrHcVJBmhFNFWu/emo2w1Dr6kGd9oXPOZsVphCxD64JyNxdm1KlSbQvFhMK91W5ZKKFC2EC2vV1MVusbKaScrhcSGk7GjfmLIpRAnO57yxxUCxKv51dju6tc0v7zDLFi+fWSDKjf0ntyDLj+QJa328Ju5m2Azk4qGcAtDc2xGGHkTzBovWOwbWbfH1Ohj5lgPf1VKnxmWFmJgTe348WigrkcFeaD9WCpxxx75oIFHwlvvhfAUrhE5sKet7VUptcj47Ba3Sv0DJCRzHnNjMLHBaFKhe+BKuPQf/szf/404iWs2qewItXHEjf54z+adWtzj9HBRKvdxze8CgM35dEaox6vnYUQkiNXsF0ony1ENKRUptDRM4nFA8UgbDhwJ+RTTxYyD6iM2pb8NnwBisCE/pfr76SXHWNyhTdOojGTUhbeTP1HdfZJMQ5QFRr5FXC98h1c+bApZuLWpIWezPny/hkVKU6lb2SuylbMxivoqSAXnncQD94tpDDq7aQdOwqHwasw9C/EoxYjSPCkwhmJKQl7LZaEWlXWVGRmuYTOvROyyl9isboY6ilaaTTrVmIuwnlQIeEoBy0jQHxIfuGZrb1AJLvCtRHMBtb1hw6wsY+JyfAgc04uw5vGXOFQLM/bxqsnwnPCXrzn9Z+ywc1d27koVEfvHms+UhoFH/wL3ocwmc6RAq/1kTFez9b0sfwPQeFNPAESTJuo9ipwgsKxaGXyPtgll1Y4bAADhuFwBEuIpgCI+18RuJK7T1ewsS5pqqHPx8uZp5JyL34RYgIU9NAyou4q9Q5tyRVbVwwfYVAkgy3Bj7zANMdE7LdOPQUdaSlIGtzK2A/vFbVmhUK9bEM+DZsvYwPaRjEsIhDFXJ7vXz+7v8Ii+YAM30wt09ZnrTtu2LAZdMIOF
 wOyAwDcN
 po7LUzr++KMLMg29d3Mi0dirCBti6qI1sWLiR69lued7R/AwEbRXtMBurKgVmmtJkQVTvD4ACM+X68E8zwu0SaNY3mSXpACK9PcobfJZfOuYMdQfUJxNTiwlE3BkAAgk91FrRxF1hWOXoYNUgoIm82rInoVxmF3zRAPD/83jkOgaB4siNhMxa48whmtWLUJ19ZUSgnbOhaXCjRJDnfbO0i+q54l2r2o5GYxbv9VilcMtMokHNofJGstZM8X1+e/fYmsRy/SlafFuWpvb5CK17FxVIGeKX57UQitic1gYRFKsFXiPoPoqhUAGUG2N1JzUe2fZngRxAxnKu0mOAlmoNYaHUEtbrwELyieMedHMWERphXUO9rvwMKbS4O6oUyh4U9GO8D3Gb9VXmUfuNvfhiPmcGbUGYp+iCe+l0U8SXXQ664mcDGoAeoQ9g1wTpirQ8hOsG5BxHQSIa5V8OfSFyE+25F5Ot+5x7Tkjp/ctONYvGTQXwPd6DrDpfM/oczwKJd63Fj917Fvik7bLyMmJgcspzTHv7A40Zt8LdXidJmLMTIu3+XyCCui5yYWS0G8tCFN151miM2KUMje1wXJ3STPe5gntZ9W+FNT15xs9e0kmeIBGtIDDVDlUFO9hiWdBn0NowPQSeQY+Wvgp+5pCq+ljM8eY5zU/V29cwDRdAdBbawi/zspIbjgpMYNM2Cc1FPPVLeKHld9dJw4Ro6+TqlRoKe7EtLwy7oaYLzA8CWUTLJXRKpl00iSo/Tu2mwahO2yfs/I6gLACpT8RsFWBRXM5RF+k+VGnNllchj6kmvWNiZcEjGg8tqLff2NoBcpvJKyh0kwZyNLDVM9hoKlMs+AChgyj2LwqycrThhXdJGUvFSYMo2DJ9wwbIY8gV8lDiTnnCjzNZ5Au9SdE37mbJDl3+Tj1XUFr0KLpokWkM01VyFgA1rnVAuxwJG2VnKduNnz4Xp3mkIkB3sSr3WiBv1j8u+DQy
 wKUDWutC
 YyejpGVvTVUtnT+JCasewakpJdi7IERApO5ZGcKvLcEurdqMUI+82qQQ1Q+Tsrhp1OEY2E0KAfzVz1euViUMJPdnrQ5cY3Jw3kXySfpB5b4H10yCghLKtnh7FAfjVs3K0m0lr2D4PFdZWgsbNRyqDs6BuamMmtu7DedJx2Lc62XP3RuWqxUSLhZ8KVvPvNtkSL35TjFhdPCUBsxwz97yhOvWhpi9i5EOT5XJStgcxyzHlrOwey8FKmg36TReCSd+dMIv+ynuXpw6HxFTvXOwsyPDTvj9zOS4ZQROozkKzNu/wBtext8XQMiTRscQfYzhmg2bOyDeZ13GdOrXskMPthadtWrOlsSEkON2Vy5leETy4Nv0/8jgxfPmDsCCVpiyWzyPdBIgsZgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert bfs i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/bfs/dir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index c375e22c4c0c15ba27307d266adfe3f093b90ab8..a70efe448ee82e9b1bd499abc968cd47271e33ba 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -35,7 +35,7 @@ static int bfs_readdir(struct file *f, struct dir_context *ctx)
 	int block;
 
 	if (ctx->pos & (BFS_DIRENT_SIZE - 1)) {
-		printf("Bad f_pos=%08lx for %s:%08lx\n",
+		printf("Bad f_pos=%08lx for %s:%08" PRIino "x\n",
 					(unsigned long)ctx->pos,
 					dir->i_sb->s_id, dir->i_ino);
 		return -EINVAL;
@@ -180,7 +180,7 @@ static int bfs_unlink(struct inode *dir, struct dentry *dentry)
 		goto out_brelse;
 
 	if (!inode->i_nlink) {
-		printf("unlinking non-existent file %s:%lu (nlink=%d)\n",
+		printf("unlinking non-existent file %s:%" PRIino "u (nlink=%d)\n",
 					inode->i_sb->s_id, inode->i_ino,
 					inode->i_nlink);
 		set_nlink(inode, 1);

-- 
2.53.0


