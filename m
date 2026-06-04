Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF316CD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 23:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B018F6B0005; Thu,  4 Jun 2026 19:25:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9266B0088; Thu,  4 Jun 2026 19:25:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF1D6B008A; Thu,  4 Jun 2026 19:25:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DCF86B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:25:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 319A81C0C85
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:25:27 +0000 (UTC)
X-FDA: 84843813894.21.22E71B8
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5502020007
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:25:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HSZfHBqw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780615525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=afznK2o04gyhM0m9icIwY9Iwej89NrlffaDAhI1G0qM=;
	b=hfebc87xOSaK7kptF51JvhUK5qLzitOSLjqVrNd+CSgKa6z60dA453p1AJJYpk2D4+M3Dm
	xapeLi/TL8zdfAiwN1miQcuThwB48WNukODgTmNxeFByOdMUQHHcFhN9g/Kz2wxMYrrJ9d
	NMJqg6zIvPysMQ9yfj0gG2h0c/dgyFQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HSZfHBqw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780615525;
	b=tYBZ23iNb0NXSkuhvX5HozpNt64hVGGBK63LVatiiXaxOLGPb7LAFtWK1jEBdExXZ29j0L
	IKJrtAXc4tm5O7NNIC3NsBh9ZuHCACuwRSoaPQ9P5KLxnnsHMrwkHjQrvIeig7zw70Bqwx
	m+Dif5KfYXCY5Qzdhd7pW3S4AExFsjU=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-45ef372c58aso762630f8f.0
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 16:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780615524; x=1781220324; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=afznK2o04gyhM0m9icIwY9Iwej89NrlffaDAhI1G0qM=;
        b=HSZfHBqws0bUOik5Yg/vJf+PULEH/xsnIdXyCFqJcfod4nW2/2ToJoOwmrNaX5yENw
         Xw8RUZvuBl2ElHRavvxcloiBACg+sxj2LlM6XSZcJksryfSwwAo7JjtTjM0ERa6ZsQBP
         oFu+KAS8b+obKJyl26Yhxys7b9OV8SxlaSn6ZhVJhcg3+SIclxZ1/jRFcRLczEsl7J2e
         4ldoZlfrxrD2zgMna3Aqs9qNiJJBeRa884Ni3WuI4SzeaFD121RqLWWxkN0to0I98SXR
         EgU2J7kUADIDkgpOEFEmclBg/2BbGhAiKFFviN3gWZbfs14iXw60+xj8GEHl6tSeC5NC
         zkNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780615524; x=1781220324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=afznK2o04gyhM0m9icIwY9Iwej89NrlffaDAhI1G0qM=;
        b=nlxIWVDLQu6bFILmuOSF75tcYbQIncbFe+LBqZsaIWa2UQJU30e5/8miDO+KZxrjcU
         zWj17vLcxjsmzevLOohS+C8qzc6qOgozF3qSKbfakLNErKRHCUoC5uhZUyH2IGgZvrMd
         CRPs/Gy8OWBSAyYr4cD3OlmIdVtFPPG9BVfRAFd2bN7iSqwbayRo3ZbvDH5cguNJnKWo
         kgEIFrH8cR+lRLGbODzd5VVongJ/JX5zJn7ZeKNUaCb0ObF7TgxsatfTsZdDGUSqrqt3
         i4k5Ptb0fguiyjFmcnVG2FD2THB07VezaUVFQOVFWizUFSL86hJaHm48iVha2vLjKevX
         YwXg==
X-Forwarded-Encrypted: i=1; AFNElJ9Z6m6Ld1Gl2dFQnCijiE9FfaIQvZMj7bzOX1Or2+vY7HkBHAuyU6HOHEfZa1lFUmj5Spptz9QEWg==@kvack.org
X-Gm-Message-State: AOJu0YyHHbCiE03WR1HTRwZpP8HAxOz1dTANhHkESoaBRb8F6WYlvHJF
	Y4fK1wRI/VluyZfQL05t6b/PxHBACdgbGx71CwhG27gK15CH/jZQg30j
X-Gm-Gg: Acq92OHjmaDNaHatqY/EdZSdZgyy6VrBbnHVzsxPj1Ozttr3kMI6WiRKJSz9C4CtIeC
	2SDTwt7Pl1C1yDTMxtPJi7iQnK3p2WnWrHgAJuW2uK8o7mzNkL3DhxKoQEbW6E9RDxocnoDz7ZK
	p4uqqpnRtxZrBvHVCO7Hprps7epb7JXX6to0RXa+SHMxSvBJin27kS2q1Hpr5FMliqSwEjMbx7e
	1aEqmVZENWVLhY/W4ZfXkGh5HGWydvLuqGeTfnmZMDIwb7Vqqz2PxOk0HLOZX8Tkz1lHEn6MbWE
	b40LoMjShMde0b3X7MMKLPyDs8LmfwZavdn9J3Uq2+qhanMoALOfJt7j+VEM7r/KuEOcIgE5rEK
	tuE8FWr9yhkoFKTlAgdZOoOAK/8vD5sdqo9svZ4Qe4d92F1K5j1zUNO/ECOs4HrGmoYzpmF4oEn
	oVxquxayfbkSszLx1LvjWRy+7WOJI9Dw==
X-Received: by 2002:a5d:4e49:0:b0:460:1ab4:6623 with SMTP id ffacd0b85a97d-460306429a0mr1128044f8f.27.1780615523601;
        Thu, 04 Jun 2026 16:25:23 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4601f3529e0sm20375107f8f.28.2026.06.04.16.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 16:25:23 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: david.laight.linux@gmail.com
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	hch@infradead.org,
	jack@suse.cz,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	metze@samba.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Fri,  5 Jun 2026 02:25:18 +0300
Message-ID: <20260604232518.1896014-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260604183829.63c35fd9@pumpkin>
References: <20260604183829.63c35fd9@pumpkin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5502020007
X-Stat-Signature: gn7jxkagmofo1jgu11hde3qrtcpremf1
X-Rspam-User: 
X-HE-Tag: 1780615525-625264
X-HE-Meta: U2FsdGVkX1+E25jFMNQubdvgT6cglzLskWGC3RsoCotxqDIn5G8MxJmfJJzM89R1mpmFP7foYXtQVwNTSCFGe10rbeuFrkjlmPPMCT4wtg4YKUriQ3iw0xBqoCvmxCbhanbg2yzGBJrSC8QERaQi2n/EyB34ntJZEwq8pt+3++myG+C7HcO+8Hrd0SIBBq+OZwqyyi6ZOci8zaLnNoI0J3ya2Bm7Y2XA9Z4evJnnGUWOFOnj/3V1D64YRvsxEfAt7Zw64pgkzwD0uWwdUd8idWotnL/E3IZONU1y+RUEMOP8gQ4On/BpjeUzX27etc1fX7uTP6yn7C4dxiBMq5BRLAiZ9uGcSk98pPzpkjrGTgJutiIgDsir8SE8IsC+F4t0JGg6jvkH4s1MrYbJaR/zw3i/5ixuuPd8R+HidfpVv62+4JpjTw4QO1jjh3Lt8Vipc0P/cNQPtb02wLmnjK4EYB4vmsLHk3lFxwpgh2axQPmLsfxSqi2oAenzPNPc5DmVG596Gb+47xlXumX7dlKIoRxAIVkCZK8bihzz+urNXptyhbYACz4eM7E7/hsNRp5Cog1acaqZlZXGwjSXaI2AIXXh3FiBQxeU8xlr8Jzey+ljBQI4m+47THyEy8A+Uoa1cAB1mz+ViwnWY30AtH0dQoUlrgYwg3N72Cltpo4D6Rcxn6SiE2qVgNZY31tNMBv73c5uDGtthsjg/CAsO0e2ksgAOJZ0o7E+Kb2LDWFHX+aBkFdlvWhO52P3XqibNHDlnvvkAfz7n9IZehO4ddSS2SoBpBoFfNV+OU1ElvkLaPQ5Mq4OKgSGNXhNtsM2eUJz51q5UA20DoXdW/56Pr5E80eEKOY44Y8vLkYbYpfKTrtESc/JLZLPyQfUYTX6sk8j0I6iPqJVDOv8R4fQUUG0obbU4O/7kk640Dbr0TsTQ9h1DudqFRoJeyWIv7uZUF24Aj3qd1kGTOr8qfoFPZ2
 N4c2Wmmm
 bN+JL83nlvbMxRYJ6Gf+e3mLe5trcdPyCgCZNDVGxcgSc8Nzn2ITY293NIwsGF0Bt81UM5Xz3GOox6iQewKuZARfIMOjHqcRwhzxZ6WOqUChldX4jWHtQ2ZKKYvK5zrB4FdEkSB0PGm3uQ1SSwQs6EN3u9Su+xlgm+D5mRmJRMUlYg+aa8R3fEMp8TId3OsM5H4pU8p/vLG9+7oTLXLtTxArb4/gvceP/qsmm5KXsDUWTvbNf3L6btyzktipkpwgFIMnbu0Yyb0kw3nbU1PZUI5tJmU4jx27Dks+pTjKEEDilZj3DveN9JGbdFZvJKiCbgsBG4v+KMhrAMRub8I0BfNnjk3Q7tGSyR8pX4QdwjKA0WQmkOei+FBwclW62PHIcqxFZcPvhEmyU+TwQCc6w/34Df0uh951t8llZzMn4VCmQPue420VIKyMqQqU1N+/gfsPVUzuNv+kioNnCM9fmzpdQXWWZRpx7rL5c+fHHgNrK4fHlkGbEIcEfuzjJ19BVxzOUZtwTW/eyBnY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Laight <david.laight.linux@gmail.com>:
> I know it has mattered elsewhere, and is easy to get wrong because
> 'mostly it works'.

I will send a patch, which will change that argument back to "int".
Hopefully today.
Also I will add that "wait_for_space".

-- 
Askar Safin

