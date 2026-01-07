Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E470D0D171
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 20:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8B216B0005; Wed,  7 Jan 2026 15:32:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D361C6B0093; Wed,  7 Jan 2026 15:32:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE3536B0095; Wed,  7 Jan 2026 15:32:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF8636B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:32:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A181C1FF1
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:32:38 +0000 (UTC)
X-FDA: 84306315996.09.545107D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9BC961C0003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:32:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DGSFZxRK;
	spf=pass (imf21.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767817956; a=rsa-sha256;
	cv=none;
	b=2SWTTXrNkSut4p8oHbZR529S0dXGcM1e8yc6AJqxEZ51MDrDwykuL+Qd3BpLkKxFAqRZEi
	AveHk3aKEQbZIJ82lSjDHJVB9Y99ugmtFWr9W5TI7bEDPwEIQJvkZFOMdYLqU2i+Gdzxk9
	ujV7X1okShe9GN4WE03pY4X4KtSI3bM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DGSFZxRK;
	spf=pass (imf21.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767817956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=01UmXmyvT8OScJdoEXdlI/lzlLOJUWcDgELiuatsWmA=;
	b=R8WzpLamnemQ1ftwd3zMTjFNQQqb4Mp0xTRGWgXTWfm6pfGLlx5SOxBWcoygsddeT/LdGl
	rIYm0TK42YU42iWg5htp1qIcFMoT5OjYMfGWDebbuBLZ+a/mnCYQStfAubH2a0Ufk+Z51a
	KUs8MkPcHdLHU2E4esamuBWLMRm4SAc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767817955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=01UmXmyvT8OScJdoEXdlI/lzlLOJUWcDgELiuatsWmA=;
	b=DGSFZxRKa3FqEwAhEmkk3vCta+8FfA3DO0yOpmGtqgy6vkNVxN11aePg3/qTyZVq0ZiWrA
	MwFdVjfsT4dsLH19mAtvJTpKoXoK3z0HXojkG3VleZObtrxUcSqJDPaWLP/WxWeN15bNb+
	74RLeLNl6D7Oz3MgvzHXB/0jpaul3/4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-MK3M_cvVOUSMroMKk8-w0w-1; Wed,
 07 Jan 2026 15:32:32 -0500
X-MC-Unique: MK3M_cvVOUSMroMKk8-w0w-1
X-Mimecast-MFC-AGG-ID: MK3M_cvVOUSMroMKk8-w0w_1767817950
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9EC6D18005B3;
	Wed,  7 Jan 2026 20:32:30 +0000 (UTC)
Received: from debian4.vm (unknown [10.44.33.27])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 3CF4930002D1;
	Wed,  7 Jan 2026 20:32:26 +0000 (UTC)
Received: by debian4.vm (sSMTP sendmail emulation); Wed, 07 Jan 2026 21:32:24 +0100
Message-ID: <20260107203224.969740802@debian4.vm>
User-Agent: quilt/0.68
Date: Wed, 07 Jan 2026 21:31:14 +0100
From: Mikulas Patocka <mpatocka@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
 David Hildenbrand <david@redhat.com>,
 amd-gfx@lists.freedesktop.org,
 linux-mm@kvack.org,
 Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>,
 Mikulas Patocka <mpatocka@redhat.com>,
 stable@vger.kernel.org
Subject: [PATCH v4 1/2] mm_take_all_locks: change -EINTR to -ERESTARTSYS
References: <20260107203113.690118053@debian4.vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: 9BC961C0003
X-Rspam-User: 
X-Stat-Signature: z63c1k137acgem1etcmkzo7knhyyet3q
X-Rspamd-Server: rspam07
X-HE-Tag: 1767817956-929645
X-HE-Meta: U2FsdGVkX1+z5mITDY5tQdE53tun0VIL2nrs+lg6VBTRGZoQRYyzp0h8PRyMMFIZqs5Wg00BO+1UDiRz29/bGGDel/nIbJ85VA5nc9KSn5Ck7B3dICMxPZfEe4dkcZvyQpyBamWabzhVOsXqRPs/lWJ5kA+tkeiV58/Sxbf63J8Lql26sCjjgtDZmEYTgewBOKVTWJQef1kuGGErQxVrr11eTvRhPf1rzk5A3ZmbCgOovdRdM08vErwNxLHYmHAel9yi+jPyRRStRJmGdbUgdpq4hR4azG3dle2dVLdP0Ic+4O4b+cJqV2sB5mne1ijlvK2xLrv4YhEpb0jWP+6VuQWnkejd8gdIRZnwQDdOQbXCg6R85TOUDscMRk6TLb24yWNzM14aw0f4Ll8WDCCV6aNnEwEWL4RudbY2svTIFbB2EXGel5O4MWsq/IO16jdWEoJWiEurxJHYWpj57IBexpgvc2+ZHvejE70CPewRnRC7wOOhi1eezmfonyjp5Bi0v9B9yl40+wZ6LPj/6HO5k3x7TDuOWzRyeWJeOQUKFb8TVYk0abvxs4bWJjF1+fSKPYUsvrKrudp1622+eH03n6ATGJF1zdVi3Hvn7ykz28aBx3+fnS4oDAn9ZcIXW5X51OwJOEeJ5/IiG/2QW6d8+ljOFdTsd9USdWCETuu9sXFRlN/GRCxQ69BBfX7ncMT14arAnLWf0kwkWFdcinlFDZzWJmWN7OXkxGr21yy79eJ8ohxIEf/C5Kkbloe2AJXLvitWxc77f2gQtzccYHmBxpauKOZ26PYtwObMICNrJ4IEiTWFHy+Y9Nk9r+t32d3TsaIlRvkD9mB8P+nMV62RajC1coj+a5TqkJftZ87gddnmM+VFOZFQ+SFM8GBNpb6Z0r/v+haZiBIIav7YJRCpcxQk+6GNdKNOzI92s2vj80fLwkC0PWMXp+mQ0pY4ffqUqZh1uXeL05gATU8wmLA
 REmVc0H8
 tGzJwztdvR6gY2A7v6ehJG8zz7EbFFiiPdgMIiuG/V6KYQt5elkQ67AdzHhuQlbwO5gyVNJEfK2T7moJ2Fthiqe8QKqQtuR5My6aA2HuZPiZ4P0CMo1o7P0xOoViuGAdv6Ym5oS/zckC2P6BgNI8/2O5ROJD3iivWAra7aRllAoQ5mYaZdS5+fFH/kMMryGK692S+0HgkH5t1yOvcue1c7hMQiHemPr9WR3eIWiRhh8UlJuhQJH9clK9sFE1D37NtfIStO18SN6vFgEt9sM6K2J0xSMUV7fFvkUlEfOgfDchmTfLlARDaj89DwBINHJ7g22SDVUay7gPx2Uh1G0qjoG+1/SdqeAnQxHQJxOhX+1KPM9cxHZKjqY51XtkzzH6/i8B6qMxFPazHejzRCJYn5mzl2Bsl8rmrixDpC+Z8p8W+1JahcLqMotz0hk3iTKTqQus/ATpulddWJQbUZWHPtxLNtQg0A6Ovg0QY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If a process receives a signal while it executes some kernel code that
calls mm_take_all_locks, we get -EINTR error. The -EINTR is propagated up
the call stack to userspace and userspace may fail if it gets this
error.

This commit changes -EINTR to -ERESTARTSYS, so that if the signal handler
was installed with the SA_RESTART flag, the operation is automatically
restarted.

For example, this problem happens when using OpenCL on AMDGPU. If some
signal races with clGetDeviceIDs, clGetDeviceIDs returns an error
CL_DEVICE_NOT_FOUND (and strace shows that open("/dev/kfd") failed with
EINTR).

This problem can be reproduced with the following program.

To run this program, you need AMD graphics card and the package
"rocm-opencl" installed. You must not have the package "mesa-opencl-icd"
installed, because it redirects the default OpenCL implementation to
itself.

include <stdio.h>
include <stdlib.h>
include <unistd.h>
include <string.h>
include <signal.h>
include <sys/time.h>

define CL_TARGET_OPENCL_VERSION	300
include <CL/opencl.h>

static void fn(void)
{
	while (1) {
		int32_t err;
		cl_device_id device;
		err = clGetDeviceIDs(NULL, CL_DEVICE_TYPE_GPU, 1, &device, NULL);
		if (err != CL_SUCCESS) {
			fprintf(stderr, "clGetDeviceIDs failed: %d\n", err);
			exit(1);
		}
		write(2, "-", 1);
	}
}

static void alrm(int sig)
{
	write(2, ".", 1);
}

int main(void)
{
	struct itimerval it;
	struct sigaction sa;
	memset(&sa, 0, sizeof sa);
	sa.sa_handler = alrm;
	sa.sa_flags = SA_RESTART;
	sigaction(SIGALRM, &sa, NULL);
	it.it_interval.tv_sec = 0;
	it.it_interval.tv_usec = 50;
	it.it_value.tv_sec = 0;
	it.it_value.tv_usec = 50;
	setitimer(ITIMER_REAL, &it, NULL);
	fn();
	return 1;
}

I'm submitting this patch for the stable kernels, because the AMD ROCm
stack fails if it receives EINTR from open (it seems to restart EINTR
from ioctl correctly). The process may receive signals at unpredictable
times, so the OpenCL implementation may fail at unpredictable times.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Link: https://lists.freedesktop.org/archives/amd-gfx/2025-November/133141.html
Link: https://yhbt.net/lore/linux-mm/6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com/T/#u
Cc: stable@vger.kernel.org
Fixes: 7906d00cd1f6 ("mmu-notifiers: add mm_take_all_locks() operation")
---
 mm/vma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: mm/mm/vma.c
===================================================================
--- mm.orig/mm/vma.c	2026-01-07 20:11:21.000000000 +0100
+++ mm/mm/vma.c	2026-01-07 20:11:21.000000000 +0100
@@ -2202,7 +2202,7 @@ int mm_take_all_locks(struct mm_struct *
 
 out_unlock:
 	mm_drop_all_locks(mm);
-	return -EINTR;
+	return -ERESTARTSYS;
 }
 
 static void vm_unlock_anon_vma(struct anon_vma *anon_vma)


