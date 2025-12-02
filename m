Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5677D12673
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 21:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18B726B0032; Tue,  2 Dec 2025 16:07:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13C976B007B; Tue,  2 Dec 2025 16:07:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B546B0088; Tue,  2 Dec 2025 16:07:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E1C8A6B0032
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 16:07:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 961721328CE
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 21:07:49 +0000 (UTC)
X-FDA: 84175767858.20.6E5F39A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id B529710000D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 21:07:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GaEd9RLi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764709667; a=rsa-sha256;
	cv=none;
	b=b/L1vM8o/Tnl2SeJNsSY7Iu6d9kn/i4y5twvFwLnyU2A4WxnlkebfMdkClvU/4PBYk1ePM
	fvxYSWfvieL+DmlrZa2tAWTCQkSS+DdGhcsZd6ImSJA4ng8EqEEzQpnwT2XeVsB0ElDaBS
	Fx1+niKHBNnqCBMicH085L/Djd2fwEs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GaEd9RLi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764709667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R7wirYtaBEcs1xFV1lZaS34XeFV0tOTVeKSuu6PoBGo=;
	b=Fk/Stou7KVCqm5Hjr93OJ6/GxKpJgZiwIk/bBcg4ORuTTMmaNeqpM2fhbNh5PUh76s87ty
	OvIqkxjzsprSmgWbUH1asKK/m3pPEsQg3MN/B6uZFtnc8r5J3mW6J6QqzXJndc7Udv1HTL
	09kFaSdQ+AKYhP87Qej6NcVvPBywh2Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D17A16019F
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 21:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E6CC19423
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 21:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764709666;
	bh=R7wirYtaBEcs1xFV1lZaS34XeFV0tOTVeKSuu6PoBGo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GaEd9RLiH7ri28LVoXr7lFwfUy5aX5mO7Dr3p0XEKDZZZmycMLSXZ+I4QMpxHzVNc
	 1wKo4PozE1iORedZ7KxZQ7JfHKx9LVOxnxBbTPGflRLyQw5FML4Z+eTxb1LTdAcgOZ
	 r5D1AFCJpe56Tx2WJPNyxi+hWHlPTZ6c6ScvDpykO+BYcAoqu6gQ7WgQBe1lzcuDyv
	 4YWKpIU2rlYpqJCgQRdMdwNhl/GgXl8vQtSiVaF/56XTxNhKCoT/DUX8TY0nDljpj4
	 FboOH40BMjfF31dNFKRJnIljlS4LbkKn6Tqq2AjEYxUtw1W1uewz6TV1jhulUnihcy
	 mv+D8BULY7bNQ==
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-787ff3f462bso3491817b3.0
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 13:07:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW2KOWzl+zW3ylver1S2qq1Qw9GON5iqwbySCQOVMXbFtxaYy7bVceoYDtSGT1T9amktEolXoa01w==@kvack.org
X-Gm-Message-State: AOJu0Yy4gy+/ufAF5mkMN8HdgfG5w3xXj1plmPo7Ss2J0JzBJ9axXnqR
	6utPdl+Co3k41lfFpNcX+IbXX2DsKUnB1JKd2V0HyUo1thFSBsx8DAdVyUIHQfyiq9ubFLKK9Hk
	0qPZVnVFBm88wJE8LZ2/vlCtlbPtn+j5cD1EEARd4EQ==
X-Google-Smtp-Source: AGHT+IHT8JKJd5Gonrvn4OPp//KBo77YDHUmEjWN3NXefgnOgG1SL2jlkHMPwyPwDpPFaiBmno6rFcNYsn+2Qou65b8=
X-Received: by 2002:a05:690c:6985:b0:788:fb3:765d with SMTP id
 00721157ae682-78bff4e7b1cmr33144547b3.7.1764709665859; Tue, 02 Dec 2025
 13:07:45 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
 <20251124172717.GA476776@cmpxchg.org> <CACePvbXLdf9bC3Juj=wA4_TKeH6XUgHbbvwV5HhNQtgoT3CiBg@mail.gmail.com>
 <20251124193258.GB476776@cmpxchg.org> <CACePvbVJEWd64r-o8ezh+0QByYbWjYVKiLgxNiBJOjfRWP__sw@mail.gmail.com>
 <20251125213126.GB135004@cmpxchg.org> <CAKEwX=MgJPFJNFuj7vQ+RjuJQiC+dOeTTEBLv6=Dna=MNFubJw@mail.gmail.com>
In-Reply-To: <CAKEwX=MgJPFJNFuj7vQ+RjuJQiC+dOeTTEBLv6=Dna=MNFubJw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 3 Dec 2025 01:07:34 +0400
X-Gmail-Original-Message-ID: <CACePvbVmf2Yyfe9+uEXZUB2yoBQFNc_s1HwkJ-RPLoTDqGgj3g@mail.gmail.com>
X-Gm-Features: AWmQ_bm_Mv5p88JXKLVIUwCIjbiOtpmMhLDdg10n3nA-NT2bQbO4J85vg6YzE5Q
Message-ID: <CACePvbVmf2Yyfe9+uEXZUB2yoBQFNc_s1HwkJ-RPLoTDqGgj3g@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B529710000D
X-Stat-Signature: bi85wsigawx9y1qkgkmm4z6buca137jk
X-Rspam-User: 
X-HE-Tag: 1764709667-430177
X-HE-Meta: U2FsdGVkX18lieWFUbxw4hwnIi3/zQcVe+Dz1z+uNlBcRlbG9WThGiTxwptfjUn7pRVOeOIO+5sFDDQtmXWCXjyjZIAYOuLTxfPry3jTBSsUeteQQ+00+ETUxfFR4X5vLonX7n8fYOx+1z1aytEOGvDtJNzZ3YgxxExFQTd579yOomZFEIjBn4fuoBAVBqUPiSIXJFYcxvSzYylZFmqiZTNqNfhbfjrSHBbpS8xv2PlNm1JN5Lfc4Pa/0JhfFp3I56XdHxsxa50SEwgcXOXEcW7SlhiAQxuC0W/ylCpNOMQNfWd0GXGn93EYmgdrJ7dTJfG4JbGTKYzq9HkRw4Szq+KNwEk4h9qjOVPQNszhmQlWTYD76jAE5RIOnr8s4YSvHd8IkstUWYhgwHTuCxaN33PwjKJkjAg8TmkSCYQHPeyXDHRxX4uZm8dpg8bucnzWXYRAwuBna46w/8L2SxCPQLD6ka6fjmFjIlUfVsYmr9NWFFRM4KdAUppEGIR43E+nVDBirPo91Fk+br/8CZlqHFn9xejw2axqJAHpMO62fFFwT3GxZrr698W1jBn0q+DWRINvkK6/DGHY+PAEpNaaxKIZg145giPRRSWsqscVC5njyfTH6oabO88oKFRMueAOL8RS806kVFLv0nrJ79LXd67bMJq8gS+k1mF5E2DQ2hU579GC3MTJjStJNXHfhccfWA6DADRHz100Bzl4ubYHadnFMqJWjObyz8UgZlGjsF4IezifzMfHrCuYdYwEoxLVRZNAAnxV5g9D3C8+5jGR2wW3UBC1mDtSIeh9URT3ubfWZsGDQc/Hp0Vm8bdB+bD2DR0HwgVNA18Lh4a11OQutOjRmW9FA6c/uRsMkYIKIxZelFbeOfzDshDBlR0ej4Unl1HNwaXnUMaUjHVrfKRbUqVHGFN/0E+yd40UowG51rq52h+u53ooMDfSkzNILUdhVV2QaNfh7BLzUz1kP1E
 nMaKJOr0
 bMkbyn3dM701j+wwCiuSAifRLv2lDOy7xlupiRG5UWqJDQShG1jJvYPxZ97APjGKa4byBMrxrWP3gSujSAW4DyqjgvoPWPOwZ9Oi8ndXQ1KazG+tiR8/qT3PAkAONI1VGAcfuekG7kpg08iWovx+u0rODlLMIK8f4YOIGwOVQ3ZmyvW4AK9+RAAsKsw0DX8xGI8vQK4xRr6UPxoIfS+3h8TJa7VOQDTb+8FtzQJTa74UAG6LVxQcQhKFhdsN+dSgU7t7tg0CH+i1OVQtUpuR/GuOoDDwSnZQgBsKCCqoGctizjvt0/Mu3ymdXvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 2, 2025 at 10:19=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> > That indirection is the tradeoff for swapped pages. In turn you're
> > getting back all that other stuff for swap slots that *aren't*
> > currently used. This is a win for the vast majority of users.
>
> I will also note though, that we will merge the zswap tree with the
> virtual swap descriptors as well.

What is the merged per swap slot entry size? If your descritor is over
48 bytes plus some zswap pool handles and compressed buffer size etc I
am not sure that is an overall win. Provide actual number helps.

> So for zswap entries there are actually no extra overhead induced by
> the backend indirection pointer :)
>
> IOW, overhead for zswap-only users (such as Google) will be much
> smaller than what Johannes is describing here - pretty much
> non-existent :) While you will still gain all the other benefits (swap

The per swap slot memory usage size, zswap+ swap core, is it smaller
than the ghost swap file patch I posted here?
Do you have a number in bytes?

Chris

