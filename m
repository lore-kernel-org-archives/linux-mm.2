Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 963DA606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eFkIqGEs
Received: by kanga.kvack.org (Postfix)
	id 9F18D6B05B8; Mon, 23 Nov 2026 07:05:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA4E6B05BE; Mon, 23 Nov 2026 07:05:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906696B05C9; Mon, 23 Nov 2026 07:05:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 703546B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:05:31 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F48F1C42AA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:05:31 +0000 (UTC)
X-FDA: 85466254062.18.EEFF822
Received: from mta0.migadu.com (out-140.mta0.migadu.com [91.218.175.140])
	by imf31.hostedemail.com (Postfix) with ESMTP id E162820005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:05:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eFkIqGEs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of qiliang.yuan@linux.dev designates 91.218.175.140 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795435529;
	b=mlxyUezdNvgUfl8zaQ48IXlujMXdsfGXzxrHUI0mne7MreOOVAzJZdTGz7L4QLhr4KKmdM
	1fNiGKnLM16LhihgtpRp8QI12kBlDCcbUDfbW+I+pT9wpebcLR3Sp3B0pvkkBKPxJE0ai0
	Sqr77KzCAWQgpiTXuuXlEbrSMY672MU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795435529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFDMSFpnPErRbunntFxo9TmJj7HbgxkIMchgGyOpqDo=;
	b=HHQyWH+2B8pFI6tZI6fo6uAmmEQ/2AlaVR4d6KZRw3t7b7Stf/J1BsHjSUNWKp2RY1qJEQ
	ftYD1D/tjq3iFkpTVVsr70TMAc47I3hjDqgYJZTgCtk831eiH9elX3lkEKrn1MROJcf05u
	Xbq6huT+394U2Ep4SzHTxdT5Ye2Uurg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eFkIqGEs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of qiliang.yuan@linux.dev designates 91.218.175.140 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TFDMSFpnPErRbunntFxo9TmJj7HbgxkIMchgGyOpqDo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795435527; v=1; x=1796040327;
 b=eFkIqGEsxjhzphH79hnrfhdUUbUVw96EA1/H3OfRimz6YmNFeW8E9UHTywVtecWVt8nhZk7s
 zksiW88VjvIm+lSLqu3zij6hZr7Yt9z6bxIrebc5HqHOKmIdaVXSyFAiWYxOw/KX9ihT4MZ3yPT
 gGK/dBLuRAjr+EHRToLz1bMk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 159dbe6bb404d09e;
	Mon, 23 Nov 2026 12:05:25 +0000
X-Mizu-Trace-ID: 159dbe6bb404d09e
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Qiliang Yuan <qiliang.yuan@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: flush the TLB once per mapping in page_vma_mkclean_one()
Date: Mon, 23 Nov 2026 07:05:14 -0500
Message-ID: <20261123120514.4141292-1-qiliang.yuan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <awQo2tg9rzMJYCQe@gremlin>
References: <20261123-feat-mm-mkclean-batch-flush-v1-1-7e998ad13251@linux.dev> <awQo2tg9rzMJYCQe@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E162820005
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: qnkrkprquf98ndnswykonnudsss1m5ra
X-HE-Tag: 1795435528-363018
X-HE-Meta: U2FsdGVkX18Q7qicDIcdowwYjIz/v53eZvj1mBn/zwi6FOb+H2tpyZNWQzKlo1zQHUAF4fy2BYc9ky1xAMBb91JwPhw1tpsqvtOWoVtQzRQtm0cHVC62wlV1FIsLg9cwyjAX8ci8ESmEZT+zmqiNjMKXM2tswoN4Dx4HCaHnjdWmJ1/iVaqttWE97qQAZmBsqrIAict0uWdtqyiPJ+iJKXvFL/Dp9MTlQXT11iHw1aPuEDZIB2+r1VvXQ6Cl5LSRnT2wH1PgqN624gKhRxM8S96lQOKEqgltAy1gUhMIawXoOdc4NWSo8nWI1En+xbApnVfbg2OCgUMuxoLM5kmvq3rX2n0xnIG/1mNR/2ctaS99XsFjVOJznoSChNNHGy/3TQdF8svGTgCvYIUMtBVI4ivc2mSY5OvKk05VkXwImIuOLkjLIBOU43gVe3D8pbT0iEjhtKsj3WpASdf94nK5OT+BhHHvOSPdIzJ2yShaxJa1KbpTD0jciPYjJ/HbGb2HxZ9GoxlzP0miKQcCUoiEhisABbuu40Wzi5XMUBGHp2jZItVp0S+JD9Smck0B8vwb7a2XO1qsuaojGwd1g4ALQC75aVy/MPGf1Bw+D1h2UfoL2aVMkYHd3QPE02tXttY6h83HZKvQlhBbTHGocz2+3Vu+RWnpapJ2S6+kn1SGVhPT5XCG2ZVWPiyCDmyWjWT1hu09dpcJtWOEoBeHUqWzWJOclfYD6f/ewuc+XF/qmXR9LKLIep7WeqYFwQ6M3Dj2r5C3uhWZ6RW6NF7LVF1rwwFij+9fm6ywcZ8eLge05fhpURFcKR+TckV7SbsFDfMSWsG3WaG4jXvyrpcrnrZPEx030VymlfqBUc976NmUPI/iWOATHGhD4YhMbOIbzKC7gYxO4IFiWNxP0QVGm8nLZs11D3qI7lxQr9GNQpN5YjXJVrLL/ZynoXtPe1Qbi5QdOiYPJT0AUvmL71YuTvl
 aNIkMdJ3
 PmnCUgd4q428orqIEarzEAUc2R1TNaCuGzuePnWfEkCwor192AAgy+Snz7tzTTaMXi2MEFSBbrbhc2NrYmV52TlMFl57uZ4STyjQ/YFUMOsnWZI63eqPbAZfSG1cLBNBcvZhH/He9xwXHISd7x8LXDjeHrr9qhGNFS8EjuM6+Bzj9W8ujjsEYktnuxpj613Ox7tiV6UKqdJv7yIB+COwX/SvMvopn96VgIh/gBhQAJcCoLPKSSmyDX0LsaAJRjC0M+QO56WVZtvoL3kAzuPX/Nb3QQ3H7MRiTkn18nZacuw/vybAZzanMifj9Cxiku+T4qYVn5MMfhtdxMJ8kWGkeweoUgGWWknjBAokYl+cTMPV4Oxa0M5HvlzVrB/U1UnDTdj/XQjBzX2zW9mRfErjLGUn7Qg/hak3ye92/OA2zLv57UbkJiiCmHhWOkRfDSeZIKvJyRZTEAbrZfl6VrQnTKLGyKKWOYNyAeDPmDYT3DLu9TKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 11:53:50AM +0000, Lorenzo Stoakes wrote:
> You are flooding the kernel with patches, 6 series across 4
> subsystems over 19 hrs:
[...]
> Given the volume both recently and in the past I assume you are using an LLM to
> do this, so could you confirm your understanding of the problem (as well as
> those of patches sent to other subsystems) and what real-world task you were
> doing to identify this issue?

Yes, I use an AI assistant. What it changed for me is mostly breadth: I
used to work in depth on one area of the kernel, and with the assistant
I can bring the same kind of algorithmic work to other paths and measure
it there. The patches stay small, a few to a few dozen lines each. I
test every change myself, with before/after measurements and the
relevant selftests, and debug kernels where it touches locking or
memory ordering, and I review the code line by line before sending it.
I don't send anything I don't understand, and I can explain every one
of them.

For this one, I was looking at how AI training jobs save checkpoints.
Writing a checkpoint through a shared mapping was 3-4x slower than
write(), and perf showed the writer spending about half of its time in
IPIs. Counting the callers of flush_tlb_mm_range() showed writeback's
folio_mkclean() flushing once per PTE in page_vma_mkclean_one(), so a
large folio mapped by PTEs costs one flush per page. The patch
write-protects the PTEs the way change_protection() does and flushes
the range once, before folio_mkclean() returns: stores through a stale
TLB entry land before writeback reads the folio, and later stores fault
and redirty it. Besides the timings in the changelog, I checked this
with writers storing through the mapping while another thread loops
fsync(), then compared the file with memory, on xfs and ext4 with 1 to
16 writers and on a KASAN/lockdep/DEBUG_VM kernel: no mismatch and no
warning.

I'd like to understand the concern better: is it the review load from
the number of postings, or something in these patches you think I may
have missed? If it is the former, I can space them out.

Thanks,
Qiliang

