Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEB25C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 04:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDCF96B00B9; Tue, 22 Sep 2026 00:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB4416B00BA; Tue, 22 Sep 2026 00:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCAED6B00BB; Tue, 22 Sep 2026 00:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B429C6B00B9
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:21:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB93FC038A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:21:56 +0000 (UTC)
X-FDA: 85240100232.17.C573017
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4B039120004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:21:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Me/fCZ3M";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790050915;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=syaZVYvUtgFnasCG/seUwWXzYWSqGpbsEDVlFQfkXQ4=;
	b=FW4VV1qcqfXtBUQP70BhUF2Y0L5GI2POqpH+FTgZmpHPyEMQaX1HQPXHMDpSCFunRJFQWk
	v8AfusjUmLd8ATcvnxOUMgAyjsaGPoSpyVBuoxN61e0cx07bb0svMlDEi0UDBSMz84+Bf9
	zJ9L/VdMH+qiz4W/wHI/nTSFo+JeNBA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790050915;
	b=yKbKkqntzmgqBIspv6H4VkWNcCA2ueMEvgxZkQmXjRgJ/gw6vRTYosLpFR6m77EgtbatJN
	Lkoi+aE++Z1KH1n4oXLf+Nz6oEDPWlp5D7A9724WndZfQ0y6l4XYauqhv+d3u96GxygSZl
	/LWx8UH4PbQtqXKlfTQ3LzafamUf/Rc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Me/fCZ3M";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D75D760210;
	Tue, 22 Sep 2026 04:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D851F000FF;
	Tue, 22 Sep 2026 04:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790050914;
	bh=syaZVYvUtgFnasCG/seUwWXzYWSqGpbsEDVlFQfkXQ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Me/fCZ3MkA+e5U5b7deNmL46lRZBivAbchui33mecbxteRUKkj+jf8wzRvO04cu9i
	 EZ8xCRpw3vgbZyON30v6aXiQRUdJiKxepri33w/E2eFJyEVGZfPB16OW2r0qNWWblq
	 Oaa5LwQbUzjU7/+shPeIpqLzgVyqXVy4zfH/Bhfx74HHNvfWT8OI558TpMVhWeik3H
	 SQAzsnkOufbKRZcUm/Dpibq6u6z6g35XOq6hzs8/pEt5uIJpT9s1nytWeUKhBWI94a
	 EmBttiqJC4CSt9N2V7WgO0Jd1pPIbayqwCbuGkFIKACCA11pRoVLg9AGPG6UABCkRv
	 vQrJ/mGlQJu1g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/4] kho: rename KHO scratch to KHO bootmem
Reply-To: sashiko-reviews@lists.linux.dev
To: "Lorenzo Stoakes" <ljs@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Alexander
 Graf" <graf@amazon.com>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, "Rob Herring" <robh@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Pratyush Yadav" <pratyush@kernel.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Ingo Molnar" <mingo@redhat.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "H.
 Peter Anvin" <hpa@zytor.com>, "Baoquan He" <baoquan.he@linux.dev>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Saravana Kannan" <saravanak@kernel.org>, "Arnd
 Bergmann" <arnd@arndb.de>, "David Hildenbrand" <david@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Borislav Petkov" <bp@alien8.de>
Cc: x86@kernel.org, devicetree@vger.kernel.org, conor+dt@kernel.org, linux-kernel@vger.kernel.org, robh@kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, kexec@lists.infradead.org
In-Reply-To: <20260922041321.233986-4-pratyush@kernel.org>
References: <20260922041321.233986-1-pratyush@kernel.org>
 <20260922041321.233986-4-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 04:21:52 +0000
Message-Id: <20260922042152.D1D851F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4B039120004
X-Stat-Signature: 1uzig787dddkxp849inw7xbf7cctso48
X-HE-Tag: 1790050915-211913
X-HE-Meta: U2FsdGVkX1/BqR6f5Ua0qHup7UStEuFwC/JKBDHwHytbWnmTSaDVlOnFljAcOCEvzOcGJLzuq4etWe/bl3j8UJmzMfQjsKnEQcMjpUj2vJXKzn/vSzsH3+kD1UZGk6Qg+zj5ULYIF4Lq9obslMrWKaMjjU4WTHsNJjWHj/+eSzZ4y7XaV3Bov3Y5/tFMA1bWhH7ljZuYRLBMud0jf0sh8gdnp2YvtUePv+s5QQZe+KXgrNy4U3JURaVsS/aiYAY0p9wHkzrflR1IS1TJkvCIGxfLfnFpWJYrTapqjA5hgInubTYWmkgoSIURV4ZlB5hM1Trf57Q11QUztdytJQNEs/amCKnlIjabZw4wvyqbrRXqAuyiveJwJa/Vp/pbHBJb6QnVKh5A+G0z1yz4TfuxuMouvDnZNpq83jqssSw0Fkxr66qcvaMYx7sIC1poPFI9jat2CKdJtThGtamenlSkGNX5NxBZ49xbdtwkkyM+kxE9iHIFDlveR9FvynBNL4Oe1RY+dzloU6C1Gop3mx1p0sexYMpwC32C4sqgaqsydPCIUBEg1ucrH6tdL+JuHYMAvnNyVo/DaWVZ6or3hTs/WOB6R3X3ZS0LaTdjiC0gP2hz2y21zvS6o2DWIJEwQdE+lY+tUSnKTdmtxuUyOZiqNVWaWPicjSNdvJq6MCKG8pG9ZnSpIKz2LH1rI/LP87yGq+xsKYxMgN0X89pInZkGsQZCh+bC1Y6bw5a7xn9ihwpqO7IMY0tTrCxXJy2TisM/RM+/LYHPEllbj74IWQf8bS0yRL4sVjz7R2oBR0CxR8L0tVgYJEyz2yqLOULuu0gsAm0aNh4FteTsX4uFvHlsJikdz7K691VZMRjBN/AhuDFlZqZMzXpAJGF5BaOuOLnHPzv5mDJJKXo1Dr3uvta994Lj3tBCT5eaYiguen2HTUu7Ehgfpyc6Vdy29jbcg/rxzW0wnD0B5rBygAVxMhp
 Cynnw9/S
 SjtrCNgBEC4DPNWwY65M5h3PP6M+2cR9sVLJzDwHxSSEnD6/XGsv4QMDdAd5cbCE01GDHnzczwnt7z6zewM/dqYp3WTOQi4hXY5p9+Ra6RSitxyubRxNzQxvPBYF5nbn8+2+Nme2xMKzNzgdqObPFGQrxcg8JVszH7bzy9eL6OvK8uze2wJamUDd3nq11neVQnuI8IAkyhz+GhlxxlDQdw0eyX+mOnjqgUL38aSe615ZhzXdbbCRIqzRE74i08xm70+0DHW99UOF47F/M49gyWSRhWNsw2VtLFZBu+MMrV4NHURSXq6qWmm6vAwTh43pAG8Y66ZNVtakk9o9WceFpzfPmm3zd6nVXjWooepnjSRDMtUqVXhxo2yKZ0yVt7c0YLTtw6hLgI3EM2ekjuoooYiHJMkkqh3FQ1MFakuw/m4YjmKRqe1uaHsXGAjQ/cBLIMRIj6ktphaotiYbsV2FPtu5y9bgUkTtaT2YO8XrEUbfzZ5AG4wL2uo3gKqEry4yUd8tOQlcFTInBu6oFlU1prQWAylOSPlIOZQtIqyjgrJJihRQLy6yXFjZ76uz8BUdBxz8W9gnqfVvxohYduhws6+4+rC5ztkGUvkNQhwrTqNaCaFX1ggqGl24Pc8G73Eqpthi+kluKzhgZbEzuFFk1EsG+qAeagQ50kBtOH/rTDpidpdCh3Wb3zpdbzNupOn0DLO+fo64Rj10KY4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>=20
> The term "KHO scratch" is vague and overloaded.
>=20
> For one, it does not accurately describe what the memory is for. From
> KHO's perspective, it is memory passed by the previous kernel that is
> guaranteed to have no allocations and hence it is safe to allocate from.
>=20
> For another, the term is overloaded. KHO also knows to discover other
> ranges of memory that don't have any preservations and are safe to
> allocate from. This is done by kho_extend_scratch(). These areas, while
> called "scratch", are completely different from the chunk of memory
> passed by the previous kernel for early boot allocations.
>=20
> Rename "KHO scratch" to "KHO boot memory", or "KHO bootmem" in short.
> Update all function names, variable names, comments, and documentation
> to use this.
>=20
> Call the discovered areas "noprsrv", matching what memblock would see
> them as. Rename kho_extend_scratch() to reflect this.
>=20
> This patch largely has no functional changes. The only functional
> changes are renames of debugfs files from "scratch_phys" and
> "scratch_len" to "bootmem_phys" and "bootmem_len" respectively.
>=20
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922041321.2339=
86-1-pratyush@kernel.org?part=3D3


