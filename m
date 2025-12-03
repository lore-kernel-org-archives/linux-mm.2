Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F211D15DAE
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 16:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61BD76B0026; Wed,  3 Dec 2025 11:31:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC626B0028; Wed,  3 Dec 2025 11:31:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BB086B002B; Wed,  3 Dec 2025 11:31:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34B206B0026
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:31:34 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F311A133348
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 16:31:33 +0000 (UTC)
X-FDA: 84178700466.29.6A30FBA
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8993140003
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 16:31:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=Foud+0QJ;
	dmarc=pass (policy=reject) header.from=canonical.com;
	spf=pass (imf07.hostedemail.com: domain of valentin.haudiquet@canonical.com designates 185.125.188.122 as permitted sender) smtp.mailfrom=valentin.haudiquet@canonical.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764779492; a=rsa-sha256;
	cv=none;
	b=xXQ9lWFdSNGMAlgfvsDP8Pm4SPvLNXUsCIENoRr/tJsQqW9htkSvvQb0xOc0YMt/m2GlK+
	Db39y9ICxLPPGtWnWKGfXL2NK5sRF+apO6CqpLus5Il9BzrypTcn3sZ62o2EFREH28Zkq2
	wQfXLRQdCAe4U3qFYbfcB1L9Gj4rUHs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=Foud+0QJ;
	dmarc=pass (policy=reject) header.from=canonical.com;
	spf=pass (imf07.hostedemail.com: domain of valentin.haudiquet@canonical.com designates 185.125.188.122 as permitted sender) smtp.mailfrom=valentin.haudiquet@canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764779492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0gnY/UzSbFUAuDU1KntIMiLjASuWWo0nEVW8bui9Tk=;
	b=Lkf5gPZaZ3Fa68vA+EctpFhB0OuaWvisibreckvpuPi02uaOb9xfRi7s6ho5EOE/hz5sGN
	ShwHJMCP/VU4TS1pPjXZi3TyApcd73JdPPweHABO7BnDQfKi5Q5j6O79zu+wCjDR6z6l/G
	QTOsImKzjsJDkpFB7ZcccB2YSTcdyrA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 05D3740177
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 16:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1764779477;
	bh=l0gnY/UzSbFUAuDU1KntIMiLjASuWWo0nEVW8bui9Tk=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type;
	b=Foud+0QJhVZjJF4DQfioBdMg6CnsFVprAVsxR93i37Uwz9UyPKGahRFI2NjuQbcNb
	 D5WzMWlvWlX+uJKLrX9WQ3YfruPepFLdZ79vfCcWNjhVEuVIQD58i95/frEZAsOWW0
	 UWSZEt1dWAIsG/C+2JSyGgF5Sx5Cmw1olm2FDXqJdxE9Yt3LKfmOnrP9L8MHoGAt7L
	 OtqgGGTvuwDtQKEAj8/oTzpXePGz7E+4oXvnJOsoV5q+VyvhTfvbEw5c0VQo9pHaol
	 PodL8wQvw/nkqxlATzYQyUhwRfiAFWB1O1d2PfGU6ula6ap30MTUfAM8QA6uwz7AHA
	 YWa861XFtBARNmDV53Ii1ApRa0i+wRW5B9E8j1YwyEPpPcrU5xYyRKMjzkIxSIBWYd
	 86pSd49woBDfwR3B0LwMbgpjtnygCNgq2NfT97RKkhzJ5ajFV+XUI9OYaq+mXreiqe
	 fTSdPkiNRisc/tPZSt7ba+y8xHk5OnD1xkjztA4WvMk99ofMgA08Cd3mTLT0Lc8EHC
	 62e/b7At2IvZT9AE3GsFJt67h7C1DP9+HtlZ6/ANu/wkoXS2vv3hbkD8JHevovOxIE
	 cf3J7O6Ol9rODBJM0bSl23h2WoMH04uXG5qxkG1OWjU1ac+xDFLKK3k/B9KtuBZoQ+
	 8YgJ9xZVl9QpCTxWt7BcIKKc=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477939321e6so39954105e9.0
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 08:31:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764779476; x=1765384276;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l0gnY/UzSbFUAuDU1KntIMiLjASuWWo0nEVW8bui9Tk=;
        b=cfIa+WNJYPkeROa5nygdlCA8Tqet/Alr827lhlgouvZcpxcQd1mWRWUE0CQnxJTLWw
         fx1ySCdirYyM6LSNR5RBPhCpO6uUcqx3hcqfYw66SHKVpOrhqIPU0vW5Xo6x6B8LinWZ
         8hWhDifGNQwfpRmOuwcaTmQlNGShIodkSTIUHx/IruEaoBB3wfMUBMz845E2nTnUy6uR
         ROIYEgiTkmMdZMfPvWdHcnXlkkFdJEa5Khvb09oMZKbxdSXGwesdazxNi+WRSNlcc6GX
         TWbyDIAJMx1vqWHz+viMTtRgQTOpQ5vp4RanlG9KsYucd31d68yaT/xgHzEytY3mOe1t
         mXEA==
X-Forwarded-Encrypted: i=1; AJvYcCUeYIjSPaYP64rZ+cGxg7IVttgVV61Vl14Is9dhVM6iTfHq65VNdDYxvWhnho7nJMWyaZMm8FXEgA==@kvack.org
X-Gm-Message-State: AOJu0YxkToa49IRp2RlA3UIZtz5BHOAJswaQODyc1J7kSHcntn1I8e1Z
	6GQmin1WNh+G0wKvljsD5d6sduINtG8lcDRoFCHEBGOcKl+jdz01AU4lHQW4nAu9t1JbEUBCnNT
	Zj+5w/8xBrNvw6n05xNxiW/ArNUWyIKNSRgmyw2YnMaJhCZIK/A6OPtuc9G/vNOuiqfcI
X-Gm-Gg: ASbGncunNqwraZV1A7ZlFzW75KT9gVq2X0+7ZwLnFj3uMtT5x9X3eGWk4gUyx7vIRTK
	d6yr58/Ytws5PoW8wNMQ7peXl8Mdj9gculKJNC2RQfe2oUClL1Nnv6XNvJV+ynIilSc7uc6UMVN
	hJf27aKosZmCmfEMzejtTZqa4oxPIiYKjRLjf0LElmr6mM09dRshQH4NT1oFUGlveqEH2Ixmobg
	3gxg9aSWvYf1cAbWeQuRmNjywJAx1X0vkN3/vaEl+aWNgxdPGN+JHkyAey7xKD/ZBswDfd1/gSj
	T3qs8hmdDr+0Hl7t5OZFEty/YIGt2E3bRWcmYFyJI9twHX8/fE7xW3n/5uIDY7UUIEW4ByT+Flb
	PMGSNjpEaqjpGXNNfigQADFHwIzuoyYahd2sYiN5nNy7KmJMXdKpX0oQS+k51ZqZNzOZzMm599h
	0=
X-Received: by 2002:a05:600c:a41:b0:46e:74cc:42b8 with SMTP id 5b1f17b1804b1-4792af327dfmr27911505e9.17.1764779476147;
        Wed, 03 Dec 2025 08:31:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHCKejq/2U+1EN5UAB8CezRHOHJDvwMZzcFVGMZ1T1ZB5XD8pg1afh59Y/Z4iwxgxyD87hFlQ==
X-Received: by 2002:a05:600c:a41:b0:46e:74cc:42b8 with SMTP id 5b1f17b1804b1-4792af327dfmr27910815e9.17.1764779475621;
        Wed, 03 Dec 2025 08:31:15 -0800 (PST)
Received: from [10.1.1.222] (atoulon-257-1-167-49.w83-113.abo.wanadoo.fr. [83.113.30.49])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5c30c4sm40900310f8f.9.2025.12.03.08.31.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 08:31:15 -0800 (PST)
Message-ID: <6b25515b-c364-47f1-bd75-8b7dc16e3701@canonical.com>
Date: Wed, 3 Dec 2025 17:31:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: devnull+debug.rivosinc.com@kernel.org
Cc: Liam.Howlett@oracle.com, a.hindborg@kernel.org,
 akpm@linux-foundation.org, alex.gaynor@gmail.com, alexghiti@rivosinc.com,
 aliceryhl@google.com, alistair.francis@wdc.com, andybnac@gmail.com,
 aou@eecs.berkeley.edu, arnd@arndb.de, atishp@rivosinc.com,
 bjorn3_gh@protonmail.com, boqun.feng@gmail.com, bp@alien8.de,
 brauner@kernel.org, broonie@kernel.org, charlie@rivosinc.com,
 cleger@rivosinc.com, cmirabil@redhat.com, conor+dt@kernel.org,
 conor@kernel.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 david@redhat.com, debug@rivosinc.com, devicetree@vger.kernel.org,
 ebiederm@xmission.com, evan@rivosinc.com, gary@garyguo.net, hpa@zytor.com,
 jannh@google.com, jim.shu@sifive.com, kees@kernel.org,
 kito.cheng@sifive.com, krzk+dt@kernel.org, linux-arch@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-riscv@lists.infradead.org,
 lorenzo.stoakes@oracle.com, lossin@kernel.org, mingo@redhat.com,
 ojeda@kernel.org, oleg@redhat.com, palmer@dabbelt.com,
 paul.walmsley@sifive.com, peterz@infradead.org,
 richard.henderson@linaro.org, rick.p.edgecombe@intel.com, robh@kernel.org,
 rust-for-linux@vger.kernel.org, samitolvanen@google.com, shuah@kernel.org,
 tglx@linutronix.de, tmgross@umich.edu, vbabka@suse.cz, x86@kernel.org,
 zong.li@sifive.com
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
Subject: Re: [PATCH v23 00/28] riscv control-flow integrity for usermode
Content-Language: en-US
From: Valentin Haudiquet <valentin.haudiquet@canonical.com>
In-Reply-To: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8993140003
X-Stat-Signature: any3nxf5ki33fa83st5c56me46ezqksy
X-Rspam-User: 
X-HE-Tag: 1764779491-369195
X-HE-Meta: U2FsdGVkX18IhlVN+R4a7kwEMNdfoO9lIGFmmA6M+L4pCNIJTkAJJxiCCmm2E5s7P9Eq8PiMucSbhbbB2HwOu+mOr8EbW3dY4lZf9zp4lrNtiYOrdyNCMGwMDo0xS7ecsDbppHOGBuZKd3TXJyGD0j7LLyeVbSv+KYU/iJeNYEQn8h0CGjf8r/1u7FTzQBBbdgC/ZM2xeV7N4gUSolcyWgggVMc6qhSEalZGAbL2zhSLf3DqKh1uF4OS1ppew3UiBA4t8abKD9WE3XwpTeZGVqSzhveDAYLM1jgyDvMQJ7ZFFmQ0S3ab4b8PO0gkgDaHo3PSu9ptyZYMyPhPq1jh3KsZrYUYXb0RsKPueo/JLHLSZiGAVNLaHi/KR2FDBedaCWgdYY11pDh9fhyh2uzzehxOsTPDv8l/uaTF1e90MQeeIyc1ZUV1H/P8CmSab9Zzk8iCkdQgby1047gPemDr3w7ohjeTqTARjt9KlaiawDERMkGwJFhjJiykjo9QvRhMAoPvKIl9YHXMe14gt23rgD8QczNA+AViCAcUT7nLRtWwCClVhzFCihdcJ0hC+hd2rJIJkSfAHB+65JzkouslJo/Slt34DzTIeSKIcQzTqCzBkY3HYzVBmQxhJl1hrBS2i1LffbObi7sJr9P2EWz7/3YinAAyCjk1ZDPl/V+fPufCj4CdUsMuRTU3rovInzKcuD3PAhetHZ9zeA5w62m0N2pN48ngIPF5Qjr0Sq2C6ZtpoTaF6Lx7WGWpkWarKKSUYiVWkWTSBGkRu2zKb3O76E2SQ4YOds9G/mKqXQ/KbBEI43k65S4N2sS5jq/QMxY0TiZWJ9XyRJMWf0TxgWG8TCETXvbsE1fd16YakmNhBTYNZu9gfZzHd6WFu1cIdsw3bu/eFokHpDtbBuSmGbx3CFcjLe3L1xdnuf6loZwcWkBfKNQoL0MwCFyTSjFsvxHtBnpCU9Kl40hx9C089WP
 yoJxCwef
 acmiJJRPCcPNqS2Sg/utIrWTveZxEBWVvw7HSewply4KZLYraY5rNZ4NhhQuMvbPPA+eQIw+RWT5kywycSlPloaTPAIjmvfO9ye+ZWCIm74KCV1fzVXZiFWsfEY/D0dMTr0hLoh8bFFqq47f1unedSlSDhSzCNjcc8GsO3S4xInDpw6auBljMZ53vS5DzuqmVXOlOhY30Nm/ouAVM8ziZB8SoNY9GbXP+Kl6UAsSTbnt3edCHAjN6xqCCKX5jEwBYBYqvoarRXm3B2C4Y3CEcP874bwNeIMeAoddl6S7aV/B1qPZPE9ZlvC8Lsusiy61D3kvRzM5BKN8fJl6cavL4PU3+fG54KVfzqGYraCc93T+ZInPLYdrKih5XDpMadg1bB9NC31E9sZhX8OBGx3G9QoVQUd1BJcZge+ZUNQ41TR3rWHtWdLMD/yxg1Dt/c3gcVGCB+QA7wbOrHcenMlFRKBT27Ki3FBWfDW2+NnWLd52O/7eGMCpPyqDO3Ga6C0Eyu0h9JuM9D1XC9ng=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>


