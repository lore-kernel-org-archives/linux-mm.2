Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C665BCAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 16:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16B208E000C; Tue, 23 Sep 2025 12:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143588E0001; Tue, 23 Sep 2025 12:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0590F8E000C; Tue, 23 Sep 2025 12:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6F4B8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 12:36:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 89125871EB
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:36:32 +0000 (UTC)
X-FDA: 83921068224.10.49AA356
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 37CC0C0003
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:36:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eBas2jFo;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758645390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j1z548Ruu5C8drIMZuEZ2fOZuShe7ZDidjw1pc4+vVY=;
	b=wc8gz3h3O0267JzfhM+yunI4D+X8zy0hKxTVdHIIPEoEEqUqezYLgtrwoQIgcwhgd1DWkn
	WAvFdIKh5izXT642BuAEcArkUL0F/ZHcFWYkw+eRzC990ENeH4capene3V2CpsCDeJNo0g
	TbEODiTFT2U5HL6MHX0EOVZV/yjgujo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eBas2jFo;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758645390; a=rsa-sha256;
	cv=none;
	b=PkYgftVLP5eAXlCWYU8MIEM9lFi835UuhfvnNuCmC3lmAArwvS76drOwsa8m0f9PJ2t/HF
	7/GYPoXGxX19/EhxRFPu6ZjPHmz+L6x/1yg5puW2cIiZJxXXNo18oM+tlh73yvILKtuqQR
	HD1CKoQ+gVLwOmQgacxlNPlxeAMO/qc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758645389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=j1z548Ruu5C8drIMZuEZ2fOZuShe7ZDidjw1pc4+vVY=;
	b=eBas2jFogazCR646audXjI8CrQ6Xutnq01+1/06+1hekgC83zAG2y7Nepxy97BT1j2M+8h
	XL+H+sQPG2RwqosHEb13eS06uV13z+R7lMElGk/K8v57CHrOLZpcTWMY49/OzOoXaI4ytg
	6sXAPtINk9AobaMdnWwxf+DAHU4WS+g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-u-PJjsAwOiS0RZ9KLKiBdQ-1; Tue, 23 Sep 2025 12:36:28 -0400
X-MC-Unique: u-PJjsAwOiS0RZ9KLKiBdQ-1
X-Mimecast-MFC-AGG-ID: u-PJjsAwOiS0RZ9KLKiBdQ_1758645387
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3efa77de998so2699872f8f.0
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:36:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758645387; x=1759250187;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j1z548Ruu5C8drIMZuEZ2fOZuShe7ZDidjw1pc4+vVY=;
        b=IStIoYd/wu645/ZqKpHOb9pbU+7RvW2LtX0kvc9HPkUfw+mrxSgvWHei98ndGAvdvh
         uZxSgoAJVV5GRaqcidTfR/5pXkjMY6N3XrEh1uxQnWJtEadCyHhGzknMKEeda9oh18/m
         BaE8s+USBtczE1GYAVnE2VwjhcS88bxAqEJhruxuC/mFkSY5OVa3szbHyHzbX3Iw/zdi
         AhfKYiMf5vVzEP6JHRX1W2W6PzaAtChWxPfGzPAedhpGFC0L6P5/TvxrNccYFIKLEPk9
         yc7jIDM+a5CcTTH1I+TPV65WVNwJz0tKYIR6hbgeBWvh2KNk4QRZGeUniyQE7VLKFkr7
         +sKg==
X-Gm-Message-State: AOJu0YyWBLWIEfzan+PPNQ8GW2ztTbreTOEGk83nQDwJ4PnfaYfLy5wG
	eq2Sr4rQaI6ZdeG12wk8qatLOtqvHLNZSGtbGBro09/YpLo78ifUYNvdvJuDsS/C6dEVR4+f+JC
	m/QCcs2+amF8DELy4rljr0EvoEq7iRzon86AahM80K+/p9e8ctJ9b
X-Gm-Gg: ASbGnct/AKSOpRV6SLVO5CREWM/MBlwY0e/c5e07i+wviXd8D8sPGNQOYwU5FxUv07H
	lcsys5BVNc8wZ3VX4/qXmI1KfeLZtKSaGmC/eaZiIs7ryhNEx3CGGhhBSzB27TXkQ4Rj/DXCXoi
	29e/ywuDSkugQTDUqp/H8GOF6R7fQjVIDY4mpofcmNbsKUGrOmnW/l+mOELgLtiXp/0xQn+X+vl
	I42nVL1Q6O1j7Go4aMbJMWLpnDWLis9u+GlGhOWkJJr5dHUq17pY2WmNS5BuE21fmTmHnvFmguo
	+VqQE25qt5wTEybRtAEWHWkuMyFV8SVgERSqsMTPYL1jesnIeR8UGT949xeAQ/Y0/0I3qnV6CkB
	P/laAdxP889vAqhZ7rgkVmkE10wqzSYduAby5Dcw0bgyN7DkERVl70xEGu1AOLuhCPw==
X-Received: by 2002:a05:6000:268a:b0:3fe:4fa2:8cdc with SMTP id ffacd0b85a97d-405ccae17b1mr2824033f8f.60.1758645386939;
        Tue, 23 Sep 2025 09:36:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF/5SOl8dE5E+3lMWMQhDRONYFN2qEs830iz//BrBpUgJk0MgDf0ttwj0Ui5EuDYcU3ZrgTwA==
X-Received: by 2002:a05:6000:268a:b0:3fe:4fa2:8cdc with SMTP id ffacd0b85a97d-405ccae17b1mr2824009f8f.60.1758645386493;
        Tue, 23 Sep 2025 09:36:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:700:c9db:579f:8b2b:717c? (p200300d82f4f0700c9db579f8b2b717c.dip0.t-ipconnect.de. [2003:d8:2f4f:700:c9db:579f:8b2b:717c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee07407fa3sm24567191f8f.21.2025.09.23.09.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 09:36:26 -0700 (PDT)
Message-ID: <ef76bea8-b212-4673-ab3e-9fb5adab660f@redhat.com>
Date: Tue, 23 Sep 2025 18:36:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/khugepaged: use start_addr/addr for better reading
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20250922140938.27343-1-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250922140938.27343-1-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OOgE9TVR6ebSmt8mR0eom_Cf7oJyXUFB1bMOJRhLRKo_1758645387
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 37CC0C0003
X-Stat-Signature: kbh8osp6z5zdf1opdtimih1isc3ceesk
X-HE-Tag: 1758645390-133141
X-HE-Meta: U2FsdGVkX1+06bQweB7etcHCMdPmKGo/its+laRmEVSzNwHySmMOimZcU1xWlCUXrUr8Pjn2xka870pM/lcU7pwgdY9xTu54ayjSmBX348o+MVDqyMGreReRCSymJN+qAymu7fwu7aRkHrv31tTPHAtSYotWldECBWZ2pq/aDTp39vYf213HT/3vYZuMpEdtRq0L9eOpoS7tFlxb8h9D87GQ1vhVhVpWjZN+K0m1+xDC2RKC+dA5/4x250wpY6hpRsiJVPyZCJt5KII14NGdOctOWot48vQs4aJtwlBHrOUc2l1XX8q5i1pjCJjTEi6ekNTlaLkwtocweBO02OyYGw6zjqILSnc3pmJOGvCRR2JpcnK54d9KIuA8DatuNpG9nxfhvTDI429bDv80nz7KW5qLVL7JNSEK0CX5IACijv5wQHYgY/SHPYzHFnuU4DV+cmuvK4sRS63lWCsKpV7qKhSV0VD35B1PvWhtUeeL41jKEW1D1Q9Vnja8F+DXmCcMznXmjBAdongh6PT6l/YCj//Y3NNiYJYjNHMny9Kxj3mNmlgHJdTZiKgZLXPqPiYYf/fNTMyHH0oxs5K1G+16iB9+ufFkTO1k0zvrn7f0C5aaodwD7D3ydpAwnRWXc5vB2btifllL4lex+k+8B1DmGySseALGR8XEC/wPKSJTq0vycX8eejkZUlNSKNwMJxpQwTJv1/YvEJso6iyxxxPkTg7yZjHR7jw+6hP2WeIqtt3mB1NzLmYQ4NeBHdozg7J/EP5kVmVMBUOsdKIOB2t4BxdOSmu5N+WWhpriMwSFr8FRuScaZH98nwWKEibKud1Z9LrDDIT6hmalzhBj3Bo3Gm1zEcY6czRaMSROTZ/EYe14GPmE9U2osWwR/U7JaxaCSNh2qTxHvRWL0aoa9nvUXRR825JpzEcX6/Nk5BVbansRij//2HXodM4DStYksb8fs2MDAnTXzCO6fyPDQ6m
 /dtD19sC
 J0G4lJBKrlMJNBh/c8iFagEVeE7GKb+DXk+eZyPKiqu8CfKIOEvP/r8tjLVk/SnKqC7lztXPIgto8xUXYsOl3v1b3cTLL06MuRuODxKhyKhahoP0QyGjfeHQMCu9TD/oz1sGu1ThsPEKzpJZujSwPLECTNHjYDgMNVKM5GbVf9zi7Mhe9jt9BiuBt4nrGqqBTF4uyi9phZyCPcD59rwjd4DEzBixL0hll1YlrhT05121Q/LWOmEgqwz9dyseDChR/x3yRm6ImMLpyQgIRqwb4HD+GohMy7mc/tlgeeSsFY9Wf2enQ3pqrDQHAMbgzhEQczmx+y7sAELWCBWyLOJVPISXGMKoaZ9mPszqTQbxa7Wp0/8OAkz2Wlm+XySWb16auIEwoqFd3xDyuq0JxtQWVUDoXLjaJh1YnDWK/8Wt7GAJAhFaB2M3uY6JN8fcyB0X19tkOMXakI59TcwN8cGjy/l4gGpXVEg3dTp4I1mJXgvOfpXqreDQoTYqtwm3yVFTO0bGJJQBWhK2tMUfLS3+vsgM177jLmJk4wEvXN3nFSnpeMOQrQ0uTt7dAig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.09.25 16:09, Wei Yang wrote:
> When collapse a pmd, there are two address in use:
> 
>    * address points to the start of pmd
>    * address points to each individual page
> 
> Current naming is not easy to distinguish these two and error prone.
> 
> Considering the plan to collapse mTHP, name the first one to start_addr
> and second one to addr for better reading and consistency.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> 
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


