Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6758606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 06:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AMgrSOKG
Received: by kanga.kvack.org (Postfix)
	id 9008B6B05B0; Thu, 26 Nov 2026 01:39:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7BB6B05B1; Thu, 26 Nov 2026 01:39:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7116B05B2; Thu, 26 Nov 2026 01:39:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52AF16B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:39:24 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D205340319
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:39:23 +0000 (UTC)
X-FDA: 85476318606.01.1BA798C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 17FD8C0003
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:39:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AMgrSOKG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795675162;
	b=Z3bumtYQryg9hoU4CdnPM9xv4wUZ5uPvArz0+IUm27QirrknjGVIgjBIhqqevU+FBCQafv
	OH570joianKzGkNjp9hI1ohHyCGnq/FTtOBDvqdwW/Gc+a3MSve6kkd1C14gabFp/EnJxq
	0joTUnH5xUH9p1NeIMExBOfVdN8tCe0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795675162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3McccvAI/FLaZGqGJQk/HhOZ4ZrqKkkSLebPcj1nZnc=;
	b=XacijcJ3hKivYp7L68PDZT+4KGDEr3V4m/IxyIL/buCYCUtcJcajL5Ng3HLK+I2Zg4igyH
	Upx2/xu1BVFPMEFEA5U+Hxz1aVj223kEaSkg7l/bBMTP9lkGU5o6GfmMFXtW1GjI/8mx3l
	77BB5R4QdbXBU3Yx+WpEm+dlfIHgES8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AMgrSOKG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 83E2E62767;
	Thu, 26 Nov 2026 06:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A32A1F000C6;
	Thu, 26 Nov 2026 06:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795675161;
	bh=3McccvAI/FLaZGqGJQk/HhOZ4ZrqKkkSLebPcj1nZnc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AMgrSOKGVOD1dNuClyYuqAm6kgbeWNJTX9kp7rsd2PvOmScHdG9euwHsAUA5bTS4c
	 SgF8C8JAU2yWxiXrEQ0FtbGgHmrPF0r24koMReV3vKjhRDF1rv/PCZEPWp7U/3a81e
	 DNpvQYfzAZs4uJgsXGTX5QFoj7WnC07HJk23bIQSdO9nxtkyb/2mRoxRyPs5iDrJtd
	 JhFDWcB+Usv1AqX5T/qdHRR/ZOyQg7adMRgG8hyRvL7xCG29Jc3DpK21VGOfsjDFdo
	 TxLy3Dl0HjtsoOuTPhVCzavUaYZ/VTfVkIe0A1rLN8GyGkJZIme94FyqNNZoOIkD+x
	 KK6PYGk679KCA==
Message-ID: <72190fc0-e756-4442-a38c-7b8871e6a971@kernel.org>
Date: Thu, 26 Nov 2026 07:39:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm/hugetlb: a min_size-only hugetlbfs subpool is kfree()d before
 its last pinned page is released, so free_huge_folio() takes a spinlock on
 freed memory (UAF)
To: Ackerley Tng <ackerleytng@google.com>, =?UTF-8?B?5b6Q5pmX57+U?=
 <xuhx@hust.edu.cn>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <4c7f9772.192e1.1a17d5c2ed5.Coremail.xuhx@hust.edu.cn>
 <2026102727-data-sequel-ce41@gregkh>
 <566ddeb4.2ad04.1a202302fe1.Coremail.xuhx@hust.edu.cn>
 <3b7d2d65-be96-4b63-9de6-7303d2de641b@kernel.org>
 <CAEvNRgFsS3ntQBANqaqdm5XS8c4n6KDh3aODiduf6pCczmBSGg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAEvNRgFsS3ntQBANqaqdm5XS8c4n6KDh3aODiduf6pCczmBSGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 17FD8C0003
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 4m8uooqr1qhzk97gzf99efp3kgukhky3
X-HE-Tag: 1795675161-267043
X-HE-Meta: U2FsdGVkX18Bqg3Q+L3lFIlSNbXzimetheifrz+npQRzCSOjitnbuDHoCf8wZHpyr1fIcKhlBruNZYfMBi/AXyOi93vwvYTee1ziE3V9mjxjCOm0OPXNY2boOHsUTe/3/PKUyy+xi6tn0O4ZY5Psv0Cjt/z5G/CNk3CGNShqeMy3mrFiJznirSiOFvcLW0QWF21m33xi8DP0lxPh55geW5CcmXNjy/aUrhXlLJQ9pyBMsxAzgXoB7iU7DAz6WivAK9T4/v9kfQi4Njx1hlG/o2Aq85aBjLm045a91pivL98Jo2is+DzylrI2pdsO07yai/ypxsAeQ4KzDJdGRn58iaVxBrYibkMefYEeW/2J+8zPpVL8TOQdFZ/ahHIVbcGPeH5Q2hcGYsiHC/iF95v6i+GlxrFzShKfc6G/pWO24heYPSwKYkXiI19WB1bDdGKt5RsuWGzoV7Ktr0kHikep8gdZT7EnuR10ba+1kRqH7UBrlhD5UZ+tBAGUtHADj3ReHNfhGp3SGc82R1sILMcQqiSlEPEg6EgJ3ChsbVrY1BBFvjIgcfpjjoEs5f0T8ItGCXl+XPCUPIBr9dNqsjUM0ixgSfDk0axOGyOxlWy57ohhI69a5svhYTdPUyCzaX7SLt31T4dMFsvNnq2SgZZkNnuTSjQ/SHkPNlopAOFeo+o2uMKP71rukhLoqJIVUvydde58JTQDu337mKzaQlW+vKHgMU++5n5n8OrJk7TtUKWlqgcdyCGEW38UpOlefLy8UdVmH5OPmQ5bnoF7MF+GP7C4JT/jsQ5IIWohI8IxA2OlvOvqjLVi1BcKatLXtBhezsr7lqViTS5FemGFX2HpYid62mzUVgDlLrSTUI0I5NwbjzrKZsq9eOFTPPpvxeG5hIxxPU3UGkx6psoQzfKWplmWPGaaNvdf+HY9rvbwyb1zAsy2/Xe13K9Zv6DGI2UxnhIziUZ410lYj5vojgr
 z10ThaLk
 PTo0a/6ZmV6B4CJXTUc2pVFkBkVJtLZaxoXM6F46t40mAJPzIL3JWqv9yzp7ZtZ6EBzkOyTg5TsqYnwVT+iIGr2+0Jm0LLS0xUnizx7RxIMA4fMg6EhZCs5vN7xtOjgRZ6y6H5j2J5Qxv+J9kBhAUBldGmch81Xsu/6NCvkZhlj4LiNUM0vd8ygPD7w2GPFIa3Mc9QukW6fpqTipFeJ+O+mEYmo+5+qnMMirX+djeK5qpL5t6T4Bx7ogxiEy4r3fBh37BFtp4k+jTGGXa10TIi1KSvz5lZqQ1NVOl+s1tKS5xUjBUBtnFl6/L77SBDDGVqskK7mq/c9bv09lS8DkQQFc2XldP7zS1gp8J2YhU/nkfxAnziHr1USye7Wwr6g/xtBwNDT+Yf3xz24LnWRSOu8YAls7Syh3V04gtkcLN77/rY65EYliEMZSqTbdWokDWBFlE1flECMK3hMRCBCP8vC6N4VEzJAojhwxAppxAXHayxfQOQLccu4fR0ZQm721o9Ma+U9fHJCjLxmRTdcHUG7R0ckhU991vS3Lj23OkIrTcsprS8Hbdsvzw72vUs2bQAbrC/6domaZU86mQW8gZB+QD5IWWjaGetIny
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/26/26 06:52, Ackerley Tng wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
>> Hi Ackerley,
>>
>> does your series [1] actually fix this? What's the status of that?
>>
>> [1]
>> https://lore.kernel.org/linux-mm/20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com/
>>
> 
> Hi!
> 
> Yes, "mm/hugetlb: Track used_hpages when getting/putting pages from
> subpool" fixes this bug.
> 
> I've been tied up with other work since [1] was posted.
> 
> I have a set of reproducers locally for the various combinations of
> min_size, max_size, and both defined, while taking various paths
> (reservations vs actual allocations).
> 
> The plan was to always track used_hpages, which simplifies the
> accounting and it does fix all the reproducers I have.
> 
> I thought in addition to simplifying and fixing all those paths, it
> would always fix races, but AI showed me a repro with races that broke
> the model.
> 
> Because of the repro, I planned to re-evaluate to see if there's a
> better model/clean fix but haven't got around to that.
> 
> I'll try to get to it in the next few weeks?

Thanks. It's a UAF, so higher priority. But I think admin interaction is
required to trigger the UAF, so lower priority :)

-- 
Cheers,

David

