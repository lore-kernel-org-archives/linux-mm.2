Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEE2CCA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 16:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54878E0051; Mon, 25 Aug 2025 12:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C8F8E0038; Mon, 25 Aug 2025 12:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D426D8E0051; Mon, 25 Aug 2025 12:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C2FDF8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:34:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 764321DD896
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:34:11 +0000 (UTC)
X-FDA: 83815827102.06.D024A02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C113CA0011
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:34:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AJmGmFSf;
	spf=pass (imf25.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756139649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4SlsLIWhNHieemuc/uF6Jc+fw0ILU37oSlsdH6xSuA=;
	b=Nbk8QtdaOqh/wfciPdI3mp88cKj9ifoZv/u0ToHpR4WLft6E2eXwWFvruHyFEye+3VArLE
	y7LWoVS47CovgFhx3xU/GoVrkdGSCZFepcRU/JbLXYTPPByC4Uct/3JTcptuL+dfQY5D34
	S61nAiMuMJH1yRnADvJ5DJKLB4gyrzU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AJmGmFSf;
	spf=pass (imf25.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756139649; a=rsa-sha256;
	cv=none;
	b=z2GQkkWVFAKRktJMK9o6gHwJ/i3c+idHgOZYAlPTmIazErJkQbYwirCZqMJy9ua1B2OKH8
	QZBUD6zfgZAcYugxVKOgJy732g7ZenVTZEGzZ/LvlH2mpA8E1Auh/gViE4XlZepzDJwkW3
	2/uQOFYv+J7HT3yxtygiltiZu2l3kLY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E06960240;
	Mon, 25 Aug 2025 16:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6487C4CEED;
	Mon, 25 Aug 2025 16:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756139648;
	bh=zu8SPfBerugkmDtJidWjfcjeeP42SIXM1xJk+/uNh1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJmGmFSftbFswP7vXw79bS5ADxT9fQR0UJ/SMXBMrJzdD/I9h1x1tFXvKihlcevSg
	 IjzWX4509+rRBljotULcr7T9GSzjAEIotwK+wkNea6fxrlOPDqWbPIvNj7BJFfQPwP
	 2KCXt/Zo8T4+pj4+p6GLieTyd2uft1wYpjeVNJ9DA03JIBlYZlwhUC/L6+9gKoSoN5
	 B9YG9J8Wg2M42FaEQ66FvlmlxcJW3mSG4sCqOoIUT7hLJnW+3XTVwnJgHLA6L0Pu5O
	 Q6tDK/afK8v94nntgvrOjYC/ZQhaQSxrdL9yiGotHFOwjDNu8Aok15ITKTfREu0QzA
	 5IKxG74piNDYg==
From: Kees Cook <kees@kernel.org>
To: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	Xichao Zhao <zhao.xichao@vivo.com>
Cc: Kees Cook <kees@kernel.org>,
	jack@suse.cz,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exec: Fix incorrect type for ret
Date: Mon, 25 Aug 2025 09:34:07 -0700
Message-Id: <175613964617.2086956.9956215220581274792.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250825073609.219855-1-zhao.xichao@vivo.com>
References: <20250825073609.219855-1-zhao.xichao@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C113CA0011
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: eh53qxmen7chrqdmcu37oitqo4sbddpa
X-HE-Tag: 1756139649-416685
X-HE-Meta: U2FsdGVkX1/wO0Z8fjgwdmcdDFajTgeEp9QgPoUtzKo8D44zzYk/zAoL/lgEX/3AyjOAB2mNlAkpZHx5hOVtQgYzk5sRaeHrfAZKRkCMcE8ndkiVDeQQyt1wX3vYqPWc+VXGCeqU2ydBdQ4d2hLGyIzs5g9s2TI5AUb900DVF9+pqSBAYcUQM6SN5g/ilmgzyTIH360OAoiIKpu/Ri8YQTrXP0nni5bgjEuw9E4qL3ObCsv/GteD/arkNNyNEIsQqt+tHKtZ3zfcrz1ZaMiw4uDWXZzKBQztY8pTFElNhlqBbKK7Z0jMWPKjvyPMcFOxbCLW/wUjJolCBkqp/izWStW7aYEudXDw7Xwjwf79MiQNixWZ+Ws0zybnDO23VDJgvgu2XAQLHJKKRp0+W5cbRRMvV188cZH0gD23cdWOdt7ADRV3KXyqz5p5feqz0nUbm27oHI0p8OG6LtX64qRJNOJ6lPdpTEodWm4yX88jQtmGnaEIID6GXcguOimCspLbeVE8mHTS/s7T6NoVSqYltMmaUt7XGXRKTvG0p6b55tfB8An7YG4wf7vB9tDhYMZ8ieY12ePHgwgjoAZ9+OREzEaVZ7j6sjEbRYZb7AbOAF5OtGTzyHXeJ9bzpsdWT+O0qJi9o3ja0ZpfqH7ni5JY+wDbc1QnmGQlb6i0u812ni78BAIh8nvjkcUHVd2yWG+VrxiXpb/q2AsI4Eqp7dzfqA3j2kMV6ISNeEM/b9LLHr2hhOHvLrrbrxv+4kai3l+N1j86N1ndMEXr/qp6EsrJhE88s/NEqQjDqmhzZOC4+P6bwqFKIbxfDxRsXNRIr/C3fb81Ib17l5kVh1a5VxVjORw7pShOECkBEeibiLLG5Z2zPGMaDw51UT+Td/3MrZuK1Gswd8CEQ0D19JxpCmLLRzgDVINg44obH/oewSBnm1GmA6g/3bP3bVJnl29sMRpkZSCBDjHvbyYp0Gqpxf1
 QQ/LbQpa
 Lr8qh6uEcWDP3Ghyx9OhblJp3veizWoauGRYamDz8Ycx+xnlnU0j45j3LrU3INYwmX2/k9RPeXv3bwnmYInZnTRNZumbOCOvVOm1azl1Baoj3k7qIWFRH5AUh2sFds7S1gQVcp6Zb123Pcy1ccbyGBKCF8WhpD6ujmmFjZdKQHHmCxsM4+ZXg8XZdSzFLR4+c8vsF31j9mvcDV386mddeEKLaVeRBhbSq/dDgAOxwKqU27aVbgAixkTt/uQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 Aug 2025 15:36:09 +0800, Xichao Zhao wrote:
> In the setup_arg_pages(), ret is declared as an unsigned long.
> The ret might take a negative value. Therefore, its type should
> be changed to int.
> 
> 

Applied to for-next/execve, thanks!

[1/1] exec: Fix incorrect type for ret
      https://git.kernel.org/kees/c/5e088248375d

Take care,

-- 
Kees Cook


