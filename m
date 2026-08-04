Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D86B9C55182
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 00:02:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB4E06B0096; Mon,  3 Aug 2026 20:02:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8C7F6B0098; Mon,  3 Aug 2026 20:02:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CC6B6B0099; Mon,  3 Aug 2026 20:02:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 791C16B0096
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 20:02:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFA2C160854
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:02:27 +0000 (UTC)
X-FDA: 85061635134.29.9441747
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4D9F5180009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:02:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mwYM55Vh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785801746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UrwJW94kDrg4+m+jnC59gn9JDVrDxdlujcdhUvF1Qqo=;
	b=bSlFlBn8xdslZKMK3u8VGei8+duN5FlBt3MErcDa2oKba9kJGxwGffMjYP9VvLaJYJW4b8
	IuQTWs7ms3NVWqaZ6BfBjpkvWZULYOhX1At0nqqECZTORPXL/T82tEA4hJmq60jpuIxNv/
	TqRg6xclzetJTNZeK6cpsqr28A04N5I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mwYM55Vh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785801746;
	b=7cjYRvqhFZIaaV2/8ijgXNDeBuG8cmzZqnT6ka9pmIuaxwlP789O8u6ujJHmseLf0eJpCh
	RSjNRU+7/sLuV01oBxR6CV5LMRo378N5rYCydXhpth69Up5OH8i6ma8UuCPaVWEUGqDFTE
	bzP/BZG9s62UKd5ar2dGEJ8nxGWYFXk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DB1C40599;
	Tue,  4 Aug 2026 00:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9584B1F000E9;
	Tue,  4 Aug 2026 00:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785801745;
	bh=UrwJW94kDrg4+m+jnC59gn9JDVrDxdlujcdhUvF1Qqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mwYM55VhfbMkU/n3grzHTwZ6ADhGXEl3Cs9odiqF3bcMRAq8LFNe93Ru/RNNE30zf
	 DHIS1P9kFCDUmgM36OKE8VtU9hpUTtefPlpuwLihxx0vr0YffDftcdyhl5/nLTyiSJ
	 qbtgdfliPAL+JkMtGLC4Fa348VMWjN4GDxZ8sgJ3gfhRXeLBW6y3Pz7S7Gvuw2H397
	 xiiHRSkLlL0951SW4fsucIOkoAqxnfOFncLL7nScLUS02URdlf1qTbxPggR+gekPFb
	 yWZpSH7w/B7EjOGpTp71A0fjmdOJK7Gi9jMIMjos2lxUahQVXna6SB1bADCk5pqkFu
	 0VNCswPiCNEWA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: pratmal@google.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH v4 1/2] selftests/mm: rename local_config.h to local_config.h_gen
Date: Mon,  3 Aug 2026 17:02:22 -0700
Message-ID: <20260804000222.88232-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260803235743.87939-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: juchbdk49pa4fdmspgsq1rnicdfxpewo
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4D9F5180009
X-Rspam-User: 
X-HE-Tag: 1785801746-822162
X-HE-Meta: U2FsdGVkX19RfKzUxDEQuEDVoL44UiQrm+DOskXqODO3lxYmKKwyT2XuFS5cUOab56ItcF0/EyoDu69/zkpoe6MexSmv+JXgslzGw+5LJCNC47+6jfEtZ925MwIKHs6kkWjl62fdBCJzPgKfPcfbsjqkcUss6jU+Y1wd+eyTc8/BQEuMBsGzm10uJSxgJ2uexsBKC5n6DitKStWgYkcEtdfXvM+zVoXBCNVcdp/tIiwjOyhTrVf75ArWRcspzjTSCz0uwVWu7bgSgfSa2ZmBMWhgSED97ssn7Ef7z3F4LsBqix6f734Nn1K0iLDIYfmo9fNRiAT64G+i+eqhx1gw6NaYWijVIMyJJ4knS+3U599WuFVetLJFCylJXNDVOTtr1MkHfC+DWytBMDKyEW5KvbvACC2xDmdPJ4HyH0VxNhLLYD6lBdBq8UZIx+bmCLo1nf4UW6hFG7nf/q6+TDccS+9whYfq7JdFuGureVHv25INxCKoXtOZ3P5iPxQS340TqrJX7pv7CIBMOXUte+yhINSXisfsYr/PW/PH4xurVpqBeftIQ5coKqcklpyLKVCKJzVdFliDwwccTbDwtIgAj1Oha6fvM7sd0IEsXXkGqutnvbDF8mpwt5dOAJRTU9sRD5ib2HdA+tGX+I1/nxRDMdoL1zBAujFFEYep8ny2tmAxOGl7fW0sCs+X0e6A7Lds8MpAcYW+w/lYJ4Hzcw5K42vuxn6AaKVfwriWfxUcaUF0Ad0zO1o/6xZpqbODeRjkedG4xKwtjlTon3tl3CkMI0KozOu/+FhG11kpsDACIwFp5XoHG/tXaIFDXdfP0LXoFV6y3iW1HE14Qpx5GjDnPL/nb68TVBkECFNOZTpt1pArNGD6/JUmgpgI7oCNYgr1JEhqrRMW48jfipko1Jcbg/mYkA0O5/skmVL0YkdshVarMiOeB2pYkbhU1qrGPuQyB8uIsIkSj4rDxTLWR6Q
 tNwNd3XU
 S/v1f55zbKgj4R3+eHuxRTcAKbK9+Salqlen0XaM03f66etmIBVu5McLWImnkAtpinKW0oBh1bLEe3NzhAkKJNkztCMdDwD/QI8KM45ZxUZG0wJTRmDMpltRby5bZKwBBCZApkSfyvrvnApWOID8U9xOoaboV7VrQdO8rdT0/LcBikYERVU+vnNxhzIi1/1MB3BmdfDLI+X18wq45krLMnUw1ZQo6q2ejGpfm9LfULLBR+w51G1NAa2ECwiAE5E6DPrb5uHHJs+UBy4UDCLO02OfdL20wXpQP4T6bo1SUNRqwls7KDLOji0p2llXHjab/DHlbrwC21i7dJHzg19RSDc1Tg1pl4CiTIR9h0S5jKY568fA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 03 Aug 2026 16:57:51 -0700 SJ Park <sj@kernel.org> wrote:

[...]
> I found this patch cannot cleanly 'git am'-ed on mm-new, mm-unstable and even
> mm-stable.  Maybe rebasing will be nice?

Never mind, I just found Andrew already added this to mm-new.

[1] https://lore.kernel.org/20260803230818.437641F000E9@smtp.kernel.org


Thanks,
SJ

[...]

