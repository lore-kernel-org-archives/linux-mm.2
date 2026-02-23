Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D274EC1126
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 19:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ADCC6B0005; Mon, 23 Feb 2026 14:24:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B006B0089; Mon, 23 Feb 2026 14:24:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75D9F6B008A; Mon, 23 Feb 2026 14:24:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60EE86B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:24:21 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7A44C1339
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:24:20 +0000 (UTC)
X-FDA: 84476697480.17.D402FC2
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 194E34000B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:24:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eiTbXIzA;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771874659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6TZd4+pJn+8hGb0V7noqVqCLrSSpO83Rz3N2TUwk/QI=;
	b=7sjdQcyKFkAyW/QP6mjNuRXpA9rha2V0fv/T0h/KHuHjYbXim39CEYjepAY815cWwvDPK+
	43aOHYwUvmp3OWOxDxVaZ4jexcVdJsQkE1uIRj4NjKFR6PIqBrbr+3cvW/H+hon5PsffLe
	PwyRyeFcl3fQHfJ196zAKWyd4v9F46Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eiTbXIzA;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771874659; a=rsa-sha256;
	cv=none;
	b=YdaFcq+E2tCP4c9tqKyITkr++lN9ktb/j/qx+kUD9GSGmZ3munQXJt/cDa9SIhJNG844+G
	PO6Se0gy9lZ67DVCuvMUbEpSsCDKo5h3E1wrWiPR3yZ7TpkY5H+cSVVvWSaf9M2wGH+Ugx
	3ZaxoeCHGqHDzk0gNnRtkmjGdrLW5U4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771874657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6TZd4+pJn+8hGb0V7noqVqCLrSSpO83Rz3N2TUwk/QI=;
	b=eiTbXIzAMiOrRPGqqLUCeGzU1qIn/7nfvwRHMTsf+6ADaVvbUQuCmG8QkQ0s/YhYUcPgMh
	k3KR5O76ASPjnsZDPRm+owgHRxHesiy+ruAUz41AjdsabQSazBODovejgRiqE8HdYQ5L2n
	xHfjKDc4WIg4ekbfBc81O48PrPNnRAc=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Uladzislau Rezki
 <urezki@gmail.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,  Michal Hocko
 <mhocko@suse.com>,  Shakeel Butt <shakeel.butt@linux.dev>,  Muchun Song
 <muchun.song@linux.dev>,  linux-mm@kvack.org,  cgroups@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm: memcontrol: switch to native NR_VMALLOC
 vmstat counter
In-Reply-To: <20260223160147.3792777-2-hannes@cmpxchg.org> (Johannes Weiner's
	message of "Mon, 23 Feb 2026 11:01:07 -0500")
References: <20260223160147.3792777-1-hannes@cmpxchg.org>
	<20260223160147.3792777-2-hannes@cmpxchg.org>
Date: Mon, 23 Feb 2026 11:24:03 -0800
Message-ID: <87h5r78drg.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 194E34000B
X-Stat-Signature: sama9gfo7cdw4duu7jozjssng7zr6uap
X-HE-Tag: 1771874658-813216
X-HE-Meta: U2FsdGVkX1929rJsFHLdyO6YsczHbcrKnURFu9l3H5e9mg6HPYHFCCO6fLbsdFZlcEZM/aUCBq4z+//SPZAFivln+cu0eW5lMI94mFbDptdedhTwxVAinz7TT3GtquD8G0gH2VULKRTdod76UfH6vz83sPJ++N9Bzy5ypCTGPWDJoRvdrp9sFeSDKAMmRHQDVKLJlVAYmftlXF1xGKVib0W2dprYgdXpT44ej7unBXn5eZ7ClMYXkgwn1fFGLxWU38IVXVr7A4ayMEkoIpIT4SMEYYsBys4hArbMqBzRtDMjIHgYfzRq6WUTZTOuHmbnxU5WryOv9shijWOIZA8CE5aRUohoSccBHPzOW7GfrGcCv3nbVU9Wf/EwGlCzjq6sIXWFmy3Rzhfc0FioHu2d48+2dLVREzZ/pmT5EFvrC/w/j37UkSh5moMtQQVlHnYfKazSBpBd7EwGADEsR/zI6H6oyDEqAIC7CkzQDj+LYUWwP7/ZlVP1BIarWuUtYbEgAY2A0Bq1HWx3DVowZIFcf9JYiDjSUMN+aPNmFA7+RR/nAGDjYjK2A4jITA1C5o3/rLk8jy60EUoLoVsQNpyvAZhE7Bf9G0YLwXma0Y9HjwWuA1keiHdejb+UNdVgxvXmtuw21xcu+JjultRqi6FfNkKeKkt4g9+ABoaMW9ZHIOABAkpuL7q4RFlJYY7i+XC4otzFAa8Fp+1MzQ1gTfm/SdfejypW8mNHngrAkHwz+pIOwhxZPUCEluotWnz8QMiCI8od5HMGy/TS8DwiN+sWzB/FHppsf1sgHity/h7jUamyEPV7ansP2W/yVpv9pfUbCU+LRIq07cGXCxJ26JJ8paJkuYtsIMTFi/vRZwrFJR6vifBgu/A6/C0nvryFam6n5gMaT49Hbb8WkVdS/No5ETuOXZ9fOs4wNZqg9lFMBPCvOKoV0EgFGNArQw6UCWs3ScfFWuBMPSKz3Nzk710
 NaJ9OsQZ
 FQejMe9FukYPCTdty/5TEmobuWEZUvZM9CoFTGrR1J3ceMBOwANH/Ip49aFICbWwvaVRaTP+tmpEYcb5Lohf8FS7ssHakNuZ33GEXXdGXhoL7RgMoqMCcWsUXwJWVQDbSg4GL0R2aMwoYHGm9IRiO2c2T1zAXkwkelH2Nh1kRnUY1Qqn2lxdln88cV8jCwtLgC9zzp9akMb4LBo5RG7nGopNKixhgYJjXmxWGXkW3XFJgcubio7cThqT3SFXY9g90Vq6XwsDpxwRuRoFGg/HSA/sS0enrwT4Gu3F4Ycwopdsbje7JeMA3nVkOrjDP8a3eXhfDS7ZsTxCdSH4KfTxren+SL4742enYxBWN+cyiu2L9yIs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Johannes Weiner <hannes@cmpxchg.org> writes:

> Eliminates the custom memcg counter and results in a single,
> consolidated accounting call in vmalloc code.
>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>

Nice series!

Thanks

