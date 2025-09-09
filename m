Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B2EBCAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 17:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ABF58E000E; Tue,  9 Sep 2025 13:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7825A8E000C; Tue,  9 Sep 2025 13:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 697B68E000E; Tue,  9 Sep 2025 13:28:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 59E328E000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:28:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DBAE811A5EF
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 17:28:10 +0000 (UTC)
X-FDA: 83870395140.07.EADF939
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0719E180006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 17:28:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="UQI/uVrn";
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757438889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=26M4MA/dTjFS6RXtLeG5uBUOvfK1ST1woOlsQ4o+SDw=;
	b=KEXCB3TgIMRrL9ChzDJyj3w92xIouplzRuotX8+Z+JsSfwl/UFGSZ9yvYmI5ru8XeXo1zS
	gfY81NI20cctDl8I4ia/A2As3DZO4EQQVNeyfqVZY3It7+wbsEe3zWLUkJi6NCVphw6jgm
	DzYvcgy4t0ztfIAGk3YX2gtSrYam3hA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="UQI/uVrn";
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757438889; a=rsa-sha256;
	cv=none;
	b=J1VczY8MTe2GvsCNuxYFjaZZVSdlAUPJ1WNN8tVPtg1c8WXCIIsGKjI/LthrPILclOjBQ4
	luk2khNPfaV2HkhkWgVXoLHINZ2ZDfqEvX7IKl6gd8QwFFfSm1XcjthTWEEGBqG7yYKvcL
	+XQNz2L/qXeal43taTckT/2aPF+YWpY=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b6004da52bso28501001cf.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 10:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1757438888; x=1758043688; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=26M4MA/dTjFS6RXtLeG5uBUOvfK1ST1woOlsQ4o+SDw=;
        b=UQI/uVrnncu3t8PSZsqxjaIJnl+DLKn6Er5SA3Q00/9QDXrO5JgTepBJqENbQYXSFP
         eed4Ez7/89HbqzJlp4iAbLT5CIfY89NigEkI2iBdESe8Jgv+i9703W/Q+BhmZq4Lj4ks
         NncYFrGDOsA5er/XIkPZNirSC2/Z5sNWKR7FVO+K4G3V1h3Y4wET0lGpSPjLD5c8IJW3
         NTwOyjeFx3UBZ4zVmCYJMdvGOWeyxPjicCXR9ip2O33dgrXAKKJKwLemxazTsTcA8IHU
         7TyoQ5qblwBLEDFgFpVorZpXeBUL5K7YZGZrG4je+c1+j8dvJ1D1YLGDvf7yEuZUgTgg
         6RXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757438888; x=1758043688;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=26M4MA/dTjFS6RXtLeG5uBUOvfK1ST1woOlsQ4o+SDw=;
        b=qWn6agdw3Lc2jPbothXoOa5KxyMFmK85SBkbWPUWPUk9LmCQsBavOLu5n6EV9H7nnW
         jbr/21ZGvedwwnYvsve/wAsdLcCbJ6B00pn50OeFzPn/mBLgLVPlCHF0WRqdHJvvoo0I
         ou+jdf4zhCqW2rOOcFe8CgmQ0OLMSfUNnGFkww3rrL13257dkhKu96pw3YmyfYMwu2ZT
         TaD1xwGFN9fo4AIpWOsolZi2i8YlUNmolgpCrR1HA2wIGTW+krPIKR9LpXdP8WL75c5P
         DxvbFCy4FG6q2NeBeSAsQa5jBj7CdnOHnVvf3dQEmmWwYtb6uXJ3rSYH6oXxMuLke3MM
         3a6A==
X-Forwarded-Encrypted: i=1; AJvYcCUYQCggDkkKYRaM9CekTAaGGFpFB8CcU8EwpGfN08Ex7BlfOjFWdBMD+karz7UuZG9esEVCpTFt7g==@kvack.org
X-Gm-Message-State: AOJu0YxmpTNlmxgygl9QWxB8/9ywtmCNv1CgZ9ehipX35oQ4ZNEzNKaT
	J3pJeqvbFBo/9CN2KJbI1o22o2vkDNpOM56ul5LD9ZPz+TrRDaEBYibKc6b2sNFBN1diZRh8qmp
	FUvtVqAmENg6Zyn2YvB9AWe3FDYqWlLBHiK8tNr9PVA==
X-Gm-Gg: ASbGncteXJqLbM6/qL5ee2n2BMcM1qz6/ak6VB2QslvYq9+wP3n8uImBYxc95Bsy6FE
	Fz413PBQXapPTQe2ZaRsRLHIMRLIv+bpQ8uyNXDQ3yn1tAOyHHN9mBYZhKymO/6hXQfCPxSOpKi
	k5++vVTHMtdmrNfYeumxMxxe7AVl87W6R6A+d1Pfg6u/q+XCb1KBGHUmWYUMaEezWW+OagjsnEf
	stcxRsLsnU2dsc=
X-Google-Smtp-Source: AGHT+IE7B3CcFEssDe4XL9VRsiu2ZVtPT1/IDpeG+lIelORf8xEKlj0sqrJaLJ7LEospzMuqfY3+hEvX2rVlLb2YGYI=
X-Received: by 2002:a05:622a:5915:b0:4b5:ec8a:a0a2 with SMTP id
 d75a77b69052e-4b5f847e52cmr164807881cf.32.1757438887951; Tue, 09 Sep 2025
 10:28:07 -0700 (PDT)
MIME-Version: 1.0
References: <mafs0h5xmw12a.fsf@kernel.org> <20250902134846.GN186519@nvidia.com>
 <mafs0v7lzvd7m.fsf@kernel.org> <20250903150157.GH470103@nvidia.com>
 <mafs0a53av0hs.fsf@kernel.org> <20250904144240.GO470103@nvidia.com>
 <mafs0cy7zllsn.fsf@yadavpratyush.com> <CA+CK2bAKL-gyER2abOV-f4M6HOx9=xDE+=jtcDL6YFbQf1-6og@mail.gmail.com>
 <20250909155407.GO789684@nvidia.com> <CA+CK2bAvxvXKKanKzMZYrknBnVBUGBwYmgXppdiPbotbXRkGeQ@mail.gmail.com>
 <20250909165718.GP789684@nvidia.com>
In-Reply-To: <20250909165718.GP789684@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 9 Sep 2025 13:27:28 -0400
X-Gm-Features: Ac12FXyDOO8j6_d8TOe427ZRqpXdtWpY2e6HlPY_G5_tWsFdybukjZ54PUO6RWA
Message-ID: <CA+CK2bBcX08kqmT3gKERdRDWBrfO2+N_LgQ00D3SRXv=bippHQ@mail.gmail.com>
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pratyush Yadav <me@yadavpratyush.com>, Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com, 
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0719E180006
X-Stat-Signature: u9mfgtdwdz9jrsa11qgzxix46s9huepm
X-HE-Tag: 1757438888-15876
X-HE-Meta: U2FsdGVkX1+vQYRCHJuVwBULYraAQol+hkRN5DVPi1JVtzKwE7Kd2aSiusda1zr0gcxLzEljVuZ+tbjgMvObPhfWppeUXseiG05PUJN8HUq+DB/Ng6wI2QwHlBlw7Hkx/xFehcSk89qUa/PE8W3cSQ8vQBrX6SV6KPcge9Q5cWYW2R5OrwctO+yENL3Ha/GhE8g2WwW+zZpa9fELxvkNTKV+LV/XNmATfqnmshUtS1OyX0L6BsTXvTJxXSTxR0dGA98S8Pug3ve3R7NQYphD+aUdQbnHkkYCZI0QGiH88fIRQ/s9MIgqimtehxCMqe9OwRWQhL+T2dBcgH/24ylck1HttuQBAmBVY7oBazPR16ajkMiw4J3o7DqjmbdrMAMp5nAVrDaa2HHp/zlAnQ4oeCVGQbxuhzKqza22iPFtM9gnTWUp2v/WLOQQLNkXXdb6S32wZmtelM9idTbX6xqhwrMyfqDcSM6LmNVK/A0o0Axug5YvmqCS6V3NImY59N+2CpkeeTCa4fbMHUQfVxEj7yZNGa3ot6QO87JB/n5OvpO4uNNVSYqgViAlcMwjUCtPoQK0FQ+tK1DRcOHmv64uCCP6wyA7ef9/NrNFSTHtI2Yr8mWjqjEurbeU1irF/z0ZaTMaq+Jcrl8LBOcez2ttElvbWnT5qTb2ehm+c32FGm82AtpfGAoBrDKEnHTZzQq6Jv7KP8W13La0upfOzYJ3ggRqQAMa8fQUpcNHQ4pH18LjkLCijrU/ArvnW4GZo1/FI6p+dH3aS7UDedtXe3mXlHDRejSt5q5f7VHsozbiLWUwxMtHdTt33zHMw3+89UV9qRSj03CptAIEVcVP1ulXqGknKodbgGBqpFsZW6QHIUm5ZKBk8OJHlCBXQh86qWMrnq8gy5eE3dlyxp1scj9P606/GKKniAmE/VYoDvk5h12wzVGmUb/Jn9yi13TfYyRBJDScGROi3HmbqmMoJWg
 BL8in9LM
 f+a88rjawlSYB2iemq4y96NqcdH3K+fn2G+RYH7oO9xffFe07IiJT1qLd8ky6kDOwB4aWIRYgVd866nmBJLJuCbL4WyIzMM3veJxVBtf83+WkBw+r/dI7zLdCUVpT/FwIgInzcjgVFDevQDgkQ2p4pWDbaVQ6DW/5r2hEzjp9n0aCo3gF/2t956EMeQh5n1++JH1Kj6c/btzjLSeS7PN0bP0uuvab+cxvFPgtdT01DmrIQA4Eus8sxLh1cWHQ0u47jQFOdHy1bG+gwmH0l6lHgEz5f/B4+gHhg71G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Yes, but lets design things to have this kind of logical code model
> where there are specific serializations, with specific versions that
> are at least discoverably by greping for some struct luo_xxx_ops or
> whatever.
>
> Let's avoid open coding versioning stuff where it is hard to find and
> hard to later make a manifest out of

Fully agreed, the versioning has to be centralized (not open coded,
and verified in a single place) & discoverable.

>
> Jason
>

