Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB912C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 11:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 808996B00A2; Mon,  6 Jul 2026 07:51:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791A26B00A4; Mon,  6 Jul 2026 07:51:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659F66B00A5; Mon,  6 Jul 2026 07:51:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0A06B00A2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:51:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC39740389
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:51:27 +0000 (UTC)
X-FDA: 84958186614.03.A55A7B0
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf12.hostedemail.com (Postfix) with ESMTP id 18E7E4000B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:51:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=kpbD9rWW;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783338686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6OBy2qV7OhxuEEHQ84IFkBzFni9vtbgA+AFFdLduRZk=;
	b=R86TuY5pzPwzXxZQBo71iFcLqQoDJMyQOGY9ynE9uC0jpEyN5XqMukhXGO/klKAlQriFae
	YJtw1LhAQjZlPksJl1Z4dyQRu+58f4JATn3ubdilq/Aty5JSOFf0a3YzUQriLRoxX4n7w9
	iQz2zz16YHBZOJjPCLzrTq0V/JFRe2I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=kpbD9rWW;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783338686;
	b=MydbDO0pXWEFMdoaExIKcvM90yiOJ671ZMtbPuCbzOIQIZYU+RT2GXWGUfIxjZwWRxIFAo
	XfjZTPv3EuVyaWGGHhUvPcuwWxduqI4IRUGpvjpyVJByqX9wOa3yWRJJTpuuAUtBMWRTJL
	itJs+E8ImZY0/Qx9xfFEu0NE47jkNqQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783338679; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=6OBy2qV7OhxuEEHQ84IFkBzFni9vtbgA+AFFdLduRZk=;
 b=kpbD9rWWzHm2q6czx3/0OGbHfXN0YGr1WOkyFcfpK2lJv6PDcxUOGj0P9t28rRPSlvlYqo
 9WWeNVlmAA+Mz941xj7ukjYfdJzlRk4oadYU81l5CWZxBtIx9NpT3qPmguXrdpG/+XniLb
 zcuXvMiSjsT1mLnfmTbVHVlCGRig94nBrDByMXRdoyZN8Hj80hhIgr4BpcjmoAYN1CEZVs
 Be2ZHE0IX4L2+04gduQFtCSM/4YRWjqTHvngREsQAbK9eDJaTGVkmpvobf0e5h9Bx3JjS4
 Qqp6t1NPiCRzRu5OYA57wXwkY8spZ8rXQhB0QolYWDtmLsGjMQzu9E+PKlBrfA==
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a4b96b6+7f6888+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
To: <david@kernel.org>
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <kees@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v5 2/8] mm: factor zone-device page init helpers out of __init_zone_device_page
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon,  6 Jul 2026 19:50:35 +0800
Message-Id: <20260706115035.49813-1-lizhe.67@bytedance.com>
In-Reply-To: <38919e81-4c35-4e8b-ba2a-8af8be60b0b6@kernel.org>
References: <38919e81-4c35-4e8b-ba2a-8af8be60b0b6@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 18E7E4000B
X-Stat-Signature: x55jqb46sygcud9nz1po1czoiyexn1jz
X-HE-Tag: 1783338684-325000
X-HE-Meta: U2FsdGVkX19IrAqNdJuxYPvdsRd/M79LB65YkeHTHmoUTpRb88nHYYB9EI3e7SW/idCioBM2IG06+cbkEjNlQezD8C7GGfDmnZugGK50oeNIezfnXvgwiR8AB0NhfHtXU+/Gao+uZnWDQYFnagHh0zR68NanW3t3LAHFy9uw0s06gnToiszCXX85Ha6id8JNr9Pu66tWQdTaG6g3hXUB0mX2kurYT8v/OO9AdKGYThmQkmHSDoNQGt0lyQya3CK4lB0v74a6WoMsNLf2DlMPAcDCmwhyOoextyz6cyBJWAaY2hlybU7lDzEzYZ9/SgnVJKh0R3As2P6Gr3HmTBD+PQ1rCjfPRwo7OOqOelMLdXgv7yNdSHKGK3Z+rrrj0Z71n5+HjTJIkhXUO+3lreBz9l83o6LE4QiRJnTlz82lJIvr5t98WExEnW6aL0Galx2Gn6vhIG0WoMdWxlkLxsyG/hSrN0+ncDaTVn8sAoMNrY7WRxcwTOoKxFgWNmcpxrsrFYAEzwBtWJWBEDrKllZyQpIO3mv7i5102+zDsC2VPinIktseShdowjpqxW+oQ5Ke8ZH4Bz9zFx4Dj80HysBZRIMEZNjVmz6hJAZW/HmObaSyWsVJ4vA7CvRtixGvxckM9F/ZdKCVR06OiQTa8pS8iqKzjiPqIivuO4vAW0TfyzndzJF1U9Ut8rKNy67gs0JXtlHIE8LdxoEMzQc+NkLp+uAn25V96y16PiPT/MOa9OSNe8Fw1iyeVYxkTaDP3eTIR9G/cpXXBKuvxbSl8+8YDl7YBi9V/3W/c91ak/Ef1RTa3z4ySN/374TwmpypLBotqn5kuULaTjWvPX6BTrc9b45XfT6fyWgQS/Tl1yiuu8gB42phy2fa0sMcE+IjU5TG5APrTZgoHSeGL/2wIIPvyp0lTliPOTTU8HkbMyP0JISKGjcmLaaKsKWGKIb45YX9jhi5CVS14lt/xWCPdg8
 wqhwOQ1H
 A1fNMhuoZMlc4ktCgPZ1q+onh1EKX3HAuCNCcD6KRUvRJ5MdUl/Z6CeU2DUKG27q5VgthAIeyANl63S8GNFXc7C7hC+yZzheoloF/OWwm8OTycfcG3u/wzV6Tu2Pj6wdUoZU1fHWJdgxAfYzLpcdS8B/MsXK5kz40sHylEOJr3vIzsb6gR4bnkoYzlU34wniv6kzLIlfa9X+B2WpPwNl+6ujMPft444vSJeeM1TK00BnipDGg8BYc9qlLugqEDToxWwLnxDWhj9jAyQ0d4JMnndYFedEPuKIzFEE186E4WHVWHweGXuMgdxW7aQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 6, 2026 at 11:13:45AM +0200, david@kernel.org wrote:

> > +static inline bool pagemap_resets_refcount(const struct dev_pagemap *pgmap)
> > +{
> > +	/*
> > +	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
> > +	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
> > +	 * the count again when the allocator or driver hands the page out.
> > +	 */
> > +	switch (pgmap->type) {
> > +	case MEMORY_DEVICE_FS_DAX:
> > +	case MEMORY_DEVICE_PRIVATE:
> > +	case MEMORY_DEVICE_COHERENT:
> > +	case MEMORY_DEVICE_PCI_P2PDMA:
> > +		return false;
> > +	case MEMORY_DEVICE_GENERIC:
> > +		return true;
> > +	default:
> > +		WARN_ONCE(1, "Unknown memory type!");
> > +		return true;
> 
> Wouldn't the compiler warn if we would define a new type but forgot to update it
> here? We're using an enum, and I thought the compiler would bail out in that case.
> 
> Or are we scared of some other garbage ending up in there?
> 
> Apart from that LGTM.

Thanks.

I will drop the default case in v6 so a newly added enum memory_type
value is easier to catch during build review.

I will move the WARN_ONCE() after the switch so we still keep a
runtime guard in case some invalid value ever shows up there.

Thanks,
Zhe

