Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3BC2D10F21
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 10:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 367DD6B0010; Wed, 26 Nov 2025 05:42:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33F5D6B002F; Wed, 26 Nov 2025 05:42:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27C946B0030; Wed, 26 Nov 2025 05:42:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18D9E6B0010
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 05:42:05 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9B7F1604B1
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:42:04 +0000 (UTC)
X-FDA: 84152418168.05.B45C596
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id EB84480005
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:42:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dmHA4CXB;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764153723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jKjG4gr2Wm9Vnb/YswWNZiyAf/vhAolGVdqjC7FQoBE=;
	b=QdB+CZQP53Sr2OT5BxfRP3qKv7UQtaOu8IC+C8eYeHG9TC7dFIyJVfFWw0nmSBFIuQ8Vb4
	hMq5kqCnIlDXvL4vMqSv0XVpwGaJdK3/Xo7E3558xHtYSODyrUyTShpLRPn6Y9dtoYsW0h
	KE+0VBmhoCs6OBTm0tlle3gZww5GhSE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764153723; a=rsa-sha256;
	cv=none;
	b=F4pHHkHH+gPHd4lNZwd752LrO8w1PmZgWmLhmj426Hj/22XXxKilb8c4lRrtQyTODF86oQ
	gzRIJeCdQ545KapZOF5EJV2iwN3MPH4rQfpX2vk7KFv/w8Wg76RawFW/YotnTfbTxe+zDB
	kDwYagZGTOn6+abmsNbAlK0GQqAQJ40=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dmHA4CXB;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF498417A6;
	Wed, 26 Nov 2025 10:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F3AC113D0;
	Wed, 26 Nov 2025 10:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764153721;
	bh=ZeNbKFXorJI4bmwAWJcBD4LOWE7JA9kzueTQlFWSg6Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dmHA4CXBlOondQYr1s3wHnFJbTwzL5Y5dFCsnYGAfYRQw4/QdERsmrgWiyu+afWe2
	 WU9V/RU64WTZ1H+iTCHhm9s58493GI5tvupt1fatfNVKkFZuGUNW9v6jY243bR9df/
	 li9Li2Jz4DCEqxcQtEFgiMNoLMQ4WGA+f8fjPkdF+L5dGGap/gK2ql11RgeFpJL0Ry
	 4D8lniQBP1lHhac0lZF/P5ewQjsiLvOJ9I4kDVZh5lSlfN0zftGqymhQxrQWgtpwqU
	 JMJ5ALQbwkt6kM4tiMr6E4r0a4I3jZyrWv2hAR/GR9UuQRRtLbtxidcFQR9BEFgu2p
	 Oxjp7WTldZhcg==
Message-ID: <6d0948f5-e739-49f3-8e23-359ddbf3da8f@kernel.org>
Date: Wed, 26 Nov 2025 11:41:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] fs/writeback: skip inodes with potential writeback
 hang in wait_sb_inodes()
To: Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, shakeel.butt@linux.dev,
 athul.krishna.kr@protonmail.com, stable@vger.kernel.org
References: <20251120184211.2379439-1-joannelkoong@gmail.com>
 <20251120184211.2379439-3-joannelkoong@gmail.com>
 <5c1630ac-d304-4854-9ba6-5c9cc1f78be5@kernel.org>
 <CAJnrk1Zsdw9Uvb44ynkfWLBvs2vw7he-opVu6mzJqokphMiLSQ@mail.gmail.com>
 <f8da9ee0-f136-4366-b63a-1812fda11304@kernel.org>
 <CAJnrk1aJeNmQLd99PuzWVp8EycBBNBf1NZEE+sM6BY_gS64DCw@mail.gmail.com>
 <CAJfpegvH=5bA3B=6Mkjs_X_RtXV+=bCnGCV7Oc_-rAy38-uZ1A@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <CAJfpegvH=5bA3B=6Mkjs_X_RtXV+=bCnGCV7Oc_-rAy38-uZ1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: EB84480005
X-Stat-Signature: 84uad7bbeafc4ppcwc7enikqu3gmjyr8
X-HE-Tag: 1764153722-101133
X-HE-Meta: U2FsdGVkX18uoH0WDRZekckYM40itNUcVZ1J8FvBRtTF5NcP8wG95yXsi/OrVhXNnOrjJKhmLvFi2vk1eUSr1C2n68dwZCKL0WXwc3a3QamsyGc8rqAL/6U/8W+ovfy91ADNAvnrpin6KWpQZQvk9HENpE9V4H80rTIhLpw0I8hLUzTzglAtC2FD2vRjOvdpvsuCytpQqhk8yGmQB3RzZ3ldoi5xg2S03L/GKS9x1KmoCFU6FgxtuVydiO7cUTGl6Y6QtJQ9qGdNi1Ru+zaSwPQN1R7iCJUrgJVOBHpkmZQXJji84bRMxhmPSPSw2rEgVu3zBoxEUx3wN+6oGPIFP6bUb3nUq5QCP/oAVimJD0EYni0ZjDDuf7NDuKL1XfSe38gCnzQD566nwZepk/QhruEzpBA7fNyX5oesexV00+IdxiiiFWf362gkOucU33ZwAZDe+4M30yUQgbsR5pO5tuLl9MYbs6cNVtITLv7Tfo1qVdd1Y2WUk80umXiPkhlx2/D9dT6J7tQ4QMUw3s0fGcEhrWtkMlzsU9wK4OS3kK6CF+nDg24w8yhGToqMlSOXVMyJLufsI1Hwn4ugE0Rs8BUvc6sbmTqsbmTbvwuauK+OXPtmKd86ko4OtdlllQ+XJGuw4gkNIAEe5T3uBQXfOMKy30ta3i1bIhDQvhvQ3z8h5BgITW3T2TjNNxZAmpR2aTlIgzhiv7UTYo1UntW8IThItc3+I1ZHH/PeKTqca9m9WQYIJaAEU+e45UVNmXycS9XujI1e1Tu+jjuLuyZvw06q0thRr0UC6L7kCKesQqj1aJKTOkNFlLDvcVe3W4OemHsk0loPEAUlg1R3bXOcfDelZ5fzc4DXszPsS8owevog0Hbue2GkQOc3iVWQFn7QIZVtQky6Eq9B2p57JbCa0JBEJ+NibJvYOSQI5B/bct/23BHQbett/pR3siey35FDK093eLYzWLOF0DqMZRY
 NEzpJi/W
 gUaMJTrYHOLtBPVUzRMwvv+NRb6STL69TZCzl8TZNg9vuPUgbaXxZWfro2wruXq5CGwQC4b80DBY4AGxCEbz+fMifYFPl9+tCWdggWeYqZYck89dx4x7ETzZjQl29yho766MZ3IkZbc/7VxZVbCNyao1+oRnqCBord3/FWH2gIdcREFjgWfr3t4vRtb3KqORjGrktF/zwAoPh4W4vAbAGfrioDmZG06VE4hqhK3u1Q71pjW4RnLHj26VGMxIxmM9698R83gs/+B9t6nVVXYPmY8gvsU5bmDV+Bu7o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 11:19, Miklos Szeredi wrote:
> On Tue, 25 Nov 2025 at 02:10, Joanne Koong <joannelkoong@gmail.com> wrote:
> 
>> Prior to the changes added in commit 0c58a97f919c ("fuse: remove tmp
>> folio for writebacks and internal rb tree"), fuse didn't ensure that
>> data was written back for sync. The folio was marked as not under
>> writeback anymore, even if it was still under writeback.
> 
> This is the main point.  Fuse has existed for 20 years without data
> integrity guarantees.  Reverting to that behavior is *not* a
> regression, it's simply a decades old bug.   And solving that bug is
> darn hard, which is why it's not an option at this point.

Yes, and it should be clearly spelled out in the patch descriptions that 
this is a fuse-only thing, and why it is a fuse-only thing. It's not a 
"we don't have data integrity because writeback may hang", it's a "we 
don't have data integrity because fuse never supported it, so waiting 
here is simply not required".

-- 
Cheers

David

