Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 171DF606A881
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 08:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gP9xyMgR
Received: by kanga.kvack.org (Postfix)
	id 2DCA56B00EF; Wed, 18 Nov 2026 03:19:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28DD96B05B0; Wed, 18 Nov 2026 03:19:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA156B05B1; Wed, 18 Nov 2026 03:19:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEB8B6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:19:05 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E4DA16064C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:19:02 +0000 (UTC)
X-FDA: 85447539324.13.590F224
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9A8CC1A0005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:19:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gP9xyMgR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794989940;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B+hVwopWpyfxcE5J+4oQuVDhp+i0Fr4gEIPR+8Nt57U=;
	b=woZDYZCc7lTmFRm7FLjhgOIARJvDTCaE/EdMEMoQOchH/2I+fqCOqJrcI9Jyxh5oMHkiMk
	WAri0coH08yD4ylq/sKSKrlWOPj/MQKfa7yM5augCb8arzqM73yZZbyrGcLCCvVpChrvzh
	1+TPr9tZrrIyVfz58qQPTKfkJGu+jMQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794989940;
	b=WYWhrWEL4eXxYYk+0wFM1cnj7CfJKtFWhX/wbukiSu96a/lXMR5T29Q7dm2d6aRT9xjwhI
	r/VUy7aEyH+8C2lI/XeqL0T8UbQlx3Vt4oF4T159q+XpOq7XfB9diAPIdSysxxFj5smxY1
	MqCev+aqSuH7GxXQhMvLhrRsJmgN9P8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gP9xyMgR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2726161F7A;
	Wed, 18 Nov 2026 08:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9B91F000C4;
	Wed, 18 Nov 2026 08:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794989939;
	bh=B+hVwopWpyfxcE5J+4oQuVDhp+i0Fr4gEIPR+8Nt57U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gP9xyMgRLbFtTHJMF9iWTDAxkSjcrv+N2R3N3Et8McBMDhWyo2roZ5D0xs0y4hCc8
	 XpVeUn9d3uetJz9h5ZiJaVmbJpcnQMwJhsEoAfL3Fq9bxouNq5r8FFPNS9oibudcGm
	 pMDi23X8QkBnt9JC2ctqM2xKmulisTOcYDogW89RUAqm2/vFMuptgJrvraaKSApq2S
	 8QDxoPvAqL3EPE2p6aQ/4g5ndeWka8HckgMLJJvcPoAciUpE/alx3djCN+a+cuUlBv
	 fYliubXqCWMuFtX6bx6PDyLmpITFZsLF9AG+JlXdVmM0BKkbo3MyMSAyrzOgP8j2OA
	 CupY7toEm9PzQ==
Message-ID: <sashiko-outbox-220424@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/ksm: do not inherit ksm_zero_pages counter or PTE
 markers on fork
Reply-To: sashiko-reviews@lists.linux.dev
To: xu.xin@linux.dev, "David Hildenbrand" <david@kernel.org>
Cc: "Donet Tom" <donettom@linux.ibm.com>, "Chengming Zhou" <chengming.zhou@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <20261117081821.7211-1-xu.xin@linux.dev>
References: <20261117081821.7211-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 08:18:59 +0000
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9A8CC1A0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: nptkbcs7nrrorwxoqd6o3bj1qr756eu5
X-Rspam-User: 
X-HE-Tag: 1794989940-140997
X-HE-Meta: U2FsdGVkX194hacZH5NVrHW8gXWmZYxKVK0ummqvka+AVc5XfOxPg0UsPppwqXZM2EG7zm3In4MMpItgkvX5uNVYDXQRGTYejGiDwQVqKewg2b16pr6J5jDXrRp1SY6XtIKYCWfQgUBMrPoLLB5VTwE/1INB3kdrdiA+k0i/BuLLJM0c9x/zPRGam4yHL4DaOoYUcVgpFPhxdZmtCIyaKkJNn7plB2FpQIUcoqCKaRmZ0Pn5Gf3/jdIQJbK0HXBSJLLQO8k9RotfY9RoxJdcsbfp6Nn9VqI6ipsu8HNECTN054PzrtRzIWX5bsrfxdI+bD8hcnXA+UCpeL2+ps12LMnZ/Shpo9RoKScYp40beujrU4G4fU6BVbQwjD6uet8cxp5Id3SNrNXk5Pe25cQma5vEbou8LFn1IxQWCS49r9W7IvyB0+8plNOcK19/Lff2bNMESTR/4EVtlMfzfhEnHB3D7lIlTm11nYZNuhqRRiN7B3m7LJaR++nKwODrGieRCil1lF7fT4rYGW4Vf3SWCWybHqYUFjOBfq0J4zrVSFMpFbg2D8058dwOaGxItXxAzg6s1xYJwlKZbXcz2GVAKZjy1G0/m97s1HreUuWNzDOiJXdIIq3PthOoklezkQ4MLZZvymN385dTqN2zvFc4ByS4NZGVjvqv7VBvKYXJYAZdWobjLjhg2iegLC3dal54YvlsrItnU3ddRMBp57ZGlnnDVsgFirDH2CcWsS5Q+l3L65NXS3cOtHtOg3tVDLltgBg5u7VvMxs5lML8P0gB62kNM8UhBi7XkxtUmDfsERxaMbiQ0VDHFEIPkPzku+qj8VT6sDBvCFNeN1p1FBhpjk9O2RdYiwD1DLm7n4/c45cVDcsKD5ETLNXIDF0tzStY8drm/UHCgirgb3hazNUUrIwzMBW2XmynzRrrrS5C3/twJZCM2zEwzxVjmn2xGymJJiuxQxj/IEODQkqmvnB
 1EEKKKEc
 U/eLGdPfEvmNHYMl4xFZ1hV91C1xL6lXhdo87hWrDO4ISC9lq+Y6Y+tYXoEW8fPzwx5u7v2KVJG0Jfxt6AKWyPKiJ9Hu7Ws7CldiiMRMf2IAME0R1WpguVBZVhvAD0Ug0fMVwSHVKAgfVIqbKXMWmkyqFOM9kdu40RWpaf72q1xFwzKqSaann5LXlDurWOL153jHhhRBpqsy3kOVMccsIUhtS1zXDQE0jc2nrv8pBd6X+iMAHk8soIVjtp+2AtdqRt4qRPP/PN3kNLP4nvPu1NX3vlihUNP1H+C8TLBrskVW3gWC8j6bwsew/0OfpV5UeOjQ81Wpx8ITRjU75/EEY6tIViFhC6/arYfCNI7iLk7BYPGvTN2LEqWjlslVznwS7FoQsISYiIdpIgKZuyHSGrYAfIKiGYUcNvDsj2y6xKoNE34nlLmLco3huJQ//IrJXbhezxybK5bBmlGUYUQvSsBfour2yAuyAs8ylBIr402LnEB3VwU+Nv+VjqZUWLUJJ3iyxAyWY6Gz7jW7/xp3y0H0j39VrgApcgs2CnDQUZBTlkPIObaaQ/aGE1++V5xgBtz9Lvx1fTMTa70eN1NoAUI9kHmALhFA3pA0BtMosFtgVP8s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/ksm: implicit declaration of is_ksm_zero_pte() when
  CONFIG_KSM=3Dn
--

commit 113c3050b4809182bceaba3e1d17c686dedf4a41
Author: Xu Xin (vivo) <xu.xin@linux.dev>

mm/ksm: do not inherit ksm_zero_pages counter or PTE markers on fork

This commit resets the child's ksm_zero_pages counter in ksm_fork() and
clears the dirty-bit marker on KSM-placed zero-page PTEs in
__copy_present_ptes() during fork.

> diff --git a/mm/memory.c b/mm/memory.c
> index d2f48d78b0d7b..4c845b38d4a01 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1160,6 +1160,14 @@ static __always_inline void __copy_present_ptes(st=
ruct vm_area_struct *dst_vma,
>  		pte =3D pte_mkclean(pte);
>  	pte =3D pte_mkold(pte);
> =20
> +	/*
> +	 * Clear the dirty-bit marker on KSM-placed zero-page PTEs in the
> +	 * child so inherited mappings are not accounted against the child or
> +	 * unshared by MADV_UNMERGEABLE.  Special PTEs always have nr =3D=3D 1.
> +	 */
> +	if (is_ksm_zero_pte(pte))
> +		pte =3D pte_mkclean(pte);

[Severity: High]
Does this break the build when CONFIG_KSM is disabled?  is_ksm_zero_pte()
is only defined inside the #ifdef CONFIG_KSM block in
include/linux/ksm.h, with no stub for !CONFIG_KSM.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117081821.7211=
-1-xu.xin@linux.dev?part=3D1

