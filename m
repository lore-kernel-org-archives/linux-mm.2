Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21FB7D185F9
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 14:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B07F6B0089; Thu,  8 Jan 2026 09:16:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74D346B0092; Thu,  8 Jan 2026 09:16:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650796B0093; Thu,  8 Jan 2026 09:16:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 551936B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 09:16:34 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0B82160163
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 14:16:33 +0000 (UTC)
X-FDA: 84308997066.04.2FAC73D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 225C5160004
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 14:16:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QlA+VBaT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767881792; a=rsa-sha256;
	cv=none;
	b=KjnwoGIhQVdwYzFdhWVhNd3DhYc+4I3KIrC+zclo25gDSam1ZixOnRz4mBzQlcOu/h2J+3
	vLc++6h+KEFMZD5oojQNK4kNaJezLeXToPzSwe8znROophsVYiyrSEGI199SilwcLYZEr5
	YOnkwf5Wr7vpUsrNhLvOBWzo1b5IsZ8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QlA+VBaT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767881792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LN5869h+XGHbf7Ty9lNVIAcZQmcRFnSruHen02cKbYg=;
	b=hg2J5yM2d995fbccHPUuOp84aACUBL0SPy1I9W7ByhHT3NiWjgt/9C+W5FamQAFtqvhqzP
	RjVe/qhGbL6ix7df2nWLLrnWIO0boMUyQmqD1zCR4kAkLGLgyuYG70LmzYAdsals/gSSU3
	leNjWAoUgnjjdD64oZAFiaRjbyxTnN8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3544B42D58;
	Thu,  8 Jan 2026 14:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31E2C116C6;
	Thu,  8 Jan 2026 14:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767881791;
	bh=D1VPIae4HqpKGPlvRnrymUWQHvCt3ne9aY+Sz53JXwc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QlA+VBaT4R/xIrb9lKqb9HjXtpalHV7p4RQgJMyoHa9HA6P+I1BG0tKcS/nIn592m
	 JEDviuJIgZf/5cD9S8KmnCov54rIYtUbBj9/ZXmtS2DGCj/50i96d0tLIDnmiSv5Ek
	 pG7NzkS1r+Rda1OSD3Kk42EgrbOaqR067Ijlv0VsOeBog79D5X+UrJq84m7k2yHI/k
	 W7qSTzYFrTRmiGX3aClCN9ixvk9zVn1OyrqMVyixa3KKD5Hvtvup/DTpUpSFTf3sEd
	 377nJAo2uuB+EaS5ld8ow6pU/PBsMJRiGLutpGOvFwBpjfCVuuZ4RrclrU6XcC806y
	 LFqC5Bw1NC8ew==
Message-ID: <65c246bc-fb10-4cef-8163-3a55bd96f326@kernel.org>
Date: Thu, 8 Jan 2026 15:16:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
To: Hannes Reinecke <hare@suse.de>, Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com
References: <20260105203611.4079743-1-gourry@gourry.net>
 <7f053290-6b9a-4d18-936e-0f28006c79c3@kernel.org>
 <aV0_SMq_I_R7ikF3@gourry-fedora-PF4VCD3F>
 <9575e042-39f4-4f01-80db-34aaaa9312e6@kernel.org>
 <aV1PQd3tyfSiH4xD@gourry-fedora-PF4VCD3F>
 <616f97b7-24e0-4134-a08d-5abaf07a8b09@kernel.org>
 <aV1pmeXP2pZ55g5i@gourry-fedora-PF4VCD3F>
 <fd21ebf7-d016-4729-8d23-a7c0f2a3d8c6@kernel.org>
 <20baab84-c8b0-4c46-a550-21b26b975d07@suse.de>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20baab84-c8b0-4c46-a550-21b26b975d07@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 225C5160004
X-Stat-Signature: hmfpm37d66bpp5zrgqcd7cox61bsp4dr
X-Rspam-User: 
X-HE-Tag: 1767881791-326740
X-HE-Meta: U2FsdGVkX1/mQ+RUHmMHEjbCe6CvFrIo0zwZj9FpOaEBBhoxykxFs3FCLeuNCm/5Kk4Ha/qhppPNxiuapS0tlJcpknhn2dBLyBCUyjTVnspCB6w5Kg58mjhVqVGPlRh3gRI1LGRT3HBHo+9yDczzJNnjRsnepwt5Rp9pziuMUazGkrL1cD3daesQCUWUoEO2qyxHRhiDW4ymjMalIhwjBQWpCBgVKPNsIDIA6LFSeB9wanQ61cZQrXljX/E2EbpztJMXO8oh+3EZgYl/qv/y07szbKZYvjHRGatJOIOTHoNL92CqfjsN+RlIpZugerN20r9lRZ9029ZvhMUOqid+vfuHxYMsIHQOzEPUwX+EEuRjIlesIwh7ISPzPoZDr1ltnw5re4eYO4a0CnPseNdI5fy4bDvpE8kjveguYrDVqbtr73kaZyuGMz4FCWEyaIyWNiouK9PbJQu7wWZQlAfaRJEIlA/trnO9nVCzi1KisJRzgN0fresBTQ6FZmAwGWJCKIhgfgvfrwyQzbhswYYKzBe5qFyoxChTWH3wIqSNNuXmKgwnMayDmrBqbd96z89E1R+6Lxr5RKXkQJt8yYr8v8sJf3L6uSrSEXwOdOJhYbDcuHrXPp7ty5dh/277f9aAogqlelDH1rs/dZkrbJ/M7Rj97bkbUdq6ei51eKs7YO4wa/Wfk2PrRa9p8B4HAsUHX/XJNoq8QMhqMLZ/I3DjpFRA2aMad0VqJPyOpLThNRMuRwoXgvLltvVnv9gTJDbs1Q4LMAqaVIMoOR1yqrbVJ1qM5cNUzxuVxEP1Lc4PmI3fkMyipRco1yVUWO+LhWTupSaRW+yKzsNy+9DLbsUDjveqNWnzWRZ8QeBuQREvY+ZwFBbn+wh5i+Gif+u3KmHkIDzpO7Eq6c85YVaBBm8/kpFmNpMLUikS32uYLEZC/Z4CNLECY7BkqfA9UTtSLwxJgTQSqFFiiTQdcNSX5IR
 hiSW9M/x
 hOkAbQjDd5tuUdVsMcONtZt/46lUbV9fTRqLm47XjP/MIoLgVV4qd9uJQireNzcPeHk95R8UXIxMpPnlnmiGvWi8nL15JsHEum4sthqKQk5J1nNKJBJolPgzoBVftilGVigucHx+mgWYnFMnU783krQJ36/EkSzyNwFunRwwtS6DtB0g6zevKVxcL2Th4zD90WJwDl0oNoIv79LUVYEejvUBCClzdKy50AJghe1eb0BfWWRVwdjextWEkUBzndahnqwGczztewtJsETAiNhoSrYmlykCV9wr10k4rB6llexin4liFmuM2ZMoQp0OUQBJ7LSySo3kmHj2vWuY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/8/26 08:31, Hannes Reinecke wrote:
> On 1/6/26 21:22, David Hildenbrand (Red Hat) wrote:
>> On 1/6/26 20:59, Gregory Price wrote:
>>> On Tue, Jan 06, 2026 at 07:38:54PM +0100, David Hildenbrand (Red Hat)
>>> wrote:
>>>> On 1/6/26 19:06, Gregory Price wrote:
>>>>> On Tue, Jan 06, 2026 at 06:52:11PM +0100, David Hildenbrand (Red
>>>>> Hat) wrote:
>>>>>> On 1/6/26 17:58, Gregory Price wrote:
>>>>>
>>>>> Fair, I'll revist this once Hannes gets a chance to chime in.
>>>>>
>>>>> This was effective at getting the discussion started though :P
>>>>
>>>> Hehe, yes.
>>>>
>>>> Another thing to look into would be to provide a way for ndctl to just
>>>> add+online the memory in one shot, without having to go back to walking
>>>> memory blocks to online them etc.
>>>>
>>>
>>> I think it's the opposite: offline+remove needing to be done in one step
>>> while holding the hotplug lock.  Right now, I think you have to do
>>> something like
>>
>> That's what I note below, yes.
>>
>> For the udev vs. ndctl race to be handled in a
>> good way you need add+online be done in one operation.
>>
>>>
>>> daxctl offline-memory ...
>>> daxctl destroy ...
>>>
>>> You can't destroy and have it offline the memory for you in one go IIRC.
>>
>> As noted below, we have offline_and_remove_memory().
>>
>> I added the comment:
>>
>> /*
>>    * Try to offline and remove memory. Might take a long time to finish
>> in case
>>    * memory is still in use. Primarily useful for memory devices that
>> logically
>>    * unplugged all memory (so it's no longer in use) and want to offline
>> + remove
>>    * that memory.
>>    */
>>
>> Nothing speaks against letting dax use that, but the tricky part is that
>> offlining might take forever, so one has to be prepared to handle that
>> (and letting user space cancel the operation).
>>
>> And for dax devices that consist of multiple ranges, it can be "fun" having
>> some regions removed and others not.
>>
>> Something to think about :)
>>
> We had this discussion at LPC. The current interface of having to
> individually offline every single memory block is not very
> user-friendly. While it provides the best possible granularity, it
> really only makes sense for virtual environments where you _can_
> hotplug individual blocks.

Yes.

> For hardware-based scenarios memory will always be removed in
> larger entities (eg the CXL device), and it's always an 'all-or-nothing'
> scenario; you cannot remove individual memory blocks on a CXL device.
> So there the memory block abstraction makes less sense, and it
> would be good to have a single 'knob' to remove the entire CXL
> device and all memory blocks on it.
> Sure, it might take some time, but one doesn't need to worry about
> restoring the original state if the operation on one block fails.

That's not what I was getting at:

offline_and_remove_memory() can be called on large regions, and it 
properly handles whether we have to back out because some offlining failed.

The issue arises once dax would have to call offline_and_remove_memory() 
multiple times, on non-contiguous areas. Of course, we could handle that 
by providing an interface that consumes multiple memory ranges.

For the DAX use case, I thing we'd really want a way to just use

* add_and_online_memory() [does not exist yet, but ppc does something
   similar]
* offline_and_remove_memory()

And not have user space to worry otherwise about onlining/offlining of 
memory at all.

Of course, that will require some new plumbing for ndctl to make use of 
this functionality.

-- 
Cheers

David

