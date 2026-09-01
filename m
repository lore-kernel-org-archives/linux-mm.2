Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7593FC61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 00:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2445A6B0088; Mon, 31 Aug 2026 20:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CD7F6B008A; Mon, 31 Aug 2026 20:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0708E6B0096; Mon, 31 Aug 2026 20:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D41766B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:42:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4452D1602B9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:42:37 +0000 (UTC)
X-FDA: 85163342754.28.DE88C79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A7B41120008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:42:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nbVgy6Pt;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788223355;
	b=1S4hSRi0N6yXGizyHHZXvYUwXNQzu09BKXN4ItIMQsLgaDFYN611Mt0HlwaQJyRAjx5KKi
	ZTVKecl8JdTwuDqPRRshL0yCaaoB7Hjx6zwyWs32laG5UKoehvmCF/oYxn+peUncf4OVBv
	yUjXO9ZK2HJUNbE3SyQT1NCNksT5GEE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nbVgy6Pt;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788223355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfiaelhoKXS6U8IAM1Cx+D9jl8jdDr5cDRVvdKuWEJE=;
	b=yNVfSreLdJOvb1CrgYyQkGD2Vtek7DaWHZldxqqE7EFeqB//xNvx29DXDCkNp/S1q+eROw
	AppGTznJ4x/X2ji3PMGzHyyPWHZ0giyA9XY513mAqetozObd0UQmGs23r+rx2hTnNVjuwf
	mrCSqu6wXTTp45vpmbBXIwYDdtErONQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD60F4052E;
	Tue,  1 Sep 2026 00:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907151F000E9;
	Tue,  1 Sep 2026 00:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788223354;
	bh=nfiaelhoKXS6U8IAM1Cx+D9jl8jdDr5cDRVvdKuWEJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbVgy6PtpGfLQR8Pd/E0YXCDhX/7ZWVtMik/SHpvQnw247r6i0j7vL2Qj/8EBmp0d
	 iHVExvU4k+CcxAMzMQBbNjt4S+FQ50OP0pgfbocO6x6SpET7vrv6HtsJdI1R7haktx
	 HF+/LCRIGNQft7goMWMO2OkoI/5BbrBHb+2jw8mLimzWaBoN5+tiuwCMoAKmUtZB1r
	 3yMMYGWqL/+ThP7yHrXdVnJl4UUUH+hgjtNi4+kJUKBIjqTwTW+tLHbo3MapB/oz8N
	 uyn/nDPtafUbjmmh8/4MDJr/IOxWQ7P4zdH/WPKuqpcgHQN6jBVK5Ij3KubRbGx1Rv
	 NyN+UeBuD/BsQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Cheng-Han Wu <hank20010209@gmail.com>
Subject: Re: [PATCH v2 1/2] mm/damon/core: remove unused damon_targets_empty()
Date: Mon, 31 Aug 2026 17:42:27 -0700
Message-ID: <20260901004227.89243-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831161907.890b5e2d6c9a005205506674@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A7B41120008
X-Stat-Signature: kedf3gdozyw85st4zracbsfozkr8n3o3
X-HE-Tag: 1788223355-650429
X-HE-Meta: U2FsdGVkX19S1DX4xsA/TtO+9cYF3qyfkpk6twO4NB475XRjcESRUy4uRtaBghd63ie+e0vfmsMi/PUSar6oOA5vts1tcqVjXn207Lkf+N5Fx7hY1iuYElikTMXLTeeKolDK+g8NIeFI1WtpYvBu2ruZnm80JsOvAVVByBpzo1aF47WeY1tyeqNjqvWHxyQJbrBxAlgJagMNBAZxtYmrVqkbKWniLpMbSAMlDyuK93/+7cWhWL8fLIT2GlsHggD5XjJceygITSLS6Q0NZ9totsvaf60SWau5J4Zl8u5n+Fi5E5z4VxI08b2tm/xE4JFOE3IxrzwcKO3evhvJLdu3AemUbIF6GHgotcmEW/WBL1AiFMiDn5GIke9JCTO/R4F0zwOe81K25TwvMMer8B90vyO1bDH23E0B4SmH/MkypR3ANCRe4Ex6ABVIdgw0EaBCRnZqm+gEDFOGlLvGlFptGDSq69H44N4XmKvcHXTeZuz/Bna9kdEMk350jT8vahGIkCrvGxhdLkgi89Ld9cNdSuU5+MT59qF+AOflbPVxY7R+3ajBjmQbWYtJsi9hl0IDhJ5U75Oeo/RUV9UlHiYYPKqW/Rx4H0893rpWx83JVau7MLXN5eGZhZk94UKmC1+xQAcXnmgmbfpzgHEB1C0hHren4AeDEB0BBpaP++m0W/ONvzQbW5wJw+vajLCq7XAmY0GthjV5bXGnsHa6pdXYUHdfBpm7bUYLzW0TmSXdtGRkLPvMjiJuqLVcqmgqS4uF+1HHYMKIpge/0N1aIDEET9ivC+UDAcasDXLSe/lftJ3zgZ8zqB6U/8MMeelZdWb8eGj5t+tNR6182VxHoY1h12/O0np97JmEVMJYBDkjsHj8OX0ew9hgjQWdOoQDNxTn9t/N02DpwTqWKM8cbfrMaZV3YkE6y3Tx3j1ZIF4yzPfVxYbRIVBVQEx9VvWG6RJk17zuOYcMapiYLqkmUgC
 7EH6FR4s
 CZuyOq+CQ+7EQ073ciNhiHNUIA0b0ng3+mhiKBeTLbtWLXemnvo9KyKYUCyrIqcV6ItfQErsr1GbR8ZK6HYGc/Ib9rW+JKb4abYxTUx0M6lRKe0wSS9py6DG0V+Q4aBxxIl5Trf63M90fLReqDqjh0CRSAarxEpYYo0zYkD/D5WxxegqPWkOj9g31+25/maTtlgsUgk1QGvhwl6WBR1kyOagSxWdxXcMa70+uaIU0nlrRL7KPlqcts7yH9oP30VVTSKCSNYgzx0i4cDCEYglALki1CMKUqD3xol2WI9MId2m+4mIZZL44FxiTjTunEquUEX/2eYcG5DrfpwxWAB3mYQJGjCLupVgqeJtQDQnxmQPzxXg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 16:19:07 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 31 Aug 2026 07:57:21 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > damon_targets_empty() has had no in-tree users since commit
> > 5ec4333b1967 ("mm/damon: remove DAMON debugfs interface") removed
> > its last caller.
> > 
> > Remove the unused declaration and definition.
> > 
> > Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
> 
> I assumed that a From:Cheng-Han was intended in this patch.

You're correct.  Seems I mistakenly dropped it while resolving a conflict.  I
will keep this in my mind to not make same mistake next time.  I found you
already fixed this when you applying this to mm-new.  Appreicate!

> 
> > Reviewed-by: SJ Park <sj@kernel.org>
> > Signed-off-by: SJ Park <sj@kernel.org>


Thanks,
SJ

