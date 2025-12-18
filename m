Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 129FDD68BE1
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 06:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 627726B0088; Thu, 18 Dec 2025 01:42:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8406B008A; Thu, 18 Dec 2025 01:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525546B0092; Thu, 18 Dec 2025 01:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7266B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:42:11 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D784D13C26A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:42:10 +0000 (UTC)
X-FDA: 84231647220.29.C79B3B4
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id E28C440002
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:42:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ej8IKp0d;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766040129; a=rsa-sha256;
	cv=none;
	b=3GgtUps8jkkZaqEDMvY0VjU27a+VZ7NAVa64PvxbhTpB5Oodfq797EPAs9r+G/HC44SO7p
	HSOFA1xM+lJ7uj1r4x+Sr8pI6teTOsJnYDCN0Iq1bgMLOGOJc8+5s6o2d8AoTeIRordgwG
	xblgSSIy0AqIchgA03swd3ffC0zLw+4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ej8IKp0d;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766040128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tm9NwXvmf/gDMlFs3lDsjBV3kpc7O9Iel8KuGxP9cWc=;
	b=hAVuzvDnNvPc3rga5IAOGhLedNPPsdzRekvawYEmm8QVXMyAhcyrQOmFlRg3KDuKPtHkAf
	V2GPNpEJtuBomtQ5nVVLpwOySIt2BLUMUpwn6Y2iDt3fh1qHBpM0erW3SwQskSBhXTQAE6
	+1vcFxq3vTiFWFGqNC1BmoAKVMdQ9OM=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-29f1bc40b35so5871635ad.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766040128; x=1766644928; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tm9NwXvmf/gDMlFs3lDsjBV3kpc7O9Iel8KuGxP9cWc=;
        b=Ej8IKp0dPESFbXM4IZ5+z+PjcZt6gMhexIekqxkxk4CdmxAKASp9JRjd8sT7stavIH
         EKldLmnQ2RUr5IVgw8xkCs6eTTnm7Gx3QkcOXCds7ZjKCDfU+pZK14XqnrgTLczF/3IS
         +miCkBtCHDxdve579Eb5Ta/8DYm0X8mqVEaPcS9m/MnyiZw8cFRm8ua+/dEBMuV42UvQ
         2RZQ8MKlgAPSngfQAXQhgRiRA6BfQSdE8IBpg3WATCPFgFy9vRwNtQh+5355KTTLegjk
         O/77BVVBlSXfP8qCUwTXR9G+ivPUgauo4pCJsOzRzpeJETapxXjtGA1Nd6Cs1QFOD/wC
         ArcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766040128; x=1766644928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tm9NwXvmf/gDMlFs3lDsjBV3kpc7O9Iel8KuGxP9cWc=;
        b=JTZP62F1foljNYjHru30FGR1Pz5WVPUyUI3PtNiruEuS9EM/o0VSCIpmFFCImJ5vwB
         3P6gxqZ7bg6WRzBH2cuet2ZGNSwu3Btd6NvODJ0wzpoEbB9xGHupQd22Y988j+qVocU4
         2F944PG+Zt4zxu/l7IA3YzqjcGFFix4CFhBQ2Hz7U1XUitLT7FSPIGm2OTKwJfLPFx5F
         uakx/BQpAOdyDKcPF7WF/TSn+Y35f7er27UPLfxTKcgtE+R9RZfcosMytpgL5f9yZ8pU
         px1vMoFV1G/qo8PyMKQDCRl8+Qjpccc7NfMtewwo1C+maQwspci0B7RW31lyorfmz6/d
         vOVw==
X-Forwarded-Encrypted: i=1; AJvYcCUCyJn5lDB3JfyeCi2yMJCYW8DIcWQXJt9u+WJAMo+NRi2M1An+AgF9d+C3YTCUm0j0xPmQ3MFJ4g==@kvack.org
X-Gm-Message-State: AOJu0YyVJrcyTcZNwgm9RW4+Tp8nqTAVtnHMYwfBGcR/JiazrsRIKysF
	5R7HdFCBc2dL/cTX+IxfUNxqIODJrK1AESEkFoVF8EmKx+/Vxdm/jJJ7
X-Gm-Gg: AY/fxX4qnweP7Qleqky/UMi6WXokHYo2Dgs0VHrh7oZQTWSjWc6a2+q805FSvmQQ4RB
	rqf/Z2Hj6gQc3JlhpCyRv1H9vHL8jvroyb918xFIembabuv7s1pvhEB/mTZyg0obr0/xi7ZJVjB
	fdgb5AEMEcduyas6hhpveyBW8K/T8KOxaf+XmzT62TnxZI1R5eVkIIgXTVx0TTS3Hqe76SpsXSs
	YmsjcPqiTTaLbyxTw7ISuqP4ua8C9nzPzhINxWKxJmfaGK/JVnmdR7EM6VRFOTr1DllnqHz9zgX
	V+5cIBPYU6ZTV3hV6l3NE+/Bzc3JJMxf9zzs4DZQFEA9dw3gSkUkExK6/yP+p0IW35Z3Yp5DrYC
	q9E2JrnjbsHWUuNk9BfbEmayV3azdHaqtcOWhiubP7KaLpSZu67gTTcVPbJlVoH5t7qpRxsXq0G
	pV5FxFHWO9sou7YJzbyy8=
X-Google-Smtp-Source: AGHT+IFERotbTi1a6NxtaY6J2+0n85N9rFTKph8nNdTT7abq8KlJPV8QdumgT/4wKWSussCpD/Mq7A==
X-Received: by 2002:a17:902:db10:b0:299:e031:16d with SMTP id d9443c01a7336-29f23c736d0mr219074165ad.33.1766040127646;
        Wed, 17 Dec 2025 22:42:07 -0800 (PST)
Received: from LilGuy ([2409:40c2:1022:14d2:aaa5:8d6d:efa8:e19c])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2a2d1926cb0sm13498585ad.69.2025.12.17.22.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 22:42:07 -0800 (PST)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: swarajgaikwad1925@gmail.com
Cc: akpm@linux-foundation.org,
	david.hunter.linux@gmail.com,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	osalvador@suse.de,
	skhan@linuxfoundation.org
Subject: Re: [PATCH] mm/memory_hotplug: Cache auto_movable stats to optimize online check
Date: Thu, 18 Dec 2025 12:11:53 +0530
Message-ID: <20251218064159.7230-1-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251207231056.71294-1-swarajgaikwad1925@gmail.com>
References: <20251207231056.71294-1-swarajgaikwad1925@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E28C440002
X-Stat-Signature: 1zde3fb1td35in6kt1k6r5bajb87pfw7
X-Rspam-User: 
X-HE-Tag: 1766040128-87044
X-HE-Meta: U2FsdGVkX19F7F8hwvTndxd+3j1st/1I9hfwwsh5rnDIMlBsTJcEKcitnbau6e6hyf/9+MdaGbcdAXdIBLa7sX8iUk3JsxqD9crZXYWxBUBKr8EzSz23oJbMP/B3LBeRI4apgCO/SDV3Z86CgDGGJq8ONkdFZ7vgQzjDNWiNWqq18CmnuXqFFGPNHFY9W84aV816MpW9j2YxCzFJzm4i0rjEWRgl6w6HB8g9doCtpNPZXFocqILdxwXcEhKRiNtjNNhirxAD4etSyjnjVcw7RgU8aY2ibCfIHQZxaT2Bi9K7ZzlQTrDQBNavp7dhSsuAZT/Zjg0/9cyGCGh2+yVaRZ9NJHWZ24xaT/CBjRcsCKKI3QcHHNZgYUc+BkUFuIlSI7h/+n2S5yzSm2ijyTJFkqbHOoLfykTfZZu9zlgKpWHodRZqHSujV87Ug1zudUuKJf5GKTmpoN0BMHLz+c3Cqlnu6piiZMMQj09gw1YuzVnKaXjrv46Qz6mPBkFCgm2F25yleXxyQatOSWh1gqt6vyPBtE3KgfbV6VG4kQzqTdZvt8864gCofxBJFdchzNzsgFdXrHFERAuRDPO3fmHImr2x+q74f8HSHybyock5y7U4UZAEzJkq5azae50Zwdd94jt51cfgHj6YpiHdCtQ5oFltrkkOVCXCwI//oQBr4siV2DcTjuN1sO+SmzhfxNk6lZPmzqnQzc+nmPPV2khRcIvLtxlZLf6UZMoZh7LJ5g/kn2/X/dUDmNPa/2fMJu87Q1XnVoCTH/sOtIDwl5bz7mu7SDP/4g/kvCuquz1UfC1SKeZKkQ745fUpvihWBglUOG23JaRUJXiBh7rNt7PRMZQNIgV2UpYXyLHn40udLrDuBNulBFA89mZP6N0syrXVCjANDuoIXAsArTjfOWEK19tbWCPTS15jAYz+xTLwVwmHDLZz3ytgcdDUyGYk10eKGVPE+j0tcnZzUv+H7Zl
 6M1UUUji
 cxfo6mVQHqQz3K0icXi+BXfl/mibyoEU5hAwmqw0fTSI/7TLdM0DfTL7KRXDqamMWJXG+dDoXFMQppwzVUTM/SDHjzd6M3DilCAm4E3gvfflZ0L+MHv+jF+cgX3K85RI3UDlRpkR3CMBWT0PhGKjIdNe+53uvP9W6DvlW3GrLd2olTE5RmJdW/LA0pW0rYdDvK7WDdBenX6/al3keZdJmjJ7NF1r5wGzN6ysw7hFOkPQNg7Tb9h9kpKkXH5iFjBzTqkSf4AC8I7ATI1GnAT7bsH9iIATP5oXePa4LACJk8SDA32Qou27doaypqH3zfwd0QqKAtT8gI9qWMLcRGm379GRVy59LgtUxTqnGWvJViImDnMqtTKplAeQocbnMjvJrdEQC1nxA/cRkR0k6/D0eaDwzD92yO07n4atX7Mj6DJTj/Ht0B0K5owECUXC5s73jMlK8xLCfCZq//qeSWGxuQQsAC6OuNfISh3llaV4PvztEUH9AfTUpCJd03oDkOm34GsAkXPwVmk2mrXMbmKu6Gumhm5qd+0kc/wQWynu4aBy3TmQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

I’m just checking in on this patch to see if you’ve had a chance to review
the benchmark results I shared last week. To recap, the caching reduced the
execution time for the NUMA_NO_NODE case from ~2402 ns to ~453 ns in my test
environment.

Please let me know if the performance gain justifies the change in your view,or
if you would prefer I send a v2 that simply updates the TODO comment as you suggested.

Thanks,
Swaraj

