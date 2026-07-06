Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFE85C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71DCA6B00A4; Mon,  6 Jul 2026 04:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CED46B00F1; Mon,  6 Jul 2026 04:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5974F6B0115; Mon,  6 Jul 2026 04:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35FB16B00A4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:57:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC0171402FD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:57:40 +0000 (UTC)
X-FDA: 84957748680.16.CC14394
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id EE6CB120003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:57:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IVPjzY/b";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783328259;
	b=NMhv1Pe+7Mj5PhzNM7R/erzzIpS7fTGCCs38jxQvvKOR7fIRLj+pCHAm/I19DQt9/YfuS3
	wW8M3qYR3chcZsUpPOiPlEssrGI9XhN+k4kEVpNDxuLRwR6g7yHLSOi0tIH9UAiVK6LnnR
	X6gwaaTm5yzBOjuOJ1L63chHZbChe5s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IVPjzY/b";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783328259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jkxD1mDZYWnsiqnV1zbOwqumBmcmbVddb3oJ2Wo7P+g=;
	b=YeBe5I4KkRhlDmIKW/pC61tCOFBgfiTgnjedqBFQ53gcRGIvsJlY86uYamgeUVRhR/z9FR
	Z9EI3fFgREAaCDxeCEUpbztRRZkiU/CkDdC6iu23imVfddAYarCfAufp7lD/GiWsHNpWlJ
	/5Ft8Zg06XYp4BEjgc1Fr7Jmf74MOFY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 26DFD432B1;
	Mon,  6 Jul 2026 08:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806EA1F00A3D;
	Mon,  6 Jul 2026 08:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783328258;
	bh=jkxD1mDZYWnsiqnV1zbOwqumBmcmbVddb3oJ2Wo7P+g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IVPjzY/bqVgdmT5bXj2hktmiNtZM7Kw24TlGzLWs7bqU2G1tjqG1pJlVWLVxc8SFu
	 i5O5c13zyeuCv6dJrzDpLZ8OJBHgZGHtZ8gB9aofSq8cl1P4tePCjsxAlmgkb1/nvD
	 ybcIQZGZ0ayIyvocwbd2MP7x8d58kPq1SDtjhZOY6NHjM+G7yoP/wyvt+DFIB+LzXv
	 LzbUXxcx5ATdVPDgHciAU9YohHZXmhbZb503ngfqhnv6XyzuzAvin/GaCZP2oLLMmk
	 /CwIK2QUGgMGzsEAfcO8uqb6qATVHSy46ROe1yKUwDdBdBs/z3uBcOE6ZibFGiY9Gh
	 kxiEvbVnfzZJg==
Message-ID: <24336f56-1024-4c9b-8653-b1a4658b627c@kernel.org>
Date: Mon, 6 Jul 2026 10:57:33 +0200
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260706044122-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EE6CB120003
X-Stat-Signature: yq87eqaifq5f5a7kjgbwkeu8qgb9fknf
X-HE-Tag: 1783328258-391080
X-HE-Meta: U2FsdGVkX1+P93MWZb3gWF+kQelvcpH6w/bZ6cqo8eXBd1qIS6TGn4GTR7/1aAD0vUbj1g3EfwbAZ+70KA37qEn72VJuAUJLNGmo2fj1nFaLbMsmVcKlZwCyDwU62FfW7yezexEHP2NHqzZz5YTvGyIv/DQiZjCe5As4ySW3QcuNAW/WPLmJkAqrbnfE+aTo2Mxup0Q+yA6h3MlusIVYPTQYioVGyQ7AqZR4Ze0GubQBZGLiZMeEIyqux6VWuqKpRmVXKbP8NR2Uw07jIRPl7QOC5Og+aH5JV2VPLXwSClcSqU2sifrg8W34GdSueeLaAnV9wGzv0U3U5BqeVNzm28wHwMQTGzziDL2CYtqcHQJY9dJM4zNV76nwB2W5hzME0uUK0uLfEhHoFazTHXUYCekFWI9yuYA9IMGf2KBuRUDx3qVF5/egLmXdG9wq8k6AcwDA1L8kDDlg+yaM0eyZHlJoGGnBvef/xCbT+xrKqwpc/kM9VPG404f/ZKudnDfcQw5vqI6eL7pfG8wPUCyMn+DxmvQcqECNR523NLsp790Fy3rX0QfJywyuCBHh0IGD0/jFQwUQhour6BL2tTQQ0F8bUImfucSwpIO8LiF/dLITnDOS0tcfAV271JVJdICfCTutDlVPpRfnX78+hS2H+pwpRUIQiycxpM3vYfCmrSOnoNpO7J2xBkPEtk+uhet08m8MUrPKRicqtBbtS3lvSzAw1xpJPDtZI+pm4ZjaAromUg+LEKaLS/FB8Z0OqFaSJ5ytkClpPlAiTmjnTo4O9BSljvN27r9EEpWiZpU7KOXhyME1uQt+G/ihsJXqlKPmtdxidJuIm+/r+AlPezHYtGjhYdDexPEWU1oHijIwpjWurAXxgYyDhld/mghN7hqYYDith0QsXu6N7hOg2PZZkXe8g7VkKknlp+rQG23bBSUV0ZyfpRt3BRITd7FAZNk85pKK69TzlvGfQZe9vLH
 Fgt5gMH6
 aET7ORmciaW+G/hiefuSQ7xqIhGcpMi2Ymh0mEZcy9DOdRwi2Dm/T40H8C2ALcn/NrMJgYaR8f874euCU3Nre6U5MfsUsQFTiQdxfdITPrV78B4kmP0g+855w1evOZh+MOtPrJupZymwnoJ2MjKWFA3SI3hgR1AxSSVCU9SeQR1EO9eRFixvyJI3/m2zqOYy54J6h7SiMA/CAIb7SvdHYM9GYebTXUp8UyD8FzOHWEmy8e5nP1voFRPr82alDl4wEOGYt7ydTM6qs8BnShrsfMAeEHSbA7k0u+bKSbNZo7JuXGlmxJsZUbQpbWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/6/26 10:43, Michael S. Tsirkin wrote:
> On Mon, Jul 06, 2026 at 10:38:18AM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> Yes.
>>>
>>>
>>> Why not?
>>
>> I was wondering whether the spec would state something about that.
> 
> Sorry I do not get the question. Virtio API expects
> callers to serialize calls for each VQ. So this just prevents the work
> from running and accessing the VQ while probe calls add_buf/kick.
> I'll add a comment explaining that.
> But it has nothing to do with the spec.

The device is clearly not properly initialized yet.

Yet, we expect that we get a stats_request() callback that would try to
queue_work(). And IIUC, the stats_request() will be directly issued by the device.

In QEMU, that would mean that balloon_stats_poll_cb() runs, which would do a

if (s->stats_vq_elem == NULL) {
	...
	return
}

virtqueue_push(s->svq, s->stats_vq_elem, 0);
virtio_notify(vdev, s->svq);


That's why I'm confused :)

-- 
Cheers,

David

