Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F351606A333
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 981A16B05B7; Wed, 11 Nov 2026 09:56:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9593F6B05B8; Wed, 11 Nov 2026 09:56:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 896E06B05B9; Wed, 11 Nov 2026 09:56:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 664016B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:56:54 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6CF61A7BFE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:56:52 +0000 (UTC)
X-FDA: 85423140264.13.2CAA598
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf30.hostedemail.com (Postfix) with ESMTP id B318C8000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:56:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf30.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794409010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uTScRtTvc50Ly2VnPZ+IRL7zVmHRGtRnjIEMUslXOU4=;
	b=BAunDrQVzjrFX7ruZzO1JmTaQf2FAU5IzY1qia2dSwO36sAYPSZT8tyXRoWRN6LxWmTMH2
	kpUQ6UWAl5o/q6hjTY463Em5Xq+EghrM8jm824nJ+gL0YyXup5otld9bpgP7QkMVFNgzX1
	yU4f6CEN6Cjr09jTSD5hDMGugOijVd4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf30.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794409010;
	b=5nDCNB0wi98XCDCdTIuqiC05BJNr8qdnNOUbc2cgEg4eSfyIGNfSa0oRVx/9Ierh5Doy64
	BQrfjWFYBg9WgqZOnFTuaH2IEcAxEEt3XX9KxHeoplx98iJV6KfuWGRev9vijEllgkkZFp
	ybWxeNpNkloFr6c9sQ9Mt99shaWlA1I=
Received: by verein.lst.de (Postfix, from userid 2407)
	id BF2AF68D09; Wed, 11 Nov 2026 15:56:47 +0100 (CET)
Date: Wed, 11 Nov 2026 15:56:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 03/41] target: fileio: check that the backing file
 supports ->{read,write}_iter
Message-ID: <20261111145647.GC9996@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-3-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-3-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B318C8000B
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: nokggyxyotyj6qxrmenewzxab9fb466w
X-HE-Tag: 1794409010-373097
X-HE-Meta: U2FsdGVkX191Qx52nZXAKDgdCkBhrWWFa8Qh/dn3dMw8cXP013ahpMBY+O5H8keu7fdYQg42tPfAe1fLuAuGrd/zSfCPbx46onU/2cDk/tubk7yw9hSM/ihG29EbVMsN60c6EOL85X98v0O4IrDSWkuGQlhn5842frpt4+h3EBulzNjaBl/YiNuiyI8Fv8XsmWeFNCoX1rC6PT0FCPuPCqWxBUbJ1IDkDrSMF9s0a6/feGzxOnp4CIqrIgb038w12ocfl+XvW2BnwsEaXIlqSi3q/pCpaFHhdURwNoW2ZyzR2UibqWXmKOu02D000y7cWMzW82ukmICJ6VtE0vlIZ+1vtxFmjkMSDIPRSNzhFMPsG0P3SksUU6zRyIO1IUgEOhLuwi6xiOlh6779oMQr4cusvq+QFGsqwVSLgVaigoLpDXHwEHmMGCHbnnKVgaT0ae8k50IN9bBecQ2I3uRBjU2G49HYiNP3p0grRn5Fa37OlEGSehdcgG4NT2dlavN1kuSEKGt2UxIFsprhMDK42mHMmu0VBmcY6cHMXusOztxcdVkDi2Uk2mAkDUjG/4TjOtj+eLm2+Nr+rZyqcCCyyMEmbu6fASa3TdlJZGFM1rJs9A5OEVu6G4AQKBY0B7QNZdlJGE3NVg7EbWOpvGxF0zsXbdsyRoD59DauoHVaBU+8wdQDQ8ON3r8wp73txJp4rAzRzNDrNhUfTWIOVoz6Xlh6tp7E0LM6zscIHBZB9/Pcm/hEqj5XtyDyaqF2GCOJjHfqUybmKUY5dy+nuGaYFVWRu1Y6W3frshppTkb0sWUIrBWMKF6xJBb2H82NSmrOGbRwxRr+IeNezSZTp0ur8eGCFXeysNi3x0hMjhLA0zvr0ZOJqhmWy5S4s8NSZ80ybmuTl+JNVjtpvpA4JCxICAqrcSdw5f2v09n9ah0BPmDVTs+NeO7/Xf07FKZ6CXC/nrxxS5X0XG1c8NO800A
 CW7osW5v
 nCHbM4/JQk579CRmZwUZ+l++gZDpsgT1NdLOQDuprgB/f44USkzFP6swbUavAChDJs3nrnay/tTS4POqLtECu44zlG1mXsc6z+dpi3yY+wdqVxqt7btU/hRXWtCMBtMWF8tFQqB6QM8T/dss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 10:14:19AM +0100, Christian Brauner wrote:
> With fd_async_io=1 the fileio backend calls ->read_iter() and
> ->write_iter() of the backing file directly. The synchronous path goes
> through vfs_iter_read() and vfs_iter_write() which check for them but
> the aio path doesn't. So a backing file without them calls a NULL
> pointer on its first I/O.
> 
> Refuse such files when configuring the device. On the synchronous path
> every read or write that needed the missing method failed with EINVAL
> anyway.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


