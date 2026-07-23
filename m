Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8E23C531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 09:45:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEE476B0163; Thu, 23 Jul 2026 05:45:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9ED66B0165; Thu, 23 Jul 2026 05:45:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B48D6B0166; Thu, 23 Jul 2026 05:45:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F68A6B0163
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:45:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D83308043E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:45:48 +0000 (UTC)
X-FDA: 85019559576.26.C58835F
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id D261840007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:45:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bVIL28DJ;
	spf=pass (imf27.hostedemail.com: domain of wqu@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784799947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9E0aa1/ah54xEiL5PB/XabSsE+mN8+R2RhZTY/b4HPs=;
	b=R8XlH2UYlmUbFJrsNgYDfEs23It8A7yM2HP9ifzUrbBtnOVoLl52gYrzgxSoS750ChynBz
	IPGqyqqavp1lqgjmPMCdQ9A/MKNlmCJ9cHnI3gpNaDI2oLVTcT6EgZDAa3rh2LYFjFO0Pr
	HW3nVAumO45tDcYVamRh8zW7I6FYRtU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784799947;
	b=LOv5pJs8BU+DpRc2DtYLZ3/sSYusbpeXDyDnVzGT9WTp2aUrzG2sBdRfG1OKu+yw5mT9bV
	fZnO2+WHOZwDJRLqymAAWy1CDAQxwyYDDogJMh01bZpADtQdSEndLLreGRUuiiD7uDOzXB
	/HekYQcG0dQbvL+rcDWWnI79kk6f9oE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bVIL28DJ;
	spf=pass (imf27.hostedemail.com: domain of wqu@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4954aff6088so3541955e9.3
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784799945; x=1785404745; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9E0aa1/ah54xEiL5PB/XabSsE+mN8+R2RhZTY/b4HPs=;
        b=bVIL28DJH7oopcEcwIOoHeSy3llxtZ6LSetAXaVz72u15tNLJwn7ObiELD6M7WA7gk
         X/3ROGeHjzEZCAr0OvANaOnpXZVUmmScY4x6hBf/x7sO5oUrpUbOei6akDnOuypLe1YF
         tS7p1+ulw6CCQewIoxg+rCIA30AjSP8fPTDdcfZT50x97cJlkyADXSvP1wto8MzwM+j/
         oJvdTmlTFfcahj6L/aFzmxhRPaw6p0jkNUnavrw4m3CSOvuJj0zZvwe6Q7rwACg0P2yq
         Rw51SLyClwjBKrMgxdua2Q7B/tyZwlz4OPmQe66kXdQgH5THpeKURA9PrtUd3+jQ+JRA
         hz4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784799945; x=1785404745;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9E0aa1/ah54xEiL5PB/XabSsE+mN8+R2RhZTY/b4HPs=;
        b=LHD1Rh4avg4nx1OBcDL04FM4502jmJ2qGXKHq3kB8NWRHEQbDQZR3I9z9VESaRuyHO
         gRbqFdOx5N+dNMbqaKwET+aRCRymhKYKaT8/CQbbHChVfz8gLB5VbSIvBpMUYZ+31QpB
         hHHFrxtq9uM98ytVrvTZDVfEvvFEWQvNH8/G+ghXAm4wZ3Hn20ahFQRl3PZzMuobVsRK
         vLu9eQBPNkKkO7B7X8iWqtLVsRtOHartHjp8oNdhLy5zr8NzFIn/lCRPO9y0W8JTQFla
         K4b82vudfal0AhFXT3RmxQleMvHJtsukGS1neykpji8Cz8vKplTGehnx5XE0kpC99nLd
         Ydiw==
X-Forwarded-Encrypted: i=1; AHgh+Ro62o7/MVvhNEr4WhLOPf4IVc4BP0cn/099g2mDQ+iw0P0GEYzlNsr8KLvg5wQO5f94VLV1Em0S2Q==@kvack.org
X-Gm-Message-State: AOJu0YyO2qnnbB+YOuyHYgNZrIwk7p60YQfEVxkLHicC4sdq7nrSiufm
	hm0wYxormtWUSWM57Og0xcRs51Y4PZX10ypnRed7UpChsTlelP5dl97Ch0Ge1y0S1IM=
X-Gm-Gg: AR+sD10nqNOYVhsckf9GOGNLQ0ZMhTasKXerwNjRjDXROKMmL++CMy+NMwv5utp+cXP
	+KyzmUB1Wf3K/2xY/8HOxLHdEqtdDC+L6CnxId6QirMdh6tz4BerVwiZ/TxVTQamJBTc1OtNeph
	48rbCcz9Mshvx49WhXvIqGV0jhbBOo3rZYwN4OPRzIZfCi1i1CH7F8abWxDltimEYdSuBdOcH5w
	Tdm+SEoeJCFAvPer4CLfaxA03mQ7v9y+UbtklBDC/I+oYazLNogrr9uK/lW67ySPHYtUrTJCHlj
	hd+fKriYN/4neT+L0cAZvYHmv4v1gkKsJIDQim4d+RC+22aTJelWFbH/s9ukXgF46F6EU5+GmkK
	bb1/q+ZpohRpa3h4loHLqBn8V3G4C6hcoF6/zdOoc5/2waLzLeu5d477yjv0rA+PYiTa8ev4=
X-Received: by 2002:a05:600c:2101:b0:495:5b4a:53c9 with SMTP id 5b1f17b1804b1-49573cff13bmr18544355e9.39.1784799945210;
        Thu, 23 Jul 2026 02:45:45 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147d47960dsm17274786eec.0.2026.07.23.02.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 02:45:44 -0700 (PDT)
Message-ID: <4beadb76-8500-452c-b84e-206c50456b8a@suse.com>
Date: Thu, 23 Jul 2026 19:15:40 +0930
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Help needed to address the dirty folio without fs notification
 delimma (Re: [PATCH RFC v2] btrfs: disable direct reads to avoid dirty folios
 without fs knowing)
From: Qu Wenruo <wqu@suse.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 linux-btrfs@vger.kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <c6dfdac9fc51c94183e51a861eec269185239660.1784787211.git.wqu@suse.com>
 <9b1d42c4-2c3f-410e-aceb-92400b8bc24f@linux.ibm.com>
 <f49478be-70fc-4cd6-a640-fb008c21c092@suse.com>
Content-Language: en-US
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
In-Reply-To: <f49478be-70fc-4cd6-a640-fb008c21c092@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D261840007
X-Stat-Signature: gd7tej63n3zaiewx1gx5586999sttkfq
X-Rspam-User: 
X-HE-Tag: 1784799946-969151
X-HE-Meta: U2FsdGVkX1/7U+NUcjj/dmHBFsIFzwJ5UPreNywt1CO/25CGRQYXW1MDW6lEB+zD0CSNz/DwOmW86pbJ8faVvQZ3BY+32U3yzAqb1NdZLSVpHQkJsCMludGLPIipbCmj2GkdD9QhH/CEns9wLoGWQXxRxu42aDl5+VH/Y4TB70v65NK/X95/U3NLyGyUpT8Z7z5bUDLvumHr35uu8HlMGKBTTR7+q3pdBKhz4tgSNJKwqP7J4Z9n8E7aH38AwuVSGa4T/lHBnqydJrUCnZChS4pph/p4goQhp8bzJ40uFelUueodjolKnEqtTFqbAj6LhIM+FaQNE114cYVW9ByQ0+g4V4iCH/gYb9HsPSZZCVGWemKv4tp+WMx0ITgpQnIqjtMM5PrWxpCTiu/G+bWDrauZG2sxaITKlL5DOTjRkB792e9eFwG554CoR8D6TmgKSprU9vO83chGVvtf3A9Ip8ikNtjjwp+5Iehgdau/9IxEMR9JYU3N9Ro5cPRoaGGNFqtyE/1m8G/lu8ezffgrxzcTEli8QZS3jYjtTfE6Grg6m7wE+L52gZJhOmUKyWmtrtLNQkdZY0JnLUZO7rC+WetkP57TDKhPnHKZbe81VTl8ZDPet8lxzJ2aI09/NUGdEVkKEtlRdyj+GYz1UXsPUvgbVLoXzfhUWDOpo3FLZ87j+dJ900VN5iGsn9WWdSfG53d895+o5IqVKiUl5i7oRRQ45FIVeSXBW+o79AM+O3hDTWF/quoLKkrGdflRs3Z3eSAqbLnPaSua8wAMG/Q2g9WjH7dSjtWsnGAzlwYYJTibDAOU2HKTkZhHX76iZzfObq1RmUhB6bZ+G+DkZO3dau4pcG7w8sqoj94JDKAW/mmJWtFa/sZW/pZfGMZV5UPnzt34Kt09XHZfY+rwd8ErZnDfvdl65NA9GiMlHhthRfYHPLBrS+X80W6UYIB5rXfH+R6+qj/wwoezaK6z4y1
 HiBxiesL
 a5FG8Dz9LX6za4B05bC+m/lHD1d2qVRCpIqr2k1fZuSYhmW06xlemoqymTaWTJJugTcYJbOrTEXOFJ2LZIHZDhcirM3du1gsJe/XSyh1H4AuEEF11dV8U8TANBf/jBAslB5zn82/UP75xksgPJkfYops+jLc7PLQTyxrquYLmpeoFp6iF5ayxcvK/i2PXZ64fYHgBGFCHFx9fTx9HBJgl7hOzsolg09mxZV5FGKqXlB7k2Vpag1EOBYl/TscEvozPngY8bDA2dz6PTGp4n0Z85uzI5xs5/30TSE4dbFV1/MjrBJPWBLnhNT2IFUD4j0gqhKugDDRwYvDB3jdTb/8sS49KlzgSsJK2JoLgA4kFYphMPJ8lKWqRM55PcZHJ/8rKHkGJfmIzoQfQDtsPuDA7B7Q70yG1PYeTAm19TztJaFWwdURcwkcN8e0CxeGhfzO8GhuclNqnU/zIEflFOcOtJgcqUDorsG1IMnrIa6rtC3N+fFVasweyt29EPALBYoBUa7Nv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/23 16:29, Qu Wenruo 写道:
> 
> 
> 在 2026/7/23 16:18, Christian Borntraeger 写道:
>> Am 23.07.26 um 08:13 schrieb Qu Wenruo:
>>> There is a bug report that a reproducer which doing the following
>>> workloads in two threads:
>>>
>>> - Direct read into memory mapped from page cache
>>> - Sync the above range
>>>
>>> This can lead to dirty folios without fs knowing, this can be a huge
>>> problem for btrfs, as even on the very basic bs == ps cases without
>>> large folios, such reproducer can screw up the ordered extent accounting
>>> already:
>>>
>>>   ------------[ cut here ]------------
>>>   WARNING: fs/btrfs/ordered-data.c:390 at 
>>> can_finish_ordered_extent.isra.0+0x56/0x1f0 [btrfs], CPU#1: kworker/ 
>>> u42:0/68
>>>   CPU: 1 UID: 0 PID: 68 Comm: kworker/u42:0 Tainted: G E       7.2.0- 
>>> rc4-custom+ #415 PREEMPT(full) 74dbeafab12c410178747d5bec9fb200ae56949f
>>>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 
>>> 02/02/2022
>>>   Workqueue: btrfs-endio simple_end_io_work [btrfs]
>>>   RIP: 0010:can_finish_ordered_extent.isra.0+0x56/0x1f0 [btrfs]
>>>   Call Trace:
>>>    <TASK>
>>>    btrfs_finish_ordered_extent+0x39/0xd0 [btrfs 
>>> 7d1ffd99bb9696179883f257e5fd838e2d1a0ca3]
>>>    end_bbio_data_write+0x1ff/0x280 [btrfs 
>>> 7d1ffd99bb9696179883f257e5fd838e2d1a0ca3]
>>>    btrfs_bio_end_io+0x76/0xf0 [btrfs 
>>> 7d1ffd99bb9696179883f257e5fd838e2d1a0ca3]
>>>    process_one_work+0x198/0x380
>>>    worker_thread+0x1c8/0x330
>>>    kthread+0xee/0x120
>>>    ret_from_fork+0x28f/0x310
>>>    ret_from_fork_asm+0x11/0x20
>>>    </TASK>
>>>   ---[ end trace 0000000000000000 ]---
>>>   BTRFS critical (device dm-3): bad ordered extent accounting, root=5 
>>> ino=257 OE offset=3465216 OE len=2826240 to_dec=319488 left=135168
>>>
>>> Unfortunately we have removed cow fixup mechanism, which is to work
>>> around such dirty folios by re-dirtying them and reserve space for them,
>>> across several kernel releases, meaning we can not easily revert a
>>> single commit to bring it back.
>>> And without doubt, that old cow fixup mechanism is not support larger
>>> folios.
>>>
>>> As a hot fix, disable btrfs direct reads for non-experimental builds for
>>> now, so this can buy some time before we find out a proper way to 
>>> address
>>> this.
>>>
>>> Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>>> Link: https://lore.kernel.org/linux-btrfs/f12f70e5-d84d-4a9f- 
>>> ac94-693be4c863ac@linux.ibm.com/
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>
>>
>> Wow that is a big hammer. Doesnt that break typical usecases (like 
>> databases on a file,
>> qemu/kvm aio+direct image files etc)?
> 
> It falls back to buffered read, which has a good side effect that if the 
> reader is also modifying the buffer, it will not cause a csum mismatch 
> warning.
> 
> Although it causes huge performance drop.
> 
>>
>> Even worse, this does not fix the other GUP use cases that still 
>> exist? So its only
>> a partial fix. Have you considered to add my RFC patch on top to close 
>> another
>> problem that I can reproduce easily.

BTW, if you really want to get everything fixed for the very basic bs == 
ps cases, you have to go back to v7.0 with CONFIG_BTRFS_EXPERIMENTAL 
disabled.

In that kernel we have cow fixup, which is unfortunately removed in 
v7.2-rc by commit b2a9f217ad3f ("btrfs: remove the COW fixup mechanism").

With that feature even if the folio is marked dirty without notifying 
the fs, we can detect and later re-dirty them and do the proper space 
reservation in a workqueue.

But again, that COW fixup mechanism is not well tested (I believed we 
shouldn't require it and we never hit any reports about that), and can 
not handle large folios or bs < ps cases either.

Furthermore it's not an easy revert in upstream, at least we have a lot 
of involved patches that are removing the cow fixup code step by step:

9bce95edb1b4d2802de9273b5170bfcff3090d24 btrfs: move large data folios 
out of experimental features
115421e29b845d521e3dc24b67d83e8695f621f6 btrfs: remove folio checked 
subpage bitmap tracking
b2a9f217ad3fa8012940744059956b20a3971135 btrfs: remove the COW fixup 
mechanism
4927b141877c35b1af4e32c7876cd2e0a0f16196 btrfs: remove folio ordered 
flag and subpage bitmap
aea704836e47decbdcac77872385c9a3fb51da42 btrfs: remove 
folio_test_ordered() usage
7d97bdca4bcb0e36b2d1251bffac3ff4e4e09c8c btrfs: use dirty flag to check 
if an ordered extent needs to be truncated
095be159f3eb4670fab75f795ce9539a381ebd3f btrfs: unify folio dirty flag 
clearing
b066155f06eeb4d6d696668cc58b6101adf6c1c2 btrfs: detect dirty blocks 
without an ordered extent more reliably

Not to mention there are also quite some conflicts with other changes.

So the assumption of every dirtied page folio is dirtied by either 
buffered write or ->page_mkwrite(), is really the core idea of recent 
btrfs update and the basis of the subpage support since v5.15.


I do not have any good idea to go forward.

Full revert is hefty and can only handle bs == ps cases, subpage/large 
folios are still affected.
Although I can revert the large folio support, that's a pretty cheap one.

The RFC patch from the reporter is not going to address the very basic 
bs == ps cases either, just check the OE accounting error message in the 
commit message.

Finally I do not have enough mm knowledge to address it from 
mm/block/vfs/gup layer either.

So any help/advice on how to address this situation would be very 
appreciated.

Thanks,
Qu

> 
> Because that doesn't fix the problem at all.
> It's just masking a corner error.
> 
> With or without your RFC, on x86_64 with large folios disable 
> intentionally, it still triggers the OE accounting problem mentioned in 
> the commit message.
> 
> I believe if you switch an older kernel, or disable large folios 
> manually (reverting commit 9bce95edb1b4d2802de9273b5170bfcff3090d24), 
> then you should hit the same warning on s390x, and also fail the 
> reproducer (error out, not hang though).
> 
> 
> Again, dirty folios without fs knowing is the root cause, your RFC is 
> only avoiding one symptom, all the other problems are still not 
> addressed, and those problems are not any less serious than the hang.
> 
> Thanks,
> Qu
> 


