Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 588FA606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dYis7w0t
Received: by kanga.kvack.org (Postfix)
	id 74C456B05B0; Fri,  6 Nov 2026 09:16:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7241E6B05B2; Fri,  6 Nov 2026 09:16:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A9C6B05B3; Fri,  6 Nov 2026 09:16:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6F36B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:16:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39535A8A06
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:16:31 +0000 (UTC)
X-FDA: 85404894582.08.C949D24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6A8E580009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:16:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dYis7w0t;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793974589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iqu6C6KXsE4USp3iSBQ/mHI3K4Pk+aZ5OmB26zeDtpM=;
	b=DOax97WYpBsm7QYArV0bPSljxMe4omfcHiDo7UYjBK1M+J5Z0qWtnCvSY6pKNZR85igC/7
	Rqzvq38XBDKr1yjiRiL0kd/xNynmOaF7DwrUPUbQOJu1jBZWVThNxbFppK/TH58wCeFsm4
	eGBloMfmog533RxPwfEobEIRAgoQKME=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dYis7w0t;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793974589;
	b=t7hI/Uyb3U7xSfCeCE063uPpsas2YndHssDH2eRmPmAhXMOPumDaH1HwzEIE1iPBsYFvpU
	zDzO5ObHXUwbnWjFEpbsL9Jq52ubqP+v8f/QGh8vQWgwoJ91kQC6q+IcZ4fkyLJ1GdQw0Y
	e/XMB4NfNE/a4mc3GVlHsVH/hlNMngw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 02937601E3;
	Fri,  6 Nov 2026 14:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DB41F0089F;
	Fri,  6 Nov 2026 14:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793974588;
	bh=Iqu6C6KXsE4USp3iSBQ/mHI3K4Pk+aZ5OmB26zeDtpM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dYis7w0tUQde6/ADfk2fxt45SU+oba+XrjaE0hJO9IiTbhtBdqvho7edgmqZgqLwn
	 3RnXTN4nBxW2NFDHVMS2xOvL6nNYqTqKw/1j/q2Oc6Lr10uqgkne1flWV1gfwXFFJI
	 vCbtm/ZTEZJwUHn8b0t7MfRTQihfNXdzmelkiQH2hzdBKHKxiUZG2PZDAm9FTFvPeE
	 S49NFHOS0sW5i301mzJM42hQKSz9FhPlaKCMbfUBAZbIxHDjBpsBIrvBRjwSn1BuJ1
	 yUIHFyMXbSl+mPwQkcZWe+jbMMF8Xp4wZNDRmezlIyXakudGTHRQ/ebkvYRck4b39i
	 68fs5XCmBj9uQ==
Message-ID: <264c406d-9f71-48a2-8892-ad0c902e3c47@kernel.org>
Date: Fri, 6 Nov 2026 15:16:20 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: move LRU size stat updates out of lru_lock in
 folio batches
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org,
 yosry@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, muchun.song@linux.dev, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 kasong@tencent.com, qi.zheng@linux.dev, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, baoquan.he@linux.dev, cgroups@vger.kernel.org,
 linux-mm@kvack.org
References: <20261029204157.117879-1-joannelkoong@gmail.com>
 <auPhT70GU-Zqe9Qy@linux.dev>
 <6849a9c7-0e11-42f2-bd99-d7ae3d5b944a@kernel.org>
 <CAJnrk1ZF7FminyCYORxysXW0zA=fuUtBe5YXkabsSTOmXt_vdA@mail.gmail.com>
 <CAJnrk1acAiHB06DKAJhuSZBNHn0dkRYJ5RU54sSz+xGXhwwnwA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJnrk1acAiHB06DKAJhuSZBNHn0dkRYJ5RU54sSz+xGXhwwnwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ozwjkbaf83k73xzss8mzhowezqboxs3o
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6A8E580009
X-HE-Tag: 1793974589-687193
X-HE-Meta: U2FsdGVkX185o6U4AdFEK3XznQ2Lgqr01zxP8pv1gx7wZt46+vdH9kU32BPCm1/gkM1FwCE+T9p8wQNSLgj8BOXLwcqnEmg2KpzAa9X4taikKtY6Ymxj2gNZFAPyAWvC2pbjnvfg70B6pCWinnHclBSWwatEtx1aletqi5WoqdrO5Ystl6E+Qhk3lcvi9XFCWGAyMpUwt4DLtlB+eYR9mwOs89956EWvqrX7eEKtnaZrrenDMzKQkvyzf0C1mRiE/uo6bxTEMorgRyPj6y7APuhP8IayC2rYz/HbiVKAz0eZj98jySZ/iVkMQEXT5yqiy7ciJFpj7ynGzXot/7tN2wdMnAy65yOhuH8C+3LNfSIfbXybjpY+FXhhf4U8Y0YuoR1A6sEpU0Dnxo+fRqUUbX2USxqC1hwc0eANpyi96A6fN2qifRCT4oAvRyrM1YxbbLNijwll8lnVZsBpGskBUna0CRM/o1xfz0b9K3sEpXrsHyRvIhr/N0+i8kal3jTJUMhum9XQa0So99Fprlp6uvSznpHOsKblB2bJrdkBxdZJ/nvamFeY9jmIPt8bnPp7a1nSQCCI8N1hWN03faa9+LwWMEHhne4yj7fSNvHXiDqNjCNY4ACLBhkN+dXy0tGQ0wbOZF/RGQWFicK3v6lAoTN3HONrxjqfoovQJyiNBYZr9fs1/iyiGwGLdX6swM4+t6O4Audzb5tAFtxMm2OQmsfytw1jx7YOihi38wkvOASaIZSvAp5ocnRZGBpq+0XHouDSKwIzgZ8XFYKGYeXrKYzw6GIFiF2T5CHPA1111GaYHm4sUsCAK5cVOMicCuNmHeR8DLy5rSyLT7VlL+ozFbFDg2z39zRp8mBWbDA72r6+HNMCHDU38+9KwZ1/T2pR4AAhWPiTbSoAgXEsO9gcjdWUvXH9hWhhln2FPbPESWAJliNms6PDDYGsd02A549nfvGr2TaRqVeOjwyiKRE
 lDts7XgW
 MtKUXLuQxIrVsT+J2Oi0PoRaD3gj7XdIs/Hm0MRNnCo10XOVF627AiagX98F92HxB7nl5StPnrbqAGjnOxfJms/m97J96wR2lhWhm+oYYQYyEI9Kxqvuh1ncGHdHKEnW5k9Rw9zu9JkAAaJrhQ+6I70v06wAJq+DkcmMsBtux7hHexU65jVxCuCvEbinmfUfcR76bBdMOPlB2n6Nnzgm8wfPvG3eFsZXh2jmUsBXiCZAJ8CsDj03ifsmnIgNzGwm26LHHVIgmjK2ClUciy4MBalNG7O+ZSHzrmNnJGOHNbufOV1c8Bnrm3/PUyurcWTVm8kheKdNo01WNUtwSlpxnQ4fld0Q2Xe5CtAxU2T3QfZkoiA/AV/Vnd6YM3GPXL9eR2cKa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 21:07, Joanne Koong wrote:
> On Thu, Nov 5, 2026 at 11:53 AM Joanne Koong <joannelkoong@gmail.com> wrote:
>>
>> On Thu, Nov 5, 2026 at 11:37 AM David Hildenbrand (Arm)
>> <david@kernel.org> wrote:
>>>
>>>
>>> Thanks, I'm planning on queue this.
>>>
>>
>> I'll send out a v3 today that adds the documentation Shakeel suggested
>> about the race between reparenting on offlining and stats update.
>>
> 
> I'm seeing that the patch was picked up yesterday into mm-new. 

Yes, soon Andrew should probably slow down on picking things that I am supposed
to pick now.

Will resolve itself once patches only cleanly apply against mm/core.git :)

For now, he will drop patches once I pick them.

> Could
> you or Andrew add this paragraph to the commit message after the
> "Accumulate the stats changes..." paragraph?:
> 
> "Applying the stats after dropping lru_lock means a batched update can
> race with reparenting when the memcg is being offlined. This is ok
> because updates to a dying memcg are redirected to its nearest
> non-dying ancestor, which is where its folios end up after
> reparenting."
> 
> Apologies for any inconveniences.

Done, thanks!

-- 
Cheers,

David

