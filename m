Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD0DEC43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:38:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB6536B00DA; Mon,  6 Jul 2026 04:38:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8D946B00DE; Mon,  6 Jul 2026 04:38:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7CA16B00E7; Mon,  6 Jul 2026 04:38:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CA596B00DA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:38:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0346D40307
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:38:24 +0000 (UTC)
X-FDA: 84957700170.26.7DE4F26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 46A3040007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:38:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WlYaGKhp;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a7yNDDf/DMYk3ol+1u6rxtj1rpa92gD4NKRD65REqG0=;
	b=gRXxVyH3JCL2V7X87SH4vvwfSRMGBVW1atWG+mokG5p/pdlftTUT6MBDjsb6LBAl61u4MB
	ex6sHrNwrtEyRDTobAkh3FvsVkK+Ui0LXiVn73pgnq6CQYhdo7XqvCgpj6I1edfyfQHzPp
	oh1+N8uYy0iITcVhqyer8HZVRm7Dk1A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WlYaGKhp;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327103;
	b=U327MlVu7DovAwwZTqqktrlQoENF024rMqf1pw0dn3lFGuf4unhs8qWL9elT4OdLY66BKd
	10AdBWZR0z5xDC2t6KQ8XcGTSEiu2XY5/h8FseJ3EVr/OyH4Da+UZc3ej03ReupDRFfmVB
	e2RQkUKif9ojN2/RS9yTlfZKvyhqXuw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CAB266138C;
	Mon,  6 Jul 2026 08:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A4E1F000E9;
	Mon,  6 Jul 2026 08:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783327102;
	bh=a7yNDDf/DMYk3ol+1u6rxtj1rpa92gD4NKRD65REqG0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WlYaGKhp7Q1qk9Es17ct14W0SAv9dREygoTVTuge751xR7qQzUd5HJgHnlxif4kMc
	 oTjqSxaX6UNdsKE3Vz0O1nkU2tJllp6+AViGu2UoX9o1qmzczfwsUdeHx11ikiG8pp
	 6KK7W7DpSGFUdWhAvT+dUHf/tE3Qijtgn23oewCoopQXdBNMnwNqCv9Hw3Qua6m5xb
	 nQngwdxgyOZpTVuwWWZC3jxKebw7ekVzKHtLhvPWMhyHbgwzYiFyTRtlQKRJAVgW8O
	 veY6wocFOjh55xO8fxJEIOfoAuWxpakeWAPUhuCAT+qafFla5+RCinfK5Chm40a3/s
	 gYD+fC2qpM5bw==
Message-ID: <6b8e4ad3-6909-4d0a-89a4-104a5ad9fe79@kernel.org>
Date: Mon, 6 Jul 2026 10:38:18 +0200
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260706042207-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 46A3040007
X-Stat-Signature: o17txi8et8w3uyqznei87onhrm5ghnnq
X-HE-Tag: 1783327103-343962
X-HE-Meta: U2FsdGVkX19N2xCAObMh57RKGpWS5fsOVh1KM+nFGkak9Yj00fD2M+rKAY/Ml4pqPr9941chu0XuRAy8KhU63vMolM+6uShaDSWd0JKdInJk1mt97ukZH8nF5Y35JUkkMOWU1rRI7PtodmWACq8InF6NNn8ejjhjmeGVh/3evro8Lukj17oA0r4VxYJNusvi2Zoah1Kji6oKJtjSZE+uDyIlkmxcJ/3ZNgFTT3Ro1Su/BpkrGtpaS69nbAgndG5uwHu/VPB9Kf+CyEVglFchdejBMkQI4xlM0IBiYT51JtBU3mBpwTWgLDi+d9KeM8AD0/Bq3+Jnl9gCcgAo+h34gKQR9bVE0h5ceNc7LpD7oWHcAuU2g/ZyxClk9GfK0EXNpc7/UDHQR3pZ//uNgxdMSFfPt9sTwFaSv6fqmyk/0HnlTL5L6MUBINS9gTUbDUvLZ48JfQ3yuvvCtpoolbSTPgknoE1D7bAY+Hk+knqFrcAhnJGw2EwMkfYztQ1nZ+or8K2nqMAheqBE8HTdl706w1Xf52hsvpMyzB612DXMB+ZFhTQo/mlP9i4g8obSYNDTSvmpD1seXVo1Lytb5QKNGI5x+rG39xBobseC7WlXJwP8D/ACt1A+FCWizUmNCJ2qTuGRLaa74aqs6d1GKPtq2QsFGVLGu9hM/9LdI3Raxy38V9NkBtSj5ZVa1ZXi1j8BGBiiD6xl94MPDodfUaUW3S91s44KyxaI7KBLbaBSaGvRi0s1tBnb0ry+RfUFU1ak3YZif7A9nZ/pJ6uy/sYecLf4slX//Ms176pf9XU7mrjmq2EXkqc6y+O6REzPrT4kelAKPESYGJsF9XbrnF/8HoSbhol/28fGnNp4x1UAyiX8SzBraFz5ztWbkd0Rz2WjvJLbke5Wp57XzSIKw9lr4Aln1ig2/RRap4/3q3T3AE71EgOx5T+ncYGXmz9zYLBxhIAEdzUiB4I/APXfMkj
 shUozt/g
 EByCxu63BDHzH2MA9lGvK0KvLtH8eBPUZyG8ye2/2Y6Dd9BJ4kZLB4RPerl7QVw7QFiKrO7Vc3sfo5qpja9QPO9MQscGW6dO3A48ZPjSWKc/4ZIubsF4G/Q7PeloNyHMOeO3qCFY6aQmCkxIwhRiAwxG7ggpk0an+ZB6ZfQQRwTd6BeX7nkTdTgXglsQyjj8Cd7SRe+fdTxGUTfCtRcX0IYMuscOOHuxGdqz1hrrMt8InYjW5hUfESEAOVi39vNUuNp7gtrltPlM0Z9Co7+JjTuQSMQlRSQYqk+pfW05o0VeIp2YhFzT5ayaEvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> -		virtqueue_kick(vb->stats_vq);
>>> +		disable_work(&vb->update_balloon_stats_work);
>>
>> That's to stop the stats queue triggering stats_request() I assume?
> 
> Yes.
> 
>> Is that
>> valid before we actually added+kicked ourselves?
> 
> Why not?

I was wondering whether the spec would state something about that.

> 
>> Also, can't we simply handle that in stats_request(), just ignoring it there?
> 
> Then we'd need to maintain a special flag and I dislike that.

I was hoping that we could use the device-ready indication, but there would be a
small race window indeed.

-- 
Cheers,

David

