Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6700EFCE4B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 21:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 129626B0088; Wed,  4 Mar 2026 16:42:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FA706B0089; Wed,  4 Mar 2026 16:42:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF7A76B008C; Wed,  4 Mar 2026 16:42:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF84A6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:42:16 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 821A6C2646
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 21:42:16 +0000 (UTC)
X-FDA: 84509704272.17.2B7D4E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 946CB120003
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 21:42:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MTiNOmzu;
	spf=pass (imf29.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772660534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TWMxDkBFlm3DbrXTIPwCf3ralkmwZ1WN6EDnLJ/iSzA=;
	b=euCgSJI5YnsBgCNBedvNRPnvGMk4ipVt6Ub5GPaaorc4N7r7wRANZ0FyIhVludQpcHHXst
	C/pid2Fmfbs6GbFZe48498mxsAH2fGebigF99FKs92vzmjPNrByAC2R1otK43ANXgpVP1d
	b5la1j0YL6lzZgemdFI1iZyt76jF2B0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MTiNOmzu;
	spf=pass (imf29.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772660534; a=rsa-sha256;
	cv=none;
	b=fTpdgSv323RpBn1458FKUYumkZLaVP1FtgX+jpUUpVzwt7lVJK7pL3KGOmCmKxUrsNxCHJ
	JBNPP2Khqd/UfrJ5Ki64iMPx6MDRUCwdZsWQfKOQI8Axp3yRfpNrVejuIEl/Xm+kY+wk9o
	UX/aYFUVivOo2RBOfYfPBPxVzyY7Wd0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A3CB743232;
	Wed,  4 Mar 2026 21:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07326C2BCB4;
	Wed,  4 Mar 2026 21:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772660533;
	bh=xiOhB9YembJ+CStGf833o6vXChZ9R9iPIsGRMRIY668=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MTiNOmzumY+Ccr9Y25oeq5uYZKghdKy9YuMJBVJenlXMeDIlM5fFuFFctJXPSrlj1
	 KOikET8YCvcGy9yWYQw1bgH6uo7qLLK1Yimq397PsLMKP+QRrCFPLt2x5Iauoplbvb
	 eVdpKah8RLNh0zfOSHOOrQ3xqtsNbQi1nkFz6EB4vJXFLpSPJMg52b3nqo2mplKkNj
	 xJmYwih0yzyZ+saefyHXLopmh2Uw8y8KnyiNiI3ZzGwKqQQ7Bt9hEM//Ab6R2kTuX0
	 dvCJZkANj5UO/wUvSeTKYiDWcUSEi2O8IiF1HH0MkcYb0vMhcqKbNtD1e26QLX94o6
	 x5Esh08bkPubQ==
Message-ID: <000dfca2-3101-45dd-8fdd-987ca885124a@kernel.org>
Date: Thu, 5 Mar 2026 06:41:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/12] zonefs: widen trace event i_ino fields to u64
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Dan Williams <dan.j.williams@intel.com>, Eric Biggers <ebiggers@kernel.org>,
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
 Xin Long <lucien.xin@gmail.com>, Magnus Karlsson
 <magnus.karlsson@intel.com>,
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
 linux-sctp@vger.kernel.org, bpf@vger.kernel.org
References: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
 <20260304-iino-u64-v3-8-2257ad83d372@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260304-iino-u64-v3-8-2257ad83d372@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8eskijsjcy3mx4iiyu8ukdamhsz3uhar
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 946CB120003
X-HE-Tag: 1772660534-410868
X-HE-Meta: U2FsdGVkX1/oMwMBRtURCTmTnQ45A8dCikhXSk7puzlnY8Qio19tFVGT7kkxUSbFumv2398TumZ6ot0hE000YCg6TJp9V/wW6mhROPS4++K0PinZerg9uKcucK213C41aJI+wpUmXI0tVx8P0u//rZb4e6R1PnQzr1Zf49zyoeKzJWn0pbqyxlY4kAzAxORmR/XwTcqNpVNdKE3z7eB5S1zwBAWpOtBOO+r10lhVyDhOHCuWvW6yGZdvBtD+Pd/wuUgyokyN249cCvm+KGclKXL0+pve8ovgk8e6njysphTCzJqpVWjP0kcliyyynowfSvrvpbenYR/RsdZTf+gE2yTzb6wycTsxwkuhiv2gML+1yXVVEGaMh2Eqsa+CDoIRn27ccnlygRvOg0lLapa201nlwd8Z0aJyWTkm04FB4ieA13UzevAlzCvCXPDHJwWTOWzRSyG5s1DhkldzcU8UfsaUEl7fr3NXeAJzlGhXl5c+AF2RjIjLcTa7rJPliIl5IB89Yd6iWXAVcMq6YN2MQUTPqP/r/f4zVsif+VG6h2yC0kkgz2NXUVfRWp2hMkVPnSwg3wAKKgyZ399gtYWqqh9aUYPCrTAi0WLJzkArGLvwq5NwtymekgxwGbqaJXfyalYBf6WlVjEoVBL+XveQFUp5vu0qVm+2LfpUFahlxQK/VVJkr2Eo8pS10SSIJ4MnOrSv2okpjhfM7pwAMQf0OiNjJcAyQf41CUnbWEGL7i0IeDhDgWOPDfHonT5YkQOuo/yOURtI1xPAieBj8+uqCGhJ/a8el6QRcRyYSn/Kn4jRk2W4JksUVznjYsbGktWluYqVSzrjor7LBQ26bmRerkPYPyg2abBU44/riVR0Lh+Gvm9rEbarg2ryiWDRj2PBWcVuv7EdUgu51wS9fatNkavn/XJ8dQRfdVNk3LRZsH6HEIUaeq6yB7EYxuikitckq2hw9tAqYOs9i/vUAOm
 w2b7t8mO
 uGrZMMYN/Kr8RgmK77lJjUCtlH32qgazRV+5nLT1MA54qfXaDVR6MywW82EAXqGgE0JC6Qv6lq+zRIALeoJWN8DcNTlBC9SAXbU0kVXn0Xiuy4mCp1zKKpZVV438f8gXUEDQuRZ8dD4dXXpul4c7JirktyxGmW1aOEOlkiAsE/Fk9BNDy9CGzxkIhGyAyPRNnKa2qisDZLaDQ6IkBJW4zBvyxNUukMImo6MVAuSsRIuZ92JgwiXKSeZcP3Y8FWSTT1c4MpAsa7Ky79b8DGBxf+y5UWw62+KcTbCZ9KN3wB4k/8J5vjlLo0SbF1G0idWDHMPl8GM/NoQdrhM0JGS7jJo5zzlmxamrDXXgc+cUu5hvG6KrADwIxWzMn2iuhFNLOryB2pRpek04fLKPIbccERX7HtO6XrpndrhZIz/n5C7FBa3m5VIiY7QgeLNw6mBfL4hsUGWfLtgp+K7O1SJBytxRUTxWSGXBJ9LkpqfyTOLB5Mwdm5NX5qHyKh7Ye+7rSufHHLqrFNtbao3v71wGM9bl/sTVXVE98cgqAQvmIlwbGbe27dNkIowif/fznpkWCQOLJ6wJSR27ScBWCYnTeEKNl2Z2RuWX13tbxv3vOMw2xYBJc4D5JTAe9ccZgGdlgkxG2GkUgS8nKWkwkR33Xk8X/zeuTe4V37MKjOAjnLaa6Vt6cGVmwGd+Mh6J7zT4AeoUOTtk22xDWd/Yr9R8HvAo8MCSGxnl5m3BPE/05OnLOwmI2rET4ZGaJwywByFmE8PCBjq+NXDxDSFHp+6UUe8hO08d40ZSpQekGSPqL3t+kMx++uOsiUP0k/Wlg4fKKU6lDL034JtUzyh/UZ1UvNasS5L5M7xYQK0RsbtwY03essNAxOR50yZrHmP8DbjphmP4DwtbQC+wrdx0FDLXrY2kJSxABVCcafQpwASIooBpFGzvsol7NLrbclIANHr0+3XW9ZVQv/zYstmLyobluCZRc9sPn
 VL1PjqNw
 LRB17tkhKVpCwKxk/jVXxP+fuN3M3O+uZNd6zXWejBp54dk+1+t9iODxv0Ww6oF9XazTRaC0eDJvot/pf3TP8gLUamVa5rrdhSUSuWTB/2NLFo2EsguxeRvq+i8QI4BWS6yWs/QBzV79w6iYJfqlun+VnsOHHOijOHuPdH1s3r0c8ifqdtHlLuIRqQwW52briVgEf8yHDorCeP8x38xCXr2clQoRJ/+Yx87k92lb54Ar+bnh3z825Cr2zRMSckjJ7uxo77UV8sKyEy2TnVnslTCmS1OpScSkXn2/b3lkdbfTAjY5ntCojVx4hgwzKBpivDTIpGPcxgh/EpHH3kfnRbtBfZjp39XXXwfgv5W8wreMNSnYoU4F9RXr4VHheB56padqwIf7281e4vQAeR14i7tUwgFGja2j+7+RNH23M391uItMVGvmGYjadLrripwRerLByinZLC3ZihnpK9xFz+ELOZmeGa7XTk6qwdZFN7hw6agFZCEh/n45FxMUhCfmpoxbhFryZTQyW74IZbRdw2YiBzOfSZccHGhZbNsHvysf5Hor4y5GZG1zGsf786Vw7yWCIGDvA4dQzvkITIcbOlGvJYwZosoY8VPnsbS36+J52N4mwoqaT4pqsLhmDP8r0dqcSvrYNHJmn2q1BNPWnqgVd3BbXGlWORvQTnXYWfSPOLi25up1JEYICtVU+qWVn0LHHL3bK4qoZaoGw8to5wPr6x+GGH1Ouy64YvyNvEfbYh0EkUzt+sN21OD0EHymYw3BpNmzAAdpwR9SS69Stuescht4ULjTFi5flp3A2fVgFqnl8T2jN1OK+vBZSfHHTGyh9D4v6hb6g7TZBQVxxHiqQAwUczRLNekyPqRjnh/KVTdTg5xv5sG/ir19wHIdyHqVuaJ1K0rDgMASVCHtb3I54jfb0gJgQwsEdpGKHtk2WS01a2am5ipB8OS3MYgUWttBStAjtY8efNbmOlkzn5FAeZ0So
 e3B5gCv/
 7KQK/feUlnxOnxvELruTdB4J9GftEwcn290qgaS93Q5C5yvi2hI4QpVoS1e38TIVXMiywObMgTyj71G+L214ctd/C8u1RZdpv8XxsV6v5a/W7ESldROQ6C3RCEi1Zrsvi55qCPeFSvp8gXK8hgoXpzgObxjmmqyRwd6BhqdJ2WunbV/4jazsn2SKoDQW10pFTXxsSr5FZLpa19Qb1s7zTJ78lghqd689Cf1ZVayjNKaFYEU3PyR1UJeZGdNsNKogaIe9po0Gy8G9E9Meo6C0rnb2rhHA9wSkhMyssDXLkiQLTAdhOCJZg8kUclyWOpfvGj5OsGPd6eEQQx8yxQVYnNnYWUNl2Q5qzgd2ojY+nUG6rTXTCfxAyMmS6MgI/5qp6SMaLCIhQ9aGbcEWrTDBqI3zegE/tp4rZgy+xEhGxQ0IuY/NgnbKtltfTmzTYjJca9WCGYNvyeeDPN3Y3tAd0FgxMlWa64c0XX1jcCDZL0PKgi46nczphiEmG4B2me4Whg+OXeofVFOuS9vvucV+ezCshWSkUlLd5mlQMexf3XKzacvAYw4NZoNzo9AG8c4ARhEGOOuS04G0KKMaBGiyIwPRrPhK42xQPquvD5OV0zu623dcl/YNxXBAfyDVa+Ov8JckKW/LDdx1yfl05p07+XZ1KWlSJMtn5xk9RYGUfWkwtGzzhRE6kLUSJxgwIBUF+Fh4rkh+eDZiggZ2xCxnukxTgKG38530V8hLtuQ6qGM1mWH1zicZjWCVcVoqwJP+DrYvJYgrqa5nKqdDeOIhhgA5+4qTh4+2qinSJU92a3/72CsyU0FSsiyRJm1lbaEWX6gJCELxUAqVMdJqXYGxGTuj2ikcvU0zm4jKanxBecoAMmCwh7pVnFVFf6JpQjslK5KnYXieoYxwCYw74hjrnCip1oL2Lr9eFLLAwxaI7VuheZRch5OOwm0BY9Do4D2I179bH76P4cXQE2qpHckZFyr3oY07Z
 zX/VA/z4
 kPxOChcCSbpt/+w7EgZs6kLy2UiGp7MNs36c+yQB99XFrGGJyzUmCGX7Cgl5QV7ABx1GQRuEKWmlzo1fyr9MbOBFn/23VRnl+ZcGtsxFHg4yD1NEukm/UVWZkCbaOEuMI+4LLt6Waf4nxTn5LyRjcSmEq8TLHCDYzARAkoyUyWOkwzASZbrjG45cC+hy96DoORQZUjPlD7dAXHm7TTSZhVsvaO/oKquUX/yNxD+v25UoI3sQ3Eg5fzd6cvfTJPvNXM+vRAjvrVyX9M/Vs6UeEka+EW3xR2nRTK7LFLU+Xc8C/JtsGGg+uWcZFi83V80K5TwXegbrpptpgP/gmlOfzXUD+xQpqk2Ziank0AmLJ5YJVMgsMaTi6ndPzPqYMlJ7XLuvWIKYM6HvQiHBR80MZNwFIuIGepaovKdDjMa4B01pdt8Gb06oE8oVN7PRKkCr7VCha0Gy7IY5e8HEnk4RvQXUToK0J/ztU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 00:32, Jeff Layton wrote:
> Update zonefs trace event definitions to use u64 instead of
> ino_t/unsigned long for inode number fields.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Acked-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

