Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A65BCDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 00:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EFFF6B0088; Tue, 23 Jun 2026 20:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0536B008A; Tue, 23 Jun 2026 20:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7256B008C; Tue, 23 Jun 2026 20:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17FF26B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:20:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7ABB5401A4
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 00:20:50 +0000 (UTC)
X-FDA: 84912900660.13.8900441
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id ED70140002
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 00:20:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QOAZrTnZ;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782260448;
	b=pUk5km+WXeOByRCsAK5koNHGKY60O7d2B9Tby20Pzz8ND6DYWLf7dZaCQa3TVJa0jNvU5h
	cVWQ30A0YFP5lTCLD+VrpHx2XauyF6hcN2SdD/JkidNLagRSMltbujFfx43E4jThDLizTZ
	IyDDGScbS3h1p8ymjGcR0B0LJ3yDqSs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782260448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kDNg5qVV08yzWrQjBlrIqqisNfsb2IhndBrBJGg+5W4=;
	b=N1Rpc0VFCx+62HpwXSg5wwvMkPDpWz8s02ZkQ69S19+RYe+aPRC4yWgL5HmcMODrCRKanY
	t/c8JCw2F4EZDwSIIrErX6UD6zJ4/13lezfOus6pJWV6czIy+Y+AuR7rRqWdkseQNuarrr
	m9RYWU6jhSz07WsboMZAIkV9VHTagn4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QOAZrTnZ;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 307B660172;
	Wed, 24 Jun 2026 00:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6A31F00A3A;
	Wed, 24 Jun 2026 00:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782260447;
	bh=kDNg5qVV08yzWrQjBlrIqqisNfsb2IhndBrBJGg+5W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QOAZrTnZIE5z7P/X/uoUb09VFIqQs78MFh01OBUyxReUzFIMjL7phg+LvbnU6i4DE
	 /9RChsOZze9l9kT5SR818AGN7xFvH7ZOmAM47H62mLalZYgRIxh1j9iP6kJyJTOZ8R
	 3OkXKMFybN+Sy9Jmma/U0/QCTSjVwjDcCouLqtWHomNiqG8Zwyrfj12O+oqTRanzbt
	 9WveQqXTozHsolmtlMuCo5tL6ZbAyD4XQn6OG71iJyMbHBfsQt/sIlwTjXtvf7+nqj
	 WEaVmtuMijdSuFdMu2CX7iVReqQRs1/XK+nPu1LNqXGNdFGkRlFSCykUiEcUYnBYxE
	 ZeUWTA1LjPa6g==
From: SeongJae Park <sj@kernel.org>
To: Igor Putko <igorpetindev@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/memory-failure: remove redundant initialization for hw_memory_failure
Date: Tue, 23 Jun 2026 17:20:36 -0700
Message-ID: <20260624002037.77770-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623114743.4565-3-igorpetindev@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4dhs6i3xaioxup4oxc7n9fu9id74ex8b
X-Rspamd-Queue-Id: ED70140002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782260448-246911
X-HE-Meta: U2FsdGVkX18vnwKXQu6J1jcJRX5gq/7IsAskNnE87Xzzhr/ORABaOFbqAmEggCCakbm4EwJsQrBxsrG5+0q/88lF7JeeOr/x00RrlUx9rzMlKdrusQf1f2I+fThiJM+qtyNqAm8Vomlrmcwe1Jbz80YdhGLcNmmb7l3yF0bI5ymvJNc22fGTdyHyjXiot5Rnb6usHLBqMmPFOD4xbfyclfHMJn/xdvIKPM8wzzzRlMXtBF7CEXIAZOVxJ0jAOsZT3oMqX3+ocuEVyC6g/BFrLW04W8wk7AZ3tpwuUiOUG9vWNM9oqYLe8JVmn7WXKrI/0aYEc5P57qZjgi8Q3pAA7a5NjHN8gaFTAFDcdHhVPBBNA7LaJlFugTZw9QagnVb6rjuy1aC/7CE6MTvlhRrH3JXSKSJGW+yKRnKrK8NMwx9eoj36A6dWP8Hk028+SwoTfkkVP29U8LgrJGbvtfZlEXLs9OcFKG5xyJEYpsQO7/Y8Qf7sCYWQfOoUCrTVVMM62uMXNuWGFuMgyivJjyVzeO5HDYM+0Vm32WOdjAqviuPGQlzmDFsgQcYsXVYDeKZzzgr1z16IpLXMT7z8glwdpWU1Nf0yrqevbLBQRv33+XmOlb6ngSaL2GWLy+FkMoa3Z2NEg8R0PasVCPqvoj7gzlFqOiY8o0SRx3kmyGzayaDpfj++jeoNm2JnPViZu0sghAwf+FwcepIRNQyAx418yJpEO6ZS0tYoVBt7zUQ1clUCqUGBBATGq/aYM8L6CC9VJtA/hXOK0AK31Iwszvfj8vGvcTOQcZuIAkvdtn0IfNhkXegsgg7fm0QR703aDyf14lMGaPzfxsVxbfZUYu4nyKgt6sl3Te6Kz51BLdasi443HWZH6zh+30DK40xniXO01qNnFNfX0KTzGQbEuJSW74R3WsAt9oGaW/F0ougp/Mr9z0Kh6VIFIoejdSmzTQW4Q4P7pR9Lar7Ig6mi4o2
 u8NlyV4J
 vGJcnHuceaUpiMK+EGhK/u6I+yN3lIGU/M7CLHV39GVcR9kV3W00X2tamwcQ6C5oTsc5ZIdqPAMOl9a3Wp2MTQmqK7NgpEoVgME1uJHTVNhP1zYji9tITmW/6XKIP/p7MeBZCGu0voZyapjgULg7zbFqZESx550HGgJjwnJTThp0utBITaAxhM1VIR9EBpLoORpocjcaNlFMsjI3JMNUw/IDcYl8idXGqumzghlQVyKzjIGwld0ttjfjuA8PWDCMv0DyAEsLMy6qUpf9XrlZP93iSS0IbwGWtYv/WoAi4j+H1bGrm7Vf2b1479XmseZt2NZ/PcMsPCDcWXZF+YVuvNQzk/P4izKfsWHBeq2WmXsTrid0bhyFnNj1SaZiHFbmGKy7v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 14:47:43 +0300 Igor Putko <igorpetindev@gmail.com> wrote:

> The static variable 'hw_memory_failure' is implicitly initialized
> to false. Remove the explicit initialization to follow the Linux
> kernel coding style.
> 
> Signed-off-by: Igor Putko <igorpetindev@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

