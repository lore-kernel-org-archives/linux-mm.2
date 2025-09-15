Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F239DCAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 20:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3D6C8E0003; Mon, 15 Sep 2025 16:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC938E0001; Mon, 15 Sep 2025 16:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 901E88E0003; Mon, 15 Sep 2025 16:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E1548E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:09:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 133C3BAE53
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:09:25 +0000 (UTC)
X-FDA: 83892574290.20.F702028
Received: from mail-yx1-f73.google.com (mail-yx1-f73.google.com [74.125.224.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id 47F6940004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:09:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ItIai1Ww;
	spf=pass (imf01.hostedemail.com: domain of 3cnLIaAYKCMU352pymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--surenb.bounces.google.com designates 74.125.224.73 as permitted sender) smtp.mailfrom=3cnLIaAYKCMU352pymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757966963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fmQFBQOU3sbSfIW0gfUABdqH2f/LLX/ec2YX0nMZUmA=;
	b=JtbkfdBFUtBdXjPq3hS8bFLEe70SkDXZxfJB743Hgp9k7eDJMil810jmsIMJJhxeX+OG0T
	xq8TrImpzolHx6/3UtqQpF8eByXtfZG97YCNwWg9D4h6bvDRHTRXLCT3b5jGQtMWNQEk7r
	QBKTB0RI4cRx7idMS19u+Vdk/RFr5A8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757966963; a=rsa-sha256;
	cv=none;
	b=NZUQKJVoGIQAM5V6heVZCaOTWDxgAjDX2B/1l0f9m+Ewk/6XrS06GmcACL/aKN94ea9BQo
	5SDu0AGs9OiPDHVf0dYHJILNG58/T2U993uhlrGN0MckTxdghbMoBhOPXX2AvEoSJLGTNK
	ZtQyoguy+bWu7VhQuliWG0S1yvKpas0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ItIai1Ww;
	spf=pass (imf01.hostedemail.com: domain of 3cnLIaAYKCMU352pymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--surenb.bounces.google.com designates 74.125.224.73 as permitted sender) smtp.mailfrom=3cnLIaAYKCMU352pymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yx1-f73.google.com with SMTP id 956f58d0204a3-60fb0c64421so4134228d50.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757966962; x=1758571762; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fmQFBQOU3sbSfIW0gfUABdqH2f/LLX/ec2YX0nMZUmA=;
        b=ItIai1Wwqmsi1uyuUgDo64y3e5kqIzrt6J38Vsw1PRQ0JRD/QLIEGLfNX+w9UzQxGy
         DFJpyttH7lH348r21FY7W59JDoaPdAKFPCn3ikEkX3RdvdTvVwl9QDvVbhceTjbBXyab
         2kiUMA+0laZjjcL0fxEiSld5pAlVsroT6dH+dk1RHeMTfCkWLhxK19SLypinFamS2ebb
         olsapbyX1T5LAWmQuubFUBMfLmC6oXR9azNA1D6Im4ySn022ZKnxBf0w5mCAEt6rjIje
         vEG9ySWl/5p26pjQZ094PV8r7FLIoUXweFdgPX1yUrclO5Lc3AL6wWZWlqpqcdTc3Xkh
         gBEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757966962; x=1758571762;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fmQFBQOU3sbSfIW0gfUABdqH2f/LLX/ec2YX0nMZUmA=;
        b=NPIyUnDbWIspGoUPC6/4TPsFFCV67hfHUT/4AVa0gUmcJ583AK21KhZlb9p2BH2/65
         r2b+avkhvqBB/k7jnCu+y8GTLniA9tkzBo+4l1407U6KFf3RQYW+t99IhsOb1Bcuw9Gs
         iYOFs5txKPclTxaVdNewvOWurBlOUwXgMg6SJ/f6XABeEZML2B+uUj3rFi7l9tATRtak
         8f9XjaROd5escudgrJB4HfVtEfmMxw38bjjWuq8CdIzMfbJ3Bc3CAOsBoUsl031h41dQ
         zzZ+uYLS6vdDdPNhSQOVQFuQV6J+o/mvP3lvAKmdei5EE+0TIP0nyswc3K4U97hgRJhP
         H1Ig==
X-Forwarded-Encrypted: i=1; AJvYcCUA4m+RCs0EFpx2fN+Uwgn2ZhM7DDIFky79NpguvabYdnEgWO1i0de2VQuGbAXG/ghwGFEdvWaylA==@kvack.org
X-Gm-Message-State: AOJu0Ywwr388nAhOkjTFjvxm31wzsEcE6TeGcuIeIMwvLlqnpMjslPmN
	8m9gKY2lHqTXiDHtJtVVjSyz5ZVcSAMSfvcyRUhuSnNVsvndmyECj80EzCwTI6N0VexfgxhvxNf
	38yhEXQ==
X-Google-Smtp-Source: AGHT+IFfkDS+5yJa97rnpCK9X9oH9mDCgwcvJD7rMR+X3QCodaw6DtIogjSxErvfJVvIxP4SKHSMVtQ9WRc=
X-Received: from ywt8.prod.google.com ([2002:a05:690c:9a08:b0:723:ac0b:257f])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:690e:1246:b0:62d:cb07:f098
 with SMTP id 956f58d0204a3-62dcb07f103mr6632562d50.18.1757966962125; Mon, 15
 Sep 2025 13:09:22 -0700 (PDT)
Date: Mon, 15 Sep 2025 13:09:16 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915200918.3855580-1-surenb@google.com>
Subject: [PATCH 0/2] fixes for slab->obj_exts allocation failure handling
From: Suren Baghdasaryan <surenb@google.com>
To: vbabka@suse.cz
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, harry.yoo@oracle.com, shakeel.butt@linux.dev, 
	alexei.starovoitov@gmail.com, usamaarif642@gmail.com, 00107082@163.com, 
	souravpanda@google.com, kent.overstreet@linux.dev, surenb@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 5uyfxeidrmbok5pwbt68nqq6u7edzdwc
X-Rspam-User: 
X-Rspamd-Queue-Id: 47F6940004
X-Rspamd-Server: rspam10
X-HE-Tag: 1757966963-699506
X-HE-Meta: U2FsdGVkX1/zlVc0SesfPEwSQGUaSlKi3rc0sWgJm1LPcCsxt3gjzRG73g89cEHQufL4z/J5vyyYNCfBt1RPj4nR+tspZtDksqUYsVPJk2srecilSZ5GOwkTLL5D1dpQmbA2a8D2482KixNpt0yEAhywn7cF3VQd1DYoYKVMiOyXXgOu+N0TkGUeIGnKZ9B66RR4GSk/RClYeYCiwRFirIbauS2FQg9J537HRAk45glJIKEgJqKQYt53M+TeG2apRNMev9TJXsw1od+831rnnHgmBrERf5Q7xydRazoBjcEoiQumoXhGxSqP+EDm7l5g89If1Yh3+1yXJHnY4Ji3L8ESMdthSpu+12bSteUBzov7jc4e1nJEudEsg2Ntog2kJL1lJdWppWw4FwYVB8uZRQRoQbBqEvvTBSyVO5QDGQGzPTd5o6couCyJrKdAszWiFkpj3yySfpuBm8dnAfE/vCEzPGNOWJLiQkiWOh/YU+RE44xA+O9QIn0YmsWEAauVfj9clPIJsE4XeT1HH3smbV/FXwv6GrAr4xxgtB+VQBzvCGmt6y3IXxwomBnFGlUkQW8PYpNmWwWYieIOXP6Dv+sjzvkyTCz/Ju3oxf/bLGCHWsNGplBl7FbEshGPQUEK1hVYznxUrzS/zLqUmnF/n0+QEChhOlfsOYtr1y7p0fP17+VLDM0gr3nVt3ZbBkLpE/RD63GNTJvnjNO23aveWpGZ5KBmAyz5VTvajhz3xd7deLcWDNhFjHUSVIHPNuekTylcJwjU5/2kpkFdd2j0xJ+7ZSDQ5gJOFx/VdFwKfnT6jvF1mWKyg1CxT3ffyCh4Q0B8ELoq+gEVuBqdps7dddGGt5yKBu+/fd1hXC5dSADD9hSxi25btBHnvLFWyR66OqXvVA7jJTpVk8dAhxhBEzK/Gj7cym4HQSfp0LS0Z30Pbld3dcaO8SYolah6ippSb4Gmuv2uAZxteHSI8Ui
 nhNhR04s
 uTySBUWHcmT+cjY42Gp+JgQYnnweak0BZxaejsKIjSW50gqZY0U6ZT2Ivh0AS1ad8b6QlDsQb27qUXci0HUOvqoxTw01eLtooznPqMoyUdvEAua64SJCyIm8gQgQQ8asB+NmdIrAJJmvL2HqwrkM/t+X0trotu3Htwih/mOB3lEdPE1Ud3YnbsG0a1HnGIvA3yGPQM0GFicsno6K6ZkYeaF+hLb333438cO5qcvE8UuHj8zFg8unnCQsggJn9SPZf5pEBlTuFrZP3hRKjMTMAUH9heT7j9KqcKS+rXNckSYCwn3wAjjP4Ylg9ONe++1vgcV/TJA6CBJvDGJMkk79V23T8+XcOEz0slXuTJ2UGdIUQcG+IE9zlPPzobxEluo465nLI7iwNPVGij08X21o/GAQwvDhpNSk4srZ0uKl8FcZ38LH4uoTKOBsl70p9bkR8t9h1X8C89dyJh/90+3uhoQKNQuI2ctlanupnjGL7QjlmS2LKwRH8xGjhMnqyipx6cg2XnqkJP4govkUkI9CFBqUlmViydgV3qAUtTdETPsBZ9D4ruqOY3Je5dqlagK9eELN8MnClJmxO2yAbxpG7HQY+1HahpSFHxj+OMtS7XkxL/LJrGoN2gdvTlDF1/s3e0B0qxVW+X2VACJNkgQQZ+uBrNBjKltegbtSOqEpXxbw2oTA2+Dfm4OVrNRdLOYVzfEkF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fixes for several issues noticed by Shakeel pertaining to slab->obj_exts
allocation failure handling in [1].

Patchset is based on mm-new.

Please route it via vbabka/slab.git as it's relevant to Alexei's patches
in that branch.

[1] https://lore.kernel.org/all/jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5/

Suren Baghdasaryan (2):
  slab: prevent warnings when slab obj_exts vector allocation fails
  slab: mark slab->obj_exts allocation failures unconditionally

 mm/slab.h | 8 ++++++--
 mm/slub.c | 3 +--
 2 files changed, 7 insertions(+), 4 deletions(-)


base-commit: 9a9318f95d63805868bd21e1381d68c3a75d03a7
-- 
2.51.0.384.g4c02a37b29-goog


