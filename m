Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA5B9CCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 04:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EA066B00B5; Mon, 19 Oct 2026 00:28:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B226B00B6; Mon, 19 Oct 2026 00:28:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765006B00B8; Mon, 19 Oct 2026 00:28:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CAB66B00B5
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 00:28:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2306160683
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:28:26 +0000 (UTC)
X-FDA: 85338094212.04.726F63D
Received: from mail-yx2-f1.google.com (mail-yx2-f1.google.com [74.125.224.129])
	by imf11.hostedemail.com (Postfix) with ESMTP id E67F640005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:28:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HF06QW4Q;
	spf=pass (imf11.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.129 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792384104;
	b=vzFR6TRN1K1dTgkgSlRaOmJFkhBv0ctbq6adIBmg8/1RGgXW8LkI7kKm9mT9QnDdQP4Pns
	O5XyPsR7XGaB65e7W7MRSVNX/QdIHnBgPSqv9Da0XYQZLGAKYiwqz5iTlDyw5imb9O1+BK
	SL4auGzbg9YGYKlfMdny5TntnuYMTDE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HF06QW4Q;
	spf=pass (imf11.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.129 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792384104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPEnziyqohgCiyllOGpLsBcdgNJdfasBLYSYKWDG7f0=;
	b=EEjw071mQmV1SF0HU0MetB1S/TKLQ3ljhV4Z1xHIl56FoT3kkjgXnzIHq7+ZyUXJts56BB
	nre/3qGCwyKlycSBPV3uMHGVUpakysi35Vb4wJIPHS/+FPaXSKtPbWfWqN8hU+Cw1KLzUC
	mSvITE8OLzrPubEp9WXUkBJpz27/CYM=
Received: by mail-yx2-f1.google.com with SMTP id 956f58d0204a3-679f050b6feso39493d50.1
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792384104; x=1792988904; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KPEnziyqohgCiyllOGpLsBcdgNJdfasBLYSYKWDG7f0=;
        b=HF06QW4QN5qTyB6P3F7ejbwAvfg9MjMbn5MgzPkjAnP0Qb0nEehqtmD4xkIo/hsEh5
         JKbeskqPkZbAVgvcwlDEJs0GfdaACRTBo0HJVKBFtY9K0C6mjaVahiGOO0+1yulwQ2EP
         fR7y/KR3fdLm5iMSTjhqLxgMP+AS4YZRimAP3utrt//rhTOd60honYQbZDQU0KZKT7gQ
         N9s7RLCVbFboq8niuKuRP2Z6zgf7YBdm5w2d2VcgQIppRj+Va3wkJlnjvYEGSJhLjRw9
         SkT8buqw1636Z4H6vDZ0as3lw7Of14QXllYgUdB/Hk05E3r6G1lVS5e9WE3IUZBrgXmp
         WDRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792384104; x=1792988904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KPEnziyqohgCiyllOGpLsBcdgNJdfasBLYSYKWDG7f0=;
        b=KAy5jQbXSokU32+KSBeQFzpAzXnKoEBEYJRtSbjulc34VTIxXtIAWz8BIAmsOTdWEp
         3pY11roTMFFNHga5lZfj4fhDEpvHUsmWymFnuDnsjKXb7SOdx4pJRP/9dGF9lY4GLO5N
         9QUm903daKhYePo8d19FJI+xvI4NSCLDB1xgR6FsoIpD3SQc7pZnAZWODP/ekSYrADB3
         G/Eqcp6J1YJhvu3MjUAyg35r8FlJBOAhDtrCg4C1IMBbfDOcRvD8wA+szI/fivNQJx/H
         tnKFu425nUJzJO9rcSbp+/jrzggC0+F0IN9vwkombIlXlPjln/4Bt/Fj8m9biOkDebOW
         8hOA==
X-Forwarded-Encrypted: i=1; AKwUvBx5SxsQJTQKCXVGIx+icADCu3zmOzdopVTucePZcZOgivWpLC63x3WbvT6Sf2CF3gcXZJTj7YSj3Q==@kvack.org
X-Gm-Message-State: AFq9FYKNI2fRbUHcryoKPllZSqSuJIbVnnwL4I+5k8sou1/mHbPjhJno
	4dZAmAGPgVjEq9vFwAmSAmMDpkVIGgOVoRSrelJz+W5MAURpwcE6Roo=
X-Gm-Gg: AYBFou1c8UxbgCB99QeWF2oPIQ3t5GebP+EzCAopUNvWCch/JOau92ugWFGUMVDiUKf
	JOkbNXq0P3Ivw+CeEK+lhISOeGdnqcGbTWKYBAkL+G4MudjBj1cxUGxCHda5dC5BLrEmLwsFk5S
	fpC7rMCt2hvKsrk0esN5oLNiU6N+FfyXN19YfI1867rVp2cOVvwCZOVofh4JDpwgNnifZdYFW7/
	XAO64SD9Qm7aV+rF2T5Dy2XNF6u8mONgFOqmFC5MkeQcW37YEXCsRp0s+8KlE4DN8MIuBiqH5q5
	1PB55WFmeVhOM2od+nCzIeuhZZ8lDKh1qSwccUWItFuSNHkifceWq0eSRJmkWbPHK2Rx8w7OxAR
	T/A7ZH0sSIUOx4z7opLor+92AMWArK9Ypdfn8NaFuIc9gVJ+Fls8lI9b9BqZj38+0f9zTZqgMaN
	PfyVF0ImJ1j5gKFjiTBJq6PTiiCxSqQAjRZp3UIsboW1ZfI5cBC5FByZEA+rYDR/W2jZLk5K5pq
	BfrYmbXtVj5dFt591R/NytxfGdL0Y+gsTzdwDWi+kibcwEXHN+OCoKXs9CS/7LZNkqpKdXDrFlj
	oMTaw5Rws3KcS0ud8A==
X-Received: by 2002:a05:690c:4346:b0:8a8:8f62:eb3 with SMTP id 00721157ae682-8b0f21d7fc0mr14428137b3.62.1792384103712;
        Sun, 18 Oct 2026 21:28:23 -0700 (PDT)
Received: from localhost.localdomain ([2600:1700:4577:1050:ec89:21db:40a3:896])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b0e591c51bsm35347307b3.34.2026.10.18.21.28.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 18 Oct 2026 21:28:22 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: aethernet65535@gmail.com
Cc: ravis.opensrc@gmail.com,
	ajayjoshi@micron.com,
	akinobu.mita@gmail.com,
	akpm@linux-foundation.org,
	bijan311@gmail.com,
	corbet@lwn.net,
	damon@lists.linux.dev,
	gourry@gourry.net,
	honggyu.kim@sk.com,
	jic23@kernel.org,
	kunwu.chan@linux.dev,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rientjes@google.com,
	sj@kernel.org,
	weixugc@google.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH v4 0/9] mm/damon: hardware-sampled access reports
Date: Sun, 18 Oct 2026 21:28:19 -0700
Message-ID: <20261019042819.1937-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261017211613.16456-2-aethernet65535@gmail.com>
References: <20261017211613.16456-2-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E67F640005
X-Rspam-User: 
X-Stat-Signature: oqxxhfyw1jbwph8epyewpcndto1jzzz4
X-HE-Tag: 1792384104-797852
X-HE-Meta: U2FsdGVkX1+NN7K2X2Ddeh7JDMu4UK05yX+md+m3vi1wkZBCWUaYBcdEfVtQxMuKZyBKLuZFsn1zm5nFJp5G+3UZ4xj/1qsQBfTmCeegiI3pb67HAQE6AwigtSJ+1oVuGISllZ8S3vCMqT1vmqBD5F2JM3c7gR8LjTx0ZP7hjc9xMqUOzIYQDwxfiy2416LRyARHCPgx+bkFn39aPT+of5Qo4f+GjZLWJWgvK1M7uuF5EvBiPOiujab7s7W7G0zoShtjWBRgnJJFpPsUWlVJxms1DfN697VEKIjGTWq+3B4ZAXy3Y7SWWcjgLYQI0Ou+smmDoR4Q50ALuI9xDf/KtAF1uNsvzjv2pg1Fv3DpyK8a0rQit9NvHXdkZa7aH31pX9+lMRt8BYySNpVUN9piunoph65I+GHiNiHiQyeBCerWZOLd2Dd7I5IHxh7wybwuwotvop/GcPxN5BBnu3GQzW7O5QpLMK0ilQvWRodPECh7xr4GLBqhDQFAI/3avaANdTq7wyswpvtJ8/Cp0UsCFu8Aaq1NRg9ErFkPa61NYF7emzlWCCiLBSKB4x/FHC4wfjZoALF6Io4KvzXhQD3xLdcR2bIrwPs3ZscyAM2tWB9xIPp4ECqXtaIhiL+DtXN8PtkLIvmhn+nczRI8OovikF8cht8yD6FIio9BR42Ug9kKVnWeKX/2NGote2UdxfZX2btGRNhG9ENse5WUrCo5o70JAX/dybgzJhvr5zkUpM00vV/XcLynCy9aMQXP38izHnZGi0DVdF/B7KD8hT9l+TRVHIYDpAJKMNXOhqiwSeH5+uSec3JsQpMBIACLMIcKbHDjqll8yTKKMrxOIIvinljlCWxSZ/q0BRz+7zDRgt+2E5EyvA027UZAesHpXNzDy6CF6UevayCZenJq2IH5m5Mps/8onTM5ZpAO4CYLhqexSZJa+2KPEEbkJjtoHmzVoAGNt1GyN9PYDfXCFUk
 nJrN+avi
 BO2N2+19o2zYLsDgdZu+BbzK2idgushkW8njcKVI42VXRhV1TXfjKu1YE4abZLrWHx6q7KZWntwZBSGgvGKgyKbdAQWJITCwB7rTzXjbtrT5BTPrQOaP1BfpiVyIDtG0VZreXsqMPK2s3VAnv7wj0JgOKG7yB+t9gqTraRsA0CZZh5obDRSsrq96fE5/DmxAt9QY+5exk+Mz5KYnDuped7MiTnskWqELGJTRQLXUot+379BrXwvpwhjz0+ou62CwNP/9ZH9eYYTWqn98uHvXronwZG/6oFQ8QRC/FIWcGSMT0xvStRK5dwVtV4XEiz7MVv4PDXGn6wVHjVEgD00D0HoUXnTlPpk+eFMh4czSPzATUASz+440Pqxar35hFw/mw6IM6qfDhj4YD5C6aBM6WvFbU/paYHFU3rNSV0wtuIG40TFX7aONr334kMLNgJyZCa6canw76BLn6QfwdRL0MmmpceElVFM5W4edxiVgAoHt0IGql4tJfy6pgihkKHGi32GSoNFAZ37jYE10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Rui Yan,

On Sun, 18 Oct 2026 05:16:13 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> On Sat, 17 Oct 2026 15:11:18 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
[...]
> > Later, I noticed that about 10 minutes after starting DAMON, the 'seen'
> > stopped increasing:
[...]
> I found that if I enable the kernel NMI watchdog, this issue can be
> fixed.  So I think this is not issue of this patch.  What do you think?

Thanks for testing the series!

Agreed, this is an AMD IBS / x86 NMI quirk rather than an issue in this
patchset.

On AMD IBS, when a counter overflows it sets IbsOpVal in
MSR_AMD64_IBSOPCTL, stops counting, and sends a single edge-triggered
NMI.  If that NMI edge is lost (e.g., across C-state transitions),
IbsOpVal stays set and the counter remains frozen on that CPU until
perf_ibs_handle_irq() clears it and re-arms the MSR.  That also explains
why the sample count in your graph stepped down gradually over time
(100k -> 36k -> 18k -> 4k -> 0), as individual CPUs got stuck one by
one.  When the NMI watchdog is enabled, its periodic NMI walks all
NMI_LOCAL handlers (including perf_ibs_nmi_handler()), which spots the
pending IbsOpVal bit and re-arms IBS.

For ibs_op, a larger period such as sample_period=262144 (as used in the
cover letter) or setting config=0x80000 (cnt_ctl=1, dispatched micro-ops
instead of clock cycles) also helps reduce the NMI rate on the CPU.

Also, if it helps for testing, the damo branch in the cover letter [1]
already has sysfs read/write support for the perf_event prep attributes
(commit 1178ccb) and tools/damon_tier_gen.py for generating IBS/PEBS
configs.  Your probe_hits_wsum support in 'damo report access' on your
branch is a nice addition as well.

[1] https://github.com/ravis-opensrc/damo/tree/damo/auto-tier-bw-2026-10-04

Thanks,
Ravi

