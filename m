Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4899C606A339
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rm2Hmmb4
Received: by kanga.kvack.org (Postfix)
	id 1CF116B05ED; Wed, 18 Nov 2026 16:59:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6A66B05FD; Wed, 18 Nov 2026 16:59:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BCAE6B05FE; Wed, 18 Nov 2026 16:59:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C70B86B05ED
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:59:28 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57E291608E1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:59:28 +0000 (UTC)
X-FDA: 85449606816.03.BA0590E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 38D47100005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:59:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rm2Hmmb4;
	spf=pass (imf14.hostedemail.com: domain of devnull+harrison.crosse.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+harrison.crosse.dev@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795039166;
	b=L5uzhY+2AMzZZGG9w0wL3G1tykKnuPSdo7FSLHU/q5kYnJuuwiezNJueyCIsgDRWfHg2O0
	L5rvG6VAMRdGB5MVhdIKWnF1c54dOtRu45psCfdOYL7HOMWpQMPE7ILrOTyGe+yr4tI6AW
	Ze+XsjoiHY1p2ljiS+lfSzub2XMP6qo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795039166;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ea27Ot+ehzrAuRSoKcNDt2qvaz6iTBMPzRnS1G4L6jg=;
	b=eiYHzgCF8ox7GuEeOuVnlYlHexDKBlmFXKZ8KiBxFhZZRz1BHo/cLksRVeQ1M/yKhRUGed
	RBUJOdyhdF+sXqOn9+lMJNOkcKMoILqNTQoCk1dwJ6HjD0WOMd+oS4aA9CpE24v4tx2zQ8
	6tHrM+Y7EXxYL4WVYLRt2kHD2CfjKN0=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rm2Hmmb4;
	spf=pass (imf14.hostedemail.com: domain of devnull+harrison.crosse.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+harrison.crosse.dev@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A5A246D15;
	Wed, 18 Nov 2026 21:59:25 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795039165;
	b=DWTnBk12sZdF8zsdz9gCwZhv+vYWe3lj68ba0afbHF6Efsi5k1vx2XUhEuda9nkIsQ6U
	 8UUCLzwgTa5yKFOsTIsR8e3ziEYEat/uHxzYc/Ap1Uft0SCK3eO/SfW/sNB30hcF9uuSn
	 H5RGi02ffZ6P92b2XEWEEAg6fMzrwWBkCl0FHKqyqLlos6wk5SE89+iMJCgbGqdQk8rJj
	 CzZ7isjJeChWH8Z6L4MtFvbsuXAaBabQNYgms1OT0HH54Jl/qrWwCuCuLwR1GJxLZgKrY
	 aXJXrDE56BJ0qUVEO/uBpxgsiAu6s733FH7nl+RuliebBTn0ZSbTzItZ27CqtCCWE9g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795039165;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=Ea27Ot+ehzrAuRSoKcNDt2qvaz6iTBMPzRnS1G4L6jg=;
	b=vnbrzcM0ACGiao2hpRFRi5VeEHM5OehtFUtLvx9I27CA/EcXlrYYWyUSIR39M2awf1VZ
	 SbLxd+LYhSzluoswD5Gg7NjUYrTFqJb+w8fJgW/fYgsB8BWszPlmScYqBnxmaHp80+SXN
	 FKOl/2FKqwOCx4l6ZP28X++XcthHU54GEnbultWoFcG79cYP1Ww6seafWvqyjUD6Bl4Vj
	 wo4Or/VgR//a+utONeWgTh2+UObAsnbDwFLu5En7L70xoS2frXICwG3Ge3roOdJHKYDxS
	 UTlDEs7dF360Kov6l8TU7YDrwZnjcXZ7XF49oieLLQVdZYdtSOJVB7K0/nff02JX3QQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A6E8A1F000C4;
	Wed, 18 Nov 2026 21:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795039165;
	bh=Ea27Ot+ehzrAuRSoKcNDt2qvaz6iTBMPzRnS1G4L6jg=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=Rm2Hmmb47BdMevLkbFJQUrSi1TWermrXl3QJtZMhr8reX1J3w0EvxDUvIxw1Ac2nG
	 7xKDUd9UPsF/R7gOFst3/YqYT0S4KpdScvIYnJh221gyUqcoJrVdmr1XRuci4ckfnv
	 4KihRK1CEH/HWvwMohiYfdG0RSuIKbu9CIQ8HZsU5R/BQL038kNaNf3FKkBOkHUoBl
	 Sf88wMebLLFwrZ0eYM77FkaBr4LomRTHOfThbUSBislJvdyO+ZID4lQcuyliVP9kcK
	 V/Es5yEjQ0S5srs7LItdWvorf9FR3swXDwASJWzUZbmT8L4aBFin91NG8ig2ZUJ9gF
	 RypFw+og+GlBA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 03AD94AFE3;
	Wed, 18 Nov 2026 21:59:24 +0000 (UTC)
From: Harrison Crosse via B4 Relay <devnull+harrison.crosse.dev@kernel.org>
Subject: [PATCH 0/2] mm/gup: fix mlock() and MAP_POPULATE looping on read
 errors
Date: Wed, 18 Nov 2026 16:56:40 -0500
Message-Id: <20261118-mmpop-populate-v1-0-9c561d178d11@crosse.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQ0ML3dzcgvwCXSAuzUksSdW1SDS2ME1NSzRPNU9TAmoqKEpNy6wAGxg
 dC+EXlyZlpSaXgExRqq0FADAipz5yAAAA
X-Change-ID: 20261118-mmpop-populate-8a385efa7e7f
To: David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>, 
 Harrison Crosse <harrison@crosse.dev>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795039163; l=2455;
 i=harrison@crosse.dev; s=20261117; h=from:subject:message-id;
 bh=/PkZRnZe5tu6LV293Ifp8K0JXLUKyW2KwcahuxQz4ow=;
 b=OSles3yksDQFXG/3q0tQCEMz+u/knBGbhU4exaXmvxAgSt04CoaGw4td44kcwey09njt++Nuc
 HjqbxmMiv9fDRR9KESgxdSjanyuJaf+XCzQHDuSAX5Nsnb69pTt5ZLy
X-Developer-Key: i=harrison@crosse.dev; a=ed25519;
 pk=fwi/XME2YaW/BDBQ76FmKgF9xHZwRb+dxlVCbxuyojo=
X-Endpoint-Received: by B4 Relay for harrison@crosse.dev/20261117 with
 auth_id=1552
X-Original-From: Harrison Crosse <harrison@crosse.dev>
Reply-To: harrison@crosse.dev
X-Rspam-User:
X-Stat-Signature: 764h9z1xozjrtm9ygdhapmra9j7etw97
X-Rspamd-Queue-Id: 38D47100005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795039166-530367
X-HE-Meta: U2FsdGVkX18I0g2kBFfUD0qRtb5QEfykNKV5SyLxg+NFUnapH3/gOBFxxRyIapOHwxuVwPuRQqtlhgTIluh0P8CN45/E9bw+A9q3M/3HKFqv6BvBvoD1bMawBpPUmsBLSFdpl69+iYNkrD+2zQ7bi0IkVMmUnza2KXUXPmPeu/jpAR1h/+YhE3C3pPrfRchEb17gr2lmhcV5u4jGihscY1zhMhhClltt0v8Resh+arl5i+n2q3ZSZ++613mFI0tgnYN+Srbrfq2leKfAwPIizmjWf86B3U8EPtXGEh7+Yrvkl/pMDPuurfoxE85Na3MYROZ/hx0ynssHbuQ1eLuKIkRBOJd+z4zFGr9gyy2OFDyBr66LVoE6wykWqaH/ZhdDZGrIAbt5lW8QXoz1A+PZNjmewDOu63XCS4v0fS7mP7jFzuAYBEuuWWMLFveYehdv35ET1+n2eL4msk8QAQkx8I77Wq1nnScJQwpW0qi+Gy5hNmolJPkNxg9SiT3YfgVRf42YgnWWL/z9sHaM6/CKd5XBjQeYzpIwQJMNzVoMU/db2jAZLMyDoBD3YqAxYlwqU/QI8UXWEfcUaea5Vgg8HzlPYkoBoOPns1mmvEgoYEjRrz+chwhhRuBPjyluK9kcb/9YcHUhzHQtvJ3awfFnf8xFUHOcyBh8rx2IT3eBDxUWO20fdAiiYv7RS396p8Jk7WTPNEKg0O8pqDHM8YMa08tIdqEhTGunllEk1acH/kVGyrl61e05CQf7vHC7MrY5/Hdej9cUEu21HljGwxrnspNL5R1stbRayIs/wx9yCPrYIrUdPtc3mIN24IFeGMnW/T5/kefUMjlw1SZSTJzy/lbFvUh5rWOFoU78JGojk/tpxZM6Tgb4Ue+8EMJeQhFeggizGoTXjqZgEucvfeKJ97zlrA17XhFKHvogoyHZcLJB1u/mim+M8qTElRSJU6Zp45NYzvY0SHzDgNoLmFV
 Vp1qXWEV
 Wa6se2g05pawOQCZthcc8/H1imYDisURqY/qvSkmRThwvwGQ/n2DXHTyX08ps4nvpampHHXFXoVifQiAkPqSxrwY04oliDqbgYrgiIdKChef0tdpePE5LlCaUR00/sGxW/MxFwoQSjvkbVl9uQ1mi3aSouTT/NU2fEQqtOBwP9hMZAfOim5NvV9eDLLSFobjCdr/7Rp/39Hq7ESDVgCzdbxP/7sgjiPnfA1qTWaL9twkGMKMkiKQ6cv3GvFyElGxYaxccF01N+9bWXDeGIdNcqN0LytuIL97LPkZXM/fcrdlLdA9YHqkchltHIAV/fKTXEjkTQ1QAxteVjT+vZibNpmkRDOFT3QKNHiDbp1DmXOXhbHRDvaYB5JPUhjOWOD8UEAa/BhmeOn77DrI+xN96bynCrAE138u62XD9PGMOsq9D3BBbfaFbob/SpUYYMPly56HKa/BnYdNLgnBa58dtOvG/T6Xdj4V3Of8X3+qYKDMAy4CkIt1jk3oHKSTh6s8RUamk//6sMnN7uIS3Cya9hH5j2KGVCmhPqzszGgWO7P3MbzdLA19Kywj71xuX0V3jGBDMIR+u+SG5Z7ssYe1+37jKWV+ma/E7k5XkvNzVU7o9D9jWR6GCWMAqCkCjdYHhKWJmy00uUhGUYAYeV2Rsn1U1cQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

If every read of a page in a file mapping fails, mmap(MAP_POPULATE) and
mlock() of that mapping retry the read in the kernel until the task gets
a fatal signal. A load from the page gets SIGBUS, and MADV_POPULATE_READ
fails with EFAULT.

Patch 1 makes __mm_populate() pass FOLL_TRIED when retrying the page
whose fault released the mmap_lock, as __get_user_pages_locked() does,
so that a read error ends the loop. mlock() then fails with ENOMEM, and
mmap(MAP_POPULATE) returns the mapping. Patch 2 adds populate_eio, a
selftest that serves such a file over FUSE and fails without patch 1.
The series is based on v7.4-rc3.

The bug was reproduced with the ext4 setup described in patch 1 on
v7.4-rc3 (arm64 and x86_64), Debian 6.12.116 (arm64) and 6.6.162
(x86_64). Under QEMU TCG, populate_eio passes its MADV_POPULATE_READ
check and fails its mmap(MAP_POPULATE) and mlock() checks without
patch 1 on v7.4-rc3 (arm64 and x86_64) and on 6.12.117 (x86_64), and
passes all three checks with patch 1 on v7.4-rc3 on both architectures.

To reproduce, build and run populate_eio from patch 2 as root on a
kernel with CONFIG_FUSE_FS.

The fix was tested only on v7.4-rc3, on arm64 and x86_64 with 4K pages.
On arm64, only populate_eio was run on the patched kernel. Also not
tested: populate_eio in unprivileged user namespaces or on kernels older
than 6.12, the ext4 setup on kernels older than 6.6, and populate_eio
timing out or getting SIGKILL during a call on the patched kernel, where
every call returns at once. The notes in each patch list the other cases
that were not tested.

The analysis and the patches were prepared with the help of an AI coding
assistant (Claude).

Signed-off-by: Harrison Crosse <harrison@crosse.dev>
---
Harrison Crosse (2):
      mm/gup: make mlock() and MAP_POPULATE handle VM_FAULT_RETRY properly
      selftests/mm: add a test for populating a page that cannot be read

 mm/gup.c                                  |  36 ++-
 tools/testing/selftests/mm/Makefile       |   1 +
 tools/testing/selftests/mm/config         |   1 +
 tools/testing/selftests/mm/populate_eio.c | 410 ++++++++++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |   1 +
 5 files changed, 445 insertions(+), 4 deletions(-)
---
base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
change-id: 20261118-mmpop-populate-8a385efa7e7f

Best regards,
--  
Harrison Crosse <harrison@crosse.dev>



