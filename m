Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DA3FFD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01EB36B0147; Thu, 26 Feb 2026 11:08:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F15526B0149; Thu, 26 Feb 2026 11:08:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF72C6B014A; Thu, 26 Feb 2026 11:08:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBB0A6B0147
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:08:26 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E054B8100
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:08:26 +0000 (UTC)
X-FDA: 84487090212.20.69583CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B513410000E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:08:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k5dYSDIB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772122104; a=rsa-sha256;
	cv=none;
	b=zVMDofZ+ow+xlpavVYO0QKda0wwLjdCo7V6ifHooUdbgHK9TEN03d1GM/WyUahjoozCQPX
	f8dSswS0Ld7gSJIj3L9oqR6pU0b9kodpksBC5BrVWRHl8IssVl+xbZhvpHKmA9KMMUYx56
	oizShnyqLYeqEv82sWMJQ+hSGIcpZ04=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k5dYSDIB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772122104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y6DvddIVJLNMey0h1CCuTB2r8rD+LmKag9tJBJQAQE8=;
	b=CfHY5eXCHgFG5dsNYSbaP1tef3yWaABnOlulV7Ebrl5EopQO1XPU9vSV+vvFSEdhc70d0w
	1XqG46n0Dg970BFiuIBczxpWnA2tELDd8niyAG0sP75RokjyOQyhuxVW3L8NxntI9+OcDH
	CxMiOaqSJ8smtLsH0ths2zPnM/TxKCY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B8492403DE;
	Thu, 26 Feb 2026 16:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6370AC2BCAF;
	Thu, 26 Feb 2026 16:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772122103;
	bh=DKhApmyz97hHNqRDBfnn+HmbPok4RTPICktaKEFjeAw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=k5dYSDIBAPQzqW+BguNSbxXsI77/BBR1Zqkb2GTl5B+wNZoLV877xFojJINgg+Hfc
	 UrOVLQI/YLOUBa4a3ST9a0Igdn6L8rKk+lTiknPRPXqyYw1a4Ly58655gQuh8GP9Y9
	 rs4kvUwYSS+RyO9nii4FBh0CFg9GIl8SJdAnjcjlt/dTjcLvW0ePiFCs7YE0MHvU60
	 DC6hyGIImi5K1WDNQGddQrz0a2NwQ8qfapAn52bH5aHlz6kpMX6qiGAwc3l5RsMMi5
	 TWpwAqf4c35siWMewXwkgGem7qGmVkQMu6wwPk3bFQPYe1ZnYG7S+4zzzLfGJLMoyL
	 yuwTxLt9qHLnQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:56:00 -0500
Subject: [PATCH 58/61] fsverity: update format string for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-58-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=793; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=DKhApmyz97hHNqRDBfnn+HmbPok4RTPICktaKEFjeAw=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0ShJVaxVP99hosE1VCTn8mUr4e1D55bkFMr
 JLwUwTrQ8WJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtEgAKCRAADmhBGVaC
 FW1wD/9n4D6Ggc73Uc+iboQycTz+zQzDx3YB6SvNvw5tExXkQWrmbQHXWE0jl7c6Vv/TMM5TYO9
 XX6CptmWBNF0kABjqGkwrvHTDy/oyVFDYPaS78W5JcqRlHO+So3SlR23AEn9lhJAdZzlSzuZq+u
 HzC3jaM5bQPJnbqqli463SyTOrMsBafb9RJYiHZJQsFE20MzfSqd5dIHjuKKTjil+qsqBx0H4vj
 a3jlcDRGPwnJQ16+G1JcSgAbtFVslpI/FpVdkpOQItQ8Smhsffm5rqsWL3rKZVMbbc5+nwn4s6D
 a3hxXNGxqd+96VN4BQUZ9f9pUlGCJOuj7Kc9nTOAadOsCObc52ugfbdTfElrTl7JLLTMXOx24SL
 IQnmSBSw3tVQNQHOfdkYiiHKD9GjmZZtwYGU/X8jf+c0cejzd7lqJr+1k24qEFL5rNA8EicGvmo
 UhNG0XQ7IWd9ji4Tn1Hnjb6iqL1cugOk4rx1ms9l4An0V5SjLmDJDtl04mdxf+3CYLhw7zN+bXb
 Tj2y70Cdw++wiRSHr4B+1EHhS0mGBjuy9GC3CImYWdDJt1sMdK46feI5rvC5EpK+O7++Boc36rL
 /5Z9a/w9FwsXha3/fp8uwVNalc/hucFqX7HnNt9MRtb3RIMdwskorXYS2D90WUhctvSUvMRRbM3
 rmbMtROf0z871BA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: jo1eqhao1hxy188whsp1uhynja59srrw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B513410000E
X-HE-Tag: 1772122104-948152
X-HE-Meta: U2FsdGVkX18LZphYIyzPpOw5VGCFL38t/f/iHzB+5I2G+KtqhIgEp/PgIaMrS5dqZdMvsa2DxKhx/N+PwjYE7umL8ZkvmMyXAlvpMx3LL7P8ls2fD2NIZ6DrwTH8c/in0bxohxi4pzL+xgqrSKLF7Jni6qIEenC9V3AgH7OqIkfH/CsEIgeqx3LTCC/VI40q2LLlulfSHZ4/tq5OC9JkQ0DDkrWrKL08KMZQfkft9+FQdzJ3nAvkKeAG4Y6ly1cHdgv4E4r3YYHvKJpSXavpSCqNZBDk7n50oEcJEskmjRDRG9EqudWq86O4fMaDgONgv9pVtXlLvTMjE4TaEAyjwPhCIxSs2ps6z93E0/Kwjts1z39t2epGfglWxLO1pEISl2qjRU4mNGdDi43F2XXmoeXyBJ8bu2xtNjkryyUlw9Qyv1Znp7bDrIl6vVWm3YZf2sS4nGPeWXUE3o4sXq2QkHUMEWWB+oQTcMePHh+IpeOCz6nw4XNazJ8KH1NGOwb7JKMirQQ8w1q9gWNbPxZl0QtEyA8zzvPhyoSP5v10S3Qge5juHr4fxHAynAM7cgawedH8jrJjDZMyo9ZBfz9EhX3WscI8xwHiNXwtffmH+71Z/KAQAO4fEoDRgUWtEGBw+opNiSgGZuPF0QMQofUMgaYeJ2e4TXuUAAwjxBodPiQzzD2dgloYJq95GxspvSfuGRxcwGs4KCmEawBJA+F9O9ysV9Chufu6QhjX+GjijiLKEaLuhKDj9Lrl4gRc97bSdCfWReMnjQVDFjmOURPqpvYUizyy4ASHQXKB01AH4TsZ8RSbjj2j6O0lAm8DOBMdL4pK4Xt0KClzptYhRG0BxkXeVuFuurZbMQe0oXRUBYA/+wdqHv6mRyQlzMr5QNGV+53TCFOwqOcyPR7OfX9QjPeDUqN1dhTfYGfOAa+WGkSFnYe2sYXbezn3fSValLKHRaLFxXnDeMZu8bBvTMt
 V5zLavka
 H6zWJ8anzUzjc0qcdSMWiR4EwPn7jiW62MLDvdi6MaEN0HX1sVM3sEtFfM8mHdq8MD9+OQYtvmUZYrp8dPRXlZJLP8SPN5bP6h13M/81SYcboJNjjKa8ND7az/viHgt4HXbPNjZ30i4Bmt2OJ1FPtRJ+7Ql7pMiGWOxywkbkTyfhouLHtNUgcLPhnw3hDPPLUY4MuvE+MgSG++L9Eckk0oA72ABS0TowHlTG0wn3yfIHwETIQtIXBgfNJr/D/O+pWdotOKO96I6q2t8UbyuIWJvamOsbIF2nk71DnuMTV6WHNYkvwcK5QHTROZBagUkgcjMk3P1I8oDfnJ+SLKTdOoNBPrjMBofHwFhxMO1dujrQ68FYvhWfP7iZF+/NzRSffTetdw+V4TUiaGLT6Hd0ZL/SflAEDrlPTd7tx/CXmZfV+x+eGMOHiIx8hcaZN9SMcL4CPmiLSbSwtpo41DCNzM5PbVroC/KKi8OG+jzacv2YoCqQPtLIR3ud8t81fU4e0GNc43WVRmy3VbREsHKU/NuVk63YmEbkM5QuTFxNJbbX3nrVK+IOJsqWQQmrGR1Rgu7r6wJpJjMSGs/xWHToDzIEoPw5nBHYzCIBhuTdXWhvavlogFf6Vusn63+RAQdVrOtlYL5BO0asvnY0wwUYhMuqehuNKJXx+AdsAQOsyWP7TdAMsaccA1b+CeKonMz/3a50nGE3n1yO9haQt/Nq+KP01gZ9xMh9s15LJI3PrCnSoP21rpKfoRgkAIRsQP30raItDlWyBJKac0xQq/4qtTvpDVKlQQuKZJh8MbrfXsb1UFZkfszDNJf1+YMN8pXmiwggEL4SXYRsJtt+MPj9KGtsmShX6h7/O/Mm4o9KgRJSc0Sk07zAruN4+nzkCr0XVztfG28gQ3qTTsFhl4is0h9n74xeH5PnRL0mY69SBc8tnIyLRwux0lQ3QZy9PZ44+JlNcNZ2eUrdj41H1AWV+ue658sAh
 6z6VoKC6
 ca18FAJPDk9awRCThl1d6nVxC/zRjA0L7kv7nKJtVZxeYakJfCCOkdcvtCPovE2OAv28PTo+PkXtdYRVWEMfVohszCfga/ZL9bOgz/RWPeJBgvLctM7zXxUVMWaCBzywtwEa/sUEeVtaWP7FSk7sk7RmO+y8oJjASFzy05ro4OlRp3btHCkfUZvCQAMOXcqlxW9beV0/C8DfJxb8yMiP5nvXpnSdK3ddkYxeC9urRT2+JtxUl4LKXCnln2V66mWIDfGR/Mlak3GQaoerzsyFf4Ha3EVvaCcu440DcIlLH2vUYE70mOlFwgE5ifYbiffc84EWpX5TQAxh5f1Vw9GjZDXOM9q6au4yHj7Y6mPbOik13qKVMIVf5jufEIQZwug+/9lm9HarRR5UKQZ+i6rRqMHqq/4Dvav26u3lShjns8cTAyC2BxwkQt/BUjnOjODc4tw++CVSoidNy5nc2k+tytBsx85aTnkzztBJdJ28A78YwalBJVjVa+la32J/aaWQQxh2PycEf9j0xOT3uA6yXEpfke0FgUhrCuz7FrGs0cDPb1b4AcwDJghBzCSE0mZvciyWiTZOTpF0Yy97oHeJ7gYstzHFzI4EKkzOm1f1orLpjICiPjMcpF5OiMXsRBYBoJJxISVTTVOb2X8Eajd/kPJkF8/ZEzZFt7wBBeiwuh71q2dFqErVUnTn98o1oZ/IzgLwICCO9UV2TxVRqzW3F5uBlmtHw3iKSYAKf2Jvv8kJlzSRvlItbivUctvvkbT2P6vfkTvbWR1S82qn3LrHW8HJdwu7EPL/De3qihTU0lSZNWUaSrOw/DuOgg24fcSy39xB7kNhjPktmdcoJIkGCNBrkNdKa90xI4bqPEIG18gnbtGaX7dU1aOhlsX98APToxcC+xlTfA7eWlDgy3EScpK1C/Cs0LsT9OFRri8aXaKCXme19ZKRK1oZ7PYAipu1I/BGbyhXkjh3+RYjBvoXKkGfdP/q8
 OBeIYWmT
 GBgIEVDElPWPOypmNgmF/qBGNZN9JEC8pejrX47PWUr9arrvyNyskj4vGzOMgR+842n6qVxhYOd1isNkj4wzWXd7evQ8dPpbIAD3DnpW9ddY9e6IK1/jvNDuPWfYYK1fnJECdlGqtDt8eVnZDsphebeHGhpFztNXozueFqrufTNMQAlX0z/GhAHDDzMOxZ4dHyb6Y7l1X388JvEC44P/OcnPJ5EjaSQphnM+pqhpTCYuST7tbsVSfj/Ykgedeby2Vpq9jA7sTejXBdIrzg8CgCwuxbQSBsoZJBsp90ROm7TvXC/wm5QUlGHBb1E4jfQFy2M+AIxXGPlBwGs2nU6AwamJe4bjW4OVV6bds3twts3mjsR1xsrXrjuRDFrhtKz9dOdE5hFKItxKKsD12Uhn3DwADnGQrB5chVxCff029gldVi7njHF133yy7WJVYn+STkHxOSIQIPq6cWUU6j4F+OO+hzzAZLEsOIjYD1rP61RBEMCP8aqHlkRLjeVuHozLErwdKsJcoOeemRp5XURVHrZjseN0EDYMkZGkwa4gQn2hXL2rv9RO67F9wRSPAaofp7yfVmW234W20Vd3y8Wuz44JjkHalluAPs4a6CfVaTigvRyyOhtGJCnn+SDI18fZgIUfTQ2mH+kbyjn5WU8ybwNVx/4Q5lgbBtQ5lsInGUv+62Yih0xUotZXcbb9R0Enp8lDk82O35pxVKyTG9qX3C6KOC4V3J6pK9hxuX5dCFaEF1mTqG03Bl+SRs9ifThSoY70CgYrZDYHlhsEnWV666wdl+MdN7Y+dXJnFutc9Kdg1+QZJX1/FCz+zW5CXm8iDWr9yvlVFL6isizPp3DJzLFbiAjo5gVXmG4xMK6/YvUtnXnqZJdg1n5DGwH4JkxfCGfem2dCDEKoNYvOF4TurhIUSymQOCAxrhEBudt69TIxPRVLY0Q6kemDwDOSGm22A/fM7h2+AETBRY8vscB0ZRw6/cRgN
 gCdWKM8X
 IwO8UrXyUK5N4Prlvekrw5k1Nwd49aSyyoy9wlq289107GrT88d9qD5WZW9x34Tqu4jSUrphYJTobyJegOnU76FUfUlIZAPw3suhpbz0CJwAd7dpWHkgvNvOITNgy4cuvkARv2/a/azRNH+WibWOQH/eIfMVSUmLI9Dugc7YVSfdOdtJ+gVLRmroMaAB3b3XUTP7mi8aOeeeMrjLn/ZU+HIxLx5o46Juu4uNunB07J23wVnYDBBEuo9MlweDMtKyjT93W+2MVb6Ra4UEsBwsjrBJ3PEpieM8+rTRzBfnn2ZVoADuujVTzzahi6XtEz1DRaNEnFrKGSVgp+C6K4B0tZp+tiI1X1yKdEF7WfPKNWXX1KvnZc8CjM46+58w2o0pGRHIwLpf6agA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format string from %lu to %llu for inode->i_ino now that
i_ino is u64 instead of unsigned long.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/verity/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/verity/init.c b/fs/verity/init.c
index d6520660858386d3b7d69b20a459dc27d8017a5f..3aa55dec88fc919792a2cb4be476f8481ef78a9e 100644
--- a/fs/verity/init.c
+++ b/fs/verity/init.c
@@ -50,7 +50,7 @@ void fsverity_msg(const struct inode *inode, const char *level,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 	if (inode)
-		printk("%sfs-verity (%s, inode %lu): %pV\n",
+		printk("%sfs-verity (%s, inode %llu): %pV\n",
 		       level, inode->i_sb->s_id, inode->i_ino, &vaf);
 	else
 		printk("%sfs-verity: %pV\n", level, &vaf);

-- 
2.53.0


