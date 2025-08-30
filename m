Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BC59CA0EFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 06:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9DE06B002B; Sat, 30 Aug 2025 02:26:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4EEA6B002C; Sat, 30 Aug 2025 02:26:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93D4D6B002D; Sat, 30 Aug 2025 02:26:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 821EC6B002B
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:26:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08358119FE4
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 06:26:23 +0000 (UTC)
X-FDA: 83832439446.11.15B9BF4
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id BF7D8C0013
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 06:26:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=IbxfabgI;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf28.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756535181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mgXyUB6vLmyGEIM/HvW/8ZTwZD3HAIcm1Xp9HqVBKsQ=;
	b=WaaJaDlNjdvLTZuevDdiRtPtnRlX9LGIxX9qqETErMQqRxBPWdfPzPDoCgEmxFTQYkNTDW
	yf+Nfe35MC5ss3/zYVcqgsiRbsmwZkU5V9qxi3ezZpT8ErCUshttxUC13boE5DUUO2+kqk
	jejeIjGsrVrvVFtMSgMt4lTDPQvbh6g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=IbxfabgI;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf28.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756535181; a=rsa-sha256;
	cv=none;
	b=xpVfE/h+RFm5HAaUW5B4Fb+l9UivkD/hj+89VzUBE7SMyaKaThpRFbOg9+MAgGu5RIxn7w
	rawR+Fjfe4rf7/awG5h3B7llhq/sQamLaQ9x6MKuTsq4Ou+6B9LjMjNnilmahCQb9kMxa8
	yfSXhLQ/XzC2LjEotniBVrKcIPyVvO0=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afee6037847so419577366b.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756535179; x=1757139979; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mgXyUB6vLmyGEIM/HvW/8ZTwZD3HAIcm1Xp9HqVBKsQ=;
        b=IbxfabgIm8h3gHQMJDauN9tsGyFPh6IHCbhNvOuOxj3HKZ+/EewWwEy5netb/rMowe
         vjQz44Fu2Wm1Z7gOOFOuja9H0PMUNuUEpNyKDQTRNz/eVIeC9iYkbWoz1DCy2zVgq8Yx
         /XkAvN3NcLBCmbY4SmpZAw5M08mP6gKF1c78u4Og5gBOwj8cThQA2BHKIEhM3aRKovZ3
         b7sFJU4qMDSLD5eXBJVjSLNMt33edQdpMQE5wqgOVfATCO+qSrzL24S3iOlCrI22PR/a
         AIGwT8IvYq6IIGTIrF2qh8x1VebY+PriGtO4X/OcL0sBHXbXMX9c87IESGPzE6zHKY0t
         4vbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756535179; x=1757139979;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mgXyUB6vLmyGEIM/HvW/8ZTwZD3HAIcm1Xp9HqVBKsQ=;
        b=UywTSGnQaAljdCtVEZT9IDMffBpqGXJtRkNelbEdnKEL6Brju93LGYFmm1LIBfajDs
         kLTvtp1vMM8KPQA5SBVi6iZjvnIgPnpWKN1HvtE49Pn8SacL6kAnSSC7zO0lbM+3xDER
         jpf4RmfrmRvFkT1k4DV3cAOtSAm6WAASWacZPYNhnhI/n68Ossp6C+q7PWVhgof9bpP4
         ifHIzIB9A4li+eLUU+Wi0mHvV61OgnkIc6mgachm9pg7PDz6a6idnybodIZw+DU3ka3B
         W60R/k5duDlor9/jd033ybSc4dfHeblGtOQPvOmUYfR++rX27vT/L4ZkfRc9Tp/ho+Rc
         4ETQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsJ4mVispz+nUcOnEVLwhmWuwEHEQQ/hSWxPqCWuzFWK/RXKnLJKGtB5tPl1fA/hRgYQlnbznPVg==@kvack.org
X-Gm-Message-State: AOJu0Yz7yAnrB3aeoX5rpK+aA/mH/fa2tCFScQlpbNuxsh+PcftEPtxL
	ctef8NyKgl8ApWA4S2yyVHY9FgCJhqTQSJRvds8GGItZSW2c7dhrrVI9x0rRA8n1CyTTAvjTo+g
	pHExpJ7NRE0sUkygLZhhtPeNfdeaeU9llE62yhznLWw==
X-Gm-Gg: ASbGnctkVv6UGTSZsYdpyRbhTi3Ml+MclpRgx9tpqGz/C1flgumGmBwfscc9D3kL4WB
	O/5NXoWEvz7efpL5dQ04z6ugkCY69GoFpCD+QKeaNlpS4q26dKVRXCWaBomhSFzEL97KrI89Hpd
	pxJIKg2eKFYZPR5YVyP2736VqtXrRoRvomS+xbWknyKQjSQ4atYINq7eJpVrLepOrvquIZ7qECi
	p/Ed0cinSWPgBg8v2yT26Q0PllRsppyknN+g2bXSzR/Bw==
X-Google-Smtp-Source: AGHT+IHCvHn9uk7hSHPOZ2nzeLKH9MIFtgrASONd9bINKE+pcP/w+esbaAmtMOpllURppKjJONJErHArmMQvP7OpUoU=
X-Received: by 2002:a17:907:9411:b0:afe:c1e4:5554 with SMTP id
 a640c23a62f3a-b01d9730679mr107602366b.38.1756535179041; Fri, 29 Aug 2025
 23:26:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
 <20250829183159.2223948-6-max.kellermann@ionos.com> <aLIxs1cFhneGU5D9@fedora>
In-Reply-To: <aLIxs1cFhneGU5D9@fedora>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Sat, 30 Aug 2025 08:26:07 +0200
X-Gm-Features: Ac12FXytabmAexw3b0aFU-olWuI7_QFOvp6zOtmDGZ1G5mwKvBMIUZZnCVOTVT8
Message-ID: <CAKPOu+9MBokh6z2o8=GKwTeU61Ce8Pbs7zjTSxo9=d+vKCYZWw@mail.gmail.com>
Subject: Re: [PATCH 05/12] mm/oom_kill: add `const` to pointer parameter
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com, 
	yuanchu@google.com, willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BF7D8C0013
X-Stat-Signature: mrqxuwnaxkw7q9xkqhseurtq5czb349e
X-Rspam-User: 
X-HE-Tag: 1756535180-452904
X-HE-Meta: U2FsdGVkX1/WpCnWMEIctwhljPyD79cz57zhAEqnY/P1qglJkl5IS21YPkirEz346mZ6X9iWKC8sS6g/Y+dZf4rtw5dDm+26rYsUfBiBFcSX9yEbJYSwSWV3hZ3HKDN/nNq7VOD5a9JxLKnisqyYPCdedXUUjT/YS2IOZLrNyTviuoUJaQ+JPBdS5SxNe0zyCPSGWCIBIBLuClAIkT+dbwnAxZMBs4it/BwMpHfGwIabH/DJsjljm4W6yDsqqV/hFop8iptZfx1Bnb5tVHkyXpPRdwzYCUGTBtTayH/NuUgzCZz0YfUM9LDIBrQ/5bYOJq4Sn9J0d1Db1S5qKUIDLw4a8RozDxOX9fwXd8Vzq932upRmsaMeHO0vQNILVJ/ut5LOKQvJ6vmIDPmPTi5GpYN26JSpeTbcKo1yM/oPrb7Az22NZ2OLP/PoV5T1hCPZL9QV9UWcGJdhcJiZZhPJSuegCcIAOu5cSbZ3V4kwvnX4WKDgRa0i01m9KewiuNr2+S4N/icQWluCYV1/0bqtFRXRKph8TiW3bWubHGDVGuPAtmS3lEmhfOJd95QlbNMXWm408NBYTzio87vZkiQNtCiqCC+nJNJ8ziUnqmg0VlGe4cXdLBB7p26+uV7yp7mroeyGm0DWr4kWSuLDUfb+k4XBH4vjydIz/gSUAEZRG4CkLHXrsJNQYEcIDu687L01TJMoaiSBDaoqHHv6G9JWGzbiYAc/EUa+U6d9IWbFToXIKA19+E3Sakq7yImguhHM8hejlqlDqFZFTFfDXMX6RGdejTvfv1inwrt8wmHAgdFWbZPISZns4cxY/7pUrvd1LoMA4Q+qJ4kUEulOiIFb4E4MW5ZJI4/TEIvg4cgxTrVw/RL/T1/Pnm3guiJUmVGchMfaoRq8aPkfyBNVqVgFOeHHjOj9EWH5E4t4U6W4lt1ZC1BzrzlTT4EtA7Udfto2PB+RfZ0SRUlxZ+F5M4y
 zlxPjM6l
 mj5H/zXNlGjSgK8rjAIluAlz4qHCnX4dZF1IDIlq11N6x6/TcoUW2Od3/kvc8bfx+N/Vr4kjKJ0NRabyiSQjvcehBl0+tdunQ5Otvp9GUIA9Q22li2sDxYXpgLMiBcJekwOOLehBjaelZMJveT1v8ESqgQdIefIgysfhSMsDOAApvr63Ljm5GwvyJvBH6cIy3FXR2zTQuC4tpBctUB3u/HiD+Gi6/vZO/pf/Q4X3lK+69oSoIc/iDuut4c4KwA/gKyUYHOs40BP8uYFucxoapSQXkicIw+P/CuGs1BfZVLYXs7jw/qTVObRRlEIjVCBJREaT+93tExF+wqGgcL/dXETeImDbfJo+hjuZLtepm5lN+1ww=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 30, 2025 at 1:03=E2=80=AFAM Vishal Moola (Oracle)
<vishal.moola@gmail.com> wrote:
> > -extern bool process_shares_mm(struct task_struct *p, struct mm_struct =
*mm);
> > +extern bool process_shares_mm(struct task_struct *p, const struct mm_s=
truct *mm);
>
> Nowadays we're dropping the extern keyword.

I can do that - is it acceptable to do that in the same patch?

> Also, Is there any reason you didn't also make the task_struct pointer co=
nst?

I wasn't sure whether for_each_thread() is const-safe. I think I
looked at the wrong definition; for_each_thread() looks safe, only
for_other_threads() is not because it uses next_thread() which takes a
non-const pointer. I'll amend the patch.

