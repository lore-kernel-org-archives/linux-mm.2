Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D55E2CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 16:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D3CC8E0007; Thu,  2 Oct 2025 12:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 084C38E0002; Thu,  2 Oct 2025 12:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03348E0007; Thu,  2 Oct 2025 12:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC1468E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 12:23:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C39F1DFF40
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:23:40 +0000 (UTC)
X-FDA: 83953695000.10.58B0694
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A296CC0006
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:23:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Aig2rI5L;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759422218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MjSORpl5GIqD7LbIZ/kS7VMDvnUTbJ1fMspLEj7AoxU=;
	b=0nQ/fzIX+JOXxQ/Hve/vYnYGSZL0MjCB7ZtcvCOq+K/ZBCTg67EgaQAa3C0DcJToHKPATI
	0PoRsC8avAtjVjYKbSF1FnGxl5cwtGTv9hrPaP8oS0KmRG5KL82hFhyCr2kuoOw+x6VdC7
	POfjsofw33rtXuyxP5txM4eYhaCRWpY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Aig2rI5L;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759422218; a=rsa-sha256;
	cv=none;
	b=joE/+5LkGWIYjfPyQGlCHxpvE9TFx9whGFpbcTtuw3ECFKZQqxP657ItJagOp36+c1Ca17
	mhrHiPwrL7AuGLeWBjJK1kLL1YLRcYb0/XniLx+LziKynLMuv7NFJINjTTmopDklaBi6la
	PUWl8LieZpIr9wqSt1wpVmGD0QFbo/g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D88863E9D
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43A4C4CEF4
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759422217;
	bh=MjSORpl5GIqD7LbIZ/kS7VMDvnUTbJ1fMspLEj7AoxU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Aig2rI5LZnBparXKJayH9DfQTyZ7OtOChijgzHA63Cxq3ciD+RFXeJABxz5HkWsv/
	 Wf1z+yJMHUNVHvbaFPs302gwiDJxJ5yIvtDagpfKEKvv88czg2PsTxs3zV+Y7C7VKg
	 tnHYTXefARKeZ+kLqijMalnofUTETdpDj67H5R8qUb3lmu7IGCZ9qUZwhNs7c3FeUt
	 eZV7D5bNkacFgA024oJx46LUlT7HXEzgaBPxynRp2IslCrPbKL6ct2PFQFNMczpp/G
	 K6K4S5jFSCTir1genN2xE5m1bHPF0TNAu5M+cJcTr7/TqlOgG/J9e0BF56u+tlB2Qw
	 aQY9nenTQvChg==
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-743ba48eb71so36230607b3.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 09:23:37 -0700 (PDT)
X-Gm-Message-State: AOJu0YzuaPyjXAaXO1BIGgGwdRZICXNTr1oIL3jGuTL144HMsG+WUoYv
	DwlVad4bfo4QYUeqgatozJYXYAsSKjEIBCZY7aj4A/dSI7j5+B+UuW8Y0Qe8ltbtGyG5sFXx8OJ
	xQw/yQ7qcyHxQq7Lj93FeOSpTlaY+gU5ooM8CuBpH0g==
X-Google-Smtp-Source: AGHT+IFwNzNeZPmnt5fisak0YY646ClFvwNjheR8H4n6z8Xfh/QhH4uxskxcnFbz9HUNSg2BMUhuxljtM90hW97Ezy4=
X-Received: by 2002:a53:cd8a:0:b0:636:fd5:ed0a with SMTP id
 956f58d0204a3-63b83b1954dmr3444426d50.16.1759422217090; Thu, 02 Oct 2025
 09:23:37 -0700 (PDT)
MIME-Version: 1.0
References: <20251001043436.41338-1-bhe@redhat.com> <CACePvbXjLqcz+Smz+woQEKbGdCP3DwgPYvJfLRLPiuHsv7-q_A@mail.gmail.com>
 <aN55dzagMDhZEAQV@localhost>
In-Reply-To: <aN55dzagMDhZEAQV@localhost>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 2 Oct 2025 09:23:25 -0700
X-Gmail-Original-Message-ID: <CACePvbXiReyjsxc9tb-Pcq9G+kXrR_k0-1xguL0_bgKZFe2UPA@mail.gmail.com>
X-Gm-Features: AS18NWDdSj_DMe1vVCdCPan4hbahezuJV_9PQTJ7X8IR5IPN8dxaZzBkvG3g-Lo
Message-ID: <CACePvbXiReyjsxc9tb-Pcq9G+kXrR_k0-1xguL0_bgKZFe2UPA@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm/swap: remove plist swap_active_head
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	baohua@kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ndb6i5p8fawxgra7kzk8hgmmm5gj8yx9
X-Rspam-User: 
X-Rspamd-Queue-Id: A296CC0006
X-Rspamd-Server: rspam04
X-HE-Tag: 1759422218-592418
X-HE-Meta: U2FsdGVkX1+Nfpd0843/tlN0FULKydGONsdeu/dFXnFvzUc6kCadgm5gJ0kgzwAcn92bkyzY5mJUsYl9x0ZNrkNCwMHBjjqJ59qUC6ytIX05ygAsfTONFlvp7XA+BTTvs+bVv/j7L9ZGx8KRMmbS/+KjXRsGYlK2iChIMGZjIMdnRk0XfEZiE2dInK77lFtehhHbdwK/VjkZ+RyhrQvArIFV4DKoFsqLvE4XoExfjIF0ZG0G1OsRXuAYeNUoXS+r7L6uqznAxnzN8lZyfJVfkCDTQggXINHHZzVpq6xcKFPFr/DNpaH1Y7KYdizXFewmLOJdLF3WnETK1qLCHtu5kYuJ4z16L7mvtpFeNPk/qtwg782gab7rJD0blSwfbNrkNb96+L9F64a/HmBJ1pm2vp9KoV2+2oIEI4rNN4FNsvMrv8x7FGBY17caFsrrA6j/4ZeQF5GtvoH308UWU2NZnTfFqn4TGmINnxAfxFDcD/FkeLuFkywF8s0kronio6qQFVBxL2VafzOlo4oCS6qkvADmajj0Ff76IHJb+TgoAgLXHW7loTP9opFAqXekS1kn3FTrqwHsMgfCriXtVDZG3oRX+moa71PhuV5iycGs0eg2Cw1D5tgZna9REBvZ/hP+fhcjWaHcqoJPl9uMaUtpg/lwkpHvf9HxipGhhweO3lgK90AQgxzAMB4oPlaS+OeT3nShbkSJRW9l6s6rzmNYPpp1T/1++kP2HKv2HqLPnSIpDUWJCACBeu6c9ifD8QBF4mknaN7EAk11orjhdqp5FOKJaZl1Byysf+IfnXsV+yBPJJuc/DmBFdDipAfJmpD+gnIYz7Yg7/ZK83Yw5+VuclFdg+AJL2tHqly77JPto4YvwOuvmGMVMudITBbwe8rd3LpBdrBk2d2IsvRtfaouOU52nmGnBnCghfhjuuw37IDySVvQyQubSOulyPmzO9HGMuBiScBvsgtZYnZUFYy
 tCiDxmcs
 oLkfiguXH6//QUPl0pPYigbrr1a9A9lcrFFUhBWptkDASMMdzu6SKb4nlRyyQvtQ2zF2NrWrj/OYwapF4se/1cGIVtBg+B765C2KdTdPwTSJ1s9oqW++4rfZGJas34g8g6t1SrWyHF8LUgMPHRl1yFLkePAW+rAWzYdhK49T3Okgk2MAIir2N52kMC44JCMpj6Z1YvoNuSCob1BAf98MPu/kcQ65lbYuxdi0p9EE7g4xxDi1kczpW1b6I607Kgozpxb9w3lrfl6C0gOWQK3tgHnENDCtqz8PuI0gqGTUg26cDun+xbKYo/Ok/TYD6xEj8E52mhQjLR51zEJwGc4gUJeorbNJofAw1Ee63
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 2, 2025 at 6:09=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
> > Can you please clarify what is the benefit of remove plist swap_active_=
head?
> > e.g. Does it simply the code or make swap code perform better.
>
> After series "[PATCH v3 0/2] mm/swapfile.c: select the swap device with
> default priority round robin", plist swap_active_head is only used in
> swapoff api to scan it to find a swap device according to the device
> name. It can be replaced with scanning swap_info[], and there's no
> efficiency degradation. And we can remove field "struct plist_node
> list;" in struct swap_info_struct, and the relevant handling code which
> is unnecessary.

So the benefit is removing a list. Thank you for confirming that.

BTW, I think I found a race bug in your patch 2/3, I replied in the
patch email thread.
Let me know if that race is valid or not.

Chris

