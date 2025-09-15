Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04CB4CA0EE8
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 01:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AE8B8E0007; Sun, 14 Sep 2025 21:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 538018E0001; Sun, 14 Sep 2025 21:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FF958E0007; Sun, 14 Sep 2025 21:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 260A08E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 21:57:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC240119E61
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:57:27 +0000 (UTC)
X-FDA: 83889822534.03.B8BA9B7
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0C61D20004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:57:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a9idHMS1;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757901446;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PsHWln/yLUYE/Ay+sDTHPpOlLl2d2kOQXkxw4GwMYto=;
	b=mpO63hi7Nvc7dy2M9nMszpykPE+SeYPtiuqEcdnY82gAcqJecQpuKgHjbNM50HeN84gziF
	iTcH5eDz2oBFa5NzaqW0gih8eNU+s/hgv3kK1djb8HUBSiWVeaeV9ru69nzGD0MqvEmfsm
	Xn8PlXOQiBxjo9oO0Sy++QulP7dHpnw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757901446; a=rsa-sha256;
	cv=none;
	b=mA+5lTDUF9fAEhp+iDsr1rIMd99bdomOJKxGmGMXh+D6S5o5YF0ehzFe03cVX/OS/pTTx0
	1nJFDq2CGT6k6MqlzjNr/o1hS5Qxs9yEl4niu71LYfHy8jfZEIXkh47hSMDgb41a3sUL+J
	RN4S/ayVKhEUjci0MLF3LxaW6vsLPv8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a9idHMS1;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-627b85e4c0fso5801380a12.1
        for <linux-mm@kvack.org>; Sun, 14 Sep 2025 18:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757901444; x=1758506244; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PsHWln/yLUYE/Ay+sDTHPpOlLl2d2kOQXkxw4GwMYto=;
        b=a9idHMS1wg7uxGpxTXqDx47+XUQBmMRB6rv4iTFdv6P4qms4taDgA0cXU7A6/xItBS
         QTqjBMzTpRZOA4Yqhein4nl91G+Zx3eQBfcx/X27jhJ8WQmMQjArNEi7hV8OVM3hwaEw
         DP7K/wobc2m1aUaXVDRcRuSsKVWeZu4SB693av+dS0bbFhkfxQUXlEzJofb4FtI9cOmD
         HyUtpmP0ZCXcMQF77DMdEJlzxNp89trr0J5qRh2AuhsbDF8PWN8ddtr/zx0vFW5IRw8N
         0+ARfv2pHleDgbIh8FlGteJyG2BKztuMqwliOBDbEBIPK5PbhNcX0FR0s+/lvBdhCvnh
         V7gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757901444; x=1758506244;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PsHWln/yLUYE/Ay+sDTHPpOlLl2d2kOQXkxw4GwMYto=;
        b=LnAMzcoj2e1wkM6IELfEu8WrFCpaJ/iIBaZvn0WRGyWd7tDcl1JxMy9yk8nbSs7xt6
         nKDXzUAvo3J7rxDjhggZb7h4ZHObvpKoTLryzyaqqO4xaY0jHnhuSeu60COxojVHUF/x
         3mFRE3aH2wSa9LbprYFGz53Vj/SeuUtGTJOjCu46JqO++jlvzJE1NQ3KbAO8nUZKUfai
         kRkWLgLINnwYWxeSwiH2WsNVNfLH3gRyU6azKIBfylHDz0nxilRoYMTbOPibqKVBj540
         9iATiBwFzah3Gqmp786U4uJUOUs6B73g2St1YLS1X4l1APZGkAjDYSvtw3BTZLjX1nQa
         E2SA==
X-Forwarded-Encrypted: i=1; AJvYcCUYfOoTs29rctRBOqhPQd1cc+XlYHyexHHwUGst5QWWiqsYbDN3bgFV0AnEFAGVSgMpgBTAyz4+Uw==@kvack.org
X-Gm-Message-State: AOJu0Yx1g+oq1EV1mossouHh4ooV3gTtpEIAUx82/sChpGycDSuJzx99
	bxa9Lk3+ZcPmu53z57g6a7YAl7FVOnQ+3+sINDFbxSPaP2a0+vQwsiOC
X-Gm-Gg: ASbGncuJ4EOiMoELvFOe8uflOpIl3QR5/VVAYuikXpXpb/ElOja7G+ITTy1o10cSMKv
	WLnqnLqrLQCbhUb0ov97Be/e/kVCsdI1ItOFtWf6KOpCi4YR+gVa89eppJ6Kd+OF1LTJ7zBaoW8
	6Xx10V3Cb4eZAPzcKMGRt15n+PpHkZqEk+7JVqCqgz4Vv5yeh1pDzKCIiFB/4aWuLLCFdp+S1Wa
	2JaP6U7TthMGFOKoM+QwV7jkgI88f2D/bgfVHG2N+KwC+JQNGKwKZ8O38GrmB1JEO/eZBCU25ki
	YAayOEWFe45k+f+9cRvY6w+xcap3Sh1XBra7NpvbanemhtYwN4oCQhis+hMbTS/8lLdOYZ3avci
	49886R+k5prhe6AtS1JeTimrcSySYQsTL
X-Google-Smtp-Source: AGHT+IEyJsq16W3JdE7KvZoVJSBG56hkE9buj1GfouR0R96Y2DynbhCjKQ7xYoaF0o5WflmlMuovcQ==
X-Received: by 2002:a05:6402:504c:b0:61d:9a4c:1081 with SMTP id 4fb4d7f45d1cf-62e7ad277aemr13978209a12.10.1757901444263;
        Sun, 14 Sep 2025 18:57:24 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62f28b873b0sm2576865a12.14.2025.09.14.18.57.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 14 Sep 2025 18:57:23 -0700 (PDT)
Date: Mon, 15 Sep 2025 01:57:22 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>, Wei Yang <richard.weiyang@gmail.com>,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com,
	akpm@linux-foundation.org, chengming.zhou@linux.dev,
	npache@redhat.com, ryan.roberts@arm.com, xu.xin16@zte.com.cn,
	baohua@kernel.org, Liam.Howlett@oracle.com, david@redhat.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
Message-ID: <20250915015722.z4w23d6ralc2y7mk@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <ae30fc02-c573-46bc-a5f6-935f256149e2@arm.com>
 <cf5d6ff7-faa4-469e-9e32-b90c75b8194f@linux.dev>
 <463716f5-be12-4d78-9432-779e3f11460c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463716f5-be12-4d78-9432-779e3f11460c@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 0C61D20004
X-Stat-Signature: kx6jtnm8rgybqdk54wsg4bhquxuuz9zh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757901445-35494
X-HE-Meta: U2FsdGVkX1/Wul4W86G7cn3P3qUrupkl8BDhVrFRV47s5IikG4AVDEgCiroYua58U9s25gAVbpbt2wQ5g5VYZkVSuFtDqAcNYKOq+AOkfMSg/xiJcrx6a5qxc5nYazWLUsweltL+M2aXvf+YOVREV8CHM8NRAjZhNkJS7sg5HGb+ucA+OMdRPEArrvrTjAyeJuC0upxy+BTOZM8GR41PU1PAB9qCEDhm24OyiaxbHg7CHzZsGuIBn6wCuFdFepijlVpp8u7rly+OYbaNQK2+sJ9Nk0T1kONREcA0GyAK++87e96JoKs+JrWrACldehen0+dLDlampgrpdKtNo9QDeItW7EQryDS0eMYUaNDrIyjbMAPtVB93txNsjp02SXiDJt8DN11AALpbJ+2hKjofRw5D7dCMvBWc1INVT8sqPWbhbgXQqfaO8jk8YWdpSsc+3tw5uMi/glkPba7uC6m0YL4aR3HMq2i5oYDCaZvgQSX4IJhTG1lhJozQxPJfpGynrgVneyG7zpMgWfixU5+ayHAeDZOrdyU5SIgV2g7SB6rZmyXMalfMChZtuWtJgJ4FDPzrw7o1Qp/6yTne243NsGRqrEoSuGpzzkTbv/JAKEE+v8HUMb2Foy4za/lutUdo+eorfqNcMa+7FqF/TunxRl6GKKjz//xIWqVDVyIIdFhmI9OEeERLsUGAn2Tv3sZZ3HtmaA95WiU4HvA80mURu1JrATxa8CvftfLtnJ0aa689mBh5IHzKIwI74uFjBe/e45Fwt0uYpng9+9YPEoNF3mqc25oh37HN7T6ZZjzq1taznlmLDqYE8mRtnCFwXn+5f3sg1IvoEopWufXJulNaneJNvIydtJ7lkc+MPwW3Ip40AFcLqBzCUiOyxqzFiv47SnFLreY/i1a6F83ZEOT8eWeRgOGgXp8q6y2qDN4tGMosITRpzzkV7ZtYOoM03gIzJtt8jpNAKFtNOHygdu/
 hcramRZY
 069NmyLVppVMXcq/cnU63hCOdXl2yZO4KplRfC5hNsjQ3hZ9rqvD8zpEYWQwXZdsTmpr+vNdvHzCN4O7tJViRES05bJIqHRMoYPH/58/Rr3IOXgOBTufVqytm9yF3a5yOSQR+gCRYjOHCTHFf3OlOxqu9R+YBthW21ji4Yb2h9AinEG+fBw9jNe/lgoI2v8M1Cjc85j4iSgtCbTHKrlrNz12sf6lb+7zEssP3jtgPe4KZ0xgFDaD3HplwAHC48BukcWpB88omWj+qJV8mOd4p2xomNVMsAp0+zItwQwRSdZjsce3e5pyoGXtSvGzIG3lRqoFm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 14, 2025 at 12:59:33PM +0530, Dev Jain wrote:
>
>On 14/09/25 12:33 pm, Lance Yang wrote:
>> 
>> 
>> On 2025/9/14 14:21, Dev Jain wrote:
>> > 
>> > On 14/09/25 5:30 am, Wei Yang wrote:
>> > > When using mm_slot in ksm/khugepaged, there is code snip like:
>> > > 
>> > >       slot = mm_slot_lookup(mm_slots_hash, mm);
>> > >       mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>> > >       if (mm_slot && ..) {
>> > >       }
>> > > 
>> > > This is only valid when mm_slot is the first element of its wrapper
>> > > structure, otherwise a NULL slot would converted to a mm_slot with
>> > > negative value. And current code thinks it is valid and continue.
>> > 
>> > Shouldn't you fix the code for the case when you can't find the slot
>> > in the hashtable, i.e slot == NULL? Like, if (!slot) return.
>> 
>> Right. For khugepaged specifically, the slot == NULL case in
>> __khugepaged_exit() (only user of mm_slot_lookup) should probably
>> be treated as a kernel BUG for new.
>> 
>> But I'm not sure if the same logic applies to KSM ;)
>
>I haven't seen the KSM analogue, but restricting the position of an element
>
>in a struct to make the code work should imply that the code is wrong in
>
>the first place :)
>

Ok, if so, I think this should be a patch with Fixes tag and cc stable? And it
supposed to be two patches, since it fixes two different commit. Am I right?

Originally, I though we don't want that bother :-)

And now we decide to fix this, I am wondering why we wrap mm_slot with
khugepaged_mm_slot. I don't think it is necessary to create a new data
structure to just wrap another. And this is why the problem comes.

  commit b26e27015e mm: thp: convert to common struct mm_slot

-- 
Wei Yang
Help you, Help me

