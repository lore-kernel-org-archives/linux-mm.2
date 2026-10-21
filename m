Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43F18606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ydt/0mHF
Received: by kanga.kvack.org (Postfix)
	id 6919A6B020E; Wed, 21 Oct 2026 07:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642886B0213; Wed, 21 Oct 2026 07:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 557D06B0246; Wed, 21 Oct 2026 07:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35B3A6B020E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:56:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 33E7340527
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:56:46 +0000 (UTC)
X-FDA: 85346481612.28.CFB4541
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 723E5140009
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:56:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ydt/0mHF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792583804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=057g4fkzojSmZ2w31SqHnYt6IBK9egcTQ3a1+8LQlYo=;
	b=jLe/VygM9ZcrCqK91yK9Ha/vTdAGgHVJn1Iwv0GgzEsX3JgOO46ETeJHmZIHVocAYVLMTe
	98O75E9sboT30zRqPLQjl14qvwty/dWfi3RQPrbRzbHzxcXipvqZpYHx0iniQCRz0Nb5VY
	TTm7QbyDy91HjLwaESE7w1Qsb8GAPSY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ydt/0mHF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792583804;
	b=6df7Ur/+SYasu0Zw/QCOR5+3BeCCAntzN5qq6MkeSfVHHTRNFkwX/99DezxiJAkd3MueSK
	3W7jQNRtyXzJdlV+dXOh+254u111jj7Bq+JI/E0LxBhXPI2DyjYHErd3Uiq4S0tHP9AQWm
	OZsyJa75vbV7TEKIYagkrGnxdo2obrc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E0EF143C58;
	Wed, 21 Oct 2026 11:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D9A1F000C5;
	Wed, 21 Oct 2026 11:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583802;
	bh=057g4fkzojSmZ2w31SqHnYt6IBK9egcTQ3a1+8LQlYo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Ydt/0mHFXuuUnlKg0e53miPmv4SeXWaNYLSgFQtRU1iEp6v77etS6tX50CNHzM7/0
	 ycIWfMsq+WE80qO/zFUnz1li+LWFKjZu0UXLNcYy/0PzpJmYpOuMMjX1oV2kzquHU9
	 RdoF2dOIlk8t57tUH49Eb72f7nw1PIcXa4mWBkZ2+BLalv2OgrhU5F8vYEXOjLaEOl
	 IFUfii0crzTjXdybBqa1WOlzaY3YX1AZTdZYxEN4iAWn9vOBtoSPyNQd75Smr9EfXD
	 iUZaWC2RhSRlQLeC5FX/i6AZazZ/86HiK00WyB6+gSPLgw35nitBYu8hz0k7v1jnqL
	 G6/LsoVK6jAkg==
From: Christian Brauner <brauner@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Nikolaos Karaolidis <nick@karaolidis.com>
Cc: Jan Kara <jack@suse.cz>, Zhihao Cheng <chengzhihao1@huawei.com>, 
 Mateusz Guzik <mjguzik@gmail.com>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20261009142431.713875-1-nick@karaolidis.com>
References: <20261009142431.713875-1-nick@karaolidis.com>
Subject: Re: [PATCH] fs: don't lose inodes that another LRU walker is
 isolating
Message-Id: <20261021-lesbar-rosig-immer-78a7ce2261ab@brauner>
Date: Wed, 21 Oct 2026 13:56:36 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=899; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Y/iaCQhSTOToIAabGiKICrDvPJx2LEbcHo4TbLPi6hU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTdWFGmptdVkBRQNFGq68ULPZVcA/sY3rAps16F12+Vq
 zptU1bZUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJHGVIY/HAKvud5tqbwg8P+/
 QlLB9U+lhXFG9/RnJpw+l+lfahHgwsjQ6/njyO9jYnsbN2dPuTkvaf4SdqXZX27+1tsRLDj7tfZ
 9ZgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 723E5140009
X-Rspam-User: 
X-Stat-Signature: igb59471ek6erbsqoei47xri6cjsp9b4
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792583804-145935
X-HE-Meta: U2FsdGVkX18wb9yt6bRDc60rprM6mahCplh7yxcP8NC4Jg2NXycaJwlIKd/4Q7uaeQ2dZCSGboEljvFWpI5ZzZu4d2lTZzwUT26MrONoapnq8mFSBYmzyTkf2DEsSs0pveynMam4BMYzF0QMSyqmPlYJBcSx72/IXw8RHm5r5uqBl77P+InDsLltnrZK+eZb+Q952xgHfxz4g5pHOTPxJksuGFGdKkVXAGNE7FDHs3ht6QEekjUVNdHlSnQckwbeAgTWD8cAc8qRaDHnbWdShe81VdZ69m/omAS6FmzIvxSktPxMJkrSr3BLn029R9kUjtJdWdHR4+Y5RC88Fr9rPtAJ70Zy3lGFFfWtpPyVymgIvGZ8oqbLm5HdpDNBC6B0YO474+lttD91Wp+AZvmMjU2m0gEngtrEM92YBRwLa232T/2z2CuNWUt9o/rsPEp9oB5bVQ8ySRYqvX/m8eR3Vz22M4vTly7b6h0dzd0RLyXb4SH0DKLDvrhCRl9cfkWX9D8mwW0JBDuZmdp2dh9cNPrOrjr8Zsg2S7kxQB+cmyC8/WqHP9PA9pFiSp6xUjyOK9VBZLxPW1z3eFI90NGWRC8zLXo9OKpOyQn4dtKZRCv0mGahd5FSNcNR/3Nd44MqXiK90dasR3rWRcpPT1lLOiSZBd22bfihg4HgqvqY51Z5mtJBKSdxmOGH6mI3bgPtkGD6hPSETY+6b/btuo6++padNOvwN/lRgXkHKTwVQbpxDnHCRvPFh9LAA3RT1yg8F3paS0uJge42XG0fooOVAN2G8i7xEemXPzRTUdrgKCnSMg2itdHgDIIWwyEp0WNeQ7G0i3KKn3n0lRcgg5vbnXXF2bLaf8My5s25guRQ3okcn0bj7OjUHrMSkRo2HOfgxo3+2zbM6aXG4v7sAl1etNSbZFFyCs4wRACcdgk2a9OBsBhghmv9T36UuN1eZTXT0obBr13RBCv7rf6ODMd
 kkT4tl0a
 HYTMZ8KsKEQIWIhwsVFuAy8K6vx23TXNU1MWbJ38RRL3cEE1h7bzdXlY8xD7FfbF/pYt0o92y35tYD9mtgo2Yw5sKcq5Zvaj9+BEtHjLakA7IvY1uJZnT/pzjUU7womNvESgu4ccIDoFbowEKThsWswhBQq3EMwCIYA8ylacSmbvlV4qVYl9XPYPLcyozXz2ZNnPMeTUVHmQ8f3qV7NBt9sMHBHAVTObuJYr4O5yKDpk4Xm//XpQ//d9mqeZAe14XECQeC/bMUpLMGQ5sV+/7iS1h6O9DStV1k8J2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 09 Oct 2026 14:24:31 +0000, Nikolaos Karaolidis wrote:
> fs: don't lose inodes that another LRU walker is isolating

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] fs: don't lose inodes that another LRU walker is isolating
      https://git.kernel.org/vfs/vfs/c/3f54961ad92a


