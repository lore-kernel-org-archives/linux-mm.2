Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3E22C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E3446B00C6; Mon,  6 Jul 2026 09:42:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96D706B00C7; Mon,  6 Jul 2026 09:42:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835456B00C8; Mon,  6 Jul 2026 09:42:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B9B46B00C6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:42:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E28B91C7D37
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:42:29 +0000 (UTC)
X-FDA: 84958466418.06.E92E431
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1784EC0009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:42:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nkgP/n7t";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783345348;
	b=NsrQW0eSIuiBelrS2G5JwMczqIHwqjOwq2xuJmTGDtMJvaaCIKgrC8LW/tPvij7GsFKHVo
	MJatZoE5H1WVFzy9SKMzkZdEVJLgQ3jfzAOvobRAm1M/7L7FfRsvFlsDbjNidkT6U4EV4R
	Mg8Pk7SOLxWpddW/SMchBFPNE1r5yxM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nkgP/n7t";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783345348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iAlZCQGUqTVxw4RwuBqXjYr6D5K+9yUEa8qoM9jBo3M=;
	b=bJArxWQk6HaJuluoGUD24vBL/yzNTPF4rDZ4xevmAyb1S1+KGpDKTGnMSI0PxWDlztRAKX
	/1aU4El/kX6ep8Qw6ASOnzKQbkov7FvpC0N6eQJQBaktoFSbcrLqK+RkCsCrnq4W5UuHco
	b9Pe/SHxa/BGsbzIN4T2gzS06MqCi7E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 40F544025B;
	Mon,  6 Jul 2026 13:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801241F00A3D;
	Mon,  6 Jul 2026 13:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783345347;
	bh=iAlZCQGUqTVxw4RwuBqXjYr6D5K+9yUEa8qoM9jBo3M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nkgP/n7twFmqF0clZhGQQG+LGD5VNF6GHhY8VIqGYI76p0Oud8VDaaFu4Ca1g8ygI
	 2gjs+zvDxPxjjUf2vMMVBD735i92FrrTz7k7OgM1YhwpjVCtS/YkOChEOPAapHrn1+
	 4LYVpV4gRdm9Cnw+ibIJX0bq5iO6wHjFWRNAbgMac2w9gOU2NFgRei0vgYWXEgvuDG
	 muSQtgD2wPYMEZFTqM2tZ/U9VWqel/gArnXxN1OF0Gv9IkHkrTmy9XkWUd8uf7zyvw
	 pcEDwzHLdKFLnEx+1VgeTZQQbb5P3pZLJ1X3Copc1oVMuNiLmdGDn5yAamD2OHyera
	 iV/5Gerl+iSZQ==
Message-ID: <23a81009-7ed2-43ec-9f6c-731225ac3667@kernel.org>
Date: Mon, 6 Jul 2026 15:42:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] virtio_balloon: prime stats vq after
 virtio_device_ready()
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Adam Litke <agl@us.ibm.com>,
 Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
References: <2f0d0de033f3005d3b985883be3e5cf37b3f6c42.1783278596.git.mst@redhat.com>
 <13794c5e-375a-4fc5-84b4-a637d077f8a0@kernel.org>
 <20260706042207-mutt-send-email-mst@kernel.org>
 <6b8e4ad3-6909-4d0a-89a4-104a5ad9fe79@kernel.org>
 <20260706044122-mutt-send-email-mst@kernel.org>
 <24336f56-1024-4c9b-8653-b1a4658b627c@kernel.org>
 <20260706070936-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260706070936-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1784EC0009
X-Stat-Signature: 6akeciwk44khf8ou755unr93m3md6poj
X-HE-Tag: 1783345347-664145
X-HE-Meta: U2FsdGVkX19YTl427QJB1X2aJpqVGJJgCY+dZ6UDSkO4EnIrB1twDwJ4cVMu/T0Z3uIJLaa2gAtt8yuj+Xd1A2/vxyBjHDPn3gOVlpjQDpDmBdn6aCJ3wbk4kS04ow+1aGN7Ynt3e+8OdvEmuSvhmlGlNSTzI2nnXQIwigtIlvpIsU2bZUkYQjc4E6gxMcNKzdQxvFJRPJvzGZ/iH16VBb+m51dCWTy25rxr+sAAN+w86U7jixIciTj3qDxT1vqFrXGUmXirZktTv2UFUIfUKYLPE9IkOseY6maMEeNm/xlzhtvdG4OTQJ9ihxtA0yzbEv1QFqmIA5Sbh0+lI6oloeQLfYZWOagUN3xP1svmCA0B3yF26y4ihA9G4MJtggtt+EbS4v60mb2XaN/894tjRvL0T+nZiXT4GJOcoxhaJyUe3bch/sbhxiZYlyOH9c/EJfheKIzoUsLeOjo29nTqnKarjQZPCb1PI+7ez51A4BYrEfX0g2ZvxOo/xGqOa/ntAMK6j8JvoKWStqQqlCUC5DezdSWtg8XvbKYGbSEqrfu3peeZOpwIUGf6zHuabkmQC/rqehLxbIkITHaMaTH6ikjvmTqdWagt8dgR2IOMVLXk2+z4pmYKI0gMwM7aRDfMxWjpcmFiU0ROwp5KdlfGZysR5Z1UUt6lD4bX27EzMFP5jbs4fa4vB4OuMlhlchJGx4gViahtIKNc7WPP+JROBWXJ+8Kwf9aO3yFwDg6HZZWl/qIZ4GZp8QqS8Hd78L4akUY2xAqWiX1vPqN8eamTmwYI84p1tVIsg8w6JM2P05QQPJLg3s0dPI8NMDkE2h0RKOSZ8OFJm9M9GZoCdO8JUXQk2RhPUkXkzddsGikHB2KlaEfSKaB9jpazicQrVy8XTIarfAaO7o1XqTbh4vQCVQRWkyBbW5Uo93tE4Lq2YKBQUrlhmuvRHMuRuE6RimSOz2l8Z3COPA6u/Gk21TK
 WWpHk/4I
 PqYLXEuvE4TiKNzOEgbpT39VD239KfFvB7hNzPkBzYguA7QYo89JjE/K7C+JJNw372Acv5WjmEpzaF0WsOsw5s/m3MN5Q8ROkCHcVzjWYNIkdLh0Bt5I9CbAMYzNYDX+ywf/sv77jLc+3WobXEgViO0HT1A+amIjo4Ht7eBZB4NIYnRY1OVkaaAxeLPBhsswY7PClY5JixmUHXMFpMUp323yUw9b0vvmz8JcwxmZosBK+GSqN18VBEU9J+I4RaO6FS6PS12N3vwIXXzkqMBeb0mfEKhlvBHO0nRtfIy09C10cjEHzLA8hNvMWhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/6/26 14:59, Michael S. Tsirkin wrote:
> On Mon, Jul 06, 2026 at 10:57:33AM +0200, David Hildenbrand (Arm) wrote:
>> On 7/6/26 10:43, Michael S. Tsirkin wrote:
>>>
>>> Sorry I do not get the question. Virtio API expects
>>> callers to serialize calls for each VQ. So this just prevents the work
>>> from running and accessing the VQ while probe calls add_buf/kick.
>>> I'll add a comment explaining that.
>>> But it has nothing to do with the spec.
>>
>> The device is clearly not properly initialized yet.
>>
>> Yet, we expect that we get a stats_request() callback that would try to
>> queue_work(). And IIUC, the stats_request() will be directly issued by the device.
> 
> With an in-spec device, it can happen right after virtio_device_ready.
> We could defer it a bit, but I don't see what this gets us, and
> this also protects against any out of spec ones.

Agreed.

> 
> 
>> In QEMU, that would mean that balloon_stats_poll_cb() runs, which would do a
>>
>> if (s->stats_vq_elem == NULL) {
>> 	...
>> 	return
>> }
>>
>> virtqueue_push(s->svq, s->stats_vq_elem, 0);
>> virtio_notify(vdev, s->svq);
>>
>>
>> That's why I'm confused :)
> 
> First the spec says there could be interrupts for no reasons right after
> DRIVER_OK. Second there are situations in which qemu might
> consume a buffer without a kick and then an interrupt
> races with the kick.

Okay, makes sense, thanks.

-- 
Cheers,

David

