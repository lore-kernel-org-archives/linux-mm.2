Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D85FF8E4A1
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 03:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7056C6B0005; Thu, 16 Apr 2026 23:55:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B6396B0089; Thu, 16 Apr 2026 23:55:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F30A6B008A; Thu, 16 Apr 2026 23:55:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F1DB6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:55:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF73FC33E0
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:55:11 +0000 (UTC)
X-FDA: 84666682422.14.7F4BCBF
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf21.hostedemail.com (Postfix) with ESMTP id BAFE91C000E
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:55:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Op8m8Qcl;
	spf=pass (imf21.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776398110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dwa9Zzv5iIZJofmNxLAczBJ8wqidHriBciYAKIZ9f1E=;
	b=y9NywBmg0RgV5UTfTlnem9L+0znPeXr7/39JfDF6n2utWj9rlO3GDsGeR0sf8Veb+s+UU7
	c/NSco3LN6u3y60HTrXTaTQS3ySJwjCw75loCBp6RDk9g8MysU7VJs9YizzXhJGrfPluWG
	4zEs9hZuCrL2dcJ2rJxgqXn8elH1C20=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Op8m8Qcl;
	spf=pass (imf21.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776398110; a=rsa-sha256;
	cv=none;
	b=NcAVtrhQeDyJXiIgPVLsudFrUxK09EKHx4BuHROKIN33LswcmvfxKi+aW+UM4GWSnSBAaz
	40fpYVLOQfTqIbh1TJKEEByfUCR496TeJuv+n3TdqW3s3M2KE20V5YQHncDwpN34m8IsOu
	zGJENzjitEuzDzCfYO4b2fH55Mp1FkU=
Date: Fri, 17 Apr 2026 05:54:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776398107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dwa9Zzv5iIZJofmNxLAczBJ8wqidHriBciYAKIZ9f1E=;
	b=Op8m8QclxRKY0piahVBmp+0HeLdeSWMuFlErJUW24Gyx7omLw8WTSbgGqHdlLbNkqlviDI
	TuphMzWZiZFQe08p9jtxw+2RNHGoo7P1U7+/zAncg9+1O5PIFl/EG9VnppqL8RsKV74t2I
	nfsykl1krm8kz5hIt6U3hH7PjXrzsd0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, 
	ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, 
	dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
Message-ID: <q5ksnnwwnjqyvzqrlx5u2zzsq2rs4uoirn4xvt6dfrdck7df5e@pxyaupfbdb3u>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1775658795.git.ojaswin@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: fohzazqyx7k1cgp4djxwpif8r6348rmx
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BAFE91C000E
X-HE-Tag: 1776398109-498403
X-HE-Meta: U2FsdGVkX18HkBB2UPsPqxI7N19uO5RnWqqqoUFrWXSWqrO0G7yI9NK0fdqxcThmF1C26AMnW37VNLp/2Bqqx6PG3bBbmInE/a5FCKetUt9dxPRWobtFiKC9pF86i4VFCQmX916A9ecaucz/thdpt+Ow4vOvepvQIAMb5RNcxB1MQZA6C87y4otGc0/ZeEhJdojXdFBrGWmwKTNDJZLHALlUuGSyE0gfLKsaMvTW0IW0gU1qXDphFynmeQzK+BJhCVb81Tws6CWeF1KLqRUopphqGuYfeL+NXquPpGbgxnBlVFC9tnxdb49SuB9rM0MVB4UgsSuGhdf9mpKx98rmkrYDyZlkVzGc4Ge+jFYRAoPkZm0L/Y55odHJL3plbDWf+WW46E6W/WFBIU/ZdkH6UydNUigli97WqIVMBuT5OCcx035scpXr4LDq3h1qrWXag2FQox0DQVWa48Rd3uR6KxCU3Oz8Zt1VJ5+h0/6Z7pdWVPeWTqTAvh/y55oJLq7UZmj87I9rYHw6JfAtVTDLnzLNgrvKa3+eu0rAYwa4sKU6UqwX9u+IOpF9IkFh4NJfR2QVitjK84GtKUPAZPnremCzAD6pGurTzW7/YQ1UZQMXzw53ytgYPiTS/Q8Tfz7qRNAw7OZWg8mH9DBF67T0Wms/0jwX9AZfVzIIK8aavg/bhvxnJPkOrHOcdHeGxKBQ0MBqB/027vde3iNHrHXjxPAKWLQr3Olnb9fdl/2obKDmXaCEF5+JeOtics7IrLn3CgK8fkp7NP8LZGAs4uKimEjSplc6IRri2DS9jRGbQkRHSOmXwwzf0epvxjzamw6y2vJF5gWxnfSNg4fBqOOBu/nWy9V0xknMsEtynZklN/Y+Zz9n6gA4+Qvi2lGLdsc2527eTy95X6/LiazoEtg4dAeXbRi49qlOkqnHkBfUpS/6AOT9guIt4RzmAb6prS/xNDp0DrNKvVVbVGxCrHA
 Y8svRcvH
 D9PEeIwhnOhhrwbkS29WsoCyZ5/2IZobPmoyEIRpbhP8ejmHW1g7ZIj+HEscPR8He4/7WOwxaCxpkF6PVrqCUVTcSYnD16vCvtP+6j6C25sw+BbsxBllHcyj1dc6XvURysVlVK3nYHGL11PyvBA/5TFPoG7dk94Pta8n5v0+wHUlKmciFfYPsY2OY4RyvHhS0wvcrinYIP/I5/gNlr/6mJLBpEYnnRB8vIW0p4eyjEmY4zVsDf+8LgUtW6XJkZ7UzOuzDlQ69rOC75n5YA98hBOwl3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the patches.

> The implementation of write-through combines the buffered IO frontend
> with dio backend, which leads to some interesting interactions.
> I've added most of the design notes in respective patches. Please note
> that this is an initial RFC to iron out any early design issues. This is
> largely based on suggestions from Dave an Jan in [1] so thanks for the
> pointers!
> 
> 
> * Testing Notes (UPDATED) *
> 
> - I've added support for RWF_WRITETHROUGH to fsx and fsstress in
>   xfstests and these patches survive fsx with integrity verification as
>   well as fsstress parallel stressing.

Could you point me to your xfstests repo where you have added this
support? :)
I have been traveling the whole week. I can give the patches a spin in
my setup in the coming days.

> - -g quick with blocks size == page size and blocksize < pagesize shows
>   no new regressions.
> 
> 
> * Design TODOs (UPDATED) *
> 
> - Evaluate if we need to tag page cache dirty bit in xarray, since 
>   PG_Writeback is already set on the folio.
> - Look into a better way to refactor writethrough path by reusing common
>   parts of dio code.
> 

