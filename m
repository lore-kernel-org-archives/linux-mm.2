Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6141E6816B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 12:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C3266B0005; Tue, 17 Feb 2026 07:42:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0466B6B0089; Tue, 17 Feb 2026 07:42:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E949D6B008A; Tue, 17 Feb 2026 07:42:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D1F4B6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 07:42:50 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 79F2C140116
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:42:50 +0000 (UTC)
X-FDA: 84453912900.12.C409F70
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7B783180006
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:42:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nd0EUNwq;
	spf=pass (imf24.hostedemail.com: domain of pankaj.raghav@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771332168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hHe3ZejbOvudEwAFGp4CJMQCUggASakx2SvWy48y3WA=;
	b=ymMokuXeaZMXPQ7ieroPxfwS9n69MoZmPo2GXb2iq5/biEQZ61qVPuZh+OtWwEMA+9HUQ9
	mFtyeF0q14xv2h+n3pEOh+TasPlFJHdf+h7ANQgdjp+3azXsUc5TVVfmZrJt2B5qZy7S45
	AiZ52p2YCNuD+9GyIYagsd/S2cNqgQY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nd0EUNwq;
	spf=pass (imf24.hostedemail.com: domain of pankaj.raghav@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771332168; a=rsa-sha256;
	cv=none;
	b=0w7E158nzvij4+J58yzyx+7PNfHElFye6LJr8O+Sb/giqtFLx/9rHDSdZYWJ1rbBy+//5U
	1xG1AkFWkTUYgSMKcliZFr6LSAwxlwZ6byvZhB0FjtBT97mh2CA23FwUBmU0l4n0iWRcWc
	Mdy2b7y+T0kv3EfjR8BRxQvRs4bazzo=
Message-ID: <4627056f-2ab9-4ff1-bca0-5d80f8f0bbab@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771332166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hHe3ZejbOvudEwAFGp4CJMQCUggASakx2SvWy48y3WA=;
	b=nd0EUNwqwPgsrOW39DUKMqi0MAu86LgmPAc45mvnFMyfd00VVEkLVG905HJY5LjZtYOxhT
	2xV5Dft2o/QCfaaYr5jKBgtQZr11QWsPRVkswFGstncp2L532LR9+4PX7FtJzluYTGY/2b
	QU9DrWfQEvKcvV0+uS0eYFGr/IRCB1A=
Date: Tue, 17 Feb 2026 13:42:35 +0100
MIME-Version: 1.0
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
To: Jan Kara <jack@suse.cz>, Andres Freund <andres@anarazel.de>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-xfs@vger.kernel.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 lsf-pc@lists.linux-foundation.org, djwong@kernel.org,
 john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
 ritesh.list@gmail.com, Luis Chamberlain <mcgrof@kernel.org>,
 dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>,
 gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com,
 vi.shah@samsung.com
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
 <zzvybbfy6bcxnkt4cfzruhdyy6jsvnuvtjkebdeqwkm6nfpgij@dlps7ucza22s>
 <wkczfczlmstoywbmgfrxzm6ko4frjsu65kvpwquzu7obrjcd3f@6gs5nsfivc6v>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <wkczfczlmstoywbmgfrxzm6ko4frjsu65kvpwquzu7obrjcd3f@6gs5nsfivc6v>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B783180006
X-Rspamd-Server: rspam02
X-Stat-Signature: cuqzz66hrchnxj698x7acjz1w1cosdfp
X-HE-Tag: 1771332168-465666
X-HE-Meta: U2FsdGVkX18KjhWPR3Qca7SrkzJy+ulH5PCtsFUZKN9q7APqtPTlrf0FB/MfMO5hRw30aEnbb0LD8FGH9bXfp/r4s3vDc17csarhnlS330CA4XK8LnpfbFolwBqrZlRgu5Cn89YBpsMUn68XpbgFFA5yQW3w0qi8r30HwGWdMDO5XJhDuzwGtyIRsQP7NtN5FHWOXxlt3Z6HGA2f00EwfvaorP5LUst2vrsSA1u5ybkRWzTg29cUywZ7Vr+NAVIqV/5fQfWgM/PRQHBprhPMj1IhQ1D8M0wqDORhOL/BQSv1j4m33Id1pb1cKJdwgInlf8reJ8L9GxpEVLzU3j8jMPvZ57cd5e0EXh6imUwZMyD+DZpzwbS58SCPN6VFK4+0wd3XV2TuPDpVG5hM3GiuthhN9LvAb98Ht/1hSpTvl0xcyOB7yRYO+4timqzXomzJyXrMUkIwDSIKfHn7tXS5L2TEaaYpHttCxFOrI7mHpccMUrmsXYLm1ZPwA5Bwzq4RddjV+Ad+nfbduTquYxxdRzywTNRKUYfye/q8h3KWQKZOUS0urqMlk14HE1AlGyC+wXMK2DbfuH+WQmmTdO4ulgsRJ8As1eEfoYOa597Wcj8mTqHCN1kqAjhm2TQ9E+dCT6J23LXO7fl0k8LjgpRQzyqmiFbIEVWZUKRsa2qXh9aBb+0khSD1zIP/Xz9lkGmol+TsMIqKs50w2sotNU2L0+zFqd+6kBHLKwNuXlQ+nTN2aWft72F3/ePYQA9olMJ4cf+lEOPNuY6KxZ+nsWQ7KqZfS1Yom2PqO4qEhupl5ofM37AxkZEx8BqRqWa0/chTlYZXhECcpMnPsZyvfr698f/Mm+xLFSsAOq/r3N2TpCG/qFj2wyFKB6LBV+bqDq2fiVOIOsa65bj/Br2kM3usX4aUgQy8vEt/N0dPgOJ90R7Eh9FtV3z7guv6Q120woTPYXCRakoszmjuAbqfwLn
 WcToxKQL
 66lDMt8kBF7FXBxzs3q7DIdcVOVJrY/vCdBp2JFAu8X9QApEHoR5+jEOb28hM7xI1O3OoeG5nvIywSuVWCza/4fhOtKGov4FDGRPq5SuhL9xaABQHRi3I/isXr3mA4JA5M9ATLPLPu7TOolBGAXB9jRWUekwAu8ou2tbM0opK47BQIIVBqQUCEMmfl10OyiJCRj2Hcjm1VrG0ENazvQVfoKE39inWsvNv1quUwi+pJbeT3F+oD2WL0hPOTAawZQMbG8FLc53IZaihvUJAXZyHvuxMVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/17/2026 1:06 PM, Jan Kara wrote:
> On Mon 16-02-26 10:45:40, Andres Freund wrote:
>>> Hmm, IIUC, postgres will write their dirty buffer cache by combining
>>> multiple DB pages based on `io_combine_limit` (typically 128kb).
>>
>> We will try to do that, but it's obviously far from always possible, in some
>> workloads [parts of ]the data in the buffer pool rarely will be dirtied in
>> consecutive blocks.
>>
>> FWIW, postgres already tries to force some just-written pages into
>> writeback. For sources of writes that can be plentiful and are done in the
>> background, we default to issuing sync_file_range(SYNC_FILE_RANGE_WRITE),
>> after 256kB-512kB of writes, as otherwise foreground latency can be
>> significantly impacted by the kernel deciding to suddenly write back (due to
>> dirty_writeback_centisecs, dirty_background_bytes, ...) and because otherwise
>> the fsyncs at the end of a checkpoint can be unpredictably slow.  For
>> foreground writes we do not default to that, as there are users that won't
>> (because they don't know, because they overcommit hardware, ...) size
>> postgres' buffer pool to be big enough and thus will often re-dirty pages that
>> have already recently been written out to the operating systems.  But for many
>> workloads it's recommened that users turn on
>> sync_file_range(SYNC_FILE_RANGE_WRITE) for foreground writes as well (*).
>>
>> So for many workloads it'd be fine to just always start writeback for atomic
>> writes immediately. It's possible, but I am not at all sure, that for most of
>> the other workloads, the gains from atomic writes will outstrip the cost of
>> more frequently writing data back.
> 
> OK, good. Then I think it's worth a try.
> 
>> (*) As it turns out, it often seems to improves write throughput as well, if
>> writeback is triggered by memory pressure instead of SYNC_FILE_RANGE_WRITE,
>> linux seems to often trigger a lot more small random IO.
>>
>>> So immediately writing them might be ok as long as we don't remove those
>>> pages from the page cache like we do in RWF_UNCACHED.
>>
>> Yes, it might.  I actually often have wished for something like a
>> RWF_WRITEBACK flag...
> 
> I'd call it RWF_WRITETHROUGH but otherwise it makes sense.
> 

One naive question: semantically what will be the difference between
RWF_DSYNC and RWF_WRITETHROUGH? So RWF_DSYNC will be the sync version and 
RWF_WRITETHOUGH will be an async version where we kick off writeback immediately 
in the background and return?

--
Pankaj


