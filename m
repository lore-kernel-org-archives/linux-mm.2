Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92A91606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 06:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=nmOYXE+Q
Received: by kanga.kvack.org (Postfix)
	id 7716B6B05B0; Wed, 28 Oct 2026 02:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7249C6B05B1; Wed, 28 Oct 2026 02:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 612566B05B2; Wed, 28 Oct 2026 02:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39C3C6B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:58:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 793C71A0B0C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:58:31 +0000 (UTC)
X-FDA: 85371131622.22.93E375B
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9725F40005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:58:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nmOYXE+Q;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793170709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/SMm2YpudK66NsGAe68ZoW6GAWXqQP+W1Wbd7hczTxM=;
	b=46CaOyX8wWd3rYBmGfvO/y4B4Ukgx3js+T2+pHJ+0LY9FEAKv4kAYZZaKLuJeRkIa9cFrD
	k/vU7H7Q2BOkGDth9DwK0MOOguLkaJfsmqKNgiP+moIFN4cTkPKRAXFRSr7rYMyxq8pKjI
	3Lxj9VyFcrkBh6GNyNARL0QefV6y6Es=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793170709;
	b=oCfv26VniskElGHJpF8jnjXWELG86SdeUmmtz4WAcnn07GZIOuI7bQ7CZ8JVlxfmk0i+T8
	hmYrxwyELQ7/34TqQq8TK2p9bb2EStf7P7sFcryGqbCFk7Qpvr3coVDEpLLWd3O6aVLgw4
	bJ+vSpKin8TlBkUzeHG56a+HK9iAVso=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nmOYXE+Q;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793170704; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/SMm2YpudK66NsGAe68ZoW6GAWXqQP+W1Wbd7hczTxM=;
	b=nmOYXE+Q9uYZBGWCY4JWLvn6zycHL8PfChSATEFHCpSoPkRcdQWyozly/j4v6/Cg6M9ykHjedXfWfO6q4wRPtwBEhBm9lwoiwyq454YzevAwhfncb2KIIzxcza5D8cQ+q/SCC6URfW4sA23FqNXBhnsrc7VVgtNL/jFTigaxxiQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XDg3Ape_1793170700;
Received: from 30.74.144.137(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDg3Ape_1793170700 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 28 Oct 2026 14:58:21 +0800
Message-ID: <bb3b1c3d-f656-4238-9c89-2639687b6f8e@linux.alibaba.com>
Date: Wed, 28 Oct 2026 14:58:20 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] shmem: clamp negative used-block samples in statfs
To: Hungyu Lin <dennylin0707@gmail.com>, hughd@google.com
Cc: akpm@linux-foundation.org, tim.c.chen@linux.intel.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261028051826.23058-1-dennylin0707@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261028051826.23058-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9725F40005
X-Stat-Signature: te6a7mauk3766g1ckmqriq7nssn37ai4
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793170707-684679
X-HE-Meta: U2FsdGVkX1/3e6SoDswVYbCEGEW5TH+lGzM7+7j0s95M0sb+q/TRGx5mWEskGhdgg1gMs6fhy8I7f97tHWEvj7zyRNIPAtKJVqZTn4daiq7/RR1e/7M5/Dvs9I1I7z2hzrXSi4WI18Q+8nxI8srJXUtXXXAp2X679XzksM6Ajo6ZJoeY1SbWIaJ/2jfjadYLTfSm2VelMDXqNFiorJ0BiwFKiwiRRnYrVG2uGODLHZ6z3msXvXa2KaJHv7SAmipky1pzUE5D+qVNb1S1FN8loGTaW8zgPe2QMlYYgipZRfGRWfNQxO43nrZnd8/IpxCkBaw0HYMRM7BrkoOsMUjw9oBw9ULfnp6/EizDZ0/Da2udsn9SE1KMYtrIJR/bU/26lRHI5J6It9uiMqYwIH4LjtGr4iYaqB9KZ5K36jJUaueu6T48JBkgqsUtAG+X+zlFivnzNw9nVDSWg07qNtVmptB5EyewJ4ynQLzhZLEt+Xz22F6dEHat8zFzBN3FBkcNYOEtNCE8bzc3aNbuECsyROYKQNeuGGQB8oZiJYECrfKUkdyhi5R/+t1IYVMFxem921j/+W3S3y2KEJC3P6iw2Jkugivg8FDhV7AAxDF75Bun/FLFWDF7wuUg7ncjUsqEB9v6NAnlBwYBjidat74suj0E4zt4OMYs0YM61mazL9r+sEs8FKrQpSxsG8BdmNd4mcORWy/xA20n/i6qWZ184fPe61n91T3t/bHzullWvQ4twRnBG1c1iBNt7XFhXrJPv+I/zfQ+1q5mxXcJergFR3zXD1bGbAgc32sRFK63aEjdyArttMVcUtGk+ssVpH/0DEUEz3ehwN42oeLSyB+l3F44PhQ9ofIX5HobxXTcDWWcW8jx3kwXVuYCuYfBRNNBtOv1qtjuZj8nUfnodvjIft5NEZdE0IGGrlQVDGwx9vYhdl1m3uWSi3ySET9gAGKuXFmqlfEjTun+z+VQUIl
 v38nJrzD
 zZr/p0W24UDg6Cb2AGJ/zL6C5nHGIGtYDLD1J8MXlrLN5PH7qaUjilFYPcoAuTs6OnZPamD1AW+yPnh9tlQVF607UsOGr5dSrPpryq/k6KbmcqT72bXGKmKEpmsQYZ+yUGdgb23v90byMmXZKPRTQhitP9oeEoAV4fAzacgCFpyVE4grXI+0z8wAxFGcHb2Ack1a1eQ9QRReYL3DqgWjbom5kOBNTWIIA+riCtCydCh8xnQHD4DQQMtKkYBRZexPT/DjK1YrPntAsIgtYNDQ2YAUQk27DJ5FnZsyE4yONj4J4rtHvwX7BhzbYeYbKw20M3JSc+54Ahro6Rojb5DNHIlbQFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/28/26 1:18 PM, Hungyu Lin wrote:
> percpu_counter_sum() holds the counter lock while scanning the per-CPU
> values, but local updates can still proceed. Concurrent allocation and
> freeing on different CPUs can therefore produce a negative sample even
> though the number of used tmpfs blocks cannot be negative.
> 
> shmem_statfs() subtracts this sample from max_blocks, reporting more free
> blocks than the filesystem's total. With a one-page file being written
> and truncated on separate CPUs, GNU df reports negative used space, for
> example 67108864 total bytes, -28672 used and 67137536 available.
> 
> Use percpu_counter_sum_positive() to clamp a negative sample to zero.
> This keeps the existing best-effort accounting in statfs and does not
> change allocation or limit enforcement.
> 
> Fixes: 7e496299d4d2 ("tmpfs: make tmpfs scalable with percpu_counter for used blocks")
> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

