Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62AACFD3762
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 14:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 784F06B0005; Wed, 25 Feb 2026 09:52:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708336B009D; Wed, 25 Feb 2026 09:52:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613EF6B009E; Wed, 25 Feb 2026 09:52:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA836B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:52:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05FA1C23E5
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:52:31 +0000 (UTC)
X-FDA: 84483270102.03.CFC04E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6D2AE140011
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:52:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KoAeoXkh;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772031149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eaxgYMDu4b1CCqhGuli8mqFA6url1u1XPz3Kqvl771s=;
	b=k9lmsA6y/CCXQp+ARYKXYUBTKaBZIb7nvEDYGHYGV0x7ICv4j7SlLy+yj+dqHKQTWjApk7
	YGlCTZFaxcmUMJdVF7UiL7aKOUwPocpLAcnCHejq2v/WBrnd4deZz9tlFkrsJHal1+5cO6
	qwywaDqUdzJRLUmoSa2zFFLfjcBMlV8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KoAeoXkh;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772031149; a=rsa-sha256;
	cv=none;
	b=HKJuDDHmZtYVaXuSmTcyliczhdcN7fphAvlxkF3vHWc2R94bqj+OM8vjvI4+TGmlaBd5Vb
	67GQLL+foNDpg49fLRsfr29R6eNo8fFL7t5+eu/QmCZzIr/EE+p7vWZQ1ZWZuubZUPc4hg
	Pwhwj7Z3lbnCbsu5HuGnNmbt3fq03j0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B6552600AE;
	Wed, 25 Feb 2026 14:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3BEC2BC86;
	Wed, 25 Feb 2026 14:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772031148;
	bh=eaxgYMDu4b1CCqhGuli8mqFA6url1u1XPz3Kqvl771s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KoAeoXkhhl1bznc4VYkRWZlAg2ppjiWIUk0dnyKZ/zNxMFttbW7QyxEtB6pG5zQjx
	 kRRp3jq7uA9gplfRPwbQrmmtlzahdHgrT48RPrE5hr9qEsas/hD22oR8nBpFmdJIz9
	 nKF71nxtE2uzxbqki8A49/NOqHEKaD1UetwZWfwNEopBdyqg0SRSjMIfs1BlmAd72/
	 S1D/QAw/CU+JLfxhBZKU86lpGi2wPVQg1fPzvTlnR/ls1nbYymevb3TDDKOiQii4u/
	 +yj1cu91PsamtV8cHHpRoUJyc5VGvw0IdmN62fKfAcoiMma3V/oyST85F6eJ5Ymxe7
	 N1uGyXNaHKg+g==
Date: Wed, 25 Feb 2026 15:52:23 +0100
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-nvme@lists.infradead.org, bpf@vger.kernel.org
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: LSF/MM/BPF: 2026: (V)FS: First Round of Invites Sent
Message-ID: <20260225-aufeinander-kummervoll-1953a06beae9@brauner>
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D2AE140011
X-Stat-Signature: iy4hzbrtwudx3pa7ube5m8tagqcgipjr
X-HE-Tag: 1772031149-201536
X-HE-Meta: U2FsdGVkX1+GdqeoFxNfK+3k908JmYAYWuCmmrrXSGI/V/DN0dh6mDuXTIJXyjt4BqWAK+qgijZG/bt9m4glwgizADBDXS94Wb2XjdNrrEx0JgL6m/GfrcG6dGmYTIgsjifvr/ZcHLR3X1J1JJ1eQg3SVgPjAMaiPYNVoVkqP5jz2iGd2g0kbtZSXD7QviP9VQdvibVvNo2DNhkPL6bU7zjaqiLJgxsQGmwSkbq9p9PPIxVyar2ImTWMNtVYp9O05iAdAll2w5B9DtqKxHlhsXsGFu8R/exJxrnGh+aMg91D2ixmIRZ8+s0dXx64hu0yhlaQ2vGX4TMvQPLLxrL/8RTfZF8LPSW+aSPrW64vq99sPVHsmlB0HK8nx6cT/D0TLQGNOPV5jEptijGuBz745M9Tmf97kjPG3hpjhCBoN8318TdHTX5Xy6zcjTEBieCz+U2LsFYRzCN7vGazQy8qI8qgwq+mcxf9KzkAux52i6etbJMhdCBWTuwMk4YX1wChU+jbRi8moCvWDRzCanLpz/Jhisi90jXUOvRdWqnxprTtuPlq0IlvJ7xTYboxudXyymVwloYE1o8/E6N1neXt1NItBVyN6GNKNI4P9BZee+XwOmEdO6FalOZFnsQA8Vm2u+uTGFyGhHsDjEyCNcNkfBe0bSP5luqi4mJNS6ZChAUQWwTAB3Sm3lgC58cnAa+YQywqnTMJOtngUg2nON8iqRnW0fAl9wlTf20P0KZ8r2aCZS/uLRbcVjB3kWjsfdgQA7D6OiT5VYzhADzv9YyZeNfGlAhLnAW0edh25UMbYeJgAf44a2LdErFyWCNS15Up5UGLIciHk9dDl+HbSVDzZnaFyiEheligEw4prhXVdEmS66Nh9K/Stwz7F1U+6VSwTi5Ma5wOcO4mVlNyLKQa5ogtX85ap+nzTKzdVey7lWKlFvNSAWxR/Pg8Rjw7Wi8g4MJtzlmdnxP+/IpACN0
 qfMXyvuS
 BZyWFQ9P5MXFG3X0PlGA66j+2eLS+nj7eqap1ONJ75zNz9yzLF2kbwxoxldzodqDhzDayMYqTq0SeYj8NXeHwSaF/ajzznlsxXI3Jvk5rsEXUin1pU0BunfPvP4mb6j+h8U3WaD+cCpqtHUH46u4M+UMDJkxK9ItyWGtSD1a/yTPpBVpiEFz5jWF5vvGzJGnJ6QjmxX4T0/LJjJ68HF+jFWrl30STYzAKrmwlVr/DFAZU3OXyMyGp4SzmJATVsjdtY+7wT/qKP4DGFZTfUSG4ADoIW9k8gJCXrNi493Pw0Vt8DVc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey everyone,

I sent out the first round of invites for the (V)FS track.
The first batch is also the largest batch. We will send out a set of
smaller invites later.

Note that the first batch includes everyone that indicated that they
would require a VISA.

Thanks!
Christian

