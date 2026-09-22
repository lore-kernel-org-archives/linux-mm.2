Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C523AC98304
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 04:19:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3FFD6B00B2; Tue, 22 Sep 2026 00:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEFAF6B00B3; Tue, 22 Sep 2026 00:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DFF66B00B5; Tue, 22 Sep 2026 00:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70E5A6B00B2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:19:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F128140381
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:19:20 +0000 (UTC)
X-FDA: 85240093680.24.5B407E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5FBEE20002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:19:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A9TK1a5Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790050759;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CFUjfWW/pDRAB45ZPOTLMOkYRqsV9MvW8Ya0iftlsh4=;
	b=ZAkssSb2SukcORAbyoWAnW8hv0IGM3IsLdeAZwXziyRbPjDJXKy1VyT9vdT2JMEOHWmou8
	UyBvPrfuiySyWfAl6c1bgV0d2MfYnSue/U/asHao9cwYTGbJYTsj94lX5iJJXmErwPzzBE
	GISAqVesUMhurjaNsjQYuWejQyromdY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790050759;
	b=jcVcwUFzVrfqkaua6KjFBE9qCtfltVGLvUNjGuQ/xorqnTMpa5Tw8jjGSz58A9fD+AHS0F
	7I+tBkcwQcQNAJ2sS75SOAoCEYlH1WZBLhm9/1TZruEquY9pCs4XWtE3gV0ukBSdm7tI8n
	Xqu5bDm4wp0tNsohBLSVTJTHnpNvBFg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A9TK1a5Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7769742D66;
	Tue, 22 Sep 2026 04:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84161F00893;
	Tue, 22 Sep 2026 04:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790050758;
	bh=CFUjfWW/pDRAB45ZPOTLMOkYRqsV9MvW8Ya0iftlsh4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A9TK1a5YzUWGYSTQvvf9KGUghwtbj8wOjMaM5Bl+fLvfFzQ4EFM6CaBOIX6Rg0RY4
	 66qmp6KLIm5DZQMTJPO21zraA7UaHca1Akg1SaA6LE+1BK44hKzNTHQtZZUghCC9gP
	 FwBsVMznVAAlfYMkK5IFKOa6DqP7/01hmIQGLORaOfrpaL45aKC/cN1IFNnE4uwR+r
	 cuFRlPBNfZzVNCpdrFpLMFOBBkWiLwq67Q3BSP5xnp96qcGbZCAspgdUWFququqvnF
	 uC5Aj8sb5cT1L05VCKITCqYzkx1e3NfbY72JS8j0tNO0GNBeB600clVwoJXtIprtxc
	 a5n4vjOQintkw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/4] memblock: rename KHO_SCRATCH to KHO_NOPRSRV
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jonathan Corbet" <corbet@lwn.net>, "Rob Herring" <robh@kernel.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Ard Biesheuvel" <ardb@kernel.org>, "Borislav
 Petkov" <bp@alien8.de>, "Suren Baghdasaryan" <surenb@google.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Saravana Kannan" <saravanak@kernel.org>, "Alexander
 Graf" <graf@amazon.com>, "David Hildenbrand" <david@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Arnd
 Bergmann" <arnd@arndb.de>, "Andrew Morton" <akpm@linux-foundation.org>, "Baoquan
 He" <baoquan.he@linux.dev>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>
Cc: robh@kernel.org, kexec@lists.infradead.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, x86@kernel.org, conor+dt@kernel.org
In-Reply-To: <20260922041321.233986-3-pratyush@kernel.org>
References: <20260922041321.233986-1-pratyush@kernel.org>
 <20260922041321.233986-3-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 04:19:16 +0000
Message-Id: <20260922041916.A84161F00893@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5FBEE20002
X-Stat-Signature: 86ofzgi1hu6cgpe7ac767tgxxfungmnp
X-HE-Tag: 1790050759-408987
X-HE-Meta: U2FsdGVkX19fBAUsCDmzisy8eBAx85TFk/Fk/X4NVkiVoMWZVtQn586LxjYWYwAjbLKt0IoFeYu7Em6pY4ny3AbW1hfWIk6e8kZyymrP1gkkDo7L8SnKacVExWR6KtyNCAc1sutC2hT+OL5lpj75u/5Upfr/tSuooI5/W+nTfK9/wahyso8zVZNMuOaVhuMUWOmKLkoNYZtXKhILt7wcpxMI2t3tLp0YII/jDPwwlfXVnfFbVtWii0OfMBXXe0PqDmFArOeSeleJmj1XO7zbcMOjo8E2suHrOSRo3rI2K1e/ODhY9DY45q8Qac/MKC7WJwWSUUOn/cuW3mIftj386WnEUtLrX6ZXFTdJdbcmbdc0iVaRHaFVlL2B5ppQBx7iSmgnKbRwXH/5sklHYtKikHY81EHkTu6qbeKpJ/ZKKZECvyTjbpqnEFvupVTztQ1+mrLf4u+Ro01/Yll9169TsbOQNGCrfGDZ7NYXm68P3dFEEAv2efC+AjTCHQZDNfdCss+bJpp+YuqNfcl6yGDGa0q80IAoAnL0RIdLhWMbUJRP/zXq55l2sH+nFhYpkEWzG8M0L8+gGLmAdhURoewVdwyXT6IapGYTe/3i4a32DBgocsja5ahkgNt+vyZ1GpIcqILC98YrlWV+B5wS5uhLlqI6QsYKp1W0NK8NKYnqCO/pI3a42yf+y5ffbBKoOr36MvjK8FAra+V+bvEZ7/DwDSuiHWFVKorNWJ4SCCrDMewTLWnHd9g4Qt6UqOxMCws5GjH7AbQXVBAmk6XypHmMhPWX4wfaVBOyjlKMmGhVcUUC1XlHvwcAAzp23jKQUtWar81mv4cyFB2agdmiv2PGy4ataMUn3f4E4Al7oQpkOpdeS1J12iNJ/CGHZuetSCJGTaRlZ0UcqGbWLjanStUpJfBstTr756dZkaw9gvmZ7NWK7FtbaqLsfzr1LERB2+hfUb5rp/G7Fw5YGpetNQD
 UryjpFeg
 8pzqMSi5ZLK79Im9vH4V5bUtIUKvDvYrrUJLKz0hP8mkY7cJGDmDVlqwr+F0MU8DuwuaWbgiEuZB2JSTjj93tFVXIRoQlnBjW/PKSHp4oVOIe7T3uRfkri7IlpIpSIg1e2NMmZf9ZbPefwr/GVglzbCfU37ZIWt6JrkDj0BIIvnkjhs0Wf7WnqTsVqxhNq2tARtmhxiopgW6sJL+Wd/xQGP6PuEQye41uq4GEINa64Z9EsDzmF6Yws1PKUPs1rVcj94xFb8J/sx2TNOiUbSmh0Ja0msDy3EnmPkeaJUNhrgm+/DjwcDOYyzzDLZuttxl6oZGVDQRECaD0y9yEdQcDzi6WW1hJlIBwC3QDYpvxgz0xIW3WcdK5aJTm/FKd1Nr/SAzRCd/bEQI2HC0QtOL/X9CklC+BBDvsDvMCc62wCSnnPNwFH6yCYFlIpz2ysjD1WjWxIcMh0guH4l2+KMhrPbNVts8g4PoJ/Nh4b05Y5jBmrEkvxhJHl+qskN/xVx/EQ4Vv4zY3rsGygR8M1sOqjORd6GHPbxLIQplcooYDTmRO3/1ELdt2Vq8v+b7flTI7rb0xI7fmxGRJxdujMSmHAN1wNZ7HNPGeVNrGoHxnQq6OrmTOoCbYMCCbo27qtMs31U3h7BeoOd7djYkY8A9wosIZRVUPVirciLMkTzqzlDFl0TWTRBhPxkIcvCdWM+6RjvWHeo35Awj/1QpCPaSnECOY6S1KyVV5+jSbtFAXSUKbmtW7oX1TrGRDGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>=20
> The term "KHO scratch" is vague. It does not accurately describe what
> the memory is for. Generally, scratch is for things that don't contain
> anything useful. This is not true.
>=20
> For memblock, KHO_SCRATCH is the _only_ useful memory during a KHO boot.
> It is memory passed by the previous kernel that is guaranteed to have no
> preserved pages, and so is the only thing safe to allocate from early in
> boot.
>=20
> In addition, KHO now has the ability to discover other "scratch" areas.
> These aren't directly passed by the previous kernel. Instead, they are
> found by searching the KHO preserved memory map.
>=20
> Memblock does not care about the difference between the two. From
> memblock's perspective, both are memory areas with no preservations and
> so they are safe to allocate from before KHO fully initializes.
>=20
> Rename MEMBLOCK_KHO_SCRATCH to MEMBLOCK_KHO_NOPRSRV. This name clearly
> shows what the memory is for from memblock's perspective. Update
> memblock functions and comments that refer to scratch to use noprsrv.
>=20
> There are no functional changes apart from the flag name change in
> debugfs.
>=20
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922041321.2339=
86-1-pratyush@kernel.org?part=3D2


