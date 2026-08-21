Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E005C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 09:35:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5B036B0095; Fri, 21 Aug 2026 05:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B32B06B009D; Fri, 21 Aug 2026 05:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A498D6B009F; Fri, 21 Aug 2026 05:35:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81AF86B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:35:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0FFCFC03BE
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:35:50 +0000 (UTC)
X-FDA: 85124769660.04.D741543
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4599640002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:35:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ybx2d0qc;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787304948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M2b7depORYOpe7iBmdnQUOKdXzN4AqhClHk74YTKfa0=;
	b=D+eOghpMgsbgyvPLfBoXSNJX7HpVgtLZUbspC1TlDoQBx1QZSc6ZB8qHnVrGHADivT32tw
	S/T2rewqB2aNeFVwTGsgTfmxVMWIMPrMZ1Wgb4dPc4B/AOzSnvYA4RPzfAinPEUAAwwhxl
	rXQWJTn5/rcZs+EnbVHLculRRF9MAyw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787304948;
	b=OOPs2UetqC+Y4DX5xuvb3M/dSs7/5Ho3i1sFd2pizJ+8NRFZlf5FFe7zQQRn49gVWEWSXA
	c+/x2Pe/6HURt5ebMU6NI5CvOz8pLM14oYk9BJn6CPdPs47eT0PY61S5aQ/xwu4uWpZR+u
	grd3uQ+Pa6ls2X3UWONdVLzepvBB/hM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ybx2d0qc;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 196A94328A;
	Fri, 21 Aug 2026 09:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763161F000E9;
	Fri, 21 Aug 2026 09:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787304947;
	bh=M2b7depORYOpe7iBmdnQUOKdXzN4AqhClHk74YTKfa0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ybx2d0qcbjFy8oda/M9EkTCbTZVsfTq5k3Z+69THEtOtJUa9tgYLJHxB+NTx+rCmH
	 PmgmuNlohvFVpv2pVfg9qQMHbcm1AjOsCSd8JlwL6/nM+wBNCkM0kuz62GeUI/NQYv
	 7eIRLEOx9tTIlMqt+gfNmTW3Oji0qqheg/TdTTZSNBTZN0sEczGkGfKfJY+9DUrbJX
	 vL3gqc+srQF5Phke/TrngURMjYrIUMEh1AJqj0/MZo2qMTrTT9rWseYZ6LrTXv9yAY
	 Vf8fMSEY0d35qYvwPWVMt/F74FCTAEYxL2RLTYi4xJRFRntWGKmHHqA0yBlxKP+K55
	 ElOafvaTr2uSQ==
Message-ID: <774ee653-5f01-4a06-965f-fd3517743c08@kernel.org>
Date: Fri, 21 Aug 2026 11:35:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] kselftest: mm: prevent random failure of huge page
 split for khugepaged
To: Yeoreum Yun <yeoreum.yun@arm.com>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
 <20260820-fix_split-v1-1-ab430c58c7cf@arm.com>
 <DKU173CETFYO.1RJA1CSOC5S99@nvidia.com> <aodwNr_zgOn55z3W@e129823.arm.com>
 <DKU60290OED0.12P9UF0Z97DND@nvidia.com> <aoeT20fPw57DtpGe@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aoeT20fPw57DtpGe@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 8fmcaz9zhjmirbd9xitu8aji35e9xmsr
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4599640002
X-HE-Tag: 1787304948-619300
X-HE-Meta: U2FsdGVkX18sE4HtuUQxq1cN3tzat8Oi8LXBrbB6GcdZkGz3iq/TtMyQ5n+BIg7BfAeEdS20mzDqp0xgmHv2Y08FhJDa+UL6+DPpsjMD3AO0u13dk7ySLMNKJLk/ch/pFfOK045pzvra7K+lpjSWYxvYl2G6c9Nk5I3M5AkQJSLb8DR5ngnakD8sZB0SnEQPEFn/vMHlrK/l6f1VUzNfSfvSjwMdvC7KacZfEPk+zHfoH7pDMvhpsds+qEkuVNylscHGUx9qMJXE04yE12/KpU44WWsU1XnFozu1lHmSF5HKjjEVlmNxgh/wOZCM58u0LTZVMzqMhITZI08dhh3dBGqrNxHN5bxOOY1mZrV12EEHVthV9r94YcuLttgr+HbTQqT3xFBVG/49EBwv+c0qIVFU56BLJFwTZemZyUeZBd3t8QmaHjeS4p/wnAIDYAArASz0nKyUlMbMOwWfLAMLwwzOqYzrIxstkrZWtUTXbGFTiAFJ75217VgbslOhp/W3hZJZJnxqL5fVcKmPjkgy3aF113KDNJ4QXPcXXpg+PhI8pxh5IuFgWjsDNYmAphCC0hapsQgWP8suEvkvHJ7vccTNsJFrewS5G4q4PW1mHtEDbcX9+PZ1W7CXtTV7c3+sAFCu8bGMGBFou3GrtApgLYvh+eUAEDE/j0YesWa0y0w9jGzVn7Ze0w8m3yWf+SiwU0lUiu9vcywbowhvy6FMGP5+02pGdZ5lJeI31Lh75Ha7loEGmtjvx5N9ZjLx566h6KArb26/NF6wpFFh7m1HIKhZ+BfuLOTyTpBNj1e+VspGutw0k6pk9bcjR6sD9QsorSleKpyHmw7y4D2jvljGvNJxiCmmgf1hxZa++zKb8TOVLyxByeivzVuQu3jf2nYGtiCZ7IgT6sjL5km5eudw3Ca1vF1H2UfrqO+Am3FgUR45FXfjUDxv79Kb5lqMudBcOM/Znich7jEj2HPaHvi
 5xOZjoKW
 92AmTTFPLbCqhQ7hHhkhYGfyb3IedvkV52SEsb6EAhfj3bds3lXL+mVDZ24EZcMLVrqBrcDY0YHY7VQGqFLYS8/sPumrLeJWJ0Uz3gMHYM0e4YDHG5h2vbpXP5P8nh+4pXwIHapmNNwefJemFzHFyX8vTXG4eHPmF3wt9tTv9fytNcRBu+/pPkCAQdTt0KTxWE16YDUmHXtPHizpVvPo87QU68UU3bYTtCklaPtMqtRazeGcjDdoRQ/BGqOvUyBAMbK+N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/26 01:55, Yeoreum Yun wrote:
> On Thu, Aug 20, 2026 at 07:37:29PM -0400, Zi Yan wrote:
>> On Thu Aug 20, 2026 at 5:23 PM EDT, Yeoreum Yun wrote:
>>>
>>> Well, this also works with hugepage_save_settings() and write the
>>> khugepaged/scan_sleep_millisecs with the maximum integer.
>>>
>>> I don't have a strong opinion but since it seems more hackish way to
>>> change scan_sllep_millisecs, I use madvise() with MADV_NOHUGEPATE.
>>>
>>> Would it be better to change using APIs in hugepage_setting,h?
>>
>> No. I did not realize there is no way of stopping khugepaged completely.
>>
>> BTW, I am curious about your khugepaged config causing this issue.
>> IIRC, khugepaged scan interval is about minutes and
>> the time between madvise(MADV_HUGEPAGE) and the second
>> is_backed_by_folio() should not be that long.
> 
> Yes. it's relly timing sensitive and I've failed to reproduce in the
> real hardware. but in the emulation environment it often failed with 
> the scan_sllep_millisecs as 10 seconds while the test running.
> 
>>
>> For your patch, maybe you want to check the return value of madvise() to
>> make sure it succeeds.
> 
> Yeap. but it seems enough just worning message for the madvise() with
> MADV_NOHUGEPAGE.

Yeah, I assume we can assume that we are running on a recent enough kernel that
supports MADV_NOHUGEPAGE.

-- 
Cheers,

David

