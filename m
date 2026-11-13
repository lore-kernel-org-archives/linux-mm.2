Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8447606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 09:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TqC7GbJh
Received: by kanga.kvack.org (Postfix)
	id B83576B064B; Fri, 13 Nov 2026 04:43:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B34856B064E; Fri, 13 Nov 2026 04:43:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A719C6B064F; Fri, 13 Nov 2026 04:43:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3206B064B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:43:30 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B14AEA0555
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:43:28 +0000 (UTC)
X-FDA: 85429608096.04.8BAE780
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1F458180002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:43:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TqC7GbJh;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794563007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xW3YbfBhoHEyzNLPOQyPfY3kNSYPaEkIOw9uSvk3Kw0=;
	b=V3Zvep9QlXm2F+gdZMAuRWw8FnP/uJzLt/7nkUFhSPE7ahjIHzPZlj933/DlYPbhpUKoSu
	bPoipm6PJoBTRZ4q8GrJ6rcq7sKkpFEbxs4V6nRiRs+GNtLOf5fIuIEln0Fdmis9PcrzfT
	vukpBJ18dpIPxNgBFywlGJIMNZ6LxtY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794563007;
	b=kbFT76eUJmrdtZoc1UXmLocG9tBG8n1avZEZplW8lAsBav9qKpdWQaH6HP/khnOcY6ebeK
	5pDQtJNC1Uxw6mAk8P2se59UtO0xa9wXnulpkGmljcaUHk1Txt58kRBCzAQ+cNOZXTBYBx
	o7MazON0ks3Oicd+fgT/JafhZWIiHw8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TqC7GbJh;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 93A656152E;
	Fri, 13 Nov 2026 09:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2D61F000C4;
	Fri, 13 Nov 2026 09:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794563006;
	bh=xW3YbfBhoHEyzNLPOQyPfY3kNSYPaEkIOw9uSvk3Kw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TqC7GbJhdhCMDDNCzcYotcWvJhf/XO6f9/AeNP7U+MfuEzjXlTHD/w2CZKH0HSSA3
	 Q1Gqzi9pCjwyhrwoT7tVI7TY6saCPkd4bVyFLcDe31t6YrR5A6PM7c+cCXrKpSiOTG
	 8OUH1snZowoJjyWW8ayo/JbbDf+GrvkRoljpX0xHbTqWbemGHPB6ZQ++gwRGI/CYu9
	 PKMC3oJHYiPwO5gZgHhN1HHTz56Ov/nczwi5oFtQlKch0xS+40IeesEs9n97jPviF5
	 OJNZAm9zRB+RWcWSleQq1X1a394Z6bcqYUcwHQ8MWCGvWFK6n7FzJ9H2P9MfGoqVKy
	 FTOppSQewqzoA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?UTF-8?q?Oscar=20Alejandro=20S=C3=A1nchez=20Lucero?= <aleszlucero@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_reporting: document @order parameter in page_reporting_notify_free()
Date: Fri, 13 Nov 2026 10:43:08 +0100
Message-ID: <179456297819.28103.6590198375118654363.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112-page-reporting-doc-v1-1-593af69f3801@gmail.com>
References: <20261112-page-reporting-doc-v1-1-593af69f3801@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1F458180002
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 58itkmcwuxyk8bcf3bics41xzf1xkprd
X-Rspam-User: 
X-HE-Tag: 1794563006-963149
X-HE-Meta: U2FsdGVkX1/cahYwiusnyDfejz3PTiWtvt2tGmo0gO8gQkZEYngJ9BA2kAAyKRTiTaDluxTlnRt32uKyDhgSx2naolLbsf5IFlOPZpkfIRA509dXNHqrt8wdelMCB175cdTwCRNfy/KOj9upOHoweipaxlpdxHV7dL/pdMZ4Wt8oZZ3M9FgBwsjvIAYfGPX+8lPobgxMTcCA4b7n/CV6TyIexWHgsl2FEDhSww2/R1cgb3SxUqlOWifvKM53Q6z10n1FM4e771sgwyY17qlCa1MVdfmUJrjynbMUTq5dEceZk50Urn5O42rPN59IumeK0H5/k8pmkypIbhe8zH9ITtLpG7aTnmG5D7jkqP1fmLiWsF0TWsBK46RKbS6qtTuyQ6KpMt+At8TpJVV10/3dE97+OaAf2qkH5ih3wZVH0MM8vn5Vq4CWSM1TsxN6YuJJzm1QhXcvls3ygXqPpWm7RbzEsPh9aUGUaG5dxiitzxxz+DvqMHIEEht/WhhkjwxFEmepazPSdaikl4MIyPrR7WZHaCmr2zX4ZpIulhjKUl3qoAzxvS1bjcpRk2QGvzpkOH1Rg1sAp0yt9xZksSbUUSwJMnNnd5sHYnOf0ugCc9msx6Mu2XTfFJQCCfmT8rCM3G6DFuNJXmxrUAsVtWKOVnM9LL0AtUHwUiEd7/vizK/MKGGirE9dMaDUs0Q815kreljUEMzJIcSsWmGc6F+4WTihkJgC9dDc+a813WB7TQRT2aQju80KvtOfd2J9naDsGFLxxfQctsTqcE4D9LKLkt2qyzoFe5qlR1JD1sww1hx1HAXyPu6VbpmNiIoSittBfoNbesL6nbi3aOKcc3J8nSwAzCBzsLUZ92wtO9IQf76kGbWyGDVUf1zQ4mRwB96XZZFzU9nwrZlRADZUhmthMlNgHplzxUY8iVNdYhS7dw2+xl7C5K8sNjsDDgYAhFbCPWpkR7+0TPi0pZdeqo3
 v3eocql+
 nJ8U4jDJeNpjZDGuer51iK0MiBfdphxgrqISA5Rqmz6xkTHEOgH14g+6jJ3Hl4H4JaD2jIwTcx2O7MnWbuto8jhxXF1Y+QK4fndzqOli6YvsG4AHeOc18Fkej4itYAckUeWN5g2JvtC315tYb3BcnPC3v7Ku8swKDuoKTE7tMB6pzeTl1MQFwWuqnnbVfDLfRtImNhtVLtGxmcT/W//V+MLyKtC2tEqD9joU6Pp9HN2u5iELybOHeFwAxi3ejPtdeuzVw2k2Gn05haZSFYy6KzIgy240IgNlhoCr0c3Ke30CmJyTjENuP7w6uBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, 12 Nov 2026 10:18:19 -0600, Oscar Alejandro Sánchez Lucero wrote:
> Add missing kernel-doc description for @order to fix a kernel-doc warning.

Applied, thanks!

[1/1] mm/page_reporting: document @order parameter in page_reporting_notify_free()
      commit: 3a99594e62fce8c646e8aac01d38af16d6833a40

Best regards,
-- 
Vlastimil Babka (SUSE) <vbabka@kernel.org>

