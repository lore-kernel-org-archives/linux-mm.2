Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA9BACD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FA956B03C8; Mon,  1 Jun 2026 10:22:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AAEB6B03C9; Mon,  1 Jun 2026 10:22:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7D76B03CA; Mon,  1 Jun 2026 10:22:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5726B03C8
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:22:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF238A06E3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:22:45 +0000 (UTC)
X-FDA: 84831559890.12.E23496E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2C16B18000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:22:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RiKQ15m8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780323764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xb9w3aa2+NN2w8mM3XFth5LPOZJyIKQb/PyqpCrSq3o=;
	b=EHVu8h75B1p0dn7XEdt8XmPOH/vbLWk+I7KBqKCFHpGTRykjddg54TZgszuXQiORezWZCv
	Jk9/IzClv4Nt29UVM/OJNFWRd3L+uCxiB64FGf/HP1pMUQ26VOix8eoeBeKD3AR+XIqJqt
	mEgGK41YyDxzwnX6h+fQejNj/f6S4s4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RiKQ15m8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780323764; a=rsa-sha256;
	cv=none;
	b=e7Kj0dv7/vPZz/xRgpSODKtc+QmHCGi/5bLjDdwXE7tGdu0QokyXwQWD6BKpdlhm5sGUwK
	l0v52BQJcHSrXxkB+3ORjhBIKxLvtsnEqY2nEBZ+Mx0j+FwvlhzPZ+JtUWM/pxvRfFHK4p
	EOK0tpddql5XzpKsONR4hQZuq4nPKsw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22D234081D;
	Mon,  1 Jun 2026 14:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4F51F00893;
	Mon,  1 Jun 2026 14:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780323763;
	bh=Xb9w3aa2+NN2w8mM3XFth5LPOZJyIKQb/PyqpCrSq3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RiKQ15m8NA69rpL0S4tXOXueTA3Eh2CzXehotde7DEgbVF5txXf3QUHJp5BwrH+Ef
	 PCOMLFoHhJpLTXJVgA0PWwWf6RrcQRUvaNu44/zbMSaIrBolFDAeajSLxhcmEjl27a
	 TcQQxGDb7p7Cml00flwhT++TDnL1MFD2/q5x97xvN8frnQhtVJKA+7HbLZhpGxy3iH
	 lyy6Rbu8DNx/59AcgsExWyLrY2A3D3gNgSjukrSlDBEIMqF6T8o9rMkf8iCbfzJUQG
	 B8pxHQYeZ6Q+IM/gqiycdg7FoV4Q/JB57emE7DraJLqTSpBT7JLNDiE4F0Lkxy4ebY
	 vpB9TzxvO6fpw==
From: SeongJae Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <chentao@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 0/3] selftests/damon: misc fixes for test bugs
Date: Mon,  1 Jun 2026 07:22:33 -0700
Message-ID: <20260601142234.111301-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260601032314.424013-1-kunwu.chan@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x1pbeb1wrtpfwww5hq55768opmep3fms
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2C16B18000D
X-Rspam-User: 
X-HE-Tag: 1780323763-668713
X-HE-Meta: U2FsdGVkX197Xqa+NVv6g6OHxyk23AWGCqTFdaBXYCSdzCopwYVssCa4w3+sLk0nsMyF4aD5T8bjHr5MnY2MrxKgXRPESMFaH5PKrpzbVa8iU+8Ys42T1b5TWZmZ5X1yJ0WugllkYgGavvMqbiyLGVoRNqkS8iBGi0kua2mMdWleX+jRL4RdMMRpqN5Z72iwzuq73iql/LSimmteXVrfi95y4h1pVajAuWyEo36p3ZwrYbN3vcLEab8YlWKi5TzUIDui4UOZyX5qDiUN1LTMbE4wARmszdb9sWEVEYkJ74mrq7xbtLaEjv4KXIfhdbws/smpE/i06TYZM/RC60Rb1gmENxzvH/VPvyj3jGEQ92yl/O7xkIt2tCZf74QpA6qzmwGIQ/THm3dWDiuIoGeq8EfhzIP/PFvxYCrSOy0OGPl78XzOmBioUSWqa/mctebWhnrP+x6hto1gNKSDXw0dAIGTh+XE8SmWTur12yxdbhGN3vgDq10uk7Uqap+JR/VO5bnQD109Loy8Zks4jZhh6kxjmdwaCXJ+GagK1rSIwqRq8HjSgR6kD8nMw4P10jFkUv/tVmKdkmgn6bn62yHMWOFT2pzKbKYpw+8DgtSqHr6ZQhOqGN5oVg0zx94D7g/aI4g1S/QTAMx0U6pqa/2/SGooqs4fcvmPUUUqOQP8ihuuj612kUHe4nFjQbRYxqt17/Q5z0E3hqXPr7AX7r947kzzz0cir3iQz9QQ9Bfhtmwhv1PDiEkWUOYJuK0Nk2qRn2WU8Mmtqf1KaNC9TZ5Zgq3qJEM7AJjdFla6W8fIO3qzX9/pOrll/4UVzNs/tOmWOA15GQdkC0Zsc8GRYpUF4ewYAZyDQt9Da0a0PSqeC6RmfLEkQm3+4pP5Mr+n0fHej3wOCZAVHF2JZIMjqBzgRHuziqk/28mUTfBlSzDYQMTe5CrfTYPESClI5VdzecjzdDBgW4cqRpy86Z3nNSw
 JGOulbBv
 FxjuomYIFA6u/x0yCsgky/K9hyF8bxa6FFjM55qL0STqvvpXUFh3GhfQp0zDLA1wet5l0QGwwgj4T8Xa78gCir4Z+ze+GmD0T3+dxBT7G3s4NccpL7oNoIKJ2glAktgACjZOm/nzHLoXpGeApGhow+EBBpaHxt6EOJMJY3w4sRErjdGWVZz1jYeAj/UXNMTKT+9onJ63/NqyfLM1DXaHnDt0lKkqUXvkResSd2/SK/3JK9vWLpneJEnGcatxVwRC6+s4U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Jun 2026 11:23:11 +0800 Kunwu Chan <kunwu.chan@linux.dev> wrote:

> From: Kunwu Chan <chentao@kylinos.cn>
> 
> This series fixes several bugs in the DAMON selftests.  Most are
> trivial but cause tests to silently pass when they shouldn't, or
> fail prematurely on slow machines.

Nit.  Only patch 3 fixes a fake test pass for "avail_operations" file existence
test, and the series is not doing something for slow machines, right?  I think
the last sentence should be updated, for example:

'''
Most are trivial but makes test output wrong or even silently pass the one for
'avail_operation' file existence check.
'''

Other than that, all look good to me, and already have my Reviewed-by: tag.

Asssuming you are ok with the above change, I applied this series to damon/next
[1] tree with the above change.  If this series is not added to mm.git in short
term (~1 week?), I will ask mm.git maintainer (Andrew Morton) to pick this.
So, no action from your side is needed for now.  If it seems I also forgot
doing that or you cannot wait for my action, please feel free to directly ask
that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

