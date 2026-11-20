Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52525606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 12:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R3tSaNjD
Received: by kanga.kvack.org (Postfix)
	id 746ED6B05B2; Fri, 20 Nov 2026 07:18:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F70C6B05B3; Fri, 20 Nov 2026 07:18:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60D176B05B4; Fri, 20 Nov 2026 07:18:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1AC06B05B2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:18:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 753E0140DF6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:18:26 +0000 (UTC)
X-FDA: 85455400212.22.D7946C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id CD9EF40007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:18:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R3tSaNjD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795177104;
	b=IgpIUZCYF00S6J/+m7sp5czvCtmqs/9d2yLK/gDiHkJu3F0p+SszIwrbcAD/RM6IgtU843
	sLAp7i+LnhD3OB4WucoLz98e9Gx66UJtkjIebb/SmR44h65lEO9ccbVqOxzFiSc22PpBiX
	Tup7P46uxCv1D9lLLDLO/qLgv3s09NE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795177104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQ7877NM0Z63f03vb+VlOqlB28yBZwRNNMB/tP7aaos=;
	b=F4fGzOvD9LXe9IkKCz5tEaCxEv9E1mVtBGxOtrP+sidFwnyW4CQFv3oS3n/h3IbGx9jekA
	0yHd3LN9VJEE7j2fOgxDphkO6X1Pti6kSpAIAxfC20g3e9S5obg1g8EKUQIkvIxBc3Ws5B
	TuQOStTv0ncjlMrx5MpUrFlp6zHPwL4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R3tSaNjD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BF1E62334;
	Fri, 20 Nov 2026 12:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D9A1F00AD4;
	Fri, 20 Nov 2026 12:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795177103;
	bh=PQ7877NM0Z63f03vb+VlOqlB28yBZwRNNMB/tP7aaos=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=R3tSaNjDrxS2buOBQuUnNft3p1BHdF0ka2s9xwRfQWYtaatHIYf/SIJftvDUBALXa
	 gnbmi74ZxRHOY8TDl38ZzpEYMermT6EUGtK8l3dyxnQK3T69h43DhYsDem5LunRyOO
	 dmZxC0Dj6rsbZRBqRW7NjwWYaBRddj6WAyj88uDgjTmtDybSyPfMn8ywSgvsPtmw4C
	 MLapjmkrXt6h0dWVWig53bBmuExExOROJrdvbwh99Z/zF6S9drRf2/N670iprfGybm
	 xXoX/u5l+pEqxFWpeS070GQxwIurW2WCDjb2Dl+S9+JV90SZJPceyVH5tBj+YKjaJX
	 KIbcGLf5t9ylQ==
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
Subject: Re: [PATCH v4 11/19] mm/shmem_luo: Require permission to preserve a
 file
In-Reply-To: <20261111002358.1842967-12-dmatlack@google.com> (David Matlack's
	message of "Wed, 11 Nov 2026 00:23:49 +0000")
References: <20261111002358.1842967-1-dmatlack@google.com>
	<20261111002358.1842967-12-dmatlack@google.com>
Date: Fri, 20 Nov 2026 12:18:17 +0000
Message-ID: <2vxztslb1yt2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User:
X-Rspamd-Queue-Id: CD9EF40007
X-Stat-Signature: tw9o4t1weox9q9qjanh9jru44jiy7ebz
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795177104-801530
X-HE-Meta: U2FsdGVkX1/f5H7bOisJn2sz3WttvRVQJXMm6J0LTBj8ounvor1M9eVY3WP1o/AIYVWA6bwi5cS6GDg7jFyLdzPwn+xo4AoVE8gwL9i5/IvS2CP6ZOjh7JhyD2FebNG2mvZUUmKQjlE0dVWDyen+Pjd4Ou6uUvuQhzi09Vc2fVaVMPLwB49jXMUTPYfNNADtHBzdgJHMFwM179YtF182VewsCDYZgdCUsWs8TFAc5tsISE13Iv8jxhTJqyYmyCKej0du/f8Gjub6STy4UmmV3geq48nqD1suIeACon4/AGb8FMTaYQrc1DfrjNWuwLO03f/7NBCqWqhlve6twuClltEHmfO7LQ2jyyE/OgE+FuNQLXIlYA3shWwmJy1zVSA2olxEah9yCOIt3FZZ6vtUXip0BdXoc6mwvuTm7uvHeajsFZMAOmuhL43DwBgfOyLOt0ritQlx3A1nouiktrnqG1nUmlCuGjnubwWriOhyYs8bMDBo0MyH40bKap3xGi+QCOtciky66CZn+meDFoAgN9bOCHedMJfxHAxvmmuQXIGf1pytyrO2G385RaEbszlC3XujBH/wNVHq0kP1n22ObH7cqLlXzXX0IolpyUXJpTb7wOtNnYFWd5+j2n1b8J9wD4ZU4047TR9rxWfvwv4hr/goVDsb9A7naW8SV9x8W2cQfZF5EKyS4vinoHIKWhi2TwHfP6k3gAwXgrOzNioqSz/HtxBO0e23PjXRiwqv8kDxWJk95eE8XssufUnVlUTYQjrrHw99Q9Lsgqx2A0YzEFLRaimoSV1y7Bh+4sgVWqWKtY9ArWy6xkAMYjI20W4K+ps8HLuneLIi6miKS1aWNrCjJ/b8BOUzJnlx7+rrymOTo9Z/sTa/ODAKhRmfaFB/sDb4NURwTMynDhRTNTAcqYIoRAcbeC6cx4rd8oolIzsnyWXTESzPK4trtOVXN19+vF8DKcRNUK/WU1PllQ5
 11tDekPl
 KgotNara9EOmbLu7vGeZFSKe24THTLSG3CG/denhWSRmGkKti08xfgiCtA+GPq6fXog0pfFr9eBBjLz1Q2hWHn0Uo0/0P6USnym0bcgvFXnVbPotTrn7+S6fsrw9HxC0b4XM4SqQrW+fp/zb+JCzdBFs11kR/DToRTcQZJl/J9MAFI7GRttYK3mqGeVj5KIM/smUkfdsPETVhGwAjXlN6W9ZgYEh/MOwA/mw7WdsE6MElrrybH/+M29IlXrE1EkpAqC8Ta77VKxw9TrDLr6LC3cXYf0ec81Nwo6ui6N73nfC9VpWttdLkP2Uxt8TYRCu5tVuNscwWQe5NZ7N0+vS5Oq5vJvkmV1Ed2oHlaW/nCEZn9jocrxMXz/4fG0dp64H6IC/ZLbVEWIusWWP2hEWBB4SCw2HaHtFTzI3alxRSKf3Dw2CV9I0jp6L/okdhwu3LzHf3h5rpUFv02JhgeKXyLCKKWPcWq6LH5JgdkAs2ee/+St+ct7g73OVe7GqPB04SLunPw49iHsdrDZSrTVY1JMCWkev7rKOyCnVIHZUDwsI6KIJoXTSlcPCYJw2epL2Q+zFsZYK/vHxlRkPYrWxVaUO2fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11 2026, David Matlack wrote:

> Require the file to be opened for reading and the caller to have
> permission to write to it in order to preserve it. Also let the owner
> preserve a file that is immutable or on a read-only superblock, and
> reject append-only files.
>
> While a file is preserved, its size is frozen for all of its users:
> truncating it, fallocate() and writes past its end fail with -EPERM.
> Today any process with an fd for a memfd can do that, even one that was
> only given a read-only fd. Requiring write permission limits this to
> callers that could truncate the file themselves. A file descriptor
> opened for writing isn't required, since that would rule out preserving
> a running binary, which can't be opened for writing. Only the permission
> of the inode is checked, so the mount doesn't need to be writable
> either. The size of an immutable file or of a file on a read-only
> superblock can't change anyway, so its owner may also preserve it.
> Append-only files are rejected, since their writers can only append to
> them, and freezing the size would stop all writes.
>
> The retrieved file can be read, so also require the file to be opened
> for reading. Otherwise a caller with a write-only fd could preserve the
> file to read its contents.
>
> Document the frozen size and the permission requirements.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

