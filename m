Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C875CC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 21:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3932B6B0088; Wed, 14 Oct 2026 17:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3445E6B008A; Wed, 14 Oct 2026 17:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25B036B008C; Wed, 14 Oct 2026 17:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 043136B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:26:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8FC491405E4
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 21:26:43 +0000 (UTC)
X-FDA: 85322516286.24.32D1957
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id B854640008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 21:26:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="NE/C39hj";
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792013201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SgefoZU/7a8w/FLm1udAZKNsvens6D/F+qkIP8OB5hQ=;
	b=cjpoUBMvqLhr4AsR8K9c/EG/Yt8ZiSXMPNdXCYDRmOlWpSD9WGq1hVJgYGzX7BOmRBm2wK
	3VKPq75bHIQ9DgfbN/3ADf+jrk8ceMbq9ZPBc8LmeUdKf96U53nToBF1bi/4twkcGlEdzm
	sV7fsZZhGloYyq0ok4PP1yo0wfSqCqA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="NE/C39hj";
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792013201;
	b=Re0g7RB9dtKOl+RgTW6o0l5xkHfY+I0PUyzYKtmEcsj/7NMd8wvGIOpwMHXTSfY5d+XcuF
	OY72I0M56FvOxidHDaWjoqUV/Z1Xp51Y8FdvVWRYbXINVVsKCGJuY1836ot5adTbh9RhJ+
	OjDBNdhM4PNvny66i3EidmD3MVjPq8M=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-91b8b456dbeso34868426d6.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792013201; x=1792618001; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SgefoZU/7a8w/FLm1udAZKNsvens6D/F+qkIP8OB5hQ=;
        b=NE/C39hjCn1n9JCCOoCscUIGzcepSwWoR76cTJ72L9JFya4cdN6JmvIYJkh6EDRb2C
         7a48eV3BJnp/g2CfSSvYZUilCxvQ7xgKhKlQODQXXGGdRiEiF0bnzfwfpA79seaygeh5
         jyMkUNwWdTu61E3jc7mlbtTTCUYl40KypXv9hLJvnBuP+v3RHEXGKtpVcbeL5axliIuA
         Z46KFLwWoUaLugdS0WsjyiL1wr5Ck895WL++SOyWvXtn5RQcYV6Nn6S9Kz+PQ0i+rwDD
         drJ/PIDeTiwfYS5qCNHwz7F0JAXY3hxbiuvo8eFKCEVk9Bwrtbsr4NsEQwqR8FMZDqoh
         OJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792013201; x=1792618001;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SgefoZU/7a8w/FLm1udAZKNsvens6D/F+qkIP8OB5hQ=;
        b=b6YQ1YAWEEUw2zQIrYIOMxf8mi/Y506qWUw2cGjGaPdB83I80UENdvBdY7g0M431FQ
         QNRtToEXyIszQMr/nHOjl2lqhNXHlB8awvD0/4FaRKrAwJMhWH3IWKVybk13vF3GuAo/
         eoVIDmfSZE4i+jCj52TPxojSwNiUGXZj7KD7iS9WkyV0JwCTryd7gKZ87sawhg9lX0Bz
         peIeCT1L5PbIdQ22Jvz/BXYYPp1CmdcyjTrdtsaFqzpfYVrWug+HgwzNQpCHYwipmyyQ
         5prtShj1YcQwhfDHrLqFR2BdrCKF68qv/OSG4az+/OzgVz83FesgAxYMdpU4cjxuoYhP
         1uYQ==
X-Forwarded-Encrypted: i=1; AKwUvBw98jOCoiasKxWGYfRQSYiW9PvAauShVfJWDQurDaucjKKIk8r+yhfvpGpS495+/VZBVev93hRtiA==@kvack.org
X-Gm-Message-State: AFq9FYIYZtibH2K1/ijt5IfAMr47gWEO8ZiZOKuGdGEhtNRD/zlXzlIA
	5JgRGLApcBfU2t4Tgl7T1QMne/kplXHFengC7J/o95stI7xhiXynIPnCyNsyR1+bnpM=
X-Gm-Gg: AYBFou1pT8AbPYBNh6664OTC5s5jnmi/0SaZPrdcKdS/tBnPnHI91D1z3BUV+xPoAJr
	8W6AqtLm5JRcDFqKoj+Fy0RXnTnWhoSNw7+Qq3sS1nWZzLb5ADfnangoNfQRO7nSi8Y1F3KOxAB
	6REKDTd9ZJ5vytF0JFqxawyqNXNLmHzhTpkiJE3W4SJlolwcQoI1Z65tArPcyiea6+FsDrl6XG6
	tQdxeYrTvP9Au9i7v57fYmqOOUFaSLsGVMrDl1yjmjdqp70XDdz/I0C2PCc3MXq2zvKeneeIT8U
	7ORLw7wqiT/j1wQUDn2DF0dBR91UVRSENokNv3kFyiTdNreoOc8OFjVsE8eMRSuCzqxhSdV7dxw
	vaHj8+gxFuxhSHQho3Lafc1kO9yzUx7OcIFzS10tu7SYgCSv4c3Fsz+whEh2KTslvPIFiLr/hVi
	m2O4ZsGl6/kSn107NgFb4FEGoXfEHMa631ByOTUgvZ91Zzu7vXwTBKO6hlnNk3ha/3cFOIDMZQx
	JwwWqKw0nq+agXlqJk1o04HqEcGstHMtHc9oLf3J/yoK9KHGpW3COo=
X-Received: by 2002:a05:620a:40d2:b0:93e:4d07:14db with SMTP id af79cd13be357-93ebd1e0133mr2853002885a.24.1792013200873;
        Wed, 14 Oct 2026 14:26:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b95847sm62808216d6.32.2026.10.14.14.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 14:26:40 -0700 (PDT)
Date: Wed, 14 Oct 2026 17:26:38 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	shuah@kernel.org
Subject: Re: [PATCH 8/8] selftests/mm: check that unauthorized MADV_PAGEOUT
 skips large file folios
Message-ID: <as_yViNexNHzdD7l@gourry-fedora-PF4VCD3F>
References: <20261014175756.2035176-1-gourry@gourry.net>
 <20261014175756.2035176-9-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014175756.2035176-9-gourry@gourry.net>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B854640008
X-Rspam-User: 
X-Stat-Signature: jzyzcbn76ya5omghsj56594ii6kyznxy
X-HE-Tag: 1792013201-267849
X-HE-Meta: U2FsdGVkX19eX2on56W2ywCQR4Bnf/R9G0CwmaMSxz+QvQZ95zbx2ruu1tnnLBUkY4X33gq8TcrW3UHPXfDeMJwR1MJ3Sn3Z1b1A1fwPMBwrhiFW2D8WgaSe6w47Ly9+5ZFQtOFk+kkud8rEqPb7XH1RYQGAeazrSCc3pUHLBrBuy3dO6cP9h308Ef3XMNzFZStOQxoFRc1onqD1uW5tpJw1qPGn4FD+K+sEDHYai397IGMhh66IpfArBr6+IRNv9psl1zCC+bPJCs6xx9qSNt+J5LjyD25gwlC81M/iCnJQCp9hNVxvnTUt+mB38fe6t12sBYd08w0CDY67RiGQ6NIn0FGM7R8ZVC/JZ+9HeH2MxmeuORZEVYAizBlKpTb2+IkVj5vuZTzmQckiOieybbFCU46f5V8wHtd05Y5a659HppsGl0UMECXkaqvXhzr1Qv/nqY8FWaeUB9qaEmYNywK9+CyXVxvad+4uIIzu94qac4bNZchZysujvyyG12EYijp/evJ4eg6JJfY0iZxL4JTeo4wKbJRdhSu4SzQvyngoG/1gWEjm6I4BRi2xgS+PLkPDLVpgfoTU67KohJ7Vo6zDBsnAzoPnbbHsxG3Zw8vmeQY3xwWXUTUI2oUoXetJcVLqPWZjlpLLctqg7ozMHG1xyz65tnrNG6D+5r8Js92J6r/9QF/M7AEb0S/2kkh8gMCZCbMyavRoftaV2P0Db7dGQefsAY1yZ8IG/zYLZd/mNmZoUIRrVi5pulC/OF7N6AuBBPBojN8OzVTPxs3Odq8I/YSVLeM6HRp1TYmlpYZlDGbSgnsbMTQM8iWIpL7/Y0fwRfiVbeInngV+k/xz7b9bP9Yub1Ig14yPtNaIv7R/Sgp3qepVEQvGMkOSet0dAJgoFFkqnpTRjnNVz5gkIeaXRDr79pHx/QSvPZN594QlXUAYTAJDFX8tmS4rMwGmuEeNoKFJeLcTer0RMlJ
 JLrX0Uv5
 9u22TPjcuuM+nfeQ4WE5remydtX9NuF3Omjh1C0X+FJ6jvUhF+lcKKKeUSDvxFEziOdrRljnm+z01HII238ZmiMXYwD1Icb/45LdcRDVyEDPpl6a+sKHlgwPEwGiyWA1pA3nCu1WfF2iVo65nRfjFdc5hiFIpWJm5qHapyTbQSBT0hddALtWbalh2uIGM+j4d8Xr1WGEK5rkXik5qkcidwGoWkpA5I96dLex2ZA+anGOpqXTs1ytshA9ezwX8qlsTPlhrbs1xwzHcz9/j/MOI0fX/yFQiKiI+oSZuIcO0+uUQLkg5qIbAQMSDCUbPIrA3vOoNKd91nFHQbcO1QqptZ/S6osRr40g3cvALiUKy536hjhbAJLwozqTduKN1eYRKIpHr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 01:57:56PM -0400, Gregory Price (Meta) wrote:
> A caller that neither owns nor may write a file may page out the COW pages
> of a private mapping of it, but not its file pages. When the advised range
> only partly covers a large file folio, the folio must be filtered out
> before it is split or reclaimed, on separate paths for PMD- and PTE-mapped
> folios.
> 
> Check that partial MADV_PAGEOUT by such a caller leaves every page of a
> PMD-sized shmem folio resident, both when a PMD maps it and when a mapping
> of half of it maps it with PTEs.
>
... snip ...
> +	ASSERT_EQ(madvise(mapping, pmd_size / 2, MADV_PAGEOUT), 0);
> +	for (offset = 0; offset < pmd_size; offset += page_size)
> +		ASSERT_TRUE(page_is_present(self->pagemap_fd,
> +					    mapping + offset));
> +	assert_filled(_metadata, mapping, pmd_size);

Sashiko reported:

  The commit message states that the folio must be filtered out before it is
  split or reclaimed. Since page_is_present() only confirms the pages were not
  reclaimed, should this test also verify that the underlying folio was not
  split by the partial-range madvise?

I'm fairly sure this is a false-positive. Splitting a file folio unmaps it
entirely, so the page_is_present assert would fail.

~Gregory

