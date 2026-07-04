Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B022CC43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 06:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96C136B00B5; Sat,  4 Jul 2026 02:43:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91CEF6B00B6; Sat,  4 Jul 2026 02:43:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80DC16B00B7; Sat,  4 Jul 2026 02:43:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BCE06B00B5
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 02:43:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4F7D120407
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 06:43:00 +0000 (UTC)
X-FDA: 84950151720.06.D9609FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 37A41C0004
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 06:42:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YLpIs6yb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783147379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gAV+ZwTlVxovv2UH+ZeI5s4MGQIDT9dk7McWDKKaZC0=;
	b=R+QAqKf+dzX+tKddj8DtQ+QKxMqoVllm/7xwCKyqiUonKFQjEhGzEq8DgcNJ9wKuStyk2E
	V6BUqslUp9EdMErnYHIbmRJ+InMjIadnwwbCVoqvssHxiI2+EuTRLMjv5LWRlpHO1yw/ce
	mgJy7e9ngkgZd1Jrd7KGlVqWpRp1WnU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YLpIs6yb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783147379;
	b=E0q9jxKrJaJP7pNeMK975iGO/hzLHe1+tqAEL7FX3mXN0EQEktkMPCHrcKT2pI1j/nx/hC
	wMfGBme8VyoxWwufNldXWPian4McXijAtIqdf75bY3Ot0UxfLoKflQTWpqsSYx/TmcPDre
	3dryQbNWB/jQC7/ZBpbCZgZAmGCqAmQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21E42405CC;
	Sat,  4 Jul 2026 06:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32DB1F000E9;
	Sat,  4 Jul 2026 06:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783147378;
	bh=gAV+ZwTlVxovv2UH+ZeI5s4MGQIDT9dk7McWDKKaZC0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YLpIs6ybhVf+B/n2/j6llRPD2ubb+mpucZ5Efv7gOgywjdkYCn3RyjDd+csYagmW5
	 hJCLfPAFN8M+dq+D5Z7m/HuuxC9OcjiApGvc2IDoyiAwrM711rMV41Mt8Wm8bzJYnt
	 OArk7F3vP8yvp0Hn0ljEM3IjIzihlE0lbaRkjO4m2R8N2/mcU1IIhI0BvnAl+Z3BVw
	 xxXbywXflA8oZqWOkeo4D0Ka4S90JaxnYFPWv9JuvV3Yi7q+ZIygdv5yJdQ2lGgzq1
	 kAQ3I+qR1MzN+8cexMbh02r1n3jHKjc+AglOZYW7BJ1N/xQ0gELP1dJ8u7dsxreq0G
	 +cKk5LH3gXdpw==
Date: Sat, 4 Jul 2026 09:42:51 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/secretmem: disable under HIGHMEM
Message-ID: <akira3QrZGJBZPoo@kernel.org>
References: <20260703-secretmem-highmem-v1-1-30d5ff944664@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703-secretmem-highmem-v1-1-30d5ff944664@google.com>
X-Rspamd-Queue-Id: 37A41C0004
X-Stat-Signature: 48de45u1wnj53g8dxkrbyq3oamgsfh14
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783147379-949965
X-HE-Meta: U2FsdGVkX1/VFzjgn53gneE4LZzzNld1+IywuffymbCC5oN3tHeb8YNZpnWab51+7UW5jC8QO94tQ8rkADD4+mx4a2B+XPU6ZOF0eOXS/p+32jC9HUXtnpGWitWtNAbXHCx5clRUkjQPw1CPO6uMdCYQSMv1ekIEdCXY3/WTnvL8M6TFudbSN81mxP9vtAfS9D+D9075DVdvCcFCVlZ+ZQl/zWd5HwQtQHVI/+lfnsmAHnjy78ODQHCkJK775gNti0c/k+8abS73k42+W6F14SBGt2pVoF6XjE/yKrJkeFRcJnsjMvCmKgvWF0quI3PFfBYnyLMcdhoyC0BizlQkU6Dn6ZRhQvyPSpJGBX4GV/wc4gA3tUYgJHKtIjkhosVVwPej5gMmGAeNKOXZEpUN+7oOjamthGowG9m19lzZN9I+p3XDPEz8zXJYRZY81FOOc3p5q7amqvSfwyBAtwwnrCddraw3sHRq4NsDXF7wVlHwhP4IRX/M1wRI4VQ8kDUv6pg6hj623jYGMEDfoCvWYmsVzCp9vgbBsPWaMZIpytT2dBWKKIom9/QZpn9XIJCSJe+c0y/VSnFfzvu8GsFmuG46Iw243NUzmfbBx+dzP3TdrfMrVGwjAaLfAgHJZojY3rWfr6lHqnR68UjqHjFLl9DWyed2EAApHipDzVMic7cZ+Yp86IAxefXZxMTUWKPEKD58srwAoyMz1o9U78zTGbkNf1UuTAts6JmvhLWPZXmbQ2eWjzifm6nHN2vaUDXzrnnoXpoCGcTIeOcEZrxftFohfBLxGak+ZYOd1akCj4ZKe6HwrvqrT9DF9GyLdfnaeBHWh0+pSamGxeE8tnrG1SU/foVN4EWbStNZsVhW8XOvPQjJrVvdm9J5v1cy0Y+YpBoWa2WPORD1igib3GWn1cuGngzw1Ohy0sxgA9TBpjLMMMulI43S31askpQdGehzuzeS+fK4QFSB7hlG5w/
 2qXRlG4t
 tGR8B3Xix7XYS9TS/WA5/+hbkOzt9OhgP05srmjWBYd62djO5q+PCt4DZVF9GgAwA/IhaSsZ1eHoApV0sXyFVsDkS7rVxOse6noILBHLK8bcuXQqT9q5O90q7CpNf8TqCcocDZH3xeYfSqgqVHGDHWH4FkETPXu7SJhjRsgnb05WijpV/loFTHh2RPkDFVp1GzsRm85gdWMhwsOAtWs1fgaNGHfvfNGAvjzRHF+aRybTyQgnaSkS1FVq1SwYoXGCqB7xd89XXgeduawy6FhRej7M4SbQMSLL7+OyySgH9p4ywQi9O00lFnicJFUXN8q5ivw487WnG/+oScIr9tLE3ywbx2prM7V259JrV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 02:48:26PM +0000, Brendan Jackman wrote:
> secretmem_fault() allocates a folio with GFP_HIGHUSER and then calls
> set_direct_map_valid_noflush() without checking folio_test_highmem().
> This causes a warning and process crash (vibe-coded reproducer in Link
> below):
> 
> Link: https://github.com/bjackman/limmat-kernel-nix/commit/7b2acba2d3a5ef01400d493a155beb1d135b6bb5
> Fixes: 1507f51255c9f ("mm: introduce memfd_secret system call to create "secret" memory areas")
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

