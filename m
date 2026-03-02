Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 378B7EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FB746B00B1; Mon,  2 Mar 2026 15:35:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AFA16B00E1; Mon,  2 Mar 2026 15:35:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A4F6B00E2; Mon,  2 Mar 2026 15:35:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 757196B00B1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:35:36 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3CE638B37C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:35:36 +0000 (UTC)
X-FDA: 84502278672.26.E1FEA17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 85E52180005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:35:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m6XxlkSn;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKQrZw8NJe3RPm8mt30+0dYla0aUIAr9QsjpzKYuSFA=;
	b=ItaqPX8AmPefuvGNHaaPJAcd84QZmtsKewkVaPbDWTTNEeq0rc1G0VL9/z+3BPbV5C53pT
	0S7Qrfkw0ga4Oyo0guZ7tZGPaO5XJZBqltOrJsjsJfB2K/rRsch9cyL5wmnft6Gx4mArnY
	fgIRF+zyoS2vYod2laJqMdRwqJZCSb8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m6XxlkSn;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483734; a=rsa-sha256;
	cv=none;
	b=M90KxjrKpQP4HUAv4fn5XB+M/cT+IlQ4EsOT+UVAgquLmxkMncsWF22ck4QEb1iy/6wtLK
	B4w40ar218soNLBv+/H+fpPS/s2HQR5zg9BVG4ne9kBcC6whMnlECoKSlgOqtwkBIbEK/T
	u3qkaDchuuezXUwvUlYB8dRt9JoH3xQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CF3B261340;
	Mon,  2 Mar 2026 20:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370FCC19423;
	Mon,  2 Mar 2026 20:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483733;
	bh=lWf448UGMXudQ8B1VgEJeBVXqLyKfodUZAp30JCf+B0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=m6XxlkSnJTMRJCps7ybYdo+e7wluY471f5jMMgETDx7npcxrPLAAS5IAXfL0Q1Bh0
	 AFbTzA8T5oZoGUBvADEJ+0TtIFwqCTsMPnCXDZfNb9CP6RyWsP7+iak2VmcSeeQtJd
	 7Qy3+CKs1MtMEbsMPr1F0beOUXYdPwVeqUf1wYmmKsJNSfwRHCgggZL5ZI/by97IEn
	 8bDM32GpFRddFSyIOTmaVcdatrCXwLkkTQw+2r73pQ29Zz71+kkNTyDKK19sWpwaJK
	 psE77cE0SOjhDV0KoqDd/l6+Mxm0ag25Asi6akNMiP+seLYsk1tmLs/oEKuVBmYMIk
	 nIwUF6wTPvylQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:28 -0500
Subject: [PATCH v2 044/110] qnx6: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-44-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=871; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=lWf448UGMXudQ8B1VgEJeBVXqLyKfodUZAp30JCf+B0=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH6kEu6DiAEc02xSfhZdMCb8Qj46n6ykbtXd
 mVp2VirwwyJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx+gAKCRAADmhBGVaC
 FSnYD/wP6n93JAu8E2arFdXKlOQCAJY9cUuf5kcncBbnxHhRensERQpBumPgpB04J+1nSx7rBAm
 /2vV3AQnI/ynCCWL8pIw4l+4TA+RAb1ztfS5Ly7z/zvMK+CoRCNSW7Rxz4dn5cWUa4OJZfwUFyf
 KcMOZMSD7qugW8mpKWGM4SaZXKqkn6V28hJozNSEaMlWYAGKeYyWJFK0Jkk7494Mxg1hdPOngdc
 lPIBjjiVRJyc2dxiFRU5rizVE0AKeh5k+hsFpEMqI4u7DBu8r6hlPl37be+qaEE9pfEFeIN9ZJL
 jqLgtwAlraAWkTe8D24n+gSsToh7T1OXHsQMlpyjsfLr2kFpevlFER1w5x4VPssHRW9M+kpjbHl
 IAIL4/TtRITSw+6wP59km9nZbH2FlzTHUjGjIfuaCR39IEd4psQfZrPWfWv5YlWtCCbKEw11SVS
 3WgZ7hc904ScIv+9gl/gDE6rR/2wDStlnosPb0UtX9DvLxsegVCbtiefzKqMOlV0jzhO6vQnRMl
 31MGnUmRKqP0duwCsima+30F+GiEaV7M77rtX6zJB9cp+vIZRNbg5mo1bjc3JJYTO2w4jjCSj2o
 I+SZVhs2qMPVG7CMYSQsXaT4hdS5hw4vOCRGHlYoQ9T+0PWs7Nm231bg78BdK5i+rDpMhRwJGNj
 OnzqkKjiDqUG84w==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: ogf8okfqfquhjh1rb6xkxogpxzmopjj5
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 85E52180005
X-HE-Tag: 1772483734-62442
X-HE-Meta: U2FsdGVkX1/aLYTv4m4gCTI60EYTN7PK8FZxmoYy+owE5MlCIsEGz1FgJk4xMt1hCaDV4dEP9YAayoSwgl468FBenz0n46vlbqPtL0/N1UrxVkKe9hQkWxqmQPE2kxO4ClFTy0o1GUG976+p00RCOfdH33DEcc5sjPydcdVl080e92oUzv7knGWuef8I4ZtJYbsphFZwZtDDJWt4Oe2gaVezWI6TEcC70SZhnAyxVKmTLA96zGf2G/c31pqgtenzQ9eA6ibpeMLEmcOgTDzlaSie9ToYjSoLsuao4d0mbvHCSy5JFvGLuqqGtrpEs+IBC9tiSJrRVk2dXISMhtPD48t1eyVTcmCbGU6FfvZzTUpTAmh14j5chlvUWTyAIu0SJCJZr9hULaacdhEBZkkpHZxz5YORDzWD6DWHyzbiy7n1c+x7yCFZXpQkOy0L62vrvMIoRIdoBIIgAFZV3C54EKhSDKrlcVtrZ574r5sUvcTCxsgP0lLfn3fe8wejTGx+OdUzWxlQ8E3epx54vxe3MeejflD9QnsZD9Qreuwz2ThPsAdkahxum+dH2fC6KUjuoxCf0/HcgOSSpft+W/46I20r/nrd7833+eO2HPvWGlih041L+vjJ5gYIGY2R/z3Y9Wea+sRAtKnuyF2qLOoXoTVI4bhNU3V2LlN5uLpf/rKx1MM5MsyKAKCwmyb9l4+K1gbSwOGKnIqRdjq/TyDehq2M9nVvYULkuBQxrahLxj7MCyNs4z1+ztLUmkzcGoEd2T8Be4jYTFCOrrnB6rDg1QDssp6IP/SFV0HdYiSW3Dno8WkSv+A0x/2E/Ttt+Ytnf2evfoH/KtUWEjlvqg9ZUngYTxZaaAcq6S0+UQMAGDpkQN88FR9s8jvLaYqy6inYPvntXAT+4r1zc8/dqRe4fxUqa2SZCh0SyFLCvMnjG80V6Gv1PDPIFAItnJm6zaL9X7q0YBR8xyNsnU4f63d
 eGm57QfC
 aONcbdaXWe5K69ZuMGR9tb/gKb741F98oC76HOCy6PaxPzn7nXIRhwxsrLHnRyMXibnv0r5A9InJmLHF3RzIcxylRT+wQeUj1NY55hOLgKPtm6c71H0VACKk1xjllMgxGae9vtnp5LIjFufbdp926D7zRo4DQlW1E/N6q9GtXA9uv1QWFZeYW1WCkzoYMD23H1VMg6ZTCXWkj+BQWvLp38w0DgM+FctlblYHRlfEZeZ5MLknUW4J7AIUAliz8H5zxCSDvuqGuJWyOvXrT6wjTubFmiIBYxnpNKcphD6KlaLwvzBnFw7Fp+IV53L4KrpR44bBFjJttk+bLqFvwsh0HlYks3L5weBQaoLyIpw1csf4VUu6369lBzPY5eF3EnGw1Y8rxaYucYTGXLZ2jJDPhC+yMTmkzIbgPsomjffuviT7b5yUOnqQEqJ/J0qMjeYMRK+JX33NNvS8fpeqr6K52kJ51DjrOEhl55TJh9SFMoXcU5BVFJCrRirpKLGhD1MzJMilUEYto/vgzQI6xIWe7D9xzEAcU7ZDU9/nPm1eCQDYk0bi/s+aQ0byW54Lc85GjCwFxntgAN3eDXv3IxbnVaY4m/33B83Hi0N5d92tFQGW16Cxs5C00SRhesoEc2b4njKoaryTtei+vT+jrTmjZWCU6Uf/SLRtcCqmKJcnjjCtiqvKgd7q5FyIv2JeI+Ap4zfCwtYUcWdC6SQKy8gyajsc0s5NShjUvWGeQd4WtM3dnBfe7DlS85JK32AZn/GY1HonEWodVBmILgtGnm/lYIlgg9qOcNWpxBp+Kk5JxR3w5/Y6tq5ENWDXOmU7LzpEFKAfVO/UGrUNVpWEGOhPRsnQjZewjrh38WaBmALEwT/14fjPuq7/wTFEBW9XeUkN088ZrGFk9PRZ9TbphuSMzyR3fqEhRW3dBbiQXup6/UVEegu+wa8xeB2RRa+UaTqzKgtnC+D/ciSvYSk9jEgL3/8BAqNWV
 IL50GpOm
 IhB62pWPvxOaJnZ0to9Hh7/iHhiUWYcZgV5ZZmXafO/S4TF42wXbho7ZrQkMzCERL5H7bYN1cYo5gcTAZOt5JZ27xBLG3PLt+5lUaQrp0HIUFXDfwGZq5MYEDFP5ZGspRrpYivJHQWT99VezXbdUOI/7HvS9R4bdH8abx0hxqUWhb1pma8JA01E1MKw1+46IVPq9Rx1BMXZyz/F4EwbZQcfcnOek2LaWRlm8vFA77AI30Ebzqy+zjFhombGaDml+oBUFpnfe1wsVDaS78hFguE5reksZDGyepWgqfCTRGCe0sY2XhLxREq5r42mHQeNV1HZNpOrGUGXpSJjafHrzs61cD0qJnJWttb5J45mBajo7uYedk87X0FxfhMv+EZsRUoSyrbSC9wTUcp4jrEnSRL85h2xNy+M8wwGLOojX2R6IVflufxCIMpsarTfOWOlWfqbdx8PIx32b4ks/2XLLyZ0BTyFqcBLXg1Yz2pLL2VxyONkKYlieQFUUjCSj3BFyYJhV6PwUtSCxm9SwWsojiy/MQPun7zfk+a6Fidg0FZFfvXOUiPu2czFg+Sl+zYH4JESdU6SraN4JSRXODcfz7GtwcJrIWVoZ0CA652qcgANXDeCd8GNzDhrcLCugVetyEjPfcLvK4AqvIUIlHYKL95oKytmMKY1I4hfKl7HPRk0GDh9LnJ+iZ38Wxh6p/EuZ64z6ub3eVHNrjTZDNzH79IOzCESK2RW4nD+wljX2NlxjqihL5SJTq6JkQ3FVQRXnYRtFVY2oKGl7L60r3pXN14Ist3yQicPC2s/76l12R/Jsn/qex41dp8iUb/hagKXmurPie174AUEV669dYzIkXLIAvyMbpnlgCTanBX+DkxKzvS8OioXFWl2l0Wye798HPu2L8yVo+CV8yJdd85Cw2hMrZBSw3R5jc1yFninJ29+sHOl1U7HMPmH/DnyocS/uuOGjuIuJUGNMQ+Ytjdp5hMoXuyrc4
 X9VdLPc3
 p1U+WPk/pnNx6soenBAbFunfHmPnGQSlYq4k3YKAFLwgpK3oCm7F+atmNr9I2hbRELaDr5PPJZaRmUA//mDjtL4L801mr3y3EF+YGb7IwYfzTX08AteHDWVRWexgK3HuDE34wC5JhwtVHv/jF/jJ8AaXEftzZInuyMofdTOaNnJSX+gqZVoqK6hHWsUY3R7ZxxptF99glv81bUGCSqJ1Isn7sb7bejpB17AAQexyVYFChvMLX3Nr+kTHZ9oUo1RatH+5Hhkhe9byHCwOCXLy3zEhCznf0KXeDe/HgMaLnwdrjrA6RhJsP3IYBDMxDtWykf9t8gEGCcX6Jr+D1hBBHdvXubUk3Rj7i0DObbvbzOwkI+z53z630bCkPav8CF71s7JJHA8JI3wVA7Kths3WBCtyHF2peijpdmlT+Y1FCkUJhg2ebf2VTiN3WMQdM94e1QwY6G/Am6efbLCPsdkeW/prDoADFYuS4j3TxNfVvNvSvyRAFagzObiFTVrEgNxGHrBrxsSU28TORVfwbXbnHM+H/GirUTcW3beMhdgf6PaD20J3OvQtgL3SB7PDDr1YrJqc4aDJwk3bQsd6cxGFLam8gy4z5r6cX5JRGmJna2wB8GkBOiO/Ui+nyA/LHJYVO9h6ZLkpHWyqLAaddb7Et3tJzigs0uF7HsxKvfbPGH/pccU1qU+StOrpL30FtdTm/B4bmwlZuirGSUVP3qPVi2gJzTb+FFLEKVGCfLH1aLFV5UiKPej6W64D6dOOxc5jXS85VzDIPQmsUpU4/RzyMs6GVuXknTFhalsEZci4vudaFC/+zU7xyWl+vSaCZXfVttEeozJGwLPF3900k+b/LoU5aYHXtqpGAaNV3IyAWz5g31Fsz8zzJ/mq0zrT6/17PcLpMQadj4ZZ0Z4ckZ3EcH5J/ZLJXNT3M8om5GIdQtPLavuA7heiSe+Ui2ofidm0JYTtLqwwKeTHTExUMp9CEnr/09SQq
 nQM0UXQ0
 4A6G8C5n0awtHDF10vkdRBN3ZqNwRrfgayBVbRqA2AbKSzPOLTbr6xWWT40GBf/AL/kGXUGBV7jHCOF60ByVbSjWgaQhvKbFgU7q3f6w2Tv7YVrPIpTEyMspLGwTrclBYxPsJCpCYxq2hThIUbfYZqAx5i5gR5J4N3a8XNp9x2O483m4/DMJCD7rM2693bxr4hY69QXhOI5JeyMChOsrq5W6hbUeTbO7klNT/0H78iDcm+mgIFt4BWf5sYgwmMiEXyMTzHtbWyhhUbnczxMcl+g/2bEj+NIS/U2Ien0KDk0zLLGHCPHuFbW9KBWc9X0J7e0perJ6y5jnkrlyykmJADpIhhAmLMSy4aCCLQ+oaQaO4iqH8A/E8Vc/qpBWXCLJmfC2tYIotidQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert qnx6 i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Also correct signed format specifiers to unsigned, since inode
numbers are unsigned values.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/qnx6/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/qnx6/inode.c b/fs/qnx6/inode.c
index c4049bb8bd60d47f9edd3d724a5d5be6b5deb5ee..630ebaa8a1c554b4d83ae75e5940a512e847bf51 100644
--- a/fs/qnx6/inode.c
+++ b/fs/qnx6/inode.c
@@ -75,7 +75,7 @@ static int qnx6_get_block(struct inode *inode, sector_t iblock,
 {
 	unsigned phys;
 
-	pr_debug("qnx6_get_block inode=[%ld] iblock=[%ld]\n",
+	pr_debug("qnx6_get_block inode=[%" PRIino "u] iblock=[%ld]\n",
 		 inode->i_ino, (unsigned long)iblock);
 
 	phys = qnx6_block_map(inode, iblock);

-- 
2.53.0


