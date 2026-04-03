Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25B43E7E371
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 11:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559CE6B0005; Fri,  3 Apr 2026 07:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A586B0089; Fri,  3 Apr 2026 07:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F9F46B008A; Fri,  3 Apr 2026 07:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2A1A16B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:19:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B23D313B51D
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:19:53 +0000 (UTC)
X-FDA: 84616999866.30.B73925D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 047E140005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:19:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FIfnoZ5q;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FIfnoZ5q;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775215192; a=rsa-sha256;
	cv=none;
	b=WCJL07esZ3ie8Cf/b2a92Ideel0qYRv/QKLFxsdo9ABfrXCUO8hBW6gUE2hpvgTyKKUR8A
	efq4Lu7EvGR/yVxRQ/QB0XcfDvu9hOriSgGI779tyAfkJncmFIOHpw5x/h4839befF7sHG
	E5XfmLFlcD0eGS0Gi9L0Kr3TJ+o6mAw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775215192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KaAOgiZxECAPK1B+kBXn7+r47g012VKDAHenGPUTCjs=;
	b=6C6HYooFzUylCkmLy1Ne9v84VNghalevTO2958eU5WzfAcPLEhP2RD8iUOmJs+BfU1Tnh9
	fLpHCJgCLXPIf/T00gCMCV6LQssPmTl1CgKXO6QnNfuVwldLNUDckhQY0MgXShp5xYlBgC
	z1o1ma39VQzYvUXtgPIu4AF9yh0ev2A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DFEE440888;
	Fri,  3 Apr 2026 11:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F51C4CEF7;
	Fri,  3 Apr 2026 11:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775215190;
	bh=hRrSUX5Y67DodyvbxDmfIiZc+tcYC4iUUoSxWjobaA4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FIfnoZ5qQxessDI+5NuWCseFDkD92kIvmF+Bkr/BNYTmAUBcMY0ue+bEpIvtnMES6
	 lPEN7268SRB5gRkMLFHvVd3U0dA6d03XhHuhdc28C4xmadPRl7Ulczx8S+r9RxmCK+
	 PC4BszpdWHOSXgA8a8YlhWDLJ+gTyScVwn2Yg48N6l3eYX7VjQ+MFZGZ4lotKIUvZb
	 u+0OAoyGErcYBrIwTaqEgJkjhRWz65uZCiTlU/ne069HRhqBYMrTgqv8dTQRu3Ub5i
	 yTox3WKhYjGwhDdfDtfjGMjXwKE68aQVQg5rUIfwNAYQbBlADCQK/bsNKkv8S+kKM4
	 dB3Wj8lqwkqag==
Date: Fri, 3 Apr 2026 20:19:48 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
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
Subject: Re: [PATCH v4 02/15] userfaultfd: introduce struct mfill_state
Message-ID: <ac-iVOJZ8B8MLOl4@hyeyoo>
References: <20260402041156.1377214-1-rppt@kernel.org>
 <20260402041156.1377214-3-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402041156.1377214-3-rppt@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 047E140005
X-Stat-Signature: o9tw84fpuxozttpoaqes8gdifjozkfxk
X-Rspam-User: 
X-HE-Tag: 1775215191-357406
X-HE-Meta: U2FsdGVkX19gdJVSuU9MQrjxukiemB0xY284XF3U0pevQklU8VAOoKsUbusV3ujZtScbhMXJt0NcVSp8bT7E8gd7PsRS89l3f8L/i75ZGzIOauyjFy+qi9uXKoNEXQtIdZjV4SYXChb5NVRKhNrmTMx4HKvNHm+G0s177JoV2GM18o5knULVJrJOJT0HXontw6+yFSLmBIFCNBoqnpPL3AjqqsSXco7M90pDRoZIaxW3fkz8WZvM8xEDuEMOBrodiBLGTiTM58zepGd/jF5zDCsJtMGShJOB9r6jtXvkI2stayE8MqPrsZsHsDg7uxH2AmM4dTytakO/QsYZOjykOwpta9K+BeHpGKHn/FgSlkiWG5k9mkkAIP/OlX7RU8LZzhVWivbqUCbBMTuXmOoVxC/fXRrVBopfTAE6G2EtHHgZRUqPbzJhd+wK4B12pY4pavOjnznyeosrVbgHarIYGfzId0uPq4U+m5aUtBDRzf3ha85hI96G6faw0m6bdlydSkTnZnYtHThqkeeRvflDV27hxTSdndbfnvkBnEYAEoKBHrhlBS7kbW1fpeMw935PWGhGT3ExLVSqPPjKfvucSmShVSnUw4e3u4iTtUbMWt7J7fBZSU+ynrqGhdsqozPrRfW8fqD44Gdfwq3/n1bK5dMsS6e7gPjZdJljsTybmgt5QVKa8XJzWNJMUsOWMLQ5GKJaPTThykzaICmFfkyQEfz9lnEi7dsjeuxZgVog1JyZ0HVBNqY1AK1n22P4C5p07h5Yg+DFur0825x3gmj1Nx2UsBcgKfCv02brqAsVTDS6W4YYEe5jopm3nl5x475v0y7dYe0xmzG/8rVFo0HBQ6jZ5V8nKzLFgExz+1R86TMJgDZ/DOSnq1ZBQGjGqUvenyZr4M0etQryHGzvYvL24voLB5UnGFyHzUeraJaxBuuPCA66rgpnxFGkrxTGLePEVzlsoLVuTmfzwmXR0+S
 etQOk54k
 08p/87Lcu4mF3U+e6FrWTbaKXDECga+Md3TGLU7XnQqs7hUFZl5HW2cuMuCreisZjmibT4qBKhO0J9/7ktbi4NfqPEGDi6nN0Z2qRBCsNvnvZvlUwaZb5dEAFLVrziaeh0rudXIjDOKheYILPGYP6BllGgA4PQQBcFqr+rVhxKX4n+AFK0ahZAsUFcMge7bCViRLN//62w6LdMlihubDnAJCcI1MQwWzIKP+hYuvWIK6ffIBo7QDsH43U4XrC0R3isF8Ua3JuAXKcf9tx50vHw0cr2xKhWQE/6u8W7XC2BTre6YatVmhOGcNNsXgIjSjCCgYJg+iMB4ReGLcuEhrMScHONmmy8PuWI6gX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 07:11:43AM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> mfill_atomic() passes a lot of parameters down to its callees.
> 
> Aggregate them all into mfill_state structure and pass this structure to
> functions that implement various UFFDIO_ commands.
> 
> Tracking the state in a structure will allow moving the code that retries
> copying of data for UFFDIO_COPY into mfill_atomic_pte_copy() and make the
> loop in mfill_atomic() identical for all UFFDIO operations on PTE-mapped
> memory.
> 
> The mfill_state definition is deliberately local to mm/userfaultfd.c,
> hence shmem_mfill_atomic_pte() is not updated.
> 
> [harry.yoo@oracle.com: properly initialize mfill_state.len to fix
>                        folio_add_new_anon_rmap() WARN]
> Link: https://lkml.kernel.org/r/abehBY7QakYF9bK4@hyeyoo
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

