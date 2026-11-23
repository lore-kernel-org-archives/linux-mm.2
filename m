Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA0B6606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rph2yaNB
Received: by kanga.kvack.org (Postfix)
	id B085F6B05B0; Mon, 23 Nov 2026 11:02:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADF806B05B1; Mon, 23 Nov 2026 11:02:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5E66B05B2; Mon, 23 Nov 2026 11:02:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B03A6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:02:13 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07FCD160927
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:02:13 +0000 (UTC)
X-FDA: 85466850546.29.C7D0657
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1D61680004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:02:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rph2yaNB;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795449731;
	b=ORgWkhQJvy2U92PS5g3zkoZK31rdlz113+Rv/MWqnRZTiuOmrepcj8fU6n6NhPL/Aqxvt8
	desq6nh9JsHdfQr1zCjd0rtdl/QMCRg1qIhnvElStovy12Y0XhI4zGctfNhte7F5m+fg9l
	w1XSK1yJBU5jL7/TkZritkPeYjCN5+4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795449731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKGG8yQhQluo1jeMgy5Pk2aPts9Q3V6ZRR7HGYPBxOI=;
	b=6B5n0SO274/s3++E7JJmIOhklTQ+DF6iAvXulpSlIeFmG6C4UwO4RK4kJH2ORVWB7kFdHp
	+InZvOwJgBQGz1eItngQdB3zwGP8zgj3xGpuZ63LEtS3/S28TH6eFsAullopUtO4qKSxb9
	6eeb1e5ZY+HoUqre7EZ3YUqN6MhYJwA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rph2yaNB;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6048F44D50;
	Mon, 23 Nov 2026 16:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAED11F000EC;
	Mon, 23 Nov 2026 16:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795449729;
	bh=WKGG8yQhQluo1jeMgy5Pk2aPts9Q3V6ZRR7HGYPBxOI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=rph2yaNBXwJZOPhwxVMX/y08tuzLhPa5ch2uDrK7AJv6bHG1kzodt90Vkh6UeFKA7
	 aDABcvWiZ9xOhXE9RCvUFpSkj1oVc0yf6PncX3YXBEK3Mcn8mkMYciWBipsRgplNeP
	 uRyk2prYaNa6KQdYVE073xUFv8Qc3V+RKoLGqK9Y=
Date: Mon, 23 Nov 2026 08:02:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kurt Lin <lylin1023@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko
 <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Muhammad Usama Anjum
 <usama.anjum@arm.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: skip hard dirty page-cache test on FUSE
Message-Id: <20261123080208.b84bce7a706a0351aee6aead@linux-foundation.org>
In-Reply-To: <20261123150459.2211177-1-lylin1023@gmail.com>
References: <25ecd9ad-7c5c-16ff-5197-5703622a88b1@huawei.com>
	<20261123150459.2211177-1-lylin1023@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1D61680004
X-Stat-Signature: 7yeh7oegs1wmuz4i6dgi6yx9gj85q79t
X-Rspam-User:
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795449730-108710
X-HE-Meta: U2FsdGVkX1/lxQxxY0pzBIJy5mQ2mQUNDavCnctP3ggJTeUPQETMMQ6HWkm4enw3RzcaFVgM+1oNWO8jA4X6Xi5ISs5I9OQcPiRSSacEPi84wqL68KBd+exTkp6C4NC0PUcuOOuYId7zfXS90f3rZGm1bqxrP97ckF6wAWdKqzhnIlk8gbG4yo15iEoUf/IkFDamKpEZsFLdWD9xxDLISm7oMrxY1uLLYHqA1dZHLHGXceK64ZeojjvRGFFLkTaTGTSuvbJAfSRxg877u3q4yrHPrCtDv9cihGNbn4mfq4dHjfFj/wNb6yfi+N0O/uiSLD6BzMK8ws4HFnkmlWRGwu//C9kIm0z2uBI54AMZ/BtjNiTBonodF84Wnt9rkcv+4WUpkWs6iVRpDAAqpVjerVO1W97QETlGxCxIyq8kttqofwLmvJshfHqrxe9Qcm/1TCCAgWWLNQ+asLHhBsZ3VQXYxy3EffIipTVVcbrdXm0e2ckPCrgrtMgZObqxnpvUE0nNd3U2cdEKxCp2W3Q3S3VcHBXp38ztlQbjneg95CtX26ajlb05VEOaJBArqwmMRkbUOM64kBjTF3Aib2OrUAan8uem8u2ePxaI+dGIunudeBrqaIwgeImKD9dHsueSQfuYRI19EctNbg/dHesPIVf6TxmzvtmTSy1ULL+phFpfGhJrP7yu8UXsHAt5JC8Gda1fB1hYl+M14Bni+G4Bi52W1BPC3IN/xIYR2m+eI7KqaUD/KbL5ayZYU1vlxs9KmwPNEajg3dPksNe4ADo5UC83Og+WDWWbUz0uhQ+LBGS++Mg6Zsh9fswMGJlKVTAvZQfilOf+Ozsd9yPwALxRkCJQP3bzdYsvLL5QJHfIK1G/fBygs8MwOsQE4HFZ/6PqYIs4NwcYf1nH7nkIDSFlP1lVIrwp5kKlzKuunVITsXs8rba2CxAwTZwA3jMHVmqSbM5nmJhQbpOc11iVqf3
 daROHObg
 3RUDU4PrEY5eJ5uLlNADJWAtX+D/ENM1PivHTOQ+7IPDgfp89+3HKimM4SKzTGLKp7OiX/Zj5tZGMwSGRTZzYGuOrJOZK2mr+rdMYfJ6FmKpDXsJIQPEgF6CuXdNNR3/0k6ER+uuLM+jOuWjytlnZ3SRuRM1liOC+EZ07qp2cmnhP8poD+Wd2CMvNxrwFked+gyumlGvoq4BplkTPJmGDt2XhwCRhsSkLagHWPCW4ab8UJv+C0J7L4vZCiyrQEgehZ5BldBhWyuvUM2JrfDWwCZL5ir8fje2tck6CM/mVjkhcf9IrV7aWD/2Jja2mmWxz6UH8BuWLY+l7RD3/GSWuMxjm2YzLswnfCBdUN2YtLkfy3gtxzYGbafVX2AJQX8j/lLdprLUlPEhutxMw8/v1R3vw8weADcStHWEa8Nmgl0gh5ADHoMP/1w4JpqP/unW4/nzmm2Ibxc1qt3nL7VLCLWdirarTUQ+OVplPmClfYl8DKc9SVOTgGrYOU8wAXD7rp29f4JZFCkzkBexr6GJE+jFOwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 23 Nov 2026 23:04:59 +0800 Kurt Lin <lylin1023@gmail.com> wrote:

> On Mon, Nov 23, 2026 at 11:06:45AM +0800, Miaohe Lin wrote:
> > Would it be better to add a helper? I doubt there might be more
> > unsupported filesystem.
> 
> Thanks for the ack. There are more (CIFS and orangefs also report the
> error on close()), but Andrew has since replaced this patch in mm-new
> with e747ed2c3418 ("selftests/mm: check that fsync() reports
> hard-poisoned dirty page-cache"), which needs no per-filesystem list.
> My patch can be dropped.
> 
> I tested mm-new 87cdbd9bd631, which has e747ed2c3418 and 44191f78d131,
> in a virtme-ng guest. memory-failure now passes from virtiofs, where it
> failed before, still passes on ext4, and 50 runs in a row on each were
> clean. I did not hit the unpoison -EBUSY on virtiofs even without the
> ftruncate(), so that part is not covered here.
> 
> Tested with the help of an AI coding assistant. For both e747ed2c3418
> and 44191f78d131:
> 
> Tested-by: Kurt Lin <lylin1023@gmail.com>

Cool, thanks.  Yes, that's a work in progress, I'm drafting an email
but not quite there yet.  I think I have 71 filesystems working but a
few (cephs, orangefs, afs, hpfs, omfs) are fighting back.  

