Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DDCBCF2566
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 02:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4E996B008A; Tue, 18 Nov 2025 21:00:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFEDD6B00A5; Tue, 18 Nov 2025 21:00:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14CD6B00A6; Tue, 18 Nov 2025 21:00:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9DFDE6B008A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 21:00:17 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4EC7A12EB30
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:00:17 +0000 (UTC)
X-FDA: 84125701674.02.C85E0AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B1E951A000C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:00:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kb/UXTSe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763517615; a=rsa-sha256;
	cv=none;
	b=tHDPQ9JFN1e66s4XHFEQb8sB2fbJV9CNo5zAUiI3lUpUK4OXUPqmO4D2oDwe8WOeCCDhbT
	qYavzlWcxnsSlBHO+aavIOLw/htaCP1eyZzZmk4+jSzIVEFi+sdlfUgBOLkgDVJsyma2BZ
	gTlV1M7BCz3BKm3GpaT6LNRtV3KKRhk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kb/UXTSe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763517615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5lLzJ3HX2WFatV9+GacUwdgdtt5CF5Xf3PFlaOI1b3Y=;
	b=w/5IOW/uZLgwym9pODYkL1C5rzhMDRT0Pani8p2y+ymcTFkwtIiklAq2sKxwxubR2TDT1H
	KuyDvoRrjPu4RlIiZ8RcsHXKGOke2uAb7dXSct8Q0S6qwWAS2jmLFpgnQMf0Ih0TTc0Jh9
	WfNZvM9IfLlGmhg7DqYYiaotBk8mi+w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 07998600C4;
	Wed, 19 Nov 2025 02:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2E9C4CEFB;
	Wed, 19 Nov 2025 02:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763517614;
	bh=+wyBW64IzNGcFzUyRIq3XdIAGkWKGaf05JXNZtza/v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kb/UXTSeMmyW3QHHULosUPUWmqxeQJz7cW5eLR/nyR2yPwFAmXrl7Te/dHy8IBwuh
	 ie9qj2dIQmVwC66HrrlVnLlcbCZwQU/qbv69RVxg1TxvHTSmz1bn48KpimDrgtaiKD
	 ZYknW1kPYRGWcx2TUcPwjJVHb4QOau7vu/U9qqHEpIR6eJop/Gsfy6kXKMwDml+UyI
	 4CoUbeifcy3BQfXVPWnAJJtZBtyyQHQrNALPAxFnsRUPd5mf88y2PjfOru5TkkOUo4
	 ySm+kRZJ+qO3fISJLYJOkzUx29FX+bw/q7uN+Vblr0vvsmmhg+2ur8Y05gSdNF1dD/
	 d5kKqmMq/Vg3w==
From: SeongJae Park <sj@kernel.org>
To: David Heidelberg via B4 Relay <devnull+david.ixit.cz@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	phone-devel@vger.kernel.org,
	David Heidelberg <david@ixit.cz>
Subject: Re: [PATCH v2] mm/vmalloc: warn only once when vmalloc detect invalid gfp flags
Date: Tue, 18 Nov 2025 18:00:09 -0800
Message-ID: <20251119020010.72911-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251118-only-one-vmalloc-v2-1-fe702aa68d8b@ixit.cz>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B1E951A000C
X-Rspamd-Server: rspam07
X-Stat-Signature: 3xns1oxai6dsacinrnm1o8wb8awjwdf6
X-Rspam-User: 
X-HE-Tag: 1763517615-508736
X-HE-Meta: U2FsdGVkX1+1JeBGA0cG5327YgTxd/+xBjlGmtz3pijr2K2DN1cDL27S8QiOikrqJUYn4LX0WaQIL6qButByhegRuneioDLj+WZdtUath7oxtb2VYVfGA1jW8Rd+r6P+tjEKJxGIjI40eJ9J4zWwxo6KsfR22ONYxM4tTKqe9Z4lLxv8HHaL2e34tisqzdg06o8SJ/fDPWljeEhC/F38MiOaBfa3wuQaipbcQnSBc/fQ+M+HNtMdPyA2PSzX0kQLezWXn47+fljDq31LMa3Pksi/MyaafJybXBXPXhMd8F8+nDxWOYy4gpb9+2E8zan81UggwNXJxgf+OuQTCHvl3Ze/9zoDbwzGHqTILxmJ9e0adfYS+NRa0Mry3M7yoZmgQPJEajlbwClIBnq5W7BRbLQubU2Mw3yNKqD3I4ZMihRm39l5D322Pf2VbpFiJuK+d4fx/hqlXFV45ZrBNTAsGRmsUrqDrk0NO5PCXQgZPMiErwn2mkLpAusQjw2NWta6y013e2genQ6MzqWQ4ixeyuwRRtc84FJGkF5VNfb58qltrdOMlXYVFFi+0pViRDAJYe+QTmMpdT4KZkl0wgcvwmWEurAPWHn/KGgQNTHPqnQJhBbF7ZYDiWQWRydqtsyK+9n0E8ygPXnc93Z7hvk3Xmx28XnDpAuKaaNYNDcid5ikh8RIsHQh/Q5MMtwwCxf25IXpf1i7C0Qt6P6QrstmWo1bnTRm77cPGN7CUPnol2cyIHfPMY/gzFVIB0v5wmyoTDxrjxEUzMKmVzyqR1noOJt5p5ZdbLtrsYg3HjE0OT19MJVVA0FvuvJ9UBvSI2sHLm8UCXAd/g3TPdD/QgABPMvJ5YIE2iHzvyOY9jDGj4roI8riojXc4U+AL9TnjPECV8n/tbN2CKx5oRCbZSc5CXPHxfOnf+cU5WfBeHPVgUES6BYevTGXeqnQZoKZUDSF+EZyVT3n7/L1m/zcXZ7
 LX+NZ7+g
 g7SGQySEV6IRl5Utg/mVuOP783Qcrni56nm3fWskTl4OKlOR8xy4aIHYDODzJLbf6XqNVLKj9l2zyrakXlsvrWVL0zXj9R+AgVe3mMGN7drj0sl5B3J0HKuzNJ7Ait1jSnUYptBUi1K5IlNqnuP5c46GlUJt6ZQ+asX4hvU56IriEiB/11TtfM2XYg/jlaOaSODXz/EdjcL/o89J1bCOP5Vsxhw4RnDTKECI5Rg3tGXlUYh1i51AvhhxT9JDcbg/HRI+wSVju9TLH5ehJ4dsXu54cGMysCasHZfJ4xY88GLJcQ10VlN2bWpAbqLGnlaK8lIjUt/DtGz3NDzb8XV6Fg21AcW+2DiNxkm7e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Nov 2025 12:37:16 +0100 David Heidelberg via B4 Relay <devnull+david.ixit.cz@kernel.org> wrote:

> From: David Heidelberg <david@ixit.cz>
> 
> Without WARN_ONCE, the logs get spammed immediately after the boot,
> on devices as OnePlus 6T (Snapdragon 845).
> 
> Fixes: 7179b2256315 ("mm/vmalloc: warn on invalid vmalloc gfp flags")
> Signed-off-by: David Heidelberg <david@ixit.cz>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

