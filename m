Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F8F4D2ECF6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 22:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CD376B0307; Mon, 19 Jan 2026 17:44:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B396B0308; Mon, 19 Jan 2026 17:44:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9EE66B0309; Mon, 19 Jan 2026 17:44:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DAA4E6B0307
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 17:44:58 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 78A5957F6F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 22:44:58 +0000 (UTC)
X-FDA: 84350195076.08.FD26EF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9B66112000B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 22:44:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kzM1N7rr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768862696; a=rsa-sha256;
	cv=none;
	b=u2JzS2W6p195rDT/O1Ta4iK7R16oXS6wG9enHumzYHl/Od0GT2iKgARyReZFEe1yJ80nWz
	rYlKkmzWKNM6biN+ubOX1A/y6sevusGjiQGCtdhLOP3lntEB0YFjH3+iDllt39NcCWfzyo
	N8d54AntFWyynRSgX4IFsisclnWLIJY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kzM1N7rr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768862696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gm9dc5F2jfcBg4JViz581iboiF7iqo0o6V9OAwa47g0=;
	b=CSg8BlzUOvhdcTTgwQ4pkl4LD3otqlbJtSGBsOpnvVXtM5yxSOFAR2A9clvBdUiaR6u66R
	YzMEKEiOLNkPT1OxyxpcWE2i0UTBu1+LUMFOi+G1JZTH0G3mwJn9sZU5aDuhDwbx6n/FiV
	zOgqwk84d/pHH58Sn9tQgHpTDljishA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EE9642A27;
	Mon, 19 Jan 2026 22:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC3CC116C6;
	Mon, 19 Jan 2026 22:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768862695;
	bh=XoSUqnCMf3akJ4bcHDXMf3EcSxhGjttPB+TdRBpbklM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kzM1N7rr7Ang0VD4BF8ItnVdga7joaGshQyjPdaoprj+LIsVrOTh6NTLL3LcRhEDu
	 w/Ah87KxBbK/AfLbZZsTZmbZoLFgAEwTih8VyEKdS0r3gCUCor/g2fREFge+xBt5f+
	 VDmUfXrggSHvhE7EE2wbcn1Rcc3Jc5u6iWO8Hr6qm7g4Rve1G1Z/JJuSRtp5Hq8Vrb
	 XZprHzSJl9mYs1fzJcRc7Com2eFTPbivtKMflYSWPTieY4ZiAlDPJ54WfQmB2kqFHZ
	 UKZwQLl5UD/82OgegaKgvNT5bxD2hUK2GaaYOd6kABc95He3NmGFihWZHDBb17dIvJ
	 x5JJ1vqfdw3Ew==
Message-ID: <47108ae5-fc73-432f-9942-c2fe5fbf4bb5@kernel.org>
Date: Mon, 19 Jan 2026 23:44:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/23] powerpc/pseries/cmm: remove
 cmm_balloon_compaction_init()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann
 <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-4-david@kernel.org>
 <5ed94c8a-35ac-4635-aeac-3fe72d4f9c8e@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <5ed94c8a-35ac-4635-aeac-3fe72d4f9c8e@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: htdmxmybtqunq6ryzdwub18ethpkphxs
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9B66112000B
X-HE-Tag: 1768862696-265465
X-HE-Meta: U2FsdGVkX1/PTisBgriF9epLx0VHXaCj91fPiy39y0wpp9SdTxL7l+IVw5D/1IJ27EjvsV3vN/UjP2kcWQh7GAOTG21qPra5MOVP2UA2jIO/ta3ZrvTdCK2GutIirYbTDXggcs+KsOyuQlAcbW8SGwJ+JPqVIDlR8f+0ao25qXxK5ignVkKP2Cr2wNzRaRPufgsERjuRxDWGeppN6IfKOyt6RzwQmz0D/UplkhP2dsTicT9ZRRuZRt0uSOxgGJyzr1fQV+K1SvD2fSLalGsDrRCPxTqskF/CSGU4WMv5sKUKob+5hIh1oZIS+yUFLCHCdBZfv0Pxr9yhfoD76sSFTMdEacE+/etkRO0I9bKMBag8+sd4FiFoB4JHBJFl/HngW8y9oWDtTH0j4T5dPUE4SX07/gqRHAKBEQ2h/5XgXkWMjFYPbFqE22sEz9lkI1u5P5eexFctJeBhGkEX8hy6tuVN3gZSikGbTH7Uo0EqhMjwRUjRgZFMoDfcgP7xbPvcrDeMFpKFgfhKYaVmat5sHeu2FTNYTqbuYmpA67uHvvEKMTn4h4wg2y8hPVg0MsIBdCriNLkSwp4BrCQVwKhCAayDuiPWJ/0bkfeV3ylDqnlidOwpC17UqGLUpo11KHaveEQH3jAEsU80ffUEqIFfxLNWEaLXtxUnF6cHjNOr6fo0KMMomdJuDB9XiAYC4+mqdKaVfMKpriyCIEWuiQK7IZv2QxMJQkQ0cbT+CpOgDYWWARfXuttgpY4G7oAXURcFfu0fcsfU+Em6tXvgSjc3qxqrysIucwoQCpHyqfNk0xTWXMJ9pkhpPpFJtWmLbDpa7SAhDDgYo6tWIZuxNkuXPKjzk/EWn+dlya/pdV/jd6tBXpxT/DEwpJ1GNpgrCyLCeh+1wvmLq8xjG2lMW6+y8FU20bgazzbFkyAzxkPtCxJkKcEuKj1Exhs/VgZsDKmRspQQoF/nGddRVQokhZ1
 UzzAGPUV
 0b8H64SJKkhnfT/0rhctipgIR5Zk63gKkWBdLkNR3bgCuDiny1s9ZuSgjSRU/xUqyPkQP+LWgRfENDmDU2ph+vKx81mtSsREf3X8QUp8JYdfW+K+ugbdEil0heeGgLrERn2YeYNOurGaN1ERPRP6fRcAkT7ZvlKlLlkJUWx56psvutFVdYnioEWNvYgrfPR4LRivjELYKII3yX0n5tMF6dlcbc3vdDF9axdFfJIMVXzqqto1vsE/i9hXP8Hks8n3wxunz3S2Hnp+d3S+hW+y8Ho14ypKxcB8xf4018ApyOQYFim8pEzQsqEIm+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> @@ -573,11 +567,12 @@ static int cmm_init(void)
>>   		return -EOPNOTSUPP;
>>
>>   	balloon_devinfo_init(&b_dev_info);
>> -	cmm_balloon_compaction_init();
>> +	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
>> +		b_dev_info.migratepage = cmm_migratepage;
>>
>>   	rc = register_oom_notifier(&cmm_oom_nb);
>>   	if (rc < 0)
>> -		goto out_balloon_compaction;
>> +		return rc;
>>
>>   	if ((rc = register_reboot_notifier(&cmm_reboot_nb)))
>>   		goto out_oom_notifier;
>> @@ -606,7 +601,6 @@ static int cmm_init(void)
>>   	unregister_reboot_notifier(&cmm_reboot_nb);
>>   out_oom_notifier:
>>   	unregister_oom_notifier(&cmm_oom_nb);
>> -out_balloon_compaction:
> 
> So silly, I assume before there was more that happened here?

Right, I commented that above in the patch description.

Thanks!

-- 
Cheers

David

