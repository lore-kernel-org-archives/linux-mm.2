Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98319C47BE2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 11:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E875C6B0005; Tue,  6 Jan 2026 06:41:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60186B0095; Tue,  6 Jan 2026 06:41:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A7C6B0096; Tue,  6 Jan 2026 06:41:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C651A6B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:41:00 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66A915928A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:41:00 +0000 (UTC)
X-FDA: 84301347480.11.B53F046
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6019DC0003
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:40:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j5aEv2Yc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767699658; a=rsa-sha256;
	cv=none;
	b=W+hmiBDExRIXkNvTsGusHazvFOoJlt/bRgKu+dFBCVTfYRwpfJG8JENb47vd+QHNd8NO71
	lAtB/I8/qEZwgZ4aP1KFmv1zeM1JSFnYdx+Alz71nP5FPobORMS4Kkl4MWwYzGN7bESW16
	ygUwg8N/FDH+rfqWmLlAmFe5C+6pxXo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j5aEv2Yc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767699658;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTjKCxBA5jic+1d6/NF0uCDYNtvMFc4Y1iIxcjcYDhU=;
	b=J0l2mwdeTr6S/yrogsNCez2SDZHClR5/SmNLvedqeFoK/cvGbOWdwOMscS80ZLyxRnkYfF
	wgeIEnU3Bzqw3zxsTRTUKo5rnBjzfL3mXl/YA+AUnDOmXNsXN/vZe4bjP+orfucpLJTJiy
	d13HHpzsGq6euK9uSNXoE4W4xJNGRtQ=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-65063a95558so1215276a12.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 03:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767699657; x=1768304457; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sTjKCxBA5jic+1d6/NF0uCDYNtvMFc4Y1iIxcjcYDhU=;
        b=j5aEv2YcGTT7HuOJKSAnuhgI+DEZSys/BQUkKbRA1tU1vZS2Ngr6TSN8ayNfYEz1Uq
         WBUlIvCpwjh+kGCs7RFFEyshTxDhn8WrjCLbcPgfrsKQuY3dRqyq6T7ZE0a4UoY8KSBR
         XPjXvGWmZDyH/0OJDYwZEbAGuzTbl3Vl4oJGLbhHrQoG7fDoumUkKvLHO3gzzaT3+dK1
         T8SUJinhyQmzOv+8I8LKQbMMXMTo7qZ83Ewbz0DEWbwhzHhxYlADXdeq8pkcsJ03jXVG
         9q7A260vz4cleHSKx06W1xXj8orC/k4e2eTvA1AGjJjYnHj+l3QhqBpkvq24iqSdbn8f
         6gZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767699657; x=1768304457;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sTjKCxBA5jic+1d6/NF0uCDYNtvMFc4Y1iIxcjcYDhU=;
        b=bHIRExm4kK5/lGUNMN6W3UQD+xdJ8zD69CgLjmcXQhpkK/Xg9r9caEJNQheqmDDXpc
         hAX2Mwo5tQ9Qjnja95V0Ad+xVQ3w2UZWiUrpOf8dKPaDHPIIK5K0yf8o6pMzl3PNIPwn
         RJ2BWIeMtRStY+sJ8tajYl/S9HVr+5J/14DT/mauCY7Q43gUfAv+Q3Lvtp1Gr49+kzAn
         TbtCqt7BaG3aEF9aRMwQ9+f7gw6dR3kqA10m6BGPbIlpHsoTeRy/IisPtdBmWCi5n3r5
         AbL4pWxFXcmy7IQypnGjNVNWUJnC7c2R/n5lXPVwYMBtqufObwXMizwdcdaaTKS4bWyF
         yVDA==
X-Forwarded-Encrypted: i=1; AJvYcCURuOYe7XSH8f1sViXEbHVE6VBvAyI7f6+7qW2trKIQIaC8Y99w36zr3vRtrwgqXxyKTtvY0mR2XA==@kvack.org
X-Gm-Message-State: AOJu0Yyc36nB914my0VqCQ4zZIO0RddtRYFaQzJX5KhHVn7kXmPnK+rS
	ey98KFKMn5nqvQgjR9/K3F+YKLeY85/fxYddPiND96qSljj7X4Zv9u8iQfzU2Q==
X-Gm-Gg: AY/fxX6JH98Q7TbdCKipNPfJhWUMJlLgVkfGbO3nBJbeE+BzpDnj3vJDe0VREC02AUW
	4hscBCjd4dTutKEhYDrBoAIKm5cbDWRI/tL8JPcowDSZeuuM9CKE9um9mh98eHmc9o37OfxAeP1
	mi3OhAh/ZQc/6d2S5oz2+/9WlWLFHjeKtelpS6sP9loWOwHtlwGUd/dciJ1vrjwg/mWx+cFgWZE
	x4jk3w7eKkMhLZ7M6gaFjzSgicwAN2MpwqMJJ+tNOWYnrBavcIx20soKU5u3nyQ0fSIy0xBGTwP
	NEiJkEoqVAhQw/C8Wa4l4CSi0zy8lXIAlRNMPWZ8iR0oVoNNtyKFS11dS6W0xoT6Lb7HcmrDL/m
	xbkjD/rdDJybuYOygqIanDKOGrxVUU52aUrQO8G4FpfRn7CVGcuUHQZ4xhibchVixjus7ejLQfy
	hBIWCmjcC8ZA==
X-Google-Smtp-Source: AGHT+IEqE+SrBfYNLCmXf9gTVCdeT51JzW22Cxa+iv6E5lyywdyAM+Vg1cenc3qZy9eZvrQ4txCsFw==
X-Received: by 2002:a05:6402:210c:b0:64b:6007:d8dc with SMTP id 4fb4d7f45d1cf-6507921a6c4mr2412762a12.7.1767699656429;
        Tue, 06 Jan 2026 03:40:56 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf65c07sm1893752a12.23.2026.01.06.03.40.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Jan 2026 03:40:56 -0800 (PST)
Date: Tue, 6 Jan 2026 11:40:55 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-mm@kvack.org, Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [Patch v2] mm/vmstat: remove unused node and zone state helpers
Message-ID: <20260106114055.6gktnv7orxjdusr7@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251225210213.2553-1-richard.weiyang@gmail.com>
 <350310f2-8644-46c7-a29e-c977e76f0285@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <350310f2-8644-46c7-a29e-c977e76f0285@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: 6019DC0003
X-Rspamd-Server: rspam10
X-Stat-Signature: c3tq1eukp4iumzcjk9z9ym71dqn6e4bq
X-HE-Tag: 1767699658-402406
X-HE-Meta: U2FsdGVkX19Hb1lcxeOCbowG/fe2w9YYdNFVqYKWbpFZXrmSEMCFb0Q+jlSxg8EzDJo2vHHebrvNUwfKB0fBft1d4OLda3+bsWwtoIrSwi+cC9yqZ7qINejX1a9s5SimHI4xnwqyRr25+je5guaOJ8V/Ef62Nbb/ByJ9ppmcHJx1mr40mVjvvbwXpzuFerYKM/zTnVxHTanHfoAS/pB/OJMebpUI22EAqqrFabpTjx0EyQrM6BhNMu7suwCNHATdccP5ERws19w3DHhxBM86WTzEB9mSzwNAHLROEDvSXU6d0cQ6lVYY1sCKPnMzP8zXHrPk04E+7sSgMuqnqS8yflDoLvSK7MQBM7QX3DQz7ov9NV6SfqpUwYcJsbTGuC8qjZlhDbdBcfKzRARvxENWxCYZ64krxEeK/aDfJfoMT3N/WqX36Qc8QrP5MbSttcHa92Op5gmdFzSuSTEBOMIfkPwYopAW/k8sFfbmY0X8rWpTqGLNi/FdAwq20jl1H7CqyijvCqHozSDzH1HQVaJDduG1RtPcMZx6FWHA3Wcmeuyhed8K4VmNd0azWb/rF8FK0BbECaVY+L7y77cLGLXpMuvblPZMcLV+HzVXg/bmlhZXPxR01YIkn1tERSRoDrG96nZVdZwEdNYevXO0B8H0m7Tf7EP5AfKcdU229zav0/mHIOccKblGxewnzuz2jCJ+fSP9fAjZ0QQ9qsa15oQBH5IVuyujMzXhla/hibKQbgdMbFPc4EcPJBr2SxSEU8IA/Kl36MX2GDSy/twcIVd3OOYwzu8yi9Vs5yRwM/KF7yUcC0WNPmKqokAq5/2LQ2tRzQVt1dyy3J8dODnRC26R3JX2uWqLPiPbnoZegtE2hGopsaP0O8eHEAGUeIJFSIqTMnz6BYfKH1aCsuc3JGKn8jqZ/z/FBU9ae+DItRezM0YMV5n0SH0l9eqk/LwPo/OW4Rlh/HijhD+fS/4dMDD
 RKnzQaGb
 oSrCFRkfZDdACmPFQ47ew7Nz6vmA3mavL9XEj0yMZQvn3F2T9tE7FtQlKoVVlZ9KfDNmu3dtm3ipELHGdehE+Fzbz1Pehp5Plf+EhlgFypZYE5k7JkHiqL9zzt+qbZz0ACqMkkBdH8OHPniiPGxhKAmmNj5yM8QzhaFlJlTkLPWYE6KGcHKCsetoBKc2SJqy6oDHiJuw3MdCAc9xD/6X6NVWDZG9UyEFhPFy/CDtcZi/+SoY6uqtFQEtS2xF6vVh17rjAXoI/q568heRoUxDXmaNf3Wgd7qA9TYmTEmybNwwVz06C+nwJ2Ao3SFhmKtJIWnSH6W7qOmDTDPrhm8NkzcwvJZm+fkdlrdIUdGqJuBFSEg/u8ku418fToGKbBlFZq6bS+lmPHl/Hk+MEpvCNo0KsEsQZMub0Cz0Bl1iosh38FADpzom5u8GIZJ4oy9jS0KltSDWxgtByJrPVb2x3VwqowRh8D9CelhaytUn8+kZxQn4ClBW+EXV4+5F13cQCTU6Eh55UzH34SmtWNHZRvbvydpBZ3HMvgZ1qyc6+SgqMj0kHVkSgiU1mOE3YTmODRwInnmwTIAvZpy4i/uiE+dT+StW412jnqAiFJZ/REoMDhVM4MKld+j/vOzFiwFmTuSVpCtR2klQxCQwhvVkYrWTrB5hi6dTZyobBkfO5A2KaSwSRSNbwZ5NER37MfZRVpany6DoyHCdGXoBUVFdhZtt29GN8JbedKqAVyGnvI/qgCFfu33JUteMaCRhCdYXWq6fjd6Q+v3I7NC1rB5L0H0vJ5X4F0zD3gw3A1uT4xsJYyxBuUnecBI9sKo+n7A8cIVoayKTc6PNwUJSNjMYJikZvDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 04:23:23PM +0100, David Hildenbrand (Red Hat) wrote:
>On 12/25/25 22:02, Wei Yang wrote:
>> Several helper functions for managing node and zone states have become
>> obsolete and no longer have any callers within the kernel.
>> 
>>    inc_node_state()
>>    inc_zone_state()
>>    dec_zone_state()
>> 
>> This commit removes the dead code.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>> ---
>
>Note: It's good practice to describe below the "--" what changed between v1
>and v2, and to not drop RBs/Acks for minor stuff.
>

Got it, thanks.

>Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>
>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

