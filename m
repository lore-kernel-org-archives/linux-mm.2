Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA048606A33F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 18:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FtKR3jM0
Received: by kanga.kvack.org (Postfix)
	id 00D646B0608; Thu, 19 Nov 2026 13:26:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24456B06D7; Thu, 19 Nov 2026 13:26:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E61DC6B06D8; Thu, 19 Nov 2026 13:26:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C696C6B06D5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:26:58 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 522D5A0C05
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:26:58 +0000 (UTC)
X-FDA: 85452700116.03.77F1968
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id BA34A20028
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:26:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FtKR3jM0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795112816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DZ4mPEBjUmR27wH31ZCXCx6rDwt85HZoDNwiNUBwYs=;
	b=0fEQrTM22I0Q9ZLwxsy0qWEH29HQXxKdRkX59fHgu6gjhincByDRvhZ+QdDJ0lTzG6/2Az
	QQt18O29nEBxW85HfWXFySjfW3ltN7/GALyiTEbpjA5DbhZ40F55KqQMFsJATI29ZF3sBB
	TkxnXzKzG1eKUdbLG+7LIMoNFS08024=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FtKR3jM0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795112816;
	b=uQjzFmI5xTtlku7rzhhBSWUSKkqZl3TpyuB7xZlzGwzwU7Nlx26lZOBmCUxDgP/sKxVMfl
	au9GH5oW7koEUBRdOM04Rm0/RqVEQH25gH/5wME74f41MwqJvJKhY7Nqe1MpEyv/7WFyNB
	JePosNBdva60PyyOXv8HaLx3hgREo3w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 11E9D4424B;
	Thu, 19 Nov 2026 18:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9052C1F000C4;
	Thu, 19 Nov 2026 18:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795112815;
	bh=8DZ4mPEBjUmR27wH31ZCXCx6rDwt85HZoDNwiNUBwYs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=FtKR3jM0xbMz1npQDKTHSOZ2Z4Pqwh6sOxEWnBVmzin2nJEBX9dwZ6GQW93/xmHwC
	 tL1SyEGSU6oZwiCIrBfhW/d3dGUvgJQjlW8e+XdOHnmaZ+V9CZacMN74agW4bZascV
	 SOR6QYNhxO5Y+Eq/+XuOO/tH1gJjaPFoxX9grfqpz2ClL6gzRP/nF4LpaJdumhvSkA
	 2fMdt690Sgjg0rYcGIOfqJMiDzjk3DvSkCwAcop2sQQckLPk2uNPl3i4gfU8ia62ky
	 xTVEV5ABSlC5K9ysPF6CKr0yoJqZrO71KwHfANKR0LiDTGtWlM55ThaPE9RQ9VVNLv
	 YgWJbKeiEFdQg==
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
Subject: Re: [PATCH v4 01/19] liveupdate: Remove the list of steps from
 luo_preserve_file()'s comment
In-Reply-To: <20261111002358.1842967-2-dmatlack@google.com> (David Matlack's
	message of "Wed, 11 Nov 2026 00:23:39 +0000")
References: <20261111002358.1842967-1-dmatlack@google.com>
	<20261111002358.1842967-2-dmatlack@google.com>
Date: Thu, 19 Nov 2026 18:26:49 +0000
Message-ID: <2vxzv75s3ceu.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: op59ig3cjj5ahhupfawqkpcrhcbdqatp
X-Rspamd-Queue-Id: BA34A20028
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795112816-525101
X-HE-Meta: U2FsdGVkX1+8iWQECB0uLH2ML2VOCGc6eFiH8Sklx8En6BOP+h+aSdWOfWyZPh4L8J41w43hEM1XYMAGL6LRh+5t3Engb2Qr6B+KqzZ/4ZIXY8k6zQRlXodMw4G29weexRfxoM0x6uoP1+zlyzryfEJYMCeuCRq8CRWX7JBvYa3uYMeeyjy6OE0Y57Jq+HfXIgWN2H1NOqhNLVS0bX7jGtwNWEFqhXcqh1tDv8kxaEQ/kCX4Dzdl2EpOvju7YPBDnFESGJD1R9kG/912O64zZ1Eyhmp3GGCvnoyfWmTt8yFwQvJqlIlU6T+HKywAGLWaidZpXT91S/Rc2gF3JnIPb+WogvzMEb6IIBD0kDA5aIvnEJVWho/0FhktqCgGBad84lSEvc4Hv5MbOK3RdRslQdHGnXlUnJiizbPGmzt0mCCOWWG7kdDkThmlhNxLoxGXeqOHog4YgEzFRMmbY1S7YMw+5e5Um9CHkipDowT2XA1aIpnQkuL2QIBi3PROJWKmgLbtqNN93wW34zAis7MP5Vxu8OHowEQIyUG3b5AuH355b09q3DAb7KrKnGikezDO6mhnkRcc3pjPzYRCwDkI3BHLoI0kIf1VByi8KBGySJ/lKvBGqHGPZHXd3v8k0uBmQ3WreNVUu2kVd8+9sppZxb8aidlNB8p6RjY5f1aBA0FxG/i0gaX9WL9eVAjquS0e5UVTqje5FD5wdYglyZ8x7y3uchXSxOChcPhacSlCSa8K9HafGgDEW7Uzo3Inmg0xMFUFN+xSl4t5gu21srQRDn/Cdojcdzd1dgEKd9jPdIpTHzXiRNVJ7Dta/MVdbdWb7C+15ZPR4fPMMtMazDaPLg2DcNqTzOoMEA2Wx1Jh5zsJYoGWa0CWqSaaiJS3CgTV7nmtLstHDJFWoqdJ+NznE11mj76WS+7HP5gqgBDPCH9itY30N3degnao1mk1a1gR+nD4nc+xI8l4ZmjD+j0
 btTXKHr+
 g4sSc3Tj5dzNPtkWzD1L11UjJoD7Dyk5LcbYoHaO8Mi7NscDCqn9FahTh09YmnGqzuzrPiZgGvDxSsUm68aFSVLYo5S7CYdmFkp5T5feNyfdONXsbq7VDOUZCObLeg/0TLHZ8c1MgD698r1kUitssQhDadx6Q4gZ28mXVGlROgikh6a6NU2l3VNvNoDZyXqvJLWBzwnUPFmOKMcM0v6IXW2uKr9Hs1ys4u4adnts1mU7dg3FkGmCKR/gUNpno6rw2Y86p7LElnW6zzjuh6HbiZ0UgMyXyC2Um5gPgKD/KfUetA8b1mKEpo5Q8vQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11 2026, David Matlack wrote:

> Remove the numbered list of steps from the kernel-doc comment of
> luo_preserve_file(), along with the sentence that introduces it, which
> repeats the first sentence of the previous paragraph.
>
> The list only restates what the code does, and goes stale whenever the
> code changes.
>
> Suggested-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

