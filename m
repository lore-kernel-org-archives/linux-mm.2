Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6467DCCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 05:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81F948E013C; Sat, 25 Oct 2025 01:26:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D08A8E0135; Sat, 25 Oct 2025 01:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 698CB8E013C; Sat, 25 Oct 2025 01:26:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5670A8E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 01:26:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F00A21A049F
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 05:26:48 +0000 (UTC)
X-FDA: 84035502096.11.C7C0DDC
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0073440008
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 05:26:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CwrpUWGM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761370007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mV8buuSZQP0rHOq5S4b8K+cOmbjRvDVQwA71gPDHBAE=;
	b=ayzGRNtGq/ngfR31IaJoS6iv7py5VPz2OWUmEKTuRotX3YHpcqv3brIGiA3jG8CmsL+fky
	FMNGHiF2sqlPKx5mUYbbErJcri0EiNQLNezNebtbpf7nUzFQIsoRU2PtkR8zTZbfcBKH8P
	wObF2fL/pWEL7wTBuZ/GV0sm0Iucf1w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761370007; a=rsa-sha256;
	cv=none;
	b=OHkEi9bgRm889Jhd75LqRVssMiCDiRCtbPpK8jRcBeejYUir4iPeVVP3DSq/oTHyCvPsF6
	YVXCbLd8UH5yulByI81bmtfZBQ6+57S2m+IHc+CTu9PsZ9eHlLUYHTAD134cZn3tr5f9HE
	a88dYAU6Y+UAJ0BQHYOO/DateJGO+y0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CwrpUWGM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-63c11011e01so4336954a12.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 22:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761370005; x=1761974805; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mV8buuSZQP0rHOq5S4b8K+cOmbjRvDVQwA71gPDHBAE=;
        b=CwrpUWGMBduY0KR8GlLn1rjQEpnGHVBxLRAf+27J3mP/klFqhOcCymDHWDRHYdtof9
         hGCyEwKnAcdix7suo9FuVEBh10vyLLsAtpaVAsTBjjqW5lAn3iy5xJ3Jqkki8vA+huiN
         BeXZ2lzKoa+ThwPvVK1Uo/vPZgvEHU7bM8abji2CF+Hz6t8k1/etuRaND+QbceAPf9ni
         lYaMRBoN2udbNlzcM6ttkuRbWSvgo7H1S3NscRpBa7ZO7jpDRxScTweMf6ax5lWQUshS
         R2RowiXguCJMU1IUGIF5PNmT5JtDbG9K4EQs3wt4TuWdU1JYfQA+cvmHLcBsPqPG4ncQ
         GqeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761370005; x=1761974805;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mV8buuSZQP0rHOq5S4b8K+cOmbjRvDVQwA71gPDHBAE=;
        b=pn9ly5OzLJ+15Vbxv0tCkFWB0/zE8K5OeNNGeJTGYmACgw0v0Uxz/UYsHif7VRiXX3
         3SOisT5+qE+Js8MH6jyA7/LrGWX6B8Q8xjyQvRbL6n8/o78QixSgFz/d+1EyF05EovK/
         P94kWCHUrxawDNo3NE/Y761bYSmYi0Dfj1Zkj0DdZO1GIGXuQCteTe14WWml9TXjzR7b
         5s2xTKCYVA6UTUP1U7/WharyYR4f9OCkManAEP2nZzkID1sx1VBXrvmgd304KYeAPfnQ
         UPjSwN02NMmpCL+UwDotuXwB2r1wW+1alBBM0ckkGq3W+96pt0jbkEIygfkSkSKTvfYP
         oR5g==
X-Forwarded-Encrypted: i=1; AJvYcCUlbno10tLbyayky5tA+IVh4CpuYayjrLe+FQBx+woFFZptqRi/fbJRrWftxBeSJ3GBGGJSNlVcKw==@kvack.org
X-Gm-Message-State: AOJu0YyhgF8XcFRguFwZVH8V6KO86b8X1SKug7Gi4aMDKQXrzOryVsBa
	aS/xVL2Ham2m6alBL+XnfI4DtQmZSgztUEu/+QXIQwUak3yJ5lFv105O
X-Gm-Gg: ASbGncsJTLRgDcCdCTo0FYzxdiQrCDcBiR7aMUS4HE0io8CAMaXjgRF0ekgIVsgQvph
	hZnJws7l0MenN7CNAukwTZ52krORK5+Y3o1mhmOC7EbmwVq5X9miBXBxj+Aa57EQtvtsXj6HfTk
	I613H8p+uQRUoFTkN5pr60UoS4v98aFteuL7dNwv8R0mc75lPz6vK225vUWuNdlYhSsFALVHzuA
	pzqdqTol42ntYG5VciYse9P8WEno02TADl09zul3IsyeareIfRg96vIZ0CDov0K7bPEQDKria4p
	CMUjlx1coH4FuG9DEoaWc/76EQTH0dKs46CXkMN0vbAoKhkDxh2KEZ8a2hkDjE8e3zVya6+3qt3
	RAQhJom/EI1+3UTMcVEOu5exkbkZRzkqqIrvgyaX+WAz56vYGUxUDkSjVkO/mpWF4elA0tIamFi
	XJuJH5KSfVhEs=
X-Google-Smtp-Source: AGHT+IHk4JGeekekahtUg2k/EhAC9kyrxVTGjCsIExfHrDtgIcN62P8FCtHZWZXypDamfyJkpyvf/Q==
X-Received: by 2002:a05:6402:40d5:b0:628:5b8c:64b7 with SMTP id 4fb4d7f45d1cf-63c1f64ec00mr33191598a12.6.1761370005212;
        Fri, 24 Oct 2025 22:26:45 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-63e7ef96105sm880960a12.19.2025.10.24.22.26.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 22:26:44 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: safinaskar@gmail.com
Cc: Dell.Client.Kernel@dell.com,
	brauner@kernel.org,
	dm-devel@lists.linux.dev,
	ebiggers@kernel.org,
	gmazyland@gmail.com,
	kix@kix.es,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	mzxreary@0pointer.de,
	nphamcs@gmail.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	ryncsn@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: dm bug: hibernate to swap located on dm-integrity doesn't work (how to get data redundancy for swap?)
Date: Sat, 25 Oct 2025 08:26:37 +0300
Message-ID: <20251025052637.422902-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024163142.376903-1-safinaskar@gmail.com>
References: <20251024163142.376903-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: i5r43rw9eix81tcn5yebrgaghcfyd8ei
X-Rspam-User: 
X-Rspamd-Queue-Id: 0073440008
X-HE-Tag: 1761370006-448942
X-HE-Meta: U2FsdGVkX1+GO32AMeCSN7F1oqTuFB6b7x0j10YISxa8pywlVnAWUhZIvMMAnEKdxp6lofsHGUDwM98O0/Ji5WJeGXmMqYm7PYij4kx4rDyDAfxo2yggeVtwnnq5DniU2TLb5f4MMDiWWQOet6Y0C+hyEXWzGe5ifYzhQAC6RuR4wqDfSUeN1FaCf/KOiIhQVSYdoIYe3RIsSNPqkE98+jWKVNcHqPqZVJ8/e4t+OeJnCszNZksbAXH/2prRp7qeo59FU19lHpTS3ohvJ3gHYVVrbEubJ7cviN4AunFtZwn3jy0pvGB+mU/zYhZVRSt3kif0BOVPQ2/OAv1aKaK2xX5ULqrUKXIjJni3iQeaFvAUasVx2lp9EplLe8ZMpr3q/5ZLoUDBHsCNzoy0Ktk+/fnK47FJZC3QJAe/5fYVKh2AabYIeghZ1wDKeX0yRAkgWgEcC+Y6powH3ELrvL33iLr6JS9vEpyAbUaGQ65JBG78W4oqlXRb35/be5nsZ+3MNKlHCMGZm+2qJii/F4p8t11tzhw9/gCFCj0ozR2aoW0wz+1WiLsg/9JnTCWlOA8iB0E/RWPk3dSBvXXBv1VaNGjhLDpGO44obOg48ENxFYXR91KpvSMoO2C1dnXcbyWveHkkzOmX7Ql5ftFzhBwtsf/dVX0h4J89s9cYMxFhuQASr9BVypuml1UWoBCVXtMtpFPAHk2z9Q8h0MIXXENhnqMmgm0eFbmPG06Ev/VNJgioKnEgZgo6TR4Qa2Tz1+eKoAvhDnDcSxGVYC9qiDxbromwoNt1kJ9HLXmd34l2vqkI7niX6JpTVYp6iknyIxyAcImpCBajyFqc+vW/uVxA9ASc9cwsrQnNow6McOSpGpe7Yay7+0tDF1j7htoKy5G2Ql8KoL3FUOQCZSIpzMmJBoTLzrl7w8zBZlB/84fGQSVWFIITM/7YPsy4PPfRTvuOi8coLWiUiiyPqMQV+3D
 lbL3JBoN
 GK/2z72ztjQprZ7iDcX84IT2FouSIa8BVqsJge+E7IXG8oD9gyHnDqXD507efy7B7GREfXCd7Tujz3Ij32J2aDJ94sU+gyv8wRRUUdxkKMm+rMP6v/6JgjWZBF+Hn4oLbDIdwarK04EfvFzkjq8F/Vx4cVWJcU7FBL373oQ3iMx9i+VidMrZtJr3w5AuG2sFw7ieCbfXXUSzpEEgr5gDwvh49eLb3EecyPFbxM4w419m6vpY7czCYmj3rK29faExpRGR4AuBNfZqcT27SoHJtr5Qb6i7yULeqoXXtNA2J7CIDVcqLrkXXGFp9VtobSVvEkPNr5gjHTHuYVY9DqfP6UpNYcQp6Rci1Uy5z0fFaAWgyhXBFOqco8cdFYGcuenfbhCnp+WM+7UMdCnAlX+m4oE+aUCUAkFZzUwy0tE4oRj7YY4Ns5aeCV788DQcX4R/f3ViV0Nr7tVkNd/udegNvM9JeyXDIR4YLNCs+WRL7Diy+ecyBGbcQC1SBdemZSoNruzuW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Askar Safin <safinaskar@gmail.com>:
> Here is output of this script on master:
> https://zerobin.net/?68ef6601ab203a11#7zBZ44AaVKmvRq161MJaOXIXY/5Hiv+hRUxWoqyZ7uE=
[...]
> Also, you will find backtrace in logs above. Disregard it. I think this
> is just some master bug, which is unrelated to our dm-integrity bug.

That WARNING in logs is unrelated bug, which happens always when I hibernate.
I reported it here: https://lore.kernel.org/regressions/20251025050812.421905-1-safinaskar@gmail.com/

-- 
Askar Safin

