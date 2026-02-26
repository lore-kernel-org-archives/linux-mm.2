Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B0B7FD8FCA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D95EE6B0128; Thu, 26 Feb 2026 11:05:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2C386B0129; Thu, 26 Feb 2026 11:05:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C18586B012A; Thu, 26 Feb 2026 11:05:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABD2F6B0128
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:05:19 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7815C1A030F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:05:19 +0000 (UTC)
X-FDA: 84487082358.22.07EDF05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 82895C0014
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:05:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XWjYSLSM;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/bqZUT3Ncs5WVtCc8ZbAvwfk/TLrJoWKqmzHS/YujHw=;
	b=xPpGAskHY7bLMXRjLcTuACM8qkKRdZk8Ideunpz+jprXYW5hfC1bkaekpa7h93EGsfajmX
	EavjDMg79oN8sSfkluFqZS/eT6Qn1cv4G22ilLYHWXmcPUh3GNybcF4u/i39vBw0aUe4XN
	FHfIOWnU8f40Dfv/dPwJezN4FexTKBk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XWjYSLSM;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121917; a=rsa-sha256;
	cv=none;
	b=eQLH/vfbhkp3Q5KxiAktBDzhIHsm9uVFxfBf5AnFjCZ152EN9i5LacbNY4uO0y+a2OLFwe
	7XJAMnGziJQ3aoN6hx23tP89ly+GRA2vQdXNfKr+WPUq5r7EjPRzRw3fC78Myj0G1B5nra
	OeVEMhthvAHh+fkG/RQIFXQC4DFbSNQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9480A4016D;
	Thu, 26 Feb 2026 16:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D351C19424;
	Thu, 26 Feb 2026 16:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121916;
	bh=+pnQ8La3nnL9HS2EVrCQAp5yF4hT3O2Rul83Y/lIgNA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=XWjYSLSM8MNgl2VhR7assRMUrmqUb67e41ZpF/HEp+Zl76IEXGuo46t/ehib5cQBv
	 uRggDYTAjpxRBx11gOz/2fJIuuvPmvuWkGTu4obykRoSb55b521uUBDBAJswshCq4W
	 FfDbrXkqiC/VTfVNiOOtM2Qk9HmR17AeneKUXOsujG21SDPDltVV3jXMryG8Dqq0S3
	 CNLLXVe9zBwekQT5q9/s84LHJKckbhBy3ow41/xdmP7c4idOzDAmUTPdcE3RIx3GeP
	 e7Meln1rBS/c0NKNAiubURo9NOegQGPt0lDuRM1xPOAwg6pJoIOg3LVj5p1GWs7TqI
	 mo+zGjUGJSrTg==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:45 -0500
Subject: [PATCH 43/61] orangefs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-43-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=790; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=+pnQ8La3nnL9HS2EVrCQAp5yF4hT3O2Rul83Y/lIgNA=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0PbsKa4p2zwoBYu+jpKVGBywcC4wbxn3Fv5
 QY8YgoZQSCJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtDwAKCRAADmhBGVaC
 FSAnD/0e97/yCaqr7LNCmzcAr94/eBgG3Od2/vIhcgrO6Zln1dxic8+5A7hSqtBdq4KBmKHPaIK
 pSBT53zlzsY2pX1f4afF8oL6VmFbimSF+WRZCol8xpgAeupsdciq/ixwa+AIh4Rgh29o435mRiU
 b/KwWh8/b4A1jZNF1tx01xtGz9WhcpFzM6Z5NN43rsmkQYoEk2uznZNsFgN9u4eQ2JbFnUAhX/8
 hfwulzL0D44QxG3vVr+9qsNnBQAvFMZV08Ll/ouL24zfpvmhYU/rfF2Y02YvUsho6fDu5OhyRa8
 nR2Ffu8KMbSXuPWda5b1asEmlVFPpNoWCl+uIflVF4u+PKmpZwkUtOMN0vCJoGq8YPmtd1rNBlk
 zxU1iNqHblPpTDeGveFLkrJ2cWNCp3pTZ41DuCcsaSaFK+Ynke1MerNc6eCOkKiMbXTpNUiK4oy
 hv+0NIr/Gw59YsdFgdQvGDqsqIQCxbZDGYg10dRlDMJB664nqgHAFTQrXLUXvseIvgu4MX88LL6
 94xFysFTeAHGFompkZj7dRrr48abb8itvzdfgqgsfXGpb5zhn1AnYtekOJ5gLNQz1KW9uLk7jCt
 D5Cs2FcilYhaHSUO/iap3WkBQD1K3hmMvKhUJ6JDw9qsBmj6DtT445IAMGtTNn9rTeDwVCI+B9q
 y/+cbUENvzLt/Rg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 82895C0014
X-Stat-Signature: 7479a6qjttkk7k46cqghu9k4h6q79pfw
X-HE-Tag: 1772121917-373259
X-HE-Meta: U2FsdGVkX1/9a+h9laYxf0TdVYA8idxd7OFUwS2jd/C/OSVOsKuZfSymxaY+8kYhMPOdw8WSoDsA4QQSW+JKO9wxhFcxqkQyb+lBOX9oJkjJgV/3Jds9eNxhQHYAOZaKVx7fsSpebmRSnw2aW2fndS9EOhMfRWyrUMbIbU+31oOVB2zyPFVb1SvbK7ziY9qtwht4nLS+m5r9aopEaWniwgguI5Pfc+UhCBjzLeJoTKe0kIL2YfCd5nRWLll+/lHoMoRbxi6zb/BZ8WSTfN1QM+yExUw89QUPtNXMgYLJ3/7DjqLofL9L0LyUkjEoXBLLLdvGoW37trXlvyoE4NdrdFt/3BG0srfgvcrKEKK0JnkhUOKzJUBeqeOWujYBSUkYGx5ZLlVkxkLVFiobDCdQMMn84eu356quRwmx81S2PwlKlRDLXXjPiGR6Zb54Rg1iV0BA+U+2W0KdzUNKxggwPxl+dCmiMYjLNhBWqf4VJHl/cpbNluMe71/MtftgixR2fGh64dzH+QzO3Kqt/dyVPAboEidNmGtLyMwzs4+rE3bOfsoB8XKoZOaaBeVmLb2L7Q+7RscGDWOdhk9VL8+GmkFISpb+QJ4duIsBl4ApxtkMe6xYKHBPp2RWY7H670xirYgm939n6zVFwcuzKQHPd7WJEQgbioiEUROCTcxL1FC61g4oMUs7ktJtpo2Y6mdzzU5x54X1OBUOVSELiTY/4dJOMawyEJnqJGjuGvOavtP7XzSVB9E+dICL+2e9PRgu0T3sRinoNfCUQDF/tBuFPLQBxijFrUF2QGMhNCcVrCE8AUjUqpwNLYRkwsL/dQjAjVZu6B4irmWqsP8d9ACwam69dT3ZTr2iEr5f+/5usi3wPbvz3UxhuOijxKtCwNF5fVEHgbdLo1aS/46Ov7UnyHPx9EZmfWe0K596SJSLJ5z2jGeJbbg6FR6pzHK/P3GOFe9/TLnHNQiTnw0oBbx
 E0gZfWSx
 c342l1y8RZ7PtD/l3WmULTWebJYq8BJnnsGEQNivYBOwxaA9nizP6f60ApgbHkTkexcCTsNvQMOmFhHjcqsgRYk+iVR0QJdDGjCeIB1wnAi+YAIqWt7Au8NZhQnO9mjfinemNG43RAE0m7tLqlCyvPB3+5qNn9t1lwkKBS0+A3eBwEtRnTBiRdHi7T29qgZTtF/BMUeHAHN1AZiVXzVlP4z1/h+ImhTd/YZdfoQjJOhloCs+bBJfwtxrxoqaQFFn2cnwDI5dzcTKbvy6DiULyRbLrg6CNHvhlqdjJrlq9AUG2jdXkulBgS2XGAAWZ+YoDDI/xqQGR/vVCK/rQIpm32+cZADPeZ5UqR1pYaqP3IriczWmEAIG9OWsCqp3dP91Qa/+N3Te5+U8kqAsm7SI5JT1Tl6SP6WNti63TYHW6xkRYr9rqsDggrd73c01zVAWfdEmtVzanSW48ItErCMcaf857CqA/8T2YvNnAmPWKf/j0NfgpBHH3qku6yo2z2gQQre6QkcRRzQJclTlZGuQmRnh3R7DNpljem+cWTw5f5nX0bdW+r7lBE8pvdYthw8HaGGBHvXXMfwR2aJyzyXYOWjfIrXEDh5VHEFHKTUr6PxG9zddhrpMIsKSRhiaCG6oDdAt17bVkSvDLZf5YGNE2bKejcHPLGewUKpDBguxPkY787g/XhnIxh9FyZj+wg7CQbRfdWg84Po6RVLlxGonqcz8gT2BccTjcuhsaV+CvA9Jj6Yt/FcW0v9CKE314UoPD/KdvYNudjivdmQrI+W2rfR2sH6w1iOtbV4XOHkXnYG+0thvvp1PjhL2zk3p/LFcOMv9A1konhZpFCholwELyJ+VB4SkOYdnL9Fb21GaQ1UikIwpz2QvswS2l3DIGnz+oa7ZxIYbZN8wGZOEgI3V1/Yer9wqz+WPpexhPDIWBVfJEk2b61nL7QRvF1Kj08qyr0VU4MwNzF6c0t/f7N7TPhHEQ5o2Z
 uJBLoX4c
 dCK/VAFaETY8teDAGk0V/vs5iqg7wlKHuMo30l233pTWciOQZmssydOhbM4JcuBnbEm5d4WMC9FVJnSP90UDi85bmZzxI+04N3jB9dgeyzWz/O31gj8MIdz35c2UPhqd1fWLHoIfwqHwkreq7cR0uni59+3c6qYMMzZEEqylzAwbIbd9p7BJ3zFQKomEqIPl9LU3apJUc82LmqOzFkxJxRimQcXACALVcd3Elrlql50tfz0VFha9G+cFL0Q5MQ7YRIsiVt227HoQI7oM9a2b3YpgjZRGH9UNdwfX4XTWNTUF092Nz8BcabDKAtXDBMhrCqmQ+eVCw5Sqkp3qjWMbRxzyOKpvnAmCLJ11FaldIS3aEvmQ1J6VIyhZjm7Bd5DWk1L3Q1ygZFXve1wGAsGZcyhVmGspOLGfaEIPH7IdKp3wI0Arz1xDnlLhk2y7dRI6aG77N9Me8r7jB9hSuGvxTkKIv3utuMVgOkQYluBOFgdQgbxkAjAIEf5fiWFiKnqUIi4/UekNx+liYp8C2zWfu1vnV8AsJ5GzDswNs68d/MEu5ApmWpVaUqy9cY1C1TVYf1RBzn2reLjEb/B5ubMWxZ4DftExRJMIjvBdEQ+qOHsYGAKcQ0cKFIfubZB4XCH881Nh2iukR73WgnqjPot+mmmqvrtampP3WViKCzwZaxjM+pjOz1ape03+vjz3faejJnzIku3iUmrozz4x2tFz9p3ed82S0sChsQ/fFp9P+2oDWrEgLYupk18NrhwwKl6mAhTzePVIHAsUUGDlRQKdz+d3tTz/Y0xvKAF77MTKw/XlmyEfwYpTN0lenwPcO922Yd+ybotctBxanaL0Gluln4qmChBuRH5xgm4WuG/HzFadTgrRycYWSrEW9g+VeE6BdDPeSA1FXiT8PqpwzsA9MjNcnI9zHseBF+s3tuPLFCdhjIOLCbJWZwCWV0c4gyZ+CVtRtuhjd2pOtLojEfN1tmN1IPe9C
 5KE6u3Z1
 RtJI3C+wtQP/59hXU0UU3xxRdfeR6wCIuT6vap7MicGfx9LH7cMbVRw+OEhD1hp3l/meAepIBXQ4VleHnvLJIIGRQDLFGD3wP1UYFrKh//vvryqeatrmLwwkYHVp1zd7Zg5VaR2Uust5oueYPqN8HlR4zxDERHnaohod6VBYosAkSwZD4fBiJrWlicN+blnI3cIuxjRKX6VsKvKljKYHmPW4UZ8qB2ZSw8iL49KeWxPq34Z3zakRHax8Pl6haiqfJwf+r8gsacd0sRMwcMVIS3YVvG/0N9iEsa/oONvHhuZ5YEzBHwQ7UNr9ageQJ3W2qt8+r6JFjHMPGfRkOOn3xNIpBl5G/i7hUEW6+clyANt8x1cbDNmoWbMDpLtffA6nHfHAbjcpnER84dgpFejWBpzw+Orf2/r2by00VI0jsr6I4DtivPq7Q3k1tkFwfxdjYEDdvtN6Sxl2Dww5zZ3P6pnIo3IfS5CbgPpndz95VrqNXCzifjNyO9gtHUDhvr1Zea9UlVbCYn9kzARWdeDIVKKQVKDD8ZlsNttxQPHcugZaA4NhCxxg7twldcsW/9laRwZ0ghD3E3QUfGnL2xzC6PDbVAr0/0JxIjxM7UFNhknh+DN91V8M9eTVnGxoRCTsAD/vHOlJ3BOlge8hWimaxjyOe831BLNNO80S+OIlEiLc55CcC6xKwj7T3fe/mxN33HwvwYNA8HG+06V2Taj0EQJWGHNusMbNQHvILSzzLdhvXmRXpEIq8jRP9GKytP8har4AoMMEXZrZLxhYKrVp7ueP6jsJrtc3RsiimZXc/cQyXiY9ZvJ7ZpbAIqF5e7YqTSsTPIi61B2gQ8ChMUl2X1BPS6oyjxdOODcHOHPQY1PnShlX7enoxoP8jWC68HLzwp3Zo6tzsxbTorwnejvAshoOhk1/JqEzEhf22/nK0CPb9eN9lIW+TRvIStsyNaAAwKNDJRonv95jj+TLflnD+BbygbXbD
 rtdZXEDV
 /F0SrNu5eE4ygIt7f/QqdhXZRVnqhZd68axhxsfDx9xnbvLXjN/pcBvwr8UaNaNn5m4qQf1fxwOEZwXQVBVOREmYwPIUn2hRPUBDQjwSzYtCUG7x3kEAu1SsOqqfSsfgUlAJYj9KeUKTEDbSjEDndx/kSPH+R7+/zKqxyKMCKke9P79dASDlPKLZcH5bkwBnWfK+RUHOxbNKFZfyFmQaovPiPZumxTLkdOUaMa+IhtsMnrSmsA8xqGUSxHgS1m9tXF/ayGLEPnc5WULYt0kqG2T96DUCrNXupjTknT3AEPQrBk9fJZUa/gIJLzjJIhlKiPfpvmXeKxyClKHAYuVbI5ORWeSwc5Dj3i3WJhSI/NiXzl46t+xKRqtdPl293I1bsXr7izYUj9bQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in orangefs for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/orangefs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index 2d4710d0e05e195855186c6bedd211bc419abc36..9e8a2a9e5229861a4976d67483a0f6452048f86b 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -1062,7 +1062,7 @@ struct inode *orangefs_iget(struct super_block *sb,
 	unlock_new_inode(inode);
 
 	gossip_debug(GOSSIP_INODE_DEBUG,
-		     "iget handle %pU, fsid %d hash %ld i_ino %lu\n",
+		     "iget handle %pU, fsid %d hash %ld i_ino %llu\n",
 		     &ref->khandle,
 		     ref->fs_id,
 		     hash,

-- 
2.53.0


