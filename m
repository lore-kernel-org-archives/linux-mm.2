Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF50ECAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 13:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 047FA8E0002; Mon, 22 Sep 2025 09:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3A698E0001; Mon, 22 Sep 2025 09:50:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29908E0002; Mon, 22 Sep 2025 09:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBA348E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:50:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 82D421A05CA
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:50:18 +0000 (UTC)
X-FDA: 83917020516.10.77DE0D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id BAE851A000F
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:50:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a0gkXo+7;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758549016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGnFKhP56ksvTbt87RMDe3QMyAKJwKabBNpwTSWZp1Q=;
	b=zmsV2a2EZXc5JKy/4gJoY82FEvw/hBFJpz/8y4ZurSuAf3SrShiYwJaYa0VhZ++FcdX3fr
	VSRsa8CW31jbGbKuweBAE801AFNy1HY+/lxj78Yu9r4p9TCAmRaw5JTSU+iFqaNKBx3x78
	URxPRRTbS+sGVNaVvgPV8JZEWzJkb6k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a0gkXo+7;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758549016; a=rsa-sha256;
	cv=none;
	b=NlKV6Pjf6i/iVv9g34Sd5BGdlWj7Gb+NJrma187HbqzT8zsSVJHpIICfQ6sTXIdXsLHoY6
	cEgQid5vQKnc84TH9H65c8KdhNtjRgzLuwo66FOtTJ5pU5OY18SfCXGyirbfZ4QA+NOo+l
	9MYy6VpFizqk8NEnzKcKTx8e5T4KD2s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 67C3F44283;
	Mon, 22 Sep 2025 13:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F0AC4CEF0;
	Mon, 22 Sep 2025 13:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758549015;
	bh=KUdvoa11waaL9VuET18T94f4qWSxyLfuRY+uFrUSlbc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=a0gkXo+7nkOQjnfZoRnPryocuqfZjQyryU+hLaAMYZUqw6iC1azA7St+vnNuoVRTh
	 nNkh68Ro9p2RrHDyKGqPnT73vcBHi+RqgC+3AKVPNaQve8wgwDMUFVQP6i0bkwuyR7
	 N9dWi040fV2IjhU7VJw2lW7933JwoNscuXyevLoGxbgWMi5OaBVieTstCKHqaj9Cji
	 kL84/+J0ryNnwsfKSYoFZqW3DYPyLLWM2S8UY8W4aVKacDIN3c9zwcAHElgdPNmfHw
	 IDWLQQcOEjB88Apb8ReEL/jIX60v8tlUChs4T64rSXK5TqNuYDwtTgXtkZgA2arBtb
	 jYvB4xyJi6a6A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  Baoquan He <bhe@redhat.com>,  Changyuan Lyu
 <changyuanl@google.com>,  Chris Li <chrisl@kernel.org>,  Jason Gunthorpe
 <jgg@nvidia.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/4] kho: replace kho_preserve_phys() with
 kho_preserve_pages()
In-Reply-To: <20250921054458.4043761-3-rppt@kernel.org>
References: <20250921054458.4043761-1-rppt@kernel.org>
	<20250921054458.4043761-3-rppt@kernel.org>
Date: Mon, 22 Sep 2025 15:50:12 +0200
Message-ID: <mafs0y0q6fvfv.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BAE851A000F
X-Stat-Signature: tfihrnspzqi85zmbyf4z8kyy6wj6twgt
X-HE-Tag: 1758549016-478842
X-HE-Meta: U2FsdGVkX1/3Zy8JNwRUVr857gpM0qJTYO4zJBJL+zzJzsV8aQ1pX/dBdYAI1HAZnB4RCdZ9BY7y40JdC09JKqfz2BYfVdYgLSQbv2mqmrkjHYY95uCtYB3wkfGnIby9QoCzimhxaKcY9E1CCMeQJq/O5WF4fujaAt4kall/MlAav63KHI8kTdzdVaxXMLxn2G4IgmBSyj3IyuQ+f8MyN1eIWLR026UNP+iQe3CbA9RtJFLDyypHvP5B+aU27uvSScqr7vGqZXItFP1IPPWeqLkd4VnutrqFGdUETHfFxp4VOYzLIyR7DlyzZqzoXVi2d/2nqMFYrW/OUwZNPQ38LHR/0460kv4HBVHcIETX8gZb5HxREE+9cC9N6sz7L9xkpvMcfdb4JyZav3iy1FbL07j31H/DVDnAVQI8k13whPsYbMBphozYKqLhnBu4u/CpY19/PSBODoEWlsDYqsQKpskUmyYunhjLENWjJXOZaXkH09Un1F294xDUmLSoYmtDIsHefODGFP5xjV7CA2vuUVidnSDw/axzNXkQNEmLRKLP6jkz08A18lSLNeDi8UF4RJsfYj3VFM1kLS29lt1YBzl22HEifHAGpK5v1NX/uBxTaQUZAq2q94pywo8Mfr3Ow7E0ZGzlhoy1pGc+KDkSntzFq/zs9SbO0KaV81p4EKq3x1+ubO8X1cMd7gdF6aGUP4TRhsPo5KgZKFvnulAOCtAIO0sb58hGX3Sjzz0O6+VOGvJtkQIOFn9MOqfwC4SPlgv203X0isA9QsT4Ey/Mkv8RgUHEkw7oEfgYQxTp3wsfHoMjETiRDYePvuSF4IenkfXzDOyZ/zkARNVVdcRS0x6Gi7dnTUj2Dp7vTgi1+Assdiy9waJRzMH5S5nfJkcVVCeyj5T/fhxZJVrFaAiygYLykcPs4a9usU/sPoP191r31S/jPzZh4cCeAcngNwHuC0wduDixYR2bdeS1mKi
 THGQp8B6
 K7WgEIUYjCJ25lYx/N0RFosIWEe3fXC4CoiPkMzPiOAiYTDtjbf9plW6L1tgodFpuEjR0UxiHyTNRv2HnqYVly5KmpSGDnw0q8TurOia5Cc3Wnvj8Q1ZLI3RlKnkNKiZhWLtSqLX75AR7wTj8mCcUcWV/jYCIOo4Yc7Hfyy9doYKcwu5rjQSbttyP/cYZbn7f60s3IZVH+3BqP9OK0GZOSmj0nhXbJlHbq3J0vT35ebkviQLCtwNIIHLYzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 21 2025, Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> to make it clear that KHO operates on pages rather than on a random
> physical address.
>
> The kho_preserve_pages() will be also used in upcoming support for
> vmalloc preservation.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

