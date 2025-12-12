Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFAFAD4336A
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 09:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649636B0007; Fri, 12 Dec 2025 04:14:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621346B0008; Fri, 12 Dec 2025 04:14:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5366B6B000A; Fri, 12 Dec 2025 04:14:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 413EE6B0007
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:14:05 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C47861604B9
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:14:04 +0000 (UTC)
X-FDA: 84210257208.26.B72AA5F
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1D39514000B
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:14:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=GKPh8o1P;
	spf=pass (imf09.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765530842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avilWIry9gTxLFV5dzlklnHAwp0+Z25pb6ACZiTI8wE=;
	b=E3jp13lV1wvL9WdpXCi7tAbG7kb6nQ++JPE2u1b/c+8Ih5jhFxzvsnf5xA61BYoEffGUnr
	Qz90gS3qCl30g81RUh6gQsody5IBm60IVCmJXa6WLAWyFQ/YyXS5GTxUhlw6Vj5OFyNKgp
	bHk5VAjrRZ5BuCRJzSbA8IjEfbH5i4s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765530842; a=rsa-sha256;
	cv=none;
	b=T9hjWk+MTAGW3saab4dGiDFrYY/ZF0rmktmueqDEGJBAMdAxXCettNMaI1mZtCG2BtZGNS
	4dr0bT+yDcmbQ2zi1uD9bwPm6wH7s7WFTxnrdkn751w3lwllM6+ziMYIFwhmktM9jgQW1M
	pl+zjRYGQCwQaAjQW4x2dXgLba5rH3E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=GKPh8o1P;
	spf=pass (imf09.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BC90UGQ2505028
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:14:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=avil
	WIry9gTxLFV5dzlklnHAwp0+Z25pb6ACZiTI8wE=; b=GKPh8o1P17lf0KKJKa9b
	Q5yu+41K5zsh7QbMxnvFsPzmmtTfVAoCBEmC6sjCjGByGvsEzk3/DMBEKAf0ZXIX
	Zb8wQnlthE3Op2+W4xfZ+fURt0FX+jOqmcOkgBxFf0h6ILh3m2uD4d3JnLLrinqv
	dGLeCrsHQFgqRtgdgmk1kn3Q7Yyq5M2S1LYhjbeT3W6AWWhlcB5tcaTXwiZmyTOo
	PjLyfN4w162BRPpXH8VPtnkJPcfY1tnnBm8mCT8d2CrCrXQIxo3N1mzDL4956LCw
	q5e9jRMy6e1wl2yPsS+7aeLHX+/FlKiHn/q2TeYWhW/sVPcXm3FR+lR+WOEUlfu1
	dQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4b01tq5850-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:14:00 -0500 (EST)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34ab459c051so1899994a91.0
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 01:14:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765530840; x=1766135640;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=avilWIry9gTxLFV5dzlklnHAwp0+Z25pb6ACZiTI8wE=;
        b=hxNkzSZtyAO9xt731O/dklEBQnuLho3ya7AO1vhMftEJOKbmeRXHyv5gKnh0O7SKJy
         KsR2jjlGNDaFQFMj8FIk+wVYbAFvIYiheNRlNoZvdlImMQTv7VEUx5Bm667UnKz9lgrR
         ZENbUg16j9+q92cJh69r5OuYFlNCvKbiCbGOYJ8fcrZydiG9RNLVFKT3llYtsveZXub7
         cXZVMU2ahdtohTe+ClTJLnd+QJZFXYS40UOcrOBYY2Ws5l8vscVXEmeTs/ugUwO2dNeI
         w77gjY0kJBrCkXOYnj3soB3wr+heA1A1nxyt+c+/E/fbVzOOk/RuwB9PgvDczP0njuVA
         UYig==
X-Forwarded-Encrypted: i=1; AJvYcCXkMazvgtHiugM5MTQ2hPNxftIicP1WOSfUhiXkj84nkDqLTL8/qUDi/TL511QUyW6mHUKiAmQUrw==@kvack.org
X-Gm-Message-State: AOJu0Yxk0GN+bD19W16/Uvb2N189r4mYZGQgCfMcgjRhLVIjEX/Q9+fx
	6bbbHNGhm3dB7soYO8MLwMsTq3Go07Y0fp52gc4HDcVWgd1ftt2uQfDOm4UjvsiXW4GuJmB8jn6
	HesNgPVSDxTZ5YhNRUeOM0QQAmgA3gvYmSdzFv48cSJOUyJ4i
X-Gm-Gg: AY/fxX4Y5mVD9quGN6zWeISN0AnQN1c100JNXjXAli/n6tP4QeZFeaVh6twPmpcaHKA
	MObPeVM1ZTw7PSfb94pEHpYQ9ufM0CfIikqB97OH0OGbCmNDdCoAbzkqnKAoa2JLsKnixF0fu45
	Ryyp4yeV0VN0REcwcB9EpZclI4PwSSrSzMQykcOKSq7uYuZEAp9/v1wGIxZV4UuO2b497f68sza
	Li0130MrbgfeIOj80rz8XWxq0V2zQZa7/DRs4zvXaO+xmKAKHlzeWo/bNjq0zYV1R4fTy9ZzQYe
	CXSvyNBJ1lw7XrDXQ09jZ4T2lfvVC4cSAvxXPjNJHFR37GpgrSduz6+eN5Acolcrw42ZqOwkd31
	jvM6QjGpjg7NpAU4PNbnpjpzz72KF6e5r3lZgZT485KcGqx/RWtj63ZQc
X-Received: by 2002:a05:6a20:918d:b0:366:14ac:e1f7 with SMTP id adf61e73a8af0-369b07ab627mr1259543637.73.1765530840075;
        Fri, 12 Dec 2025 01:14:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IELRX7SnPRiviMlTSgk/0tB6eCplpLNDZWHl3aivotSRf1ij/an8wIly2PXn4fRkPYXltl+Rg==
X-Received: by 2002:a05:6a20:918d:b0:366:14ac:e1f7 with SMTP id adf61e73a8af0-369b07ab627mr1259504637.73.1765530839512;
        Fri, 12 Dec 2025 01:13:59 -0800 (PST)
Received: from [127.0.1.1] (p99250-ipoefx.ipoe.ocn.ne.jp. [153.246.134.249])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea016e57sm48497255ad.63.2025.12.12.01.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 01:13:59 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Fri, 12 Dec 2025 04:08:08 -0500
Subject: [PATCH v2 2/2] mm: Remove tlb_flush_reason::NR_TLB_FLUSH_REASONS
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251212-tlb-trace-fix-v2-2-d322e0ad9b69@columbia.edu>
References: <20251212-tlb-trace-fix-v2-0-d322e0ad9b69@columbia.edu>
In-Reply-To: <20251212-tlb-trace-fix-v2-0-d322e0ad9b69@columbia.edu>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@surriel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        x86@kernel.org, Will Deacon <will@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
        Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        David Hildenbrand <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>,
        David Hildenbrand <david@kernel.org>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765530499; l=689;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=EmdTK/fRZopBGWpziuNMPd4s3SKCTzTlZFLJE/4064U=;
 b=UsUA/XaWe7PQ81AUFd/Djoo4VpRjtMdRkW6w61JAXpaFzEpvAYddwkNn4lF34ddKsrIvtCT5K
 qasOL1ORuYzAbPIRlACXAmu8BfEbBJOoUBeMiE+Sy0LjYBxhUHo3KIn
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=VIHQXtPX c=1 sm=1 tr=0 ts=693bdcd8 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=gC7H+NTNV8TiHuUi9Bl0tg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=20KFwNOVAAAA:8 a=fwyzoN0nAAAA:8
 a=pHWCnKJda-1CI8IbBYIA:9 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
 a=Sc3RvPAMVtkGz6dGeUiH:22
X-Proofpoint-ORIG-GUID: GNxd36VTWabPQpSeNqqBBrA87NgOoBLd
X-Proofpoint-GUID: GNxd36VTWabPQpSeNqqBBrA87NgOoBLd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEyMDA2OSBTYWx0ZWRfX/7zNpyCX/cIp
 0v+xYtTuf6hYClRkRMP3dJBupG31B7ldr16IPYj0+03BGH+Hb38ulbjdVSTD8OPH2TfmiY6SbyJ
 4EUidEanopVevMf6tO+8D4vaP792iW2IAzcRwID9kMTaGA+m1UYTfyKDvMQ2AqB2usfZCB7KRp0
 cWlzUuaXrN/JUJ7GHHJNBkMIwBpz9X0PTXeRdyap+ALgrXz06APhUzHiHHEL3a3ZW7mbP3RPlw1
 wSu1nYiDSXk7Slax+5C3GH2XSK8TpKMUbmkSQKBaTZbEGgX0Lquu+WPYnMBlaxJSgJi85ujS5+E
 D3aTfxisyayHJe0HbiunLjvAA8XEFHWXvFCF6NNlegoO8ZgdgbYa4jpUREkX6LWMuUt2hHaut8J
 H+BFxSwTy5MsE7n8cP9/RJA/FFktIQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11639
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 spamscore=0 priorityscore=1501 lowpriorityscore=10
 impostorscore=10 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 clxscore=1011 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512120069
X-Stat-Signature: h535hi5cfqge6swjxhrm1pch936qwf5d
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1D39514000B
X-Rspam-User: 
X-HE-Tag: 1765530841-533387
X-HE-Meta: U2FsdGVkX1/GlZ087pRXeojx7dgG6RB4vfGZoEXOY5Oo/bkb1AISczdoT0UaF4uMV73+zs7z6K9pQ2AlUR9k5tQGj9ENvTsVQqsruRYCNyCUoYTWc0NQ/Oj9W/ghGz7EqMsRtgWpFCE0EA5P2iWjghK0egh2TdlpvCBIOT5fYNkWJR/DenV+XWLoTWdDJS0afjGgPHlDGi8ZFcyPB6ODBzfKW5c3G5sUAavftaX8fKfcGvqdsQid3EobOX6LmnBItimNcbTqqFWh5EcivfTEfeJHgx/VFZPF9hYE/CusW/eDKh/djd8eTvPSEUWp8uXzrrFApzYTXcc5T4y2VsKaJ0/K4rxQkkWBaU6Jd1NHgvdPsX4TzKglRjZ7DeBEQxpZcNOz611FVrwyVsiKSQ6ttsS6e19BuiH+A/rQpd9BTX5LFlGGJGs6PL/IyUPsuViNYMOvd9wY00WyYZKGZ2a+OC7UF5DR9dEuSmJcI9dlSF64BBjslLuExpph0QRshW8NKxm2iyrMpTlNfue0l7UMES9Bhi3gA0cRFQ+yDNstj0OmNTfvZnBLUl61YeeUqB5LAuHmsltjO6s9+ROgxc6psedEtK9C152OjfcZ53jXnTTVN5DKsQJ0CtioRtCcrILVscZG7ZxZw1IID9LzhKXivvNkCZ8dEP/jw4/qIM88wYRa/HsM5mYVU2AeDBdFWVIgdSmGAsqUdrCcFoGYw6bNVOsRfv9EE+UEqPJmT2ePWqkFMTdMdesOtAvQ7Qt6xvcJcYP3MKpRsZnQT2s0rBJ+Eiurja6GX7/bNIE94VKh8diFq7410j/apAC8gbe/NZuaGlvFqym+c0qBdV0qgq9de1sdChLkkfOD2B0thq7EfJWvMWHjP+ZHv9II+gJ8dRIAsL4tg6d9Lbh/mTzHMaRxAQ4m/LlHIBQf6oZ9Yiip54oc9sBQVXyuzCGtevHp4Dc6nKdp+Hbo0zPLtCzrrGa
 hkQ7hMsn
 hIZRlcjjGOsqpvzIppOKrlmaJsLRdBtugvGyoWJOkyZu2LFX2NiBqRuwF2XaS45lwwcMI3E5uA9bnNrMu4bKskZWELEt0mHYURSUoCA8q7Uwr+t8JbFRx+PHd6EttOu+9ts9n4bkX5OaXFEbHMRS2mi81ZUt8LHSKV9fam1CzChaBq4TquhWdY1g5FuvLXZ/eo9/aUhwKytKW6fNZ8WeD3EdYnBdB1DncGUFtW0HOJKv53vBQCPa4O9aZZpfNTN2nmosGbb4MGD3e8UMxhrg2YcPgvR4MlVAplIam2bbYmaqQMVfWpwvLHQM4k+gw0iWaYBnLCgBolmD1ES6ErmgYz1rbtPVwEpp8hM3zW4qF4VTxyDflXOrIdlq5OH146l9j9SGLf50bKG6MphBpDJ2NZ+PflhLl+S7t3w2Dx0W8kBCJ9AfZiJelVdQN25OD8tiLVAwFNPaOHGakUAchlif+pHFjqet5BZgxwnitjBsIT9ZLV7jneaXLGM25aZ3uWDv0VV5k0YlSaRXwUiChI90fZ+1jiaDicG5XV26Q2C7az517qtnq38otdPJjuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This has been unused since it was added 11 years ago in commit
d17d8f9dedb9 ("x86/mm: Add tracepoints for TLB flushes").

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/mm_types.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 9f6de068295d..42af2292951d 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1631,7 +1631,6 @@ enum tlb_flush_reason {
 	TLB_LOCAL_MM_SHOOTDOWN,
 	TLB_REMOTE_SEND_IPI,
 	TLB_REMOTE_WRONG_CPU,
-	NR_TLB_FLUSH_REASONS,
 };
 
 /**

-- 
2.39.5


