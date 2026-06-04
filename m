Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7736CD6E57
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 00:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2FC96B0005; Wed,  3 Jun 2026 20:46:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0BA6B0088; Wed,  3 Jun 2026 20:46:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6B16B008A; Wed,  3 Jun 2026 20:46:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C26086B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:46:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CCBC14018A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 00:46:11 +0000 (UTC)
X-FDA: 84840388542.05.4316402
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7916F40008
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 00:46:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YG7gV0Lw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780533969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNgRjJgbYuUrLzdW/5WEzZhlyP27Ht6YujPqndZuMqc=;
	b=JWryxPoTZ+GFXUWsXi4IiEbdQmyONiqkq59MxSHlD8EYlTpL9Qzv2/St/+8AcPvgIjfN2g
	3D7f2YrV0o89fPq8j5NvziV0kS8zOtp68lIVlIsqnmcjZvIM1+oHMrBw7jSH/8p6KO5Aqg
	nmji1F5V+GO9rZNuSqZoXgVb54PAOuA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YG7gV0Lw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780533969;
	b=rd3y8pS3fRa3VTG/nywIigFx8cZM5UhlmKYO5maEgvAz/eINXymx9Apej5YvxswCxJM5AA
	qOdh3mnWLUsNGO5h15OV73b6OeMtwqsx7daX+Cphh4gHxai0py+1D5A3M6QHGTw6af8lWb
	+yCm9WBKKLjwebL6klhc30oG7OIS1Cc=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-45ef56d9b67so74815f8f.2
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 17:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780533968; x=1781138768; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hNgRjJgbYuUrLzdW/5WEzZhlyP27Ht6YujPqndZuMqc=;
        b=YG7gV0LwwMwbZOf5OIXHHTi+bSxyJRsmrfw/nnBYbw7GZDA7vKHCSq3ZXyJSV6vyuy
         MHt7DhHOh4L/2q74r7A7EbP81FRA17pqGfje+FfQrgzpIFVEqk0iv4gbSAd+0TY/GO7O
         8x0qanot/7sXrarc3s7sVyDEaYKzaZuQOxYAUTzw+6lN+gKTJNMXZ3RZtInd0awg23RM
         0HPEFURzBeowMl7J1Ng77Ri1H65Ui2fs2x/B6+P3rdoPWjVhLpqYrnKoZZTU8SSKdOpc
         urbdlEPPn0MJATNmHtt5vi0sf7AJ+Yyk/0kmmYqfgo6NnHxrr7RKxk+SiPbHW9rNQHOv
         ICCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780533968; x=1781138768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hNgRjJgbYuUrLzdW/5WEzZhlyP27Ht6YujPqndZuMqc=;
        b=g+wqwMX+uT77jCM2fJ6xHarZtER9CWJowWYT5NIM9qg+3ueDMJ01FTOWt0VN24g08I
         whnpOnAG98A0nmlAs3Qhml13jmh+wDjEw4xG/rieG/rai/c3ukcI5Vq/sucF3iQ4644Q
         FQn2aFXXeJfVzQsJfzK6PDKBFFkCTC0f1bmrzpu1Fss7Z0Gfltj8y4BLG3/VyKSsmH51
         osSxPKj6Q9zr/i458shUHoB+3mkjDHAYwi2QuuSTy6j1cEVM2UgG+cr2rsnxqP2LXrRH
         /CadPASWA73WccFGOvGgtjiuV33uSP4mKpdsTN+yCpSZtAGxbd/vPOup3MF1tjCozhlA
         Zdtg==
X-Forwarded-Encrypted: i=1; AFNElJ+K3XBBAlIB+36K9/RMv+TTl+dgehGzRYriLh8skzFeM8jQ0U6yM3pWvvq8xK1JkJ33oqS+DpAoNw==@kvack.org
X-Gm-Message-State: AOJu0Ywa/G9G2fmnue/M4ldqy+Mn3QsdKqYIrqQUzaRTTy7qkjB3Rxz+
	pdJX0mm5gdPvtbva9Fs8ZA/7fq2gN1BJYBPER1SsieUPDIc4Y8iPTjh2
X-Gm-Gg: Acq92OFJdtwkgVGzVYMFX7ph4zlQIjTwTuI12uJgNWLnyiavtLVcK7uEtYvrLSC1ZAl
	x2t0XDf5jCb/Aeg5qKn5o5iilel6Un3J4UIIBrGHZTYaLIbho09pf1wt3jCMEn80mbSArGUqv9o
	sQIZW95pG0yFzYHTlVOvTCU/BsfttJ02gMbOenR7iLfSG9J0rR97SM6t+gKc1Jb7Lz63ujs3r/e
	xT3jyZpPtyXl6C/9RpJg+CSxgAtjKMyGnmi1HDjmCQ90rFCzrbZ5T6LJMNOiVOYyi9bnWeQlYTO
	9fyUe7EKrS9UjVCO/JHPOYCPmO4HoUKJoytZh3Ki5/W8M66aRj6JR4t8JGBUmuABH9uGu9eSVcm
	SYrO7JL8S+t9j8vWLANoq7E/JIThruum2ZessjRkx2ol2fqgOWSmAuw2DIOuSS4uNBtYL4zcdsQ
	3btYQafyVSpsh9AoN1sYqBD9/+27ftfNnnAfU3r/Af
X-Received: by 2002:a5d:55cb:0:b0:43d:dd:8ca4 with SMTP id ffacd0b85a97d-460218f1283mr6820154f8f.14.1780533967626;
        Wed, 03 Jun 2026 17:46:07 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4601f2dcde3sm13029996f8f.1.2026.06.03.17.46.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 17:46:05 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: safinaskar@gmail.com
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	hch@infradead.org,
	jack@suse.cz,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Thu,  4 Jun 2026 03:45:59 +0300
Message-ID: <20260604004559.1112474-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260531010107.1953702-1-safinaskar@gmail.com>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7916F40008
X-Stat-Signature: y3s9u5bi84t9ghbzdq44py46nx937r95
X-HE-Tag: 1780533969-534811
X-HE-Meta: U2FsdGVkX1+nI1BwVIp1wMbGtbvpXij60588aDwRhLeFg8bo4a0i2Lwt1pjntKPqGPB0H/eKcITcao0UA7hB7Iif2WDP1MAiMQLcHU07eKzf0/Qg5ftmIi/tXePBdol+3DEp9VDJTeXtd4E/490ZhsnfaIUwfGroyb3iAEFUh4e54raeozgKR5jwQaiEWwMqiX4XyQJ9LLilERZZC1my8BJjTr/doNjJxDuAGNs4G968XQ6L92kdaRe9XVmHQtfJ0cdaRmzgmBwM32k2ljaaOAqrU+FCvGU7NwmFNYtEJ9vOOyP2sqahLA52jNLPUP3cMgBle48HXbF/M03I+A/l+034uOwlIWIi0icIeuV2rCX+ipAX9WbZ6eF+d9PoRf1jTM10z69g5UjjJfX5eWAqZd8sB3/LW660gHtXBvPJyt0OMMjz8pJ0jGZvfhTTa7yY3DoKpAZ7Ursfv1uluMASy3pFbutqELAFV+4+euXH4lPWfPbgaqx7yRrozSRvmlbjdEmyZeu8MpowFuurG+fAloRQlGRgw8Y27yvr0739LhOcX+PiiyPEN/a3KqOqt2Cncy6AzplObfq9If+ofHiGli/3lDlNj6kQnMY3QCQi0xXgrapGOMdD+WuJenSM/OnkxkgAZZTbrsS/deHgdeChqTxNeYIcJkwCcGQCuf5HunL8wpKAyRB1OdN5zkZWOT2pMLbHuK2VSuYRE01KAgUShOUD9Uq/7w+g63IiOriWulR9E5Vq0FlPBbNVO4GPilrCEosw+256kIemLZ2fdFe6xOlv3G7gJn6nzdMG5s0NqA7fwuDBVucVRoOTS3XwwCPAsHeC+ZVTjCZzhsLh5pRzvQSPx4+ideuZBudM/BDIB+buFjQkPBueraRCmsdRXsIwHZ4QOi36BtraaWlKmFyQ/IhVqFjxjUfhJGnLs/K+xv12i3DRc6PdL2qCnhHIFcJ/2CBJBnSDohzRb1Ae0Cl
 FMy9Oi3y
 iBDRwP3oZWSqH/eEAlu+PiIPB7TGVcY8GzUEUtuod5lMzU9JOKJGIG6SbU9RUMyLYl5cmhyBQazQMLbdkVuVT1a+h/4yg9oL3fHa8YQuGTh4YJwoU3IEzOs3YKoAxr0fGVTmqWLFlk50nheuEaLt9bangPr41eE5CJcrx0YE/9H3z6SPEhvQiLYy4xBL/gbfGvjQ+1KDIGTTPUAdO5jRq7MifR3llwM5ffaCjq6bjtlevpBCVy/oUNXRS0FTzyBjZWx0zM1ID4Kfq2z255FObbSYQZoiHq6zEOrgs6SJnNCM7SgZVeY/36Iu1imoh5tg79r6pC2doitpILnmGYSOBMi7HufOvIa1Hh4bVAnhPVz8LcxqwofOCB8U+8aVZxd4xZ2pfPAcdbC+C/chInoC49wEZYZDvoDsLSSx+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Askar Safin <safinaskar@gmail.com>:
> For all these reasons I propose to make vmsplice a simple wrapper for
> preadv2/pwritev2.

This patchset is already in next, but I still kindly ask people to
carefully review it. I'm still a new contributor, and I can make mistakes.

For example, in vmsplice I do "CLASS(fd, f)(fd)" and then I pass
"fd" (i. e. integer) to "do_writev/do_readv". I don't know whether
this is okay to do so.

-- 
Askar Safin

