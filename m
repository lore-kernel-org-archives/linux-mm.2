Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7729ACD6E49
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 16:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95B526B0093; Sat, 30 May 2026 12:40:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90C386B0095; Sat, 30 May 2026 12:40:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848F26B0096; Sat, 30 May 2026 12:40:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 770C16B0093
	for <linux-mm@kvack.org>; Sat, 30 May 2026 12:40:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07A681203CB
	for <linux-mm@kvack.org>; Sat, 30 May 2026 16:40:53 +0000 (UTC)
X-FDA: 84824650386.23.2DFBCBF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 88D6540006
	for <linux-mm@kvack.org>; Sat, 30 May 2026 16:40:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hdCbWICb;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780159251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2zzjgsQUdD2nPmtqx/bwdNf+Rj3UakuTlFKNAWi0pfQ=;
	b=SGzbbK625IvAaL2JlDfiY4Wn0Pnc22a1s1no5rRqozceFmIPavKLq1C6TlHybeZZNtihaI
	+MVforROAsBmRGJOd8w1zKsNP84S/xYhauZRZF4x9g8nXXSWYdoGQpJaeGpzCCuiGPv8t3
	8J2qOglL6DYO8bAtg2PGOuDuHfpdml8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hdCbWICb;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780159251; a=rsa-sha256;
	cv=none;
	b=wHQ9ON3b8oKCI8EPiWMy/fO1cbY8LwiCw90xD9z3JzpIEYw7J/a1e+Mx7kZFo8gzBtkfMv
	wTs7WSs0TsjxldL2MpmKh7WJHqcxoMyyylSkX3zL1egSOx6d45yP51HIIHtf1ga5wp3I1q
	avhY7qzBw5hJUZbPFULIfaYY8Y18xhg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0FD13600CB;
	Sat, 30 May 2026 16:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64961F00898;
	Sat, 30 May 2026 16:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780159250;
	bh=2zzjgsQUdD2nPmtqx/bwdNf+Rj3UakuTlFKNAWi0pfQ=;
	h=From:To:Cc:Subject:Date;
	b=hdCbWICbwFBa20wkKgcr++ZnmP3piO9vDq4VGmTwcpXetOni1Ua0+m2oFjEiRnPq2
	 obc4LNxxhkVwE9np0zbtoeP6gj0t029XK/xjy0VHFmW/8Y3U+03ioDITaQA6hV/a3k
	 ksC7zQ6+HJmLFroRIq9zF9Wuo/AhIJU/vqZQLcwp3M9F7yIvJSkOK1zrt9cFAPsuKk
	 h4A3zqUhuVJTHs688PotTEcUfzBEP84hB9drGjk3nO/+VCHn5EvCrr3tXXn8qH7azp
	 YKPIm4x7q67aCkeiWZ2dqfmkuDD2v0b8jIsbcu2mic23lEnOFhDwQ/Abb3Mj5N9k3u
	 +ENm6MaVxwLBg==
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Breno Leitao <leitao@debian.org>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [GIT PULL] memblock: fix regression from memblock_free_late() refactoring
Date: Sat, 30 May 2026 19:40:43 +0300
Message-ID: <20260530164044.1428118-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4rtdw7i1c8qq8oyqmnfzjt5ymmcmbyzt
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 88D6540006
X-HE-Tag: 1780159251-291044
X-HE-Meta: U2FsdGVkX185zXSytFTJFy4RhOLUGlUFz4ZrBmsgcxOjRU9N6yVNTh1UnS/dgRjz48XIxVEpERWvvWEp762L7aaF6BoDKlky4ddxb+YovQLXK3r3hg0io5IlzcW6GM+w0VTvT1B2XSzLamvaVwb8snL4PVd9n81dCQQk8NovvJF5LHCJ3EU6t4lkRwoCSZM7HBb6YjSYoTK2mxgJzDTPedxPm75UWSluY6FNGggNWno/SPllLJMh8O97p1ML2YDovllJ7GqaOdzH8Ja6DHf2wkj7WEdY6+huOgrtUdBhBtWZbspoMRDXz3F2r8Jh+Euj+w46em7hj/OC9s+GxlW8I8TtaxP9SVskJ2IkTYQvVP638/k3xyKZLQMRFc0cA7ImiBh7FUp0sdvW+k2rSvNiAn1en5kuo7yhax7Y9bcvSV/z87qHW7v7CWz3tmiFTur9Bl39d8p/mIGltzH+A/z2IFPqMII+jmqOyev2kXvM916qUVfp5WCxx0hlTC/z1q2SethI/ofeC4vDfCaETOyBMQJEnGoIE2sY3RJFCIXL8Yc72TSTld6fA6GK4lYGzkjkORZ2Te84YrN8gyZfjjj9bFi8xlupuzct49XeFCS3k6uT89gjM5Q3+izbR8br2LbIRCT+QTLDqG4Y9jPsPsuNZUcfQE+sxq5XhNKYkx1iTSa+114neGEet8e7SgbPGGBiNtgAmgjsSpQmyhYaz4Avw6MAM3lbaV/z7HhNCO7YnNC/tfyMvMZzdpO7awjq2Xtf7bsZ/JNVXQt45hsGU0OEjZd2vxCI+entGoiAaVOeu5n5uEIKOoXdX5RarMQFxOdLRekSK6f68MjmVaunuuB8SJ1wGIzVSO83dyU9QWH7CReTBCPx2ZVS0hrvJpiubS4FafhHVLYvMD7aG9oYE+AmA0YyYkVPxlPpQhptdLw+0V99UotrweWoLJFXG0C9Jqzw9gCLnd8YJnPtVj5OEaN
 SAVlFII7
 7drkchJcmuvVr6na6HVRuCnW7udAg3g5OX/BhHymSiXoq1QTF1TahbFi+zyhINSxEVbQyjn7H0igINYES/YdjLkOyjftjEqCb+Mc2dRdrq4pFe43l+QgSb9NcVLBpWWufeRAzAxZ8EsFWyFd4H1Dh0+hoDhZxlTH4FvtEL83EAKecg0qJfLIhZz1XNRz+301hS5gsy0hVU1h/YCKrrrmwNIpNyt+vOFyrQtOMfhJ0pTw++GVsPdeJAAFeOiIpvUEA9+qQlFeeF6dty2WwVd0nZoKeuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

The following changes since commit 5d6919055dec134de3c40167a490f33c74c12581:

  Linux 7.1-rc3 (2026-05-10 14:08:09 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git tags/fixes-2026-05-30

for you to fetch changes up to 7c2eee9c136734825ff524dd8b2146438a4f8250:

  memblock: don't touch memblock arrays when memblock_free() is called late (2026-05-25 20:48:14 +0300)

----------------------------------------------------------------
memblock: fix regression from memblock_free_late() refactoring

After refactoring of memblock_free_late() and free_init_pages() it became
possible to call memblock_free() after memblock init data was discarded.

Make sure memblock_free() does not touch memblock.reserved unless it is
called early enough or when ARCH_KEEP_MEMBLOCK is enabled.

----------------------------------------------------------------
Mike Rapoport (Microsoft) (1):
      memblock: don't touch memblock arrays when memblock_free() is called late

 mm/memblock.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

