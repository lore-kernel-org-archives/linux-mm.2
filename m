Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 319F5CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 20:53:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846DF8E013F; Tue, 14 Oct 2025 16:53:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81EBA8E0090; Tue, 14 Oct 2025 16:53:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 733DC8E013F; Tue, 14 Oct 2025 16:53:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5ADB18E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:53:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14CA911B1C8
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:53:18 +0000 (UTC)
X-FDA: 83997920076.16.2AB889C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6C86EC000C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:53:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=swyR28py;
	spf=pass (imf22.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760475196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=elgpkSHi7oRAKLl42GPYSQRGs0aJD3woXeve17j9/bk=;
	b=Cvr/znHWaEAqXM0PFjUDQh0e1D4tkKCfYMqoisFy1o6bwLNxOCXYiok1DmRHcK+0r+QP4x
	82E5RM02Wql9RO6JizOfr258FmX07ywy7XPdpHmGQW26n3zIAOenIqcngkwJ7AIOhfSf4S
	L8XTchpw91lB6oH7xfIbWQlVDAZ96EY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=swyR28py;
	spf=pass (imf22.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760475196; a=rsa-sha256;
	cv=none;
	b=yR4vc0gLAot+KLPNRi1WQubFZ6JxWnBhbk2B9AWh+nBbBhOhKZqPcqx1KC+XFj/GWXT1P6
	GUDqplcbyQXAj1UsDey494o8FhR9Sya8O8Diq18gbqC78RA7V+WOkOyLmqXvd5AKg1htCc
	/Ax/fD0SpKDlG4aB8AA5xD9qmyifdWU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AA70623FC;
	Tue, 14 Oct 2025 20:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21D6C4CEF9;
	Tue, 14 Oct 2025 20:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760475195;
	bh=n/LR/VOVuEOFCI8XhFHTE8VhAsveYLysbT1xUiVBRoQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=swyR28pypyBnRwl4m3DigwMj3bUrxOd00mzjuGD5aTN0FjLn8NZloGgLtoSm4EWF6
	 U+OQrImhcyFW1VE+1XOf7gsl+Z6u33VL59B3ZFGSMdhSCKfE10SSPf7PmGdnejwJFG
	 4W7sgMSd47UsSs4bbQQC0m2b54v2j6riWSO3ueU6abtrZ6v3Z1APYa4Dz7eg+oMj1c
	 E6GAg/xVIOaSHdCbI1G5jNYk9cUVlMAQIS1+cIiZKnhohliyM8TIACP4GiEgzG7+ha
	 7oSYLyFf2hw0TAj9/uWSaVineqdRxAJldC0oB4sXW5a4J7HK8JAuGF/KcmG4Gk36Tb
	 fkRsty8PnFzAw==
Date: Tue, 14 Oct 2025 15:53:13 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 01/33] PCI: Prepare to protect against concurrent
 isolated cpuset change
Message-ID: <20251014205313.GA906793@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013203146.10162-2-frederic@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6C86EC000C
X-Stat-Signature: cqkz6p8a473kmiube6negd1zaqq159j3
X-Rspam-User: 
X-HE-Tag: 1760475196-182121
X-HE-Meta: U2FsdGVkX18Dt+u1BKHuMZEFvXnRoSMLA6j/jwP44rT5S74TckDL8C2VC68a4WPz4E8L+WAnFRfbmjDRoYlqET+F0MoeFIdxJ0WDSifoAsLJ/C9w0ZaOtittqasgz08VavHuEaGRHbPOP4cGqTEO1HAr9LWk2DNt9sc5w2Oa3/IPF08Yv66XoWxO0ErSci+NiYRIFiTklidmxFOZfbgn1o9PQcslNIK812E/ycqNjIw9IhRynpQiCwgNQE7tOxd0VmUii0Mne8lXKowAonya+sEYbnSWvFN7bb/a3TmtPjWvDsfcs/6VuE6dV+/t8RFvoN2v1JdoRFVvGUAhRBkvJcygqjG16EF9ZU0UDjSL3Kanf2J/dH1+jpFrxT58b4tqPFJERP5/Ys7ZXv2IHNkjwW9W0abvo0hgPnAFFfg2e+2ClqHG7ssu0pHBVvxGsdjEaQ4Bdw9eoDwgidOk0MdzVJ0rCLpW2gjASW+mN4uzprCANrgCpQWvjdI0rtMtibrXMtsySuTZLHj8QnFzEUn6JyzyGnjLsHwlf1BjTiS+5rvtbpOZtMn3+tLMYfOlaQX+3msaRGGXHDCvzPUJYvCWOUsKzHdjEzp0zcYCstIKY89lRjL21JJsc7cv0SYJLzsKonUnyf2zdku6MVVtUP2nJkD3TItC/8rcTltElh4qAqGCZy29bujKEPqBW1O2jenO4FBJIWEc0kpXk3BPuwM6u6bv0sVvXu1KT8EyLVwT1iqMv6o1yWJ+aYcqyGUPRzK4clv79/G6nlJg6i9DdzJYP5sf7IQpgFV5EK2lZBUa+3FhR4eOnQuTqdwSMLk4kcPrD9NANED5RFYIt3aDyBvbY7PmB8cO9I1uhwoTRuM0s9qo2jsg8MIDDW9FuEXq1GY/DL2nZCRkEdScklBfZmvwkcDFvbP/fO/5nVmvTINldYPlw/Xm7gVA+nCgnNdGRRxZzsvwuCcQ8NdsIknqHjT
 Kl2opcpM
 2upLotxkWgA46c0cF6dYzGVuqx3a75X9hIpUOIlrlAhdzCjpsu38DZVgR2SM9tQovbSosnTofqzGlEbb0CL/SqiNakUPEPx8ADeQkw42ehEzCY/1CxNtOohclxnVaklxuqFhM9AkqjtMFhLwTMoPZ40f2AklwRy0Uy2Z5ylevK6Xl/WeG+YUxJabQ3jJpkEUMR0TtPd4CaO/287AIHiy8WBsdWsRzPTXt46yrxjEn9xI1uk5LhYsIy7slSZmvuq5YMqFhs5GxcDJTbB7KgvD97sIo8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 10:31:14PM +0200, Frederic Weisbecker wrote:
> HK_TYPE_DOMAIN will soon integrate cpuset isolated partitions and
> therefore be made modifyable at runtime. Synchronize against the cpumask
> update using RCU.
> 
> The RCU locked section includes both the housekeeping CPU target
> election for the PCI probe work and the work enqueue.
> 
> This way the housekeeping update side will simply need to flush the
> pending related works after updating the housekeeping mask in order to
> make sure that no PCI work ever executes on an isolated CPU. This part
> will be handled in a subsequent patch.

s/modifyable/modifiable/ (also in several other commit logs)

