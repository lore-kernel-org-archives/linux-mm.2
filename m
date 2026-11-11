Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34FA9606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nPQ/W3tB
Received: by kanga.kvack.org (Postfix)
	id 3AB6A6B05B3; Wed, 11 Nov 2026 04:18:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 382C36B05B4; Wed, 11 Nov 2026 04:18:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2116B05B5; Wed, 11 Nov 2026 04:18:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0AF466B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:18:17 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94DD1A0166
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:18:16 +0000 (UTC)
X-FDA: 85422286992.03.FB92C3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0D1E01C0007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:18:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nPQ/W3tB";
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794388695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QWs1gzgqO1A59hoKs3tuMBi4edD/w8k5cYwrGVQ+cB0=;
	b=gfLMZQnEf7/DvcMoD5GbKsRwl6EUO8Yh7hoomMm3gudj7alRxM93ls5q9gAJDCsF3CKuFi
	a6LYA+KZDjKtL0771irZaLbEtFdSHDS3BrPEzZHGxbwJ39to2SO7J0CezUE1PwOkqNgtjF
	zF3qHhaR6WdxOQUcjIrn5bNdoaPmKCA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794388695;
	b=ZgKTjAKQ3wUQoomXCXkRzOUozggvea2KpLhxWcRT4NKdIHN20Hf2WttFrfvqVZniv01pBP
	xvgOsaOdPfFo3Vocw9IviQ1tOVIUB4mRI3hNfi8WOpemgbLupP+qsIvYziktTzcmZZnHEU
	48FBOERnDU6faNFWJ5hHNjJlDN8swCg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nPQ/W3tB";
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CB9F63BB0;
	Wed, 11 Nov 2026 09:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CCA1F00A05;
	Wed, 11 Nov 2026 09:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794388694;
	bh=QWs1gzgqO1A59hoKs3tuMBi4edD/w8k5cYwrGVQ+cB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nPQ/W3tBH7IXMyeKIqwMvWCKjOnatvPKh87fP3UWoe4psnTdQu3w//a4sVvyE5zyz
	 WF6vpLmRhLQ185mGVjNFBZhQ7xCxtNeg3hFPeJzQXaTIUVMFg/S3s9Qe1Cxt8RCkJF
	 HhDBZ6WdHgptQZ2NRfBJiRcBr5kB7SouvZozxUO2+UN1neTwxcLQmC61yWu1KPQ6by
	 gwpvXemy6XTmp/oBzm6UWZvKSQ0ZwHAhr3GU5rLIhfedrpY5pUWiqZLQpnLKj4hkNR
	 5zs8NjAKyNYimLPdfruEqZ6OUkajo6zoVMkPD0cWEzSrrHnr+VdqzG9d/rcN2NXPxd
	 95DJQsE3IFJIA==
Date: Wed, 11 Nov 2026 11:18:08 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kho: Prevent reuse of preserved pages after a
 reservation failure
Message-ID: <avQy0MUl6eOplwhh@kernel.org>
References: <avQUquBK6cO6tUUI@chrisdown.name>
 <avQg0_jFY3get3wG@kernel.org>
 <avQka0wY-EdLkspv@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avQka0wY-EdLkspv@chrisdown.name>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 9cke1kre6wdq1mt1tjezd5nyg5qib71g
X-Rspamd-Queue-Id: 0D1E01C0007
X-Rspam-User: 
X-HE-Tag: 1794388694-912270
X-HE-Meta: U2FsdGVkX181NiIGOBxSkuNtAUs1X3rhp7C62b3BIB+564HstWTeaLTqJ8oDUBvhW/PdgXgAK+dr+UtuMhdF/R6oXuWOMacH0mNDReGyigVrM7adYt5pdBa+3mORslE4hxg87S2Vyb2M/e8eTMOYuhgP968i6Y53qSDgDbaYmCPRTHd8eDy6deDUzwJZHRe3cA5Q+Pe3/+RwMFNPiMoRxOzov/qgIBGkYnPM/wu2NJ/9vUXQjg0arjaH3E+HeP2Y5Q48qlVhgoRXYuRVRhYrPoF9VnBVMIJ7o03J8LP7NDWjNbpOrzUAxFSidzt7ssMiLT6hb0QAOIClSbi4JNNfp9W8dVQunTNc6otKLHo3OMVelfqmU+9JSZo4BdaAlNNb1tslAvVRB6Mk0KHOqwgF0WlDx3ecNyfJl97yNf8k07X4vZD/NCzXxv/h+YFEBJI5owf6IIbMNH5WRloAGYFXPU/DonHZQrwrwHBAYtY81McCTuprIXUQy8WH6W8pSskxL6j2faQdf4ZhZ2Y72iV3x0LUf1qm3I5dR0j5rbpg3SeBx9Xik8T83YZJtaP2PW+iyhe61jEWWfYN3gwCVYEuOjKO7kQ9OmGTZaQb80jbZFwBa50HDLyNrJJhNQ9CRy8omQWKy/uUgTiYn5fL2xNkl1dcFFgpoNIAoUH0QU6A13/5qSwyc9P7K+ry6tMRUlWiXzxSNryKpYBWxYm4CG37VGysmSCRDunUgKd0orGeUk6x/xxiTnPi+rWlxehBJurnFseryB0WyH/1r5CpMx8ei94p6JUEjkzY8YLWTHs0JfRZBgEm1HqOhSqDd0lFjpUslB7i9JWM6nQDhzrM1q2270QGcXayyc+DztK+utJGoybNLbgi9cylmKV17tbTjM4sQql70/5HlNzJW/SWJY1hDy3pajYCh0alZn9cjhRpjNMdKqMPNB9QR9kqKfxwq6vOFoS4GZprKHDnRoO92eC
 y5uSOzg8
 HOTHc8q10j+CE2U7CR4vsowK5O7zo1V9o6x7BpJZCp4OSpE01VO1+2F9cfDIy4SkKPf2F4lJLV/JNNJyfwT/gqSw4Z7BnXvQhC9BJNQkU+Wgqrx7gULpQWU63ailRIqe+QmmKKfH87WvkGgVI282M6JHVviTX0pr6F2h9tTPYL2XvB/YJ9hpxDmtKkku+0KF7nZatn+D7qdvJNKtNVoALzMPO4iwusCQs1YjUK7kzdkGe6XtC61o/IDHvI3dLhtztX5R1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 12:16:43AM -0800, Chris Down wrote:
> Hi Mike,
> 
> Mike Rapoport writes:
> > On Tue, Nov 10, 2026 at 11:09:30PM -0800, Chris Down wrote:
> > > kho_preserved_memory_reserve() reserves each range of preserved memory
> > > in memblock and marks it noinit, but ignores both return values. Either
> > > can fail when memblock has to grow its reserved array and can't find
> > > room, which at this point in boot it may only take from KHO bootmem.
> > 
> > Is it an LLM analysis or you seen this happen?
> 
> Are those the only two options nowadays! :-) In this case it's just eyeballs.

Didn't think anybody still uses those :)
Kudos!
 
> I happened to notice this while preparing my KHO/LUO observability patchset
> and thought it made sense to send as a separate patch, since it doesn't
> depend on anything there.
> 
> It's probably realistically quite unlikely, I would think it would require a
> lot of fragmentation or a very small kho_bootmem=.

It's unlikely indeed and if that happens we'll panic on memory map
allocation anyway :)
 
> > > Dropping the handover at this point isn't safe either. reserve_mem=
> > > revives its regions from the handover before mm_core_init(), and
> > > relies on this walk to reserve them.
> > 
> > reserve_mem_kho_revive() can memblock_reserve() its memory itself and we
> > can carry on, can't we?
> 
> Thanks, that's better. I had thought carryong on wasn't possible because
> reserve_mem has already reserved its regions by the time we get to the walk,
> but actually you're right that there's no reason reserve_mem_kho_revive()
> can't just do it itself...
> 
> Looking at the code one thing we would likely trip over then is that
> kho_mem_retrieve()'s error path only clears fdt_phys, but not bootmem_phys.
> kho_init() then thinks that it's a cold boot and runs
> init_cma_reserved_pageblock() over the inherited bootmem which has already
> been handed to the buddy allocator, so this would need adjustment first.
> 
> So then, let me send v2 with reserve_mem_kho_revive() sorting out its own
> range, and making kho_init() skip the bootmem setup when the bootmem was
> inherited, if that sounds good?

Yeah, just keep them as two patches please :)
 
> Thanks!
> 
> Chris

-- 
Sincerely yours,
Mike.

