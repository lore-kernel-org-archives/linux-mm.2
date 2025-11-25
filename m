Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AC98CFD36E
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 00:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3FD66B0062; Mon, 24 Nov 2025 19:59:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B181F6B0088; Mon, 24 Nov 2025 19:59:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05E66B0089; Mon, 24 Nov 2025 19:59:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C8826B0062
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:59:11 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C023E1A05D0
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 00:59:08 +0000 (UTC)
X-FDA: 84147320376.19.03CB0D6
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id E31AEC000B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 00:59:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernelci-org.20230601.gappssmtp.com header.s=20230601 header.b=MaawkW88
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764032347;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=aF7/Anmsp9eYT32+281AVkISPdChfpfcUc4Qf4hGmPU=;
	b=VSgK/xzUvTJThvbL7qKZSn7GNgsxyMa8kfW6g4YdOGeO/Qly4+/Yu5qvctSyKTohPSDE4Z
	29bL6tzqaJ5zWEnKXtiQAwbCzkLMfhjppRJarNOMULYQTk5NwIqVOSXpB+SQcwzs2BIQAg
	nCMMd8SUw0UdR9ADQdA/QTF7zgn0zbI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernelci-org.20230601.gappssmtp.com header.s=20230601 header.b=MaawkW88;
	spf=none (imf28.hostedemail.com: domain of bot@kernelci.org has no SPF policy when checking 209.85.215.181) smtp.mailfrom=bot@kernelci.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764032347; a=rsa-sha256;
	cv=none;
	b=2YbV/UCGiNpAEKTtYedUGY9Sf0n9RzmJYqUYVzYdtU98yQCi046zkBzTTYRoC0TxWPrn1b
	2p1EufNR0NZ/MsO4UDlQtymXYbeDG5mr09rJ6lpwJYXxSZF/yLHcz1WkPNwAnosOSaMAYC
	P7OC5+zQqVPZQUrgq3c51yQ5utFyPf8=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso3348298a12.3
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20230601.gappssmtp.com; s=20230601; t=1764032346; x=1764637146; darn=kvack.org;
        h=message-id:date:reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aF7/Anmsp9eYT32+281AVkISPdChfpfcUc4Qf4hGmPU=;
        b=MaawkW88b4OFaX3B60o/wGGmIYTOzTNfnzkFe4M+rTb6r0xqjHPPEyMN3qhEMlWrz/
         1lTx6CYHBw1ggfU/pj1kxPnXcaLDdGd4xCzfA8Nn3S3Gy2oIjoJK6Uv0dMB+MyWVvj6t
         9He33qghSsSFHwveeHJfaQPYWcNXqIV5gsSF/I3TJKzcJs47EYGEfwt/1slr2pYvuA7a
         9X8dyYDgVj0+rybt7ze9Gc1wrQr9HcrPRSd6Wib+SfhWbn+rQdUTbsfieWdmMGsgePRJ
         a9VMoNmUASmku+10lLEBNqh7S1Dck1g+D6vqqwfWr9JLf37KezKMOe6STKvvEf5dhKjl
         y7Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764032346; x=1764637146;
        h=message-id:date:reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aF7/Anmsp9eYT32+281AVkISPdChfpfcUc4Qf4hGmPU=;
        b=VeJFlNzcYPsgENL+n5pwLpKNCEPi6Y/Ml63Fldxo7E7cfttSZClSZjiiI06ia1X5q6
         ikpYIqdXmuGTnLR71sUqac/UXcEvB7jJclzVtQ2mgHCCISB+cSKjYJKbbSzdZC0CJH5+
         S5Xug3mybfg16P0EqfbGmZuTVo7ANlFed1WSTUxjlpToshznWWiiqtya6LeNugF/cI4X
         tcEidlTBdXph5nq+MxVS8BFPyORlSZLwYCLUtWS/0P2UGTmJUPEuwN77Nr2ip5yI4ua2
         ZbqmTqCSHlxlwlNSEEZ2MnKfYaRtdP73R2T/zexAK2BpvpLPb5pGr7yh79FVZuAdIg0C
         jl+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVGFlJv8agUYy7XJJKRlTEZC9hS0TR5xo1n2IVrNi5SlT9e4g+JRPIa94x0IW83vjNXZ33OW1OiaA==@kvack.org
X-Gm-Message-State: AOJu0YzEqw8ni0x/Z8Wv3UNMtJOXmqHyKSo8aLJPYA98qk/LMSTnyIXT
	bMckpCWmze84LCQ7UumWDDOR3k5eCIkzkfOqc6pQUVlYVVnVoxuhDHvFSsSuNFbV5sA=
X-Gm-Gg: ASbGncsD4mJzNGRvSApFa+r2T+CkryLUeseVqNP3jcOwFKCetwFcvEwdY4O6yHarVzY
	yz9+akkCxqZ/sM0eAULLnFjvmf9wSQfFGU58C+VQTKWxbQtOgqhogRUAUNDn79wDnVtlfs1t6RV
	uMNtPfVnZY94skqHFfTeAS/x487VqACT+475iRXOrMYBEApYHG10WWIesdOrb4Bx1F5zyR3aIxY
	lLeQMEUqdpqkdjJgqbw1EqFzeT0uW/WLSaHHhkU0UnEGGJ1aozoD11HrbEi3sL5qTqaS5QEolhO
	tvWuXKxNZvO8V2XeugNED8R0wEorj0YcQF2YUv3fWOT+iBUtAr4ogOFBvALWSOnfq68QbJnGlTY
	gz3pKFlupeQJeAj7lHGg/lXP++XcD5YUNfPa1lg0cp9M/2OLcDiVdS17FCxA3S+r0+ntj123akw
	p1UpD8y/vabmOMNM0=
X-Google-Smtp-Source: AGHT+IFL7ZvRkulDOiMdLBmqkzJEIkKMXk50zXJLKYvvhVmGSYK0b0PrHyi1O0zHmsHbYgrdAArNxg==
X-Received: by 2002:a05:7301:4909:b0:2a4:3593:c7d7 with SMTP id 5a478bee46e88-2a7195cbd9fmr8286774eec.23.1764032345518;
        Mon, 24 Nov 2025 16:59:05 -0800 (PST)
Received: from f771fd7c9232 ([20.38.40.137])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a6fc38a66bsm56555295eec.1.2025.11.24.16.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 16:59:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: 
 =?utf-8?q?=5BREGRESSION=5D_rppt/for-kernelci=3A_=28build=29_in_expansion_of_?=
 =?utf-8?q?macro_=E2=80=98array=5Findex=5Fnospec=E2=80=99_in_drivers/ata/lib?=
 =?utf-8?q?ahci=2E=2E=2E=2E?=
From: KernelCI bot <bot@kernelci.org>
To: kernelci-results@groups.io
Cc: gus@collabora.com, rppt@kernel.org, linux-mm@kvack.org
Reply-To: kernelci@lists.linux.dev
Date: Tue, 25 Nov 2025 00:59:03 -0000
Message-ID: <176403234329.318.13946177897504881380@f771fd7c9232>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E31AEC000B
X-Stat-Signature: an5yg39yhu9sayoxkhdhmbp33tbrg7x3
X-Rspam-User: 
X-HE-Tag: 1764032346-540220
X-HE-Meta: U2FsdGVkX19jpMPJN5sT+icRY4aPr8fbBXMmlxTlDlBgnUs75SLLwj/C778NoiBpIJVk1vL1thxte6BnNrQzJ61uij58+YiiG+5lHx8kWVFtEPb7YL31VCze7TmiCBZ7e6cHJsIQQWHYuoox/Jet7BAv/6dEYiT78lwU0GFRWoM7zDmyk4xJuWJSIvd2LPXy13V2QLJ9egzxeT6r/ihFC7Fjq3wX8hiqdq+4G+tbBtGJOmDPG2VpuNyHqZZhwSkJ0Vswer9bpuTMKjtS6lcmAD/XQrCoTj8wf8VzA/fB8nb+rAwY7EPBtfRMlexL1qHWL98kuvzrdFYyMED2dnop+HJOmAS5jXTzxsW7MbLXuW8NHnoiHj/4h+++x/BnKnLU5HHbHsJdI9k0Wn2fD37ZkWK85o/QYKGlwxzxIZfuc8I7BV3KSLuqOsnRKzGoiSm4KYkX9HIbQlUBBHO4bXwEmmoWcC7w4HXwLCczPUlDWdsUrOeG0nkuQv311SNFvdNmb3NHFmfN+pIvH1RS2VPodFlQq9eSlJ1jLSG3DQ2OcaA1Pyzs0yPnaHih23kY553UxU0EZ6kV0I1z92miGzBRU/G487l6yibrItPMMdnHHYqdPxVqbARPSks5Col18EPCPeHuDCTXyJKaqWrsnmII5Cd5WlV3ew519J1t+nTU5X1q9B2pxng+XVwnTEsh5EiwcNv0Pq2G44UMesD310SXHhErnhZ9G1SIyKOvWtNvdIdoI+Pq3Eh62A6vFzTMzu7aW6BjLeH4p9bjJ8tp3awNJgr93fJAp0s4MBFHVjuNranOarhv5mGbxLb3GhqRybiJ53NvMSdhYyw/4vqrYetpotxfRIrRI/sF/3nroE6aTEQ3GzCWcImeReHC6uI0kEAszlM3lwcYdjTQip17KCDdHgTIs8g9Z+DZhD0Zb3PMAm2rlWW9H/Wc/3ZTBnVWwo2JCf/CYh+0YVfUiRhKN1Y
 2X/szLwh
 ibVIW3dXhIQT5nsPSNZ/vJw7O60hjumX9XWTQsl9MrvN5Eiemy27y/JXBYtjGTQGA98RnjGJjEd8otQNsq8vsC6G6abQXvX2/lZWa0nMq6qO8Ptty/Cd9r2JyfAg0Wl2W44ErNyvArauWm5aH/fUwv0a9aO4O0KhcSRlubT+jywXBE+wERZxflG2Ty+dOeoQKOf+y5ceusWl9/Un1GjcgJlrvparITcNsJ/6J7xXJdBAu0M8/iJAIVqtxDuCLPeOLwRcpxyvcs/KpoyVTx2EFYqDbQQK92hjuC/31AYnmD9TeG9nXPPnjT5gl8FdSTmROK5GvH38U+yHWHIMz4orWY45yEiAtKFJozC+v1k+0JaEgs5Utb1RjhOlMFxBGv5Vv4sob6K1y3qFvWQ1aH26SaII4TcO3izhHi6uodjLLnJZXKgBa2mbRvMu7IdVLu4fDWHG7ynclciHICz31oUp7rBjGKo5iWuat6KOz6Fy/dSS31bZAf6eGpKTt9/cIxOZe4SsM6JOH2YVZSCtEHxlWJwpLY7gSC225SS5GUULRxBni4xsQywMqbyyTEkwHcUSvFcw2hNe8X80M9xLqB0YI5la0Fcd2LDg0gdG60j4WOweed9IpwyBwRT/bAhrWe2tfWDvRwIbrJP5zHfWn3PPNnA4nCsbniycXL2TbMmQ7E3udThbL1v+tIh31jIArfU5LZBZCIa2+LceRWGAgpmBtYX9aGPaLuB2Gf54rm7zhYl16DRM/bNzAVK13JgewB/P0CRRScrimUPTVgCrVPxVzwxcoXji7rTLk4EcqRaA7cstOxts=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000818, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>





Hello,

New build issue found on rppt/for-kernelci:

---
 in expansion of macro ‘array_index_nospec’ in drivers/ata/libahci.o (drivers/ata/libahci.c) [logspec:kbuild,kbuild.compiler.note]
---

- dashboard: https://d.kernelci.org/i/maestro:dacc6afb56e50ce22ced82ab876358b9e8e153c1
- giturl: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git
- commit HEAD:  7a1b17aedd2aad3a04a211865f048903bd47fedd



Log excerpt:
=====================================================
drivers/ata/libahci.c:1161:23: note: in expansion of macro ‘array_index_nospec’
 1161 |                 pmp = array_index_nospec(pmp, EM_MAX_SLOTS);
      |                       ^~~~~~~~~~~~~~~~~~
  CC      drivers/gpu/drm/drm_gem_atomic_helper.o

=====================================================


# Builds where the incident occurred:

## multi_v7_defconfig on (arm):
- compiler: gcc-14
- config: https://files.kernelci.org/kbuild-gcc-14-arm-6924fcf1f5b8743b1f5fa552/.config
- dashboard: https://d.kernelci.org/build/maestro:6924fcf1f5b8743b1f5fa552


#kernelci issue maestro:dacc6afb56e50ce22ced82ab876358b9e8e153c1

Reported-by: kernelci.org bot <bot@kernelci.org>

--
This is an experimental report format. Please send feedback in!
Talk to us at kernelci@lists.linux.dev

Made with love by the KernelCI team - https://kernelci.org

