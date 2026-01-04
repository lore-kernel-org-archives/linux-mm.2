Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADD6BC2A062
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 21:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23ABA6B00A8; Sun,  4 Jan 2026 16:17:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DB336B00A9; Sun,  4 Jan 2026 16:17:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DDF86B00AA; Sun,  4 Jan 2026 16:17:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F13576B00A8
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 16:17:13 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE2A5161729
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 21:17:13 +0000 (UTC)
X-FDA: 84295541946.13.21D60C0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id C862B140007
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 21:17:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LgJxiyfW;
	spf=pass (imf26.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767561432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YXrJP9q/GUrVMl1VY4mCkTx4D5WafNvciWq+lKsafng=;
	b=ktymxUXEbWT59KTAIsKxMt4nTRsWJX/uLaAip8AhdTW4IMbn+ZXw9EuZdS1O5ByrWEQ4rJ
	h7wMtu3s7FvrZ/wSKD89jsgwQzH/6avohjs1V0EsKhAQwBZe7c1NFA4t75Ic2+pgt07/lO
	fVI7xIzmTtL3J/Rz8R77q1K7JgKyzQM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LgJxiyfW;
	spf=pass (imf26.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767561432; a=rsa-sha256;
	cv=none;
	b=1Y3Wv0B2wBr7l2uH+L94isbXdTPTPdymrr8EWDV8TwOdcB0fNg+O4J1oIJiof29UmhXpe7
	2hdo35iU3C8UrQjkEA1PjM3wkoULxcRqhm9Mfo8hmvoI/lFSL5kqggr86lRylSd4+qPfyL
	qMKUgYRVdOe2tuX0sEnVWfJ3yhKukH4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767561431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=YXrJP9q/GUrVMl1VY4mCkTx4D5WafNvciWq+lKsafng=;
	b=LgJxiyfWrHHXD167CC3kVBMZ383KO8L7HTe5VlxLE31rxawuhjrygYMUNDv94eHvYn42ZQ
	kBULp/ZRIHgKniswQqPeSnB/skfsN8oB2QN+hJBWW/+xfM6Qs7EO2gONHjwBnVISpo4+7N
	bYDeYzIG/DMrwzk8yd/4Y3X+FZB6nZc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-32-RflY1I1HOry_6hVCuw3eXQ-1; Sun,
 04 Jan 2026 16:17:08 -0500
X-MC-Unique: RflY1I1HOry_6hVCuw3eXQ-1
X-Mimecast-MFC-AGG-ID: RflY1I1HOry_6hVCuw3eXQ_1767561426
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 09FBC1956080;
	Sun,  4 Jan 2026 21:17:06 +0000 (UTC)
Received: from [10.44.33.27] (unknown [10.44.33.27])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6AE2180049F;
	Sun,  4 Jan 2026 21:17:02 +0000 (UTC)
Date: Sun, 4 Jan 2026 22:17:00 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
cc: Alex Deucher <alexander.deucher@amd.com>, 
    =?ISO-8859-15?Q?Christian_K=F6nig?= <christian.koenig@amd.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org, 
    linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
    Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH v3 2/3] mm: only interrupt taking all mm locks on fatal
 signal
Message-ID: <b672e17b-461d-16ae-e7d3-45d3c1aab142@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6gyRgyyfy9VidRAmutbxHFDtILRfSWESJSQzWPKI8_o_1767561426
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam02
X-Stat-Signature: dn8ub555kuooakwyaj9u1p46417g947j
X-Rspam-User: 
X-Rspamd-Queue-Id: C862B140007
X-HE-Tag: 1767561431-490162
X-HE-Meta: U2FsdGVkX19RzayUCASJcbXvfD5uZ/M6ie0YMYgv8EQ4tcyasA5ZVncwFClRDMULwuUYie0DdNdIDCFMbvvbhoxD8I9pnXQlAU6yUJRcfiYrcJAbByUoUmB0kgbkdIbMznHVW1EotWm6m2EFooQr5RplCOdWDhqUG2w88AplLz658nDPEFoefQaYRHu5F7BeIsRJruYv2v/ysm6pDy52n2siPLm7ksRIUMz6tjLEIUZcovVl1/cT5Nia0EQQseSUxfuz5+fSIZ2oehDtUZu9JeuYdlDXcfoCfmNLvnC5ncBGLnKm2wUuzb4G2uy8WuaHDVtrAuq0AklTe434EGXXSYhJcu/bgUfPRHtyOTxhAyM91m9ziC+nlmb9zgbYLK6pZpxsFYO206FNGLjnEMm2I5EIeGubaDhJ1ednULCozeP3OsAnqPNuiecSJ8nGmd2K+zNPUtZ0J06i/oYW5GDJ5tB0oHyfBtXOy7U8c2USoqDrg/1tcQd/ax5Ai030ls6w7Fr5ijseYWZK4XczNIwP3KH4M+s/kGh5EAEPL4ZugL1h7XcZKAYyl91EYq32brFFoSKtNk+d6HSmOw1IiOILiVoziA6pkDyS6UYTeV+5Am8MF8Q+jdSjBLRjsh9bG9jdCezvD5dl5cyy8qx+1c/GhFBYtulUjDjQ8xrSe5xNLGWxhSP0fi748wL0M4Wmkg+ycgYXjrhQL8dJIzhf45AkOc+NMPzmKA82Kyt4eO2TjhaC7c1SvgK4twNwxNDxkj56s/JHk82KufJ18lh3B/22qR2oMD0TxQJBsWiJ5M6I1+LugWsp/tBewF7Ln9cbn+AaeSvv+Gnt4HiU04Z20h5J2fu70F34fS+UTnnxLtqzNkaAjBl3LprzIGpWtR0WE5+kcjLY42LFouNl1QOAGilK+wpqclHoKj7cX4jfax++pmFfvwdJDSW/kvHhGPFaKb/hUoR4zIMOWLJYReXPs4E
 scHroVvI
 3zVaK0V8qmdLyarItrVeqODuq+mpFYvEEHNVFMSRNzbjIHZRhxS2NhTOX9GamEMRgG4Vyy00rJY1EVG7p8TknXzojRTaSg9GRx+bsqcVhw1ojtaayIQVf/fhUWBhgFAKZRyOxDl3RhGPDOdhr9IETQsPXjFsrFnRiPEcquceDKb17fqnAk5ORXB/XfckNBBopGwt8Da6aifb4eZ1yd8uBPRyPIXRGTU9wO7bTIUwOyM5XkM7m7pbtzHp6veQFsl93umNR1caUn6yu03OoBOYRBY/165Q93M5bVbv6AYQNhwUkdmO6uNQU6CDiRrBKZzj8JCy+NZ5BUW5Y+5vngT/XrDCfc0a9mwR22Fv6zWCyZyU5SzyTEBD34jdpfA9jlHw6BIzz0Lu9GEqWyw0TTtKLaFAbibZoYzBAOpvTon6c6nftQc//V5H1M3te2aEl9uLI8NRvV6EkoQ7Oh9ZfAgFHHjKF6W77WHGdeSsLfWDZ0sGAQAWejroEMXYOqqI6SLZc0L42sJ0lQdSvZPEaC9WEHPxQQTuMBjfDWPKJtjUYB9HhNMU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If a process sets up a timer that periodically sends a signal in short
intervals and if it executes some kernel code that calls
mm_take_all_locks, we get random -EINTR failures.

The function mm_take_all_locks fails with -EINTR if there is pending
signal. The -EINTR is propagated up the call stack to userspace and
userspace fails if it gets this error.

In order to fix these failures, this commit changes
signal_pending(current) to fatal_signal_pending(current) in
mm_take_all_locks, so that it is interrupted only if the signal is
actually killing the process.

For example, this bug happens when using OpenCL on AMDGPU. Sometimes,
probing the OpenCL device fails (strace shows that open("/dev/kfd")
failed with -EINTR). Sometimes we get the message "amdgpu:
init_user_pages: Failed to register MMU notifier: -4" in the syslog.

The bug can be reproduced with the following program.

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

I'm submitting this patch for the stable kernels, because this bug may
cause random failures in any code that calls mm_take_all_locks.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Link: https://lists.freedesktop.org/archives/amd-gfx/2025-November/133141.html
Link: https://yhbt.net/lore/linux-mm/6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com/T/#u
Cc: stable@vger.kernel.org
Fixes: 7906d00cd1f6 ("mmu-notifiers: add mm_take_all_locks() operation")

---
 mm/vma.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: mm/mm/vma.c
===================================================================
--- mm.orig/mm/vma.c	2026-01-04 21:19:13.000000000 +0100
+++ mm/mm/vma.c	2026-01-04 21:19:13.000000000 +0100
@@ -2166,14 +2166,14 @@ int mm_take_all_locks(struct mm_struct *
 	 * is reached.
 	 */
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (fatal_signal_pending(current))
 			goto out_unlock;
 		vma_start_write(vma);
 	}
 
 	vma_iter_init(&vmi, mm, 0);
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (fatal_signal_pending(current))
 			goto out_unlock;
 		if (vma->vm_file && vma->vm_file->f_mapping &&
 				is_vm_hugetlb_page(vma))
@@ -2182,7 +2182,7 @@ int mm_take_all_locks(struct mm_struct *
 
 	vma_iter_init(&vmi, mm, 0);
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (fatal_signal_pending(current))
 			goto out_unlock;
 		if (vma->vm_file && vma->vm_file->f_mapping &&
 				!is_vm_hugetlb_page(vma))
@@ -2191,7 +2191,7 @@ int mm_take_all_locks(struct mm_struct *
 
 	vma_iter_init(&vmi, mm, 0);
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (fatal_signal_pending(current))
 			goto out_unlock;
 		if (vma->anon_vma)
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)


