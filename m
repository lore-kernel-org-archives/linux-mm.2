Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19715103E160
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 10:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D77E6B0169; Wed, 18 Mar 2026 06:50:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 188CF6B016A; Wed, 18 Mar 2026 06:50:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 077816B016B; Wed, 18 Mar 2026 06:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E396D6B0169
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:50:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A9881B86F4
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:50:38 +0000 (UTC)
X-FDA: 84558865356.15.7FE020E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id C21EAA0013
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:50:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hAN4uUE1;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773831036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iI+YGwyJk1XEOWYrtPhgWgUumNgPkqT7s1ZYpPkcdrw=;
	b=IY8V+y0QEtiOhqq2ipy+LUwSGB7wp1weWh7oBkFMp6sXYE8rLa1mm2BOTKIpb9zD4eS44m
	GUFPrrbdyDlnj9VVz9q9Mvx/zsM3DtYbHN1fQlYcTuu383n8eC17WcRMmKJfqgj0VfPcM1
	67VbtFthwdMaXPO2CzKTRtXEAul/IUU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773831036; a=rsa-sha256;
	cv=none;
	b=PoD5Fcsh9a40B7sE5tgcfVaW7hEOWoMBbB1iCrthsvD0SNJdSeA2JPOJswab6zN3G9/A8a
	SraJojZcn9+HmfAtGRnl+Kyoalv8+nAWrI2DwJoi9J9KvZ0s59Bvuan7HsVwaff3zGQ6iy
	5l+LxQxeCizRk8AfHywa721oEZWIc0E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hAN4uUE1;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 51B7443B2C;
	Wed, 18 Mar 2026 10:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B979BC2BCAF;
	Wed, 18 Mar 2026 10:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831031;
	bh=okXOWphObIXIAlBWIeZzQv6uCPpw5hPKczJAOq3IjHY=;
	h=Date:From:To:Subject:From;
	b=hAN4uUE1gGNmN7j+iUAkSBQChFbatzDAOCblBsGPrfxuCNa3ThJwlQy41HXXC2Njc
	 66I/epeuhWTKKads/gv9CM5mRpOph+ztIftofHCf/MdML51Ep6bRFQjuN8GbfudYR+
	 Xu2JJ3tjGPn85u9t1C19SnO1Ydt26/z593eM0v+D+2MjsBAKpYJ3dZBcBnwtk+Fo68
	 6LGnabQrJsNOZtk3urfRuhGfHh8ppGQepeEw65oLT/kezPgcbvKJfq6Dq9A1QneC8R
	 c9NA4E1lUwKpfdeznlekxn+zfmb4nV3Uy9pKFlP5Vrh3c4QXTbYCizItcUUftquObf
	 JEJIy8oH62IzQ==
Message-ID: <22d1bdf9-4d21-4252-8558-e9618a409bc5@kernel.org>
Date: Wed, 18 Mar 2026 11:50:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-03-19
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C21EAA0013
X-Stat-Signature: z3c3d8ctgykk9fkii3duz35rpzwpa473
X-Rspam-User: 
X-HE-Tag: 1773831036-875684
X-HE-Meta: U2FsdGVkX19zVtmfHL/f1Rlk8hf9rkZ9KH0+HxEasslQRIsu9aP0+rtjClnY5G5TgkZANcIQdEdwrn5m/TN+0gVDFglUb/+q+iTyjWY6IGp6vCSNqYLg/YAyEIvXVrxCoHJ5wRfy3UNDF/XPWbIAxtf6qDI9vjebUbuWkYkO6e8SxjSRUpTwUCHFtz5p7aiDafk1sNjJ73tJqj4l3IzjidNZUrV10d8RG8bpUSPn0sCeje1emH0RtNc0+KqhAtgcLJIWfDMReLKtB5rKkexF9i1qf3OF1/vzx4505JDF1wY/tNv+TxidcjPCoifpQd4nN28dw8fEn/AelAmFm4KbGZ8p5L5lkz9MeBiPjPViA++WwZnyRlOXtdCVtkK4GZ2OwTeazIoEOqzOZEasRXpCLg3lW4goU6FvEGl6BdyyW2A/8SY7pJMBysiMvsiwZBDEJltRPYtcZv0FeFpm9pVgJCp752mVPIYgXoe4/xTmq5F3N/xikzFvYNiDh2gWExDmAATIbXDmRNVhTRrA0A/zEPwi3aUwpK9oPl1jQFGNbrkEfdeaZ8KKhDhDcuno66PyaYWPJvZKXRA036KyTC54tZhZUtVjZZ4PtBebHdDuZC10wqTrhKJFDhq1e4l9pL4ukgYQXNwk3E5HV+0f8G8r50u35DMCKkPAuY2+zL4dWj0jUA2l3oFSNgyF7DvG46xa6SR1kKD/WybYYihI1ZvOBY+qBKBzNkRs5VUcn8gtSvDsgu8/lB/n1MH8CgVg2t8yNTtCbeNjHj1LNrPiC4CiCormUSMwLX5crTrWxnJ5q769CCzy0V4wGztjDgKH7uZn29dNVeEhNTxJfxga/bqvYQhNrNXEf+sA8nravZHIBp41V0IMlO3PuDDkDgTO4ugbxguPoFyDo+jYI7Vfc/a1Dq8Od55q56MqvUW/OYdRjaJDeWC2uJFIolAEYYHNFofNp75xHDs3TTmWLqRUqQb
 H1GIJGOV
 kVqn7lzzhZfkTAkJOARqgu98gleWXICbk4yYf4DmVuvVQUNHsU1Hu3ZRXBM1yLRxXjeTzjk0FuAZxj5AN8JNA7zjvS8BNhIBUzif5i09x4uPyz61TYiVhvuDstflOHtfqY9mxkG+MeHoblTaIPjecJXq9T2owvyRVCf6Yja+yyv4lliRhARXt1Tm2ij2TRPRfvGOQLdVvNZb49pNczNqWdxqE6n118upns3HokW+KHo2QUgOQXTbbKXrn/jSJhRInfaXmiaw9OjWNYmkJWTEFQMgKUuBoeYXzUThDdIjs19lSpAR+/+NdogzNrJ0kLQz9HaxApFWT24ivawC2tUEvlJ6Tj2BaaWT9qjiFU2PBXjCUfeJpjQBmsUgT4iSmodca2oq7F3DmRVlXVpQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2026-03-19 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

!!! Note the GMT-08:00 -> GMT-07:00 change due to DST in the US :) !!!

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
or Ackerley a mail.

In this meeting, we'll talk about the in-place conversion series and ABI
implications ... and I'm sure other things will come up (pKVM update? :) ).

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers,

David


