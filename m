Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E07EC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 00:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 047356B0093; Thu,  6 Aug 2026 20:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F39AE6B0095; Thu,  6 Aug 2026 20:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDAB96B0096; Thu,  6 Aug 2026 20:13:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADD276B0093
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:13:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98825160296
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:13:29 +0000 (UTC)
X-FDA: 85072549338.25.5E81F09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id EC17620007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:13:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GpfLwq0I;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786061607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SUkWc8IbxWpzQ33i0B//yTn9ol258cdEH2veH5fjFXo=;
	b=FrroBRnQDvbYmilbEojBno+ZhLk5AxtM8aYdQQqxdqU+ZfpGHugEe+eD44j1G4APHpPsYK
	cyX76xJ/LDuioHO/Ap2uD/lt60kZgwHjwAMzZcNOxh7SJVaf5F3QjjuBclOOOv8VeyPvQj
	6uwfz2S7SlbKgifVPqy7eYYIc6ga5G0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GpfLwq0I;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786061607;
	b=koYzr09XLYc5z5AWtH3sp7JqfYzjxZfeQn9EOARXRc+l4xRn6dAplcQa3m/qXep/tEWGZp
	D9ye/dthAelsedaV9ojUexqAzUiZdyP6niluNyXMZoAIA33trAfy1j6JGfYWTxfjEg8Jt5
	Ru4q+hgo31F9N0TpZgoHcY5ibEANr+I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C455600B0;
	Fri,  7 Aug 2026 00:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037641F000E9;
	Fri,  7 Aug 2026 00:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786061607;
	bh=SUkWc8IbxWpzQ33i0B//yTn9ol258cdEH2veH5fjFXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GpfLwq0IYZ2EU+OY40tvhxlCbR0jWJ+v9lq4b/ajtab0w/1FJlCD2pXLf4dAzrIkz
	 tMQdg77OZqxL8gidTxtjtfA3rVDlHJ+L90A4XlM2AzgFgZiauwYw8PEfgZ9ymEpy7f
	 OOOZVqjLihFImNY/mCJfI98wFH8xxMMuVl5EwKcJ9NPrmDy9FncN2ioqZW+bor32+4
	 K2Nbd96Uk+cFm5uFfXerMSHPIW/2LwH5bRZ+cx7cugj1DtohJVPEzE5ERz0KdTN9DF
	 hyu1gW5E1D7njul0HPjiGYAjvCYURYUpymz+78ZNoeddRtGDh9a4PPRDzR0h2RKe6l
	 8LMKAgf1k5caw==
From: SJ Park <sj@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH] mm/damon/core: remove declaration of __damon_commit_ctx()
Date: Thu,  6 Aug 2026 17:13:18 -0700
Message-ID: <20260807001319.80491-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260806170701.79266-1-zenghui.yu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EC17620007
X-Stat-Signature: fh76wubo9455cryyehsdtehbtdbmimsg
X-HE-Tag: 1786061607-484769
X-HE-Meta: U2FsdGVkX18nFG45BXrhJbcEvRycv3Jn/JrwOErV8g4hzA+VUUT/z/j+2iSPY1WAPiA9i+sIbTyUXi6I1c/mnE9Cpcghdc433I3vGh+XTQZbLJmk638GdfzeVxPsLdC32vkaNtsBb6ffNXXJD6I8IZNzgZKXNH7n06CWngPgkZcjyiOF4Cd+9A0TcysutB8V0gMVxRjBUiIBqiO+r2S9WhB/jvfOtFoEUQsvGuAyAN9vLe07s0LvM5JLVnNf1XQ2tt1inVYTgRRxk7SdOuYFsf5MzWuy5xxeJf4FEHKXI2F0fNlyy+Pi5012bCoHK0/aLvzC6ucYa8YHi0kj/337zwja/r8bIyWbhHdRX+FhnbF/hGA8UEco1tzTjnTmfyNrG2WQhnHwZhkflmF8Mi1IbLhJnEIFoFXFmuc2pIBnDYQSfyfe1Got1PXQs/DZ9kppMnMhQPeS5Vy7LUraMHLxvf1QiwI42kRVaO5rBHtXX1gcif0TnLt3or3kucAsGqdZx2Gg2/APfqEV5ps/IOJGETY7n5CdyrC8mVmCP9fMoxrMov9ozqa6E61MVgxhcYD/nmaO53Qo+2FlrlWMR206ON+/XIK7y+KJacqedxfP/yPHxLiBZWMgYmad4r20vA5P3wjiZoW10mrclawiBYD8VdopP1qMm7nae2V4b3ViKBAqwepKtPYBi2goiYNgyX6SP8OVQ5ODFA5hJQXxjl92MKsuEXSfk0k612WXkLYG4DLMoZoZfGJQSoigelRk+kNqWstdSPtldI8CiCk4wFyhmsrhdul6eZKf2CVOIVZ0y5iIXXAZxm6OZHBIaKGE107kUF6gLDeJgd/CuIhrUThvrvzK1R9+4fZxnR50l//dGx7MWA0fikSGs5C8XL75IPKPNoiLNS94fdmhmrj82gVwOjg+Usaaf5EvF/2qSmXt1C4DKuSqOVuamHovrF9Dk4N7liu7geyus7Q6oDoo1X7
 pWjf2ElX
 twkLyqMO/o9MAgpFo4NNxr127Su1mc5cMuXK0swN/2KPn+ywTVZ6Qs/PQNOZQSA/L74N3GQ2lIWtt3Pg/w3IsIfZhxpNMWJU5CjQoW505JAht8Q00YlKs0S2LtP0dM0Y3tJL9t8TqT5Rb9WW1fgFiwtrUzQMktUAS9Ruv0xNgC/etQ1zitwM37l7FPZdVs7SGxxVutM4ro6IR737NHjVd42ApjXTpjXy22q4uUNvwyQfFc2xsPmgftyAVoH8NSqgID7xV3BKK8xQbbtGMHrBSBD2/4FcWkDTa1umNbeL4WNDUlD3BM3rg2kruiQIolqN+7q3u7ds/khnbYHU1wG3KBs97AA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  7 Aug 2026 01:07:01 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> It was added by commit b1471afe4d10 ("mm/damon/core: do parameter testing
> commit on damon_start()") but is actually not needed.  Remove it.

Thank you for finding and fixing this, Zenghui!

> 
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Reviewed-by: SJ Park <sj@kernel.org>

I applied  this patch to damon/next [1] tree.  We are now quite close to next
merge window.  We (mm community) want to focus on making mm.git more stabilized
and therefore ready for the next merge window, rather than adding more changes
that are not really urgent.  I understand this series is not really urgent.
Hence, Andrew might not add this patch until next -rc1 release.  In the case, I
will request adding this to mm.git after next -rc1 release.  So, no action from
your side is needed for now.  Let me know if you think this is really  urgent.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

