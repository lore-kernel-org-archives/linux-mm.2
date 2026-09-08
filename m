Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D7E2C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 08:32:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DED26B008C; Tue,  8 Sep 2026 04:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7689A6B0092; Tue,  8 Sep 2026 04:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6307D6B0093; Tue,  8 Sep 2026 04:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31D2A6B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:32:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B23CE160453
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:32:42 +0000 (UTC)
X-FDA: 85189928964.14.4B2F374
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id C507580005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:32:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lLzQG5i5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788856360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vRu051t1h1A6nzfqSoDX3YwLGwKiY0jwf7brkaReOLM=;
	b=78GOSXVKCRNTp4Mkh66z/mhkcI2rXFA6PqDrevoqe3CRtdiP7QrFjtCnsJB8e455k0pppt
	VjzEpjnp3KsgAOZEKM3sNIilS4oyELuybJlBktjY0ugfKM4of0GBUd+nIJihsRv59hUMoo
	b78h2dSTJQvLVl3y8TvS9jDtB1/h8EI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788856360;
	b=CYJ3UXC4P8cUnu8gggixpBgSURr2xK1sfLCf/27oAb3KhblVCDhLWobzMdeqtgVySHHYpw
	bs/70BAMywfEodVE1Wv97zc0h0b1tT2qjxHv1wOqdkqCTGDONtQs5pWnMPvCaLWWGg2hun
	ToUlqIUh3Hq7IFaxYdA5ynwbe6t1M5I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lLzQG5i5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48436251906so4918360f8f.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 01:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788856359; x=1789461159; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vRu051t1h1A6nzfqSoDX3YwLGwKiY0jwf7brkaReOLM=;
        b=lLzQG5i5dZ4W4JwKXZkHebhhlx/X3W7IuE0QIVvs0XrcpS1us+5/EZxgR66aCI9LOv
         cVYyT5t3Vo7S7M0kizW5yktEBu+iQm1QtRbQA0B1llab6SDJ2GGcLqqytq7dYfclzbDk
         KfAkbmm4Vpp33SbOulCPhYCCoI7nou/yKeag66YmJVupIrzaGWIyWRdeQB60lFdATR75
         iB8Ed2MBteE0q8J9nLH6ZVVwOVDZcMLU355u0xe2febIizKnCJjbwBUC2fiUbkUk8NAf
         4eUk0rxVwSc/jy7vevEn2pKapqZqPGGunUwp0+f/7A9CCAW81T1oIMMON4ySojpRGXVk
         CmXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788856359; x=1789461159;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vRu051t1h1A6nzfqSoDX3YwLGwKiY0jwf7brkaReOLM=;
        b=W3/gtq6mGMY92W7HDVgBLvFxuG49XhMCOwKI3IqaXuCOTYPrWW819VHpd09Zfs234U
         qhBrwzRkwn/mXkdvQbvSMClN2BqkZe4xRsws0UAp/1hXsmocDLCR3SlScSJ/2fLJ17or
         NdToqEVFVf6C0emeLDlsrSeN0ihrvuc+YtZSZ0dEacoWjHhj7Men97cWDV7K3SFNS16/
         u5NdvwNZy6vqauJO970+qPSpwRlTZlIxhN0ehzNpW9pYjo9wyZMEynY6PrHHNIPHl1LW
         sOvoB7jF2Y3pUiEZkJ3yEUR5ptZzQ8Heoa9Epv8tdGG+31fFwyxndIt6EobDfKLuVNB1
         tzwQ==
X-Forwarded-Encrypted: i=1; AKwUvByXJNTxd8WSfXNFlmOYSBzkMaMPSC21Bn86U9lyeAIVrDD0tBqUAEciN7F0nO9xPU5QhD3Ig3x2Aw==@kvack.org
X-Gm-Message-State: AFuF++ljyF8XRSZdLhLTXF6rlSPJI12D7Il0S2D+2D4BGp4smBz6NlW4
	W/rxOZFsSPQoBwMRGRBattNdhSXdbnUuBcLoLyKCL0hNWFIAtiBHpV2M
X-Gm-Gg: AYBFou1FCZ8r1GGGHtFLpdF8HZy4J3Y1Lmi59ey6TUQbXQ1eJDT4P0NgbcC6VDFhFdw
	xqcVp5ue0S1twhLr6yFi9rY7Wrz/uCeySyX5/VJBLVS5ws2ztdZnnzq6Q80UEgZrTT4CckICEtr
	CmKODXaIetQBdRAIpN50mIz5e+JEzBTKC9RQZW2kluBNSW+L4E9qHYtx/qHtlZIADGzjIJlLvhS
	e6W2IhkqiK/AIHwbJDNPAC9PFRIKbDTD5N3TZ85ToUdKGV1XhvimSZvcxFXjBcL2jMuEfkWYNzX
	taEKFXezBw8tAnoafwuRL3pTZjrE/xUgBul4E7jpzFSj1TaPFAbBycjN2yTmPh74Ety/orjW7Y2
	rlGJ+qXIhUeVBVUqDbfA8azu8I5YOBdK1Oc5NJO8B9uz5NtJu2DmTGFhRvdrxUHEGRe+tfxLT/x
	KOOJ2icusjliciIWZL1Zi/uTEC5mbktS7B2LbKsHDKN67bOsxzscth+V01FTc5EkqTSOKcDLjVQ
	soiigh7qKaGdS+PQRyt8aWD9sTqIugXB89Ndz/YAS+4wtMh0uRbq/w5WVkxCxB9Yzb3RfTj9td2
	RttWMOJpDpi4tUacOER+9FsbxqERRZmq6ouoYrbGCjNMx1aqzdDw6jlsmfBszviIX2gkSNY1DS8
	Q6ifsG2Y8cOE61fPqXrNl0v9DNvnPVmC5YA==
X-Received: by 2002:a5d:588f:0:b0:485:847f:fd9b with SMTP id ffacd0b85a97d-48586e4a62bmr48379038f8f.6.1788856359104;
        Tue, 08 Sep 2026 01:32:39 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858d312ca0sm35535684f8f.4.2026.09.08.01.32.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 01:32:38 -0700 (PDT)
Message-ID: <9fd0ed6b-e732-4485-a7b5-0380b07d3fc4@gmail.com>
Date: Tue, 8 Sep 2026 10:32:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: remove unnecessary ret variable in
 ocfs2_calc_xattr_init()
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Andrew Morton <akpm@linux-foundation.org>, kernel test robot
 <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>
References: <202609040247.8B3lmoqX-lkp@intel.com>
 <20260907132202.48834-1-krystianmkaniewski@gmail.com>
 <b63bd2bd-229f-4636-9c89-8f1686ab087d@linux.alibaba.com>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <b63bd2bd-229f-4636-9c89-8f1686ab087d@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C507580005
X-Stat-Signature: 51qpwgtkm5qqjubbc9y1xthcczc9axzz
X-Rspam-User: 
X-HE-Tag: 1788856360-170741
X-HE-Meta: U2FsdGVkX19DODxiC0Yhc5Wj7Ws7jNdiZZ6aKGbQ3ZxCjF73lJZp3R7qKD2hIbBo7i+5fdpB4bDl+MRgoW4F5wHG+4sYN07XtfY8C7nvc3xsCTmn7NIsg/R+iq7rGPnT59RnvHgYlsp/Ni7/dGP/+wciVCFzXIHmszbpru0LFZqeSjbMh/5xzk90bLBD7BKaLCcwyDSvoaYYEefFanlv6qi33jVOwZlO18X3KPETExfKC9lXvrD8prsW0TqltY/Ks7prWCoXsicII2Z3BfaZHgm+m9F1YQh2ZGuWjEB8ZFnx0MwqpflPWyN+rLgMPkwV9j+XH5Dbiu6ojW80NFk1f4KDF+cCBKEhkqWTDTBD/UfcfAFo52lOQUsY2MSWs41FQdUDf/Q5zG8Xa30+qo8bDrEUCPs+i7d+2XZ8eBYrvLswaMOybDP07jRknxoepmydCxBbzKgggd+o3pC9OpBZSU/QFxr37HOmtna79S292vDXX4f6vd+r6TmhAGUl5EQB4ktO4xlpI/TCMWA6yoPJko5di9xUQWAVyqLcGpOr8o667xj+Ima3i7d081GPZ4+2FxO+KtQ9ZuJ2M9Cghm9A/P6VCuDzCeXTBur83wjB3QCw6loDUgzFLAIYaNdL8yQeTRsQlrC6bXPj3rpioPBTxeCx0BouNW1LwR4QI/vpk+uTQEf7kc0kBsPwJMnGzWXA7Ed+5xe5piQvZvSlqugh4Svh+U/OmJRzRjp2bftGCgs/J7UYWaoTfQwm8M0M6efXa+Hg4qhWU5PcMCtdA8L/fJo3xMcDxw8LhaIbN4bv3X+07ynfQ+wBmmjzmDCYhFtfTtZ/MLJMaE0C64Yw2zVT4vmN7jrGJgcQd9I+9D9dPhzivIwtiucOBIg7GCxsQzZbhI0kcpyElRAERjGZ2evay3ldJYHKpvCdTXydWWmWA9hv1Itn2bpB4e99+bB5Gqeie0/45O8ZFI157OPdqhg
 XdNmf8FJ
 eH5uxtWtatQbXAFP5m/K7KVqh8gDTo6VJVhqC12IQqumePuWHrIl8jwt0MDEq4eQWIdhiIMxaG+6+eyMu5Bos8fDg4bAO5cP4itMJ5LtZqyHYQjiwlk7VaBTZNKqlaUcil2R9MmXMch7VmGk5uvxcp9ZkFHLd3ogZp3oaekulkz0KF+H2XkubT65SeUqP27PJEY/1oMF9pjJSWvamyobrYX/2LRczCfG8JL+YK7dJY61Tlcerpnb6HpPaKi57BEOzvVXrr3ssiugFFLqlkv4F1jnzQLU4FgkFASKYU+WOKKNQ2quHTjMy6vN+FlptO70pLMEJ1PoWYGO8HH613lfcx3YdDeryd4rkkej72VWhqJORyHNeZBWdX+Kph6Grijj+Wppf6IF7/sTODSYWmL+/O0GDWlP+I368Uw2hBDnriQyI4Z78VRtNfU+lBCkcOB73FrcXIblfYS8/X0Rrtz3K87R7LsMzTTe8dFT/4gjd6cnAZ/CfBzFdOKLuC6lqqaUrVAlYyhy3d6+JDD+ZIrth9zt20r+vUEDyZExHQbeA2CZccMs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey Joseph,

Thanks for letting me know and let's drop this patch then. I've just 
received an email a few days ago after my patch was applied to upstream 
Linux and there was this finding, however I didn't expect it's already 
addressed.

On 9/8/2026 3:23 AM, Joseph Qi wrote:
> Hi,
> This has already been addressed by:
> ed57836ff300 ocfs2: make ocfs2_calc_xattr_init() return void
>
> Thanks,
> Joseph
>
> On 9/7/26 9:22 PM, Krystian Kaniewski wrote:
>> Commit bd7c05fb4a47 ("ocfs2: fix circular locking dependency in
>> ocfs2_init_acl()") removed the only code that could change ret in
>> ocfs2_calc_xattr_init(). The variable is now always zero, so remove it
>> and return zero directly.
>>
>> This fixes the reported Coccinelle warning without changing behavior.
>>
>> Fixes: bd7c05fb4a47 ("ocfs2: fix circular locking dependency in ocfs2_init_acl()")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: https://lore.kernel.org/oe-kbuild-all/202609040247.8B3lmoqX-lkp@intel.com/
>> Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
>> ---
>>   fs/ocfs2/xattr.c | 5 ++---
>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index 35bcbb0ff607..ab3b645983c9 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
>> @@ -640,7 +640,6 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
>>   			  int *want_clusters, int *xattr_credits,
>>   			  int *want_meta, struct ocfs2_acl_state *acl_state)
>>   {
>> -	int ret = 0;
>>   	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
>>   	int s_size = 0, a_size = 0, acl_len = 0, new_clusters;
>>   
>> @@ -662,7 +661,7 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
>>   	}
>>   
>>   	if (!(s_size + a_size))
>> -		return ret;
>> +		return 0;
>>   
>>   	/*
>>   	 * The max space of security xattr taken inline is
>> @@ -729,7 +728,7 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
>>   		}
>>   	}
>>   
>> -	return ret;
>> +	return 0;
>>   }
>>   
>>   static int ocfs2_xattr_extend_allocation(struct inode *inode,
>>
>> base-commit: bc35965f6940a9bf834d54187b6088b8eb09206d

