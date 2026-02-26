Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA958FD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF1886B013D; Thu, 26 Feb 2026 11:07:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBAEC6B013F; Thu, 26 Feb 2026 11:07:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D31086B0141; Thu, 26 Feb 2026 11:07:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD50E6B013D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:07:36 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E4C61A0280
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:07:36 +0000 (UTC)
X-FDA: 84487088112.20.462A7B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C4FB220016
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:07:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JK5x+DGZ;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772122054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgzNRDBJO4amFMycpMMRf+vfqwK1IXnNEgqjgztAPqw=;
	b=FBz4SkKPQXhlYgYag2D52hBqSXPa7X61xuhmUCAIuLW6AsAAxRYU2NTuwjBg8o5/X3vSBk
	Hwc299VOHf4d1wRO+aaSJUXaFZlQDaLI6E+nXCS8sSm+uSma1xp/Ycnr8XhPPR75mejaKt
	0NU+kLELyOSMLt+hGjm2FJUZZvmjZFA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JK5x+DGZ;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772122054; a=rsa-sha256;
	cv=none;
	b=yikbqj21ZHOTfnc7mhm249pttDlpG9c4RI/QL/zKkYxGFD5FM5vRrlPnJv97xdnapbnJc8
	Cm1HmttMinDA1xUYnmAy9BW5x6S+b1pwwIRGJSOjIMq2UOJqnFw143lV7EDeYWY2te5mKH
	SlH5Bdnd7oeNaxy6G1jxOrsau8CbZB8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 27B1B6013C;
	Thu, 26 Feb 2026 16:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB8CC19423;
	Thu, 26 Feb 2026 16:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772122053;
	bh=g3n1nCxYMXEXDsu2ySJk4rG4mNa4qrBoj39gl+KTRp8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JK5x+DGZZZUuI0edwhDsoOLVacQSr2/2YCXlaFfdQqIunLA1rkj5wQ9VamvSO3bCA
	 A5nWTz3DvoXB5ol7feKJES0oIZcWbjYxY4HE/9ngdNeySq7KWFTfmCF5VsALncqJTm
	 aFulpOAiFtNLP68xa4SaFWpTjyOtA7E3xPHi08mdDQfxDUfAVmHBfIsRrP4fTKI2OP
	 /IjobM+teyuaj6/j3CVBQvJaTbr8dqEm9vVNEVt+zOpTOoD6yX+lBPZsXS0fG50YVd
	 UE40mkB0rrqxWqWmutULB0BzzxTD4xqLxmhEY4ebRz8xEj+XODgaa1cGYt6lx4MDP3
	 g01ujiPYpLTCw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:56 -0500
Subject: [PATCH 54/61] net: update socket dname format for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-54-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=716; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=g3n1nCxYMXEXDsu2ySJk4rG4mNa4qrBoj39gl+KTRp8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0R0ftkUVIgNWqRLpd6PjX/F6VzDmk1dabAF
 WFJS0/tvhyJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtEQAKCRAADmhBGVaC
 FbWzD/0YwIWbFt/wgPSYpzAoZ+dvSXhYUNv1qSOgWuZe/51x7ywGmtwlS+4pzvJVeUBrlxRp7yP
 UUIL4k3r2vgnjv5AbwRjtmB5HXfWlJ8gvx0bL9FPlxPP3sa/Q4JdlMIzJQDBxPQTPLv4WiOkUGI
 r+q0zTk77AVk/IELx074i7//bQBt+CGIiGRrD75P/ybl/IpF9ChoNKDKQhUB3g44T79ggU1A+VR
 eEP9NRAmIT9zaHIi0ZxuPtEERuECX+IosPUx85+UjTw7T2RvpPBwQTZAQKMyQWRaL/BVRzqzc63
 hGptdBZnmMgfDRh9zcCtZloAPd0wXeKNQh65r+MkW9yV+6cyzZypkA53Au9S+h1YFxWRv4q7P+p
 5Zd6+fG1C1PVFaNu5I1e91bs6LjWWhkE1D+I+PDj54RnPpzl4jGHfRLcIWlCGqO/FaHY/lTcfhv
 ioQXIQKh+cMjH/Gbq/OI01UMmaM0g4DsroUqoDPwKwevT1tUD8lSgbKv0mC08VZaMqEE7XNeOzI
 3lWP97M3d25pq/AJz98IKhSCNg6GcDc2v95IhToNIzeiW2tLT7qcWSUg9Xvm2jjTNsyltIi5egT
 itiO0drEKuORLrzOiZKvkEM0f0A1llbTYHIjitVM3x+tT5ARx5ZXL6QBynHiCaiRNETRgJuk3ar
 6/G5xOXPzR5hAjw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: kehpsyzcwwi9op6xi18rq6jx3rsahq6t
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: C4FB220016
X-HE-Tag: 1772122054-313370
X-HE-Meta: U2FsdGVkX18ofPxgO5CwncLsqaye+5y6+VDhmYEL4iCqijhtOjd0n4ZiSJQIvMBPKh7vY14w1NSe0lGn296FhDVWe/AUJL3pLe69tZJjCWouzuak28xk1glQSLblO9fSCV0CCJv5Cvu4lz9uWmTd0T1KhcOLNrHQzKD0r3KFbte/Ok4fe4EBiT2giuj3ChYgadMEeYEuI3GGhX8XpNNbSGNlPkSQZ0Qa7OOSPmJpu6ovhSxxRO5YRG+t8rW4hX8BZD+5qQozI01eGKTkBVhq7YFwL47Aj7gyIQAofb61Zggn4wNPCm5XQO/AUNC4vbm/c8gUZ2CTMm94dQGgHFpAAzxx9uYzCk31qQw7+oI7FKd0/C9nDLIYHZgs21wE5oGBjsBqwf2dCHI+Xjv74kSMPADIPNJngE4BtNpTfS5k0r66HK52Xwy16ZaGZbokyGf0IFjmPQN77j2O1diy9lb4FPcTEcejV64Qmt+8Uicl134Ey5kP9YV353jNQsLtmfUy/uPZlynxnO7fpgCD0Lk/L/wU3pqcCY6vKFmTUWHNRrVwPBUHB5DH8ASMzTZ1CG5nEdLgraNkQOORECARWrWjlm9wPAfZQ/tEVCIv51OATZUuE+JvPs3aZjx7u02huHm3y9xAo8Wr4IV5aNqA9S9D75LP15P1cmL+5fOk4mxp56XwLAyaLyUtMeroUz2skWB9RWorpR8VehSnKVTm8w3VUiHyjtUzd8WmE+Bgjgh/pcNtJQE51pE2QxmFP4JPsaWI8ScAczNGGpAH43LPdQsbFtezeEi4sR4MrUmxj51L9ofllZQPSTK4DbDs/tHGjqTfyKhE6aE6y0mHgO4vUWFwvHr8OkdqeNftSXKF/SeL62JJhBm8AM+YNyP0BMYSxEsfNd35Vg9pYo813p6yiR+uxQ7imlCoeI8tyNLireu+qAr3gD4ePmsxMd27tx4cTZ9MzjXCydWOUazxo8325zo
 YsdJjr/i
 IZrD54+L7mE8K792qpFhF1a6eIWwQsRkg4LNQNZJPIc1BlRkV95ZjNibS6VQLo7SrF93DUZ/Tl5UReIP7HgvAm53HFxSh2Zm+fi6ZxNJMqaed5M18Izm0QZ5ZEx60rlorP4qBYbpBQmFtydzGhL2ChR606bF0Fkvg7qIWBcQPo7qWqht/sgY+FYJP5Mzv23pyw7TBMrMA2V5Mr1DwR0Yim18+QCf45Cf75hEE9pPTTZj+IxfY4HShfxM07jncfyab96tDLuvHZ7NrXGteVb5CZFjaTAUfcF8BoHeq6EAAUdCrbJmmrtdqlY0eAe3hd9vG1X4dr6etMvV8E3PLAIBDOCW5LuG43IJIET2g9l/kmCRUTWumLvIH1OrlZiVapee6Qo4uHNTNhtcNnOxLrS7X45EI/Y0VsvcW2LbqFrCaOd+Pxxd5YFa424Q9+ujk6+bopqth5stF4LY/3ZH6ScnP+nUZiJv9tFkJGtQrPM/Wfj64UD7NsiqzQ7KXZSR85WdcTAnB9HTIndtoH+0qAhfHHZqqcqDigt95WyMEOyhZfQ2BsES6Y/BPPIYCddRYAk11mk1+tl/VVWq4r1mZSx7gG0e70PWA6WuthpctmEILYtaZzvaEYNq5i6zvX1bpQadzKr0mJA3xmLe93fb99LRui/TrMY96SwAfIRay+VVX67SAJk89oWcaiG0djyMrlh8wu2qaRas1neyb4AKC5Q8QFOsf3eiRflYtId/mRR6aNFVXBKyq8RCCFPcIeNXi2CENkLJ85Njl6mbhXuD1h2dmUCUZ33vAhLjktyaGPwqq1qOjaeFNtfeeW/9rpXs6UrmvxJwcy3aTJkm7t+yIqjDlbbsTdOnDodv8jrs/ME5MYJE0IOyP8OAXbbVw1rAmMJM4MRVharQJFo4ZYSJCCDd5JmynnzXmAlnJaVJK/vjm3StxtIhfSKmpihxsMYoho8/mEqIQDJRfDiUgE8LkJlTX56Zboh70
 /STLO/mT
 +1yJYjYtsX0aychBYN3HxTTz3/taGVZQWzgwRKYsXQyDESkDTLsK3RHty3j7JpQc11JVDfrdjmgZfszYDSAkLeCDsPRiA9y13WvtjBksvKeKYmkuo0s4Zhno1gQ69ZbpUNkSGgvM3ou9etZyuZk4w5ux24nMcaYyzvHkLAmWgvbHjSg+qj38dAbXU6k65Mwx0zPXDiFYhORbcjcYMXJ1UtdPj9+73IrokD2jgagpqWwrkjznbf3OiO1HG7cCAqdR605K+vGINR92fyDik0W/i/C7r2n8PIY/dPied3FvzLG76awkwTaiUxvaV/zFQluTllY44mmHN+Bt7su5Y45chhERxNNcXIYIzEXoPep3LGKcE1Zao1hPeFc3lZXbJlcnixYJRAyLoO7zztesrGiacyQd6dQ827qdgzKu+QJafQi2E505b78UVKF8EzL2wQh07loK27THLbqzPcA6DmO9VTBEU/s1zvEicnXHYt/mmTLYGhpSmOheAHHT/FawwbK3bkp7d8NgEXTZXby5/VmyPHZot/+9t1ypXAlN9etDCXWyosPtkTGmT5Nou5S8C0ljhr79UoByK5oAZsJHFnW3mp1YP3ndWnM/TKV8iiGa+WXr89eXGvxoIjRrY0wzmg226+K/TEVgflfobn2gwnh1lmGZD97WfBwCsiAzM+QND2eT0UlSrDs8DvLPIJf7YaVaWGQ+BTdO0J8K4BkeyYb2QW+fLXqeQkGfJyjA+y5dJKqeE8DRDBcqzyAptmElLsGc+2lD1NkGZwkuwLH+sZseIB3NP+7xvJVXXgGpFZ08dWHAguX08XQEEA2ixjM+AYV3JtPDrCcpznaFsdFxt6FuxmzdhqU7fSipvYC2MN873mUC2hzdfCxV9AFuI1dRUePBom7H2TqaRyab0XiERMaCDk4+whiGTOWc1iDIsvNSmoJbIKirZV5uzSMv8keXifPUK9tb7jWGgBMrIwM3Fr0oQI5iCZd2j
 8HMMhmW1
 7bSWAFq+I5cf8Wuhk5cf54oHxsPUZNIObidbJt2XyPRY64itF6ELaMru2zs4r7nLdc0kPjOCuy6jB2VgW9nIILgMvydUKopZuPC0isiExfqUj8IBlFIFPEzh3/gc6h7iMKysgBTCQiKq9cO9VAXUX+zP5QXN/KYVua8XT6Lh5QXwA2Pa8q9mgkFvztQeIAjZwdIQF8EtGJ6G+2rNjWB+pYsfpgQ9vcp/LyY+1nbYNQ+7RGtXhAyEwUfrMIBoA084qHhpXB93JtcTgdTvDltV7swF2QA+pwtaXjLQJVyv8VWvruboBCNBgXog0TEH6/lV2/YyHG9DjJ7hJRyyjzHs2H6eMFZC26CVi2D71luivJNjcnMZVuzdhDh9U4d1vh9yh6KR5sO78fGkREKzf+MGG5g6A7QawUTu7O6iiYMoVfvX41iDr2p1E95Fu+NLGJlNi6PvA7xPZqd/zohz9T5WokWK3tQp1JhM6Kyzep6D3pmX4gsCZZYAv8nw0TFWgXVZvALnGN+KrESuJhq3aEUxiVEY0WRP9stpoEQ5alBwWfXQprsaYB6wrD6hvNjuYTfSwvtrlCtVZ0h/cA0ArahKjGTgdf7MV8/rcLR1CZbG2KVuguz0IBG6cgNXJnlZVVcSMKrxfEojCyR32cKR5cQ//3RDAmz067UgZn5qyUk0PmzREDqY4qChHk/H8DCrz9vuwoSgRBGR4mdzmKv0Ye2M1H0LypA6oo+U9/AZOlXUi/x4V7wf0MDcI22lIsIONom4ieMKJFX3T4J4+dVaggnT6fMe9rR64vpCuxuyARZWZIinbXMVkW5ga3tjmRL+uyXJ/7O7DsH4lQ64Xw2ScjPtAeOmwz//WZT7SEF4Z3DsAaiOBPFDV9J40gB2oBkyt6YoDkT/JfhDsNyGZu0EpnNG2c0NTQHRY6Qb0kJ5z1SvzZoIieC97CVdPxUruurj1f7Yz5YGS254y/wxKNqwI4ZM2Ob0+VtTA
 pednmJZD
 pUraRQTRQUmldNLYTQldQxlJe/jA8IbHYzxlpnFXD+wcrqF/tw2Fl5EqRpw27oVI8ulr0cDFuJWkrZURPC/FNwzrbCUhS/2ghMqLzoqj0Vk4fntkLlqL9BrpBRYTvT4V3rPMogvDv3WGjIGkp2vYh11geyXw9vTqpBJCTU/9kO4ZGkS+KJfPCX40n16T+5HZ4dtwpvM2WVljUHLz27khT7iRybuWwedpaon+GEypZONTsbVdF/B/jOL0OadCrPnNscpoxtaGJmkWfX1TZcaOYB6/ro9RClPQQGxd0/All5O0ZEdxy8TEHIwH7rlUMj587vYQ5FdobFJY0ltNQa+VXspzm79YWCfKc76m6rPNvz8YnuGT9NhV5J91FLVfchGo/MS81VPCIBwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update %lu to %llu in sockfs_dname() for printing i_ino, since i_ino
is now u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index 7aa94fce7a8b3d6beec7594e311e73fb52f371cc..3f4d2a867aa15b2d2aec1c9dfa004bca94f6d5de 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -399,7 +399,7 @@ static const struct super_operations sockfs_ops = {
  */
 static char *sockfs_dname(struct dentry *dentry, char *buffer, int buflen)
 {
-	return dynamic_dname(buffer, buflen, "socket:[%lu]",
+	return dynamic_dname(buffer, buflen, "socket:[%llu]",
 				d_inode(dentry)->i_ino);
 }
 

-- 
2.53.0


