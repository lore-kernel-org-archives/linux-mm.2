Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5433CA100B
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 06:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E257E8E0006; Wed,  3 Sep 2025 02:30:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD6318E0001; Wed,  3 Sep 2025 02:30:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D12D18E0006; Wed,  3 Sep 2025 02:30:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD48F8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 02:30:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 48E4913B0DB
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:30:28 +0000 (UTC)
X-FDA: 83846964936.12.E97C606
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id C5CB9180011
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:30:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r8L5J+Up;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756881026; a=rsa-sha256;
	cv=none;
	b=pEaQHw6d0oXk2kPAKIaw27qZqNFyv1AU0XEu0dsfq+gCt3OReTOZ/oJpM9qf1D7gV6pLwc
	S5dBEU93qtazuCD1ILCfmADKP+7yZIWFCpabM01Hdn4s6fcOKcKaK3mKyTxL+wWHeXElPw
	0SA6V7hoRbS1XPJpj5hm0GcOH/jVFEo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r8L5J+Up;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756881026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=x9VALCUu5PPY2af6wI6+9K/vJZQgbiXo+WV/pWMB534=;
	b=LVq3HkGr9VVVODETo4ZF3MQHIjHKmKXJmoptfLTWhQG1QOJzaakZFNrBCQyP1MHTqC4Lmn
	EOvdDgujj7JoOJZgyRiBxH5GQhDB6zRTEMU2GSFu5C+pgkITZpTeLMrFh44njFSewOZq4u
	EBwerI3M6PNakOdAeQkrPQT3HnDyMNE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CCC1660239;
	Wed,  3 Sep 2025 06:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FC5C4CEF0;
	Wed,  3 Sep 2025 06:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756881025;
	bh=0BP7MTU7WtClcd5jUvnxmjOIUJ5oBGFWJ9RXidmD/b0=;
	h=From:To:Cc:Subject:Date:From;
	b=r8L5J+UpwsZFc6vxvw/oeG2L7/kI3GOXOPF1wkLa53P0zXa/EWSrxgEzwd7YgKQE9
	 ydDjrfNusiUWQwYgKKVHO0PosNWMB/PZmMN9tLVni5+5hRx8udYAnSqB6SYqDNV4pd
	 /FfuvmrZuh9EtDb3aev9j3WRR/o2+RmZNeZKMA+S6uw4+BXkw2F961clb3kXyG/v4A
	 oF/fqFlwj7ciQc6VI2sP/soaMg/0ReJ4Ymze8kKhGy0nwNoECivEoI4pjBNmzw1cck
	 zQoKoyfddujrP8rjmcowiXA3gThpuJZskxVpkE3NEMVdEryDcPKcclpQ52m1PZKsE7
	 Ie5WO9SfESaBw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] kho: add support for preserving vmalloc allocations
Date: Wed,  3 Sep 2025 09:30:16 +0300
Message-ID: <20250903063018.3346652-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C5CB9180011
X-Stat-Signature: 9ymb187ph67nmymbphdk8qc6uaq3szsr
X-Rspam-User: 
X-HE-Tag: 1756881026-274592
X-HE-Meta: U2FsdGVkX18GviY+xnxFwYADCkgGquntT4Ke+GTUCQKcG66UwhX/s/Oi80yjccQO3aZtDS7j1wEoJCSU6rKZJ2IIlswYUz96rdBcJ/doy6LBdTftHrH11x2Uon0Bq/jNlu9yr8nc6LQQJKC9xoWAmp7UqL078Xz6R0S7BaXJIVxJ04UNoVqdt/MTpSQ591OmEEE3ZrAF+tsbw7h/v/A5NmnB0ERZTVK8tcPJNw92eOjN7y/R2az6pAh8blAR75J/vakCZqn4a+3Y85p4Gqmy996I5uvRET6KEPiTvTqRj6LUZfOU0bRyXt8BF/6x2Ybcp+H8udqRdH/M+9YDBLIGZTfZVCyWtn4pBZldbi6ODpi58j+C7lZEavgFp6srTzl081CKUkfsdAAQgFN/r1KNhbtzCBaB+106EK3XHZnQENCZw+/mu/+pAIIARo1WG9IeFGHV/QpH3yKeOZi+TK9xiuTUhaTLbBSZ3XIc06I4s0hUBfqbNhaN14hCpOC3YU1GEyWdv1VGZftlobT4LRfg46IcOYg9yS4dAJboGqRMMe3RlM7XUcAQoM4PBwVts1Q/vYtOD2a54xHPBzp5HCOo0u9qVZSjwUiKKcAMQMbUj+7FQQCwiRpp6qHLnny/w09FzB6u3UNszsb6mfI2c6+Ng7KL9im5ph3sUXRIFo9oQJSYrTDddLCfrER9Ohhbux0Q0Y5SvqBNzxk8Z81aixM9QhLbu1f30ovnpkkPzg24/TMgK5QQuMyN8L2JDlVQVeuDFc/9WxVkWcr4vpiu+46GDsGelE0SnkVazKIyYSHGGtYnLOcnGw1qFKBRDw/PwdWmAJam1liuqtxL1qRlwE6/ZMtgPs7tFnTmBzum64k1RENwfwlWzDRY5ptnPFfFhtM6hatQCL86g/ULiUUgy3IHFez6msFkTKHT5DjAEVlz42Jls7VP6p2zCEmVgez5od5z+YlgrT9szDZ18RzDU13
 3qf3mSA6
 gdVDYObtqYl+KWTMhZW/iiBNslWwexPaVogYGD7X5iwpMUxLfqpkkwLZbXf+PA+f4+WEjQ56m5oCSsYrXsoSD6E7Map+bw7tK3t2BbaYi3lQu6Fh3mDFL5SCgLto+5ygUDGISB7a2n0Pm+fQ+UqnbHlbOxZJOpWHbLWlkN9y92n1LeIPKdS6M65MjGnuXRceRCJdHqbD5LjVQfm6nHWYF7COowlwo01ZCKYJSuSHfdqbY0NAy//LJuhV18pLEC61acALSDCgW8cT3dAo3Dr2Wx9EA4JxTCugjMbCTZXTnhNXceZhR29a1U5ByXhCVLgpG7rJR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

Following the discussion about preservation of memfd with LUO [1] these
patches add support for preserving vmalloc allocations.

Any KHO uses case presumes that there's a data structure that lists
physical addresses of preserved folios (and potentially some additional
metadata). Allowing vmalloc preservations with KHO allows scalable
preservation of such data structures.

For instance, instead of allocating array describing preserved folios in
the fdt, memfd preservation can use vmalloc:

        preserved_folios = vmalloc_array(nr_folios, sizeof(*preserved_folios));
        memfd_luo_preserve_folios(preserved_folios, folios, nr_folios);
        kho_preserve_vmalloc(preserved_folios, &folios_info);

[1] https://lore.kernel.org/all/20250807014442.3829950-30-pasha.tatashin@soleen.com

Mike Rapoport (Microsoft) (2):
  kho: add support for preserving vmalloc allocations
  lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt

 include/linux/kexec_handover.h |  12 +++
 kernel/kexec_handover.c        | 140 +++++++++++++++++++++++++++++++++
 lib/test_kho.c                 |  30 +++++--
 3 files changed, 175 insertions(+), 7 deletions(-)


base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
--
2.50.1

