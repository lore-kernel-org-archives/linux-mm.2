Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E884108E1E7
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 11:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 970076B0470; Thu, 19 Mar 2026 07:00:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947CD6B0472; Thu, 19 Mar 2026 07:00:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85DC16B0473; Thu, 19 Mar 2026 07:00:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 74DD06B0470
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:00:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C0208BBE7
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:00:06 +0000 (UTC)
X-FDA: 84562518012.16.3D18FDB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 479C5C000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:00:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qgAwqqmF;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773918004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dCAW2g+0cJeuxf/MrLUs83E/BW9WsBOUtop26KGz8+E=;
	b=BxB/t7UK4tAioWD362G5Z6jnZP80TkwZI7F722rpmASgk9ZaHu/0fzxBQ1BYFC51WjRQ36
	UnjsQaY4GdLpV4fEHZ6liRHpbceyRsycK+LkItPwGhkYG9zHO7TkOGtey9AtZPSKmhdMEg
	XwR0xXhScvopD9tq7ZjeRy7qGzF0VhI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qgAwqqmF;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773918004; a=rsa-sha256;
	cv=none;
	b=eqAxnkwQVYqfk70V4bqRR6+gg0aS8R15U38k6pMwQryagybE89kKixHAUFtjElt/0RDarf
	b8SgsHKKNrBVQyQBfxX82TcVoTZveKuH3urcPSCedk4313Vp/TFTqCYi6AYZRC+YfQhTkZ
	2kletK3aDo+FZHybl0mhkIaJ9ZWBWtM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 949046011F;
	Thu, 19 Mar 2026 11:00:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6172C2BC87;
	Thu, 19 Mar 2026 10:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773918003;
	bh=+fWFGDXy3y4CVX7cdvwYOmx6e31wKTqWuXmsnGHx4F4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qgAwqqmFtRwRcKbqxM7zNQkWcn1MnzslfW5GUXgQ1GEFdzKw5HNEgLV/6kbFlpz3O
	 ZmiQ9G56PMkL1L6kijRDjNicm1JmnMpjkeB+WGWY1IwUGigTOR2+hgMM7+lqB0Vuup
	 qc0V0Xe+NU+0sQGhzOzseRtkjj3MCZ5g66jBN3PTVfdZhZ3iu+TC33SLTc9iKcXYyn
	 m3ihTCJFqzTWeNlALhBrlgX1bLmh0KVF9xX2NIjyXVB3gc9T2wVW0jW+V59coxPe58
	 6pTvT4/t0PB14vN6g/mLGT06xebpuYHyrhoqQlSg48FyCcOYbV2R2YVfva0/WCCih+
	 c1M2pp4dGrvQA==
Message-ID: <37b48d94-9576-4529-8576-d4ed615d4768@kernel.org>
Date: Thu, 19 Mar 2026 11:59:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] kernel BUG in collapse_scan_file
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>,
 syzbot <syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com>,
 willy@infradead.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
 linux-mm@kvack.org, baohua@kernel.org, ryan.roberts@arm.com,
 syzkaller-bugs@googlegroups.com, dev.jain@arm.com, ziy@nvidia.com,
 linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org
References: <69bba3c0.050a0220.227207.002b.GAE@google.com>
 <e92ca212-9ada-4cd0-8d54-2f433d6d47a1@linux.dev>
 <10e5f1d6-077d-4783-aa16-6c8b98cb9e74@lucifer.local>
 <c3defcfd-74f6-4e70-b002-85bdcba44df9@kernel.org>
 <b963c391-8576-4351-b121-67ab9a9b2a1e@linux.dev>
 <8ab10631-4672-4196-b32e-7c5a01707424@kernel.org>
 <ecedbb39-2df6-4300-99de-a56c7490c3d9@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ecedbb39-2df6-4300-99de-a56c7490c3d9@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 479C5C000C
X-Stat-Signature: pqs4hmimfdnaqki5bfuc3xcp4tnioas5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773918004-750377
X-HE-Meta: U2FsdGVkX1+A5WiqB3VE5uGwehXIj0akbeJF+bqUxqiDn6Cki99/Tk2V7q0eNOxvFO/tTEK/1ze5xfco6Q4aboMk6726fEjA8wBbKBSi67vFcYMyr8CAqVB617u8QiovckXNt2BULCJyyhlInb3os+q06AuKsNCeNZaQlonHj8i/NgNMmROcPEhf1/y7oVAuynL2UjbZVih1x1HzKxLp7KgVh/yhXJmkpwI3NqdGmqT01nMgWJ0WCvgab5nrCbp24ckAvsSgGRsb6DVgEU3jyIRqJbI22h6x9TBsV91LiKSAzBPPVsUsli4TJwKM2xDl8VtF0MpSfy5GeauiDtPj9c08c5zd+AaF0opbm/Czey3TpEK0kV2qfQpzrweBf+NWoGjljUVygK/IZp2jGlP3xdcfj/f7yUDhZlenQH/6WgGeDHSadD1t5L63abbohEYU8sfCiAyfve0Wy79AgX1CPUacntXLzeBgdCDqABBwX3IyUiMQvMnybnPkLVVkH/DZYwo6yRG583s16zCU1ami0uWNuNW2UbmPRqyyrapD/EXvJPR7z/nw12FpW249fZCISX4k828FvOgodwamrv3BhNwue6tW2NERFC6G7ndp9DVyLM0+fXD8mNI9wC91xWdr0L1CyGmnIS6aCxE/0J0NCvtlZj6TaAmazIcV/y1ERntS5UwLM3umULNX/cLM8mt0+zBvzSnPLQsukYCcEuGn9pxQeMBkLSCys7XMLzGJ8mwKJeudf8MB7PJSfxA3PMRYqNCaZ1PG5nHkJifTNB+tkkZ/8mtHSdfK1MjjlS3fZTx/APOMLtOGRo3xB7zhMlBP1d8rwm2d4IRonRfqOTHPn+egFL907vBGKF6y7SOfPHwYqvsG38OqpKIQdhTkU/+ciPF/DYbP3MiyNibmgFSm96JClSDUWwIF2HPFErk0ykigdmTR2j3m2HRRwwtS5PErApGMlfnpAcbBTY4ZmGY
 vYT25FJf
 AaOB0EvNWSXOSJimfYs+G5bM1Mjx5RE2KNT9+ShlnScTM5TB/sPe40cyxSe0fGpXDG7CG024H1nVIL5Q5eIwaPNxN6YUs/ZoQBqhbGkLdfYGmSaDDvgXToBc+8morj5FzmI4/LgkQpgGCfsDSOwCIv591N7kaO5zh/AUiMTfPIQ2gd28MKnJG9cjNgDYMwBt4LxjXdugc6zTatgGmNXBLZnK8k1Vc0n5RozCM6krOCvQM5OIFLyDQsuKj5/0lfAg93si7/9E26QIRbOIQnJlkxHOiUddHfJJ27P5p3Vz+BT64XL7eq1YnIBJAnfDcGvk9LISlOvmY7i4uslSoBzS4ciPVunzRX/V/rrF8tTEmCIug9qwl8aPcA5P1j3rq2emrTDQ20iIkqKUoA4l9Yd2aBF5dhfKtbWPSx1xcrQ9CHt0c0JooqaToph5WfAwvdmGBEZ6SpEJgG9Pd58NuYOPGcj9frw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> We shouldn't, really, be just ignoring splatting kernels like that. At least
> that's my personal point of view on it.

Yes, we shouldn't.

> 
> But anyway I really don't have the time or energy to try to track this down or
> push on this further.

The problem I'm having is that reverting the commit might hide a real
problem, and understanding weather there is a real problem requires ...
real work.

Willy said

"It *might* still be safe in this instance; I'll look
at this carefully for a bit and decide how best to fix it."

That likely didn't happen.

Later he said:

"But this is a long and complicated function (over 400 lines!) and I
don't know if fixing this one way or the other would serve to make other
bugs more likely or expose some future problem to the debugging code."

with

"This isn't the kind of thing where you can just jump in with a one line
patch and actually be helpful, sorry."

So I am clueless if there is a real problem there or whether it's just a
false positive. And whether (if it's a real problem) the simple fix
would actually be a good temporary fix ("make other bugs more likely").

I can try finding some time to look into that, but pagecache code is not
particularly the code I'm familiar with ...

-- 
Cheers,

David

