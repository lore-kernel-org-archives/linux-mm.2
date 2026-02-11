Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 913DDECD6C1
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 16:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90E756B0005; Wed, 11 Feb 2026 11:44:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5DA6B0089; Wed, 11 Feb 2026 11:44:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F25B6B008A; Wed, 11 Feb 2026 11:44:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4786B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:44:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D489160422
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:44:45 +0000 (UTC)
X-FDA: 84432749730.28.0B7B641
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 735EBC0002
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:44:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mOFAT6+9;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770828283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+C3dGoDWQJizu7m85eqT/j+wMTyTYOp+wAS3fiddtO4=;
	b=I4x80kr+xgUWj5Ui5koC20Pwh0nLUSBvYOFzmbcTCLYC6xWsYYTaJ4VA2WE+jjDAuZbKj3
	ZWMTiwGEjx9PwxaU4f7tF8apqencHiCT+fsP5x0vm4Tk+VKL9xu+maQB+r0/oEnu2scQWo
	+AQKCqaJ7fVakb8Num6EZg0PvnulEnw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mOFAT6+9;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770828283; a=rsa-sha256;
	cv=none;
	b=e+d0Q1Asgk3CRYF6ANlAWkLa+Vy6mfuPvMwoXKPnNXzT/puWzOmVccgcJaSsOC5EAy7+me
	e7WyX6srjU19oMMCHKDm7TYmMijNAbqWDKS9pjMtGTE+QLYpmb/Ryt80vCUGpqUsRofZEd
	jeYouOoCyxtxD9VDsvbYuBzUVHhPtjs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B5B8360053;
	Wed, 11 Feb 2026 16:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6C4C19423;
	Wed, 11 Feb 2026 16:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770828282;
	bh=zZDwXGHABkyfgI6f7GNhk+hSENCHTcuRnUJ7iiEY6T4=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=mOFAT6+9r1pqOhNwJyH+QKiM+kKmqWwbpVUCw9nACztYjI3LjrfapKAbq9v0NzYlJ
	 99FrmI0VZ2i5nCI2BcC8zB0serNLSjVe2w9p/DnbA+brDwxiS47HdaEj4MAEEdhzMZ
	 ytwpHrw3OVv2lgz8LhrFq1VR7BBsnsKP0sqX/9B+VWSyYVmL2LJVfnJXyyEWPYytq1
	 mBa2r65CDpnCL7fFZ7f4CaFzv77qo9a9eWArS0AiRjmCY/YrDhYEE0LKh6+W+wck3X
	 GdoBvQH0lfs0hgoMHhLAwGvLJUmBKluUvSt4yDZDf8tMuNSLMF3BRM5Eqrp8PIkR5m
	 UjG2oXgs2WTAQ==
Message-ID: <8a186f0f-c192-4e89-a11f-705c78d52233@kernel.org>
Date: Wed, 11 Feb 2026 17:44:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in
 file_thp_enabled()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Ackerley Tng <ackerleytng@google.com>,
 Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
 vannapurve@google.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
References: <20260209033558.22943-1-kartikey406@gmail.com>
 <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org>
 <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org>
 <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
 <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org>
 <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
 <CAEvNRgGvZbRLcb4JbXjsLUX_V59EApHYTQc49X3Jq70GxovD2w@mail.gmail.com>
 <5759bfba-f235-4b2d-bb30-919dcdfe7b2c@kernel.org>
 <CAEvNRgH1rzZopht8HoKh_Z+HsESMnpbgb8n3o5ezf9it_CrLsA@mail.gmail.com>
 <3932d6b3-5de9-4c84-b60a-f2a8cc2457e2@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3932d6b3-5de9-4c84-b60a-f2a8cc2457e2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 735EBC0002
X-Stat-Signature: dqfzrr5myt3swr6if8wy7r1uhje86knj
X-Rspam-User: 
X-HE-Tag: 1770828283-127214
X-HE-Meta: U2FsdGVkX1/trenIljrAi6kPJZTErPB4xtx0Sxvgjo8DMPzM7TJLnYJ31vT2kLRl4+7LBx/Ipm5D/jjrWfYAoMwZN7p7qcYPUig+ww3lccujMi/UlJXYa5ljY+Up4D9887m5bKDlCBuhY7f+dgZvsgHHvguB8PoermU7u0xlQjvlzvmi8B5W+TGh5vhXFcT8Yslfh20ID7yKu+4hfOZuqtLwrsM+SHDGfX2Rvy8DRTIglsbo0KutgxYgrgzz+DDWX3sC9Z6kVVffWmhLpR8GvLW6pxbo/S/fBp5pjklF58fOR/hTYfRu/kvnlH4Qr3bk6GSuOU3F3QSViZdoB34PXj2zoBHlY1QcfHqCv5BWHig38jVIwCRwMXE/K87s2Y6eBSRAuOrxHA+WHJ9+a0A/kRRzl4d7ykJjVr/h8LG5/SNY693vpVwEm4sp7gQitUGh5RKigErmCWBzBWYtDz+5zOKNdW07m+t1M6Uf+TlAGPRFeBhXCEVhnNBZt/y+tit/gYjJoKoT8RLUbk7hLJ30MPQwupzawopOqYqYXLxGS54XWBpsQ7a3QyB5xyCjCfzs+bVj8RAce51yKf9BxYKFsP/AUBphkCWQl3adpDKqhsOy6W0xOkAP+oI4rneegSKLagAOm3JAmgEjw5DVK63RbiQBsv/R2iLFmQ66hTULiEk37d1AP6gy6jQXJrSn2eSKQc+DzAd0Ox+HFPbsq5NdG7WFomRz4qGXmLPYIxjOr1voCFHRh2TTvtFMpHdjnM4WUZmC8ibJSJNLnlf2CfCKTVqgVkM+joZuz9U1eLUl9S3PT0jUhKT299s7rpo53opP4f/WsiA/1LsITQKhD7skq0hmcdYe7XAX1sj8hXbXcQ3OqTm7uI+LKpv5YBDPuJl5/1X5XNqWYNmbORRWrKYWCTQkXVoKhUF//KyLYoinnUXikMH4yGEdd6boMS4p8rJXo0U/CBRSIaf0sXVX1FC
 QhVC7F9M
 IxWfpRQdzVk3uZlvSwEjUu5i1WKACOv4BtjPeZ1saNxbaXLeQXXnCqbEGCyKKGNW+peMpqxCiAVVNB7fiHtZGI1skxng8oscjQB52d8CujbbATfTN2+7wssPzYIl1Kb1uk6HbVp33OIpsIjZt5vgzvr9Gfy+MCY233N7Ri7wQJwHPV+ONcU9fGkPylZG5zvVDSZayNqB4U/DNRcTf5IuslO8oQIryIvImYdTiUupvYTvgzDcka4rHKlTxi7e4XELqcvK482LybKpnO05+GiDKhXxg3MGjWNxYa1a1aX/Tl8LovcLYFZh4O+q2Y0vviLUX089mrWdB1DQdIvxzjDOwI5sHTDeIIf+7dSsj3fKmCIP7dbhYIy5/jo+E96kqQdxnoSAI7dl+etBRNGCRvQ1gToyttiZ+FPBhYhffgmWTLCsIcTodtmsAJ1sbhPKbybsO7EGR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 17:35, David Hildenbrand (Arm) wrote:
> On 2/11/26 17:16, Ackerley Tng wrote:
>> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>>
>>>
>>>
>>> Do you have a reproducer? If so, which behavior does it trigger?
>>>
>>> I would assume that we would suddenly have secretmem pages (THP) that
>>> have a directmap. Or some page copy would crash the kernel.
>>>
>>
>> Is there a good way to verify from userspace that the directmap hasn't
>> been restored? Should I use CONFIG_PTDUMP_DEBUGFS?
> 
> Anything that uses GUP must fail on that secretmem memory. Like doing an 
> O_DIRECT read/write or using vmsplice.
> 

Ah, but that might still fail, because we can identify the page as such.

Hm ... we'd need some introspection interface indeed.

-- 
Cheers,

David

