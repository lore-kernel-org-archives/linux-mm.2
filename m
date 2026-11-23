Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38001606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AxHbErb3
Received: by kanga.kvack.org (Postfix)
	id 6102A6B05B5; Mon, 23 Nov 2026 12:35:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C1516B05B6; Mon, 23 Nov 2026 12:35:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AFD56B05B7; Mon, 23 Nov 2026 12:35:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2992E6B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:35:44 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1CD3160968
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:35:43 +0000 (UTC)
X-FDA: 85467086166.19.FB39377
Received: from mail-dy2-f7.google.com (mail-dy2-f7.google.com [74.125.229.7])
	by imf08.hostedemail.com (Postfix) with ESMTP id BCCB416000F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:35:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AxHbErb3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.7 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455341;
	b=t7/DkIeRhSVmccNLPlVKYQ+OXtvIacsgtiKx66Ph7PtVIhZnHBqJ9h+KOIOZ8PdKFbpLWB
	w0Ur78tkNQOuO1+IaeiY/IN8HaRlQ+mwzlHptVIgecCtANxcBvBvOSVk9lJlAfWArQlrle
	CdNFwtcPTNGfx4KXuPsRFmM8snknJsI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7F+8ITRX02mLDnos/7a9o9PFJ5+L5LzcuUjZXYMI0/0=;
	b=XxEOaObVWs5ddQsAxmZDL5DRL6x/mth/ktBR3DZhgkZqaDG0vuu3DBewFCSQMTz8AIg1s0
	CKUCHzD9fRsv8EOW0yYpp6J21CzR2LkIuqPSU8xmGsW1oJsGGzpkwi6loehqup7KbrJ4QH
	hTvkj+VoW1BY05MO18/1Pp5u+Dt8e+I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AxHbErb3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.7 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f7.google.com with SMTP id 5a478bee46e88-36c9b5c6faaso1365317eec.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455340; x=1796060140; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7F+8ITRX02mLDnos/7a9o9PFJ5+L5LzcuUjZXYMI0/0=;
        b=AxHbErb3ndjuIwcWsc7yPrU7/xRnablnUkQm9aCEzaDnGAd7by2Wa2zk38ir6IpGez
         8+x4QyTWbYFlvuuj8i47c6YDk/mhRTxuYS0n7N94HbpIXZ5ZasVUXlHtkkp99eM1CRvA
         HLTxex2+CTdNDcseGVb7FmURoeRyeke2p4ai/embuecveeLJQeQPljMt0nWZpLl9Gy3j
         9DIg9UlZPVuPsQYrFl1n9Rkt2MOwflQQGsphpNcJOkrrtAO4pyN1Wiq7KKlyjZhmyMKs
         r1BZX1+OsLts0wceIxClbzshAm+C4G4ygCW6+f9eP203hyuhu1SMFhfKDcg2j9EusCDd
         EQAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455340; x=1796060140;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7F+8ITRX02mLDnos/7a9o9PFJ5+L5LzcuUjZXYMI0/0=;
        b=1M3BythoqQhX+b8ZbF+KDemCoQEy9OG1DES+vyrEXNz8vvd6XTqaRHF6bAQHJ+fNr6
         dc4sxntWxwBJk7LBuqHaFdr2WxTo1coKfxC8PuRK6jfoxjgnTrdIGONVfrCc0wPvZFxr
         QNYt3IKsRow5+Mb65qLIAy7gt4i7suNgTaa4x+GwC3Iw4r9x6fvmO2rwp9nTBM8SkFBW
         giplXxIJ1hIN39cPoCzV9mqzvBzs8sJXedL1iPxH+UFHXlDwMi1LTr7JjDgx0nyGqUUa
         71U81FWcypuU0HiIQcQl0Dg0+uDTYdyKbg4Kqf0r6gH9/68B23R5FyNZ6YL051pVz86g
         /GCw==
X-Forwarded-Encrypted: i=1; AL+hErFWMGpcSXKR6Qy1iOAyjo9L3EHA8Rb5dwQuUy6xrITxK1Eu+tBgj30/3q0uheMYA5FOW+AK2P3Qsg==@kvack.org
X-Gm-Message-State: APuU4Z+VmKkykzQsh8waLvFE2qUDb6s5g1deSPVzi0VSGR2JnBKqTwIg
	9VSevI7fwChWF609kXLbA0d9MX5uI1v6wzVmWdgqopDs62ft0iYRACiX
X-Gm-Gg: AZFdTZey6y2OP9/94ToibwbK2v3+PtXcMyJafBXONwO9tQW8MlNcNUBxjIw6A3MFFDF
	gETok6+qDv3NYCDi4jr3nkQN3LjU3v8fbjltIgHnxOuv2G0eWy5LFv3SZ3BHhRw2HcCVfiDq8NY
	Q5ianGYBrlsBLwPkkSyxC2V7OvtjwWaa4xjOht6bcvf5yZREYMCm9VZNhoHDAS08cjZPF08wDww
	nesXHy8XafdCpKmMmy/kYnLfwKVNv+TyGGVWR4Xs1Zme1N9PkNIFLO4xfD0r00oa7Jki/m+LJtY
	1UnOIwZOP/vVG+MQBQKeLeMQJ3xBjHyvFzjHH+rurm0WVYC1/VIGO9gzzwHE9Bvx3w/2a6OoN2C
	Dw/Ck0ZljLg1af+1wPUx3E3lgzAVb6faw0L+MruC0IBOdMzCKHLtqWfvQxY9kxvTjwUOFPxOxxc
	kkmuxnsQZ3hIHfluIaqa5KQaYKqGPTW7iyguoBrXCI3wbF5g+qhg1xt0GZDLLRjV89S4SfymHjQ
	EA4DbDAxU6yxTB4GlEi0S8NScdeMbxJ0a70HbJFoA7u7aHDTAVwuV+tjKOJejgSDBHAs4KoZQTU
	TyrHecSP6h3qwd4Zzd5DABHl4lKJaC8huHiciif8pRGen6h658HDsQCGZxF8h1iiHGyxNEyTxHW
	2QyCiZmNRibarnRLdq5MlMbw+a6XsBxkm43ll/W61f9wHWUWs7y7SARtykLjIrg==
X-Received: by 2002:a05:7301:4704:b0:383:729:cabe with SMTP id 5a478bee46e88-3856f8519ecmr13298813eec.19.1795455340146;
        Mon, 23 Nov 2026 09:35:40 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:35:39 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 04/27] mm/damon/sysfs: add admin/reports/ directory
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:25 +1100
Message-Id: <179545256506.4.16243298231071152571.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 Lian Wang <lianux.mm@gmail.com>, linux-mm@kvack.org
In-Reply-To: <20261121210013.130397-5-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-5-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BCCB416000F
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: kfpk3arktu7tt3ffqk53bhacojmzwut5
X-HE-Tag: 1795455341-818906
X-HE-Meta: U2FsdGVkX1+xNOi9P+xgGz3S8Wey3GWnB4PthojjlgwDvQ7Q3fOThiQpiQqHGEyWtve070oKjJAXhk6n3+VPtQBD/MHwv+cweLy9vXa2WeHWvMAT6NizEt/I1UrGSiWacWiM/uvEE3Es3p8xxtzTMgPygSTvOrvaOmKvPtADLoho33eX9UbxF10BY06EByv+VDlT5DasjdsNm13eiEETyWgDqFHWXbqiBN1nAkeW1zBNEdUUf0x4nkmIq0wEPjbY3r0bll39kcQwkot3AGqrxVbNUOKGVPb2YtEPl/DQHXSNPAvLRfR6Dqm3EeQgtIQRaXKIcEiuN5DjnKBNbFbexN3DwrMlXnqQrHe9HIws6z6sMDOcNd05S/+sPkFE6e0MsbTpEtV2JOpLw9PU7mOif5AR+Z/H/e/wIpsMlzMd0HL7E5UZQYzLXoklj3tjJ6ZkTcSsJdw/SAbcY9miurJii/9cWRjHYisFDJEj1b4UlZnZ3PSPW8yu1CTRvbvSLz3qe1w1LvqBv+dDEMP0YQ/R74onRyoZWfWK0SYgdWXOwx/v8CGE1G0OFNaUzaXQIGjYPX5ucQvvdD5ZaV9TJzr+UtUt1nWHd5q3umbmWSWX8PEnLkykS/thP2pIoHKY1mvqPtCFWqHKB8xH8XlbXTaOd1tn7UnZNHojrJMU/XqmUv7H0e4sHC4LaBcAQBcdStMviDkg8EavXCWENAYRgcFjKCGUVGTko2BNtafbhQtOLPtRVHGJWN+SqMLC0CdIxXFbetMZJjS7hElUv1Qo/3zMPpHn+rFZpUsQigVVFp3Me65kBDbZEk6Trc+TwcLodc04wT7SjE52RswoB8OVJ+oIG9rolSVpSnGgB3mOJ1hS8b3FLZtmCqKBc9ykFkmnpqdg91ismyW64hcoM/fCfYxBe9YPE0Mm9Flq2E25WOuoXt4HqlSVrs0mvaJ6dNVRXYab+Z3dpc8+J0KNYnZE54G
 d1amqoBj
 Pcw+CijR4EGRDzjNLWDndGcV2rrK+RuEfJHd280E/6RZ2IFYdPZYVLYMtCBAqpL7u+OF5WWiJ7lpGuIS7hWpkw+L0EczLFmqCzGMFVlhOlJieZ6HdZ9az+gAobIfP1J1POTD3aG+O6zNIVYc0p9EJ4tyz27MC+oslpLTdkZ1e76yPUvlDb0JAwaPlKd68iXMrz8PJx0gvYyhh2Jv2EAlVfRTTAHWaSucEwKSJLW+aquv44Z65RJoc0bPfObx4kulBkd0SYOd8OjATMyMg4BeGAofF4XWw8exStQlGgZ8+DQU5seqnNFH3LTnxHC7mODwE/NeZIUCX4DRFGUQJTRCpsaH4Zbupj6y+aODw3IbCBH8OaYFxsgrVw7IytMbNEJZQWj73d0C+Y0rnXw3TLIyiifeDJs0qlqLo/3Gb+vgWW+TfqIK23+mugx3/IFIYdfmjCrWtVtGyohMv/iaxA+k82LpZZFGIBYWXVTp5CnWJVIhIUNSvenvX3B949QaL3eC8jHHjptbpbDSb3EKsIDckWTtr752jKDkChfknpFTEpdKxvzYcB8YEjP5nFBFPtiFmRYKPUjDctamHV5qCoMzaIUYyrknjeIPGdS4rs6bQDFjNJFU21OEMRZfueMyWswHgZpnUgiuPEXhb4BkNqnPPwHR62WprwTboAGL7bDN5lHCp+/iS8rkbT0fVIlLdDW2yvkG0A7oZ8qIvuX+a/InCrNzYoltMzHVMTEB1gsSaYM1N1PXU2ELmtmAYZqV2DUJIbLll
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 12:59:48 -0800 SJ Park wrote:

> Add a new sysfs directory, reports/, as a place holder for sysfs files
> that will be used for controlling the data attribute report system.  Put
> the directory under the admin/ directory, next to kdamonds/ directory.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

