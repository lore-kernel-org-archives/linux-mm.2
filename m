Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 473ADE8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 03:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54B1F6B0088; Sun, 28 Dec 2025 22:52:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9196B0089; Sun, 28 Dec 2025 22:52:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DA686B008A; Sun, 28 Dec 2025 22:52:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C0F16B0088
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 22:52:28 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D99801A0884
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 03:52:27 +0000 (UTC)
X-FDA: 84271136334.08.1529079
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0CFDE180003
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 03:52:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=run8UnHR;
	spf=pass (imf24.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766980346; a=rsa-sha256;
	cv=none;
	b=k41nndAjPlniiqne4FO0T0sJ6jyaxXKh3zD2+djGMar5VBMPa6svqTMnBAb6NKgTtEUsil
	y2qWVxqAG/XQ/x9xyUOeGrLsbv5HoUVERAhHtZt/BYE4JFbJc/DK4wD0b3/5z7ZQJD5+iy
	EBu5a1988bMe3QHKJlcSp99Tf3AwTvQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=run8UnHR;
	spf=pass (imf24.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766980346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aB7g6CXDfW6HGExZB4E/LWQMKMOyqE5DaYwLo3Ciu3k=;
	b=rMHSA1v0GJs4mKL7arbnvVPrHhSfCXaMgLfNi7JHROFzxQ8dygJ01Tc4m9B5pdBp3rk0EX
	lmUAjT+gFoobNUFDdio2YKvMwQWDeDNpKaymdpMHb8n9/EAwID+RfXpzN4MpvriTmAFgTn
	IeKBO6z5Trn1A1wuyovBRrmutFPJ504=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a0d06cfa93so1271325ad.1
        for <linux-mm@kvack.org>; Sun, 28 Dec 2025 19:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766980345; x=1767585145; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aB7g6CXDfW6HGExZB4E/LWQMKMOyqE5DaYwLo3Ciu3k=;
        b=run8UnHRZRy4DJNwuuGGeVKvWNsvgNrbiuhIrFTX92trgFdlI9QeL+6Du17ytfqLDw
         ou0F8cLmbX2NapHo2nneV+RgQPPTFM9Gnnb2WBQN6yz8Ku5oSXLJ0tsIa/07zoWxMMsb
         94ClmOsydctSZF4mCOd6cRbkcTXtz8HQ90s6mr58xHgjpD7qEhY8fijmxRYwObr/aLjr
         ce/PtJTdqdrCbaMr80+hwTRjODtWMyFR7i49Wup1zxVKyEKC5W+8Ls8sNibvwLEzNJeB
         5KLZYyU3pvsdBx8pxldqXFqH0tEvgfyd2zjyOwVNCZprsXLsgYE15saWAYBIkN3aty4C
         i38A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766980345; x=1767585145;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aB7g6CXDfW6HGExZB4E/LWQMKMOyqE5DaYwLo3Ciu3k=;
        b=eACBcHWyFK7u3QWhrUtGEeNb5em5jgg4AgDQvJJWknDGUK3Z4hjhA+p6LuNKNx06He
         Bd4k2ARSgPz2GSWbTO7y/Yu9ocl2o/k2q4mMfL3XhFYodCSCLe6aOC0BffYHq4Q6HvTR
         zoZVABPJ/YWYjY+ij7xM8D1cdfcbOdsDXXSoJ8VEmR+h4BH5dOIuK+vbEz5k6lhvh36R
         9L8SicP5oLyppyRjDzxEZ+G5yh63WCCtcZi+MYsFhfgWcmjLMoeo3wJ7v3v2/SFBnwUi
         X8T+sI9CwxRzKfjv+XsHJvxRXeo2xZ9eFGXVj0YzNnuOiNX8nwC10cqg0sXo08CBG5QL
         dh8w==
X-Forwarded-Encrypted: i=1; AJvYcCXZR1JSbYczTTNMe1Z8vEI1FttKYGBUw//NVXiCsUAsUj/6cO/gAdtlNG9SlN58v1pz4oFgnuKr6A==@kvack.org
X-Gm-Message-State: AOJu0Yz0tW291LL/l1/WZg9vE43v7NQHdzHyVY/AN86+fYp5826LLQ+g
	UpGrUNHYWqobLV19Y+Kla8tFP9QWbP0vDWUWi5u1noKe1EQKL1fV1cjpiIoduwSfyg==
X-Gm-Gg: AY/fxX47ZiWS3XenDKUxiHG4aTz0ZeUCURV3M7d4rXM85Fl5BUjLFKviDme9Vwpwh7V
	eL48Q1jNzYTO1CVgUfhy4c3oE4HlkC9VIe/CXPD4iGGdqOjK9s8hJVeiQ0IlNcnspH0NKvkTiTJ
	xXShEy9LT0g07/Km344usJsX8oGCUm/GDzk7PjZVVGVEn9iTu4lyFqSjNtcFDlvI2QdamZNXfce
	FGpOaCtGlBbuVg8vaJIvuWXAhVu2FaXamL0fQZjeIOL6FpRVFTJ+CcyQeia7QH90dLyxMwqg0aG
	qAQ7Cwr8vdwCdvw+o0dW/cyCAKJxRvHSf2zqO7qpA2KZvLerIwOHyHvJb0OpyjeXu+KTyETsGrA
	FhopAp9jjPJzgy3OnF1AC1fHmkk6NQcfwnWybPHXG52gFfxgrx8oG7mKteGDbsmXPqDLBBH/EW9
	9qCBviEhmtCkLLdUMLnb2DCV4mnopv+zwLSRPS5o8nIc2q0n6lZVl1NST6HmQ9I81sk4MpnOOiD
	D3TlBsfAkGWeu/cKOfxW3krr5gaprTQKJefgmkgmw==
X-Google-Smtp-Source: AGHT+IGwDgm5TTH1m4KnMuqe8eyyJlsiZm+/PVOJRxv8qkQKTUcBfAhfY33eVNRJQEtmKMKYtaD8Ng==
X-Received: by 2002:a17:902:f687:b0:2a3:2844:98cd with SMTP id d9443c01a7336-2a3522d4fabmr5359435ad.8.1766980344398;
        Sun, 28 Dec 2025 19:52:24 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:6aa2:ed72:3a50:d77e] ([2a00:79e0:2eb0:8:6aa2:ed72:3a50:d77e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d5d3e1sm255327115ad.76.2025.12.28.19.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Dec 2025 19:52:23 -0800 (PST)
Date: Sun, 28 Dec 2025 19:52:23 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Dipendra Khadka <kdipendra88@gmail.com>
cc: Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/oom_kill: Remove unnecessary integer promotion in
 format string
In-Reply-To: <20251228154456.2386-1-kdipendra88@gmail.com>
Message-ID: <33688294-ac1a-cec8-527d-a6a010a6128d@google.com>
References: <20251228154456.2386-1-kdipendra88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CFDE180003
X-Rspamd-Server: rspam04
X-Stat-Signature: gms8utsetc4jdu5oh5ktasqomzsjm11a
X-HE-Tag: 1766980345-725036
X-HE-Meta: U2FsdGVkX18CM0DuPTIpf+hNzfrsroEhQ5nOQa2Wtcn4wynRw/7S/VTueOWI2Q2FZXYCDQWe3dT1SxmRJJ5TLydJJ0vkUlsUvc2xQ6mnejzlHhtapppG1MYnARov4htqruv2Rb5USkicoZGvjAjeRgSrdiHpQrlo4IldrlIYOV0B1jXMGB0WL7li/ZLN5jIvN88OnvcOR+9lvMjccqplyR5FZ0V4TvTEH0Ujw9NlgVPzx+5bDLpNaDaX9j3pOLfHQyj9/PbDVNio1t6EPPawujnYWJmBXYjBJFOa1gL3R8vyjRki5zQtsl4xpMbplMRoy9K5BtIfxRf4J6Le/DiHmHqfJ+7e5/QfX2dJ/CcGydEWSaFaDM9tis9E5EwywJx0XQi1EW66GV44xGMfOExxabk9Fr34JUjW3WX3AcQZQXk1bO9It1QDR15bEv/qjeCh1NagCk71O2jy0Sqeun4nOtDFoJs4rX64rNGD+EomVXUbIBE15jPkWN0ol2ePBN3he3iAuP83NKJsFjvRKnNVekeRdfZdfMyVIYkxh4zNQ+0/5Oo8urCrQRjIsFhhwdjYfvl4WM5oMorNCQY6ZDwpoCFDDD2IGiOS1dr+GsX6CPyfJ7YU3LmXXQXzCmZi67i4co97ObDjU5cS8K1tQjueVHq9lwhQAMv2OPmixMIrIcKFaLlZ4YU8mKmPeYbKQJnFCsN64gLpsATI+z2lnq8eGaOK+QPXpTH2q6AcOncM+7s24gO0JC6kggiA6LEWpSnxl5RBYgXivXFfEgrlWFAcV1Cfdx7jCzTsWF85JehAe1390+aWRS0FjNCXyckfOnb8R8qjBbsGtyTulc451W+Rty5kwJubX9TDEhm8jKYoOYXB34Gbwje46ChrMbEhiHMKBU0eQFsDlIhk3ghqdhGvCfvRYE7+R2XQ7uoTnwSCjaCbT/xd0aY/RjYmQ7t+Cj/IqMrKP80CwFeGPPOXLAE
 810rbP9Z
 xlvOo6wnc/yva054NVcZJYoLcy3zYJVe5zQGgb5pF13wov6z0froMlqAGLhEmU2UimAu/jBRijguWcThUrzoQX7pO2wMww/3IkUTV/D5lQ9IWA7IpC7b8h8rLpBmkk65ZLlodIt9gP3cUfsM2MoHmnGEh9BP5QedzqLd7BLUo8OwDGtuL8kOhaf44YvSmOKiJmeg4K3DGlbvb8JDQ+9nUqXbUOeyfnn41Lyp0QMPnwtJ/a/d7Ut6sFMyhdA1UjGE/4grsY04h7+eykhYrc6BPFwCVr1Qq4fV3ewfoPhiF+JCnhkQcQBRNad4ZiXrcOVSAMohOUrnStj0+Mj5hWOgr5bDQ4u67OqDOfn9nWYs7nw78+WnVND5nszwDfCweB7FirRWnHYJumGUWRJZWAfUuGF+m/COmJfRCJon8vwSsFMtROAc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Dec 2025, Dipendra Khadka wrote:

> The 'h' length modifier in '%hd' is unnecessary as short integers are
> promoted to int in variadic functions. Use '%d' instead.
> 
> Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>

I don't have a strong opinion given this will result in the same output.

Acked-by: David Rientjes <rientjes@google.com>

