Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D07D8606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 21:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=X5J/Yojb
Received: by kanga.kvack.org (Postfix)
	id B9E2B6B05B0; Fri, 27 Nov 2026 16:41:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4E366B05B1; Fri, 27 Nov 2026 16:41:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3D046B05B2; Fri, 27 Nov 2026 16:41:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6822C6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 16:41:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE6431204EE
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 21:41:17 +0000 (UTC)
X-FDA: 85482220194.18.F09B567
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 196DC12000B
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 21:41:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="X5J/Yojb";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795815676;
	b=KAkYPLbCyWkLF2oxVLXG/ywQ6R0ZK9sDpNLAiTZ+o2vwud6QFgcBu2monYcdn98japGw4+
	liUCUNs0ZyVejC45ksmeC67eFOeLWwlsYMQ/kra7lPXF0uEhuSfpv6DtDw65AEmdudQ7ak
	iqI/vYgPBsqoOBdKbuUghefWkdhJneM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795815676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNjJtSmgBzeJqa75AyMuB1FfpMIGeExfgQrDDeRI15s=;
	b=UWQ15SAVqystKztLoSvg2KeynB8gIwute17xSOXEKBWJQyoQVAuWlV7NsBLOd5rvYiimei
	RpLA1WbBQXcVVuQlcDHl2TkTXZZlkSlgOOxFtwl3baBq40Er5bPATx9i80ZhbXoJmppNQ0
	BlJDtL0MNRrM0TePL5jogZCBE/IR2WY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="X5J/Yojb";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb666304fdso83008025e9.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795815674; x=1796420474; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GNjJtSmgBzeJqa75AyMuB1FfpMIGeExfgQrDDeRI15s=;
        b=X5J/YojbaAGarumz8hC/DncZVrI2wFPwmZ2aPvFgUZNgl3tqzBIfbZGBRnx+ZsauvU
         KvOnIGNpuP8eUqXFncLdYQ457K3AgdQuM/TKYg5Th84Kx2p8wySIaGWwK6k3MRLeV7Ob
         WqvO8n+PmcW1WmNiR3EPqw6e4uDnnmiz+PgN8EQH+uS28vZU6MpQsQ4JYElpWSRUBVjI
         RPL0VIU9rupN1TcUg8Q6/y0qTZZR0mRdXWiMjJBdrgl2KyARNSRuwfalH3zhozrj50NW
         X4S/q7WFBBn7Qd6efBgyjkLTwUpe2bZk0USucw4FWCQstztNGtnPWMNy0heOWun9wTA1
         S4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795815674; x=1796420474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GNjJtSmgBzeJqa75AyMuB1FfpMIGeExfgQrDDeRI15s=;
        b=xsr9+IgIsCSp0AgXOW6cxIcN+FrG8m36qjUq5GHhyZ2uBZpbLGs2pGAJIjk5BdLBc8
         Ptr2u12+o4gFaZIF1yYbJE+Iy45Usg2oeFLU0GK4hD8cSTiBW8UWLLWbeNA1RHyvkQIJ
         xR0Ydp+nKI8PXch5VaJ7EvfZlCoPzH5qwipShQFhnjFXaxXTXkmhGQHhxarZZQVysvJa
         mMCu1D2+93XLUy70uJDMoa47NeWm8MJy+OEKy7a7J6tFEPx4NIC3pVLWB6637RoQT8xR
         RLIomgjB+7E9OPXfRzRQPXMl71y8n6RrSMhJKrXTZIdxVR5Qx6tWEW5nLugnynjO/8hb
         LLtQ==
X-Forwarded-Encrypted: i=1; AL+hErExGbf2kvs72/vnC7I4+royeB4Li61Q2DwzAwXrL7N2DFqszVemFcjnCjNvvErNlOhxwwvebj6CvA==@kvack.org
X-Gm-Message-State: APuU4Z+bcdsX+oVoWWjm1a9ukmZRyNM+0+fCUJExOi3m+qYR6fdDrBcY
	fq+MwEUXJ6UOQZw2CRVKp6eCVhOSdgdmtKez0iiUrOAS/bYgRa/wFYIv
X-Gm-Gg: AZFdTZefkeV5NCarZ8x6BqojvW/jSgcjbJzNNrYrrI9kGB4l+85SmQwsgGH21mM5CyD
	Zpj5tWwmJXoffHBd8hcnRMx2SB7TGzLKdUQsSEhBXkLXrwhzLiCtToqMWOMIg1Jgt8Yaa2WO01g
	/ViL3VGu3Q/xADokJYcm1UMWtYYrPTLsUgtiosTbKLDq1puxIZjR57go83ttv6zi/8D83tdG+/0
	Vt0Fj+h/iZ/nZ9wlQa8BDO5a3KQE5euBJ/hJWm94cws4wO2TIX05Hb7KaUjuaSzgtqWYCwYrgC0
	YhxNfsDL3ccS8hQeSOjtBbsSY3U4PMbJ26sRLl86Rmo6Tv/JP82oFf3v+NcW4BC6NshzbZGH44C
	Ks/4nSN5iBLP/VmSqC35QJhRgJZhwUgBIx7vnVR1Mu8JR5AZew3BX+yiOAKDqjzv+yHcflpEfHi
	zmuNTdJhxeuJIH5HjVt/PIlndlo23xR3BoLEkHRJ3O9kDgVoZvr3z9cyCr002l9WI9ZQMEj7Sj6
	QtZjrj2tKisN7rzRxkD5VDbs2iVnxVSDJVwR1VvVMK3xxLxFLOp5pbrDC0tThu8tLAbO66hJDwC
	/BqQi4jxwQLZE+2BT4sEYzzqDA==
X-Received: by 2002:a05:600c:a085:b0:4bb:85d9:156e with SMTP id 5b1f17b1804b1-4bb8880fe46mr518939935e9.11.1795815674386;
        Fri, 27 Nov 2026 13:41:14 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4bbb97e5356sm37714445e9.4.2026.11.27.13.41.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 13:41:13 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: jarkko@kernel.org
Cc: aleksa@amutable.com,
	alex@amutable.com,
	alexei.starovoitov@gmail.com,
	arnd@arndb.de,
	bpf@vger.kernel.org,
	brauner@kernel.org,
	containers@lists.linux.dev,
	corbet@lwn.net,
	dhowells@redhat.com,
	ebiggers@kernel.org,
	giuseppe@scrivano.org,
	hughd@google.com,
	jack@suse.cz,
	jlayton@kernel.org,
	josef@toxicpanda.com,
	kees@kernel.org,
	kpsingh@kernel.org,
	lennart@poettering.net,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	luto@amacapital.net,
	neal@gompa.dev,
	oleg@redhat.com,
	paul@paul-moore.com,
	ptikhomirov@virtuozzo.com,
	sergeh@kernel.org,
	skhan@linuxfoundation.org,
	viro@zeniv.linux.org.uk,
	zygmunt.krynicki@canonical.com
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Date: Sat, 28 Nov 2026 00:41:03 +0300
Message-ID: <20261127214103.542291-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <awOQDOel_72Xwjm7@kernel.org>
References: <awOQDOel_72Xwjm7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 196DC12000B
X-Rspam-User:
X-Stat-Signature: b34giggk8fsht6e8e1961rsz96zq7utr
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795815675-848469
X-HE-Meta: U2FsdGVkX18QQy7REqYpYj47nvlpOeQEXDia5uQypISwmk47LeDeYB8yNq3L2O0xvOIrS4TGT2onkYbCsRFab43fkBINm0f8cqQ3tO/Cv2604p4Twi10kW3eQobtDNhogNttAv8KHuQ43x61/uuRatEKq0pAS7RCALKrUjHWwQSdIf5sms8hjygKclY6RoOwJeUrMkYVmqvS1vSUptHt3Geeg2xZytPNisw2te5zewVE88IaIxziDzVrfsZ6Du8hNQqdFv0jN7dwe8iTVGqI5Ja7ffFQvl9E25g2BbJJLPisjw2wjZIDnpHeFI0sxmqJpUmF/7hyi+JtlVQtDfOIQiCNunuTru/ruUVA82leap22LbuNhA00ZxlxefylBIQXK9gQDFmQ2kR3zJz8N5/D25R1hyLB4ZyXxFxEiSD7VBHD+kZqUZTT/tNyRN8iDXgozW5H5SSkyfHIOzTyZELJHpcqaKwKJ4IvrK4ghkYH9WKeM3qUt1Kvx1hRFbRlx+6eB1BBqT0ZNyJaAtgz1n4r4ViADRGfPrRubsgQT0GBiHRyZ9YQkHtupUZQrTOoHAIo7B0g1GJFvCN+CzXjB2P/uTg5A6HSt7W6XJvyXdBC6y9vIE+6V/mvas/4ZgrtmEmOt9PvOUw/CmVuc0iO0khBo0P45/ctfpbNjzs7MvL429SfR+GuOoBYYA6972EqEBVY4ncrkC/jSW2QmTJYopo6IgKoglwmWnEMSGKeogFRSsVow98U1XxLGyD3iTIUlE/2YoX6XLUwYgElFVsXRsnRvdBWec1U7Nt1iYC9wTsVfrBFJCPGsmCI6ZS4uT4lR6tRrxkhlET930Gyl0S3VFNiPQUXk1wdljUuWOg/Vjg2XKI9ET+9LewPeACF7ibOULDaVGNfVdOBBjRe10NA1+goxVG3IjXGWjGzaYEsNIIx0TyJb2ll9/DSPHfenVsJ3UVTNmpbf0bHlaOpOfpZ8TG
 az/6cwe7
 NfAo3As9iYOOgslyBeopLJh+hs9UyRQfSR62VyeMrcuKlRwWAEFfzR447A52wZxeALbuP7XtA0ji7e1AOMpa5Iuu7JLYmDaUD0TrKItXfmKQf8AB5d9CNW6R7eGigCEbs/r1GKGQGMEjeEgXBrIRI2+RJxlUp5+vUTHPeUizDjf5AiP7NFEkG+x3aFruO9JjlhMNRw8mxI/LNGAoXuwXGTJlk5S+NoOlUV2IaZ2uVO3q5Q76SrwRFGQ/MlBlu3EAA/MRpoFgbVECT6SvrC4x8RK6ZslZ5rGUOxy1bkZT2rk67kMmGQpqu44zMXHjdypklCRkFwBYuCNHKLCPvjh9BxVIShldWHfYgJAUNJib74VNqBQB0Dyz+VmmcghrI8yad1phEchHywdpShIUsDfHD2k9GqjMqVIl0HV3qNVDsiwHwHvO5uCqIVhos2ougIgBaX0L1FrMEOjKYt15keZjw96eIlD4u2UmiPszkocCaRTSopN1kE3M3QwkitaGEwky19rCy36VPRRIqNii7LlQqlGYEM6mtfjxRrK9SLh3zcs14jxH5Ft6R2ib3WLqc8Exn3iuZv36qhXgdaXsyDQixeo84qwPicu42bL4ee0vHT75r2BV6fOcJAzlSy8arXpWhobaCRt6KjyVOstX0vlp3X3xRRCqwzPlXcCeksIJB2MKlJAvmPfP1UWaO/spltTRSucPgZoeJmlqXwU7S6PtbtyhDjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Jarkko Sakkinen <jarkko@kernel.org>:
> I personally think that "getting in" should not be a goal in the first
> place. I care more about that whaever gets in has a high bar of
> quality enough. It can be something different than this but
> when I read the LWN article about Cells I was alarmed enough
> so that I had to do this and prove my point.

I think that Bacik's patchset has better chances than yours.
I think so, because (as Bacik said) it was tested in Anthropic, and also
because Brauner reacted positively:
https://lore.kernel.org/all/20261021-zeitig-niemals-clubmitglieder-b3973fcebd38@brauner/ .

So I suggest reading Bacik's patchset and say what you don't like about it.
You will have chance to influence Bacik's proposal before it will be merged.

(Note: I am not kernel developer.)

-- 
Askar Safin

