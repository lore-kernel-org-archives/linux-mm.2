Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C8A8606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 20:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=EAGQcZQk
Received: by kanga.kvack.org (Postfix)
	id 5352D6B00EF; Tue,  3 Nov 2026 15:35:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E56D6B05B1; Tue,  3 Nov 2026 15:35:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ADB46B05B2; Tue,  3 Nov 2026 15:35:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 009DC6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:35:11 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 808C5A021B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:35:11 +0000 (UTC)
X-FDA: 85394962422.19.63EC31B
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id 83F34C000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:35:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EAGQcZQk;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793738109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9fnNuB1Wct/8OEoZPHjnr7HEm078IbGQ7GxgW+ue7k=;
	b=jNPUzbDUe7DwXmfxkTwBtqMdU2GWtOukvuzz/h4ce2Er13OVkDrShc3Ymei8EWOX8VnvFs
	F+cNorRNrdloLEaaM7pL+IoxrhrUOVLimRQgwWUdeKig47gJJqOLmsbinG0k5V7yH1RUhc
	ArE+plLGCA08iG32S5F31UDmLMrsPhA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EAGQcZQk;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793738109;
	b=dE36DCWh3TkBsDi5CC3g4fjjPuEfdeYgODKltwXqDSPWkRtWVBz3UHui16kZTQlLWwpx5r
	xo3X1fjun7eoB4rSMhDFdTAbj7AJQiXYFh52twkc6qGgBvRIr0JvrJxjF6EwKJK6CTB2Sp
	bGupEOAv/Eo4f8X0SZ2IgJVB4rpmvJc=
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-7cc0e865dd1so1559745137.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 12:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793738108; x=1794342908; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=q9fnNuB1Wct/8OEoZPHjnr7HEm078IbGQ7GxgW+ue7k=;
        b=EAGQcZQko03wxsoZIMW8GxqnEOKILLo8GSZWKWTaaNtzvloUuJB0mP5Py98P/cogW7
         EEK6uQsjXI6F3ax1a9e9s2v1nvpWTu+6rrgxKnOEc3qgCZSeCYNpqN9HQDsUR9t/HcAd
         lPTe3QmmD1+fzfQcnVryFunF/+Aw37u/UvLeelMjrFjppb1C2ecvKbV6XcZO9qvqvlxa
         VzS8V7UmD8OUeiOfe1l8kvO567RIzYoMSNM7EbCso6KYQ9SxtIjH6aZRzFOvPk9j6LTD
         JCO9LpubVvztsornHqLWFnhb4x5X6AmR+xyDPLNoNsU6d6c5SJb7bZJAzSI6LDUsQyty
         8diA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793738108; x=1794342908;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q9fnNuB1Wct/8OEoZPHjnr7HEm078IbGQ7GxgW+ue7k=;
        b=cIFk6sE0xsGprX9IVrLqeJBb54/QULsxjLiEhXfAYUtGYiVIq/pPOZ+eWINVRoZJkY
         Ny7F5xrmz5lKif+7sAf9d6Vz48L8wxFhlCtpPXHIktuN1EcK/25eyRs66OQKl9uez1X2
         aeYrmclmQbMnHy89OSdcTDdyAdEgQvlyfgOQGaXpB/Rm5pKtmY1hnHLdyyg4efeWbILY
         5puDwkiE/BWOwdzxjZMjTCtNW+Va78ZMpD7vSOvMs93ucVHMVPUOUEvd6mEJjhjH0s8F
         YscyeUVbyDKrRhiz7gcLq1HpjwB0ZpTF/ovqdTuDRWPybphALl6dJ1SzhmHSi92AK0cW
         Bh1Q==
X-Forwarded-Encrypted: i=1; AKwUvBwtN2vICnkSA3XsbNzqYbPlw95FQewqLDiihNbkMCzm98k0BovSzxae6Y636soVNPPtwK+0TTjY5w==@kvack.org
X-Gm-Message-State: APuU4Z+XcVMviW3Ufib96LiKhBvxNOcZzWXTMLO9OyKl1LmXb6Y0YpFg
	HDsLTkR3YsELXngxU8e+pEc2UQdXqPsbzWjfW/KOr2nwPlkxtDskWeP2vyZ5S22iFoU=
X-Gm-Gg: AYBFou3K7bAtCKLD1z2CSPQdBFSlrUoLSRNshtnUWNdzKtTjr0iTivnwfhg5xXLWRW5
	dvZGpEzrQbF6c3/upv/z6YIOvo5rWNlrjHRV/74s/6wko/mwkwKmJhGu1BjOIeR6qvRyeuMZdLD
	QN9pUqg0daVgoPdCsnKxTFpwrNj7dADErtKP7pxaoTFdAAdH6L8RyuuKgbklRlT+eGEYRqaM76R
	XudADA9hK0wzLI26w+LStIaYY7A6YxEpx9Ihu5aoFU6RYecVhdWZpnED0Jz08TnDhOK+fWLYCjN
	N31sJe97uJfXBN/HagBr24kvlHgF6cAdbKQgqNapLDSg+sh7aDeSSMS28cP4ZyOie91/Ku2U4IA
	YLUIWCV6M+AxvF5ApAzu9UywhmgPvKtzNqXrjpp6tUry86l1yIdTOmg9EtUQgfKTfjM+4fYIJfp
	9YvjAjU2rYc43s1X8ITPCWcg2SkbBIHmSK0/vKreSfSM2swt6oPtE03Rpj9RTdQt7qDgMjBceU3
	nfLSi4I3TU8M2jT6lQ6LFc4zPxxuxEtPx5SjWPhhxzPpoSCrCaBoU9C8HFKiuO7HGpqLwnV51mI
	A9e/0lO72b/yNct3OsCVtjZMtQniw+M1nKI3jnvXk+QsHixBReoEJvpmdmOsrdzF22xm47/RrDl
	0O6wAr2kDcv8SCWjRIfN0/IwJ8J98V40Qm9k7jWzd8TTcUUE8hs1rFhUOku4+tIJbWjwV
X-Received: by 2002:a05:6102:689a:b0:7c3:7286:b7ea with SMTP id ada2fe7eead31-7d072c18c5fmr5571067137.17.1793738108579;
        Tue, 03 Nov 2026 12:35:08 -0800 (PST)
Received: from soleen.c.googlers.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-998d91d212bsm155984241.6.2026.11.03.12.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 12:35:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] liveupdate: luo_file: allow keeping private_data
 from retrieve until finish
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261103181916.2462825-2-pratyush@kernel.org>
References: <20261103181916.2462825-1-pratyush@kernel.org>
 <20261103181916.2462825-2-pratyush@kernel.org>
Date: Tue, 03 Nov 2026 15:35:04 -0500
Message-Id: <179373810485.663454.14095082591432581397.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2169;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=tHMyOi4C3Mnre2HB0bf7Ye3Kluqt8+S+aPWfRyB5xw8=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq6kV7B7E4arxmHQz6//CViXirnIcDK3k6F+IF8
 G2RMjjNCuaJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCaupFewAKCRC7dyhM23N6
 3mpPEADHu6Ct3CLDFw8h+kmZSVru4v6jD1/kPyqBbFgPi31cJh1bTfQMXGCjDlEzSOivapKaQN2
 2v/pdI2q2vwigrPI/DlXzZeWXZPTB4XeUFZNYc9LOkOHGjIgA0kqQcQe5wvgxZv93gnSG7U5MCe
 fNeJBdLPFe4VyDYlD8PPXmI8y32szJDuil5a9xrCoUKTnT0TicuuhdzsohzBIIa82svYrXJ2jhA
 m8xLRbNbsGzvGBH90ZRBeaAmOCpk4VPmTTDROI/y/X+fqMbWkk+niFXnHSjDgH1ulybqaNifL+s
 e0O2oS8tujnsw0bs/Ztt2yo4EvklFYYwbAgzPtbRvmo+pk9DIpqYb5kcERbmU0rB4zZvll2ARp+
 JgRcXoU+h2FD0f6GZACwh7yKwiffUv00MwWqxAtPRjtDhVpbeS9cXRHX3RZ9EpFeJHcXSXDCJsN
 VTrUwITg1oTg6nnzpJPVn+bVu60UYx8kd26BJSKbfiieN3W4xaEIl6vZs+cTm9R3RO8LbBX/8kJ
 aJaXh7hl56jKrQ1mbIEePSvABtuiPTQA2ZvFaPa086+0VDvcpIvuF8Zr5zWTG3Ps0MnuJwj5t9O
 GGbbagRNeTMAhWqjRv4qsStCFg6gcyAMeXHrjuvJUbQTIWRNHwzM+D+zUuhkLYZV8O4gETBtydR
 X57ZvJBdSqeDlhw==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 83F34C000A
X-Stat-Signature: tbgzd1i4qcdeftba59yz4embaaz75ujk
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793738109-466306
X-HE-Meta: U2FsdGVkX1+Mz6BzEVuvDjQ78psayM0W4YgPRQZX7aImFsiQiJG0z6ea+OUndVaKWrWUvCgIe2ageOV4xSe+Xv+42zPzu7dsH00wt52WqVMlbm7DrVliWSFN1nd3mf9zqEWyIaVbLqNGAQ8HT7q5gcBKPVE2ENhubLK8nKGFS+FC/mIGwzaFyFglpbnHsZow7vWtgnYFiKjB7lj6Cw7iTzbdza22ePKMf2JMPpSC1GLdAIL5ltUK1+1n8K/T2etlKfuk3dSnhv3RiAhBPfJd5ZlgiMR83JeBPwbHeuFU5U2WcRSKi2b7VDBPXDjtXbxET2yU4K6pxBzEhfysiLQr5SDgL97WAH2XEpBRXBSmYWkBQ08IKZlIRrkMBXxzlnzK2p01a+fepneLCFMJrX+bDlqa4eouWT8VUR99swwt6M8JESdXU8jTNbFAdeMKdSkeJ2qSWJ+1PNOUh3ULz/v+DMYpTMZWhTlnPe+H0G5vhMZNLZoermIv6Zx3Zugip9V4ChgxY6m+UPbH/zrzxQrxzmi2q0VCWnIEV/8AyHWCNT0xH+hyo/ugTvdWgUslBuwkQcsTNiGsJTvCzLokDmCzI4TAN409P0BtTCKhf2syihs2Qws2PoCfGay9Nv77W5wQZ0T3tqkg0g4FQ7/8Iey3PGjXUt7l77vxWS5f2WNKjikEGJfwq7ADSERQFYJEVs53pf/UZWqdUoqVp+wSgXgoTiQHdhkm7W+CLLRKq/cdj/DWcrSb0PJlqstYc8j1BpIDFw/CE68deKc/iB/LM3Kf1MzhlFtINmMsfr4DgWUPiy4p+HyxMQl3mszZoag5XmafM6A48SQwB0RVCbxFHKwgbK6S1aybsPTSHafgvKjapKaphdXUGKD5/ERqwXtHdq3W4W68Y9VL/cxolIFQKXLldxMadcwk1y9hVKEnfeX0iqIPIi70bLEbsTfCLVxcPoY68DEUN+1s0x+tQB64Sry
 a4K1NDRW
 VE8zoHXJeK7NcVgGlUQ8GyBqztJ+lqjr5/9ad53y1G0Q73JCQs6oz2wPyMkIE0aDCim9anfl7mHMnQX8nyVv4A/BRX+NOXBptugbVmBkPC95VtJl8aDg2uk/9Z+xkJF55BZ8vtNU8Y7lRcNevh/E5TCmz1K4s7MPWfLPrNUT005N7Y8/jMqyIl1m11vtzE8wQIwt4zywtZT4Vrlmage3m9wTiOo/rIpacjH1TRnpAmLeLeDBT8h1M2JfvXwwy5KDZYU49Cw1MEi2uCyiRWXp6dVbCpCAk2cEj8NcKmhFvvmhbxeaVi9Tcvej/1aEAAWN22lCQCRoEuUA0uemFEWK677tq0xFA/0rr1RykofYQAL2W9K9WOPIjvqvc0iHD6InBzFJyhBbQXCEJ3RgvnrgXCjcI9Eo/hFdQspr1wdriUydNPfQ2G8R3sQmfmsL4TemgRfyWYA9WsXL6LluMKeCyHu1dto/g7bNgZpqLudqz7MHA/EY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> The private_data field of struct liveupdate_file_op_args lets file
> handlers keep runtime state that is not preserved. It is set by
> .preserve() and passed to the later outgoing callbacks, up to
> .unpreserve(). But in the new kernel, nothing set by .retrieve() is
> kept, and .can_finish() and .finish() always get a NULL private_data.
> 
> Handlers might need to keep runtime state from retrieve until finish.
> For example, memfd will need to remember the folios it holds on to
> until finish so it can release them there.
> 
> Save the private_data set by a successful .retrieve() in the luo_file,
> and pass it to .can_finish() and .finish(). The handler must free it in
> .finish().
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> Link: https://patch.msgid.link/20261103181916.2462825-2-pratyush@kernel.org
>
> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> index 63ea5417de84..21caff8a98a7 100644
> --- a/include/linux/liveupdate.h
> +++ b/include/linux/liveupdate.h
> @@ -36,9 +36,11 @@ struct file;
>   * @serialized_data:  The opaque u64 handle, preserve/prepare/freeze may update
>   *                    this field.
>   * @private_data:     Private data for the file used to hold runtime state that
> - *                    is not preserved. Set by the handler's .preserve()
> - *                    callback, and must be freed in the handler's
> - *                    .unpreserve() callback.
> + *                    is not preserved. For outgoing, set by the handler's
> + *                    .preserve() callback, and must be freed in the handler's
> + *                    .unpreserve() callback. For incoming, set by the handler's
> + *                    .retrieve() callback on success, and must be freed in the
> + *                    handler's .finish() callback.
>   *
>   * This structure bundles all parameters for the file operation callbacks.
>   * The 'data' and 'file' fields are used for both input and output.

Please also update the stale: 'data' argument here.

With that,

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha


