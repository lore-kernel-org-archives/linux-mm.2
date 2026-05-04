Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38DD0FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 16:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 670666B0088; Mon,  4 May 2026 12:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 620DA6B008A; Mon,  4 May 2026 12:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55E226B008C; Mon,  4 May 2026 12:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 493C46B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:58:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87B33A0227
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:58:18 +0000 (UTC)
X-FDA: 84730345476.07.A842920
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9BAE5120007
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:58:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DQBcbQWk;
	spf=pass (imf29.hostedemail.com: domain of weilin.chang@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=weilin.chang@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777913897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ph51h16mN5ALauWwsMxUN6Ajhuz1KsdblGQVgMgn1aE=;
	b=mKmrAJYchv8iVcqd/FwC2eHH/pB18X6ETBLR4+XnE3tXaoXAT6e5ak8dPPkKMmUNi7do3n
	UYRRs5nk5aG1leq8Gsxc7bwHIJQGxOocXAoSxXRrzyIbIhs6NY4cs4Acvh2ryMkqQh08Y/
	NO4hzWtD8yNXLdBM0Y4NAtY0+9N3yfM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DQBcbQWk;
	spf=pass (imf29.hostedemail.com: domain of weilin.chang@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=weilin.chang@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777913897; a=rsa-sha256;
	cv=none;
	b=3YiW4esIbrzTQBUXCKKhKBzZN1o/V/ZXQDEK8Srhq9hXZLU+nkmUge4EePT3sAg+WKQ77M
	I3mDocAvp/rmsURJrWDF2ZWDFl16M4muqcLucIzU8ehJ2PlTYDov4sTiUE0M+Z1cMio/Ol
	UAAhie0zl8t6J+IJ/w5tE1abtrQognA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1EB2169E;
	Mon,  4 May 2026 09:58:09 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E2DEE3F763;
	Mon,  4 May 2026 09:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777913895; bh=XhgXUyGfG2nyaluK0MeJ9Ts+z2JPQ05UrF+BAsOzOis=;
	h=From:To:Cc:Subject:Date:From;
	b=DQBcbQWkRpXner/WSIx9wZbSYOCYk7i4K3TCNHhWuUYE9J/zJqLADFOWjV6TEnTay
	 nQhe1uzmCQViGe41wg6qd2MkJaCHzvCvKQ9x1IvKfPulWqwEJlLVu9maIWONgP/rO1
	 tPWsnNUP8wdcw7JKbQv3dC1skMS0zTEoQ5WPSUlE=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 0/2] Documentation: maple_tree: Improve statements on reserved values
Date: Mon,  4 May 2026 17:57:44 +0100
Message-ID: <20260504165746.1422057-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j7xxb7xrrbw55j9zyfjimu336tc7kbqt
X-Rspamd-Queue-Id: 9BAE5120007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777913896-576447
X-HE-Meta: U2FsdGVkX19NwAtb/Iy9KrP/fc832Zrz0AEGAlUma3YNQRsBu93ZeOIclG+OIMAwYm5P9b/DDpUS76wCEBSUy2a5uc7Cs8ARi9x4ImleyFLEvV6DorX34op8SXuPSGZ+/Ix3ugHU8+mJIBgxkkglUCo0lA6umiEmHO8v4AMiIq3eIQQZGESbfw5qd1FkNIv984T0oUPaxIKNHoK92dtMBkb8XxEBJ4hJKhk1h7ODaZkbg/r0Fb2R5GXNqtDpPCEkXXYGckgkxPbpr5C8EHv/uBSL7Yn6ng2rRUQZw88k1ye4j1EeTq5Syt/cS5MI3JWUzFif8b6FTnwE1zyM0Z3uojDnH+cpFjIxFu00NJE8HkXI0PMD7UQbnH8vh0Gdl4ARYccRqpXxN4PXYW1bXWUSIFXv7VVzP+0634wYPNanhlVuVqVom+9kbMmm/9Qvw+k/iBdO0zGQeTDFguRPk8A/3s+Jdz3/SSFQf1Dkg2czWoOE8LsL8RFhEeFvKP8ObamGHlVhCaX4c1YBOiRKJjJ6DF/oIK5mwtUFmz4KqkP2Wxek3YPyLD3Hrp3jj7mT8ajqWysSyJGenHnZHvwHm+g1V2BEaEtY1OB5DYQn4q8+yyws3+XPZI7RisUkWkxRBnp2lXZ+ZRYujyST4rML1qb3qlhXglFq9dxgKj5SB3pengEaUOV38/5brM1GAr1l34girv4KWWUj3eRobBwmuNUXAPYAc32+lnZErwMu9jcuUEREzCb+bgiqhBHgGWJTcN2RPMu5XdO240FHbbO2/zUN0pwvkTM+Jwfoo/oq8Cf4/eBYioD0+L4vEKoKPmhYLxhU9vczddWVPhHJIxwe0G0/MmXU3iaat7viO/o2uqN6Ax80yjoAfhAHwUTTqpytVlH4fj4aoxQU/2lnPr5izUOnaGCoFaumDQwBVXquhvFliXCk8vZrE/3QTvkBxbmeE9GKz6sgWTaC/NN/oYKGIxA
 j1YQ6zp1
 IndYHxdm63EtHupjZuMAXquoUQiWWff/vrjUkfnfovQyv+BdfjDI2q52fJ9eGTXY3VklSrk69Q4wAk/baFsKZzp4TgvdConuZj/ZUmzlTCA7Ng/RBjkYqA+hsrOnAyubIdOKhO7xNioGVNbpWxBKz2qId8KTV2H759m07mvc53BdZXPOwC+fZZQe9I4DHfYvrFIA8Xo82lckGydkfKcGNRg5sNTCgIINtaMbDGtCLnjYYPWVyzmkHVFMuN1DG65aqvlmbjgvA1V4PALny5v99Fpr+BpSJUsIk86/f8C0SBKtQxY1NmaQIGU2Wyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This is another version of [1], where I improved wording.

While using the maple tree and reading its documentation, I found a few
bits confusing, mainly about the reserved values. So here are some
changes hoping to make things clearer.

I am not familiar with the implementation, so if I got something wrong
please let me know.

While looking at the code I also found that although the doc claims the
normal API blocks reserved value stores, the code checks this using
xa_is_advanced(), which only blocks values up to 1026, not up to the max
maple tree reserved value 4094. For this part I am not sure whether the
code needs to be changed or we can also improve the doc.

Any feedback is appreciated, thanks!

[1]: https://lore.kernel.org/linux-mm/20260418204754.120405-1-weilin.chang@arm.com/

Wei-Lin Chang (2):
  Documentation: maple_tree: Point out constraint when using xa_{mk,
    to}_value
  Documentation: maple_tree: Clarify behavior when using reserved values

 Documentation/core-api/maple_tree.rst | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

-- 
2.43.0


