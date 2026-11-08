Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E4E606A32A
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 16:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=QD1EdFCA
Received: by kanga.kvack.org (Postfix)
	id 7EAB86B05B0; Sun,  8 Nov 2026 11:35:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79B7C6B05B1; Sun,  8 Nov 2026 11:35:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689EC6B05B2; Sun,  8 Nov 2026 11:35:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F8E46B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:35:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF133A80D0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 16:35:33 +0000 (UTC)
X-FDA: 85412502546.08.E564D9C
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id A0E95A0006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 16:35:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QD1EdFCA;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794155731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vUMpCh0+ME16WhcfFd1W/qBu+AGK/hHn1T2S4rTNv3g=;
	b=Myh37/5Q6YzDeh+aujX4Pq/Snd+mOBEjUPrejHjAoo7VyDzvnjh3G3mRq2XB53/5fa2VbN
	Lfpq5+GR/oxmq07TAEx8NO8p8RuKDQt7hkFPdyutiq3+BXttLggfGBWVAxP386zZU2UDXa
	bSucujwYFkYzWAPeMrlZPGZdmTAo0Ag=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QD1EdFCA;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794155731;
	b=M1a+Wjj9bGiVxTzac+aPg7xVgRvIDP9QfZQp2mtkxZk4N0ca2Itetvl9ps4u9LY+B22KHA
	c/oRwBFH7BDhrxBDc3D+ea1YM0xAA36Oq46XAHAwABzf7HTfT/iSQMfFdX1HY0SU9bdA8t
	om3FSYBqyK9pd/Sn+Ejgupfpd16JjpM=
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-999b2b06bd7so73098241.0
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 08:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794155731; x=1794760531; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vUMpCh0+ME16WhcfFd1W/qBu+AGK/hHn1T2S4rTNv3g=;
        b=QD1EdFCAfuxNLeX/YgFQbmlB/qi47H5LBk3M/HXqFKBGB+E/gNP/tyLFeQpwHXmyYZ
         VfoP4EQDjndRHELPrvKYKh2QBJhNumCgiodRiwJnHV8K2HDvdCoJaIHPpjrKkGAERZLO
         r1MnvIQMyg+bSrR5DKdrUswehANOpoe7oQZ2EF1pvH51VxJFsR2QStyX4blG+k2Ajzu7
         utpswR5Lyjw1I9vI4vdccKik44mp2yXMaaFRMZ/JAlre+MTTVtYLRWv3CiV0iq0kl1Lx
         TQmtBcA3YMq9yZBb0ENQvVemoEg16PwnhsKUpvPNR8d/0VYGcENAG5uvT9oyZFsMhv0L
         9wmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794155731; x=1794760531;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vUMpCh0+ME16WhcfFd1W/qBu+AGK/hHn1T2S4rTNv3g=;
        b=QxVOq3llLiMBQDqkSHdkVLsZtrjTkP0IlFSGng/W6qJ5lW8HKjgN/NjlB+ZxO2XtAq
         QJqHNi8A2zGVmFwJoMhTCXpmaRKotDMCKAv4wK8hYZbQyI3KlyrfsJR6qAEyW5bw8cUk
         e6BtB2fIT2TNkHvah8fQNCwSCIOYSLtFb+B17QD5cQOialM1Ur7vQkFm69ZTKMw2nUk7
         2BvHhyUm0apjLj27XOk3Yds6i5XbeWhLFRAQJFfNuvQ+Az86KbHlsNVIxaBTiclIQdBe
         KQtFKJ3tIuJOINVvge3v1Ud+Z/k1mECrdzmY44CAz0DLsyXH6wFasrm9R9bJXfYiBzBS
         iwBA==
X-Forwarded-Encrypted: i=1; AL+hErHbRJEERQVOKAVLam7y/Vy7OMFGl36qsDbWYAqkTW1H9as85ZdNVawCBFnBu0WR8d606sNniDLjDg==@kvack.org
X-Gm-Message-State: APuU4Z8RjXrU36AEncWDzmV/e1K7lR3KocFIe00tXcsS+yfkUxO8KlJv
	NvSoQSjWLtr3QE9DC1uvc0lRdf90jWSi4Vb5inUssEXzOAsx8Q9WomBOSWfnzYHjchI=
X-Gm-Gg: AYBFou3nDIu3RvOqkjPzTxdoevM+puIE7WTdiFNbITrTDQ5Us2BkHTsWe9i7FO5PRxt
	HQefdOrojIMdcnF9Zgvun9MQeE3KMFBoEXW3CO4YJiioMQwRIyjsuIZ+5l83Vpuaan4qjZoAZzi
	HVefeq2mdEjGmmh+IfiCE2VRyCfqrj1jTaOEtBK8GU4NBjeTiUSv6odL4bU3ONCs/PpSqlZqU2p
	BYOyr2dOh6P56NsFBiDj+1UrtCi1reCZbs6xWpbFsQr1cBYh5GMCm2alBjEeHaD4duToSBFuOjk
	GXXUjH4wj+s6aA/EpKc75meaE+KBvFR2wkySH0zD30Q9MJfKrNoP/vkpIpbjTv5eGEzNKqiOjAc
	9FOZ7qt0ZSO0Av1Ms6LOE1GvkzXIpb7uR95r3JMj1pCBfJrxTbJD5h4casCMSQOlMEWivzxJ+kr
	+NgSsdscKwE3McT8m7e0CbuuZjRZ3G8SPfljG2D1RDT3TQm+gW7bK0z/SUf0f5HvaM08irHTTId
	FkDes67bb7X/85+fSrF3cnqU8T1U36kMV1CmHU4N/OIuEwtcxl7mLHZpF2fwKY/1hcbcMyN+kdq
	vMElmG2aEtnMCSWI6dhC6JaF9bsUPydc8Pdqw5lqNoeAdueZNt1HnDOPyJ5r+wScEcTyvbzbgox
	fN1Te4oqfX0x7tMTB4eRT+WqHot8jcHfVT+o0Nub4usU7mk4=
X-Received: by 2002:a05:6102:6b0a:b0:7cf:61e8:c508 with SMTP id ada2fe7eead31-7d2db0bcd81mr562845137.21.1794155730709;
        Sun, 08 Nov 2026 08:35:30 -0800 (PST)
Received: from soleen.c.googlers.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d2db5ef806sm2095957137.6.2026.11.08.08.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 08:35:29 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
 Alexander Graf <graf@amazon.com>, Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Evangelos Petrongonas <epetron@amazon.de>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261023054518.3258350-1-gthelen@google.com>
References: <20261023054518.3258350-1-gthelen@google.com>
Subject: Re: [PATCH] kho: check fdt_phys in is_kho_boot()
Message-Id: <179415569586.625723.12004410702455553565.b4-ty@b4>
Date: Sun, 08 Nov 2026 11:34:55 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=332;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=pntAOEp28rvpPJmjiHSWGEkBLb5e9psS4E+7JdTPPpo=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq8KTRkK+pdagJG3uuwOjoIOYQWkYDjK1Z7kQiA
 uyff3mUlEaJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCavCk0QAKCRC7dyhM23N6
 3nAQD/46TScYr5fNbB1l95VJdBlbmbfFCXWVTm4C/4Pc22h6gzpojjQSQyRcS68ZsbRODtMydmF
 QWzNl02NZS7CDiZYXl7kz7ZP0+fIETuQP8kHfwdJB+r6agGnF2lx82uuL6283oNWzVCwJ1RFlyx
 Rx8WsaGF2wmD6e2HW2OxhPevs7tjbytuUautMqdt9bZ2YurWVTcojCDhITzB6RpBW/2ZFMYbToS
 ubEQgkPjY2L4wqvywV5bvWsDwWjwmbHI6wgY5wPghqVm1KztgAnfDm2dRsPGhvftXGw4vta2JI5
 7AZWqYy8eZTamFmqjlYczr+NG/A4yPm5tKrpe5xnWzIjho0uyOcxOvio1eIZYfQqzIL9UPkEN0y
 m9LnNz5ROzzuYN8uU4ag18A9TDcoMCtLAfzrHk10Xc+G+MkTtKgcqMqSfE99OiYAo5ZWCg9Y7K8
 EQDHDOEljbZgrcE9yZQrfFUcVikND22cEbFAUFx8hqV6mW0qmpkq2PjMyc6iKx/qMPNf1jleIMA
 iph/Eq7sMIqOEojUUO4c6gM98NnbjIEdDIfIXp2zD27fxFURTpSC0admJ06ae8+M+NSzczMCpSj
 bu6i9WZkMBq1lfjIViJunX22yYZ39dyz53PEJGsNz7hRNPEz94UUaROONBl6D/6+JUSpGKjH/Yu
 OSNWBBtibvZWKyw==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Stat-Signature: x9xsh5eefsg6qshxrmhqwk4mps46z5gq
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A0E95A0006
X-HE-Tag: 1794155731-777904
X-HE-Meta: U2FsdGVkX18bTlNvQUoj31Sw9yokPJkofQvKHcuYXaChsDH86vQE8JJTPcWv7Y1npdbbjKWE9YznPPzmSsWlB1qGTt04XwX+3Q+zkv0FBOc52K0zp6nijzepRiFpXaOP2L7b7psvHBjNf9UOGBKqW7vrB8J5sAp6h0qQ0+zV4b5lCr1ej9JK7yqszlI9AAa+5nzRlV27MlIboQSfBcI7mz/ADq0fGOgUtlCUAZayvfcyZTvoE/SJIU8VJAasHxjkniRPeAT86M9iebbfp0cxnL6rU941Jdkso+vpCyR7q0IXjFJC3gLlBdCkrVipVGw5dIbpD9eyw2viSrj4mg11+UVOTBmFo2QsBVccXA8TvGjP9YQGVclPkHyKkWPqiXT1semcGlcmqgXZKZ/foMMcDzF6kygNDwrPrKm/otbRITuiq3dd8KCnuAxsHyhpbuSE0NFpnXZIBT2wPBykph7uXL64kZQVl8/MPkSq+dCZ+1LoAqn3U9fnvRPRHZNCcWBtU07kzJEnkiz6tMFJEapbRGds2x3XdkJTrBmfBNKtP1u2Ii0WM+uLkFkJpWvEHeTMlm50j9rl/iFha8dZLFGKolLeY6b+vjxJSs/ARZ4RfMLf+7XBmePC4qPk1x5x4l1WPU/djLahHSC8lQdA3E2GMqxBdJokcL5Z1+38YHrhtAKmn00x9onpM3zr5kymKcwlEgwy+KyBfDGfIm1u6EiRFXeK4KpLgcfVNE2ep4GiGzs0R9YvIWacCJYVccLUi04fHr8XCbUY/jGRSc6Odn9/VhFT4/yRYOW1oaBfmCAFN81P4eZKMi5HBZQ0vYC78aeS0VYuAvRGx+TSZCl0ZmsBMch2yHJ6j82IVBIvy37G/mgFPStJxnt0LVB8CqgOmGRupvy1DdH3Y+VJVsoDNjV/Fy30WVj9HfMPwlmWykMUFFOLsYkIXrohoKiwtuev74IrOXVgLIpOZa9xyNQfONr
 a6li+ItR
 Z2Mi1NKG1oFjQLvX8qz+Kwe4Lp/huVzGCoDOuFagCKnBE63jO+/Mj5bXyKIZ/M4OU2JoLt17eWx29CcsMGf/cwKdM1f/lGCxXq/YOsJ3OI2u4phJwyOVTR5llOvoTZwEgr4ryEBXo8rt+6hf8X0hESKVeS0CfNBQ9Xpxt75O2qMuYPKw7UZYomyWSjef0qkzOPNRHoXmwg7woVZH9DcO2uth+NJtmz8OxwMAOOD/KbWbzPyPxZn290k/6fKQIAX4hTJ9bWiQMmpKfZIu5YRi3Ivk07KPQ8eRNI3qE1XQ8X+jpetc4AceV1BiuiHgG8vLKccRuQLV4uMTfZ0nkpBySxwNAEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 22 Oct 2026 22:45:18 -0700, Greg Thelen wrote:
> kho: check fdt_phys in is_kho_boot()

Applied, thanks!

https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/log/?h=fixes

[1/1] kho: check fdt_phys in is_kho_boot()
      commit: 58c5852ca96c58cdfdb9646870b217fc54d06a97

Best regards,
-- 
Pasha



