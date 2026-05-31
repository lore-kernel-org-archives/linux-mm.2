Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4767BCD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 14:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 383B06B0147; Sun, 31 May 2026 10:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35B0B6B0148; Sun, 31 May 2026 10:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 298766B0149; Sun, 31 May 2026 10:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B31D6B0147
	for <linux-mm@kvack.org>; Sun, 31 May 2026 10:17:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9744A140482
	for <linux-mm@kvack.org>; Sun, 31 May 2026 14:17:14 +0000 (UTC)
X-FDA: 84827917188.07.7478933
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id AF58710000F
	for <linux-mm@kvack.org>; Sun, 31 May 2026 14:17:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g1p8fP0w;
	spf=pass (imf05.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780237032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QETSw8/RXe/Tygaegi/uCWCwNOf7r+7D6WQEjI7aiGg=;
	b=YPxb8v44Pkt+E1XjDg3UI6NFYqRKen9xD7BUoTwQXkfZiQqZqfTrVZEHLK4vXtvuddFptC
	e+EaLmqbBZ6wPSeXEetYZ7GMSFSOQL6ISnnPpXInqmKl6gOv1T/fzNdGSCQSZFwqJAvcyY
	YKH/0oJwNPj+6mCEJ5CbLNPyOCeC6CA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g1p8fP0w;
	spf=pass (imf05.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780237032; a=rsa-sha256;
	cv=none;
	b=YShu5OcUr2/KLOKvlq29qDE3E1Sc3hl8XnhemCNul3C3pAaEuIGM3mdgTYwNbUj+a7QPWG
	9ckcYiK+AnspRc/NveM/JDGJLscIhaXzunW+wQsY73OI+/wkvvlj0+UoCXi1nHRbFtoLAi
	WgN5kQEmBPVyGJWT7E5dOG5gySnw/zg=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2bf258aba12so4203735ad.3
        for <linux-mm@kvack.org>; Sun, 31 May 2026 07:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780237031; x=1780841831; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QETSw8/RXe/Tygaegi/uCWCwNOf7r+7D6WQEjI7aiGg=;
        b=g1p8fP0wdRSkt4ilG2DYU1vRlmX9Xc9xHS2ZX7w5c1J2QVEU5QlyxoRsAdR9ohPhtr
         GKMe5z79TdDTBw3KgJkIDpf3SupP28EluuUVznJPBz1xaLOoot4w0O9uhJ/APWAqlJ7U
         qM+B9C21C85tCT25MKcAlPiqZ7W/sWnWnG0vZhu8iT7ItH8zjfUHdypA7T6PDWg6+Trt
         ebJV2NH/lEg7Xp0X+moLuUooFdapxO6XwoUjfCtQXa81uXjtQuYqgaKPLGu1ZFnnV4DT
         8jw3zLWM53SqZnY/NFXLqSWJKowIQdfNlCmU4K4FRwXWl8wkS8AndyY4iJvpvM9Er0YC
         Ttfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780237031; x=1780841831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QETSw8/RXe/Tygaegi/uCWCwNOf7r+7D6WQEjI7aiGg=;
        b=Iqz3szrXZtL4LwjTVFjdn92ApWdkEQa6SYhnoLnw517RUG9Z8KDNL3kBktnnf13r9h
         ocd9znthmhYewb8kx4vjFSMycFmjYUquWDD1hObWMYjJGgoufFk8ZY/KvzPaey6vGKeo
         EXEFbeshBKcg/mbveShsIXbqJmCBcrIfEiKyMyWH5zXpk7YwdgHYIEv5PnJ8sn0Cmtbp
         vveAAlV7dTtuhAdBcqTLMvoCNpJdONV86qnHHmA/Kys3ZDas50yhPeRkxDkkpF3/Gl6c
         3mB3Hem7A2mtCd3SwFz6Buo7g6Asx1rIO2xxg/Mro68DCym5fDXiDvDPM4hTOF/HdP7f
         q44A==
X-Forwarded-Encrypted: i=1; AFNElJ9HgDFDOBl3U3Npyuftf1cFDlCAvk9sbgTqxoKDn+jm2oW5u19edQDu/Bs07o5QIf7/CGv+1zOMiw==@kvack.org
X-Gm-Message-State: AOJu0YysymWZ2Jo3ezug9w4CzGaFbspAQytgJvvQT0t+Awgd1aoJ3Wja
	HePsrFquA1h5rDk8SJrtGDCZYeFfXppmohTgsmh0NLTnBkkqDr0VoAAJ
X-Gm-Gg: Acq92OEWxOqFn0UszGQ3df/9Dz0a5nwRwH12C2M0i0G5Mbd18v3MhYX5elx5e8AAyd+
	peXKBle/24k+NZhxG9rZUAa5pffKXz+DtcsjVE6bwH7la/fcvjovRZx6QglSRgG8o4jjKUSsAvv
	OnxCMIi3P6K9GUL2AxCBX5CBQS9rbDLk1FWzIGEOFQpVsClM7MhE3tWtBe1HjGah0/1p8wIkXWa
	qj1Uv/bc2t2pPGATJvwAwdFlKL742dpI0BpA7b8wr2L9UkHT9diQD12Dcg0SfxrHQTXN6mPU58v
	mx5nPCVZGQhLjKa0Uqx+wdD70EHuH/yNMf+UtzHsUMMGWsoXacpI+LPf5kv9FqRP3jpYcV95QVo
	i2eBFxyQyms1yZ5LaB1rQRNnEEakJSrQ0AepCuzVmk0BtjSMWtuToDvioAAT1a6VobTSYTrug9j
	2uCjEHi368bXaUFsyI8l0Ukh9B5McVFMSJlAgTgrCH5zqkkX3YqgjmBK86+Qkr6uNFzm2Oqr5f6
	/dTBM6TqRIimMFziAAt8As=
X-Received: by 2002:a17:903:1b07:b0:2bf:13f3:4d3 with SMTP id d9443c01a7336-2bf36375bb5mr41175755ad.0.1780237030917;
        Sun, 31 May 2026 07:17:10 -0700 (PDT)
Received: from fedora ([38.244.149.186])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf23c0d727sm73838965ad.59.2026.05.31.07.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 07:17:10 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: nphamcs@gmail.com,
	joshua.hahnjy@gmail.com
Cc: haowenchao22@gmail.com,
	akpm@linux-foundation.org,
	yosry@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@kernel.org,
	senozhatsky@chromium.org,
	xueyuan.chen21@gmail.com,
	haowenchao@xiaomi.com
Subject: Re: [RFC PATCH v2 3/3] mm/zsmalloc: drop class lock before freeing zspage
Date: Sun, 31 May 2026 22:16:33 +0800
Message-ID: <20260531141633.27779-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <CAKEwX=OjEkm766-js+mxRr2KBTSpLxc6wRWXxVuBXt-OT+drcQ@mail.gmail.com>
References: <CAKEwX=OjEkm766-js+mxRr2KBTSpLxc6wRWXxVuBXt-OT+drcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rz3dzso3a8gpcrrb3ckw9x4ksibfwzqt
X-Rspamd-Queue-Id: AF58710000F
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780237032-808749
X-HE-Meta: U2FsdGVkX18YRXe05zR3qz2rf1rLpzR8b9BUpT0Na+U9LClJaMjdPlyHM6+3ze7xA7WO0fGxtAzMiAWXZKbU57QCpQZZbrALAM3FOiSGt7n00ODx0jMepLttx2t4e2TkNrGpgQQ3cTMhgCvlOIRjsKQTdJKnUZrjVHW8YK3/sYRttKq+bYff3Yudmrild8kj3BVZou9gI50OeyvscknOpSsGjEgC44QQuGWRSVeC/4fnF397Q2SLjbMWqDpX49xi5oSzT6nS14gySS1+EzzFhtGylIi13CxVhdG24/DEL2hDpfy5RcPxLZVRU3fzKkQYdzocNbsnozjKcazGwVMo9dYzc+b3MGODLzHLU/SO5nZzPN5UkG8YaitUW12oqLzkweOtQdmjH4eAKMQMp3JeOqR1TTviQhWsOy35A+10vtpvFfsF3RokdWeiPh/q3lxs5vYEx00qm6PC0h+yO6FstvaVlJD1/n0iDCaDafRUJeEpx65nDtPXtzHajwKdhSG8dnuhiiSbEGT75mMATeLWOMwMKTFyJojRzq4PATdqOnjLqDAiGAbWblzockyTmbRTYNhCMyYu+fXH8oDjagOs7I98aq+i1R/lTu8J7eqWir0KdlF6GiuGklNtAeJF+gpK1HviGWFPjQkYjNecOCiGJmDpNHB06LzNFqZPgsVO54XDEHXdSVFDgkH7dgk2PIAQPRkKrp4g2PIU09BKFfJ3KlGUQK1FzYNhvFQ4j4P89Ty+u2yrvDDpFxnpeBVhQYThoh8v5egdyL0ImPQdFkG4rYjF4qM6yySLQLBSVs/sDAKaNJ16Q7OQZD5JMjAoeXuWiqySqcCT0YVVF4ZGCUashq7CdZLuBqEtCZJnDEhkJLcr+4VQscUQIqhYeSauoMs7e4MegN2i/RA6arSgMLAfwDAFB2LFMUhrkl9oM7db8Kc14VD4qzMDQpgksOjuw5q0EK6YjP3xe0VZbtcGGW3
 L9su5kVU
 T2o/4hmyWS5BrnSCpCRMBS4e7oF9QJDMJm7x/psQaZbEUlVouBAIObNTQBANpDUrCl9xlh0UVA40zACtO3ujEc+GP3tLMKg7SWzgIy/qc0fj4YfChWAISC7h+pC6rGEiM8Xk9kCuf4gCqPFkMifgZp3LU87X/iJEapM1+A0er976TFleltbWwFSuSr1H+y48ENvleupjlXk6WjFWdufLHMcjaknBhMvEUUxpCcDsbeYyktwXTexgVX8ka69qdQsNDc7YoR8dECACvruy2D2utH4onLJgZgTqPhqWYn0ctzJ6HIzs+COuXlwZDwgS03Dsha2rsRDGd2m9VokR778o/bPqCacJxjJ5WiXNdyfQ/zkJOOwvN3UCmu5K2wd4qfrlIVROgRpSHqUshwN3uHBeQCn3z+T4t1HyY6U4MHwRnfo++cTC+L4wbYz4qjceELW8wGb62zW0sYvv1jVMOGxUFOlwvx+xi/dQkglK2ytdi+9Se+a09ovzhaSwPlrapHoXGzcpXpNkMrktofVv5cmZQxiCskoq8pq/TI3g074XQ8Gjd2t9pRAGgmfiGOyqbiXZe2194xlgh9TU184QfslbZpq6/YwIkcCfQM4o72o14fVbsCv0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, May 29, 2026 at 03:59:50PM -0700, Nhat Pham wrote:

[...]

Hi Joshua, Nhat,

Sorry for the late reply, and thanks for the review.
You are right. I will update the code according to your suggestions in
the next version.

Thanks,
Xueyuan

