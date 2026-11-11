Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12CB7606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n3Cb6yMC
Received: by kanga.kvack.org (Postfix)
	id 3058A6B05C5; Wed, 11 Nov 2026 04:33:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DCF56B05C6; Wed, 11 Nov 2026 04:33:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21CFD6B05C7; Wed, 11 Nov 2026 04:33:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0072F6B05C5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:33:52 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97604A79CA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:33:52 +0000 (UTC)
X-FDA: 85422326304.08.DB72834
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id F152F40003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:33:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n3Cb6yMC;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389631;
	b=xpf5tYPTqjJ+Kndft64SllScrEK0oYBzZ60+3qrHpUzwQH0XZeTo2U3ZljhROUU/++zXJP
	jCAEI5MaUAwMat/VJa4K4kcUejQoi5O3Q+3UwRzSEs09vapHWZdfcM0BRvXeGA5gV9SAcT
	z3EtBWj2pTlFXYKHxIUQEaQ7Uej8E2o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n3Cb6yMC;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=456qmbozWJFCOonDULqMGwfLm3LOz4ouH9mjjl+y80o=;
	b=lLREMKsXxSp14b6ra0EYY/jmuIwTMiR6/yvQjCJIzP7/VrDkj7y9PD/t24EGWUZykbZrh7
	PVotEbvuyracW9waHZfMm/J/xn9/J9QI2cvZhlyUqad82IbpA0j2+baVBuvYK8L9sC7pPV
	gq3ieukMTj612X73XvVH5nHmL0RVkwc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 375D940622;
	Wed, 11 Nov 2026 09:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0931F00A05;
	Wed, 11 Nov 2026 09:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389630;
	bh=456qmbozWJFCOonDULqMGwfLm3LOz4ouH9mjjl+y80o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n3Cb6yMC6Xx+MhtaqnOrnXGh1yx6okkK2jIpzAW4cu5aUYc8j/y7EU8g3NgNu/QuZ
	 h6aRu73Riaov4wJiTnTP4KKCxNNwt/WLi4lQRVlUpwcuYix3GWpv5VbatMMyd2c2ka
	 bsAKOxkUbXnwPs9gnHyNBgbqw2VZSeX+TvxOlIZowTeU16S9ZvRFLN2y2DgCcctYkQ
	 uKpzfty4H61QbRrp+wcGz2FRiFuijKiwVF5IpDCY/ybtNToPzQn0DiqL5TuyPiT2ba
	 ETQN7xaKj7gXRMaAdX02fBSo5rp8cdjm+07TNPZUCfj2UcYTANvSDnd0dwsYA2Fr6z
	 h9XcZ9pa3YQpQ==
Date: Wed, 11 Nov 2026 10:33:43 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, Viacheslav Dubeyko <slava@dubeyko.com>, dsterba@suse.cz, 
	tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 11/34] hfs: don't set SB_RDONLY after MDB write errors
Message-ID: <20261111-albern-windhund-lockmittel-21301b1f1729@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-11-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191230@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-191230@kernel.org>
X-Stat-Signature: d3kbcyh9pbyn5uy35xq4seogxdzrctao
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F152F40003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794389630-357645
X-HE-Meta: U2FsdGVkX1/FrnCZCPHEil7J5NMclP3ImL6czr7mDVbGEJIa6/fmtNZ6p0Erb4ZuiUGV/tXNlGytMZ7dGTbDaOl0tB8dRM7IilcVh7XodMg8lXfP+JC0dtJla5aDNihmARbBP24AtqNYyeclqt8Eu6nGXHpo2lvEvWPx6BqdCAt0l6OrQm76I6WqASYr0C8njiejLfSwG7QOql6uvSOXizkUkuEpme7CxnGXUZJksiESyK82JFjrQk5eDZDVJu4xPV/OvVdMoyWro1U5qblu8drtYoOoa3K3RsGNyHg5ukhBSMfR1qJGDqEsf5/vc3diSeu7gY/RlMFa9tf6ChpDQYNpqxmDdUt32EyInU4jBer5q/PGIrPLm9sODBU3cDHSv1vCePvrRmSx0SaNTM6Ajj+FH4dXyZvLb4f7c6rjpufjr+mK/+vsJILXHgOl8AwAdOifEK6l8kqayHmMjMMddJPt8nrYlec3fwqoFPFtUTL+b+l2ADyoEaG2oOMXkurXfMbN8a0g6ms+Y5N8hP8KishvrmG3lEYfAoJBTJ22E5ZOsUebQ75BuFws77eMV1biAZMYmglx7n82vDIjLzQqo80Fa4ll8+nLsfZIE29T4gQHtqzsmvgWkQvKAZnYE8UzILAynp4mf70dTDq0FXbUHagfWMxQ/MzfsNwuJR/z7osmgvsdx/mLjPZRYC9F7sismAJj8Yin2M+IQ4rTTovuO5GjKosGp/z2LO48s158mY8CTB0otdcqcfiByT8xTFe3Jd81BLYoAQNPtofYgL8R3vwlwiEVoAXcAhgqZPzqyoVRq29v1FvGSCHvKPfiEzA5SxyEDXMh/wzb2iGIhyDPXV9IG4xk7OB76UzC/1aX1iLPZxu6egMwlf3G8MPla3XOwfSQob4G4sAOnyAH6twmLnzLrqQ2qVPxkc+mdYpJOcPRg7wycMWZl0+A4CvVUEoGU2mh4300drO2cQe4Dgc
 OmXWK5J3
 ILe8TGNwj8PUGLBUH+grnh0iAtm8v7ErdbtWoY49h+QWbgGp/h+5JSZca7X36qCYCYJ4uk4GTBij12NApHTpfLZfVretXOo8F5ZYwp+fvTJZUXD0DaVusiEhEQsoGvp+r6Jy1dCdj6VB+40N8/8S1yyODRfD4oUjCp7LxTHKM4EOe/tK0me0wNkoznR0uDJWzchL1LXu0JC60az/hGdzwXVPoXNKZOrS0lnhqgcGw4vrtWx9BuRpWpflGgViBdnKKxxXWNXDxUJyeaG1IwQMGv6UJjUij48R5ZEPlBzTeMFs1vJNHXylSrjU6P3LkIW16yDo5ZtEhesOBKleSGFNrZELMkIK9Fniku/d6hhyGq6pLIdKLohc2WFBAsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 04:09:57PM +0000, sashiko-bot@kernel.org wrote:
> Returning early at the top of hfs_file_truncate() skips the out: label
> adjustments as well, leaving HFS_I(inode)->phys_size,
> HFS_I(inode)->fs_blocks, and the inode byte count inflated past
> inode->i_size.

That's all in-memory state. hfs_write_inode() and hfs_mdb_commit()
refuse after the error. None of it reaches the disk.

