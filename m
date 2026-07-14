Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 228D0C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 050296B00AA; Tue, 14 Jul 2026 10:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 001196B00AB; Tue, 14 Jul 2026 10:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E32776B00DC; Tue, 14 Jul 2026 10:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C386C6B00AA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:11:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 424031203E6
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:11:41 +0000 (UTC)
X-FDA: 84987570402.05.12B895C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9979F140016
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:11:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PytcVd8B;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784038299;
	b=C1OXOrqgk1z84FDspX313S+6tAbUHNFRx09bjcc9OQInQvaQDfqGqV9uy3Ubq1lWC3py8t
	IDZAY86Xc/KrIycajl1G1fnu+5PYQT/e7KXd4uem27cFbY2ufT8uXlogvLZ+DBcIEbqfUp
	XhhwCqLBWK4SYc+eATeH8ANCs6Rvtp0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PytcVd8B;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784038299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6UDn/zB13GY2rQ9/2v1cLrwdrHaWMbAjwv9EdpOgA8=;
	b=rNFlbu0Fprt8C9oEgqnd+va5p5/9dOVBzUWl5Czsi2RJZse7dKv7Hpr3Ljeyrrmv/Fktd2
	317ZJD03Vs2mLtrFc02BJgQ9fGrTI5Z+FT041lSP2PiTP30Pqvq+rymECVDeZspXk6e6OB
	D58AgfZt5x0iEAq4yXMGEbm1q17hqiI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D2F77601ED;
	Tue, 14 Jul 2026 14:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592CD1F000E9;
	Tue, 14 Jul 2026 14:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784038298;
	bh=B6UDn/zB13GY2rQ9/2v1cLrwdrHaWMbAjwv9EdpOgA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PytcVd8BQgI/38oDRG2qlhYVQChh7MTMHM2uHfiV55lxVh25JhDX58hRVcmGZdaQ9
	 ZF5qI1aOuiwO1j6IoftP1UaIhfZ7WIhHztUvP7Ozm4R6H6noWdZBWTj9zoG/5JZWao
	 Ti+s7PkLFiwAiF9dJR5dm0BWXB9saA63zVcU7O42DmM2MpW6RwUubX0AIV3TaA6lY2
	 meIfQFGHbn8KN//6bmEJioh2Jrv6PFi361ZAxrm4OhJwUTDKS/QBG+/ZEfWT1BkeKG
	 X242vnAKZmjr2HCGBL6IOFhWqXTxtQo/NOHU224G+3IV3nJGAuNkLD+uMkHZVhtapW
	 8A5XeIAPCr2AQ==
From: SJ Park <sj@kernel.org>
To: Xuewen Wang <wangxuewen@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/damon: remove trailing semicolons after function definitions
Date: Tue, 14 Jul 2026 07:11:27 -0700
Message-ID: <20260714141129.96609-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714075358.1592393-1-wangxuewen@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9979F140016
X-Stat-Signature: 3zc17hecg8347a18ah3ei3s3ynx54cop
X-HE-Tag: 1784038299-794030
X-HE-Meta: U2FsdGVkX18KMVTY5KKdf8toh2NiVioOh81r0TAQaYE2V9ZqnyeHe+ipYUZizDLFY2BkQCkI4WJy1LwRZGCHK53n4t+r/ounHWf3eyE/qmVuiocRwr75IrLJARHX3Yxbu/lmseKJAsVL8wPtfGo/QNqHM+BY6aMqECzYQFa89lFZpy5NYf+sTvwP9SxUU54UgCLobheU3v6m10tpi22TDZQlmGcI/NsWyGNZq0d8z8cS/mUcaLGO1JvIcIfODWndYvq0+tEO+VfPGdLH6RnQ5mEOZXPHmJzL4lj3Hi6yGzmcIodD3J9EsbYBYDS2ShYX9CQEpc5NsSY2GyEicRKXhKOL6EkM+vKAFeovV0gRt9WyII2Nezvdb9LPPY27+nipskML3fh+p3IQNy3e/FFwm1QS5rYS79FMS7leJL1dAqfi4T32hisX5krh40lE3OdvxhJ6vekr8JkUc40ai+s5f+Y8+2GFT/hQqKzxUojfcGC26s7jbj7r71vBXlYEv/dZu599jNJ6rlc2crJyC+uybCMCNIXM87h4lQk4urvP2G72uznvprD5IIsVuIVxKUS9pluzEZEIJsfr8gC6Mf8phJ+s+1JocQoouMHKiYxawOcG5SCJODVr011oHnWatv/JAU1Tzn0y/9PLg3KfCTwvKNeHuDo47DOv9D+Tac5IZtcgL/8fcfwAef4DUfAGUHd8iYKFhxLYtXluQq997RiB8tuglmAfuz+IAoFaro1p1l7o+rQCsyoNP7LKEL6CnAR6+5CxK4gvbMnRAq1TisdSWSeeYy+dPJCl8ptYFNrkQ8WJnYrLR5VT2jCulwLrtq8wEL401Vf9p6TfOcdhFECj3v8dH94b2fp3b67kFRxDoiT908PNZ1CKTJoy5gAWtu1G3X6JhpSX1PA/c/M7Vzpv5n5pURrEGp4DvsKlbRqc5KnO0+8nGieSYgrSwn6jDFl5bXLb4hBXzpoBh+6RLIb
 HDslrQlD
 BnucoGzYlrMMRMHUrQQkte0NSQgA4Tn5mmdxdhmofy1vk7/aU+HAXawZCYo4EYmP4Lweo1P9hnEwOuccFXoppgK1N81QKDSoD3LcCtSJ7VdqRstUeoXR71yYHM+B8bVBDGSFv9pLhoV7hcBn/VkZOh45VWHYq7Uzg5/KixPZdea7Lj0nawXHZgkGJPpOcJ9pyEq7Zd1Z+0ksFQSo0PYd8GjFgYRL8LlDqHThE3ZQLHvrMH2hBuihoNLLC+jMTJgSUE3XD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 15:53:58 +0800 Xuewen Wang <wangxuewen@kylinos.cn> wrote:

> Three function definitions terminate with '};' instead of '}',
> which is unnecessary and inconsistent with kernel coding style:
> 
> - damon_pa_initcall() in paddr.c
> - damon_va_initcall() in vaddr.c
> - damos_get_some_mem_psi_total() in core.c
> 
> No functional change intended.

Nice catch!  Thank you for this patch!

> 
> Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>

This series is applied to damon/next [1] tree.  If this series is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

