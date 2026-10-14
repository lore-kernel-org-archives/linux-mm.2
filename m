Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CECECA9EBD
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287196B009D; Tue, 13 Oct 2026 23:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210D96B009E; Tue, 13 Oct 2026 23:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 100B86B009F; Tue, 13 Oct 2026 23:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CCEA96B009D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:58:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D57AC0409
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:58:43 +0000 (UTC)
X-FDA: 85319875326.27.1388502
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 26FF51C0004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:58:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=efNl0fzq;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791950321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hCM/rLbUxNjORiVZD5L+LGA24mSGgi/XAzABcfZnU2E=;
	b=w3W3TLMqMTDrLw0tacHI4psHGRxnEELZGR5VnTX4TGsd0Kmz8AzMXICf2KZlcWZnhEymVX
	Cwd4DBB82awJyKWTcidbYK1PYadO0DvbEalTa/8Oz8MeMdLcdY4unF3BmH7lC4LAGVNKoq
	cUU+tnYtkLkJ/2LFbu45x1Xyoq2tM4U=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=efNl0fzq;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791950321;
	b=XGpRh2IT7kS45VxSIkgpb2MSqe3/xRTswee5TxC1hEJDNh7YFEQvTYWgNeEaajlvWQlBEg
	kdMNz50GwFAMlfo/ZB8rFomL+KXUfcKLsrxq18hS+iyiTMThIM3Cj2Wpe6V0XctLPHRNaH
	jeUElNUR+h400Uqv8mRyOBRteMD4TSk=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c169ae1cb26so1026572466b.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:58:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791950319; cv=none;
        d=google.com; s=arc-20260327;
        b=YjE440JLRlmMuQLAojNJtZB6EDIDOM3I83tr6JjXW/mIy5h86YcMrRseMnZ9YYIPdx
         LpdiIHEEJyuw7yZB/8PK2cNHJqgKTKx9qcEscZ1FRDnDbjSoMYxWJ4GywfgSs36sXSBx
         i1cEwwe6KE+svFQEYH0CVdvnkLkrzMcrvdu8sJJ+9SU6VNk7APogbvHNwYQJ9vJ7SaGJ
         aS/PcBu1FHVpbRhJIlzhaYqqxu3Y3vK/apBNo0ikozU/aiOKNF7htz6a1/OI2GvFjlVz
         QERTYntqHqJPSaLT7p91P9rcYd9YUAQ0m7/mYUfdz0yaXzwWSUhNCgqNWEGCXjzke59+
         ZbKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hCM/rLbUxNjORiVZD5L+LGA24mSGgi/XAzABcfZnU2E=;
        fh=WKf41ci5Jbtsq0IqDipfurcqjUV1wGK250aqiTEonc4=;
        b=bvmEGMCiATlSnpOMT9fHW+s+P1MuTRo41u0VQ1yCoKlZUW0/Oq2jcujuD86skcC5b1
         zWNQIJC8AhYSru8v765dgHoD+JE0iF20TzFSyfvozrB1ThbslB61sAKCofU4DnJLQNj5
         If0MRrfpDWsItAT+iNiBlFadX+++xK00WsLeEiRQyxlfchK5I0Uu9W3AEvd6Zm1Q/dzp
         g/MKENlYLyh00cJOpba+i8IgaboyFdhu1kQyN6BlwEOUyIQ6vGUwwuDzfUFST534DKOB
         SywvgXsk+e31vvv77s/09Fk3A+DvQFENG9u4o8JZ+xyYQ5kIsDPQrKeOaFFHt8I6kUXu
         +Xag==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1791950319; x=1792555119; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hCM/rLbUxNjORiVZD5L+LGA24mSGgi/XAzABcfZnU2E=;
        b=efNl0fzqsel1gxoaD/9XA2jaLMC/Y6oEUurKlxJBRyNUPXSr15IfZpO7kJdVmAG6P+
         7MCN2E79p/3zPX4pTdqeRtevAzz0nyFPxezKvmRr+QciSwTLoWn9DQI4DomzKQP2dYGj
         GtNVg2Oh4dJSBkXUeYRvCyTqEDHJta2A9N/DperzO127dauPjDHo9/+YenATJ9ZrcM4c
         aLz7vLqOZuElCDKZq/V+GwrKqyepTVHYZZqXyg7JnQkJa3AZUXHLKAE6GfUZc9BrGASg
         kgP+mNGbUYOTMYjkJ0TklcV6D4XqdW+lG0CDxS556z4GQgPXKdfCHxoh6VqXIPLXuU4f
         03Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791950319; x=1792555119;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hCM/rLbUxNjORiVZD5L+LGA24mSGgi/XAzABcfZnU2E=;
        b=DTBwkPSzoTonNtYjswKsvoX0PBX3gu7NCcQ3Lg4ROb33ytqu9k8qfuQKNI46bXwFeH
         NZx8KzzGX3z0509NgPITesxLhuOQEg4JcMlNCOr/SPHoFROyIoWvzWejMM53590HQjgj
         4LKC0/iPo2lo+oRMrK1vQ2vlTggixGSVKbfxphvNSUGVpsljoX1S0CBXVO98rxb4HJGw
         3tp4a9mRFYCXBVKn9j1ybKE65P2WyC3dkG2mYvVZHmOVwwef3+KQUYnpCs30YlIh9r3P
         TluLE/cogUwpO3Wp60gYup4ZcVudKmSHA41QLpo1C2/EI2ca5FoodgwYAoHC6ww4hWtU
         00Tg==
X-Forwarded-Encrypted: i=1; AKwUvByVDnamG44GBOH+8UsPv+Uyzwp7beP98uEB8sIii1hUtsQDu6x1pKU3ItE/u8mawpcDbQp3NDbr6A==@kvack.org
X-Gm-Message-State: AFq9FYJ/DSPYX1smFTXTfaX+wvv0dnZ4Cdwf7+KjzcrVNo2JnThez2vC
	1qRiRIVyRfwWCX5iyGZxIpZ0REl3JVGC5rcwPrg0guqvgib08A75JzcDpC570NIjg5pBjlJV8jp
	cDL4Bt0VKEdOj27LNyvF9rBTwK7dbDozXWGtxhBFOaQ==
X-Gm-Gg: AYBFou0c0vOC1r5bhUFnwzmliaIn7p3gRrtnuKWr9pD4nytzgCfnKPIrmDEbvTx6NFi
	7wp2vrpi1EeFzixrO+AWlNG8pzIvlbvtuO/XLwC6sklBw/4j3iiRVVAubBjYtqk2HK0ITAU/WQP
	TVVMl6Gv1W3oB6f96smYNqwvI+Bx2KVhrVO7mRer5P64pqRLKibCLaZk6c2aooNVkuEKCS/iUCo
	iJH/kXqw9YcUN9ebywo3wqoGwCaRinOIeToyXlYZE37abXSiIrbT26pMVjelVJS0pSsHk/OT1ta
	Qh4ynhZcXaLJxoKBVYXNoDnoEueMCclAUDySf87l5fQIo9/2N+RQxgwVqDf3PgAjsJgsDg3FSli
	N5PnBCc1K
X-Received: by 2002:a17:907:9813:b0:c2e:22f7:59c5 with SMTP id
 a640c23a62f3a-c31a700713fmr1462632366b.7.1791950319528; Tue, 13 Oct 2026
 20:58:39 -0700 (PDT)
MIME-Version: 1.0
References: <20261012205447.2717801-1-max.kellermann@ionos.com>
 <20261012205447.2717801-4-max.kellermann@ionos.com> <a64f6a98-de70-4004-aac0-312cb05aaf92@linux.dev>
In-Reply-To: <a64f6a98-de70-4004-aac0-312cb05aaf92@linux.dev>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 14 Oct 2026 05:58:28 +0200
X-Gm-Features: AclHuK-EVXCJZ2dMETv7V581o_s9NhAvmGhqI1-eNh0gIrQGd2lTR1oPmoD0xNc
Message-ID: <CAKPOu+83bH2CRtiAio+1VTTQrYFF9th5XfG5wL45ujEavPS3Dg@mail.gmail.com>
Subject: Re: [PATCH 3/5] mm/mglru: cache the last memcg node, make tail
 insertion constant time
To: Ridong Chen <ridong.chen@linux.dev>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	baolin.wang@linux.alibaba.com, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, hannes@cmpxchg.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 26FF51C0004
X-Rspam-User: 
X-Stat-Signature: d78mcosxth7n9ioxbxpi37o9y51xxmry
X-HE-Tag: 1791950320-547140
X-HE-Meta: U2FsdGVkX1/Ds7b3jUM93GpW6U+xeyFrMcH/VoqJ80NX0UDZ/itXUBbAHkcJxWUnfCN7SumlpjSU95s3bnedo8nAlHRBD86xdmaQoWMtXLQEPUgMakSqzIUMxBs1R2oD2afDn9zGPJHluV7n5mmrZZqBGfXJuvwI10JQ+IjnOajj4kRzWLh65X3VTxTrCgGq1nwkFsi6MMc0fRzXMo9M3467CGj+sOakvZDy1fvN52hg/qcB0KhcI9W7e7yiLOKZt7ph+KNURSuvLPv0dNOQMg/EGm9Gs54E6DCIFSl3oJ/35aVEoltWJGikLecous5BwLDPtJU2KJMNcw8CGRAZyBmldyoduBgirWxnqQNiwIvqPE6xUVVD0tfKRcB0mjsXSB0EYOQO+BpHl4i2nKbr/4h5y7f29hkjNAsaS4F8s9y02wBKXWZjQZVRO+kIoVqGB0i/r8QTZLbwo5IQ7Jzlqin122BAOvUHmL7yDPuF2BeCmIeikR+LCYPGZs/EYG65xLAlRChOinQnKsvB8Gqd8SY0f0lWawIAXokqFvwJ46RSRLeZYIazavBpnOx0QkqkplqFq835lbBpLYV4QuaW8g91D40re2VS4HseKSXKMMPuWF86EfLEBjbSnRd3OAt+kjfNRruJxLolYUxf+frGFpnrwbrT9JPx8LbJHWuCny/qEd0kaEglhxNX+NQEHTX2j4e3uLaNmzMu/9SdhQBgNZrKSRCtGNVO7sHEqGTNmcwKpg9KQJJWFWVVTbz8MYx+m5b56SyQCkUoX6nB3d4V6WtyjV95FBPvbNe65/0vyxVGal0rU3iCaDj/Zui8OJ0gey/PYUoKRcSux11I+ZZxEpGReVKufDZZWqUzW6nxQ+w7UFSgtqCDbfmEcVo5GxDE5VBdUB0kYzjTpuMJfJvFMXjdP4Ko9ifHk/AGmd+VLDgf4Hz1qG2O5ULeUCemaTzE2eJENepkqKIljpGcdnV
 +kLl91qI
 saoP63JDhoHHoBjr7uZVgx16IF1OQR4a/qr3qeqRm2TY9kmKq0asNXPnGafS2xHsrtslJ0IgDkKKzElJnPFB1cqlmw3Hf3Gr9vWGtqwBtPrIJZQ6DFAPq4lZyNB9UNqTNSJYdthBWkx6z/v6dw7a9q5l5P0vKjXMsaKIyBVmvxaoLjh9Ijq6U/64p0Q00xhnx7xIl3NjNoxP9fNiDVK+0bxIlLu5MorR5Yic3KoVm+0UoD+GXoAPzYmEdXbPDosbjRgdAmMZI304VjfHBdxPzU/A0EK5BKKXS8oIE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 5:31=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
> I've also submitted an RFC patch that addresses this issue.

Oh, interesting!  I did not know but your patch, but it looks very
similar to mine (but without the hlist_nulls refactoring so yours
comes with some code duplicating the hlist_nulls header).

Too bad your RFC went nowhere, that would have saved us from a
production incident...  Anyway, even if neither gets merged, I'll keep
my patches on our internal kernel fork, because they do help a lot
with our workload.

--=20
Max Kellermann
Principal Architect
Hosting Technology

cm4all | Im Mediapark 6a | 50670 K=C3=B6ln | Germany
General information about the company can be found here:
https://www.cm4all.com/impressum
A member of the IONOS Group

