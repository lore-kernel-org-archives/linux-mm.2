Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8205ACA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 06:10:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 604C78E000D; Mon, 18 Aug 2025 02:10:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DC6F8E0001; Mon, 18 Aug 2025 02:10:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3CC8E000D; Mon, 18 Aug 2025 02:10:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C4338E0001
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:10:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F14B283E3A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:10:28 +0000 (UTC)
X-FDA: 83788853736.17.7A1D5FD
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id BAFFBC0011
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:10:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=f1PwvdQp;
	spf=none (imf10.hostedemail.com: domain of BATV+597369eda0ba97e1de7a+8030+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+597369eda0ba97e1de7a+8030+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755497427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dpnwm04mLZ9r5oigDr9e2a5pokpGR4TaQMRCA1h4VTE=;
	b=rv0npA+6vdMwsjzZKYTbCgOp+5oUqABDPdeE3AHiaP2mtilsvdEK6LnD0+QX5I7f1j6XH9
	4svJ3EP0HQfSRith0QBcZpL/PPb0I5ikZkhMKR/C3JUzR17jSun+XlvGt0jx8DxlwhHHuo
	DVviKrJ5ih5pUcWeLCXXNUngoBqvLbk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755497427; a=rsa-sha256;
	cv=none;
	b=51UYv6ewzrygFIpNGv87ccSAEliaJ29QGMUqD+f/N28fz9V2XE31t90l0ERNnqI20LNPns
	k+pjyY6ofaRBh2aMXysj5/zamF56N3VJ6HN2T8+bIFpxj4a8joZPaOw8JiyBeQKsDPi7td
	qTRUn18pK7DaB8oEvfCtiKZb1ZwY3SE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=f1PwvdQp;
	spf=none (imf10.hostedemail.com: domain of BATV+597369eda0ba97e1de7a+8030+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+597369eda0ba97e1de7a+8030+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=dpnwm04mLZ9r5oigDr9e2a5pokpGR4TaQMRCA1h4VTE=; b=f1PwvdQpvwfaPRcIJ8U32YGvLI
	q1zub5osggMmsp25CcFpJEQhwSgClZedqucIcJ8rp4AxZvP06CG8407nP40F/1JqCfMnM+NtMdy6D
	xI1QpL5Mu8PiY8isRAhuUJP9C210ghHO19Zsoakt+cLVlWf2U6eU2iLsmkUzgnErgBBQKfLrpxXTz
	f5UfqRBwsniaK3xV9dxg/2FkMyQMOyeY5Fbo5IC2jrEAdLaOfCH+yZ5LX6f43pTL6BOS6/6yF9JmR
	nkSxCxsa8z82rogN0H4Lm8RdccWgIh9RZNpd0fD5mig7Z3dzbnXyT0ktXpGhpwVZ46D5FLh1Y27Y1
	b5hGUnkQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unt4W-00000006bmJ-2OXI;
	Mon, 18 Aug 2025 06:10:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	linux-bcachefs@vger.kernel.org,
	ntfs3@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: remove write_cache_pages()
Date: Mon, 18 Aug 2025 08:10:07 +0200
Message-ID: <20250818061017.1526853-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BAFFBC0011
X-Stat-Signature: todhbfy4x1cdpg7kxbbo3rg741crmc8e
X-Rspam-User: 
X-HE-Tag: 1755497424-478063
X-HE-Meta: U2FsdGVkX18aiYksF2FuSHDtk3I1prFD/QhMhUW9aQKl7/c6ZQMxT6Bm2OzWVwzS3Uy0TEYXPHLfWoonziC0Owz2QHbpyOF49sVpDWHa1BGAwOJ5oYVj+Ias2ZR8n6veLR6XdUUceGODeUVq+LS6XnpDcVmmLQAkk2rrU7izY9HVRiOq+amxBgoUGtGJ9pCeW23DGEGHD6RVW5yInhu3FP7NepQNhqrzG85HIV/I4KTZVE5gsGpoA3EL8dU3nS1CjLcyTEaUxil1H+aM67ohU69wD1OFcSpdJjRAlwIfhC7RGuFbMunKg0JND/MDbLgSKaLEFnYJ/AnOnbigUQzul08ix7WP2+vB9CAp1O9FqgM53F1+oIpQ379tYEk/1EuEC++kh+WHwVkzaAN9qvVL26MHuj5nKf3exSC103LsZ+mUdydYS8BmcacGrVP91UQ3mVj6mFmkslg2/hsSNCv6QGl+VQQuSNZZ/60YMjfxitle34aZR+hGSQidOkBeM3jCCOhKD87EsG7oHG/ABCpWoYQlWbxogsyvLy0UjY1qwSXbyP0GUyZ4DclrHjD2OJBoYbwVKUpMil1gdywoRNHmK/DVVYTnx6ZotMCPwxCbIAkehYgy/sxZbYVjY01ScfI4xl1IZr4QHZALl0kdxj6uRFGzPlvQHU1xRjpITm6J+68rnLSBJTKx9GbzBqTA+M+WEtU56aWQxojvGI6D8sf0WgUAU8PUeUsaUz8qP6j04hj3qZEdTsEaAdwXqblo/0VsC4sG8lPJ5rBShOViQkWSZcsPEEaIpb309Cw7Otp7S5sXMGiSEEu3EdpE7cu1OcG4LMSLa+X21jIQRutX2OeSY1EzmwEbTFR6YRi7YMY+e8/NZv1lDJcnVpLLXT53b6WwMVknnFZV6MiGRezjfbXWOaZ8ziY53tXqRFUQ/kRWYtCWo/xplA7JF6s+ktyyqwps+hNTfcEzj7BCsbXnBiZ
 YqBg8Ed3
 CVearTm2oZezGkuL3gaEQ4btQRwr0GnIPvuR9lwbaPOmncoi025Gs4L1+HVz8QgglqR0njJA/ko/j3gte12LJmlzNDbDuSdQp/dhJSekePjCPNg8v5DxC5yqb8tEI6f1vlW/jbQ3HUAIFnoInQJL8imxdD/7pFFC1truFdek0QYftZK6vyk3hk3P1F8/FmJcdJsF1me0lNEfK7V3VrXLwJquPx2XmyNgqMJyEIc/ehaRivfOKFXdh7QoVmyOX1wp9qAbWUJmGB61NU66upJVAnS2d02zwegSr7k9Lw+E5Te1NexM0QEgL7NlQM8CzUuQQkbjFG036+Oqdc/+KT9P1tairq/h2M+JTrt/6gBLuTxK+5KwKacQ+7lDuH47O9kzuDwf/wx0ND65V9DKpiIn7kf5ACKxs44QvrMYCbvvN1fD4QVopSbV0supEawMw1CelF3ONdStEKjd5P9rQ1dtwvgYk/m10ojRmfr1CslVWqZjN8bachh2VGYMBRNqDjnccR3mKuxGBwctoiWbzrmQyE3+PGdloojnVclK404KVLmXBofKlYX4D2/h2n5Q95WVbcmXkCwqKLo5eEd350rN7nuUtl9Y/INvmsYc/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kill of write_cache_pages after converting the last two users to the
iterator.

Diffstat:
 fs/bcachefs/fs-io-buffered.c |   13 ++++++++++++-
 fs/ntfs3/inode.c             |   15 ++++++++++-----
 include/linux/writeback.h    |    6 ------
 mm/page-writeback.c          |   30 ------------------------------
 4 files changed, 22 insertions(+), 42 deletions(-)

