Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFAB1FD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59B0F6B00E6; Thu, 26 Feb 2026 10:58:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5646C6B00E7; Thu, 26 Feb 2026 10:58:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40F9F6B00E8; Thu, 26 Feb 2026 10:58:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 296336B00E6
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:58:26 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8A6BC1546
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:58:25 +0000 (UTC)
X-FDA: 84487064970.23.8F0ACF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3E3E5160011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:58:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dCt3uwXV;
	spf=pass (imf08.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2riSwB9oXrA+hUDwKZ6wuBgSmQFaS7XnYX+TB1vHGTk=;
	b=Gqtz3RMrOg1LyWfyxVbnzmHRFloyUuYqM+9gkf/YBj+gnJbPmlH0nmu4pTPRxW5X7TgTXG
	Eh2LrOBrdyChtOYhEqehPMB6aW4Pf9WtwL7FXKBtHY5Q5YyD4obZX/wTIXA6PC8baqLciU
	T0YPgivi2TYCgxX9dyoC9wikJeeTxUQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dCt3uwXV;
	spf=pass (imf08.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121504; a=rsa-sha256;
	cv=none;
	b=zVooacp9QyTRfeuth472hujClsnHewHdapHifjE5HYrvbM0UUGKFxieQECgipd+dpqxhqL
	BGZaiU4L2V/2Xj+zxdb1P8SkuI4NrwcuZx4WIz9csUufAuT5w+OMpxqA6fmxf432X0myEg
	atiJDoPrDXJcwVei5msfOP/vcic7kyQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 788E160141;
	Thu, 26 Feb 2026 15:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FE1C19424;
	Thu, 26 Feb 2026 15:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121503;
	bh=LdZkgMiSMRyY7w4wkYXYbMfPdYZGHhFy6fPC/XGukhU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dCt3uwXVqrIJKbQvl3uX9/gup6SlY+mQqX91Ad9vd7S8op6Yd+KnCAZfqT4OSuZ5h
	 bFGxqPsbtlVvSFA4/Lcr/ut8yak5t5k7WCf1y5xyJDtumk+D//S9Di9nluiniHliYC
	 n6eVHA0dgSRDHNycrjK4MqfgaELytBs0GHEHSXiF38hbEWVUj9xLFXhbX16GPBXJMZ
	 EWNLIPkjbNzqBFPY4qkwolYq3Ss4/8HVyAO6aOFGde9RPZDyI3a7asDXIiMWO1moUp
	 C5DzD0aiQOnrsnc3jTtDPTUBA6EVUpdOUkm5ZK+MlUq+bpXUpYb2af9356FNFx49bL
	 9plvVtOi3V43A==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:12 -0500
Subject: [PATCH 10/61] nfs: remove nfs_compat_user_ino64()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-10-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3342; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=LdZkgMiSMRyY7w4wkYXYbMfPdYZGHhFy6fPC/XGukhU=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0GsDBsYnVAsr/6aY+OdwYGWSxrZsM8EJuxC
 Q78RgWfUx+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtBgAKCRAADmhBGVaC
 Few+D/4mutU81rl2n75boDhsJKJUaSJoujeBAfusAFqLjMdwyXIMSpj4L7+chJ7lo0OoNZKL9Tz
 FJ/WpcytXS5tASm4LU5ttoves66soBtPT/e9jqIden5a+xNYd2xdMQz2GkYLU8UoEDMKz2B4FWi
 bbXP1cdIi+Gs1L00idufQp9klca91ib/uh4ZDWmILa66KtgJiqpNT8IW/FZ+rRbL4DxXzX9Odyw
 xY3XP2mOemu+oUKNHuaVtKqd/mo7+/mrtnfTxGbycSCIYvUq4xZiWRa2HaeeW9mJ9AW8PgceRxS
 Xe+5t/g4fR7ybGLeaa1lxM441cQIrG2VjJMCglE62qoaOPbG1U7nhQQbq49cVdXftZu3qvqe08b
 xZZ1Zb1Xj2BLi+1LZc2hU083aHI6YGhzjD/uu33zfHrY43PjKARDtU8ke1+4BWZ7SDJgXlNXqqT
 +XlOWV4PRKQoQcLIhLJZMRvGpY5Uf2fAN5IWLCUcXxUG73lbx2woNUdFTxa7siP3V5FgljMFZIh
 ud/Fy3p+krV0hwTknttuuV+JC1OGV4wXj6aIOpmLjOd7gQy1p8SNSdR6SL+XZg7OsWQZCRqSZpH
 4xHedLHyQldZ+1gf5fEeSO+f7vru2AwppvkFyWar5ihu7zNrouABbWaJDO0QkNsPsXetXqyntDa
 PQTg7n2ICcFlcnw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E3E5160011
X-Rspamd-Server: rspam02
X-Stat-Signature: 1exaq77wz6896j7q89kfothcjxfr5j8j
X-HE-Tag: 1772121504-432318
X-HE-Meta: U2FsdGVkX1/cFppDebM5VC84j1vqm1S+iwtX0MLTDIBQ2e7W3RAbov1N67Lf36MhGlqOkJb/D2L7Tp0ryLMIJlz92Nw37AvmUqGVlHPMKzf1FPZsvTI1ujGq7weUwgXx6AU6BNBvW38azqzUqx9byIirM+x0dFBlxMXbZE9884Xczd4AAGEtC80DC1872ruH0oU8T5x3CormW7+++Sk5zy0+/W1CuMhokYgW0fib+KyzkYkFLGqA5liSv2ZyCWJwe/BbQVRYwbFZY9rAmvkKGuTzF1H6XmID2e5OSsEo5cN1zvTK4NjJwjja6H2jYjrhlw2/+v9Q9X1EkjlNCvSS2yXapp/cDXNuf4u0ApdTp0pErZFzmmNAjJm2xV9WVqkH0Zm/Q4HVPBT9m3ZlgsCwhk+yQRIJPhIlIuwTKWqGrytQhTYa02gmQG82EhaqzBvirEIeKC2KxnXlAzx6BYtiqMj3/Xf99HxrpOhabk8ahinfDKROfAfY+QE4siRKxE5Tx1uQEJYZdENRa64lK1xjrmF9g685sgVSi2wxW7KSEutdE6fLn7Ea/siLCzdV8Xpn3XHzOh4pBHDeNdjQl3IMHSOI+9mDfPnYnQ9Sq2cYTRLFNcPHzKa98rxZ58rIlntY7n1HGtqnoygZgmpkf+aHG02UYv+TIkn/muv/H+r6Rwba+vCVh0IQBjaxQJf08jWmKzqEu8QXxQ0gihy8d38aWJBAdnalZ/VrldUWoUzs+hx4Tg91ys/I+ckwv7y+ieKND5xT0QZ7/QmjDwPizPi2fpvgdgFcNin/kjDR1mkblNKIdDNQcgwQM9YI2k5oGTGWfVbekQ+u4O2CIZfioB4MTtOdpMXZ0fMQtU9l+FaD77eAB9HcTJ8ExU7C5KsOV5jIqiYmkPAULiC+FxfOMyS+ecD10EPjE8szBGaBC1lZnjioW6uuxgEgo+1lh0FxlPlIZu3JBtB3R4S760WzJ+N
 WKi9dmQm
 14k/gvdh7lxvJkqD5017QKcTyFgYrHnPKMAjfs5KwenwdDdDCbyEbg92rfiVLqd5u996Xg/DA8bnu/+OARvd3mEQp4ZTdLN83MeGhiZe7NsQfKCyHSa3MLQo88DkvvvM2Bg+CZfQOy9Fp0wSejRpPAjOElR0AABfJ69kvJXTb9v2w8OgI8H78yFue9HourtSINlxEhMq+GVfw5VCxQg0FLJnSRs4tiWMWzVz/c/mZUqsnGCEEceqNcsmzj5MLoZwuCFY8gJOx+G9cNjHnjiDrLz3EcbIAujItzXikKrTxSkEBoBE0FZWjbXvjmLfxli2Qhsjo63pXgRCU2q8nKNRXsF2MSL8df1wYNc0wTbDza7jZuCE6qcucJ47OfT2pr6Xf9AwzA+Fo92Qaz/YJJXloUkfbedKUtWbDn8AQkJDBw8rHtW809ZxU914zstbTpG4P5qz0cG6oNplm42JM57Rtw4KCLxCdD3SU3DoSDEA3eqlYQyKeHD3PypTprlxcJqb09lbq4Ahyx7bStwI1FpIFZYqJdpj6RH4PgGmRCIJzoP/mY3NebQATrYCFmAQ9Fa8hSOuF2OnLzD0WXf4LdHpyycyMpoOBc28ZTfa2fp1grFYkiSjwXt1ubskyMa+9OV8bUQmUKEvoRrVZRTTidQydfOHbTPQOoTFzacMq1ul5IVvQg5Pr1/hO4WsvG1WpMGGgyw9m/NFPU9UbUC7QHUFg1GbSjVLn6EMG4jMXYBDUi+2E4fhGQeHQqlCSP2UCGmavuCpTpaoxMK6ySjvsPFGMrW32p4P8Am11Oh6Rs9p4FWHAw9jBT9zUR77F/3DwpxAiQIeM4mX+uYxRIcOH7B5LWcwHsbxWK1FlBJA1P2UHPetAn2qu/E5BBAPhm8NfqSnTDiSxED3gP7RvfDPzbYhNpFqwEq0yoHhC624TTeduuPI9cZlMlFRYNhYzVPMJTx9pYP21MChO7WQ4DwQm7ldHjBU5WKB2
 Kdul6wKQ
 iwCap+fCMPGa0q3LKxrGLHQL9esZTaHZTmThUVIpRdBcFMS9V3M8rfAsEp3g0f45tn/lqJ5F8sQi2/ULhiLQaPVi/j73+pX+ddjG1zu5beP4EY1t87243bKUIRCGxtWSChR0MKGmLyH0BzTQooylGgMDIBF5Rb2Am4KzOGFCL+8XPAyt3jbzXoRdADKqYs+qA1quIwFgBdYo5scPJtK5bVrPEHugRbLFFxr6GA2D5/b1uXOhuBabmEelreXJgtoOCnMbsfmuAIZYJpCiXOS0rRM8CnxwZSSrC1WisnHX94qe9yraLjimEchpfAkhzdn8HRHWQZYXQ5WR3cY1M9Hcncn2djryQbWoaI1tAjAqPrsXtY3NgbYmAcPct2Sa4s21ZUqI7Hag1gv0+tbeWuIcuxyr/+iMA3tPnqK0Re3OT1Ilygan6KDdmDnNrAckuMBuG41wv/Fk4dG7zX6XoRHcNVgD6uvRt8fSeEDlfWciHdU0QbpPVmYh+zIUdqIxTZagMKXFuVl1zeN+yrwbEHYYP3ydwhGG0qGZ+sJz9L2GsG9bKl6I2QSjThrCboJa5ngOO6QHRSpLVvY3kWURI7sC4vyp8rJWeq+CU9Sb4Eqq4tNAGcrz2zHaayJz+InDlTGCfBwz3imLeAVAMv7QU5SB+FdrxaewH44H/Su77o95macTRu0fIOAO7f1NOMLmqRhOlSyl+TUw+IqTtH/tbqCwGTgT0VfqSr1LJ74xQ9pVyMe5pe7hxyABKMSdQb1imEoNuDUUhFLqNd+PmYICuXyI/TN5J1iMe0yMbMpuUJt4QXXhvWpS/qycyBuZ4taeyAI4yhAguAE9yoxdhD39GGTB3zR4Q6Xu3fNa7EoEUj9/kSsnHSostYSIkYtE2I8mcZyeoPThi88ifBg7WSqJEYyugfGEkd77n013Y0lxdmkvuVyY+12wOx7pwIpPgrOsXCpHlUXVrK1AwjISluOK2rIAMpLQ5q+yY
 p9WwNPzy
 ByEartk1TuwdDXQcByUT6jMFgN0epB2jtrwuaJn7KiNABMt3uYA9d+znBT8l+rLz3TZKC2sb2pwDgsTr5ePllY8SJbgdv5YvccQcJDGSf9QUCEKYJ1swMh8STqkFJfcWTBlg0lUAXERm0Qy3fdPpeg45fyS4fB3rmTYTS88KPdPwylfugQjFOikqw2I3t5z6cQ5RTj9RwOpdQlbM3ASxc5mH8UIFnmi+apVW7r+KfkHjVChHruiZVV5Si9+PsjMBbBgAPJrtq241N2ALxNWERfMXXfopc4auiKKU4GlWI6RElFkFGgQW+LbRFTDGYyTErwFvdW9R9/Q8O+drPcLaKxoFcPME9d7Kuy2vX49cDK1SaQbtDC7cfcoEV1eN+zCrt32kXKhNN0ePe5cgdQs9BBGQnNFPVixu/X4Ug16VEwvTavi//7yX0Yo6hAfk71r6WzJIEKGh+cCxwfKIF/cgm8LAserYre5INIcMeDoZp/vNkTGk/OEkqeidcqbQG33yYBk+bPMxVNWv3F97YJa4nClr81FPhPFJ+OXvaFnACeuvVZQRmIQLmbwwP+7VFxbOR6tOahfWf1rNRHK9JTylh8y2Fqsb1GjzpDQKsw2xb5JMCfoyYwCUh51fz0FgTmU2gg9uRwpMkKYWwKwUD/8u8AGD8oFj7/OnwovW0eNsfE7HZXk2/WYbcVNTUjCX9BLoKJdh1f78/YZXW2hLb5Vikr7rd2gVUjdxTu5kDiYcsEUW0V5TGA/v0Wum8akLInRYzQoehjuuQvLYlG1V4ktZcF5AjzR46gKl/BzyWAnRAVfDtnJXIWgkzmIBl57cVQTDSL3M2pl+WL4gozk1ztY9lRcgu22HL/mdmMstsDexm0SePJaILB7e1wRn99lspHJCAd9D7rshCoIOzyBC+lqTjhzVERSAp0Te4+z8nVgUkjDdxbufTdzomCbMeuE6sUVG3OjybQdXX+jYEBoO7PawoVL1ydmEB
 F6+hrUkZ
 Bp7C92v6MIKa2bgJq8+8FAXzu/geeWHQ98f2wa6A5LZUlVlpfu+HHP/iL1DRo3YWyaEmUex5WWxk+ZJ2ze63CCVJCCyreSjjW2a8eHdO2VvBJWueW5H0ZKxOGnZlh+btE/SosTVZC5NdxrL9NkpAeVACQQslMewCkJKZ513LLMCVUC7PfJegXYb0rwLsBI5TsUUDK/w45XNcwEts4icrDj0eUcxCu0nOyjDDH27xm4UeZ0Cl5DPogqcF1/uE6hpTj/P2NFoChODCldUwMVV755MVrvuDjGZkqbnDEGtm6QXLJhfw6CjHtIypU7CRJQftZWRGSV+RUwN6ceZ38Ru7Kv4uqg+/KLvYRazfB9QaCt9GbRTdFhnvh7DTs0AefR9JMWGcSBZwKI3vNpV/eoMm7at7pGDX/M71LpbmUGvpLneg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64, the VFS stat path handles 64-bit inode numbers
natively. The truncation to 32-bit st_ino (with -EOVERFLOW) is handled
by cp_new_stat() and cp_compat_stat() in the generic stat code, so the
NFS-specific XOR-folding hack is no longer needed.

Remove nfs_compat_user_ino64() and have callers pass the full 64-bit
fileid directly to stat->ino and dir_emit(), both of which accept u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/nfs/dir.c           |  2 +-
 fs/nfs/inode.c         | 25 +------------------------
 include/linux/nfs_fs.h |  1 -
 3 files changed, 2 insertions(+), 26 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index ddc3789363a5f8a2ef0169e37aa2292d075092c4..a9ef74d0cff8de58a42be9c2c94af428a347bb2e 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1107,7 +1107,7 @@ static void nfs_do_filldir(struct nfs_readdir_descriptor *desc,
 
 		ent = &array->array[i];
 		if (!dir_emit(desc->ctx, ent->name, ent->name_len,
-		    nfs_compat_user_ino64(ent->ino), ent->d_type)) {
+		    ent->ino, ent->d_type)) {
 			desc->eob = true;
 			break;
 		}
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index d88f5689548bcb4e27d6087a49b525762fbaa9e2..1a7d7bafbb623ab603b8c517628343463277e096 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -77,29 +77,6 @@ int nfs_wait_bit_killable(struct wait_bit_key *key, int mode)
 }
 EXPORT_SYMBOL_GPL(nfs_wait_bit_killable);
 
-/**
- * nfs_compat_user_ino64 - returns the user-visible inode number
- * @fileid: 64-bit fileid
- *
- * This function returns a 32-bit inode number if the boot parameter
- * nfs.enable_ino64 is zero.
- */
-u64 nfs_compat_user_ino64(u64 fileid)
-{
-#ifdef CONFIG_COMPAT
-	compat_ulong_t ino;
-#else	
-	unsigned long ino;
-#endif
-
-	if (enable_ino64)
-		return fileid;
-	ino = fileid;
-	if (sizeof(ino) < sizeof(fileid))
-		ino ^= fileid >> (sizeof(fileid)-sizeof(ino)) * 8;
-	return ino;
-}
-
 int nfs_drop_inode(struct inode *inode)
 {
 	return NFS_STALE(inode) || inode_generic_drop(inode);
@@ -1061,7 +1038,7 @@ int nfs_getattr(struct mnt_idmap *idmap, const struct path *path,
 	stat->result_mask = nfs_get_valid_attrmask(inode) | request_mask;
 
 	generic_fillattr(&nop_mnt_idmap, request_mask, inode, stat);
-	stat->ino = nfs_compat_user_ino64(NFS_FILEID(inode));
+	stat->ino = NFS_FILEID(inode);
 	stat->change_cookie = inode_peek_iversion_raw(inode);
 	stat->attributes_mask |= STATX_ATTR_CHANGE_MONOTONIC;
 	if (server->change_attr_type != NFS4_CHANGE_TYPE_IS_UNDEFINED)
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 816670562d17b3f46ec2d22d4f9412e42f7e1a3b..d721a8acbb449666941ec19b18386b42c152db10 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -472,7 +472,6 @@ extern void nfs_file_set_open_context(struct file *filp, struct nfs_open_context
 extern void nfs_file_clear_open_context(struct file *flip);
 extern struct nfs_lock_context *nfs_get_lock_context(struct nfs_open_context *ctx);
 extern void nfs_put_lock_context(struct nfs_lock_context *l_ctx);
-extern u64 nfs_compat_user_ino64(u64 fileid);
 extern void nfs_fattr_init(struct nfs_fattr *fattr);
 extern void nfs_fattr_set_barrier(struct nfs_fattr *fattr);
 extern unsigned long nfs_inc_attr_generation_counter(void);

-- 
2.53.0


