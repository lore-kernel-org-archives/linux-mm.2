Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC9D606A332
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gj57/5xQ
Received: by kanga.kvack.org (Postfix)
	id 6A1016B05B0; Wed, 18 Nov 2026 12:56:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678C36B05B1; Wed, 18 Nov 2026 12:56:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567336B05B2; Wed, 18 Nov 2026 12:56:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 359E96B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:56:17 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 577031206DE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:56:16 +0000 (UTC)
X-FDA: 85448993952.18.0D5BF2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7CF14140009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:56:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Gj57/5xQ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795024574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=13046BEyk3OL0XiJDfnqzRxyQM4EIUQxyIC+qg+uPx4=;
	b=vwgD6QBCBIMOeBMaj4LmAm/XA263eGZwSQqjDzW/0TaIz/mX2zDL7SZOTazjUspLLUDkpO
	mlfgtFy+uftdZEf+tKO04EsEP/M4IknilX3Cgv3986a6fUg5xLILQKNyeDeqAA0CKIgUAZ
	wq9CNJKdJjoJkxctd67ZfzqafW4Hgp0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Gj57/5xQ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795024574;
	b=nV0lEBaIQ336yg1qU7MnlmJNSNWYmSgWuJ0VMVRnWkhSqZuUzvEES5OEq1VQPJA7C8RhTx
	ye8j/KDzybYo0XF27pb4CIFKyRL3MejlItyfOrt1n/X5/sIyi9YFOwD37nICbfYoFKgij9
	vv/2OumJW3lTwFuXBekJefirqh1VLZg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B0DC40508;
	Wed, 18 Nov 2026 17:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0771F000C6;
	Wed, 18 Nov 2026 17:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795024572;
	bh=13046BEyk3OL0XiJDfnqzRxyQM4EIUQxyIC+qg+uPx4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Gj57/5xQvx96AFQb5qSmSIAvCs/NDEgpjKn9AwD+XaaF6SCgRpFyvf2Px4UGCV/fU
	 uGHtFLLfhF7abcL36OCI0/GAHN3DrhR1QiNN5PGDKAwLtkOq6mCqn5GfBVZLmnJkrw
	 flW1AnyzCUNsiM7ds9ZqdLrybqaCBaJ+BQAQszenljMg446FHHqRx8v/dyiuYGExgR
	 UC2ogdwIW9DxiygNAlFOUNuGZx5jLHVBFV9M10er/v2KJWHUFscqCwlYjDL9MV5CGy
	 19X2Fq7si5Nu1kzGF3JNtJq2WjEGrdogLOIRpicBDaLFc48qdSJBm5Rt7/4IZCnJWk
	 dUwMnT8eubnNg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 772B43808210;
	Wed, 18 Nov 2026 17:56:12 +0000 (UTC)
Subject: Re: [GIT PULL] Non-mm hotfixes for 7.4.rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261118000947.a86e7241c67d295c40eb8b71@linux-foundation.org>
References: <20261118000947.a86e7241c67d295c40eb8b71@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261118000947.a86e7241c67d295c40eb8b71@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-hotfixes-stable-2026-11-18-00-06
X-PR-Tracked-Commit-Id: a001666afbf9d2a6096fea95686549b9b1c9d968
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd
Message-Id: <179502457112.1929586.16741761767129300180.pr-tracker-bot@kernel.org>
Date: Wed, 18 Nov 2026 17:56:11 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org
X-Stat-Signature: tupyqqtncw63kegij7kkg7t3ob6q6oih
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7CF14140009
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795024573-779344
X-HE-Meta: U2FsdGVkX1/jVjZ/mTDBTgjTGcOWlaI3uHsHsrSLJONHNEEZuZQkblirFjRsPPcT25HC/Bv2ywajZf8Z5ccmDSVYRCp2sZEHg0V+WrTLK50qLykfmesxxkC+I9iXNkT2amhWepnxSVWI0pv2oQqN1dua79EjND5IROPP7Ns0oX+HFrweIV5Mqm5/ZOl72Ann7lsxcCwIY6p6K0g2Ks0QmyKzAF5kcHIIf5EUrjfvBzKkhRFDKn3m9WfdHO4WyXnC6ZrrspnVXMqBS6ddhkgepyI3VTnV1NfIeqZnMudSsamppPtNYxOq301tcf5J2ddM6tpWAgtqx/vz4jZ3DM+fnjquylodj10Ya0KiocemNUCYCcmVP7TN5YY7Lj+utsNo/rKHuqDEyRIuJDYkoqKc2HL9UjZpamzYsotfjwlVd4zYuwpZx2TjEvEK7jgeFz4x64Dm8Dw+03OyEfyeuTurY6Gj55vMXvYUJEkOJecue1Y1ZYBrJ5KwrjDN5ix3H1zvO/h2esjiLDipA9z5xDfXDwcYyvy/Ez4VyKpCe4+D24OuB1N68iLjV5NFeEaknUGlm6jYlNrC3cO9TGfg9f+5d02xY+ND6GE7b1q/QWyLwjhcdquQglDOHZXk+7/3EDJBGzrhp/sQz0BYBnYuH2HUZf4OFUG32kryMBKuN1HdQ+QKP7gOmqdiJOHDYa/62OkzXSllBGVJcAe/OgD5txsb0ri4M5t9sO/WcfSi6G4P7d7qG7skQwDibYzHX3htILg/WlzbDzuiSqIVreBjm+MYFDzNhqkvQjLUNjFxQxNFMWjClksESzR+rYlMd3Dbbosl4lV44WSs0pqeOZwOd8uovyuUmz7muxA6dH9NCGgakSN2GNn0uNX5/2Wm/M6EuA8vqy5OycUvBECuLFJAaNFa5cNMj0VaaYqZdi7dI3uMAquTR9TgoubIFgZW7xeVWw7MIQApPJ5TRraTMfLHqk5
 oSU/Jplm
 tjP6Lp6XQJySRyWIdnYU9B5riQfDxhkDLzMefIzdg2xM2Lc3BADy+/t3G53KNU8RS67qm1A49pRTYGOSotMwJtdT0Iz++XVKxP51H+qKcDdS4NFyNWQVhNQjW/pfirZoFQOfn0WZ4phjA3Vg996+ovCZbC6DFGQ8XoxrRCBPdUvj8qUHeOdhJgNuFPS6CF0bTK4ji7oi1j3bQihsnqshEOYQQnjz6duMYiTfDFQy6otR33QnpnUX3YCN4b9su2Hr9J1QcG2MixDbUQRZeSDon7qzyy1E/d/TfMvDHcWPKdHPpG+htZZMbvgv+vHuD1r8fpdXKEenfKlqsxQ4p+8bmhDPAS62ss+W9+tHmt7E+idHh2AV5C24BMBB0HhQRfxF7J+8ENZTOsSCH9uQysxhhgADKz+0ki/PpJZsBVPWuXYykqdWnRKP4H1AhVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Wed, 18 Nov 2026 00:09:47 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-hotfixes-stable-2026-11-18-00-06

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

