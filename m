Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B496606A32F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 00:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=TTSy7R0E
Received: by kanga.kvack.org (Postfix)
	id 642C06B05B5; Tue,  3 Nov 2026 19:43:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FA586B05B6; Tue,  3 Nov 2026 19:43:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E2E96B05B7; Tue,  3 Nov 2026 19:43:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2A06B05B5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:43:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A0A3F805E9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:43:58 +0000 (UTC)
X-FDA: 85395589356.27.CCC1F4A
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id B62B520003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:43:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TTSy7R0E;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793753036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qRp/BwQBEaKjJByyj+gyRQztnD96+imNxep8e/AfWM=;
	b=dCT8KisDdrjwkb4OMsVjdZYJT+rH15fBhfybQYYOp1obfDBVVLoLlu/DYFQnVv9dpvZlVy
	hVIgFGJcpx9a5Y8fmv0h4qnq+SJUfBYBSBVYOtBjhHcaBc6Ms1eWDx3MQcNANQta82GLfq
	gQAIl7y/4EmKcyFM20mrItxy8jqH+U8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793753036;
	b=OXBCK29rf+F5sCa5YDZEn3TNpybRFmyjkJ+64NR1wn8qn/sE7Emuh9VDHaWqW9uh0GpbES
	t4imqFKMeRuyaOqTtOJYTtC+RfvJIm/+GmU4CLnauN5ZPyUZFcT5HQJawhve9tqjq37FVr
	HMcPRuQPlyRil1tExCaOQ1gxI8TfEas=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TTSy7R0E;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-7cccb2c96d0so43105137.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 16:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793753036; x=1794357836; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8qRp/BwQBEaKjJByyj+gyRQztnD96+imNxep8e/AfWM=;
        b=TTSy7R0EG4/TjR6H0HaJSL9H3OBeBDzRjzDGi1eF5o3Kq+LblVCIHZkj0s5rHJJc3b
         xN12+ebc7X64s0tGlbZ3mllWWHm02EBHI66V6Wzd2rwthPxt4PsXW1SoIegb0xrplwxu
         2nXSY3f0Y83vQZQnXIcSKzzXBbiLXxJGnO7YH9+4iUcmbZ0UodKnoWkcIMKBTjrjjuvE
         jAwT9CooZAQFLUp3Ly7mZGlixbOZDqfq5neE5gY7j6xSkVgpO6ABTMG9edFqtfY2T7fC
         cqGM1Wi8LLd9YzZQDH8KgTr+7VZ83lnibsp8Lv0kXB9qVegEBb56P8XwSPCDLitqCD7/
         mfRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753036; x=1794357836;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8qRp/BwQBEaKjJByyj+gyRQztnD96+imNxep8e/AfWM=;
        b=Sj93LqrarkAlr+zNRkLPpBo9vUqWITewP0wU9UHyS/UcXdvrsWeYk5/+CGscMXtTwD
         VQ52/cLVz7pJDenhQA04rsHxej9PqOqrxlAULHVvILcwzeg8G3osV2Yv6qtUelBka6F0
         Ak/GJq3IQPYJBV/pi6Tuo5bFeiWOmg31WBfeqX+08S2zlV+3EF+9Rv0qdz/2akjyUq4O
         b6lG4ke0hYRUV63SPLR0wNMo4ms+EHRjabo1kShCbPupUahoAkxqyI+tSP2+7ROP7Pzz
         tGBqIs/2nLXbSc5VJh7Gtqss7XYsQey1W5JV5lLDjPO4w0oXq0lvorOq9UOlUojp6WnP
         uf2Q==
X-Forwarded-Encrypted: i=1; AKwUvBwqBIMSdS42gaBKrE/O2JHoAGRrC1Zx0mSBV+poUiJNE6hLHezNii/LBSEEOXqQ6d1a1F6JOw0/Mg==@kvack.org
X-Gm-Message-State: APuU4Z+a6aNB/Ji0Duo+kVHAy8MZrYsJ3MVJzRD1a/0RsYl3u7oRAmvP
	xGJJHFtkoYSkBt3mYIfy+/9PLks0bFQIosBqmP1cuQUa0jMpKUylnvQ/TS3zpk3QboY=
X-Gm-Gg: AYBFou3Cr+/a699jfr+ge17mrhzspSwLlNvj3UtDp4tZsz7m2RCIxLuYDRj1ORGLb+t
	wXkvtd47aBDYhU5dJIi3ZYRfniTTwWqD0fB0d05rV5+L1PTiVQ/bQdsD4l9YexSNrrMAUrY23Qy
	7xYC7LZMOfpj4/+n/BfCQAOQU9LCU3oc6nHMAYqM/PoM3vmBXUY2HqE8FZJVDz7El15v/lX3h5p
	tNAo3Bv1ZbeKHjCdpBLW+1GWqzr8hpbCiNneicfLVEioENPplUyvG0knExnCrlfPZF0j6bbmzOG
	pJS1ktJql7zFWSzuJQZuUO0TTfJ6Kif3zSBKJ+0KiM38nl58+gr5hUDaYNLqd6xAL2zSdnMaWlt
	tUUKQkibuab9Vy1N6xDwUz4E3sB33F+T/wjQquu60HFesdj3gOv8l+N0PV0AC9PKV8WM8ENOFwl
	ywJbTBXZq9hU46zaM1O+t2m4H64DBNAORsPvaA/m0nCxufd4dBOkU+i5ksjMKUafuTBFRZ8g2c3
	bINYiJ6fvoIjzVgoY2QYImP/LTlqR0leN30OePqk/3oySXJTwSWUALZDfahnR4p2BIoCt9GMmUA
	Pf4pjBBSlT+IW5Gzo6L1E1dBDrnbqHSFzemZHT0Xq40/VIR0RCSMs8d3jPNeOPuRtsQeTInYyPX
	lA+DzR0gOTv6N/30Yb/0A7iWQEd+Zza7i8xNBXEs7Fai2lrs7jWqnhkiXTYn3WHWs6A==
X-Received: by 2002:a05:6102:5126:b0:7cc:9f01:1378 with SMTP id ada2fe7eead31-7d07227aa1bmr5468508137.1.1793753035777;
        Tue, 03 Nov 2026 16:43:55 -0800 (PST)
Received: from soleen.c.googlers.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d26fef4ed3sm527432137.11.2026.11.03.16.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:43:54 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 09/10] mm/shmem_luo: Allow retrieving tmpfs files
 with O_RDONLY
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-mm@kvack.org, Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
 Jonathan Corbet <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
In-Reply-To: <20261103010216.3447716-10-dmatlack@google.com>
References: <20261103010216.3447716-1-dmatlack@google.com>
 <20261103010216.3447716-10-dmatlack@google.com>
Date: Tue, 03 Nov 2026 19:43:45 -0500
Message-Id: <179375302574.727293.7162114309691231709.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1135;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=YJNHuLpjxIokzzpeqa7IUF5TSeIz4RUMcZp7xbSVc0o=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq6n/F6EDZbzsbaVPLjMR9sGnRAbDjC1Ciq/AWa
 k9NfuYfEceJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCaup/xQAKCRC7dyhM23N6
 3lCsEACbXM9A4HxMiLl0Hu2iZsdE1Zmu0oXPj7p9V/8TudGtpt1T3tZNzMqRg6mcMoIdIXCEIg2
 JGGNbNtFurmX2M5+0ioNMR5zbXreBE6AuMkYyEhsz9mLhC6GBjKjgPj2jwt+KnOABcJebeqvRKd
 y4Ya+Yp8Es0cpw17FEDkCzUKbK3//D/WIsWKUn6UM7hucv2w/fAkxpXo5BN543+YBaI8xkMMVRn
 n2g2UW/55sOqpWCgyLP5hKC7O0nH80i67ccDx51adPqeWorKXdA8tAiJGEPA1HvKWrQDq1M5XiV
 TL4ToZhvaP2cDPZOzpWQ+SgM8RR5rEbNjx9HbRyEDqVkGL4ewRKR51X3p3i1MjK/Icggu6iRZCV
 pQA4W2yUN0jd8+lNPUAiYVySmSCxilvwg6NSyXvMmni81dEPk1fNTTLz0RXPakYv7ZOo3Msi6nl
 7tFk0/DrvNUKZ0r6ofwz0pJr2y99tYr9lo1aH+1zucM2oxgldSBR4CeGzDL5Qw+ht5ewGuRtCiB
 ipQP2XasfAbUcUZS6qWGqKtqHwJTzTNR0SpjLgOb1maNy6iJzZa9Ft7S02FAM7S0MoEuYDPga+D
 8lVnnR8pCfP6Vv6S/s9t7rUIlGpD3nal/TBbtUq5aGwpDr8N80Ks9Ddzg29Xk+EE4VtpUcJ5HMk
 PbRmcH5B06b972g==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Stat-Signature: 6d94y84u8isz7puotujgwgaq7aw7pqat
X-Rspamd-Queue-Id: B62B520003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793753036-772368
X-HE-Meta: U2FsdGVkX1+F1fOZI7N0gKVz86Ro+BRpDHngbd1CxRPSvVDNpSCvKyYvU5o+WQ2U2c+WZODHN58gTKtUtlIejmVm7ueE0r/GZ0G9zMolZYMsuiywlYvZM6L7B25bUzGwXyXVbab7JzVxH68UcZmusvNUhWluIHSoZnEPFqjzi3mMRYOY3PTydMv5XGgPMr9fUUR9qkLrvCCEeoNpwyisA8T6MgPNvFFHZhkVeZrn/EO1ZDi5wuNcN+i1mnSiSDmaLT/vhvhd+JdqgjjuQSAjMAK3feIJhCfFCym6OJuQ0VnujT7Iwp7x3jSO6zNFH0Xo1gNqkMft1NsJS6kLzCinAUN5phbmEB3OfjtzUD+9tlZ9/x4Q/U4pys3n2BePcLGocmUz/Gws8kEpoNwIEKVwCenJW9HsNutHSG0H5KqCy58pM5MDNX5nNwzlXwHiKU3BV0mOSmCY1RYdgdNCBYTR27bphKUtdsXzWlKDVvhip0+mEakScgc9Ya4s3+mWc9vUXwrdDg2X3yvHJjrTpUXqq6lI5251uelz58KBC0ztRpYijX2gjGhx4b6sGFOUUPSZzGeh+aqG7g3YDotb/qLFMG332OP8YVzYxeA+3Ff5PVg81THexBIQj++A+jexxVTwshYYbAiOeZnU0GSCW2xAcHGOf25OSoG/ui+XzvJ2PeY3vYHphpifZ/bg2EwO0nMJ09DMekXPhyTSRdsctfyEZZF3bMP/HARQec1L/WsNAro12oz2o/jktZa9FrexoMQJ/G4T/g9O1rto3wTaSGpfLmGI02S5ewbqnYQPJEZJ+eRNi0i/X3CQ/s8aMjLtwqUKY4I6mWhG4m711MWBJXv2kbZqmZ3lXg56uKZjeYp39mTeDl2s5OTgq9vKgLoZAIT0oHG/skwYWBvgpdUpg9NomaDz+ozXmKgJqiAPdqX4gtx+EtaTtWhUROjwUMCJ6I9uy6AUxSuBN5na8ncpcCV
 0a5uhmMl
 tcTI4G18E5MkEYlD4ZZYBco6sPSyz/fAJYqXIWU3Dx9qSSzeZT3fnTU/McLbqvUXhl24/DsbPxW3yCDajs8GjSGVLzm1Yp+ReI1VHyp9T7Y/XVY1iqGFuimUHYYNsQ9oqTvyjDEdrV3Osm3lQRlWFyf1PINccFUG5vcdkhxpL7gEuC/xGxy29QYWOhnQkVTfvskeAdr6E0YRr3M2WsEiWjqtQch5bxOVUxip7ek9RKpszW7Q8hmMt82NN7tT5wsEP7aqC8LqmgeJr9yuJdDL0kr0QLRuVrLs1kRVWa9yKsyQyJjg2yo0q8KYqO0BsoamsVU7RhOLPwcym1sdDrmgFiDSmVvXf0MgkCVaFVY6AECOPW7uaE6m7hyGt4LlGMzINeE8isEMsJ7NfnY2j8Je0JUPvNrTImT7IS3ihbGLLIMkbOnRpU83JMPGhlvhEt+sn2WdiDhn+LurxaQw3EPcwCM+nWcXFbNmN2GMcbQXTH6utmRb6eg07ZdUwfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Allow userspace to pass O_RDONLY in struct liveupdate_shmem_retrieve_arg
> to retrieve a tmpfs file read-only.
> 
> open() requires write access for O_TMPFILE, so create the file writable
> like before, then reopen it read-only with dentry_open() using the flags
> of the writable file, which file_open_root() normalized, and drop the
> writable file. Like open(), which grants the requested access to a new
> file regardless of its mode, don't check permission for the read-only
> open.
> 
> Retrieving a file read-only allows a restored binary to be executed
> before the session is finished. LUO keeps the retrieved file open until
> then, and executing a binary that is open for writing fails with
> -ETXTBSY. Being able to execute restored binaries right away matters
> when they are needed to finish restoring the system, e.g. to bring up
> the services that retrieve and finish the remaining sessions.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Link: https://patch.msgid.link/20261103010216.3447716-10-dmatlack@google.com

Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha


