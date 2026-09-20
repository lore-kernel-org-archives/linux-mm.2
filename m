Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D31C982D8
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 14:38:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4846B008A; Sun, 20 Sep 2026 10:38:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785776B008C; Sun, 20 Sep 2026 10:38:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69B1C6B0092; Sun, 20 Sep 2026 10:38:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 719086B008A
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:38:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF5C8A0462
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:38:53 +0000 (UTC)
X-FDA: 85234397346.14.1EFDF48
Received: from outbound.qs.icloud.com (qs-2002c-snip4-11.eps.apple.com [57.103.87.161])
	by imf30.hostedemail.com (Postfix) with ESMTP id D982D80002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:38:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=U7lcF8oj;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf30.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.87.161 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=U7lcF8oj;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf30.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.87.161 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789915131;
	b=Oc1xwj17QzpBcpQX3K3K4lL4Xnd0cwwOfFaOkrGGuvsoMsqKlnkPby31H2iUaiwXGPMkQt
	b5t9Aq85pjNP4dyWRgyh9qP+3inGd0xJtfNebbw4OhMn4rEHOhydGp0bbtU6nZStiOOpJl
	VfKbdEdQ7W8XjtS+JgV7neWdx6YbwaA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789915131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=raqOTO9AIqyOAzGm1P0sVDeq4KzwqUFbcRya30XSdns=;
	b=Ts/ByRZVQc416qUXkywbssYch5otw4y1rWOMR9DzcscGI7Uww/8o5TmqmlxHBaBaWqBPRM
	5BSC6S1QTNkmwY0+S4eIVv4h1VP/hyFJH1mu28PijIdibHZ8CQn15l6+xNcmQ4Nu0oP1Oo
	oqzaq+aRNfqYPPU3M6hjOh3H8uvtz9g=
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-7 (Postfix) with ESMTPS id CBA951801661;
	Sun, 20 Sep 2026 14:38:45 +0000 (UTC)
X-ICL-RepId: 01a0bf41-57c8-7523-aa73-7c26d5ba53af
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQhKB0MGWQReCEsEQwFbEhVdRUkERxtXAlQXXQZSEnIZWhRcGFNFUR9UWFUJCgJRHFYNV0NUBF9QSxsOXwZLWhVVFw4CQh9QH0wWV0NGGBwZWhRcGFNFUR9UWEMZRVZpQQtPHV0ZWxxCZFhXCQoCURxWDVdDVARfUFQRV1ALWQJCD0gKXwdaBkMBSQVDBFIKQg5VAkBNAkIAXApeAlkAVwl5EVABWB5WXloXXlMXH0sAXEVaDlsERxQ=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1789915131; x=1792507131; bh=raqOTO9AIqyOAzGm1P0sVDeq4KzwqUFbcRya30XSdns=; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=U7lcF8ojfNvZkmMm++JxYz2+hV3ZUmQUbV1CZ9XvjWIsv/nw6yyUmR1yeL/TZg5SzJ4/0cGKR7JV17FvDDCBC1LgJQ5T8mGzWb9dk7lk5T+xtBRboGwPTAxo/ERr0y+TG9isAKs2uESw1cHtZNhpXDjT4ReNsDr/dsg0iEgxlydcI7vs6lVRXJOC+xHuZxO6bB7seMTEZWk5W8CPHDDf6xD2ptdWy4bdmDGochtmkvolooAHPCVA08g6i85I5XB3m8ImgF5bXIGHOvVoDtao4gkXAB6mu5USeJz5e9zrNXfVCbsimmIhYudIwD5Iyo1jmFyD5NrNQNGRdxLMJ9v3LA==
Received: from BRUZZHANG-MC1.tencent.com (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-7 (Postfix) with ESMTPSA id 4548B1801665;
	Sun, 20 Sep 2026 14:38:34 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
To: Barry Song <baohua@kernel.org>
Cc: Zhang Peng <zippermonkey@icloud.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Kairui Song <kasong@tencent.com>,
	Zhang Peng <bruzzhang@tencent.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/5] mm/vmscan: introduce folio_activate_locked() helper
Date: Sun, 20 Sep 2026 22:38:15 +0800
Message-ID: <20260920143816.39827-1-zippermonkey@icloud.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAGsJ_4x7W3Tgr_VNY+RLK_pXnFdehGGbjaVH29JsYipXGf7Z9g@mail.gmail.com>
References: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com> <20260720-batch-tlb-flush-v5-1-db943a0d0d6b@icloud.com> <CAGsJ_4x7W3Tgr_VNY+RLK_pXnFdehGGbjaVH29JsYipXGf7Z9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: L66WQfMMSDzz0EPgFzcAF2TcZ7jB_kNU
X-Authority-Info-Out: v=2.4 cv=Ve/6/Vp9 c=1 sm=1 tr=0 ts=6aafeff8
 cx=c_apl:c_pps:t_out a=bsP7O+dXZ5uKcj+dsLqiMw==:117
 a=bsP7O+dXZ5uKcj+dsLqiMw==:17 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=GvQkQWPkAAAA:8 a=v3ZZPjhaAAAA:8 a=Z4Rwk6OoAAAA:8
 a=1XWaLZrsAAAA:8 a=iox4zFpeAAAA:8 a=ufHFDILaAAAA:8 a=JfrnYn6hAAAA:8
 a=37rDS-QxAAAA:8 a=pGLkceISAAAA:8 a=3THdtwnjks2O2M9xHaAA:9 a=QEXdDO2ut3YA:10
 a=HkZW87K1Qel5hWWM3VKY:22 a=WzC6qhA0u3u7Ye7llzcV:22 a=ZmIg1sZ3JBWsdXgziEIF:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=k1Nq6YrhK2t884LQW06G:22 a=J82S1U87d15UFHHUFZS8:22
 a=kKg27zqgtulLWh45kPDF:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIwMDIxMyBTYWx0ZWRfX6MKzHBPz7M7w
 9HAYdkOpIc6od+lKkGgItSCO0BIEftsaA5Ex56jsIqCJVvCf1IptW+YB9ejjGevtOAwGu3ccvJ5
 zlGCHpfWOwRTkf+jUkqXe8Aq3kgGtPmcPgxjlnhswE/U/E0CF2op0kzuHRZiDRebhbg4GfPzcvJ
 LGewZ43xYkTFIDCp4VCECuiyyCmPF+tW9lJfjH9lGSKUx9qtlrm3bVrZgs97/pWibnlqYyOclx8
 MFTD8UHSMtHUX2uYiIcHrCf2OrlseuV2sdh2i/fGSAn1V1iYkmjTWOmAxjVlePi99AAhV//Ilzd
 Gm9GmnuQsRYbEPJoUJknqec80af3pNAh1hefhfAHfAsn7awRAV1ycgl7MjOs1k=
X-Proofpoint-GUID: L66WQfMMSDzz0EPgFzcAF2TcZ7jB_kNU
X-JNJ: AAAAAAABNK4/+tL72JzeBEVIE6yCotX61SAVQQHQGF/oRsTT7+hDj9fFNeueoAvgGq1nTaOHcwx/ogZU1KSkJ1FMjYEiifmDt/nzXPH1FjwWrDLZu3TJ4eUoGtW7yI7dHEYV3jjHSyDyao4MJPSq9uQ4nOXFgjuc5zTHDTKZJ+iUW1uHgZx42wbgSTX1SjDYPoWG/J6w/uxO2pNstFwNIMQdTjI7zdhvTuJKBMLc+Uqn4gNdmeniaVtFihHdmI5cMPV5eO1nnfwYanxa7RPITGcWOZja2v67/GBgxpQMbcwlvgDq26exMht9MmkIEEb4bknq2WJaNQ3R0kX85IRiaA7Y5BdtWbxpigY50V9XB40KD4FJO5vFqZnESAD7IXq8rzzZE7sb37tbIHoT7VsLri4R+1ne8Yo509ljSes7mZvYJXokwF7OW1Z7IUcONBhUy9ZfHww2USbklOY8hqnJLMbErgbXptFHoHhMnE4jdaXTi9e0ZmIv28Pymfwm2PAOkBPXMJOXA1PddztFB9bQEdCnCejZFwbLFFX17iUdP0+E4HJ5VJv1HYij9tqBEq4Hfo6lDMGUaboHRc9KTUEd0/km7xItWH54Q8EhX1qNkWeC8/ksKH7Jsv9Rvc3rosUBJp5/+7jxP0LcELkk6kkUnBrM4sdG9fJcXCMLO4vmDGuMeGLJnMSxEGdi8nnLtdseS5aNo/KKkDMVtssKNZuPyBVWsfjANuinNOjlBqFbRUmguBK0gcb+Hxvc1dnS+195zjbKyPQpihPGhP5/tD/yCwwUvEDRR9q/GWTIKz9pJMTaBXW5Oo2Q4Sp4ReFRJ9We78Fc4XcnW6zyu6DNmXFZbH3jLG+QTktpQMN7CgqgGIAIFt0OESWYPDDrtG9YDlzG7NE8XtO04Bx4H4A90ZLLIsXKp+CzrO6Oc6THoqurM+vMwrPSDCEkAiSQAD5scpAMYno0cu8p+3mO1+Hyy5l1TG0
 m94IwKzw
 k6P86ww8RiH16KtRLY8QaYfo2Db+SxBYCZZDxFNnH7ZhAplgS3fyU6owLisx0mxxk7JPU9+A0cw2G8tCzqubHYIZvqWhm1OUT3lkKnKqwV7PWmRZikvQggaP6wFHxXrVlR0iNML5zsS1IkGPHsV0cu8WDMH8VFSAOwO8B3kk9/uL5Hay+9N1eH+b5rTvzGtJjQGyES02t2vTtMx6HnKRU/fqYwjfMC7LO0urLv+mizquRD2wO/6mebBypYyNLBTMs/yhbKURBV0dZ/OH4014/xK74OQDAeKIwpyMkVu/ahJlFV3cg1aYGzizhkkqDOnn6qXlyji0x2cbZJUxKq1YRtK3uKty8YYZ9DShI9UO1sb809xg6q2jAMxtDQ4y76/mX/4M0T0yoV/cL4vTHOB67MXBEbgcTx796nWX1zeXHZdwn9m6Zrj/oETj3RJ5xbXyQxTk8O8XgwXe8hFQ5gzPeLurDOs82XSXq3PD/uHABgFpnh+JDZzzFevoP8SFFETBOjV9ku5DC1hYDCVXv6Idx2MHwdBkfMsOuIJM=
X-Rspam-User: 
X-Rspamd-Queue-Id: D982D80002
X-Stat-Signature: otuqtbash5n1rd3b78t7gyywj9qbt5rt
X-Rspamd-Server: rspam01
X-HE-Tag: 1789915131-33608
X-HE-Meta: U2FsdGVkX1+PdHWTU4IDNdRYk4YK9aqoeIw/Pt/5MKgSNPyFBOltMJpXzmWVJR9q2AB0GtqXrA/H9gitH8Uzb+yGzdNNV/IKFEDUcaH6NbqWP+6TXThcnAiKdYnVxJHQkzR2OhqKzWA9IoSQty6akUvjqbmbi36V+lXbpWWjxW/xM+hMW+/ZvPPCvZ7VB5jpLvHBzRIapjJCWf5iGZR5nOgie9wmkXItwXkc2+Uf8ye0fWzJAKDJUVSzghkLz67SSWXOepXAheQnMhkWVmmaNFQel+pfHSWTAYT75AXSFlZdgozmBl8Qk4Ck0YE06G/6EpdsRqmCmDl/Una0PtXUuEnu+DX2sU1/qi81q2FogedPCKWnumgOizTSf3R9fDx4BIrK1gLauEbUNoeJnodSMzM5UZlTkrZjyECV4s2X89wMApRxQh2DYD0R7chgY1k3MfqVuXKjoul6K9loUqtzST4VK5HBasS3aoGVE2nRFBwKsglqEe3NVlX7aJa7wMKVvNWNK9RkSLR4DTXKXI8VfTSk/fhAXGQalufSjZr77If6q2Q7eiV41hF1MEfHpOl8AG/GfsuLwmPNQLniPjoHUOrFrLC8yMwpuccx1qnc3Ed6+5N/MUSyytABuuS87hPw2YuYtx2AwwXz5ldOFWt3f5FVxyU9Sc7vh5jlZg6zQaSrRhWlSDC/cwSqYjonKtq41nF0n7lhm4GF3Q8Rmanzyr4Q9GE5BrxSB3LCmbsIEdDiunTvK7fIYvk0hJcTyjuK2DtUudSdYmfzqyemE8PHFnT0HA4Xf4IUe9jcLEqByIRegdhLGY+DPALdOB7t+ZGkzGfB2dxd0R9foDEkSw1AadSuEmxGbgga2f0W+TZBVBxsQeaRs8flNFEn+aJ2nxubqlQvgA3Ot6++UBkVpUCqBNlyaXrIjgREO5I0GgIC1qfo278AOQWmDafEB390if3j3QHwInw20uoaT1NIYWS
 f36gyRKY
 IlFhm1m0f5uPdMe57nhtHDAYhljW0UA80/3+bpcZ4B09GWIlLI/c3cxwivVIgFYMUAJNDQz0Y5fCNpSmCdoLzUpX5CjJ35lIff3OGGe/opnK7zygO5jQvnopYAy3+8Ck75X8G4i15tnN+19ICOJnnwxEGK4Ou1xZ2dSX5u5Y2AK0eC/5Ucn/ydV9W/JK6hRmekv5qBPc/Brby33OWR37bGMXVlhvHwGXop5DBUf4+B3z3aZpYhpQGb1FJPLrrqkTHmIB2BANCvgG1PAOKDaqz4VtCQgQcRBmGoH6lXYm3ExmWPPTS7IonRkJvaTZGZUKJnW57Cp0EsXcyYnK094KhboRHEdnbPLVOLoxIUVHZdMavM+ZR2hG2vbvfeq9KYcpBmIaXDEwzKy7/6/JYNQEQs45dpvoPBR48HjtTqef3ZtKLHXuhE8VJTr8Xmf9PFTe7WnMTnkYx4N5z61q9COScEtBHAlZzSwl29v5Q0q/ImBtEJiD22d5snUqb/qvjZsMteLQU3JTSiWZz2h3B+e6ZAcbx64Yqq6faShQ/I8iq1cSMrQNqPjDvhxeriSoXRloWUcFo3J1PL3V2xUZY6cQ+w6Z4UlyFQJaZQdF/7BT4TNLkS7eMAW0eRAAOjMLQ/oHXEyN8ZJlVxBxKoI9hpk6pkC0b2FmlnR9COBxW5T+i4qXoeoLd9VDJvHx56bfpNz30iAxrhKIS9pSPG4HE9M1XM5AABJYVkc/jTg4x00PSnvzm2iNYUEJzu8AlMgcYZO2IP/LDj1AZV/828V+yLGJ3vs7f9mecFlFVUtHb5np7fCVkhdVGua1FIy4mGJJmeGOwgloxQPi5/Ue87DkA3MEYxKKGfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 4:36 PM Barry Song <baohua@kernel.org> wrote:
>
> Reviewed-by: Barry Song <baohua@kernel.org>

Thanks for the review!

> > + * Prepare a locked folio to be kept active rather than reclaimed.
> > + * Reclaims its swap slot if it will not be swapped, then marks it
>
> I'm not quite sure whether this should be "if". Because, it seems
> to always be true up to this point. BTW, if we really want to use
> "if", shouldn't we use it to check whether swap is full?

You're right, the wording was misleading: the condition that actually
guards folio_free_swap() is the swapcache/swap-full/mlocked test right
below it, not anything about whether the folio "will be swapped".

Rather than try to restate that in prose, I dropped the paragraph and
left a single line, since the code below is already explicit:

	/* Activate an isolated, locked folio and account the activation. */
	static void folio_activate_locked(struct folio *folio,
			struct reclaim_stat *stat)

One thing I should flag, since it is not just a comment change: the
VM_BUG_ON_FOLIO(folio_test_active(folio)) that used to sit at the
activate_locked label is now a VM_WARN_ON_ONCE_FOLIO(), so a caller
that gets this wrong is reported rather than taking the machine down.
Both are CONFIG_DEBUG_VM-only, and no non-debug behaviour changes, but
it is a deliberate change rather than a pure move, and the changelog
now says so.

I kept your Reviewed-by on that basis - please let me know if you'd
rather I dropped it, or if you'd prefer the BUG_ON left alone.

This patch is now part of a smaller cleanup-only series, see my reply
on 5/5.

Thanks
Zhang Peng

From nobody Sun Sep 20 00:00:00 2026
From: Zhang Peng <zippermonkey@icloud.com>
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Kairui Song <kasong@tencent.com>,
	Zhang Peng <bruzzhang@tencent.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/5] mm/vmscan: extract folio_free() from shrink_folio_list()
Date: Sun, 20 Sep 2026 14:14:37 +0800
References: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com>
 <20260720-batch-tlb-flush-v5-2-db943a0d0d6b@icloud.com>
 <CAGsJ_4ykbJKVqEv6uGNKZaQhtV1UxxV-MWt7D1jx6SpdMN+cqA@mail.gmail.com>
In-Reply-To: <CAGsJ_4ykbJKVqEv6uGNKZaQhtV1UxxV-MWt7D1jx6SpdMN+cqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, Aug 14, 2026 at 5:40 AM Barry Song <baohua@kernel.org> wrote:
>
> Could we avoid hiding the activate semantics inside
> folio_try_reclaim_free()? It makes the logic harder to read and
> can be confusing.
>
> Could we pull this out so that the three possible outcomes are
> explicit?
>
> 1. activate
> 2. keep
> 3. free
[...]
> I mean, this is confusing because an activated folio ends up in the
> "keep" path. Can we make the activation semantics explicit at the
> outer level?

Agreed, and thanks - the bool return was the root of it. The helper
now returns exactly the three outcomes you listed, and the caller,
not the helper, decides what to do with each:

	enum folio_reclaim_result {
		FOLIO_RECLAIM_KEEP,
		FOLIO_RECLAIM_ACTIVATE,
		FOLIO_RECLAIM_SUCCESS,
	};

	switch (folio_try_reclaim_free(folio, &free_folios, sc,
				       &nr_reclaimed)) {
	case FOLIO_RECLAIM_ACTIVATE:
		goto activate_locked;
	case FOLIO_RECLAIM_KEEP:
		goto keep_locked;
	case FOLIO_RECLAIM_SUCCESS:
		continue;
	}

So there is no longer a folio_activate_locked() call inside the
helper at all, and an activated folio no longer disappears into the
"keep" path.

The patch has been respun on that basis and posted in a cleanup-only
series, see my reply on 5/5.

Thanks
Zhang Peng

From nobody Sun Sep 20 00:00:00 2026
From: Zhang Peng <zippermonkey@icloud.com>
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Kairui Song <kasong@tencent.com>,
	Zhang Peng <bruzzhang@tencent.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/5] mm/vmscan: extract pageout_one() from shrink_folio_list()
Date: Sun, 20 Sep 2026 14:16:52 +0800
References: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com>
 <20260720-batch-tlb-flush-v5-3-db943a0d0d6b@icloud.com>
 <CAGsJ_4zOfR3Rn5tk_RcOWUDmREO1JyRwXA15Vr3aeUs=+ybMMA@mail.gmail.com>
In-Reply-To: <CAGsJ_4zOfR3Rn5tk_RcOWUDmREO1JyRwXA15Vr3aeUs=+ybMMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, Aug 14, 2026 at 5:49 AM Barry Song <baohua@kernel.org> wrote:
>
> Also, this patch looks basically good, just like the previous one.
> Could we also avoid hiding the activation semantics in the inner
> function? It would be clearer to make the activation semantics
> explicit at the outer level, so readers don't have to dig into a
> deep internal function to realize that a folio may take the
> activation path.
>
> In LRU, we have two distinct possibilities: activate a folio or just
> keep it. This is an important semantic distinction in the LRU logic.
> Hiding the activation decision so deep in an inner function makes
> that semantic much less obvious.

Done, same treatment as 2/5 - the helper reports the decision and the
caller acts on it:

	enum folio_pageout_result {
		FOLIO_PAGEOUT_KEEP_LOCKED,
		FOLIO_PAGEOUT_KEEP_UNLOCKED,
		FOLIO_PAGEOUT_ACTIVATE,
		FOLIO_PAGEOUT_FREE,	/* folio is locked, hand it to
					   folio_try_reclaim_free() */
	};

	switch (folio_try_pageout(folio, sc, &ctx, folio_list)) {
	case FOLIO_PAGEOUT_ACTIVATE:
		goto activate_locked;
	case FOLIO_PAGEOUT_KEEP_LOCKED:
		goto keep_locked;
	case FOLIO_PAGEOUT_KEEP_UNLOCKED:
		goto keep;
	case FOLIO_PAGEOUT_FREE:
		break;	/* folio is locked; try to free it below */
	}

Two things beyond what you asked for, both because pageout() has more
outcomes than the freeing path does:

 - "keep" is split into KEEP_LOCKED and KEEP_UNLOCKED. pageout() can
   return with the folio either still locked or already unlocked, and
   previously the caller had to know which internal branch it came
   from to pick between the keep_locked and keep labels. Now the
   result says so.

 - FOLIO_PAGEOUT_FREE keeps the "and now try to free it" step at the
   outer level too, instead of chaining into folio_try_reclaim_free()
   from inside folio_try_pageout().

This patch is in the cleanup-only series, see my reply on 5/5.

Thanks
Zhang Peng

From nobody Sun Sep 20 00:00:00 2026
From: Zhang Peng <zippermonkey@icloud.com>
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Kairui Song <kasong@tencent.com>,
	Zhang Peng <bruzzhang@tencent.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/5] mm/vmscan: flush TLB for every 31 folios evictions
Date: Sun, 20 Sep 2026 14:19:08 +0800
References: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com>
 <20260720-batch-tlb-flush-v5-5-db943a0d0d6b@icloud.com>
 <CAGsJ_4wrQRGjqavMzWgi2+PrRr1ztf4QRZEb6HKm02OF8nEBUQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4wrQRGjqavMzWgi2+PrRr1ztf4QRZEb6HKm02OF8nEBUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, Aug 14, 2026 at 5:58 AM Barry Song <baohua@kernel.org> wrote:
>
> Yes, I think batching the dirty flush is a great idea. I can clearly
> see that IPIs for dirty flushes (smp_call) on x86 take up a
> significant part of the flame graph when building the kernel in a
> memcg, so I think this is something we should pursue. Could we
> revisit this patch after we clean up the previous ones?

Sounds good, and thanks for confirming the workload - useful to know
the dirty-flush IPIs show up that clearly in a memcg kernel build.

I've split the series accordingly. The four cleanup patches, with the
explicit-outcome rework you asked for in 2/5 and 3/5, are posted on
their own as:

  [PATCH 0/4] mm/vmscan: refactor shrink_folio_list()
  https://lore.kernel.org/all/20260920-vmscan-refactor-v1-0-ec04d71cb761@tencent.com/

No functional change intended there. I'll repost the TLB batching on
top once that has settled.

Thanks
Zhang Peng


