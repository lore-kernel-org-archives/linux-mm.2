Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17A0BC54F55
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 17:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C069A6B007B; Tue, 28 Jul 2026 13:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B91836B0088; Tue, 28 Jul 2026 13:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A58196B008A; Tue, 28 Jul 2026 13:41:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 699716B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:41:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD3F61C0C18
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 17:41:22 +0000 (UTC)
X-FDA: 85038902004.20.B900C2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1BB44100008
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 17:41:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lQuCOS3d;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785260481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQDHHrPTm8wUA00SAU3tWeSEWOP+J5kB/jxB8HLfcPA=;
	b=qm1szHqIDXg6yyc47cy417uV6v25ujdYhP+yBHR5sc4lOKp5EUKKhg80lEB+nqt3+SM7Qp
	1iv8movayO8n+WhyDQA4Ue+fRqivwCOnLe4vvyWENRqZeQJm/FCuj4gPLVFsd36Mhq45qy
	PFo3f3uqLu21/SOOnyCodhWnWBD6roM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785260481;
	b=z2OT8i1GFxhds8EGXX/KJx+5t8pBwT2Yij88oMXAfqKvd7eE+SlO4Sj/NKyXTl2b9clmsV
	f2EhHvNVEjy2QkgWT1Kui4mBdAydjoqrUXCwpg6gFhz8vVjgSO6l0zmQ24GmigcQ12XVaK
	0l+PNi78Ly3zg2TPdMF3aufAcbS5v4o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lQuCOS3d;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7333E60A58;
	Tue, 28 Jul 2026 17:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FDC1F000E9;
	Tue, 28 Jul 2026 17:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785260480;
	bh=BQDHHrPTm8wUA00SAU3tWeSEWOP+J5kB/jxB8HLfcPA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lQuCOS3d1ws7UGlowjuxi/xIeEVlvuM4bUkrEBOZ6HkXbSiLWY26/U34wGWnYFniJ
	 axYfRytTmC1LQ+BYWNolzK2224KO0LrAZ2rKKXxlY5FbBOsqYN7VsljtLj0FvniKxr
	 LS/rMna4q5if94a2rREaCbeBLCVSl5PX+YLn7+YrtyqHzBi6Kuagxsjh8w7/OvitQD
	 BIZkFRoUeUT9rwEWSTqu54KZUlz8lXSTrSUKXu59nSImUPgXD5pr56/hxYYaM92ynZ
	 lMXpVgbnLfaCJ/pGaL10KWxrIT4yRU/QZixdsZMjzkeNiJnmGkzn4BDUC8TtlIb5nS
	 2VkepP6EHTkaQ==
Message-ID: <365d8e50-5aeb-45e9-97a3-87d0024cdc5f@kernel.org>
Date: Tue, 28 Jul 2026 19:41:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/13] mm/slab: abstract slabobj_ext.ref access
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-6-c29ef0f1f257@kernel.org>
 <amivCT7AaPux-GSK@thinkpad>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <amivCT7AaPux-GSK@thinkpad>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1BB44100008
X-Stat-Signature: 4baqxqqmgf5ex55h9zem1dtmpuo4yxbw
X-Rspam-User: 
X-HE-Tag: 1785260480-792885
X-HE-Meta: U2FsdGVkX1/xhpFgCo2ag0grqhg1CIM4TndytC8foxi56QJY1NzDbwawuzGM8DDlKTpwSRIRwIsbTAtDJ7Vs33l1j+socj8TNLj+m46FbpARrYwxvApkQkPEAGZOtw38EP6KTGSeWdlFNiBJZVsrKBGlCL2WYEq4IFaJQAOaMEJ/wktuEHKH8XogvC912BnxPxRWegFhdXNZU7nw3UXPKrlg7gBxxzVV1e9xgcDMqgCvkklTn6aby/eTxbaj3+1HEJQcR/aG2Z5mHJpRpRSCGmu/bA1rUiH2wHQ223EPfFdK61Zx1fgd0Bk7eSRnOx4ACBR9EQMUCxKnve5+ceBBx8CVq9rhnztf0ppP5p78v3HeBV37LGsnFmDJWUbznRafthgMiRZgOrW5eA1WomeB+k2OQ16apbSqDgU5deVFp9e3xyiwKWx3ub87j+Z73ZFkz5YP/YAETbI01EwkTiYyOFnLsfL/vUGHGXyQFWIRbS+KAq1+UrN9v2gqG1kM/IV2XV9iOD0YSwg1cqMYdHp6fj3o9cYO9U2wzwdq/Rbh9+M+f0kb7Q4QqOdeAQ333xQHjZIfNiIsgm6sGw+UUF2uNvdL2kAmyhSqmYPdH3Easz8ZBEH5za8vy20rRYAQ3Pj4+Myik+POx9LG3adbmBkyX9xzs+A2RpKAI486cTjcrAUpWBsfU75Kq9o41/5uZ3Ni9dD/u1vbEUM1KAZxwfLsV8GMnLKR3JS1oGis9lKyvIFftnhwEPz5rdDP5EDdaqQuiHwkMX6dSD66Y3+T1PNqxsBiYQoGddM6Q8t9nwcUrzynh1x1EhE9Y57v3D73Ab2PZ3BFcaT7CLY8YBJ6bl0UpohlPVNqCPDOnj3XHwp/Mgi4cMREmHkp09oWtfMIpz23yh/uuEya6H+70rFMQCaCrHFsqL0BmI6678x8tKnnfPDodXCJYrE3VLM1C1kjyaHaqAhzbjp/mMt24zjOAxR
 v4k5MLH8
 z5CvpMCX7bHDFPAWVA2vDtMXknhhnwzry2/BJ2eO+PzAobjA9LT15IYkMZd0ui8cm7D0SouYz5Ot91Yp/kBCOycO0iAnK6M9EMVNuK8qruj6IB+PUUIcGjYWkpXVKM28rRdPdm7QDthJlgpkm2swHsbTNjndZKvZTkiuwNspvvE5pbZeB9ThL+vq2L1og5fx7+RJ0dABDCgcUeVtruU8mdwpW+u54eTjchgTCxVGve2KHXs2vGVvrwYiXGKwP3QOUdyfLXOzT5+O/9gbFus6orvXCV9FDm1TuvJa07Jy2EtWnT6jV/Io2lYEmLkffZYC/WznLszgZQyyJjVaLsNWDRaYkyk9gTv2wmj07
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 15:41, Harry Yoo wrote:
> On Mon, Jul 27, 2026 at 02:54:00PM +0200, Vlastimil Babka (SUSE) wrote:
>> In preparation for changes to the structure, abstract access to the ref
>> field with a slab_obj_ext_codetag_ref() function. Rename the field to
>> _ctref to make an unexpected direct access a compile error.
>> 
>> No functional change intended.
>> 
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Reviewed-by: Hao Li <hao.li@linux.dev>
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
> 
> Looks good to me,
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> 
> With a suggestion: it would be nice to have debug warnings
> that trigger when slab_obj_ext_codetag_ref() is compiled but
> not supposed to be called.
> 
> e.g.) for kfence objects, or later in the series when we
> reduce slabobj_ext memory (!slab_obj_ext_has_codetag()) 
> 
> Similarly, it would be nice (later in the series) to have a warning
> in slab_obj_ext_objcg() when slab_needs_objcg() returns false.

OK good idea but we can't do it right now as the helpers are introduced
later.

So for 9/13 mm/slab: introduce slab_obj_ext_has_codetag():

diff --git a/mm/slab.h b/mm/slab.h
index 8f352d9f4d91..fbad99da093c 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -726,6 +726,8 @@ static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
 static inline union codetag_ref *
 slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_ext)
 {
+       VM_WARN_ON_ONCE(!slab_obj_ext_has_codetag());
+
        if (IS_ENABLED(CONFIG_MEMCG))
                obj_ext += 1;
 
... and for objcg we would need to start passing slab pointer to
slab_obj_ext_objcg() and slab_obj_ext_set_objcg(). Hmm...


>>  mm/slab.h | 10 +++++++++-
>>  mm/slub.c | 42 ++++++++++++++++++++++++++++--------------
>>  2 files changed, 37 insertions(+), 15 deletions(-)


