Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00EB9FD530D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 08:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F62F6B0005; Fri, 27 Feb 2026 03:16:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A39D6B0088; Fri, 27 Feb 2026 03:16:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 377B26B0089; Fri, 27 Feb 2026 03:16:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 188656B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:16:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C46D2B9E64
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:16:42 +0000 (UTC)
X-FDA: 84489530244.30.CEA047F
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf18.hostedemail.com (Postfix) with ESMTP id C72171C0002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:16:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FexkOtUa;
	spf=pass (imf18.hostedemail.com: domain of chengzhihao1@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=chengzhihao1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772180200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wmv8uJ7HJDbZV50M+x838HOhuGm9CcXmr7O5DxYmnaA=;
	b=EZpyAPwAB1bIqRROJlXb3NLrvVKHJsfbIQZwDb5/n8gHMOgvWT67lFoN8b40Y8vtUZcSUb
	yckh41xIPxfg92CMZ8JxAYIAa0THYUqiLV2Co7dekaR4+5ywtIbOfsBnlURuKjJAgGhUy+
	AR8g1ihIpgcxJ+aVeRVAsJLDBfYwkBw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772180200; a=rsa-sha256;
	cv=none;
	b=xhxVI74Qz6xp/MJEVdxGTMrNq/2wCDYwqS6nrM2xJAJQRlyqevsfvk+rISsoxqPmttTv31
	c2pbsA1Ay+XUrkMKzRv1zSzmr0wWJbSpHovPdc3VIMtzfgmaVTl9FdKcJmp+1PlR8Kgch6
	jRueZL4BaXgKKD+jeJY0vbIz6NhLhFs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FexkOtUa;
	spf=pass (imf18.hostedemail.com: domain of chengzhihao1@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=chengzhihao1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Wmv8uJ7HJDbZV50M+x838HOhuGm9CcXmr7O5DxYmnaA=;
	b=FexkOtUagAcXDFcLvanuYXCxG6VsB4YyIX20qg20gGlU56RQBvPIdX5JmmfvAen1kl9Xcad9P
	BxTzvSbaMCfK6x/I533upYv8dB5mDxS3zN0xsMCDpaP2BLxgIVtISPyXXJDdxnYqn2e9mf1ZnD9
	Jm8up2Sq/fbakpqcesMqrt8=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4fMgyt43fFz12LDP;
	Fri, 27 Feb 2026 16:11:50 +0800 (CST)
Received: from kwepemk500005.china.huawei.com (unknown [7.202.194.90])
	by mail.maildlp.com (Postfix) with ESMTPS id DB9DD40363;
	Fri, 27 Feb 2026 16:16:29 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 kwepemk500005.china.huawei.com (7.202.194.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 27 Feb 2026 16:16:23 +0800
Subject: Re: [PATCH 47/61] ubifs: update format strings for u64 i_ino
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
	<jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
	<willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o"
	<tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
	<osalvador@suse.de>, David Hildenbrand <david@kernel.org>, David Howells
	<dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, Andreas Dilger
	<adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Jaegeuk Kim
	<jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Trond Myklebust
	<trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever
	<chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, Olga Kornievskaia
	<okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey
	<tom@talpey.com>, Steve French <sfrench@samba.org>, Ronnie Sahlberg
	<ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Bharath
 SM <bharathsm@microsoft.com>, Alexander Aring <alex.aring@gmail.com>, Ryusuke
 Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>,
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck
	<linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>, Marc Dionne
	<marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, Luis de Bethencourt
	<luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, "Tigran A.
 Aivazian" <aivazian.tigran@gmail.com>, Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>, Jan Harkes <jaharkes@cs.cmu.edu>,
	<coda@cs.cmu.edu>, Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks
	<code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig
	<hch@infradead.org>, John Paul Adrian Glaubitz
	<glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, Mikulas
 Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse
	<dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Dave Kleikamp
	<shaggy@kernel.org>, Konstantin Komarov
	<almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg
	<martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen
	<al@alarsen.net>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
	<naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, John Johansen
	<john.johansen@canonical.com>, Paul Moore <paul@paul-moore.com>, James Morris
	<jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar
	<zohar@linux.ibm.com>, Roberto Sassu <roberto.sassu@huawei.com>, Dmitry
 Kasatkin <dmitry.kasatkin@gmail.com>, Eric Snowberg
	<eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, Stephen Smalley
	<stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>,
	Casey Schaufler <casey@schaufler-ca.com>, Alex Deucher
	<alexander.deucher@amd.com>, =?UTF-8?Q?Christian_K=c3=b6nig?=
	<christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, Simona Vetter
	<simona@ffwll.ch>, Sumit Semwal <sumit.semwal@linaro.org>, Eric Dumazet
	<edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni
	<pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, "David S. Miller"
	<davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Simon Horman
	<horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra
	<peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de
 Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Alexander Shishkin
	<alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, James
 Clark <james.clark@linaro.org>, "Darrick J. Wong" <djwong@kernel.org>, Martin
 Schiller <ms@dev.tdt.de>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<fsverity@lists.linux.dev>, <linux-mm@kvack.org>, <netfs@lists.linux.dev>,
	<linux-ext4@vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>,
	<linux-nfs@vger.kernel.org>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <linux-nilfs@vger.kernel.org>,
	<v9fs@lists.linux.dev>, <linux-afs@lists.infradead.org>,
	<autofs@vger.kernel.org>, <ceph-devel@vger.kernel.org>,
	<codalist@coda.cs.cmu.edu>, <ecryptfs@vger.kernel.org>,
	<linux-mtd@lists.infradead.org>, <jfs-discussion@lists.sourceforge.net>,
	<ntfs3@lists.linux.dev>, <ocfs2-devel@lists.linux.dev>,
	<devel@lists.orangefs.org>, <linux-unionfs@vger.kernel.org>,
	<apparmor@lists.ubuntu.com>, <linux-security-module@vger.kernel.org>,
	<linux-integrity@vger.kernel.org>, <selinux@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-media@vger.kernel.org>, <linaro-mm-sig@lists.linaro.org>,
	<netdev@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-fscrypt@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-hams@vger.kernel.org>, <linux-x25@vger.kernel.org>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
 <20260226-iino-u64-v1-47-ccceff366db9@kernel.org>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <def8c48d-495c-9942-c66b-4e91d81a8e28@huawei.com>
Date: Fri, 27 Feb 2026 16:16:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20260226-iino-u64-v1-47-ccceff366db9@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.46]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk500005.china.huawei.com (7.202.194.90)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C72171C0002
X-Stat-Signature: w9hhbk18ckb3rc7aj3oiirkgesuayh4b
X-Rspam-User: 
X-HE-Tag: 1772180199-339661
X-HE-Meta: U2FsdGVkX18dezgJSUZCVUtL9PCiJbBpTRxTod0UfPt3cQvnRjoYA1WQ45mzDouY1h4xviZIyG3FlXhmotRZ+V+Pw9OEzqGrqqbzx63mv9xO3ne8Z70oRRxev+RO28ihTpJQyuQWirEmeZCi9YWr5fYv7Rxe1n0KUKUkpl22N0YH3mkYLnIE/wfEEie8dZbVeySytRJBzjf7XFfhPAmv+lOsFDDNg+R5y4N2WZa6J+MtXE+kMfJNeVlKeA7JUKbJqCLMiWCC4rGVh7Foec4nbYaOrNDmkULIPBrkjNb0zL42kJEWq9s19BNxL3AK1zhNOFhAG+peFB8StWUmu0jYE9M7hx3H5XMPy2wTH7+Eie3y3K72azTnCoZYbstcDu88MQYbX4gPncJOxsW3kBQK/+KQGGdAD3Kn5S2vg9w4m/ySqabfZTdw9IVrEAh676l881YaaQmZcT+GCJrBRYgTpSzc0uCdN5kyIaZMYwfJ0/Hbzx3U3G7Pzohqegn4fYuWZKaGnCizfwrufo7Kpyx2m2BA9kJviBXwsn2PcVdNJmeYN3ap46Q2KbdWU5lnPNR/yqU0HnDgueVxNaMfpLYiIQY8eIu6d8a9IleHNIOqsz50X5m7jTrx+/Z9CtBxgmpzk9PAugRlurFv2nmt1ijLHzZY6cogS5vw3enY6yNMy622za51WkrELq1KeAL/i51ckjgd2GZPsZfzx+9jbwW5E8Hd8gRrN0Eak09DYB+jq02rVPOYFTebA978ylEzP27dDv4amRj688SCEARN/gglzKRZJGNifQVO0u5PvA9J7/zfGv1Y7qQaNDdfnlhZAxGG+F5j7XizLXrRsTqV6iFqhQkms5gqezCcsbx/LV7z08BPZI1RL1lGbpwkhzhJrAyUZmezKymMPOAAETB68P0UAryx1coR8mFPiYXaXOZhVTVGX8nFMY/KA7H3GDpfZIEZmk/K3VYfMTtkIjvoUDn
 GIbHOI0s
 cPErx8bjJYgTFZzz55JLanSsmSrNrkK0aZmsFi5S+a4thfQrhMg5TyFQN1e/qE6M9/ouTwHPyjZ2atbXU7wh6XlTST+GiVnLcn0lzcv115IPQ8kKgEzUE8mB2J5K1Okc6yG1NHw1sfXHVcl151DbrYoMFhpV7LAef6xdpAmvcwv2IuatXNcmKfGlmDKA8hpZ2UXsts7XYcLT69c+FNg83ypynPpbtAm4EVLC3zJeuup17YJgTSDgpEUvgRUlt9PLWMfBuy/IaNKz4L6VV8D2hi5BRIRdFs/3Yb0V9XvKaVozrMls7AKE8HLMXPo6dElex1iKXk2T8hnDS3GkoSMf3aK1sMEZfb9h6akPSOT+yq9OAcNn/mE+UWJoU85lGjBGTdP1ECg+w39Cin0H7DrPNUSJ94j2zekfbDrA4QUWtkXnxh9dAGJRhQuXcG5VJDJsP1wYoEIp1/hjjEEsZgMI4Fl0IJKa8cCrQL63ni6+tyKZL5DYsqVosFJxdKVmgOoMlz95T0RbNIqHGGXz+hl5NLTLhZjjmi0oRj7XJoUekiBSaZr+WI0SOFFmgUtIcKlEqp38+39vU+0DndI3dAfIGuKzW9dQi7IbUAZkVmJl9aE30j/HHYcyxJqutZ1FXHTEJKo3OAKqwX3k2QgaROO2XU/fNAYjP41h8FN8AkkdmoJzYP2WIc8T9djRrYg8OPeoo1cskjT98eYjiFErBpxvjaHpUvBpyF88N4JInrjvVqN13F83MAZvxMm5vmMcwaHOBSOWYgu+TiQLv+Pn8xwROjtKs3UXizx+Kku9A8clHuAb38yl9uhHMLaxrs15yJWSeE7I7xkDjWILhdoKAkkEOw3vlu4N0x9AAwX3Kd7ArkH/grjK1PxXOztUcQFaQeo8sMQyqyFHccZOWkiOoW0QbHUEvzHlKdJCjYb0Ah2V/gSaDAdxDSbx+MTRE/Th+HTrVC5+O5C9mOQQC/UadImz+oyc7xOMP
 0g0t6HQj
 k5qjvwn8nlkfmsdadcP+WZ20bKVoKJwlSK5p25PtiYW6I61k6Cc8JHXq77FVr5t7PWYd8Bmz39COXkzNDD6cYmknYO0MyWtKIyeOKrpeKHKu12ZMWSyyeOTJdBOCsgdUlzCNjVA+ZQ3DVqmKuU1iWaJiXNOE9MdFpghAczWSA93AKnuzzU3XV6Iq/wbB8comBbycCrKO9z/KmSgdEImjXahLmfWJGq+iBwTbmsYXvvwrvVAsmoPLlCSDjv5HX1YbNjLgHJ6LkOy7H3hdJoLLvBzBALcWMOUr/geo/1+oPC2w9zRr/+B3GadKamnvNJZS+9d9lgXJoO7GTtuCcw5BP3s8nGT9PRVZMR6qi7RpxVkC1FyxadUZ+NCe/lqIX61vwszfhbBqapSh1lO4EwuDse3BetruS0ml7jkHYuCn7SOBqssL53Hst+qzOpSu4ZN99W8+odS9bwYmIRZL2nZ2m+HBSwi5SFB0We8foPJMcf3MI/2z9bE6pcey2Roj22h9bDkrgY7ZakwDSfyYAQCT/bliZV6ea/tHjWoApNJFcs+Tsx0LkSYD7jQwltqD7UOk76xoRNxclWtQKnVkWdwsmzVWimnH2AqlzSXkh65DvNq7KB8W+VJmjr64BksYo7qPEPGQqRIds2uLivv4GbKzVOH0AG6B67QZg45Gq/RQZnmMMPe+eYvgvGd2MG9l/Caa6bFyUcP/A+7RZDAtefHHn9kyZUBsysnIsQWE6PofZiRPXZSkeBAd72XD8b8S2mC7ejcBuh7km3r6ZnVrfovJU2Kp52eHaEkoGX0M2ebb+1RAkfvmZ7L2x0PSP85EzzP5jwtHWeIA8OOU+oZ83yT65MOL6YZYZciww6M4FgelEtSglrsjIZ0dcDGvm5icxTYly8PWpywV09OpIqDK+Z1ZDudtnrwl7emxa3pK/KA2yJKfLbweAwC1Xu7BadbNCs/ckoOI27d5oPo5UwzQaQpDX//NDO6q1
 X/r0Gu5T
 Hd1zjwMXpXJ60ixJhExxNEB+B13CjLPAEPXceha6TeFilGkos+0FDSG4S71BNzZ8POrr2ZSI/QRF6yQ4jxGB8TzzqH8uSxP4fS9YuedM4FMZaomCajd012K9Xf9jgV0ii00APtAm4xFSq9nHRQ81OhhDlcdp8hVhw8Csebf6PaDnQhliyV+5R6XBKk91pOgJB8Cs5uS+cQ3Q/YH/N/o0HiFc3R+/JyPz2uHgekVDemCG690oC+000woqtacTiuPjbRKXtYYSkg4Dd2Rgg1KjPUOeRl4sE8BkgAeXshqV9YkMgzNiOPbldavKD+vQduXqRx5RgwfQs96BCD7VYduPj3OETk1Rpv34OhzU0XR/kkDb+Um0M6h3lP2jXvv4n+dLJKofoY/Wa6lGUDgpgA8+eIhwQnN9xWC4ugT/82tRQcBKo+jwS0K6EvyZrJztHHTX8/YJbYrH5wXOvzkGDrsEEagwGKsOE4Hw5oHGLYbJgxINmbWmTH4MudSYEUIWdXmpiWnDqPMfI2UPpnk3CnbSn4oHmmRmhd2LNzGLS7j9Kf6z7eoZdA1JaxUWE4SehciooojCcUHAs7FErR31z37ENNY4M/q9qABSnnKsUoBKFbl2f2pq98QxfbvWuFdru+AqcuJ3N+osXX9mFHabBZrvk8Py1whxUIjtlVy7D7GyHv7txYkUKkdr3MTIa6FxtVkXeYAoeKTsBJAFHJiLwsPeIq+Q0X5xJ/yKcRECMMfDwLAvR32SOthOLFtPWgFr3zpmC8vqPXw51jTAZ+1x1f1xhoC+jtDS9fgxXPt5/S12SiUMXy5LGNWeQRxo4EeeTos+Q72GEQEsq3/uPM4inPUJ/nk78f3yZ/4BTvhuqeTtyBExl0fo/SKwoJUXxTfoxWepRslnaTXeOyQWDNS2uRJ8sUnnOUMBMdesqI3LopKJwQgpvcmcX1xdFtCKNu4KC5pNMlfaMtO2IfRhZ6DmcQhKV1HQcB01K
 4CdiOg6t
 SGMPY/PJc1FWeh9mOqJY4bL6yzVE3wccJ4OyXoPMe4gxaQ+uJGNFn9YqBooGCWeiCGuIuhgBjZcC6hfwpP9bvkjm0tW6JBL1gxy0zI4UKQHqGSETZz5xVrQzEbqfYgwPWpcvO/FdrfMnZu+FqjrOp/IA2PxyElSUb5zPo5VrXRBKMcbcAd9VjfV9D/aw5wDMH6tB0VSGVJr/dX/+YoyLIx5rvO1Ab78HXCaHTBY3PzUFw3UCgp7EmuyU305WvizBTQ7DeO0Xf8uvgEiTZWxnPM4dEkYcfFm9RmWsycii9Z3kaGlFiDf9p/8oZ4qOx2C9LPr8lVu/a2Mu7kLT5Biz5bxilV9n4EMabuSCv3V0UnR61ftMPJsaJYad+GQ4DCQEdzXxTa7OSRc+gyo0tz4Vsulzvy1WfYaJ25F/cgp6dDGH+JBOFbszAJqkpF/oPmipMfwOTfB6DFSSgdwQB98umQ6csQ+hPVrmnzXlCzaOMFWtptHMeMnY0dE9HEANALYsibGp/CoqEEGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/2/26 23:55, Jeff Layton 写道:
> Update format strings and local variable types in ubifs for the
> i_ino type change from unsigned long to u64.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ubifs/debug.c   |  8 ++++----
>   fs/ubifs/dir.c     | 28 ++++++++++++++--------------
>   fs/ubifs/file.c    | 28 ++++++++++++++--------------
>   fs/ubifs/journal.c |  6 +++---
>   fs/ubifs/super.c   | 16 ++++++++--------
>   fs/ubifs/tnc.c     |  4 ++--
>   fs/ubifs/xattr.c   | 14 +++++++-------
>   7 files changed, 52 insertions(+), 52 deletions(-)

Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
> 
> diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
> index 160c16aa7b6e7088355582670357262ab3930225..5794de5a9069f20302b6630c39c1452183137acc 100644
> --- a/fs/ubifs/debug.c
> +++ b/fs/ubifs/debug.c
> @@ -230,7 +230,7 @@ void ubifs_dump_inode(struct ubifs_info *c, const struct inode *inode)
>   	int count = 2;
>   
>   	pr_err("Dump in-memory inode:");
> -	pr_err("\tinode          %lu\n", inode->i_ino);
> +	pr_err("\tinode          %llu\n", inode->i_ino);
>   	pr_err("\tsize           %llu\n",
>   	       (unsigned long long)i_size_read(inode));
>   	pr_err("\tnlink          %u\n", inode->i_nlink);
> @@ -1101,7 +1101,7 @@ int dbg_check_synced_i_size(const struct ubifs_info *c, struct inode *inode)
>   	if (ui->ui_size != ui->synced_i_size && !ui->dirty) {
>   		ubifs_err(c, "ui_size is %lld, synced_i_size is %lld, but inode is clean",
>   			  ui->ui_size, ui->synced_i_size);
> -		ubifs_err(c, "i_ino %lu, i_mode %#x, i_size %lld", inode->i_ino,
> +		ubifs_err(c, "i_ino %llu, i_mode %#x, i_size %lld", inode->i_ino,
>   			  inode->i_mode, i_size_read(inode));
>   		dump_stack();
>   		err = -EINVAL;
> @@ -1163,7 +1163,7 @@ int dbg_check_dir(struct ubifs_info *c, const struct inode *dir)
>   	kfree(pdent);
>   
>   	if (i_size_read(dir) != size) {
> -		ubifs_err(c, "directory inode %lu has size %llu, but calculated size is %llu",
> +		ubifs_err(c, "directory inode %llu has size %llu, but calculated size is %llu",
>   			  dir->i_ino, (unsigned long long)i_size_read(dir),
>   			  (unsigned long long)size);
>   		ubifs_dump_inode(c, dir);
> @@ -1171,7 +1171,7 @@ int dbg_check_dir(struct ubifs_info *c, const struct inode *dir)
>   		return -EINVAL;
>   	}
>   	if (dir->i_nlink != nlink) {
> -		ubifs_err(c, "directory inode %lu has nlink %u, but calculated nlink is %u",
> +		ubifs_err(c, "directory inode %llu has nlink %u, but calculated nlink is %u",
>   			  dir->i_ino, dir->i_nlink, nlink);
>   		ubifs_dump_inode(c, dir);
>   		dump_stack();
> diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
> index 4c9f57f3b2adbbd396b288878cb18fa87cdbd0df..86d41e077e4d621dbb8c448acd0065c8ac7ae225 100644
> --- a/fs/ubifs/dir.c
> +++ b/fs/ubifs/dir.c
> @@ -223,7 +223,7 @@ static struct dentry *ubifs_lookup(struct inode *dir, struct dentry *dentry,
>   	struct ubifs_info *c = dir->i_sb->s_fs_info;
>   	struct fscrypt_name nm;
>   
> -	dbg_gen("'%pd' in dir ino %lu", dentry, dir->i_ino);
> +	dbg_gen("'%pd' in dir ino %llu", dentry, dir->i_ino);
>   
>   	err = fscrypt_prepare_lookup(dir, dentry, &nm);
>   	if (err == -ENOENT)
> @@ -281,7 +281,7 @@ static struct dentry *ubifs_lookup(struct inode *dir, struct dentry *dentry,
>   	if (IS_ENCRYPTED(dir) &&
>   	    (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode)) &&
>   	    !fscrypt_has_permitted_context(dir, inode)) {
> -		ubifs_warn(c, "Inconsistent encryption contexts: %lu/%lu",
> +		ubifs_warn(c, "Inconsistent encryption contexts: %llu/%llu",
>   			   dir->i_ino, inode->i_ino);
>   		iput(inode);
>   		inode = ERR_PTR(-EPERM);
> @@ -318,7 +318,7 @@ static int ubifs_create(struct mnt_idmap *idmap, struct inode *dir,
>   	 * parent directory inode.
>   	 */
>   
> -	dbg_gen("dent '%pd', mode %#hx in dir ino %lu",
> +	dbg_gen("dent '%pd', mode %#hx in dir ino %llu",
>   		dentry, mode, dir->i_ino);
>   
>   	err = ubifs_budget_space(c, &req);
> @@ -386,7 +386,7 @@ static struct inode *create_whiteout(struct inode *dir, struct dentry *dentry)
>   	 * atomically.
>   	 */
>   
> -	dbg_gen("dent '%pd', mode %#hx in dir ino %lu",
> +	dbg_gen("dent '%pd', mode %#hx in dir ino %llu",
>   		dentry, mode, dir->i_ino);
>   
>   	inode = ubifs_new_inode(c, dir, mode, false);
> @@ -460,7 +460,7 @@ static int ubifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
>   	 * be released via writeback.
>   	 */
>   
> -	dbg_gen("dent '%pd', mode %#hx in dir ino %lu",
> +	dbg_gen("dent '%pd', mode %#hx in dir ino %llu",
>   		dentry, mode, dir->i_ino);
>   
>   	err = fscrypt_setup_filename(dir, &dentry->d_name, 0, &nm);
> @@ -589,7 +589,7 @@ static int ubifs_readdir(struct file *file, struct dir_context *ctx)
>   	bool encrypted = IS_ENCRYPTED(dir);
>   	struct ubifs_dir_data *data = file->private_data;
>   
> -	dbg_gen("dir ino %lu, f_pos %#llx", dir->i_ino, ctx->pos);
> +	dbg_gen("dir ino %llu, f_pos %#llx", dir->i_ino, ctx->pos);
>   
>   	if (ctx->pos > UBIFS_S_KEY_HASH_MASK || ctx->pos == 2)
>   		/*
> @@ -764,7 +764,7 @@ static int ubifs_link(struct dentry *old_dentry, struct inode *dir,
>   	 * changing the parent inode.
>   	 */
>   
> -	dbg_gen("dent '%pd' to ino %lu (nlink %d) in dir ino %lu",
> +	dbg_gen("dent '%pd' to ino %llu (nlink %d) in dir ino %llu",
>   		dentry, inode->i_ino,
>   		inode->i_nlink, dir->i_ino);
>   	ubifs_assert(c, inode_is_locked(dir));
> @@ -836,7 +836,7 @@ static int ubifs_unlink(struct inode *dir, struct dentry *dentry)
>   	 * deletions.
>   	 */
>   
> -	dbg_gen("dent '%pd' from ino %lu (nlink %d) in dir ino %lu",
> +	dbg_gen("dent '%pd' from ino %llu (nlink %d) in dir ino %llu",
>   		dentry, inode->i_ino,
>   		inode->i_nlink, dir->i_ino);
>   
> @@ -941,7 +941,7 @@ static int ubifs_rmdir(struct inode *dir, struct dentry *dentry)
>   	 * because we have extra space reserved for deletions.
>   	 */
>   
> -	dbg_gen("directory '%pd', ino %lu in dir ino %lu", dentry,
> +	dbg_gen("directory '%pd', ino %llu in dir ino %llu", dentry,
>   		inode->i_ino, dir->i_ino);
>   	ubifs_assert(c, inode_is_locked(dir));
>   	ubifs_assert(c, inode_is_locked(inode));
> @@ -1018,7 +1018,7 @@ static struct dentry *ubifs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
>   	 * directory inode.
>   	 */
>   
> -	dbg_gen("dent '%pd', mode %#hx in dir ino %lu",
> +	dbg_gen("dent '%pd', mode %#hx in dir ino %llu",
>   		dentry, mode, dir->i_ino);
>   
>   	err = ubifs_budget_space(c, &req);
> @@ -1096,7 +1096,7 @@ static int ubifs_mknod(struct mnt_idmap *idmap, struct inode *dir,
>   	 * directory inode.
>   	 */
>   
> -	dbg_gen("dent '%pd' in dir ino %lu", dentry, dir->i_ino);
> +	dbg_gen("dent '%pd' in dir ino %llu", dentry, dir->i_ino);
>   
>   	if (S_ISBLK(mode) || S_ISCHR(mode)) {
>   		dev = kmalloc_obj(union ubifs_dev_desc, GFP_NOFS);
> @@ -1183,7 +1183,7 @@ static int ubifs_symlink(struct mnt_idmap *idmap, struct inode *dir,
>   					.dirtied_ino = 1 };
>   	struct fscrypt_name nm;
>   
> -	dbg_gen("dent '%pd', target '%s' in dir ino %lu", dentry,
> +	dbg_gen("dent '%pd', target '%s' in dir ino %llu", dentry,
>   		symname, dir->i_ino);
>   
>   	err = fscrypt_prepare_symlink(dir, symname, len, UBIFS_MAX_INO_DATA,
> @@ -1349,7 +1349,7 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
>   	 *   ino_req: marks the target inode as dirty and does not write it.
>   	 */
>   
> -	dbg_gen("dent '%pd' ino %lu in dir ino %lu to dent '%pd' in dir ino %lu flags 0x%x",
> +	dbg_gen("dent '%pd' ino %llu in dir ino %llu to dent '%pd' in dir ino %llu flags 0x%x",
>   		old_dentry, old_inode->i_ino, old_dir->i_ino,
>   		new_dentry, new_dir->i_ino, flags);
>   
> @@ -1597,7 +1597,7 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
>   	 * parent directory inodes.
>   	 */
>   
> -	dbg_gen("dent '%pd' ino %lu in dir ino %lu exchange dent '%pd' ino %lu in dir ino %lu",
> +	dbg_gen("dent '%pd' ino %llu in dir ino %llu exchange dent '%pd' ino %llu in dir ino %llu",
>   		old_dentry, fst_inode->i_ino, old_dir->i_ino,
>   		new_dentry, snd_inode->i_ino, new_dir->i_ino);
>   
> diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
> index cd04755e792a7f8e7d33ed4e67806cd202c71fad..e73c28b12f97fd1fbeb67510434e499eab84da70 100644
> --- a/fs/ubifs/file.c
> +++ b/fs/ubifs/file.c
> @@ -90,7 +90,7 @@ static int read_block(struct inode *inode, struct folio *folio, size_t offset,
>   	return 0;
>   
>   dump:
> -	ubifs_err(c, "bad data node (block %u, inode %lu)",
> +	ubifs_err(c, "bad data node (block %u, inode %llu)",
>   		  block, inode->i_ino);
>   	ubifs_dump_node(c, dn, UBIFS_MAX_DATA_NODE_SZ);
>   	return -EINVAL;
> @@ -106,7 +106,7 @@ static int do_readpage(struct folio *folio)
>   	loff_t i_size = i_size_read(inode);
>   	size_t offset = 0;
>   
> -	dbg_gen("ino %lu, pg %lu, i_size %lld, flags %#lx",
> +	dbg_gen("ino %llu, pg %lu, i_size %lld, flags %#lx",
>   		inode->i_ino, folio->index, i_size, folio->flags.f);
>   	ubifs_assert(c, !folio_test_checked(folio));
>   	ubifs_assert(c, !folio->private);
> @@ -162,7 +162,7 @@ static int do_readpage(struct folio *folio)
>   			dbg_gen("hole");
>   			err = 0;
>   		} else {
> -			ubifs_err(c, "cannot read page %lu of inode %lu, error %d",
> +			ubifs_err(c, "cannot read page %lu of inode %llu, error %d",
>   				  folio->index, inode->i_ino, err);
>   		}
>   	}
> @@ -212,7 +212,7 @@ static int write_begin_slow(struct address_space *mapping,
>   	int err, appending = !!(pos + len > inode->i_size);
>   	struct folio *folio;
>   
> -	dbg_gen("ino %lu, pos %llu, len %u, i_size %lld",
> +	dbg_gen("ino %llu, pos %llu, len %u, i_size %lld",
>   		inode->i_ino, pos, len, inode->i_size);
>   
>   	/*
> @@ -526,7 +526,7 @@ static int ubifs_write_end(const struct kiocb *iocb,
>   	loff_t end_pos = pos + len;
>   	int appending = !!(end_pos > inode->i_size);
>   
> -	dbg_gen("ino %lu, pos %llu, pg %lu, len %u, copied %d, i_size %lld",
> +	dbg_gen("ino %llu, pos %llu, pg %lu, len %u, copied %d, i_size %lld",
>   		inode->i_ino, pos, folio->index, len, copied, inode->i_size);
>   
>   	if (unlikely(copied < len && !folio_test_uptodate(folio))) {
> @@ -599,7 +599,7 @@ static int populate_page(struct ubifs_info *c, struct folio *folio,
>   	size_t offset = 0;
>   	pgoff_t end_index;
>   
> -	dbg_gen("ino %lu, pg %lu, i_size %lld, flags %#lx",
> +	dbg_gen("ino %llu, pg %lu, i_size %lld, flags %#lx",
>   		inode->i_ino, folio->index, i_size, folio->flags.f);
>   
>   	end_index = (i_size - 1) >> PAGE_SHIFT;
> @@ -680,7 +680,7 @@ static int populate_page(struct ubifs_info *c, struct folio *folio,
>   	return 0;
>   
>   out_err:
> -	ubifs_err(c, "bad data node (block %u, inode %lu)",
> +	ubifs_err(c, "bad data node (block %u, inode %llu)",
>   		  page_block, inode->i_ino);
>   	return -EINVAL;
>   }
> @@ -913,7 +913,7 @@ static int do_writepage(struct folio *folio, size_t len)
>   	}
>   	if (err) {
>   		mapping_set_error(folio->mapping, err);
> -		ubifs_err(c, "cannot write folio %lu of inode %lu, error %d",
> +		ubifs_err(c, "cannot write folio %lu of inode %llu, error %d",
>   			  folio->index, inode->i_ino, err);
>   		ubifs_ro_mode(c, err);
>   	}
> @@ -987,7 +987,7 @@ static int ubifs_writepage(struct folio *folio, struct writeback_control *wbc)
>   	loff_t i_size =  i_size_read(inode), synced_i_size;
>   	int err, len = folio_size(folio);
>   
> -	dbg_gen("ino %lu, pg %lu, pg flags %#lx",
> +	dbg_gen("ino %llu, pg %lu, pg flags %#lx",
>   		inode->i_ino, folio->index, folio->flags.f);
>   	ubifs_assert(c, folio->private != NULL);
>   
> @@ -1106,7 +1106,7 @@ static int do_truncation(struct ubifs_info *c, struct inode *inode,
>   	int offset = new_size & (UBIFS_BLOCK_SIZE - 1), budgeted = 1;
>   	struct ubifs_inode *ui = ubifs_inode(inode);
>   
> -	dbg_gen("ino %lu, size %lld -> %lld", inode->i_ino, old_size, new_size);
> +	dbg_gen("ino %llu, size %lld -> %lld", inode->i_ino, old_size, new_size);
>   	memset(&req, 0, sizeof(struct ubifs_budget_req));
>   
>   	/*
> @@ -1258,7 +1258,7 @@ int ubifs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>   	struct inode *inode = d_inode(dentry);
>   	struct ubifs_info *c = inode->i_sb->s_fs_info;
>   
> -	dbg_gen("ino %lu, mode %#x, ia_valid %#x",
> +	dbg_gen("ino %llu, mode %#x, ia_valid %#x",
>   		inode->i_ino, inode->i_mode, attr->ia_valid);
>   	err = setattr_prepare(&nop_mnt_idmap, dentry, attr);
>   	if (err)
> @@ -1308,7 +1308,7 @@ int ubifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>   	struct ubifs_info *c = inode->i_sb->s_fs_info;
>   	int err;
>   
> -	dbg_gen("syncing inode %lu", inode->i_ino);
> +	dbg_gen("syncing inode %llu", inode->i_ino);
>   
>   	if (c->ro_mount)
>   		/*
> @@ -1495,7 +1495,7 @@ static vm_fault_t ubifs_vm_page_mkwrite(struct vm_fault *vmf)
>   	struct ubifs_budget_req req = { .new_page = 1 };
>   	int err, update_time;
>   
> -	dbg_gen("ino %lu, pg %lu, i_size %lld",	inode->i_ino, folio->index,
> +	dbg_gen("ino %llu, pg %lu, i_size %lld",	inode->i_ino, folio->index,
>   		i_size_read(inode));
>   	ubifs_assert(c, !c->ro_media && !c->ro_mount);
>   
> @@ -1531,7 +1531,7 @@ static vm_fault_t ubifs_vm_page_mkwrite(struct vm_fault *vmf)
>   	err = ubifs_budget_space(c, &req);
>   	if (unlikely(err)) {
>   		if (err == -ENOSPC)
> -			ubifs_warn(c, "out of space for mmapped file (inode number %lu)",
> +			ubifs_warn(c, "out of space for mmapped file (inode number %llu)",
>   				   inode->i_ino);
>   		return VM_FAULT_SIGBUS;
>   	}
> diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
> index e28ab4395e5ca404d8e8d8f735c3113b58bcc941..40a95a2fad50039f39917e71da7b71a735237469 100644
> --- a/fs/ubifs/journal.c
> +++ b/fs/ubifs/journal.c
> @@ -982,7 +982,7 @@ int ubifs_jnl_write_inode(struct ubifs_info *c, const struct inode *inode)
>   	int kill_xattrs = ui->xattr_cnt && last_reference;
>   	u8 hash[UBIFS_HASH_ARR_SZ];
>   
> -	dbg_jnl("ino %lu, nlink %u", inode->i_ino, inode->i_nlink);
> +	dbg_jnl("ino %llu, nlink %u", inode->i_ino, inode->i_nlink);
>   
>   	if (kill_xattrs && ui->xattr_cnt > ubifs_xattr_max_cnt(c)) {
>   		ubifs_err(c, "Cannot delete inode, it has too many xattrs!");
> @@ -1743,7 +1743,7 @@ int ubifs_jnl_truncate(struct ubifs_info *c, const struct inode *inode,
>   			int dn_len = le32_to_cpu(dn->size);
>   
>   			if (dn_len <= 0 || dn_len > UBIFS_BLOCK_SIZE) {
> -				ubifs_err(c, "bad data node (block %u, inode %lu)",
> +				ubifs_err(c, "bad data node (block %u, inode %llu)",
>   					  blk, inode->i_ino);
>   				ubifs_dump_node(c, dn, dn_size);
>   				err = -EUCLEAN;
> @@ -1987,7 +1987,7 @@ int ubifs_jnl_change_xattr(struct ubifs_info *c, const struct inode *inode,
>   	u8 hash_host[UBIFS_HASH_ARR_SZ];
>   	u8 hash[UBIFS_HASH_ARR_SZ];
>   
> -	dbg_jnl("ino %lu, ino %lu", host->i_ino, inode->i_ino);
> +	dbg_jnl("ino %llu, ino %llu", host->i_ino, inode->i_ino);
>   	ubifs_assert(c, inode->i_nlink > 0);
>   	ubifs_assert(c, mutex_is_locked(&host_ui->ui_mutex));
>   
> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
> index 03bf924756ca003809d229837a970d5935450f23..9a77d8b64ffa70f9d5b695fb3d87c22cb223704f 100644
> --- a/fs/ubifs/super.c
> +++ b/fs/ubifs/super.c
> @@ -92,7 +92,7 @@ static int validate_inode(struct ubifs_info *c, const struct inode *inode)
>   		return 5;
>   
>   	if (!ubifs_compr_present(c, ui->compr_type)) {
> -		ubifs_warn(c, "inode %lu uses '%s' compression, but it was not compiled in",
> +		ubifs_warn(c, "inode %llu uses '%s' compression, but it was not compiled in",
>   			   inode->i_ino, ubifs_compr_name(c, ui->compr_type));
>   	}
>   
> @@ -248,14 +248,14 @@ struct inode *ubifs_iget(struct super_block *sb, unsigned long inum)
>   	return inode;
>   
>   out_invalid:
> -	ubifs_err(c, "inode %lu validation failed, error %d", inode->i_ino, err);
> +	ubifs_err(c, "inode %llu validation failed, error %d", inode->i_ino, err);
>   	ubifs_dump_node(c, ino, UBIFS_MAX_INO_NODE_SZ);
>   	ubifs_dump_inode(c, inode);
>   	err = -EINVAL;
>   out_ino:
>   	kfree(ino);
>   out:
> -	ubifs_err(c, "failed to read inode %lu, error %d", inode->i_ino, err);
> +	ubifs_err(c, "failed to read inode %llu, error %d", inode->i_ino, err);
>   	iget_failed(inode);
>   	return ERR_PTR(err);
>   }
> @@ -316,12 +316,12 @@ static int ubifs_write_inode(struct inode *inode, struct writeback_control *wbc)
>   	 * As an optimization, do not write orphan inodes to the media just
>   	 * because this is not needed.
>   	 */
> -	dbg_gen("inode %lu, mode %#x, nlink %u",
> +	dbg_gen("inode %llu, mode %#x, nlink %u",
>   		inode->i_ino, (int)inode->i_mode, inode->i_nlink);
>   	if (inode->i_nlink) {
>   		err = ubifs_jnl_write_inode(c, inode);
>   		if (err)
> -			ubifs_err(c, "can't write inode %lu, error %d",
> +			ubifs_err(c, "can't write inode %llu, error %d",
>   				  inode->i_ino, err);
>   		else
>   			err = dbg_check_inode_size(c, inode, ui->ui_size);
> @@ -357,7 +357,7 @@ static void ubifs_evict_inode(struct inode *inode)
>   		 */
>   		goto out;
>   
> -	dbg_gen("inode %lu, mode %#x", inode->i_ino, (int)inode->i_mode);
> +	dbg_gen("inode %llu, mode %#x", inode->i_ino, (int)inode->i_mode);
>   	ubifs_assert(c, !icount_read(inode));
>   
>   	truncate_inode_pages_final(&inode->i_data);
> @@ -375,7 +375,7 @@ static void ubifs_evict_inode(struct inode *inode)
>   		 * Worst case we have a lost orphan inode wasting space, so a
>   		 * simple error message is OK here.
>   		 */
> -		ubifs_err(c, "can't delete inode %lu, error %d",
> +		ubifs_err(c, "can't delete inode %llu, error %d",
>   			  inode->i_ino, err);
>   
>   out:
> @@ -399,7 +399,7 @@ static void ubifs_dirty_inode(struct inode *inode, int flags)
>   	ubifs_assert(c, mutex_is_locked(&ui->ui_mutex));
>   	if (!ui->dirty) {
>   		ui->dirty = 1;
> -		dbg_gen("inode %lu",  inode->i_ino);
> +		dbg_gen("inode %llu",  inode->i_ino);
>   	}
>   }
>   
> diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
> index 694b08d27d7d9c7d9d7d9039f406637c702f8613..52c758c5290d8cc425fdc6d49c608d0cb0ba7ff7 100644
> --- a/fs/ubifs/tnc.c
> +++ b/fs/ubifs/tnc.c
> @@ -3561,8 +3561,8 @@ int dbg_check_inode_size(struct ubifs_info *c, const struct inode *inode,
>   
>   out_dump:
>   	block = key_block(c, key);
> -	ubifs_err(c, "inode %lu has size %lld, but there are data at offset %lld",
> -		  (unsigned long)inode->i_ino, size,
> +	ubifs_err(c, "inode %llu has size %lld, but there are data at offset %lld",
> +		  (unsigned long long)inode->i_ino, size,
>   		  ((loff_t)block) << UBIFS_BLOCK_SHIFT);
>   	mutex_unlock(&c->tnc_mutex);
>   	ubifs_dump_inode(c, inode);
> diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
> index c21a0c2b3e907c1572780d4a3e48cc9d2a11b9d6..b5a9ab9d8a10adcf49e6d7228d385cb986e6e75e 100644
> --- a/fs/ubifs/xattr.c
> +++ b/fs/ubifs/xattr.c
> @@ -76,7 +76,7 @@ static int create_xattr(struct ubifs_info *c, struct inode *host,
>   				.dirtied_ino_d = ALIGN(host_ui->data_len, 8) };
>   
>   	if (host_ui->xattr_cnt >= ubifs_xattr_max_cnt(c)) {
> -		ubifs_err(c, "inode %lu already has too many xattrs (%d), cannot create more",
> +		ubifs_err(c, "inode %llu already has too many xattrs (%d), cannot create more",
>   			  host->i_ino, host_ui->xattr_cnt);
>   		return -ENOSPC;
>   	}
> @@ -88,7 +88,7 @@ static int create_xattr(struct ubifs_info *c, struct inode *host,
>   	 */
>   	names_len = host_ui->xattr_names + host_ui->xattr_cnt + fname_len(nm) + 1;
>   	if (names_len > XATTR_LIST_MAX) {
> -		ubifs_err(c, "cannot add one more xattr name to inode %lu, total names length would become %d, max. is %d",
> +		ubifs_err(c, "cannot add one more xattr name to inode %llu, total names length would become %d, max. is %d",
>   			  host->i_ino, names_len, XATTR_LIST_MAX);
>   		return -ENOSPC;
>   	}
> @@ -390,7 +390,7 @@ ssize_t ubifs_listxattr(struct dentry *dentry, char *buffer, size_t size)
>   	int err, len, written = 0;
>   	struct fscrypt_name nm = {0};
>   
> -	dbg_gen("ino %lu ('%pd'), buffer size %zd", host->i_ino,
> +	dbg_gen("ino %llu ('%pd'), buffer size %zd", host->i_ino,
>   		dentry, size);
>   
>   	down_read(&host_ui->xattr_sem);
> @@ -498,7 +498,7 @@ int ubifs_purge_xattrs(struct inode *host)
>   	if (ubifs_inode(host)->xattr_cnt <= ubifs_xattr_max_cnt(c))
>   		return 0;
>   
> -	ubifs_warn(c, "inode %lu has too many xattrs, doing a non-atomic deletion",
> +	ubifs_warn(c, "inode %llu has too many xattrs, doing a non-atomic deletion",
>   		   host->i_ino);
>   
>   	down_write(&ubifs_inode(host)->xattr_sem);
> @@ -641,7 +641,7 @@ int ubifs_init_security(struct inode *dentry, struct inode *inode,
>   					   &init_xattrs, NULL);
>   	if (err) {
>   		struct ubifs_info *c = dentry->i_sb->s_fs_info;
> -		ubifs_err(c, "cannot initialize security for inode %lu, error %d",
> +		ubifs_err(c, "cannot initialize security for inode %llu, error %d",
>   			  inode->i_ino, err);
>   	}
>   	return err;
> @@ -652,7 +652,7 @@ static int xattr_get(const struct xattr_handler *handler,
>   			   struct dentry *dentry, struct inode *inode,
>   			   const char *name, void *buffer, size_t size)
>   {
> -	dbg_gen("xattr '%s', ino %lu ('%pd'), buf size %zd", name,
> +	dbg_gen("xattr '%s', ino %llu ('%pd'), buf size %zd", name,
>   		inode->i_ino, dentry, size);
>   
>   	name = xattr_full_name(handler, name);
> @@ -665,7 +665,7 @@ static int xattr_set(const struct xattr_handler *handler,
>   			   const char *name, const void *value,
>   			   size_t size, int flags)
>   {
> -	dbg_gen("xattr '%s', host ino %lu ('%pd'), size %zd",
> +	dbg_gen("xattr '%s', host ino %llu ('%pd'), size %zd",
>   		name, inode->i_ino, dentry, size);
>   
>   	name = xattr_full_name(handler, name);
> 


