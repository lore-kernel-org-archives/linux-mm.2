Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F1AE606A321
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=uNW+pkE5
Received: by kanga.kvack.org (Postfix)
	id 8495A6B05B0; Wed, 28 Oct 2026 09:43:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821746B05B1; Wed, 28 Oct 2026 09:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7108A6B05B5; Wed, 28 Oct 2026 09:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8E96B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:43:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BD93120C6C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:43:37 +0000 (UTC)
X-FDA: 85372152474.09.23C3497
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8952680003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:43:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uNW+pkE5;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793195015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Gj9UHjLoMrPL2uz849IcayELirXOaA9Tos3l7jEBBQ=;
	b=bZhInxkZD0xd8LNxF22v2+7qo4Pgz+GjJshbUaSMM7d5tQkcKaK3UWnyOF/iJ/Vg2j8SzO
	+BcdKoBDWpJspt/eCu08nOjJo2ZsariP5QoWPvD+jPIYgDW4yf9Dr/++/6bah1Hb7Wmj8X
	dFvt/CIxaDbrbPkG/gTraQ0AeTfJFsg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uNW+pkE5;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793195015;
	b=27g5XlksVwh5Wl6wNOVGu1Xooe/GIs+KD4C54+E1JzkeESorjc5QYL3Gg9hgj5YoJ6t2dy
	r/eO6s2EeMx2jcyh7GOYKBqTTwa0h3bKvfKqCGOwQuReUdON0arTE4ewZyNz+2nONhJkod
	eBPvyeB+THH4+qvL8PDJexK5/0G+aqY=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-93f1e5d7450so81177485a.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793195015; x=1793799815; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6Gj9UHjLoMrPL2uz849IcayELirXOaA9Tos3l7jEBBQ=;
        b=uNW+pkE5TryWMSOBgPcMsSGIQZ5uQq1qUeZt2cSP0PqqBW8UaZh42B0jnA80BRqTAr
         v7Jm/4NiK30RuSYcKzKq5CjZ73bRHaBqQGrD+OxqzSJfUK6qmiGrBY6qDz/5GwWEhER0
         +K//yR1SHpew2I7u+HWBMS3d8z7X7v2xXB4pf3M4A/d7Kf4NP2HsMLKF/+8EbGTosvel
         GXNcgdROO4dbb+rRvtBlxEv+0c2eQ5RQOVpCSlRS0hrO/Tc4PS93iByu0fmTSD3z2pPW
         5Cg6i+pFvoJ4gwHRAMk7CvHdLFefOgyFLy45NbsEePgZbK3r5FL9TcdSZmRpQ7CaGBdK
         njOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793195015; x=1793799815;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6Gj9UHjLoMrPL2uz849IcayELirXOaA9Tos3l7jEBBQ=;
        b=g96pkBJWxdjq+mpCNh1Bc6SXC10igcMc0z983RpDTuyWLXNgjXWRlfDDes6ndr4Jb6
         Eq2SaCsylVpnHi4OT0pscNJkOLG38PlQUDpNeE+Hoh+xY5bEzUWksAmxWlo+LzgZkh48
         eMIcXvroAehajZBbDr+G6gR9UbO2DlLYPnLzEd6BTLpR3W+beDT1+PfAmIO+fKxt3wSK
         gzu7mQxitiLOpd+ADPBdvNGFA8iPUu0AZ+Wt4uTUZ1yZFc2ZS1M6o/pPARR/9ovu2f0t
         g3GOpYmHDAwQw6oUYSDYe5u0nPZzSk8S6Ex4JPb9mi2DZ8UbNcPFf6ymwXWUteRM2sOX
         hLHQ==
X-Forwarded-Encrypted: i=1; AKwUvByj7eheqPdXRUWsEhejNWdoYoolRMDiHjpB+tYCB5cUAXQxANNWyIVZwbJ9cYMiz0XNA05pppwOXA==@kvack.org
X-Gm-Message-State: AFq9FYKm2rgQ1jMCQZnTAoy7m21N4B7tdQ0j4llxEYzeX9TSCL7GarWs
	lMDiKsHNcCUmIdlnV0lDBdxtZ4hfknjBoteNxrWsq7tNwQhZhebepaopFqrPYYtSrOc=
X-Gm-Gg: AYBFou1pNHo9CVKizN6agUskwQ54eGmdQwIwuA+27JiMe9rSvxMXFNdwZZIR3hHKQTL
	cNZ3BSTJsExTpzdN7/Kc9iZJtRKmht/eMHBx8zxrw+zAO6Bd5vYDwOHp4IsgYreUnp67d5zjgVP
	Dm4zD8FbqxNBQiL4FVpibCuyBv1o5SW90S50qqOjyz7winK4HBIaNR75UtHa0Wt+mLC6TB3+2AT
	Wexr9dsl/QRkxptd5aDFte9TGQjS0Wwa93DbsMxMepk3JzVoaMAKiBpJ0Ghj3UkVnxf/O9998nr
	NbFJrbSMjPLgOf4lcZzXYBPwxaNA5+Cy21S3fi2GDjYfJICURP0CauO3Bn54sOnXAX2VbFzb+Fa
	Vz1nlAkMSZ7h0Jqaxnq556n4hVnFiupCxyTh7jduryzRtFtw0J+Z0+bxLrq3ipPpJXESG3ny57V
	svKPOyPGrGndwbwy6y/1ylKfrTrwh2kB0FshZMa/6EwFUsY6IkGJOROoNT1kBEWov5ckqlmEuoR
	mPDCft3nzZFoQM2fIMnoNFosG1OgiRnMRoxBq4fRvjPICEQzff3exA35pPCecNh0vTM3VUWQ/7U
	pzOKpuhUUmQDTdBrkCz86RoW4KiKUUeGMfh8KZVL0m0UyaDewEtl87yVqttob4UJv0X681nWXva
	p
X-Received: by 2002:a05:620a:4044:b0:940:f53d:5eb with SMTP id af79cd13be357-94408ccad65mr342537085a.35.1793195014674;
        Wed, 28 Oct 2026 06:43:34 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47a6bff7sm131382856d6.5.2026.10.28.06.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 06:43:34 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/7] selftests/mm: add MADV_COLD and MADV_PAGEOUT
 contract tests
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
 mhocko@suse.com, shuah@kernel.org
In-Reply-To: <726ac203-7ee1-41d1-a9f3-7322c7528971@arm.com>
References: <20261019171206.3331374-1-gourry@gourry.net>
 <20261019171206.3331374-2-gourry@gourry.net>
 <726ac203-7ee1-41d1-a9f3-7322c7528971@arm.com>
Date: Wed, 28 Oct 2026 09:43:33 -0400
Message-Id: <179319501336.2032926.1556159871121015337.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 8952680003
X-Stat-Signature: ppqoxfxbobtjhhtiz4wrnk39dkk8h41d
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793195015-978325
X-HE-Meta: U2FsdGVkX18loGH5/5DskDBwXbhS+FdM7PrJKW4tbJEmSQorY1xOM/X7gtunUnGjsAsTiaTqzCJcX8XRAnOAkiN55wRxjWN8HuhrWwhTmB/kQJvcDx6mOfVayWFcVWBrERRz4xuxcS+V/etlfdkOQzWAjBmLXrFN82Qmn0Hmc0WRr4lEpwxh8FHUHjJTsAl6a85a2CqrAsno0ZkwoRszVmUkrBn2ElBYtmzRFF9AkBqxMmC349N/m1mB9u8MIf2F/HczvMCauoHvNE2vwvJx/NqcUJyqHqU6VDmk8OEUbXCvve6rRBjyCjPrdy71uDsxpuHZZ5180kCryBX/T5SDVI3AbPeQnS/EwAOy8Vw6loEGVq3TriLhA64FRMk6B/pnVxkDTjVjuomGzVwEhl+gOhltM4cEFA2rciyhHWH5xvGMWVV93MxX2RyuGiRNXsoRig11rlxNNwIzPZA/dgt1SlXgQop9KdTw0zYNdSPrzoonDX1l6rG4HuJAOWQJFidBPJDHPNicurB74c5Tc+ZqQ+sLiB6Z+j5CCS4a7wsI/q/j9shyPFY/oK2TlnRK6zswDI3rT7Mlw8xHjFdcriCCbJp61ti83cVx/6SJeYUSEJcJ3A+7cFo8HddkPDIP7nLSPlf8YgjO/qaC/Aot9o/M80qZEtYfQJdacf7IguBcmj/x1hoZIVp88sZ5epU1wL8AZwYi7Vb1CJmENpIbQTvGdwvCtTviYEygusamCqlOzVclIHZMPfl+PXdOOqQC9JGvSATM3K2riPMqzKLOie0QqqEElDYF0bsOqYfPV2wpyY8ACHAy8KzoEwJNw86lkMdlW77JRiGQ8vsVh9Nll+W8RS1bka3LqJxXCO2WLhCaorfusxNbEXhqSpU6Bl3z8mUVLfuZCtUaDtwo9CkNGk5uYa/HtcbGcpmvXu1Nc9ma17Vq5D6ZgZxMV1axUn7HZyG+0Q5KZ2OPrLeudV/kW4J
 ioNk5ODF
 9Go2nOrn5/vn5cbi1/MAEnPUCo2nkc4cz13GiBQYPO+bd/V3p2Tz3tm6sOJHtsSu9eTq+gPpcyJe/YuDTnnyXwKPYlRzm10SwNoxJZ9dcm0RbEsmyMI2QZX9KOlrNymHgrlk7I3UzudCD+Jf/SdFQryIfKk81xJepSdbySg0iIvOq4ob5TTGxDCw2iUpJCuGNAKr5ChVRRmUJUQxzIapq2ZiHjoSeM4CACYimFRaUZ6/jKFqa1EeV593uMmJ35GKdFbAQf9AtPI50oXFiI2xz9s/AYg2R7x/m2CPg0qoCxVjubxRLklE9vlrABt28YIVtMTD+IBSucNfBFqlHq9Sgb09fg1oJ3W5NDtAablh6TVE1u4U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-28 16:52 +0530, Sarthak Sharma wrote:
> 
> > v3: Dropped Sarthak's Reviewed-by from v2 1/8 and 2/8, which are folded
> > here, since this patch now adds main() with the CPU pinning and the
> > one-time reclaim check, and the swapped-page tests fail rather than skip.
> Thanks for changing the name of the selftest. Adding the swap check once
> in main() also looks good.
> 
> Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
> 

Thank you for the reviews!

-- 
~Gregory


