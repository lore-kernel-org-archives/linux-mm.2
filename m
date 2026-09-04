Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EEDEC79F87
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AA856B0095; Fri,  4 Sep 2026 11:29:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8821D6B0096; Fri,  4 Sep 2026 11:29:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797C26B0098; Fri,  4 Sep 2026 11:29:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52F5A6B0095
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:29:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D9019160136
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:29:22 +0000 (UTC)
X-FDA: 85176463764.11.AA59BE3
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id 084281C0003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:29:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KKbgn3cM;
	spf=pass (imf21.hostedemail.com: domain of eli.billauer@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=eli.billauer@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788535761;
	b=jAf6+jSIyI68B4O6hrZDAW/i5Ut62zoNrGNviF1etd6gBb6El6x97iabPQNfdlREKviypE
	syHsVyfzVFtjNMCgVgptzMo5AwUJ3/K2vox4sE382Jv/eWEA3R1ZROJzjBY88ntnm49dJW
	c6tfp3UstaXK9T6bF1Hh/krB82pg/iI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KKbgn3cM;
	spf=pass (imf21.hostedemail.com: domain of eli.billauer@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=eli.billauer@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788535761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3s2kh4gj1DOKMjmkcbmo31+xgIaWNFlf4UB372dsWc=;
	b=h1KDI8hdMECKHeYZxIJylntsYhQOyo6yW9rpcN4ttN3O23nVo+1NgxdTYzjipKdSlKujJ2
	kAHr7+Z5Ytk3jEvfb3Kckvlq6BbArBVS//unBr8Q8iD/UhrelPv16VpaCvJuv/p0Myq5N1
	qbUi9hPEdu68oLlK9jH5OX5P8qu//Zg=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a60f0dbeccso1669247a12.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 08:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788535759; x=1789140559; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=b3s2kh4gj1DOKMjmkcbmo31+xgIaWNFlf4UB372dsWc=;
        b=KKbgn3cM3QKGU1VzrU+vaavHTATj1aMXjDwYU2rH4G4hFSU+amPop3ssC2Elh941rF
         eQi4GG/MxKFoGcdms7y/JCF6H8yDBz8ShC49VUlWsYx/O/zzCGYteC7U2iERya/+xrAe
         j7it76mcxmjvfF0LwK3au73NPnc7ro+bMjVGCykxq0cxBxT/ooQKofcEtXn4pNBcu120
         lYG6PNtgl/VMLaWpO7dai+nPZZvHRK05thW9xYemBUmUHgBIzA+n4Y+0iQSp9HUDRr4k
         E8h3gR5WAzRZEPlWR0Xu89Yn+odfKddIdK/TxUSmoiubmwoAumzZTTzKgxyrh2Pfqybh
         VgLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788535759; x=1789140559;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b3s2kh4gj1DOKMjmkcbmo31+xgIaWNFlf4UB372dsWc=;
        b=htVzj3L5dDXd94XnqpaUwG3X18gVkSfE7qKMUcRIgqprBNukguxuLEesUTdjlp/FyB
         eODFrmg7lAMovhPqPidXrAen0GuCawIrDOro4VBXRVQ8JUa6Kor0EORqNQk+Wq9dYBxZ
         s4VrHh1AaSSNJicOOgFVn0NnTSBPaaFWET19zZ5mqCtju31CxJUeMLHOUkZ5qh/eQdpd
         L1j97bQURK30VC2z+LygQIkoEcokYWVs6Seq6MAgU4jdmFL7Iuj3HHUK9UYdkB3sKHvB
         yo1/dAgtolTprZRJCLypEz0ILk6U9OiZks7T3CIvEBk01wec9+BsuwwlS9ThSlM2t5k4
         i9eA==
X-Forwarded-Encrypted: i=1; AKwUvBxFoz6jPuONJiyIC8f/A80OUffH6/rWxtI1TvNB9VJn59idjensN6Oo+zaNjE2VtFkYYymdc1hZXg==@kvack.org
X-Gm-Message-State: AFuF++l5oAr+TQVGBkAbJkeZCxy6zIUiWJPHqDu8RauQVK7fZvPhnLO4
	00WNqHLwwj5nRRX6rtj7Z0pMfO5yVpkCQNHjdRueDlQsB7wwppbEBs72
X-Gm-Gg: AYBFou19l3CRmBdatFAWVihxCzjAjBhqE0s1hK3Q5WE7iaby3KSw/FHWUZSuq/oG2rh
	AQt6lGAqGFaTPQVZGFzd/5t7X2tT41VGs4JDsHK42KVt5W7tT2Q9ybN231Dq1IRpryty5cqr2Zf
	/F5o/uyVxZksO5w77o+bSGOsmxuhB1Vku35BTw4dM3UeDYulBDEZTLxG9o7jEbNXeCG8+BimScr
	QWM58BvFeEUR1n4YU/4LFZBWjlu1lLOY0gcV3Zx+AKdhEXUjqGoXZ8fm7b56NwWpAu4x/I/uGUj
	50FqHGfFnEYQxoaiFmdeFlmTtYoXO1XbYXS3JvdrTlzSvcWM0TEI25MXH03cgzcd0PmYoBPIjOl
	TVN57BPzUVkYy/5PiE9ewk6lE9KKIJOLtCklIV+j1ivtoVaNGm98ADMT4mL0mrYYKllV+I7XQxz
	EAKYCAbFTkpOvifiUH32Se80V6VUVHxh5eHende8O8WBhC2MJptuUQ1YppgWmB2WM1X55A7CSnC
	orJwasPoiatBqBKc7fh9LY=
X-Received: by 2002:a05:6402:24d0:b0:6a7:ea54:386 with SMTP id 4fb4d7f45d1cf-6a7ea541e6cmr1470990a12.23.1788535759252;
        Fri, 04 Sep 2026 08:29:19 -0700 (PDT)
Received: from [192.168.1.89] (c-85-228-45-68.bbcust.telenor.se. [85.228.45.68])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a7e6bee8e8sm1460646a12.23.2026.09.04.08.29.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 08:29:18 -0700 (PDT)
Message-ID: <49245a34-cc56-736e-b2b4-168c2a0b1df7@outbound.gmail.com>
Date: Fri, 4 Sep 2026 17:29:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From: Eli Billauer <eli.billauer@gmail.com>
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>, Arnd Bergmann
 <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Michal Simek <michal.simek@amd.com>, Ritu Agarwal <rituagar@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
 <20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
 <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
 <20260831123937.32255a49@pumpkin> <apaF1HUtJnstuUN4@kernel.org>
 <1729fb06-6beb-f8ef-3e71-47fc3f00345d@outbound.gmail.com>
 <apcPg_y-HsMki7we@kernel.org>
 <9a3d6a08-339c-3315-cc81-46907d0836ad@outbound.gmail.com>
 <apgSCyj-h2xVc2ss@kernel.org>
 <1d7f8806-f4a0-fda0-a361-a011460ef308@outbound.gmail.com>
 <3c19c24f-5036-4bbe-b3af-e5eae102f34a@kernel.org>
Content-Language: en-US
In-Reply-To: <3c19c24f-5036-4bbe-b3af-e5eae102f34a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: gf91znrwrhdtcod7fawrnsfhc8gp8jdr
X-Rspamd-Queue-Id: 084281C0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788535760-304689
X-HE-Meta: U2FsdGVkX18nJERhuDWJWzsrV19kkw1wOvhbR/sxWKa7nIniXZF+9IWwob8cCCo68bzhPCqgpiV+wVxHE3/mfn39YCm+pwVz1o5PObWIzfezZX7OQSr7ezvyhyGUL7P1I5CaBmi1JkDucF/wxlM7uGxDOGauLPLzlaCp2dKklCodxXTjGmEpOk6Yu5t6uGFtTtHv59Agoe6TLlvvP838GzQ337CbvV+YmqQVb6iw19R6rursZ4q62kc0oJRmTzV1b+TIIWFPkx4NfqLpWdsGoRRG709hqGPlyMworNPGG5s+BMEq7qCH6Aa+U68oSE843jtyC6QObf45qimjUu652bqdss3l2GppI0i8ftCoCDYiOT6njd6YU7DjPUztZIH1u59X35XyytFLAkVXbmULYyzXdekOuw2OfiC1GGO/jVf2BCyk718S299YkNalYbohq30dXKuP2Jk3RLgaDsvslxTCCu045gCd9bdCe5hQ1cOKVeRKLTYoNHMdjtQ9FvDfgOE+E00nRtiBO4DcxxFRhB9tj91oI/lW10MjUrIawOZnyXG1iEWR5Au8/ocqZ9y6qZHBNXBZEJ6xKAk2YLAn40uFhMKWe6mDlbGYiSlB4YrBYotM7+7nPKESYuXnFiF2YU0GOINDdBc9jr31YFHvAgCj0tIqDJ96dPdYk3XQJ6HZQGPZHtVQL4WcE7QCmjkI3ZIY4Pbb/o0P7RgvqVuVdCUjYdsnQyrlSU6ug+ZruS53ayRig6uhxWWAVco06ApTWcFVPj6H4nR/yRp1FF6UgkPaF3ZHPuGcJ6HPdOQFeSD9ihUiy0HcKDYQ6scpjB0pz3M6/7jcklRg3A/9Rt0Zk2ca9V0xg09Dl4tHsG7mc0MT4MmBypYNs+dKgSzku8hSGQR4RWaLKIXJZmsnexQ11vQyomo6JZgcqzlWe8XpaQBJvzgsCcCtrcVypCAV+nq/ExXS4iUVJxCg7BqQbt4
 FjfyoZ9h
 mjUzuXj3Cg6qdXcZ3Zu20Ng0Vcx0SF3sqYFNKrm5tLPmUa3NofUTxRzNLlD39f7+8iZD3tHwd2cZTYEeLB+JvEPjARuZE0wMp9Kc7QXP6TaKViWu/zJQ6JjlvF6AgKTYW+JA6ZY5ghVfJuYHbefOVXcD1EhBlzaYwehfnD81Z0WQ1QGX4uAb7d5h5hfP1+faCkGK0Pt44IqjXWjbh26CZbPtVvovuEDCHKZ8Kt8F0LiRIEjrGn5S4y60RpHGPAQ0i8NG+jW230T6PDkbQO8hYUNp/WiB9TKV717IxGVw/pONDArYVF8I1Ztg3k1jocysNdRCFXGjPDDF2jCBsLz8CcFTYe3Jw6mIYJ8sqJXpGta5Pc28IXjzJuK9OEYBg0lpsGv0vCm5LwDsnSPBlmyvwwJn6oeCyEeYZuLGptjmg14WEQsmImSmRiKdWux21iwM6OxEeYNi8JCV5bGTPzKcdwV6LKDN/itHJcbF4zBpU1Mj0QIeoduzkOC0WqOc7tlRmNIzYLdQNDYskR5SfnsXNMAHPEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/09/2026 16:28, Vlastimil Babka (SUSE) wrote:
>> Replacing it with a kmalloc() is confusing in my opinion, and requires
>> that the reader is aware that kmalloc() falls back to __get_free_pages()
> Why? The reader has only to know that kmalloc() will provide such a buffer
> (up to sizes that the page allocator would) and whether it falls back to the
> page allocator or not is an implementation detail.

When I see __get_free_pages(), I automatically assume there is some ugly 
low-level memory management going on, which is exactly what fifo_init() 
does. kmalloc() feels like something you use more for allocating memory 
for a struct. There is no such rule, of course, but this is my 
subjective view on these two functions. As I wrote earlier, this is a 
matter of taste. Maybe it's only me thinking like that.

And as I'm not the one deciding whether this patch is applied or not, it 
doesn't matter so much what I think about this matter. I've humbly 
voiced my opinion, and that's about as much as I can do.

Regards,
    Eli

