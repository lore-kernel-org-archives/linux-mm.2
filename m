Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61A78606C91F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 20:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=KbwKx6pQ
Received: by kanga.kvack.org (Postfix)
	id 6EBFE6B05B0; Wed,  4 Nov 2026 15:55:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69C5A6B05B1; Wed,  4 Nov 2026 15:55:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 564C56B05B2; Wed,  4 Nov 2026 15:55:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 21A2D6B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:55:11 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F08212067A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:55:10 +0000 (UTC)
X-FDA: 85398641580.10.4326527
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 974E7C0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:55:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KbwKx6pQ;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793825708;
	b=OBPSWvsTuSFwMjg8zH3Hx758j8yjzZ63Yef5mbrDnAF7gT89nMHNTS8W7vQJSRH/kVC9tp
	cW3uksUZBpY9l1xWYzCqTiwftHPJjnsQ3JmuL46/ZiwoZI8Q4RBWqqPUquPFcCEDxMejqf
	JasoU6pxAe7ELsawjE6sWvBxzonzTnY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KbwKx6pQ;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793825708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aqgdpi7gCkH60Z/isUI3USxyApBzH2FtqkjwxCL88mU=;
	b=TlKV6aDf2PErT49yPp0nY7Xe9Eu8g2OQjeE0fOx3yusoGt9wK4+jvHZyvb3fuGNNFLSUOP
	skQ0cR5gZ1OH+R9ijoqHQ+8tzVncNrrkCTIUJUL5GHeFrsazKp2vivud86qlzyaUQSqD/O
	uCzjDv+1gjqa3huxyauyPdb0dVpCOfI=
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-77bf892b496so371886137.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 12:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793825708; x=1794430508; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aqgdpi7gCkH60Z/isUI3USxyApBzH2FtqkjwxCL88mU=;
        b=KbwKx6pQgOTx1Z+jBWNKei4B9qil2NjwtdS2kXHGxxI7VJveKyYz1K6Nswdm0Bn+eu
         7qN2/tHZZjVOenzwPKsYY8THemxWaNqIeKwb4dAx1fM6s44aW554vPeksmY4REX64AuS
         a6WLH3bHcohcm2JD3ef7NyKXuAGd4lx5U9YNd4tQevbhQZWtc9pCzB/v67xU/FLtZQzU
         z6knhZHsgTblGIHVTaKefQy6PGOJs3Oe/Pv0O3zNFSdoJ0eK/Emd1K7aGqNg8P0t5d2R
         jSC+uv/PCw1YGbfIt8Zs+PfLOv+nPipk6zJYLW6vgbBNNkrddSm82DFh6FJT+Zaqa6i+
         emmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793825708; x=1794430508;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aqgdpi7gCkH60Z/isUI3USxyApBzH2FtqkjwxCL88mU=;
        b=V8cP+4X6pNldcke+t7/xZfzYeTlw7PqNGV6yzI2AEnJH4L7tPlBpImqw3BaaKtS9IE
         TmelVyWlGr3RsAEpL/pDRCNECtaLH0/VH8e1ks4hLLqgTuaZQzCri525dAtnRHI6Rslb
         7PqBB+bZPhdNwa5Hyo+hbm3n6Diwb6sfNstVmHK6j2z2IGb4fHAvbILk8GlnRWmCNA2S
         4ZliZgO5QnDxEBjxgt4ZBAw9UU8wPXF9oZpRHL4D9fJpm4JFDNPWappGMc2djaOlr5Mh
         A08pRALrXhscLcNDOhel2CsSVh6Of9FhPvGEFJonlfHQNGZ2NK8LbB7yNs1+MBBiIvFb
         uDtA==
X-Forwarded-Encrypted: i=1; AKwUvBw4sepI0kCVsl2d0ji4tU0vgOrrwO8xOML1DM/W7CuIgdMs3imeh+mLbGAQF3orwaJDkirGaNTDlQ==@kvack.org
X-Gm-Message-State: APuU4Z8N9o+o+vEg2V60z9+37Qe+p+ZS7jH/Dpjzyn+LMUtdoR6rJ63p
	XZ3a+/Rh5Ntm4mzxx3OEc6ok8jumJ1yW+4actIpiq4z+Rnn6aNFcrfvguS7+cZDMB4U=
X-Gm-Gg: AYBFou2GwCkop303vUSBumqVqEjTY9s76atKYYf4wuw3aX7WH1sf1RT8ksptcvr+eF5
	38RQoTtHlnAhsa6L7/ufMiSas2lLeBn6Dz1GMgoTomc6edHAo0iHKScIGLe60seKMKcAQBDlbrT
	wI7Na5lC+ieDJvj3O//0qKUaLG4jnUXN3qmikPOLrOyvrARGEalN+9644qj4WzZQNgPC5Bcanoo
	STwoNg8GefnveXgJIoZVypnhwS35hV8pSxAAp7G177a+vsFVCzn6+biP8XBtte2kBJ2IVqrAFZp
	WBMbo2EeaZx071uGxMa4iff2lYaTssLksj4hJ36Qdnw5hmlJHhxYKSoUWzby5pKr8SfDPG1sDFY
	N/oVMIxdaAt9Kzol5otj8/mxp5NwXB84T/MTXIfT5pWhBDylVmr7T7rMUwIRAtl+Vf0Mwyixbbz
	WtnF++6EKCKCVxK7G61Ys66PEvBl6dzW24r6DNiinRoS5d0VhMtSo/9LjuWd0t3m64DsOJb0mvx
	sxqCq4BOjmNy5lMwwRJpHNA/ddQCMqeD4d/el+d6JZd8Ds8lYU+qOxujTNw3pjiI7tJ5mPFM+6U
	NZ9bmOIyPmEnY13lYpGGpEVxzAHZap66mXS+waYVASAUzQQwGf614YUGP5rGJ0wPG6bWT9sSdQ5
	rAcgRfpvy1uvBXToEX1xiAdzyvutJ1RvYiCuGtOAhpNxdlfY=
X-Received: by 2002:a05:6102:1623:b0:7a6:a24e:8140 with SMTP id ada2fe7eead31-7d072c2ba18mr6112103137.14.1793825707582;
        Wed, 04 Nov 2026 12:55:07 -0800 (PST)
Received: from soleen.c.googlers.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-998d91d212bsm2888015241.6.2026.11.04.12.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 12:55:07 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] kho: Remove redundant 0x prefixes
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Thorsten Blum <blum@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261104162352.140836-3-blum@kernel.org>
References: <20261104162352.140836-3-blum@kernel.org>
Date: Wed, 04 Nov 2026 15:55:04 -0500
Message-Id: <179382570401.2089669.6201187990672133004.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1110;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=nf/pbrG/3HMY+E3Xb9PYIXXf5eFKpBebgul3T9w7Tns=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq65uqenFbBMaztBsCNPi+5jP4Gy+jdHDzzMCE0
 AC8artOAtiJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCauubqgAKCRC7dyhM23N6
 3g6FEACxKJFKSeWDmcpF4MW+HdGHBych9VYleOaeLks4H5Jobe5OdO4PZ1BxPgjlf33ihIu0Cvy
 qUJll+5ee/BP7ue8XHEoKp+bs5J7/hJbsqiU9RBst4yORNBrHOTl8M1xUhUG2mLxA8t+3Q1zQqc
 JqLug6dfJmV22HOKmvtZZ5KnHz9hvhbXBWMpwgnBkg/9/dW/Cy7pZSeouW9JY8018P0hAAl7yET
 Gffrvg4Q952YZhd2yBktR7RjQ7nwTM/ntrpQLek4b7CLUg8NpCezTuNXXvkpi3ijzsJyluEzX9P
 SbLmD14CRvA8bQtgoW9rAKf+h7aRMxeemVftJ6EuV9Rr+ydhlygMqW9NTLTEHVEH+j8L8ULw9ZT
 tYXpnXcjNN6SUxD1WAhZd3UWDlSb5i4VemuPUjoaMgTp0Pxy4gbnkg+w/KZl/ytltxii7mMBjmv
 oaY/iz6jEO3XpHdRGNVCENGOesj1my4WTYt4aJikQngaKQyZzTdPzxjJFB0tllSy8LZ5yeojFbG
 1kTU5jsSvUOmJTifsIPYsrapvlZMhaLTP4t9nS5qGAGYwORWKAoHe46sW01S9FfU+PUhpjv2ZXU
 D2jgjT+p1VLkkOI59RjeZ1Hi1YLkfqzORCz1Tgxqtk+R7Rl6ZcZ7RZxA0J/I3d4mzxn0+gtKhfS
 04eqDdxWL00PXFg==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Stat-Signature: of5opndzrqnd3ssd7otti6qaenygkzu4
X-Rspamd-Queue-Id: 974E7C0005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793825708-584458
X-HE-Meta: U2FsdGVkX19KdNDx8i+QcX69MKGSyw7QTFGCx/Q0kv7iNcxLMAT2COYtLukwFLtEarqk/b7D4MyTwBR+VIFIND83nScKrU6fejOwREK3FPf7FibWCftbclnPLHyMsamHE9B4RG3Q+5yZdzlN2yRikrHAskar41W3ebbuLkWcpIhcSJ3a3JsP/ClFp7j4nEYy4OIJi1v1wy4Aqa7oafPskrI98ZCl921Fa5k0kk/Hd6T/EfbNnwjyM/hWQSbN1K08WAYkCSIdHMHvVcVJmgggFiQrhPS9dAGzoh+aRuSTN5DYqY9JHE7mRd7fERWaDrBPoR5iSKsHNlaTQcG9LtaYn/EV6ZhHxDtKyZtY6rCRVntYntRWkHkMF4Uv1MXhVdpAE5sLe61ZGrViXK1NUIy0H5w/gui5jN/tK9dxjzUc9ML3aKKmU8cFENdunOi+fT7tBeBlD/zCWp2WgcuKlU5a2vnUAt9nJS1b6VOZ/R6rUeqWiBzTwikVZFyvQaZgkohIUi5j3UAe9XplOtFpZLI2pbMvPFrf1viCdhYyblf6g1qpNEKQSth91IT5p5xHcb8rWBZX5vRUBCTKbo1FWERuVriFBBLWv7ZzN2ZaGkkSruAtH7QO4XJFWMwWq055FTLXi50EgWHULzkJ4lulEvG8Lur38Fy+CzzIMTtuDvvuw3JLy4QexAwh7SqoSeFF9pZDar1MJDPdLTV7NFeMFl1RPk2kHv5E25s2yLuOA0hHPb79hDLkvEEqWJQUp3JlIs3YHbmNVwprGOdU0kw1tkHBpDpT0URzoc5q8lOQT4oE/J0HWd9uGMKflPKuEtpR2yf4/7bRztJRi8tDJFntU6EaXdIbB57O1L5cxwDB3ELE4WpCxA1gBBS2gwx9tEpvR3jq99Onk8nA0rJDj4UWHaQFmYe5Rux1Ui1PvuEBduvOpaJrxhX1cOk7O6fijj6nKne/JTD8xErO3jVUNlP5hea
 +YWu3L/q
 6CndGk0SP+UOcB8PnfqbnnXIV2sqONiv0icZaM2Yc1RdWouP+eqh8zwxbM8FzfUNFWj8diDcqVSqg/DgpHI2ORnPlkFqp5lgO8y+vDSg3IosEQsUottbCMJpmNxgT+kSsz+Gjy08sPXD7gAmZmBjIDHCNP4m1DCAxcbicnZ+Ught8qmm1a8ow3TAfrVonhnbddG5jc00vnH0BeLy3if41GN9pvvuwKbBDOVZCdIa9Kh8WAiRowtuY3EpUtxqCn48+FGVg1n3vSe3SMZ2Wd3+YJCQlqmne76Plvpng/Crqqvx5OZM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> The %pa format specifier already includes the 0x prefix. Remove the
> redundant prefixes to avoid printing 0x0x.
> 
> Use phys_addr_t for size to match the expected type.
> 
> Fixes: c609c144b0e8 ("kexec: add KHO parsing support")
> Signed-off-by: Thorsten Blum <blum@kernel.org>
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 6f1f55fe3181..6a7600a0a7d5 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -2010,16 +2010,16 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  	 */
>  	for (int i = 0; i < bootmem_cnt; i++) {
>  		struct kho_bootmem *area = &bootmem[i];
> -		u64 size = area->size;
> +		phys_addr_t size = area->size;

I am not sure; having a variable size of type phys_addr_t looks strange 
to me. Furthermore, KHO only works on 64-bit platforms because of how 
our radix tree is designed, and we do not plan to add support for 32-bit 
systems.

I would keep u64, or if using %pa for u64 is still an eyesore, use 
0x%llx for the size field.

-- 
Pasha


