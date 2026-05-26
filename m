Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4B70CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 09:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D706B008A; Tue, 26 May 2026 05:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 173B16B008C; Tue, 26 May 2026 05:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A0D6B0093; Tue, 26 May 2026 05:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAF216B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 05:31:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B172A1611D6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:31:20 +0000 (UTC)
X-FDA: 84809052720.25.05EC202
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf05.hostedemail.com (Postfix) with ESMTP id 07C5D10000E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:31:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l+iWaZOg;
	spf=pass (imf05.hostedemail.com: domain of william.kucharski@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=william.kucharski@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779787879; a=rsa-sha256;
	cv=none;
	b=TEeVodaC/FVKqc7IiapBIQ5MWJ0WijyFBW7MnlwZStnrRg350pDQxjCwdHcMA5usgfdNwI
	wpwjRfOgtswmxKpszTpxqHnVklTF4aZNpk88C4zjfzGduRaXqELek2gvJS986lIAzvqszn
	IkF/GV2cqPEDeFjYpHHcNEvT5GY8LGY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l+iWaZOg;
	spf=pass (imf05.hostedemail.com: domain of william.kucharski@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=william.kucharski@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779787879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMqGSTNX/ruzLxK2F9/7GP9Wked/JMlEDdRD6w8SgUQ=;
	b=MQI4+BlQk9xG84V5HSpXw6ttMVfSuXGditFazsdjtMqQnKtdT6izT7NTVhGubb3oP9+5lG
	6RIIkP3tn9Edm5CILaJwsF1hlLkCNhoxnbXbIzUkqLsj98LyOFWbONnhVD01o6+GgtQEHL
	qiSieQICgrwEL8kCneqXeKNDLHH3ZvU=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779787877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wMqGSTNX/ruzLxK2F9/7GP9Wked/JMlEDdRD6w8SgUQ=;
	b=l+iWaZOgyJwBFGr9oefKDRKZQVlf/pzjINJ5Jc6x3rQzEONt6AzN6prAQJG7ZlGa4EVTKO
	EfwhRlk06EAwcbJqRtqkJy7JUz4uFLk2PYe1DfiVoGukTvh1XvsnZhlitXPIh1GwWw+Z5E
	OmEXTyyNWsI91UaCR+ptfieqjz/WwpA=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm: make mmap_miss accounting symmetric for VM_SEQ_READ
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: William Kucharski <william.kucharski@linux.dev>
In-Reply-To: <20260525145751.2671248-1-usama.arif@linux.dev>
Date: Tue, 26 May 2026 03:30:55 -0600
Cc: Andrew Morton <akpm@linux-foundation.org>,
 jack@suse.cz,
 linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 willy@infradead.org,
 david@kernel.org,
 hannes@cmpxchg.org,
 kas@kernel.org,
 shakeel.butt@linux.dev,
 kernel-team@meta.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <715DF460-33D0-441C-A732-D029EBAE4BBF@linux.dev>
References: <20260525145751.2671248-1-usama.arif@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 07C5D10000E
X-Stat-Signature: 9aib9btjg5t3mj18m3xr7gwzs7uobty7
X-HE-Tag: 1779787878-206400
X-HE-Meta: U2FsdGVkX1/nK+9YXvXtw6+79gG8sykGvu+9fNaMOXlQajPJdNEEACc+z/6tlsWWhbIonEFWKPYTHvQnDKJm6ra+0Gp7Mmvtr9O0YZ8n4OdqOynLxNCXXwOlcGG/dTZVAEdlIsU0VZTUdaRt+5e8WiuRbPGHfUIOhj985C6DrP9ousi54BFUm9yTa7HjxAbj9XGdMUXkswDiXW7hYlJQw2Mf5Sm8TYrjzjWyOc5cL7zaxccI6ay+ZIpjO1+Ste0CJtlb5gQ3Ufbr0hF3jTWMBg2VhjWlyLYH36DERYFlQH67agdwZ306Y7OwNUd1gLD02cj0iO8bPkYzC2eNNppArC/ZuMO7wCtylhnZnPF5vG0/oMgWOCHQGzbZmlwIdft9nBMDaYVFhFX8sqnX9HLgYY6a0tH1ESl9hTw4bewtBcdljBsCi2x4K5KrsY6L8xDZbNmi8E2lWWESOVsOdPqJPfSyuX8rfbgOFF0ssg64AV+6LrQGXq+1F5/eDCQ8F942f+UWTIEWaLVz6c5ZHkIDWbPBHed/2bKAZxT8wN8xWuMF17gflFXnWlKVl+/HizneU24bN3PppZIwJFV24IA1gTRf3MrNzGNZ5xcVZ3r5BBXd8Vt1DN3izfyAB38YPudZ+ShGlkufjDDr9DnN+k20NlOWAUUmUiMhCKQ31115QNJpYHTZlYuGCvpVBSw8Ajy/DxPi0AG821tDWIDMpBvpxIcY1rAGE/LBAMb85/vYfE7RhpaFp9XUMYe3OxQPV4uSW4FdU7/0/myV2Fp9k+iFYd7AAQb2cO+exHDYVqdO6DpX0N/tycBBlBwXD+Gt6HN7kL7yjmlst9cKDj08FqUPJ4WVA2qCzfyvZ4vlYlj6Dl7slm/C4ZKICLjC0Rxq36ulABA5ZzcuUf3xlx5gjU0r6z0UdaPCI7f1WqxPNhQFuSpRDw+sZfDBPWE6aRumI31SBmlfW4N5qpUjNiYgy7z
 bwfcxNoH
 7aMAFx+0Yz6xOPbWtr/VFLklvr377d9xSSx7hWUCqmPQIqOMgcsKk9LUieQQGEBubeeoX2HGWtoqMcvsT4n68pRc2S/hNSB6Mf4c565FflF94bywQ08BfZzABcpae3lyORn1ASSpFV8mgFZh2vFg2wu8Ek/22tU9acF3vdmy7Il7T9EI6pUwVlAve1EPWvbA1P5WimAfMEo6RwlZlyDxIUN3+TXnAyKeD/sA0PexIZoyloY4o1oX13rCBsGL4cC7ySQLI1lEjVJ9rLTiNisIeBsBLn1ZsmfTykwWZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good to me.

Reviewed-by: William Kucharski <william.kucharski@linux.dev>

> On May 25, 2026, at 08:57, Usama Arif <usama.arif@linux.dev> wrote:
>=20
> do_sync_mmap_readahead() skips both the mmap_miss increment and the
> MMAP_LOTSAMISS check for VM_SEQ_READ mappings, since sequential access
> is non-speculative and should always read ahead. The two decrement
> sites in do_async_mmap_readahead() and filemap_map_pages() do not
> mirror this skip, so concurrent faults on a VM_SEQ_READ mapping can
> still drive ra->mmap_miss down to zero through the decrement paths
> even though nothing in the sync path ever increments it. The counter
> itself is per-file (file->f_ra.mmap_miss), so it can be moved by any
> VMA mapping the file, not just the one currently faulting.
>=20
> Skip the decrement for VM_SEQ_READ in both decrement sites so the
> counter only moves for mappings that also participate in the
> increment side. No functional change for VM_SEQ_READ users, since the
> increment-side gate already prevents the counter from being consulted
> on their behalf, but it stops a VM_SEQ_READ mapping from biasing the
> counter for other mappings of the same file.
>=20
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
> mm/filemap.c | 14 ++++++++++++--
> 1 file changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 5aaba0d3e81d..cca20e350c95 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3433,8 +3433,13 @@ static struct file =
*do_async_mmap_readahead(struct vm_fault *vmf,
> * Don't touch the mmap_miss counter to avoid decreasing it multiple
> * times for a single folio and break the balance with mmap_miss
> * increase in do_sync_mmap_readahead().
> + *
> + * VM_SEQ_READ mappings skip the mmap_miss increment in
> + * do_sync_mmap_readahead(), so skip the decrement here as well to
> + * keep the counter symmetric.
> */
> - if (likely(!folio_test_locked(folio))) {
> + if (likely(!folio_test_locked(folio)) &&
> +    !(vmf->vma->vm_flags & VM_SEQ_READ)) {
> mmap_miss =3D READ_ONCE(ra->mmap_miss);
> if (mmap_miss)
> WRITE_ONCE(ra->mmap_miss, --mmap_miss);
> @@ -3935,10 +3940,15 @@ vm_fault_t filemap_map_pages(struct vm_fault =
*vmf,
> * In such situation, read-ahead is only a waste of IO.
> * Don't decrease mmap_miss in this scenario to make sure
> * we can stop read-ahead.
> + *
> + * VM_SEQ_READ mappings skip the mmap_miss increment in
> + * do_sync_mmap_readahead(), so skip the decrement here as
> + * well to keep the counter symmetric.
> */
> if ((map_ret & VM_FAULT_NOPAGE) &&
>    !(vmf->flags & FAULT_FLAG_TRIED) &&
> -    !folio_test_workingset(folio)) {
> +    !folio_test_workingset(folio) &&
> +    !(vma->vm_flags & VM_SEQ_READ)) {
> unsigned short mmap_miss;
>=20
> mmap_miss =3D READ_ONCE(file->f_ra.mmap_miss);
> --=20
> 2.52.0
>=20
>=20


