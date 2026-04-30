Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51B20CD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 15:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAEE66B008A; Thu, 30 Apr 2026 11:53:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B866A6B008C; Thu, 30 Apr 2026 11:53:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9CA26B0092; Thu, 30 Apr 2026 11:53:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9186B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:53:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D62501C7A2C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:59:56 +0000 (UTC)
X-FDA: 84715531992.19.97A2AF8
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id B6D25180005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:59:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pl3Q9Rj7;
	spf=pass (imf06.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777561194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=ltj6T683SxCXf3LsBkB1ReWgsQhETBHz/ogGUF5RS28=;
	b=7mCTCfZJ+WYA2CbS/NhS5fain5HKhl4yXcO1vuCIyfqlfRTKyNgzVKfkXcgN3dzVF0J8Pf
	RtR5yoVA/dHrPjdTR6ndDHyCX5UxXisL5ilbcQfhgcfFkEwgWqJtGzC85ol7eUop+Cf5+2
	S5YlzJCi9P53LXLrw3vHy1aldseKOrk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pl3Q9Rj7;
	spf=pass (imf06.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777561194; a=rsa-sha256;
	cv=none;
	b=5SFS1e5tJoC8OW01ZE/yLV/SuQ6sikclZrWtP57qthnrHI2QZFJGjWTGUbbDaS3gt8J0cm
	CKXl7+EA0eLudalqSrpGBrtekorVWzcbIIVdadAGmRbRZZ7xmvLGQ3downwGGJMJgSDVqs
	giUiJecZ/DYqnNzzrYv09J+gFxbdhys=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c7961d7bc09so437533a12.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777561193; x=1778165993; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ltj6T683SxCXf3LsBkB1ReWgsQhETBHz/ogGUF5RS28=;
        b=pl3Q9Rj7zkAbXHDh6OfVZJW/p8yFhg/FlDruONV9KjcME459hm18dB0WL3x8mZi1Xp
         B7xUd0+9frnKydFLHSp9ImNdScMa204SeeSPnJmPmwR4Uh9xCCpVb6nq02OjEdutfzrl
         NPdJAwEUZiw2Lw9lWXzBaqpnQRjvMA2xMXxaPWVq8sICJrzVwm2dGRG3XT8chHDyvd2v
         iqiLe99bPvxlH5I+zYD54+sPyQkgxM+nhq0qAVby2TD9MqW0VEnrisiLbeq/vOX6Y69A
         V5LbUwXaJUnSg4rQ+/aqE/y1RrUsa0qCTyz/b38ej5DIUoZgfI9gXCrrI9+ZBaSW3YOr
         VUIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777561193; x=1778165993;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ltj6T683SxCXf3LsBkB1ReWgsQhETBHz/ogGUF5RS28=;
        b=IgSNZhqHjvlQavyWrgI0puGw7cBojCGr9v/7cEYK9Mk9FWF4Tkw5bypnoAzz+mFN/a
         CBgBCUojQkjzNn6IhGYJrF5z+vkdZaM2kNDRbvYP62LJf0sFi3bKrGM/kCtswucUc5xp
         c+mxVgkD2NJPWBAvCj4fmCYqtakrg9KriG7jSCWlz0znKq8LaIz6YFhRdUWeHnpV2QS8
         0F75AY92Xu45loUpeI248fq01+USNSb/aWGxAeJsSY+4nSDP5/Twk5KH5nPhyZDEe7gz
         INF7xZcnIaxhPhzMwJplc+3G2tJ3XBpGW5yMuCwhGBxGJ94NJObqh85BnN1DoWlVCQ5E
         tNHQ==
X-Forwarded-Encrypted: i=1; AFNElJ+KVhsVJtYBV7R0EuaqW7uWAYX6l0YVtFtiH44WSca9fTNAFSsAJTVvj9N0cS3CDxX0WWOYlDv8rA==@kvack.org
X-Gm-Message-State: AOJu0Yw5dy2eZPD0WD7mEX7aKT1+YdTgQLOZM+gJamu4eGfVfsYAbBhz
	EpuHjBJPyfN/wHhTREFoxkQHWwf5kAsWgudaM9ojq6dmdnC8HR29dRCr
X-Gm-Gg: AeBDietEo4hJ52vA8pmgsdw9Rd1feuunKTOGWl+p11xIVnQBHJsqg9tiCtqs2BecECc
	6vV0ps0qh9N0nw/uMsTt6itxx6f8kzBLJi9l4mRC2Cwu3cEf4il8fxHvDiIqg6dhetS6xgcCAeU
	Kzl52eC12NggckQzkpIn2fMFCSqdd0AZMBEOMiGqQQAje2leX7LyT+xA83GKdM4NEkFS6B+xfqQ
	hSpwMbwUzJWsiJ8GbnpVK1CbmKmAAuno8L069pCMNBS5uVPj8zdztnaxNPOVRFZtkmjVxVrniM9
	tqxaPOyobVT2Rxry9PKzPpqaFJETPJIlpfi0qXhX4S8Zuwguo6YZGzr6Pr3pZxeUkILEMntLQpZ
	C4dSpr6BBkpyUFbV6S/3izROZ/gv6ARgwNYmNeJldGk7wPGlfjgJI9FeMHmDz1HZLdZ9QUp9UiI
	ORSzv0eb9Nrdo5kSooSJUZVU+sHmEY4kyw
X-Received: by 2002:a05:6a20:9190:b0:398:6461:688c with SMTP id adf61e73a8af0-3a3cf56fd5fmr4020396637.2.1777561193436;
        Thu, 30 Apr 2026 07:59:53 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7fd606a079sm5010555a12.12.2026.04.30.07.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 07:59:52 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, lsf-pc <lsf-pc@lists.linux-foundation.org>, Gregory Price <gourry@gourry.net>, Bharata B Rao <bharata@amd.com>, Donet Tom <donettom@linux.ibm.com>, Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [LSF/MM/BPF BoF Session] Numa-Aware Placement for Page Cache Pages
In-Reply-To: <afNV5wbhsFQJLzxi@casper.infradead.org>
Date: Thu, 30 Apr 2026 20:13:08 +0530
Message-ID: <ecjwse4j.ritesh.list@gmail.com>
References: <h5ossmwe.ritesh.list@gmail.com> <afNV5wbhsFQJLzxi@casper.infradead.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B6D25180005
X-Rspam-User: 
X-Stat-Signature: ywdpt9i7rb1dfbqm8b3stw4mebks1ojt
X-HE-Tag: 1777561194-782953
X-HE-Meta: U2FsdGVkX1+QeO++qpjUOaOoWEt4Q+Yewq6iyIFKQRo//+R1k3Pq6eZIszGM5Elldd2yJJ/L4GZZANxYZMtowhJYzZEcSH9TXaTRZaVTL4EzP0fkP3WhcjlmQb72bNPp7LDQopF0kAnnaoRQiiwbkxWzMc243+WnPGfOQHvBMpPJ3FUeG4+Ft73k5ovvNCiqr8rX9WUAgZy3j32L3JpiaJ53h877aCKO0l6XSITPhDcOgPINm0DBdlKCvusz/hPACEz00Dqigz+0DfqJsnP5WsiULSyCMSUf1iC0MsqJyBmtmIOKFQr8JlEWT6OsWbbhBnJKg2Pvj8nhVMNkmnAvPlL7f1efalSQN/rj7H2mEcE/qOId0TonWBHJW3niq1m3cpp1P+1Pt/ads3+V1+eMtn7APzE4HsEYWBkrENzt6eCGTsZMrntmIyiCdU8CwcuNicSGwwLk8F8WJiddzRp8ykPHWgBeHVgiP8ZlKXGiE6RRuTkI634zK+N81WCChbaN4ia+DngeeU7D1RSqrHVA+xGYF8fBq4UzVerI6sOTsAVgjP9XXm05K+A53N5FezxAOYrComVJ4rPAqHSP1xc4u7tvQkioGQy2F7Q3CmB68QeJwraAzuie/02rBZzx4PyLJjGTdkLMz1idfFBLJCA8rDXEck26bOB3cYoyBA/bvXgGWSwF1WV4vUVe5xIxNzMdfQ5Q+CwAw+Itk5SnJ1HE9N2VWPF9V+OnjKCUnOnEO6G+S/kNFdLwYebvUNofIB0ggiio63kqcCv43jLCX1LcRvip2T/2VMU8yk41xNNka6v9PdSt9k+iGSUuIhZLdclsJ5lhO1X95VHIKiKnXLnAB3cfiw59gSwNSsFbdAKt1Ii4ck4k9WFNX/b3j9fsqw2oDZgmI4hTH7HHv2DlgAWxwFOXj6a3bx87aCX2jBefRY4mOjEsJtd5XcGEZByq4V6XBE1MGnTPdqKBjoTD2gC
 hCgJDv5d
 EO71iRGsvOFKkZYYVwFE6DpB1KDwKLvwbSN9y+MPXpIGTjbfWJO5sB5YWsNHq0XQwQiQoHr9u3OosDySqkc8a2UXVxu/6SvDxJAfjzVn7rOVutm27fxGOWUoBIkE/mlJhtBvEQU9lFXSfLnLaf0tKssMtDLcgVCI6Bq1cagqdGBbM9tywGhNsE3BPs8jYXyQET5BwGfBGbahIdVWue1n7Z8QBrlv8KncGbVMuBACt9hwRnfFxlr8V8334VwQ7M7BG2oKLQXnDNym55+X0WSsTAdN4FAncJwul7kCGBTQDhmvtGLQadV7p/agfeX3m7MEu+qQgs5JK8OCs7Velec19/7ZhzD5LUKJ49pjd8Mf/uJmVTJ/q7AsXFzKu8cegNPF36KQU8WBqBGVDSHY0xTbeXqrEY7efHPQRWMW+xATWRr6xe9FAD4b9xS2Ui0j0PCkXIUfjIQKEylAsoU+B3HWLE477OpXoU/NeiZtD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matthew Wilcox <willy@infradead.org> writes:

> On Thu, Apr 30, 2026 at 05:03:37PM +0530, Ritesh Harjani (IBM) wrote:
>> Linux already supports memory tiers and there are ongoing discussions around
>> promotion of unmapped page cache pages, which lets kernel do the right thing
>> for userspace page cache pages on a tiered system.
>
> Well, you know my opinion of that idea ...
>

:)

>> So the question is:
>> Do we need a userspace interface for the placement policy of page cache pages on a per file basis?
>
> What do we do if two tasks both "know" the right NUMA placement for the
> inode's data, and they disagree?
>

Yes, that's a fair concern that I too had.

So, the placement policy only takes effect at the first allocation i.e.
once a folio is in the page cache. So in the common case where two tasks
read disjoint ranges of the same file, a per-fd policy might work
cleanly - each task's policy governs the folios it reads and there
shouldn't be any conflict.

However, on the same range, whoever instantiate the folio first wins.
But that problem exist today too, even with set_mempolicy.

>> 1. Is there a need for an interface that allows userspace to do per-fd page
>>    placement and maybe per-fd page migration?
>
> Ideally, no, the kernel should observe the task and get it right.
>
> By the way, you're familiar with how filemap_alloc_folio_noprof()
> works today, right?

Are you pointing towards the recent work of yours here?

16a542e22339 Matthew Wilcox  mm/filemap: Extend __filemap_get_folio() to support NUMA memory poli..  8 months ago
7f3779a3ac3e Matthew Wilcox  mm/filemap: Add NUMA mempolicy support to filemap_alloc_folio()         8 months ago
    mm/filemap: Add NUMA mempolicy support to filemap_alloc_folio()

    Add a mempolicy parameter to filemap_alloc_folio() to enable NUMA-aware
    page cache allocations. This will be used by upcoming changes to
    support NUMA policies in guest-memfd, where guest_memory need to be
    allocated NUMA policy specified by VMM.

    All existing users pass NULL maintaining current behavior.


Yup, that sort of is laying the foundation work for this discussion :)
Although I understand that it was done particularly for guest_memfd only.

Is that what you meant?


> I forget whether cpuset_do_page_mem_spread
> is on or off by default.
>

Should be off then I guess...

cpuset_write_u64()
...
	case FILE_SPREAD_PAGE:
		pr_info_once("cpuset.%s is deprecated\n", cft->name);
		retval = cpuset_update_flag(CS_SPREAD_PAGE, cs, val);
		break;

Is this what you were referring to?


>> Let me know if people think that this discussion qualifies for a BoF discussion at LSFMM?
>> Or do you think it's a bad idea altogether, if that is the case - Then
>> please help me understand, why so?
>> Before starting to jump on the implemention of any of this - I would
>> like to gather feedback on what do others think?
>
> I'm just concerned about what other session i'll have to miss to attend
> this instead ;-)

It's good to know that there is an interest then ;)

-ritesh

