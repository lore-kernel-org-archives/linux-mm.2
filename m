Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87D15CAC59A
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 06:24:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A86A78E0002; Sun, 21 Sep 2025 02:24:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37158E0001; Sun, 21 Sep 2025 02:24:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94C7B8E0002; Sun, 21 Sep 2025 02:24:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 80F128E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 02:24:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 102C51602BA
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 06:24:23 +0000 (UTC)
X-FDA: 83912268006.08.D5B1B7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 675E180004
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 06:24:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mG5uWx77;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758435861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eWcdAfkQu2Hk5PJzJfAjIeCbBCxsmDLxl1sT6vKhzQc=;
	b=FZtyWXDy5ZyN8nkQMkixhIVgJM8eDROAs4sbuzmMnMbjiM+pJlEDwDpLuL5i8BjZYdHOkm
	m9xcxa39kaZOvjwrhzsR5JuTzT/Z3Bmjqj45tKsysH4LZmfEonal+uFMb/Zs3HW+FaNbqA
	1VgjUjtHAkraGD42S+dA0OreyyMqR58=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mG5uWx77;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758435861; a=rsa-sha256;
	cv=none;
	b=A2t2vCFYdJwQbGrfMXsei5vhIwG2N4tbUYumE6/n3s0UMCVnS5uaU1JrXPeJj3ScdxsZ9B
	LWF3UBfsoJ38r7NlfBQUeZEM0BQEMdZvaYZ5Y6lkuf2t3i8AN8PEuoMAH0mxa66yoMmVXI
	lLZ8jGdDX8KEp2QFHPrIa/C2+3ivryA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DE87446A9;
	Sun, 21 Sep 2025 06:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E26C4CEE7;
	Sun, 21 Sep 2025 06:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758435860;
	bh=7ncQyYZxpGQpoWZu4O4eeQ31bFZfa7Ff2+7sYzrfMf4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mG5uWx77WE0EGnCrHbQasMsoBXvZLyPyefnHDo/kv1dErYEdI1ixpuJRy2SCwFJt8
	 lVCSDFtq2gEKcqR29ZP6JNVPZQobSCkg/IsOC4p/3Dgp6QvRkYbxJOtEqBxvkwxKsg
	 10gPrepuN9n3PonQTVtPdEmWnCGXSJxgx/6QAM9OQW7H/lFS1bG1wQ2xWQbcAfH1Ki
	 HU4G5KYrRpareJGa4IVC5HrYOZr13dvUQj0Br2epvj/QlOUPAltIoDZfvuotLTFxz2
	 9LLBuQKO+rYqzfoQBXQ5m3NcTW+TsUdsGScsXteM/3JKOYFOWJJDdDtIuILWqBPyq5
	 PSMCpgFOK7XZg==
Date: Sun, 21 Sep 2025 09:24:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jan Engelhardt <ej@inai.de>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com, Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>,
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture
 support
Message-ID: <aM-aDAIbKqBMN2DQ@kernel.org>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
 <3ns36rp5-rp37-1nns-9q43-op05or6s26nq@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ns36rp5-rp37-1nns-9q43-op05or6s26nq@vanv.qr>
X-Rspamd-Queue-Id: 675E180004
X-Rspamd-Server: rspam05
X-Stat-Signature: kftz4odhs93rwyamixwoha1rzujnq8of
X-Rspam-User: 
X-HE-Tag: 1758435861-233975
X-HE-Meta: U2FsdGVkX1+juWG9Qz2PiaHKpHiq6hG1y27+oeVVrdWVKMxLqwynz/zWyABsMR816ms4eCn0bBctQGFkR2h+Kc1XnA1Fjr5XkLY1ti9aYSuO+gSL0YgzY7zv9I3mI0wWPG5yco8dZBFhZVVyquuVprQ6uXA9GLDQy//6eRuKxjDjv9t0LUQbFVq7/oGjatvAekmS1sB9IvoN64OdDjBKjxmRk/LBmQd1KFmKZ8sSqjE/mJQW2akwsQvRCT350gs0UDISRrtt/eKR+3535d3jgFor97THQHHBqreyk5m31bci8jFVSDlglws1+rWpzjxJeXFK05cMIDhBWpRdnUlb4C6D5cadFO2zrGUKFYrKyNNnZbbXmKZu+jmE2gPSqwZofqcb+jO++R+tBCzeztbNAiV0ncpL7odxwOBq5o6R1NExGvSelZmNHWdALcgXIOz6hOJK2bZemfL16sa5Tgb9E1Zn3eSNfc1hCE8BeJcsQDCX9oR63CO0Y34y1CvxezRSOhKj5vduDfKQN/QBVwFNZ3t+jA0oKWfwTX8cemOeuRq5VhqUX2hBjsdMhgqkj/XNWeghXmTg5LsvHZNHUE1BeHFnlZ1UlGTwMFsvuXg4qPHxarGRQ1og1OzjoHaaFghn7X3ECjl4nQM35pwz7q0PQK8D1hqfZFOwk1XrtF4pbgtyHk8LjeCi0K/KOUf5fYp6mIRG6JJ90efJEor4fhlUjRxUXMr0S539XTk7T+lMvZifIdh8tFumZlouAzc17k8DF3w8l0EaWEgaADB4Dlwxe2JZRowNF0pv65rBRvlV6/hTU348ptKlMpNz/QvdzwFMFCX+XpQl/Pvh8hR1/PsWg1QqG0V/SriX5EYSF2U0y19mxTtgySxthV1y0jiBP3fM8lVDwv4vFg5rSEdxnIEzYi+F5jWNC9HvIBooM5u7Y4H7rPd2+SBejbamaD3MfheKhc4opdje2OB6MIR5Dgr
 2bMgICjF
 cFVMjlxDt4yFtm7x4gl5WdM5/qu552grLR2roxZznaP4zH8mN5ivq4NfoKVd6R+t7gtOFpGv3/xWVh77KBx+7wM+QXouZbvjziI6wTy0YcQ5NgXL1YzvCrZxvS91ZTyLpi5po91Xyz9BcLKrBAm55N+BZUhnEAx4aFiFC8Lh1Aw59kq7MOmGnvjnxM2FmhYo+rfEC6ml7kY+W5mN2ceLAI+8MGW7FpyYP+zwct6mDqwXfE5ucvuONWpJQ0IcNECauD5tCS8ABVo3EndKCOU0Sr9vhXQWlVcU0ViTBMQM7OTgDf7+rC3PhIYA/TMQhH0CLbdHWG9SdPwZrnB08dWcLlxojbgqgl5R/ttSe3opbrrU7w/PHSpbnQWLVYX22rm0eLzoe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 21, 2025 at 07:54:31AM +0200, Jan Engelhardt wrote:
> 
> On Friday 2025-09-19 00:25, Cong Wang wrote:
> 
> >This patch series introduces multikernel architecture support, enabling
> >multiple independent kernel instances to coexist and communicate on a
> >single physical machine.
> >
> >Each kernel instance can run on dedicated CPU
> >cores while sharing the underlying hardware resources.
> 
> I initially read it in such a way that that kernels run without
> supervisor, and thus necessarily cooperatively, on a system.
> 
> But then I looked at
> <https://multikernel.io/assets/images/comparison-architecture-diagrams.svg>,

The diagram also oversimplifies containers, with system containers the "OS"
runs inside the container and only the kernel is shared.

It's interesting to hear how the multikernel approach compare to system
containers as well.

> saw that there is a kernel on top of a kernel, to which my reactive
> thought was: "well, that has been done before", e.g. User Mode Linux.
> While UML does not technically talk to hardware directly, continuing
> the thought "what's stopping a willing developer from giving /dev/mem
> to the subordinate kernel".
> 
> On second thought, a hypervisor is just some kind of "miniature
> kernel" too (if generalizing very hard).
> 

-- 
Sincerely yours,
Mike.

