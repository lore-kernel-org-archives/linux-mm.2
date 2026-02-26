Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78476FD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16A56B0129; Thu, 26 Feb 2026 11:05:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1346B012B; Thu, 26 Feb 2026 11:05:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37296B012C; Thu, 26 Feb 2026 11:05:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C7986B0129
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:05:32 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B80C81602AE
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:05:31 +0000 (UTC)
X-FDA: 84487082862.19.F88CF23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0DDBF40005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:05:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZFzN5/gW";
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8w7EvgUuMSaZE9Qyg0MHPKNkMuZRawwbCzxzxIoORKw=;
	b=LXyFWebPGr6618URrasHkzTzMDh8p+1K3dHmw1y+kQv3RGjaEPqyCcpBH3L8qNGlQr1Qhd
	hQe/oibVw+Kgh0ViWJWWEYnWLkhWVnN+RkeESgHKDRP2sFICW/kf+QMld2Qd/eLxyaffaj
	ySPzM9NF9sFjTpJlcZue92koJwPhEOQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZFzN5/gW";
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121930; a=rsa-sha256;
	cv=none;
	b=ohPsZWbOdDMmVdy20za+sZDtntr9XS8NeNeJkGJNt6Zlj7ssq4rQrkcMX1Ef6nKeSsnpsf
	y5XgMMPNI6UcFYSxPyGtnq/7+KLoEuqAZs1DzaFXcr85hTmcMjXNAnRxOpRz3F3v2HQo2w
	j83wv9OQm9cSO1IpRiOQ2n/gngUa8HY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B4536184E;
	Thu, 26 Feb 2026 16:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAD6C116C6;
	Thu, 26 Feb 2026 16:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121928;
	bh=6UN3al2tzYcVr4bhkYBjIiJcg7kY6ll3XiJLa1oVlfY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ZFzN5/gWqI9gVceO21c3BlE3ZOAJdQoQM8i9DH0/agwltGQfJBEj2IZiSMGobNPVQ
	 qBR6afkadV23GWyE9polaKgasPkxRt9pVcNxjkkCRuv75exdLsba1i4bjFk30U4fFD
	 UX9ijQ9hwUqkVl3r/XBmRg0F7V8PSUA2ZpThgY+oEqEpq0zqD4e/ryCk4JajBRvsAv
	 lVCjmimZLSzAFRgQh9TG2Gwr5k+xiKNxvFGnRUWmrCTyM3Gc0rXm3YT9wEYE6kitvS
	 EI2JXuKLyYi2twKciyQHWfESTvgYf9be/q35EEgBc1xBLbg4ilPdK1D8vnIy3OWz0g
	 FHhaJQ7ROg3VQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:46 -0500
Subject: [PATCH 44/61] overlayfs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-44-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2573; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=6UN3al2tzYcVr4bhkYBjIiJcg7kY6ll3XiJLa1oVlfY=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0PmAX6po+Me1LtXOxELbE3YbRF+E3FwKFhW
 iRe4MINX9GJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtDwAKCRAADmhBGVaC
 FfUvD/9jNP3wjvadvWrklZqzkFB0cB/NqSi8mDICkvziy9OFAtTNtEYvzW+khlIKBucHQ54yIOM
 zY/xF5a7/YoFhl9C5394YJjBShWBN6KvHBfe8MnxqXAiRGCDX2AF9XRxZTwbl40wcxMQ837uA2X
 9StKcjWI012KgN3nMFJ4wJUCCBvHGlzZODxlnzPYuc73B8I6LzYkjL7b1Hrdol24+O7nOyUipAr
 fFldocux2lUhdNtFG7o51ByNpYPvZR9ikm4Eq+M7CUk7NFbHViPsh0ZazAsodIfS4KWawW3EuCh
 BbPcItOXDx4PD/GtKrZchiaeBTGQs56DFgH27H2I1skP7wG7/tU4qWkZOYGp1ynUj8nWjdM5jzJ
 lz8WUSw4nXKgGxltV/z//r1obNY8QYL6RMPvILX5WCmvazbWL3p7fENvjKNzlbOI8RWZQkgUrt+
 09RTMnokkTxKg+zs77OKTRBHDu8x58IdE3xaecJG5TmrObPp1lXiMnCpU5baPwXt/FHuI+x+La1
 eH5/LL/aIOL1lk1vt3yWAnQrzMgtRXV5VlqxeT4lS5U0iaQEDcWRikUd5yoBXNOM+8loEjduUTw
 7eoLOS0VNr9gAabi/VS2wquojz/TBJKG0K054mFYwl5ABhYOoge/H7vCbLV87Kq5cRYyVIoYdM0
 DEiwZhMl+TVsm4g==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: 7kqtbew3z9qt5bqo46juwsfq8sxyngr9
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 0DDBF40005
X-HE-Tag: 1772121929-564869
X-HE-Meta: U2FsdGVkX1+nMxRK57HuTOO33OIh/eFSFDHe2IuowK/56102z10o4MVP4hjEi7TCmo7eWiccj1S/y+b7s4X2nP7J8XBHmLmWdSY25eys4IRgJuBSQfA8f4J2lrT4x/RD+XcA5Qr2+eaJ+26STb2xLHYM5veqdp+JLrVHA9cvYfcPPpxKS/hLkTOVUDzTzfG94AeecXKEWqJo67IvTonXg1Rsjdlld7WMwVVOzDB6nMnY2om9+1OKui68aiSF+jklPrkcnaQ5/lXuQU9fY2cDehLCfGIWOFZ26mcRtaKe+JMEiOTZj4kZtu5hpCQ+BV+daWCodof3gcfmWcQrnIolD9U4l4f5TELEgSP78nPyv9/QaRhj2mR7iNyOnLMRM1ntt1Ww/h1ZZ+xgDHbo/QZLtW7WYx6ZcMdn/cfZEpXfIYUDPdLbzWGZ60ee5K+b5JHRTaatYn4a4Nnn4YOCMg+WklZh5tTFN/CMj068BAY/ZEskC3I5chbvbpN1UWUFEoYjHpJwJHa1W4wtG26fXeLbl9KMN2cN8rCsJ4oHkdxS1whzF948diL7MULrdImv5vPC9yhTQ2+t3yZhb/DqJK9ZHo7D0m1phKLcsXB/PbE11c6wfprf/MV4kuq3aRVtdTNfe6JZ7v535BIjphiLUQXP6NNC2+VwbYkTCMUQtXYP6YucHF5l+eH5cigBFBMdNinbcugImBKZscLE3y/04IZQEeAkr7PjqJpFUQviOzrZlgUzCjR6tRbxG8WqqdoeHa4+q48m7Fs3sIsCM+eIBGvq/NGrVzgfMNz4TGwT7f66pDzqg9hOBAlVGE4WCVN8pYCLtigmV02DDFy9P/k+VfGjZ2rK+hgV9IauUql+a7DNbOs3gylCW/vSGKYI3FGgLdWn76pkiJZ4qnntU3WNard8w8uYwwgNH1WgDO6HGDqtfcgBNcAxrbIgi5XTBe8thz4tLswiMKTKXnpdic4UDbZ
 Dh2jHpTh
 sB0sndi8LSLQcunwr0IbZ3V1Qtg/OmHVzkB4nfnpNNk8qYQB4RnOVfN1jxXa8xAEMefAqrh4AJXG0mfZe/bixu81/xbj7X0N96Eul1q4WPfwtwl6MfQt8WyCfAN87kDbmvmKZZ7eIihH70nsz4XjVFpd2waNR1uL0jb7Pbe8tkJ0ihcbGShpw1ZHlKn41/iDp7Msx1S6Lo7r+4fZd/kJq23rPu4D/2UKPl1xzVgtieH1Wnd9nyzTto0Yao3o3VQRELYJed5esjE9WretlGyvJtUHsM3HMSUDx0TLquU4ssVrD94Av1ZyYTVn+Yy0joPLKW3dGDVpKsym/e4QcxL2COp04LfCsuJ9R29N4zei1j6eOuEOrPCeHQviNZhvh7pLrtLsFLTv9ImZoqsfmdeVUc2E2POn11KhMFfUx7GH2GcUmPVYjgNGyuort7qOw0jYcT/U0Au+8gvVixlhHVCqZd5H6zWlSjb4uX29Pcuw2m67adr9/GkNzHVL+uJpXez6J7EkFmTb6FkVyfp7jp55Aguhm7T2PHPmZS6j4AYueQ1r0eXPV2SsUA2UjEnwxmeXLt6TRELmedzqqrmzOXlO44nKBGTAtoj+Seoz1TWB9Hvnr92vkUaOxKR6tQoOb5O13po2XKRdqlvYyBnRCwuMtSkOIWliE6DCpu01a2TG/23km1Qa5FNXMR6TdarWBEYpD+22XF8fIVfY4wXb0uUbxDTgOzrQSUuL3gWyldCfbqmSEBSGCmvczeW7c/YMODguljzc1unZEGPiuXRt0k92YXvBOl0i54N6soVhd6vK3EX8BmFxPMxucw4DpuVOuVv/+0zVs2DHKPGnm37E4iGWtNCvgjFk28I37vkMzH1lO1gErjESfTVMa6LXj3tXn3/NGEZPdXr8uUNtHSp4OZ+ceTrQHNjaAm9lontWhS3MDdoQZvsuS5Pedp9oqip88QPBnkaT30qb/fmBQVgzB7Qe8o/J4pGbi
 T1bDAwP9
 CGv3CEDy1K7B0Kh1mLalfUG+EfPyXT7VM/fzNOBzUEyX6+fNAdW1bl+jOAwyt4pt7DYKEqG0cOKzA2v2UojQosj6y4f6DOhOT26SewO4YNL3O0ol890w4I6jy8GBwx+Nxj0a3flJczy7xiqopQ58quIt03XPaCDE1WxlxPaeLQxOdXfYS2f9cWHgJa98QpSLdpuIG+3Qo+IcrIgxozkQwu/Wej4La62lt5z8MgHn+skjX+wmgCM/cF+fVDpM4OPKAPUxJZ7XTJyxcGzmFUyty3SkvPaiyNmS4KwbRddZzY2GqwoEGNayV1srMiqA4X0uwN/a4q9Z7EWeoxnYy6vwwMLZU1PvMu2CgMTQQwxjVdygubTqULT7026e97OJEDcicj6J0gVlmDp77/Z/Q4El2aWUowydzAMxAhHyTdw13HSphNzBP5LBwaNWr9HssosEVjwvfYhRetVmoKWuvh7VsfAb0JO6yTT325UXxUrchSFVUXnBq/bPPx55NrTQ8+cLkKXGBYbZNA6sYAtLD8amQUlUgT4LulqKIF3S9UJdy07UuXdAzkwexQc/uKAitzc23a7tfGBjJ0AknbjCJg/yPCNDEAUU7hv3Kt4uCzh8AgIINR7fKL1fC5roQd6MqXDm/QztgNwYCGvWw8JR47KAgrRz8LHJ+nGv1GoIsrQkSNR74bwUf4PscLY7WM4/EeFgrY8zI1e/smKDF7ppCy6CuL/3opc1c709R1S3x0MB0IllRid2RJWcHY45CcfWpIexjtw6CL6ACC/6WgI5P1+Uk0odSla/FrU8ozRBT4laFMKbePo/sAiseS5PmtCanSJNl5nr/lGRt2P9R8ao0NhB+8AntrtWQMD+k+n4DR/zsYhY7i5QUbiuLgZV1B9czKfjlULlLh28Fw7La8Nl4+WKuuNe1sdYBgd9vpk3A/Lz0bwDSO7TlryOpqn9vipLa0prI74xUS6Y2f0hQdhZahDfJSLr6e9ae
 Gz1YpY/6
 Sy/5yg7Y75XimHeFx4urZMn+D3Zvb5M4SwAlfWuWm4VpIO3TmDZuFqjSvvMQDtG9p+KoVkF1jImbCs5B4S36pyJbKbFeBItY+VJ8gXqI9bK/JAGxvHt8k3Qmc7C4NAWJYX7beaY9Q60+yVNQwwgxZjA/5PcjS7lKcbC5ZSj21SN8QNB/DbqaPV/6/wqSE35+NFEf3nf1lnTnFe3VuWlSUJFgKcOcmrySPJT8U/JkQ6EQwLg7XR2lwSyH9XWkCytj8Y3zHzBmU/WJlvoPGLZHEys+FyNl+SnlXRMSSlLPOVFFp3Y0SrfZSeDZcrlztIafogBXS0t1weyDIudPfuBqAJOwiF3rgNG/0Sp52EtA3yAUnIHFr+uz4PF7bG4ovEZG1gdMbfdQ9y0Gmnk1ifqe+d44HHKO5nhDX3HQfH+0NDnQNOtGNjoY8QbaHD+DbDY5EA41VB+RNVbbuge4dqEants1AMx/v+/zNvbzidfdGW75y5o5pHV8903ebqURsoLNERRa4m6yrnKZlE6F7/MK7W8im+PLPUukHhks1OxFAUP4gkalBjM5aI8nDSg2B1MVkHg1Aa0j4EYo24LoP2IFrWZ7x9MpKs34AHMsXtYtAVW3H4txm5oiAg/oasAdSm9TemCE4dz+K9TzgPTVODBDq+krcCpOM2u9Y1O8NNr4b7M0hQFbqr1wRH9gGck8c9Bme40zj6dzz1dPl0vjfT8ZwsrQ4i56dWVg+YU7tJuBaYG6YZS3/I2wHxuPPRunO7f5mpU/IK2GX0NLkcWNGtse9iLYk2FNLl5zpv3OWvHHdx8q29QbqaxasPvDhdCF3UFtZSAir3AWKWWNS9yoSxuMBnQ1a8LlQEGSosF1JzpVuGCNDPSE5aIGHZrheSsNopYNPdUkb2GDJbz/wxWWGfF0haUGS1mm8eQS9D9xklPUNgMdcoX+LlRcIM1PgrKU8QWsX2uYaXOggDVnZZahu5GT+yQIRYiGd
 l+Xd5S/J
 i8w0427N1e4yxhDSWBjc0w88xNwAJONccPF+XVd29b20CWItAtDxZuWuiFKS76RwNRzfLan7VXCpzeuF2436FO6E5yiX9jUqFw62pBk9B+li/QkHwYzF1WcJCuczi81gpbHqnScorrrJ0AIXRrUUVZOnL9RugPXRJnYgDQZDlY4s5Yha2mZYV+3N74x0LaG7mfsWzpWFL8PZ82bJ0JN18k3ya7F2LE4QsL/xajG4TiuvIn+TarzmFi25U6IgyfAq6EgS2Or0sQXYHzBqxG+ncsq0ZrvuI5+Z/YBI45rCzXBpWDMZin15TnMAEWsyCpGXSQBrxw/Mq42w3Wh7IIcY1BQ+mj9PAJaMskoDhnRK99zSOW2ukTqzJnpEQQiX5pU1k5Nrhw+3CX1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in overlayfs for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/overlayfs/export.c | 2 +-
 fs/overlayfs/namei.c  | 4 ++--
 fs/overlayfs/util.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 83f80fdb156749e65a4ea0ab708cbff338dacdad..0a35d1a20f13fbab5bbee5f271d41f52334a9a6a 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -262,7 +262,7 @@ static int ovl_dentry_to_fid(struct ovl_fs *ofs, struct inode *inode,
 	return err;
 
 fail:
-	pr_warn_ratelimited("failed to encode file handle (ino=%lu, err=%i)\n",
+	pr_warn_ratelimited("failed to encode file handle (ino=%llu, err=%i)\n",
 			    inode->i_ino, err);
 	goto out;
 }
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index d8dd4b0529843bc20e4efc1924c2be3b5712b343..ca899fdfaafd21f4bb31807e73883b4978116732 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -591,7 +591,7 @@ int ovl_verify_origin_xattr(struct ovl_fs *ofs, struct dentry *dentry,
 
 fail:
 	inode = d_inode(real);
-	pr_warn_ratelimited("failed to verify %s (%pd2, ino=%lu, err=%i)\n",
+	pr_warn_ratelimited("failed to verify %s (%pd2, ino=%llu, err=%i)\n",
 			    is_upper ? "upper" : "origin", real,
 			    inode ? inode->i_ino : 0, err);
 	goto out;
@@ -831,7 +831,7 @@ struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 			index = NULL;
 			goto out;
 		}
-		pr_warn_ratelimited("failed inode index lookup (ino=%lu, key=%.*s, err=%i);\n"
+		pr_warn_ratelimited("failed inode index lookup (ino=%llu, key=%.*s, err=%i);\n"
 				    "overlayfs: mount with '-o index=off' to disable inodes index.\n",
 				    d_inode(origin)->i_ino, name.len, name.name,
 				    err);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 3f1b763a8bb4cb842e5d5cebffbee6b8dbe01de9..2edad9a146486bda5edf47dc60e1645d49af6539 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1092,7 +1092,7 @@ static void ovl_cleanup_index(struct dentry *dentry)
 	got_write = true;
 	inode = d_inode(upperdentry);
 	if (!S_ISDIR(inode->i_mode) && inode->i_nlink != 1) {
-		pr_warn_ratelimited("cleanup linked index (%pd2, ino=%lu, nlink=%u)\n",
+		pr_warn_ratelimited("cleanup linked index (%pd2, ino=%llu, nlink=%u)\n",
 				    upperdentry, inode->i_ino, inode->i_nlink);
 		/*
 		 * We either have a bug with persistent union nlink or a lower

-- 
2.53.0


