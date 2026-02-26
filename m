Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B71C9FD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 212EC6B00C7; Thu, 26 Feb 2026 11:02:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BD126B00C9; Thu, 26 Feb 2026 11:02:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0888B6B010A; Thu, 26 Feb 2026 11:02:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E5CAA6B0107
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:02:03 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A51CBC17F6
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:02:03 +0000 (UTC)
X-FDA: 84487074126.05.D6F5AEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 578E510002E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:01:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="e/I2LrAJ";
	spf=pass (imf14.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9xRK9vrD5bwqKo3Vjx2T4RMzsjJnkRCeoYa+7MkLmVo=;
	b=y0WjBvejWTQm2cyEU+7zo+Neh2RD5R2pT+/REHR6/8Ej6ARmnXenktW+pe+kg1D4OGUf6I
	64eJmD0OO/67FqAq/rMgmay3zL4AntOX5ZPwr/RFoy2sTD4kXRGlsFOHfIH3Vngmpw2Ywm
	84xr5af6TFHEtn/PGY5BvhmBLgyYcl8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="e/I2LrAJ";
	spf=pass (imf14.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121720; a=rsa-sha256;
	cv=none;
	b=TAnKFZHkHzb2dbZwWUHK2T/JmYCiWIOh7bt2vkT3dbRh4d34ipYHNOIgH7RkQBVZmgfU3W
	ZonyXfLZORucx1UMCfDcUtDtWTCMynT3nvnt/HPQd7jl7kAApsKr0BW+2yuQBVb5U3lmwc
	wz5yyYi7XDrAUrNY7rJHMk9volfnRgc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C26A66183A;
	Thu, 26 Feb 2026 16:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43023C2BCAF;
	Thu, 26 Feb 2026 16:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121716;
	bh=9N75YU8P0Dg8THcxQbWno3cEp0CN0prbaNbOwalVkKM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=e/I2LrAJtlajRHbmApBBp9GF/jNhQdIGLETvtCEnAzUVUtba8QK0CBGWmV9htCT6B
	 5K6R2idub7svbh/mw9n90uNytkxvJhgBcffgrIRhIGuivq+iId7ayUPqXBP9t97MuZ
	 hkBNExUfd7etzo5lfzZThjHdvIm1YRbUX5Z1AbidHk4Fw4nsbHWhOsKCZfW/M7qyhb
	 hneHLVlhtGFZyUxwo7lS4xi78nN/dh6F7R89m9Q3zlwhsUSWW/9tgRo+NFkkgnzNHw
	 xTOAf1RzdTLGgfXDcrDFUDU0cG7V7OPS3TMg6/ofg5003GN/je1prtytpOmOVqeEG4
	 Q3G+ILuBFRJ6Q==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:29 -0500
Subject: [PATCH 27/61] cramfs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-27-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=848; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=9N75YU8P0Dg8THcxQbWno3cEp0CN0prbaNbOwalVkKM=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0LKMgHR3VVeOoTBTGq+UXxZ66ksEq5R7ONd
 Gh23SbI7jWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtCwAKCRAADmhBGVaC
 FVrMD/9TPlMz1avJRvLzXr4XKIEyTKJl0/n8qdLwIZPVmFSra7fQYCR4nDjNAbvq5t7Bj2uG2Cg
 9lPaebAEBXG4NSa817wFHm1WkeiRdg+Dtjx3vXI3h99IhKi7mzJDHs9k8j3+1dVa5Y0uoQXr+w7
 76aaK8JGiMxxskZboMpBrNj6Mq5ZMfcePJwS72FB7z8WeW4PdvpmPIdfyjYi3/VBZ1PcGoDtXfC
 Si/m6S/FBXgCO6Wt6m3vYLyu0S5gjlMbi8Ijjd7wxo/8WsfUGfyDVOLIM3roFQG+dU+tKjRYEhg
 CMdXUOREK+PclQtWurWUV+syJ/U5vnceqvg/4eyRMTCUl5n7Qemk9BkCZhxsQ1+jC9Rxddo+kJi
 f7ntEzDqc3eljeIolbh+kOcaIRldz5wW25WozcEgrP2HsC1+u+kakEE1qvMHnlG8RUhoSYHW7Wt
 GAOX8NuIDfK3uf9Uc+UjIvO6SrZ11bJXx+/P3h1qtq8h7ohU8d8ulkJiE6b5KTC/r3WCw8xl8XN
 8yCBV7Pdm/43xeMdxScGgd1dtuk5ToxVONwc4n3begxzyEurk1ereoUwZKB8PVBeYzoy2uPL2CD
 zSkFIpwncp2hQddaNxedeTnKj06KaFw7WntckzTBbp6Z83UmktCVtZEREX4F8KOhf93jLcVUQeI
 TUYSztb1qSZQgGQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 578E510002E
X-Stat-Signature: 9741iynane6pw567f41okawkywbjjeu1
X-Rspam-User: 
X-HE-Tag: 1772121717-74557
X-HE-Meta: U2FsdGVkX1+pYcYHVY5VxyK1OfD1I7l4qTS6YXKVQWNTjsSOP8Gd3Kul7lBkAis04IhLjMy4EqI56ddYVmoz1cQZ+cI+TjDFO4EL5YWC1lKWtEIxYF/sp8iyxZzSTEUaKA4qlUtSE109oM6nYQrohZVqxktcroMAuyhhuCp8WwEffuIekRuQFG2uLUrPr1bfhN5cJg3IqJC+GGEPJccpq7VxVzt8D9aPBVQzhx/81QtebGrHjwV/XfTQL1l1TuPdTC5pA/Uyo7iVA9X8Pc5s4fSHW8L+CgjtODVNiqXBg4BF/GZPkOqDyjseyD7Vzhn6spWm5HZnMWEXN7cc8Bi20KyAruo0Q4YRuA1mXs9dzb7IE2HkS9ujMHWqglYS2BQuFPMyqmPpTHEnTC9eM4fvKuXi03lPO6N3HCvhePeI4OM4pnhexD3roSwBzKD+sWvg/p9OEOsPuvYWYQx2lE42gVhV1BZy95wRGFYoc1hlF5/z1mdTMDbLnS0Wwc/6eNtORsski7UzZfwLRGZ2YmXwdYWAd4h9Yk4mGU3P9BwI9tr1TmOCj52fvYuTxpAp9mfkKr6qiOuFUne6R84K58dftfCau8ESmGWAGVBQeZx5AqBAccsFw7rcCJu6J/LTDrjjPJTuBFVm91yelNlwX2Zw2B8YmLNpxCjpFj97HWTISJp6irbauNaZKJ+4Z6Q0R4A3zsC0WBMmuCNrz5WE72EYBCQx4ovEpAzE+OvJlTjewY2jYqs/ttWfj2EzQS8D4sLRgnmsmka62oQshj0qBFDRc2M2AxAjiJach3uYUeW7ho1cLC1YZQITk2UKpnxHa9cAPzxMqY6leeX7IN72wzoQlAwf//VdaqRALOoAWJDTTtLOf2BUf4ehbxGNeB2SvRaNJSO6RYT6uW0zmzz2DDtmF7URK+30b97M6aBq1eT4PX+vBnz70uLnGZz9d69189QKlh74Opm1KYYx1skQzFl
 GPSOIw9J
 7Zt6FNk1KQnnrcGI0MBGuF4IOKaNHFUn0uKDT+ujTxNMEIfLn/MqlUzo3ONpRyIBNACK0HknCWpBXrfOLJXRIvkXp1VPFzgvy5RZzFx+Af/rL7uFnNmMqWLO47CLQgU2nkX9k1C9BGdagBnQIHN5Y8ML9hAZjCVPHxcXFZrqIRL9vmmATa3F03cNFU3A7KvfIxNoYTdXy2aRc/2R15lcJmwufeumMVvYN7DWr/XOrfMWziPUMvV6eCjAEqQ/Sh1M4LLOH0RISDeYKRu6cgB7BM41R4tqvKXLs0NUTrFXPB916zSl9dYhdXmzxEA6JWVEEO+zR9OjWEoMsjccg7bKjqVmjysG5tCvwrY2CYEBx+mbjmMi1ZzTDfRpiXRSqT/GIHBHAzmLwAdiYDdglSZjQzaTSzgz+UXeq/pcBENLmfojzFtqkh0F9LzfgKDyWXQ2rjlp3cVIPKf3aVpVx7f3+Gr8xlzX9onYFcRCmDWGAGXMtXG+kFPfBrKJloJG/qku4oSPNuUko7Zke4an7oeIOkuA4LSWnzmG5/wKIvEb9/jvQ8bixg8RBp3yf9kQYZHinOVSZH3hlo13sOd/Jr4PmBWDcYzxcUQmWVm0ln0003feFequ689gLRVqOMc3u+O9kqBk9JpZwB8X0oVKZ/cgh/cxsp8WBvyU3wx0cGEVQlQv9rZXu/ie9rIFKvQmDdKuEGGK0hggnIKo1kszUYJbK2IZCgiDGoIfTfnGC0bcLS+xWlCZRzsTTHZKx3fvlYM8OlIhSaF44GsucYAtW1VAtkVtlUUdG57v5R1Eu72Tsuz5iClf1eme8b5SfQvSz/MGd5gkeFq/WOZoe0T5vyebap7yWZeg2L4LzVM9lq7Xxe1D3Egg8ytB7k0P3zGXL/cb+5LLljCCbOo/PQxmTEVrwaT+772ot2UIWEwOBaywazvJul292LFchpOVOe7ASF9cgMLdKcR5pskZjczmpaYMQklCxwHwN
 xWGeUiVt
 DtAB438rO9ui6wJm8/DfpsD2y7gxlhZZ/569m+Ngn2/dLGaxy8hS7oU6SLEX6+2ThMsaQ3VuwOCpi8j6/4gjicLCyLvfilR8WQf7QPuklLIY5aNfkFQ1d19qoOKzUA82KVUy4iuaDM+w7hcneHEOPj6t4/NWWVMHUus6e/B4Ob57nowxTY2rWePbA2InAjGQ1+vjx+d8YfgFoxdcY6iCj5o7OmwCH/W1xTjcJEiMf/dotfKq9FiJvmZe4JK4g5PHYGo5Y2O1puH9KXLvSpN+g8xPvqG5bwNs/+FRTCOEiWu86h3Nasq4A0ErjTMGA5LEj0XlPo3FsKWhz1YTphonCOe2S9h/fwJGSGIIqHpcVXRcIg0FWSHBqD+XGmG2gTfC42Sa5OAAfYQlRnvjwp30Z5QZRzZmtkrwRIn40xkag+cyyw8bIQ3GtMPSTj5lSWbO/2Ne3hebe5r+c4QzDqoaDyBIE44Onw975Ki4ThIo4/vdENzkfVfVNDCvS3ZKb6RscDPFfWTtvG8LP9GeOCxalp5K6IWajaatRYSGnSkqTbk+zJ0sKaHL6sBXioo3WZpRcMCk5r3agL+zQz1n0I6OTKuijciQC9OE4foqOEvqyctRNfA+k3vVXJ9kTDq4kjBucS70q7dGOP9UppPnpSgg8Olo1Nl4MX0ncaW1viX1QeYzNuEgq07/j8sBVIpFWV+vOhz+bwF3i8WMEoj2XcnULTWbUGqw1acQVz3pIModSrzUJOFs3R/76dIViRqcHhP+ubP8OXuaOkeMuRUDDdWxWNOZczf6803Ycuy4vqQS8Z7VzsR1KPlk8KVtg97GZselpEXA8ZHucinzfaqle4dnuSqwydsOkHiRDIy+2R6uXE2wsfjixGutkVKDlWX13W7ZrcSB3gg1EQIOMo4b8I0k5yrl3h9gPTIymMWcQ6IwquLG8SC6mqb+WXBe04I8nVMU+zJ4Lu+8+CjMmTuqc5lem4EsBUeMz
 jx1fsWow
 ZeaYTmVKkask0LJ6TJ9LbUxZzIvnzOBHTbTDqv/SjHKoNHqLXa2/9QZAKkK9KFD5mbRU3LGwzbJNhLqdyG3Z0iAnVrVh18iFHCcHGhbPdLmSvdJIp2fELEvGxHGiRRbJ5wC8h0O0se3tX/myGBQxg/cnlISPw+ek4ifut3e4xrpxsDixXEW14OFlNBHtZk2xZNNclvLodvmy+Hm3g0wXrJMGk1Y/kI+NF5HB3acPARJH/Auxi62AelO1bXcJsls+8vDlcLHK4z8SdeuWHXlRGF8+s4gieQmjrPXOI3fgPTZHMVyinm6YcLd56s3oWvc8K8jcS9dzP2LajLnBvUgEAblPlYf3+0H6QUbP3PdTeU1FLZ+3Uq0T/y5yg1Mjw+PVaY9CnyJ9q6qU3Xy0aLtvSj31Kdj/wgS7sQ1dtqi0czFtqgIp0Y2FSaRSPc6hSujIwjrVyL+s2zzrpR9Ml2mNy8L8diU1ZdMTDTYvvR83uj4iPGC3jir6z/xpnen5PvhmDdwhT+OXX+9GQA1VVgvfcYV0Jz5UNAydRAPs4zRjj2E95i6dUwi6MK0j0R3ulVejTcQ7K6JRxHLWJpiOFtzJmESVoYFYP/FT8jrOZtqh5gMBmaCuajszbxOWP8NOr/+Av5EJpHeCG0wonQ/dVGsHjHZuQdHVuL3s1TW1J4hLDEUM4YNu2Yn2z7PoxFOu0+fvbAVReRatkXH7tMe38lst4/1hfAG8xHpD9rT4k9F0WXP63ytRM3oAy0c+YisOzstgTm46sR0JgT5PXKLM9SEvvCJMpx1ac84R3g5aAzUH/J3uo62+kRgtga55nLk5bpnft3pml4S4GUGiA+c3UWYPl7BV5j8fVPDM4qJnqpnaxyfJgYmBnyaWHumIBqk7+XJ0utXlh+TrQRvQW8A8LXfexiWEzgIyKstBk2ArKZFNOB0h0OZkhG8z7Y2gvZyk9nGNtjhmojh0hwVwRxZTSbUI1t4uBgsGq
 oGCG3qag
 vuOZwlQzzGsrtZ/5lQZYngxq4iOyoBWB26q+8b/z5jeiyZRAwpK9JliZJ1YW1vWKk+ElFj4y0lbWGS/gCQaPD587HeA2eBIrjtdHBGQSPQWV0sEgalZyhMxk5K/tEYEZSBFnbUNTtLKaGxviKTKEgEt/Gc8YPTfCjBvK5CzjgaiHwd41W9TDYoNwCV1J2NWYYY/cv3dOGKoWgCYNayiR99rY3MAm/jmG6z0bNWm1n5jK7xZSl0PomVPHFagxXIqj2ynGHgJPWEUS1X3zk2BNwibZkZ6v9darZSV8r/mT7FTMids4WsuY2MTGQGlWZak06YXgVE14l320FEL/cHvgASHrdnOSksDQxql6B3syylgpG65JGRKyuHLrJ1OHEQnHCma5YH28NDHHBcvo6nbMaT2Ggde9/7G7nNjIvrgnYNzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in cramfs for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/cramfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index e0ba9cd640dcfe86e0976344b30a5b9a0da6b90f..4edbfccd0bbea39a1babd289afb1d8b985570eeb 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -125,7 +125,7 @@ static struct inode *get_cramfs_inode(struct super_block *sb,
 				old_decode_dev(cramfs_inode->size));
 		break;
 	default:
-		printk(KERN_DEBUG "CRAMFS: Invalid file type 0%04o for inode %lu.\n",
+		printk(KERN_DEBUG "CRAMFS: Invalid file type 0%04o for inode %llu.\n",
 		       inode->i_mode, inode->i_ino);
 		iget_failed(inode);
 		return ERR_PTR(-EIO);

-- 
2.53.0


