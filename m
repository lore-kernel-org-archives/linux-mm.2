Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4742FFD8FD0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50CD6B0142; Thu, 26 Feb 2026 11:07:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A114B6B0143; Thu, 26 Feb 2026 11:07:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9386B0144; Thu, 26 Feb 2026 11:07:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 74F7F6B0142
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:07:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3AB3614020A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:07:49 +0000 (UTC)
X-FDA: 84487088658.20.FC64323
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4F358A000F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:07:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KwAsXlRo;
	spf=pass (imf25.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772122067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBNw2TJpVq9dqBuZ8KYKuWHBMXom1bt4ItAxvrvlyQw=;
	b=x/L8JAen//bVJX1N9D6rrR8uBlTwbOAMwPQ2WNnwx9zR1+ye5DQ22PhbUjwQ66MZQtDy3B
	z8N0DapvEYlCnVCELS0g4h2442JfNjmDT2/AWSLb59ztcWNxXFuw0UgJh1+k5ArR6fF/wv
	KB7FiYQPHFhJzm3n62ibc3z4rtc1iGI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KwAsXlRo;
	spf=pass (imf25.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772122067; a=rsa-sha256;
	cv=none;
	b=c8BC6AZ7mrMGCRxdF7cIzmLGElX+x3Daiqim6UC3YcDKIxtFQ5E2hOGj2HmsXrFKCsLEc4
	GMgfWB82txCR0ocGS495gdbpRNP3gc+stSe86Hz523a/VM9q3ok4zcznM3r9LLXJnKr9qM
	27KkNm0YM+zkz6A8qSop7j4hmfQJcFE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 655EB418EF;
	Thu, 26 Feb 2026 16:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182BFC19424;
	Thu, 26 Feb 2026 16:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772122066;
	bh=87RomnifO0cL5ulL+HismKZkw+RwFQPeGoOI69KOx40=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KwAsXlRovpo0h09a4MZbAKFc9uk/4A+aQTF4aProFCmuL6hG40MvhhxJUI+VqfRud
	 O6lcHDeBshiWkZIDgRdaxnaj+C8AFUJ8rOsvkPj8ib0pFg4RybCP12WGycXssGRPxa
	 Y/xp2kWbPY1WqWMEVzYgJzKmhnM6MZrgeBQmZGeQodKg6IrAj1UkJKygD1YzzHn800
	 2KSHklBObDd+M72oyka/zzgTKj/HvjXOsXi5hwZU4h9ENuru/sXV6fqZycHFM07/gy
	 TXu1xft5ywD39PmN4it9lfO1rB+zJedqmopTLvG6GcEsbLoqlHekI8H2PY5/Dz/XKO
	 EXxVq4IYq56zw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:57 -0500
Subject: [PATCH 55/61] uprobes: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-55-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1424; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=87RomnifO0cL5ulL+HismKZkw+RwFQPeGoOI69KOx40=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0SgH+gJAN29PyQUVILDrGJ9juPunMjNerJ8
 p9n6L8XweWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtEgAKCRAADmhBGVaC
 FbzND/0RW8OwdDIsMNP/tE/3wHlHzbrhC6zVA5x3k2XukHz7HwfDr/1AV6nP0+2rs1tmoxOCBKd
 uB3bC8zaWu2bOdmlNB9AJp3YtiZ29kD1TqBZi1fg1uq98Y/F/YDGSspkxIMu+tzuTcHFRtSvSH+
 IDpK337hFool4tBRuBOST6DrvXm4ihW7o/zqDFmgaHeyGIDcdBbFcKIxKOW/ed+5ntAUUpCTw6S
 WArcCdtpB+8odYkpEtb8hvj0sWMIjlyxxNrrW4J4XRzKGcpx9s3vB00xdJzCpRnJ29X09oG9ccg
 +h4daAbfsXU83CBHtze+Y4734lKaOKw62NnpIOhMZIMYloPgKNEFOTW632ULNN5gWWaucAc/OjE
 VcXPJeL90s+LzWRjIxIqZNYEZzGcQLv1xUM2ji5x1ieTov8j07uiFW/SZtoylEhw2qKExhXny0Y
 B4T8eiCR3m4FwoK0/kWQJwZ8wkZP+ZWlMtJ7B4cUavNhFHR3KpsAajcjpAd39hYsLMh0SszZaTM
 awizdyLsgkfNtdVqMmGQgIHN4K2CS6rGe/1MWiNMu6vcdBTvw1FEWSCzJHb+ZV4mXxYAIVewcMo
 Tm+/Akh931ithtTOjIZe3mE3UFxpvTvcptAA47mL0syU01j4yq0zP683Uhp3KJk7UeNzlCO1Nn8
 UAMj/f2rI4uvZhQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: 8kx8e797bwpmnd8zgghbkqeic4qgpc73
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F358A000F
X-HE-Tag: 1772122067-72489
X-HE-Meta: U2FsdGVkX1/XbfJ+oR1A+lfg75EHv782fa7I63MgpO03mrr+PFzv9Qg1W4MFcJhWe39pbXxfoekIoELLY9LnFgscyo5swx7j8rUSYdrRoHPOgA9UMgylwAOISiXQbE+H0IjG8USVz5yIO9TvZStSqJacSAou4kBYA87qtCJgYLuBItHlobKg8+kUKaC4PR4piQYh74xSo1hEIEyPDyfi8K+t1fQV1EvuwSjlGRz3JmS3POKdSJb5F3U5ZoJz2cxuEWDosKV3ooTcheTv12Xm15ITFbHAASR6ueWPAf4ofGedvwPP+erhMTmeRua9s/QV4vMQ3KKiXZSvy6CjIY6urwrVjfvRFvVsOPcQcwxi2iYLdNMfMHk5ccHqYv53E70U45DarZQUyoM2Me4ox/J0GD6Qkbv209WFLwJvQRGRLUM1+sRV7IyCWQr85aoUyvAiuvXsT1fzfemUQjRgG0UqMVF9iKKPkrDVj9RVlVGiMnpfaaI43766zHDhFrEQx9WfuzBh9bCOK6do+8T2GoyPFoTpHz12NI8AS54LbY0T2ylSExgJo/ehBGsL8iNPifTFj5UiOipStADZddlduVT2Tc9OGmas0EbG/MVvP1vOFVdJYxcvrBSHN5qsbL5QHoOPOBxKlkrYeRxfkfnR9+xfR9j2dy7HVEUzPF/LoHJdZWSK93dL/wwjWxKgzVTISud1PSqYgwEX2hLJgOKfA40T9+q3uJCNj0nt2wOftMgGUDOJdI5WzvLSqs7nMoKRxK/vt0fhdVTwR8tM7aet+14HIhz88/Hts8PJarf0TxpuoSRJxBn9zbHgM6yOT22YJubKtqhTsn1pprRaYgvYA0AWgeD7FVQdjEuzlTvoiZiIqb2vMGx4BFtksmCw4AT6qDEVQmIK2CyR54X7ealOHeWthSGJC4pyi39QRb3pIQlHLwfoPBoswv6KdqY/zbNuNMSPg2eAc5IKGrvx3r9QmmP
 jrQn7Upo
 rHYg0CCS1D7ju2Y5T71EV0csZbdGZCGdgfoL32a5LwOnCON4rEvpZk6Jv8zKPtAtqRVXEOh8cZG8lqV+Etw+U1aWixLeExv7bw0Sn7jpHTYbF33/SDSssuIKZ6gmECUs8RD09Wpt4sPyCpxDfizMuAPZq3X4UjAqe3WEgrlaRdYaX7wzIR6LIGuBVMO9fjZw8eIq6krxigN2wvqdgM3J51mlmasvPObCHqRPRmJHSEKtC250dZ9dReX/KOrC2HyK/e2LQfqhyvl4ICweTIV233p1TGY9QwIaQc9ggW14wcs+iSSrwzDDpkOQuyMatb1XOsZ3YHx8Blw5Pzgmlq9gNZynOWvFgu9gzidGhFfxKZ1p2b0E3Et9BiRr3SwNM/ALcFz3QHLxrKkLwx3KxCxkHELrLAfZqBDa9q0gNj5OqMGgulA/7SY1ick4J4xOOLTXi9stTGPoVzfZzpTo6Zz0E3CxCCDdLIR2n2uy8a+Llq69ad/GOOnwaqaci3Qj1JKLCWsP1fvvFzoejh7cqtcZ/L7JjMOdanHpb/B1wANUCD9X64Povkf5P6MZfwC0qzmKJajcGlAotpowrqptypeo+PTZ4IOSRuqITvXQ0L6lXAXgyg6xDIqRVB5deJQC7wGtC1c641/noMiMIttSD8IJ8H17w+QhjrEytifSzpUX8DRNYFkLCKnsR2remEZoYQTJEHlQmWiKmLCu0qI5r0dGGIWXkrSmz35ewsQO3NGXYDetJ3PAC2OxFKCzIPGkTf0hJootNvWyxoMro5CH5wU3RhdT6cqqz925LcVZo3iDRCXCBW1phK0Eug+JTMW3qqtggxXHnSXkiTa67nNvWc2m+tTYfcL3hCYydGr7PMrYO2nxZXNKXPbHci9gOoUGnVbLEmXa96MsslhKOPUWpyBFG/5G3uCqjNr5dIjhstXAy+qtHkpGsIinBVN5maOiWdj/NXH1LcfzOsJ7VvvUbQ4s2OSRi8APR
 7kMlpVtI
 9gxNYoo2Ken7MwCDfXpIy7+xWjlBgR9bS6kJHHpJgox0sFiXnfLpzegWI56AyXf78qorKkiRYqLk/2PrsohchcEtzUMfCnPJ1/HmmQL/CJN3FHuCJM2XGAjcqGsVMduqfGz1B0IGHWsUEAs8303Lvqd/NrKrGdcJvpQtBDNHqxs+dFSrADPq6DkLnZ9/XwfZ/evCXlyNEnzmA81dt7+fy49mhxhS7FeGcrH3UdcM8Vc8cIzI/RAIsdfV9oEvJ+KsPmgJW2RLyaXy1cUkUxuf8iGJb4/ntBALqwOSOVMW8DrDJ2NsavfefB4p32lsSN0zGPk7/gNRSssWDPN3hQVBJw75fdnV2wvQgsGCPItcEUj2PXcYkFGcTMvXExZxjYeBFkuexXmNsJ/HtRYXsuGMY6z6IYbh83hU9zPQiqXpFQ+alY7s/sPe+B9QH9D/FUX64bRdboAzAb0CfGT+QCQsk4di9p2yvtgJiBAPTt/Dja07OO4Z7EpdzjxhGB1oDMnNbtJ/1VzCqs35jNuAvzQe0rdhP36cL1Q4LJKJZY8/mMjkeEsm5VzGZSzBbOsxVStszsqtlh8u5QEjmZCnrpNbPZtHC+CMTrldyDI50nQqquNu2oFuSriFc1KrmrDPRZMjAXfZvCoSZEx58G2OaEQKdu/hPrG6tz461qLagq/tbYwAeHghiDhyjLIVRHFu4TUKHshIYFwnblvBDvubF+HgTB6mkgWTxCH1hJbLgGnbrD1YZ37Kd6GwP+aHk3QIXrNcFyjBHNkAQ/4dnhnGUK65rhJa/jpG7v7/U1u+K6GG/UcV+WwWVqxNJDNwxyb86sePHNUud0rVjeQHKx7FsFf7p1BTgqUayfVcWzTPqpWO2y76Ps+Np9BTa2rine4+abAxNVAzvtdWXm7Dqoh+bufmgkwn44K/oN/qcc3icPpKWRUREo4i62WmSBY3FLhBTd8k/aDP9tx/eW0ferYymJ6a8XjYb63Na
 +WgeeAmB
 /oZVtQ5KKsiStqGwVKXWpzfwhxvV13e41rk8JKtiXhDxwb7A6FSRoF04/DDJJDfKMedWH8rsZ3MrgbR9RSnJdrfZ8AlXnSRjAp75/izkVE6HCiotvzYSD+hvXLd3/Izpjh/cVmiJH9ebMh18htGAO46tB+0A4ptY6j6+zw+dKPwzqQleSXXv9ASl3seSDUP3t0OFnb8Ypa511a7AUKdSwjQ0rI4qwwJ8LFjiONMZz9pVpePaSIKBq+VbwVQzbRh7kITN/GnrDwFDCGqzmyuzwad85vrIZTSCFo8p4Ynv4c9BQIgC4j7IZ3/gGR1lsh5zpKDjpxooAeAPJkPiVHc0SD6+ghQQv/60TAc4+PQoGDO8cNjZeV8RHI/Uf1t2erbsq9d3qtlwoKiVQkyegBxeY90iXsRTVF+hQ39gWNdy7RRYZX2f5k+f/6TL4j2FaNWNatESfKXAp6CCTMhhTHf7pQf6taJBleSg5BLlBxu0tK7wRXMErxCgu+Ip0h2wIatUOicyKqyrnSrGC4KDCXgqHpKliBv7aCFz4qQLES3yIQjrEqSVBpB/LhcLB08DoT0vj123hIfveYtB+5uBJxZeMnk05OHnboQhrAqPzHRFuGPQsIuyFB6E2fbtYJGqqfJ1MO7tnEZKf5x3OHAW3NrKleYxAu3qmBZIV20YXxfG09Brr9RVqCtlR2u0eVdinySlrjE6hvWzY/yQrXURnF8sKq2UUE28c1lON6pJxwxodYY7Kgjh3PSlrBmuOnjY/KMRriMu9E+F/f+0DCBLWFX5Yc9TuLUxOwQoxSWqzPE/kwvF4jGNnJJhdVMTT+QmYc6/bl7xVuCZH9rnXG7Td6YG598+wdNntOmqQypbCMxzyVB/YraAnOzx5T/28983bi8bxEsYJ4N5smK5MMBP+G/aZH5wRggqMnUYwq8c7KrGelFBODZo2792Hm+2Zs+KSgCiW7gPzyBed1I+yFwQHdAZFB3A9qQLz
 R3bcOcgs
 JOlh7rVPrijKSdXdGGGNcAnb6zcsdwMe14hLsYsAYeIJDoMWplgAWjO71Fky1fwl0Qg/ab1+MmDAJi3NZC2X4npuyzXYjIiyjDxd92aZDAkbMhO0kOQB3FnbGxs+UQU5PC8IMF/LWn68GtQ6zQ76kFnj9+wuvfqWJsW7YSCm/E8lxMC+FvMxblqWXagEdz9y6ObhPXjWBu5v/4XIr7Uv65rXtoH8N4a6VHoIDAJVX07gaAm5a5QzyOD+tiWTHO9EJiiTfWJYACGwGAWy33v0IDqYpzB5GblYsTArVuv4jIU7QTQ7qL9WYip6iJ3UmMwy+7ww9L9naGyRDYX9fvnbk5GEGggNclIkwg3tNNsD3teMQvVrwguH7Ck+wC0ydeJ2o9Xcd+NC5H8TLz3FSm3CyR1byLprq37Tywxya7fYD8Vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update %lx to %llx in uprobe warning messages for printing
inode->i_ino, since i_ino is now u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 kernel/events/uprobes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 923b24b321cc0fbdecaf016645cdac0457a74463..4084e926e284487ea7e28b63721797b20f0dfefd 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -344,7 +344,7 @@ __update_ref_ctr(struct mm_struct *mm, unsigned long vaddr, short d)
 static void update_ref_ctr_warn(struct uprobe *uprobe,
 				struct mm_struct *mm, short d)
 {
-	pr_warn("ref_ctr %s failed for inode: 0x%lx offset: "
+	pr_warn("ref_ctr %s failed for inode: 0x%llx offset: "
 		"0x%llx ref_ctr_offset: 0x%llx of mm: 0x%p\n",
 		d > 0 ? "increment" : "decrement", uprobe->inode->i_ino,
 		(unsigned long long) uprobe->offset,
@@ -982,7 +982,7 @@ static struct uprobe *insert_uprobe(struct uprobe *uprobe)
 static void
 ref_ctr_mismatch_warn(struct uprobe *cur_uprobe, struct uprobe *uprobe)
 {
-	pr_warn("ref_ctr_offset mismatch. inode: 0x%lx offset: 0x%llx "
+	pr_warn("ref_ctr_offset mismatch. inode: 0x%llx offset: 0x%llx "
 		"ref_ctr_offset(old): 0x%llx ref_ctr_offset(new): 0x%llx\n",
 		uprobe->inode->i_ino, (unsigned long long) uprobe->offset,
 		(unsigned long long) cur_uprobe->ref_ctr_offset,

-- 
2.53.0


