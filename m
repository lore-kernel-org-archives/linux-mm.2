Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F23E7C5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 09:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75BE96B0362; Sat, 15 Aug 2026 05:18:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733E16B0363; Sat, 15 Aug 2026 05:18:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6493F6B0364; Sat, 15 Aug 2026 05:18:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9296B0362
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 05:18:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86E3F40336
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 09:18:33 +0000 (UTC)
X-FDA: 85102953306.29.FDE53BE
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id D01BE40003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 09:18:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LlD6OUxz;
	spf=pass (imf11.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786785511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LXZKFyuDLY2DRqrs+BqA4wglyce4j9tGUwHMwcrD9yQ=;
	b=MhppXJUBt41pgj2YGluzpjfIdtry9gZl97D/hjdbcYIXZ7XHaCnOTVbYOjS4jCnPsEvLlx
	A3Tl3Z24e64EquU45nMsNYGThyeQBMTTdETdmntBS9S59MXVdURQmv969eVgZwJJFX6E/l
	DX9Qsobf+pXt2YZvFZNRoTDfLmO18SQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LlD6OUxz;
	spf=pass (imf11.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786785511;
	b=aTotd7rlg53yH70TqqXwDgj2MlI/JKHjUX1JxFMYbh1BtKQE5v66WMU4F7U58yxqBCYveB
	hnAWxN7hDUQfwtuElhzGpsoyYH04u28QBvYcnTTHSf55z7gZRHpRnEkkQXi2tN17YV5UNg
	3aF9kpp+ZTa3UWmr3N8RrZjKEIZb0So=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84faf87d19dso1871744b3a.3
        for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786785511; x=1787390311; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LXZKFyuDLY2DRqrs+BqA4wglyce4j9tGUwHMwcrD9yQ=;
        b=LlD6OUxzi7Nnk03EUn3DfzRz8yhm5lvB+3OeaLAb8NT39Egu9H4KsZxuOk8CmUMwmT
         ixZv9fGOVSeqQxG/EzjczdCn/Q6yGlKDlO+v1uq8pz9xCcVd07DrN3ZLc/74UY7rW4Lh
         3PMqSmbCvjIYQQp55hjX/00rM4ZGLzo0T59PHeRL4FyZbXwwHimiCLmjEKxTjZ89jlkO
         FXngZAdcAIEC5LGuUNqRV92i9jF5MbkpZ+8tEnrWAEcW1aX9rPlCliNypdYvD8aTHGgh
         S4yVWTy4yiAsLzCy9HPiiksvzTMnXVirL+kiaCDCeS/cmjlYqpq+KEOzrEfLWh/NjvPt
         0OQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786785511; x=1787390311;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LXZKFyuDLY2DRqrs+BqA4wglyce4j9tGUwHMwcrD9yQ=;
        b=Xgjc+paEVI6TID9yxqtSnh1e1TYzsYRuT8JcmpNnyp8kENLI6suEfD9b/pz1HU3TdU
         yI3zlSpWbxOHU8d8C5bxn4F/6S+Vc57oJYKEvV8kuzCt6fJgMWaz4MM84gAsh/Y9BagC
         8QAxb3SEWd7YCP2OzxjKIJe1x8Wnd8fs3b9yGKFSNqa293k5yc+KrIkLFC6l1rlmi1hS
         EqyRPBSr1SlQVMK+8MbGpepn640NCkMl5DLlFw4YqzPDTtNx2/0KXI7azFKN04OuERRv
         Fzjh5nWn41m/qVtvTTeZBrAx5c7djfYQWpkLpN2wTFqJsYufl5b9tA5j8a41oJX4tm1v
         UGrg==
X-Forwarded-Encrypted: i=1; AHgh+RpqiXTP+t4aeCzUB6JySA4kYdQQQD7KT3pT3sPjHDs3L+xaH1TQKZ0TheROunbBS2colwlVY/tOyQ==@kvack.org
X-Gm-Message-State: AOJu0YzgkTN6TvSHcrpUu7uLai9vy6pUrlTFwGRoi4UZjnn4iKArHfJB
	VKxO7NpNByuHEnwCn35spU7PNNcKOAsRmXBakqDEBhWdJBigzxrBoQlT
X-Gm-Gg: AR+sD12HGZhDFECjKWvCBV7s4nAGizk6teLWN4Krg7Y8k/gbLyQk3kKnsFxvPIvGkeu
	YI5JB3Uf+N1y7HUqBCJF2lcTnjmgG1FMYfZNYFBxelHCakNtjGlyjXA3YQ19XtPzxKPbcqOXH0e
	91DkhqJguaNofixwoabdVbHb+FxPctvsQ5NaVpugokD+DqwsAX9z6B51M4/XeXIhEJ8O3uhlGOZ
	bowFhRgtwol0Ym1J4XUlPzU+chAlvlCq3E+w2W1yGsrBGZgP6poYCjcDSZ/9A6fqda42dACfM00
	0vR/zBTGVCus87Uotlphjjq6X40aLhvJJUK3UWPWra7ixDB3lsd7vV+/hhVa5YevVhTakdyG4LE
	yzB30DzAqIqWcEiqKOnCi6Js8eD3C3D7z3YfkfcvJpmNuuXbRdbJMktVOvYVNep9MEQfllhYBWJ
	TExRq8dFFlT+I3kBizOe8Q00Wz+IROsarEV7pKifmzfXY0YEpJ1h6galAG3Y8foQxA+QSlFxvOl
	WOYfpz2+3BuI+280ku/cbAl/6E7
X-Received: by 2002:a05:6a00:3d88:b0:851:8084:133a with SMTP id d2e1a72fcca58-8518084471emr6698912b3a.29.1786785510477;
        Sat, 15 Aug 2026 02:18:30 -0700 (PDT)
Received: from bj-kjy-standalone-gaoxiang17.mioffice.cn ([43.224.245.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8517d223f1bsm1274934b3a.38.2026.08.15.02.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 02:18:28 -0700 (PDT)
From: Xiang Gao <gxxa03070307@gmail.com>
X-Google-Original-From: Xiang Gao <gaoxiang17@xiaomi.com>
To: Andrii Nakryiko <andrii@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	yinchuang1@xiaomi.com,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Gao <gaoxiang17@xiaomi.com>
Subject: [RFC] bpf: account ring buffer backing pages separately from Lost RAM
Date: Sat, 15 Aug 2026 17:18:19 +0800
Message-Id: <20260815091819.3651099-1-gaoxiang17@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D01BE40003
X-Stat-Signature: bceru1zm8prwqgggq6ji5tb91dt8ufu1
X-Rspam-User: 
X-HE-Tag: 1786785511-839027
X-HE-Meta: U2FsdGVkX19e1+FcXoKP0OoeL3ERTbSm9b/131C8AMbnJ9HmAD7V1hvcn51Y+IQ7s1dZ3iXlQn0dgUSfjNrOozmf7vPQKx7IPWvgdQyJM6lxfe4t/gg2nAkI/LxRb0n2TTVKZ18JP9M4CeNZF5imWH8VyWH5ieZ6vpWHnYNPmXbdvMe7X/aq45CrtyTVpu2IB/TlSyJcnagJ9qbN72D0JE/T/t1qJMlHOOPVf8E4do0XtTWZiPSD2Q5pxISDbpI2grAok/c+xsMmUdgtzlJczhtB/QtmR23ualkjOCRQC5l89LnNMeL8jdQkkUxdmBEaSHzaQEQVk85s3jxOIAr7iiYcFruiED9ibjG+JXvWQ2z0VX3EP9ngHOpf7JZd0lYRZAhvwyNzEOqlimmuYjSb+jWh51NXF9ZpABE8FhsJXrMyFh8mTCZVfzn3OtefRLCVvZq3nU2HctScgYx5yDFa3fPNaTjaYKIrMWBAVCOzj/0j3SH1C+OQDO+Sg4XMkrlso+lE9Lfiig4TaQcmG8xlIes0j5Rf8Cugqx/f01ijvZtx7+ocH/ttnvUCT5LvR5Qkojv7Hvcqa/oF+fEbez3aYkJe29C57X1SDmjnHkf9sjW8TsFAFTeQK7R5qGzBN1C+vPSOL8rH0D1FfekSdnGE8AUKcEVYdyF2ltI9c1fOJbmvAP7NRnSnVvsYi4SSmWN1bpc5RtDfMllvo2ix+pDhu6w987h2Z/wgggADUMH5V0HLz/4hTQ2//I6QoDfJwWtK+RoNuBraZS+xcGb8wswgLvaqQ9Zu6yHkDsia7KbPQTxyNlHmydbdezrEiGRopn7ct4CPoIj1CsEFV1lnbLtZQO7x84NwD5yzXLUSphJV7DHP2K0Aw1ijrV7KmeB6yFUvLgu2DyeGyIAtuspEvmUYr7gFl+UhteW5J9dFgk6LH/yiDaWdl2gvBJNl4MTFNQ1mGr9GREEZV1ZsmTXWYs2
 9jPeh/QV
 OZZufA6gDoNQ1O5KId0KylHLptU1hFHOLDvtgY1kvAb6ckTw7m108mYQlSaBH640oJG6tE/GqL3S1CeEIbAdGVHeqVa5FMcwniLZyBtGH3rcBdGfIP1l1QnxTO9KY34KU/nmT/3XJAblsq8J6NHbj0eY3oXzyS99IvqkNVoOacMeRkwhXBYftek+IWQSDrT5AsX6ZzsVPLKBxFJoNbEI9STo+RMGQRtaALeAWf6ySoz+whTp9zR0od9Fi3toKFbu2706jkDtg7vFKq/LukDsPXhemnhwdShDd3eCq5yYyQ1crQRzVdo7QyjCipnsssbUGS/Bi4r69MwVIN1iD+Ih0OicqqufwKMnjMwhH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I would like to discuss accounting BPF ring buffer backing pages in
system-wide memory reports.

BPF ring buffers allocate their data and metadata as order-0 pages directly
from the buddy allocator, and then map those pages with vmap().

Because vmap() maps caller-owned pages, these backing pages are not counted
by VmallocUsed. They are also not slab pages. As a result, most BPF ring
buffer memory is not represented by an existing named /proc/meminfo category
and appears as Lost RAM in Android memory reports.

We measured this on an Android 6.18 kernel.

Test case:

  32 BPF ring buffer maps
  16 MiB data area per map
  512 MiB total data area

Observed changes:

  Lost RAM:       approximately +529 MiB
  VmallocUsed:      approximately +2 MiB
  Slab:        approximately unchanged

After destroying all maps, the values returned close to baseline.

The question is whether the kernel should expose the unique physical backing
pages of live BPF ring buffers through a dedicated global counter and a
/proc/meminfo entry, for example:

  BpfRingbuf: <value in kB>

The proposed counter would include:

  * ring buffer data pages;
  * metadata pages;
  * consumer and producer position pages.

It would exclude:

  * the second virtual mapping of data pages;
  * the pages[] pointer array;
  * map metadata allocations;
  * vmap page tables.

The goal is to account for the currently unclassified direct backing pages.
Slab- and vmalloc-backed auxiliary allocations are already represented by
existing memory categories and should not be counted again.

A possible implementation is an NR_BPF_RINGBUF vmstat counter maintained by
the ring buffer allocation and free paths, with the aggregate exposed through
/proc/meminfo.

Questions:

1. Is a dedicated BPF ring buffer counter appropriate?
2. Should this be represented as an NR_* vmstat counter?
3. Is /proc/meminfo an acceptable interface for this information?
4. Is counting only unique physical backing pages the correct accounting unit?

Thanks,

Xiang Gao

