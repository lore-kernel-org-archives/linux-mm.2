Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA135C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75B3490007C; Wed, 13 Aug 2025 09:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70B00900044; Wed, 13 Aug 2025 09:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9F690007C; Wed, 13 Aug 2025 09:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD7C900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:49:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C1A011739C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:49:30 +0000 (UTC)
X-FDA: 83771866500.23.3E10F2C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id CC671A0007
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:49:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RQpLU5gK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755092968; a=rsa-sha256;
	cv=none;
	b=0Ixy9evFVI71OvZSqe0WHG6wa44g4TQAoFHMhkv9hNIVpS2P+kC37dnrbIQWzBXI4yDWSE
	WCO7fMbLgR5p0fCtXB7DJo9RSd0lwHeR4z/HFlVt7nzkEM7yf6UPo4slD6Nuf6VtZfn8YY
	G1IJfJ9B/Y6aFCgptUFpZUm84V9bl0M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RQpLU5gK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755092968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ngX7KqakvaHrr7jdbnboB1CiS7jx0blLv4FZ9WlGS6Y=;
	b=PMmkOPs0nE4lGds5JlcxCmhZFzKTFbIoE1fifHC+1Vayl6IN4xGEo50eTBkubnkG9fAIDa
	OSYXPcUihUNIihsJJz+zW80odZQO3rQyMZK/1PZP3/EoaKO20byhXum9s+bufxUlXP/zet
	duRUJ4okbNSyaVbJwJPJqofSmD1nBDo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755092968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ngX7KqakvaHrr7jdbnboB1CiS7jx0blLv4FZ9WlGS6Y=;
	b=RQpLU5gKqAQmlPqTTWU06eTp7WVhLv3Vnl4g51hLES5izZjnBGAH2eCxdM8ZL0khQVKRt1
	AtfNiUcgpOHAwHnSg38LDq8hjUbBN87OQHr+qJ2IWlQq3jmeXfIs/mICKHioPYJ3Ch5MUX
	cP83/PuVPFzdNG3hDphW/vCyaYsQxvU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-85-7Vo1U-J3ONyy5NFUj1oonA-1; Wed,
 13 Aug 2025 09:49:25 -0400
X-MC-Unique: 7Vo1U-J3ONyy5NFUj1oonA-1
X-Mimecast-MFC-AGG-ID: 7Vo1U-J3ONyy5NFUj1oonA_1755092957
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2ACA2195609F;
	Wed, 13 Aug 2025 13:49:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.21])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1AE64300145D;
	Wed, 13 Aug 2025 13:49:08 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <aJwj4dQ3b599qKHn@codewreck.org>
References: <aJwj4dQ3b599qKHn@codewreck.org> <20250811-iot_iter_folio-v1-1-d9c223adf93c@codewreck.org> <202508120250.Eooq2ydr-lkp@intel.com> <20250813051633.GA3895812@ax162>
To: Dominique Martinet <asmadeus@codewreck.org>,
    Christian Brauner <brauner@kernel.org>
Cc: dhowells@redhat.com, Nathan Chancellor <nathan@kernel.org>,
    kernel test robot <lkp@intel.com>,
    Dominique Martinet via B4 Relay <devnull+asmadeus.codewreck.org@kernel.org>,
    "Matthew Wilcox (Oracle)" <willy@infradead.org>,
    Alexander Viro <viro@zeniv.linux.org.uk>,
    Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev,
    oe-kbuild-all@lists.linux.dev,
    Linux Memory Management List <linux-mm@kvack.org>,
    Maximilian Bosch <maximilian@mbosch.me>, Ryan Lahfa <ryan@lahfa.xyz>,
    Christian Theune <ct@flyingcircus.io>,
    Arnout Engelen <arnout@bzzt.net>, linux-kernel@vger.kernel.org,
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
    stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iov_iter: iterate_folioq: fix handling of offset >= folio size
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <758962.1755092947.1@warthog.procyon.org.uk>
Date: Wed, 13 Aug 2025 14:49:07 +0100
Message-ID: <758963.1755092947@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Stat-Signature: ayu4hnqsabfwukcnojj7bum7wuifx4rm
X-Rspam-User: 
X-Rspamd-Queue-Id: CC671A0007
X-Rspamd-Server: rspam02
X-HE-Tag: 1755092968-93199
X-HE-Meta: U2FsdGVkX1+S2ZqinqqnICWltMNdD4gtScccJJnCRde4UHe4tVbxlc0ZuCf8NHae91SB/vlnohO6qtzsgdYbDEdTn6ZiH5ctjR995mkdary/lyL8H/1d5RHacv16zGSUxvWReHWI6bJ50KHcHN/e/SaKk5DDy303cQAFZsbS3KSG6ovwoMcczw/NFoSkjhujhJ94iiYytz1xyJ4vZqFpMYnbY/OEzrEtXaU5wugvadI0biRfnqPhBGp+kdFHr0XhZ1y6+3fP0nV6fcp/yf4LEFg5FsMxwMz6x1xEX2Z0hWPlaqDswPcHqcMzLYwYSJFL4ErOIqkeVdAhbI6tydRhLHiG+FtGknA3pAyOJd5owQNvspjZKH7nGldoi18K8n0cYWvyZoayWgAr8V2L9qDXZ5HsFG/q/pwxe+fb3EfrvA+C7YNl60/AEPwMSr+Vcr7tWEWoV/W6c3LPhCy0dEpemYbDkHAUeM6jjqUc4s09Nj+O8wk929WCbF+6Zh5exqw8i+A9/tdxMwxTibOws+LnOk/kbxg2eYb9Jpy1IywWioCR7PHajI7LLSCIk7JViowd6d4k5CUvjmie3hETiXEaFKGjC1OuE+srav/IwivBQrUpYu2LpIgfMGvY5Ny+TbljsKWAmIJFFjZ30CzsA/eFUrU8YrgktOodtl+QFi8qkvP6MqycsI/rEbc4yXBMzQv5hpeh2Ysxp+HrlAhc4syE/6Hm9Ldl0nNIkIkMSS+ltCMGcdmE37lmGiTzljQ6pCCCaiMT778/q0nnO1QZ568gY2WVdGOBWD30/PClX1/UTmC5b8JV8a089VL0hRpkcfb1WaGWkqJqQ3BqSfezlKFOldqQupKzECwLU+LmYS8RX8F/wSRre8nqMlsbRuXGn1b5UETuK0WXOWNG9rzX0CH+0gr2CgNtoUi7xQonIih9PU1AZ8jDHqqvOWXGGo+J3quGj3+LXier9eayh/uBDg+
 m7mtHBSw
 7ouCoNslSKMIhg/GgqdSrmtWXRNK73UlAe0F6QjCM3qLzu6BLtExfgAlExEAcrHM/OyrRtu515lezwVmf1lTeUN6A4XvSTGFPBHHFxfnV+r9CfmZoVuon+/BX7BUr76yt2lsda4BRX+2tZRp/RD6tkncKan4PI8MA851v2rwa53gQOeSEEzjilejt9WWsXcTbX8zyL1ASL33U6t/goF82IVNa0ViGsT+7/lrvrTpomS2CfpsGcdnc7QLwktWLLGgK2WMS6zf67odDaeSCcFUOraSYu67RdqBaGnKQmccyphLfZ++b/5vlXs717QQDkFYd7m0QAAuj+HMCReX+KKrXXA9/XLUzptVVE+JPuk3s+kxQyTM6oB56qEIIs177lSJbMiBMJ3l7TSjsabcYAzKlVbBsBVsB1QLEz08bKJYggHB9c4hGQ6/u1gceKfTGmnRvvKy8PpFW9vWOxikp/aEkSrewcdFEUKekNVJPIg3CgbD8S8BfvsJP91aLdg53i1jOdLjVoy9+rr/7lIusCRpwxhsaVq0kdhZHaGD1ab8WqRAuhrU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dominique Martinet <asmadeus@codewreck.org> wrote:

> I assume Andrew will pick it up eventually?

These might be more a Christian/VFS thing.

David


