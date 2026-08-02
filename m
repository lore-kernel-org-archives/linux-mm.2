Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5DB5C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 23:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30A886B0088; Sun,  2 Aug 2026 19:38:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E27C6B008A; Sun,  2 Aug 2026 19:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A9EC6B0092; Sun,  2 Aug 2026 19:38:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E62816B0088
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:38:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DB1F1A05B8
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 23:38:22 +0000 (UTC)
X-FDA: 85057945644.17.1879D07
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8B002120004
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 23:38:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hVV0uJly;
	spf=pass (imf29.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785713900;
	b=T1R+9BrFIjCZCUQgOZfofKCcZgNNbl/k1FKlbsxvzzvc/E0sE2uFE7li7Q+xn6pw6+k/da
	BjoIhmBUUmtpHyZXvKHyi9Z6Sk5oHXbksN0s+kNoXlfXv4YMxSWYGNywnyx9sTfdv9B9uS
	irgT+w9OyPAv6xcdtNjUSYM1sNxaf8U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hVV0uJly;
	spf=pass (imf29.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785713900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WjoUynZVyetLFo7x/yUba6Zt9rYMhRjBHXBxc2twQlQ=;
	b=IJFN3dOJnwpORNHXJe8+XWSzP2xitw3uX+0wa1P+9EChdoKtbKOTglFAn1/23ReoXakNGF
	iDKtxV1x50VEZmZZfYDl7bEKSBzEZ6UEH8O1lQnsx+Q8dEd1N6BTaiCyunzB2CXFV+N+l3
	DtxiPv/RefkjD6l/qMbXf1OXcNjuV3w=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cf52d15d88so22377845ad.2
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 16:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785713899; x=1786318699; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WjoUynZVyetLFo7x/yUba6Zt9rYMhRjBHXBxc2twQlQ=;
        b=hVV0uJlyBSH8oTaesfs6ntLac509wtLKUd9zUtqOCuh7AVcGlHPThTsPYqtZNx+BUg
         T9s0SwvhdEJf4UqRNrGAFC91uJuWO9Cuzn/908Dghv18K3Ab/TBoQvz96eCV4bYemRg3
         RKB0yk6+oGYGczUkqzjxOGqCgNUlcXAgGmaOn+uoxsuPqOGxS58AyGd2JQl99BPmIJYH
         Hlt12kMdZk7a6N4RZSlWANYR+VpSTs10euf7eL5dUPjfTYvwGk55W76YfdS5PkI/HBDf
         Z+rMHGdaqtlBN2oemDGim17axeUGTS+/YNxO95GPTvJkC5gwnXv7BsZMvE7dlIWh3D75
         0J1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785713899; x=1786318699;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WjoUynZVyetLFo7x/yUba6Zt9rYMhRjBHXBxc2twQlQ=;
        b=MM9sUbyfp/nONKiyXlsVs5mUgOAPZ2PQ2t6mFIzSBcdjTbqms/rRgkAvYWFXu6ms72
         JIiakqFKnh0j0p1khma7Ee4c5LzlPIMtGofcuIdrlvDVI/ON8bHu+6Y2OXCT8jFUDffR
         nNkqxSZ+ucMnFycaRj52+V12CmR3mIokWeP8dcbSFPb9LrzavONG3FIrnW0ePB/7fGcw
         R3EWeW/o0T7Hm7Bs/N8JV83IZS4DM4JM5yHD3Yz+hR6znnlbZMd4qtftG3PyxgBZWZY4
         rlE41gNIkJ/lumOQQdkFMuOMqkL5jwPexLWcQD2JpcFjEjK49OHSOPB0tgt1bh8nihOt
         SA7w==
X-Forwarded-Encrypted: i=1; AHgh+RrJrrYzb6ZghQxwEyj+QyjAC61zSLvz+IOsQeWffJ0FMmfL3Vqkq139VcyZprBS6ERL20+/d8jCZQ==@kvack.org
X-Gm-Message-State: AOJu0YwdrX9rCbRdLV5g8xDMymT2Ew7G2CmSIGNs68eIWCwVJSAAATrY
	Cb9I/lcAlRmSOUPQiT4Proeg/ZBfSZDMCqOn1yOAKYKbQO89C6eQd+WM
X-Gm-Gg: AR+sD10gch9FRP2JpsOjBD+k0aAhG6d8pyTi1yPK8NBAWXx/LFHdY9QSUQjk7Q53gqV
	SRHsKDSQWr6YNuu4+/JgSb7r0SVPAubxqObHfprn5IAG9uaAr+3x8BUhxY1Wgjcm5OSzlIXPGz/
	s/lVwdpmEbi0O1oPQ9xVvu36ODNtACC2ZwPOrT5iv9z742tleWlzpI9EcbzuQ74Diigtljfdo9l
	i4eCDdaTDCt5rPb3PXkqrhwh29K38oZmQ+ZKBqWm3Udf4b362E/a4nRIAYaavpuFu89dj3Ri9Iv
	aDk1XQxxDy6xGRhf7bQbjw4X/c6eiNkgbMBjf+Ayv4fKWeKRtLYW23MDc2Ar+EA7bsBH/k2jNE0
	8JYt0EcChAbqrThmvzzW2Pz//1zxhjkRlZi9SKYMprncUlaK8uEEao0qoIFEPVrw9COEasT6aMU
	TdH8sTGnXRovICLxUBKv5cq8uTHhaGsZV5EtBUkV4jjXyB53gJI8cA7bF6nZebB/fmxXkciDZCI
	w955Q==
X-Received: by 2002:a17:90b:56cc:b0:38e:69ae:7148 with SMTP id 98e67ed59e1d1-38fbc4d966amr6898529a91.24.1785713899432;
        Sun, 02 Aug 2026 16:38:19 -0700 (PDT)
Received: from [127.0.0.2] ([73.222.46.22])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fab4e44bcsm35070094c88.12.2026.08.02.16.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 16:38:18 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/9] selftests/exec: let binfmt_flag_supported() return
 a bool
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 bpf@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
 jannh@google.com, mail@johnericson.me
In-Reply-To: <20260730-work-binfmt_misc-preopen-v1-2-4a0b0da71f16@kernel.org>
References: <20260730-work-binfmt_misc-preopen-v1-0-4a0b0da71f16@kernel.org>
 <20260730-work-binfmt_misc-preopen-v1-2-4a0b0da71f16@kernel.org>
Date: Sun, 02 Aug 2026 16:37:58 -0700
Message-Id: <178571387899.1880415.16506772757157668104.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8B002120004
X-Stat-Signature: khnr4f1zyzmzptnjruponqz4dxkbf4mo
X-Rspam-User: 
X-HE-Tag: 1785713900-114434
X-HE-Meta: U2FsdGVkX18ONWr+qMpkk4TVC7Rpq7dpX/JqLxpA9ubUedCpp2SBWnAJp7n+08xZtWXkGFZyohv3XeDH/h/F/uhXPB72GNSZ7Rc5tSVJytRGfQm6GCjZG5TwWveZASwjHWP9fBPiLQOLQEmgzrk9h9UsVSZqpf2lNcWhqOM6qBOXwkJ0BJhoVVw7lMPW6Ouf5YrIc7VxQQkC3tRRm3s4ym8GFiw1ihdBNunyZrPu6MNZGbDN8YvxFttc7xbv/AmMXBg0k9jIZzMVQxkUJ6POB0zgOg0xRQ2c/UcleNV07TX4ntliAH8uwnSqDvsgkguAecdD9yaBFrX3I0YbTwZa9+v5uXCOE3kT/2fj8yIRWn6qnaUvJqqlcijrPuKj1d6OmBeAet/9QDclwzMQvhzL8JYrNMMH/wgY126uwR6ALqY9zJM/Oe1zdSMCeT5UrFwWjcOxyz+hmhxyGk8AHq6H+IFSQEQnoD1e7XUiqOrfxeSSb7AsZCn+9U9YL0Qw9jdiRAaYd055C7CYpt+n9V0IjbsnzuvKSVcE8BHjv4HjLnqAYDERBLQ1u2TFzsPEbP3bggtcMnbWgy8VXZuRxZKuddq1BXPYMoH/lL79G4ZPMtd9jo62dWLAllOuhK84uplPEkJEHTmhxK0cwc4kk/Os8dzZqJ4M8Pq4OCMsndbw1KIrOGt/I/8xXaHbQfkFxCf9Rtwl0mCwMNPKqnBb8b8+43+G+QutjLg+ZveM++I3wQtOWNDLdd7PO/d0PM9Kt8k4ugqLCRpaqBGMHLeOvX2Q0FDAkbiodlynrxCdg3CGcxMlBpAXEtAso+RCVDBWIEk61LRy0GC488pbobf2ImUit6iNkJc+dHOV/xvjWHpTwL8/Fc4EN/Mm4eZkXwhiXUMMz4Qqsj0+emxM/wGCp0SWG5lV2CizkagCmZ4mcF4mYj5mfHtafV/Ks7mI1YvCG8dCfjgrcdnjDkvuBdZ0slZ
 X1QwUzgt
 oIh0q8PX4JGHngpC/zaXGcE2GvLgyNqMcBIvQrXOVVJbA+G9bNDR3jutlY01yzLoYD/kVKrYpL4G1cmIXtjyabRXl0oxNqAAkEkAmQVuhoIcemRyZPlDE/burXHJ/58JrTE7yp4zxmBgfZ59kY3aEAujLqpMUL5YZKAkUwCdi698G7HWSqMnfOunkSgjk0ICNe+Zvod5UavkNTbAC7NhANRpTtJSxchPHlS/udgTHgZKvYcGOqi/SiI8SpX9/718FM8SMxax3LSZ+ijiRtfsJ/5Y7njVUUhBsuP7q0ZyYNyrPYP0CQK4nk8cWx1G39sE8odwB5LTkkNsqZ2Tk9ymC12Zp7kqw4CzbJZPhZqsCb/+3iPFnO/cS5JyNL+diWrE2j/fhDUbntNIiszBMBcIJz6ndR7+8IdHBxl/a9DTp6wGlDNPWnuN/p5elS1pDds3GJcGgGScfNmxEnwLMUnjL/BJlWLWX8QBn7EYB4HxFRqoXIcqUrjQfM9QPKo4jBtJcV8Xsx3AK6BCV2AVv/pz0FV9qz0syjgoefrbTeVElb+XXbS6PlVpYJSCA4+ci5U60IUWD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Jul 2026 15:34:04 +0200, Christian Brauner <brauner@kernel.org> wrote:
> binfmt_flag_supported() returns 0 when the flag is supported and -1
> when it is not, so every caller reads backwards:
> 
> 	if (binfmt_flag_supported('T'))
> 		SKIP(return, "kernel without the 'T' flag");
> 
> Make it return a bool and flip the callers. errno from a failed probe
> is still set for callers that check it.
> 
> [...]

Reviewed-by: Farid Zakaria <farid.m.zakaria@gmail.com>

-- 
Farid Zakaria <farid.m.zakaria@gmail.com>

