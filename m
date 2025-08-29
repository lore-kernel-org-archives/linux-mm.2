Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69716CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 11:44:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88B378E0006; Fri, 29 Aug 2025 07:44:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83C118E0001; Fri, 29 Aug 2025 07:44:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72ABC8E0006; Fri, 29 Aug 2025 07:44:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E4368E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:44:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE6B6119890
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:44:45 +0000 (UTC)
X-FDA: 83829612930.06.D4DC8B5
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id CA12240004
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:44:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=v96AQjMM;
	spf=pass (imf27.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.167.47 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756467884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NYFEjS97w6k9aJ9qSpZ2i0GrDJhEZpwYJ/gSKtJjiaY=;
	b=sAXKkQRPRELU9nXjQ8FL/c7GlI3xGB2YghYHHIAbEa0OnPPcFSfLFVkqWtexGYaZZhMBMr
	2NIcNLcaYZ2nCMU/bUhcrM2AMK38bJRvVT1WA1E/XTUx8xi0DEpkNXuMo2XsRrP9/tciWD
	/YTNLYFRaPFCENBqbtI1CXG16Z3oK0I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=v96AQjMM;
	spf=pass (imf27.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.167.47 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756467884; a=rsa-sha256;
	cv=none;
	b=UtOrqbyUxnT9NCCQYLtxJ6t4kszzUiRFGwl0W21S/K0IIUfp0IxOBKSYUTfNKoVuXJZn8k
	6SlvS/Q22QLUbzNTH4BTl2lAXZzPsemqCXtckkpfWW/OnK0IEvRs4euAQR5ao3WEJYvb1F
	c3kKkalKX/ASAhvk1ZHhAaQhiy4bX0w=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-55f3e4dfc5eso1691378e87.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756467882; x=1757072682; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NYFEjS97w6k9aJ9qSpZ2i0GrDJhEZpwYJ/gSKtJjiaY=;
        b=v96AQjMM5uvkpEsKgdxwZfp1pE/psDHRDu/iMbstfp7pWCHnDq408BnrScFIYqSpvX
         c5vU4WduYUQUjfmggyE1DQvbJfG0W8onv/47PQfDApWFW1uy9tDJLgSEYgAucT2BaOQz
         55E57cJD0z1ZnhQ+bZaikQr9CWAPVeNuFm3WtNULkQyH7YHL6sKS4ai+Fm4HOS+OfGbe
         rsYjIGAbYojdaY1B5R/4LT4ID9oUC1PNeINkc51dRhkKpszdw8rD/z0He/ZvZ5VgvlsR
         t3c5gB6R5V67rwUAqJFaAdZp2DXhryA8x8YRJiv31z/0tXrGGfV5PzHpCtwOEhZQKzkV
         6DEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756467882; x=1757072682;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NYFEjS97w6k9aJ9qSpZ2i0GrDJhEZpwYJ/gSKtJjiaY=;
        b=fH6zJENwiAjUAjbPeqkAca6GZDjxb2ZqyThQRGtZ4pmaFD+n41qDteAICZMhpz8U7Y
         TuoNzmcGIugOhL6RKxm9pyIK5/IWiE6oStUw6uWQiCM8gftKKUq+66JnAFTxeV0nuUPj
         Lu/uqOSBMx+M8kg5Sb8FZj0HMTsdre3zqUHEEiHnIIfKXyti2FwEAJC+GKIhu5EvAOCH
         ZpRg7jPkk3BgbKbkCEXDT9X/aYbIUlTzwzH8C9san9taH/qebUU0i7PdJRwSydqJH1G0
         CThY/nMC0pQBvFEEDDCHFat3dwD/l7Hdu1gNQryK6x9SBho/ekVjF60d2s3NUSskdaMr
         2SoA==
X-Forwarded-Encrypted: i=1; AJvYcCV/NpKC61BOjCP1Yo+3qu+QHkKeLzPmKVuvOrTJMudKhfqAgX4AluQCsgyrVkqiVDVYkVy5T3AyGw==@kvack.org
X-Gm-Message-State: AOJu0Ywre25ZZ999zBiaV8oo3xcpzMlKR/eUb7uL1VGt7fOqzjHPFD5G
	muGlzmKJQnHhNjYyGVG7DeO5kuuDkD5p4t5XKgUYfgSzkmsNMivxALGHvffzAyvU1XDND/DOAUM
	UQMPG
X-Gm-Gg: ASbGncs93m+xkrRQI+yuukUuG4Rt8/4oXPD83girPBEi7JBmj/FcpqXl3tVCThumLaZ
	OarCg4uWtQlp+zfQEUvQTGcPb1kATpkWs0up9ZHASvEP3cp+ywQ/ogs/NFw/2wiMpC4cIz4N7wS
	DQ1tHjGR2L/DF0WisXhXTNpeCANuTsH9SkFqaluEulePs/9FW++tOObXOyxNlOjB3DHdoJZOmsy
	T1SrI8IvcFvAUlWekU2OicnpnZNtUhW+qjGh7GnOj6EK3G1jZ/LE2H7+Q3PMd+dM0pW62ZIE4DB
	N+95o4lvo0nyfLd0qEq1gZeMIyfEp5DGpoCQjKpgl6BVrF4EJc0bgG7e+OvUV92eiZ6+HKaku1M
	qmqoGZdn6aS13oDQp0QhP5MOEAf1AcUtX
X-Google-Smtp-Source: AGHT+IGnEbXMN1WVX/jWRB0dcBZuNXIC1IpWZ0S8MP6TGxiRzhzgPMsPfwiQzUYaRA6WU0ZV/K1KvA==
X-Received: by 2002:a05:6512:31c6:b0:55f:65ef:eb12 with SMTP id 2adb3069b0e04-55f65eff890mr1401957e87.46.1756467881765;
        Fri, 29 Aug 2025 04:44:41 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55f67a4c612sm581162e87.146.2025.08.29.04.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 04:44:41 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/2] mm: task_stack: Stack handling cleanups
Date: Fri, 29 Aug 2025 13:44:39 +0200
Message-Id: <20250829-fork-cleanups-for-dynstack-v1-0-3bbaadce1f00@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKeSsWgC/x3MwQqDMAwA0F+RnBeoAcHtV8YOsU01OKo0UxTx3
 607vss7wCSrGLyqA7KsajqlgvpRgR849YIaioEcNa6lJ8Ypj+i/wmmZ7RaGPdmP/YjkmroLkZi
 EoQRzlqjbP39/zvMCOJzJfGwAAAA=
X-Change-ID: 20250829-fork-cleanups-for-dynstack-2051bdf2a2ea
To: Andrew Morton <akpm@linux-foundation.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Linus Walleij <linus.walleij@linaro.org>
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CA12240004
X-Stat-Signature: ygs9ehwesqi8dys3xpn1npdb7mcjhdrt
X-Rspam-User: 
X-HE-Tag: 1756467883-406689
X-HE-Meta: U2FsdGVkX1/W87bphhf2Sk117gYg3hl6uzQx7DzCNRN7SAM9T8fHgNwO4viTg98oVRMxddRpfmxgGBv9E0qALtO46gVqnY4YqlNGKJGrDgTVOBORDmvgClfeVkIFExRTivhAfLQn0LEn4EzwZOLKsljWcXA4CW49OvUWpE59B404AxaD+s1PO0jMhZt4levCyzvSOKaDfySuxYu1BCJhMNvH55hqEMpd1VDlnC3Y4t/YSHHAzaOROtCkVQWedTP06aKG3Ek8ITfqMKHv/VaLpK5aekFbQgyk4Rk8Td2flvwkjcVr/uz2wzkNCreIcFRfTk1OOSxsOi7rb/uayOWIUk09PMZCxG8eHmJHlqkQhRe5pMdYgxjOpR1ZsndRW7kx5ajITn6o5DPMdJhYI7f1P7718Uk2oyLT87zGv0D2G45f/1XTMOPMITaOQu/pctaWUI7rgcWNg+N0/CZ5U8nXfoYY2r5Mwv77T+qB8LWD/NCajp8nNBvZ4gsVFjgaH/WmIAKzZOFiJw2vvMHpJgPMEV3nOJsUrxkzRqz4T25MdsLJOZSTHaPHqm1SnJic1DaonWzthwZhlB0ieNQB1vAbtrd20hkScABUWtxLGK2gV1759zst+g1XkXDa7HW9HRsgXtq0eZrtBpZzYzX0zRzWMp+kCXk9F72CjKEJTE4SeBQw9ANsEx8gWL67nhyxELUDFIcxmfkhyOW/Dztp8Oh4fZAzU+8e/bW99mer8oCnTP/5UgWn38u5ZUg5IMTaNan9tQdVGWVzmp75xR49uRoiltK03917313yFo73C8yumligFNT8GFaRTu4HAVdC5p58xGtNFh15M5U3anWyVmOkp/0nHWg8HLcsKPfOFIGwMoPPG1MlbJUt73CL+kJr6JCRAz3mxVQngdrsp6kzjBMbjGeaGwTVv0XtkKVMylSYmGcYVDg+cHbgrKbpORUQGEmp92CX0XLi7IoTX/+IJyc
 fI0ZZhLD
 BMarsYPWenVQOytw99ZPE1LkeDIbcK/M039jQCKLObYq8xI+jSBHwWm1wCDjORcQPzrGV6p00mpmGYwth7SDHzycFfBDDllCTqXA0leIZPsbl0F1fHA+eSZVgUPK+ksNh6YFfIRVRukIQZPpXgEKOiaoSdyLmJVtmKTP+fRud1ViByVbg7WctF6h3NGjyGZe3aZmBczk4t6NpYWmMQq4BGMLHFgyL0IrD+DomJ8GRnr/cZPW+TCkdwU0cFTASIO47cEuwuXs4YHHjBjgsR/RF0P+2MQfslqdfncqLGe6KHxb535pGF2W3LTwl+Z2gY4/HtKtbRpA67n6KYJoMhUnDTFFtf9a1o9bXGK31TY9RBkNnAEGZ2670/y25iYscAhSXpvmO0EPCqU8ZMmhjPlHfR73y72gF46ojTiCX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These are some small cleanups for the fork code that was
split off from Pasha:s dynamic stack patch series, they
are generally nice on their own so let's propose them for
merging.

This will go through Andrews tree I suppose.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Pasha Tatashin (2):
      fork: check charging success before zeroing stack
      task_stack.h: Clean-up stack_not_used() implementation

 kernel/exit.c | 23 ++++++++++++++---------
 kernel/fork.c | 10 +++++-----
 2 files changed, 19 insertions(+), 14 deletions(-)
---
base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
change-id: 20250829-fork-cleanups-for-dynstack-2051bdf2a2ea

Best regards,
-- 
Linus Walleij <linus.walleij@linaro.org>


