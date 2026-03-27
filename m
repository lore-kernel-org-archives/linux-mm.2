Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DAF210BA431
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBDFE6B00C6; Fri, 27 Mar 2026 03:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95736B00C7; Fri, 27 Mar 2026 03:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2746B00C8; Fri, 27 Mar 2026 03:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC1DE6B00C6
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:12:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6B2298D5AA
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:12:41 +0000 (UTC)
X-FDA: 84590975322.16.4CBCF51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id E9DB74000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:12:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sp6tuO5d;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774595560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U00RjldiyoskDcbDpqTQmzXBLsfo8bBiFLnezELd6kE=;
	b=5gkTaovY42ZuxTCrISVTZC48fgUl6Itt33ODiyeekkR2rTDxM+QhX7Q4+LoiU3luat6A6r
	GxvXkG34OQjkt7xICPls0fxrXsydqNGcF5jX4rLsaGTn7cmqIJVXBMFSym9RzT88uKAuSe
	bIVR/aOft3IUuTJxECBjKf5xsKl2OM0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774595560; a=rsa-sha256;
	cv=none;
	b=TsfNvx8aRw45aPzEJm0De/uhwR26Q4bnxGjAaZalgvYcOr4RnnU6FQ/mqIkzTSvaPa3orh
	gZ/miRtdlqb5yHccHxLG9ybJzH5fcA4xgwdkyHkB0psj1Geb7y6Hb2YRM0N8MUAeZbzHaV
	uBo7BPw5suQ5+JvG3CWDgg3o/UXnRV8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sp6tuO5d;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FC5A41B26;
	Fri, 27 Mar 2026 07:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1E2C19423;
	Fri, 27 Mar 2026 07:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774595558;
	bh=PItmMBxubPXbDaDdFWXsnbR+luD1aEAhbzGl7SFLZPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sp6tuO5d9pGV1raZoHXRtGY96jXKIm4ROm5AlCmZXFn7QxpwFuNJUeFg5gTbc/TII
	 6PT2AR8Dpl0fFzcjkgh+RVmOBuO6IXUKbuoFf9MqUlnMgWx/Gmebdl973ejK4pWYgW
	 Y4bMkQNxNBlQwnG4nVDKdjsYUDmbZjHSoeT/wXL/jHmmiSxaTFr44P9TS/lONeSPea
	 0ofvniHWmQ+y4X3P6pnbZawHQQPvNsBIwY1yJIfadGRiHTn/KED7vwXxMCk9pUSqBm
	 PD+/iriMqKRAwyFQxBYj/LD7T01X3kL1e7CTVQnYPlIfEXm9laHcfaBlYpRC/HtywN
	 Nhso0JpjQendQ==
Date: Fri, 27 Mar 2026 10:12:28 +0300
From: Mike Rapoport <rppt@kernel.org>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 08/15] shmem, userfaultfd: use a VMA callback to
 handle UFFDIO_CONTINUE
Message-ID: <acYt3EA3TCgcgxX-@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
 <20260306171815.3160826-9-rppt@kernel.org>
 <CADrL8HWLnuQHEPFN9SZbAd_Lq1USJDV=Di4fsQuztwp4v5oXOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADrL8HWLnuQHEPFN9SZbAd_Lq1USJDV=Di4fsQuztwp4v5oXOg@mail.gmail.com>
X-Rspamd-Queue-Id: E9DB74000A
X-Stat-Signature: hx349e3r7g3sza7wpwhxd6hzqnoxorwp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774595559-28112
X-HE-Meta: U2FsdGVkX19uEgJZHLFAMsumrob2PoDrpMu/Gyrl3T0NQ1KNjCkrWyNYhGOLrDsaqzxpzhKFeEgc2GYK01oFja6FjMG6UAuQI6qWJ7CE3V24yx5dYmK88ilwAAV6/VMQpOqET8XlPQkSTCS6cS3G0N4+CXVYLT7yq4t/SOpZRM5IW84lUvEg8oIFG75eLKJbsqkilRynTsCgpfOgsZcZLNJGzkntfyrgHoBf2lf4ofRtpdUyyp8OPeW3GkX8d+zzY3pCczX1JwK9BXtT7UskLn4mSObYHeG2HGVZbkH7vh9Cm3tg++JM657bCtKILwC1QPNBFjuTS9TGgV6bJ9Tr1t7PI//TdFygXS1rGGdinuA8y5bk+sYOeGPcIxK9DL0qKe1AMIwxg9Z4kdopmuFMxeazxT3UxMeehBQFwqLdwOm+GZcxMPid9PWSXW7JbrMNifd4YLBq1yIzGXGajITTH1+5NuSgc7MmFKNX8ry7/1N2kriC2B2+GLrDGmtkH/hYjMwHandmCvx7F3HFW4ZdaCmsV+Q5lxJ4JDhm7YM0A8FcxP6JaqkaUjVPeq3zF45W/pr6ykwGydSy17DFw7fikp4oF65ZlYjI5CJwuY3yOpy2AErHdWRzJx44uvkfXDSJJZk0l1Bnpo6nwQcON9HKVTB+OGwgp9pFDjFeo9UAmKGqiVifgYsjhzYzS7fNYUY4GTw3zDm9O5yz9S+Pp9leVlxW910lGxi5+aZVrq7dhI1ZzkXqQ99XvLhLZBmRTDHPcYR4rkNlgDCwXTiC+pqFPG0bOJK5peWbrlB66hPe0TH/Q50Wyq1/JnBa5nzxJE+b8LnA4O1rV3F/ryylorkEKX3dvaooHELNmiuGrm9Kntl8gczKdpUOPdpID9W2BCYbAKI24vu+n6x0eyqROAhIj3NCD19q6CqSGMM7cwl1uLHuWkz90uM+ZKuswLVChG6z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi James,

On Thu, Mar 26, 2026 at 04:43:27PM -0700, James Houghton wrote:
> On Fri, Mar 6, 2026 at 9:19 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > When userspace resolves a page fault in a shmem VMA with UFFDIO_CONTINUE
> > it needs to get a folio that already exists in the pagecache backing
> > that VMA.
> >
> > Instead of using shmem_get_folio() for that, add a get_folio_noalloc()
> > method to 'struct vm_uffd_ops' that will return a folio if it exists in
> > the VMA's pagecache at given pgoff.
> >
> > Implement get_folio_noalloc() method for shmem and slightly refactor
> > userfaultfd's mfill_get_vma() and mfill_atomic_pte_continue() to support
> > this new API.
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> I found myself asking why HugeTLB wasn't included here; it's because
> we call into hugetlb_mfill_atomic_pte() pretty early. It would be nice
> to have HugeTLB implement get_folio_noalloc() and use the same path as
> shmem, but we don't have to do that now.

You are welcome to join the effort ;-)
 
> Feel free to add:
> 
> Reviewed-by: James Houghton <jthoughton@google.com>

Thanks!
 
-- 
Sincerely yours,
Mike.

