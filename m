Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCCD3CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE7B18E001D; Wed, 12 Nov 2025 10:42:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A983D8E0002; Wed, 12 Nov 2025 10:42:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95FF58E001D; Wed, 12 Nov 2025 10:42:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 73CC58E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:42:48 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4238D1A056B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:48 +0000 (UTC)
X-FDA: 84102372816.28.A356E05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id B2B1D4000E
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VPxNTBtu;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762962166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yIgrDpD3CrWSyVuSFtCsRsBF0u7y2CQRSmKcd9cGmg4=;
	b=vxVxcKUPmqBTJnFaVhgMnRLvAs7Qjn2NswZJtwhC/J1HXFwP4oDU4FmX7u204HxjnmfJ8K
	9vFAmSh0e9gOwdvP+Fy/d0SFsC5F9O+lQBTtQp+LupkpOj8gcpNGkwIE9LEhKXeGgkGoMd
	VHeLgrfkqDi8vvNa8pW1FfSH16YUBmw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VPxNTBtu;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762962166; a=rsa-sha256;
	cv=none;
	b=l9BbgjxQTGNRrxYoo9K75ceNj2wimhmhKPfe5YxHRSJOIexho/JWl1+OH/4xav2FkD3LXq
	PDkXDMoebF/AwHN1p+VVwL77HUyXCZTpHEOIyvIrttPYBCpujKrC+nLN7KQJyY3wN4N4ac
	UUiuEfLbWuDhIR1YFQb+knPyQWQJ4lI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F899601AF;
	Wed, 12 Nov 2025 15:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EE4C19421;
	Wed, 12 Nov 2025 15:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762962165;
	bh=+Y8/mmzsL4R1VnXUesO/LqQSUharTVlUfdkKQD15AOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPxNTBtuFzWP5E0kbJfUaoHse2TRa2w3nZ7fygR+O4btmVa4UyrFKKPFIVhBu1gAp
	 /FxcP+pNURKfWiadsKxQsW+cuQkIE/ik57NaUnCq2om4A6XN+9Ev2fZEbRPl/saqy1
	 1FAPq3L/MS8HBKtkCko/vb381RHwcFxRcnYu5clqp4frD5Mt9zBWEibZI+OOpbRNbP
	 cQfXVgDHOBs+XzBzlIYZcLlZB4gv1NkonecWttOx4sE5fIOLC3ztqIX76Bg6p7aJ/F
	 UyGuKTdsWUkuCq53Vhruu08ckKwqpZWi//L+HpgnQAl0Z9CErM3dHFWNwKJqxnanBt
	 6+pGTk/lNP2ew==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 8/9] Docs/mm/damon/maintainer-profile: fix a typo on mm-untable link
Date: Wed, 12 Nov 2025 07:41:11 -0800
Message-ID: <20251112154114.66053-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112154114.66053-1-sj@kernel.org>
References: <20251112154114.66053-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B2B1D4000E
X-Stat-Signature: 48e57dqsc8xsupkfcednutw3ou4dq38n
X-Rspam-User: 
X-HE-Tag: 1762962166-364389
X-HE-Meta: U2FsdGVkX1900whxyAEXliNU8LoW5RBUG8ohN5PL7sJWo8zpkwpB+PYYfABcJc0kG/jT9JIQcmf7wAHbbK+UW+vFQdzC0rmoiiYINmKtngDjWcV+PmakpDQ220Y+fT2yh9CYSpGW7dDqU+0/ImuSKqZwinoEnRJApSGn07TMILZoEqQAkFVv9wGeHjq1BY1asfu8Z4nO0WtcK7eVgy4Ls/z10xf2ixHs4CUxuRZ95biYBJhZsyBFReQyYTiptcEOLxNMU1Qdv3ljUCGM3NxKIao0IhFogD/pF4eiV9yT0oMgDgwe55AxkSB8vpAMb+v/8ui+pAKnQeeJtlajcK//uBnq6HlBQ7uurUPv3zQhSkVbbtdt7rxqp+kzhFapsVFLrNdTXWdEHAhgztRknXbCSj/JjuOwc/qH+yFu7S7uuylJqHDWqCAMgYgGEID2xSLcd3HGd0tENqLUh+5qszCDZvTndIv/O2RMnmG0CDOnr1RxZsXhnzBbsm89MATaJ68f9ZecxC2Pt8S5+8rViPLGqkzuLou6Fc0Ie57kR2DoTiw+d/tfszpMSHgu0jVRkfsko65SdvZMejk9BD8O1GQyvMlMJMecVeopCtt2eKBAakveA+TkofukEy3sqQPiZmnW/0eAZkWMFT1zRdi+uURTQlpJZjxdrhvM1y+ylBPsVMKmqcDsDLQ7W8Myk/clr+JJKVdCOeIW7KzPPt6uCKh2Yz0JJdI+I+W9+OZh2wf9ogjacD9xrscsmtqpFGGYg0GhlkowSk4WRyltlOWMCOq2mczSwx+BkWtJPsjd97WKSswXny7JKPIhsfVkFXJQvZdPvEHYZZHV/zEBP2qPBpSwPBU4GW4H5EvkExiQBjQqJiXo6JkKQju4+xrltkzPD2k1TnAoK+laMoLAASPVqCg3JkYeYx0NiS9Yr7usp46Rp+0akBZhwV8IhpzCt14o1im/boaa81jx6630IlLNEzA
 6NJN9vk9
 5U/8D5zb7essJ1tsA4bvUelWnmMkpPpHCdh8Zqm866u868HjqPzKHewrdrgRoit33Gieu9p/2OFT0NU28j+phGMk+7mp8i89pJGuwN0vxKPO4uasUu4w5vr3xQHDF8Zx7gFHhn8PBY0xDkGY8/VniEjLST9S0COP1Mnu0SYKBJzo1t2KA9ifFLwtiqYWgkxlK7K3SKYOOIL99Z5vwASkail4pd5r4x5xjPtQEeTyPJDJuI6CGXOuJLKxeNUVllNwgyzHYU7AS7DtCzkU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 0b473f9e6eac ("Docs/mm/damon/maintainer-profile: update for
mm-new tree") mistakenly forgot putting a space between a link and the
next word.  Fix it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/maintainer-profile.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
index 58a3fb3c5762..f1aed6e55d31 100644
--- a/Documentation/mm/damon/maintainer-profile.rst
+++ b/Documentation/mm/damon/maintainer-profile.rst
@@ -57,7 +57,7 @@ Key cycle dates
 
 Patches can be sent anytime.  Key cycle dates of the `mm-new
 <https://git.kernel.org/akpm/mm/h/mm-new>`_, `mm-unstable
-<https://git.kernel.org/akpm/mm/h/mm-unstable>`_and `mm-stable
+<https://git.kernel.org/akpm/mm/h/mm-unstable>`_ and `mm-stable
 <https://git.kernel.org/akpm/mm/h/mm-stable>`_ trees depend on the memory
 management subsystem maintainer.
 
-- 
2.47.3

