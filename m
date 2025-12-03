Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9EF5D1CDA6
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 22:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D2D6B0026; Wed,  3 Dec 2025 17:28:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91CB46B0027; Wed,  3 Dec 2025 17:28:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 832376B0028; Wed,  3 Dec 2025 17:28:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 70A5C6B0026
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 17:28:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F87C13BADB
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 22:28:53 +0000 (UTC)
X-FDA: 84179600946.17.9668F6A
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 586B240004
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 22:28:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GJuBZZYB;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764800931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJuYblw+dPBNjt91k0IyybwASRsrokbHzJNmEJrb9Ow=;
	b=6Z1yYuisgLw5LVL5PEqXNKp3gP47FmePPk9Z7swjPCavmWR4dWUpcj+byi6+a7ECXKIh2o
	3XDAUXleyWTL07QH2Kwqeal0+L1w89RICnhDmnJqNKzEWOu035Yw/B7sCAuoig7ommm8fu
	q4YhTK7Et/lnnU/DHeIU1WijsEm/6us=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764800931; a=rsa-sha256;
	cv=none;
	b=IO6GVdKXv+cUyHdO8QGWOTfnzoR8JTKa9Xjdlt11ABoWGV1m5E0EOZEHzVBl3EOi6MNSTm
	qzL3wBPArRpDzORlZ0jOEsuAbzTcawHM7iQDgFXFlg/MaNUT3alxgx5Ysw9J5RsAaT4WBy
	oAyUsjChWRLbMEtOzLLiufTgMNZs40Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GJuBZZYB;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8b29ff9d18cso21907885a.3
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 14:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764800930; x=1765405730; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DJuYblw+dPBNjt91k0IyybwASRsrokbHzJNmEJrb9Ow=;
        b=GJuBZZYB0F3k0zWaU98eG1uoMeuWQq3wZzZlg6N11TY9hFGK4SgRoQNU5TizSXcvBe
         Q+XxqkGUDFoye9u+Hpml/hYC23TkDFhcGXoqvNzDZnASDSWg8Vz65+pF0yM8zRjTNdwW
         h0eLn2RBuxC/zIYrKyljQaK6mglQa3k/ygijSVORsvFT0iLWGXnINcP0+ldp4SFJBPZp
         HfHehQ/9C+IAvq1Y1v/SLqXBh2tQIucChToVaXFn+RUTKiHlNjVZlUB0w8VvhhBbmo7t
         +kIZIhmKrLOFBQkgk2PoYN9OM2sIH9wDVxm4TWoaIHT90bL74XjNY6yIujcvZPVqwjjA
         G2fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764800930; x=1765405730;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJuYblw+dPBNjt91k0IyybwASRsrokbHzJNmEJrb9Ow=;
        b=DcvBp53NIJK+CNrU6HBQKIYVaXqob7Ot2/PtEb6NQyZEfkqSmm4cPRYA6jBhKh1UP8
         JRdNTa7dgoa374A8Spn5fH2MtpjttJrqo398sK8zngiNqMknYaAeMQQg7rCEANCy/2OG
         nT+PPGlal8oddc8exHZVCoWfLA/LyryTgdgLZ5WOX8aTynJUXzQjO3lnqULe8KNw0X5B
         PN+MCPBEzme2b2dCF/nV1TG6YjgRCc+MZJDyGauhclc5stcW/5j3LPTobO783AhlbuL7
         ONJTkJpypGtVLH1gxnajAKasr6eAIAUoo8roGuiUqGFoHV2m2qKItXUIIKX5VXym0yVs
         Uqlw==
X-Forwarded-Encrypted: i=1; AJvYcCVlOyFGTtRPrWx4pTwicW3AGQJ51ulCRdKNaIRtrkb0YT/CI2kvacNGefpDAPd1jnHH9asFC/jJrg==@kvack.org
X-Gm-Message-State: AOJu0YxPYgzzZqZ3PzSdKI7CtV+kPXNqUMBoDY7EFKbtkXQrp9kLl1Tv
	14iqDzcHbuJV31+Z0UJuTv2Nsk28OVMxXp9txKoKfI3KXbs2CHUEiS4YZbR6fYMZOek=
X-Gm-Gg: ASbGncstccTuC4+gFEOsHxbtl7MRtStjVhb6Cvq7AQ5bvuCpoeoZSF9yUuc0rdxiOjq
	aVGgFqEmzmy2GsmD3iPwVSgxE/1vF7+xgHPPwWs6d1AjfrYYvfoqZVqOBR4jOdyVpYWK2E0oxPw
	xtMMlTBjd63Io0QznByXzVUDQaJy35k/ejnhdrlv+mWF1RG5VdLI0InAi+fjrQY+4MUxiz1ufuj
	S3lhDtXhms6gb/4e915OHKw2OdUGaiR1E6f/EhvGdcxNqaRTgofRDFkPkBHhvIg3keXYWUOZIUI
	P2Cwuy4X15iBNcmW1pwsbGv7FWS719PQyebS0+VqXeT3Z4d3kVFeOMduQDhfB0fcFsl1mB1VxMN
	f2yy1E6epd/GQtzlZG3R8+TcfNPBR8sWZztmff75aiOrLlmrZZOurcBYGckFfXpncnnI5atjSGk
	ZcMpRau0HhUtNoif6gpRD3Vc9ZPRY=
X-Google-Smtp-Source: AGHT+IEUEwizfwI1xIa7YtPlnP2+rXbYxdkvrH4FZM0/DpgOe51+DlMUC8XISbjJnJhjqbc0VNYliQ==
X-Received: by 2002:a05:620a:2584:b0:8b1:c1d3:8e91 with SMTP id af79cd13be357-8b5e5b15b5bmr548684085a.39.1764800930450;
        Wed, 03 Dec 2025 14:28:50 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4efd2fbb8d1sm130179381cf.9.2025.12.03.14.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 14:28:49 -0800 (PST)
Date: Wed, 3 Dec 2025 17:28:49 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Jayaraj Rajappan <jayarajpr@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com
Subject: Re: Calls to do_swap_page() from handle_pte_fault() on a system
 where swap is not configured
Message-ID: <aTC5oXnJqoHFiJre@gourry-fedora-PF4VCD3F>
References: <CAEJW1wECyPh-wbgnnoOGY460ido=U2A3rPhF1FQAv7txed1-Rw@mail.gmail.com>
 <aS_ycQQh5n1cVIRk@gourry-fedora-PF4VCD3F>
 <ac78e666-6c59-4faa-ab87-8b1c7caaeb9e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac78e666-6c59-4faa-ab87-8b1c7caaeb9e@kernel.org>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 586B240004
X-Stat-Signature: oidskwadzztxgzhsen1jzqgbx54fs5pk
X-HE-Tag: 1764800931-902326
X-HE-Meta: U2FsdGVkX18KJESq1Hx1oSj0wj1hG9W6LtKfPwVsGByUy2275TdzVYCpOobS/RJAPxx41efxETaikoYfkC/OTzbPZ8r49XDIIBQ4RF+/OpRPXuQy+U/VrdCMhgd6Af0X9N39+K6/+Tuy4qzuussk6Wuwv9+ggc+1NjJsqnATbD+rUp4Ka10aTsz/x13dte3G1iZCNJK4yWqyQC9eotQCbKEFLUZTTBVgBEUWxtDPaLvr91vgSw88azz6PKOixIZMXtvARkqhZnOHbPoKkOe/627NrfmQi+27wuMypLdm8l66sH42iqYSjIF9IuqFtq1TNKDxUXk2E/Xk/CFoL8dF5t5MkPG+G2Xbcgy2HQ3X0sc5iC63qmWq2Vxm7Rl/UtjlLq5XF/RQpACY4tJKWlVf5gXoUAkDgJThq+yRBvH7Bn2GetvkqADqnEujrI0AgzTAe0YenoIW/a/f73R/JaM+0TVxoHlgkBVRQ1+t+ofbrg6QWbj6BuLDMGSoqtN6QI0leFFBiJh+PHHMDq45lOLqmbZmZnBeLci3Pz1TjLNzrdYSH5JcCCLRvDmpKDXBBIYqeuMXiQfqDtZG3q40YRNBlbcSsOqP/u3vE8kBGG9vO3t64vbasUNwfQsMKdJHIBHBfaC4zUN9ycDELaHsG7a5gzB89dl/Lb3R8nE8waz0g06pPd7mS6PI+cFqeO3NZxl0HUqj7Wjg9XXTCBOfBy23uMHDD6htWe3WPaJfV0YH53nGLBoD/bfVh8rPnW2X6ikp8UeRVlPkgVOCoMUOzbyw7cTfjmskWC384h8tD/7s6aC72QQed4O39ifsluuKMOkjp11Ek1ir82vnHiECkffUgLC23+s9sLPg/XwYVcW4Z24PRRZxQFr6TcoowzpQyPVRW2JEeGU83XDtdX1tdknn9AjcmHGIUvWldTOBXT3OeURXVC+LnWbu4p0qXEBdulQn5an/wu7kSoaIX0T9+jA
 793jq3hL
 lbD/O2o+/E0YEntEyAkbeelZdyvMuZOmYHlhGspb9FZ68hAdInyGmSb3FoifB4qJou38WZnmRO2WlKtexKpyjfFR4QJ9hGeYPsDgkMsQ84DjJb86yud+L3u3iP7EgOlRT0Bs5I64Xv+3e0gr8YjOkruTd0Wt2jNFsjAfWudiSmrI5UNfJJpFAiZr4H6Cy6ZodCTfxr0Zpk2nu2W3/Yu/vzGz03++TmEjnMnUjm0i3Rj9nL2RrU14EaExWxqjMmWWDc57SagbsdZszeXS8dJSBdsmSwMRZko6g1RRvmeTSScaY6zBBkKIAZUePS0cwKC+psM8W0MywAK6IcwqFOgzjASinubll36KtAe91cB82PkRBKurdx9x2UVubtly2bz3xu5RG/4ovX8UgViZ49yUaYNaLPicgrQXB2g0HB2JDZSJxpknsPW8Un10NtD+aI5gyFZajWFhccwETC9hDhQDCYbvYkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 11:12:23PM +0100, David Hildenbrand (Red Hat) wrote:
> > 
> >  From 92de7131f74b9300ea711ceae98bbe137cf0058f Mon Sep 17 00:00:00 2001
> > From: Gregory Price <gourry@gourry.net>
> > Date: Wed, 3 Dec 2025 03:12:44 -0500
> > Subject: [PATCH] mm: rename do_swap_page to do_softleaf_page
> > 
> > do_swap_page is a stale function name with introductio of softleaf.
> 
> The "page" in "softleaf_page" is weird.
> 
> In general, the "do_*" is weird as well.
> 
> fault_handle_softleaf? Something like that?
>

Reasonable.  I will probably come back around on this after LPC.

> -- 
> Cheers
> 
> David

