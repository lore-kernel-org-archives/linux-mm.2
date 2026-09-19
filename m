Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 041E4C982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 01:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E70736B00E7; Fri, 18 Sep 2026 21:00:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21C76B00E8; Fri, 18 Sep 2026 21:00:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D10526B00E9; Fri, 18 Sep 2026 21:00:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC4906B00E7
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:00:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3429812015B
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:00:32 +0000 (UTC)
X-FDA: 85228706304.10.ADAC0C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9B267180008
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:00:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j1WpHsfm;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789779630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9lElQgrUnY9LHTkSAaKVYQoZBcsoW1xlrdh3QP0whJg=;
	b=6GraiXAKVFylVN1/ke5n0GTB59K0HoxgzMsiUX8XjXTIjPLydrIypsDo+KDErNYoJuc0o8
	nAaEh6Z2V6iNfeP7kCkIbR2h+SGexJ3FhMf6NuHrDUTATnw+udCRXPZkE+zw5SCbqavfQX
	BXtwxM3Nzas7zGIb01GO10AXsWnFY/c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789779630;
	b=gIy0WOFCe8XOVYmS//sJhXpfKOQ5afvon9G5KTYi9HcM13c70eCscGFcTekeIffut3Epcj
	WqglkRMdBX/hCGOeRXdp1+GwShDQQcmelbFBdIgPdaTKPgo4N6xe7xQb5p0NF0tcqtgL9O
	qM6tGXGYFtU09wOfKtfO7hR7yQLbCxU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j1WpHsfm;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18F746053B;
	Sat, 19 Sep 2026 01:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896F61F00898;
	Sat, 19 Sep 2026 01:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789779629;
	bh=9lElQgrUnY9LHTkSAaKVYQoZBcsoW1xlrdh3QP0whJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j1WpHsfmwAvEKkTHWYEXgqB5++KnNamAQdRHtTAriAohTEtMtu/PdzVC53L5e2n/h
	 w0Beh48taro9Z+W72rv17Vmio1IhfdJAgoQ0dd5qFl/sJQC/Wj13A9XAN9G3Cy1P0d
	 lvsMEs1tQdiwSYKbEuzil4s11Z6JQeMvbYDh576S6I/SdizuStVDPny/BaUlbtjH4V
	 jv9osrZrjlm1mAMt8FMfjBf3FOWVMzTBpMAQhCjOBcQK/5tUVs90NpM3l2SB9mPQ4H
	 2zNMxIsJp0t780nRIqsD7hiWK+eHOBYf0dxga9vYgRf7RM36gcoouXEZuML5B7GGcV
	 p78wvKErbOtvQ==
From: SJ Park <sj@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Constify arguments in default pxdp_get()
Date: Fri, 18 Sep 2026 18:00:22 -0700
Message-ID: <20260919010022.88004-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918064928.793742-1-anshuman.khandual@arm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: nh7bzgftiykw4pkjonb5rbbs3uco1ae1
X-Rspamd-Queue-Id: 9B267180008
X-HE-Tag: 1789779630-24054
X-HE-Meta: U2FsdGVkX18z6vffgk+Vyhc1SI5fjqzu2twHM8QM1pOmT3DTMg+hzxTSWjJZhx++3dVjcCVmw+9c3jfwNXi/VX9e89iqcxTUxu5jvnuOKboO0KIp6I4IbfMrJSdCWhP/cz2etYv75vQS8DHIKPNHIVs2z+SJgCaXrOOqibqXWGdOxz0dxRZDQCRzD36//2sByXZnSQwwVu5Z2RJhv00S/l+Q9Vac+zTIFoAbnFygcxX5jB1ILTjSdOabSb4IZbXRLEG4BGAbrnvTQhwFKykBhjEZuTkTMiKK2bjyxQr82HnjuCbTQOWgJqNGTQ4mmcQTyn3kwLEbe1YSmG63GOiPjR7Mr+TuHyKY45wsUZayxaCOcQK5ixEQpezAvpM+WV183YQBYsTqcBBsuSvs8y3hJ08BgCIh3S46ze0cSuEIzSw/bnqIrKZ7Fd7cuRpqXIms6Wauc2tlC8SxsO3aXWOyh9pF5ysbG6lkzWOuThE5YzwgYaz3Tv8dOQg8J0tqyGWg+tZ9tN3MlHmn3blsNSUr+hVlCJRK+XQrubOuzAgRXNmw5EZJdF30oLKHW+QOnKMIXDDh8Xe6AnQO9hy1393gse5IqZWaY6oPrxZSXIDv1rksNMAM0SuATtuBNk+1q1MOSzxtmJy381Qt5lPW4Jhgmz9kqEhKBvIagr1u61moJvO3gEzmr4GEJNPE1XADMmp/IR8N5dWfYPntnpJZcLfRKB9r+R5s3vhxr778SqnHHhaRt/fprmrSY6DkCwb5L4ri4OB4Y12hCJeXaOK9w9Xga5ustjsC4PlYp/NggYdPhrn0gldb7kEvwKnwILTnG1TnizR5+HU1wMSXzYo4N1a/3Y8/uYf0WvUD2oXnLD/HA4q7wSA1cEgWiO7KRkfagmjKROwjyvaaBlDjPXPjojdttwGCt22Gj79V2sh4ATgtQ7Q0HBvTMQLObMBKha2zu6Hh0pboavLEBuJYNXuIkWK
 WD5dLTcZ
 Mqq9ptPeXoLx8ehl+bGO2VpNDALs0g8gayQ08JENXWWU0M47Lbfw6yjJ8N3uDNlgPUDn6lAn7CUuspklBMAHR/QA1dw1CftgrNbc8iMxYBYjwkl6/DBDgulCHrB/pM41m60q5bJwUx9PTFWQtjXq+Q8dCmAmRLqGxul2ET2VUM+KDZtHu/12TcK7qRvSvMxyeqpSEtc6u602BXYWDS0FA72Ww6kdsmMzcQz8hspuzofujsN6YLahoQDnodNk7rcfRJhBVGHkQsZVBtWax9w+aB3To1uIL+JElJEX/SXIc/8F2U2i7YaraYzxsLaX6FMUDH4r4bRkDwAdujRNh64CViewfLgJvKgeHYZZpGmFSYuCeSQ89zV2q6dxkyc6S+z/7kAsHkZ1u3CB8LyC0eIEKlY+eGjq795+i6GpUJSW6K4vsduoLeezG30g1nRpCRpf50xHMdGoRT8+QY8U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 12:19:28 +0530 Anshuman Khandual <anshuman.khandual@arm.com> wrote:

> Generic MM default pxdp_get() helpers fetch the values contained in pgtable
> entries via READ_ONCE() without modifying them. Just make their arguments
> explicitly 'const' for some additional protection.

Looks good and safe to me.

> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

