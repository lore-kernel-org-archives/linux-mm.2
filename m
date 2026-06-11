Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F019CD98C5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 00:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83AE86B0005; Wed, 10 Jun 2026 20:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EBE96B0088; Wed, 10 Jun 2026 20:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FFE16B008C; Wed, 10 Jun 2026 20:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CBD16B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:40:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B6378DBF1
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:40:12 +0000 (UTC)
X-FDA: 84865775064.18.B0DB174
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7519BC0010
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:40:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ViWw2HPw;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781138410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ud3DdjG6jP1kOYJPRGFo2ygHKx4avNMyuqxqmFs1iYY=;
	b=aLfZYw0NMGWxdc2HW66KaHoSZ/m5DL3syLS/uR+1T8bKEcfE7IjapOeUarU2iWxdl5FIej
	G5dxB68biYmQtCIIZ2DYjeNl7kI8CWr54g3BwumHn3Y/wbIyMaW+qwrxJKiIqk+Cj3SPc3
	C+Ruk2iMU4e3Axh0NFNr2VlgutXss98=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ViWw2HPw;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781138410;
	b=MASLo9JtmWxh92Jubh3q+nZ8Y95DvYJY6wkjBPZKuIXS7noUnwGh41prI9aOGKIJsm94nu
	df1Aa4fnT7Rh4IYJkfOwtF/mHNmY9Jo19v6yDijMw2CO5alwqG7I3WwDSluJWVKPfeK363
	b7+vyvvcQeC84c2nJMv7e/aHXwLci5w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F73541600;
	Thu, 11 Jun 2026 00:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CAD1F00893;
	Thu, 11 Jun 2026 00:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781138409;
	bh=Ud3DdjG6jP1kOYJPRGFo2ygHKx4avNMyuqxqmFs1iYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ViWw2HPw2UHb/1kd73XPK59Jg5pHZFiBBxf0T4w52tacMsCXWl7pY8opv1AFfnZcr
	 kAAacPwAxsR/bORVqtBDaLOZQxSKdEyh0kVSIRaQvcJx/jkWogIGyrCHk3CiIpKaq8
	 e376C8/RtXMvjrW1EwWD4lwDNO+9N/DDlLtRbMnqap2hLR6Vo9K00LjWM70jNYDrg8
	 fyteb5dzvjmFGqqkixj66vu4mYjXjvV3xBBq95ok5YHYqos/ayF7W7eFE0o6B3xWZ/
	 o+qoJWNx/8SJKQqfEeW10end0YJLskwhF+Mw3Jt/IhQRvv960M3J4/M35AcVY3N7nc
	 s93TRjn1F24PQ==
From: SeongJae Park <sj@kernel.org>
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH] maple_tree: remove undocumented CONFIG_MAPLE_RCU_DISABLED macro
Date: Wed, 10 Jun 2026 17:40:01 -0700
Message-ID: <20260611004001.69726-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610220905.99860-1-enelsonmoore@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7519BC0010
X-Stat-Signature: 1ciatswiny9ny64m8qg7kyt4uyghbcx6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781138410-409869
X-HE-Meta: U2FsdGVkX1+VzKWswSk3rDYPEvzK8mj2qDWIAyE7omJb6GhGlurCV4lxBOtl2yOlfH4BrUHtZXIWa/NqipQCIKMaElnulkdL6bEBwbAk8H+yHrsFFIIJQUzRyMKo+YUIcOAzBtOO7i+8A+IqCxMdbW3NWJOxkr7jtW3+HYr6oX/tMv0YNe2uW8zftPgWPkCxoANBiktWsHOiyL+YaWJ57RA8tUwk+dbkWXAqLJ4Df0SPHQyiskRvPtP0hT2MDzKoycd3CW3FooOk42C7xoOJffLlA3R/Mi/i1PdTOf8Yp+yLHLrJaDlP4edKJpCCGB+x7UklMuv3Y1hdOkpqz5HHfqarpiAuQGpmxUHaITGsqHRLTAPoWhRl13EOETobTs0A38537Q68isOcA3T5LqRzBJkuNPhbRclrMoUH1yWH1vFuUbjtPxOxg9r4pUcFc+ROVykXyDVgBZ5xz04FOn5GqqpbDyQzKmrpDP155eRZX0Qc7W7grZqCm3dGCgtH5orkfA4VrcQfgxHS5HRtcAR6Pw7qYbOXqbDO0Reedfxv8nlpTuD9+82XfPcvgYrjRv88QcmXJ19UIb7E3Oe1i77uJCeLKDxOKfnWr2/xzhW0SQQCWyjC22DS6msWrc4PRMJkELX8Gh5OwrLZF+n6glnS3njGIHhfN6Z6nwltoVtRLOvDJjovQv+wAEi030NkY2gkRmzLlPhYmyTInJTz6w6/2UZugCu72QvjjBJoq3crjr9bI1iz3Jo4+DgYksSvxs05I68rWewlEFqwZikbAFoQQcTO/EsmzKfq3RetgL7Aj7ohlOHCrMIwm2H7oYIbymnkToIc7ap4ASd021qangj+LNK+2H7ZgrtcXyaXy1edkn7mEYx29rABYLRXeE5+CnRrgj6MIY6Sr2feko47yogmb/TaNi9zSeWl0ivfvbOT5/TJ57d1iKw8TxL9V1cDEMp4V51csuylo8B8Gk+yqPi
 JGGW1eoL
 WtgRPsjgteW6pBCO+G6cWE3sH54gcOdbS4fHkRqJHJ5bdKFjE/ODVj/usnghySVc5/TyoTwcdr4eeo1IAxqxca2kbhFENwu504KLj3fmYG6zxCET0zUcNbThu/fsWi9Sc4l5w+q2KQmh+akjUUeujxjISHPScQXwJU14XFU5uzbv83yQVp1j7FtEFpMRn5tVm7TvdZznj22gwAc4U79wSlkiwQ5drHtAKLyiLUQLJzDKRhzoomH6wpvJuysH+zl7UkkHp0FeXbjQZjOxMWXsfHg1JBSa73RtVnucBqvgX1e8VZ5Ra6riLSmmRcz1AfKGXbJ+5zAqUdD0ydTvGSrrHW7jeo+OCVOxrUR1q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Jun 2026 15:09:04 -0700 Ethan Nelson-Moore <enelsonmoore@gmail.com> wrote:

> <linux/maple_tree.h> consults the macro CONFIG_MAPLE_RCU_DISABLED to
> determine whether to disable the mt_in_rcu() function (by making it
> always return false). This macro is not reachable via Kconfig, despite
> its name, and is not documented anywhere. Remove it to avoid polluting
> the CONFIG_* namespace.
> 
> Discovered while searching for CONFIG_* symbols referenced in code but
> not defined in any Kconfig file.

Seems this was also found in the past [1], and apparently this is not
intended to be as is.

I also think it is better to be removed or renamed.

[1] https://lore.kernel.org/20230906152325.dblzauybyoq5kd35@revolver

> 
> Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

