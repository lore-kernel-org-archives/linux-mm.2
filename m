Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EDCD606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 01:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f+s2Utow
Received: by kanga.kvack.org (Postfix)
	id 93B6F6B05B4; Mon, 23 Nov 2026 20:21:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ECB56B05B5; Mon, 23 Nov 2026 20:21:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801E76B05B6; Mon, 23 Nov 2026 20:21:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 480366B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:21:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E091160A3A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:21:34 +0000 (UTC)
X-FDA: 85468260108.19.0EA9DFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9ABF7120004
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:21:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f+s2Utow;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795483292;
	b=lksfEr398yWMmC6P42+F20LJauyhYVw7hx95nYoExaMEhekQQWixD8ZLF4Iu2EAHQb8Ue6
	doO/GCmqTR4t3oRKx2HwSzqh2H+EVgVLjmBlHXPEaThQzG82fVEq1XLyUiuiC7fvRDp6Jn
	q/KzNHtftskjj/eIeeXmchLwARMz5Hs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795483292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IAXmygWx+MtzlQfD/THE5tctNVDaMp12YBsy1SVW570=;
	b=HTuNBtrvxFpmBv1hl7tQ3HKm273HJtVKDMVxsCG14O7svdZC9T6kjJOb/aGcF/hf+9hCJm
	KzSHyTrsrFiPqj+zpFzNFzRHg3gNkHC1JyTG67B1xPiwllmgvR6Qqo3R9R6SrmsEgrlotQ
	cOcUrqstwBNOwGhkU3XWlaKYbGAmK6s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f+s2Utow;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A3C945676;
	Tue, 24 Nov 2026 01:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B627A1F000ED;
	Tue, 24 Nov 2026 01:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795483291;
	bh=IAXmygWx+MtzlQfD/THE5tctNVDaMp12YBsy1SVW570=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+s2UtowwOrLJ3ihcP60KU1bKjQQFLBXgytIHqewml1nnZ/HXEb2s/OJgGTPNUsnv
	 HuWJPxNI1i2G8yyC01UzU2ozv2+3qWjD+NGmRloMEMGoFDTvUKpckLtSDJagu9MLEU
	 UjKsLgHhJs/iEmx85YvcgISXLJGW4E9ZZ019YNeOj5dcmla6Ic4xAr2ipUXfGU2ih2
	 PTSz9wnth/XnpLl5mspXgWCpgSiU1Dbhd9UgubzqNAzsNYSIoajJQxRjzlRjOK7cjT
	 mPmAqxbhJQVL5DBqbMHEcWEJiFEDm6jgoRaGk9bUl564Eh00hQqEVubLpeMpA/Gchq
	 1xO+wQ1jTTDEg==
From: SJ Park <sj@kernel.org>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	chengming.zhou@linux.dev,
	yosry@kernel.org,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: zswap: remove dead length check in zswap_store_page()
Date: Mon, 23 Nov 2026 17:21:22 -0800
Message-ID: <20261124012123.94517-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123032512.6119-1-raizudeen.kerneldev@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 9ABF7120004
X-Stat-Signature: d4quaf8ofd891hdx58m93qfau9yzyuj3
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795483292-645099
X-HE-Meta: U2FsdGVkX1+mMSkyAS9DhPsdtBYGqx7k3mL39LWV+/qVyXf/DSCflM0ythG7vFkHMYWllCLxybburP0kNU6jHQUg/TA6ww7IwNhk5b6TuYwy/MZWAd6fw+p/86S1TFaoZ4+8WIJoGBnwDSlbxzPd4Z6qKbynnJv1Eumn9/BANkeZgHcw5emuHvVvsBI0WDJEl8J8aQEnoV8MkBsVSSByDyqElB2HhURFqrwzrpotvwlGox2Ob7EdCFKlPQ1MHc6CI3D0fgPCkxMuGFV1PZKNCbNaUW75EfvNgly52I9vsT+pwE+9npbRpDDlRa0avt9hZ2B1ofP5CNTZ7SM4Wzb2SC0hLYrJLo0R5T7j39DGEXbwqECg5vVF/YF1G8v6gDa6ttNxNSAzo1srp5rQIdVLxbtPsEyIubXEuxbmeCAmQAkbkdtIG7JwMUncfkB0tEp/G7fbNMudkkuxjv+tO5YfKGz7PtLauTdnaMX1dl/TU4nqOVxzXBnDUVn2ttzhdVz9+BihRXGaeA07wPYQCQnf4IRUTz3Bv+JIwfhr6rjQBItPYDIXfjnAVu+WEFFhjmcRpshzN4Xoe1ackc3lUkYh7CS4ZW+HQ+3sDDGlvEmBfMf4+cCxOkdqMx9AhohTcQOlRuN2jJ1D3SgkgRnRzh3zHYR3AwGj9ngp7Sm2zEEiMbWXj1qOqbk/v0GlJI5mEbKhZkvSskbfIwyyNTFNEAXbxTgEQJFkG2Sucya8L+mdpht/vUqBg6FJqg2H65Kv9UmhKaeyGH6qWYVSYNZwuTwm/Ljmg0vs8Fpt6SRVT0nEPE8fPAIxJtzK/tTbche4uCKXmL8pWBQ80r+X4Lm0vPfmGclm4gNSXoV1OQLhF48/73uDDD//d8GbztM7Wg82URIPSFpCNvCcUNXKHhb91jXELWANEJhr7pIMBoDe5P5oXno3eS7Prena2N0jCYHBxKfQ/Do0vRvskwfCotpw+d6
 OThpAkN+
 ljGBGhYtXGgrkl5Wkgk8JUpfuPeVEIotR5E1vn+Y7kk6WIZimDmOXNmzmlFOW88LTKWRKG47cZecwPJ8GXV5Os4zeY98taAAipJQbyh0KAzv7CtG2zxrMFFDLuydDvvHbM03UQyFYJOqCDuLneRSFa98DFc1jNl4txe9/bKVWpDEWDe9Udv9oJOCA7nYlHViDx8TMyxTdi6KJufDBm4eiNlrjoHE8KFdMQ9Yb2+gx5BrKgXd7Nt7l5tzCCDHuBPXxyBZrCC1WhdU9RTCOuKIVe386evNFFsNaY2qe+cfSSr/sxDEJzo0iTh0zofUCCQg1iPr3jgn8fM2qfz7TIior2OILpUNrIBeTVi3ULhkb5Na0MVuuUfbjBsEojh+5Z0R3/kXqSSt4TNPE+i8R29Ri59PCeFQNuDp0AXiCvn7/ZM/HQGE2AgP4uc8LzKvWPw4XljnQ6at93I498yUkOKwIpv9yC63GhxFBvw1krmw/eqUHF23r+kPdHjx7GRIukpdY+eiQfsmI97tbWLvS5zYZNOvm8ejK3TLq2Tq3faVhLlhh4UGi38UL77r/9c0Lu8c6Y5toOC2K0LgrpUpo+O5oIrBNqMf3DmoQmURz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 23 Nov 2026 08:55:12 +0530 Mohamad Raizudeen <raizudeen.kerneldev@gmail.com> wrote:

> zswap_compress() never succeeds with entry->length == 0, so the
> condition is always true. Remove it.

Makes sense to me.

> 
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

