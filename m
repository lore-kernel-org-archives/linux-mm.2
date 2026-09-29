Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58802C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 14:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 473906B008A; Tue, 29 Sep 2026 10:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C686B008C; Tue, 29 Sep 2026 10:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38A146B0092; Tue, 29 Sep 2026 10:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E90F6B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:00:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9ADE9A04F2
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:00:16 +0000 (UTC)
X-FDA: 85266959232.11.4D6CE06
Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	by imf25.hostedemail.com (Postfix) with ESMTP id A0A9AA0007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:00:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Frfm6UAD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of med08elkadiri@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790690414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/srKavlgqYlrzFVROF7aG+7+UUAJd3JIGxu7I1XKtY=;
	b=xlec6+uxQdixMHS+Wf02TdX/QyAb1qXSg24SQwRHdDa2iEerQZOoFv+KuCInTQ916Bo/Jv
	Bbt7UpFTeHrC3czdP4IafQoimQy6z7Hv7URxddLhRtFlrSid0Q6pQR86/6/FT2GDlKAYHM
	9epO3wbbEqZCO2vmkLziOy1iBUYTieI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Frfm6UAD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of med08elkadiri@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790690414;
	b=LUAGJEfPxkbc/oJyMHBxLhK0b0ba3OmR3tgW2fSbvNOZMCEctKcESGRQivDNmLkxS5nNoe
	RGWAGN/caTlVYbtLy/LKgrCxJS2WMUW4MVVmBTwl8i3AeUJiwLESd5o/uv26cTTaih+P3G
	3RsjzrTYYnvwWNBfBYxoTvNAJCryL9Y=
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-4887f6cf16bso2662048f8f.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790690413; x=1791295213; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x/srKavlgqYlrzFVROF7aG+7+UUAJd3JIGxu7I1XKtY=;
        b=Frfm6UADjp+VfTe+wCxPbSx5msr8c90KH7Ox107MTTwkTHE9Ynsq2vrHFNUQrD5meO
         91L6vSMabps/+Ptt7Sek2dEJEBz/h51ZYzPz1t5eBA+aNE5Mak5bsohTvBVOfdi5g1tQ
         BIul2sDF1qoqxUyu29+H0zYFUjMmlBMrgQ1ic2hFnbrL2Loe+eF2ZpiPaAt2vk1UWNjL
         HXPSq0IkeBSzoxci+0ULppgmbKXwD8DCRDir8HwO+G3o1fHJd2rrIYTnRAqnlpJc/I7q
         WIzJt/OoJkBVJry4wEfuwCIH/uK99mWsRFCcT1G2OnoE3tPzy/ExtG25yAjo7lf7kXTG
         CsCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790690413; x=1791295213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=x/srKavlgqYlrzFVROF7aG+7+UUAJd3JIGxu7I1XKtY=;
        b=vmzSEIWZJPIxjesXfPs3uXXsZM1R4rmhwLhQlqg26mz9rSoFjuN7PV5Cc3q/Scvrn9
         eJIlilZFAJiqz+z28KhleypUvf/fL9ihYHKYsgYmqf5v8yds975KVPZObHpjddFswCOG
         UlwMZNkoo8YG0Te1pfp0QwZkGQAudwN3uDb/6BMoRVz8Twe2f4auwQlYKzJHBn284Dw9
         IGU1xAI5NSlQrTyo1q345AEwRd8MzfuLdOWqspsNxQb38Pbb8VrSGod1GEgSx8rQKgbs
         DZkaBf/H4/vHpDlFINWNjon8sae6AyTwMjw7WGko/5ZxacnsvJcANziJMvs4qb9keOQS
         GCFg==
X-Forwarded-Encrypted: i=1; AKwUvByeelmJggG9aiwCLOs0UyYzeieW96NO7b8rsCgId+gQpA0cubEet/oZsKOBIXdsC2JTb9EJfpc9Cw==@kvack.org
X-Gm-Message-State: AFuF++kmkO2TIJFi/d/uG2tzrSDcV5Uqeauo93p6ZkrMIfGVpsJc7BjN
	8le9Ez6Dx833wos8PjFYHQ24cGcU373ZyW6H/jGq/FyeomJFzYKhs1c=
X-Gm-Gg: AYBFou0GY9DVO0buKmlzbQ14T2+RoCn2YTKz+9FnzNqorjY8glFCEdfI6MU55Vum3UT
	CfbsZocsSiZyDeHdtjlRGhhPrbOViK8dWtlhlb7d0LjvZKhfQ4j7Ozw1HuRt92vyokitg4cpYQF
	/RqaD/tm3Cl57P3dlyHVZfDZpxJymTMjxL6do6Dc5wg/zKabzCYPAsiRK6T4QtMO/PdkRL9nWNr
	XGa0w+wPm8+fPWXuCqLb378L5FTGtaerzCnICRm3TqMFXCD/lA9JGijr9641DTXQyNLguGLbVtP
	20+jbB9pudIfFWFQRM13rQyQxi4P4Mvs0kmcy16HtTV21jQxk3IQ4oGH/5wCje2Agz14aB5EMZL
	pHdIiCIdAyNtuJJFfwjbXYsn9xXvbtloYavIwtIbRhCiIHrkPUt4Tqu/l3CKdRfvkeYzAeSrfE4
	nBQ5bD77uBDwr2AJNXzJkxgFm/LQ1m9UnFZ2/YFru+JzliOtUQ+qjGq0qdMkKcCpc029FDmlFur
	WvSkbfIbzRyubypBnTXc/BLFlxGS/Zwz/At8E1oBOd6jyHncQR4Ki1YraEM1eJ0NmItips76TCA
	xnJMha4=
X-Received: by 2002:a05:600c:4695:b0:49e:7d74:7b7a with SMTP id 5b1f17b1804b1-49ff06b2c70mr225355595e9.6.1790690412769;
        Tue, 29 Sep 2026 07:00:12 -0700 (PDT)
Received: from Ubuntu-2604-resolute-amd64-base ([2a01:4f8:13b:86d::2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a013cc0255sm7184465e9.1.2026.09.29.07.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 07:00:12 -0700 (PDT)
From: Mohammed EL Kadiri <med08elkadiri@gmail.com>
To: krisman@suse.de
Cc: amir73il@gmail.com,
	brauner@kernel.org,
	danielzgtg.opensource@gmail.com,
	hughd@google.com,
	jack@suse.cz,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-unionfs@vger.kernel.org,
	miklos@szeredi.hu,
	tytso@mit.edu
Subject: Re: [PATCH 1/4] shmem: Report casefold setting in mount options
Date: Tue, 29 Sep 2026 16:00:11 +0200
Message-ID: <20260929140011.211148-1-med08elkadiri@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928213155.2612039-2-krisman@suse.de>
References: <20260928213155.2612039-1-krisman@suse.de> <20260928213155.2612039-2-krisman@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nxw5s6kingp5gp4kata75cc8txg9bzxn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A0A9AA0007
X-HE-Tag: 1790690414-541876
X-HE-Meta: U2FsdGVkX1++ZveUh2Y7mdb8hniqwyKfV4iwPFrA25o8S6c/ftxBP5PnokkhkYkQEYeVwjOvfw/xjC2QKy1S0l2+y4K07HvItgWu0GOeeDO8t9SSOZju3JbUnFl3UYqDwAyP/6dx8LeP77NoHBJ8CINhT/6PwDVvUhFEtztThjXYz+SNQN2qA2HLFlRwLTca95FgcN11xEJSmQ9008P8H1/VzM+YifnzZ0FKOHEp077xGdPuxd4BrnVjhrdS6dNDaOIMvgU+BXx4NNO2RWjpqw5StRwD08Eb5OXESk6VCJnIdRW8HgqnC35YzPR0RU/ajg85r+p7roZ9vJPdiocQMNz7tybmN8KeDsh5z87HMXHa5VTFHm1Z0GF45Jncp0zgDfUw7mUp9BetPaUIfvtazldWtMHqql3vWtU3qYYCGF6auYVsFrVnGUHkK/ynEAXlP+2F21LQBA0yVtrE83AdesBGIsESc9FS0w/wsPW7l6qIuERXkeYvAoVCWx14Ul5EtquS4EyXVemSLmwFYDhzV3bo2wWzt5xlM182HuOMcB2rAkQemXxcK35wkTaagd35OCKDfJ09qX0kx/vxHM2dBt7D9TFBTGxPGAywwJjOPJK1immk/w0+86xvbmpdwMDJmSKLRYQVNxcEOIgwAK16uXDvvvRplJBArtj9sNA/u7lQrzd1tUdQovDENcePH5b2WQz4Lh2vc/ID9a2AuMDY00tRS4VfsV1+3NXbnmpBvHuoUq808StikUrusPEaOoUKKaHSgRWez4O0JJwwCGbGjVvbGvTQH43+YUGznynotg5t9MM2HWaDtbnB5LWUZp1JqxKUPgJq3B7gu9VUQ02p6lvvtkb4GEroW7KDdEp1v9MrdcGZzErlq8zF4RwybvGvbbQRcCQCBxyEX8gF8KZYGxT5WaCoDkNY5MfM0uX1Jezthr7iZ/oysudKTpmRvGTqrjBV3frq3DLU2L3KDJw
 hyI9UVFS
 zr5pXJKOmuP8y6j4uAuYe85GANLRYOu6jktMkkc8mqX/k1kJhQkwL9meAXYvaXf0ddxFBsA0pF+kRVvO/cUAaa1osFNvb8J1SGy0kkc2ZVFb57hob4QNGF/sPxYxI4nCAg7/dYfAbS16/8/v9v1JqMstRzyP3gdJZfWrcsmZ57tSnDppq/q75oxzn4Fr/RM0TvQeST+feW+ajRKL0PT5NnwPNZ4s2dD3SP4U4PVAssg4M7H+yRPIkVCczCkyMlD3OyHPGKpK4PBu8xA6swI8ONUf+SI7GXCK2+YxKMcezaPtOCxmsDzQ4bsNaluqZtGyR4bEYrM57/SwepSr03xhtUfwkQ5QcRXZx9lHojsTvoIcRjjjZ+Vuj9HO4EiH7QevIEwX5tmAFwCGlzapwLBDS/OpBbjxVShOMnPEOv+Owp5CBqnK5+60LKZwMbzM7jHa1oRikEvQ6mJzB2aNLhnFMDMo/PwcluaRW69X1XlSrjD5wlOeZq23mW7bJkPzVLMRaAie9/iTIjUKKWqtdFQD8XCzFX+6w8spsSaeNJcKHinoQFjmcPV3FgetsOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 05:31:52PM -0400, Gabriel Krisman Bertazi wrote:
> For shmem, casefolding is a mount option.  Report the current encoding
> and casefolding flags in /proc/mounts

This works for me, on 90ddfbd19636 (akpm/mm-unstable), x86_64,
CONFIG_UNICODE=y:

  # mount -t tmpfs -o casefold tmpfs /t
  # grep /t /proc/mounts
  tmpfs /t tmpfs rw,relatime,casefold=utf8-12.1.0 0 0

Tested-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>

Heads-up on one side effect, since mount(8) builds its remount options
from /proc/mounts: once casefold= is listed there, it gets passed back on
every remount.

  # mount -t tmpfs -o casefold tmpfs /t
  [  527.593309] tmpfs: Using encoding : utf8-12.1.0
  # mount -o remount,size=64M /t
  [  527.595716] tmpfs: Using encoding : utf8-12.1.0

That second line is shmem_parse_opt_casefold() running on a remount that
only asked to change size.  It calls utf8_load() each time, and nothing
frees the result - shmem_reconfigure() doesn't look at ctx->encoding and
shmem_free_fc() doesn't unload it.  50000 such remounts grew kmalloc-32 by
~50000 objects; a tmpfs without casefold stays flat.

The leak predates this patch - you can trigger it by passing casefold= on
a remount by hand - so I sent the fix as a separate patch:

https://lore.kernel.org/all/ba38f80f629fd093c77f3a49fdab7b71ee7bbc5f.1790687276.git.med08elkadiri@gmail.com/

