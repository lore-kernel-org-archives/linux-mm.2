Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31076CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 17:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 449266B0005; Mon,  8 Jun 2026 13:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F9AD6B0088; Mon,  8 Jun 2026 13:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E86D6B008A; Mon,  8 Jun 2026 13:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E4626B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:13:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0071C0A9A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:13:06 +0000 (UTC)
X-FDA: 84857390772.02.EDF3B96
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id C3462100009
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:13:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QxhEiiPv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780938784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUpt/EToVTToJvd7YASG+3OoKZxNxbXoqptfVbb/HeE=;
	b=b2kwidb5ONaP5oz+XWaWsKHWVe03bIRWj3rxFQAzp84HH07iynsf27Nb4VpDh89QAyR3ey
	leNp9OGMTFvjlIUhIP1AN678qNyKKl3k5bW/12YQfk3Axhguo8pN5LIiENKKum5rAgeWkw
	feh+8Guybu7X9S2E9a5iUdNi+ezQ9rM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QxhEiiPv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780938784;
	b=V6WXNuDSfe56YZmuH4lFImTLzeaqH1OdghMEQybwJxH5ExXDfPJrYLoC1+GlS0/KpEFbuO
	TUxfRziG/IG86ecWktkCSqDmXdHCnZDxtd6MpZYzojqSwlH5B6GeYIGTLjQkKzxWNkE8VL
	xA/qCoK6NIEQxQ/+jA1RMi1kNdCdBeM=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490cdae130cso8236125e9.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 10:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780938783; x=1781543583; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AUpt/EToVTToJvd7YASG+3OoKZxNxbXoqptfVbb/HeE=;
        b=QxhEiiPvl12cX3i7Fbn2iorhGVWn2lLLbO67DAAzV4uwyNJQzrzCif64pKgmACQR0t
         bBeyp7DQYTAo2W2+6FgE0KeSd4mlgtAYTZ/XiTcYsplIrhJ6rqdM1PJ84ijl+BEk7FMD
         hB87WhA5by3cY7ZaYxomXffons8Zz6oiHyu51mNy0U/uVLwt73I2Ws4WB5Z/MOqG2TGC
         ITTd4GxxO+hEH+3fqoZcuvSHvAHEcSHHTKwCjbrmMLCwxj6tDEj763E8mJyma81pgJvk
         bDO3ci3HLSjELK0ja5PZauUZ74NKkQ8XaDMrK+/Fsi/k+i4MnrQrV8+GUxZT0E4nzM1l
         AEuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780938783; x=1781543583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AUpt/EToVTToJvd7YASG+3OoKZxNxbXoqptfVbb/HeE=;
        b=gkLStbs2Pw9HV7PIijzE7B/175mR8S6ZMKiCeI6ac06tovsbMJt99ag8/B2YM9DMQF
         0l093VQ/yboARXgG4RUCJ830N1KX1QBa6n8y8zbKxJm2/a+ALzZIMkz1jqwT6L4TFS1y
         ZtBJJaVSGpMeTdKpiC+WjsC8hJVxg/J20vmMAzH+OCmthNfw73pwm/tieqjCWd2Hn8Iu
         zI144WYwuTkItELxXD1N6vv0qVCIdnE89zoDbdYvKKukyNdzajkiflCpRo6ZmkcP1Rq9
         7AN55KkqYP+HO/nz5Ty8Fo81vnVT4BZOpWwZLjaitY+pXAE4SXU5bvIADfLRDxmbLrOc
         2vNw==
X-Forwarded-Encrypted: i=1; AFNElJ8bhIdM6Y7U8tZ8UYe/Ii7/wCAj0CI0BHlerrtckd3CqUerPCTe1mIMOYVFuPOumu0/ySBjE1UIXQ==@kvack.org
X-Gm-Message-State: AOJu0YxlxYubZJ0Y+l7CqCR3GRAEREZS0e28Yl0i0CXh2Wa2gdICJQcJ
	zmMwuRPmf7woizToErtZD4+Gi3Z5JP0aYwK00f9d7GaEXuVKy4wWTBPD
X-Gm-Gg: Acq92OEZ989RuCj1lJzUsIpKJsczLn0tjRSNQRdShhTFvEzIpGeyqaGlegtASp4CYox
	e0ysLJVlKUxyEI6ceB93XS/hqmwLX9JzrmNKWtSwhLDW9Gtqhx+zouq1WUB/+cspCBAKMs8zsmf
	y3n1cNdf0gOCAymcRWBboAi0YjRRueMJ7dOdMqLOIoTpn1dCTokLzjcaH2qkdLUb+jj1EjS6n4t
	KgdWwDAcFSpEbs/PmHPKwYzQ7QSE0yOyUG6zefgDzcSsGtx43WA9a/lEzN52DKl+bU/iaNAMN1a
	wITB0gLqZ3+6Z2lnjif4E2DbMEePfhsaCdhxXpdp9y6uV7fpTbDUiExE8S+NFFlPL3nyae3WJ0e
	qkI9q0ZSahmMBnXtOjt9grvofZ5OIrGjqKZTiZTZ3IR+YJmZYmmYLFFxYe76hIbytCPGAlJ4c3T
	DnbvvBHSmBv7zk4bK4EnQW9MyoQFifrCtOaEw4MNQ7
X-Received: by 2002:a05:600c:458a:b0:490:389:7644 with SMTP id 5b1f17b1804b1-490c25fbd78mr244360025e9.17.1780938782731;
        Mon, 08 Jun 2026 10:13:02 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4601f351ac0sm97432933f8f.27.2026.06.08.10.12.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 10:13:02 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: andrea.cervesato@suse.com
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	collin.funk1@gmail.com,
	david.laight.linux@gmail.com,
	david@kernel.org,
	dhowells@redhat.com,
	fuse-devel@lists.linux.dev,
	hch@infradead.org,
	jack@suse.cz,
	joannelkoong@gmail.com,
	kernel@infinite-source.de,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ltp@lists.linux.it,
	luto@amacapital.net,
	metze@samba.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	w@1wt.eu,
	willy@infradead.org
Subject: Re: [LTP] [PATCH 0/5] vmsplice: fix some problems in my previous vmsplice patchset
Date: Mon,  8 Jun 2026 20:12:31 +0300
Message-ID: <20260608171231.1480447-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <6a26aa28.283787d8.1f1282.ba36@mx.google.com>
References: <6a26aa28.283787d8.1f1282.ba36@mx.google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: nqmpztpboewsrnxnczj6ad6ajfms7mpd
X-Rspamd-Queue-Id: C3462100009
X-HE-Tag: 1780938784-981718
X-HE-Meta: U2FsdGVkX1/fbJxxrQyLqNorcSoxxtsmOs1YILsYbDuoz278kxrbe4xYw0s+aW9Sb3iySLOs8ZeQh9Qk6i5qT/1D7Etlf0YkJFQEbFHu5wz3DuVMg35IIf3yy/lkppKgDK60ullen9Z/ocV8+3bK0TWKvyk3KwJeyHfyj21ow2G+AfzVdmr1S0Cp2KBlPr5iLTG9OuBsek0G5aWrRUjzK0+YZmiJWOxCJr0AnXoee1mV6QSx9gnpX8djtfZ6R0P0qXKLZH2Gx2zV0iGRgv38UHoG9RAhR3pdMMt98CalHfwRRNceKM1inmgHgb7s37BBD66iqYEtDiT2UgegHS7xqkilhFAkVRuuQht+W6pEoVeTA3itm6tBVSYcQnfFO+U3j1xNzCaEg49laeqZleg+CvrZgRX3/tRXlN/3C70sMXFrVCh/10AL7XQclRQgsFrCQd7tvdIre8Ln+4kAzBztZrILJ01h2EzpjNwGnShLy+gETugbctwTIZGZ1anc+ZPXMSUAtcm+z8OncKsklyuqpsa/RwILRqRiR1qwgMzvs2p79zAGX5EROz2+9NKpOPGtmLK2rf62qqwqmmZlatA+rO1lhnJxr+ftgfpfLKq442H4lKsEgXZ+gbqngFE7pxLZcwTDErQy2nWyMwcIjqw+Qah6DgI9hOKJRNw587Vx596xP58QI5+CfFQq5pSRIy1yLT1T10nHwiH1IpRt0b9bl+Z8dW+GmUf45BRFvrR5UnkhqGnKTbm8NjxhQU6QatH9clHTr8TcjWDyOQJatl3Q7jMOUxQXdmZDyXy37u/S1n5svzMJfXjI4wIJG+WxJEDxJTD8BEMTpkJmRsw9JWafHYwbcCIl2xq66yoAyPO9pVAwT35jFrzBizE6AFjWACuISXWZwQ1i7qopnuwyzxpQYOnzUy7WTzi900Ef5FPZ5Lor9Zjsm1/+dtA6l/w7n/u8QZQAIJ+9k5B+2hnO4rt
 22rEtEyf
 uWBrMrBQTCL05g9Wp8J3VR7HY6uDby3qYWmxZJIi1Y8+jc+v4pSEb5qT3KqzN8SmVnu4jaMyobD45rPr8jPFTE3zF6f5W5NY9oSaTk7/UZ5Thbn8D/D9bJpi/04wSeYRYgMLUeAJj/X5yo+hyv3TTfTVKg63jSawOWLlp2YL3mYL4pGrHEipmyIiCAjRsmqjXQfwu8MsyOJoI2g2oDSCfnXaJlF4dVK3PNFyFAg4PWelS5A2Z6rD9UXflgTHx5LEwGOxYE60Bk6VQXcUzFhzYJnNfbbo2Romcj9EbEpcMJBy1RxxSjyWS92zD+5TCxY2n7RRfYNOp7lCymgOEb0hgOlm06800m1PExE87WHwUEqI1vABzs3D51LK7IwBQMui5Ses7bKhhwGo+fEQE2JvcLB5Kx7vCWYMYSdFgzHtregli2lxhLYSwubvtxeWYPgskGzWxGj9ntErluIGUtDqSQw6oNX6vNdA5Gyljwxv7OvQd9yRwMoayqR5CIESC9KTsTTKrAUWqnoONQCSNUcw3PFczdBEBTReygZEAQwBXgTC1sds=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Andrea Cervesato" <andrea.cervesato@suse.com>:
> Hi Askar,
> 
> the patch-set doesn't apply:

This is patchset for Linux kernel.
(It is expected it will fix some failing LTP tests, among other things.)

-- 
Askar Safin

