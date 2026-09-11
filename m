Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 401CAC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 22:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 056BC6B0088; Fri, 11 Sep 2026 18:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02DE96B008C; Fri, 11 Sep 2026 18:14:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E868D6B0092; Fri, 11 Sep 2026 18:14:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA4F26B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:14:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4FF0916038E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 22:14:50 +0000 (UTC)
X-FDA: 85202887140.01.521651C
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9545F1C0006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 22:14:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eGTx+wRL;
	spf=pass (imf21.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789164888;
	b=I2JQ0QWXjjaQwAOM3j6iNcBXFiUXmPsmluEqTMRfKSy2y1nH1764WHCTK4GLz14CfHc3JJ
	GV3O+gvGMXD/2TbOQbzn9Im+/dk9bjepIjjTlUpqxEOXtM0gt4GyS+SDwt8DHGKfOEH3PX
	/VmbCMvkUcbJku6RUCKizrQ1kPM/ANU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eGTx+wRL;
	spf=pass (imf21.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789164888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=l+6FszybKpenSJZy2BI3hcOtPumB191OQOasiZknYb8=;
	b=cMX0WNWC3HRiRojsoeMt5RIHBjslXCD/peV3d/6a3FcRHTB0YD2NAQr18Qflb8vjxWteCH
	fxiiIG+wuCJQ87W8TivZ2sZAq2NWgGeOzgHNrmOFsu0vfScQylM8jmz9gbiNa7tR9o+owD
	5cYN/KHepnFdnPNTpMYjhpI+/q6TrUw=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38ec1402b05so1520890a91.2
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789164887; x=1789769687; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=l+6FszybKpenSJZy2BI3hcOtPumB191OQOasiZknYb8=;
        b=eGTx+wRLe8eGXXcSA79LYK/MF9kojdAyRfMqyrcaDfvSS9kJWQsm9uEIKM864vaiGy
         5Kc67UOeO2SG+FefoP/9ZGXHx0XfAv/iyohzrAmIxvDD3Kqlqw0uWTsc1enTKqM883oR
         /FMb0q5IlF9MQZrn5Yb6ptwMnaqiimg0GvDjkeuuny2C3Es9F5deYQzIi4Z+IEh2bqTY
         CHe7XjFAxEImOBvE4FTAfTDs/5NnC0vxUcj3EHn3CkY9TxqlNY14N0RTgKpCVoxIjACC
         SJ6xftk49LUH1kgETLiLY7ZHWJPxjhogvE/WuEcesEHr+c8MZdr5IL+1o9rqtEIbAWKV
         ljiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789164887; x=1789769687;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l+6FszybKpenSJZy2BI3hcOtPumB191OQOasiZknYb8=;
        b=cbNk0qy3zNWgqyu6It4OxasJt8yoeRAbRF2nGaN2Or3y0MJQRreGEEY7zM+3iLEMiq
         UqOLZOvFVsiFdH83xZbq6eWaR9CSTeqp034f4SGUz0ovWSzePEYdbRi3xP8GORUKJ6BS
         e61zCP/msAuTYCRMt4v/rFoVsNBX5EK2CIIv7mtcA5l/VRVqBz28srntoF4qt3EpJYo4
         NmJGHLfT7/F+1gjXnBfG7ZI4BAqvb73u9YDehKYRguk7dVvD5yoCLbJV0n2QOgBeiQp5
         n3qXlibIUJT7gUfEULqNYeZj2LfnJzGs/mtZi5HbBN+/sWAl9hfDFL1GK5aoRGBm+p0b
         pjjQ==
X-Forwarded-Encrypted: i=1; AKwUvBxp4NULmzTm3t/jSVmD3r1X55Rl8/nezmVmHQP6T2NbRp2PTTt1RhHSmechXA7o/x8PraDcscekAw==@kvack.org
X-Gm-Message-State: AFuF++k+rkArT9OrsNob2t+jBb5g8osAnlaMYLO+8PT1qTnx6BwwcXg7
	VSlnXF1OZPpZJIdmqaDWwkvS7ZhfALA3sQqkQCcbJlBmnrm0/LYA2wvB
X-Gm-Gg: AYBFou16U77EkH2+qlQLsUg6KiChEwyLf95H/6w0kC7cDXFnHdwkG1aDGC02++VUz9H
	3Bc1g92e1V53HQ0LSTa+Csyr6PL0EKY7FzflKL/B/HwbiTxZrgu2KgjwId2i2iEMn7ozTzBUqQO
	BWWNqwfZYZOpaO5bL6N67tu9MrwoYU293pHE626xXd6hkNYPELiviJ12juIVJYlUCee0wRlHJfE
	C51G8gF1CfDPyQ/zeI1PGDzPeiUDMItfd3h0Br8np/Sofjg6ZU1Bb6XBCa0+/ZMe5exKuKLJBsl
	hF8W27+TqGcXqMQLTrryUk6YSrNH/P0A5RF8St7outX3+jO9B020HEOLH7O47IIUKXTk3q69ABu
	V1+kyj/p94iNlA94+BSBzI74Htmrh/Fa172qw9VB4fYb5nFLU11DV2rhiQtw5G/CmNoovivI5eC
	JWor6CVwZyhjyw5Xbrb7OYW01j8BLj1tFg0KPW2zn3PDqBZxw6zjSTrEHCXc2aIyDsyl/qLy+Zs
	xiGWC4=
X-Received: by 2002:a17:90a:fc48:b0:39a:e983:d4bd with SMTP id 98e67ed59e1d1-39d9c3527b5mr9789091a91.24.1789164887357;
        Fri, 11 Sep 2026 15:14:47 -0700 (PDT)
Received: from localhost ([216.228.127.128])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4efc398sm10174839eec.19.2026.09.11.15.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 15:14:46 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
X-Google-Original-From: Yury Norov <ynorov@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	"Liam R. Howlett" <liam@infradead.org>
Cc: Yury Norov <ynorov@nvidia.com>,
	Chris Li <sparse@chrisli.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Yury Norov <yury.norov@gmail.com>,
	linux-sparse@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	maple-tree@lists.infradead.org
Subject: [PATCH 0/3] Catch automatic storage in IDA and Maple Tree definitions
Date: Fri, 11 Sep 2026 18:14:40 -0400
Message-ID: <20260911221444.1523311-1-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9545F1C0006
X-Rspam-User: 
X-Stat-Signature: 913mpd39mu7rn47e3d4js4cxzteko9zx
X-HE-Tag: 1789164888-257157
X-HE-Meta: U2FsdGVkX18Ot0FUxg7kAJ36K/C35jBQ3puxhEqLQ3bPK73SyNWvuHuwH4tErIUKAlqWujpE9/WwCKRmfnvH7ParuqGwn8uuXnl35TS8rcuSlRyCezVR3T8/xXQCZHuZ6mG33dF4l5nOD8LHlHnpM0iKw7tYzjwwc/SwUICPVm7DoCYAE4dhmj4bDkg/Jbhd//vTXxaqHY8UtCwMQIbhbWFA+wOIo9W3Me4k4k4dEl7OJc4wetqRIHx56SDBIbYgH9mWYp71mrzRIkSWIACvUaiZl0AJOpmWohgrZMMVCBQ8+XSB/YTsCKBVO0Yebsi0ddlzFsj5KzHrjMBdn7aXT853TfxMt4ueZU2Qd0Lwtv+RpVcqkUYwZFzzKxvUo0EBFLr0hf5vo8fv7sPcvBdfX4V8tfMHa+/vlnmIAZyf1/XpQ0ETsDyhlNqOeEFnUSNCsNxM78ljrW+SKwZw/myEZDLZtoA6VkQK+8H5i1BK2u74N//aM87h5fMezqP2leEya53rbHvwKMVxAUmEYCQQSJvRvW3DbYfFuJulj4AMbx1mpf/Fj41I9utyYmL+3j754wm9VlsZwX3O+BNdZHmLa95/n3BvwPtuAY9LVsrjMqBbIq02WzChTCOTRJrYVO6gvGJz/5OquSvL9+/iwIBbQBfb1OOJ1NrVlRwK67MusSg31VbRnNjKsKyHOyMojDm0ZjitDgHdjhoUNABWO0YUynv2le6QKm1LzPCc0n/JvWGsCTKilXqyesZ+WdZB8vyqqqYwLKemJePaeJ3yokiUsusg1X2uuKA5jkCiwDlvzO36oOHQK1oUrzQMLL4v9ISBUdQHpf06cwmJbwftSydWBfvWqIIks9xUPZFcFNKBrPqcdd731CTrSiXTYlL51ig0O6e5z2u4HiAwcSbl5JTEXuBvOsSAhd0cmEx7rEw05WtaKYl16UVwCc6c+IntgxdaZnYxLdbusqdjMJb8q1m
 XjriChSP
 rGeos9oblYj4nv2Dr5aFJa5TGdlEsIkqls2lidkowbfmof/4REimZXUV/RiNEW5d+WQ6D+8Z7O9m7FMiyJ//1vRT9kQmD+fWA0qhHmGBD3UHmzPhBkHzG/xPhkvTG1X/JxoVtbhz/SLj7MyJNp9Z8TL+mlXrj9eb5R/U2VXpUUusr2j5y+B/ZtlzhGCRas0m/N/pFQZtnJMsGNjLCUR+G6SgfJNbj7w+W+Ayy4Nh/piDDuIAYKP48rt6H5Czr3NlnwQsLDffMlWJGDmvdfJN1l7NnleCXQ1otJ4eFgoFkF55dgngOd1KJrlEp2P6FgLgHOIe0TM52PXC8B7XfFjqwyxN3WONXmaVlTSXckX/TiUNSI7C6OeFRLHXw8hxgzvc83/0aHXUPwec9lEBN+vyMFZ0iYX3gg4Fw+m099xOYXojFP1dy/giRQt3MnHgNAy4wX2Ds505zYEIhZp8l4kWwYWRJI55nO4KFiqns2htneAkm6aq4jSyHOvhzzHkIvvSzR+F48eLMmUrRDlagGqQ35PRr+z4eXF2axlyw9+XhcQVLlGURsVJRP8BLZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A 0day report [1] from the region allocation benchmark exposed a lockdep
initialization bug: a stack-local Maple Tree used MTREE_INIT(), whose
embedded lock has a static initializer. On the first allocation, lockdep
rejected the lock address as a non-static class key and disabled locking
validation. The IDA benchmark had the same issue, masked because it ran
after Maple Tree had already disabled lockdep.

The fix [2] switches the test to using mt_init_flags() and ida_init().
This series adds a compile-time check to the related DEFINE_IDA() and
DEFINE_MTREE() declaration macros to catch the same class of mistake
earlier.

Patch 1 introduces ASSERT_STATIC_STORAGE(). It declares an unused static
pointer initialized with the object's address, requiring that address to
be a valid static initializer. Patches 2 and 3 apply the helper to IDA and
Maple Tree definitions, respectively.

The helper is mirrored in the tools compiler header. The existing automatic
local IDAs and Maple Trees in the userspace radix-tree tests are converted
to runtime initialization. The interval-tree span test keeps its existing
mt_init_flags() call and uses a plain Maple Tree declaration.

For example, an automatic local definition:

  void example(void)
  {
          DEFINE_IDA(ida);
          ida_destroy(&ida);
  }

now produces:

  error: initializer element is not constant
  note: in expansion of macro 'ASSERT_STATIC_STORAGE'
  note: in expansion of macro 'DEFINE_IDA'

File-scope definitions and static local definitions remain valid.
Automatic local objects should use ida_init(), mt_init(), or
mt_init_flags().

The check is limited to declaration macros. Direct uses of IDA_INIT(),
MTREE_INIT(), and MTREE_INIT_EXT() remain unchanged. The helper cannot be
inserted directly into those initializer expressions because it expands
to a declaration.

Validated by GCC and Clang checks accepting static storage and rejecting
automatic storage The userspace IDR/IDA and Maple Tree test are passed
as well.

[1] https://download.01.org/0day-ci/archive/20260910/202609101106.771b567e-lkp@intel.com/
[2] https://lore.kernel.org/all/20260911155244.1406122-1-ynorov@nvidia.com/

Yury Norov (3):
  compiler.h: add ASSERT_STATIC_STORAGE()
  idr: assert static storage for DEFINE_IDA()
  maple_tree: assert static storage for DEFINE_MTREE()

 include/linux/compiler.h            |  5 +++++
 include/linux/idr.h                 |  5 ++++-
 include/linux/maple_tree.h          |  4 +++-
 lib/interval_tree_test.c            |  2 +-
 tools/include/linux/compiler.h      |  5 +++++
 tools/testing/radix-tree/idr-test.c | 20 +++++++++++++++-----
 tools/testing/radix-tree/maple.c    | 12 +++++++++---
 7 files changed, 42 insertions(+), 11 deletions(-)

-- 
2.53.0


