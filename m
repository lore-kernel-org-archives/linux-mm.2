Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B4CDC61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 03:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D38F6B008C; Thu,  3 Sep 2026 23:27:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 583FE6B0092; Thu,  3 Sep 2026 23:27:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A516B0095; Thu,  3 Sep 2026 23:27:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 293E86B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:27:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD1AB1A0700
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:27:57 +0000 (UTC)
X-FDA: 85174645794.04.7FBD173
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 313AF40005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:27:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PdGiT0Cu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788492476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Al5KAJP8giS62+UxiXi5MDDZS7SoEmI6X+dEZIGc0fg=;
	b=nuILpSN57vY4V1m7INYlp78HQAhq/Td31zNGvsxIJ9arwqOLZempdg7zmY2+ihzRLVSj4l
	QALV0yv0kRcby9SQDxi2uwz0SNNbSIZujxiaCNeDf9wF7isq6ydw/tY+0vayOJlDfYtrxk
	QKnHkY9o/b18AnEyb6tx1VY/JRw429s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PdGiT0Cu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788492476;
	b=G7+tlQQS16093j1pNrYktUK6M3LygopSQVj5AG1GAJ7l5eCEj2yWsOJQLteVAwzXFOzXUV
	6fG/euC5Se3AQk8Y1OzBeGPbxst2N+ucKoa1nQ1QIjXNgcBlfkeKcDurb+Sxr2IFZqP7hx
	ZxavkzNyXmbx4OCtJbNTKJhxyJWvtgI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE11260A62;
	Fri,  4 Sep 2026 03:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E5B1F00A3D;
	Fri,  4 Sep 2026 03:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788492474;
	bh=Al5KAJP8giS62+UxiXi5MDDZS7SoEmI6X+dEZIGc0fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PdGiT0CuPwQbG7gpnwF2wu669kC1UAzW8GO4geRORQE0qSbP4ixBfL0PHSiQCsGRn
	 ZIVRqTqDeINniv6qDdu1ce5ZHYAbn53uHjcWWbqrsFieDgIyxyliRaSY9PM0F0t6+o
	 qCtD+9qN4iV+el0CYwQbFjuhTSMKeEZWzORDeQydnniS9d4oQfCnwl6mcBiERmb3W+
	 mhUr4sACuzrGSuAp9qJavKJuWoVhFuZJr/FhsdOlmUbhqnHAsTtnMJrWSP943NpM0L
	 JXRaHqQIVrgTCoxODhGEHuNbnXs1ZR8tlaqbKxYmiw/G5C4T4LH7uLwed+rz32prBu
	 azyrNI47fDITA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
Cc: axelrasmussen@google.com,
	baohua@kernel.org,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	xueyuan.chen21@gmail.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com
Subject: Re: [PATCH v3 6/7] mm/mglru: move folios from oldest gen to second-oldest gen from head to tail
Date: Fri,  4 Sep 2026 11:27:48 +0800
Message-Id: <20260904032748.210-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <129ecc53-f96e-4a5d-a79c-c05293d815d3@linux.alibaba.com>
References: <129ecc53-f96e-4a5d-a79c-c05293d815d3@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k4nouoi5kdcexowcm4x7rnuig3xq4mz6
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 313AF40005
X-Rspam-User: 
X-HE-Tag: 1788492476-375658
X-HE-Meta: U2FsdGVkX18QazL14jjmCA9+ycCmX5vA6eEuK3wblHHdNUG8Ei2klbzLXwF90Hn9K33MTR4ePvlW51h8vapl6JZOy33djuiZVIj6jY5N982dtgV68BQ5Xp9t1+nrM0X01r4LA6uF9qBO6q8scx8QozJRBIM4Ze53H/zZryaD+dgmkOiO80W1rPpIZM6U+EtAYqdUdIJG/8hd/NjfbTw3Q3Ck3ggiQeOMzQD3jCCRZveVa8KY+9USS42dXWGPili8gDBBFF2SoKuh4kP7oDIf5rTlN+Y5qREGnU/YwXmonVGsWoxzP3QczLySWvsxZYB/0Fh8OOkehNDel142C299mU4T4REe7AvuefVgqM+NRfshnkvCF5dJVdNbmxTEImqfu2A9Ju+iYMtBJPOzROSdBQugKz85zFyusKxptZMbmjF2/anxeMp0jXayXlJOHcPdqh0292DgAkepOxk8Cw+IojCHB0Sh86nmXLR5ZHQukWRnIgMcEKOVada15D10raBB5FPdQAoCgTLy+YwSsxt37KHtEb5e+hneyWCoRQ7Y2H6RG+5+vf6pKoSgR/Sd99nDpNRuTCO9k8jZi6B7Biri7G2RJB0aCLhlfRyTx6oIkL2t55QTkYGA/Yd5BLa7wSNGuHlQ2AvwrIWY55Oqpc9JsqpZDYixn1Q6Kpio1WnwAxQIXO+TOzVlohyOw5+uDQIxxIKuouzNtOTqyBLSL1OYIpNeyiiCWHFN1vqVt9xsde+Kpucno9vhwCc0fw5KpMI+/44Vu/A46Jzt6cDS9+NDowHIaHU7wWe3i+17Fv1YYl3yZ0nAYZlhPSoH4pQsLbmJpvVA+3Q3/nt3lI+45zhgOYcitEeuWSbIreStXEx6j1sB7yIXfml3dDZ9uO4mxsiDgb6GrVIZ+zPlFQMbbRgOXla9chVqf/h9G2bMREtoLVqLbbS+rx6GcMX7/BTp5eAovMOCfsGvuFdf7VDnH10
 NhVoWBKK
 akF/EpLBOyHvdQwkULZU+gesOqN4ImWRGYrveWz0Qge63rOEv/eEabn2eEwZDOy8mRULMlHP3fwCWkV/NbUDnc/EjU8M+ywOohnwxJbbr0qCBeyIZP6PO7RvfEg7qg03nfOsYNvxugiEFeFt3aaOA7gU+JUppJu/iN0Udltl0xBlLj2Oy0mRaNzXDPA74fh7ISLtlsuWrE2Pq8W9Q/xf4g30K+COzAFpV11yawstJ3jaXbk1RbWS5Dwd+AQNgg6VpyxQk8rhSBBsn1ykvfVRwBMDQSGnzkv5iGFod1QXgFWnWP+mV3H3+njdTGQDYzRc9g+2R7ozMG5hCE5Mv80UY5DTMhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 4, 2026 at 10:47 AM Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
[...]
>
> Could you add this info to the commit message? (IIUC, someone tried to
> remove the prefetch in MM, since they found that prefetch doesn't seem
> to help much on modern CPUs.)

Sure. I guess we could ask Andrew for his kind help in adding the
following to the Changelog of this patch.

Hi Andrew,

Could you please update the changelog and add the description below
at the end? Hopefully, this would be easier for you than handling a
new version. If you would prefer a new version instead, please let
me know.


The impact of the added prefetching might be arch-dependent. Some
architectures could benefit more from prefetching, while others
might see little to no impact. In my x86 test, it shows a very
slight improvement:


***** no-prefetch:

agetest:
...
gen 100:    2.421 ms
gen 101:    2.424 ms
gen 102:    2.420 ms
gen 103:    2.413 ms

Total:   248.418 ms
Average: 2.460 ms

agetest:
...
gen 100:    2.393 ms
gen 101:    2.396 ms
gen 102:    2.395 ms
gen 103:    2.392 ms

Total:   245.627 ms
Average: 2.432 ms

agetest:
...
gen 100:    2.433 ms
gen 101:    2.427 ms
gen 102:    2.432 ms
gen 103:    2.450 ms

Total:   249.186 ms
Average: 2.467 ms

**** has-prefetch:

agetest:
....
gen 100:    2.314 ms
gen 101:    2.310 ms
gen 102:    2.321 ms
gen 103:    2.303 ms

Total:   237.619 ms
Average: 2.353 ms

agetest:
gen 100:    2.342 ms
gen 101:    2.343 ms
gen 102:    2.339 ms
gen 103:    2.335 ms

Total:   239.929 ms
Average: 2.376 ms

agetest:

gen 100:    2.344 ms
gen 101:    2.347 ms
gen 102:    2.352 ms
gen 103:    2.348 ms

Total:   241.188 ms
Average: 2.388 ms

Basically, it’s 2.3xx vs. 2.4xx, lower is better.

