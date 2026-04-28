Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD3C8FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 10:32:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F7366B008A; Tue, 28 Apr 2026 06:32:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CEE36B008C; Tue, 28 Apr 2026 06:32:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40C376B0092; Tue, 28 Apr 2026 06:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EB526B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:32:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E34861A05A5
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:32:55 +0000 (UTC)
X-FDA: 84707601510.27.C8C3792
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1311C40008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:32:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oBBmWcVC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777372374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9CQxtBSs3Cczt2GVApBi4vYYXNbkMfBw+Ph1x+xFWOQ=;
	b=RG7M/tYqqGGlgEDW/cGG2zzLW0yGQrT7ie5BvyNjiaHHqwTWCXU8ahJDAYTmOMMFrPA220
	A8zavo1CA/7H7cmrHl8YSUR+ZaVmSXA1gTBGofHZXphquA9O+i1BFtCIjFCeRytDZbfIAQ
	SUNYvt0MN7dw1HYDTuk8zAISsJQHRdo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777372374; a=rsa-sha256;
	cv=none;
	b=FSrhgb2cczOd+a9TbR3MO/wKZohXJhNpaWKVWbiBAthuKAWyG90m/7wSHGdmsI4F0fmGje
	pSOKUysQeEGF/Cqa2wVD74bO6hIoJTl5MyRzHmSuuinAJbOEyTNuKvNoRlDWSHOv0nuQpt
	FtUAd5PpD1EmBKymwVRbU5pV467zfGk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oBBmWcVC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6DC2660142
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25920C2BCB7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372373;
	bh=9CQxtBSs3Cczt2GVApBi4vYYXNbkMfBw+Ph1x+xFWOQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oBBmWcVC6KzKC4xRiIVG2oJYjMQSgQsyCNmdUNzhE7qXtNAu+cQLHX08rN37MC97t
	 8Tjh7gop+mloG6QnMhjAT3qlLu17BCmNV28Mp/5Dxq6GU6UW3awAG00ajiUicIUwU6
	 rwXq7h70t/nex1ewUf0fCQOeQ2fSFbpoNwXqByex4+IB3ReZid9izkVXRPra8opbaq
	 aNZQZ8XAY10DSZBRdW95lbZfkklUVZGh2H/AVsx0UrNNr3E3Ni6frWkTkCMik1j0M5
	 tn8SHBTYsDULM1WPYc4i9ASHhvRdo7lRPaSoqzLULx9Zgrg79GnmrMtp4IJ4hA87kt
	 bM/PtFbBzrPtA==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8a068db9989so112571396d6.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:32:53 -0700 (PDT)
X-Gm-Message-State: AOJu0YwnfEo7CpVHiBWfjTif4Q/xUJupafOBa8uWf8YqsO4ewaqfQtYa
	oY/jMRHJspa3szB61X7Ao0TD8mf0k/r2Soi+16QEXtiSPvbrFxLfdKUbNvmb3gzEz+3a1JSbABL
	N4FkL2nffwd01TqZ+eqgQA4M7lTIY0wU=
X-Received: by 2002:a05:6214:29e1:b0:89c:ceaa:872c with SMTP id
 6a1803df08f44-8b3e32d3832mr30001106d6.13.1777372372433; Tue, 28 Apr 2026
 03:32:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260423034917.8234-1-baohua@kernel.org> <ec08f25f-1049-4fbd-8a87-0df135a867be@kernel.org>
 <CAGsJ_4wn=o5ZCNPGguCCk=19iYZr1V9Jup0NdRUKXySsKfD_4g@mail.gmail.com>
 <17a3bc38-0d97-4316-b2fb-02a91202c504@kernel.org> <CAGsJ_4y6_G5BPZKs3Mg3s2ygxGh1o22GX_3wEsM5hs7WX_cOhQ@mail.gmail.com>
 <efcdb62c-54e9-4806-87a2-5729e3c1506d@kernel.org>
In-Reply-To: <efcdb62c-54e9-4806-87a2-5729e3c1506d@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 28 Apr 2026 18:32:40 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xvXZVRO0-mXAWM7mH9pVH+DAYggDBG1+2x5iQ9mfDDDA@mail.gmail.com>
X-Gm-Features: AVHnY4KbOrnYIKBewsa-Btt8RDB_21xarBFqTw0olz6fx5r1g_RM2NylEZzpZRQ
Message-ID: <CAGsJ_4xvXZVRO0-mXAWM7mH9pVH+DAYggDBG1+2x5iQ9mfDDDA@mail.gmail.com>
Subject: Re: [PATCH] mm/huge_memory: Fix outdated comment about freeing
 subpages in __folio_split
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 1311C40008
X-Rspamd-Server: rspam04
X-Stat-Signature: eucdi96iyg4d8hu8yenqq4e1z6wpxeas
X-HE-Tag: 1777372373-251079
X-HE-Meta: U2FsdGVkX1+bELKccvrcRNKQcI+oXTRtEnueKhI6zkmDWEgBFg59Bw9oLqrMgcIGxe96zpMP7P+6E83mLOUpCaH4lKwv2lvMi2QiXZhYlTQXFka3/QhXKXmifdAPrcbFuBfaOkGt3GVnpU0KIY7WNaGEzhS5ZJoLqv4VA8KEuW/de0taDq6yTLrVXrlFeepgb7z8h74Vm1pG9X+6h8FSe4SPZgVK1dxB3Q4/amzsHCzHKwjjOiRObpygABGMdq6/6BqFJVt9FVzKJomvvIo9ICIfYS2yuGXxW7yEC/NzWuW6ZZZMHuu2mo4m6lyU4wTNjIX5VwQyF+LHHHMqS5VjrShBBdNi04Ahrqe1TmcNC8QjbuGuvSHrZpx0uVJW7nmUJVhq0aSwu8xrX2VeAVNUg3mC/BdCJdYWgJeN8r08STY5+DkQw2IwnWUMyY/7QPSIzCTMbggDlVDynwr6OZnb3SG1nwIp4Vu6TNtr/VsN2HNVlyExE0j0dRZwFjwqNskxqDN/5tKYg3dkhIKM0rGNFcTk0LNEoxhwEpwda6r6CrCuVPHVS67Vy6IkLdBt0t5Y0Uh6SeQNI4ps9c84Zgt/q5B8xGpTV6+ipRe/0I/JXVxo4fZUGVv2fyyKuAHq6vo5H18ulp0MMRbwbnWAaC8dDN9SufmlFFz/Z1pnOwadXB/zntJW97OUdVhZUswAhqdnj7q/cxjdbnZvU+vjxUpR2OJPgt3wV2f9yrSKUihJ11pG7/p7WGMDATAO7MKW5ZHjfPOk3ZfqCvW2vw/FhzKoc8bvvztLgCrgDiadRoejcbHUW0qMAG94jaSY7n0AIB3UrlWAj8A9H60MaSPDA9H0EGyNoB6lvstzNWoRiH2Iu+ptfuHesWz09FFkRHPTKqxTca0cOtloEJoVOQQoI06X+laZ0FJfV/ijkph+N7prYXAnOYyeX8x9WVhj1NmH3FlasDsdcBnNzaZ8UdYalf+
 aCsnIK6y
 6R6W2L6e2ZSnSxwcqcsRSshZfHW4oFa55dKIJ/+U+iYAnNvXxaAtuPA4C5FrFe5fEBTdZBnTZn9PAgbQWcio0KyLRfbsmnJ9zfhNDKUOh/sf7hzP8slr7yJdXknUlKvWKc0hTqWE+6j/Oyva9yD+w1zAhsWnTZXwREaH84FL3rM1E8G2dUX79/6AdaqYx0zUroZ1I5sJcIIW9MB7ad+AklmMdnn/7fw8KP7RRVxjGWZBNNU0jZ8y5Ue1tewLeXAFThqE2J7Dk+EJviovP9wT2K5/Wl1/uRJ/lyZUo2zRhpGkYy3S+P7Vxvh9uJzRuXDiHCaCN/9dhJn8QpP6qjjVKrZZS4ET9bgCQJ85r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 6:08=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 4/28/26 12:05, Barry Song wrote:
> > On Mon, Apr 27, 2026 at 3:42=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 4/26/26 22:42, Barry Song wrote:
> >>> On Thu, Apr 23, 2026 at 8:36=E2=80=AFPM David Hildenbrand (Arm)
> >>> <david@kernel.org> wrote:
> >>>
> >>> Thanks, david! would it make more sense to add =E2=80=9Cwhen
> >>> CONFIG_PAGE_MAPCOUNT is enabled=E2=80=9D at the end of the
> >>> sentence?
> >>
> >> Better to phrase it in a way that doesn't even require these details :=
)
> >>
> >> Do we even need this detail in the patch description?
> >
> > What about:
> >
> > The comment appears to be outdated. add_to_swap() no longer exists,
> > and the explanation of why we need to call put_page() after
> > splitting could be made more general.
>
> Jup :)

Thanks!
Hi Andrew, would you like to make the change in the
changelog, or would you prefer that I send a new version?

Thanks
Barry

