Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F00BC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 09:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 269F56B007B; Wed, 22 Jul 2026 05:35:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 219EB6B0088; Wed, 22 Jul 2026 05:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E25F6B008A; Wed, 22 Jul 2026 05:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CBED76B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:35:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C999C03EF
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:35:45 +0000 (UTC)
X-FDA: 85015905450.25.385D171
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1AB4740005
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:35:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=StqRSIUi;
	spf=pass (imf12.hostedemail.com: domain of wqu@suse.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784712943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFy4yNyzmo3UbOv6Xs2SIMr6v8Q5AhI2ZjktcOYD0w8=;
	b=TLyEXhBlrKTPaMMtu8lMR9VzbinGV2TOJKwfD/zVcnWJZG0uTh9ZRlmNWNt2GsF3r55zU0
	r+em1JRFkW1YT584V0IanNcKRHdzdoOhbo7SER+ktAVLQfk7za00deGVUSkH9UAvyVqF0F
	H8opmt7+BDpx8iDaof5X+SkgJRsJyQA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784712943;
	b=ifJshXcsZar/dcxuLo2TDhztkiXiCPoCkTggKl86Kc9nhsrK3dxvK58IEtHcMLjv2Ada+o
	/fmVAD9cQyw2+vHWG8Z1wzu58Vw2XMYAP2Rypfu8V4hezIlDXDUBZQlzIDpWFvmGLwRTZy
	KMY8oxntmY8EqjjdPcuZwhuXHfHrlLc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=StqRSIUi;
	spf=pass (imf12.hostedemail.com: domain of wqu@suse.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-69e2266b07fso10528820a12.2
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784712941; x=1785317741; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dFy4yNyzmo3UbOv6Xs2SIMr6v8Q5AhI2ZjktcOYD0w8=;
        b=StqRSIUiVpS94VmEa547I231duS8ULqF1lOFtVaiqs8BCE9/QL5qR6x9JBPN0GUaSf
         HJNsbSgsTt64G0S2VWnda/yYODV3IrfYotaSIqTyTztNDq+UuZwyYXzDT1EGmOSgQW/9
         Wc1VasUlD4XFPbWqy+FbcE+WXPDjXbpbmgBjEwcu3aMnJyEhkA5X7g43X5rGSi8kJREn
         8a+2gSceaksLO9gDGU2tS79fcv6mktBnrCtHvLX9Vyp0kK8NokMJwRSBId1dpxvS1DHe
         eNQ19QqHcrRFD0aC83AgV7VmiXVeB4GnDYG1K56PycY/fAFXK8cy6yVQwr4ELXBDOz5A
         yBoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784712941; x=1785317741;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dFy4yNyzmo3UbOv6Xs2SIMr6v8Q5AhI2ZjktcOYD0w8=;
        b=CLXdB9tMlbFlZUG4735ipsvZa3dyj46k3HKKpojUuDNDsCiy/Fy6FCZbbLKv3by2DB
         hu9h1nYZIKBxPMRQAxDspgeLmxMRqqhWkhNa06SIqLBnjjhmQUHuo0B58bV/h1stdNIe
         CsKicxy+rMA0iIqjOiApdFHw9hXskg1jobiTJlCcmzYvoefKCkPEd3QNgDYTiKf7sUEm
         AWwyG0zaoUx/Ee9nKqzm+x0M7yZMbMIYNRxw4isVNx/eiZ0R31kiwvhZaUhLo3VhBebL
         sqQDdwRZrbI/THZFZ8WE5LH8s38xefeBt6c91HlR9BVzH0Eh08ouk14IKsm+hK78MjOW
         BD9w==
X-Forwarded-Encrypted: i=1; AHgh+RpH+YyMxZOSZUvxvn5WlpEroZZKcmt8k3DzQhDMHryjuLxkwqf/RRPl4byX2wOhoKbKkORxYtjl8g==@kvack.org
X-Gm-Message-State: AOJu0YxvB777RbS4uPlBms6uq/zhvRA3s+NItmU/kPmqyTJi+YFR5Mtd
	f4qnfluLT6LlwYUNryJshuOc1THtzkKxz3OwG7HNX1n7PHDNg6ENVSGA73lY3itvKgY=
X-Gm-Gg: AR+sD13imqAPChHdWOlyL+wgD/oVtybjAZFuvtN6KaEiGWwLUf/mjgFm/gVTxIE2Sl4
	K37SSSeNUPyE3W94e8Dg0x0Aq6fiWNsYAUqblyLDwu5hINJytzSAwVEaA70iPxc+GJeWIWxEO0E
	RnHLcjvJaKaGbuDMGQ1dy4UE10YVwEMuwVfiLmeCRoz3NBNVUJZf6ZnRwLsunrs4xrG+GtMUcKL
	kks57WXpfFzrGiOV637v6KBgNEcAlRw22AeZMBGO5cxwS1MZdgL490hTqLeraBZ+C5dr3VUbZ9i
	MadiPTJwdqFD0A4JzZU7eDn2H9Uyncm/kD0HvdlTbWOh2FtH/Augoh8Sgw1c8Qs8HAI8/0JDxca
	udGPZJ2pyhYBZ7yH9/rpyGXPKh+Dipv/HZtuklZn0TBahNqdntUUS/vU57eZxqclPqMXhOZM=
X-Received: by 2002:a17:907:3f99:b0:c16:592b:ec4c with SMTP id a640c23a62f3a-c16b46990d8mr926168866b.1.1784712941118;
        Wed, 22 Jul 2026 02:35:41 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbb8f02e454sm882841a12.0.2026.07.22.02.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 02:35:40 -0700 (PDT)
Message-ID: <8ef80fa7-6c93-40bc-8a49-bf6494104cb7@suse.com>
Date: Wed, 22 Jul 2026 19:05:33 +0930
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH/RFC] btrfs: fix folio lock leak in writepage_delalloc()
 for folios dirtied behind btrfs' back
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20260721191152.101118-1-borntraeger@linux.ibm.com>
 <20260721191152.101118-2-borntraeger@linux.ibm.com>
 <b226a6e9-fef2-49bd-b17e-9f9b015626c1@gmx.com>
 <83290932-cb8b-4741-bff0-6a7d8df2c637@linux.ibm.com>
 <224d56d2-fcad-41bf-afe3-6f5f5108172a@gmx.com>
 <f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1AB4740005
X-Stat-Signature: 88rx11agmx5ydgnp4nsyf9nmr88ym3hd
X-Rspam-User: 
X-HE-Tag: 1784712942-970802
X-HE-Meta: U2FsdGVkX18eV+uLsTPuc8PTEI8lgz4HTWb6/shJJK4Y+aEpE/y40j6vHyGZsKOTQnFcsxYxnHsmqnAuh9IzgaREklMJU1g21DrBn5l2ioamPCJ2/xks2s08Iqb8t4j+S6CBGfk++MhdMkmY9sIv2OPyEwVjcka+OjiY4TpepubQrKIDqR719Sf7us+XAjnQRSnuQIypBUISlxgEZwbR7HczK2x5aDNfr5xhnlie9Zw1iNIOM3twBk2PGg49fz7irLXTkRaUvUxja7tfoaoL63wuHlA928d7xj3xvP9PL2GDvQmhvMzzh1jboS2wzsqpLSlPPKGs/Mr1Rn5AIV5JLuQdkAiHVd2jDvd2z1kVdYU6Jv8NJk0BCPOo6s9ktoD/hFUK1cHKD2PD49r3ofChAl7UNXAVrUtCzTbIs55MwWvKYnG5sRfgNsAoCeFHyWHuLxZI4p+NcfSn5H99q6HVJdIrJX9S9m/0UDtBCJK5uhRxSmkfjz/C9vseEV7g5ratkknQKBdVQTIwWRPgsZ9fWR26a0mCeR3ecOeJnttVKzAvgO03N3AI6j+WVZdvRF6mbQ+H0sWMl/+ej/18t81YdQdOaUSBx4L8xoo8h/s9rRHY0LNh87QfYiU0ZsdJAdHoPglWoWd+HjpHwAW1Tf1jDXsiSVQ1OTLmmZHiZiG1y7BgiexLwsPvZyA/LPXR7tXeM6POJmrdzN693p57+15QrnuytghIlkWj3EQm5DmvbzXRdzAbdHkmEnxOzyu9h8yEDu4rOiodXi2Kr/tKiW+7jseVUlyNWFSk3U1LE7nY3xTj4+hX/j8C+9LIFH3gzUN8ORVoNl5D9rBqB5ErwAhuvPEkGRcwCFiZoLtWlVXt9LoJey8XGbHzvus300vzbHj4vM76fNErF2cXC+lso71VBdYG1nprbMQIQMT8VfiOhn6SIZJ9vXjtm98UaY2QbdfrvMRC0rrLj16TgDrVk3c
 4PMquxFa
 eefrh7ZibyaCQ0xiJDlDFqm3RrOAAeFuTm0ahfmHS2s1LsOZETr6fkrWFEJze50LTzYumWpwi7ejyS2EgFhZW6tB0dsxM5c/sfwkEtV+Why4Z1g0//0JzYxJ0kVBax7+RiPRJTgh+fyhxhckJ44IT8SOzNtxFDV3rv1wZ86GRdqReaVks/YUt6iHuLxZxFJlNIys937YbsWEfYnTG1KhA9EHd7/wJRGhsdjuJ/emgU7lHaHL0J8glmW4BK+jqCb+uFl1inoyOcp4nXk5nhGOTNT+sczD80YlypMc7eAne9UuzUEWmn9pcAa696CvMQM/pMXcyUdTSMKdSbXte0S3TSu0VsKw0jmEU5geCae5COzAgGsxAoZR/TgDzvi0hHnQBbFwRHqAJCNxdTXpxS7LVX1c1Ar821qF6gsYS6C0dzHNE25I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/22 18:59, Christian Borntraeger 写道:
> Am 22.07.26 um 10:59 schrieb Qu Wenruo:
>>
>>
>> 在 2026/7/22 18:05, Christian Borntraeger 写道:
>>> Am 21.07.26 um 23:07 schrieb Qu Wenruo:
>>>
>>> First, thank you for taking the time to look into this and trying to 
>>> understand
>>> things and trying to explain things. this is highly appreciated.
>>> I am still trying to fully understand this myself. A question:
>>>
>>>> 在 2026/7/22 04:41, Christian Borntraeger 写道:
>>>>> A folio can carry the folio-level dirty flag while its btrfs subpage
>>>>> dirty bitmap is empty: btrfs data mappings use filemap_dirty_folio(),
>>>>> so a generic folio_mark_dirty() call sets only the folio flag and the
>>>>> xarray tag, without setting any subpage dirty bit and without a
>>>>> delalloc reservation.  The typical source is set_page_dirty_lock() on
>>>>> a GUP pin,
>>>>
>>>> Shouldn't such folio got its ->page_mkwrite() callback get called 
>>>> first?
>>>
>>> Isnt that called implicitely at pin time?
>>
>> I have to admit, I'm not an expert on the MM part, I'm mostly a simple 
>> user of the existing MM interfaces.
>>
>> AFAIK, the last time I brought this thing up, Christoph mentioned that 
>> dirtying-folio-without-notifying-fs is a bug, and fs should not and is 
>> not able to handle such situation anyway.
>>
>> And that idea makes a lot of sense to me.
>>
>> So adding MM list for more help.
> So I now have an userspace O_DIRECT reproducer outside of KVM. 
> (attached) which gave me (on an s390 system, though)

Thanks a lot, I can also reproduce it on arm64 (64K page size).

This is super bad, as we have just removed a lot of folio ordered 
related code to detect such problem.

I'll also check if it's some recent btrfs changes making it worse.

Thanks,
Qu
> 
> [  189.067731] sysrq: Show Blocked State
> [  189.067872] task:kworker/u1665:5 state:D stack:0     pid:1363  
> tgid:1363  ppid:2      task_flags:0x4208060 flags:0x00000000
> [  189.067877] Workqueue: writeback wb_workfn (flush-btrfs-1)
> [  189.067884] Call Trace:
> [  189.067886]  [<000003a8b2e19284>] __schedule+0x374/0x900
> [  189.067891]  [<000003a8b2e1984c>] schedule+0x3c/0xf0
> [  189.067894]  [<000003a8b2e1996c>] io_schedule+0x2c/0x40
> [  189.067896]  [<000003a8b219d158>] folio_wait_bit_common+0x198/0x3b0
> [  189.067902]  [<000003a8b263e2e8>] extent_write_cache_pages+0x348/0x4d0
> [  189.067907]  [<000003a8b263ea0a>] btrfs_writepages+0x6a/0xd0
> [  189.067910]  [<000003a8b21ad444>] do_writepages+0xd4/0x190
> [  189.067915]  [<000003a8b2324590>] __writeback_single_inode+0x50/0x310
> [  189.067917]  [<000003a8b2324b1a>] writeback_sb_inodes+0x2ca/0x690
> [  189.067919]  [<000003a8b2324f36>] __writeback_inodes_wb+0x56/0x140
> [  189.067921]  [<000003a8b2325498>] wb_writeback+0x368/0x460
> [  189.067923]  [<000003a8b23258c6>] wb_do_writeback+0x336/0x3d0
> [  189.067925]  [<000003a8b2325d2a>] wb_workfn+0x5a/0x1d0
> [  189.067927]  [<000003a8b1f0cee2>] process_one_work+0x1d2/0x480
> [  189.067932]  [<000003a8b1f0df30>] worker_thread+0x210/0x420
> [  189.067935]  [<000003a8b1f190b8>] kthread+0x148/0x170
> [  189.067939]  [<000003a8b1e90358>] __ret_from_fork+0x48/0x220
> [  189.067941]  [<000003a8b2e2426a>] ret_from_fork+0xa/0x30
> [  189.067994] task:oob-dirty-repro state:D stack:0     pid:8152  
> tgid:8151  ppid:7260   task_flags:0x400040 flags:0x00000800
> [  189.067997] Call Trace:
> [  189.067998]  [<000003a8b2e19284>] __schedule+0x374/0x900
> [  189.068050]  [<000003a8b2e1984c>] schedule+0x3c/0xf0
> [  189.068052]  [<000003a8b2e1996c>] io_schedule+0x2c/0x40
> [  189.068054]  [<000003a8b219d158>] folio_wait_bit_common+0x198/0x3b0
> [  189.068057]  [<000003a8b263e2e8>] extent_write_cache_pages+0x348/0x4d0
> [  189.068061]  [<000003a8b263ea0a>] btrfs_writepages+0x6a/0xd0
> [  189.068063]  [<000003a8b21ad444>] do_writepages+0xd4/0x190
> [  189.068066]  [<000003a8b2199dec>] filemap_writeback+0xbc/0x100
> [  189.068069]  [<000003a8b2199e5a>] filemap_fdatawrite_range+0x2a/0x40
> [  189.068072]  [<000003a8b2637d3c>] 
> btrfs_start_ordered_extent_nowriteback+0x18c/0x1d0
> [  189.068074]  [<000003a8b26260ce>] btrfs_page_mkwrite+0x22e/0x8d0
> [  189.068079]  [<000003a8b21f89d0>] do_page_mkwrite+0x60/0xf0
> [  189.068084]  [<000003a8b21ffa64>] do_wp_page+0x134/0x660
> [  189.068086]  [<000003a8b2206584>] __handle_mm_fault+0x1c4/0x5a0
> [  189.068088]  [<000003a8b22069f0>] handle_mm_fault+0x90/0x230
> [  189.068090]  [<000003a8b1ebfbd0>] do_exception+0x190/0x560
> [  189.068094]  [<000003a8b2e136c0>] __do_pgm_check+0x1b0/0x370
> [  189.068098]  [<000003a8b2e243a4>] pgm_check_handler+0x114/0x160
> [  189.068101]  [<000003a8b283135e>] _copy_to_iter+0x6e/0x870
> [  189.068106]  [<000003a8b2831c4a>] copy_page_to_iter+0xea/0x160
> [  189.068108]  [<000003a8b219ff8c>] filemap_read+0x1ec/0x400
> [  189.068109]  [<000003a8b22d0a70>] vfs_read+0x210/0x370
> [  189.068112]  [<000003a8b22d1694>] ksys_pread64+0xa4/0xd0
> [  189.068114]  [<000003a8b2e13b7e>] __do_syscall+0x14e/0x590
> [  189.068117]  [<000003a8b2e24242>] system_call+0x72/0x90
> [  189.068120] task:oob-dirty-repro state:D stack:0     pid:8153  
> tgid:8151  ppid:7260   task_flags:0x400040 flags:0x00000000
> [  189.068123] Call Trace:
> [  189.068124]  [<000003a8b2e19284>] __schedule+0x374/0x900
> [  189.068126]  [<000003a8b2e1984c>] schedule+0x3c/0xf0
> [  189.068128]  [<000003a8b2e1996c>] io_schedule+0x2c/0x40
> [  189.068130]  [<000003a8b219d158>] folio_wait_bit_common+0x198/0x3b0
> [  189.068133]  [<000003a8b263e2e8>] extent_write_cache_pages+0x348/0x4d0
> [  189.068136]  [<000003a8b263ea0a>] btrfs_writepages+0x6a/0xd0
> [  189.068138]  [<000003a8b21ad444>] do_writepages+0xd4/0x190
> [  189.068141]  [<000003a8b2199dec>] filemap_writeback+0xbc/0x100
> [  189.068144]  [<000003a8b2199e5a>] filemap_fdatawrite_range+0x2a/0x40
> [  189.068146]  [<000003a8b2637d3c>] 
> btrfs_start_ordered_extent_nowriteback+0x18c/0x1d0
> [  189.068149]  [<000003a8b26260ce>] btrfs_page_mkwrite+0x22e/0x8d0
> [  189.068152]  [<000003a8b21f89d0>] do_page_mkwrite+0x60/0xf0
> [  189.068154]  [<000003a8b21ffa64>] do_wp_page+0x134/0x660
> [  189.068156]  [<000003a8b2206584>] __handle_mm_fault+0x1c4/0x5a0
> [  189.068158]  [<000003a8b22069f0>] handle_mm_fault+0x90/0x230
> [  189.068160]  [<000003a8b1ebfbd0>] do_exception+0x190/0x560
> [  189.068163]  [<000003a8b2e136c0>] __do_pgm_check+0x1b0/0x370
> [  189.068165]  [<000003a8b2e243a4>] pgm_check_handler+0x114/0x160
> [  189.068168]  [<000003a8b283135e>] _copy_to_iter+0x6e/0x870
> [  189.068170]  [<000003a8b2831c4a>] copy_page_to_iter+0xea/0x160
> [  189.068172]  [<000003a8b219ff8c>] filemap_read+0x1ec/0x400
> [  189.068174]  [<000003a8b22d0a70>] vfs_read+0x210/0x370
> [  189.068176]  [<000003a8b22d1694>] ksys_pread64+0xa4/0xd0
> [  189.068178]  [<000003a8b2e13b7e>] __do_syscall+0x14e/0x590
> [  189.068181]  [<000003a8b2e24242>] system_call+0x72/0x90
> [  189.068184] task:oob-dirty-repro state:D stack:0     pid:8154  
> tgid:8151  ppid:7260   task_flags:0x400040 flags:0x00000000
> [  189.068187] Call Trace:
> [  189.068188]  [<000003a8b2e19284>] __schedule+0x374/0x900
> [  189.068190]  [<000003a8b2e1984c>] schedule+0x3c/0xf0
> [  189.068192]  [<000003a8b2e1996c>] io_schedule+0x2c/0x40
> [  189.068193]  [<000003a8b219d158>] folio_wait_bit_common+0x198/0x3b0
> [  189.068196]  [<000003a8b26260fc>] btrfs_page_mkwrite+0x25c/0x8d0
> [  189.068199]  [<000003a8b21f89d0>] do_page_mkwrite+0x60/0xf0
> [  189.068202]  [<000003a8b21ffa64>] do_wp_page+0x134/0x660
> [  189.068203]  [<000003a8b2206584>] __handle_mm_fault+0x1c4/0x5a0
> [  189.068206]  [<000003a8b22069f0>] handle_mm_fault+0x90/0x230
> [  189.068208]  [<000003a8b1ebfbd0>] do_exception+0x190/0x560
> [  189.068210]  [<000003a8b2e136c0>] __do_pgm_check+0x1b0/0x370
> [  189.068213]  [<000003a8b2e243a4>] pgm_check_handler+0x114/0x160
> [  189.068215]  [<000003a8b283135e>] _copy_to_iter+0x6e/0x870
> [  189.068218]  [<000003a8b2831c4a>] copy_page_to_iter+0xea/0x160
> [  189.068219]  [<000003a8b219ff8c>] filemap_read+0x1ec/0x400
> [  189.068221]  [<000003a8b22d0a70>] vfs_read+0x210/0x370
> [  189.068223]  [<000003a8b22d1694>] ksys_pread64+0xa4/0xd0
> [  189.068225]  [<000003a8b2e13b7e>] __do_syscall+0x14e/0x590
> [  189.068228]  [<000003a8b2e24242>] system_call+0x72/0x90
> [  189.068231] task:oob-dirty-repro state:D stack:0     pid:8155  
> tgid:8151  ppid:7260   task_flags:0x400040 flags:0x00000000
> [  189.068234] Call Trace:
> [  189.068235]  [<000003a8b2e19284>] __schedule+0x374/0x900
> [  189.068237]  [<000003a8b2e1984c>] schedule+0x3c/0xf0
> [  189.068239]  [<000003a8b2e1996c>] io_schedule+0x2c/0x40
> [  189.068241]  [<000003a8b219d158>] folio_wait_bit_common+0x198/0x3b0
> [  189.068244]  [<000003a8b263e2e8>] extent_write_cache_pages+0x348/0x4d0
> [  189.068246]  [<000003a8b263ea0a>] btrfs_writepages+0x6a/0xd0
> [  189.068249]  [<000003a8b21ad444>] do_writepages+0xd4/0x190
> [  189.068252]  [<000003a8b2199dec>] filemap_writeback+0xbc/0x100
> [  189.068255]  [<000003a8b2199e5a>] filemap_fdatawrite_range+0x2a/0x40
> [  189.068257]  [<000003a8b2637d3c>] 
> btrfs_start_ordered_extent_nowriteback+0x18c/0x1d0
> [  189.068260]  [<000003a8b26260ce>] btrfs_page_mkwrite+0x22e/0x8d0
> [  189.068263]  [<000003a8b21f89d0>] do_page_mkwrite+0x60/0xf0
> [  189.068265]  [<000003a8b21ffa64>] do_wp_page+0x134/0x660
> [  189.068267]  [<000003a8b2206584>] __handle_mm_fault+0x1c4/0x5a0
> [  189.068269]  [<000003a8b22069f0>] handle_mm_fault+0x90/0x230
> [  189.068271]  [<000003a8b1ebfbd0>] do_exception+0x190/0x560
> [  189.068274]  [<000003a8b2e136c0>] __do_pgm_check+0x1b0/0x370
> [  189.068277]  [<000003a8b2e243a4>] pgm_check_handler+0x114/0x160
> [  189.068279]  [<000003a8b283135e>] _copy_to_iter+0x6e/0x870
> [  189.068281]  [<000003a8b2831c4a>] copy_page_to_iter+0xea/0x160
> [  189.068283]  [<000003a8b219ff8c>] filemap_read+0x1ec/0x400
> [  189.068285]  [<000003a8b22d0a70>] vfs_read+0x210/0x370
> [  189.068287]  [<000003a8b22d1694>] ksys_pread64+0xa4/0xd0
> [  189.068289]  [<000003a8b2e13b7e>] __do_syscall+0x14e/0x590
> [  189.068292]  [<000003a8b2e24242>] system_call+0x72/0x90
> [  189.068294] task:oob-dirty-repro state:D stack:0     pid:8156  
> tgid:8151  ppid:7260   task_flags:0x400040 flags:0x00000000
> [  189.068297] Call Trace:
> [  189.068298]  [<000003a8b2e19284>] __schedule+0x374/0x900
> [  189.068300]  [<000003a8b2e1984c>] schedule+0x3c/0xf0
> [  189.068302]  [<000003a8b2e1996c>] io_schedule+0x2c/0x40
> [  189.068304]  [<000003a8b219d158>] folio_wait_bit_common+0x198/0x3b0
> [  189.068307]  [<000003a8b263e2e8>] extent_write_cache_pages+0x348/0x4d0
> [  189.068310]  [<000003a8b263ea0a>] btrfs_writepages+0x6a/0xd0
> [  189.068313]  [<000003a8b21ad444>] do_writepages+0xd4/0x190
> [  189.068315]  [<000003a8b2199dec>] filemap_writeback+0xbc/0x100
> [  189.068318]  [<000003a8b2199e5a>] filemap_fdatawrite_range+0x2a/0x40
> [  189.068320]  [<000003a8b232bbf2>] sync_file_range+0x122/0x150
> [  189.068323]  [<000003a8b232bc84>] ksys_sync_file_range+0x64/0xb0
> [  189.068326]  [<000003a8b232bd0a>] __s390x_sys_sync_file_range+0x3a/0x50
> [  189.068328]  [<000003a8b2e13b7e>] __do_syscall+0x14e/0x590
> [  189.068331]  [<000003a8b2e24242>] system_call+0x72/0x90


