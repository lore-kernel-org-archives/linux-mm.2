Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7476BCA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 13:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5656B009D; Thu,  1 Oct 2026 09:26:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C586B009E; Thu,  1 Oct 2026 09:26:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C9156B009F; Thu,  1 Oct 2026 09:26:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE2D6B009D
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:26:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D81DE40400
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:26:09 +0000 (UTC)
X-FDA: 85274130858.30.F517546
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf11.hostedemail.com (Postfix) with ESMTP id E9EE040005
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:26:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SmDpcrus;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790861168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1U7rCP2J1UR7XvChQyXqCJWaXLGRfuecEUSlZ8WyOlk=;
	b=qcetf7kINz09kqP7cWTx2RsXvQSCxbQuhWDZPBhFtvwe3IZyh/ADirQiUBs+kXeNKtT9rx
	VOgPaR9VzpJygTeEuE4gTQSQQ5dyUf4St4coAf73qR4xP4C5f5zgqgs4FpRUixqZC5KUXJ
	yIWBH1hjodI8/ETSvsnGOuwpPGIWVAM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SmDpcrus;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790861168;
	b=c/fRDlOtpcaLFikyzyt5ahaHtj70pbeO0Ke3sB8naY3LM6kD3o/EDQxP79LnsUrDxNP8OL
	ZhdxofV5d7uCi6MRaO9Mi8S4atvc1+zTR+PLkiayZglunlRKUNFsY/+9fW+IMvhwKHv7TK
	PB+U5gKDx7vrDuozn6Xf1M+UAaAdO28=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ce364488dso10718615e9.0
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 06:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790861166; x=1791465966; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1U7rCP2J1UR7XvChQyXqCJWaXLGRfuecEUSlZ8WyOlk=;
        b=SmDpcrusj6QtnVCfpb3Xpb57JlYtaGr9lthEEEIMk/jzVDPr8ts629s8BLuhTXREg8
         XA4t9eziLLJJe1T/SoOguu3WjMLgCYvX2C2PgrvMpD4oM4CCMsxaaVbiUcLTkOs46E3b
         32+DTCIU+pQvguqXtd8IiCkqTH/jlbXtGmWSDrsuARMnHvU559a6EMPkWKocdRXnpdWo
         ciiwvThFlz35JF3nQeKPfOAvu/yWr/vELohoJDmz0N2DcQ6Pik2sDQxfc7tY4W1EPiXu
         GyKKE1y5zaNzRg4wu/bpYhMBhJmylPXNbfC0jm0U9H9hqqTBS8TZjXEzVVk5wxYwkzrw
         bVMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790861166; x=1791465966;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1U7rCP2J1UR7XvChQyXqCJWaXLGRfuecEUSlZ8WyOlk=;
        b=Ij1EIrnAtxvim3qohqGKMgzb/Bom+Y29jFnhMBdnvSXwPO306dFJ6PjcBk5CCVPiqm
         hmkaKe6gLfPeloGRl+ByUl+Iq9LaNagmV7PSqkKaHazRcNX90XkPbsylmfCNes21zNTV
         EdTvjaTtesLFNzEiFDTMmSmM5oi//vKirICNtTS330JnIhMbrv/xk4674K7Eh4MJdY0q
         2R3YknCes3R3HzmA/Nh7sZ0TyIPSwR7Dr6El8DO6ELVYbXUBI0K4Yx2nAN/aFZSrQS67
         YfYpO6sArVqfIG64k0MSHPNtMc/IXllD6Ak0Vrf8brEVh8Oj4XB92jZl2SXv4G/53av/
         ndLg==
X-Forwarded-Encrypted: i=1; AKwUvByJRem4R943j6fY7t4gPwaN5EPSyK4j51VGM7na3keLa3QD2ixHG77YxAW/LsV82YNH5+qqx/z3Wg==@kvack.org
X-Gm-Message-State: AFuF++l1Jb6fdoFCqrzVujJocJPuTDyWdjDRtwGYnGE3V4DaUkGtBcxp
	yDKydDGCx7ySLG6i86m0jB8H7zrPVG8qludTkkMfOymcOHkcWOItdmLuGsuSGvHfRYM=
X-Gm-Gg: AYBFou0TXM7mnghANqP9sVmdVG+KRnDVvenSKWHqggFXN2fl/c0zHiYNKIutk+1DaF9
	0/M2GWCmhO/Dns2aML2eMXlkGHil9DX+PMKFwl6RkVQmgmL81+qI5TbPHUAz53Y7JvT4cmd0sHe
	KkEIMboMzw7WXkkRAnGwpCSZVd12SYEATZwkVmayQ4XuixysbEMabih14RO6uj3WyDtxqWj66Mx
	pnq0ZmjE1CH5FYeQOK3iN9KaU3NEVrPKuFi/E+cL3d/AeehFpBBNXJmsGA1GJ5GQBz8sDRXFV7l
	0W4nTw2ELrcMrXVILSW488+tlrkEZob8rVqVsHgbyIAMVDcWFxiWvbQs2HNaB431KDgU/x3Sa2M
	acsztEyJOv9AO312Hn0Q7baVZ4eJUNXzfLIuhHpEkLOIj+7QhsBTj/SjxJGfmTRp6Duu4rO+x4A
	Oi/Hq1n3GZloGJlx3HkNxroQN1hdSutR7kw+1FTsiI/klPV9Qabi4EUWI2glAAq8ORsNDAa5cT5
	pt77Q==
X-Received: by 2002:a05:600c:a107:b0:4a0:1ef1:b62b with SMTP id 5b1f17b1804b1-4a01ef1b7ebmr36180515e9.10.1790861166322;
        Thu, 01 Oct 2026 06:26:06 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::6:7dd1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f93ad0bsm47435175e9.4.2026.10.01.06.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 06:26:05 -0700 (PDT)
Date: Thu, 1 Oct 2026 09:26:03 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Li Zhe <lizhe.67@bytedance.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org, 
	rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference
 with MPOL_WEIGHTED_INTERLEAVE policy
Message-ID: <ar5eC22VfSFlMw3W@gourry-fedora-PF4VCD3F>
References: <20260930121154.687586-1-joshua.hahnjy@gmail.com>
 <2e3f12b7-0dac-428c-b70b-07e1f63de028@bytedance.com>
 <ar0fURbLDPrphYMY@gourry-fedora-PF4VCD3F>
 <A005B05D-A85C-4153-A65D-0BDF9D8500DF@nvidia.com>
 <280965b2-c6eb-4f01-a0ac-c4fb7e518f97@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <280965b2-c6eb-4f01-a0ac-c4fb7e518f97@kernel.org>
X-Stat-Signature: 4iyo6j5nqqi5td1b379kkou1fknj485x
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E9EE040005
X-HE-Tag: 1790861167-659603
X-HE-Meta: U2FsdGVkX1+k0tp2Dda+2YkdlsiBfEPzXYogZIgVLvF1YQGrQva9T6t0FIqFxyYlt2ge1H4HInLpfpCKkJfgdKPK8S2KJeinvIXw5d2qcPcaZciUHrpDVkbwd8DmHF2KlL0OrBlBQzsFdQj+cmhsFerVkadCg4s3ozm0dcdeyscHn9qrUCd8ks8mE3CrSajDAebvY9pFB+vMHncnLSR2MrDU0xX5wDXTov+5naOA9caERs0zBvRtoE3HmEG0hT/1Bw7gDAIRjHIc8SKNJy2fqbwcY9CDL1U+b/0ttlHFr1c1f0mbwZp7ziKQSNw8SXJ+t5PliCejUAfJh0sdjvXU4F2GNiNGT7DdL+jpCRUEZEC4neIN/rVs5T+zTatDdVXKEFRLOyWdEW6BwXP1mE37+oafgt4OCVDIDjNQS/1KZdWV2m8lzEXHlioohSR0Nk3Hej95+N0wCyZ0RGOHLcMvF8X543kU2LYMkUBUU44s2xO3bMegfEGodv1yKhzfiwjaITndNAfYUpViRdTvCIp+Igb/QPPFtDKgOKecXwwxM8gZV7sHiCvsyVnMuukiKnWYXuNROrXsNbNafZ6GLTR8e9jD8jTcdZGcXBYHC/Cj0FrFj5BM9zf6J0R0yGM4DoatFaycKGmW9mL7PYG1lergAAI+Q+m5BvqNeq/WoSPdOjdQS9p6gCE194YZ2KLcCC/7e4LAPAu9M4xewstY6B7qThVvBA1+bjWtwJdSpXH6koUnBWqSzLa7v3tJM4V4l9Dh36XBu9TOjDrDxqb5Zyc9XQHlZl+/13f/3bA9bQqQ4phPViFX0ck7yyrz5lJFK0JTrzv4CV4Xnznj/BcnLt+Yzw3+Nl6xSTUk41Qw914gh5End83P0SUZwB7e5y+wcJMZhMqMeNsR37QGeV4LGmuUVFuLJYnFUWSrjpgvFp2ckWNDnWe5G5tOMfkV+WVnAm7u+dFgoAGUDBdnXR9xk/u
 jdHVMOQz
 WxGnNASb71itxsH103jNUPMAdkKP2fefpyTtU2Q+OI0xjkGp4ywRfEIJ/Ie1s2r7b3NDjJtBXEUqhuxr0Zq4rfPgSnLY69/GRX+7TnKlD0mtvU90TjnmNhnZBIHKKr9B8SJA4ymXhW37iOzXJCTojpNCQ6+b1qm+WhRgI4e12BqlbLN0vZ43g+Va5rfhHCnYwOyJgWzhO0AnA8dVd4OlTZOMZ5Ac8QUq+VItn+nC/6R1/9mI64ZoFu80Wf972g+Zv+KfNbXqno+ION7muuVY7yMpOLy44MWgDoqaTrybJa2OyI9M2f39KHa61tJDh0mdmgVRyAOI73TxD0OyoGq5fP/M04EptRUkSBSSZ0isoerT6iS6w2ayYM+PtxtXCKufShiE00K5bv+lU0FZgNznzv/3owkjvmkkPnP92Sl9OcR799zckdR/kJ9UzHLjJwDTDZLD495yWo6pbPY+WuVu9d0JUUHi8WjMj/v17ExJhji2I5/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 12:54:22PM +0200, David Hildenbrand (Arm) wrote:
> > If this is a initial-fill problem, can userspace set weighted interleave
> > initially? The program or harness can observe memory usage of the program
> > or related NUMA nodes and switch the policy to numa balancing via
> > set_mempolicy() or mbind() without MPOL_MF_MOVE after certain threshold
> > is met?
> 
> You mean: use the weighted policy initially and then switch to a NUMA-balancing
> one which doesn't involve the weights anymore?
> 
> That makes more sense to me. Although I struggle to see why an effectively
> "let's put random memory on slow and others at hot" is a good starting point to
> later let if be fixed up by actual balancing/tiering.
> 
> It all sounds a bit hackish. :)
>

It is a bit of a non-combo (Nonbo).  You're using weighted interleave
with the intent of spreading out the bandwidth utilization (and maybe to
offset some reclaim behavior? *shrug*) but then undo all the placement
with tiering.

But, in defense of the hackery - I have seen strategies like this work
to optimize startup times and then let tiering optimize runtime.  Phased
execution gets funky like that.

~Gregory

