Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2FDECFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 13:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5D8F6B0029; Thu, 27 Nov 2025 08:18:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B34AD6B002A; Thu, 27 Nov 2025 08:18:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD116B002B; Thu, 27 Nov 2025 08:18:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A6B66B0029
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 08:18:08 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3957113850E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 13:18:08 +0000 (UTC)
X-FDA: 84156440256.03.B5BF2A7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 90DA240011
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 13:18:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=P0H9HpGh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="G/+h9gm8";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=P0H9HpGh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="G/+h9gm8";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764249486; a=rsa-sha256;
	cv=none;
	b=HJznbd8mulxZIjdiokNXI8ZgR1jU3vKjlpMwzXmDrm4YH+7iUf+AilXq2+ET2MOCnUusmv
	tFLztHdeGzGdg3ympUyuyCe6qoX565wCgkaGtmP/TiqmP6bRSzE57tdxeHqgH2TUKu1Fbi
	VWHwFVCG2guAZeQyUlHtxvZhScPgxoQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=P0H9HpGh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="G/+h9gm8";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=P0H9HpGh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="G/+h9gm8";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764249486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nl3RvlsgL1Doc36smv6M7Hh+DbNIw3VquMXV65wwdek=;
	b=pE75spvU9Dwp68eL0zvnhFmCoUBic0wjQ7rsuxzB+RDtcux6m+xWrBtwNCGckE8iMALFoS
	lj15Ca0cGEcBLT8vOVd5jyZHOog4OfMP5NMTEBJqhfP1tIH4QT4bak13k4RaqqQbFjFCcg
	yWMfrK6NYJLnzsE1FVhayoiEIAYV1Dc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 51D225BD9F;
	Thu, 27 Nov 2025 13:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764249483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Nl3RvlsgL1Doc36smv6M7Hh+DbNIw3VquMXV65wwdek=;
	b=P0H9HpGhtTYxk4RiA3cxPpmxZ/8Zq+2ZlkS5WMfWYoG0SE5SPPX0MHDN7aGimq3e491n9M
	Z3RRv5jrOruK9QR99dGC9HpfQ+ihGNyRWyf2t/wIKTY24/Awup7/QiSAe0+Cd5nr583TsU
	y1hhnIk4RsiCrPuGnSvJaEXinYOT7SQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764249483;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Nl3RvlsgL1Doc36smv6M7Hh+DbNIw3VquMXV65wwdek=;
	b=G/+h9gm8UFfa8MI+tjoU7cWHzzUYZdfXDtWumvZfP7dOsFPWbm+DAfDca0POzZ9tlVZtY2
	X+jmAIe6Aoe7wkDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764249483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Nl3RvlsgL1Doc36smv6M7Hh+DbNIw3VquMXV65wwdek=;
	b=P0H9HpGhtTYxk4RiA3cxPpmxZ/8Zq+2ZlkS5WMfWYoG0SE5SPPX0MHDN7aGimq3e491n9M
	Z3RRv5jrOruK9QR99dGC9HpfQ+ihGNyRWyf2t/wIKTY24/Awup7/QiSAe0+Cd5nr583TsU
	y1hhnIk4RsiCrPuGnSvJaEXinYOT7SQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764249483;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Nl3RvlsgL1Doc36smv6M7Hh+DbNIw3VquMXV65wwdek=;
	b=G/+h9gm8UFfa8MI+tjoU7cWHzzUYZdfXDtWumvZfP7dOsFPWbm+DAfDca0POzZ9tlVZtY2
	X+jmAIe6Aoe7wkDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 235263EA63;
	Thu, 27 Nov 2025 13:18:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DeFMCItPKGlyRAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 27 Nov 2025 13:18:03 +0000
Message-ID: <cec33567-57cd-44fb-be9b-1bc86f9b30bd@suse.cz>
Date: Thu, 27 Nov 2025 14:18:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu()
 operations
Content-Language: en-US
To: Jon Hunter <jonathanh@nvidia.com>, Daniel Gomez <da.gomez@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org, linux-modules@vger.kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 Lucas De Marchi <lucas.demarchi@intel.com>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <0406562e-2066-4cf8-9902-b2b0616dd742@kernel.org>
 <e988eff6-1287-425e-a06c-805af5bbf262@nvidia.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <e988eff6-1287-425e-a06c-805af5bbf262@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 90DA240011
X-Stat-Signature: ta1gp3z3tdcx5swapt1k3xm75ye8agmb
X-Rspam-User: 
X-HE-Tag: 1764249485-412822
X-HE-Meta: U2FsdGVkX1/5PrWh+jmrdAwZzitMZaiBcHdSTiHicUisOKoA2vDQIPmR2ZLsXSp8SnBpc8DYRDtnPL/sZB2HzuId8lUw3o+GuPLqf/AWrfALCQPCv5AAtfaxdVWckyBVXS6Zg8s8JT1eW/aTfDoC5qroLUKLJ8cfs46V4pY/b1xrL+gME+eQArv7Vxn/R7cUk6eWObqWdi1IzPKUtx/jIvr01Zog7JCZUxyfLGvNo7Ef4yPB4IlFxap2Aa3eE9GwbrXzjFd4Fjq+1v38hA9h9Cs6RrljkNQq0F8yKSUeWx3Z1wro1S1BBIJDJJU084+W8698BJV9Saicgb6vhutE4hQgKPRNiXswb0sssZ2v1ZYtZNOoNFPjb6TesZwV/CtoYKgbvE1xlDCF/iv6lBPojt8o4KHYyQxODvBvkcDG2xt8Exw9LhaeG5ZfXjvEsZNsvZLLzQKeYKP956iwif0duSy1+wDOvlB8mPgtpDkBOWJg0R4YIpNsoRbhoAsQP9d1ctmLLZIbUz//A7Of+CSChVUTSAkPlSFiBkwXNe0Ek5bRa/XLuTCU7sU/eEzHlHqQ0m+Gq1yLsQzLPy8Jh2ljpMTfYBlMuqgnicaIoCLPVuR85OLdVbBeGe5OTcBPVXu0cjOuzVKLCMqxQwkHwk8XL+BhtsVdg0ijm73Ewj6d1ci7ix7wbCigvnPGRiW/uKCWWx2QJ5PBzi71tqgQutVJMWNw1lCpa9JAdn67nntjga/6YbRv7oplOl90beIqIm2YQ0mLmL2iZXjZ+NiwK6ifeI/ISJ8P8jPk6TuBQz+ZTiX2YL7fajV03BG/UExm48+n7xiLHr9LaI6ZSNOUC2NcswNXHMd4ACdqUpDNshVLAM2vSdxZTE8NL7cwZsHnqD7UD0D43LuLBWhq9d8CbzyLLcW7WpeFkgG8dlU3Lg6Hg+/4uGV++Y2dgji9i961SAUw+9iM+Hhz4ow9Syy/KAm
 JZb8H8R2
 Ud0SV5WDfpD6YO0vnW+T4agJbwE945X5DcEEnltMP1I93O0YWLSRr1QC4IGfNEhHkAFoVMH6iz1wLbzpq50CBeLToYHxD7zqn33aMyTfB8nnATyhiMg9lHYP587rO4TVctELp8ap26Ni1NQ40RUIz93rqRI9mt13ivxc6xj04PRefNplfuIQh5TE/npzGoKVtjQkvKsBC9t5epEr4XPic+Q9+70DCSy8XyUy2Lkz39Tv0Ha/ETyItzGXdQOP1/gQNNPl791iQeNGLMGlp7h/LyS7mqu68PHhR1FXTJkd3R46R7pNOzZTJkcFqux13A6N0aYqtYenvBfxmlGJNHkZDRWEWTbx5BQ+oLlAOyDdf8lKWxIsQI9v3rn4/yA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/27/25 12:38, Jon Hunter wrote:
> 
> 
> On 31/10/2025 21:32, Daniel Gomez wrote:
>> 
>> 
>> On 10/09/2025 10.01, Vlastimil Babka wrote:
>> 
>> Hi Vlastimil,
>> 
>> This patch increases kmod selftest (stress module loader) runtime by about
>> ~50-60%, from ~200s to ~300s total execution time. My tested kernel has
>> CONFIG_KVFREE_RCU_BATCHED enabled. Any idea or suggestions on what might be
>> causing this, or how to address it?
>> 
> 
> I have been looking into a regression for Linux v6.18-rc where time 
> taken to run some internal graphics tests on our Tegra234 device has 
> increased from around 35% causing the tests to timeout. Bisect is 
> pointing to this commit and I also see we have CONFIG_KVFREE_RCU_BATCHED=y.

Do the tegra tests involve (frequent) module unloads too, then? Or calling
kmem_cache_destroy() somewhere?

Thanks,
Vlastimil

> I have not tried disabling CONFIG_KVFREE_RCU_BATCHED=y but I can. I am 
> not sure if there are any downsides to disabling this?
> 
> Thanks
> Jon
> 


