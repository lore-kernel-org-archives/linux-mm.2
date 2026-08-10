Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33E3EC5B569
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 23:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9016B007B; Mon, 10 Aug 2026 19:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6F4B6B008A; Mon, 10 Aug 2026 19:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980906B008C; Mon, 10 Aug 2026 19:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 713766B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:05:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E60C21A02E5
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:05:24 +0000 (UTC)
X-FDA: 85086892968.04.9F61A8C
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3611C2000D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:05:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Uv1VC2HL;
	spf=pass (imf03.hostedemail.com: domain of 3MVl6agYKCCgWIERNGKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--seanjc.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3MVl6agYKCCgWIERNGKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786403123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9OrpqxZWhRM/HFUiR8JGN523y//wB+NGc5onZ0jOJQ=;
	b=Mk8PQw2mRbJWDTJJ7NLiUtwFBvSUO9D8vizTqYQzQzJ6esxPonqcFfTvnQdE1p9GfMoc6y
	lGaHm2MxcbN+9cGXONVr11NG7tu1OCxfbsS8TEpy5584qucdJYzK3603cRXqbilCNl49ZK
	WfBoGAa8iqcc10kgt4ltU6Ee5QYn13Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786403123;
	b=hVGDdcqksFiUh7LFhAaLGrp7QhnAuCn01JkATstiJ4QAlrjXDFPah3qBjd6iTQX8SHS+xk
	MWDJeMBQhpicZGKC183G6ylfLjp7ySpBZPW+u4P4EiyU8WHPTpIfpGBS1DDGckB22nhDXI
	Hr1Jfs0XbAw3Rw85UWYoY7+CXefi+7M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Uv1VC2HL;
	spf=pass (imf03.hostedemail.com: domain of 3MVl6agYKCCgWIERNGKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--seanjc.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3MVl6agYKCCgWIERNGKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84857446424so4157837b3a.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786403122; x=1787007922; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/9OrpqxZWhRM/HFUiR8JGN523y//wB+NGc5onZ0jOJQ=;
        b=Uv1VC2HLVLpU/hX6MUfwFTDjzQVVpI5rjweSKy0I6RKJQEdJG/hK8CCvl984Ndj6rj
         kUbQ7mW0Tr4ZDKO3s9x5l50jaya5BcoJ34MNk/d0Mw95HVK7MQEJCo4tmBJZoHCEJQIN
         FqCnlonCqfgQskHieS6jNIrf0hrf09WAv6vmwtNLV4NkKobjQRL8Gg4pMRSyRFgbGhXU
         3gN5XOKAOP3YVVR3nPlm+qlBPHz/gvg6L2YAtdFoyts37K4a35nh8rPIS0NmFna1pSS1
         E2TvsgVEXOObyp0azZr2tBg3DJOiJQlqWJXuxssEMTZQylpa/bxXqz1s/vzrwSlx7JPt
         ryvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786403122; x=1787007922;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/9OrpqxZWhRM/HFUiR8JGN523y//wB+NGc5onZ0jOJQ=;
        b=rcJv7kn8xO0HpRBd2rZG9BgrScqo40TyAap8EX/CNu8oPBehOEe4q2B/hgfPGMXR7x
         DS811MoJwN1xe4g5UHZlelOPdsw0qBff87GRA3fY34dQbXkyxD2xAphORzqd7etWuReP
         HalB2grDduN2suQBUNwQb532ki6oPscgZT01JaRMY5YFgOpw9XweSD81RNRh0Bb3C75C
         s2PxtRvkGj0r2ejHl3bdf01EnPoVlVowMq4WKku9ALlYr+x3rt/qaLN9yysySN9qIwdW
         n6k+uTdeU/YDxmTxJB0QFvIeQZnW9DUjVISbGAeTLAFexU2ucrcUH5c9XhotPZ9Z2v46
         i+bw==
X-Forwarded-Encrypted: i=1; AHgh+Rrl5OEYCdRmwW4y+9xfe4fLrGyWf6oT6XprbO+JSix1P1DDxCxFmPUmZpXffYT2Erih7uEYlN4QYQ==@kvack.org
X-Gm-Message-State: AOJu0YwmNj5KDVgDjhDuVSv99Z39XTVgsgrkZdHf63pETHmWwwl2Oh1P
	gwm9H4Gm3WulB/BT2Tclo5pNG85MmzG73ooD1opPqMaZisofoEykoFI9kUAlga9aRAL69NdtZ41
	sKFWg/A==
X-Received: from pfnv2.prod.google.com ([2002:aa7:8502:0:b0:847:7765:a4c3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:420c:b0:848:2f2c:b2c8
 with SMTP id d2e1a72fcca58-84f9c95f809mr5850968b3a.24.1786403121703; Mon, 10
 Aug 2026 16:05:21 -0700 (PDT)
Date: Mon, 10 Aug 2026 16:05:21 -0700
In-Reply-To: <20260728121138.1103610-3-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-3-tarunsahu@google.com>
Message-ID: <anpZMemVz5yC_WLo@google.com>
Subject: Re: [PATCH v4 02/11] KVM: Introduce kvm_create_vm_file() helper
From: Sean Christopherson <seanjc@google.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3611C2000D
X-Rspam-User: 
X-Stat-Signature: dk7z1cfjwmy91pwd6ugjyx87u3baiabp
X-HE-Tag: 1786403123-935015
X-HE-Meta: U2FsdGVkX1/TyvmnFMRlZWkuowblfxXI/TRANgnahOpxgborzqv65UG6eKJEVKYuetEV+vHRU4t4q99lCoJfepvdE+8vkXCMg0hZcPVowk+cpohEWyQx2yBIN43qHr7xPlyx+7ZND3OX7Apuohr8ZBQAaN0xi1ZsHJUu1hSp5irfSHhZI7tCTHHnCBc45bclDDVtglF9fYXwGwURhB+5PIIoK1y81IxmKCyZQM8tDEBES0JLobq94NlGDQXBk0MYtUQJ4438EEd9sXb21noDpfPnjsZQfFkuck/mp6cEA+ZeNaIOT0RffwgVAMWmwMmP3nVAiYW213cq0XlDET2OWLK+w7ow5bN+WkLyQTXkGBGR+vOfAROt9X4VWvpD4aXIS4VPwZSjenyFqfrGWzc+kHSzw4cr92ZDaS4er38URKwT1cFMp5TwWz7ZT+vvCtbBKSLiwD3tVwpZpYeMAihxJaqZVERfFdDwviPSqEo02Xs0eIqfNtm35vYvtTMshUQEXKp/S6ZgxEFpOKax4iDWioOMgzcs5szuJ9JfSBTC3Nhnjuozksj+Z6jC1Bva1QHbkteRVMOmR5deicnkxWRNzYX4FgIqUDo6DrjnnfTQNnnA2X+F3iSSIGdejtSmiDkauqzBMd1IZwPFdGnLTldkzywR7WIoKcvlgjzhLQJyeWg8UttxETAaZ8SWK0qCifb7UkZ5PtAOmPPKlHYE6BJ+qXu7v4d4neocQr6GAkkyS1jBTHENvhtCNbnx6CcK2UoZtBqp//QURzfArYjvWcEMSTxrCjXmglzLYYz78rbX3e2Pz7bijDSQl/elm44pSkiNGYP84PNm4PVNnZAMOX2SkzdTzmir0x03T4mU5duP5HUQ0dV5epZQQoawLC/MidZ2ftglYg4+1kEnEBoHqWsuG3a+FfzOt1O+E6KOjCPEDTzEAHgN48OzzP+Is4bqghtR6hnDr5bx5lDPB415YjI
 7dWVEAG4
 eF7uAinbNCespxKelBsHyTBE3CsHtu+k0FoXg03ySzy8ZLyHSKTbhV480YBGmgKzzOJL2TJdibe0cZ6bKMBf3yAdY1GTN2b0o8H7H246iJch4n3Li1DJZpMLGoIV6eTAlcl4ivKWXUm1ppb+GCesZaDzVGIK7By/S1L3arx28S0BqgOoI/uY2baXW2ASQH+QoRKBLNnJgOzk0a50XEOxd+z6EvfjbI8AMaTerb5ixJzmpaSUVyyUlACAq1yP2hekgUzX3+4W89id7CGQ9dHS3/Pdf2GmkPqzqelj/8EVMhanppYPqjjEu+muXDJKIxTPuBXfZTJf6ZrEW1TXauk5mf0M5XGGz+I6lfEFjIVdf5Zs7eKUQVCZD7CFEVpLJC5+JU9ZkgOejXvo6mmJc5sUFOA7+3ZEAgpiUoX3OsxaSWA3z4GTvuFQ4XZIkdO6yLRDG9Kl+0RHkJzE2k+vY8NBmFiHnDlnc5lBAsJJ+dejrQPXhB0bmPnYTXUslKf5ECtuhTEXBDoVxzs9YzBlIvmkOp9t8sNKR7C5uZCtDYXet8Fq7oW3WaqH0fapVMfpvM2j41l9PVGOJLumAa2dkh5N+GmhX9x3nWLG7AozNxm0wsQKi7Fpge1D3d1PS4C+0j+tlP8l4rU2j1VCQbuniz1p4hzMxEHE/bagbumbtM+KSmNts2Qc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026, Tarun Sahu wrote:
> - Move ITOA_MAX_LEN to kvm_mm.h for reuse by upcoming kvm_luo code.
> - Introduce kvm_create_vm_file() to wrap kvm_create_vm() and
>   anon_inode_getfile(), providing a unified VM file creation API.

As Ackerley pointed out, changelogs that are literally a list pretty much always
needs to be split.

These also need to explain *why*.  "providing a unified VM file creation API"
isn't sufficient justification.  In general, all of these changelogs need to
provide more of the "why"; I can figure out what the patches are doing easily
enough, but in my speed read of the series, it's hard to figure out the "why".

