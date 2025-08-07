Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D07DC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 07:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81E878E0005; Thu,  7 Aug 2025 03:58:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB4D8E0007; Thu,  7 Aug 2025 03:58:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693518E0005; Thu,  7 Aug 2025 03:58:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 57E878E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 03:58:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FDF1140880
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:18 +0000 (UTC)
X-FDA: 83749208676.07.A5ABA77
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4ADF640007
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bWUiUGmU;
	spf=pass (imf12.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754553496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KDFnf8EI4upo742I8wxwbr7SIwCoz9KqQtqWzVuCI6Y=;
	b=vVBHiIV9ftW5Sgw7AVsekQuHeLjtDR4PbNm9pt9e6BSBMoFVmKeplRaY+6LaLq7fL/XXEj
	XdI/eKtJNFKehOHLqcTXTqUyvIc6nGjHckhH+T60tTpxmRPFf7OD0O3cAq31LKJnpKnaJZ
	4d9hCenOwduvyUySama1hn9djESGYsI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bWUiUGmU;
	spf=pass (imf12.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754553496; a=rsa-sha256;
	cv=none;
	b=GVALRbxC1p0iY53AyJzMqmX7FL4HzzVDreZqduKzTt3kY38AhTw3ftVSvnC9DEcPRi68WB
	chJgK/t7pAAD3q8PFA6jE9clUpsXAubbGcw9RClpiIB99t4i3FwB2lnQHgPrNice5+el8o
	MGhjCm8S7hx5OuBQ1tKMz4VIn8YLoUY=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-55b797ad392so799327e87.3
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 00:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754553495; x=1755158295; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDFnf8EI4upo742I8wxwbr7SIwCoz9KqQtqWzVuCI6Y=;
        b=bWUiUGmUn6ak3I8Nleju8c6ntI8qv7XKXEIeyhHd/NFwB/ntq9fOI6bE8C2cALTID8
         LTswqkX8LXdTHv29bUiWNzRr0oP+wio/hPbjYMRGeRmXDycBHkwj9KilV9t3+RKCNoNR
         mB4TbixKNlcJwMxcSN7Whr6Gb3MMP1tlOLl98araotwz2euk4otBiReZs1IADSwrm519
         4h19fnP0WwrzAqfl26Eq1BRISwva/Ed5zLvCuvmwE8oqijqJn3nj6KyMJQdgFqMxD3eZ
         QXabjk15A8NYpVgiNgq5SjpJBIZGej+fW8ecfhDe8Ru8tsmd2I1Ig8yIW7wlJlT/NREo
         mNcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754553495; x=1755158295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KDFnf8EI4upo742I8wxwbr7SIwCoz9KqQtqWzVuCI6Y=;
        b=vsnK+DIjESrC/koivNkP/pA0UF4Coj9w17oqsgopDqcCObZ/r6IC4pUuE1cpEE0B5N
         vSrb6CFaHEssNctw1CFQ+Huppj1Fg9tvQXafPnPngfayBH3UFGKEkfCtZlRwkK3blb+c
         g59d/nkk84bRs+mR/Hg1AjqJ4DowBELTVLzPSjVUvqldzHYYrRQcbEQIj8seOFoB4Ryn
         9xfbgwI1jqgTxrOQwbSs84q2H1OqvSaU+eZ+3JRIwbu+4mX3eb8O3k7gqq50Q5TnfNgw
         HtRXky3d1/lNNvKdWirZ9iGUic+DktO6xcFLcFxiwVMBMf8fPtJEwuNmDSMvvkhq2kae
         sIWg==
X-Gm-Message-State: AOJu0Yyu1fmHZSAGIuBn8vQxNI+blfBFACN/kBZm53DnI1PYRCf5wTjs
	3+Ho5bkqDoYmKFsSHoi/DP77Oc7wRh4SBd87UqQr/KIuO/7eLAkWjC5cf2KR5w==
X-Gm-Gg: ASbGncv2mnXOuM+dalkfTEnAywzxMvBXt447B9Y5jt/oUY3hNgxlLBjuInRqB7il+d6
	9vdtruBbTlfbOU1DADmUZT9NJEVqybN9A8OdkZ+DaLFD4TjWTZ+z/y7tbevTpE99t25u1vQAOi4
	TwqdfnGYr2Na6tSj2MZuqL03oDhQnND+hx9dHQuAIGOaUXq6Q54lNZrM2IsE68nEO8zqtMl5kqa
	haeDQf21HI8RWRS8AkuMSUkiI1EbOLT/9l22aiOTesCZzKFZ5kzb9LeNlyrjdn4+KPdlvGwK/WV
	VA3mMIUgW2jD6TcV2YmHUwYnADUG7MHgI2b3GLKT6OxyRxNNkx5wni72EP0w35fNwoFDgwAQD+s
	syyosKA3gIzkRAilPgQ==
X-Google-Smtp-Source: AGHT+IGLrJfn07j+Z/Q1+AZhXJEZJx78Z7HhlZXmk3MvvjRB0pkrjJdAKWHTqR2XcogNuGRLnleTog==
X-Received: by 2002:a05:6512:3da2:b0:55b:8056:626 with SMTP id 2adb3069b0e04-55caf5fda96mr2199121e87.38.1754553494378;
        Thu, 07 Aug 2025 00:58:14 -0700 (PDT)
Received: from pc638.lan ([2001:9b1:d5a0:a500:2d8:61ff:fec9:d743])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88c9b1fesm2501995e87.96.2025.08.07.00.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 00:58:13 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH 2/8] lib/test_vmalloc: Remove xfail condition check
Date: Thu,  7 Aug 2025 09:58:04 +0200
Message-Id: <20250807075810.358714-3-urezki@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250807075810.358714-1-urezki@gmail.com>
References: <20250807075810.358714-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q8gn5xqphoy1eeex6ush6q1a6yhqiab4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4ADF640007
X-Rspam-User: 
X-HE-Tag: 1754553496-15675
X-HE-Meta: U2FsdGVkX1+QjuzGqLhiy2oOqLitBYHvOYgQyBEFz3cPR2dzPeKM85IQUwgtd8m5qlr8I0aBu3bjziu+dYC3NjM/Ggg9SY3Rm1758h/zgjoV3cGZwjNF7rLchElUsyDofeS/2GJTBVwVKYxgnIqmTmFM3B/xXlq55hCfH5hscFUj/Gdh6xfU4Xal1AOfDNLuvZUxWa6Dd8B3gNs5jTJEW+8+Vv6/lGoAc2FL24Kg1uxzzxvNvBdY4UgrlUnnLid0Bv/3smt2O28PAg8Xs7It79B+IxlTJYERvG1p8si5XUe5GvCDoImkTLtwC8KRCN9Ur0yVsnna1aRaIyWAAKU6i1W1SR9fY+9klU5W6ISqVTvkYRo5L0QuoNA0CACmOwdlw5b4tZdICznx+a6pLALpUwtzqV/gGSG6Dwt5KRNCUzG9UkkvwIymkc5jzGb1aunrHu/5jthlrQIHerxlT7vyiS7NmRNTvcbRD84h4LmOKF8mpNG+vDUqg/E5Bi4D3TlOhml7Y2H/Qofx5p4Xsqkk/8NqEWJrwDHfhxrlErLTuMFarRyJBbtdDk60WrjbeGg+ONuP/mr+pXsNvRvWbu8tOyigd5mKj2LGUxMg3m+EZq3yhheztIuRsyptzYZ/VDP9J5D4epV+xRtYjUUQMFaqNV48wfsxHpY/uyKctiW59wNQpw9GzXIX2tSBj4b/fT2kHFTHAxL+X4gKG3ucboYKhRQbL4KpJTy2/3IQLQuJdNQazLUjtkOxx5jbx6cfltQyQGFhV+hHlaILZZoARQxGmWVtTG3B4Z9oE0c0WmzTgTVbailrZ7JhNHLOzcysT12RneQGr8lKzCQen4Ji399ym2mvTkLhKgtHBzCdYFaoaSTH/8Ew1UoymejZBTkDChJwSIb72wTk1eFZRsT9ebhXbFsqJHggf3SC4WOKI+jJb96B/0nWSAOBTtKE/tehswXvEo8XAS6iSxt4iTgEQts
 EdJNcPKq
 LTfJCkhmqw4t7mHrBNtenOyiZVfnNayUieUVJc/PaN5A31KcQfPwyxbSky4723B9R2Vvk/THJAcFdR0fJKnwXRh78JTAsR+pMsINY3JOr1t1WrxucmTIawTrgIDsSNEDhNx7QJuriDxMupeEp3CF4TjcKwtvb3xXV+9adGOdRl6mF9sfHz/jrU5iSDgdOpSLyHbuRMYhbYF3IADLzwQzK50+ms323akXJZSySKeapvu96BvpqhfVz6Z2ODuMj2rq2EhNdD2UFQEqh/XGQvWOV4E5jAXDDoi7gryhtugdfOZRFGcV6y4sVuPGjRSG4UOyacWJpFxUce12kL4irgqZv/uTHcKNtaC1XbJekn00nRDimsqlFaSYnoCDzgmnlDYmLvsi0p+T5SRTk+93ogZMb68MpQ0zfv+E5HjzKVAeREdVjP5Vr4DgU3OPUOd5/AhzLs9SdQaAXlOm4Zo5MUQqKkBMTWzCDnFcGKkomaCEaeBFVoLAdniknMxmCcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A test marked with "xfail = true" is expected to fail but that
does not mean it is predetermined to fail. Remove "xfail" condition
check for tests which pass successfully.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 lib/test_vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_vmalloc.c b/lib/test_vmalloc.c
index aae5f4910aff..6521c05c7816 100644
--- a/lib/test_vmalloc.c
+++ b/lib/test_vmalloc.c
@@ -500,7 +500,7 @@ static int test_func(void *private)
 		for (j = 0; j < test_repeat_count; j++) {
 			ret = test_case_array[index].test_func();
 
-			if (!ret && !test_case_array[index].xfail)
+			if (!ret)
 				t->data[index].test_passed++;
 			else if (ret && test_case_array[index].xfail)
 				t->data[index].test_xfailed++;
-- 
2.39.5


