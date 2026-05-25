Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A06FCD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 11:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988B86B0005; Mon, 25 May 2026 07:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 939FE6B0088; Mon, 25 May 2026 07:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F416B008A; Mon, 25 May 2026 07:24:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7510B6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:24:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 223BE8CC64
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:24:27 +0000 (UTC)
X-FDA: 84805708974.07.CF5F6D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7E9C7C0010
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:24:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NrUdGUtc;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779708265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTkrNOELWZr8RdZHj18oo4hwbTBtjTNzSnJO48KWYLM=;
	b=MQT1IgRfTuCs7+CjOa4HazFntkABIMyCbvBWaRJGz9ZYbt8AlM3SzwzVy+HOKznOqz15bk
	zIg3I+RJDO2MUplZaiD9wpKdhauT3RTLmg3jhaj5Omy6v3EIYatNoeQs/8gR0n3pQN0/Fp
	cJxIec8CFEr6P3y4ZW6qldvSifXUkwI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NrUdGUtc;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779708265; a=rsa-sha256;
	cv=none;
	b=KYm1CsUOXI7XqWvBd3yFkcelXBanF8iFaOZQdleBz7d2Pc5OBM1lLzkcGM61IR782h999u
	s1lF6/BLtmaxlP0UJIkpVF+Tvlhy5VG6an/MQL5vnyUP9VZ+7UzkL8tVwMoY4P9YhI/DHp
	LoiMHH1z76dgIqwW90nDAxxBdwvcWwE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A75E43E79;
	Mon, 25 May 2026 11:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A97B1F000E9;
	Mon, 25 May 2026 11:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779708264;
	bh=lTkrNOELWZr8RdZHj18oo4hwbTBtjTNzSnJO48KWYLM=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=NrUdGUtcv1upc8503i/SWwLghU0nTsZE3mbLl/zX6G8T3puMs7bgJjpdYscqLeCm3
	 VNQw/BAopGUnH4GL/qjRfBuBHSf5uLQjObMfByWuM335/hQO+9qeK2sSjQFma4HB9w
	 wqJ/7TbfUNZs6jd7ghQ3DUMdzhCYYQeQMWGpq1ahjRtDmEtJ+EYPfFaOaBNDkhBgM9
	 k8jW/PgF9PqXZrRqP3Pxo/snC51+0ApDgPHBTIudT+0WruYb4EMziNGZx/KlVcJZSc
	 gRqLxdEnmkynF+t3XioL50S7hZvZj9opcFAGfCcLcXSID+6reyalojZjdMlp3qVyQV
	 zN0HV+jUnHZVg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/7] LoongArch: add KHO support and selftests
From: Mike Rapoport <rppt@kernel.org>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, George Guo <dongtai.guo@linux.dev>, 
 pasha.tatashin@soleen.com, pratyush@kernel.org, kernel@xen0n.name, 
 graf@amazon.com, shuah@kernel.org, loongarch@lists.linux.dev, 
 kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 George Guo <guodongtai@kylinos.cn>
In-Reply-To: <CAAhV-H4p8xe_Hfx81kjxNrp5g7RKvi4f1QM7avLvnf_r+VazFA@mail.gmail.com>
References: <20260525062810.103367-1-dongtai.guo@linux.dev>
 <177969529480.4047269.2120994507098781563.b4-review@b4>
 <CAAhV-H4p8xe_Hfx81kjxNrp5g7RKvi4f1QM7avLvnf_r+VazFA@mail.gmail.com>
Date: Mon, 25 May 2026 14:24:18 +0300
Message-Id: <177970825876.4071219.16831083000796070841.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7E9C7C0010
X-Rspam-User: 
X-Stat-Signature: jsnpwsaa7kujba4jmwgsh44knqujbp88
X-HE-Tag: 1779708265-156831
X-HE-Meta: U2FsdGVkX19bGc3dfm0ndLddXoRHqRkbadktyKlImoH6W2IN3mrmhDKGUoEtKlwABMb2WN9xnX0lgHsMcHMBud0WVUV8rL0ey/VPA9/q82/Pxw/7lTrpZFrB1mf2fclyb4ALlojE5wnC3FgApwnJRNRzeoBVPT2Ahyy/bDGEtJ3FB0pGOpa/4L2pO0bKnFNQqbYiG47N9AkWTrJYzhew/GFR6Y5pXT90Q64on6JZ2ehPkqHQebhpDUn7J3MT44bRDbgDNYEnTCTCGcs3NsXFUK1rMo54a78mgyG03wOFlxAttnHShUUzVfr5WIq8YJi8/XJJiKSnTIgg3eVRhZ2GomMysZDtXYCVxGYnpsKrvsoGia4R3UbTl2WMigheCJ45dh55SvKJR1h7MvzccJJEq6wn5SJjZswp7tIxNOREj9JOKcV3oovAc1dJUC2+5P5RWVf+TISMS3s2cMufobQLaeqW5Mnj7usjb0lR+yNrj8zu5KhzK8rBEI8WxRmb+a1rB1bdAKQTqpLFBsSUjGxIEQ2rnQGI9wB5r3/sM13Bu/KkmSM11Uh8M5YohMtrY1XlTEvufHFPr2ah1JemNtX6d7MKazYFGjdfMcmcsz6CdJqF8rOPcDNA5ydLyMXjDTX2jcjUqDPgMMgeaJ2JzHogwwM7ZJuPRBLUopMiXmmUMunjRUDmAQHxChcL95ZFHNae/MjndpOJll4DTXOphtkcvWuhsL+kc+HvHbWsvy3o54EfmX0o4Rid0jUuJfnlRg0ZPn5hqEVUYCMpOVhE5Pp8rDhEid51hk6vmgYSgrG9T9W2pvKThuA6rXubjEy9ApNSs7TE1CZVd+9xjZPVPRdh+irqm5JgLN1vWJaGwsYYPvWZjXOpdJQohlSRgKkTiBcK4E2NpjcF5lJ6fBdSwjcIX/KyJrsFNAfLkThFVnjyOXKUjaVjj4zIiVx2mKBi5tL3sj/90fV4euMwb4i3ISQ
 61PMBKYq
 D6G0oWQAsQaZGCOuoylSP4YPFcvLZG2LlLyRUglDZ1ES5xjz8TEntxg1VM6giZk1cs886a8f9v7I9le7RPN8vEQWk07518kWZnmDartUcR2EwQr1o1qPVyCwS3fNSK2QFM6TCimkZBX7vIBRxALQe2TA02Sv9dH37kXua1f8tjh2wIDnFgKdDiL0FEpyeRGHwnpc5WuZ6d/2XTMsfhuBKwDOMt/JouBhDLCYAKPhwleCtwoVS8rDI4sbJmQZQx/j9Ilt1fzlYmSl5kaUqirkWe1FKAeEXEU8rBU+8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2026-05-25 18:25:08+08:00, Huacai Chen wrote:
> Hi, Mike,
> 
> On Mon, May 25, 2026 at 3:48 PM Mike Rapoport <rppt@kernel.org> wrote:
> 
> > On Mon, 25 May 2026 14:28:03 +0800, George Guo <dongtai.guo@linux.dev> wrote:
> >
> > This fix looks unrelated to KHO, it makes sense to send it as a separate
> > patch.
> 
> He tried, but it causes new problems, but I agree this patch has
> nothing to do with KHO.
> https://lore.kernel.org/loongarch/202605211925.DbDvQ6ii-lkp@intel.com/T/#t
> 
> > And I believe that patch 2 and patch 4 can be folded into patch 1 so
> > that addition of KHO support will be a single patch.
> 
> Patch 2 should be folded, but Patch 4 can be separate, because it
> should be backported.

Fair enough. 
I'd suggest to move the fixes to be the first patches in the series, but
presuming this is going via loongarch tree it's up to you :)

> > This should be folded into patch 5 for sure.
> 
> I completely don't know why Patch 6 is needed, for normal use I8042
> doesn't cause problems in virtual machines.
> 
> Huacai



