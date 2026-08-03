Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74EF7C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FD8C6B009F; Mon,  3 Aug 2026 09:04:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D5EE6B00A2; Mon,  3 Aug 2026 09:04:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79C816B00A4; Mon,  3 Aug 2026 09:04:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA7D6B009F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:04:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB85480611
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:17:26 +0000 (UTC)
X-FDA: 85059253692.03.55BC8F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id BFE21A0008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:17:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dZI6HV0g;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785745044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=coiuyZR1VmW5G88T8irYDXeM/sT+sxprk8RM8Eu7o+Y=;
	b=CITh7ZTfg/jrQfnXOD2eBSUP9GMOIoP6fxg80vdSCH+5rr87CUSGuaorYzKh0XJXk8JJl5
	pzqP0tvuseQUeoDDyXkQS+9Hy26265uhtHLZJDq8uFC+Hu0zJaVbIOWHCfdU8j1XxQlozP
	VnLXJBckD6CJldu1A2Ww2ket4LW7/vA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dZI6HV0g;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785745044;
	b=dT4ju4lqL7V/AvQGOlnHmsIoNTA4vCQYiYcx/DiayB7WPP/VYtab1sUSL+UlRMJZcBIDpx
	97W3ZjSShgJR2heCkNDfMRpu7vu4B/54m5vUpQhejav+wnEr5ks8k9Pe7pPdncabgokCYS
	b+lGSM237TOHD599zPdf2VFiRY1lXuE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D17CA4170C;
	Mon,  3 Aug 2026 08:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640961F000E9;
	Mon,  3 Aug 2026 08:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785745043;
	bh=coiuyZR1VmW5G88T8irYDXeM/sT+sxprk8RM8Eu7o+Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dZI6HV0g2Yg7FFetdn3P1hVJ3ewoATxX0lbDDztDi38EgnW/HZUixAizvtVvOcT1N
	 0XYqAUJja335FbBgZEej8RV8VxwYK0mG9eRHyK1p/94QKHkRiu4UDDUx5aEpLqofxg
	 t0kdNV1n4nZbsAy0psfbz/75JReTYj2MPY+MSppD2mUt1tF1/XdoiBtJBvdYSuvnEr
	 7StCacmDxqPx4H5JT5bs4NHPDHjlc7TPF87/CYpfk97fBJ5h02ynfLfrfsM6o49hZj
	 T0oEZKDdPL/LpfqPjPgDSacgzrL/fAvfFsVjd3sPq0sGxzvbxneuED9S8zeAZ7WJmU
	 mIF4g1h9D6nHQ==
Message-ID: <e85ee97b-6a3a-482d-b6e1-6a6df9be60f3@kernel.org>
Date: Mon, 3 Aug 2026 10:17:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] tools/mm/page_owner_sort: fix --sort option being
 silently ignored
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260803062056.1518070-1-ye.liu@linux.dev>
 <20260803062056.1518070-2-ye.liu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260803062056.1518070-2-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BFE21A0008
X-Rspamd-Server: rspam01
X-Stat-Signature: yzjqafhpth3we4wybts9n3ykz4zgptqx
X-HE-Tag: 1785745044-602892
X-HE-Meta: U2FsdGVkX1/Vm5Okg/dljeNc3QTFf191/YFVCUIf/l2sB8iVBZvoghPfpn02ee8JTXejugx4i7T7u7Yzb+R7+XcyBpBWj0UOlvJCCdMnhoHLD4WTFKPJBNBp6iVZ5ma96UZ6vKDs3qclZky3LRL0+G0Q7BAYgWuU3sa9vSh6OwoIdOk6NEC3KfeFQLKbZvQf0g84uPsoEf5dU7tZFomkofcrtSMznOVpc12DXaU3FUC0pAt1xQYlTV3P11bmm86LjRDVwW4dE1gZTIGhbRH97PHoM1HHLrkC5eaM+t9RKtUYd4l6z8uS6DfRcCZQ5EyuAJgXB1RC6Fub77myANuwMrsA3f7zpQyIAlmw9/h7dd/vIwtBIKr4JLvOTlJ5SdUr3G4QTIS6O6Qp00OL8kz/DZbcyVcMVKSFzFAzVTWf4xIDAoY0uGYAhpN9M5Zwc9pB1GM9Tt0AH7YGoevU2z0xj8mVQnlr5+dBFAmgqJlDAPGqHy5iJgSy0u8cUreXGTk2bL8nDxx/NVjiRZN3o8IVake7yFlcFR/F7Hm5kqoPpXfI5VlKM43LnQ/d7mfRWOKMS4y3n4EZcGdsWdg7xUPvKBUIsF77SdKUPqWG7eRMQo8y/dq68n4Kn/xfBYvtAWJNgN8y1BEdO6z3bEp+FA78IIJdx2VrGbKrxTOrzCcWu0TNwxPYrndNLqVxKk81rp8mbUUf0XPgK/WAZTHpLM3H51fK5HZIj/hVZJbVXZLDqpU7X9x/DSBRIXIIr3fAC0y+79yQ4Zp+2HXUKvmf4kBj1ygjBB49lYXsSlMtma1iSHi9e6GL5NiqNewYcN5F9N5qsvJW+/n2ubThYfYp9eMLVjM3pWpbAwdLVAuPGSA27pKrqQ2UZpA66WlE7wVXe0Pq0pvizGErrY17S3kKaTE1ksb2SX3BFtll/d2h75mnmyjB5uvrGUNigorF9oJxuJtQNdh718mUrkutE+FtW/Z
 Dkz91q/2
 TF6fDwhgGiq+kHPNa5Z67u/2RrTy96hcqQ0Tu+oFXUau8MTKrZnmVZUdb4wpDf5550Vtpfo/X1DEGaVJhqCmhNQVS/2dcssXP1cFdFLMqEGprwA2NnjgZR2OO4+j7wiJzAM6a3U4d6+iCmcKZozYaDqW9VJj2th8hEgXddTC1aPPT40toVOBs0mtvkUxEP5TjLYNrBQWzA+asV8/CMC9ZloSpzKi1YRRxckhjprDQlQX6wuhc+l+0F0hpZ+pXP7CW7xY/k0Fhruoi1c3ezIXb9QbYpTk8DLMAkl/gM8Hz5v5U7805yg2w1asIvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 08:20, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> When --sort is used without any short option (-a, -m, -p, etc.),
> compare_flag remains COMP_NO_FLAG.  The switch (compare_flag) then
> falls through to the COMP_NUM case and calls set_single_cmp(), which
> unconditionally overwrites the sort conditions that parse_sort_args()
> already configured.  This makes --sort silently ineffective unless a
> short option is also supplied.
> 
> Split COMP_NO_FLAG out of the COMP_NUM fallthrough so that --sort is
> respected when no short option is present.
> 
> Reproduction:
>   # Before fix: ascending order (ignored --sort=-pid)
>   ./page_owner_sort --sort=-pid input.txt output.txt
>   # After fix: descending order as expected
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  tools/mm/page_owner_sort.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
> index 35d3d254941c..3c86c8d0618c 100644
> --- a/tools/mm/page_owner_sort.c
> +++ b/tools/mm/page_owner_sort.c
> @@ -821,6 +821,10 @@ int main(int argc, char **argv)
>  		set_single_cmp(compare_stacktrace, SORT_ASC);
>  		break;
>  	case COMP_NO_FLAG:
> +		if (sc.size > 0)
> +			break;
> +		set_single_cmp(compare_num, SORT_DESC);
> +		break;

Why not a fallthrough; after the check?

-- 
Cheers,

David

