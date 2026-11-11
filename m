Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA469606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=E0OFUO/P
Received: by kanga.kvack.org (Postfix)
	id CCB416B05C0; Wed, 11 Nov 2026 06:40:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3986B05CD; Wed, 11 Nov 2026 06:40:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB9496B05D6; Wed, 11 Nov 2026 06:40:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E36A6B05C0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:40:35 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3BA9A1C29A2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:40:35 +0000 (UTC)
X-FDA: 85422645630.24.AB83F0D
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6310340009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:40:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="E0OFUO/P";
	spf=pass (imf04.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794397233;
	b=rD73i06ZnNsKG1icZMGhYYNRFtUwDdGP6EmHhZKEIlnM9N5hcyVknGAtvnwbvgwwcmwjlq
	IhzwoMiAfLh+77MwcvEi6Mn5VCUj9JG2/x/lrD4ABe271uWS1sGpsbrFi2p5TYATjOSGDo
	oBP9fDOjFQh6o3O119ss5QW9PWu5vW8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="E0OFUO/P";
	spf=pass (imf04.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794397233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3dVn9RGJzT01nbdl7Cqhpuv5ZORMA6dSnVCJ/1pKLI=;
	b=hKq84FX7WBiJtHURtF17NE2dHYYXNMeYmPEW2FZYXcqN3IVNNbmbacDofn5Rrrq7JahP2o
	mUG/yz49/yO0cm0XDKw0KE2IfAh/PkwgD/RVJgQ16xJmjmFZ1/oirxPE4OtGaexxoRq21B
	CVg2SBcDwvEwYZX9ykbidW/R6Wcilh4=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-33c10faf6easo56482eec.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794397232; x=1795002032; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=K3dVn9RGJzT01nbdl7Cqhpuv5ZORMA6dSnVCJ/1pKLI=;
        b=E0OFUO/PuH6qWn0lRQmrTC7aAPe3MbJJgmyHdpYqCRFnJy6kDNvPmhIhbtpdcc/g80
         /sCbNYYohr01m6EMJezQ2Ykh5UFAzeiJaq9UcfyyqgGvHwQfLAcFq7HwW1O6JU/wJyJo
         5IxdLNAAT6Jzw4TqfRloGDMV4AqkLfvFhvNSyM2N/5jO+EyuvGbP2j/iFPm1vr83/07+
         If1O9Sy+QpDpeiJTPqiQIJ4BqAqkMHSLPEussYhiIAnwfbotGO+ppVEU9MFTpXwTuWbc
         3mz0Jd4O/h1BSYCTrgGpns13yOlDdaskyI7Ru8FFY9r3TsXzZOcXxy0DABu39HNzAIsW
         S7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794397232; x=1795002032;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K3dVn9RGJzT01nbdl7Cqhpuv5ZORMA6dSnVCJ/1pKLI=;
        b=XKbkWajphyjEx2C4A97y61FRSKnV+GUXT8wGafrDU0T8FWgYdMTuF8Jehd9wxbu2Ag
         OuQoK8lp+xTVq6UtTe9xDYiHuwvhh5k4F/GIlNtpFQ6nvVPI87B38MubgkWs6V8OIXFu
         7bAxmmw2zgneh+4Tt2BRDkMnQmBMPO1f4AeTPkUxrkJiFIXLHqlT+Bx7d3qL1aM76T7t
         l3UqnjPTE89UccIlNcskY58X2JK/3CDhfBCrbLOXo6JL0HoUm6eSrsiifT7lhSmmohWt
         jJQFIg/w8F60JCEjEslmK7XLq/3BHRkU08T2YRsTGFNfJHn9XUSfEW3irgfX9NLR3vNg
         B+BQ==
X-Forwarded-Encrypted: i=1; AL+hErFzPkRZE4YDx9nZOSUcFa+sW5oD1ps/j7eWFKCr2OoPHhQmozLLKSXCFJn9PSwuaSn79vJaqZmg/w==@kvack.org
X-Gm-Message-State: APuU4Z+xAoHDxxHIZi3Gjuo+tUP1dBjwM4pukVcpmorjSsYkY3AQdQN+
	Wqf3WgCcK8SSjrLmIHZM/ZmQvL9NrugAOZKbN2u4bdqk7spf46mfZBzdZDmGZUFeOyE=
X-Gm-Gg: AYBFou0x8QQD3MfJXdmEvw0gVGWMNyK3lFdifODpUO7fJV2G9mvCNO0gwXt5zbNtCi2
	6bSpEV0lM6crhP9FcF7yRIeoAaFD9GYoV+Fvdx7Hnu3luvAsoPwd8i9acnPgfOUvgI/x8wcdtyh
	mguH9iMGLjAVQWgx37ca0X2/nndAO4NX5pmj0B/tXPf/AjXVn8MhT6c/xhnti1F6WZIupj9ALyC
	x3ODykxcMUmrT/oCMSYWvdbVyTevnEHzzZ+q84KQtZHOnlDtAXuc/V+GAiMqpSeHGSNe6+kPkkG
	EYXfgmOxW829AkBGpwml6l+CQVGraJmGDyYpEECkRHXDg8SDP+aJ/nf2LT2yg67k0dRfYyBarnV
	O+T745gcuVAVCMN+IQyZHiWtci+Tr40+fk1UCh8izGZ+rAr/ptvaSo8CTtlKqgxWL8SZ+rGRRPr
	Chx0D3XYFl73DqwCrK/TCn9ProypIpD9PrqBKTPFWxR35oOU2qA5isQOlTuMUtQkco6EOepw47/
	0p7vLDX9wfapf3DkGhdse4UjcCfB2wdRAVi42/pwt0ieX9ySM8nclWNxKGQRsNbO45PzyftdiZn
	QWzs4qQNTQEVTY4J4LbZ6dvy3e18ExlV928GroM1KsedYENbmdH1Boy4VB650L2RiSLC
X-Received: by 2002:a05:7022:3a86:b0:143:5c2a:e45f with SMTP id a92af1059eb24-1b3c01600d4mr3413598c88.0.1794397231833;
        Wed, 11 Nov 2026 03:40:31 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b1003fsm14128236c88.6.2026.11.11.03.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 03:40:31 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 3/3] docs: zsmalloc: describe statistics with
 CONFIG_DEBUG_FS
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, 
 Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <CAKEwX=NEw=T6xWuu3Pv+v3Yh1BvfkGKRj-Xd3xxn1Ci_fkA9AQ@mail.gmail.com>
References: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com>
 <20261109-zsmalloc_stat-v2-3-caee41684aba@gmail.com>
 <CAKEwX=NEw=T6xWuu3Pv+v3Yh1BvfkGKRj-Xd3xxn1Ci_fkA9AQ@mail.gmail.com>
Date: Wed, 11 Nov 2026 19:40:27 +0800
Message-Id: <179439722709.2142163.401638033965414946.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Stat-Signature: qm3s8f33gk5qpbjunse884t9u4bj3wpj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6310340009
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794397233-568254
X-HE-Meta: U2FsdGVkX1+P93w0vIIY5fnDE6k5Mh6+U2DCMw+N4Xr0ZtFeTptGuXosLCs4J4quhP95wVSQr2qY0/5/phQVQNylzyI5xQR8UUBMU0IZmXWQPhtqqaQt+Ff3E39mhJPrefCZ6nE4z25m+PH1zUkPxCgygUPRWbdmeCqYBefa6LnSswQjSH6g0/xau15NsktR+L2l3YZSo2a2cOO+Jw9fHmIY5UHNcL7C+G4ZDO5Mq9bfi5o/eKFF90biHgEhqRJNck3fSPINC/rxnK35MyA+V/gk62qobmSG9+mkh1alSWq1wf0/mGbKNVyhBvmOrLOeLK7l35WVeZKlUuPRxS+kv93yvp45ve3Vwh7t8/+iVZEsJcglrFN692Fb2pKprPA1vVf8OpbvOAdtagwhrjEvGir6W9ZEYgnlY8hP9f8lxZaJyakfTynkSUXyV8Ws0sA+k84WS0x5sJp8hO9fQ8DN3C/f08S9z4diRalxtfr8OVPRppiscKHn8IOyY13ZBELfsb/Sf0lzhOYmKk3UCkUntyQCDO5dOsZhJJ+Nh0xVUE8NWqOjUDSw1cYhYP0/3i8WyKI2Z6YxetF9T8ddMw8RwGF6zW9xtSV579z3cuE9zv1vw4vcXmitperXQsTgAEkRBppnbX3MCE9cAbtY5o4vNDzJrVtAdUCGy9RBO+POT9D+EVEcfbSH6rgU2kOner3qShzMh005ra4okMNvjU+BRVT3SW0yPuQEmAG/lk5VOTIbqcYOs0hYpyzLM7De78SMHjwyb1WuWgTp5Nt2RXzHy2kiaG0/aYf3QGp+fgaO/EGJwz3yIFlsxREAPOadyUlGHkBypPaBK2iCx/H3HlusqOmWugzp7H+w72lZXnjlp5UZf75goEnTqJHl53K1wDA5KJevEAuR8dTgfbTJimlMJbNipUrL2C3j2nUNd7RWZsYCgie1WNM9cRUgKX7Pjc5JqPq9KUXE03XKWbWrkhJ
 qyvo/orq
 GCB7dPwWqSiHHQO0U8G4loBOpnX8aoyw2xknnz0Z4EKCUUNemIAlKEnrmAEfeLZzph4lQ6hUNQLaETVPtXv3dvxb6aBZ7ttbGJEFJDywqCwKBodqTJOft5tzJyc+qO2U+NXjBXOgtNyfIfFLIW0MDnrIzpYqyLrAV/eDmpUNPI5JdcLQRvjmJRde8ntI18uJXgaafYFbhsZSURxkPqCx7sjg7B6kh+5NCUdEGocK0LTE3K3zfY/Ae2QCByA0sOAAyZWkPEIQLnR89GWAag2aTFFEgE28vlBdxd7Sd9IsBCc4sSXv8wXzdWGq3xOOmGXaK6fZmoxs5IvKqb9PLSwzZGGoYyaWuwuIR9p4QOlnGHyQSKIidvrlXLLY2xjcAfY/KgYDeM7L+0m117kFgcJrC8GxvzPmJE1PfDxLgFer3vAKhhalqQM65XauqkWmxTpBqc7QuRbM0Fb+YrvBpS0l5roOYNidKkal6Omv0IqnMFN4l1tFqWdfwXcqG2G1WS+3mY4l+mcOW+tEqMk+16aCl+GkR7YLW2hw0drsspJATZHpXgbWKibj17u3be9DTG6XDfv4wNwgNpBhddhE1Z4v3xUTqX83RaANZb5W/G7GVfseKcWQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-10 08:03 -0700, Nhat Pham wrote:
> On Mon, Nov 9, 2026 at 5:59 AM Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:
> >
> > Zsmalloc statistics are now available when debugfs is enabled. Replace
> > references to CONFIG_ZSMALLOC_STAT with CONFIG_DEBUG_FS in the English
> > and Chinese documentation.
> >
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> 
> For the English documentation:
> 
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Thanks!
> 
> (but I'm mildly certain the Chinese one is also correct :))
> 
Actually, I didn't look too closely at the Chinese doc. :)
"通过" sounds a bit unnatural here. I'll change it to "启用" in v3.


