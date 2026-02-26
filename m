Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62CDCFD8FD5
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF7986B014B; Thu, 26 Feb 2026 11:08:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD41D6B014D; Thu, 26 Feb 2026 11:08:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB70D6B014E; Thu, 26 Feb 2026 11:08:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9654E6B014B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:08:51 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4621013A5DE
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:08:51 +0000 (UTC)
X-FDA: 84487091262.02.5B43BE6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 69370A0016
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:08:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="geD1d/Cl";
	spf=pass (imf25.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772122129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O9LAoJV9LH+taYO5AwamiyX+EB2QV+KeNUvGXrYq1jg=;
	b=OA38TSItTygSfAWpmUV811/SvKv20o1/btejoamuHgbaiL1x9C7pYfQTgIALwh/AlGHay8
	YsHCEsBQrpuXt6BotdK20smuYp48dyPCYNhywfVU63/DT51xeushNnNIM8s3NNUn8BkgS9
	3FBh0dSIn96pjeOKuhujswoI6+IKfX4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772122129; a=rsa-sha256;
	cv=none;
	b=n+Vkbo1zXj2mHqIjCCDIU6X8rZh2c7AAhV7h4+rVlRWLktolelhQsviDt9ILTnXgvDPTKj
	Y6qqhJYzdaK+iHrlQ9YFP/2HTPcZjqx2ee+GUL4a8roTGV2j3SOv/30OBVotdMw2mJyFIe
	5Dny+E597ywzyzzP0MvMsInS5wQBCGo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="geD1d/Cl";
	spf=pass (imf25.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E4F3C600AD;
	Thu, 26 Feb 2026 16:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4276CC19424;
	Thu, 26 Feb 2026 16:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772122128;
	bh=yMxrwlo1L23M3jdcu34tHVP1Ixv5RcybzgMboES2iR8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=geD1d/Cl0KUpz2YfLhxC/AoZZfxKJA4u9lIBS2HkxWA8Hx7hsjnAbYXEih/CGmRqD
	 LVWTT0tSwjcIL+SAjJSCMAIJwI7Rh0cedz8CQdt+grwr3gDHQBBOp4kUUC5IZh2rCD
	 YozSERTGvmg0Ab5/3zB0bT1WiK3o0F/7IHPNE4/nv63d9pnsI6ho8dTgnAWMRSdwz3
	 7QSjm7ClZ0YiZe6R735Pz+tuGDS9OlvIjxswkNZzz+I7FprQdo4MIoPL8+WYVpqM2Z
	 Al/96Nx23hsJUR/l9PdZvKwm023EifedygUH2OxYAqr8jBPDsnBJjIWPsRDM9vRwnA
	 3HY2y42nlluBQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:56:02 -0500
Subject: [PATCH 60/61] net: update legacy protocol format strings for u64
 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-60-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3384; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=yMxrwlo1L23M3jdcu34tHVP1Ixv5RcybzgMboES2iR8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0TNF9E4LLtLcsmECJBuNkdznTFUOqAaHS51
 /JvsKaS9z+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtEwAKCRAADmhBGVaC
 FVEfEAC1TwV64E1qKBJGckhNYVvwlSnX3rZDmQIxDFcxGZxtVBrVBOh2xoX2257tybZOBJSqjCY
 /Jte1PxTGc4kxiGRavFnxhO0wlYVPsTLoPG94BoDKhz1miBESmIct0tKqcpeXaw2MHdWCplxDch
 X1cRMKR9hwR4/ixDuEsCW1iKfbQNuXMWZBr3BrVhNzZK1xNPDr7dxd9AmAPY1LrHouzZQ1ggbqQ
 rWD41Lvbt3AavTNMr2XWEkgwFo0b8KJFx/9kxmZER1NumwIwrPm0KnWdFiT1ZSdWDFCXY3/sgqu
 Yjw7fVD1U93qqOOQ09+rlcBcw3yDs/8NMx/lcKaZ8hm5z//43tn1RSsUAN4Ya7t7Y9oB394tHbV
 oZdHQoaKvs0HWGmKOSpvuWdtQuyGheZPeqJz808UIJLyoznw/bt28KM+4Lzf1c+nh+5Y98vRab+
 zi7dLUSdsiLpZ4IQqrlDNeeXLj7jGLq0XlBl5h9wpsD/98SsO7OTNibIvHqI24iBQ75a3kAjcvs
 CjOAywQF2a235aopSFuUxa98gkkLPR9m3KrCaCyx2k9QVxmzJAQbpLeHCHmgVKXJvcSgjYeIJEl
 bncoKnZPdp5XWo+5rqsQv3t8nmBbMQnY1qRoz1JUtZeIcY8c4mGkjZO1gWpQ3Fdr3BEinAdwtmG
 zqw5ZXLeAS2FUbg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: 6i9yizxeh8ebgy7shw6fne1adepu1kqc
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 69370A0016
X-HE-Tag: 1772122129-805558
X-HE-Meta: U2FsdGVkX1/cZFpqN7K+UCnjlF4dvPhSA9ZwZqaRbvDQ0/cAgUeYPx12o6AFkkwTRKrNdgupGTYaSPOH+YW6jm7XyIqCF33O/Pk2C4iyGY4Whg8v7QGWM9C3LFNNEEecrZd3zuoPBoTwqN5+KzWzixoJg14Yeed7Q7ahhuBbCWR+2ErEQC4z96g+dlZ9aE3gKHh2YJwBch73kPnWo26yvudGlZBLIoG/+N1J0wKV5tY1d4JSe19Z12AsErF/MWFnPeXT1Q+tKVxoXD6YeLomzPFiy2vqRmQuqtlm3IJAWSVNWyFOyhNLzmSPF4BURSh562g5mG5Yuo4mIzoLurVB9+6TA/mpW4p5Lb5zQukHleLLpU+W+pjuICZLP5/LdVzD2U6CZG7H/t17R4smbdF70t2BmdkWV7ARAsdKdBFuFI3JW+NGtK7fQZoRgf1W77DGY4vcUKXVLU9WO68ACOTNRWVX+6g9cSuLL310mwXzFoBxjEsJ8Ua/v4pTyIQE8oPJa22nUypKP/euebtCRJpiPio2qjqk8dWZXdabnf7g4Kj6qT0SnjRUyzldf5auCJfqLwyz7Ks911QHvtXrHqEbwBsnKMzgUwhLPkLIr9zaw3QSnWmIhM2Yi3KKecF0KmZOomZY7ewWcO/WMJbzhQWf/G6AvmYe7DKeNCMY845RoXX5nnC3+uAhCR2mT55pI3L1RjHI0CN6YOi5dHN4X8mGtJGRktetVmfOGZk6sv80XQtoxccOatQYpMR6I/Nsqy5SP4q+/NSCKYW1DS7Nci2ODMJFZd0bTt/Ly+4ItaCvjC0KEQpQnhjai1Ml7Ezd3uaFNQqhh3DsqQt1rPbyn4CWGUcCJd0S+Dw9MJwhkIw4xNSKsxZq2MLUQDPe1Pay8h0C9TAUYP+mnXTXggcz+q2qM/sQhOB8x8q3SyarBoXwuMmRLtwIUlJnFQNIwYJmwJ6dZ4VMKupRTfh0oXEXrQR
 1nbJwS3V
 8Rq3ifj+bHdp6X5C84xyonZuVzJoi0FP7dQFSTfyRzK0fo7ZE575H3OSKNfpYVMNzeNv/kaDf8qX//u3EePwxH3L82fK8vUIokUn83X9pp0cqYDSJdj9frVCSmwL9HQ+2xdFH/YD6vn+6oM/TvhJyowbxf0iLV1GTAauotY4/V/UGCv9WnduhF2QzUoj6zz9sbU55i3FBhiI2xUH55u23//GqgjGmdGpt8E4HoQ49WFNwl56KLfxHob24PmItLUfqZagVurZFYy1K8hyVPkDSTmaoqojpLc2XUQm8OBOZWcwqSSkYw/G/GII83h90zFWLbL2FwvV59XxAaBzS4btXuBI4VowrPNoBZ9LtKFouY+ekiLF+uicQCl470v6Lw0DBXPtGFJVHXOqceT+A+2amrJ50STPf9EYaBTLDgeO2GDU17D6SpzgEZS+E1P3eHyH+dBPq5kmGmtTEnBNcjqE9WdVxIr6tOszbZ2gOq8fp9Hl/kTbwGOFBa9yZCLug2cSunHleFoM5RoqduB7iNWIHY21N/L+n+7JJHYEqAn5jySDwgkSlUISxMq/hOWEDfJ1dssBxk4lSv/3J6xe8MiPH64Iz0e9l8T0B3E0K69CFJhbp/aWybJ5AtZ2KcaH9ggioPveB6uCA6LWBQKXz+i5C2NvUS/q139Ak+RkYkGoLPFJaCUx6sQIn/LAQvton71kPaLvWDMMjJLNezTNDA/nDi9DtLJkPYiVm609n/ZYQuTn2Gor/LNzRPrSTHFypkhR9JMy1dqfjtVpC9kdqhyHS4QkIm/CrRKwymybXYF2JBFiy+k4GUVh65WZeOHmYQ9lqQeSMO5fwbqgAz7Mk9WRq4ZvXW/LKE7ay3ikRwOt9wCQ1y3YC9rkrN2H7eOUIqwXgUOzFfn5isMJ8HsHgagdSDjpPYTRN0S0MeWmqsjgdac3HkRMRhdCRr1DSE+MhhHP0vPSeIt4pu9d5kWfZtHqsf+r8zt1/
 lP3Nhf3W
 RK1hKQ1IrDVKAEVtCTqUAculZ9EioC/ZS6tYPhIuVnrrxtSgQLmT74XKNMVXMiOaaFfNYRBrqtFBrrrcH13zn9O9ZTJZuiNU/psjpxTw0P6MtaguiWU4JPiEVbCpnYZtcvOHFGewynEAH4W+eAKRqu/lTQOixHmBKlHpltenQwKX9KY191jyzoeLikn9RMgmMVEfnDIE/gBMgIIwqsqemuKmAKuY6Um9Bv3fe7Ijy+RL8+q3ME87XDx1xM3sfO7IQY1S9Vip0p66LQLT/gw6B1GJ34W1aHyInNyoGS8IaPt4ul+ymCuCcfmMQDxy/AqR53Umx4NiIaXuMvXxbSX/TJDSuveVRVwuh7sHSiMDcnBGK6a43Xzb65+vy0t3Ka0ZTrhzsonUZVdiyeTh3AE2Ioz4ez/sStPMPH3htr2CTTdJBVbQYVR/qQgjUW61HvTjJQPw4bqVoA5XISVXkohx34viUzmOpG//tsL6ft/lfOKIqtPQrcFL1aHLN8axQtLsnYQSaIzTHcdLD1wrBz29tFU+d/exEgc0QHH+3QK11Cfcuo7BEfstWu56ZCZEB8Xt+FLSC6CxKQO2E2/0UepvuYvYX2bP1R6SXwP6mUmQcH9zs7a1tfhtKCqvGFoqiXma9HrdDdxV0r2/HSyvfsN4y2YUSXGSMHul6+qbfRWrOj1wr6MuoJHG4+sLMq4Zt6Cx6+KSindA6ctjAOI707h3YShkD5mphRWSC3hTVZ2o9ofz5+Jeuv/rt3geYhl+oCudqWCuZJPtmVDXF7yPIoamKa0xwoFk3XeXmE6J6jaCSUBMNBIBQ35Wr02inV2IELefYB/zSUnAY47GPDQ4YeAUKE9Js1hf5blOSslrxwoK3XrnU2omCONFp9hTQ2erMS575nHCl4Gg74vhHRMO2Pe9Gq/PiSvaEpOcSf6ctUo2i+SUsiliydjy4F2Ew8s8W5Ru2401OE9khwJl6tvWhHgWZis6aKdgb
 0BnV0MhJ
 gWmGw7uweuH76CcRbE/UhMpHl/KsKmPVYJKP747ycysnHctp7B5kaFgjbC4ffmKAszDvnTq1o2FubgXv1DPq7+Benr/YFWR5nlGX8rrlaTfda49flnPWs5yKIvhNA0IUYuZqXnhqkO93bUk5oRze2ILikZvgIGoGpIp7fkTQ8n3MQhLf+DOJBBphm7c6GHm5z2mgKC5elADNZxQ2K+lUQmAngC+xK0n7Ynu8Ju9FdrHSOfKv2oQlXpBCtFSui37VduOpsVviXpPrVjB3LaHWvP1czqVUQwPUX7awV55vBeOtsjZ78hpT6wkL3UEn3DmjSGbQaNxNmLyZB2H/BX0DFjI1n2ySCkT8ZQeQzlSuqnl79vdoyPTXmbh+gB7f+38u7gp7j8bZ9BLbuFvZslkxGKWNDAKT98HxkNe9OhYh0izA20ZtYpm1xjEgCeRRYFn45w5MogguQuj9FOndVAlZsJfOBln7Z7Q2desAvPqEv23i1PZEnDoz8wZEAgCgdeVWtR7/yUtV+z6Ae1ay3XLj2CiB8Nm3XEdFEL1BVuOspS4bD7FaDviJ9neWadYMo+xSnkE4AAxcRLB4+Ui2FH6UvzUmJwpA7xomIYfoAA8Jp1LLQesTfLO6FApgVwn+u4zydZYwV5E+GDFOuVjhCW7YQgkoapUJUWYniGEQlpgFCM4mH9EXJYv9YkCR5oc19cVTD+FkOclNkzSX3f6gI1jFSHWOJjG0I9nYaJ+q3v8ONWdKTe3/HhyKuWSwcDzG2UntJesYDiH3jGrFDficpDZgZrqnttqovMmeNnc4S2HyFOntbsAOwnYoIzVXYthzKRRCdDcYlKwPH2ZJfSXiU1SM7H7TR+pn7ZK2WUMHznVP8xrHLJ+GvmsxIaPhUMlANV0blM/oLKVmo3WwWsVJ35IOttI5RdVDafjFsd+uv7TWJCrfyu3SEcQ5cGfQNuEB4M5EOvOObspJqM1XEvFwTQ8xwj5H7EYo9
 X7DA7NFZ
 bXm/lEzRD0wTSJ0wS1S/vu04IQwGLik2xBIC2c9dZT8spaYyUdDYGipQDEtR7bLi14VbzsCuhYFU9dMIFSxPcqH2YOzI84rNQTdKEl97d+eIYwfJ/9eTmu37qfWMhHg+xDBYyA19rewP6GdkOZ1VA2iPaNwGurbMO+pig5C70ytkCTe7979EU7vqlhKr7dXIjpF4zjceJmnQvVNApJOryaAT+D3VkpB1j9LANp4+r2Ba+ujm2DqRdDDv2p1DL9e16IDS8MyLiMIsL4uZImX1wItmk+4V4MtKsQ3hdJQRFfHTMYd2D8sR4PXIvq5WX39nS2z2Ro4+7NRLk/GSIpeZ5rmbIbY7WzFsU5zFMJHqgsBTytTXuUvI2uf7LYsDmZs4OVS7UGjce9xA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings from %ld to %lld and 0L literals to 0LL in
x25, netrom, and rose proc output, now that i_ino is u64 instead
of unsigned long.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/netrom/af_netrom.c | 4 ++--
 net/rose/af_rose.c     | 4 ++--
 net/x25/x25_proc.c     | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index b816c56124ab8b7e59689e612d36007bb11aacaa..c9f12ea75f2f8f941d9bc2f3167b91608448819d 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1305,7 +1305,7 @@ static int nr_info_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "%-9s ", ax2asc(buf, &nr->user_addr));
 		seq_printf(seq, "%-9s ", ax2asc(buf, &nr->dest_addr));
 		seq_printf(seq,
-"%-9s %-3s  %02X/%02X %02X/%02X %2d %3d %3d %3d %3lu/%03lu %2lu/%02lu %3lu/%03lu %3lu/%03lu %2d/%02d %3d %5d %5d %ld\n",
+"%-9s %-3s  %02X/%02X %02X/%02X %2d %3d %3d %3d %3lu/%03lu %2lu/%02lu %3lu/%03lu %3lu/%03lu %2d/%02d %3d %5d %5d %lld\n",
 			ax2asc(buf, &nr->source_addr),
 			devname,
 			nr->my_index,
@@ -1329,7 +1329,7 @@ static int nr_info_show(struct seq_file *seq, void *v)
 			nr->window,
 			sk_wmem_alloc_get(s),
 			sk_rmem_alloc_get(s),
-			s->sk_socket ? SOCK_INODE(s->sk_socket)->i_ino : 0L);
+			s->sk_socket ? SOCK_INODE(s->sk_socket)->i_ino : 0LL);
 
 		bh_unlock_sock(s);
 	}
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 841d62481048def8d800779efb6e4ea8cbe419fe..bbecad799c60cd74c62f2b2a01909f03547a0d4f 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1479,7 +1479,7 @@ static int rose_info_show(struct seq_file *seq, void *v)
 			callsign = ax2asc(buf, &rose->source_call);
 
 		seq_printf(seq,
-			   "%-10s %-9s %-5s %3.3X %05d  %d  %d  %d  %d %3lu %3lu %3lu %3lu %3lu %3lu/%03lu %5d %5d %ld\n",
+			   "%-10s %-9s %-5s %3.3X %05d  %d  %d  %d  %d %3lu %3lu %3lu %3lu %3lu %3lu/%03lu %5d %5d %lld\n",
 			rose2asc(rsbuf, &rose->source_addr),
 			callsign,
 			devname,
@@ -1498,7 +1498,7 @@ static int rose_info_show(struct seq_file *seq, void *v)
 			rose->idle / (60 * HZ),
 			sk_wmem_alloc_get(s),
 			sk_rmem_alloc_get(s),
-			s->sk_socket ? SOCK_INODE(s->sk_socket)->i_ino : 0L);
+			s->sk_socket ? SOCK_INODE(s->sk_socket)->i_ino : 0LL);
 	}
 
 	return 0;
diff --git a/net/x25/x25_proc.c b/net/x25/x25_proc.c
index 0412814a2295bba5e26f4c95697ef7b7ba5fb34f..697fdfef297826e2dc267b89e34fd6a54f862a3f 100644
--- a/net/x25/x25_proc.c
+++ b/net/x25/x25_proc.c
@@ -96,7 +96,7 @@ static int x25_seq_socket_show(struct seq_file *seq, void *v)
 		devname = x25->neighbour->dev->name;
 
 	seq_printf(seq, "%-10s %-10s %-5s %3.3X  %d  %d  %d  %d %3lu %3lu "
-			"%3lu %3lu %3lu %5d %5d %ld\n",
+			"%3lu %3lu %3lu %5d %5d %lld\n",
 		   !x25->dest_addr.x25_addr[0] ? "*" : x25->dest_addr.x25_addr,
 		   !x25->source_addr.x25_addr[0] ? "*" : x25->source_addr.x25_addr,
 		   devname, x25->lci & 0x0FFF, x25->state, x25->vs, x25->vr,
@@ -104,7 +104,7 @@ static int x25_seq_socket_show(struct seq_file *seq, void *v)
 		   x25->t21 / HZ, x25->t22 / HZ, x25->t23 / HZ,
 		   sk_wmem_alloc_get(s),
 		   sk_rmem_alloc_get(s),
-		   s->sk_socket ? SOCK_INODE(s->sk_socket)->i_ino : 0L);
+		   s->sk_socket ? SOCK_INODE(s->sk_socket)->i_ino : 0LL);
 out:
 	return 0;
 }

-- 
2.53.0


