Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ECDBE9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 05:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 503516B0088; Thu, 19 Feb 2026 00:03:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BA4C6B0089; Thu, 19 Feb 2026 00:03:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C63D6B008A; Thu, 19 Feb 2026 00:03:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 288786B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 00:03:10 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE8771B43D4
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 05:03:09 +0000 (UTC)
X-FDA: 84460012098.07.F5B1A07
Received: from lobo.ruivo.org (lobo.ruivo.org [173.14.175.98])
	by imf23.hostedemail.com (Postfix) with ESMTP id EC151140005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 05:03:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=VRp7cmXZ;
	dkim=pass header.d=ruivo.org header.s=mail header.b=NBdWDNqD;
	spf=pass (imf23.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771477388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=rgUOuq8+s6E9XErwU0wHbWiTKV6o9/+of9XcffzfYCs=;
	b=cmMncyYV2iO1qGM2UxjjbYVE1KCOSndulsV+E70ZALec+AcdmyPMWoVHeAonRQaPQZZXG4
	PcdW9Pwd2lcJrsj3WgpNGZjMRQE1ggOWUEY8AKgyCRYj1f2jfD/zWE3z8nC7Mz2zpJTmKO
	yoG0d7qwWG1kCK04qZ8L9C8h8igUvt0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=VRp7cmXZ;
	dkim=pass header.d=ruivo.org header.s=mail header.b=NBdWDNqD;
	spf=pass (imf23.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771477388; a=rsa-sha256;
	cv=none;
	b=eFYx67xMAkbRlFhZEdzucO5P3mhHKxNOu+qHip0sitbkTRTCRi2llwNsDK3icP7pN5vLat
	pgMMsV79L2ho5OJZtXVIio5/VA4C4czvQY3AbB+yAu69gsBkDb7FEwcDoeA+/LYIl/EDWn
	2A8javZdJ4NjfyqLwXFtzxpsnJLC5rk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1771477386; bh=GU0ijlFo3Auc4NIlfS913oGt4YwUM0CS5ID/b4zisu4=;
	h=Date:From:To:Cc:Subject:From;
	b=VRp7cmXZBwuN75tTX5zivcS8l/vi15hpht2xufrLTivTia+rGOnR0qzEAMKmiETLc
	 XrPSKYXoP74ZBiXpH66ZLYUUIcq7L9zEnVXSZVe9drbwdUg97rhHBR4665y/PZbVaE
	 9VxsJInPeSafLgGMnvnQ2gIUStrsYpBZZZEXijlE=
Received: by lobo.ruivo.org (Postfix, from userid 1011)
	id 9169B53184; Thu, 19 Feb 2026 00:03:06 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1771477370; bh=GU0ijlFo3Auc4NIlfS913oGt4YwUM0CS5ID/b4zisu4=;
	h=Date:From:To:Cc:Subject:From;
	b=NBdWDNqDgFlcsrXNDy3PZGYtwV1QsJmnkc5g5QsxhXCWTgUKaX0zNYaSa3H92QMt/
	 PG32wNWKaTrsD2dGoZTl/X1MN8uSgUCdJTvWS5ha/s3PRi/sRjuCkBNTuMMonxuWh0
	 4mpKpdYp8hMP9u18DnVPrDwFOvNlAQoAUsXsD7BA=
Received: from helbrecht.local (bob.qemu.ruivo [192.168.72.19])
	by lobo.ruivo.org (Postfix) with ESMTPSA id 49F0352388;
	Thu, 19 Feb 2026 00:02:50 -0500 (EST)
Received: from aris by helbrecht.local with local (Exim 4.99.1)
	(envelope-from <aris@ruivo.org>)
	id 1vswBe-00000004J0q-0ajo;
	Thu, 19 Feb 2026 00:02:50 -0500
Message-ID: <20260219050250.061598056@ruivo.org>
User-Agent: quilt/0.69
Date: Thu, 19 Feb 2026 00:02:50 -0500
From: Aristeu Rozanski <aris@ruivo.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
Subject: [PATCH 0/2] mm: gup: cleanup gup_fast call chain
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EC151140005
X-Stat-Signature: ez4fyy46fopgutns93tsnpotmdttw1hu
X-Rspam-User: 
X-HE-Tag: 1771477387-447186
X-HE-Meta: U2FsdGVkX19e7nsAOiJE5lwLIVCxrn/J38h1ROh+eAun6x9mSerudWi11MgTTiIeGRuZeUs2unLD8K2m0Nmodaga6lF1bfg5QoNoUZExHGwlYnLpH6VYqKMjUr3dfBWXKSjLV6P/56MDio7MYeRwASHAEahhfjd1Ekcph3jDz54cN5/+gR/4KQC1RZ4L95xpedALUWAqRSrJX0pzMGRigKrw0sXZktr1sdPAfPqsgEixxlh2y6USL3jjFGkLtkQ64HYCCs1uoetXfYs2DS9eDuyLgL/fHME3TYN9zZ5rnRC0XwHI44cJqLPSSBxcqbifosNoKWtlkM3Vmx9WFRl9rE/vUAFotbLCIPYuwKaJ8paqxegE7pa6IdHFwzgHVFv3hWcm1Nvwuw3Xoq/3saT4OwkPfaZXofIrQvM7jb39OWd4eXrbReTziYktofQ63XKE8oYRJ4Dduq0eWaF1tME98Cfl5J5xcdr7Ebs4megdwgyky0aGREEqjL/NarZfJL2VvJxb59WTT4jKDoasb3P6f5EnrvinFlrsg0O6yXqHwE29s/+MjjjTtiJI4J7QgB/pwhcc+cCZ54CbRxEXpuQ7789iTHm6NBHdtrWp+NG9Jyco8VZ8zf0PNARQFTBwjai9tlAJpUvfC36gYHieudNtZ6ufVpobCVcuwuaaHds9o6TlXgivHU5c7ti+QZfgEH2rLRuFzoS4WTBnl95YRnrCP8iEtPkte5l1CrAbnvFysbuvgdxgzbLSbX2b4Up1s+t7Gci6Z7uEubcQeq057a7fDlL8jM8QZ26goPpP8msnDV0nbSzKPaFzSXh5sVvBBMJvB9EMJClhaM8n2jrqSkJ5TcHZy/+aRK746eg+hSkLzSPz3XjcQ7XutEclavu/JT+uZNw/HKPkaNM7MyddOosoStZOiBHIV8SQfa6y01mcoa8pahd/HcRIBsTeCpOcWAuXp++rSWdP6jkHK48g0NP
 gUZIEJ/d
 McG0OYIov+tkZFm3O0wb1CuQO3Y/UIWpaaE4n9NYilQkfUMbSYjsjKEqB5QY6LoAHj01en/kjMfKtH4c7PHQPR3TKbzwJ7VsRo6tmiDW/iAIrk82sT6LWIhP61L612phQ+bKKU462UDfTLELPz7evb7IlW83KSSt0n8RReE+ycjOP7F9bExZ7c7QYd60u/sXoIKieNoDtugYq2lWMM0vJbK3bRE1QobiMLmTBIMqISxG98HPcfLd/HLYhIblyFGkLOPQdKKHjf26MyUmJK608y6e781YfRM+8RvO9vJ4hYKqXF54DPjZBmmxvhtkGx7R2wshqdYMAbMWajN8cYvGsw+vWujSyiJICUznO3FH5sJqanRUe6/mkOYMTGDO01dNfWWK7MiNa4tlIJGN2LR8yL1J9DaHp7bAgf7buAn+pPpZjnkQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These two patches implement the refactor in gup_fast call chain David
Hildenbrand mentioned in

	https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u

Suggested-by: David Hildenbrand <david@kernel.org>
Link: https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Aristeu Rozanski <aris@ruivo.org>

-- 
Aristeu

