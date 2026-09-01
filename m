Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E259C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64F56B00BE; Tue,  1 Sep 2026 09:16:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3D9B6B00C0; Tue,  1 Sep 2026 09:16:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97BB46B0168; Tue,  1 Sep 2026 09:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78F3C6B00BE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:16:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13315C040F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:16:47 +0000 (UTC)
X-FDA: 85165243254.05.215828E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7344E20010
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:16:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PtTwl+4L;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5EmtEOOlMI9psXa+ZJ0NAX7+WGqzKLkS6oODj7p3dY=;
	b=DDs6QdJSHmgGiFwwa1hgXbyi66TmUmeQaDFd535se2GXds9FHmDRZQPr+78K5wrNqLJbZL
	5DUZ4tVrTtZsDCQL62HTko/J89AuJ+M6mBYp/XJioEAVPfNLQDPGwQUnmUjm6enIkTe4xv
	BK2hp+gP+40MXv7+3jt4Qz+3fQmsQz0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268605;
	b=oX0SC3drlDaiRUIfSzIdxVA3XUvn1V1xm7LDFZc4sHiWxeYeYdsbXl15KBnuP50eR/ICsV
	dxg43s4TlcVP4kKvhrxEf8KDnVkEZaboWX7tfuja//1O9Ccvgv8PK7i8IQmT68vbSjVECR
	mmburKkDw7mQW07tBu6NyFRxoJUp6yc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PtTwl+4L;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 850DB42DFE;
	Tue,  1 Sep 2026 13:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5C51F000E9;
	Tue,  1 Sep 2026 13:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268604;
	bh=q5EmtEOOlMI9psXa+ZJ0NAX7+WGqzKLkS6oODj7p3dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PtTwl+4Le/oUwNPL2xjteGiti4F1x1HHc9wwCGXpgWjTVrjtGPRsTuXMQvnXjWmGW
	 u9h8WS4PcME11LPib67j57Q/872pr3OoI5lEGFsp73QIxGL0eMDCbx166NRlPApGdF
	 fnbp2Tdsswjae7UNXTU0jBZymTa4CtxD159TD2Vo8sbVLiQU6/K/m6BxK3OBW1NIRr
	 SL04j1yUAV2uKJN5iapJegu6xFsXH+CHOnGaSJ6TvHRoIL5VUH613YHxLYbapx+JpJ
	 E99tuL7mwb3b2yx7d6EJ3S9dlJH7Q75JLID22oQHkMBhdrn7mp0BQxPaPW8XoZS2ix
	 4DATqmrQz5xkA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	Usama Arif <usamaarif642@gmail.com>,
	Yueyang Pan <pyyjason@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/7] damos_apply_scheme() splits a region and apply the action to the
Date: Tue,  1 Sep 2026 06:16:36 -0700
Message-ID: <20260901131637.97711-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901131326.97615-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7344E20010
X-Stat-Signature: 6yjjmwjsrmckx8o1gpbd8dwsskpbkbog
X-HE-Tag: 1788268605-925426
X-HE-Meta: U2FsdGVkX188mYoCURtNCIdSgDKpW9ZiF9zYX6eeUtlk2hxdXo53mEqP9NBVdWjC4Xl/YmwXL97nXLk+tb5QTfoINuOE3UoldrlWRPdiqFZS9xYGAWK1W4NNJmFWFtEWuMIStmQ7UAsQ0dGKDAMQ+zX7y81r2L0449bF5OKsuUK9gE5D7ekX73BrcOEcf3aYSi9wijPaUDXY4JFMzBzS/jbtROmu1hxLcMrm73Wzhw3QL78I0ooFm34tfUBiDCVKu0YXN5HvkRJOPAbNF+gvPQToPybx6fkuVJ/VUxmPI9F/gNWbCpxLpFY+v7NrZj7pMX/vsKLtfa1wuZ+jvs85bNAnFgha6knT9tHk/O7RPWR6BPbFAQ+tOv0B8JbGobGBilfAZ2nxk4KZmF6Qo9QTvM2vr1CIybncGITj+HBxmmAVRqvWPt7tbF2VrgFyxxh3WUb+xisNL7P8r84tZx4jDbjqBPk/g+UVOwdv4qTnF7rFDp23ss/2JnSHSg1c2Xi8zImKb2vBTRk13BJrWHI1pGBWJ/Q5a7zgfQccBG1ZKmezpY1OgO7x6kgx7KGgk2gz+9N0/FJIUVqwSbxamA7CAn9VuyEZwihZ4Tjlvn+jbPmVxYNWoJil+KRygXkVOKAcLj24OusRBXEwqG/xFmvW389xfsyTVTUZLeaQXo4JbAVtPDX8ZkwVEBFSJTq3zt0UkZMQEGy2hBA9bOZcPU7dpppawPS2M+r8BA6ajNW8KoNCuC3g9yJOZpcng5pTDrkJ4wVE/pWUgayb5/rQUGL+HuO63UzFVqf+jTUV0aPJZ2z9vPfHHCCmwpMGGQzTorR7h/KA764XDjDPdQv7dFR860Aqv3Pwx647ru+A5FL5kVvJrh6abICOxVeDqlLnctfgc4fwsAp3DW3q0dMTy6UGWelNN9vdmWSt9aSLr7No86b4KKkM/7vaJSJSMW8RxgWCVPy+wzLJ87c6pvejSfy
 q/Oez1e5
 didACp4KeTNOIM1Jzj1gcAxoOSumQ8Bcfy8ClcBrx6Nl+d8xV5An+x7qpURr/Oc2P7b57FIN/5EkWZXwFOegXaKznh7BmjZCwv5uBOa1/ItFnlew78ASr3qqUr8o9qlI2rWREI35HjfFhP9btc5P9ml6lP5slzBFT55gLRcW2GQAFUyRTf5Xwd9AuvNu3HeO/5Jdv73XOA9hRX1ZEjHTnpsRK2jxMUZQ7x3Vr4fTa8L1eblwWJ5aX6MamPGQmJObLw5tw8navUvUYVzTzokFRi+e2U69cKtRJ5mQNB0o/Klay9hQ7fRhiWSytBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I sent this series by a mistake.  This has wrong cover letter.  I will resent.
Sorry for the noise.


Thanks,
SJ

[...]

