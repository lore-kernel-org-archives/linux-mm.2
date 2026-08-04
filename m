Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D0FFC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 16:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99F126B00F8; Tue,  4 Aug 2026 12:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976DB6B00F9; Tue,  4 Aug 2026 12:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88BE86B00FB; Tue,  4 Aug 2026 12:54:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3FE6B00F8
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:54:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF246140248
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:54:51 +0000 (UTC)
X-FDA: 85064186382.10.8236A42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 05738C000E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:54:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ye8RwW2d;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785862490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TU4DUVULliKfyhAIZhJDDnI/AE8m4fPKvRa/vfVfg4I=;
	b=t0LTvPs7b+zSfK6dxvkVeKW8E7TbUih3X8AK8BRnnDl0LikA/mdBNX5+bu9wugbPfXzC1i
	KZhOVoHE6Bwnvcu+w3PiU+MFKCdJ3HfmfAYrmuORbO/2lLwBe7o+M7/mUV+lFUiCTqufZu
	ZbpskHTy5dJwcOxkNqxSye1whZaarx0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ye8RwW2d;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785862490;
	b=HjKwTdfALWc9+JAAmSTlq5G6AEimACiWTq1eMjo1RanzOG+QMKpcJ/akQrSSEF/w/PDwcx
	3I5C/t4st/Judpud/w314bEI3IDZkBZRX1hLUQvsxwUNy0Uov6LpV3eZ1w1kgpVedJXxqt
	k2CKa6OQOQKcNEn7+Dd+urSJkmF5iZk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 35D3542DF6;
	Tue,  4 Aug 2026 16:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3256B1F00A3A;
	Tue,  4 Aug 2026 16:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785862489;
	bh=TU4DUVULliKfyhAIZhJDDnI/AE8m4fPKvRa/vfVfg4I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ye8RwW2d7GDmAxjfmzVlZXjSvre6TLxVpfc43JKhWXtLMpy6Ouma/DClWqRLIq5eB
	 UAcW1HQZN5IfBulAPNrUM62ALzdQLG9ZWkUleO73vXGB8usXx2rFJO4wmD1Ui0QqwZ
	 vvYvdclQMZpe06/RaSzWm+tFMBNzelACkigUIMf+77HATpuiPmmanE3Om4NsqVT1lW
	 Lcaj+lFQ4r4HvwS8WnqU5EgkpQeIP4GEPJaupYnem4VKElMgbf9gWgrCvogPwCxC/2
	 bmGmwALZknPaG7/HKniNQ/fs0+UolugZMREQgrD83VYaMk5vezvVmpbG4/t0Mv/Evw
	 I1gcRDzynCfsA==
Message-ID: <c049dbe1-3d17-4715-882c-ca68068bd00c@kernel.org>
Date: Tue, 4 Aug 2026 18:54:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: Linus Torvalds <torvalds@linux-foundation.org>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Yang Shi <yang@os.amperecomputing.com>,
 Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org,
 urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org,
 akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com,
 agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org> <anHuLy52o5S9Nlwp@lucifer>
 <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com>
 <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org>
 <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: orf5asfzs5xmyaey98fgt69i9fxi75s3
X-Rspamd-Queue-Id: 05738C000E
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785862489-52997
X-HE-Meta: U2FsdGVkX198KWH6mQK+ndRR/zy9hTeK7AwdGjOQ8GuOwZIiPfQMoeUyNpqdyj0AgOeK2JxSccNqyvXbrNGR6ofK2QEPAjqCaHii7d/YJf/V2OvaQ9CZclBzIDUFNCmLSUgZacxJWHVvbNyGrTpE5M9cz7KsTYXcA/NyqCmNOB/PK8zvdl3ozoa5CHGUnyYN07e0OFBCFiyaAxsEpj6yjsYp4W1r+ZKrOAEqikbYW2ffjQA39qkQURm2wCIRRlyxSYMJN0HDd3ppi3mS9SGBIASrUsyZ0tEL5PtYOOw1r82R59DRJS0Bgn6qmGJ+Mt67HDyWYEWUObe5V3LTvfzlhl+D3yBOvo6hLZj0jBb8RYvkOzt869oybC5j4Y50JEsps61C4ZwTbKj2GXUGZ12GfrE2Gl/mzBeIZ4j8C+hthhkxd2H+bv0sC7BfdZCvQjJKJ8SO2BCzPgHw0B6/0JMerzYyHlwoLCdn3qHK/2GKOxHWJ7w9sJqGGOiT/Y9jupWh1aQPyDhJMu7MOyo/5MiOYUwEDfz6m3s0J0/o2JozF0g0MWeW2o1YYVgUVdDvPHqSqQp3/qkxyPP8n88fRsLVo8RXFI5OOAVfFaGA1NNXD/DLbjG23odDAdewxeJ5z7X/q5bqDPpIjzmyJee8lYm9qYkAZ2VlRHD/C4szhh8X875b+TcOMvclkEnqKABpeg9K9qfauNfmY1p/1vRBC2I5nkhBtKppWLKcvgxO+GdoY32u8xPeXhD9k2Ul2pWES426Ytm/Hgq/+Fr97yRjCpzD8XXDopyJ8mK98bAvscdSxi738wzxel20BvclBLbUTsCS6O4YkIaf2ApAknya53mHRXUUpgeiqzZiOuLCD6+gEhpcFHVnj54RJgTRi+zC0M/HWLAvWyZste4W1KtbOQT1Pcr7PCThxmKIAtk0+Ax3j+hiNNC8p6EHo6w10S4oJTuYlREB5x0hHKF/eyy2RLk
 MBAvMHwQ
 BHBcl5E+FBapoxwFM/jSu4ovsZBOo7h55yRM/MeYafRA8QLmqULy9vriogZIDOopd5BS/JfqH4hSLOa2eG2G+rN6bBYwHu89S5tJjaeSBBccuiu8ucvqpv+hyuojMUVSNYs/5RHIgN0sfFHTnTu6PFVFB5KtjC5oHqERYOwwoD2tF8uQ3Cv3ng8G0YOv6/ES4ElG3lQ4YmeqSjb0U8lT9RDM5Nj4psLqKaI6WPjamD5yr0hHK1/c3bqb/Gmz+FUhVbKwT1RgEYccawB+IX3eAyDRAUWTWOuLW0dGirbGGHGhWeYq5jhlU4LvFjCbvewTHM5TBUTqlN2wT5BdTqCBcxdLf6Kk82a9SGYgyXDx7Up4AnyO21t1RsaEiAG+9ZjEgrPY06EDbz04qfCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 18:30, Linus Torvalds wrote:
> On Tue, 4 Aug 2026 at 09:27, Christoph Lameter (Ampere) <cl@gentwo.org> wrote:
>>
>> We certainly do not want to replicate that approach. We are using the per
>> cpu page tables to avoid address calculations in the VM that other
>> platforms can do with a segment override.
> 
> Right, and I said that that's ok as long as it's a internal
> architecture thing. Not a "this is how the VM works".

Just for completeness: I claim that things like "kernel text replication" are a
completely different beast that we should not even put into the same bag as what
is being discussed here ("using the per  cpu page tables to avoid address
calculations in the VM that other platforms can do with a segment override"), in
some limited internal architecture-specific thing.

(I assume some people here don't realize how tricky kernel text replication
actually is)

-- 
Cheers,

David

