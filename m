Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 760B0606A335
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PPeTuCJW
Received: by kanga.kvack.org (Postfix)
	id 9FE586B05BA; Thu,  5 Nov 2026 05:04:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6A16B05BB; Thu,  5 Nov 2026 05:04:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7716B05BF; Thu,  5 Nov 2026 05:04:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67DE36B05BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:04:10 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 85E6116096C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:04:08 +0000 (UTC)
X-FDA: 85400629776.23.9DBB37D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id D2BEF1A0002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:04:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PPeTuCJW;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793873046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4sAOTQijm0unkHuug1Z8C+1HeeNtpwsDrUWnMkqB5cE=;
	b=IjTSdQn0mZ7HKi6NRw0GrPZBWV+oDkueS5qCRBOTylbblfQuy5EFLao5lBBT26EM1TvjTY
	1ocsSRPZvGHnvKS5++1F5jzEcxeM8Fdb+MCoRf/NlylMjjm8Vnw5Ke+r/np9zy62nvxszS
	7peHJE+lmrx++hA/0aPhiN01Wx8+Cqg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793873046;
	b=crQFQVZCB7AhM+I6pq7/OsWXnQa18cgcWdSuWe+xY0DPZvn2byn5D6NtreLNKZ12tXFjbz
	s64VeyQzmzgRwFxTWiEzJsiHbnTWyK0OtjWquKVbe+DtDialMwNCVwKhZOZ/GlHxRd+8ku
	6MWfyMfGeLJlZ7xm0L/kf6VJjFNvIUI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PPeTuCJW;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70F5360D90;
	Thu,  5 Nov 2026 10:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F641F000C1;
	Thu,  5 Nov 2026 10:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873046;
	bh=4sAOTQijm0unkHuug1Z8C+1HeeNtpwsDrUWnMkqB5cE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PPeTuCJWAkflarn1lLbfkXeQH5EsCZzh76zu/pXKzFV0qNLrDhBw8QqE06mMTRHRo
	 JrqaKJNfFY7/gsK6h6b3b9FKcjZT+YlwLE/NgP+j6rdiLpDelAc+uHd6Kirj9HuHS9
	 6fVjp63JPPJPND6a7fbz2kTI9UW2H4IubtgH1r+NmWpihjoSGHC7FKhBqDx2QDukQ3
	 GFWdGH9dXCuRr30RK60LfnSAga1t4i19RY6AMwXddsbHmZmnQy7wjGJf6xPbXla3H0
	 /CnCdkTVPV00PxMk+PHxR66JPJf86k20NCVwcgBYGNIRnggGZbxvgbtuEG2tCvo7iH
	 /2LABFxL2v/cA==
Message-ID: <eda01b72-c88f-4a75-ac5b-7f849a7a1fa0@kernel.org>
Date: Thu, 5 Nov 2026 11:03:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/ksm: align smart scan skips with the scan
 number
To: Qiliang Yuan <odys.yuan@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20261105-bug-mm-ksm-smart-scan-align-skips-v2-0-8a9780b6844e@gmail.com>
 <20261105-bug-mm-ksm-smart-scan-align-skips-v2-1-8a9780b6844e@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261105-bug-mm-ksm-smart-scan-align-skips-v2-1-8a9780b6844e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8huoognjh9tgbjzxu715a8gk9bptd15j
X-Rspamd-Queue-Id: D2BEF1A0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793873046-564954
X-HE-Meta: U2FsdGVkX19YPwSOjHmJnWQ9mf8ecg7vs9fwATTpPwKUf1/7X2ZjokHbHptWypbHi/wc+OSWRvEYjTIt7a1jU1sYllgdwj9f3JcJNse3r9SCc3JpNxgPgq7PKF0riaNJH8JLzakriLJcicJ2iphn1H/8Ggzg8K/XvQv+3hJT8y53Ll15f4fIBAY3ncoTouBr6MUpG3m5teaF3SK2axFHmnb2qfzIFJzsakEIZc/U4MtAvMRAXi9Z2VakFNS1w+WGXJ6IALYyuhxDdb085Sqy1EpCaR3HrS7rSNZcXR9MkfJJ7maBZcvon62c19pFnaXS9YPAh+S1c5GIasUD0A69PRBsK5gpzCi9soEmxY3uh6i+IGhJjPC5KQjp8f34tfMipWHBprWRDJKDj1C3NJ4G0/aHtdCp6N92UwTUEeJ8vkUkPK1tsW/wjXWmlwhS22lygRcxGafAEgWAEx/wHlVmlKZEiR0evoR+yNG9V7SsRXN4t8kV8iYD1YyidcvEseACyT9Ap1h27ZdHGp5JNLGbcxVRLPkOcFjhdHwEckH31jggOoud1lMwEDaa5LEyGzR5qJ0s216bVPRYeen+hZTLa5zZN/jNPsgbCAQXziWZG+IE5fLXZvSgoCrZPeqaXelaHW/Gcu8SvGnR+M/ydOqcASrSGL+MPoWuxf6YocHvO+tDvFxCzKZ2Vwrdo2QGh1+REr5/KPxy/CewKNJ5qFkJbPSlrsvzDhEDJlYl3ZFrFjz7uvKLl8OtfmYkvrGHsGJs/KCrsZZL3yhg27pGtj/l4W/y1ftLq2fQ5NSe5qcFwi01t/+DrawGqpup7reFCXjH1KE25C0x/hXkEK9WiWabJm07fiTqIY1mpN/WXM8TK3X/Dtb/zkrkHOl3GJ4Ap7qQaaTb7nFiV/YH0rXGgRg0XvsgXtbLI/hBgN/CysqoFxBOV48zx3vliBU2C9tRFaMk0tBTXCM5sGycpXuvWdV
 lmXhsj1X
 QZpbf3e9lIZ/JK6RJNe1xz3z8f6M/dlR+mYr78q5TrvWPACJ1gZpI8ppdZ7+WvLbeLtJYiFQgwKg37F3HsjHqPlST2kO9DlNDVnriELeR52XoybQO0lSO7wPmSRYzeDK4AygkV8lCvtOl8xDXjJ1x8kdusJ250XwjfXv99PVKPQqLOYEJlxWiW+tYQev19TUIr1kmlalsAnucQN0iRG5xor7OFZmEiIL6AwU5dyl81qv+ht72TQuHOx5bKz6/x68PkwfugBx7S//HtVpd82UwS75TdBmWB9LZ0WYqaBEde8I8UulRWSM3HQ/UCQ1TKPUXohMjKNZAWpRcp3lrRB9yAFHVJ++VsYej1wSZDVbXPHpaC38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 10:36, Qiliang Yuan wrote:
> Smart scan skips pages that KSM has failed to de-duplicate for a while.
> Once a page is three scans old, its rmap_item counts down its own number
> of scans to skip, 1, 2, 4 and then 8 as it ages, so an old page is looked
> at every ninth scan.
> 
> The unstable tree is rebuilt on every scan, so two identical pages that
> are not in the stable tree yet can only be merged in a scan that looks
> at both. Each countdown runs from when its own page became mergeable, so
> two pages that became mergeable at different times end up on different
> phases and, once both are old, may never be looked at in the same scan
> again. They then stay unmerged for as long as they live. Making a page
> mergeable, waiting for 0 to 20 full scans before doing the same with an
> identical page, 20 times for each wait, and checking the pair after
> another 64 full scans shows this, on two boots per kernel:
> 
>                                 before            after
>   pairs merged (of 420)         329 / 317         420 / 420
>   64M of unique pages skipped   89.0% / 89.1%     87.5% / 87.5%
>   ksmd CPU time per scan        6.25 / 6.25 ms    6.88 / 7.03 ms
> 
> Pick the skipped scans by the global scan number instead, with periods
> of 2, 4 and 8 scans. The periods being powers of two, every old page is
> looked at on each scan that is a multiple of 8, whatever its age, so any
> two pages meet at least every eighth scan. The longest period goes from
> nine scans to eight, which costs 10-12% more ksmd time on memory that
> never merges.
> 
> Fixes: 5e924ff54d08 ("mm/ksm: add "smart" page scanning mode")
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> ---

Makes sense to me, without looking to closely into the details.

Maybe Stefan can give some input?

-- 
Cheers,

David

