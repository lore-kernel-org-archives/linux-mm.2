Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC80CCD98F6
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 03:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FCE56B0088; Fri, 19 Jun 2026 23:27:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D3BA6B008A; Fri, 19 Jun 2026 23:27:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E96A6B008C; Fri, 19 Jun 2026 23:27:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 348AD6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 23:27:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3249140614
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 03:27:55 +0000 (UTC)
X-FDA: 84898856910.18.F5F7494
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id BD9831A0008
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 03:27:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O4vXqbj4;
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781926073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/1/Mg7emQaBENUuGSJ+5NebjL57uLeYV751FIXQTYs=;
	b=zLv4TD82qDECpZnAKpxTuafD/VKXg7pPuhrX9n1amujviQWOqgxtLEo7u8yKFF+WFf7Gb7
	N9pEWRyeestacT+gSro7+1RSmANd6bn9RjdRBr4xkB1H1kbjiOPRl00dPnaQgoubCQ/lBA
	GB2KpI3hCQXs0cloWkbyhBSZSJRoNDs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O4vXqbj4;
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781926073;
	b=TYeF+iz31wpd1Wodn4y+Jy4AsqC94XuMKYGSm0ZMmuKTDw6E6qxsuXzw4mrhHTdTW/QWhd
	K1XIrQMbgm47SmV9RbUK8S6GmRfQsLUUcsJ6RANbc17efhU12xsAuPuaSHTpp2Yt4QLzot
	D9oChJ+e4ZsvC8SEYrcNtZ1/B6Nf6RQ=
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-441080fd7b9so1911558fac.3
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781926073; x=1782530873; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/1/Mg7emQaBENUuGSJ+5NebjL57uLeYV751FIXQTYs=;
        b=O4vXqbj4Pz0zv4glfhSKL9EAUj1CEFFsE1saWZzZURWfFJ1+dKt9uRLkx0IURrNhJ2
         MnHKpKTRNzwokF7VGdVtKetoOmuCEuH7RVCEPPG672HBhvl8uPFxzP/9lMatQkOtLwdA
         0Njko8yEVQdlKB9v/Yj20NZMLWxZZpKOzRBIUWcAtHVUZD0Tfv2GE8tGstbVUXjPCt0c
         n9Q5rSUUdcRCNMLYVWSv3IebyeJCJ6a673JPpTHgMq02gnN1Zc81KWzrPjORyyuCB+6p
         zzauZoYFhv1ztZQvv5/LlHok7ekKsCBpGQzWRceJVsKcVn+SaDZSC9JG3H4huq04Ha/S
         BpWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781926073; x=1782530873;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p/1/Mg7emQaBENUuGSJ+5NebjL57uLeYV751FIXQTYs=;
        b=HFD/eEHJIX38RvT60yW2Y37U3+TjqYb5bzAp8NmwmHYy840GdbA6Bjafb+YlpYfew7
         OkJ4jUFaACNrZHd0UKMRgHl4JOhUG2eYSyKY2Gc4LxyQyGEuhiZ06GqzxvFLoFFa0ibG
         GBKP53FEZ/7VfXucQGINxLpqcu3avEno681R4tAQI1yNmHnYJse+qrb5JxuEuDpqaIzv
         vApiBFxuqbscbBZCn/b/4w13wNnzFkfilPfWtmvBIcF2DREJfM76sqtwZjKO3VRKYRfR
         cabYeUWlKHGUrRVMeeo2cownELCY9Mpxy++d0m5Eftnx44jSodRKSoEm7ZXihceAbILe
         +P+A==
X-Forwarded-Encrypted: i=1; AFNElJ+m9+hiv1iW3H6FSy7rKDPrvTehOzZiPY5PTpDL70K6kCgE7nXyh3aOPCPdsI5roFeCw5bW7mZXnQ==@kvack.org
X-Gm-Message-State: AOJu0YzrPhnQl8R7ALYHwH1HQSBQ7b6aShEHJkEuzmzCLwk9/itBEn96
	zyDxk1N7tzi3TgKeD8KGcZoHd2mjId6tyqsT+RR9IEsmVMDSrVB861x5
X-Gm-Gg: AfdE7cnsQ8Qsg569np8wX2hu7RWUb96WbmWeXA+c/Qkpm0xvznMXv4+LJhuq77WTz2O
	NUTGhViv3rTHEqhieYpeFJUSkaQnxLdpLYifWUchcIo4axx7P40Cpv3MUXya/0oX5xVJ+MWBwPk
	jl2Qa1bxOBV8Wo9K/gAClOCaHO+OQck76efnisS07034vJRSorPtT/KORUG29j3rIcw6UcISxC0
	+2CZXU+ZY0p8qFCRRxaKh5bXhmYVVGVKnn8Rgzk8ZXvhjNNQHIol1fljJap9wDrJd4LO9yHX8iS
	ogaxDIbUY2Y3DP2VhkBZmBbKmPt6oFxdhclpwRWv/pAXUfUQST+H/VloBwRxrdRXigwzd4JoEl3
	GCsmSWsP1uySXEqDzbTwbdlztFb9hV0BoZTET70Jn8OvzQovAP1aQgI/44wDkkuAYPjCVlFBw/V
	y5MLUgVB6iKOGBbg/LnRFsQnWaSa5loUYb0AVsbtMsuX+6yRzTeM45OqUxeQ5bAb7auhFkihp1J
	DT2NfG6wbyV7g99EA==
X-Received: by 2002:a05:6820:189a:b0:696:573c:9f0b with SMTP id 006d021491bc7-6a0d8da24d7mr4814286eaf.14.1781926072536;
        Fri, 19 Jun 2026 20:27:52 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:73::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4472ecd3de2sm1275554fac.8.2026.06.19.20.27.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2026 20:27:51 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 19 Jun 2026 20:27:50 -0700
Message-Id: <DJDK2NVO8903.19LWKQ3ST3U89@gmail.com>
Cc: "JP Kobryn" <jp.kobryn@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Alexei Starovoitov" <ast@kernel.org>, "bpf" <bpf@vger.kernel.org>,
 "linux-mm" <linux-mm@kvack.org>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/bpf_memcontrol: mark BPF memcg kfuncs static
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Roman Gushchin" <roman.gushchin@linux.dev>
X-Mailer: aerc
References: <20260617202147.78347-1-jp.kobryn@linux.dev>
 <CAADnVQJ=q7hJkt=ekLD_a5KjJ_+icdwgsY61rujjLMKAKByvWw@mail.gmail.com>
 <7ia4cxxosss5.fsf@castle.c.googlers.com>
In-Reply-To: <7ia4cxxosss5.fsf@castle.c.googlers.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BD9831A0008
X-Stat-Signature: r1z5gsb7timduyj7eathdxa36hhse7kx
X-HE-Tag: 1781926073-369297
X-HE-Meta: U2FsdGVkX1+RE1Tum1aw6zZNsahgSOruqKMDsOX+4INvAO4h0jN7C9Y4TJM5qxZRgAx50c4hW+uRwMQfuxHH/Zfgo9lRcGqiom3t0XIEMydqk0maAbDGbUEWO/tJwVHedv2jpSNPpKm8hnEbnf0t0cgwnLPbbb3WudJCq0EWlEsZZOiMLIfdcj76XvSbLsV2XhMMFO/ilwoH79W+Br6x9e5NyNk8tRiCIli30JcbzK8VmMJJlzrx/nGc5alit9PqDxLSZkEw4H5eSF7tVoukvYsuRSJIL4IA3Z1PdPKfmYeVSxsHWbBaHmXTNg5UKxdvj+PGAcLFXlOiiSPtKqexfavtbU0lX+VDagQOG7p5sUnkyPOp8qphcXd/5SlDHhOegptq8Ni7FjQBOjsZC2fhyyytCNvwCwUvEGFAit4kPZmsIegYWXV8y6wXImtb6VJ0uDUOU/Q+YF8KYN4o/gYJi/AgMcna3H7u02ZLfznYB5PgJT7CAtuWttD4Dz0uH5Dk4rz9oeypkrij6RF22f/5zfWauTcj91mYTWkHT3j7tvReAfVnznYzK6dpbt0V7V0x4bh2TsVUOaDq20XC2b+zVC7oRLYgxPS1HcbCFM8fNgEwjUfaZZndVReQ7zXnbd+LaicRuFGZt5pPbs8GLPfrlrJoBlWa2zAuvGhrgDL+oelVPW5b49J3Loj5Yt48C6WLiS2fSGQLggOGyanbnPurUh5rj+CelMUyr9Zc67p7u+2TQDawSJIccy8/Ua/Idqwf+wtrNANeKqO+Nj4d3JYpPzxe5JcD8TAd2M1Dysxmva7pbuSeao7woWoRWOsKUtBaAD5NLcwFf7P7ntLxCCCm85hddJS5+Q26uTTQw7SLeeoucw7XgqQhaCVDs0nzCSho/b1mAJV0jOCNl+8adKEegqAQsdLbdwW/sAgBQx5qv2rOeiKqqOK7I2QojrUQey8WWPVz56ADbhp3kvENl3F
 sTWwlQ9Y
 gvmliRHcezEjvpDR32ggALeZQOK9wOzrLlj9Pr3WQvsYDXxGEW6SPv23twB+R00WPANH8RUiFeTSzbAzS9p1wFVBQfqA2E9LaOCML0pZrJxLdULmcLom2iSCleWzBMFzvMl4jylbuoxPzrQV8NTpzZvv6bcO9AX0wwaLa/HYlvmnDqMg+9Ddccoq+X7q7xAYCvHeNKSCLlk8/mCXLMU5U39qWGQcZMQK9M8ILC65NNtQf6gKONKRy3O+Ruo4/2cyRt7s2kwZ3OycLg0K0GP6gCSH9aCpW5o+0eEemwfEvbSNYkvztxZzz1XMwRklk0ffFI7wvBMClp6JEztPqA3Z0Hhe8mLu/Yn9c4ntXnQwPhi1hbADH2uMKWC09Ws1haGi7HGTTaIkNDtqhMOvBEUZOcwxgnftpad1rEn9XePkuicZyWSry7GB58srXyUKGYnEaKR0PmrcuD2vx2uFsOzneNb9feV4OQ+kV2xcEOMJUqQvfGfTsb1lhObsw5w/GFfy0mUNZvN29QmOTKy6/EpzzPXkBloGOvPfM2fVdh0Xi6fZ8VnhZFIwsPXswVLPfG/M/ZofC9CQrwyUTAuvM84/eqR7Z9Es8UuGVqR2lpWHpts28afs6Rn9CuM0I8J1Dz0Aj7CpcxGd5OkIMXszAkgTGGyKj61wYGo1gxHSH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jun 17, 2026 at 3:31 PM PDT, Roman Gushchin wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
>> On Wed, Jun 17, 2026 at 1:22=E2=80=AFPM JP Kobryn <jp.kobryn@linux.dev> =
wrote:
>>>
>>> The kfuncs in bpf_memcontrol.c are not called by in-kernel C code. They=
 are
>>> only referenced by BPF programs and resolved through BTF.
>>>
>>> Since no external linkage is needed, mark these functions static.
>>>
>>> Fixes: 5904db9891f8 ("mm: introduce BPF kfuncs to deal with memcg point=
ers")
>>> Fixes: 5c7db3239c9f ("mm: introduce bpf_get_root_mem_cgroup() BPF kfunc=
")
>>> Fixes: 99430ab8b804 ("mm: introduce BPF kfuncs to access memcg statisti=
cs and events")
>>> Reported-by: kernel test robot <lkp@intel.com>
>>> Closes: https://lore.kernel.org/oe-kbuild-all/202606150332.Xy4Egd9s-lkp=
@intel.com/
>>> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
>>> ---
>>>  mm/bpf_memcontrol.c | 21 +++++++++++----------
>>>  1 file changed, 11 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>>> index 716df49d7647..eff79bb2c758 100644
>>> --- a/mm/bpf_memcontrol.c
>>> +++ b/mm/bpf_memcontrol.c
>>> @@ -20,7 +20,7 @@ __bpf_kfunc_start_defs();
>>>   *
>>>   * Return: A pointer to the root memory cgroup.
>>>   */
>>> -__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
>>> +__bpf_kfunc static struct mem_cgroup *bpf_get_root_mem_cgroup(void)
>>
>> sashiko disappoints. It couldn't notice that kfuncs should not be static=
.
>> We have few "__bpf_kfunc static" in net/ipv4/
>> that work by sort-of "luck", since their addresses are taken.
>>
>> In general kfuncs cannot be declared static.
>
> It seems like it thought hard on it but failed based on the existing
> code and a bit vague documentation in Documentation/bpf/kfuncs.rst:
>
>   kfunc definitions should also always be annotated with the ``__bpf_kfun=
c``
>   macro. This prevents issues such as the compiler inlining the kfunc if =
it's a
>   static kernel function, or the function ...
>
> So it reads like bpf kfuncs can be static.
>
> This is the reasoning from the logs (a dismissed concern, to be precise):
> {
>       "type": "Dead Code / Linker Error",
>
>       "description": "Marking kfuncs as static could cause the compiler
>       to optimize them away, breaking BPF verifier BTF resolution.",
>
>       "reasoning": "The patch adds `static` to multiple `__bpf_kfunc`
>       annotated functions that are not called anywhere in C
>       code. Normally, a compiler would remove unused static functions or
>       fail to expose them in object files, which could prevent the BTF
>       ID generation logic (`resolve_btfids`) from finding them. However,
>       the `__bpf_kfunc` macro expands to include `__used` and
>       `__retain`, which strictly instructs the compiler and linker to
>       preserve the functions in the object file regardless of
>       usage. Additionally, `resolve_btfids` and `BTF_ID_FLAGS`
>       successfully parse and resolve `STB_LOCAL` static symbols, making
>       this change completely safe and correct.",

Almost, except it's not clear what takes priority for the compiler.
__bpf_kfunc used to have '__used' and it was enough until clang
got too aggressive in LTO mode. So we added '__retain' and so far
it seems to be holding, but sashiko is missing that both of these
attributes don't say anything about _name_ of the function.
'static' keyword means that compiler is free to rename it and
compilers do take advantage of that from time to time,
while __used and __retain don't add 'do-not-rename' restriction
to the compiler.

Also look at it from the other angle.. why anyone would add
'static' when the function is clearly not static to this particular
compilation unit. It will be used outside of it by bpf progs
that are obviuosly not part of this .c file.

Documentation/bpf/kfuncs.rst needs to be updated.

JP,
pls send a patch to update the docs and include few words
to ignore sparse.


