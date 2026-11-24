Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 350BA606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 01:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xJodKaL2
Received: by kanga.kvack.org (Postfix)
	id 2D81D6B05B5; Mon, 23 Nov 2026 20:24:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 288DC6B05B6; Mon, 23 Nov 2026 20:24:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F266B05B7; Mon, 23 Nov 2026 20:24:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB0006B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:24:10 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D3621C422F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:24:10 +0000 (UTC)
X-FDA: 85468266660.19.77A6042
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9C7541C0004
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:24:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xJodKaL2;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795483448;
	b=4+KZkhRCTWphHjJhvcrPhwOhbLp3aoKlTGKO1VDJj4RJ94zC2UHn1ppSVT2S4EzEVR6bo6
	cY3eYNGat8qg3ncHwQ0a/7fq9Mh42tOlRKnVXxKk4HO5diG+hw2n2SQVXS50ueBfZT/7vH
	VyU0OrMvhUD8pauOLiEJALVNDe/oOcc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795483448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0t5pbVANwul/1wsHrhSmkJyfXGa5C6Z5SFFtj9nFfM=;
	b=Spneo7e2Euq/4428RFuY07aGPLHezuuuE/GUAolkNR0TNlCU7de5c2w3Ax1WSB0MdXnEqP
	X9JDN0aLql2MYxf7isS8AxVO6rcNXhfR76W7m/gb1/2FiDH8PncKGb6rLyreGYSM1PHDD0
	9IWg4NUCNugHJhJxya3/rbkgvFKH1DY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xJodKaL2;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B6C1040AB4;
	Tue, 24 Nov 2026 01:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0701F000C6;
	Tue, 24 Nov 2026 01:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795483447;
	bh=W0t5pbVANwul/1wsHrhSmkJyfXGa5C6Z5SFFtj9nFfM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=xJodKaL26ux++MU142EpkwBQYMd759R+F9d5x54S+kLJs3LTewJu5uOO3wmhHmdoq
	 BYBnrGFpOVVJ9Q+RIWl/boIROE6WFw+rCefsVgUWRqT7973fKssc5MhE/ChU6I9IQt
	 cyLqxTJh91A/PzSRxKBDsCEEsiRX4PaBacoEjBXY=
Date: Mon, 23 Nov 2026 17:24:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kaleshsingh@google.com
Cc: kernel-team@android.com, android-mm@google.com, Kees Cook
 <kees@kernel.org>, stable@vger.kernel.org, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry
 Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-mm@kvack.org,
 linux-sparse@vger.kernel.org
Subject: Re: [PATCH] mm: swap: make swap_header badpages a flexible array
Message-Id: <20261123172406.a89eea9c1b5124d5389ce0c6@linux-foundation.org>
In-Reply-To: <20261120061750.2973004-1-kaleshsingh@google.com>
References: <20261120061750.2973004-1-kaleshsingh@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 9C7541C0004
X-Stat-Signature: btycyekinfmfy7wxrm9jpjz3hcr4cbq3
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795483448-839898
X-HE-Meta: U2FsdGVkX1995dhOC03L+wfFL1qWdp65nUvA/EEU2yoUtbpcApOEAohFZ8jtjRSkcoMpKncyXn+TbhTdHJYG4EPTEREl8h9bwJUyIKkcKZumZFZuUuwmS/bpZtiEeBQn2F7CaxwOWa8LeWdpqcgImfzEkDbJZBK0TFusaxyZR7rJ33NM6ZEdGKG74tZ1mOwaY640ed15ZaKxj8UPTD6yF8ml9Gb5pWEVeOZ2wXyils1cccp4sDtTmu2JMYJxX/xqJFYv7jFTgFQgEsyAnjH58Jfot+aFDeKIdufBc1Ytdj+VvYPkvQDSbpGh4/xZc+VQqDzZh3dz0tUab/1N4cIw0PcjHoeVC0Iym0M+PWeo1GRpNrAFG6iQLysx7E12LOxUYJLARnTCx6qJkubG2W7WbDYcjhEG33uyKvfV0q6++ZT95vMuSild6hJqCCVfjjMwyt5KsRd1Ai2ruMedfZBZZT3HlWJge0zyxlGu3IWV2NX1fwa5fLihcVVo67gCFkBVX94dfM+RQ3T691Yh46ONE4MUQQSkD5ec3jcid3SxSUDKx31fKsosb4FGAGpuh95ZsRXacVE4ocNMUqLTaQJk/Uql7EosEvsByl3bQVAndj6Eqh0tKWk8pOw9hvuv1sAgR36bf0U7aO5wBGf53PnP36tBRmeyiCsmkP//plNc+CT/XFXv6mw2BR5wGaAECEZyZeulAUevNhk0wH/awdM60VeMCMGAPt13EgckvwrV1541dULna9+xx0/jAyjij5e5cvrvqIeNkIYkXevJ6woMjz0KSKPAC1O2+atnIRR5e3rM30BB2xi6w1jpgoIk2mFv6tMmM71U8cz0sFcxGQ8OMO7+Yihzzt+rxh1lLM5akEkJJNUh85zKi/+bYfumgVSq2ftb0/3iVbZpddNRMhCRukoysylFLAlbp+hL6ScMnnJhqx5z1KEvpGKsMaQ2Tnkf+Qs96k8HwV9/Ed1Rmex
 Fwk0zmdl
 OmDIwV2IRsS6Po83HPaGVxBORsdmGsU00ZIvc7aPvf3GqgvKWjotvfYtHdyQCjtcqqnUhaLuFv+RfC44HfAmpEBzULZVFw+6TGXfbJojnz93r/x00xNSQFb89wYqb1n/oWAFq1Y3R4WrlvbQ8t5h8dyIR+YNnDKG/f9a7jr2ShLS1dyQ8cdgSPgvbw93+W7R0KZds4kPnCt4kZYvkuJVkZvl4BmyeeAtOk+mq1PhpBawLRdUOuLMPtarDdTDlPu+CBQD6eezwAibNxvQ45zPWt6D4Bee8/SPjDGImWNlQ9HcpIa+OU0oocouSf15XLxepsIQxwasicKDMXPIf2eqCBD/XJ1CF57lWGgpiCPDM8aHokn7WzfkTcclDYJrzQ0mUyi4YrkrevBHTHZjSibpt6gwoPMx6mdi+y4LBwW7jgpznjKilJmrAafY8HapYB1sYOCDGheraU3GvH15wZTHxhracXSsbw//chbRYmjXQwFepDToM2dxmjCkQ3TJBeOJO0Fp6QsrGE+cjtRKY2yP7ZIet7x/W4EnJKpyRYQUBqADLzPtowRoeRAlLPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 06:17:49 +0000 kaleshsingh@google.com wrote:

> From: Kalesh Singh <kaleshsingh@google.com>
> 
> The swap header declares its list of bad pages as a one-element array,
> even though the list can fill the rest of the header page. Since the
> kernel is built with -fstrict-flex-arrays=3, the compiler takes that
> size literally, so with UBSAN bounds checking, swapon() of a swap area
> with two or more bad pages reports an out-of-bounds access:
> 
>   UBSAN: array-index-out-of-bounds in mm/swapfile.c:3674:26
>   index 1 is out of range for type '__u32[1]' (aka 'unsigned int[1]')
> 
> Kernels that trap on UBSAN reports and panic on oops, such as Android
> GKI kernels, crash instead.
> 
> Declare the list as a flexible array. The layout of the swap header
> does not change.

OK.

I worry about these flex_array conversions because there's a trap.

The conversion is safe only if nobody copies swap_header.info using
assignment or memcpy(..., sizeof(info)).  Both would have previously
copied badpages[0], but would omit it after this change because
sizeof(info) shrinks by four bytes.

I couldn't find any such copy operations (didn't expect to) so we're
good.

However it is a trap.  Having a static checker warn about this would be
helpful.  And afaict no checkers we presently have will pick up on this.

(cc sparse peeps)

Can sparse warn when a struct containing a flexible array is copied by
assignment or by memcpy(..., sizeof(struct))?  Both will copy only the
fixed fields, which may silently omit flexibly-allocated array elements.

> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -129,7 +129,7 @@ union swap_header {
>  		unsigned char	sws_uuid[16];
>  		unsigned char	sws_volume[16];
>  		__u32		padding[117];
> -		__u32		badpages[1];
> +		__u32		badpages[];
>  	} info;
>  };

Thanks, tossed onto the mm-unstable pile.

