Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC4C1099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:58:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA6486B0119; Fri, 20 Mar 2026 14:58:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E65EB6B011C; Fri, 20 Mar 2026 14:58:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7B876B011E; Fri, 20 Mar 2026 14:58:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C60216B0119
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:58:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 772C2160358
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:58:16 +0000 (UTC)
X-FDA: 84567351792.24.C468B43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C09CB80003
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:58:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=umTHJqmO;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774033094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JipdzKui5zYpXBb0yoWNua5GvOzwF2m3pP3MDhjP8po=;
	b=JfWDr47CKF7njIkiydYXZqOYu68zVW9zMHVGlY6lft0UV/Bs1qADT2KwMs/qduWlQGKfcV
	QWkvsIgP4H1C94Tep1/xXCnAUoT6QDE2MIFhzsNdDoV++mVX78TynJNweMXwmV8xVIm64Z
	duYWwRn4eRx+O+qQz0VBrhynBZdrcS4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=umTHJqmO;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774033094; a=rsa-sha256;
	cv=none;
	b=n06oXWntGwRVL79oC7wWY1Yh87YofCc6mSxboVH7oTfdU/lue7KWJBXRSogrX6T41rdQgG
	ktpnkxUMNB3ikKsIDi/SxBozCB/3DvXuFUU+9oe924LvrGn5AnYzGTGG7t777QRM8Oxyvs
	BbVb7j1tj2jy0p6s0JiufwWNfDGBo+A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4205C6014C;
	Fri, 20 Mar 2026 18:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD023C2BC87;
	Fri, 20 Mar 2026 18:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774033093;
	bh=112L6+1HQkp7RU6SoFW4SCnLVUouDEUQ8DohNJdWZnM=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=umTHJqmOXzuqRvcnq49/eTrH3uEqKQl0FoPkF59JOVazrjJ/vBLoCJe+4MudQXyHx
	 IGZ1vIyiFX3V2wxWWMwCVIDAMEOI2g8PfW+knsd+MNYjzwBDdlJmI2RHnfhUReMbqY
	 AsIJgW8UBuhD9EICaSbT4uJk/mbjGzA2vXWk/s7Tarvw+TNg9oArzsJkCG7CgqdsN2
	 e+g2ExpFCL/NWu47hEGiQJQXqIZPRaTODtG29BDJxEp5NzmvjLijkkVFjjntZi6b8l
	 d7rEpArMPDTiD6lOrcyUyVoOYSS0wQWP9gF1h8WCDAPpgzXDMkTFY30waezYVBSp/5
	 qjU2UeXZwwNaQ==
Message-ID: <1a05e4c5-01b4-4614-bcc5-43e142fe4b9f@kernel.org>
Date: Fri, 20 Mar 2026 19:58:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/14] mm/sparse: remove CONFIG_MEMORY_HOTPLUG-specific
 usemap allocation handling
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-10-david@kernel.org>
 <f23aa64a-d78f-4c57-a08b-5c589889b7fc@lucifer.local>
 <306f0fd2-cba1-4f48-af05-248be2bc9506@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <306f0fd2-cba1-4f48-af05-248be2bc9506@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C09CB80003
X-Stat-Signature: dmapepyfxx6faqjptx7kh4oc1ff7zpea
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774033094-796968
X-HE-Meta: U2FsdGVkX18IP9ciptWrclODlJntak4eGUO4SFuNr2Xz9cDH8otAM5jfiAzS5nb5h+EGsSo9UHW2AgWNkMASwg7M9T5+tgDerAqHYFrIQHWLr0xx134OtpgRWjRVFsg/mjt762LeExypmV3Y17IGWXRDv+hRy0TpY9egcOa9EljbhLvtLxZ7koAtpsOwUk7OU0uwpLaSj6ooDarLHQhQmfAtNzoOchsy/BeAJJ15+jKschFCQUGcZZiBGe0rKgNKSbCUEeZWI/nd62CpcfsXv/KPLCZGkFm9USzkj4hcosj4jhEUDSxCvW1B4/VV3yHDC9ZZoAH2bYfInO+Kc57wUpdU/We/bKdwFJ5ouhe5FJt90Zi/yDjwg28RHGjhf785yhLMgnaErXXQXnu0qRpoKUxti+TSXA67atHd9VngXmEXUof12fBXN9wHBb0Z6ZYmcJDonQM6nKfHd3DeLiIhFz1zQYKbwt3M8Uc5p/Hpu1HXOZwhrb/xTYXrEWCpGOUJ+tNUXMMQH2cCuvOsOxM1AxtWpPo8/Q8p6q27DXd/6dAx4tlMoVxvwXXQEsXx9puxyZkf4AzJeOQTFDz6sEqElMuxd1/ZzPE+XZEKvuBc/+guRJrYotk8ovGgegr4qihee1q2ZiW/yb5/WVSXzlN50k4Z1Ts2lTTjSPd39yLPhNNl0LrV0EzdQ5v0r95vxOSXm/Z6beEQyTyXx3C010EmPEc9iQwzpXR6jsqFUkdxPkiWGcwb50eFkaW/PCLK+P2gEWaAS62KyD1xocBDao2YjKyKZsxUFvS1otoEvYNZvxJT5cHGIHHeYmLzYLo/PLVlXTPsMRXvnfHmuGvEfioHtxO5Oo7WC6u62q2f7Iobt8t9++Amw8yyLPXef8p1QAAJ2EPby0sej0WHk3xw5Pes5yJboztUwxeKK7V1VdGBF/XF/MSuyUMjmHSY0rXaiH3TpMA0PdURyVERpTya3bJ
 fBRb6fHT
 G/DFc3sMRR54Lzr0azsXloUl/Fz+1QUEv6WQpbg4Oe1O9f/bJ8OFA6iSI9r29DzWMUZs6M6TDRt1WsKE12+cV0SNcbpMfFf7nQR9+Tp+5bAguva321P7rHoJBwyfQlozeIdt3hrwC1subx//SJTfjVlLoWch9XBLJVwayvG4RABACfZlCDh8MoVuuwlqtz7SOQE+L56I9zcrnqDmCXYys61qglCtU6nrNxz2yGNNwku3oZrRryU5a28QC8rPtzIrG3KppI0zaDl1u0yC1wKEmmIlAyfW5iBFwYxSKCWmpwQBbkUnLxU8ZKdRbtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> Anyway I'm also confused by 'given we don't free the pgdat any more', but the
>> comment says a 'pgdat can prevent a section being removed' rather than anything
>> about it being removed?
> 
> Well, if a pgdat resides in some memory section, given that it is
> unmovable turns the whole memory section unremovable -> hotunplug fails.
> 
> Assuming you could free the pgdat when the node goes offlining, you
> would turn that memory section removable.
> 
> And I think that commit somehow assumed that the last memory section
> could be removed if all it contains is the corresponding pgdat (which
> was never the case).

I decided to just drop that whole comment block completely.

-- 
Cheers,

David

