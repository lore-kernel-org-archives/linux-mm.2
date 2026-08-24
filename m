Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD02CC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71716B009F; Mon, 24 Aug 2026 03:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B497F6B00A0; Mon, 24 Aug 2026 03:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F9B6B00A1; Mon, 24 Aug 2026 03:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8978B6B009F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:59:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D5B0A31DC
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:59:44 +0000 (UTC)
X-FDA: 85135413888.07.CF7D9D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7679DC0008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:59:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uf8hkcQg;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787558382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJoYfBFszVnClToOHHH2o5hji7ont+MTpRkHMfc8KdE=;
	b=WSGxiYKi8sQ9r1sT3+h3K+biQSkkTCoLdN11G08brFeGizAoJnFo4XDcHZJ6L2D1e46Sw7
	2rXUNUOKh0yqrnRm3ouX1uWXPoYAT9iNZEljnjzjt3j9o4WbB+hS22cL8hyBVqwQkh6HZq
	3r77UztddY6f17CBI2BRzDIlm6c8wa8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uf8hkcQg;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787558382;
	b=whPl3XS9OQGJqnCsOocOsPqSjewy8wh2PtPJ/OqJi/fWwiivi68RMTERhB6CsTEEuBL9v5
	YiLgRt3BuYge6haRjNpzROwNzBhxsy15uoSVx7abeN1nYVqJPjQeNa15z5mE9jgrJmKGPx
	sFfD1cTJAZaQO95lm3fBKba8wDPMnTE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18928600C8;
	Mon, 24 Aug 2026 07:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924EA1F000E9;
	Mon, 24 Aug 2026 07:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787558381;
	bh=WJoYfBFszVnClToOHHH2o5hji7ont+MTpRkHMfc8KdE=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Uf8hkcQgyJKXdHugZsCiBPziTvMAXJnVifz9UyTjgD/eZWe/nknUlm8s0O/JoBeMM
	 zOTkqWmeWZJoTGQP8oT3O5tOnrzFTgNZzN6nujVMzarnsU3/FVXrUGlzZyltG425B5
	 +5CNyoVrS40s3VYr7n2RcGZGU5qjozmZEVplpknmIafNO34dtivWT5sK2bzfFJDyyV
	 kN/9elDd4dQ9pMZ0j2E/SN1bucrC2Xn49rRnACE3FdS8FH50U310+gFa3RXS9JS0RQ
	 AGounwpHabWZsDoQJkpU7yulG7y55O16IuZkiR899OWASWOlCEITvxYxu+obYmpqy9
	 pYkqB1Wm0371g==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 5/6] tools/mm: make gup_bench a benchmark only tool
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Mark Brown <broonie@kernel.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260813181230.483746-6-sarthak.sharma@arm.com>
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
 <20260813181230.483746-6-sarthak.sharma@arm.com>
Date: Mon, 24 Aug 2026 10:59:05 +0300
Message-Id: <178755834511.3606540.5889183666243190319.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7679DC0008
X-Stat-Signature: m5s13767ndjawg7zanjm5xgsfiyy339r
X-Rspam-User: 
X-HE-Tag: 1787558382-964031
X-HE-Meta: U2FsdGVkX19HX+xwuMmgAqjtjvrhbEdA1X1ca6+eNl045rLiXT3CPzSdud7rVNqGgD8U1SonsDBKB9DX9BQrZ9LFq0TcvZl6ebvgPWNgiPpBA5cun2uL2t5moS6e8cbqoRTDjjGnQIvYIerUhPhEexV64lFh+B0+3w2+1E5FIIevwbdJwleM5tD3gVMtoB+Ub+8c+HFP/yqtVZFH/U0LDbHZVVno3crE7mUPOAjjZgpPbEw93EXqO2h1cuSpfdg/n/r9Jn8mfLkoUETZFCfidmdYpTvbztnU45pCoN/U8Sr7bs9e9PA2TMrwck+iPo8D5pgfnSeiTSxNjYn/4GJTAJdHm1fI107gc6h3B0QMSJrgQuSRkQqCJfUyPt9C8f9G/D5+FKiq9kMLrTGYrwjvYX1OBbmTSl1tJCYLPsEmjpds7Q9ON6ZeWCRGicwG5hVg9r0LqSXaWYq4ov5+u4vM7Zx6N1oMCPkc2LBnsmJMT/duCsjr33YKjfndZfY+glT6v8LGwMlNftg3WcQGTm5k0BIN2zkiXYy8XwWq/yd+lSyZP3oQ2iGxxejrsRNm9m/FBzeK9oMc45lUffLJP6/dsQt9WhODJ7BvADn+DNWMIXl/A5/KQpXR+6y9o+sU5wgpi0mwBf4odqMyCbz9yTPP21+jQosZzkeog1Rbgv40oi+Yg0oEFireK/g8A99XC7vMYwy5xfm44nSCSAlSxlrufbbHUblSl4iMBGJtKv9ay7C9OFCzij5bMi9oG/P4GE3O5A6ARk5OBzqipHZ8+NLu+z4Qmtp8H7p1j1bMM47FZYEblVsiSIQYvwyREb76yopLw6pIgPA280chVy+oXJ8ujls5ujpw5pWl2OcENVr0mNbjmJCzkwrxSSpLh4FUxT9IOK800QdmX3dHsOB3wO0V2bApSLkttdmCA5RoK5nbOP9wb+iORUyNyiBEmvD0/cnEiFTD+6RTiGaxYlc95c2
 Pw8gx8v/
 eej/1rTOKWUoSw0F57EG7eFyLzc1oR4Kr1C+LwaQz0P4BLVWX6IHzrZnZ48rt2i03nawKrwLJ/QOTP5iUDKlmFUo8L65DAcGXToYKfXXjzeTODIXFISAt3dSxY/HSuMxl+xPetzPM2/GaA/QEMi8cZwgvCh4+eSOCuOnwd17qgYX1qB9J5koqKTv93Y6Ex2N+uLYrgUcSJzfHuQbqqCI+Ba78oc/qvsi84kvlz22y1glAyQk8rjq+/OTAvwfG6ytlZW2+8Y5Q91ADy8b+1c0spXVaxTp1eJdDuP59ycb+YIEPsB6+2z8g9FWNi1ajDQw5LJ3tzIZdtHNwHddpMzWpzFuS0/idshz+VI1i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Aug 2026 23:42:29 +0530, Sarthak Sharma <sarthak.sharma@arm.com> wrote:
> Remove the functional modes (GUP_BASIC_TEST, PIN_BASIC_TEST and
> DUMP_USER_PAGES_TEST) from gup_bench. Drop the kselftest dependency
> and use normal diagnostics and exit statuses.
> 
> When no arguments are supplied, run a single GUP_FAST_BENCHMARK
> with the existing default values. Let users select other
> configurations through command-line options. Report ioctl failures
> and handle errors without relying on assert().
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


