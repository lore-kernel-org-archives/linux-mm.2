Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69BF8C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 20:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5F86B0092; Fri, 24 Jul 2026 16:32:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 466BC6B0095; Fri, 24 Jul 2026 16:32:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32F666B0096; Fri, 24 Jul 2026 16:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 031EF6B0092
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:32:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 31DAD120162
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 20:32:55 +0000 (UTC)
X-FDA: 85024819110.05.EC5895B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8CFFF8000C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 20:32:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lMBvjMyc;
	spf=pass (imf02.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784925173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=ZKQYivscj2/YLitJTr85nVGb3DcdncClDyomNie32W0=;
	b=A9DZNwD4DHe2yApPgSfWmBFsoMW/+PNcEKFjlWWI3dxQD6rhJkf+tVF4Iqno8GIrZfupTn
	tEL6YECYp32V4Y3oB5rXb18iXlqq2yN3VPpvhh+yodhaTcNf7bg+4/F/aBICKg8QUa/U3L
	E4QAYS7w4jOpkaJ97GaIvfUcj9RSXZ0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lMBvjMyc;
	spf=pass (imf02.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784925173;
	b=rQuRHVF36ZcAFWfPo6pCFCcJaGMYCRfSne5TdjVNndsH0XdooO273GOH9QNK8lKORHKQne
	p5b/ngIskYpSO6hNemiNWHHMsV2wY5nMlPIOEXaVVEm2l7MiD4PeYWcbKu6B7ck2pT9Kcf
	eGybxcacD7z8fztjdMEqcp4P1Dt5c0g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2CA6144011;
	Fri, 24 Jul 2026 20:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F0D1F000E9;
	Fri, 24 Jul 2026 20:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784925170;
	bh=ZKQYivscj2/YLitJTr85nVGb3DcdncClDyomNie32W0=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=lMBvjMyc2ADRRvgYO7Si5PcjiSQSr5it1WztjtKdT5vjbWClOEsrOrjW3ofWdtYfH
	 qY32i4tEpHCBD4Mk6wgQcyrclEAtjJ/PyKX8hekEPUjzN7bYF0Qp+wSJyfEzum6Y8s
	 ch9DH0xsWI6UY9vX2KspJTFw23p+foJLZIkGbpDv3Uq9ozpqJK5St52wuLIjzmuwm/
	 tmQQi51M4YEeH6IPo+uSf6l7FgqA18Z3vFp/BGwvx1MVr29TJfAep47O8oSuX1TpYj
	 Y9IJC6d6F9PLPw/2QMcqnW3IXzspoFpC5TEl2RxCXyb06cQvqhFLLRoRaMiWRf+fzn
	 H85M2Nv5O2FJg==
Date: Fri, 24 Jul 2026 15:32:49 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v7 02/12] PCI: liveupdate: Track outgoing preserved PCI
 devices
Message-ID: <20260724203249.GA1033821@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710212616.1351130-3-dmatlack@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8CFFF8000C
X-Stat-Signature: riu7nrpmw7j8n44t34frqikp87xcdb3h
X-HE-Tag: 1784925173-250840
X-HE-Meta: U2FsdGVkX1+q/JWaDNbgOemQJ7lFI3L9FrSIK2txo8tHrcmj+FHiqv1nS+jOHhQr5txV8MMiOO7GujZSiJJdKO1BrAohsjxxt5fCKikBbcICMP5bcP6XL07lEDe39YYYYVthNXSl0ERv7Z/ExFXY7WqB09ATddirChgS4gwGf9wC3PzinA29mJ2ZGuJZ1jcXNV0bGs5QdssSn8hOzdHCVAyZq6xvuviy5Wiq5WKQwe8YXzpc5VjER28saiH7zcah6186Cn2qJJ8rAsPIX1Euzf0rr138YK9n82BpODI6vGyfFnQUvDJsxIFeSWmYV5xNnx2b260Hm4ygyeummxFRnP9Et7csROm10D3ga2ises+M2MWXzUfAJ0WB5mBgA6l9hDoh0smLe6WxvkOaWpCh1uAI4oLHHPtGPjSCDu833vVCa1r7ctJi+4RWnbIAVf5nX4QvgmSmA6a/HeGYdUggSfedurvBxBUo98LabP/edG3BbHuxbVJwrHSYWftffuG15C7IGwYqcqvr0vILEYKrncS4DD1PpZkbN6hrYR3Llf6EoqnbimmSd6+TnC+n1JztoHnR3VM89wx77HtTSvdrIEbsP2Ib/GdXGqMg6aPt2YX3IFQ8ZbRb6Vr0gcYmchElNCz9yj85H41iV7IXtzsieluBisedqPL21TMaGC0SppZMEeLMNjiHlC3EB2u1+1z/1qXjIw/Mj5W5BOEVxQbY7PfMzdvN2uIry163lzh2hioEJUxypnar4MVdcwg/UwEAoerbtRJemEmyL6Ttt6Niz3LGLai1u2viRBuJlb+IUXRHsVNJGgFVx9pP/qNsPErVbJ0BZlr67QnQCfRo4MbheTcoptNhxPDnB6nUPwV40y3lqbdLqsobpxUnhwg1O1AU9rdgFwEThdWFIm+xeKX4vRlRJRlUO52FwOvMKIzeHU89GPpyz1MKDSJlG7Vx3vheoGzTM0IwdL9EmMJl+yG
 fVBv2C5c
 YLtyjuE/R+AvUg32taZ6+G0c7sqP1gUO0HO0CNral+LEQZ33AkI4fia/9iR6npNEmr6JSLARPdJiUydHM2TtMEf3N242Zw4IQrl8B9XjWNBueT3/p4z5Q2H9RbQCDxkP9LBg6h6ALA179BIEcDuExI9UBw5u72XTsaSuinB/BadNiAvxAYORbBChAGCwBNQYXFWljTX8UgxeRbl6f4OLf6sN6+bNZywJwVtnf0yFny0ZK/dVSYW4aHyjDStAJ42eo+6K+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 09:26:05PM +0000, David Matlack wrote:
> Add APIs to allow drivers to notify the PCI core of which devices are
> being preserved across a Live Update for the next kernel, i.e.
> "outgoing" devices.
> ...

> +++ b/include/linux/pci_liveupdate.h

> +#include <linux/kho/abi/pci.h>
>  #include <linux/liveupdate.h>
>  #include <linux/types.h>
> +#include <linux/spinlock_types.h>

Alpha order unless there's a special rule about spinlock_types.h.

