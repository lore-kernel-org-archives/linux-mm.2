Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3985CCCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 17:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592C58E000C; Tue, 11 Nov 2025 12:28:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56AF68E0002; Tue, 11 Nov 2025 12:28:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47FB58E000C; Tue, 11 Nov 2025 12:28:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 365918E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:28:42 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4562140168
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 17:28:41 +0000 (UTC)
X-FDA: 84099010842.19.F297BF3
Received: from siberian.tulip.relay.mailchannels.net (siberian.tulip.relay.mailchannels.net [23.83.218.246])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4DFEBA000D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 17:28:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=MeBs0vAl;
	spf=softfail (imf15.hostedemail.com: 23.83.218.246 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762882119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fGEXgunrl9FTquLyoAqFKq7Y4iaVGi3mztkWXISr/mg=;
	b=8JWSj7G3UQku89995ex+GrwyTtWIUTHOCJ19rS3k0w7E/qt7CjgBQA4InQ+yrYp9UDU7zL
	vF5jD9wyFnOGG5wtNyR5j17Qsmnr5F4/Te4bVrRvXEpUAXeXRMW2S4/CE/CHiICQBhVEJH
	Yisf+WDmr6/VMn/scwvUzxnq+q0s1U0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762882119; a=rsa-sha256;
	cv=pass;
	b=40hiDj7dImOl2v1Rn5zuFDQslcxJOKEfeWSK+qMCPOvKaIcGxOBtXufMdWsb+ATO1PBHMW
	LcqmU1p7sX6ugPrhjxM+cYfOXRiBTTC1KybcDGCxRNNJzHFN8rLdmkQnx5aBw23ItZaplC
	BCuTpLOaB4El1xfUQmLmNVW0S8mnYU8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=MeBs0vAl;
	spf=softfail (imf15.hostedemail.com: 23.83.218.246 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id DC444782877;
	Tue, 11 Nov 2025 17:26:24 +0000 (UTC)
Received: from pdx1-sub0-mail-a229.dreamhost.com (100-121-213-86.trex-nlb.outbound.svc.cluster.local [100.121.213.86])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 69FA8782A54;
	Tue, 11 Nov 2025 17:26:24 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1762881984; a=rsa-sha256;
	cv=none;
	b=0J7hKXdHWGUhuMYjopblG/a/ktX7eRjc3ERxz/o+VuKq+q5zpWdozVP4xRmKpEBZEI5iyw
	ckUlvSYZtvl9GcqDUFRtk1ek01kVkEP+QIfg/SNm7q4KJIt27Zo/1lRfUxVvKAz9rs2nhH
	0TJ9NNEYYWhSxiMHe7rXkLdg8Zmxuz97L9EaTBHzzjwvLyLWlsi7/2CUORZEhYFlMsIf6X
	c1jks8ZxOQvbyyMj5n5YDHxKYtaYHgni3glXATwMfGlKEMx8uIZmmpJKWVv/QXf3foi+UZ
	GR+oGT5rkt964idf1Vmp4rLf08vsOwFsiXQYm8vRqyIdfmdiV2Xmh2PLGiNpTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1762881984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fGEXgunrl9FTquLyoAqFKq7Y4iaVGi3mztkWXISr/mg=;
	b=zx5/4bj2uSrWlTHnlPr2VQvpzl5GU6Av6g0R6mpdnWvEuFzebekhXc8Yy30mLM5XKu+5vD
	+CNwsYPMPv9tis9LEo0whPD+Ex4I8xqTMdyPcE/r/Y/848VydRDaWprVR1FJxygGZ7S5MQ
	OJ3YW4XDXAl9chig3+bpA5nM6wo9WSF1+CELsk1ZePztQyO7bGxbrYEPOim9g3BiExcPNv
	rY798LWd8SyvP+kbdR2+c/3SHD4Bzj/SOSAT604Lo3A2Rs6t7rvXurPB7Wk1OxyJhRWaKO
	1YDfxuucyXU+lkC5IvJqd0ybvIpzTHaRQrFWTCb7fAK0Y0kzAxTvMMBZucbbJw==
ARC-Authentication-Results: i=1;
	rspamd-768b565cdb-4j59m;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Inform-Shoe: 3cfc82b06efca727_1762881984722_3782567276
X-MC-Loop-Signature: 1762881984722:3676767511
X-MC-Ingress-Time: 1762881984722
Received: from pdx1-sub0-mail-a229.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.213.86 (trex/7.1.3);
	Tue, 11 Nov 2025 17:26:24 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a229.dreamhost.com (Postfix) with ESMTPSA id 4d5YNb4z1Dz2W;
	Tue, 11 Nov 2025 09:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1762881984;
	bh=fGEXgunrl9FTquLyoAqFKq7Y4iaVGi3mztkWXISr/mg=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=MeBs0vAlrFCikEu4BdYnm3CWXL/eYV16oGylX0dD5s3QHKiJsB0iQsYhZDfHK02Wc
	 16uYwnZMJRJ6y7vkJm3DQAPUWdL4AKi811KMhQ3yfLvCFz7N4/BFhvpzOQyGNvz+P0
	 ZG/YsLmJ1i6ktuz/7b4ZcWnE6mUmwPqZtKYF8wmhGpk8n7+0lPVIKrWZRDn4tL2i6X
	 J8tpPyiW987HegmmpcfDF/dpMUvUAfeh/rvPkH01qKcUsAdlpFzKhgcBGxe89/0910
	 51CoD35q06Kgfkdtx1+NVboRFlmlApXURVnBRQNuGeR14BIng2RjcdGjX3q1aZ76h6
	 CGwEoJLZCK0tw==
Date: Tue, 11 Nov 2025 09:26:21 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/madvise: allow guard page install/remove under
 VMA lock
Message-ID: <20251111172621.thszs4gtc5exsvuy@offworld>
Mail-Followup-To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1762795245.git.lorenzo.stoakes@oracle.com>
 <cca1edbd99cd1386ad20556d08ebdb356c45ef91.1762795245.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <cca1edbd99cd1386ad20556d08ebdb356c45ef91.1762795245.git.lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20220429
X-Stat-Signature: fgwjq7oscazowmfp9dnojwehcuokkqk9
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DFEBA000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1762882119-961700
X-HE-Meta: U2FsdGVkX18NNzTRMpjUduG7m58OKe3btdVMPFbfS4TuKR+W2HkARqGqlBl3kITQfvIkWj4EoPhhirH16b8UXqI9Cd7MOOaJ76Meuao76KXEdzU3dojJKUrNZ4q/ToKfyXKprKUqnA1JD36leg7Ge0m/pK7Cgm8pmq4DBS13MhqObS8DW2ji7qfTjvXzY8e72XJt+ROkclw93CvQliUoAUDbP2K0lkJfiBDQwD96Yfn8WVQlZDonWFqdM1AbBXXmPKiLo1VJvaA565swMMAPc67aQa5R2nk5QtJOmvbhYhKGJShgbTxx3FvQMJrz4ZFu1ryUR1tkbFDOr9vVHYUkJQcaohtnIG88hlKKWg2M9287E2Pp5aYAvARs/kUk/No7tWGAfHgIAFX4Gkv7i3qSTGZ9r+0kP76aE1gqKLYqUd6ff1RhoF2ouhFoaCKZXBaSN1P4Wds5u1ZxRFuNSA0fgB2uNl1BS3es1Xv/NJa/DEl0GsIuEwIR0NrKCtTXNsUon/xc5fWWORBDcFZuvTqAA00zSWXu6Oxphx+RkbnbZ3V1s7c/bXvIfxR2Jd6hMZan2MlIqxnE7+g+O4ClJwgEtnBeG8QkEfwVIbNaWNM97eqymn7ZkdBGwIntYu3a90HvPz+rEWUmc7Hlm0v2QOYl7WywsyixUJv4qtP0GmYVrEAMBj8TkdH8k747yJYAdh8JtWfbzhGV/UxPolG2T0wvEOb8rBNifpbLmeJSCef9jldiFY+YGpQYRrSVimQzpD/PYmrcrKm+t2EnWR1XhcFy2GRKlzgAk3hkf0aQdABsXfWuxC+Una7fntM66DejtTuTAtpQBJO0BcReEzEoJO7PhI8DtWVVSJ+BKHstRMW71aj5gxVljC0YTo4voyeNcCjaq0DygFNO+hinnAw0rndS6ruOZOxUri/cOA6JaJlndOcGjtfhVQ87ox/qFpW8AG0+2CVvs5KwLoU3EaZMHJP
 wEWJeokD
 PFCjuRxWhVP0u9EwxVrf7irQRR6JAhTiZkPw0o9SST9JfmLLpuD7b9XY4vdCS9AOiyMy56XliYBZVfRNCELmhQdOveyRdrRBH5YKRBvYCoDPTzKAuUutBVl3I/ZsO8tWmbWS4TiQgrDP2TM6er+19flK90sXYjBB6MZS3t7saGB+3JKdxl+j8kct+Bh9bp66UGBTjUc8k6h1/eXDJii2KnrH4gfL0zLFBXUAc1aQAquekJfnMWHT6BylTBBH0s/3JsTQoviF/jiW7hX7vAXHONApYvx0/fq77B9fn2PLVClnDbDTJMhwEX03v2IAmyz0ayzFNnl+XYso413vMe9wLQTLuk+B6cbYyLYwUDjBtZHBgd6njpw4gFkfT4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Nov 2025, Lorenzo Stoakes wrote:

>We only need to keep the page table stable so we can perform this operation
>under the VMA lock. PTE installation is stabilised via the PTE lock.
>
>One caveat is that, if we prepare vma->anon_vma we must hold the mmap read
>lock. We can account for this by adapting the VMA locking logic to
>explicitly check for this case and prevent a VMA lock from being acquired
>should it be the case.
>
>This check is safe, as while we might be raced on anon_vma installation,
>this would simply make the check conservative, there's no way for us to see
>an anon_vma and then for it to be cleared, as doing so requires the
>mmap/VMA write lock.
>
>We abstract the VMA lock validity logic to is_vma_lock_sufficient() for
>this purpose, and add prepares_anon_vma() to abstract the anon_vma logic.
>
>In order to do this we need to have a way of installing page tables
>explicitly for an identified VMA, so we export walk_page_range_vma() in an
>unsafe variant - walk_page_range_vma_unsafe() and use this should the VMA
>read lock be taken.
>
>We additionally update the comments in madvise_guard_install() to more
>accurately reflect the cases in which the logic may be reattempted,
>specifically THP huge pages being present.

Makes sense.

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

