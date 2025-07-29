Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03709C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 18:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED7A6B0089; Tue, 29 Jul 2025 14:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5466B008A; Tue, 29 Jul 2025 14:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601D26B008C; Tue, 29 Jul 2025 14:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B9586B0089
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:21:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C67651D8E5A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:21:34 +0000 (UTC)
X-FDA: 83718120108.08.E60CD22
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4E3F940005
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:21:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DcqezsrF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753813293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GRBa5m9Dqb44rSQu5D2OdO4F0TNPgMFtPNUkTa+SIWw=;
	b=FNIQVvKZF+326JoaPAyehx+O0hqDIWOSEFbC5bzvutxRGmzCGo1IyO4EjHittdqUzL6/AH
	CZf1hvWRGevnuNvCzdQzv+4DwtTw8yfAk7Tw1JbhchCQUpv6At7QWUiUPooaCRaCX9lg/R
	8GNgaMM+Sbk/IVr2H8CCrsUNsRj3VPI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753813293; a=rsa-sha256;
	cv=none;
	b=s79IsZCwLM9t9v3Q7OErnnSe2vG2mU6W874mbXJDGtKQtNRutgVKC4gwnCI5/1LwkRpei1
	JvqInhQSeJac0uiJG8OJ/GfzdInLraORkspHO3vdiInpvAivKR2HuwDCrV+ycolSb5XMQT
	UQorD9m5I5JSNCzr0d6UgF+jJnrD4aI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DcqezsrF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 3F4DF5C37D9;
	Tue, 29 Jul 2025 18:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6995C4CEEF;
	Tue, 29 Jul 2025 18:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753813291;
	bh=PYpcpT7h3xRaIjw9UV9V8F02zuO84IEvLaQsNkR2ofY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DcqezsrFw4yybHEuuviYDwQMdSxACzIzTQ7rf5pEaYsg288n21nP9RRMLb/XIuiWl
	 Of09XVzMh7VcSmefeVBQcqQUIQaItvKQEcShG+vkwe9r5p81HoxOm68p5EnJZqF4yF
	 ECwE2tcKHrj5ssPdnc1W/PBEik+oOWNrgBuSM6DwkMIlVMMPf++qHOOBOGGHbBx/Xv
	 MDx9feTpaHmXXDmQ3ZKSmqIL91LNtG2pFO66Jn/9FzhU2bweqaYhZyX1AcF8hTjBmS
	 NButTXHtt3iSOH+Nst4TvHLlFpoKX9kSHt54I5LevuXhrdFZ9qDpZhOwaYztvmLlEv
	 e9zwjVEuL8+5Q==
From: SeongJae Park <sj@kernel.org>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] mm/damon: Add damos_stat support for vaddr
Date: Tue, 29 Jul 2025 11:21:29 -0700
Message-Id: <20250729182129.56268-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <44a30f700fdcf4470318ef5cd248ba98c59b77a2.1753794408.git.pyyjason@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4zzb8b8a39ortua84agx5c6rads7o43n
X-Rspamd-Queue-Id: 4E3F940005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753813293-874857
X-HE-Meta: U2FsdGVkX19tfyT7hByZhSCnTN2xWdjGnekay/SkS4nWQvdytLQi1CZzIOkEqxSQeFgcWggc4ouAovtjGcz3uIKbDo7OGiQ47kn2WsyjW3GQ2Ofa33G1kiJx2xeJt2RZLbfMjctvZgy9MldD1rioq/ycUmRdcceES+yl/5jZGkfAocu6UGfY/FtQh6PP1MbUSloBhpWoFwq0XhUE+6Kaxti1ksymD8dM+QA3Wo9tYDdefDfWRthf/Y5f0lsw/J5DdhLhmkSdt8zvov3RJTZATeoTJoqOCzCyh3mI4D69tLdm6X+NPzxz73n8WCGWvaXCsXcWhKf6Y1lTBuo7VygWpArnUtHA8cW0nXSAodo/fPYofPEnb/VnDEV+qcHdxI7dBHliQw1CCp02SCQgVw4nZepoN8rSZipaPrdYgnqJYcicKd2a7HdyFyERJHbhc5AYM3fkjSFl3X4zoxhmj9DaodVlGe69QWGWzBJaDXCrhSzpRJBGoiUNwWsxlid+DR+XuI9/E7R7Ul533raeFkTsD2YqJYHyK40MxHcnz3x1Hp92KzRZdQTXN4+G0x0g/tfIG55qceIZVbkuNpujkQ+ptE+P9P63aGPlX+Y2qSrMfP2WdC2sT4CpD9M9Wm/zA3UIMNS0d9WyRRo+UtORx01q05qtu39dOels6ShfpbHXgxU1m96uLlPop5PxtyX+Psd0bTbavgjie8suVHIH8M16oJbkEbmPskv54NrgTUIqOysV6/cvCQox0jLs8wmvzO/ci3TV30Q0A+XEmMjyC17MILf76ZQIWqepTs0gDkJuQM5zXdydeNFR5yxM7Jzk88A4SD00oBJZJazMTeYUVkLwXFiXANQAUY9uNq2kAjqcO5H8BbmZ81qwl84cmRK67R4B04DpXDlquiSaJlNs6MRdJA2KEPbIO+AsuWNbKGtYYhqb27m7fbRWv0MjBoUhXf67Vw+EbHb0/8zUwCuou7f
 IKJNligD
 cNgYx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Jul 2025 06:53:30 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:

> From: PanJason <pyyjason@gmail.com>
> 
> This patch adds support for damos_stat in virtual address space.
> It leverages the walk_page_range to walk the page table and gets
> the folio from page table. The last folio scanned is stored in
> damos->last_applied to prevent double counting.

Please add your Singed-off-by: tag[1] here.

[1] https://docs.kernel.org/process/submitting-patches.html#developer-s-certificate-of-origin-1-1


Thanks,
SJ

[...]

