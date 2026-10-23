Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A68606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 03:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=IaF5uL9G
Received: by kanga.kvack.org (Postfix)
	id 5F3066B0AD0; Thu, 22 Oct 2026 23:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CB116B0AD2; Thu, 22 Oct 2026 23:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E0876B0AD3; Thu, 22 Oct 2026 23:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 241F26B0AD0
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:29:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E402A020A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:29:18 +0000 (UTC)
X-FDA: 85352460396.30.E6ABFD6
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id C2762C0003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:29:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=IaF5uL9G;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792726156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9uNfDtdkpMmQSCiyYsn9we+cKJrdTwJ3vYkFgm9/S6E=;
	b=DdNGMpqU/VBmetO3Tv9ay7ZYFatbKz70AIad1n6scErnJ2GUfKL0OMcVfAzsGwKW6rkT0V
	4DB1rVnLpQwBGQrmiDrqXhjth9o2lykst+HbpkTF7yDcML7sV4+i+kMRFjCZR3jKZTs++A
	30ukLnGDTC76QUMd4y3/myUCC9AG56Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792726156;
	b=dNycnXdOs0VpHyaVoVMaDuq3eRGhMyR2d+dnSMKosj5VfB5jxK5enESj0gNAyLdkrFRRpm
	ADcdp+jcC7J698pD0yUAp9UVfGZE0MIra3+Zprx/Ti4ePkk4C0RVW4K+nQNqcz3fgAhl3K
	ENaROx57avPizTHE1ovXIVFMdj7aojo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=IaF5uL9G;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-3550c917fd3so726637eec.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792726155; x=1793330955; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9uNfDtdkpMmQSCiyYsn9we+cKJrdTwJ3vYkFgm9/S6E=;
        b=IaF5uL9GL837vhlieZfZhAaTpR9KrDHlcI5exBAnhNOJJH2ipvbbGbw8TbaXbUSOHH
         bkzz03qUpwd67FZIgb3SnLcP9PsGfB27hVnJtYHYFxW502FjvWduX2seOj/RMZ1Dlr6u
         SWuVVkEP4pgKX6UVLe44CXon/xlL/8inbYLrE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792726155; x=1793330955;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9uNfDtdkpMmQSCiyYsn9we+cKJrdTwJ3vYkFgm9/S6E=;
        b=Q86D811+a4pMdy4AbirdQd5lm557N8XFBcrFO66dprV+ySevkaI/wRcnElLHk3vwaU
         tEtl+5FUFZvXs6GwiECOvUA/2Pjno/E2OoHe2UQuSStlftbDYhS6e5FzG7+CzkijuvmX
         XFy2vsY7In8F9r9r/3s3Zmasv0A7hT52CsEg1wPf5QfR1LF5HbB1Oni659gkXNiHocR7
         qux8VzqZdNakRMe7S6wixcrmgRDL/uqcQuIUgnWFFMuAxGGcOZJcO7+dFT5TqDKF3DKE
         BAzw10ytJUQqzOj25RP2MNCnvRTbLdh6dosqtncUqrhbJBGYKggPQ1TCEcF2zoxmJwMb
         mcNg==
X-Forwarded-Encrypted: i=1; AKwUvByrbmjXwB9UsWrl2pYKqtYZ6MRF4CJluIdsNtM4ub+R675FuXd/cLMB6dnIH0lZNWUVVAroYk1A9g==@kvack.org
X-Gm-Message-State: AFq9FYJs55bTBjo7WtdUBlew6akLo3DSs8RwQyOjimerU9JMUw37WqmP
	5K2vWMgNfqiV2hIneP2loSJRozF4iu9hywo/Fu6Yw66qrD042cKuWHp3lhuFhqpBOA==
X-Gm-Gg: AYBFou2jCitqlDOyryOJmHczWgoMakBbE0cEUmEZpHD3NPRrjJ9g0WBpW2DABCRwPoR
	DF4WJ1FGLh80JXpIeaDUF8Ec6xK35Op1aKQqeem6S+yKrdV/TFEV5Rrf8ypjha9iK5avJy+Tb8T
	CUkp3JHaBVA2k+wCfe7wPWsQbkinlJDSPGttLCD41arT5CXorx8xUchiVsHJtwXu4ozR/ggXuUJ
	J54/ccfujumFPmxwidSul2w/K6Obacw57e4GLncurs0CEQh2qaYXCJar/lG1RjbA15t/niyAZ+/
	G48h5dNvtOnIc236CmdV7ZvYInU9glv2vMGNp8qEA9FPlLWs3R21tyC9ZqX2OEnE2J+i2Q17RaG
	3PpDx6ljA0Dm9+Y+5T/7PrwS0Np1PUAyrTgsw8D8gBTagmVPx01ZDICYxQhpbNyE2Mtxfd4A9fs
	fTyDoI7bI3yXJU19XIouOAc11p20yCpM3v09H4fjh6zMB8F2YtGO9x6UrxFZmrAMm03RlYq4asv
	SXZOxP8P2rBtMD+S2TZjh9soi9HOX2LXhTxkiXCZjpSJ/HV4+zJQyXYvM0xd1l42Dm3W8/yTiAO
	p2pJMJTIsHe1fzosbSIZ9Q==
X-Received: by 2002:a05:7022:150d:b0:195:9228:50a0 with SMTP id a92af1059eb24-195c74c48c2mr1343680c88.42.1792726155374;
        Thu, 22 Oct 2026 20:29:15 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:30e6:10e1:f7d3:a06d])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-195e5163e7dsm2445013c88.2.2026.10.22.20.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 20:29:14 -0700 (PDT)
Date: Fri, 23 Oct 2026 12:29:06 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Hillf Danton <hdanton@sina.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Brian Geffon <bgeffon@google.com>, 
	Barry Song <21cnbao@gmail.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v6 09/13] zram: split zcomp into separate R/W streams
Message-ID: <atrTd8REbAo-OH5f@google.com>
References: <atlt8YGuSxgRb5uE@google.com>
 <20261022232538.978-1-hdanton@sina.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022232538.978-1-hdanton@sina.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C2762C0003
X-Stat-Signature: gkoi9bx54t51ajm5a93cd94de6zbb875
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792726156-118461
X-HE-Meta: U2FsdGVkX1+b1Xu66t2ECc7PLf1MynnwXXQ7IpjOz6PN4FhvChKiYgqO6o+VOvxhatzCt4VA90dGfyTPjAgHooFLOI0tuzwKY2/6PmbYjLL8y/UyOhBnKfXKByXQZxk3kZXI47iJALiC40sbFe/0+TI4ihUcY1up0YJ+NAyp7K3rDmGgIiHcCYIIF7QMnzABiXPMoTn6gYdJBtn6cPN/zmYnzrhiZfEvatdkWtVnDQx1it7Lmh/dUZpUeT4SmKNRwZNKJuUUXpmCXcF0+DzDTTziGtf7gmGmUPBCwCcwe9V8vjo84svf4v5oikmp+HV/4G/gQQwOxLVPgjO6cNd5rCstmwc5u+DdST5gMR8NV/SN9Ub1s4KdNd2kw3Sf+RIcr94ZQ55NSMFiM26XLaEM9Dz9fHfSlL2bXV5cnpgammZDCsMpJg65PuCPsyT/km37Mi7MhCWZ+OuD3BWrudEsi+ZUqhr8fTm0/iWUMtKCOm8LnLGeWcpumFvvG/0PZcSvjx/D2cgyKQm9ROv7T7BMCJ5K+SNA/qfGHCClFkumy9AilzSsSWrhQUVVz4kDtxDpyb8qZhthrUKm5/N6Zqgh3swbRWfMKyl5/EVBCds9dj3Ms5uiSzt6wCEGtYEQvvVK3O/GkARJfdsa/erDX4vIBEmTnNP4WuGSVemxUrooyYGmJydXXYPd+7qXJ+F8ThYd+rScqPiWSvyHmP4RMaejLZxOUPRv3wkMYKyc9NmmfjAAbkutrFjLWcLlN/aVh6QH59AntLpcFe5zFLlhmVekksBNUuNEu52vAmzhSqFKXQYZ6Ij7bnkzyIKr4kclITE5jLyR1bcB0GF0q5solLhavwqze3UqEnb55rJWa53V6w2ZSc18H+jm130teN0o+7WitujWm/p4lPiQCgTRigBquRXuA05W3Cl25jlDCsLN0pztlXMa15arkfKheBMyXhtSc82sP5Ld8J2ShhKRjnj
 0yyg3Tu7
 nrDoAARC7u6dFvDG8aLJAFOrnYy1UMpxnayEE3zJrAguYmKl1sGBnM6R4njxm1EENTePVAWByVNm2hwW84z25b4FL2PtXNL8JfjQLDcHzbeHIMknmZ3CzAJa/JnKjUQcB+TDiRsFb4+SHFAxx6VKPtlbK+TTuf4Ju3kaemzejPaALKy67ljtN4ZwmQeOWRYSezttju2+mUB6HfLYtwOeby7wuGlFrP5Z916p/jPDAIxAOT34ADdVkWw7rRIdOWVSFcfGogvtsVNaOZgU+L/AxtRTiN1l051sEAMtdUFSN94XtgYr4fdr+/8OcRsoaZqvCuY7PUId8dv89t5zFit0hMZAZmlVHECTSsMba
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/10/23 07:25), Hillf Danton wrote:
[..]
> So the decouple sounds like the half baked croissant, HBC, the
> Eric Dumazet dude sometimes is happy to deliver to lore.

I take it as a compliment.

