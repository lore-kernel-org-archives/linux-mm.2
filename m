Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC707C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 15:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADD9E6B008C; Wed,  8 Jul 2026 11:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8E726B0092; Wed,  8 Jul 2026 11:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A5236B0093; Wed,  8 Jul 2026 11:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 728F76B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:39:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2E41A01DB
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:39:23 +0000 (UTC)
X-FDA: 84966018606.01.B64C218
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8A4E01C0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:39:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XjjwPWtF;
	spf=pass (imf20.hostedemail.com: domain of chaithco@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783525161;
	b=TnCIRKmiMFiKtl9jtSVgWUHbWKAmdlxD5Em2Wt9zCYBDD28jIK5z5/VCAZHE4sWi3V8xBK
	uIoUjbrwCVYnq36ZXv6RzTHbynmZLMuiidYxT8Vte+yQZBqaX+GQ5Qn8cgihDhTacI90i1
	8MFBAeagqR48d23K+tp/fybksc1hwyk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XjjwPWtF;
	spf=pass (imf20.hostedemail.com: domain of chaithco@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783525161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zBiHyNBlQUysgWQZDi0Q5QxcKieaA1+OV3DOTBzoFAY=;
	b=gxUDrr+jfSZFYLyG206plNBTPSGru/mtaUYUnVCbJEvweswpjJH74TOVmwFB5riX8H+Y2P
	LZ0X0szGYNi0uYz/SrE0xV4Qy9QWZA7c56J/512cW0XjZaPm0fvSzLEAJsIuEeFjLGxfq+
	GhvtSHYzPJNNK0GiBCLqILQCaP3Ybbw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783525161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zBiHyNBlQUysgWQZDi0Q5QxcKieaA1+OV3DOTBzoFAY=;
	b=XjjwPWtFHZ8epWiK8c4f79R0BBZdYSaD5Y93kUw+EQDeDKJqej5GdvlfmW5XRrey5/5RPk
	hw+CPE7oOZN3VUZAcAEyaDuCZvPgk5Ubt86FW6dTWGhOWgoCbIwwbIkOACAybqvAYZZy0j
	f2SGP93oXfTIdtncLrX3E4c6lFRyeNI=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-383-vEb4QUcoOGGSe9GJkPX1dg-1; Wed, 08 Jul 2026 11:39:19 -0400
X-MC-Unique: vEb4QUcoOGGSe9GJkPX1dg-1
X-Mimecast-MFC-AGG-ID: vEb4QUcoOGGSe9GJkPX1dg_1783525159
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4893fc86bebso1176035b6e.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 08:39:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783525159; x=1784129959;
        h=content-type:mime-version:references:in-reply-to:message-id:cc:to
         :subject:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zBiHyNBlQUysgWQZDi0Q5QxcKieaA1+OV3DOTBzoFAY=;
        b=JyfpgqA/n0foepjpnPwRUHf+W/7IF8Flw2LYzqyYpY3KGE35qkARzE+CBVvGuzbmot
         9dqc4JZ8mCvi+iks4cWjYxHIuGqnCQVyn1CcpYBYr/qoycYHgzXwzLfNQRL8TpjCeFji
         EubLQ5SucmyCjmAoLqzzw6yFdtA1Hg6m2Xte4fbRiV7G9Fas/7kl+yX9npJFJIldlsGO
         goyLJvEVwhobfp4Sw9iXUz1desN4yj4qN7P+SoHzJ32lPgM7h2VQuSCNR516QnZvA5IK
         8rfFXtXyGT6BbwdN3WYa1MUI56e9GUxOlhh5QD79T9yD6BzCQasEx+qPBFzJmSDRsoEw
         aePg==
X-Forwarded-Encrypted: i=1; AFNElJ8UA2yq0OPK5UFXZrAq0H1JGX2Sf8bIsLoNNtUhVm9/rWV8TtsjtniOKaFYvWgRxYDZDaKvm9XUUQ==@kvack.org
X-Gm-Message-State: AOJu0YzbxkaPh5dxiSsHk/FRaAEiwJ1ZQXjnLcp4F1gX9t7Ppzq7gpRl
	GSaib2q+W75ejewJ+MSj9x6VUzTrfY7QDN1rji/IqJ1fBhH3B4lktqhuVjSLx3W5Q17xnYxfVgh
	Ge+qg/kY/Yn3JywFCI08Ein6OWu3hL5O5QnAbXCVveKX0wi0Tm6OV
X-Gm-Gg: AfdE7cl8u2U14BC57HcSTCn4/dBP79bNVZNUfVgs2tJYGRXxb/scgXd5PCZ/7wTHbwn
	i0hISZjde4JtT2DfdciLZx2fB/tVUokkWFm2VFlYC9sFm9/oegdfA9olI1zwROcWDi+iaCKSeEZ
	B7kJhzmr7Jx6ZfVejBJ1KETVNEt3ImYscEFlybJUvoJEfrYeg/Icj+ZuTQaPIXy33xxOZVhe/3n
	CIeFUcLYeTHXV3jvTY9oVmspCrHZ4W1wRzOLp1tdGFJ2e9rEB8MUqfkqZvbfn/vJwpNdz3Km3uL
	VGnfDs6GPHl+YSmPNb8rEba0K77WAcl+XWJcNJOUBE7H+I3u0M7jamESJEbaQ0y1O94Go9W0JwY
	0KEYeluDcD+23Vkp+V6/DivvvforHz7wSqfXSiNXJlmc=
X-Received: by 2002:a05:6808:17a8:b0:485:a99c:cfe3 with SMTP id 5614622812f47-4a2062141a2mr2582661b6e.42.1783525159063;
        Wed, 08 Jul 2026 08:39:19 -0700 (PDT)
X-Received: by 2002:a05:6808:17a8:b0:485:a99c:cfe3 with SMTP id 5614622812f47-4a2062141a2mr2582624b6e.42.1783525158649;
        Wed, 08 Jul 2026 08:39:18 -0700 (PDT)
Received: from [192.168.1.59] (184-96-191-56.hlrn.qwest.net. [184.96.191.56])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4a1b02e5abbsm1924246b6e.15.2026.07.08.08.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 08:39:17 -0700 (PDT)
Date: Wed, 08 Jul 2026 09:39:11 -0600
From: chaithco@redhat.com
Subject: Re: [PATCH 1/2] mm/hugetlb: Prefer mempolicy nodes for calcuating
 surplus hugepage reservation
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
	david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	arozansk@redhat.com
Message-Id: <BT4VHT.DYI921C1JF9G@redhat.com>
In-Reply-To: <20260707193358.3434034-1-joshua.hahnjy@gmail.com>
References: <20260707182900.483757-2-chaithco@redhat.com>
	<20260707193358.3434034-1-joshua.hahnjy@gmail.com>
X-Mailer: geary/46.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: H5SDGpg6PfDgQmJdP8Voio2vGdKvmePSQW3jgg6_Eeg_1783525159
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii; format=flowed
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8A4E01C0005
X-Stat-Signature: 949fi6qbfsyf66tmo98979sk6u5s9oww
X-HE-Tag: 1783525161-535609
X-HE-Meta: U2FsdGVkX19vMRrx3wu7pmgVlCbPo05PfyEv6MkSdoJBKXbDf+1uLd4TZQvAWPqtkbNMHrujG1qen1vOHwMP/I5p4zbMyMii3kBA/qX9DHODdBUzHaeyy5NpaY0Hq9ZDXwOE+D7dUolnirWJZaUuJtiellP8Y9ClSm1fBvN3R3FeLZFUBzdchBV9eDiq44Qz26PtL76sjGDk37/V7rrM900wHjeTmGpy8QTcHRISVtzrXMV4kAa3q6wPGa+GfJ8mRc0wsvi3tPADw52Xpw4K0ipoTFcvitDv4UGH0NWs3HiznxPCvYpJcy2opSplqv2fSBAceHx3EDEgA/VzdZIPI5H6LeQodgOQVdwoRkP4nmAJN8xWQy9ecRqNUMnoy1L46wtGTssUEV2Wi5DsQc8sNxxncwUzeeBTRpsU5IHiAgrJj/rNCQfgveR6pS+dLoww/vHyq8KPm9ZAMKHtxSgMFF1dvJWTx0HvhZmsWqA4ouySrUYWNIMrLzHJHjawK8mf8uF1zSsL/XT2vfe7tRd72xHwzlgQKZNFtbrElRWpYDvN/vUbR4P0QCuaclFJFbHcyqkFWV5Ckx7lklbuTdufcznkz3HscIa9Uf53RZO8vDCMyeVomlO9odBRDhBJD2lAyDXczcsowPItx1o5zvZtJVsZMTsDynkISmmYTNS2LmB6/C+ev10DFtk6TI+WKpe7QfRainH943dCDLg2f6MenoHAxp1Lbb09d9U/4C/bW9WPYACNjSskn9dNKQcL0WyHbRiJyNX4x8PrmxSYxe8kqLr2+1jqS1/nHiW7G9e0T9W6mYOgpTBWoiDVLs3mGgs6tu3dXv3bTGoE8k3usaDdsUO8M8fdZg2cVo37Lhc9tg07ZfjzDAQ7ryAAOD4xCQI+Wgt1YkdX2Ni7rnO6B48lbNYe2okmo+bNMNT+jtmL4Hg8ttkqGWqGW37crkV5aG2F2+Kz+2yqib1P5nbQBLu
 qtJBIBza
 eP0lSifnjoebM8mx3FPB9rIgW8pE6NMfOr1B7fEJ71JZD07TktLstYwwdqDUUQ334/GpalUBxFCDeCZXtTRDXQFo7W5LSdo5723Ulcq9Z2JImGXbrbyMITOE1ocGWKpQUN5XysTsXEMZ6o+M/lLc3Mqbd5P22nE35M3KTuNAULcaLeAmdeA32fqeWEu0SORw7dOZZBCQeYh2tTyVF4surLv8xdy/oPxHGvtE71MOsYz0NYAIsXFPy50ovado67HTymSk1Xi9eHZw438CKQ4FP46pv0Xk3Jr66/E03lQpvGyZM1qC3OT9Wz0V//qeRcxKDcV47g0Nf2psshJsnHJtBVzmlyRjrlY9qNs1kzTsmmqmDxIcYHNa3nnb/84CpEDDJnqghWtvdzss1WkWjYYqINTwpzFnsB5rpTjB1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Tue, Jul 7 2026 at 12:33:57 PM -07:00:00, Joshua Hahn 
<joshua.hahnjy@gmail.com> wrote:
 > On Tue,  7 Jul 2026 12:28:55 -0600 Charles Haithcock 
<chaithco@redhat.com> wrote:
 >
 > Hi Charles, thank you for the patch, this looks good to me!
 >
 > Personally I like the description of the commit in the cover letter
 > because it provides a bit more context. Do other reviewers have
 > thoughts on this? In any case, the code LGTM : -)

Thank you! If people prefer, I can copy the cover letter contents to 
the main
patch notes. Just let me know!

 > BTW this is a little strange but Sashiko seems to have failed to 
apply
 > this patch [1] which is strange because when applying on the exact
 > same commit db6ed2a3d3106 "mm/swap, PM: hibernate: atomically 
replace hibernation pin"
 > as Sashiko tried, it worked & compiled for me with no errors at 
all...

Interesting; is this something I need to act on in any way?
> 



