Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 619FDCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 12:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7A358E0053; Thu, 21 Aug 2025 08:44:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2A618E0008; Thu, 21 Aug 2025 08:44:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D19648E0053; Thu, 21 Aug 2025 08:44:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BE7F58E0008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:44:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F47A1DCE36
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:44:18 +0000 (UTC)
X-FDA: 83800732596.08.E48DDE5
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9AC0E1C000B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:44:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UX4iRhPq;
	spf=pass (imf21.hostedemail.com: domain of 3nxSnaAgKCLAZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3nxSnaAgKCLAZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755780256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kh5QYdAh6nAxq3wHVmiK83eqHqd1Ae70oDTSD42Qpis=;
	b=L0zM7rnjKNZuyQLhils0qD6UQQWS2bcn8r5QlRY/4kuByQ/LU5zV2T9C25Hr/k2a5Rdh5H
	3uEF5VIhkjR0nfU0GHb3AlTmxxE9nb2TWsxpVWy8/No20Q6/I94kwd77jYslPcVs3aZmCI
	vRW6zkNk7sM+decM+letiRg8hZ11EdQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UX4iRhPq;
	spf=pass (imf21.hostedemail.com: domain of 3nxSnaAgKCLAZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3nxSnaAgKCLAZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755780256; a=rsa-sha256;
	cv=none;
	b=r3tFmVLK6HOAqoA2+xCQAdhw3sutzuFwBTcljZFOxx1p5Gq301g9/OISz5N1j201Pn2U7C
	Nn6a72lRc2bfdHGKKCU5qzGudjwGiBqhvQowzCRsSQlPuIGOabbP+tiMT7xfdfQIBz46z4
	8AuFsWociBjyGGTsLs+VglVQgpTWZCs=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45a1b0cfbafso5610185e9.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 05:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755780255; x=1756385055; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kh5QYdAh6nAxq3wHVmiK83eqHqd1Ae70oDTSD42Qpis=;
        b=UX4iRhPqdSHqhOITVAQVIA9sBYPkGSgisTrkEylHaQwpWmSAQY4fEO9f4CtDGNdlFv
         bxybnaDJKSRGBHOtmSu/fMdjmnSPP2d6RQH+VoHoPq7+gAp6sG7/SuBfthMgstGc6DYW
         z41PCHUbY0fpV50jhk20tqdG/5PJZesE8DiFwUrwp+w3YUHXWTvn2PZF44BnKH2hOcDk
         /3roAMcTdq6I0arxTdxUeTmhol6h0h1aOoqbC+SdFllwmWmDdoXX2EP3xVcijhaVqYPH
         GKMx2Uecht+0sUdYgT8g37Wh+9DHLmPErQ1aPeYSgM9yvglvJdg+90J1Tw1OIgtza/jx
         uUvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755780255; x=1756385055;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kh5QYdAh6nAxq3wHVmiK83eqHqd1Ae70oDTSD42Qpis=;
        b=DrrjblgdbQrf9KfQsWGjUWVZmGAtp1vIxHXEFBaOX87XrC3LZ+AEUg8jBQ3TqHaFhP
         3F8C2vmSNGzVqwnAIhBJB9ZOvAEwqBDkpPaYK9NoVTV1qaA0zy2dYEZdHnqBgO3bUzpe
         eH7lEOOZQ/AXJXxfwOi6PBLQO++tMd8vN2RfQV9JZlCAVtDSumSbxQ7si+YcR7badUpx
         5WF5J53jZ7bkenrizeDYwROQV+MRFFuGTzePiWZxJdzn7AVKfm7RlfWm0ShkXBafos8S
         bcuoiwOqtdlyBU52ddYqx4cD/XKTclwMHdBieXui2/06VwPUu3Sm+C3v620rkMLNsFzL
         +dKw==
X-Gm-Message-State: AOJu0Yzy+49CyCIXAcqJlchnLyPkxvk8riTQkUr/PO7J1Ml3phR276IF
	cTTrRaUoeQJ0HR2ZlPJOX3apppV4vZHr/JSWC4lp0A+q3sRNK5X5u/yiRLtkb0zc6L/DnY5fLzg
	HRYudPYp92k5L0w==
X-Google-Smtp-Source: AGHT+IHAROi3MrtrJw/aU/9ZmYqp2tOlukwY3bYbBdELumt2D0HPjVm8FpMPMoJokOc2rHfbgvTz5uNpauUQ3Q==
X-Received: from wmqa19.prod.google.com ([2002:a05:600c:3493:b0:459:dbaa:93a6])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3541:b0:459:dc81:b189 with SMTP id 5b1f17b1804b1-45b4d8587a7mr22616175e9.31.1755780255050;
 Thu, 21 Aug 2025 05:44:15 -0700 (PDT)
Date: Thu, 21 Aug 2025 12:44:14 +0000
In-Reply-To: <20250817065211.855-1-ujwal.kundur@gmail.com>
Mime-Version: 1.0
References: <20250817065211.855-1-ujwal.kundur@gmail.com>
X-Mailer: aerc 0.20.1
Message-ID: <DC845LPNX9EW.248S4JXKRUJAP@google.com>
Subject: Re: [PATCH v7 1/1] selftests/mm/uffd: Refactor non-composite global
 vars into struct
From: Brendan Jackman <jackmanb@google.com>
To: Ujwal Kundur <ujwal.kundur@gmail.com>, <akpm@linux-foundation.org>, 
	<peterx@redhat.com>, <david@redhat.com>, <lorenzo.stoakes@oracle.com>, 
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>, 
	<surenb@google.com>, <mhocko@suse.com>, <shuah@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9AC0E1C000B
X-Stat-Signature: af6aw8ycex4xm1mwcya1jcfhinjmwefn
X-Rspam-User: 
X-HE-Tag: 1755780256-490407
X-HE-Meta: U2FsdGVkX18aPPPPKoDrMGg17fZx8jmuDci7BLI6re0TSDv0a6KPR+asj6JV/ucqmT1mWsNkAJtCKBm8JOyCM8l1tHziK6nte8KlFB7OJ/AG3vQH3BG2H2cxhc1eDlZWmEzRWCscsdpSYNAWHDBeTjEmkDRNjhD+fE1gEKJob/4Ssv6Nnnd22HsTwtRQc6cZ0u7ULNzPMSKfI/G+IZOBJ+xUn80oIr0bb2Om8nv2xJc6Qg2R2/5z8ZlotnxAAQ0Hz637J6QTKznQWTz0iebYsR2S5iiREnIqj8EExp376zbWWCEObbHD2NRtY6RLD2a09gVb78nb1TC0oIP81CgI8zMx5qIAiHS+LFee6026Nfdq484W+7ZnR+X8Tv2D9bIEx9Iv/hXzLi9IT4VCRTmOgNVQOvlhoM2oNTfxHqInLin+rDpzzZs7bUk/517XfDE1aMCDKI5gwh53wSswWsmuJkVdu1psE2XjzZnaAZzfIBlome99WAcbtIauGDV0GbGfNCgHQxwfJOICw0AyY3MkqUUOki7rP/+reJIo9PcsYTyjOW/ZvUHa9sbYBK+pBkLPr234zZKqXgC4HtnuUgdMFI5LEi6PgXlKZ1tn+qGN4DviO3Cj/ig/82X1ApN/CTxRgnZVhfxsQYtFhTxHpU5CJo0pbRE/ZzZ1p6bVpBaFI9Js82sOROwPFHyu8CxYc/W13VsoVYCJLQJcRh4YpOh1kn+v68482j4TKw7HLLpHEgEZK0ec8x0G0Zw/3aLv8n8Cma6DFNRMYgab/ZDSpC26/gc6fxztzcNKK9LGGz2a7HtvRwwJdrU6n5RAFwqMhZdYaUr8gHu5cZMQxpFaKLCHEJ+u7NytaCt5z+R/It/ChCtIUDQKrLAxCbfqAPbyOB5RnNFsX5N4eiwQ52xp9/QBEhp6K31Ec4y8/quZ2Xvf8f06HFYnFMwxUaAtG4sudrRaVJN1oFVSaNdaAzQqfTM
 O9Fjjl0w
 0DJlElC6625iCOAvUOe4f/N3tJKmnORIGBbQanyDih7+iosqMQjHRITmi102ax01VQUy1U/ObiL8bmacCQYnlVIm3Yjk25i8e2aXTj0Jz/ys7fhkLav9XL82hOysToepKsjN6wQfUjqYIhcSAHAHKOKXVZwe/uR+fU36/StfIw0IBiBSNgTQfuI6KuvnFsoTqIMd97yFfcXSkpQxQ6kDvWtDBF2Cp1iAviYx8z4dhSRaLqEW/BhyApJ9k9zkXJINKJgVeFDQA83xDU4sAsAt7IIMd7112MGPDRiKjxFg/tIiw2J3LtF25I7Oe0p8JAHJ+BPwPZ0FJIentiECh12B5N3aC0oGMaEmtaXiLfoITz1EhCS3nuykXg6NmzLRVEw/cDIPXI9ytJ1sz/i6kiV4E5INu6xa5xEWJwOsAQ0pSLDKHaYIEyt+ZJC197IOd+/HiX4XQFu506s1C7i+t+LSzKrX9FosNs+WN/cAqr1VFYJAMHrQPHuT0oHhEIV3j1tRSGx2OHuV+uonQ7R2NTncs9k+jEGf11IKgdrSCMAgTqBFYYUvK4BWqiVTH3szEdwsJ69l5mTnI8H7o4QFUI9Rd9T3rBq/LtzTM9XNlMI1a9n1d6+p7sgdmFrXYMFhgH6qTPfncxdrvDXL8gjB1GwHLyIMytw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 17, 2025 at 6:52 AM UTC, Ujwal Kundur wrote:
> Refactor macros and non-composite global variable definitions into a
> struct that is defined at the start of a test and is passed around
> instead of relying on global vars.

Hey sorry for the delayed response here.

Based on doing a range-diff vs the v4 that I reviewed this LGTM,
thanks!

Reviewed-By: Brendan Jackman <jackmanb@google.com>

