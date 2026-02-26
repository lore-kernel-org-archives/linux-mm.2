Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DC0DFD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDAB96B0135; Thu, 26 Feb 2026 11:06:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA5B76B0137; Thu, 26 Feb 2026 11:06:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9A716B0138; Thu, 26 Feb 2026 11:06:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95F626B0135
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:06:46 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D22214020A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:06:46 +0000 (UTC)
X-FDA: 84487086012.12.D6A3478
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id AB7381C0010
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:06:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ukakv9X2;
	spf=pass (imf21.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772122004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RosneTh1RPG9RKTlBWVLmYtktO4uQvcocmGJfaaVVeY=;
	b=zORnxnU70PZpgRoMBI5G9WZQ2EBgrVtDsigP9xk5nlYHhPlUZL5Oi9cDa+pzTHhxL8ObVG
	/23Ht0AhSafEDdXbhGFzo2Ez3z2UpFc1vIFQd1xfA7TtQ5qgcvnIqNC3lpWuSw77FD7wUN
	YeLOVNPf+2CrvplFbLKuUqTuE+DaIq4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ukakv9X2;
	spf=pass (imf21.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772122004; a=rsa-sha256;
	cv=none;
	b=UjrjNZCGPvwMxfAFZ9z+gAm2/0qHjMM67UlyulGN7qlEaTZwaKCHWRnG8yI6RkPkslhVmV
	b/GagDvecxXoxPunlrE0km9TitYLfZsIzp0y6YIWzkrfLTm7PDc9O6+cefCTmz1H+HcPzE
	zp9513K/3oble1cXYEHmf/gdzTzn9cg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E911160130;
	Thu, 26 Feb 2026 16:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6E0C2BCB0;
	Thu, 26 Feb 2026 16:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772122003;
	bh=gYc0Qc0IF60tn99IWkEnOHjqpmcSIp1x9+JsJd0a9tw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ukakv9X20AVEnVUF/8ry0ExNB8eKO+pzdN5Pvpw5YQYkLUMndMtoysKXWlTkEh+DL
	 q18/Uw7fUw475fANeF6oKWC3cLpaO2YKq+FVlCByMA/e0hIw94d3YKUrmRWGicPW1s
	 aqy0iUxhAN42NfFlU0FiMc/uC9ev0EPhk+cjvXhVJ/WkVRHip3H1l/6oQn8sTo4PYi
	 a/rIDlPtLklankzn0sqlvmS1cepjqBf5DCkuY7lcBk8VP84ZeUk5joXNIyk9xVu7Ay
	 kn00SrH5Q+deeEiFzXcYlUP7lGWwbmP8ce6MYDY0SJFxlqyvrN+QXetb0UZrvQbFMU
	 OaEGh5hBSKxzQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:52 -0500
Subject: [PATCH 50/61] zonefs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-50-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2078; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=gYc0Qc0IF60tn99IWkEnOHjqpmcSIp1x9+JsJd0a9tw=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0QcO/LxQNws7cy0zU6dB0t3Fak7uBgiuban
 +8qhJ6x6iSJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtEAAKCRAADmhBGVaC
 FRp4D/0aYTGhGam+V2nxHCwT2yLUTYR49OQ28pbNN8sUw2sZ+oxZoVazx3yBFhZkhXNlXT2DWxe
 cWzQScU9k6YEumEve0g6OCTJlZf7xwSpH7sEHoZ6nLjChJHLgGC6Jvc6+tmbMvvaudSB7ihS84A
 TC0O54BIioxmYoJU+yZPplYOqa/T/j1THMHdCbYimRPHcJEqMYyyxWpBHUyK1PHa1ZoMeH63tMF
 J2aqfsQAt4iM3ukbI0otbctQc+etV4x8rQxE1Uvrsp4G/Gk2jooef1c29n8xVsrGCZFgMQOjNsp
 0rdxhE33rvF+5XmOfv03Hrp0J+S6Dk+woEJgGk+iaVv1kN6Qn6vyD3xxo5L3UQzm/DGM/Rfjvfs
 mHOOx/YwqWvE/9qssvbAakwLwXAKYjWVQKP0JXqZ0HcfJMjJ38GuOca7c1yOgbAgCMObFybMhKr
 xFvHCYNZR034WsIL4dFMDoTJsJJ8PWbruGii1YGjfMsSqrEpcKL3nBJB9xn5ADY8dA6n6BJXMKy
 25QM7aodLYSaP4QT4K3c8LLD+nLndWDWRtN9rXvEulvhJTAmfT02PtvKF7HliU1umqhnKSBX1jR
 tHZjhEM2flMJSXXV8hdCLxGrEnbBibdI4ySrjzowv37Ju7OCjOEUzecqqaV0C9dX344pc30Bduv
 5rc+RF6phs1Inxg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AB7381C0010
X-Stat-Signature: o1xjqx5rm6x7uwe3jp4sde75q95segi5
X-Rspam-User: 
X-HE-Tag: 1772122004-972888
X-HE-Meta: U2FsdGVkX19l3cVIDswqmTycPf9YYGSgxkm/HRGCBQcfBD3tWb9M3OOP4u0NIeROL9iYPx5tI7JduVdQZ5ynIwi0YLuqYtUG6t2mYz00vnLAQ/kr7EDcT7iJjMUpQA2dhBXFR63zyOND677NzYJBYJ8euL61pamS7SCc6ITJaabFlIb4ognQpr+H8iRWmmVjYYEu0Eqse0EM2HSINRBQSvluY5HDC97eY+63ktKDTt33KrWTKqy8xdz4m0/iZYoF9+m4b9oM6zRceIPDVMLOdMwmMNGv44xV58FXGTCBknk3Sw1Zn5NwFWoPzZOA22T2FCuPwo5muV29GNqMNJEEROHUKeN0zG3ARg7Eu9NTFTOQlcMNkWX2xUDlVWtbMTOIrXD6GWRUfvxGUuT3ybt+bK5etAoMFwxIRq4vvheb6ODuf6Lo4/fZqECpWz/ANVXtyLSsiN+o5glocB/DW0SDB6/N7S1jbI0h7kfP7uwGYA9jQLZEKIqb/P5pRkkCdKThvYM2H4DZYB+5VmYTxiU01NBanfOdU80QLvgnTAKuKfdrj2J8zv/toHyzQNbk3l9p91gvKYhXHbe+C8wI40k0A8RFfFYCzirEU0iJaoZycr3131cpH9YP7jElmRtWp8DVRBL6DLGCnIByQXIcTlFxlyqe39itmqGyMUu5jyiWe7rASlEsSuQuLh6eoCMPr4/1lQqs3F7EMullrfnC6VV6YS8Ygy4wMsSH+jzvKE60cfSTNw0jJJUpQb9UH6OCT4PbiVATgFlhZYm5QHluPaFROqIryKQE1FqDM/18yL0eAhcLR8OCrkIOC/hexHKv2HdRmW0znyUhtA+Xfi9ntkqLmyCA3gx6naSl4V6h/hOnoUikBrk9jyxYWhJVDa0U36mQcZTnH2wyH0Hj7rMiNMz7G456d2GTp9PkyhU/lk7QniUt3pvlUj0876uJH+JEFeRJLKXYmmP+p4aQdKFdRpv
 cpYid1kd
 +7C1IC6JyxBpBN9MHs4BYBPhJ54aF7HQxuSjkjD0YV1iYSl/c5LTcNTXIAR1lB34LJACvDQbgs2e8zXGe4VVqxRx3W0bdZg+6kdUjDTAXvo9hpXTIDKf8UT/UsByDuPWpR58SmOyv5QtyF0qRX2CAsAL2FgCLuHRhACBgxksRSug2tWLOz4hIKT5P/dr1aCDitQ3xELJAu9zTJRj55QBJRZbSRakJhNErD704njrZ/qyZvSV4LwFCldgiAGugEwGnB9Pqe5ED2uyNPXsgKCrkCZT1MHiOs0oBPG8J9mAevQvhAU8RfYORi/vGCwsw1MfOINMtlH52OhmPZ2d5m462qzAhrINgMO0O0RpQUvSazGgt6O00SQfSwhLW1Xqf9CCSWwVvLGj050PCCFQBgkgf3SvErLCWnQGQoh92f3Dq+Z2fWL37tDwajnjA5poickQ5c39L0NeAghPsI9lBeh7MLkmIkWa5p7ZY+qQxcZCKYKizGVF/9tSU1+UMH87CQK027IbHs+Inqyh/FijXfou3K38xXjro65LWb3rS6GaMSYEMR7R/n4K00JyTgrMVB6Syi5DV0iVeghtIjADxo5mt6vJoDlOMJoVgUCfe1D3bgWgb3UklMYt63Kubhm3NwegPmnZXIVKbV2/GYhRY1WYpLPp9t347OqIFx2OCOBDT6Dgx09pLFv1eLrjOa43jUPUeb9nnwPoQVmecPqTARwNMA3XAbfdReSwmHEazRXrPZ+eyzBiSOajoQKS10F5mO8C76q8tUodeGL+jWTfpotCihXYUfmaqR2ksK36GSP5m77g7H8jXpzvyhAVFHuRSRgBetsqqGJfcr+BQLMBnLsWiEDWF62gqP9yn0gmMc38tZa4z84Q2pdp/ka7UmnJSnJ311gHNm690mzmgFyOCIP9+ThfYEjJjaPXP8UhvLBWpbg4zw8bLPGtoZM7otTi2Jd8P3BZz21TdJ+iuXIgVSI90dniMS5Dt
 k17X3Y3d
 C58A8BUIdS+D2dw2flmkvQF8mg2tJ/lSi9Rzo7JxU21aCybfQWo4+G705pf8uDXc50g+P2XCONGaM3KnL9ntIM7UIJelMzZzPU1L6CchRaGZmXCZaDeXQzgRNN9G52sRHsHeXwOYfyIcKKh95FkGKBTMU1YisfJTLMh9ac7B5yJ1Pvk5LYxNWzrI5hRFKplpTG7fZr84wePbvb/OTYHFP2pHuy4XHDAcLOmWscHE7+Gq7kgHJHpG2gqK4sprArTB/Pa6Y8xo6nPJLOnYE6/L22HAVkuwODybnP3iOfDCZeGN1muBbWa3a1/jfc04MAI/jFT1i9NOmJ42IoqE0bK9WrMKalaVakuqoRaW0PlkOyytUuSrBc82x+GZm3JUChv3cs13lrkN03S7jXGofjlvhOebdAxD2QS8Plf2yQ9PDiArJh0AgeLBZEKnVtY5Ghq83jSet/GUElLDNSal0mrv5OwqFuxj2As3nZdUGnekG9k/vwwEggoDhqOEXRy3W5Hus79RCWzO8twUpkAS0Aq7bZNK0Mx9Si8Mzs+CgWhky/indT350Z1UsyqLzwsmdJsAJKW9bFfv5U88bcKfsgQ4EybRjXGEhj9GGWH6WKf5dVLE4h3dcWwgjrHXZfh/VnR5ivaPb1BlPj2oBaB03tkEbYYr67zsjlYrdDz4z6MSPqTKGC+sbmbD/1LnzbddDPUcQR5qX7MQIaUsovmoZQ9WUJtH5ifb5B789ARSpQx2aoFCO8il5fKNEUgQyOOItqF6cZylE5rDznheMvKc7RKsK/RQHIpUbVDlUtpN/lEgr9yKQz8fSAx1G3yMDsdxH0OMfcRH/9zR4+/ul2Nt0KQZyFGanpyGEszmjbMvejC+7AkacssA8s9gQDZEUXvuzmEsagHb5pkYbwL8TIp6sZphmhm9Z5aOPBIf+8vDdqdxQZXbgBKg/t8ZxpWP9ncfuvpEZpIQgxneqyLHP+cFtXDHnmUh5lzlk
 Dmk8/SsL
 IJi+bSArtD4YR0GIldzWqx4Xr9dOuod9uO4/o/2t09P90wTRFV97kJmG3w8U6VHe7lSB+PTjq2KDnhQMJTBoiOqX2dYK/B/HdnWMThSXXojUCTVMSb9igSrqc6+5GjphF3513aZDdVjbxLN3yNTAF16Su++k2lgEfCtvWnjyyF97UOqMdh5N81gSVglnWQSTGnL78xcXK61Vo83rmiEtIugvBp0Ga4uv7xh2BkcLfMMQCt+7Z1AO72rTih07dbG3I4lvaaOHyk7M0UfGY0kwGFLYRZbZrfPemKHYuXpeofejqxpPyT8/a1u01IgoVGnq79M6hPU8iMrPU9n+KohhUiTl0Q14PPVsu8MwzXv6GqnSWFs0xxH6tgxmgPekO0IsW57+iELVqJ4fCGJE7FbUk93v4G/LsuwbxleEMMdiiTUxyLJATLlwq/CoUqNIWl6+pn0h9SNpktp7bxaAi+0YLGYB//ND8E2IGjRInPlAhwRLqJ0hyAGmboPQ5xUfJsyLSVQIAhP/oGZOi4vbwyVhcIUORF99DHy1ZPIQ7/CGj5n6WI1QBhMKoWz2s7033ZRPRdmjJ5xN+reeM8adK36CM5I/Qul5xRJ7s5AZpRGHpuHa7sCA3EiqfY17coN7WYZdVAJ2cBwYNOoK6FfHKZba3C4+QJp+wZf7kJgbjzkg5U4Bo+90h53m2SO+3Qqmi/LlM7yFdybj0mflUTXm1/XPN0EVX35ZYZh0iL92JV6R0JvMpoK67PptY7EgsBZQE++oEkNZqYt2G3Vb9IQLChxaffasxGtLQaFg8vzdcR4Yq33fIzPcTcZjsSo/VpbBVYhPdlLyOL4J1O9JD9XaP6GMAyQjtkJG7OuiB11yuGPrTCJN6xI475SCTuxOtuoPAgwdTNdXebiZHoxVKA/PJ3oaOhu54sid2+mPa3TKkBA3wt3ld454zX6ODI7NSPXSwYmfNi9nQ/6Hv7sgwtqE2Omi/bRQsc9pO
 KhCjkawq
 rKXDwf1S2zcILycjylAcDAXYw8/8gleFCo0GrTx1iOYm/E4gv/QRVSOy7+3JjFSDyMThjiACgTXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in zonefs for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/zonefs/super.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index e83b2ec5e49f81674bfbb5e1fd2c65add32cda1c..9b646cb5335d0643bc0431aa8efc35a90fbcdac5 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -297,7 +297,7 @@ static void zonefs_handle_io_error(struct inode *inode, struct blk_zone *zone,
 	 */
 	if (isize != data_size)
 		zonefs_warn(sb,
-			    "inode %lu: invalid size %lld (should be %lld)\n",
+			    "inode %llu: invalid size %lld (should be %lld)\n",
 			    inode->i_ino, isize, data_size);
 
 	/*
@@ -308,7 +308,7 @@ static void zonefs_handle_io_error(struct inode *inode, struct blk_zone *zone,
 	 */
 	if ((z->z_flags & ZONEFS_ZONE_OFFLINE) ||
 	    (sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_ZOL)) {
-		zonefs_warn(sb, "inode %lu: read/write access disabled\n",
+		zonefs_warn(sb, "inode %llu: read/write access disabled\n",
 			    inode->i_ino);
 		if (!(z->z_flags & ZONEFS_ZONE_OFFLINE))
 			z->z_flags |= ZONEFS_ZONE_OFFLINE;
@@ -316,7 +316,7 @@ static void zonefs_handle_io_error(struct inode *inode, struct blk_zone *zone,
 		data_size = 0;
 	} else if ((z->z_flags & ZONEFS_ZONE_READONLY) ||
 		   (sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_ZRO)) {
-		zonefs_warn(sb, "inode %lu: write access disabled\n",
+		zonefs_warn(sb, "inode %llu: write access disabled\n",
 			    inode->i_ino);
 		if (!(z->z_flags & ZONEFS_ZONE_READONLY))
 			z->z_flags |= ZONEFS_ZONE_READONLY;
@@ -402,7 +402,7 @@ void __zonefs_io_error(struct inode *inode, bool write)
 	memalloc_noio_restore(noio_flag);
 
 	if (ret != 1) {
-		zonefs_err(sb, "Get inode %lu zone information failed %d\n",
+		zonefs_err(sb, "Get inode %llu zone information failed %d\n",
 			   inode->i_ino, ret);
 		zonefs_warn(sb, "remounting filesystem read-only\n");
 		sb->s_flags |= SB_RDONLY;

-- 
2.53.0


