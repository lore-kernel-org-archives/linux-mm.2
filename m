Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E10C5606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=rxmtt7fQ
Received: by kanga.kvack.org (Postfix)
	id CFB5F6B05BE; Tue, 27 Oct 2026 03:35:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD2286B05EC; Tue, 27 Oct 2026 03:35:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0ECD6B05ED; Tue, 27 Oct 2026 03:35:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9996E6B05BE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:35:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 140F91209A7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:35:24 +0000 (UTC)
X-FDA: 85367595768.19.46BB71C
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 565101A0006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:35:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=rxmtt7fQ;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf19.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.46 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793086522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/YRCUcykH2kxr7zY9j/CVMJiW+kRaXQLZ0+Ryrw32iA=;
	b=DS6tbb2pH7KC0+1nOKs1mH5xoYdYUuvFa7VyfKzMeB1RlxpvnANAteQHR3u+12R6mlIe5t
	D66GbYTam0CAo7u9UWsKmwiLV4g0UDcbbv2g+tHA7mb4iEg4+cGjuqVbLZnXBMEbtdB59J
	+8Klwdyk1NnodRMGuji8XyRhI/DuA/c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=rxmtt7fQ;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf19.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.46 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793086522;
	b=zyk+mi7hMm7unRBSf9mPbunYLHUedRF72wDVJ5bKeNWOk4EMnqiuaxjZZrLsJo4v3OqN19
	4R+AfLPdCYa6h5SCv9IZ/Tpl6NMJ5tooehNgucCCWDBBePIj39jo29xvqSJp4iztset2EH
	13+MnopP2WPC1GsF9veOZq4aSnmID2g=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3ae0852df46so530151a91.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793086521; x=1793691321; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/YRCUcykH2kxr7zY9j/CVMJiW+kRaXQLZ0+Ryrw32iA=;
        b=rxmtt7fQFMCbA/VIlcEhwuSubDTPVDx/I20libMnnbNqXVFmjQA6PNhE+ub9wQzzYd
         bkP+s5U63CkWO6g4E/5XZsxCxj3db/OaeSXAVgmnLEY+jp5JsxzUIZEl3d5ns5VHm+k7
         asB+IZ6wpDRwoLbujTdpP5w+WrhJa+0OpCn6o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793086521; x=1793691321;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/YRCUcykH2kxr7zY9j/CVMJiW+kRaXQLZ0+Ryrw32iA=;
        b=T0Iz7jDxa+LmxylB+1OmxKdILuS3pg1p9BbltqgxDoyfveSlSkYfBLA5Zs/0l/SjlD
         uqFAoBiRKq543uwim9FVZ5QCfGUrc4mD+2qcFzx/HUsM3cgCh8rPgmjXHFw8J0ghaxRj
         Jvz/o0DohUEKYgJK7+R4m/Z+6KWrsyDQcG7XOdpsQenMIhbPp2k5wKcTEG8RWtKPSqaM
         Iz8wy8be5d4miVuoGJaFsJPAWF64SOHnLffz02q6iVc/3UB+L0VfBuHzruNUj4/xEirg
         A6kOzzBD7YdNOxCz/W4wJJnRss4qUUX7wdFLQWIVvYddPvBTng2uyvV0S74OkJbehlYz
         FKfg==
X-Forwarded-Encrypted: i=1; AKwUvBw0wrdS/MYD+CjDQsTlZ1q37QEhF6oxlssQT7418e3uK08EQtuduA/vCOlX8p59xtU6Sz6e2eF2mw==@kvack.org
X-Gm-Message-State: AFq9FYLmpH3KPHD20/mPvIgMG0U+ohc7XJsjK7ePhm6XPMG1ZS/y4gY6
	0Khb2wdTb0tSMW1W2wRpeVMHUlCEQAqFnP7vQPanIlA4VVMooHg5P81CYGcgKLjqYQY=
X-Gm-Gg: AYBFou3icDuoO0WiM41NfwZdRPLK5C3vviNGfgJJzDp5sVSbqSVGwHH4CV94/RiPh9j
	Z0TYgBENfRKCpLJyruUgdVHLr+KepcYzE6enhCenRYZ20yjxPb555Y4F8gZVXB8N3Z9RGsv/KOP
	AiGSiOskJ47neKWJmUpOi5S6NDaL2y/e8tk0O1FrPhkLRm2osahZtU2+FxtzRDJJWiG/K7ONVzU
	16Z489M7eQa7lVVV9hUEB41CwH+O89DeMo1VWPHffYbs+GnM/cBVwTk4AxxKuA2FwrsTzBk4cud
	h8vZw9RNub4FLfMKc1PbzdZzwW3pJ4g3yrkyfMOSmMUvi6EfZjibrkymNeyTE4IYL7XfTqzq+ZE
	Vjp5QpLG5C/8laOfk2XoNWWXw3N+HBwxc3Pqf9MPVIebYwj4LmT7ewJ9uQrWiAXY7wHv/t3Nr7s
	cgrwwCZavlN1NjzEdrCKz6yQ7kDVeduK+m9s0NT+gjVeyNa06wldy1jh+UI+o/YJSn27UN6z3AE
	Oj9Hp1FWACPQHLjF2jQA8mbFaR1+47+ay5dlEfZIrguJmipI7fdKi93a1VRUHjmbDvj/ohk1I4G
	F7vAHYQBD6ebZdVqzOmFCiove0/lY5U2+zoUoPZvgsWoXLNmyaKLnyU8R/OVBO6DyUkIMQ8OoxM
	29qfrrCbqtCw2vCoqtIIGgGRJlx5qYilRdV0geh+pvldXAQ==
X-Received: by 2002:a17:90b:35c4:b0:3ad:7f4d:2839 with SMTP id 98e67ed59e1d1-3ae402840cbmr752308a91.14.1793086521251;
        Tue, 27 Oct 2026 00:35:21 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae404429a8sm2527473a91.8.2026.10.27.00.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 00:35:20 -0700 (PDT)
Date: Tue, 27 Oct 2026 15:35:16 +0800
From: Chris Down <chris@chrisdown.name>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH 0/8] mm/slab: Support selecting slab hardening features at
 boot
Message-ID: <cover.1793086056.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Queue-Id: 565101A0006
X-Stat-Signature: f3ymmq9oe3xxjkr5d54sh1aix8w1kdtw
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793086522-818186
X-HE-Meta: U2FsdGVkX1+VBDH1CyfU+7BRdsaqIa1wgsj0nDOinpvJ/1Bnaxs4W3CKmMScg98iAktXC/vSDCB8HvqwW+G/IfUsfd8Dd/yb633f3PafFMF4qPH/t4q9h32vZ8Glxq6ZCj4tL8vDEx39L3TDYjG7uCcDu8GJjhY+NJCEQFZof2KRb5EsD+7V2YmJLw05qotKSA5JbjBPjEEBjrxegaN0hGqnXvW9YuINqrlNSaAxf3j//bmROX9dIWvVZRxMN7ykEDOGEo5PoG16MV1+ORM2qaHGTSC9x+pj+yAP8sVrBVgnsnCXeST1O+m7hsK8nqU2F8k01c8AjCNMkyGnGP9iF5Lt8awzju9ZgHJZvwlUkpNwq0jkOjyioqjp2BsngZ8yLKbtkuR8Tl93db19NawkdaxDtrJX3iiKCdrL6JQhIgK/pcbRlXqLOcDeeMKM12gEEPkJr9k2iUhQ/uw0ukt7k4rD8PVHaW49AY1c4NdMx5ptsCxXXhFvapGFx0I4S68oxuCmJEESzWMscJXOHA4w0jgivJc9sLyERGOiSS8mYSiAvzI9n2oCknh24bfOk2bNI6W890QZnHj8v4L2YZype2uYSAFt31QZZVjs5oGnTtrDtQR3UjC3vhMxcsf8/FsNJHOqgkFpW8gc6Ml67kq6VEMmhaDveh4I/OLfodFWSnFgvJrhPDhtLGTVGjNXdNlzFCbE9GZs9NmQ7uZQlcn8wb5hueGDXz6hXwq4myPH0A5N1cHxNPjjbI83PNTxokFdz1gvGVN4OEjqu4e4/x64mLAjEFYtwCK4iFpD2Oha5LasvWRD6zSgqaOI/Sxb/aZ0NLHIf64odHJ1UH+xPLsbBePoCLO5bXzFVtv/JjFwRKPMcooErTwwu0Eaa5EsgvO1kIF+vRxeqVFtJChflSzOQJQfm11x7UuGgmEMp4MdGcGLbRCGho3cPagpImWJ8lxlSwOp4vUuB8D/v6NTjb0
 2Exu2wVH
 Mc3uSqRgjf0JkJ15iea2/OaAap52jzSDFweOEozIWV13OqjvaDc1/kze2I0doYw8IgvMMhDm20eBsTQat8jxxwW2VgT8qExkRa2YP0trMhSAFFHTJl627f79mb7TgdfgOn2D96D2zNiUhP2rTXozx4vt6QlxB/+mepi4Z8EQYfrrZt4VlVOe3rmwfCn6B/qTZDsd2ks+CCbOINuQkfn8P7Faz4lq8eLWL6BV72hujJ5wi/zCSLwIslAPRm8o7U+sxkFbDJeEOveSUctUHp9wlX0BADqYvHnN55q+rGb5yw+7+rxMA/8EWQkHYr8Qk3X+ua8S8VODcZ7q98cOMsNZg8k/s+Nno8Bg2lx18pwqYBriSHNYM4E6WYo2Hwq0YtSlptn6snhN07ICSsSzUkY3pXvqC5UOG5My2oj8QPN+cGWu7JaqNWSQXlkq+QGG3u8svPTEMhic1RDGvbhLXkYvtNUxfjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Slab hardening settings are currently all build time choices. This means
that, unfortunately, hosts with different requirements end up needing
separate kernel images. Let's allow those hosts to use one image and
select each policy at boot instead.

This series adds four new boot parameters that default to their values
from CONFIG_*:

  slab_freelist_hardened=
  slab_freelist_random=
  slab_buckets=
  kmalloc_partition=

These mostly act at cache initialisation time. For free list hardening we
use a static key settled before the first free pointer is written.

Chris Down (8):
  mm/slub: Support disabling freelist hardening at boot
  slub_kunit: Add a test for slab_freelist_hardened=
  mm/slub: Support disabling freelist randomisation at boot
  slub_kunit: Add a test for slab_freelist_random=
  mm/slab: Support disabling SLAB_BUCKETS at boot
  slub_kunit: Add a test for the slab_buckets boot parameter
  mm/slab: Support disabling KMALLOC_PARTITION_CACHES at boot
  slub_kunit: Add a test for the kmalloc_partition boot parameter

 .../admin-guide/kernel-parameters.txt         |  29 +++
 lib/tests/slub_kunit.c                        | 186 ++++++++++++++++++
 mm/Kconfig                                    |  15 ++
 mm/slab.h                                     |  24 +++
 mm/slab_common.c                              |  48 ++++-
 mm/slub.c                                     |  68 ++++++-
 scripts/gdb/linux/slab.py                     |   8 +-
 7 files changed, 361 insertions(+), 17 deletions(-)


base-commit: d15d7703166daf7bd62c844a3cb1b3a6279adb4c
-- 
2.54.0


