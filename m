Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 126C5CCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 05:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCC788E0003; Thu,  6 Nov 2025 00:35:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7D468E0002; Thu,  6 Nov 2025 00:35:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B928E8E0003; Thu,  6 Nov 2025 00:35:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A97928E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 00:35:21 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3EF9688EEF
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 05:35:21 +0000 (UTC)
X-FDA: 84079069242.22.9DCEF4A
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id 41F8914000B
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 05:35:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RcBTMD6l;
	spf=pass (imf09.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762407319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xqu+odkC5y2EUQD3P72UD8nqz7ztmWCfwzT6Wx3nK2g=;
	b=jRmGSD7KYpMKyVFn9YY+3G6N17jYFhSiIzyV29top0HCYelekxeHnn18ml4+A+rL5ayvPx
	i/J80Soegazz2KGea0Kfn3ZOuSnG9WA2wYiI4HbxtuZkN8qJIE0oaTf7AVb7UDzO7DQFmg
	/F9wEANF38GlUOAtBlEoT9emoPIf3bo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762407319; a=rsa-sha256;
	cv=none;
	b=WL2vLYmHahthurKxIimbxyxIGaMDxCqYE115OBT5nEQpZXi8lpWBva3lvLWqrTNRGPbNDy
	Y/mjB8dFwAgJteHuxhrwYNRQibc7Dvo9hikpWYr/tDrufQKWvEUKJ4gHVq8qv6V2PWV9Bh
	8h5cNgdWl4cm+fgCcZXu+VOwht6ed18=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RcBTMD6l;
	spf=pass (imf09.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so580265b3a.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 21:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762407318; x=1763012118; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xqu+odkC5y2EUQD3P72UD8nqz7ztmWCfwzT6Wx3nK2g=;
        b=RcBTMD6lZPlF0etcdOuQbaEg5n1bZMmL1jUzLBtHKLavmNQDu7DnmBDFVOzzarMk4w
         lla88IF+kZoKkHuSPmm0nqj28mKKUfm4TKcI77g6qV5ey+/YqqoQzhwxOQIXIFRTLr6t
         zv5GiSN8c28H+1CH2ZooxRZ5QS/XSGZ3rKFLsksIR8eld0u3NLq0TrELR0GkAwkUxLFY
         KElybg86yOIIdqdqt4ll9y7bna3IZGJ+u1CTHnBUFzk7fXXPI5keDJC9DlZSa/XlQFh6
         Pt/7CGsfMCi6HHmlxH/qEortza5As/N742lrAhaE4UinAq2uMy2xFOLxl+TMQb+YOMFh
         CJgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762407318; x=1763012118;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xqu+odkC5y2EUQD3P72UD8nqz7ztmWCfwzT6Wx3nK2g=;
        b=rFAaaugzuKFarQSfJKhuvork/FtXgdGD0AXJiYBXwb8vhweEZpSEqmDJnI22wNN14E
         GA74HdPuQn7Ji/nDAL5onFtuiri8FsdCYSbtlKbwqZFuDW9ZVLfYrTLrCSN37PWVtjpV
         G+GkscsUcHdMRTHMEQTHW8juHWPkam0AE7znFxnDn8ILslUsk7I47PI8cd11VEVEtfmM
         VwhvawUFQbqbJzBmhHs7u2/1K4jQPuVoV2TvzFjUgN0x30ygLFgB3b773yxc9Rgqm+cL
         HfKwGmM5aorrZfiW2XDiZSv3+iMBgTEPxvPIKdDIRf+zo+bWRLZeiK+pQ2a8K9poaBxa
         RTaA==
X-Forwarded-Encrypted: i=1; AJvYcCU41JsuuoN3vfAVkm5MJnhuezGOwQyZEOySs5PamSDMzFkL63vRP2m0l05AmLrrBA7JXvyQ56RSmA==@kvack.org
X-Gm-Message-State: AOJu0Yx0ON8CMvMjTLxhTjTQ/HWzxJ6DoZzwPyiVoWD41bY32PTQ7F9g
	JhskdQQSAYHHOt9JeQVnR56EpVtHKV2frUKnrZ1C3F+qx+5tO7ri94Kz
X-Gm-Gg: ASbGncunMxf8nXRQ9Rhwq1o8PxmUySZadhk5sTX3hnfN06ynUG5NZmjJUKZK14EEWfY
	ajUbpZ6sAB+PWyvmfcSRqxwJzoVHO7g00lq9/HTF62hp5fkt7apOs9JNyLYTq34JmPgLumxO8Pr
	1KPvHhItgsX2BtUTrIhx0QTTH3/qaCtVZMyKWMREoZMXm4SxfHlGS/dpKJ3Tho3CYIs1rWmC+os
	sLjL1lYubh+follOPAm7WIr3OG9fw00kbSOmq4K6EKU2pLdN+itYGShyyQ8dNxfez+dEzXdjwvf
	DCr3gppINST46QospAhdijuAeKCs8LE/5ea4T9XRpuErEeHWDOq4KisPuPuUhwOu8oOOCQdsGDh
	4qqQ5vSwlKfugg0A99DA8clFhLy/3SbB6upBVzprQOqlCw7GoFhZ0ShzRMgJzQTpKV7Ils76q7G
	6MKkACtOulvy7L1YwcjWzv
X-Google-Smtp-Source: AGHT+IHdEFv9Zor3bc4Bu4OwuhNr0f57kycevNnexdIDViJx433B1mm7bsY0xFtLkvh/PAGC6U94nQ==
X-Received: by 2002:a05:6a00:1818:b0:7a9:7887:f0fa with SMTP id d2e1a72fcca58-7af6f5e1aebmr2587605b3a.1.1762407317929;
        Wed, 05 Nov 2025 21:35:17 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7af82af1907sm1290495b3a.62.2025.11.05.21.35.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 21:35:17 -0800 (PST)
Message-ID: <c704e7d9-5bc9-43e6-98cf-d28c592b0f3b@gmail.com>
Date: Wed, 5 Nov 2025 21:35:14 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2] mm/memcontrol: Flush stats when write stat file
To: Leon Huang Fu <leon.huangfu@shopee.com>, shakeel.butt@linux.dev
Cc: akpm@linux-foundation.org, cgroups@vger.kernel.org, corbet@lwn.net,
 hannes@cmpxchg.org, jack@suse.cz, joel.granados@kernel.org,
 kyle.meyer@hpe.com, lance.yang@linux.dev, laoar.shao@gmail.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mclapinski@google.com, mhocko@kernel.org, muchun.song@linux.dev,
 roman.gushchin@linux.dev, yosry.ahmed@linux.dev
References: <6kh6hle2xp75hrtikasequ7qvfyginz7pyttltx6pkli26iir5@oqjmglatjg22>
 <20251106033045.41607-1-leon.huangfu@shopee.com>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <20251106033045.41607-1-leon.huangfu@shopee.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 41F8914000B
X-Stat-Signature: e6mnknsft395k8kssptwonaruwwo9gac
X-HE-Tag: 1762407319-432311
X-HE-Meta: U2FsdGVkX1+Pm9XdbWmByS0zFW/OmvCYJOxN2ON88AacbIZuI3DpmmMvVczaXSPHARk+CtZmlcOL+T1Ie8cLHnbs32AETQwQgtrzntx8QXvfk3HPCLDbFcD98BOGH6lllFPE637MApXzEXbSfiysjJpOseoTcD9WWs+DsYSMXjLqa/PThugy58aBQDMvPnVW0c7KL9fCxCv7p1Gn2dCkODrqCZ5JlAgkeT2fX8eLrItmrufIfouRTFnzp56neCceqvX1BsBkJnLL0KdA2nsz4ovtoOExbxr3Sqb9uhS7HmpAKd9vo4EWmPEIn9XQPS3ZdGoM0vwWnSOEy5mg40ogQFrysfzlL7YqydIQnuZzZjQoJAhp3Q7AyuVIaEVEBiyL9lMnEN7n69xh1kqwlEWzMBWREZ5j2uPZNjL4GRqT3cJSdGugw978rDZqiE42hHR9ZhP/JhtufrUrS94E3KiRoAPjfhrII+PdCPzabmA46ua2ixnDR+vX5j4awnnKCpqudsj0BPhH68kmb7Wawu7WTcTWfC7VavXl927oG2JHEcoaENgkvboNkhJpr5W0hqPE7osiwLEWHBgju3ofkIQd5fAEtyCjjwoULLCLfwko+TDu6jC86X+vCqk0hmN/G2SnYi768T6PEA4gCye+Jvd/4Q4gaNQkSPqge/Enfu4QZ/zN/iQMCzGwdsnt4F9SCZCvnikwlXh6Y4Elpp6l5/2xorl+N9LekYpUPYojCWfolt20yOhd5NXOnpN5McfxKvxcY/1m076pQnTbNRPXXzHKaJ//+xk7rXBtjRcI3N2dLLtwT79nFr0QsstdWyXR5muhAR+PELGmT6EZ4LQ3C3CQy3E++YKVsZ6xo8XigLQQyo25PEPctF2c/rOOzdpesdtujlQv52ZXSf1OQG0g7pvvxmOKb6FKVq2jCtK4DZFgc0ecXDVZcLGS0qdRSlho3n0ICvNiuVmAZ5NnN0Z8u2k
 ggEzfPzw
 LAVtwlUt1kftpkfb6+iczHEa0gomEFeJKjOuwdB9je+j2bRrK4vJZ8uEQ6kBNk0oxIBoNHbpqj7Hb6i0KJb1bDfzTNWpk37uvff572R0edjSAIXZ++V5hLDYJKngf9ui3prROtrvqE7VZM9QVNvgT6XcAj059yM+8Fp2+uE8g8gmjjYVIKYvonM9cegNLcOADJdSM6FGzecuU5YDfIrkFAB6jnCnYSZ2O51ay8DvBXdOyGmt39+UzcQ5awy4b06SZxCjQ6VESzed6ttc2kyJSIB/0dcPlvXQZTGZ5qH7r2K4veIj16G0KB0JVbgTRWPeHpqs/UOauz5W7rUNc0SYWz8YhOVuc27CP4uccWtFJYsPXJRT2amtGI0R0BoWuuyWoPZAn9n8F/QnlDtHZ3paOviCaVunkSYhAJRc4BM0i09uMIZA943bOc9aB9o+Ppnk4FDFF3cy1qO3NE4Ya2wcUeal+ywRSx1Wj6IB1QLZFKOkqeGgB0DXTGc5J3g0oxMQYQqYK9nX+UWuSWx0Y3xgEI/dZ9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/5/25 7:30 PM, Leon Huang Fu wrote:
> On Thu, Nov 6, 2025 at 9:19 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
>>
>> +Yosry, JP
>>
>> On Wed, Nov 05, 2025 at 03:49:16PM +0800, Leon Huang Fu wrote:
>>> On high-core count systems, memory cgroup statistics can become stale
>>> due to per-CPU caching and deferred aggregation. Monitoring tools and
>>> management applications sometimes need guaranteed up-to-date statistics
>>> at specific points in time to make accurate decisions.
>>
>> Can you explain a bit more on your environment where you are seeing
>> stale stats? More specifically, how often the management applications
>> are reading the memcg stats and if these applications are reading memcg
>> stats for each nodes of the cgroup tree.
>>
>> We force flush all the memcg stats at root level every 2 seconds but it
>> seems like that is not enough for your case. I am fine with an explicit
>> way for users to flush the memcg stats. In that way only users who want
>> to has to pay for the flush cost.
>>
> 
> Thanks for the feedback. I encountered this issue while running the LTP
> memcontrol02 test case [1] on a 256-core server with the 6.6.y kernel on XFS,
> where it consistently failed.
> 
> I was aware that Yosry had improved the memory statistics refresh mechanism
> in "mm: memcg: subtree stats flushing and thresholds" [2], so I attempted to
> backport that patchset to 6.6.y [3]. However, even on the 6.15.0-061500-generic
> kernel with those improvements, the test still fails intermittently on XFS.
> 

I'm not against this change, but it might be worth testing on a 6.16 or
later kernel. There were some changes that could affect your
measurements. One is that flushing was isolated to individual subsystems
[0] and the other is that updating stats became lockless [1].

[0] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/kernel/cgroup/rstat.c?h=v6.18-rc4&id=5da3bfa029d6809e192d112f39fca4dbe0137aaf
[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/kernel/cgroup/rstat.c?h=v6.18-rc4&id=36df6e3dbd7e7b074e55fec080012184e2fa3a46

