Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D839C10F2865
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 19:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BED66B008C; Fri, 27 Mar 2026 15:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46F836B0095; Fri, 27 Mar 2026 15:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AC676B0096; Fri, 27 Mar 2026 15:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2990E6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:13:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C5FE18DFAE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:13:53 +0000 (UTC)
X-FDA: 84592792746.25.0894FBA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id EC3821A0016
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:13:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="vGpRQ/jj";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774638832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=igejSyxkWEwhQfSyQuEiimB2zShEMuDhph/zXZNiP30=;
	b=WjYLscqW8IMQlc0Nb1xoB6IUqidTyaT5WRSWJFus5VfczcHSjW6AM4pwAuZUMJ+JHJ8uS5
	F8Qjy+H+T/QXt6JHxt5NUi1As9kDOiyQNJIRFwBM508hvL3ZAhAMVxS97Z11fkHjq77xSa
	q83fqLR+HQ2TEtWMaRdNOeJRRH8wrds=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="vGpRQ/jj";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774638832; a=rsa-sha256;
	cv=none;
	b=HVstg8WeOCfm4ajVB9TKD6xK2bXBekZbvbvnZoeTXBfW/M6/G/ZNb5ZQHK5yjXz3EuvN+X
	DqBPboPwKX1z4y+3Cp786W/bJn2kBj8k6Cg3Imzm5hzYBc4bOGfpH2vTleL+HCl6X2sRn8
	GGdPLYPce1z2+r1dUUjqu9fdE3Xfx9U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 55DD0600AE;
	Fri, 27 Mar 2026 19:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9309DC19423;
	Fri, 27 Mar 2026 19:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774638831;
	bh=sCKExA/z6SpVqvB2m7zmhBRO1VOP9oHSCV8P4PPj9WA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vGpRQ/jjF7b3+LW+FI8glJV8BAJe7wiffXZkP1Z4Cu9fqA1GfG9lezqF1dgOYyLhC
	 sb+op9gCZrllOQ/MMdt43lxR9KtqLTAreszvVZDsxajvKgCR+1IfwddKpcxrThqY24
	 yh1kwk46NIs6HdmaPWfTzuf0scUW1U9G5+BaGIo4=
Date: Fri, 27 Mar 2026 12:13:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Wang <liwang@redhat.com>
Cc: rppt@kernel.org, david@kernel.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, aubaker@redhat.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/mm: skip hugetlb_dio tests when DIO
 alignment is incompatible
Message-Id: <20260327121350.858a127fa49ed6e1eb4a40a7@linux-foundation.org>
In-Reply-To: <20260327120305.58653-1-liwang@redhat.com>
References: <20260327120305.58653-1-liwang@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EC3821A0016
X-Stat-Signature: nd4xan8s8hq9kdbm3m14u5jtx1jghy7y
X-Rspam-User: 
X-HE-Tag: 1774638831-531875
X-HE-Meta: U2FsdGVkX1/Tl/FlCNpwXHq6z6yGFnrcXYN+qqT/+YVBtmN5QsDrIdFIr3DBIwqa2ddw1T0vYGHsNsPgkBsIlrPPq9frrWCArUriDvJODPAeoqBddPKyKDDO1X8WM/fWv8o+gJyzU2ryntenfXEvGbRG93Tsue7wJ2OYTrSx7UKU+wblmHjx5V8ZIe3Ef1IjCgtRfFcZ8wOl12lBZpTYEDj0OAV+I+5hefu0WgHbiB1ckdObxhoafOb7/CZKbHUyRu81uCV5y+41dAuZvAvt/OYVkX+l18P/CBWAZWiuZTT6+3c4pdvjIq9dkjN7daX54BFBnuOTaQUgSNOscGvHyFTMhzMYx63ibW5KS0XkzZnlz1Im3YteTK2LluIsxZHDSCik+ZgBzT/t4mGwvoRqqZ4rPe+odLOea0Aq6VAE5AOAwt6Ke4ruUkgoQayZb8gGGzbvvZAuyIkonWucnYxGowiNIZZ/Vox8URaywcIyNblr+xX4YXB6ya97zhNafLWPUePd17Bvp1b77FkD5G81ALxJuRo6kOWkvT4hy0r5pi44wRSMjcKZ/ZYpvU9YUArK995uSmF7D+AxHJKMEJORY9avAn3eoUgfuaGufocgToOpNfgYozF1sqxHOnYzx79baeb9dUxy1LKanmsD/OI75hTfZ0sZ0vCiE2uU/ZvduA2aCw1iK05wAjOy8d52YnfM59bNck6glP6y0L+eOC9MTRN2vVtUmATjpNWY8uxSwIkG5AwL2X+7rC/2+AxoL38hoSIunhMq4+NzhqZeSzxWfCJs23IwpalVNGyXpzYly18x+g4Lx8FSPQ5lCmF4atKZg9iVBpkCzV+qUogWF4VEjxKIPr39a0/kdIOSePC638Bz8cV7ZIJxVDZ/6AcWbdw1BsjmPT7tyDJE8XZhNJSdnJi76zjCVxnjy4hREl8DoVdhX3Vdvv8/iQLkv9llxozaWs6B4MjQ/Jtit9Hw5uJ
 SAPBnN8i
 1a6GknBYgdVNx3FzWl3enzlgHIqDv2GCb/03Lf++CV+KCZaT8r0ym1nA2FsU7tc7Wfa9aH1KIyHU0XVCJMwHhPpLHtcQzCF8ImDiZvcPFRBHRkaT8uWY61SpmmRLke99cAkYgPtgUw5RwxmhiiiFbx3vlCTpJ5FvM91UKCagO7cYaexCdTZH9GxJI+znhpFpoMNOdjoBubEdZ79PAOVyGA+li4OvUe4/NtD+L5yRU+a00iT3+aEYzLivQois4/G1YrjTputphUWiyWh4cgmocKjeP365OTPvMMUySSI2qwUrJSuWE67mtIYEyXFU1jSGZrCISjFZAjR8AHOuSQu0vtsv/p+lqMigiRcg2pkVbSHEqP/UDwFHP9hUg/QFhtKfKh4Sq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 20:03:05 +0800 Li Wang <liwang@redhat.com> wrote:

> hugetlb_dio test uses sub-page offsets (pagesize / 2) to verify that
> hugepages used as DIO user buffers are correctly unpinned at completion.
> 
> However, on filesystems with a logical block size larger than half the
> page size (e.g., 4K-sector block devices), these unaligned DIO writes
> are rejected with -EINVAL, causing the test to fail unexpectedly.
> 
> Add get_dio_alignment() to query the filesystem's required DIO alignment
> via statx(STATX_DIOALIGN) and pass it to run_dio_using_hugetlb(). Skip
> individual test cases whose write length is not a multiple of the
> alignment, so that aligned cases are still tested.
> 
> === Reproduce Steps ===
> 
>   # dd if=/dev/zero of=/tmp/test.img bs=1M count=512
>   # losetup --sector-size 4096 /dev/loop0 /tmp/test.img
>   # mkfs.xfs /dev/loop0
>   # mkdir -p /mnt/dio_test
>   # mount /dev/loop0 /mnt/dio_test
> 
>   // Modify test to open /mnt/dio_test and rebuild it:
>   -       fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
>   +       fd = open("/mnt/dio_test", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
> 
>   # getconf PAGESIZE
>   4096
> 
>   # echo 100 >/proc/sys/vm/nr_hugepages
> 
>   # ./hugetlb_dio
>   TAP version 13
>   1..4
>   # No. Free pages before allocation : 100
>   # No. Free pages after munmap : 100
>   ok 1 free huge pages from 0-12288
>   Bail out! Error writing to file
>   : Invalid argument (22)
>   # Planned tests != run tests (4 != 1)
>   # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> ...
>
>     v2:
>     	- Pass dio_align as a parameter to run_dio_using_hugetlb()
>     	  instead of generally page_size/2 alignment check.
> 

Whee, AI review has decided that pre glibc-2.36 is a problem (last time
it was pre-2.37).

And it's forgotten the previous fs-doesnt-support-DIO issues.  Did you
alter that?

The get_dio_alignment-before-ksft_print_header thing seems legit.

https://sashiko.dev/#/patchset/20260327120305.58653-1-liwang@redhat.com

