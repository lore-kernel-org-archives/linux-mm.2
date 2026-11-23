Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5DF1606A690
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ufQLTeQm
Received: by kanga.kvack.org (Postfix)
	id D3E606B05BF; Mon, 23 Nov 2026 12:36:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEF0F6B05C0; Mon, 23 Nov 2026 12:36:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06196B05C1; Mon, 23 Nov 2026 12:36:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BB226B05BF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:36:51 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 11B7E80924
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:36:51 +0000 (UTC)
X-FDA: 85467089022.27.BE705D7
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2E4AA40003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:36:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ufQLTeQm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455409;
	b=hx3qdCCh5AtcYkgkzKkvt/lAmZDoTQTn59jySyv/5eoL5/pA2mIZZtsihFed8c2cxjI2PF
	rFb6t6qk+arxUQP4cBxV4WrhHvuohj4OSLF6WzwI+GT8ky75ShwHym1mWkGiLo7ewEMSl8
	wfqflFr2ZWyiXL7KJSDeTIbAiMRGgAs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WY8mFIQo7NgVJ+1F6gP49ImSV6baaGjOTA3lfUYDY1k=;
	b=gchHQZT1EPSHjiJ27WbkHzuDzaiUAQOKMDpayfC7b455wrMkEBVRQolIEMOsgKJB+C53RN
	nysBhncqrqf2yju0SzJ4Viy12Tc9mgI9SS5EkpbclMquQnm+4ST2amOPAKRSvtdTOWo+5m
	x9Oh5q0+QaSSQQCDQbq65NP+uSK89/8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ufQLTeQm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-382afece6d8so661078eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455408; x=1796060208; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WY8mFIQo7NgVJ+1F6gP49ImSV6baaGjOTA3lfUYDY1k=;
        b=ufQLTeQmX3E73HItcUE9V3WELvAXSosNNwFeFIZMdj95303DpLjmsUA+zt5xI6uui0
         xMBnWkxtagV4CmyDfAYF6nByJWChJVoyQT+LpjxVk1J+/sc3xXpiG13XDZTldtrEF0fN
         +tRwGCXJdOPX/LvyEerSZHwJKWDjottHqHxv+WeiliM1NAP01BqMzdE+pe8HTNgdtB7D
         VlYHvr9+B2HeDi09azbG69KHzunbyR+MiOYJ5ahrj6dcGGh8tIKvVhZasoYvyPKuErGl
         buxsheWJCGZk+SH7uTi/pqG+NC18DsTzEnqSAvBi0QAIl8K5CrCFjpu2dzIxDqcdvYEE
         lymQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455408; x=1796060208;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WY8mFIQo7NgVJ+1F6gP49ImSV6baaGjOTA3lfUYDY1k=;
        b=ChI2flL3H6Zv4nKVWJv9EftSp0wy/DajGcoKcSP/aRm5VYLljvsJZ4jfSbtrL99eez
         4+IFg4yrbSfN5R2ebcbh3y0VdY7tshzBJGEMog3DKD4UNH/6E1dMgCLf8Z7HBeJA5PzQ
         tdIkoDVbVBRHJr8HCPapb13XZjUivZ7AzXX+2o7zKluOPNnSlkWq/pKb50e4sKjVbeGT
         B3bIxanN6lrYBLsYK2LOE1yI3aDIjIkFPDqgCRwlXo6+lQVin0FGWgeQBrtdaN7uxtz8
         8/tlfnGmGDKz9k9ftLebuI+ROcFX3JcKKYFdg7Y/zzcqve40ETeJxv/xbwr8iMMpHiFu
         16DA==
X-Forwarded-Encrypted: i=1; AL+hErGmFP+YzxIXTUYxIR/14FrkHwbBx604xlJFrNXFfm5TfYB6Olq6tvoqnvtLsuMviSe+7bSxcK2rNA==@kvack.org
X-Gm-Message-State: APuU4Z9t1q4ESubdxcFQhqFK7uDfGvTlo9bFaLgDO1g1wTUhWfWUPUcp
	Y8xey8sU5M1Fu00ji6XHCiKA7XuRxxPNW0FBoq42nM+ZHyPiLAmZY3VW
X-Gm-Gg: AZFdTZcHZaAnGzj3fOuHjIdVC1heuvSKi/fEHgzBmgvUa8Gpy6+UcLfEWbHzHDwYiRO
	K52sl1CS8IKydFP2JmkpmgEB9frtsdU3hiQHs/7dl8YqtwHgG870i9CEO0myEq8aGVsYwKzIetG
	KvB7f9sb2ArQm+qVLuLac7LUx9Nc8ImSiBd4qUSG7Uu+RYe9f36AQc0j8R9DwO9NciIGujkXjzS
	zJrX3EdsxrptAEr/V7wS7RM/7Sw78qUIwD7fyOU0xMk1BGGsVMsPhVQ+B4d2ObA4vOMNWP9dSgD
	nBavnqYoWCraHL7ay5I3RPLEUuPalMdZqIiJZaFFe9RflCWi5gNcWM99zM3Xy77L59DG6FZCUYz
	0zRdv/H4UeGyaqKvwW57/RGNms4pewu9nDCRvZ+UnQqvR+rxXUL9HLizMvzZFK6GUV8XEcpOYu8
	cgna4vKT+jsVxChksf2PJbdmPP2YICNr1xJTR0Obj0wktsB7V3A6sfli0iGI/L3EcPPAfpzy5kZ
	tC/ou/uOwVFia1mM8RdW49S06vO5ZkcDU8y96LRene+tI5A76IN9lcqGM/aNry08K/lmL2qwRBl
	dd8LqLKnH2wWQe2jkT32N+rHXFoJ6HYNJ0fvXm2e1tXHE5c19uIY2EMzJz20FXFuUA53BkWlKD3
	gTagaN+mmlIheuRecfCF6dvwcHuh7A562zvwzvBlrMTO4BLiun6A2qhTTvjSTng==
X-Received: by 2002:a05:693c:42cb:b0:386:b621:d8ec with SMTP id 5a478bee46e88-386b621dc16mr2377883eec.19.1795455407856;
        Mon, 23 Nov 2026 09:36:47 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:36:47 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 11/27] Docs/ABI/damon: update for report producer sysfs
 files
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:25 +1100
Message-Id: <179545256508.4.9352836018196513728.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 Lian Wang <lianux.mm@gmail.com>, linux-mm@kvack.org
In-Reply-To: <20261121210013.130397-12-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-12-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 2E4AA40003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: n1hro98k4wb5rxf8q8wwgu69xmb9w48f
X-HE-Tag: 1795455409-909821
X-HE-Meta: U2FsdGVkX18YiBD3xj8TEBdpMXvJ5N/J6OGJhT0FWPrpAJhMpUy6S6teW1LE2A/CEW9eUr/mxI855XGiRWdUYC1+2RjurDy46BaM9VYr/ySQ98o59EyFLQJeOYctyUqFebRK14o4rtPkgN8icWTY+t4wUBZm+WkZuxnivFTN8a2HONhC+IoBbtI37u26zHNMlLnjqboxc4dLqELN1nlu53OGAfdgmb/QyVKj+58jeSIvajY/NFNDZw78qLRYbGn93fuLbC7jNn0xd/UowgCgdm2Y3A/i0zUiebQ+GG/7Reypf5oy15NuTFj/yE5r2N8Qox35QC80IKggLbWmpFdKSBnF8jBw8tjdKbR61GHtYOXuZlo+omqcfcLNk8wrq9HOBEkuF0cAo+HQlVX8LKqd2jAJgTmXOmrgAKaCm5tXqd383p945WHZgL9bfwBV+hUX6nsspMqJkkynvSRgfB2BCOCXx/S6BE6B5GDwtlYIigcAk0sl/WZhpPJZBipXBiBmiS/2GSZ47w28RzlijxYuiZye7caidmR4jeZxa/sk92aVXvYV6w/s/uCCakBRbEdsVv3qNn1z5u0lDZY8FODmSWFSo3p7oKc8ESg1iee/Qm2qNdfCLMCL/BaO+vix7XINhpvsX/J3PoC7od7BsfU06FM4V2Po4MYSaBd1Q37Pmt4TQhcltMNuYuFl7sgMHdwqf+g7B87sGTVOridCQ8t0YiCCfPhpgzPuCtuNpiKHX/vRzWxzb+FrM9dwFdZHVTxG40Ocau0v/j30s43xDZ6av4uyE19dHRcXSa9f3iK1RwRvEwNoPDaJpSDkoI8tcjRNfiKDknfaNlAb6hYNGQeZVLDMaI+gOIAVih2dygICP86RJ2xPuehLaoU9jgXZgwGrSqXQVhURJJsmNHczV4ndlxzaaFx7cNGahdFmE5VlJPVBIxg3B1C4UFC0XmID3fk4XRIyN77was2eGmhhq3Z
 0Dld3nR7
 /05JDqVG+g08KiXruX+1Oxk/JAmpQm53wvz7ra+BlNIPtuHVseo5217E0PcDUTw61iONu9lC3CSQiC/7xpe8b5j8LzT0gCvTW4KKkQRBCsgEKihqmB0GuIdJ0j3CBoE/9a1TYxsb+Jnr05owLIZRlbUEg/Rm104dH6od+bSZ2QeOPS3L2lUc13JTWSqoEiUbUYmFr8yBm8BtaSDcqIOtwSbhj9lPY1SHuCqoLgqyqdqXNNS8z2g7Y8LQmWfIeRG9B2Bc4IzDzJHKI1XGrgBHMAzFXI5sJluCos75Rahi2s/VNW3zfKGEwFI/CbvjTPVIJKx45uldxum6rmsi+JOzqMTrxrSuTZvu/nxu+/2t1uuYU5TgD7t8WxyygFmtoHmBhrd2VDB/Botd2ZnjxLY5r9M7InrHc7W5l5CjUCaEtJLm60lUVVaUHjg7xoio1X2fAqXUCsCv0UU3GoYh8hBLWDn86fNr1JBTxjM4WyAcyKeucltGEkxpiKG0255MYbi2qWHezDWhyZ3jvvG+3pp6c8wkjRt4TBr8+BjNNu7J1HdxM8R9gXbB8stoLGTCINdR1/jjMEvVoRTmj99aIiqdGGab6UEcgzplHNbsxBgEN0D9LRAyv/wmBjXZ5rXIfxwbfbBn8mUPJ8/3ofFdqp3EoxxDnPci4yeYpzNOYhcFyyTiDHuFE+C1mkxTQpOtsERl7wLbbGo9ChFC1Wa2RqE9KhIIIt5lWUhLOAp0AR4ciERmb1N1b/o4X6Ow12myNqmeluN1bQNqfHZ/mX7x80Xrh5rRfKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 12:59:55 -0800 SJ Park wrote:

> Update DAMON ABI document for the newly added data attribute report
> producer control sysfs files.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

