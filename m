Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E3C6CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2C1B8E001A; Wed, 10 Sep 2025 01:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DBAE8E0001; Wed, 10 Sep 2025 01:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CA8A8E001A; Wed, 10 Sep 2025 01:32:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 74A588E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:32:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1EB645A513
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:32:27 +0000 (UTC)
X-FDA: 83872220334.05.C216046
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5BF1840006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:32:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cNbM6oZ0;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757482345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96+nFua0lvoBAT5TkzLTpIuvi/sQOjbeRjcMdzpxTOo=;
	b=1v0z3hfWblLqBHvd52Mpz4QYbZqYMCr/MtqnVJI8Vd1YkPgnVE3kXGR5Byamflsrx4qq7o
	/RQvJQITDgBEpSVFQewW67RomFtLEtg+fKyFIdywyhnitzgPaOFVy7jL5MxIr81C40DNyN
	K91n1R6jCw92Nyvydj9NRJaV14Zwi3s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cNbM6oZ0;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757482345; a=rsa-sha256;
	cv=none;
	b=SbYy455ycqfpL27hli1Yfz1gfyXHsakY8FQt/CuVaL8ittipam4YnRE4bjEdV+YU4vcdYv
	sZSAnmYu+MFGcE+KEvN5WC0VlBNlK4ZJizTOPAsC3c6NOwQogvbHBSagOzOtEyp9OEQUMU
	XQBuoc4cs9eizc51Ij3O7DL5RKrEg0Y=
Date: Tue, 9 Sep 2025 22:32:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757482343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=96+nFua0lvoBAT5TkzLTpIuvi/sQOjbeRjcMdzpxTOo=;
	b=cNbM6oZ0gFrR0bGqu3X9OuekugDQE09JfMarGERbPwHIC2/j6WgHANxoVgR8Ndb9iq931l
	BGf1d2F7vw5f/u2xoy+RwY63KDxjo56pNaNznjQmSUXrmc0Kht9/v2GYZrPUnClzQ4iLdQ
	eS0ZoVwmL+oyIIq8A/SGQN3829tT510=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	usamaarif642@gmail.com, 00107082@163.com, pasha.tatashin@soleen.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] alloc_tag: prevent enabling memory profiling if it
 was shut down
Message-ID: <k6dhapofhcrhmcigqasy25lxmht4ybxp7jv5rg5oe4fjt3feop@lkyiqad43b5b>
References: <20250909233409.1013367-1-surenb@google.com>
 <20250909233409.1013367-3-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909233409.1013367-3-surenb@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5BF1840006
X-Rspamd-Server: rspam05
X-Stat-Signature: 8gghncoxqdrq1g9eus8u87jhjbh7nngk
X-Rspam-User: 
X-HE-Tag: 1757482345-244471
X-HE-Meta: U2FsdGVkX1/ZhzSfu0QWTNMy7uth2QHtUIhn4OdIl9Fq/5pwv9HFTbHVFxoTlyVnoQOm0mC22AiI8VK9TN4DG8F0/aay6EHCkSBIJsn6zg9QB1volqkvVy53cTi4TVy4Sep8/CCHjyZX5taOylGdGUEY24dOSu50jQrnZE4sNxN6heCKUQ1gWHo2ylys+z8zIoqLKgode7CL2TLZhve0eWWPBV4uQjNJ+OdfAM3nsETUqcVI1ahRGKfcNqXteYW1khwM3XdkXXvDJ38EmmB52K2QPKvTb4G9LZJ7KY1GwcUfVZIuYu881wqFNasUshnqwjznGGrqzgVWcjmUuzTQ+XEWwFU26imSZQ9U6z5888DDqgwqMfv/1sTUO1sNSgCWyl7ze/5x9GQELjk9e84lI33uIPUxXoE4berB8h+9QV8moZ/782j5k3P6cgxbpJF51ILEGO6py4HjSZmNsNd6AuuL3f++X/stUuccU7LeVfmQJ3RBOsLJZDZPYFWvUeKO4W/uqNTk+h9ivvvKDbab2gTdUxnT5UcEOBkUZDJjXbWA58yxXlPc1skNnUY3Ky+B1O7ziQwJx7+spNBX4nAo8TinRVpu9Wlwe222P/wvztILKG+8C4XgGCBnnS7dQ43/PnhVRadMkY/YkRAAYcKpbFB8LKmTGuguSuM04NnuCaFzrltkhy7EV+s738V+rAKuErkltve/caKfRzynF9jdxzP4W9GhT/3qbizh4HF56NR9ZfX0xp7BYw7nl2rUVHMrpUc3dSt+yU+XXD6Jn8hhrEbuxLqVwh+8KjDE8bgxQZg/vz6nNXkS8Jlezg3BewSVbMjJ06H4r3WgxciFphDERmDyuC7s6VHGLv/wooOxMJUOCi6QC/W+ws4kfYnukCqATAhpv2R4XX2nnz5dhDv8d8v0//NRh/GZ8X3lr/8XG5meifizCcMKue5Zq7hBYQCQolG4JKJEX5A3mmo/Qjn
 thjmyWlF
 hVzlSnokHyzpqGG1HFFh57Zzue1oj/lIdGKh2mKea0Y8W2yUCUWHWF7amDgh9iZnP8uHXtDFSrF8xt/mqKnig3vbsXWaaMPJ29hSGw/6s6ZeKIO8Ssa3PXwLIzUhF/BPjbW2su9YZRf0GPOAKhYIrdnZWmEs+H0as1NF1llvnAFyMlM/p0v2tKbajdEtSs7DiVbLhYySQRcELGppf7PAignFoCI0Kf5Fqg4e9laD4hxl2WkbFhk1p8GbxBofyG9SSQvyEn2MR6NqsvYSRXZjlHtjZmoJ1lcdfQT8i5/6yqO1+OY99yasXzhWlzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 04:34:08PM -0700, Suren Baghdasaryan wrote:
> Memory profiling can be shut down due to reasons like a failure during
> initialization. When this happens, the user should not be able to
> re-enable it. Current sysctrl interface does not handle this properly
> and will allow re-enabling memory profiling. Fix this by checking for
> this condition during sysctrl write operation.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

