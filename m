Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F34A5606A327
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S3A4M8PG
Received: by kanga.kvack.org (Postfix)
	id 1F98E6B05BA; Wed, 11 Nov 2026 04:37:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9FF6B05D3; Wed, 11 Nov 2026 04:37:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8186B05D4; Wed, 11 Nov 2026 04:37:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E158D6B05BA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:37:10 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 898C2A024C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:37:10 +0000 (UTC)
X-FDA: 85422334620.20.B017252
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 07AEA1C0008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:37:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S3A4M8PG;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V3OCk+N8SB0awCd36HtzgSzqG30/oaImEUc9AZVKUng=;
	b=u0/A3LVHyGjvBbE6LETdPnILzPm8IAmWkbrF4sgGVs5tHOMunFbWV72bfZA/dBbQH5lnEj
	f2F0EmdNqfL7pHs2JUsS0cPsikoUjV5+Ev2cXO4XrxDs06NSg8EoIh7HrBD3zy5LMCBukL
	h3m9VFDJFF7aXel78I8l/m9ffnP72lU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389829;
	b=wg3xV5RiZrkAbkLW4BoXkRwGldi2oGeyxGWoq1wyTo7yyOBhMuz9To2Tpdm/M1EUigIUhX
	j9fIX+aAyVIEtVfAWSKghoI9JBBAuXUvZdjOsfHaRCXqCJx7QG1TrGZ5Cc3fb7eFe9mAfc
	clGkOqssDgkEyzYDzElvy7slZ1eSGo0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S3A4M8PG;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D8BF608FB;
	Wed, 11 Nov 2026 09:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D071F00A05;
	Wed, 11 Nov 2026 09:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389828;
	bh=V3OCk+N8SB0awCd36HtzgSzqG30/oaImEUc9AZVKUng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S3A4M8PGrXZZOjpczvfRgaHWV379jGtDI+QSGgXmCBtKj/ifTm4o2c/Ak/jI1r70F
	 2G46uDCdpQPL2kqtHqHS5rV/1XDUQoXAxQT2YrsX0fEoyBXHynKrsDXD6F4ZFfE9Iv
	 rg9rJLzMKxS14WpcNgCywWHctZHbfmICCX40LkQshwDheWrF1im1dw2Juu+6OxXvsI
	 QR+QoVJrLogbfPB2tmdB2QXkbfq6pDu14YuQu21BrehPbP86A/CS6YUpMGnawv5j+g
	 vvsgo74iOZRxBtosfh27sXCrUErO6RMDC9/L5pG6pwW800na+FQoE9k4Xsp5ln0jFn
	 2jqesqNPs4+vQ==
Date: Wed, 11 Nov 2026 10:37:02 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 28/34] ubifs: don't set SB_RDONLY after errors
Message-ID: <20261111-perfekt-dekaden-bildband-0e31f4bd1858@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-28-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191247@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-191247@kernel.org>
X-Stat-Signature: i1cku134d7pi1dy1t9oq4y41qx4gb3c9
X-Rspamd-Queue-Id: 07AEA1C0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794389828-522924
X-HE-Meta: U2FsdGVkX1+3vhBbNwufh3M9FiDx3dbbUfsYV+8HQT8jUm5XtDKBHkq26nyf4J4wvylkwjMI3hq7GGsFAjDKZofA4Fv+1bp0groPoHjVguMrojHkMIm1oXxtU2eFJxxnUXBEpXs94Uauf74IurCgB8Kg0gOUMVaDn8JjW3bbIzQanQ75xWvHzYy/KBPIyIP698DIVIoUqIZPTRJpa1Mgj67vj7eQZAVF8zLQQhD8+y0E7DCBEjVg/UG/AgIRp3HilBdy60LLqCtmbYk3pe93aWcwP6HPUgdphMUjcyt2OSbBPTFkXWVxJmBWhhCmP9dmZWile/Ke+tZvlbq9z/TjG9HjEOjod9bEmujcSQS1MB9exWUPvbThdRBXxCOpC2NxtUGLCG5DuEIq9hlUXN+a4vWl9uOUSDRrJAcyHK9lUBpoDqAQAANkVvpvzSiLScPptseMJ5NgAaIiH7aerZSTdB6gYX64ymUWTjoUnDyEA8d9OvlZJbaQwnUH/P1b84wy/SPZTwLytJdVGi5swQqdiae+5HPqKmH1SRi+hOAsRaws8ngSaj9rxKirZyR3uSWgZLFul71BZSEPat4b1/c2Uc7azIwDfAvfSOgJkcvqy5pItkV+p00wccddu1VnlQv1H4gJOGEZk4/IlOonnw6jEf5F9IKCeJMdGoAYfXkaub9l9x4ZLQAcjOom5IepeTYd4Ygw7uvUiBUclJg+dveKlA12Ooh7Hju6M9aO5JrsrlQHxvLUMWTPT+Xp2tqmEmhC08hiBHP0apOG+Dpk5NeDacredT8wGfOYzLJFxR7WZ/ulWsWB0XjkIpgcB7Q0fGjF1o5LHFQv411iVAmP16keupa58r12FNF/LEulO6ASPSTi+gq4eQz2K4m+0QsAMBfRL8mS3eAHcj9rQ2CMA4u6hCwP+Ye2Fj2cks82rhRIW6jlCSnFRyuzFmB1/ciVOv65ADDraMQaeSMtwxUA717
 HQChJY1S
 FOqPkDkTm9vyaY/8K9V3yz/6gr3Ro3Td/xiYXFsMHQew/n986PX+DzDdXWqZjbJt7jMNraF+DTeJA9sEVzutQrpT6hcR5LsxdDo7GTYjWJe3L5hBqBThHX4PD0sPFBvtgNoqRjkiuQRMtsCN5HVyZ/knP35HGf5keH9F3qKE/pI4mJSEPQoK0e8t79I6Gk5c2KLAghq1aCocbU2/TkmX9jjpkW9VT9/rFxzvRUG8gwC+/7Uu7g3YYFEd9VDN/d5sP+dt7orTy1kG+dELnPPC6UXp9UNwPbsNa85hZev50UfXYSA/zbQRiKgXomZjSLiOD56HqiqNE/gRavGJirlwxj4L0xDnCywK2S/8Ub5uAVzQVIzT4IOnaBR+k4wRSMJDZHRT7EYIFXM8yQ4s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 04:10:12PM +0000, sashiko-bot@kernel.org wrote:
> Should ubifs_ro_mode() call sb_set_emergency_ro(c->vfs_sb) unconditionally?

Yes, the background thread doesn't hold s_umount. I'll do that.

> Does allowing ubifs_remount_ro() to run after c->ro_error is set cause a NULL
> pointer dereference on c->write_reserve_buf or trigger assertions in
> reserve_space() and ubifs_wbuf_sync_nolock()?

ubifs_remount_ro() won't sync the write-buffers or write the master node
after an error anymore and ubifs_sync_fs() fails early. See my other reply.

> Now that ubifs_reconfigure() no longer returns -EROFS on a read-only remount
> when c->ro_error is set, should the assertion at the end of
> ubifs_reconfigure() also be guarded by !c->ro_error, similar to
> ubifs_put_super()?

Yes.

