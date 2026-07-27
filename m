Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA519C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 07:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D47316B007B; Mon, 27 Jul 2026 03:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8BB6B0088; Mon, 27 Jul 2026 03:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E3C6B008A; Mon, 27 Jul 2026 03:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 97D206B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:42:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 11DF3A069B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:42:12 +0000 (UTC)
X-FDA: 85033763304.23.ED88ADA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 44AE240009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:42:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ejGDJpZg;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785138130;
	b=zkblRY/6LUT7JHnlLe0bNBS8AzDbpLUuOjO4jroJUFXcUNi8c55AW11EZZWyxFFZ08yY2/
	pYYcUGJWKquqThEaS7NYW9Ag9n/ARlmjDS/z8h0Z1ES9gk+o7sHwlddOsaAohfp9zHmdLf
	IhSgbz0/XjKIQMAqbUpADNyXCDKw5qE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ejGDJpZg;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785138130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3uuTmfGIyohz3f0+ucpApKqT9POBRXJbNmZCxQUDmc=;
	b=o/V+fB+Dk0xD26QNDoiKKKCpHR/Qquseu+Vam6iTZ3afkyFegtsXjcqBheSgvkkidUnB6D
	9f2Dp4zq3AGIFPNFIgWmOGvthQRTGzViiBDbUPSwRvuOrr0iaOzP7ip3to8TY72zoH62f2
	PPN7/tErLjpEy3OHO0eMgqSfkasOAAE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E2AB41484;
	Mon, 27 Jul 2026 07:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958191F000E9;
	Mon, 27 Jul 2026 07:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785138129;
	bh=k3uuTmfGIyohz3f0+ucpApKqT9POBRXJbNmZCxQUDmc=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=ejGDJpZgoy4BylkHwgvCG5X+ECz1mF+YpaqZLfRtZ6unmm33wCgfQnjL5ILY2kdJM
	 GNVYB3EYR8D4tsVin74idXkHtx6VKOYMeU6LwWEoxX8dnO1t4qEKFATVnNMd/cQjT5
	 SU/BWjr8bUX1SLog0p225SIcjSGhqDu3cn3+q4FEut/tlNi+gOtXYB+mVLoeF16sLf
	 APqcEkQxEO7/ymObe5Gzy7k9kDP3cU5dG1hza841sp6j0f5fJYZ8Jd8bqgZKPXb4zS
	 +b5GHDGQsJ174X7M8BHvl+XV274HNkWuj8gqD45sVKvtx/DHM3ALg2hnfxhxl/WDqh
	 IaKhW3S9tuN+g==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 09/24] binfmt_misc: rename Node to struct
 binfmt_misc_entry
From: Christian Brauner <brauner@kernel.org>
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
In-Reply-To: <amTYWb9X1B75lIdX@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-9-a162f7cb58d6@kernel.org>
 <amTYWb9X1B75lIdX@lt-jori.localdomain>
Date: Mon, 27 Jul 2026 09:42:05 +0200
Message-Id: <20260727-zufuhr-wahren-couch-0637f96a66b2@brauner>
X-Mailer: b4 0.16-dev-09492
X-Developer-Signature: v=1; a=openpgp-sha256; l=244; i=brauner@kernel.org;
 h=from:subject:message-id; bh=k3uuTmfGIyohz3f0+ucpApKqT9POBRXJbNmZCxQUDmc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSlc5/f+sno01bj0kMWtwt3dngseHcs4J2D/EVt1/epP
 GwvmGoCO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbiEc7I8Cz+gOQFls1VZqrC
 c4yXff5u2yPNLztlQcqVei2Dv0wTnBkZ1qheY9otU6K2nWMn1zoLz8O5bTP9vFNaM3Zma8U5dzT
 zAAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: np3tkwyps99ejjxqsj6tzie453zoqri4
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 44AE240009
X-Rspam-User: 
X-HE-Tag: 1785138130-642043
X-HE-Meta: U2FsdGVkX18pWhxR1ea6/HgJWSsVNv3Yx/JZdoNMAlG+P4El2httt/8tAqVE4STqg5IQ8GgKx+o/ZaOYA8f3H3ZUSBeLi7SAwaBa50XitHyOvHZWz0hY2bjR1xx9NSd+5h93Qx7fvpZ1nyhgyMusnN69IizYu84+wNBtzoI9HV/QCaLEWvuZBm7Idm5WCE2iWH3cQNmBD20k44VEURIAn2xqJWL+rg2NepsDP3/j94ZKSu+Xh6eB5i7zHACq076j7JIWkiavUiTELG/UKiINpJBWLpWx0wpRHBid76xzsDrbXS1ZxGCCgfF6jDeMTxxPH0jjzykg2b9D/B9N1JlfUMmHeTGvjEvlFd3wyltmap2y/ikSZJ2/V7grWnIBG0wOmR4feafAl4e3iR+uagdv2/IxZPQ8QM6PC/3Vgia300UpYivmrljcG5AIlHAc1ppenwomFko44aN+h9D5iLf1Br8WQAC2NeE31BUQaML+wIctkw28G/Whs6mjIYN7SlEpZTB3EAq/BQFkvJq8OcysIWIi5Cj+WHcs6dfRKjs4G4Ez6TfNucSzt9s81WIBQ2ye9A8TV/pYLPPsLYaaXC45Om5JMMRqCm/tjJoP4GeDwduh3YjTTDMgPc0hcsS6QE2+iT1idModSfHRaUOGEkSfcseJovy7Ur9QIEq95LCaveyZs6wQfvSyYltXUahGMIvO54eA6gbTjWOCBEm7kDGIyHPFWVRGCy0IVnoilq2K8Xb9aMHVwUmwb82Uy7qTYpYzOyXXyMb6nPwbHR0dkbJQqQFNl714HypscJMVneQ3fKJtPs6bh43v5YWt083iP5/GByq19TliytvxCi7reXL73Bra7p/Gxar2ZzuJ6M3Df75tHxmPaU6Mne8iCGxh6q6DiMIfT2+AjGRpcmNyHMvOa98GPRn/AAPIrpCWcIeIINhYwDpTVKy53WB5Rg86l/BTdFEuzfL6FYHK5rvs2jd
 13T+Njn9
 uCdol8YFnVj8i42e0qqphnZd1pdI4+H3P9c16spjYmYQv5xBWxrmw1+w5/njLf8yjg6xxbp0xoOlB+gwoq/fW1GHQ4lrJ0jaq05c56AK49f94UJIwFEEZLgY+lNeOiTyv4YR9MYTsZ+xhs6A0jDkYhCriiaefgjYucfNXyQzReLRFHXLaAK3w9xXbL3Ao2DibgsOG6s7LWsDRLBCPdOSBy3xYbZ0Sgu9Dukg8EfeuZW5CmZddPofwfq9l9PA9obCoKyDHF2aEugu4OWkg+ioZgfvSjXjeUgEs+2+K7+D00wTWTSb0QSiB4SeG/qe2n91yhI1lp0ADrAAxIiHfdP2SvuZVaIa95IiqbvnsCGY2BfE1+PFO+q52QClbez5uOWMxcT12DeSfD1VGm1wgCcsAVyikZXh9p8Vx1OXt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

One very minor tip. If you review a patch and you don't have any
comments other than you ack or rvb. just trim everything apart from
maybe the commit message and place it directly below.


