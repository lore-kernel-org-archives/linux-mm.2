Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37E2FEB363C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 22:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3290B6B0121; Mon,  2 Mar 2026 17:58:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6756B0122; Mon,  2 Mar 2026 17:58:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 159406B0123; Mon,  2 Mar 2026 17:58:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0513E6B0121
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:58:24 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ABBFB1A033E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:58:23 +0000 (UTC)
X-FDA: 84502638486.04.D9612C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id AA312A000C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:58:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p0GsC9wo;
	spf=pass (imf15.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772492301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Q0HlBxe6sbxmPudQLnH1jovFF7d3bWebayXuRsBlR0=;
	b=T08UABX3md1mcFg+npzW3aZfAOCh4xxZDXzppnVAQR2sn1TT6tqujVEGWiMTwEdL4hGO2G
	Y4dT8gTF4OfCcY9oaKnODIPdNN1Wm52mMfqrDeXqhMKbcNrf2nI5z+STXlG5u9vhZ00oD/
	o9pBDNImp2wG58mFjMcMxwMhsIopQVw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772492301; a=rsa-sha256;
	cv=none;
	b=sAOOYc4oOnF1TrjMkYacB1b2sxpQ8liKAniy+OQtd1Ssmyq7EWiuqZqQiShVfHvZTSXSKh
	ikwFLp9hIGmVYsuSHBvlP4TIU+9ChaVFfokTLAsdVZK51XdHNXiQUzVBxnZZ9qSIPtLGH4
	j9VqNKSJ9q7OPNz3YSeXe6okMzX7bc8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p0GsC9wo;
	spf=pass (imf15.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4098643FCE;
	Mon,  2 Mar 2026 22:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65343C19423;
	Mon,  2 Mar 2026 22:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772492300;
	bh=dSvaafq7s+HEj/Y72jLuoeKNRy1B3Rikjpm6NcM7diE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p0GsC9woFCUKtxDwipZDfc1GU9rUyiVi0vJPYP2u+0lYlFaKaiE4wvtujTtUsUSSG
	 y9tJP1pMFCSZdbVlZJsp/30PmZ1S1faPO832d6Ub6IMUIFkIp8SCUMEnJc2IJ8q+Ka
	 ZpyDlt5SN2HnUNutEs6KYH5Vx0HXoq7KvmUrZbG2IxG5LEgsEnTMz87mdm/+x6Ju03
	 1GI4Matlc31LEhXo5LtVUEq5GJUiz63iWVRgT2s1o3D5+9nJtUMseF11lElVDkS1f/
	 DQZuLjZC0NNLwbtBL3D60LeHl8deT4SR0u9RtbK2+hz+nll+4jjYRTC9U8dXhLefK3
	 ACgo7vVXPcUag==
Message-ID: <8f2d476f-5c2a-48d5-8e20-998c06d7ea88@kernel.org>
Date: Tue, 3 Mar 2026 07:57:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 048/110] zonefs: use PRIino format for i_ino
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
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-48-e5388800dae0@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260302-iino-u64-v2-48-e5388800dae0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: kxrrpqokbj9pz9mn8yhy4qia69zkwj41
X-Rspamd-Queue-Id: AA312A000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1772492301-143925
X-HE-Meta: U2FsdGVkX1/F2tR1r/fKy4PWYlPOhjM0++1+uczKZmxZUmDXsjjYd0Ll+lUJMLHNeGZ1wtJeGZ8MBVfE7OuHLFMDUnMU3kLY4Jn6hB1D8a2yTsxLDSAh4nGMlUMP2c5NQzZj/wwiDUir/oBglJXmTAE9PDOw7Y54NykarpqnSyiLW7BBzLrl/zTITKBfCKIdN38oqx8AeGtymdYakO04BdPK1bM8EkpjduxFdbCSeiaJiE8R/woZNtyDFCW5VI3qBK1KHiztYEEn7iCuAfrD9ne8zITofvlVNGPI00yV+86MALZVUHOn5qnFbDc8/32xl0hvnY/++eO5+vx3rJxU/HyxGi1NYqh0MMQ3megDQstq/5wI2WolpImoi+abvNRY6zFWX7VvI+Ig2GXosVIrxKk1Flx6NJzUifaiqcq1EDXOYPR2qImGdMerzo39iK5XCS2esHLJxtonN1UY/9AbeKA9D8m328bc9iA0C2Jv81PYBbySvcd9p7tR8NBSNp0NWhfaooazKBtq8ml6V9rGjpWXpEA9XeS88DESChqegS2NfZUJgUm8PYJUUFV3LSZsW1vAjwobHGa/wZnKyi3gxUpgQL90dXTggwvoZw4BjNrW9KamQIZZg61BTwmdhwvlcPYHWxWhyMJtt34kdVFDsfFqZVjp+banB1awnzKMJnVfKJzDox0qkqZQM3bLMs0+FGMMrE1rZyJ8fpsJn49iTbDTSXiwOxQU+Bp/lAK24PFiNfoNtMMIXS+sQqoGjnoPq6r7GGtXGzJZxz5Le1l6BYqDOe/ioxjB6M+hKJJ9+HcA3I+811qPEOtKjdScCI6HAWgubiIBapec0ixWXtM05KFBKWe24vA2wQDnzUg33T7m1SJftvwcwcJYFnQ/fk3rY0iNWuweuf1/s2jtr8YSFUZCKKVHBlwAmAqtddxqCXkOlP517cwCgXZ7J98F7fj0JyEcS0kRdqn5r4huP/j
 3beiniLx
 r2wVOucsNec7O//HVT8KUm5SBAgXf/5W1YnabrjQ+joJJG7nWIH0p3IRZkLm8IQYhGHcbl3EB9A7j0xWwLNJqgeGjMOpgaq0+PwPTWc2PNdwnCNjcSyi/J0lBHPesJxAHiHwlqYKY4ZjG6b9UiSQR4vNey84gfS42GFKd3gi515OVTh8wbdokm/OZanBrcJtVIOPHSFPxpAp/ud3s44/cFNX/yehqIkdMA4JSZUaT+xIarDPiq0050gkHNHPNsuTeTp2245UFuUh4SoMo9GamN/9nRzC4gswbNb+pt1UDJlAJnGOkPDaAPga/wY2VR9EUB2Iyq/q1M5O9DOOeWzfegmnnscogfgDg6VUagzGaoCk0UCO3iO7icIvbulehVTAb5UzWSaQFG21/HLHbtpYyUw7npHjybNst18QapPi8QG+H9sr9RSJI6rUaD15ZTEZTxInxnxmdo/DER8xjFmlMSqfYCwAPbbDiLGouTE9x3gfnc6RWlqlU0V1zf7K+FdK2lhSevO+ubrn5kj6YCAsuBua4V3lShrVYUq3zqsoL3jPLsEr3k14+XcPdZy8hHn1oekS+cBeYsId1tpl9D50yWSzD88Mp1U//W+x98Xeja1a1iKZlJuIMJWxc3Nx4QHw8AcOvTQVr9pP96P+tWdoKcdS37swMOylcBdeXgl1smWtrPqkt6UXLMKbcDAaRTfdafo2cw5lZEnZx0tgDObSDqeVYpYg4r0TUV4VSI4Z3ePPz8uOzCHtQ488Wa/z0/NYFQYH14eJ/FAk2ZQYkQAZ4ZK+uO7eRuy5HwQDE0V4NwMnI0E/aoNHsteflCIFxWxtZH13EmjHk3QDWRxkMGqP50A4DksgVFj+PSD6OC6d0KnwexMJUx0Pc7b60UQi9Qrdoko1rpErdOA32ygjkFd/G9G0xBbUscYr6Cr4MNDVS9Vy9xcCKH+sbruoOPgOtsgMtro/mbiXNi5diIJoPYqkdzyC5Bad7
 P0eq6pAZ
 TXv9Ty2N3RYupl/Sq/xOgGM4XCUDXhtXEyT6GOJF8f4ELHswNGZbn4D9CHk0r6KT7McfGDsC31I0+WI1sAgYosiq6fUdWilHHg9z74SJ6syb4geN9B5+t10VH99XcMRO0bPWn7cglgWN9jeuq/np9Sl7nnwvbiZaJgOUKuMDFm/1Yd9BhGj/46jdPcwAMRoySxypzltaT5T4Fw1ud5crIsIvEC2suPCh8bVGak3DT6ijj1zu5wzfuNhI8LFqWTCCXqwZL7UBg1IaS0umBRVjYNUlTmoDeWsqym1mHaJLtdVQtSzAdID26mdmCi5wfVIcwBNgciMlCHm95esS/W6taZ7D0YuW3QfhXytZZc3qkhoyRaNrbnw8oCx+EeKHRld7Vy+5iRHp9/DUl0PGPWJJ0Y9PtBrbaWli5JZfml0DRXxLwBwXjO8vpCegBf1DVnJXAu8GNrqKT4Y7jpp/BG+2g8o4O4hphoP5R8mRiODMxUqwJjtO3fxhjIEJ1d8UyqROT7/RS0qEK7g6jdp87ghYcacJRnAKQlZ1JmfBST9TiiaiR+dp6cCrV6kmLilTwgLo9wLjrwFvtiDz6pzqlBGNzmRuo+z5pA2VxOHu/MPXb7xDOvrjKu+dci5/mfqnCbZtw6bJ7F65EgCSmtOV06iVLK/PkTyuB+/iM41Jt/eoNmetm5oz1Q+wJiIhO+1MpzuaSn4ifO56whdhF1hVTAnlShN7uXrodRsuLIebs+HV655InjIiaICM3zZBgDTtv6PAZKA0yoWqC+rjawOGIp6ecLkfsncnQu1OYgPXsNYkAyW9oDaA3XcbXNpWrmtb7xLxtTI5iAkrFfV29fF1kI7i6aLPLbTpkETGkZs500hvHVu47ZHCpMO4XY9GOQuiHZ1mKmZUwy1eugY0JNGrRerF3oh8MDFyeWU4q5iBCo4IjuyUQ3VOiReGG/cWxuWgQN57I0UyvET/IWwMR1QGDZ4iUttkHFSrG
 6SAjs7gx
 Lwu9RNYdWae+faTiOizDxpSS1d8zqn+eNBzHHQ4A+6qWokuxxpzcEHMD4XnntxJSjKHL70SWdmgdly26dccK76D6+Fj8kkQ86xP+8BQMtArzGrqD3SMcpLdYPjA6YbVJJS9SAglfWwK5dF5E8FvhzojrlTmqz0ACfBDw1SC72eSUWokAeDS+52KFVk+SwuPXWVTlibK/3rbR/+npPxhQNLwiAeoZrUyYbF0cGDrYIOGkvLRD2uTF0eoN/EGerfn4Lw348cX0Bhf8uWD4CYncRt2hhPnouPTbYLi1AsGXkBSFYeIsHUcsvQyQzDB/hcm0yBhgtz2OMrmG9C9jVbClnq7RQ/0Imxb/+CO7ZdGMxea5tPJNmyAx25XECN0qkGvrzF8y2Aw8L9Nk5QK2OddEeOHfQJfDc2M0pUHBUFqTPynrRylEMLUWM/KNq6XfI5oqJ83dcL69ONlfmgBCGtiwsRT11zjQo2v/30uJx5xW43sDN0DZ7dLNvk3FkSnjHIN9nRaGpPtRptu0lEan+FceJ3tviKi1ydlSEC6DK0DKnSds6baY4ipaHYAoQoqkUWyecYzV1sHRDAKT4XdFYhQRsfJjqfj/r7fMSBrPR0Q7Jra7wAQt+uQ7TRwZLLKQmNH4ZcaUZEHZsAJ7RznxtQXiWpJ3yQmQwRUOOACTvwuGCyB7hKBdZ1/CHgVyytLF5l59bWtBIiXcqtKW9wCM1i0+Kyubui3mH+CK8r5dK+QAdkz+kdTCudbOLZLPay4VvQTZES5+k578a5TUpjUH0d9xMGMG1pcTo4Mx3r+TaK1DET5Zwo3VFfYFYj8vtHMfEAQ76E9MY0bUKugFz70fg4NMX78WQ8/OjgK6LZw8epcAHea+Oz0NiFoAPxgJrbdGp5IuIapQBSBD5zLNf7A1u5ShExb5dcojA44MD84BTXLm1/FawvyfKDU6Dmlmc18cJ1Ho9wSvSDp/SPIifReJJGNadLls9fjIM
 YDg7FFUz
 JXPAynnMO8abCqvnWWPsPnhxhrJgs2LhiKJkMOUpH/4IPMtMrkfDM/oRn4Tdq10mxQjodMfjm/BqLQ1Cs4J0911Q99P1xCJ/FVeF5429Umt7XH+suWWb8ucgfKvh7LI2GHfkib3ppys1EvMaFT1r+RIEBZ2MpHkqmbUGp0Q8ATUKwpCcm/e7xCPALUSF7HTkKp/7UlBYrt86jR6iG1MQyEfJYbPDSzLD7xCF42SwHsPIUieCSPFrPchJe12cWmYkZR9CfEPyoLBOJmjj6ErLDMOIz9szAxxb9Biqq+upiDuh7hnXb0IxpigO00A7Roi4R9IFEXwr99A41UFqJwajXGeHcoPYQDkRP9S26Lh+sk05MbUAsG/0QXhlVanBpR2u/DfHNSa/IDqQsOUkI4ovr6xuMYja5rXcwDqCa2eN5/tAoV4ULPpU/MzLOW2T0n//8PPpqZDLpk0TXF+AKvB+SdtMZbbz1G87ZR3k0qgvl9euOj8KM/rE4R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 05:24, Jeff Layton wrote:
> Convert zonefs i_ino format strings to use the PRIino format
> macro in preparation for the widening of i_ino via kino_t.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Acked-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research

