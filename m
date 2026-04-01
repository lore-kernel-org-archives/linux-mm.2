Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C9FE10F931B
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 03:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8D4F6B0089; Tue, 31 Mar 2026 23:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3E256B008A; Tue, 31 Mar 2026 23:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7B126B0092; Tue, 31 Mar 2026 23:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF1376B0089
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 23:01:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 688CEC4626
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:01:52 +0000 (UTC)
X-FDA: 84608487264.27.14392BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AAAB88000B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:01:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lS5D11xR;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775012510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ENp0VX+MQBhuLDjAxscS1nW1CSudbIbSayS+NIcL44I=;
	b=Rub8HvZhFY7EMjSngRMRKq2kBzXSRTaRDAk6fezx2JYTH0PTEsuWLH31HoCjVSjFUusvzH
	fI8d1RViWEtRhJ0vmZhpTdRTtvmgaubQg/HEpZhnvrm2osaXdzdX7BUahNX3V/lRAZ2gf1
	zfCmjnDj8MpN0zkd4wLli2bmBVuwIDI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lS5D11xR;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775012510; a=rsa-sha256;
	cv=none;
	b=gSbYHvdueZOz1sMmKTn8vxEDpEPPpy7e5cQABykONu4FtP/1L8XvZvuDxEd1WzL6U7LBIh
	y731lQHtOdYNuof9wJnT6gMbzh5FtL1wNrFHXxYl8ILvH+r6EtA0zrsDH+58PccSBXrNOd
	WFww5s7JNUUORqbtl9GuetWHIq/ivRk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ABA2841AD9;
	Wed,  1 Apr 2026 03:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0B9C19423;
	Wed,  1 Apr 2026 03:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775012509;
	bh=ZVTmb5OLDlIKZZKOSd5dxlLCVxnnVXo3iP8zcwo5QKE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lS5D11xR9HeBMut1uKPuy64GlGGY9xrdhDDL7Ny5n7GBAM4eBRYTu+rRgRlUxkcFU
	 zMpYZ+n9K97xXeniop8EGgYwaBjIHhgc6ko06AGvS+uQFkg6KbP8vchpD6vFH/Arl/
	 yZ4/gUv64ZK2t25GCTBTatjCh4yP2SvqRqanef/Q=
Date: Tue, 31 Mar 2026 20:01:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Carlier <devnexen@gmail.com>
Cc: Peter Xu <peterx@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-Id: <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
In-Reply-To: <20260331134158.622084-1-devnexen@gmail.com>
References: <20260331134158.622084-1-devnexen@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AAAB88000B
X-Stat-Signature: dwf1mpy31e89bqfh98w75zhbnanf3yz8
X-Rspam-User: 
X-HE-Tag: 1775012510-116630
X-HE-Meta: U2FsdGVkX1+xBVuhSzJgqqhQE8KtNcHyUGrE905ohTc3DHpI1tZIn8NcH6bP8vzu+scW/hmW+JFhmCOdd1iBN+C5PLzUYrqpQB/s54kI9wxwBIhjp3KfvcmNu4U5yewTnPu4ixkhiz0qkngu7oo0VYqtpHmHCstQXFCJeXLMOpBBcyuGUfqwDskIcgGi+vwOiY/d1hKznDeACanaKe8Z2I36gSUyq2iSMd6YaEOTWP961i/IPj00gaKeCRTGiGL4EXRD3G/htkXF0prpNX4qkj0i91OT0KarlR4ACGad5h2OxXB92qZxpo62v/dHSK5d8Gt312rrOcHwwF0xICL+MgQ5yFTWC2/1nqgSpfyxgZ4cuiTGSSIK3RfsMfTZgLmKLM+FQOliQ8ShLktrl60o5qSVKZ09tUXlW+IebZzmwIsZ8xWzlaJYvQhvBXkd5ZH2WitB2OxW6MtcdWrVcCssNY4V+tx/Vnf8HJaAxuqmy6iMFnf6K3ajBrq/pgdXw4Qm6RH86i7HcXa6aZWFwv8GU9cHJ06yYsChG94u3CXiSTy5P6wi1GPPRmgtqPpotMe87SzaJYJVXgMXiG+H7JUKBhWK4shh/Ge4jEXUZvf+yW8CdnFTR1/Xm2V87jsPUDdeI5fSC0jDtKlC92LmJCANNo7ic6GIqd99vW059SxO6xtAFgwYSX26zSydUlupKaaYuoAMVWf2nDbMfaiifMGgDJvY7mmYtouodONxpz7bRpt6xxH7LB6ZLUl2cjq4DYZ5v20JW9ntAN0V+lBQ6KEiDNjK3xMHDD4ILqVXsMHvCTLWHBxILeYsZ+0lD0wuMpdIA6r1EX9jegvE6y1KW0B+8HEJSZmFwl3g6+kCbozJU39hlcCNcjKjN6eEE7OeIBibOAlskV0TVHnexbthVxqxsIrTtcT8gX7K2sSS02DyON0KffU7NOyLZhlXmV1fuSm08oswEJGQSoQJddV5uaN
 yXxCTcbp
 2Wqjbhxw/G4Pl5X+LJp/jM2vmOwRIFc3nd05oWFa9XfhAAdu/VIYJ8TOh7McWoog/W13ixUb+QV+StcOXV3YrgC9XItDqSnF/x5KN/7y5URSZ96FRbbjv33Xyz1Vn3H9ohUW3VMBM5OVMm+O24bSwHmoLohvjPGdCuc+jrQVBtIX/7Q/itVzBho3XZOj6XAN40mB+do5UbFbvgmz2Q2eynHAoiBSnglhCgZd60yLilb/To0C+/Id62hDS97ALjGH1Jc+GF89mwgJ54hC8VqxZUzpFIVpXI9G4XD0j8qQKWHRL1Ui4XdUgRJhifEEk4b7c3Ptj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 14:41:58 +0100 David Carlier <devnexen@gmail.com> wrote:

> In mfill_copy_folio_retry(), all locks are dropped to retry
> copy_from_user() with page faults enabled. During this window, the VMA
> can be replaced entirely (e.g. munmap + mmap + UFFDIO_REGISTER by
> another thread), but the caller proceeds with a folio allocated from the
> original VMA's backing store.
> 
> Checking ops alone is insufficient: the replacement VMA could be the
> same type (e.g. shmem -> shmem) with identical flags but a different
> backing inode. Take a snapshot of the VMA's file and flags before
> dropping locks, and compare after re-acquiring them. If anything
> changed, bail out with -EINVAL.
> 
> Use get_file()/fput() rather than ihold()/iput() to hold the file
> reference across the lock-dropped window, avoiding potential deadlocks
> from filesystem eviction under mmap_lock.

Thanks, I've queued this as a squashable fix against mm-unstable's
"shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops
ongoing".

I've fumbled the ball on your [2/2] unlikely() fix ;).  Please resend that
after -rc1.


