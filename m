Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B68A8CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 17:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0140E6B0005; Fri,  1 May 2026 13:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2E516B008A; Fri,  1 May 2026 13:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6BB96B008C; Fri,  1 May 2026 13:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8AB66B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:31:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 79C2A1401DC
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:31:26 +0000 (UTC)
X-FDA: 84719542572.17.9154350
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 857C54000D
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:31:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PoGYFM+G;
	spf=pass (imf04.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777656684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p8iyhANYh3zo/R/pXDjlB+lRBTZSZ++xkutbnUsPG3Y=;
	b=mnl8S/KeMazUxSpdOH7ghfULVOAX1ILX95yKu2kO6XkgTJ+b7dEIJXoqDPEQ1IzRY48H5C
	7upokAOfXQezMc4wPEO4xceelA/k+ciUpBwxXxz5GC+5VjZjb/MMBtF2bkJlbNXRtIn+6+
	0Es8seRmoL7uxwwHOG0mzD2WpBfGcaE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PoGYFM+G;
	spf=pass (imf04.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777656684; a=rsa-sha256;
	cv=none;
	b=6YZAaSr1OtqsPVy2yAqOG7JDZQSnYNzoWyOaS5lQ3bb6kYSnNNy+sA8sXJ23m6y/AKMIAf
	bO7SSXMxcM3Eho7/MiL90u4euDr53vn5qJU3vhAC28W+rAc9+SN84jtNI8uh/FsJwaqjpo
	6uN05CU8JE7xkLdWoG09lJSnr087H6U=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ad9516a653so10760715ad.0
        for <linux-mm@kvack.org>; Fri, 01 May 2026 10:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777656683; x=1778261483; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p8iyhANYh3zo/R/pXDjlB+lRBTZSZ++xkutbnUsPG3Y=;
        b=PoGYFM+GshA0AmVlKUT5+u5qucyIPAiS+3medq+bFGhWXo0oA8v/wxEhFnfoa4+Jj3
         cByvFu/mKjZEf5BhCRMJhLXNjIy7pt8bypkiSeSJ09MMV03CXbiTrgwBKgZ+7541FQR8
         xHluFW72o89b0AvoOmkLNk1hmqRfnZUIJ7JlBlWZb8YM53rTr8UdEIyhBiy7ywuuKgj1
         aHnb7gZjyHZRwZwwHGjOoVG/kezoxfUkcP0avEF4U2GY7az4ub01h5s/mfGofHm5sXuC
         ZnzTZXPXri/W5Da3ffDjmazSOes5ZQOQwZP8nBGFpO59OGk0uiEtJArg0fmmlhGsoRz0
         wNDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777656683; x=1778261483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p8iyhANYh3zo/R/pXDjlB+lRBTZSZ++xkutbnUsPG3Y=;
        b=LweA4YiCYTkaZvBLX/k9amj3nOE4RdjpNDZjzgbQNJgO/ehF5IYlqmJL550Sc+shhA
         U+WV9ieDoTSXIvxmeS3R7q3mVltOE34vyEpf1++PK7VlAIpZrHsIpfwGyual2w8ZCrYC
         jBwB5h6vtuimaTqQeGOVuGUp8V8sV8aSYx4HAgSHjfk2TGVcbPs6WQNKwaZYbi7Cg6FQ
         Kbs9CaasqzVR5xWvfg13KwRd1+Vp9IwW2YxdwCMWCR6APTeD9A6/OeK4xOg3a0O9tRyI
         ax8GHYgn49bIHS7b0B+r7b3iKaaBC8Q/LpzvNDHujfI8p9yg/Ih7Pg9A46GgJWy9oMrh
         3S3Q==
X-Forwarded-Encrypted: i=1; AFNElJ/CKUGLUG9rt0ZckP4+IO01b8ypPGfpQiOst7dMZ8vLlKjZuITxogMUGju0/kPPk92Yw9foVY0/FQ==@kvack.org
X-Gm-Message-State: AOJu0YziQfJotNxQl16p5QsjehM7T62J6dm2dAwDyVFYERkZkU/nn/rA
	flcvYwcF9dpsAWDBxQuB/EdnpESG9G9LoEp5HPD/TZcLsaZbMTNmf40K4m0MMyyXKoc=
X-Gm-Gg: AeBDietgEYPfmYbFSiBYxW0sTFpeGtWZhMdva6u03WxDVco1dRNCi9iS9Gm2S8Mt1a4
	hQJ2V33jB+0NBjLjTCWt9sJnan/tFYgTU5eofJhoMExCSxEbprvKwP4niyEmrUuLgz8Ge6bQXcw
	Ap3Z+AlX74zqqrc0Y91WAz9y+N1VPmVx7GjZVcAX3nIORmjfQCUUPq7THZgkNeQ7hL90N4rYsqZ
	BD1+GhYUrtgWXnHV6q4r+OhNVV/yJZI4TD3qp300Fx0X6aqg9bxXNwKPmAOK/MLhcSBfZH2AO6D
	zsJD63TwYToxEXhp7C82dNIqJRTWgW6MZL5Ss2maaotLtzXft3vw+H5LZV02Gv+7HqE370bu8dG
	b47nHz6voVm4Xw/ygB/jmjHOeOMr/8NdL22Lzo2MmLkdKAWdHiQnfGo7pHnI/DMAmsbOdnpDEsO
	jdPK/2Rb2qY5WdPjVuFgokK1NMQt/Mg+hwTEXbPA==
X-Received: by 2002:a17:903:1815:b0:2b2:539b:d2b1 with SMTP id d9443c01a7336-2b9f257c9a4mr1034795ad.16.1777656683049;
        Fri, 01 May 2026 10:31:23 -0700 (PDT)
Received: from laptop ([2001:4455:8025:be00:15cc:43cd:8af9:5a8e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caad2459sm27094895ad.33.2026.05.01.10.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 10:31:22 -0700 (PDT)
From: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] liveupdate: validate restored LUO metadata
Date: Sat,  2 May 2026 01:30:48 +0800
Message-ID: <20260501173053.73116-1-crisjacobmaamor@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
References: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 857C54000D
X-Stat-Signature: wf639y9tuf9udfs9dmaj9qscz4c8pzz7
X-HE-Tag: 1777656684-73125
X-HE-Meta: U2FsdGVkX19HCxPX299pwcA+slzF6LnUZJ7De/IjCf6jQzTKY1Y4w8ifRWHbUD5DE6621U/eplgvsXppK7NDvSPhyjoEoBAkN5WGL4j1Go0jhsu7S3gOtKGvXnn40oCrmeU/Vre49rW0HriS/psIU5UUgZ5D3gzbqHJq3nm8OrZ1JSGVw63Kh6rT/5DV9qxz24Wmjo5tCJBlgiBQES5RLzIk5w6lM5EmTidGTZhYCAochEqIhx0hIixcXVinQ7YQWn4FoNTCZHar5tEBYlK/IA1CGiCtCctWOeQKibaLzRtfRfNTavOUyXJNtPJS09MN+wQwW6GRIHSunjWh/CU9xhQy4IEfsy6YXE3JD08e/5aUgimE/OfuZdsr4x/5onenFgxJdQU20Oeh38QqOp5C/jT5LyQzEyu2E8kF7tpwswGxDInyYewe2EkrvNcfGIMP057uznrHnOGqsuGN659YxG2alCqeUE8q7RfvseylyS2DVZRxqkeYVwodfByP50HXf4QqH4BLHXkuTqYoNsEcCN4JvRGqAbi87kknrw/zCWprfQ/nhD2Gl/XNtzXbwlHdncTRPinUDtHmjgb6wEcFWOcsUXy4MJ6n/L6WLpvj1YzVtoSQZKlLQdbhVVWc5LV4TMhTd27xY03PhpFhhttMiLSE4glNP4Vsyc5R8p3mcOoEVasZMQzthh1mLuaks206vSzmMUAHn/lIg1+AaJAR8HSWz5zVgrTH1iFHWMnRpdawKv5wySPd6i4Pcd8jB3oV3POYGHaCWU2pet8uJcBBSBfSK8FnknDgPb6dNi2tM64eH8eZNy0+jbs0Ls38L3SsWToZFxOAGV+oaoaNB5wh2yw+kudkGnsFC/81P543qL4RJlcPRt9XFUz7lF4sbm+NOl85Z/js/lhF2l67qVbQq50RSeZJXgJe4EU8OT8kdGwPUFRnsLOIA6PglRJ3gD1vn3WLIxbjf2Ih1XCetCE
 VTmp2ioM
 4EAoJh23O/ndK36p3j2EIHap4siHELom4ZlrP93Y4a2qi14dpG4kKDbhOskJG3TiVdz9gigUZZr855uFQdxtR8WkYMYFEPnmLymMx16GnukMK+F7/hpFMRCdVL4tGBAAUvoo1jGIUTX8ZOjq0jbbUtc3HjUP1ldObsTWtRL0zImkf0W/tE2XF7ciYFbXnM1V11t/jDzul3cXj6C8V5hwlrYx6JVenNcFJIhgXUsg9n/hSyVvD0v7H2C5apnBNfqsRKo8urmee0XBXXHD0ZqDCApEfs/juUHBT97ugnJ6eLe+tvd1zH0HkCcI/P0T9XqPy9LCqL00FdHz+pd4KC0NfKJsTpLA4BkpSy8bE5CaRug0Q0IgN4RCEC40MJDwKWE+EcPG42+UVu150AY4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

LUO restores metadata from KHO/FDT during liveupdate. The restored
metadata contains physical addresses and count fields used to access and
walk preserved session, file set, and FLB arrays.

This series adds a non-consuming KHO preserved-range check and uses it
before phys_to_virt() on restored metadata addresses. It also rejects
restored counts above LUO_SESSION_MAX, LUO_FILE_MAX, and LUO_FLB_MAX
before traversal.

As far as I can tell, this is root/admin-only; I do not have evidence
that a normal unprivileged user can trigger it directly.

Changes since v1:
- Dropped RFC marking.
- Added changelog text to each patch.
- No code changes.

Cris Jacob Maamor (5):
  kexec: handover: add helper to check preserved page ranges
  liveupdate: validate LUO FDT physical address before mapping
  liveupdate: validate restored LUO session metadata
  liveupdate: validate restored LUO file set metadata
  liveupdate: validate restored LUO FLB metadata

 include/linux/kexec_handover.h     |  6 +++++
 kernel/liveupdate/kexec_handover.c | 35 ++++++++++++++++++++++++++++++
 kernel/liveupdate/luo_core.c       | 10 ++++++++-
 kernel/liveupdate/luo_file.c       | 14 ++++++++++--
 kernel/liveupdate/luo_flb.c        | 23 +++++++++++++++++++-
 kernel/liveupdate/luo_session.c    | 22 +++++++++++++++++--
 6 files changed, 104 insertions(+), 6 deletions(-)

-- 
2.53.0


