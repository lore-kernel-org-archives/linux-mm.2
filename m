Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64632606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 11:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XRmupP+O
Received: by kanga.kvack.org (Postfix)
	id 87B746B05B1; Fri, 20 Nov 2026 06:55:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B266B05B2; Fri, 20 Nov 2026 06:55:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741796B05B3; Fri, 20 Nov 2026 06:55:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 532AC6B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:55:54 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF008C0EDF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:55:53 +0000 (UTC)
X-FDA: 85455343386.21.BA452F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 35A04180008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:55:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XRmupP+O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795175752;
	b=4hUnrwtPWWP98h9gCtlF0xPtivOw9pBxnJ+nQnTNMuN+zoqqAiQJQ/LNxbxA5ltViwBPDh
	nUipceirjBqtVLSHct71LvF9igK/IsJ8I83tAo7a03yQNozovxjGEAn7JJtLmNNOUVmgeK
	i7SzB48ieThmmgIOZUnKX+JyVay0nOk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795175752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P3gyj12NGt5BrOAVOnJOGDgKEsVMdz42lpXGv/yZrc4=;
	b=XqPG3f7VFyv5qtei7+h1L9fPagpf0qThLKSH0s+tzrfiEU7GZ1mJDMkg0Tnpw0gyUj6zRq
	0HUz3d0REQBb0e0+UR+xfW/JoOxJpr/0LNjL/eycOPT+zpfp/tH5/HOXm+ZE5J+np0r+6j
	nBF/JCM8PgKHdWn8eh0i3QhB3SPjQ1o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XRmupP+O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3317E40467;
	Fri, 20 Nov 2026 11:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF9F1F000C4;
	Fri, 20 Nov 2026 11:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795175750;
	bh=P3gyj12NGt5BrOAVOnJOGDgKEsVMdz42lpXGv/yZrc4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=XRmupP+OLijrmAtsyFzXXifwkuMS8W6gNVR4LOQJPmUXO7GcnqLiZxj7w2peSSlsu
	 QMq1FxF6ebx+N5vGd+gPCfWv/hQdtBeT2ynxnVrf00EB2x6ercEW9SIcOTFr6/Gg+0
	 +0VZoq0mBHSiGpSUMlOovIy33ZXnen4fS+2fARU6pJbnmbFK3EAr2ic61lpeGjOwQf
	 iFH9PTAknNIhVdp95GGo75mLA233YHUQfa4N6a6X+dOkSuSfPvhInvrsgbZRJm5kOG
	 X4YITabmy70LoUjGg+Mx9siucKp0Y9fW03PE1MjQGJywW/z58DOrX5l+Ovs5sBRMsQ
	 9qqDxMCNtyI/Q==
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
Subject: Re: [PATCH v4 09/19] mm/shmem_luo: Leave freeing the preserved
 state to finish()
In-Reply-To: <20261111002358.1842967-10-dmatlack@google.com> (David Matlack's
	message of "Wed, 11 Nov 2026 00:23:47 +0000")
References: <20261111002358.1842967-1-dmatlack@google.com>
	<20261111002358.1842967-10-dmatlack@google.com>
Date: Fri, 20 Nov 2026 11:55:44 +0000
Message-ID: <2vxz33sv3ef3.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 35A04180008
X-Stat-Signature: 3w18mpzir7o5qnabe9rhgq6f5kixcr1b
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795175752-353351
X-HE-Meta: U2FsdGVkX18DLs8Cjq5c+B+tZwwJtFDcmOzjjgfRG08frv9qMA6vxgGGm8tI2C8dVvlusFycEGEqowZuf1HucsVT8kM7VJSH88qq1s+JKxQejDyT6xuDanrz8WUwjc2jXTMP+nhm6NOTYRO/uGLr8PZMII/SnsAfx04GybWi9meU4tVQmoR1VEm8jcmDSVDD40bZA5TiU/7mQ1U9Ro3rivexO5NmMhonQKlhH35hFQR9KzbIZ3BavhL7SBf5p1VIPSxloazlRPgUuJ6SjGh/zNxUqMOSriDs8GMiDAq1qLvLRJZKzFGr9DCnwnX/BQKzQH6xY7PVU4tY3zVDrDOJXKBLdCbvRRtKyf3lSX3z7AEqkEbH6ykPjcZGYellx+h1rBhR6I+zZpBjwLiw1JZhwX+1fRp1FfDRodZFLCFMHQZan3u9CpCHCmtGl75Iy3ArJNi5RBQBiY/8mstqMsCjbr8ZgUCZUDo0CZjmNEv9l0JjXBtKSstIXw7VVrlh+6stWKDBnKRSTdrUB7Aem8mWk14y0t/qSjmjzEp7SZ0FMm8o/p0Rehj/a9Wa6e2p48EP8Abmm/CB54catTPoNe3T+i4rrcqGbXsNnxSPuk+tXVu5MJrFPn5Z91euawbTvVbSKgt/Bdkw0G73RKhOe0kiR5X+MvBkpgFyS/x1vyWTMzRnEdWyp10D2NJ/OKm54IrDKAOlY3xxrrY0MQSzlH3jSrsFzJLo25dfkW+EsDJEK/xWS5N60sLoT2kh8U/wjXcF2ALjqPPm6MhRJEL5ecSS5bNB/XHrwV0HyHUIAyT6uWqZ3BezFsqZ74yXHmnz/3hwvUq82O9DEQccciikGd7kn6+2PvS4G1f0IH56DDFTGViOB0GSigmz3rmq0syp/xhvg8cTEQqyhvLUgWRksyPWE6JoByed8rtEvgHRofBvbvBvUaCrIb75qTIGIhGe5NtScBll6wU2r9uHQZ335Kg
 Y4FvM58D
 y9tli5g9uYp0GNjK/hQG7cLPhqMBAwU7YSEX1s1iDEZVn4APixgxjuAvgERZAHAHCk1/a2rLzd/2PNfxcPbOFAjSwS2h4thkrL8ftUw0c4NHC1mBCKyn9krtCLzwtvd5dRAjJ/bZm0X28fpRhEnVMd6TEkCYarUJcEvRjfdv5POHNMTcmwStgTw5BZeBCpakRtY61xLFsQObO8SJLV9IpExwmqFN8B7uezp1fCQGHN/ZLQehA1SGKYjVdUL1xrCbpFwdb7+RPz8JVvcV+h5idRSTh7sCqZwG0I22XuJ3plQR2/jXqVnlRTkKY48WzwLFjKTOfosSwjI5YgsODEuh/7s+M2BnWGpr6e0JSHdKqXDvqkpowDhmjN6WMay0XUJKuegv2UrEovUE1g3NXXiL18Ja1GXaQ4jmnu45FlyAQBV98W4xt7eG6jyW0gMTAfqikrRZy/rl+T6hjdnaF2AeDWrX9YVSIq7Z3SwEVx+awqbVREjC5eA0YnP+0cQGzA9/3oOYeMj34jMAI5mNK50QeFTl/uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11 2026, David Matlack wrote:

> Don't free the serialized state in shmem_luo_retrieve(), whether the
> retrieve succeeds or fails, and let finish() free whatever is left of
> the preserved state of every file. Once retrieve() has restored the
> folios, it sets nr_folios in the serialized state to 0, so that
> finish() only frees the rest.
>
> This fixes leaking the preserved folios when the retrieve fails before
> it restores them, e.g. because the file has seals that this kernel
> doesn't support, or because memfd_alloc_file() fails. The retrieve freed
> the serialized state but not the folios, and finish() then skipped the
> file because its retrieve had failed, so the folios were never freed.
>
> Preserved folios may also be in use until the session is finished, e.g.
> by a device that was preserved with DMA mappings of them, so they must
> not be freed before finish().
>
> Fixes: f85b1c6af5bc ("liveupdate: luo_file: remember retrieve() status")
> Signed-off-by: David Matlack <dmatlack@google.com>

I think some of this is already fixed by [0]. It holds the folios until
finish, but only in the success case. On failure to parse seals for
example, it leaks them. Except, as Sashiko also points out, in
memfd_luo_retrieve_folios() the folios are freed.

I don't think this is strictly related to your series so can you please
send something on top of [0] to fix these bugs, and perhaps drop this
patch?

[0] https://lore.kernel.org/kexec/20261110175855.2437084-3-pratyush@kernel.org/

[...]

-- 
Regards,
Pratyush Yadav

