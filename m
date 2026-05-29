Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCA8CCD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 09:39:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5220F6B008A; Fri, 29 May 2026 05:39:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9A76B008C; Fri, 29 May 2026 05:39:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410626B0092; Fri, 29 May 2026 05:39:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 343476B008A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:39:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B01F5140C69
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:39:42 +0000 (UTC)
X-FDA: 84819960204.09.0B61F3C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0655B80009
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:39:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ssrv992d;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780047581; a=rsa-sha256;
	cv=none;
	b=EVWdgLHzo/kgeUHIY6DV+pgbTYQNQaeGI90WPq0EFL6oVxCLodOGUHHvxlq3TmEPcoUHKC
	kqHRiJm+tdo+5ARKrLgIgdDryc876IfjK7XKVSeq44wjCf8lzlzkoEnSTwj4bzhwvvDZxU
	C3N2Lhr9oS3t4Uvde6aTdkNlXTnNn18=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ssrv992d;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780047581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u8Wre9+wiB6TiMY7n9myBvA+vRB1boxonB1dp6LX6CE=;
	b=gGs9kyw5Tc3R6lP3TJFDx0pORGCfR6Y9S5OPMZdodVRDot8+4vjMlA3WQu9O58LYaCYcZV
	Nmh4e3VBypVpNrlqabxq4HA9tBruNnWWbyS/K823LqJTPnFcvytOyz7ARxJYvKGocSwf3o
	eiqXzWalSI6mkulN05eiHfPflxIexyE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D9A960569;
	Fri, 29 May 2026 09:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FB11F00893;
	Fri, 29 May 2026 09:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780047580;
	bh=u8Wre9+wiB6TiMY7n9myBvA+vRB1boxonB1dp6LX6CE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ssrv992dDYFi1TQIFM5NW7S/NJaD3aF+rznql+Wa/f8gHIbtaDrx9LSPVybM+r2Wr
	 5rgolipg/bCJUf3xtdvEEbi757w6BWMNAzpUHYCPyhVTLCQWCOH9ZgkvUNXDTcLYCJ
	 WiuNHAk3eB6iEoiPwpRv7AMyDPtxpKAVy05v/xuRbSPtBeddZK7c4tek4X7Qy/IJOv
	 QKv827gOb8AoLKIaQ2zmojP8ZAPYT1e+l130j7v7/7XDzv8uetun1BytrhEmnSJK0u
	 LyxIfJG9i+o9rODadibmEuAMHk9JdgFkVzbanh3DqfDnhNSUq6m+0cL4dmSJJcuj7l
	 0Q2MCzMOBvZzA==
Message-ID: <2c1b8eff-f613-4407-b5f3-4d8b12d34321@kernel.org>
Date: Fri, 29 May 2026 11:39:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?UmU6IOetlOWkjTog562U5aSNOiBb5aSW6YOo6YKu5Lu2XSBSZTogW1BB?=
 =?UTF-8?Q?TCH=5D_mm/mempool=3A_use_static_key_for_boot-time_debug_enablemen?=
 =?UTF-8?Q?t?=
Content-Language: en-US
To: Usama Arif <usama.arif@linux.dev>,
 "Li,Rongqing(ACG CCN)" <lirongqing@baidu.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <20260527104634.2434-1-lirongqing@baidu.com>
 <20260527130337.983366-1-usama.arif@linux.dev>
 <fcf5585aba18414cbd0ab01935eeb1df@baidu.com>
 <ddb499d5-6821-4fa7-9fec-563bdfbc8cbc@linux.dev>
 <b9d53cb0be024778b09e1bb1ef7d0211@baidu.com>
 <6ca2af4a-90ed-4d7e-9c21-42ebffddc3fe@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <6ca2af4a-90ed-4d7e-9c21-42ebffddc3fe@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0655B80009
X-Rspamd-Server: rspam03
X-Stat-Signature: waus6bguxzgtquhyhftiurrj79i61ne4
X-HE-Tag: 1780047580-80901
X-HE-Meta: U2FsdGVkX18Ajmkvn9cp0D3qRSmNKRhxYVs/i+HsRYXDqAQxxT+33R1MqO/45lSKw931H5kgf1hmQw4SrgmHzlYvDyhKCRGdIp+TKaro/SKQerZZgyHxaL6m3UhN02qNPV9Qe7bLAuA8GsZdg7k2Xj06T9HX6xLhoXH9Yss3SxWC6TIweEvvWdCBESqKRS6vx6PpANdmdZWJg+x85m4goDzce15RKijjdvnU6EMU0lzVfoYm7kz530+hDQiJ4J43KzoSgNqN815cT8MscMPNqXpmV18JPIHiPLA7HpLw5QwA49ePgFCQvHsKg6fNtpYycn/oCmrbb7O3r/uv96cvaqbx09/BAVAndJ3nhXXbhILj6HxLJ9ANvwCOVKSZu/RIzps4EeXlG61LGEQM4eIsdiwm1GDMEAf75Dx+TsufQ8o2U/+vo4cZj1kHIRxa/Ugyi1HC+005ljWgYRBdX0RqamMndGgzQPlGM/SvOk+STpNpfNU1fpLuLVn2LdMmvvhbdnekEetx5Qq73rJjj9GfeLoYwah2A9xQvIxfFrT2sFfdHKgu9zpJO4akJdWGlENmV703/sSOcyK6tjuRBx5hgJcwiRUk6U6VdN3fQgf1hMPhJIYmzLoHGLiH8SUgrDX1bwdazGvPVviT9lTddeVTLI+fQRnzJ+PNE5jBK0ycxxAEgrBtC5od6r/vKImn3AiC0Q9HxPL2g8L4nRs4v8ADkUnBj6IsFYEfk5pMTT0VD4e4SE2D50n4cxauaPuGyXIkwa5xJwQtoJAFR4kPaWaQHgw8rRd1FwSld5yU79lffoOm7HYbh4bN3pmEwj2ahfsRqoYUjLefw/s3xu1St67NY7kF293aYoOjyQzV3vfVn3KbjI875QAAt4VZVNQx0tEGk9nvTrbX6P5xzY/2MPcfU30BombRIxTXbfs5WTFXvqZ5P1SAOqwZKMSVAXK4/B88ocakgIdR7Hs8KD7wz2a
 0X08Buwz
 L4HmJJUO8OHsZzVpc3E0Ccb1iBpdbi8Mn96ZYWHO/97WzdeAvF2PS6D5cvvnydvXa0MGMwzIUZBqEemDLA4kSpGJIK5SaQbBl2w5dGTneGHfPYWbdHPdoqcWYcuJ0ernz825mQE+1BolcXn6+5liZg6VrHpNkWf78CXLDbGo1VgeYrKLvIG0LbRkxGYoIA9tbCPOx6jtB/A1p1z4xFbgUNLO73etdJDakn/ljqn9jMvqxtUPPOG2IjxJU79PX/rypwYYxcaITg8jSD6Xgf7GOk1+GNF542BHH/KjkI9DIJPZoJ+QbEVVGLEkcfkB8PPCCrS6l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 14:59, Usama Arif wrote:
> 
> 
> On 28/05/2026 11:50, Li,Rongqing(ACG CCN) wrote:
>> 
>> 
>>>
>>> On 28/05/2026 04:00, Li,Rongqing(ACG CCN) wrote:
>>>
>>> I think 32 bit ARM doesnt?
>> 
>> You are right, 32-bit ARM doesn't. 
>> 
>> However, the correct architectural approach should be fixing the boot sequence 
>> inside arch/arm/ to match arm64 , powerpc and m68k, rather than compromising core MM 
>> code with temporary boilerplate variables.
>> 
>> I prefer to keep the mempool implementation clean. If ARM32 triggers the 
>> warning, the proper remedy is a follow-up patch to align its setup_arch() 
>> ordering.
>> 
>> What do you think?
>> 
> 
> I think it would be a prerequisite rather than a follow up patch inorder to not
> break 32 bit arm. I will let ARM and slab maintainers decide on this. 

Yeah we shouldn't just knowingly break it.
But I kind of doubt the argument that crucial mempool allocations happen
that early in the boot and we could miss errors in them? They are mostly
storage drivers, AFAICS. So I don't think we need the debugging to be
enabled early.



