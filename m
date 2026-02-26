Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30EE3FD8FCA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90BCA6B0146; Thu, 26 Feb 2026 11:08:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CC846B0147; Thu, 26 Feb 2026 11:08:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784616B0148; Thu, 26 Feb 2026 11:08:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 61E086B0146
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:08:14 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2AC7E1A02FD
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:08:14 +0000 (UTC)
X-FDA: 84487089708.24.5E4359C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3330A20004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:08:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N/iU9fkY";
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772122092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6IfDemJd2MNf/WGrf31oPvRz2UGhOevGnanKtJhuV+E=;
	b=ueuql9PxEEXFy0ugzhGA6yx7I6enMxXbXYYCyi0eJyMfW5wDZakbqojXyqSxY/TzBGlmC+
	C8nvGtuVTJrg3T+2455DB5tDSOl2hFNflPz6Z8blbWbnF7jdz0+kXEHf9TCA8PuvzkhMLP
	RE4+HCHujl01L0M692KY2bjwjxDwiFQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N/iU9fkY";
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772122092; a=rsa-sha256;
	cv=none;
	b=i8LHZpBS+ZJNKt/H2oJJ6SYn6buHg88cb+Fb++36Ox1X+QpwGsJWJO5P4kxokjFfjSQQS7
	2Lbo8k+M/Zc5E2fL06gPpY37QrtgMTYyHamgzj1QvrdYbAkbegmQPhZGkCGKcT0Lv/8NQZ
	QGBokLySBIwrQfqPjN5Ni0ns3x8rxaM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B4BF40B61;
	Thu, 26 Feb 2026 16:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC59C19423;
	Thu, 26 Feb 2026 16:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772122091;
	bh=QVP/A0Wr2Abx3BWIf3M/CTqVpPmV8SXmSE5S4tBQdB8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=N/iU9fkY7C+X0gBA8Fi8wI+B9cgJ3ZSt6kN4EuqYE+eP8vng3qyDWNfsyIhvtKLdH
	 b+b4Aulfg3FxrO0Nm/YcWTCOcXO8KCjAYbQRgQ7mVqFUqT4sm4WDf0eBVloGkV76Qr
	 nzuEqM5tBQz8ltYFpBlQxn9/JiVP72na6rLnacqYsI4nNdpxGTgdAMyZLHYRXq/4hX
	 iUesVZMqUqLc1V+1j2OQrGrDnS19dzjRGvGlWMVyWmletccEF567lF82pATRt0e1O/
	 TjpBPU5Ieg1IbZKo5hjqzncuK/qa9dvo9N2Li7BzU0aNxcuEYodPJfkpyZdtWwQ3zU
	 M4VIYqh/JOBMg==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:59 -0500
Subject: [PATCH 57/61] fscrypt: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-57-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2279; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=QVP/A0Wr2Abx3BWIf3M/CTqVpPmV8SXmSE5S4tBQdB8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0Sq+j7M9feeeWsEEfnIcsU2CbAxEDqyZD2b
 80+R1w14vOJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtEgAKCRAADmhBGVaC
 FVKJEAC5sid11Go6fuJI7CWXgk/4O9Urmq5+faYtXDswS3e3Xney5z3y6yARF5s8jF6mfhgzQla
 vQ5vaTZ4z5mXQy/RAzR9sUFhWtITbMTuDCT5t/OkYsBp8k7TwPqeEVypA51Ep4SVoYatBJBiLQf
 2fat2kabGqKEdxfCFhYZ/T/0dQV3iRAt9D43qR/WxIm6MSoTlo9YHWCG91yTvgD0CJW04McaD9e
 nABf28Ev6HbF1zoK9hLfjRiwAC29acMvnrI3Im5gXXzJ3e46OOwusoMZtJhXXd2agPTunLgXcRl
 +/ycDsR+Tty6dLu6VAPvTR3bnQezZb781kcYoTcQIWu/ddCkKz0VN6tP3bv0JkLuXRGp5oMuJvs
 FLd0RNjIJ8Ld9Cxg6Okd724968ObOXOBed5IGmMNSiyI1onguOK2GPh5Y4UcuvhDl3Hb9B3YLPv
 GQoEkhHN0x/lNXU8GCxcaTPkOHjEdaymP6yleBH4f2aw30WmtBhphVmnABJ3EIHcDVimT+dukC3
 7UJg7jQn/8YGDHpTw5kC/uLPLgLMuwHYtsmRsnrvs61gYC+3Qtk3Y7gYe4FIJx76xaByCFyzY87
 rBIQo95KFdLZQVVKUfEH8H44JnZ0KGwlz9muKgqItA3T9f5veP4BQOKpi5i+iTywd4a4kYDOPcK
 EQzZuVxQyu+fRsA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: 4uugaio6tojfhjn7uc8xukioph9gn647
X-Rspam-User: 
X-Rspamd-Queue-Id: 3330A20004
X-Rspamd-Server: rspam01
X-HE-Tag: 1772122091-399399
X-HE-Meta: U2FsdGVkX191mDvnPO5ykxvKbpfDDnIhyxePFs3lHeh7+oABfYAjDBVWA7ZKo3c8NlRT1GJ7CrL14crX9L8YwgdfsPp443+hcz1pmkMnxpfUmYYGM1frapcWhIrrpU5y8tVtvBOx8HcPTi2cwah4GealFIkZWsGtI5dm/iUBMYeKxfmyX6RZXIpHSkzjt7muHEGROw0c0q3woASuIDMhVWvqI1WwhHeKNGhm6oaTNBBOeFluXiPoKvrrBxKbgklftc948dWbDHglNKgZoOQTJiGm0hWE9PmkkFdeBkv2RJOnsW0DXeSF84pWn3Pz3N5uH4V817QBGUQTzahetA0apuutHwejify4tm1tw5e7uesAZKyrmapvd6V4oLG9KvXJEhoa/V/cbKCKvbA6jkZh0gxWhBhrqs+L8U0Dtr7iIvQSTO81+sLPRLygMzaP38lRECG6uSWaa3t17eWGUWG1R6JkdJcQY5g+fE89RRL1tXRWnwdltiZ16sUlXG0MibxNk2ssIAf+Vd9ebPSmtDRHldDIVvNc4AVg7UlDMPPRCZx4n/X1Z8CPBd3u2p2/YU4TJPLE90YkMgZeH1t0NBkdMRX4Jp2DQHNEvMkB9Y1G41ox2GE20j+BKT8Z7an654FuAXCZ6uG4E06dWU2D+shWFCCCD3NFoE7bu2MrwNT9barU9/lykBlVGjLwCqqbNt1wDjZp5uqBakcLZsvHdRvBperjIxXkyRg3THCUyTeDlw/PSd/0ukduU7ksVicGGl/p3RPSLBlgiy28f5conjtyLqa6eym9LWuSRMJe0sHifptZODff6EXA1GPjTmPg4Ieum7fDQERQ38OAwASVvVdkK6vg710Br4QZ2AgnqsoGAfZlc5gaoSA/kN3aIPmLstDoxGaX8DQtR4GdV9dJCw3Jx+pCYHo5xFtXx244BEIu4sQm2WhQ6Vc3wpJvRwQIe7FV0dKU70WvFdc/bNSmt2G
 CKv8R0CV
 HWEXnsqdEHS7ybA7Y0vNXBewCTcYQX4eED5Z1zi1R5for/sxV51ng8Rv6qCNhBxcfKjeyLHQdgRtqrLK789K9+2qp90rBLsZCc0zV8mGkiWcKpm3THVHFQteVRim+X0LMY3Jyb9CpyEjebM1Rhv/+aXv8O43NuWjPTU4DhCtxncSRulKc1YDEOSgM5ju/zJhf9jmF87kcgXm9CPeDdL4wB+iogOGAfEBhq2XFqzIK5ltzNbazbhupNxn7KqS+pfbW9ocVBs5Fc65lpGdSKpuuN0vrpYQ/EMlgddm6RSBANSP87kVAe7EsSka0bwu+2QoB0YDG64bzicLXu4z5Gi3D/DBERyu48Fjv1yJMi/ue0rKzYu4AwDDCD6AvMGIPw8igaFo0rv/UgxEnF96z9fP1QdA9tymX0U/d24xDraEQGVMBW4rcTir2NRpsXwCPXk7nsoUcXuOhax1vE7dWQXrPQinKDF+kqrtkeqx64QNHE86Gp8FjCrAqhIFx7gBlmZG5xm55X99yq4DbBdXv/cOUHN/tgVC0nKjgj85oji6eojzGZstos7EUIhwPtnU9jduz8LswlTxPCOS/10/DJ5cNalm+F966u04Uh0mdTtRmX5c11g6ahZRCZVgVc/uB9RLwqivFKtjRaeBglB7skdeJjF2giqoDj2iyLoQ63XvuzTcryV5Oe8jFVneoDCZbpMOW3LTdLro059vvT3R2dGPNKKqMb1KfE8jcj+9otqNw5nc+w/C79h8v9wTCbXXFnYfRw84uE9krkWZPgbx8c5+OTuvTWONWolnWn9dSTlknqIi+2HPa/dOF+rseqlJWf8Ague9UxKpQtkxeQLHoQznUWE9EQrgUZkRpKQ5pCU8YtrufTKewBnoRRu5xosYrfaJaerTFORZqozTQDTt2TpJDYpJ6avqORYClshdpnPOr9YuWcjtttoQUTrx9RgpROMHdR2LlGJ+xy+N5fOs0iNbRkMOf9/Qc
 FX/B+hWF
 fB2rOO48EWRdtBWCkKXr8BMcD0euRrapNQBfp+aWqbXV3fLA0SYEbFBxGeOiMeSfsPhh0jMbhF+mHjLGl9Qw0zGudHRFpcWPRC5VUuc+IG7F6ErrKW4KIQOwBCnds9J86s2hCoftApzRe+GtfWjGknrOCpyx9R3YZ0mJQHWS6Z4icKmhLzdlK4zVoFTQSY6TlOY4vNPxICAxd0E7HHp0tnrozaTzC+z5Dt8thTfE8qfDjm4lvXN/++zVBq3oS57NG4Cy4I4Riie95kY/w4hlGDZLy/g2Vb5p5+UOlyafezPGlO0175vaumAVW5kdg+xl+8cnq7kxGSICfFGCjKwqOF+YKe89AOBa5Lcd13BGzbGyYlYlV26ejOAxfjg0PVuPPZY1Ea5+KEgVHNR2KFBvsmLBgyfvrkIJHZYgshesCWD7OSWMIgjkzp5dnAr++SEj93bLcQKJnG9ABxvO3Opucj82PDVsO9Mb+fz4pHxxLeGz35NqyNg8K/I33GsaUT7A0+DxeKWOra2rMmaawA9sOa+ger4ucZM6mnayYcfppU15BaT2V5NkB5X7+gDCM+ylVnadKKe9At6qvI/1hUvfaQ4Y8rw/OOyu5ukY7361KdlbRPVk/jlC/i+U3VyvNjF+Pf2SHVt39EqOx9baH6z84ANAkKBRRL6uzUq9Rt6d7r5vpmBwssq6w8fis07kvPMJ1M3IdtIfkJgbemJji91jyGY7lF4FwWHgLEwcheFNBEv3WB60Sm19QODddAzEkQS//hI/lJeHxxIhBpZJ0DzibpfTJAybM4M0UVxPPZwC8XyjPsm11fcJcMtW/IYHGik00fsfcyCACcr8II7qzZnIdLpqAIIcUzJjZ4MMGQdfTSUc8v4siUYOhs4W+zaFH5+PwmKiXplUbWs2pRdVby5Ey48utBQpQi+3eeehDmEB1poXD1QwnHR6P8JExy0DVUasDtQfMujiHwM/+m4FByNhI6F/yOUOF
 Blkr8dgd
 bF3/+EQgrwv1K4gj2n2E+gcWSWaRMAZmX+j8F4VHekOpnZuktTYUx8k3oQEDZgTgYgtFVS8MV+24OYMVZKyz82HUMqGVI7lbephES6FctZJ5MlUQotTvor/l9YuY+db/v8EhLYo5TV0Qm+HLo4oBQEVyIUPGICdlEX+vNkufPZ5kh/2agETerIOj3uTR/TECXYMaKJJZV75cOk1CE9dVIrFbh7bsl1gXp8xzAFs8u8X1IADOSZh6doqEu0oiXgXZr3ivDuQvzxdQep4RqkO20BEmyn+wvMMi06oJzAXLJJV9cAOmXwvUEtCLN2rp/oL2o8yPTM/Q8INGGEetZN9LnSINYVesur5lp6IfvJEsWDEQtHR9SUTWLfqzV5cM7ve0JZROfAm4QOETkkD+NHqb6myG6ZX7ZQi9d1lokmhdiDLPRyroe2rdi+8/tB5D8LBaWznW8DABbjHyTcFi1t0YpfTK03BbRM78UteYdMmp28DYpOGrGT40j7fAfMp/poAbuiI40V3ywatRc6TV1x7G18+PLaYBSbHRGBLK7WlVcI19rImA+njBW09eR0FwxbFGIJeLBRPmcNYALj3+6Fh98RokRqBACFcM1260nG9tihKj7f+oPiB6ycuuRrgxuu0FsmUl380SQezAYzNdWoLiwBNFNwQNHjzFqpmJGJ0Y+cnUaJYUMeqmFtEWrUQSlAdz7Es+w1qzfQAvTWvR3kD5mn1vXqLdaFRK+oFepm317lPjulAOhTKUkbH9cEU4RraE215OzWMTdNM9N+WR1ohMi8wc0wuidsx1biia0VDeYOglXpTIGRRqYyEaGDACY+enhJC3GpY9RuBtal55VWsIx5K+vrlonDyO0LxyY5FGQAOk+6GIxXXcVCl0dU7Zx3TW76BbYsrrETyeYdEB/aNHIRQV0k7Pdy+l7AC/bV6pzbuzK6FDm+dBjy4/ldNZuG3qiF69FiJkybyicrhmpdf1UnMol+thF
 Oe3UmKJP
 wcquhjWNJT6HGINN2/rsXzwKUXwBOh8uztHgDAeWjOP8HPX06l/K/gCXN140nar+TJ4BkCd7RVzJOOgvshXS5fKuZd2p2R2mLqUZcCp93XcJRQHLMAvfr5V4XiCm2s2j5/nMlL9ANAL2bfy7LE8XzxwutueYQME5BT1hwRUzevzo7n7fmMIcXAN/7KKWkRnqFi6PXxxUx17DUVHsmKByB7prnZdBKWeOE2evf/jCTE3n0V+vphs7oTC2/s8W46YsBar41+2bAM+nwBqNo9QY4mwYzMr0zZZKqDu9YPnNlKu8+AEBEmBTS/qMfPjnT+uacW/EqKI4XGYvkZqSfwbL9YNhHZcnYa6b69CAQAyXlfY2fR9SZa2b9qt2qLTS/71F5kUBG/70smNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings from %lu to %llu for inode->i_ino now that
i_ino is u64 instead of unsigned long.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/crypto/crypto.c   | 2 +-
 fs/crypto/hooks.c    | 2 +-
 fs/crypto/keysetup.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 07f9cbfe3ea4115b8fcc881ae5154b3c3e898c04..570a2231c945a6c649cf8dc3b457f0b55657e0c3 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -365,7 +365,7 @@ void fscrypt_msg(const struct inode *inode, const char *level,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 	if (inode && inode->i_ino)
-		printk("%sfscrypt (%s, inode %lu): %pV\n",
+		printk("%sfscrypt (%s, inode %llu): %pV\n",
 		       level, inode->i_sb->s_id, inode->i_ino, &vaf);
 	else if (inode)
 		printk("%sfscrypt (%s): %pV\n", level, inode->i_sb->s_id, &vaf);
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index b97de0d1430fd6ec764f4a758dffe00263496118..a7a8a3f581a0460537f5ff955bc8b5d30573a033 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -62,7 +62,7 @@ int fscrypt_file_open(struct inode *inode, struct file *filp)
 	dentry_parent = dget_parent(dentry);
 	if (!fscrypt_has_permitted_context(d_inode(dentry_parent), inode)) {
 		fscrypt_warn(inode,
-			     "Inconsistent encryption context (parent directory: %lu)",
+			     "Inconsistent encryption context (parent directory: %llu)",
 			     d_inode(dentry_parent)->i_ino);
 		err = -EPERM;
 	}
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 40fa05688d3a1d4aa33d29e9508441faf4bca933..df58ca4a5e3cb1df94e2f08e3f3b093c33368993 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -91,7 +91,7 @@ select_encryption_mode(const union fscrypt_policy *policy,
 	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
 		return &fscrypt_modes[fscrypt_policy_fnames_mode(policy)];
 
-	WARN_ONCE(1, "fscrypt: filesystem tried to load encryption info for inode %lu, which is not encryptable (file type %d)\n",
+	WARN_ONCE(1, "fscrypt: filesystem tried to load encryption info for inode %llu, which is not encryptable (file type %d)\n",
 		  inode->i_ino, (inode->i_mode & S_IFMT));
 	return ERR_PTR(-EINVAL);
 }

-- 
2.53.0


