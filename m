Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BCE0D31A15
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C661A6B008C; Wed, 14 Jan 2026 02:26:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C32576B0092; Wed, 14 Jan 2026 02:26:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54D36B0098; Wed, 14 Jan 2026 02:26:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A4C266B008C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:26:18 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 33BB713ACD0
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:26:18 +0000 (UTC)
X-FDA: 84329736036.23.E6C7290
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8C165C000D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:26:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SlF8FjGu;
	spf=pass (imf22.hostedemail.com: domain of nroycea@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=nroycea@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768375576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bN/i4CQyNjdEdlfUdvv4JFg5bXI4mmxXHLVQN1SnSSg=;
	b=JCkZUMqAyebgi/dhZrBKNwQxCbAPL5Im9nSABv65YJNcrSanWmtNn4lml3QEOMunddTAw9
	xjy8pMxJGJySNmfurlyt5mw+YNSYiVWq/asgYnP15WYq55OOdvaJJVRfV1b1W/dll3B0/U
	vafhHZsQ+9CEXwnp9KzgoHxHKpZlduw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SlF8FjGu;
	spf=pass (imf22.hostedemail.com: domain of nroycea@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=nroycea@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768375576; a=rsa-sha256;
	cv=none;
	b=z+pSxXEeXRAP0KT+v8v274byX4KYUsflZlw7mUZ89usxpaVhhxsegop60tGxdGqBZiVt+e
	Y/5NaNCczmxxlEdae+yzwmg8lqiA1YIibmb52vurYrnjiijzM6PW7qo4HGNpwLVv43rmUq
	F2NBdcizuW7PDIvXYsPLoPWEmkTSw2A=
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-12336f33098so298320c88.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768375575; x=1768980375; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bN/i4CQyNjdEdlfUdvv4JFg5bXI4mmxXHLVQN1SnSSg=;
        b=SlF8FjGu10lFj88StZVm4gowF6hIDq6G2QYt8hTl9Iwn9aEB7o8spWYZUOEOLaaXmo
         rhlOM+XMXhMk6nqbrbEaROgqIqhp9I2zhNC2UjLh0Asfkh67/DAxtjyNE7LePoi0vtUv
         Sy1RMcPmQv/9nU+Sr4yq78Likhfv+zLccdU4W7UWZxRZNLv5nSZKpiuMb9xdCTH7iy/p
         xCv+BE7ceFPFumbJ5SrdbwpO6bJJ7AlP8EIpkTzJK397Wd0RbOEG91zU3LjMfxv/VeFa
         EHZ2514fr3sY1gaoN1VYqCl8ImGGsP5gwvBV0tvK1GAR5RRguzSa/WScuFF0l85R5c9B
         6YbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768375575; x=1768980375;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bN/i4CQyNjdEdlfUdvv4JFg5bXI4mmxXHLVQN1SnSSg=;
        b=QGSqd6VqT3ocS+TKS3UZuU+d+6RB0hZ+76eZYsTUhv3oucI8YzBHIWsepq8gwB1rbK
         ob9AcLAaxbtOiQ1LaVk0W47n3fx5pOnDl8T67wQz6UktpqjqjadFcnmtL3c+/vAKBm3S
         sjy5FWHk4g8DYpsXWx0/xDRyJRt2WUTWw2oQFFrwlUGm4Hqr4dB5s75ynt8T7T+rnOcd
         COWn03Kex6OcdVp4LqTvr1v8l5hAN3YNgpcERqFED0BQroOitb3gQjHReGleQUp/vcsc
         7FMpiexQKWbqObzjr8FvckRVbHu1ZmpWAmQISyUnjg38eTArMp+jF9NLRJdo42PYvrkw
         K7iw==
X-Gm-Message-State: AOJu0YzRrKWzzSo0sNWvSwGvDGGR6+d4a0Jq/tLkPZ5xu8lRtcjIWTXy
	EPW2dbOhYDQYiXqlxKZ9PGw5VjrUMngX0cygCO2E7BenbA1nKWSpohau9REz/4ySg6cvKzRiIUp
	CdiNaeF89JSb35zQ3/DXP4a6z4v1p0dg=
X-Gm-Gg: AY/fxX5Ivf+3Sj2Lwvn2UuxWa/+/NFcgQu+AksuPjfys40I5jgpjjcn5dWuNYrQFS02
	4noCdbyAGoqpSYHnmL01uZ84BV2yzy3dfn2mzg+9mxr7LTC1AV0eNVFz24sUlRdhROTiKJ3YJCd
	xOp4GzSme/HI7KjDRawiXRMkGpaqSh2dUBRRzSxSD6xHiLWTsNZnBST7+xbJPfanFEpglbGFkI/
	y3ad7F5xMbBSTvxKDq26kXcWYW2INsuPfJC67OY3I6lTxYWMOVbgM32G56m93bvnYy2FHBb
X-Received: by 2002:a05:7022:3f83:b0:11b:9386:825b with SMTP id
 a92af1059eb24-12336a9898amr1882308c88.48.1768375575118; Tue, 13 Jan 2026
 23:26:15 -0800 (PST)
MIME-Version: 1.0
From: Nathan Royce <nroycea+kernel@gmail.com>
Date: Wed, 14 Jan 2026 01:25:39 -0600
X-Gm-Features: AZwV_Qj6xZyzL8oV1F9nchcOQymQWdiVrb2FW13YKa2ch-QlHmBgDRvqaxL3X9g
Message-ID: <CALaQ_hqfXkfU0TwcXReRPuc_gCo=5OGF1dtV2To0mPFP3a49CQ@mail.gmail.com>
Subject: TmpFs Incorporation Of FsCrypt?
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: z4dkxxzeacznwom31a61uahaw8quwmtm
X-Rspamd-Queue-Id: 8C165C000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1768375576-764708
X-HE-Meta: U2FsdGVkX18KBVYeUCu5NCf8UYOP5/2BG3Oq94bh4Sz8fSfZ6qZ2gIxTtxPRvnGYRmhHpiYu7SMDs5UtCYsT4vyHrxw8+p4mQrCzDqRxGm1eSiwSGMuCwrDgCgHZ4CCQJr5OVzUAplFEoutsyfrgyhLZnuVAP607gEdkG9s2kIXGiOyMM8vb7nkPJWkGMKjZNlVQlpxXPmzQLzfmuIkw1Z96u+8boEGju5dCDAKJhngS+xlclnrojt4sdDCXCBNyw84e1vS5BfTpYdttnruDeA4au3hRB/rNzA6yyXJtEqmvn1yAS1IBJ6hM56zZQJrFjChLYMuka3fWKdtmOdW0UNgd3A1e90/NqTuD5afZtv01oXmM2wsdTXTzrUGZD1foseHNj6YJp9l9TMQHtmuyFlvuHsB7ODQTQNxJ7nH4V+2Pw+zfCUiHep0rIKT+inLYmixAnpsC5ko6relCsmMXq112n665XhyUDWTuuKtCMiyJi56aFy3hBmfWxJkzxRQuUgRPx1MWZDz//LTcy+KdLfmJDDB9uCGqhjJyAwzGyPEqzlFfUGUMKi7Y5WbxJQniaG4q4zZUGZ85cuC63yNcgVxbBBwVIOjS/vC+s390puVC+oPAoQdn13fUXjzxe0uVn6v8oRZThwq4aGuDNLyCDsBRA9ekPufEguUzb++smj4f7A5MwJuxt6dcKBq8NuADC1IY2oBWJBVVhOgI4vHMhQuI7jKsnjEB/Vrm0rVWC3rIt9tGTWXZR3XNaNQAqYBlKFrrhXu3kB3K8XZZ/beDRdKt+SkaaDxk8FcG+YjXRgn7wgW3D0MYYUwDhpBAVD8F3IfbxNCcmiKjARA3/Hux7UMWGl6nNMSqYF10XqJ9T8TXEwzzYiMXRYGGOxMWePb5HDygBTttb3DhXA1QfVS4MIePjrQ+2ASwTBvV34+pAk238XzLtq4IP/0aGuWciV2vo6nKIKBCpnzy4lUmnuW
 2vVHQfX/
 zJzy5lWgfEl8VfDfJjt23PbPvcVXHBhXL1ygaWrhaI5k4WyhR+rNoJ5VD16KkMkPwXgVI34WXkHcLR3XUdVQb46Xte7uk4Y4FU32fNs18fS/UTKd1pg2MDsIJpSNYv9+EinE4Ch4Ayb97o6IBRAfaw6nTSj2NjIqnNHdOQlyhdh+ck4RaH8CHFwNKU4wZJcbaZRu3lfMjvcU0IuYkVPiD9s5UzkKuEXB1PnqPNmUoQf18iQOwds+X8vbtnwOtVtZrKsFNmWFBTp3EqfvEYTGlwOu7ZgvZkRuT+SKZ866cT8sZniam88pfkknvrPbFcgGrJkdy2y00tzYX0ocTyWherriAqJGI6qZtI0GmZM4gPf4LqaSFtjOd3MQRIeFgZVi0w6DnlPZHScKopl2Kvm2/ARL8Edyjs8vNqTfh6v4D6tOJauDPgRV9IwGtfrYGdDd4e1NwqKCOCK72ZNt/IoHiDTaSSP/jlU8JoAH4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.004853, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I recently saw the PRs for BTRFS relating to FSCRYPT, and thought I'd
explore the fscrypt package.

I started with `status` before moving to `setup` on the `/tmp` path
which is tmpfs.
As expected I'm sure, I got: `[ERROR] fscrypt setup: filesystem type
tmpfs is not supported for fscrypt setup`

Looking in https://github.com/google/fscrypt, I saw:
https://github.com/google/fscrypt/blob/ea916da7fa9844cc3da608e75510f478c7b09f7d/cli-tests/t_not_supported.sh
which coincides with my presumably expected error.

But I also saw: `The source files are located on an in-memory
filesystem such as tmpfs.` in the main README, which makes me wonder
if there is intent/plan to bring fscrypt to tmpfs.

I'm kind of thinking a use case of having keys and/or a password
manager database on external/encrypted storage, that gets transferred
to some random path in `/run/user/<#>` (tmpfs) on login where it is
encrypted as well (then the storage is unmounted/locked/removed), and
the respective program that uses the file(s) would point to a freshly
generated config that points to the random location.

