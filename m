Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46DE8606A331
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 15:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Wf3hhvof
Received: by kanga.kvack.org (Postfix)
	id EB7646B05B0; Sun,  8 Nov 2026 10:24:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E68816B05B1; Sun,  8 Nov 2026 10:24:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0C546B05B2; Sun,  8 Nov 2026 10:24:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A37D76B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 10:24:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 15BC8120473
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:24:22 +0000 (UTC)
X-FDA: 85412323164.27.7302E13
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 116E1180009
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:24:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Wf3hhvof;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794151460;
	b=mPTe3Ay2r4nZNwFO4+8xsWjRh+zFLyIso08Vv2rh59bA6Zwaq9+8JTlWAnt5MnZrOv3huO
	ZuGtOkE7TRYQtmVERQt6joYD/Fyvz8pPEQxgCcd6Ab0pL9sViy9e/2ihUOUYqs19ympVVx
	keCvWI4tzNgezB7fYAZ1FMd0kQSfRBY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Wf3hhvof;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794151460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5H2H8MP8L+/rXp31cDc9VnUcbqmvBKhHx7W0RFsHYLE=;
	b=R/chGjtkd/XoaU5CiZTejgXrXxcVT5QthE68/j+dHpD6WxYK8njTkXvWE7bif2ZImc7F2E
	PiFULIXEeAO5cpk2DIVDxgrX+Cg9i2DWHMV4I3uoZkzbealx967KgeyzhqflmaX2t07tRX
	Jbwc6df5gEc20eT9kSz4H2uxE+ciZR0=
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5eac7220e9cso42062e0c.3
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 07:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794151459; x=1794756259; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5H2H8MP8L+/rXp31cDc9VnUcbqmvBKhHx7W0RFsHYLE=;
        b=Wf3hhvofOKkK30BTvaIjS+P51413Krcp8iVu1Vw5Npktz7/DP9xcr65rmmJPVBOIVP
         0UGkY4EpVdM9JaW76yCJ1rdfrvEF9hFeHpJJ/5LipcR1S533YVdtZ79qAIjKbUPhp3nG
         UMEOIvyKngFuU2XCs8iOqN0x4HUfkMcNkx1CWjCiVNN8EI0pRT1Dpjlp15CYnGz5zzNe
         nzz0wIOcLvBdUHTBhppWEbx4k34PjBU30ixiMSL57uSi4l5v2tbDaNBhRPW+K5NHGHLP
         nnbXyKFe+AWb7LMQg02UWfH306vsmBoN03mw2e5Hp6ZCWEF1s7MxAKNpPn6dBeCkS7tb
         dHLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794151459; x=1794756259;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5H2H8MP8L+/rXp31cDc9VnUcbqmvBKhHx7W0RFsHYLE=;
        b=fhyQrVp38AIh9rau5IwJbWMurv3RLJ2Es+4JcEaHidBSC1r3st+aNM+So/k3ZvM6MU
         LAHmGMwo73wXN+6gbuCG7zIFaaWQJNluwXqN7rpnj65r1z/X/5cRZADzKyKrhGZrWL3z
         X0fGXsAkx68ckJ+FC/SNRuc+2CIc+TrzOin8E30gAJxv5F3XZQTmhnlgCLlWaLkwkOCX
         ukf4f9LUva47naGzzw85WSnJM2F2BdLijBNq/rfbJU677hKQ5bGR+G42W9ENTPbBZeRE
         35O0XlQeTaIFDeZZYHgELVhu9iuwKfMtJ7/AfHLDV6ngZk1+ME/c52hymAxvZbMLJz6Y
         KLKg==
X-Forwarded-Encrypted: i=1; AL+hErFiWQlZLPzgmVBTNFhDHjx240KVeV8wuIp2sb7r7S238baHOelHTTZJ/kEKmsu+Leccl5wk8J4X5A==@kvack.org
X-Gm-Message-State: APuU4Z8aysULMzH7CvOO2JNfxK6Jqz8CmQW/vigyd/DSGNDbBTKUoufD
	l2/sgYQomeg6/yjO3db+Fq2lPgSgyE3H1/MSHbTmvNgbNrU8iHZAbgKm4gbC+5Slfcos22UUD60
	JJqpD
X-Gm-Gg: AYBFou12x4wSWdS4R43On4LmFh2FL8Hi8iGrU4oOqu9RnVJLNwFoV/n/TowFv4Q/Fj+
	ltfg/p+JRTptNw136uirC5k4gZvYUxByHiLpHr7E7p+tX3bK2xrfWNp4vz9eEHgF5TL5rxYNE9K
	2RMdmIOd2XBHnijdRr6aBtYxxHzvHjYuqnmbviGJUg0kyJ+AJQ4GLVLy7shpkkVYDREqAZw806d
	MMlcFPfjG45yUqc4FJdUGNZHvWULDoBhLTVUbU+SUvh0zFMrU7/laGCgfOsCDXJgtUoDGwer0u3
	wg4rw09FMmUUhLehXoBqGer2+wp9kCaWF+A/lVKsYuAKQ/NM1pg3SuUDehQwJE1xJq2mY2LZLNh
	0tjvCV1fZuYdHjyYn1eL5iyP3dt1Q2Ycad1atncpe9+16Vc7ftK/zfKmaKbY6L4H5jByIOp2GYF
	/GlkPe1DjkMTAVgnrQnGtta4KG3knYYpRA0iL6//XdSgiHzfJwfqten5Z3bd6As4ZTZjR0dG2jK
	C7R/cWB8WiaJEPPZm1CxHkOeLR8/m8JjEC/vwao7c+BN3EXSs/GMnGiqyQiZB5Wzh03HWCpIp5M
	0Wcijj8lBzQ9DZCBC1MYTT20+kd7yZG57ntj+1zLxgeyDoJFwZ4EiRrcVgiLTQnG1kTyOjTjgeh
	/RLyAStjQ1pM6iVNk35/E/W42MmH3KAC4LHt4AFLTa5RAIgtm
X-Received: by 2002:a05:6123:4a:b0:5ec:c162:d58c with SMTP id 71dfb90a1353d-5ece7232e04mr468275e0c.9.1794151459109;
        Sun, 08 Nov 2026 07:24:19 -0800 (PST)
Received: from soleen.c.googlers.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ece60c1adfsm2166205e0c.8.2026.11.08.07.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 07:24:18 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/4] riscv: Call early_ioremap_setup() before
 parsing the DTB
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Chen Pei <cp0613@linux.alibaba.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, alex@ghiti.fr, rppt@kernel.org, 
 pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com, 
 shuah@kernel.org, guoren@kernel.org, linux-riscv@lists.infradead.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, kexec@lists.infradead.org
In-Reply-To: <20261106071459.2003-2-cp0613@linux.alibaba.com>
References: <20261106071459.2003-1-cp0613@linux.alibaba.com>
 <20261106071459.2003-2-cp0613@linux.alibaba.com>
Date: Sun, 08 Nov 2026 10:24:13 -0500
Message-Id: <179415145357.358073.15510298244264317494.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=612;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=3Y64H37LmlHFT1VEQVtmy1MOdzH3F3b2j267UF4uRWE=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq8JQgz9JeNn8fjKYo6x7VzlFWQWT/Lp3pbpLNs
 SP93uPVKjCJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCavCUIAAKCRC7dyhM23N6
 3uGHD/9Puz8wWfsenmFRRLxdqDDp4alEi2QGtibd3g1gVeZ7Erpg749NWd29hLL+Nps+tMLws+e
 ee5EPvfyBmjdqv2aB9jwLRhFRBVCu+uecsYEpi5pIvZnhLUYS7pLfzWQESHepH0t1Uo1zbs2ThQ
 w2QeZ6ys+x3aRZh5P4T57xtD9ZKTMO/lx5nL0zQ7y10Lc59MkvZiuIpgegVGt+afWmMp51e1LMU
 zZTNA54QUipvJplO8tdXHzC2R9tnDyCkspRxxi+iIQ52w3TaF2LY0HGMYNKjv/GWdQGcaMoORg9
 HPw3OPmHgI8x2rX0qbSZR6VLp8KqKd8jnlSzWcI1w2NMxzwF5tswwwvmxHxRXWBigTxL/ZI91qg
 FBK/MLdWhxbZ2ikerG6+mpnyJh8ifXFLI2QXmbVvjiKZTghn9/oq313tuHBfPlBxHLT07rp1gwh
 EYQ/h5X/PzAQOWJTT7h6f6LvoJANqrnrTIh/YVT3FGSGfOs82HjJtsmvkPAbaY6bCM1fgcy5Iu6
 o0CHn9bw6TOupWQqjrVgowolhg9vSeQNBv0rpoRTA/lmGKBzSTNtRYZeZfeQCViJ9VL0X/OlK9C
 l+fImT0gCxVTujJCKLC3TbO2Nb9dqnsI0iSqK/Ftgm/7Pt3MXpy48agJgU4famUxHxEvG0dTa/r
 P3vcc/gP4HWC/tg==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 116E1180009
X-Stat-Signature: do3tseeawphys5ziyw6zmm1ffcfygw6q
X-Rspam-User: 
X-HE-Tag: 1794151459-989690
X-HE-Meta: U2FsdGVkX1/pg24vMPC+GhHstm4Hgc3KHUfjKDW6g73/4WyA9/7Cj4SzELbZHyInXU8CtQfyHD/iTSnm2EjPD02GJZl0KEoW9feXNA5LgSdNHAmK4nmWYQmqI4QZhK8hFFdZi3CuO+1Jol/hkuJU9n2Qr+TvqTyQ7xE4zcrnp4yJQba/CDcBkDHrifPxWBAkgkpx8AN24oEFE+ToWgfCfds9gd7NoLAqTcIB/I3oDejSH8My8d+6bfgqOrOcZSc+hzz2DtJV5yKW29xqLdtla9KbSWO76NEzQrKcqC9tQBhs46wGUQBw379ldMxdzz3gns5j5F8j/KcaUNwYw/FX1ph6bDAMY4kXtFWfsjYT1XLAKP/fos7VFixAVTAxTCLXyxLX9AYglB+u7yoiYWO5Y2K7pUatLXCPfoDFYoqTp18AZ2k6LvpBTOc7kKa/GKWAqycSUz+6FPtmlrxpX5KrcWbM/6G2Ej95k2+zeHF2efvQiQZsUwQbfWiMKt9QmfO4mv7yl0iHq6rdWkBZmEdY1Nwm3+BWVYePpQUE+weZuC6khBeBFglVafJn/0not7QuFxQPCP6STHhI+lqthxDCd5IHSmXRf+ExiNjaCpa7yGqm7GzEKwV69o/qozUzQM4VceLXdp2ZHhFcbxb7/lGE+69TC9emVlaNXTV3yLJEnd5PXhN1HlNGFNqTcNLc/J1bosFxy0aqOsF4kqg0O+HuvY+e+h1/u66jXOUm7H3IxmFa3eA4DMr7fK/DtNCNMGge7/6Ed1IupLIoepLJpNZA44vTveUTzEh0S0w2W6DVg58GcZwWy/t4b9NlLIGrsS7SqgxdVHVEu8X3GtjOMIwaHoohOLQYR6jvRZ+dXDUtOZQpesXe8MqX2AGSY1TU1nFXoSPmDVIU7riGf9HZPpBuPMVb0aHTmy4NX0qCU5R8y3iI1AfrC9U9A/+N9jtmlJAbMNWKiXjW6Ix3v/uiCOZ
 7S+rRdhA
 L8rnTm3st7WYMIbyX79bpXWu78yGx04LB/zrbikO+mrx6BJK6Eanj90dRQjK7jXdilosz7l0bQZYoW4DgGaueEoP1AAA5Ewmb7wR7qwLoXq+C6FyQRzYTAydbpW9BzLtwcxQ1uY7QJqPc8be6xZa91b5RMeLVuMiwo4q4rvZIaxgExY8Irsn7BffQbNW0uQ1fYYzb2Z43y3vNrTzl2Hxz+vUgmu77iChrWvSCp65MTdSGXo9FqM0cb6FHi1crWuJSJknJI7o58n7dAcHD1Iqr6McAcraLST7iOOYYG2XNZrXfF7aPsY7iNQNnzxIRMJU4JaDDshsepKWihhClndbtfXxRBRrOWV/vWWmK9ecm4z+T9xNJu4qr0NnZfapiOVE5E8GhlIsxV1M9QcOFlYNEvEaoIWOtiH5cFxO3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 06 Nov 2026 15:14:56 +0800, Chen Pei <cp0613@linux.alibaba.com> wrote:
> parse_dtb() can reach early_memremap(), whose return value is composed
> from the slot table that early_ioremap_setup() fills in - and on RISC-V
> that setup ran after the scan, so the mapping came back NULL. The DT
> based kexec handover parsing is the first caller to hit this:
> kho_populate() cannot map the handover FDT and the handover is dropped.
> 
> Run early_ioremap_setup() before parse_dtb(), as arm64 and x86 already
> do.
> 
> [...]

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha


