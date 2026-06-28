Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62EB3C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 16:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14DBE6B0088; Sun, 28 Jun 2026 12:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D79E6B008A; Sun, 28 Jun 2026 12:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBBA16B0092; Sun, 28 Jun 2026 12:50:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAC916B0088
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 12:50:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 23F1F167A99
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:50:32 +0000 (UTC)
X-FDA: 84929909904.06.4B4768A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7384F100010
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:50:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mqE78tfj;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782665430;
	b=AKAGJjd7yoVAE8Bj9F9ktHUNHFb5ZIb3yWNTt+JXsWYaZUtswLjKlhrSJgrIortFjuVeA8
	MwXzXufBIkxdfDakv4lWi+y1soYv/kixAJiTxBiCzBXQTuo+C7MWoxuw6jmseMRSpxBTUX
	Rd6555L/glSbZ9JldTkGXD1Pd25jN64=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782665430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4tNWb0g/fFPdngLw0tQabxt79dLq+ueJy5cbexUblyY=;
	b=JwWkBLSvtEVefYlhtC0KToJOAPpVyQpmNQ8Sq6RYVsFEwg3ezRPUnJ2KAtueUcp6hGJlny
	Zjv/IPuunUBPVd+PsSDbzd0qU120aJxIx40TH9G+0eRERWvwAswS4KCrFf8tjWnYzUFqBi
	a38L/qjAvhZM0TwA40sBG7PB6oQ3svQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mqE78tfj;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9263941F9E;
	Sun, 28 Jun 2026 16:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD681F000E9;
	Sun, 28 Jun 2026 16:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782665429;
	bh=4tNWb0g/fFPdngLw0tQabxt79dLq+ueJy5cbexUblyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mqE78tfjm25WDHjpzvrUDuASfQ6RRBt6XmsrhSHc2ipd0VA/+OiPFBeE/vPDD4nhJ
	 DKdBQVZOU9pgmzEEj2SOammBx39+0Xfn3enODddgHhenBIMmQhaOesQQjnCPvnG2hd
	 Ap51hzwMwf125cxQSSdYFEWCmrUbbv87L6k2gvoUIytUoefawvO6QTpqM2JDvMHdL/
	 SFXpWUHJv8eHULhLUtq9aZhcwsqQKyjnFd0EDyFeOyrdcIBvaqgazf24VVtAH0tcAz
	 8xuSk80DH5Vr92CeP9a8QBaCj4VRiR8afNvJD6kSuJldAdX4UayAPFHMb13EFEQnwG
	 QmOXDp68rg0ew==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Arnd Bergmann <arnd@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH] mm/damon/core: reduce kernel stack usage
Date: Sun, 28 Jun 2026 09:50:20 -0700
Message-ID: <20260628165021.85893-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260627223405.3533412b4010b6ce658da01f@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7384F100010
X-Stat-Signature: fwwqcr93ry6bwurxa64byqoz5pmi4nxy
X-HE-Tag: 1782665430-70831
X-HE-Meta: U2FsdGVkX1+anp0U3LaoehW/F+i98FvTdt5DUZns/g1ayN9pFCSOx0bmSJQ9GK3sKTZJOYo/bv3zkvFQzPJPoyi/82HWh5TfSX5RmuMsDX1uDrLPajumWxe5PsvAPWsPHh3KLtHkWf1OzVmsTJkbQedZ396leEaCTEb2ZgQGzRHPPbesGnT8TfCJqwmlrPfpx1MTYSk+Sh1uEifjHQyhYa+hLU3C6lMK9X8FU09D2s3bzsV05xSz26e8vN5Ta5hvg+mX7Xw/8bKv/MDFo7h0ixMJuHucvrSVsHVlnf7B6A1UoRZ7JK11clUi5DgHi8Aya2gOH7E1CmYisgwd/Qh9qYSCUFRAYQ54nzNFgEYdvVrfsGU52mGowWPmC9SH7uIlC75mu8KCrtM9C1H7xA9bU90SoQLPm+nnpPFyplN0eId1oKcVZSPyTjmk9bm142VoYTP+WQPId5dG53OzS4axQbIBLYBE8qjYcphaQj0glxSoX/0VWKhKplw1V3sT4LX2irkN4dkVhDfilfUBpkKI3yBMLHP6MSf8F1AnmTZB4joNcPIQY2aN5XVpGWeHtUUd3OAknivCF+FC0BKU9bLUDi1JT/8x1upIfWjWE6Yo4Jwzyh4HC+etPRSEz7HtCN7tuqbSebvnEWk+AV+H21Pp9kIkgqeuSwvXPmnN8SVHN42AB7WuyJuxOF4tNvTLhOM2mxtc+w0dAE36D8Pb1B/O1tpJrtVNDEZgJhFKPrNySpXhwphYr31COAGC7EovxM3YnqkjSrMpNOPVPYYqKXhIC6dvC6tc8oQynlT1DbBgjjvWW0mcbfKJkApPp4IFOo1jxrY0LecfuKd4xLKHCxCEb/w0aJrDkSS9X0iopZxlOzFvIIyn2cjaEcQiMGhLvn4G1MjEEpgLOFRKMSMQLnFAYBzmmgNdp4wMRPfH3coNynKEJBIcWa5ywyxnPiCq5WIhnXNWB5Wqp71iTP/TIau
 SYrMtJ4T
 0suhZFI3MW9gc1+xTWSilZiOQSfaDsw4g8tT76EXsIcgj3obQD0xryNaqf8s/3ZHDAJTQeBioy36NHSjExgw7w/WUA8ZP7BJTspdxA79O7w2S+h0iDbgKjI8tF9Es40w3nyzgZSvk9jz4dkxY8q1M5QDJaLb/xmj5TxUWfOeWptt3I4w19TH/4aw0WpXwikgkBl/4jkhd9V52AVEirwlLACd8TfFkf/Jh0W4lb5sni8DXo/SghBrW6z/DG7j5/tVJL0ve0gutfFMZ4yrF3mQm485RluGpVD0Wi8vrEoCQq+/VkikuRtkd3TYtt9f0B3p++QZ1tU0u29ahh8e/3OLY7JWpkt2StfiiavcELDFi6Dm3PhwFVo9mySOyLgXljhTpqG3WVOBNUyvxX1d/7DZ5nTojz4Z5vjncS1T2Vpnl5btWB7Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 27 Jun 2026 22:34:05 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 11 Jun 2026 06:56:07 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Thu, 11 Jun 2026 14:56:57 +0200 Arnd Bergmann <arnd@kernel.org> wrote:
[...]
> > Should we add Fixes: and Cc: stable@ too?  This function was introduced by
> > commit f04b0fedbe71 ("mm/damon/core: implement intervals auto-tuning") which
> > was merged into 6.15.
> 
> I don't think so - kernel is full of these offenders and it will be a
> long and painstaking process to weed them out.

Thank you for input, Andrew.  I agree.


Thanks,
SJ

Sent using hkml (https://github.com/sjp38/hackermail)

