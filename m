Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B333CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 03:14:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC14A6B0088; Wed, 24 Jun 2026 23:14:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E99146B008A; Wed, 24 Jun 2026 23:14:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD70B6B0092; Wed, 24 Jun 2026 23:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B33716B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:14:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3782C14056F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:14:19 +0000 (UTC)
X-FDA: 84916966638.17.3A85D5F
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5165414000C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:14:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kB53I0qc;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782357257;
	b=HHkZtBVcQYQ5Q+hE4ZcM0YwT21eIV9gG3AH7kCHZS5T/EbpwJ08WhmKGottna3I5pAWUM3
	9yW0TLdfmOxfj+qhiCiyqk9vIDsOn9ijlK9cpxE+II+4RtRWIdrSBAi3e6lg/MG9oHcLwl
	zvJnH013kWuFEEcp+nIPCNL912uFcW8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782357257;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0i0e5oKK2OJvLmaL3gLiYy0U7eXjRC1fYmOiYFlxlDA=;
	b=MsEMewAGr03sSA9xo3nv3ZoXZDb/erMpPVvTbEBf1xjDfOf6+lW+Odj+oWv5xq9E641Qtu
	ZVrr4+w20A09ad0PhodVAvmf+6B0ixaUtdIqarXTMeg1jwdoOvL0jI1dEIKYSNwWey0oX+
	gu/UflgNv6EqhVY0jy/xRxeO3SaFi/I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kB53I0qc;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-bed19623d6eso264513066b.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782357256; x=1782962056; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0i0e5oKK2OJvLmaL3gLiYy0U7eXjRC1fYmOiYFlxlDA=;
        b=kB53I0qc73mifbHPHAlHUzcFP4EinesXIH1vlpu1ytemDtoLaxG1ClHrbG5gfliOAK
         eSfBJRTmeOqBnXkEvECGKi0FaRhydR+LLW5pHWzPjyBXA45t42uqs7U6bPpC2JR34npU
         X+fiaW8yogSbueh4yC+2vQStnzbVsuR3nwk0pILpcKfPFcp5Sre8a7AQStPO1C2dipcl
         LHWSCn4wSGJn9awgT5Tx16KU85CO8JJzNI6VWiK+BvDH6l5G53C+IFxVl/Oau0coXVj7
         lzT/0smzJevq95aukPbFlOfmATyctVbWcBBv7z2Rs/6ldfcijl/oxGTqr8FEZRFyT+cN
         pPGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782357256; x=1782962056;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0i0e5oKK2OJvLmaL3gLiYy0U7eXjRC1fYmOiYFlxlDA=;
        b=SMTwVUA5fg5JD2clYIaOdQFwahgtaAzEGpUQz/FkOH5xk4oKBa6x09NT4m2w5LR7Kp
         DQR8mnMyBZ0A6TbYXW1wHF2jyAHbwWAV20xjiuOdF35sVlxY+Kpc3Z0Tnq04hnM7J0iw
         mr5kspYKkaTlyarbFE90h8eIGAYXBY3D7NO+LoXG/BejM3r7fzZGfa1M50RvYrMt8rgp
         jOzHi/Ad6Zy/h4xwhg7+gBOk7eyN7BKmVlrgFb4PWSEvYsTucEWK8FSWFFyQicqR0kWw
         wJGVgAcv6NKLLVhJdwuQbG3lBy5c/uSaXTvkr9V4ZRnFzMvAp6M9sqIENYjY3s/s7N1f
         aH8g==
X-Forwarded-Encrypted: i=1; AHgh+Rqp7MOXuYidrbQVAcJBFyrH4U8TTKUFoiMDS4gK9jhKSGJtPnfpGUX/LyLnLRkuEV7Z8/4b5HAIMQ==@kvack.org
X-Gm-Message-State: AOJu0Yy8DPisCEg4Lm0uZza6A8trduTdXjt9OHZzswiAArhDwwBXVDhx
	v4TF+cs4vrR6Q3t9sEMF/q12G1+LjlIa7nw+tbudmFnFEpuItw/P8P4q
X-Gm-Gg: AfdE7cmC76OuwwE7wwTbVWzYBhJ6XxqiTHLbpzjI+11nbdu0pUxKoG8oVB3jw+VgwdM
	uBEbGH6AcdN481jwKfFTjczDc882+Udi4w2xJQ49/Ew4fB0U4rfcTeOWgpU4tsedBkz3wofewn3
	BblVLiEi3U1Y+jHKCmSAwlc742rmlU4FkG2pNyjDcc/Yca1R8tUPTZdBNRRJtqWh+eUwJbP6Biy
	EKxoXOWd1Z86bbez3zRqb6vHLOJdhlP2/wWvAjWrbn6kRGVVJpjrXZV2J8yzaCOjGTxYjmr82ui
	aTLI4Mv9xyqr9p47wNzoAcIBTR6KWFjE4C7Vbkrx5ecJZ3uz6NHqMwAMtQ+o945klOfOA1Nt1MR
	enisYRAhDhUnxuzAZp3RBbQzGr7HPHsMMH8g+P4QrezJ6qyHa7V4c9qr723NEvTl6n5LSFE1Qag
	kkGua93dARBlGSYKK0aq+t5Q==
X-Received: by 2002:a17:907:969e:b0:c0c:c2c1:63ee with SMTP id a640c23a62f3a-c1205d970dfmr26440866b.15.1782357255516;
        Wed, 24 Jun 2026 20:14:15 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c11fbed6c4esm79584066b.61.2026.06.24.20.14.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Jun 2026 20:14:14 -0700 (PDT)
Date: Thu, 25 Jun 2026 03:14:13 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	izumi.taku@jp.fujitsu.com, linux-mm@kvack.org,
	Yuan Liu <yuan1.liu@intel.com>,
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] mm/mm_init: fix incorrect node_spanned_pages
Message-ID: <20260625031413.shmx6lk5awqfnilx@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260622022403.16375-1-richard.weiyang@gmail.com>
 <ajk_l8cT0mIyhs4r@kernel.org>
 <20260623083507.kg7jmd7ofz3awqmq@master>
 <ajpQR0hX681OryCB@kernel.org>
 <20260623092653.yfahsc7kekuncbcf@master>
 <ajv4KewVYU5YzVea@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajv4KewVYU5YzVea@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5165414000C
X-Rspam-User: 
X-Stat-Signature: o783iygfjcbxum6t3dzhpczeu179g6nw
X-HE-Tag: 1782357257-335263
X-HE-Meta: U2FsdGVkX1/6Gyy8lJDPEnizV4OeKWNRcFhGxa7uOWqabGTV2H669Kh43f0kTB93wb30TaVQhBI/rxvloYhtDTSEkNkXfInviRZZbsLL/HJj1mXMYBs4PpAXRrAs0Pvxlk3aFLfuOls+rPh3BArE1XYcQKQxev7XS42rNx3h5atEaDJAyoDxK34zxH4HIQ1i79troMm0jEqZawqJoC4ko3IzUff/LPUm6MDB00P4sZWMhffY/W+OfX61tKpqPMGVqQDZA4TVB6Eikeokkm+n+SLd3n+d57KscuY+5koV+ZR72yMJ80NX6MFf7XvPhIlF0XgodMvkxGD7JNyiDDnWj/2gqFrIgMcfnGU+Vp1RI9//odnjTEf0keaZSi8G9Hd0jWFbpMbVjufkfSSnoLu4j89c4ab28DskxW7hv7JGm0W9ksXT1sSMVxmw2/gqP2ZujcbwCADnR5G3tQnvryCS1DcL8e9AhKcu3gzN6Fr/hGsvtxrFJdu48rtdDh7eo4auk4w0uSWNp9RjCNTMM3q2QEoNSVr05C67Wm5DuO8elLdMToUwCdsj2sSp2qv6eMBj35GvrEPZ9iS3KcsHSund8MGzPewu9OulmVPIBIvt1HPmdrsbR3O84eWHtW/cD9s1zqx6VjqJUL6nGNSUFRYIcXY75QY6JO9FWIvrxce9SwqijLkT1FhyBSgVm3c0gWp+5GRG9DXNG10pPvdjI2yq69UG1fBap6lwN2Eje9k7dYoPBJCzX7RgvTi4KNKqtvZrTbZ+P9BTqj5YDWUw/cRcpuF9NZdfV3xC4eCCYhjDl7mYOXDaltEGCFfiQ0EY9032VYqBGtQLa9lifuwWROQNzTuQ5hOmlOwjBdqoRJKsctn82d+C78xhWEKFhafY/a9zPmEy02A0VDVgpnPQlsv9hUqFpbSv5QZ92+24egI+aSv+N6Z7RC+ZNV7lLhKaf8aqJNDz3Gzg6yr+EAp4aTC
 92azyxNH
 ikuUvS4gGpH5vNUYFzCmLgPjkEQTI9gJm4EorrKXBhMtInoDJsH6V/mZMj4qB7XBDN1oPv3i5lnM7q4wBsck5lexHnGFwzvTxbGSfYrp5cVnsnPoAQDTzIVZW+CFytKH/MxkkDmHcSTaFKPBjzhDUMgyag4F0f6c0cMhEcj/f24JGLBi6xanJGoGaMVVb1NI9L+g5BA2/541irXSmAaWECCq/3yw9rtqU1FJ+UAbM7ShI0EcnMw3Mu/Q6e0qeffbnwam0Ai0ZDvlPsrIWErMLPp8bZWCVCE2yo+1SiCaOTIn1B/9iyQdPFgkkga4Jjv96ef2T2Qyci/ljzA4x20dhBfaGJzivqoU8nfcmje3H/w9XMukO5NHQMzOpbzX+4szYN/53TXaJamfrMhjueEnjYtr2gAgfe0PsBxnTQHsyIplipU28SxdrNt9WxZTRUk7oo233S/sG5WHPBmwi30SSMiMqlIxf+o9egmIx5T6vOHJ56QoVI2mLrsXhe1ODZKqNYUUqISDVhovkAbOKE71rsFpmx2eUOq8kKq4DoJa3y4Xu5dlt9cDUtqu5NSIrORlAfaHX7ZJc03W2eMZGMBdoQMWOXMxk6FaWoEXmrvUBYWJ/fq7fEQsom88M0Nz1QwDa5NTbWt5EuhrGTLlRE2WvhJx3Z/MGbbXogM4geE53vKsUb7M1WJVoZaecqPNGRDCquE/opOdiaQhRrgypWLPve+h+3nZUmVYkFZiuzxmakBnNUuyyvECjsGDjKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 06:30:49PM +0300, Mike Rapoport wrote:
>On Tue, Jun 23, 2026 at 09:26:53AM +0000, Wei Yang wrote:
>> On Tue, Jun 23, 2026 at 12:22:15PM +0300, Mike Rapoport wrote:
>> >
>> >After I applied your patch, I did some checks to see why
>> >mirrored_kernelcore causes us troubles. I found that unlike other variants
>> >of kernelcore/movablecore settings, mirrored_kernelcore creates zone
>> >overlap for no apparent reason. I did some git archaeology and I didn't
>> >find a justification for making overlapping pages absent in ZONE_NORMAL.
>> >
>> >So I came up with this cleanup:
>> >
>> >https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=kernelcore-mirror
>> >
>> >I'm waiting for the bots to chew on it before positing the patches.
>> > 
>> 
>> Ah, just the same as I do :-).
> 
>I'm going to send my version with your co-developed-by if you don't mind.
> 

My pleasure :-)

>> -- 
>> Wei Yang
>> Help you, Help me
>
>-- 
>Sincerely yours,
>Mike.

-- 
Wei Yang
Help you, Help me

