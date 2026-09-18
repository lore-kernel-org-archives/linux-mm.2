Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60CD1C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 05:31:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244F86B008A; Fri, 18 Sep 2026 01:31:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CE7E6B008C; Fri, 18 Sep 2026 01:31:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095276B0092; Fri, 18 Sep 2026 01:31:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB7766B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:31:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76801A58E3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:31:43 +0000 (UTC)
X-FDA: 85225760886.17.F8241A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9B1ECA0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:31:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XALPkTHI;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789709501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTKs4UNutRziimqfjfFRRtWf3g6axFUgMAOFzei57H0=;
	b=mSfHleeQPPzXIQRyFFKaOstMHNiMcuo7ha/oQrcnBO5znhLeQeO6vFUnblX7Yoqn8a+h2x
	n/MopF/tpaDdfr74/cUqNrTzKSdfpzVE5x1cMAkc4KNxSl9m87PJzWzntuwyuaxdCj5rI8
	Ra40mLkZi2E/00cMPiFdO242qagFBcM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XALPkTHI;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789709501;
	b=7t6F9olGlOnsnw5IFPxnXgYIURAa+Td09YhjzS1Ts+AWDcxiAikE7WV1CsPwu3B54PIpMv
	EOx3eS/O01t0KHZZRtHnrqFcQDm5R1/e+DJ5zLZbtFrBbkLOIigk3CMxoc1QzsYY/1DXPn
	O4JCEdLlT0ZjWeBckhA3X1ECSiKWQzw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 350B743DBC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069951F0089F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789709500;
	bh=lTKs4UNutRziimqfjfFRRtWf3g6axFUgMAOFzei57H0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XALPkTHIOXBAgobYA6UDVnDozvAdDLZC3xRanFKDF6fM0hJbu6itU3Gfxx6Xabvj+
	 1Sdd1vlOKXZusbYwc0YBQgwFyAzlDjI6yUqNT3Gh0uOia8qwC2+Pdaw7wZdGps/fDy
	 yBUYPAT7zJeWwVNb66vHcCJ6mBsXXL3g5X9SW+SG3Re1yc+8b+QdQjYU77ehMeXe56
	 1lAWGkwi+LVNIjMVc0pQ6/b9+Yfss6yAmq4XUkUDPPm8d+Ew5YRRJwvcnlPhcvevMO
	 dfsztsa9sz6MzGqF03erFilyIWLi+WGGgxN2S2mvP9KK2NYlM5aKVv63tLZGzLcuGe
	 USBPFM+N87EaA==
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93a222edc62so41780585a.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:31:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxSP6uRrLe/aKm+7CDLAmReWW2hhl16j9WDEcXMnb51Cva2/oSDFaLFevv6pV7i4HYfamvka14FEw==@kvack.org
X-Gm-Message-State: AFuF++kTLgI49pRxxKQ1DRc5IyK74PvnBN/T2xDqmL7B2tV4ZsmdVfeL
	5s8mk63GRFwFkN/IG83exfkQPMiHGZZgSInWaet3UFjpcpnlOqBrdo0mOBcdOHsfQaC3fzxiR3Z
	s3hNnhCyHdJGuiKF8aaQ2Ak5RGAkTIvk=
X-Received: by 2002:a05:620a:8014:b0:93b:d79b:9a72 with SMTP id
 af79cd13be357-93bdcb308c3mr211352285a.83.1789709499349; Thu, 17 Sep 2026
 22:31:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1789701677.git.baolin.wang@linux.alibaba.com> <12bac4614aa4b37490e92051d484f4f2cb215076.1789701677.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <12bac4614aa4b37490e92051d484f4f2cb215076.1789701677.git.baolin.wang@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 18 Sep 2026 13:31:27 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w-tgRiaRz0HN9yuC6uaJ7TbzcyZjhZ8jAeoFP+Vh2p9Q@mail.gmail.com>
X-Gm-Features: AcwNN1VR6l_eDj5OOibm_tX3rRIND2K28WTb6XdqoNZ1l5ovR0kEfYMCExbY97o
Message-ID: <CAGsJ_4w-tgRiaRz0HN9yuC6uaJ7TbzcyZjhZ8jAeoFP+Vh2p9Q@mail.gmail.com>
Subject: Re: [PATCH 01/12] mm: khugepaged: remove outdated comments and check
 for shmem
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hughd@google.com, david@kernel.org, 
	ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, 
	usama.arif@linux.dev, kas@kernel.org, ljs@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9B1ECA0002
X-Stat-Signature: noab6oqd3p48crs5pey8pqs8771k93qh
X-Rspam-User: 
X-HE-Tag: 1789709501-57282
X-HE-Meta: U2FsdGVkX1/OhEnJn2KOvdqQcMU8aHNYodQrNbN1tj5ZRgYWSK+nYPGce3nw6dmXplYTB2LxcJ42MwP4GA8Se7l6vZtTPx2E6Ojt3FslGUbT4xpWtFTCuzpzyUbqc86+TGTc2XbZ0ZSmbb5ZyW5zphdhY8DDM4Ge8Ma4ucsNgodW87Bnv/ZMYN/o8hXUUIbO6mwMEovcAjJOCImrAZBUMbrwuUSjtH1/HgHvhuaKChGhbnq2WMcypOu8sf0pzfuJvG8+7tBy3BmyY1xnecWPUNQUmD+lZGaYF0znt4sclN+mnW6OvNjUK/bG1JDY2DfCGk0SjJAajqND7kTdast0Mn0EAkpg9aBUl6IKB7xwTPvXTEOKj7Ss6Z3+Ytxt7YCoI5dK6M1GA/PxGCWpxJ3ZLSt8Q2lh+YuB7V/5IAJgfHpTILKMnE30nRRn7At+ak57+Z4ePJsQUwrUo4iIzT3B+L8OJUFCzcGyCLMcgQyTldPAP3gG4BOsckRGexQWCX8jiyKFoSwtk90H6hZIrlJ4fIWiDj7zGDbumBecV53mkDD7qF08G7UVq9ZXd821aUpAHD9dfpuPHO2xcBFCC5z7zSPep8NWbRGBR5OMvqLrqbxE2l+9FrtN3sh/Rtv0JEfCAmV17gXL8vEovq5YCse9ettBCMRAXjdJbSMwLAtdlxnjpt2VtLb0HQVOM2U1zynG+o8zSMPBreSJhUsFvGtK5ooJtOWkh83nACYfBlKpByBrMJYwPP0ksK52sPcuaNLlUUAWnP8IwJw+co1OA2+22lPgPCJbrbxOBDG04HVRyVaosS3qyqB5KBenBkXZNrhGHNeUrq7foJOwe73MPn7yect3rjJrAfr+RJGb3qjbrJDQffFthjoV8WfLjEg/oQ3LPx0gQ55qcLX5+r1HIsJtbTNYCLtVKNLmXGvkHidAw8Qie/KCQSBQOGJDbFImp+Xe6X6hOsfByIorHyXyuEO
 O37bNidz
 55hNBCLSqgBuCqkTJpdyZsorQzHZ4PErQ6l2SzDZk9VuTsuyKOqTCaFpxPV4UI66ZWGnvVfJep8eE0rSNq9UFGJ0yPdlReOPhGXmZIti2YkJsSoDX44J5YzJ1igaotzMuVZYAzcERu2jOZAAdg6u+Z/mUKHu7bM8XJKATLFKibpFrU3WFuZAk+mmsRuLrOrarPbXcykqUfusBF7e6h7xkGCrquA/qtaR4ZzDpe7FtV/ectdaZo4gWApiZJabqPTfa6I5N6FOmg1RD+kw501USq2n52WTrAMl01JeEoWmZ2K3KbO4TSlNgswifccvdsKwopowScGRPPKfYHIw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 11:59=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> After commit eb92d97f7e6a ("Revert 'tmpfs: don't enable large folios if
> not supported'"), all shmem mounts can support large folios unconditional=
ly,
> so drop the outdated comments and the check for shmem in collapse_file().
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

