Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C84CD2F037
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 14:29:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB65D6B0088; Tue, 27 Jan 2026 09:29:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64096B0089; Tue, 27 Jan 2026 09:29:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B456A6B008A; Tue, 27 Jan 2026 09:29:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A0B5A6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:29:06 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A3381359C3
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:29:06 +0000 (UTC)
X-FDA: 84377975892.30.47122CD
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 58826180004
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:29:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NSyrXHGb;
	spf=pass (imf16.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769524144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RzsSYm6I8uueV/iFR6SlAY5cx6+4mIHkGt73AMjJd/E=;
	b=PLw5BsfimhAGP7RKfDYmI7P1I7aSy2dFXfl0r7VZTo8hd2BWs4iXd678BzjtGK65sC36TG
	0MkjRjFcwDZCrrUKQpuVJtE161JRXukzwCbPwBZ6WATDHrIkuQ+53xUYU1oLQc17DLWq1V
	za2S6Vts6A9Us3EgqVZ3bDDB1QG3yv8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NSyrXHGb;
	spf=pass (imf16.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769524144; a=rsa-sha256;
	cv=none;
	b=a/MP3e+tCI6ZH8pBfzcl3N3iwcLJSgG7zORFo2Rn63mB/jTRHRU1/erwYMkFeZX0gsB5tt
	X0+AZOsVFExbqQZe3hAxvmYtNAH99d22Lo5ZtbZ1G5AY7tICZSfkEp86k4CaBkQAQr0DHG
	dLGa9f9rJ7M8Borf7Zfu8+rszACGhDQ=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4359a16a400so5154705f8f.1
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 06:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769524143; x=1770128943; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RzsSYm6I8uueV/iFR6SlAY5cx6+4mIHkGt73AMjJd/E=;
        b=NSyrXHGbpmet72kG8ZqT9LSw+ljzW7QrU/K2IdBNfyjMAGsETdyiAd/Pv9fgllbm0w
         mBj1xqA5GjN7lZ5S7fQJ3B227SJ+6uWZm8ipHrZtwck8Nv4P5Y5p3F9SKSIZXa6NibYK
         oPcA2J1DSfWtyz+gjZRLjC2hkQAnSygSX2C4/wdu8Xc0SqekVHRPRDvO8ExqVF9Rohj7
         LxaGR6Hmh6OcjzkXdmYHaXhCLlt2s/3H9QiLewMnoQqAPujPywWJMHK2z3ysHqkfDDZ9
         G1y7C7V8ASQAIej9SvHFZCfndcs6HKxuN8iWI0IBHv//zwM2zxa19Na2saTeaRkDWrGY
         IgXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769524143; x=1770128943;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RzsSYm6I8uueV/iFR6SlAY5cx6+4mIHkGt73AMjJd/E=;
        b=g/CR3ZR+PIseAYrU6k/0JAQ5DAsdMlqoNel2d9naAJhmD3yth4n8gd1HZdrs+gTos0
         CFUefiB3LFdVdO69zBQVWhKJOz5gmkGaBh6IOmdMYcnRcV4yZ6iR6szJsQufae1BBj4H
         2MTtdTlxE+gYuiPK+BOIr19wKRq2xXplM7GMNzQMMWlb5CtR+a9AH8IsLUvlI/GDHJGy
         ujTX92+HCPS8R8CjASDyYcPfpJRc9KyW64TUzNAzHkDII1fFyfauyJtGY67Nb5dbNq33
         XIDGeomRgVMZDDtCwc2chsQBfWjSDzfyEnq+3IFSsqeK+fguZz83+5gTmIOsLZGOTVtn
         6vJg==
X-Forwarded-Encrypted: i=1; AJvYcCWA3UuB/cc7D2R1HguQc9j8ByV2cPVBSlDV4wfOCao2i3dIgJzWDu0dwWU0TlKKCNTDS/TR8nF1lg==@kvack.org
X-Gm-Message-State: AOJu0YwIsgZnslALVfXh5DCc7kIcgS9zmIT+Hky/ZHtzBkIiqBcL4l47
	ZzM2U+eYi3B71rPiySW+OK7vnhH4m0qfn+2N3OBUklKSHH0TqAf5pTnI
X-Gm-Gg: AZuq6aIcoSrbYl+yzkqxyRpITl1bA02P2+QHYnmtsb7jr7tRGSkxKKjRGYbBo0EA6q+
	gyWtXyCq9TzrTv20qTHZiGGyCd0QX4ZqUtVE3/UdIDT05JJ+j3dj2nDzIYadJum/qQ9rzwZYxtK
	mlKFp/IMrBJOacE4s3roE4OyhvKak00JagK5iz5J4z40ZvEMXt9yAhmOSKeSlYJZ7wHKJwg1R7J
	RsN0OGVIaJz6kA+J43VMtvwMvaoPjZLRptlQygh1C7N1wCWDes2yC8w71Qe9EE5tXNg2DA9Xf0o
	lj/eyPmjQKFYQ6kZbIQnSdp+6SAxLd0MUPR4ZaEOyAjP+9M1UXdS3Q3SLptEhYXYFjxNineFw/X
	TVdXXnPI8vIcF/DfUvyMsfXzzMUB1SKGLijPybQPnM3GAkphhP8bXhbJgzLJITFqE888wHcaUIZ
	8c06LaSBoNcoZLhvKH2KBfJPqGYEuh+UcEHUjQdhVqri8ZRRkU3bxS2X539+Y=
X-Received: by 2002:a05:6000:2082:b0:435:a9c9:159 with SMTP id ffacd0b85a97d-435dd05aba3mr2633501f8f.18.1769524142351;
        Tue, 27 Jan 2026 06:29:02 -0800 (PST)
Received: from f (cst-prg-85-136.cust.vodafone.cz. [46.135.85.136])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435b1c02ba3sm37600235f8f.2.2026.01.27.06.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 06:29:01 -0800 (PST)
Date: Tue, 27 Jan 2026 15:28:53 +0100
From: Mateusz Guzik <mjguzik@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
Subject: Re: [PATCH v4 18/22] slab: refill sheaves from all nodes
Message-ID: <cburjqy3r73ojiaathpxwayvq7up263m3lvrikicrkkybdj2iz@vefohvamiqr4>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-18-041323d506f7@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260123-sheaves-for-all-v4-18-041323d506f7@suse.cz>
X-Stat-Signature: 4qb3nhpqb9xq91zru48e7tb344fqw7fu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 58826180004
X-HE-Tag: 1769524144-436376
X-HE-Meta: U2FsdGVkX192I9K+53f3q+bivuuppq0ulfgJwdPALsYxU+Qt2Ya4k19MRkxrva5HxYiCyGLXsa0+EIBXAJkIl5rjPL9+3Ib41ewFnaz6zsOvq1e9ZldCCKmS6tYIKAnTwancrCpVAZpbdIKSneB8HeuqoiytSIZXjoD4sQmI+JFxKDFrThBBGV2faHRYnkYCTbJSMpOS+JI/mYdafUTxdvZ4tnAeNjpRvAZ115Nq/w/FyboIckoPVr60p9aDT6hj+zorL6pXMaY/mNO3WIXONUG8bHAbAbd2BkNhp0LAcW/qy3Yoa7Nt6KcjYyXbdwVz9siVPYrlY9YRpN3hnBCcwOB7zGo34KG3M1qIB8N3gax5gu5qL8ZBUHH81ifWhJYBUougC8h2AmsFLN1K+Y1dWxx+ykgJBxjE5A7+DM5kFjn7O6lRX9+/uk9RI6NoLbvhyEo52Srg9q/kt1YsiW4dNDMqrVCfwW9yc/ymF9X1gUDnarlez7IyjukfDp6CD4Bq0xCghS/QUtQ2YhZpiWmo9+iXGILFoRV4tfUNm0lD55WkprpdTGdH1QMyRWMC+rK6go/HOQUTJ+VRxVIL2NgSlQCo5EQ3xj7PL0tnKkOQ2UQIUxdm2zkKeNjy/dOyLMCJIj5MI8QHRI/9X3gTiduLLvPgCWPZRFO2q5MDvwdVPgyifpqbV2qJqqXhckAjtQdcxLk9rZ7JkLVWg1yDm18RHLwaht/HdlEhlhakdnGAeCMITHRdY3BM4/bmYqDZcZc1loZsQhpmheG0Lpefjtrac1pDPp3CLcgio9ac/mRr4eEpdNZTQ/e2VFoI6uj7cIfssqPD9++0u5kxzmXEsGIpTiEnt/C+v8qKo30QUbGi2hu2vWIkfAEnnYHDRZqZ+Pa0qeeXtZr5yMiat2pVBIJGtMH7KC4sIv2rtSrq+FpIIYYrBIpJavsNWnysSNoehXYYVLe/i9/hWICU6aXHlF1
 /LGm2Pj0
 ms8LPngg+oQ3SReGaxCytbVYTMngW1RcKnMm0Vov6wobnKU1/SGda8w23IbbBBWEtVkJoQUgZnTowdV8ufKX3WWgbryGJ2uugUfri5PGGL/f24ZGXzTL0i0E5RFRmRT9Pl5l/0yURvXdgMr55nNxzyRXXRHh7WXiS/X4v30G9JCl9wPHXtVQp1P5jib4oG3hoseO/e7LKZ7rI3pGoTLf3a08ZP4gd8Dejrx4R+0lSHwCZHaX7rwXKrrL/cm96AYT6CGziWDxJuUKVf3LZGYgKQeotzFCW+BFrDc+V88c7SmZMA9PHp2kUdePJCRf+/GAkdYjMDdtnnid+C+z9ANndaopO0TrIiw6F06O9/xLyEq+rcs7YpNVtwZHfO2wBdcSffdt5QGhY+rX111vo6+QW/vCoU+wDOGzvsd50J8i/i8UXdlLU+oJFMyHTKjc1bm6gvNYcWLYPhFxbXAL6XQprgVHfzTkW/vaQHuzkcA1GPZ3h+YBaMpJrbhUCuCh3Hp5Lr6J0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 07:52:56AM +0100, Vlastimil Babka wrote:
> __refill_objects() currently only attempts to get partial slabs from the
> local node and then allocates new slab(s). Expand it to trying also
> other nodes while observing the remote node defrag ratio, similarly to
> get_any_partial().
> 
> This will prevent allocating new slabs on a node while other nodes have
> many free slabs. It does mean sheaves will contain non-local objects in
> that case. Allocations that care about specific node will still be
> served appropriately, but might get a slowpath allocation.

While I can agree pulling memory from other nodes is necessary in some
cases, I believe the patch as proposed is way too agressive and the
commit message does not justify it.

Interestingly there were already reports concerning this, for example:
https://lore.kernel.org/oe-lkp/202601132136.77efd6d7-lkp@intel.com/T/#u

quoting:
* [vbabka:b4/sheaves-for-all-rebased] [slab]  aa8fdb9e25: will-it-scale.per_process_ops 46.5% regression

The system at hand has merely 2 nodes and it already got:

         %stddev     %change         %stddev
             \          |                \  
      7274 ± 13%     -27.0%       5310 ± 16%  perf-c2c.DRAM.local
      1458 ± 14%    +272.3%       5431 ± 10%  perf-c2c.DRAM.remote
     77502 ±  9%     -58.6%      32066 ± 11%  perf-c2c.HITM.local
    150.83 ± 12%   +2150.3%       3394 ± 12%  perf-c2c.HITM.remote
     77653 ±  9%     -54.3%      35460 ± 10%  perf-c2c.HITM.total

As in a significant increase in traffic.

Things have to be way worse on systems with 4 and more nodes.

This is not a microbenchmark-specific problem either -- any cache miss
on memory allocated like that induces interconnect traffic. That's a
real slowdown in real workloads.

Admittedly I don't know what the policy is at the moment, it may be
things already suck.

A basic test for sanity is this: suppose you have a process whose all
threads are bound to one node. absent memory shortage in the local
node and allocations which somehow explicitly request a different node,
is it going to get local memory from kmalloc et al?

To my understanding with the patch at hand the answer is no.

Then not only this particular process is penalized for its lifetime, but
everything else is penalized on top -- even ignoring straight up penalty
for interconnect traffic, there is only so much it can handle to begin
with.

Readily usable slabs in other nodes should be of no significance as long
as there are enough resources locally.

If you are looking to reduce total memory usage, I would instead check
how things work out for resuing the same backing pages for differently
sizes objects (I mean is it even implemented?) and would investigate if
additional kmalloc slab sizes would help -- there are power-of-2 jumps
all the way to 8k. Chances are decent sizes like 384 and 768 bytes would
in fact drop real memory requirement.

iow, I think this patch should be dropped at least for the time being

