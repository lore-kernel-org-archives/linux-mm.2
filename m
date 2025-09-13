Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17378CA101F
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 00:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AB378E0008; Fri, 12 Sep 2025 20:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55C0B8E0001; Fri, 12 Sep 2025 20:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471548E0008; Fri, 12 Sep 2025 20:09:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30DD58E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 20:09:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EEDC3BBD0A
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:09:43 +0000 (UTC)
X-FDA: 83882293446.05.4EDBD36
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2AE38A000D
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:09:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iq0m92TX;
	spf=pass (imf15.hostedemail.com: domain of 3RLbEaAkKCBE9Bur89r43x55x2v.t532z4BE-331Crt1.58x@flex--sudarsanm.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3RLbEaAkKCBE9Bur89r43x55x2v.t532z4BE-331Crt1.58x@flex--sudarsanm.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757722182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4qcwx7tIF7ceX4FWdqTaXFiCrpIzKr7ul9F9MwN60k=;
	b=5xArNFjFp7wdgtUTlXfPnbznP8xkKixJcUfXMkULODmhJy1HKR5SWKZ/pE710mr9MwpgBx
	2yDHMjMWYxNMBOy/P9iI4S3tZiNca0KTfLf+j/5hU6o0mCmKGlRnNQNtdPzYFJ8wc3Wxl6
	CBboytxZiVWTneJcXU8Jf+GrO5SVjE8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iq0m92TX;
	spf=pass (imf15.hostedemail.com: domain of 3RLbEaAkKCBE9Bur89r43x55x2v.t532z4BE-331Crt1.58x@flex--sudarsanm.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3RLbEaAkKCBE9Bur89r43x55x2v.t532z4BE-331Crt1.58x@flex--sudarsanm.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757722182; a=rsa-sha256;
	cv=none;
	b=0PZqwpp4NjBkQxlSxH0o+rztUi/sCUJKH9NRT0oMzpIlVeMiLZJSS1ZJy5O/JVbSKnWH/0
	RPiuFePJGfCd/W8mGUZPb0X3RlGWnHIEM2t58GVqUGcVfjGEeS9wR5IK28TXT51GkBn7Cz
	CeE9aCvCNKMDF62i1EJ9CLTSTPKGI4U=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77283b2b5f7so4069454b3a.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757722181; x=1758326981; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D4qcwx7tIF7ceX4FWdqTaXFiCrpIzKr7ul9F9MwN60k=;
        b=iq0m92TX1Yf2F4nF9FeXvvRBXta09Rv9wFve1kM0/E4Xor6gbCUEkjkyT/3NYXAmoF
         JClyzp9ySIH30oHGFOFgU9tY8/otuZyeRlT9bSyczGvlY5Dacyl2/zKaQYPsyZu8qLpR
         19Zip83eNDeZ6oEgTd3xBE1mxkUbhMrOkABy1eTpG/AtPy6Qu7kFoL5zQkvetSEwmeVq
         ixDXZrDH4bkjaxtPSa5blXtRVh0NJ56WVV3HgAi51MrFJfhV2Lff5vDLYmW/FmUW6ho+
         M+N9psievd19dXxX9XBH+X9uj/JpedQPDJq+xsAq+lOYs26lZKgrQTgjuhSqP6uoz6TJ
         6Xjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757722181; x=1758326981;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D4qcwx7tIF7ceX4FWdqTaXFiCrpIzKr7ul9F9MwN60k=;
        b=bC6UzyR87hDrUjK1LMQMBfPAtJwGgLiWuhuBcH4PvmQqV+aJufsSBBZh6xGmt8QFPe
         EjGiXtQlSy4eXejEwx5aswfRzUFFM85Di8CeUJ3tgTtEq8omNNyxEuZTrvAjp7ytWtGH
         KXNSw7hFViLFGAUteNfTXGhsG8BVdvMjfRHsehD4DptIrpmhkhud7YikV2eX4xBEHfQp
         dT1Zlh/KIQ6n+Efn9RLtBw4F++ClJeC9oZmQQYWgw4DTPZsafeYgcoa1CUAdsVAr+LsZ
         LE3GIjD3+tz15YisEErSRc8zvCgkSNk8ca+/4WbUg1JANbzJV2hma995yP1qb+omQnWS
         53Zg==
X-Forwarded-Encrypted: i=1; AJvYcCXZMJ8XJYjR4izG2Ov5MiXaRG5wTXTuMS3dq4kI+TpLfOABEmyNfHw2Zh6q7gghUiwWqi5ghZEQnA==@kvack.org
X-Gm-Message-State: AOJu0Yyh2uofCBwCD3yn++3bZ8cfawD9SISPJ2M9q/xYPZ5uIQCIdxhD
	WAyK1+y87jsJk1uqg7A7uW5SfGwF8DF78ivG9dSShbtC8KFWp94P9kFcRFyrNvMYGpV02A41WQ5
	y9JNAJ7ynQ8i/j+irxA==
X-Google-Smtp-Source: AGHT+IHS23gulFRPNDYDol1StJlKh3HDBOcLTAfZPF7cXgJccYt3Eih+Wl2Bgx4LCQZX6nkkbvzcr31DF56Mzcs=
X-Received: from pjwx7.prod.google.com ([2002:a17:90a:c2c7:b0:327:d54a:8c93])
 (user=sudarsanm job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3288:b0:252:2bfe:b648 with SMTP id adf61e73a8af0-2602c6246e2mr5853775637.52.1757722180835;
 Fri, 12 Sep 2025 17:09:40 -0700 (PDT)
Date: Fri, 12 Sep 2025 17:09:35 -0700
In-Reply-To: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
Mime-Version: 1.0
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250913000935.1021068-1-sudarsanm@google.com>
Subject: Re: Benchmarking [PATCH v5 00/14] SLUB percpu sheaves
From: Sudarsan Mahendran <sudarsanm@google.com>
To: vbabka@suse.cz
Cc: Liam.Howlett@oracle.com, cl@gentwo.org, harry.yoo@oracle.com, 
	howlett@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	maple-tree@lists.infradead.org, rcu@vger.kernel.org, rientjes@google.com, 
	roman.gushchin@linux.dev, surenb@google.com, urezki@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2AE38A000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: pdd8bruw5yrrpwiuyjgkfq9w6sj9p35i
X-HE-Tag: 1757722181-314292
X-HE-Meta: U2FsdGVkX1+VcyFgiD6RIMOdjRTiEKftYwL18+VUbg6mCuTvnn4infI9wi9brfQyUXX+wPFqWsHF47xDrA5gnlLwNblYyQyvWmtAfW+4ZW9pMLlght3J5Kf708TERwYc1etb324xdTQJtlCi24ZnC8nNOQndxNIr6UqAF1hE/xWQmsRzENYERo6L440sPyNOGBWMRnbVSAogryTb4SS+G37LMZf62lq3NDD38HutLrlDBnNwIHOqGFSe+6ToCL3s1LIXgfluOLsEVlCNVhDfJ+pT0OmqtwUDOpQG9pr3Bxqci1Zi0K09VAhxCeqCPcIxSzYMvqa7JWVZqwujoIyU1h0omKINSsoYvpOrzXI1TBQp0xWB+ALXRLqgl9pCEB5VJ9gyBm30w/jKJXX1XbCFGDj9PMPuXXcmVWmP79Hh7BYop0ZxQPtCCacFDKvOny/dvE3txvqlwFlHGvFpf1z+W7j5+clwNpAU/a+oqcHrqaT7CRGj6chvrQEMFg8JU2qqlFoNVsqnd+Ek0r8J5sIUv64ADbQvzlXBW6LOFfDFRQMfzZjrW0Pi0V3VJ7XjGqFrXhOPPv7L3L8QSdmUqyd+XWrsc5loQfjMx0j9NzdSN5auNcY65bYWfbntNEufx4JNwjyZwLHnaHmMbfodn38NqSaDrSYnVfgm56haeghM/EEz/m2W1yQlhPpvrWJBVZngOQXNOk8Dd8h3OJOyIsqiN+uuc6gDBa+/UZgiBNv6MSRfDpCPYz/V24VqSgksLNtkV+WOMRnNo2n+ePK0T4/KEhgink7m4UbiqrVbmWkCk/cJMivGyUvZWeINXya7mxvH8nvjSqf8UzOqPtE5wVwr8FiTc3fWm57ujLZqPjiEDDP+Sz4+0ltcYZ/bkqIinNF569hwHr2+pOKUNaR6RbPacogc/kgcr0s/tgS8QsuC9FlZcj6yWY1ySuKDk0vI21yHAXz+mHcc0ognFSXNIpW
 dpdDbvjK
 nYeBa+fcZkgvNqOtyB6WHhA0mz3qewMXACoAqGoPi4G8sOuDytPoCCKFvDsl9XL2+fhgt1zgbK6w66OyONd2EZMCa22urQJcKmCMListfI+HQIPE9sYOzGHlZP+Q1TlyxIWWccqqByFtA3fEnZTONtxOYTcehxeqbzH3O2t/4zF/kIFQjdvHfJW0LIDshgjJiFyMPKYnFbdQnHHKZAhi5NwdoGlzPu9BAslu2TN951aLFR9BbAfg15Bn2E+gD/1VN8i57DRQjl7YEz2b5dA9be73eVu82reDN57FxrLDtxMkf1xyapFAVmnd56Ntwi4HgiEe1YFdSHBcox0+/YRjbLKhdN3jg+p8rWy4lXuUjVgy0I/Nbt4OgBmcYhIaRnxuJe+oMH8KCm3qtCBJEvSMaeQR+vWkC+/ghEy5zXehBseUVWJK3l7t3MEceD5MwNf6aJWmWL1ivw7rThT4T6+7osETklcMC/a6Yi3P1F1gQ836c9utWbqPNqJTgzksedV1qcEKn3B5AseU74FJJ/f86VmISxHSXPwPTw3USHmrJFmCevzXa8USc8UjJqe1EmCBG8la2a/3PsM4Ex+A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil,

I ported this patch series on top of v6.17 and ran
some benchmarks: will-it-scale, hackbench, redis,
unixbench and kernbench. I ran the benchmarks
on Intel Granite Rapids (480 cores), AMD Turin (512 cores)
and ARM (80 cores)

Summary of the results:

- Significant change (meaning >10% difference
  between base and experiment) on will-it-scale
  tests in AMD.
- No significant change on other benchmarks ran.

Summary of AMD will-it-scale test changes:

Number of runs : 15
Direction      : + is good

|            | MIN        | MAX        | MEAN       | MEDIAN     | STDDEV     |
|:-----------|:-----------|:-----------|:-----------|:-----------|:-----------|
| brk1_8_processes
| BASE       | 7,667,220  | 7,705,767  | 7,682,782  | 7,676,211  | 12,733     |
| TEST       | 9,477,395  | 10,053,058 | 9,878,753  | 9,959,360  | 182,014    |
| %          | +23.61%    | +30.46%    | +28.58%    | +29.74%    | +1,329.46% |
| brk1_8_threads
| BASE       | 1,838,468  | 1,890,873  | 1,864,473  | 1,864,875  | 18,406     |
| TEST       | 1,464,917  | 1,668,207  | 1,608,345  | 1,654,578  | 70,558     |
| %          | -20.32%    | -11.78%    | -13.74%    | -11.28%    | +283.34%   |
| brk1_128_processes
| BASE       | 65,018,211 | 65,603,366 | 65,285,348 | 65,103,197 | 232,885    |
| TEST       | 51,287,801 | 52,161,228 | 51,647,807 | 51,509,505 | 277,326    |
| %          | -21.12%    | -20.49%    | -20.89%    | -20.88%    | +19.08%    |
| brk1_256_processes
| BASE       | 15,186,881 | 15,239,120 | 15,210,265 | 15,205,809 | 15,850     |
| TEST       | 20,478,924 | 23,936,204 | 22,754,698 | 22,771,320 | 1,255,974  |
| %          | +34.85%    | +57.07%    | +49.60%    | +49.75%    | +7,823.72% |
| brk1_384_processes
| BASE       | 11,587,076 | 11,851,775 | 11,765,869 | 11,806,007 | 73,736     |
| TEST       | 25,464,757 | 29,176,818 | 26,695,946 | 26,563,116 | 1,012,563  |
| %          | +119.77%   | +146.18%   | +126.89%   | +125.00%   | +1,273.23% |
| brk1_512_processes
| BASE       | 14,410,293 | 14,891,082 | 14,775,209 | 14,793,142 | 114,384    |
| TEST       | 22,918,195 | 29,648,177 | 25,204,321 | 25,128,471 | 1,604,037  |
| %          | +59.04%    | +99.10%    | +70.59%    | +69.87%    | +1,302.32% |
| mmap1_8_processes
| BASE       | 3,164,411  | 3,170,585  | 3,167,590  | 3,167,692  | 2,436      |
| TEST       | 3,516,242  | 3,756,209  | 3,684,585  | 3,698,731  | 68,659     |
| %          | +11.12%    | +18.47%    | +16.32%    | +16.76%    | +2,718.28% |
| mmap1_8_threads
| BASE       | 627,817    | 632,702    | 630,554    | 629,281    | 1,764      |
| TEST       | 541,202    | 554,097    | 549,104    | 549,896    | 4,257      |
| %          | -13.80%    | -12.42%    | -12.92%    | -12.62%    | +141.34%   |
| mmap1_128_processes
| BASE       | 30,303,429 | 30,736,686 | 30,466,107 | 30,343,821 | 174,985    |
| TEST       | 9,749,426  | 9,893,331  | 9,823,701  | 9,857,157  | 52,125     |
| %          | -67.83%    | -67.81%    | -67.76%    | -67.52%    | -70.21%    |
| mmap1_256_processes
| BASE       | 7,496,765  | 7,546,703  | 7,528,379  | 7,543,246  | 21,465     |
| TEST       | 10,868,119 | 16,947,857 | 12,695,418 | 11,608,083 | 2,157,787  |
| %          | +44.97%    | +124.57%   | +68.63%    | +53.89%    | +9,952.34% |
| mmap1_384_processes
| BASE       | 5,629,206  | 5,856,927  | 5,758,347  | 5,733,892  | 85,930     |
| TEST       | 12,053,514 | 13,635,555 | 12,966,975 | 13,283,450 | 606,325    |
| %          | +114.12%   | +135.49%   | +112.89%   | +104.26%   | +2,855.57% |
| mmap1_512_processes
| BASE       | 6,959,199  | 6,996,383  | 6,975,912  | 6,974,353  | 15,446     |
| TEST       | 10,197,814 | 12,029,690 | 11,458,180 | 11,381,726 | 534,690    |
| %          | +46.54%    | +71.94%    | +64.25%    | +63.19%    | +3,361.67% |
| tlb_flush2_384_threads
| BASE       | 2,953,477  | 3,021,464  | 3,003,512  | 3,014,264  | 25,525     |
| TEST       | 2,231,417  | 2,526,876  | 2,408,368  | 2,411,121  | 115,773    |
| %          | -24.45%    | -16.37%    | -19.81%    | -20.01%    | +353.55%   |
| tlb_flush2_512_threads
| BASE       | 2,499,486  | 2,542,966  | 2,520,278  | 2,530,049  | 17,161     |
| TEST       | 1,707,641  | 1,714,524  | 1,708,951  | 1,707,713  | 1,877      |
| %          | -31.68%    | -32.58%    | -32.19%    | -32.50%    | -89.06%    |
| mmap2_128_processes
| BASE       | 29,754,984 | 30,313,146 | 30,010,106 | 29,897,731 | 218,812    |
| TEST       | 9,688,640  | 9,750,688  | 9,710,137  | 9,696,830  | 23,428     |
| %          | -67.44%    | -67.83%    | -67.64%    | -67.57%    | -89.29%    |
| mmap2_256_processes
| BASE       | 7,483,929  | 7,532,461  | 7,491,876  | 7,489,398  | 11,134     |
| TEST       | 11,580,023 | 16,508,551 | 15,337,145 | 15,943,608 | 1,489,489  |
| %          | +54.73%    | +119.17%   | +104.72%   | +112.88%   | +13,276.75%|
| mmap2_384_processes
| BASE       | 5,725,503  | 5,826,364  | 5,763,341  | 5,765,247  | 29,674     |
| TEST       | 11,682,353 | 13,720,566 | 12,269,665 | 11,776,228 | 877,060    |
| %          | +104.04%   | +135.49%   | +112.89%   | +104.26%   | +2,855.57% |
| mmap2_512_processes
| BASE       | 6,959,199  | 6,996,383  | 6,975,912  | 6,974,353  | 15,446     |
| TEST       | 10,197,814 | 12,029,690 | 11,458,180 | 11,381,726 | 534,690    |
| %          | +46.54%    | +71.94%    | +64.25%    | +63.19%    | +3,361.67% |


