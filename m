Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 983E2C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:07:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A929A6B009D; Tue, 15 Sep 2026 11:07:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69956B009E; Tue, 15 Sep 2026 11:07:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8366B009F; Tue, 15 Sep 2026 11:07:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7BA046B009D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:07:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02748A0445
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:07:28 +0000 (UTC)
X-FDA: 85216325418.07.4954E3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5C035A0007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:07:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Or0xFmsU;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789484847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2oo1YTQM4+/pZ9cxl8HYREgNTNlerD/1V9/5x3e0ys=;
	b=0znvif461VxLPyYjYw/jk3c0W0WdElAUbPBEprQLKVTY2KObaxmGFDZkQ0MY9oolryzsDN
	xWyeBNjd6aze8Tpru3wdEZv+jYS63145+Z2qveUGOCO0kRMr3i1GJ3eaeYIrwKpslQonJm
	jIOEHYeRrCI91epyWnlcW7vOX1VH0+4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Or0xFmsU;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789484847;
	b=6qQC2tdjxeoaeqFYHVarpBJHOmIULspKGSQoqyHheweeggbnpZOs5gDkh1PF1ZBF1GQu20
	ygOTHm6/OZqFLt1Sf0XRffiC2fpH8P+BWGTZ0P3nfOmf0RmL4TsmgwiXSTSpxshWyUUZ5M
	CcDDpCktKi3WHgCNn0PIpRLFTRY6UlY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D852A600CB;
	Tue, 15 Sep 2026 15:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551151F00899;
	Tue, 15 Sep 2026 15:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789484846;
	bh=n2oo1YTQM4+/pZ9cxl8HYREgNTNlerD/1V9/5x3e0ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Or0xFmsUWVc1VE4V2yWed5RpVwtOQvRKaTdcug4QpmzHJ0yC2sEn+uNkZ32cudyS/
	 1GmD0pTyiWTP4l/Qq7zLYPE8RRpHWPZXroVA3cDpt+xtKjX9IXnTGbLhZd+8HBrM3V
	 odII4vBCL2IchrJmlhB+Y0/Kip/ak4oWvbxE0J9IIZY+JY5GODUNAAykqJtSG2PhXd
	 NWm1+cbdvSDDKWN4yExQ6X9qVizExG0Qu9EHNK/iXZsnqt6ZBunM1nyVKsY5YJipJO
	 /65vjFxM1dZygGKHoCPVebDkvIIQmxCf1kCIz/ruPz6xq3FDYsJTMnGGDwXvPKEkzD
	 j50s36LpqYwow==
From: SJ Park <sj@kernel.org>
To: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ahuang12@lenovo.com
Subject: Re: [PATCH 1/1] mm/damon: fix typos in comments
Date: Tue, 15 Sep 2026 08:07:18 -0700
Message-ID: <20260915150719.95470-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915102746.647-1-adrianhuang0701@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5C035A0007
X-Stat-Signature: 8hpfijwmg9axmqe5r1sb1ysijegndmwt
X-Rspam-User: 
X-HE-Tag: 1789484847-489989
X-HE-Meta: U2FsdGVkX18mZyzE6XQ2hivpN9iW2b86RNJNI+JpXACyym63Ic8DPbNysoz98a2kT1HD78wtikV/qdCKhIxeueqLl5LCBqeihOLfaw86k6Bv3kxTjH9A+C2CVc+Gz+k7rue5O8ApJiceQU2rW9x3SXoqT8mAt/Hjbb+g6fel04CUC1s9YGptMjz/XuQCpZaBqogjeoxZZuTevqlrbcQAkCLvbxECWV2bUk2MdkJBGCV21BmZ5iNKjBEt9jCOpJM1sbVBali6Yu4V6Mm3GPenQccL2UCsvtyvx6eCAA/laZ83PHZh+4c9MjNrmOna2ihSTubCZiqSFDjVdzy96WawkSDl+dVVP1dh0PWtmwke7Vl+DCUugS67cPKoQC+AAeugCYNc8wgj8i9D72O/39ZpmPjf94l3aaj6yHkORPiMJXhcxFkMSiT6K8GOAApOaj8/2AY2rUYueEerBqAOMQyiSOikoyNlZycsXm4jNte/9RPY4UTHPcgO/iNXitndSAOkjr13+KffNBJZDMMhxKM0+a4H37nYOJ0F5W9T0IDdcWGf/neFmyzVSXHhPZLHmrbu3HRvvSKPt/oeWgUKxWpnboPg+d9FHSfHFeB6xP89UtQeEmHT0uzjwdTJh51A3ZKudA75WqeyjcnBnnfO5KSm4JSF8QNjeLGz2INUiW7MYlFDm92oAowVMSNVmqWZItOdCOi1szijBhUSa3Ocw4hWl5TMpd5T+xm0CUF5Qg/f7+oQAo/NUwZMtP65WUwXd6I/652c+qgH98pd/Xzsm2XKFAZwM9d9dnzFbgcxd6MxicY2ov7a+ginTc6rCMRQ85fMNWqTccTiQQIDNUYIEbxT1PZuZhj10M3ex5Na9nEmOH5NjlL73qqN3edy+6mGUwiBwIkdQNbvo+iHjZzXbJ8jEBpikiKEZizyexvSknMDqL+Y/ixafCx8lsnlYaCqTmwrshRYuj9kwIjWxtNQp9N
 7xH4goFk
 wEKhvOsvlidbAyPcnu9l2s7xvRYeLGZRejiB/Id0RSn0CVSNXRXGH68MrIAldorJMA9XvWxNmB/xm6BbFhzWb13m1Aam4YRrv6oYWq40nDWJ0jTrw/rZG2Gf0ba+CIKuL3rWg9kAXrzdpeojAfMyIS7GdcGET3pgI1tC0bGWkZqBT69SbGaFfnr5wwmMjrEj7xpiJP8urEjmR9YL6Uxi5VgYzKogfUv2Ga5GHG6ZrnnegA0Qnc4KV4jl7j4xIOxSGww+eqcniiRN2MktYgBuEZYMizA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 18:27:46 +0800 "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com> wrote:

> Correct spelling mistakes. No functional changes.

Thank you for fixing those, Adrian!

> 
> Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

