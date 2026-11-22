Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41F7C606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 17:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DlWUp3dm
Received: by kanga.kvack.org (Postfix)
	id 356016B05BC; Sun, 22 Nov 2026 12:21:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32CB26B05BD; Sun, 22 Nov 2026 12:21:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26C946B05BE; Sun, 22 Nov 2026 12:21:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 006776B05BC
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:21:30 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7DD86A04D0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:21:30 +0000 (UTC)
X-FDA: 85463421540.07.29DF00F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id D620C20003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:21:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DlWUp3dm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795368089;
	b=GdeP5z70orKs8gtVJghLxv0bPfTnjxHnJMPxWQyMwRpUII+FAx9uK36nQpFr53q2myynQ2
	Q1K681t3XVBfhf1OrKoefzEpAyya6vLrAJuMmvs1h4Y4cCwDhuYN+yb7t9qCJ5ZXWm7n7e
	rUUlszmON4C5QyEWxLoBe5uuYBA/yeI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795368089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qactUoyjpgY5pptL4OazGhQ4h7pIDgNLQg3L1qeBdho=;
	b=SYX1+bUgX15Gpa0RQ5/7v/B4E32/suZz9WBmmGbnEOcVVCp6qdDF+NHnf+AFkTNsmReMct
	OHX6xrxIK04lVnGAXSXnNAmt4LpIhAy0cb1u0YSFxn653qHvRoeXQrvb8sccSl6dym6H1i
	unQ0n1JnfEOiJEtG+TV4eFlWwAk+FKk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DlWUp3dm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AEEB84071A;
	Sun, 22 Nov 2026 17:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5493C1F000C6;
	Sun, 22 Nov 2026 17:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795368087;
	bh=qactUoyjpgY5pptL4OazGhQ4h7pIDgNLQg3L1qeBdho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DlWUp3dmD9Z9ZqTxT2C5j+emQ+4msQtDCjFGN7NISg72dJi7aDh323DNMrVs+ZOqA
	 EgsNYLToMhWKiJE2S3rQegKR715uEsHFsI7j6IvtPfQamskA60+X8yMG7N5jVUmDgl
	 xYF/M+cz8JK6rjGJN6dZRTmaWoXmAA75lfi3raB31eLgUhi3/LMBgkwLbfxzBmevFy
	 t+UqTmsGhAW8c/cUVmDIvb5Yfc5idP79/Ggu4OZtkMA1ec6VuqUAK6qseTC8fXUTwZ
	 RGYCnX9rZw6dmX6eNVGgln0/65mENkVixjztWAFb7rBnuuz3jrvMcaWZr0rw4vVjab
	 wJ4blMqkheWQw==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 02/27] mm/damon/core: implement data attribute report queue
Date: Sun, 22 Nov 2026 09:21:14 -0800
Message-ID: <20261122172119.153755-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CANOyQmE9kM_WgOneXhQ29HTFDLYJwdzWjVKj4e11ESTtT7K2Rg@mail.gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D620C20003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fot87axudb5gcgebqhhuc4kjhzqf7ooe
X-Rspam-User:
X-HE-Tag: 1795368088-622481
X-HE-Meta: U2FsdGVkX19n/ij9TqZfVWO81EE5hQFW+5RAcAFlz8oyjBWhhACuxrlEzDj41uv5PLszkmr0EjrbNQV+QdoZiAToA7JI/jLeDpyu6XiD5YfU15pfc2udOkLcgI994QxIaWFsO6auH4XujRVXDD/T7EkBAXahYjZ8Dr7NifTBbb+oMl1p1Xyid2nc9IXmi5L9V3u4drDV9xxJUFiIK/bOK2yIKLtm/yH/qp0BMEML+D6baklw0iuAxBG2hHt1sMStothSADZAYTSojgAJVPG860TVAUoY7Mmxe8XxwwIU5tyEuOQW0caDLijHmaO4ymIgkocRWEWE1gA7iOc0L1ScAEqCwzrRAbWDwcNkuwStn6koznRSIhS0f3K8QnQuPULTp1QNyN2nBVDU57uEN3WYOlh4AKan9rnmKvLogF80UkhklA6zFosfarJOS6ZkUBIupF3pUsWlIdbsoYKI/3LCuBwpF3aFG3l8z5tLZcLrTSVJzI+b5z4V3g479ZcidFI2YaMSK1WauOHhaGK7NzETt3lCvzy3wMBHAOJqX4FQCx9Q9mB6zlkGNVgxyGBb9b8g/2OxntvIRH7dDID492y1pADMCRgcoymDtvCpoeHZw996gcDvCIzUuy4txm8cZl+88NcXO921obf70T6FBJuUGUgUgiV6QWKXjxDi4B/U/QwjB5xvhaZAVRMbTaIIFXBkcI4hkAUWC7sng3p69HNJUzNvZZ4ITQGABzNjtHRKchf8jvdv0+NJlusd+OnXnOTDe4LNJBDUlq7JSd9Ibv7Pm5cEChjXm1fh6ZikWVlOtPmkLckOvwrkdwBKCyZfllcFuZmZGr25mjaIzhU49k2p5FwKnqyPeanHRXnx4sLodIghcDgYyRstcjd/6vaGY5N3zwhuz4+uYaDb0XG2Yk1hzZzBa2kCweI97xJutd8pFnPS835YBafYNLDuY44ZYXhe2MDXRSobQ0UpkBZGefX
 v0G4aCfM
 GsxQAkkS1B1YfhH11pSwMwyqdnWMmmu8R9WPQWAajRM9UYrQZermZ0jNZd008B6I4OX/GtDtoX+G5LuSpKAkDVCUoFpSt++iVnUQQHSZng9LD378ZT/CzFFFUxVR8yqz/WXExQhdUedpK2va1IygsG3g9d6VcQ+6txwplF7HWLpN4t/0vDEBpesNzbA+wFEE22POe7Kpt+G1Uwv0r35sdo/KPXNKDI4eBi0o/DtFcjxEHEpB8CJJYZKoTOUwMvON9ZMkNgBQ1qebPJbfYKtLJ1HVz8hlnxfQxqCjrIEwqCYXoC7CCDbP0gAYHaFDwy9yqGoP44T+Eas0lMKi2dcaxFKdCt+TRe+ad1eHH/sWVYQrB4w7/Lbh8A0V3CwVaHMx69sfF+Jxsm97WG/elDENDXOxDGxm+y0c28JuTETSqCfXF8GTXvsgltnKn8SAfnVE0UlUijuT/hzTIAb+y2fUQF7VKX88yxCJWxb7uGTHbi54zx0qrqfMiRhb7DCJIQCDDokaMPJyJgOgk7nM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 23 Nov 2026 02:43:18 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi SJ,
> 
> On Sun, Nov 22, 2026 at 8:00 AM SJ Park <sj@kernel.org> wrote:
> >
> > Implement DAMON core internal data structure for queuing received
> > data attribute reports.  Initialize the queue for up to 1,000 reports,
> > inside the DAMON init routine.  Destroy damon_region_cache and reset the
> > pointer for the queue setup failures.
> >
> 
> Looks good to me.
> 
> BTW, while reviewing this, I noticed a pre-existing issue in DAMON
> sysfs. If the core fails to initialize, sysfs still registers the
> interface, and trying to start monitoring with an initial region can
> hit a NULL pointer dereference.Maybe I'll send a separate patch
> to fix it.

Thank you for reporting it, looking forward to the patch!

> 
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thank you for reviewing!


Thanks,
SJ

[...]

