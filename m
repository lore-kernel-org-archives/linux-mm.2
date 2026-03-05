Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12947F33A70
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 14:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7969A6B0088; Thu,  5 Mar 2026 09:25:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 758146B0089; Thu,  5 Mar 2026 09:25:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DABE6B008C; Thu,  5 Mar 2026 09:25:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 443B26B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:25:48 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E46B8138F2D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:25:47 +0000 (UTC)
X-FDA: 84512233134.10.40D4BAD
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 52E9410001C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:25:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="N/OnFzWa";
	spf=none (imf05.hostedemail.com: domain of BATV+2e11e6930e970eb8572e+8229+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+2e11e6930e970eb8572e+8229+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772720746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=Vi/6Zkosv+62vJ+zf6UraQQ9J6Mf7JjF8ETVTRzdkgfOKAuy0V5gjngRwcTlKcfEv74WfA
	iPA6ifHthG2vo9dQ5QytK66IaxNIxNMsJLinvGqItoA5IIjW+7Ui6aYafEpI5dgtIwTVJx
	Bu6MntWc+8fSHp5ovvTD6N//ceqU/x0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="N/OnFzWa";
	spf=none (imf05.hostedemail.com: domain of BATV+2e11e6930e970eb8572e+8229+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+2e11e6930e970eb8572e+8229+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772720746; a=rsa-sha256;
	cv=none;
	b=WKyC21FRW2CPDP5KS3DVUFALXADRwL+rpTdV1paqcC3DnEJxMEj621e7rrNcEqgbegGJlI
	cr7iHHjHT7rVOt8yPpJDdfq2Ku1HyCQFIxBB6yG4cGkDze+M6BXD9Z+2NvEd2AKWomSDol
	Wq7HucjscrsVuseiIZb9vPjhr0DJ/+o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=N/OnFzWa9k33Gb8WoaORaZf8/1
	omQzMxzv7AKB0iGBOiFBTlfDd8cv/SFY2cN/xlhCF9LD4axDr458b3KkJDHIqY9jaYSeX0Iuke/ea
	ruLhr6C+ymLhOMKavxBklyL56gQe5kOFHaR9GqikFPQ4+YspElC14XRfWh6kM52omEOHgMpsSREro
	y5uto1k++Slfwuo7nq2YzlvQFOIu0vNsS5w8AUmDYAa3V8L257/vRobIemRsPwt43jEH4dMBKvjE9
	qvJU8j7WutreciL7iwRXCEmJf59WsaeHF8hGB2PcyqrdNOf6OBCyjpqgu7qzQ+34Omj2U+HU1z4kP
	lBT6VZKQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vy9dP-00000001z65-3qix;
	Thu, 05 Mar 2026 14:25:03 +0000
Date: Thu, 5 Mar 2026 06:25:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Steve French <sfrench@samba.org>,
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
	David Sterba <dsterba@suse.com>,
	Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
	Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Dave Kleikamp <shaggy@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>,
	Joerg Reuter <jreuter@yaina.de>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	David Ahern <dsahern@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Remi Denis-Courmont <courmisch@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
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
	linux-hams@vger.kernel.org, linux-x25@vger.kernel.org,
	audit@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-can@vger.kernel.org, linux-sctp@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH v3 12/12] treewide: change inode->i_ino from unsigned
 long to u64
Message-ID: <aamSP0KKicK3dvIf@infradead.org>
References: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
 <20260304-iino-u64-v3-12-2257ad83d372@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304-iino-u64-v3-12-2257ad83d372@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 52E9410001C
X-Rspamd-Server: rspam07
X-Stat-Signature: 39gfccnqfzwdgrcghfne5x3zquxh3wj1
X-Rspam-User: 
X-HE-Tag: 1772720746-654466
X-HE-Meta: U2FsdGVkX1+OfV4x7dJGrd5p5TH+1HOUHNZ7EgBPaKNVICEFT/D7ZUZ5kIPiJCxuL2ZIc9cAryMw4Ze9JS2lLYMUGL4lgff604wh2sxmUK4xnXZjwIuX3f0IkcnVDgAi2KJSgFS3lj4qxWeoMkawvSnehaiF8rj/DojckScSRnyOlVqRTrTU65rRNGGQ44gW3TRdZpWKjI9gnsdndr+EtSEECaJCLPE25L3NFECFRUzf+ZsfnEuYKM7Qqe9cAbzA8qjaSPuYtKgqB6KfzvYOJVZvsTM9qp/FvwG7t9pEMtr9XEMTEWVi3Wk80mb+Qy5yfBT66uQT4xtUB8uUrEgoF1kmxgKVnjcmxF+23V7kgG51R+wnFKKmCDbGOIOCk3ifnFURSmCE+EhHpcENMo5lgM3qotWLncKfWJ4UD0rCxvsUqrvlvpcDkgKrF6tsQjpMKNYnIx5Kx2faIy61n4HzgfjoWOz5ngza1bqK9bg8A9nj1T5B/ZP4rhWKW9ZlzOSSeXtE27LWPIlqhgfTfb04Wr2Ykhnpx8gb0C5qfuYQrRAX+ErxVl5ODTTHFW/9gWj48YH8sfvIirNa5EmKeXnJJuWSIvT/zqqvE51q5GMQcRKdi6jJ6SNhsZbzxugh9zml4DjHSCH7HnC+ykWNWsX0LX7z7h7qtTj5EOnDPeHYrfWKdAP72EcsmsCsv/bWHVXO/BtEG5RYOsjhLT7MV1Rfg/cIDzoWV/BqaUjPD1STlTwsYqTh9Y+dwn8GCg53S5Rjm+E5SWVN97FFh64haXcDFLP5ImdTxLBwhHp7Ba7Mzr9o/mmTCj+ij5N07nemk6n2IUJtJn+cp6YEiQPvETFYfUBvG5m5GERXLlmr5iIINTPWy161Y5jVd1g3/CjR+8h+ZRZsFBcPoqkwYNme6kKA/BXj6RyPY09SzxqVfhgnB0FhkTvlFZeLsGYwkbsDt5lsuYFMx4062tTkFO7K5Gu
 cHVYavrZ
 mlt9xvQF8MfgVsaOmCp1HFXSVHfz9rCP9+wWp4jnSna7kaW0D0Da26h2FxHh/VZQELgLxVvXR5swYKjEQ+x78pBlStpjbZqIbkZPMi4/zu7OTFpiPRFPfhZ/YbEOaznUz6JKpctjBd/CBLO4Z57w+LVyGUfJb4lZVbgTLwb366R2hl0BTO1Pqoz4lmnWk6mtPQmsMgCEHztOyDUkm7iLE1bJeUStQOHmTBqrKPS7RSusatHzi6jzASBbTJb/58afZ5MZPGFavE+ueFtpJ1vJD8lplrkkItU2vSbHAdHnfytuAjEntchiYphfdAKKQck7CqFy6Pbm9fQxlp5abF/SwUbNmS5CJ9YfauHjG/84fXcJZe7p7bTeLpyKlXSc0mM8Ch1mW1Szfta7XdN4D17Gpf2TZbz5K02Qa18+DRxGohBVYxvOexoVAWPVS73OA4/+G+V0sKT2BFAp7kLqH9FL/l1vmqQaFGrqpvEkGdKBFs+Nbw9FUcNSkoVp3jou65wpXAscZhb/igyvHhk7ZkIw30Au6xKfKRVQc4urJqWldoLIR5r5rOwaH141fdfzPCckiLuBEIz/aMzgFl8CKa3C3qkw7UANzwFfc9cbQfb554C9j+U3UG+t/xsm92B+xiCe5jpQ95oFJ/qSqMIB/HCbB6nbvce6swcyovOjWN5qojnl33nDpm6b/4teN+Uo1WfApx0RYDn4hPWjeo9tn4WkxYHa0GyHstQ6/dbFAOGUsq5fFn+2zMl/i9Rd6LC74/nQ/37JJ6IEJbxpx6860UX3bl79q1nb0dL0KavcPtU/wcSqtUcsW2FdNl6rU9nFX9TKoRv1S1dRtPR0yvTg0t+0S4UVMQdVATNr040a3pbwxmpF0XD4TpsXhdSS4+CjtJ+tQ6+kvIUY8ZnbjDB5+PkW5Uf5BDNh7Kw5eHFLvWeB5Io/AfYbitJKoOfuFHVvhv8zexagcxHE4mp1d/8kOIJNbtUkBFnlw
 1o5hxqAg
 xIVJwNznJD18uABh3M+dR3CQ2HgZHI5bhpXYRhRk9mXiIFFCWCkauVcXspG7SmDzMIgIoCP1KxKgVkb2/Bw5vHomuoVV1wABxQsIICcSZ1o1/JHbK8PwPTmKkJzkmWSlBEnyuGhBJUhq1wQ8RYCfIDaSEGv8IPgjnbN4hO9WtfbeZHKmx/n8k5LwkDJPT8X1C8QHO8GvIh5hWQY1Yf5LPQucCeOvURQWJpCBHbaNRPCjk9AWnODJ+WJ0af0LMtfcnrLFV4kn5z2L0ZT0Tgzpmen45d0w5pzMts5vtk7Vs3Z7YLVCtgPqYQD7X3h/CldEDQHHFaGiwu0jRXQuCWJTCAcDGTG8h+Wj7R39EDp3GlG3qTZQI0BhhmRVyCMLRl3llnYMEFrVDCsKbi7nBTd3Bfw/2weKK4gZ4n1ZkD8I0JOi0JaAW8Ur3LOqm8lQN8BBNeJ6GeojocFlWnwFPp/wPfxqIcI4JBbA4gMY3vCDNTi6uVM4kSLxZ0AByN97XJdr8Uzxf/mW9Z/iNvtOe6+Ijt9lAd5nCfMwo4CHpxtfnJjU/9eAu5Nv58hxvcuzega7qn9xTPTp8vrhtrzvVfJxnB4EI78LRSGBOwl+kOMAP+Jb9y8SHnzzwaM3ccTlHhVu4HhkdN4wWTJJe9xpYXlOiyGgVEqcYXy2aYpHu39VsV6IP8XITI776HFvM9hIQtTkEbbzx0RDk2BB26K1rxmOQfALjqD70BrRS53aYmX4mNCqw6dmJf8JC6bxxGMbd+7Hrqd2P8CePUpqpk78iHhU43L2gr7HQdxVzADAocBA+k6opeLWNA4v3KLwRxTEb+B4aaqdoi+5X/XyFflp4RproUWfDj2Xp9+5Kb/kOc9gKXqIavwwyoTvSAFdun7WySqs0nnYnDaffOwagvl0XIDpXgemSETZy2VARrA1bXJBnMZiJJSHLsEXZVzUhl30EWi23SrD0JZ0l1+ogxPbGH/I33fIPj26q
 IdTMfNT6
 VC6xpGvTlA/DjTp1mOrhSXSIdQ89uxysi+MBUc66AbC1wUsoO85FsVSMPF8QO30n9/+3xYZJXDZk3dnZb3kngPI8Jgikm71OpEeHJVE4uz10ht9XyWDCg6wYZOGUaAD3gPlNFXekdn4gUe7Gei76Pxu4j+hbwfG4jAAyTSL3qB7UZLPukv5V2FQOeKaLkCb0qKiBlUmWpDQw7sv6a7d02m3Q+BUVV1vrxKyNYVTx0bPrFkJzyTNOL8tANgnvgIGNGD62XJPvzYnOrBERnY0c7iTMjsak347m7JgpBQL+7LF17lw50FON63kj0GokMi0ztA6EbJgO2xf9Tiy+1U5simMFLylTmm0JPUZ/1gcJqBMcm6Exl1598elDs8CdTuzHRGuvN7ADS89jRG52YKZrMj5GDUvZwvK1VOiUnCfPJCMU9Re41zDNCAZ3qLFCrTjQ8OISvAPfDIJiNs6dRQYHmgblpOcxSUxKejR6qE0qDlFtewRyq1Yg3CxqtvXyuc0jSRBth64hWzGlfw54ZuF7CGXyGWF30EWQRT0VuNXaK+Ij7qZOj92WXO4Nk3MrPBnRvK/90+yxNbzI3Ei+0pBjf4U0FHMGQAT+rbYRBFY1bVReZhWZimNU3RqRO/tmKGMw0XTrF+C3GjcrTiYbq7lMzC9BcgkRlEOf2rX5CejaQDMj2IN8eqO/7WEgdr62jXNS/ZjuOZ1E+uHJjQMqPxoRUsXMAUZ4ys644Yk0f6LuETVUcJg0yBeCCTrLjZzdlschmcYIw/YGlFdWs7M/g90ndMXOnuLm8W3oJBNEsIqLaun5MQdPWwpXgnCiVd6NuN/+Oeps5c6nTdBwCEY1ZHuirT5L2Je6HdQZD+0Y343gzCWjLH3zsSZSFHDoL//AXgdF8iyzRcSSRRkqbT7C1Ni0ZYSxwYvSE4otWezm9fxwFGyxHanadilblRPlu5FrWnLvvJlZD+Wbrx72RKK+37JnVrb9jJANH
 Euzinwa1
 14VvXrNddb/Fx2x3aX8TTdB6sYEpQLEjlWp/CqfUF2ejrE4Nx+A5p8kBiGUHps4TjxW5CL2awSpD0tkrrM1FQ/p09k7EAgYTdbt/lr3R6b/RlmrsSMRJTOKmqVDjwnbzH60bPoEUQFKUxRBwWNhsX0rvi4G9OJTs6TBUVDzy0+XAMvKBn9IWRzAPdfS8TaOOxy7VbILY8ltV33nsl5L7AGjtMrl9NJCPx2ofLd6d4dDo1ZFaYaFbSnDTSxiJl2LmO++cgZRQ9N04Q4w6PiQr7zzkpQKIJ0E7RfOSE4j4PCzmOUdO5lNEwGlL/BFrBYNOGupUJXgKyvttbjTYoUpccL9jPkhl/ukEBj8IxZYheobW5+gOGDgPO6Es44d8+YIdpptEOEWf/m5E7nnBbaqmZGzhPugkvZXz0T8O34tj4LbtsOb8lupk/GGEmLZWAUCMTye1jqtGnolxIj7mhMlk8y+hfH6IgODR2cKdVulmyVzPL2+NU7OOzAYfgeY3l/wrutmhsvRb9OvzwSOThYmRbbhw4kqrduSOxzOQUzVTGgFWefGdY1mwi2JVEjrxsDMcHO/LeH8gNBQcYWpAt227rgm3RoHDC+CtZUL1uUkI0Q84yTUrAGxqZ0yzRAeaUcOmxNG5akk+aWEw5ieDOaXYV/qZo+4A0FZiy/c/MP5IMCi0jkJcxkPttzmH5Sb2YN6yekg0Bx3dLFtZFQEmbYsLvNhGZcDeNAm9sYLgVG5zUjTVWvxP1tR70C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


