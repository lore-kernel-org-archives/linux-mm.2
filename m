Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8658EE7BDB8
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 13:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740486B0005; Mon, 16 Feb 2026 08:18:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EE136B0088; Mon, 16 Feb 2026 08:18:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EC686B0089; Mon, 16 Feb 2026 08:18:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46B796B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:18:19 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C75168CE8A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:18:18 +0000 (UTC)
X-FDA: 84450373476.26.70A7F98
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id CB20F1C000A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:18:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p48jLXCy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771247897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V05ejPvopLo9DRbeUi1eZlG4ZZP00I4HL4AVm44w2ig=;
	b=oIO6rGN/2ze2ftGLd97qjv+w/auKqHHAgFRG7M1PZX6LV4PDlhv6+Dfbdu5ZMJkbppL1U0
	gsjgYyHV4iuuTgFr+Fuy18ziyme8U7bCNqJd1XDebThx/mqR2wBXFkwcnzwgkloZ5B+aWn
	g8ltUDy9hV2EshO8HunIKZXbJjTQz9k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771247897; a=rsa-sha256;
	cv=none;
	b=po32qkqh+FWbGiPuh4HxZcCQyAyQOekbWHLvBrTKxaDD34aCZkb803ScHTngW7L+E2vuXX
	fjCzMI7Z92shCYRIVOJbkDNJGvFx7XkNLTomKFTnm7bsR0oingJVkqLDvVl1YZdsABJOh2
	0F7NaI2GZLeu4/eKEYUlN23Pjez8Ezs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p48jLXCy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev
Message-ID: <c29d36eb-0706-4f3c-aaed-de7d9ef74bed@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771247894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V05ejPvopLo9DRbeUi1eZlG4ZZP00I4HL4AVm44w2ig=;
	b=p48jLXCyB4VQIxa8U3Gdq7k8wKO8XyymBq6W8BKSRkDN7UxEod2Qo9XWM6In41SsmVr+1X
	6bxBpYh3sSb2Zy2qbVUyeFagIxBxAeBh7JjAaEUhiDSJL47UcvZlEFoNMF1POC5KagDyAC
	gKbYB0/kLVuZKWkLCLWUh1bnjRK+ODA=
Date: Mon, 16 Feb 2026 14:18:10 +0100
MIME-Version: 1.0
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
To: Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
 Andres Freund <andres@anarazel.de>, djwong@kernel.org,
 john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
 ritesh.list@gmail.com, Luis Chamberlain <mcgrof@kernel.org>,
 dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>,
 gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com,
 vi.shah@samsung.com
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <w3vwdaygcz3prsxwv43blo4co666mragpdwaxihbirt5stl4vr@agyz4mnaxghj>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <w3vwdaygcz3prsxwv43blo4co666mragpdwaxihbirt5stl4vr@agyz4mnaxghj>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CB20F1C000A
X-Stat-Signature: 4e6jdspbi7pwrnyigpes5d9id3hm33jr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771247896-670208
X-HE-Meta: U2FsdGVkX1+g9SAhL+8gW9o4pyAFdPoNMSXwZh9qreAv+efM4cubpxpMuyHt9UsCxt3f4Shl8TJiRnOkkGgQgUVqQnzPFDEcSyk58E1SfVOJ7kfD/hRSvRDu8eBB8eMSUuEBOjBeFboCTtbI+Boy/+L4pevw76g/QXkbiUxDAQ2UNKTZurv2x8CAe0uI3bq5SzLPzuMb3d7FCzTRGJFjA9NYLYGRTiRWkL1QunIDxk/N0w4T5lu496ztTl9HvTG6eg1wMlWHAHFQGomlDGcXfOtMHmxBbkKXLtdnbcFoyw2Z87bYUsFGsi8St0q9IVhnEPeH7dnaY/mAzsORdh88zo+4l2G+6/JFZxJ7OnqF/V58MuEVYdVSRpL9S4mvpd24lxOEHCIYOxQN08V0Ez+KjLA0aJ9r+dV1m3CkRMPAiwODvtxR+5QVYC0ujQFqPHcailm+TgPAReYGtu8DV90UAT/yAjvkYAZUin1dGYoC3dAoGNy4aqtTnG8lkXlSpVP2Nhf0FW9AeygL/cPktj68mg44OHX3qcKRi3BgqbAykOtqEHYlTKG/xxXbpk+aD64iL+pquISVK04W7BUY1yGatxHFIIMzHfaJ7j0u74xZ2nnDZyN0aIuANt8786BmW7MUFowJpnRnF0/Sh5Ypgrj2q9xNSywbSSr6FFSrYSP2TkynCgUWdrDYTTKk8vUelQmWvzAntqG5kyUjvhqlPLzu7Qn1/4zI1fxaVmXp9jfVSNJ02lvPwdcES59ca48pAXF0vhd1GOiXyYN56j8qj8GPKgCIYF+xQ1UZ6nOwxhLI4UL+8OkBrmNACAgKdZygSB3xaojCcQck4Xl8vhkFboqlgpsFnizGaCDvBejS8Wj4qSskw35WrqWa2fbqOXR+fNMcNu0/Tfii0hGx7A2LRSAcVrzXU4O90wkRoEzzSXmJE7XY69bs6Bj+ZiD9XFCvupNC5IRcy3AiywmN9C/bqjC
 Dbd4fWUK
 hFSbspm2eheYkSeqmtw60sJcXTP51fD2pMJUrNAhlXhdFnQAm7PJqBuf+H2q5v3iU+L4g8KePZWZJ+TRcPN5egMbDAlraf2zNacWO9czUSsXRZ1DHyaV408qOHvfVdB7cioy09N/7mi4Z6I7AO6XxdcpByKwhyB9/a/Wf9tpjd40SsVRg3RSHgF2mzk/NmPNVskYD/SHmmIk5lEHm3EEVi+Uz6dK9GqgLGf6eDFDBMU8IegDqlvoPK2EcrM5SGLAooDz1ObaNXREJ7VU61D2iRm5KuGBgVMXjIvqpqdm3QJjsXc0LW2uczoykbTuDytx3iI/YiKazoL433O/y/g8h453K8udZ8+2jyK/ISur+yw6usRQKjOCwdOMPZxMZYHL0CqIC4xey9zggnZKPX4h2isUmpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/16/2026 12:38 PM, Jan Kara wrote:
> Hi!
> 
> On Fri 13-02-26 19:02:39, Ojaswin Mujoo wrote:
>> Another thing that came up is to consider using write through semantics
>> for buffered atomic writes, where we are able to transition page to
>> writeback state immediately after the write and avoid any other users to
>> modify the data till writeback completes. This might affect performance
>> since we won't be able to batch similar atomic IOs but maybe
>> applications like postgres would not mind this too much. If we go with
>> this approach, we will be able to avoid worrying too much about other
>> users changing atomic data underneath us.
>>
>> An argument against this however is that it is user's responsibility to
>> not do non atomic IO over an atomic range and this shall be considered a
>> userspace usage error. This is similar to how there are ways users can
>> tear a dio if they perform overlapping writes. [1].
> 
> Yes, I was wondering whether the write-through semantics would make sense
> as well. Intuitively it should make things simpler because you could
> practially reuse the atomic DIO write path. Only that you'd first copy
> data into the page cache and issue dio write from those folios. No need for
> special tracking of which folios actually belong together in atomic write,
> no need for cluttering standard folio writeback path, in case atomic write
> cannot happen (e.g. because you cannot allocate appropriately aligned
> blocks) you get the error back rightaway, ...
> 
> Of course this all depends on whether such semantics would be actually
> useful for users such as PostgreSQL.

One issue might be the performance, especially if the atomic max unit is in the 
smaller end such as 16k or 32k (which is fairly common). But it will avoid the 
overlapping writes issue and can easily leverage the direct IO path.

But one thing that postgres really cares about is the integrity of a database 
block. So if there is an IO that is a multiple of an atomic write unit (one 
atomic unit encapsulates the whole DB page), it is not a problem if tearing 
happens on the atomic boundaries. This fits very well with what NVMe calls 
Multiple Atomicity Mode (MAM) [1].

We don't have any semantics for MaM at the moment but that could increase the 
performance as we can do larger IOs but still get the atomic guarantees certain 
applications care about.


[1] 
https://nvmexpress.org/wp-content/uploads/NVM-Express-NVM-Command-Set-Specification-Revision-1.1-2024.08.05-Ratified.pdf 


