Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9857CF30928
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 10:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102C96B008A; Thu,  5 Mar 2026 05:05:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A39B6B008C; Thu,  5 Mar 2026 05:05:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9D636B0092; Thu,  5 Mar 2026 05:05:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D642C6B008A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:05:57 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 899E61A08F8
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:05:57 +0000 (UTC)
X-FDA: 84511578354.08.A0395FE
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id 818C440005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:05:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FVOU+qW3;
	spf=pass (imf07.hostedemail.com: domain of jgross@suse.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772705155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lkS4n6+ZdvPRjbWufqh2//AU1wZNE/9YAUYKtAtaEKM=;
	b=6tzmG1zWyE/JIAK3wSkQfLP95tYY5x2EclKwSfS0OAJlmtPzFC9Ar5MIVulosnY2lohn3S
	hYSzcBb8ehLfgP8Zqwyz+HPlw5vJVnDFBpTAhEqw2oyptm5WWseIkkOyzkZt8wzNRhaUwm
	Fl+zx77dQCAqU4ng+fJz2zowat2+HaM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FVOU+qW3;
	spf=pass (imf07.hostedemail.com: domain of jgross@suse.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772705155; a=rsa-sha256;
	cv=none;
	b=tokw3o6Gngf7PFxKdinOYc+pXzq1VRTVaAA3vM3wduso3KjuJmQ1s8cJYpDdx/Jkr6pWAJ
	byZf/mkp/luEQIuZEDcx7ZERsrIFTYJ21uViksk+UA2heSS8p2vTyqSxGGNO/++8it/Z3H
	hLf56E3iPul+b2nodupizD8lkSkgV8M=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b93695f7cdcso1006630766b.3
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 02:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772705154; x=1773309954; darn=kvack.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lkS4n6+ZdvPRjbWufqh2//AU1wZNE/9YAUYKtAtaEKM=;
        b=FVOU+qW3HDiWHNNQwwbh0p6GynAI1bp9TWqZuGqIQif4DMhjM5qIu+zE5ltXWKFepo
         muhZnhB2C56ncdgqcHHK/h+6eOu6veL+vc2WTYPkBEn23o43f7SSAPQUHfirNZUHaDpR
         +Bl2xQHML4VUCnUks0V+BKc1cfCgpgD0FmxsCv85T4m+/7A4olpXg3GCwZ1QH0h1mvlJ
         5RWnzO/y/HTvlcc5ObnCxpybGu6NZCWGultdAMoHzTBDROuLs9MUxdRs8VqqrHQ6oPP/
         qYwTMZzB0NnJHjBKB39RhxmehjugZYUwF86hSSX0zkpCc+inpvKJn0Y77vdEU6C4izwo
         43uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772705154; x=1773309954;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lkS4n6+ZdvPRjbWufqh2//AU1wZNE/9YAUYKtAtaEKM=;
        b=FGlhwQp8QaGS2QiDJvadfBVx37fd4n+euzs2ecTXhXwVFuz0jPo1kpYLTelDqWGoiD
         W7plUQZhTAC2MoxeIC50gIMPQctT+EEw16ABf+zPdPmB7tEj5jL288DBHLT2faQBOx2j
         /KD0BqPYg2ltU3e2c+CrUeAYi7yqLB1V6Le2gnNa2498gt9hmmnDxiNAUrcPySrLkABc
         OPuoCs29WgkQqgqkVV9p+E/Hc1S8lFJRomqmIePAs2ToEcIvmPYS56hF8MMxhXsdOJBa
         knTM3PjRVte1YpTLo7zZ8AMAkNvfPFLslhAR6Wgt74GSO9RCk015d5lOrvhoeFTha+R1
         hXdQ==
X-Forwarded-Encrypted: i=1; AJvYcCVd8SW9ev9WrLh6l10l4lEFl+TTOwatMywXY/Bvx5Q202c2Lf+x2S1fRd+OClnasGfkWM1C5ozbgg==@kvack.org
X-Gm-Message-State: AOJu0Yztm01dSs1SaCwaWeFHUoOknT2n3ObQ+fqFkhR8Di/HUs5XfM5a
	3U7u43PE+zjjw9AFRlFTgmWjj+315mGZFD3EzmgFV5d8GF9bG3bFyV5XORL9ip0B9Rg=
X-Gm-Gg: ATEYQzysk9yKzXVyYNO+Loa8qlwoK1CQ1lBlPA+3w9JAVzVUOrDt1P2t9BaFSHqmND4
	c9ke7mYU/E5zaMCXnSxUT96c1yVSifkmzzFLEg0PuEG3DPX3htyMCQpRLMklfsVijRf5BcCGfaK
	HzmLiFdY7lwNCsfpUAw9HbYfczOxEotE7huyYzLkkJGgC/lX94iagkJavDrtS74Hr3gH/g+3drJ
	xSFy4dEOwGt/BMD9e2VmaBbRKvGXRB+NyCit/xSaTetkrS8J2usqk2AvvAQeH5T60CYl8a8zYD3
	n2mI0vwAjzRwGAZAXLBljuoGVm0+EB9J6BwwJuWPzhk6aEMAqOPHvaIDoFY5wwVUHxLA0kLaW3J
	5ORk5PRE17NjVthpkYTtjPWA7LEnqgkuz1DW0tGHfeeEqMfGSZ8gspdTdivml6B6jSVkmH+T3pS
	M3qdlUOns3Fu0E5w95e6MWjMbXcf1NDz6mgHuhVKgVdFn4/PGA0Gk0FvFc3S4ugNjw7Z7zqPWXw
	8y0anZy++eKqXeet0iOksxMmVOpoqOoGQvuT3gbJa8VTDBW3FXK7hI0eoFnnD7h
X-Received: by 2002:a17:907:94c8:b0:b89:fb0b:65e3 with SMTP id a640c23a62f3a-b93f1411bbbmr330622466b.47.1772705152161;
        Thu, 05 Mar 2026 02:05:52 -0800 (PST)
Received: from ?IPV6:2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112? (2a00-12d0-af5d-ad01-5d3f-14e6-9bcb-5112.ip.tng.de. [2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b94037fca0dsm98139666b.50.2026.03.05.02.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2026 02:05:51 -0800 (PST)
Message-ID: <4d7c396a-6a48-4e56-b8d1-3ac7bd5d10fb@suse.com>
Date: Thu, 5 Mar 2026 11:05:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 2/4] mm/pgtable: Make pfn_pte() filter out huge
 page attributes
To: Yin Tirui <yintirui@huawei.com>, Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, david@kernel.org,
 catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, luto@kernel.org,
 peterz@infradead.org, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, anshuman.khandual@arm.com,
 rmclure@linux.ibm.com, kevin.brodsky@arm.com, apopple@nvidia.com,
 ajd@linux.ibm.com, pasha.tatashin@soleen.com, bhe@redhat.com,
 thuth@redhat.com, coxu@redhat.com, dan.j.williams@intel.com,
 yu-cheng.yu@intel.com, baolu.lu@linux.intel.com, conor.dooley@microchip.com,
 Jonathan.Cameron@huawei.com, riel@surriel.com,
 Kefeng Wang <wangkefeng.wang@huawei.com>, chenjun102@huawei.com
References: <20260228070906.1418911-1-yintirui@huawei.com>
 <20260228070906.1418911-3-yintirui@huawei.com>
 <5eaf3846-01db-471e-9903-b0b239d7838d@suse.com>
 <e8d5ba16-3071-4b4a-b6a1-d492cc46e8c2@huawei.com>
Content-Language: en-US
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Autocrypt: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==
In-Reply-To: <e8d5ba16-3071-4b4a-b6a1-d492cc46e8c2@huawei.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------IBH0hIChx0pJo3JB9HTgBbXv"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 818C440005
X-Stat-Signature: tfamax5y4c8z74cwx8ruhrqym1h5w53z
X-Rspam-User: 
X-HE-Tag: 1772705155-143720
X-HE-Meta: U2FsdGVkX1/Ktdxqp4Sg6l6T+gf5ah/a8lDpGzr+EkOhpVtjofgUTrRG126lynW1oC915prmPr6iCs/1QUYk6FwDScwXhdv3mkhCIZyJNYE28c5IBtMrZEU+RgWB1jw1jGYFzf3TSVStt+BVxlukMj9gEZahKwALVzKk2geb0KoizA3cm8p9aq/p27jX99+5ONjlqACdtm9yYCYl5Ryr443ubLdz4B34r0RDnjwc+JXyXk9ztD/BSXXJCsiy7fY9cjgw3CcH4R3DfHk9ustlsSHRQ6BZs1ZPQ1MFFXHrJRfh+FNl+cArHlirVwz65JRhzzEWYzqO5d3V4Y2dvdprS5AhE4NgMb1PoIO4dKwXIkorLymIaR4SX++eCEiC+/l+2U//AIsn1KXzvM+zECyFwAhJw76LvHKWxhCil60MSAeJnypQpRFcADjGEL9EXODhKVeX7JAhPXFeIkskxtTTQOi20EXgSVYPVqQq46hUSjb42ORtnixAQxk/WdoGVUFFYmUVnLDgdYbI765vslN88NtWbPBMRA745cE+JLX0NJdmIN2lT7RuXcc7kxhxqJLBP76sjf0WCWXDnmGVVxAMqIL6kx3qFTUAlgk4GgWxr67Wa3Pnv1r6duHLrrP4TxJYTtBgkqw+xQ6mRlDmpAtJC4iaBk+i9Ga7RBG9PN1vhN4UV6gofX3N9/yACJSKV9ClJP2HmEpmrOJaNaejhFI67VepwRwKfZiOdaxjQIZWfzL6x/g7hR74ecjQec3PIaGsnIZlcl0TTs8fjGlTtDBktrsxFceAVkmgrSDsjXaaIUqtcTITU1+wAt8p7qzWHTyEoAp7QUnupQrqBHTARW0Y4TOoUBrlv9jcCa20otTux0ZIUOa+MRZ0ttfr+YtSI2G9fZTADgF+PHPTTu9UvAm4K0rWU8Hfv+UWWKebvmuOeWBqhsJJQi5ZkADrFPBI3wUtpGdi7W1xPEkCQB1rOX+
 vjKsX/In
 LN8+d3nD8uv/7tCr1rCyVn2Y4vIQGuvQQ9wmHhcPySK9o7AZLkmoSn4UR6mzCMrBTAjJ8+drm9HGYdwzi4KapZEjoX9+Nb51X/SrB+s0eSx9zI5aK/iFsPdjgajagNGeirkZuwpJQmH9OAQpPBau90YuVeIfW0KWQMQsyKHpBpYekBtB6MQxuJzENumgUHnOLSgQXl/2eWe2dwMfcBHCJTtGagjOaOlvdNu1IQorkk3ZvVBZPN+Mab2QkyxKCKOxL8Rk+Li1WcFXWHkld6nmlWiDOHkSGl7CK3zsOath8E5ISd6cy9D1UrFIipLQ6AiYvBv16NbdTrF8r8wIblzdsOdgs7+wSkVY+PlP+4k++8rBgFYD2cfHOXfzwT2ET0TsZ6fM1ZMw2ECyPU7B+Vjgd1/wqrmNeruQcKRM6GshOdM9YKT5r2BDsE7G6oKHV8tKBK2ExrW/ncyzAA7UShGN//S9sK2w7/hyFV/kOjYhGn5iExz1SWZHLAxz6jqaLrjvGBHGb/hxum7INxt62iXzxuOTH8B9rSyE6dxa76mvpkq+FiLdmPO9slm2J0v/GvZAXfpPBV+6/MsLdUqDBbWfyNeApehnYurmNlwNhhLLSStvw05pbUbEZZHjbYdnvu9WguDnEek3Snd/fp11Pqgd5tKaT2KZR8abdnRkUTurRaduluq/Vfw9mR6+NapdB1noVS9LlY1tXKntnRAQWpqgzfuT4QgSOa2LpPybFFLsIysh55FLVW9Ja2CvHwNp9a1Oq8BLslftkQHD+WNpmefEvey0L7pn9OS11+Sic3slUXnNArZtczYBRayFqkarDQABbLp1bMsLVlwK28DTNBTdkNz7g9W22ykF3HZ0xlL8pwsK/cra6oln5TKat9qszSe4KEQ39HrzT3LiB86OqfVcQcPxD7pG6kZXpU8pcN8n4zq4vzlM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------IBH0hIChx0pJo3JB9HTgBbXv
Content-Type: multipart/mixed; boundary="------------5UCV7MO0yGV9I2Gcqe3OKiXQ";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Yin Tirui <yintirui@huawei.com>, Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, david@kernel.org,
 catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, luto@kernel.org,
 peterz@infradead.org, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, anshuman.khandual@arm.com,
 rmclure@linux.ibm.com, kevin.brodsky@arm.com, apopple@nvidia.com,
 ajd@linux.ibm.com, pasha.tatashin@soleen.com, bhe@redhat.com,
 thuth@redhat.com, coxu@redhat.com, dan.j.williams@intel.com,
 yu-cheng.yu@intel.com, baolu.lu@linux.intel.com, conor.dooley@microchip.com,
 Jonathan.Cameron@huawei.com, riel@surriel.com,
 Kefeng Wang <wangkefeng.wang@huawei.com>, chenjun102@huawei.com
Message-ID: <4d7c396a-6a48-4e56-b8d1-3ac7bd5d10fb@suse.com>
Subject: Re: [PATCH RFC v3 2/4] mm/pgtable: Make pfn_pte() filter out huge
 page attributes
References: <20260228070906.1418911-1-yintirui@huawei.com>
 <20260228070906.1418911-3-yintirui@huawei.com>
 <5eaf3846-01db-471e-9903-b0b239d7838d@suse.com>
 <e8d5ba16-3071-4b4a-b6a1-d492cc46e8c2@huawei.com>
In-Reply-To: <e8d5ba16-3071-4b4a-b6a1-d492cc46e8c2@huawei.com>

--------------5UCV7MO0yGV9I2Gcqe3OKiXQ
Content-Type: multipart/mixed; boundary="------------0j5uJBxdVyNObR0ABqhDrgLS"

--------------0j5uJBxdVyNObR0ABqhDrgLS
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDUuMDMuMjYgMTA6MzgsIFlpbiBUaXJ1aSB3cm90ZToNCj4gDQo+IE9uIDMvNC8yMDI2
IDM6NTIgUE0sIErDvHJnZW4gR3Jvw58gd3JvdGU6DQo+PiBPbiAyOC4wMi4yNiAwODowOSwg
WWluIFRpcnVpIHdyb3RlOg0KPj4+IEEgZnVuZGFtZW50YWwgcHJpbmNpcGxlIG9mIHBhZ2Ug
dGFibGUgdHlwZSBzYWZldHkgaXMgdGhhdCBgcHRlX3RgIHJlcHJlc2VudHMNCj4+PiB0aGUg
bG93ZXN0IGxldmVsIHBhZ2UgdGFibGUgZW50cnkgYW5kIHNob3VsZCBuZXZlciBjYXJyeSBo
dWdlIHBhZ2UgYXR0cmlidXRlcy4NCj4+Pg0KPj4+IEN1cnJlbnRseSwgcGFzc2luZyBhIHBn
cHJvdCB3aXRoIGh1Z2UgcGFnZSBiaXRzIChlLmcuLCBleHRyYWN0ZWQgdmlhDQo+Pj4gcG1k
X3BncHJvdCgpKSBpbnRvIHBmbl9wdGUoKSBjcmVhdGVzIGEgbWFsZm9ybWVkIFBURSB0aGF0
IHJldGFpbnMgdGhlIGh1Z2UNCj4+PiBhdHRyaWJ1dGUsIGxlYWRpbmcgdG8gdGhlIG5lY2Vz
c2l0eSBvZiB0aGUgdWdseSBgcHRlX2Nscmh1Z2UoKWAgYW50aS0gcGF0dGVybi4NCj4+Pg0K
Pj4+IEVuZm9yY2UgdHlwZSBzYWZldHkgYnkgbWFraW5nIGBwZm5fcHRlKClgIGluaGVyZW50
bHkgZmlsdGVyIG91dCBodWdlIHBhZ2UNCj4+PiBhdHRyaWJ1dGVzOg0KPj4+IC0gT24geDg2
OiBTdHJpcCB0aGUgYF9QQUdFX1BTRWAgYml0Lg0KPj4+IC0gT24gQVJNNjQ6IE1hc2sgb3V0
IHRoZSBibG9jayBkZXNjcmlwdG9yIGJpdHMgaW4gYFBURV9UWVBFX01BU0tgIGFuZA0KPj4+
IMKgwqAgZW5mb3JjZSB0aGUgYFBURV9UWVBFX1BBR0VgIGZvcm1hdC4NCj4+PiAtIE9uIFJJ
U0MtVjogTm8gY2hhbmdlcyByZXF1aXJlZCwgYXMgUklTQy1WIGxlYWYgUE1EcyBhbmQgUFRF
cyBzaGFyZSB0aGUNCj4+PiDCoMKgIGV4YWN0IHNhbWUgaGFyZHdhcmUgZm9ybWF0IGFuZCBk
byBub3QgdXNlIGEgZGlzdGluY3QgaHVnZSBiaXQuDQo+Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5
OiBZaW4gVGlydWkgPHlpbnRpcnVpQGh1YXdlaS5jb20+DQo+Pj4gLS0tDQo+Pj4gwqAgYXJj
aC9hcm02NC9pbmNsdWRlL2FzbS9wZ3RhYmxlLmggfCA0ICsrKy0NCj4+PiDCoCBhcmNoL3g4
Ni9pbmNsdWRlL2FzbS9wZ3RhYmxlLmjCoMKgIHwgNCArKysrDQo+Pj4gwqAgMiBmaWxlcyBj
aGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4+Pg0KPj4+IGRpZmYg
LS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3BndGFibGUuaCBiL2FyY2gvYXJtNjQv
aW5jbHVkZS8gYXNtLyANCj4+PiBwZ3RhYmxlLmgNCj4+PiBpbmRleCBiM2U1ODczNWM0OWIu
LmYyYTdhNDAxMDZkMiAxMDA2NDQNCj4+PiAtLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNt
L3BndGFibGUuaA0KPj4+ICsrKyBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vcGd0YWJsZS5o
DQo+Pj4gQEAgLTE0MSw3ICsxNDEsOSBAQCBzdGF0aWMgaW5saW5lIHB0ZXZhbF90IF9fcGh5
c190b19wdGVfdmFsKHBoeXNfYWRkcl90IHBoeXMpDQo+Pj4gwqAgI2RlZmluZSBwdGVfcGZu
KHB0ZSnCoMKgwqDCoMKgwqDCoCAoX19wdGVfdG9fcGh5cyhwdGUpID4+IFBBR0VfU0hJRlQp
DQo+Pj4gwqAgI2RlZmluZSBwZm5fcHRlKHBmbixwcm90KcKgwqDCoCBcDQo+Pj4gLcKgwqDC
oCBfX3B0ZShfX3BoeXNfdG9fcHRlX3ZhbCgocGh5c19hZGRyX3QpKHBmbikgPDwgUEFHRV9T
SElGVCkgfCANCj4+PiBwZ3Byb3RfdmFsKHByb3QpKQ0KPj4+ICvCoMKgwqAgX19wdGUoX19w
aHlzX3RvX3B0ZV92YWwoKHBoeXNfYWRkcl90KShwZm4pIDw8IFBBR0VfU0hJRlQpIHwgXA0K
Pj4+ICvCoMKgwqDCoMKgwqDCoCAoKHBncHJvdF92YWwocHJvdCkgJiB+KFBURV9UWVBFX01B
U0sgJiB+UFRFX1ZBTElEKSkgfCBcDQo+Pj4gK8KgwqDCoMKgwqDCoMKgIChQVEVfVFlQRV9Q
QUdFICYgflBURV9WQUxJRCkpKQ0KPj4+IMKgICNkZWZpbmUgcHRlX25vbmUocHRlKcKgwqDC
oMKgwqDCoMKgICghcHRlX3ZhbChwdGUpKQ0KPj4+IMKgICNkZWZpbmUgcHRlX3BhZ2UocHRl
KcKgwqDCoMKgwqDCoMKgIChwZm5fdG9fcGFnZShwdGVfcGZuKHB0ZSkpKQ0KPj4+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9wZ3RhYmxlLmggYi9hcmNoL3g4Ni9pbmNs
dWRlL2FzbS8gcGd0YWJsZS5oDQo+Pj4gaW5kZXggMTY2MmM1YThmNDQ1Li5hNGRiZDgxZDQy
YmYgMTAwNjQ0DQo+Pj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vcGd0YWJsZS5oDQo+
Pj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcGd0YWJsZS5oDQo+Pj4gQEAgLTczOCw2
ICs3MzgsMTAgQEAgc3RhdGljIGlubGluZSBwZ3Byb3R2YWxfdCBjaGVja19wZ3Byb3QocGdw
cm90X3QgcGdwcm90KQ0KPj4+IMKgIHN0YXRpYyBpbmxpbmUgcHRlX3QgcGZuX3B0ZSh1bnNp
Z25lZCBsb25nIHBhZ2VfbnIsIHBncHJvdF90IHBncHJvdCkNCj4+PiDCoCB7DQo+Pj4gwqDC
oMKgwqDCoCBwaHlzX2FkZHJfdCBwZm4gPSAocGh5c19hZGRyX3QpcGFnZV9uciA8PCBQQUdF
X1NISUZUOw0KPj4+ICsNCj4+PiArwqDCoMKgIC8qIEZpbHRlciBvdXQgX1BBR0VfUFNFIHRv
IGVuc3VyZSBQVEVzIG5ldmVyIGNhcnJ5IHRoZSBodWdlIHBhZ2UgYml0ICovDQo+Pj4gK8Kg
wqDCoCBwZ3Byb3QgPSBfX3BncHJvdChwZ3Byb3RfdmFsKHBncHJvdCkgJiB+X1BBR0VfUFNF
KTsNCj4+DQo+PiBJcyBpdCByZWFsbHkgYSBnb29kIGlkZWEgdG8gc2lsZW50bHkgZHJvcCB0
aGUgYml0Pw0KPj4NCj4+IFRvZGF5IGl0IGNhbiBlaXRoZXIgYmUgdXNlZCBmb3IgYSBsYXJn
ZSBwYWdlICh3aGljaCBzaG91bGQgYmUgYSBwbWQsDQo+PiBvZiBjb3Vyc2UpLCBvciAtIG11
Y2ggd29yc2UgLSB5b3UnZCBzdHJpcCB0aGUgX1BBR0VfUEFUIGJpdCwgd2hpY2ggaXMNCj4+
IGF0IHRoZSBzYW1lIHBvc2l0aW9uIGluIFBURXMuDQo+Pg0KPj4gU28gYmFzaWNhbGx5IHlv
dSBhcmUgcmVtb3ZpbmcgdGhlIGFiaWxpdHkgdG8gdXNlIHNvbWUgY2FjaGUgbW9kZXMuDQo+
Pg0KPj4gTkFDSyENCj4+DQo+Pg0KPj4gSnVlcmdlbg0KPiANCj4gSGkgV2lsbHkgYW5kIErD
vHJnZW4sDQo+IA0KPiBGb2xsb3dpbmcgdXAgb24gdGhlIHg4NiBfUEFHRV9QU0UgYW5kIF9Q
QUdFX1BBVCBhbGlhc2luZyBpc3N1ZS4NCj4gDQo+IFRvIGFjaGlldmUgdGhlIGdvYWwgb2Yg
a2VlcGluZyBwZm5fcHRlKCkgcHVyZSBhbmQgY29tcGxldGVseSBlcmFkaWNhdGluZyB0aGUg
DQo+IHB0ZV9jbHJodWdlKCkgYW50aS1wYXR0ZXJuLCB3ZSBuZWVkIGEgd2F5IHRvIGVuc3Vy
ZSBwZm5fcHRlKCkgbmV2ZXIgcmVjZWl2ZXMgYSANCj4gcGdwcm90IHdpdGggdGhlIGh1Z2Ug
Yml0IHNldC4NCj4gDQo+IEBKw7xyZ2VuOg0KPiBKdXN0IHRvIGJlIGFic29sdXRlbHkgY2Vy
dGFpbjogaXMgdGhlcmUgYW55IHNhZmUgd2F5IHRvIGZpbHRlciBvdXQgdGhlIGh1Z2UgcGFn
ZSANCj4gYXR0cmlidXRlcyBkaXJlY3RseSBpbnNpZGUgeDg2J3MgcGZuX3B0ZSgpIHdpdGhv
dXQgYnJlYWtpbmcgUEFUPyBPciBkb2VzIHRoZSANCj4gaGFyZHdhcmUgYml0LWFsaWFzaW5n
IG1ha2UgdGhpcyBzdHJpY3RseSBpbXBvc3NpYmxlIGF0IHRoZSBwZm5fcHRlKCkgbGV2ZWw/
DQoNClRoZXJlIGlzIG5vIGh1Z2UgYml0IGF0IHRoZSBQVEUgbGV2ZWwuIEl0IGlzIGV4aXN0
aW5nIG9ubHkgYXQgdGhlIFBNRCBhbmQgdGhlDQpQVUQgbGV2ZWwuDQoNClNvOiB5ZXMsIGl0
IGlzIGFic29sdXRlbHkgaW1wb3NzaWJsZSB0byBmaWx0ZXIgaXQgb3V0LCBhcyB0aGUgYml0
IGhhcyBhDQpkaWZmZXJlbnQgbWVhbmluZyBpbiAicmVhbCIgUFRFcyAod2l0aCAiUFRFIiBo
YXZpbmcgdGhlIG1lYW5pbmc6IGEgdHJhbnNsYXRpb24NCmVudHJ5IGluIGEgcGFnZSByZWZl
cmVuY2VkIGJ5IGEgUE1EIGVudHJ5IG5vdCBoYXZpbmcgdGhlIFBTRSBiaXQgc2V0KS4NCg0K
PiANCj4gQFdpbGx5IEBKw7xyZ2VuOg0KPiBBc3N1bWluZyBpdCBpcyBpbXBvc3NpYmxlIHRv
IGZpbHRlciB0aGlzIHNhZmVseSBpbnNpZGUgcGZuX3B0ZSgpIG9uIHg4Niwgd2UgbXVzdCAN
Cj4gdHJhbnNsYXRlIHRoZSBwZ3Byb3QgYmVmb3JlIHBhc3NpbmcgaXQgZG93bi4gVG8gbWFp
bnRhaW4gc3RyaWN0IHR5cGUtc2FmZXR5IGFuZCANCj4gc3RpbGwgZHJvcCBwdGVfY2xyaHVn
ZSgpLCBJIHBsYW4gdG8gaW50cm9kdWNlIHR3byBhcmNoLW5ldXRyYWwgd3JhcHBlcnM6DQo+
IA0KPiB4ODY6DQo+IC8qIFRyYW5zbGF0ZXMgbGFyZ2UgcHJvdCB0byA0Sy4gU2hpZnRzIFBB
VCBiYWNrIHRvIGJpdCA3LCBpbmhlcmVudGx5IGNsZWFyaW5nIA0KPiBfUEFHRV9QU0UgKi8N
Cj4gI2RlZmluZSBwZ3Byb3RfaHVnZV90b19wdGUocHJvdCnCoMKgwqAgcGdwcm90X2xhcmdl
XzJfNGsocHJvdCkNCj4gLyogVHJhbnNsYXRlcyA0SyBwcm90IHRvIGxhcmdlLiBTaGlmdHMg
UEFUIHRvIGJpdCAxMiwgc3RyaWN0bHkgc2V0cyBfUEFHRV9QU0UgKi8NCj4gI2RlZmluZSBw
Z3Byb3RfcHRlX3RvX2h1Z2UocHJvdCkgX19wZ3Byb3QocGdwcm90X3ZhbChwZ3Byb3RfNGtf
Ml9sYXJnZShwcm90KSkgfCANCj4gX1BBR0VfUFNFKQ0KDQpTZWVtcyB0byBiZSBva2F5Lg0K
DQoNCkp1ZXJnZW4NCg==
--------------0j5uJBxdVyNObR0ABqhDrgLS
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjri
oyspZKOBycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2
kaV2KL9650I1SJvedYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i
1TXkH09XSSI8mEQ/ouNcMvIJNwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/B
BLUVbDa4+gmzDC9ezlZkTZG2t14zWPvxXP3FAp2pkW0xqG7/377qptDmrk42GlSK
N4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEBAAHNHEp1ZXJnZW4gR3Jvc3Mg
PGpnQHBmdXBmLm5ldD7CwHkEEwECACMFAlOMcBYCGwMHCwkIBwMCAQYVCAIJCgsE
FgIDAQIeAQIXgAAKCRCw3p3WKL8TL0KdB/93FcIZ3GCNwFU0u3EjNbNjmXBKDY4F
UGNQH2lvWAUy+dnyThpwdtF/jQ6j9RwE8VP0+NXcYpGJDWlNb9/JmYqLiX2Q3Tye
vpB0CA3dbBQp0OW0fgCetToGIQrg0MbD1C/sEOv8Mr4NAfbauXjZlvTj30H2jO0u
+6WGM6nHwbh2l5O8ZiHkH32iaSTfN7Eu5RnNVUJbvoPHZ8SlM4KWm8rG+lIkGurq
qu5gu8q8ZMKdsdGC4bBxdQKDKHEFExLJK/nRPFmAuGlId1E3fe10v5QL+qHI3EIP
tyfE7i9Hz6rVwi7lWKgh7pe0ZvatAudZ+JNIlBKptb64FaiIOAWDCx1SzR9KdWVy
Z2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+wsB5BBMBAgAjBQJTjHCvAhsDBwsJ
CAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey/HmQf/RtI7kv5A2PS4
RF7HoZhPVPogNVbC4YA6lW7DrWf0teC0RR3MzXfy6pJ+7KLgkqMlrAbN/8Dvjoz7
8X+5vhH/rDLa9BuZQlhFmvcGtCF8eR0T1v0nC/nuAFVGy+67q2DH8As3KPu0344T
BDpAvr2uYM4tSqxK4DURx5INz4ZZ0WNFHcqsfvlGJALDeE0LhITTd9jLzdDad1pQ
SToCnLl6SBJZjDOX9QQcyUigZFtCXFst4dlsvddrxyqT1f17+2cFSdu7+ynLmXBK
7abQ3rwJY8SbRO2iRulogc5vr/RLMMlscDAiDkaFQWLoqHHOdfO9rURssHNN8WkM
nQfvUewRz80hSnVlcmdlbiBHcm9zcyA8amdyb3NzQG5vdmVsbC5jb20+wsB5BBMB
AgAjBQJTjHDXAhsDBwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/
Ey8PUQf/ehmgCI9jB9hlgexLvgOtf7PJnFOXgMLdBQgBlVPO3/D9R8LtF9DBAFPN
hlrsfIG/SqICoRCqUcJ96Pn3P7UUinFG/I0ECGF4EvTE1jnDkfJZr6jrbjgyoZHi
w/4BNwSTL9rWASyLgqlA8u1mf+c2yUwcGhgkRAd1gOwungxcwzwqgljf0N51N5Jf
VRHRtyfwq/ge+YEkDGcTU6Y0sPOuj4Dyfm8fJzdfHNQsWq3PnczLVELStJNdapwP
OoE+lotufe3AM2vAEYJ9rTz3Cki4JFUsgLkHFqGZarrPGi1eyQcXeluldO3m91NK
/1xMI3/+8jbO0tsn1tqSEUGIJi7ox80eSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1
c2UuZGU+wsB5BBMBAgAjBQJTjHDrAhsDBwsJCAcDAgEGFQgCCQoLBBYCAwECHgEC
F4AACgkQsN6d1ii/Ey+LhQf9GL45eU5vOowA2u5N3g3OZUEBmDHVVbqMtzwlmNC4
k9Kx39r5s2vcFl4tXqW7g9/ViXYuiDXb0RfUpZiIUW89siKrkzmQ5dM7wRqzgJpJ
wK8Bn2MIxAKArekWpiCKvBOB/Cc+3EXE78XdlxLyOi/NrmSGRIov0karw2RzMNOu
5D+jLRZQd1Sv27AR+IP3I8U4aqnhLpwhK7MEy9oCILlgZ1QZe49kpcumcZKORmzB
TNh30FVKK1EvmV2xAKDoaEOgQB4iFQLhJCdP1I5aSgM5IVFdn7v5YgEYuJYx37Io
N1EblHI//x/e2AaIHpzK5h88NEawQsaNRpNSrcfbFmAg987ATQRTjHAWAQgAyzH6
AOODMBjgfWE9VeCgsrwH3exNAU32gLq2xvjpWnHIs98ndPUDpnoxWQugJ6MpMncr
0xSwFmHEgnSEjK/PAjppgmyc57BwKII3sV4on+gDVFJR6Y8ZRwgnBC5mVM6JjQ5x
Dk8WRXljExRfUX9pNhdE5eBOZJrDRoLUmmjDtKzWaDhIg/+1Hzz93X4fCQkNVbVF
LELU9bMaLPBG/x5q4iYZ2k2ex6d47YE1ZFdMm6YBYMOljGkZKwYde5ldM9mo45mm
we0icXKLkpEdIXKTZeKDO+Hdv1aqFuAcccTg9RXDQjmwhC3yEmrmcfl0+rPghO0I
v3OOImwTEe4co3c1mwARAQABwsBfBBgBAgAJBQJTjHAWAhsMAAoJELDendYovxMv
Q/gH/1ha96vm4P/L+bQpJwrZ/dneZcmEwTbe8YFsw2V/Buv6Z4Mysln3nQK5ZadD
534CF7TDVft7fC4tU4PONxF5D+/tvgkPfDAfF77zy2AH1vJzQ1fOU8lYFpZXTXIH
b+559UqvIB8AdgR3SAJGHHt4RKA0F7f5ipYBBrC6cyXJyyoprT10EMvU8VGiwXvT
yJz3fjoYsdFzpWPlJEBRMedCot60g5dmbdrZ5DWClAr0yau47zpWj3enf1tLWaqc
suylWsviuGjKGw7KHQd3bxALOknAp4dN3QwBYCKuZ7AddY9yjynVaD5X7nF9nO5B
jR/i1DG86lem3iBDXzXsZDn8R3/CwO0EGAEIACAWIQSFEmdy6PYElKXQl/ew3p3W
KL8TLwUCWt3w0AIbAgCBCRCw3p3WKL8TL3YgBBkWCAAdFiEEUy2wekH2OPMeOLge
gFxhu0/YY74FAlrd8NAACgkQgFxhu0/YY75NiwD/fQf/RXpyv9ZX4n8UJrKDq422
bcwkujisT6jix2mOOwYBAKiip9+mAD6W5NPXdhk1XraECcIspcf2ff5kCAlG0DIN
aTUH/RIwNWzXDG58yQoLdD/UPcFgi8GWtNUp0Fhc/GeBxGipXYnvuWxwS+Qs1Qay
7/Nbal/v4/eZZaWs8wl2VtrHTS96/IF6q2o0qMey0dq2AxnZbQIULiEndgR625EF
RFg+IbO4ldSkB3trsF2ypYLij4ZObm2casLIP7iB8NKmQ5PndL8Y07TtiQ+Sb/wn
g4GgV+BJoKdDWLPCAlCMilwbZ88Ijb+HF/aipc9hsqvW/hnXC2GajJSAY3Qs9Mib
4Hm91jzbAjmp7243pQ4bJMfYHemFFBRaoLC7ayqQjcsttN2ufINlqLFPZPR/i3IX
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------0j5uJBxdVyNObR0ABqhDrgLS--

--------------5UCV7MO0yGV9I2Gcqe3OKiXQ--

--------------IBH0hIChx0pJo3JB9HTgBbXv
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmmpVX4FAwAAAAAACgkQsN6d1ii/Ey/Q
fwf+PMUoSzrh4GgZ4p2g9HKWv2hwH2+K/bdStVYbu5X1vagRbtZliX1FWpF1oKjaKbL5DDJNIyxB
zkiCpGavvH+YBm/3WlS3sCa0XWIL5PNx58y3xrE8VMMy+JR+ep/Y+5wwkmu8xnJq6Ve8x5CPyLCk
9l7KM9lxs+GeZRb2Myy0ZQx2QYJbPmIyNaFjcq8455Nqd5hFUdYz192Og6f6hYZ0VB9lPfFyVocJ
64CizN+y/P3P1ka03VixrZ3kh+abP98r5uDJ3yXtfPi4h7GDIktQR9iCDbF7nWohmxGP8sV2BvGp
BilPW6WrtO/Ok1Nhusie4FX4RYYXFwjKmhsHHJH9GA==
=EuOw
-----END PGP SIGNATURE-----

--------------IBH0hIChx0pJo3JB9HTgBbXv--

