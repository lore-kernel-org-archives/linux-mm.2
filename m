Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18840EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5543B6B0155; Mon,  2 Mar 2026 16:18:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52BDE6B0158; Mon,  2 Mar 2026 16:18:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D816B015C; Mon,  2 Mar 2026 16:18:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F0966B0155
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:18:03 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF65116034C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:18:02 +0000 (UTC)
X-FDA: 84502385604.18.99CC223
Received: from sender-pp-o92.zoho.in (sender-pp-o92.zoho.in [103.117.158.92])
	by imf22.hostedemail.com (Postfix) with ESMTP id 496E8C0007
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:17:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=p8Y3MiUy;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	dmarc=pass (policy=reject) header.from=zohomail.in;
	spf=pass (imf22.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.92 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772486280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9GtXPwklIzkFSZYLlr687Dlgan7HsKJYHVaIrysMXRk=;
	b=8GcjdVeDZ1QhZsL/ji1sjHvv3dmTCnsTlJQS2RKo8v/fHeBJ/eW/VQSS49JfLpn5JWWlci
	tXWPEW/Im115LvqfhOBKMbq2iXmqDlLPoP++o0xv9AnawxYm+0NH6cm7g1sn2C/nhvK4J0
	t4cWs/MmGD2Mdr7o7pQQEJAQBXRx6ws=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=p8Y3MiUy;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	dmarc=pass (policy=reject) header.from=zohomail.in;
	spf=pass (imf22.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.92 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772486280; a=rsa-sha256;
	cv=pass;
	b=NN+HeGqZRcJD+gmZKcd+KvWhtsrL+gtzr3eOLYPxMi1tV7QMq3a1xY6lCSVN1nx4ockIkE
	6TVuTZntO05Y7nVzSpya+Wlw42Z5cYy4pBr99UgY7mVq1D7/IUspSCbdZ5OaLRPuzZsTeB
	QNH7MT6yJF4VEjCPTyQn+bKrr5Fi3CE=
ARC-Seal: i=1; a=rsa-sha256; t=1772486259; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=AeGsFpR1y3tdweScAUN0raTyYzk6brVW0t0Dh8c/d8uXy7B1PqrrDk3AI5IDocMR9QaCidYRhKmjzd3i0ExMRa1BvZa5ksTDFj2V19kzsq5mtIJ6cBaEsAYBJI+MkzcltQcQgl6wL4XLH16+DysXAtrd2Nk1eIkzCnmDOdy/JR8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1772486259; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=9GtXPwklIzkFSZYLlr687Dlgan7HsKJYHVaIrysMXRk=; 
	b=fm0bEkIL8x4T9EoclSbpbBhqh0FnukMtDeDh26+SIwm+jJd0OzHjdBpJFRCIxyUPHk/2jSBly0SsvRMeeGT1SIDpcLuMnLYYvsLoiy7O+VksJGy+kPPsCR7abzhiBtbXYholJqS9kuBsJ9O3rwhK+msiPYAoPWn340a89Ta8D24=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772486259;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=9GtXPwklIzkFSZYLlr687Dlgan7HsKJYHVaIrysMXRk=;
	b=p8Y3MiUyT7wvrCtUgTjscoGdx915NBuJgybEkku2mPClgPfPk/UJDbEMmwk9lyG2
	mgzXZyS8Xvq8pGTxG8jeBWxOLK/+4Kb1Tgb0kVBC4szft1nOpdA5SNMZgreeMQnmFEK
	p3l57V+P1DdNG27ze3m6Eb4N0qhVkUidNjg6aOhI=
Received: by mx.zoho.in with SMTPS id 17724862585521005.7690663896108;
	Tue, 3 Mar 2026 02:47:38 +0530 (IST)
Message-ID: <6212beb0-3b80-446a-9577-e94889fdc5a5@zohomail.in>
Date: Tue, 3 Mar 2026 02:47:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm/vmalloc: vrealloc() shrink TODO - seeking direction
 before implementing
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org,
 akpm@linux-foundation.org, aliceryhl@google.com
References: <29e454bc-5a46-43b2-80b0-4d8d93e3feae@zohomail.in>
 <aZdBDOPUccXa85O2@pc636> <DGJ3LPUDBDTK.1TK1DXXFNXYPN@kernel.org>
 <7d65b7a0-9bc3-4fb6-b25f-58b0e07c2ad8@zohomail.in> <aaVUbJ8is-9hYeEe@pc636>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <aaVUbJ8is-9hYeEe@pc636>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 496E8C0007
X-Stat-Signature: 7e9xbn4xs5go7f97rpdp5g1xyqqomnnr
X-Rspam-User: 
X-HE-Tag: 1772486279-404117
X-HE-Meta: U2FsdGVkX18tK0qNWc5kg7RUBjO3TKFmPakAPgX/I9kNmeGLqd0EesxgQOU3n2DEYiWRK/akIoA17asBmUi3PegGnZ8iRXQGhJcb69L+56SFFVBhx96zBdUGjVXkiAuMLyRGUAyl2gAIqsLLX4NTb6dxsfwmPxYd16kL4g5J9ktjXlOl/Z53OdtMarwRxEX1mmq6lg0aFpzGgwhdF2yI+10UYrpMR/jO6erlVKBCeRMyRze77DlDsdmhHTElJ7sjGeFL5qHvDW1rw2k2jzeVQ0e1/rXg9wFuzebeedkrRbJmrHWq85vLuxbud65kBmJnAA8PpfMoWYn5RCfm2S9QvIseE4VhF+UOFXkVrXL7wSX1fSZwGl6cERazBu53uvxCcB8z7/qWvex8PzlcrpMU0/btOHnbWjUFrLhm+bKPy7pa3Ci9pNROfI881ciOoNDPA3gT3/51/NfD+v/+Cpt6k4z0rQa2oDxBteArcQ9MHMlytAfhf758Q5B5yv0rEgKtmtRe/cECKreCSFK9f4VSA6oGIKZ6Q1o0qgdPBaxNdYAOr1Yi5WZQ8Vp5Itz8zJLwGj8B6nhfyqbU6fvGOUFcnNtS0FAvS905IwswLfSFyGc2ofTlelDoHwKeGDGO7oiGZKylps1cVouXIx75yDLO3WRY229TlR5ti/APtChYS3Apy7sJcos50Jo4DKSLUGU3KB+1I2qJlRU2aNLwop9uiQeMd3rwfc6ob3PMGAxe5dik8SpjUcz6mkkNj7BHxqS2KB70XPlZ7bqyt7rJn1r9g35eZgTxXp1D0SlBj6Gqo8Jh5nRFC+pu6JSmlhNK/BOhSAwHIvwG/bYHTwDwuGNolvhvRay/YJnZ7N5x4UEHPfpRlCF8BSBOzaW8bKJ+05U37OB+iKqOK758Z/Qvto5XHOe2mK3xySxrfKvN1NAOsA84vDPs4mjaFUDpuORLAhIxsrdrBlRNCClYaKERp/R
 smymQYql
 phRANmUvm9nFblUfy9e5buAkyQly8h2u/swVZJS1/BAwJv1DLaBwUU364Lv89DxyOVoTLZCNK2ukI4/vYlkT292eDdx7zFP13x6KJan7WdqjDfJnkmD9ceMuhOd/Uk3u508IrsRiZPTUV8f14fb4TtPOt1AqLu0n+nucUZdN6npypd3G/wppM0CsWtcwFLTHzbNNmtp033dgzlUjSx4rroqZPoIxTzl+PERSzXD3xZ8VyzvFc/Qtb3aafxLpimnOr5P06jjDc7zEYi3U/hQiiNQVyux2rIQm33t6kiMUXHAlgsUYTFQxkDgNuJUVgUoaW1xlbCLxZ1XrFtFPWNEx8BWqmkj8+ckhBiTjsqK4OB0DynI/OYJK8a7TUcKKMizdTjEHD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/03/26 14:42, Uladzislau Rezki wrote:
> Hello, Shivam!
> 
>> On 19/02/26 22:31, Danilo Krummrich wrote:
>>> (Cc: Alice)
>>>
>>> On Thu Feb 19, 2026 at 5:57 PM CET, Uladzislau Rezki wrote:
>>>> I think we have 0 users of vrealloc(). It was added because of Rust folk
>>>> wanted this.
>>>
>>> We just gained a user with the Rust binder driver.
>> Hi Uladzislau,
>>
>> You mentioned concerns about there being no users and added complexity.
>> The Rust binder driver has a user of kvrealloc for long-lived resizable
>> arrays. I also have a patch series adding shrink_to support for these
>> allocations, which is now in char-misc-testing [1].
>>
>> Given that there's now an active use case, I'd like to go ahead with
>> implementing the vrealloc shrink as described in the RFC- in-place tail
>> page freeing, skipping huge-page allocations. Happy to adjust the
>> approach based on your input.
>>
>> [1]
>> https://lore.kernel.org/all/20260216-binder-shrink-vec-v3-v6-0-ece8e8593e53@zohomail.in/
>>
> Go ahead. Send out a path then we will see what we have.
> 
> --
> Uladzislau Rezki
Cross posting the link to the patch series
https://lore.kernel.org/all/20260302-vmalloc-shrink-v1-0-46deff465b7e@zohomail.in/

