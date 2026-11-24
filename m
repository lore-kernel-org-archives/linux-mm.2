Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC470606A330
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rgt3qNyH
Received: by kanga.kvack.org (Postfix)
	id BEC546B0739; Tue, 24 Nov 2026 10:03:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76BC6B073B; Tue, 24 Nov 2026 10:03:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17AF6B073C; Tue, 24 Nov 2026 10:03:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BB226B0739
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:03:18 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B485C0BF8
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:03:18 +0000 (UTC)
X-FDA: 85470330876.13.AF7153C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 706BC1C000E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:03:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rgt3qNyH;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795532596;
	b=iqJxuHgxNDcw1NW/Rdz2Vd79daFucHW6B09uBXtew3yLGGyGSKshP0X8aWoNyDzqQq2w1u
	LWj85yUrZSsaWFtiTMRHO7MNVpRgvSofa1MFJ18iOBQm5rn8GwoGOgBeqbl3GuPfrj2gzY
	z6xTSWNJILDPMrQ2//nzsX8LDrHoewM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795532596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=REPVVlJkeD+ZeFzs7zAo1+Ptfc+JAlFq2umyUtgb25c=;
	b=Adz5Mh92Np4EXs6sGh6iZK2akZlHAi3TDX9//YEr8OOd7J45z3aZwykeZBB60VPOaK83jC
	5pTYd/lzj+oSn8JS6So4XuRoDKjac4Aub6tiZ8I7cxV4dKV4nW9DAJXlgXbqZqgIOY2nUw
	P5M1nyJioGz69oOw56uSZNu4GFzIEn4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rgt3qNyH;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E2D9460F86;
	Tue, 24 Nov 2026 15:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33E51F000E0;
	Tue, 24 Nov 2026 15:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795532595;
	bh=REPVVlJkeD+ZeFzs7zAo1+Ptfc+JAlFq2umyUtgb25c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Rgt3qNyHPCldkjic2773LwWjg9d3P/FLq5Qu1r0gEa12eaPtA6b7aA0ONNNWg+Q16
	 3MfPbdPUHrYiiRtHBN8UHBcbbVwSQH6Nxwtr4Vauzk0jdXWVWTNwZW2Q0U1jAkSg/I
	 a8jjMCJFLDOGujcH8zGjkxrbasfDekPP2ucvZ2rPiNWCHHS73zxGZWYhlzEVmPdvTb
	 YIAZGT5zRos71jgHCl5iotePibJWLcBWeFVNhUyF6P8IitYK6Ilzkdb+nYWenk4yzv
	 ZiLUWimuKPUmIfOmwI2kpapgw9Kn5gUqxdpMc4Swk2LhTfMzrU4jHWJNAuXbSZC2te
	 G3U/5Zf2x/zRg==
From: Pratyush Yadav <pratyush@kernel.org>
To: "David Matlack" <dmatlack@google.com>
Cc: "Pratyush Yadav" <pratyush@kernel.org>,  <kexec@lists.infradead.org>,
  <linux-doc@vger.kernel.org>,  <linux-kernel@vger.kernel.org>,
  <linux-kselftest@vger.kernel.org>,  <linux-mm@kvack.org>,  "Alexander
 Graf" <graf@amazon.com>,  "Andrew Morton" <akpm@linux-foundation.org>,
  "Baolin Wang" <baolin.wang@linux.alibaba.com>,  "Christian Brauner"
 <brauner@kernel.org>,  "David Hildenbrand" <david@kernel.org>,  "Hugh
 Dickins" <hughd@google.com>,  "Jonathan Corbet" <corbet@lwn.net>,  "Liam
 R. Howlett" <liam@infradead.org>,  "Lorenzo Stoakes" <ljs@kernel.org>,
  "Michal Hocko" <mhocko@suse.com>,  "Mike Rapoport" <rppt@kernel.org>,
  "Pasha Tatashin" <pasha.tatashin@soleen.com>,  "Randy Dunlap"
 <rdunlap@infradead.org>,  "Samiullah Khawaja" <skhawaja@google.com>,
  "Shuah Khan" <skhan@linuxfoundation.org>,  "Suren Baghdasaryan"
 <surenb@google.com>,  "Vlastimil Babka" <vbabka@kernel.org>
Subject: Re: [PATCH v4 07/19] liveupdate: Add helpers to track the files
 that LUO manages
In-Reply-To: <DN2SLUVNO0L5.3NUHFPC0J7QTG@google.com> (David Matlack's message
	of "Mon, 23 Nov 2026 10:13:37 -0800")
References: <20261111002358.1842967-1-dmatlack@google.com>
	<20261111002358.1842967-8-dmatlack@google.com>
	<2vxzbj7j3ga2.fsf@kernel.org> <DN2SLUVNO0L5.3NUHFPC0J7QTG@google.com>
Date: Tue, 24 Nov 2026 15:03:09 +0000
Message-ID: <2vxz7bi2z2z6.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 706BC1C000E
X-Stat-Signature: xref8wytr9rmmb79ty6bb4z3rjxaq3ue
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795532596-332288
X-HE-Meta: U2FsdGVkX18/P4rKGgYiI5cnCDZ9vwsFbSfy9wdkn+tEJATHN3fzT1ukfjFVM7sSLmpHXbn2to8WkZxs883JiyYKOO9mMuLuA4FK0kPq86ZfyOyYpJbKETZbNuWTc+aYiXqCJvU+z01kIVH5TiBMHKmbhOhjtvyRhk6FuP7eQ5bDitNC2xRV/qFV8Atm13oXp8o077UsYbRitKfzN4upl/5dBALbOU1w0hzAuiZA7bTKc/n7uRYSoJwKihcN2Qev1nSDtzhXbjYheYA1mwADozcMKGTGQRLPh8GTC1m54Sj3cZKtK6cp2VKm283nbN71LNi9pcc3BZMBSI4VZsRoOB/1BHVPI7t6TPbH+MJeY4hYtcrdZh7toEJWx2KaADa+xJj0G15viey55QdMWO/2LpXtk/XRjXgkYc9R36eu0T+g6ajNd8I1U71LwTVuRg3Wz5xW2khpsx4+QC0uvTCHLAI4gw5NlXUMUGfkJdUMygCbc6Xak66WJrvALgT07X3RqIdu/LHjtpRdxCJrYKLcJG2OTO6P9hzGKAnY/sQbgu2WEsFbiGn6wsoGEopyH970x1jb5xxptx3uAa0zDM6Hb1+8CuOrO9BD0U+82ho6drsPLusYfsZzYo7SXdjugfrFtsLRi0Xb+eIkYj7kLlSTPPA7O4SQd8dw1VWVSOUuMJrcP2wwNs98gO+uvZg9DR/BN6ozUlx54ytbSCZdY9TlWpEPk378gPktcrlJKfPt8/mAvbcqkaQFz5luSyQ+phRm/mRAT9bYi4pFSh5ufsERT9o6l3ddi74fAiocOs4yvmc7MEnoHyPOyuciMN+Qjyr8gXs+Am0mgRS6E/TP+ZXsHlen8lI8ZaRXX50H2upP4gCc5KRk4wro7gq2pIImGg+afCZTKyjOh0n/Lv0/2HXQdRjGzxk8d6FoK2kAI/vEP4SkKhU5dE1lOe5Ehl2FQ76+sS1DHDbMdpbjSYN7lbU
 ioPrhIVt
 wuOazmtRI89bFEA/a5VZxoxIz2lyDqEq2GDkrheE/j1hD5NwSpg4AitsHcoOrTlYuW2mFpTJbeIFkhkJTXbk8W/3B83WHMo/3iFvXNzy1ccWA6yHk2qspqM/WKv+FXxaTCMf2vOfHelcEaQrOrD9ttPu15Rn2rpE/v/aTdtsGLIaNlAlRR8A0bguOphGFvljvJKl+hNkCJ/80Xj56umDNuZrzcIuYwisIu2dfUAl57XTs40KHFWAdlMDYdiqSdapEjPDhdO0hcgBxiB2/vTwTXRXoMUs8noEegc0hYH3p34/S4nEShEh+oRAFAkHeRTyNT/0R7DmjH/aXLXlCVxDIPYqf6nRYC6et2x5gC168vX4IN/1n4hWPVWUGSpkAJ4EIyywcHAnwxzR0AcLkY+HCHjeNhrcZYn0cv8XdRTdAcYii/pYKJM2XOTn+Cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23 2026, David Matlack wrote:

> On Fri Nov 20, 2026 at 3:15 AM PST, Pratyush Yadav wrote:
>> On Wed, Nov 11 2026, David Matlack wrote:
>>> @@ -788,8 +797,7 @@ int luo_file_finish(struct luo_file_set *file_set)
>>>  		luo_file_finish_one(file_set, luo_file);
>>>  
>>>  		if (luo_file->file) {
>>> -			xa_erase(&luo_preserved_files,
>>> -				 luo_get_id(luo_file->fh, luo_file->file));
>>> +			luo_untrack_file(luo_file->fh, luo_file->file);
>>
>> This looks dangerous.
>>
>> Since the previous patch set luo_file->file when xa_insert() failed,
>> this will trigger in a failed retrieve. Except, the file was never
>> tracked to begin with.
>>
>> While I don't see anything that actually breaks because of this today,
>> I think it is a bug in the making.
>>
>> I think the below is a bit better. Although this change probably makes
>> more sense in the previous patch, since that introduced the problem.
>> This patch should just replace the xa_erase() with luo_untrack_file().
>>
>> 	if (luo_file->file)
>> 		fput(luo_file->file);
>>
>> 	if (luo_file->retrieve_status > 0)
>> 		luo_untrack_file(luo_file->fh, luo_file->file);
>
> Good catch, I'll fix this in the previous patch in v5.
>
> (But luo_untrack_file() needs to be called before fput() in case the
> latter drops the last reference.)
>
> So:
>
> 	if (luo_file->retrieve_status > 0)
> 		luo_untrack_file(luo_file->fh, luo_file->file);
>
> 	if (luo_file->file)
> 		fput(luo_file->file);

Right, makes sense. Thanks!

-- 
Regards,
Pratyush Yadav

