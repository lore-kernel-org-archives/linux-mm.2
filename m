Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8369FFD8FCA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:01:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFE8E6B0100; Thu, 26 Feb 2026 11:01:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBB436B0101; Thu, 26 Feb 2026 11:01:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80E86B0102; Thu, 26 Feb 2026 11:01:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B2BB46B0100
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:01:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D4C116029C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:01:09 +0000 (UTC)
X-FDA: 84487071858.06.89A5F3A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8F7711A0013
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:01:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tKwM+R80;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pD9sWgsPKwIrIBnB/EC1YeGw1h0Z5RgETypjFEA4qds=;
	b=QWMGsqHmJkOZ3SIyYqWl+kQIXCzZaLPOxxP8bmQW+Wt5NHu9+ovxUI0L3+raqX7wm5viOy
	N6zOHWHDoQKsruWmW60jmIusMGJ9mHWQ/zF3qE/4yrYzIQTYC5OsvHCaadszxCxz98dzo+
	Y1FHXj8e4gyn0S/18rkWWcVSIEVv6no=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121667; a=rsa-sha256;
	cv=none;
	b=0P7kNSGSxnA+h+hnXpW6Ner7HyjKKDC8aU7PmZCC10ooT6krOuO/mBLg/C2JLBUjnm/pLR
	qmM9khR7PhYHwEoiLEZUyrQq9IUR6GH+9gYDHK9i7/BHQO9pPE2rNxMTtTB29EZxW/t53Q
	Tb5luCKx3/wKLZEaMvYTjbOIuF15Fgk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tKwM+R80;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E913761841;
	Thu, 26 Feb 2026 16:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60656C19423;
	Thu, 26 Feb 2026 16:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121666;
	bh=7Xz1UJJfqeBRm3KK7yj9hLaG5S2SE5Y3JXXRiEG1LdI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=tKwM+R80wvtJ2UQiy1J/R0hfUKnaZfinJ6dUoaFZtMDTIxMyAqaGuN2BHRO4fFbab
	 q7P0zROfKP+2iC23lppRzRcdEw+c1NyNeUf9JfSqlxu5DLOxdk61DhH43iQT7zADEM
	 erL8kbhNIXuLt6XxvjGN2DxbNefjiwFMyQaJqbzP4EbhuvKVXxouew8f0QfkY3ISkw
	 7PnCV9755KVTitBYoHD0RLqiMZ3IFj3GIKRAiBT98wwpQTGUiLsGhGcsx1H7dj86mq
	 t9rIdqLaOeRCpgmkfGx6qqG4EdsubayvJGsEg9NxnsvfvDiMaVxAwYpXeHQIzX873s
	 6KwBo2ZV79OfA==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:25 -0500
Subject: [PATCH 23/61] bfs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-23-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1107; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=7Xz1UJJfqeBRm3KK7yj9hLaG5S2SE5Y3JXXRiEG1LdI=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0J6t6tAHYClGd62fXWh3aD6R0JIxKC6WIfQ
 qH6RcFEaVCJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtCQAKCRAADmhBGVaC
 FVDGD/sFG10TSohP0ZZ2AeGUAmdad+S2uCijCN7EK9gYsFfVXhxvbQSLD1EgEXKfMb60YawxYV4
 msM9kXN9SvzMM8q7NsemBtVDtmqnHunALM0Alfibn23+O259I7pulNXd+X31Z6Ww6AT5emWQzjp
 2zfBuwXIE0VZeISxHYPcgge0M5QCMHpO+aiMPnqH+gyzY6hhuIhLBEE2uFA9Jwt6uPY4L1pjn7w
 YVmjT8CeakBDnokgfYNEN3yQSOKc4Tug8svWt7c9+DVbzSh/CRY+vmn56e17RVe2SCI+zH8HNfk
 1M2oe/Ab7bLVX3Gj4sDNVg8BvB+okTSoNxOR554k+ku2olLUjgt5EwePyh5LxtXg090fG7xbPzw
 W/N3RxocuhQ9+9XW7Nw0Uo6WsDW8l6IUoQSABE5tK/wKZlXPdyMAt28n7Wp5JyME7zGKFujGmtx
 2ePsN0IZI4a88M+8xfRzRZg0dH1yRsodpH60IvqbuegH15JcPcHDrj4/ELAaKwnrA1rQ3SYr0Ej
 t9MXA1lQFg9IjKyoU0elmhE+iUailxHJliMljHf57qG2gRwOLi5CLjNWKBCGyyBzt7Lvn7XaFgG
 6ea+FEnYn0NjOKJpgDaOQvNrE15zRYDlR/+xrb8UaVXILYZPHoZngBD4MNFibOMd8JqSnJ23x3R
 oKBiMHqoCoK1mqA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam09
X-Stat-Signature: 975o9b1z46f1miek7fckarmqo5h7xzpx
X-Rspamd-Queue-Id: 8F7711A0013
X-Rspam-User: 
X-HE-Tag: 1772121667-392847
X-HE-Meta: U2FsdGVkX1+qeboWsIKSkh9LHnl1lGbPqsKB7Y3npkY9bZcoqkShJWn6JkaL5fg6BeLqRPaSKm3H4fix33CDTdRKpN3GS+LsUuKf/SOqwlsuxf7Se+S7oYYFo7N/+DAzr8EZxSTi/qpkeSslU3oXcjblVCuhhqSipjbStWy8EuSdPXMYj3258FrG3Oia3hGeW5yJTnci5gH9GLPT03e8YJUHR5nuL6kX5dfkkoaBM06ZlMAgrDsPLBOJjHAsf3yQgwY9q1A86kjO5H8Bbu6TaVSzgzc375BgKBggjSMz0Cecy6j9h23GdLflpjTaBcFOOHVzyLBcFLtG6WNTd2+EKyj3jpCwgGjr8M19/tKDq4NzosSyy1ESFMjeAZeGE9VwCS4b+1BIf03sH/ML2ro0QtUEQVhYUTzXUD+OOM8ElhKHa5YvCHuU1t2fyWIB7lNCn1aqLpN/pYiLmMDIIkcj3FfhM3N8jeOJRcWDFCPTgsgChckVPNC10I0bb8EgW6psGyESkDzF7PaW4FefMIi8Xd0KDK5pg2ABuapmKSkwfWKIgEUehsFwRPSTRhguzPM/SwKsIcHxxKpHDmJ/NWWloup5/mQbxztHFyYDzeBsRrnxap9sNokcH743IZ2QNZFV8Zt3zK4wrMMQ1e1v8eIgIUVRxhy1nqnUOGehJbXnZKSeN12hRZJm1nvz/C5vqU05MQgkJCi958F7UWflTVHGw07jgXXZifPIQnhp6F2Ax6PVJDQVruT4H/V7cSM4xWW9S4cRH/x9vyLVNRSg+iVGa65vldMi12Jp9ITKH9iMNcs0WF2G32eGZiMvok6znMSl5V1FGBJx1gBDTndUfzBj+g2c2meI7dC1Ia1tRioGQgyTRu/wu+29zEOYafY77IDQ0Gb558UY8m1BZXgow83R0BTrxDuzu7PB1xVt+rsszYMY3ZiA3HzYjr89PvKx7xi7uTfWiC94pzgco5K/VI8
 JRVBAuT2
 er/S/e1iZM7NPqJnNNYecKMPYhbkhOpqSVlgdLDtWZOoTZE2nFd3CYwr9YacdPGjYXRaedzQMA4S7FLY2xPA+14B62HswZkDde2PXqFatrzM3fowLcCQ9dFYBSjVFNSek6QY+qky/chMvQwm17Tly2ullFd0mRIw9ZP6hADY6S3/tmavEvtGJUBnxJA8WE9iY/G01ITSqP9NAVSL8JNmuR5TLcKJPy7Atc9RzJgw7WAJNMGMqUNIVDeXIg2EVcUrD5j8gH0xSgMmYBXv6qg2QPLtAEc8iTu64O3RVFPdaHcuyBhKrNUoKMmCgUoNgY5QL0FkJynq38I8WyC0LJiLNKpErF66s0KUIsjDJv1nBJVLBYpMmba3b9U0mYZZSIQKPPLg8herJ2imOhkfmC8hB3JjbP1z8Rief2hSG6CAp/zgHEuN+yb5NxYHTLN5WjTm9FCiypRkjzoAH4KZxCFFwO/YPaAhFuVypEIhXLufhf6BymOBmK9CNYRxaiq4uYWnkRoobBx8hPVwii/Aek+CBaFW5D/+qEk6fXLsHpdZ4XLNIzx+0bTHBIdZxWbjbT10WnZtY7miy1cjncup/YX0iGAA1b9Mp15UO2PdRcg1Aq2XIqLnRNLOAPMW0+lgQ95dUqHZZAIw/yb6UzCYEIC/0kfJlaHczY7IRQdDo2G6CHG6yKbGOx6oCfcHczzAO+PrLbgioKkAqLPMUVollVK3VkZd7lOJV4GSq5mOtkYA0/dTz97SAop2XFvU3At5fh/zS5AIFV8jNNE/IWIDseMXkud4CXJB76rCYqo06s05xXtJzMCOGJJOBmblhzVYRydFw4ymOcbD4p8uPKHoSjyhIicTMLG4z+SIsxeeR4upkHLEBS9BHYF5947VVO0gqV359rcO75wMhqmKCOGXLgh3LGpFZwq/2VR9Ztyy9f0TSC7u5MN/jvTKTYFNeON2Za9X8sMj3q74Sh6i48G3Hx2iEc7jOs2Sa
 q2w4XfY0
 bA5xfrO3vBG1wQDVnb1VmvG2YKTSqwEdD8WX/K3vCmey2qamPYzMVOFHViY9I5gJgHE3d9BxkTW4pPlmPob7vXXbATOB43izY1z/3KRZQjKIa6aUJdSyrpysBT2SDPObize+curBCZC1c10pDJTcUmuuM7vNuTHyxV5qxXPI1PmuEIN1ET/aQS/RPC0rLmKpUer4KNIlBERNyjO7fd6dKo5T80hdo/7dlSOHd9YBRPbVkXFH0xqqcyM40hEl8r9A1imuB1jE4LR7ojbv8EAVAm5dVifDONds7aBqhAmMbGlq480QIaEdG828+ehoeRyL/1R/HIqp1MV0wjrmQMVNa2JyEDgUKwTEXum+i8dulEDzlwLhu8IwYwvx0WgLTo19p7rOqa6G7caczSmxiChTJNG629Ty2B2CgN1dWcS8vCH0nlX9KlLyyVDPCFX4gTt2aH/MKiGUKoF7pdAWoIMGdTUUYY6Bbnltxk/csYzhpF6Y48tZJEjPcRZ1FXrA2BSOU5ukRo9XCc6q0oCd1TwIjQWmHBiuOQU9BWkWs1efdLp6Gic/ZvDK3EeFeThkLz2xgNBmNA2GGQIczin2FLjhmQcnnyOD+6a/W7vIa3UxzMT0aiMcIuIraZgh3vTzODz2/BFVzWvmdew3Ee0I0wlbB2KFTn5BWN24RJVHzf7nkWPysREmVj09F5oasFJTJnSz/jubNZAc4boYcIX0zzuRpMV63Xh3XpqeDyMaf0EWf3u8iFlBsB2zLGL+6Z85B+n28ykF3PKSqr8ogvB0SGP3xBOshpseg47eXD4SYcy3GPVq+GveJwUdFxt8XH1BYNJOmR0HKQ8e6kCzAn4Y0gnBvHgaTEknsb/C5U/L/aenmuzvsvEUYejgBu8wZLPf4UcZmNJTFc+AkEMOS4mquP5c8kmM3MDNDpc4dnkhsVMKOiyNCDE73ZtKiaJGIO5I1SOPvs3cLBbmcgJ7s+qAL2OeAglGC735Q
 SsvpaGw6
 r3foo9C9KqrgrnGgwVcUTO4YOX0qQyJD6ZgYs+j4qGC9o0UHKYb4viXWfvX8rovzxRcmA2aoqyCvmUcalNAx25HwePEaYr/cbxD9NejG28ia/WZj/RMzjG1JCL9ThgpY9h9S506QH5bCNwVSOqqGEz45T40C97aHMm/LLV5eBZP7Rjfy1B2DEB5qqaxZZx89/kuiKYjADP6S/LRClTj6pUsBULsVp7qqw1vLC5powZIanB2r3rETAkML46pLqox4IMGEvjECi/0zreblUWmhupQf229o6OC2V1v42AVSwbDqDtD+1cIBAByhNRiTidOHXE8Iz9QMzrSDMY+c9saQuymzvWY5qoLKkxjfCnuTYLUA1/AwlNuHhK8VT9y2lCsw0cZDBq/+bqdF2wqR2dQAdUKksoR50fTddFDAxtggugtEvc8wiXmw02FzPA3Qnurw5vLnlalIAZwBfNRDQipf8bhiHPM7YBjaIUGeQlclw0fo3INdwg6BR77ZfbQlEGR2WTnWdWcf01vaehQ0RZtM7o1w/WOEyIA66HVnRu08V0IBKkwf4alassHbnTWmd98sBnV14nwLtGPfNt6Ymp0acVC1NHTq+qdvuOeC4gNrl9Q9q2A0MYCp8BRvouTIsG9kOo+sWWeNy8QJli2kQRhgfCQT1wsakevK7WiQBRI204S/SdrjCIVT+Vk7I0+Epk1ulKlHJkPLtZo4bT9gIkmymK+SAq0WUEAbcSAr8ZlPtOcV/X+O0J1Qji7zl7lgTbWRtks81nV0kUuxQK8xb4ys3IywP3pWu6BR71Q9iDEJdWtq5+y9T7PkBAMvdTpCvhfBKDJNKKFllJBhEX29Kh73iKyQDL0EztyJ0AB8TGog5EsmPengw48JVzata1z8aK6OpkhPbHoLrovOdvT6xrpA79x9/dwVAlCgk8Hab1Qn7bTf3aeMqT/3ZmCp/t2ZBaXEXgtv6dQjqXw20mkMkFI+QlMWW5+ZU
 NPjS1GZ5
 JpYrAoiBQKI9xigx5jaOVDblktCHGNfdBiHb8VQz9spHbh3A0rWrftvs2ZZyI5PEG8dMGMmhmARoFWJaq2suDwk8cIe+vNWQ0+axi0Igpiv9TLYKcbs79gRVuCOLlqoE1J49vJmKu+bsEvccGUMGqq5CSM07dtviDl06r/gZLYd7v0A3y7lk8zjCSXILis2vFOXf+r+L3kvHEnAupfaw0uo9SI1TYuU9j/RNaKWILIvcykb0jTZ+V0buZUhSUngqd5qnDNmfkLGl7wc+WqAORg82nQaXHv1KBzPtxYtxCXHlCLqbTrP01v1ATnJiYtKA4zzwpRlGgC6vFflHjQOJTADsH8JQHpc948xlzynS8MCIhW8rJ/JdcvNtyWVHJL3SYVmuR51C0PrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in bfs for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/bfs/dir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index c375e22c4c0c15ba27307d266adfe3f093b90ab8..481514db4eae3c33c280d04371a17ef321486ac1 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -35,7 +35,7 @@ static int bfs_readdir(struct file *f, struct dir_context *ctx)
 	int block;
 
 	if (ctx->pos & (BFS_DIRENT_SIZE - 1)) {
-		printf("Bad f_pos=%08lx for %s:%08lx\n",
+		printf("Bad f_pos=%08lx for %s:%08llx\n",
 					(unsigned long)ctx->pos,
 					dir->i_sb->s_id, dir->i_ino);
 		return -EINVAL;
@@ -180,7 +180,7 @@ static int bfs_unlink(struct inode *dir, struct dentry *dentry)
 		goto out_brelse;
 
 	if (!inode->i_nlink) {
-		printf("unlinking non-existent file %s:%lu (nlink=%d)\n",
+		printf("unlinking non-existent file %s:%llu (nlink=%d)\n",
 					inode->i_sb->s_id, inode->i_ino,
 					inode->i_nlink);
 		set_nlink(inode, 1);

-- 
2.53.0


