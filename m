Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 192D7606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 14:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=A6Tk98HQ
Received: by kanga.kvack.org (Postfix)
	id 241E06B05B1; Mon, 26 Oct 2026 10:04:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F2706B05B2; Mon, 26 Oct 2026 10:04:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1BD6B05B4; Mon, 26 Oct 2026 10:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D91246B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:04:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67BD01A0747
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:04:29 +0000 (UTC)
X-FDA: 85364947458.02.5EC8C3E
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1B20F20009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:04:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=A6Tk98HQ;
	spf=pass (imf31.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.182 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793023467;
	b=ku+3w5ASXpElBtQpcIJTPRip26CeZKS6K6INg+SiA1SaBY65HmhDjPhKIgUiLqAJW2ActX
	2cbJ/ZybJn129PL116o56AHQM9V8B0FU8ILgrDBmxBf6rIb8887mIY/yDXFmbPhLh5I+3O
	qAD6yVvfQTmMdgsUuLTCm+dDHwb5lbc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=A6Tk98HQ;
	spf=pass (imf31.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.182 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793023467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+j+27jHK6eH0bRZGv1MwMG7TaEjdMoEo1o6LdZHQ6Ew=;
	b=66mJAYZBg7n/fbV1hrUlQQNMXP2RPO85O/k6EaBuBJ6X+qG1SZqfUY0fm2fk7t6HgvOjOo
	PS/Q4LGNMiMk7rQKE9WnzXc44dkD/L8ZTqMqqlQ8A3KRwy1Bw8J1smHaoT0uiTR00vvV5O
	gLn//V7Tu9k39LWyGfF8UUPYljBy1bA=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e9995ce866so28027295ad.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793023466; x=1793628266; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+j+27jHK6eH0bRZGv1MwMG7TaEjdMoEo1o6LdZHQ6Ew=;
        b=A6Tk98HQfVqD5eX2+X9tBRqBqw1oGCYGzyY544fPKCfTeLQKjlKV18poEBJB2q3S3y
         6kOjx5Vmq2tBjlkWnF4Ec0p3G3j5upe/odzEBW+Xik60xjWHksAlN/KUIw8k52skIpZT
         cgT5uHOSwdJ15hH156TbpDr6z70PAlQkJpJ4g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793023466; x=1793628266;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+j+27jHK6eH0bRZGv1MwMG7TaEjdMoEo1o6LdZHQ6Ew=;
        b=IEVt1mUFg8oAY/sMdkBkjJNOWyZKmPCVZIc3+42O92nRApK79vrbt5fO3uzIerAccA
         u5ePRDtHCmRzjE+rwf6Oobnm0t2fprZTJU77AO1MxeOINHn6QKodULfH/vl4aMgaAscE
         Qzg4rVYa4+OZjxly70pHkkgwEZ8T7cbUK6Xvyj2772YTPtDZJ/ZT/+qzPkLF6XhaHwWG
         v8ryQZmi7fPvQ6xFuPZP4Ns/Z3vWIb3neaCZBaW3eEKHsrZom+kGkD1ajV5qXWmA7Lnt
         9FR4gqKO3noKAO99UpmZ5Vqc+gRAUhLp7fvF9N8IVpWb1LeexUHkBxOST4C549li9ewx
         rGIg==
X-Forwarded-Encrypted: i=1; AKwUvBx3hP9YOfSZGSibwQXCyugq7bVfsw5tfyujG9zuJ9Z3/BLt6gpQPot1oL9mRVHOr4i5AYHKQUrYRQ==@kvack.org
X-Gm-Message-State: AFq9FYKn5ld/h8aRJdM72kRchRndie+BkZQxkMBEHj84y5Th/icjLEQt
	UAGn7S6AhinkaMv3WmSJ2m/PuIAzkkbU15dR2zWj0ROcbyuoVY8rgF+ZT3nXRZ2ouYc=
X-Gm-Gg: AYBFou2BKxHVp3idZJ3VznUMGzxJP+FiQhMVrBt/S7735YhJfMHqMGppaASsFoi7ssL
	1fUuE71CKDaFSSSrbUVcmmu6oQzqL+glz3Ugrz4g9+M8AFRBMsgZ3kXlWfkzLqfqyv+3pxzx1p6
	BlI91NPCfMsE6Aq9+WLGeHlNnATZhj/69af5HZzS1wrpTLf+sCQAaJ3De1DZvtoeHpSo0vVJqpP
	aY1VeAxqlmm4jHl5MgLiqUZhqXXYoGt07HF/rbD3saC3IAd8EJLT3j3JcCef+shEHEqLWg4tsDj
	IG9uazvXQKkHphLRhfBn1xTVsVhVjZe8smOR6rDefdus3n3aZsKgcq8e1K/3toVieEf31/aLKrG
	SXH2x3DN7KhZg1i0T139uU6W7N6HILLRpPfLq4yONyLHU6v1XOiLwcez7ZnuaOIM4WGqHHDNshg
	Zk5RYTR1gkIM1mR61zN7QW7AHvH2yboBNyzVsv0vHk45nRvd4BmtL0CUMjpoJ9t68Rj/cDezezt
	WLMioo5RDyORpt2RKPqC7FGjX8xZGKMkZitBhKyip45DI20vWxdMAlVixEcQkYOWaE30j/uSNfO
	xhVBgGEYIhJ82B1iiYNG2OeAuH5SkVWSdgTuR3I9P7xwc4aTfBK6LncfXmJMtAXDlSMJnnQO2hJ
	/X7dCfZSC9rKp8YyBa6dtsJE=
X-Received: by 2002:a17:902:db0f:b0:2e8:4066:d247 with SMTP id d9443c01a7336-2ea9c697792mr62884475ad.33.1793023466139;
        Mon, 26 Oct 2026 07:04:26 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea9b1a748csm17270035ad.55.2026.10.26.07.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 07:04:25 -0700 (PDT)
Date: Mon, 26 Oct 2026 22:04:22 +0800
From: Chris Down <chris@chrisdown.name>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Kelley Nielsen <kelleynnn@gmail.com>,
	Vineeth Pillai <vineeth@bitbyteword.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: Make swapoff interruptible when unusing mms/shmem
Message-ID: <at9d5rD-15wXXiK8@chrisdown.name>
References: <ar2YlFYjYUZ49ZA5@chrisdown.name>
 <b1aaff8f-c4b1-4c2c-939e-7051e7f9b6b8@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b1aaff8f-c4b1-4c2c-939e-7051e7f9b6b8@linux.alibaba.com>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B20F20009
X-Stat-Signature: theujpy37qqho5dnoideid85k9pdsugy
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793023467-29900
X-HE-Meta: U2FsdGVkX1+ksehiqm3q+gW1O02/JJDktTsPlIyKWdM5eIBrtrLEDn3N0vRxEmQBoNAKuLxat6ANPIBIVg8w3V0aplWznq1Q6COL+ba68A5IeJkOSwFJxlBdeTT1MiQdFXfY3fGthhqt5+1ARinkFF8jemYQ9WvpvQuDtpqVLd2BQZ+QQZmw2kBuf3CEWUsvwNPHvzgu8OjqIAx4yixpXN+7TpcnhbvuazXtJG+PNAdONWKVOkoj725GoY7FX0RdvXt3jFBuLXoLbn32Q9Lju5EZZvTNnndn83tmS4YddwjiCEAzaqWbFzJzuu1HLDPkQKwQC7oWSqFc9YZz/LIo9xzmNgqyzYUX1JM5sDSYNba1xy+jYeexxo1V0w+gIb9jxlodMTH9o0ZNOLs8vYKkG59O2rwcNH3QAYcmPf6Ocp5iPREL7e3y/fhjJ7/UpC/PskrOBtGi1ho8nfH1+5U17bX71RDm/kkXmruL+8fHiNhVAyo0TDho+nEcBD2SQn0lAWgqXhn1fz/rxld+3yHAbca9iwdOicoRmc3fuQ7slvBPSil74St3adS4BCSd9Mxn3aMI8MgECCqq1xsnXh/9Eb5eYqEmJF7bza50cJJypzdTRmZQIcRIFpeUUQKHPun9sgyW6TUR2ywUt0iuY7zOyH/2N01GWNdQVAlQ91wgTsKZutp0/PN2FWwagZxuAK1QKzTiXtdsDca7xABRSQkLcc6dSpaxAhr1pO8ZSeSLZzC52L9h9JwnQ+FoYqvEl+TC8Mia/BtlWGEgI7/711OtZOzx/CMx9vw04Cgwm0fL6DPgHtc64vKIbxM4fm2CwECAA3j9jIGo761CkYP0z+/Fus6DWRtFAUzW1UbgUNV+2awSL/SjKEMFFAUfT6R3oSozwqkWncIgOBBVuuiuL4QT+4a0E6ZvTB1oc1omYoDrOmLBlmsVEXug6nT5x3EQtIn86m2509DU4OtTISd4qXs
 us83tkSy
 XJqnvBZLjfZpMxsWcs/omuSG9tzFRTKQ+nhlxq2B5NVoo8aD0wXiUhWAH+n5bp0nRMghotjovC3cUqbP2c2ylHhalzxxFrGxPoPYQWNuw+z38ijEjFLzMy6ik4Q6q+YwHN93mzcvctGVn82N9bE6ZRCRWoVPs/KhqG7oJO0h22dHGU77DuZF9/+oc/a0Zk4zIdsU7NSlAfy57ciNf9jEngtLRzIMF9nmvSpRg1hhwxDdxet8F5q+GPaTSkP8+6uV5cJc79qhWrykh7qrkaPBOzv3jc6ESQsdtFhKAz2S8bIreN9kh8PsCKeXjNnPnogX6w9whWXcQdITt+PiQakta1RTrNm4IlcRmhSIAXYaAcVuupcDoG02kDR//uTXB/6JuqtUC/QXqy3jYmSImOxU6Hr6JgbXtPluNSuZQSXxN3xpZ9k2cVvHfihSU56vAsiXp1fTALRwwmG42ZX+jnYUjiBKkimAxHhVvQ4dapktmFqufBNhEPNa19nhoPaDOvVHJVJwWoLP4HGY+LA1WIynDL9L0A1TvmzlMLqZw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Baolin, Andrew,

Sorry, I missed this.

Yes, I think -ERESTARTSYS is appropriate here. I used -EINTR to match the 
existing signal exit in try_to_unuse(), but that also means a freezer induced 
interruption becomes visible to userspace after thaw. Let me use ERESTARTSYS 
instead.

Re: Andrew's earlier questions: before b56a2d8af914, try_to_unuse() checked for 
signals between swap entries, rather than after walking an entire mm.  
Individual I/O waits can still delay it but certainly it's a lot better than 
this situation.

So yes, I think this probably warrants a stable backport given the suspend 
timeout is reproducible and it's a reasonable usability regression even though 
it has been present for a long time. I'll add Cc: stable for v2.

Thanks!

