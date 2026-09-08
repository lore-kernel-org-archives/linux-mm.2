Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 915A6C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CE586B0095; Mon,  7 Sep 2026 23:03:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F766B00A5; Mon,  7 Sep 2026 23:03:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7952C6B00AF; Mon,  7 Sep 2026 23:03:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53DE46B0095
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:03:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2171C02FE
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:03:29 +0000 (UTC)
X-FDA: 85189099338.28.3E6A6FF
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id CFA2380002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:03:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ACUuhMUz;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5a1YoX0SvL7sfW8pstssuVuZZ1A6GuIK0U/myKASnew=;
	b=tzqggDnpwIpgogov1kFPmVsmilmqZAXFqsbzYtRbBPntzSEd4F7KfbdxEQRkhoaVkk7mPt
	SMVeNacf4Qq4x4K1A4LXRucq1aYtsf2PqTUFPQNc8Dx0o/R/wKOlOBIVx6MCMK8h+6i3Ls
	GaUyGxTEyO9tdjWZjVrtf6NvLLnKkuI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ACUuhMUz;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788836608;
	b=l8MJqM2sgtVcxLxCpA2Ow2NC7quRSWfIgJh9XpxJI6lJYgTk0dU2qF+KxP1L3m5NRpRHDG
	oZSRwzlsj2PQOfjrR1S6qwyIUdS5aYUg9Rw/9HWUCQMISnSB+JU8wXkY2QfPi8eNrpQ74r
	+Vnk3Ctm1p81MHON3BoxGa2Aopoz0oU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788836603; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5a1YoX0SvL7sfW8pstssuVuZZ1A6GuIK0U/myKASnew=;
	b=ACUuhMUzPiqhWhIdCgsOnOPoU9chMhyECkUb2qaaqOWmPTkYb96tuprexQq8nchvuSIk1pIeDGBbZDYihYu6gwWqjJL80f6Wmc5lXGNRMdbRsGLmg3D/T7NZI0yETrPxwIpe4goeRI72KkZo2jNkZadKVmC3wky4D0tWkLD6C/s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XAa8j2p_1788836600;
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAa8j2p_1788836600 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 08 Sep 2026 11:03:21 +0800
Message-ID: <67d9bbcf-2991-4867-8afb-14bad1cebf8d@linux.alibaba.com>
Date: Tue, 8 Sep 2026 11:03:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: mglru: clear the reference counter for rejected
 folios
To: Barry Song <baohua@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
 ljs@kernel.org, ridong.chen@linux.dev, hebaoquan@kylinos.cn,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <8e4db9a298c5ea6ccb192e274caed5b96f0cf022.1788751143.git.baolin.wang@linux.alibaba.com>
 <ap9zPPughaSlfXM2@fedora>
 <CAGsJ_4wn5ArqhG9w7gJY7X4G+Lg6=1teCb70dzPdN0k+5H8MbQ@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4wn5ArqhG9w7gJY7X4G+Lg6=1teCb70dzPdN0k+5H8MbQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9hc8f8pxsk9t33xer13aw6nin171np53
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CFA2380002
X-Rspam-User: 
X-HE-Tag: 1788836606-798720
X-HE-Meta: U2FsdGVkX18ka0wF3L26FmU5UPFLBD18ZB6Q+ART/wnfHnMBJ8sxUHZrUiL1NNxSCIJMYyUGdFHSZQigGIsPIT0S1F4cQOgdoyxlwNW0jPqUr2Ul3yBpjbi+lds1mfFzRwhmpG/mlJNouRmRgZmgxRsBD5dJhoLDtswqcX8P0YMWQ5uv9CQJ/9nlV+Op3thRu/G9iiSFECDprm0RqzK2Qs4QhO9kGPfRNK1bluyrMVOLLelnbO4CEFQ/sBBYFiMEJl/dbBUXZOwpH9hjq2a1go9HLlYVm/5ryO9b+YFIF/Owe+u5HCQX4Rx2htZ2LG2d2jyS3C34NFusaCPd97aAOcdDcAa5ZoQEA9F+d8iC0tXKluhMvcmFhBBAU22K9jH01Fz5VMhze+merEvyrc+SewOayVxpK7IGi6iECRzIpgrPBPpJGS4wdRn+MQtwRi0XR8oCMs8j2KDlZLLETQw7AR6tIFkNI75NjISS15qVIYcDubJDjYOAkRh8mOHqVxeqBTf5aIDBgtX2Tkb1IAkJOIgFYs1qjIz+U+AMiwYfIyEbB+l6QUlgBMI0v+81ci0L8IHn/In+TJd54x95giNtPr0t9IdLs9q6PHczyMPa+bBVq6kU1T1Gb2MQwimTRrbbJMMGtn60mylLUe8y/0XpuZldHD7gf5V2wdIp+dGHTL0u/EZgA82rdIWOeqqMUgPMddhV3pgqf4uAOsaB2Mx4BdYqdhXi1aeuJMq24vu/KcCNriBtvhM2jS+stKbaCRD1Wy1yDHZT/BDnupQHnIEYAQWeNMNxrv/c3dyyld4IZU3N7HyL/39Y9+DxlBI6/MXeg1h1lmHRgvYLTZzr5wNkSqH9OK2TEmKta8ePfpNf9LrqnbRBkonTcwcJyZP0fsTv/3T7zS0m/P0gqk8Zk6TaQq+QvE4LdWuV/XA8/HIZ4aTokZCXKXJ0k1GmbyESZs+fLFeAHTd+lNG0C+EAUfe
 lMdCdFYR
 vf+RPqJknSGJ3FDb+05/iriII2YB57XJzN24kqu+F/KF5jgwwX2g3mHJRkMff9WdGrUsYgcRr/5AQVGs4TVNG+upc/MJFSfIiLz6/6xi0eMYxko6mE6S7zrmAfgivssT3O6l/YzsvfehO2EBHKiuqfIUs8y/U6+A3cmh+H/ttYgY1EKYDaUuBLLXYOROtnF5AZgJcVTiQ+zVCvQEIhcz41yzQkUnmGD6nORycjzsXjMPd99Dd4ZHNuOHKj9XELi0Dc9GrRiPT/BFaOi+TSvH+IctRb+UAJoBIjPdZ5wYW5fDt68NRfxo5mk4uTXcL7Js5FwhNYmW3IeoilHYgylUFR+dy471wOVc6+862/HpDEQcosqk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 10:34 AM, Barry Song wrote:
> On Tue, Sep 8, 2026 at 10:30 AM Baoquan He <baoquan.he@linux.dev> wrote:
>>
>> Hi Baolin,
>>
>> On 09/07/26 at 11:25am, Baolin Wang wrote:
>> ......snip...
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 40d3f1b48a74..42c0a09938ab 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>
>> Well, this seems to be based on Andrew's mm-new branch. I usually track
>> mm-unstable branch. Maybe the subject should be marked as below?
>> [PATCH mm-new] mm: mglru: clear the reference counter for rejected

ACK.

>>
>>> @@ -5021,10 +5021,11 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>>                }
>>>
>>>                /* don't add rejected folios to the oldest generation */
>>> -             if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
>>> -                     folio_set_lru_refs(folio, 0);
>>> +             if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
>>>                        folio_set_active(folio);
>>> -             }
>>> +
>>> +             /* See the comments on LRU_REFS_FLAGS */
>>> +             folio_set_lru_refs(folio, 0);
>>
>> This looks like a great catch, while the code change could bring issue.
>>
>> Because move_folios_to_lru() relies on folios' flags to decide their new
>> generation. You just cleared it before move_folios_to_lru(). This is no
>> problem for rejected folios that are determined to be put into the
>> oldest generation. But for those rejected folios that are determined to
>> be promoted, this could be wrong. E.g currently gen window is 4, and a
>> folio is referenced, lru_gen_folio_seq() decides its new gen as 1, which
>> is the 2nd oldest generation. While folio_set_lru_refs(folio, 0) clear
>> referenced bit, this causes it being put into the oldest generation in
>> move_folios_to_lru(), this is not expected.

Yes. As I discussed with Barry earlier, lru_gen_folio_seq() also needs 
to be reconsidered regarding whether it should rely on PG_referenced [1].

For commit 6cbdd9726fb5, we didn't discuss the impact on rejected folios 
either. Before commit 6cbdd9726fb5, if rejected folios did not have 
PG_active set by shrink_folio_list(), evict_folios() would set PG_active 
on these rejected folios.

[1] 
https://lore.kernel.org/linux-mm/20260901220430.79810-1-baohua@kernel.org/

> The original code looks quite weird. It even prioritizes folios
> that won't be promoted by `PG_active`. Do we need to change all
> the cases just to call `PG_active`?

Yes. Regarding this concern, I plan to change back to the original behavior:

	/* See the comments on LRU_REFS_FLAGS */
	folio_set_lru_refs(folio, 0);

	/* don't add rejected folios to the oldest generation */
	if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
		folio_set_active(folio);

What do you think?

