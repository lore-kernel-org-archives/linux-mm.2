Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF4C1606A327
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QyAc7lHe
Received: by kanga.kvack.org (Postfix)
	id 11AF66B09BF; Wed, 25 Nov 2026 06:34:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2CD6B09C2; Wed, 25 Nov 2026 06:34:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23EC6B09C4; Wed, 25 Nov 2026 06:34:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C4C936B09BF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:34:39 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 443BFC0DB8
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:34:39 +0000 (UTC)
X-FDA: 85473433878.17.101EA89
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4F5E818000D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:34:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QyAc7lHe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795606477;
	b=tx/OyezXPt0C5Gg/cihFXv7dq3edEDlF7n4Jmiskl8DN5t/IjFLpKXJiXuP6vbv2pXZpF0
	3L4Gfogu+EGtGAdPoscMmoNx9dn0mVxWdtndiSTljsE38OxPhZaSjPponWGMcppTDJk7iQ
	Rm8MfvKe9fMuGLclYCB4w3f0OUk2BUk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795606477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=au+aUwkr58kHsbNGWzHntkHpOI9D5jL8SiuAtxwKygc=;
	b=B8Bv/ALvCOXuMWh7IxwWsbmHUqIGi1b80Y16nbLsIERrxvf2x4iQVoHcWTqbMxVkJrIl83
	8gqM9qYr9ETKILDjv7T0R5fYdpeWtlCwrA0i8Lf1TkCiQkP6wfY9IQGvTSpWJna8nAeGuv
	WiAo4oyI5+zEtRZ/ySXFzh++5qQsHfk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QyAc7lHe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4bb6886d30aso53782255e9.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795606476; x=1796211276; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=au+aUwkr58kHsbNGWzHntkHpOI9D5jL8SiuAtxwKygc=;
        b=QyAc7lHeLVJApL2aidn2Q1NSIKYrqDFR3giQddSsZY0GJdaroC4HUTlx923SveFcLo
         B8ulQFaDCD1K6xhnC/MGzGHHXw2wZsE5dmXdoqnIufjOBNLgIXOvhmm+ePBtdCmbHEDH
         1h0dYkG18megajCwoT+7XgVO1kQrLGFM/yCc/7IyelwdHIFVcdFIf7oUbb2WKyphlJkv
         omp3ajACVj8noDooOeS5y/TopKuRqSJH5CJsJ0d0pv+0Hbm/YitiJi7or2bRnvKD4L8X
         c+GbumzD7e+PUt9QIv9ZpU+3JRmYjSIzWJzwoBUU1rOYLwt5mb66FvJVSGrulILz1Ss9
         ZZHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795606476; x=1796211276;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=au+aUwkr58kHsbNGWzHntkHpOI9D5jL8SiuAtxwKygc=;
        b=XgsSRtimMm8RchrXFlvYvsYhQg5sUmAC7akJDDBP7y/QuWSUMB8yFz+tFNpQTzOW5i
         EE1we4+HA1GcrEYaBYbQ84xoINvHiawFjzkB1udBMRXeFXWk/seRSmEbmijRl7583ehu
         LLNanNTjIJKgFPqAWntIODoxA2yx1cBh1BArq1i27I2pEgjMZjl9Pt2clJYJtdFEgbHd
         StWPyHZ6cLnf/9oNleblU7HmWU34cJgiJOBAlVWEynWa508edm0Mwcgpt9eaV5bUFufo
         riNXQbuo2YItrRVNP2ocvNxonf2biWnMpQgEgqFbAcHHcW/FYfPicLfrj+dlYipBpmrJ
         fJ/A==
X-Forwarded-Encrypted: i=1; AL+hErEK/IJdp/Y78eOK+5sKb73Jq0TLpnjkJKVYEJaocFeuqJvkdoM5VbuvQjbRVlivUz3/rCZF9sfzQQ==@kvack.org
X-Gm-Message-State: APuU4Z/4+xbk8PX3UIAlw1vri3wdWbYep2p8UTzRYXvCW2XPY0LgP3rS
	aYVCTHzgT3uq6tIhCwpLalY6jXB7T9V3aecjjBlfY0g1hJeQqBYBLw+B
X-Gm-Gg: AZFdTZfSqZ9fIeGp2pANyZzU2HZIonAVVphisFX6pw8TXemBEg0VvQXWPMuUbgywRBK
	NtkUf65rc7wXnFiOzh6fKutZIdFbTvsVZZw+ZEcVxjbLonc+7AIMdBqrM2+WkXJNSvygyjzGIB3
	HApofhbNeq6W65//lI9I4yT7XWAon7DUn/FOdzTER+mNEug9n7cfFtJw5nITOs0SZ6SJ/rB9fGU
	/dCbqWepxzdiTfPWLeehfSBVWfpmqu8l8kYwmlLPc/BJux0OILdwOo55sax18LVwtIPk7udf9dY
	gA6+nKVxX3jUtjqKEQ/HFE7gCPxh2sOw3+rlgX6eoCXfG5Nq83kQs5XPNpYzo7ub+Q2lZZDzBkV
	ERDl6IV46G5fGJvHI0tIWJe527uR0sYcIknPB14ZQxTEN+vUJhiKDZgigESSq+wmuKPkb8hvXBz
	rIQi1Ck0ScrcvG253C7AR7PB7Z4vEUAPK1/pAwGy7Zku8OwzOADTZVTbu/14eQpFwRLWQ7vdg+s
	9p5q0mdIo8LQpQO9LAYO4dOX60K6yzvw3Kda6lgTaZCECZPHwDF7woeI1Xqt1odryP/l6DLtD47
	2ZzV+iw563+Fz3TV+DNYrnc3
X-Received: by 2002:a05:600c:64c7:b0:4bb:68b9:f610 with SMTP id 5b1f17b1804b1-4bb887ffee2mr340117785e9.9.1795606475753;
        Wed, 25 Nov 2026 03:34:35 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a9687sm572512745e9.10.2026.11.25.03.34.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 03:34:35 -0800 (PST)
Message-ID: <286006b1-9f9e-4661-bd38-e5f5fce9646b@gmail.com>
Date: Wed, 25 Nov 2026 12:34:33 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm/khugepaged: use NOFS while collapse_file() holds
 folio locks
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Zach O'Keefe <zokeefe@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Hugh Dickins <hughd@google.com>, Kiryl Shutsemau <kas@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
 Song Liu <songliubraving@fb.com>
Cc: "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <20261125100058.15200-1-azpijr@gmail.com>
 <20261125100058.15200-5-azpijr@gmail.com>
 <8c60bed8-6857-4361-91b5-c8fed8a083c3@kernel.org>
 <66fd4450-6e17-4a1c-be76-38758a62073a@gmail.com>
 <413a7751-a368-42fd-8983-c3b44a86fd0c@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <413a7751-a368-42fd-8983-c3b44a86fd0c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4F5E818000D
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: d88asrcmjxucfaapegey4b6asm4afbfd
X-HE-Tag: 1795606477-103246
X-HE-Meta: U2FsdGVkX18JVNN+SYAuC6zY5MqaA5bmc9ClGL+jqAuTofyD/6YG4hkv+q4xpwiWr11npRJ4ZwN8EgSNtQZ1MSmmyEcrVdrcb9Dqhek6k641Ab8lGrQfy2+vz42gBUeZrwnUNTRPfflpnaMoFw8Jh3MVGs9vj9PZkL6qGas50ZOu4zOkZtkukSfNiUgCHK0aao/HXhaZLebSXOyTpA9RdQhtALdCNbq7sR92oiNZI0gpJvMwu6VjyQC4Qpu+T4Op6ncnejbfPubnPe/eYiFGCV9amsO3vMqpDhsHPfb1f3quD8RI0U/5dViYiw+sDvC4hgJDwHgA/ipfCDxEnKGjfdzpeZXIiK7+IzBPsi3f4/MoLNZlSakgGN5jbUCGDVpLEB+QjIYmipmxb/0HG/00s72RpiSBlnEkcFdV8hMKhIOQfgGf+fDauMm9blOg22m3UYFBny88uaB2tcL9Pz+ZAVZYiO6K0oopM8AXYsoAe5N0JULQ/b3WKPzyuC1RBPBDHeYmEkwUP25ks2aJM6P1DWWfeXOuFe4USmI+40hg8fPYDUw1MQhH1jsKSdsT6dqcugBubLhMsPAX8jyq8DLaKzaMcgdWuDsOMVqdOEtMZ6zFPu5ZmLIrTVqXrqUy/CiwLBWN4x3+Acmc+zfHweI6Ozf2FDW2Q5m+b9E9Xte1QsHKMaq3ZzK/qsA6gyjbY4a60Sbl2FkNGxPgysCr/IeN7ZKXE1Qg+5vBPiC+oZYJhXopEx6r4uKDNMHB7qjN5kDN72b611XAtoXlbRM2XYi5SitBPZo62A2PCsc2ZoLKln7aAARAGBRyc+bCi0qvonBz5hMuP3gmv99GuZSlAX/EBZWa8f8LYk5rWDUHAu/TOlW0ZB8aJJtek5eLyKqvn6HaWlgsItyfcbbAcKmYFCt3k6dKJSt8D5wwt2lkjgJhzusgekSN/froIO7K6YtCjCIoWWj0mfGYrbLgdHU3dJy
 BbskNnkT
 9YcqPpzwWddfg6YykeW7EGRC5ahfFo3GYs8cLXd+oOp4GasX424SnPCko4g6Hu4BPQQU4u7xiy71O82IcjbjoBQwo/r4HBc6rBpt3Xitav70lbskrV49MACNKIL5BcmBsLkhg5yltC2EWecLO8u37b1A4Zv3Wl6JjehyxYZ0jMUEasN09easW1joY2uhzvuBs5DFZKww1djOWCJbtIHFaEnL+8EJeO/SLBDXMkiYJPfpiuCowVauTuTg+YGLmmBgRR9AZmoticdYz22bmdc+AlxCUoo4zwT41qIJdapzBwRjkyAdkgd3lg2iBQ+m5V6jWRTcK4ti+3YJoSGIyRog4pzzPiJ29yD9t/ZHaDSH6RbYAW8FAhL0YVQRDzWUDIa/zEY3Vw4teHXKcJ4KnGW3NE1VsftkLVj6mHmHR2JnUG/36OtEICJyvGlJj5Imuwy7X+BTdLSsqIHfoa9bzaBqxp4Jhe/Ym2+oOu7ekKkVA4BcSavkWrHnoUkxo7b8reD8yHGk1PFHj+pHqnyPCg98K1EhGLsC27hdgqw2hyVwYyzvUBj76b3cLVZpaY82aYoEYGqIOp2Mewks/sTEL+lsG26fw/5nS9UzLt9ZqNFOKYzHYHUn+u0X0rp9BqV0YxuvsYJ3Ac9ejDQsh6tFOVGCFTyGZKGAp35kA3J18uWHZ9RJfMNNWAxGwMLtPB+E7prsHj9NJDJ4UguVkZ5tUEcc4BxMinBqmCkOlSFWlNDdRIRmrOgA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 12:15 PM, David Hildenbrand (Arm) wrote:
> On 11/25/26 12:12, Jose A. Perez de Azpillaga wrote:
>> On 11/25/26 11:55 AM, David Hildenbrand (Arm) wrote:
>>> On 11/25/26 10:59, Jose A. Perez de Azpillaga wrote:
>>>> collapse_file() keeps the folios it collapses locked until it is done.
>>>> With those locks held, it calls filemap_release_folio() with GFP_KERNEL,
>>>> and for shmem it swaps folios in with the mapping gfp, which includes
>>>> __GFP_FS.
>>>>
>>>> As when splitting folios, allocating with __GFP_FS while holding folio
>>>> locks can deadlock in direct reclaim or compaction, and __GFP_FS also
>>>> lets filemap_release_folio() wait on the filesystem.
>>> How is that possible with my fixes?
>>>
>> it isn't, sorry. I'll drop 4/4.
> So there are no other allocations in there besides the one done by splitting?

there are, the shmem swapin, but they can't deadlock.

-- 
cheers,
jose a. p-a

