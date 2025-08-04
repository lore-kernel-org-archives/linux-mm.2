Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC16C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 18:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 304976B007B; Mon,  4 Aug 2025 14:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DCA06B00A7; Mon,  4 Aug 2025 14:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219206B00A8; Mon,  4 Aug 2025 14:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 11E4E6B007B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:31:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AEBB8115737
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 18:31:26 +0000 (UTC)
X-FDA: 83739917772.24.A06391D
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf02.hostedemail.com (Postfix) with ESMTP id 08A2F8000C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 18:31:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r65dpNld;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3e_yQaAcKCAQn2iwgewksskpi.gsqpmry1-qqozego.svk@flex--jyescas.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3e_yQaAcKCAQn2iwgewksskpi.gsqpmry1-qqozego.svk@flex--jyescas.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754332285; a=rsa-sha256;
	cv=none;
	b=vPSWtlpKGChtbeh/zwiqOBRyBc/KW0zeDE4hWTJ+Qdq6Mb7GuF05PqKIMRPIjtqoqD4Ttm
	xk49S7IO85TOe+Vt3Tp1h7JrvgeAwEPLHU0JWdBoBWE0rxhPU4uMcJ8Ro3Yg5yAirOY8qR
	pHNEhiagPfbEit+0g1evbtsTuo9rXYg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r65dpNld;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3e_yQaAcKCAQn2iwgewksskpi.gsqpmry1-qqozego.svk@flex--jyescas.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3e_yQaAcKCAQn2iwgewksskpi.gsqpmry1-qqozego.svk@flex--jyescas.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754332285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ZVlhV6ndThCFd4+zGJNIWInZ4a60Ev1vYWmuIdzmJ4=;
	b=syDXL5LZz30HF9FPHCm1n8ECtJlkkrwUtmU+3J3WjEU6QltLZG7b0ZaeRtfjAJor3U/REx
	LNQxN8liFIBPviXSozgY+oG22PBziZRHDTkunlZ1Kff4A/snKCuxW4oVx2rW9LTVh2ULTu
	TX0vmeb90D0SxdOYUIrefSesJ8YR/e0=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2400cbd4241so65940645ad.3
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 11:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754332284; x=1754937084; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2ZVlhV6ndThCFd4+zGJNIWInZ4a60Ev1vYWmuIdzmJ4=;
        b=r65dpNlderDDqWPgfodt318sQ12apLkSxFdJ6xzZ+HTLMIALgF09cyVoNaflvccyRh
         AW2NKNCTmYLjaQXZb/jgxIiz+az6ykVw/g79dMlbIeLshjAUDqRCXHY5EYJJ2/g9xW5T
         bQ2bgDIH5IFB31mocaqkZGAVXAOSG3IibxF6wo+ZjmoCC8kxxZjSrbbJaN3Ncc+ReL0j
         xjKbemGP5rDXEDkTYsXzdLAzd+1iumFqUeG4pKFPpiOqvAfq3rLrfm7GT0q/2Ogmbe6b
         btSYn2LofQVTZEBKzH7hmQBnGR3ekGGaLAy243ZCFHuMvl/E52UsGypUH+AkIyaS/7dQ
         DXyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754332284; x=1754937084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ZVlhV6ndThCFd4+zGJNIWInZ4a60Ev1vYWmuIdzmJ4=;
        b=col8FasklCMAUItbWc4NtwdyYoJ8zcsOab81dHQwXZibaDGLV2m4v8bd9YkRsSRJq4
         2GsIJ/b3CHS1PMlaLj2BG++lC7c9+Ga5n+UYSDhsha/UT/QVDwo5lqUzxbERKS69/Ch1
         m3ffSd0QUvW7L3hk9by5YwmQfgQy+Q5otqFSjz6ToXcRXo0iKXb4/XIA9DT8ZiGCaRBM
         EaWVkdqzJkQ62C0EW7U4IkYI5UJU/Mo8x5Wwxuf9o1AooGRze0TBa+nBx7ESSmXUajGQ
         MPpkQhWDGjiqdG6ZTPKQH2NoW5YMew67kb9N9vFjv7Wz7hkrrHogfCTlahUancE7Z4Ni
         XJ6A==
X-Forwarded-Encrypted: i=1; AJvYcCU8DDH7aaVlOyMiNQ7onZZge1H3B3E2wFV5kMC/+V424iKb+LcRPf6DbnRUh87mLUzdKuehHTg3lQ==@kvack.org
X-Gm-Message-State: AOJu0Yw4EGqcWms23BjJ36pnW7IPkLxAvpHq8bUQc/wSDAOH7J0IvI3g
	fBJyWGzRY5Gh+IjmnjMQ8iIKJ+CpsF/Qmbo56tnTtrhBcMWQWPTw9i5+235MYm48zsjuqIGAJhA
	jg4GEQEfcEg==
X-Google-Smtp-Source: AGHT+IHWBu3VQz8pzZ+1rcfbz3HxJNSMQP0rdBf6OTWgijBCozRjoOUWrc/UH4pOKHcnDrH55Kq6u4Oao4QE
X-Received: from plgw17.prod.google.com ([2002:a17:902:e891:b0:23f:fded:852b])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d506:b0:240:52c8:2556
 with SMTP id d9443c01a7336-24247023afamr130598435ad.39.1754332283728; Mon, 04
 Aug 2025 11:31:23 -0700 (PDT)
Date: Mon,  4 Aug 2025 11:31:21 -0700
In-Reply-To: <67a54f31-e568-427a-8fc8-9791fd34e11b@redhat.com>
Mime-Version: 1.0
References: <67a54f31-e568-427a-8fc8-9791fd34e11b@redhat.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250804183121.2892827-1-jyescas@google.com>
Subject: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
From: Juan Yescas <jyescas@google.com>
To: david@redhat.com
Cc: akash.tyagi@mediatek.com, akpm@linux-foundation.org, 
	angelogioacchino.delregno@collabora.com, hannes@cmpxchg.org, 
	jackmanb@google.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	linux-mm@kvack.org, matthias.bgg@gmail.com, mhocko@suse.com, 
	surenb@google.com, jyescas@google.com, kaleshsingh@google.com, 
	tjmercier@google.com, isaacmanjarres@google.com, vbabka@suse.cz, 
	wsd_upstream@mediatek.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 08A2F8000C
X-Stat-Signature: f1b6b5m66o84oxdqbrqbe43j4x1nn8dd
X-Rspam-User: 
X-HE-Tag: 1754332284-833975
X-HE-Meta: U2FsdGVkX1+W3iSS0ms6ptNxkPS9AJUfklxDQP2Pam/mekKmDiTieCgCU6T637fdL3DKEFU9ktpkqC0NteVza78XZCnvK5zWa2ZhjHyyLV2ha/kWWGTG6hIIce7yy0EoKdCkixkmp33qbRJzhAJb0GxYSAAcSL8vcs6ctk2Arz4u6XaS0Bj6OoXcTW4vP7DzqfbdiZIhcUaZ2Y1Nejhi05Fwhm5SCP+BOn2Eg8Ia8qDNAIMs9yTDfDaUeVJLqO22mFNZf4Om0TgKRoVR+zQHIEKI8dwRQEm6P2bnSewosExX3KS18LGXdXiqOkFarklHiaYFPfxdLb5di/0laH/1cYKTeP7D30m4fZ7y1DgJwDSDq+TTvEjkXJUn043ThGgt7lFR6r3urQj6KFmRW23iidHK29FH/VsetQEvmTggJrm38m0SjyaVWdS4OEJMf512q2LEGzCr1ex9BOzXGe45VTQ7PIGeUS2kdVKSmykUzxctVkp5gwBSqGk/HCJ4LwaW9BgSB2d2YqVyFqjj/hD0SOTHEYHCsXluYxRourKvpuUBJexx3qtjBBseGd8HHHveUdwAR8T6onp5YoW8uSji6OQ3BQBkLsAJ+AgHf4SwEe40ggjRizHKuYf0k3Thcteny5Y3ZI9ud5CNsemoC805MSzgkKT5cX3OQUDboSKNsCCnu9kWYcDCvuC+khQpAqlveFp9e3F/501GEjhdlNmkdekHfa3TiegWTtL1EJsjL5PLelr8WFyC6ujnOd5RgQuUje5pqccpw8xA+E4ZTBqpvPlgcHM7vcWmN6Ky53A46XZI/IJdgTgm0mJlPlSfr5kOjwMATI0bpLt6T+LfCNuG/jyoDhYiv18cWQ66WQN8V64iuLCHHwqSlrYaBPs/RN1++caRfhRU27tr5NaTluWt2q9lMfYLGSdPi683l8cFPEP/5pfjfmwm7qfUimYzmW/fGM9QKzwipAyNrl3JZY/
 Of7T+elC
 ulA9d0DpC5LJJSJm4Y7OCQtpAmabZERfrq2eV4zqUAbQAIIJrUDmXXT+F9VlIXlDi8y6zuWna13r/zoxYT2iiVaoM45RbelOy/VwYNoj+UqCuggtlAr1kQlBOP+VrlM3UgrdniWiTrfqH3Y+bYq3N1bGSnWOEGgg5pGrsJqZAErLPrXKtS9J3gQrowAxF49gc/ccWMzdec2cXXdUr8NiOmcKPLojH5RPs5CDZiA1hqCaI25NAGJqHi1gfE/L+FHuF1h3ud0leJs0mPyLiTQYUGYXjWwGXv9fGBzjwqijlsCeTeVLj0stHw24olnjm14Vwx8QPaWGkjVKBuICMcXk+RMUQ7mfplcALa/A646liodJqvlrFCUV4+KDg8IDPoOqB7ZOX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David/Zi,

Is there any reason why the MIGRATE_CMA pages are not in the PCP lists?

There are many devices that need fast allocation of MIGRATE_CMA pages,
and they have to get them from the buddy allocator, which is a bit
slower in comparison to the PCP lists.

We also have cases where the MIGRATE_CMA memory requirements are big.
For example, GPUs need MIGRATE_CMA memory in the ranges of 30MiB to 500MiBs.
These cases would benefit if we have THPs for CMAs.

Could we add the support for MIGRATE_CMA pages on the PCP and THP lists?

Thanks




