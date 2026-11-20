Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F86606A330
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cnhVylqs
Received: by kanga.kvack.org (Postfix)
	id BF8866B05B5; Fri, 20 Nov 2026 08:55:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCF996B05B8; Fri, 20 Nov 2026 08:55:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE5116B05BB; Fri, 20 Nov 2026 08:55:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B7506B05B5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:55:22 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 236E5A8F4D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:55:22 +0000 (UTC)
X-FDA: 85455644484.16.3D1673C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 926AF1C0007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:55:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cnhVylqs;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795182920;
	b=06i/Y67gP4v5v0qhTr3d/AiMQ/OrMzSdXUwAP7dD6OMp//V23BUm4Azjw/Ik+RNyMBulnh
	8mOZODK07ZfFa1lNfQBOjK+wCNmVLEMHK+kO3Bokjxr253QYKbb5DjVwvM7z2Cb39/4ECD
	W1sE+Q2EtJO6vlU15fSS7Pf9xjLbq5w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795182920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K6Ek4iGcbq3vQ07GRWmSQBnPhMgNe+rY+J8oqtO23vE=;
	b=d1ZQibbkqPU7xoyHnk7lEL28Ez17W7F8oFqGVPN6hG686AOOEFOrocvCbRazTVQ6mHZKtw
	FWpHlz/2vhu1hNOfYgmmrCW3wIPbmP+Zr2G1bpogLtaT9hDxTlaa2dUxdsBvx2YU1T+DOD
	QgstHtLRh5FDPpxJkcb1F1ni0t6b7hw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cnhVylqs;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 256C361912;
	Fri, 20 Nov 2026 13:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0C91F000CA;
	Fri, 20 Nov 2026 13:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795182919;
	bh=K6Ek4iGcbq3vQ07GRWmSQBnPhMgNe+rY+J8oqtO23vE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=cnhVylqs5ES3JxvaYjPvjapckpsryCakLkf58K6cdu/yj6hEpK55l61/r5leNICKo
	 27nkXsy8zKUdCQYesScKFBHbzuGcGSMTih+K4Glwu9mkcllzFD6NIpLxeRhwpSbtMC
	 8Tfec7DkiYTiaSZiSkRmUJmpAOFLegUbO39jNFJfK+g4mT0xpEX0u8r1ziz2VFRy0U
	 gdAk5alXFHUQX3rzuWjGG9rreAoYk7Is3htWwhisfUatj5QU3Jwe0ghmm8AbUKx+GH
	 MNOwscOVMcGYsVJ/tbFp27qzAeWLDbB6s2DJ/r6JsLVSupBwX+z3TmQJqYkNS6URJ/
	 JYvAfbSkIEcpg==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Christian Brauner <brauner@kernel.org>,  David Hildenbrand
 <david@kernel.org>,  Hugh Dickins <hughd@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  "Liam R. Howlett" <liam@infradead.org>,  Lorenzo
 Stoakes <ljs@kernel.org>,  Michal Hocko <mhocko@suse.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  Randy Dunlap <rdunlap@infradead.org>,
  Samiullah Khawaja <skhawaja@google.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Suren Baghdasaryan <surenb@google.com>,
  Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v4 13/19] mm/shmem_luo: Allow preserving tmpfs files
In-Reply-To: <20261111002358.1842967-14-dmatlack@google.com> (David Matlack's
	message of "Wed, 11 Nov 2026 00:23:51 +0000")
References: <20261111002358.1842967-1-dmatlack@google.com>
	<20261111002358.1842967-14-dmatlack@google.com>
Date: Fri, 20 Nov 2026 13:55:13 +0000
Message-ID: <2vxzld6n1ubi.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 926AF1C0007
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7s3irzhrwty4w7caihr1e3jmahynuy6h
X-HE-Tag: 1795182920-66017
X-HE-Meta: U2FsdGVkX1/RgqCjWoFRIDZNhsw20GKFKK8y3/Vek/aT/h/MyLLkZG57oErshiWABsBAOCbavZt7HfnbKUMKyeqAWsmko5fYSNyIj7vL2n/WPiHct29G5pt8Uin+ubZQaQN+eJ3QRV3bgbihx3ZrwB591ayZ1UFDJ/dbsLb/CfoFgBTe3PTaeOlC6KyxFc9TulNtW64UFSeSEtVO68sjpw6JfjcDOBrZQKNsn4YUMj36gkUu7Vadd9PH5blvbg+yMOjf4m9zn4uBb/3AAORUuF2ZBtyoNfSzU7y6osDB+72XAPmdw56ZqrPYhnX397xl8MZLc8U2HKiW9xMfygKePVtxh7oafWS+nJ06EMUQl3plFobdo823bhFDWnrK/GsbOZBiJKtm49nMQhPXc4Da06MQH2YvcMA01eeHPn5KqQNKaTQFD+69tFtHFuEPf2aItSrSEh0pSXB/X1wmmfozWp0A6ZQPu5WGhAS04dnOmc6YnDRyia4QWHdwDKlF6nqakH25imjeNdkgjKJJ0ba/SuJMGAoAhWMrI2tof/tE1dXNzkpeqMNHiWFIvP4TVHk8yLtM5MrjYyDHf/i6zmf/TChUW1K0qyJZDWnMkb3ye8lkOlKXGttJfAy4t1TPuJTKZr8v2FblB4W1swFu5cDWZbjgPUqbMlXnW54xdsOPXb7tLMG/E6bZOUblfQlNebf8O1XVxuQEK8K4iN+Sgmpxi+J7qflPasKIFKPM0T4W9lmI5X/MLxjbsz0dX+4T1SyO0I3Z88hBde3azk6RG91Pz2WaTtxCs6E7QaPc6dLoi73KNxTsVXUNZS0q54txFK/JpsEkE9kPDWBQ57elkSBBVtn5YEuFV75OUmROkTZQODr09ju1K/MRSnrWQE8KtnpBNaA85ztXqRf5E9xLBUUEBcMEjI4FiDBJObYfLwgXOrLiXcNz05X+VnXccPsnm0st8L2CbxUUEs1MtLUzHyW
 MC0/0yFT
 hLWIbVedalatkC/9zX6EyKj4Bpso9dA9qx2ksc13vgIqdC2bVNiWKRt0josMBLKpd99CWUqcUBLh5MW7GwCBOg0aYr7qF2g8Mw5XcgJWIL3NA8RfiD0nTFn19Zw0hwopNr743RKr0GiCZPgtAq6rTtybFdwDeyloOD4/6gdO06GewyticcksDKZS4icZeXdBqe9TmQLynqeR0O/7hVA6I4deBW/QeWEV34L95/NkoI8CJhu+0wtZENFKXDxrowtyx8CPoyD1BTxb9W3xL+bLDvn6Ftsz9p74dGiXYTvcXc/LXvjJ6eRG5ag/fvlG41OZfi+xWA1qEW5Xk1FC5UYvkAO0jZjUruqgNFG4mcggwBVW3MM/7kml5LRNb/Kz7x3bf7Qt/HsBs+H2gQt+QBa80ZH2QeJwuFJo7SRVi2xxr39TVRGmaEP52sJseIgWl+XSimZpfsq6EqS8zkiAKDRYt4xX0tDlYwTESMpbX3KGQi886fCqQqHe3gfA1WIFeXjdoLoyQ1lSCDKQj5I0dArH0vAo9G6WCHkm6+QIAnyxcSs4L+vXDOdNwuzg7lfK49PJYCY/nKsggh0UgVwx1vWbhxDnthQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11 2026, David Matlack wrote:

> Allow preserving files on tmpfs mounts by dropping the link count check
> from shmem_luo_can_preserve(). The check was meant to limit preservation
> to memfds, which never have links. It isn't needed anymore, since tmpfs
> files are now retrieved into a file on a tmpfs mount.
>
> Userspace can keep using a linked file by its path until the Live
> Update. The path of the file isn't preserved. Userspace creates the file
> to retrieve it into, and can then link that file at the path it wants.
>
> Preserving a linked file affects everyone who opens it by its path,
> since its size is frozen while it is preserved. The permission check
> added by "mm/shmem_luo: Require permission to preserve a file" covers
> that: Callers need permission to write to the file, or must own it if
> its size can't change anyway.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

