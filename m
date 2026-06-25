Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82F1ACDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AB956B00CC; Thu, 25 Jun 2026 03:09:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65C256B00CE; Thu, 25 Jun 2026 03:09:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599336B00CF; Thu, 25 Jun 2026 03:09:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 339896B00CC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:09:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF661A053D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:09:37 +0000 (UTC)
X-FDA: 84917559594.06.530207C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 111881C0006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:09:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IOkqfVhb;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782371376;
	b=BSohXiuqeGR6zUbgGg6PxRekKino8NROieTDdM/g96iPtMYxajNzPR/bJElGdJCUaBTM3A
	qbsyBmbPcAgx1AiBzKMo1R+Gdb8u0fpWeSfVBQZA5OFOYGfs59MM0dKkHxRYcT1TmMD2E8
	+klbeeLtx280RWwX2opzjTGjZs/Fr7s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782371376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/RyHSUG1l6yInKlHO8vL6Q+ePzu5eDGtAmKFe61uI50=;
	b=BYSrhy6ckzYOqrtbZUpd6bmUYPwxHd7njwzt6l1IijVB+uZN6cADPAO4knHWoEaug/36tt
	JnTi9G6ODJgwJU6OuF459xPFftrebMtbMnzusyHVEhE6CQiFJ5ZUAgPi0taE0CVQlYou4r
	B+3nOAAXqjLZFoUNuQSf3DcM7ViYJw0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IOkqfVhb;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E03D60217;
	Thu, 25 Jun 2026 07:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B57A1F000E9;
	Thu, 25 Jun 2026 07:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782371375;
	bh=/RyHSUG1l6yInKlHO8vL6Q+ePzu5eDGtAmKFe61uI50=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=IOkqfVhbPqs/r3NXLO62NTnfmNPLxtWHRQpxIW3ENaaxWKF3LvmrhRLGoBbtnMNAG
	 w0FgvmAqJyVrkYwzgtJVUQJb7zKbiPrWoal60Sq4OamLHy8ZIH///bzdOhulu3pkCS
	 Mw+9EH8SnpAZoaZDntcL0MGc8w1wBCCt/AtJw51xqmd4jvv8cOKPajErk571J34pCs
	 yvjqjF39mHidPELOvn3MELDgTMm4CDBrgIwH6Xeqoomso7lkKtYtwz53m06B8HV6DD
	 +EgnkSTA97f7TvM9cqtBRmkx0Cl3xEDcjWGYvE3aFylD5p5SEnuXuZ6uXIOdtsSQov
	 GRH4Da1q6/qBw==
From: Christian Brauner <brauner@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 Rik van Riel <riel@surriel.com>, Zi Yan <ziy@nvidia.com>, 
 Jinjiang Tu <tujinjiang@huawei.com>, Dave Jones <davej@codemonkey.org.uk>
In-Reply-To: <20260623192850.1595958-1-willy@infradead.org>
References: <20260623192850.1595958-1-willy@infradead.org>
Subject: Re: [PATCH] fs: Free any excess xarray nodes in clear_inode()
Message-Id: <20260625-leber-waldrand-passierbar-11cc6a8087be@brauner>
Date: Thu, 25 Jun 2026 09:09:21 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-d9d01
X-Developer-Signature: v=1; a=openpgp-sha256; l=894; i=brauner@kernel.org;
 h=from:subject:message-id; bh=3QwDk/HeTA8/TrfhxghZj8ZqBWpH7iaeCuMfJ7MIlnc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTZXNEN8wr27RV+w//xbaz71RcylzZdWdWaffg35737X
 g55NRk5HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMp0mX4Z7VoQpLhCtkVGxhW
 fl54LzjczfdUgb99UV3D1R0PH+Sy72P4K6PYE9bB6nkmc/sOiUtfPxzo/vDx8IxSLqcZUWfKVDe
 vYQUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 111881C0006
X-Stat-Signature: 36jikrdbx7x1h4o8kqhp33f1r79eej35
X-HE-Tag: 1782371375-430354
X-HE-Meta: U2FsdGVkX1/3EmxFa3TXvy/lClSDiLMSZ/gk/FwwPV0Nl15K44GboVyaqpRGFnI9NZozsfQhc9oiSyKsAw9TH8ILbtgxQxlS3G67Fh1ydnOlzhfm/lyAZjQswpYUjClXaXD0C9YQI7y9RBa9coye7+vCkXrtMKkSvfKIyjNY5MITlF2BladlTa4R6PP+ColL6tYztKnff+cOTAaJ/7lyrK0jMn5P0q9/KoL8o4jTvuXyuMsRCl3uHDnv4SXaHn6GOPO/7jv2JDIQOnDwv9xWtF5d5OqTqwcrMrgtFU/0BfF4jb71TZJjcZIjkP0nO/Pq5/gWaHrTUS6LplzkE29L6oTphV1CT1bcbr2c0mG7fBBtmwyNb3ZyS/afCRB5HCvyOklN2UxF1DqUiSk9jFyWyBW8DhXZWZ4nTEyh5uuRxXtzkEq9DpzuBfIAShzWEHyTdNfa/CS4NYCaC5frrvwc+3etXUN1h9Flz2Y3k63rgqS5YOYK3gZ+Csd0Ssjln5QHiJcOqQcRelo8YXJlvrqi+yw3dUILTu3nnujcXstIJ12HLo8/EUkEuYXUDCKzC0dXNvRnr22s9IUQYbjfx1weKvsCRvCubpe9X750VJMPy2tlVTsyWA9hk1Ze7ilvNQNnCIRYIuhoPDmTQAb6r+C9D+GaYDslmsRUdTddoTzrGkBGbcPi2rpznQSCsZYFKce9SbxqpbHr+4g/5qHLPZVF9HRPCvUtVKASIMH2nH9Nt4cSlt9xqbuZJqxO4Zr2GsmfHErvBqZX+3iaJ+pYUNpFzokTbVvEXJagZ083ksbupGf7+woMko3DQcJ9QAiMFPWwetfJ2nVZArOxBRzbDQk4YlQoHwEBgONpU5nExD0ukZo96dCwoRd2ETlxwfpgPYx8OcUbG5PVADkqLZTTXmGZb0G9fGZDruuBVEjtojAJCo74gmregJtrupBh+azHkXBg9oFlihiyYoHdYy3Qn7S
 KK9pH87G
 rolUC4lu8elnVLGRsSfTxTNlXcdV6/90+oncllMQHrhpatlFQ19n3aQIYaHUB/ZWFXEwNSuTdonD2Eott1f/heOryLuTKgx8dI0VWINPV0HWvc0l8wHvXeg4vnt84/5bBfI6xu031NmUeuUY41HBiP8F7VB5q4XILxCXQLGq5QjEmbAvqc8jPHxEHUlmXFhiNz2IshEoia5X0/0CI6pGHnZkRPC0rWPNHy2DUG1keBNiCWRcTucgq4qME6ZHbQLXfxVwzEZ0hPUgtGnCT5jZVOxoPJndgzGAION5gY/E6xlTrl/pYqe8Ji1t3opmlZeQvv7R8wwvWxqdmix/jUJXVsCBy5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 20:28:48 +0100, Matthew Wilcox (Oracle) wrote:
> fs: Free any excess xarray nodes in clear_inode()

Applied to the vfs-7.3.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.3.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.3.misc

[1/1] fs: Free any excess xarray nodes in clear_inode()
      https://git.kernel.org/vfs/vfs/c/aaecb408f8d3


