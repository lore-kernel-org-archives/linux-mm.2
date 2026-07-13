Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8903C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D8FE6B0092; Mon, 13 Jul 2026 07:48:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7628E6B0096; Mon, 13 Jul 2026 07:48:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58EA86B009D; Mon, 13 Jul 2026 07:48:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31A936B0092
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:48:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B61C61C5BE3
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:48:44 +0000 (UTC)
X-FDA: 84983581368.22.FB465DD
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0040140002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:48:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=f1cjNPoi;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783943323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=h+ewRGwRCC5f80UYTJvZsM+OSAaYeVd+91q2pbM6EL8=;
	b=Yfhe9VlPf7I0u6+j0Ujuoq/Zpmwgp0nHji6aB9qLqNOIf4qpfhVEvEZ4BpwoGb3HyR5ZWH
	o1zgz+pt1wGk4t/ToJRMUlCFb60I/CRqIxMp5e6e25IGn4M4zIVaFbrOAvB5BqrnXr5gZX
	tOfvA3irZCAMfzk6Z891vdbwTzP1h7A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=f1cjNPoi;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783943323;
	b=Zr3mRV8rmSRlRfzGFtZqJnWvLKNIfv8CACc8xKcwH0wYp8t0OHQ+CKAEVaves/YNbv+D0B
	RyijJeMa4v96/FEQTNrt1g/gaThvcYDnrDCiEfDIwxwZJLynnmJYvokhvM22IAzZ3lLbaD
	fFh9XA1g3mRITl6F810TdCEQNUhEnnY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=h+ewRGwRCC5f80UYTJvZsM+OSAaYeVd+91q2pbM6EL8=; b=f1cjNPoiNOYteBMDkMB+7j4YaX
	RviPxa+xWHKln17FzBOhhYXqWHOCZH7cXydmBHTEZmXxtF1EhzTj8FiHIEGKx6fDvMzvoX0IDlIHF
	caeBMjAdLKBY7vnwoPQeQ5nJs86dk83uDk6efM9KkhGcqcv67KFalEqcJPbc4Ot96BSJXFpy5/pyV
	DKd7nUcT56uRQOM2YERUyvSzEiNrWqISOR+8Xl+ZSUX3ytAEIeKbu4XNh9ufVbzKZC7he4RlFdTCx
	eZvZik5E1vuMANBEpjx9UuSHSDwvTw3zI3CnwLCqCx9x52FILOuy10yEURygM+xBvh3MP4wxksI3u
	M4xFACOQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wjF96-001Tib-33;
	Mon, 13 Jul 2026 11:48:25 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH 0/4] mm: kmemleak: reduce transient false positives by
 confirming leaks
Date: Mon, 13 Jul 2026 04:48:03 -0700
Message-Id: <20260713-catalin_pto-v1-0-5b93b1131089@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHTQVGoC/x3MWwqAIBAF0K0M9zuhBxi4lYiYbKyBsNCIQNp70
 FnAKciSVDIcFSS5NesR4aipCH7juIrRBY7Q1q2t+6Yzni/eNU7ndZhlZh+snaULjIpwJgn6/Ns
 wvu8HWfvr7V0AAAA=
X-Change-ID: 20260713-catalin_pto-dbacf66be3fa
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=1856; i=leitao@debian.org;
 h=from:subject:message-id; bh=6m0sGE2RD1Jzdr/pWFz6NTrp36wLFw+6shhzF/VGRDY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqVNCD4ZdAePawtg7VFuLqpysw6wnTe3c8T79Pi
 IxLUJCR7AqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCalTQgwAKCRA1o5Of/Hh3
 bSzbD/93Jr74YAW1SERbtRFp9A4hsP+JaCLfhTQJmzuI91RIOjGm26p3wu/yg23uwGf3BdWdl+g
 HKb/xjTyk6syZUlmGnkx3qFOrFnS8reOIWRm4tsAUjnbsYVhu3DO3doYDTrRIdDITFT1HyOPF2i
 ZXJSXhRtG61AQIWxdhabJnPv9aaNfYUvtx6Ktq0x7oDL6tDL8uaZozRHEaBgQm0ydyhe0VL904j
 uEgGL25/iVLwyzgwvmo2u2J4RVwijPG1sKw4yIOZkSsyCLiJNbE8RhQk2Q2PZZQuow9WpZ5rV8F
 cgDnXqmOUWSX1Fojftf+G1ts/LC3+ZtzaOLs/ZvjgKmY9/i7We87yGpJk6pEKohdwZ4dZp+hzsS
 KfA/ZpfkTQFuWjyFjT2/js8xwBqWv1SNwTiMPmS8qqsnAdzDG/YXTdVdUofkcYyTjazc+rRLdzc
 87T/Hfie08URotG2WoJjm3EUwkPSh6bJL70vk27Jj7Lh/OORX1FpJwGTeL7SeinGd8jSocIZIDV
 DlFN+uf3YtpSZQ3XLhaKu2ZKV/vGviJaiIPn0g1fbFq8GOMJA9rxxUMgKK+WBXXkbSon5EVfWMr
 eMidKO4e7D8ULHtdI1s+j0x4NrdQ33l8AzKS9XiY0yCY7S+OS4A32XBpKy1TXyPESuCyNdmzTFi
 vcGu4LnSRsUvz7A==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0040140002
X-Stat-Signature: tf5jyo4jomjhjmd5gyj99x45py4hpoix
X-Rspam-User: 
X-HE-Tag: 1783943322-796127
X-HE-Meta: U2FsdGVkX19knbdvxBpcsSpPPEBiYHVoo8C8xjMEbMAReuLrLfn2vA3GwzvfVt9JxB6VSRlFDWZB4Sm8WBSv25kA1wVcpG8Y/9YrWZ96CUFYkJVaA3lsueVSVQmf1eBylHyq0yZ+uRtjG6k9fxm6aMsw8VtnzZzXXC3SgGeHcnfZ8TBmfXM1QEfvFBdeu7qXuwwpmu9tjeLP6+5IvHmrNdqQVz5M+aFtOzzpEBEaNIqxl2S3CG0nYnZc48qkqy5R40lVe1gMcshhBtAvM+JBRyvMJ2Nxb+FvpG9SoP307h6hWeE1QuK47ZCx3nz6IS58o/gbMapNf9/6WTUxFse+aJal5MXvw18uwMXhVj46LcT4BFajXlw9TDWAae4Lx8teiOuat0VzkK8JtzKMhUKdM+GLb7u7zf6azj6KmgvPp+6ZhTiKfTTtZElj447naNw+Nhzq697UEFeCqj6giWDlbaryZd/e44m/oDtXUYGy6/ftgliepKKVpqflWKYRuItz1SITv2DyxzknWvmTelqouBpCusr8TGdhABDT0VypwbOPPvOLqbRQW5REFwvKCrc5emjyikwy1J39kwiU0V/wwi/ZtqLBhljp5xplKW2h0cDiqRn9SvuLjk3zqiEUqpA1MPKQVqQdhMrz15HX4O7fDChBOIjtF0lQ0HZmnvslfCCjSpbC4rpOMtf8eaGXHFhHd+P5JkOhWUtcqbyK7f8Bu2thHpx1yuOxKMg6rfs2iJAtdnH4v8q/z07ihH5SC8B7HM6fZheaNFjkzPmWYyh3sIs924v+g+tX30zqCzTjlX64uPVBdSsv07vcUlUhkgAFBqeud9PwWtCgMql8xqQW/cQnYrp0/8PBAedXsgyf7zIuTp9WKvqpjIpAFJz91XbUOow6D5h0UwBXiMrAf/Zok5cmO7Xme+gx7WImAWPS2sBQiG6p6X3qJ+eyzJXlouimKf2Q6j4RwF4c5J4vKRi
 DLwuP4Pw
 OG13aoyoMuRkT58tJKhDYkO0vcQnlrkIoGHgdjSecJTZ+uGLhRjCsdtTbyTowcUs4+IiNvQ7FVLg58N/jCl5bwyjHoBP7rWXEiGRFfefYfI9HMtvLNfKehoeZjQ+aQhVxtpKEMneljmm3DLlBJ+c5CfmygqOgVtfVUk5kS0+wswER2Bqa5y1ZoINaCJGR9cwtWxW7Od1ZKcbfk4PJx7gYA4F3khCsp3fYrl/BBo4en8pAm/sEoxJKBqvjbRi1PaG7Q6w6aYWU/u5jf40NuEIWQDccmX3nDbHSy6K0/oHiF3sYf+CXY0iU98xNCxPP8MvoObuavvszam6rz8I9upL76hnPltQbnf+N1pyxjj5D+/ZojR40MKknPZ/0cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series combines two kmemleak enhancements that were originally submitted
separately but both required rebasing after commit 79c37ae3733e9 ("mm/kmemleak:
fix checksum computation for per-cpu objects").

The first feature introduces a second scan to confirm suspected leaks:

        https://lore.kernel.org/all/20260709173347.689607-1-catalin.marinas@arm.com/

The second feature adds a module parameter controlling the minimum number of
consecutive unreferenced scans before a leak is reported, as discussed in:

        https://lore.kernel.org/all/20260626-kmemleak_twice-v1-0-ab28f7cc0971@debian.org/

Changes from v1:
Now that commit 79c37ae3733e9 is upstream, the selftest includes an additional
priming phase scan as requested by Catalin.

Additionally, I've factored out the leak-detection conditional into a helper
function to be more digestible for the reader's eye.

This 4-patch series resolves all outstanding kmemleak issues I've been
tracking.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Breno Leitao (3):
      mm: kmemleak: report leaks only after N consecutive unreferenced scans
      mm: kmemleak: factor leak confirmation into a helper
      selftests: mm: test kmemleak's N-consecutive-scan leak confirmation

Catalin Marinas (1):
      mm: kmemleak: confirm suspected leaks with a second scan

 Documentation/dev-tools/kmemleak.rst               |   8 ++
 mm/kmemleak.c                                      |  90 +++++++++++++-
 tools/testing/selftests/mm/Makefile                |   1 +
 .../testing/selftests/mm/ksft_kmemleak_confirm.sh  | 132 +++++++++++++++++++++
 4 files changed, 225 insertions(+), 6 deletions(-)
---
base-commit: bee763d5f341b99cf472afeb508d4988f62a6ca1
change-id: 20260713-catalin_pto-dbacf66be3fa

Best regards,
--  
Breno Leitao <leitao@debian.org>


