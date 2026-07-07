Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5108C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8A9A6B009F; Tue,  7 Jul 2026 02:36:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B9E6B00A0; Tue,  7 Jul 2026 02:36:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C531A6B00A1; Tue,  7 Jul 2026 02:36:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C66E6B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:36:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23B51A0308
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:36:59 +0000 (UTC)
X-FDA: 84961022958.05.E6812AF
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3D94E1C0007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:36:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=AUjxQV3L;
	spf=pass (imf18.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dHcaoSCQABHmb9XmVmdOyeX7FURk+lYNsEghSRHaptg=;
	b=o6kAE0rXUEQ8LJJqNBK1OWWIg+W6/rv1+FalCsgbeo2h1CZQgrvOJYPa4i0o7W1OwCxIIN
	gsQXvs3RI1VonMR8ey7bW9zK1CWMQiyqlu3Om/nVQDj+d0l2NYP73kufLRl8UVau8E5P6E
	sRY4JSBAP9lJuXX/oRw1UPQFtSJFOIA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=AUjxQV3L;
	spf=pass (imf18.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406217;
	b=qro+m/YW+SmVZSzc+MpLkqOgiPnMd7LXF9GHq5SStmVIjOs2Omsa5SpZj6E/i+YMHe3DCc
	oacHxF0dCUOrQqhyOqeAR5N2/sJ1FibzGQCVsVamMxgAxCNAkJliWshA8ckH1hhCIe/48I
	YzPw4MS0Af6x7pOPXmIpjHtf8QHxmwQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783406212; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=dHcaoSCQABHmb9XmVmdOyeX7FURk+lYNsEghSRHaptg=;
 b=AUjxQV3LjSk+phBxXAT1ebvfBirIVVbys7R14lG+hshrzgeUj8BNg72P/xoaxwrnTDt7QW
 04g5CzP4AZ8mIQUpaGT+dvgGlDKTu/lTxGwhdY2t+RTEEEIQKAD4bTRtxL2byd3NLKGICB
 FJ+bFRUY8kIu+6eoEmd7wPnKZ+qnl72qtYxjtr88fuwDn+tu9gUFcTAqHLOpmiLn8QJfZ8
 +OAshlke0WgTvd2Jm+uO6gz/srX0iO25yeVktt2+t0WCFz5vPrnAFMnj3XX85iqq0tqzMa
 0tGCum2a8HKA7YRBj2kuWLUdb/ufz2yAjH9cnWGDKIFRtrxpUdd5yi5zLPe+BQ==
Date: Tue,  7 Jul 2026 14:36:29 +0800
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
Subject: Re: [PATCH v5 4/8] mm: add a template-based fast path for zone-device page init
X-Lms-Return-Path: <lba+26a4c9e83+591931+kvack.org+lizhe.67@bytedance.com>
To: <apopple@nvidia.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <akpm@linux-foundation.org>, <arnd@arndb.de>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <david@kernel.org>, <kees@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>, <x86@kernel.org>
Message-Id: <20260707063629.40360-1-lizhe.67@bytedance.com>
In-Reply-To: <akxsbwyfYH1LCyGm@nvdebian.thelocal>
References: <akxsbwyfYH1LCyGm@nvdebian.thelocal>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3D94E1C0007
X-Stat-Signature: iu3kgw4mpuxwn3iw9ewz38qfpu8z9s54
X-HE-Tag: 1783406217-129518
X-HE-Meta: U2FsdGVkX19ziz92WLHzVQ7ZX3WSqQlSrxtOVZx0jv57vg85u3Q5jT4jwF5E2x9wu997E+d9U+421XUNKQEIm3DhBSSWMIDIgnwUUNkr/QxUuyxjWcOC/N2Lj+FfROux6mc/a3x59OJCAZXdr2v1hTUzbI/Dl5U9yD4nIvL488qUvnvxX53GGCtzwil0K7/F/XhSNxWRuqT+Gm0NWh+1Zv3UH4UqE0/a4G2OrYLDkhaLaAim8rv2cGUWG9kUlDJdKVfYk5NfzvL8SpvNy0Tm4pTdIiODX9TN55vlSZd1aqmnusqf8TcwwZS5vA6T/7E0wch6rK68IzchCrEpLJtmmkdIeK4HAGkxAj/KEkU6M+CtM+526KOt5qNuHFMlvLVII8NJ0hJNycYCC2hHdz9ISrVd5V+NDYLEMixeUjj2Ie3S0W3LmYWI0hTOrZsZtahiohpYRqgc1AQOFI08yCnYzFp7k3XeNacTPuDT9Wgon7jFZUsV1IpW1dIkTUKUCjli0uwhHLtrCsEzaboU1OoTZTSCouVmIyfd/6KMS/vduZDl5bo2nXCNZMr59U9T2cZ/1iQIbo2ApJDhQQ31d1p4FnbL58Kc2d6mTulbCB3wcp/kLDqhHP20Zz0qcbPAtL5kvjC5kVmvRfgBT53otIef8d2//PY8/vzklm5UImttxzXi7ZD2JUPnunrnQOK0Iox4U+sufDQL0gTIfyngGNtQXuDPPOZRYbAKnR8AVKCnZ+gB07DEnr0lOOfhsoYVE5Y1RAFev3kW8N9bFvYf+IpbwllZEQDSEbBOc00BmQGXLMJGde+wkh2UxloG8XYSXB2915NBfAusnyhcLmCFec73gfO+PUKaj61X01K2dENq6DSxt+cWM5I7J1StCx0ZDmGc1+AKkN9lLa0ywsNYf+pW+H1ozbADKi5eKeB/m0LtmCKCUUpUUIU1gUOin0GUeJ1G5o+ytJdQoBjgLd3Lvvq
 nJ0kOkPX
 M8CCMJ5UgQZQSe8XTLv4fqgXiptNVCkYESgqevoi0m9ONiKmRIQOYM9HnRrUnApsgrK0fjCIg2yFpeXsE3AAeaS7L4QcR62DOsxDS96QaEbhZOs4vQlADPcCKpp0VBFM0rZMDLgJZWtpUFnJjdiJQUdF58emm2kMLlwmigEEd+cc1Zd3taaWDNJkjJFyqLrgAAHsBsGZpI8yD/9L8cugLgoOTxCwFjvWRnaagFwmOHSZQY6nginWtmMKx5YmfTUumE2nk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Jul 2026 13:06:02 +1000, apopple@nvidia.com wrote:

> > > The whole bunch of template functions look like it could be useful for
> > > initialization of the non-zone-device struct pages as well.
> > >
> > > As I mentioned previously, it's interesting to see if this approach speeds
> > > up normal memory map initialization as well. If if does could have a single
> > > set of the template functions.
> >
> > Thanks for the suggestion. I agree this is worth exploring.
> >
> > For this series, I would prefer to keep the scope limited to the
> > ZONE_DEVICE initialization path and get that part settled first.
> 
> I think that makes sense, especially as my initial perf testing with other types
> of ZONE_DEVICE pages without altmap didn't show much of a perf impact. Meaning
> it might not be so useful for normal page init.
> 
> > After this series is settled, I plan to look into whether a similar
> > template-based approach can also help normal page initialization. If it
> > shows a real benefit there as well, I can follow up with a separate
> > series.
> 
> I agree it would be interesting though, please let us know what you find one way
> or the other.

Thanks. I will keep this series focused on the pmem-oriented
ZONE_DEVICE path for now, and I will report back separately if the
follow-up work on normal page initialization turns up anything useful,
positive or negative.

Thanks,
Zhe

