Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7C95EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1906D6B0134; Mon,  2 Mar 2026 15:45:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12EC16B0136; Mon,  2 Mar 2026 15:45:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F348B6B0137; Mon,  2 Mar 2026 15:45:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF08F6B0134
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:45:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ADC4A13A3E4
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:45:38 +0000 (UTC)
X-FDA: 84502303956.20.CAF738D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0A3031C0002
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:45:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d8pF+XiA;
	spf=pass (imf21.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0f+FPaAjJsTEMdpl9as50SzMo85wC8aIF4RrAro20ak=;
	b=f2eKceqaZSuvWxb485dcmFvvN7evl+mQG9XLMx5DgPHlaLGHKlLI8n8la1fCcEuXOKbD4X
	R3i6VtLlHYaDDitKlDsu1iHz04LpbzR8T0jqUOP9UXN9PwNOPLfTd+TgHRURGHK9xOY2XV
	NmmvHvacLlCm555tx6+zXo2MfIZEFWQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484337; a=rsa-sha256;
	cv=none;
	b=ceNljSW2rZHPKZTPLewnjU8WP+BUoKE+81Zp8+3KLkSdEy+jG188msimYk0oYdeckV57rI
	hiC+zcZkEXxFNmqYKM/MEJjUHekE9RiW0EpbmVyRA8yjLb0naKh1LK13eGNs6AcX5woG60
	IQ9vV0on7+FZuJ4ohDZ+2buo4ioK8I4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d8pF+XiA;
	spf=pass (imf21.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 506766132F;
	Mon,  2 Mar 2026 20:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9E5C19425;
	Mon,  2 Mar 2026 20:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484336;
	bh=GisfDvIMJS5+/ACR6XGt6OCvg/VPhMFu0yCg5/zEC50=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=d8pF+XiAxxr5Rd6pQVJKLalnobSDcbvAKp7+uPSnJED0FReFWYFYpEORS8k0pwIqB
	 YZHzvmCBs6dVFXO9QXSd70XKUDaz3xDROfqfmr/MUnvyxVorS44POhT8CYOWQ2k9AB
	 suUyfu12Q0CGQSNjZPBklFgI3+OexDnF1iet8YNlUt+woxx1CRDBsLOFZ+tPgCyywk
	 /75nyQP+/1HvQkeaSBY3kM/Cx67T8SYk7/aMgkHYSwMh1mmVdGedbXic/WXDRB5Y+r
	 dFGjYxzs4s52/N1vRMV9HBLBi0AVw/P/8Mqi+8PFWvXQz2YuJs1s+DJCdjzYaM9K4B
	 I3bQ59DG2FizA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:10 -0500
Subject: [PATCH v2 086/110] hpfs: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-86-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2692; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=GisfDvIMJS5+/ACR6XGt6OCvg/VPhMFu0yCg5/zEC50=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIG9oWwNKw+7hnDwGQdVh7GuK9QLizbtdRLK
 yabNEQe8VaJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyBgAKCRAADmhBGVaC
 FbDcEAChwPefJDL+u2bmVreu8DWYGyQ8npBbLa81Vem1c4WA6LYCYxDVDGCeAxPXrS6+lAJtZPv
 eVf9lhme77ZJuIjxbm4gZ/zpawMnPWl+qZYybB3T9WQ8KgsWx3sRKvc1csYXukuesFoTYjNNxRP
 sr88BlCeZD+RLp8Zn5n0BOCW+ChiZEubHaHo9Fv/NgjV73ahYqW7bSWN5+q0eykiDClNtvJYhFV
 jtXZA7qcS6Dt+S2V+sR6KOjZGaotQNDH5I2UOpuOpDGTIEMT+GmvY/tR7vI6CAWWFNFRev1jgA0
 Q3kmAkwrBPaWToV9sExBMIvAjTdx2mT3GUn7eISMCU8bXtfw36MLqCav3dutjCOREaLQjqaczok
 d653t1zQLh0Wfar6y3VgjsDBQceqDh/2hj6l/csE694vTuvcjgNGmAtVhuC5VNWcOon3Rjxr0Nk
 DXPWZKevZWeId2Lq0kz+880etRXEeIa4vCrGMGoF7sCbH0ErDMrHNK4z658CjqErRdZjT+yHIPc
 yHVd50g9/hsbvwYD3hKtlw3qCoDQ/XgAp9gLqMGMBQXRGjU2lSuJHX3yXxrsvGBOianeXJZ4/bd
 elCq3IKPa4PKIK91kx4NtdhXR42XE05iXjZyBVLebErmWVU2IdNLEEfu0N5kt3di8z2KUXsusjJ
 g6/cfvTu2mdTqvQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0A3031C0002
X-Stat-Signature: xbza8uccyjar3mxqjixe3swg74pewwic
X-HE-Tag: 1772484336-145496
X-HE-Meta: U2FsdGVkX18kAq7yE3AIH1mPSVhRXkuX5hX3p2vRVy9miKpPaIZoIRYc7bl5E90Zm3Ap0kHefE4lnfEgqc3Mlhe7u7l3sdxDi+bc5gVbj+ycuHxuCJ1O3ieLJUi+bDG9f5V1u+hJiNGDw+lqoQXByP0gVqbTy17IMAxHDzF2YMcTiCzebuIv0PmTA5rhcF+zZhpKO52Qeu2npv+rCChyyfTW9yBwABEwDlyX/tAf0CjskvbS2b9omIXb5U4S23HnsV+N4SUpqiqwJxyAAd6kJ2U1bN18hdR8ewEi2ybhrK/UEKqfkfSQqW9OBSrj0B6ZH8poXpmpgyJWFpRzNC48PHpH5I9zdAA3yxNpXidgRB6ntBlmyLc/WdYwI7C0FhlprZsOdew3odBPaxluNPAz0X8JYs3YxM96rYtWQje0kcGAAQYVFFWos555qKYFYw0MFNKZrcBQUUihSgGAkvN5NxvCmEjQ4VSeGDr5BCZrJrauu70obM2nU8jKFgnWZ0n8jja/F0dqIiws09ma0S+f20bBb1Fx8Cz+KSAXeSQCEoatllwhwwaC8xgRffCZcD9amS8MjE2FCwvV0dhTxBhb/sXHR4TvH/eTtoJHhgbHuv3CejhxE/DPMAUBxd85wrHmrQhWJqlXxV0/weKw3ojmIhGMsFHygAFjFGo7HtO6xm3BD8CVzhkQpU78BGCiSTSNY4BR3anlTwZxF/K2sm/KAWYrA5sXBHZfSzsvPVbuMBWRG8KKBH2Z0t9BbxAHVHbWO7M+Fqz7n2SqK3hq/bdUEknPhyV2Qh00WoBXkThlqPutHfqzWo8rPtfzkciaQz4Y9PZkkQOPKajnFekCEA/3e1/HOdVMJmu4EBEHlN8QBMU/P7UBdT4jWOtBXQDtqwS4mod+8indUeH459pX8tSkwdQel7kSpG5rqLEX4y39/fEQ3Z9yPDIJiuUtB0taHDRSAyy4cIAH/PhLKFwe6Ki
 3tFi8Q/4
 FYukBRVeo5BmzceMXH/8qac5/E+IiwnAR3EX+upb7E+o3f9GOmZnIgDL7w2/S9fgOPMHB/3S+VWgPPX2wA+foQhqj/+HDkSYexzFux/nDonV4uLxfPR66ZzyNpKc7r/2pgDlpjBPJf1EDtZzZb+qz9myw0gO51AJADlLd7lgQRCiDTdNaZquTeVsTAIU5vR+3sUj+G8YLf7IXN75kLHA4YvZyun5MKPTaJ/LlYHwnj8yg46q+3ryhI8myKbh+yBzT/QJD164o3Z3uQdHVQQS4M5VkJNpnMXcpxGZjU9179uCucEmFUC2peBquns+MaTjPEhHMecv6dcpXBF0uBsbL/lcKdsfWGbXTmgmqTQLlF9QKANt6W5/luDmitL48Tu+hbXY+amcyawDH7z1f1SPbmTRVgGG5MXHE3zIERf6DwlXztkUqSUEGdH0tIh24aUlO3ceiyh0l2sktttcMG9INSLufldaVFW32qgGknVuP3yU0VQ8P7clZYRwzgdDM4EIYnWlq3+TW1A0Ax+UuqyRngNVK6MlzTHLiabf0Zk6UdISK02NrqdLd6bri+3STySzuSA7snI0zczrFXSSGmUu/5aqoW1ZGFsHEn4m7ifBs+COc/aSM2/GuFG60vySP6S3aod8mwBLHMFiWmXGrIfgeGLnDBcKlOmige0holl0zc4bhP3WdcNseKqZt42iCVOSch+J7alOJfDTMGXwZLOTwEMyBF/UQGkGiKg2UU+Yp1XHfI4tWTUfUeOhptmxG+lROeBMM7NIzIC5zYSj4VbvmnjP4I6z0z1jySbn7pM4RFAG39FIDhvrVlD2U0dAdaDJ08rIw8jajA8MHMj73dlHNg1DxcgBUII9igf7d6T/FTc9KVUZF2EA6Das2lAfQCW54Lo1xW917XrIYceuy3EIJ73xzSSV7B25gNqvVLjYZH7HJRYGwC9wSu2ZOYg0eUDOMn/mcDf5cKnXgXkEhCWSjDHKtZODr
 lByF/gdS
 7K46gYvtFVFv2QLTMVngrwpGii+Aw2FtZCq1Htg64+PXXoWI3gIvHPnzUIbuSjaUWUNj5MzS2j1R1Y+Z/KTneTRuCGeZwpKMjbkjBzADt+Pq3Kh+TdLr/OSuZwfvWEpo/O8lj9dTcmwofyaGH55WcsMR6dkcfeoNq1nNcRTLHQ90qictoRv3dI3jubHc1x4k8GPTtyNwqv1zEPoq0h8A8jn7r3xXHqRQkjXWbFdVL8YoxHlM6isUdKZ+cdHobFsMIOm7cV4zTt2d3LSKozpxeQ3YqjU6/pVSYd6FmAt6AWiXnQWzNZ3M3Zs1cLunIjU/wuAnquvcHtzgDYPP707+F/eoIDDZ1HxxfpMGtReoSzF7W4tupiHW6LOIHlOhMvqKPWzYnEif0fe6H+zkMG+i4rK5RX9QQSKHrwXFHAHeRSs+FKZdrJAMwhtz8tg5nsQ2LF+AXEI5VHbvvn3zWOdF7UW4PVe1M90dww5wOCOpmVc4pH/M2PpdKnga+BVrv3OwTEGipl+SWsdGqbykDSkl/sGx2Wzv4YAKkWnF4TOLBamwcW7vxiv9Fv4QVKEyBgyhMDrtfj1T3TSnOeDVkpBhL8EbmitSp47r1ZyVifJlKJWwDWzaPD4rBoicR0ETs06I6+hYptCCc9KV9MzPJ5tseyO0SGwtITFLlI92c02uDF2wNGbPb13fkLE0duYORO0Jq+SWPFX/zh37f1JZUl4q45QgXtpJMgple90JBIU0hpw6CgJp1jPgR/M62rdNSW9lEzCXMf4NH7YFHOIgPDsw5mMo5lnO9bER62rXkYHYzTZXk7DDT9S9nnvoE0Y2b9dveEHJ1NudKgP7+4HDDUHCXAXjKSgEwyZEpnhVCVtRl0LTZnNq2g4xVN4D5eQGIWWKu0LouRCsUDyM62Pwg2Me0pm3oo6E51yOvLmp07TMnY1MFZfVyxKXcpRlkTR2PZYeKTkC7ihrhj68ktvoXK11ePkxPh5qW
 Xd/RcE+b
 FaCocU4CJnlbBwPMgrQBJAcrh+adp7B703OpIqVcx2YYTe33iSdmHw0HPIxJEB42KziKhGOp3zwNr1nuPfPHLZHxSUfnG9F+n7UrnK/OQSirA9Y01Ka3j61rfgty1bCUBV1T+yBZbuR2xKO6b+6T7hu2O0hVLO+s8N3Xq7H/qAFKUkBrG+rCsxUQa9IrIA4DecFkRxg4CFM1qyj7xMlWFFD65JikYRiw0FYkB+zIzkcz/hNn+h41SWJCJvdYpxlFFo1PjN2sHBKUB5NyyxO11liMzJ/Gay0QOcvamKiT+Q5VirtpEfUbQsvsFKLqJOFdMBK/ZYOnOGT5JpbJMMdYBpXUuxLLKsf67uB+A8kRxzhRO9BqEQLwZJBxk2XXM8geJmnlvDnBsHdx7GiGeWH5ZTUSI62QfWnioky7KwFVaZySOHKd1klANycMJysZEqoaw7dM9k/VrLCwnFV6x3+GnO28cYeeyOUKhGOwBX40zzibOBqeEiF1herbnqtkXui+qR6m3c4Fw084aXgz62w7rxxmSxwD87yQMyun1LSYseCqA51UFf+r6ZXpxtMIGHgcBs6nN305PD6N8lKqznK48jpZXMBS30cExsEe3aKP2zE8gz4unNIZbJEFuea0m4Go6cApwiZ/K4J5xQXmUUAgF0iCHjb/umFfE5SEb6IyYgHPDx4lpRvaNg50UmAPyHQhJ6VfO+bEXOY/vNYk2yTBQ2lKG8C0J/3M6ZPKqmWw0HkB6X+uFKDGZW9EopM5YF6RFiYgu4HpUiEzTJkXOzaWJbRiJrmUxuqSI1UoFrn+iCEAQmEm5BM2bnMkZeXzbxtGvc4ETjtA4nXUe5uKATowoebu+x9kF6rMPcu9lifm5dRvG8JSCXdpEraq2N+IIgr43eOhz24/nI3VuSgQNNIE4fadMV0bkkLWjizqA2/OLvcg7QNiIpQLtg10OskYXC1E/MX6w9/3yAMxjk1k1j/DSaDUHTqeO
 /0+ZyWUJ
 YzdJyEtDLBN+IPV74V2pZw1hFJEn11NswuNydir1TveKniaPt2wRoCfaMRaAKeF6Jiwesy2/FEI9pfvDMuojAkl6Z+XqKABBD1nqYEZHaAe7vFw52WajDXkU9nXTGELZDL+NstGdu1Tz0JOKnBWFltbtO3dGV3xB6V75MtC0KHJJ9VPObojOyU01NHNdHBZEPuObe3RbqM0KoypBYu6vpXtB8H99lKDeG/IWgjizIQCoExGjW9NMEwg3+8GzEfB0wLi4EEVgeoQAEaZH+pxao2SvPb9nEZcX3LFQ0tm5aTneGjS9GYtG1r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in hpfs with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/hpfs/dir.c   | 2 +-
 fs/hpfs/dnode.c | 2 +-
 fs/hpfs/ea.c    | 2 +-
 fs/hpfs/inode.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/hpfs/dir.c b/fs/hpfs/dir.c
index 9db0e7a101c2a8d9cc265c14ed74c58533ab31ff..3bf11202e2d3c585a3f1aefb5180da82fd7d4a3f 100644
--- a/fs/hpfs/dir.c
+++ b/fs/hpfs/dir.c
@@ -96,7 +96,7 @@ static int hpfs_readdir(struct file *file, struct dir_context *ctx)
 		}
 		if (!fnode_is_dir(fno)) {
 			e = 1;
-			hpfs_error(inode->i_sb, "not a directory, fnode %08" PRIino "x",
+			hpfs_error(inode->i_sb, "not a directory, fnode %08llx",
 					inode->i_ino);
 		}
 		if (hpfs_inode->i_dno != le32_to_cpu(fno->u.external[0].disk_secno)) {
diff --git a/fs/hpfs/dnode.c b/fs/hpfs/dnode.c
index 5df10c82f84ca40c4d65b97b6c6b61ec364029b5..8c6aa060fd874ac9ac844268b016491204d978fd 100644
--- a/fs/hpfs/dnode.c
+++ b/fs/hpfs/dnode.c
@@ -550,7 +550,7 @@ static void delete_empty_dnode(struct inode *i, dnode_secno dno)
 			if (hpfs_sb(i->i_sb)->sb_chk)
 				if (up != i->i_ino) {
 					hpfs_error(i->i_sb,
-						   "bad pointer to fnode, dnode %08x, pointing to %08x, should be %08" PRIino "x",
+						   "bad pointer to fnode, dnode %08x, pointing to %08x, should be %08llx",
 						   dno, up,
 						   i->i_ino);
 					return;
diff --git a/fs/hpfs/ea.c b/fs/hpfs/ea.c
index f4fce87110d77c6af47fd45e024fb913c09e82f7..4664f9ab06eef3795b33cebcdc57e598cf83b0e9 100644
--- a/fs/hpfs/ea.c
+++ b/fs/hpfs/ea.c
@@ -245,7 +245,7 @@ void hpfs_set_ea(struct inode *inode, struct fnode *fnode, const char *key,
 		fnode->ea_offs = cpu_to_le16(0xc4);
 	}
 	if (le16_to_cpu(fnode->ea_offs) < 0xc4 || le16_to_cpu(fnode->ea_offs) + le16_to_cpu(fnode->acl_size_s) + le16_to_cpu(fnode->ea_size_s) > 0x200) {
-		hpfs_error(s, "fnode %08" PRIino "x: ea_offs == %03x, ea_size_s == %03x",
+		hpfs_error(s, "fnode %08llx: ea_offs == %03x, ea_size_s == %03x",
 			inode->i_ino,
 			le16_to_cpu(fnode->ea_offs), le16_to_cpu(fnode->ea_size_s));
 		return;
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index c82f5f7f435a1a6f6c26fc62ff0c680c26c9f4ad..0e932cc8be1b28353cffd8e62e26f77a02394edb 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -250,7 +250,7 @@ void hpfs_write_inode_nolock(struct inode *i)
 			hpfs_brelse4(&qbh);
 		} else
 			hpfs_error(i->i_sb,
-				"directory %08" PRIino "x doesn't have '.' entry",
+				"directory %08llx doesn't have '.' entry",
 				i->i_ino);
 	}
 	mark_buffer_dirty(bh);

-- 
2.53.0


